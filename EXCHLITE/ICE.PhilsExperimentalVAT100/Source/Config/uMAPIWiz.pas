{-----------------------------------------------------------------------------
 Unit Name: uMailWiz
 Author:    vmoura
 Purpose:
 History:

 create and update e-mail accounts
-----------------------------------------------------------------------------}
Unit uMAPIWiz;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvEdit, AdvGlowButton, ExtCtrls, AdvPanel, AdvProgressBar,
    htmlbtns;

Const
  cMESSAGE = '{313C3A3C-5B9E-4B3D-BE14-D867551E7E55}';
  cFORMHEIGHT = 343;

Type
  TfrmMAPIWiz = Class(TForm)
    advPanel: TAdvPanel;
    Label12: TLabel;
    btnAdd: TAdvGlowButton;
    btnClose: TAdvGlowButton;
    edtEmailAddress: TAdvEdit;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edtYourName: TAdvEdit;
    Label6: TLabel;
    Procedure edtYourNameChange(Sender: TObject);
    Procedure btnTestAccountClick(Sender: TObject);
    Procedure btnCloseClick(Sender: TObject);
    Procedure btnViewResultTestClick(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure btnAddClick(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
  Private
    Procedure Send;
    Procedure Receive;
  Public

  End;

Var
  frmMAPIWiz: TfrmMAPIWiz;

Implementation

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: edtYourNameChange
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMAPIWiz.edtYourNameChange(Sender: TObject);
Begin
  btnTestAccount.Enabled := (Trim(edtYourName.Text) <> '') And
    (Trim(edtEmailAddress.Text) <> '');
  btnViewResultTest.Enabled := btnTestAccount.Enabled;
End;

{-----------------------------------------------------------------------------
  Procedure: btnTestAccountClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMAPIWiz.btnTestAccountClick(Sender: TObject);
Begin
  prgTest.Visible := True;
  mmLog.Clear;
  mmLog.Lines.Add('Checking E-Mail account...');

  Application.ProcessMessages;

  Try
    Send;
    Receive;
  Except
    On e: exception Do
      mmLog.Lines.Add('Error checking E-Mail account. Error: ' + e.Message);
  End;

  mmLog.Lines.Add('End of checking E-Mail account...');

  prgTest.Visible := False;
End;

{-----------------------------------------------------------------------------
  Procedure: Receive
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMAPIWiz.Receive;
Var
  lRes: String;
Begin
(*  prgTest.Position := 80;
  lRes := 'Pass...';
  mmLog.Lines.Add('Checking POP3 login...');
  Application.ProcessMessages;

  msPOP.Host := edtPop3Server.Text;
  msPOP.UserName := edtUserName.Text;
  msPOP.Password := edtPassword.Text;

  Try
    Try
      msPOP.Login;
    Except
      On E: exception Do
        lRes := e.Message;
    End;
  Finally
    Try
      msPOP.Logout;
    Except
    End;
  End; {try..finally}

  mmLog.Lines.Add('POP3 account result : ' + lRes);
  prgTest.Position := 100;
  Application.ProcessMessages;
  Sleep(300);*)
End;

{-----------------------------------------------------------------------------
  Procedure: Send
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMAPIWiz.Send;
Var
  lRes: String;
Begin
(*  prgTest.Position := 10;
  Application.ProcessMessages;

  lRes := 'Pass...';
  Sleep(500);

  msSMTP.Host := edtSMTPServer.Text;
  msSMTP.MailMessage.Recipients.AddAddress(edtEmailAddress.Text, edtYourName.Text);
  msSMTP.MailMessage.Subject := 'Client Sync E-mail Test';
  msSMTP.MailMessage.Body.Text := 'Client Sync E-mail Test - ' + cMESSAGE;
  msSMTP.MailMessage.Sender.Name := edtYourName.Text;
  msSMTP.MailMessage.Sender.Address := edtEmailAddress.Text;

  {try sending a message first}
  Try
    msSMTP.Send;
  Except
    On E: exception Do
      lRes := 'Failed. Reason: ' + e.Message;
  End; {try}

  mmLog.Lines.Add('Sending result : ' + lRes);

  mmLog.Lines.Add('Checking SMTP login...');
  lRes := 'Pass...';
  Application.ProcessMessages;
  prgTest.Position := 35;
  Sleep(500);

  Try
    Try
      msSMTP.Login;
    Except
      On E: exception Do
        lRes := 'Failed. Reason: ' + e.Message;
    End; {try}
  Finally
    Try
      msSMTP.Logout;
    Except
    End; {try}
  End; {try..finally}

  mmLog.Lines.Add('SMTP login result : ' + lRes);
  prgTest.Position := 65;
  Application.ProcessMessages;
  Sleep(500);*)
End;

{-----------------------------------------------------------------------------
  Procedure: btnCloseClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMAPIWiz.btnCloseClick(Sender: TObject);
Begin
  ModalResult := mrCancel;
End;

{-----------------------------------------------------------------------------
  Procedure: btnViewResultTestClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMAPIWiz.btnViewResultTestClick(Sender: TObject);
Begin
  If Height = cFORMHEIGHT Then
    Height := 475
  Else
    Height := cFORMHEIGHT
End;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMAPIWiz.FormCreate(Sender: TObject);
Begin
  Height := cFORMHEIGHT;
End;

{-----------------------------------------------------------------------------
  Procedure: btnAddClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMAPIWiz.btnAddClick(Sender: TObject);
Begin
  If edtYourName.Text = '' Then
  Begin
    MessageDlg('Invalid user information name!', mtInformation, [mbok], 0);
    If edtYourName.CanFocus Then
      edtYourName.SetFocus;
    Abort;
  End; {If edtYourName.Text = '' Then}

  If edtEmailAddress.Text = '' Then
  Begin
    MessageDlg('Invalid E-Mail address!', mtInformation, [mbok], 0);
    If edtEmailAddress.CanFocus Then
      edtEmailAddress.SetFocus;
    Abort;
  End; {If edtEmailAddress.Text = '' Then}

  ModalResult := MrOK;
End;

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMAPIWiz.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    ModalResult := MrCancel;
End;

End.

