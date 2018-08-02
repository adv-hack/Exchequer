{-----------------------------------------------------------------------------
 Unit Name: uClientSyncBackup
 Author:    vmoura
 Purpose:
 History:


ClientSync.hlp -> dashboard.chm

-----------------------------------------------------------------------------}
Unit uClientSyncBackup;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvFileNameEdit, StdCtrls, AdvEdit, AdvEdBtn, AdvDirectoryEdit,
  AdvGlowButton, AdvOfficePager, AdvOfficePagerStylers, ExtCtrls, AdvPanel,
  AdvProgressBar, ComCtrls;

const
  cCAPTIONINFO = '%s Backup';
  cINFO = '%s Backup and Restore Utility';
  cBACKUPINFO = 'The Backup wizard helps you create a backup of the %s Database.';

Type
  TfrmCSBackup = Class(TForm)
    advPanel: TAdvPanel;
    Panel1: TPanel;
    lblInfo: TLabel;
    opBackup: TAdvOfficePager;
    AdvOfficePagerOfficeStyler: TAdvOfficePagerOfficeStyler;
    ofpWellcome: TAdvOfficePage;
    ofpbackup: TAdvOfficePage;
    ofpRestore: TAdvOfficePage;
    lblBakupInfo: TLabel;
    Label3: TLabel;
    btnbackupUtility: TAdvGlowButton;
    btnRestoreUtility: TAdvGlowButton;
    Label6: TLabel;
    Label4: TLabel;
    edtBackupDir: TAdvDirectoryEdit;
    mmLog: TMemo;
    edtBackupName: TAdvEdit;
    btnStartbackup: TAdvGlowButton;
    Label5: TLabel;
    mmRestore: TMemo;
    btnRestore: TAdvGlowButton;
    edtFileRestore: TAdvFileNameEdit;
    pbRestore: TAdvProgressBar;
    pbBAckup: TAdvProgressBar;
    btnClose: TAdvGlowButton;
    aniBackup: TAnimate;
    aniRestore: TAnimate;
    tmbackup: TTimer;
    Procedure FormCreate(Sender: TObject);
    Procedure btnbackupUtilityClick(Sender: TObject);
    Procedure btnRestoreUtilityClick(Sender: TObject);
    Procedure btnStartbackupClick(Sender: TObject);
    Procedure btnRestoreClick(Sender: TObject);
    Procedure btnCloseClick(Sender: TObject);
    Procedure ApplicationEventsException(Sender: TObject; E: Exception);
    Procedure tmbackupTimer(Sender: TObject);
    Procedure opBackupChange(Sender: TObject);
  Private
  Public
  End;

Var
  frmCSBackup: TfrmCSBackup;

Implementation

Uses uAdoDSR, uCommon, uConsts, uCrypto, uSystemConfig, udashGlobal;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCSBackup.FormCreate(Sender: TObject);
Begin
  Application.OnException := ApplicationEventsException;

  Self.HelpFile := cHELPFILE;

  opBackup.ActivePage := opBackup.ActivePage;
  opBackup.ActivePage := ofpWellcome;
  edtFileRestore.InitialDir := GetCurrentDir;

  with TSystemConf.Create do
  begin
    try
      CheckCIS(DBServer);
    finally
      Free;
    end;
  end; {with TSystemConf.Create do}

  Caption := Format(cCAPTIONINFO, [_GetProductName(glProductNameIndex)]);
  lblInfo.Caption := Format(cINFO, [_GetProductName(glProductNameIndex)]);
  lblBakupInfo.Caption := Format(cBACKUPINFO, [_GetProductName(glProductNameIndex)]);
End;

