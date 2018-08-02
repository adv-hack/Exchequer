unit bacs00;

interface

uses
  CustAbsU, ExpObj;



type

     BACS1IntRec  =  Record
                      DESTSort  :  Array[1..6] of Char;
                      DESTAcc   :  Array[1..8] of Char;
                      ZFill1    :  Char;
                      TranCode  :  Array[1..2] of Char;
                      CompSort  :  Array[1..6] of Char;
                      CompAcc   :  Array[1..8] of Char;
                      ZFill2    :  Array[1..4] of Char;
                      AmountP   :  Array[1..11] of Char;
                      CompName  :  Array[1..18] of Char;
                      CompRef   :  Array[1..18] of Char;
                      DestName  :  Array[1..18] of Char;
                    end;

     TBacs1Obj = Class(TExportObject)
       public
         function WriteRec(const EventData : TAbsEnterpriseSystem;
                            Mode : word) : Boolean; override;
     end;

var
  Bacs1Obj : TBacs1Obj;



implementation

uses
  SysUtils, Dialogs;

function TBacs1Obj.WriteRec(const EventData : TAbsEnterpriseSystem;
                            Mode : Word) : Boolean;
var
  OutRec : BACS1IntRec;
  TempStr : Str255;
  pence : longint;
  OutString : string;
  Target : TAbsCustomer;
begin
  GetEventData(EventData);
  FillChar(OutRec, SizeOf(OutRec), 32);
  with EventData, OutRec do
  begin

    if IsReceipt then
      Target := Customer
    else
      Target := Supplier;

    Case Mode of

    Contra : begin
               Str2_Char(MakeDigits(UserBankAcc, SizeOf(DestAcc)), DestAcc, SizeOf(DestAcc));
               Str2_Char(MakeDigits(UserBankSort, SizeOf(DestSort)), DestSort, SizeOf(DestSort));
               ZFill1 := '0';
               if IsReceipt then
                 TranCode := '99'
               else
                 TranCode := '17';
               Str2_Char(MakeDigits(UserBankAcc, SizeOf(CompAcc)), CompAcc, SizeOf(CompAcc));
               Str2_Char(MakeDigits(UserBankSort, SizeOf(CompSort)), CompSort, SizeOf(CompSort));
               TempStr := '0000';
               Str2_Char(TempStr, ZFill2, SizeOf(ZFill2));
               TempStr := ZeroesAtFront(TotalPenceWritten, SizeOf(AmountP));
               Str2_Char(TempStr, AmountP, SizeOf(AmountP));
               TempStr := 'BACS ' + IntToStr(ProcControl.PayRun);
               Str2_Char(TempStr, CompName, SizeOf(CompName));
               TempStr := 'CONTRA';
               Str2_Char(TempStr, CompRef, SizeOf(CompRef));
               Str2_Char(Bacs_Safe(Setup.ssUserName), DestName, SizeOf(DestName));
              end;
    PayLine : begin
               Str2_Char(Target.acBankSort, DestSort, SizeOf(DestSort));
               Str2_Char(Target.acBankAcc, DestAcc, SizeOf(DestAcc));
               ZFill1 := '0';
               if IsReceipt then
               begin
                 Case Target.acDirDebMode of
                   0  : TranCode := '01';
                   1  : TranCode := '17';
                   2  : TranCode := '18';
                   3  : TranCode := '19';
                 end; {Case}
               end
               else {Payment}
                 TranCode := '99';

               Str2_Char(MakeDigits(UserBankAcc, SizeOf(CompAcc)), CompAcc, SizeOf(CompAcc));
               Str2_Char(MakeDigits(UserBankSort, SizeOf(CompSort)), CompSort, SizeOf(CompSort));
               TempStr := '0000';
               Str2_Char(TempStr, ZFill2, SizeOf(ZFill2));
               Pence := Pennies(Transaction.thTotalInvoiced);
               TempStr := ZeroesAtFront(Pence, SizeOf(AmountP));
               Str2_Char(TempStr, AmountP, SizeOf(AmountP));
               Str2_Char(Bacs_Safe(Setup.ssUserName), CompName, SizeOf(CompName));

               Str2_Char(Bacs_Safe(Target.acCompany), DestName, SizeOf(DestName));
               Str2_Char(Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun),
                           CompRef, SizeOf(CompRef));
               TotalPenceWritten := TotalPenceWritten + Pence;
               inc(TransactionsWritten);
             end; {not contra}
    end; {case}


  end; {with}
  {write record here}
  with OutRec do
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
