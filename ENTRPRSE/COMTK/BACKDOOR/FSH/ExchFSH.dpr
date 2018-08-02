library ExchFSH;

//MH: 13/10/2014: Backdoor DLL for FSH to backdoor the COM Toolkit for whatever the FSH system is.

{$WARN SYMBOL_PLATFORM	OFF}

uses
  SysUtils,
  Windows,
  SecCodes in '..\..\SECCODES.PAS';

{$R *.res}

Procedure FSH_CTKDebugMode (Var I1, I2, I3 : LongInt); StdCall;
Var
  lpText, lpCaption : ANSIString;
  ExeName           : String[8];
Begin
  //Extract name of calling exe
  ExeName := UpperCase(ExtractFileName(ParamStr(0)));

  //Name may not have extension so remove if it is there
  If (Pos('.', ExeName) > 0) Then
     Delete (ExeName, Pos('.', ExeName), Length(ExeName));

  //Validate calling app and parameters and return with SetDebugMode parameters for opcode 124
  If ((I1 = 1970) And (I2 = 937482) And (I3 = -611306)) Then
  Begin
    I1 := 0;
    I2 := 0;
    I3 := 0;
    EncodeOpCode (124, I1, I2, I3);  // Backdoor mode added for Konnect-IT
  End { If I1... }
  Else Begin
    // Unlicenced use - show fake access violation
    Randomize;
    lpCaption := 'Error';
    lpText    := Format ('%s caused an Access violation at address %8.8x in module KERNEL32.DLL', [ExeName, Random(2147000000)]);
    MessageBox(0, PCHAR(lpText), PCHAR(lpCaption), MB_OK Or MB_ICONERROR Or MB_TASKMODAL);
  End; { Else }
End;

Exports
  FSH_CTKDebugMode Index 1 Name '';
end.
