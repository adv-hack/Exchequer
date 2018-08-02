unit FuncParser;

interface

Uses Classes, Dialogs, SysUtils, Windows;

Type
  // The FunctionParser object is used to break down an drill-down string into
  // its component parts - FunctionName & Parameters.
  TFunctionParser = Class(TObject)
  Private
    // Stores the last process formula
    FFormula : ShortString;

    // Stores the extracted function name
    FFuncName : ShortString;

    // Stores the unique index number of the function within the FunctionList object
    FFunctionIndex : SmallInt;

    // stores the extracted parameters in text format
    FParams   : TStringList;

    function GetParamCount: Integer;
    function GetParams(Index: Integer): ShortString;
  Protected
    Procedure AddParameter (ParamStr : ShortString);
  Public
    Property Formula : ShortString Read FFormula;
    Property FunctionIndex : SmallInt Read FFunctionIndex;
    Property FunctionName : ShortString Read FFuncName;
    Property ParamCount : Integer Read GetParamCount;
    Property Params [Index: Integer] : ShortString Read GetParams;

    Constructor Create;
    Destructor Destroy; Override;

    Function ParseFormula (Const TheFormula : ShortString) : Boolean;
  End; { TFunctionParser }


implementation

Uses FuncList,      // FunctionList object
     DrillLog;      // DrillDownLog object

//=========================================================================

Constructor TFunctionParser.Create;
Begin { Create }
  Inherited;

  FFormula := '';
  FFuncName := '';
  FFunctionIndex := -1;
  FParams := TStringList.Create;
End; { Create }

//-------------------------------------------------------------------------

Destructor TFunctionParser.Destroy;
Begin { Destroy }
  FreeAndNIL(FParams);

  Inherited;
End; { Destroy }

//-------------------------------------------------------------------------

// Parses the formula and returns True if it is considered to be a valid Enterprise formula
Function TFunctionParser.ParseFormula (Const TheFormula : ShortString) : Boolean;
Var
  CurrPos       : SmallInt;     // Index of character being processed within the Formula string
  CurrChar      : Char;         // Stores the character being processed
  Depth         : SmallInt;     // Tracks how deep bracketwise we are into any section of the formula
  Formula       : ShortString;  // Local working copy of the Formula parameter
  FormulaLen    : SmallInt;     // Stores the length of the Formula
  IgnoreChar    : Boolean;      // Flag to indicate whether the current character should be added into the parameter string
  ParamStr      : ShortString;  // Stores the parameter currently being extracted
  StartBracket  : SmallInt;     // Stores the position of the opening ( within the formula
  InString      : Boolean;      // Tracks whether we are within a string parameter
Begin { ParseFormula }
  // Initialise return result to failed status
  Result := False;

  // Initialise all properties to default values
  FFuncName := '';
  FFunctionIndex := -1;
  FParams.Clear;
  FFormula := TheFormula;       // Store original unmodified formula in property
  Formula := Trim(FFormula);    // Setup local Working copy

  // Check there is a formula to process
  FormulaLen := Length(Formula);
  If (FormulaLen > 0) Then Begin
    If (Formula[1] = '=') Then Begin
      // Remove opening '=' if it exists
      Delete (Formula, 1, 1);
      FormulaLen := Length(Formula);
    End; { If (Formula[1] = '=') }

    // Check it is an Enterprise function
    If (Copy (Formula, 1, 3) = 'Ent') Then Begin
      // Check for Brackets
      StartBracket := Pos ('(', Formula);
      If (StartBracket > 3) Then Begin
        // Extract Function Name
        FFuncName := Copy (Formula, 1, StartBracket - 1);

        // Lookup the Function Name in the FunctionList object to see if it is valid
        FFunctionIndex := FunctionList.IndexOf (FFuncName);

        If (FFunctionIndex >= 0) Then Begin
          // Valid - Extract Parameters
          CurrPos := StartBracket + 1;
          Depth := 1;
          ParamStr := '';
          InString := False;
          While (CurrPos <= FormulaLen) And (Depth > 0) Do Begin
            // Extract character of formula under examination
            CurrChar := Formula[CurrPos];

            // HM 01/05/03: extended to handle embedded commas within strings
            IgnoreChar := False;
            If (Depth = 1) And (CurrChar = ',') And (Not InString) Then Begin;
              // End of Parameter - Add into list and reset for next parameter
              AddParameter (ParamStr);
              ParamStr := '';
              IgnoreChar := True;
            End; { If (Depth = 0) And (CurrChar = ',') }

            If (Not IgnoreChar) Then Begin
              // Check for opening/closing brackets changing the depth
              If (Currchar = '(') Then Inc (Depth);
              If (Currchar = ')') Then Dec (Depth);

              // HM 01/05/03: extended to handle embedded commas within strings
              If (CurrChar = '"') Then InString := Not InString;

              If (Depth > 0) Then
                ParamStr := ParamStr + CurrChar;
            End; { If (Not IgnoreChar) }

            Inc (CurrPos);
          End; { While (CurrPos <= FmlaLen) }

          // Add Last Parameter - Has to be added now as no ',' to trigger it within the loop
          AddParameter (ParamStr);

          // Check number of parameters is correct
          With FunctionList.Functions[FFunctionIndex] Do
            If (FParams.Count = fdParamCount) Then
              // Parameters are correct - Return a valid status
              Result := True
            Else
              DrillDownLog.AddString (Format ('The function has an incorrect number of parameters - %d expected and %d found',
                                              [fdParamCount, FParams.Count]));
        End { If (FFunctionIndex >= 0) }
        Else
          // Invalid Function
          DrillDownLog.AddString ('The function "' + FFuncName + '" is not supported by the Drill-Down Add-In');
      End { If (StartBracket > 4) }
      Else
        DrillDownLog.AddString ('The Start Bracket ''('' is missing from the formula');
    End { If (Copy (Formula, 1, 3) = 'Ent') }
    Else
      DrillDownLog.AddString ('No Enterprise Function Found');
  End { If (FormulaLen > 0) }
  Else
    // Formula is blank
    DrillDownLog.AddString ('The formula is blank');
End; { ParseFormula }

//-------------------------------------------------------------------------

Procedure TFunctionParser.AddParameter (ParamStr : ShortString);
Begin { AddParameter }
  If (Length(ParamStr) > 0) Then Begin
    // Remove any leading/trailing spaces
    ParamStr := Trim(ParamStr);

    If (Length(ParamStr) > 0) Then
      // Remove any pairs of leading/trailing bracket
      While (ParamStr[1] = '(') And (ParamStr[Length(ParamStr)] = ')') Do Begin
        ParamStr[1] := ' ';
        ParamStr[Length(ParamStr)] := ' ';
        ParamStr := Trim(ParamStr);
      End; { While }
  End; { If (Length(Params[ParamIdx]) > 0) }

  FParams.Add (ParamStr);
End; { AddParameter }

//-------------------------------------------------------------------------

function TFunctionParser.GetParamCount: Integer;
begin
  Result := FParams.Count;
end;

//--------------------------

function TFunctionParser.GetParams(Index: Integer): ShortString;
begin
  If (Index >= 0) And (Index < FParams.Count) Then
    Result := FParams[Index]
  Else
    Raise Exception.Create ('TFunctionParser.GetParams: Invalid Index');
end;

//=========================================================================

end.
