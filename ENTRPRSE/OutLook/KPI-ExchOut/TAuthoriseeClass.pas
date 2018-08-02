unit TAuthoriseeClass;

{* COMMENTS IN CAPITALS HIGHLIGHT CODE WHICH WOULD USUALLY NEED TO BE ALTERED TO SUIT EACH PLUG-IN *}

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, IRISEnterpriseKPI_TLB, StdVcl, IKPIHost_TLB, GmXML, Windows, Forms, TOutlookControlClass;

type
  TAuthorisee = class(TOutlookControl)
  private
    FExclusiveOp: WordBool;
{* PLUG-IN CONFIGURATION *}      // from the plugin's idp file [Config] section

{*  FIELDS SPECIFIC TO THIS PLUG-IN *}
    FAuthID: ShortString;
    FAuthCode: ShortString;
    FLastDays: integer;
    FExpaSet: THandle;

  public
    function  Configure(HostHandle: Integer): WordBool; override;
    function  DrillDown(HostHandle: integer; MessageHandle: Integer; const UniqueID: WideString): WordBool; override;
    function  Get_dlpColumns: WideString; override;
    function  Get_dpCaption: WideString; override;
    function  Get_dpConfiguration: WideString; override;
    function  Get_dpDisplayType: EnumDataPlugInDisplayType; override;
    function  Get_dpPluginID: WideString; override;
    function  Get_dpSupportsConfiguration: WordBool; override;
    function  Get_dpSupportsDrillDown: WordBool; override;
    function  GetData: WideString; override;
    procedure Initialize; override;
    procedure Set_dpConfiguration(const Value: WideString); override;
  end;

implementation

uses Classes, ComServ, Contnrs, Dialogs, IniFiles, Math, SysUtils, Enterprise01_TLB,
     Controls, CTKUtil, ShellAPI, FileUtil, AuthoriseeConfigForm, AuthoriseeForm, AuthoriseeInterface, VAOUtil;

Type
  TSortData = Class(TObject)
  Private
    FSortKey:     ShortString;
    FOurRef:      ShortString;
    FAmount:      double;
    FRequestDate: ShortString;
  Public
    property SortKey:     ShortString read FSortKey;  {* DATA FIELDS REQUIRED FOR OR AFTER THE SORT *}
    property OurRef:      ShortString read FOurRef;
    property RequestDate: ShortString read FRequestDate;
    property Amount:      double      read FAmount;

    Constructor Create (const OurRef: ShortString; const RequestDate: ShortString; Amount: double);
  End;

Constructor TSortData.Create (const OurRef: ShortString; const RequestDate: ShortString; Amount: double);
Begin
  Inherited Create;

