{-----------------------------------------------------------------------------
 Unit Name: uExBackup
 Author:    vmoura
 Purpose:
 History:

-----------------------------------------------------------------------------}
Unit uExBackup;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, AdvOfficePager, AdvOfficePagerStylers, Mask, AdvSpin,
  AdvFileNameEdit, AdvOfficeButtons, StdCtrls, AdvCombo, AdvEdit, AdvEdBtn,
  AdvDirectoryEdit, AdvGlowButton, ExtCtrls, AdvPanel;

Const
  cCONNECTIONSTR =
    'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=master;Data Source=%s';

  cBACKUPCOMMAND = 'BACKUP DATABASE %s TO DISK = %s';
  cCONFIEXT = '.cfg';
  cDBEXT = '.mdf';
  cDBLOGEXT = '.ldf';
  cRESTORECOMMAND =
    ' USE master ' +
    ' ' +
    ' RESTORE DATABASE [%s] ' +
    ' FROM DISK = %s ' +
    ' WITH ' +
    ' FILE = 1, ' +
    ' MOVE %s TO %s, ' +
    ' MOVE %s TO %s, ' +
    ' REPLACE ';

  //cICORECOMMAND = 'iCoreCreateLogin.exe /S %s %s xcheckdbo password123';
  cICORECOMMAND = '/S %s %s exchequerdbo password123';

Type
  TFileOption = (soDoCompress, soDoDeCompress);
  TFileOptions = Set Of TFileOption;

  TAction = (acBackup, acRestore);

  TExSQLBackup = Class(TThread)
  Private
    fAction: TAction;
    FErrorMessage: String;
    Procedure DoBackup;
    Procedure DoRestore;
    Function DoCompressionFile(pOption: TFileOptions; Const pFileIn, pFileOut:
      String): Boolean;
    Function DeCompress(Const pFileIn: String; Const pFileOut: String = ''):
      Boolean;
    Function Compress(Const pFileIn: String; Const pFileOut: String = ''): Boolean;
  Protected
    Procedure Execute; Override;
  Public
    Constructor Create(pAction: TAction);
    Destructor Destroy; Override;
  Published
    Property ErrorMessage: String Read FErrorMessage Write FErrorMessage;
  End;

  TfrmExBackup = Class(TForm)
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
    edtBackupName: TAdvEdit;
    btnStartbackup: TAdvGlowButton;
    Label5: TLabel;
    btnRestore: TAdvGlowButton;
    edtFileRestore: TAdvFileNameEdit;
    btnClose: TAdvGlowButton;
    edtMSFiles: TAdvDirectoryEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtDBName: TAdvEdit;
    Label7: TLabel;
    edtInstance: TAdvEdit;
    cbDbList: TAdvComboBox;
    Label8: TLabel;
    btnConnect: TAdvGlowButton;
    Label9: TLabel;
    edtInstRest: TAdvEdit;
    btnConnectRest: TAdvGlowButton;
    cbCompress: TAdvOfficeCheckBox;
    cbICore: TAdvOfficeCheckBox;
    edtTimeout: TAdvSpinEdit;
    Label10: TLabel;
    cbCompanyBK: TAdvComboBox;
    Label11: TLabel;
    Procedure FormCreate(Sender: TObject);
    Procedure btnbackupUtilityClick(Sender: TObject);
    Procedure btnRestoreUtilityClick(Sender: TObject);
    Procedure btnStartbackupClick(Sender: TObject);
    Procedure btnRestoreClick(Sender: TObject);
    Procedure btnCloseClick(Sender: TObject);
    Procedure ApplicationEventsException(Sender: TObject; E: Exception);
    Procedure opBackupChange(Sender: TObject);
    Procedure edtFileRestoreDialogExit(Sender: TObject; ExitOK: Boolean);
    Procedure btnConnectClick(Sender: TObject);
    Procedure btnConnectRestClick(Sender: TObject);
  Private
    Function ConnectionOk(Const pInstanceName: String): Boolean;
    Procedure LoadDatabaseNames;
    Procedure GetExCompanies;
//    Procedure Dobackup;
//    Procedure DoRestore;
    Function DBExists(Const pserver, pDb: String): Boolean;
  Public
  End;

Var
  frmExBackup: TfrmExBackup;

