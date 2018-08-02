unit TImportJobClass;

{******************************************************************************}
{       One single instance of TImportJob imports one file.                    }
{       TBuildImportJob creates an instance of TImportJob and populates its    }
{       properties with all the information required to import the file.       }
{                                                                              }
{       TImportJob knows nothing about Exchequer. Future amendments should     }
{       ensure that this remains the case.                                     }
{                                                                              }
{       see the Getters and Setters methods for descriptions of the various    }
{       properties (actually, don't - I didn't have time).                     }
{******************************************************************************}

interface

uses classes, windows, TIniClass, GlobalTypes, TCSVClass, TMapsClass, TRecordMgrClass,
     TAutoIncClass, TStdImpFileClass, TPosterClass, TImportToolkitClass, EntLicence;

type

  TImportJob = class(TObject)
  private
// internal fields
    FCSVFile:       TCSV;
    FFieldNo:       integer;
    FFieldValue:    string;
    FFirstAType:    boolean;
    FFirstSType:    boolean;
    FFirstFType:    boolean;
    FImportError:   boolean;
    FOrigFieldValue: string;
    FRecordMgr:     TRecordMgr;
    FRecordNo:      integer;
    FStartTime:     cardinal;
    FStdImportFile: TStdImpFile;

    DD, MM, YY: string;
    PosDD, PosMM, PosYY: integer;
// property fields
    FArchiveFolder: string;
    FAutoInc:       TAutoInc;
    FAutoIncCopy:   TAutoInc;
    FExchequerCompany: string;
    FMaps:          TMaps;
    FHeaderRecordPresent: boolean;
    FImportFileName: string;
    FErrorRecordCount: integer;
    FHeaderRecordCount: integer;
    FImportFileRecordCount: integer;
    FImportFileType: TImportFileType;
    FJobDescription: string;
    FLogFileName:    string;
    FSortRequired:   boolean;
    FReadSortFile:   boolean;
    FJobNo:          integer;
    FFileNo:         integer;
    FArchiveImportedFiles: boolean;
    FIOCalcTHTotals: boolean;
    FIOAutoSetTLLineNo:  boolean;
    FIOAutoSetTHLineCount: boolean;
    FIOAutoSetTLRefFromTH: boolean;
    FIOAutoSetTHOurRef:  boolean;
    FIOTrialImport:  boolean;
    FIOTruncateLongValues: boolean;
    FJobFile: string;
    FUserName: string;
    FPassword: string;
    FCarryOverAutoInc: boolean;
    FPoster: TPoster;
    FIOAutoSetPeriod: boolean;
    FIOUpdateAccountBalances: boolean;
    FIOAutoSetStockCost: boolean;
    FIOOverwriteNotepad: boolean;
    FIOUpdateStockLevels: boolean;
    FIOValidateJobCostingFields: boolean;
    FIODeductMultiLocationStock: boolean;
    FIODeductBOMStock: boolean;
    FIOAutoSetCurrencyRates: boolean;
    FIOAllowTransactionEditing: boolean;
    FIODefaultCurrency: string;
    FIODefaultCostCentre: string;
    FIODefaultDepartment: string;
    FIODefaultNominalCode: string;
    FIODefaultVATCode: string;
    FDateFormat: string;
    FValidRecord: boolean;
    FIOIgnoreImportErrors: boolean;
    FIONomCurrVarTolerance: string;
    FIOUseJobBudgets: boolean;
    FJobGlobalRecordType: string;
    FIOApplyVBD : Boolean;
    FIOApplyMBD :  Boolean;
    //PR: 07/10/2010 New property added for importing discounts with date ranges
    FIOOverwriteDiscountDates : Boolean;
    FLoginDisplayName: string;

// procedural methods
    function  ArchiveImportFile: integer;
    function  CheckFieldDefault: integer;
    function  CheckLoginCredentials: integer;
    procedure CheckSysVal;
    procedure CloneAutoInc(FromAutoInc, ToAutoInc: TAutoInc);
    function  ConfigureTheToolkit: integer;
    procedure DecodeDateFormat;
    function  EndOfFieldDefs: boolean;
    function  EndOfFile: boolean;
    function  FindMap(ARecordType: string): integer;
    function  FirstFieldDef: integer;
    function  FormattedAutoInc: string;
    function  FormattedCurInc: string;
    function  IgnoreField: boolean;
    function  ImportTheFile: integer;
    function  InFixedList: boolean;
    function  InitLogFile: integer;
    function  LogEntry(ALogEntry: string; AImportError: boolean): integer;
    function  OutputFieldValue: integer;
    function  NextAutoInc: integer;
    function  NextFieldDef: integer;
    procedure NextFieldNo;
    function  NextRecord: string;
    procedure NextRecordNo;
    function  NextFieldValue: integer;
    function  PassesVRule: boolean;
    procedure PostPhase1Message; // v.084
    procedure PostPhase2Message; // v.084
    procedure PostProgressMessage;
    function  RecordDone: integer;
    function  Shutdown: integer;
    function  Startup: integer;
    function  StopLogFile: integer;
    procedure TranslateValue;
    function  ValidFieldValue: boolean;
    function  ValidMap: boolean;
    procedure IncrementDataRecordError(Sender : TObject);
// Getters and Setters
    procedure SetArchiveFolder(const Value: string);
    procedure SetExchequerCompany(const Value: string);
    procedure SetHeaderRecordPresent(const Value: boolean);
    procedure SetImportFileName(const Value: string);
    procedure SetImportFileRecordCount(const Value: integer);
    procedure SetImportFileType(const Value: TImportFileType);
    procedure SetJobDescription(const Value: string);
    procedure SetLogFileName(const Value: string);
    procedure SetSortRequired(const Value: boolean);
    procedure SetAutoInc(const Value: TAutoInc);
    procedure SetReadSortFile(const Value: boolean);
    procedure SetJobNo(const Value: integer);
    procedure SetFileNo(const Value: integer);
    procedure SetArchiveImportedFiles(const Value: boolean);
    procedure SetIOAutoSetPeriod(const Value: boolean);
    procedure SetIOCalcTHTotals(const Value: boolean);
    procedure SetIOAutoSetTHOurRef(const Value: boolean);
    procedure SetIOAutoSetTHLineCount(const Value: boolean);
    procedure SetIOAutoSetTLLineNo(const Value: boolean);
    procedure SetIOAutoSetTLRefFromTH(const Value: boolean);
    procedure SetIOTrialImport(const Value: boolean);
    procedure SetIOTruncateLongValues(const Value: boolean);
    function  GetSysMsg: string;
    function  GetSysMsgSet: boolean;
    procedure SetSysMsg(const Value: string);
    procedure SetJobFile(const Value: string);
    procedure SetPassword(const Value: string);
    procedure SetUserName(const Value: string);
    procedure SetCarryOverAutoInc(const Value: boolean);
    procedure SetPoster(const Value: TPoster);
    procedure SetIOAllowTransactionEditing(const Value: boolean);
    procedure SetIOAutoSetCurrencyRates(const Value: boolean);
    procedure SetIOAutoSetStockCost(const Value: boolean);
    procedure SetIODeductBOMStock(const Value: boolean);
    procedure SetIODeductMultiLocationStock(const Value: boolean);
    procedure SetIODefaultCostCentre(const Value: string);
    procedure SetIODefaultCurrency(const Value: string);
    procedure SetIODefaultDepartment(const Value: string);
    procedure SetIODefaultNominalCode(const Value: string);
    procedure SetIODefaultVATCode(const Value: string);
    procedure SetIOOverwriteNotepad(const Value: boolean);
    procedure SetIOUpdateAccountBalances(const Value: boolean);
    procedure SetIOUpdateStockLevels(const Value: boolean);
    procedure SetIOValidateJobCostingFields(const Value: boolean);
    procedure SetDateFormat(const Value: string);
    procedure SetIOIgnoreImportErrors(const Value: boolean);
    procedure SetIONomCurrVarTolerance(const Value: string);
    procedure SetIOUseJobBudgets(const Value: boolean);
    procedure SetJobGlobalRecordType(const Value: string);
    procedure SetLoginDisplayName(const Value: string);
  public
    constructor create;
    destructor  destroy; override;
    function  CreateAutoInc: boolean;
    procedure CreateRecordMgr;
    function  Execute: integer;
    property  ArchiveFolder: string read FArchiveFolder write SetArchiveFolder;
    property  ArchiveImportedFiles: boolean read FArchiveImportedFiles write SetArchiveImportedFiles;
    property  AutoInc: TAutoInc read FAutoInc write SetAutoInc;
    property  CarryOverAutoInc: boolean read FCarryOverAutoInc write SetCarryOverAutoInc;
    property  DateFormat: string read FDateFormat write SetDateFormat;
    property  FileNo: integer read FFileNo write SetFileNo;
    property  Maps: TMaps read FMaps write FMaps;
    property  HeaderRecordPresent: boolean read FHeaderRecordPresent write SetHeaderRecordPresent;
    property  ImportFileName: string read FImportFileName write SetImportFileName;
    property  ImportFileRecordCount: integer read FImportFileRecordCount write SetImportFileRecordCount;
    property  ImportFileType: TImportFileType read FImportFileType write SetImportFileType;
    property  IOAllowTransactionEditing: boolean read FIOAllowTransactionEditing write SetIOAllowTransactionEditing;  // why didn't I create an ImportOptions class ?
    property  IOAutoSetCurrencyRates: boolean read FIOAutoSetCurrencyRates write SetIOAutoSetCurrencyRates;
    property  IOAutoSetPeriod: boolean read FIOAutoSetPeriod write SetIOAutoSetPeriod;
    property  IOCalcTHTotals: boolean read FIOCalcTHTotals write SetIOCalcTHTotals;
    property  IOAutoSetTHOurRef: boolean read FIOAutoSetTHOurRef write SetIOAutoSetTHOurRef;
    property  IOAutoSetStockCost: boolean read FIOAutoSetStockCost write SetIOAutoSetStockCost;
    property  IOAutoSetTHLineCount: boolean read FIOAutoSetTHLineCount write SetIOAutoSetTHLineCount;
    property  IOAutoSetTLLineNo: boolean read FIOAutoSetTLLineNo write SetIOAutoSetTLLineNo;
    property  IOAutoSetTLRefFromTH: boolean read FIOAutoSetTLRefFromTH write SetIOAutoSetTLRefFromTH;
    property  IODeductBOMStock: boolean read FIODeductBOMStock write SetIODeductBOMStock;
    property  IODeductMultiLocationStock: boolean read FIODeductMultiLocationStock write SetIODeductMultiLocationStock;
    property  IODefaultCostCentre: string read FIODefaultCostCentre write SetIODefaultCostCentre;
    property  IODefaultCurrency: string read FIODefaultCurrency write SetIODefaultCurrency;
    property  IODefaultDepartment: string read FIODefaultDepartment write SetIODefaultDepartment;
    property  IODefaultVATCode: string read FIODefaultVATCode write SetIODefaultVATCode;
    property  IODefaultNominalCode: string read FIODefaultNominalCode write SetIODefaultNominalCode;
    property  IOIgnoreImportErrors: boolean read FIOIgnoreImportErrors write SetIOIgnoreImportErrors;
    property  IONomCurrencyVarianceTolerance: string read FIONomCurrVarTolerance write SetIONomCurrVarTolerance;
    property  IOOverwriteNotepad: boolean read FIOOverwriteNotepad write SetIOOverwriteNotepad;
    property  IOTrialImport: boolean read FIOTrialImport write SetIOTrialImport;
    property  IOTruncateLongValues: boolean read FIOTruncateLongValues write SetIOTruncateLongValues;
    property  IOUpdateAccountBalances: boolean read FIOUpdateAccountBalances write SetIOUpdateAccountBalances;
    property  IOUpdateStockLevels: boolean read FIOUpdateStockLevels write SetIOUpdateStockLevels;
    property  IOUseJobBudgets: boolean read FIOUseJobBudgets write SetIOUseJobBudgets;
    property  IOValidateJobCostingFields: boolean read FIOValidateJobCostingFields write SetIOValidateJobCostingFields;
    property  JobDescription: string read FJobDescription write SetJobDescription; // used by TJobQueue
    property  JobExchequerCompany: string read FExchequerCompany write SetExchequerCompany;
    property  JobFile: string read FJobFile write SetJobFile;
    property  JobGlobalRecordType: string read FJobGlobalRecordType write SetJobGlobalRecordType; // v.067
    property  JobNo: integer read FJobNo write SetJobNo;
    property  JobPassword: string read FPassword write SetPassword;
    property  JobUserName: string read FUserName write SetUserName;
    property  LoginDisplayName: string read FLoginDisplayName write SetLoginDisplayName;
    property  LogFileName: string read FLogFileName write SetLogFileName;
    property  Poster: TPoster read FPoster write SetPoster;
    property  ReadSortFile: boolean read FReadSortFile write SetReadSortFile;
    property  SortRequired: boolean read FSortRequired write SetSortRequired;
    property  SysMsg: string read GetSysMsg;
    property  SysMsgSet: boolean read GetSysMsgSet;
    property  IOApplyVBD : Boolean read FIOApplyVBD write FIOApplyVBD;
    property  IOApplyMBD : Boolean read FIOApplyMBD write FIOApplyMBD;
    //PR: 07/10/2010 New property added for importing discounts with date ranges
    property  IOOverwriteDiscountDates : Boolean read FIOOverwriteDiscountDates write FIOOverwriteDiscountDates;

  end;

