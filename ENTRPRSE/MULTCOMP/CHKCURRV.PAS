unit ChkCurrV;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows;


Function CheckCurrencyVer (ChkPath : ShortString) : Boolean;


implementation

Var
  GotSingle : Boolean;
  GotMulti  : Boolean;



{ Check its the correct currency version }
Function CheckCurrencyVer (ChkPath : ShortString) : Boolean;
Begin
  ChkPath := UpperCase(Trim(ChkPath));

  If (GotSingle And (Not GotMulti)) Then Begin
    { Single Currency - check for .SYS files }
    Result := FileExists (ChkPath + 'DEFPF044.SYS') And (Not FileExists (ChkPath + 'DEFMC044.SYS'));
  End { If }
  Else Begin
    If ((Not GotSingle) And GotMulti) Then Begin
      { Multi Currency }
      Result := (Not FileExists (ChkPath + 'DEFPF044.SYS')) And FileExists (ChkPath + 'DEFMC044.SYS');
    End { If }
    Else
      { Dimebar??? - unknown currency version }
      Result := False;
    End; { Else }
End;


Initialization
  GotSingle := FileExists (ExtractFilePath(Application.ExeName)+'DEFPF044.SYS');
  GotMulti  := FileExists (ExtractFilePath(Application.ExeName)+'DEFMC044.SYS');

end.
