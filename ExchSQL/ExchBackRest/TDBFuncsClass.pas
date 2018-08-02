unit TDBFuncsClass;

interface

// snaffled from the Compass project
// some stuff left in just in case ExchBackRest is expanded to also cater for Pervasive databases.

uses
  EntLicence, Sysutils, Btrvu2, AdvProgressBar, windows, classes, ExtCtrls, graphics, SQLUtils;

const
  GROUP_ACCOUNT  = 'XYZXYZ';
  COMPASS_COCODE = 'COMPAS';

{$I EXCHDLL.INC}

Type
  VerRec = Record
    Ver  :  Integer;
    Rel  :  Integer;
    Typ  :  Char;
  end;

type
  TDBFuncs = class(TObject)
  private
    FAccountRec: TBatchCURec;
    FHistoryBalRec: THistoryBalRec;
    FCompassAccountBalance: double;
    FConRec: array[1..3] of VerRec;
    FTransHead: TBatchTHRec;
    FTransLine: array[1..10] of TBatchTLRec;
    FDataPath: string;
    FDBConnected: boolean;
    FMultiCurrency: boolean;
    FWorkstationID: integer;
    FProgressBar: TAdvProgressBar;
    FStatusBar: TPanel;
    FGLCode: integer;
    FCostCentre: string;
    FDepartment: string;
    FCoCode: string;
    FSQLBackupFolder: string;
    FLastError: string;
    FIncludeTime: boolean;
    FIncludeDate: boolean;
    FFileExt: string;
    FFilePrefix: string;
    FSeparator: string;
    FSQLDatasetBackupFileName: string;
    procedure apm;
    function  BackupPervasiveFiles: integer;
    function  BackupSQLDataset: integer;
    function  GetDatabaseType: TelDatabaseType;
    function  GetCoBackupDone: boolean;
    function  PvsBkpFile(FileStub: string): string;
    function  PvsDatFile(FileStub: string): string;
    function  RestorePervasiveFiles: integer;
    function  RestoreSQLDataset: integer;
    procedure SetDataPath(const Value: string);
    procedure SetProgressBar(const Value: TAdvProgressBar);
    function GetCompassCompanyCode: string;
    procedure SetFileExt(const Value: string);
    procedure SetFilePrefix(const Value: string);
    procedure SetIncludeDate(const Value: boolean);
    procedure SetIncludeTime(const Value: boolean);
    procedure SetSeparator(const Value: string);
    function  GetSQLDatasetBackupFileName: string;
  public
    destructor destroy; override;
    function  CompanyExists: boolean;
    function  CoBackup: integer;
    function  CoCreate(const FileName: string): integer;
    function  CoDelete: integer;
    function  CoRestore: integer;
    procedure InitProgressBar(Min: integer; Max: integer);
    function  LIVEInstalled: Boolean;
    procedure ShowStatusMsg(TextMsg: string; TextColor: TColor = clBlack; TextStyle: TFontStyles = []);
    property  SQLDatasetBackupFileName: string read GetSQLDatasetBackupFileName write FSQLDatasetBackupFileName;
    procedure StepProgressBar;
    property  CompassCompanyCode: string read GetCompassCompanyCode;
    property  CoBackupDone: boolean read GetCoBackupDone;
    property  CoCode: string read FCoCode write FCoCode;
    property  DataPath: string read FDataPath write SetDataPath;
    property  DatabaseType: TelDatabaseType read GetDatabaseType;
    property  DBConnected: boolean read FDBConnected;
    property  FilePrefix: string read FFilePrefix write SetFilePrefix;
    property  FileExt: string read FFileExt write SetFileExt;
    property  IncludeDate: boolean read FIncludeDate write SetIncludeDate;
    property  IncludeTime: boolean read FIncludeTime write SetIncludeTime;
    property  LastError: string read FLastError;
    property  ProgressBar: TAdvProgressBar read FProgressBar write SetProgressBar;
    property  Separator: string read FSeparator write SetSeparator;
    property  SQLBackupFolder: string read FSQLBackupFolder write FSQLBackupFolder;
    property  StatusBar: TPanel read FStatusBar write FStatusBar;
  end;

