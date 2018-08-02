program EntDel;

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  Forms,
  ScriptU in 'Scriptu.pas',
  progu in 'progu.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Enterprise Uninstall Utility';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
