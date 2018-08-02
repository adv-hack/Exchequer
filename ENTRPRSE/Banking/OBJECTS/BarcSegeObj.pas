//HV 09/06/2016 2016-R2 ABSEXCH-17575: Barclays.NET Sage file format, Sage file format -UK Three Day Payments and UK faster/Next Day Payment

unit BarcSegeObj;

interface

uses
  CustAbsU, ExpObj, MultiObj, BarcSegeConst;

type

  TBarcSegeObject = Class(TMultiFileExportObject)
  private
    FCompanyBIC: string;
    FCompanyIBAN: string;
    function ValidatePayType(const ATarget : TAbsCustomer) : Boolean;
    function ValidateCompanyName(const ATarget : TAbsCustomer; AACLength : Smallint) : Boolean;
    function ValidateBankAcc(const ATarget : TAbsCustomer) : Boolean;
    function ValidateBankSortCode(const ATarget : TAbsCustomer) : Boolean;
  protected
    PayRecs : Array[1..MaxCreditLines] of TBarcSegePayLine;
    OldPayCount : integer;
    FIniFileName : string;
    function WriteData(const EventData : TAbsEnterpriseSystem) : Boolean; override;
  public
    constructor Create(const EventData : TAbsEnterpriseSystem);
    function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function WriteRec(const EventData : TAbsEnterpriseSystem; Mode : word) : Boolean; override;
    
    property CompanyBIC : string read FCompanyBIC;
    property CompanyIBAN : string read FCompanyIBAN;
  end;

implementation

Uses
  StrUtils, SysUtils, IniFiles;

{ TBarcSegeObject }

constructor TBarcSegeObject.Create(const EventData: TAbsEnterpriseSystem);
begin
  inherited Create;
  RecsPerFile := MaxCreditLines;
  FMaxFiles := MaxFiles;
  Ext := DefaultExt;
  FIniFilename := 'BarcSege.ini';
  PayCount := 1;
end;

//Validation : Trader Bank Account Length with All Digits
function TBarcSegeObject.ValidateBankAcc(const ATarget: TAbsCustomer): Boolean;
var
  TempStr : string;
begin
  Result := True;
  TempStr := Trim(ATarget.acBankAcc);
  if (Length(TempStr) <> DefaultACLength) or (not AllDigits(TempStr)) then
  begin
    Result := False;
    LogIt(ATarget.acCompany + ': Invalid account - ' + TempStr);
  end;
end;

//Validate : Sort code can be in either NNNNNN or NN-NN-NN format.
function TBarcSegeObject.ValidateBankSortCode(const ATarget: TAbsCustomer): Boolean;
var
  TempStr : string;
begin
  Result := True;
  TempStr := Trim(FormatSortCode(ATarget.acBankSort));
  if (Length(TempStr) in [DefaultSortLength, 8])  then
  begin
    if ((Length(TempStr) = DefaultSortLength) and (not AllDigits(TempStr)))
       or ((Length(TempStr) = 8) and (not AllDigitsWithHyphen(TempStr))) then
    begin
      Result := False;
      LogIt(ATarget.acCompany + ': Invalid sort code - ' + TempStr);
    end;
  end
  else
  begin
    Result := False;
    LogIt(ATarget.acCompany + ': Invalid sort code - ' + TempStr);
  end;
end;

//Validation : Trader Company name is not null.
function TBarcSegeObject.ValidateCompanyName(const ATarget: TAbsCustomer;
  AACLength: Smallint): Boolean;
var
  TempStr : String;
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
function TBarcSegeObject.ValidatePayType(const ATarget: TAbsCustomer): Boolean;
begin
  Result := True;
  if ATarget.acPayType <> 'B' then
  begin
    Result := False;
    LogIt(ATarget.acCompany + ': PayType not set to Bacs');
  end;
end;

