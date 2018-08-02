program ComCallerDemo;

uses
  Forms,
  uComCallerDemo in 'uComCallerDemo.pas' {frmDSRCOM},
  RemotingClientLib_TLB in 'RemotingClientLib_TLB.pas',
  uDSR in 'uDSR.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmDSRCOM, frmDSRCOM);
  Application.Run;
end.