function DBFuncs: TDBFuncs;

implementation

uses
  UseDLLu, forms, dialogs, PathUtil, IniFiles, VAOUtil;

const
  PvsFileNames: array[1..5] of string = ('Cust\CustSupp', 'Trans\Details', 'Trans\Document', 'Trans\History', 'ExchqNum');

var
  FDBFuncs: TDBFuncs;

function DBFuncs: TDBFuncs;
begin
  if not assigned(FDBFuncs) then
    FDBFuncs := TDBFuncs.Create;

  result := FDBFuncs;
end;

{ TDBFuncs }


destructor TDBFuncs.destroy;
begin
  inherited;
end;

function TDBFuncs.GetDatabaseType: TelDatabaseType;
begin
  result := EnterpriseLicence.elDatabaseType;
end;

procedure TDBFuncs.SetDataPath(const Value: string);
begin
  FDataPath := IncludeTrailingBackslash(UpperCase(Value));
end;


procedure TDBFuncs.SetProgressBar(const Value: TAdvProgressBar);
begin
  FProgressBar := Value;
end;

procedure TDBFuncs.InitProgressBar(Min, Max: integer);
begin
  FProgressBar.Min      := Min;
  FProgressBar.Max      := Max;
  FProgressBar.Position := Min;
end;

procedure TDBFuncs.StepProgressBar;
begin
  FProgressBar.Position := FProgressBar.Position + 1;
  FProgressBar.Update; apm;
end;

function TDBFuncs.CoBackup: integer;
// backup the appropriate database depending on the licence
begin
  ShowStatusMsg('Backing-up company...');
  case EnterpriseLicence.elDatabaseType of
    dbBtrieve: result := BackupPervasiveFiles;
    dbMSSQL:   result := BackupSQLDataset;
  end;
end;

function TDBFuncs.BackupPervasiveFiles: integer;
// copy selected pervasive .dat files to .cmp Compass backup files.
// if any file causes an error, the whole backup is aborted.
var
  i: integer;
  DatName: string;
  BkpName: string;
begin
  Result := -1;
  if CoBackupDone then begin
    ShowStatusMsg('Company backup already done.', clBlue, [fsBold]);
    EXIT;
  end;
  for i := low(PvsFileNames) to high(PvsFileNames) do begin
    apm;
    DatName := PvsDatFile(PvsFileNames[i]); // what's the .dat name ?
    BkpName := PvsBkpFile(PvsFileNames[i]); // what's the .cmp name ?
    if FileExists(BkpName) then begin
      ShowStatusMsg(format('Backup file "..\%s.cmp" already exists. Backup aborted.', [PvsFileNames[i]]), clRed, [fsBold]);
      EXIT;
    end;
    if not CopyFile(pchar(DatName), pchar(BkpName), true) then begin
      ShowStatusMsg(format('Unable to copy "..\%s.dat". Backup aborted.', [PvsFileNames[i]]), clRed, [fsBold]);
      EXIT;
    end;
  end;
  ShowStatusMsg('Company backup complete');
  result := 0;
end;

function TDBFuncs.LIVEInstalled: Boolean;
// CJS 2012-02-15 - ABSEXCH-11856 - MS SQL Backup/Restore for LIVE
var
  FuncRes: LongInt;
  CountResult: Variant;
begin
  //RB 16/03/2017 2017-R1 ABSEXCH-17009 : When backing up company that does not exist in Exchequer LIVE the backup is failing with error,
  //so now checks for a table(WebVATCodes) in Company specific group instead of Common group
  FuncRes := SQLFetch('SELECT COUNT(name) AS tableCount FROM sys.tables WHERE name = ''WebVATCodes''',
                      'tableCount',
                      DataPath,
                      CountResult);
  if (FuncRes = 0) then
    Result := (CountResult = 1)
  else
    raise Exception(Format('Error checking for Exchequer LIVE: %s', [GetSQLErrorInformation(FuncRes)]));
