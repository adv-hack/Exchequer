unit initmod;

{ markd6 14:23 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Dialogs, Forms, SysUtils, Windows;

implementation

Uses GlobVar;

Procedure DefaultPath;
Var
  Temp1, Temp2 : PChar;
  FPath        : ShortString;
  PLen         : SmallInt;
Begin
  FPath := ExtractFilePath(Application.ExeName);

  If (Trim(FPath) <> '') Then Begin
    Temp1 := StrAlloc (250);
    Temp2 := StrAlloc (250);

    StrPCopy (Temp1, Trim(FPath));
    PLen := GetShortPathName (Temp1, Temp2, StrBufSize (Temp2));
    If (PLen > 0) Then
      FPath := Trim(StrPas(Temp2));

    StrDispose (Temp1);
    StrDispose (Temp2);
  End; { If }

  SetDrive := FPath;
End;

Initialization
  DefaultPath;
end.
