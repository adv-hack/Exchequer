program PDQWedge;

{$REALCOMPATIBILITY ON}

uses
  Forms,
  PDQWedgeMain in 'PDQWedgeMain.pas' {Form1},
  EnterpriseTradePlugIn_TLB in 'EnterpriseTradePlugIn_TLB.pas',
  oClient in 'oClient.pas' {PDQWedge: CoClass},
  Swipe in 'SWIPE.PAS' {frmSwipe},
  ASK in 'ASK.PAS' {FrmCheckSig},
  ReferralDialog in 'ReferralDialog.pas' {frmReferralDialog},
  ManualEntry in 'ManualEntry.pas' {frmManualEntry},
  CardReaderU in 'CardReaderU.pas',
  CardReaderErrors in 'CardReaderErrors.pas',
  CommideaInt in '..\CommideaDLL\ExCommid.Dll\CommideaInt.pas';

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm := FALSE;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
