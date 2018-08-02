unit ParamO;

{ markd6 14:23 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, SysUtils;

Type
  TParamParser = Class(TObject)
  Private
    FParamStr : ANSIString;

    Function GetParamCount : Byte;
    Procedure SetParamStr(Value : ANSIString);
  Protected
  Public
    FParams   : TStringList;
    Constructor Create (sParam : ANSIString);
    Destructor  Destroy; Override;
  Published
    Property ParamCount : Byte Read GetParamCount;
    Property ParamStr   : ANSIString Read FParamStr Write SetParamStr;

    Function GetParamStr (Const PName : ShortString) : ShortString;
    Function GetParamBool (Const PName : ShortString; Const Deflt : Boolean) : Boolean;
  End; { TParamParser }

implementation

{ Creates the object initialising local variables as needed }
Constructor TParamParser.Create (sParam : ANSIString);
Begin
  Inherited Create;

  { Create strings list }
  FParams := TStringList.Create;

  { Setup Parameters if specified }
  If (Trim(sParam) <> '') Then Begin
    ParamStr := sParam;
  End; { If }
End;


{ Deallocates memory and destroys any internal objects }
Destructor TParamParser.Destroy;
Begin
  If Assigned(FParams) Then
    FParams.Destroy;

  Inherited Destroy;
End;


{ Returns the number of parameters in the list }
Function TParamParser.GetParamCount : Byte;
Begin { GetParamCount }
  If Assigned(FParams) Then
    Result := FParams.Count
  Else
    Result := 0;
End;  { GetParamCount }


Procedure TParamParser.SetParamStr(Value : ANSIString);
Var
  I         : Integer;
  InStr     : Boolean;
  TheChar   : Char;
  CurrParam : ShortString;
Begin { SetParamStr }
  Value := UpperCase(Trim(Value));

  If Assigned(FParams) And (Value <> FParamStr) Then Begin
    { Copy into local property }
    FParamStr := Value;

    { Clear out list of parameters }
    FParams.Clear;

    { Parse the parameters into separate items and add into parameters list }
    CurrParam := '';
    InStr := False;
    I := 1;
    While (I <= Length (Value)) Do Begin
      { Get current character }
      TheChar := Value [I];

      If Instr Then Begin
        If (TheChar = '"') Then
          Instr := False
        Else
          CurrParam := CurrParam + TheChar;
      End { If }
      Else Begin
        Case TheChar Of
          { separator between strings }
          ',' : Begin
                  FParams.Add(Trim(CurrParam));
                  CurrParam := '';
                End;
        Else
          { No special meaning to character - add to CSVStrs }
          CurrParam := CurrParam + TheChar;

          InStr := (TheChar = '"');
        End; { Case }
      End; { Else }

      Inc (I);
    End; { While }

    { Add Last parameter }
    If (CurrParam <> '') Then FParams.Add(Trim(CurrParam));
  End; { If }
End; { SetParamStr }


{ Returns a string from the list of parameters - blank if it doesn't exist }
Function TParamParser.GetParamStr (Const PName : ShortString) : ShortString;
Begin { GetParamStr }
  Result := Trim(FParams.Values[PName]);

  If (Length(Result) > 0) Then
    If (Result[1] In ['''', '"']) Then
      Delete (Result, 1, 1);

  If (Length(Result) > 0) Then
    If (Result[Length(Result)] In ['''', '"']) Then
      Delete (Result, Length(Result), 1);
End;  { GetParamStr }


{ Returns a boolean from the list of parameters - set to DefLt if it doesn't exist }
Function TParamParser.GetParamBool (Const PName : ShortString; Const Deflt : Boolean) : Boolean;
Var
  PStr : ShortString;
Begin { GetParamBool }
  { Return the default value as the default result }
  Result := Deflt;

  PStr := GetParamStr (PName);

  { Check values considered to be true }
  If (PStr = 'YES') Or (PStr = 'Y') Or (Pstr = 'TRUE') Or (PStr = 'ON') Or (PStr = '1') Then Begin
    { True }
    Result := True;
  End { If }
  Else Begin
    { Check values considered to be False }
    If (PStr = 'NO') Or (PStr = 'N') Or (Pstr = 'FALSE') Or (PStr = 'OFF') Or (PStr = '0') Then Begin
      { False }
      Result := False;
    End; { If }
  End; { Else }
End;  { GetParamBool }

end.

