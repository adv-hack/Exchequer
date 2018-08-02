unit TBtrvFileU;

{******************************************************************************}
{ TBtrvFile defines and creates a Btrieve file and controls the writing and    }
{ reading of records.                                                          }
{                                                                              }
{ This class has been written to make it almost entirely generic and usable    }
{ for creating any Btrieve file with any number of key segments.               }
{ Only the most basic record writing and reading functions, as required by     }
{ Importer, have been implemented so far and should be added to as and when    }
{ required.                                                                    }
{ 17/01/2006: Added record locking and unlocking                               }
{                                                                              }
{ Usage:-                                                                      }
{                                                                              }
{   set property FileIx with the unique number of the file. property MaxBtrvFiles
{                can be used to determine the highest number defined in Btrvu2 }
{   set property TotalIndexes with the total number of indexes                 }
{   set property KeySegs with total number of KeySegs                          }
{   set property Filename to the full path of the Btrieve file/table           }
{   set property RecordLength to length of record (full record definition is   }
{                           contained in your own unit)                        }
{   For each required key call DefineKey(KeySeg, KeyPos, Flags);               }
{                                                                              }
{ Unless there is a specific reason for doing so, there is no need to          }
{ explicitly call OpenFile as this will be done automatically the first time   }
{ a call is made to FindFirst, FindRecord or WriteRecord.                      }
{                                                                              }
{ DefineBtrvFile is called automatically by OpenFile. If the file does not     }
{ exist, OpenFile will create it.                                              }
{******************************************************************************}

interface

uses Btrvu2, GlobVar;

type
  TBtrvFile = class(TObject)
  private
{* internal fields *}
    FFileSpecLen: integer;
    FBtrvFileDefined: boolean;
    FBtrvFileF: FileVar;
    FBtrvFileOpen: boolean;
    FKeyS: Str255;
{* property fields *}
    FKeySegs:      integer;
    FBtrvFileName: string;
    FRecordLength: integer;
    FTotalIndexes: integer;
    FFileIx: integer;
{* procedural methods *}
    function  DefineBtrvFile: integer;
{* getters and setters *}
    procedure SetBtrvFileName(const Value: string);
    procedure SetKeySegs(const Value: integer);
    procedure SetRecordLength(const Value: integer);
    procedure SetTotalIndexes(const Value: integer);
    procedure SetFileIx(const Value: integer);
//    function  GetSysMsg: string;
//    function  GetSysMsgSet: boolean;
//    procedure SetSysMsg(const Value: string);
    function  GetMaxBtrvFiles: integer;
  public
    constructor create;
    function  DefineKey(KeySeg: integer; KeyPos: integer; KeyLen: integer; KeyFlags: smallint): integer;
    function  DeleteRecord: integer;
    function  CloseFile: integer;
    function  OpenFile: integer;
    function  FindFirst(var InputRec): integer;
    function  FindNext(var InputRec): integer;
    function  FindRecord(var InputRec; Key: string): integer; overload;
    function  FindRecord(var InputRec; Key: string; KeyNo: integer): integer; overload;
    function  LockRecord: integer;
    function  UnlockRecord: integer;
    function  UpdateRecord: integer;
    function  WriteRecord(var OutputRec): integer;
    property  FileIx: integer read FFileIx write SetFileIx;
    property  FileName: string read FBtrvFileName write SetBtrvFileName;
    property  TotalIndexes: integer read FTotalIndexes write SetTotalIndexes;
    property  KeySegs: integer write SetKeySegs;
    property  MaxBtrvFiles: integer read GetMaxBtrvFiles;
    property  RecordLength: integer read FRecordLength write SetRecordLength;
//    property  SysMsg: string read GetSysMsg;
//    property  SysMsgSet: boolean read GetSysMsgSet;
  end;

implementation

uses sysutils, dialogs{, TErrorsU, TLoggerU},
{$IFDEF EXSQL}
     SQLUtils,
{$ENDIF}
     Forms;

type

{* A split version of the usual FileSpec which allows KeyBuff to be a
   dynamic array so we can set the number of KeySeqs at runtime rather than
   at compile time *}

  TBtrvFileSpec = record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
  end;
var
    KeyBuff   :  array of KeySpec; // length depends on number of keysegs received
    AltColt   :  AltColtSeq;
{***}

  BtrvFileSpec: TBtrvFileSpec;
  FileSpec: array of char; // the actual spec buffer that gets passed to Btrieve

  { TBtrvFile }

constructor TBtrvFile.create;
begin
  inherited;

  FTotalIndexes := 1;              // default
  FFileIx       := MAXFILES;       // default
end;

{* Procedural Methods *}

function TBtrvFile.CloseFile: integer;
var
  rc: integer;
begin
  rc := Close_File(FBtrvFileF);
  FBtrvFileOpen := false;
  result := rc;
end;

function TBtrvFile.DeleteRecord: integer;
begin
  result := Delete_Rec(FBtrvFileF, FileIx, 0);
end;

function TBtrvFile.DefineKey(KeySeg, KeyPos, KeyLen: integer; KeyFlags: smallint): integer;
// KeySeg is 1-based. KeyBuff array is dynamic so 0-based.
// Populates a standard KeyBuff array.
begin
  KeyBuff[KeySeg - 1].KeyPos   := KeyPos;
  KeyBuff[KeySeg - 1].KeyLen   := KeyLen;
  KeyBuff[KeySeg - 1].KeyFlags := KeyFlags
end;

function TBtrvFile.DefineBtrvFile: integer;
// setup up a standard BTrieve FileSpec except for the contents of KeyBuff

        procedure BuildBtrvFileSpec;
        var
          FileSpecLen: integer;
          KeyBuffLen:  integer;
          AltColtLen:  integer;
        begin
          FileSpecLen := SizeOf(TBtrvFileSpec);
          KeyBuffLen  := FKeySegs * SizeOf(KeySpec);
          AltColtLen  := SizeOf(AltColtSeq);

          FFileSpecLen := FileSpecLen + KeyBuffLen + AltColtLen;
          SetLength(FileSpec, FFileSpecLen); // correctly size the buffer

        {* put the three bits together, end-to-end, in FileSpec buffer *}
          Move(BtrvFileSpec, FileSPec[0], FileSpecLen);
          Move(KeyBuff[0], FileSpec[FileSpecLen], KeyBuffLen);
          Move(AltColt, FileSpec[FileSpecLen + KeyBuffLen], AltColtLen);
        end;

        procedure SetupBtrvu2;
        // these arrays in Btrvu2 get used when a call to, for example, add_rec
        // eventually calls btrv(b_insert......) etc.
        begin
          FileSpecLen[FileIx]  := FFileSpecLen;
          FileRecLen[FileIx]   := FRecordLength;
// n.b. RecPtr[FileIx] is set in WriteRecord as it changes each time.
          FileSpecOfs[FileIx]  := @FileSpec;
          FileNames[FileIx]    := FBtrvFileName;
        end;
begin
  if FBtrvFileDefined then exit;

  result := -1;

  FillChar(BtrvFileSpec, SizeOf(TBtrvFileSpec), #0);
  with BtrvFileSpec do begin
    RecLen   := FRecordLength;
    PageSize := DefPageSize;                               // from Btrvu2
    NumIndex := FTotalIndexes;
    Variable := B_Variable + B_Compress + B_BTrunc;        // from Btrvu2
  end;
  AltColt  := UpperALT;                                    // from Btrvu2

  BuildBtrvFileSpec;
  SetupBtrvu2;
  FBtrvFileDefined := true;
  result := 0;
end;

function TBtrvFile.FindFirst(var InputRec): integer;
// don't need to explicitly call OpenFile when reading records as the first call
// to FindFirst will do this.
begin
  if not FBtrvFileOpen then
    OpenFile;

  FKeyS := '';
  RecPtr[FileIx] := @InputRec;
  result := Find_Rec(B_GetGEq, FBtrvFileF, FileIx, RecPtr[FileIx]^, 0 , FKeyS);
//  ShowMessage('Fkeys = ' + FKeys);
end;

function TBtrvFile.FindNext(var InputRec): integer;
begin
  RecPtr[FileIx] := @InputRec;
  result := Find_Rec(B_GetNext, FBtrvFileF, FileIx, RecPtr[FileIx]^, 0 , FKeyS);
//  ShowMessage('Fkeys = ' + FKeyS);
end;

function TBtrvFile.FindRecord(var InputRec; Key: string): integer;
begin
  if not FBtrvFileOpen then
    OpenFile;

  FKeyS := Key;
  RecPtr[FileIx] := @InputRec;
  result := Find_Rec(B_GetEq, FBtrvFileF, FileIx, RecPtr[FileIx]^, 0 , FKeyS); // ***Check Importer - changed from GetGEQ
end;

function TBtrvFile.FindRecord(var InputRec; Key: string; KeyNo: integer): integer;
begin
  if not FBtrvFileOpen then
    OpenFile;

  FKeyS := Key;
  RecPtr[FileIx] := @InputRec;
  result := Find_Rec(B_GetEq, FBtrvFileF, FileIx, RecPtr[FileIx]^, KeyNo , FKeyS); // ***Check Importer - changed from GetGEQ
end;

function TBtrvFile.LockRecord: integer;
// Position must have been established by one of the Findxxxx functions
var
  posn: longint;

  function GetWithLock: integer;
  begin
    result := GetDirect(FBtrvFileF, FileIx, RecPtr[FileIx]^, 0, B_SingLock + B_SingNWLock);
  end;

begin
  result := GetPos(FBtrvFileF, FileIx, posn);
  if result = 0 then begin
    Move(posn, RecPtr[FileIx]^, SizeOf(posn));
    result := GetWithLock;
  end;
  if (result = 84) or (result = 85) then // "file or record in use"
   repeat
     sleep(500);                      // Keep Task Manager Cpu
     application.ProcessMessages;     // usage at nil during rapid loop
     result := GetWithLock;
   until (result = 0) or ((result <> 84) and (result <> 85));
end;

function TBtrvFile.OpenFile: integer;
// If the file doesn't exist, this function will try to create it.
var
  rc: integer;
begin
  result := 0;
  if FBtrvFileOpen then exit;

  result := -1;

  if not FBtrvFileDefined then
    if DefineBtrvFile <> 0 then exit;

  rc := 0;

{$IFDEF EXSQL}
  if not SQLUtils.TableExists(FileNames[FileIx]) then
{$ELSE}
  if not FileExists(FileNames[FileIx]) then
{$ENDIF}
  begin
    rc := Make_File(FBtrvFileF, FileNames[FileIx], FileSpec[0], FFileSpecLen);
  end;

  if rc = 0 then
    rc := Open_File(FBtrvFileF, FileNames[FileIx], 0);

  if rc = 0 then
    FBtrvFileOpen := true;

  result := rc;
end;

function TBtrvFile.UnlockRecord: integer;
begin
  FillChar(FKeyS, Sizeof(FKeyS), #0);
  result := Find_Rec(B_Unlock, FBtrvFileF, FileIx, RecPtr[FileIx]^, 0, FKeyS);
end;

function TBtrvFile.UpdateRecord: integer;
// record must have been locked with LockRecord
begin
  result := Put_Rec(FBtrvFileF, FileIx, RecPtr[FileIx]^, 0);
end;

function TBtrvFile.WriteRecord(var OutputRec): integer;
// don't need to explicitly call DefineBtrvFile and OpenFile when writing
// records as the first call to WriteRecord will do this.
begin
  result := -1;

  if not FBtrvFileDefined then
    if DefineBtrvFile <> 0 then exit;

  if not FBtrvFileOpen then
    if OpenFile <> 0 then exit;

  RecPtr[FileIx] := @OutputRec; // add_rec wants a var so need an intermediate store

  result :=  Add_Rec(FBtrvFileF, FileIx, RecPtr[FileIx]^, 0);
end;

{* getters and setters *}

procedure TBtrvFile.SetKeySegs(const Value: integer);
begin
  FKeySegs := value;
  SetLength(KeyBuff, FKeySegs);
end;

procedure TBtrvFile.SetRecordLength(const Value: integer);
begin
  FRecordLength := Value;
end;

procedure TBtrvFile.SetBtrvFileName(const Value: string);
begin
  FBtrvFileName := Value;
  FileNames[FileIx] := value;
end;

procedure TBtrvFile.SetTotalIndexes(const Value: integer);
begin
  FTotalIndexes := Value;
end;

procedure TBtrvFile.SetFileIx(const Value: integer);
begin
  FFileIx := Value;
end;

//function TBtrvFile.GetSysMsg: string;
//begin
//  result := TErrorsU.SysMsg;
//end;

//function TBtrvFile.GetSysMsgSet: boolean;
//begin
//  result := TErrorsU.SysMsgSet;
//end;

//procedure TBtrvFile.SetSysMsg(const Value: string);
//begin
//  TErrorsU.SetSysMsg(Value);
//end;

function TBtrvFile.GetMaxBtrvFiles: integer;
begin
  result := MAXFILES;
end;

end.
