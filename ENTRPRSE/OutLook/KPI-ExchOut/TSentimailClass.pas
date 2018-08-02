unit TSentimailClass;

{* COMMENTS IN CAPITALS HIGHLIGHT CODE WHICH WOULD USUALLY NEED TO BE ALTERED TO SUIT EACH PLUG-IN *}

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, IRISEnterpriseKPI_TLB, StdVcl, IKPIHost_TLB, GmXML, Windows, Forms, TOutlookControlClass, Contnrs,
  Sentimail_TLB;

type
  TSentimailMessages = class(TOutlookControl)
  private
    FExclusiveOp: WordBool;
{* PLUG-IN CONFIGURATION *}      // from the plugin's idp file [Config] section

{*  FIELDS SPECIFIC TO THIS PLUG-IN *}

  public
    function  Configure(HostHandle: Integer): WordBool; override;
    function  DrillDown(HostHandle: integer; MessageHandle: Integer; const UniqueID: WideString): WordBool; override;
    function  Get_dlpColumns: WideString; override;
    function  Get_dpCaption: WideString; override;
    function  Get_dpConfiguration: WideString; override;
    function  Get_dpDisplayType: EnumDataPlugInDisplayType; override;
    function  Get_dpPluginID: WideString; override;
//    function  Get_dpStatus: EnumDataPlugInStatus; override;
    function  Get_dpSupportsConfiguration: WordBool; override;
    function  Get_dpSupportsDrillDown: WordBool; override;
    function  GetData: WideString; override;
    procedure Initialize; override;
    procedure Set_dpConfiguration(const Value: WideString); override;
  end;

implementation

uses Classes, ComServ, Dialogs, IniFiles, Math, SysUtils, Enterprise01_TLB,
     Controls, CTKUtil, ShellAPI, FileUtil, SentimailConfigForm, SentimailForm;
Type
  TSortData = Class(TObject)
  Private
    FSortKey:       ShortString;
    FSubject:       ShortString;
    FInstance:      ShortString;
  Public
    property SortKey:  ShortString read FSortKey;  {* DATA FIELDS REQUIRED FOR OR AFTER THE SORT *}
    property Instance: ShortString read FInstance;
    property Subject:  ShortString read FSubject;

    Constructor Create (const Instance: ShortString; const Subject: ShortString);
  End;

Constructor TSortData.Create (const Instance: ShortString; const Subject: ShortString);
Begin // Create
  Inherited Create;

