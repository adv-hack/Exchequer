{-----------------------------------------------------------------------------
 Unit Name: uAddPop3Account
 Author:    vmoura
 Purpose:
 History:

 add/update pop3 accounts monitored by the dsr
-----------------------------------------------------------------------------}
Unit uAddPop3Account;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvEdit, AdvGlowButton, ExtCtrls, AdvPanel;

Type
  TfrmAddPop3Account = Class(TForm)
    advPanel: TAdvPanel;
    btnAdd: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    Label5: TLabel;
    edtPopuser: TAdvEdit;
    Label7: TLabel;
    edtPopServer: TAdvEdit;
    Label8: TLabel;
    edtPopPassword: TAdvEdit;
    Label12: TLabel;
    edtPopAddress: TAdvEdit;
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure btnAddClick(Sender: TObject);
    Procedure btnCancelClick(Sender: TObject);
  Private
    fEditPop3: Boolean;
    Procedure SetEditPop3(Const Value: Boolean);
  Public
  Published
    Property EditPop3: Boolean Read fEditPop3 Write SetEditPop3 Default False;
  End;

Var
  frmAddPop3Account: TfrmAddPop3Account;

Implementation

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddPop3Account.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    Close;
End;

{-----------------------------------------------------------------------------
  Procedure: btnAddClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddPop3Account.btnAddClick(Sender: TObject);
Begin
  If (edtPopuser.Text = '') Or (Pos(' ', edtPopuser.Text) > 0) Then
  Begin
    MessageDlg('Invalid POP3 User!', mtInformation, [mbok], 0);
    Try
      edtPopuser.SetFocus;
    Except
    End;
    Abort;
  End;

  If edtPopServer.Text = '' Then
  Begin
    MessageDlg('Invalid POP3 server!', mtInformation, [mbok], 0);
    Try
      edtPopServer.SetFocus;
    Except
    End;
    Abort;
  End;

  If edtPopPassword.Text = '' Then
  Begin
    MessageDlg('Invalid POP3 password!', mtInformation, [mbok], 0);
    Try
      edtPopPassword.SetFocus;
    Except
    End;
    Abort;
  End;

  If edtPopAddress.Text = '' Then
  Begin
    MessageDlg('Invalid POP3 address e-mail!', mtInformation, [mbok], 0);
    Try
      edtPopAddress.SetFocus;
    Except
    End;
    Abort;
  End;

  ModalResult := mrOK;
End;

{-----------------------------------------------------------------------------
  Procedure: btnCloseClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddPop3Account.btnCancelClick(Sender: TObject);
Begin
  Close;
End;

Procedure TfrmAddPop3Account.SetEditPop3(Const Value: Boolean);
Begin
  fEditPop3 := Value;

  If fEditPop3 Then
  Begin
    Caption := 'Update Pop3 Account';
    btnAdd.Caption := '&Update';
  End;
End;

End.
