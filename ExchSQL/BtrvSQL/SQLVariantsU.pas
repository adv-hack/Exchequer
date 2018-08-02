unit SQLVariantsU;

interface

uses SysUtils, Classes, SQLRedirectorU, ClientIDU;

const
  VALID_VARIANT_OPERATIONS = [5, 6, 7, 8, 9, 10, 11, 23, 24, 35, 36, 37, 38, 39];

type
  TSQLVariantFile = class(TObject)
  private
    FRedirectors: TSQLRedirectorCache;
    FLastRedirector: TSQLRedirector;
    function GetRedirector(Prefix, SubType: Char): TSQLRedirector;
    procedure SetRedirector(Prefix, SubType: Char;
      const Value: TSQLRedirector);
    procedure SetLastRedirector(const Value: TSQLRedirector);
  public
    PosBlock: Integer;
    FileSpec: string;
    TableName: string;
    ClientID: TClientID;
    CacheID: LongInt;
    UsingCache: Boolean;
//    Redirector: TSQLRedirector;
    function RedirectorForRecordAddress(RecAddress: LongInt): TSQLRedirector;
    function PrefixForRecordAddress(RecAddress: LongInt; var Prefix: Char;
      var SubType: Char): Boolean;
    property Redirector[Prefix, SubType: Char]: TSQLRedirector
      read GetRedirector write SetRedirector;
    property LastRedirector: TSQLRedirector read FLastRedirector write SetLastRedirector;
    constructor Create;
    destructor Destroy; override;
  end;

  TSQLVariants = class(TObject)
  private
    FCallProtector: TMultiReadExclusiveWriteSynchronizer;
    FList: TList;
    function FileNameOnly(FullFileSpec: string): string;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    // Returns True if there is already an entry for this file.
    function AlreadyRecorded(PosBlock: Integer): Boolean;

    // Returns True if the specified file holds variant records. The check is
    // not case-sensitive, and FileName can include a path.
    function IsVariant(FileName: string): Boolean;

    // Adds the file to the list, assuming it is a Variant file (does nothing if
    // it is not), and that it is not already recorded.
    procedure AddFile(FileName: string; PosBlock: Integer; ClientID: Pointer = nil);

    // Clears all the entries, disposing the allocated memory for the
    // TSQLVariantFile records.
    procedure Clear;

    // Returns the entry id of the Variant File record if an entry exists
    // against the specified PosBlock, otherwise returns -1;
    function FindEntry(PosBlock: Integer): Integer;

    // Returns the entry for the specified posblock, or nil if an entry
    // cannot be found.
    function GetEntry(var PosBlock): TSQLVariantFile;

    // Removes the entry against the specified PosBlock. Does nothing if no
    // matching entry can be found.
    procedure RemoveEntry(PosBlock: Integer);

    // This is called from BTRCALL and BTRCALLID after a file is successfully
    // opened.
    procedure AfterOpenFile(var KeyBuf; var PosBlock; ClientID: Pointer = nil);

    // This is called from BTRCALL and BTRCALLID when a file is opened. If the
    // file is a variant file, it is added to the list of active variant files.
    procedure OnOpenFile(var KeyBuf; var PosBlock; ClientID: Pointer = nil);

    // This is called from BTRCALL and BTRCALLID when a file is closed. It
    // removes the file from the list (assuming it is recorded).
    procedure OnCloseFile(var PosBlock);

    // Returns True if it is valid to call UseVariantForNextCall for the
    // specified operation and file.
    function CanUseVariant(Op: Integer; var PosBlock): Boolean;

    // This is called from CreateCustomPrefillCache to disable the Use Variant
    // option (prefilled caches are incompatible with UseVariantForNextCall).
    procedure OnCreateCache(FileName: string; CacheID: LongInt; ClientID: Pointer);

    // This  is called from DropCustomPrefillCache, to re-enable the Use Variant
    // option.
    procedure OnDropCache(CacheID: LongInt; ClientID: Pointer);

    // Returns a count of the number of open variant files recorded in the
    // system.
    property Count: Integer read GetCount;
  end;

// Access routine for the FSQLVariants global singleton.
function SQLVariants: TSQLVariants;

Procedure Finalize_SQLVariantsU;

implementation

uses CompilableVarRec, GlobVar, BtrvU2;

var
  FSQLVariants: TSQLVariants;

// =============================================================================

function SQLVariants: TSQLVariants;
begin
  if not Assigned(FSQLVariants) then
    FSQLVariants := TSQLVariants.Create;
  Result := FSQLVariants;
end;

// =============================================================================
// TSQLVariants
// =============================================================================
procedure TSQLVariants.AddFile(FileName: string; PosBlock: Integer;
  ClientID: Pointer);
var
  VariantFile: TSQLVariantFile;
