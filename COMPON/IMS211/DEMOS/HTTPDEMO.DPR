program HttpDemo;

uses
  Forms,
  HttpMain in 'HttpMain.pas' {HTTPForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(THTTPForm, HTTPForm);
  Application.Run;
end.
