program EntTrade;

uses
  Forms,
  EnterpriseTrade_TLB in 'EnterpriseTrade_TLB.pas',
  oDummy in 'oDummy.pas' {Customisation: CoClass},
  CustIntU in 'CustIntU.pas',
  oFuncs in 'oFuncs.pas',
  oSysSetup in 'oSysSetup.pas',
  oVersion in 'oVersion.pas',
  oTrade in 'oTrade.pas',
  oHookPnt in 'oHookPnt.pas',
  oEvent in 'oEvent.pas',
  oTrans in 'oTrans.pas',
  VarCustm in 'VarCustm.pas',
  oCustTxt in 'oCustTxt.pas',
  oConfig in 'oConfig.pas',
  PIAboutF in 'PIAboutF.pas' {frmPlugInList},
  PIAbFram in 'PIAbFram.pas' {PlugInAboutFrame: TFrame},
  TCMainF in 'TCMainF.pas' {Form1},
  oUserPro in 'oUserPro.pas';

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
