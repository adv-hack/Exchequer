unit ProcFunc;

{$ALIGN 1}

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows,
     VarRec2U,
     oDrill,              // Drill-Down COM Object
     FuncParser,          // Global Function Parser object
     FuncList,      // FunctionList Object
     EntData,              // EntData object
     EBJCLine,
     EBStockLine,
     EBCustLine,
     DrillConst;

Type
  // Local types to simplify parameters
  TCompanyCode  = String[6];
  TCurrency     = Byte;
  TGLCode       = LongInt;
  TGLFilterSet  = Set Of Char;
  TPeriod       = SmallInt;
  TYear         = SmallInt;
  TCustCode     = string[6];
  TCCDept       = String[3];
  TJobCode      = String[10];
  TStockCode    = String[16];
  TAnalysisCode = String[10];
  TLocationCode = String[3];
  TAccountCode  = String[6];
  TJAType       = Integer;
  TGLView       = Integer;
  TGLLineCode   = ShortString;

  // Enumeration identifying the type of parameter
  TParamType = (ptString);

  // Enumeration for result of processing the parsed formula in ProcessFormula
  TProcessFormulaResult = (frNoAction, frDrillOK, frUpdateFormula, frException);

  // The FunctionParser object is used to break down an drill-down string into
  // its component parts - FunctionName & Parameters.
  TProcessFunction = class(TObject)
  private
    // Reference to Parent IDrillDown object to allow direct communication
    // to Excel for resolving cell references, etc...
    FDrillo : TDrillDown;

    // Reference to FunctionParser containing details of the Formula
    FFuncParser : TFunctionParser;

    function CategoryToJAType(Category: Integer): TJAType;

    // Parameter resolution routines
    function ResolveDateParameter (CodeParam: ShortString; var ParamDate: TDateTime) : Boolean;
    function ResolveIntParameter (CodeParam : ShortString; var ParamInt : Integer) : Boolean;
    function ResolveStringParameter (CodeParam : ShortString; var ParamStr : ShortString) : Boolean;

    // Data Resolution routines
    function ResolveAccountCode(CodeParam: ShortString;
      var AccountCode: TAccountCode; AllowBlank: Boolean = False): Boolean;
    function ResolveAgeBy(CodeParam: ShortString; var AgeBy: Char): Boolean;
    function ResolveAnalysisCode(CodeParam: ShortString;
      var AnalysisCode: TAnalysisCode; AllowBlank: Boolean = False): Boolean;
    function ResolveCompanyCode(CodeParam: ShortString;
      var CompDets: TCompanyDetails): Boolean;
    function ResolveCCDept (CodeParam: ShortString; var CCDept: TCCDept;
      const WantCC: Boolean; AllowBlank: Boolean = False): Boolean;
    function ResolveCurrency(CodeParam: ShortString;
      var Currency : TCurrency) : Boolean;
    function ResolveCustCode(CodeParam: ShortString;
      var CustCode: TCustCode; AllowBlank: Boolean = False): Boolean;
    function ResolveGLCode(CodeParam: ShortString; var GLCode: TGLCode;
      var GLDesc: ShortString; var GLType: Char;
      const FilterSet: TGLFilterSet = []) : Boolean;
    function ResolveGLView (CodeParam: ShortString;
      var GLView: TGLView; var CostCentre: TCCDept; var Department: TCCDept) : Boolean;
    function ResolveGLLineCode(CodeParam: ShortString;
      var GLView: TGLView; var GLLineCode: TGLLineCode; var GLCode: TGLCode) : Boolean;
    function ResolveJAType(CodeParam: ShortString;
      var JAType: TJAType): Boolean;
    function ResolveJobCode(CodeParam: ShortString;
      var JobCode: TJobCode): Boolean;
    function ResolveLocation(CodeParam: ShortString;
      var Location: TLocationCode; AllowBlank: Boolean = False): Boolean;
    function ResolvePeriod (CodeParam: ShortString;
      var Period : TPeriod) : Boolean;
    function ResolvePeriods(CodeParam1, CodeParam2: ShortString;
      var StartPeriod, EndPeriod: TPeriod): Boolean;
    function ResolvePostedStatus(CodeParam: ShortString;
      var Status: TPostedStatus): Boolean;
    function ResolveStockCode(CodeParam: ShortString; var StockCode: TStockCode;
      AllowBlank: Boolean = False): Boolean;
    function ResolveYear(CodeParam: ShortString; var Year: TYear): Boolean;
    function ResolveYears(CodeParam1, CodeParam2: ShortString;
      var StartYear, EndYear: TYear): Boolean;

    // function processing routines
    function ProcessDataSelection : TProcessFormulaResult;
    function ProcessGLHistory (const FuncType : TEnumFunctionCategory) : TProcessFormulaResult;
    function ProcessGLViewHistory(const FuncType: TEnumFunctionCategory): TProcessFormulaResult;
    function ProcessJCHistory (const FuncType : TEnumFunctionCategory) : TProcessFormulaResult;
    function ProcessJCAnalysisActual(const FuncType: TEnumFunctionCategory): TProcessFormulaResult;
    function ProcessJCStockActual(const FuncType: TEnumFunctionCategory): TProcessFormulaResult;
    function ProcessJCTotActual(const FuncType: TEnumFunctionCategory): TProcessFormulaResult;
    function ProcessStkHistory(const FuncType: TEnumFunctionCategory): TProcessFormulaResult;
    function ProcessCustHistory(const FuncType: TEnumFunctionCategory): TProcessFormulaResult;

  public
    constructor Create (const oDrillDown: TDrillDown;
      const FunctionParser: TFunctionParser);
    destructor Destroy; override;

    function ProcessFormula : TProcessFormulaResult;
  end; { TProcessFunction }

implementation

uses
     GlobVar,       // Exchequer global const/type/var
     VarConst,      // Exchequer global const/type/var
     Comnu2,        // Exchequer Misc Routines
     NomLineF,      // Drill-Down Form for EntGL functions
     JobLineF,      // Drill-Down Form for EntJob functions
     JobActlF,      // Drill-Down Form for EntJC functions
     frmStockU,     // Drill-Down Form for Stock functions
     frmCustU,      // Drill-Down Form for Customer functions
     SelDataF,      // Drill-Down form for entSelect functions
     DrillLog;      // DrillDownLog object

//=========================================================================

constructor TProcessFunction.Create (Const oDrillDown : TDrillDown; Const FunctionParser : TFunctionParser);
begin { Create }
  inherited Create;

  // Make local copies of references to objects
  FDrillo := oDrillDown;
  FFuncParser := FunctionParser;
end; { Create }

//-------------------------

Destructor TProcessFunction.Destroy;
Begin { Destroy }
  // Remove local references to objects
  FFuncParser := NIL;
  FDrillo := NIL;

  Inherited;
End; { Destroy }

//-------------------------------------------------------------------------

// Attempts to resolve a parameter to a date value
function TProcessFunction.ResolveDateParameter(CodeParam: ShortString; var ParamDate: TDateTime) : Boolean;
Var
  CellValue, CellFormula : ShortString;
  ParamLen               : SmallInt;
  DateStr: ShortString;
Begin { ResolveStringParameter }
  // Initialise return result to failed
  Result := False;
  DateStr := '';

  // Check length of string before starting processing
  ParamLen := Length(CodeParam);
  If (ParamLen > 0) Then Begin
    // Check for a direct string parameter - "01/01/2000"
    If (CodeParam[1] = '"') And (CodeParam[ParamLen] = '"') Then Begin
      // Got string parameter - remove quotes and return value
      DateStr := Copy (CodeParam, 2, ParamLen - 2);
      Result := True;
    End { If (CodeParam[1] = '"') And (CodeParam[ParamLen] = '"') }
    Else Begin
      // Try Named Cells and Cell References - $B$7, CompanyCode, R1C1, ...
      CellValue   := '';
      CellFormula := '';
      If FDrillO.GetCellInfo (CodeParam, CellValue, CellFormula) Then Begin
        // Got a valid Cell value/formula
        DateStr := CellValue;
        Result := True;
      End; { If FDrillO.GetCellInfo }
    End; { Else }
    // If we have a valid string parameter, attempt to convert it to a date.
    if Result then
    begin
      ParamDate := StrToDateDef(DateStr, 0);
      if (ParamDate = 0) then
        Result := false;
    end;
  End; { If (ParamLen > 0) }
End; { ResolveStringParameter }

//-------------------------------------------------------------------------

