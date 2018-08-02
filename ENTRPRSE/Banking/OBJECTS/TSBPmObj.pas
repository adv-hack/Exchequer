unit TSBPmObj;

interface

uses
  AibObj, Aib01, CustAbsU, ExpObj;

type

  TTSBPermExportObject = Class(TAibEftObj)
  protected
    function GetIniFileName : string; override;
    function WriteRec(const EventData : TAbsEnterpriseSystem;
                         Mode : word) : Boolean; override;
  public
    procedure SetHeader(const EventData : TAbsEnterpriseSystem); override;

  end;

implementation

uses
  SysUtils;
{ TTSBPermExportObject }


function TTSBPermExportObject.GetIniFileName: string;
begin
  EFTIniFile := DefaultTSBPermIniFile;
end;

procedure TTSBPermExportObject.SetHeader(
  const EventData: TAbsEnterpriseSystem);
var
  TempString, DateString : String;
  TempInt : longint;
begin
  GetEventData(EventData);
  inherited SetHeader(EventData);
  with EventData do
  begin
    with VolHeader do
    begin
      Version := '1'; //Label standard version
    end;

    FillChar(FileHeader.FileID4[1], SizeOf(FileHeader) - 14, 0);
    with FileHeader do
    begin
      RecFormat := 'F';
      SectionNo := '01';
      Filler5[17] := ' '; {replace '.' with space}
    end;

    with UserHeader do
    begin
      Str2_Char('95', ReceiverID, SizeOf(ReceiverID));
      Filler2[40] := ' '; {replace '.' with space}
    end;

    with UserTrailer do
    begin
      Filler1[36] := ' '; {replace '.' with space}
    end;

  end;
end;


function TTSBPermExportObject.WriteRec(
  const EventData: TAbsEnterpriseSystem; Mode: word): Boolean;
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
               if IsReceipt then
                 TranCode := '99'
               else
                 TranCode := '17';
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
               Str2_Char(Bacs_Safe(Setup.ssUserName), DestName, SizeOf(DestName));
              end;
  wrPayLine : begin
               Str2_Char(Target.acBankSort, DestSort, SizeOf(DestSort));
               Str2_Char(Target.acBankAcc, DestAcc, SizeOf(DestAcc));
               AccType := '0';
               if IsReceipt then
                 TempStr := DirectDebitCode(Target.acDirDebMode)
               else {Payment}
                 TempStr := '99';
               Str2_Char(TempStr, TranCode, SizeOf(TranCode));
               Str2_Char(MakeDigits(UserBankAcc, SizeOf(CompAcc)), CompAcc, SizeOf(CompAcc));
               Str2_Char(MakeDigits(UserBankSort, SizeOf(CompSort)), CompSort, SizeOf(CompSort));
               TempStr := '0000';
               Str2_Char(TempStr, Reserved1, SizeOf(Reserved1));
               Pence := Pennies(ConvertToOutCurr(ProcControl.Amount));
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

end.
