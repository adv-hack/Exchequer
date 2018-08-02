unit TRecordMgrClass;

{******************************************************************************}
{ TRecordMgr allocates blank Exchequer records to the caller and receives      }
{ information about any keys for that record. Is it up to the caller to fill   }
{ in the Exchequer record with data.                                           }
{ TRecordMgr decides whether a completed record should be written either       }
{ to Exchequer or to an intermediate BTrieve table for sorting. If to a sort   }
{ file, then when instructed to, TRecordMgr reads the records back in key      }
{ sequence and they are written to the Exchequer database.                     }
{ At any point, the caller can call FlushRecords to force TRecordMgr to        }
{ complete the processing of any records that have not yet been written to     }
{ Exchequer or the BTrieve table.                                              }
{ N.B. Originally, all the arrays in this class were dynamic and the lengths   }
{ were adjusted as appropriate with SetLength. However, in order to track down }
{ a particularly obscure bug I changed the arrays to have 2 fixed elements.    }
{ This matches the requirements of the release version of Importer.dat and is  }
{ unlikely to change. As it turns out, the bug had nothing to do with FRecIx   }
{ but I've left the working code asis with the SetLength statements commented  }
{ out.                                                                         }
{******************************************************************************}

interface

uses GlobalTypes, TMapsClass, TBtrvFileClass, Btrvu2, TDBAClass, TPosterClass, TImportToolkitClass, Classes;

const
  InitialRecCount = 2; // the number of FManagedRecs that we have being built at any one time
  MaxKeys         = 2; // maximum keys defined in the settings file for any given record type

type

  TKeyField = record
    KeyNo:    byte;
    KeyValue: ShortString;
    KeyLen:   integer;
  end;

  TKeyFields = record
//    RecIx:     integer;
    NoOfKeys:  integer; // number of following elements used
    KeyField:  array[0..MaxKeys - 1] of TKeyField;
  end;

  TRecordMgr = class(TObject)
  private
{* internal fields *}
    FDBA: TDBA;
    FDBACreated: boolean;
    FImportError: boolean;
    FRecKeys: array[0..InitialRecCount - 1] of TKeyFields;
    FManagedRecs: array[0..InitialRecCount - 1] of TManagedRec;
    FRecordCount: integer;
    FRecIx: integer; // index into the FManagedRecs array
    FSortFile: TBtrvFile;
    FSortFileCreated: boolean;
    FSortFileName: string;
    FSortFileOpen: boolean;
    FSortFileRecordCount: integer;
    FSortReqd: boolean;
{* property fields *}
    FReadSortFile: boolean;
    FJobNo: integer;
    FFileNo: integer;
    FRecordNo: integer;
    FImportedRecordCount: integer;
    FCachedRecordCount: integer;
    FCurrencyVarianceCount: integer;
    FErrorRecordCount: integer;
    FPoster: TPoster;
    FTHCount: integer;
    FNomCurrencyVarianceTolerance: string;
    FIncDataErrorProc : TNotifyEvent;
{* Procedural Methods *}
    function  BlankChar(RT: string): char;
    function  CreateDBA: integer;
    function  CreateSortFile: integer;
    function  DeleteSortFile: integer;
    function  GenSortFileName: string;
    function  LogEntry(AEntry: string; AImportError: boolean): integer;
    function  OpenSortFile: integer;
    function  OutputRecord: integer;
    procedure PopulateKeyFields;
    function  ProcessSortFile: integer;
{* getters and setters *}
    function  GetCurrentRecord: PExchequerRec;
    procedure SetReadSortFile(const Value: boolean);
    procedure SetJobNo(const Value: integer);
    procedure SetFileNo(const Value: integer);
    procedure SetRecordNo(const Value: integer);
    function  GetSysMsg: string;
    function  GetSysMsgSet: boolean;
    procedure SetSysMsg(Value: string);
    procedure SetImportedRecordCount(const Value: integer);
    procedure SetCachedRecordCount(const Value: integer);
    procedure SetPoster(const Value: TPoster);
    procedure SetSortReqd(const Value: boolean);
    procedure SetNomCurrencyVarianceTolerance(const Value: string);
  public
    constructor create;
    destructor destroy; override;
    procedure  AddKey(KeyValue: string; FieldType: char; FieldLen: integer; SortSeq: char);
    procedure ClearSortFile;
    procedure ClearTotals;
    procedure CopyPreviousKeys;
    function  FlushRecords: integer;
    function  NewRecord(RecordType: string; OrigRecType: string): PExchequerRec; // v,061
    function  RecordDone(OkToOutput: boolean): integer;
    property  CachedRecordCount: integer read FCachedRecordCount write SetCachedRecordCount;
    property  CurrencyVarianceCount: integer read FCurrencyVarianceCount;
    property  CurrentRecord: PExchequerRec read GetCurrentRecord;
    property  ErrorRecordCount: integer read FErrorRecordCount;
    property  FileNo: integer read FFileNo write SetFileNo;
    property  ImportedRecordCount: integer read FImportedRecordCount write SetImportedRecordCount;
    property  NomCurrencyVarianceTolerance: string read FNomCurrencyVarianceTolerance write SetNomCurrencyVarianceTolerance;
    property  JobNo: integer read FJobNo write SetJobNo;
    property  Poster: TPoster read FPoster write SetPoster;
    property  ReadSortFile: boolean read FReadSortFile write SetReadSortFile;
    property  RecordNo: integer read FRecordNo write SetRecordNo;
    property  SortReqd: boolean read FSortReqd write SetSortReqd;
    property  SysMsg: string read GetSysMsg;
    property  SysMsgSet: boolean read GetSysMsgSet;
    property  THCount: integer read FTHCount;
    property  IncDataErrorProc : TNotifyEvent read FIncDataErrorProc write FIncDataErrorProc;
  end;

implementation

Uses Windows, TIniClass, SysUtils, Utils, dialogs, GlobalConsts, TLoggerClass, TErrors,
     VAOUtil, TJobQueueClass, EntLicence;

{ TRecordMgr }

constructor TRecordMgr.create;
begin
  inherited;

  FRecIx := -1;
//  SetLength(FManagedRecs, InitialRecCount); // don't want to keep resizing for every new record so we'll reserve some
end;

destructor TRecordMgr.destroy;
begin
  FreeObjects([FSortFile, FDBA]);
//  FManagedRecs := nil;
//  FKeyFields   := nil;

  inherited;
end;

{* Procedural Methods *}

procedure TRecordMgr.AddKey(KeyValue: string; FieldType: char; FieldLen: integer; SortSeq: char);
// populates the array of TFields with the new key.
// FKeyFields is a two dimensional array where the first dimension is the
// RecIx of the FManagedRecs array and the second dimension contains the key
// field for the record.
// We can't pass the key to TBtrvFile.DefineKey yet because we don't know how
// many there will be.
// The key values need to be moved into the record in KeyNo order, 1-9 in
// PopulateKeyFields which is another reason why we store them here first - we
// might not received them in KeyNo order.
// The commented-out code is left over from when the arrays were dynamic.
// Had to go to fixed-length arrays to solve a particularly obscure bug. If the
// number of keys in the meta-data ever increases from the two now hard-coded here
// this code can be re-instated.
// Records with a key sort sequence of 1 to 9 will be written to the sort file.
// Records with a key sort sequence of A to C aren't written to the sort file but
// are used by TDBA to identify the end/start of each group of TH/TL records which
// are identified by a reference field (LinkRef).
var
  KeyIx: integer;
begin
  if not (SortSeq in ['1'..'9', 'A'..'C']) then exit; // not a key field

  if (FieldType = 'C') and (length(KeyValue) <> FieldLen) then
    KeyValue := format('%-*s', [FieldLen, KeyValue]); // pad out the array of char with spaces

  if FSortReqd then
    if not FSortFileCreated then
      CreateSortFile; // been given a key - we'll need a sort file then

//  if length(FRecKeys) < (FRecIx + 1) then // have we got room for the new key ?
//    SetLength(FRecKeys, FRecIx + 1); // (FRecIx is zero-based) create a new record element                
  if (SortSeq in ['1'..'9']) then
    KeyIx := StrToInt(SortSeq)
  else
    KeyIx := Ord(SortSeq) - 64; // change A..C to 1..3
//  if KeyIx > length(FRecKeys[FRecIx].KeyFields) then
//    SetLength(FRecKeys[FRecIx].KeyFields, KeyIx); // lengthen the TKeyField dimension to accommodate
  if KeyIx > FRecKeys[FRecIx].NoOfKeys then
    FRecKeys[FRecIx].NoOfKeys := KeyIx;  // how many keys do we have ?

  KeyIx := KeyIx - 1; // 0-base it to set attributes

{* fill in the key attributes *}
  FRecKeys[FRecIx].KeyField[KeyIx].KeyNo    := KeyIx + 1;
  FRecKeys[FRecIx].KeyField[KeyIx].KeyValue := KeyValue;
  FRecKeys[FRecIx].KeyField[KeyIx].KeyLen   := FieldWidth(FieldType, FieldLen);
end;

function  TRecordMgr.BlankChar(RT: string): char;
// get the char which is used to blank new records.
// The default is #0. For Apps & Vals we use #255 so that we can distinguish
// a zero field from a "not set" field.
// In the settings file, the character is described as an ascii code prefixed
// by a #.
var
  BlankCharCode: string;
begin
  Result := #0;
  BlankCharCode := IniFile.ReadString(BLANK_CHAR, RT, '#0');
  if BlankCharCode[1] = '#' then // check to be sure
    result := chr(StrToInt(copy(BlankCharCode, 2, length(BlankCharCode) - 1)));
end;

procedure TRecordMgr.CopyPreviousKeys;
// RL transaction lines are multiple lines for a common header record.
// Each RL transaction line generates a transaction header.
// But they all need to have the same RT/LinkRef key fields so that Record Mgr
// knows where each group starts and ends.
// Same for OL which is a single transaction line with a transaction header.
// In each case, the RT/LinkRef for the transaction line has been set before
// transaction header record is populated.
// Here, the current value of FRecIx will point to the transaction header and
// FRecIx-1 points to the transaction line. See TImportJob.OutputFieldValue.
var
  i: integer;
begin
  if FRecIx = 0 then exit;
  if FRecKeys[FRecIx-1].NoOfKeys = 0 then exit;

  FRecKeys[FRecIx].NoOfKeys := FRecKeys[FRecIx-1].NoOfKeys;

  for i := 0 to FRecKeys[FRecIx-1].NoOfKeys - 1 do begin
    FRecKeys[FRecIx].KeyField[i].KeyNo    := FRecKeys[FRecIx-1].KeyField[i].KeyNo;
    FRecKeys[FRecIx].KeyField[i].KeyValue := FRecKeys[FRecIx-1].KeyField[i].KeyValue;
    FRecKeys[FRecIx].KeyField[i].KeyLen   := FRecKeys[FRecIx-1].KeyField[i].KeyLen;
  end;
end;

function TRecordMgr.FlushRecords: integer;
// Each distinct job number can result in multiple instances of TImportJob on the job queue - one for each file.
// Some or all of them can output records to the sort file.
// The job settings determine whether the sort file is read back in at the end of each file or at the end of
// the overall job after all instances of TImportJob have written to it.
var
  x: integer;
begin
  result := 0;


  if FReadSortFile then       // does any instance require this instance to process the sort file ?
    result := ProcessSortFile;

//  if result >= 0 then begin // this could probably be changed to =0 now since ProcessSortFile no longer returns the number of records imported, but it works so I've left it.
    if FDBACreated then begin
      if result < 0 then begin // v.077
        x := FDBA.FlushRecords; // preserve the error condition
        if x < 0 then
          inc(FErrorRecordCount, abs(x))
        else
          inc(FImportedRecordCount, x);
      end
      else begin
        result := FDBA.FlushRecords;        // The DBA might have cached some transactions (e.g. the final set of TH/TL's)
        if result < 0 then
          inc(FErrorRecordCount, abs(result))
        else
          inc(FImportedRecordCount, result);
      end;
      FCurrencyVarianceCount := FDBA.CurrencyVarianceCount; // v.077 two lines moved from before "if result < 0"
      FTHCount               := FDBA.THCount;
      if assigned(FPoster) then
        FPoster.PostMSg(WM_IMPORTJOB_PROGRESS, FSortFileRecordCount, FImportedRecordCount + FErrorRecordCount); // Post progress to gauges
    end;
//  end;

//***************
  //PR: 30/01/2013 ABSEXCH-11974 - moved this from above (before 'if FReadSortFile then') so that we don't close and re-open
  //                               the sort file before reading the records that have been added -
  //                               seems to bypass the caching problem

  if FSortReqd then begin     // did this instance output records to the sort file ?
    FSortFile.CloseFile;
  end;
//****************

  if assigned(FPoster) then
    FPoster.PostMSg(WM_IMPORTJOB_PROGRESS, 0, 0); // finished importing (including SortFile)
end;

function TRecordMgr.CreateDBA: integer;
begin
  result := -1;

  if not assigned(FDBA) then
    FDBA := TDBA.create;

  FDBA.NomCurrencyVarianceTolerance := StrToFloat(FNomCurrencyVarianceTolerance);

  FDBA.IncrementErrorCount := FIncDataErrorProc;

  FDBACreated := true;

  result := 0;
end;

function TRecordMgr.CreateSortFile: integer;
const
  SortF = 23;
begin
  result := -1;

  if not assigned(FSortFile) then
    FSortFile := TBtrvFile.create;

  //PR: Changed to use file no 23 to avoid clashes
  FSortFile.FileIx := SortF;
  FSortFile.FileName     := GenSortFileName;
  FSortFile.RecordLength := SizeOf(TManagedRec);
  FSortFile.KeySegs      := StrToInt(IniFile.ReturnValue(SYSTEM_SETTINGS, 'KeySegs'));

  FSortFileCreated := true;

  result := 0;
end;

function TRecordMgr.DeleteSortFile: integer;
// delete the sort file and the .lck file that BTrieve will have created.
begin
  result := 0;
  if FileExists(FSortFile.FileName) then
    if not DeleteFile(FSortFile.FileName) then
      result := -1;
  if FileExists(ChangeFileExt(FSortFile.FileName, '.lck')) then
    if not DeleteFile(ChangeFileExt(FSortFile.FileName, '.lck')) then
      result := -1;

  if result = -1 then
    LogEntry('Unable to delete record cache after use', false); // not entirely sure this is an ImportError condition, if it ever happens we'll find out
end;

procedure TRecordMgr.ClearSortFile;
// Clear out any previous records for this file. This allows a trial import
// to be performed, immediately followed by a proper import if no errors.
// Otherwise records would be duplicated.
// If this is the first file in the job, delete all records from the sort file.
// Just a precaution in case a program crash causes a job number to be reused.
// (The sort file is named after the job number). This ensures that if we
// reuse a sort file from a previous job, we don't re-import records.
var
  rc:          integer;
  InputRecord: TManagedRec;
  OpenedHere:  boolean;
begin;
  if not FSortReqd then exit;

  rc := 0;
  OpenedHere := not FSortFileOpen;
  if not FSortFileOpen then
    rc := OpenSortFile;

  if rc = 0 then begin
    rc := FSortFile.FindFirst(InputRecord);
    while rc = 0 do begin
      if (FFileNo = 1) or (InputRecord.FileNo = FFileNo) then
        rc := FSortFile.DeleteRecord;
      if rc  = 0 then
        rc := FSortFile.FindNext(InputRecord);
    end;

    if OpenedHere then
      FSortFile.CloseFile;
  end;
end;

procedure TRecordMgr.ClearTotals;
// no idea !
begin
  FCachedRecordCount     := 0;
  FImportedRecordCount   := 0;
  FErrorRecordCount      := 0;
  FCurrencyVarianceCount := 0;
  if FDBACreated then
    FDBA.ClearTotals;
end;

function TRecordMgr.GenSortFileName: string;
// file name = 'RC' + JobNo as six-digit hex + '.dat'
// Each TImportJob for the same FJobNo must use the same sort file so the name
// is based on the job number.
var
  JobNo: string;
  TargetFolder: string;
begin
  TargetFolder := IncludeTrailingPathDelimiter(VAOInfo.vaoCompanyDir) + 'SWAP\';
  ForceDirectories(TargetFolder); // v.071
  JobNo := format('%.6d', [FJobNo]);
  result := TargetFolder + 'RC' + JobNo + '.dat';
//  LogEntry('Record Cache: ' + result, false);
end;

function TRecordMgr.LogEntry(AEntry: string; AImportError: boolean): integer;
begin
  result := Logger.LogEntry(FFileNo, AEntry);
  if AImportError then
    FImportError := true; // n.b. not the same as FImportError := AImportError.
end;

function TRecordMgr.NewRecord(RecordType: string; OrigRecType: string): PExchequerRec; // v.061
// provide a new blank TExchequerRec for TImportJob to fill in with data from the import file
begin
  inc(FRecordCount);
//  if FRecordCount > InitialRecCount then
//    SetLength(FManagedRecs, FRecordCount); // resize the array now that we have more records than initially catered for

  inc(FRecIx);
  FillChar(FRecKeys[FRecIx], SizeOf(TKeyFields), 0);                      // blank out the previous key fields for this FRecIx
  move(RecordType[1], FManagedRecs[FRecIx].RecordType, 2);                // Store the Record Type in the new record
  move(OrigRecType[1], FManagedRecs[FRecIx].OrigRecType, 2);                // v.061
  FillChar(FManagedRecs[FRecIx].ExchequerRec, SizeOf(TExchequerRec), BlankChar(RecordType)); // blank the rest ***TEST*** changed #0 to #255 for Apps & Vals
  result := @FManagedRecs[FRecIx].ExchequerRec;                           // return a pointer to the new record
end;

function TRecordMgr.OpenSortFile: integer;
begin
  result := -1;
  {$IFNDEF EXSQL} // the physical file will never exist in a SQL environment
  if not FileExists(FSortFile.FileName) then begin
    LogEntry(format('Record Cache does not exist: %s', [FSortFile.FileName]), true);
    EXIT;
  end;
  {$ENDIF}

  result := FSortFile.OpenFile;
  if result = 0 then
    FSortFileOpen := true
  else
    LogEntry(format('Unable to open record cache %s: %s', [FSortFile.FileName, FSortFile.LastError]), true);
end;

function TRecordMgr.OutputRecord: integer;
// do we write to the sort file or to Exchequer via the DBA ?
// In the meta-data, TFieldDef.Usage = [1..9] denotes key fields for records which need to be written to the sort file,
// whereas TFieldDef.Usage = [A..C] denotes key fields for records which don't need to be written to the sort file.
// In the case of the latter, records arrive in the correct sequence and Record Mgr uses the key fields to identify
// when one group of TH/TL's end and another begins. In the case of record type "RL" which are multiple TL's linked by a common
// reference field (LinkRef), each TH comes with a copy of the keyfields of the TL. So when the key fields of the TH don't match those of
// the previous TH, we're into a different set of TH/TL's. Don't worry, just nod.
begin
  result := -1;
  if FSortReqd then begin  // will have been determined in TMaps.CreateMaps from the meta-data
    FSortFile.KeySegs := FRecKeys[FRecIx].NoOfKeys; // Tell TBtrvFile the total KeySegs reqd.

{* PopulateKeyFields calls TBtrvFile.DefineKey. Needed to set KeySegs first as
   this tells TBtrvFile how many keys are coming which allocates memory for them. *}
    PopulateKeyFields;                                           // move the key values into the record
    result := FSortFile.WriteRecord(FManagedRecs[FRecIx]);       // the first write will define and open the sort file
    if result < 0 then begin
      LogEntry(format('Error writing to record cache: %d', [result]), true); // not user-friendly
      LogEntry(format('Record cache: %s', [FSortFile.FileName]), true);
      LogEntry(format('Last Error: %s', [FSortFile.LastError]), true);
    end
    else
      inc(FCachedRecordCount);
  end
  else begin
    PopulateKeyFields; // still need keys to distinguish between related groups of TH/TL's
    if not FDBACreated then
      CreateDBA;
    FDBA.HighFileNo := FManagedRecs[FRecIx].FileNo; // all errors get logged to the most recently read file's log
    result := FDBA.WriteRecord(FManagedRecs[FRecIx]);            // the first write will open the DLL Toolkit if it isn't already
    FCurrencyVarianceCount := FDBA.CurrencyVarianceCount;
    FTHCount               := FDBA.THCount;
    if result < 0 then
      inc(FErrorRecordCount, abs(result))
    else
      inc(FImportedRecordCount, result);
  end;
end;

procedure TRecordMgr.PopulateKeyFields;
// cycle through the array of keyfields for the current record.
// Move the value to the correct position in the KeyFields array of the
// TManagedRecord.
// For moving the key values into the record the offset is 0-based.
// In the call to DefineKey, the offset has 3 added to it:-
//      a) we add 1 because KeyBuff.KeyPos key positions are 1-based in the Btrieve spec
//      b) we add another 2 because all records have a 2-char
//         Record Type at the front which the meta-data doesn't know about.
//         This shifts all Btrieve key positions along 2.
// v.061
// In the call to DefineKey, the offset has 5 added to it:-
//      a) we add 1 because KeyBuff.KeyPos key positions are 1-based in the Btrieve spec
//      b) we add another 2 because all records have a 2-char
//         Record Type at the front which the meta-data doesn't know about.
//      c) we add another 2 because all records have a 2-char
//         Original Record Type at the front which the meta-data doesn't know about.
//         This shifts all Btrieve key positions along 4.

var
  i: integer;
  KeyIx: integer;
  offset: integer;
  flags: smallint;
begin
  offset := 0;
  flags := DupModSeg+AltColSeq;
  for KeyIx := 0 to FRecKeys[FRecIx].NoOfKeys - 1 do begin
    if FSortReqd then begin
      if KeyIx = FRecKeys[FRecIx].NoOfKeys - 1 then
        flags := DupMod+AltColSeq; // change for final segment of the key
//      FSortFile.DefineKey(KeyIx + 1, offset + 3, FRecKeys[FRecIx].KeyField[KeyIx].KeyLen, flags); // define the key in the sort file // v.60
      FSortFile.DefineKey(KeyIx + 1, offset + 5, FRecKeys[FRecIx].KeyField[KeyIx].KeyLen, flags); // define the key in the sort file // v.061
    end;
    Move(FRecKeys[FRecIx].KeyField[KeyIx].KeyValue[1], FManagedRecs[FRecIx].KeyFields[Offset], FRecKeys[FRecIx].KeyField[KeyIx].KeyLen);
    offset := offset + FRecKeys[FRecIx].KeyField[KeyIx].KeyLen; // next keyvalue will follow this one
  end;
end;

function TRecordMgr.ProcessSortFile: integer;
// read the sort file in key sequence and pass the records to the DBA.
// Also see comments in FlushRecords about TImportJob instances.
var
  InputRecord: TManagedRec;
  rc: integer;
  ImportedRecords: integer;
  HighFileNo: integer;
begin
  HighFileNo := 0;
  result := -1;

  if not ImportToolkit.ToolkitConfiguration.tcTrialImport then begin
    LogEntry('', false);
    if EnterpriseLicence.IsLITE then begin
      LogEntry('Importing into IRIS Accounts Office', false);
      LogEntry('===================================', false);
    end
    else begin
      LogEntry('Importing into Exchequer', false);
      LogEntry('========================', false);
    end;
    LogEntry('', false);
    LogEntry(format('Importing record cache RC%.6d', [FJobNo]), false);
  end else begin
    LogEntry('', false);
    LogEntry(format('Reading record cache RC%.6d', [FJobNo]), false);
  end;

  if not FSortFileCreated then       // this instance might not have needed to write to it
    if CreateSortFile <> 0 then exit;

  if not FDBACreated then
    if CreateDBA <> 0 then exit;

  if not FSortFileOpen then
    if OpenSortFile <> 0 then exit;

  if assigned(FPoster) then begin // no point in doing this if no-one wants to know
    if FSortFileOpen then begin     // count number of records in SortFile;
      FSortFileRecordCount := 0;
      HighFileNo := 0;
      rc := FSortFile.FindFirst(InputRecord);
      while rc = 0 do begin
        inc(FSortFileRecordCount);
        if InputRecord.FileNo > HighFileNo then // reading cached records from multiple files....
          HighFileNo := InputRecord.FileNo;     // but all errors must be reported in the last file's log
        rc := FSortFile.FindNext(InputRecord);
      end;
      if assigned(FPoster) then
        FPoster.PostMSg(WM_IMPORTJOB_PROGRESS, FSortFileRecordCount, 0); // Post Maximum value to gauges in Main.pas
    end;
  end;

  result := 0;
  if FSortFileOpen then begin
    FDBA.HighFileNo := HighFileNo;
    rc := FSortFile.FindFirst(InputRecord);
    while rc = 0 do begin
//      if debug then ShowMessage(InputRecord.RecordType + ' ' + InputRecord.KeyFields + #13#10 +
//                         InputRecord.ExchequerRec.BatchTLRec.Desc);
      ImportedRecords := FDBA.WriteRecord(InputRecord);
      FCurrencyVarianceCount := FDBA.CurrencyVarianceCount;
      FTHCount               := FDBA.THCount;
      if ImportedRecords < 0 then begin
        result := ImportedRecords;
        inc(FErrorRecordCount, abs(result));
//        SetSysMsg('An error occurred while writing records from the Record Cache');
//        exit;
      end
      else
        inc(FImportedRecordCount, ImportedRecords);
      if assigned(FPoster) then
        FPoster.PostMSg(WM_IMPORTJOB_PROGRESS, FSortFileRecordCount, FImportedRecordCount + FErrorRecordCount); // Post progress to gauges
      rc := FSortFile.FindNext(InputRecord);
    end;
    FSortFile.CloseFile;
    if not ImportToolkit.ToolkitConfiguration.tcTrialImport then // Processed sort file after a proper import
    begin
      //PR: 01/08/2014 ABSEXCH-15471/ABSEXCH-14856 Under MS-SQL, the sort file doesn't get deleted until the program closes,
      //                             so clear out records first, im case the file gets re-used.
      ClearSortFile;
      DeleteSortFile;
    end;
  end;

end;

function TRecordMgr.RecordDone(OkToOutput: boolean): integer;
// TImportJob has finished filling the record with data so fill in the bits it
// doesn't know about.
// If TImportJob detected a data error with the record, OkToOutput will be false
// in which case the record doesn't go any further.
// Otherwise OutputRecord will either write it to the sort file or to Exchequer
// via the DBA.
begin
  result := 0;
  if FRecordCount > 0 then begin
    FManagedRecs[FRecIx].JobNo  := FJobNo;
    FManagedRecs[FRecIx].FileNo := FFileNo;
    FManagedRecs[FRecIx].RecNo  := FRecordNo;
    if OkToOutput then        // otherwise just release the record without writing it to Exchequer
      result := OutputRecord;
    dec(FRecordCount);
    dec(FRecIx);
  end;
end;

{* getters and setters *}

function TRecordMgr.GetCurrentRecord: PExchequerRec;
begin
  result := @FManagedRecs[FRecIx].ExchequerRec;
end;

procedure TRecordMgr.SetReadSortFile(const Value: boolean);
begin
  FReadSortFile := Value;
end;

procedure TRecordMgr.SetJobNo(const Value: integer);
begin
  FJobNo := Value;
end;

procedure TRecordMgr.SetFileNo(const Value: integer);
begin
  FFileNo := Value;
end;

procedure TRecordMgr.SetRecordNo(const Value: integer);
begin
  FRecordNo := Value;
end;

function TRecordMgr.GetSysMsg: string;
begin
  result := TErrors.SysMsg;
end;

function TRecordMgr.GetSysMsgSet: boolean;
begin
  result := TErrors.SysMsgSet;
end;

procedure TRecordMgr.SetSysMsg(Value: string);
begin
  TErrors.SetSysMsg(Value);
end;

procedure TRecordMgr.SetImportedRecordCount(const Value: integer);
begin
  FImportedRecordCount := Value;
end;

procedure TRecordMgr.SetCachedRecordCount(const Value: integer);
begin
  FCachedRecordCount := Value;
end;

procedure TRecordMgr.SetPoster(const Value: TPoster);
begin
  FPoster := Value;
end;

procedure TRecordMgr.SetSortReqd(const Value: boolean);
begin
  FSortReqd := Value;
end;

procedure TRecordMgr.SetNomCurrencyVarianceTolerance(const Value: string);
begin
  FNomCurrencyVarianceTolerance := Value;
end;

end.
