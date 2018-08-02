unit TBuildImportJobsClass;

{******************************************************************************}
{ TBuildImportJob reads the settings in a .SAV file and for every import file  }
{ implied by the settings, creates an instance of TImportJob and adds it to    }
{ the import queue.                                                            }
{                                                                              }
{ Where the .SAV specifies folder names or wildcard file names,                }
{ TBuildImportJob finds all the existing import files which match and creates  }
{ a TImportJob for each one.                                                   }
{                                                                              }
{ SAV files are in standard ini file format. So are MAP files.                 }
{                                                                              }
{ TBuildImportJobs knows nothing about Exchequer. Future amendments should     }
{ ensure that this remains the case.                                           }
{******************************************************************************}

interface

uses TFindFilesClass, SysUtils, classes, TImportJobClass, IniFiles, TIniClass, GlobalTypes,
     dialogs, TAutoIncClass;

type
  TBuildImportJobs = class(TObject)
  private
{* internal fields *}
    FFindFiles: TFindFiles;
    FSAVFile: TMemIniFile;
    FNoFilesFound: boolean;
    FFileNo: integer;
    FIgnoreMissingImportFiles: boolean;
    FLastImportJob: TImportJob;
{* property fields *}
    FJobNo: integer;
    FSAVFileName: string;
    FMapFiles: TStringList;
    FAddedJobs: integer;
{* procedural methods *}
    function  FFCallBack(AFileName: string; AFileData: TFFFileData): integer;
    function  GenJobNo: integer;
    function  IniSetting(ASectionName: string; AIniSetting: string): string;
    function  LoadMapFiles: integer;
    function  OpenIniFiles: integer;
    function  PopulateAutoInc(AAutoInc: TAutoInc; AImportFileRecordTypes: TStringList; AImportFileType: TImportFileType): integer;
{* getters and setters *}
    procedure SetJobNo(const Value: integer);
    procedure SetSAVFileName(const Value: string);
    procedure SetSysMsg(const Value: string);
    function  GetSysMsg: string;
    function  GetSysMsgSet: boolean;
  public
    constructor create;
    destructor  destroy; override;
    function  BuildJobs: integer;
    property  AddedJobs: integer read FAddedJobs;
    property  JobNo: integer read FJobNo write SetJobNo;
    property  SAVFileName: string read FSAVFileName write SetSAVFileName;
    property  SysMsg: string read GetSysMsg;
    property  SysMsgSet: boolean read GetSysMsgSet;
  end;

implementation

uses TJobQueueClass, utils, TMapsClass, TLoggerClass, TErrors, GlobalConsts,
     TBtrvFileClass, VAOUtil, Btrvu2, LoginF;

{ TBuildImportJob }

constructor TBuildImportJobs.create;
begin
  inherited;

  FFindFiles := TFindFiles.create;
  FMapFiles  := TStringList.create;

  GenJobNo;
end;

destructor TBuildImportJobs.destroy;
begin
  FreeObjects([FFindFiles, FSAVFile, FMapFiles]);

  inherited;
end;

{* Procedural Methods *}

function TBuildImportJobs.BuildJobs: integer;
var
  i: integer;
  ImportList: TStringList;
begin
  result := -1;

  if OpenIniFiles <> 0 then exit;

  if LoadMapFiles <> 0 then exit;

  FLastImportJob               := nil;

  FIgnoreMissingImportFiles := SettingTF(IniSetting(JOB_SETTINGS, 'Ignore Missing Import Files'));

  ImportList := TStringList.Create;
//  ImportJobQueue.BeginUpdate; // request that JobQueue pauses while we add new jobs - now done in Scheduler
  try
    FSAVFile.ReadSectionValues(IMPORT_LIST, ImportList); // read the list of files or folders to be imported

    for i := 0 to ImportList.Count - 1 do begin
      FFindFiles.FolderName        := IncludeTrailingPathDelimiter(ExtractFilePath(ImportList.values[ImportList.Names[i]]));
      FFindFiles.FileMask          := ExtractFileName(ImportList.values[ImportList.Names[i]]);
      FFindFiles.RecurseSubFolders := false;
      FFindFiles.FileAttr          := faAnyFile;
      FNoFilesFound := true;
      if FFindFiles.FindFiles(FFCallBack) <> 0 then exit;

      // procedural logic continues in FFCallBack until FindFiles returns

      if FNoFilesFound then begin
        if not FIgnoreMissingImportFiles then
          SetSysMsg(format('No files match "%s"', [ImportList.values[ImportList.Names[i]]]));
        Logger.LogEntry(0, format('No files match "%s"', [ImportList.values[ImportList.Names[i]]]));
      end;
    end;
  finally
    ImportList.free;
  end;

