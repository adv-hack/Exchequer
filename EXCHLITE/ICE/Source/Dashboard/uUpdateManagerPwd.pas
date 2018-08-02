{-----------------------------------------------------------------------------
 Unit Name: uUpdateManagerPwd
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uUpdateManagerPwd;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvEdit, AdvGlowButton, ExtCtrls, AdvPanel,
  uADODSR, uCommon, uConsts,
  ufrmbase
  ;

const
  cINFO = '%s Update Manager Password';  

Type
  //TfrmUpdateManagerPwd = Class(TForm)
  TfrmUpdateManagerPwd = Class(TFrmbase)
    pnlUpdateManager: TAdvPanel;
    Label5: TLabel;
    lblPassword: TLabel;
    btnUpdate: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    edtNewPass: TAdvEdit;
    edtConfirmPass: TAdvEdit;
    Label1: TLabel;
    edtOldPassword: TAdvEdit;
    Panel1: TPanel;
    lblInfo: TLabel;
    Label3: TLabel;
    Procedure btnCancelClick(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure btnUpdateClick(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  Private
    fDB: TADODSR;
//    fUser: String;
//    fisManager: Boolean;
  Public
  Published
//    Property User: String Read fUser Write fUser;
//    property IsManager: Boolean read fisManager write fIsManager;
  End;

Var
  frmUpdateManagerPwd: TfrmUpdateManagerPwd;

Implementation

Uses udashSettings, uDSR, udashGlobal;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: btnCloseClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmUpdateManagerPwd.btnCancelClick(Sender: TObject);
Begin
  Close;
End;


{-----------------------------------------------------------------------------
  Procedure: FormClose
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmUpdateManagerPwd.FormClose(Sender: TObject;
  Var Action: TCloseAction);
Begin
  If Assigned(fDb) Then
    FreeAndNil(fDb);
End;

{-----------------------------------------------------------------------------
  Procedure: btnUpdateClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmUpdateManagerPwd.btnUpdateClick(Sender: TObject);
Var
  lPass: String;
Begin
  If Assigned(fDb) Then
  Begin
    lPass := fDb.GetAdminPassword;

    {check if both passwords are equal}
    If Lowercase(trim(edtOldPassword.Text)) <> Lowercase(trim(lPass)) Then
    Begin
      //MessageDlg('The actual password you typed does not match.', mtError, [mbOK], 0);
      ShowDashboardDialog('The actual password you typed does not match.', mtError, [mbOK]);

      If edtOldPassword.CanFocus Then
        edtOldPassword.SetFocus;
      Abort;
    End; {If Lowercase(trim(edtOldPassword.Text)) <> Lowercase(trim(lPass)) Then}

    {check empty passwords}
    If edtNewPass.Text = '' Then
    Begin
      //MessageDlg('Invalid Password!', mtError, [mbOK], 0);
      ShowDashboardDialog('Invalid Password!', mtError, [mbOK]);

      If edtNewPass.CanFocus Then
        edtNewPass.SetFocus;
      Abort;
    End; {If edtNewPass.Text = '' Then}

    If edtConfirmPass.Text = '' Then
    Begin
      //MessageDlg('Invalid Password!', mtError, [mbOK], 0);
      ShowDashboardDialog('Invalid Password!', mtError, [mbOK]);

      If edtConfirmPass.CanFocus Then
        edtConfirmPass.SetFocus;

      Abort;
    End; {If edtConfirmPass.Text = '' Then}

    {check if both passwords are equal}
    If Lowercase(trim(edtNewPass.Text)) <> Lowercase(trim(edtConfirmPass.Text)) Then
    Begin
      //MessageDlg('The passwords you typed do not match. Type the password in both text boxes.', mtError, [mbOK], 0);
      ShowDashboardDialog('The passwords you typed do not match. Type the password in both text boxes.', mtError, [mbOK]);

      Abort;
    End
    Else
    Begin
      If TDSR.DSR_SetAdminPassword(_DashboardGetDSRServer,
        _DashboardGetDSRPort, trim(edtNewPass.Text)) = S_OK Then
      Begin
        If edtOldPassword.CanFocus Then
          edtOldPassword.SetFocus;
        //MessageDlg('Password updated!', mtInformation, [mbok], 0);
        ShowDashboardDialog('Password updated!', mtInformation, [mbok]);

        ModalResult := mrOK;
      End;
    End; {begin}
  End; {if Assigned(fDb) then}
End;

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmUpdateManagerPwd.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    btnCancelClick(Sender);
End;

procedure TfrmUpdateManagerPwd.FormCreate(Sender: TObject);
begin
  inherited ;


  Try
    fDb := TADODSR.Create(_DashboardGetDBServer);
  Except
    On e: exception Do
    Begin
      ShowDashboardDialog('An exception has occurred connecting the database:' + #13#13 + E.Message, mterror, [mbok]);
      _LogMSG('Error connecting database. Error: ' + e.message);
    End;
  End;

  CheckCIS(_DashboardGetDBServer);

  lblInfo.Caption := Format(cINFO, [_GetProductName(glProductNameIndex)]);
end;

End.