// Indentifies the type of parameter and resolves it to a Integer value
Function TProcessFunction.ResolveIntParameter (CodeParam : ShortString; Var ParamInt : Integer) : Boolean;
Var
  CellValue, CellFormula : ShortString;
  ParamLen               : SmallInt;

  // Attempts to convert the string to an integer value, returns true if successful
  Function ConvStrValue (StrValue : ShortString; Var IntValue : Integer) : Boolean;
  Var
    ConvValue, ErrCode : Integer;
    ParamLen, I        : SmallInt;
  Begin { ConvStrValue }
    // Initialise return result to failed
    Result := False;
    ErrCode := 0;

    // Run through string checking for illegal characters and removing
    // any embedded comma's e.g. 2,000
    ParamLen := Length(StrValue);
    If (ParamLen > 0) Then Begin
      // Check for illegal characters
      For I := 1 To (ParamLen - 1) Do
        If (Not (StrValue[I] In ['0'..'9', ',', '-'])) Then Begin
          // Set error condition and exit loop
          ErrCode := 1;
          Break;
        End; { If (Not (StrValue[I] In ['0'..'9'])) }

      If (ErrCode = 0) Then Begin
        // Remove embedded comma's
        I := Pos (',', StrValue);
        While (I > 0) Do Begin
          Delete (StrValue, I, 1);
          I := Pos (',', StrValue);
        End; { While (I > 0) }
      End; { If (ErrCode = 0) }

      If (ErrCode = 0) Then Begin
        // Characters checked OK - try to convert to integer
        Val (StrValue, ConvValue, ErrCode);

        // Return True as function result if successful
        Result := (ErrCode = 0);
        If Result Then Begin
          // Got valid integer - return value
          ParamInt := ConvValue;
          Result := True;
        End; { If Result }
      End; { If (ErrCode = 0) }
    End; { If (ParamLen > 0) }
  End; { ConvStrValue }

Begin { ResolveIntParameter }
  // Initialise return result to failed
  Result := False;
  ParamInt := 0;

  // Check length of string before starting processing
  ParamLen := Length(CodeParam);
  If (ParamLen > 0) Then Begin
    // Integer parameters can be used within quotes in Excel - Check for
    // Quotes and remove if present
    If (CodeParam[1] = '"') And (CodeParam[ParamLen] = '"') Then Begin
      // Got string parameter - remove quotes and recalc len
      CodeParam := Copy (CodeParam, 2, ParamLen - 2);
    End; { If (CodeParam[1] = '"') And (CodeParam[ParamLen] = '"') }

    // Try to convert the string parameter to a number
    Result := ConvStrValue (CodeParam, ParamInt);
    If (Not Result) Then Begin
      // Try Named Cells and Cell References - $B$7, CompanyCode, R1C1, ...
      CellValue   := '';
      CellFormula := '';
      If FDrillO.GetCellInfo (CodeParam, CellValue, CellFormula) Then
        // Got a valid Cell value/formula
        Result := ConvStrValue (CellValue, ParamInt);
    End; { If (Not Result) }
  End; { If (ParamLen > 0) }
End; { ResolveIntParameter }

//-------------------------------------------------------------------------

// Identifies the type of parameter and resolves it to a string value
Function TProcessFunction.ResolveStringParameter (CodeParam : ShortString; Var ParamStr : ShortString) : Boolean;
Var
  CellValue, CellFormula : ShortString;
  ParamLen               : SmallInt;
Begin { ResolveStringParameter }
  // Initialise return result to failed
  Result := False;
  ParamStr := '';

  // Check length of string before starting processing
  ParamLen := Length(CodeParam);
  If (ParamLen > 0) Then Begin
    // Check for a direct string parameter - "ABCD01"
    If (CodeParam[1] = '"') And (CodeParam[ParamLen] = '"') Then Begin
      // Got string parameter - remove quotes and return value
      ParamStr := Copy (CodeParam, 2, ParamLen - 2);
      Result := True;
    End { If (CodeParam[1] = '"') And (CodeParam[ParamLen] = '"') }
    Else Begin
      // Try Named Cells and Cell References - $B$7, CompanyCode, R1C1, ...
      CellValue   := '';
      CellFormula := '';
      If FDrillO.GetCellInfo (CodeParam, CellValue, CellFormula) Then Begin
        // Got a valid Cell value/formula
        ParamStr := CellValue;
        Result := True;
      End; { If FDrillO.GetCellInfo }
    End; { Else }
  End; { If (ParamLen > 0) }
End; { ResolveStringParameter }

//-------------------------------------------------------------------------

// Attempts to resolve the parameter to a valid company code
Function TProcessFunction.ResolveCompanyCode (    CodeParam : ShortString;
                                              Var CompDets  : TCompanyDetails) : Boolean;
Begin { ResolveCompanyCode }
  Result := ResolveStringParameter (CodeParam, CompDets.cmCode);
  If (Not Result) Then DrillDownLog.AddString ('Unable to resolve Company Code Parameter "' + CodeParam + '"');

  If Result Then Begin
    // Validate Company Code parameter to ensure it is valid
    Result := EnterpriseData.ValidCompanyCode (CompDets);
    If (Not Result) Then DrillDownLog.AddString ('Invalid Company Code Parameter "' + CompDets.cmCode + '"');
  End; { If Result }
End; { ResolveCompanyCode }

//-------------------------------------------------------------------------

// Attempts to resolve the parameter to a valid AgeBy code
function TProcessFunction.ResolveAgeBy(CodeParam: ShortString;
  var AgeBy: Char): Boolean;
var
  AgeStr: ShortString;
begin
  Result := ResolveStringParameter (CodeParam, AgeStr);
  If (Not Result) Then DrillDownLog.AddString ('Unable to resolve Age By Parameter "' + CodeParam + '"');
  If Result Then Begin
    // Validate Age By Code parameter
    AgeStr := Trim(AgeStr);
    if (AgeStr <> '') then
    begin
      AgeBy := AgeStr[1];
      if not (AgeBy in ['D', 'W', 'M']) then
        Result := False;
    end
    else
      Result := False;
    If (Not Result) Then DrillDownLog.AddString ('Invalid Age By Parameter "' + AgeStr + '"');
  End; { If Result }
end;

//-------------------------------------------------------------------------

// Attempts to resolve the parameter to a valid Year
Function TProcessFunction.ResolveCurrency (CodeParam : ShortString; Var Currency : TCurrency) : Boolean;
Var
  IntVal : Integer;
Begin { ResolveCurrency }
  // Use standard number routine to resolve cell
  Result := ResolveIntParameter (CodeParam, IntVal);
  If (Not Result) Then DrillDownLog.AddString ('Unable to resolve Currency Parameter "' + CodeParam + '"');

  If Result Then Begin
    // Validate Year to ensure it is valid
    Result := EnterpriseData.ValidCurrency (IntVal);
    If Result Then
      Currency := IntVal
    Else
      DrillDownLog.AddString ('Invalid Currency Number: ' + IntToStr(IntVal));
  End; { If Result }
End; { ResolveCurrency }

//-------------------------------------------------------------------------

// Attempts to resolve the parameter to a valid Financial Period
Function TProcessFunction.ResolveGLCode (      CodeParam : ShortString;
                                         Var   GLCode    : TGLCode;
                                         Var   GLDesc    : ShortString;
                                         Var   GLType    : Char;
                                         Const FilterSet : TGLFilterSet = []) : Boolean;
Var
  IntVal : Integer;
Begin { ResolveGLCode }
  // Use standard number routine to resolve cell
  Result := ResolveIntParameter (CodeParam, IntVal);
  If (Not Result) Then DrillDownLog.AddString ('Unable to resolve GL Code Parameter "' + CodeParam + '"');

  If Result Then Begin
    // Validate GL Code to ensure it is valid
    Result := EnterpriseData.ValidGLCode (IntVal, GLDesc, GLType);
    If (Not Result) Then DrillDownLog.AddString ('Invalid GL Code: ' + IntToStr(IntVal));

    If Result And (FilterSet <> []) Then Begin
      // Check the GL Code type is valid
      Result := (GLType In FilterSet);
      If (Not Result) Then DrillDownLog.AddString ('GL Codes of type ' + QuotedStr(GLType) + 'are not supported for this function');
    End; { If Result And (FilterSet <> []) }

    If Result Then
      GLCode := IntVal;
  End; { If Result }
End; { ResolveGLCode }

//-------------------------------------------------------------------------

// Attempts to resolve the parameter to a valid GL View code
function TProcessFunction.ResolveGLView(CodeParam: ShortString;
  var GLView: TGLView; var CostCentre: TCCDept; var Department: TCCDept) : Boolean;
var
  IntVal : Integer;
begin
  // Use standard number routine to resolve cell.
  Result := ResolveIntParameter (CodeParam, IntVal);
  if (not Result) then
    DrillDownLog.AddString ('Unable to resolve GL View Parameter "' + CodeParam + '"');

  if Result then
  begin
    // Validate GL View to ensure it is valid.
    Result := EnterpriseData.ValidGLView(IntVal, CostCentre, Department);
    if (not Result) then
      DrillDownLog.AddString ('Invalid GL View Number: ' + IntToStr(IntVal));

    if Result then
      GLView := IntVal;
  end; { If Result }
end;

//-------------------------------------------------------------------------

// Attempts to resolve the parameter to a valid GL View Line code. If
// successful, returns the GL Code of the record in the GLCode parameter.
function TProcessFunction.ResolveGLLineCode(CodeParam: ShortString;
  var GLView: TGLView; var GLLineCode: TGLLineCode;
  var GLCode: TGLCode): Boolean;
begin
  Result := ResolveStringParameter(CodeParam, GLLineCode);
  if (not Result) then
    DrillDownLog.AddString ('Unable to resolve GL Line Code Parameter "' + CodeParam + '"');
  if Result then
  begin
    Result := EnterpriseData.ValidGLLineCode(GLView, GLLineCode, GLCode);
  end;
