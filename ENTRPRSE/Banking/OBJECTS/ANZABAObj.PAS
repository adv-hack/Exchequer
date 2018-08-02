unit ANZABAObj;

interface

uses
  ExpObj, CustAbsU;


type
  TANZABAHeaderRec = Record
    RecTyp      : Char;
    BSB         : String[7];
    FromAc      : String[9];
    Reserved    : Char;
    Sequence    : String[2];
    Bank        : String[3];
    Reserved2   : string[7];
    UserName    : string[26];
    UserID      : string[6];
    Desc        : string[12];
    TransDate   : string[6];
    TransTime   : string[4];
    Reserved3   : string[36];
  end;

  TANZABAPaymentRec = Record
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

  TANZABATrailerRec = Record
    RecTyp      : Char;
    Reserved    : String[7];
    Reserved2   : String[12];
    NetTotal    : String[10];
    CreditTotal : String[10];
    DebitTotal  : String[10];
    Reserved3   : String[24];
    TotalCount  : String[6];
    Reserved4   : String[40];
  end;



  TANZABAExportObject = Class(TExportObject)
  private
    FUserID : string;
    FUserName : string;
    FDescription : string;

    FHeaderRec : TANZABAHeaderRec;
    FTrailerRec : TANZABATrailerRec;
    FHeaderWritten : Boolean;
    FTraceBSB : string;
    FTraceAC  : string;
    procedure ReadIniFile(const EventData : TAbsEnterpriseSystem);
    function FormatBSB(const s : string) : string;
    function WriteHeaderRec : Boolean;
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
  S_INI_FILENAME = 'ANZABA.ini';

function TANZABAExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                         Mode : word) : Boolean;
var
  OutRec  : TANZABAPaymentRec;
  OutString : AnsiString;
  Target : TAbsCustomer;
begin
  Result := True;

  GetEventData(EventData);

  if not FHeaderWritten then
  begin
    FHeaderRec.TransDate := DDMMYY(ProcControl.PDate);
    Result := WriteHeaderRec;
    FHeaderWritten := True;
  end;

  if Result and (Mode = wrPayLine) then {don't want the contra}
  begin
    FillChar(OutRec, SizeOf(OutRec), #0);
    with EventData, OutRec do
    begin

      Target := Supplier;

      RecTyp      := '1';
      ToBSB       := FormatBSB(Target.acBankSort);
      toAc        := LJVar(Target.acBankAcc, 9);
      Tax         := ' ';
      TransCode   := '50';
      Amount      := Pennies(ProcControl.Amount);
      ToName      := LJVar(Target.acCompany, 32);

      if Trim(Target.acBankRef) <> '' then
        Ref       := LJVar(Target.acBankRef, 18)
      else
        Ref       := LJVar(Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun), 18);

      //According to ANZ, the Trace account will usually be the same as the Funds account but
      //may sometimes be different. Consequently, we'll default these fields to the Funds account
      //but allow them to be overridden by settings in the ini file.
      if Trim(FTraceBSB) <> '' then
        TraceBSB := FTraceBSB
      else
        TraceBSB := FHeaderRec.BSB;

      if Trim(FTraceAC) <> '' then
        TraceAC := FTraceAC
      else
        TraceAC := FHeaderRec.FromAc;

      Originator  := LJVar(Setup.ssUserName, 16);
      Withholding := StringOfChar('0', 8);


//      Amount := Pennies(Transaction.thTotalInvoiced);

//      TransDate := DDMMYY(ProcControl.PDate);

      TotalPenceWritten := TotalPenceWritten + Amount;
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
  end; {if mode = wrpayline}
end;


procedure TANZABAExportObject.ReadIniFile(
  const EventData: TAbsEnterpriseSystem);
begin
  with TIniFile.Create(EventData.Setup.ssDataPath + S_INI_FILENAME) do
  Try
    {$IFDEF MULTIBACS}
    //Take User ID from database if available
    FUserID := UserID;
    if FUserID = '' then
    {$ENDIF}
      FUserID := ReadString('Settings','UserID', '');

    FDescription := ReadString('Settings','Description', '');
    FUserName    := ReadString('Settings','UserName', '');

    FTraceBSB    := ReadString('Settings','TraceBSB', '');
    FTraceAC    := ReadString('Settings','TraceAC', '');

    if Length(UserBankAcc) < 9 then
      UserBankAcc := UserBankRef;
  Finally
    Free;
  End;
end;

function TANZABAExportObject.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  TempStr : Shortstring;
begin
  Result := True;

  if Result then
  begin
    ReadIniFile(EventData);
    if FUserID = '' then
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

function TANZABAExportObject.CloseOutFile: integer;
begin
  FillChar(FTrailerRec, SizeOf(FTrailerRec), 0);

  with FTrailerRec do
  begin
    RecTyp      := '7';
    Reserved    := '999-999';
    Reserved2   := StringOfChar(' ', 12);
    NetTotal    := ZerosAtFront(TotalPenceWritten, 10);
    CreditTotal := NetTotal;
    DebitTotal  := StringOfChar('0', 10);
    Reserved3   := StringOfChar(' ', 24);
    TotalCount  := ZerosAtFront(TransactionsWritten, 6);
    Reserved4   := StringOfChar(' ', 40);
  end;

  WriteTrailerRec;

  Result := inherited CloseOutFile;
end;

function TANZABAExportObject.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
begin
  FHeaderWritten := False;
  Result := inherited CreateOutFile(AFileName, EventData);

  if Result = 0 then
  begin
    FillChar(FHeaderRec, SizeOf(FHeaderRec), 0);

    with FHeaderRec do
    begin
      RecTyp      := '0';
      BSB         := FormatBSB(UserBankSort);
      FromAc      := LJVar(UserBankAcc, 9);
      Reserved    := ' ';
      Sequence    := '01';
      Bank        := 'ANZ';
      Reserved2   := StringOfChar(' ', 7);
      UserName    := LJVar(FUserName, 26);
      UserID      := LJVar(FUserID, 6);
      Desc        := LJVar(FDescription, 12);
//      TransDate   : string[6];
      TransTime   := '0930';
      Reserved3   := StringOfChar(' ', 36);

    end;
  end;
end;

function TANZABAExportObject.FormatBSB(const s: string): string;
begin
  Result := s;
  if Pos('-', Result) = 0 then
    Insert('-', Result, 4);
end;

function TANZABAExportObject.WriteHeaderRec : Boolean;
var
  OutString : string;
begin
  with FHeaderRec do
  begin
    OutString :=  RecTyp     +
                  BSB        +
                  FromAc     +
                  Reserved   +
                  Sequence   +
                  Bank       +
                  Reserved2  +
                  UserName   +
                  UserID     +
                  Desc       +
                  TransDate  +
                  TransTime  +
                  Reserved3;

  end;

  Result := WriteThisRec(OutString);
end;

function TANZABAExportObject.ValidateRec(
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

function TANZABAExportObject.ValidBSB(const s: string): Boolean;
begin
  Result := (Length(s) = 6) or ((Length(s) = 7) and (Pos('-', s) = 4));
end;

function TANZABAExportObject.WriteTrailerRec: Boolean;
var
  OutStr : string;
begin
  with FTrailerRec do
    OutStr := RecTyp      +
              Reserved    +
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