implementation

uses utils, SysUtils, TLoggerClass, TErrors, GlobalConsts, TJobQueueClass;

{ TImportJob }

constructor TImportJob.create;
begin
  inherited;

  FMaps    := TMaps.Create;
end;

destructor TImportJob.destroy;
begin

  inherited;
end;

{* Procedural Methods *}

function TImportJob.ArchiveImportFile: integer;
// return code of MoveFileEx is non-zero if successful or zero if it failed.
var
  Entry: string;
  FileNum: integer;
  ArchiveFile: string;
  FileName: string;
  FileExt: string;
  FileStub: string;
begin
  result  := -1;
  FileNum := 0; // v.066
  ForceDirectories(ArchiveFolder);
  if not DirectoryExists(ArchiveFolder) then begin
    Entry := format('Folder "%s" does not exist and could not be created', [ArchiveFolder]);
    LogEntry(Entry, true);
    exit;
  end;

  ArchiveFile := ArchiveFolder + ExtractFileName(ImportFileName); // v.066 prevent name clashes with existing files
  FileName := ExtractFileName(ArchiveFile);
  FileExt  := ExtractFileExt(FileName);
  FileStub := copy(FileName, 1, length(FileName) - length(FileExt));
  while FileExists(ArchiveFile) do begin
    inc(FileNum);
    ArchiveFile := format('%s%s %.3d%s', [ArchiveFolder, FileStub, FileNum, FileExt]);
  end;

  if MoveFileEx(pchar(ImportFileName), pchar(ArchiveFile),
                MOVEFILE_COPY_ALLOWED {allows file to be moved to different drive}
                or MOVEFILE_WRITE_THROUGH) <> longbool(0) then begin
    result := 0;
    Entry := format('%s archived to %s', [FImportFileName, ArchiveFile]);
    LogEntry(Entry, false);
  end
  else begin
    result := -1;
    Entry := format('Couldn''t archive %s to %s: %s', [FImportFileName,
                                                          ArchiveFile,
                                                          SysErrorMessage(GetLastError)]);
    LogEntry(Entry, true);
    Logger.LogEntry(0, Entry);
  end;
end;

function TImportJob.CheckFieldDefault: integer;
// If there are more Field Defs defined in the map than there are fields on the
// CSV record, TCSV will return "CSVERROR_". This is checked for and replaced
// by the default value. This means the user can provide default values at the
// end of each map, without having to provide loads of blank values at the end
// of each record.
//
// If the map specifies that its a FIXED field then the default is always used.
// This allows incoming record types such as OL to be registered with
// TRecordMgr as TL which is what they end up as. The original idea behind fixed
// fields was that the incoming value must equal the default value but a better
// use is to replace the incoming value regardless of what it is. In the case
// of the Record Type, we can use it to identify which map describes the
// incoming data record, and then change it to the type of Exchequer record
// that gets built from it.
// For an AutoInc/CurrInc field, FFieldValue has already been taken care of.
// If it's an "Include" field, there is never a column for it in the import file
// so use the default value after having removed the identifying [I] prefix.
// (A) If FJobGlobalRecordType <> '' then FOrigFieldValue has already been taken care of in DoGlobalRecordType.
//     If the RecordType is followed by an AutoInc field then an Include field such as "Operator = [I]%sysuser%" then
//     FFieldNo will still be 1 and FFieldValue will be blank. This causes an access violation as TRecordMgr.NewRecord gets passed a null string
//     and then tries to Move OrigFieldValue[1].
begin
  Result := 0;
  if (not FMaps.AutoInc) and (not FMaps.CurrInc) and ((FFieldValue = '') or (FFieldValue = 'CSVERROR_') or FMaps.Fixed) then begin
    if (FFieldNo = 1) and (FJobGlobalRecordType = '') and (FFieldValue <> '')  then  // see (A) - Fixes the "include field is first in map" bug
      FOrigFieldValue := FFieldValue; // remember the incoming record type   // v.061
    FFieldValue := trim(FMaps.FieldDef.FieldDefault);
    if FMaps.IncludeField then
      delete(FFieldValue, 1, 3); // remove the [I] prefix from the value
  end;
end;

procedure TImportJob.CheckSysVal;
// checks if FFieldValue is equal to one of the %sysval% variables and replaces
// the contents if it is.
// This was specifically introduced so that Job Start Date on the Job Record
// will default to "today's" date.
begin
  if SameText(FFieldValue, '%sysdate%') then
    FFieldValue := FormatDateTime(FDateFormat, date)
  else
    if SameText(FFieldValue, '%sysuser%') then
      FFieldValue := BlowFishDecrypt(JobUserName);
end;

procedure TImportJob.CloneAutoInc(FromAutoInc, ToAutoInc: TAutoInc);
// Other than for a TrialImport, the Import will be performed twice: firstly,
// as a test, followed by the real import.
// The current state of the AutoInc counters must be restored in between each
// stage otherwise they will simply continue to increment.
// CloneAutoInc will be called twice: once with the original TAutoInc instance to be
// copied to a clone, then to copy it back again.
// If no AutoInc object was created then there's nothing to copy.
var
  i: integer;
