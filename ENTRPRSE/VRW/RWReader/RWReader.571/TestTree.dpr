program TestTree;

uses
  Sharemem,
  Forms,
  TestTreeF in 'TestTreeF.pas' {Form1},
  RWRIntF in 'RWRIntF.pas',
  RepDetsF in 'RepDetsF.pas' {frmReportDets};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
