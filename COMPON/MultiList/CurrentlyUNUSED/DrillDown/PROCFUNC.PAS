unit ProcFunc;

{$ALIGN 1}

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows,
     oDrill,              // Drill-Down COM Object
     FuncParser,          // Global Function Parser object
     FuncList,      // FunctionList Object
     EntData;             // EntData object

Type
  // Local types to simplify parameters
  TCompanyCode = String[6];
  TCurrency    = Byte;
  TGLCode      = LongInt;
  TGLFilterSet = Set Of Char;
  TPeriod      = SmallInt;
  TYear        = SmallInt;
  TCCDept      = String[3];

  // Enumeration identifying the type of parameter
  TParamType = (ptString);

  // Enumeration for result of processing the parsed formula in ProcessFormula
  TProcessFormulaResult = (frNoAction, frDrillOK, frUpdateFormula, frException);


  // The FunctionParser object is used to break down an drill-down string into
  // its component parts - FunctionName & Parameters.
  TProcessFunction = Class(TObject)
  Private
    // Reference to Parent IDrillDown object to allow direct communication
    // to Excel for resolving cell references, etc...
    FDrillo : TDrillDown;

    // Reference to FunctionParser containing details of the Formula
    FFuncParser : TFunctionParser;

    // Parameter resolution routines
    Function ResolveIntParameter (CodeParam : ShortString; Var ParamInt : Integer) : Boolean;
    Function ResolveStringParameter (CodeParam : ShortString; Var ParamStr : ShortString) : Boolean;

    // Data Resolution routines
    Function ResolveCompanyCode (    CodeParam : ShortString;
                                 Var CompDets  : TCompanyDetails) : Boolean;
    Function ResolveCCDept (      CodeParam : ShortString;
                            Var   CCDept    : TCCDept;
                            Const WantCC    : Boolean) : Boolean;
    Function ResolveCurrency (CodeParam : ShortString; Var Currency : TCurrency) : Boolean;
    Function ResolveGLCode (CodeParam : ShortString; Var GLCode : TGLCode;
                            Var GLDesc : ShortString; Var GLType : Char;
                            Const FilterSet : TGLFilterSet = []) : Boolean;
    Function ResolvePeriod (CodeParam : ShortString; Var Period : TPeriod) : Boolean;
    Function ResolveYear (CodeParam : ShortString; Var Year : TYear) : Boolean;

    // function processing routines
    Function ProcessDataSelection : TProcessFormulaResult;
    Function ProcessGLHistory (Const FuncType : TEnumFunctionCategory) : TProcessFormulaResult;
  Public
    Constructor Create (Const oDrillDown : TDrillDown; Const FunctionParser : TFunctionParser);
    Destructor Destroy; Override;

    Function ProcessFormula : TProcessFormulaResult;
  End; { TProcessFunction }


implementation

Uses
     GlobVar,       // Exchequer global const/type/var
     VarConst,      // Enterprise global const/type/var
     Comnu2,        // Entrprse Misc Routines
     NomLineF,      // Drill-Down Form for EntGL functions
     SelDataF,      // Drill-Down form for entSelect functions
     DrillLog;      // DrillDownLog object

//=========================================================================

Constructor TProcessFunction.Create (Const oDrillDown : TDrillDown; Const FunctionParser : TFunctionParser);
Begin { Create }
  Inherited Create;

  // Make local copies of references to objects
  FDrillo := oDrillDown;
  FFuncParser := FunctionParser;
End; { Create }

//-------------------------

Destructor TProcessFunction.Destroy;
Begin { Destroy }
  // Remove local references to objects
  FFuncParser := NIL;
  FDrillo := NIL;

  Inherited;
End; { Destroy }

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
      ParamLen := Length(CodeParam);
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

// Indentifies the type of parameter and resolves it to a string value
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
                                         Const WantCC    : Boolean) : Boolean;
Const
  CCDpDesc : Array [False..True] Of ShortString = ('Department', 'Cost Centre');