end;

function TDBFuncs.BackupSQLDataset: integer;
var
  ExportType: integer;

begin
  result := -1;
//  if CoBackupDone then begin
//    ShowStatusMsg('Company already backed-up', clBlue, [fsBold]);
//    EXIT;
//  end;

  // CJS 2012-02-15 - ABSEXCH-11856 - MS SQL Backup/Restore for LIVE
  try
    if (LIVEInstalled) then
      ExportType := EXPORT_LIVE_ALL
    else
      ExportType := EXPORT_ALL;

    result := ExportSQLDataset(FCoCode, SQLDatasetBackupFileName, ExportType);

    if result <> 0 then begin
      ShowStatusMsg(format('Error during company backup: %s', [GetSQLErrorInformation(result)]));
      EXIT;
    end;

    ShowStatusMsg('Company backup complete');
    result := 0;
  except
    on E: Exception do
      ShowStatusMsg(E.Message);
  end;
end;

function TDBFuncs.GetCoBackupDone: boolean;
// if ANY of the backup files are missing then we don't have a backup.
// For Pervasive, a neat side effect of this is that in a group environment the users won't be able to click on the "Restore Co" button from
// one workstation and then do the same on another. The second will fail with "Incomplete backup".
var
  i: integer;
begin
  result := false;

  case DatabaseType of
    dbBtrieve: for i := low(PvsFileNames) to high(PvsFileNames) do
                 if not FileExists(PvsBkpFile(PvsFileNames[i])) then EXIT;

    dbMSSQL:   if not FileExists(SQLDatasetBackupFileName) then EXIT;
  end;

  result := true;
end;

function TDBFuncs.PvsBkpFile(FileStub: string): string;
// the FileStub is the name of the file without the path and extension
begin
  result := FDataPath + FileStub + '.cmp';
end;

function TDBFuncs.PvsDatFile(FileStub: string): string;
// the FileStub is the name of the file without the path and extension
begin
  result := FDataPath + FileStub + '.dat';
end;

function TDBFuncs.CoRestore: integer;
begin
  ShowStatusMsg('Restoring company...');
  case DatabaseType of
    dbBtrieve: result := RestorePervasiveFiles;
    dbMSSQL:   result := RestoreSQLDataset;
  end;
end;

procedure TDBFuncs.apm;
// as this is done liberally throughout the project it makes for neater code for it to be in a procedure.
// its used primarily to ensure the throbber and progress bar remain animated.
begin
  application.ProcessMessages;
end;

procedure TDBFuncs.ShowStatusMsg(TextMsg: string; TextColor: TColor = clBlack; TextStyle: TFontStyles = []);
// change the status message displayed in the main ui.
begin
  if assigned(FStatusBar) then
    with FStatusBar do begin
      Caption      := ' ' + TextMsg;
      Font.Color   := TextColor;
      Font.Style   := TextStyle;
      update; apm;
    end;
end;

function TDBFuncs.CompanyExists: boolean;
begin
  case DatabaseType of
    dbBtrieve: result := DirectoryExists(DataPath);
    dbMSSQL:   result := ValidCompany(DataPath);
  end;
end;

function TDBFuncs.RestorePervasiveFiles: integer;
// if ANY of the backup files are missing then we don't have a backup.
// A neat side effect of this is that in a group environment the users won't be able to click on the "Restore Co" button from
// one workstation and then do the same on another. The second will fail with "Incomplete backup".
var
  i: integer;
  DatName: string;
  BkpName: string;
  TmpFiles: TStringList;
