library E32EXCH;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

{$Warn Symbol_Platform Off}

uses
  SysUtils,
  Windows,
  SecCodes in 'X:\ENTRPRSE\COMTK\SECCODES.PAS';

{$R *.res}

Procedure X (Var I1, I2, I3 : LongInt); StdCall;
Var
  lpText, lpCaption : ANSIString;
  ExeName           : String[8];
Begin
  // Extract name of parent .EXE
  ExeName := UpperCase(ExtractFileName(ParamStr(0)));
  If (Pos('.', ExeName) > 0) Then Delete (ExeName, Pos('.', ExeName), Length(ExeName));

  // Check running from an acceptable .EXE as a security measure
  If (ExeName = 'VB5') Or (ExeName = 'VB6') Or (ExeName = 'EARNIE32') Or (ExeName = 'PAYROLL') Or  // Intex Payroll
    ((I1 = 102) And (I2 = 318542) And (I3 = -14252363)) Or                 // IRIS Accounts Production
    ((I1 = 235) And (I2 = 173842) And (I3 = -6472163)) Then Begin          // Britannia
    I1 := 0;
    I2 := 0;
    I3 := 0;
    EncodeOpCode (97, I1, I2, I3);
  End { If (ExeName = ... }
  Else Begin
    // Unlicenced use - do something nasty, hee, hee, hee!!!!
    Randomize;
    lpCaption := 'Error';
    lpText    := Format ('%s caused an Access violation at address %8.8x in module KERNEL32.DLL', [ExeName, Random(2147000000)]);
    MessageBox(0, PCHAR(lpText), PCHAR(lpCaption), MB_OK Or MB_ICONERROR Or MB_TASKMODAL);
  End; { Else }
End;

Exports
  X Index 1 Name '';
end.
