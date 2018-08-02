unit RBSBULKO;

interface
{$H-}
uses
  ExpObj, CustAbsU;

type

  TRBSBulkExportObject = Class(TExportObject)
  private
    fListName : string;
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
  SysUtils, ListName, Controls;

function TRBSBulkExportObject.CreateOutFile(const AFileName : string;
                       const EventData :
                       TAbsEnterpriseSystem) : integer;
var
  s : string;
begin
  with TfrmListName.Create(nil) do
  Try
    ActiveControl := edtName;
    ShowModal;
    if ModalResult = mrOK then
    begin
      fListName := edtName.Text;
      Result := 0;
    end
    else
      Result := -1;
  Finally
    Free;
  End;
  if Result = 0 then
  begin
    Result := inherited CreateOutFile(AFileName, EventData);
    //write header
    s := '1' + LJVar(UpperCase(ExtractFileName(AFileName)), 12) + FormatDateTime('yyyymmdd', Date) + FormatDateTime('hhnnss', Now);
    s := s + StringOfChar(' ', 97);
    WriteThisRec(s);
  end;
end;

function TRBSBulkExportObject.CloseOutFile : integer;
var
  s : string;
begin
  //write trailer
  s := '9' +
  ZerosAtFront(TransactionsWritten, 5) +
  ZerosAtFront(TotalPenceWritten, 15);

  s := s + StringOfChar(' ', 103);
  WriteThisRec(s);
  Result := inherited CloseOutfile;
end;

function TRBSBulkExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
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

      s := '3' +
        UserBankAcc +
        UserBankSort +
        LJVar(fListName, 35) +
        ZerosAtFront(Target.acBankAcc, 9) +
        Target.acBankSort +
        LJVar(Bacs_Safe(Target.acCompany), 18);

        if not IsBlank(Bacs_Safe(Target.acBankRef)) then
           TempStr := Target.acBankRef
        else
           TempStr := '';

        s := s + LJVar(Bacs_Safe(TempStr), 18);

        s := s + ZerosAtFront(Pence, 15) +
                 FormatDateTime('yyyymmdd', Date);

        //Payer Reference. For some versions of rbs software this field overwrites
        //Payee reference
(*        if not IsBlank(Bacs_Safe(Supplier.acBankRef)) then
           TempStr := Supplier.acBankRef
        else
           TempStr := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);

        s := s + LJVar(Bacs_Safe(TempStr), 18);

        s := s + 'Nx' + StringOfChar(' ', 69) + 'N'; *)
    end;

    TotalPenceWritten := TotalPenceWritten + Pence;
    inc(TransactionsWritten);

    Result := WriteThisRec(s);
  end
  else
    Result := True;
end;


function TRBSBulkExportObject.ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
  Result := inherited ValidateRec(EventData);
end;


end.
