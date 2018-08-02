unit CommerzBankObj;

interface

uses
  ExpObj, CustAbsU;


type

  TCommerzBankObject = Class(TExportObject)
  public
    function WriteRec(const EventData : TAbsEnterpriseSystem;
                      Mode : word) : Boolean; override;
  end;


implementation

uses
  SysUtils;

{ TCommerzBankObject }

function TCommerzBankObject.WriteRec(const EventData: TAbsEnterpriseSystem;
  Mode: word): Boolean;
var
  OutS : String;
  TempStr : String;
  Pence : longint;
  Target : TAbsCustomer4;
begin
  GetEventData(EventData);

  if Mode = wrPayLine then
  with EventData do
  begin
    if IsReceipt then
      Target := TAbsCustomer4(Customer)
    else
      Target := TAbsCustomer4(Supplier);

    if not IsBlank(Bacs_Safe(Target.acBankRef)) then
       TempStr := Bacs_Safe(Target.acBankRef)
    else
       TempStr := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);


    Pence := Pennies(ProcControl.Amount);
    TotalPenceWritten := TotalPenceWritten + Pence;
    Inc(TransactionsWritten);

    OutS := Target.acBankSortCode +
            Target.acBankAccountCode +
            '099406201' +
            UserBankAcc +
            '    ' +
            ZerosAtFront(Pence, 11) +
            Bacs_Safe(LJVar(Setup.ssUserName, 18)) +
            LJVar(TempStr, 18) +
            Bacs_Safe(LJVar(Target.acCompany, 18));

    Result := WriteThisRec(OutS);

  end
  else
    Result := True;
end;

end.