function TBarcSegeObject.ValidateRec(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  Target  : TAbsCustomer;
  TempStr : string;
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

    TempStr := Trim(Copy(Bacs_Safe(Target.acBankRef), 1, 18)) ;
    if (AnsiPos(PAY_REF_CONTRA, UpperCase(TempStr)) <> 0) then
    begin
      Result := False;
      LogIt(Target.acCompany + ': Invalid customer reference - ' + TempStr);
    end;
  end; {with EventData}
end;

function TBarcSegeObject.ValidateSystem(const EventData: TAbsEnterpriseSystem): Boolean;
begin
  Result := True;

  {$IFDEF MULTIBACS}
    FCompanyBIC := LeftStr(Trim(UserBankSort),6);
    FCompanyIBAN := LeftStr(Trim(UserBankAcc),8);
  {$ELSE}
    FCompanyBIC := LeftStr(Trim(TAbsSetup10(EventData.Setup).ssBankSortCode),6) ;
    FCompanyIBAN := LeftStr(Trim(TAbsSetup10(EventData.Setup).ssBankAccountCode),8);
  {$ENDIF}

  if (Length(FCompanyIBAN) <> DefaultACLength) or not AllDigits(FCompanyIBAN) then
  begin
    Result := False;
    failed := flBank;
  end;
  if (Length(FCompanyBIC) <> DefaultSortLength) or not AllDigits(FCompanyBIC) then
  begin
    Result := False;
    failed := flBank;
  end;

  if not Result then
    Failed := flBank;

  if Result then
    LogIt('Validate system - successful');
end;

function TBarcSegeObject.WriteData(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  OutString : string;
  i : integer;
begin
{$I-}
  Result := True; 
  for i := 1 to OldPayCount do
  begin
    with PayRecs[i] do
    begin
      OutString :=  DQuotedStr(DestBankSort) + COMMA +                          // Payee Sort Bank code - Sort code number from Supplier (Trader) details
                    DQuotedStr(DestAccName) + COMMA +                           // Payee Name - Supplier Name
                    DQuotedStr(DestBankAcc) + COMMA +                           // Payee Bank Account Number - Bank Account Number from Supplier Details
                    DQuotedStr(Trim(Format('%8.2f', [PayAmount]))) + COMMA +    // Payment Amount
                    DQuotedStr(DestBankRef) + COMMA +                           // Payee Name - Customer Bank Reference
                    DQuotedStr(BacsCode) + CRLF ;                               // Bacs Code and End of Line Char(CLRF)
      Result := WriteThisRec(OutString);
    end; {with}
  end; {for i}
end;

function TBarcSegeObject.WriteRec(const EventData: TAbsEnterpriseSystem;
  Mode: word): Boolean;
var
  Amount : Double;
  OutString : string;
  Target : TAbsCustomer;
  DestRef : string;
  aCompany : string;
begin
  Result := True;
  Target := GetTarget(EventData);
  if Mode = wrContra then
  begin
    if OldPayCount > 0 then
      Result := WriteBatch(EventData);
  end
  else
  if Mode = wrPayLine then
  begin
    with EventData, PayRecs[PayCount] do
    begin
      if not IsBlank(Target.acBankRef) then
        DestRef := Target.acBankRef
      else
        DestRef := '';
      aCompany := Trim(Copy(Bacs_Safe(Target.acCompany), 1, 18));
      Amount := 0.00;
      Amount := Transaction.thCurrSettled;
      TotalPenceWritten := TotalPenceWritten + Pennies(Amount);  
      DestBankSort := Trim(Target.acBankSort);                                // Payee Sort Bank code - Sort code number from Supplier (Trader) details
      DestAccName  := aCompany;                                               // Payee Name - Supplier Name
      DestBankAcc  := Trim(Target.acBankAcc);                                 // Payee Bank Account Number - Bank Account Number from Supplier Details
      PayAmount    := Amount;                                                 // Payment Amount
      DestBankRef  := Trim(Copy(Bacs_Safe(DestRef), 1, 18));                  // Payee Name - Customer Bank Reference
      BacsCode     := SEGE_BACS_CODE;                                         // Bacs Code 99

      Inc(TransactionsWritten);
      OldPayCount := PayCount;
      Inc(PayCount);
      if PayCount > MaxCreditLines then
      begin
        Result := WriteBatch(EventData);
        PayCount := 1;
        OldPayCount := 0;
      end;
    end;
  end
  else
    Result := True;
end;

end.
