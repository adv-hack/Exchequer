unit HsbcIrelandObj;

interface

uses
  BankIObj, Aib01, CustAbsU, ExpObj;

type

  THSBCIrelandExportObject = Class(TBankIrExportObject)
  protected
    function GetIniFileName : string; override;
    function WriteRec(const EventData : TAbsEnterpriseSystem;
                         Mode : word) : Boolean; override;
  public
    function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    procedure ReadIniFile(const EventData : TAbsEnterpriseSystem); override;
    procedure SetHeader(const EventData : TAbsEnterpriseSystem); override;

  end;

implementation

uses
  SysUtils, IniFiles;

const
  HSBCIrelandIniFilename = 'HSBCIreland.ini';

{ THSBCIrelandExportObject }

function THSBCIrelandExportObject.GetIniFileName: string;
begin
  EFTIniFile := HSBCIrelandIniFilename;
end;

procedure THSBCIrelandExportObject.ReadIniFile(
  const EventData: TAbsEnterpriseSystem);
begin
  with TIniFile.Create(CheckPath(EventData.Setup.ssDataPath) + HSBCIrelandIniFilename) do
  Try
     if IsReceipt then
       EFTRec.UserID := ReadString('EFT','RecUserID','')
     else
       EFTRec.UserID := ReadString('EFT','UserID','');
  Finally
    Free;
  End;

end;

procedure THSBCIrelandExportObject.SetHeader(
  const EventData: TAbsEnterpriseSystem);
var
  TempString, DateString : String;
  TempInt : longint;
begin
  GetEventData(EventData);
  inherited SetHeader(EventData);
  with EventData do
  begin
    with FileHeader do
    begin
      NA1 := '00000000000000000';   //17 zeros
      Str2_Char(FormatDateTime('yymmdd', SysUtils.Date), CreateDate, SizeOf(CreateDate));
    end;

    with UserHeader do
    begin
      ReceiverID := '00';
//      Filler1 := '0000';
      Filler2[40] := ' '; {replace '.' with space}
    end;

(*    with UserTrailer do
    begin
      Filler1[36] := ' '; {replace '.' with space}
    end;
  *)
  end;
end;


function THSBCIrelandExportObject.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
begin
  if Length(UserBankAcc) <> 12 then
    UserBankAcc := UserBankRef;

  Result := Length(UserBankAcc) = 12;

  if not Result then
    Failed := flBank;
end;

function THSBCIrelandExportObject.WriteRec(
  const EventData: TAbsEnterpriseSystem; Mode: word): Boolean;
var
  OutRec : TAIBDataRec;
  TempStr : String[255];
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
               //For HSBC needs to be a 12 digit account no + 2 spaces
               Str2_Char(LJVar(UserBankAcc, 14), DestSort, 14);
               AccType := '0';
               if IsReceipt then
                 TranCode := '99'
               else
                 TranCode := '17';
               //For HSBC needs to be a 12 digit account no + 2 spaces
               Str2_Char(LJVar(UserBankAcc, 14), CompSort, 14);
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

               //For HSBC needs to be a 12 digit account no + 2 spaces
               Str2_Char(LJVar(UserBankAcc, 14), CompSort, 14);
               TempStr := '0000';
               Str2_Char(TempStr, Reserved1, SizeOf(Reserved1));
               Pence := Pennies(ProcControl.Amount);
               TempStr := zerosAtFront(Pence, SizeOf(AmountP));
               Str2_Char(TempStr, AmountP, SizeOf(AmountP));
               Str2_Char(Bacs_Safe(Setup.ssUserName), CompName, SizeOf(CompName));

               Str2_Char(Bacs_Safe(Target.acCompany), DestName, SizeOf(DestName));
               TempStr := Transaction.thOurRef;
               if Trim(Transaction.thYourRef) <> '' then
                 TempStr := TempStr + '/' + Transaction.thYourRef;

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
