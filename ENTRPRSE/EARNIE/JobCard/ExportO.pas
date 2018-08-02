unit ExportO;

interface

uses
  Enterprise01_TLB, ComObj, Classes, JcObj;

const
  TypeHours = 'H';
  TypePayOW = 'A'; //Overwrite
  TypePayAC = 'I'; //Accumulate

  PayTypes = [TypePayOW, TypePayAC];

type
  TProgressProc = procedure (const sMessage : string) of object;

  TJCExportLineObject = Class
  protected
    FPayNo  : string;
    FAcGroup : string;
    FAnalString : string;
    FPeriod : Byte;
    FType : Char;
    FVal : Array[1..3] of String[10];
    function GetVal(Index : Integer) : Double;
    procedure SetVal(Index : Integer; Value : Double);
  public
    function WriteLine(var F : TextFile) : integer;
    property PayNo : string read FPayNo write FPayNo;
    property AcGroup : string read FAcGroup write FAcGroup;
    property AnalString : string read FAnalString write FAnalString;
    property Period : Byte read FPeriod write FPeriod;
    property PayType : Char read FType write FType;

    property Value1 : Double Index 1 read GetVal write SetVal;
    property Value2 : Double Index 2 read GetVal write SetVal;
    property Value3 : Double Index 3 read GetVal write SetVal;

  end;

  TJCExportObject = Class
  private
    FFile : TextFile;
    FFileName : string;
    FToolkit : IToolkit;
    FRangeStart, FRangeEnd : string;
    FYear : Smallint;
    FPeriod : SmallInt;
    FLineObject : TJCExportLineObject;
    ErrFound : Boolean;
    FTransList : TStringList;
    FEmployee : string;
    FWeekMonth : SmallInt;
    FAllowPosted, FUseJobRates, FAllowExported, FUseLineRate,
    FExcludeSubContractors : Boolean;
    FCompanyCode : string;
    FEmpObject : TEmpObject;
    FGotEmployee : Boolean; //Indicates that the toolkit employee object is pointing at the employee
                            // for this timesheet
    FLineTypeFromAnal : Boolean;
    FTimeRate : ITimeRates;
    FOnProgress : TProgressProc;
    FOverwritePayments : Boolean;
    function AlreadyDone : Boolean;
    function GetPayNo : string;
    function GetAccountGroup : string;
    function GetAnalString(LineNo : longint) : string;
    function GetPeriod : Byte;
    function GetType(LineNo : longint) : Char;
    function GetVal1(LineNo : longint) : Double;
    procedure GetVal2And3(LineNo : longint; var V2, V3 : Double);
    function BuildIndex(const s : string) : string;
    function CheckTrans : Boolean;
    function IncludeThisTrans : Boolean;
//    function GetJobRate(const oJob : IJob; const TRate : string; var v2, v3 : Double) : Boolean;
    function GetLineRate(const oLine : ITransactionLine; var v2, v3 : Double) : Boolean;
    function GetEmployee(const EmpCode : string) : Boolean;
    function GetTimeRate(const RateCode : string) : Boolean;
    function GetOverwritePayments: Boolean;
    procedure SetOverwritePayments(const Value: Boolean);
    function TypePay : Char;
  public
    constructor Create(const FName : string);
    destructor Destroy; override;
    function Write : Boolean;
    procedure UpdateTimeSheets;
    property Toolkit : IToolkit read FToolkit write FToolkit;
    property RangeStart : string read FRangeStart write FRangeStart;
    property RangeEnd : string read FRangeEnd write FRangeEnd;
    property Year : SmallInt read FYear write FYear;
    property Period : Smallint read FPeriod write FPeriod;
    property Filename : string read FFilename write FFilename;
    property Employee : string read FEmployee write FEmployee;
    property WeekMonth : SmallInt read FWeekMonth write FWeekMonth;
    property AllowPosted : Boolean read FAllowPosted write FAllowPosted;
    property EmpObject : TEmpObject read FEmpObject write FEmpObject;
    property CompanyCode : string read FCompanyCode write FCompanyCode;
    property UseLineRate : Boolean read FUseLineRate write FUseLineRate;
    property AllowExported : Boolean read FAllowExported write FAllowExported;
    property ExcludeSubContractors : Boolean Read FExcludeSubContractors write FExcludeSubContractors;
    property LineTypeFromAnal : Boolean read FLineTypeFromAnal write FLineTypeFromAnal;
    property OnProgress : TProgressProc read FOnProgress write FOnProgress;
    property OverwritePayments : Boolean read GetOverwritePayments write SetOverwritePayments;
  end;

