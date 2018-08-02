unit EBStockLine;

interface

uses
  Classes, Dialogs, Forms, SysUtils, Windows,
  GlobVar,       // Exchequer global const/type/var
  VarConst,      // Exchequer global const/type/var
  BtrvU2,        // Btrieve Interface Routines & Constants
  Recon3U,       // Extended Btrieve Ops classes for reading data
  DrillConst;    // Types and constants used by the drill-down routines.

type
  { IMPORTANT: Turbo Pascal Object, not Object Pascal Class! }
  TExtBtrieveStockLines = object(ExtSNObj)
    constructor Init;
    destructor Done;

    procedure SetCurrencyFilter(
      var Term: FilterRepeatType;
      var Compare: Char;
      const Currency: Byte;
      const CompCode: TExtBtrCompareMode = cmpEqual;
      const LogicEx: TExtBtrLogicExpression = lexAND
    );

    procedure SetCustCodeFilter(
      var Term: FilterRepeatType;
      var Compare: array of Char;
      const CustCode: ShortString;
      const CompCode: TExtBtrCompareMode = cmpEqual;
      const LogicEx: TExtBtrLogicExpression = lexAND
    );

    procedure SetLineTypeFilter(
      var Term: FilterRepeatType;
      var Compare: Char;
      const LineType: Char;
      const CompCode: TExtBtrCompareMode = cmpEqual;
      const LogicEx: TExtBtrLogicExpression = lexAND
    );

    procedure SetPeriodFilter(
      var Term: FilterRepeatType;
      var Compare: Char;
      const Period: Byte;
      const CompCode: TExtBtrCompareMode = cmpEqual;
      const LogicEx: TExtBtrLogicExpression = lexAND
    );

    procedure SetRunNumberFilter(
      var Term: FilterRepeatType;
      var Compare: LongInt;
      const Status: TPostedStatus;
      const LogicEx: TExtBtrLogicExpression = lexAND
    );

    procedure SetStockCodeFilter(
      var Term: FilterRepeatType;
      var Compare: array of Char;
      const StockCode: ShortString;
      const CompCode: TExtBtrCompareMode = cmpEqual;
      const LogicEx: TExtBtrLogicExpression = lexAND
    );

    procedure SetYearFilter(
      var Term: FilterRepeatType;
      var Compare: Char;
      const Year: Byte;
      const CompCode: TExtBtrCompareMode = cmpEqual;
      const LogicEx: TExtBtrLogicExpression = lexAND
    );

    function Filter01(
      const B_Func: Integer;
      const Fnum: Integer;
      const Keypath: Integer;
      var   KeyS: Str255;
      const FStockCode: ShortString
    ): Integer;

    function Filter02(
      const B_Func: Integer;
      const Fnum: Integer;
      const Keypath: Integer;
      var   KeyS: Str255;
      const Mode: TDataFilterMode;
      const FStockCode: ShortString;
      const FCurrency: Byte;
      const FYear: Byte;
      const FPeriod: Byte
    ): Integer;

    function Filter03(
      const B_Func: Integer;
      const Fnum: Integer;
      const Keypath: Integer;
      var   KeyS: Str255;
      const Mode: TDataFilterMode;
      const FCustCode: ShortString;
      const FYear: Byte;
      const FPeriod: Byte
    ): Integer;

  end;

implementation

uses
  ETStrU;

{ TExtBtrieveStockLines }

destructor TExtBtrieveStockLines.Done;
begin
  ExtSNObj.Done;
end;

