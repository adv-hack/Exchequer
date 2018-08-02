unit AuthenticateUserUtil;

{------------------------------------------------------------------------------}
{ This unit is a mediator and serves Login functionality for Common Login Dialogs
{ (Enter1, Importer, Sentinel, OLEServer, OLEDrillDown, Ebusiness
{ Note: When adding any unit into uses please make sure to compile all above Projects}
{------------------------------------------------------------------------------}

interface

{$IFNDEF IMPv6}
  {$IFNDEF OLE}     // this conditional define added to work with OLE Server
    {$I DEFOVR.Inc}
  {$ENDIF OLE}
{$ENDIF IMPv6}

uses Forms, Classes, oUserIntf, oUserDetail, SysUtils, VarRec2U, PasswordComplexityConst,
     AuditIntf, oSystemSetup, Dialogs, SysU2, ETStrU, VarConst, Crypto, SecSup2U, HelpSupU,
     {$IFDEF SEC500} BTSupU1, oMCMSec, VarFPosU, Excep2U, {$ENDIF}
     {$IFDEF IMPV6} GlobalConsts, Utils, VAOUtil, {$ENDIF}
     BTSupU2, ForgottenPasswordRequestF, ChangePasswordF, GlobVar, ETDateU, Controls;

type
  {AP:01/10/2017 ABSEXCH-19378:Importer - When Running the Job: It gives error related to Invalid User Name or Password}
  TInitImporterEvent = procedure(Sender: TObject) of object;
  TSetFocusUserEvent = procedure(Sender: TObject) of object;
  TSetUserInfoEvent = procedure(const AuthenticationMode, AUserID, AWinID: String) of object;

  {$IFDEF S2}
    function GetWinUserOfFirstLogin(): String;
  {$ENDIF}
  procedure ProcessSecurity(var AUserCountCaption: String {$IFDEF SEC500}; var AoMCMSecurity: TMCMSecurity {$ENDIF});
  function GetAuthenticationMode: String;
  function GetUserDetailObj(const AUserID: String): IUserDetails;
  function AuthenticateSystemUser(const AUserID, APassword: String): Boolean;
  function ValidateUser(const AUserID, APassword: String;
                        var AFailedAttempt: Byte;
                        const ALoginDialog: TLoginDialog;
                        var AUserSuspended: Boolean): Boolean;
  function ValidateNonCoreLoginSecurity(const ALoginDialog: TLoginDialog; FUserDetailIntf: IUserDetails): Boolean;
  procedure InitAuditInfo;
  procedure DisplayForgottenPwrdDialog(AOwner: TComponent; AUserID: String);
  function GetCompanyDrive: String;
  procedure SetAuditUser(AUserName: String);
  function XLogoEnabled: Boolean;
  procedure SetCurrCompPath(ACurrCompPath: String);

var
  OnInitImportEvent: TInitImporterEvent;
  OnSetFocusUserEvent: TSetFocusUserEvent;
  OnSetUserInfoEvent: TSetUserInfoEvent;


implementation

{------------------------------------------------------------------------------}

{$IFDEF S2}
function GetWinUserOfFirstLogin(): String;
var
  lWinUserID: string;
begin
  if (EntryRec^.Login = EmptyStr) and (EnSecurity) then {If this is the first login, suggest the windows user name}
  begin
    lWinUserID := UpCaseStr(WinGetUserName);
    {$B-}
      if (lWinUserID <> EmptyStr) and (GetLogInRec(lWinUserID)) then
    {$B+}
      Result := lWinUserID;
  end;
end;
{$ENDIF}

{------------------------------------------------------------------------------}
//ProcessSecurity is only used for Exchequer core login dialog.
procedure ProcessSecurity(var AUserCountCaption: String {$IFDEF SEC500}; var AoMCMSecurity: TMCMSecurity {$ENDIF});
var
  lRes: Integer;
  lLocked: Boolean;
  lTries: Integer;
begin
  {$IFDEF SEC500}
    AoMCMSecurity := nil;
    {Create MCM Security Object for Enterprise v5.00 Security}
    AoMCMSecurity := TMCMSecurity.Create (ssEnterprise, SyssMod^.ModuleRel.CompanyID);
    try
      {Reset Company User Counts if exclusive access was gained, otherwise check the user counts}
      if ULFirstIn then
      begin
        {HM 30/01/02: Reset to False otherwise UCounts get reset using File-Open Company}
        ULFirstIn := False;

        {Reset any user counts for the Company Id across all components (Entrprse, Toolkit, Trade, etc...)}
        lRes := AoMCMSecurity.ResetSystemSecurityEx;
        if lRes = 0 then
        begin
          if Syss.EntULogCount <> 0 then // Reset the internal Enterprise User Count in Syss if set
          begin
            lLocked := True;
            if GetMultiSys(True, lLocked, SysR) and lLocked then
            begin
              Syss.EntULogCount := 0;
              PutMultiSys(SysR, True);
            end; { If GetMultiSys }
          end; { If (Syss.EntULogCount > 0) }

          {Reset the User Counts for other modules in SyssMod if any are set}
          if (SyssMod^.ModuleRel.TKLogUCount <> 0) or             // Toolkit
             (SyssMod^.ModuleRel.TrdLogUCount <> 0) then          // Trade Counter
          begin
            lLocked := True;
            if GetMultiSys(True, lLocked, ModRR) and lLocked then
            begin
              SyssMod^.ModuleRel.TKLogUCount := 0;
              SyssMod^.ModuleRel.TrdLogUCount := 0;
              PutMultiSys(ModRR, True);
            end; { If GetMultiSys }
          end; { If }
        end { If (lRes = 0) }
        else
        begin
          {Failed to reset MCM User Counts - Add error log and notify user}
          AddErrorLog('Error Resetting User Count',
                      'An error ' + IntToStr(lRes) + ' occurred resetting the Logged-In User Counts', 0);         // System generated error
          MessageDlg ('An error ' + IntToStr(lRes) + ' occurred resetting the Logged-In User Counts, ' +
                      'Please contact your Technical Support', mtError, [mbOk], 0);
        end; { Else }
      end { If ULFirstIn }
      else
      begin
        { Users already logged in - do a consistency check on the duplicate user counts,
          this prevents one data set from being used in more that one MCM at a time.
          NOTE: Written as a loop with automatic retries as this inconsistency may
          occur naturally in the window between the security record being added in
          Company.Dat and Syss being updated with the new count}

        lTries := 0;
        repeat
          lLocked := False; // Refresh Syss just in case someone else has just logged in
          GetMultiSys(False, lLocked, SysR);

          lRes := AoMCMSecurity.msTotalUsers; // Get current number of users logged-in according to Company.Dat

          if Syss.EntULogCount <> lRes then
          begin
            Delay(200, True); // Mismatch - delay for 1/5th second before retrying
            Inc(lTries);
          end; { If (Syss.EntULogCount <> Res) }
        until (Syss.EntULogCount = lRes) or (lTries = 5);

        if Syss.EntULogCount <> lRes then
        begin
          { User Count mismatch - could be system error changing the user counts or
            the user is running this data set from more than one MCM simultaneously
            (which breaks the licence agreement) }

          AddErrorLog('User Count Mismatch',
                      'Program User Count: ' + IntToStr(Syss.EntULogCount) + #13#10 +
                      'Security User Counts: ' + IntToStr(lRes), 0);         // System generated error

          MessageDlg ('The Security Sub-System found an inconsistency in the licence details, please contact ' +
                      'your Technical Support Helpline for advice', mtWarning, [mbOk], 0);
        end; { if Syss.EntULogCount <> lRes then }
      end; { Else }
      {v5.00 Security - user counts stored in Company.Dat}
      AUserCountCaption := Format ('User Count: %d / %d', [AoMCMSecurity.msLicencesUsed, AoMCMSecurity.msLicenceCount]);
    finally

    end;
  {$ENDIF}

  {$IFNDEF SEC500}
    with Syss do      {Old Pre-v5.00 security - user counts stored in Syss}
      AUserCountCaption := 'User Count: ' + Form_Int(Succ(Syss.EntULogCount), 0) + ' / ' + Form_Int(DeCode_Usrs(ExUsrSec,ExUsrRel),0);
  {$ENDIF}
end;

{------------------------------------------------------------------------------}

procedure InitAuditInfo;
begin
  with AuditSystemInformation do
  begin
    {$IFDEF IMPV6}
      asApplicationVersion := APPVERSION;
      asCompanyDirectory := VAOInfo.vaoCompanyDir;
    {$ELSE}
      asCompanyDirectory := SetDrive;
      asApplicationDescription := 'Exchequer';
      asApplicationVersion := CurrVersion;
    {$ENDIF}
    asCompanyName := Syss.UserName;
  end;
end;

{------------------------------------------------------------------------------}

function GetAuthenticationMode: String;
begin
  Result := SystemSetup(True).PasswordAuthentication.AuthenticationMode;
end;

{------------------------------------------------------------------------------}

function GetUserDetailObj(const AUserID: String): IUserDetails;
var
  lUserDetailObj: TUserDetail;
  lUserPassDetailRec: tPassDefType;
begin
  FillChar(lUserPassDetailRec, SizeOf(lUserPassDetailRec), #0);
  if GetAuthenticationMode = AuthMode_Exchequer then
    lUserPassDetailRec.Login := UpperCase(Trim(AUserID))
  else
    lUserPassDetailRec.WindowUserId := UpperCase(Trim(AUserID));
  lUserDetailObj := CreateUser(0, umLogin, lUserPassDetailRec);

  if Assigned(lUserDetailObj) then
    Result := lUserDetailObj
  else
    Result := nil;
end;

{------------------------------------------------------------------------------}
//Check user's access permission for its respective LoginDialog.
function ValidateNonCoreLoginSecurity(const ALoginDialog: TLoginDialog; FUserDetailIntf: IUserDetails): Boolean;

  //--------------------------
  function CheckNonCoreSecurity(const AUserName: Shortstring; const aAreaCode: LongInt): Boolean;
  begin
    Result := False;
    if (aAreaCode > High(FUserDetailIntf.udUserAccessRec.Access)) or (aAreaCode < Low(FUserDetailIntf.udUserAccessRec.Access)) then
      MessageDlg(errAreaCodeRange, mtError, [mbOk], 0)
    else
    begin
      if GetLogInRec(UpperCase(AUserName)) then
        Result := FUserDetailIntf.udUserAccessRec.Access[aAreaCode] = 1
      else
        MessageDlg(errUserSecurity, mtError, [mbOk], 0);
    end;
  end;
  //--------------------------

begin
  Result := True;
  if ALoginDialog = ldSentimail then
  begin
    Result := CheckNonCoreSecurity(Trim(FUserDetailIntf.udUserName), pAccessSentimail);
    if not Result then
      MessageDlg(Format(errSentimailSecurity, [Trim(FUserDetailIntf.udUserName)]), mtError, [mbOk], 0)
  end;
  if ALoginDialog = ldeBusiness then
  begin
    Result := CheckNonCoreSecurity(Trim(FUserDetailIntf.udUserName), pAccessEBusiness);
    if not Result then
      MessageDlg(Format(errEbusinessSecurity, [Trim(FUserDetailIntf.udUserName)]), mtError, [mbOk], 0);
  end;

  {$IFDEF IMPV6}
    if (ALoginDialog = ldImporter) and (Assigned(OnInitImportEvent)) then
    begin
      {AP:01/10/2017 ABSEXCH-19378:Importer - When Running the Job: It gives error related to Invalid User Name or Password}
      OnInitImportEvent(nil);

      //SS:10/10/2017:2017-R2:ABSEXCH-19432:'Windows User ID' is displayed in Exchequer instead of 'Username' of the User when data is Imported using Importer
      LoginDisplayName := BlowFishEncrypt(FUserDetailIntf.udUserName);

      //SS:10/10/2017:ABSEXCH-19378:Importer: When Running the Job: It gives error related to Invalid User Name or Password.
      if SystemSetup.PasswordAuthentication.AuthenticationMode = AuthMode_Windows then
        LoginUserName := BlowFishEncrypt(FUserDetailIntf.udWindowUserId)
      else
        LoginUserName := BlowFishEncrypt(FUserDetailIntf.udUserName);
    end;
  {$ENDIF}

  if Result and Assigned(OnSetUserInfoEvent) then
    OnSetUserInfoEvent(GetAuthenticationMode, Trim(FUserDetailIntf.udUserName), Trim(FUserDetailIntf.udWindowUserId));
end;

{------------------------------------------------------------------------------}

function AuthenticateSystemUser(const AUserID, APassword: String): Boolean;
var
  lPwd,
  lDailySystemPass,
  lDailyDirectorPass: String;
  lValidPass: Boolean;
begin
  lDailySystemPass := Get_TodaySecurity;
  lDailyDirectorPass := Calc_TodayPW2;

  lPwd := UpcaseStr(Strip('B',[#32], APassword));
  GetLoginRec(SBSDoor);
  with EntryRec^ do
  begin
    Login := SBSDoor;
    PWord := EnCode(SBSPass2);
    lValidPass := (((Strip('B',[#32],DeCode(PWord))=lPwd))
                    or (((((lPwd=lDailySystemPass) and (Not Syss.IgnoreBDPW)) or
                        (lPwd=lDailyDirectorPass))
                    and(Syss.LastDaily<DateTimeToFileDate(Now)))));
    if not lValidPass then
      MessageDlg(msgInvalidUser, mtError, [mbOk], 0)
    else
      SBSIn := ((lPwd=SBSPass2) or (lPwd=lDailySystemPass) or (lPwd=lDailyDirectorPass));

    Result := lValidPass;
  end;
end;

{------------------------------------------------------------------------------}

function ValidateUser(const AUserID, APassword: String;
                      var AFailedAttempt: Byte;
                      const ALoginDialog: TLoginDialog;
                      var AUserSuspended: Boolean): Boolean;
var
  FUserDetailIntf: IUserDetails;
  lRes: Integer;
begin
  Result := False;
  // Validate SYSTEM User
  if AnsiCompareText(AUserID, SBSDoor) = 0 then
  begin
    Result := AuthenticateSystemUser(AUserID, APassword);
    if not Result then
      NewAuditInterface(atLogin, Format(amLoginIncorectUserNamePassword, [AuditSystemInformation.asExchequerUser])).WriteAuditEntry;
    Exit;
  end;
  FUserDetailIntf := GetUserDetailObj(AUserID);
  if Assigned(FUserDetailIntf) then
  begin
    lRes := FUserDetailIntf.AuthenticateUser(AUserID, APassword);
    if lRes = 0 then
      Result := True
    else
    begin
      Result := False;
      MessageDlg(FUserDetailIntf.AuthenticationErrorDescription(lRes), mtError, [mbOk], 0);
      //RB 25/09/2017 2017-R2 ABSEXCH-18984: 3.1 Exchequer Login Screen - Auditing
      case lRes of
        2001  : NewAuditInterface(atLogin, Format(amLoginIncorectUserNamePassword, [AuditSystemInformation.asExchequerUser])).WriteAuditEntry;
        2002  : NewAuditInterface(atLogin, Format(amLoginUserSuspended, [AuditSystemInformation.asExchequerUser])).WriteAuditEntry;
        2003  : NewAuditInterface(atLogin, Format(amLoginPasswordExpired, [AuditSystemInformation.asExchequerUser])).WriteAuditEntry;
      end;
      // Check User Login fail attempt and Set Status SuspendedLoginFailure
      if (lRes = 2001) and {(GetAuthenticationMode <> AuthMode_Windows) and}
      (FUserDetailIntf.udUserStatus = usActive) and
      SystemSetup.PasswordAuthentication.SuspendUsersAfterLoginFailures then
      begin
        if Assigned(OnSetFocusUserEvent) then
          OnSetFocusUserEvent(nil);

        if (Trim(FUserDetailIntf.udUserName) = Trim(AUserID)) or
           (AnsiCompareText(Trim(FUserDetailIntf.udWindowUserId), Trim(AUserID)) = 0) then
          Inc(AFailedAttempt);

        if AFailedAttempt >= SystemSetup.PasswordAuthentication.SuspendUsersLoginFailureCount then
        begin
          FUserDetailIntf.udUserStatus := usSuspendedLoginFailure;
          if FUserDetailIntf.Save > 0 then
            MessageDlg(FUserDetailIntf.SaveErrorDescription(lRes), mtError, [mbOk], 0)
          else
            MessageDlg((Format(msgSuspendUser, [IntToStr(AFailedAttempt)])), mtInformation, [mbOK], 0);
          AUserSuspended := True;
        end;
      end;
    end;  // Else End

    if Result then
    begin
      if (GetAuthenticationMode = AuthMode_Exchequer) and (AnsiCompareText(AUserID, SBSDoor) <> 0) then
      begin
        {Here user will have to forcefully change the password or the access application will be denied}
        if FUserDetailIntf.udForcePwdChange then
          lRes := DisplayChangePasswordDlg(nil, FUserDetailIntf, False)
        else if (FUserDetailIntf.udPwdExpMode = PWExpModeExpDays) and (FUserDetailIntf.udPwdExpDate = Today) then
        begin
          { if the password expires today it will warn the user irrespective of him changing the password it will let the user enter the application}
          if MessageDlg(msgPwdExpireToday, mtWarning, [mbYes, mbNo], 0) = mrYes then
            DisplayChangePasswordDlg(nil, FUserDetailIntf, False);
        end;
      end; {if AnsiCompareText(txtUserName.Text, SBSDoor) <> 0 then}
    end;
    Result := (lRes = 0) and ValidateNonCoreLoginSecurity(ALoginDialog, FUserDetailIntf);
  end
  else
    MessageDlg(msgUnknownError , mtError, [mbOk], 0);  
end;

{------------------------------------------------------------------------------}

procedure DisplayForgottenPwrdDialog(AOwner: TComponent; AUserID: String);
var
  lUserDetailObj: TUserDetail;
  lUserPassDetailRec: tPassDefType;
  FUserDetailIntf: IUserDetails;
  lExpired: Boolean;
  lDaysLeft: Longint;
begin
  FillChar(lUserPassDetailRec, SizeOf(lUserPassDetailRec), #0);
  lUserPassDetailRec.Login := Trim(AUserID);
  lUserDetailObj := CreateUser(0, umLogin, lUserPassDetailRec);
  FUserDetailIntf := lUserDetailObj;
  if Assigned(FUserDetailIntf) then
  begin
    if (FUserDetailIntf.udUserName <> EmptyStr) and
       ((FUserDetailIntf.udUserStatus <> usActive) or (FUserDetailIntf.udPwdExpMode = PWExpModeExpired)) then
    begin
      MessageDlg(msgUserInActive, mtError, [mbOK], 0);
      if FUserDetailIntf.udPwdExpMode = PWExpModeExpired then
        NewAuditInterface(atLogin, Format(amLoginPasswordExpired, [AuditSystemInformation.asExchequerUser])).WriteAuditEntry
      else
        NewAuditInterface(atLogin, Format(amLoginUserSuspended, [AuditSystemInformation.asExchequerUser])).WriteAuditEntry;
    end
    else if (FUserDetailIntf.udUserName <> Emptystr) and
            ((FUserDetailIntf.udSecurityQuesAns = EmptyStr) or (FUserDetailIntf.udEmailAddr = EmptyStr)) then
    begin
      MessageDlg(msgForgottenPasswordNotAvailable, mtError, [mbOK], 0);
      //RB 25/09/2017 2017-R2 ABSEXCH-18984: 3.1 Exchequer Login Screen - Auditing
      if (FUserDetailIntf.udSecurityQuesAns = EmptyStr) then
        NewAuditInterface(atLogin, amForgottenPwrdSecurityQuesAnsNotSet).WriteAuditEntry
      else if (FUserDetailIntf.udEmailAddr = EmptyStr) then
        NewAuditInterface(atLogin, amForgottenPwrdEmailNotProvided).WriteAuditEntry;
    end
    else
    begin
      lDaysLeft := NoDays(Today, FUserDetailIntf.udPwdExpDate);
      lExpired := (lDaysLeft < 0) and (FUserDetailIntf.udPwdExpMode = PWExpModeExpDays);
      if lExpired and (FUserDetailIntf.udUserStatus = usActive) then
      begin
        FUserDetailIntf.udPwdExpMode := PWExpModeExpired;
        FUserDetailIntf.Save;
        MessageDlg(msgUserInActive, mtError, [mbOK], 0);
      end
      else
        DisplayForgottenPasswordDlg(AOwner, FUserDetailIntf);
    end;
  end;
end;

{------------------------------------------------------------------------------}

function GetCompanyDrive: String;
begin
  {$IFDEF IMPV6}
    Result := VAOInfo.vaoCompanyDir;
  {$ELSE}
    Result := SetDrive;
  {$ENDIF}
end;

{------------------------------------------------------------------------------}

procedure SetAuditUser(AUserName: String);
begin
  //RB 25/09/2017 2017-R2 ABSEXCH-18984: 3.1 Exchequer Login Screen - Auditing
  AuditSystemInformation.asExchequerUser := Trim(AUserName);
end;

{------------------------------------------------------------------------------}

function XLogoEnabled: Boolean;
begin
  Result := NoXLogo;
end;

{------------------------------------------------------------------------------}

procedure SetCurrCompPath(ACurrCompPath: String);
begin
  SetDrive := ACurrCompPath;
end;

end.

