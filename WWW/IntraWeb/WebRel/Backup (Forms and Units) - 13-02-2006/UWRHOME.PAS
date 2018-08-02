unit uWRHome;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompButton, IWCompEdit, Classes,
  Controls, IWControl, IWCompLabel, WebSec_TLB, IWLayoutMgr,
  IWTemplateProcessorHTML, IWCompListbox;

type
  TfrmHome = class(TIWAppForm)
    lblUserID: TIWLabel;
    lblPassword: TIWLabel;
    edUserID: TIWEdit;
    edPassword: TIWEdit;
    bnLogin: TIWButton;
    TemplateProcessor: TIWTemplateProcessorHTML;
    procedure bnLoginClick(Sender: TObject);
    procedure edUserIDSubmit(Sender: TObject);
  private
    function isDistributorUser: boolean;
    function isHQAccount: boolean;
    function isInternalCall: boolean;
  end;

implementation

{$R *.dfm}

uses uWRServer, uWRSite, uWRData, uPermissionIDs, uCodeIDs, SysUtils;

//*** Event Handlers ***********************************************************

procedure TfrmHome.edUserIDSubmit(Sender: TObject);
begin
  ActiveControl:= edPassword;
end;

procedure TfrmHome.bnLoginClick(Sender: TObject);
begin
  {Authenticate the user and validate their permission to run WebRel; If the user
   fails either test, terminate the application with the last error message;
   Otherwise, store the user code for further security validation and log whether
   they are an internal or external user; Validate the user for each of the
   security tabs and store the permissions in the session Pages set; Display the
   site page and check the user's password; If the password has expired, notify
   the user that it has been changed and that a new one has been emailed to them;}

  with UserSession, Security do
  begin
    if Authenticate(edUserID.Text, edPassword.Text) = 0 then
    begin
      if Validate(edUserID.Text, pidRunWebRel) = 0 then
      begin
        UserCode:= edUserID.Text;
        InternalHQUser:= isHQAccount and isInternalCall;
        DistributorUser:= isDistributorUser or isHQAccount;
        WRData.LoadRecipients;
        InitUser;

        if Validate(UserCode, pidSecEnterprise) = 0 then Pages:= Pages + [npEnterprise];
        if Validate(UserCode, pidSecModules) = 0 then Pages:= Pages + [npModules];
        if Validate(UserCode, pidSecPlugs) = 0 then Pages:= Pages + [npPlugIns];
        if Validate(UserCode, pidSecVectron) = 0 then Pages:= Pages + [npVectron];
        if Validate(UserCode, pidSecOther) = 0 then Pages:= Pages + [npOther];
        TfrmSite.Create(WebApplication).Show;
        Release;

        if isPasswordExpired then
        begin
          WebApplication.ShowMessage('Your password has expired and a new password has been emailed to you.' + #13#10#13#10 + 'The next time you login to this website you will need to use your new password.');
          AdminLog(0, itLogin, 'Password expired for ' + edUserID.Text);
        end;
      end
      else
      begin
        WebApplication.Terminate('You do not have permission to run this application. Please contact your local Exchequer representative or support@exchequer.com.');
        AdminLog(0, itLogin, edUserID.Text + ' tried to run WebRel without the RunWebRel permission');
      end;
    end
    else
    begin
      case Get_LastErrorCode of
        usNonExistentUser, usPasswordFailed:
        begin
          // 18/09/2003 AB Changed this code so that failed logins cause the entry boxes to be clear and the
          // login page is effectively redisplayed.
          // WebApplication.Terminate('The application login has failed because either the UserID or Password is incorrect.');
          edUserID.Text := ''; edPassword.Text := '';
          WebApplication.ShowMessage('The application login has failed because either the UserID or Password is incorrect.',smAlert,'');
          if isInternalCall then AdminLog(0, itLogin, 'Login failed for UserID:' + edUserID.Text + ', Password:' + edPassword.Text + ', Internal IP:' + WebApplication.IP)
          else AdminLog(0, itLogin, 'Login failed for UserID:' + edUserID.Text + ', Password:' + edPassword.Text + ', External IP:' + WebApplication.IP);
        end;
        usUserInactive:
        begin
          WebApplication.Terminate('This account is currently suspended. Please contact your local Exchequer representative or support@exchequer.com.');
          AdminLog(0, itLogin, 'User ' + edUserID.Text + ' failed to login because their account is disabled');
        end;
        else
        begin
          WebApplication.Terminate('Application authentication error: ' + IntToStr(Get_LastErrorCode) + '. Please contact your local Exchequer representative or support@exchequer.com.');
          AdminLog(0, itLogin, 'Application authentication error for UserID:' + edUserID.Text + ', Password:' + edPassword.Text);
        end;
      end;
    end;
  end;
end;

//*** Helper Functions *********************************************************

function TfrmHome.isInternalCall: boolean;
begin
  {The website is being used internally if the calling IP address is either of
   those listed;}

  isInternalCall:= (Pos('10.', WebApplication.IP) = 1) or (Pos('127.', WebApplication.IP) = 1);
end;

function TfrmHome.isHQAccount: boolean;
begin
  {An HQ account is being used if the security object returns 0 from an isHQUser
   call with the user code supplied;}

  with UserSession.Security do
  begin
    isHQAccount:= isHQUser(edUserID.Text) = usSuccessful;
  end;
end;

function TfrmHome.isDistributorUser: boolean;
begin
  {A distributor user will have a parent with a grouptype of gtDistributor,
   indicating they are a distributor and not a dealer or HQ;}

  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select grouptype from usergroups a inner join users b ');
    Sql.Add('on a.groupid = b.groupid ');
    Sql.Add('where b.usercode = :pusercode ');
    ParamByName('pusercode').AsString:= Trim(UpperCase(edUserID.Text));
    Open;

    Result:= not(eof) and (FieldByName('GroupType').AsInteger = gtDistributor);
  end;
end;

//******************************************************************************

end.
