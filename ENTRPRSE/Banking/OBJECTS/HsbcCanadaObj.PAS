unit HsbcCanadaObj;

interface

uses
  ExpObj, CustAbsU;


type

  THSBCCanadaPaymentRec = Record
    RecType       : Char;        // 'P' or 'R' (Credit or debit.)
    XRef          : string[19];  //Blank
    ToSortCode    : string[9];   //Bank no + branch no
    ToAcNo        : string[12];  // Left-justified
    Amount        : longint;   // Cents
    ToName        : string[30];
    OurAcNo       : string[12];
    CPACode       : string[3];
    OurNameShort  : string[15];
    OurNameLong   : string[30];
  end;


  THSBCCanadaExportObject = Class(TExportObject)
  private
    FUserID : string;
    FUserName : string;
    FDescription : string;
    FFileCreationNo : longint;

    FCreditCPA : string;
    FDebitCPA : string;

    FSegmentCount : Integer;
    FLineCount : Integer;
    FOutString : AnsiString;

    procedure ReadIniFile(const EventData : TAbsEnterpriseSystem);
    function WriteHeaderRec : Boolean;
    function WriteTrailerRec : Boolean;
    function GetCreationDate : string;
    function GetCPACode : string;
    function GetDueDate : string;
  protected
    function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function Flush : Boolean;
    function GetLineStart : string;
    function GetRecType : string;
  public
     function BACS_Safe(TStr  :  Str255)  :  Str255; override;
     function WriteRec(const EventData : TAbsEnterpriseSystem;
                       Mode : word) : Boolean; override;
     function CreateOutFile(const AFileName : string;
                            const EventData :
                            TAbsEnterpriseSystem) : integer;  overload; override;
     function CloseOutFile : integer; override;
  end;

implementation

uses
  SysUtils, StrUtils, MultIni, IniFiles, DateUtils;

const
  S_INI_FILENAME = 'HSBCCanada.ini';
  LINE_START_LENGTH = 24;

function THSBCCanadaExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                         Mode : word) : Boolean;
var
  OutRec  : THSBCCanadaPaymentRec;
  OutString : AnsiString;
  Target : TAbsCustomer;
