unit ZUtils;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows;

Function WideStrToChar (Const WideStr : WideString; Const ErrChar : Char) : Char;

implementation

Function WideStrToChar (Const WideStr : WideString; Const ErrChar : Char) : Char;
Begin { WideStrToChar }
  If (Length(WideStr) > 0) Then
    Result := Chr(Ord(WideStr[1]))
  Else
    Result := ErrChar;
End; { WideStrToChar }


end.
