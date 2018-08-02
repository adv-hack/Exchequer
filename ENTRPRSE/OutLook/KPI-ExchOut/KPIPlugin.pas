unit KPIPlugin;

{* COMMENTS IN CAPITALS HIGHLIGHT CODE WHICH WOULD USUALLY NEED TO BE ALTERED TO SUIT EACH PLUG-IN *}

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, IRISEnterpriseKPI_TLB, StdVcl, IKPIHost_TLB, GmXML, oAuthenticationState, Windows, Forms,
  TOutlookControlClass, TAccountStatusClass;

const
  Debug_Mode = FALSE;

type
  TExchequerOut = class(TAutoObject, IDataListPlugin, IDataPlugin)
  private
    // The unique Id for this instance of the plug-in which identifies messages sent into
    // the OCX as being from this plug-in
    FMessageId : HWND;
    FIDPFile: string;

  protected
    function Configure(HostHandle: Integer): WordBool; safecall;
    function DrillDown(HostHandle, MessageHandle: Integer; const UniqueID: WideString): WordBool; safecall;
    function Get_dlpColumns: WideString; safecall;
    function Get_dpAuthenticationID: WideString; safecall;
    function Get_dpAuthenticationRequest: WideString; safecall;
    function Get_dpCaption: WideString; safecall;
    function Get_dpConfiguration: WideString; safecall;
    function Get_dpDisplayType: EnumDataPlugInDisplayType; safecall;
    function Get_dpMessageID: Integer; safecall;
    function Get_dpPluginID: WideString; safecall;
    function Get_dpStatus: EnumDataPlugInStatus; safecall;
    function Get_dpSupportsConfiguration: WordBool; safecall;
    function Get_dpSupportsDrillDown: WordBool; safecall;
    function GetData: WideString; safecall;
    procedure Authenticate(const AuthenticationInfo: WideString); safecall;
    procedure CheckIDPFile(const IDPPath: WideString); safecall;
    procedure Set_dpConfiguration(const Value: WideString); safecall;
    procedure Set_dpMessageID(Value: Integer); safecall;
    procedure Set_dpHostPath(const Value: WideString); safecall;
    procedure Set_dpHostVersion(const Value: WideString); safecall;
  public
    procedure Initialize; override;
  end;

procedure DebugLine(ALine: string);

implementation

uses Classes, ComServ, Contnrs, Dialogs, IniFiles, Math, SysUtils, Enterprise01_TLB,
     Controls, CTKUtil, ShellAPI, FileUtil;


procedure DebugLine(ALine: string);
const
  DEBUG_FILE = 'C:\KPIDebug.txt';
begin
  with TStringList.Create do begin
  try
    if FileExists(DEBUG_FILE) then
      LoadFromFile(DEBUG_FILE);
    Add(ALine);
    SaveToFile(DEBUG_FILE);
  finally
    free;
  end; end;
end;

 {TExchequerOut}

procedure TExchequerOut.CheckIDPFile(const IDPPath: WideString); {* CHECK IDP FILE FOR PLUG-IN CONFIGURATION *}
// can't check the IDP file until we get this control's unique message ID
begin
  if Debug_Mode then DebugLine(format('CheckIDPFile: IDPPath = %s', [IDPPath]));
  FIDPFile := IDPPath;
  SetOutlookControl(IDPPath, FMessageID); // Create a new control using the details in the IDP file; Calls the controls CheckIDPFile method
end;

function TExchequerOut.Configure(HostHandle: Integer): WordBool; {* DISPLAY CONFIGURATION FORM *}
begin
  if Debug_Mode then DebugLine(format('Configure: HostHandle = %d', [HostHandle]));
  if ODDC <> nil then begin
    if Debug_Mode then DebugLine('Configure ' + ODDC.Get_dpPluginID);
    result := ODDC.Configure(HostHandle);
  end
  else
//    ShowMessage('No control assigned in Configure');
end;

function TExchequerOut.DrillDown(HostHandle, MessageHandle: Integer; const UniqueID: WideString): WordBool;
begin
  if Debug_Mode then DebugLine(format('DrillDown: HostHandle = %d, MessageHandle = %d, UniqueID = %s', [HostHandle, MessageHandle, UniqueID]));
  if ODDC <> nil then
    result := ODDC.DrillDown(HostHandle, MessageHandle, UniqueID)
  else
//    ShowMessage('No control assigned in DrillDown');
end;

function TExchequerOut.Get_dlpColumns: WideString; {* DESCRIBE THE REQUIRED COLUMNS TO THE KPI HOST *}
begin
  if ODDC <> nil then
    result := ODDC.Get_dlpColumns
  else;
//    ShowMessage('No control assigned in Get_dlpColumns');
  if Debug_Mode then DebugLine(format('Get_dlpColumns: %s', ['' {result}]));
end;

