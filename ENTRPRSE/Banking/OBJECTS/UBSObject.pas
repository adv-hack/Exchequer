unit UBSObject;

interface

uses
  ExpObj, LegacySepaObj, CustAbsU;

type
  TUBSExportObject = Class(TLegacySepaObject)
  protected
    FBankClearingNo : string;
    FUserID : string;
    FIniFileRead : Boolean;
    function GetPaymentDate : string;
    function GetClearingCode(const IBAN : string) : string;
    function GetUserID : string;
    function GetTargetDetails(const Target: TAbsCustomer4) : string;
    function GetSegment3(const Target: TAbsCustomer4) : string;
    function GetOurAddress(const EventData : TAbsEnterpriseSystem) : string;
    procedure ReadIniFile;
  public
    constructor Create;
    function CloseOutFile : integer; override;
    function WriteRec(const EventData : TAbsEnterpriseSystem;
                      Mode : word) : Boolean; override;
  end;

implementation

uses
  EtDateU, SysUtils, IniFiles, Multini;

const
  IniFileName = 'UBSPay.ini';


{ TUBSExportObject }

function TUBSExportObject.GetClearingCode(const IBAN : string): string;
begin
  //Bank Clearing No in a Swiss IBAN is positions 5-9; however it may be left-padded with
  //zeros, so we need to remove those first.
  Result := Copy(IBAN, 5, 5);
  if Result[1] = '0' then
    Delete(Result, 1, 1);

  if Result[1] = '0' then
    Delete(Result, 1, 1);
end;

function TUBSExportObject.GetTargetDetails(const Target: TAbsCustomer4) : string;
begin
  Result := LJVar(Target.acCompany, 35) + LJVar(Target.acAddress[1], 35) + LJVar(Target.acAddress[2], 35) +
                 StringOfChar(' ', 21);
end;

function TUBSExportObject.GetPaymentDate: string;
begin
  Result := Copy(ProcControl.PDate, 3, 6);
end;

function TUBSExportObject.GetSegment3(
  const Target: TAbsCustomer4): string;

var
  IdChar : Char;

  function IdType(const IBAN : string) : Char;
  begin
    if (IBAN = 'CH') or (IBAN = 'LI') then
      Result := 'D'
    else
      Result := 'A';
  end;

begin
  IdChar := IdType(Copy(Target.acBankAccountCode, 1, 2));

  Case IdChar of
    'D' : Result := IdChar + StringOfChar(' ', 70);
    'A' : Result := IdChar + LJVar(Target.acBankSortCode, 70);
  end;

  Result := Result + LJVar(Target.acBankAccountCode, 55);
end;

function TUBSExportObject.GetUserID: string;
begin
  Result := FUserID;
end;

function TUBSExportObject.WriteRec(const EventData: TAbsEnterpriseSystem;
  Mode: word): Boolean;
var
  Target : TAbsCustomer4;
  OutString : AnsiString;
  Amount : longint;
begin
  Result := True;

  if not FIniFileRead then
  begin
    ReadIniFile;
    {$IFNDEF MULTIBACS}
    UserBankAcc := TAbsSetup10(EventData.Setup).ssBankAccountCode;
    {$ENDIF}
  end;

  GetEventData(EventData);

  if Mode = wrPayLine then
  with EventData do
  begin
    Target := TAbsCustomer4(Supplier);
    Amount := Pennies(ProcControl.Amount);
    TotalPenceWritten := TotalPenceWritten + Amount;
    inc(TransactionsWritten);

    OutString := '01000000            00000' +
                 YYMMDD(EtDateU.Today) +
                 LJVar(GetClearingCode(UserBankAcc), 7) +
                 LJVar(GetUserID, 5) +
                 ZerosAtFront(TransactionsWritten, 5) +
                 '83600' +
                 LJVar(GetUserID, 5) +
                 LJVar(Transaction.thOurRef, 11) +
                 LJVar(UserBankAcc, 24) +
                 YYMMDD(ProcControl.PDate) +
                 ProcControl.PayCurr +
                 LJVar(Trim(EuroFormat(ProcControl.Amount)), 15) +
                 StringOfChar(' ', 11) +
                 // Segment 2
                 '02' + StringOfChar(' ', 12) +
                 GetOurAddress(EventData) +
                 StringOfChar(' ', 9) +
                 // Segment 3
                 '03' + GetSegment3(Target) +
                 // Segment 4
                 '04' + GetTargetDetails(Target) +
                 // Segment 5
                 '05U' + LJVAr(IntToStr(ProcControl.PayRun) + '/' + Transaction.thOurRef, 105) +
                 '2' {= SHA} + StringOfChar(' ', 19);
                 ;

    Result := WriteThisRec(OutString);
  end;
end;

procedure TUBSExportObject.ReadIniFile;
var
  TheIni : TIniFile;
begin
  {$IFNDEF MULTIBACS}
  TheIni := TIniFile.Create(RequiredPath + IniFileName);
  Try
    FUserID := TheIni.ReadString('Settings','UserID','');
    FIniFileRead := True;
  Finally
    TheIni.Free;
  End;
  {$ELSE}
  FUserID := UserID;
  {$ENDIF}
end;

function TUBSExportObject.CloseOutFile: integer;
var
  OutString : string;
begin
      OutString := '01000000            00000' +
                 YYMMDD(EtDateU.Today) +
                 LJVar(' ', 7) +
                 LJVar(GetUserID, 5) +
                 ZerosAtFront(TransactionsWritten + 1, 5) +
                 '89000' +
                 LJVar(EuroFormat(Pounds(TotalPenceWritten)), 75);

  WriteThisRec(OutString);

  Result := inherited CloseOutFile;
end;

function TUBSExportObject.GetOurAddress(
  const EventData: TAbsEnterpriseSystem): string;
begin
  with EventData do
    Result := LJVar(Setup.ssUserName, 35) + LJVar(Setup.ssDetailAddr[1], 35) + LJVar(Setup.ssDetailAddr[2], 35);
end;

constructor TUBSExportObject.Create;
begin
  inherited;
  FIniFileRead := False;
end;

end.
