unit HexObj;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

{$IFDEF BBM}
  {$H-}
{$ENDIF}


uses
  ExpObj, Hex01, CustAbsU, Classes, MultiObj;

type

  THexagonExportObject = Class(TMultiFileExportObject)
    protected
      HeaderRec    : THexFileHeaderRec;
      ContraRec    : THexBalanceHeader;
      PayLines     : Array[1..MaxPayLines] of THexPaymentRec;
      PayValue     : longint;
      ContraCount  : integer;
      FDateFormat  : string;
      procedure InitialiseHeader(const EventData : TAbsEnterpriseSystem);
      procedure InitialiseContra(const EventData : TAbsEnterpriseSystem);
      function WriteData(const EventData : TAbsEnterpriseSystem) : Boolean; override;
      procedure DeleteOldFiles(const EventData : TAbsEnterpriseSystem); override;
      procedure ReadIniFile;
    public
      constructor Create(const EventData : TAbsEnterpriseSystem);
      function GetDate(const ADate : string) : string;
      function FormatDate(const ADate : string) : String;
      function WriteRec(const EventData : TAbsEnterpriseSystem;
                           Mode : word) : Boolean; override;
      function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
      function CreateOutFile(const AFileName : string;
                             const EventData :
                             TAbsEnterpriseSystem) : integer; override;
    end;

var
  HexagonExportObject : THexagonExportObject;


implementation

uses
  SysUtils, IniFiles, Dialogs, Controls;

constructor THexagonExportObject.Create(const EventData : TAbsEnterpriseSystem);
begin
  inherited Create;
  RecsPerFile := MaxPayLines;
  FMaxFiles := MaxFiles;
  Ext := DefaultExt;
  FDigitCount := 3;
  FOverwriteFiles := False;
  RequiredPath := IncludeTrailingBackslash(EventData.Setup.ssDataPath);
  ReadIniFile;
end;

procedure THexagonExportObject.InitialiseHeader(const EventData : TAbsEnterpriseSystem);
begin
  FillChar(HeaderRec, SizeOf(HeaderRec), 0);
  with HeaderRec do
  begin
    GetEventData(EventData);
    Count       := 1;     {number of payments in file}
    TotalValue  := 0;     {value of all payments}
    if (Ord(ProcControl.PayCurr[1]) = 128) or
       (ProcControl.PayCurr = 'EUR') then  {is there a better way of doing this?}
       Currency := 'EUR'
    else
       Currency := 'GBP';
  end;
end;

procedure THexagonExportObject.InitialiseContra(const EventData : TAbsEnterpriseSystem);
begin
  GetEventData(EventData);
  with EventData, ContraRec do
  begin
     CoAcc      := UserBankAcc;
//     ValDate    := GetDate(ProcControl.PDate);
//     ValDate    := ProcControl.PDate; //16/3/04 - Date format changed to yyyymmdd
     ValDate    := FormatDate(ProcControl.PDate); //24/03/06 Date format changed again. We now take
                                                  //it from the ini file to make it relatively future-
                                                  //proof.
     Descript   := 'BACS ' + IntToStr(ProcControl.PayRun);//24/03/06 Remove '/' character from Descript
     PCount     := 0;
     PTotal     := 0;
  end;
  PayCount := 1;
  PayValue := 0;
  Inc(ContraCount);
  if not AllDigits(ContraRec.ValDate) then
  begin
    ShowExportMessage('Error','Invalid Windows date format','Run aborted');
    EventData.BoResult := False;
    Failed := flDate;
  end;
end;


function THexagonExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                                  Mode : word) : Boolean;
var
  Target : TAbsCustomer;
begin
  Result := True;
  Target := GetTarget(EventData);
  if Mode = wrContra then
  begin
    GetEventData(EventData);
    ContraRec.Descript   := 'BACS ' + IntToStr(ProcControl.PayRun);
    if ContraRec.PCount > 0 then
      Result := WriteBatch(EventData);
  end
  else
  begin
    with EventData, PayLines[PayCount] do
    begin
      DestAcc    := Target.acBankAcc;
      DestSort   := Target.acBankSort;
      DestName   := Bacs_Safe(Target.acCompany);
      if (Length(DestName) > 1) and (DestName[1] = '-') then
        DestName[1] := ' ';
      Amount     := Pennies(Transaction.thTotalInvoiced);
      if not IsBlank(Bacs_Safe(Target.acBankRef)) then
        PayDescrip := Bacs_Safe(Target.acBankRef)
      else
        PayDescrip := Transaction.thOurRef + ' ' + IntToStr(ProcControl.PayRun);

      ContraRec.PTotal := ContraRec.PTotal + Amount;
      TotalPenceWritten := TotalPenceWritten + Amount;
      ThisFilePenceWritten := ThisFilePenceWritten + Amount;
    end;
    inc(TransactionsWritten);
    ContraRec.PCount := PayCount;
    inc(PayCount);
    if PayCount > MaxPayLines then
    begin
      Result := WriteBatch(EventData);
    end;
  end; {with}
end;

function THexagonExportObject.WriteData(const EventData : TAbsEnterpriseSystem): boolean;
var
  OutString : string;
  i : integer;