function TExtBtrieveStockLines.Filter01(const B_Func, Fnum,
  Keypath: Integer; var KeyS: Str255; const FStockCode: ShortString): Integer;
{ Exact match for StockCode }
begin

  // Build the Extended Btrieve structures
  ExtSNObj.Prime_InitRec(
    SearchRec^.Filter.FilterS1.ExtendHead,
    SearchRec^.Filter.FilterS1.ExtendTail,
    Fnum,
    Sizeof(SearchRec^.Filter.FilterS1)
  );

  SearchRec^.Filter.FilterS1.ExtendHead.NumTerms := 4;

  // Stock Code = XX
  SetStockCodeFilter(
    SearchRec^.Filter.FilterS1.Term1,
    SearchRec^.Filter.FilterS1.Compare1,
    FStockCode,
  );

  // Posted Run number = Any
  SetRunNumberFilter(
    SearchRec^.Filter.FilterS1.Term2,
    SearchRec^.Filter.FilterS1.Compare2,
    psAll
  );

  // Year = Any
  SetYearFilter(
    SearchRec^.Filter.FilterS1.Term3,
    SearchRec^.Filter.FilterS1.Compare3,
    0,
    cmpGreaterThanOrEqual,
  );

  // Period = Any
  SetPeriodFilter(
    SearchRec^.Filter.FilterS1.Term4,
    SearchRec^.Filter.FilterS1.Compare4,
    0,
    cmpGreaterThanOrEqual,
    lexLastTerm
  );

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end;

function TExtBtrieveStockLines.Filter02(const B_Func, Fnum,
  Keypath: Integer; var KeyS: Str255; const Mode: TDataFilterMode;
  const FStockCode: ShortString; const FCurrency, FYear, FPeriod: Byte): Integer;
{
  Exact match for StockCode, Currency, and Year;
  Period = Any
}
var
  CompareMode: TExtBtrCompareMode;
  ForYear, ForPeriod: Byte;
begin

  // Build the Extended Btrieve structures
  ExtSNObj.Prime_InitRec(
    SearchRec^.Filter.FilterS2.ExtendHead,
    SearchRec^.Filter.FilterS2.ExtendTail,
    Fnum,
    Sizeof(SearchRec^.Filter.FilterS2)
  );

  SearchRec^.Filter.FilterS2.ExtendHead.NumTerms := 5;

  // Stock Code = XX
  SetStockCodeFilter(
    SearchRec^.Filter.FilterS2.Term1,
    SearchRec^.Filter.FilterS2.Compare1,
    FStockCode
  );

  // Posted Run number = Any
  SetRunNumberFilter(
    SearchRec^.Filter.FilterS2.Term2,
    SearchRec^.Filter.FilterS2.Compare2,
    psAll
  );

  // Currency = XX
  if (Mode in [dfThisPeriodConsolidated, dfAllPeriodsConsolidated,
               dfToYearConsolidated, dfToPeriodConsolidated,
               dfThisYearConsolidated]) then
    SetCurrencyFilter(
      SearchRec^.Filter.FilterS2.Term3,
      SearchRec^.Filter.FilterS2.Compare3,
      0,
      cmpGreaterThanOrEqual
    )
  else
    SetCurrencyFilter(
      SearchRec^.Filter.FilterS2.Term3,
      SearchRec^.Filter.FilterS2.Compare3,
      FCurrency
    );

{
  Specific year:          dfThisPeriod, dfToPeriod
  Up to specific year:    dfToYear
  Any year:               dfAllPeriods
}
  ForYear := FYear;
  if (Mode in [dfThisPeriod, dfThisPeriodConsolidated,
               dfToPeriod,   dfToPeriodConsolidated]) then
    CompareMode := cmpEqual
  else if (Mode in [dfToYear, dfToYearConsolidated]) then
    CompareMode := cmpLessThanOrEqual
  else
  begin
    CompareMode := cmpGreaterThanOrEqual;
    ForYear     := 0;
  end;

  SetYearFilter(
    SearchRec^.Filter.FilterS2.Term4,
    SearchRec^.Filter.FilterS2.Compare4,
    ForYear,
    CompareMode
  );

{
  Specific period:        dfThisPeriod
  Up to specified period: dfToPeriod
  Any period:             dfAllPeriods, dfToYear
}
  ForPeriod := FPeriod;
  if (Mode in [dfThisPeriod, dfThisPeriodConsolidated]) then
    CompareMode := cmpEqual
  else if (Mode in [dfToPeriod, dfToPeriodConsolidated]) then
    CompareMode := cmpLessThanOrEqual
  else
  begin
    CompareMode := cmpGreaterThanOrEqual;
    ForPeriod    := 0;
  end;

  SetPeriodFilter(
    SearchRec^.Filter.FilterS2.Term5,
    SearchRec^.Filter.FilterS2.Compare5,
    ForPeriod,
    CompareMode,
    lexLastTerm
  );

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end;

