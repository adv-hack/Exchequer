unit yorkobj;

interface

uses
  CoopObj, CustAbsU, ExpObj;

type

  TYorkBankExportObject = Class(TCoopExportObject)
    function WriteRec(const EventData : TAbsEnterpriseSystem;
                       Mode : word) : Boolean; override;
  end;

implementation

uses
  SysUtils;

function TYorkBankExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                         Mode : word) : Boolean;
var
  OutRec  : TCoopRec;
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

      AcType := '0';
      if IsReceipt then
        TransCode := DirectDebitCode(Target.acDirDebMode)
      else {Payment}
        TransCode := '99';

      OutString := DQuotedStr(Bacs_Safe(DestName)) + ',' +
                   DQuotedStr(Bacs_Safe(Ref)) + ',' +
                   DQuotedStr(DestSort) + ',' +
                   DQuotedStr(DestAcc) + ',' +
                   DQuotedStr(Pounds(Amount)) + ',' +
                   DQuotedStr(AcType) + ',' +
                   DQuotedStr(TransCode);


      Result := WriteThisRec(OutString);
    end; {with eventdata, outrec}
  end; {if mode = wrpayline}
end;

end.
