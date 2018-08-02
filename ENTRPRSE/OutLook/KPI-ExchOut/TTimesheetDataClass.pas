unit TTimesheetDataClass;

interface

uses classes, Enterprise01_TLB, CtkUtil, contnrs, SysUtils, dialogs;

type
  TTimesheetLine = class(TObject)
  private
    FHours: double;
    FCostPerHour: double;
    FChargeOutRate: double;
    FRateCode: WideString;
    FUserField2: WideString;
    FCostCentre: WideString;
    FJobCode: WideString;
    FUserField3: WideString;
    FDepartment: WideString;
    FUserField4: WideString;
    FUserField1: WideString;
    FNarrative: WideString;
    FAnalysisCode: WideString;
    FIsNewLine: boolean;
    FMarkedForDeletion: boolean;
    FHoursForDay: array[1..7] of double;
    FDeletionConfirmed: boolean;
    FLineChanged: boolean;
    FExchLineNo: integer;
    FLogicalLineNo: integer;
    FChargeCurrency: smallint;
    FCostCurrency: integer;
    { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
    FUserField5: WideString;
    FUserField6: WideString;
    FUserField7: WideString;
    FUserField8: WideString;
    FUserField9: WideString;
    FUserField10: WideString;
//    FChargeExchangeRate: double;
//    FCostExchangeRate: double;
    procedure DecodeDailyHours;
    procedure SetLineHours(const Value: double);
    function  GetHoursForDay(DayOfWeek: integer): double;
    procedure SetHoursForDay(DayOfWeek: integer; const Value: double);
    function  GetLineDeleted: boolean;
    function  GetUserField3: WideString;
    function  GetUserField4: WideString;
  public
    property AnalysisCode:   WideString read FAnalysisCode   write FAnalysisCode;
    property ChargeOutRate:  double     read FChargeOutRate  write FChargeOutRate;
    property CostCentre:     WideString read FCostCentre     write FCostCentre;
    property CostPerHour:    double     read FCostPerHour    write FCostPerHour;
    property CostCurrency:   integer    read FCostCurrency   write FCostCurrency;
    property Department:     WideString read FDepartment     write FDepartment;
    property Hours:          double     read FHours          write SetLineHours;
    property JobCode:        WideString read FJobCode        write FJobCode;
    property Narrative:      WideString read FNarrative      write FNarrative;
    property RateCode:       WideString read FRateCode       write FRateCode;
    property UserField1:     WideString read FUserField1     write FUserField1;
    property UserField2:     WideString read FUserField2     write FUserField2;
    property UserField3:     WideString read FUserField3     write FUserField3;
    property UserField4:     WideString read FUserField4     write FUserField4;

    { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
    property UserField5:     WideString read FUserField5     write FUserField5;
    property UserField6:     WideString read FUserField6     write FUserField6;
    property UserField7:     WideString read FUserField7     write FUserField7;
    property UserField8:     WideString read FUserField8     write FUserField8;
    property UserField9:     WideString read FUserField9     write FUserField9;
    property UserField10:    WideString read FUserField10    write FUserField10;

    property ExchLineNo:     integer    read FExchLineNo     write FExchLineNo;
    property ChargeCurrency: smallint   read FChargeCurrency write FChargeCurrency;

//    property CostExchangeRate: double   read FCostExchangeRate write FCostExchangeRate;
//    property ChargeExchangeRate: double read FChargeExchangeRate write FChargeExchangeRate;

    property LineChanged: boolean read FLineChanged write FLineChanged;
    property IsNewLine: boolean read FIsNewLine write FIsNewLine;
    property MarkedForDeletion: boolean read FMarkedForDeletion write FMarkedForDeletion;
    property DeletionConfirmed: boolean read FDeletionConfirmed write FDeletionConfirmed;
    property LineDeleted:           boolean read GetLineDeleted;
    property LogicalLineNo: integer  read FLogicalLineNo  write FLogicalLineNo;

    property HoursForDay[DayOfWeek: integer]: double read GetHoursForDay write SetHoursForDay;
  end;

  TTimesheet = class(TObject)
  private
    FWeekMonth: integer;
    FYear: smallint;
    FPeriod: smallint;
    FOurRef: WideString;
    FDescription: WideString;
    FUserField2: WideString;
    FTransDate: WideString;
    FUserField1: WideString;
    FUserField3: WideString;
    FOperator: WideString;
    FUserField4: WideString;
    FEmployee: WideString;
    FTimesheetLines: TObjectList;
    FTimesheetLine: TTimesheetLine;
    FIsNew: boolean;
    FTimesheetChanged: boolean;
    FHoldStatus: smallint;
    FHoldFlag: smallint;
    { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
    FUserField5: WideString;
    FUserField6: WideString;
    FUserField7: WideString;
    FUserField8: WideString;
    FUserField9: WideString;
    FUserField10: WideString;
    // CJS 2013-11-04 - MRD2.6.43 - Support for Transaction Originator
    FOriginator: WideString;
    FCreationDate: WideString;
    FCreationTime: WideString;
    function GetTimesheetLiveLineCount: integer;
    function GetTotalQtyHrs: double;
    function GetTotalCharge: double;
    function GetTimesheetLine(LineNo: integer): TTimesheetLine;
    function GetTotalCost: double;
    function GetTotalHoursForDay(DayOfWeek: integer): double;
    function GetLinesMarkedForDeletion: integer;
    function GetTimesheetRealLineCount: integer;
    function GetTimesheetChanged: boolean;
    function GetLinesDeletedCount: integer;
    function GetHighestExchequerLineNo: integer;
  public
    constructor Create;
    destructor  Destroy; override;
    procedure ApplyDataChanges(ATransaction: ITransaction11);
    function  LocateLogicalLine(ALineNo: integer): TTimesheetLine;
    function  AddNewLine: TTimesheetLine;
    procedure ConfirmLineDeletions;
    property Description: WideString read FDescription write FDescription;
    property Employee:    WideString read FEmployee    write FEmployee;
    property Operator:    WideString read FOperator    write FOperator;
    property OurRef:      WideString read FOurRef      write FOurRef;
    property Period:      smallint   read FPeriod      write FPeriod;
    property TransDate:   WideString read FTransDate   write FTransDate;
    property UserField1:  WideString read FUserField1  write FUserField1;
    property UserField2:  WideString read FUserField2  write FUserField2;
    property UserField3:  WideString read FUserField3  write FUserField3;
    property UserField4:  WideString read FUserField4  write FUserField4;

    { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
    property UserField5:  WideString read FUserField5  write FUserField5;
    property UserField6:  WideString read FUserField6  write FUserField6;
    property UserField7:  WideString read FUserField7  write FUserField7;
    property UserField8:  WideString read FUserField8  write FUserField8;
    property UserField9:  WideString read FUserField9  write FUserField9;
    property UserField10: WideString read FUserField10 write FUserField10;

    property WeekMonth:   integer    read FWeekMonth   write FWeekMonth;
    property Year:        smallint   read FYear        write FYear;
    property HoldStatus:  smallint   read FHoldStatus  write FHoldStatus;
    property HoldFlag:    smallint   read FHoldFlag    write FHoldFlag; // used to preserve the special +32 and +128 values of thHoldFlag if set

    property TimesheetChanged: boolean read GetTimesheetChanged write FTimesheetChanged;
    property CurrentLine: TTimesheetLine read FTimesheetLine;
    property TimesheetLine[LineNo: integer]: TTimesheetLine read GetTimesheetLine;
    property TimesheetLines: TObjectList read FTimesheetLines;
    property TimesheetLiveLineCount: integer read GetTimesheetLiveLineCount; // the number of lines discounting those that are flagged as deleted
    property TimesheetRealLineCount: integer read GetTimesheetRealLineCount; // the number of items in the FTimesheetLines object
    property TotalQtyHrs: double     read GetTotalQtyHrs;
    property TotalCharge: double     read GetTotalCharge;
    property TotalCost:   double     read GetTotalCost;
    property TotalHoursForDay[DayOfWeek: integer]: double read GetTotalHoursForDay;

    property IsNew: boolean read FIsNew write FIsNew;
    property LinesDeletedCount: integer read GetLinesDeletedCount;
    property LinesMarkedForDeletion: integer read GetLinesMarkedForDeletion;

    property HighestExchequerLineNo: integer read GetHighestExchequerLineNo;

    // CJS 2013-11-04 - MRD2.6.43 - Support for Transaction Originator
    property Originator: WideString read FOriginator write FOriginator;
    property CreationDate: WideString read FCreationDate write FCreationDate;
    property CreationTime: WideString read FCreationTime write FCreationTime;
  end;

  TTimesheetData = class(TObject)
  private
    FCopySetTransPeriodByDate: Boolean;
    FDataPath: string;
    FEmployeeID: string;
    FRes: integer;
    FTimesheets: TObjectList;
    FTimesheet: TTimesheet;
    FToolkit: IToolkit;
    FTransaction: ITransaction11;
    FCurrentIx: integer;
    FQtyDecimals: integer;
//    FGlobalPeriod: integer; // F6 period and year
//    FGlobalYear: integer;
    FTHUDF1Desc: WideString;
    FTHUDF2Desc: WideString;
    FTHUDF3Desc: WideString;
    FTHUDF4Desc: WideString;
    FTLUDF1Desc: WideString;
    FTLUDF2Desc: WideString;

    { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
    FTHUDF5Desc: WideString;
    FTHUDF6Desc: WideString;
    FTHUDF7Desc: WideString;
    FTHUDF8Desc: WideString;
    FTHUDF9Desc: WideString;
    FTHUDF10Desc: WideString;
    FTLUDF5Desc: WideString;
    FTLUDF6Desc: WideString;
    FTLUDF7Desc: WideString;
    FTLUDF8Desc: WideString;
    FTLUDF9Desc: WideString;
    FTLUDF10Desc: WideString;

    FUseCCDeps: boolean;
    FLastError: WideString;
    procedure OpenCOMToolkit;
    procedure CloseCOMToolkit;
    procedure CopyTimesheetData;
    procedure DeleteTimesheets;
    function  GetTimesheetCount: integer;
    procedure CopyTimesheetLines(ATimesheet: TTimesheet);
    function  GetEmployeeTotalCharge: double;
    function  GetEmployeeTotalHours: double;
    function  GetEmployeeTotalCost: double;
    // CJS 2013-11-04 - MRD2.6.43 - Support for Transaction Originator
    function GetOriginatorCaption: WideString;
  public
    constructor Create(ADataPath: string; AnEmployeeID: string);
    destructor  Destroy;
    procedure FetchTimeSheetData;
    function  FirstTimesheet: TTimesheet;
    procedure LocateTimesheet(AnOurRef: WideString);
    function  NextTimesheet: TTimesheet;
    function  NewTimesheet: TTimesheet;
    function  SaveTimesheet(var AnOurRef: WideString): integer;
    property  EmployeeID: string read FEmployeeID;
    property  LastError: WideString read FLastError write FLastError;
    property  Timesheet: TTimesheet read FTimesheet write FTimesheet;
    property  TimesheetCount: integer read GetTimesheetCount;
    property  EmployeeTotalCharge: double read GetEmployeeTotalCharge;
    property  EmployeeTotalCost: double read GetEmployeeTotalCost;
    property  EmployeeTotalHours: double read GetEmployeeTotalHours;
    property  QtyDecimals: integer read FQtyDecimals;
    property  THUDF1Desc: WideString read FTHUDF1Desc;
    property  THUDF2Desc: WideString read FTHUDF2Desc;
    property  THUDF3Desc: WideString read FTHUDF3Desc;
    property  THUDF4Desc: WideString read FTHUDF4Desc;
    property  TLUDF1Desc: WideString read FTLUDF1Desc;
    property  TLUDF2Desc: WideString read FTLUDF2Desc;

    { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
    property  THUDF5Desc:  WideString read FTHUDF5Desc;
    property  THUDF6Desc:  WideString read FTHUDF6Desc;
    property  THUDF7Desc:  WideString read FTHUDF7Desc;
    property  THUDF8Desc:  WideString read FTHUDF8Desc;
    property  THUDF9Desc:  WideString read FTHUDF9Desc;
    property  THUDF10Desc: WideString read FTHUDF10Desc;
    property  TLUDF5Desc:  WideString read FTLUDF5Desc;
    property  TLUDF6Desc:  WideString read FTLUDF6Desc;
    property  TLUDF7Desc:  WideString read FTLUDF7Desc;
    property  TLUDF8Desc:  WideString read FTLUDF8Desc;
    property  TLUDF9Desc:  WideString read FTLUDF9Desc;
    property  TLUDF10Desc: WideString read FTLUDF10Desc;

    property  UseCCDeps: boolean read FUseCCDeps;
    property  ssSetTransPeriodByDate: boolean read FCopySetTransPeriodByDate;

    // CJS 2013-11-04 - MRD2.6.43 - Support for Transaction Originator
    property OriginatorCaption: WideString read GetOriginatorCaption;
  end;

  TCurrency = class(TObject)
  private
    FInverted: boolean;
    FExchangeRate: double;
  public
    constructor create(AnExchangeRate: double; IsInverted: boolean);
    property ExchangeRate: double  read FExchangeRate write FExchangeRate;
    property Inverted:     boolean read FInverted     write FInverted;
  end;

var
  GCurrencySymbols: TStringList;
  GCurrencies: TObjectList;

implementation

uses Math, TUDPeriodClass, ETDateU;

{ TTimesheetData }

procedure TTimesheetData.CloseCOMToolkit;
begin
  FToolkit.CloseToolkit;
  FToolkit := nil;
end;

procedure TTimesheetData.CopyTimesheetLines(ATimesheet: TTimesheet);
var
  NewLine: TTimesheetLine;
  i: integer;
  TransactionLine: ITransactionLine2;
begin
  for i := 1 to FTransaction.thLines.thLineCount do begin
    NewLine := TTimesheetLine.Create;
    TransactionLine := FTransaction.thLines.thLine[i] as ITransactionLine2;
//    if FTransaction.thOurRef = 'TSH001260' then
//    FToolkit.Functions.entBrowseObject(TransactionLine, true);
    NewLine.ChargeCurrency := TransactionLine.tlChargeCurrency;
    with NewLine, TransactionLine.tlAsTSH do begin
      AnalysisCode  := trim(tltAnalysisCode);
      ChargeOutRate := tltChargeOutRate;
      CostCentre    := trim(tltCostCentre);
      CostPerHour   := tltCostPerHour;
      CostCurrency  := tltCurrency;
      Department    := trim(tltDepartment);
      Hours         := tltHours;
      JobCode       := trim(tltJobCode);
      Narrative     := trim(tltNarrative);
      RateCode      := trim(tltRateCode);
      UserField1    := trim(tltUserField1);
      UserField2    := trim(tltUserField2);
      UserField3    := trim(tltUserField3);
      UserField4    := trim(tltUserField4);

      DecodeDailyHours; // from udf3 and udf4

      ExchLineNo    := TransactionLine.tlLineNo;
      LogicalLineNo := i;
    end;

    { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
    with NewLine, TransactionLine as ITransactionLine8 do
    begin
      UserField5    := trim(tlUserField5);
      UserField6    := trim(tlUserField6);
      UserField7    := trim(tlUserField7);
      UserField8    := trim(tlUserField8);
      UserField9    := trim(tlUserField9);
      UserField10   := trim(tlUserField10);
    end;
    ATimesheet.TimesheetLines.Add(NewLine);
  end;
end;

procedure TTimesheetData.CopyTimesheetData;
var
  NewTimesheet: TTimesheet;
begin
//  FToolkit.Functions.entBrowseObject(FTransaction, true);
  NewTimesheet := TTimesheet.Create;
  with NewTimesheet, FTransaction do begin
    HoldStatus := thHoldFlag;
    HoldFlag   := (thHoldFlag and 32) + (thHoldFlag and 128); // obtain the +32 and +128 bit settings if they're set
    HoldStatus := HoldStatus - HoldFlag;                      // ODD control only uses 0=Not Held and 1=Hold for Query
  end;

  with NewTimesheet, FTransaction.thAsTSH do begin
    Description := trim(ttDescription);
    Employee    := trim(ttEmployee);
    Operator    := trim(ttOperator);
    OurRef      := trim(ttOurRef);
    Period      := ttPeriod;
    TransDate   := trim(ttTransDate);
    UserField1  := trim(ttUserField1);
    UserField2  := trim(ttUserField2);
    UserField3  := trim(ttUserField3);
    UserField4  := trim(ttUserField4);
    WeekMonth   := ttWeekMonth;
    Year        := ttYear;
  end;

  { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
  with NewTimesheet, FTransaction as ITransaction9 do
  begin
    UserField5  := trim(thUserField5);
    UserField6  := trim(thUserField6);
    UserField7  := trim(thUserField7);
    UserField8  := trim(thUserField8);
    UserField9  := trim(thUserField9);
    UserField10 := trim(thUserField10);
  end;

  // CJS 2013-11-04 - MRD2.6.43 - Support for Transaction Originator
  with NewTimesheet, FTransaction as ITransaction11 do
  begin
    Originator := trim(thOriginator);
    CreationDate := trim(thCreationDate);
    CreationTime := trim(thCreationTime);
  end;

  CopyTimesheetLines(NewTimeSheet);
  FTimesheets.Add(NewTimeSheet);
end;

constructor TTimesheetData.Create(ADataPath: string; AnEmployeeID: string);
begin
  inherited Create;
  FDataPath   := ADataPath;
  FEmployeeID := AnEmployeeID;
  FTimesheets := TObjectList.Create;
  FTimesheets.OwnsObjects := true;
end;

procedure TTimesheetData.DeleteTimesheets;
begin
  FTimesheets.Clear;
end;

destructor TTimesheetData.Destroy;
begin
  if FTimesheets <> nil then
    FTimesheets.Free;
  inherited;
end;

procedure TTimesheetData.FetchTimeSheetData;

  function CheckCurrSymb(ACurrSymb: WideString): WideString;
  begin
    if ACurrSymb = '' then
      result := '-' else
    if trim(ACurrSymb) = #156 then
      result := '£'
    else
      result := ACurrSymb;
  end;

  procedure GetSystemSetup;
  var i: integer;
  begin
    FQtyDecimals := 2; // FToolkit.SystemSetup.ssQtyDecimals; // v10 build 11
    with FToolkit.SystemSetup do begin
      UDPeriod.GlobalPeriod            := ssCurrentPeriod;
      UDPeriod.GlobalYear              := ssCurrentYear;
      UDPeriod.SetTransPeriodByDate    := ssSetTransPeriodByDate;
      FCopySetTransPeriodByDate        := ssSetTransPeriodByDate;
      FUseCCDeps := ssUseCCDept;
      with ssUserFields as ISystemSetupUserFields2 do begin
        FTHUDF1Desc := ufTSHDesc[1];
        FTHUDF2Desc := ufTSHDesc[2];
        FTHUDF3Desc := ufTSHDesc[3];
        FTHUDF4Desc := ufTSHDesc[4];
        FTLUDF1Desc := ufTSHLineDesc[1];
        FTLUDF2Desc := ufTSHLineDesc[2];

        { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
        FTHUDF5Desc  := ufTSHDesc[5];
        FTHUDF6Desc  := ufTSHDesc[6];
        FTHUDF7Desc  := ufTSHDesc[7];
        FTHUDF8Desc  := ufTSHDesc[8];
        FTHUDF9Desc  := ufTSHDesc[9];
        FTHUDF10Desc := ufTSHDesc[10];
        FTLUDF5Desc  := ufTSHLineDesc[5];
        FTLUDF6Desc  := ufTSHLineDesc[6];
        FTLUDF7Desc  := ufTSHLineDesc[7];
        FTLUDF8Desc  := ufTSHLineDesc[8];
        FTLUDF9Desc  := ufTSHLineDesc[9];
        FTLUDF10Desc := ufTSHLineDesc[10];
      end;
      GCurrencySymbols.Clear;
      GCurrencies.Clear;
      for i := 0 to ssMaxCurrency do
        with ssCurrency[i] do begin
          GCurrencySymbols.Add(CheckCurrsymb(scSymbol));
          if ssCurrencyRateType = rtCompany then
            GCurrencies.Add(TCurrency.create(scCompanyRate, scTriInvert))
          else
            GCurrencies.Add(TCurrency.create(scDailyRate, scTriInvert));
        end;
    end;
  end;
begin
  OpenCOMToolkit;
  try
    DeleteTimesheets;
    if FToolkit <> nil then begin
      GetSystemSetup; // just because its as good a time as any
      FTransaction := FToolkit.Transaction as ITransaction11;
      if FTransaction <> nil then
        with FTransaction do begin
          Index := thIdxRunNo;
          FRes  := GetLessThanOrEqual(BuildRunNoIndex(0, 'T')); // I Spy with my little eye, all OurRefs beginning with 'T' (with RunNo = 0, daybook unposted trans)
          while (FRes = 0) and (thRunNo = 0) and (thDocType = dtTSH) do begin
            if trim(FTransaction.thAsTSH.ttEmployee) = FEmployeeID then
              CopyTimesheetData;
            FRes := GetPrevious; // going backwards retrieves them in ascending OurRef order.
          end;
        end;
    end;
  finally
    FTransaction := nil;
    CloseCOMToolkit;
  end;
end;

function TTimesheetData.FirstTimesheet: TTimesheet;
begin
  if FTimesheets.Count = 0 then
    FetchTimesheetData;
  FTimesheet := nil;
  FCurrentIx := FTimesheets.Count - 1;
  if TimesheetCount <> 0 then
    FTimesheet := TTimesheet(FTimesheets[FCurrentIx]);
  result := FTimesheet;
end;

function TTimesheetData.GetTimesheetCount: integer;
begin
  result := FTimesheets.Count;
end;

function TTimesheetData.NextTimesheet: TTimesheet;
begin
  FTimesheet := nil;
  if FCurrentIx > 0 then begin
    dec(FCurrentIx);
    FTimesheet := TTimesheet(FTimesheets[FCurrentIx]);
  end;

  result := FTimesheet;
end;

procedure TTimesheetData.OpenCOMToolkit;
begin
  FToolkit := OpenToolkit(FDataPath, True);
//  if FToolkit <> nil then
//    FToolkit.OpenToolkit; // ???
end;

function TTimesheetData.GetEmployeeTotalCharge: double;
var
  i: integer;
begin
  result := 0;
  for i := 0 to FTimesheets.Count - 1 do
    result := result + TTimesheet(FTimesheets[i]).TotalCharge;
end;

procedure TTimesheetData.LocateTimesheet(AnOurRef: WideString);
var
  i: integer;
begin
  if FTimesheets.Count = 0 then FetchTimeSheetData;
  FTimesheet := nil;
  for i := 0 to FTimesheets.Count - 1 do
    if trim(TTimesheet(FTimesheets[i]).OurRef) = trim(AnOurRef) then
      FTimesheet := TTimesheet(FTimesheets[i]);
end;

function TTimesheetData.NewTimesheet: TTimesheet;
begin
  if FTimesheets.Count = 0 then FetchTimeSheetData; // primarily, it simply ensures that FPrecision gets set from ssQtyDecimals
  result := TTimesheet.Create;
  FTimesheets.Add(result);
  FTimesheet            := result;
  FTimesheet.IsNew      := true;
  FTimesheet.TransDate  := FormatDateTime('yyyymmdd', date);
  FTimesheet.FWeekMonth := 0;
  FTimesheet.Period     := UDPeriod.GetPeriod(FTimesheet.TransDate, true);
  FTimesheet.Year       := UDPeriod.GetYear(FTimesheet.TransDate, false);
  FTimesheet.Employee   := FEmployeeID;
  FTimesheet.HoldStatus := -1; // v20
end;

function TTimesheetData.SaveTimesheet(var AnOurRef: WideString): integer;
begin
  result := -1;
  OpenCOMToolkit;
  try
    if FTimesheet.IsNew then begin
      FTransaction := FToolkit.Transaction.Add(dtTSH) as ITransaction11;
      if FTransaction = nil then EXIT;
    end
    else begin
//      FTransaction := FToolkit.Transaction as ITransaction11; // ???
      with  FToolkit.Transaction do begin
        Index := thIdxOurRef;
        result := GetEqual(BuildOurRefIndex(FTimesheet.OurRef));
        if result <> 0 then EXIT;
        result := -2;
        if not entCanUpdate then EXIT;
        result := -3;
        FTransaction := FToolkit.Transaction.Update as ITransaction11;
      end;
    end;
    if FTransaction <> nil then begin
      FTimesheet.ApplyDataChanges(FTransaction);

    UDPeriod.GetPeriod(FTransaction.thTransDate, false); // Get UDPeriod to set AutoSetPeriod. dont need the pr/yr as its already set on the transaction
    FToolkit.Configuration.AutoSetPeriod := UDPeriod.AutoSetPeriod;
    FToolkit.Configuration.AutoSetTransCurrencyRates := true;

//    FToolkit.Functions.entBrowseObject(FTransaction, true);
//      FTransaction.UpdateTotals;
      result := FTransaction.Save(true);
      if result = 0 then begin
        AnOurRef := FTransaction.thOurRef;
        UDPeriod.SetTransPeriodByDate := FCopySetTransPeriodByDate; // reset to system default
      end;
    end;
  finally
    FTransaction := nil;
    if result = -3 then
      FLastError := 'This timesheet may be in use by another process.'#13#10'Please wait then try saving again.'
    else
      FLastError := FToolkit.LastErrorString;
    CloseCOMToolkit;
  end;
end;

function TTimesheetData.GetEmployeeTotalHours: double;
var
  i: integer;
begin
  result := 0;
  for i := 0 to FTimesheets.Count - 1 do
    result := result + TTimesheet(FTimesheets[i]).TotalQtyHrs;
end;

function  TTimesheetData.GetEmployeeTotalCost: double;
var
  i: integer;
begin
  result := 0;
  for i := 0 to FTimesheets.Count - 1 do
    result := result + TTimesheet(FTimesheets[i]).TotalCost;
end;

function TTimesheetData.GetOriginatorCaption: WideString;
begin
  if (trim(FTimesheet.Originator) <> '') then
    Result := 'Added by ' + FTimesheet.Originator + ' on ' +
              POutDate(FTimesheet.CreationDate) + ' at ' +
              Copy(FTimesheet.CreationTime, 1, 2) + ':' +
              Copy(FTimesheet.CreationTime, 3, 2)
  else
    Result := '';
end;

{ TTimesheet }

constructor TTimesheet.Create;
begin
  inherited;

  FTimesheetLines := TObjectList.Create;
  FTimesheetLines.OwnsObjects := true;
end;

destructor TTimesheet.Destroy;
begin
  if FTimesheetLines <> nil then
    FTimesheetLines.Free;

  inherited;
end;

function TTimesheet.GetTotalQtyHrs: double;
var
  i: integer;
begin
  result := 0;
  if FTimesheetLines = nil then ShowMessage('No timesheet lines');
  for i := 0 to TimesheetRealLineCount - 1 do
    with FTimesheetLines[i] as TTimesheetLine do
      if not LineDeleted then
        result := result + Hours;
end;

function TTimesheet.GetTimesheetLine(LineNo: integer): TTimesheetLine; // get a real line, deleted or not
begin
  result := nil;
  if (LineNo < 1) or (LineNo > TimesheetRealLineCount) then EXIT;
  LineNo := LineNo - 1;
  result := TTimesheetLine(FTimesheetLines[LineNo]);
end;

function TTimesheet.GetTimesheetLiveLineCount: integer;
var LineNo: integer;
begin
  result := 0;
  for LineNo := 1 to TimesheetRealLineCount do
    if not (TimesheetLine[LineNo].LineDeleted) then
      inc(result);
end;

function TTimesheet.GetTotalCharge: double;
// as of v14, Hours * ChargeOutRate is converted to Consolidated by multiplying by the ChargeExchangeRate
var
  i: integer;
begin
  result := 0;
  if FTimesheetLines <> nil then begin
    for i := 0 to TimesheetRealLineCount - 1 do
      with FTimesheetLines[i] as TTimesheetLine do
        if not LineDeleted then
          if TCurrency(GCurrencies[FChargeCurrency]).Inverted then
            result := result + RoundTo(Hours * ChargeOutRate * TCurrency(GCurrencies[FChargeCurrency]).ExchangeRate, -2)
          else
            result := result + RoundTo(Hours * ChargeOutRate / TCurrency(GCurrencies[FChargeCurrency]).ExchangeRate, -2)

  end;
end;

function TTimesheet.GetTotalCost: double;
// as of v14, Hours * CostPerHour is converted to Consolidated by multiplying by the CostExchangeRate
var
  i: integer;
begin
  result := 0;
  if FTimesheetLines <> nil then begin
    for i := 0 to TimesheetRealLineCount - 1 do
      with FTimesheetLines[i] as TTimesheetLine do
        if not LineDeleted then
          if TCurrency(GCurrencies[FCostCurrency]).Inverted then
            result := result + RoundTo(Hours * CostPerHour * TCurrency(GCurrencies[FCostCurrency]).ExchangeRate, -2)
          else
            result := result + RoundTo(Hours * CostPerHour / TCurrency(GCurrencies[FCostCurrency]).ExchangeRate, -2)
  end;
end;

function TTimesheet.LocateLogicalLine(ALineNo: integer): TTimesheetLine;
var
  LineNo: integer;
begin
  for LineNo := 1 to TimesheetRealLineCount do
    with TimesheetLine[LineNo] do
      if LogicalLineNo = ALineNo then begin
        FTimesheetLine := TimesheetLine[LineNo];
        result         := FTimesheetLine;
      end;
end;

function TTimesheet.AddNewLine: TTimesheetLine;
begin
  result := TTimesheetLine.Create;
  FTimesheetLines.Add(result);
  FTimesheetLine               := result;
  FTimesheetLine.IsNewLine     := true;
  FTimesheetLine.LogicalLineNo := TimesheetLiveLineCount;
  FTimesheetLine.ExchLineNo    := HighestExchequerLineNo + 1;
end;

function TTimesheet.GetTotalHoursForDay(DayOfWeek: integer): double;
var
  i: integer;
begin
  result := 0;
  for i := 0 to TimesheetRealLineCount - 1 do
    with FTimesheetLines[i] as TTimesheetLine do
    if not LineDeleted then
      result := result + HoursForDay[DayOfWeek];
end;

function TTimesheet.GetLinesMarkedForDeletion: integer;
var
  LineNo: integer;
begin
  result := 0;
  for LineNo := 1 to TimesheetRealLineCount do
    with TimesheetLine[LineNo] do
      if MarkedForDeletion and not DeletionConfirmed then
        inc(result);
end;

procedure TTimesheet.ConfirmLineDeletions;
var LineIx, LineNo: integer;
begin
  for LineIx := 0 to TimesheetRealLineCount - 1 do // logically delete lines marked for deletion
    with FTimesheetLines[LineIx] as TTimesheetLine do
      if MarkedForDeletion then
        DeletionConfirmed := true;

  LineNo := 0;
  for LineIx := 0 to TimesheetRealLineCount - 1 do // renumber lines which haven't been logically deleted
    with FTimesheetLines[LineIx] as TTimesheetLine do
      if LineDeleted then
        LogicalLineNo := -1 // not used, just useful for debugging.
      else begin
        inc(LineNo);
        LogicalLineNo := LineNo
      end;
end;

function TTimesheet.GetTimesheetRealLineCount: integer;
begin
  result := FTimesheetLines.Count;
end;

function TTimesheet.GetTimesheetChanged: boolean;
var LineNo: integer;
begin
  Result := FTimesheetChanged;
  if not Result then begin
    for LineNo := 1 to TimesheetRealLineCount do
      with TimesheetLine[LineNo] do begin
        result := LineChanged or (LineDeleted and not IsNew);
        if result then BREAK;
      end;
  end;
end;

function TTimesheet.GetLinesDeletedCount: integer;
var
  LineNo: integer;
begin
  result := 0;
  for LineNo := 1 to TimesheetRealLineCount do
    with TimesheetLine[LineNo] do
      if MarkedForDeletion and DeletionConfirmed then
        inc(result);
end;

procedure TTimesheet.ApplyDataChanges(ATransaction: ITransaction11);
var
  LineNum: integer;
  NewLine: ITransactionLine2;
begin
  if FTimesheetChanged or IsNew then begin // has the timesheet header information changed. This is subtly different from using the property getter
    ATransaction.thOperator := FOperator;

    // CJS 2013-11-04 - MRD2.6.43 - Support for Transaction Originator
    if (IsNew) then
      ATransaction.thOriginator := FOperator;

    ATransaction.thHoldFlag := FHoldStatus + FHoldFlag; // + FHoldFlag to preserve the +32 and +128 bit settings if they're set.
    with ATransaction.thAsTSH do begin
      ttDescription := Description;
      ttEmployee    := Employee;
      ttOperator    := Operator;
      ttOurRef      := OurRef;
      ttPeriod      := Period;
      ttYear        := Year;
      ttTransDate   := TransDate;
      ttUserField1  := UserField1;
      ttUserField2  := UserField2;
      ttUserField3  := UserField3;
      ttUserField4  := UserField4;
      ttWeekMonth   := WeekMonth;
    end;
    { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
    with ATransaction as ITransaction9 do
    begin
      thUserField5  := UserField5;
      thUserField6  := UserField6;
      thUserField7  := UserField7;
      thUserField8  := UserField8;
      thUserField9  := UserField9;
      thUserField10 := UserField10;
    end;
  end;

  for LineNum := TimesheetRealLineCount downto 1 do begin // downto so we can delete lines from the thLine array
    if TimesheetLine[LineNum].LineDeleted then begin      // don't process deleted lines
      if not TimesheetLine[LineNum].IsNewLine then        // new lines won't be in the thLine array
        ATransaction.thLines.Delete(LineNum);
      CONTINUE;
    end
    else
    if TimesheetLine[LineNum].IsNewLine then
      NewLine := ATransaction.thLines.Add as ITransactionLine2
    else
      NewLine := ATransaction.thLines[LineNum] as ITransactionLine2;
    with NewLine.tlAsTSH, TimesheetLine[LineNum] do begin
      if LineChanged or IsNewLine then begin
        tltJobCode       := JobCode;
        tltRateCode      := RateCode;
        NewLine.tlChargeCurrency := ChargeCurrency;
        tltCurrency      := CostCurrency;
        NewLine.ImportDefaults;
//        NewLine.tlChargeCurrency := ChargeCurrency;
        tltAnalysisCode  := AnalysisCode;
        tltChargeOutRate := ChargeOutRate;
        tltCostCentre    := CostCentre;
        tltCostPerHour   := CostPerHour;
//        tltCurrency      := CostCurrency;
        tltDepartment    := Department;
        tltHours         := Hours;
        tltNarrative     := Narrative;
        tltUserField1    := UserField1;
        tltUserField2    := UserField2;
        tltUserField3    := GetUserField3;
        tltUserField4    := GetUserField4;
        NewLine.tlLineNo := ExchLineNo;

        { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
        with NewLine as ITransactionLine9 do
        begin
          tlUserField5    := UserField5;
          tlUserField6    := UserField6;
          tlUserField7    := UserField7;
          tlUserField8    := UserField8;
          tlUserField9    := UserField9;
          tlUserField10   := UserField10;
        end;

        if IsNewLine then
          with NewLine as ITransactionLine do Save;
      end;
    end;
  end;
end;

function TTimesheet.GetHighestExchequerLineNo: integer;
var
  LineNo: integer;
begin
  result := 0;
  for LineNo := 1 to TimesheetRealLineCount do
    with TimesheetLine[LineNo] do
      if ExchLineNo > result then
        result := ExchLineNo;
end;

{ TTimesheetLine }

procedure TTimesheetLine.DecodeDailyHours;
var
  DayNo: integer;
  UDF: WideString;
  PosSlash: integer;
  DayHours: string;
begin
  UDF := FUserField3;
  for DayNo := 1 to 7 do begin
    PosSlash := pos('/', UDF);
    if PosSlash <> 0 then begin
      DayHours := copy(UDF, 1, PosSlash - 1);
      delete(UDF, 1, PosSlash);
    end;
    FHoursForDay[DayNo] := StrToFloatDef(DayHours, 0);
    if DayNo = 3 then
      UDF := FUserField4;
  end;
end;

function TTimesheetLine.GetLineDeleted: boolean;
begin
  result := MarkedForDeletion and DeletionConfirmed;
end;

function TTimesheetLine.GetHoursForDay(DayOfWeek: integer): double;
begin
  result := FHoursForDay[DayOfWeek];
end;

procedure TTimesheetLine.SetHoursForDay(DayOfWeek: integer; const Value: double);
begin
  FHoursForDay[DayOfWeek] := Value;
end;

procedure TTimesheetLine.SetLineHours(const Value: double);
begin
  FHours := Value;
//FillChar(FHoursForDay, SizeOf(FHoursForDay), 0);
end;

function TTimesheetLine.GetUserField3: WideString;
begin
  result := format('%.2f/%.2f/%.2f/', [FHoursForDay[1],FHoursForDay[2],FHoursForDay[3]]);
end;

function TTimesheetLine.GetUserField4: WideString;
begin
  result := format('%.2f/%.2f/%.2f/%.2f/', [FHoursForDay[4],FHoursForDay[5],FHoursForDay[6],FHoursForDay[7]]);
end;

{ TCurrency }

constructor TCurrency.create(AnExchangeRate: double; IsInverted: boolean);
begin
  FExchangeRate := AnExchangeRate;
  FInverted     := IsInverted;
end;

initialization
  GCurrencySymbols := TStringList.Create;
  GCurrencies      := TObjectList.Create(true);

finalization
  if GCurrencySymbols <> nil then
    GCurrencySymbols.Free;

  if GCurrencies <> nil then
    GCurrencies.Free;

end.