{-----------------------------------------------------------------------------
  Procedure: btnbackupUtilityClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCSBackup.btnbackupUtilityClick(Sender: TObject);
Begin
  opBackup.ActivePage := ofpBackup;
  opBackup.HelpContext := 23;
  If edtBackupDir.CanFocus Then
  Try
    edtBackupDir.SetFocus;
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: btnRestoreUtilityClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCSBackup.btnRestoreUtilityClick(Sender: TObject);
Begin
  opBackup.ActivePage := ofpRestore;
  opBackup.HelpContext := 24;
  If edtFileRestore.CanFocus Then
  Try
    edtFileRestore.Setfocus;
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: btnStartbackupClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCSBackup.btnStartbackupClick(Sender: TObject);
  Procedure _WriteMessage(Const pMsg: String);
  Begin
    mmLog.Lines.Add(pMsg);
    Sleep(200);
    Application.ProcessMessages;
  End;

Var
  lDb: TADODSR;
  lSource, lDest,
    lIceDb: String;
  lBackName: String;
  lSystem: TSystemConf;

  lServer,
  lInstance,
  lMSQLSERVER: String;
Begin
  pbBAckup.Visible := True;
  pbBAckup.Position := 5;

  If edtBackupName.CanFocus Then
    edtBackupName.SetFocus;

  mmLog.Visible := False;
  If Trim(edtBackupDir.Text) = '' Then
  Begin
    ShowDashboardDialog('Invalid backup directory!', mtError, [mbok]);

    If edtBackupDir.CanFocus Then
      edtBackupDir.SetFocus;
    pbBAckup.Visible := False;
    Abort;
  End; {if Trim(edtBackupDir.Text) = '' then}

  pbBAckup.Position := 10;

  If Not DirectoryExists(Trim(edtBackupDir.Text)) Then
  Begin
    ShowDashboardDialog('The backup directory does not exist!', mtError, [mbok]);

    If edtBackupDir.CanFocus Then
      edtBackupDir.SetFocus;
    pbBAckup.Visible := False;
    Abort;
  End; {If Not DirectoryExists(Trim(edtBackupDir.Text)) Then}

  pbBAckup.Position := 20;

  If Trim(edtBackupName.Text) = '' Then
  Begin
    ShowDashboardDialog('Invalid backup name!', mtError, [mbok]);

    If edtBackupName.CanFocus Then
      edtBackupName.SetFocus;
    pbBAckup.Visible := False;
    Abort;
  End; {If Trim(edtBackupName.Text) = '' Then}

  {check if the sql service exists}
  If Not (_FileSize(ExtractFilePath(Application.ExeName) + cDSRINI) > 0) Then
  Begin
    ShowDashboardDialog('The ' + _GetProductName(glProductNameIndex)+ ' configuration file could not be found!' + #13 +
      #10 + 'The backup has been aborted!', mtError, [mbok]);

    pbBAckup.Visible := False;
    Abort;
  End; {If Not (_FileSize(ExtractFilePath(Application.ExeName) + cDSRINI) > 0) Then}

  with TSystemConf.Create do
  begin
    lServer := DBServer;
    lInstance := Copy(DBServer, Pos('\', DBServer) + 1, Length(DBServer));
    Free;
  end;

  lMSQLSERVER := Format(cSQLIRISSERVICE, [lInstance]);

  //If Not _ServiceExists(cSQLIRISSERVICE) Then
  If Not _ServiceExists(lMSQLSERVER) Then
  Begin
    ShowDashboardDialog('The Microsoft SQL Service does not exist in this machine!' + #13 +
      #10 + 'The backup has been aborted!', mtError, [mbok]);

    pbBAckup.Visible := False;
    Abort;
  End; {If Not _ServiceExists(cSQLIRISSERVICE) Then}

  If Not DirectoryExists(_GetApplicationPath + cINBOXDIR) Then
  Begin
    ShowDashboardDialog('The '+ _GetProductName(glProductNameIndex) +' Inbox directory could not be found!' + #13 +
      #10 + 'The backup has been aborted!', mtError, [mbok]);

    pbBAckup.Visible := False;
    Abort;
  End; {If Not DirectoryExists(Trim(edtBackupDir.Text)) Then}

  If Not DirectoryExists(_GetApplicationPath + cOUTBOXDIR) Then
  Begin
    ShowDashboardDialog('The '+ _GetProductName(glProductNameIndex) +' Outbox directory could not be found!' + #13 +
      #10 + 'The backup has been aborted!', mtError, [mbok]);

    pbBAckup.Visible := False;
    Abort;
  End; {If Not DirectoryExists(Trim(edtBackupDir.Text)) Then}

  pbBAckup.Position := 30;

  If _FileSize(IncludeTrailingPathDelimiter(edtBackupDir.Text) + edtBackupName.Text
    + cDBBACKUPEXT) > 0 Then
    If ShowDashboardDialog('A backup with name "' + edtBackupName.Text + '" already exists.'
      + #13 + #10 + 'Do you want to replace this backup?', mtConfirmation, [mbYes, mbNo]) In [mrNo] Then
    Begin
      pbBAckup.Visible := False;
      Abort;
    End; {if messagedlg}

  tmbackup.Enabled := True;

  mmLog.Clear;
  mmLog.Visible := True;
  _WriteMessage('-Starting Backup Utility-');
  pbBAckup.Position := 40;

  _WriteMessage('Loading database filename...');
  btnStartbackup.Enabled := False;

  {connect the database to obtain the database filename}
  Try
    lDb := TADODSR.Create(lServer);
  Except
    On e: exception Do
      _WriteMessage('Could not connect the Database. Error: ' + e.Message);
  End;

  {get the db filename}
  If Assigned(lDb) Then
  Begin
    If lDb.Connected Then
      lIceDb := lDb.GetDbFileName;
    lDb.free;
  End; {If Assigned(lDb) Then}

  {check the file and the services}
  If (lIceDb <> '') And (_FileSize(lIceDb) > 0) Then
  Begin
    _WriteMessage('Stopping ' + _GetProductName(glProductNameIndex) + ' service...');
    pbBAckup.Position := 50;

    {stop the client sync service}
    _ServiceStatus(cDSRSERVICE, '', False, True);
    If _ServiceStatus(cDSRSERVICE, '', False) = $00000004 Then
      _ServiceStatus(cDSRSERVICE, '', False, True);

    {if that is still running, something is wrong}
    If _ServiceStatus(cDSRSERVICE, '', False) = $00000004 Then
    Begin
      ShowDashboardDialog('The '+_GetProductName(glProductNameIndex)+' Service could not be stopped!' + #13 + #10 +
        'The backup has been aborted!', mtError, [mbok]);

      pbBAckup.Visible := False;
      btnStartbackup.Enabled := True;
      tmbackup.Enabled := False;
      Abort;
    End; {If _ServiceStatus(cDSRSERVICE, '', False) = $00000004 Then}

    _WriteMessage('Stopping database service...');
    pbBAckup.Position := 60;

    {stop the sql service}
    _ServiceStatus(lMSQLSERVER, '', False, True);
    If _ServiceStatus(lMSQLSERVER, '', False) = $00000004 Then
      _ServiceStatus(lMSQLSERVER, '', False, True);

    {if that is still running, something is wrong}
    If _ServiceStatus(lMSQLSERVER, '', False) = $00000004 Then
    Begin
      ShowDashboardDialog('The Microsoft SQL Service could not be stopped!' + #13 + #10 +
        'The backup has been aborted!', mtError, [mbok]);

      pbBAckup.Visible := False;
      btnStartbackup.Enabled := True;
      tmbackup.Enabled := False;
      Abort;
    End; {If _ServiceStatus(lMSQLSERVER, '', False) = $00000004 Then}

    _WriteMessage('Saving backup filename...');
    pbBAckup.Position := 70;

    {encrypt the backup message so i can identify that as a clientLink backup file}
    lBackName := _CreateGuidStr;
    _CreateXmlFile(IncludeTrailingPathDelimiter(edtBackupDir.Text) +
      edtBackupName.Text + cDBBACKUPEXT, TCrypto.EncryptString(lBackName));

    ForceDirectories(IncludeTrailingPathDelimiter(edtBackupDir.Text) + lBackName);

    lSource := ExtractFilePath(lIceDb) + cICEDATABASEFILE;
    lDest := IncludeTrailingPathDelimiter(edtBackupDir.Text) + lBackName + '\' +
      lBackName + ExtractFileExt(lSource);

    _WriteMessage('Copying the database...');
    {copy the main file}
    If CopyFile(pChar(lSource), pChar(lDest), False) Then
    Begin
      pbBAckup.Position := 80;
      {copy the log file}
      lSource := ExtractFilePath(lIceDb) + cICEDATABASEFILELOG;
      lDest := IncludeTrailingPathDelimiter(edtBackupDir.Text) + lBackName + '\' +
        lBackName + '_log' + ExtractFileExt(lSource);

      _WriteMessage('Copying the database log...');
      If CopyFile(pChar(lSource), pChar(lDest), False) Then
      Begin
        lSystem := TSystemConf.Create;
        aniBackup.Visible := True;
        aniBackup.Active := True;

        {create inbox directory for backup}
        ForceDirectories(IncludeTrailingPathDelimiter(edtBackupDir.Text) + lBackName
          + '\' + cINBOXDIR);
        {create outbox dir for backup}
        ForceDirectories(IncludeTrailingPathDelimiter(edtBackupDir.Text) + lBackName
          + '\' + cOUTBOXDIR);

        pbBAckup.Position := 85;
        _WriteMessage('Copying '+_GetProductName(glProductNameIndex)+' Inbox files...');

        If _CopyDir(ExcludeTrailingPathDelimiter(lSystem.InboxDir),
          IncludeTrailingPathDelimiter(edtBackupDir.Text) + lBackName) Then
          _WriteMessage(_GetProductName(glProductNameIndex)+' Inbox files copied...');

        pbBAckup.Position := 90;
        _WriteMessage('Copying '+_GetProductName(glProductNameIndex)+' Outbox files...');
        If _CopyDir(ExcludeTrailingPathDelimiter(lSystem.OutboxDir),
          IncludeTrailingPathDelimiter(edtBackupDir.Text) + lBackName) Then
          _WriteMessage(_GetProductName(glProductNameIndex)+' Outbox files copied...');

        aniBackup.Visible := False;
        aniBackup.Active := False;

        pbBAckup.Position := 95;
        _WriteMessage('Starting services...');

        {start sql service}
        _ServiceStatus(lMSQLSERVER, '', True);
        _ServiceStatus(lMSQLSERVER, '', True);
        {start client sync service}
        _ServiceStatus(cDSRSERVICE, '', True);
        _ServiceStatus(cDSRSERVICE, '', True);

        _WriteMessage('Backup completed. Success!');
        pbBAckup.Position := 100;
        lSystem.Free;
        tmbackup.Enabled := False;
        ShowDashboardDialog('Backup Completed!', mtInformation, [mbok]);
      End
      Else
      Begin
        _WriteMessage('The backup has been aborted! The Database Log could not be copied!');
        ShowDashboardDialog('The backup has been aborted!', mtInformation, [mbok]);
      End;
    End
    Else
    Begin
      _WriteMessage('The backup has been aborted! The Database file could not be copied!');
      ShowDashboardDialog('The backup has been aborted!', mtInformation, [mbok]);
    End;
  End
  Else
  Begin
    _WriteMessage('The backup utility could not locate the database file ' +
      cICEDATABASE + '!' + #13 + #10 + 'The backup has been aborted!');

    ShowDashboardDialog('The backup utility could not locate the database file ' +
      cICEDATABASE + '!' + #13 + #10 + 'The backup has been aborted!', mtInformation, [mbok]);
  End;

  pbBAckup.Visible := False;
  btnStartbackup.Enabled := True;
  tmbackup.Enabled := False;
End;

{-----------------------------------------------------------------------------
  Procedure: btnRestoreClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCSBackup.btnRestoreClick(Sender: TObject);
  Procedure _WriteMessage(Const pMsg: String);
  Begin
    mmRestore.Lines.Add(pMsg);
    Sleep(200);
    Application.ProcessMessages;
  End;

Var
  lDb: TADODSR;
  lSource,
    lIceDb,
    lGuid,
    lFileLog,
    lTempDb, lTempLog: String;
  lSystem: TSystemConf;
  lDate: String;


  lServer,
  lInstance,
  lMSQLSERVER: String;
Begin
  pbRestore.Visible := True;
  pbRestore.Position := 5;

  mmRestore.Visible := False;
  If edtFileRestore.CanFocus Then
    edtFileRestore.SetFocus;

  {check the backup to restore}
  If Trim(edtFileRestore.Text) = '' Then
  Begin
    ShowDashboardDialog('Invalid file to restore!', mtError, [mbok]);

    If edtFileRestore.CanFocus Then
      edtFileRestore.SetFocus;
    pbRestore.Visible := False;
    Abort;
  End; {If Trim(edtFileRestore.Text) = '' Then}

  {check the backup file extension}
  If lowercase(ExtractFileExt(edtFileRestore.Text)) <> cDBBACKUPEXT Then
  Begin
    ShowDashboardDialog('Invalid backup file!', mtError, [mbok]);

    If edtFileRestore.CanFocus Then
      edtFileRestore.SetFocus;
    pbRestore.Visible := False;
    Abort;
  End; {If lowercase(ExtractFileExt(edtFileRestore.Text)) <> cDBBACKUPEXT  Then}

  pbRestore.Position := 10;

  {get the encrypted message inside the file}
  mmRestore.Clear;
  mmRestore.Lines.LoadFromFile(edtFileRestore.Text);
  lGuid := TCrypto.DecryptString(Trim(mmRestore.Lines.Text));

  {check length and if that is a valid guid file}
  If (lGuid = '') Or (Length(lGuid) <> Length(cGUIDREF)) Or Not _IsValidGuid(lGuid)
    Then
  Begin
    ShowDashboardDialog('Invalid backup file!', mtError, [mbok]);

    If edtFileRestore.CanFocus Then
      edtFileRestore.SetFocus;
    pbRestore.Visible := False;
    Abort;
  End; {if (lGuid = '') or Length(lGuid) <> Length(cGUIDREF) or not _IsValidGuid(lGuid) then}

  {check if database file exists to restore}
  If Not FileExists(ExtractFilePath(edtFileRestore.Text) + lGuid + '\' + lGuid +
    ExtractFileExt(cICEDATABASEFILE)) Then
  Begin
    ShowDashboardDialog('The database file backup does not exist!' + #13 +
      #10 + 'The restore has been aborted!', mtError, [mbok]);

    pbRestore.Visible := False;
    Abort;
  End; {If Not FileExists(ExtractFilePath(edtFileRestore.Text) + lGuid + ExtractFileExt(cICEDATABASEFILE)) Then}

  pbRestore.Position := 20;

  {check  if the log file to restore exists}
  If Not FileExists(ExtractFilePath(edtFileRestore.Text) + lGuid + '\' + lGuid +
    '_log' + ExtractFileExt(cICEDATABASEFILELOG)) Then
  Begin
    ShowDashboardDialog('The database file log does not exist!' + #13 +
      #10 + 'The restore has been aborted!', mtError, [mbok]);

    pbRestore.Visible := False;
    Abort;
  End; {If Not FileExists(ExtractFilePath(edtFileRestore.Text) + lGuid + '_log' +
    ExtractFileExt(cICEDATABASEFILELOG)) Then}

  {check if the sql service exists}
  If Not (_FileSize(ExtractFilePath(Application.ExeName) + cDSRINI) > 0) Then
  Begin
    ShowDashboardDialog('The '+_GetProductName(glProductNameIndex)+' configuration file could not be found!' + #13 +
      #10 + 'The restore has been aborted!', mtError, [mbok]);

    pbRestore.Visible := False;
    Abort;
  End; {If Not (_FileSize(ExtractFilePath(Application.ExeName) + cDSRINI) > 0) Then}

  with TSystemConf.Create do
  begin
    lServer := DBServer;
    lInstance := Copy(DBServer, Pos('\', DBServer) + 1, Length(DBServer));
    Free;
  end;

  lMSQLSERVER := Format(cSQLIRISSERVICE, [lInstance]);

  {check if the sql service exists}
  If Not _ServiceExists(lMSQLSERVER) Then
  Begin
    ShowDashboardDialog('The Microsoft SQL Service does not exist in this machine!' + #13 +
      #10 + 'The restore has been aborted!', mtError, [mbok]);

    pbRestore.Visible := False;
    Abort;
  End; {If Not _ServiceExists(cSQLIRISSERVICE) Then}

  If Not DirectoryExists(_GetApplicationPath + cINBOXDIR) Then
  Begin
    ShowDashboardDialog('The '+_GetProductName(glProductNameIndex)+' Inbox directory could not be found!' + #13 +
      #10 + 'The restore has been aborted!', mtError, [mbok]);

    pbBAckup.Visible := False;
    Abort;
  End; {If Not DirectoryExists(Trim(edtBackupDir.Text)) Then}

  If Not DirectoryExists(_GetApplicationPath + cOUTBOXDIR) Then
  Begin
    ShowDashboardDialog('The '+_GetProductName(glProductNameIndex)+' Outbox directory could not be found!' + #13 +
      #10 + 'The restore has been aborted!', mtError, [mbok]);

    pbBAckup.Visible := False;
    Abort;
  End; {If Not DirectoryExists(Trim(edtBackupDir.Text)) Then}

  tmbackup.Enabled := True;
  pbRestore.Position := 30;
  btnRestore.Enabled := False;

  mmRestore.Clear;
  mmRestore.Visible := True;
  _WriteMessage('-Starting Restore Utility-');

  {connect the database to obtain the database filename}
  Try
    lDb := TADODSR.Create(lServer);
  Except
    On e: exception Do
      _WriteMessage('Could not connect the '+_GetProductName(glProductNameIndex)+' Database. Error: ' +
        e.Message);
  End;

  _WriteMessage('Loading database filename...');

  pbRestore.Position := 40;

  {get the db filename}
  If Assigned(lDb) Then
  Begin
    If lDb.Connected Then
      lIceDb := lDb.GetDbFileName;
    lDb.free;
  End; {If Assigned(lDb) Then}

  {check the file and the services}
  If (lIceDb <> '') And (_FileSize(lIceDb) > 0) Then
  Begin
    _WriteMessage('Stopping '+_GetProductName(glProductNameIndex)+' service...');
    pbRestore.Position := 45;

    _ServiceStatus(cDSRSERVICE, '', False, True);
    If _ServiceStatus(cDSRSERVICE, '', False) = $00000004 Then
      _ServiceStatus(cDSRSERVICE, '', False, True);

    {if that is still running, something is wrong}
    If _ServiceStatus(cDSRSERVICE, '', False) = $00000004 Then
    Begin
      ShowDashboardDialog('The '+_GetProductName(glProductNameIndex)+' Service could not be stopped!' + #13 + #10 +
        'The restore has been aborted!', mtError, [mbok]);

      pbRestore.Visible := False;
      btnRestore.Enabled := True;
      tmbackup.Enabled := False;
      Abort;
    End; {If _ServiceStatus(cDSRSERVICE, '', False) = $00000004 Then}

  {connect the database to obtain the database filename}
    _WriteMessage('Stopping database service...');
    pbRestore.Position := 55;

    {stop the database}
    _ServiceStatus(lMSQLSERVER, '', False, True);
    If _ServiceStatus(lMSQLSERVER, '', False) = $00000004 Then
      _ServiceStatus(lMSQLSERVER, '', False, True);

    {if the service is still running, something is wrong}
    If _ServiceStatus(lMSQLSERVER, '', False) = $00000004 Then
    Begin
      ShowDashboardDialog('The Microsoft SQL Service could not be stopped!' + #13 + #10 +
        'The restore has been aborted!', mtError, [mbok]);

      pbRestore.Visible := False;
      btnRestore.Enabled := True;
      tmbackup.Enabled := False;
      Abort;
    End; {If _ServiceStatus(cSQLIRISSERVICE, '', False) = $00000004 Then}

    pbRestore.Position := 60;
    _WriteMessage('Renaming '+_GetProductName(glProductNameIndex)+' Inbox Directory...');

    {-------------------------- start copying process ----------------------------}

    lSystem := TSystemConf.Create;

    lTempdb := ExtractFilePath(lIceDb) + _CreateGuidStr;
    lTempLog := ExtractFilePath(lIceDb) + _CreateGuidStr;
    lFileLog := ExtractFilePath(lIceDb) + cICEDATABASEFILELOG;

    lDate := FormatDateTime('yyyymmdd hhnnss', Now);

    If _RenameDir(ExcludeTrailingBackslash(lSystem.InboxDir),
      ExcludeTrailingBackslash(lSystem.InboxDir) + '_' + lDate) Then
    Begin
      pbRestore.Position := 65;
      _WriteMessage('Renaming '+_GetProductName(glProductNameIndex)+' Outbox Directory...');

      If _RenameDir(ExcludeTrailingBackslash(lSystem.OutboxDir),
        ExcludeTrailingBackslash(lSystem.OutboxDir) + '_' + lDate) Then
      Begin
        _WriteMessage('Creating temporary Database file...');

        {create temp files of the db and its log}
        If CopyFile(pChar(lIceDb), pChar(lTempDb), False) Then
        Begin
          _WriteMessage('Creating temporary Database log file...');
          pbRestore.Position := 70;

          If CopyFile(pChar(lFileLog), pChar(lTempLog), False) Then
          Begin
             {try to copy the db file}
            lSource := ExtractFilePath(edtFileRestore.Text) + lGuid + '\' + lGuid +
              ExtractFileExt(cICEDATABASEFILE);

            _WriteMessage('Restoring Database file...');
            pbRestore.Position := 75;

            If CopyFile(pChar(lSource), pChar(lIceDb), False) Then
            Begin
              {try to copy the log file}
              lSource := ExtractFilePath(edtFileRestore.Text) + lGuid + '\' + lGuid
                + '_log' + ExtractFileExt(cICEDATABASEFILELOG);

              _WriteMessage('Restoring Database log file...');
              pbRestore.Position := 80;

              If CopyFile(pChar(lSource), pChar(lFileLog), False) Then
              Begin
                aniRestore.Visible := True;
                aniRestore.Active := True;

                {create inbox directory for restoring the backup files}
                ForceDirectories(lSystem.InboxDir);
                {create outbox dir for restoring the backup files}
                ForceDirectories(lSystem.OutboxDir);

                pbBAckup.Position := 85;
                _WriteMessage('Restoring '+_GetProductName(glProductNameIndex)+' Inbox files...');

                If _CopyDir(ExtractFilePath(edtFileRestore.Text) + lGuid + '\' +
                  cINBOXDIR, ExcludeTrailingBackslash(_GetApplicationPath)) Then
                Begin
                  _WriteMessage(_GetProductName(glProductNameIndex)+' Inbox files restored...');

                  pbBAckup.Position := 90;
                  _WriteMessage('Restoring '+_GetProductName(glProductNameIndex)+' Outbox files...');
                  If _CopyDir(ExtractFilePath(edtFileRestore.Text) + lGuid + '\' +
                    cOUTBOXDIR, ExcludeTrailingBackslash(_GetApplicationPath)) Then
                  Begin
                    _WriteMessage(_GetProductName(glProductNameIndex)+' Outbox files restored...');
                    {delete temp directories}
                    _DelDir(ExcludeTrailingBackslash(lSystem.OutboxDir) + '_' +
                      lDate);
                    _DelDir(ExcludeTrailingBackslash(lSystem.InboxDir) + '_' +
                      lDate);
                    {delete temp files}
                    _DelFile(lTempDb);
                    _DelFile(lTempLog);

                    aniRestore.Visible := False;
                    aniRestore.Active := False;
                    Application.ProcessMessages;

                    pbRestore.Position := 95;
                    _WriteMessage('Starting services...');
                    _ServiceStatus(lMSQLSERVER, '', True);
                    _ServiceStatus(lMSQLSERVER, '', True);
                    _ServiceStatus(cDSRSERVICE, '', True);
                    _ServiceStatus(cDSRSERVICE, '', True);

                    _WriteMessage('Restore completed. Success!');
                    pbRestore.Position := 100;
                    tmbackup.Enabled := False;
                    ShowDashboardDialog('Restore Completed!', mtInformation, [mbok]);

                    {end.........................}
                  End
                  Else
                  Begin
                    _WriteMessage('The '+_GetProductName(glProductNameIndex)+' Outbox backup directory could not be found! The restore has been aborted!');

                    {rollback copied files}
                    _DelDir(ExcludeTrailingBackslash(lSystem.OutboxDir));
                    If Not _RenameDir(ExcludeTrailingBackslash(lSystem.OutboxDir) +
                      '_' + lDate, ExcludeTrailingBackslash(lSystem.OutboxDir)) Then
                      _WriteMessage('The '+_GetProductName(glProductNameIndex)+' Outbox temp directory could not be renamed back to the original name! Please, call for support...');

                    _DelDir(ExcludeTrailingBackslash(lSystem.InboxDir));
                    If Not _RenameDir(ExcludeTrailingBackslash(lSystem.InboxDir) +
                      '_' + lDate, ExcludeTrailingBackslash(lSystem.InboxDir)) Then
                      _WriteMessage('The '+_GetProductName(glProductNameIndex)+' Inbox temp directory could not be renamed back to the original name! Please, call for support...');

                    If CopyFile(pChar(lTempLog), pChar(lFileLog), False) Then
                      _DelFile(lTempLog);

                    If CopyFile(pChar(lTempDb), pChar(lIceDb), False) Then
                      _DelFile(lTempDb);

                    ShowDashboardDialog('The '+_GetProductName(glProductNameIndex)+' Outbox backup directory could not be found!'
                      + #13 + #10 + 'The restore has been aborted!', mtInformation,
                      [mbok]);

                  End; {if copy outbox}
                End
                Else
                Begin
                  _WriteMessage('The '+_GetProductName(glProductNameIndex)+' Inbox backup directory could not be found! The restore has been aborted!');
                  {rollback copied files}
                  _DelDir(ExcludeTrailingBackslash(lSystem.InboxDir));
                  If Not _RenameDir(ExcludeTrailingBackslash(lSystem.InboxDir) + '_'
                    + lDate, ExcludeTrailingBackslash(lSystem.InboxDir)) Then
                    _WriteMessage('The '+_GetProductName(glProductNameIndex)+' Inbox temp directory could not be renamed back to the original name! Please, call for support...');

                  If CopyFile(pChar(lTempLog), pChar(lFileLog), False) Then
                    _DelFile(lTempLog);

                  If CopyFile(pChar(lTempDb), pChar(lIceDb), False) Then
                    _DelFile(lTempDb);

                  ShowDashboardDialog('The '+_GetProductName(glProductNameIndex)+' Inbox backup directory could not be found!'
                    + #13 + #10 + 'The restore has been aborted!', mtInformation,
                    [mbok]);

                End; {if copy inbox}

                aniRestore.Visible := False;
                aniRestore.Active := False;
                tmbackup.Enabled := False;
                Application.ProcessMessages;
              End
              Else
              Begin
                {rename temp directories back}
                If Not _RenameDir(ExcludeTrailingBackslash(lSystem.InboxDir) + '_' +
                  lDate, ExcludeTrailingBackslash(lSystem.InboxDir)) Then
                  _WriteMessage('The '+_GetProductName(glProductNameIndex)+' Inbox temp directory could not be renamed back to the original name! Please, call for support...');

                If Not _RenameDir(ExcludeTrailingBackslash(lSystem.OutboxDir) + '_'
                  + lDate, ExcludeTrailingBackslash(lSystem.OutboxDir)) Then
                  _WriteMessage('The '+_GetProductName(glProductNameIndex)+' Outbox temp directory could not be renamed back to the original name! Please, call for support...');

                {copy temp log file back and delete it}
                If CopyFile(pChar(lTempLog), pChar(lFileLog), False) Then
                  _DelFile(lTempLog);
                _WriteMessage('The log DB file could not be restored! The restore has been aborted!');

                ShowDashboardDialog('The log DB file could not be restored!' + #13 + #10 +
                  'The restore has been aborted!', mtInformation, [mbok]);

              End;
            End
            Else
            Begin
              {rename temp directories back}
              If Not _RenameDir(ExcludeTrailingBackslash(lSystem.InboxDir) + '_' +
                lDate, ExcludeTrailingBackslash(lSystem.InboxDir)) Then
                _WriteMessage('The '+_GetProductName(glProductNameIndex)+' Inbox temp directory could not be renamed back to the original name! Please, call for support...');

              If Not _RenameDir(ExcludeTrailingBackslash(lSystem.OutboxDir) + '_' +
                lDate, ExcludeTrailingBackslash(lSystem.OutboxDir)) Then
                _WriteMessage('The '+_GetProductName(glProductNameIndex)+' Outbox temp directory could not be renamed back to the original name! Please, call for support...');

              {copy temp db file back and delete it}
              If CopyFile(pChar(lTempDb), pChar(lIceDb), False) Then
                _DelFile(lTempDb);
              _WriteMessage(' The DB file could not be restored! The restore has been aborted!');

              ShowDashboardDialog(' The DB file could not be restored!' + #13 + #10 +
                'The restore has been aborted!', mtInformation, [mbok]);
            End;
          End
          Else
          Begin
            {rename temp directories back}
            If Not _RenameDir(ExcludeTrailingBackslash(lSystem.InboxDir) + '_' +
              lDate, ExcludeTrailingBackslash(lSystem.InboxDir)) Then
              _WriteMessage('The '+_GetProductName(glProductNameIndex)+' Inbox temp directory could not be renamed back to the original name! Please, call for support...');

            If Not _RenameDir(ExcludeTrailingBackslash(lSystem.OutboxDir) + '_' +
              lDate, ExcludeTrailingBackslash(lSystem.OutboxDir)) Then
              _WriteMessage('The '+_GetProductName(glProductNameIndex)+' Outbox temp directory could not be renamed back to the original name! Please, call for support...');

            _WriteMessage('The temp log DB file could not be copied! The restore has been aborted!');

            ShowDashboardDialog('The temp log DB file could not be copied!' + #13 + #10 +
              'The restore has been aborted!', mtInformation, [mbok]);
          End;
        End
        Else
        Begin
          {rename temp directories back}
          If Not _RenameDir(ExcludeTrailingBackslash(lSystem.InboxDir) + '_' +
            lDate, ExcludeTrailingBackslash(lSystem.InboxDir)) Then
            _WriteMessage('The '+_GetProductName(glProductNameIndex)+' Inbox temp directory could not be renamed back to the original name! Please, call for support...');

          If Not _RenameDir(ExcludeTrailingBackslash(lSystem.OutboxDir) + '_' +
            lDate, ExcludeTrailingBackslash(lSystem.OutboxDir)) Then
            _WriteMessage('The '+_GetProductName(glProductNameIndex)+' Outbox temp directory could not be renamed back to the original name! Please, call for support...');

          _WriteMessage('The temp DB file could not be copied! The restore has been aborted!');

          ShowDashboardDialog('The temp DB file could not be copied!' + #13 + #10 +
            'The restore has been aborted!', mtInformation, [mbok]);
        End;
      End
      Else
      Begin
          {rename temp directories back}
        If Not _RenameDir(ExcludeTrailingBackslash(lSystem.InboxDir) + '_' +
          lDate, ExcludeTrailingBackslash(lSystem.InboxDir)) Then
          _WriteMessage('The '+_GetProductName(glProductNameIndex)+' Inbox temp directory could not be renamed back to the original name! Please, call for support...');

        _WriteMessage('The restore has been aborted! The '+_GetProductName(glProductNameIndex)+' Outbox directory could not be renamed!');

        ShowDashboardDialog('The restore has been aborted!', mtInformation, [mbok]);
      End;
    End
    Else
    Begin
      _WriteMessage('The restore has been aborted! The '+_GetProductName(glProductNameIndex)+' Inbox directory could not be renamed!');
      ShowDashboardDialog('The restore has been aborted!', mtInformation, [mbok]);
    End;
  End
  Else
  Begin
    _WriteMessage('The restore utility could not locate the database file ' +
      cICEDATABASE + '!' + #13 + #10 + 'The backup has been aborted!');

    ShowDashboardDialog('The restore utility could not locate the database file ' +
      cICEDATABASE + '!' + #13 + #10 + 'The backup has been aborted!',
      mtInformation, [mbok]);
  End;

  _ServiceStatus(lMSQLSERVER, '', True);
  _ServiceStatus(lMSQLSERVER, '', True);
  _ServiceStatus(cDSRSERVICE, '', True);
  _ServiceStatus(cDSRSERVICE, '', True);

  tmbackup.Enabled := False;

  If Assigned(lSystem) Then
    lSystem.Free;
  pbRestore.Visible := False;
  btnRestore.Enabled := True;
End;

{-----------------------------------------------------------------------------
  Procedure: btnCloseClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCSBackup.btnCloseClick(Sender: TObject);
Begin
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: ApplicationEventsException
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCSBackup.ApplicationEventsException(Sender: TObject;
  E: Exception);
Begin
  btnStartbackup.Enabled := True;
  btnRestore.Enabled := True;
End;

{-----------------------------------------------------------------------------
  Procedure: tmbackupTimer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCSBackup.tmbackupTimer(Sender: TObject);
Begin
//  tmbackup.Enabled := False;
  Application.ProcessMessages;
//  tmbackup.Enabled := True;
End;

{-----------------------------------------------------------------------------
  Procedure: opBackupChange
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCSBackup.opBackupChange(Sender: TObject);
Begin
  If opBackup.ActivePage = ofpWellcome Then
  Begin
    opBackup.HelpContext := 22;
  End
  Else If opBackup.ActivePage = ofpbackup Then
  Begin
    opBackup.HelpContext := 23;
    If edtBackupDir.CanFocus and not (csLoading in opBackup.ComponentState) Then
    try
      edtBackupDir.SetFocus;
    except
    end;
  End {If opBackup.ActivePage = ofpbackup Then}
  Else If opBackup.ActivePage = ofpRestore Then
  Begin
    opBackup.HelpContext := 24;
    If edtFileRestore.CanFocus and not (csLoading in opBackup.ComponentState) Then
    try
      edtFileRestore.SetFocus;
    except
    end;
  End; {If opBackup.ActivePage = ofpRestore Then}
End;

End.