var
  ExportObject : TJCExportObject;


implementation

uses
  SysUtils, LogO, JCFuncs, BtrvU2;


function TJCExportLineObject.GetVal(Index : Integer) : Double;
begin
  Try
    Result := StrToFloat(Trim(FVal[Index]));
  Except
    Result := 0;
  End;

end;

procedure TJCExportLineObject.SetVal(Index : Integer; Value : Double);
var
  s : string;
begin
  if Index = 1 then
  begin
    Value := Value * 100;
    s := IntToStr(Round(Value));
  end
  else
  if Index = 2 then
  begin
    if FType in PayTypes then
      s := Format('%8.2f', [Value])
    else
      s := IntToStr(Trunc(Value));
  end
  else
    s := IntToStr(Trunc(Value));
//  FVal[Index] := StringOfChar(' ', 10 - Length(s)) + s;
  FVal[Index] := Copy(s + StringOfChar(' ', 10), 1, 10);
end;

function TJCExportLineObject.WriteLine(var F : TextFile) : integer;
var
  s : string;
begin
  s := FPayNo + ',' +
       LJVar(FAcGroup, 25) +
       LJVar(FAnalString, 100) +
       ZerosAtFront(FPeriod, 2) +
       FType + FVal[1] + FVal[2] + FVal[3];
{$I-}
  WriteLn(F, s);
  Result := IOResult;
{$I+}
end;

//===============================================================================

constructor TJCExportObject.Create(const FName : string);
begin
  inherited Create;
  FOverwritePayments := True;
  FLineObject := TJCExportLineObject.Create;
  FTransList := TStringList.Create;
  FFileName := FName;
  AssignFile(FFile, FFileName);
  Rewrite(FFile);
end;

destructor TJCExportObject.Destroy;
begin
  FTransList.Free;
  FLineObject.Free;
  CloseFile(FFile);
  inherited Destroy;
end;

function TJCExportObject.Write : Boolean;
var
  Res, Res2 : longint;
  i : longint;
  V2, V3 : Double;
  KeyS : string;
begin
  ErrFound := False;
  with FToolkit do
  begin
    if FPeriod = 0 then
      Transaction.Index := thIdxOurRef
    else
      Transaction.Index := thIdxYearPeriod;


    Res := Transaction.GetGreaterThanOrEqual(BuildIndex(FRangeStart));

    while (Res = 0) and (CheckTrans) do
    begin
      if not AlreadyDone and (Transaction.thDocType = dtTSH) then
      begin
        FLineObject.Period := GetPeriod;

        if IncludeThisTrans then
        begin
          if Assigned(FOnProgress) then
            FOnProgress('Processing ' + Transaction.thOurRef + '...');
          FLineObject.PayNo := GetPayNo;
          FLineObject.AcGroup := GetAccountGroup;
          for i := 1 to Transaction.thLines.thLineCount do
          begin
            FLineObject.AnalString := GetAnalString(i);
            FLineObject.PayType := GetType(i);
            FLineObject.Value1 := GetVal1(i);
            GetVal2And3(i, V2, V3);
            FLineObject.Value2 := V2;
            FLineObject.Value3 := V3;

            if not ErrFound then
            begin
              Res2 := FLineObject.WriteLine(FFile);
              if Res2 = 0 then
                FTransList.Add(Transaction.thOurRef)
              else
              begin
                TheLog.Logit(Transaction.thOurRef + ': IO Error ' + IntToStr(Res2) + ' writing line.');
                ErrFound := True;
              end; //res2 <> 0
            end; //not ErrFound
          end; //for i
        end; //IncludeThisTrans
      end; //not AlreadyDone
      Res := Transaction.GetNext;
    end; //While res = 0
  end; //with FToolkit
  Result := not ErrFound;
  if Result then
    UpdateTimeSheets;
