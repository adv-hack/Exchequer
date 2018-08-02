unit TExchequerNotesClass;

{* COMMENTS IN CAPITALS HIGHLIGHT CODE WHICH WOULD USUALLY NEED TO BE ALTERED TO SUIT EACH PLUG-IN *}

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, IRISEnterpriseKPI_TLB, StdVcl, IKPIHost_TLB, GmXML, Windows, Forms, TOutlookControlClass, Contnrs;

type
  TExchequerNotes = class(TOutlookControl)
  private
    FExclusiveOp: WordBool;
{* PLUG-IN CONFIGURATION *}      // from the plugin's idp file [Config] section

{* DATA FILTERS *}               // from the <username>.dat file (maintained using ConfigF)

{*  FIELDS SPECIFIC TO THIS PLUG-IN *}
    FViewCustNotes: boolean;
    FViewSuppNotes: boolean;
    FViewStokNotes: boolean;

    procedure CheckUserAuth;
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
     Controls, CTKUtil, ShellAPI, FileUtil, NotesConfigForm, StockForm, AccountForm;

Type
  TSortData = Class(TObject)
  Private
    FSortKey:       ShortString;
    FNoteDate:      ShortString;
    FCode:          ShortString;
    FDesc:          ShortString;
    function GetDisplayCode: ShortString;
  Public
    property SortKey: ShortString read FSortKey;  {* DATA FIELDS REQUIRED FOR OR AFTER THE SORT *}
    property NoteDate: ShortString read FNoteDate;
    property code: ShortString read FCode;
    property DisplayCode: ShortString read GetDisplayCode;
    property Desc: ShortString read FDesc;

    Constructor Create (const Code: ShortString; const NoteDate: ShortString; const Desc: ShortString);
  End;

Constructor TSortData.Create (const Code: ShortString; const NoteDate: ShortString; const Desc: ShortString);
Begin // Create
  Inherited Create;

