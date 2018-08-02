unit TOutlookControlClass;

interface

uses SysUtils, classes, IKPIHost_TLB, Enterprise01_TLB, CTKUtil, gmXML, KPICommon;

// const
//  MAX_ODD_CONTROLS = 13;

type

  IOutlookControl = interface
    ['{DD9DF1A6-C3F0-4DD9-8C1D-133D22EB0137}']
    // Getters and Setter for public properties
    function  GetUserID: ShortString;
    procedure SetUserID(const Value: ShortString);
    function  GetCompanyCode: ShortString;

    // public functions and properties
    function  Configure(HostHandle: Integer): WordBool;
    procedure CheckIDPFile(const IDPPath: WideString);
    function  DrillDown(HostHandle, MessageHandle: Integer; const UniqueID: WideString): WordBool;
    function  GetData: WideString;
    function  Get_dlpColumns: WideString;
    function  Get_dpCaption: WideString;
    function  Get_dpConfiguration: WideString;
    function  Get_dpDisplayType: EnumDataPlugInDisplayType;
    function  Get_dpPluginID: WideString;
    function  Get_dpStatus: EnumDataPlugInStatus;
    function  Get_dpSupportsConfiguration: WordBool;
    function  Get_dpSupportsDrillDown: WordBool;
    procedure Initialize;
    procedure Set_dpConfiguration(const Value: WideString);
    procedure Set_dpHostPath(const Value: WideString); safecall;
    procedure Set_dpHostVersion(const Value: WideString); safecall;
    property  ocCompanyCode: ShortString read GetCompanyCode;
    property  ocUserID: ShortString read GetUserID write SetUserID;
    property  ocHostPath: WideString  write Set_dpHostPath;
    property  ocHostVersion: WideString write Set_dpHostVersion;
  end;

  TOutlookControl = class(TInterfacedObject, IOutlookControl)
  private
    FAreas:             smallint;
    FToolkit:           IToolkit2;
    FCompanyCode:       ShortString;
    FCurrencySymbol:    WideString;
    FDataPath:          ShortString;
    FUserID:            ShortString;
    FUserAuth:          boolean;
    FRows:              integer;
    FCurrency:          integer;
    FClickedColumn:     smallint;
    FUniqueIDEtc:       string;
    FFarRightColumn:    smallint;
    FToolkitOpen:       boolean;
    FIdpPath:           WideString; // v20
    FAltCaption:        WideString; //v 20
  protected
    FXML:               TgmXML;
    function CheckAltCaption(const OrigCaption: WideString): WideString; // v20
  public
    // Interface property getters and setters
    function GetCompanyCode: ShortString;
    function GetUserID: ShortString;
    procedure SetUserID(const Value: ShortString);

    // methods implemented in this base class
    function  CheckAccessSetting(ASecurityFlag: integer): boolean;
    procedure CheckIDPFile(const IDPPath: WideString); virtual;
    procedure CloseComToolkit;
    function  Contract(const AString: WideString; ALength: integer): WideString;
    function  ConvertToCurrency(Value: double): double;
    function  ConvertToThisCurrency(FromCurrency: Integer; Value: double): double;
    procedure CrackDrillDownInfo(const DrillDownInfo: WideString);
    procedure FreeXML;
    function  Get_dpStatus: EnumDataPlugInStatus; virtual;
    procedure OpenComToolkit;
    procedure Set_dpConfiguration(const Value: WideString); virtual;
    procedure SetFarRightColumn;
    procedure Set_dpHostPath(const Value: WideString); safecall;
    procedure Set_dpHostVersion(const Value: WideString); safecall;

    // methods which must be overridden in descendent classes
    function  Configure(HostHandle: Integer): WordBool; virtual; abstract;
    function  DrillDown(HostHandle, MessageHandle: Integer; const UniqueID: WideString): WordBool; virtual; abstract;
    function  Get_dlpColumns: WideString; virtual; abstract;
    function  Get_dpCaption: WideString; virtual; abstract;
    function  Get_dpConfiguration: WideString; virtual; abstract;
    function  Get_dpDisplayType: EnumDataPlugInDisplayType; virtual; abstract;
    function  Get_dpPluginID: WideString; virtual; abstract;
    function  Get_dpSupportsConfiguration: WordBool; virtual; abstract;
    function  Get_dpSupportsDrillDown: WordBool; virtual; abstract;
    function  GetData: WideString; virtual; abstract;
    procedure Initialize; virtual; abstract;

    // properties accessed both through the Public Interface and from Descendent classes
    property  ocCompanyCode: ShortString read FCompanyCode write FCompanyCode;
    property  ocUserID: ShortString read GetUserID write SetUserID;
    property  ocHostPath: WideString write Set_dpHostPath;
    property  ocHostVersion: WideString write Set_dpHostVersion;

    // properties only accessed in the base and descendent classes.
    property  ocAreas: smallint read FAreas write FAreas;
    property  ocClickedColumn: smallint read FClickedColumn;
    property  ocCurrency: integer read FCurrency write FCurrency;
    property  ocCurrencySymbol: WideString read FCurrencySymbol write FCurrencySymbol;
    property  ocDataPath: ShortString read FDataPath write FDataPath;
    property  ocFarRightColumn: smallint read FFarRightColumn;
    property  ocRows: integer read FRows write FRows;
    property  ocToolkit: IToolkit2 read FToolkit;
    property  ocUniqueIDEtc: string read FUniqueIDEtc write FUniqueIDEtc;
    property  ocUserIsAuthorised: boolean read FUserAuth write FUserAuth;
    property  ocXML: TgmXML read FXML;
    property  ocIdpPath: WideString read FIdpPath; // v20
    property  ocAltCaption: WideString read FAltCaption; // v20
  end;

