unit paywayob;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  ExpObj, CustAbsU;

type

  TPayawayExportRec = Record
    DestSort : Array[1..8] of Char;
    DestAcc  : Array[1..8] of Char;
    DestName  : Array[1..18] of Char;
    AmountP  : Array[1..11] of Char;
    Ref      : Array[1..18] of Char;
    TransCode : Array[1..2] of Char;
    AcType    : Char;
    ProcDate  : Array[1..8] of Char;
    TransID   : Array[1..6] of Char;
    Desc      : Array[1..34] of char;
  end;

  TPayawayExportObject = Class(TExportObject)
      function WriteRec(const EventData : TAbsEnterpriseSystem;
                        Mode : word) : Boolean; override;
      function ValidateSystem(const EventData : TAbsEnterpriseSystem): Boolean;  override;
  end;


implementation

uses
  SysUtils;

function TPayawayExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                         Mode : word) : Boolean; 
var
  OutRec : TPayawayExportRec;
  Target : TAbsCustomer;
  OutString, TempStr : string;
  Pence : longint;
begin
  if Mode = wrContra then
  begin
    Result := True;
  end
  else
  begin
    FillChar(OutRec, SizeOf(OutRec), #32);

    with EventData, OutRec do
    begin
      if IsReceipt then
        Target := Customer
      else
        Target := Supplier;

        TempStr := Copy(Target.acBankSort, 1, 2) + '-' +
                   Copy(Target.acBankSort, 3, 2) + '-' +
                   Copy(Target.acBankSort, 5, 2);

        Str2_Char(TempStr, DestSort, SizeOf(DestSort));
        Str2_Char(Target.acBankAcc, DestAcc, SizeOf(DestAcc));

        Str2_Char(Bacs_Safe(Target.acCompany), DestName, SizeOf(DestName));

        Pence := Pennies(Transaction.thTotalInvoiced);
        TempStr := Pounds(Pence);
        Str2_Char(TempStr, AmountP, SizeOf(AmountP));

        if not IsBlank(Bacs_Safe(Target.acBankRef)) then
          TempStr := Bacs_Safe(Target.acBankRef)
        else
          TempStr := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);
        Str2_Char(TempStr, Ref, SizeOf(Ref));

        if IsReceipt then
          TempStr := DirectDebitCode(Target.acDirDebMode)
        else {Payment}
          TempStr := '99';
        Str2_Char(TempStr, TransCode, SizeOf(TransCode));

        TotalPenceWritten := TotalPenceWritten + Pence;
        inc(TransactionsWritten);

        OutString := DestSort + DestAcc + DestName + AmountP + Ref + TransCode +
          AcType + ProcDate + TransID + Desc;

        Result := WriteThisRec(OutString);
    end;
  end;
end;

function TPayawayExportObject.ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
//We don't output any system details so result is always true
  Result := True;
end;

end.
