program PDQWedge;

{$REALCOMPATIBILITY ON}

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  Windows,  
  PDQWedgeMain in 'PDQWedgeMain.pas' {Form1},
  EnterpriseTradePlugIn_TLB in 'EnterpriseTradePlugIn_TLB.pas',
  oClient in 'oClient.pas' {PDQWedge: CoClass},
  EnterpriseTrade_TLB in 'X:\ENTRPRSE\EPOS\TRADE\EnterpriseTrade_TLB.pas',
  Swipe in 'SWIPE.PAS' {frmSwipe},
  ASK in 'ASK.PAS' {FrmCheckSig},
  CommideaInt in '..\CommideaDLL\ExCommid.Dll\CommideaInt.pas',
  ReferralDialog in 'ReferralDialog.pas' {frmReferralDialog},
  ManualEntry in 'ManualEntry.pas' {frmManualEntry};

{$R *.TLB}

{$R *.res}

{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/05/2016 : : Added PE flag release to plug-ins.

begin
  Application.Initialize;
  Application.ShowMainForm := FALSE;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
