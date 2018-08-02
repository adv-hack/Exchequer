unit RBSEqObj;

interface

uses
  CustAbsU, ExpObj;

type
  TRBSEqObject = Class(TExportObject)
  private
    FCompanyBIC: string;
    FCompanyIBAN: string;
    function FormatDate(const ADate : string) : string;
    function ValidateIBAN(const IBAN : string) : Boolean;
    function ValidateBankAcc(const ATarget : TAbsCustomer) : Boolean;
    function ValidateCompanyName(const ATarget : TAbsCustomer; AACLength : Smallint) : Boolean;
    function ValidatePayType(const ATarget : TAbsCustomer) : Boolean;
    function ValidateBankSortCode(const ATarget : TAbsCustomer) : Boolean;
  public
    constructor Create;
    procedure Initialise; virtual;
    function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function WriteRec(const EventData : TAbsEnterpriseSystem; Mode : word) : Boolean; override;
    function CreateOutFile(const AFileName : string; const EventData: TAbsEnterpriseSystem) : integer; override;
    function CloseOutFile : integer; override;
    property CompanyBIC : string read FCompanyBIC;
    property CompanyIBAN : string read FCompanyIBAN;
  end;

implementation

uses
  SysUtils, EtDateU, StrUtils;

const
  HeadRecType = '1';
  PayRecType = '2';
  ControRecType = '9';
  HeadFileName = 'EQBACSPYTS';
  COMMA       = ',';
  BLANK     = ' ';
  PAY_TYPE_BACS = 'N';
  DefaultExt  = '.csv';

{ TRBSEqObject }

//this will write the control record
function TRBSEqObject.CloseOutFile: integer;
var
  lOutString : String;
begin
{$I-}
  lOutString := ControRecType + COMMA +
                IntToStr(TransactionsWritten) + COMMA +
                Format('%8.2f', [TotalPenceWritten/100]);
  WriteThisRec(lOutString);

  Result := inherited CloseOutFile;
  if Result <> 0 then
    ShowExportMessage('Warning','Unable to close file ' + OutFileName, '');
{$I+}
end;

constructor TRBSEqObject.Create;
begin
  inherited;
  Initialise;
end;

function TRBSEqObject.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
var
  lOutString: String;
begin
{$I-}
  Result := inherited CreateOutFile(AFilename, EventData);
  GetEventData(EventData);

  //Write Header row.
  with EventData do
  begin
    lOutString := HeadRecType + COMMA +
                  HeadFileName + IntToStr(ProcControl.PayRun) + COMMA +
                  FormatDateTime('YYYYMMDD', Date) + COMMA +
                  FormatDateTime('HHMMSS', Time);
    WriteThisRec(lOutString);
  end;
{$I+}
end;

function TRBSEqObject.FormatDate(const ADate: string): string;
begin
  Result := Copy(ADate, 7, 2) +
            Copy(ADate, 5, 2) +
            Copy(ADate, 1, 4);
end;

procedure TRBSEqObject.Initialise;
begin
//
end;


//Validation : Payee Bank Account Number(i.e Supplier's eCom Account-Code/IBAN) should be of 8 digit Length with All numbers
function TRBSEqObject.ValidateBankAcc(const ATarget: TAbsCustomer): Boolean;
var
  TempStr: String;
  lAcNum: Integer;
begin
  Result := True;
  TempStr := Trim(ATarget.acBankAcc);
  Result := AllDigits(TempStr);
  if Result and (Length(TempStr) <= 8) then
  begin
    lAcNum := StrToInt(TempStr);
    TempStr := Format('%.*d',[8, lAcNum]);
  end
  else
    Result := False;

  if not Result then
    LogIt(ATarget.acCompany + ': Invalid account - ' + TempStr);
end;

//Validate : Payee Sort code (i.e. Supplier's eCom Sort Code) should be of 6 characters and all numbers
function TRBSEqObject.ValidateBankSortCode(const ATarget: TAbsCustomer): Boolean;
var
  TempStr : string;
begin
  Result := True;
  TempStr := Trim(FormatSortCode(ATarget.acBankSort));
  Result := (Length(TempStr) = DefaultSortLength) and (AllDigits(TempStr));
  if Result = False then
    LogIt(ATarget.acCompany + ': Invalid sort code - ' + TempStr);
end;

//Validation : Payee Name (i.e Supplier's Company name) shouldn't be null and should be valid BACS character
function TRBSEqObject.ValidateCompanyName(const ATarget: TAbsCustomer; AACLength : Smallint): Boolean;
var
  TempStr : string;
begin
  Result := True;
  TempStr := Trim(Copy(Bacs_Safe(ATarget.acCompany), 1, AACLength));
  if (Length(TempStr) = 0) then
  begin
    Result := False;
    LogIt(ATarget.acCompany + ': Invalid account name - ' + TempStr);
  end;
end;

//Validation : Company Payment Type should be BACS.
function TRBSEqObject.ValidatePayType(const ATarget: TAbsCustomer): Boolean;
begin
  Result := True;
  if ATarget.acPayType <> 'B' then
  begin
    Result := False;
    LogIt(ATarget.acCompany + ': PayType not set to Bacs');
  end;
end;

