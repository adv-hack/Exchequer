unit VarToolK;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Classes;
// Import Btrieve Constants
{$I ExDllBt.Inc}

// Import Record Structures
{$I EXCHCTK.INC}

Const
  // Constants for History Access
  sYTDHistory = 'YTD';
  iYTDHistory = -99;

  iYearEverything = 0;

Type
  // Pointer to TBatchCURec
  pBatchCURec = ^TBatchCURec;


implementation

end.
