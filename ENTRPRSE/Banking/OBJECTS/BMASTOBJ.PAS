unit BMastObj;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  CustAbsU, MultiObj, BacNcObj, Bacs00, {$IFDEF EX600}Enterprise04_TLB{$ELSE}Enterprise01_TLB{$ENDIF}, ComObj, Dialogs;

const
  MaxLines = 999;
  MaxOutFiles = 99999;
  DefaultExt = '.txt';

type
  TBusinessMasterExportObject = Class(TMultiFileExportObject)
    private
      FToolkit : IToolkit;
      FSterling : integer;
      FDataPath : string;
    protected
      PayRecs    : Array[1..MaxOutFiles] of BACS1IntRec;
      OldPayCount : integer;
      function WriteData(const EventData : TAbsEnterpriseSystem) : Boolean; override;
      function ConvertToSterling(Value : Double) : Double;
      function ReadSterlingFromIniFile : integer;
    public
      constructor Create(const DataPath : string);
      destructor Destroy; override;
      function WriteRec(const EventData : TAbsEnterpriseSystem;
                                Mode : word) : Boolean; override;
    end;


implementation

uses
  ExpObj, SysUtils, IniFiles, SecCodes;

const
  {$IFDEF EX600}
  sTkClassName = 'Enterprise04.Toolkit';
  {$ELSE}
  sTkClassName = 'Enterprise01.Toolkit';
  {$ENDIF}


constructor TBusinessMasterExportObject.Create(const DataPath : string);
var
  a, b, c : longint;
  Res : longint;
begin
  inherited Create;
  FToolkit := nil;
  RecsPerFile := MaxLines;
  FMaxFiles := MaxOutFiles;
  Ext := DefaultExt;
  PayCount := 1;
  FDataPath := DataPath;
  FSterling := ReadSterlingFromIniFile;
  if FSterling <> 1 then
  begin
    FToolkit := CreateOLEObject(sTkClassName) as IToolkit;
    if FToolkit.Enterprise.enCurrencyVersion <> enProfessional then
    begin
      if Assigned(FToolkit) then
      begin
        EncodeOpCode(97, a, b, c);
        FToolkit.Configuration.SetDebugMode(a, b, c);
        Res := FToolkit.OpenToolkit;
        if Res <> 0 then
          ShowMessage('Error opening COM Toolkit:'#13#13 +
                       QuotedStr(FToolkit.LastErrorString));
      end
      else
        ShowMessage('Unable to create COM Toolkit');
    end
    else
      FSterling := 1;
  end;
end;

destructor TBusinessMasterExportObject.Destroy;
begin
  if Assigned(FToolkit) then
  begin
    if FToolkit.Status = tkOpen then
      FToolkit.CloseToolkit;
    FToolkit := nil;
  end;
  inherited Destroy;
end;

function TBusinessMasterExportObject.ReadSterlingFromIniFile : integer;
var
  TheIni : TIniFile;
begin
  Result := 1;
  TheIni := TIniFile.Create(FDataPath + 'EntBMast.ini');
  Try
    Result := TheIni.ReadInteger('Currency','Sterling', 1);
  Finally
    TheIni.Free;
  End;
end;

function TBusinessMasterExportObject.ConvertToSterling(Value : Double) : Double;
begin
  if FSterling = 1 then
    Result := Value
  else
  begin
    Result := FToolkit.Functions.entConvertAmount(Value, 1, FSterling, 0);
    Result := FToolkit.Functions.entRound(Result, 2);
  end;
end;


function TBusinessMasterExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                     Mode : word) : Boolean;
var
  Target : TAbsCustomer;
  TempStr : string;
  Pence : longint;
begin
  Result := True;
  Target := GetTarget(EventData);
  if Mode = wrContra then
  begin
    if OldPayCount > 0 then
      Result := WriteBatch(EventData);
  end
  else
  begin
    with EventData, PayRecs[PayCount] do
    begin
               Str2_Char(Target.acBankSort, DestSort, SizeOf(DestSort));
               Str2_Char(Target.acBankAcc, DestAcc, SizeOf(DestAcc));
               ZFill1 := '0';
               if IsReceipt then
                 TempStr := DirectDebitCode(Target.acDirDebMode)
               else {Payment}
                 TempStr := '99';
               Str2_Char(TempStr, TranCode, SizeOf(TranCode));
               Str2_Char(MakeDigits(UserBankAcc, SizeOf(CompAcc)), CompAcc, SizeOf(CompAcc));
               Str2_Char(MakeDigits(UserBankSort, SizeOf(CompSort)), CompSort, SizeOf(CompSort));
               TempStr := '0000';
               Str2_Char(TempStr, ZFill2, SizeOf(ZFill2));
               Pence := Pennies(ConvertToSterling(Transaction.thTotalInvoiced));
               TempStr := ZerosAtFront(Pence, SizeOf(AmountP));
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
    end;
    OldPayCount := PayCount;
    inc(PayCount);
    if PayCount > MaxLines then
    begin
      Result := WriteBatch(EventData);
      PayCount := 1;
      OldPayCount := 0;
    end;
  end; {with}
end;

function TBusinessMasterExportObject.WriteData(const EventData :
                                           TAbsEnterpriseSystem) : Boolean;
var
  i : integer;
  OutString : string;
begin
  Result := True;
  for i := 1 to PayCount - 1 do
  with PayRecs[i] do
  begin
    OutString :=  DESTSort +
                  DESTAcc   +
                  ZFill1 +
                  TranCode  +
                  CompSort  +
                  CompAcc   +
                  ZFill2    +
                  AmountP   +
                  CompName  +
                  CompRef   +
                  DestName;
    Result := WriteThisRec(OutString);
  end;

end;






end.
