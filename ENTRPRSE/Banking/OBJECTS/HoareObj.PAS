unit HoareObj;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

//PR: 16/03/2012 v6.10 ABSEXCH-12013 Added format for E Hoare & Co bank.
interface

uses
  ExpObj, CustAbsU;

type
  THoarePayRec = Record
    DestSort : string[6];
    DestName : string[18];
    DestAcc  : string[8];
    Amount   : longint;
    Ref      : string[18];
  end;

  THoarePayExportObject = class(TExportObject)
    function WriteRec(const EventData: TAbsEnterpriseSystem;
                            Mode: word) : Boolean; override;
  end;

  //HV 13/04/2017 2017-R1 ABSEXCH-18556: New format for The Honourable Soc of Gray's Inn - E-banking Platform- C Hoare & Co
  THoareTransCodeExportObject = class(TExportObject)
    function WriteRec(const EventData: TAbsEnterpriseSystem;
                             Mode: word): Boolean; override;
  end;

implementation

uses
  SysUtils;

function THoarePayExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                         Mode : word) : Boolean;
const
  S_OUTSTRING_FORMAT = '"%s","%s","%s","%d","%s"';
var
  OutRec  : THoarePayRec;
  OutString : string;
  Target : TAbsCustomer;
begin
  Result := True;
  if Mode = wrPayLine then {don't want the contra}
  begin
    FillChar(OutRec, SizeOf(OutRec), #0);
    GetEventData(EventData);
    with EventData, OutRec do
    begin
      if IsReceipt then
        Target := Customer
      else
        Target := Supplier;
      DestSort := Target.acBankSort;
      DestAcc  := Target.acBankAcc;
      DestName := TrimRight(Bacs_Safe(Target.acCompany));
      if not IsBlank(Bacs_Safe(Target.acBankRef)) then
        Ref := TrimRight(Bacs_Safe(Target.acBankRef))
      else
        Ref := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);
      Amount := Pennies(Transaction.thTotalInvoiced);
      TotalPenceWritten := TotalPenceWritten + Amount;
      inc(TransactionsWritten);

      OutString := Format(S_OUTSTRING_FORMAT, [DestSort, DestName, DestAcc, Amount, Ref]);

      Result := WriteThisRec(OutString);
    end; {with eventdata, outrec}
  end; {if mode = wrpayline}
end;



{ THoareTransCodeExportObject }

function THoareTransCodeExportObject.WriteRec(const EventData: TAbsEnterpriseSystem;
                                                    Mode: word): Boolean;
const
  S_OUTSTRING_FORMAT = '"%s","%s","%s","%.2f","%s","%s"';
  SEGE_BACS_CODE = '99';
var
  lOutRec: THoarePayRec;
  lOutString: String;
  lTarget: TAbsCustomer;
  lTransAmount: Double;
begin
  Result := True;

  if Mode = wrPayLine then {don't want the contra}
  begin
    FillChar(lOutRec, SizeOf(lOutRec), #0);
    GetEventData(EventData);
    with EventData, lOutRec do
    begin
      if IsReceipt then
        lTarget := Customer
      else
        lTarget := Supplier;

      DestSort := lTarget.acBankSort;
      DestAcc  := lTarget.acBankAcc;
      DestName := TrimRight(Bacs_Safe(lTarget.acCompany));
      if not IsBlank(Bacs_Safe(lTarget.acBankRef)) then
        Ref := TrimRight(Bacs_Safe(lTarget.acBankRef))
      else
        Ref := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);

      Amount := Pennies(Transaction.thCurrSettled);
      lTransAmount :=ABS(Amount / 100);
      TotalPenceWritten := TotalPenceWritten + Amount;
      inc(TransactionsWritten);

      lOutString := Format(S_OUTSTRING_FORMAT, [DestSort, DestName, DestAcc, lTransAmount, Ref, SEGE_BACS_CODE]);

      Result := WriteThisRec(lOutString);
    end; {with eventdata, outrec}
  end;
end;

end.
