{-----------------------------------------------------------------------------
 Unit Name: uDSRConfigFrame
 Author:    vmoura
 Purpose:
 History:

 common dsr frame
-----------------------------------------------------------------------------}
Unit uDSRConfigFrame;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mask, AdvEdit, AdvSpin, StdCtrls, AdvGlowButton,
  ComCtrls, ExtCtrls, AdvPanel, strutils,

  uSystemConfig, Menus, AdvGroupBox, AdvOfficeButtons, AdvListV
  ;

Type
  TfrmDSRConfigFrame = Class(TFrame)
    advPanel: TAdvPanel;
    gbPop: TAdvGroupBox;
    lvPop3: TAdvListView;
    gbEmail: TAdvGroupBox;
    Label2: TLabel;
    edtPollingTime: TAdvSpinEdit;
    rbConnectionType: TAdvOfficeRadioGroup;
    ckbDeleteEmail: TAdvOfficeCheckBox;
    edtOutgoingGuid: TAdvMaskEdit;
    edtIncomingGuid: TAdvMaskEdit;
    ppmMail: TPopupMenu;
    mniAddNew: TMenuItem;
    Update1: TMenuItem;
    Delete1: TMenuItem;
    mniSetasDefault: TMenuItem;
    pnlButtons: TAdvPanel;
    btnPop3Add: TAdvGlowButton;
    btnUpdate: TAdvGlowButton;
    btnPop3Delete: TAdvGlowButton;
    btnSetDefault: TAdvGlowButton;
    lblDefaultEmailAccc: TLabel;
    edtDefaultEmailAcc: TAdvEdit;
    Procedure btnPop3AddClick(Sender: TObject);
    Procedure btnUpdateClick(Sender: TObject);
    Procedure btnPop3DeleteClick(Sender: TObject);
    Procedure rbConnectionTypeClick(Sender: TObject);
    Procedure btnSetDefaultClick(Sender: TObject);
    Procedure lvPop3SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    Procedure mniAddNewClick(Sender: TObject);
    Procedure Update1Click(Sender: TObject);
    Procedure Delete1Click(Sender: TObject);
    Procedure mniSetasDefaultClick(Sender: TObject);
    Procedure ppmMailPopup(Sender: TObject);
    Procedure ckbDeleteEmailClick(Sender: TObject);
    Procedure FrameEnter(Sender: TObject);
    procedure lvPop3DblClick(Sender: TObject);
  Private
    fDSRConf: TSystemConf;
    Function SearchMail(Const pMail: String): Boolean;
    Procedure LoadConnectionType(Sender: TObject);
  Public
    Constructor Create(Aowner: TComponent); Override;
    Destructor Destroy; Override;
    Procedure LoadDSRSettings;
    Procedure LoadDSRPopMails;
    Procedure SaveDSRSettings;
  Published
    Property Conf: TSystemConf Read fDSRConf Write fDSRConf;
  End;

Implementation

Uses {uAddPop3Account, } uCommon, uConsts, uPasswordDialog, uEmailDllWizard,
  uPOPSMTPWiz, udashGlobal;

{$R *.dfm}

{ TfrmDSRConfigFrame }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TfrmDSRConfigFrame.Create(Aowner: TComponent);
Begin
  Inherited Create(Aowner);
  fDSRConf := TSystemConf.Create;
  btnSetDefault.Enabled := False;
  mniSetasDefault.Enabled := False;
  lblDefaultEmailAccc.Visible := False;
  edtDefaultEmailAcc.Visible := False;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TfrmDSRConfigFrame.Destroy;
Begin
  If Assigned(fDSRConf) Then
    FreeAndNil(fDSRConf);
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: LoadDSRPopMails
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.LoadDSRPopMails;
Var
  lcont: integer;
