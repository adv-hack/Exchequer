unit DpViewFuncs;

interface

Uses SysUtils, StdCtrls;

Procedure OutputChar(Const OutputMemo : TMemo; Const Description : ShortString; Const CharValue : Char);
Procedure OutputDouble(Const OutputMemo : TMemo; Const Description : ShortString; Const FloatValue : Double; Const Decs : Byte);
Procedure OutputInteger(Const OutputMemo : TMemo; Const Description : ShortString; Const IntValue : Integer);
Procedure OutputString(Const OutputMemo : TMemo; Const Description : ShortString; Const StrValue : ShortString; Const MaxSize : Integer);

implementation

//=========================================================================

Procedure OutputChar(Const OutputMemo : TMemo; Const Description : ShortString; Const CharValue : Char);
Begin // OutputChar
  OutputMemo.Lines.Add (Description + ': ' + CharValue + ' (#' + IntToStr(Ord(CharValue)) + ')');
End; // OutputChar

//-------------------------------------------------------------------------

Procedure OutputDouble(Const OutputMemo : TMemo; Const Description : ShortString; Const FloatValue : Double; Const Decs : Byte);
Begin // OutputDouble
  OutputMemo.Lines.Add (Description + ': ' + Format('%0.' + IntToStr(Decs) + 'f', [FloatValue]));
End; // OutputDouble

//-------------------------------------------------------------------------

Procedure OutputInteger(Const OutputMemo : TMemo; Const Description : ShortString; Const IntValue : Integer);
Begin // OutputInteger
  OutputMemo.Lines.Add (Description + ': ' + IntToStr(IntValue));
End; // OutputInteger

//-------------------------------------------------------------------------

Procedure OutputString(Const OutputMemo : TMemo; Const Description : ShortString; Const StrValue : ShortString; Const MaxSize : Integer);
Begin // OutputString
  If (Length(StrValue) > MaxSize) Then
    OutputMemo.Lines.Add (Description + ': *** Max Length ' + IntToStr(MaxSize) + ', ' + IntToStr(Length(StrValue)) + ' received ***' + StrValue)
  Else
    OutputMemo.Lines.Add (Description + ': ' + StrValue);
End; // OutputString




end.
