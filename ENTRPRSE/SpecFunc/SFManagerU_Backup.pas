unit SFManagerU;

interface

uses SysUtils, Windows, Controls, Classes, ComCtrls, Contnrs,
  SFHeaderU;

type
  TSFFileType = (sfInvalid, sfUncompressed, sfCompressed);

  { TSFConfiguration handles the configuration file for Special Function DLLs.
    These files are created when the DLL is first accessed, and are used mainly
    for keeping track of expiration details. }
  TSFConfiguration = class(TObject)
  private
    { The name of the currently open file. }
    FFileName: string;

    { The entries for the currently open file. }
    FEntries: TStringList;

    { Creates a new configuration file, and installs the default details. }
    procedure CreateFile(FileName: string);

    { Uses ZLib to uncompress the data from InputStream, outputting the
      uncompressed results in OutputStream. }
    procedure ExpandStream(InputStream, OutputStream: TStream);

    { Returns the file type (compressed or uncompressed) of the specified
      file. Returns stInvalid if it is not a valid configuration file. }
    function FileType(FileName: string): TSFFileType;

    { Reads and uncompresses the configuration file. }
    procedure ReadFile(FileName: string);

    { Writes the configuration to file. If WithCompression is false, the file is
      written to disk without compression, so that it can be read by any text
      viewing program.

      Note that the uncompressed version still includes the opening file
      signature. }
    procedure WriteFile(FileName: string; WithCompression: Boolean);

  public
    constructor Create;
    destructor Destroy; override;

    { Opens the configuration file for the specified DLL. Creates the file if
      it does not exist yet. }
    procedure Open(DLLFileName: string);

    { Returns the installation date (actually, the date when the DLL was first
      accessed by the system). }
    function InstallationDate: TDateTime;

    { Returns True if the DLL has successfully been run at least once. This is
      used for run-once DLLs. }
    function HasRun: Boolean;

    { Returns a Boolean value from the configuration file (this works in the
      same way as reading from an INI file). }
    function ReadBoolean(ValueName: string; DefaultValue: Boolean): Boolean;

    { Returns a Date/Time value from the configuration file (this works in the
      same way as reading from an INI file). }
    function ReadDateTime(ValueName: string; DefaultValue: TDateTime): TDateTime;

    { Writes a Boolean value to the configuration file (this works in the
      same way as writing to an INI file). }
    function WriteBoolean(ValueName: string; const Value: Boolean): Boolean;

    { The configuration entries read from the file. }
    property Entries: TStringList read FEntries;

    { The filename of the currently open configuration file. }
    property FileName: string read FFileName;

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
    FExpiryDate: TDate;
    FFunctionType: TFunctionType;
    FDaysRemaining: Integer;
    { Pointers to the functions in the DLL. }
    FGetDLLTitle: TStringFn;
    FOnDLLExecute: TDLLExecuteFn;
    FGetDLLExpiryDate: TDateFn;
    FGetDLLDaysRemaining: TIntegerFn;
    FGetDLLFunctionType: TByteFn;
    { Reference to function in application. }
    FOnExecute: TExecuteProcedure;
    function GetTitle: string;
    function GetDaysRemaining: Integer;
    function GetExpiryDate: TDate;
    function GetFunctionType: TFunctionType;
  public
    constructor Create;
    destructor Destroy; override;
    function Execute(Params: TSFParams): Boolean;
    function HasExpired: Boolean;
    function LoadFromDLL(FileName: string): Boolean;
    property Config: TSFConfiguration read FConfig;
    property DLLHandle: Integer read FDLLHandle;
    property ErrorCode: Integer read FErrorCode;
    property ErrorMsg: string read FErrorMsg;
    property FromDLL: Boolean read FFromDLL;
    property Title: string read GetTitle write FTitle;
    property FunctionType: TFunctionType read GetFunctionType write FFunctionType;
    property ExpiryDate: TDate read GetExpiryDate write FExpiryDate;
    property DaysRemaining: Integer read GetDaysRemaining write FDaysRemaining;
    property OnDLLExecute: TDLLExecuteFn read FOnDLLExecute;
    property OnExecute: TExecuteProcedure read FOnExecute write FOnExecute;
  end;

  { TFunctionManager deals with loading and running the special functions. }
  TFunctionManager = class(TObject)
  private
    FList: TObjectList;
    function GetFunction(Index: Integer): TSpecialFunction;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;

    { Adds a new special function to the list. }
    procedure Add(Title: string; ExecProc: TExecuteProcedure); overload;

    { Adds a special function from a DLL. If the DLL is not a valid Special
      Function DLL, the function will not be added. }
    procedure Add(DLLFileName: string); overload;

    { Loads functions from any Special Function DLLs found in the specified
      path. }
    procedure LoadFunctions(Path: string);

    { Populates the supplied strings with a list of the special functions. }
    procedure PopulateList(Strings: TStrings);

    { Returns the number of special functions installed (from DLLs and/or from
      the application. }
    property Count: Integer read GetCount;

    { Indexed property into the list of installed functions. }
    property Functions[Index: Integer]: TSpecialFunction read GetFunction;
  end;

implementation

uses ETDateU, ZLib;

const
  { Identifying string -- appears unencrypted at the start of the configuration
    files. The first byte indicates whether or not the file is compressed, and
    the last byte is intended to be the version number. }
  FILE_ID            = #221#183#170#178#200;
  COMPRESSED_FILE_ID = #222#183#170#178#200;

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
  FExpiryDate := 0;
  FFunctionType := ftStd;
  FDaysRemaining := 0;
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
  if Assigned(FOnDLLExecute) then
    Result := OnDLLExecute(Params.Mode, Params.ProgressCallback, Params.OutputCallback)
  else if Assigned(FOnExecute) then
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
  else
    Result := False;
  if Result then  //and (FunctionType = ftRunOnce) then
  begin
    { TODO: Record the fact that the function has successfully been run. }
    Config.WriteBoolean('HAS_RUN', True);
  end;
end;

// -----------------------------------------------------------------------------

function TSpecialFunction.GetDaysRemaining: Integer;
begin
  Result := FDaysRemaining;
  if Assigned(FGetDLLDaysRemaining) then
    Result := FGetDLLDaysRemaining
end;

// -----------------------------------------------------------------------------

function TSpecialFunction.GetExpiryDate: TDate;
begin
  Result := FExpiryDate;
  if Assigned(FGetDLLExpiryDate) then
    Result := FGetDLLExpiryDate;
end;

// -----------------------------------------------------------------------------

function TSpecialFunction.GetFunctionType: TFunctionType;
begin
  Result := FFunctionType;
  if Assigned(FGetDLLFunctionType) then
    Result := TFunctionType(FGetDLLFunctionType);
end;

// -----------------------------------------------------------------------------

function TSpecialFunction.GetTitle: string;
begin
  Result := FTitle;
  if Assigned(FGetDLLTitle) then
    Result := FGetDLLTitle;
end;

// -----------------------------------------------------------------------------

function TSpecialFunction.HasExpired: Boolean;
begin
  if (FunctionType in [ftRunOnce, ftExpiresAfter, ftExpiresOn]) then
  begin
    if (FunctionType = ftRunOnce) then
    begin
      { Has the function successfully been run yet? }
      Result := Config.HasRun;
    end
    else if (FunctionType = ftExpiresAfter) then
    begin
      { Are there more than DaysRemaining days since the function was installed? }
      Result := ((Date - Config.InstallationDate) > DaysRemaining);
    end
    else if (FunctionType = ftExpiresOn) then
    begin
      { Have we reached or gone past the expiry date yet? }
      Result := ExpiryDate <= Date;
    end;
  end
  else
    { Not an expiring function type. }
    Result := False;
end;

function TSpecialFunction.LoadFromDLL(FileName: string): Boolean;
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
    FGetDLLFunctionType := GetProcAddress(FDLLHandle, 'FunctionType');
    if not Assigned(FGetDLLFunctionType) then
    begin
      FErrorCode := -1;
      FErrorMsg  := 'Failed to find FunctionType function in ' + FileName;
      Result := False;
      Exit;
    end;
    FGetDLLExpiryDate := GetProcAddress(FDLLHandle, 'ExpiryDate');
    if not Assigned(FGetDLLExpiryDate) then
    begin
      FErrorCode := -1;
      FErrorMsg  := 'Failed to find ExpiryDate function in ' + FileName;
      Result := False;
      Exit;
    end;
    FGetDLLDaysRemaining := GetProcAddress(FDLLHandle, 'DaysRemaining');
    if not Assigned(FGetDLLDaysRemaining) then
    begin
      FErrorCode := -1;
      FErrorMsg  := 'Failed to find DayRemaining function in ' + FileName;
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
  Config.Open(FileName);
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TFunctionManager
// =============================================================================

procedure TFunctionManager.Add(Title: string; ExecProc: TExecuteProcedure);
var
  Fn: TSpecialFunction;
begin
  Fn := TSpecialFunction.Create;
  Fn.Title := Title;
  Fn.OnExecute := ExecProc;
  FList.Add(Fn);
end;

// -----------------------------------------------------------------------------

procedure TFunctionManager.Add(DLLFileName: string);
var
  Fn: TSpecialFunction;
begin
  Fn := TSpecialFunction.Create;
  if (Fn.LoadFromDLL(DLLFileName)) then
    FList.Add(Fn)
  else
    Fn.Free;
end;

// -----------------------------------------------------------------------------

procedure TFunctionManager.Clear;
begin
  FList.Clear;
end;

// -----------------------------------------------------------------------------

constructor TFunctionManager.Create;
begin
  inherited Create;
  FList := TObjectList.Create;
  FList.OwnsObjects := True;
end;

// -----------------------------------------------------------------------------

destructor TFunctionManager.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

function TFunctionManager.GetCount: Integer;
begin
  Result := FList.Count;
end;

// -----------------------------------------------------------------------------

function TFunctionManager.GetFunction(Index: Integer): TSpecialFunction;
begin
  if (Index < FList.Count) then
    Result := TSpecialFunction(FList[Index])
  else
    raise Exception.Create('Function index out of bounds: ' + IntToStr(Index));
end;

// -----------------------------------------------------------------------------

procedure TFunctionManager.LoadFunctions(Path: string);
var
  SearchRec: TSearchRec;
  Found: Integer;
begin
  if (Path <> '') then
    Path := IncludeTrailingPathDelimiter(Path);
  Found := FindFirst(Path + '*.dll', faAnyFile, SearchRec);
  try
    while (Found = 0) do
    begin
      Add(Path + SearchRec.Name);
      Found := FindNext(SearchRec);
    end;
  finally
    SysUtils.FindClose(SearchRec);
  end;
end;

// -----------------------------------------------------------------------------

procedure TFunctionManager.PopulateList(Strings: TStrings);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Strings.AddObject(Functions[i].Title, Functions[i]);
  end;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TSFConfiguration
// =============================================================================
constructor TSFConfiguration.Create;
begin
  inherited Create;
  FEntries := TStringList.Create;
end;

procedure TSFConfiguration.CreateFile(FileName: string);
begin
  FEntries.Clear;
  FEntries.Add('INSTALL_DATE=' + FormatDateTime(ShortDateFormat, Date));
  FEntries.Add('HAS_RUN=0');
  WriteFile(FileName, False);
end;

// -----------------------------------------------------------------------------

destructor TSFConfiguration.Destroy;
begin
  FEntries.Free;
  inherited;
end;

procedure TSFConfiguration.ExpandStream(InputStream, OutputStream: TStream);
var
  InputBuffer,OutputBuffer: Pointer;
  OutBytes, Size: integer;
begin
  InputBuffer  := nil;
  OutputBuffer := nil;
  Size := InputStream.Size - InputStream.Position;
  if Size > 0 then try
    GetMem(InputBuffer, Size);
    InputStream.Read(InputBuffer^, Size);
    DecompressBuf(InputBuffer, Size, 0, OutputBuffer, OutBytes);
    OutputStream.Write(OutputBuffer^, OutBytes);
  finally
    if InputBuffer <> nil then
      FreeMem(InputBuffer);
    if OutputBuffer <> nil then
      FreeMem(OutputBuffer);
  end;
  OutputStream.Position := 0;
end;

// -----------------------------------------------------------------------------

function TSFConfiguration.FileType(FileName: string): TSFFileType;
var
  FileIn: TFileStream;
  Buffer: array[0..Length(FILE_ID) - 1] of Char;
begin
  FileIn := TFileStream.Create(FileName, fmOpenRead, fmShareDenyNone);
  try
    { Read the first chunk of the file }
    FileIn.Read(Buffer, Length(Buffer));
    { Look for the version's file identifier }
    if (Buffer = FILE_ID) then
      { Uncompressed }
      Result := sfUncompressed
    else if (Buffer = COMPRESSED_FILE_ID) then
      { Compressed }
      Result := sfCompressed
    else
      { Unrecognised buffer -- not a valid configuration file }
      Result := sfInvalid;
  finally
    FileIn.Free;
  end;
end;

// -----------------------------------------------------------------------------

function TSFConfiguration.HasRun: Boolean;
begin
  Result := ReadBoolean('HAS_RUN', False);
end;

// -----------------------------------------------------------------------------

function TSFConfiguration.InstallationDate: TDateTime;
begin
  Result := ReadDateTime('INSTALL_DATE', Now);
end;

// -----------------------------------------------------------------------------

procedure TSFConfiguration.Open(DLLFileName: string);
begin
  FFileName := ChangeFileExt(DLLFileName, '.cfg');
  if not FileExists(FileName) then
    CreateFile(FileName);
  ReadFile(FileName);
end;

// -----------------------------------------------------------------------------

function TSFConfiguration.ReadBoolean(ValueName: string;
  DefaultValue: Boolean): Boolean;
begin
  if (Entries.Values[ValueName] = '') then
    Result := DefaultValue
  else
    Result := (Entries.Values[ValueName] = '1');
end;

// -----------------------------------------------------------------------------

function TSFConfiguration.ReadDateTime(ValueName: string;
  DefaultValue: TDateTime): TDateTime;
begin
  if (Entries.Values[ValueName] = '') then
    Result := DefaultValue
  else
    Result := StrToDate(Entries.Values[ValueName]);
end;

// -----------------------------------------------------------------------------

procedure TSFConfiguration.ReadFile(FileName: string);
var
  InputStream: TFileStream;
  ResultStream: TMemoryStream;
  Version: array[0..Length(FILE_ID) - 1] of Byte;
begin
  ResultStream := nil;
  InputStream := TFileStream.Create(FileName, fmOpenRead, fmShareDenyNone);
  try
    { Read the header }
    InputStream.Read(Version, Length(FILE_ID));
    ResultStream := TMemoryStream.Create;
    { The first byte of the version array indicates whether the file is
      compressed or not }
    if (Version[0] = 221) then
      { Uncompressed file }
      ResultStream.LoadFromStream(InputStream)
    else
      { Compressed file: Expand into ResultStream }
      ExpandStream(InputStream, ResultStream);
    { Read the uncompressed XML data from ResultStream }
    ResultStream.Position := 0;
    FEntries.LoadFromStream(ResultStream);
  finally
    if Assigned(ResultStream) then
      ResultStream.Free;
    InputStream.Free;
  end;
end;

// -----------------------------------------------------------------------------

function TSFConfiguration.WriteBoolean(ValueName: string;
  const Value: Boolean): Boolean;
begin
  if (Value) then
    Entries.Values[ValueName] := '1'
  else
    Entries.Values[ValueName] := '0';
  WriteFile(FileName, False);
end;

// -----------------------------------------------------------------------------

procedure TSFConfiguration.WriteFile(FileName: string; WithCompression: Boolean);
var
  Stream: TFileStream;
  CompressionStream: TCompressionStream;
begin
  CompressionStream := nil;
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    if (WithCompression) then
    begin
      Stream.Write(COMPRESSED_FILE_ID, Length(FILE_ID));
      CompressionStream := TCompressionStream.Create(clDefault, Stream);
      FEntries.SaveToStream(CompressionStream);
    end
    else
    begin
      Stream.Write(FILE_ID, Length(FILE_ID));
      FEntries.SaveToStream(Stream);
    end;
  finally
    if Assigned(CompressionStream) then
      CompressionStream.Free;
    Stream.Free;
  end;
end;

// -----------------------------------------------------------------------------

end.
