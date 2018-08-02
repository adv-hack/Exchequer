unit bacstobj;

interface

uses
  Bacs00, CustAbsU;

type
  TBacstelExportObject = Class(TBacs1Obj)
       public
         function WriteRec(const EventData : TAbsEnterpriseSystem;
                            Mode : word) : Boolean; override;
     end;


var
 BacstelExportObject : TBacstelExportObject;


implementation

uses ExpObj, SysUtils;

function TBacstelExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                                  Mode : word) : Boolean;
var
  OutRec : BACS1IntRec;
  TempStr : string;
  pence : longint;
  OutString : string;
  Target : TAbsCustomer;
begin
  GetEventData(EventData);
  FillChar(OutRec, SizeOf(OutRec), 32);
  with EventData, OutRec do
  begin

    Target := GetTarget(EventData);

    Case Mode of

   wrContra : begin
                {nothing to do}
                Result := True;
              end;
  wrPayLine : begin
               Str2_Char(Target.acBankSort, DestSort, SizeOf(DestSort));
               Str2_Char(Target.acBankAcc, DestAcc, SizeOf(DestAcc));
               if IsReceipt then
                 TempStr := DirectDebitCode(Target.acDirDebMode)
               else {Payment}
                 TempStr := '99';
               Str2_Char(TempStr, TranCode, SizeOf(TranCode));
               Pence := Pennies(Transaction.thTotalInvoiced);
               TempStr := ZeroesAtFront(Pence, SizeOf(AmountP));
               Str2_Char(TempStr, AmountP, SizeOf(AmountP));
               Str2_Char(Bacs_Safe(Target.acCompany), DestName, SizeOf(DestName));
               if not IsBlank(Bacs_Safe(Target.acBankRef)) then
                 TempStr := Bacs_Safe(Target.acBankRef)
               else
                 TempStr := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);
               Str2_Char(TempStr, CompRef, SizeOf(CompRef));
               TotalPenceWritten := TotalPenceWritten + Pence;
               inc(TransactionsWritten);

               {write record here}
               with OutRec do
               begin
                 OutString :=  DESTSort +
                               DESTAcc   +
                               TranCode  +
                               AmountP   +
                               CompRef   +
                               DestName;
               end;
               Result := WriteThisRec(OutString);

             end; {not contra}
    end; {case}


  end; {with}
end;


end.
