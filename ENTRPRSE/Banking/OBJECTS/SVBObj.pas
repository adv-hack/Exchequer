unit SVBObj;

interface

uses
  CustAbsU, ExpObj;

type

  TSVBObject = Class(TExportObject)
  private
    FListName : string;
    FReference : string;
    FCompanyBIC: string;
    FCompanyIBAN: string;
    function FormatDate(const ADate : string) : string;
    function ValidateIBAN(const IBAN : string) : Boolean;
    function ValidateAmount(const AAmount : Double) : Boolean;
    function ValidateCustomerRef(const ARef : string) : Boolean;
    /// Trader Validation
    function ValidatePayType(const ATarget : TAbsCustomer) : Boolean;
    function ValidateCompanyName(const ATarget : TAbsCustomer; AACLength : Smallint) : Boolean;
    function ValidateBankAcc(const ATarget : TAbsCustomer) : Boolean;
    function ValidateBankSortCode(const ATarget : TAbsCustomer) : Boolean;
    function ValidateBankRef(const ATarget : TAbsCustomer) : Boolean;
  protected
    FIniFileName : string;
    procedure ReadIniFile(const DataPath: String; sBankGL: String = ''); virtual;
  public
    constructor Create;
    procedure Initialise; virtual;
    function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function WriteRec(const EventData : TAbsEnterpriseSystem; Mode : word) : Boolean; override;
    function CreateOutFile(const AFileName : string; const EventData :
                          TAbsEnterpriseSystem) : integer; override;
    function CloseOutFile : integer; override;
    property CompanyBIC : string read FCompanyBIC;
    property CompanyIBAN : string read FCompanyIBAN;
  end;

  //HV 28/07/2016 2016-R3 ABSEXCH-17648: BACS - New format for Silicon Valley Bank (SVB)-BACS OR MULTI-BACS USER DEFINED FILE RECORD FORMAT
  TSVBUDObject = class(TSVBObject)
  private
    FPayType: String;
  public
    procedure Initialise; override;
    function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function WriteRec(const EventData : TAbsEnterpriseSystem; Mode : word) : Boolean; override;
    procedure ReadIniFile(const DataPath: String; sBankGL: String = ''); override;
  end;

implementation

uses
  SysUtils, IniFiles, EtDateU, StrUtils;

const
  PAY_TYPE_FP = 'FP';
  PAY_TYPE_MULTIBACS = 'MULTIBACS';
  PAY_TYPE_BACS = 'BACS';
  COMMA = ',';
  PAY_REF_CONTRA = 'CONTRA';  //payee reference field cannot contain the text ’CONTRA'
  PAY_AMT_LIMIT = 100000.00;  //Faster Payment amount value cannot exceed 100000.00

{ TSVBObject }

function TSVBObject.CloseOutFile: integer;
begin
  Result := inherited CloseOutFile;
end;

constructor TSVBObject.Create;
begin
  inherited;
  Initialise;
end;

function TSVBObject.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
begin
   Result := inherited CreateOutFile(AFilename, EventData);
end;

function TSVBObject.FormatDate(const ADate: string): string;
begin
  Result := Copy(ADate, 7, 2) +
            Copy(ADate, 5, 2) +
            Copy(ADate, 1, 4);
end;

procedure TSVBObject.Initialise;
begin
  FIniFilename := 'SVB.ini';
end;

procedure TSVBObject.ReadIniFile(const DataPath: string; sBankGL: string);
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
  Finally
    Free;
  End;
end;

function TSVBObject.ValidateAmount(const AAmount: Double): Boolean;
begin
  //Faster Payment amount value cannot exceed 100000.00
  Result := AAmount <= PAY_AMT_LIMIT;
end;

//Validation : Trader Bank Account Length with All Digits
function TSVBObject.ValidateBankAcc(const ATarget: TAbsCustomer): Boolean;
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

//Validate : Customer Reference, Validate Customer Bank Ref contain
function TSVBObject.ValidateBankRef(const ATarget: TAbsCustomer): Boolean;
var
  TempStr : string;
