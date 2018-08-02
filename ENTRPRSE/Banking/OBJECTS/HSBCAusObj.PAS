unit HSBCAusObj;

interface

uses
  ExpObj, CustAbsU;


type

  THSBCAustraliaPaymentRec = Record
    RecTyp      : Char;
    ToBSB       : String[7];
    toAc        : String[9];
    Tax         : Char;
    TransCode   : String[2];
    Amount      : longint;
    ToName      : string[32];
    Ref         : string[18];
    TraceBSB    : string[7];
    TraceAC     : string[9];
    Originator  : string[16];
    Withholding : string[8];
  end;

  THSBCAustraliaTrailerRec = Record
    RecTyp      : Char;
    InstAcNo    : String[7]; //999-999
    Reserved2   : String[12];
    NetTotal    : String[10];
    CreditTotal : String[10];
    DebitTotal  : String[10];
    Reserved3   : String[24];
    TotalCount  : String[6];
    Reserved4   : String[40];
  end;



  THSBCAustraliaExportObject = Class(TExportObject)
  private
    FUserNo : Integer;
    FUserName : string;
    FDescription : string;

    FTrailerRec : THSBCAustraliaTrailerRec;
    FHeaderWritten : Boolean;
    FTraceBSB : string;
    FTraceAC  : string;
    procedure ReadIniFile(const EventData : TAbsEnterpriseSystem);
    function FormatBSB(const s : string) : string;
    function ValidBSB(const s : string) : Boolean;
    function WriteTrailerRec : Boolean;
  protected
    function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean; override;
  public
     function WriteRec(const EventData : TAbsEnterpriseSystem;
                       Mode : word) : Boolean; override;
     function CreateOutFile(const AFileName : string;
                            const EventData :
                            TAbsEnterpriseSystem) : integer;  overload; override;
     function CloseOutFile : integer; override;
  end;

implementation

uses
  SysUtils, StrUtils, MultIni, IniFiles;

const
  S_INI_FILENAME = 'HSBCAustralia.ini';

function THSBCAustraliaExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                         Mode : word) : Boolean;
var
  OutRec  : THSBCAustraliaPaymentRec;
  OutString : AnsiString;
  Target : TAbsCustomer;