Begin
  fDSRConf.LoadPop3List;

  If fDSRConf.POP3.Count > 0 Then
  Begin
    lvPop3.Items.Clear;

    For lCont := 0 To fDSRConf.POP3.Count - 1 Do
    Begin
      With lvPop3.Items.Add Do
      Begin
        Caption := fDSRConf.POP3[lCont].YourName;
        SubItems.Add(fDSRConf.POP3[lCont].PopAddress);
        SubItems.Add(fDSRConf.POP3[lCont].POP3Server);
        SubItems.Add(fDSRConf.POP3[lCont].SMTPServer);
        SubItems.Add(fDSRConf.POP3[lCont].UserName);
        SubItems.Add(_CreateFakedString(Length(fDSRConf.POP3[lCont].Password)));
        SubItems.Add(ifthen(fDSRConf.POP3[lCont].userdefault, 'True', 'False'));
        SubItems.Add(inttostr(fDSRConf.POP3[lCont].POP3Port));
        SubItems.Add(inttostr(fDSRConf.POP3[lCont].SMTPPort));
      End; {With lvPop3.Items.Add Do}
    End; {For lCont := 0 To fSystemConf.POP3.Count - 1 Do}

    If lvPop3.Selected = Nil Then
      If lvPop3.Items.Count > 0 Then
        If lvpop3.ItemIndex < 0 Then
        Try
          lvpop3.SelectItem(0);
        Except
        End;

  End; {If fSystemConf.POP3.Count > 0 Then}
End;

