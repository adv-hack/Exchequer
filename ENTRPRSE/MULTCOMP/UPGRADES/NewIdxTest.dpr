program NewIdxTest;

uses
  Forms,
  MainF in 'MainF.pas' {Form1},
  IdxObj in 'IdxObj.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