Implementation

Uses
  CTKUTIL, Enterprise01_TLB, sqlutils,

  IniFiles, ActiveX, ShellApi,
  zLib,
  uWait;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: GetExCompanies
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExBackup.GetExCompanies;
Var
  oToolKit: IToolkit;
  lCont: Integer;
Begin
  cbCompanyBK.Clear;
  cbCompanyBK.Items.Add('');

  {open  the toolkit}
  Try
    oToolKit := CreateToolkitWithBackdoor;
  Except
    On e: exception Do
      MessageDlg('Error creating the toolkit. Error: ' + e.message, mtError, [mbok],
        0);
  End; {try}

  { check if the toolkit is ok.}
  If Assigned(oToolKit) Then
  Begin
    Try
      With oToolKit, oToolKit.Company Do
        If cmCount > 0 Then
          For lCont := 1 To cmCount Do
          Begin
            cbCompanyBK.Items.Add('[' + Trim(cmCompany[lCont].coCode) + ']' +
              Trim(cmCompany[lCont].coName));
            Application.ProcessMessages;
          End; {For lCont := 1 To cmCount Do}
    Except
    End; { if assigned(otoolkit) }

    oToolKit := Nil;
  End
  Else
    messagedlg('The toolkit instance could not be created', mtError, [mbok], 0);
End;

