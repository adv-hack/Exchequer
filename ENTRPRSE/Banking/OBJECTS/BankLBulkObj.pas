unit BankLBulkObj;

interface

uses
  CustAbsU, ExpObj;

type

  TBankLineBulkObject = Class(TExportObject)
  private
    FListName : string;
    FReference : string;
  protected
    Target : TAbsCustomer;
    FIncBy : Integer;
    FIniFileName : string;
    procedure ReadIniFile(const DataPath, sBankGL : string); virtual;
    function GetDate(const ADate : string) : string;
  public
    constructor Create;
    procedure Initialise; virtual;
    function WriteRec(const EventData : TAbsEnterpriseSystem;
                                Mode : word) : Boolean; override;
    function CreateOutFile(const AFileName : string;
                          const EventData :
                          TAbsEnterpriseSystem) : integer; override;
    function CloseOutFile : integer; override;
    function GetCurrencyString(const CurrString : string) : string;

    //PR: 05/06/2013 ABSEXGENERIC-325 Refactoring to allow TBankLineAdHocObject descendant to change the contents of some fields.
    function GetDebitFields : string; virtual;
    function GetCreditFields : string; virtual;
    function GetBeneficiaryRef(const EventData : TAbsEnterpriseSystem) : string; virtual;
  end;

  //PR: 05/06/2013 ABSEXGENERIC-325 Added descendant object for Bankline Ad Hoc bulk payments.
  TBankLineAdHocObject = Class(TBankLineBulkObject)
  public
    procedure Initialise; override;
    function GetDebitFields : string; override;
    function GetCreditFields : string; override;
    function GetBeneficiaryRef(const EventData : TAbsEnterpriseSystem) : string; override;
  end;

  //HV 08/04/2016 2016-R2 ABSEXCH-16595: New Bacs format for Ulster Bank Bankline Ad-hoc
  TUlsterBankAdHocObject = Class(TBankLineBulkObject)
  private
    FBankAccountCodeLong: string;
    FBankSortCodeLong: string;
    function ValidateIBAN(const IBAN : string) : Boolean;
    function ValidateBIC(const BIC : string) : Boolean;
  protected
    FCompanyBIC : string;
    FCompanyIBAN : string;
  public
    procedure Initialise; override;
    function GetDebitFields : string; override;
    function GetCreditFields : string; override;
    function WriteRec(const EventData : TAbsEnterpriseSystem; Mode : word) : Boolean; override;
    function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function CreateOutFile(const AFileName : AnsiString; const EventData :
                              TAbsEnterpriseSystem) : integer;  override;
    property CompanyBIC : string read FCompanyBIC;
    property CompanyIBAN : string read FCompanyIBAN;
    property BankAccountCodeLong : string read FBankAccountCodeLong; // Customer
    property BankSortCodeLong : string read FBankSortCodeLong; // Customer
  end;



implementation

uses
  SysUtils, IniFiles, EtDateU, StrUtils;

const

  //Header fillers
  hFiller1 = ',,,';
  hFiller2 = ',,';
  hFiller3 = ',,,,,,,';
  hFiller4 = ',,,,,,';
  hFiller5 = ',,,,,,,,,,,,,,,,,,';
  hFiller6 = ',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,';
  hFiller7 = ',,,,,,,,,,,';

  //Line fillers
  lFiller1 = ',,,';
  lFiller2 = ',,,,';
  lFiller3 = ',,,,,,,,';
  lFiller4 = ',';
  lFiller5 = ',,,,,,,,';
  lFiller6 = ',,,,,,';
  lFiller7 = ',,';
  lFiller8 = ',,,,';
  lFiller9 = ',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,';

  EuroChar = #128;


procedure TBankLineBulkObject.ReadIniFile(const DataPath, sBankGL : string);
const
  sDefault = 'Default';
begin
  with TIniFile.Create(Datapath + FIniFileName) do
  Try
    FListName := ReadString(sBankGL, 'ListName', '');
    FReference := ReadString(sBankGL, 'Reference', '');

    if FListName = '' then
    begin
      FListName := ReadString(sDefault, 'ListName', '');
      FReference := ReadString(sDefault, 'ListRef', '');
    end;

    FIncBy := ReadInteger('Settings', 'IncrementBy', 0);
  Finally
    Free;
  End;
end;


{ TBankLineBulkObject }