{* POPULATE THE SORT OBJECT'S FIELDS *}

  FSortKey       := RequestDate;
  FOurRef        := OurRef;
  FRequestDate   := RequestDate;
  FAmount        := Amount;
End;

function SortObjects (Item1, Item2: Pointer) : Integer;
Var
  Obj1, Obj2 : TSortData;
Begin
  Obj1 := TSortData(Item1);
  Obj2 := TSortData(Item2);

  If (Obj1.SortKey < Obj2.SortKey) Then
    Result := -1
  Else If (Obj1.SortKey > Obj2.SortKey) Then
    Result := 1
  Else
    Result := 0;
End;

function TAuthorisee.Configure(HostHandle: Integer): WordBool; {* DISPLAY CONFIGURATION FORM *}
var
  frmConfigurePlugIn : TfrmConfigureAuthorisee;
begin
  frmConfigurePlugIn := TfrmConfigureAuthorisee.Create(nil);
  try
    with frmConfigurePlugIn do begin {* COPY CURRENT FILTERS ETC. TO THE FORM CONTROLS *}
      Host        := HostHandle;
      Caption     := 'Configure Authoris-e';
      Company     := ocCompanyCode;
      DataPath    := ocDataPath;
      Currency    := ocCurrency;
      CurrSymb    := ocCurrencySymbol;
      AuthID      := ocUserID;
      AuthCode    := FAuthCode;
      LastDays    := FLastDays;
      FExclusiveOp := true;
      try
        Startup;
      finally
        FExclusiveOp := false;
      end;
    end;

    Result := (frmConfigurePlugIn.ShowModal = mrOK);

    if Result then begin
      with frmConfigurePlugIn do begin {* COPY FORM CONTROL VALUES BACK INTO FILTER FIELDS *}
        if ocCompanyCode <> Company then begin
          ocUserId   := '';
        end;
        ocCompanyCode := Company;
        ocCurrency    := Currency;
        ocCurrencySymbol := CurrSymb;
        FAuthID      := AuthID;
        FAuthCode    := AuthCode;
        FLastDays    := LastDays;
      end;
    end;
  finally
    FreeAndNIL(frmConfigurePlugIn);
  end;
end;

function TAuthorisee.DrillDown(HostHandle: integer; MessageHandle: Integer; const UniqueID: WideString): WordBool;
{* WHAT TO DO WITH THE UNIQUE ID WHEN THE USER DOUBLE-CLICKS A DISPLAYED ROW OF DATA *}
var
  frmAuth: TfrmAuth;
  PosDate: integer;
  PosUserID: integer;
Begin
  CrackDrillDownInfo(UniqueID);

  PosDate   := pos('\/', ocUniqueIDEtc) + 2; // the value of ID = OurRef\/RequestDateTime/\ExpaSetHandle
  PosUserID := pos('/\', ocUniqueIDEtc) + 2; // Expaset Handle isn't used now.

  frmAuth := TfrmAuth.Create(nil);
  with frmAuth do begin
    DataPath    := trim(ocDataPath);
    CompanyCode := ocCompanyCode;
    OurRef      := copy(ocUniqueIDEtc, 1, PosDate - 3);
    RequestDate := copy(ocUniqueIDEtc, PosDate, length(ocUniqueIDEtc) - PosDate + 1);
    AuthID      := copy(ocUniqueIDEtc, PosUserID, length(ocUniqueIDEtc) - PosUserID + 1);
    CurrSymb    := ocCurrencySymbol;
      FExclusiveOp := true;
      try
        Startup;
      finally
        FExclusiveOp := false;
      end;
    ShowModal;
    result      := RefreshData;
  end;
  FreeAndNil(frmAuth);
end;

function TAuthorisee.Get_dlpColumns: WideString; {* DESCRIBE THE REQUIRED COLUMNS TO THE KPI HOST *}
begin
  if ocAreas < 3 then
    Result :=
      '<Columns>' +
      '  <Column Title="Ref"    Type="String" Align="Left"  Width="50%"></Column>' +
      '  <Column Title="Amount (' + ocCurrencySymbol + ')" Type="String" Align="Right" Width="50%" FontStyle="Normal"></Column>' +
      '</Columns>'
  else
    Result :=
      '<Columns>' +
      '  <Column Title="Ref"    Type="String" Align="Left"  Width="50%"></Column>' +
      '  <Column Title="Amount (' + ocCurrencySymbol + ')" Type="String" Align="Right" Width="50%" FontStyle="Normal"></Column>' +
      '</Columns>'
end;

function TAuthorisee.Get_dpCaption: WideString; {* SET THE PLUG-IN'S CAPTION *}
begin
  Result := Format('%s [%s]', [CheckAltCaption('Authoris-e'), ocCompanyCode]); // v20
end;

function TAuthorisee.Get_dpConfiguration: WideString; {* RETURN THE CURRENT CONFIGURATION TO THE KPI HOST *}
  function XMLise(ANode: string; AValue: string): string;
  begin
    result := format('<%s>%s</%0:s>', [ANode, AValue]);
  end;
begin
  Result :=          XMLise('Company', ocCompanyCode);
  result := result + XMLise('AuthID', FAuthID);
  result := result + XMLise('AuthCode', FAuthCode);
  result := result + XMLise('Currency', IntToStr(ocCurrency));
  result := result + XMLise('LastDays', IntToStr(FLastDays));
  result := result + XMLise('CurrencySymbol', ocCurrencySymbol);
end;

function TAuthorisee.Get_dpDisplayType: EnumDataPlugInDisplayType;
begin
  Result := dtDataList;
end;

function TAuthorisee.Get_dpPluginID: WideString; {* IDENTIFY THIS PLUG-IN TO THE KPI HOST *}
begin
  Result := 'Authorisee'; // matches the entry in the <username>.dat file
end;

function TAuthorisee.Get_dpSupportsConfiguration: WordBool; {* DOES THE PLUG-IN USE CONFIGF ? *}
begin
  Result := True;
end;

function TAuthorisee.Get_dpSupportsDrillDown: WordBool; {* CAN A ROW BE DOUBLE-CLICKED TO PROVIDE MORE INFO FROM EXCHEQUER ? *}
begin
  Result := ocUserIsAuthorised;
end;

function TAuthorisee.GetData: WideString; {* RETURN DATA TO KPI HOST IN XML STRING *}
Var
  SortList: TObjectList;
  SortData: TSortData;
  i: integer;
  res: integer;
  TheList : IRequestList;
  Request : IRequest;

  function GetRequests(CompanyCode, AuthID, AuthCode: ShortString; CutOffDays: SmallInt): IRequestList;
  type
    TGetRequests = function(CompanyCode, AuthID, AuthCode: ShortString; CutOffDays: SmallInt): IRequestList; stdcall;
  var
    ExpaForm:     THandle;
    ExpaSet:      THandle;
    GetRequestsF: TGetRequests;
  begin
    if not FileExists(VAOInfo.VAOAppsDir + 'ExpaForm.dll') then
      ShowMessage('Authoris-e not installed') // means...ShowMessage(format('ExpaForm.dll not found in %s', [VAOInfo.VAOAppsDir]))  // v.005
    else begin
      ExpaForm := LoadLibrary(pchar(VAOInfo.VAOAppsDir + 'ExpaForm.dll'));
      if ExpaForm = 0 then
        ShowMessage('Authoris-e is not installed') // means...ShowMessage('Cannot load ExpaForm library') // v.005
      else begin
        if not FileExists(VAOInfo.VAOAppsDir + 'ExpaSet.dll') then
          ShowMessage('Authoris-e not installed.') // with a fullstop means...ShowMessage(format('ExpaSet.dll not found in %s', [VAOInfo.VAOAppsDir])) // v.005
        else begin
          ExpaSet := LoadLibrary(pchar(VAOInfo.VAOAppsDir + 'ExpaSet.dll'));
          if ExpaSet = 0 then
            ShowMessage('Authoris-e is not installed.') // with a fullstop means...ShowMessage('Cannot load ExpaSet library') // v.005
          else begin
            FExpaSet     := ExpaSet;
            GetRequestsF := GetProcAddress(ExpaSet, 'GetRequests');
            result       := GetRequestsF(CompanyCode, AuthID, AuthCode, CutOffDays + 1);
          end;
        end;
      end;
    end;
    if ExpaForm <> 0 then
      FreeLibrary(ExpaForm); // don't free ExpaSet or it can't be reloaded in AuthF.pas !
  end;

  function CreateUniqueId(OurRef: ShortString; ADate: ShortString; UserID: ShortString): ShortString;
  begin
    result := OurRef + '\/' + ADate + '/\' + format('%s', [ocUserID]);
//    ShowMessage(result);
  end;

Begin // GetData
  Result  := '';
  FExclusiveOp := true;
  try
    OpenComToolkit;
    try
      TheList := GetRequests(ocCompanyCode, ocUserID, FAuthCode, FLastDays + 1); // FAuthId is currently overridden by FUserId, i.e. they are one and the same
    except on e:exception do
    end;

  {* RETRIEVE DATA *}
    SortList := TObjectList.Create;
    Try
      SortList.OwnsObjects := True;

      if assigned(TheList) then
        for i := 0 to TheList.rlCount - 1 do
          with TheList.rlItems[i] do
            SortList.Add (TSortData.Create(rqOurRef, rqDate, ConvertToCurrency(rqValue)));

  {* SORT DATA *}
      // Sort into (by date)
      SortList.Sort(SortObjects);

  {* RETURN DATA AS XML *}
      // Write the top n rows to the XML result
      Result := '<Data>';
      for i := 0 To SortList.Count -1 do begin
        SortData := TSortData(SortList.Items[i]);

        if ocAreas < 3 then
          Result := Result + Format('<Row UniqueId="%s"><Column>%s</Column><Column>%0.2n</Column></Row>',
                                    [CreateUniqueID(SortData.OurRef, SortData.RequestDate, ocUserID), SortData.OurRef, SortData.Amount])
        else
          Result := Result + Format('<Row UniqueId="%s"><Column>%s</Column><Column>%0.2n</Column></Row>',
                                    [CreateUniqueID(SortData.OurRef, SortData.RequestDate, ocUserID), SortData.OurRef, SortData.Amount]);
      end;
      Result := Result + '</Data>';
    finally
      FreeAndNIL(SortList);
      CloseComToolkit;
    end; // Try..Finally
  finally
    FExclusiveOp := false;
  end;
end;

procedure TAuthorisee.Set_dpConfiguration(const Value: WideString); {* DECODE THE XML CONFIGURATION FROM THE KPI HOST *}
var
  Leaf : TGmXmlNode;
begin
  inherited;

  if assigned(ocXML) then
  try
    with ocXML do begin
      FAuthID := '';
      Leaf := Nodes.NodeByName['AuthID'];
      if assigned(Leaf) then
        FAuthID := Leaf.AsString;

      FAuthCode := '';
      Leaf := Nodes.NodeByName['AuthCode'];
      if assigned(Leaf) then
        FAuthCode := Leaf.AsString;

      Leaf := Nodes.NodeByName['LastDays'];
      if assigned(Leaf) then
        FLastDays := Leaf.AsInteger;
      if FLastDays = 0 then
        FLastDays := 30;
    end;
  finally
    FreeXML;
  end;
end;

procedure TAuthorisee.Initialize;
begin
  ocRows := 10;
end;

end.
