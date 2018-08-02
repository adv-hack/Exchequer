unit ClydOBJ;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  ExpObj, CustAbsU;

type
  TClydRec = Record
    DestName : string[18];
    Ref      : string[18];
    DestSort : string[6];
    DestAcc  : string[8];
    Amount   : longint;
    AcType   : Char;
    TransCode: string[2];
  end;

  TClydExportObject = Class(TExportObject)
  protected
     function FormatField(const s : string) : string; virtual;
  public
     function WriteRec(const EventData : TAbsEnterpriseSystem;
                       Mode : word) : Boolean; override;
  end;

implementation

uses
  SysUtils;

function TClydExportObject.FormatField(const s: string): string;
begin
  Result := '"' + s + '"';
end;

function TClydExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                         Mode : word) : Boolean;

var
  OutRec  : TClydRec;
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

      OutString := FormatField(Bacs_Safe(DestName)) + ',' +
                   FormatField(Bacs_Safe(Ref)) + ',' +
                   FormatField(DestSort) + ',' +
                   FormatField(DestAcc) + ',' +
                   FormatField(Pounds(Amount)) + ',' +
                   FormatField(AcType) + ',' +
                   FormatField(TransCode);


      Result := WriteThisRec(OutString);
    end; {with eventdata, outrec}
  end; {if mode = wrpayline}
end;



end.
