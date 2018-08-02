unit bacstobj;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Bacs00, CustAbsU, {$IFDEF EX600}Enterprise04_TLB{$ELSE}Enterprise01_TLB{$ENDIF}, ComObj;

type
  TBacstelExportObject = Class(TBacs1Obj)
  private
    FSterling : integer;
    FDataPath : string;
    FToolkit : IToolkit;
    function ConvertToSterling(Value : Double) : Double;
    function ReadSterlingFromIniFile : integer;
  public
    function WriteRec(const EventData : TAbsEnterpriseSystem;
                                 Mode : word) : Boolean; override;
    constructor Create(const DataPath : string);
    destructor Destroy; override;
  end;


var
 BacstelExportObject : TBacstelExportObject;


implementation

uses ExpObj, SysUtils, IniFiles, SecCodes, Dialogs;

const
  {$IFDEF EX600}
  sTkClassName = 'Enterprise04.Toolkit';
  {$ELSE}
  sTkClassName = 'Enterprise01.Toolkit';
  {$ENDIF}


function TBacstelExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                                  Mode : word) : Boolean;
var
  OutRec : BACS1IntRec;
  TempStr : string;
  pence : longint;
  OutString : string;
  Target : TAbsCustomer;
begin
  GetEventData(EventData);
  FillChar(OutRec, SizeOf(OutRec), 32);
  with EventData, OutRec do
  begin

    Target := GetTarget(EventData);

    Case Mode of

   wrContra : begin
                {nothing to do}
                Result := True;
              end;
  wrPayLine : begin
               Str2_Char(Target.acBankSort, DestSort, SizeOf(DestSort));
               Str2_Char(Target.acBankAcc, DestAcc, SizeOf(DestAcc));
               if IsReceipt then
                 TempStr := DirectDebitCode(Target.acDirDebMode)
               else {Payment}
                 TempStr := '99';
               Str2_Char(TempStr, TranCode, SizeOf(TranCode));
               Pence := Pennies(ConvertToSterling(Transaction.thTotalInvoiced));
               TempStr := ZerosAtFront(Pence, SizeOf(AmountP));
               Str2_Char(TempStr, AmountP, SizeOf(AmountP));
               Str2_Char(Bacs_Safe(Target.acCompany), DestName, SizeOf(DestName));
               if not IsBlank(Bacs_Safe(Target.acBankRef)) then
                 TempStr := Bacs_Safe(Target.acBankRef)
               else
                 TempStr := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);
               Str2_Char(TempStr, CompRef, SizeOf(CompRef));
               TotalPenceWritten := TotalPenceWritten + Pence;
               inc(TransactionsWritten);

               {write record here}
               with OutRec do
               begin
                 OutString :=  DESTSort +
                               DESTAcc   +
                               TranCode  +
                               AmountP   +
                               CompRef   +
                               DestName;
               end;
               Result := WriteThisRec(OutString);

             end; {not contra}
    end; {case}


  end; {with}
end;

function TBacstelExportObject.ReadSterlingFromIniFile : integer;
var
  TheIni : TIniFile;
begin
  Result := 1;
  TheIni := TIniFile.Create(FDataPath + 'EBacstel.ini');
  Try
    Result := TheIni.ReadInteger('Currency','Sterling', 1);
  Finally
    TheIni.Free;
  End;
end;

function TBacstelExportObject.ConvertToSterling(Value : Double) : Double;
begin
  if FSterling = 1 then
    Result := Value
  else
  begin
    Result := FToolkit.Functions.entConvertAmount(Value, 1, FSterling, 0);
    Result := FToolkit.Functions.entRound(Result, 2);
  end;
end;

constructor TBacstelExportObject.Create(const DataPath : string);
var
  a, b, c : longint;
  Res : longint;
begin
  inherited Create;
  FToolkit := nil;
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
        FToolkit.Configuration.DataDirectory := FDataPath;
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

destructor TBacstelExportObject.Destroy;
begin
  if Assigned(FToolkit) then
  begin
    if FToolkit.Status = tkOpen then
      FToolkit.CloseToolkit;
    FToolkit := nil;
  end;
  inherited Destroy;
end;




end.
