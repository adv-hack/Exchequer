unit SQLLockU;

interface

uses SysUtils, Classes;

type
  TLockType = (ltNone, ltSingleWait, ltSingleNoWait, ltMultiWait,
               ltMultiNoWait, ltRelease, ltReleaseAny, ltReleaseAll);

  TLock = class(TObject)
  private
    TimeStamp: TDateTime;
    FThreadID: string;
    FPosBlock: Integer;
    FRecordAddress: Integer;
    FLockType: TLockType;
    procedure SetRecordAddress(const Value: Integer);
    procedure SetPosBlock(const Value: Integer);
    procedure SetThreadID(const Value: string);
    procedure SetLockType(const Value: TLockType);
  public
    property LockType: TLockType read FLockType write SetLockType;
    property PosBlock: Integer read FPosBlock write SetPosBlock;
    property RecordAddress: Integer read FRecordAddress write SetRecordAddress;
    property ThreadID: string read FThreadID write SetThreadID;
  end;

  TLockKeeper = class(TObject)
  private
    FLocks: TList;
    FMaxRetries: Integer;
    FSleepTime: Integer;
    FPath: string;
    FRandomSleepTime: Integer;

    { Returns the position in FLocks of the lock record identified by the
      specified details. Returns -1 if no matching lock record can be found. }
    function FindLockPos(PosBlock: Integer; RecordAddress: Integer; ThreadID: string): Integer;

    { Returns the position in FLocks of the first lock record matching the
      specified details. Returns -1 if no matching lock record can be found.
      This is used when locating all the locks relating to a specific position
      block. }
    function FindFirstLockPos(PosBlock: Integer; ThreadID: string): Integer;
    procedure SetMaxRetries(const Value: Integer);
    procedure SetSleepTime(const Value: Integer);
    procedure SetPath(const Value: string);
    procedure SetRandomSleepTime(const Value: Integer);

  public
    constructor Create;
    destructor Destroy; override;

    { Adds and returns a new lock record against the specified details. If a
      lock already exists, it will be returned instead, and a new lock record
      will not be added. }
    function AddLock(LockType: TLockType; PosBlock: Integer; RecordAddress: Integer; ThreadID: string): TLock;

    { Removes all the existing lock records from the list. }
    procedure Clear;

    { Returns True if there is a lock record against the specified details. }
    function LockExists(PosBlock: Integer; RecordAddress: Integer; ThreadID: string): Boolean;

    { Returns the existing lock record identified by the specified details, or
      nil if no matching lock record can be found. }
    function FindLock(PosBlock: Integer; RecordAddress: Integer; ThreadID: string): TLock;

    { Returns the lock type of the specified operation. Returns ltNone if the
      operation does not include a lock bias (see the Btrieve manual for
      information about Btrieve locks). }
    function LockType(Operation: Integer): TLockType;

    { Deletes all the lock records which match the specified details. (Note that
      no error is raised if no matching records are found.) }
    procedure DeleteAllLocks(PosBlock: Integer; ThreadID: string);

    { Deletes the lock record which matches the specified details. (Note that
      no error is raised if a matching record cannot be found.) }
    procedure DeleteLock(PosBlock: Integer; RecordAddress: Integer; ThreadID: string);

    { The number of times the system should attempt to re-apply a failed
      lock. }
    property MaxRetries: Integer read FMaxRetries write SetMaxRetries;

    { The length of time, in milliseconds, to wait between attempts to
      re-apply a failed lock. }
    property SleepTime: Integer read FSleepTime write SetSleepTime;

    { A maximum random amount to add to the sleep time (see above) in order to
      randomise it. }
    property RandomSleepTime: Integer read FRandomSleepTime write SetRandomSleepTime;

    { The path to the Exchequer system. The settings are read from a BtrvSQL.dat
      file in this directory. }
    property Path: string read FPath write SetPath;
  end;

function LockKeeper: TLockKeeper;

Procedure Finalize_SQLLockU;

implementation

uses Inifiles, DebugLogU;

var
  FLockKeeper: TLockKeeper;

