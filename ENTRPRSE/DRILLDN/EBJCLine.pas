unit EBJCLine;

interface

uses
  Classes, Dialogs, Forms, SysUtils, Windows,
  GlobVar,       // Exchequer global const/type/var
  VarConst,      // Exchequer global const/type/var
  BtrvU2,        // Btrieve Interface Routines & Constants
  JHistDDU,      // Extended Btrieve Ops classes for reading data
  DrillConst;    // Types and constants used by the drill-down routines.

type

  { IMPORTANT: Turbo Pascal Object, not Object Pascal Class! }
  TExtBtrieveJCLines = object(ExtSNObj)
    constructor Init;
    destructor Done;

    procedure SetAnalysisKeyFilter(
      var Term: FilterRepeatType;
      var Compare: TAnalysisKey;
      const JobCode, AnalysisCode: ShortString;
      const CompCode: TExtBtrCompareMode = cmpEqual;
      const LogicEx: TExtBtrLogicExpression = lexAND
    );

    procedure SetBudgetedFilter(
      var Term: FilterRepeatType;
      var Compare: Byte;
      const Budgeted: Byte;
      const CompCode: TExtBtrCompareMode = cmpEqual;
      const LogicEx: TExtBtrLogicExpression = lexAND
    );

    procedure SetCurrencyFilter(
      var Term: FilterRepeatType;
      var Compare: Char;
      const Currency: Byte;
      const CompCode: TExtBtrCompareMode = cmpEqual;
      const LogicEx: TExtBtrLogicExpression = lexAND
    );

    procedure SetHeaderKey(
      var Term: FilterRepeatType;
      var Compare: THeaderKey
    );

    procedure SetJATypeFilter(
      var Term: FilterRepeatType;
      var Compare: TJATypeKey;
      const JobCode: ShortString;
      const JAType: LongInt;
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

    procedure SetPostedFilter(
      var Term: FilterRepeatType;
      var Compare: TRunNoKey;
      const Status: TPostedStatus;
      const LogicEx: TExtBtrLogicExpression = lexAND
    );

    procedure SetStockKeyFilter(
      var Term: FilterRepeatType;
      var Compare: TStockKey;
      const JobCode, StockCode: ShortString;
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

    { --- Filters for Job Costing Analysis list ----------------------------- }
    function Filter01(
      const B_Func: Integer;
      const Fnum: Integer;
      const Keypath: Integer;
      var KeyS: Str255;
      const FJobcode: ShortString;
      const FAnalysisCode: ShortString;
      const FCurrency: Byte;
      const FYear: Byte;
      const Status: TPostedStatus
    ): Integer;

    function Filter02(
      const B_Func: Integer;
      const Fnum: Integer;
      const Keypath: Integer;
      var   KeyS: Str255;
      const FJobcode: ShortString;
      const FAnalysisCode: ShortString;
      const FCurrency: Byte;
      const FYear: Byte;
      const FPeriod: Byte;
      const Status: TPostedStatus
    ): Integer;

    function Filter03(
      const B_Func: Integer;
      const Fnum: Integer;
      const Keypath: Integer;
      var   KeyS: Str255;
      const FJobcode: ShortString;
      const FAnalysisCode: ShortString;
      const FYear: Byte;
      const FPeriod: Byte;
      const Status: TPostedStatus
    ): Integer;

    function Filter04(
      const B_Func: Integer;
      const Fnum: Integer;
      const Keypath: Integer;
      var   KeyS: Str255;
      const FJobcode: ShortString;
      const FAnalysisCode: ShortString;
      const FYear: Byte;
      const Status: TPostedStatus
    ): Integer;

    function Filter05(
      const B_Func: Integer;
      const Fnum: Integer;
      const Keypath: Integer;
      var   KeyS: Str255;
      const FJobcode: ShortString;
      const FAnalysisCode: ShortString;
      const FYear: Byte;
      const FPeriod: Byte;
      const Status: TPostedStatus
    ): Integer;

    { --- Filters for Job Costing totals ------------------------------------ }
    function Filter06(
      const B_Func: Integer;
      const Fnum: Integer;
      const Keypath: Integer;
      var KeyS: Str255;
      const FJobcode: ShortString;
      const FJAType: Integer;
      const FCurrency: Byte;
      const FYear: Byte;
      const Status: TPostedStatus
    ): Integer;

    function Filter07(
      const B_Func: Integer;
      const Fnum: Integer;
      const Keypath: Integer;
      var KeyS: Str255;
      const FJobcode: ShortString;
      const FJAType: Integer;
      const FCurrency: Byte;
      const FYear: Byte;
      const FPeriod: Byte;
      const Status: TPostedStatus
    ): Integer;

    function Filter08(
      const B_Func: Integer;
      const Fnum: Integer;
      const Keypath: Integer;
      var   KeyS: Str255;
      const FJobcode: ShortString;
      const FJAType: Integer;
      const FYear: Byte;
      const FPeriod: Byte;
      const Status: TPostedStatus
    ): Integer;

    function Filter09(
      const B_Func: Integer;
      const Fnum: Integer;
      const Keypath: Integer;
      var   KeyS: Str255;
      const FJobcode: ShortString;
      const FJAType: Integer;
      const FYear: Byte;
      const Status: TPostedStatus
    ): Integer;

    function Filter10(
      const B_Func: Integer;
      const Fnum: Integer;
      const Keypath: Integer;
      var   KeyS: Str255;
      const FJobcode: ShortString;
      const FJAType: Integer;
      const FYear: Byte;
      const FPeriod: Byte;
      const Status: TPostedStatus
    ): Integer;

    { --- Filters for Stock Budget list ------------------------------------- }
    function Filter11(
      const B_Func: Integer;
      const Fnum: Integer;
      const Keypath: Integer;
      var KeyS: Str255;
      const FJobcode: ShortString;
      const FStockCode: ShortString;
      const FCurrency: Byte;
      const FYear: Byte;
      const Status: TPostedStatus
    ): Integer;

    function Filter12(
      const B_Func: Integer;
      const Fnum: Integer;
      const Keypath: Integer;
      var   KeyS: Str255;
      const FJobcode: ShortString;
      const FStockCode: ShortString;
      const FCurrency: Byte;
      const FYear: Byte;
      const FPeriod: Byte;
      const Status: TPostedStatus
    ): Integer;

    function Filter13(
      const B_Func: Integer;
      const Fnum: Integer;
      const Keypath: Integer;
      var   KeyS: Str255;
      const FJobcode: ShortString;
      const FStockCode: ShortString;
      const FYear: Byte;
      const FPeriod: Byte;
      const Status: TPostedStatus
    ): Integer;

    function Filter14(
      const B_Func: Integer;
      const Fnum: Integer;
      const Keypath: Integer;
      var   KeyS: Str255;
      const FJobcode: ShortString;
      const FStockCode: ShortString;
      const FYear: Byte;
      const Status: TPostedStatus
    ): Integer;

    function Filter15(
      const B_Func: Integer;
      const Fnum: Integer;
      const Keypath: Integer;
      var   KeyS: Str255;
      const FJobcode: ShortString;
      const FStockCode: ShortString;
      const FYear: Byte;
      const FPeriod: Byte;
      const Status: TPostedStatus
    ): Integer;

   end; { TExtBtrieveJCLines}

const
  // Filter modes which require Extended Btrieve
  TJCExtendedBtrieveFilters = [
  	dfToYear,
    dfToPeriod,
    dfThisPeriodConsolidated,
    dfToYearConsolidated,
    dfToPeriodConsolidated
  ];

implementation

uses BtKeys1U;

{ TExtBtrieveJCLines }

destructor TExtBtrieveJCLines.Done;
begin
  ExtSNObj.Done;
end;

function TExtBtrieveJCLines.Filter01(const B_Func, Fnum, Keypath: Integer;
  var KeyS: Str255; const FJobcode, FAnalysisCode: ShortString;
  const FCurrency, FYear: Byte; const Status: TPostedStatus): Integer;
{
  Exact match for JobCode, AnalCode, and Currency;
  Year <= Specified;
  Period = Any
}
begin

  // Build the Extended Btrieve structures
  ExtSNObj.Prime_InitRec(
    SearchRec^.Filter.FilterN7.ExtendHead,
    SearchRec^.Filter.FilterN7.ExtendTail,
    Fnum,
    Sizeof(SearchRec^.Filter.FilterN7)
  );

  SearchRec^.Filter.FilterN7.ExtendHead.NumTerms := 6;

  // Prefix and SubType
  SetHeaderKey(
    SearchRec^.Filter.FilterN7.Term1,
    SearchRec^.Filter.FilterN7.Compare1
  );

  // Job Code      = XX
  // Analysis Code = XX
  SetAnalysisKeyFilter(
    SearchRec^.Filter.FilterN7.Term2,
    SearchRec^.Filter.FilterN7.Compare2,
    FJobCode,
    FAnalysisCode
  );

  // Currency = XX
  SetCurrencyFilter(
    SearchRec^.Filter.FilterN7.Term3,
    SearchRec^.Filter.FilterN7.Compare3,
    FCurrency
  );

  // Year <= XX
  SetYearFilter(
    SearchRec^.Filter.FilterN7.Term4,
    SearchRec^.Filter.FilterN7.Compare4,
    FYear,
    cmpLessThanOrEqual
  );

  // Period > 0 (i.e. any period)
  SetPeriodFilter(
    SearchRec^.Filter.FilterN7.Term5,
    SearchRec^.Filter.FilterN7.Compare5,
    0,
    cmpGreaterThan
  );

  // Posted or Committed
  SetPostedFilter(
    SearchRec^.Filter.FilterN7.Term6,
    SearchRec^.Filter.FilterN7.Compare6,
    Status,
    lexLastTerm
  );

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end;

function TExtBtrieveJCLines.Filter02(const B_Func, Fnum, Keypath: Integer;
  var KeyS: Str255; const FJobcode, FAnalysisCode: ShortString;
  const FCurrency, FYear, FPeriod: Byte; const Status: TPostedStatus): Integer;
{
  Exact match for JobCode, AnalCode, Currency, and Year;
  Period <= Specified
}
begin

  // Build the Extended Btrieve structures
  ExtSNObj.Prime_InitRec(
    SearchRec^.Filter.FilterN7.ExtendHead,
    SearchRec^.Filter.FilterN7.ExtendTail,
    Fnum,
    Sizeof(SearchRec^.Filter.FilterN7)
  );

  SearchRec^.Filter.FilterN7.ExtendHead.NumTerms := 6;

  // Prefix and SubType
  SetHeaderKey(
    SearchRec^.Filter.FilterN7.Term1,
    SearchRec^.Filter.FilterN7.Compare1
  );

  // Job Code      = XX
  // Analysis Code = XX
  SetAnalysisKeyFilter(
    SearchRec^.Filter.FilterN7.Term2,
    SearchRec^.Filter.FilterN7.Compare2,
    FJobCode,
    FAnalysisCode
  );

  // Currency = XX
  SetCurrencyFilter(
    SearchRec^.Filter.FilterN7.Term3,
    SearchRec^.Filter.FilterN7.Compare3,
    FCurrency
  );

  // Year = XX
  SetYearFilter(
    SearchRec^.Filter.FilterN7.Term4,
    SearchRec^.Filter.FilterN7.Compare4,
    FYear,
    cmpEqual
  );

  // Period <= Specified
  SetPeriodFilter(
    SearchRec^.Filter.FilterN7.Term5,
    SearchRec^.Filter.FilterN7.Compare5,
    FPeriod,
    cmpLessThanOrEqual
  );

  // Posted or Committed
  SetPostedFilter(
    SearchRec^.Filter.FilterN7.Term6,
    SearchRec^.Filter.FilterN7.Compare6,
    Status,
    lexLastTerm
  );

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end;

function TExtBtrieveJCLines.Filter03(const B_Func, Fnum, Keypath: Integer;
  var KeyS: Str255; const FJobcode, FAnalysisCode: ShortString;
  const FYear, FPeriod: Byte; const Status: TPostedStatus): Integer;
{
  Exact match for JobCode, AnalCode, Year, and Period;
  Currency = Any
}
begin

  // Build the Extended Btrieve structures
  ExtSNObj.Prime_InitRec(
    SearchRec^.Filter.FilterN7.ExtendHead,
    SearchRec^.Filter.FilterN7.ExtendTail,
    Fnum,
    Sizeof(SearchRec^.Filter.FilterN7)
  );

  SearchRec^.Filter.FilterN7.ExtendHead.NumTerms := 6;

  // Prefix and SubType
  SetHeaderKey(
    SearchRec^.Filter.FilterN7.Term1,
    SearchRec^.Filter.FilterN7.Compare1
  );

  // Job Code      = XX
  // Analysis Code = XX
  SetAnalysisKeyFilter(
    SearchRec^.Filter.FilterN7.Term2,
    SearchRec^.Filter.FilterN7.Compare2,
    FJobCode,
    FAnalysisCode
  );

  // Currency >= 0 (i.e. any)
  SetCurrencyFilter(
    SearchRec^.Filter.FilterN7.Term3,
    SearchRec^.Filter.FilterN7.Compare3,
    0,
    cmpGreaterThanOrEqual
  );

  // Year = XX
  SetYearFilter(
    SearchRec^.Filter.FilterN7.Term4,
    SearchRec^.Filter.FilterN7.Compare4,
    FYear,
    cmpEqual
  );

  // Period = XX
  SetPeriodFilter(
    SearchRec^.Filter.FilterN7.Term5,
    SearchRec^.Filter.FilterN7.Compare5,
    FPeriod,
    cmpEqual
  );

  // Posted or Committed
  SetPostedFilter(
    SearchRec^.Filter.FilterN7.Term6,
    SearchRec^.Filter.FilterN7.Compare6,
    Status,
    lexLastTerm
  );

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end;

function TExtBtrieveJCLines.Filter04(const B_Func, Fnum, Keypath: Integer;
  var KeyS: Str255; const FJobcode, FAnalysisCode: ShortString;
  const FYear: Byte; const Status: TPostedStatus): Integer;
{
  Exact match for JobCode, AnalCode, and Year;
  Currency = Any;
  Period = Any
}
begin

  // Build the Extended Btrieve structures
  ExtSNObj.Prime_InitRec(
    SearchRec^.Filter.FilterN7.ExtendHead,
    SearchRec^.Filter.FilterN7.ExtendTail,
    Fnum,
    Sizeof(SearchRec^.Filter.FilterN7)
  );

  SearchRec^.Filter.FilterN7.ExtendHead.NumTerms := 6;

  // Prefix and SubType
  SetHeaderKey(
    SearchRec^.Filter.FilterN7.Term1,
    SearchRec^.Filter.FilterN7.Compare1
  );

  // Job Code      = XX
  // Analysis Code = XX
  SetAnalysisKeyFilter(
    SearchRec^.Filter.FilterN7.Term2,
    SearchRec^.Filter.FilterN7.Compare2,
    FJobCode,
    FAnalysisCode
  );

  // Currency >= 0 (i.e. any)
  SetCurrencyFilter(
    SearchRec^.Filter.FilterN7.Term3,
    SearchRec^.Filter.FilterN7.Compare3,
    0,
    cmpGreaterThanOrEqual
  );

  // Year = XX
  SetYearFilter(
    SearchRec^.Filter.FilterN7.Term4,
    SearchRec^.Filter.FilterN7.Compare4,
    FYear,
    cmpEqual
  );

  // Period > 0 (i.e. any)
  SetPeriodFilter(
    SearchRec^.Filter.FilterN7.Term5,
    SearchRec^.Filter.FilterN7.Compare5,
    0,
    cmpGreaterThan
  );

  // Posted or Committed
  SetPostedFilter(
    SearchRec^.Filter.FilterN7.Term6,
    SearchRec^.Filter.FilterN7.Compare6,
    Status,
    lexLastTerm
  );

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end;

function TExtBtrieveJCLines.Filter05(const B_Func, Fnum, Keypath: Integer;
  var KeyS: Str255; const FJobcode, FAnalysisCode: ShortString;
  const FYear, FPeriod: Byte; const Status: TPostedStatus): Integer;
{
  Exact match for JobCode, AnalCode, and Year;
  Period <= Specified;
  Currency = Any
}
begin

  // Build the Extended Btrieve structures
  ExtSNObj.Prime_InitRec(
    SearchRec^.Filter.FilterN7.ExtendHead,
    SearchRec^.Filter.FilterN7.ExtendTail,
    Fnum,
    Sizeof(SearchRec^.Filter.FilterN7)
  );

  SearchRec^.Filter.FilterN7.ExtendHead.NumTerms := 6;

  // Prefix and SubType
  SetHeaderKey(
    SearchRec^.Filter.FilterN7.Term1,
    SearchRec^.Filter.FilterN7.Compare1
  );

  // Job Code      = XX
  // Analysis Code = XX
  SetAnalysisKeyFilter(
    SearchRec^.Filter.FilterN7.Term2,
    SearchRec^.Filter.FilterN7.Compare2,
    FJobCode,
    FAnalysisCode
  );

  // Currency >= 0 (i.e. any)
  SetCurrencyFilter(
    SearchRec^.Filter.FilterN7.Term3,
    SearchRec^.Filter.FilterN7.Compare3,
    0,
    cmpGreaterThanOrEqual
  );

  // Year = XX
  SetYearFilter(
    SearchRec^.Filter.FilterN7.Term4,
    SearchRec^.Filter.FilterN7.Compare4,
    FYear,
    cmpEqual
  );

  // Period <= Specified
  SetPeriodFilter(
    SearchRec^.Filter.FilterN7.Term5,
    SearchRec^.Filter.FilterN7.Compare5,
    FPeriod,
    cmpLessThanOrEqual
  );

  // Posted or Committed
  SetPostedFilter(
    SearchRec^.Filter.FilterN7.Term6,
    SearchRec^.Filter.FilterN7.Compare6,
    Status,
    lexLastTerm
  );

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end;

function TExtBtrieveJCLines.Filter06(const B_Func, Fnum, Keypath: Integer;
  var KeyS: Str255; const FJobcode: ShortString; const FJAType: Integer;
  const FCurrency, FYear: Byte; const Status: TPostedStatus): Integer;
{
  Exact match for JobCode, JAType, and Currency;
  Year <= Specified;
  Period = Any
}
begin
  // Build the Extended Btrieve structures
  ExtSNObj.Prime_InitRec(
    SearchRec^.Filter.FilterN8.ExtendHead,
    SearchRec^.Filter.FilterN8.ExtendTail,
    Fnum,
    Sizeof(SearchRec^.Filter.FilterN8)
  );

  SearchRec^.Filter.FilterN8.ExtendHead.NumTerms := 6;

  // Prefix and SubType
  SetHeaderKey(
    SearchRec^.Filter.FilterN8.Term1,
    SearchRec^.Filter.FilterN8.Compare1
  );

  // Job Code = XX
  // JA Type  = XX
  SetJATypeFilter(
    SearchRec^.Filter.FilterN8.Term2,
    SearchRec^.Filter.FilterN8.Compare2,
    FJobCode,
    FJAType
  );

  // Currency = XX
  SetCurrencyFilter(
    SearchRec^.Filter.FilterN8.Term3,
    SearchRec^.Filter.FilterN8.Compare3,
    FCurrency
  );

  // Year <= XX
  SetYearFilter(
    SearchRec^.Filter.FilterN8.Term4,
    SearchRec^.Filter.FilterN8.Compare4,
    FYear,
    cmpLessThanOrEqual
  );

  // Period > 0 (i.e. any)
  SetPeriodFilter(
    SearchRec^.Filter.FilterN8.Term5,
    SearchRec^.Filter.FilterN8.Compare5,
    0,
    cmpGreaterThan
  );

  // Posted or Committed
  SetPostedFilter(
    SearchRec^.Filter.FilterN8.Term6,
    SearchRec^.Filter.FilterN8.Compare6,
    Status,
    lexLastTerm
  );

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end;

function TExtBtrieveJCLines.Filter07(const B_Func, Fnum, Keypath: Integer;
  var KeyS: Str255; const FJobcode: ShortString; const FJAType: Integer;
  const FCurrency, FYear, FPeriod: Byte;
  const Status: TPostedStatus): Integer;
{
  Exact match for JobCode, JAType, and Year
  Period <= Specified;
  Currency = Specified
}
begin
  // Build the Extended Btrieve structures
  ExtSNObj.Prime_InitRec(
    SearchRec^.Filter.FilterN8.ExtendHead,
    SearchRec^.Filter.FilterN8.ExtendTail,
    Fnum,
    Sizeof(SearchRec^.Filter.FilterN8)
  );

  SearchRec^.Filter.FilterN8.ExtendHead.NumTerms := 6;

  // Prefix and SubType
  SetHeaderKey(
    SearchRec^.Filter.FilterN8.Term1,
    SearchRec^.Filter.FilterN8.Compare1
  );

  // Job Code = XX
  // JA Type  = XX
  SetJATypeFilter(
    SearchRec^.Filter.FilterN8.Term2,
    SearchRec^.Filter.FilterN8.Compare2,
    FJobCode,
    FJAType
  );

  // Currency = XX
  SetCurrencyFilter(
    SearchRec^.Filter.FilterN8.Term3,
    SearchRec^.Filter.FilterN8.Compare3,
    FCurrency,
    cmpEqual
  );

  // Year = XX
  SetYearFilter(
    SearchRec^.Filter.FilterN8.Term4,
    SearchRec^.Filter.FilterN8.Compare4,
    FYear
  );

  // Period <= XX
  SetPeriodFilter(
    SearchRec^.Filter.FilterN8.Term5,
    SearchRec^.Filter.FilterN8.Compare5,
    FPeriod,
    cmpLessThanOrEqual
  );

  // Posted or Committed
  SetPostedFilter(
    SearchRec^.Filter.FilterN8.Term6,
    SearchRec^.Filter.FilterN8.Compare6,
    Status,
    lexLastTerm
  );

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end;

function TExtBtrieveJCLines.Filter08(const B_Func, Fnum, Keypath: Integer;
  var KeyS: Str255; const FJobcode: ShortString; const FJAType: Integer;
  const FYear, FPeriod: Byte;
  const Status: TPostedStatus): Integer;
{
  Exact match for JobCode, JAType, Year, and Period;
  Currency = Any
}
begin
  // Build the Extended Btrieve structures
  ExtSNObj.Prime_InitRec(
    SearchRec^.Filter.FilterN8.ExtendHead,
    SearchRec^.Filter.FilterN8.ExtendTail,
    Fnum,
    Sizeof(SearchRec^.Filter.FilterN8)
  );

  SearchRec^.Filter.FilterN8.ExtendHead.NumTerms := 6;

  // Prefix and SubType
  SetHeaderKey(
    SearchRec^.Filter.FilterN8.Term1,
    SearchRec^.Filter.FilterN8.Compare1
  );

  // Job Code = XX
  // JA Type  = XX
  SetJATypeFilter(
    SearchRec^.Filter.FilterN8.Term2,
    SearchRec^.Filter.FilterN8.Compare2,
    FJobCode,
    FJAType
  );

  // Currency >= 0 (i.e. any)
  SetCurrencyFilter(
    SearchRec^.Filter.FilterN8.Term3,
    SearchRec^.Filter.FilterN8.Compare3,
    0,
    cmpGreaterThanOrEqual
  );

  // Year = XX
  SetYearFilter(
    SearchRec^.Filter.FilterN8.Term4,
    SearchRec^.Filter.FilterN8.Compare4,
    FYear
  );

  // Period = XX
  SetPeriodFilter(
    SearchRec^.Filter.FilterN8.Term5,
    SearchRec^.Filter.FilterN8.Compare5,
    FPeriod
  );

  // Posted or Committed
  SetPostedFilter(
    SearchRec^.Filter.FilterN8.Term6,
    SearchRec^.Filter.FilterN8.Compare6,
    Status,
    lexLastTerm
  );

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end;

function TExtBtrieveJCLines.Filter09(const B_Func, Fnum, Keypath: Integer;
  var KeyS: Str255; const FJobcode: ShortString; const FJAType: Integer;
  const FYear: Byte; const Status: TPostedStatus): Integer;
{
  Exact match for JobCode, and JAType;
  Year <= Specified;
  Period = Any;
  Currency = Any
}
begin
  // Build the Extended Btrieve structures
  ExtSNObj.Prime_InitRec(
    SearchRec^.Filter.FilterN8.ExtendHead,
    SearchRec^.Filter.FilterN8.ExtendTail,
    Fnum,
    Sizeof(SearchRec^.Filter.FilterN8)
  );

  SearchRec^.Filter.FilterN8.ExtendHead.NumTerms := 6;

  // Prefix and SubType
  SetHeaderKey(
    SearchRec^.Filter.FilterN8.Term1,
    SearchRec^.Filter.FilterN8.Compare1
  );

  // Job Code = XX
  // JA Type  = XX
  SetJATypeFilter(
    SearchRec^.Filter.FilterN8.Term2,
    SearchRec^.Filter.FilterN8.Compare2,
    FJobCode,
    FJAType
  );

  // Currency >= 0 (i.e. any)
  SetCurrencyFilter(
    SearchRec^.Filter.FilterN8.Term3,
    SearchRec^.Filter.FilterN8.Compare3,
    0,
    cmpGreaterThanOrEqual
  );

  // Year <= XX
  SetYearFilter(
    SearchRec^.Filter.FilterN8.Term4,
    SearchRec^.Filter.FilterN8.Compare4,
    FYear,
    cmpLessThanOrEqual
  );

  // Period > 0 (i.e. any)
  SetPeriodFilter(
    SearchRec^.Filter.FilterN8.Term5,
    SearchRec^.Filter.FilterN8.Compare5,
    0,
    cmpGreaterThan
  );

  // Posted or Committed
  SetPostedFilter(
    SearchRec^.Filter.FilterN8.Term6,
    SearchRec^.Filter.FilterN8.Compare6,
    Status,
    lexLastTerm
  );

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end;

function TExtBtrieveJCLines.Filter10(const B_Func, Fnum, Keypath: Integer;
  var KeyS: Str255; const FJobcode: ShortString; const FJAType: Integer;
  const FYear, FPeriod: Byte; const Status: TPostedStatus): Integer;
{
  Exact match for JobCode, JAType, and Year
  Period <= Specified;
  Currency = Any
}
begin
  // Build the Extended Btrieve structures
  ExtSNObj.Prime_InitRec(
    SearchRec^.Filter.FilterN8.ExtendHead,
    SearchRec^.Filter.FilterN8.ExtendTail,
    Fnum,
    Sizeof(SearchRec^.Filter.FilterN8)
  );

  SearchRec^.Filter.FilterN8.ExtendHead.NumTerms := 6;

  // Prefix and SubType
  SetHeaderKey(
    SearchRec^.Filter.FilterN8.Term1,
    SearchRec^.Filter.FilterN8.Compare1
  );

  // Job Code = XX
  // JA Type  = XX
  SetJATypeFilter(
    SearchRec^.Filter.FilterN8.Term2,
    SearchRec^.Filter.FilterN8.Compare2,
    FJobCode,
    FJAType
  );

  // Currency >= 0 (i.e. any)
  SetCurrencyFilter(
    SearchRec^.Filter.FilterN8.Term3,
    SearchRec^.Filter.FilterN8.Compare3,
    0,
    cmpGreaterThanOrEqual
  );

  // Year = XX
  SetYearFilter(
    SearchRec^.Filter.FilterN8.Term4,
    SearchRec^.Filter.FilterN8.Compare4,
    FYear
  );

  // Period <= XX
  SetPeriodFilter(
    SearchRec^.Filter.FilterN8.Term5,
    SearchRec^.Filter.FilterN8.Compare5,
    FPeriod,
    cmpLessThanOrEqual
  );

  // Posted or Committed
  SetPostedFilter(
    SearchRec^.Filter.FilterN8.Term6,
    SearchRec^.Filter.FilterN8.Compare6,
    Status,
    lexLastTerm
  );

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end;

function TExtBtrieveJCLines.Filter11(const B_Func, Fnum, Keypath: Integer;
  var KeyS: Str255; const FJobcode, FStockCode: ShortString;
  const FCurrency, FYear: Byte; const Status: TPostedStatus): Integer;
{
  Exact match for JobCode, StockCode, Currency;
  Year <= Specified;
  Period = Any
}
begin

  // Build the Extended Btrieve structures
  ExtSNObj.Prime_InitRec(
    SearchRec^.Filter.FilterN9.ExtendHead,
    SearchRec^.Filter.FilterN9.ExtendTail,
    Fnum,
    Sizeof(SearchRec^.Filter.FilterN9)
  );

  SearchRec^.Filter.FilterN9.ExtendHead.NumTerms := 6;

  // Prefix and SubType
  SetHeaderKey(
    SearchRec^.Filter.FilterN9.Term1,
    SearchRec^.Filter.FilterN9.Compare1
  );

  // Job Code   = XX
  // Stock Code = XX
  SetStockKeyFilter(
    SearchRec^.Filter.FilterN9.Term2,
    SearchRec^.Filter.FilterN9.Compare2,
    FJobCode,
    FStockCode
  );

  // Currency = XX
  SetCurrencyFilter(
    SearchRec^.Filter.FilterN9.Term3,
    SearchRec^.Filter.FilterN9.Compare3,
    FCurrency
  );

  // Year <= XX
  SetYearFilter(
    SearchRec^.Filter.FilterN9.Term4,
    SearchRec^.Filter.FilterN9.Compare4,
    FYear,
    cmpLessThanOrEqual
  );

  // Period > 0 (i.e. any period)
  SetPeriodFilter(
    SearchRec^.Filter.FilterN9.Term5,
    SearchRec^.Filter.FilterN9.Compare5,
    0,
    cmpGreaterThan
  );

  // Posted or Committed
  SetPostedFilter(
    SearchRec^.Filter.FilterN9.Term6,
    SearchRec^.Filter.FilterN9.Compare6,
    Status,
    lexLastTerm
  );

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end;

function TExtBtrieveJCLines.Filter12(const B_Func, Fnum, Keypath: Integer;
  var KeyS: Str255; const FJobcode, FStockCode: ShortString;
  const FCurrency, FYear, FPeriod: Byte;
  const Status: TPostedStatus): Integer;
{
  Exact match for JobCode, StockCode, Currency, and Year;
  Period <= Specified
}
begin

  // Build the Extended Btrieve structures
  ExtSNObj.Prime_InitRec(
    SearchRec^.Filter.FilterN9.ExtendHead,
    SearchRec^.Filter.FilterN9.ExtendTail,
    Fnum,
    Sizeof(SearchRec^.Filter.FilterN9)
  );

  SearchRec^.Filter.FilterN9.ExtendHead.NumTerms := 6;

  // Prefix and SubType
  SetHeaderKey(
    SearchRec^.Filter.FilterN9.Term1,
    SearchRec^.Filter.FilterN9.Compare1
  );

  // Job Code   = XX
  // Stock Code = XX
  SetStockKeyFilter(
    SearchRec^.Filter.FilterN9.Term2,
    SearchRec^.Filter.FilterN9.Compare2,
    FJobCode,
    FStockCode
  );

  // Currency = XX
  SetCurrencyFilter(
    SearchRec^.Filter.FilterN9.Term3,
    SearchRec^.Filter.FilterN9.Compare3,
    FCurrency
  );

  // Year = XX
  SetYearFilter(
    SearchRec^.Filter.FilterN9.Term4,
    SearchRec^.Filter.FilterN9.Compare4,
    FYear
  );

  // Period <= XX
  SetPeriodFilter(
    SearchRec^.Filter.FilterN9.Term5,
    SearchRec^.Filter.FilterN9.Compare5,
    FPeriod,
    cmpLessThanOrEqual
  );

  // Posted or Committed
  SetPostedFilter(
    SearchRec^.Filter.FilterN9.Term6,
    SearchRec^.Filter.FilterN9.Compare6,
    Status,
    lexLastTerm
  );

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end;

function TExtBtrieveJCLines.Filter13(const B_Func, Fnum, Keypath: Integer;
  var KeyS: Str255; const FJobcode, FStockCode: ShortString; const FYear,
  FPeriod: Byte; const Status: TPostedStatus): Integer;
{
  Exact match for JobCode, StockCode, Year, and Period;
  Currency = Any
}
begin

  // Build the Extended Btrieve structures
  ExtSNObj.Prime_InitRec(
    SearchRec^.Filter.FilterN9.ExtendHead,
    SearchRec^.Filter.FilterN9.ExtendTail,
    Fnum,
    Sizeof(SearchRec^.Filter.FilterN9)
  );

  SearchRec^.Filter.FilterN9.ExtendHead.NumTerms := 6;

  // Prefix and SubType
  SetHeaderKey(
    SearchRec^.Filter.FilterN9.Term1,
    SearchRec^.Filter.FilterN9.Compare1
  );

  // Job Code   = XX
  // Stock Code = XX
  SetStockKeyFilter(
    SearchRec^.Filter.FilterN9.Term2,
    SearchRec^.Filter.FilterN9.Compare2,
    FJobCode,
    FStockCode
  );

  // Currency >= 0 (i.e. any)
  SetCurrencyFilter(
    SearchRec^.Filter.FilterN9.Term3,
    SearchRec^.Filter.FilterN9.Compare3,
    0,
    cmpGreaterThanOrEqual
  );

  // Year = XX
  SetYearFilter(
    SearchRec^.Filter.FilterN9.Term4,
    SearchRec^.Filter.FilterN9.Compare4,
    FYear
  );

  // Period = XX
  SetPeriodFilter(
    SearchRec^.Filter.FilterN9.Term5,
    SearchRec^.Filter.FilterN9.Compare5,
    FPeriod
  );

  // Posted or Committed
  SetPostedFilter(
    SearchRec^.Filter.FilterN9.Term6,
    SearchRec^.Filter.FilterN9.Compare6,
    Status,
    lexLastTerm
  );

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end;

function TExtBtrieveJCLines.Filter14(const B_Func, Fnum, Keypath: Integer;
  var KeyS: Str255; const FJobcode, FStockCode: ShortString;
  const FYear: Byte; const Status: TPostedStatus): Integer;
{
  Exact match for JobCode, AnalCode, and Year;
  Period = Any;
  Currency = Any
}
begin

  // Build the Extended Btrieve structures
  ExtSNObj.Prime_InitRec(
    SearchRec^.Filter.FilterN9.ExtendHead,
    SearchRec^.Filter.FilterN9.ExtendTail,
    Fnum,
    Sizeof(SearchRec^.Filter.FilterN9)
  );

  SearchRec^.Filter.FilterN9.ExtendHead.NumTerms := 6;

  // Prefix and SubType
  SetHeaderKey(
    SearchRec^.Filter.FilterN9.Term1,
    SearchRec^.Filter.FilterN9.Compare1
  );

  // Job Code   = XX
  // Stock Code = XX
  SetStockKeyFilter(
    SearchRec^.Filter.FilterN9.Term2,
    SearchRec^.Filter.FilterN9.Compare2,
    FJobCode,
    FStockCode
  );

  // Currency >= 0 (i.e. any)
  SetCurrencyFilter(
    SearchRec^.Filter.FilterN9.Term3,
    SearchRec^.Filter.FilterN9.Compare3,
    0,
    cmpGreaterThanOrEqual
  );

  // Year = XX
  SetYearFilter(
    SearchRec^.Filter.FilterN9.Term4,
    SearchRec^.Filter.FilterN9.Compare4,
    FYear
  );

  // Period > 0 (i.e. any)
  SetPeriodFilter(
    SearchRec^.Filter.FilterN9.Term5,
    SearchRec^.Filter.FilterN9.Compare5,
    0,
    cmpGreaterThan
  );

  // Posted or Committed
  SetPostedFilter(
    SearchRec^.Filter.FilterN9.Term6,
    SearchRec^.Filter.FilterN9.Compare6,
    Status,
    lexLastTerm
  );

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end;

function TExtBtrieveJCLines.Filter15(const B_Func, Fnum, Keypath: Integer;
  var KeyS: Str255; const FJobcode, FStockCode: ShortString; const FYear,
  FPeriod: Byte; const Status: TPostedStatus): Integer;
{
  Exact match for JobCode, StockCode, and Year;
  Period <= Specified;
  Currency = Any
}
begin

  // Build the Extended Btrieve structures
  ExtSNObj.Prime_InitRec(
    SearchRec^.Filter.FilterN9.ExtendHead,
    SearchRec^.Filter.FilterN9.ExtendTail,
    Fnum,
    Sizeof(SearchRec^.Filter.FilterN9)
  );

  SearchRec^.Filter.FilterN9.ExtendHead.NumTerms := 6;

  // Prefix and SubType
  SetHeaderKey(
    SearchRec^.Filter.FilterN9.Term1,
    SearchRec^.Filter.FilterN9.Compare1
  );

  // Job Code   = XX
  // Stock Code = XX
  SetStockKeyFilter(
    SearchRec^.Filter.FilterN9.Term2,
    SearchRec^.Filter.FilterN9.Compare2,
    FJobCode,
    FStockCode
  );

  // Currency >= 0 (i.e. any)
  SetCurrencyFilter(
    SearchRec^.Filter.FilterN9.Term3,
    SearchRec^.Filter.FilterN9.Compare3,
    0,
    cmpGreaterThanOrEqual
  );

  // Year = XX
  SetYearFilter(
    SearchRec^.Filter.FilterN9.Term4,
    SearchRec^.Filter.FilterN9.Compare4,
    FYear
  );

  // Period <= XX
  SetPeriodFilter(
    SearchRec^.Filter.FilterN9.Term5,
    SearchRec^.Filter.FilterN9.Compare5,
    FPeriod,
    cmpLessThanOrEqual
  );

  // Posted or Committed
  SetPostedFilter(
    SearchRec^.Filter.FilterN9.Term6,
    SearchRec^.Filter.FilterN9.Compare6,
    Status,
    lexLastTerm
  );

  // Call generic Search routine in base class to do the Extended Btrieve call
  Result := ExtSNObj.GetSearchRec(B_Func, Fnum, Keypath, Sizeof(SearchRec^), SearchRec, KeyS);
end;

constructor TExtBtrieveJCLines.Init;
begin
  ExtSNObj.Init;
end;

procedure TExtBtrieveJCLines.SetAnalysisKeyFilter(var Term: FilterRepeatType;
  var Compare: TAnalysisKey; const JobCode, AnalysisCode: ShortString;
  const CompCode: TExtBtrCompareMode; const LogicEx: TExtBtrLogicExpression);
begin
  // Job Code = xx
  // Analysis Code = xx
  with Term do
  begin
    FieldType   := BString;
    FieldLen    := Sizeof(SearchRec^.Filter.FilterN7.Compare2);
    FieldOffset := BtKeyPos(@JobDetl.JobActual.AnalKey, JobDetl);
    CompareCode := Ord(CompCode);
    LogicExpres := Ord(LogicEx);
  end;
  FillChar(Compare[1], 20, #32);
  Move(JobCode[1],      Compare[1],  Length(JobCode));
  Move(AnalysisCode[1], Compare[11], Length(AnalysisCode));
end;

procedure TExtBtrieveJCLines.SetBudgetedFilter(var Term: FilterRepeatType;
  var Compare: Byte; const Budgeted: Byte;
  const CompCode: TExtBtrCompareMode;
  const LogicEx: TExtBtrLogicExpression);
begin
  with Term do
  begin
    FieldType   := BString;
    FieldLen    := Sizeof(Compare);
    FieldOffset := BtKeyPos(@JobDetl.JobActual.Post2Stk, JobDetl);
    CompareCode := Ord(CompCode);
    LogicExpres := Ord(LogicEx);
  end; { With Term }
  Move(Budgeted, Compare, Sizeof(Compare));
end;

procedure TExtBtrieveJCLines.SetCurrencyFilter(var Term: FilterRepeatType;
  var Compare: Char; const Currency: Byte;
  const CompCode: TExtBtrCompareMode;
  const LogicEx: TExtBtrLogicExpression);
begin
  // Currency = XX
  with Term do
  begin
    FieldType   := BString;
    FieldLen    := Sizeof(Compare);
    FieldOffset := BtKeyPos(@JobDetl.JobActual.ActCurr, JobDetl) - 1;
    CompareCode := Ord(CompCode);
    LogicExpres := Ord(LogicEx);
  end; { With Term }
  Compare := Chr(Currency);
end;

procedure TExtBtrieveJCLines.SetHeaderKey(var Term: FilterRepeatType;
  var Compare: THeaderKey);
begin
  with Term do
  begin
    FieldType   := BString;
    FieldLen    := Sizeof(Compare);
    FieldOffset := BtKeyPos(@JobDetl.RecPFix, JobDetl) - 1;
    CompareCode := Ord(cmpEqual);
    LogicExpres := Ord(lexAND);
  end; { With Term }
  Compare[1] := JobDetl.RecPfix;
  Compare[2] := JobDetl.SubType;
end;

procedure TExtBtrieveJCLines.SetJATypeFilter(var Term: FilterRepeatType;
  var Compare: TJATypeKey; const JobCode: ShortString;
  const JAType: Integer; const CompCode: TExtBtrCompareMode;
  const LogicEx: TExtBtrLogicExpression);
var
  JATypeKey: ShortString;
begin
  with Term do
  begin
    FieldType   := BString;
    FieldLen    := Sizeof(Compare);
    FieldOffset := BtKeyPos(@JobDetl.JobActual.HedKey, JobDetl);
    CompareCode := Ord(CompCode);
    LogicExpres := Ord(LogicEx);
  end;
  FillChar(Compare[1], SizeOf(Compare), #32);
  Move(JobCode[1], Compare[1], Length(JobCode));
  JATypeKey := FullNomKey(JAType);
  Move(JATypeKey[1], Compare[11], Length(JATypeKey));
end;

procedure TExtBtrieveJCLines.SetPeriodFilter(var Term: FilterRepeatType;
  var Compare: Char; const Period: Byte;
  const CompCode: TExtBtrCompareMode;
  const LogicEx: TExtBtrLogicExpression);
begin
  // Period = XX
  with Term do
  begin
    FieldType   := BString;
    FieldLen    := Sizeof(Compare);
    FieldOffset := BtKeyPos(@JobDetl.JobActual.ActPr, JobDetl) - 1;
    CompareCode := Ord(CompCode);
    LogicExpres := Ord(LogicEx);
  end; { With Term }
  Compare := Chr(Period);
end;

procedure TExtBtrieveJCLines.SetPostedFilter(var Term: FilterRepeatType;
  var Compare: TRunNoKey; const Status: TPostedStatus;
  const LogicEx: TExtBtrLogicExpression);
var
  RunStr: Str20;
  CompCode: TExtBtrCompareMode;
begin
  case Status of
    psPosted:
      begin
        RunStr   := FullNomKey(0);
        CompCode := cmpGreaterThanOrEqual;
      end;
    psCommitted:
      begin
        RunStr   := FullNomKey(OrdPPRunNo);
        CompCode := cmpEqual;
      end;
    psAll:
      begin
        RunStr   := FullNomKey(-$FFFFFF);
        CompCode := cmpGreaterThanOrEqual;
      end;
  end;
  with Term do
  begin
    FieldType   := BString;
    FieldLen    := Sizeof(Compare);
    FieldOffset := BtKeyPos(@JobDetl.JobActual.PostedRun, JobDetl) - 1;
    CompareCode := Ord(CompCode);
    LogicExpres := Ord(LogicEx);
  end; { With Term }
  Move(RunStr[1], Compare[1], Sizeof(Compare));
end;

procedure TExtBtrieveJCLines.SetStockKeyFilter(var Term: FilterRepeatType;
  var Compare: TStockKey; const JobCode, StockCode: ShortString;
  const CompCode: TExtBtrCompareMode;
  const LogicEx: TExtBtrLogicExpression);
begin
  // Job Code = xx
  // Stock Code = xx
  with Term do
  begin
    FieldType   := BString;
    FieldLen    := Sizeof(Compare);
    FieldOffset := BtKeyPos(@JobDetl.JobActual.StockKey, JobDetl);
    CompareCode := Ord(CompCode);
    LogicExpres := Ord(LogicEx);
  end;
  FillChar(Compare[1], SizeOf(Compare), #32);
  Move(JobCode[1],   Compare[1],  Length(JobCode));
  Move(StockCode[1], Compare[11], Length(StockCode));
end;

procedure TExtBtrieveJCLines.SetYearFilter(var Term: FilterRepeatType;
  var Compare: Char; const Year: Byte; const CompCode: TExtBtrCompareMode;
  const LogicEx: TExtBtrLogicExpression);
begin
  // Year = XX
  with Term do
  begin
    FieldType   := BString;
    FieldLen    := Sizeof(Compare);
    FieldOffset := BtKeyPos(@JobDetl.JobActual.ActYr, JobDetl) - 1;
    CompareCode := Ord(CompCode);
    LogicExpres := Ord(LogicEx);
  end; { With Term }
  Compare := Chr(Year);
end;

initialization
{
ShowMessage(
  'AnalKey: ' + IntToStr(BtKeyPos(@JobDetl.JobActual.AnalKey, JobDetl)) +
  #13#10 +
  'Currency: ' + IntToStr(BtKeyPos(@JobDetl.JobActual.ActCurr, JobDetl)) +
  #13#10 +
  'Year: ' + IntToStr(BtKeyPos(@JobDetl.JobActual.ActYr, JobDetl)) +
  #13#10 +
  'HedKey: ' + IntToStr(BtKeyPos(@JobDetl.JobActual.HedKey, JobDetl)) +
  #13#10 +
  'StockKey: ' + IntToStr(BtKeyPos(@JobDetl.JobActual.StockKey, JobDetl)) +
  #13#10 +
  'Period: ' + IntToStr(BtKeyPos(@JobDetl.JobActual.ActPr, JobDetl))
  );
}
end.


