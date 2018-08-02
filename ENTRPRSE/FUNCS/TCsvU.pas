unit TCSVu;

{******************************************************************************}
{  TCSV encapsulates an entire CSV file and presents it like a database        }
{  table of rows and fields.                                                   }
{  Each value in the CSV file can either be contained in double quotes or not. }
{  Each row of values can contain a mixture or double-quoted and unquoted      }
{  values.                                                                     }
{  Values can only be separated by commas, not by commas and spaces.           }
{******************************************************************************}

interface

uses classes, SysUtils;

type
  TCSV = class(TObject)
  private
{* internal fields *}
    CSVFile:       TStringList;
    CSVF: TextFile;
    CSVFileLoaded: boolean;
    CurrentToken:  integer;
    CursorPosition: integer;
{* property fields *}
    FCSVFileName:  string;
    FCurrentRecord: string;
    FCurrentRecordNumber: integer;
    FErrorSet: boolean;
    FLastErrorString: string;
{* procedural methods *}
    function  FieldNRecordN(AFieldNumber: integer; ARecordNumber: integer): string;
    function  GetToken: string;
    procedure ResetCursor(ARequestedToken: integer; ARequestedRecordNumber: integer);
    procedure ResetCursorPosition;
    procedure ResetError;
//    function  SkipQuotedTokens(TokenCount: integer): integer; // obsolete
    function  SkipTokens(ATokenCount: integer): integer;
    function  SkipUnQuotedTokens(ATokenCount: integer): integer;
{* getters and setters *}
    function  GetCurrentRecordBlank: boolean;
    function  GetCurrentRecordLength: integer;
    function  GetEOR: boolean;
    function  GetQuotesAndCommas: boolean;
    function  GetRecordCount: integer;
    procedure SetCSVFileName(const Value: string);
    procedure SetCurrentRecord(const Value: string);
    procedure SetCurrentRecordNumber(const Value: integer);
    procedure SetLastErrorString(const Value: string);
    function  GetSysMsg: string;
    function  GetSysMsgSet: boolean;
    procedure SetSysMsg(const Value: string);
  public
    constructor create(ACSVFileName: string; AutoRead: boolean);
    destructor  destroy; override;
    function FieldFromRecord(AFieldNumber: integer; ARecordNumber: integer): string;
    function FieldN(AFieldNumber: integer): string;
    function LoadCSVFile(const AFileName: string): boolean;
    function ValidFieldNumber(AFieldNumber: integer): boolean;
    function ValidRecordNumber(ARecordNumber: integer): boolean;
    function ReadRecord(ARecordNumber: integer): string;
    property CSVFileName: string read FCSVFileName write SetCSVFileName;
    property CurrentRecord: string read FCurrentRecord write SetCurrentRecord;
    property CurrentRecordBlank: boolean read GetCurrentRecordBlank;
    property CurrentRecordLength: integer read GetCurrentRecordLength;
    property CurrentRecordNumber: integer read FCurrentRecordNumber write SetCurrentRecordNumber;
    property EOR: boolean read GetEOR;
    property ErrorSet: boolean read FErrorSet;
    property LastErrorString: string read FLastErrorString;
    property QuotesAndCommas: boolean read GetQuotesAndCommas;
    property RecordCount: integer read GetRecordCount;
    property SysMsg: string read GetSysMsg;
    property SysMsgSet: boolean read GetSysMsgSet;
  end;

implementation

uses TErrorsU;

{ TCSV }

constructor TCSV.create(ACSVFileName: string; AutoRead: boolean);
// If AutoRead is true, the CSV will be read and the CurrentRecord will be the first
// record in the file.
// If AutoRead is false, then each record of the file is read sequentially and the record number is ignored.
begin
  CSVFile := TStringList.create;
  CSVFileName := ACSVFilename;
  if FileExists(CSVFileName) then
    if AutoRead then begin
      LoadCSVFile(ACSVFileName);
      if RecordCount > 0 then
        CurrentRecordNumber := 1; // If there is one, record 1 will become current
    end
    else begin
      AssignFile(CSVF, ACSVFileName);
      reset(CSVF);
    end;
end;

destructor TCSV.destroy;
begin
  if assigned(CSVFile) then
    CSVFile.free;
  if not CSVFileLoaded then
    CloseFile(CSVF);

  inherited destroy;
end;

{* Procedural Methods *}

function TCSV.FieldFromRecord(AFieldNumber, ARecordNumber: integer): string;
// returns a given field from a given record
// If valid, RecordNumber will become the CurrentRecord
begin
  result := 'CSVERROR';
  ResetCursor(AFieldNumber, ARecordNumber);

  if not ValidRecordNumber(ARecordNumber) then
    result := LastErrorString
  else if not ValidFieldNumber(AFieldNumber) then
    result := LastErrorString
  else result := FieldNRecordN(AFieldNumber, ARecordNumber);
