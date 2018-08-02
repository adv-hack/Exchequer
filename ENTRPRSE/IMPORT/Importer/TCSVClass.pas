unit TCSVClass;

{******************************************************************************}
{  TCSV encapsulates an entire CSV file and presents it like a random-access   }
{  database table of rows and fields (if AutoRead=True. Otherwise the file is  }
{  is read sequentially)                                                       }
{  Each value in the CSV file can either be contained in double quotes or not. }
{  Each row of values can contain a mixture of double-quoted and unquoted      }
{  values.                                                                     }
{  Values can only be separated by commas, not by commas and spaces.           }
{******************************************************************************}

interface

uses classes, SysUtils, dialogs;

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
    function  NextToken: string;
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

{$IFDEF TERRORS} uses TErrors; {$ENDIF}

{ TCSV }

constructor TCSV.create(ACSVFileName: string; AutoRead: boolean);
// If AutoRead is true, the CSV will be read and the CurrentRecord will be the first
// record in the file.
// If AutoRead is false, then each record of the file is read sequentially and the record number is ignored.
// Applications should not use AutoRead if there is a chance that the file is very large.
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
    result := NextToken; // sets CursorPosition to start of next token or EndOfRecord
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

function TCSV.NextToken: string; // v95 renamed from GetToken and rewritten to allow for double-quotes as part of the value.
// returns the token starting at the CursorPosition by finding the comma that delimits the token or by reaching the last char of the record
// If the token is double-quoted, it's delimited by the next ", combination.
// If the token is not double-quote, its delimited by the first comma. Simples.
// 1. A value can be enclosed in double-quotes.
// 2. A value can contain a double-quote (or a pair representing one).
//
// Will handle the following strings:-
//   1. "Pipe, 5'6" long",Pipe 5'6" long,             = 2 tokens  = Pipe, 5'6" long and Pipe 5'6" long
//   2. "Pipe, 5'6"" long",Pipe 5'6"" long,           = 2 tokens  = Pipe, 5'6" long and Pipe 5'6" long
//   3. "Pipe, 5'6"", blue",Pipe 5'6"",Pipe 5'6",     = 3 tokens  = Pipe, 5'6", blue and Pipe 5'6" and Pipe 5'6"
//   4. "Pipe, 5'6""",                                = 1 token   = Pipe, 5'6" (This was the customer's data that prompted all this)
//   5. Hell's Bells"""""""",                         = 1 token   = Hell's Bells"
//   6. "Pipe, 5'6"",
// it will not handle:-
//   7. "Pipe, 5'6"",x,"Pipe, 5'6", blue",            = 2 tokens = Pipe, 5'6",x,"Pipe, 5'6 and blue"
var
  CurRec: string;
  Cursor: integer;
  Quoted: boolean;
  EndOfToken: boolean;
  JustSkippedAPair: boolean;
begin
  result := 'CSVERROR_';
  if CursorPosition > length(CurrentRecord) then exit;
  CurRec := CurrentRecord + ','; // Add the implied delimiter after the last token on the record to make life easier
  Cursor := CursorPosition;
  Quoted := CurRec[Cursor] = '"';
  if Quoted then inc(Cursor); // start parsing at CursorPosition + 1 if the token is double-quoted.
  JustSkippedAPair := false;

  while Cursor <= CurrentRecordLength + 1 do begin
    if (CurRec[Cursor] = '"') and (CurRec[Cursor + 1] = '"') then begin // always skip pairs of double-quotes to handle example 3 above.
      inc(Cursor, 2);
      JustSkippedAPair := true; // allows for example 3 in the test below.
      CONTINUE;
    end;

    EndOfToken := ((not Quoted) and (CurRec[Cursor] = ','))
               or ((not JustSkippedAPair) and Quoted and (CurRec[Cursor - 1] = '"') and (CurRec[Cursor] = ','));

    if EndOfToken then begin
      result := copy(CurRec, CursorPosition, Cursor - CursorPosition);
      inc(CurrentToken);
      BREAK;
    end;

    JustSkippedAPair := false;
    inc(Cursor);
  end;


// if the token starts and ends with a double-quote then neither is treated as part of the value
  if length(result) > 1 then // must have at least 2 chars to do the following
    if (result[1] = '"') and (result[length(result)] = '"') then begin
      delete(result, 1, 1);
      delete(result, length(result), 1);
    end;

// If the token contains pairs of double-quotes, each pair is reduced to a single occurrence.
// This has the, probably, unexpected result that multiple consecutive pairs all get reduced to just one double-quote instead of one for each pair.
// If this becomes an issue, the following will need to be changed to loop from end to beginning, deleting one double-quote from each pair.
  while pos('""', result) <> 0 do
    delete(result, pos('""', result), 1);

//  ShowMessage(format('Token: %s', [result])); // *** TEST ONLY ***

// Set CursorPosition either on the first character of the next token or passed the end of the record
  CursorPosition := Cursor + 1;
end;

//===== pre v95 for reference
{function TCSV.NextToken: string; // v95 renamed from GetToken
// (shouldn't really have called this a Getxxxx - too late now) // v95 why so ?
// returns the token starting at the CursorPosition
// Double-Quotes are removed from double-quoted values
// BJH 2005/09/16 Check each token to see if its double-quoted
var
  i: integer;
  Delimiter: char;
  EndOfToken: boolean;
  EOLMod: integer; // End of Line Modifier
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
      if ((Delimiter = ',') and (i = CurrentRecordLength)) then begin  // rows ends in last character of last token rather than a delimiter
        EndOfToken := true;
        EOLMod     := 1;                                          // in which case the calculation for the length of the token is different
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

  ShowMessage(format('Token: %s', [result]));
  inc(CursorPosition); // position passed the delimiter
  if Delimiter = '"' then // we also need to skip over the comma
    inc(CursorPosition); // point to first character of next token or EndOfRecord
end;}

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
// BJH 2005/09/16 Mods to SkipTokens and NextToken make this function redundant
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
{$IFDEF TERRORS}  result := TErrors.SysMsg; {$ENDIF}
end;

function TCSV.GetSysMsgSet: boolean;
begin
{$IFDEF TERRORS}  result := TErrors.SysMsgSet; {$ENDIF}
end;

procedure TCSV.SetSysMsg(const Value: string);
begin
{$IFDEF TERRORS}  TErrors.SetSysMsg(Value); {$ENDIF}
end;

end.