procedure SetOutlookControl(AIDPPath: string; AMessageId: integer);
function ODDC: IOutlookControl;

implementation

uses dialogs, TAccountStatusClass, TDaybookTotalsClass, TAuthoriseeClass, TCalendarClass, TLinksClass,
     TMessagesClass, TExchequerNotesClass, TSentimailClass, TTasksClass, TTopAccountsClass, TTopProductsClass,
     IniFiles, KPIPlugin, TTimesheetClass, TVRWReportsClass;

type
  ODDCRec = record
    IDPFile: ShortString;
    IMessageID: integer;
    IODDC: IOutlookControl;
  end;

var
  FOutlookControl: IOutlookControl;
  FControlList: array of ODDCRec;
  FControlCount: integer;

procedure SetOutlookControl(AIDPPath: string; AMessageId: integer);
// reuse an existing instance of the required interface or create a new one and add it to the list
// The KPIHost doesn't correctly set the MessageID of a control before calling its CheckIDPFile method.
// So, as the IDP file itself is unique for each control, including customer/supplier variations, we use that instead.
// This was corrected in IKPIHost v.006, so now if we have an idp file we can either find a match or create a new control,
// otherwise if we only have a messageid we can try and match an existing control.
var
  i: integer;
  OddControlName: string;
  IDPFileName: ShortString;
begin
//  result := nil;

  if Debug_Mode then DebugLine(format('SetOutlookControl: IDPPath: %s, MessageID: %d ', [AIDPPath, AMessageId]));

  IDPFileName := LowerCase(ExtractFileName(AIDPPath));          // remove the path
  IDPFileName := copy(IDPFileName, 1, length(IDPFileName) - 4); // remove the .idp extension

  if AMessageID <> 0 then                    // only reuse objects when there's a messageid
  for i := 0 to high(FControlList) do
    with FControlList[i] do
      if ((IDPFile = IDPFileName) or (IDPFile = '')) and (IMessageID = AMessageId) then begin
        FOutlookControl := IODDC;