end;

function TJCExportObject.AlreadyDone : Boolean;
begin
  Result := not FAllowExported;
  if Result then
    with FToolkit.Transaction as ITransaction3 do
      Result := thExported;
end;

function TJCExportObject.GetPayNo : string;
var
  Res : longint;
  ECode : string;
begin
  with FToolkit do
  begin

    with JobCosting do
    begin
      if FGotEmployee then
        Res := 0
      else
      begin
        with Transaction as ITransaction2 do
          ECode := thAsTSH.ttEmployee;
        Employee.Index := emIdxCode;
        Res := Employee.GetEqual(Employee.BuildCodeIndex(ECode));
      end;

      if Res = 0 then
      begin
        Result := Employee.emPayrollNumber;
        if (Trim(Result) = '0') or (Trim(Result) = '') then
        begin
          ErrFound := True;
          TheLog.Logit(Transaction.thOurRef + ': Blank Payroll No for ' + Employee.emCode);
        end;
      end
      else
      begin
        ErrFound := True;
        TheLog.Logit(Transaction.thOurRef + ': Employee ' + Employee.emCode + ' not found');
      end;
    end;
  end;
end;

function TJCExportObject.GetAccountGroup : string;
var
  Res : integer;
begin
  FEmpObject.Index := 0;
  Res := FEmpObject.FindRec(LJVar(FCompanyCode, 6) + FToolkit.Transaction.thEmployeeCode, B_GetEq);
  if Res = 0 then
    Result := Trim(FEmpObject.AccGroup);

  if Result = '' then
  begin
    TheLog.Logit('No account group found for Employee ' + FToolkit.Transaction.thEmployeeCode);
    ErrFound := True;
  end;
end;

function TJCExportObject.GetAnalString(LineNo : longint) : string;

  function Delimit(const s : string; LastOne : Boolean = False) : string;
  begin
    Result := Trim(s);
    if not LastOne then
      Result := Result + '\';
  end;

begin
  with FToolkit do
  begin
    Result := Delimit(Transaction.thLines[LineNo].tlCostCentre) +
              Delimit(Transaction.thLines[LineNo].tlDepartment) +
              Delimit(Transaction.thLines[LineNo].tlJobCode)+
              Delimit(Transaction.thLines[LineNo].tlAnalysisCode, True);
  end;
end;

function TJCExportObject.GetPeriod : Byte;
begin
  Result := (FToolkit.Transaction as ITransaction2).thAsTSH.ttWeekMonth;
  if Result = 0 then
  begin
    TheLog.LogIt('No Week/Month number for transaction ' + FToolkit.Transaction.thOurRef);
    ErrFound := True;
  end;
end;

function TJCExportObject.GetType(LineNo : longint) : Char;
var
  Res : longint;
  RatePayrollCode, AnalPayrollCode : Byte;
  FoundRate : Boolean;
  AnalCode, RateCode : String;
begin
  if FLineTypeFromAnal then
  begin
    GetTimeRate(RateCode);
  //Old style - depends on Analysis Type - Labour = hours
    if FToolkit.Transaction.thLines[LineNo].tlAnalyisCodeI.anType = anTypeLabour then
      Result := TypeHours
    else
      Result := TypePay;
  end
  else
  begin
    //New style, courtesy of Fiona - check Rate & Analysis Code for PayRoll Code
    with FToolkit.Transaction.thLines[LineNo].tlAnalyisCodeI as IJobAnalysis3 do
    begin
      AnalCode := anCode;
      AnalPayrollCode := StrToIntDef(anPayrollCode, 0);

    end;
    RateCode := ITransactionLine2(FToolkit.Transaction.thLines[LineNo]).tlAsTSH.tltRateCode;
    FoundRate := GetTimeRate(RateCode);
    if FoundRate then
    begin
      RatePayRollCode := FTimeRate.trPayrollCode;

      if (RatePayrollCode > 0) and (AnalPayrollCode = 0) then
        Result := TypeHours
      else
      if (RatePayrollCode = 0) and (AnalPayrollCode > 0) then
        Result := TypePay
      else
      begin
        ErrFound := True;
        if RatePayrollCode + AnalPayrollCode = 0 then
          TheLog.Logit(Format('No payroll code found for TimeRate %s or AnalysisCode %s',
                                [Trim(RateCode), Trim(AnalCode)]))
        else
          TheLog.Logit(Format('Both TimeRate %s and AnalysisCode %s have payroll codes',
                                [Trim(RateCode), Trim(AnalCode)]));
      end;
    end
    else
      TheLog.Logit(Format('Unable to find Time Rate %s', [RateCode]));

  end;