begin
  FCallProtector.BeginWrite;
  try
    if (IsVariant(FileName) and not AlreadyRecorded(PosBlock)) then
    begin
      VariantFile := TSQLVariantFile.Create;
      VariantFile.PosBlock  := PosBlock;
      VariantFile.FileSpec := FileName;
      VariantFile.TableName := FileNameOnly(FileName);
      if (ClientID <> nil) then
      begin
        VariantFile.ClientID.AppId  := TClientID(ClientID^).AppId;
        VariantFile.ClientID.TaskId := TClientID(ClientID^).TaskId;
      end
      else
      begin
        VariantFile.ClientID.AppId  := #0#0;
        VariantFile.ClientID.TaskId := 0;
      end;
      FList.Add(VariantFile)
    end;
  finally
    FCallProtector.EndWrite;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLVariants.AfterOpenFile(var KeyBuf; var PosBlock;
  ClientID: Pointer);
var
  FileName: string;
  Key: Str255;
  Status: LongInt;
begin
  FileName := Uppercase(PChar(@KeyBuf));
  if (Pos('EXCHQSS.DAT', FileName) <> 0) then
  begin
    { Get the Syss record }
    Key := 'SYS';
    Status := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, 0, Key);
  end;
end;

// -----------------------------------------------------------------------------

function TSQLVariants.AlreadyRecorded(PosBlock: Integer): Boolean;
begin
  Result := (FindEntry(PosBlock) <> -1);
end;

// -----------------------------------------------------------------------------

function TSQLVariants.CanUseVariant(Op: Integer; var PosBlock): Boolean;
var
  VariantFile: TSQLVariantFile;
  EntryPos: Integer;
begin
  Result := False;
  if (Op in VALID_VARIANT_OPERATIONS) then
  begin
    EntryPos := FindEntry(Integer(@PosBlock));
    if (EntryPos <> -1) then
    begin
      VariantFile := TSQLVariantFile(FList[EntryPos]);
      Result := not VariantFile.UsingCache;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLVariants.Clear;
var
  i: Integer;
begin
  FCallProtector.BeginWrite;
  try
    for i := FList.Count - 1 downto 0 do
    begin
      TSQLVariantFile(FList[i]).Free;
      FList[i] := nil;
    end;
    FList.Clear;
  finally
    FCallProtector.EndWrite;
  end;
end;

// -----------------------------------------------------------------------------

constructor TSQLVariants.Create;
begin
  inherited Create;
  FCallProtector := TMultiReadExclusiveWriteSynchronizer.Create;
  FList := TList.Create;
end;

// -----------------------------------------------------------------------------

destructor TSQLVariants.Destroy;
begin
  Clear;
  FreeAndNil(FCallProtector);
  FreeAndNil(FList);
  inherited;
end;

// -----------------------------------------------------------------------------

function TSQLVariants.FileNameOnly(FullFileSpec: string): string;
begin
  Result := Trim(Uppercase(ExtractFileName(FullFileSpec)));
end;

// -----------------------------------------------------------------------------

function TSQLVariants.FindEntry(PosBlock: Integer): Integer;
var
  i: Integer;
begin
  FCallProtector.BeginRead;
  try
    Result := -1;
    for i := 0 to Count - 1 do
    begin
      if (TSQLVariantFile(FList[i]).PosBlock = PosBlock) then
      begin
        Result := i;
        break;
      end;
    end;
  finally
    FCallProtector.EndRead;
  end;
end;

// -----------------------------------------------------------------------------

function TSQLVariants.GetCount: Integer;
begin
  FCallProtector.BeginRead;
  try
    Result := FList.Count;
  finally
    FCallProtector.EndRead;
  end;
end;

// -----------------------------------------------------------------------------

function TSQLVariants.GetEntry(var PosBlock): TSQLVariantFile;
var
  i: Integer;
begin
  FCallProtector.BeginRead;
  try
    Result := nil;
    for i := 0 to Count - 1 do
    begin
      if (TSQLVariantFile(FList[i]).PosBlock = Integer(@PosBlock)) then
      begin
        Result := TSQLVariantFile(FList[i]);
        break;
      end;
    end;
  finally
    FCallProtector.EndRead;
  end;
end;

// -----------------------------------------------------------------------------

function TSQLVariants.IsVariant(FileName: string): Boolean;
const
  Files: array[0..12] of string =
  (
    'MLOCSTK.DAT',
    'EXSTKCHK.DAT',
    'EXCHQCHK.DAT',
    'SETTINGS.DAT',
    'JOBCTRL.DAT',
    'JOBDET.DAT',
    'JOBMISC.DAT',
    'NOMVIEW.DAT',
    'EBUS.DAT',
    'EBUSLKUP.DAT',
    'DICTNARY.DAT',
    'SENTLINE.DAT',
    'TILLNAME.DAT'
  );
var
  i: Integer;
begin
  FCallProtector.BeginRead;
  try
    Result := False;
    FileName := FileNameOnly(FileName);
    for i := Low(Files) to High(Files) do
      if Files[i] = FileName then
      begin
        Result := True;
        break;
      end;
  finally
    FCallProtector.EndRead;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLVariants.OnCloseFile(var PosBlock);
begin
  RemoveEntry(Integer(@PosBlock));
end;