function TBankLineBulkObject.CloseOutFile: integer;
begin
  Result := inherited CloseOutFile;
end;

function TBankLineBulkObject.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
var
  HeaderRec : AnsiString;
  sBankGL : string;
begin
  Result := inherited CreateOutFile(AFilename, EventData);
  if (Result = 0) and (not (Self is TUlsterBankAdHocObject)) then
  begin
    sBankGL := IntToStr(EventData.Stock.stCosgl);
    ReadIniFile(EventData.Setup.ssDataPath, sBankGL);

    //Write header
    GetEventData(EventData);
    HeaderRec := hFiller1 + {'06' + hFiller2 + FListName + hFiller3}GetDebitFields + UserBankSort+UserBankAcc +
                 hFiller4 + DDMMYYYY(GetDate(ProcControl.PDate)) + hFiller5 + FReference + hFiller6 + {'C' +}
                 hFiller7;

    if WriteThisRec(HeaderRec) then
    begin
      Result := 0;
    end
    else
      Result := 1;
  end;
end;

function TBankLineBulkObject.GetBeneficiaryRef(const EventData : TAbsEnterpriseSystem) : string;
begin
  Result := Bacs_Safe(Target.acBankRef); 
end;

function TBankLineBulkObject.GetCreditFields: string;
begin
  Result := '07' + lFiller2 + Target.acCode + lFiller3;
end;

function TBankLineBulkObject.GetCurrencyString(
  const CurrString: string): string;
