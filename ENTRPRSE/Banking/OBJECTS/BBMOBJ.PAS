unit BbmObj;

interface

{$H-}

uses
  ExpObj, BacConst, CustAbsU, BbmConst, Db_Accss, Enterprise01_TLB;

type
  TBbmObject = Class(TExportObject)
  protected
    FEventData : TAbsEnterpriseSystem;
    FDelimiter : String;
    FAccessCode : string;
    FDbase, FTable : string;
    FDm : Tdm1;
    FTarget : TAbsCustomer;
    FBankAcc : string;
    FToolkit : IToolkit;
    Pence : longint;
    FFileNo : longint;
    FPath : string;
    FDebugMode : Boolean;
    FStrictValidation : Boolean;
    FNoCRAtEndOfRec, FNoCRAtEndOfFile : integer;
    function ReadIniFile(Folder : AnsiString) : Boolean;
    function PayeeBankDetails : AnsiString;
    function TransRef : String;
    function ValDate : String;
    function CurrencyCode : String;
    function Amount : String;
    function RemitterName : String;
    function AccNumber : String;
    function ChargingInstructions : String;
    function SenderRecInfo : string;
    function SetString(const s : string) : string;
    function PaymentDetails : string;
    function CheckField(const s : string; const FName : string) : Boolean;
    function CRs(Count : integer) : string;
  public
    constructor Create;
    destructor Destroy; override;
    function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function WriteRec(const EventData : TAbsEnterpriseSystem;
                      Mode : word) : Boolean; override;
    function CreateOutFile(const AFileName : string;
                           const EventData :
                           TAbsEnterpriseSystem) : integer; override;
    function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;

  end;


implementation

uses
  IniFiles, SysUtils;

constructor TBbmObject.Create;
begin
 inherited Create;
 FDm := TDm1.Create(nil);
 FDelimiter := '';
 Pence := 0;
 FDebugMode := False;
 FStrictValidation := True;
end;

destructor TBbmObject.Destroy;
begin
  FDm.Free;
  inherited Destroy;
end;

function TBbmObject.TransRef : String;
begin
  Result := SetString(FEventData.Transaction.thOurRef);
end;

function TBbmObject.ValDate : String;
begin
  Result := FEventData.Transaction.thTransDate;
{  Result := Copy(Result, 1, 4) + '/' +
            Copy(Result, 5, 2) + '/' +
            Copy(Result, 7, 2);
  Result := SetString(Result);}
end;

function TBbmObject.CurrencyCode : String;
begin
  Result := SetString(ProcControl.PayCurr);
end;

function TBbmObject.Amount : String;
begin
  Pence := Round(FEventData.Transaction.thInvNetVal * 100);
//  Result := IntToStr(Pence);}
  Result := Trim(Format('%12.2f', [FEventData.Transaction.thInvNetVal]));
end;

function TBbmObject.RemitterName : String;
begin
  Result := SetString(Trim(FEventData.Setup.ssUserName));
end;

function TBbmObject.AccNumber : String;
begin
  Result := Trim(FBankAcc);
end;

function TBbmObject.ChargingInstructions : String;
begin
  //not used - taken from access table
end;

function TBbmObject.SenderRecInfo : string;
begin
  //not used - taken from access table
end;

function TBbmObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                      Mode : word) : Boolean;
var
  OutRec : AnsiString;
begin
  if Mode <> wrContra then
  begin
    GetEventData(EventData); //loads data into proccontrol rec
    FEventData := EventData;
    FTarget := GetTarget(EventData);

    OutRec := TransRef + CRLF +
              ValDate + CRLF +
              CurrencyCode + CRLF +
              Amount + CRLF +
              RemitterName + CRLF +
              AccNumber + CRLF +
              PayeeBankDetails + CRs(FNoCRAtEndOfRec);

//    Result := WriteThisRec(OutRec);
    {$I-}
    Write(OutFile, OutRec);
    Result := (IOResult = 0);
    TotalPenceWritten := TotalPenceWritten + Pence;
    inc(TransactionsWritten);
    if not Result then
    begin
      ShowExportMessage('Warning','Unable to write record ' + IntToStr(TransactionsWritten)
                      + ' to file', 'This run has been aborted');
      Failed := flFile;
    end;
    {$I+}


  end
  else
  begin
    {$I-}
    Write(OutFile, Crs(FNoCRAtEndOfFile));
    Result := True;
    {$I+}
  end;
end;

function TBbmObject.ReadIniFile(Folder : AnsiString) : Boolean;
var
  s : AnsiString;
begin
  Result := True;
  s := IncludeTrailingBackSlash(Folder) + BbmIniFileName;

  with TIniFile.Create(s) do
  Try
    FDbase := ReadString('DataAccess', 'DataBase', '');
    FTable := ReadString('DataAccess', 'Table', '');
    FDelimiter := ReadString('Output', 'Delimiter', '');
    FFileNo := ReadInteger('Output', 'FileNumber', 1);
    FPath := ReadString('Output', 'Folder', '');
    FNoCRAtEndOfRec := ReadInteger('Output', 'NoCRAtEndOfRec', 2);
    FNoCRAtEndOfFile := ReadInteger('Output', 'NoCRAtEndOfFile', 0);

    FBankAcc := ReadString('Banks', IntToStr(ProcControl.BankGl), '');
    //Increment fileno for next run
    if FFileNo < 99 then
      WriteInteger('Output', 'FileNumber', FFileNo + 1)
    else
      WriteInteger('Output', 'FileNumber', 1);

    FStrictValidation := ReadBool('DataAccess', 'StrictValidation', True);
  Finally
    Free;
  End;

