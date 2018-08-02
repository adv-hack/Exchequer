{-----------------------------------------------------------------------------
 Unit Name: uUsers
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uUsers;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, AdvPanel, ComCtrls, uAdoDsr, StdCtrls, AdvGlowButton,
  AdvListV, Menus;

Type
  TfrmUser = Class(TForm)
    advPanel: TAdvPanel;
    lvUsers: TAdvListView;
    pnlButtons: TAdvPanel;
    btnUpdate: TAdvGlowButton;
    btnUserAdd: TAdvGlowButton;
    btnUserDelete: TAdvGlowButton;
    btnClose: TAdvGlowButton;
    ppmUserLogin: TPopupMenu;
    Delete1: TMenuItem;
    mniAddNew: TMenuItem;
    Update1: TMenuItem;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Procedure FormCreate(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    Procedure btnUpdateClick(Sender: TObject);
    Procedure btnUserAddClick(Sender: TObject);
    Procedure btnUserDeleteClick(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure btnCloseClick(Sender: TObject);
    Procedure Delete1Click(Sender: TObject);
    Procedure mniAddNewClick(Sender: TObject);
    Procedure Update1Click(Sender: TObject);
    procedure lvUsersDblClick(Sender: TObject);
  Private
    fDb: TADODSR;
    Procedure LoadUsers;
  Public
  End;

Var
  frmUser: TfrmUser;

Implementation

Uses uDsr, uDashSettings, uCommon, uAddUserLogin, udashGlobal;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmUser.FormCreate(Sender: TObject);
Begin
  Try
    fDb := TADODSR.Create(_DashboardGetDBServer);
  Except
    On e: exception Do
    Begin
      //MessageDlg('An exception has occurred:' + #13#13 + E.Message, mtError, [mbok], 0);
      ShowDashboardDialog('An exception has occurred:' + #13#13 + E.Message, mtError, [mbok]);

      _LogMSG('Dashboard login database error. Error: ' + e.message);
    End;
  End;

  LoadUsers;
End;

{-----------------------------------------------------------------------------
  Procedure: FormDestroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmUser.FormDestroy(Sender: TObject);
Begin
  If Assigned(fDb) Then
    FreeAndNil(fDb);
End;

{-----------------------------------------------------------------------------
  Procedure: LoadUsers
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmUser.LoadUsers;
Var
  lcont: Integer;
  lUsers: Olevariant;
  lTotal: Integer;
Begin

  If Assigned(fDb) Then
  Begin
    lUsers := fDb.GetUsers;
    lTotal := _GetOlevariantArraySize(lUsers);

    If lTotal > 0 Then
    Begin
      lvUsers.Items.Clear;

      For lCont := 0 To lTotal - 1 Do
        With lvUsers.Items.Add Do
        Begin
          Caption := lUsers[lCont][0];
          SubItems.Add(lUsers[lCont][1]);
          SubItems.Add(lUsers[lCont][2]);
        End; {With lvUsers.Items.Add Do}
    End; {If lTotal > 0 Then}
  End; {if Assigned(fDb) then}
End;

{-----------------------------------------------------------------------------
  Procedure: btnLoadUsersClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmUser.btnUpdateClick(Sender: TObject);
Begin
//  LoadUsers;
  If lvUsers.Selected <> Nil Then
  Begin
    Application.CreateForm(TfrmAddUserLogin, frmAddUserLogin);
    With frmAddUserLogin Do
    Begin
      OldUser := lvUsers.Selected.Caption;
      OldPass := lvUsers.Selected.SubItems[1];
      OldLogin := lvUsers.Selected.SubItems[0];

      EditUser := True;
      edtUser.Text := lvUsers.Selected.Caption;
      edtLogin.Text := lvUsers.Selected.SubItems[0];
      edtPassword.Text := lvUsers.Selected.SubItems[1];
      If ShowModal = mrOK Then
        LoadUsers;

      Try
        lvUsers.SetFocus;
      Except
      End;
    End;

    FreeAndNil(frmAddUserLogin);
    Application.ProcessMessages;
  End; {If lvUsers.Selected <> Nil Then}
End;

{-----------------------------------------------------------------------------
  Procedure: btnUserAddClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmUser.btnUserAddClick(Sender: TObject);
Begin
  Application.CreateForm(TfrmAddUserLogin, frmAddUserLogin);
  With frmAddUserLogin Do
  Begin
    If ShowModal = mrOK Then
      LoadUsers;

    Try
      lvUsers.SetFocus;
    Except
    End;
  End; {With frmAddNewuserLogin Do}

  FreeAndNil(frmAddUserLogin);

  Application.ProcessMessages;
End;

{-----------------------------------------------------------------------------
  Procedure: btnUserDeleteClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmUser.btnUserDeleteClick(Sender: TObject);
Begin
  If lvUsers.Selected <> Nil Then
  Begin
(*    If MessageDlg('Are you sure you want to delete the selected user login?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes Then*)
    If ShowDashboardDialog('Are you sure you want to delete the selected user login?',
      mtConfirmation, [mbYes, mbNo]) = mrYes Then
    Begin
    {delete the selected user}
      TDSR.DSR_DeleteUser(
        _DashboardGetDSRServer,
        _DashboardGetDSRPort,
        lvUsers.Selected.SubItems[0]
        );

      lvUsers.Selected.Delete;

      LoadUsers;
    End; {if messagedlg}
  End; {If lvUsers.Selected <> Nil Then}
End;

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmUser.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    Close;
End;

{-----------------------------------------------------------------------------
  Procedure: btnCloseClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmUser.btnCloseClick(Sender: TObject);
Begin
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: Delete1Click
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmUser.Delete1Click(Sender: TObject);
Begin
  btnUserDeleteClick(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: AddNew1Click
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmUser.mniAddNewClick(Sender: TObject);
Begin
  btnUserAddClick(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: Update1Click
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmUser.Update1Click(Sender: TObject);
Begin
  btnUpdateClick(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: lvUsersDblClick
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmUser.lvUsersDblClick(Sender: TObject);
begin
  btnUpdateClick(Sender);
end;

End.
