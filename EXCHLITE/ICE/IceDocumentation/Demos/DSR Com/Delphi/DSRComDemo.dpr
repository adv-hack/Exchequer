program DSRComDemo;

uses
  Forms,
  uDSRComDemo in 'uDSRComDemo.pas' {frmDSRCOM},
  RemotingClientLib_TLB in 'RemotingClientLib_TLB.pas',
  uDSR in 'uDSR.pas',
  uAddPackage in 'uAddPackage.pas' {frmAddPackage};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmDSRCOM, frmDSRCOM);
  Application.CreateForm(TfrmAddPackage, frmAddPackage);
  Application.Run;
end.