begin
  Result := True;

  GetEventData(EventData);

  if (Mode <> wrPayLine) then //Contra - write any existing line.
  begin
    if Length(FOutString) >  LINE_START_LENGTH then
      Result := Flush;
  end
  else
  begin
    if FOutString = '' then
      FOutString := GetLineStart;

    FillChar(OutRec, SizeOf(OutRec), #0);
    with EventData, OutRec do
    begin

      if IsReceipt then
        Target := Customer
      else
        Target := Supplier;

      ToSortCode  := Target.acBankSort;
      toAcNo        := Target.acBankAcc;
      Amount      := Pennies(ProcControl.Amount);
      ToName      := Bacs_Safe(Target.acCompany);



      OurNameLong := Bacs_Safe(Setup.ssUserName);
      if UpperCase(Copy(Setup.ssUserName, 1, 4)) = 'THE ' then
        OurNameShort := Bacs_Safe(Copy(Setup.ssUserName, 5, Length(Setup.ssUserName)))
      else
        OurNameShort := OurNameLong;

      XRef := Transaction.thOurRef;


      OurAcNo  := UserBankAcc;

      TotalPenceWritten := TotalPenceWritten + Amount;
      inc(TransactionsWritten);

      OutString := GetCPACode +
                   ZerosAtFront(Amount, 10) +
                   GetDueDate  +
                   ToSortCode +
                   LJVar(toAcNo, 12)  +
                   StringOfChar('0', 25) +
                   LJVar(OurNameShort, 15) +
                   LJVar(ToName, 30) +
                   LJVar(OurNameLong, 30) +
                   FUserID +
                   LJVar(XRef, 19) +
                   StringOfChar(' ', 60) +
                   StringOfChar('0', 11);


      FOutString := FOutString + OutString;
      inc(FSegmentCount);
      if FSegmentCount = 6 then
        Result := Flush;
    end; {with eventdata, outrec}
  end; {if mode = wrpayline}
end;


procedure THSBCCanadaExportObject.ReadIniFile(
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

    //Read last file creation no, increment it and write it back. As the
    //field is only 4 chars we can't go above 9999, so start again at 1.
    FFileCreationNo := ReadInteger('Settings','FileNo', 0);
    inc(FFileCreationNo);

    if FFileCreationNo > 9999 then
      FFileCreationNo := 1;
    WriteInteger('Settings','FileNo', FFileCreationNo);

    //Read CPA codes
    FDebitCPA := ReadString('Settings', 'DebitCPA', '700');
    FCreditCPA := ReadString('Settings', 'CreditCPA', '450');

    if Length(UserBankAcc) < 12 then
      UserBankAcc := UserBankRef;
  Finally
    Free;
  End;
end;

function THSBCCanadaExportObject.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  TempStr : Shortstring;
begin
  Result := True;

  if Result then
  begin
    ReadIniFile(EventData);
    if Length(FUserID) <> 10 then
    begin
      Result := False;
      Failed := flUserId;
    end;
  end;

  with EventData.Setup do
  begin

    if Length(UserBankAcc) <> 12 then
    begin
      Result := False;
      failed := flBank;
    end;
  end; {with EventData.Setup}


  if Result then
    LogIt('Validate system - successful');
end;

function THSBCCanadaExportObject.CloseOutFile: integer;
begin
  WriteTrailerRec;

  Result := inherited CloseOutFile;
end;

function THSBCCanadaExportObject.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
begin
  Result := inherited CreateOutFile(AFileName, EventData);

  if Result = 0 then
  begin
    if not WriteHeaderRec then
      Result := 1;
  end;
end;

function THSBCCanadaExportObject.WriteHeaderRec : Boolean;
var
  OutString : AnsiString;
begin
  OutString := 'A000000001' +
               FUserId +
               ZerosAtFront(FFileCreationNo, 4) +
               GetCreationDate +
               '01600' + StringOfChar(' ', 20) +
               'CAD' + StringOfChar(' ', 1406);

  Result := WriteThisRec(OutString);
  FSegmentCount := 0;
  FLineCount := 2;
  FOutString := '';
end;

function THSBCCanadaExportObject.ValidateRec(
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

    if Length(TempStr) < 9 then
    begin
      LogIt(Target.acCompany + ': Invalid SortCode - ' + TempStr);
      Result := False;
    end;
  end; {with EventData}
end;

function THSBCCanadaExportObject.WriteTrailerRec: Boolean;
var
  OutStr : AnsiString;
begin
  OutStr := 'Z' +
            ZerosAtFront(FLineCount, 9) +
            FUserID +
            ZerosAtFront(FFileCreationNo, 4);

  if IsReceipt then
  begin
    OutStr := OutStr + ZerosAtFront(TotalPenceWritten, 14) +
    ZerosAtFront(TransactionsWritten, 8) +
    StringOfChar('0', 36);
  end
  else
  begin
    OutStr := OutStr + StringOfChar('0', 22) +
    ZerosAtFront(TotalPenceWritten, 14) +
    ZerosAtFront(TransactionsWritten, 8) +
    StringOfChar('0', 14);
  end;

  OutStr := OutStr + StringOfChar('0', 30) + StringOfChar(' ', 1352);

  Result := WriteThisRec(OutStr);
end;

function THSBCCanadaExportObject.GetCreationDate: string;
begin
  Result := '0' + FormatDateTime('yy', Date) + ZerosAtFront(DayOfTheYear(Date), 3);
end;

function THSBCCanadaExportObject.GetCPACode: string;
begin
  if IsReceipt then
    Result := FDebitCPA
  else
    Result := FCreditCPA;
end;

function THSBCCanadaExportObject.Flush: Boolean;
begin
  Result := WriteThisRec(FOutString);
  Inc(FLineCount);
  FOutString := GetLineStart;
end;

function THSBCCanadaExportObject.GetLineStart : string;
begin
  Result :=  GetRecType + ZerosAtFront(FLineCount, 9) + FUserID + ZerosAtFront(FFileCreationNo, 4);
end;

function THSBCCanadaExportObject.GetRecType: string;
begin
  if IsReceipt then
    Result := 'D'
  else
    Result := 'C';
end;

function THSBCCanadaExportObject.GetDueDate: string;
begin
  Result := '0' + Copy(ProcControl.PDate, 3, 2) + ZerosAtFront(DayOfYear(ProcControl.PDate), 3);
end;

function THSBCCanadaExportObject.BACS_Safe(TStr: Str255): Str255;
var
  i : integer;
begin
  Result := UpperCase(TStr);
  for i := 1 to Length(Result) do
    if not (Result[i] in ['0'..'9', 'A'..'Z', ' ']) then
      Result[i] := ' ';
end;

end.