//        result := FOutlookControl;
        EXIT;
      end;

  // only create a new control if we know which idp file its being generated from - this allows the user to have multiple copies of the same control.    
  if AIDPPath = '' then EXIT;  // This should only be the case when AMessageID <> 0 and it matched an existing control - not using MessageID's any more (v.010 yes we are).

  with TIniFile.Create(AIDPPath) do begin
    try
      OddControlName := LowerCase(ReadString('Config', 'ODDControl', ''));
    finally
      Free;
    end;
  end;

  if OddControlName = 'accountstatus' then
    FOutlookControl := TAccountStatusClass.TAccountStatus.Create
  else
  if OddControlName = 'daybooktotals' then
    FOutlookControl := TDaybookTotals.Create
  else
  if OddControlName = 'authorisee' then
    FOutlookControl := TAuthorisee.Create
  else
  if OddControlName = 'olcalendar' then
    FOutlookControl := TOLCalendar.Create
  else
  if OddControlName = 'links' then
    FOutlookControl := TLinks.Create
  else
  if OddControlName = 'olmessages' then
    FOutlookControl := TOLMessages.Create
  else
  if OddControlName = 'exchequernotes' then
    FOutlookControl := TExchequerNotes.Create
  else
  if OddControlName = 'sentimail' then
    FOutlookControl := TSentimailMessages.Create
  else
  if OddControlName = 'oltasks' then
    FOutlookControl := TOLTasks.Create
  else
  if OddControlName = 'topaccounts' then
    FOutlookControl := TTopAccounts.Create
  else
  if OddControlName = 'topproducts' then
    FOutlookControl := TTopProducts.Create
  else
  if OddControlName = 'timesheet' then
    FOutlookControl := TTimesheet.Create
  else
  if OddControlName = 'vrwreports' then
    FOutlookControl := TVRWReports.Create
  else begin
    ShowMessage(format('Unknown Outlook Dynamic Dashboard control name: "%s"', [OddControlName]));
    EXIT;
  end;

  SetLength(FControlList, Length(FControlList) + 1);
  with FControlList[high(FControlList)] do begin
    IDPFile     := IDPFileName;
    IMessageID  := AMessageId;
    IODDC       := FOutlookControl;
  end;

//  result := FOutlookControl;
  ODDC.Initialize;
  ODDC.CheckIDPFile(AIDPPath);
end;

function ODDC: IOutlookControl;
begin
  result := FOutlookControl;
end;


{ TOutlookControl }

function TOutlookControl.CheckAccessSetting(ASecurityFlag: integer): boolean;
var
  oUserProfile: IUserProfile;
  res: integer;
begin
  result := false;
  if assigned(FToolkit) then begin
    oUserProfile := FToolkit.UserProfile;
    if oUserProfile <> nil then
      with oUserProfile do begin
        Index := usIdxLogin;
        res := GetEqual(BuildUserIDIndex(FUserId));
        if res = 0 then
          result := upSecurityFlags[ASecurityFlag] = srAccess;
      end;
  end;
end;

procedure TOutlookControl.CloseComToolkit;
begin
  FToolkit := nil;
  FToolkitOpen := false;
end;

function TOutlookControl.Contract(const AString: WideString; ALength: integer): WideString;
begin
  if length(AString) > ALength then
    result := copy(AString, 1, ALength) + '..'
  else
    result := AString;
end;

function TOutlookControl.ConvertToCurrency(Value: double): double;
begin
  if FCurrency = 0 then begin
    result := Value;
    EXIT;
  end;

  if assigned(FToolkit) then
    with FToolkit.Functions do
      result := entConvertAmount(Value, 0, FCurrency, 0);
end;

function TOutlookControl.ConvertToThisCurrency(FromCurrency: Integer;
  Value: double): double;
begin
  if assigned(FToolkit) then
    with FToolkit.Functions do
      result := entConvertAmount(Value, FromCurrency, FCurrency, 0);
end;

procedure TOutlookControl.CrackDrillDownInfo(const DrillDownInfo: WideString);
var
  Leaf : TGmXmlNode;
begin
  FXML := TgmXML.Create(nil);
  if assigned(FXML) then
  try
    with FXML do begin
      FXML.Text := DrillDownInfo;

      FClickedColumn := 0;
      Leaf := Nodes.NodeByName['column'];
      if Assigned(Leaf) Then
        FClickedColumn := Leaf.AsInteger;

      FUniqueIDEtc := '';  // Default Value
      Leaf := Nodes.NodeByName['id'];
      If Assigned(Leaf) Then
        FUniqueIDEtc := Leaf.AsString;
    end;
  finally
    FreeAndNil(FXML);
  end;
end;

procedure TOutlookControl.FreeXML;
begin
  if assigned(FXML) then
    FreeAndNil(FXML);
end;

function TOutlookControl.GetCompanyCode: ShortString;
begin
  result := FCompanyCode;
end;

function TOutlookControl.GetUserID: ShortString;
begin
  result := FUserID;
end;

procedure TOutlookControl.OpenComToolkit;
begin
  if FToolkitOpen then EXIT;
  FToolkit := OpenToolkit(FDatapath, true) as IToolkit2;
  FToolkitOpen := true;
