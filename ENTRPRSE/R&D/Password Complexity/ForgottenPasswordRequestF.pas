unit ForgottenPasswordRequestF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TEditVal, oUserIntf, PasswordComplexityConst,
  EnterToTab, oSystemSetup;

type
  TfrmForgottenPasswordRequest = class(TForm)
    lblSecQuestion: TLabel;
    lblAnswer: TLabel;
    edtAnswer: TEdit;
    btnResetPassword: TButton;
    btnCancel: TButton;
    lblInstructions: TLabel;
    lblQuestion: TLabel;
    EnterToTab1: TEnterToTab;
    procedure btnResetPasswordClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FUserDetailsIntf: IUserDetails;
    FIsValidUser: Boolean;
    FAttempt,
    FSuspendFailureCount: Integer;
    FUserSecurityQuesAns: String;
    procedure SetQuestion;
    function ValidateAnswer: Boolean;
    procedure Init;
  public
  end;

procedure DisplayForgottenPasswordDlg(AOwner: TComponent; AUserDetailsIntf: IUserDetails);

implementation

{$R *.dfm}

uses
  VarRec2u, Math, AuditIntf;

//------------------------------------------------------------------------------

procedure DisplayForgottenPasswordDlg(AOwner: TComponent; AUserDetailsIntf: IUserDetails);
var
  lfrmForgottenPasswordRequest: TfrmForgottenPasswordRequest;
begin
  lfrmForgottenPasswordRequest := TfrmForgottenPasswordRequest.Create(AOwner);
  try
    with lfrmForgottenPasswordRequest do
    begin
      FUserDetailsIntf := AUserDetailsIntf;
      Init;
      ShowModal;
    end;
  finally
    if Assigned(lfrmForgottenPasswordRequest) then
      Freeandnil(lfrmForgottenPasswordRequest);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmForgottenPasswordRequest.btnResetPasswordClick(Sender: TObject);
var
  lRes: Integer;
begin
  if (FIsValidUser) then
  begin
    if ValidateAnswer then
    begin
      Screen.Cursor := crHourGlass;
      try
        lRes := FUserDetailsIntf.ResetPassword(True, True, MsgTypeForgettenPwd);
        if lRes = 0 then
          MessageDlg (msgForgottenPasswordSucess, mtInformation, [mbOK], 0)
        else
        begin
          //RB 25/09/2017 2017-R2 ABSEXCH-18984: 3.1 Exchequer Login Screen - Auditing
          {$IFDEF ENTER1}
            if (lRes = 4) then
              NewAuditInterface(atLogin, amForgottenPwrdIncorredtDefSettings).WriteAuditEntry;
          {$ENDIF}
          MessageDlg(FUserDetailsIntf.ResetPasswordErrorDescription(lRes), mtError, [mbOk], 0);
        end;
      finally
        Screen.Cursor := crDefault;
        Close;
      end;
    end
    else
    begin
      MessageDlg(msgIncorrectAnswer, mtInformation,[mbOk],0);
      if (FSuspendFailureCount > 0) and (FAttempt >= FSuspendFailureCount) then
      begin
        FUserDetailsIntf.udUserStatus := usSuspendedLoginFailure;
        FUserDetailsIntf.Save;
        MessageDlg((Format(msgSuspendUser, [IntToStr(FAttempt)])), mtInformation, [mbOK], 0);
        Close;
        //To Do Close Login Scree.
      end;
    end;
  end
  else
  begin
    MessageDlg(msgIncorrectAnswer, mtInformation,[mbOk],0);
    Close;
    //To Do Close Login Scree.
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmForgottenPasswordRequest.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

//------------------------------------------------------------------------------

procedure TfrmForgottenPasswordRequest.Init;
begin
  FIsValidUser := FUserDetailsIntf.udUserName <> EmptyStr;
  if FIsValidUser then
    FUserSecurityQuesAns := FUserDetailsIntf.udSecurityQuesAns;
  with SystemSetup(True) do
  begin
    if PasswordAuthentication.SuspendUsersAfterLoginFailures then
      FSuspendFailureCount := PasswordAuthentication.SuspendUsersLoginFailureCount
    else
      FSuspendFailureCount := 0;
  end;
  FAttempt := 0;
  SetQuestion;
end;

//------------------------------------------------------------------------------

procedure TfrmForgottenPasswordRequest.SetQuestion;
begin
  if Assigned(FUserDetailsIntf) and (FIsValidUser) and (FUserDetailsIntf.udSecurityQuesId > 0) then
    lblQuestion.Caption := SecurityQuestionList[FUserDetailsIntf.udSecurityQuesId]
  else
    lblQuestion.Caption := SecurityQuestionList[RandomRange(1, 6)]
end;

//------------------------------------------------------------------------------

function TfrmForgottenPasswordRequest.ValidateAnswer: Boolean;
begin
  if AnsiCompareText(FUserSecurityQuesAns, Trim(edtAnswer.Text)) = 0 then
    Result := True
  else
  begin
    //RB 25/09/2017 2017-R2 ABSEXCH-18984: 3.1 Exchequer Login Screen - Auditing
    NewAuditInterface(atLogin, amForgottenPwrdIncorrectAnswer).WriteAuditEntry;
    Result := False;
    Inc(FAttempt);
  end;
end;

//------------------------------------------------------------------------------

end.
