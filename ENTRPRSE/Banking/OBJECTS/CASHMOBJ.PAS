unit CashMObj;

interface
{$H-}
uses
  ExpObj, CustAbsU;

type

  TRoylineCashManObject = Class(TExportObject)
  public
    function CreateOutFile(const AFileName : string;
                           const EventData :
                           TAbsEnterpriseSystem) : integer; override;
    function CloseOutFile : integer; override;
    function WriteRec(const EventData : TAbsEnterpriseSystem;
                            Mode : word) : Boolean; override;
    function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean;
                                      override;
  end;



implementation

uses
  SysUtils;

function TRoylineCashManObject.CreateOutFile(const AFileName : string;
                       const EventData :
                       TAbsEnterpriseSystem) : integer;
var
  s : string;
begin
  Result := inherited CreateOutFile(AFileName, EventData);
  //write header
  s := '1' + UpperCase(ExtractFileName(AFileName)) + FormatDateTime('yyyymmdd', Date) + FormatDateTime('hhnnss', Now);
//  s := s + StringOfChar('x', 152);
  WriteThisRec(s);
end;

function TRoylineCashManObject.CloseOutFile : integer;
var
  s : string;
begin
  //write trailer
  s := '9' +
  ZerosAtFront(TransactionsWritten, 5) +
  ZerosAtFront(TotalPenceWritten, 15);

//  s := s + StringOfChar('x', 158);
  WriteThisRec(s);
  Result := inherited CloseOutfile;
end;

function TRoylineCashManObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                        Mode : word) : Boolean;
var
  s, TempStr : Ansistring;
  Pence : longint;
  Target : TAbsCustomer;
begin
  //set up s
  if Mode = wrPayline then
  begin
    GetEventData(EventData);
    Pence := Pennies(ProcControl.Amount);
    with EventData do
    begin
      if IsReceipt then
        Target := Customer
      else
        Target := Supplier;
      s := '2' +
        UserBankSort +
        UserBankAcc +
        Target.acBankSort +
        ZerosAtFront(Target.acBankAcc, 8) +
        s + ZerosAtFront(Pence, 15) +
                 ProcControl.PDate;

        s := s + LJVar(Bacs_Safe(Target.acCompany), 18);

{        if not IsBlank(Bacs_Safe(Target.acBankRef)) then
           TempStr := Target.acBankRef
        else
           TempStr := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);}



        //Payer Reference. For some versions of rbs software this field overwrites
        //Payee reference
        s := s + LJVar(Bacs_Safe(UserBankRef), 18);

        if not IsBlank(Bacs_Safe(Target.acBankRef)) then
           TempStr := Target.acBankRef
        else
           TempStr := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);

        s := s + LJVar(Bacs_Safe(TempStr), 18);


        s := s + 'Nx' + StringOfChar(' ', 69) + 'N';
    end;

    TotalPenceWritten := TotalPenceWritten + Pence;
    inc(TransactionsWritten);

    Result := WriteThisRec(s);
  end
  else
    Result := True;
end;


function TRoylineCashManObject.ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
  Result := inherited ValidateRec(EventData);
end;


end.
