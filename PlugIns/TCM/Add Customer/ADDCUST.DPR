program AddCust;

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  Forms,
  Windows,  
  MainForm in 'MainForm.pas' {Form1},
  EnterpriseTradePlugIn_TLB in 'EnterpriseTradePlugIn_TLB.pas',
  oClient in 'oClient.pas' {AddCustomer: CoClass},
  EnterpriseTrade_TLB in 'x:\entrprse\EPOS\TRADE\EnterpriseTrade_TLB.pas',
  CustDet in 'CustDet.pas' {frmAddCust},
  UserKey in 'USERKEY.PAS',
  UAFDCODE in 'UAFDCODE.PAS' {frmPostcodes};

{$R *.TLB}

{$R *.res}

{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/05/2016 : : Added PE flag release to plug-ins.

begin
  Application.Initialize;
  Application.ShowMainForm := FALSE;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmPostcodes, frmPostcodes);
  Application.Run;
end.
