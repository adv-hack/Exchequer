program RVRSCL;

uses
  Forms,
  Windows,  
  RSCLProc in 'RSCLProc.pas',
  StandaloneRSCL in 'StandaloneRSCL.pas',
  RVProc in '..\Shared\RVProc.pas',
  Progress in 'Progress.pas' {frmProgress};

{$R *.res}

{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/05/2016 : : Added PE flag release to plug-ins.

var
  RunRSCLFunction : TRunRSCLFunction;
begin
  Application.Initialize;

  RunRSCLFunction := TRunRSCLFunction.Create;
  RunRSCLFunction.Execute(Paramstr(1));
  RunRSCLFunction.Free;

  Application.Run;
end.
