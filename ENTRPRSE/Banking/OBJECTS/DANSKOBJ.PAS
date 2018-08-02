unit DanskObj;

interface

uses
  ExpObj, CustAbsU;

const
  NotInUse = '"","","",';

type
  TDanskeBankRec = Record
    Entry       : String[4];
    FromAc      : String[14];
    ToAc        : String[10];
    Amount      : longint;
    TransDate   : String[8];
    Currency    : string[3];
    PayType     : String[1];
    InfoType    : String[1];
    ToSort      : string[6];
    Advice      : string[1];
    Name        : string[18];
    OurRef      : string[20];
    TheirRef    : string[18];
  end;

  TDanskeExportObject = Class(TExportObject)
  private
    function TranslateDate(const d : String) : string;
    function DecimalComma(const s : string) : string;
  public
     function WriteRec(const EventData : TAbsEnterpriseSystem;
                       Mode : word) : Boolean; override;
  end;

implementation

uses
  SysUtils, StrUtils;

function TDanskeExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                         Mode : word) : Boolean;
var
  OutRec  : TDanskeBankRec;
  OutString : AnsiString;
  Target : TAbsCustomer;
  function DoDate(const s : string) : string;
  begin
    Result := Copy(s, 7, 2) + Copy(s, 5, 2) + Copy(s, 1, 4);
  end;
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
      Entry := 'CMUI';
      ToSort := Target.acBankSort;
      ToAc  := Target.acBankAcc;
      Name := TrimRight(Bacs_Safe(Target.acCompany));
      if not IsBlank(Bacs_Safe(Target.acBankRef)) then
        OurRef := TrimRight(Bacs_Safe(Target.acBankRef))
      else
        OurRef := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);
      TheirRef := OurRef;

      //PR: 14/10/2013 ABSEXCH-14414 Change to use ProcControl amount as TotalInvoiced is in base.
      Amount := Pennies(ProcControl.Amount);

      FromAc := UserBankSort + UserBankAcc;
      TransDate := TranslateDate(ProcControl.PDate);

      if (Ord(ProcControl.PayCurr[1]) = 128) then
        Currency := 'EUR'
      else
      if (Ord(ProcControl.PayCurr[1]) = 163) then
        Currency := 'GBP'
      else
        Currency := ProcControl.PayCurr;

      PayType := 'B';
      InfoType := 'M';
      Advice := 'N';
      TotalPenceWritten := TotalPenceWritten + Amount;
      inc(TransactionsWritten);

      OutString := DQuotedStr(Entry) + ',' + DQuotedStr(FromAc) + ',' +
                   DQuotedStr(ToAc) + ',' + DQuotedStr(DecimalComma(Pounds(Amount))) +
                   ',' + DQuotedStr(DoDate(ProcControl.PDate)) +  ',' + DQuotedStr(Currency) + ',' +
                   DQuotedStr(PayType) + ',' + DQuotedStr(InfoType) + ',' +
                   DQuotedStr(ToSort) + ',' + NotInUse + NotInUse + DQuotedStr(Name) + ',' +
                   NotInUse + DQuotedStr(OurRef) + ',' + '"",' +
                   DQuotedStr(TheirRef);

      Result := WriteThisRec(OutString);
    end; {with eventdata, outrec}
  end; {if mode = wrpayline}
end;

function TDanskeExportObject.TranslateDate(const d : String) : string;
begin
  Result := Copy(d, 7, 2) + Copy(d, 5, 2) + Copy(d, 1, 4);
end;

function TDanskeExportObject.DecimalComma(const s: string): string;
begin
  Result := AnsiReplaceStr(s, '.', ',');
end;

end.
