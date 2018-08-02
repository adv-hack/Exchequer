program TCMWEEEPI;

uses
  Forms,
  Windows,  
  MainForm in 'MainForm.pas' {Form1},
  EnterpriseTradePlugIn_TLB in 'EnterpriseTradePlugIn_TLB.pas',
  oClient in 'oClient.pas' {WEEE: CoClass},
  WEEEProc in '..\common\WEEEPROC.PAS',
  ExchequerRelease in '\SBSLib\Win\ExCommon\ExchequerRelease.pas';

{$R *.TLB}

{$R *.res}

{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/05/2016 : : Added PE flag release to plug-ins.

begin
  Application.ShowMainForm := FALSE;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
