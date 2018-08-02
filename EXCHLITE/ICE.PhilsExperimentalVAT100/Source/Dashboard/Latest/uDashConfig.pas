{-----------------------------------------------------------------------------
 Unit Name: uDashConfig
 Author:    vmoura
 Purpose: set up the dashboard and the dsr settings
 History:

 changed the dsr settings to work with a frame (sharing with the config.exe).
-----------------------------------------------------------------------------}
Unit uDashConfig;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, uDSRConfigFrame, Mask, AdvSpin, StdCtrls,
  AdvEdit, AdvOfficePager, AdvGlowButton, AdvOfficePagerStylers, AdvPanel,
  uADODSR, AdvOfficeButtons, AdvGroupBox, AdvScrollBox
  ;

Type
  TfrmConfiguration = Class(TForm)
    advPanel: TAdvPanel;
    btnSave: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    ofConfig: TAdvOfficePager;
    ofpDash: TAdvOfficePage;
    ofpDsr: TAdvOfficePage;
    Label2: TLabel;
    edtCompanyName: TAdvEdit;
    pgStyler: TAdvOfficePagerOfficeStyler;
    gbAditional: TAdvGroupBox;
    gbServers: TAdvGroupBox;
    lblDbServer: TLabel;
    edtDatabaseServer: TAdvEdit;
    lbServiceServer: TLabel;
    edtDSRServer: TAdvEdit;
    seDSRPort: TAdvSpinEdit;
    lblPort: TLabel;
    btnBrowseDbServer: TAdvGlowButton;
    btnBrowseClientSync: TAdvGlowButton;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    frmDSRConfigFrame: TfrmDSRConfigFrame;
    ScrollBox1: TAdvScrollBox;
    pnlDash: TAdvPanel;
    cbDripFeed: TAdvOfficeCheckBox;
    cbShowAlert: TAdvOfficeCheckBox;
    cbShowReminder: TAdvOfficeCheckBox;
    cbExportAddon: TAdvOfficeCheckBox;
    cbImportAddon: TAdvOfficeCheckBox;
    pnlCIS: TAdvPanel;
    cbUseTestGateway: TAdvOfficeCheckBox;
    AdvOfficeCheckBox4: TAdvOfficeCheckBox;
    AdvOfficeCheckBox5: TAdvOfficeCheckBox;
    Procedure btnFindDSRClick(Sender: TObject);
    Procedure btnCancelClick(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure btnSaveClick(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure pcConfigChange(Sender: TObject);
    Procedure btnBrowseDbServerClick(Sender: TObject);
    Procedure btnBrowseClientSyncClick(Sender: TObject);
    Procedure ofConfigChange(Sender: TObject);
    procedure cbUseTestGatewayClick(Sender: TObject);
  Private
    fDB: TADODSR;
    Procedure LoadDashSettings;
    Procedure LoadDSRSettings;

    Procedure SaveDashSettings;
    Procedure SaveDSRSettings;

    Procedure ApplyCISChanges;
  Public
  End;

Var
  frmConfiguration: TfrmConfiguration;

Implementation

Uses uBaseClass, uDsr, udashSettings, uCommon, uDashGlobal, uConsts;

{$R *.dfm}

{ TfrmConfiguration }

{-----------------------------------------------------------------------------
  Procedure: LoadDashSettings
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConfiguration.LoadDashSettings;
Begin
  edtDatabaseServer.Text := _DashboardGetDBServer;
  edtDSRServer.Text := _DashboardGetDSRServer;
  seDSRPort.Value := _DashboardGetDSRPort;
//  cbShowAlert.Checked := _DashboardGetShowAlert;
  cbExportAddon.Checked := _DashboardGetExportAddon;
  cbImportAddon.Checked := _DashboardGetImportAddon;
//  cbShowReminder.Checked := _DashboardGetShowReminder;

  edtCompanyName.Text := fDb.GetSystemValue(cCOMPANYNAMEPARAM);

(*  edtCISRegistrationID.Text := fDb.GetSystemValue(cCISREGIDPARAM);
  edtCISPassword.Text := fDb.GetSystemValue(cCISREGPASSPARAM);*)

  cbShowReminder.Checked := fDb.GetSystemValue(cSHOWREMINDERPARAM) = '1';
  cbShowAlert.Checked := fDb.GetSystemValue(cSHOWALERTPARAM) = '1';
  frmDSRConfigFrame.edtPollingTime.Value := StrToIntDef(fDb.GetSystemValue(cPOLLINGTIMEPARAM), 1);
End;

{-----------------------------------------------------------------------------
  Procedure: LoadDSRSettings
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConfiguration.LoadDSRSettings;
Var
  lXml: WideString;
  lRes: LongWord;
  lLog: _Base;
Begin
  lRes := S_False;
  lLog := _Base.Create;
  lLog.ConnectionString := _DSRFormatConnectionString(_DashboardGetDBServer);

  ofpDsr.Enabled := False;
  cbDripFeed.Enabled := glDSROnline;

  {deactivate option for automatic drip feed when vao is set}
  If glIsVAO Then
  Begin
    cbDripFeed.Checked := False;
    cbDripFeed.Enabled := False;
  End; {if glIsVAO then}

  {load main client sync settings}
  If glDSROnline Then
    lRes := TDSR.DSR_GetDsrSettings(_DashboardGetDSRServer,
      _DashboardGetDSRPort, lXml);

  Application.ProcessMessages;
  {check the dsr setting}
  If lRes = S_Ok Then
  Begin
    ofpDsr.Enabled := True;

    frmDSRConfigFrame.Conf.TranslateXmltoDSRSettings(lXml);

    If Not glIsVAO Then
      cbDripFeed.Checked := frmDSRConfigFrame.Conf.AutomaticDripFeed;

    cbUseTestGateway.Checked := frmDSRConfigFrame.Conf.UseCISTest;

    {load mail settings}
    lXml := '';
    lRes := TDSR.DSR_GetMailSettings(_DashboardGetDSRServer,
      _DashboardGetDSRPort, lXml);

    Application.ProcessMessages;
    {check mail setting}
    If lRes = S_OK Then
      frmDSRConfigFrame.Conf.TranslateXmltoMailSettings(lXml);

//    If Trim(frmDSRConfigFrame.Conf.CompanyName) <> '' Then
//      edtCompanyName.Text := frmDSRConfigFrame.Conf.CompanyName;
  End {if lRes = S_Ok then}
  Else
  Begin
    lLog.DoLogMessage('TfrmConfiguration.LoadDSRSettings', 0,
      //'Error loading Client Sync Settings. Error: ' + _TranslateErrorCode(lRes),
      'Error loading Dashboard Settings. Error: ' + _TranslateErrorCode(lRes),
      True, True);

    If (Trim(lXml) = '') And glDSROnline Then
      lLog.DoLogMessage('TfrmConfiguration.LoadDSRSettings', 0,
        'The Microsoft XML object might be corrupted.', True, True);
  End;

  lLog.Free;

  {display dsr settings}
  If lRes = S_OK Then
  Begin
    frmDSRConfigFrame.LoadDSRSettings;
    frmDSRConfigFrame.LoadDSRPopMails;
  End; {If lRes = S_OK Then}
End;

{-----------------------------------------------------------------------------
  Procedure: btnFindDSRClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConfiguration.btnFindDSRClick(Sender: TObject);
Var
  lServer: String;
Begin
  _BrowseComputer('Select the DSR Server', lServer, false);

  If lServer <> '' Then
    edtDSRServer.Text := lServer;
End;

{-----------------------------------------------------------------------------
  Procedure: btnCancelClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConfiguration.btnCancelClick(Sender: TObject);
Begin
//  If ((_DashboardGetCompanyName) = '') And (edtCompanyName.Text <> '') And
//    (frmDSRConfigFrame.Conf.CompanyName <> '') And glDSROnline Then
//    _DashboardSetCompanyName(edtCompanyName.Text);

  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConfiguration.FormCreate(Sender: TObject);
Begin
  ofConfig.ActivePage := ofpDsr;
  ofConfig.ActivePage := ofpDash;
  Self.HelpContext := 3;
  ActiveControl := edtCompanyName;
  lbServiceServer.Caption := _GetProductName(glProductNameIndex) + ' Server Name';

  frmDSRConfigFrame.Conf.IniFileName := GUIDToString(_CreateGuid);
  frmDSRConfigFrame.Conf.MailFileName := GUIDToString(_CreateGuid);
  frmDSRConfigFrame.ckbDeleteEmail.Caption := '<FONT face="Arial">Delete non related ' + _GetProductName(glProductNameIndex) +' e-mails</FONT>';

  Try
    fDB := TADODSR.Create(_DashboardGetDBServer);
  Except
  End;

  LoadDashSettings;

  {set CIS configuration}
  If glISCIS Then
  Begin
    lblInfo.Caption := 'Dashboard Configuration';
    pnlDash.Visible := False;
    pnlCIS.Visible := True;
    //gbAditional.Visible := False;
  End
  Else
  Begin
    lblInfo.Caption := 'Dashboard and E-Mail Configuration';
    pnlDash.Visible := True;
    pnlCIS.Visible := False;
  End; {else begin}

  Application.ProcessMessages;

  Try
    LoadDSRSettings;
  Finally
    If Not glDSROnline Then
    Begin
      ofpDsr.Enabled := False;
//      edtCompanyName.Enabled := False;
    End; {If Not glDSROnline Then}
  End; {try}

  If glISCIS Then
    ApplyCISChanges
  Else
    ofpDsr.TabVisible := True;
End;

{-----------------------------------------------------------------------------
  Procedure: SaveDashSettings
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConfiguration.SaveDashSettings;
Begin
  If Trim(edtDatabaseServer.Text) = '' Then
  Begin
    ShowDashboardDialog('Invalid database server name!', mtInformation, [mbok]);

    If edtDatabaseServer.CanFocus Then
      edtDatabaseServer.SetFocus;
    Abort;
  End; {If Trim(edtDatabaseServer.Text) = '' Then}

  If Trim(edtDSRServer.Text) = '' Then
  Begin
    //ShowDashboardDialog('Invalid Client Sync server name!', mtInformation, [mbok]);
    ShowDashboardDialog('Invalid ' + _GetProductName(glProductNameIndex) + ' Server name!', mtInformation, [mbok]);

    If edtDSRServer.CanFocus Then
      edtDSRServer.SetFocus;
    Abort;
  End; {If Trim(edtDSRServer.Text) = '' Then}

  If seDSRPort.Value <= 0 Then
  Begin
    ShowDashboardDialog('Invalid ' + _GetProductName(glProductNameIndex) + ' port number!', mtInformation, [mbok]);

    If seDSRPort.CanFocus Then
      seDSRPort.SetFocus;
    Abort;
  End; {If seDSRPort.Value <= 0 Then}

  If edtCompanyName.Enabled And (Trim(edtCompanyName.Text) = '') Then
  Begin
    ShowDashboardDialog('Invalid company name!', mtInformation, [mbok]);

    If edtCompanyName.CanFocus Then
      edtCompanyName.SetFocus;
    Abort;
  End; {If Trim(edtCompanyName.Text) = '' Then}

  _DashboardSetDBServer(edtDatabaseServer.Text);
  _DashboardSetDSRServer(edtDSRServer.Text);
  _DashboardSetDSRPort(seDSRPort.Value);
//  _DashboardSetCompanyName(edtCompanyName.Text);

   fDb.SetSystemParameter(cCOMPANYNAMEPARAM, edtCompanyName.Text);
   {cis params}

(*   fDb.SetSystemParameter(cCISREGIDPARAM, edtCISRegistrationID.Text);
   fDb.SetSystemParameter(cCISREGPASSPARAM, edtCISPassword.Text);*)

//  cSHOWREMINDERPARAM = 'ShowReminder';
///  cSHOWALERTPARAM = 'ShowAlert';
 // cPOLLINGTIMEPARAM = 'PollingTime';

  fDb.SetSystemParameter(cSHOWREMINDERPARAM, Inttostr(Ord(cbShowReminder.Checked)));

  fDb.SetSystemParameter(cSHOWALERTPARAM, Inttostr(Ord(cbShowAlert.Checked)));

  fDb.SetSystemParameter(cPOLLINGTIMEPARAM, Inttostr(frmDSRConfigFrame.edtPollingTime.Value));

  //_DashboardSetShowReminder(cbShowReminder.Checked);
  //_DashboardSetPollingTime(frmDSRConfigFrame.edtPollingTime.Value);

//  _DashboardSetShowAlert(cbShowAlert.Checked);
  
  _DashboardSetExportAddon(cbExportAddon.Checked And cbExportAddon.Visible);
  _DashboardSetImportAddon(cbImportAddon.Checked And cbImportAddon.Visible);
End;

{-----------------------------------------------------------------------------
  Procedure: SaveDSRSettings
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConfiguration.SaveDSRSettings;
Var
  lXml,
    lTrans: WideString;
  lRes: Longword;
Begin
  frmDSRConfigFrame.Conf.CompanyName := edtCompanyName.Text;

  frmDSRConfigFrame.Conf.AutomaticDripFeed := cbDripFeed.Checked;
  frmDSRConfigFrame.Conf.DBServer := edtDatabaseServer.Text;

  frmDSRConfigFrame.SaveDSRSettings;

  lXml := frmDSRConfigFrame.conf.TranslateDSRSettingstoXml;
  lRes := TDSR.DSR_UpdateDsrSettings(_DashboardGetDSRServer, _DashboardGetDSRPort,
    lXml);

  If lRes = S_OK Then
  Begin
    lXml := frmDSRConfigFrame.Conf.TranslateMailSettingstoXml;
    If frmDSRConfigFrame.Conf.UseMapi Then
      //_DashboardSetDefaultMail(frmDSRConfigFrame.Conf.CompanyName)
      //fDB.SetSystemParameter(cDEFAULTEMAILPARAM, edtCompanyName.Text)
      fDB.SetSystemParameter(cDEFAULTEMAILPARAM, frmDSRConfigFrame.Conf.DefaultMapiEmail)
    Else
    Begin
      If frmDSRConfigFrame.Conf.DefaultEmail <> '' Then
        //_DashboardSetDefaultMail(frmDSRConfigFrame.Conf.DefaultEmail)
        fDB.SetSystemParameter(cDEFAULTEMAILPARAM, frmDSRConfigFrame.Conf.DefaultEmail)
    End;

    If Not glISCIS Then
      lRes := TDsr.DSR_UpdateMailSettings(_DashboardGetDSRServer,
        _DashboardGetDSRPort, lXml)
    Else
      lRes := S_OK;

    If lRes = S_Ok Then
      btnCancelClick(Self);
  End; {if TDSR.DSR_UpdateDsrSettings}

  If (lRes <> S_OK) And Not glISCIS Then
  Begin
    Try
      lTrans := TDSR.DSR_TranslateErrorCode(_DashboardGetDSRServer,
        _DashboardGetDSRPort, lRes);
    Except
      lTrans := 'Unrecognised error';
    End;

    ShowDashboardDialog('An exception has occurred while saving Dashboard settings:' + #13#10 + lTrans, mtError, [mbok])

  End; {if lRes <> S_OK then}
End;

{-----------------------------------------------------------------------------
  Procedure: btnSaveClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConfiguration.btnSaveClick(Sender: TObject);
Begin
  SaveDashSettings;
  If glDSROnline Then
    SaveDSRSettings;
End;

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConfiguration.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    btnCancelClick(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: FormClose
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConfiguration.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  If Assigned(fDb) Then
    FreeAndNil(fDB);

  _DelFile(frmDSRConfigFrame.Conf.IniFileName);
  _DelFile(frmDSRConfigFrame.Conf.MailFileName);
End;

{-----------------------------------------------------------------------------
  Procedure: pcConfigChange
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConfiguration.pcConfigChange(Sender: TObject);
Begin
  ofpDsr.Enabled := glDSROnline;
End;

{-----------------------------------------------------------------------------
  Procedure: btnBrowseDbServerClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConfiguration.btnBrowseDbServerClick(Sender: TObject);
Var
  lServer: String;
Begin
  _BrowseComputer('Select a Database server name...', lServer, false);

  If lServer <> '' Then
    edtDatabaseServer.Text := lServer;
End;

{-----------------------------------------------------------------------------
  Procedure: btnBrowseClientSyncClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConfiguration.btnBrowseClientSyncClick(Sender: TObject);
Var
  lServer: String;
Begin
  //_BrowseComputer('Select a Client Sync server name...', lServer, false);
  _BrowseComputer('Select a ' + _GetProductName(glProductNameIndex) + ' Server name...', lServer, false);

  If lServer <> '' Then
    edtDSRServer.Text := lServer;
End;

{-----------------------------------------------------------------------------
  Procedure: ofConfigChange
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConfiguration.ofConfigChange(Sender: TObject);
Begin
  If ofConfig.ActivePage = ofpDash Then
    Self.HelpContext := 3
  Else If ofConfig.ActivePage = ofpDsr Then
  Begin
    Case frmDSRConfigFrame.rbConnectionType.ItemIndex Of
      0: Self.HelpContext := 5;
      1: Self.HelpContext := 6;
      2: Self.HelpContext := 8;
    End; {case frmDSRConfigFrame.rbConnectionType.ItemIndex of}
  End; {If ofConfig.ActivePage = ofpDsr Then}
End;

{-----------------------------------------------------------------------------
  Procedure: ApplyCISChanges
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConfiguration.ApplyCISChanges;
Begin
  ofpDsr.TabVisible := False;
  lbServiceServer.Caption := _GetProductName(glProductNameIndex) + ' Server Name';
  cbDripFeed.Checked := False;
  cbDripFeed.Visible := False;
  frmDSRConfigFrame.rbConnectionType.ItemIndex := -1;
  cbShowAlert.Checked := False;
  cbShowAlert.Visible := False;
  cbShowReminder.Checked := False;
  cbShowReminder.Visible := False;

End;

{-----------------------------------------------------------------------------
  Procedure: ckbUseTestGatewayClick
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmConfiguration.cbUseTestGatewayClick(Sender: TObject);
begin
  {check if something has changed}
  If frmDSRConfigFrame.Conf.UseCISTest <> cbUseTestGateway.Checked Then
  Begin
    If ShowDashboardDialog('Are you sure you want to select this option?', mtConfirmation,
      [mbYes, mbNo]) = mrYes Then
    Begin
      cbUseTestGateway.Checked := Not frmDSRConfigFrame.Conf.UseCISTest;
      frmDSRConfigFrame.Conf.UseCISTest := Not frmDSRConfigFrame.Conf.UseCISTest;
    End
    Else
      cbUseTestGateway.Checked := frmDSRConfigFrame.Conf.UseCISTest;
  End; {If frmDSRConfigFrame.Conf.UseCISTest <> ckbUseTestGateway.Checked Then}
end;

End.

