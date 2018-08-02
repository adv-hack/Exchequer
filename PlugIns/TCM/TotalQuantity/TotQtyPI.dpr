program TotQtyPI;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form1},
  EnterpriseTradePlugIn_TLB in 'EnterpriseTradePlugIn_TLB.pas',
  oClient in 'oClient.pas' {TotalQuantity: CoClass};

{$R *.TLB}

{$R *.res}

begin
  Application.ShowMainForm := FALSE;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
