program xdomexample03;

uses
  Forms,
  example03main in 'example03main.pas' {Mainpage};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainpage, Mainpage);
  Application.Run;
end.
