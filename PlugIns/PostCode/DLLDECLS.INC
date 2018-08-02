{           DLL declarations
  **********************************************************************
  Include this file into any units that need it using a $I declaration.
  We use conditional compilation to decide whether to use 16 bit or 32
  bit calls.

  This file is given a .INC extension so that it doesn't get compiled
  separately if you've got it open in the source code inspector.
}

{$ifdef WIN32}
   { 32 Bit Win95 only - Delphi 2/3 }
{  Function GetFirst(Var details: PostcodeData; Var flags:Integer):  LongInt; far; stdcall; external 'pcode32';
   Function GetNext(Var details: PostcodeData):  LongInt; far; stdcall; external 'pcode32';
   { 32 Bit NT only - Delphi 2/3 }
   Function GetFirst(Var details: PostcodeData; Var flags:Integer):  LongInt; far; stdcall; external 'pcode32.dll';
   Function GetNext(Var details: PostcodeData):  LongInt; far; stdcall; external 'pcode32.dll';
{$else}
   {16 Bit - Delphi 1}
   Function GetFirst(Var details: PostcodeData; Var flags:Integer): LongInt; far; external 'postcode';
   Function GetNext(Var details: PostcodeData):  LongInt; far; external 'postcode';
{$endif }