Begin { ResolveCCDept }
  Result := ResolveStringParameter (CodeParam, CCDept);
  If (Not Result) Then DrillDownLog.AddString ('Unable to resolve ' + CCDpDesc[WantCC] + ' Parameter "' + CodeParam + '"');

  If Result Then
    // Validate Company Code parameter to ensure it is valid
    Result := EnterpriseData.ValidCCDept (CCDept, WantCC)
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
Function TProcessFunction.ProcessDataSelection : TProcessFormulaResult;
Var
  CompDets            : TCompanyDetails;
  SelectType          : TDataSelectType;
  NewFormula, SelCode : ShortString;
  OK                  : Boolean;
Begin { ProcessDataSelection }
  Result := frNoAction;
  Try
    // Resolve the first parameter to the Company Code
    OK := ResolveCompanyCode (FFuncParser.Params[0], CompDets);

    If OK Then
      // Open the specified Company Data Set
      If EnterpriseData.OpenDataSet(CompDets) Then Begin
        // Extract existing code from parameter 2
        With FunctionList.Functions[FFuncParser.FunctionIndex] Do
          // String Code e.g. Customer List, Stock List, etc...
          OK := ResolveStringParameter (FFuncParser.Params[1], SelCode);

        // Determine the type of data being selected from the value in the function's data property
        SelectType := TDataSelectType(FunctionList.Functions[FFuncParser.FunctionIndex].fdData);

        // Create and display the selection dialog
        With TfrmSelectData.Create (Application.MainForm, SelectType) Do
          Try
            // Automatically display the current code in the dialog
            SearchText := SelCode;

            ShowModal;

            // If a code was selected then update the Excel worksheet
            If (Trim(FoundText) <> '') Then Begin
              // Generate the new formula to be placed in the cell in Excel
              Case SelectType Of
                dstCostCentre  : NewFormula := '=EntSelectCostCentre(' + FFuncParser.Params[0] + ',"' + FoundText + '")';

                dstCustomer    : NewFormula := '=EntSelectCustomer(' + FFuncParser.Params[0] + ',"' + FoundText + '")';

                dstDepartment  : NewFormula := '=EntSelectDepartment(' + FFuncParser.Params[0] + ',"' + FoundText + '")';

                dstGLCode      : NewFormula := '=EntSelectGLCode(' + FFuncParser.Params[0] + ',"' + FoundText + '")';

                dstLocation    : NewFormula := '=EntSelectLocation(' + FFuncParser.Params[0] + ',"' + FoundText + '")';

                dstStock       : NewFormula := '=EntSelectStock(' + FFuncParser.Params[0] + ',"' + FoundText + '")';

                dstSupplier    : NewFormula := '=EntSelectSupplier(' + FFuncParser.Params[0] + ',"' + FoundText + '")';
              Else
                Raise Exception.Create ('TProcessFunction.ProcessDataSelection: Unhandled Data Selection Type');
              End; { Case SelectType }

              // Fire the Update Cell event to cause the Excel Add-In to update the cell
              FDrillO.UpdateCellFormula (NewFormula);
              Result := frUpdateFormula;
            End; { If (Trim(FoundText) <> '') }
          Finally
            Free;
          End;
      End { If EnterpriseData.OpenDataSet(CompDets) }
      Else
        DrillDownLog.AddString ('Unable to Open or Login to the Company Data Set');
  Except
    On E:Exception Do
      Result := frException;
  End;
End; { ProcessDataSelection }

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
        // Check specific security settings for this function
        If EnterpriseData.CheckUserSecurity(20) Then Begin
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
              // Due to an OLE Server (Enterprise?) Feature the -98 period
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
        End { If EnterpriseData.CheckUserSecurity(20) }
        Else
          DrillDownLog.AddString ('The User does not have rights to see this data');
      End { If EnterpriseData.OpenDataSet(CompDets) }
      Else
        DrillDownLog.AddString ('Unable to Open or Login to the Company Data Set');
  Except
    On E:Exception Do
      Result := frException;
  End;
End; { ProcessGLHistory }

//=========================================================================

end.
