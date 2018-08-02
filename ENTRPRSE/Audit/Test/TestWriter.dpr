program TestWriter;

uses
  Forms,
  TestF in 'TestF.pas' {Form1},
  AuditLog in '..\AuditLog.pas',
  AuditFindClass in 'W:\ENTRPRSE\R&D\AuditFindClass.Pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
