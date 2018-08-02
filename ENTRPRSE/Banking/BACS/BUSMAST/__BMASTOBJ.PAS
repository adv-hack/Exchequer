unit BMastObj;

{ prutherford440 15:10 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  CustAbsU, MultiObj, BacNcObj, Bacs00;

const
  MaxLines = 4;
  MaxOutFiles = 99999;
  DefaultExt = '.txt';

type
  TBusinessMasterExportObject = Class(TMultiFileExportObject)
    protected
      PayRecs    : Array[1..MaxOutFiles] of BACS1IntRec;
      OldPayCount : integer;
      function WriteData(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    public
      constructor Create;
      function WriteRec(const EventData : TAbsEnterpriseSystem;
                                Mode : word) : Boolean; override;
    end;


implementation

uses
  ExpObj, SysUtils;

constructor TBusinessMasterExportObject.Create;
begin
  inherited Create;
  RecsPerFile := MaxLines;
  FMaxFiles := MaxOutFiles;
  Ext := DefaultExt;
  PayCount := 1;
end;




function TBusinessMasterExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                     Mode : word) : Boolean;
var
  Target : TAbsCustomer;
  TempStr : string;
  Pence : longint;
begin
  Result := True;
  Target := GetTarget(EventData);
  if Mode = wrContra then
  begin
    if OldPayCount > 0 then
      Result := WriteBatch(EventData);
  end
  else
  begin
    with EventData, PayRecs[PayCount] do
    begin
               Str2_Char(Target.acBankSort, DestSort, SizeOf(DestSort));
               Str2_Char(Target.acBankAcc, DestAcc, SizeOf(DestAcc));
               ZFill1 := '0';
               if IsReceipt then
                 TempStr := DirectDebitCode(Target.acDirDebMode)
               else {Payment}
                 TempStr := '99';
               Str2_Char(TempStr, TranCode, SizeOf(TranCode));
               Str2_Char(MakeDigits(UserBankAcc, SizeOf(CompAcc)), CompAcc, SizeOf(CompAcc));
               Str2_Char(MakeDigits(UserBankSort, SizeOf(CompSort)), CompSort, SizeOf(CompSort));
               TempStr := '0000';
               Str2_Char(TempStr, ZFill2, SizeOf(ZFill2));
               Pence := Pennies(Transaction.thTotalInvoiced);
               TempStr := ZerosAtFront(Pence, SizeOf(AmountP));
               Str2_Char(TempStr, AmountP, SizeOf(AmountP));
               Str2_Char(Bacs_Safe(Setup.ssUserName), CompName, SizeOf(CompName));

               Str2_Char(Bacs_Safe(Target.acCompany), DestName, SizeOf(DestName));
               if not IsBlank(Bacs_Safe(Target.acBankRef)) then
                 TempStr := Bacs_Safe(Target.acBankRef)
               else
                 TempStr := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);
               Str2_Char(TempStr, CompRef, SizeOf(CompRef));
               TotalPenceWritten := TotalPenceWritten + Pence;
               inc(TransactionsWritten);
    end;
    OldPayCount := PayCount;
    inc(PayCount);
    if PayCount > MaxLines then
    begin
      Result := WriteBatch(EventData);
      PayCount := 1;
      OldPayCount := 0;
    end;
  end; {with}
end;

function TBusinessMasterExportObject.WriteData(const EventData :
                                           TAbsEnterpriseSystem) : Boolean;
var
  i : integer;
  OutString : string;
begin
  Result := True;
  for i := 1 to PayCount do
  with PayRecs[PayCount] do
  begin
    OutString :=  DESTSort +
                  DESTAcc   +
                  ZFill1 +
                  TranCode  +
                  CompSort  +
                  CompAcc   +
                  ZFill2    +
                  AmountP   +
                  CompName  +
                  CompRef   +
                  DestName;
  end;
  Result := WriteThisRec(OutString);
end;






end.