end;

//-------------------------------------------------------------------------

// Attempts to resolve the parameter to a valid Financial Period
Function TProcessFunction.ResolvePeriod (CodeParam : ShortString; Var Period : TPeriod) : Boolean;
Var
  IntVal : Integer;
Begin { ResolvePeriod }
  // Use standard number routine to resolve cell
  Result := ResolveIntParameter (CodeParam, IntVal);
  If (Not Result) Then DrillDownLog.AddString ('Unable to resolve Period Parameter "' + CodeParam + '"');

  If Result Then Begin
    // Validate Period to ensure it is valid
    Result := EnterpriseData.ValidFinancialPeriod (IntVal);
    If Result Then
      Period := IntVal
    Else
      DrillDownLog.AddString ('Invalid Period: ' + IntToStr(IntVal));
  End; { If Result }
End; { ResolvePeriod }

//-------------------------------------------------------------------------

// Attempts to resolve the parameter to a valid Year
Function TProcessFunction.ResolveYear (CodeParam : ShortString; Var Year : TYear) : Boolean;
Var
  IntVal : Integer;
Begin { ResolveYear }
  // Use standard number routine to resolve cell
  Result := ResolveIntParameter (CodeParam, IntVal);
  If (Not Result) Then DrillDownLog.AddString ('Unable to resolve Year Parameter "' + CodeParam + '"');

  If Result Then Begin
    // Validate Year to ensure it is valid
    Result := EnterpriseData.ValidFinancialYear (IntVal);
    If Result Then
      Year := IntVal
    Else
      DrillDownLog.AddString ('Invalid Year: ' + IntToStr(IntVal));
  End; { If Result }
End; { ResolveYear }

//-------------------------------------------------------------------------

// Attempts to resolve the parameter to a valid company code
Function TProcessFunction.ResolveCCDept (      CodeParam : ShortString;
                                         Var   CCDept    : TCCDept;
                                         Const WantCC    : Boolean;
                                         AllowBlank: Boolean = false) : Boolean;
Const
  CCDpDesc : Array [False..True] Of ShortString = ('Department', 'Cost Centre');
Begin { ResolveCCDept }
  Result := ResolveStringParameter (CodeParam, CCDept);
  If (Not Result) Then DrillDownLog.AddString ('Unable to resolve ' + CCDpDesc[WantCC] + ' Parameter "' + CodeParam + '"');

  If Result Then
  begin
    if not((CCDept = '') and AllowBlank) then
      // Validate Company Code parameter to ensure it is valid
      Result := EnterpriseData.ValidCCDept (CCDept, WantCC);
  end
  Else
    DrillDownLog.AddString ('Invalid ' + CCDpDesc[WantCC] + ': ' + CCDept);
End; { ResolveCCDept }

//-------------------------------------------------------------------------

// Identifies and calls the correct method for processing the function extracted by the parser
Function TProcessFunction.ProcessFormula : TProcessFormulaResult;
Begin { ProcessFormula }
  Result := frNoAction;

  With FunctionList.Functions[FFuncParser.FunctionIndex] Do
    Case fdCategory Of
      // Basic GL History - EntGLxx
      fcGLHistory        : Result := ProcessGLHistory(fdCategory);

      // GL+CostCentre History - EntGLCCxx
      fcGLCCHistory      : Result := ProcessGLHistory(fdCategory);

      // GL+Department History - EntGLDpxx
      fcGLDpHistory      : Result := ProcessGLHistory(fdCategory);

      // GL+CostCentre+Department History - EntGLCCDpxx
      fcGLCCDpHistory    : Result := ProcessGLHistory(fdCategory);

      // Committed GL History - EntGLCOMxx
      fcGLCOMHistory     : Result := ProcessGLHistory(fdCategory);

      // Committed GL+CostCentre+Department History - EntGLCCDpCOMxx
      fcGLCCDpCOMHistory : Result := ProcessGLHistory(fdCategory);

      // Job Costing History
      fcGLJobActual      : Result := ProcessJCHistory(fdCategory);

      // Actual Job Costing Analysis
      fcJCAnalActual     : Result := ProcessJCAnalysisActual(fdCategory);

      // Actual Job Costing Quantity
      fcJCAnalActualQty  : Result := ProcessJCAnalysisActual(fdCategory);

      // Stock Budget Analysis
      fcJCStkActual      : Result := ProcessJCStockActual(fdCategory);

      // Stock Budget Quantity
      fcJCStkActualQty   : Result := ProcessJCStockActual(fdCategory);

      // Total Job Costing Analysis
      fcJCTotActual      : Result := ProcessJCTotActual(fdCategory);

      // Total Job Costing Quantity
      fcJCTotActualQty   : Result := ProcessJCTotActual(fdCategory);

      // Stock Quantity on Order
      fcStkQtyOnOrder    : Result := ProcessStkHistory(fdCategory);

      // Stock Quantity Sold
      fcStkQtySold       : Result := ProcessStkHistory(fdCategory);

      // Stock Quantity Allocated
      fcStkQtyAllocated  : Result := ProcessStkHistory(fdCategory);

      // Stock Quantity OSSOR
      fcStkQtyOSSOR      : Result := ProcessStkHistory(fdCategory);

      // Stock Quantity in Stock
      fcStkQtyInStock    : Result := ProcessStkHistory(fdCategory);

      // Stock Quantity Picked
      fcStkQtyPicked     : Result := ProcessStkHistory(fdCategory);

      // Stock Quantity Used
      fcStkQtyUsed       : Result := ProcessStkHistory(fdCategory);

      // Works Order stock quantity allocated
      fcStkWORQtyAllocated : Result := ProcessStkHistory(fdCategory);

      // Works Order stock quantity issued
      fcStkWORQtyIssued  : Result := ProcessStkHistory(fdCategory);

      // Works Order stock quantity picked
      fcStkWORQtyPicked  : Result := ProcessStkHistory(fdCategory);

      // Stock quantity allocated, by location
      fcStkLocQtyAllocated : Result := ProcessStkHistory(fdCategory);

      // Stock quantity in stock, by location
      fcStkLocQtyInStock : Result := ProcessStkHistory(fdCategory);

      // Stock quantity on order, by location
      fcStkLocQtyOnOrder : Result := ProcessStkHistory(fdCategory);

      // Stock quantity OSSOR, by location
      fcStkLocQtyOSSOR   : Result := ProcessStkHistory(fdCategory);

      // Stock quantity picked, by location
      fcStkLocQtyPicked  : Result := ProcessStkHistory(fdCategory);

      // Stock quantity sold, by location
      fcStkLocQtySold    : Result := ProcessStkHistory(fdCategory);

      // Stock quantity used, by location
      fcStkLocQtyUsed    : Result := ProcessStkHistory(fdCategory);

      // Works Order stock quantity allocated, by location
      fcStkLocWORQtyAllocated : Result := ProcessStkHistory(fdCategory);

      // Works Order stock quantity issued, by location
      fcStkLocWORQtyIssued : Result := ProcessStkHistory(fdCategory);

      // Works Order stock quantity picked, by location
      fcStkLocWORQtyPicked : Result := ProcessStkHistory(fdCategory);

      // Customer stock quantity
      fcCustStkQty         : Result := ProcessStkHistory(fdCategory);

      // Customer stock sales
      fcCustStkSales       : Result := ProcessStkHistory(fdCategory);

      // Customer aged balance
      fcCustAgedBalance    : Result := ProcessCustHistory(fdCategory);

      // Customer balance
      fcCustBalance        : Result := ProcessCustHistory(fdCategory);

      // Customer committed balance
      fcCustCommitted      : Result := ProcessCustHistory(fdCategory);

      // Customer net sales
      fcCustNetSales       : Result := ProcessStkHistory(fdCategory);

      // Supplier aged balance
      fcSuppAgedBalance    : Result := ProcessCustHistory(fdCategory);

      // Supplier balance
      fcSuppBalance        : Result := ProcessCustHistory(fdCategory);

      // Supplier committed balance
      fcSuppCommitted      : Result := ProcessCustHistory(fdCategory);

      // GL View History
      fcGLViewHistory      : Result := ProcessGLViewHistory(fdCategory);

      // Data Selection Functions - EntSelectxx
      fcDataSelection    : Result := ProcessDataSelection;
    Else
      // Unsupported Category
      MessageDlg ('TProcessFunction.ProcessFormula: The Function Category ' + IntToStr(Ord(fdCategory)) + ' is not supported', mtError, [mbOk], 0);
    End; { Case fdCategory }
End; { ProcessFormula }

//-------------------------------------------------------------------------

// Processes the following Data Selection Functions added by EntDrill.Xla:-
//
//   Function EntSelectCostCentre (CompCode$, CCCode$) As Variant
//   Function EntSelectCustomer (CompCode$, AcCode$) As Variant
//   Function EntSelectDepartment (CompCode$, DeptCode$) As Variant
//   Function EntSelectGLCode (CompCode$, GLCode$) As Variant
//   Function EntSelectLocation (CompCode$, LocCode$) As Variant
//   Function EntSelectStock (CompCode$, StockCode$) As Variant
//   Function EntSelectSupplier (CompCode$, AcCode$) As Variant
//
function TProcessFunction.ProcessDataSelection : TProcessFormulaResult;
var
  CompDets            : TCompanyDetails;
  SelType             : TDataSelectType;
  NewFormula, SelCode : ShortString;
  Ok                  : Boolean;
  Params              : string;
