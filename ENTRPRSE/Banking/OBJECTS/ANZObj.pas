unit ANZObj;

interface

uses
  ExpObj, CustAbsU;

type
  TANZHeaderRecord = Record
    RecType         : Char;                  // '0'
    Reserve1        : Array[1..17] of Char;  // Blank
    SequenceNo      : Array[1..2] of Char;   // '01'
    BankName        : Array[1..3] of Char;   // 'ANZ'
    Reserve2        : Array[1..7] of Char;   // Blank
    UserName        : Array[1..26] of Char;  // User company name (from ini file)
    UserID          : Array[1..6] of Char;   // User ID (from ini file)
    Desc            : Array[1..12] of Char;  // Description of entries (from ini file)
    Date            : Array[1..6] of Char;   // Processing date - DDMMYY
    Reserve3        : Array[1..40] of Char;  // Blank
  end;

  TANZDataRecord = Record
    RecType         : Char;                   // '1'
    SortCode        : Array[1..7] of Char;   // nnn-nnn
    AccountNo       : Array[1..9] of Char;
    Indicator       : Char;                  // Blank
    TransCode       : Array[1..2] of Char;   // 50
    Amount          : Array[1..10] of Char;  // in cents, right-justified, zero-padded
    AccountName     : Array[1..32] of Char;  // Name of supplier account
    Reference       : Array[1..18] of Char;
    UserSort        : Array[1..7] of Char;   // nnn-nnn
    UserAcc         : Array[1..9] of Char;
    UserName        : Array[1..16] of Char;
    Reserved        : Array[1..8] of Char;   //Zero filled
  end;

  TANZTrailerRecord = Record
    RecType         : Char;                  // '7'
    Reserved1       : Array[1..7] of Char;   // '999-999'
    Reserved2       : Array[1..12] of Char;  // Blank
    TotalAmount1    : Array[1..10] of Char;  // in cents, right-justified, zero-padded
    TotalAmount2    : Array[1..10] of Char;  // in cents, right-justified, zero-padded, same value as TotalAmount1
    Reserved3       : Array[1..10] of Char;  // Zero filled
    Reserved4       : Array[1..24] of Char;  // Blank
    RecordCount     : Array[1..6] of Char;   // number of transactions, right-justified, zero-padded
    Reserved5       : Array[1..40] of Char;  // Blank
  end;

  TANZExportObject = Class(TExportObject)
  protected
    HeaderRec : TANZHeaderRecord;
    DataRec : TANZDataRecord;
    TrailerRec : TANZTrailerRecord;
    function AddDashToSortCode(const sCode : string) : string;
    function ProcessAccountCode(const sCode : string) : string;
  public
    function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function WriteRec(const EventData : TAbsEnterpriseSystem;
                         Mode : word) : Boolean; override;

    function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function CreateOutFile(const AFileName : string;
                           const EventData : TAbsEnterpriseSystem) : integer; override;
    function CloseOutFile : integer; override;
  end;

var
  sUserName : string[26];
  sUserID   : string[6];

implementation



{ TANZExportObject }

function TANZExportObject.AddDashToSortCode(const sCode: string): string;
// Accepts either nnnnnn or nnn-nnn, and returns nnn-nnn
begin
  if Pos('-', sCode) = 0 then
    Result := Copy(sCode, 1, 3) + '-' + Copy(sCode, 4, 3)
  else
    Result := sCode;
end;

function TANZExportObject.CloseOutFile: integer;
begin

end;

function TANZExportObject.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
begin
  FillChar(HeaderRec, SizeOf(HeaderRec), 0);
  with HeaderRec do
  begin
    RecType := '0';
    SequenceNo := '01';
    BankName := 'ANZ';
  end;
end;

function TANZExportObject.ProcessAccountCode(const sCode: string): string;
//Returns maximum of 9 chars, achieved by deleting '-' chars if necessary - if not possible to reduce then returns string with
//all dashes removed
var
  MoreDashes : Boolean;
  i : integer;
begin
  Result := sCode;
  MoreDashes := True;
  while (Length(Result) > 9) and MoreDashes do
  begin
     i := Pos('-', Result);
     MoreDashes := i > 0;
     if MoreDashes then
       Delete(Result, i, 1);
  end;
end;

function TANZExportObject.ValidateRec(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  TempStr : string;
  Target : TAbsCustomer;
begin
  Result := True;
  GetEventData(EventData);
  with EventData do
  begin
    Target := GetTarget(EventData);

    if Target.acPayType <> 'B' then
    begin
      Result := False;
      LogIt(Target.acCompany + ': PayType not set to Bacs');
    end;
    TempStr := Target.acBankSort;
    if ((Length(TempStr) = 6) and not AllDigits(TempStr)) or
       ((Length(TempStr) = 7) and (TempStr[4] <> '-')) or
       (Length(TempStr) > 7) then
    begin
      Result := False;
      LogIt(Target.acCompany + ': Invalid BSB code - ' + TempStr);
    end;
    TempStr := ProcessAccountCode(Target.acBankAcc);
    if (Length(TempStr) > 9) then
    begin
      LogIt(Target.acCompany + ': Invalid account code - ' + TempStr);
      Result := False;
    end;
  end; {with EventData}
end;

function TANZExportObject.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  TempStr : string;
begin
  TempStr := UserBankSort;
  if ((Length(TempStr) = 6) and not AllDigits(TempStr)) or
     ((Length(TempStr) = 7) and (TempStr[4] <> '-')) or
     (Length(TempStr) > 7) then
  begin
    Result := False;
    LogIt(Target.acCompany + ': Invalid system BSB code - ' + TempStr);
  end;
  TempStr := ProcessAccountCode(UserBankAcc);
  if (Length(TempStr) > 9) then
  begin
    LogIt(Target.acCompany + ': Invalid account code - ' + UserBankAcc);
    Result := False;
  end;
end;

function TANZExportObject.WriteRec(const EventData: TAbsEnterpriseSystem;
  Mode: word): Boolean;
begin

end;

end.
