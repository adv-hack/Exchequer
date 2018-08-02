program WhoIsDemo;

uses
  Forms,
  WhoIsMain in 'WhoIsMain.pas' {WhoIsForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TWhoIsForm, WhoIsForm);
  Application.Run;
end.
