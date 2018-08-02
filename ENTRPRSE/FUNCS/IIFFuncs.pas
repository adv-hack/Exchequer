unit IIFFuncs;

interface

// Overloaded functions to replicate the VB IIF function in Delphi.
//PR: 07/07/2009 Changed second line to use 'AnsiString' rather than 'String' to avoid compile errors with $H-

Function IIF (Const BooleanCondition : Boolean; Const ReturnIfTrue, ReturnIfFalse : ShortString) : ShortString; OverLoad;
Function IIF (Const BooleanCondition : Boolean; Const ReturnIfTrue, ReturnIfFalse : AnsiString) : AnsiString; OverLoad;
Function IIF (Const BooleanCondition : Boolean; Const ReturnIfTrue, ReturnIfFalse : Cardinal) : Cardinal; OverLoad;
Function IIF (Const BooleanCondition : Boolean; Const ReturnIfTrue, ReturnIfFalse : Double) : Double; OverLoad;
Function IIF (Const BooleanCondition : Boolean; Const ReturnIfTrue, ReturnIfFalse : Integer) : Integer; OverLoad;

implementation

//------------------------------

Function IIF (Const BooleanCondition : Boolean; Const ReturnIfTrue, ReturnIfFalse : ShortString) : ShortString;
Begin { IIF }
  If BooleanCondition Then
    Result := ReturnIfTrue
  Else
    Result := ReturnIfFalse;
End; { IIF }

//------------------------------

Function IIF (Const BooleanCondition : Boolean; Const ReturnIfTrue, ReturnIfFalse : AnsiString) : AnsiString;
Begin { IIF }
  If BooleanCondition Then
    Result := ReturnIfTrue
  Else
    Result := ReturnIfFalse;
End; { IIF }

//------------------------------

Function IIF (Const BooleanCondition : Boolean; Const ReturnIfTrue, ReturnIfFalse : Cardinal) : Cardinal;
Begin { IIF }
  If BooleanCondition Then
    Result := ReturnIfTrue
  Else
    Result := ReturnIfFalse;
End; { IIF }

//------------------------------

Function IIF (Const BooleanCondition : Boolean; Const ReturnIfTrue, ReturnIfFalse : Double) : Double;
Begin { IIF }
  If BooleanCondition Then
    Result := ReturnIfTrue
  Else
    Result := ReturnIfFalse;
End; { IIF }

//------------------------------

Function IIF (Const BooleanCondition : Boolean; Const ReturnIfTrue, ReturnIfFalse : Integer) : Integer;
Begin { IIF }
  If BooleanCondition Then
    Result := ReturnIfTrue
  Else
    Result := ReturnIfFalse;
End; { IIF }

//------------------------------


end.
