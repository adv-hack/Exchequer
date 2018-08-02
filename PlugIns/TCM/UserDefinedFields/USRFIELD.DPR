program UsrField;

uses
  Sharemem,
  Forms,
  EnterpriseTradePlugIn_TLB in 'EnterpriseTradePlugIn_TLB.pas',
  oClient in 'oClient.pas' {UserDefinedField: CoClass},
  EnterpriseTrade_TLB in 'x:\entrprse\epos\TRADE\EnterpriseTrade_TLB.pas',
  LineUDFs in 'LineUDFs.pas' {frmLineUDFs},
  MainForm in 'MAINFORM.PAS' {Form1},
  UDefProc in 'X:\PlugIns\User Defined Fields\COMMON\UDEFPROC.PAS',
  HeaderUDFs in 'HeaderUDFs.pas' {frmHeaderUDFs};

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm := FALSE;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
