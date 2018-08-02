program formtest;

uses
  Forms,
  SetupBas in 'Setupbas.pas' {SetupTemplate},
  testf in 'testf.pas' {SetupTemplate1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TSetupTemplate1, SetupTemplate1);
  Application.Run;
end.
