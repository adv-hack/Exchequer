unit HypoVObj;

interface
{$H-}
uses
  CustAbsU, ExpObj;



type

   THypoVObj = Class(TExportObject)
   protected
     function PaymentDebitType : string;
     function FileType : string;
     function HeaderRec(const EventData : TAbsEnterpriseSystem) : string;
     function TrailerRec : string;

   public
     function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean;
                                      override;
     function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
     function FormatSortCode(SortCode : string) : string; override;
     function CreateOutFile(const AFileName : AnsiString;
                            const EventData :
                            TAbsEnterpriseSystem) : integer;  override;
     function CloseOutFile : integer; override;
     function WriteRec(const EventData : TAbsEnterpriseSystem;
                         Mode : word) : Boolean; override;
     constructor Create;
   end;

implementation

{ THypoVObj }
uses
  SysUtils, Dialogs;

function THypoVObj.CloseOutFile: integer;
begin
  WriteLn(OutFile, TrailerRec);
  Result := inherited CloseOutFile;
end;

constructor THypoVObj.Create;
begin
  inherited Create;
  DefaultSortLength := 8;
  DefaultACLength := 10;
end;

function THypoVObj.CreateOutFile(const AFileName: AnsiString;
  const EventData: TAbsEnterpriseSystem): integer;
begin
  Result := inherited CreateOutFile(AFilename, EventData);
  if Result = 0 then
    WriteLn(OutFile, HeaderRec(EventData));
end;

function THypoVObj.FileType: string;
begin
  if IsReceipt then
    Result := 'LK'
  else
    Result := 'GK';
end;

function THypoVObj.FormatSortCode(SortCode: string): string;
begin
  while Pos('-', SortCode) > 0 do
    Delete(SortCode, Pos('-', SortCode), 1);
  Result := SortCode;
end;

function THypoVObj.HeaderRec(
  const EventData: TAbsEnterpriseSystem): string;
begin
  Result := '0128A' +
            FileType +
            FormatSortCode(UserBankSort) +
            StringOfChar('0', 8) +
            LJVar(Bacs_Safe(EventData.Setup.ssUserName), 27) +
            FormatDateTime('mmddyy', Date) +
            '    ' +
            ZerosAtFront(UserBankAcc, 10) +
            StringOfChar('0', 10) +
            StringOfChar(' ', 15) +
            DDMMYYYY(ProcControl.PDate) +
            StringOfChar(' ', 24) +
            '1';
end;

function THypoVObj.PaymentDebitType: string;
begin
  if IsReceipt then
    Result := '04000'
  else
    Result := '05005';
end;

function THypoVObj.TrailerRec : string;
begin
  Result := '0128E' +
            StringOfChar(' ', 5) +
            ZerosAtFront(TransactionsWritten, 7) +
            StringOfChar('0', 13) +
            ZerosAtFront(TransactionsWritten, 17) +
            ZerosAtFront(TransactionsWritten, 17) +
            Pounds(TotalPenceWritten, 13) +
            StringOfChar(' ', 51);
end;



function THypoVObj.ValidateRec(
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
    TempStr := Target.acBankAcc;
    if (Length(TempStr) > DefaultACLength) or not AllDigits(TempStr) then
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

function THypoVObj.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  TempStr : Shortstring;
begin
  Result := True;
  with EventData.Setup do
  begin
    TempStr := UserBankAcc;
    if (Length(TempStr) > DefaultACLength) or not AllDigits(TempStr) then
    begin
      Result := False;
      failed := flBank;
    end;
    TempStr := FormatSortCode(UserBankSort);
    if (Length(TempStr) <> DefaultSortLength) or not AllDigits(TempStr) then
    begin
      Result := False;
      failed := flBank;
    end;
  end; {with EventData.Setup}
  if Result then
    LogIt('Validate system - successful');
end;

function THypoVObj.WriteRec(const EventData: TAbsEnterpriseSystem;
  Mode: word): Boolean;
var
  OutString : string;
  Target : TAbsCustomer;
  pence : longint;
begin
  if Mode <> wrContra then
  begin
    GetEventData(EventData);

    if IsReceipt then
      Target := EventData.Customer
    else
      Target := EventData.Supplier;

    Pence := Pennies(ProcControl.Amount);
    OutString := '0187' +
                 'C' +
                 FormatSortCode(UserBankSort) +
                 FormatSortCode(Target.acBankSort) +
                 ZerosAtFront(Target.acBankAcc, 10) +
                 StringOfChar('0', 13) +
                 PaymentDebitType +
                 ' ' +
                 StringOfChar('0', 11) +
                 FormatSortCode(UserBankSort) +
                 ZerosAtFront(UserBankAcc, 10) +
                 Pounds(Pence, 11) +
                 '   ' +
                 LJVar(Bacs_Safe(Target.acCompany), 27) +
                 StringOfChar(' ', 8) +
                 LJVar(Bacs_Safe(EventData.Setup.ssUserName), 27) +
                 LJVar(Bacs_Safe(Target.acBankRef), 27) +
                 '1  00';

      Result := WriteThisRec(OutString);
      TotalPenceWritten := TotalPenceWritten + Pence;
      inc(TransactionsWritten);
  end
  else
    Result := True;
end;

end.
