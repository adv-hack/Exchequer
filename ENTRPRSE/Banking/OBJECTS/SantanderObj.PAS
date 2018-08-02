unit SantanderObj;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  ExpObj, CustAbsU;

type

  TSantanderCsvExportObject = Class(TExportObject)
  private
     function WriteHeader(const EventData : TAbsEnterpriseSystem) : Boolean;
     function WriteTrailer : Boolean;
     function GetFileNo : string;
  public
     function WriteRec(const EventData : TAbsEnterpriseSystem;
                       Mode : word) : Boolean; override;
     function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
     function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean; override;
     function CreateOutFile(const AFileName : string;
                              const EventData :
                              TAbsEnterpriseSystem) : integer;  overload; override;
  end;

implementation

uses
  SysUtils, StrUtils, DateUtils, IniFiles, FileUtil;

const
  S_INI_FILE = 'Santander.ini';


function TSantanderCsvExportObject.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
begin
  GetEventData(EventData);
  Result := inherited CreateOutFile(AFilename, EventData);

  if Result = 0 then
    WriteHeader(EventData);
end;

function TSantanderCsvExportObject.GetFileNo: string;
var
  FNo : Integer;
begin
  Try
    with TIniFile.Create(GetEnterpriseDirectory + S_INI_FILE) do
    Try
      FNo := ReadInteger('SETTINGS', 'FileNo', 1);
      Result := ZerosAtFront(FNo, 4);
      inc(FNo);
      if FNo > 9999 then
        FNo := 1;
      WriteInteger('SETTINGS', 'FileNo', FNo);
    Finally
      Free;
    End;
  Except
    Result := '0001';
  End;
end;

function TSantanderCsvExportObject.ValidateRec(
  const EventData: TAbsEnterpriseSystem): Boolean;
begin
  Result := inherited ValidateRec(EventData);

  if Result then
  begin
    if TransactionsWritten > 9999 then
    begin
      Result := False;
      failed := flTooManyRecs;
      LogIt('The Santander format does not allow more than 9999 payments in one file.');
    end;
  end;
end;

function TSantanderCsvExportObject.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  TempStr : Shortstring;
begin
  Result := True;
  with EventData.Setup do
  begin
    //Santander Bank account number must be 7, 8, or 9 Chars in length
    TempStr := UserBankAcc;
    if not (Length(TempStr) in [7..9]) or not AllDigits(TempStr) then
    begin
      Result := False;
      failed := flBank;
    end;
    TempStr := FormatSortCode(UserBankSort);
    if (Length(TempStr) <> DefaultSortLength) or not AllDigits(TempStr) then
    begin
      Result := False;
      failed := flBank;
    end;
  end; {with EventData.Setup}
  if Result then
    LogIt('Validate system - successful');

end;

function TSantanderCsvExportObject.WriteHeader(const EventData : TAbsEnterpriseSystem): Boolean;
var
  s : string;
begin
  s := Format('PAYMENT,HEADER,%s,Payment Run %d,%s', [FormatDateTime('ddmmyyyy', Date),
                                          ProcControl.PayRun,
                                          GetFileNo]);
  Result := WriteThisRec(s);
end;

function TSantanderCsvExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                         Mode : word) : Boolean;
var
  OutString : string;
  Target : TAbsCustomer;

  DestSort : string;
  DestAcc  : string;
  DestName : string;
  Ref      : string;
  Amount   : Int64;
begin
  Result := True;
  if Mode = wrPayLine then {don't want the contra}
  begin
    GetEventData(EventData);
    with EventData do
    begin
      Target := Supplier;

      DestSort := Target.acBankSort;
      DestAcc  := Target.acBankAcc;
      DestName := LeftStr(TrimRight(Bacs_Safe(Target.acCompany)),35);   //HV 11/01/2016, JIRA-15332, Santander Bacs format pulls out greater than the allow 35 characters for the Beneficiary Name
      if not IsBlank(Bacs_Safe(Target.acBankRef)) then
        Ref := LeftStr(TrimRight(Bacs_Safe(Target.acBankRef)),18)   //HV 11/01/2016, JIRA-15331, Santander Bacs format pulls out greater than the allow 18 characters for the payment ref
      else
        Ref := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);
      Amount := Pennies(Transaction.thTotalInvoiced);
      TotalPenceWritten := TotalPenceWritten + Amount;
      inc(TransactionsWritten);

      //PR: 09/05/2014 ABSEXCH-15024 Format changed - we now need field 3 to concatenate user sort code and account
      OutString := 'PAYMENT,MULTIBACS,' +
                   UserBankSort + UserBankAcc + ',' +
                   DestName + ',' +
                   DestSort + ',' +
                   DestAcc + ',' +
                   Pounds(Amount) + ',' +
                   DDMMYYYY(ProcControl.PDate) + ',' +
                   Ref;

      Result := WriteThisRec(OutString);
    end; {with eventdata, outrec}
  end {if mode = wrpayline}
  else
    Result := WriteTrailer;
end;



function TSantanderCsvExportObject.WriteTrailer : Boolean;
var
  s : string;
begin
  s := Format('PAYMENT,TRAILER,%s,%d', [ZerosAtFront(TotalPenceWritten, 15),
                                         TransactionsWritten]);

  Result := WriteThisRec(s);
end;

end.