begin { ProcessDataSelection }
  Result := frNoAction;
  try
    // Resolve the first parameter to the Company Code
    Ok := ResolveCompanyCode (FFuncParser.Params[0], CompDets);
    if Ok then
    begin
      // Open the specified Company Data Set
      if EnterpriseData.OpenDataSet(CompDets) then
      begin
        // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
        EnterpriseData.AddReferenceCount;
        Try
          // Extract existing code from parameter 2
          with FunctionList.Functions[FFuncParser.FunctionIndex] do
            // String Code e.g. Customer List, Stock List, etc...
            Ok := ResolveStringParameter (FFuncParser.Params[1], SelCode);
          if Ok then
          begin
            // Determine the type of data being selected from the value in the function's data property
            SelType := TDataSelectType(FunctionList.Functions[FFuncParser.FunctionIndex].fdData);
            // Create and display the selection dialog
            With TfrmSelectData.Create (Application.MainForm) Do
            Try
              Initialise(SelType);
              // Automatically display the current code in the dialog
              SearchText := SelCode;

              ShowModal;

              // If a code was selected then update the Excel worksheet
              if (Trim(FoundText) <> '') then
              begin
                // Generate the new formula to be placed in the cell in Excel
                Params := '(' + FFuncParser.Params[0] + ',"' + FoundText + '")';
                case SelectType Of
                  dstCostCentre: NewFormula := '=EntSelectCostCentre' + Params;
                  dstCustomer  : NewFormula := '=EntSelectCustomer'   + Params;
                  dstDepartment: NewFormula := '=EntSelectDepartment' + Params;
                  dstGLCode    : NewFormula := '=EntSelectGLCode'     + Params;
                  dstLocation  : NewFormula := '=EntSelectLocation'   + Params;
                  dstStock     : NewFormula := '=EntSelectStock'      + Params;
                  dstSupplier  : NewFormula := '=EntSelectSupplier'   + Params;
                  dstJob       : NewFormula := '=EntSelectJob'        + Params;
                  dstEmployee  : NewFormula := '=EntSelectEmployee'   + Params;
                  dstAnalysis  : NewFormula := '=EntSelectAnalysis'   + Params;
                  dstJobType   : NewFormula := '=EntSelectJobTypes'   + Params;
                else
                  raise Exception.Create ('TProcessFunction.ProcessDataSelection: Unhandled Data Selection Type');
                end; { Case SelectType }

                // Fire the Update Cell event to cause the Excel Add-In to update the cell
                FDrillO.UpdateCellFormula (NewFormula);
                Result := frUpdateFormula;
              end;  // if (Trim(FoundText) <> '')...
            finally
              Free;
            end;  // With TfrmSelectData.Create (Application.MainForm)...
          end // if Ok...
          else
            DrillDownLog.AddString('Invalid selection code');
        Finally
          // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
          EnterpriseData.RemoveReferenceCount;
        End; // Try..Finally
      end  // if EnterpriseData.OpenDataSet(CompDets)...
      else
        DrillDownLog.AddString ('Unable to Open or Login to the Company Data Set');
    end // if Ok then...
    else
      DrillDownLog.AddString ('Invalid Company Code');
  except
    on E:Exception do
      Result := frException;
  end;
end; { ProcessDataSelection }

//-------------------------------------------------------------------------

// Processes the following standard GL History Functions:-
//
//   Function EntGLActual (Company$, TheYear%, ThePeriod%, TheCcy%, GLCode&) As Variant
//   Function EntGLCredit (Company$, TheYear%, ThePeriod%, TheCcy%, GLCode&) As Variant
//   Function EntGLDebit  (Company$, TheYear%, ThePeriod%, TheCcy%, GLCode&) As Variant
//
// and the following GL+CostCentre History functions:-
//
//   Function EntGLCCActual (Company$, TheYear%, ThePeriod%, TheCcy%, GLCode&, CostCentre$) As Variant
//   Function EntGLCCCredit (Company$, TheYear%, ThePeriod%, TheCcy%, GLCode&, CostCentre$) As Variant
//   Function EntGLCCDebit  (Company$, TheYear%, ThePeriod%, TheCcy%, GLCode&, CostCentre$) As Variant
//
// and the following GL+Department History functions:-
//
//   Function EntGLDpActual (Company$, TheYear%, ThePeriod%, TheCcy%, GLCode&, Department$) As Variant
//   Function EntGLDpCredit (Company$, TheYear%, ThePeriod%, TheCcy%, GLCode&, Department$) As Variant
//   Function EntGLDpDebit  (Company$, TheYear%, ThePeriod%, TheCcy%, GLCode&, Department$) As Variant
//
// and the following GL+CostCentre+Department History functions:-
//
//   Function EntGLCCDpActual (Company$, TheYear%, ThePeriod%, TheCcy%, GLCode&, CostCentre$, Department$) As Variant
//   Function EntGLCCDpCredit (Company$, TheYear%, ThePeriod%, TheCcy%, GLCode&, CostCentre$, Department$) As Variant
//   Function EntGLCCDpDebit  (Company$, TheYear%, ThePeriod%, TheCcy%, GLCode&, CostCentre$, Department$) As Variant
//
// and the following Committed GL History functions:-
//
//   Function EntGLCOMActual (Company$, TheYear%, ThePeriod%, TheCcy%, GLCode&) As Variant
//   Function EntGLCOMCredit (Company$, TheYear%, ThePeriod%, TheCcy%, GLCode&) As Variant
//   Function EntGLCOMDebit  (Company$, TheYear%, ThePeriod%, TheCcy%, GLCode&) As Variant
//
// and the following Committed GL+CostCentre+Department History functions:-
//
//   Function EntGLCCDpCOMActual (Company$, TheYear%, ThePeriod%, TheCcy%, GLCode&, CostCentre$, Department$) As Variant
//   Function EntGLCCDpCOMCredit (Company$, TheYear%, ThePeriod%, TheCcy%, GLCode&, CostCentre$, Department$) As Variant
//   Function EntGLCCDpCOMDebit  (Company$, TheYear%, ThePeriod%, TheCcy%, GLCode&, CostCentre$, Department$) As Variant
//
Function TProcessFunction.ProcessGLHistory (Const FuncType : TEnumFunctionCategory) : TProcessFormulaResult;
Var
  CompDets    : TCompanyDetails;
  Currency    : TCurrency;
  GLCode      : TGLCode;
  GLDesc      : ShortString;
  GLType      : Char;
  Period      : TPeriod;
  Year        : TYear;
  CostCentre  : TCCDept;
  Department  : TCCDept;
  OK          : Boolean;
Begin { ProcessGLHistory }
  Result := frNoAction;
  Try
    // Resolve the first parameter to the Company Code
    OK := ResolveCompanyCode (FFuncParser.Params[0], CompDets);

    If OK Then
      // Open the specified Company Data Set and get the user to login
      If EnterpriseData.OpenDataSet(CompDets) Then Begin
        // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
        EnterpriseData.AddReferenceCount;
        Try
          // Check specific security settings for this function
          If EnterpriseData.CheckUserSecurity(487) Then Begin
            // Got Company Code - Extract Year from the second parameter
            OK := ResolveYear (FFuncParser.Params[1], Year);

            If OK Then
              // Got Year - Extract Period from the third parameter
              OK := ResolvePeriod (FFuncParser.Params[2], Period);

            If OK Then
              // Got Period - Extract Currency from the fourth parameter
              OK := ResolveCurrency (FFuncParser.Params[3], Currency);

            If OK Then Begin
              // Got Currency - Extract GL Code from the fourth parameter
              OK := ResolveGLCode (FFuncParser.Params[4], GLCode, GLDesc, GLType, [PLNHCode, BankNHCode]);

              If OK And (GLType = PLNHCode) And (Period = -98) Then
                // Due to an OLE Server (Exchequer?) Feature the -98 period
                // doesn't work as advertised for P&L Type GL Codes, instead
                // it returns YTD for the F6 Year!
                Year := Syss.CYr;
            End; { If OK }

            If OK Then Begin
              // Initialise optional fields
              CostCentre := '';
              Department := '';

              Case FuncType Of
                // Extract CostCentre from parameter 5
                fcGLCCHistory      : OK := ResolveCCDept (FFuncParser.Params[5], CostCentre, True);

                // Extract Department from paramater 5
                fcGLDpHistory      : OK := ResolveCCDept (FFuncParser.Params[5], Department, False);

                // Extract Cost Centre and Department from params 6 & 7
                fcGLCCDpHistory,
                fcGLCCDpCOMHistory : Begin
                                       OK := ResolveCCDept (FFuncParser.Params[5], CostCentre, True);
                                       If OK Then OK := ResolveCCDept (FFuncParser.Params[6], Department, False)
                                     End; { fcGLCCDpHistory }
              End; { Case FuncType }
            End; { If OK }

            If OK Then Begin
              // Got Parameters - Display detail window
              {ShowMessage ('TProcessFunction.ProcessGLHistory:-' + #13 +
                           '  CompanyCode: ' + CompanyCode + #13 +
                           '  Year: ' + IntToStr(Year) + #13 +
                           '  Period: ' + IntToStr(Period) + #13 +
                           '  Currency: ' + IntToStr(Currency) + #13 +
                           '  GLCode: ' + IntToStr(GLCode));}

              // Display entGLxxx Drill-Down window
              With NewGLLines Do Begin
                // Setup form properties for Drill-Down
                Case FuncType Of
                  fcGLHistory        : glMode := glOnly;
                  fcGLCCHistory      : glMode := glCC;
                  fcGLDpHistory      : glMode := glDept;
                  fcGLCCDpHistory    : glMode := glCCDept;
                  fcGLCOMHistory     : glMode := glCommit;
                  fcGLCCDpCOMHistory : glMode := glCommitCCDept;
                Else
                  MessageDlg ('TProcessFunction.ProcessGLHistory: The Function Type ' + IntToStr(Ord(FuncType)) + ' is not supported', mtError, [mbOk], 0);
                End; { Case FuncType }
                glCompanyCode := CompDets.cmCode;
                glGLCode      := GLCode;
                glGLDescr     := GLDesc;
                glGLType      := GLType;
                glPeriod      := Period;
                glYear        := Year;
                glCurrency    := Currency;
                glCostCentre  := CostCentre;
                glDepartment  := Department;

                // Initialise the list now the properties are set
                StartList;

                // Show form and finish drill-down - form will close when Excel unloads
                Show;

                Result := frDrillOK;
              End; { With NewGLLines }
            End; { If OK }
          End { If EnterpriseData.CheckUserSecurity(487) }
          Else
            DrillDownLog.AddString ('The User does not have rights to see this data');
        Finally
          // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
          EnterpriseData.RemoveReferenceCount;
        End; // Try..Finally
      End { If EnterpriseData.OpenDataSet(CompDets) }
      Else
        DrillDownLog.AddString ('Unable to Open or Login to the Company Data Set');
  Except
    On E:Exception Do
      Result := frException;
  End;
