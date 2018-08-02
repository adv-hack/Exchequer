unit AuthenticateUserTKUtil;

{------------------------------------------------------------------------------}
{ This unit is a mediator and serves Login functionality for Common Login Dialogs
{ (Scheduler and OLEDataQuery)
{ Note: When adding any unit into uses please make sure to compile all above Projects}
{------------------------------------------------------------------------------}

interface

uses Forms, Classes, SysUtils, APIUtil, VarRec2U, PasswordComplexityConst,
     {$IFNDEF OLEDATAQUERY}
       oSystemSetup, AuditIntf, SchedVar, VarConst,
     {$ELSE}
       Enterprise01_TLB,
     {$ENDIF}
     DailyPW, Btrvu2,
     Dialogs, ETStrU, Crypto, GlobVar, ETDateU, Controls,
     CTKUtil;

type
  TSetFocusUserEvent = procedure(Sender: TObject) of object;
  TCheckUserProc = function(const AUserID, APassWord: ShortString): SmallInt of Object;
  TSetUserInfoEvent = procedure(const AuthenticationMode, AUserID, AWinID: String) of object;

  function XLogoEnabled: Boolean;
  function GetWinUserOfFirstLogin(): String;
  function GetAuthenticationMode(const ACompPath: String = ''): String;
  procedure InitAuditInfo;
  procedure SetAuditUser(AUserName: String);
  function GetCompanyDrive: String;
  //routine for oledataquery
  function AuthenticateUser(const AUserName, APassword, ACompPath, AAreaCodeName: String; const AAreaCode: Integer; var AFailedAttempt: Byte): Integer; overload;
  //routine for scheduler
  function AuthenticateUser(const AUserName, APassword: String): Integer; overload;
  function AuthenticationErrorDescription(const AAuthError: Integer): String;
  function AuthenticateSystemUser(const AUserID, APassword: String): Boolean;
  function ValidateUser(const AUserID, APassword: String;
                        var AFailedAttempt: Byte;
                        const ALoginDialog: TLoginDialog;
                        var AUserSuspended: Boolean;
                        ACompNamePath: String = '';
                        AAreaCodeName: String = '';
                        AAreaCode: Integer = 0): Boolean;
  procedure DisplayForgottenPwrdDialog(AOwner: TComponent; AUserID: String);

var
  OnCheckValidUser : TCheckUserProc;
  OnSetFocusUserEvent: TSetFocusUserEvent;
  OnSetUserInfoEvent: TSetUserInfoEvent;

implementation

{------------------------------------------------------------------------------}

function GetWinUserOfFirstLogin(): String;
var
  lWinLogin : String;
  lStatus : SmallInt;
begin
  lWinLogIn := UpCaseStr(WinGetUserName);
  if Assigned(OnCheckValidUser) then
  begin
    lStatus := OnCheckValidUser(Trim(lWinLogIn), '');
    if (lStatus = 0) or (lStatus = 30002) then
      Result := Trim(lWinLogIn);
  end;
end;

{------------------------------------------------------------------------------}

procedure InitAuditInfo;
begin
  {$IFNDEF OLEDATAQUERY}
    with AuditSystemInformation do
    begin
      asCompanyDirectory := SetDrive;
      asApplicationVersion := SchedulerVersion;
      asCompanyName := Syss.UserName;
    end;
  {$ENDIF}
end;

{------------------------------------------------------------------------------}
function GetAuthenticationMode(const ACompPath: String = ''): String;
{$IFDEF OLEDATAQUERY}
var
  lToolkit: IToolkit;
{$ENDIF}
begin
  {$IFDEF OLEDATAQUERY}
  try
    lToolkit := OpenToolkit(ACompPath, true);
    with lToolkit.SystemSetup as ISystemSetup16 do
      Result := ssLoginAuthenticationMode;
  finally
    if Assigned(ltoolkit) then
    begin
      lToolkit.CloseToolkit;
      lToolkit := nil;
    end;
  end;
  {$ELSE}
    Result := SystemSetup.PasswordAuthentication.AuthenticationMode;
  {$ENDIF}
end;


{------------------------------------------------------------------------------}

function AuthenticateUser(const AUserName, APassword: String): Integer; overload;
var
  lRes, lStatus: Integer;
  lPos: Smallint;
  lExpired: Boolean;
  lDaysLeft: Longint;
  lKeyS: Str255;

  function FullPWordKey (RC,ST        :  Char;
                         Login        :  Str20)  :  Str20;
  begin
    FullPWordKey := RC + ST + LJVar(Login, 10);
  end;
begin
  {$IFNDEF OLEDATAQUERY}
    Result := -1;
    lKeyS := FullPWordKey('P', 'D', AUserName);
    lStatus := Find_Rec(B_GetEq, F[MLocF], MLocF, RecPtr[MLocF]^, MLK, lKeyS);
    lRes := OnCheckValidUser(AUserName, APassword);
    if lRes = 0 then
    begin
      if GetAuthenticationMode = AuthMode_Exchequer then
      begin
        if MLocCtrl.PassDefRec.UserStatus = usActive then
        begin
          // Password Never Expired
          if MLocCtrl.PassDefRec.PWExpMode = PWExpModeNeverExp then
            Result := 0;
          // Password Expired after Some Days
          if MLocCtrl.PassDefRec.PWExpMode = PWExpModeExpDays then
          begin
            lDaysLeft := NoDays(Today, MLocCtrl.PassDefRec.PWExpDate);
            lExpired := lDaysLeft < 0;
            if (not lExpired) and (lDaysLeft <= 10) and (lDaysLeft <> 0) then
            begin
              Result := 0;
              MessageDlg(format(msgPwdExpireWarning, [Form_Int(lDaysLeft,0), PoutDate(MLocCtrl.PassDefRec.PWExpDate)]), mtWarning, [mbOk], 0);
            end
            else
            begin
              if not lExpired then
                Result := 0
              else
              begin
                MLocCtrl.PassDefRec.UserStatus := usPasswordExpired;
                MLocCtrl.PassDefRec.PWExpMode := PWExpModeExpired;
                lStatus := Put_Rec(F[MLocF], MLocF, RecPtr[MLocF]^,MLK);
                if lStatus <> 0 then
                  Result := 2004;
              end;
            end;
          end; {PWExpModeExpDays}
          // Password Expired
          if MLocCtrl.PassDefRec.PWExpMode = PWExpModeExpired then
            Result := 2003;
        end {if MLocCtrl.PassDefRec.UserStatus = usActive then}
        else if (MLocCtrl.PassDefRec.UserStatus = usPasswordExpired) and (MLocCtrl.PassDefRec.PWExpMode = PWExpModeExpired) then
          Result := 2003
        else
          Result := 2002; //suspended user
      end {if GetAuthenticationMode = AuthMode_Exchequer then}
      else if GetAuthenticationMode = AuthMode_Windows then
        Result := 0; //validation  for Windows Authentication is already done OnCheckValidUser
    end
    else
      Result := 2001; // Invalid User
  {$ENDIF}
end;

function AuthenticationErrorDescription(const AAuthError: Integer): String;
begin
  case AAuthError of
    2001  : Result := msgInvalidUser;
    2002  : Result := msgSuspendedUser;
    2003  : Result := msgPwdExpired;
    //2004  : Result := Self.SaveErrorDescription(AAuthError);
  else
    Result := msgUnknownError + IntToStr(AAuthError);
  end;
end;

{------------------------------------------------------------------------------}

function AuthenticateSystemUser(const AUserID, APassword: String): Boolean;
var
  lPwd,
  lDailySystemPass,
  lDailyDirectorPass: String;
  lValidPass: Boolean;

  {$IFNDEF OLEDATAQUERY}
    function CheckSysPassword(const s: string): Boolean;
    var
      i : integer;
    begin
       if Trim(s) = Trim(Get_TodaySecurity) then
       begin
         Result := True;
         for i := 0 to 9 do
           ViewsAllowed[i] := True;
         AllViewsAllowed := True;
       end
       else
         Result := False;
    end;
  {$ENDIF}
begin
  {$IFNDEF OLEDATAQUERY}
    lDailySystemPass := Get_TodaySecurity;
    lValidPass := CheckSysPassword(APassword);
    if not lValidPass then
      MessageDlg(msgInvalidUser, mtError, [mbOk], 0)
    else
      SBSIn := ((lPwd=SBSPass2) or (lPwd=lDailySystemPass) or (lPwd=lDailyDirectorPass));
    Result := lValidPass;
  {$ENDIF}
end;

{------------------------------------------------------------------------------}

function ValidateUser(const AUserID, APassword: String;
                      var AFailedAttempt: Byte;
                      const ALoginDialog: TLoginDialog;
                      var AUserSuspended: Boolean;
                      ACompNamePath: String = '';
                      AAreaCodeName: String = '';
                      AAreaCode: Integer = 0): Boolean;
var
  lRes,
  lStatus: Integer;
begin
  Result := False;
  {$IFNDEF OLEDATAQUERY}
    // Validate SYSTEM User
    if AnsiCompareText(AUserID, SBSDoor) = 0 then
    begin                                        
      Result := AuthenticateSystemUser(AUserID, APassword);
      if not Result then
        NewAuditInterface(atLogin, Format(amLoginIncorectUserNamePassword, [AuditSystemInformation.asExchequerUser])).WriteAuditEntry;
      Exit;
    end;
  {$ENDIF}

  {$IFDEF OLEDATAQUERY}
    lRes := AuthenticateUser(AUserId, APassword, ACompNamePath, AAreaCodeName, AAreaCode, AFailedAttempt);
    if lRes = 0 then
      Result := True
    else
    begin
      Result := False;
      MessageDlg(AuthenticationErrorDescription(lRes), mtError, [mbOk], 0);
    end;
  {$ELSE}
    if Assigned(OnCheckValidUser) then
    begin
      lRes := AuthenticateUser(AUserID, APassword);
      if lRes = 0 then
        Result := True
      else
      begin
        Result := False;
        MessageDlg(AuthenticationErrorDescription(lRes), mtError, [mbOk], 0);
        case lRes of
          2001  : NewAuditInterface(atLogin, Format(amLoginIncorectUserNamePassword, [AuditSystemInformation.asExchequerUser])).WriteAuditEntry;
          2002  : NewAuditInterface(atLogin, Format(amLoginUserSuspended, [AuditSystemInformation.asExchequerUser])).WriteAuditEntry;
          2003  : NewAuditInterface(atLogin, Format(amLoginPasswordExpired, [AuditSystemInformation.asExchequerUser])).WriteAuditEntry;
        end;

        // Check User Login fail attempt and Set Status SuspendedLoginFailure
        if (lRes = 2001) and { (GetAuthenticationMode <> AuthMode_Windows) and }
           (MLocCtrl.PassDefRec.UserStatus = usActive) and
           (SystemSetup.PasswordAuthentication.SuspendUsersAfterLoginFailures) then
        begin
          if Assigned(OnSetFocusUserEvent) then
            OnSetFocusUserEvent(nil);

          if (Trim(MLocCtrl.PassDefRec.Login) = Trim(AUserID)) or
             (AnsiCompareText(Trim(MLocCtrl.PassDefRec.WindowUserId), Trim(AUserID)) = 0) then
            Inc(AFailedAttempt);

          if AFailedAttempt >= SystemSetup.PasswordAuthentication.SuspendUsersLoginFailureCount then
          begin
            MLocCtrl.PassDefRec.UserStatus := usSuspendedLoginFailure;
            lStatus := Put_Rec(F[MLocF], MLocF, RecPtr[MLocF]^,MLK);
            if lStatus = 0 then
              MessageDlg((Format(msgSuspendUser, [IntToStr(AFailedAttempt)])), mtInformation, [mbOK], 0);
            AUserSuspended := True;
          end;
        end;
      end; {Else End}
    end  {if Assigned(OnCheckValidUser) then}
    else
      MessageDlg(msgUnknownError , mtError, [mbOk], 0);
  {$ENDIF}

  if Result and Assigned(OnSetUserInfoEvent) then
    OnSetUserInfoEvent('', Trim(AUserID), Trim(AUserID));
end;

{------------------------------------------------------------------------------}

function GetCompanyDrive: String;
begin
  Result := SetDrive;
end;

{------------------------------------------------------------------------------}

procedure SetAuditUser(AUserName: String);
begin
  {$IFNDEF OLEDATAQUERY}
    AuditSystemInformation.asExchequerUser := Trim(AUserName);
  {$ENDIF}
end;

{------------------------------------------------------------------------------}

function XLogoEnabled: Boolean;
begin
  Result := NoXLogo;
end;

{------------------------------------------------------------------------------}

procedure DisplayForgottenPwrdDialog(AOwner: TComponent; AUserID: String);
begin
  //No support of ForgottenPwrd and change password for Oledataquery and scheduler.
end;

{------------------------------------------------------------------------------}

function AuthenticateUser(const AUserName, APassword, ACompPath, AAreaCodeName: String; const AAreaCode: Integer; var AFailedAttempt: Byte): Integer; overload;
{$IFDEF OLEDATAQUERY}
  var
    FuncRes: Integer;
    Res: Integer;
    FToolkit: IToolkit;
    lLoginOk: Boolean;
    lUserID: string;
{$ENDIF}
begin
  {$IFDEF OLEDATAQUERY}
    lLoginOk := false;
    FToolkit := OpenToolkit(ACompPath, true);
    try
      if not assigned(FToolkit) then
         ShowMessage('Couldn''t open the COM Toolkit')
      else
      begin
        FuncRes := FToolkit.Functions.entCheckPassword(AUserName, APassword);
        lLoginOk := FuncRes = 0;     
        if not lLoginOk then
        Begin
          AFailedAttempt := AFailedAttempt - 1;
          if Assigned(OnSetFocusUserEvent) then
            OnSetFocusUserEvent(nil);
          Result := 2001;
        end
        else
        begin
          // Resetting OK back to true as the login has been accepted
          // Resetting the Login Attempts to 3
          AFailedAttempt := 3;
          lUserID := AUserName;

          if lUserID <> EmptyStr then
          begin
            Res := FToolkit.Functions.entCheckSecurity(lUserID, AAreaCode);   // SSK 01/06/2018 2018-R1.1 ABSEXCH-20574: Windows Login will be handled inside entCheckSecurity
            if Res = 1 then
               ShowMessage('You do not have the required permissions to access the ' + AAreaCodeName + ' information through the Excel Add-Ins')
            else
            begin
              if Res = 1000 then
                ShowMessage('Users security information not found')
              else
              begin
                if Res = 1001 then
                  ShowMessage('Area code out of range')
              end;
            end;
          end
          else
            Res := 2001;
        end;
      end;
    finally
      if FToolkit <> nil then
      begin
        FToolkit.CloseToolkit;
        FToolkit := nil;
      end;
    end;
  {$ENDIF}
end;

end.

