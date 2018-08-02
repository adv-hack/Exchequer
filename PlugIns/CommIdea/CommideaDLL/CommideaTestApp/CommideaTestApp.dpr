program CommideaTestApp;

{$REALCOMPATIBILITY ON}

uses
  Sharemem,
  Forms,
  Main in 'Main.pas' {Form2},
  CommideaInt in '..\ExCommid.Dll\CommideaInt.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
