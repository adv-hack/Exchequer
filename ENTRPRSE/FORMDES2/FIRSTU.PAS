unit FirstU;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface


Var
  Orig_ShortDateFormat : ShortString;

implementation

Uses SysUtils;

Initialization
  Orig_ShortDateFormat := ShortDateFormat;
end.










