unit CompUtil;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Function PathToShort (Const FPath : ShortString) : ShortString;
Function PathToLong (Const FPath : ShortString) : ShortString;

Procedure FixPath (Var ThePath : String);

implementation

Uses Dialogs, Windows, SysUtils;

Function PathToShort (Const FPath : ShortString) : ShortString;
Var
  Temp1, Temp2 : PChar;
  PLen         : SmallInt;
Begin
  Result := FPath;

  If (Trim(FPath) <> '') Then Begin
    Temp1 := StrAlloc (250);
    Temp2 := StrAlloc (250);

    StrPCopy (Temp1, Trim(FPath));
    PLen := GetShortPathName (Temp1, Temp2, StrBufSize (Temp2));
    If (PLen > 0) Then
      Result := Trim(StrPas(Temp2));

    StrDispose (Temp1);
    StrDispose (Temp2);
  End; { If }
End;

Function PathToLong (Const FPath : ShortString) : ShortString;
{Var
  Temp1, Temp2, Temp3 : PChar;
  PLen                : SmallInt;}
Begin
  Result := FPath;

  (*  Doesn't Work
  If (Trim(FPath) <> '') And FileExists(FPath) Then Begin
    Temp1 := StrAlloc (250);
    Temp2 := StrAlloc (250);

    StrPCopy (Temp1, Trim(FPath));
    StrPCopy (Temp2, Trim(ExtractFilePath(FPath)));
    PLen := GetFullPathName (Temp1, StrBufSize (Temp2), Temp2, Temp3);
    If (PLen > 0) Then
      Result := Trim(StrPas(Temp2));

    StrDispose (Temp1);
    StrDispose (Temp2);
  End; { If }
  *)
End;


{ Ensures that the path is terminated correctly }
Procedure FixPath (Var ThePath : String);
Begin
{$IFNDEF HMTEST}
  If (Trim(ThePath) <> '') Then Begin
    ThePath := PathToShort(Trim(ThePath));

    If Not (Copy(ThePath, Length(ThePath), 1)[1] In [':', '\']) Then
      ThePath := ThePath + '\';
  End; { If }
{$ENDIF}
End;

end.
