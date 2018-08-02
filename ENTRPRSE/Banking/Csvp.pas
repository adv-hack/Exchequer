unit csvp;
//------------------------------------------------------------------------------//
//                                CSV Parser components                         //
//                        Written by Paul Rutherford 12/2/2001                  //
//------------------------------------------------------------------------------//

interface
{ nfrewer440 16:07 13/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

uses
  Classes, Forms;

type
  TCSVFieldEvent = procedure(const FieldName, FieldValue : string; FieldNo : integer) of Object;
  TCSVLineEvent = procedure(LineNo : longint; AList : TStrings; var Abort : Boolean) of Object;
  TParseLineFunc = function : integer of Object;

{TCsvLineParser will separate a line into fields using the Separator character which
defaults to a comma. A Delimiter character can also be set. The values of the fields
are put into the ValueList property in order of reading.  ValueList remains available until
another line is parsed.

As each value is read, the OnReadValue event is triggered.

A TStrings containing the names of fields in order can be assigned to the NameList property,
enabling the OnReadValue event to pass the name of a field as well as its number and value.

Call the Execute method to parse the line set in the Line property}

  TCsvLineParser = Class(TComponent)
    private
      FNameList : TStrings;
      FValueList : TStringList;
      FString : string;
      FOnReadValue : TCSVFieldEvent;
      FSeparator : Char;
      FDelimiter : Char;
      InString : Boolean;
      FUseDelimiter : Boolean;
    protected
      procedure SetDelimiter(AValue : String);
      function GetDelimiter : string;
    public
      constructor Create(AOwner : TComponent); override;
      destructor Destroy; override;
      function Execute : Integer; virtual;
      property Line : string read FString write FString;
      property ValueList : TStringList read FValueList write FValueList;
      property NameList : TStrings read FNameList write FNameList;
    published
      property Separator : Char read FSeparator write FSeparator;
      property Delimiter : String read GetDelimiter write SetDelimiter;
      property OnReadValue : TCSVFieldEvent read FOnReadValue write FOnReadValue;
    end;

{========================================================================================}

{TCsvFileParser has the same properties as TCsvLineParser but overrides the Execute
method in order to read and parse each line of the textfile named in the
FileName property.  Parsing starts at the line indicated in the StartLine property.
This assumes that the first line in the file is line 1.

An OnReadLine event is added which enables the user to take action after each line
has been read.  The line number and ValueList are available in this event}

  TCsvFileParser = Class(TCsvLineParser)
    private
      FFileName : string;
      FStartLine : longint;
      FOnReadLine : TCSVLineEvent;
      FLastLine : longint;
      FKeepFileOpen : Boolean;
      F : TextFile;
      FFileOpen : Boolean;
      FSortList : TStringList;
      FCompareProc : TStringListSortCompare;
      FOnEOF : TNotifyEvent;
      OldFileMode : Byte;
      FParseLine : TParseLineFunc;
    public
      constructor Create(AOwner : TComponent); override;
      destructor Destroy; override;
      function Execute : Integer; Override;
      procedure Sort;
      property CompareProc : TStringListSortCompare read FCompareProc write FCompareProc;
    published
      property FileName : string read FFileName write FFileName;
      property StartLine : longint read FStartLine write FStartLine;
      property OnReadLine : TCSVLineEvent read FOnReadLine
                                          write FOnReadLine;
      property LastLine : longint read FLastLine write FLastLine;
      property KeepFileOpen : Boolean read FKeepFileOpen write FKeepFileOpen;
      property OnEOF : TNotifyEvent read FOnEOF write FOnEOF;
      property ParseLine : TParseLineFunc read FParseLine write FParseLine;
  end;

  TFixedLengthLineParser = Class
  private
    FLine : string;
    FFields : Array of Integer;
    FFieldCount : Integer;
    FValues : TStrings;
    function GetField(Index: Integer): Integer;
    procedure SetField(Index: Integer; const Value: Integer);
    procedure SetFieldCount(const Value: integer);
  public
    destructor Destroy; override;
    function Execute : Integer;
    property Field[Index : Integer] : Integer read GetField write SetField;
    property FieldCount : integer read FFieldCount write SetFieldCount;
    property Line : string read FLine write FLine;
    property Values : TStrings read FValues write FValues;
  end;

procedure Register;




implementation

uses
  SysUtils, APIUtil, Dialogs;


procedure Register;
begin
  RegisterComponents('Samples',[TCsvLineParser, TCsvFileParser]);
end;



constructor TCsvLineParser.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FString := '';
  FNameList := nil;
  FOnReadValue := nil;
  FSeparator := ',';
  FDelimiter := ' ';
  FUseDelimiter := False;
  FValueList := TStringList.Create;
end;

destructor TCsvLineParser.Destroy;
begin
  FValueList.Free;
  inherited Destroy;
end;

function TCsvLineParser.Execute : Integer;
var
  i, j : integer;
  s, s1 : string;
  FieldCount, CharCount : integer;