begin
  if not assigned(FAutoInc) then exit;
  ToAutoInc.Clear;

  for i := 0 to MaxAutoIncs do begin
    ToAutoInc.AutoInc[i]  := FromAutoInc.AutoInc[i];
    if FromAutoInc.SetReset[i] <> '' then // SetReset property has side-effect we don't want to trigger unnecessarily
      ToAutoInc.SetReset[i] := FromAutoInc.SetReset[i];
  end;
end;

function TImportJob.CreateAutoInc: boolean;
// only create the TAutoInc instance if this is the first file of a job
// or we're not going to be using a carried-over instance from a previous file
// in this job.
begin
  result := false;
  if (FFileNo = 1) or (not FCarryOverAutoInc) then begin
    FAutoInc := TAutoInc.create;
    result := true;
  end;
end;

procedure TImportJob.CreateRecordMgr;
// Record Manager provides blank Exchequer records to be filled in and when
// TImportJob has finished filling in each record, decides whether the record
// should be cached in memory, written to the sort file or written directly to
// Exchequer.
begin
  FRecordMgr := TRecordMgr.Create;
  with FRecordMgr do begin
    SortReqd          := FSortRequired;
    ReadSortFile      := FReadSortFile;
    JobNo             := FJobNo;
    FileNo            := FFileNo;
    Poster            := FPoster; // pass through TPoster object from TImportJob
    NomCurrencyVarianceTolerance := FIONomCurrVarTolerance;
    IncDataErrorProc  := IncrementDataRecordError; //PR: 19/10/2012
  end;
end;

procedure TImportJob.DecodeDateFormat;
// split up FDateFormat into it's constituent parts, noting where each
// part starts. We're only interested in the digits, so in theory a date format can inlude
// any extraneous characters such as / etc. anywhere.
// This is used in isDateFormat to validate dates and convert them to standard Exchequer
// YYYYMMDD format.
var
  i: integer;
begin
   FDateFormat := LowerCase(FDateFormat);
   for i := 1 to length(FDateFormat) do begin // decode date format
     if FDateFormat[i] = 'd' then begin
      DD := DD + 'd';
      if length(DD) = 1 then PosDD := i;
     end else
     if FDateFormat[i] = 'm' then begin
       MM := MM + 'm';
       if length(MM) = 1 then PosMM := i;
     end else
     if FDateFormat[i] = 'y' then begin
       yy := yy + 'y';
       if length(YY) = 1 then PosYY := i;
     end;
   end;
end;

function TImportJob.EndOfFieldDefs: boolean;
// Signals that all the Field Defs for the current map have been cycled thru.
begin
  result := FMaps.EndOfFieldDefs;
end;

function TImportJob.EndOfFile: boolean;
// returns EOF condition for whichever file is being read: CSV or Import file
begin
  Result := False;
  case FImportFileType of
    ftUserDef:   result := FRecordNo > FImportFileRecordCount;
    ftStdImport: result := FRecordNo > FStdImportFile.RecordCount;
  end;
end;

function TImportJob.Execute: integer;
// returns zero if all records from the import file were imported into Exchequer with no issues
// otherwise it returns -1 and the SysMsg property or the file log contains more info.
// Detailed errors are reported in the LogFile, so the return code is ostensibly to allow
// the job to be listed in the Scheduler as having finished "with errors" to show that the log needs looking at.
begin
  result := -1;

  if Startup     <> 0 then exit;
  if InitLogFile <> 0 then exit;

  if ConfigureTheToolkit <> 0 then exit; // Transfer the user's job settings to the TImportToolkit object and open the DLL Toolkit
  if CheckLoginCredentials <> 0 then exit;
  if ImportToolkit.GetSystemSetup <> 0 then exit;

  if not FIOTrialImport then begin              // If the user doesn't want a Trial Import, make it look like something else...
//    LogEntry('', false);
    LogEntry('Pre-Import Data Check', false);   // hhmmm, I see.
    LogEntry('=====================', false);
    LogEntry('', false);
    LogEntry('Row   Field', false);
    LogEntry('===== =====', false);
  end;

  ImportToolkit.ToolkitConfiguration.tcTrialImport := true; // always do a trial import first, regardless
  CloneAutoInc(FAutoInc, FAutoIncCopy);          // Take a copy of the current state of the AutoInc counters;
  PostPhase1Message; // v.084
  if ImportTheFile < 0 then                      // go thru the motions
    FImportError := true;                        // not the same as FImportError := ImportTheFile < 0  !!

  //ABSEXCH-15722 Issue of Importer - Trial Import gives Transaction header error when using FH/FL Import Method.
  if (not FIOTrialImport) or (FImportError) then
  begin
    //PR: 01/08/2014 ABSEXCH-15471/ABSEXCH-14856 Need to clear cache file here, as it wasn't getting cleared when there was an error.
    FRecordMgr.ClearSortFile;                    // clear out the cached records from this file
    FRecordMgr.ClearTotals;                      // zero the cached and imported record counts
  end;

  if (not FIOTrialImport) and (not FImportError or FIOIgnoreImportErrors) then begin  // if no errors and user wants a proper import...
    LogEntry('', false);
    if not FImportError then
      LogEntry('There were no errors', false)  // how did the pre-import data check finish ?
    else begin
      LogEntry('Import Errors Ignored', false);
      FImportError := false; // could have been true if we're Ignoring Import Errors
    end;
    if not FReadSortFile then begin // else leave TRecordMgr.ProcessSortFile to write this to the log
      LogEntry('', false);
      if EnterpriseLicence.IsLITE then begin
        LogEntry('Importing into IRIS Accounts Office', false);
        LogEntry('===================================', false);
      end
      else begin
        LogEntry('Importing into Exchequer', false);
        LogEntry('========================', false);
      end;
    end;
    ImportToolkit.ToolkitConfiguration.tcTrialImport := false;
    FRecordNo := 0;                              // Start again from the first record of the import file
    CloneAutoInc(FAutoIncCopy, FAutoInc);        // Reset the original state of the AutoInc counters

    //PR: 01/08/2014 ABSEXCH-15471/ABSEXCH-14856 Moved ClearSortFile & ClearTotals above
//    FRecordMgr.ClearSortFile;                    // clear out the cached records from this file
//    FRecordMgr.ClearTotals;                      // zero the cached and imported record counts
    PostPhase2Message; // v.084
    if ImportTheFile < 0 then                    // Import into Exchequer.
      FImportError := true;                      // not the same as FImportError := ImportTheFile < 0  !!
    LogEntry('', false);
    if not FImportError then
      LogEntry('There were no errors', false)
  end;


  ImportToolkit.CloseImportToolkit;

  if StopLogFile <> 0 then exit;
  if Shutdown    <> 0 then exit;

  if FImportError then exit;                // has any function set the error flag during the entire import process ?
                                            // If so, the user needs to check the log for this file.
  result := 0;
end;

function TImportJob.FindMap(ARecordType: string): integer;
// Locates the FieldDef Map of the given RecordType or returns -1 if not found
begin
  Result := -1;
  if EndOfFile then exit;

  Result := FMaps.FindMap(ARecordType);
  if Result <> 0 then
    LogEntry(format('%.*d: Invalid record type "%s"', [LEN_REC_NO, FRecordNo, ARecordType]), true);
end;

function TImportJob.FirstFieldDef: integer;
// Set the internals of the FMaps object to be pointing to the first Field Def of the current map
// and reset our flags for reading the map.
begin

  Result := FMaps.FirstFieldDef;
  FFirstSType := true; // reset flags
  FFirstAType := true;
  FFirstFType := true;
end;

function TImportJob.FormattedAutoInc: string;
// format the value of the AutoInc field according to the maximum length of the target field's value
// Could have used %.*d and saved a line (and a local variable).
// result := format('%.*d', [FieldWidth(FMaps.FieldDef.FieldType, StrToInt(FMaps.FieldDef.FieldWidth)), FAutoInc[FMaps.AutoIncIx]]);
var
  FormatString: string;
begin
  FormatString := '%.' + IntToStr(FieldWidth(FMaps.FieldDef.FieldType, StrToInt(FMaps.FieldDef.FieldWidth))) + 'd';
  result := format(FormatString, [FAutoInc[FMaps.AutoIncIx]]);
end;

function TImportJob.FormattedCurInc: string;
// format the value of the AutoInc field according to the maximum length of the target field's value
// Could have used %.*d and saved a line but it's not as clear IMHO
// result := format('%.*d', [FieldWidth(FMaps.FieldDef.FieldType, StrToInt(FMaps.FieldDef.FieldWidth)), FAutoInc[FMaps.CurIncIx]]);
var
  FormatString: string;
begin
  FormatString := '%.' + IntToStr(FieldWidth(FMaps.FieldDef.FieldType, StrToInt(FMaps.FieldDef.FieldWidth))) + 'd';
  result := format(FormatString, [FAutoInc[FMaps.CurrIncIx]]);
end;

function TImportJob.IgnoreField: boolean;
// Is the field an "Ignored Field" ?
begin
  result := FMaps.IgnoreField;
end;

