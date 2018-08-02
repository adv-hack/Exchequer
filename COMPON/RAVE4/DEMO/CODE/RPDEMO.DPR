program RPDemo;

uses
  Forms,
  Main in 'MAIN.PAS' {MainForm},
  Demo01 in 'DEMO01.PAS' {Demo01Form},
  Demo02 in 'DEMO02.PAS' {Demo02Form},
  Demo03 in 'DEMO03.PAS' {Demo03Form},
  Demo04 in 'DEMO04.PAS' {Demo04Form},
  Demo05 in 'DEMO05.PAS' {Demo05Form},
  Demo06 in 'DEMO06.PAS' {Demo06Form},
  Demo07 in 'DEMO07.PAS' {Demo07Form},
  Demo08 in 'DEMO08.PAS' {Demo08Form},
  RTFDemo in 'RTFDEMO.PAS' {RTFDemoForm};

{$R *.RES}

begin
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
