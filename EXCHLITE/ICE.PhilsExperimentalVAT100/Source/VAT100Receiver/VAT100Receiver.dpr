Program VAT100Receiver;

uses
  Forms,
  uCommon,
  Windows,
  Sysutils,
  uFrmReceiver in 'uFrmReceiver.pas' {frmVAT100Receiver},
  uDSRSettings in '..\DSR\uDSRSettings.pas',
  DSRIncoming_TLB in '..\DSR\Incoming\DSRIncoming_TLB.pas';

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
      uFrmReceiver.StartVAT100Receiver(Trim(ParamStr(1)));
    Except
      On e: exception Do
      Begin
        Sleep(100);
        _LogMSG('An exception has occurred while calling StartVAT100Receiver. Error: ' +
          e.message);
      End; {begin}
    End; {try}
  End
  Else
    _LogMSG('Invalid parameter starting VAT100Receiver...');

  SetErrorMode(lErrorMode);
  Application.Terminate;
End.

