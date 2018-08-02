unit TTimesheetClass;

{* COMMENTS IN CAPITALS HIGHLIGHT CODE WHICH WOULD USUALLY NEED TO BE ALTERED TO SUIT EACH PLUG-IN *}

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, IRISEnterpriseKPI_TLB, StdVcl, IKPIHost_TLB, GmXML, Windows, Forms, TOutlookControlClass, TTimesheetDataClass, TTimesheetIniClass{,
  EnterpriseSecurity_TLB}, oEntSec;

type
  TTimesheet = class(TOutlookControl)
  private
    FExclusiveOp: WordBool;

{* PLUG-IN CONFIGURATION *}      // from the plugin's idp file [Config] section

{* DATA FILTERS *}               // from the <username>.dat file (maintained using ConfigF)
    FEmployeeID: ShortString;    // Employee ID
    FEmployeeName: ShortString;  // Employee Name

{*  FIELDS SPECIFIC TO THIS PLUG-IN *}
    procedure CheckUserAuth;
  public
    procedure CheckIDPFile(const IDPPath: WideString); override;
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
     EnterpriseSecurity_TLB, Controls, TimesheetConfigForm, CTKUtil, ShellAPI, FileUtil, TimesheetListForm, IRISTimesheets_TLB;

var
  GThirdParty: IThirdParty;
  FSecurityStatus: string;
  GUserGotData: integer;
  GCOMServer: IODDTimesheets;

procedure UserCounting;
var
  rc: integer;
  MaxUserCount: integer;
  CurrentUsers: integer;
begin
  GThirdParty := CreateOleObject('EnterpriseSecurity.ThirdParty') as IThirdParty;
  try
    with GThirdParty do
    begin
      tpSystemIdCode := 'EXCHODDTIM000201';
      tpSecurityCode := '!f%h&4hj(%Fgh£^%';
      tpDescription  := 'Outlook Dynamic Dashboard Timesheets';
      tpSecurityType := SecUserCountOnly; //

      rc := ReadSecurity;
      if rc <> 0 then begin
        FSecurityStatus := format('Error: %s', [LastErrorString]);
        EXIT;
      end;

      MaxUserCount := tpUserCount;
      CurrentUsers := tpCurrentUsers;
      if CurrentUsers = MaxUserCount then begin
        FSecurityStatus := format('Maximum users reached: %d', [MaxUserCount]);
        EXIT;
      end;

      rc := AddUserCount;
      if rc <> 0 then begin
        FSecurityStatus := format('Error: %s', [LastErrorString]);
        EXIT;
      end;

    end;

    FSecurityStatus := 'OK'; // Comment this line out for testing - FSecurityStatus will be displayed as this ODD Control's data in Outlook

    GCOMServer := CreateOLEObject('IRISTimesheets.ODDTimesheets') as IODDTimesheets;
    if assigned(GCOMServer) then begin
      GComServer.Startup('EXCHODDTIM000201', '!f%h&4hj(%Fgh£^%');
    end
    else
      ShowMessage('No Com Server');

  finally
    GThirdParty := nil; // v17
  end;
end;

function TTimesheet.Configure(HostHandle: Integer): WordBool; {* DISPLAY CONFIGURATION FORM *}
Var
  frmConfigurePlugIn : TfrmConfigureTimesheets;
Begin // Configure
  frmConfigurePlugIn := TfrmConfigureTimesheets.Create(ocDataPath);
  Try
    with frmConfigurePlugIn do begin {* COPY CURRENT FILTERS ETC. TO THE FORM CONTROLS *}
      Caption    := 'Configure Timesheets [' + ocCompanyCode + ']';
      Company    := ocCompanyCode;
      ConfigCurrency   := ocCurrency;
      ConfigCurrSymb   := ocCurrencySymbol;
      Host       := HostHandle;
      EmployeeID := FEmployeeID;
      EmployeeName := FEmployeeName;
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
          ocUserId           := '';
          ocUserIsAuthorised := false;
        end;
        ocCompanyCode    := Company;
        ocCurrency       := ConfigCurrency;
        ocCurrencySymbol := ConfigCurrSymb;
        FEmployeeID      := EmployeeID;
        FEmployeeName    := EmployeeName;
      end;
    End;
  Finally
    FreeAndNIL(frmConfigurePlugIn);
  End;
end;

function TTimesheet.DrillDown(HostHandle: integer; MessageHandle: Integer; const UniqueID: WideString): WordBool;
{* WHAT TO DO WITH THE UNIQUE ID WHEN THE USER DOUBLE-CLICKS A DISPLAYED ROW OF DATA *}
Var
  PosEndUserID: integer;
  UserID: string;