End; { ProcessGLHistory }

// -----------------------------------------------------------------------------

// Processes the following standard GL View History Functions:-
//
//   Function EntGLViewActual  (Company$, TheYear%, ThePeriod%, TheCcy%, GLView&, GLLineCode$) As Variant
//   Function EntGLViewCredit  (Company$, TheYear%, ThePeriod%, TheCcy%, GLView&, GLLineCode$) As Variant
//   Function EntGLViewDebit   (Company$, TheYear%, ThePeriod%, TheCcy%, GLView&, GLLineCode$) As Variant
//
function TProcessFunction.ProcessGLViewHistory(const FuncType: TEnumFunctionCategory): TProcessFormulaResult;
var
  CompDets    : TCompanyDetails;
  Currency    : TCurrency;
  GLView      : Integer;
  GLLineCode  : ShortString;
  GLCode      : TGLCode;
  GLDesc      : ShortString;
  GLType      : Char;
  Period      : TPeriod;
  Year        : TYear;
  CostCentre  : TCCDept;
  Department  : TCCDept;
  OK          : Boolean;
  Mode        : TGLDrillMode;
begin
  Result := frNoAction;
  Mode   := glOnly;
  try
    // Resolve the first parameter to the Company Code
    OK := ResolveCompanyCode(FFuncParser.Params[0], CompDets);

    if OK then
      // Open the specified Company Data Set and get the user to login
      if EnterpriseData.OpenDataSet(CompDets) then
      begin
        // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
        EnterpriseData.AddReferenceCount;
        Try
          // Check specific security settings for this function
          if EnterpriseData.CheckUserSecurity(567) then
          begin
            // Got Company Code - Extract Year from the second parameter
            OK := ResolveYear (FFuncParser.Params[1], Year);

            if OK then
              // Got Year - Extract Period from the third parameter
              OK := ResolvePeriod (FFuncParser.Params[2], Period);

            if OK then
              // Got Period - Extract Currency from the fourth parameter
              OK := ResolveCurrency (FFuncParser.Params[3], Currency);

            if OK then
              // Got Currency - Extract GL View Number from the fifth parameter,
              // and get the Cost Centre and Department from the View Control
               // record.
              OK := ResolveGLView(FFuncParser.Params[4], GLView, CostCentre, Department);

            if OK then
              // Got GL View - Extract GL Line Code from the sixth parameter
              OK := ResolveGLLineCode(FFuncParser.Params[5], GLView, GLLineCode, GLCode);

            if OK then
            begin
              // Got GL Line Code. Locate the actual GL record, and read the
              // details.
              OK := EnterpriseData.ValidGLCode(GLCode, GLDesc, GLType);

              if OK and (GLType = PLNHCode) and (Period = -98) then
                // Due to an OLE Server (Exchequer?) Feature the -98 period
                // doesn't work as advertised for P&L Type GL Codes, instead
                // it returns YTD for the F6 Year!
                Year := Syss.CYr;

            end; { If OK }

            if OK then
            begin

              // Set the mode based on whether the Cost Centre and/or Department
              // is defined.
              if (CostCentre = '') and (Department = '') then
                Mode := glOnly
              else if (Department = '') then
                Mode := glCC
              else if (CostCentre = '') then
                Mode := glDept
              else
                Mode := glCCDept;

            end; { if OK }

            if OK then
            begin
              // Got Parameters - Display detail window
              {ShowMessage ('TProcessFunction.ProcessGLViewHistory:-' + #13 +
                           '  CompanyCode: ' + CompanyCode + #13 +
                           '  Year: ' + IntToStr(Year) + #13 +
                           '  Period: ' + IntToStr(Period) + #13 +
                           '  Currency: ' + IntToStr(Currency) + #13 +
                           '  GLCode: ' + IntToStr(GLCode));}

              // Display entGLxxx Drill-Down window
              with NewGLLines do
              begin
                glMode        := Mode;
                glCompanyCode := CompDets.cmCode;
                glGLCode      := GLCode;
                glGLDescr     := GLDesc;
                glGLType      := GLType;
                glPeriod      := Period;
                glYear        := Year;
                glCurrency    := Currency;
                glCostCentre  := CostCentre;
                glDepartment  := Department;

                // Initialise the list now the properties are set
                StartList;

                // Show form and finish drill-down - form will close when Excel unloads
                Show;

                Result := frDrillOK;
              End; { With NewGLLines }
            End; { If OK }
          End { If EnterpriseData.CheckUserSecurity(567) }
          Else
            DrillDownLog.AddString ('The User does not have rights to see this data');
        Finally
          // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
          EnterpriseData.RemoveReferenceCount;
        End; // Try..Finally
      End { If EnterpriseData.OpenDataSet(CompDets) }
      Else
        DrillDownLog.AddString ('Unable to Open or Login to the Company Data Set');
  Except
    On E:Exception Do
      Result := frException;
  End;
End; { ProcessGLViewHistory }

// -----------------------------------------------------------------------------

function TProcessFunction.ProcessJCHistory(
  const FuncType: TEnumFunctionCategory): TProcessFormulaResult;
var
  CompDets: TCompanyDetails;
  Ok: Boolean;
  GLCode      : TGLCode;
  GLDesc      : ShortString;
  GLType      : Char;
  StartPeriod, EndPeriod: TPeriod;
  StartYear, EndYear: TYear;
  Currency: TCurrency;
  CostCentre  : TCCDept;
  Department  : TCCDept;
  JobCode     : TJobCode;
  StockCode   : TStockCode;
  AnalysisCode: TAnalysisCode;
  Location    : TLocationCode;
  AccountCode : TAccountCode;
