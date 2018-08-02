unit SogeObj;

interface

uses
  ExpObj, CustAbsU;

type

  TSogeExportObject = Class(TExportObject)
  protected
     FCountryCode : string[2]; //ISO Country code
     FCompanyAC : string;
     function WriteBeneficiary(const EventData: TAbsEnterpriseSystem) : Boolean;
     function WriteOrderingCustomer(const EventData: TAbsEnterpriseSystem) : Boolean;
     function WriteReporting : Boolean;
     function Amount : string;
     function SendersRef : string;
     function CustRef : string;
     function AccountWith(const EventData : TAbsEnterpriseSystem) : string;
     function ExecutionDate : string;
     function FormatCurrCode(const s : string) : string;
     function ReadIniFile : Boolean;
  public
     function CreateOutFile(const AFileName : string;
                            const EventData :
                            TAbsEnterpriseSystem) : integer; override;
     function CloseOutFile : integer; override;
     function WriteRec(const EventData : TAbsEnterpriseSystem;
                       Mode : word) : Boolean; override;
     function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
  end;


implementation

uses
  SysUtils, EtDateU, IniFiles;

const
  sgIniFileName = 'SogeCash.ini';

{ TSogeExportObject }

function TSogeExportObject.AccountWith(const EventData : TAbsEnterpriseSystem) : string;
begin
  Result := ':57C://' + {FCountryCode}'SC'  + EventData.Supplier.acBankSort;
end;

function TSogeExportObject.Amount: string;
begin
  Result := ':32B:' + FormatCurrCode(ProcControl.PayCurr) + EuroFormat(Format('%.2f', [ProcControl.Amount]));
end;

function TSogeExportObject.CloseOutFile: integer;
var
  bRes : Boolean;
begin
  bRes := WriteThisRec('-');

  Result :=  inherited CloseOutFile;
end;

function TSogeExportObject.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
var
  Days : Integer;
begin
  GetEventData(EventData);

  Days := NoDays(EtDateU.Today, ProcControl.PDate);
  if (Days < -2) or (Days > 30) then
  begin
    Failed := flDate;
    Result := -1;
    LogIt('Invalid Execution Date ' + POutDate(ProcControl.PDate) +
          '. Must be >= Today - 2 and <= Today + 30');
    ErrorReport(EventData, 0);
  end
  else
  begin
    //Take country code from first two chars of VAt Registration No
    FCountryCode := Copy(EventData.Setup.ssUserVATReg, 1, 2);

    Result := inherited CreateOutFile(AFileName, EventData);

    //Header
    if (Result = 0) and
       WriteThisRec('SOGEXXXXCMI') and
       WriteThisRec(UserBankRef) and
       WriteThisRec('101') and
       //Sequence A - common
       WriteThisRec(SendersRef) and
       WriteThisRec(CustRef) and
       WriteOrderingCustomer(EventData) and
       WriteThisRec(':52A:' + UserBankRef) and
       WriteThisRec(ExecutionDate) then
         Result := 0
    else
      Result := -1;
  end;
end;

function TSogeExportObject.CustRef: string;
begin
  Result := ':21R:' + IntToStr(ProcControl.PayRun);
end;

function TSogeExportObject.ExecutionDate: string;
begin
  Result := ':30:' + Copy(ProcControl.PDate, 3, 6);
end;

function TSogeExportObject.FormatCurrCode(const s: string): string;
begin
  if Length(s) > 1 then
    Result := s
  else
  begin
    if s[1] in ['£', #156, #163] then
      Result := 'GBP'
    else
    if s[1] in ['€', #128] then
      Result := 'EUR'
    else
      raise Exception.Create('Unknown Currency: ' + s);
  end;
end;

function TSogeExportObject.ReadIniFile: Boolean;
var
  TheIni : TIniFile;
begin
  Result := False;
  TheIni := TIniFile.Create(DataPath + sgIniFileName);
  Try
    FCompanyAc := TheIni.ReadString('Settings', 'IBAN', '');
    Result := Trim(FCompanyAc) <> '';
    if not Result then
      Failed := flBank;
  Finally
    TheIni.Free;
  End;
end;

function TSogeExportObject.SendersRef: string;
begin
  Result := ':20:' + Copy(IntToStr(ProcControl.PayRun) + FormatDateTime('yymmddhhnn', Now), 1, 16);
end;

function TSogeExportObject.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  TempStr : string;
begin
  Result := True;
  with EventData.Setup do
  begin
    Result := ReadIniFile;
    if not Result then
    begin
      failed := flBank;
      Exit;
    end;
    TempStr := UserBankRef;
    if not (Length(TempStr) in [8, 11]) then
    begin
      Result := False;
      failed := flBank;
    end;
  end; {with EventData.Setup}
  if Result then
    LogIt('Validate system - successful');
end;

function TSogeExportObject.WriteBeneficiary(const EventData: TAbsEnterpriseSystem): Boolean;
var
  i : integer;
begin
  Result := WriteThisRec(':59:/' + EventData.Supplier.acBankAcc) and WriteThisRec(Bacs_Safe(Copy(EventData.Supplier.acCompany, 1, 35)));
  if Result then
  begin
    i := 1;
    while Result and (i <= 3) and (Trim(EventData.Supplier.acAddress[i]) <> '') do
    begin
      Result := WriteThisRec(Bacs_Safe(Copy(EventData.Supplier.acAddress[i], 1, 35)));

      inc(i);
    end;
  end;
end;

function TSogeExportObject.WriteOrderingCustomer(const EventData: TAbsEnterpriseSystem): Boolean;
var
  i : integer;
begin
  Result := WriteThisRec(':50H:/' + FCompanyAC) and WriteThisRec(Bacs_Safe(Copy(EventData.Setup.ssUserName, 1, 35)));
  if Result then
  begin
    i := 1;
    while Result and (i <= 3) and (Trim(EventData.Setup.ssDetailAddr[i]) <> '') do
    begin
      Result := WriteThisRec(Bacs_Safe(Copy(EventData.Setup.ssDetailAddr[i], 1, 35)));

      inc(i);
    end;
  end;
end;

function TSogeExportObject.WriteRec(const EventData: TAbsEnterpriseSystem;
  Mode: word): Boolean;
begin
  GetEventData(EventData);

  if Mode = wrContra then
    Result := True
  else  //Sequence B
  begin
    Result := WriteThisRec(':21:' + EventData.Transaction.thOurRef) and
              WriteThisRec(Amount) and
              WriteThisRec(AccountWith(EventData)) and
              WriteBeneficiary(EventData) and
              WriteReporting and
              WriteThisRec(':71A:SHA'); //Charges


    TotalPenceWritten := TotalPenceWritten + Pennies(ProcControl.Amount);
    inc(TransactionsWritten);
  end;
end;

function TSogeExportObject.WriteReporting: Boolean;
begin
  Result := WriteThisRec(':77B:/ORDERRES/' + FCountryCode + '//GDS') and
            WriteThisRec('/BENEFRES/' + FCountryCode);
end;

end.