{* POPULATE THE SORT OBJECT'S FIELDS *}

  FSortKey       := Subject;
  FInstance      := Instance;
  FSubject       := Subject;
End; // Create

// Sorts into Descending date order
function SortObjects (Item1, Item2: Pointer) : Integer;
Var
  Obj1, Obj2 : TSortData;
Begin // SortObjects
  Obj1 := TSortData(Item1);
  Obj2 := TSortData(Item2);

  If (Obj1.SortKey < Obj2.SortKey) Then
    Result := 1
  Else If (Obj1.SortKey > Obj2.SortKey) Then
    Result := -1
  Else
    Result := 0;
End; // SortObjects


function TSentimailMessages.Configure(HostHandle: Integer): WordBool; {* DISPLAY CONFIGURATION FORM *}
Var
  frmConfigurePlugIn : TfrmConfigureSentimail;
Begin // Configure
  frmConfigurePlugIn := TfrmConfigureSentimail.Create(NIL);
  Try
    with frmConfigurePlugIn do begin {* COPY CURRENT FILTERS ETC. TO THE FORM CONTROLS *}
      Host        := HostHandle;
      Caption     := 'Configure Sentimail Messages';
      Company     := ocCompanyCode;
      DataPath    := ocDataPath;
      Rows        := ocRows;
      FExclusiveOp := true;
      try
        Startup;
      finally
        FExclusiveOp := false;
      end;
    end;

    Result := (frmConfigurePlugIn.ShowModal = mrOK);

    If Result Then
    Begin
      with frmConfigurePlugIn do begin {* COPY FORM CONTROL VALUES BACK INTO FILTER FIELDS *}
        if ocCompanyCode <> Company then begin
          ocUserId   := '';
        end;
        ocCompanyCode := Company;
        ocDataPath    := DataPath;
        ocRows        := Rows;
      end;
    End;
  Finally
    FreeAndNIL(frmConfigurePlugIn);
  End;
end;

function TSentimailMessages.DrillDown(HostHandle: integer; MessageHandle: Integer; const UniqueID: WideString): WordBool;
{* WHAT TO DO WITH THE UNIQUE ID WHEN THE USER DOUBLE-CLICKS A DISPLAYED ROW OF DATA *}
var
  frmMail: TfrmMail;
  PosSentinel: integer;
  PosInstance: integer;
Begin
  CrackDrillDownInfo(UniqueID);

  PosSentinel := pos('\/', ocUniqueIDEtc) + 2; // the value of ID = UserID\/SentinelName/\Instance
  PosInstance := pos('/\', ocUniqueIDEtc) + 2;

  frmMail := TfrmMail.Create(nil);
  with frmMail do begin
    DataPath := trim(ocDataPath);
    UserID   := copy(ocUniqueIDEtc, 1, PosSentinel - 3);
    Sentinel := StringReplace(copy(ocUniqueIDEtc, PosSentinel, PosInstance - (PosSentinel + 2)), '*', ' ', [rfReplaceAll]);
    Instance := StrToInt(copy(ocUniqueIDEtc, PosInstance, length(ocUniqueIDEtc) - PosInstance + 1));
      FExclusiveOp := true;
      try
        Startup;
      finally
        FExclusiveOp := false;
      end;
    ShowModal;
    result := RefreshData;
  end;
  FreeAndNil(frmMail);
end;

function TSentimailMessages.Get_dlpColumns: WideString; {* DESCRIBE THE REQUIRED COLUMNS TO THE KPI HOST *}
begin
  if ocAreas < 3 then
    Result :=
    '<Columns>' +
    '  <Column Title="Subject"   Type="String" Align="Left"  Width="100%"  FontStyle="Normal"></Column>' +
    '</Columns>'
  else
    Result :=
    '<Columns>' +
    '  <Column Title="Subject"   Type="String" Align="Left"  Width="100%"  FontStyle="Normal"></Column>' +
    '</Columns>';
end;

function TSentimailMessages.Get_dpCaption: WideString; {* SET THE PLUG-IN'S CAPTION *}
begin
  Result := Format('%s [%s]', [CheckAltCaption('Sentimail Messages'), ocCompanyCode]); // v20
end;

function TSentimailMessages.Get_dpConfiguration: WideString; {* RETURN THE CURRENT CONFIGURATION TO THE KPI HOST *}
  function XMLise(ANode: string; AValue: string): string;
  begin
    result := format('<%s>%s</%0:s>', [ANode, AValue]);
  end;
begin
  Result :=          XMLise('Company', ocCompanyCode);
  result := result + XMLise('Rows', IntToStr(ocRows));
end;

function TSentimailMessages.Get_dpDisplayType: EnumDataPlugInDisplayType;
begin
  Result := dtDataList;
end;

function TSentimailMessages.Get_dpPluginID: WideString; {* IDENTIFY THIS PLUG-IN TO THE KPI HOST *}
begin
  Result := 'SentimailMessages'; // matches the entry in the <username>.dat file
end;

function TSentimailMessages.Get_dpSupportsConfiguration: WordBool; {* DOES THE PLUG-IN USE CONFIGF ? *}
begin
  Result := True;
end;

function TSentimailMessages.Get_dpSupportsDrillDown: WordBool; {* CAN A ROW BE DOUBLE-CLICKED TO PROVIDE MORE INFO FROM EXCHEQUER ? *}
begin
  Result := true;
end;

function TSentimailMessages.GetData: WideString; {* RETURN DATA TO KPI HOST IN XML STRING *}
Var
  SortList: TObjectList;
  SortData: TSortData;
  i: integer;
  Triggered : ITriggeredEvent;
  Toolkit : IToolkit;
  res: integer;

  function CreateUniqueId(Sentinel: WideString; Instance: integer): ShortString;
  begin
    result := format('%s\/%s/\%d', [trim(ocUserId), StringReplace(Sentinel, ' ', '*', [rfReplaceAll]), Instance]);
  end;
Begin // GetData
  Result := '';

{* RETRIEVE DATA *}
  FExclusiveOp := true;
  try
      SortList := TObjectList.Create;
      Try
        SortList.OwnsObjects := True;

        Toolkit := CreateToolkitWithBackDoor;
        Triggered := CreateOLEObject('Sentimail.TriggeredEvent') as ITriggeredEvent;
        with Triggered do begin
          teDataPath := ocDataPath;
          Res := GetFirst(ocUserId);
          while res = 0 do begin
            SortList.Add (TSortData.Create(CreateUniqueId(teSentinel, teInstance), teEmailSubject));
            res := GetNext;
          end;
        end;

{* SORT DATA *}
        // Sort into (by date)
        SortList.Sort(SortObjects);

{* RETURN DATA AS XML *}
        // Write the top n rows to the XML result
        Result := '<Data>';
        For i := 0 To IfThen(SortList.Count > ocRows, ocRows - 1, SortList.Count -1) Do
        Begin
          SortData := TSortData(SortList.Items[I]);

          if ocAreas < 3 then
            Result := Result + Format('<Row UniqueId="%s"><Column>%s</Column></Row>',
                                      [SortData.Instance, SortData.Subject])
          else
            Result := Result + Format('<Row UniqueId="%s"><Column>%s</Column></Row>',
                                      [SortData.Instance, contract(SortData.Subject, 30)]);
        End;
        Result := Result + '</Data>';
      Finally
        FreeAndNIL(SortList);
        Triggered := nil;
        Toolkit   := nil;
      End; // Try..Finally
  finally
    FExclusiveOp := false;
  end;
end;

procedure TSentimailMessages.Set_dpConfiguration(const Value: WideString); {* DECODE THE XML CONFIGURATION FROM THE KPI HOST *}
var
  Leaf : TGmXmlNode;
begin
    inherited;

    if assigned(ocXML) then
    try
      with ocXML do begin
      end;
    finally
      FreeXML;
    end;
end;

procedure TSentimailMessages.Initialize;
begin
  ocRows := 10;
end;

end.
