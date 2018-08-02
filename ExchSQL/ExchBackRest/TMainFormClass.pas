unit TMainFormClass;

// BJH: An apology. When I rewrote Compass I went through a phase of putting the object type
// at the end of the variable name. e.g. CloseBtn instead of btnClose.
// This program started as Compass with everything to do with backup and restore ripped out.
// Having recovered from this obviously disturbing condition and gone back to the usual naming, this code is now a mixture of
// both conventions. Sorry.

interface

uses
  Windows, Forms, jpeg, ExtCtrls, StdCtrls, Controls, Classes,
  ToolWin, ImgList, graphics, messages,
  Contnrs, psvDialogs, AdvCircularProgress, AdvProgr, ComCtrls,
  AdvProgressBar, AdvCombo, ColCombo,
  Buttons, AppEvnts, Dialogs, common, IniFiles, Login, TBrowseForFolderClass, ClipBrd,
  TLoggerClass, Enterprise01_TLB, SQLUtils, TExclusiveAccessClass;

type

  TMainForm = class(TForm)
    MainPnl: TPanel;
    PageControl: TPageControl;
    ButtonPnl: TPanel;
    NavButtonPnl: TPanel;
    CloseBtn: TButton;
    ImagePnl: TPanel;
    Image1: TImage;
    tsBackupRestore: TTabSheet;
    ExchequerCoGbx: TGroupBox;
    ccbCompany: TColumnComboBox;
    BackupFolderLbl: TLabel;
    BackupFolderBtn: TBitBtn;
    BackupFolderBvl: TBevel;
    OpenDialog: TpsvOpenDialog;
    StatusBar: TPanel;
    tsSecurity: TTabSheet;
    gbPassword: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtCurrentPassword: TEdit;
    edtNewPassword: TEdit;
    edtConfirmPassword: TEdit;
    btnSaveNewPassword: TButton;
    gbBatchSecurityCode: TGroupBox;
    edtBatchCode: TEdit;
    Label4: TLabel;
    btnSaveBatchCode: TButton;
    edtBackupCmdLine: TEdit;
    edtRestoreCmdLine: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    gbBackupFileName: TGroupBox;
    edtBackupPrefix: TLabeledEdit;
    cbIncludeDate: TCheckBox;
    cbIncludeTime: TCheckBox;
    edtFileExt: TLabeledEdit;
    cbBackupFileNames: TComboBox;
    BackupFolderEdt: TEdit;
    BackupCoBtn: TButton;
    RestoreCoBtn: TButton;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    btnCopyBackupCmdLine: TSpeedButton;
    btnCopyRestoreCmdLine: TSpeedButton;
    imgSide: TImage;
    Timer: TTimer;
    pnlProgressMeters: TPanel;
    CancelBtn: TButton;
    BatchTimer: TTimer;
    OverrideChk: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DataPathEdt_Change(Sender: TObject);
    procedure BackupCoBtnClick(Sender: TObject);
    procedure RestoreCoBtnClick(Sender: TObject);
    procedure ccbCompanyChange(Sender: TObject);
    procedure BackupFolderBtnClick(Sender: TObject);
    procedure BackupFolderEdtChange(Sender: TObject);
    procedure btnCopyBackupCmdLineClick(Sender: TObject);
    procedure btnCopyRestoreCmdLineClick(Sender: TObject);
    procedure btnSaveBatchCodeClick(Sender: TObject);
    procedure btnSaveNewPasswordClick(Sender: TObject);
    procedure cbBackupFileNamesSelect(Sender: TObject);
    procedure CreateCoBtnClick(Sender: TObject);
    procedure DeleteCoBtnClick(Sender: TObject);
    procedure edtConfirmPasswordChange(Sender: TObject);
    procedure edtBatchCodeChange(Sender: TObject);
    procedure edtBatchCodeKeyPress(Sender: TObject; var Key: Char);
    procedure edtCurrentPasswordKeyPress(Sender: TObject; var Key: Char);
    procedure edtFileExtKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TimerTimer(Sender: TObject);
    procedure tsSecurityShow(Sender: TObject);
    procedure FireBatchTimer(Sender: TObject);
    procedure OverrideChkClick(Sender: TObject);
  private
    FBackupFile: string;
    FBackupFolder: string;
    FBackupSecurityCode: string;
    FRestoreSecurityCode: string;
    FCanClose: boolean;
    FDBOp: boolean;
    FNewCaption: string;
    FOrigPos: TRect;
    FFileName: string;
    FFileNameCleared: boolean;
    FImportExportWnd: HWND;
    FSelectingFile: boolean;
    Throbber: TAdvCircularProgress;
    FMCMTimer: TTimer;
    procedure APM;
    function  BackupCo: integer;
    function  BackupFileExists: boolean;
    function  BackupFolderExists: boolean;
    function  BatchProcess: boolean;
    procedure ChangeCaption;
    procedure ChangeOfCompany;
    procedure ChangeImportExportCaption(NewCaption: string);
    function  CompaniesMatch: boolean;
    function  CompanyCode: string;
    function  CompanyDataPath: string;
    function  CompanyName: string;
    function  CompanySelected: boolean;
    function  ConfirmBackup: boolean;
    function  ConfirmRestore: boolean;
    procedure CreateCo;
    procedure DeleteCo;
    procedure EnableDisableEtc;
    procedure FindBackupFiles;
    function  GenBackupSecurityCode(BatchCode: string): string;
    function  GenRestoreSecurityCode(BatchCode: string): string;
    function  GenBackupCmdLine(BatchCode: string): string;
    function  GenRestoreCmdLine(BatchCode: string): string;
    procedure GetWizardBitmap;
    procedure LoadSettings;
    function  RestoreCo: integer;
    procedure SaveSettings;
    procedure SetBackupParams;
    procedure Shutdown;
    procedure Startup;
    procedure ThrobberOn;
    procedure ThrobberOff;
    procedure PopulateCompanyList;
    procedure ShowStatusMsg(TextMsg: string; TextColor: TColor = clBlack; TextStyle: TFontStyles = []);
    function  WaitForMCMToClose: boolean;
    procedure OnTimer(Sender: TObject);
  Public
    procedure ProcessCmdLine;
  end;

