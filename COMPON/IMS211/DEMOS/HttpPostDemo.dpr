program HttpPostDemo;

uses
  Forms,
  HttpPostMain in 'HttpPostMain.pas' {PostTestForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TPostTestForm, PostTestForm);
  Application.Run;
end.