// -----------------------------------------------------------------------------

procedure TSQLVariants.OnCreateCache(FileName: string; CacheID: LongInt;
  ClientID: Pointer);
var
  i: Integer;
  VariantFile: TSQLVariantFile;

  function MatchingClient: Boolean;
  begin
    Result := True;
    if (ClientID <> nil) then
    begin
      Result :=
        (VariantFile.ClientID.AppId  = TClientID(ClientID^).AppId) and
        (VariantFile.ClientID.TaskId = TClientID(ClientID^).TaskId);
    end
    else if (VariantFile.ClientID.AppID <> #0#0) then
      Result := False;
  end;

begin
  FCallProtector.BeginRead;
  try
    FileName := FileNameOnly(FileName);
    for i := 0 to Count - 1 do
    begin
      VariantFile := TSQLVariantFile(FList[i]);
      if (VariantFile.TableName = FileName) and MatchingClient then
      begin
        VariantFile.UsingCache := True;
        VariantFile.CacheID := CacheID;
        break;
      end;
    end;
  finally
    FCallProtector.EndRead;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLVariants.OnDropCache(CacheID: LongInt; ClientID: Pointer);
var
  i: Integer;
  VariantFile: TSQLVariantFile;

  function MatchingClient: Boolean;
  begin
    Result := True;
    if (ClientID <> nil) then
    begin
      Result :=
        (VariantFile.ClientID.AppId  = TClientID(ClientID^).AppId) and
        (VariantFile.ClientID.TaskId = TClientID(ClientID^).TaskId);
    end
    else if (VariantFile.ClientID.AppID <> #0#0) then
      Result := False;
  end;

begin
  FCallProtector.BeginRead;
  try
    for i := 0 to Count - 1 do
    begin
      VariantFile := TSQLVariantFile(FList[i]);
      if (VariantFile.CacheID = CacheID) and MatchingClient then
      begin
        VariantFile.UsingCache := False;
        VariantFile.CacheID := 0;
        break;
      end;
    end;
  finally
    FCallProtector.EndRead;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLVariants.OnOpenFile(var KeyBuf; var PosBlock; ClientID: Pointer = nil);
var
  FileName: string;
begin
  FileName := PChar(@KeyBuf);
  AddFile(FileName, Integer(@PosBlock), ClientID);
end;

// -----------------------------------------------------------------------------

procedure TSQLVariants.RemoveEntry(PosBlock: Integer);
var
  i: Integer;
begin
  FCallProtector.BeginWrite;
  try
    for i := 0 to Count - 1 do
    begin
      if (TSQLVariantFile(FList[i]).PosBlock = PosBlock) then
      begin
        TSQLVariantFile(FList[i]).Free;
        FList.Delete(i);
        break;
      end;
    end;
  finally
    FCallProtector.EndWrite;
  end;
end;

// -----------------------------------------------------------------------------

{ TSQLVariantFile }

constructor TSQLVariantFile.Create;
begin
  inherited Create;
//  Redirector := nil;
  FRedirectors := TSQLRedirectorCache.Create;
end;

// -----------------------------------------------------------------------------

destructor TSQLVariantFile.Destroy;
begin
//  if Assigned(Redirector) then
//    FreeAndNil(Redirector);
  FreeAndNil(FRedirectors);
  inherited;
end;

// -----------------------------------------------------------------------------

function TSQLVariantFile.GetRedirector(Prefix,
  SubType: Char): TSQLRedirector;
begin
  Result := FRedirectors[Prefix, SubType];
end;

// -----------------------------------------------------------------------------

function TSQLVariantFile.PrefixForRecordAddress(RecAddress: Integer;
  var Prefix, SubType: Char): Boolean;
begin
  Result := FRedirectors.PrefixForRecordAddress(RecAddress, TableName, Prefix, SubType);
end;

// -----------------------------------------------------------------------------

function TSQLVariantFile.RedirectorForRecordAddress(
  RecAddress: Integer): TSQLRedirector;
begin
  Result := FRedirectors.RedirectorForRecordAddress(RecAddress);
end;

// -----------------------------------------------------------------------------

procedure TSQLVariantFile.SetLastRedirector(const Value: TSQLRedirector);
begin
  FLastRedirector := Value;
end;

// -----------------------------------------------------------------------------

procedure TSQLVariantFile.SetRedirector(Prefix, SubType: Char;
  const Value: TSQLRedirector);
begin
  FRedirectors[Prefix, SubType] := Value;
end;

// -----------------------------------------------------------------------------

Procedure Finalize_SQLVariantsU;
Begin // Finalize_SQLVariantsU
  if Assigned(FSQLVariants) then
    FreeAndNil(FSQLVariants);
End; // Finalize_SQLVariantsU

//-------------------------------------------------------------------------

initialization
  FSQLVariants := nil;
finalization
// MH 15/03/2010 v6.3: Moved into Finalize_SQLVariantsU as getting problems with order of finalizations
//  if Assigned(FSQLVariants) then
//    FreeAndNil(FSQLVariants);
end.
