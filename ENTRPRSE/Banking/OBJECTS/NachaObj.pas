unit NachaObj;

interface

{$H-}
uses
  CustAbsU, ExpObj, Enterprise04_TLB, CTKUtil04;

type

   TNachaObject = Class(TExportObject)
   private
     FHash : String;
     FEventData : TAbsEnterpriseSystem;
     FOriginatingFII : string;
     FToolkit : IToolkit;
     FNumberOfBlockingRecords : Byte;
     FUserID : string;
   protected
     function TransType : string;
     function FileType : string;
     function FileHeaderRec(const EventData : TAbsEnterpriseSystem) : string;
     function BatchHeaderRec(const EventData : TAbsEnterpriseSystem) : string;
     function BatchTrailerRec : string;
     function FileTrailerRec : string;
     procedure AddToHash(const SortCode : string);
     function CheckDigit(const SortCode : string) : Char;
     function CompanyID : String;
     function EffectiveDate : String;
     function FileIDModifier : Char;
     function OriginatingFII : String;
     function BatchNo : String;
     function GetHash : string;
     function TraceNo : string;
     function GetTotalAmounts : string;
     function GetDescription : string;
     function BlockCount : Integer;
     procedure WriteBlockingRecords;
     procedure ReadIniFile(const EventData : TAbsEnterpriseSystem);
   public
     function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean;
                                      override;
     function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
     function CreateOutFile(const AFileName : AnsiString;
                            const EventData :
                            TAbsEnterpriseSystem) : integer;  override;
     function CloseOutFile : integer; override;
     function WriteRec(const EventData : TAbsEnterpriseSystem;
                         Mode : word) : Boolean; override;
     constructor Create;
     destructor Destroy; override;
   end;


implementation

{ TNachaObject }
uses
  SysUtils, IniFiles, MultIni, EtDateU, Math, EtMiscU, Windows, ActiveX;

const
  CheckDigitMultipliers : Array[1..8] of Integer = (3, 7, 1, 3, 7, 1, 3, 7);
  TransTypes : Array[False..True] of String[2] = ('22', '27');  {Credit, Debit}
  S_INI_FILENAME = 'Nacha.ini';



procedure TNachaObject.AddToHash(const SortCode: string);
var
  iHash : Int64;
begin
  iHash := StrToInt(FHash) + StrToInt(Copy(SortCode, 1, 8));
  FHash := Format('%.10d', [iHash]);
end;

function TNachaObject.BatchHeaderRec(
  const EventData: TAbsEnterpriseSystem): string;
begin
  Result := '5200' +  LJVar(EventData.Setup.ssUserName, 16) + StringOfChar(' ', 20) +  LJVar(CompanyID, 10) + 'PPD' +
                      GetDescription + EffectiveDate + EffectiveDate + '   1' + OriginatingFII + BatchNo;
end;

function TNachaObject.BatchNo: String;
begin
  Result := '0000001';
end;

function TNachaObject.BatchTrailerRec: string;
begin
  Result := '8200' + ZerosAtFront(TransactionsWritten, 6) + GetHash + GetTotalAmounts + LJVar(CompanyID, 10) +
             StringOfChar(' ', 25) + Copy(UserBankSort, 1, 8) + BatchNo;
end;

{
The check digit is computed using Modulus 10 as follows:
     (1)  Multiply each digit in the transit/routing number by a weighting factor.  The
            weighting factors for each digit are:
            Position : 1 2 3 4 5 6 7 8
            Weights:   3 7 1 3 7 1 3 7
     (2)  Add the results of the eight multiplications.
     (3)  Subtract the sum from the next highest multiple of 10.  The result is the check digit.

Example:
Transit/ABA Number  0  7  6  4  0  1  2  5
Multiply By	    3  7  1  3  7  1  3  7
		    0 49  6 12  0  1  6 35
Sum = 109
Check Digit = 1 (110 minus 109)

}
function TNachaObject.CheckDigit(const SortCode: string): Char;
var
  i, iTotal, iNum : Integer;
begin
  iTotal := 0;
  for i := 1 to 8 do
    iTotal := iTotal + (StrToInt(SortCode[i]) * CheckDigitMultipliers[i]);

  iNum := iTotal mod 10;
  if iNum > 0 then
    iNum := 10 - iNum;

  Result := Char(iNum + 48);
