unit BankLBulkBBTObj;

interface

uses
  CustAbsU, ExpObj;

type

  TBankLineBulkBBTObject = Class(TExportObject)
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

implementation

uses
  SysUtils, IniFiles, EtDateU;

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


procedure TBankLineBulkBBTObject.ReadIniFile(const DataPath, sBankGL : string);
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


{ TBankLineBulkBBTObject }


function TBankLineBulkBBTObject.CloseOutFile: integer;
begin
  Result := inherited CloseOutFile;
end;

function TBankLineBulkBBTObject.CreateOutFile(const AFileName: string;
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

function TBankLineBulkBBTObject.GetBeneficiaryRef(const EventData : TAbsEnterpriseSystem) : string;
begin
  Result := Bacs_Safe(Target.acBankRef);
end;

function TBankLineBulkBBTObject.GetCreditFields: string;
begin
  Result := '07' + lFiller2 + Target.acCode + lFiller3;
end;

function TBankLineBulkBBTObject.GetCurrencyString(
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

function TBankLineBulkBBTObject.GetDebitFields: string;
begin
  Result := '06' + hFiller2 + FListName + hFiller3;
end;

function TBankLineBulkBBTObject.WriteRec(
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
                Target.acBankAcc + lFiller7 + Bacs_Safe(Trim(Copy(Target.acUserDef2, 1, 35))) + lFiller8 + {Bacs_Safe(Target.acBankRef)}
                GetBeneficiaryRef(EventData) + lFiller9;
    Result := WriteThisRec(LineRec);

    TotalPenceWritten := TotalPenceWritten + Pennies(Amount);
    inc(TransactionsWritten);
  end
  else
    Result := True;
end;

constructor TBankLineBulkBBTObject.Create;
begin
  inherited;
  Initialise;
end;

procedure TBankLineBulkBBTObject.Initialise;
begin
  FIniFilename := 'BankLBBT.ini';
end;

//PR: ABSEXGENERIC-347 function to increment the date by the number of days specified in the ini file.
function TBankLineBulkBBTObject.GetDate(const ADate: string): string;
begin
  if FIncBy = 0 then
    Result := ADate
  else
    Result := CalcDueDatexDays(ADate, FIncBy);
end;

end.