{ Access to TLockKeeper singleton. }
function LockKeeper: TLockKeeper;
begin
  if (FLockKeeper = nil) then
    FLockKeeper := TLockKeeper.Create;
  Result := FLockKeeper;
end;

// =============================================================================
// TLock
// =============================================================================

procedure TLock.SetLockType(const Value: TLockType);
begin
  FLockType := Value;
end;

// -----------------------------------------------------------------------------

procedure TLock.SetPosBlock(const Value: Integer);
begin
  FPosBlock := Value;
end;

// -----------------------------------------------------------------------------

procedure TLock.SetRecordAddress(const Value: Integer);
begin
  FRecordAddress := Value;
end;

// -----------------------------------------------------------------------------

procedure TLock.SetThreadID(const Value: string);
begin
  FThreadID := Value;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TLockKeeper
// =============================================================================

function TLockKeeper.AddLock(LockType: TLockType; PosBlock: Integer; RecordAddress: Integer; ThreadID: string): TLock;
begin
Log('TLockKeeper.AddLock(LockType: ' + IntToStr(Ord(LockType)) + ', PosBlock: ' + IntToStr(PosBlock) + ', RecordAddress: ' + IntToStr(RecordAddress) + ', ThreadID: ' + ThreadID);
  if (LockType = ltSingleNoWait) then
    DeleteAllLocks(PosBlock, ThreadID);
  Result := FindLock(PosBlock, RecordAddress, ThreadID);
  if (Result = nil) then
  begin
    Result := TLock.Create;
    Result.LockType      := LockType;
    Result.ThreadID      := ThreadID;
    Result.PosBlock      := PosBlock;
    Result.RecordAddress := RecordAddress;
    Result.TimeStamp     := Now;
    FLocks.Add(Result);
  end;
end;

// -----------------------------------------------------------------------------

procedure TLockKeeper.Clear;
var
  Entry: Integer;
begin
  for Entry := 0 to FLocks.Count - 1 do
  begin
    TLock(FLocks[Entry]).Free;
  end;
  FLocks.Clear;
end;

// -----------------------------------------------------------------------------

constructor TLockKeeper.Create;
begin
  inherited Create;
  FLocks := TList.Create;
  FMaxRetries := 3;
  FSleepTime := 50;
  FRandomSleepTime := 50;
end;

// -----------------------------------------------------------------------------

procedure TLockKeeper.DeleteAllLocks(PosBlock: Integer; ThreadID: string);
var
  Entry: Integer;
begin
Log('TLockKeeper.DeleteAllLocks(PosBlock: ' + IntToStr(PosBlock) + ', ThreadID: ' + ThreadID);
  repeat
    Entry := FindFirstLockPos(PosBlock, ThreadID);
    if (Entry <> -1) then
    begin
      TLock(FLocks[Entry]).Free;
      FLocks.Delete(Entry);
    end;
  until (Entry = -1);
end;

// -----------------------------------------------------------------------------

procedure TLockKeeper.DeleteLock(PosBlock: Integer; RecordAddress: Integer; ThreadID: string);
var
  Entry: Integer;
begin
Log('TLockKeeper.DeleteLock(PosBlock: ' + IntToStr(PosBlock) + ', RecordAddress: ' + IntToStr(RecordAddress) + ', ThreadID: ' + ThreadID);
  Entry := FindLockPos(PosBlock, RecordAddress, ThreadID);
  if (Entry <> -1) then
  begin
    TLock(FLocks[Entry]).Free;
    FLocks.Delete(Entry);
  end;
end;

// -----------------------------------------------------------------------------

destructor TLockKeeper.Destroy;
begin
  if (FLocks.Count > 0) then
    Log('TLockKeeper.Destroy: ' + IntToStr(FLocks.Count) + ' locks still remaining at shutdown');
  Clear;
  FLocks.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

function TLockKeeper.FindFirstLockPos(PosBlock: Integer; ThreadID: string): Integer;
var
  Entry: Integer;
  Lock: TLock;
begin
  Result := -1;
  for Entry := 0 to FLocks.Count - 1 do
  begin
    Lock := TLock(FLocks[Entry]);
    if (Lock.ThreadID = ThreadID) and
       (Lock.PosBlock = PosBlock) then
    begin
      Result := Entry;
      break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TLockKeeper.FindLock(PosBlock: Integer; RecordAddress: Integer; ThreadID: string): TLock;
