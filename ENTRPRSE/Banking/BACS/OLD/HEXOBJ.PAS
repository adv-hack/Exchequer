unit HexObj;
{This format is slightly more complex to deal with than usual export formats.  The file
header has to have the count and total of transactions which we don't yet have when we
write the header.  The simplest way to do this is to write the transactions into a temporary
file, then write the header, then read the transactions from the temporary file and write
them to the output file}

interface

uses
  ExpObj, Hex01, CustAbsU;

type

  THexagonExportObject = Class(TExportObject)
    protected
      HeaderRec    : THexFileHeaderRec;
      ContraRec    : THexBalanceHeader;
      TempFile     : TextFile;
      TempFileName : ShortString;
      FileCount    : integer;
      FilePrefix   : string;
      PayLines     : Array[1..MaxPayLines] of THexPaymentRec;
      PayCount     : Word;
      PayValue     : longint;
      ContraCount  : integer;
      function WriteFinalFile : Boolean;
      procedure InitialiseHeader(const EventData : TAbsEnterpriseSystem);
      procedure InitialiseContra(const EventData : TAbsEnterpriseSystem);
      function WriteBatch : Boolean;
      function NewFiles(const EventData : TAbsEnterpriseSystem) : Boolean;
      function DeleteTempFile : Boolean;
    public
      constructor Create(const EventData : TAbsEnterpriseSystem);
      function CreateOutFile(const AFileName : string;
                             const EventData :
                             TAbsEnterpriseSystem) : integer; override;
      function CloseOutFile : integer; override;
      function WriteRec(const EventData : TAbsEnterpriseSystem;
                           Mode : word) : Boolean; override;
    end;

var
  HexagonExportObject : THexagonExportObject;


implementation

uses
  Classes, SysUtils;

constructor THexagonExportObject.Create(const EventData : TAbsEnterpriseSystem);
begin
  inherited Create;
  FileCount := 0;
  PayCount := 0;
  PayValue := 0;
  ContraCount := 0;
  InitialiseHeader(EventData);
  InitialiseContra(EventData);
end;


function THexagonExportObject.CreateOutFile(const AFileName : string;
                                            const EventData :
                                      TAbsEnterpriseSystem) : integer;
var
  s : string;
begin
  FilePrefix := CheckPath(EventData.Setup.ssDataPath) + Copy(AFilename, 1, 3);
  if NewFiles(EventData) then
    Result := 0
  else
    Result := -1;
end;

function THexagonExportObject.CloseOutFile : integer;
var
  InheritResult : integer;
  OutString : String;
begin
  with HeaderRec do
  begin
    Count := ContraCount;
    TotalValue := TotalPenceWritten;

    OutString := tagContras + IntToStr(Count) + CR +
                 tagTotal + Pounds(TotalValue) +
                 tagCurrency + Currency + CR;
    Write(OutFile, OutString);
  end;

{$I-}
  InheritResult := Inherited CloseOutFile;
  CloseFile(TempFile);
  Result := IOResult;
  if Result <> 0 then
    ShowExportMessage('Warning','Unable to close file ' + TempFileName, '');
{$I+}
  if (Result = 0) and (InheritResult = 0) then
  begin
    if not WriteFinalFile then
      Result := -1;
  end;
end;

function THexagonExportObject.WriteFinalFile : Boolean;
var
  OutStream, TempStream : TFileStream;
begin
  Result := True;
  Try
    OutStream := TFileStream.Create(OutFileName, fmOpenReadWrite);
    Try

      TempStream := TFileStream.Create(TempFilename, fmOpenRead);
      Try
        OutStream.Seek(-1, soFromEnd);
        OutStream.CopyFrom(TempStream, 0);
      Finally
        TempStream.Free;
      End;

    Finally
      OutStream.Free;
    End;
  Except
    ShowExportMessage('Error', 'Unable to create output file', 'Run aborted');
    Result := False;
  End;
  DeleteTempFile;
end;

procedure THexagonExportObject.InitialiseHeader(const EventData : TAbsEnterpriseSystem);
begin
  FillChar(HeaderRec, SizeOf(HeaderRec), 0);
  with HeaderRec do
  begin
    GetEventData(EventData);
    Count       := 0;     {number of payments in file}
    TotalValue  := 0;     {value of all payments}
    if ProcControl.PayCurr[1] <> '£' then  {is there a better way of doing this?}
       Currency := 'EUR'
    else
       Currency := 'GBP';
  end;
end;



function THexagonExportObject.NewFiles(const EventData : TAbsEnterpriseSystem) : Boolean;
{create and open files: FilePrefix + FileCount + Ext & + TempExt. Increment file count}
var
  FName : string;
  FileResult, TempResult : integer;
begin
  FName := FilePrefix + ZeroesAtFront(FileCount, 5);
  FileResult := inherited CreateOutFile(FName + DefaultExt, EventData);
  if FileResult = 0 then
  begin
{$I-}
    TempFileName := FName + TempExt;
    AssignFile(TempFile, TempFilename);
    Rewrite(TempFile);
    TempResult := IOResult;
    if TempResult <> 0 then
      ShowExportMessage('Warning','Unable to create file ' + TempFileName,
                          'This run has been aborted');
{$I+}
  end;
  Inc(FileCount);
  if FileCount > 99999 then
  begin
    ShowExportMessage('Error','Maximum number of files reached', 'Run aborted');
    Result := False;
  end
  else
    Result := (FileResult = 0) and (TempResult = 0);

end;

procedure THexagonExportObject.InitialiseContra(const EventData : TAbsEnterpriseSystem);
begin
  GetEventData(EventData);
  with EventData, ContraRec do
  begin
     CoAcc      := UserBankAcc;
     ValDate    := Copy(ProcControl.PDate, 3, 6);
     Descript   := ''; {until we decide}
     PCount     := 1;
     PTotal     := 0;
  end;
  PayCount := 1;
  PayValue := 0;
  Inc(ContraCount);
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
    Result := WriteBatch;
  end
  else
  begin
    with EventData, PayLines[PayCount] do
    begin
      DestAcc    := Target.acBankAcc;
      DestSort   := Target.acBankSort;
      DestName   := Target.acCompany;
      Amount     := Pennies(Transaction.thTotalInvoiced);
      if not IsBlank(Bacs_Safe(Target.acBankRef)) then
        PayDescrip := Bacs_Safe(Target.acBankRef)
      else
        PayDescrip := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);

      ContraRec.PTotal := ContraRec.PTotal + Amount;
      TotalPenceWritten := TotalPenceWritten + Amount;
    end;
    inc(TransactionsWritten);
    ContraRec.PCount := PayCount;
    inc(PayCount);
    if PayCount >= MaxPayLines then
    begin
      Result := WriteBatch;
      InitialiseContra(EventData);
    end;
  end; {with}
end;

function THexagonExportObject.WriteBatch : Boolean;
var
  OutString : string;
  i : integer;
begin
  with ContraRec do
  begin
    OutString := tagStartBalance + CR +
                 tagCoAcc + CoAcc + CR +
                 tagValDate + ValDate + CR +
                 tagDescript + Descript + CR +
                 tagPayCount + IntToStr(PCount) + CR +
                 tagPayTotal + Pounds(PTotal) + CR;
    Write(TempFile, OutString);
  end;

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
      Write(TempFile, OutString);
    end; {with}
  end; {for i}

  Write(TempFile, tagEndBalance + CR);
end; {write batch}

function THexagonExportObject.DeleteTempFile : Boolean;
begin
  Result := DeleteFile(TempFileName);
end;






end.
