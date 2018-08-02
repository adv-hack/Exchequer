program RvServer;

uses
  Forms,
  RvServerMain in 'RvServerMain.pas' {ServerForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TServerForm, ServerForm);
  Application.Run;
end.
