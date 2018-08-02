{-----------------------------------------------------------------------------
 Unit Name: uAddContact
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uAddContact;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, AdvGlowButton, AdvEdit, AdvPanel,

  uFrmBase
  ;

const
  cINFO = '%s Add New E-Mail Contact';  

Type
  TOnCheckDefault = Function(pCompany: Longword): Boolean Of Object;

  //TfrmAddContact = Class(TForm)
  TfrmAddContact = Class(TFrmbase)
    advPanel: TAdvPanel;
    Label5: TLabel;
    edtContactName: TAdvEdit;
    btnAdd: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    Label1: TLabel;
    edtContactMail: TAdvEdit;
    cbCompany: TComboBox;
    Panel1: TPanel;
    lblInfo: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Procedure btnAddClick(Sender: TObject);
    Procedure btnCancelClick(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure FormCreate(Sender: TObject);
  Private
    fEditContact: Boolean;
    fOldContactMail: String;
    fOnCheckDefault: TOnCheckDefault;
    Procedure SetEditContact(Const Value: Boolean);
  Public
  Published
    Property EditContact: Boolean Read fEditContact Write SetEditContact Default
      False;
    Property OldContactMail: String Read fOldContactMail Write fOldContactMail;

    Property OnCheckDefault: TOnCheckDefault Read fOnCheckDefault Write
      fOnCheckDefault;
  End;

Var
  frmAddContact: TfrmAddContact;

Implementation

Uses uDSR, uDashSettings, uInterfaces, uConsts, udashGlobal, ucommon;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: btnCancelClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddContact.btnAddClick(Sender: TObject);
Var
  lRes,
    lCompId: Longword;
  lResult: Boolean;
Begin
  If Trim(edtContactName.Text) = '' Then
  Begin
    //MessageDlg('Invalid contact name!', mtInformation, [mbok], 0);
    ShowDashboardDialog('Invalid contact name!', mtInformation, [mbok]);

    If edtContactName.CanFocus Then
      edtContactName.SetFocus;
    Abort;
  End; {If Trim(edtContactName.Text) = '' Then}

  If (Trim(edtContactMail.Text) = '') Or (Pos('@', Trim(edtContactMail.Text)) =
    0) Or (Pos(' ', Trim(edtContactMail.Text)) >= 1) Then
  Begin
    //MessageDlg('Invalid contact e-mail!', mtInformation, [mbok], 0);
    ShowDashboardDialog('Invalid contact e-mail!', mtInformation, [mbok]);

    If edtContactMail.CanFocus Then
      edtContactMail.SetFocus;
    Abort;
  End; {If (Trim(edtContactMail.Text) = '') Or (Pos('@', Trim(edtContactMail.Text)) =}

  lCompId := 0;
  Try
    If cbCompany.ItemIndex >= 0 Then
      lCompId := TCompany(cbCompany.Items.Objects[cbCompany.ItemIndex]).Id;
  Except
    lCompId := 0;
  End;

  If edtContactName.CanFocus Then
    edtContactName.SetFocus;

  lResult := True;

  {check if this e-mail has been set for another company}
  If Assigned(fOnCheckDefault) Then
    lResult := fOnCheckDefault(lCompId);

  If lResult Then
  Begin
    If fOldContactMail <> '' Then
      TDSR.DSR_DeleteContact(_DashboardGetDSRServer, _DashboardGetDSRPort,
        fOldContactMail);

    lRes := TDSR.DSR_AddNewContact(
      _DashboardGetDSRServer,
      _DashboardGetDSRPort,
      Trim(edtContactName.Text),
      Trim(edtContactMail.Text),
      lCompId
      );

    If lRes = cRECORDALREADYEXISTS Then
    Begin
      //MessageDlg('Then contact "' + edtContactMail.Text + '" already exists.', mtInformation, [mbok], 0);
      ShowDashboardDialog('Then contact "' + edtContactMail.Text + '" already exists.', mtInformation, [mbok]);

      Abort;
    End;
  End
  Else
  Begin
    //MessageDlg('The selected company already has a default e-mail receiver.',  mtInformation, [mbok], 0);
    ShowDashboardDialog('The selected company already has a default e-mail receiver.',  mtInformation, [mbok]);

    Abort;
  End;

  ModalResult := mrOK;
End;

{-----------------------------------------------------------------------------
  Procedure: btnAddClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddContact.btnCancelClick(Sender: TObject);
Begin
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddContact.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    Close;
End;

{-----------------------------------------------------------------------------
  Procedure: SetEditContact
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddContact.SetEditContact(Const Value: Boolean);
Begin
  fEditContact := Value;

  If fEditContact Then
  Begin
    //Caption := 'Update Contact';
    lblInfo.Caption := 'Dashboard Change E-Mail Contact';
    btnAdd.Caption := '&OK';
  End {If fEditContact Then}
  else
    lblInfo.Caption := 'Dashboard Add New E-Mail Contact';
End;

{-----------------------------------------------------------------------------
  Procedure: FormClose
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddContact.FormClose(Sender: TObject;
  Var Action: TCloseAction);
Var
  lComp: TCompany;
  lCont: Integer;
Begin
  If cbCompany.Items.Count > 0 Then
  Try
    {free memory elements}
    For lCont := 0 To cbCompany.Items.Count - 1 Do
      If cbCompany.Items.Objects[lCont] <> Nil Then
        If cbCompany.Items.Objects[lCont] Is TCompany Then
        Begin
          lComp := TCompany(cbCompany.Items.Objects[lCont]);
          If Assigned(lComp) Then
            FreeAndNil(lComp);
        End; {If cbCompany.Items.Objects[lCont] Is TCompany Then}
  Except
  End;

  If Assigned(fOnCheckDefault) Then
    fOnCheckDefault := Nil;
End;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddContact.FormCreate(Sender: TObject);
Begin
  Inherited;
  fOnCheckDefault := Nil;

  CheckCIS(_DashboardGetDBServer);

  lblInfo.Caption := Format(cINFO, [_GetProductName(glProductNameIndex)]);
End;

End.