begin
  result := -1;
  TmpFiles := TStringList.Create;
  try
    if not CoBackupDone then begin
      ShowStatusMsg('Backup is incomplete. Restore aborted', clBlack, [fsBold]);
      EXIT;
    end;
    for i := low(PvsFileNames) to high(PvsFileNames) do begin
      apm;
      DatName := PvsDatFile(PvsFileNames[i]); // what's the .dat name ?
      BkpName := PvsBkpFile(PvsFileNames[i]); // what's the .cmp name ?
      if FileExists(DatName) then begin
        if not RenameFile(DatName, DatName + '_') then begin // take a temporary copy in case the restore fails
          ShowStatusMsg(format('File "..\%s.dat" cannot be renamed. Restore aborted.', [PvsFileNames[i]]), clBlack, [fsBold]);
          EXIT;
        end;
        TmpFiles.Add(DatName + '_'); // delete the temporary copy later
      end;
      if not RenameFile(BkpName, DatName) then begin
        ShowStatusMsg(format('Unable to restore "..\%s.dat". Restore aborted', [PvsFileNames[i]]), clBlack, [fsBold]);
        if FileExists(DatName + '_') then
          RenameFile(DatName + '_', DatName); // restore the .dat from the .dat_ and abort
        EXIT;
      end;
    end;
    for i := 0 to TmpFiles.Count - 1 do // all .cmp's got renamed to .dat's so delete the .dat_ files
      DeleteFile(pchar(TmpFiles[i]));
    ShowStatusMsg('Company restored');
    result := 0;
  finally
    TmpFiles.Free;
  end;
end;

function TDBFuncs.RestoreSQLDataset: integer;

  // CJS 2012-02-15 - ABSEXCH-11856 - MS SQL Backup/Restore for LIVE
  function EnableConstraints(Enable: Boolean): Boolean;
  {
    Enables or disables (based on the Enable parameter) the foreign key
    constraints and the triggers. This is necessary when restoring a database
    because the restore routines deletes all the data from each table in
    turn and then copied the data back in. This breaks the referential
    integrity because the data is in an invalid state until the entire restore
    is complete.
  }
  var
    FuncRes: LongInt;
    Qry: AnsiString;
  begin
    Result := True;
    if Enable then
    begin
      // Call the stored procedure to re-enable the foreign key constraints.
      Qry := 'EXECUTE [common].[isp_Enable_Foreign_Keys] 1';
      FuncRes := ExecSQL(Qry, Datapath);
      if (FuncRes <> 0) then
      begin
        ShowStatusMsg(format('Error enabling foreign keys: %s', [SQLUtils.LastSQLError]));
        Result := False;
      end;
      if Result then
      begin
        // Call the stored procedure to re-enabled the triggers.
        Qry := 'EXECUTE [common].[isp_Enable_Triggers] 1';
        FuncRes := ExecSQL(Qry, Datapath);
        if (FuncRes <> 0) then
        begin
          ShowStatusMsg(format('Error enabling triggers: %s', [SQLUtils.LastSQLError]));
          Result := False;
        end;
      end;
    end
    else
    begin
      // Call the stored procedure to disable the foreign key constraints.
      Qry := 'EXECUTE [common].[isp_Enable_Foreign_Keys] 0';
      FuncRes := ExecSQL(Qry, Datapath);
      if (FuncRes <> 0) then
      begin
        ShowStatusMsg(format('Error disabling foreign keys: %s', [SQLUtils.LastSQLError]));
        Result := False;
      end;
      if Result then
      begin
        // Call the stored procedure to disable the triggers.
        Qry := 'EXECUTE [common].[isp_Enable_Triggers] 0';
        FuncRes := ExecSQL(Qry, Datapath);
        if (FuncRes <> 0) then
        begin
          ShowStatusMsg(format('Error disabling triggers: %s', [SQLUtils.LastSQLError]));
          Result := False;
        end;
      end;
    end;
  end;

begin
  result := -1;
  try
    // CJS 2012-02-15 - ABSEXCH-11856 - MS SQL Backup/Restore for LIVE
    // CJS 2014-01-31 - ABSEXCH-15000 - ExchBackRest fails with Ledger Multi-Contacts

    // Temporarily disable referential integrity while we are restoring
    // the data.
    if EnableConstraints(False) then
    try
      result := ImportSQLDataset(FCoCode, FSQLDatasetBackupFileName); // file name must be set by caller
      if result <> 0 then
        ShowStatusMsg(format('Error restoring company: %s', [GetSQLErrorInformation(result)]))
      else
        ShowStatusMSg('Company restored.');
    finally
      // Make sure that the constraints are re-enabled, regardless of the
      // success or failure of the actual restore.
      EnableConstraints(True);
    end;
  except
    on E:Exception do
      ShowStatusMsg(E.Message);
  end;