end;

procedure TOutlookControl.SetFarRightColumn;
begin
  case FAreas of
    1,
    2:    FFarRightColumn := 2; // three columns 0-2 when there are only 1 or 2 areas
    3:    FFarRightColumn := 1; // only two columns 0-1 when there are 3 or more areas
  else
    FFarRightColumn := 1; // allow for expansion to more than 3 areas
  end;
end;

procedure TOutlookControl.SetUserID(const Value: ShortString);
begin
  FUserID := Value;
end;

procedure TOutlookControl.Set_dpConfiguration(const Value: WideString);
var
  Leaf : TGmXmlNode;
begin
  FXML := TGmXML.Create(NIL); // Don't free this, leave it for the descendent to do it.
  if assigned(FXML) then
    with FXML do begin
      Text := Value;

      // Extract Company Code
      FCompanyCode := '';
      Leaf := Nodes.NodeByName['Company'];
      If Assigned(Leaf) Then
        FCompanyCode := Leaf.AsString;


      // Extract Currency
      FCurrency := 0; // default
      Leaf := Nodes.NodeByName['Currency'];
      If Assigned(Leaf) Then
        FCurrency := Leaf.AsInteger;

      // Extract Currency Symbol
      FCurrencySymbol := ''; // default
      Leaf := Nodes.NodeByName['CurrencySymbol'];
      If Assigned(Leaf) Then
        FCurrencySymbol := Leaf.AsString;

      // Extract Rows
      FRows := 10;  // Default Value
      Leaf := Nodes.NodeByName['Rows'];
      If Assigned(Leaf) Then
        FRows := Leaf.AsInteger;

      // Extract the number of Areas / columns the host is displaying
      FAreas := 1;
      Leaf := Nodes.NodeByName['Areas'];
      if assigned(Leaf) then
        FAreas := Leaf.AsInteger;
      SetFarRightColumn;
    end;
end;

function TOutlookControl.Get_dpStatus: EnumDataPlugInStatus;
// Here we tell the KPI host whether the plug-in needs configuring or we need the login screen displayed to get the userid
var
  oToolkit : IToolkit;
  i : SmallInt;
begin
  result := psConfigError;
  if FCompanyCode = '' then EXIT;

//  FCompanyCode := format('%-*s', [6, UpperCase(Trim(FCompanyCode))]); // v.004 - allow for company codes shorter than 6
  FCompanyCode := UpperCase(Trim(FCompanyCode));
//   FDataPath    := ''; // v15
  oToolkit := CoToolkit.Create;
  try
    if (oToolkit.Company.cmCount > 0) then begin
      for i := 1 to oToolkit.Company.cmCount do begin
        if (trim(oToolkit.Company.cmCompany[I].coCode) = FCompanyCode) then begin
          FDataPath := Trim(oToolkit.Company.cmCompany[I].coPath);
          BREAK;
        end;
      end;
    end;
  finally
    oToolkit := nil;
  end;

  if FDataPath = '' then EXIT; // Config Error - Invalid Company

  result := psAuthenticationError;
  if FUserId = '' then EXIT; // Authentication

  result := psConfigError;
  if FRows <= 0 then EXIT;

  result := psReady;
end;

procedure TOutlookControl.CheckIDPFile(const IDPPath: WideString);
begin
  FIdpPath := IDPPath; // v20
  with TIniFile.Create(FIdpPath) do begin
    try
      FAltCaption := ReadString('Config', 'Label', '');
//      if FAltCaption <> '' then
//        ShowMessage(format('%s: "%s"', [IDPPath, FAltCaption])); // *** TEST ONLY ***
    finally
      Free;
    end;
  end;
end;

function TOutlookControl.CheckAltCaption(const OrigCaption: WideString): WideString;
begin
  if FAltCaption = '' then
    result := OrigCaption
  else
    result := FAltCaption;
end;

procedure TOutlookControl.Set_dpHostPath(const Value: WideString);
begin
  KPIHostPath := Value;
end;

procedure TOutlookControl.Set_dpHostVersion(const Value: WideString);
begin
  KPIHostVersion := Value;
end;

initialization
  FControlList := nil;
  FOutlookControl := nil;
  FControlCount := 0;

finalization
  FControlList := nil;

end.
