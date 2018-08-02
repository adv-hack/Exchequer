{-----------------------------------------------------------------------------
 Unit Name: uAddUserLogin
 Author:    vmoura
 Purpose:
 History:

 add new dashboard login
-----------------------------------------------------------------------------}
Unit uAddUserLogin;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvGlowButton, StdCtrls, ExtCtrls, AdvPanel, AdvEdit;

Type
  TfrmAddUserLogin = Class(TForm)
    advPanel: TAdvPanel;
    btnAdd: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    Label5: TLabel;
    lblPassword: TLabel;
    Label1: TLabel;
    edtLogin: TAdvEdit;
    edtPassword: TAdvEdit;
    edtUser: TAdvEdit;
    Panel1: TPanel;
    lblInfo: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Procedure btnCancelClick(Sender: TObject);
    Procedure btnAddClick(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
  Private
    fEditUser: Boolean;
    fOldUser: String;
    fOldPass: String;
    fOldLogin: String;
    Procedure SetEditUser(Const Value: Boolean);
  Public
  Published
    Property EditUser: Boolean Read fEditUser Write SetEditUser Default False;
    Property OldUser: String Read fOldUser Write fOldUser;
    Property OldPass: String Read fOldPass Write fOldPass;
    Property OldLogin: String Read fOldLogin Write fOldLogin;
  End;

Var
  frmAddUserLogin: TfrmAddUserLogin;

Implementation

Uses uDsr, uDashSettings, udashGlobal;

{$R *.dfm}

Procedure TfrmAddUserLogin.btnCancelClick(Sender: TObject);
Begin
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: btnAddClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddUserLogin.btnAddClick(Sender: TObject);
Var
  lResult: Longword;
Begin
  {check user name}
  If edtUser.Text = '' Then
  Begin
    //Messagedlg('Please, enter a valid username!', mtInformation, [mbok], 0);
    ShowDashboardDialog('Please, enter a valid username!', mtInformation, [mbok]);

    edtUser.SetFocus;
    Abort;
  End; {If edtUser.Text = '' Then}

  {check user login}
  If edtLogin.Text = '' Then
  Begin
    //Messagedlg('Please, enter a valid login!', mtInformation, [mbok], 0);
    ShowDashboardDialog('Please, enter a valid login!', mtInformation, [mbok]);

    edtLogin.SetFocus;
    Abort;
  End; {If edtLogin.Text = '' Then}

  {check user password}
  If edtPassword.Text = '' Then
  Begin
    //Messagedlg('Please, enter a valid password!', mtInformation, [mbok], 0);
    ShowDashboardDialog('Please, enter a valid password!', mtInformation, [mbok]);

    edtPassword.SetFocus;
    Abort;
  End; {If edtPassword.Text = '' Then}

  Try
    edtUser.SetFocus;
  Except
  End;

  {if update is true, just delete the old one and add a new user}
  If fEditUser Then
    TDSR.DSR_DeleteUser(_DashboardGetDBServer, _DashboardGetDSRPort, fOldLogin);

  {create a new user and password}
  lResult := TDSR.DSR_AddNewUser(
    _DashboardGetDSRServer,
    _DashboardGetDSRPort,
    edtUser.Text,
    edtLogin.Text,
    edtPassword.Text
    );

  If lResult <> S_Ok Then
  Begin
(*    MessageDlg('Then user "' + edtLogin.Text + '" already exists.',
      mtInformation, [mbok], 0);*)
    ShowDashboardDialog('Then user "' + edtLogin.Text + '" already exists.',
      mtInformation, [mbok]);

    If fEditUser Then
      TDSR.DSR_AddNewUser(
        _DashboardGetDSRServer,
        _DashboardGetDSRPort,
        fOldUser,
        fOldLogin,
        fOldPass);

    Abort;
  End
  Else
    ModalResult := mrOK;
End;

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddUserLogin.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    Close;
End;

{-----------------------------------------------------------------------------
  Procedure: SetEditUser
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddUserLogin.SetEditUser(Const Value: Boolean);
Begin
  fEditUser := Value;

  If fEditUser Then
  Begin
    lblInfo.Caption := 'Dashboard Change User Login';
    btnAdd.Caption := '&OK';
  End
  Else
    lblInfo.Caption := 'Dashboard Add New User Login';
End;

End.