end;

function TDBFuncs.GetSQLDatasetBackupFileName: string;
begin
  if FSQLDatasetBackupFileName <> '' then begin // v.010 the property has been set from elsewhere, probably from the command line
    result := FSQLDatasetBackupFileName;
    EXIT;
  end;

// the property has not been set so invent a backup file name based on the user's settings.
  result := FSQLBackupFolder;
  if trim(FFilePrefix) <> '' then
    result := result + FFilePrefix + FSeparator;
  result := result + FCoCode;
  if FIncludeDate then
    result := result + FSeparator + FormatDateTime('yyyymmdd', date);
  if FIncludeTime then
    result := result + FSeparator + FormatDateTime('hhmm', time);
  result := result + '.' + FFileExt;
end;

function TDBFuncs.CoCreate(const FileName: string): integer;
  function ReadOnlyUser: string;
  begin
    Randomize;
    Result := 'REP' + FormatDateTime('hhnn', Now) + COMPASS_COCODE + Format('%.3d', [Random(1000)]);
  end;

  function ReadOnlyPassword: string;
  var
    GUID: TGUID;
  begin
    CreateGUID(GUID);
    Result := StringReplace(GUIDToString(GUID), '-', '', [rfReplaceAll]);
    Result := Copy(Result, 1, Length(Result) - 2);
  end;
begin
  result := -1;

  ShowStatusMsg('Creating company...');
  result := CreateCompany(COMPASS_COCODE, 'Compass Company', VAOInfo.vaoCompanyDir + COMPASS_COCODE + '\', FileName, ReadOnlyUser, ReadOnlyPassword);
  if result = 0 then begin
    ShowStatusMsg('Company created');
    ForceDirectories(VAOInfo.vaoCompanyDir + COMPASS_COCODE);
  end
  else begin
    ShowStatusMsg(format('Error %d creating company: %s', [result, GetSQLErrorInformation(result)]));
    ShowMessage(format('Error %d creating company: %s', [result, GetSQLErrorInformation(result)]));
  end;
end;

{function TDBFuncs.GetCompassCompanyExists: boolean;
// *** needs more work - need to know how to get the datapath for the CMPASS company code
begin
//  case Compass.DBFunctions.DatabaseType of
//    dbBtrieve: result := false;
//    dbMSSQL:   result := ValidCompany(DataPath);
//  end;
  result := false; // *** needs more work
end;}

function TDBFuncs.GetCompassCompanyCode: string;
begin
  result := COMPASS_COCODE;
end;

function TDBFuncs.CoDelete: integer;
begin
  result := -1;

  ShowStatusMsg('Deleting company...');
  result := DeleteCompany(COMPASS_COCODE);
  if result = 0 then
    ShowStatusMsg('Company deleted')
  else begin
    ShowStatusMsg(format('Error %d deleting company: %s', [result, GetSQLErrorInformation(result)]));
    ShowMessage(format('Error %d deleting company: %s', [result, GetSQLErrorInformation(result)]));
  end;
end;

procedure TDBFuncs.SetFileExt(const Value: string);
begin
  FFileExt := Value;
end;

procedure TDBFuncs.SetFilePrefix(const Value: string);
begin
  FFilePrefix := Value;
end;

procedure TDBFuncs.SetIncludeDate(const Value: boolean);
begin
  FIncludeDate := Value;
end;

procedure TDBFuncs.SetIncludeTime(const Value: boolean);
begin
  FIncludeTime := Value;
end;

procedure TDBFuncs.SetSeparator(const Value: string);
begin
  FSeparator := Value;
end;

initialization
  FDBFuncs := nil;

finalization
  if assigned(FDBFuncs) then
    FDBFuncs.Free;

end.
