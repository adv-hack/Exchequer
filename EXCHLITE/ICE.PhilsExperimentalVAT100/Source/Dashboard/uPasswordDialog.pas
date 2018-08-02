{-----------------------------------------------------------------------------
 Unit Name: uPasswordDialog
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uPasswordDialog;

Interface

Uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, AdvEdit, AdvGlowButton, ExtCtrls, AdvPanel, Dialogs,

  ufrmbase
  ;

Const
  cINFO = '%s Manager Password';

Type
  //TfrmPasswordDlg = Class(TForm)
  TfrmPasswordDlg = Class(TFrmbase)
    advPanel: TAdvPanel;
    lblPassword: TLabel;
    btnOK: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    edtPass: TAdvEdit;
    Panel1: TPanel;
    lblInfo: TLabel;
    Label2: TLabel;
    Procedure btnOKClick(Sender: TObject);
    Procedure btnCancelClick(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure FormCreate(Sender: TObject);
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
      ShowDashboardDialog('An exception has occurred connecting the database:' +
        #13#13 + E.Message, mtError, [mbok]);

      _LogMSG('Error connecting database. Error: ' + e.message);
    End; {begin}
  End; {try}

  If Assigned(lDb) And lDb.Connected Then
  Begin
    If trim(edtPass.Text) = '' Then
      _CallInvalidPassword;

    If lowercase(trim(edtPass.Text)) = lowercase(lDb.GetAdminPassword) Then
      ModalResult := mrOk
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
End;

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPasswordDlg.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    btnCancelClick(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPasswordDlg.FormCreate(Sender: TObject);
Begin
  Inherited;

  CheckCIS(dbServer);

  lblInfo.Caption := Format(cINFO, [_GetProductName(glProductNameIndex)]);
End;

End.

