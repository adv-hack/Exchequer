unit HobsObj;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

{$IFDEF BBM}
  {$H-}
{$ENDIF}


uses
  AibObj, CustAbsU, Aib01, ExpObj;

type
  TBankScotHobsExportObject = Class(TAibEftObj)
    public
      function WriteRec(const EventData : TAbsEnterpriseSystem;
                            Mode : word) : Boolean; override;
      function CreateOutFile(const AFileName : string;
                                const EventData :
                                TAbsEnterpriseSystem) : integer; override;
      function CloseOutFile : integer; override;


   end;


implementation

uses
  SysUtils, IniFiles;

function TBankScotHobsExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                         Mode : word) : Boolean;
var
  OutRec : TAIBDataRec;
  TempStr : Str255;
  pence : longint;
  OutString : string;
  Target : TAbsCustomer;
begin
  GetEventData(EventData);

  FillChar(OutRec, SizeOf(OutRec), 32);
  with EventData, OutRec do
  begin
    if IsReceipt then
      Target := Customer
    else
      Target := Supplier;

    Case Mode of

   wrContra : begin
               Str2_Char(MakeDigits(UserBankAcc, SizeOf(DestAcc)), DestAcc, SizeOf(DestAcc));
               Str2_Char(MakeDigits(UserBankSort, SizeOf(DestSort)), DestSort, SizeOf(DestSort));
               AccType := '0';
               TranCode := '99';
               Str2_Char(MakeDigits(UserBankAcc, SizeOf(CompAcc)), CompAcc, SizeOf(CompAcc));
               Str2_Char(MakeDigits(UserBankSort, SizeOf(CompSort)), CompSort, SizeOf(CompSort));
               TempStr := '0000';
               Str2_Char(TempStr, Reserved1, SizeOf(Reserved1));
               TempStr := ZerosAtFront(TotalPenceWritten, SizeOf(AmountP));
               Str2_Char(TempStr, AmountP, SizeOf(AmountP));
               TempStr := 'EFT ' + IntToStr(ProcControl.PayRun);
               Str2_Char(TempStr, CompName, SizeOf(CompName));
               TempStr := 'CONTRA';
               Str2_Char(TempStr, CompRef, SizeOf(CompRef));

               //PR: 08/05/2013 ABSEXCH-14200 v7.0.4 HBoS have change format so company name isn't included in contra.
               // Str2_Char(Bacs_Safe(Setup.ssUserName), DestName, SizeOf(DestName));
              end;
  wrPayLine : begin
               Str2_Char(Target.acBankSort, DestSort, SizeOf(DestSort));
               Str2_Char(Target.acBankAcc, DestAcc, SizeOf(DestAcc));
               AccType := '0';
               TempStr := '98';
               Str2_Char(TempStr, TranCode, SizeOf(TranCode));
               Str2_Char(MakeDigits(UserBankAcc, SizeOf(CompAcc)), CompAcc, SizeOf(CompAcc));
               Str2_Char(MakeDigits(UserBankSort, SizeOf(CompSort)), CompSort, SizeOf(CompSort));
               TempStr := '0000';
               Str2_Char(TempStr, Reserved1, SizeOf(Reserved1));
               Pence := Pennies(Transaction.thCurrSettled); //HV 19/05/2016 2016-R2 ABSEXCH-17123 - BANK OF SCOTLAND BACS PLUG IN, Payment Currency conversion issue 
               TempStr := zerosAtFront(Pence, SizeOf(AmountP));
               Str2_Char(TempStr, AmountP, SizeOf(AmountP));
               Str2_Char(Bacs_Safe(Setup.ssUserName), CompName, SizeOf(CompName));

               Str2_Char(Bacs_Safe(Target.acCompany), DestName, SizeOf(DestName));
               if not IsBlank(Bacs_Safe(Target.acBankRef)) then
                 TempStr := Bacs_Safe(Target.acBankRef)
               else
                 TempStr := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);

               Str2_Char(TempStr, CompRef, SizeOf(CompRef));
               TotalPenceWritten := TotalPenceWritten + Pence;
               inc(TransactionsWritten);
             end; {not contra}
    end; {case}


  end; {with}
  {write record here}
  with OutRec do
  begin
    OutString :=  DESTSort +
                  DESTAcc   +
                  AccType +
                  TranCode  +
                  CompSort  +
                  CompAcc   +
                  Reserved1    +
                  AmountP   +
                  CompName  +
                  CompRef   +
                  DestName;
  end;
  Result := WriteThisRec(OutString);