//It should be an eQ account of format nnnn-nnnnnnnn (where n=number)
function TRBSEqObject.ValidateIBAN(const IBAN: string): Boolean;
var
  TempStr : string;
begin
  Result := True;
  if Length(IBAN) = 13 then
  begin
    if (not AllDigitsWithHyphen(IBAN, 5)) then
      Result := False;
  end
  else
    Result := False;

  if Result = False then
    LogIt('Invalid company account number - ' + IBAN);
end;

function TRBSEqObject.ValidateRec( const EventData: TAbsEnterpriseSystem): Boolean;
var
  Target  : TAbsCustomer;
  Amount  : Double;
begin
  Result := True;
  GetEventData(EventData);
  with EventData do
  begin
    Target := GetTarget(EventData);
    Result := ValidatePayType(Target) and Result;
    Result := ValidateCompanyName(Target, 18) and Result;
    Result := ValidateBankAcc(Target) and Result;
    Result := ValidateBankSortCode(Target) and Result;
  end; {with EventData}
end;

function TRBSEqObject.ValidateSystem(const EventData: TAbsEnterpriseSystem): Boolean;
begin
  Result := True;

  {$IFDEF MULTIBACS}
    FCompanyBIC := LeftStr(Trim(UserBankSort),6);
    FCompanyIBAN := LeftStr(Trim(UserBankAcc), 13);
  {$ELSE}
    FCompanyBIC := LeftStr(Trim(TAbsSetup10(EventData.Setup).ssBankSortCode),6) ;
    FCompanyIBAN := LeftStr(Trim(TAbsSetup10(EventData.Setup).ssBankAccountCode), 13);
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

function TRBSEqObject.WriteRec(const EventData: TAbsEnterpriseSystem; Mode: word): Boolean;
var
  Amount : Double;
  OutString : string;
  Target : TAbsCustomer;
  DestRef : string;
  lSuppBankAccNum: String;
  lAcNum: Integer;
begin
  if Mode = wrPayLine then
  begin
    GetEventData(EventData);
    with EventData do
    begin
      Target := GetTarget(EventData);

      if not IsBlank(Target.acBankRef) then
        DestRef := Target.acBankRef
      else
        DestRef := '';

      lSuppBankAccNum := Target.acBankAcc;
      if Length(lSuppBankAccNum) <= 8 then
      begin
        lAcNum := StrToInt(lSuppBankAccNum);
        lSuppBankAccNum := Format('%.*d',[8, lAcNum]);
      end;

      Amount := 0.00;
      Amount := Transaction.thCurrSettled;
      TotalPenceWritten := TotalPenceWritten + Pennies(Amount);
      Inc(TransactionsWritten);
      OutString :=  PayRecType + COMMA +                                      // Record Type (Must Be 2)
                    Trim(FCompanyIBAN) + COMMA +                              // Payer Account Number (Company Bank Account Code)
                    BLANK + COMMA +                                           // By Order of - Line 1 (For Basc/FP must be blank)
                    BLANK + COMMA +                                           // By Order of - Line 2 (For Basc/FP must be blank)
                    BLANK + COMMA +                                           // By Order of - Line 3 (For Basc/FP must be blank)
                    BLANK + COMMA +                                           // By Order of - Line 4 (For Basc/FP must be blank)
                    BLANK + COMMA +                                           // Charge Account Number (Company Account Code)(For Basc/FP must be blank)
                    'GBP' + COMMA +                                           // Default To GBP
                    Trim(Target.acBankSort) + COMMA +                         // Payee Sort Bank code - Sort code number from Supplier (Trader) details
                    lSuppBankAccNum + COMMA +                                 // Payee Bank Account Number - Bank Account Number from Supplier Details
                    Trim(Format('%8.2f', [Amount])) + COMMA +                 // Payment Amount
                    FormatDate(ProcControl.PDate) + COMMA +                   // Payment Debit date is taken from batch payments
                    Trim(Copy(Bacs_Safe(Target.acCompany), 1, 18)) + COMMA +  // Payee Name - Supplier Name
                    Trim(Copy(Bacs_Safe(UserBankRef), 1, 18)) + COMMA +       // Payer Name - Company Bank Ref
                    Trim(Copy(Bacs_Safe(DestRef), 1, 18)) + COMMA +           // Payee Name - Supplier Reference
                    PAY_TYPE_BACS + COMMA +                                   // Payment Method - must be 'N' for Bacs/FP
                    BLANK + COMMA +                                           // By Order of - Line 1 (For Bacs/FP must be blank)
                    BLANK + COMMA +                                           // By Order of - Line 2 (For Bacs/FP must be blank)
                    BLANK + COMMA +                                           // By Order of - Line 3 (For Bacs/FP must be blank)
                    BLANK + COMMA +                                           // By Order of - Line 4 (For Bacs/FP must be blank)
                    PAY_TYPE_BACS + COMMA +                                   // CHAPS advice indicator - should be N for BACS
                    BLANK + COMMA +                                           // Charges Payer - must be blank for BACS
                    BLANK + COMMA +                                           // Earliest Value Date Flag - value either Y/N
                    BLANK;                                                    // Data Export Reference
      Result := WriteThisRec(OutString);
    end;
  end
  else
    Result := True;
end; 

end.
