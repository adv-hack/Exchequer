Unit ADOConnect;

Interface

{$IFNDEF EXSQL}
  //This unit should not be compiled in
{$ENDIF}

Uses ADODB, Forms, Controls,ExchConnect;

Var
  // CJS 2011-07-19: ABSEXCH-11620 - Global SQL connection should no longer be read-only
  GlobalADOConnection : TExchConnection;

Procedure InitialiseGlobalADOConnection (Const DataPath : ShortString);
Procedure TerminateGlobalADOConnection;
function ResetConnection(const aDataPath: ShortString): Boolean;

Implementation

Uses SQLUtils, Dialogs;

//=========================================================================

Procedure InitialiseGlobalADOConnection (Const DataPath : ShortString);
Var
  CompanyCode, ConnectionString, lPassword: WideString;
  lRes: Integer;
Begin // InitialiseGlobalADOConnection
  CompanyCode := GetCompanyCode(DataPath);

  // CJS 2011-07-19: ABSEXCH-11620 - Global SQL connection should no longer be read-only
  //GetConnectionString(CompanyCode, False, ConnectionString);

  //SS:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  lRes := GetConnectionStringWOPass(CompanyCode, False, ConnectionString, lPassword);

  { PL 10/12/2017 2018R1 : ABSEXCH-19449 When running Workstation Setup for
    Exchequer on local drive when setup to run through mapped drive for services, error returned }
  if ConnectionString = '' then
    Exit;

  GlobalADOConnection := TExchConnection.Create(nil);
  GlobalADOConnection.ConnectionString := ConnectionString;
  GlobalAdoConnection.Password := lPassword;


  {AP 18-05-2017: ABSEXCH-18710 - UI- Currency Update Confirmation Screen
  LoginDialogExProc dialog gets initializ in initialization block of DBLogDlg.pas
  a databse login propmt}
  GlobalADOConnection.LoginPrompt := False;
  if lRes = 0 then
    GlobalADOConnection.Open;
  If (GlobalADOConnection.Errors.Count > 0) then
  Begin
    MessageDlg ('InitialiseGlobalADOConnection: ' + GlobalADOConnection.Errors.Item[GlobalADOConnection.Errors.Count - 1].Description, mtError, [mbOK], 0);
    GlobalADOConnection := NIL;
  End; // If (GlobalADOConnection.Errors.Count > 0)
End; // InitialiseGlobalADOConnection

//-------------------------------------------------------------------------

Procedure TerminateGlobalADOConnection;
Begin // TerminateGlobalADOConnection
  If Assigned(GlobalADOConnection) Then
  Begin
    If GlobalADOConnection.Connected Then
      GlobalADOConnection.Close;
    GlobalADOConnection.Free;
    GlobalADOConnection := NIL;
  End; // GlobalADOConnection
End; // TerminateGlobalADOConnection

//=========================================================================

//RB 29/06/2017 2017-R2 ABSEXCH-18914: SQL connection fixes from Delphi end.
//Function to Reset GlobalAdoConnection
function ResetConnection(const aDataPath: ShortString): Boolean;
var
  lCompanyCode,
  lConnectionString,
  lPassword: WideString;
  lRes: Integer;
begin
  Screen.Cursor := crHourGlass;
  try
    GlobalADOConnection.Close;
    lCompanyCode := GetCompanyCode(aDataPath);
    //GetConnectionString(lCompanyCode, False, lConnectionString);

    //SS:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
    lRes := GetConnectionStringWOPass(lCompanyCode, False, lConnectionString, lPassword);
    GlobalADOConnection.ConnectionString := lConnectionString;
    GlobalAdoConnection.Password := lPassword;
    if lRes = 0 then
      GlobalADOConnection.Open;
    Application.ProcessMessages;
  finally
    Result := GlobalADOConnection.Connected;
    Screen.Cursor := crDefault;
  end;
end;
Initialization
  GlobalADOConnection := NIL;
End.