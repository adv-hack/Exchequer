program FTPResumeDemo;

uses
  Forms,
  FTPResumeDemoMain in 'FTPResumeDemoMain.pas' {ResumeForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TResumeForm, ResumeForm);
  Application.Run;
end.
