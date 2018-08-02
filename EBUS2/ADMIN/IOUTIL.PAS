unit IOUtil;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  SysUtils;

function LengthDesc(StandardLength, ActualLength : integer) : string;

type
  TFileImportExport = class
    private
      fHandle : Text;
      fOpened : boolean;
      fFileName : string;
      fDelimiter : char;      // e.g. double quotes around strings
      fSeparator : char;      // field separator, use #0 for fixed width
      procedure SetFileName(Value : string);
      procedure SetDelimiter(Value : char);
      procedure SetSeparator(Value : char);
      procedure SetOpened(Value : boolean);

    protected
      property Opened : boolean read fOpened write SetOpened;

    public
      property Separator : char read fSeparator write SetSeparator;
      property FileName : string read fFileName write SetFileName;
      property Delimiter : char read fDelimiter write SetDelimiter;

      constructor Create(Name : string);
      destructor Destroy; override;
      procedure CloseIOFile;

      procedure HandleIOError(IOR      :  Integer);

  end; // TFileImportExport

  //=======================================================================

  TFileExport = class(TFileImportExport)
    private
      fFieldCount : integer;  // Number of fields on the current line

    protected
      function  UseDelimiter : boolean;
      function  ReplaceDelimiter(const Str : string) : string;
      
    public
      procedure CreateExportFile;
      procedure WriteBlank(Width : integer);
      procedure WriteString(Value : string; Width : integer = 0;
        IgnoreDelimiter : boolean = false);
      procedure WriteBool(Value : boolean);
      procedure WriteNum(Value : double; Len, DP : byte);
      procedure NewLine;
  end; // TFileExport

  //=======================================================================

  TFileImport = class(TFileImportExport)
    private
      fCurLine : ansistring;
      fLineCount : integer;
      fCurLinePos : integer;
      procedure SetCurLine(Value : ansistring);
    public
      property CurLine : ansistring read fCurLine write SetCurLine;
      property LineCount : integer read fLineCount;
      procedure OpenImportFile; virtual;
      procedure ReadBlank(Width : integer);
      function  ReadImportLine : boolean;
      function  ReadString(Width : integer) : string;
      function  ReadInteger(Width : integer) : integer;
      function  ReadIntegerMsg(Width : integer; Msg : string) : integer;
      function  ReadFloat(Width : integer) : double;
      function  ReadFloatMsg(Width : integer; Msg : string) : double;
      function  ReadFloatDef(Width : integer; DefaultValue : double) : double;
  end;

  //=======================================================================

  TLogFile = class(TFileImportExport)
    public
      procedure CreateLogFile;
      procedure WriteLogLine(Value : ansistring);
      procedure WriteLogLineFmt(const FormatStr : string; const Args : array of const);
  end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

uses
  StrUtil, EBusUtil,Dialogs; //, SysUtils;

//=======================================================================

function LengthDesc(StandardLength, ActualLength : integer) : string;
// Notes : Compares 2 values and returns a description of relative sizes.
//         e.g. Use for reporting on imported data line lengths.
begin
  Result := 'correct';
  if ActualLength < StandardLength then
    Result := 'too short'
  else
    if ActualLength > StandardLength then
      Result := 'too long';
end; // LengthDesc

//=======================================================================

procedure TFileImportExport.SetOpened(Value : boolean);
begin
  fOpened := Value;
end;

//-----------------------------------------------------------------------

procedure TFileImportExport.SetSeparator(Value : char);
begin
  if fSeparator <> Value then
    fSeparator := Value;
end;

//-----------------------------------------------------------------------

procedure TFileImportExport.SetDelimiter(Value : char);
begin
  if fDelimiter <> Value then
    fDelimiter := Value;
end;

//-----------------------------------------------------------------------

procedure TFileImportExport.SetFileName(Value : string);
begin
  if fFileName <> Value then
    fFileName := Value;
end;

//-----------------------------------------------------------------------

constructor TFileImportExport.Create(Name : string);
begin
  inherited Create;
  FileName := Name;
  Delimiter := #0;
  Separator := #0;
end;

//-----------------------------------------------------------------------

procedure TFileImportExport.CloseIOFile;
begin
  try
    CloseFile(fHandle);
  except ;
  end;
end;

//-----------------------------------------------------------------------

destructor TFileImportExport.Destroy;
begin
  CloseIOFile;
  inherited Destroy;
end;


//=======================================================================



//-----------------------------------------------------------------------

procedure TFileImportExport.HandleIOError(IOR      :  Integer);

Var
  LocalIOResult  :  Integer;

