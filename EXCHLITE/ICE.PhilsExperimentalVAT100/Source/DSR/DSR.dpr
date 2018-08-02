Library DSR;

{$WARN SYMBOL_PLATFORM OFF}

uses
  ComServ,
  windows,
  DSR_TLB in 'DSR_TLB.pas',
  uDSRSERVER in 'uDSRSERVER.pas' {DSRSERVER: CoClass},
  uDSRFileFunc in 'uDSRFileFunc.pas',
  uDSRThreads in 'uDSRThreads.pas',
  uDSRGlobal in 'uDSRGlobal.pas',
  uDSRLock in 'uDSRLock.pas',
  uDSRSettings in 'uDSRSettings.pas',
  uDSRMail in 'uDSRMail.pas',
  uDSRExport in 'uDSRExport.pas',
  uMCM in 'uMCM.pas' {frmMCM},
  uDSRBaseThread in 'uDSRBaseThread.pas',
  uDSRCIS in 'uDSRCIS.pas',
  
  // 24/06/2013. PKR. Added for VAT 100 XML support.
  uDSRVAT100 in 'uDSRVAT100.pas',

  uDSRHistory in 'uDSRHistory.pas',
  uWrapperDSRSettings in 'uWrapperDSRSettings.pas';

Exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

//Implementation


{


http://www.mustangpeak.net/hooks_fix.htm

}

Procedure madPatch_ExitThreadTLS;
Var
  p: Pointer;
Begin
  If @TlsLast = Nil Then
    Exit;
  If TlsIndex <> -1 Then
  Begin
    p := TlsGetValue(TlsIndex);
    If p <> Nil Then
    Begin
  // The RTL will check the TLS value for nil so if we Free it first then
  // set it to nil when the RTL tries to free it will find it set to nil and
  // skip it
{$IFNDEF COMPILER_5_UP}
  // D5 and lower have already freed the TLS slot before calling this function
  // In these compilers we can't free the memory but we can nil it.
      LocalFree(Cardinal(p));
{$ENDIF COMPILER_5_UP}
      TlsSetValue(TlsIndex, Nil);
        // <- this fixes case (5), the RTL does not nil the value
    End;
  End;
End;

Var
  // D5 Fixes this problem;
{$IFNDEF COMPILER_5_UP}
  ControlWord: Word;
{$ENDIF}

Procedure DLLEntryProc(EntryCode: integer);
Begin
  Case EntryCode Of
    DLL_PROCESS_DETACH:
      Begin
  // D5 Fixes this problem;
{$IFNDEF COMPILER_5_UP}
        Set8087CW(ControlWord);
{$ENDIF}
      End;
    DLL_PROCESS_ATTACH:
      Begin
  // D5 Fixes this problem;
{$IFNDEF COMPILER_5_UP}
        Set8087CW($133F);
{$ENDIF}
      End;
    DLL_THREAD_ATTACH:
      Begin
      End;
    DLL_THREAD_DETACH:
      Begin
        madPatch_ExitThreadTLS;
      End;
  End;
End;

Begin
  DLLProc := @DLLEntryProc;
  // Since we are already in the Process Attache to get to this point we call the function
  // manually
  DLLEntryProc(DLL_PROCESS_ATTACH);
End.

