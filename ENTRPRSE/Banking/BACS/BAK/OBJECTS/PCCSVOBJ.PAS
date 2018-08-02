unit PcCsvObj;

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
begin
  Result := True;
  if Mode = wrPayLine then {don't want the contra}
  begin
    FillChar(OutRec, SizeOf(OutRec), #0);
    GetEventData(EventData);
    with EventData, OutRec do
    begin
      DestSort := Supplier.acBankSort;
      DestAcc  := Supplier.acBankAcc;
      DestName := TrimRight(Bacs_Safe(Supplier.acCompany));
      if not IsBlank(Bacs_Safe(Supplier.acBankRef)) then
        Ref := TrimRight(Bacs_Safe(Supplier.acBankRef))
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
