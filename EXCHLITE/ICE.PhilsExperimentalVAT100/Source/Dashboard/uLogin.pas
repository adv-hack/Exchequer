{-----------------------------------------------------------------------------
 Unit Name: uLogin
 Author:    vmoura
 Purpose:  login to dashboard
 History:

ClientSync.hlp changed to dashboard.chm
-----------------------------------------------------------------------------}
Unit uLogin;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, AdvPanel, StdCtrls, uAdoDSR, AdvGlowButton, AdvEdit,

  uFrmBase
  ;

const
  cCAPTIONINFO = '%s Login';
  cINFO = 'This login is necessary for connecting to the %s.';   

Type
//  TfrmLogin = Class(TForm)
  TfrmLogin = Class(TfrmBase)
    advPanelMail: TAdvPanel;
    lblUsername: TLabel;
    lblPassword: TLabel;
    edtUserName: TAdvEdit;
    btnOk: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    edtPassword: TAdvEdit;
    Panel1: TPanel;
    lblCaptionInfo: TLabel;
    Label2: TLabel;
    lblInfo: TLabel;
    Procedure FormCreate(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    Procedure btnOkClick(Sender: TObject);
    Procedure edtUserNameKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
    Procedure btnCancelClick(Sender: TObject);
    Procedure edtUserNameExit(Sender: TObject);
    Procedure edtPasswordExit(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
  Private
    fDb: TADODSR;
  Public
  End;

Var
  frmLogin: TfrmLogin;

Implementation

Uses uDashSettings, uCommon, uDashGlobal, uConsts, SECSUP2U, uWait;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmLogin.FormCreate(Sender: TObject);
Begin
  inherited;

  {create a database connection to verify user and password}
  Try
    fDb := TADODSR.Create(_DashboardGetDBServer);
  Except
    On E: exception Do
    Begin
      ShowDashboardDialog('An exception has occurred:' + #13#13 + E.Message, mtError, [mbok]);

      _LogMSG('Error connecting database. Error: ' + e.message);
    End;
  End; {try}

  CheckCIS(_DashboardGetDBServer);

  lblCaptionInfo.Caption := Format(cCAPTIONINFO, [_GetProductName(glProductNameIndex)]);
  lblInfo.Caption := Format(cINFO, [_GetProductName(glProductNameIndex)]);
End;

{-----------------------------------------------------------------------------
  Procedure: FormDestroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmLogin.FormDestroy(Sender: TObject);
Begin
  If Assigned(fDb) Then
    FreeAndNil(fDb);

  inherited;  
End;

{-----------------------------------------------------------------------------
  Procedure: btnOkClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmLogin.btnOkClick(Sender: TObject);
Var
  lPass: String;
Begin
  If Assigned(fDb) Then
  Begin
    If fDb.Connected Then
    Begin
    {check admin password}
      lPass := fDb.GetAdminPassword;
      If lPass = '' Then
        lPass := _DecryptString(cADMINPASS);

    {test system/admin/user user}
      If (LowerCase(Trim(edtUserName.Text)) = LowerCase(cSYSTEMUSER)) And
        (LowerCase(Trim(edtPassword.Text)) = lowercase(Get_TodaySecurity)) Then
      Begin
        glUserLogin := cSYSTEMUSER;
        ModalResult := mrOK;
      End
      Else If (lowercase(Trim(edtUserName.Text)) = Lowercase(cADMINUSER)) And
        (lowercase(Trim(edtPassword.Text)) = lPass) Then
      Begin
        glUserLogin := cADMINUSER;
        ModalResult := mrOK;
      End
      Else If fDb.CheckUserAndPassword(Trim(edtUserName.Text),
        Trim(edtPassword.Text)) Then
      Begin
        glUserLogin := edtUserName.Text;
        ModalResult := mrOk;
      End
      Else
        ModalResult := mrNone;
    End; {If fDb.Connected Then}
  End; {If Assigned(fDb) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: edtUserNameKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmLogin.edtUserNameKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key In [vk_return, vk_tab] Then
    btnOkClick(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: btnCancelClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmLogin.btnCancelClick(Sender: TObject);
Begin
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: edtUserNameExit
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmLogin.edtUserNameExit(Sender: TObject);
Begin
  If fDb.Connected Then
    If Not fDb.SearchUser(Trim(edtUserName.Text)) Then
      If Not (Trim(Lowercase(edtUserName.Text)) = cADMINUSER) Then
        If Not (Trim(Lowercase(edtUserName.Text)) = cSYSTEMUSER) Then
        Begin
          If edtUserName.CanFocus Then
            edtUserName.SetFocus;
          Abort;
        End; {If Not (Trim(Lowercase(edtUserName.Text)) = cADMINUSER) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: edtPasswordExit
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmLogin.edtPasswordExit(Sender: TObject);
Begin
  If Trim(edtPassword.Text) = '' Then
  Begin
    If edtPassword.CanFocus Then
      edtPassword.SetFocus;
    Abort;
  End; {If Trim(edtPassword.Text) = '' Then}
End;

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmLogin.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = Vk_ESCAPE Then
    btnCancelClick(Sender);
End;

End.

