unit SFManagerU;

interface

uses SysUtils, Windows, Controls, Classes, ComCtrls, Contnrs, ADODB, ActiveX,
  SFHeaderU, SFPasswordU;

type
  TSFFileType = (sfInvalid, sfUncompressed, sfCompressed);
  TSFFunctionType = (fnHardCoded, fnDLL, fnScript);
  TSFTypeSet = set of TSFFunctionType;

  TSFIDArray = array[0..4] of Char;

  TSFConfigBlock = record
    Identifier: TSFIDArray;
    ID: LongInt;
    Title: string[80];
    InstallDate: TDate;
    ExpiryDate: TDate;
    ExpiryType: TSFExpiryType;
    HasRun: Boolean;
    IsCompressed: Boolean;
    IsPassworded: Boolean;
  end;

  { The Special Function ID List file holds a list of all Special Function
    plugins and Script Files that have been assigned IDs, and returns the
    next available ID.

    The file is formatted as a list of INI file entries ('key=value'), where
    the key is the Special Function title, and the value is the ID. }
  TSFIDFile = class(TObject)
  private
    FFileName: string;
    FuncList: TStringList;
    { Returns True if there is already an entry in the file against the
      specified title. }
    function Exists(Title: string): Boolean;
    { Returns the next available ID. }
    function NextID: Integer;
    procedure SetFileName(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    { Adds a new Special Function to the file. The supplied title must be
      unique (an exception is raised if it is not). Returns the ID that was
      assigned. }
    function Add(Title: string): Integer;
    { Changes an existing title to a new title (the title acts as the unique
      ID, so it is important to do this). }
    procedure ChangeTitle(OldTitle, NewTitle: string);
    { Saves the existing list to file, against the currently assigned
      filename. }
    procedure Save;
    { Filename (including path) of the Special Function ID List file. Assigning
      this value automatically opens the file -- this is done when an instance
      of this class is created (it uses a hard-coded file name), so the file
      is ready for use straight away). }
    property FileName: string read FFileName write SetFileName;
  end;

  { Handles the Configuration Block for Special Function files. The Configuration
    Block is a block of bytes appended to the end of the file, containing details
    mainly relating to password protection and expiry dates. }
  TSFConfiguration = class(TObject)
  private
    FFileName: string;
    FFunctionType: TSFFunctionType;
    function GetExpiryType: TSFExpiryType;
    function GetHasBlock: Boolean;
    function GetHasRun: Boolean;
    function GetTitle: string;
    procedure SetFileName(const Value: string);
    function GetInstallDate: TDate;
    procedure SetExpiryType(const Value: TSFExpiryType);
    procedure SetInstallDate(const Value: TDate);
    procedure SetTitle(const Value: string);
    procedure SetHasRun(const Value: Boolean);
    function GetID: Integer;
    procedure SetID(const Value: Integer);
    function GetIsCompressed: Boolean;
    procedure SetIsCompressed(const Value: Boolean);
    function GetExpiryDate: TDate;
    procedure SetExpiryDate(const Value: TDate);
    function GetIsPassworded: Boolean;
    procedure SetIsPassworded(const Value: Boolean);
  public
    Block: TSFConfigBlock;

    { Returns true if the currently assigned file is a DLL. Raises an exception
      if there is no currently assigned file. }
    function IsDLL: Boolean;

    { Returns the next available file ID. }
    function NextID: LongInt;

    { Reads the Config Block from the end of the currently assigned file,
      returning False if no Config Block can be found. Raises an exception if
      there is no currently assigned file. }
    function Read: Boolean;

    { Writes the contents of the Config Block record to the currently assigned
      file, creating a new block if the file does not contain one. If the block
      cannot be written for some reason, returns False. Raises an exception if
      there is no currently assigned file. }
    function Write: Boolean;

    { Holds the filename of the currently assigned file. Assigning a filename
      will open the file, and read the contents of the Config Block (if any)
      into the Block record. }
    property FileName: string read FFileName write SetFileName;

    { Returns True if the currently assigned file contains a Config Block. If
      there is no currently assigned file, always returns False. }
    property HasBlock: Boolean read GetHasBlock;

    { Returns the ID of the function. }
    property ID: Integer read GetID write SetID;

    { Returns the title of the function. }
    property Title: string read GetTitle write SetTitle;

    { Returns the function expiry type: ftStd, ftRunOnce, ftExpiresAfter }
    property ExpiryType: TSFExpiryType read GetExpiryType write SetExpiryType;

    { Returns the expiry date, if set (will return 0 otherwise) }
    property ExpiryDate: TDate read GetExpiryDate write SetExpiryDate;

    { Returns the installation date of the plugin (actually, the date on which
      it was first accessed by the Function Manager). }
    property InstallDate: TDate read GetInstallDate write SetInstallDate;

    { Returns True if the function has successfully been run at least once. }
    property HasRun: Boolean read GetHasRun write SetHasRun;

    { Returns True if the file is compressed. This is only relevant for Script
      files (other file types will always return False). }
    property IsCompressed: Boolean read GetIsCompressed write SetIsCompressed;

    { Returns True if the function requires a password before being run. }
    property IsPassworded: Boolean read GetIsPassworded write SetIsPassworded;

    { Holds the function type -- fnHardCoded, fnDLL, or fnScript }
    property FunctionType: TSFFunctionType read FFunctionType write FFunctionType;
  end;

  { TSpecialFunction holds the details of one function. It can deal with
    functions hard-coded into the application, and with functions from
    external DLLs. }
  TSpecialFunction = class(TObject)
  private
    FConfig: TSFConfiguration;
    FTitle: string;
    FDLLHandle: Integer;
    FErrorCode: Integer;
    FErrorMsg: string;
    FFromDLL: Boolean;

    { Pointers to the functions in the DLL. }
    FGetDLLTitle: TStringFn;
    FOnDLLExecute: TDLLExecuteFn;

    { Reference to function in application. }
    FOnExecute: TExecuteProcedure;

    function GetTitle: string;
  public
    constructor Create;
    destructor Destroy; override;
    function Execute(Params: TSFParams): Boolean;
    function ExecuteDLL(Params: TSFParams): Boolean;
    function ExecuteScript(Params: TSFParams): Boolean;
    function ExecuteHardCodedFunction(Params: TSFParams): Boolean;
    function HasExpired: Boolean;
    function LoadFromDLL(FileName: string): Boolean;
    function LoadFromScript(FileName: string): Boolean;
    property Config: TSFConfiguration read FConfig;
    property DLLHandle: Integer read FDLLHandle;
    property ErrorCode: Integer read FErrorCode;
    property ErrorMsg: string read FErrorMsg;
    property FromDLL: Boolean read FFromDLL;
    property Title: string read GetTitle write FTitle;
    property OnDLLExecute: TDLLExecuteFn read FOnDLLExecute;
    property OnExecute: TExecuteProcedure read FOnExecute write FOnExecute;
  end;

  { TFunctionManager deals with loading and running the special functions. }
  TSFManager = class(TObject)
  private
    FList: TObjectList;
    function GetFunction(Index: Integer): TSpecialFunction;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;

    { Adds a new special function to the list. }
    procedure Add(ID: Integer; Title: string; ExecProc: TExecuteProcedure); overload;

    { Adds a special function from a DLL. If the DLL is not a valid Special
      Function DLL, the function will not be added. }
    procedure Add(FileName: string); overload;

    { Loads function details from any valid Special Function DLLs found in the
      specified path. }
    procedure LoadFunctions(Path: string);

    { Populates the supplied strings with a list of the special functions of
      the specified type. }
    procedure PopulateList(Strings: TStrings; ForTypes: TSFTypeSet);

    { Returns the number of special functions installed (from DLLs and/or from
      the application. }
    property Count: Integer read GetCount;

    { Indexed property into the list of installed functions. }
    property Functions[Index: Integer]: TSpecialFunction read GetFunction;
  end;

  { TSFScript is a class for running SQL Scripts. }
  TSFScript = class(TObject)
  private
    FConnectionString: string;
    FScript: TStrings;
    FLine: Integer;
    FQuery: TADOQuery;
    FErrorMsg: string;
    FOnOutput: TOutputCallback;
    FOnProgress: TProgressCallBack;

    { Retrieves the next SQL statement from the script. }
    function NextStatement: string;

    { Retrieves the connection string for connecting to the SQL database }
    procedure GetConnectionString;

    { Executes an SQL query }
    function RunQuery(Statement: string): Boolean;

    { Outputs a message via the OnOutput callback (if assigned) }
    procedure Output(OutputMsg: ShortString; Style: TOutputStyle = osNormal);

    { Updates any progress display via the OnProgress callback (if assigned) }
    procedure UpdateProgress(MaxTotal, Position: Integer);

    procedure SetScript(const Value: TStrings);
  public
    constructor Create;
    destructor Destroy; override;

    { Runs the current script }
    function Execute: Boolean;

    { Returns any error message generated by the last executed SQL script }
    property ErrorMsg: string read FErrorMsg;

    { Holds the script that is to be executed }
    property Script: TStrings read FScript write SetScript;

    { Callback property for updating an attached progress bar }
    property OnProgress: TProgressCallBack read FOnProgress write FOnProgress;

    { Callback property for output messages }
    property OnOutput: TOutputCallback read FOnOutput write FOnOutput;

  end;

procedure ExpandStream(InputStream, OutputStream: TStream; BytesToCopy: Integer);
procedure LoadScript(FileName: string; Lines: TStrings);
procedure SaveScript(FileName: string; Lines: TStrings; Compressed: Boolean = False);

implementation

uses ETDateU, EntLic, LicRec, ZLib, SQLUtils, GlobVar,
  Dialogs;

const
  { Identifying string for DLLs -- appears at the start of the configuration
    blocks. The last byte is intended to be the version number. }
  ID_DLL_BUFFER:    TSFIDArray = #200#168#170#170#100;

  { Identifying string for Script Files -- appears at the start of the
    configuration blocks. The last byte is intended to be the version number. }
  ID_SCRIPT_BUFFER: TSFIDArray = #200#183#167#184#100;

// =============================================================================
// Compression Routines
// =============================================================================

procedure ExpandStream(InputStream, OutputStream: TStream; BytesToCopy: Integer);
{ Uses ZLib to uncompress the data from InputStream, outputting the uncompressed
  results in OutputStream. Used by the LoadScript routine. }
var
  InputBuffer, OutputBuffer: Pointer;
  ByteCount, Size: integer;
begin
  InputBuffer := nil;
  OutputBuffer := nil;
  Size := InputStream.Size - InputStream.Position;
  if (Size > BytesToCopy) then
    Size := BytesToCopy;
  if Size > 0 then try
    GetMem(InputBuffer, Size);
    InputStream.Read(InputBuffer^, Size);
    DecompressBuf(InputBuffer, Size, 0, OutputBuffer, ByteCount);
    OutputStream.Write(OutputBuffer^, ByteCount);
  finally
    if InputBuffer <> nil then FreeMem(InputBuffer);
    if OutputBuffer <> nil then FreeMem(OutputBuffer);
  end;
  OutputStream.Position := 0;
end;

// -----------------------------------------------------------------------------

procedure LoadScript(FileName: string; Lines: TStrings);
var
  InputStream: TFileStream;
  ResultStream: TMemoryStream;
  BytesToCopy: Integer;
  Block: TSFConfigBlock;
begin
  { Load the script file into the strings, uncompressing it if necessary. }
  ResultStream := nil;
  InputStream := TFileStream.Create(FileName, (fmOpenRead or fmShareDenyNone));
  try
    { Read the file, omitting the configuration block }
    BytesToCopy := InputStream.Size - SizeOf(TSFConfigBlock);
    InputStream.Position := BytesToCopy;
    InputStream.Read(Block, SizeOf(TSFConfigBlock));
    InputStream.Position := 0;
    ResultStream := TMemoryStream.Create;
    if (Block.IsCompressed) then
      { Compressed file: Expand into ResultStream }
      ExpandStream(InputStream, ResultStream, BytesToCopy)
    else
      { Uncompressed file }
      ResultStream.CopyFrom(InputStream, BytesToCopy);
    { Read the uncompressed data from ResultStream }
    ResultStream.Position := 0;
    Lines.LoadFromStream(ResultStream);
  finally
    InputStream.Free;
    ResultStream.Free;
  end;
end;

// -----------------------------------------------------------------------------

procedure SaveScript(FileName: string; Lines: TStrings; Compressed: Boolean);
var
  Stream: TFileStream;
  CompressionStream: TCompressionStream;
begin
  CompressionStream := nil;
  { Save the strings to the script file, compressing if required. }
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    if (Compressed) then
    begin
      CompressionStream := TCompressionStream.Create(clDefault, Stream);
      Lines.SaveToStream(CompressionStream);
    end
    else
    begin
      Lines.SaveToStream(Stream);
    end;
  finally
    if Assigned(CompressionStream) then
      CompressionStream.Free;
    Stream.Free;
  end;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TSpecialFunction
// =============================================================================

constructor TSpecialFunction.Create;
begin
  inherited Create;
  FTitle := '<New>';
  FDLLHandle := 0;
  FErrorCode := 0;
  FErrorMsg := '';
  FFromDLL := False;
  FConfig := TSFConfiguration.Create;
end;

// -----------------------------------------------------------------------------

destructor TSpecialFunction.Destroy;
begin
  FConfig.Free;
  if (DLLHandle <> 0) then
    FreeLibrary(DLLHandle);
  inherited;
end;

// -----------------------------------------------------------------------------

function TSpecialFunction.Execute(Params: TSFParams): Boolean;
begin
  Result := False;
  if Assigned(Params.OutputCallback) then
  begin
    Params.OutputCallback(Config.Title, osSubHeader);
    { Audit trail }
    Params.OutputCallback('Path:'#9#9 + SetDrive, osNormal);
    Params.OutputCallback('Date:'#9#9 + FormatDateTime('dd mmm yyyy', Now), osNormal);
    Params.OutputCallback('Time:'#9#9 + FormatDateTime('hh:nn', Now), osNormal);
    { Line break }
    Params.OutputCallback('', osNormal);
  end;
  case Config.FunctionType of
    fnDLL: Result := ExecuteDLL(Params);
    fnScript: Result := ExecuteScript(Params);
    fnHardCoded: Result := ExecuteHardCodedFunction(Params);
  end;
  if Result then  //and (FunctionType = ftRunOnce) then
  begin
    Config.HasRun := True;
    if Config.IsDLL then
    begin
      { We are about to write the configuration details to the DLL file, so
        we must unload it first. }
      if (DLLHandle <> 0) then
        FreeLibrary(DLLHandle);
      { Write the configuration to the file, then re-load the DLL. }
      Config.Write;
      LoadFromDLL(Config.FileName);
    end
    else
      Config.Write;
  end;
end;

// -----------------------------------------------------------------------------

function TSpecialFunction.ExecuteDLL(Params: TSFParams): Boolean;
begin
  Result := False;
  if Assigned(FOnDLLExecute) then
    Result := OnDLLExecute(Params.Mode, Params.ProgressCallback, Params.OutputCallback)
end;

// -----------------------------------------------------------------------------

function TSpecialFunction.ExecuteHardCodedFunction(
  Params: TSFParams): Boolean;
begin
  Result := False;
  if Assigned(FOnExecute) then
  begin
    try
      OnExecute(Params);
      Result := True;
    except
      on E:Exception do
      begin
        FErrorCode := -1;
        FErrorMsg  := E.Message;
        Result := False;
      end;
    end;
  end
end;

// -----------------------------------------------------------------------------

function TSpecialFunction.ExecuteScript(Params: TSFParams): Boolean;
var
  Runner: TSFScript;
begin
  Result := False;
  Runner := TSFScript.Create;
  try
    LoadScript(Config.FileName, Runner.Script);
    Runner.OnProgress := Params.ProgressCallback;
    Runner.OnOutput   := Params.OutputCallback;
    Result := Runner.Execute;
    if not Result then
    begin
      FErrorCode := -1;
      FErrorMsg  := Runner.ErrorMsg;
    end;
  finally
    Runner.Free;
  end;
end;

// -----------------------------------------------------------------------------

function TSpecialFunction.GetTitle: string;
begin
  Result := FTitle;
  if Assigned(FGetDLLTitle) then
    Result := FGetDLLTitle
  else if Config.FunctionType = fnScript then
    Result := Config.Title;
end;

// -----------------------------------------------------------------------------

function TSpecialFunction.HasExpired: Boolean;
begin
  { Default as a non-expiring function type. }
  Result := False;
  if (Config.Block.ExpiryType in [etRunOnce, etExpiresOn]) then
  begin
    if (Config.ExpiryType = etRunOnce) then
    begin
      { Has the function successfully been run yet? }
      Result := Config.HasRun;
    end
    else if (Config.ExpiryType = etExpiresOn) then
    begin
      { Have we gone past the expiry date? }
      Result := (SysUtils.Date > Config.ExpiryDate);
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TSpecialFunction.LoadFromDLL(FileName: string): Boolean;
begin
  Config.FileName := FileName;
  Config.FunctionType := fnDLL;
  Result := Config.Read;
  if Result then
  begin
    FFromDLL := True;
    FDLLHandle := LoadLibrary(PChar(FileName));
    if FDLLHandle <> 0 then
    begin
      FGetDLLTitle := GetProcAddress(FDLLHandle, 'Title');
      if not Assigned(FGetDLLTitle) then
      begin
        FErrorCode := -1;
        FErrorMsg  := 'Failed to find Title function in ' + FileName;
        Result := False;
        Exit;
      end;
      FOnDLLExecute := GetProcAddress(FDLLHandle, 'Execute');
      if not Assigned(FOnDLLExecute) then
      begin
        FErrorCode := -1;
        FErrorMsg  := 'Failed to find Execute function in ' + FileName;
        Result := False;
        Exit;
      end;
      Result := True;
    end
    else
    begin
      FErrorCode := GetLastError;
      FErrorMsg  := 'Failed to load ' + FileName;
      Result := False;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TSpecialFunction.LoadFromScript(FileName: string): Boolean;
begin
  Config.FileName := FileName;
  Config.FunctionType := fnScript;
  Config.Read;
  Result := True;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TSFManager
// =============================================================================

procedure TSFManager.Add(ID: Integer; Title: string; ExecProc: TExecuteProcedure);
var
  Fn: TSpecialFunction;
begin
  Fn := TSpecialFunction.Create;
  Fn.Title := Title;
  Fn.OnExecute := ExecProc;
  Fn.Config.ID := ID;
  Fn.Config.FunctionType := fnHardCoded;
  FList.Add(Fn);
end;

// -----------------------------------------------------------------------------

procedure TSFManager.Add(FileName: string);
var
  Fn: TSpecialFunction;
begin
  Fn := TSpecialFunction.Create;
  if (ExtractFileExt(FileName) = '.dll') and Fn.LoadFromDLL(FileName) then
  begin
    FList.Add(Fn);
  end
  else if (ExtractFileExt(FileName) = '.scr') and Fn.LoadFromScript(FileName) then
  begin
    FList.Add(Fn);
  end
  else
    Fn.Free;
end;

// -----------------------------------------------------------------------------

procedure TSFManager.Clear;
begin
  FList.Clear;
end;

// -----------------------------------------------------------------------------

constructor TSFManager.Create;
begin
  inherited Create;
  FList := TObjectList.Create;
  FList.OwnsObjects := True;
end;

// -----------------------------------------------------------------------------

destructor TSFManager.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

function TSFManager.GetCount: Integer;
begin
  Result := FList.Count;
end;

// -----------------------------------------------------------------------------

function TSFManager.GetFunction(Index: Integer): TSpecialFunction;
begin
  if (Index < FList.Count) then
    Result := TSpecialFunction(FList[Index])
  else
    raise Exception.Create('Function index out of bounds: ' + IntToStr(Index));
end;

// -----------------------------------------------------------------------------

procedure TSFManager.LoadFunctions(Path: string);
var
  SearchRec: TSearchRec;
  Found: Integer;
  Ext: string;
begin
  if (Path <> '') then
    Path := IncludeTrailingPathDelimiter(Path);
  Found := FindFirst(Path + '*.*', faAnyFile, SearchRec);
  try
    while (Found = 0) do
    begin
      Ext := Lowercase(ExtractFileExt(SearchRec.Name));
      if (Ext = '.scr') or (Ext = '.dll') then
        Add(Path + SearchRec.Name);
      Found := FindNext(SearchRec);
    end;
  finally
    SysUtils.FindClose(SearchRec);
  end;
end;

// -----------------------------------------------------------------------------

procedure TSFManager.PopulateList(Strings: TStrings; ForTypes: TSFTypeSet);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    if Functions[i].Config.FunctionType in ForTypes then
      Strings.AddObject('[' + Format('%.3d', [Functions[i].Config.ID]) + '] ' + Functions[i].Title, Functions[i]);
  end;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TSFConfiguration
// =============================================================================

function TSFConfiguration.GetExpiryDate: TDate;
begin
  Result := Block.ExpiryDate;
end;

// -----------------------------------------------------------------------------

function TSFConfiguration.GetExpiryType: TSFExpiryType;
begin
  Result := Block.ExpiryType;
end;

// -----------------------------------------------------------------------------

function TSFConfiguration.GetHasBlock: Boolean;
begin
  if (FileName = '') then
    raise ESFManager.Create('No file assigned. ');
  Result := ((Block.Identifier = ID_DLL_BUFFER) or (Block.Identifier = ID_SCRIPT_BUFFER));
end;

// -----------------------------------------------------------------------------

function TSFConfiguration.GetHasRun: Boolean;
begin
  Result := Block.HasRun;
end;

// -----------------------------------------------------------------------------

function TSFConfiguration.GetID: Integer;
begin
  Result := Block.ID;
end;

// -----------------------------------------------------------------------------

function TSFConfiguration.GetInstallDate: TDate;
begin
  Result := Block.InstallDate;
end;

// -----------------------------------------------------------------------------

function TSFConfiguration.GetIsCompressed: Boolean;
begin
  Result := Block.IsCompressed;
end;

// -----------------------------------------------------------------------------

function TSFConfiguration.GetIsPassworded: Boolean;
begin
  Result := Block.IsPassworded;
end;

// -----------------------------------------------------------------------------

function TSFConfiguration.GetTitle: string;
begin
  Result := Block.Title;
end;

// -----------------------------------------------------------------------------

function TSFConfiguration.IsDLL: Boolean;
begin
  if (FileName = '') then
    raise ESFManager.Create('No file assigned. ');
  Result := (Lowercase(ExtractFileExt(FileName)) = '.dll');
end;

// -----------------------------------------------------------------------------

function TSFConfiguration.NextID: LongInt;
begin
  Result := 0;
end;

// -----------------------------------------------------------------------------

function TSFConfiguration.Read: Boolean;
var
  Stream: TFileStream;
begin
  if (FileName = '') then
    raise ESFManager.Create('No file assigned. ');
  Result := False;
  if FileExists(FileName) then
  begin
    Stream := TFileStream.Create(FileName, (fmOpenRead or fmShareDenyNone));
    try
      if (Stream.Size > SizeOf(Block)) then
      begin
        Stream.Position := (Stream.Size - SizeOf(Block));
        Stream.Read(Block, SizeOf(Block));
        Result := HasBlock;
      end;
    finally
      Stream.Free;
    end;
  end;
  if not HasBlock then
  begin
    Block.Identifier   := #0#0#0#0#0;
    Block.ID           := 0;
    Block.Title        := FileName;
    Block.InstallDate  := Now;
    Block.ExpiryType   := etStd;
    Block.IsCompressed := False;
    Block.IsPassworded := False;
    Block.ExpiryDate   := 0;
    Block.HasRun       := False;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSFConfiguration.SetExpiryDate(const Value: TDate);
begin
  Block.ExpiryDate := Value;
end;

// -----------------------------------------------------------------------------

procedure TSFConfiguration.SetExpiryType(const Value: TSFExpiryType);
begin
  Block.ExpiryType := Value;
end;

// -----------------------------------------------------------------------------

procedure TSFConfiguration.SetFileName(const Value: string);
begin
  FFileName := Value;
  Read;
end;

// -----------------------------------------------------------------------------

procedure TSFConfiguration.SetHasRun(const Value: Boolean);
begin
  Block.HasRun := Value;
end;

// -----------------------------------------------------------------------------

procedure TSFConfiguration.SetID(const Value: Integer);
begin
  Block.ID := Value;
end;

// -----------------------------------------------------------------------------

procedure TSFConfiguration.SetInstallDate(const Value: TDate);
begin
  Block.InstallDate := Value;
end;

// -----------------------------------------------------------------------------

procedure TSFConfiguration.SetIsCompressed(const Value: Boolean);
begin
  Block.IsCompressed := Value;
end;

// -----------------------------------------------------------------------------

procedure TSFConfiguration.SetIsPassworded(const Value: Boolean);
begin
  Block.IsPassworded := Value;
end;

// -----------------------------------------------------------------------------

procedure TSFConfiguration.SetTitle(const Value: string);
begin
  Block.Title := Value;
end;

// -----------------------------------------------------------------------------

function TSFConfiguration.Write: Boolean;
var
  Stream, TempStream: TFileStream;
  BytesToCopy: LongInt;
  TempFile: file;
  OriginalFileName: AnsiString;
  TempFileName: string;
begin
  if (FileName = '') then
    raise ESFManager.Create('No file assigned. ');
  Result := True;
  { Open the file for reading, and create a temporary new file. }
  Stream := TFileStream.Create(FileName, (fmOpenRead or fmShareExclusive));
  TempFileName := IncludeTrailingPathDelimiter(ExtractFilePath(FileName)) +
                  '~' +
                  ExtractFileName(FileName);
  TempStream := TFileStream.Create(TempFileName, fmCreate);
  try
    { If the file currently has a configuration block, we need to copy the
      file without the block... }
    if (HasBlock) then
      BytesToCopy := (Stream.Size - SizeOf(Block))
    else
    begin
      { ...otherwise just copy the whole file. }
      BytesToCopy := Stream.Size;
      { Make sure we have a valid configuration block identifier. }
      if IsDLL then
        Move(ID_DLL_BUFFER, Block.Identifier, SizeOf(ID_DLL_BUFFER))
      else
        Move(ID_SCRIPT_BUFFER, Block.Identifier, SizeOf(ID_SCRIPT_BUFFER));
    end;
    { Write the existing file to the temporary file. }
    TempStream.CopyFrom(Stream, BytesToCopy);
    { Add the configuration block at the end. }
    TempStream.Write(Block, SizeOf(Block));
  finally
    TempStream.Free;
    Stream.Free;
  end;
  { Delete the original file. Rename the temporary file. }
  OriginalFileName := FileName;
  DeleteFile(PChar(OriginalFileName));
  AssignFile(TempFile, TempFileName);
  Rename(TempFile, FileName);
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TSFIDFile
// =============================================================================

function TSFIDFile.Add(Title: string): Integer;
begin
  if not Exists(Title) then
  begin
    Result := NextID;
    FuncList.Add(Title + '=' + IntToStr(Result));
  end
  else
    raise ESFManager.Create('A Special Function called "' + Title + '" already exists');
end;

// -----------------------------------------------------------------------------

procedure TSFIDFile.ChangeTitle(OldTitle, NewTitle: string);
var
  i: Integer;
  ID: string;
begin
  i := FuncList.IndexOfName(OldTitle);
  if (i <> -1) then
  begin
    ID := FuncList.Values[OldTitle];
    FuncList[i] := NewTitle + '=' + ID;
  end
  else
    raise ESFManager.Create('Could not find Special Function "' + OldTitle + '" in Function List file');
end;

// -----------------------------------------------------------------------------

constructor TSFIDFile.Create;
begin
  inherited Create;
  FuncList := TStringList.Create;
  FileName := 'x:\Entrprse\SpecFunc\funclist.txt';
end;

// -----------------------------------------------------------------------------

destructor TSFIDFile.Destroy;
begin
  FuncList.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

function TSFIDFile.Exists(Title: string): Boolean;
begin
  Result := (FuncList.Values[Title] <> '');
end;

// -----------------------------------------------------------------------------

function TSFIDFile.NextID: Integer;
var
  FuncName: string;
begin
  Result := 1;
  if (FuncList.Count > 0) then
  begin
    FuncName := FuncList.Names[FuncList.Count - 1];
    Result := StrToIntDef(FuncList.Values[FuncName], 0);
    if (Result = 0) then
      raise ESFManager.Create(FileName + ' contains invalid entries')
    else
      Result := Result + 1;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSFIDFile.Save;
begin
  FuncList.SaveToFile(FileName);
end;

// -----------------------------------------------------------------------------

procedure TSFIDFile.SetFileName(const Value: string);
begin
  FFileName := Value;
  if (FileExists(FileName)) then
    { Open the file }
    FuncList.LoadFromFile(FileName)
  else
    { Assume a new file is required }
    FuncList.Clear;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TSFScript
// =============================================================================

constructor TSFScript.Create;
begin
  inherited Create;
  FScript := TStringList.Create;
  FQuery  := TADOQuery.Create(nil);
end;

// -----------------------------------------------------------------------------

destructor TSFScript.Destroy;
begin
  FQuery.Free;
  FScript.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

function TSFScript.Execute: Boolean;
var
  Statement: string;
  StartTime, StopTime: TDateTime;
begin
  GetConnectionString;
  FQuery.ConnectionString := FConnectionString;
  Result := True;
  FLine  := 0;
  StartTime := Now;
  try
    repeat
      Statement := NextStatement;
      if (Statement <> '') then
      begin
        { Assign and run the query }
        if not RunQuery(Statement) then
        begin
          Result := False;
          Break;
        end;
      end;
    until (Statement = '');
  finally
    StopTime := Now;
    Output('Script started:'#9 + FormatDateTime('dd mmm yyyy hh:nn:ss', StartTime));
    Output('Script finished:'#9 + FormatDateTime('dd mmm yyyy hh:nn:ss', StopTime));
    if not Result then
      Output('Script error:'#9 + ErrorMsg, osWarning);
  end;
end;

// -----------------------------------------------------------------------------

procedure TSFScript.GetConnectionString;
var
  CompanyCode: WideString;
begin
//  FConnectionString := 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=exchsql;Data Source=CSDEV\IRISSQL';
  CompanyCode := SQLUtils.GetCompanyCode(SetDrive);
  SQLUtils.GetConnectionString(CompanyCode, False, FConnectionString, nil);
end;

// -----------------------------------------------------------------------------

function TSFScript.NextStatement: string;
begin
  Result := '';
  { Extract the lines from the script until we either reach the end of the
    script, or we encounter a 'GO' line (which is used to mark the end of
    each individual SQL statement, allowing multiple statements to be
    included in the script). }
  while (FLine <= FScript.Count - 1) do
  begin
    if Uppercase(Trim(FScript[FLine])) = 'GO' then
      Break
    else
      Result := Result + FScript[FLine] + ' ';
    FLine := FLine + 1;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSFScript.Output(OutputMsg: ShortString; Style: TOutputStyle);
begin
  if Assigned(FOnOutput) then
    OnOutput(OutputMsg, Style);
end;

// -----------------------------------------------------------------------------

function TSFScript.RunQuery(Statement: string): Boolean;
var
  CompanyCode: string;
begin
  Result := False;
  try
    FQuery.SQL.Clear;
    CompanyCode := SQLUtils.GetCompanyCode(SetDrive);

    { Manually replace the :Company parameter (this will be the SQL schema name
      that differentiates between multi-company datasets in one database, and
      in fact uses the company code).

      We can't use the normal Delphi Query Parameters system because it does
      not correctly identify the schema part of 'schema.database' when
      replacing parameters. }
    FQuery.SQL.Text := StringReplace(Trim(Statement), ':Company', CompanyCode, [rfReplaceAll]);

    FQuery.ExecSQL;
    Result := True;
  except
    on E:Exception do
    begin
      FErrorMsg := E.Message;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSFScript.SetScript(const Value: TStrings);
begin
  FScript := Value;
end;

// -----------------------------------------------------------------------------

procedure TSFScript.UpdateProgress(MaxTotal, Position: Integer);
begin
  if Assigned(FOnProgress) then
    OnProgress(MaxTotal, Position);
end;

// -----------------------------------------------------------------------------

initialization

  CoInitialize(nil);

finalization

  CoUninitialize;

end.