begin
  Result := frNoAction;
  try
    // Resolve the first parameter to the Company Code
    Ok := ResolveCompanyCode (FFuncParser.Params[0], CompDets);
    if Ok then
    begin
      // Open the specified Company Data Set and get the user to login
      if EnterpriseData.OpenDataSet(CompDets) then
      begin
        // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
        EnterpriseData.AddReferenceCount;
        Try
          // Check specific security settings for this function
          if EnterpriseData.CheckUserSecurity(515) then
          begin

            // Start Period and End Period
            if Ok then
              Ok := ResolvePeriods(FFuncParser.Params[2],
                                   FFuncParser.Params[4],
                                   StartPeriod,
                                   EndPeriod);

            // Start Year and End Year
            if Ok then
              Ok := ResolveYears(FFuncParser.Params[3],
                                 FFuncParser.Params[5],
                                 StartYear,
                                 EndYear);

            // General Ledger Code
            if Ok then
            begin
              Ok := ResolveGLCode(FFuncParser.Params[1],
                                  GLCode,
                                  GLDesc,
                                  GLType, [PLNHCode, BankNHCode]);

              // Due to an OLE Server (Exchequer?) Feature the -98 period
              // doesn't work as advertised for P&L Type GL Codes, instead
              // it returns YTD for the F6 Year!
              if Ok and (GLType = PLNHCode) and (StartPeriod = -98) then
                StartYear := Syss.CYr;

              if Ok and (GLType = PLNHCode) and (EndPeriod = -98) then
                EndYear := Syss.CYr;
            end;

            // Currency
            if Ok then
              Ok := ResolveCurrency(FFuncParser.Params[6], Currency);

            // Job Code
            if Ok then
              Ok := ResolveJobCode(FFuncParser.Params[7], JobCode);

            // Analysis Code
            if Ok then
              Ok := ResolveAnalysisCode(FFuncParser.Params[8], AnalysisCode, True);

            // Stock Code
            if Ok then
              Ok := ResolveStockCode(FFuncParser.Params[9], StockCode, True);

            // Location
            if Ok then
              Ok := ResolveLocation(FFuncParser.Params[10], Location, True);

            // Cost Centre
            if Ok then
              Ok := ResolveCCDept (FFuncParser.Params[11], CostCentre, True, True);

            // Department
            if Ok then
              Ok := ResolveCCDept (FFuncParser.Params[12], Department, False, True);

            // Account Code
            if Ok then
              Ok := ResolveAccountCode (FFuncParser.Params[13], AccountCode, True);

            if OK Then Begin
              // Got Parameters - Display detail window
              {ShowMessage ('TProcessFunction.ProcessJobHistory:-' + #13 +
                           '  CompanyCode: ' + CompanyCode + #13 +
                           '  Year: ' + IntToStr(Year) + #13 +
                           '  Period: ' + IntToStr(Period) + #13 +
                           '  Currency: ' + IntToStr(Currency) + #13 +
                           '  GLCode: ' + IntToStr(GLCode));}

              // Display entJobxxx Drill-Down window
              With NewJobLines Do Begin
                // Setup form properties for Drill-Down
                jlMode := jdGLActual;

                jlCompanyCode := CompDets.cmCode;
                jlGLCode      := GLCode;
                jlGLDescr     := GLDesc;
                jlGLType      := GLType;
                jlStartPeriod := StartPeriod;
                jlEndPeriod   := EndPeriod;
                jlStartYear   := StartYear;
                jlEndYear     := EndYear;
                jlCurrency    := Currency;
                jlCostCentre  := CostCentre;
                jlDepartment  := Department;
                jlJobCode     := JobCode;
                jlStockCode   := StockCode;
                jlAnalysisCode := AnalysisCode;
                jlLocation    := Location;
                jlAccountCode := AccountCode;

                // Initialise the list now the properties are set
                StartList;

                // Show form and finish drill-down - form will close when Excel unloads
                Show;

                Result := frDrillOK;
              End; { With NewGLLines }
            End; { If OK }

          end { If EnterpriseData.CheckUserSecurity(515) }
          else
            DrillDownLog.AddString ('The User does not have rights to see this data');
        Finally
          // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
          EnterpriseData.RemoveReferenceCount;
        End; // Try..Finally
      end { If EnterpriseData.OpenDataSet(CompDets) }
      else
        DrillDownLog.AddString ('Unable to Open or Login to the Company Data Set');
    end // if Ok (from ResolveCompanyCode...)
  except
    on E:Exception do
      Result := frException;
  end;
end;

function TProcessFunction.ResolveCustCode(CodeParam: ShortString;
  var CustCode: TCustCode; AllowBlank: Boolean = False): Boolean;
begin
  Result := ResolveStringParameter(CodeParam, CustCode);
  if (not Result) then
    DrillDownLog.AddString ('Unable to resolve CustCode Parameter ' +
                            '"' + CodeParam + '"');
  if Result then
  begin
    if not ((CustCode = '') and AllowBlank) then
      Result := EnterpriseData.ValidCustCode(CustCode);
  end
  else
    DrillDownLog.AddString ('Invalid Cust Code: ' + CustCode);
end;

function TProcessFunction.ResolvePeriods(CodeParam1,
  CodeParam2: ShortString; var StartPeriod, EndPeriod: TPeriod): Boolean;
Begin { ResolvePeriod }
  Result := ResolvePeriod(CodeParam1, StartPeriod) and
            ResolvePeriod(CodeParam2, EndPeriod);
end;

function TProcessFunction.ResolveYears(CodeParam1, CodeParam2: ShortString;
  var StartYear, EndYear: TYear): Boolean;
Begin { ResolveYear }
  Result := ResolveYear(CodeParam1, StartYear) and
            ResolveYear(CodeParam2, EndYear);
end;

function TProcessFunction.ResolveJobCode(CodeParam: ShortString;
  var JobCode: TJobCode): Boolean;
begin
  Result := ResolveStringParameter(CodeParam, JobCode);
  if (not Result) then
    DrillDownLog.AddString ('Unable to resolve JobCode Parameter ' +
                            '"' + CodeParam + '"');
  if Result then
  begin
    Result := EnterpriseData.ValidJobCode(JobCode);
    if (JobRec.JobType = 'K') then
      Result := False;
  end
  else
    DrillDownLog.AddString ('Invalid Job Code: ' + JobCode);
end;

function TProcessFunction.ResolveStockCode(CodeParam: ShortString;
  var StockCode: TStockCode; AllowBlank: Boolean = False): Boolean;
begin
  Result := ResolveStringParameter(CodeParam, StockCode);
  if (not Result) then
    DrillDownLog.AddString ('Unable to resolve StockCode Parameter ' +
                            '"' + CodeParam + '"');
  if Result then
  begin
    if not ((StockCode = '') and AllowBlank) then
      Result := EnterpriseData.ValidStockCode(StockCode);
  end
  else
    DrillDownLog.AddString ('Invalid Stock Code: ' + StockCode);
end;

function TProcessFunction.ResolveAnalysisCode(CodeParam: ShortString;
  var AnalysisCode: TAnalysisCode; AllowBlank: Boolean = False): Boolean;
begin
  Result := ResolveStringParameter(CodeParam, AnalysisCode);
  if (not Result) then
    DrillDownLog.AddString ('Unable to resolve AnalysisCode Parameter ' +
                            '"' + CodeParam + '"');
  if Result then
  begin
    if not((AnalysisCode = '') and AllowBlank) then
      Result := EnterpriseData.ValidAnalysisCode(AnalysisCode);
  end
  else
    DrillDownLog.AddString ('Invalid Analysis Code: ' + AnalysisCode);
end;

function TProcessFunction.ResolveLocation(CodeParam: ShortString;
  var Location: TLocationCode; AllowBlank: Boolean = False): Boolean;
begin
  Result := ResolveStringParameter(CodeParam, Location);
  if (not Result) then
    DrillDownLog.AddString ('Unable to resolve Location Parameter ' +
                            '"' + CodeParam + '"');
  if Result then
  begin
    if not((Location = '') and AllowBlank) then
      Result := EnterpriseData.ValidLocation(Location);
  end
  else
    DrillDownLog.AddString ('Invalid Location: ' + Location);
end;

function TProcessFunction.ResolveAccountCode(CodeParam: ShortString;
  var AccountCode: TAccountCode; AllowBlank: Boolean = False): Boolean;
begin
  Result := ResolveStringParameter(CodeParam, AccountCode);
  if (not Result) then
    DrillDownLog.AddString ('Unable to resolve Account Code Parameter ' +
                            '"' + CodeParam + '"');
  if Result then
  begin
    if not((AccountCode = '') and AllowBlank) then
      Result := EnterpriseData.ValidCustCode(AccountCode);
  end
  else
    DrillDownLog.AddString ('Invalid Account Code: ' + AccountCode);
end;

function TProcessFunction.ProcessJCAnalysisActual(
  const FuncType: TEnumFunctionCategory): TProcessFormulaResult;
var
  CompDets: TCompanyDetails;
  Ok: Boolean;
  Period      : TPeriod;
  Year        : TYear;
  JobCode     : TJobCode;
  AnalysisCode: TAnalysisCode;
  Currency    : TCurrency;
  Status      : TPostedStatus;
  JAType      : TJAType;
