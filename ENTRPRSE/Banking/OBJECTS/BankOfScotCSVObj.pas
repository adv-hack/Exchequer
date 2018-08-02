unit BankOfScotCSVObj;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


//SS:28/07/2017:2017-R2:ABSEXGENERIC-408:New Plug-in format for Bank of Scotland

interface

{$IFDEF BBM}
  {$H-}
{$ENDIF}


uses
  AibObj, CustAbsU, Aib01, ExpObj,StrUtil;

type
  TBankScotRec = Record
    ImpDate       : String[8];
    BankAcRef     : String[18];
    CompSort      : Array[1..6] of Char; {sort code of user's bank}
    CompAcc       : Array[1..8] of Char; {user's account no}
    DRAcNum       : String[15];
    Amount        : LongInt;
    DestName      : string[18];
    DestAcc       : string[8];
    DestSort      : string[6];
    DestRef       : String[18];
  end;


   TBankScotCSVExportObject = Class(TAibEftObj)
    protected
      function BankScotDate(const ADate : string) : string;
    public
      function WriteRec(const EventData : TAbsEnterpriseSystem;
                            Mode : word) : Boolean; override;
      function CreateOutFile(const AFileName : string; const EventData :TAbsEnterpriseSystem) : integer; override;
      function CloseOutFile : integer; override;   
   end;


implementation

uses
  SysUtils, IniFiles;

const
    Sep = ',';


{ TBankScotCSVExportObject }

function TBankScotCSVExportObject.BankScotDate(const ADate: string): string;
begin
    Result := Copy(ADate, 7, 2) + '/' +
              Copy(ADate, 5, 2) + '/' +
              Copy(ADate, 3, 2);

end;

function TBankScotCSVExportObject.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
var
  OutString : string;
  VAOPath : string;
  LRequiredPath : string;
  OutRec : TBankScotRec;
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


  if Result = 0 then
  begin
  {file should now be open for writing so we can write headers}
{$I-}


    OutString := 'H'   + Sep +
                FormatDateTime('YYYYMMDD',Date) + Sep +
                IntToStr(ProcControl.PayRun);
    WriteLn(OutFile, OutString);


    Result := IOResult;


    //SS:02/08/2017:2017-R2:ABSEXGENERIC-408:New Plug-in format for Bank of Scotland
    //Write Header row.
    FillChar(OutRec, SizeOf(OutRec), 0);
    with EventData, OutRec do
    begin
      ImpDate :=  ProcControl.PDate;

      Str2_Char(UserBankAcc, CompAcc, SizeOf(CompAcc));
      Str2_Char(RemoveHyphens(UserBankSort), CompSort, SizeOf(CompSort));

      BankAcRef := Trim(UserBankRef);

      with OutRec do
      begin
        OutString := 'D'     + Sep +
                     ImpDate + Sep +
                     BankAcRef+ Sep +
                     UserBankSort+'-'+CompAcc;
      end;
      
      WriteThisRec(OutString);
    end;  
  end; {if Result = 0}
{$I+}
end; {CreateOutFile}


function TBankScotCSVExportObject.WriteRec(const EventData: TAbsEnterpriseSystem; Mode: word): Boolean;
var
  Target : TAbsCustomer;
  OutRec : TBankScotRec;
  OutString : string;
  lAmount : Double;
  TempStr : Str255;
begin
  Result := False;
  GetEventData(EventData);
  FillChar(OutRec, SizeOf(OutRec), 0);
  with EventData, OutRec do
  begin
    if IsReceipt then
      Target := Customer
    else
      Target := Supplier;

    Case Mode of
        wrPayLine:
        begin      
          TempStr := Bacs_Safe(Target.acCompany);
          DestName := Trim(TempStr);

          TempStr := Target.acBankAcc;
          DestAcc := Trim(TempStr);

          TempStr := Target.acBankSort;
          DestSort := Trim(TempStr);
            

          if not IsBlank(Bacs_Safe(Target.acBankRef)) then
            DestRef := Bacs_Safe(Target.acBankRef)
          else
            DestRef := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);   

          lAmount := ProcControl.Amount;
          TotalPenceWritten := TotalPenceWritten + Pennies(lAmount);
          inc(TransactionsWritten);

          with OutRec do
          begin
            OutString := 'C'     + Sep +
                         Trim(Format('%.2f', [lAmount])) + Sep +
                         DestName     + Sep +
                         DestAcc      + Sep +
                         DestSort     + Sep +
                         DestRef;

          end;

          Result := WriteThisRec(OutString);
        end;

        wrContra  :
        begin
          {write record here}
           Result := True;   
        end;
      end; {case}
  end;
end;


function TBankScotCSVExportObject.CloseOutFile : integer;
var
  OutString : string;
begin
{$I-}
  with UserTrailer do
  begin
    OutString := 'T';
  end;

  WriteThisRec(OutString);


  CloseFile(OutFile);
  Result := IOResult;
  if Result <> 0 then
    ShowExportMessage('Warning','Unable to close file ' + OutFileName, '');
{$I+}
end;


end.