Begin // DrillDown
  CrackDrillDownInfo(UniqueID);

  FExclusiveOp := true;
  try
    ShowTimesheetListForm(ocDataPath, ocUniqueIDEtc, FEmployeeName, ocUserID);
  finally
    FExclusiveOp := false;
  end;

  result := true; // tell the host to refresh the displayed data.
end;

function TTimesheet.Get_dlpColumns: WideString; {* DESCRIBE THE REQUIRED COLUMNS TO THE KPI HOST *}
var
  ColumnTitle: string;
begin
//  ShowMessage(format('DataPath: %s, EmployeeID: %s', [ocDataPath, FEmployeeID]));

  TimesheetSettings(ocDataPath).EmpCode := FEmployeeID;
  if TimesheetSettings.ShowTotalCharge then
    ColumnTitle := 'Total Charge' + '(' + ocCurrencySymbol + ')'
  else
    if TimesheetSettings.ShowTotalCost then
      ColumnTitle := 'Total Cost' + '(' + ocCurrencySymbol + ')'
  else
    ColumnTitle := 'Total Hours';

  CheckUserAuth;

//  if ocUserIsAuthorised then
    if ocAreas < 3 then
      Result :=
        '<Columns>' +
        '  <Column Title="Emp ID"    Type="String" Align="Left"  Width="15%" BackColor="#EEEEFF"></Column>' +
        '  <Column Title="Employee Name"    Type="String" Align="Left"  Width="60%" ></Column>' +
        '  <Column Title="' + ColumnTitle + '" Type="String" Align="Right" Width="25%" FontStyle="Normal"></Column>' +
        '</Columns>'
    else
      Result :=
        '<Columns>' +
        '  <Column Title="Employee Name"    Type="String" Align="Left"  Width="60%" ></Column>' +
        '  <Column Title="' + ColumnTitle + '" Type="String" Align="Right" Width="40%" FontStyle="Normal"></Column>' +
        '</Columns>'
//  else
//    result := '<Columns>' +
//              '  <Column Title=" " Type="String" Align="Left"  Width="100%"></Column>' + // one column to contain the error message
//              '</Columns>';
end;

