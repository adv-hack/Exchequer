program DemoDll;

{$REALCOMPATIBILITY ON}
{$Align 1}

uses
  Forms,
  uDemoDll in 'uDemoDll.pas' {Form1},
  uCommon in '..\Common\uCommon.pas',
  ComCaller_TLB in '..\DsrComCaller\ComCaller_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
