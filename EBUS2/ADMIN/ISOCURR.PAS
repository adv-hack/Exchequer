unit ISOCurr;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Classes;

type
  TISOCurrencyList = class
    private
      fISOCurrencyList : TStringList;

    protected
      procedure ReadCurrenciesFromResource;
      procedure ReadCurrencies;
    public

      class procedure ProcessTextFile;
      class procedure ProcessTextFileDesc;
      function CurrencyCodeExists(const Currency : string) : boolean;



      constructor Create;
      destructor  Destroy; override;
  end;

Const
  MAX_CurrDesc  =  179;
  MAX_VATDesc   =  6;


  Function  ISOCurrencyList(n  :  Integer)  :  String;
  Function  BASDAVATList(n  :  Integer)  :  String;


implementation

uses
  ETStrU,
  SysUtils;


//-----------------------------------------------------------------------

constructor TISOCurrencyList.Create;
begin
  inherited Create;
  fISOCurrencyList := TStringList.Create;
  ReadCurrencies;
end;

//-----------------------------------------------------------------------

destructor TISOCurrencyList.Destroy;
begin
  fISOCurrencyList.Free;
  inherited Destroy;
end;

//-----------------------------------------------------------------------

procedure TISOCurrencyList.ReadCurrenciesFromResource;
var
  i : integer;
  str : string;
begin
  i := 1;
  repeat
    // LoadStr returns an empty string if the index specified cannot be found
    str := LoadStr(i);
    if str <> '' then
      fISOCurrencyList.Add(str);
    inc(i);
  until str = '';
end;




//-----------------------------------------------------------------------

procedure TISOCurrencyList.ReadCurrencies;
const
  MAX_CURRENCIES = 181;
  CURRENCIES : array [1..MAX_CURRENCIES] of string[3] =
    ({$I ISOCODES.PAS});

var
  i : integer;
begin
  for i := 1 to MAX_CURRENCIES do
  Begin
    fISOCurrencyList.Add(CURRENCIES[i]);

  end;

  fISOCurrencyList.Sorted := true;

end;

//-----------------------------------------------------------------------

function TISOCurrencyList.CurrencyCodeExists(const Currency: string): boolean;
var
  Index : integer;
begin
  Result := fISOCurrencyList.Find(Currency, Index);
end;

//-----------------------------------------------------------------------

class procedure TISOCurrencyList.ProcessTextFile;
// Notes : Uses an input text file with 3 letter ISO code as first non-white space
//         element on a line.
const
  INPUT_FILE_NAME = 'ISOCodes.TXT';
  OUTPUT_FILE_NAME = 'TEMP.TXT';
  CURRENCIES_PER_LINE = 10;
var
  lstCurrencies : TStringList;
  ReadString,
  WriteString : string;
  ReadFile,
  WriteFile : TextFile;
  i : integer;
begin
  lstCurrencies := TStringList.Create;
  lstCurrencies.Duplicates := dupIgnore;
  lstCurrencies.Sorted := true;

  // Read the input file
  AssignFile(ReadFile, INPUT_FILE_NAME);
  Reset(ReadFile);
  while not EOF(ReadFile) do
  begin
    readln(ReadFile, ReadString);
    if Trim(ReadString) <> '' then
      lstCurrencies.Add(copy(Trim(ReadString), 1, 3));
  end;
  CloseFile(ReadFile);

  AssignFile(WriteFile, OUTPUT_FILE_NAME);
  Rewrite(WriteFile);
  WriteString := '';
  for i := 0 to lstCurrencies.Count -1 do
  begin
    WriteString := WriteString + '(''' + lstCurrencies[i] + '''),';
    if (i + 1) mod CURRENCIES_PER_LINE = 0 then
    begin
      writeln(WriteFile, WriteString);
      WriteString := '';
    end;
  end;
  if WriteString <> '' then
    writeln(WriteFile, WriteString);

  CloseFile(WriteFile);
  lstCurrencies.Free;
end;


class procedure TISOCurrencyList.ProcessTextFileDesc;
// Notes : Uses an input text file with 3 letter ISO code as first non-white space
//         element on a line. Picks up name
const
  INPUT_FILE_NAME = 'ISOCodes.TXT';
  OUTPUT_FILE_NAME = 'TEMPD.TXT';
  CURRENCIES_PER_LINE = 10;
var
  lstCurrencies : TStringList;
  ReadString,
  AddString,
  WriteString : string;
  ReadFile,
  WriteFile : TextFile;
  i : integer;
begin
  lstCurrencies := TStringList.Create;
  lstCurrencies.Duplicates := dupIgnore;
  lstCurrencies.Sorted := true;

  // Read the input file
  AssignFile(ReadFile, INPUT_FILE_NAME);
  Reset(ReadFile);
  while not EOF(ReadFile) do
  begin
    readln(ReadFile, ReadString);
    if Trim(ReadString) <> '' then
    Begin
      AddString:=Copy(ReadString,1,3)+'-'+Copy(ReadString,5,Length(ReadString)-4);

      lstCurrencies.Add(Trim(Strip('A',[Chr(Ord(''''))],AddString)));
    end;
  end;
  CloseFile(ReadFile);

  AssignFile(WriteFile, OUTPUT_FILE_NAME);
  Rewrite(WriteFile);
  WriteString := '';
  for i := 0 to lstCurrencies.Count -1 do
  begin
    WriteString := WriteString + '(''' + lstCurrencies[i] + '''),';
    writeln(WriteFile, WriteString);
    WriteString := '';
  end;

  CloseFile(WriteFile);
  lstCurrencies.Free;
end;


Function  ISOCurrencyList(n  :  Integer)  :  String;

const
  CurrDesc  :  array [0..MAX_CURRDesc] of string[80] =
  ({$I ISODesc.pas});

Begin
  If (n>=0) and (n<=Max_CURRDesc) then
    Result:=CurrDesc[n]
  else
    Result:='';

end;


Function  BASDAVATList(n  :  Integer)  :  String;

const
  BASDAVATDesc  :  array [0..MAX_VATDesc] of string[80] =
  (
  ('S - Standard Rate'),
  ('Z - Zero Rate'),
  ('E - Exempt'),
  ('L - Lower Rate'),
  ('H - Higher Rate'),
  ('N - None'),
  ('X - Outside the scope of local tax')
  );

Begin
  If (n>=0) and (n<=Max_VATDesc) then
    Result:=BASDAVATDesc[n]
  else
    Result:='';

end;



end.