end;

function TJCExportObject.GetVal1(LineNo : longint) : Double;
begin
  if FLineObject.PayType = TypeHours then
    with FToolkit.Transaction.thLines[LineNo] as ITransactionLine2 do
      Result := tlAsTSH.tltHours
  else
  begin
    if Assigned(FToolkit.Transaction.thLines[LineNo].tlAnalyisCodeI) then
    Try
      Result := StrToInt((FToolkit.Transaction.thLines[LineNo].tlAnalyisCodeI as IJobAnalysis3).anPayRollCode);
    Except
      Result := 0;
    End;
    if Result = 0 then
      TheLog.LogIt('No Payroll Code found for Analysis Code ' +
                       Trim(FToolkit.Transaction.thLines[LineNo].tlAnalysisCode));
  end;
  ErrFound := ErrFound or ((Result = 0) and (FLineObject.PayType = TypePay));
//    Result := 0; //Payment/Deduction number in payroll - in utility or Ent Analysis
end;

procedure TJCExportObject.GetVal2And3(LineNo : longint; var V2, V3 : Double);
var
  Res : longint;
  TRate : string;
begin
  V2 := 0;
  V3 := 0;

  if FLineObject.PayType = TypeHours then
  begin
    with FToolkit.Transaction.thLines[LineNo] as ITransactionLine2 do
      TRate := tlAsTSH.tltRateCode;

    with FToolkit, JobCosting do
    begin
