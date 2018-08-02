program VATInc;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form1},
  EnterpriseTradePlugIn_TLB in 'EnterpriseTradePlugIn_TLB.pas',
  oClient in 'oClient.pas' {VATInclusive: CoClass},
  EnterpriseTrade_TLB in 'x:\ENTRPRSE\EPOS\TRADE\EnterpriseTrade_TLB.pas';

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm := FALSE;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
