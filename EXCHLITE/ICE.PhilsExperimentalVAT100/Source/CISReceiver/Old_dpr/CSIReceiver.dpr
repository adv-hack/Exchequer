Program CSIReceiver;

Uses
  Forms,
  uCommon,
  Windows,
  Sysutils,
  uFrmReceiver In 'uFrmReceiver.pas' {frmCISReceiver},
  uDSRSettings In
  'X:\EXCHLITE\ICE\Source\DSR\uDSRSettings.pas',
  CISIncoming_TLB In
  'X:\EXCHLITE\ICE\Source\CISIncoming\CISIncoming_TLB.pas',
  DSRIncoming_TLB In
  'X:\EXCHLITE\ICE\Source\DSR\Incoming\DSRIncoming_TLB.pas';

{$R *.res}
Var
  lErrorMode: Cardinal;
Begin
  lErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS Or SEM_NOOPENFILEERRORBOX Or
    SEM_NOGPFAULTERRORBOX);

  Application.Initialize;

  If _IsValidGuid(Trim(ParamStr(1))) Then
  Begin
    Try
      uFrmReceiver.StartCISReceiver(Trim(ParamStr(1)));
    Except
      On e: exception Do
      Begin
        Sleep(100);
        _LogMSG('An exception has occurred while calling StartCISReceiver. Error: ' +
          e.message);
      End; {begin}
    End; {try}
  End
  Else
    _LogMSG('Invalid parameter starting CISReceiver...');

  SetErrorMode(lErrorMode);
  Application.Terminate;
End.