begin
  Result := True;
  TempStr := Trim(Copy(Bacs_Safe(ATarget.acBankRef), 1, 18)) ;
  if (Length(TempStr) = 0) or (not ValidateCustomerRef(TempStr)) then
  begin
    Result := False;
    LogIt(ATarget.acCompany + ': Invalid customer reference - ' + TempStr);
  end;
end;

//Validate : Sort code can be in either NNNNNN or NN-NN-NN format.
function TSVBObject.ValidateBankSortCode(const ATarget: TAbsCustomer): Boolean;
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
function TSVBObject.ValidateCompanyName(const ATarget: TAbsCustomer;
                                              AACLength : Smallint): Boolean;
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
function TSVBObject.ValidatePayType(const ATarget: TAbsCustomer): Boolean;
begin
  Result := True;
  if ATarget.acPayType <> 'B' then
  begin
    Result := False;
    LogIt(ATarget.acCompany + ': PayType not set to Bacs');
  end;
end;

function TSVBObject.ValidateCustomerRef(const ARef: string): Boolean;
  //Reference value must contain a string of at least 6 alphanumeric characters
  function GetAlphaNumCharCount(const aValue: String): Integer;
  var
    i : Smallint;
  begin
    Result := 0;
    for i := 1 to Length(aValue) do
    begin
      If (aValue[i] In ['0'..'9','A'..'Z']) then
        Inc(Result);
    end;
  end;
  //References must not contain a string of all the same alphanumeric characters e.g. all zeroes or all ’A s’.
  function CharElementsEqual(const aValue: String): Boolean;
  var
    i : Smallint;
  begin
    Result := True;
    for i := 2 to Length(aValue) do
    begin
      if aValue[1] <> aValue[i] then
      begin
        Result := False;
        Break;
      end;
    end;
  end;
begin
  Result := True;
  if AnsiPos(PAY_REF_CONTRA, UpperCase(ARef)) <> 0 then
    Result := False;
  if Result and (GetAlphaNumCharCount(UpperCase(ARef))<6) then
    Result := False;
  if Result and (CharElementsEqual(UpperCase(ARef))) then
    Result := False;
end;

function TSVBObject.ValidateIBAN(const IBAN: string): Boolean;
begin
  Result := Trim(IBAN) <> '';
end;

function TSVBObject.ValidateRec( const EventData: TAbsEnterpriseSystem): Boolean;
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
    Result := ValidateCompanyName(Target, 35) and Result;
    Result := ValidateBankAcc(Target) and Result;
    Result := ValidateBankSortCode(Target) and Result;
    Result := ValidateBankRef(Target) and Result;

    //Validate : Payment amount - Faster Payment amount value cannot exceed 100000.00.
    Amount := Transaction.thCurrSettled;
    If not ValidateAmount(Amount) then
    begin
      Result := False;
      LogIt(Target.acCompany + ': Faster payment amount value cannot exceed 100000.00');
    end;
  end; {with EventData}
end;

function TSVBObject.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
begin
  Result := True;

  {$IFDEF MULTIBACS}
    FCompanyBIC := LeftStr(Trim(UserBankSort),6);
    FCompanyIBAN := LeftStr(Trim(UserBankAcc),8);
  {$ELSE}
    FCompanyBIC := LeftStr(Trim(TAbsSetup10(EventData.Setup).ssBankSortCode),6) ;
    FCompanyIBAN := LeftStr(Trim(TAbsSetup10(EventData.Setup).ssBankAccountCode),8);
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

function TSVBObject.WriteRec(const EventData: TAbsEnterpriseSystem;
  Mode: word): Boolean;
