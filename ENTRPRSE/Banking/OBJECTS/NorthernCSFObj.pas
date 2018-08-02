unit NorthernCSFObj;

interface

uses
  ExpObj, CustAbsU;

type
  TNBCsfRec = Record
    DestName : string[18];
    Ref      : string[18];
    DestSort : string[6];
    DestAcc  : string[8];
    Amount   : string[11];
    AmountCode
             : String[1];
    TransCode: String[2];
  end;

  TNorthernCSFExportObject = Class(TExportObject)
     function WriteRec(const EventData : TAbsEnterpriseSystem;
                       Mode : word) : Boolean; override;
  end;


implementation

{ TNorthernCSFExportObject }
uses
  SysUtils;

function TNorthernCSFExportObject.WriteRec(
  const EventData: TAbsEnterpriseSystem; Mode: word): Boolean;
const
  S_OUTSTRING_FORMAT = '"%s","%s","%s","%s","%s","%s","%s"';
var
  OutRec  : TNBCsfRec;
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
      Target := Supplier;
      AmountCode := '0';
      TransCode := '99';
      DestSort := Target.acBankSort;
      DestAcc  := Target.acBankAcc;
      DestName := TrimRight(Bacs_Safe(Target.acCompany));
      if not IsBlank(Bacs_Safe(Target.acBankRef)) then
        Ref := TrimRight(Bacs_Safe(Target.acBankRef))
      else
        Ref := TrimRight(Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun));
      Amount := Format('%8.2f', [Transaction.thTotalInvoiced]);
      TotalPenceWritten := TotalPenceWritten + Pennies(Transaction.thTotalInvoiced);
      inc(TransactionsWritten);

      OutString := Format(S_OUTSTRING_FORMAT, [DestName, Ref, DestSort, DestAcc, Trim(Amount), AmountCode, TransCode]);
      Result := WriteThisRec(OutString);

    end; {with eventdata, outrec}
  end; {if mode = wrpayline}
end;

end.