begin
  GetEventData(EventData);


  FillChar(OutRec, SizeOf(OutRec), #0);
  with EventData, OutRec do
  begin
    if IsReceipt then
      Target := Customer
    else
      Target := Supplier;

    RecTyp      := '1';
    if Mode = wrPayLine then
    begin
      ToBSB       := FormatBSB(Target.acBankSort);
      toAc        := RJVar(Target.acBankAcc, 9);
      Amount      := Pennies(ProcControl.Amount);
      TotalPenceWritten := TotalPenceWritten + Amount;
      if IsReceipt then
        TransCode := '13'
      else
        TransCode   := '50';
      Ref       := LJVar(Transaction.thOurRef, 18);
      ToName      := LJVar(Target.acCompany, 32);
    end
    else
    begin
      ToBSB       := FormatBSB(UserBankSort);
      toAc        := RJVar(UserBankAcc, 9);
      Amount      := TotalPenceWritten;
      if IsReceipt then
        TransCode := '50'
      else
        TransCode   := '13';
      Ref       := LJVar('Payment Run ' + IntToStr(ProcControl.PayRun), 18);
      ToName      := LJVar('Balancing Entry', 32);
    end;
    Tax         := ' ';


    TraceBSB := FormatBSB(UserBankSort);
    TraceAc := RJVar(UserBankAcc, 9);

    Originator  := LJVar(Setup.ssUserName, 16);
    Withholding := StringOfChar('0', 8);


    inc(TransactionsWritten);

    OutString := RecTyp     +
                 ToBSB      +
                 toAc       +
                 Tax        +
                 TransCode  +
                 ZerosAtFront(Amount, 10)
                            +
                 ToName     +
                 Ref        +
                 TraceBSB   +
                 TraceAC    +
                 Originator +
                 Withholding;
;

    Result := WriteThisRec(OutString);
  end; {with eventdata, outrec}
end;


procedure THSBCAustraliaExportObject.ReadIniFile(
  const EventData: TAbsEnterpriseSystem);
begin
  with TIniFile.Create(EventData.Setup.ssDataPath + S_INI_FILENAME) do
  Try
    {$IFDEF MULTIBACS}
    //Take User ID from database if available
    Try
      FUserNo := StrToInt(UserID);
    Except
      FUserNo := 0;
    End;
    if FUserNo = 0 then
    {$ENDIF}
      FUserNo := ReadInteger('Settings','UserID', 0);


    if Length(UserBankAcc) < 9 then
      UserBankAcc := UserBankRef;
  Finally
    Free;
  End;
end;

function THSBCAustraliaExportObject.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  TempStr : Shortstring;
begin
  Result := True;

  if Result then
  begin
    ReadIniFile(EventData);
    if FUserNO = 0 then
    begin
      Result := False;
      Failed := flUserId;
    end;
  end;

  with EventData.Setup do
  begin

    if not ValidBSB(UserBankSort) then
    begin
      Result := False;
      failed := flBank;
    end;
  end; {with EventData.Setup}


  if Result then
    LogIt('Validate system - successful');
end;

function THSBCAustraliaExportObject.CloseOutFile: integer;
begin
  FillChar(FTrailerRec, SizeOf(FTrailerRec), 0);

  with FTrailerRec do
  begin
    RecTyp      := '7';
    InstAcNo    := '999-999';
    Reserved2   := StringOfChar(' ', 12);
    NetTotal    := StringOfChar('0', 10);
    CreditTotal := ZerosAtFront(TotalPenceWritten, 10);
    DebitTotal  := CreditTotal;
    Reserved3   := StringOfChar(' ', 24);
    TotalCount  := ZerosAtFront(TransactionsWritten, 6);
    Reserved4   := StringOfChar(' ', 40);
  end;

  WriteTrailerRec;

  Result := inherited CloseOutFile;
end;

function THSBCAustraliaExportObject.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
var
  OutString : string;
begin
  FHeaderWritten := False;
  Result := inherited CreateOutFile(AFileName, EventData);

  if Result = 0 then
  begin
    GetEventData(EventData);
    OutString :=  '0'  + StringOfChar(' ', 17) + '01HBA' + StringOfChar(' ', 7) +
                  LJVar(EventData.Setup.ssUserName, 26) + ZerosAtFront(FUserNo, 6) +
                  LJVar(IntToStr(ProcControl.PayRun), 12) + DDMMYY(ProcControl.PDate) +
                  StringOfChar(' ', 40);

    if WriteThisRec(OutString) then
      Result := 0
    else
      Result := -1;
  end;
end;

function THSBCAustraliaExportObject.FormatBSB(const s: string): string;
begin
  Result := s;
  if Pos('-', Result) = 0 then
    Insert('-', Result, 4);
end;


function THSBCAustraliaExportObject.ValidateRec(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  TempStr : string;
  Target : TAbsCustomer;
begin
  Result := True;
  GetEventData(EventData);
  with EventData do
  begin
    Target := GetTarget(EventData);

    if Target.acPayType <> 'B' then
    begin
      Result := False;
      LogIt(Target.acCompany + ': PayType not set to Bacs');
    end;

    TempStr := Target.acBankSort;
    if not ValidBSB(TempStr) then
    begin
      LogIt(Target.acCompany + ': Invalid BSB - ' + TempStr);
      Result := False;
    end;
  end; {with EventData}
end;

function THSBCAustraliaExportObject.ValidBSB(const s: string): Boolean;
begin
  Result := (Length(s) = 6) or ((Length(s) = 7) and (Pos('-', s) = 4));
end;

function THSBCAustraliaExportObject.WriteTrailerRec: Boolean;
var
  OutStr : string;
begin
  with FTrailerRec do
    OutStr := RecTyp      +
              InstAcNo    +
              Reserved2   +
              NetTotal    +
              CreditTotal +
              DebitTotal  +
              Reserved3   +
              TotalCount  +
              Reserved4;

  Result := WriteThisRec(OutStr);

end;

end.
