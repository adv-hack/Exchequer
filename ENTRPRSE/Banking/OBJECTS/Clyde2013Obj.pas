unit Clyde2013Obj;
//PR: 12/03/2013 ABSEXGENERIC-803 New EFT format for Clydesdale bank.
interface

uses
  ExpObj, CustAbsU, MultiObj;

const
  MAX_RECS_PER_FILE = 249;

type
  //Record to encapsulate one line of the file.
  TClyde2013Rec = Record
    FromSort : string[6];
    FromAc   : string[8];
    DestName : string[35];
    Ref      : string[18];
    DestSort : string[6];
    DestAcc  : string[8];
    Amount   : longint;
  end;

  //Export object
  TClyde2013ExportObject = Class(TMultiFileExportObject)
  private
    FRecords : Array[1..MAX_RECS_PER_FILE] of TClyde2013Rec;
  protected
    function WriteData(const EventData : TAbsEnterpriseSystem) : Boolean; override;
  public
    function WriteRec(const EventData : TAbsEnterpriseSystem;
                       Mode : word) : Boolean; override;
    constructor Create;
  end;


implementation

uses
  SysUtils;

{ TClyde2013ExportObject }

constructor TClyde2013ExportObject.Create;
begin
  inherited Create;
  RecsPerFile := MAX_RECS_PER_FILE;
  FMaxFiles := MaxInt; // No limit on number of files
  Ext := '.txt';       // File extension
  FDigitCount := 5;    // Filenames will be Pay00001.txt, Pay00002.txt, etc.
end;

function TClyde2013ExportObject.WriteData(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  i : integer;
  OutString : String;
begin
  Result := True;

  //Write payment records to file
  for i := 1 to PayCount do
  begin
    with FRecords[i] do
    begin
      OutString := FromSort + ',' +
                   FromAc   + ',' +
                   DestName + ',' +
                   Ref      + ',' +
                   DestSort + ',' +
                   DestAcc  + ',' +
                   Pounds(Amount);

      Result := Result and WriteThisRec(OutString);

    end;
  end;

  //clear payment array and reset counter
  FillChar(FRecords, SizeOf(FRecords), 0);
  PayCount := 0;
end;

function TClyde2013ExportObject.WriteRec(const EventData: TAbsEnterpriseSystem;
  Mode: word): Boolean;
begin
  Result := True;

  if Mode = wrPayline {don't output a contra line}then
  begin
    Inc(PayCount);

    GetEventData(EventData);
    with EventData do
    begin
      with FRecords[PayCount] do
      begin
        FromSort := UserBankSort;
        FromAc   := UserBankAcc;

        DestName := Trim(Bacs_Safe(Supplier.acCompany));

        if not IsBlank(Bacs_Safe(Supplier.acBankRef)) then
          Ref := TrimRight(Bacs_Safe(Supplier.acBankRef))
        else
          Ref := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);

        DestSort := Supplier.acBankSort;
        DestAcc  := Supplier.acBankAcc;

        Amount := Pennies(Transaction.thTotalInvoiced);

        TotalPenceWritten := TotalPenceWritten + Amount;
        inc(TransactionsWritten);

      end;
    end;
  end;

  //Reached limit for this file or contra received so no more payments. Write data to file.
  if (PayCount = RecsPerFile) or (Mode = wrContra) then
    Result := WriteBatch(EventData);
end;

end.
