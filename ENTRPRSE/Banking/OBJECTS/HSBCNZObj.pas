unit HSBCNZObj;

interface

uses
  ExpObj, CustAbsU, Classes;

type
  THSBCNZExporter = Class(TExportObject)
  private
    FUserID : string;
    FOutputList : TStringList;
    FPaymentSetNo : string;
    function GetHeaderRec : string;
  public
    constructor Create;
    destructor Destroy; override;
    function CreateOutFile(const AFileName : string;
                           const EventData : TAbsEnterpriseSystem) : integer;  override;
    function WriteRec(const EventData : TAbsEnterpriseSystem;
                          Mode : word) : Boolean; override;
    function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function CloseOutFile : integer; override;

  end;

implementation

uses
  SysUtils, IniFiles, Dialogs, Controls, MultIni;

{ THSBCNZExporter }
const
  Filler = '099';
  OurSort = '405162';
  Filler2 = '    '; //4 spaces

function THSBCNZExporter.CloseOutFile: integer;
begin
  FOutputList.Insert(0, GetHeaderRec);
  {$I-}
  FOutputList.SaveToFile(OutFilename);
  {$I+}
  Result := IOResult;
end;

constructor THSBCNZExporter.Create;
begin
  inherited;
  FOutputList := TStringList.Create;
end;

function THSBCNZExporter.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
var
  VAOPath : string;
  LRequiredPath : String;
begin
  GetEventData(EventData);
  IsReceipt := ProcControl.SalesPurch;
  LRequiredPath := CheckPath(EventData.Setup.ssDataPath);
  with TIniFile.Create(LRequiredPath + VAOIniFilename) do
  Try
    VAOPath := CheckPath(ReadString('Paths','Output',''));
  Finally
    Free;
  End;
  OutFileName := AFilename;
  if VAOPath <> '' then
    OutFileName := VAOPath + ExtractFilename(OutFilename);
end;

destructor THSBCNZExporter.Destroy;
begin
  FOutputList.Free;
  inherited;
end;

function THSBCNZExporter.GetHeaderRec: string;
var
  TotalAmountWritten : Double;
begin
  TotalAmountWritten := TotalPenceWritten;
  TotalAmountWritten := TotalAmountWritten / 100;
  
  Result := '1NZHSBC' +  UserBankAcc + FPaymentSetNo + ZerosAtFront(TransactionsWritten, 6) +
            ZerosAtFront(TotalAmountWritten, 17) + ProcControl.PDate + 'APO' +
            LJVar('Payment Run: ' + IntToStr(ProcControl.PayRun), 24) + 'A' + StringOfChar(' ', 53) + '1';
end;

function THSBCNZExporter.ValidateRec(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  TempStr : string;
  Target : TAbsCustomer;
begin
  Result := True;
  GetEventData(EventData);
  with EventData do
  begin
    Target := Supplier;

    if Target.acPayType <> 'B' then
    begin
      Result := False;
      LogIt(Target.acCompany + ': PayType not set to Bacs');
    end;
    TempStr := Target.acBankRef;
    if (Length(TempStr) <> 16) or not AllDigits(TempStr) then
    begin
      Result := False;
      LogIt(Target.acCompany + ': Invalid account - ' + TempStr);
    end;
    TempStr := FormatSortCode(Target.acBankSort);
    if (Length(TempStr) <> DefaultSortLength) or not AllDigits(TempStr) then
    begin
      LogIt(Target.acCompany + ': Invalid sort code - ' + TempStr);
      Result := False;
    end;
  end; {with EventData}
end;

function THSBCNZExporter.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  IniFilename : string;
begin
  DefaultAcLength := 12;
  if Length(UserBankAcc) <> 12 then
    UserBankAcc := UserBankRef;
  Result := Inherited ValidateSystem(EventData);
  if Result then
  begin
    IniFilename := IncludeTrailingBackslash(EventData.Setup.ssDataPath) + 'HSBCNZ.ini';
    with TIniFile.Create(IniFilename) do
    Try
      FPaymentSetNo := ReadString('Settings','PaymentSetNo','');
    Finally
      Free;
    End;
    Result := Length(FPaymentSetNo) = 3;
    if not Result then
      LogIt('Invalid Payment Set No: ' + FPaymentSetNo);
  end;
end;

function THSBCNZExporter.WriteRec(const EventData: TAbsEnterpriseSystem;
  Mode: word): Boolean;
var
  OutS : String;
  Pence : longint;
  Target : TAbsCustomer;
begin
  if Mode <> wrContra then
  begin
    GetEventData(EventData);
    with EventData do
    begin
      Target := Supplier;

      Pence := Pennies(ProcControl.Amount);
      TotalPenceWritten := TotalPenceWritten + Pence;
      Inc(TransactionsWritten);

      OutS := '2' + RJVar(Target.acCode, 12) + 'ANZD' + ZerosAtFront(ProcControl.Amount, 16) +
              StringOfChar(' ', 8) + LJVar(Target.acBankSort, 8) + LJVar(Target.acBankRef, 20) +
              StringOfChar(' ', 8) + LJVar(Target.acCompany, 20) + RJVar(Transaction.thOurRef, 12) +
              StringOfChar(' ', 26);

    end;
  end;
  FOutputList.Add(OutS);
  Result := True;
end;

end.