begin
  Result := frNoAction;
  try
    // Resolve the first parameter to the Company Code
    Ok := ResolveCompanyCode (FFuncParser.Params[0], CompDets);
    if Ok then
    begin
      // Open the specified Company Data Set and get the user to login
      if EnterpriseData.OpenDataSet(CompDets) then
      begin
        // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
        EnterpriseData.AddReferenceCount;
        Try
          // Check specific security settings for this function
          if EnterpriseData.CheckUserSecurity(515) then
          begin

            // Currency
            if Ok then
              Ok := ResolveCurrency(FFuncParser.Params[3], Currency);

            // Job Code
            if Ok then
              Ok := ResolveJobCode(FFuncParser.Params[4], JobCode);

            // Analysis Code
            if Ok then
            begin
              Ok := ResolveAnalysisCode(FFuncParser.Params[5], AnalysisCode);

              // MH 06/03/2012 v6.10 ABSEXCH-11389: Analysis drill-down requires the correct Job Analysis Type to filter the job actuals
              if OK Then
                // Analysis Code record is still in memory from the ResolveAnalysisCode lookup
                JAType := JobMisc^.JobAnalRec.AnalHed;
            end; // if Ok

            // Year
            if Ok then
              Ok := ResolveYear (FFuncParser.Params[1], Year);

            // Period
            If Ok Then
              OK := ResolvePeriod (FFuncParser.Params[2], Period);

            if Ok then
            begin
              if (FuncType = fcJCAnalActual) then
                Ok := ResolvePostedStatus(FFuncParser.Params[6], Status)
              else
                { fcJCAnalActualQty }
                Status := psPosted;
            end;

            if OK then
            begin
              // Display entJobxxx Drill-Down window
              with NewJobActualDialog do
              begin

                jaFunctionCategory := FuncType;

                jaYear         := Year;
                jaPeriod       := Period;
                jaJobCode      := JobCode;
                jaAnalysisCode := AnalysisCode;
                jaCurrency     := Currency;
                jaStatus       := Status;

                // MH 06/03/2012 v6.10 ABSEXCH-11389: Analysis drill-down requires the correct Job Analysis Type to filter the job actuals
                jaJAType       := JAType;

                // Initialise the list now the properties are set
                BuildList;

                // Show form and finish drill-down - form will close when Excel unloads
                Show;

                Result := frDrillOK;
              end; { with NewJobActualDialog }
            End; { if OK }

          end { If EnterpriseData.CheckUserSecurity(515) }
          else
            DrillDownLog.AddString ('The User does not have rights to see this data');
        Finally
          // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
          EnterpriseData.RemoveReferenceCount;
        End; // Try..Finally
      end { If EnterpriseData.OpenDataSet(CompDets) }
      else
        DrillDownLog.AddString ('Unable to Open or Login to the Company Data Set');
    end // if Ok (from ResolveCompanyCode...)
  except
    on E:Exception do
      Result := frException;
  end;
end;

function TProcessFunction.ResolvePostedStatus(CodeParam: ShortString;
  var Status: TPostedStatus): Boolean;
var
  StatusCode: ShortString;
begin
  Result := ResolveStringParameter(CodeParam, StatusCode);
  if (not Result) then
    DrillDownLog.AddString ('Unable to resolve Posted Status Parameter ' +
                            '"' + CodeParam + '"');
  if Result then
  begin
    if (StatusCode = 'P') then
      Status := psPosted
    else if (StatusCode = 'C') then
      Status := psCommitted
    else
    begin
      Result := False;
      DrillDownLog.AddString ('Invalid Posted Status Parameter ' +
                              '"' + CodeParam + '"');
    end;
  end;
end;

function TProcessFunction.CategoryToJAType(Category: Integer): TJAType;
{ Translates a category number used in the Excel spreadsheet and in
  Exchequer into the equivalent JAType value stored in the database. }
begin
  case Category of
    10, 20, 30, 40, 50, 60: Result := (Category div 10);
    99:                     Result := 99;
    160, 170, 180, 190:     Result := ((Category - 90) div 10);
    5:                      Result := 15;              // Sales Applications
    14:                     Result := 14;              // Sales Deductions
    23:                     Result := 11;              // Sub Contract Labour
    53:                     Result := 12;              // Materials 2
    63:                     Result := 13;              // Overheads 2
    67:                     Result := 17;              // Purchase Deductions
    173:                    Result := 16;              // Purchase Applications
  else
    Result := -1;
  end;
end;

function TProcessFunction.ResolveJAType(CodeParam: ShortString;
  var JAType: TJAType): Boolean;
var
  Category: Integer;
begin
  // Use standard number routine to resolve cell
  Result := ResolveIntParameter (CodeParam, Category);
  if (not Result) then
    DrillDownLog.AddString('Unable to resolve Category Parameter "' + CodeParam + '"');
  if Result then
  begin
    { Convert the category to the JA Type, and verify. }
    JAType := CategoryToJAType(Category);
    if (JAType = -1) then
      DrillDownLog.AddString ('Unknown category: ' + IntToStr(Category));
  end;
end;

function TProcessFunction.ProcessJCTotActual(
  const FuncType: TEnumFunctionCategory): TProcessFormulaResult;
var
  CompDets: TCompanyDetails;
  Ok: Boolean;
  Period      : TPeriod;
  Year        : TYear;
  JobCode     : TJobCode;
  JAType      : TJAType;
  Currency    : TCurrency;
  Status      : TPostedStatus;
begin
  { Params: 0 = Company,
            1 = Year,
            2 = Period,
            3 = Currency,
            4 = Category,
            5 = Job Code,
            6 = Posted Status }
  Result := frNoAction;
  try
    // Resolve the first parameter to the Company Code
    Ok := ResolveCompanyCode (FFuncParser.Params[0], CompDets);
    if Ok then
    begin
      // Open the specified Company Data Set and get the user to login
      if EnterpriseData.OpenDataSet(CompDets) then
      begin
        // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
        EnterpriseData.AddReferenceCount;
        Try
          // Check specific security settings for this function
          if EnterpriseData.CheckUserSecurity(515) then
          begin

            // Year
            if Ok then
              Ok := ResolveYear (FFuncParser.Params[1], Year);

            // Period
            If Ok Then
              OK := ResolvePeriod (FFuncParser.Params[2], Period);

            // Currency
            if Ok then
              Ok := ResolveCurrency(FFuncParser.Params[3], Currency);

            // Job Analysis Line Type
            if Ok then
              Ok := ResolveJAType(FFuncParser.Params[4], JAType);

            // Job Code
            if Ok then
              Ok := ResolveJobCode(FFuncParser.Params[5], JobCode);

            if Ok then
            begin
              if (FuncType = fcJCTotActual) then
                Ok := ResolvePostedStatus(FFuncParser.Params[6], Status)
              else
                { fcJCTotAnalQty }
                Status := psPosted;
            end;

            if OK then
            begin
              // Display entJobxxx Drill-Down window
              with NewJobActualDialog do
              begin

                jaFunctionCategory := FuncType;

                jaYear         := Year;
                jaPeriod       := Period;
                jaJobCode      := JobCode;
                jaCurrency     := Currency;
                jaStatus       := Status;
                jaJAType       := JAType;

                // Initialise the list now the properties are set
                BuildList;

                // Show form and finish drill-down - form will close when Excel unloads
                Show;

                Result := frDrillOK;
              end; { with NewJobActualDialog }
            End; { if OK }
          end { If EnterpriseData.CheckUserSecurity(515) }
          else
            DrillDownLog.AddString ('The User does not have rights to see this data');
        Finally
          // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
          EnterpriseData.RemoveReferenceCount;
        End; // Try..Finally
      end { If EnterpriseData.OpenDataSet(CompDets) }
      else
        DrillDownLog.AddString ('Unable to Open or Login to the Company Data Set');
    end // if Ok (from ResolveCompanyCode...)
  except
    on E:Exception do
      Result := frException;
  end;
end;

function TProcessFunction.ProcessJCStockActual(
  const FuncType: TEnumFunctionCategory): TProcessFormulaResult;
var
  CompDets: TCompanyDetails;
  Ok: Boolean;
  Period      : TPeriod;
  Year        : TYear;
  JobCode     : TJobCode;
  StockCode   : TStockCode;
  Currency    : TCurrency;
  Status      : TPostedStatus;
begin
  Result := frNoAction;
  try
    // Resolve the first parameter to the Company Code
    Ok := ResolveCompanyCode (FFuncParser.Params[0], CompDets);
    if Ok then
    begin
      // Open the specified Company Data Set and get the user to login
      if EnterpriseData.OpenDataSet(CompDets) then
      begin
        // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
        EnterpriseData.AddReferenceCount;
        Try
          // Check specific security settings for this function
          if EnterpriseData.CheckUserSecurity(515) then
          begin

            // Currency
            if Ok then
              Ok := ResolveCurrency(FFuncParser.Params[3], Currency);

            // Job Code
            if Ok then
              Ok := ResolveJobCode(FFuncParser.Params[4], JobCode);

            // Stock Code
            if Ok then
              Ok := ResolveStockCode(FFuncParser.Params[5], StockCode);

            // Year
            if Ok then
              Ok := ResolveYear (FFuncParser.Params[1], Year);

            // Period
            If Ok Then
              OK := ResolvePeriod (FFuncParser.Params[2], Period);

            if Ok then
            begin
              if (FuncType = fcJCStkActual) then
                Ok := ResolvePostedStatus(FFuncParser.Params[6], Status)
              else
                { fcJCAnalActualQty }
                Status := psPosted;
            end;

            if OK then
            begin
              // Display entJobxxx Drill-Down window
              with NewJobActualDialog do
              begin

                jaFunctionCategory := FuncType;

                jaYear      := Year;
                jaPeriod    := Period;
                jaJobCode   := JobCode;
                jaStockCode := StockCode;
                jaCurrency  := Currency;
                jaStatus    := Status;

                // Initialise the list now the properties are set
                BuildList;

                // Show form and finish drill-down - form will close when Excel unloads
                Show;

                Result := frDrillOK;
              end; { with NewJobActualDialog }
            End; { if OK }

          end { If EnterpriseData.CheckUserSecurity(515) }
          else
            DrillDownLog.AddString ('The User does not have rights to see this data');
        Finally
          // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
          EnterpriseData.RemoveReferenceCount;
        End; // Try..Finally
      end { If EnterpriseData.OpenDataSet(CompDets) }
      else
        DrillDownLog.AddString ('Unable to Open or Login to the Company Data Set');
    end // if Ok (from ResolveCompanyCode...)
  except
    on E:Exception do
      Result := frException;
  end;