begin
  if Length(CurrString) = 1 then
  begin
    if (CurrString[1] = #156) or (CurrString[1] = '£') then
      Result := 'GBP'
    else
    if CurrString[1] = EuroChar then
      Result := 'EUR';
  end
  else
    Result := CurrString;

end;

function TBankLineBulkObject.GetDebitFields: string;
begin
  Result := '06' + hFiller2 + FListName + hFiller3;
end;

function TBankLineBulkObject.WriteRec(
  const EventData: TAbsEnterpriseSystem; Mode: word): Boolean;
var
  LineRec : AnsiString;
  Amount : Double;
begin
  if Mode <> wrContra then
  begin
    GetEventData(EventData);
    Target := GetTarget(EventData);

    Amount := ProcControl.Amount;
    // CJS 2014-06-12 - ABSEXCH-15217 - BACS Bulk Export Beneficiary name allows too many characters
    LineRec := lFiller1 + {'07' + lFiller2 + Target.acCode + lFiller3}GetCreditFields + GetCurrencyString(ProcControl.PayCurr) + lFiller4 +
                Trim(Format('%8.2f', [Amount])) + lFiller5 + Target.acBankSort + lFiller6 +
                Target.acBankAcc + lFiller7 + Bacs_Safe(Trim(Copy(Target.acCompany, 1, 35))) + lFiller8 + {Bacs_Safe(Target.acBankRef)}
                GetBeneficiaryRef(EventData) + lFiller9;
    Result := WriteThisRec(LineRec);

    TotalPenceWritten := TotalPenceWritten + Pennies(Amount);
    inc(TransactionsWritten);
  end
  else
    Result := True;
end;

constructor TBankLineBulkObject.Create;
begin
  inherited;
  Initialise;
end;

procedure TBankLineBulkObject.Initialise;
begin
  FIniFilename := 'BankLinB.ini';
end;
//PR: ABSEXGENERIC-347 function to increment the date by the number of days specified in the ini file.
function TBankLineBulkObject.GetDate(const ADate: string): string;
begin
  if FIncBy = 0 then
    Result := ADate
  else
    Result := CalcDueDatexDays(ADate, FIncBy);
end;

{ TBankLineAdHocObject }

function TBankLineAdHocObject.GetBeneficiaryRef(const EventData : TAbsEnterpriseSystem) : string;
begin
  Result := Bacs_Safe(Copy(Trim(EventData.Setup.ssUserName), 1, 18));
end;

function TBankLineAdHocObject.GetCreditFields: string;
begin
  Result := '09' + lFiller2 + lFiller3;
end;

function TBankLineAdHocObject.GetDebitFields: string;
begin
  Result := '08,,,,,Payments ' + IntToStr(ProcControl.PayRun) + ',,,,';
end;


procedure TBankLineAdHocObject.Initialise;
begin
  FIniFilename := 'BLAdHoc.ini';
end;

{ TUlsterBankAdHocObject }
function TUlsterBankAdHocObject.CreateOutFile(const AFileName: AnsiString;
  const EventData: TAbsEnterpriseSystem): integer;
var
  HeaderRec : AnsiString;
  sBankGL : string;
begin
  Result := inherited CreateOutFile(AFilename, EventData);
  if Result = 0 then
  begin
    sBankGL := IntToStr(EventData.Stock.stCosgl);
    ReadIniFile(EventData.Setup.ssDataPath, sBankGL);

    //Write header
    GetEventData(EventData);
    HeaderRec := hFiller1 + GetDebitFields + FCompanyIBAN +
                 hFiller4 + DDMMYYYY(GetDate(ProcControl.PDate)) + hFiller5 + FReference + hFiller6 +
                 hFiller7;

    if WriteThisRec(HeaderRec) then
      Result := 0
    else
      Result := 1;
  end;
end;

function TUlsterBankAdHocObject.GetCreditFields: string;
begin
  Result := '09' + lFiller2 + lFiller3;
end;

function TUlsterBankAdHocObject.GetDebitFields: string;
begin
  Result := '08,,,,,Payments ' + IntToStr(ProcControl.PayRun) + ',,,,';
end;

procedure TUlsterBankAdHocObject.Initialise;
begin
  FIniFilename := 'UBAdHoc.ini';
end;

function TUlsterBankAdHocObject.ValidateBIC(const BIC: string): Boolean;
begin
  //BIC must be either 8 or 11 chars
  Result := Length(BIC) in [8, 11];
end;

function TUlsterBankAdHocObject.ValidateIBAN(const IBAN: string): Boolean;
begin
  //We don't know valid lengths for IBAN - just ensure that it is populated.
  Result := Trim(IBAN) <> '';
end;

function TUlsterBankAdHocObject.ValidateRec(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
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

    FBankSortCodeLong := Trim(TAbsCustomer4(Target).acBankSortCode) ;
    FBankAccountCodeLong := LeftStr(Trim(TAbsCustomer4(Target).acBankAccountCode),34);
    If not ValidateIBAN(BankAccountCodeLong) then
    begin
      Result := False;
      LogIt(Target.acCompany + ': Invalid account - ' + BankAccountCodeLong);
    end;
    if not ValidateBIC(BankSortCodeLong) then
    begin
      LogIt(Target.acCompany + ': Invalid BIC - ' + BankSortCodeLong);
      Result := False;
    end;
  end; {with EventData}
end;

function TUlsterBankAdHocObject.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
begin
  Result := True;

  {$IFDEF MULTIBACS}
    FCompanyBIC := LeftStr(Trim(UserBankSort),6);
    FCompanyIBAN := LeftStr(Trim(UserBankAcc),34);
  {$ELSE}
    FCompanyBIC := LeftStr(Trim(TAbsSetup10(EventData.Setup).ssBankSortCode),6) ;
    FCompanyIBAN := LeftStr(Trim(TAbsSetup10(EventData.Setup).ssBankAccountCode),34);
  {$ENDIF}

  If not ValidateIBAN(FCompanyIBAN) then
  begin
    LogIt('No System IBAN supplied');
    Result := False;
  end;

  if not Result then
    Failed := flBank;

  if Result then
    LogIt('Validate system - successful');
end;

function TUlsterBankAdHocObject.WriteRec(
  const EventData: TAbsEnterpriseSystem; Mode: word): Boolean;
var
  LineRec : AnsiString;
  Amount : Double;
begin
  if Mode <> wrContra then
  begin
    GetEventData(EventData);
    Target := GetTarget(EventData);

    Amount := ProcControl.Amount;
    LineRec := lFiller1 + GetCreditFields + GetCurrencyString(ProcControl.PayCurr) + lFiller4 +
                Trim(Format('%8.2f', [Amount])) + lFiller5 + BankSortCodeLong + lFiller6 +
                BankAccountCodeLong + lFiller7 + Bacs_Safe(Trim(Copy(Target.acCompany, 1, 35))) + lFiller8 +
                GetBeneficiaryRef(EventData) + lFiller9;
    Result := WriteThisRec(LineRec);

    TotalPenceWritten := TotalPenceWritten + Pennies(Amount);
    inc(TransactionsWritten);
  end
  else
    Result := True;
end;

end.