  function RemoveDelimiter(const s2 : string) : string;
  begin
    Result := s2;
    if Length(Result) > 0 then
    begin
      if Result[1] = FDelimiter then
        Delete(Result, 1, 1);
      if Result[Length(Result)] = FDelimiter then
        Delete(Result, Length(Result),1);
    end;
  end;

begin
  Result := 0;
  if Length(FString) > 1 then
  begin
    if FString[1] = '"' then
    begin
      FDelimiter := '"';
      FUseDelimiter := True;
    end;
    FieldCount := 0;
    FValueList.Clear;
    InString := False;
    i := 1;
    j := i;
    Repeat
      Try
        while (i < Length(FString)) and ((FString[i] <> FSeparator) or InString) do
        begin
          if (FString[i] = Delimiter) and (FUseDelimiter) then
            InString := not InString;
          Application.ProcessMessages;
          inc(i);
        end;

        if i >= length(FString) then
        begin
          if (i = Length(FString)) and (FString[i] = ',') then
            CharCount := i - j
          else
            CharCount := i - j + 1;
        end
        else
          CharCount := i - j;

        s := Copy(FString, j, CharCount);
        if FUseDelimiter then
          s := RemoveDelimiter(Trim(s));
          
        FValueList.Add(s);
        inc(i);
        j := i;

        s1 := '';
        if Assigned(FNameList) then
         if FNameList.Count > FieldCount then
          s1 := FNameList[FieldCount];

        if Assigned(FOnReadValue) then
          FOnReadValue(s1, s, FieldCount);

        Inc(FieldCount);

        Application.ProcessMessages;
      Except
        Raise;
      End;
    Until i > Length(FString);

    if FString[Length(FString)] = FSeparator then
      FValueList.Add('');
  end;{if}

end;

procedure TCsvLineParser.SetDelimiter(AValue : String);
begin
  FDelimiter := #0;
  if Length(AValue) > 0 then
    FDelimiter := AValue[1];
  FUseDelimiter := Length(AValue) > 0;
end;

function TCsvLineParser.GetDelimiter : String;
begin
  Result := FDelimiter;
end;

{========================================================================================}

constructor TCsvFileParser.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFileName := '';
  FStartLine := 0;
  FFileOpen := False;
  FKeepFileOpen := False;
  OldFileMode := FileMode;
  FileMode := fmOpenRead or fmShareDenyNone;
end;

destructor TCsvFileParser.Destroy;
begin
  if FFileOpen then
    CloseFile(F);
  FileMode := OldFileMode;
end;

procedure TCsvFileParser.Sort;
var
  HeaderLine : string;
begin
  if Assigned(FCompareProc) then
  begin
    FSortList := TStringList.Create;
    Try
      FSortList.LoadFromFile(FFilename);
      HeaderLine := FSortList[0];
      FSortList.Delete(0);
      FSortList.CustomSort(FCompareProc);
      FSortList.Insert(0, HeaderLine);
      FSortList.SaveToFile(FFileName);
    Finally
      FSortList.Free;
    End;
  end;
end;

function TCsvFileParser.Execute : Integer;
var
  LineCount : longint;
  ThisLine : string;
  Abort : Boolean;
  IORes : Integer;
begin
  Result := 0;
  if not (FFileOpen and FKeepFileOpen) then
  begin
    AssignFile(F, FFileName);
    {$I-}
    Reset(F);
    IORes := IOResult;
    if IORes = 0 then
       FFileOpen := True
    else
    begin
      Case IORes of
        32 :  msgBox('The file ' + QuotedStr(FFilename) + ' is currently in use by another application.'#10#10 +
                'Please close the file and try again', mtError, [mbOK], mbOK, 'Import Bank Statement');
        else
          msgBox(Format('IO Error %d occurred while trying to open file ''%s''', [IORes, FFileName]),
                  mtError, [mbOK], mbOK, 'Import Bank Statement');
      end; //Case
      Result := IORes;
    end;
    {$I+}
  end;
  if FFileOpen then
  Try
    LineCount := 1;
    Try
     Abort := False;
     While not EOF(F) and not Abort do
     begin

      if FStartLine > 1 then
      begin
        while not Eof(F) and (LineCount < StartLine) do
        begin
          Application.ProcessMessages;
          ReadLn(F, ThisLine);
          inc(LineCount);
        end;
      end;

      ReadLn(F, ThisLine);
      FString := ThisLine;

      if Assigned(FParseLine) then
        FParseLine
      else
        inherited Execute; //Calls default csv line parser

      if Assigned(FOnReadLine) then
        FOnReadLine(LineCount, ValueList, Abort);

      inc(LineCount);
      FLastLine := LineCount;
     end;
    Except
     Raise;
    End;
  Finally
   if Assigned(FOnEOF) then
     FOnEOF(Self);
   if FFileOpen and not FKeepFileOpen then
   begin
     FFileOpen := False;
     CloseFile(F);
   end;
  End;
end;



{ TFixedLengthLineParser }

destructor TFixedLengthLineParser.Destroy;
begin
  Finalize(FFields);
  inherited;
end;

function TFixedLengthLineParser.Execute: Integer;
var
  i : integer;
begin
  FValues.Clear;
  for i := 0 to FFieldCount - 1 do
  begin
    FValues.Add(Trim(Copy(FLine, 1, FFields[i])));
    Delete(FLine, 1, FFields[i]);
  end;
  Result := 0;
end;

function TFixedLengthLineParser.GetField(Index: Integer): Integer;
begin
  Result := FFields[Index];
end;

procedure TFixedLengthLineParser.SetField(Index: Integer;
  const Value: Integer);
begin
  FFields[Index] := Value;
end;

procedure TFixedLengthLineParser.SetFieldCount(const Value: integer);
begin
  FFieldCount := Value;
  SetLength(FFields, Value);
end;

end.