{-----------------------------------------------------------------------------
  Procedure: LoadDSRSettings
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.LoadDSRSettings;
Begin
  rbConnectionType.OnClick := Nil;
  If fDSRConf.UseMapi Then
  begin
    rbConnectionType.ItemIndex := 0;
    edtDefaultEmailAcc.Text := fDSRConf.DefaultMapiEmail;
  end
  Else If fDSRConf.POP3.Count > 0 Then
    rbConnectionType.ItemIndex := 1
  Else
    rbConnectionType.ItemIndex := 2;
  rbConnectionType.OnClick := rbConnectionTypeClick;

  If fDSRConf.PollingTime > 1440 Then
    edtPollingTime.Value := 1
  Else
    edtPollingTime.Value := fDSRConf.PollingTime;

  ckbDeleteEmail.Checked := fDSRConf.DeleteNonDSR;

  edtIncomingGuid.Text := fDSRConf.IncomingGuid;
  edtOutgoingGuid.Text := fDSRConf.OutgoingGuid;

  rbConnectionTypeClick(Nil);
  LoadDSRPopMails;
End;

{-----------------------------------------------------------------------------
  Procedure: SaveDSRSettings
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.SaveDSRSettings;
Begin
  fDSRConf.DeleteNonDSR := ckbDeleteEmail.Checked;

  fDSRConf.IncomingGuid := StringReplace(edtIncomingGuid.Text, ' ', '',
    [rfReplaceAll]);
  fDSRConf.OutgoingGuid := StringReplace(edtOutgoingGuid.Text, ' ', '',
    [rfReplaceAll]);

  If edtPollingTime.Value > edtPollingTime.MaxValue Then
    fDSRConf.PollingTime := edtPollingTime.MaxValue
  Else
    fDSRConf.PollingTime := edtPollingTime.Value;

  If rbConnectionType.ItemIndex <= 0 Then
  Begin
    lvPop3.Clear;
    fDSRConf.POP3.Clear;
    if rbConnectionType.ItemIndex = 0 then
    begin
      fDSRConf.UseMapi := True;
      {add a default e-mail for mappi}
      if Trim(edtDefaultEmailAcc.Text) = '' then
      begin
        ShowDashboardDialog('Please insert a default e-mail account!', mtError, [mbok]);
        if edtDefaultEmailAcc.CanFocus then
          edtDefaultEmailAcc.SetFocus;
        Abort;
      end; {if Trim(edtDefaultEmailAcc.Text) = '' then}

      fDSRConf.DefaultMapiEmail := edtDefaultEmailAcc.Text;
    end
    else
      fDSRConf.UseMapi := False;
  End {If rbConnection.ItemIndex = 0 Then}
  Else
  Begin
    fDSRConf.DefaultMapiEmail := '';
    fDSRConf.UseMapi := False;
    If rbConnectionType.ItemIndex = 1 Then
    Begin
      If lvPop3.Items.Count = 0 Then
      Begin
        //MessageDlg('Please insert at least one e-mail account for POP3/SMTP connection!', mtError, [mbok], 0);
        ShowDashboardDialog('Please insert at least one e-mail account for POP3/SMTP connection!', mtError, [mbok]);
        Abort;
      End; {if lvPop3.Items.Count = 0 then}
    End
    Else
    Begin
      lvPop3.Clear;
      fDSRConf.POP3.Clear;
    End; {begin}
  End; {begin}

  fDSRConf.SavePopList;
End;

{-----------------------------------------------------------------------------
  Procedure: SearchMail
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmDSRConfigFrame.SearchMail(Const pMail: String): Boolean;
Var
  lCont: integer;
Begin
  Result := False;
  For lCont := 0 To lvPop3.Items.Count - 1 Do
    If Lowercase(trim(lvPop3.Selected.SubItems[1])) = Lowercase(trim(pMail))
      Then
    Begin
      Result := True;
      Break;
    End; {If Lowercase(trim(lvPop3.Selected.SubItems[1])) = Lowercase(trim(pMail)) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: btnPop3AddClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.btnPop3AddClick(Sender: TObject);
Var
  lCont: Integer;
Begin

  Application.CreateForm(TfrmPOPSMTPWiz, frmPOPSMTPWiz);

  With frmPOPSMTPWiz Do
  Begin
    EditPop3 := False;
    If ShowModal = mrOK Then
    Begin
      If Not SearchMail(edtEmailAddress.Text) Then
      Begin
        If (fDSRConf.POP3.Count > 0) And cbDefault.Checked Then
          For lCont := 0 To fDSRConf.POP3.Count - 1 Do
            fDSRConf.POP3.Items[lCont].UserDefault := False;

        With fDSRConf.POP3.Add Do
        Begin
          UserName := edtUserName.Text;
          Password := edtPassword.Text;

          SMTPServer := edtSMTPServer.Text;
          POP3Server := edtPop3Server.Text;

          YourName := edtYourName.Text;
          PopAddress := edtEmailAddress.Text;
          UserDefault := cbDefault.Checked Or (fDSRConf.POP3.Count = 1);
          POP3Port := edtPOP3Port.IntValue;
          SMTPPort := edtSMTPPort.IntValue;
        End; {With fDSRConf.POP3.Add Do}

        {save the new list to .ini file}
        fDSRConf.SavePopList;
        LoadDSRPopMails;
      End {if not SearchMail(edtPopAddress.Text) then}
      Else
(*        MessageDlg('The e-mail ' + edtEmailAddress.Text +
          ' could not be added because this e-mail already exists!',
          mtInformation, [mbok], 0);*)
        ShowDashboardDialog('The e-mail ' + edtEmailAddress.Text +
          ' could not be added because this e-mail already exists!',
          mtInformation, [mbok]);

    End; {If ShowModal = mrOK Then}

    If Assigned(frmPOPSMTPWiz) Then
      FreeAndNil(frmPOPSMTPWiz);
  End; {With frmPOPSMTPWiz Do}

  Try
    lvPop3.SetFocus;
    lvPop3.SelectItem(lvPop3.Items.Count - 1);
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: btnUpdateClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.btnUpdateClick(Sender: TObject);
Var
  lCont: Integer;
Begin
  If lvPop3.Selected <> Nil Then
  Begin
    Application.CreateForm(TfrmPOPSMTPWiz, frmPOPSMTPWiz);

    With frmPOPSMTPWiz Do
    Begin
      EditPop3 := True;
      {set the updated parameters for the especific user}
      edtYourName.Text := lvPop3.Selected.Caption;
      edtEmailAddress.Text := lvPop3.Selected.SubItems[0];
      edtPop3Server.Text := lvPop3.Selected.SubItems[1];
      edtSMTPServer.Text := lvPop3.Selected.SubItems[2];
      edtUserName.Text := lvPop3.Selected.SubItems[3];
      {get the real password, otherwise it is going to update the facked string}
      Try
        edtPassword.Text := fDSRConf.POP3.Items[lvPop3.Selected.Index].VisiblePass;
      Except
        edtPassword.Text := '';
      End;
      cbDefault.Checked := Lowercase(lvPop3.Selected.SubItems[5]) = 'true';
      edtPOP3Port.Text := lvPop3.Selected.SubItems[6];
      edtSMTPPort.Text := lvPop3.Selected.SubItems[7];

      If ShowModal = mrOK Then
      Begin
        {delete his own section}
//        fDSRConf.DeleteSection('pop_' + inttostr(lvPop3.Selected.Index + 1));

        If (fDSRConf.POP3.Count > 0) And cbDefault.Checked Then
          For lCont := 0 To fDSRConf.POP3.Count - 1 Do
            fDSRConf.POP3.Items[lCont].UserDefault := False;

        {add the new details}
        With fDSRConf.POP3[lvPop3.Selected.Index] Do
        Begin
          UserName := edtUserName.Text;
          Password := edtPassword.Text;

          SMTPServer := edtSMTPServer.Text;
          POP3Server := edtPop3Server.Text;

          YourName := edtYourName.Text;
          PopAddress := edtEmailAddress.Text;
          UserDefault := cbDefault.Checked Or (fDSRConf.POP3.Count = 1);
          POP3Port := edtPOP3Port.IntValue;
          SMTPPort := edtSMTPPort.IntValue;
        End; {With fDSRConf.POP3.Add Do}

        {save the list}
        fDSRConf.SavePopList;
        LoadDSRPopMails;

        Try
          lvPop3.SetFocus;
          lvPop3.SelectItem(lvPop3.Items.Count - 1);
        Except
        End;
      End; {If ShowModal = mrOK Then}
    End; {With frmPOPSMTPWiz Do}

    If Assigned(frmPOPSMTPWiz) Then
      FreeAndNil(frmPOPSMTPWiz);
  End; {if lvPop3.Selected <> nil then}
End;

{-----------------------------------------------------------------------------
  Procedure: btnPop3DeleteClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.btnPop3DeleteClick(Sender: TObject);
Begin
  If lvPop3.Selected <> Nil Then
  Begin
(*    If MessageDlg('Are you sure you want to delete the selected item(s)?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes Then*)
    If ShowDashboardDialog('Are you sure you want to delete the selected item(s)?',
      mtConfirmation, [mbYes, mbNo]) = mrYes Then
    Begin

    //fDSRConf.DeleteSection(lvPop3.Selected.SubItems[3]);
      fDSRConf.DeleteSection('pop_' + inttostr(lvPop3.Selected.Index + 1));

      lvPop3.Selected.Delete;
      fDSRConf.SavePopList;
      LoadDSRPopMails;
    End; {messagedlg}
  End; {If lvPop3.Selected <> Nil Then}
End;

{-----------------------------------------------------------------------------
  Procedure: rbConnectionTypeClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.rbConnectionTypeClick(Sender: TObject);
Begin
  LoadConnectionType(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: LoadConnectionType
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.LoadConnectionType(Sender: TObject);
Begin
  {set help contexts id}
  Case rbConnectionType.ItemIndex Of
    0: Self.HelpContext := 5;
    1: Self.HelpContext := 6;
    2: Self.HelpContext := 8;
  End; {Case rbConnectionType.ItemIndex Of}

  If rbConnectionType.ItemIndex In [0, 1] Then
  Begin
    edtOutgoingGuid.EditText := '{' + cDSROUTGOING + '}';
    edtIncomingGuid.EditText := '{' + cDSRINCOMING + '}';
    ckbDeleteEmail.Visible := True;
  End {If rbConnectionType.ItemIndex In [0, 1] Then}
  Else
  Begin
    edtOutgoingGuid.Clear;
    edtIncomingGuid.Clear;
    ckbDeleteEmail.Visible := False;
  End; {begin}

  {set if list of pop e-mails is visible or not}
  If rbConnectionType.ItemIndex = 1 Then
  begin
    //gbPop.Visible := True
    gbPop.Caption := ' E-Mail Accounts ';
    lvPop3.Visible := True;
    pnlButtons.Visible := True;
    lblDefaultEmailAccc.Visible := False;
    edtDefaultEmailAcc.Visible := False;
    edtDefaultEmailAcc.Clear;
  end
  Else
  begin
    gbPop.Caption := ' E-Mail Account ';
    //gbPop.Visible := False;
    lvPop3.Visible := False;
    pnlButtons.Visible := False;
    lblDefaultEmailAccc.Visible := True;
    edtDefaultEmailAcc.Visible := True;
    edtDefaultEmailAcc.Text := fDSRConf.DefaultMapiEmail;
  end;

  If (rbConnectionType.ItemIndex = 2) And (Sender <> Nil) Then
  Begin
    Application.CreateForm(TfrmEmailDllWizard, frmEmailDllWizard);
    With frmEmailDllWizard Do
    Begin
      If fDSRConf.OutgoingGuid <> '' Then
        edtOutgoingGuidWiz.Text := fDSRConf.OutgoingGuid;
      If fDSRConf.IncomingGuid <> '' Then
        edtIncomingGuidWiz.Text := fDSRConf.IncomingGuid;

      If ShowModal = mrOK Then
      Begin
        If _IsValidGuid(edtOutgoingGuidWiz.Text) Then
          edtOutgoingGuid.Text := edtOutgoingGuidWiz.Text;

        If _IsValidGuid(edtIncomingGuidWiz.Text) Then
          edtIncomingGuid.Text := edtIncomingGuidWiz.Text;
      End; {if ShowModal = mrOK then}
    End; {with frmEmailDllWizard do}

    FreeAndNil(frmEmailDllWizard);
  End; {if rbConnectionType.ItemIndex = 2 then}
End;

{-----------------------------------------------------------------------------
  Procedure: btnSetDefaultClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.btnSetDefaultClick(Sender: TObject);
Var
  lCont: Integer;
Begin
  If lvPop3.Selected <> Nil Then
  Begin
    For lCont := 0 To fDSRConf.POP3.Count - 1 Do
      fDSRConf.POP3.Items[lCont].UserDefault := False;
    fDSRConf.POP3.Items[lvPop3.Selected.Index].UserDefault := True;
    fDSRConf.SavePopList;
    LoadDSRPopMails;

    Try
      lvPop3.SetFocus;
      lvPop3.SelectItem(lvPop3.Items.Count - 1);
    Except
    End;
  End; {If lvPop3.Selected <> Nil Then}
End;

{-----------------------------------------------------------------------------
  Procedure: lvPop3SelectItem
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.lvPop3SelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
Begin
  If Item <> Nil Then
  Begin
    btnSetDefault.Enabled := lowercase(Item.SubItems[5]) = 'false';
    mniSetasDefault.Enabled := btnSetDefault.Enabled;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: mniAddNewClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.mniAddNewClick(Sender: TObject);
Begin
  btnPop3AddClick(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: Update1Click
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.Update1Click(Sender: TObject);
Begin
  btnUpdateClick(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: Delete1Click
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.Delete1Click(Sender: TObject);
Begin
  btnPop3DeleteClick(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: SetasDefault1Click
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.mniSetasDefaultClick(Sender: TObject);
Begin
  btnSetDefaultClick(Sender);
End;

Procedure TfrmDSRConfigFrame.ppmMailPopup(Sender: TObject);
Begin
  Application.ProcessMessages;
End;

{-----------------------------------------------------------------------------
  Procedure: ckbDeleteEmailClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.ckbDeleteEmailClick(Sender: TObject);
Begin
  {check if something has changed}
  If fDSRConf.DeleteNonDSR <> ckbDeleteEmail.Checked Then
  Begin
(*    If MessageDlg('Are you sure you want to select this option?', mtConfirmation,
      [mbYes, mbNo], 0) = mrYes Then*)
    If ShowDashboardDialog('Are you sure you want to select this option?', mtConfirmation,
      [mbYes, mbNo]) = mrYes Then
    Begin
      ckbDeleteEmail.Checked := Not fDSRConf.DeleteNonDSR;
      fDSRConf.DeleteNonDSR := Not fDSRConf.DeleteNonDSR;
    End
    Else
      ckbDeleteEmail.Checked := fDSRConf.DeleteNonDSR;
  End; {If fDSRConf.DeleteNonDSR <> ckbDeleteEmail.Checked Then}
End;

Procedure TfrmDSRConfigFrame.FrameEnter(Sender: TObject);
Begin
  Case rbConnectionType.ItemIndex Of
    0: self.HelpContext := 5;
    1: self.HelpContext := 6;
    2: self.HelpContext := 8;
  End;
End;

procedure TfrmDSRConfigFrame.lvPop3DblClick(Sender: TObject);
begin
  btnUpdateClick(Sender);
end;

End.

