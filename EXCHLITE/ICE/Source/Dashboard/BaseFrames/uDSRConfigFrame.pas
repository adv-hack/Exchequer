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

  uSystemConfig, uAdoDSR,

  Menus, AdvGroupBox, AdvOfficeButtons, AdvListV
  ;

Type
  TfrmDSRConfigFrame = Class(TFrame)
    advPanel: TAdvPanel;
    gbEmail: TAdvGroupBox;
    Label2: TLabel;
    edtPollingTime: TAdvSpinEdit;
    ckbDeleteEmail: TAdvOfficeCheckBox;
    ppmMail: TPopupMenu;
    mniAddNew: TMenuItem;
    Update1: TMenuItem;
    Delete1: TMenuItem;
    mniSetasDefault: TMenuItem;
    lvPop3: TAdvListView;
    btnPop3Add: TAdvGlowButton;
    btnUpdate: TAdvGlowButton;
    btnPop3Delete: TAdvGlowButton;
    btnSetDefault: TAdvGlowButton;
    Procedure btnPop3AddClick(Sender: TObject);
    Procedure btnUpdateClick(Sender: TObject);
    Procedure btnPop3DeleteClick(Sender: TObject);
    Procedure btnSetDefaultClick(Sender: TObject);
    Procedure lvPop3SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    Procedure mniAddNewClick(Sender: TObject);
    Procedure Update1Click(Sender: TObject);
    Procedure Delete1Click(Sender: TObject);
    Procedure mniSetasDefaultClick(Sender: TObject);
    Procedure ppmMailPopup(Sender: TObject);
    Procedure ckbDeleteEmailClick(Sender: TObject);
    Procedure lvPop3DblClick(Sender: TObject);
  Private
    fDSRConf: TSystemConf;
    fDBServer: String;
    Procedure LoadEmailAccounts;
    Function GetDb: TAdoDSR;
    Procedure DestroyEmailAccounts;
  Public
    Constructor Create(Aowner: TComponent); Override;
    Destructor Destroy; Override;
    Procedure LoadDSRSettings;
    Procedure SaveDSRSettings;
  Published
    Property Conf: TSystemConf Read fDSRConf Write fDSRConf;
    Property DBServer: String Read fDBServer Write fDBServer;
  End;

Implementation

Uses uInterfaces, uCommon, uConsts, uPasswordDialog,
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
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TfrmDSRConfigFrame.Destroy;
Begin
  DestroyEmailAccounts;

  If Assigned(fDSRConf) Then
    FreeAndNil(fDSRConf);
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: LoadEmailAccounts
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.LoadEmailAccounts;
Var
  lDb: TADODSR;
  lcont, lTotal: integer;
  lEmails: OleVariant;
  lResult: Longword;
  lEmailAccount: TEmailAccount;
  lListItem: TListItem;
Begin
  lDb := GetDb;

  {check database connection}
  If Assigned(lDb) Then
  Begin
    If lDb.Connected Then
    Begin
      DestroyEmailAccounts;
      lvPop3.Items.Clear;
      {load email accounts}
      lEmails := lDb.GetEmailAccounts(lResult);
      lTotal := _GetOlevariantArraySize(lEmails);

      For lCont := 0 To lTotal - 1 Do
      Begin
        lEmailAccount := _CreateEmailAccount(lEmails[lCont]);

        {add email account object that will be manipulated by the configuration}
        If lEmailAccount <> Nil Then
        Begin
          lListItem := lvPop3.Items.Add;
          lListItem.Data := lEmailAccount;
          lListItem.Caption := lEmailAccount.YourName;
          lListItem.SubItems.Add(lEmailAccount.YourEmail);
          If lEmailAccount.IsDefaultOutgoing Then
            lListItem.SubItems.Add(lEmailAccount.ServerType + '(Default)')
          Else
            lListItem.SubItems.Add(lEmailAccount.ServerType);
        End; {if lEmailAccount <> nil then}
      End; {for lCont:= 0 to lTotal - 1 do}

      If lvPop3.Items.Count = 1 Then
      Try
        if lvPop3.Items[0].Data <> nil then
          If Not TEmailAccount(lvPop3.Items[0].Data).IsDefaultOutgoing Then
          begin
            lDb.SetDefaultEmailAccount(TEmailAccount(lvPop3.Items[0].Data));
            TEmailAccount(lvPop3.Items[0].Data).IsDefaultOutgoing := True;
            try
              lvPop3.Items[0].SubItems[1] := TEmailAccount(lvPop3.Items[0].Data).ServerType + '(Default)';
            except
            end;  
          end;
      Except
      End;
    End; {if lDb.Connected then}

    lDb.Free;
  End; {if Assigned(lDb) then}
End;