begin
{$I-}
  with HeaderRec do
  begin
    Count := 1;
    TotalValue := ThisFilePenceWritten;

    OutString := tagContras + IntToStr(Count) + CR +
                 tagTotal + Pounds(TotalValue) + CR +
                 tagCurrency + Currency + CR;
    Write(OutFile, OutString);
  end;

  with ContraRec do
  begin
    Descript   := 'BACS ' + IntToStr(ProcControl.PayRun);

    OutString := tagStartBalance + CR +
                 tagCoAcc + CoAcc + CR +
                 tagValDate + ValDate + CR +
                 tagDescript + Descript + CR +
                 tagPayCount + IntToStr(PCount) + CR +
                 tagPayTotal + Pounds(PTotal) + CR;
    Write(OutFile, OutString);
  end;
  Result := (IOResult = 0);
  If Result then
  begin
    for i := 1 to ContraRec.PCount do
    begin
      with PayLines[i] do
      begin
        OutString := tagStartPay + CR +
                     tagDestAcc + DestAcc + CR +
                     tagDestSort + DestSort + CR +
                     tagDestName + DestName + CR +
                     tagAmount + Pounds(Amount) + CR +
                     tagPayDescript + PayDescrip + CR +
                     tagEndPay + CR;
        Write(OutFile, OutString);
      end; {with}
    end; {for i}

    Result := (IOResult = 0);
    If Result then
      Write(Outfile, tagEndBalance + CR);
  end;
  ThisFilePenceWritten := 0;
  InitialiseHeader(EventData);
  InitialiseContra(EventData);

end; {writeData}


function THexagonExportObject.GetDate(const ADate : string) : string;
//No longer used
var
  TempString,
  StoreDateFormat    : string;
  StoreDateSeparator : char;
  DateInQuestion : TDateTime;
  i : integer;
begin
{date comes in as yyyymmdd and we need to convert it to a string using windows format
(but can't be more than 6 chars). Let's assume for simplicity that the options in windows
are either dd/mm/yy, dd/mm/yyyy, mm/dd/yy and mm/dd/yyyy. I think that we can reasonably
expect users to use one of these}
  StoreDateFormat := ShortDateFormat;
  StoreDateSeparator := DateSeparator;
  ShortDateFormat := 'dd/mm/yyyy';
  DateSeparator := '/';
  TempString := Copy(ADate, 7, 2) + '/' +
                Copy(ADate, 5, 2) + '/' +
                Copy(ADate, 1, 4);
  Try
    DateInQuestion := StrToDate(TempString);
  Except
    DateInQuestion := 0;
  End;

  ShortDateFormat := StoreDateFormat;
  DateSeparator := StoreDateSeparator;

  if DateInQuestion > 0 then
  begin
    Result := DateToStr(DateInQuestion);

    i := Pos('yyyy', ShortDateFormat);
    if i > 0 then
      Delete(Result, i, 2);

    i := 1;
    while i < Length(Result) do
      if not IsDigit(Result[i]) then
        Delete(Result, i, 1)
      else
        inc(i);

    if Length(Result) <> 6 then
      Result := 'N/A';
  end
  else
    Result := 'N/A';

end;

function THexagonExportObject.ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
  Result := inherited ValidateSystem(EventData);
  InitialiseHeader(EventData);
  InitialiseContra(EventData);
  DeleteOldFiles(EventData);
end;

procedure THexagonExportObject.DeleteOldFiles(const EventData : TAbsEnterpriseSystem);
var
  i : integer;
  ThePath : string;
  FName : string;
begin
  if FOverwriteFiles then
  begin
    ThePath := CheckPath(EventData.Setup.ssDataPath);
    i := 1;
    FName := ThePath + 'Hex' + ZerosAtFront(i, FDigitCount) + Ext;
    while (i <= FMaxFiles) and FileExists(FName) do
    begin
      DeleteFile(FName);
      inc(i);
      FName := ThePath + 'Hex' + ZerosAtFront(i, FDigitCount) + Ext;
    end;
  end;
end;

function THexagonExportObject.CreateOutFile(const AFileName : string;
                                            const EventData :
                                            TAbsEnterpriseSystem) : integer;
var
  FormatStr : string;
begin
  Result := Inherited CreateOutFile(AFileName, EventData);
  if not FOverwriteFiles then
  begin
    FormatStr := ZerosAtFront(ProcControl.PayRun mod 100, 2);
    FPrefix := FPrefix + FormatStr;
    FilePrefix := FilePrefix + FormatStr;
    if FileExists(FilePrefix + '001.dat') then
    begin
      if MessageDlg('File ' +  FilePrefix + '001.dat already exists.' +
                      #10 + 'Cancel batch run?', mtWarning, [mbYes, mbNo], 0) = mrYes then
        Result := 1;
    end;
  end;
end;

procedure THexagonExportObject.ReadIniFile;
var
  s : string;
begin
  with TIniFile.Create(RequiredPath + 'EntHex.ini') do
   Try
     s := UpperCase(ReadString('Files','Overwrite','Y'));
     FOverwriteFiles := s[1] = 'Y';

     FDateFormat := ReadString('Date','Format', 'yyyymmdd');
   Finally
      Free;
   End;
end;

function THexagonExportObject.FormatDate(const ADate: string): String;
//ADate comes in as yyyymmdd. Need to format for output using FDateFormat which is standard format
//string
var
  dd, mm, yy : Word;
  dtDate : TDateTime;
begin
  Try
    yy := StrToInt(Copy(ADate, 1, 4));
    mm := StrToInt(Copy(ADate, 5, 2));
    dd := StrToInt(Copy(ADate, 7, 2));
    dtDate := EncodeDate(yy, mm, dd);
    Result := FormatDateTime(FDateFormat, dtDate);
  Except
    on E: Exception do
      raise Exception.Create('Error when converting date: ' + QuotedStr(E.Message));
  End;
end;

end.