end;

function TCSV.FieldNRecordN(AFieldNumber, ARecordNumber: integer): string;
// returns a given field from a given record
begin
  CurrentRecordNumber := ARecordNumber; // set the current record
  result := FieldN(AFieldNumber); // don't reset the CursorPosition first
end;

function TCSV.ValidFieldNumber(AFieldNumber: integer): boolean;
// needs more work
begin
  result := AFieldNumber > 0;
end;

function TCSV.ValidRecordNumber(ARecordNumber: integer): boolean;
// record number must be between 1 and the number of records in the file
begin
  result := not CSVFileLoaded or ((ARecordNumber > 0) and (ARecordNumber <= RecordCount));
  if not result then FLastErrorString := 'CSVERROR_INVALID_RECORD_NUMBER';
end;

function TCSV.ReadRecord(ARecordNumber: integer): string;
// reads given record from file - doesn't set CurrentRecordNumber as that would call this function again.
// Even for blank records CursorPosition can be set to 1 as EOR (EndOfRecord) will return true;
begin
  if ValidRecordNumber(ARecordNumber) then begin
    if CSVFileLoaded then
      CurrentRecord  := CSVFile.Strings[ARecordNumber - 1]
    else begin
      if ARecordNumber = 1 then
        reset(CSVF); // back to the top of the file
      ReadLn(CSVF, FCurrentRecord);
    end;
    ResetCursorPosition;
  end;
end;

function TCSV.FieldN(AFieldNumber: integer): string;
// returns value of Field n from the CurrentRecord
begin
  ResetError;
  if CurrentRecordBlank then begin
    SetLastErrorString('CSVERROR_BLANK_RECORD');
    result := LastErrorString;
  end
  else begin
    ResetCursor(AFieldNumber, CurrentRecordNumber);
    SkipTokens(AFieldNumber - CurrentToken); // sets CursorPosition to start of next token or EndOfRecord
    result := GetToken; // sets CursorPosition to start of next token or EndOfRecord
  end;
end;

function TCSV.LoadCSVFile(const AFileName: string): boolean;
begin
  CSVFile.LoadFromFile(CSVFileName);
  CSVFileLoaded := true;
  CurrentRecordNumber := -1;
  result := true;
end;

procedure TCSV.ResetError;
begin
  FErrorSet := false;
end;

//function TCSV.SkipQuotedTokens(TokenCount: integer): integer;
//// Skips a given number of tokens from the current CursorPosition
//// On return, CursorPosition will be pointing either at the opening quote of next token
//// or, if the remaining tokens have just been skipped, passed the end of the record
//// BJH 2005/09/16 This function is no longer called
//var
//  i: integer;
//  InQuote: boolean;
//  SkipCount: integer;
//begin
//  result    := -1;
//  InQuote   := false;
//  SkipCount := 0;
//
//  for i := CursorPosition to CurrentRecordLength do begin
//    if CurrentRecord[i] = ',' then continue; // ignore separating comma, point to next opening quote
//    if CurrentRecord[i] = '"' then InQuote := not InQuote;
//    if not InQuote then begin // we're pointing at a closing quote
//      inc(SkipCount);
//      inc(CurrentToken);
//      CursorPosition := i;
//      if SkipCount = TokenCount then break;
//    end;
//  end;
//  inc(CursorPosition); // otherwise we'll be pointing at the closing quote
//  inc(CursorPosition); // otherwise we'll be pointing at the delimiting comma
//
//  if SkipCount = TokenCount then // did we skip the required number ?
//    result := CursorPosition;    // return the new CursorPosition
//end;

function TCSV.SkipUnQuotedTokens(ATokenCount: integer): integer;
// Skips a given number of tokens from the current CursorPosition
// On return, CursorPosition will be pointing at the first character of the next token
// or passed the end of the record if the remaining tokens have just been skipped
// BJH 2005/09/16 modified to allow a mixture of quoted and unquoted tokens in the same record
//                Also modified to return the number of skipped tokens rather CursorPosition.
var
  i: integer;
  SkipCount: integer;
  InQuote: boolean;
begin
  result    := -1;
  if EOR then exit;

  SkipCount := 0;
  InQuote := false;

  for i := CursorPosition to CurrentRecordLength do begin
    if CurrentRecord[i] = '"' then InQuote := not InQuote;
    if ((CurrentRecord[i] = ',') and not InQuote) or (i = CurrentRecordLength) then begin
      inc(SkipCount);
      inc(CurrentToken);
      CursorPosition := i;
      if SkipCount = ATokenCount then break;
    end;
  end;
  inc(CursorPosition); // otherwise we'll be pointing at the delimiting comma

