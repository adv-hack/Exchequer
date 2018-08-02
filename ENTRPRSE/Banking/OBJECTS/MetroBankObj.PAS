//HV 12/04/2017 2017-R1 ABSEXCH-18562: New format for QPR - E-Banking Metro Bank

unit MetroBankObj;

interface

uses
  CustAbsU, MultiObj, ExpObj;

const
  MaxCreditLines    = 1000;
  MaxFiles    = 99999;
  DefaultExt  = '.csv';
  COMMA       = ',';
  SEGE_BACS_CODE = '99';
  S_OUTSTRING_FORMAT = '"%s","%s","%s","%.2f","%s","%s"';

type
  TMetroBankPayRec = Record
    DestBankSort : String[6];
    DestAccName  : String[18];
    DestBankAcc  : String[8];
    PayAmount    : Double;
    DestBankRef  : String[18];
  end;

  TMetroBankObject = Class(TMultiFileExportObject)
  private
    FCompanyBIC: String;
    FCompanyIBAN: String;
    FPayRecs : array[1..MaxCreditLines] of TMetroBankPayRec;
    FOldPayCount: Integer;

    function ValidatePayType(const ATarget: TAbsCustomer): Boolean;
    function ValidateCompanyName(const ATarget: TAbsCustomer; AACLength: Smallint): Boolean;
    function ValidateBankAcc(const ATarget: TAbsCustomer): Boolean;
    function ValidateBankSortCode(const ATarget: TAbsCustomer): Boolean;
    function ValidateAmount(const AEventData: TAbsEnterpriseSystem): Boolean;
  protected
    function WriteData(const EventData: TAbsEnterpriseSystem): Boolean; override;
  public
    constructor Create(const EventData: TAbsEnterpriseSystem);
    function ValidateSystem(const EventData: TAbsEnterpriseSystem): Boolean; override;
    function ValidateRec(const EventData: TAbsEnterpriseSystem): Boolean; override;
    function WriteRec(const EventData: TAbsEnterpriseSystem; Mode: word): Boolean; override;

    property CompanyBIC : string read FCompanyBIC;
    property CompanyIBAN : string read FCompanyIBAN;
  end;

implementation

Uses
  StrUtils, SysUtils, IniFiles;

{ TMetroBankObject }

constructor TMetroBankObject.Create(const EventData: TAbsEnterpriseSystem);
begin
  inherited Create;
  RecsPerFile := MaxCreditLines;
  FMaxFiles := MaxFiles;
  Ext := DefaultExt;
  PayCount := 1;
end;

//Maximum of 10 digits with 2 decimal places e.g. 194.01 as MetroBank format
function TMetroBankObject.ValidateAmount(const AEventData: TAbsEnterpriseSystem): Boolean;
var
  lAmount: Double;
begin
  Result := True;
  lAmount := Round(ABS(AEventData.Transaction.thCurrSettled)*100);
  if Length(FloatToStr(lAmount)) > 10 then
  begin
    Result := False;
    LogIt(AEventData.Customer.acCompany + ': Invalid Amount - ' + FloatToStr(lAmount/100));
  end;
end;

//Validation : Trader Bank Account Length with All Digits and should not 00000000

function TMetroBankObject.ValidateBankAcc(const ATarget: TAbsCustomer): Boolean;
var
  lTempStr: String;
begin
  Result := True;
  lTempStr := Trim(ATarget.acBankAcc);
  if (Length(lTempStr) <> DefaultACLength) or (not AllDigits(lTempStr)) or (lTempStr = '00000000') then
  begin
    Result := False;
    LogIt(ATarget.acCompany + ': Invalid account - ' + lTempStr);
  end;
end;

//Validate : Sort code can be in either NNNNNN format and should not 000000
function TMetroBankObject.ValidateBankSortCode(const ATarget: TAbsCustomer): Boolean;
var
  lTempStr: String;
begin
  Result := True;
  lTempStr := Trim(FormatSortCode(ATarget.acBankSort));
  if (Length(lTempStr) <> DefaultSortLength) or (lTempStr = '000000') or (not AllDigits(lTempStr)) then
  begin
    Result := False;
    LogIt(ATarget.acCompany + ': Invalid sort code - ' + lTempStr);
  end;
end;

//Validation : Trader Company name is not null.
function TMetroBankObject.ValidateCompanyName(const ATarget: TAbsCustomer;
  AACLength: Smallint): Boolean;
var
  lTempStr: String;
