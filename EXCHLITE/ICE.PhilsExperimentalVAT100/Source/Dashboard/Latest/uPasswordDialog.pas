{-----------------------------------------------------------------------------
 Unit Name: uPasswordDialog
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uPasswordDialog;

Interface

Uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, AdvEdit, AdvGlowButton, ExtCtrls, AdvPanel, Dialogs;

Type
  TfrmPasswordDlg = Class(TForm)
    advPanel: TAdvPanel;
    lblPassword: TLabel;
    btnOK: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    edtPass: TAdvEdit;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Procedure btnOKClick(Sender: TObject);
    Procedure btnCancelClick(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
  Private
    fDBServer: String;
  Public
  Published
    Property DBServer: String Read fDBServer Write fDBServer;
  End;

Var
  frmPasswordDlg: TfrmPasswordDlg;

Implementation

Uses uAdoDSR, uCommon, udashGlobal;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: btnOKClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPasswordDlg.btnOKClick(Sender: TObject);
  Procedure _CallInvalidPassword;
  Begin
    //MessageDlg('Invalid password!', mtInformation, [mbok], 0);
    ShowDashboardDialog('Invalid password!', mtInformation, [mbok]);

    If edtPass.CanFocus Then
      edtPass.SetFocus;
    Abort;
  End;
Var
  lDb: TADODSR;
Begin
  Try
    lDb := TADODSR.Create(fDBServer);
  Except
    On e: exception Do
    Begin
      //MessageDlg('An exception has occurred connecting the database:' + #13#13 + E.Message, mtError, [mbok], 0);
      ShowDashboardDialog('An exception has occurred connecting the database:' + #13#13 + E.Message, mtError, [mbok]);

      _LogMSG('Dashboard database error. Error: ' + e.message);
    End; {begin}
  End; {try}

  If Assigned(lDb) And lDb.Connected Then
  Begin
    If trim(edtPass.Text) = '' Then
      _CallInvalidPassword;

    If lowercase(trim(edtPass.Text)) = lowercase(lDb.GetAdminPassword) Then
    Begin
      ModalResult := mrOk;
//      CLose;
    End
    Else
      _CallInvalidPassword;

    lDb.Free;
  End {if Assigned(lDb) and lDb.Connected then}
End;

{-----------------------------------------------------------------------------
  Procedure: btnCancelClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPasswordDlg.btnCancelClick(Sender: TObject);
Begin
  ModalResult := mrCancel;
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPasswordDlg.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    Close;
End;

End.

