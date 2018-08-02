program sysmessg;

uses
  ShareMem,
  Forms,
  sysdebug in 'sysdebug.pas' {Form_SysDebug},
  Sysmessg_TLB in 'Sysmessg_TLB.pas',
  DebugServer in 'DebugServer.pas' {DebugServer: CoClass};

{$R *.TLB}

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'On-Line Messages';
  Application.CreateForm(TForm_SysDebug, Form_SysDebug);
  Application.Run;
end.