end;


function TBankScotHobsExportObject.CreateOutFile(const AFileName : string;
                                            const EventData :
                                             TAbsEnterpriseSystem) : integer;
var
  OutString : string;
  VAOPath : string;
  LRequiredPath : string;
begin
{$I-}
  GetEventData(EventData);
  IsReceipt := ProcControl.SalesPurch;
  LRequiredPath := CheckPath(EventData.Setup.ssDataPath);
  with TIniFile.Create(LRequiredPath + VAOIniFilename) do
  Try
    VAOPath := CheckPath(ReadString('Paths','Output',''));
  Finally
    Free;
  End;
  OutFileName := AFilename;
  if VAOPath <> '' then
    OutFileName := VAOPath + ExtractFilename(OutFilename);
  AssignFile(OutFile, OutFileName);
  Rewrite(OutFile);
  Result := IOResult;
  if Result <> 0 then
    ShowExportMessage('Warning','Unable to create file ' + AFileName,
                        'This run has been aborted')
  else
    LogIt('File created: ' + AFileName);
{$I+}

  SetHeader(EventData);

  with UserHeader do
    Str2_Char(GetFileNo, FileNo, SizeOf(FileNo));

  if Result = 0 then
  begin
  {file should now be open for writing so we can write headers}
{$I-}

     with UserHeader do
     begin
       OutString := LabelID   +
                    LabelNo   +
                    ProcDate;
       WriteLn(OutFile, OutString);
     end; {with UserHeader}
     Result := IOResult;
  end; {if Result = 0}
{$I+}
end; {CreateOutFile}


function TBankScotHobsExportObject.CloseOutFile : integer;
var
  TempStr, OutString : string;
begin
{$I-}
  with UserTrailer do
  begin
   if IsReceipt then
   begin
    TempStr := zerosAtFront(TotalPenceWritten, SizeOf(TotalDr));
    Str2_Char(TempStr, TotalDr, SizeOf(TotalDr));
    TempStr := zerosAtFront(TransactionsWritten, SizeOf(CountDr));
    Str2_Char(TempStr, CountDr, SizeOf(CountDr));
    TempStr := zerosAtFront(TotalPenceWritten, SizeOf(TotalCr));
    Str2_Char(TempStr, TotalCr, SizeOf(TotalCr));
    TempStr := zerosAtFront(1, SizeOf(CountCr));
    Str2_Char(TempStr, CountCr, SizeOf(CountCr));
   end
   else {payment}
   begin
    TempStr := zerosAtFront(TotalPenceWritten, SizeOf(TotalDr));
    Str2_Char(TempStr, TotalDr, SizeOf(TotalDr));
    TempStr := zerosAtFront(1, SizeOf(CountDr));
    Str2_Char(TempStr, CountDr, SizeOf(CountDr));
    TempStr := zerosAtFront(TotalPenceWritten, SizeOf(TotalCr));
    Str2_Char(TempStr, TotalCr, SizeOf(TotalCr));
    TempStr := zerosAtFront(TransactionsWritten, SizeOf(CountCr));
    Str2_Char(TempStr, CountCr, SizeOf(CountCr));
   end;

    OutString := LabelID +
                 LabelNo +
                 TotalDr +
                 TotalCr +
                 CountDr +
                 CountCr;
  end;

  WriteThisRec(OutString);


  CloseFile(OutFile);
  Result := IOResult;
  if Result <> 0 then
    ShowExportMessage('Warning','Unable to close file ' + OutFileName, '');
{$I+}
end;


end.