end;

function TNachaObject.CloseOutFile: integer;
begin
  FNumberOfBlockingRecords := (4 + TransactionsWritten) mod 10;
  if FNumberOfBlockingRecords <> 0 then
    FNumberOfBlockingRecords := 10 - FNumberOfBlockingRecords;
  WriteLn(OutFile, BatchTrailerRec);
  WriteLn(OutFile, FileTrailerRec);
  WriteBlockingRecords;
  Result := inherited CloseOutFile;
end;

constructor TNachaObject.Create;
begin
  inherited Create;
  DefaultSortLength := 8;
  FHash := '0';
  {$IFNDEF MULTIBACS}
  CoInitialize(nil);
  {$ENDIF}
  FToolkit := CreateToolkitWithBackdoor;
end;

function TNachaObject.CreateOutFile(const AFileName: AnsiString;
  const EventData: TAbsEnterpriseSystem): integer;
var
  Res : Integer;
begin
  Result := inherited CreateOutFile(AFilename, EventData);
  if Result = 0 then
  begin
    FEventData := EventData;
    WriteLn(OutFile, FileHeaderRec(EventData));
    WriteLn(OutFile, BatchHeaderRec(EventData));
    FToolkit.Configuration.DataDirectory := EventData.Setup.ssDataPath;
    Res := FToolkit.OpenToolkit;
    if Res <> 0 then
      Result := -1;
  end;
end;

function TNachaObject.EffectiveDate: String;
begin
  Result := YYMMDD(CalcDueDate(ProcControl.PDate, 1));
end;

function TNachaObject.OriginatingFII: String;
//This is the Transit Routing Number of the originating bank - ie the bank sort code from system setup
//We store this during ValidateSystem
begin
  Result := FOriginatingFII;
end;

function TNachaObject.FileHeaderRec(
  const EventData: TAbsEnterpriseSystem): string;
begin
  Result := '101 022000020' + LJVar(CompanyID, 10) + FormatDateTime('yymmddhhnn', Now) + FileIDModifier + '094101HSBC Bank USA          ' +
             LJVar(EventData.Setup.ssUserName, 23) + StringOfChar(' ', 8);
end;

function TNachaObject.FileIDModifier: Char;
var
  sDate : string;
  sFID : string;
begin
  with TIniFile.Create(DataPath + 'Nacha.fid') do
  Try
    sDate := ReadString('Settings', 'LastRun', '');
    sFID := ReadString('Settings', 'FIDModifier', 'A');
    Try
      Result := sFID[1];
    Except
      Result := 'A';
    End;
    if sDate = FormatDateTime('yyyymmdd', Now) then
    begin
      if Result = 'Z' then
        Result := 'A'
      else
        Result := Succ(Result);
    end;
  Finally
    WriteString('Settings', 'LastRun', FormatDateTime('yyyymmdd', Now));
    WriteString('Settings', 'FIDModifier', '' + Result);
    Free;
  End;
end;

function TNachaObject.FileTrailerRec: string;
begin
  Result := '9000001' + ZerosAtFront(BlockCount, 6) + ZerosAtFront(TransactionsWritten, 8) + GetHash + GetTotalAmounts + StringOfChar(' ', 39);
end;

function TNachaObject.FileType: string;
begin

end;

function TNachaObject.CompanyID: String;
begin
  if IsReceipt then
    Result := '9' + FUserID
  else
    Result := '1' + FUserID;

  Result := LJVar(Result, 10);
end;

function TNachaObject.TransType: string;
begin
  Result := TransTypes[IsReceipt];
end;

