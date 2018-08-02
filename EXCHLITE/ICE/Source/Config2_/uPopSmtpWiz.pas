{-----------------------------------------------------------------------------
 Unit Name: uMailWiz
 Author:    vmoura
 Purpose:
 History:

 add and update e-mail accounts

-----------------------------------------------------------------------------}
Unit uPopSmtpWiz;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, htmlbtns, AdvOfficePager, AdvOfficePagerStylers, StdCtrls,
  AdvPanel, Mask, AdvEdit, AdvEdBtn, AdvFileNameEdit, AdvGroupBox,
  AdvGlowButton, AdvOfficeButtons, AdvProgressBar, HTMLabel, ExtCtrls,

  uInterfaces, uAdoDSR, uSMTP, uPOP3, uIMAP, uMailMessage, uMailbase,
  IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,

  ufrmbase

  ;

Const
  cMESSAGE = '{313C3A3C-5B9E-4B3D-BE14-D867551E7E55}';
  cFORMHEIGHT = 412;
  cBTNFINISH = '&Finish';
  cBTNNEXT = '&Next >';

  cEMAILSETTINGSMSG = 'Internet E-Mail Settings';
  cTIMEOUT = 16000;

Type
  //TfrmPOPSMTPWiz = Class(TForm)
  TfrmPOPSMTPWiz = Class(TFrmBase)
    AdvOfficePagerOfficeStyler: TAdvOfficePagerOfficeStyler;
    pgEmailSystem: TAdvOfficePager;
    pnlButtons: TAdvPanel;
    btnBack: TAdvGlowButton;
    btnNext: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    ofpEmailServer: TAdvOfficePage;
    ofpConfiguration: TAdvOfficePage;
    Panel2: TPanel;
    Label1: TLabel;
    Label16: TLabel;
    lbltestSettings: THTMLabel;
    lblLogonUser: TLabel;
    lblIncomingServer: TLabel;
    lblLogonPassw: TLabel;
    lblEmailAddress: TLabel;
    lblUserInformation: TLabel;
    lblServerInfo: TLabel;
    lblLogonInfo: TLabel;
    lblYourName: TLabel;
    lblOutgoingServer: TLabel;
    edtUserName: TAdvEdit;
    edtPop3Server: TAdvEdit;
    edtPassword: TAdvEdit;
    edtEmailAddress: TAdvEdit;
    edtYourName: TAdvEdit;
    edtSMTPServer: TAdvEdit;
    ofpFinish: TAdvOfficePage;
    Panel1: TPanel;
    lblEmailSettings: TLabel;
    Label3: TLabel;
    cbDefault: TAdvOfficeCheckBox;
    prgTest: TAdvProgressBar;
    btnTestAccount: TAdvGlowButton;
    btnViewResultTest: TAdvGlowButton;
    btnMoreSettings: TAdvGlowButton;
    ofp3rdParty: TAdvOfficePage;
    AdvGroupBox1: TAdvGroupBox;
    AdvGroupBox2: TAdvGroupBox;
    Label2: TLabel;
    edtOutgoing: TAdvFileNameEdit;
    Label4: TLabel;
    Label5: TLabel;
    edtOutgoingGuidWiz: TAdvMaskEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edtIncomingGuidWiz: TAdvMaskEdit;
    edtIncoming: TAdvFileNameEdit;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    pnlMemo: TAdvPanel;
    mmLog: TMemo;
    rgServerType: THTMLRadioGroup;
    tmRefresh: TTimer;
    AntiFreeze: TIdAntiFreeze;
    Procedure edtYourNameChange(Sender: TObject);
    Procedure btnTestAccountClick(Sender: TObject);
    Procedure btnCancelClick(Sender: TObject);
    Procedure btnViewResultTestClick(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure btnBackClick(Sender: TObject);
    Procedure btnUpdateClick(Sender: TObject);
    Procedure btnPop3AddClick(Sender: TObject);
    Procedure btnNextClick(Sender: TObject);
    Procedure btnMoreSettingsClick(Sender: TObject);
    Procedure edtOutgoingDialogExit(Sender: TObject; ExitOK: Boolean);
    Procedure FormDestroy(Sender: TObject);
    Procedure rgServerTypeClick(Sender: TObject);
    Procedure rgServerTypeEnter(Sender: TObject);
    procedure tmRefreshTimer(Sender: TObject);
  Private
    fEditPop3: Boolean;
    fEMailAccount: TEmailAccount;
    fDBServer: String;
    fIsDefault: Boolean;
    Procedure Send;
    Function SMTPSend(pMessage: TMailMessage): Boolean;
    Procedure Receive;
    Function ReceivePOP3: Boolean;
    Function ReceiveIMAP: Boolean;
    Procedure SetEditPop3(Const Value: Boolean);
    Procedure EmailSystemSelected;
    Procedure UncheckEMailServer;
    Procedure ClearValues;
    Function ValidateValues: Boolean;
    Procedure SetEMailAccount(Const Value: TEmailAccount);
    Function EmailExists: Boolean;
    Procedure UpdateEmailAccount;
    Procedure SaveEmailAccount(pEmailAccount: TEmailAccount);
    Procedure ClearEmailSystem;
    Function GetDb: TADODSR;
    Function GetEmailSystem: TEmailSystem;
    Procedure SelectEmailSystem(Const pServerType: String);
  Public
    Procedure LoadEmailSystem;
  Published
    Property EditPop3: Boolean Read fEditPop3 Write SetEditPop3 Default False;
    Property EMailAccount: TEmailAccount Read fEMailAccount Write SetEMailAccount;
    Property DBServer: String Read fDBServer Write fDBServer;
    Property Isdefault: Boolean Read fIsDefault Write fIsDefault Default False;
  End;

Var
  frmPOPSMTPWiz: TfrmPOPSMTPWiz;

Implementation

Uses usystemconfig, uconsts, uCommon, udashGlobal, uEmailSettings

  ;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: edtYourNameChange
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.edtYourNameChange(Sender: TObject);
Begin
  btnTestAccount.Enabled := (Trim(edtYourName.Text) <> '') And
    (Trim(edtEmailAddress.Text) <> '') And
    (Trim(edtPop3Server.Text) <> '') And
    (Trim(edtSMTPServer.Text) <> '') And
    (Trim(edtUserName.Text) <> '') And
    (Trim(edtPassword.Text) <> '');
  btnViewResultTest.Enabled := btnTestAccount.Enabled;
  btnMoreSettings.Enabled := btnTestAccount.Enabled;

  // keep the email account info updated
  UpdateEmailAccount;
End;

{-----------------------------------------------------------------------------
  Procedure: btnTestAccountClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.btnTestAccountClick(Sender: TObject);
Begin
  tmRefresh.Enabled := True;
  prgTest.Position := 0;
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
  tmRefresh.Enabled := False;
End;

{-----------------------------------------------------------------------------
  Procedure: Receive
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.Receive;
Var
  lRes: String;
Begin
  prgTest.Position := 80;
  lRes := 'Checking e-mail account: Failed...';

  Try
    If _IsPOP3(fEMailAccount.ServerType) Then
    Begin
      mmLog.Lines.Add('Checking POP3 login...');
      Application.ProcessMessages;

      If ReceivePOP3 Then
        lRes := 'POP3 account result : Pass...'
      Else
        lRes := 'POP3 account result : Failed...';
    End
    Else If _IsIMAP(fEMailAccount.ServerType) Then
    Begin
      mmLog.Lines.Add('Checking IMAP login...');
      Application.ProcessMessages;

      If ReceiveIMAP Then
        lRes := 'IMAP account result : Pass...'
      Else
        lRes := 'IMAP account result : Failed...'
    End;
  Finally
  End; {try..finally}

  mmLog.Lines.Add(lRes);
  prgTest.Position := 100;
  Application.ProcessMessages;
  Sleep(300);
End;

{-----------------------------------------------------------------------------
  Procedure: ReceivePOP3
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmPOPSMTPWiz.ReceivePOP3: Boolean;
Var
  lPOP3: TPOP3;
  lMsgCount, lCont: Integer;
  lMsg: TMailMessage;
Begin
  lPOP3 := TPOP3.Create;
  lPOP3.KeepTrying := False;
  lPOP3.Timeout := cTIMEOUT;
  lPOP3.Host := fEMailAccount.IncomingServer;
  lPOP3.UserName := fEMailAccount.UserName;
  lPOP3.Password := fEMailAccount.Password;
  lPOP3.IncomingPort := fEMailAccount.IncomingPort;
  lPOP3.UseAuthentication := fEMailAccount.UseSSLIncomingPort;
  lPOP3.Connected := True;
  Result := lPOP3.Connected;
  lPOP3.Connected := False;
  lPOP3.Free;
End;

{-----------------------------------------------------------------------------
  Procedure: ReceiveIMAP
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmPOPSMTPWiz.ReceiveIMAP: Boolean;
Var
  lIMAP: TIMAPReceiver;
  lMsgCount, lCont: Integer;
  lMsg: TMailMessage;
Begin
  lIMAP := TIMAPReceiver.Create;
  lIMAP.KeepTrying := False;
  lIMAP.Timeout := cTIMEOUT;
  lIMAP.MailBox := fEMailAccount.MailBoxName;
  lImap.MailBoxSeparator := fEMailAccount.MailBoxSeparator;
  lIMAP.Host := fEMailAccount.IncomingServer;
  lIMAP.UserName := fEMailAccount.UserName;
  lIMAP.Password := fEMailAccount.Password;
  lIMAP.IncomingPort := fEMailAccount.IncomingPort;
  lIMAP.UseAuthentication := fEMailAccount.UseSSLIncomingPort;
  lIMAP.Connected := True;
  Result := lIMAP.Connected;
  lIMAP.Connected := False;
  lIMAP.Free;
End;

{-----------------------------------------------------------------------------
  Procedure: Send
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.Send;
Var
  lRes: String;
  lMessage: TMailMessage;
Begin
  prgTest.Position := 10;
  Application.ProcessMessages;

  lRes := 'Failed...';
  Sleep(500);

  lMessage := TMailMessage.Create;
  lMessage.SenderName := fEMailAccount.YourName;
  lMessage.SenderAddress := fEMailAccount.YourEmail;
  lMessage.To_.Add(fEMailAccount.YourEmail);
  lMessage.Body.Add(cPIPE + cMSGBODY + cPIPE + ' ' + cCLIENTSYNCEMAILTEST);

  Try
    if SMTPSend(lMessage) then
      lRes := 'Pass...'
  Except
    On e: exception Do
      lRes := 'Failed. Reason: ' + e.Message;
  End;

  lMessage.Free;
  mmLog.Lines.Add('Sending result : ' + lRes);

  prgTest.Position := 35;
  Sleep(500);
End;

{-----------------------------------------------------------------------------
  Procedure: SMTPSend
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmPOPSMTPWiz.SMTPSend(pMessage: TMailMessage): Boolean;
Var
  lSmtp: TSMTP;
Begin
  Result := False;

  lSmtp := TSMTP.Create;
  lSmtp.KeepTrying := False;
  lSmtp.Timeout := cTIMEOUT;
  lSmtp.Host := fEMailAccount.OutgoingServer;
  lSmtp.UserName := fEMailAccount.UserName;
  lSmtp.Password := fEMailAccount.Password;
  lSmtp.OutgoingPort := fEMailAccount.OutgoingPort;
  lSmtp.UseAuthentication := fEMailAccount.Authentication;
  lSmtp.SMTPLoginUser := fEMailAccount.OutgoingUserName;
  lSmtp.SMTPLoginPassword := fEMailAccount.OutgoingPassword;

  lSmtp.Connected := True;

  If lSmtp.Connected Then
    Result := lSmtp.SendMail(pMessage);

  lSmtp.Free;
End;

{-----------------------------------------------------------------------------
  Procedure: btnCloseClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.btnCancelClick(Sender: TObject);
Begin
  ModalResult := mrCancel;
End;

{-----------------------------------------------------------------------------
  Procedure: btnViewResultTestClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.btnViewResultTestClick(Sender: TObject);
Begin
  If Height = cFORMHEIGHT Then
  Begin
    Height := 536;
    btnViewResultTest.Caption := 'Hide Test Results...';
  End
  Else
  Begin
    Height := cFORMHEIGHT;
    btnViewResultTest.Caption := 'Show Test Results...';
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.FormCreate(Sender: TObject);
Begin
  Inherited;
  
  fEMailAccount := TEmailAccount.Create;

  Height := cFORMHEIGHT - CAPTIONBARHEIGHT;

  pgEmailSystem.TabSettings.Height := 0;
  ofpConfiguration.TabVisible := FAlse;
  ofpEmailServer.TabVisible := FAlse;
  ofpFinish.TabVisible := False;
  ofp3rdParty.TabVisible := FAlse;
  AntiFreeze.Active := True;
End;

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    ModalResult := MrCancel;
End;

{-----------------------------------------------------------------------------
  Procedure: SetEditPop3
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.SetEditPop3(Const Value: Boolean);
Begin
  fEditPop3 := Value;

  If Value Then
  Begin
    pgEmailSystem.ActivePage := ofpConfiguration;
//    EmailSystemSelected;
    btnBack.Enabled := False;
    btnNext.Enabled := True;
    edtEmailAddress.Enabled := False;
  End
  Else
  Begin
    pgEmailSystem.ActivePage := ofpEmailServer;
    btnBack.Enabled := False;
    btnNext.Enabled := False;
    edtEmailAddress.Enabled := True;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: ntmUseDefaultClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.EmailSystemSelected;
Var
  lSystem: TEmailSystem;
Begin
  lblUserInformation.Visible := False;
  lblYourName.Visible := False;
  lblEmailAddress.Visible := False;
  edtYourName.Visible := False;
  edtEmailAddress.Visible := False;
  lblServerInfo.Visible := False;
  lblIncomingServer.Visible := False;
  lblOutgoingServer.Visible := False;
  edtPop3Server.Visible := False;
  edtSMTPServer.Visible := False;
  lblLogonInfo.Visible := False;
  lblLogonUser.Visible := False;
  edtUserName.Visible := False;
  lblLogonPassw.Visible := False;
  edtPassword.Visible := False;
  lbltestSettings.Visible := False;
  btnMoreSettings.Visible := False;
  btnTestAccount.Visible := FAlse;
  btnViewResultTest.Visible := False;
  cbDefault.Visible := False;

  lSystem := GetEmailSystem;

  If lSystem <> Nil Then
  Begin
    If _IsMAPI(lSystem.ServerType) Then
    Begin
      lblUserInformation.Visible := True;
      lblYourName.Visible := True;
      lblEmailAddress.Visible := True;
      edtYourName.Visible := True;
      edtEmailAddress.Visible := True;
      lblEmailSettings.Caption := cEMAILSETTINGSMSG + ' (MAPI)';
    End
    Else If _IsPOP3(lSystem.ServerType) Or _IsIMAP(lSystem.ServerType) Then
    Begin
      lblUserInformation.Visible := True;
      lblYourName.Visible := True;
      lblEmailAddress.Visible := True;
      edtYourName.Visible := True;
      edtEmailAddress.Visible := True;
      lblServerInfo.Visible := True;
      lblIncomingServer.Visible := True;
      lblOutgoingServer.Visible := True;
      edtPop3Server.Visible := True;
      edtSMTPServer.Visible := True;
      lblLogonInfo.Visible := True;
      lblLogonUser.Visible := True;
      edtUserName.Visible := True;
      lblLogonPassw.Visible := True;
      edtPassword.Visible := True;
      lbltestSettings.Visible := True;
      btnMoreSettings.Visible := True;
      btnTestAccount.Visible := True;
      btnViewResultTest.Visible := True;
      cbDefault.Visible := True;

      If _IsPOP3(lSystem.ServerType) Then
        lblEmailSettings.Caption := cEMAILSETTINGSMSG + ' (POP3)'
      Else If _IsIMAP(lSystem.ServerType) Then
        lblEmailSettings.Caption := cEMAILSETTINGSMSG + ' (IMAP)'
    End; {If _IsPOP3(lSystem.ServerType) or _IsIMAP(lSystem.ServerType) Then}
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: btnBackClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.btnBackClick(Sender: TObject);
Begin
  If (pgEmailSystem.ActivePage = ofpConfiguration) Or
    (pgEmailSystem.ActivePage = ofp3rdParty) Then
  Begin
    ClearValues;
    UncheckEMailServer;
    pgEmailSystem.ActivePage := ofpEmailServer;
    btnNext.Caption := cBTNNEXT;
    btnNext.Enabled := FAlse;
    btnBack.Enabled := False;
  End
End;

{-----------------------------------------------------------------------------
  Procedure: UncheckEMailServer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.UncheckEMailServer;
Var
  lCont: Integer;
Begin
  If rgServerType.Items.Count > 0 Then
    For lCont := 0 To rgServerType.Items.Count - 1 Do
    Try
      (rgServerType.Controls[lCont] As THTMLRadioButton).Checked := False;
    Except
    End;
End;

{-----------------------------------------------------------------------------
  Procedure: ClearValues
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.ClearValues;
Begin
  edtYourName.Clear;
  edtEmailAddress.Clear;
  edtPop3Server.Clear;
  edtSMTPServer.Clear;
  edtUserName.Clear;
  edtPassword.Clear;
End;

{-----------------------------------------------------------------------------
  Procedure: btnUpdateClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.btnUpdateClick(Sender: TObject);
Begin
  pgEmailSystem.ActivePage := ofpConfiguration;
End;

{-----------------------------------------------------------------------------
  Procedure: btnPop3AddClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.btnPop3AddClick(Sender: TObject);
Begin
  pgEmailSystem.ActivePage := ofpEmailServer;
End;

{-----------------------------------------------------------------------------
  Procedure: btnNextClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.btnNextClick(Sender: TObject);
Var
  lSystem: TEmailSystem;
Begin
  lSystem := GetEmailSystem;
  If lSystem <> Nil Then
  Begin
    If btnNext.Caption = cBTNFINISH Then
    Begin
      {update db values}
      UpdateEmailAccount;
      SaveEmailAccount(fEMailAccount);
      ModalResult := mrok;
    End
    Else If pgEmailSystem.ActivePage = ofpEmailServer Then
    Begin
      If _IsMAPI(lSystem.ServerType) Or _IsPOP3(lSystem.ServerType) Or
        _IsIMAP(lSystem.ServerType) Then
      Begin
        ClearValues;
        EmailSystemSelected;
        btnNext.Caption := cBTNNEXT;
        btnNext.Enabled := True;
        btnBack.Enabled := True;
        pgEmailSystem.ActivePage := ofpConfiguration;

        Try
          edtYourName.SetFocus;
        Except
        End;
      End
      Else
      Begin
        ClearValues;
        EmailSystemSelected;
        btnNext.Caption := cBTNNEXT;
        btnNext.Enabled := True;
        btnBack.Enabled := True;
        pgEmailSystem.ActivePage := ofp3rdParty;
        Try
          edtOutgoing.SetFocus;
        Except
        End;
      End
    End
    Else If pgEmailSystem.ActivePage = ofpConfiguration Then
    Begin
      If ValidateValues Then
      Begin
        pgEmailSystem.ActivePage := ofpFinish;
        btnBack.Enabled := False;
        btnNext.Caption := cBTNFINISH;
        btnCancel.Enabled := False;
      End; {if ValidateValues then}
    End;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: ValidateValues
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmPOPSMTPWiz.ValidateValues: Boolean;
Var
  lSystem: TEmailSystem;
Begin
  Result := True;
  lSystem := GetEmailSystem;

  If lSystem <> Nil Then
  Begin
    {common properties for mapi, pop and imap}
    If _IsMAPI(lSystem.ServerType) Or _IsPOP3(lSystem.ServerType) Or
      _IsIMAP(lSystem.ServerType) Then
    Begin
      If edtYourName.Text = '' Then
      Begin
        ShowDashboardDialog('Invalid user information name!', mtInformation,
          [mbok]);
        If edtYourName.CanFocus Then
          edtYourName.SetFocus;
        Result := False;
        Abort;
      End; {If edtYourName.Text = '' Then}

      If edtEmailAddress.Text = '' Then
      Begin
        ShowDashboardDialog('Invalid E-Mail address!', mtInformation, [mbok]);

        If edtEmailAddress.CanFocus Then
          edtEmailAddress.SetFocus;
        Result := False;
        Abort;
      End; {If edtEmailAddress.Text = '' Then}
    End; {If rbMAPI.Checked Or rbPOP3.Checked Or rbIMAP.Checked Then}

    If Not EditPop3 And EmailExists Then
    Begin
      ShowDashboardDialog('The e-mail address you are trying to add, clashes with another record in the e-mail account matrix.'#13#13
        + 'You must amend your record in order to be able to save it.', mtWarning,
        [mbOK]);
      Result := False;
      Abort;
    End; {if EmailExists then}

    {common property for pop and imap}
    If _IsPOP3(lSystem.ServerType) Or _IsIMAP(lSystem.ServerType) Then
    Begin
      If edtPop3Server.Text = '' Then
      Begin
        ShowDashboardDialog('Invalid incoming e-mail server!', mtInformation,
          [mbok]);

        If edtPop3Server.CanFocus Then
          edtPop3Server.SetFocus;
        Result := False;
        Abort;
      End; {If edtPop3Server.Text = '' Then}

      If edtSMTPServer.Text = '' Then
      Begin
        ShowDashboardDialog('Invalid outgoing e-mail server!', mtInformation,
          [mbok]);

        If edtSMTPServer.CanFocus Then
          edtSMTPServer.SetFocus;
        Result := False;
        Abort;
      End; {If edtSMTPServer.Text = '' Then}

      If edtUserName.Text = '' Then
      Begin
        ShowDashboardDialog('Invalid user name!', mtInformation, [mbok]);

        If edtUserName.CanFocus Then
          edtUserName.SetFocus;
        Result := False;
        Abort;
      End; {If edtUserName.Text = '' Then}

      If edtPassword.Text = '' Then
      Begin
        ShowDashboardDialog('Invalid password!', mtInformation, [mbok]);

        If edtPassword.CanFocus Then
          edtPassword.SetFocus;
        Result := False;
        Abort;
      End; {If edtSMTPServer.Text = '' Then}
    End;

    If _Is3rdPRT(lSystem.ServerType) Then
    Begin
      If Not _IsValidGuid(edtOutgoingGuidWiz.Text) Then
      Begin
        ShowDashboardDialog('Invalid GUID information for the outgoing system.' + #13
          + #10 +
          'Select a valid DLL or enter the GUID mannualy.', mtError, [mbok]);
        Result := False;
        Abort;
      End; {if not _IsValidGuid(edtOutgoingGuidWiz.Text) then}

      If Not _IsValidGuid(edtIncomingGuidWiz.Text) Then
      Begin
        ShowDashboardDialog('Invalid GUID information for the incoming system.' + #13
          + #10 +
          'Select a valid DLL or enter the GUID mannualy.', mtError, [mbok]);
        Result := False;
        Abort;
      End; {if not _IsValidGuid(edtIncomingGuidWiz.Text) then}
    End; {if _Is3rdPRT(lSystem.ServerType) then}
  End
  Else
    Result := False;
End;

{-----------------------------------------------------------------------------
  Procedure: btnMoreSettingsClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.btnMoreSettingsClick(Sender: TObject);
Begin
  Application.CreateForm(TfrmEmailSettings, frmEmailSettings);
  With frmEmailSettings Do
  Begin
    {fill form information}
    edtPOP3Port.IntValue := fEMailAccount.IncomingPort;
    edtSMTPPort.IntValue := fEMailAccount.OutgoingPort;
    ckbOutgoingAuth.Checked := fEMailAccount.Authentication;
    If fEMailAccount.Authentication Then
    Begin
      rbSameasIncoming.Enabled := True;
      rbLogonUsing.Enabled := True;
      If (fEMailAccount.UserName = fEMailAccount.OutgoingUserName) And
        (fEMailAccount.Password = fEMailAccount.OutgoingPassword) Then
        rbSameasIncoming.Checked := True
      Else
      Begin
        rbLogonUsing.Checked := True;
        edtOutgoingUserName.Text := fEMailAccount.OutgoingUserName;
        edtOutgoingPassword.Text := fEMailAccount.OutgoingPassword;
      End;
    End
    Else
      ckbOutgoingAuthClick(self);

    ckbPOPEncrypted.Checked := fEMailAccount.UseSSLIncomingPort;
    ckbSMTPEncrypted.Checked := fEMailAccount.UseSSLOutgoingPort;

    If _IsIMAP(fEMailAccount.ServerType) Then
    Begin
      edtMailBoxName.Visible := True;
      edtMailBoxSeparator.Visible := True;

      edtMailBoxName.Text := fEMailAccount.MailBoxName;
      edtMailBoxSeparator.Text := fEMailAccount.MailBoxSeparator;
    End;

    {update the object properties}
    If ShowModal = mrOK Then
    Begin
      fEMailAccount.IncomingPort := edtPOP3Port.IntValue;
      fEMailAccount.OutgoingPort := edtSMTPPort.IntValue;
      fEMailAccount.Authentication := ckbOutgoingAuth.Checked;
      If rbSameasIncoming.Checked Then
      Begin
        fEMailAccount.OutgoingUserName := fEMailAccount.UserName;
        fEMailAccount.OutgoingPassword := fEMailAccount.Password;
      End
      Else If rbLogonUsing.Checked Then
      Begin
        fEMailAccount.OutgoingUserName := edtOutgoingUserName.Text;
        fEMailAccount.OutgoingPassword := edtOutgoingPassword.Text;
      End;

      fEMailAccount.UseSSLIncomingPort := ckbPOPEncrypted.Checked;
      fEMailAccount.UseSSLOutgoingPort := ckbSMTPEncrypted.Checked;
      fEMailAccount.MailBoxName := edtMailBoxName.Text;
      Try
        fEMailAccount.MailBoxSeparator := edtMailBoxSeparator.Text[1];
      Except
      End;
    End; {If ShowModal = mrOK Then}

    Free;
  End; {with frmEmailSettings do}
End;

{-----------------------------------------------------------------------------
  Procedure: edtOutgoingDialogExit
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.edtOutgoingDialogExit(Sender: TObject;
  ExitOK: Boolean);
Var
  lStr: TStringlist;
Begin
  If ExitOK Then
  Begin
    lStr := TStringlist.Create;
    {load info from a win32 dll}
    Try
      _GetGuidsFromDll((Sender As TAdvFileNameEdit).Text, lStr);
    Except
    End;

    If lStr.Count = 1 Then
    Begin
      {check for just one guid loaded..}
      If lStr.Count = 1 Then
      Begin
        {tag - 0 = outgoing, tag - 1 = incoming}
        If (Sender As TAdvFileNameEdit).Tag = 0 Then
          edtOutgoingGuidWiz.Text := lStr.Text
        Else
          edtIncomingGuidWiz.Text := lStr.Text
      End
    End
    Else
      ShowDashboardDialog('The Dashboard could not load the information required.' +
        #13 + #10
        + 'Please contact support for help.', mtError, [mbok]);

    lStr.Free;
  End; {If ExitOK Then}
End;

{-----------------------------------------------------------------------------
  Procedure: SetEMailAccount
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.SetEMailAccount(Const Value: TEmailAccount);
Begin
  If Value <> Nil Then
  Begin
    fEMailAccount.Assign(Value);
    edtYourName.Text := Value.YourName;
    edtEmailAddress.Text := value.YourEmail;
    edtPop3Server.Text := value.IncomingServer;
    edtSMTPServer.Text := value.OutgoingServer;
    edtUserName.Text := value.UserName;
    {get the real password, otherwise it is going to update the facked string}
    Try
      edtPassword.Text := value.Password;
    Except
      edtPassword.Text := '';
    End;

    SelectEmailSystem(Value.ServerType);

    cbDefault.Checked := value.IsDefaultOutgoing;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: FormDestroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.FormDestroy(Sender: TObject);
Begin
  AntiFreeze.Active := False;
  If Assigned(fEMailAccount) Then
    fEMailAccount.Free;

  ClearEmailSystem;

  inherited;
End;

{-----------------------------------------------------------------------------
  Procedure: EmailExists
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmPOPSMTPWiz.EmailExists: Boolean;
Var
  lDb: TADODSR;
Begin
  Result := FAlse;
  lDb := GetDb;

  If Assigned(lDb) Then
  Begin
    If lDb.Connected Then
      Result := lDb.EmailExists(edtEmailAddress.Text);

    lDb.Free;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: UpdateEmailAccount
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.UpdateEmailAccount;
Var
  lEmailSystem: TEmailSystem;
Begin
  lEmailSystem := GetEmailSystem;
  If lEmailSystem <> Nil Then
  Begin
    fEMailAccount.servertype := lEmailSystem.ServerType;
    fEMailAccount.EmailSystem_ID := lEmailSystem.Id;
    fEMailAccount.YourName := edtYourName.Text;
    fEMailAccount.YourEmail := edtEmailAddress.Text;
    fEMailAccount.IncomingServer := edtPop3Server.Text;
    fEMailAccount.OutgoingServer := edtSMTPServer.Text;
    fEMailAccount.UserName := edtUserName.Text;
    fEMailAccount.Password := edtPassword.Text;
    fEMailAccount.IsDefaultOutgoing := cbDefault.Checked Or fIsDefault;
  End; {If lEmailSystem <> Nil Then}
End;

{-----------------------------------------------------------------------------
  Procedure: SaveEmailAccount
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.SaveEmailAccount(pEmailAccount: TEmailAccount);
Var
  lDb: TADODSR;
Begin
  lDb := GetDb;

  If Assigned(lDb) Then
  Begin
    If lDb.Connected Then
    Begin
      If EditPop3 Then
        lDb.UpdateEmailAccount(pEmailAccount, dbDoUpdate)
      Else
        lDb.UpdateEmailAccount(pEmailAccount, dbDoAdd);
    End; {if lDb.Connected then}

    lDb.Free;
  End; {if Assigned(lDb) then}
End;

{-----------------------------------------------------------------------------
  Procedure: GetDb
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmPOPSMTPWiz.GetDb: TADODSR;
Begin
  Result := Nil;
  Try
    Result := TADODSR.Create(DBServer);
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: LoadEmailSystem
  Author:    vmoura

  MUST be called AFTER setting the DBserver... otherwise, no email system will be loaded
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.LoadEmailSystem;
  Function EmailSystemCaption(pSystem: TEmailSystem): String;
  Begin
    Result := '<B>' + pSystem.ServerType + '</B><BR>' + pSystem.Description;
  End;

Var
  lDb: TADODSR;
  lESystem: Olevariant;
  lTotal, lCont: Integer;
  lREsult: Longword;
  lemail: TEmailSystem;
Begin
  lDb := GetDb;

  If Assigned(lDb) Then
  Begin
    If lDb.Connected Then
    Begin
      ClearEmailSystem;
      rgServerType.Items.Clear;

      lESystem := lDb.GetEmailSystem(lResult);
      lTotal := _GetOlevariantArraySize(lESystem);

      For lCont := 0 To lTotal - 1 Do
      Begin
        lemail := _CreateEmailSystem(lESystem[lCont]);
        If lemail <> Nil Then
          rgServerType.Items.AddObject(EmailSystemCaption(lemail), lemail)
      End;
    End; {if lDb.Connected then}

    lDb.Free;
  End; {if Assigned(lDb) then}
End;

{-----------------------------------------------------------------------------
  Procedure: ClearEmailSystem
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.ClearEmailSystem;
Var
  lCont: Integer;
  lSystem: TEmailSystem;
Begin
  If rgServerType.Items.Count > 0 Then
    For lCont := 0 To rgServerType.Items.Count - 1 Do
      If rgServerType.Items.Objects[lCont] <> Nil Then
      Begin
        lSystem := TEmailSystem(rgServerType.Items.Objects[lCont]);
        If lSystem <> Nil Then
          lSystem.Free;
      End; {if rgServerType.Items.Objects[lCont] <> nil then}
End;

{-----------------------------------------------------------------------------
  Procedure: GetEmailSystem
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmPOPSMTPWiz.GetEmailSystem: TEmailSystem;
Begin
  Result := Nil;
  If rgServerType.Items.Count > 0 Then
    If rgServerType.ItemIndex >= 0 Then
      Result := TEmailSystem(rgServerType.Items.Objects[rgServerType.ItemIndex]);
End;

{-----------------------------------------------------------------------------
  Procedure: rgServerTypeClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.rgServerTypeClick(Sender: TObject);
Var
  lSystem: TEmailSystem;
Begin
  lSystem := GetEmailSystem;

  If lSystem <> Nil Then
    btnNext.Enabled := _IsMAPI(lSystem.ServerType) Or _IsPOP3(lSystem.ServerType)
      Or _IsIMAP(lSystem.ServerType) Or _Is3rdPRT(lSystem.ServerType);
End;

{-----------------------------------------------------------------------------
  Procedure: rgServerTypeEnter
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.rgServerTypeEnter(Sender: TObject);
Begin
  If rgServerType.Items.Count > 0 Then
  Try
    (rgServerType.Controls[0] As THTMLRadioButton).SetFocus;
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: SelectEmailSystem
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmPOPSMTPWiz.SelectEmailSystem(Const pServerType: String);
Var
  lCont: Integer;
  lSystem: TEmailSystem;
Begin
  For lCont := 0 To rgServerType.Items.Count - 1 Do
    If rgServerType.Items.Objects[lCont] <> Nil Then
    Begin
      lSystem := TEmailSystem(rgServerType.Items.Objects[lCont]);
      If lSystem <> Nil Then
        If lowercase(Trim(lSystem.ServerType)) = lowercase(Trim(pServerType)) Then
        Begin
          rgServerType.ItemIndex := lCont;
          Break;
        End; {if lowercase(Trim(lSystem.ServerType)) = lowercase(Trim(pServerType)) then}
    End; {if rgServerType.Items.Objects[lCont] <> nil then}
End;

procedure TfrmPOPSMTPWiz.tmRefreshTimer(Sender: TObject);
begin
  Application.ProcessMessages;
end;

End.