var
  Amount : Double;
  OutString : string;
  Target : TAbsCustomer;
  DestRef : string;
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

      Amount := 0.00;
      Amount := Transaction.thCurrSettled;
      TotalPenceWritten := TotalPenceWritten + Pennies(Amount);
      Inc(TransactionsWritten);
      OutString :=  PAY_TYPE_FP + COMMA +
                    FormatDate(ProcControl.PDate) + COMMA +                   // Payment Date
                    Trim(Copy(Bacs_Safe(Target.acCompany), 1, 35)) + COMMA +  // Payee Name - Supplier Name
                    Trim(Target.acBankSort) + COMMA +                         // Payee Sort Bank code - Sort code number from Supplier (Trader) details
                    Trim(Target.acBankAcc) + COMMA +                          // Payee Bank Account Number - Bank Account Number from Supplier Details
                    Trim(Format('%8.2f', [Amount])) + COMMA +                 // Payment Amount
                    Trim(FCompanyIBAN) + COMMA +                              // Debit Account Number - SVB account number (e-banking setup) - 8 characters (Sort code for SVB - 6 characters )
                    Trim(Copy(Bacs_Safe(DestRef), 1, 18));                    // Payee Name - Customer Reference

      Result := WriteThisRec(OutString);
    end;
  end
  else
    Result := True;
end; 

{ TSVBUDObject }

procedure TSVBUDObject.Initialise;
begin
  FIniFilename := 'SVBUD.ini';
end;

procedure TSVBUDObject.ReadIniFile(const DataPath: String; sBankGL: string);
begin
  if FIniFilename <> '' then
  begin
    with TIniFile.Create(Datapath + FIniFilename) do
    try
      FPayType := ReadString('Payment Type', 'Value', '');
    finally
      Free;
    end;
  end;
end;

function TSVBUDObject.ValidateRec(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  Target  : TAbsCustomer;
begin
  Result := True;
  GetEventData(EventData);
  with EventData do
  begin
    Target := GetTarget(EventData);

    Result := ValidatePayType(Target) and Result;
    Result := ValidateCompanyName(Target, 35) and Result;
    Result := ValidateBankAcc(Target) and Result;
    Result := ValidateBankSortCode(Target) and Result;
    Result := ValidateBankRef(Target) and Result;

  end; {with EventData}
end;

function TSVBUDObject.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
begin
  Result := True;
  if Result then
  begin
    ReadIniFile(EventData.Setup.ssDataPath);
    if (FPayType <> PAY_TYPE_BACS) and (FPayType <> PAY_TYPE_MULTIBACS) then
    begin
      LogIt('Payment type not set in SVBUD.ini file');
      ShowExportMessage('Error','Payment type not set in SVBUD.ini file.', '');
      Result := False;
    end;
  end;
  if not Result then
    Failed := flBank
  else
    Result := inherited ValidateSystem(EventData);
end;

function TSVBUDObject.WriteRec(const EventData: TAbsEnterpriseSystem;
  Mode: word): Boolean;
var
  Amount : Double;
  OutString : string;
  Target : TAbsCustomer;
  DestRef : string;
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

      Amount := 0.00;
      Amount := Transaction.thCurrSettled;
      TotalPenceWritten := TotalPenceWritten + Pennies(Amount);
      Inc(TransactionsWritten);
      OutString :=  FPayType + COMMA +
                    FCompanyIBAN + COMMA +                                    // Debit Account Number - SVB account number (e-banking setup) - 8 characters (Sort code for SVB - 6 characters )
                    Trim(Copy(Bacs_Safe(Target.acCompany), 1, 35)) + COMMA +  // Payee Name - Supplier Name
                    Target.acBankSort + COMMA +                               // Payee Sort Bank code - Sort code number from Supplier (Trader) details
                    Target.acBankAcc + COMMA +                                // Payee Bank Account Number - Bank Account Number from Supplier Details
                    Trim(Format('%8.2f', [Amount])) + COMMA +                 // Payment Amount
                    FormatDate(ProcControl.PDate) + COMMA +                   // Payment Date
                    Trim(Copy(Bacs_Safe(DestRef), 1, 18));                    // Payee Name - Customer Reference

      Result := WriteThisRec(OutString);
    end;
  end
  else
    Result := True;
end;

end.