end;

function TBbmObject.PayeeBankDetails : AnsiString;
var
  Tmp : AnsiString;
begin
  Result := SetString(FDm.GetString(detSwiftBIC)) + CRLF +
            SetString(FDm.GetString(detRouting))  + CRLF +
            SetString(FDm.GetString(detBankName)) + CRLF +
            SetString(FDm.GetString(detBankAdd1)) + CRLF +
            SetString(FDm.GetString(detBankAdd2)) + CRLF +
            SetString(FDm.GetString(detBankAdd3)) + CRLF +
            SetString(FDm.GetString(detBankAcc)) + CRLF +
            SetString(FDm.GetString(detBenName)) + CRLF +
            SetString(FDm.GetString(detBenAdd1)) + CRLF +
            SetString(FDm.GetString(detBenAdd2)) + CRLF +
            SetString(FDm.GetString(detBenAdd3)) + CRLF +
            PaymentDetails + CRLF +
            SetString(FDm.GetString(detCharge)) + CRLF;{ +
            SetString(FDm.GetString(detPay));           }

            Result := Result + SetString(FDm.GetString(detPay)) + CRLF;

end;

function TBbmObject.CreateOutFile(const AFileName : string;
                                  const EventData :
                                   TAbsEnterpriseSystem) : integer;
var
  s : string;
begin
  Result := 0;
  GetEventData(EventData);
  Try
    ReadIniFile(EventData.Setup.ssDataPath);
  Except
  End;

  if (FDbase = '') or (FTable = '') then
  begin
    ShowExportMessage('Warning', 'Database and table must be specified',
                        'Run aborted');
    Result := 1;
  end
  else
  if not FDm.InitialiseTable(FDbase, FTable) then
  begin
    if FDm.ErrorCode = 101 then
      ShowExportMessage('Warning', 'Cannot open database ' + QuotedStr(FDbase),
                        'Run aborted')
    else
    if FDm.ErrorCode = 102 then
      ShowExportMessage('Warning', 'Cannot open table ' + QuotedStr(FTable) +
                         ' in database ' + QuotedStr(FDbase),
                        'Run aborted');


      Result := 2;
  end
  else
    if (Trim(FBankAcc) = '') or not AllDigits(FBankAcc) then
    begin
      ShowExportMessage('Warning', 'Invalid Bank Account for GL Code '  + IntToStr(ProcControl.BankGl),
                        'Run aborted');
      Result := 3;
    end;

  if Result = 0 then
  begin
{    s := FormatDateTime('YYMMDD', Date) +
                          ZerosAtFront(FFileNo, 2) + '.' + ProcControl.PayCurr;}
    //Change requested by Keith Simms 27/9/02
    s := 'BACS' + ZerosAtFront(ProcControl.PayRun, 4) + '.' + ProcControl.PayCurr;

    if Trim(FPath) = '' then
      s := IncludeTrailingBackSlash(EventData.Setup.ssDataPath) + s
    else
      s := IncludeTrailingBackslash(FPath) + s;

    Result := Inherited CreateOutFile(s, EventData);


  end;
end;

function TBbmObject.ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean;
var
  TempStr : string;
  Target : TAbsCustomer;
  BIC, Routing : Boolean;
begin
  GetEventData(EventData);
  with EventData do
  begin
    Target := GetTarget(EventData);

    Result := FDm.SelectRecord(Target.acCode);

    if not Result then
      LogIt('Unable to find record for ' + Target.acCode)
    else
    begin
      LogIt('Record found for ' + Target.acCode);
      BIC := FDm.GetString(detSwiftBIC) <> '';
      Routing := FDm.GetString(detRouting) <> '';

      //Must have either SWIFT BIC or Routing Code but not both
      //At request of Keith Simms allow a less strict validation which allows both to be blank
      if FStrictValidation then
      begin
        if not BIC xor Routing then
        begin
          Result := False;
          if BIC then
            LogIt('Cannot use both SWIFT Code and Routing Code')
          else
            LogIt('SWIFT Code and Routing Code cannot both be blank');
        end;

        if Result and not BIC then
          Result := Result and
            CheckField(FDm.GetString(detBankName), detBankName) and
            CheckField(FDm.GetString(detBankAdd1), detBankAdd1) and
            CheckField(FDm.GetString(detBankAdd2), detBankAdd2);

        Result := Result and
                CheckField(FDm.GetString(detBankAcc), detBankAcc) and
                CheckField(FDm.GetString(detBenName), detBenName);
      end;

    end;
  end;
end;

function TBbmObject.SetString(const s : string) : string;
begin
  Result := Bacs_Safe(s);
end;

function TBbmObject.PaymentDetails : string;
begin
  with FEventData do
  Result := SetString(Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun)) + CRLF +
            SetString('') + CRLF +
            SetString('') + CRLF +
            SetString('');
end;

function TBbmObject.ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean;
var
  TempStr : Shortstring;
begin
  Result := True;
  GetEventData(EventData);
  if Length(ProcControl.PayCurr) <> 3 then
  begin
    Result := False;
    Failed := flCurrency;
  end;

  if Result then
    LogIt('Validate system - successful');

end;

function TBbmObject.CheckField(const s : string; const FName : string) : Boolean;
begin
  Result := Trim(s) <> '';
  if not Result then
    LogIt('No value found for field ' + QuotedStr(FName));
end;

function TBbmObject.CRs(Count : integer) : string;
var
  i : integer;
begin
  Result := '';
  if Count > 0 then
    for i := 1 to Count do
      Result := Result + CRLF;
end;






end.