{* POPULATE THE SORT OBJECT'S FIELDS *}

  FSortKey       := NoteDate;
  FNoteDate      := NoteDate;
  FCode          := Code;
  FDesc          := Desc;
End; // Create

function TSortData.GetDisplayCode: ShortString;
begin
  result := copy(FCode, 2, length(FCode) - 1); // strip off the leading K, C or S
end;

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

function TExchequerNotes.Configure(HostHandle: Integer): WordBool; {* DISPLAY CONFIGURATION FORM *}
Var
  frmConfigurePlugIn : TfrmConfigureNotes;
Begin // Configure
  frmConfigurePlugIn := TfrmConfigureNotes.Create(NIL);
  Try
    with frmConfigurePlugIn do begin {* COPY CURRENT FILTERS ETC. TO THE FORM CONTROLS *}
      Host        := HostHandle;
      Caption     := 'Configure Exchequer Notes Plug-In';
      Company     := ocCompanyCode;
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
          ocUserIsAuthorised := false;
        end;
        ocCompanyCode := Company;
        ocRows        := Rows;
      end;
    End;
  Finally
    FreeAndNIL(frmConfigurePlugIn);
  End;
end;

function TExchequerNotes.DrillDown(HostHandle: integer; MessageHandle: Integer; const UniqueID: WideString): WordBool;
{* WHAT TO DO WITH THE UNIQUE ID WHEN THE USER DOUBLE-CLICKS A DISPLAYED ROW OF DATA *}
var
  SourceType: WideChar;
  Code: WideString;
  ID: WideString;
  NoteText: WideString;
  PosDoubleSlash: integer;
Begin
  CrackDrillDownInfo(UniqueID);

  ID := ocUniqueIDEtc;

  if ID <> '' then begin
    SourceType := ID[1];
    Code       := copy(ID, 2, length(ID) - 1);
    PosDoubleSlash := pos('//', Code);
    NoteText       := copy(Code, PosDoubleSlash + 2, length(Code) - (PosDoubleSlash + 2));
    NoteText       := StringReplace(NoteText, '*', ' ', [rfReplaceAll]);
    Code           := copy(Code, 1, PosDoubleSlash - 1);
    FExclusiveOp   := true;
    try
      case SourceType of
        'K': ShowStockForm(ocDataPath, Code, ocCurrency, NoteText);
        'C': ShowAccountForm(ocDataPath, Code, 'Customer', ocCurrency, NoteText, '');
        'S': ShowAccountForm(ocDataPath, Code, 'Supplier', ocCurrency, NoteText, '');
      end;
    finally
      FExclusiveOp := false;
    end;
  end;
  result := false;
end;

function TExchequerNotes.Get_dlpColumns: WideString; {* DESCRIBE THE REQUIRED COLUMNS TO THE KPI HOST *}
begin
  CheckUserAuth;

  if ocUserIsAuthorised then
    if ocAreas < 3 then
      Result :=
      '<Columns>' +
      '  <Column Title="Code"      Type="String" Align="Left"  Width="15%"  FontStyle="Normal" BackColor="#EEEEFF"></Column>' +
      '  <Column Title="Date"      Type="String" Align="Left"  Width="21%"  FontStyle="Normal"></Column>' +
      '  <Column Title="Desc"      Type="String" Align="Left"  Width="64%"  FontStyle="Normal"></Column>' +
      '</Columns>'
    else
      Result :=
      '<Columns>' +
      '  <Column Title="Date"      Type="String" Align="Left"  Width="35%"  FontStyle="Normal"></Column>' +
      '  <Column Title="Desc"      Type="String" Align="Left"  Width="65%"  FontStyle="Normal"></Column>' +
      '</Columns>'
  else
    result := '<Columns>' +
            '  <Column Title=" " Type="String" Align="Left"  Width="100%"></Column>' + // one column to contain the error message
            '</Columns>';
end;

function TExchequerNotes.Get_dpCaption: WideString; {* SET THE PLUG-IN'S CAPTION *}
begin
  Result := Format('%s [%s]', [CheckAltCaption('Notes'), ocCompanyCode]); // v20
end;

function TExchequerNotes.Get_dpConfiguration: WideString; {* RETURN THE CURRENT CONFIGURATION TO THE KPI HOST *}
  function XMLise(ANode: string; AValue: string): string;
  begin
    result := format('<%s>%s</%0:s>', [ANode, AValue]);
  end;
begin
  Result :=          XMLise('Company', ocCompanyCode);
  result := result + XMLise('Rows', IntToStr(ocRows));
end;

function TExchequerNotes.Get_dpDisplayType: EnumDataPlugInDisplayType;
begin
  Result := dtDataList;
end;

function TExchequerNotes.Get_dpPluginID: WideString; {* IDENTIFY THIS PLUG-IN TO THE KPI HOST *}
begin
  Result := 'ExchequerNotes'; // matches the entry in the <username>.dat file
end;

function TExchequerNotes.Get_dpSupportsConfiguration: WordBool; {* DOES THE PLUG-IN USE CONFIGF ? *}
begin
  Result := True;
end;

function TExchequerNotes.Get_dpSupportsDrillDown: WordBool; {* CAN A ROW BE DOUBLE-CLICKED TO PROVIDE MORE INFO FROM EXCHEQUER ? *}
begin
  Result := true;
end;

function TExchequerNotes.GetData: WideString; {* RETURN DATA TO KPI HOST IN XML STRING *}
var
  oAccount : IAccount;
  oStock   : IStock2;
  oSortObj : TSortData;
  SortList : TObjectList;
  Res, rc  : LongInt;
  I        : SmallInt;
  UniqueID: WideString;
Begin
  Result := '';
  if not ocUserIsAuthorised then begin
    result := '<Data><Row UniqueId=" "><Column>Authorisation is required to view this data</Column></Row></Data>';
    EXIT;
  end;

{* RETRIEVE DATA *}
  FExclusiveOp := true;
  try
    OpenComToolkit;
    if assigned(ocToolkit) then begin
    try
        SortList := TObjectList.Create;
        try
          SortList.OwnsObjects := True;

          if FViewStokNotes then begin // Get Stock Notes
            oStock := ocToolkit.Stock as IStock2;
            oStock.Index := stIdxCode;

            // Load the sort list with all stock notes - use stock code as the sort key
            Res := oStock.GetFirst;
            while (Res = 0) Do Begin
              with oStock do begin
                with oStock.stNotes do begin
                  ntType := ntTypeDated;
                  rc := GetFirst;
                  while rc = 0 do begin
    //                ShowMessage(format('Operator: %s, AlarmUser: %s', [ntOperator, ntAlarmUser]));
                    if ntAlarmSet and (ntAlarmDate <> '') and (SameText(ntOperator, ocUserID) or SameText(ntAlarmUser, ocUserID) or (ntAlarmUser = '')) then
                      SortList.Add (TSortData.Create('K' + stCode, ntDate, ntText)); // K identifies stock codes in DrillDown
                    rc := GetNext;
                  end;
                end;

                application.ProcessMessages;
                Res := GetNext;
              end;
            end;
          end;

          if FViewCustNotes then begin // get customer notes
            oAccount := ocToolkit.Customer;
            oAccount.Index := acIdxCode;

            res := oAccount.GetFirst;
            while res = 0 do begin
              with oAccount do begin
                with oAccount.acNotes do begin
                  ntType := ntTypeDated;
                  rc := GetFirst;
                  while rc = 0 do begin
                    if ntAlarmSet and (ntAlarmDate <> '') and (SameText(ntOperator, ocUserID) or SameText(ntAlarmUser, ocUserID) or (ntAlarmUser = '')) then
                      SortList.Add(TSortData.Create('C' + acCode, ntDate, ntText)); // C identifies customer account codes in DrillDown
                    rc := GetNext;
                  end;
                end;
                application.ProcessMessages;
                res := GetNext;
              end;
            end;
          end;

          if FViewSuppNotes then begin // get supplier notes
            oAccount := ocToolkit.Supplier;
            oAccount.Index := acIdxCode;

            res := oAccount.GetFirst;
            while res = 0 do begin
              with oAccount do begin
                with oAccount.acNotes do begin
                  ntType := ntTypeDated;
                  rc := GetFirst;
                  while rc = 0 do begin
                    if ntAlarmSet and (ntAlarmDate <> '') and (SameText(ntOperator, ocUserID) or SameText(ntAlarmUser, ocUserID) or (ntAlarmUser = '')) then
                      SortList.Add(TSortData.Create('S' + acCode, ntDate, ntText)); // S identifies supplier account codes in DrillDown
                    rc := GetNext;
                  end;
                end;
                application.ProcessMessages;
                res := GetNext;
              end;
            end;
          end;

  {* SORT DATA *}
          // Sort into (by date)
          SortList.Sort(SortObjects);

  {* RETURN DATA AS XML *}
          // Write the top n rows to the XML result
          Result := '<Data>';
          For I := 0 To IfThen(SortList.Count > ocRows, ocRows - 1, SortList.Count -1) Do
          Begin
            oSortObj := TSortData(SortList.Items[I]);

            UniqueId := StringReplace(oSortObj.Code + '//' + oSortObj.Desc, ' ', '*', [rfReplaceAll]);
            if ocAreas < 3 then
              Result := Result + Format('<Row UniqueId="%s"><Column>%s</Column><Column>%s/%s/%s</Column><Column>%s</Column></Row>',
                                        [UniqueId, contract(oSortObj.DisplayCode, 6), copy(oSortObj.NoteDate, 7, 2),
                                                                                   copy(oSortObj.NoteDate, 5, 2),
                                                                                   copy(oSortObj.NoteDate, 1, 4),oSortObj.Desc])
            else
              Result := Result + Format('<Row UniqueId="%s"><Column>%s/%s/%s</Column><Column>%s</Column></Row>',
                                        [UniqueId,                                 copy(oSortObj.NoteDate, 7, 2),
                                                                                   copy(oSortObj.NoteDate, 5, 2),
                                                                                   copy(oSortObj.NoteDate, 1, 4),oSortObj.Desc]);
          End;
          Result := Result + '</Data>';
        finally
          FreeAndNIL(SortList);
        end;

    finally
      CloseComToolkit;
    end;
    end;
  finally
    FExclusiveOp := false;
  end;
end;

procedure TExchequerNotes.Set_dpConfiguration(const Value: WideString); {* DECODE THE XML CONFIGURATION FROM THE KPI HOST *}
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

procedure TExchequerNotes.CheckUserAuth; {* CHECK THE USER IS AUTHORISED TO VIEW THE DATA THIS PLUG-IN DISPLAYS *}
begin
  OpenComToolkit;

  FViewCustNotes     := CheckAccessSetting(104);  // can view customer notes
  FViewSuppNotes     := CheckAccessSetting(105);  // can view supplier notes
  FViewStokNotes     := true; // CheckAccessSetting(???)  // can view stock notes
  ocUserIsAuthorised := FViewCustNotes or FViewSuppNotes or FViewStokNotes; // currently always true
  
  CloseComToolkit;
end;

procedure TExchequerNotes.Initialize;
begin
  ocRows := 10;
end;

end.