end;

function TProcessFunction.ProcessStkHistory(
  const FuncType: TEnumFunctionCategory): TProcessFormulaResult;
var
  Ok          : Boolean;
  CompDets    :  TCompanyDetails;
  Period      : TPeriod;
  Year        : TYear;
  Currency    : TCurrency;
  StockCode   : TStockCode;
  CustCode    : TCustCode;
  Location    : TLocationCode;
  CostCentre  : TCCDept;
  Department  : TCCDept;
  Frm         : TfrmStock;
begin
  Result := frNoAction;
  try
    Year       := 0;
    Period     := 0;
    Currency   := 0;
    CustCode   := '';
    CostCentre := '';
    Department := '';
    Location   := '';
    StockCode  := '';
    // Resolve the first parameter to the Company Code
    Ok := ResolveCompanyCode (FFuncParser.Params[0], CompDets);
    if Ok then
    begin
      // Open the specified Company Data Set and get the user to login
      if EnterpriseData.OpenDataSet(CompDets) then
      begin
        // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
        EnterpriseData.AddReferenceCount;
        Try
          // Check specific security settings for this function
          if EnterpriseData.CheckUserSecurity(490) then
          begin

            if (FuncType in [fcStkQtySold, fcStkQtyUsed, fcStkLocQtySold, fcStkLocQtyUsed]) then
            begin

              // Year
              Ok := ResolveYear(FFuncParser.Params[1], Year);

              // Period
              if Ok then
                Ok := ResolvePeriod(FFuncParser.Params[2], Period);

              // Currency
              if Ok then
                Ok := ResolveCurrency(FFuncParser.Params[3], Currency);

              // Stock Code
              if Ok then
                Ok := ResolveStockCode(FFuncParser.Params[4], StockCode);

              // Location
              if Ok and (FuncType in [fcStkLocQtySold, fcStkLocQtyUsed]) then
                Ok := ResolveLocation(FFuncParser.Params[5], Location);

            end
            else if (FuncType in [fcCustStkQty, fcCustStkSales]) then
            begin

              // Cust Code
              Ok := ResolveCustCode(FFuncParser.Params[1], CustCode);

              // Stock Code
              if Ok then
                Ok := ResolveStockCode(FFuncParser.Params[2], StockCode);

              // Currency
              if Ok then
                Ok := ResolveCurrency(FFuncParser.Params[3], Currency);

              // Year
              if Ok then
                Ok := ResolveYear(FFuncParser.Params[4], Year);

              // Period
              if Ok then
                Ok := ResolvePeriod(FFuncParser.Params[5], Period);

              // Cost Centre
              if Ok then
                Ok := ResolveCCDept (FFuncParser.Params[6], CostCentre, True, True);

              // Department
              if Ok then
                Ok := ResolveCCDept (FFuncParser.Params[7], Department, False, True);

              // Location
              if Ok then
                Ok := ResolveLocation(FFuncParser.Params[8], Location, True);

            end
            else if (FuncType in [fcCustNetSales]) then
            begin

              // Year
              if Ok then
                Ok := ResolveYear(FFuncParser.Params[1], Year);

              // Period
              if Ok then
                Ok := ResolvePeriod(FFuncParser.Params[2], Period);

              // Cust Code
              Ok := ResolveCustCode(FFuncParser.Params[3], CustCode);

            end
            else if (FuncType in [fcStkLocQtyInStock,
                                  fcStkLocQtyOnOrder,
                                  fcStkLocQtyOSSOR,
                                  fcStkLocQtyPicked,
                                  fcStkLocQtyAllocated,
                                  fcStkLocWORQtyAllocated,
                                  fcStkLocWORQtyIssued,
                                  fcStkLocWORQtyPicked
                                 ]) then
            begin

              // Stock Code
              Ok := ResolveStockCode(FFuncParser.Params[1], StockCode);

              // Location
              if Ok then
                Ok := ResolveLocation(FFuncParser.Params[2], Location);

            end
            else
              Ok := ResolveStockCode(FFuncParser.Params[1], StockCode);

            if Ok then
            begin
              // Display entStkxxx Drill-Down window
              Frm := NewStkHistoryDialog;
              with Frm do
              begin

                stkFunctionCategory := FuncType;
                stkYear             := Year;
                stkPeriod           := Period;
                stkCurrency         := Currency;
                stkLocation         := Location;
                stkCustCode         := CustCode;
                stkCostCentre       := CostCentre;
                stkDepartment       := Department;
                // Stock Code must be the last parameter set, as setting it will
                // trigger the update of the Main tab on the Stock History
                // dialog.
                stkStockCode        := StockCode;

                // Initialise the list now the properties are set
                BuildList;

                // Show form and finish drill-down - form will close when Excel unloads
                Show;

                Result := frDrillOK;
              end; { with NewJobActualDialog }
              BringWindowToTop(Frm.Handle);
            end; { if OK }

          end { If EnterpriseData.CheckUserSecurity(490) }
          else
            DrillDownLog.AddString ('The User does not have rights to see this data');
        Finally
          // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
          EnterpriseData.RemoveReferenceCount;
        End; // Try..Finally
      end { If EnterpriseData.OpenDataSet(CompDets) }
      else
        DrillDownLog.AddString ('Unable to Open or Login to the Company Data Set');
    end // if Ok (from ResolveCompanyCode...)
  except
    on E:Exception do
      Result := frException;
  end;
end;

function TProcessFunction.ProcessCustHistory(
  const FuncType: TEnumFunctionCategory): TProcessFormulaResult;
var
  Ok          : Boolean;
  CompDets    :  TCompanyDetails;
  Period      : TPeriod;
  Year        : TYear;
  Currency    : TCurrency;
  StockCode   : TStockCode;
  CustCode    : TCustCode;
  CostCentre  : TCCDept;
  Department  : TCCDept;
  Location    : TLocationCode;
  AgeAsAtDate : TDateTime;
  AgeBy       : Char;
  PeriodInterval: Integer;
begin
  Result := frNoAction;
  try
    Year     := 0;
    Period   := 0;
    Currency := 0;
    AgeAsAtDate := 0;
    AgeBy    := #0;
    PeriodInterval := 0;
    // Resolve the first parameter to the Company Code
    Ok := ResolveCompanyCode (FFuncParser.Params[0], CompDets);
    if Ok then
    begin
      // Open the specified Company Data Set and get the user to login
      if EnterpriseData.OpenDataSet(CompDets) then
      begin
        // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
        EnterpriseData.AddReferenceCount;
        Try
          // Check specific security settings for this function
          if EnterpriseData.CheckUserSecurity(477) then
          begin

            if (FuncType in [fcCustBalance, fcCustCommitted, fcSuppBalance, fcSuppCommitted]) then
            begin

              // Year
              Ok := ResolveYear(FFuncParser.Params[1], Year);

              // Period
              if Ok then
                Ok := ResolvePeriod(FFuncParser.Params[2], Period);

              // Cust Code
              if Ok then
                Ok := ResolveCustCode(FFuncParser.Params[3], CustCode);

            end
            else if (FuncType in [fcCustAgedBalance, fcSuppAgedBalance]) then
            begin
              // Cust Code
              Ok := ResolveCustCode(FFuncParser.Params[1], CustCode);

              // AgeAsAt
              if Ok then
                Ok := ResolveDateParameter(FFuncParser.Params[2], AgeAsAtDate);

              // AgeBy
              if Ok then
                Ok := ResolveAgeBy(FFuncParser.Params[3], AgeBy);

              // Period Interval
              if Ok then
                Ok := ResolveIntParameter(FFuncParser.Params[4], PeriodInterval);

              // Period
              if Ok then
                Ok := ResolvePeriod(FFuncParser.Params[5], Period);

            end
            else
              Ok := ResolveStockCode(FFuncParser.Params[1], StockCode);

            if Ok then
            begin
              // Display entCustxxx Drill-Down window
              with NewCustHistoryDialog do
              begin

                custFunctionCategory := FuncType;
                custCustCode         := CustCode;
                custYear             := Year;
                custPeriod           := Period;
                custCurrency         := Currency;
                custStockCode        := StockCode;
                custLocation         := Location;
                custAgeAsAt          := AgeAsAtDate;
                custAgeBy            := AgeBy;
                custPeriodInterval   := PeriodInterval;

                // Initialise the list now the properties are set
                BuildList;

                // Show form and finish drill-down - form will close when Excel unloads
                Show;

                Result := frDrillOK;
              end; { with NewJobActualDialog }
            end; { if OK }

          end { If EnterpriseData.CheckUserSecurity(477) }
          else
            DrillDownLog.AddString ('The User does not have rights to see this data');
        Finally
          // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
          EnterpriseData.RemoveReferenceCount;
        End; // Try..Finally
      end { If EnterpriseData.OpenDataSet(CompDets) }
      else
        DrillDownLog.AddString ('Unable to Open or Login to the Company Data Set');
    end // if Ok (from ResolveCompanyCode...)
  except
    on E:Exception do
      Result := frException;
  end;
end;

end.