function TExtBtrieveStockLines.Filter03(const B_Func, Fnum,
  Keypath: Integer; var KeyS: Str255; const Mode: TDataFilterMode;
  const FCustCode: ShortString; const FYear, FPeriod: Byte): Integer;
var
  CompareMode: TExtBtrCompareMode;
  ForYear, ForPeriod: Byte;
begin

  // Build the Extended Btrieve structures
  ExtSNObj.Prime_InitRec(
    SearchRec^.Filter.FilterS3.ExtendHead,
    SearchRec^.Filter.FilterS3.ExtendTail,
    Fnum,
    Sizeof(SearchRec^.Filter.FilterS3)
  );

  SearchRec^.Filter.FilterS3.ExtendHead.NumTerms := 6;

  // Line Type = Any
  SetLineTypeFilter(
    SearchRec^.Filter.FilterS3.Term1,
    SearchRec^.Filter.FilterS3.Compare1,
    #0,
    cmpGreaterThanOrEqual
  );

  // Cust Code = XX
  SetCustCodeFilter(
    SearchRec^.Filter.FilterS3.Term2,
    SearchRec^.Filter.FilterS3.Compare2,
    FCustCode
  );

  // Stock Code = Any
  SetStockCodeFilter(
    SearchRec^.Filter.FilterS3.Term3,
    SearchRec^.Filter.FilterS3.Compare3,
    '',
    cmpGreaterThanOrEqual
  );

  // Posted Run number = Any
  SetRunNumberFilter(
    SearchRec^.Filter.FilterS3.Term4,
    SearchRec^.Filter.FilterS3.Compare4,
    psAll
  );

{
  Specific year:          dfThisPeriod, dfToPeriod
  Up to specific year:    dfToYear
  Any year:               dfAllPeriods
}
  ForYear := FYear;
  if (Mode in [dfThisPeriod, dfThisPeriodConsolidated,
               dfToPeriod,   dfToPeriodConsolidated]) then
    CompareMode := cmpEqual
  else if (Mode in [dfToYear, dfToYearConsolidated]) then
    CompareMode := cmpLessThanOrEqual
  else
  begin
    CompareMode := cmpGreaterThanOrEqual;
    ForYear     := 0;
  end;

  SetYearFilter(
    SearchRec^.Filter.FilterS3.Term5,
    SearchRec^.Filter.FilterS3.Compare5,
    ForYear,
    CompareMode
  );

{
  Specific period:        dfThisPeriod
  Up to specified period: dfToPeriod
  Any period:             dfAllPeriods, dfToYear
}
  ForPeriod := FPeriod;
  if (Mode in [dfThisPeriod, dfThisPeriodConsolidated]) then
    CompareMode := cmpEqual
  else if (Mode in [dfToPeriod, dfToPeriodConsolidated]) then
    CompareMode := cmpLessThanOrEqual
  else
  begin
    CompareMode := cmpGreaterThanOrEqual;
    ForPeriod    := 0;
  end;

  SetPeriodFilter(
    SearchRec^.Filter.FilterS3.Term6,
    SearchRec^.Filter.FilterS3.Compare6,
    ForPeriod,
    CompareMode,
    lexLastTerm
  );

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end;

constructor TExtBtrieveStockLines.Init;
begin
  ExtSNObj.Init;
end;

procedure TExtBtrieveStockLines.SetCurrencyFilter(
  var Term: FilterRepeatType; var Compare: Char; const Currency: Byte;
  const CompCode: TExtBtrCompareMode;
  const LogicEx: TExtBtrLogicExpression);
begin
  // Currency = XX
  with Term do
  begin
    FieldType   := BString;
    FieldLen    := Sizeof(Compare);
    FieldOffset := BtKeyPos(@Id.Currency, @Id) - 1;
    CompareCode := Ord(CompCode);
    LogicExpres := Ord(LogicEx);
  end; { With Term }
  Compare := Chr(Currency);
end;

procedure TExtBtrieveStockLines.SetCustCodeFilter(
  var Term: FilterRepeatType; var Compare: array of Char;
  const CustCode: ShortString; const CompCode: TExtBtrCompareMode;
  const LogicEx: TExtBtrLogicExpression);