function TImportJob.ImportTheFile: integer;
// The main logic for importing a file.
// Reads a record, determines the correct field map to use and obtains a blank
// Exchequer record from TRecordMgr.
// Cycles thru each field def in the map getting the corresponding value from
// the import file and moving it to the output record.
// When all the fields from the input record have been moved to the output
// record, control of the output record is returned to TRecordMgr and TImportJob
// gets the next input record for processing.

   function DoGlobalRecordType: integer;
   // v.067 The user can supply the record type in the Job Settings instead of in the data file.
   // If they have, process the record type - the first true data value from the file then corresponds to the
   // next field def.
   begin
      result := 0;
      if FJobGlobalRecordType <> '' then begin
        FFieldValue     := FJobGlobalRecordType;
        FOrigFieldValue := FJobGlobalRecordType; // remember the record type in case it gets changed by CheckFieldDefault
        CheckFieldDefault; // effects OL and RL
        result          := OutputFieldValue;
        NextFieldDef;
      end;
   end;
begin
  result := 0;

  repeat
    FindMap(NextRecord);
  until ValidMap or EndOfFile;             // find the first record with a valid record type

  if (not ValidMap) and EndOfFile then
    LogEntry('File contains no valid Record Types', true);

  while ValidMap and not EndOfFile do begin
    FirstFieldDef;                         // get the definition of the first field in the import file record.
    FValidRecord := true;                  // until proved otherwise.
    if result < 0 then                     // v.074 correct bug from v.067
      DoGlobalRecordType                   // preserve the error return code // v.074 correct bug from v.067
    else
      result := DoGlobalRecordType;        // is the record type in the file or the job setting ?
    while not EndOfFieldDefs do begin
      NextFieldValue;                      // get the next field value from the import file's record(or an AutoInc value etc.)
      if not IgnoreField then begin        // if the map doesn't say we should ignore the field...
        CheckFieldDefault;                 // if it's blank or FIXED, replace it with the default value
        CheckSysVal;                       // Check if equal to a %sysval% variable and replace contents accordingly
        TranslateValue;                    // Check if there is a lookup translation table for this field
        if not (InFixedList and PassesVRule and ValidFieldValue) then // validate the field contents against it's map definition and any Validation Rule. Need to do the ValidateRule first coz FFieldValue gets altered for isDateFormat
          FValidRecord := false
        else
          if result < 0 then
            OutputFieldValue               // preserve the error return code
          else
            result := OutputFieldValue;    // Move the value to the output record
      end;
      NextFieldDef;                        // get the definition of the next field we're expecting
    end;
    if result < 0 then
      RecordDone                           // preserve the error return code
    else
      result := RecordDone;                // Finished building the Exchequer record.
    FindMap(NextRecord);                   // Get the next record from the import file.
    PostProgressMessage;
  end;

  if result < 0 then
    FRecordMgr.FlushRecords                // Flush the records but preserve the error return code from RecordDone
  else
    result := FRecordMgr.FlushRecords;     // no more records coming;
end;

function TImportJob.InFixedList: boolean;
// if the main settings file defines a fixed list of values for the field
// check that the current value is in the list otherwise reject the value.
var
  BlankOK: boolean;
  SettingType: TSettingType;
  ErrorMsg: string;
begin
  result := true;

  if FFieldValue = '' then begin  // don't apply the test to blank fields which are allowed to be blank
    BlankOK := SettingTF(IniFile.ReadString(trim(FMaps.FieldDef.FieldDesc), 'BlankOK', 'No'));
    if BlankOk then exit;
  end;

  SettingType := SettingTypeFromString(IniFile.ReadString(trim(FMaps.FieldDef.FieldDesc), 'Type', ''));
  if SettingType <> stFixedList then exit; // not a fixedlist field

  result := IniFile.ValueNameExists[trim(FMaps.FieldDef.FieldDesc), trim(FFieldValue)];  // compare FFieldValue against the list possible values

  if not result then begin
    ErrorMsg := 'is not in the list of permitted values';
    LogEntry(format('%.*d %s: "%s" %s',
          [LEN_REC_NO, FRecordNo, trim(string(FMaps.FieldDef.FieldDesc)), FFieldValue, ErrorMsg]), true);
  end;
end;

function TImportJob.InitLogFile: integer;
// The LOG_PROCFILE constant is searched for in ViewLogFile to determine which
// file the log file refers to.
// This is no longer an issue since the names of log files were changed to
// include the name of the file being imported.
var
  Entry: string;
begin
  result := -1;

  if FFileNo = 1 then
    Logger.LogEntry(0, '=====');
  Entry := format('Importer %s: Job %d File %d started at %s on %s', [APPVERSION, FJobNo, FFileNo, TimeToStr(time), DateToStr(date)]);
  LogEntry(Entry, false);
  Logger.LogEntry(0, format('Job %d File %d started at %s on %s', [FJobNo, FFileNo, TimeToStr(time), DateToStr(Date)]));
  FillChar(Entry[1], length(Entry), '=');
  LogEntry(Entry, false);
  Entry := format('Logged into company "%s" as "%s"', [JobExchequerCompany, BlowFishDecrypt(JobUserName)]);
  LogEntry(Entry, false);
  LogEntry('', false);
  Entry := format('%s %d: %s', [LOG_PROCFILE, FFileNo, FImportFileName]);
  LogEntry(Entry, false);
  LogEntry('', false);
  if FIOTrialImport then begin
    LogEntry('Trial Import Only - no records will be imported', false);
    Logger.LogEntry(0, 'Trial Import');
    LogEntry('', false);
  end;

  result := 0;
end;

function TImportJob.LogEntry(ALogEntry: string; AImportError: boolean): integer;
// March 29th 1912: food low, weather absolutely appalling. Just sending Oates out to post this now. Regards, RF Scott (Captain)
begin
  Result :=Logger.LogEntry(FFileNo, ALogEntry);
  if AImportError then
    FImportError := true; // n.b. Not the same as FImportError := AImportError.
end;

function TImportJob.NextFieldDef: integer;
// Change the internals of FMaps to point to the next Field Def in the current Field Map
begin

  Result := FMaps.NextFieldDef;
end;

function TImportJob.NextFieldValue: integer;
// Returns the next value from the input file. With a CSV file this is easy in that we simply get the next comma-delimited value
// in the record from TCSV. With a standard import file though, the number of characters we retrieve is dependant on the
// the utils.FieldWidth of the type of field defined in the Field Def.
// However, if the FieldDef is an [AutoInc] or a [CurrInc] field then the value doesn't appear in the import file at all
// and is generated automatically.
// Include Fields also don't appear in the import file. The field value will be set to the default value.
// If there are more Field Defs defined in the map than there are fields on the CSV record, TCSV will return "CSVERROR_".
// This is checked for in CheckDefaultReqd and replaced by the default value. This means the user can provide default
// values at the end of each map, without having to provide loads of blank values at the end of each record.
begin
  Result := 0;
  FFieldValue := '';
  if FImportFileType = ftUserDef then  // ... then "Include"-ed value won't be in the import files. All values are in ftStdImport files - if they're blank they'll default anyway so "include" fields are meaningless
    if FMaps.IncludeField then exit;   // The default value will be used instead in CheckFieldDefault

  if FMaps.AutoInc then begin        // side effect of accessing this property is for FMaps to determine which counter is specified in the default value
    NextAutoInc;                     // generate the next value of the AutoInc counter specified in the default value for this field
    FFieldValue := FormattedAutoInc; // format it to match the width of the field in the Exchequer record
  end
  else
    if FMaps.CurrInc then             // side effect of accessing this property is for FMaps to determine which counter is specified in the default value
      FFieldValue := FormattedCurInc // format it to match the width of the field in the Exchequer record
    else begin
      NextFieldNo;                   // not Include, AutoInc or CurrInc field so increment FieldNo and read from import file
      case FImportFileType of
        ftUserDef:   FFieldValue := trim(FCSVFile.FieldN(FFieldNo));
        ftStdImport: FFieldValue := trim(FStdImportFile.FieldValue(FMaps.StdOffset, FMaps.StdWidth));
      end;
    end;
end;

function TImportJob.NextAutoInc: integer;
// get the next value of the current AutoInc counter.
// The required counter is specified in the default value of the current Field Def
begin
  Result := FAutoInc.NextInc[FMaps.AutoIncIx];
end;

procedure TImportJob.NextFieldNo;
// increment the number of the field that we'll be retrieving next from the import file's current record
begin
  inc(FFieldNo);
end;

function TImportJob.NextRecord: string;
// Gets a record from one of two places:-
// 1. a CSV file, 2. a Std Import file, 3. N/A
// returns the record type;
// If the record type of the new record has a reset AutoInc registered, that counter will be reset to zero.
// When the record has been read, FFieldNo is set to zero. NextFieldValue will increment it to retrieve the first field
// which is always the Record Type.
// However, FindMap needs to know what the record type of this record is, as well as OutputFieldValue also needing to
// process the record type and move it to the Exchequer record.
// So, for CSV files, we retrieve the first field with FCSVFile.FieldN(1), then set FFieldNo to zero so that NextFieldValue re-reads it.
begin
  result := FJobGlobalRecordType; // will either be a 2-char record type or an empty string;
  case FImportFileType of
    ftUserDef:   begin
                   NextRecordNo; // increment the number of the record to be retrieved from the import file
                   if not EndOfFile then
                     if (FRecordNo = 1) and FHeaderRecordPresent then begin // read and ignore the first record in the CSV file
                       FHeaderRecordCount := 1; // report it in the log so the record numbers add up
                       FCSVFile.ReadRecord(FRecordNo); // read the header record
                       NextRecordNo;                   // start again properly with the first data record
                     end;
                   if not EndOfFile then begin
                     FCSVFile.ReadRecord(FRecordNo); // read the required record from the import file
                     if result = '' then // v.067 no GlobalRecordType has been set so get RT from file
                       result := FCSVFile.FieldN(1); // returns the Record Type
                     FFieldNo := 0; // reset the FieldNo. NextFieldValue increments it before getting the first field
                   end;
                 end;
    ftStdImport: begin
                   NextRecordNo; // increment the number of the record to be retrieved from the import file
                   if not EndofFile then begin
                     if result = '' then // v.067 no GlobalRecordType has been set so get RT from file
                       result := FStdImportFile.ReadRecord(FRecordNo); // returns the Record Type
                     FFieldNo := 0; // reset the FieldNo. NextFieldValue increments it before getting the first field
                   end;
                 end;
  end;
  FAutoInc.Reset(result); // reset any AutoInc counters registered against this Record Type
