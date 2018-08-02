unit TEmployeeRateClass;

interface

uses Enterprise01_TLB, CTKUtil, dialogs, sysutils, Contnrs;

type
  TRateCode = class(TObject)
  private
    FDesc: string;
    FRateCode: string;
    FAnalysisCode: string;
    FTimeCharge: double;
    FTimeCost: double;
    FCostCurrency: smallint;
    FChargeCurrency: smallint;
  public
    constructor Create(ARateCode: string; ADesc: string; AnAnalysisCode: string; AChargeCurrency: smallint; ACostCurrency: smallint; ATimeCharge: double; ATimeCost: double);
    property rcRateCode: string read FRateCode write FRateCode;
    property rcDesc: string read FDesc write FDesc;
    property rcAnalysisCode: string read FAnalysisCode write FAnalysisCode;
    property rcChargeCurrency: smallint read FChargeCurrency write FChargeCurrency;
    property rcCostCurrency: smallint read FCostCurrency write FCostCurrency;
    property rcTimeCharge: double read FTimeCharge write FTimeCharge;
    property rcTimeCost: double read FTimeCost write FTimeCost;
  end;


  TEmployeeRate = class(TObject)
  private
    FToolkit: IToolkit;
    FDataPath: string;
//    FTimeCharge: double;
//    FTimeCost: double;
    FTimeRateRules: TTimeRateRulesType;
    FEmpCode: string;
    FJobCode: string;
    FRateCode: string;
    FRateCodes: TObjectList;
    FCurrentRateCode: TRateCode;
    function FindGlobal(FoundRate: boolean): boolean;
    function FindJob(FoundRate: boolean): boolean;
    function FindOwn(FoundRate: boolean): boolean;
  public
    constructor Create;
    destructor Destroy;
    function FindRates(EmpCode: string; JobCode: string; RateCode: string): boolean;
    property CurrentRateCode: TRateCode read FCurrentRateCode;
//    property TimeCharge: double read FTimeCharge;
//    property TimeCost: double read FTimeCost;
    property DataPath: string read FDataPath write FDataPath;
    property RateCodes: TObjectList read FRateCodes;
  end;

implementation

{ TEmployeeRate }

constructor TEmployeeRate.Create;
begin
  inherited;
  FRateCodes := TObjectList.Create;
  FRateCodes.OwnsObjects := true;
end;

destructor TEmployeeRate.Destroy;
begin
  if FRateCodes <> nil then
    FRateCodes.Free;
end;

function TEmployeeRate.FindGlobal(FoundRate: boolean): boolean;  // also pass back the analysis code for the rate ?
var
  res: integer;
begin
  result := FoundRate;
  if FoundRate then EXIT;
  FRateCodes.Clear;
  with FToolkit.JobCosting.TimeRates do begin
    res := GetFirst;
    while res = 0 do begin
      FRateCodes.Add(TRateCode.Create(trRateCode, trDescription, trAnalysisCode, trChargeCurrency, trCostCurrency, trTimeCharge, trTimeCost));
      if trim(trRateCode) = FRateCode then begin
        FCurrentRateCode := TRateCode(FRateCodes[FRateCodes.Count - 1]);
//        FTimeCharge := trTimeCharge;
//        FTimeCost   := trTimeCost;
        result      := true;
//          EXIT;  // since v12 - loop through all rates to populate FRateCodes
      end;
      res := GetNext;
    end;
  end;
end;

function TEmployeeRate.FindJob(FoundRate: boolean): boolean;  // also pass back the analysis code for the rate ?
var
  res: integer;
begin
  result := FoundRate;
  if FoundRate then EXIT;
  FRateCodes.Clear;
  with FToolkit.JobCosting.Job as IJob3 do begin
    index := jrIdxCode;
    res   := GetEqual(BuildCodeIndex(FJobCode));
    if res <> 0 then EXIT;
    with jrTimeRates do begin
      res := GetFirst;
      while res = 0 do begin
        FRateCodes.Add(TRateCode.Create(trRateCode, trDescription, trAnalysisCode, trChargeCurrency, trCostCurrency, trTimeCharge, trTimeCost));
        if trim(trRateCode) = FRateCode then begin
          FCurrentRateCode := TRateCode(FRateCodes[FRateCodes.Count - 1]);
//          FTimeCharge := trTimeCharge;
//          FTimeCost   := trTimeCost;
          result      := true;
//          EXIT;  // since v12 - loop through all rates to populate FRateCodes
        end;
        res := GetNext;
      end;
    end;
  end;
end;

function TEmployeeRate.FindOwn(FoundRate: boolean): boolean;  // also pass back the analysis code for the rate ?
var
  res: integer;
begin
  result := FoundRate;
  if FoundRate then EXIT;
  FRateCodes.Clear;
  with FToolkit.JobCosting.Employee do begin
    index := emIdxCode;
    res := GetEqual(BuildCodeIndex(FEmpCode));
    if res <> 0 then EXIT;
    with emTimeRates do begin
      res := GetFirst;
      while res = 0 do begin
        FRateCodes.Add(TRateCode.Create(trRateCode, trDescription, trAnalysisCode, trChargeCurrency, trCostCurrency, trTimeCharge, trTimeCost));
        if trim(trRateCode) = FRateCode then begin
          FCurrentRateCode := TRateCode(FRateCodes[FRateCodes.Count - 1]);
//          FTimeCharge := trTimeCharge;
//          FTimeCost   := trTimeCost;
          result      := true;
//          EXIT;  // since v12 - loop through all rates to populate FRateCodes
        end;
        res := GetNext;
      end;
    end;
  end;
end;

function TEmployeeRate.FindRates(EmpCode, JobCode, RateCode: string): boolean;
var
  Employee: IEmployee;
  res: integer;
begin
  result := false;
//  FTimeCharge := 0;
//  FTimeCost   := 0;
  FEmpCode    := EmpCode;
  FJobCode    := JobCode;
  FRateCode   := RateCode;
  FCurrentRateCode := nil; // v14
  FToolkit := OpenToolkit(FDataPath, true);
  if FToolkit = nil then EXIT;
  try
    with FToolkit.JobCosting.Employee as IEmployee4 do begin
      index := emIdxCode;
      res   := GetEqual(BuildCodeIndex(EmpCode));
      if res <> 0 then EXIT;
      FTimeRateRules := emTimeRateRules;
      case FTimeRateRules of
        trGlobalOwnJob: result := FindGlobal(FindOwn(FindJob(false)));
        trOwnOnly:      result := FindOwn(false);
        trGlobalJobOwn: result := FindGlobal(FindJob(FindOwn(false)));
        trJobOnly:      result := FindJob(false);
      end;
    end;
  finally
    FToolkit.CloseToolkit;
    FToolkit := nil;
  end;
end;

{ TRateCode }

constructor TRateCode.Create(ARateCode: string; ADesc: string; AnAnalysisCode: string; AChargeCurrency: smallint; ACostCurrency: smallint; ATimeCharge: double; ATimeCost: double);
begin
  inherited Create;
  FRateCode       := ARateCode;
  FDesc           := ADesc;
  FAnalysisCode   := AnAnalysisCode;
  FChargeCurrency := AChargeCurrency;
  FCostCurrency   := ACostCurrency;
  FTimeCharge     := ATimeCharge;
  FTimeCost       := ATimeCost;
end;

end.