var
  Entry: Integer;
begin
Log('TLockKeeper.FindLock(PosBlock: ' + IntToStr(PosBlock) + ', RecordAddress: ' + IntToStr(RecordAddress) + ', ThreadID: ' + ThreadID);
  Result := nil;
  Entry := FindLockPos(PosBlock, RecordAddress, ThreadID);
  if (Entry <> -1) then
    Result := TLock(FLocks[Entry]);
end;

// -----------------------------------------------------------------------------

function TLockKeeper.FindLockPos(PosBlock: Integer; RecordAddress: Integer; ThreadID: string): Integer;
var
  Entry: Integer;
  Lock: TLock;
begin
  Result := -1;
  for Entry := 0 to FLocks.Count - 1 do
  begin
    Lock := TLock(FLocks[Entry]);
    if (Lock.PosBlock      = PosBlock) and
       (Lock.RecordAddress = RecordAddress) and
       (Lock.ThreadID      = ThreadID) then
    begin
      Result := Entry;
      break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TLockKeeper.LockExists(PosBlock: Integer; RecordAddress: Integer; ThreadID: string): Boolean;
begin
  Result := (FindLockPos(PosBlock, RecordAddress, ThreadID) > -1);
end;

// -----------------------------------------------------------------------------

function TLockKeeper.LockType(operation: Integer): TLockType;
const
  B_Close  =  1;
  B_Update =  3;
  B_Delete =  4;
  B_Unlock = 27;
  B_Reset  = 28;
begin
  { Do an integer division -- the lock bias values are 100, 200, 300, and 400,
    so the division will reduce the operation value to 1, 2, 3, or 4 for lock
    operations, or 0 for non-lock operations. }
  Result := TLockType(operation div 100);
  { If the operation is not a lock, check to see if it is an operation that
    will cause the lock to be released. }
  if (Result = ltNone) then
  begin
    { Update will release single locks }
    if (operation = B_Update) then
      Result := ltRelease
    else if (operation in [B_Close, B_Reset]) then
      Result := ltReleaseAll
    else if (operation in [B_Unlock, B_Delete]) then
      Result := ltReleaseAny;
  end;
end;

// -----------------------------------------------------------------------------

procedure TLockKeeper.SetMaxRetries(const Value: Integer);
begin
  FMaxRetries := Value;
end;

// -----------------------------------------------------------------------------

procedure TLockKeeper.SetPath(const Value: string);
var
  Inifile: TInifile;
begin
  FPath := Value;
  Inifile := TInifile.Create(FPath + 'BTRVSQL.DAT');
  try
    MaxRetries      := Inifile.ReadInteger('LOCKS', 'MAX_RETRIES', 3);
    SleepTime       := Inifile.ReadInteger('LOCKS', 'SLEEP_TIME', 50);
    RandomSleepTime := Inifile.ReadInteger('LOCKS', 'RANDOM_SLEEP_TIME', 50);
  finally
    Inifile.Free;
  end;
end;

// -----------------------------------------------------------------------------

procedure TLockKeeper.SetRandomSleepTime(const Value: Integer);
begin
  FRandomSleepTime := Value;
end;

// -----------------------------------------------------------------------------

procedure TLockKeeper.SetSleepTime(const Value: Integer);
begin
  FSleepTime := Value;
end;

// -----------------------------------------------------------------------------

Procedure Finalize_SQLLockU;
Begin // Finalize_SQLLockU
  If (FLockKeeper <> nil) Then
  Begin
    FLockKeeper.Free;
    FLockKeeper := NIL;
  End; // If (FLockKeeper <> nil)
End; // Finalize_SQLLockU

//-------------------------------------------------------------------------

initialization
  FLockKeeper := nil;
finalization
// MH 15/03/2010 v6.3: Moved into Finalize_SQLLockU as getting problems with order of finalizations
//  If (FLockKeeper <> nil) Then
//  Begin
//    FLockKeeper.Free;
//    FLockKeeper := NIL;
//  End; // If (FLockKeeper <> nil)
end.