end;

procedure TImportJob.NextRecordNo;
begin
  inc(FRecordNo);
end;

function TImportJob.CheckLoginCredentials: integer;
begin
  result := -1;

  with ImportToolkit do begin
    itExchequerCompany := FExchequerCompany; // must be the first thing we do
    if not itToolkitOpen then begin
      result := -2;
      Logger.LogEntry(FFileNo, format('%.*d: [%d] %s', [LEN_REC_NO, FRecordNo, result, 'Cannot open Toolkit']));
      exit;
    end;
    if CheckLogin(BlowFishDecrypt(FUserName), BlowFishDecrypt(FPassword)) <> 0 then begin
      result := -3;
      Logger.LogEntry(FFileNo, format('%.*d: [%d] %s', [LEN_REC_NO, FRecordNo, result, 'Invalid UserName or Password']));
      exit;
    end;
  end;

  result := 0;
end;

function TImportJob.OutputFieldValue: integer;
// The type of Field Def determines where the Field Value goes:-
// The first S-type field in a map has to be the record type of the incoming
// record. The default field should override this to the type of Exchequer
// record being built. Get a blank record from TRecordMgr into which we will
// move the F-type field values.
// If we've got AutoGen fields we need another blank Exchequer record from
// TRecordMgr into which to move the A-type field values (e.g. one-line transactions).
// Convert the value into its proper data type and copy it to the correct offset
// in the output record.
// N.B.....
// 1. The Field Defs in a MAP are always in S-Type, A-Type, F-Type sequence.
// 2. Toast always lands butter-side down.
begin
  result := 0;
  case FMaps.FieldDef.FieldDefType of
  'S':  begin
          if FFirstSType then begin
            FFirstSType := false;
            FRecordMgr.NewRecord(trim(FMaps.FieldDef.FieldDefault), FOrigFieldValue); // get a blank record to move the F-type fields into at 'F': below // v.061
            FRecordMgr.RecordNo := FRecordNo; // Set the source record no.
          end;
          FRecordMgr.AddKey(FFieldValue,
                            FMaps.FieldDef.FieldType,
                            StrToInt(FMaps.FieldDef.FieldWidth),
                            FMaps.FieldDef.FieldUsage);
        end;

  'A':  begin
          if FFirstAType then begin
            FFirstAType := false; // also tells 'F': below that we've been building an AutoGen record
            FRecordMgr.NewRecord(FMaps.FieldDef.RecordType, FOrigFieldValue); // get a blank record to move the A-type fields into // v.061
            FRecordMgr.CopyPreviousKeys; // e.g. AutoGen-ed TH records need a copy of LinkRef from the TL records - currently only affects OL and RL record types
          end;                       // TRecordMgr's current record won't be the same one allocated at 'S': above
          {* no need to set the source record no. here as it is the same as at 'S': so is already set. *}
          ConvertData(FFieldValue, FMaps.FieldDef.FieldType,
                      StrToInt(FMaps.FieldDef.FieldWidth),
                      StrToInt(FMaps.FieldDef.Offset), FRecordMgr.CurrentRecord^);
        end;

  'F':  begin
          if FFirstFType then begin
            FFirstFType := false;
            if not FFirstAType then // we must have been building an AutoGen record
              result := FRecordMgr.RecordDone(FValidRecord); // if we've been building a record from A-Type fields then we're finished now
          end;                     // TRecordMgr's Current Record will revert to the one allocated at 'S': above
          ConvertData(FFieldValue, FMaps.FieldDef.FieldType,
                      StrToInt(FMaps.FieldDef.FieldWidth),
                      StrToInt(FMaps.FieldDef.Offset), FRecordMgr.CurrentRecord^);
        end;
  end;
end;

function TImportJob.PassesVRule: boolean;
// If a validation rule has been defined for this field it will be in an
// ini section named the same as the field description.
type
  TVRule = (vrSalesDecimals, vrCostDecimals, vrQtyDecimals, vrDateFormat);
const
  VRules: array[0..3] of string = ('ssSalesDecimals', 'ssCostDecimals', 'ssQtyDecimals', 'isDateFormat');
var
  VRule: byte;
  ValidationRule: string;
  DPs: integer;
  ErrorMsg: string;
  s: string;
  BlankOK: boolean;

  function  VRuleFromString(AVRule: string): byte;
  var
    i: integer;
  begin
    result := 255;
    for i := low(VRules) to high(VRules) do
      if VRules[i] = AVRule then begin result := i; break; end;
  end;

  function  DPCount: integer;
  // returns the number of decimal places in a number.
  var i: integer;
  begin
    result := 0;
    i := 1;
    while (i <= length(FFieldValue)) and (FFieldValue[i] <> '.') do inc(i); // find decimal point
    inc(i);                                                                 // skip decimal point
    while (i <= length(FFieldValue)) do begin inc(result); inc(i); end;     // count digits after decimal point
    if result <> 1 then s := 's';                                           // pluralise "place"
  end;

  function  ssSalesDecimals: boolean; // System Setup Sales Decimals
  begin
    DPs    := DPCount;
    result := DPs <= ImportToolkit.itSalesPriceDPs;
    if not result then ErrorMsg := format('Contains %d decimal place%s - System Setup allows %d', [DPs, s, ImportToolkit.itSalesPriceDPs]);
  end;

  function  ssCostDecimals: boolean;  // System Setup Cost Decimals
  begin
    DPs    := DPCount;
    result := DPs <= ImportToolkit.itCostPriceDPs;
    if not result then ErrorMsg := format('Contains %d decimal place%s - System Setup allows %d', [DPs, s, ImportToolkit.itCostPriceDPs]);
  end;

  function  ssQtyDecimals: boolean; // System Setup Qty Decimals
  begin
    DPs    := DPCount;
    result := DPs <= ImportToolkit.itQtyDPs;
    if not result then ErrorMsg := format('Contains %d decimal place%s - System Setup allows %d', [DPs, s, ImportToolkit.itQtyDPs]);
  end;

  function  isDateFormat: boolean; // Import Settings Date Format
  var
    i: integer;
    Day, Month, Year: word;
    YYMMDD: TDateTime;
  begin
    result := false;
    ErrorMsg := format('Date does not match Import Setting Date Format %s', [FDateFormat]);
    if length(FFieldValue) <> length(FDateFormat) then exit;

    try
      Year  := StrToInt(copy(FFieldValue, PosYY, length(YY))); // check if parts constitute a valid date.
      if length(YY) = 2 then
        if Year < 50 then Year := 2000 + year else Year := 1900 + year;
      Month := StrToInt(copy(FFieldValue, PosMM, length(MM)));
      Day   := StrToInt(copy(FFieldValue, PosDD, length(DD)));
      if not TryEncodeDate(Year, Month, Day, YYMMDD) then exit;
    except
      exit; // any problems, report an invalid date format
    end;

    FFieldValue := FormatDateTime('YYYYMMDD', YYMMDD); // reformat into Exchequer format
    result := true;
    ErrorMsg := '';
  end;

begin
  result := true;

  if FFieldValue = '' then begin  // don't apply validation rules to blank fields which are allowed to be blank
    BlankOK := SettingTF(IniFile.ReadString(trim(FMaps.FieldDef.FieldDesc), 'BlankOK', 'No'));
    if BlankOk then exit;
  end;

  ValidationRule := IniFile.ReadString(trim(FMaps.FieldDef.FieldDesc), 'VRule', '');
  if ValidationRule = '' then exit; // no validation rule defined

  VRule := VRuleFromString(ValidationRule);

  case TVRule(VRule) of
    vrSalesDecimals: result := ssSalesDecimals;
    vrCostDecimals:  result := ssCostDecimals;
    vrQtyDecimals:   result := ssQtyDecimals;
    vrDateFormat:    result := isDateFormat;
  else begin
    result := false;  // there is a validation rule but it's not recognised so reject the field
    ErrorMsg := 'Unknown Validation Rule "' + ValidationRule + '"';
  end;
  end;

{* e.g. 12345, EEC Member: "x" is not a valid True/False value *}
  if not result then
    LogEntry(format('%.*d %s: "%s" %s',
          [LEN_REC_NO, FRecordNo, trim(string(FMaps.FieldDef.FieldDesc)), FFieldValue, ErrorMsg]), true);
end;

procedure TImportJob.PostPhase1Message; // v.084
begin
  if assigned(FPoster) then
    FPoster.PostMSg(WM_IMPORTJOB_PHASE1, 0, 0);
end;

procedure TImportJob.PostPhase2Message; // v.084
begin
  if assigned(FPoster) then
    FPoster.PostMSg(WM_IMPORTJOB_PHASE2, 0, 0);