begin
  Result := True;
  lTempStr := AnsiReplaceStr(ATarget.acCompany, '&', #32);
  lTempStr := Trim(Copy(Bacs_Safe(lTempStr), 1, AACLength));
  if Length(lTempStr) = 0 then
  begin
    Result := False;
    LogIt(ATarget.acCompany + ': Invalid account name - ' + lTempStr);
  end;
end;

//Validation : Company Payment Type should be BACS.
function TMetroBankObject.ValidatePayType(const ATarget: TAbsCustomer): Boolean;
begin
  Result := True;
  if ATarget.acPayType <> 'B' then
  begin
    Result := False;
    LogIt(ATarget.acCompany + ': PayType not set to Bacs');
  end;
end;

function TMetroBankObject.ValidateRec(const EventData: TAbsEnterpriseSystem): Boolean;
var
  lTarget: TAbsCustomer;
begin
  Result := True;
  GetEventData(EventData);
  with EventData do
  begin
    lTarget := GetTarget(EventData);
    Result := ValidatePayType(lTarget) and Result;
    Result := ValidateCompanyName(lTarget, 18) and Result;
    Result := ValidateBankAcc(lTarget) and Result;
    Result := ValidateBankSortCode(lTarget) and Result;
    Result := ValidateAmount(EventData) and Result;
  end; {with EventData}
end;

function TMetroBankObject.ValidateSystem(const EventData: TAbsEnterpriseSystem): Boolean;
begin
  Result := True;

  {$IFDEF MULTIBACS}
    FCompanyBIC := LeftStr(Trim(UserBankSort), 6);
    FCompanyIBAN := LeftStr(Trim(UserBankAcc), 8);
  {$ELSE}
    FCompanyBIC := LeftStr(Trim(TAbsSetup10(EventData.Setup).ssBankSortCode), 6) ;
    FCompanyIBAN := LeftStr(Trim(TAbsSetup10(EventData.Setup).ssBankAccountCode), 8);
  {$ENDIF}

  if (Length(FCompanyIBAN) <> DefaultACLength) or (not AllDigits(FCompanyIBAN)) then
  begin
    Result := False;
    Failed := flBank;
  end;
  if (Length(FCompanyBIC) <> DefaultSortLength) or (not AllDigits(FCompanyBIC)) then
  begin
    Result := False;
    Failed := flBank;
  end;

  if not Result then
    Failed := flBank;

  if Result then
    LogIt('Validate system - successful');
end;

function TMetroBankObject.WriteData(const EventData: TAbsEnterpriseSystem): Boolean;
var
  lOutString: String;
  i: Integer;
begin
{$I-}
  Result := True;
  for i := 1 to FOldPayCount do
  begin
    with FPayRecs[i] do
    begin
      lOutString := Format(S_OUTSTRING_FORMAT, [DestBankSort,
                                                DestAccName,
                                                DestBankAcc,
                                                PayAmount,
                                                DestBankRef,
                                                SEGE_BACS_CODE]);
      Result := WriteThisRec(lOutString);
    end; {with}
  end; {for i}
end;

function TMetroBankObject.WriteRec(const EventData: TAbsEnterpriseSystem;
  Mode: word): Boolean;
var
  lAmount: Double;
  lTarget: TAbsCustomer;
  lDestRef,
  lDestAcc: String;
begin
  Result := True;
  lTarget := GetTarget(EventData);
  if Mode = wrContra then
  begin
    if FOldPayCount > 0 then
      Result := WriteBatch(EventData);
  end
  else
  if Mode = wrPayLine then
  begin
    with EventData, FPayRecs[PayCount] do
    begin
      if IsReceipt then
        lTarget := Customer
      else
        lTarget := Supplier;

      lAmount := Transaction.thCurrSettled;
      TotalPenceWritten := TotalPenceWritten + Pennies(lAmount);

      DestBankSort := Trim(lTarget.acBankSort);
      DestBankAcc := Trim(lTarget.acBankAcc);

      lDestAcc := AnsiReplaceStr(lTarget.acCompany, '&', #32);
      lDestAcc := Trim(Copy(Bacs_Safe(lDestAcc), 1, 18));
      DestAccName := lDestAcc;
      PayAmount := ABS(lAmount);
      lDestRef := AnsiReplaceStr(lTarget.acBankRef, '&', #32);
      lDestRef := Trim(Copy(Bacs_Safe(lDestRef), 1, 18));
      if not IsBlank(lDestRef) then
        DestBankRef := lDestRef
      else
        DestBankRef := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);

      Inc(TransactionsWritten);
      FOldPayCount := PayCount;
      Inc(PayCount);
      if PayCount > MaxCreditLines then
      begin
        Result := WriteBatch(EventData);
        PayCount := 1;
        FOldPayCount := 0;
      end;
    end;
  end
  else
    Result := True;
end;

end.