Begin
  LocalIOResult:=IOR;

  ShowMessage('IO Error writing to '+FileName+#13+
              'Error Code '+IntToStr(LocalIOResult)+#13+SysErrorMessage(LocalIOResult));

end;

//=======================================================================

procedure TFileExport.CreateExportFile;
begin
  AssignFile(fHandle,FileName);
  rewrite(fHandle);
  // Allow EInOutError to propagate so calling code can handle appropriately
  Opened := true;
end;

//-----------------------------------------------------------------------

function TFileExport.UseDelimiter : boolean;
begin
  Result := Delimiter <> #0;
end;

//-----------------------------------------------------------------------

function TFileExport.ReplaceDelimiter(const Str : string) : string;
var
  ReplaceChar : char;
begin
  case Delimiter of
    '"'  : ReplaceChar := '''';
    '''' : ReplaceChar := '"';
  end;
  Result := StringReplace(Str, Delimiter, ReplaceChar, [rfReplaceAll]);
end;

//-----------------------------------------------------------------------

procedure TFileExport.WriteString(Value : string; Width : integer = 0;
  IgnoreDelimiter : boolean = false);
begin
  if not Opened then
    CreateExportFile;

  if Separator <> #0 then
  begin // CSV etc.
    Value := Trim(Value);
    if UseDelimiter and not IgnoreDelimiter then
      Value := Delimiter + ReplaceDelimiter(Value) + Delimiter;
    if fFieldCount > 0 then
      Value := Separator + Value;
  end
  else
  begin // Fixed width
    if length(Value) > Width then
      Value := copy(Value,1,Width)
    else
      if Width > length(Value) then
        Value := PadString(psRight, Value, ' ',Width);
  end;

  write(fHandle,Value);
  inc(fFieldCount);
end; // TFileExport.WriteString

//-----------------------------------------------------------------------

procedure TFileExport.WriteBlank(Width : integer);
begin
  WriteString(StringOfChar(' ',Width), Width);
end;

//-----------------------------------------------------------------------

procedure TFileExport.WriteNum(Value : double; Len, DP : byte);
var
  StrValue : string;
begin
  str(Value :Len :DP, StrValue);
  WriteString(StrValue, Len);
end;

//-----------------------------------------------------------------------

procedure TFileExport.WriteBool(Value : boolean);
begin
  if Value then
    WriteString('TRUE',5)
  else
    WriteString('FALSE',5);
end;

//-----------------------------------------------------------------------

procedure TFileExport.NewLine;
begin
  writeln(fHandle);
  fFieldCount := 0;
end;

//=======================================================================

procedure TFileImport.OpenImportFile;
begin
  AssignFile(fHandle,FileName);
  reset(fHandle);
  // Allow EInOutError to propagate so calling code can handle appropriately
  Opened := true;
end;

//-----------------------------------------------------------------------

procedure TFileImport.SetCurLine(Value : ansistring);
begin
  fCurLine := Value;
end;

//-----------------------------------------------------------------------

function TFileImport.ReadImportLine : boolean;
var
  TempLine : ansistring;
begin
  if not Opened then
    OpenImportFile;

  Result := not SeekEof(fHandle);
  if Result then
  begin
    fCurLinePos := 1;
    inc(fLineCount);
    readln(fHandle, TempLine);
    CurLine := TempLine;
  end;
end;  // TFileImport.ReadImportLine

//-----------------------------------------------------------------------

function TFileImport.ReadString(Width : integer) : string;
begin
  if fCurLinePos > length(CurLine) then
    Result := ''
  else
    Result := copy(CurLine, fCurLinePos, Width);
  inc(fCurLinePos,Width);
end;

//-----------------------------------------------------------------------

procedure TFileImport.ReadBlank(Width : integer);
begin
  inc(fCurLinePos,Width);
end;

//-----------------------------------------------------------------------

function TFileImport.ReadInteger(Width : integer) : integer;
var
  Value : string;
begin
  Value := ReadString(Width);
  // Allow conversion errors to propagate - handling of error will differ in each case
  Result := StrToInt(Value);
end; // TFileImport.ReadInteger

//-----------------------------------------------------------------------

function TFileImport.ReadIntegerMsg(Width : integer; Msg : string) : integer;
var
  Value : string;
begin
  Value := ReadString(Width);
  try
    Result := StrToInt(Value);
  except
    on EConvertError do
      // Re-raise same error but add in appropriate message
      raise EConvertError.Create(Msg);
  end;
end; // TFileImport.ReadIntegerMsg

//-----------------------------------------------------------------------

function TFileImport.ReadFloat(Width : integer) : double;
var
  Value : string;
begin
  Value := ReadString(Width);
  // Allow conversion errors to propagate - handling of error will differ in each case
  Result := StrToFloat(Value);
end; // TFileImport.ReadFloat

//-----------------------------------------------------------------------

function TFileImport.ReadFloatMsg(Width : integer; Msg : string) : double;
var
  Value : string;
begin
  Value := ReadString(Width);
  try
    Result := StrToFloat(Value);
  except
    on EConvertError do
      // Re-raise same error but add in appropriate message
      raise EConvertError.Create(Msg);
  end;
end; // TFileImport.ReadFloatMsg

//-----------------------------------------------------------------------

function TFileImport.ReadFloatDef(Width : integer; DefaultValue : double) : double;
// Notes : Traps any conversion exceptions and substitutes the default value
begin
  try
    Result := ReadFloat(Width);
  except
    on EConvertError do
      Result := DefaultValue;
  end;
end; // TFileImport.ReadFloatDef

//=======================================================================

procedure TLogFile.CreateLogFile;
begin
  AssignFile(fHandle,FileName);
  rewrite(fHandle);
  // Allow EInOutError to propagate so calling code can handle appropriately
  Opened := true;
end;

//-----------------------------------------------------------------------

procedure TLogFile.WriteLogLine(Value : ansistring);
begin
  if not Opened then
    CreateLogFile;

  writeln(fHandle,Value);
end;

//-----------------------------------------------------------------------

procedure TLogFile.WriteLogLineFmt(const FormatStr : string; const Args : array of const);
begin
  WriteLogLine(Format(FormatStr, Args));
end;

end.


