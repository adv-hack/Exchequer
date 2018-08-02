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
  uADODSR, AdvOfficeButtons, AdvGroupBox, AdvScrollBox,

  ufrmBase

  ;

Const
  cINFOCAPTION = '%s %s Configuration';
  cTABCAPTION = '&%s Settings';

Type
  //TfrmConfiguration = Class(TForm)
  TfrmConfiguration = Class(TfrmBase)
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
    edtInstance: TAdvEdit;
    Label1: TLabel;
    Procedure btnFindDSRClick(Sender: TObject);
    Procedure btnCancelClick(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure btnSaveClick(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure pcConfigChange(Sender: TObject);
    Procedure btnBrowseDbServerClick(Sender: TObject);
    Procedure btnBrowseClientSyncClick(Sender: TObject);
    Procedure ofConfigChange(Sender: TObject);
    Procedure cbUseTestGatewayClick(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    procedure seDSRPortChange(Sender: TObject);
  Private
    fDB: TADODSR;
    fDSRPortChanged: Boolean;
    Procedure LoadDashSettings;
    Procedure LoadDSRSettings;

    Function SaveDashSettings: Boolean;
    Procedure SaveDSRSettings;

    Procedure ApplyCISChanges;
  Public
  published
    property DSRPortChanged: Boolean read fDSRPortChanged write fDSRPortChanged default False; 
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
var
  lPos: Integer;
Begin
  lPos := Pos('\', _DashboardGetDBServer);

  if lPos > 0 then
    edtDatabaseServer.Text := Copy(_DashboardGetDBServer, 1, lPos -1)
  else
    edtDatabaseServer.Text := _DashboardGetDBServer;
    
  if (Trim(edtDatabaseServer.Text) = '') and (_DashboardGetDBServer <> '') and (lPos = 0) then
    edtDatabaseServer.Text := _DashboardGetDBServer;

  if lPos > 0 then
    edtInstance.Text := Copy(_DashboardGetDBServer, lPos+ 1, Length(_DashboardGetDBServer));

  edtDSRServer.Text := _DashboardGetDSRServer;
  seDSRPort.Value := _DashboardGetDSRPort;
  cbExportAddon.Checked := _DashboardGetExportAddon;
  cbImportAddon.Checked := _DashboardGetImportAddon;

  edtCompanyName.Text := fDb.GetSystemValue(cCOMPANYNAMEPARAM);

  cbShowReminder.Checked := fDb.GetSystemValue(cSHOWREMINDERPARAM) = '1';
  cbShowAlert.Checked := fDb.GetSystemValue(cSHOWALERTPARAM) = '1';

  frmDSRConfigFrame.DBServer := _DashboardGetDBServer;

  frmDSRConfigFrame.edtPollingTime.Value :=
    StrToIntDef(fDb.GetSystemValue(cPOLLINGTIMEPARAM), 1);

//  fdb.SetSystemParameter(cCOMPANYNAMEPARAM, edtCompanyName.Text);
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

  cbUseTestGateway.Checked := fdb.GetSystemValue(cUSECISTESTPARAM) = '1';
//  cbDripFeed.Checked := fdb.GetSystemValue(cAUTOMATICDRIPFEEDPARAM) = '1';

//  If Not glIsVAO Then
//    cbDripFeed.Checked := fdb.GetSystemValue(cAUTOMATICDRIPFEEDPARAM) = '1';

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

    //cbUseTestGateway.Checked := fdb.GetSystemValue(cUSECISTESTPARAM) = '1';

    {load mail settings}
    //lXml := '';
    //lRes := TDSR.DSR_GetMailSettings(_DashboardGetDSRServer,
    //  _DashboardGetDSRPort, lXml);

    Application.ProcessMessages;
  End {if lRes = S_Ok then}
  Else
  Begin
    lLog.DoLogMessage('TfrmConfiguration.LoadDSRSettings', 0,
      'Error loading ' + _GetProductName(glProductNameIndex) + ' Settings. Error: '
        + _TranslateErrorCode(lRes),
      True, True);

    If (Trim(lXml) = '') And glDSROnline Then
      lLog.DoLogMessage('TfrmConfiguration.LoadDSRSettings', 0,
        'The Microsoft XML object might be corrupted.', True, True);
  End;

  lLog.Free;

  {display dsr settings}
  If lRes = S_OK Then
    frmDSRConfigFrame.LoadDSRSettings;
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
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConfiguration.FormCreate(Sender: TObject);
Begin
  Inherited;

  frmDSRConfigFrame.DBServer := _DashboardGetDBServer;

  ofConfig.ActivePage := ofpDsr;
  ofConfig.ActivePage := ofpDash;
  Self.HelpContext := 3;
  ActiveControl := edtCompanyName;
  lbServiceServer.Caption := _GetProductName(glProductNameIndex) + ' Server Name';

  frmDSRConfigFrame.Conf.IniFileName := GUIDToString(_CreateGuid);
  frmDSRConfigFrame.ckbDeleteEmail.Caption :=
    '<FONT face="Arial">Delete non related ' + _GetProductName(glProductNameIndex) +
    ' e-mails</FONT>';

  Try
    fDB := TADODSR.Create(_DashboardGetDBServer);
  Except
  End;

  CheckCIS(_DashboardGetDBServer);

  LoadDashSettings;

  {set CIS configuration}
  If glISCIS Then
  Begin
    //lblInfo.Caption := 'Dashboard Configuration';
    lblInfo.Caption := Format(cINFOCAPTION, [_GetProductName(glProductNameIndex),
      '']);
    pnlDash.Visible := False;
//    pnlCIS.Visible := False;
//    gbAditional.Visible := False;
  End
  Else
  Begin
    //lblInfo.Caption := 'Dashboard and E-Mail Configuration';
    gbAditional.Visible := True;
    lblInfo.Caption := Format(cINFOCAPTION, [_GetProductName(glProductNameIndex),
      'and E-Mail']);
    pnlDash.Visible := True;
    pnlCIS.Visible := False;
  End; {else begin}

  ofpDash.Caption := Format(cTABCAPTION, [_GetProductName(glProductNameIndex)]);

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
Function TfrmConfiguration.SaveDashSettings: Boolean;
Begin
  Result := FAlse;

  If Trim(edtDatabaseServer.Text) = '' Then
  Begin
    ShowDashboardDialog('Invalid database server name!', mtInformation, [mbok]);

    If edtDatabaseServer.CanFocus Then
      edtDatabaseServer.SetFocus;
    Abort;
  End; {If Trim(edtDatabaseServer.Text) = '' Then}

//  If edtInstance.Enabled And (Trim(edtInstance.Text) = '') Then
//  Begin
//    ShowDashboardDialog('Invalid Database Instance name!', mtInformation, [mbok]);

//    If edtInstance.CanFocus Then
//      edtInstance.SetFocus;
//    Abort;
//  End; {If Trim(edtInstance.Text) = '' Then}

  If Trim(edtDSRServer.Text) = '' Then
  Begin
    ShowDashboardDialog('Invalid ' + _GetProductName(glProductNameIndex) +
      ' Server name!', mtInformation, [mbok]);

    If edtDSRServer.CanFocus Then
      edtDSRServer.SetFocus;
    Abort;
  End; {If Trim(edtDSRServer.Text) = '' Then}

  If seDSRPort.Value <= 0 Then
  Begin
    ShowDashboardDialog('Invalid ' + _GetProductName(glProductNameIndex) +
      ' port number!', mtInformation, [mbok]);

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

  // db
  if Trim(edtInstance.Text) <> '' then
    _DashboardSetDBServer(edtDatabaseServer.Text + '\' + edtInstance.Text)
  else
    _DashboardSetDBServer(edtDatabaseServer.Text);

  // dsr
  _DashboardSetDSRServer(edtDSRServer.Text);

  // need to recheck the server\instance
  if fDb.Connected then
  try
    fDb.Connected := False;
  except
  end;

  try
    fdb.ConnectionString := _DSRFormatConnectionString(_DashboardGetDBServer);
    fDb.Connected := True;
  except
  end;

  try
    if fDb.GetDbFileName = '' then
    begin
      ShowDashboardDialog('Invalid database server or instance name!', mtWarning, [mbok]);
      fDb.Connected := False;
//      Abort;
    end;
  except
    fDb.Connected := False;
//    Abort;
  end;

  {check new connection}
  if fdb.Connected then
  begin
    fDb.SetSystemParameter(cCOMPANYNAMEPARAM, edtCompanyName.Text);
     {cis params}

    fDb.SetSystemParameter(cSHOWREMINDERPARAM, Inttostr(Ord(cbShowReminder.Checked)));
    fDb.SetSystemParameter(cSHOWALERTPARAM, Inttostr(Ord(cbShowAlert.Checked)));
    fDb.SetSystemParameter(cPOLLINGTIMEPARAM, Inttostr(frmDSRConfigFrame.edtPollingTime.Value));
    fdb.SetSystemParameter(cUSECISTESTPARAM, inttostr(ord(cbUseTestGateway.Checked)));

    Result := True;
  end; {if fdb.Connected then}

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
  frmDSRConfigFrame.DBServer := _DashboardGetDBServer;

  frmDSRConfigFrame.Conf.AutomaticDripFeed := cbDripFeed.Checked;
  frmDSRConfigFrame.Conf.DBServer := _DashboardGetDBServer;

  if fdb.Connected then
    fdb.SetSystemParameter(cCOMPANYNAMEPARAM, edtCompanyName.Text);

  frmDSRConfigFrame.SaveDSRSettings;

  lRes := S_OK;

  lXml := frmDSRConfigFrame.conf.TranslateDSRSettingstoXml;
  If glDSROnline Then
    lRes := TDSR.DSR_UpdateDsrSettings(_DashboardGetDSRServer, _DashboardGetDSRPort,
      lXml)
  Else
    lRes := S_FALSE;

  If lRes = S_OK Then
    btnCancelClick(Self);

  If (lRes <> S_OK) And Not glISCIS Then
  Begin
    Try
      lTrans := TDSR.DSR_TranslateErrorCode(_DashboardGetDSRServer,
        _DashboardGetDSRPort, lRes);
    Except
      lTrans := 'Unrecognised error';
    End;

    ShowDashboardDialog('An exception has occurred while saving ' +
      _GetProductName(glProductNameIndex) + ' settings:' + #13#10 + lTrans, mtError,
      [mbok])

  End; {if lRes <> S_OK then}
End;

{-----------------------------------------------------------------------------
  Procedure: btnSaveClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConfiguration.btnSaveClick(Sender: TObject);
Begin
  if SaveDashSettings then
  begin
    {to be able to change to port which the dashboard comunicates to wrapperservice,
    it needs to first change the database info about the port to be used (the dsr will change it
    when DSR_UpdateDsrSettings is called) and then change the dashboard.ini file... }
    if fDb.Connected then
      fDb.SetSystemParameter(cDSRPORTPARAM, Inttostr(seDSRPort.Value));

    SaveDSRSettings;

    _DashboardSetDSRPort(seDSRPort.Value);
  end; {if SaveDashSettings then}
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
  _BrowseComputer('Select a Database Server name...', lServer, false);

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
  _BrowseComputer('Select the ' + _GetProductName(glProductNameIndex) +
    ' Server name...', lServer, false);

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
  cbShowAlert.Checked := False;
  cbShowAlert.Visible := False;
  cbShowReminder.Checked := False;
  cbShowReminder.Visible := False;
End;

{-----------------------------------------------------------------------------
  Procedure: ckbUseTestGatewayClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConfiguration.cbUseTestGatewayClick(Sender: TObject);
Var
  lUseTest: Boolean;
Begin
  lUseTest := Boolean(Ord(StrToIntDef(fdb.GetSystemValue(cUSECISTESTPARAM), 0)));

  {check if something has changed}
  If lUseTest <> cbUseTestGateway.Checked Then
  Begin
    If ShowDashboardDialog('Are you sure you want to select this option?',
      mtConfirmation,
      [mbYes, mbNo]) = mrYes Then
    Begin
      cbUseTestGateway.Checked := Not lUseTest;
      fdb.SetSystemParameter(cUSECISTESTPARAM, inttostr(Ord(Not lUseTest)));
    End
    Else
      cbUseTestGateway.Checked := lUseTest;
  End; {If frmDSRConfigFrame.Conf.UseCISTest <> ckbUseTestGateway.Checked Then}
End;

{-----------------------------------------------------------------------------
  Procedure: FormDestroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmConfiguration.FormDestroy(Sender: TObject);
Begin
  If Assigned(fDb) Then
    FreeAndNil(fDB);

  _DelFile(frmDSRConfigFrame.Conf.IniFileName);

  Inherited;
End;

procedure TfrmConfiguration.seDSRPortChange(Sender: TObject);
begin
  inherited;
  fDSRPortChanged := True;
end;

End.