//      if not GetJobRate(FToolkit.Transaction.thLines[LineNo].tlJobCodeI, TRate,  v2, v3) then
      if not GetLineRate(FToolkit.Transaction.thLines[LineNo], v2, v3) then
      begin
        if GetTimeRate(TRate) then
        begin
          V2 := FTimeRate.trPayRate;
          V3 := FTimeRate.trPayFactor;
        end;
{        Res := Employee.emTimeRates.GetEqual(TRate);
        if Res = 0 then
        begin // have employee rates
          V2 := Employee.emTimeRates.trPayRate;
          V3 := Employee.emTimeRates.trPayFactor;
        end
        else
        begin //no employee rates - can we use global?
          if Employee.emOwnTimeRatesOnly then
          begin
            ErrFound := True;
            TheLog.Logit(Transaction.thOurRef + ': Time rate ' + TRate + ' not found for '
                                                + Employee.emCode);
          end
          else //Check global rates
          begin
            Res := TimeRates.GetEqual(TRate);
            if Res = 0 then
            begin
              V2 := TimeRates.trPayRate;

              V3 := TimeRates.trPayFactor;
            end
            else
            begin
              ErrFound := True;
              TheLog.Logit(Transaction.thOurRef + ': Global Time Rate ' + TRate + ' not found');
            end;
          end; //not owntimerates only
        end; // }
      end; // not GetLineRates
      if V2 = 0 then
         TheLog.Logit(Transaction.thOurRef + ': No PayRate found for ' + TRate);

      if V3 = 0 then
        TheLog.Logit(Transaction.thOurRef + ': No PayFactor found for ' + TRate);

      ErrFound := ErrFound or (V2 = 0) or (V3 = 0);

    end;//with
  end //Hours
  else
  begin //Adjustment
    V2 := FToolkit.Transaction.thLines[LineNo].tlNetValue * FToolkit.Transaction.thLines[LineNo].tlQty;
    V3 := 0;
  end;




end;

procedure TJCExportObject.UpdateTimeSheets;
var
  Res, i : longint;
  oTrans : ITransaction3;
begin
  with FToolkit do
  begin
    Transaction.Index := thIdxOurRef;
    for i := 0 to FTransList.Count - 1 do
    begin

      Res := Transaction.GetEqual(Transaction.BuildOurRefIndex(FTransList[i]));
      if Res = 0 then
      begin
        oTrans := (Transaction as ITransaction3).UpdateEx(umDefault) as ITransaction3;
        oTrans.thExported := True;
        Res := oTrans.Save(False);
        if Res <> 0 then
          TheLog.Logit(Transaction.thOurRef + ': Error saving Transaction ' +
                            QuotedStr(LastErrorString));

      end
      else
        raise Exception.Create('Unable to update Export flag on Transaction ' + FTransList[i]);
    end;
  end;
end;

function TJCExportObject.BuildIndex(const s : string) : string;
begin
  Case FToolkit.Transaction.Index of
    thIdxOurRef  :  Result := FToolkit.Transaction.BuildOurRefIndex(s);
    thIdxYearPeriod : Result := FToolkit.Transaction.BuildYearPeriodIndex(FYear, FPeriod);
  end;
end;

function TJCExportObject.CheckTrans : Boolean;
begin
  Case FToolkit.Transaction.Index of
    thIdxOurRef : Result := FToolkit.Transaction.thOurRef <= FRangeEnd;
    thIdxYearPeriod : Result := (FToolkit.Transaction.thPeriod = FPeriod) and
                               (FToolkit.Transaction.thYear = FYear);
  end;
end;

function TJCExportObject.IncludeThisTrans : Boolean;
begin
  Result := FToolkit.Transaction.thDocType = dtTSH;
  if Result then
  begin

    FGotEmployee := GetEmployee((FToolkit.Transaction as ITransaction2).thAsTSH.ttEmployee);
    if FGotEmployee then
      Result := Result and ((FToolkit.JobCosting.Employee.emType <> emTypeSubContract) or
                             not FExcludeSubContractors);
    if FEmployee <> '' then
      Result := Result and (FEmployee = FToolkit.Transaction.thEmployeeCode);
    if FWeekMonth <> -1 then
      Result := Result and (FWeekMonth = (FToolkit.Transaction as ITransaction2).thAsTSH.ttWeekMonth);
      //PR: 25/03/2009 Was allowing negative run no - wrong!!
    Result := Result and (FAllowPosted or (FToolkit.Transaction.thRunNo >= 0));
  end;
end;


{function TJCExportObject.GetJobRate(const oJob: IJob;
                                    const TRate : string;
                                    var v2, v3  : Double): Boolean;
var
  Res : Integer;
  Found : Boolean;
begin
  Result := False;
  v2 := 0;
  v3 := 0;
  if FUseJobRates and Assigned(oJob) then
  with oJob as IJob3 do
  begin
    Found := False;
    Res := jrTimeRates.GetGreaterThanOrEqual(TRate);
    while (Res = 0) and not Found do
    begin
      Found := (Trim(jrTimeRates.trRateCode) = Trim(TRate)) and
        (Trim(jrTimeRates.trEmployeeCode) = Trim(oJob.jrCode));
      if Found then
      begin
        Result := True;
        v2 := jrTimeRates.trPayrollCode;
        v3 := jrTimeRates.trTimeCost * 10000;
        FLineObject.PayType := 'R'; //manual rate
      end
      else
        Res := jrTimeRates.GetNext;
    end;
  end;
end;}

function TJCExportObject.GetLineRate(const oLine: ITransactionLine; var v2,
  v3: Double): Boolean;
var
  GotPayroll, Found : Boolean;
  oJob : IJob3;
  Res : Integer;
  TRate : string;
begin
  Result := False;
  GotPayRoll := False;
  if FUseLineRate and Assigned(oLine) then
  begin
    Result := True;
    FLineObject.PayType := 'R'; //manual rate
//    V3 := (oLine as ITransactionLine2).tlAsTSH.tltCostPerHour * 10000;
    V3 := FToolkit.Functions.entRound((oLine as ITransactionLine2).tlAsTSH.tltCostPerHour,
                                       FToolkit.SystemSetup.ssCostDecimals) * 10000;
    oJob := oLine.tlJobCodeI as IJob3;
    TRate := (oLine as ITransactionLine2).tlAsTSH.tltRateCode;
    if Assigned(oJob) then
    with oJob do
    begin
      Found := False;
      Res := jrTimeRates.GetGreaterThanOrEqual(TRate);
      while (Res = 0) and not Found do
      begin //Take Payroll code first from Job then from Employee
        Found := (Trim(jrTimeRates.trRateCode) = Trim(TRate)) and
          (Trim(jrTimeRates.trEmployeeCode) = Trim(oJob.jrCode));
        if Found then
        begin
          v2 := jrTimeRates.trPayrollCode;
        end
        else
          Res := jrTimeRates.GetNext;
      end;

      if not Found then
      with FToolkit, JobCosting do
      begin
        Res := Employee.emTimeRates.GetEqual(TRate);
        if Res = 0 then
        begin // have employee rates
          V2 := Employee.emTimeRates.trPayRate;
        end
        else
        begin //no employee rates - use global?
          Res := TimeRates.GetEqual(TRate);
          if Res = 0 then
          begin
            V2 := TimeRates.trPayRate;

          end
          else
          begin
            ErrFound := True;
            TheLog.Logit(Transaction.thOurRef + ': Global Time Rate ' + TRate + ' not found');
          end;
        end; // Res <> 0
      end;
    end;
  end;
end;

function TJCExportObject.GetEmployee(const EmpCode : string) : Boolean;
var
  Res : Integer;
begin
  with FToolkit.JobCosting do
  begin
    Employee.Index := emIdxCode;
    Res := Employee.GetEqual(Employee.BuildCodeIndex(EmpCode));
    Result := Res = 0;
  end;
end;

function TJCExportObject.GetTimeRate(const RateCode: string): Boolean;
var
  RateRule : TTimeRateRulesType;

  //Each of these 3 functions searches for the appropriate timerate and, if successful, stores
  //it in FTimeRate
  function GetEmployeeRate : Boolean;
  begin
    with FToolkit.JobCosting.Employee.emTimeRates do
    begin
      Result := GetEqual(RateCode) = 0;
      if Result then
        FTimeRate := FToolkit.JobCosting.Employee.emTimeRates;
    end;
  end;

  function GetJobRate : Boolean;
  begin
    with (FToolkit.JobCosting.Job as IJob3).jrTimeRates do
    begin
      Result := GetEqual(RateCode) = 0;
      if Result then
        FTimeRate := (FToolkit.JobCosting.Job as IJob3).jrTimeRates;
    end;
  end;

  function GetGlobalRate : Boolean;
  begin
    with FToolkit.JobCosting.TimeRates do
    begin
      Result := GetEqual(RateCode) = 0;
      if Result then
        FTimeRate := FToolkit.JobCosting.TimeRates;
    end;
  end;

begin
  FTimeRate := nil;
  Result := False;
  with FToolkit.JobCosting.Employee as IEmployee4 do
  begin
    Case emTimeRateRules of
      trGlobalOwnJob : begin
                         Result := GetEmployeeRate;
                         if not Result then
                           Result := GetJobRate;
                         if not Result then
                           Result := GetGlobalRate;
                       end;
      trOwnOnly      : Result := GetEmployeeRate;
      trGlobalJobOwn : begin
                         Result := GetJobRate;
                         if not Result then
                           Result := GetEmployeeRate;
                         if not Result then
                           Result := GetGlobalRate;
                       end;
      trJobOnly      : Result := GetJobRate;
    end; //Case
  end;
end;

function TJCExportObject.GetOverwritePayments: Boolean;
begin
  Result := FOverwritePayments;
end;

procedure TJCExportObject.SetOverwritePayments(const Value: Boolean);
begin
  FOverwritePayments := Value;
end;

function TJCExportObject.TypePay: Char;
begin
  if FOverwritePayments then
    Result := TypePayOW //Overwrites existing payments
  else
    Result := TypePayAC; //Accumulates payments
end;

end.

