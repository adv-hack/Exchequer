program CISSubDemo;

uses
  Forms,
  uCISSubDemo in 'uCISSubDemo.pas' {Form1},
  CISExSubcontractor_TLB in 'X:\EXCHLITE\ICE\Source\Export\CIS\Subcontractors\CISExSubcontractor_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
