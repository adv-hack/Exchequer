unit DanskeUKObj;

interface

uses
  ExpObj, CustAbsU;

const
  S_MESSAGE = '"","","","",';

type
  TDanskeUKBankRec = Record
    Command     : String[8];
    Version     : String[3];
    FromAc      : String[14];
    BACSID      : string[6];
    ToAc        : String[14];
    Amount      : longint;
    TransDate   : String[8];
    Currency    : string[3];
    PayType     : String[1];
    PayeeName   : string[18];
    OurRef      : string[20];
    TheirRef    : string[18];
    PayerName   : string[18];
  end;

  TDanskeUKExportObject = Class(TExportObject)
  private
    FBacsID : string;
    function GetBacsID(const EventData : TAbsEnterpriseSystem) : string;
  protected
    function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
  public
     function WriteRec(const EventData : TAbsEnterpriseSystem;
                       Mode : word) : Boolean; override;
  end;

implementation

uses
  SysUtils, StrUtils, MultIni, IniFiles;

const
  S_INI_FILENAME = 'DanskeUK.ini';

function TDanskeUKExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                         Mode : word) : Boolean;
var
  OutRec  : TDanskeUKBankRec;
  OutString : AnsiString;
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

      Command := 'CMGB';
      Version := '1.0';
      FromAc := UserBankSort + UserBankAcc;
      BacsID := FBacsID;
      ToAc  := Target.acBankSort + Target.acBankAcc;
      PayeeName := TrimRight(Bacs_Safe(Target.acCompany));

      //PR: 12/11/2013 ABSEXCH-14414 Change to get amount in currency rather than base.
      Amount := Pennies(ProcControl.Amount);

      TransDate := DDMMYYYY(ProcControl.PDate);

      if (Ord(ProcControl.PayCurr[1]) = 128) then
        Currency := 'EUR'
      else
      if (Ord(ProcControl.PayCurr[1]) = 163) then
        Currency := 'GBP'
      else
        Currency := ProcControl.PayCurr;

      PayType := 'B';

      OurRef := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);

      if not IsBlank(Bacs_Safe(Target.acBankRef)) then
        TheirRef := TrimRight(Bacs_Safe(Target.acBankRef))
      else
        TheirRef := OurRef;

      PayerName := EventData.Setup.ssUserName;

      TotalPenceWritten := TotalPenceWritten + Amount;
      inc(TransactionsWritten);

      OutString := DQuotedStrEx(Command) +
                   DQuotedStrEx(Version) +
                   DQuotedStrEx(FromAc) +
                   DQuotedStrEx(BACSID) +
                   DQuotedStrEx(ToAc) +
                   DQuotedStrEx(Pounds(Amount)) +
                   DQuotedStrEx(TransDate) +
                   DQuotedStrEx(Currency) +
                   DQuotedStrEx(PayType) +
                   DQuotedStrEx(PayeeName) +
                   DQuotedStrEx(OurRef) +
                   DQuotedStrEx(TheirRef) +
                   S_MESSAGE +
                   DQuotedStrEx(PayerName, False);

      Result := WriteThisRec(OutString);
    end; {with eventdata, outrec}
  end; {if mode = wrpayline}
end;


function TDanskeUKExportObject.GetBacsID(
  const EventData: TAbsEnterpriseSystem): string;
begin
  Result := UserID;
  if Trim(Result) = '' then
  with TIniFile.Create(EventData.Setup.ssDataPath + S_INI_FILENAME) do
  Try
    Result := ReadString('Settings','BACSID', '');
  Finally
    Free;
  End;
end;

function TDanskeUKExportObject.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
begin
  Result := inherited ValidateSystem(EventData);

  if Result then
  begin
    FBacsId := GetBacsID(EventData);
    if FBacsID = '' then
    begin
      Result := False;
      Failed := flUserId;
    end;
  end;
end;

end.