end;

procedure TImportJob.PostProgressMessage;
begin
  if assigned(FPoster) then
    FPoster.PostMSg(WM_IMPORTJOB_PROGRESS, FImportFileRecordCount, FRecordNo);
end;

function TImportJob.RecordDone: integer;
// Finished building an Exchequer record -  Leave TRecordMgr to decide what to do with it.
// If the record contains an invalid field, TRecordMgr will just release the record without
// outputting it to Exchequer or the Sort File.
begin
  if not FValidRecord then begin
    inc(FErrorRecordCount);
    FImportError := true;
  end;

  result := FRecordMgr.RecordDone(FValidRecord);

  if result < 0 then
    FImportError := true;
end;

function TImportJob.Shutdown: integer;
begin
  result := 0;

  //PR: 19/12/2016 ABSEXCH-17856 Try to log any problem closing the csv file.
  case ImportFileType of
    ftUserDef  :
                  Try
                    FreeAndNil(FCSVFile);
                  Except
                    on E:Exception do
                    begin
                      LogEntry('Exception closing CSV File: ' + QuotedStr(E.Message), True);
                      Logger.LogEntry(0, 'Exception closing CSV File: ' + QuotedStr(E.Message));
                      raise;
                    end;
                  End;

    ftStdImport: FreeObjects([FStdImportFile]);
  end;

  if (not FImportError) and (not ImportToolkit.ToolkitConfiguration.tcTrialImport)        // v.066
                        and FArchiveImportedFiles and (ArchiveImportFile <> 0) then
    result := -1;

{The Log File isn't left open at the end of a job which caches all it's records
 which is what I originally had in mind. Error messages for import records read
 in prior import jobs will be reported in the log file of the job which eventually reads the sort file.}
  if FReadSortFile then // TRecordMgr will have processed the sort file and
    Logger.CloseLogs    // has no further use for the log files. Any errors
                        // after this point need to be displayed to the user.
  else
//    if not FSortRequired then
      Logger.CloseLog(FFileNo); // otherwise leave it open for the ImportJob that eventually processes the sort file - NO !!

  FreeObjects([FMaps, FRecordMgr, FAutoIncCopy]); // off they go....

  if not FCarryOverAutoInc then // not carrying over counter values to the next job
    FreeObjects([FAutoInc]); // otherwise leave TJobQueue to do it
end;

function TImportJob.Startup: integer;
begin
  result := -1;
  FStartTime := GetTickCount;

  if Logger.NewLog(FFileNo, FLogFileName) <> 0 then exit;

  case ImportFileType of
    ftUserDef:    FCSVFile       := TCSV.create(ImportFileName, false);
    ftStdImport:  FStdImportFile := TStdImpFile.create(ImportFileName);
  end;

  FAutoIncCopy := TAutoInc.create;

  FRecordNo := 0;

  CreateRecordMgr;

  DecodeDateFormat;

  result := 0 ;
end;

function TImportJob.StopLogFile: integer;
var
  Entry: string;
  s, s2, s3, s4, s5, s6, s7, s8, s9: string;
//  StopTime: cardinal;
  ElapsedTime: cardinal;
  ElapsedMins: cardinal;
  ElapsedSecs: cardinal;

      function YesNo(AYesNo: boolean): string;
      begin
        if AYesNo then result := 'Yes' else result := 'No';
      end;
begin
  result := -1;

  if FRecordNo - 1                    <> 1 then s  := 's'; // make the word "record" plural for "0 records" and "> 1 records"
  if FErrorRecordCount                <> 1 then s3 := 's';
  if FRecordMgr.CachedRecordCount     <> 1 then s4 := 's';
  if FRecordMgr.ImportedRecordCount   <> 1 then s5 := 's';
  if FHeaderRecordCount               <> 1 then s6 := 's';
  if FRecordMgr.ErrorRecordCount      <> 1 then s7 := 's';
  if FRecordMgr.THCount               <> 1 then s8 := 's'; // no. of auto-generated TH records (for RL and OL record types).
  if FRecordMgr.CurrencyVarianceCount <> 1 then s9 := 's';

  if FRecordMgr.ImportedRecordCount <> 0 then
    if (not FIOTrialImport) and ImportToolkit.ToolkitConfiguration.tcTrialImport then
//      s2 := ' - Pre-Import Data Check only, no records were actually imported'
//    else
//      if FIOTrialImport and (FRecordMgr.ImportedRecordCount > 0) then s2 := ' - Trial Import only, no records were actually imported';
      s2 := 'ready to be '
    else
      if FIOTrialImport and (FRecordMgr.ImportedRecordCount > 0) then s2 := 'ready to be ';

  LogEntry('', false);
  LogEntry('Summary', false);
  LogEntry('=======', false);
  LogEntry(format('%5d record%s read from import file', [FRecordNo - 1, s]), false);
  LogEntry(format('%5d header record%s skipped', [FHeaderRecordCount, s6]), false);
  if FRecordMgr.THCount > 0 then               // not yet implemented so always zero
    LogEntry(format('%5d transaction header%s created', [FRecordMgr.THCount, s8]), false);
  if FRecordMgr.CurrencyVarianceCount > 0 then                      // not yet implemented so always zero
    LogEntry(format('%5d currency variance transaction line%s created', [FRecordMgr.CurrencyVarianceCount, s9]), false);
  LogEntry(format('%5d record%s had data errors', [FErrorRecordCount, s3]), false);
  LogEntry(format('%5d record%s cached', [FRecordMgr.CachedRecordCount, s4]), false);
  LogEntry('', false);
  LogEntry(format('%5d record%s had import errors', [FRecordMgr.ErrorRecordCount, s7]), false);
  LogEntry(format('%5d record%s %simported', [FRecordMgr.ImportedRecordCount, s5, s2]), false);
  LogEntry('', false);
  Entry := format('Importer: Job %d File %d finished at %s on %s', [FJobNo, FFileNo, TimeToStr(time), DateToStr(date)]);
  LogEntry(Entry, false);
  FillChar(Entry[1], length(Entry), '=');
  LogEntry(Entry, false);

  Logger.LogEntry(0, format('Cached   %5d record%s', [FRecordMgr.CachedRecordCount, s4]));
  Logger.LogEntry(0, format('Imported %5d record%s', [FRecordMgr.ImportedRecordCount, s5]));
  Logger.LogEntry(0, format('Job %d File %d finished at %s on %s', [FJobNo, FFileNo, TimeToStr(Time), DateToStr(Date)]));
  if FImportError or SysMsgSet then begin
    LogEntry('There were errors', false);
    Logger.LogEntry(0, 'There were errors');
  end
  else begin
    LogEntry('There were no errors', false);
    Logger.LogEntry(0, 'There were no errors');
  end;
  Logger.LogEntry(0, '');

  LogEntry('', false);
  LogEntry('', false);
  LogEntry('Job Settings', false);
  LogEntry('============', false);
  LogEntry('Archive Folder                     = ' + FArchiveFolder, false);
  LogEntry('Achive Imported Files              = ' + YesNo(FArchiveImportedFiles), false);
  LogEntry('Carry Over AutoInc                 = ' + YesNo(FCarryOverAutoInc), false);
  LogEntry('Header Record Present              = ' + YesNo(FHeaderRecordPresent), false);
  LogEntry('Read Record Cache                  = ' + YesNo(FReadSortFile), false);
  LogEntry('', false);
  LogEntry('Import Settings', false);
  LogEntry('===============', false);
  LogEntry('Allow Transaction Editing          = ' + YesNo(FIOAllowTransactionEditing), false);
  LogEntry('AutoSet Currency Rates             = ' + YesNo(FIOAutoSetCurrencyRates), false);
  LogEntry('AutoSet Period                     = ' + YesNo(FIOAutoSetPeriod), false);
  LogEntry('AutoSet Stock Cost                 = ' + YesNo(FIOAutoSetStockCost), false);
  LogEntry('AutoSet Trans Header Line Count    = ' + YesNo(FIOAutoSetTHLineCount), false);
  LogEntry('AutoSet Trans Line No              = ' + YesNo(FIOAutoSetTLLineNo), false);
  LogEntry('AutoSet Trans Line Ref from Header = ' + YesNo(FIOAutoSetTLRefFromTH), false);
  LogEntry('AutoSet Trans Ref                  = ' + YesNo(FIOAutoSetTHOurRef), false);
  LogEntry('Calc Trans Header Totals           = ' + YesNo(FIOCalcTHTotals), false);
  LogEntry('Date Format                        = ' + FDateFormat, false);
  LogEntry('Deduct BOM Stock                   = ' + YesNo(FIODeductBOMStock), false);
  LogEntry('Deduct Multi Location Stock        = ' + YesNo(FIODeductMultiLocationStock), false);
  LogEntry('Default Cost Centre                = ' + FIODefaultCostCentre, false);
  LogEntry('Default Currency                   = ' + FIODefaultCurrency, false);
  LogEntry('Default Department                 = ' + FIODefaultDepartment, false);
  LogEntry('Default Nominal Code               = ' + FIODefaultNominalCode, false);
  LogEntry('Default VAT Code                   = ' + FIODefaultVATCode, false);
  LogEntry('Ignore Import Errors               = ' + YesNo(FIOIgnoreImportErrors), false);
  LogEntry('Nom Currency Variance Tolerance    = ' + FIONomCurrVarTolerance, false);
  LogEntry('Overwrite Notepad                  = ' + YesNo(FIOOverwriteNotepad), false);
  LogEntry('Trial Import                       = ' + YesNo(FIOTrialImport), false);
  LogEntry('Truncate Long Values               = ' + YesNo(FIOTruncateLongValues), false);
  LogEntry('Update Account Balances            = ' + YesNo(FIOUpdateAccountBalances), false);
  LogEntry('Update Stock Levels                = ' + YesNo(FIOUpdateStockLevels), false);
  LogEntry('Validate Job Costing Fields        = ' + YesNo(FIOValidateJobCostingFields), false);

  if ShowTime then begin // only included if /showtime option is on the command line
    LogEntry('', false);