function TNachaObject.ValidateRec(
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
    TempStr := Trim(Target.acBankAcc);
    if (Length(TempStr) = 0) then
    begin
      Result := False;
      LogIt(Target.acCompany + ': Invalid account - ' + TempStr);
    end;
    TempStr := Target.acBankSort;
    if (Length(TempStr) <> DefaultSortLength) then
    begin
      LogIt(Target.acCompany + ': Invalid sort code - ' + TempStr);
      Result := False;
    end;
  end;
end;

function TNachaObject.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  TempStr : Shortstring;
begin
  Result := True;
  ReadIniFile(EventData);
  with EventData.Setup do
  begin
    TempStr := Trim(UserBankAcc);
    if (Length(TempStr) = 0) then
    begin
      Result := False;
      failed := flBank;
    end;
    TempStr := Copy(UserBankSort, 1, 8);
    if (Length(TempStr) <> DefaultSortLength) then
    begin
      Result := False;
      failed := flBank;
    end;
  end; {with EventData.Setup}
  if Result then
  begin
    LogIt('Validate system - successful');

    FOriginatingFII := Copy(UserBankSort, 1, 8);
  end;
end;

function TNachaObject.WriteRec(const EventData: TAbsEnterpriseSystem;
  Mode: word): Boolean;
var
  OutString : string;
  Target : TAbsCustomer;
  pence : longint;
  oTarget : IAccount;
  Res : Integer;
begin
  if Mode <> wrContra then
  begin
    GetEventData(EventData);
    FEventData := EventData;

    if IsReceipt then
    begin
      Target := EventData.Customer;
      oTarget := FToolkit.Customer;
    end
    else
    begin
      Target := EventData.Supplier;
      oTarget := FToolkit.Supplier;
    end;

    oTarget.Index := acIdxCode;
    Res := oTarget.GetEqual(oTarget.BuildCodeIndex(Target.acCode));
    Pence := Pennies(ProcControl.Amount);

    OutString := '6' + TransType + Copy(Target.acBankSort, 1, 8) + CheckDigit(Target.acBankSort) + LJVar(oTarget.acBankAcc, 17) +
                       ZerosAtFront(Pence, 10) + LJVar(Target.acCode, 15) + LJVar(Target.acCompany, 22) + '  0' + TraceNo;

    Result := WriteThisRec(OutString);
    TotalPenceWritten := TotalPenceWritten + Pence;
    inc(TransactionsWritten);
    AddToHash(Target.acBankSort);
  end
  else
    Result := True;
end;

function TNachaObject.GetHash: string;
begin
  Result := FHash;
  if Length(Result) > 10 then
    Result := Copy(Result, 1, 10);
end;

function TNachaObject.TraceNo: string;
begin
  Result := Copy(UserBankSort, 1, 8) + Format('%.7d', [TransactionsWritten + 1]);
end;

function TNachaObject.GetTotalAmounts: string;
begin
  Result := ZerosAtFront(TotalPenceWritten, 12);
  if IsReceipt then
    Result := Result + StringOfChar('0', 12)
  else
    Result := StringOfChar('0', 12) + Result;
end;

function TNachaObject.GetDescription: string;
begin
  if IsReceipt then
    Result := 'REC'
  else
    Result := 'PAY';

  Result := LJVar(Result + IntToStr(ProcControl.PayRun), 10);
end;

destructor TNachaObject.Destroy;
begin
  FToolkit := nil;
  inherited Destroy;
end;

function TNachaObject.BlockCount: Integer;
var
  dLines : Double;
  iLines : Integer;
begin
  iLines := TransactionsWritten + 4 + FNumberOfBlockingRecords;
  if iLines = (iLines div 10) * 10 then
    Result := iLines div 10
  else
  begin       //Should never happen
    dLines := TransactionsWritten + 4;
    dLines := Round((dLines / 10) + 0.5);
    Result := Trunc(dLines);
  end;
end;

procedure TNachaObject.WriteBlockingRecords;
var
  i : Integer;
begin
  if FNumberOfBlockingRecords > 0 then
    for i := 1 to FNumberOfBlockingRecords do
      WriteThisRec(StringOfChar('9', 94));
end;

procedure TNachaObject.ReadIniFile(const EventData: TAbsEnterpriseSystem);
begin
  with TIniFile.Create(EventData.Setup.ssDataPath + S_INI_FILENAME) do
  Try
    {$IFDEF MULTIBACS}
    //Take User ID from database if available
    FUserID := UserID;
    if FUserID = '' then
    {$ENDIF}
      FUserID := ReadString('Settings','CompanyID', '');
    UserBankSort := ReadString('Settings','SortCode', '');
    if Trim(UserBankAcc) = '' then
      UserBankAcc := UserBankRef;
  Finally
    Free;
  End;
end;

end.