{-----------------------------------------------------------------------------
  Procedure: DBExists
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmExBackup.DBExists(Const pserver, pDb: String): Boolean;
Var
  lQry: TADOQuery;
Begin
  Result := False;
  Try
    lQry := TADOQuery.Create(Nil);
    lQry.CommandTimeout := edtTimeout.Value;
    lQry.ConnectionString := Format(cCONNECTIONSTR, [pserver]);
    lQry.SQL.Text := 'sp_helpdb ';

    {execute store procedure command}
    Try
      lQry.Open;
    Except
    End;

    {check if any database exists }
    If lQry.Active And Not lQry.IsEmpty Then
      With lQry Do
      Begin
        First;
        {check for specific database name}
        While Not eof Do
        Begin
          Result := LowerCase(Trim(fieldbyName('name').asString)) = LowerCase(pDb);
          If Result Then
            Break;
          Next;
        End; {while not eof do}
      End; {with lQry do}
  Finally
    If Assigned(lQry) Then
    Begin
      If lQry.Active Then
        lQry.Close;

      FreeAndNil(lQry);
    End; {If Assigned(lQry) Then}
  End; {If Connected Then}
End;

{-----------------------------------------------------------------------------
  Procedure: ConnectionOk
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmExBackup.ConnectionOk(Const pInstanceName: String): Boolean;
Var
  lQry: TADOQuery;
Begin
  Result := False;
  Try
    lQry := TADOQuery.Create(Nil);
    lQry.CommandTimeout := edtTimeout.Value;
    If (Trim(pInstanceName) = '') Or (Trim(pInstanceName) = '.') Then
      lQry.ConnectionString := Format(cCONNECTIONSTR, ['.'])
    Else
      lQry.ConnectionString := Format(cCONNECTIONSTR, ['.\' + pInstanceName]);

    lQry.SQL.Text := 'sp_helpdb ';

    {execute store procedure command}
    Try
      lQry.Open;
    Except
      On e: exception Do
      Begin
        MessageDlg('Error connecting the database. Error: ' + e.Message, mtError,
          [mbok], 0);
      End;
    End;

    {check if any database exists }
    Result := lQry.Active;
  Finally
    If Assigned(lQry) Then
    Begin
      If lQry.Active Then
        lQry.Close;

      FreeAndNil(lQry);
    End; {If Assigned(lQry) Then}
  End; {If Connected Then}
End;

{-----------------------------------------------------------------------------
  Procedure: LoadDatabaseNames
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExBackup.LoadDatabaseNames;
Var
  lQry: TADOQuery;
Begin
  Try
    lQry := TADOQuery.Create(Nil);
    lQry.CommandTimeout := edtTimeout.Value;

    If (Trim(edtInstance.Text) = '') Then
      lQry.ConnectionString := Format(cCONNECTIONSTR, ['.'])
    Else
      lQry.ConnectionString := Format(cCONNECTIONSTR, ['.\' + edtInstance.Text]);

    lQry.SQL.Text := 'sp_helpdb ';

    {execute store procedure command}
    Try
      lQry.Open;
    Except
      On e: exception Do
        MessageDlg('Error connecting the database. Error: ' + e.Message, mtError,
          [mbok], 0);
    End; {try}

    {check if any database exists }
    If lQry.Active And Not lQry.IsEmpty Then
      With lQry Do
      Begin
        First;
        {check for specific database name}
        While Not eof Do
        Begin
          cbDbList.Items.Add(Trim(fieldbyName('name').asString));
          Next;
        End; {while not eof do}
      End; {with lQry do}
  Finally
    If Assigned(lQry) Then
    Begin
      If lQry.Active Then
        lQry.Close;

      FreeAndNil(lQry);
    End; {If Assigned(lQry) Then}
  End; {If Connected Then}

  If cbDbList.Items.Count > 0 Then
    cbDbList.ItemIndex := 0;
End;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExBackup.FormCreate(Sender: TObject);
Begin
  Application.OnException := ApplicationEventsException;

  opBackup.ActivePage := opBackup.ActivePage;
  opBackup.ActivePage := ofpWellcome;
  edtFileRestore.InitialDir := GetCurrentDir;

  cbDbList.Color := clSilver;
  cbCompanyBK.Color := clSilver;
End;

{-----------------------------------------------------------------------------
  Procedure: btnbackupUtilityClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExBackup.btnbackupUtilityClick(Sender: TObject);
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
Procedure TfrmExBackup.btnRestoreUtilityClick(Sender: TObject);
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
Procedure TfrmExBackup.btnStartbackupClick(Sender: TObject);
Var
  lBkp: TExSQLBackup;
  lMsg: String;
Begin
  If edtBackupName.CanFocus Then
    edtBackupName.SetFocus;

  If (Trim(edtBackupDir.Text) = '') Or Not DirectoryExists(Trim(edtBackupDir.Text))
    Then
  Begin
    MessageDlg('Invalid backup directory!', mtError, [mbok], 0);

    If edtBackupDir.CanFocus Then
      edtBackupDir.SetFocus;
    Abort;
  End; {if Trim(edtBackupDir.Text) = '' then}

  If Trim(edtBackupName.Text) = '' Then
  Begin
    MessageDlg('Invalid backup name!', mtError, [mbok], 0);

    If edtBackupName.CanFocus Then
      edtBackupName.SetFocus;
    Abort;
  End; {If Trim(edtBackupName.Text) = '' Then}

  If FileExists(IncludeTrailingPathDelimiter(edtBackupDir.Text) + edtBackupName.Text)
    Then
  Begin
    MessageDlg('Invalid backup name or backup already exists!', mtError, [mbok], 0);

    If edtBackupName.CanFocus Then
      edtBackupName.SetFocus;
    Abort;
  End;

  frmWait := TfrmWait.Create(Self);
  frmWait.Start('Backup in progress...');

  Application.ProcessMessages;

  lBkp := TExSQLBackup.Create(acBackup);

  lBkp.Resume;

  // backup thread in action...
  While Not lBkp.Terminated Do
  Begin
    Application.ProcessMessages;
    If Not frmWait.Showing Then
    Begin
      LockWindowUpdate(Self.Handle);
      frmWait.Start();
      LockWindowUpdate(0);
    End; {If Not frmWait.Showing Then}

    Sleep(1);
  End; {While Not lBkp.Terminated Do}

  lMsg := lBkp.ErrorMessage;

  lBkp.Free;

//  Try
//    Dobackup;
//  Finally
  frmWait.Stop;
//  End;

  freeAndNil(frmWait);

  Application.ProcessMessages;

  If Trim(lMsg) <> '' Then
    MessageDlg(lMsg, mtInformation, [mBok], 0);

  btnStartbackup.Enabled := True;
End;

{-----------------------------------------------------------------------------
  Procedure: btnRestoreClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExBackup.btnRestoreClick(Sender: TObject);
Var
  lFile, lMsg,
    lCommand, lInstance: String;
  lRes: TExSQLBackup;
Begin
  edtDBName.Text := StringReplace(edtDBName.Text, ' ', '', [rfReplaceAll]);

  If edtFileRestore.CanFocus Then
    edtFileRestore.SetFocus;

  lFile := ExpandUNCFileName(edtFileRestore.Text + cCONFIEXT);

  If Not FileExists(lFile) Then
  Begin
    MessageDlg('Invalid Backup configuration file!', mtError, [mbok], 0);
    Abort;
  End; {if not FileExists('') then}

  {check the backup to restore}
  If (Trim(edtFileRestore.Text) = '') Or Not FileExists(edtFileRestore.Text) Then
  Begin
    MessageDlg('Invalid file to restore!', mtError, [mbok], 0);

    If edtFileRestore.CanFocus Then
      edtFileRestore.SetFocus;
    Abort;
  End; {If Trim(edtFileRestore.Text) = '' Then}

  {check where the files will be created}
  If (Trim(edtMSFiles.Text) = '') Or Not DirectoryExists(edtMSFiles.Text) Then
  Begin
    MessageDlg('Invalid directory to create the new database!', mtError, [mbok], 0);

    If edtMSFiles.CanFocus Then
      edtMSFiles.SetFocus;
    Abort;
  End; {If Trim(edtMSFiles.Text) = '' Then}

  {check the new database name}
  If Trim(edtDBName.Text) = '' Then
  Begin
    MessageDlg('Invalid database name!', mtError, [mbok], 0);

    If edtDBName.CanFocus Then
      edtDBName.SetFocus;
    Abort;
  End; {If Trim(edtDBName.Text) = '' Then}

  If Trim(edtInstRest.Text) = '' Then
    lInstance := '.'
  Else
    lInstance := '.\' + edtInstRest.Text;

  // check the database name
  If DBExists(lInstance, edtDBName.Text) Then
  Begin
    MessageDlg('The database "' + edtDBName.Text + '" already exists!', mtError,
      [mbok], 0);

    If edtDBName.CanFocus Then
      edtDBName.SetFocus;
    Abort;
  End; {If DBExists(lInstance, edtDBName.Text) Then}

  btnRestore.Enabled := False;

  frmWait := TfrmWait.Create(Self);
  frmWait.Start('Restore in progress...');

  Application.ProcessMessages;

  lRes := TExSQLBackup.Create(acRestore);
  lRes.Resume;

  // restore thread in action
  While Not lRes.Terminated Do
  Begin
    Application.ProcessMessages;
    If Not frmWait.Showing Then
      frmWait.Start();

    Sleep(1);
  End; {While Not lRes.Terminated Do}

  lMsg := lRes.ErrorMessage;

  lRes.Free;

//  Try
//    DoRestore;
//  Finally
  frmWait.Stop;
//  End;

  Application.ProcessMessages;

  If Trim(lMsg) <> '' Then
    MessageDlg(lMsg, mtInformation, [mBok], 0);

  If cbICore.Checked Then
  Begin
    If assigned(frmWait) Then
      frmWait.pnlMessage := 'Creating Exchequer configuration files...';

    If Trim(edtInstRest.Text) = '' Then
      lCommand := format(cICORECOMMAND, ['.', edtDBName.Text])
    Else
      lCommand := format(cICORECOMMAND, ['.\' + edtInstRest.Text, edtDBName.Text]);

      // = '/S csdev\irissql  DB xcheckdbo password123';
    ShellExecute(0, pChar('open'), pChar('iCoreCreateLogin.exe'), pChar(lCommand),
      pChar(ExtractFilePath(Application.ExeName)), SW_NORMAL);
  End; {If cbICore.Checked Then}

  freeAndNil(frmWait);

  If DBExists(lInstance, edtDBName.Text) Then
    MessageDlg('Database completely restored!', mtInformation, [mbok], 0)
  Else
    MessageDlg('Error restoring the database named "' + edtDBName.Text + '".',
      mtInformation, [mbok], 0);

  btnRestore.Enabled := True;
End;

{-----------------------------------------------------------------------------
  Procedure: btnCloseClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExBackup.btnCloseClick(Sender: TObject);
Begin
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: ApplicationEventsException
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExBackup.ApplicationEventsException(Sender: TObject;
  E: Exception);
Begin
  btnStartbackup.Enabled := True;
  btnRestore.Enabled := True;
End;

{-----------------------------------------------------------------------------
  Procedure: opBackupChange
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExBackup.opBackupChange(Sender: TObject);
Begin
  If opBackup.ActivePage = ofpWellcome Then
  Begin
    opBackup.HelpContext := 22;
  End
  Else If opBackup.ActivePage = ofpbackup Then
  Begin
    opBackup.HelpContext := 23;
    If edtBackupDir.CanFocus And Not (csLoading In opBackup.ComponentState) Then
    Try
      edtBackupDir.SetFocus;
    Except
    End;
  End {If opBackup.ActivePage = ofpbackup Then}
  Else If opBackup.ActivePage = ofpRestore Then
  Begin
    opBackup.HelpContext := 24;
    If edtFileRestore.CanFocus And Not (csLoading In opBackup.ComponentState) Then
    Try
      edtFileRestore.SetFocus;
    Except
    End;
  End; {If opBackup.ActivePage = ofpRestore Then}
End;

{-----------------------------------------------------------------------------
  Procedure: edtFileRestoreDialogExit
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExBackup.edtFileRestoreDialogExit(Sender: TObject;
  ExitOK: Boolean);
Var
  lFile: String;
  lIniFile: TIniFile;
Begin
  If Exitok Then
  Begin
    edtMSFiles.Text := ExtractFilePath(edtFileRestore.FileName);

    lFile := ExpandUNCFileName(edtFileRestore.Text + cCONFIEXT);

    // load backup setting file
    lIniFile := TIniFile.Create(lFile);
    edtDBName.Text := lIniFile.ReadString('Settings', 'DBName', '');
    lIniFile.Free;
  End; {If Exitok Then}
End;

{-----------------------------------------------------------------------------
  Procedure: btnConnectClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExBackup.btnConnectClick(Sender: TObject);
Var
  lConnected: Boolean;
Begin
  LockWindowUpdate(Self.Handle);

  frmWait := TfrmWait.Create(Self);
  frmWait.Start('Connecting MS SQL database...', False);

  Application.ProcessMessages;

  sleep(300);

  Try
    lConnected := ConnectionOk(edtInstance.Text);
  Finally
    frmWait.Stop;
  End;

  FreeAndNil(frmWait);

  Application.ProcessMessages;

  If lConnected Then
    LoadDatabaseNames;

  cbDbList.Enabled := lConnected;
  edtBackupDir.Enabled := lConnected;
  edtBackupName.Enabled := lConnected;
  btnStartbackup.Enabled := lConnected;
  cbCompress.Enabled := lConnected;
  cbCompanyBK.Enabled := lConnected;

  If lConnected Then
  Begin
    cbDbList.Color := clWindow;
    cbCompanyBK.Color := clWindow;
    If cbDbList.CanFocus Then
      cbDbList.SetFocus;
    GetExCompanies;
  End
  Else
  Begin
    cbDbList.Color := clSilver;
    cbCompanyBK.Color := clSilver;
  End; {else..begin}

  LockWindowUpdate(0);
End;

{-----------------------------------------------------------------------------
  Procedure: btnConnectRestClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmExBackup.btnConnectRestClick(Sender: TObject);
Var
  lConnected: Boolean;
Begin
  LockWindowUpdate(Self.Handle);

  frmWait := TfrmWait.Create(Self);
  frmWait.Start('Connecting MS SQL database...', False);

  Application.ProcessMessages;

  sleep(300);

  Try
    lConnected := ConnectionOk(edtInstRest.Text);
  Finally
    frmWait.Stop;
  End;

  FreeAndNil(frmWait);
  Application.ProcessMessages;

  If lConnected Then
    If edtFileRestore.CanFocus Then
      edtFileRestore.SetFocus;

  edtFileRestore.Enabled := lConnected;
  edtMSFiles.Enabled := lConnected;
  edtDBName.Enabled := lConnected;
  btnRestore.Enabled := lConnected;
  cbICore.Enabled := lConnected;
  LockWindowUpdate(0);
End;

{-----------------------------------------------------------------------------
  Procedure: Compress
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TExSQLBackup.Compress(Const pFileIn: String; Const pFileOut:
  String = ''): Boolean;
Begin
  Result := DoCompressionFile([soDoCompress], pFileIn, pFileOut);
End;

{-----------------------------------------------------------------------------
  Procedure: DeCompress
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TExSQLBackup.DeCompress(Const pFileIn: String; Const pFileOut:
  String = ''): Boolean;
Begin
  Result := DoCompressionFile([soDoDecompress], pFileIn, pFileOut);
End;

{-----------------------------------------------------------------------------
  Procedure: DoCompressionFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TExSQLBackup.DoCompressionFile(pOption: TFileOptions; Const
  pFileIn, pFileOut: String): Boolean;

  Function _CreateGuid: TGuid;
  Begin
    CoCreateGuid(Result);
  End;

  Function _CreateGuidStr: String;
  Begin
    Result := GUIDToString(_CreateGuid);
  End;

  Function _FileSize(Const FileName: String): LongInt;
  Var
    SearchRec: TSearchRec;
  Begin { !Win32! -> GetFileSize }
    Result := 0;
    If FindFirst(ExpandUNCFileName(FileName), faAnyFile, SearchRec) = 0 Then
      Result := SearchRec.Size;
    FindClose(SearchRec);
  End;

Var
  lInMem: TMemoryStream;
  lOutMem: TFileStream;
  lPtr: Pointer;
  lOutBytes: Integer;
  lFileOut: String;
  lCompress: TCompressionStream;
Begin
  FErrorMessage := '';

  // give sometime to flush data...
  Sleep(1000);

  // initializate variables...
  Result := False;

  lPtr := Nil;
  lInMem := Nil;
  lOutMem := Nil;
  lCompress := Nil;

  { test if pFilein and pFileout are diferent}
  If pFileOut <> '' Then
  Begin
    If _FileSize(pFileout) > 0 Then
      DeleteFile(pFileout);
    lFileOut := pFileOut;
  End
  Else { if they are equal, create a temp file}
    lFileOut := ExtractFilePath(pFileIn) + _CreateGuidStr + ExtractFileExt(pFileIn);

  Try
    lInMem := TMemoryStream.Create;

    // create output stream file
    lOutMem := TFileStream.Create(lFileOut, fmCreate);
    lOutMem.Position := 0;

    Try
      lInMem.LoadFromFile(pFileIn);
    Except
      On e: exception Do
        FErrorMessage := 'An error has just occurred. Error: ' + E.Message;
    End;

    If FErrorMessage = '' Then
    Begin
      lInMem.Position := 0;

      If soDoDecompress In pOption Then
      Begin // if decompress, decompress it to a buffer and save
        Try
          DecompressBuf(lInMem.Memory, lInMem.Size, 0, lPtr, lOutBytes);
        Except
          On e: exception Do
          Begin
            FErrorMessage := 'An error has just occurred. Error: ' + E.Message;
            lOutBytes := 0;
            lPtr := Nil;
          End; {begin}
        End; {try}

      // i will only write something if i havent got any exception ...
        If lOutBytes > 0 Then
          lOutMem.Write(lPtr^, lOutBytes);
      End
      Else If soDoCompress In pOption Then
      Begin // if compress, just save it...
        lCompress := TCompressionStream.Create(clDefault, lOutMem);

        Try
          lInMem.SaveToStream(lCompress);
        Except
          On e: exception Do
            FErrorMessage := 'An error has just occurred. Error: ' + E.Message;
        End; {try}

      End; {If soDoCompress In pOption Then}
    End; {If FErrorMessage <> '' Then}
  Finally
    Try
      If Assigned(lPtr) Then
        FreeMem(lPtr);
    Except
      lPtr := Nil;
    End;

    If Assigned(lInMem) Then
      FreeAndNil(lInMem);

    If Assigned(lCompress) Then // i need first release the compress stuff
      FreeAndNil(lCompress);

    If Assigned(lOutMem) Then
      FreeAndNil(lOutMem);

    // teste the output file
    If _FileSize(lFileOut) > 0 Then
    Begin
      If pFileOut = '' Then // only one file
      Begin
        If CopyFile(pchar(lfileOut), pChar(pFileIn), False) Then
        Begin // try to copy to same name
          DeleteFile(lFileOut);
          Result := True;
          FErrorMessage := '';
        End // copy file
        Else If DeleteFile(pFileIn) Then
          // if somethig happens, try delete and just rename the file name
          If RenameFile(lFileOut, pFileIn) Then
          Begin
            Result := True;
            FErrorMessage := '';
          End; {If RenameFile(lFileOut, pFileIn) Then}
      End
      Else
      Begin
        Result := True;
        FErrorMessage := '';
      End; {else..begin}
    End
    Else {If _FileSize(lFileOut) > 0 Then}
      DeleteFile(lFileOut)
  End; {try..finally}
End;

{ TExSQLBackup }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TExSQLBackup.Create(pAction: TAction);
Begin
  Inherited Create(True);
  FreeOnTerminate := False;
  fAction := pAction;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TExSQLBackup.Destroy;
Begin
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: DoBackup
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TExSQLBackup.DoBackup;
Var
  ADOCommand: TADOCommand;
  lFile: String;
  lIniFile: TIniFile;
  lOk: Boolean;
  lCompCode: String;
  lConnection: String;
Begin
  FErrorMessage := '';

  Sleep(100);
  lFile :=
    ExpandUNCFileName(IncludeTrailingPathDelimiter(frmExBackup.edtBackupDir.Text) +
    frmExBackup.edtBackupName.Text);
  lOk := True;

  Application.ProcessMessages;

  Try
    ADOCommand := TADOCommand.Create(Nil);

    // get the selected company code
    If Trim(frmExBackup.cbCompanyBK.Items[frmExBackup.cbCompanyBK.itemIndex]) <> ''
      Then
    Begin
      lCompCode :=
        Trim(frmExBackup.cbCompanyBK.Items[frmExBackup.cbCompanyBK.itemIndex]);
      lCompCode := Copy(lCompCode, 2, Pos(']', lCompCode) - 2);
    End; {if Trim(frmExBackup.cbCompanyBK.Items[frmExBackup.cbCompanyBK.itemIndex]) <> '' then}
                             
    If Trim(lCompCode) <> '' Then
      lConnection := sqlutils.GetConnectionString(lCompCode, False)
    Else
    Begin
      // get the default connection string...
      If (Trim(frmExBackup.edtInstance.Text) = '') Then
        lConnection := Format(cCONNECTIONSTR, ['.'])
      Else
        lConnection := Format(cCONNECTIONSTR, ['.\' +
          frmExBackup.edtInstance.Text]);
    End;

    // set the connection string
    If (Trim(frmExBackup.edtInstance.Text) = '') Then
      ADOCommand.ConnectionString := lConnection
    Else
      ADOCommand.ConnectionString := lConnection;

    ADOCommand.CommandTimeout := frmExBackup.edtTimeout.Value;
    ADOCommand.CommandText := Format(cBACKUPCOMMAND, [frmExBackup.cbDbList.Text,
      QuotedStr(lFile)]);

    {execute store procedure command}
    Try
      ADOCommand.Execute;
    Except
      On e: exception Do
      Begin
        lOk := False;
        FErrorMessage := 'Error performing MS SQL backup. Error: ' + e.Message;

//        MessageDlg('Error performing MS SQL backup. Error: ' + e.Message, mtError,
//          [mbok], 0);
      End;
    End;
  Finally
    If Assigned(ADOCommand) Then
      FreeAndNil(ADOCommand);
  End; {If Connected Then}

  Application.ProcessMessages;

  // write the configuration file
  If lOk Then
  Begin
    lIniFile := TIniFile.Create(lFile + cCONFIEXT);
    lIniFile.WriteString('Settings', 'DBName', frmExBackup.cbDbList.Text);
    lIniFile.WriteBool('Settings', 'Compress', False);

    If frmExBackup.cbCompress.Checked Then
    Begin
      // change splash information
      If Assigned(frmWait) Then
      Begin
        frmWait.pnlMessage := 'Compressing file...';
        Application.ProcessMessages;
      End;

      lIniFile.WriteBool('Settings', 'Compress', Compress(lFile));

      Application.ProcessMessages;
    End;

    lIniFile.free;
  End; {if lOk then}
End;

{-----------------------------------------------------------------------------
  Procedure: DoRestore
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TExSQLBackup.DoRestore;
Var
  ADOCommand: TADOCommand;
  lFile, lInstance: String;
  lCompressed: Boolean;
  lIniFile: TIniFile;
  lOk: Boolean;
Begin
  Sleep(100);
  FErrorMessage := '';

{

loading the database name from the backup file...
RESTORE FILELISTONLY
FROM disk='C:\EXSQL\Backup\EXCHEQUER'

}

  lFile := ExpandUNCFileName(frmExBackup.edtFileRestore.Text + cCONFIEXT);

  // load backup setting file
  lIniFile := TIniFile.Create(lFile);

  If trim(frmExBackup.edtDBName.Text) = '' Then
    frmExBackup.edtDBName.Text := lIniFile.ReadString('Settings', 'DBName', '');

  lCompressed := lIniFile.ReadBool('Settings', 'Compress', False);
  lIniFile.Free;

  // decompress database
  If lCompressed Then
  Begin
    If Assigned(frmWait) Then
      frmWait.pnlMessage := 'Decompressing file...';
    Application.ProcessMessages;
    lOk := DeCompress(frmExBackup.edtFileRestore.Text);
  End
  Else
    lOk := True;

  // check decompressed file
  If lOk Or (lCompressed And lOk) Then
  Begin
    If Assigned(frmWait) Then
      frmWait.pnlMessage := 'Restoring Database...';
    Sleep(100);

    Application.ProcessMessages;

    If Trim(frmExBackup.edtDBName.Text) <> '' Then
    Begin
      Try
        ADOCommand := TADOCommand.Create(Nil);

        // format connection string
        If Trim(frmExBackup.edtInstRest.Text) = '' Then
          ADOCommand.ConnectionString := Format(cCONNECTIONSTR, ['.'])
        Else
          ADOCommand.ConnectionString := Format(cCONNECTIONSTR, ['.\' +
            frmExBackup.edtInstRest.Text]);

        ADOCommand.CommandTimeout := frmExBackup.edtTimeout.Value;
        // format command line
        ADOCommand.CommandText := Format(cRESTORECOMMAND, [
          frmExBackup.edtDBName.Text,
            QuotedStr(frmExBackup.edtFileRestore.Text),
            quotedstr(frmExBackup.edtDBName.Text),
            quotedstr(IncludeTrailingPathDelimiter(frmExBackup.edtMSFiles.Text) +
            frmExBackup.edtDBName.Text
            + cDBEXT),
            quotedstr(frmExBackup.edtDBName.Text + '_log'),
            quotedstr(IncludeTrailingPathDelimiter(frmExBackup.edtMSFiles.Text) +
            frmExBackup.edtDBName.Text
            + '_log' + cDBLOGEXT)
            ]);

      {execute store procedure command}
        Try
          ADOCommand.Execute;
        Except
          On e: exception Do
          Begin
            FErrorMessage := 'Error performing MS SQL restore. Error: ' + e.Message;

//            MessageDlg('Error performing MS SQL restore. Error: ' + e.Message,
//              mtError, [mbok], 0);
          End;
        End;
      Finally
        If Assigned(ADOCommand) Then
          FreeAndNil(ADOCommand);

        If Trim(frmExBackup.edtInstRest.Text) = '' Then
          lInstance := '.'
        Else
          lInstance := '.\' + frmExBackup.edtInstRest.Text;

        Sleep(3000);
        Application.ProcessMessages;

        If frmExBackup.DBExists(lInstance, frmExBackup.edtDBName.Text) Then
        Begin
          // set compression to false
          If lCompressed Then
          Begin
            lIniFile := TIniFile.Create(lFile);
            lIniFile.WriteBool('Settings', 'Compress', False);
            lIniFile.Free;
          End; {if lCompressed then}
        End
      End; {If Connected Then}
    End;
  End
  Else
  Begin
    If assigned(frmWait) Then
    Begin
      frmWait.Stop;
      FreeAndNil(frmWait);
    End;

    Application.processmessages;
    FErrorMessage := 'Error decompressing file.';
    //MessageDlg('Error decompressing database.', mtInformation, [mbok], 0);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: Execute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TExSQLBackup.Execute;
Begin
  CoInitialize(Nil);

  Try
    Case fAction Of
      acBackup: doBackup;
      acRestore: DoRestore;
    End;
  Finally
    Terminate;
  End;

  CoUninitialize;
End;

End.