{* The following statement seems to cure the eratic behaviour of GetTickCount when dealing with sub-1 second jobs *}
{* GetTickCount sometimes returns a lower count than the previous call in TImportToolkitU.StopTimer. *}
{* This results in the log reporting that, e.g., the job ran for 800ms of which 842ms were spent calling the toolkit ! *}
{* See Google Groups for more details *}
    sleep(250);

//   StopTime    := GetTickCount;
//   ElapsedTime := StopTime - FStartTime;
    ElapsedTime := GetTickCount - FStartTime;
    ElapsedMins := (ElapsedTime div 1000) div 60;
    ElapsedSecs := (ElapsedTime - (ElapsedMins * 60 * 1000)) div 1000;
    LogEntry(format('Elapsed Time: %10dms = %3.2dm%.2ds', [ElapsedTime, ElapsedMins, ElapsedSecs]), false);

    ElapsedTime := ImportToolkit.itElapsedTime;
    ElapsedMins := (ElapsedTime div 1000) div 60;
    ElapsedSecs := (ElapsedTime - (ElapsedMins * 60 * 1000)) div 1000;
    LogEntry(format('Toolkit Time: %10dms = %3.2dm%.2ds', [ElapsedTime, ElapsedMins, ElapsedSecs]), false);
  end;

  result := 0;
end;

procedure TImportJob.TranslateValue;
// Check the settings file to see if there is a translation table for this field
// and whether there is a translation value for the current value.
// Replacement values beginning with '#' are assumed to prefix an ascii character code.
var
  XLateVal: string;
  AsciiChar: char;
begin
  XLateVal := IniFile.ReadString('XLATE ' + trim(FMaps.FieldDef.FieldDesc), FFieldValue, '');
  if XLateVal = '' then exit;
  FFieldValue := XLateVal;
  if length(XLateVal) = 1 then exit;
  if XLateVal[1] = '#' then begin
    AsciiChar := chr(StrToInt(copy(XLateVal, 2, length(XLateVal) - 1)));
    FFieldValue := AsciiChar;
  end;
end;

function TImportJob.ValidFieldValue: boolean;
// checks that the contents of the field read from the import file are consistent
// with the data type defined for that field in the field map.
var
  ErrorMsg: string;
  allowed: integer;
  diff: integer;
  s: string;
  PreTrunc: string;
  MinSet, MaxSet: boolean;
  Min, Max: LongInt;
  sMin, sMax: string;

  function OnlyDecimal: boolean;
  // valid values can start with + or - or . and then contain only digits.
  // only one decimal point allowed
  var
    i: integer;
    DotCount: integer;
  begin
    result   := false;
    ErrorMsg :=  'is not a valid decimal value';
    if length(FFieldValue) = 0 then exit;
    DotCount := 0;
    for i := 1 to length(FFieldValue) do begin
      if (i = 1) and not (FFieldValue[1] in ['.', '+', '-', '0'..'9']) then exit;
      if (i > 1) and not (FFieldValue[i] in ['.', '0'..'9']) then exit;
      if FFieldValue[i] = '.' then inc(DotCount);
      if DotCount > 1 then exit;
    end;
    try StrToFloat(FFieldValue); except on EConvertError do exit; end;
    result := true;
  end;

  function OnlyInteger(MinValue: LongInt; MaxValue: LongInt): boolean;
  // valid values can start with + or - and then contain only digits
  var
    i: integer;
    NumericValue: LongInt;
  begin
    result   := false;
    ErrorMsg :=  format('is not a valid integer value between %d and %d', [MinValue, MaxValue]);
    if length(FFieldValue) = 0 then exit;
    for i := 1 to length(FFieldValue) do begin
      if (i = 1) and not (FFieldValue[1] in ['+', '-', '0'..'9']) then exit;
      if (i > 1) and not (FFieldValue[i] in ['0'..'9']) then exit;
    end;
    try NumericValue := StrToInt(FFieldValue); except on EConvertError do exit; end;
    if (NumericValue < MinValue) or (NumericValue > MaxValue) then exit;
    result := true;
  end;

  function OnlyTF: boolean;
  // Boolean fields can only contain the following representations of TRUE and FALSE.
  // If the field passes the validation then we don't need the original value any more
  // for error reporting so we can change it to '1' for true or '0' for false.
  begin
    result   := false;
    ErrorMsg := 'is not a valid True/False value';
    if length(FFieldValue) = 0 then exit;
    result := FFieldValue[1] in ['1', '0', 't', 'f', 'T', 'F', 'y', 'n', 'Y', 'N'];
    if result then
      if FFieldValue[1] in ['t', 'T', 'y', 'Y'] then
        FFieldValue := '1'
      else
        if FFieldValue[1] in ['f', 'F', 'n', 'N'] then
          FFieldValue := '0';
  end;

  function OnlyDigits(MinValue: integer; MaxValue: integer): boolean;
  // valid values can only contain digits
  var
    i: integer;
    NumericValue: integer;
  begin
    result := false;
    ErrorMsg :=  format('should only contain digits with values between %d and %d', [MinValue, MaxValue]);
    if length(FFieldValue) = 0 then exit;
    for i := 1 to length(FFieldValue) do begin
      if not (FFieldValue[i] in ['0'..'9']) then exit;
    end;
    try NumericValue := StrToInt(FFieldValue); except on EConvertError do exit; end;
    if (NumericValue < MinValue) or (NumericValue > MaxValue) then exit;
    result := true;
  end;

begin
  result := false;
  Min := 0;
  Max := 0;

{* Set the default Min and Max for the data type *}
  case FMaps.FieldDef.FieldType of
    'S':  begin end;
    'D':  begin end;
    'I':  begin Min := -32767; Max := 32768; end;
    'C':  begin end;
    'W':  begin end;
    'L':  begin Min := -2147483648; Max := 2147483647; end;
    'B':  begin Min := 0; Max := 255; end;
    'b':  begin end;
  else
    ErrorMsg := format('Invalid Field Type "%s" in map', [FMaps.FieldDef.FieldType]);
  end;

{* Override Min and/or Max if set for this field in the main settings file *}
  sMin := IniFile.ReadString(trim(FMaps.FieldDef.FieldDesc), 'Min', 'NO');
  sMax := IniFile.ReadString(trim(FMaps.FieldDef.FieldDesc), 'Max', 'NO');
  MinSet := sMin <> 'NO';
  MaxSet := sMax <> 'NO';
  if MinSet then
    Min := StrToInt(sMin);
  if MaxSet then
    Max := StrToInt(sMax);

  case FMaps.FieldDef.FieldType of
    'S':  result := (length(FFieldValue) <= FieldWidth(FMaps.FieldDef.FieldType, StrToInt(FMaps.FieldDef.FieldWidth)));
    'D':  result := OnlyDecimal;
    'I':  result := OnlyInteger(Min, Max);
    'C':  result := (length(FFieldValue) <= FieldWidth(FMaps.FieldDef.FieldType, StrToInt(FMaps.FieldDef.FieldWidth)));
    'W':  result := OnlyTF;
    'L':  result := OnlyInteger(Min, Max);
    'B':  result := OnlyDigits(Min, Max);
    'b':  result := OnlyTF;
  else
    ErrorMsg := format('Invalid Field Type "%s" in map', [FMaps.FieldDef.FieldType]);
  end;

  if not result then begin
    case FMaps.FieldDef.FieldType of
      'S', 'C':  begin
                   if IOTruncateLongValues then begin // field value is too long but ok to truncate it
                     PreTrunc := FFieldValue;
                     FFieldValue := copy(FFieldValue, 1, FieldWidth(FMaps.FieldDef.FieldType, StrToInt(FMaps.FieldDef.FieldWidth)));
                     LogEntry(format('%.*d Truncated %s: "%s" %s',
                       [LEN_REC_NO, FRecordNo, trim(string(FMaps.FieldDef.FieldDesc)), FFieldValue, 'from "' + PreTrunc + '"']), false);
                     result := true;
                     exit;
                   end
                   else begin
                     allowed := FieldWidth(FMaps.FieldDef.FieldType, StrToInt(FMaps.FieldDef.FieldWidth));
                     diff := length(FFieldValue) - allowed;
                     if diff <> 1 then s := 's';
                     ErrorMsg := format('contains %d more character%s than the %d allowed', [diff, s, allowed]);
                   end;
                 end;
    end;
{* e.g. 12345, EEC Member: "x" is not a valid True/False value *}
    LogEntry(format('%.*d %s: "%s" %s',
          [LEN_REC_NO, FRecordNo, trim(string(FMaps.FieldDef.FieldDesc)), FFieldValue, ErrorMsg]), true);

    FValidRecord := false;
    FImportError := true;
  end;
end;

