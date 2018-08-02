unit UnityOBJ;

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
    TransCode : string[2];
  end;

  TUnityExportObject = Class(TExportObject)
     function WriteRec(const EventData : TAbsEnterpriseSystem;
                       Mode : word) : Boolean; override;
  end;

implementation

uses
  SysUtils;

function TUnityExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
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
      if IsReceipt then
        Ref := 'RC27694'
      else
      begin
        if not IsBlank(Bacs_Safe(Target.acBankRef)) then
          Ref := TrimRight(Bacs_Safe(Target.acBankRef))
        else
          Ref := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);
      end;
      if IsReceipt then
        TransCode := DirectDebitCode(Target.acDirDebMode)
      else {Payment}
        TransCode := '99';

      Amount := Pennies(ProcControl.Amount);
      TotalPenceWritten := TotalPenceWritten + Amount;
      inc(TransactionsWritten);

      OutString := DQuotedStr(DestName) + ',' +
                   DQuotedStr(DestSort) + ',' +
                   DQuotedStr(DestAcc) + ',' +
                   DQuotedStr(TransCode) + ',' +
                   DQuotedStr(ZerosAtFront(Amount,11)) + ',' +
                   DQuotedStr(Bacs_Safe(Ref));

      Result := WriteThisRec(OutString);
    end; {with eventdata, outrec}
  end; {if mode = wrpayline}
end;



end.
