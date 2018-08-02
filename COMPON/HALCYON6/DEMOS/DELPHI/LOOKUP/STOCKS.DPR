program Stocks;

uses
  Forms,
  Stocksu in 'Stocksu.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