function TImportJob.ValidMap: boolean;
begin
  result := FMaps.ValidMap;
end;

{* Getters and Setters *}

procedure TImportJob.SetArchiveFolder(const Value: string);
begin
  FArchiveFolder := Value;
end;

procedure TImportJob.SetExchequerCompany(const Value: string);
begin
  FExchequerCompany := Value;
end;

procedure TImportJob.SetImportFileType(const Value: TImportFileType);
begin
  FImportFileType := Value;
  FMaps.ImportFileType := Value;
end;

procedure TImportJob.SetHeaderRecordPresent(const Value: boolean);
begin
  FHeaderRecordPresent := Value;
end;

procedure TImportJob.SetImportFileName(const Value: string);
begin
  FImportFileName := Value;
end;

procedure TImportJob.SetJobDescription(const Value: string);
begin
  FJobDescription := Value;
end;

procedure TImportJob.SetLogFileName(const Value: string);
begin
  FLogFileName := Value;
end;

procedure TImportJob.SetSortRequired(const Value: boolean);
begin
  FSortRequired := Value;
end;

procedure TImportJob.SetImportFileRecordCount(const Value: integer);
begin
  FImportFileRecordCount := Value;
end;

procedure TImportJob.SetAutoInc(const Value: TAutoInc);
begin
  FAutoInc := Value;
end;

procedure TImportJob.SetReadSortFile(const Value: boolean);
begin
  FReadSortFile := Value;
end;

procedure TImportJob.SetJobNo(const Value: integer);
begin
  FJobNo := Value;
end;

procedure TImportJob.SetFileNo(const Value: integer);
begin
  FFileNo := Value;
end;

procedure TImportJob.SetArchiveImportedFiles(const Value: boolean);
begin
  FArchiveImportedFiles := Value;
end;

procedure TImportJob.SetIOCalcTHTotals(const Value: boolean);
begin
  FIOCalcTHTotals := Value;
end;

procedure TImportJob.SetIOAutoSetTHOurRef(const Value: boolean);
begin
  FIOAutoSetTHOurRef := Value;
end;

procedure TImportJob.SetIOAutoSetTHLineCount(const Value: boolean);
begin
  FIOAutoSetTHLineCount := Value;
end;

procedure TImportJob.SetIOAutoSetTLLineNo(const Value: boolean);
begin
  FIOAutoSetTLLineNo := Value;
end;

procedure TImportJob.SetIOAutoSetTLRefFromTH(const Value: boolean);
begin
  FIOAutoSetTLRefFromTH := Value;
end;

procedure TImportJob.SetIOTrialImport(const Value: boolean);
begin
  FIOTrialImport := Value;
end;

function TImportJob.GetSysMsg: string;
begin
  result := TErrors.SysMsg;
end;

function TImportJob.GetSysMsgSet: boolean;
begin
  result := TErrors.SysMsgSet;
end;

procedure TImportJob.SetSysMsg(const Value: string);
begin
  TErrors.SetSysMsg(Value);
end;

procedure TImportJob.SetIOTruncateLongValues(const Value: boolean);
begin
  FIOTruncateLongValues := Value;
end;

procedure TImportJob.SetJobFile(const Value: string);
begin
  FJobFile := Value;
end;

procedure TImportJob.SetPassword(const Value: string);
begin
  FPassword := Value;
end;

procedure TImportJob.SetUserName(const Value: string);
begin
  FUserName := Value;
end;

procedure TImportJob.SetCarryOverAutoInc(const Value: boolean);
begin
  FCarryOverAutoInc := Value;
end;

procedure TImportJob.SetPoster(const Value: TPoster);
begin
  FPoster := Value;
end;

procedure TImportJob.SetIOAutoSetPeriod(const Value: boolean);
begin
  FIOAutoSetPeriod := Value;
end;

function TImportJob.ConfigureTheToolkit: integer;
// Setup the TToolkitConfiguration object's properties.
// Later, the actual Toolkit will be configured from these properties
begin
  with ImportToolkit do begin
    itUserName         := JobUserName;
    itPassword         := JobPassword;
    itExchequerCompany := JobExchequerCompany;
  end;

  with ImportToolkit.ToolkitConfiguration do begin
    tcAllowTransactionEditing  := IOAllowTransactionEditing;
    tcAutoSetCurrencyRates     := IOAutoSetCurrencyRates;
    tcAutoSetTHLineCount       := IOAutoSetTHLineCount;
    tcAutoSetTHOurRef          := IOAutoSetTHOurRef;
    tcAutoSetTLLineNo          := IOAutoSetTLLineNo;
    tcAutoSetTLRefFromTH       := IOAutoSetTLRefFromTH;
    tcAutoSetPeriod            := IOAutoSetPeriod;
    tcAutoSetStockCost         := IOAutoSetStockCost;
    tcCalcTHTotals             := IOCalcTHTotals;
    tcDeductBOMStock           := IODeductBOMStock;
    tcDeductMultiLocationStock := IODeductMultiLocationStock;
    tcDefaultCostCentre        := IODefaultCostCentre;
    tcDefaultCurrency          := 0;
    if IODefaultCurrency <> '' then // blank equates to 0
      tcDefaultCurrency        := StrToInt(IODefaultCurrency); // TEditBox ensures that this only contains digits
    tcDefaultDepartment        := IODefaultDepartment;
    tcDefaultNominalCode       := 0;
    if IODefaultNominalCode <> '' then  // blank equates to 00000
      tcDefaultNominalCode       := StrToInt(IODefaultNominalCode); // TEditBox ensures that this only contains digits
    tcDefaultVATCode           := IODefaultVATCode;
    tcTrialImport              := IOTrialImport;
    tcUpdateAccountBalances    := IOUpdateAccountBalances;
    tcUpdateStockLevels        := IOUpdateStockLevels;
    tcOverwriteNotepad         := IOOverwriteNotepad;
    tcValidateJobCostingFields := IOValidateJobCostingFields;
    tcUseJobBudgets            := IOUseJobBudgets;

    tcApplyVBD                 := IOApplyVBD;
    tcApplyMBD                 := IOApplyMBD;
    tcOverwriteDiscountDates   := IOOverwriteDiscountDates;
  end;

  result := ImportToolkit.ConfigureTheToolkit; // configures and OPENS the Toolkit

  if result <> 0 then
    LogEntry(format('Unable to Configure the Toolkit [%d] ', [result]), true);
end;

procedure TImportJob.SetIOAllowTransactionEditing(const Value: boolean);
begin
  FIOAllowTransactionEditing := Value;
end;

procedure TImportJob.SetIOAutoSetCurrencyRates(const Value: boolean);
begin
  FIOAutoSetCurrencyRates := Value;
end;

procedure TImportJob.SetIOAutoSetStockCost(const Value: boolean);
begin
  FIOAutoSetStockCost := Value;
end;

procedure TImportJob.SetIODeductBOMStock(const Value: boolean);
begin
  FIODeductBOMStock := Value;
end;

procedure TImportJob.SetIODeductMultiLocationStock(const Value: boolean);
begin
  FIODeductMultiLocationStock := Value;
end;

procedure TImportJob.SetIODefaultCostCentre(const Value: string);
begin
  FIODefaultCostCentre := Value;
end;

procedure TImportJob.SetIODefaultCurrency(const Value: string);
begin
  FIODefaultCurrency := Value;
end;

procedure TImportJob.SetIODefaultDepartment(const Value: string);
begin
  FIODefaultDepartment := Value;
end;

procedure TImportJob.SetIODefaultNominalCode(const Value: string);
begin
  FIODefaultNominalCode := Value;
end;

procedure TImportJob.SetIODefaultVATCode(const Value: string);
begin
  FIODefaultVATCode := Value;
end;

procedure TImportJob.SetIOOverwriteNotepad(const Value: boolean);
begin
  FIOOverwriteNotepad := Value;
end;

procedure TImportJob.SetIOUpdateAccountBalances(const Value: boolean);
begin
  FIOUpdateAccountBalances := Value;
end;

procedure TImportJob.SetIOUpdateStockLevels(const Value: boolean);
begin
  FIOUpdateStockLevels := Value;
end;

procedure TImportJob.SetIOValidateJobCostingFields(const Value: boolean);
begin
  FIOValidateJobCostingFields := Value;
end;

procedure TImportJob.SetDateFormat(const Value: string);
begin
  FDateFormat := Value;
end;

procedure TImportJob.SetIOIgnoreImportErrors(const Value: boolean);
begin
  FIOIgnoreImportErrors := Value;
end;

procedure TImportJob.SetIONomCurrVarTolerance(const Value: string);
begin
  FIONomCurrVarTolerance := Value;
end;

procedure TImportJob.SetIOUseJobBudgets(const Value: boolean);
begin
  FIOUseJobBudgets := Value;
end;

procedure TImportJob.SetJobGlobalRecordType(const Value: string);
begin
  if Value = '<none>' then
    FJobGlobalRecordType := ''
  else
    FJobGlobalRecordType := Value;
end;

procedure TImportJob.IncrementDataRecordError(Sender : TObject);
begin
  Inc(FErrorRecordCount);
end;

//SS:10/10/2017:2017-R2:ABSEXCH-19432:'Windows User ID' is displayed in Exchequer instead of 'Username' of the User when data is Imported using Importer
procedure TImportJob.SetLoginDisplayName(const Value: string);
begin
  FLoginDisplayName := Value;
end;

end.