{-----------------------------------------------------------------------------
  Procedure: LoadDSRSettings
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.LoadDSRSettings;
Var
  lDb: TADODSR;
  lcont, lTotal: integer;
  lPollingTime: Integer;
Begin
  lDb := GetDb;

  {check database connection}
  If Assigned(lDb) Then
  Begin
    If lDb.Connected Then
    Begin
      {load polling time}
      Try
        lPollingTime := strtoint(lDb.GetSystemValue(cPOLLINGTIMEPARAM));
      Except
        Try
          lDb.SetSystemParameter(cPOLLINGTIMEPARAM, '1');
        Finally
          lPollingTime := 1;
        End;
      End;

      If lPollingTime > 1440 Then
        edtPollingTime.Value := 1
      Else
        edtPollingTime.Value := lPollingTime;

      {delete or not non releated dsr e-mails}
      ckbDeleteEmail.Checked := lDb.GetSystemValue(cDELETENONDSREMAILPARAM) = '1';

      LoadEmailAccounts;
    End; {if lDb.Connected then}

    lDb.Free;
  End; {if Assigned(lDb) then}

  If lvPop3.Selected = Nil Then
    If lvPop3.Items.Count > 0 Then
      If lvpop3.ItemIndex < 0 Then
      Try
        lvpop3.SelectItem(0);
      Except
      End;
End;

{-----------------------------------------------------------------------------
  Procedure: SaveDSRSettings
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.SaveDSRSettings;
Var
  lDb: TADODSR;
  lPollingTime: Integer;
Begin
  lDb := GetDb;

  {check database connection}
  If Assigned(lDb) Then
  Begin
    If lDb.Connected Then
    Begin
      If edtPollingTime.Value > edtPollingTime.MaxValue Then
        lPollingTime := edtPollingTime.MaxValue
      Else
        lPollingTime := edtPollingTime.Value;

      lDb.SetSystemParameter(cPOLLINGTIMEPARAM, IntToStr(lPollingTime));
      lDb.SetSystemParameter(cDELETENONDSREMAILPARAM,
        inttostr(ord(ckbDeleteEmail.Checked)));
    End; {if lDb.Connected then}

    lDb.Free;
  End; {if Assigned(lDb) then}
End;

{-----------------------------------------------------------------------------
  Procedure: btnPop3AddClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.btnPop3AddClick(Sender: TObject);
Begin
  Application.CreateForm(TfrmPOPSMTPWiz, frmPOPSMTPWiz);
  frmPOPSMTPWiz.DBServer := Self.DBServer;

  With frmPOPSMTPWiz Do
  Begin
    EditPop3 := False;
    IsDefault := lvPop3.Items.Count = 0;

    LoadEmailSystem;

    If ShowModal = mrOk Then
      LoadEmailAccounts;

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
    frmPOPSMTPWiz.DBServer := Self.DBServer;
    With frmPOPSMTPWiz Do
    Begin
      EditPop3 := True;
      IsDefault := False;
      LoadEmailSystem;
      EMailAccount := TEmailAccount(lvPop3.Selected.Data);

      If ShowModal = mrOK Then
      Begin
        LoadEmailAccounts;
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
Var
  lDb: TADODSR;
Begin
  If lvPop3.Selected <> Nil Then
  Begin
    If ShowDashboardDialog('Are you sure you want to delete the selected item(s)?',
      mtConfirmation, [mbYes, mbNo]) = mrYes Then
    Begin
      {connect database}
      lDb := GetDb;

      If Assigned(lDb) Then
      Begin
        {delete selected object}
        If lDb.Connected Then
          lDb.UpdateEmailAccount(TEmailAccount(lvPOP3.Selected.data), dbDoDelete);

        lDb.Free;
      End; {if Assigned(lDb) then}

      LoadEmailAccounts;
    End; {messagedlg}
  End; {If lvPop3.Selected <> Nil Then}
End;

{-----------------------------------------------------------------------------
  Procedure: btnSetDefaultClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.btnSetDefaultClick(Sender: TObject);
Var
  lDb: TADODSR;
Begin
  If lvPop3.Selected <> Nil Then
  Begin
    lDb := GetDb;

    If Assigned(lDb) Then
    Begin
      If lDb.Connected Then
        lDb.SetDefaultEmailAccount(TEmailAccount(lvPop3.Selected.Data));
      lDb.Free;
    End; {if Assigned(lDb) then}

    LoadEmailAccounts;

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
    btnSetDefault.Enabled := Not TEmailAccount(Item.Data).IsDefaultOutgoing;
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
Var
  lDb: TADODSR;
  lDelete: Boolean;
Begin
  lDelete := False;
  lDb := GetDb;

  If Assigned(lDb) Then
  Begin
    If lDb.Connected Then
    Begin
      lDelete := Boolean(StrToIntDef(lDb.GetSystemValue(cDELETENONDSREMAILPARAM),
        0));
      {check if something has changed}
      If lDelete <> ckbDeleteEmail.Checked Then
      Begin
        If ShowDashboardDialog('Are you sure you want to select this option?',
          mtConfirmation,
          [mbYes, mbNo]) = mrYes Then
        Begin
          ckbDeleteEmail.Checked := Not lDelete;
          lDb.SetSystemParameter(cDELETENONDSREMAILPARAM, inttostr(ord(Not
            lDelete)));
        End
        Else
          ckbDeleteEmail.Checked := lDelete;
      End; {If fDSRConf.DeleteNonDSR <> ckbDeleteEmail.Checked Then}
    End;

    lDb.free;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: lvPop3DblClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.lvPop3DblClick(Sender: TObject);
Begin
  btnUpdateClick(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: GetDb
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmDSRConfigFrame.GetDb: TAdoDSR;
Begin
  Result := Nil;

  Try
    Result := TADODSR.Create(DBServer);
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DestroyEmailAccounts
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRConfigFrame.DestroyEmailAccounts;
Var
  lCont: integer;
  lEmail: TEmailAccount;
Begin
  For lCont := 0 To lvPop3.Items.Count - 1 Do
    If lvPop3.Items[lCont].Data <> Nil Then
    Begin
      lEmail := TEmailAccount(lvPop3.Items[lCont].Data);
      If lEmail <> Nil Then
        lEmail.Free;
    End; {If lvPop3.Items[lCont].Data <> Nil Then}
End;

End.

