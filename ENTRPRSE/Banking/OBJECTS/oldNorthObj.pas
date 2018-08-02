unit NorthObj;

interface

uses
  ExpObj, CustAbsU;

const
  NorthernIniFile = 'Northern.ini';

Type
  TNorthernObj = Class(TExportObject)
  private
    FSetup : TAbsSetup;
    FUserID : string;
    FIniFilename : string;
    function VolHeader : string;
    function FileHeader1 : string;
    function FileHeader2 : string;
    function UserHeader : string;
    function FileTrailer1 : string;
    function FileTrailer2 : string;
    function UserTrailer : string;
    function TransWritten : string;
    procedure ReadIniFile;
  public
    constructor Create(const EventData : TAbsEnterpriseSystem);
    destructor Destroy; override;
    function CreateOutFile(const AFileName : string;
                           const EventData :
                           TAbsEnterpriseSystem) : integer; override;
    function CloseOutFile : integer; override;
    function WriteRec(const EventData : TAbsEnterpriseSystem;
                       Mode : word) : Boolean; override;
  end;


implementation

{ TNorthernObj }
uses
  SysUtils, Math, IniFiles;

function TNorthernObj.CloseOutFile: integer;
begin
  WriteThisRec(FileTrailer1);
  WriteThisRec(FileTrailer2);
  WriteThisRec(UserTrailer);
  Result := inherited CloseOutFile;
end;

constructor TNorthernObj.Create(const EventData: TAbsEnterpriseSystem);
begin
  inherited Create;
  FIniFilename := CheckPath(EventData.Setup.ssDataPath) + NorthernIniFile;
  ReadIniFile;
  FSetup := EventData.Setup;
end;

function TNorthernObj.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
begin
  Result := inherited CreateOutFile(AFileName, EventData);
  if Result = 0 then
  begin
    GetEventData(EventData);
    WriteThisRec(VolHeader);
    WriteThisRec(FileHeader1);
    WriteThisRec(FileHeader2);
    WriteThisRec(UserHeader);
  end;
end;

destructor TNorthernObj.Destroy;
begin

  inherited;
end;

function TNorthernObj.FileHeader1: string;
begin
  Result := 'HDR1A992087Z   99208700000100010001       ' +
            JulianDateStr(FormatDateTime('yyyymmdd', Date)) +
            ' ' + JulianDateStr(ProcControl.PDate) +
            '0000000' +
            StringOfChar(' ', {13}20);

end;

function TNorthernObj.FileHeader2: string;
begin
  Result := 'HDR2F0106000106' + StringOfChar(' ', 35) +
            '00' +  StringOfChar(' ', 28);
end;

function TNorthernObj.FileTrailer1: string;
begin
  Result := 'EOF1A992087Z   99208700000100010001       ' +
            JulianDateStr(FormatDateTime('yyyymmdd', Date)) +
            ' ' + JulianDateStr(ProcControl.PDate) +
            '0' + TransWritten +
            StringOfChar(' ', 20);
end;

function TNorthernObj.FileTrailer2: string;
begin
  Result := 'EOF2F0106000106' + StringOfChar(' ', 35) +
            '00' +  StringOfChar(' ', 28);
end;

procedure TNorthernObj.ReadIniFile;
begin
  with TIniFile.Create(FIniFileName) do
  Try
    FUserID := LJVar(ReadString('EFT','UserID',''), 6);
  Finally
    Free;
  End;
end;

function TNorthernObj.TransWritten: string;
var
  dTransWritten : Double;
begin
  dTransWritten := TransactionsWritten;
  SetRoundMode(rmUp);
  Result := ZerosAtFront(Round(dTransWritten / 10), 6);
end;

function TNorthernObj.UserHeader: string;
begin
  Result := 'UHL1 ' + JulianDateStr(ProcControl.PDate) +
            FUserID + '    ' +
            '000' +
            StringOfChar(' ', 14) +
            '001' +
            StringOfChar(' ', 40);

end;

function TNorthernObj.UserTrailer: string;
var
  OutCreditTotal, OutDebitTotal,
  OutCreditCount, OutDebitCount : longint;
begin
  if IsReceipt then
  begin
    OutDebitTotal := TotalPenceWritten;
    OutDebitCount := TransactionsWritten;
    OutCreditTotal := 0;
    OutCreditCount := 0;
  end
  else
  begin
    OutDebitTotal := 0;
    OutDebitCount :=  0;
    OutCreditTotal := TotalPenceWritten;
    OutCreditCount := TransactionsWritten;
  end;

  Result := 'UTL1' +
            ZerosAtFront(OutDebitTotal, 13) +
            ZerosAtFront(OutCreditTotal, 13) +
            ZerosAtFront(OutDebitCount, 7) +
            ZerosAtFront(OutCreditCount, 7) +
            StringOfChar(' ', 36);
end;

function TNorthernObj.VolHeader: string;
begin
  Result := 'VOL1       ' + StringOfChar(' ', 26) +
            '    992087    ' +
            StringOfChar(' ', 28)
            + '1';
end;

function TNorthernObj.WriteRec(const EventData: TAbsEnterpriseSystem;
  Mode: word): Boolean;
var
  OutStr, TransCode, Ref : string;
  Target : TAbsCustomer;
  Pence : longint;
begin
  GetEventData(EventData);
  if IsReceipt then
    Target := EventData.Customer
  else
    Target := EventData.Supplier;


  if Mode = wrPayLine then
  begin

    if IsReceipt then
      TransCode := DirectDebitCode(Target.acDirDebMode)
    else {Payment}
      TransCode := '99';

    if not IsBlank(Bacs_Safe(Target.acBankRef)) then
      Ref := Bacs_Safe(Target.acBankRef)
    else
      Ref := EventData.Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);

    Pence := Pennies(ProcControl.Amount);

    OutStr := Target.acBankSort +
              Target.acBankAcc + '0' +
              TransCode +
              UserBankSort +
              UserBankAcc +
              '0000' +
              ZerosAtFront(Pence, 11) +
              LJVar(Bacs_Safe(FSetup.ssUserName), 18) +
              LJVar(Bacs_Safe(Ref), 18) +
              LJVar(Bacs_Safe(Target.acCompany), 18) +
              ' ' + JulianDateStr(ProcControl.PDate);

    Result := WriteThisRec(OutStr);

    TotalPenceWritten := TotalPenceWritten + Pence;
    inc(TransactionsWritten);


  end
  else
    Result := True; //No contra
end;

end.
