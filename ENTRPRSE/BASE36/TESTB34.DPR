program TESTB34;

uses
  Forms,
  Test34F in 'Test34F.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