begin
  with Term do
  begin
    FieldType   := BString;
    FieldLen    := Sizeof(Compare);
    FieldOffset := BtKeyPos(@Id.CustCode, @Id);
    CompareCode := Ord(CompCode);
    LogicExpres := Ord(LogicEx);
  end;
  FillChar(Compare, SizeOf(Compare), #0);
  FillChar(Compare, SizeOf(Compare) - 4, #32);
  Move(CustCode[1], Compare, Length(Trim(CustCode)));
end;

procedure TExtBtrieveStockLines.SetLineTypeFilter(
  var Term: FilterRepeatType; var Compare: Char; const LineType: Char;
  const CompCode: TExtBtrCompareMode;
  const LogicEx: TExtBtrLogicExpression);
begin
  with Term do
  begin
    FieldType   := BString;
    FieldLen    := Sizeof(Compare);
    FieldOffset := BtKeyPos(@Id.LineType, @Id) - 1;
    CompareCode := Ord(CompCode);
    LogicExpres := Ord(LogicEx);
  end; { With Term }
  Compare := LineType;
end;

procedure TExtBtrieveStockLines.SetPeriodFilter(var Term: FilterRepeatType;
  var Compare: Char; const Period: Byte;
  const CompCode: TExtBtrCompareMode;
  const LogicEx: TExtBtrLogicExpression);
begin
  // Period = XX
  with Term do
  begin
    FieldType   := BString;
    FieldLen    := Sizeof(Compare);
    FieldOffset := BtKeyPos(@Id.PPr, @Id) - 1;
    CompareCode := Ord(CompCode);
    LogicExpres := Ord(LogicEx);
  end; { With Term }
  Compare := Chr(Period);
end;

procedure TExtBtrieveStockLines.SetRunNumberFilter(
  var Term: FilterRepeatType; var Compare: LongInt;
  const Status: TPostedStatus; 
  const LogicEx: TExtBtrLogicExpression);
var
  RunKey: LongInt;
  CompCode: TExtBtrCompareMode;
begin
  case Status of
    psPosted:
      begin
        RunKey   := 0;
        CompCode := cmpGreaterThanOrEqual;
      end;
    psCommitted:
      begin
        RunKey   := OrdPPRunNo;
        CompCode := cmpEqual;
      end;
    psAll:
      begin
        RunKey   := -$FFFFFF;
        CompCode := cmpGreaterThanOrEqual;
      end;
  end;
  with Term do
  begin
    FieldType   := BInteger;
    FieldLen    := Sizeof(Compare);
    FieldOffset := BtKeyPos(@Id.PostedRun, @Id) - 1;
    CompareCode := Ord(CompCode);
    LogicExpres := Ord(LogicEx);
  end; { With Term }
  Compare := RunKey;
end;

procedure TExtBtrieveStockLines.SetStockCodeFilter(
  var Term: FilterRepeatType; var Compare: array of Char;
  const StockCode: ShortString; const CompCode: TExtBtrCompareMode;
  const LogicEx: TExtBtrLogicExpression);
begin
  // Stock Code = xx
  with Term do
  begin
    FieldType   := BString;
    FieldLen    := Sizeof(Compare);
    FieldOffset := BtKeyPos(@Id.StockCode, @Id);
    CompareCode := Ord(CompCode);
    LogicExpres := Ord(LogicEx);
  end;
  FillChar(Compare, SizeOf(Compare), #0);
  FillChar(Compare, SizeOf(Compare) - 4, #32);
  Move(StockCode[1], Compare, Length(Trim(StockCode)));
end;

procedure TExtBtrieveStockLines.SetYearFilter(var Term: FilterRepeatType;
  var Compare: Char; const Year: Byte; const CompCode: TExtBtrCompareMode;
  const LogicEx: TExtBtrLogicExpression);
begin
  // Year = XX
  with Term do
  begin
    FieldType   := BString;
    FieldLen    := Sizeof(Compare);
    FieldOffset := BtKeyPos(@Id.PYr, @Id) - 1;
    CompareCode := Ord(CompCode);
    LogicExpres := Ord(LogicEx);
  end; { With Term }
  Compare := Chr(Year);
end;

end.
