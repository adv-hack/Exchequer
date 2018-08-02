{-----------------------------------------------------------------------------
 Unit Name: uAddressBook
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uAddressBook;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, AdvPanel, StdCtrls, ComCtrls, uAdoDsr, Menus,
  AdvGlowButton, AdvListV,

  ufrmbase
  ;

const
  cINFO = '%s E-Mail Contacts';
  cDESCRIPTION = 'You can use the %s Contacts to look up and select names, e-mail addresses when you address messages.';

Type
  //TfrmAddressBook = Class(TForm)
  TfrmAddressBook = Class(TFrmbase)
    advPanel: TAdvPanel;
    lvAddress: TAdvListView;
    Label5: TLabel;
    edtName: TEdit;
    AdvPanel1: TAdvPanel;
    btnOk: TAdvGlowButton;
    btnClose: TAdvGlowButton;
    btnAddNew: TAdvGlowButton;
    btnDelete: TAdvGlowButton;
    ppmAddressBook: TPopupMenu;
    mniDelete: TMenuItem;
    mniAddNew: TMenuItem;
    btnUpdate: TAdvGlowButton;
    Panel1: TPanel;
    lblInfo: TLabel;
    lblDesc: TLabel;
    mniChange: TMenuItem;
    Procedure FormCreate(Sender: TObject);
    Procedure btnOkClick(Sender: TObject);
    Procedure lvAddressDblClick(Sender: TObject);
    Procedure edtNameChange(Sender: TObject);
    Procedure btnDeleteClick(Sender: TObject);
    Procedure btnAddNewClick(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure btnCloseClick(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure mniDeleteClick(Sender: TObject);
    Procedure mniAddNewClick(Sender: TObject);
    Procedure btnUpdateClick(Sender: TObject);
    Procedure lvAddressKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    procedure mniChangeClick(Sender: TObject);
  Private
    fDb: TAdodsr;
    fSelectionMade: Boolean;
    Procedure LoadAddressBook;
    Procedure LoadCompanies(Var pCombo: TComboBox);
    Function GetCompanyDesc(pCompany: Longword): String;
    Function CheckCompany(pCompany: Longword): Boolean;
  Public
  Published
    Property SelectionMade: Boolean Read fSelectionMade Write
      fSelectionMade Default False;
  End;

Var
  frmAddressBook: TfrmAddressBook;

Implementation

Uses strUtils, uDashGlobal,
  udsr, uCommon, uDashSettings, uAddContact, uInterfaces;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddressBook.FormCreate(Sender: TObject);
Begin
  Inherited;
  
  Try
    fDb := TADODSR.Create(_DashboardGetDBServer);
  Except
    On e: exception Do
    Begin
      ShowDashboardDialog('An exception has occurred connecting the database:' + #13#13 + E.Message, mtError, [mbok]);

      _LogMSG('Error connecting database. Error: ' + e.message);
    End; {begin}
  End; {try}

  CheckCIS(_DashboardGetDBServer);

  lblInfo.Caption := Format(cInfo, [_GetProductName(glProductNameIndex)]);
  lblDesc.Caption := Format(cDESCRIPTION, [_GetProductName(glProductNameIndex)]);

  LoadAddressBook;
End;

{-----------------------------------------------------------------------------
  Procedure: LoadAddressBook
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddressBook.LoadAddressBook;
Var
  lAdd: Olevariant;
  lCont, lTotal: Integer;
Begin
  If Assigned(fDb) Then
  Begin
    lvAddress.Items.Clear;
    lAdd := null;
    lAdd := fDb.GetContacts;

    lTotal := _GetOlevariantArraySize(lAdd);

    If lTotal > 0 Then
      For lCont := 0 To lTotal - 1 Do
        With lvAddress.Items.Add Do
        Begin
          Caption := lAdd[lCont][0];
          SubItems.Add(lAdd[lCont][1]);
          //SubItems.Add(lAdd[lCont][2]);
          SubItems.Add(GetCompanyDesc(lAdd[lCont][2]));
        End; {With lvAddress.Items.Add Do}
  End; {if Assigned(fDb) then}
End;

{-----------------------------------------------------------------------------
  Procedure: btnOkClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddressBook.btnOkClick(Sender: TObject);
Begin
  If lvAddress.Selected <> Nil Then
    ModalResult := mrOk
  Else
    ModalResult := mrCancel;
End;

{-----------------------------------------------------------------------------
  Procedure: lvAddressDblClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddressBook.lvAddressDblClick(Sender: TObject);
Begin
  If SelectionMade Then
  begin
    If lvAddress.Selected <> Nil Then
      btnOkClick(Sender)
  end
  else
    btnUpdateClick(Sender);  
End;

{-----------------------------------------------------------------------------
  Procedure: edtNameChange
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddressBook.edtNameChange(Sender: TObject);
Var
  lCont: Integer;
Begin
  With lvAddress Do
    For lCont := 0 To Items.Count - 1 Do
      If Pos(Lowercase(edtName.Text), Lowercase(Items[lCont].Caption)) > 0 Then
      Begin
        Try
          Selected := Items[lCont];
        Except
        End;

        Break;
      End; {If Pos(Lowercase(edtName.Text), Lowercase(Items[lCont].Caption)) > 0 Then}
End;

{-----------------------------------------------------------------------------
  Procedure: btnAddNewClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddressBook.btnDeleteClick(Sender: TObject);
Begin
  If lvAddress.Selected <> Nil Then
  Begin
(*    If MessageDlg('Are you sure you want to delete the selected contact?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes Then*)
    If ShowDashboardDialog('Are you sure you want to delete the selected contact?',
      mtConfirmation, [mbYes, mbNo]) = mrYes Then
    Begin
      TDSR.DSR_DeleteContact(
        _DashboardGetDSRServer,
        _DashboardGetDSRPort,
        lvAddress.Selected.SubItems[0]
        );

      LoadAddressBook;
    End; {if messagedlg}
  End; {If lvAddress.Selected <> Nil Then}

  Application.ProcessMessages;
End;

{-----------------------------------------------------------------------------
  Procedure: btnAddNewClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddressBook.btnAddNewClick(Sender: TObject);
Begin
  Application.CreateForm(TfrmAddContact, frmAddContact);
  With frmAddContact Do
  Begin
    LoadCompanies(cbCompany);
    
    OnCheckDefault := CheckCompany;
    If ShowModal = mrOK Then
    Begin
      LoadAddressBook;

      Try
        lvAddress.SetFocus;
        lvAddress.SelectItem(lvAddress.Items.Count - 1);
      Except
      End; {try}
    End; {If ShowModal = mrOK Then}
  End; {With frmAddNewContact Do}

  FreeAndNil(frmAddContact);
End;

{-----------------------------------------------------------------------------
  Procedure: FormClose
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddressBook.FormClose(Sender: TObject;
  Var Action: TCloseAction);
Begin
  If Assigned(fDb) Then
    FreeAndNil(fDb);
End;

{-----------------------------------------------------------------------------
  Procedure: btnCancelClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddressBook.btnCloseClick(Sender: TObject);
Begin
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddressBook.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    btnCloseClick(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: Delete1Click
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddressBook.mniDeleteClick(Sender: TObject);
Begin
  btnDeleteClick(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: AddNew1Click
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddressBook.mniAddNewClick(Sender: TObject);
Begin
  btnAddNewClick(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: btnUpdateClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddressBook.btnUpdateClick(Sender: TObject);
Begin
  If lvAddress.Selected <> Nil Then
  Begin
    Application.CreateForm(TfrmAddContact, frmAddContact);
    With frmAddContact Do
    Begin
      LoadCompanies(cbCompany);
      OnCheckDefault := CheckCompany;

      {set the details to update}
      EditContact := True;
      OldContactMail := lvAddress.Selected.SubItems[0];
      edtContactName.Text := lvAddress.Selected.Caption;
      edtContactMail.Text := lvAddress.Selected.SubItems[0];
      cbCompany.ItemIndex :=
        cbCompany.Items.IndexOf(lvAddress.Selected.SubItems[1]);

      If ShowModal = mrOK Then
      Begin
        LoadAddressBook;

        If lvAddress.CanFocus Then
          lvAddress.SetFocus;

        Try
          If lvAddress.Items.Count > 0 Then
            lvAddress.SelectItem(lvAddress.Items.Count - 1);
        Except
        End;
      End; {If ShowModal = mrOK Then}
    End; {With frmAddNewContact Do}

    FreeAndNil(frmAddContact);
  End; {If lvAddress.Selected <> Nil Then}
End;

{-----------------------------------------------------------------------------
  Procedure: LoadCompanies
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddressBook.LoadCompanies(Var pCombo: TComboBox);
Var
  lCompanies: OleVariant;
  lCont: Integer;
  lTotal: integer;
  lComp: TCompany;
Begin
  pCombo.Clear;
  pCombo.AddItem('', TCompany.Create);

  lCompanies := null;
  lCompanies := fDB.GetCompanies(IfThen(glIsVAO, _GetEnterpriseSystemDir, ''));
  lTotal := _GetOlevariantArraySize(lCompanies);

  If lTotal > 0 Then
    For lCont := 0 To lTotal - 1 Do
      With pCombo Do
      Begin
        lComp := _CreateCompanyObj(lCompanies[lCont]);
        If (lComp <> Nil) And lComp.Active Then
          AddItem(lComp.ExCode + ' - ' + lComp.Desc, lComp);
      End; {With lvComp.Items.Add Do}
End;

{-----------------------------------------------------------------------------
  Procedure: GetCompanyDesc
  Author:    vmoura

  get the company code and description in the correct format
-----------------------------------------------------------------------------}
Function TfrmAddressBook.GetCompanyDesc(pCompany: Longword): String;
Var
  lCompanies: OleVariant;
  lCont: Integer;
  lTotal: integer;
  lComp: TCompany;
Begin
  Result := '';
  lCompanies := null;
  lCompanies := fDB.GetCompanies(IfThen(glIsVAO, _GetEnterpriseSystemDir, ''));
  lTotal := _GetOlevariantArraySize(lCompanies);

  If lTotal > 0 Then
    For lCont := 0 To lTotal - 1 Do
    Begin
      lComp := _CreateCompanyObj(lCompanies[lCont]);
      If (lComp <> Nil) And lComp.Active Then
      Begin
        If lComp.Id = pCompany Then
        Begin
          Result := (lComp.ExCode + ' - ' + lComp.Desc);
          Break;
        End; {If lComp.Id = pCompany Then}

        FreeAndNil(lComp);
      End; {If (lComp <> Nil) And lComp.Active Then}
    End; {With lvComp.Items.Add Do}
End;

{-----------------------------------------------------------------------------
  Procedure: CheckCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmAddressBook.CheckCompany(pCompany: Longword): Boolean;
Var
  lMail: String;
Begin
  Result := True;

  If Assigned(fDb) Then
    If pCompany > 0 Then
    Begin
      lMail := Trim(fDb.GetDefaultReceiver(pCompany));
      Result := lMail = '';
    End; {If pCompany > 0 Then}
End;

{-----------------------------------------------------------------------------
  Procedure: lvAddressKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddressBook.lvAddressKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_RETURN Then
    If SelectionMade Then
      btnOkClick(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: Change1Click
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmAddressBook.mniChangeClick(Sender: TObject);
begin
  btnUpdateClick(Sender);
end;

End.

