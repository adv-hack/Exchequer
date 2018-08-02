program DSRDemo;

uses
  Forms,
  uDsrDemo in 'uDsrDemo.pas' {frmComDSRDemo},
  DSR_TLB in '..\DSR_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmComDSRDemo, frmComDSRDemo);
  Application.Run;
end.
