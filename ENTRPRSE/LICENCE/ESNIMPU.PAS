unit ESNImpU;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Mask, SysUtils, Windows, LicRec;

// Processes a 6 segment ESN string in the OnExit event of a MaskEdit
Function ProcessESNStr (Var ESN : ESNByteArrayType; Var MEdit : TMaskEdit) : Boolean;

// Processes a 7 segment v5.00 ESN string in the OnExit event of a MaskEdit
Function ProcessESN7Str (Var   ESN              : ESNByteArrayType;
                         Var   DemoFlag         : Byte;
                         Var   MEdit            : TMaskEdit) : Boolean;

implementation

Uses LicFuncU;

//-----------------------------------------------------------------------

Function GetESNNo (Var MEdit : TMaskEdit; Const StartPos : Byte; Var ESNByte : Byte) : Boolean;
Var
  EdText : ShortString;
  NumStr : String[3];
  NumVal : SmallInt;
Begin { GetESNNo }
  Result := True;

  { Extract String from MaskEdit Text }
  EdText := MEdit.Text;
  NumStr := Copy(EdText, StartPos, 3);

  { Convert partial ESN value to Integer }
  If (Trim(NumStr) <> '') Then Begin
    { Convert the number to an integer }
    NumVal := StrToInt(Trim(NumStr));

    { Validate the number }
    If (NumVal < 0) Or (NumVal > 255) Then Begin
      If MEdit.CanFocus Then MEdit.SetFocus;
      MEdit.SelStart := StartPos - 1;
      MEdit.SelLength := 3;
      Result := False;
      SysUtils.Beep;
    End; { If }
  End { If (Trim(NumStr) <> '') }
  Else
    NumVal := 0;

  { Update Mask EditText }
  NumStr := Format ('%3.3d', [NumVal]);
  Move (NumStr[1], EdText[StartPos], Length(NumStr));
  MEdit.Text := EdText;

  { Return partial ESN Value if AOK }
  If Result Then ESNByte := NumVal;
End; { GetESNNo }

//----------------------------------------------------------------------

// Processes a 6 segment ESN string in the OnExit event of a MaskEdit
Function ProcessESNStr (Var ESN : ESNByteArrayType; Var MEdit : TMaskEdit) : Boolean;
Begin { ProcessESNStr }
  Result := False;

  FillChar (ESN, SizeOf(ESN), #0);

  { Check to see if the ESN field is enabled }
  If MEdit.Enabled Then Begin
    { OK - process the text }
    If GetESNNo (MEdit, 1, ESN[1]) Then
      If GetESNNo (MEdit, 5, ESN[2]) Then
        If GetESNNo (MEdit, 9, ESN[3]) Then
          If GetESNNo (MEdit, 13, ESN[4]) Then
            If GetESNNo (MEdit, 17, ESN[5]) Then
              Result := GetESNNo (MEdit, 21, ESN[6]);
  End; { If MEdit.Enabled  }
End; { ProcessESNStr }

//----------------------------------------------------------------------

// Processes a 7 segment v5.00 ESN string in the OnExit event of a MaskEdit
Function ProcessESN7Str (Var   ESN              : ESNByteArrayType;
                         Var   DemoFlag         : Byte;
                         Var   MEdit            : TMaskEdit) : Boolean;
Begin { ProcessESN7Str }
  Result := False;

  FillChar (ESN, SizeOf(ESN), #0);

  { Check to see if the ESN field is enabled }
  If MEdit.Enabled Then Begin
    { OK - process the text }
    If GetESNNo (MEdit, 1, ESN[1]) Then
      If GetESNNo (MEdit, 5, ESN[2]) Then
        If GetESNNo (MEdit, 9, ESN[3]) Then
          If GetESNNo (MEdit, 13, ESN[4]) Then
            If GetESNNo (MEdit, 17, ESN[5]) Then
              If GetESNNo (MEdit, 21, ESN[6]) Then
                Result := GetESNNo (MEdit, 25, DemoFlag);
  End; { If MEdit.Enabled  }
End; { ProcessESN7Str }


end.