var
  MainForm: TMainForm;

Implementation

uses
  SysUtils, Types, EntLicence, TDBFuncsClass, VAOUtil, Brand, TLHelp32;

{$R *.DFM}

procedure CursorOff;
begin
  screen.Cursor := crDefault;
end;

procedure CursorOn;
begin
  screen.Cursor := crHourGlass;
end;

function TMainForm.CompanySelected: boolean;
begin
  result := ccbCompany.ItemIndex <> -1;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Startup;
end;

procedure TMainForm.CloseBtnClick(Sender: TObject);
begin
  if CancelBtn.Visible then  // only in a batch mode restore
    if ConfirmRestore then
      ModalResult := mrOK
    else
      ModalResult := mrCancel
  else
    close;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  EnableDisableEtc;
  ChangeCaption;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Shutdown;
  if not FCanClose then
    Action := caNone;
end;

procedure TMainForm.EnableDisableEtc;
// Enable or disable buttons etc. depending on what's going on at the time.
// This procedure gets called after most user actions as well as before and after most tasks.
begin
  if BatchProcess then EXIT;

  if FDBOp then ThrobberOn;

  CloseBtn.Enabled          := not FDBOp;

  cbBackupFileNames.Enabled := BackupFolderExists;

  with DBFuncs do begin
    DataPath             := CompanyDataPath;
    CoCode               := CompanyCode;
    BackupCoBtn.Enabled  := CompanySelected and BackupFolderExists and not FDBOp and (FBackupFile = '') and (FBackupFolder <> '\');
    RestoreCoBtn.Enabled := CompanySelected and BackupFileExists and not FDBOp and CompaniesMatch;
  end;

  case DBFuncs.DatabaseType of
    dbBtrieve: begin
                 BackupFolderLbl.visible       := false;
                 BackupFolderEdt.visible       := false;
                 BackupFolderBtn.visible       := false;
                 BackupFolderBvl.Visible       := false;
               end;
    dbMSSQL:   begin
                 BackupFolderEdt.Enabled       :=  not FDBOp; // BackupCoBtn.Enabled; // otherwise they can't pick up a backup from another folder !
                 if BackupFolderEdt.Enabled then
                   BackupFolderEdt.Color       := clWindow
                 else
                   BackupFolderEdt.Color       := clBtnFace;
                 BackupFolderBtn.Enabled       :=  not FDBOp; // BackupCoBtn.Enabled;
               end;
    end;

end;

procedure TMainForm.DataPathEdt_Change(Sender: TObject);
begin
  EnableDisableEtc;
end;

procedure TMainForm.Startup;
begin
  if not CancelBtn.Visible then begin // setting these false in ProcessCmdLine doesn't work
    ccbCompany.TabStop      := true;  // so they've been set to false at design time
    edtBackupPrefix.TabStop := true;
    edtFileExt.TabStop      := true;
    cbIncludeDate.TabStop   := true;
    cbIncludeTime.TabStop   := true;
    BackupCoBtn.TabStop     := true;
    RestoreCoBtn.TabStop    := true;
  end;

  GetWizardBitmap;
  LoadSettings;
  EnableDisableEtc;
  PageControl.ActivePage := tsBackupRestore;

  with FOrigPos do begin              // this is a Compass thing. Not sure why I've left it in.
    Top    := self.Top;
    Left   := self.Left;
    Bottom := self.Height + 10;
    Right  := self.Width;
  end;

  case DBFuncs.DatabaseType of
    dbBtrieve: BackupFolderEdt.Text := '';
    dbMSSQL:   if BackupFolderEdt.Text = '' then
                 BackupFolderEdt.Text := VAOInfo.vaoCompanyDir;
  end;

  PopulateCompanyList;
end;

procedure TMainForm.Shutdown;
begin
  FCanClose := true;
  if not BatchProcess then
    SaveSettings;
  if assigned(Throbber) then
    Throbber.Free;
end;

procedure TMainForm.ThrobberOff;
begin
  if assigned(Throbber) then
    Throbber.Visible := false;
end;

procedure TMainForm.ThrobberOn;
begin
  if assigned(Throbber) then begin
    Throbber.Visible := true;
    Throbber.Enabled := true;
    Throbber.Update;
  end;
  application.ProcessMessages;
end;

procedure TMainForm.BackupCoBtnClick(Sender: TObject);
var
  rc: integer;
begin
  SaveSettings;
  SetBackupParams;

  if not ExclusiveAccess.HaveI(CompanyCode) then begin
    // ExclusiveAccess.ReportErrors(etShowIt);
    if not ExclusiveAccess.ReportErrorsWithOverride then
      EXIT;
  end;

  if not ConfirmBackup then EXIT;

  ShowStatusMsg(format('Backing-up %s: %s...', [CompanyCode, CompanyName]));
  Logger.LogLine(format('Backup Started: filename: "%s"', [DBFuncs.SQLDatasetBackupFileName]));

  SetWindowPos(self.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE); // stop ICoreImportExport.exe's window from flashing up before we can grab it. It will show behind our window.
  Timer.Enabled := true;       // TopMost is removed after we grab the window.
  rc := BackupCo;

  if rc = 0 then
    Logger.LogLine('Backup Finished')
  else
  if rc = -1 then
    Logger.LogLine(format('Backup failed: backup file "%s" already exists', [DBFuncs.SQLDatasetBackupFileName]))
  else
    Logger.LogLine(format('Backup failed: "%s"', [GetSQLErrorInformation(rc)]));
  FindBackupFiles;
end;

function TMainForm.BackupCo: integer;
begin
  ThrobberOn;
  try
    FDBOp := true;
    EnableDisableEtc;
    result := DBFuncs.CoBackup;
  finally
    ThrobberOff;
    FDBOp := false;
    EnableDisableEtc;
  end;
end;

procedure TMainForm.PopulateCompanyList;
var
  toolkit: IToolkit;
  i : SmallInt;
begin
  CursorOn; ThrobberOn; apm;
  ccbCompany.ComboItems.Clear;
  try
    ShowStatusMsg('Building company list, please wait...', clNavy, [fsBold]);
    toolkit := CoToolkit.Create; apm;
    if assigned(toolkit) then
    try
      if (Toolkit.Company.cmCount > 0) then
        with Toolkit.Company do
          for i := 1 to cmCount do begin
            if cmCompany[i].coCode = DBFuncs.CompassCompanyCode then
              ForceDirectories(cmCompany[i].coPath);
                                   // If the user has created a SQL dataset from another workstation the obligatory company path will have been
                                   // created locally. Trying to open the dataset from another workstation may require the same local path to exist.
                                   // *** Discuss ***

            if DirectoryExists(cmCompany[i].coPath) then
               with ccbCompany.ComboItems.Add do begin
                  strings.Add(trim(cmCompany[i].coCode));
                  strings.Add(trim(cmCompany[i].coName));
                  strings.Add(trim(cmCompany[i].coPath)); apm;
               end;
          end;
    finally
      toolkit := nil;
    end;
  finally;
    ShowStatusMsg('');
    CursorOff;
    ThrobberOff;
  end;
end;

procedure TMainForm.ShowStatusMsg(TextMsg: string; TextColor: TColor = clBlack; TextStyle: TFontStyles = []);
begin
  with StatusBar do begin
    Caption      := ' ' + TextMsg;
    Font.Color   := TextColor;
    Font.Style   := TextStyle;
    update; apm;
  end;
end;


procedure TMainForm.APM;
begin
  application.ProcessMessages;
end;

procedure TMainForm.ccbCompanyChange(Sender: TObject);
begin
  ChangeOfCompany;
  FindBackupFiles;
end;

function TMainForm.CompanyDataPath: string;
begin
  result := ccbCompany.ColumnItems[ccbCompany.ItemIndex, 2];
end;

procedure TMainForm.ChangeCaption;
begin
  caption := 'Exchequer Backup & Restore ' + AppVersion;
  case DBFuncs.DatabaseType of
    dbBtrieve: caption := caption + ' - Pervasive Edition';
    dbMSSQL:   caption := caption + ' - SQL Server Edition';
  end;
end;

procedure TMainForm.RestoreCoBtnClick(Sender: TObject);
var
  rc: integer;
begin
  SaveSettings; // They may have renamed and moved all the files since the last backup.
  DBFuncs.StatusBar := StatusBar;

  if not ExclusiveAccess.HaveI(CompanyCode) then begin
    ExclusiveAccess.ReportErrors(etShowIt);
    EXIT;
  end;

  if not ConfirmRestore then EXIT;

  ShowStatusMsg(format('Restoring %s: %s...', [CompanyCode, CompanyName]));
  Logger.LogLine(format('Restore Started: filename: "%s"', [FBackupFolder + FBackupFile]));

  timer.Enabled := true;
  rc := RestoreCo;

  if rc = 0 then
    Logger.LogLine('Restore Finished')
  else
    Logger.LogLine(format('Restore failed: "%s"', [GetSQLErrorInformation(rc)]));
end;

function TMainForm.RestoreCo: integer;
begin
  ThrobberOn;
  try
    FDBOp := true;
    EnableDisableEtc;
    DBFuncs.SQLDatasetBackupFileName := FBackupFolder + FBackupFile;
    result := DBFuncs.CoRestore;
  finally
    FDBOp := false;
    ThrobberOff;
    EnableDisableEtc;
  end;
end;

procedure TMainForm.ChangeOfCompany;
begin
  with DBFuncs do begin
    DataPath := CompanyDataPath;
    CoCode   := CompanyCode;
  end;
  EnableDisableEtc;
end;

function TMainForm.CompanyCode: string;
begin
  result := ccbCompany.ColumnItems[ccbCompany.ItemIndex, 0];
end;

procedure TMainForm.BackupFolderBtnClick(Sender: TObject);
begin
  FSelectingFile          := false;
  FBackupFolder           := IncludeTrailingBackslash(BrowseForFolder('Select a backup folder', ExtractFilePath(BackupFolderEdt.Text), true));
  FBackupFile             := ''; // change of folder so deselect the file name
  BackupFolderEdt.Text    := FBackupFolder;
  DBFuncs.SQLBackupFolder := BackupFolderEdt.Text;
  SaveSettings;
  FindBackupFiles;
  EnableDisableEtc;
end;

procedure TMainForm.BackupFolderEdtChange(Sender: TObject);
begin
  if FSelectingFile then begin
    FSelectingFile := false;
    EXIT;
  end;
  FBackupFolder := IncludeTrailingBackslash(ExtractFilePath(BackupFolderEdt.Text));
  FBackupFile   := ExtractFileName(BackupFolderEdt.Text);
  DBFuncs.SQLBackupFolder := FBackupFolder;
  FindBackupFiles;
  EnableDisableEtc;
end;

procedure TMainForm.btnCopyBackupCmdLineClick(Sender: TObject);
begin
  ClipBoard.AsText := edtBackupCmdLine.Text;
  btnCopyBackupCmdLine.Down := false;
end;

procedure TMainForm.btnCopyRestoreCmdLineClick(Sender: TObject);
begin
  ClipBoard.AsText := edtRestoreCmdLine.Text;
  btnCopyRestoreCmdLine.Down := false;
end;

procedure TMainForm.btnSaveBatchCodeClick(Sender: TObject);
var
  msg: string;
begin
  msg := 'Save new batch security code.'#13#10#13#10'Saving a new batch code will render'#13#10'any existing command lines invalid.'#13#10#13#10'Do you wish to proceed ?';
  if MessageBox(self.Handle, pchar(msg), 'Exchequer Backup & Restore', MB_YESNO + MB_ICONQUESTION) <> mrYes then EXIT;
  with TIniFile.Create(IniFileName) do begin
    WriteString('Security', 'BatchCode', Encrypt(edtBatchCode.Text));
    WriteString('Security', 'BackupSecurityCode', Encrypt(GenBackupSecurityCode(edtBatchCode.Text)));
    WriteString('Security', 'RestoreSecurityCode', Encrypt(GenRestoreSecurityCode(edtBatchCode.Text)));
    free;
  end;
end;

procedure TMainForm.btnSaveNewPasswordClick(Sender: TObject);
begin
  with TIniFile.Create(IniFileName) do begin
    WriteString('Security', 'Password', Encrypt(edtNewPassword.Text));
    free;
    gbPassword.Caption := 'Change Login Password - new password saved';
  end;
end;

procedure TMainForm.CreateCoBtnClick(Sender: TObject); // left in in case we add Pervasive at a later date.
begin
  CreateCo;
end;

procedure TMainForm.CreateCo; // left in in case we add Pervasive at a later date.
begin
  with OpenDialog do
    if Execute then begin
      InitialDir := ExtractFilePath(FileName); // remember path for next time
      try
        FDBOp := true;
        EnableDisableEtc;
        if DBFuncs.CoCreate(FileName) <> 0 then EXIT
        else begin
          PopulateCompanyList;
          ShowStatusMsg('Company created');
        end;
      finally
        FDBOp := false;
        EnableDisableEtc;
      end;
    end;
end;

procedure TMainForm.DeleteCoBtnClick(Sender: TObject); // left in in case we add Pervasive at a later date.
begin
  DeleteCo;
end;

procedure TMainForm.DeleteCo; // left in in case we add Pervasive at a later date.
begin
  try
    FDBOp := true;
    EnableDisableEtc;
    if DBFuncs.CoDelete <> 0 then EXIT
    else
      PopulateCompanyList;
  finally
    FDBOp := false;
    EnableDisableEtc;
  end;
end;

procedure TMainForm.edtConfirmPasswordChange(Sender: TObject);
// called every time the user types into any of the three password boxes.
var
  OK: boolean;
begin
  OK := Encrypt(edtCurrentPassword.Text) = LoginPassword;
  if not OK then
    gbPassword.Caption := 'Change Login Password - current password is invalid'
  else begin
    OK := length(edtNewPassword.Text) >= 6;
    if not OK then
      gbPassword.Caption := 'Change Login Password - enter 6 or more characters'
    else begin
      OK := edtNewPassword.Text = edtConfirmPassword.Text;
      if not OK then
        gbPassword.Caption := 'Change Login Password - passwords do not match'
      else
        gbPassword.Caption := 'Change Login Password';
    end;
  end;

  btnSaveNewPassword.Enabled := OK;
end;

procedure TMainForm.edtBatchCodeChange(Sender: TObject);
begin
  btnSaveBatchCode.Enabled := (length(trim(edtBatchCode.Text)) = 6);
  if btnSaveBatchCode.Enabled then begin
    edtBackupCmdLine.Text := GenBackupCmdLine(edtBatchCode.Text);
    edtRestoreCmdLine.Text := GenRestoreCmdLine(edtBatchCode.Text);
  end;
end;

procedure TMainForm.edtBatchCodeKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['a'..'z', #8]) then
    Key := #0;
end;

procedure TMainForm.edtCurrentPasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['a'..'z', '0'..'9', #8]) then
    Key := #0;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  EnableDisableEtc;
  if CancelBtn.Visible then
    cbBackupFileNames.DroppedDown := true
  else
    ccbCompany.SetFocus;
end;

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  Key := EnterToTab(Key, handle);
end;

function TMainForm.GenBackupCmdLine(BatchCode: string): string;
var
  CompanyCode: string;
begin
  CompanyCode := '%CODE%';
  if (OverrideChk.Checked) then
    result := ExeFileName + ' force-backup ' + CompanyCode + ' ' + GenBackupSecurityCode(BatchCode)
  else
    result := ExeFileName + ' backup ' + CompanyCode + ' ' + GenBackupSecurityCode(BatchCode);
end;

function TMainForm.GenRestoreCmdLine(BatchCode: string): string;
var
  CompanyCode: string;
begin
  CompanyCode := '%CODE%';
  SetBackupParams; // to get SQLDatasetBackupFileName
  result    := ExeFileName + ' restore ' + CompanyCode + ' ' + GenRestoreSecurityCode(BatchCode) + ' ' + DBFuncs.SQLDatasetBackupFileName;
end;

procedure TMainForm.SaveSettings;
begin
  with TIniFile.Create(IniFileName) do begin
    WriteString('Backup', 'Folder', Encrypt(IncludeTrailingBackslash(LowerCase(ExtractFilePath(BackupFolderEdt.Text)))));
    WriteString('Backup', 'Prefix', edtBackupPrefix.Text);
    WriteBool('Backup', 'IncludeDate', cbIncludeDate.Checked);
    WriteBool('Backup', 'IncludeTime', cbIncludeTime.Checked);
    WriteString('Backup', 'FileExt', edtFileExt.Text);
    free;
  end;
end;

procedure TMainForm.LoadSettings;
begin
  EncryptionOn; // comment this out for testing the ini file values - delete the ini file before setting encryption on
  with TIniFile.Create(IniFileName) do begin
    FBackupFolder         := Decrypt(ReadString('Backup', 'Folder', ''));
    edtBackupPrefix.Text  := ReadString('Backup', 'Prefix', 'Backup');
    cbIncludeDate.Checked := ReadBool('Backup', 'IncludeDate', true);
    cbIncludeTime.Checked := ReadBool('Backup', 'IncludeTime', false);
    edtFileExt.Text       := ReadString('Backup', 'FileExt', 'bkp');
    edtBatchCode.Text     := Decrypt(ReadString('Security', 'BatchCode', ''));
    FBackupSecurityCode   := ReadString('Security', 'BackupSecurityCode', '');
    FRestoreSecurityCode  := ReadString('Security', 'RestoreSecurityCode', '');
    free;
  end;
  BackupFolderEdt.Text  := FBackupFolder; // triggers BackupFolderEdtChange
end;

procedure TMainForm.tsSecurityShow(Sender: TObject);
begin
  edtBatchCode.SetFocus;
end;

function TMainForm.GenBackupSecurityCode(BatchCode: string): string;
begin
  result := Encrypt('bkp' + BatchCode);
end;

function TMainForm.GenRestoreSecurityCode(BatchCode: string): string;
begin
  result := Encrypt('rst' + BatchCode);
end;

procedure TMainForm.ProcessCmdLine;
var
  action: string;
  CoCode: string;
  SecurityCode: string;
  rc: integer;
  mr: TModalResult;
  BackupPathParam: string;
  FileExistsParam: string;
  msg: string;
begin
  FCanClose := true;
  Logger.LogFileName := VAOInfo.vaoAppsDir + 'LOGS\ExchBackRest.log'; // override Logger's default path

  if ParamCount < 3 then begin
    Logger.LogLine('Insufficient parameters');
    EXIT;
  end;

  action := ParamStr(1);
  CoCode := ParamStr(2);
  SecurityCode := ParamStr(3);

  if ParamCount > 3 then begin
    BackupPathParam := ParamStr(4) + '  '; // add two spaces to prevent AV below when ParamStr(4) is empty
    FileExistsParam := LowerCase(ParamStr(5));
    if (BackupPathParam[1] = '\') or (BackupPathParam[2] = ':') then // unc or drive letter specified
      BackupPathParam := trim(BackupPathParam) // remove our additional spaces
    else begin // backup path parameter is optional
      BackupPathParam := '';
      FileExistsParam := LowerCase(ParamStr(4));
    end;
  end;

  if BackupPathParam <> '' then begin // backups default to the backup folder in the ini file but can be overridden on the command line
    FBackupFolder := IncludeTrailingBackslash(ExtractFilePath(BackupPathParam));
    FBackupFile   := ExtractFileName(BackupPathParam);
    if (FBackupFolder <> '') and (FBackupFile <> '') then  // v.010
      DBFuncs.SQLDatasetBackupFileName := BackupPathParam; // v.010
  end;

  Logger.LogLine(format('Batch command: %s company %s %s', [action, CoCode, FileExistsParam]));
  DBFuncs.CoCode := CoCode;


  if not WaitForMCMToClose then begin
    Logger.LogLine('Operation failed: MCM still running');
    EXIT;
  end;

  if (action = 'force-backup') then
  begin
    if not ExclusiveAccess.HaveI(CoCode) then
      ExclusiveAccess.ReportErrors(etIgnore);
  end
  else if not ExclusiveAccess.HaveI(CoCode) then begin
    ExclusiveAccess.ReportErrors(etLogIt);
    EXIT;
  end;

  if (action = 'backup') or (action = 'force-backup') then begin
    if SecurityCode <> Decrypt(FBackupSecurityCode) then begin
      Logger.LogLine('Backup failed: invalid backup security code');
      EXIT;
    end
  end
  else if action = 'restore' then begin // not implemented
    if SecurityCode <> Decrypt(FRestoreSecurityCode) then begin
      Logger.LogLine('Invalid restore security code');
      EXIT;
    end
  end
  else begin
    Logger.LogLine(format('Operation failed: invalid action requested "%s"', [action]));
    EXIT;
  end;

  if (ccbCompany.ComboItems.IndexOf(CoCode).Y = -1) then begin
    Logger.LogLine(format('Backup failed: invalid company code "%s"', [CoCode]));
    EXIT;
  end
  else
    ccbCompany.ItemIndex := ccbCompany.ComboItems.IndexOf(CoCode).Y;

  DBFuncs.DataPath := CompanyDataPath;

  if (action = 'backup') or (action = 'force-backup') then begin
    SetBackupParams;
    if DBFuncs.CoBackupDone then begin
      if (FileExistsParam = 'existoverwrite') then else
      if (FileExistsParam = 'existfail') then begin
        Logger.LogLine(format('Backup failed: backup file "%s" already exists', [DBFuncs.SQLDatasetBackupFileName]));
        EXIT;
      end else
      if (FileExistsParam = 'existconfirm') then begin
        msg :=       'Backup file already exists'#13#10#13#10;
        msg := msg + 'Backup Folder: ' + FBackupFolder + #13#10;
        msg := msg + 'Backup File:   ' + ExtractFileName(DBFuncs.SQLDatasetBackupFileName) + #13#10#13#10;
        msg := msg + 'Do you wish to overwrite this file ?';
        if MessageDlg(msg, mtConfirmation, [mbYes, mbNo], 0) = mrNo then begin
          Logger.LogLine(format('Backup cancelled by user: backup file "%s" already exists', [DBFuncs.SQLDatasetBackupFileName]));
          EXIT;
        end;
      end
      else begin
        Logger.LogLine(format('Backup failed: backup file "%s" already exists', [DBFuncs.SQLDatasetBackupFileName]));
        Logger.LogLine(format('Invalid parameter specified: "%s"', [FileExistsParam]));
        EXIT;
      end;
    end;


    Logger.LogLine(format('Backup Started: filename: "%s"', [DBFuncs.SQLDatasetBackupFileName]));
    ChangeImportExportCaption(format('Backup %s: %s', [CoCode, CompanyName]));
    rc := BackupCo;
    if rc = 0 then
      Logger.LogLine('Backup Finished')
    else
      Logger.LogLine(format('Backup failed: "%s"', [GetSQLErrorInformation(rc)]));
  end;

  if action = 'restore' then begin
    if FBackupFile = 'USERSELECT' then begin            // create a copy of MainForm and reshape the normal
      with TMainForm.Create(application) do begin       // GUI so it just displays the backup file selection.
        FBackupFolder              := MainForm.FBackupFolder; // copy relevant info in to our new window.
        ccbCompany := MainForm.ccbCompany;              // saves repopulating the list of companies.
        FindBackupFiles;                                // populate the list of backup files.
        BorderStyle                := bsDialog;         // don't let them resize the window and see all the unused controls.
        Height                     := 160;              // just enough real estate to work with.
        Width                      := BackupFolderBvl.Width + 40; // just enough width.
        ImagePnl.Visible           := false;            // don't need the wizard bitmap.
        StatusBar.Visible          := false;            // no status messages will be created.
        tsSecurity.Free;                                // don't need the security tab.
        tsBackupRestore.Caption    := 'Restore ' + CoCode + ': ' + MainForm.CompanyName;
        ExchequerCoGbx.Top         := -600; // move way out of sight
        BackupFolderBvl.Top        := BackupFolderBvl.Top   - 40;     // these are the controls they can use.
        BackupFolderLbl.Top        := BackupFolderLbl.Top   - 40;
        BackupFolderEdt.Top        := BackupFolderEdt.Top   - 40;
        cbBackupFileNames.Top      := cbBackupFileNames.Top - 40;
        BackupFolderBtn.Top        := BackupFolderBtn.Top   - 40;
        CloseBtn.Cancel            := false;            // Close becomes a Restore button...
        CloseBtn.Caption           := '&Restore';
        CloseBtn.ModalResult       := mrOk;             // ...which will close the copied window.
        CancelBtn.Visible          := true;             // CancelBtn only used in this batch restore USERSELECT mode.
        CancelBtn.Default          := true;             // Escape now fires CancelBtn instead of CloseBtn

        CancelBtn.TabStop          := true;             // try and make a sensible tab order
        CancelBtn.TabOrder         := 4;                // for what remains visible.
        CloseBtn.TabStop           := true;             // This doesn't actually work properly.
        CloseBtn.TabOrder          := 5;                // Controls with TabStop:=false at design time still seem to be able to be tabbed to.

        mr := ShowModal;
        MainForm.FBackupFolder := FBackupFolder;        // The two values we were after
        MainForm.FBackupFile   := FBackupFile;
        if mr = mrCancel then begin
          Logger.LogLine('Restore cancelled');
          EXIT;
        end;
      end;
    end;  // from here onwards its the same as if the backup folder and file had been specified on the command line

    if not FileExists(FBackupFolder + FBackupFile) then begin
      Logger.LogLine(format('Restore failed: backup file "%s" does not exist', [FBackupFolder + FBackupFile]));
      EXIT;
    end;

    if (pos('-' + CoCode + '-', FBackupFile) = 0)  // file prefix and date and/or time included in filename
    and (pos('-' + CoCode + '.', FBackupFile) = 0) // file prefix but not date or time included in filename
    and (pos(CoCode + '-', FBackupFile) <> 1)      // no file prefix but date and/or time included in filename
    and (pos(CoCode + '.', FBackupFile) <> 1)      // no file prefix and no date and/or time included in filename
     then begin
      Logger.LogLine(format('Restore failed: backup file "%s" cannot be used to restore company %s', [FBackupFolder + FBackupFile, CoCode])); // v.011
      EXIT;
    end;

    Logger.LogLine(format('Restore Started: filename: "%s"', [FBackupFolder + FBackupFile]));
    ChangeImportExportCaption(format('Restore %s: %s', [CoCode, CompanyName]));
    rc := RestoreCo;
    if rc = 0 then
      Logger.LogLine('Restore Finished')
    else
      Logger.LogLine(format('Restore failed: "%s"', [GetSQLErrorInformation(rc)]));
  end;

end;

function TMainForm.BackupFileExists: boolean;
begin
  result := FileExists(FBackupFolder + FBackupFile);
end;

function TMainForm.BackupFolderExists: boolean;
begin
  result := DirectoryExists(FBackupFolder);
end;

procedure TMainForm.cbBackupFileNamesSelect(Sender: TObject);
begin
  FSelectingFile := true; // prevent loop in BackupFolderEdtChange
  BackupFolderEdt.Text := IncludeTrailingBackslash(ExtractFilePath(BackupFolderEdt.Text)) + cbBackupFileNames.Text;
  FBackupFile := cbBackupFileNames.Text;
  EnableDisableEtc;
end;

procedure TMainForm.edtFileExtKeyPress(Sender: TObject; var Key: Char);
begin
  if key = '.' then // the file extension box doesn't require the dot
    key := #0;
end;

procedure TMainForm.FindBackupFiles;
// e.g. find all *ZZZZ01*.bkp in the backup folder
var
  rc: integer;
  sr: TSearchRec;
  FileMask: string;
begin
  cbBackupFileNames.Clear;
  if CompanyCode = '' then EXIT;
  FileMask := format('%s*%s*.%s', [FBackupFolder, CompanyCode, edtFileExt.Text]);
  rc := FindFirst(FileMask, faAnyFile, sr);
  while rc = 0 do begin
    cbBackupFileNames.Items.Add(sr.Name);
    rc := FindNext(sr);
  end;
  FindClose(sr);
end;

function TMainForm.BatchProcess: boolean;
begin
  result := (ParamCount <> 0) and (ParamStr(1) <> 'gui');
end;

procedure TMainForm.GetWizardBitmap; // get the branding image and resize it.
        Procedure DoBitmapStuff;
        Var
          FromRect, ToRect : TRect;
        begin
          Image1.Picture.Bitmap.Height := Image1.Height;
          Image1.Picture.Bitmap.Width := Image1.Width;

          FromRect := Rect (0, imgSide.Picture.Height - Image1.Height, imgSide.Picture.Width, imgSide.Picture.Height);
          ToRect   := Rect (0, 0, Image1.Width, Image1.Height);

          DeleteObject(Image1.Picture.Bitmap.Palette);
          Image1.Picture.Bitmap.Palette:=CopyPalette(imgSide.Picture.Bitmap.Palette);
          Image1.Picture.Bitmap.Canvas.CopyRect(ToRect, imgSide.Picture.Bitmap.Canvas, FromRect);
        end;
begin
  Image1.Picture := nil;
  if (VAOInfo.vaoHideBitmaps) then EXIT;

  initBranding(VAOInfo.vaoCompanyDir);
  if Branding.BrandingFileExists(ebfSetup) then begin
    Branding.BrandingFile(ebfSetup).ExtractImage (imgSide, 'TallWizd');
    DoBitmapStuff;
  end;
end;

procedure TMainForm.SetBackupParams;
begin
  with DBFuncs do begin
    SQLBackupFolder := FBackupFolder;
    FilePrefix      := edtBackupPrefix.Text;
    IncludeDate     := cbIncludeDate.Checked;
    IncludeTime     := cbIncludeTime.Checked;
    FileExt         := edtFileExt.Text;
    Separator       := '-';
    StatusBar       := self.StatusBar;
  end;
end;

function TMainForm.ConfirmBackup: boolean;
var
  msg: string;
begin
  msg :=       'Backup Exchequer Company'#13#10#13#10;
  msg := msg + 'Company Code: ' + CompanyCode + #13#10;
  msg := msg + 'Company Name: ' + CompanyName + #13#10#13#10;
  msg := msg + 'Backup Folder: ' + FBackupFolder + #13#10;
  msg := msg + 'Backup File:   ' + ExtractFileName(DBFuncs.SQLDatasetBackupFileName) + #13#10#13#10;
  msg := msg + 'Do you wish to proceed with creating a new backup for this company ?';

  result := MessageDlg(msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes;

  if result and FileExists(DBFuncs.SQLDatasetBackupFileName) then begin
    msg :=       'Backup file already exists'#13#10#13#10;
    msg := msg + 'Backup Folder: ' + FBackupFolder + #13#10;
    msg := msg + 'Backup File:   ' + ExtractFileName(DBFuncs.SQLDatasetBackupFileName) + #13#10#13#10;
    msg := msg + 'Do you wish to overwrite this file ?';
    result := MessageDlg(msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes;
  end;
end;

function TMainForm.ConfirmRestore: boolean;
var
  msg: string;
begin
  msg :=       'Restore Exchequer Company'#13#10#13#10;
  msg := msg + 'Company Code: ' + CompanyCode + #13#10;
  msg := msg + 'Company Name: ' + CompanyName + #13#10#13#10;
  msg := msg + 'Backup Folder: ' + FBackupFolder + #13#10;
  msg := msg + 'Backup File:   ' + ExtractFileName(FBackupFolder + FBackupFile) + #13#10#13#10;
  msg := msg + 'Do you wish to proceed with restoring this company ?';

  result := MessageDlg(msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

function TMainForm.CompaniesMatch: boolean;
begin
  result := not (
        (pos('-' + CompanyCode + '-', FBackupFile) = 0) // file prefix and date and/or time included in filename
    and (pos('-' + CompanyCode + '.', FBackupFile) = 0) // file prefix but not date or time included in filename
    and (pos(CompanyCode + '-', FBackupFile) <> 1)      // no file prefix but date and/or time included in filename
    and (pos(CompanyCode + '.', FBackupFile) <> 1)      // no file prefix and no date and/or time included in filename
  );
end;

function TMainForm.CompanyName: string;
begin
  result := ccbCompany.ColumnItems[ccbCompany.ItemIndex, 1];
end;

procedure TMainForm.TimerTimer(Sender: TObject);
// wait for and find ICoreImportExport.exe's window.
// Then make it a child of the pnlProgressMeters TPanel component.
// Move it left and up to lose the left-hand window border and the title caption.
// The height and width of pnlProgressMeters are important as they cut off the bottom
// and right-hand window borders.
begin
  Timer.Enabled := false;
  FImportExportWnd := FindWindow('WindowsForms10.Window.8.app.0.33c0d9d', 'Import/Export');
  if FImportExportWnd = 0 then
    Timer.Enabled := true       // window hasn't been created yet. try again in 1/1000th of a second
  else begin
    Windows.SetParent(FImportExportWnd, pnlProgressMeters.Handle); // now a child of pnlProgressMeters
    SetWindowPos(FImportExportWnd, HWND_TOP, -4, -46, 0, 0, SWP_NOSIZE + SWP_SHOWWINDOW); // left, up and show
    SetWindowPos(self.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE); // remove the TopMost setting which prevented ICoreImportExport.exe's window from flashing briefly
  end;
end;

procedure TMainForm.FireBatchTimer(Sender: TObject);
// wait for and find ICoreImportExport.exe's window.
// change the window caption so the user knows whether they're backing-up or restoring
// and which company they're effecting.
// The original caption just says "Import/Export"
begin
  BatchTimer.Enabled := false;
  FImportExportWnd := FindWindow('WindowsForms10.Window.8.app.0.33c0d9d', 'Import/Export');
  if FImportExportWnd = 0 then
    Timer.Enabled := true       // window hasn't been created yet. try again in 1/1000th of a second
  else
    Windows.SetWindowText(FImportExportWnd, pchar(FNewCaption));
end;

procedure TMainForm.ChangeImportExportCaption(NewCaption: string);
begin
  FNewCaption := NewCaption;
  BatchTimer.Enabled := true;
end;

procedure TMainForm.OnTimer(Sender: TObject);
begin
  FMCMTimer.Enabled := false;
end;

function TMainForm.WaitForMCMToClose: boolean;
const
  SomeWhiles: array[1..9] of integer = (50, 100, 150, 200, 500, 1000, 2000, 3000, 4000); // MCM has 11 seconds to close
var
  i: integer;

  function MCMNotRunning: boolean;
  var
    AHandle: THandle;
    PE32: TProcessEntry32;
  begin
    result := true;

    AHandle := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS, 0);
    PE32.dwSize := Sizeof(TProcessEntry32);

    if Process32First(AHandle, PE32) then
      if LowerCase(PE32.szExeFile) = 'entrprse.exe' then
        result := false
      else
      while result and Process32Next(AHandle, PE32) do
        if LowerCase(PE32.szExeFile) = 'entrprse.exe' then
          result := false;
  end;

  procedure WaitAWhile(AWeeWhile: integer);
  begin
    FMCMTimer := TTimer.Create(nil);
    try
      FMCMTimer.Enabled  := false;
      FMCMTimer.Interval := AWeeWhile;
      FMCMTimer.OnTimer  := OnTimer;
      FMCMTimer.Enabled  := true; // gets reset to false when timer fires.
      while FMCMTimer.Enabled do application.ProcessMessages; // essential to allow ShellExecute in MCM to return.
    finally
      FMCMTimer.Free;
    end;
  end;

begin
  result := MCMNotRunning;
  if not result then
   for i := Low(SomeWhiles) to high(SomeWhiles) do begin
     WaitAWhile(SomeWhiles[i]); // can't use sleep or MCM won't close until this process exits saying MCM is running
     result := MCMNotRunning;
     if result then BREAK;
   end;
end;

procedure TMainForm.OverrideChkClick(Sender: TObject);
begin
  edtBackupCmdLine.Text := GenBackupCmdLine(edtBatchCode.Text)
end;

end.