function TTimesheet.Get_dpCaption: WideString; {* SET THE PLUG-IN'S CAPTION *}
begin
  result := Format('%s [%s]', [CheckAltCaption('Timesheet'), ocCompanyCode]); // v20
//  result := ocIDPPath; // for testing porpoises only
end;

function TTimesheet.Get_dpConfiguration: WideString; {* RETURN THE CURRENT CONFIGURATION TO THE KPI HOST *}
  function XMLise(ANode: string; AValue: string): string;
  begin
    result := format('<%s>%s</%0:s>', [ANode, AValue]);
  end;
begin
  Result :=          XMLise('Company', ocCompanyCode);
  result := result + XMLise('Currency', IntToStr(ocCurrency));
  result := result + XMLise('CurrencySymbol', ocCurrencySymbol);
  result := result + XMLise('EmployeeID', FEmployeeID);
  result := result + XMLise('EmployeeName', FEmployeeName);
end;

function TTimesheet.Get_dpDisplayType: EnumDataPlugInDisplayType;
begin
  Result := dtDataList;
end;

function TTimesheet.Get_dpPluginID: WideString; {* IDENTIFY THIS PLUG-IN TO THE KPI HOST *}
begin
  result := Format('timesheet', []); // DON'T INCLUDE SPACES otherwise it will not match with what's in username.dat
end;

function TTimesheet.Get_dpSupportsConfiguration: WordBool; {* DOES THE PLUG-IN USE CONFIGF ? *}
begin
  Result := True;
end;

function TTimesheet.Get_dpSupportsDrillDown: WordBool; {* CAN A ROW BE DOUBLE-CLICKED TO PROVIDE MORE INFO FROM EXCHEQUER ? *}
begin
  Result := ocUserIsAuthorised;
end;

function TTimesheet.GetData: WideString; {* RETURN DATA TO KPI HOST IN XML STRING *}
Var
  Res      : LongInt;
  I        : SmallInt;
  DispTot: double;
  ShowCharge: boolean;
  ShowCost: boolean;
  CanView:  boolean;
Begin // GetData
  if GUserGotData <> 12345 then begin
    UserCounting;
    ocUserIsAuthorised := FSecurityStatus = 'OK';
    if ocUserIsAuthorised then
      GUserGotData := 12345;
  end;

  Result := '';
  if not ocUserIsAuthorised then begin
//    result := '<Data><Row UniqueId=" "><Column>Authorisation is required to view this data</Column></Row></Data>';
    result := '<Data><Row UniqueId=" "><Column>' + FSecurityStatus + '</Column></Row></Data>';
    EXIT;
  end;

{* RETRIEVE DATA *}
  FExclusiveOp := true;
  try
//    OpenComToolkit;
//    if assigned(ocToolkit) then begin
//    try
      TimesheetSettings(ocDataPath).EmpCode := FEmployeeID;
      ShowCharge := TimesheetSettings.ShowTotalCharge;
      ShowCost   := TimesheetSettings.ShowTotalCost;
      CanView := TimesheetSettings.CanView(trim(ocUserID), FEmployeeID);
      if not CanView then begin
        Result := '<Data>';
        if ocAreas < 3 then
          result := Result + Format('<Row UniqueId="%s"><Column>%s</Column><Column>%s</Column><Column>%s</Column></Row>', [' ', FEmployeeID, 'Authorisation revoked for ' + FEmployeeID, ''])
        else
          Result := Result + Format('<Row UniqueId="%s"><Column>%s</Column><Column>%s</Column></Row>', [' ', 'Authorisation revoked for ' + FEmployeeID, '']);
        Result := Result + '</Data>';
        EXIT;
      end;

      with TTimesheetData.Create(ocDataPath, FEmployeeID) do begin
        FetchTimeSheetData;
        if ShowCharge then
          DispTot := EmployeeTotalCharge
        else
        if ShowCost then
          DispTot := EmployeeTotalCost
        else
          DispTot := EmployeeTotalHours;
      end;
      try
  {* RETURN DATA AS XML *}
        // Write the top n accounts to the XML result
        Result := '<Data>';

        if ocAreas < 3 then
          result := Result + Format('<Row UniqueId="%s"><Column>%s</Column><Column> %s</Column><Column>%0.2n</Column></Row>', [FEmployeeID, FEmployeeID, FEmployeeName, DispTot])
        else
          Result := Result + Format('<Row UniqueId="%s"><Column> %s</Column><Column>%0.2n</Column></Row>', [FEmployeeID, FEmployeeName, DispTot]);

        Result := Result + '</Data>';
      finally
      end; // Try..Finally
//    finally
//      CloseComToolkit
//    end; // Try..Finally
//    end;
  finally
    FExclusiveOp := false;
  end;
end;

procedure TTimesheet.CheckIDPFile(const IDPPath: WideString); {* CHECK IDP FILE FOR PLUG-IN CONFIGURATION *}
begin
  inherited; // v20 set ocIdpPath
//  With TIniFile.Create(IDPPath) Do
//  Begin
//    Try
//    Finally
//      Free;
//    End;
//  End; // With TIniFile.Create(IDPPath)
end;

procedure TTimesheet.Set_dpConfiguration(const Value: WideString); {* DECODE THE XML CONFIGURATION FROM THE KPI HOST *}
var
  Leaf : TGmXmlNode;
begin
    inherited;

    if assigned(ocXML) then
    try
      with ocXML do begin
        FEmployeeID := '';
        Leaf := Nodes.NodeByName['EmployeeID'];
        if assigned(Leaf) then
          FEmployeeID := Leaf.AsString;

        FEmployeeName := '';
        Leaf := Nodes.NodeByName['EmployeeName'];
        if assigned(Leaf) then
          FEmployeeName := Leaf.AsString;
      end;
    finally
      FreeXML;
    end;

//  CheckPluginStatus;
end;

procedure TTimesheet.CheckUserAuth; {* CHECK THE USER IS AUTHORISED TO VIEW THE DATA THIS PLUG-IN DISPLAYS *}
begin
  ocUserIsAuthorised := FSecurityStatus = 'OK';
end;

procedure TTimesheet.Initialize;
begin
  ocRows := 10;
end;

initialization
  GThirdParty := nil;
  FSecurityStatus := 'OK'; // v19
//  UserCounting;

finalization
//  if GThirdParty <> nil then begin
//    with GThirdParty do begin
{      Set_tpSystemIdCode('EXCHODDTIM000201');   // not sure if I really need to set these for RemoveUserCount
      Set_tpSecurityCode('!f%h&4hj(%Fgh£^%');
      Set_tpDescription('Outlook Dynamic Dashboard Timesheets');
      Set_tpSecurityType(1); //

      if GUserGotData = 12345 then
        if RemoveUserCount <> 0
          then ShowMessage(format('ODD Timesheet error %s', [#13#10 + Get_LastErrorString]));}
//      Free;
//      GThirdParty := nil;
//    end;
//  end;
end.
