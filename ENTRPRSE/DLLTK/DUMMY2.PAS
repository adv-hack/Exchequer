unit Dummy2;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


Interface

Var
  X2 : Pointer;

implementation

Initialization
  GetMem (X2, 1000);

Finalization
  FreeMem (X2, 1000);
end.

