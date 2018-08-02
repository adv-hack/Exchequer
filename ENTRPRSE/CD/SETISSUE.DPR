program SetIssue;

uses
  Forms,
  IssueF in 'IssueF.pas' {Form1},
  IssueU in 'IssueU.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Exchequer v5.00 Issue No Editor';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