function TExchequerOut.Get_dpCaption: WideString; {* SET THE PLUG-IN'S CAPTION *}
begin
  if ODDC <> nil then
    result := ODDC.Get_dpCaption
  else;
//    ShowMessage('No control assigned in Get_dpCaption');
  if Debug_Mode then DebugLine(format('Get_dpCaption: %s', [result]));
end;

function TExchequerOut.Get_dpConfiguration: WideString; {* RETURN THE CURRENT CONFIGURATION TO THE KPI HOST *}
begin
  if ODDC <> nil then
    result := ODDC.Get_dpConfiguration
  else;
//    ShowMessage('No control assigned in Get_dpConfiguration');
  if Debug_Mode then DebugLine(format('Get_dpConfiguration: %s', [result]));
end;

function TExchequerOut.Get_dpDisplayType: EnumDataPlugInDisplayType;
begin
  if ODDC <> nil then
    result := ODDC.Get_dpDisplayType
  else;
//    ShowMessage('No control assigned in get_dpDisplayType');
  if Debug_Mode then DebugLine(format('Get_dpDisplayType: %d', [ord(result)]));
end;

function TExchequerOut.Get_dpPluginID: WideString; {* IDENTIFY THIS PLUG-IN TO THE KPI HOST *}
begin
  if ODDC <> nil then
    result := ODDC.Get_dpPluginID
  else;
//    ShowMessage('No control assigned in Get_dpPluginID');
  if Debug_Mode then DebugLine(format('Get_dpPluginID: %s', [result]));
end;

function TExchequerOut.Get_dpSupportsConfiguration: WordBool; {* DOES THE PLUG-IN USE CONFIGF ? *}
begin
  if ODDC <> nil then
    result := ODDC.Get_dpSupportsConfiguration
  else;
//    ShowMessage('No control assigned in Get_dpSupportsConfiguration');
  if Debug_Mode then DebugLine(format('Get_dpSupportsConfiguration: %d', [ord(result)]));
end;

function TExchequerOut.Get_dpSupportsDrillDown: WordBool; {* CAN A ROW BE DOUBLE-CLICKED TO PROVIDE MORE INFO FROM EXCHEQUER ? *}
begin
  if ODDC <> nil then
    result := ODDC.Get_dpSupportsDrillDown
  else;
//    ShowMessage('No control assigned in dpSupportsDrillDown');
  if Debug_Mode then DebugLine(format('Get_dpSupportsDrillDown: %d', [ord(result)]));
end;

function TExchequerOut.GetData: WideString; {* RETURN DATA TO KPI HOST IN XML STRING *}
begin
  if ODDC <> nil then
    result := ODDC.GetData
  else;
//    ShowMessage('No control assigned in GetData');
  if Debug_Mode then DebugLine(format('GetData: %s', ['' {result}]));
end;

procedure TExchequerOut.Set_dpConfiguration(const Value: WideString); {* DECODE THE XML CONFIGURATION FROM THE KPI HOST *}
begin
  if Debug_Mode then DebugLine(format('Set_dpConfiguration: %s', [Value]));
  if ODDC <> nil then
    ODDC.Set_dpConfiguration(Value)
  else
//    ShowMessage('No control assigned in Set_dpConfiguration');
//  CheckStatus;
end;

//===== Common Methods =======

function TExchequerOut.Get_dpAuthenticationID: WideString;
begin
  Result := 'IRISEnterprise';
  if Debug_Mode then DebugLine(format('Get_dpAuthenticationID: %s', [result]));
end;

function TExchequerOut.Get_dpAuthenticationRequest: WideString;
Var
  FAuthReq : TEnterpriseAuthenticationRequirements;
Begin
  FAuthReq := TEnterpriseAuthenticationRequirements.Create;
  Try
    if ODDC <> nil then
      FAuthReq.Company := ODDC.ocCompanyCode;
    Result := FAuthReq.Requirements;
    if Debug_Mode then DebugLine(format('Get_dpAuthenticationRequest: %s', [FAuthReq.Company]));
  Finally
    FAuthReq.Free;
  End;
end;

function TExchequerOut.Get_dpMessageID: Integer;
begin
  Result := FMessageId;
  if Debug_Mode then DebugLine(format('Get_dpMessageID: %d', [result]));
end;

function TExchequerOut.Get_dpStatus: EnumDataPlugInStatus;
begin
  if ODDC <> nil then
    result := ODDC.Get_dpStatus
  else
    result := psConfigError;
  if Debug_Mode then DebugLine(format('Get_dpStatus: %d', [ord(result)]));
end;

procedure TExchequerOut.Authenticate(const AuthenticationInfo: WideString);
// Receive the login details from the KPI Host
Var
  oAuth : TCompanyAuthentication;
Begin
  oAuth := TCompanyAuthentication.Create(AuthenticationInfo);
  Try
    if ODDC <> nil then
      if (UpperCase(Trim(oAuth.Company)) = UpperCase(Trim(ODDC.ocCompanyCode))) then
        ODDC.ocUserID := oAuth.User;
    if Debug_Mode then DebugLine(format('Authenticate: Company = %s, User = %s', [oAuth.Company, oAuth.User]));
  Finally
    oAuth.Free;
  End;
end;

procedure TExchequerOut.Set_dpMessageID(Value: Integer);
begin
  if Debug_Mode then DebugLine(format('Set_dpMessageID: %d', [Value]));
  FMessageId := Value; // remember the current MessageID so we can use it in CheckIDPFile to create a new control
//  ShowMessage(format('MessageId: %d, IDPFile: %s', [Value, FIDPFile]));

  SetOutlookControl('', Value); // find the control with the corresponding MessageID.
                                // if there isn't one, a new one won't be created until the host calls CheckIDPFile
end;

procedure TExchequerOut.Initialize;
begin
  inherited Initialize;  //   TAutoObject.Initialize
end;

procedure TExchequerOut.Set_dpHostPath(const Value: WideString);
begin
  if ODDC <> nil then
    ODDC.Set_dpHostPath(Value);
end;

procedure TExchequerOut.Set_dpHostVersion(const Value: WideString);
begin
  if ODDC <> nil then
    ODDC.Set_dpHostVersion(Value);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExchequerOut, Class_ExchequerOut, ciMultiInstance, tmApartment);

end.
