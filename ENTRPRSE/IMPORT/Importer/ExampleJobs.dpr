program ExampleJobs;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  ExampleMain in 'ExampleMain.pas' {Form1},
  frmViewFile in 'frmViewFile.pas' {frmViewJobFile};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmViewJobFile, frmViewJobFile);
  Application.Run;
end.
