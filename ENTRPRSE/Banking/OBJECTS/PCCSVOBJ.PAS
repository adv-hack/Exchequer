unit PcCsvObj;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  ExpObj, CustAbsU;

type
  TPcPayCsvRec = Record
    DestSort : string[6];
    DestAcc  : string[8];
    DestName : string[18];
    Ref      : string[18];
    Amount   : longint;
  end;

  TPcPayCsvExportObject = Class(TExportObject)
     function WriteRec(const EventData : TAbsEnterpriseSystem;
                       Mode : word) : Boolean; override;
  end;

implementation

uses
  SysUtils;

function TPcPayCsvExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                         Mode : word) : Boolean;
var
  OutRec  : TPcPayCsvRec;
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

      OutString := DestSort + ',' +
                   DestAcc + ',' +
                   DestName + ',' +
                   Ref + ',' +
                   Pounds(Amount);

      Result := WriteThisRec(OutString);
    end; {with eventdata, outrec}
  end; {if mode = wrpayline}
end;



end.
