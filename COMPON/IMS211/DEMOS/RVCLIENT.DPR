program RvClient;

uses
  Forms,
  RvClientMain in 'RvClientMain.pas' {ClientForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TClientForm, ClientForm);
  Application.Run;
end.