//  if SkipCount = TokenCount then // did we skip the required number ?
//    result := CursorPosition;    // return the new CursorPosition
  result := SkipCount;    // return the number of Tokens skipped
end;

function TCSV.SkipTokens(ATokenCount: integer): integer;
// BJH 2005/09/16 Assume every token is unquoted until we actually hit a double-quote character
begin
  result := 0;
  if ATokenCount = 0 then exit;

//  if QuotesAndCommas then
//    result := SkipQuotedTokens(TokenCount)
//  else
    result := SkipUnQuotedTokens(ATokenCount);
end;

function TCSV.GetToken: string;
// (shouldn't really have called this a Getxxxx - too late now)
// returns the token starting at the CursorPosition
// Double-Quotes are removed from double-quoted values
// BJH 2005/09/16 Check each token to see if its double-quoted
var
  i: integer;
  Delimiter: char;
  EndOfToken: boolean;
  EOLMod: integer;
begin
  result := 'CSVERROR_';
  if CursorPosition > length(CurrentRecord) then exit;

//  if QuotesAndCommas then
  if CurrentRecord[CursorPosition] = '"' then // token is double-quoted so embedded commas are part of the value
    Delimiter := '"'
  else
    Delimiter := ',';

  if Delimiter = '"' then
    inc(CursorPosition); // skip the opening Double-Quote

  EndOfToken := false;
  EOLMod     := 0;

  for i := CursorPosition to CurrentRecordLength do begin
    if (CurrentRecord[i] = Delimiter) then
      EndOfToken := true
    else
      if ((Delimiter = ',') and (i = CurrentRecordLength)) then begin
        EndOfToken := true;
        EOLMod     := 1;
      end;

    if EndOfToken then begin
      result := copy(CurrentRecord, CursorPosition, (i - CursorPosition) + EOLMod);
      inc(CurrentToken);
      CursorPosition := i;
      break;
    end;
  end;

  if (length(result) > 0) and (result[Length(result)] = '"') then
    delete(result, length(result), 1); // crop trailing double-quote

  inc(CursorPosition); // position passed the delimiter
  if Delimiter = '"' then
    inc(CursorPosition); // point to first character of next token or EndOfRecord
end;

procedure TCSV.ResetCursorPosition;
// determines which character and which token we're pointing to within the current record
begin
  CursorPosition := 1;
  CurrentToken   := 1;
end;

procedure TCSV.ResetCursor(ARequestedToken: integer; ARequestedRecordNumber: integer);
// Determines whether CursorPosition should be reset to the beginning of the record
begin
  if (ARequestedRecordNumber <> CurrentRecordNumber) or (ARequestedToken < CurrentToken) then
    ResetCursorPosition;
end;

{* getters and setters *}

function TCSV.GetCurrentRecordLength: integer;
begin
  result := length(CurrentRecord);
end;

function TCSV.GetEOR: boolean;
begin
  result := CursorPosition >= CurrentRecordLength;
end;

function TCSV.GetCurrentRecordBlank: boolean;
begin
  result := CurrentRecord = '';
end;

function TCSV.GetQuotesAndCommas: boolean;
// determines whether the current record contains double-quoted values separated by commas
// or unquoted values separated by commas - customer files can contain a mixture of both
// BJH 2005/09/16 Mods to SkipTokens and GetToken make this function redundant
begin
  result := false;
  if not CurrentRecordBlank then
    result := CurrentRecord[1] = '"';
end;

function TCSV.GetRecordCount: integer;
// returns the number of records in the CSV file
begin
  result := CSVFile.Count;
end;

procedure TCSV.SetCSVFileName(const Value: string);
begin
  FCSVFileName := Value;
end;

procedure TCSV.SetCurrentRecord(const Value: string);
// "rewrites" the current record
begin
  FCurrentRecord := Value;
end;

procedure TCSV.SetCurrentRecordNumber(const Value: integer);
// Sets the CurrentRecordNumber and reads that record into CurrentRecord
begin
  if (ValidRecordNumber(value)) and (CurrentRecordNumber <> Value) then begin
    FCurrentRecordNumber := Value;
    ReadRecord(CurrentRecordNumber);
  end;
end;

procedure TCSV.SetLastErrorString(const Value: string);
begin
  FLastErrorString := Value;
  FErrorSet := true;
end;

function TCSV.GetSysMsg: string;
begin
  result := TErrorsU.SysMsg;
end;

function TCSV.GetSysMsgSet: boolean;
begin
  result := TErrorsU.SysMsgSet;
end;

procedure TCSV.SetSysMsg(const Value: string);
begin
  TErrorsU.SetSysMsg(Value);
end;

end.
