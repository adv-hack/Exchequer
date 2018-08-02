unit dummy;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Var
  X : Pointer;


implementation


Initialization
  GetMem (X, 1000);

Finalization
  FreeMem (X, 1000);
end.
 