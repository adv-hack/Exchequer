Program LogMonitor;

Uses
  windows,
  Forms,
  uLogMonitor In 'uLogMonitor.pas' {frmIceLogMonitor};

{$R *.res}

Var
  lHandle: Thandle;

Begin
  lHandle := Openmutex(MUTEX_ALL_ACCESS, False, 'IceLog');
  If lHandle = 0 Then
  Begin
    CreateMutex(Nil, True, 'IceLog');
    Application.Initialize;
    Application.Title := 'Log Monitor';
    Application.CreateForm(TfrmIceLogMonitor, frmIceLogMonitor);
    Application.ShowMainForm := False;
    Application.Run;
  End
End.