{* JobSetting "ReadCache" will either be set to EndOfFile, EndOfJob or No.
   Either of the first two settings equate to true for the last file
   as long as it isn't explicitly set to No *}
  if assigned(FLastImportJob) then
    FLastImportJob.ReadSortFile := IniSetting(JOB_SETTINGS, 'Read Record Cache') <> 'No';

//  ImportJobQueue.EndUpdate; // tell JobQueue we've finished add new jobs

  if not SysMsgSet then
    result := 0;
end;

function TBuildImportJobs.FFCallBack(AFileName: string; AFileData: TFFFileData): integer;
// recieves the name of every file which satisfies the call to FindFiles in BuildJobs.
// An ImportJob is created for each filename received and added to the JobQueue.
var
  NewImportJob: TImportJob;
  LogFileFolder: string;
begin
  result := -1;
  FNoFilesFound := false;
  inc(FFileNo);

  NewImportJob                       := TImportJob.create;
  NewImportJob.JobFile               := FSAVFile.FileName;
  NewImportJob.ImportFileName        := AFileName;
  NewImportJob.FileNo                := FFileNo;
  NewImportJob.JobNo                 := FJobNo;
  NewImportJob.ImportFileType        := CheckImportFileType(AFileName);
  if SysMsgSet then exit;

{* Job Settings *}
  NewImportJob.JobDescription        := IniSetting(JOB_SETTINGS, 'Description');
  NewImportJob.ReadSortFile          := IniSetting(JOB_SETTINGS, 'Read Record Cache') = 'EndOfFile';
  NewImportJob.ArchiveImportedFiles  := SettingTF(IniSetting(JOB_SETTINGS, 'Archive Imported Files'));
  NewImportJob.HeaderRecordPresent   := SettingTF(IniSetting(JOB_SETTINGS, 'Header Record Present'));
  NewImportJob.IOTrialImport         := SettingTF(IniSetting(JOB_SETTINGS, 'Trial Import'));
  LogFileFolder                      := IncludeTrailingPathDelimiter(IniSetting(SYSTEM_SETTINGS, 'Log File Folder')); // not stored in job file
  NewImportJob.ArchiveFolder         := IncludeTrailingPathDelimiter(IniSetting(JOB_SETTINGS, 'Archive Folder'));
  NewImportJob.CarryOverAutoInc      := SettingTF(IniSetting(JOB_SETTINGS, 'Carry Over AutoInc'));
  NewImportJob.JobGlobalRecordType   := IniSetting(JOB_SETTINGS, 'Global Record Type'); // v.067

{* Import Settings *}
  NewImportJob.JobExchequerCompany   := IniSetting(IMPORT_SETTINGS, 'Exchequer Company');
  NewImportJob.JobUserName           := IniSetting(IMPORT_SETTINGS, 'UserName');
  NewImportJob.JobPassword           := IniSetting(IMPORT_SETTINGS, 'Password');
  //SS:10/10/2017:2017-R2:ABSEXCH-19432:'Windows User ID' is displayed in Exchequer instead of 'Username' of the User when data is Imported using Importer
  NewImportJob.LoginDisplayName      := IniSetting(IMPORT_SETTINGS, 'LoginDisplayName');
  LoginDisplayName                   := NewImportJob.LoginDisplayName;
  
  NewImportJob.IOCalcTHTotals        := SettingTF(IniSetting(IMPORT_SETTINGS, 'Calc Trans Header Totals'));
  NewImportJob.IOAutoSetTHOurRef     := SettingTF(IniSetting(IMPORT_SETTINGS, 'AutoSet Trans Ref'));
  NewImportJob.IOAutoSetTHLineCount  := SettingTF(IniSetting(IMPORT_SETTINGS, 'AutoSet Trans Header Line Count'));
  NewImportJob.IOAutoSetTLLineNo     := SettingTF(IniSetting(IMPORT_SETTINGS, 'AutoSet Trans Line No'));
  NewImportJob.IOAutoSetTLRefFromTH  := SettingTF(IniSetting(IMPORT_SETTINGS, 'AutoSet Trans Line Ref From Header'));
  NewImportJob.IOTruncateLongValues  := SettingTF(IniSetting(IMPORT_SETTINGS, 'Truncate Long Values'));
  NewImportJob.IOAutoSetPeriod       := SettingTF(IniSetting(IMPORT_SETTINGS, 'AutoSet Period'));
  NewImportJob.IOAllowTransactionEditing  := SettingTF(IniSetting(IMPORT_SETTINGS, 'Allow Transaction Editing'));
  NewImportJob.IOAutoSetCurrencyRates     := SettingTF(IniSetting(IMPORT_SETTINGS, 'AutoSet Currency Rates'));
  NewImportJob.IOAutoSetStockCost         := SettingTF(IniSetting(IMPORT_SETTINGS, 'AutoSet Stock Cost'));
  NewImportJob.IODeductBOMStock           := SettingTF(IniSetting(IMPORT_SETTINGS, 'Deduct BOM Stock'));
  NewImportJob.IODeductMultiLocationStock := SettingTF(IniSetting(IMPORT_SETTINGS, 'Deduct Multi Location Stock'));
  NewImportJob.IODefaultCostCentre        := IniSetting(IMPORT_SETTINGS, 'Default Cost Centre');
  NewImportJob.IODefaultCurrency          := IniSetting(IMPORT_SETTINGS, 'Default Currency');
  NewImportJob.IODefaultDepartment        := IniSetting(IMPORT_SETTINGS, 'Default Department');
  NewImportJob.IODefaultVATCode           := IniSetting(IMPORT_SETTINGS, 'Default VAT Code');
  NewImportJob.IODefaultNominalCode       := IniSetting(IMPORT_SETTINGS, 'Default Nominal Code');
  NewImportJob.IONomCurrencyVarianceTolerance      := IniSetting(IMPORT_SETTINGS, 'NOM Currency Variance Tolerance');
  NewImportJob.IOOverwriteNotepad         := SettingTF(IniSetting(IMPORT_SETTINGS, 'Overwrite Notepad'));
  NewImportJob.IOTrialImport              := SettingTF(IniSetting(IMPORT_SETTINGS, 'Trial Import'));
  NewImportJob.IOTruncateLongValues       := SettingTF(IniSetting(IMPORT_SETTINGS, 'Truncate Long Values'));
  NewImportJob.IOUpdateAccountBalances    := SettingTF(IniSetting(IMPORT_SETTINGS, 'Update Account Balances'));
  NewImportJob.IOUpdateStockLevels        := SettingTF(IniSetting(IMPORT_SETTINGS, 'Update Stock Levels'));
  NewImportJob.IOUseJobBudgets            := SettingTF(IniSetting(IMPORT_SETTINGS, 'Use Job Budgets'));
  NewImportJob.IOValidateJobCostingFields := SettingTF(IniSetting(IMPORT_SETTINGS, 'Validate Job Costing Fields'));
  NewImportJob.IOIgnoreImportErrors       := SettingTF(IniSetting(IMPORT_SETTINGS, 'Ignore Import Errors'));
  NewImportJob.DateFormat                 := IniSetting(IMPORT_SETTINGS, 'Date Format');

  NewImportJob.IOApplyVBD                 := SettingTF(IniSetting(IMPORT_SETTINGS, 'Apply Value-Based Discounts'));
  NewImportJob.IOApplyMBD                 := SettingTF(IniSetting(IMPORT_SETTINGS, 'Apply Multi-Buy Discounts'));

  //PR: 07/10/2010 New property added for importing discounts with date ranges
  NewImportJob.IOOverwriteDiscountDates   := SettingTF(IniSetting(IMPORT_SETTINGS, 'Overwrite Discounts with Date Ranges'));

  NewImportJob.LogFileName           := LogFileFolder + format('Job %.6d File %.3d ', [FJobNo, FFileNo]) + AFileData.FileName {+ ' Log ' + CleanDateTime(now)} + '.txt';
  NewImportJob.ImportFileRecordCount := FindRecordTypes(AFileName, NewImportJob.Maps.RecordTypes, NewImportJob.HeaderRecordPresent, NewImportJob.JobGlobalRecordType);
  if SysMsgSet then exit;

{* Field Def Maps *}
  NewImportJob.Maps.MapFiles.AddStrings(FMapFiles);                      // give the Maps object the list of map files
  NewImportJob.Maps.ImportFileType   := NewImportJob.ImportFileType;     // tell it what type of file the maps are for
  if NewImportJob.Maps.CreateMaps <> 0 then                              // load the maps into the internal structures.
    exit;
  NewImportJob.SortRequired          := NewImportJob.Maps.SortRequired; // only want the code in TMaps called once to
                                                                        // find out if a sort is required.

{* AutoInc *}
  if NewImportJob.CreateAutoInc then
    if PopulateAutoInc(NewImportJob.AutoInc, NewImportJob.Maps.RecordTypes, NewImportJob.Maps.ImportFileType) <> 0 then exit;

{* Job Queue *}
  if ImportJobQueue.AddJob(NewImportJob) <> 0 then begin
    SetSysMsg(format('Unable to add Job %d File %d ("%s") to Import Job Queue', [FJobNo, FFileNo, AFileName]));
    exit;
  end;

  inc(FAddedJobs);
  FLastImportJob                     := NewImportJob;

  result := 0; // otherwise FindFiles will cancel
end;

function TBuildImportJobs.GenJobNo: integer;
// Reads the previous job number from ImportJob.dat and updates it.
// If the file doesn't exist it will be created.
type
  TJobNoRecord = record
    Key:   array[1..8] of char;
    JobNo: integer;
  end;
const
  JobNoF = 24;
var
  LastJobNo: string;
  Code: integer;
  JobNoFile: TBtrvFile;
  JobNoRec : TJobNoRecord;
  rc: integer;
begin
  result := -1;
  JobNoRec.Key   := 'JobNoRec';
  JobNoRec.JobNo := 0;

  JobNoFile := TBtrvFile.create;
  try
    //PR: 09/06/2009 Changed to use file no 24 to avoid clashes
    JobNoFile.FileIx       := JobNoF;
    //AP: 10/11/2017 ABSEXCH-19433:Importer Pervasive Only : Job number is repeated when job is executed multiple times with multi-company data set
    JobNoFile.FileName     := IncludeTrailingPathDelimiter(VAOInfo.vaoAppsDir) + 'MISC\ImportJob.dat';
//    JobNoFile.FileIx       := JobNoFile.MaxBtrvFiles - 1;
    JobNoFile.RecordLength := SizeOf(TJobNoRecord);
    JobNoFile.KeySegs      := 1;
    JobNoFile.DefineKey(1, 1, 8, Modfy+AltColSeq);

    rc := JobNoFile.FindRecord(JobNoRec, 'JobNoRec');
    if rc <> 0 then begin
      Logger.LogEntry(0, format('Previous Job Number not found - starting from 000001 [%d]', [rc]));
      if ZeroJobNo then
        JobNoRec.JobNo := -1 // used to create an ImportJob.dat file with zero in it for distributing to new installations
      else
        JobNoRec.JobNo := 0;
    end;


    rc := JobNoFile.LockRecord;
    inc(JobNoRec.JobNo); // will either be 1 or previous Job Number + 1
    if rc <> 0 then begin
      Logger.LogEntry(0, format('Cannot lock Job Number for updating [%d]', [rc]));
    end
    else begin
      rc := JobNoFile.UpdateRecord;
      if rc <> 0 then
        Logger.LogEntry(0, format('Cannot update Job Number record - [%d]', [rc]))
      else begin
        rc := JobNoFile.UnlockRecord;
        if rc <> 0 then
          Logger.LogEntry(0, format('Cannot unlock Job Number record - [%d]', [rc]));
      end;
    end;

    if rc <> 0 then begin // if we didn't get thru the above with rc = 0 then try writing a new copy of the record over the old one
      rc := JobNoFile.WriteRecord(JobNoRec);
      if rc <> 0 then
        Logger.LogEntry(0, format('Cannot write Job Number record - [%d]', [rc]));
    end;

    rc := JobNoFile.CloseFile;
    if rc <> 0 then
      Logger.LogEntry(0, format('Job Number file did not close properly - [%d]', [rc]));
  finally
    JobNoFile.Free;
  end;

  FJobNo := JobNoRec.JobNo;
  result := 0;
end;

function TBuildImportJobs.OpenIniFiles: integer;
var
  JobCompany: string;
begin
  result := -1;

  if not FileExists(FSavFileName) then begin
    SetSysMsg(format('File "%s" does not exist', [FSAVFileName]));
    Logger.LogEntry(0, SysMsgNoClear); // Log the error but don't clear the error condition
    exit;
  end;

  IniFile.DecryptIniFile(FSAVFileName, false);
  FSAVFile              := TMemIniFile.Create(FSAVFileName);
  if not PlainOut then
    IniFile.EncryptIniFile(FSAVFileName);

  //AP : 02/06/2017 : ABSEXCH-18485 : Once Scheduler re-started the Imports started importing to logged in company
  JobCompany := FSAVFile.ReadString(IMPORT_SETTINGS, 'Exchequer Company', '');
  if (JobCompany = LoginCompany) then
    //ABSEXCH-17046:Imported transactions showing the incorrect last editted user
    WriteIniLogonInfo(FSAVFile); // update the login info in the job file


  Logger.LogEntry(0, '');
  Logger.LogEntry(0, DateTimeToStr(now) + format(' Build job %d from file %s', [FJobNo, FSAVFileName]));

  result := 0;
end;




function TBuildImportJobs.IniSetting(ASectionName: string; AIniSetting: string): string;
begin
  result := FSAVFile.ReadString(ASectionName, AIniSetting, ''); // is there an override setting in the SAV file
  if result = '' then                                         // no ?.....
    result := IniFile.ReturnValue(ASectionName, AIniSetting);   // then use the default setting
end;

function TBuildImportJobs.LoadMapFiles: integer;
// compose a list of RecordType=MapFile from the SAV file and the main settings file.
// This section deliberately avoids using AddStrings with the duplicates=dupIgnore setting as
// dupIgnore has well-documented, but as yet unfixed (D6), bugs.
var
  tmpStrings: TStringList;
  i: integer;
begin
  result := -1;

  tmpStrings := TStringList.create;
  try
    FSAVFile.ReadSectionValues(FIELD_MAPS, FMapFiles);   // read in any overridden MapFile settings from the SAV file
    IniFile.ReturnValuesInList(FIELD_MAPS, tmpStrings);  // pick up the default MapFile settings
    for i := 0 to tmpStrings.Count - 1 do
      if FMapFiles.IndexOfName(tmpStrings.Names[i]) = -1 then        // add any we haven't already got
        FMapFiles.Add(tmpStrings[i]);
  finally
    tmpStrings.Free;
  end;

  if FMapFiles.Count = 0 then begin
    SetSysMsg('No Field Map settings found');
    exit;
  end;

  result := 0;
end;

function TBuildImportJobs.PopulateAutoInc(AAutoInc: TAutoInc; AImportFileRecordTypes: TStringList; AImportFileType: TImportFileType): integer;
// If any of the map files uses [AutoIncx] fields they may also contain
// an [AutoIncReset] section which states which record type causes each
// counter (0-9) to be reset to zero, e.g. 0=TH, 1=TL
// This section reads each Map file, checks for the existence of a reset
// entry and populates the AutoInc object.
// It is up to the user to ensure that their use of [AutoInc0] to [AutoInc9]
// in any one import job/Sav file does not cause conflicts.
// Ok to not have a Mapfile for ftStdImport files as it will default to the
// full definition in the main settings file. User only creates a map file for
// stdImportFile if they have default values they want to set for certain fields.
// 06/2006: Prior to release, the ability for users to create field maps for
// std import files was removed. The only defaults that get actioned are
// therefore the ones present in the main settings file.
var
  i, j: integer;
  tmpIniFile: TMemIniFile;
  RecordType: string;
  MapFileName: string;
begin
  result := -1;

  for i := 0 to AImportFileRecordTypes.Count - 1 do begin
    MapFileName := FMapFiles.Values[AImportFileRecordTypes[i]];
    if MapFileName = '' then begin
      if AImportFileType = ftUserDef then // all user-def files must a field map for each record type
        SetSysMsg(format('No Field Map setting for record type "%s"', [AImportFileRecordTypes[i]]))
      else
        result := 0;
      exit;
    end;

    IniFile.DecryptIniFile(MapFileName, false);
    tmpIniFile := TMemIniFile.Create(MapFileName);
    if not PlainOut then
      IniFile.EncryptIniFile(MapFileName); // re-encrypt the file after reading it.
    try
      for j := 0 to MaxAutoIncs do begin                  // ask for AutoInc0=record type, AutoInc1=record type, etc.
        RecordType := tmpIniFile.ReadString(AUTOINCRESET, 'AutoInc' + IntToStr(j), '');
        if RecordType <> '' then
          AAutoInc.SetReset[j] := RecordType;
      end;
    finally
      tmpIniFile.Free;
    end;
  end;

  result := 0;
end;

{* getters and setters *}

procedure TBuildImportJobs.SetJobNo(const Value: integer);
begin
  FJobNo := Value;
end;

procedure TBuildImportJobs.SetSAVFileName(const Value: string);
begin
  FSAVFileName := Value;
end;

function TBuildImportJobs.GetSysMsg: string;
begin
  result  := TErrors.SysMsg;
end;

procedure TBuildImportJobs.SetSysMsg(const Value: string);
begin
  TErrors.SetSysMsg(Value);
end;

function TBuildImportJobs.GetSysMsgSet: boolean;
begin
  result := TErrors.SysMsgSet;
end;

end.
