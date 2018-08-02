unit LLoydsColObj;

interface

uses
  ExpObj, CustAbsU, SysUtils;

type
  TLloydsCOLExportObject = Class(TExportObject)
  protected
    function WriteHeader(const EventData: TAbsEnterpriseSystem) : Integer;
    function WriteTrailer : Integer;
  public
    function WriteRec(const EventData : TAbsEnterpriseSystem;
                      Mode : word) : Boolean; override;
    function CreateOutFile(const AFileName : string;
                              const EventData :
                              TAbsEnterpriseSystem) : integer; override;
    function CreateOutFileOnly(const AFileName : string;
                                  const EventData : TAbsEnterpriseSystem) : integer;
    function CloseOutFile : integer; override;
  end;


implementation

{ TLloydsCOLExportObject }

function TLloydsCOLExportObject.CloseOutFile: integer;
begin
  Result := WriteTrailer;

  if Result = 0 then
    Result := inherited CloseOutFile;
end;

function TLloydsCOLExportObject.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
begin
  Result := inherited CreateOutFile(AFileName, EventData);

  if Result = 0 then
    Result := WriteHeader(EventData);
end;

function TLloydsCOLExportObject.CreateOutFileOnly(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
begin

end;

function TLloydsCOLExportObject.WriteHeader(
  const EventData: TAbsEnterpriseSystem): Integer;
begin
  Result := -1;

  GetEventData(EventData);

  if WriteThisRec('UHL11' + JulianDateStr(ProcControl.PDate)) then
    Result := 0;
end;

function TLloydsCOLExportObject.WriteRec(
  const EventData: TAbsEnterpriseSystem; Mode: word): Boolean;
var
  OutStr : AnsiString;
  Target : TAbsCustomer;
  Pence : longint;
  RefStr : string;
begin
  GetEventData(EventData);

  Target := EventData.Supplier;

  with EventData do
  begin


    case Mode of
      wrPayLine : begin

                    Pence := Pennies(ProcControl.Amount);
                    TotalPenceWritten := TotalPenceWritten + Pence;
                    inc(TransactionsWritten);

                    if not IsBlank(Bacs_Safe(Target.acBankRef)) then
                      RefStr := Bacs_Safe(Target.acBankRef)
                    else
                      RefStr := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);

                    OutStr := Target.acBankSort + Target.acBankAcc + '000' +
                              UserBankSort + UserBankAcc + '0000' + zerosAtFront(Pence, 11) +
                              LJVar(Bacs_Safe(Setup.ssUserName), 18) + LJVar(RefStr, 18) +
                              LJVar(Bacs_Safe(Target.acCompany), 18);
                  end; //wrPayline
      wrContra  : begin
                    OutStr := UserBankSort + UserBankAcc + '099' +
                              UserBankSort + UserBankAcc + '0000' +
                              ZerosAtFront(TotalPenceWritten, 11) +
                              LJVar(Bacs_Safe(Setup.ssUserName), 18) + LJVar('CONTRA', 18);


                  end;
    end; //Case
  end;

  Result := WriteThisRec(OutStr);
end;

function TLloydsCOLExportObject.WriteTrailer: Integer;
begin
  Result := -1;

  if WriteThisRec('UTL1' + ZerosAtFront(TotalPenceWritten, 13) + ZerosAtFront(TotalPenceWritten, 13) +
                  ZerosAtFront(1, 7) + ZerosAtFront(TransactionsWritten, 7)) then
    Result := 0;
end;

end.
