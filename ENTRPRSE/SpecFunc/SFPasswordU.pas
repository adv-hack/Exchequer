unit SFPasswordU;

interface

uses SysUtils, Classes;

type
  { TSFPassword manages the Challenge and Response passwords that can be used
    to provide time-limited access to Special Functions. }
  TSFPassword = class(TObject)
  private
    FID: LongInt;
    FChallenge: string;
    FResponse: string;
    FDataPath: string;

    procedure SetChallenge(const Value: string);
    procedure SetID(const Value: LongInt);

    { Generates a challenge, based on the Special Function ID and the
      current date. Raises an exception if no title has been assigned. }
    procedure GenerateChallenge;

    { Generates a response from the current challenge. Raises an exception if
      no challenge has been assigned. }
    procedure GenerateResponse;
    procedure SetDataPath(const Value: string);

  public
    { Validates the supplied response for the Special Function. Raises an
      exception if the Special Function ID has not been assigned. }
    function ValidateResponse(UserResponse: string): Boolean;

    { Holds the current challenge. Assigning this value will automatically
      generate the matching response, which can be read from the Response
      property. }
    property Challenge: string read FChallenge write SetChallenge;

    { Holds the response matching the current challenge. This is automatically
      generated when the challenge is assigned. }
    property Response: string read FResponse;

    { Holds the path of the Exchequer installation directory. This is required
      by GenerateChallenge, which reads the Exchequer licence file. }
    property DataPath: string read FDataPath write SetDataPath;

    { Holds the unique ID of the Special Function. Setting this value will
      automatically generate the matching challenge and response, which can
      then be read from the Challenge and Response properties. }
    property ID: LongInt read FID write SetID;
  end;

  ESFPassword = class(Exception)
  end;

implementation

uses EntLic, LicRec;

// =============================================================================
// TSFPassword
// =============================================================================

procedure TSFPassword.GenerateChallenge;
var
  LicR: EntLicenceRecType;
  Y, M, D, YearNo : Word;
  WeekNo, X: Int64;
  ESN1, ESN2, ESN3, ESN4, ESN5, ESN6: Int64;
const
  RetChars: array [0..33] of Char =
    ('6', 'C', 'Z', 'H', 'F', '7', 'J', 'P', '3',
     'V', 'B', 'E', '0', 'K', 'D', '9', 'L', 'X',
     '5', 'Q', 'N', '1', 'Y', 'M', 'R', '8', 'W',
     'G', 'S', '2', 'U', 'A', '5', 'T');
begin

  if (ID = 0) then
    raise ESFPassword.Create('The Special Function ID has not been assigned');

  if (FDataPath = '') then
    raise ESFPassword.Create('No data path has been assigned.');

  if (not DirectoryExists(FDataPath)) then
    raise ESFPassword.Create('Data path "' + FDataPath + '" not found.');

  ReadEntLic (FDataPath + EntLicFName, LicR);

  FChallenge := '';

  ESN1 := LicR.LicISN[1];
  ESN2 := LicR.LicISN[2];
  ESN3 := LicR.LicISN[3];
  ESN4 := LicR.LicISN[4];
  ESN5 := LicR.LicISN[5];
  ESN6 := LicR.LicISN[6];

  If (ESN1 < 1) Then ESN1 := 1;
  If (ESN2 < 1) Then ESN2 := 1;
  If (ESN3 < 1) Then ESN3 := 1;
  If (ESN4 < 1) Then ESN4 := 1;
  If (ESN5 < 1) Then ESN5 := 1;
  If (ESN6 < 1) Then ESN6 := 1;

  // Decode specified date into separate elements
  DecodeDate (SysUtils.Date, Y, M, D);
  WeekNo := Trunc(SysUtils.Date - EncodeDate (Y, 1, 1)) Div 7;
  YearNo := Y - 1997;

  // Character 1
  X := (ESN1 + ESN2 + ESN3 + ESN4 + ESN5 + ESN6 + ID) Mod 34;
  FChallenge := FChallenge + Retchars[X];

  // Character 2
  X := (ESN1 * ESN2 * ESN3 * ESN4 * ESN5 * ESN6 * ID) Mod 34;
  FChallenge := FChallenge + Retchars[X];

  // Character 3
  X := Abs(((ESN1 * (73 - ID)) + (ESN5 * (79 + ID)) + (WeekNo + 2)) Mod 34);
  FChallenge := FChallenge + Retchars[X];

  // Character 4
  X := (((ESN3 + 104 + ID) * (ESN6 + ID + 37) * (M + 2)) - (YearNo + WeekNo + 1)) Mod 34;
  FChallenge := FChallenge + Retchars[X];

  // Character 5
  X := ((ESN2 + 35) * (ESN4 + 71) * ((M * WeekNo * ID) + 2)) Mod 34;
  FChallenge := FChallenge + Retchars[X];

  // Character 6
  X := (M + WeekNo + ID) Mod 34;
  FChallenge := FChallenge + Retchars[X];
end;

// -----------------------------------------------------------------------------

procedure TSFPassword.GenerateResponse;

  // ...........................................................................
  function EncodeToHex(Str: string): string;
  var
    Count, Max: Byte;
    i, j: Integer;
  begin
    Result := '';
    Max := Length(Str) div 2;
    for Count := 1 to Max do
    begin
      i := Count;
      j := (Length(Str) - Count) + 1;
      Result := Result + IntToHex(Ord(Str[i]), 2) + IntToHex(Ord(Str[j]), 2);
    end;
  end;
  // ...........................................................................

var
  BaseResponse: string[6];
  Seed: LongInt;
  DaysToExpiryIdx: Byte;
  i: Integer;
begin
  if (Challenge = '') then
    raise ESFPassword.Create('A challenge has not been assigned');
  // Calculate a seed for the random number generator, based on the challenge.
  Seed := 0;
  for i := 1 to Length(Challenge) do
    Seed := Seed + Ord(Challenge[i]) * (i - 1);
  // Set up the random number generator. For any specific seed it will
  // generate the same sequence of numbers.
  RandSeed := Seed;
  // Calculate the Response.
  BaseResponse := '      ';
  for i := 1 to 6 do
    BaseResponse[i] := Char(Random(255));
  // Convert the result to a string of hex characters.
  FResponse := EncodeToHex(BaseResponse);
end;

// -----------------------------------------------------------------------------

procedure TSFPassword.SetChallenge(const Value: string);
begin
  FChallenge := Value;
  GenerateResponse;
end;

// -----------------------------------------------------------------------------

procedure TSFPassword.SetDataPath(const Value: string);
begin
  FDataPath := IncludeTrailingPathDelimiter(Value);
end;

// -----------------------------------------------------------------------------

procedure TSFPassword.SetID(const Value: LongInt);
begin
  FID := Value;
  if (FID <> 0) then
  begin
    GenerateChallenge;
    GenerateResponse;
  end;
end;

// -----------------------------------------------------------------------------

function TSFPassword.ValidateResponse(UserResponse: string): Boolean;
begin
  if (Response = '') then
    raise ESFPassword.Create('A response has not been assigned');
  Result := (UserResponse = Response);
end;

// -----------------------------------------------------------------------------

end.
