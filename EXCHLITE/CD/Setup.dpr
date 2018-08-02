program Setup;

uses
  D6OnHelpFix,
  conHTMLHelp,
  Forms,
  MainF in 'MainF.pas' {frmAutorun},
  PreReqs in 'PreReqs.pas',
  DotNet in '..\..\ENTRPRSE\FUNCS\DotNet.pas',
  ManualWiz3Frame in 'ManualWiz3Frame.pas' {fraManualWiz3: TFrame},
  PreReqsFrame in 'PreReqsFrame.pas' {fraPreReqs: TFrame},
  DebugU in 'DebugU.pas',
  WLicFile in '..\..\ENTRPRSE\CD\WLICFILE.PAS',
  LicRec in '..\..\SBSLIB\WIN\EXCOMMON\LicRec.pas',
  LicFuncU in '..\..\SBSLIB\WIN\EXCOMMON\LICFUNCU.PAS',
  SerialU in '..\..\entrprse\multcomp\SERIALU.PAS',
  Crypto in '..\..\ENTRPRSE\MULTCOMP\CRYPTO.PAS',
  InstallFrame in 'InstallFrame.pas' {fraInstall: TFrame},
  OptionsFrame in 'OptionsFrame.pas' {fraOptions: TFrame},
  PervWarningFrame in 'PervWarningFrame.pas' {fraPervasiveWarning: TFrame},
  LicDets in 'LicDets.pas',
  OSChecks in 'OSChecks.pas',
  TermServ in '..\..\ENTRPRSE\FUNCS\TERMSERV.PAS',
  UpgradeFrame in 'UpgradeFrame.pas' {fraUpgrade: TFrame},
  EntLicence in '..\..\ENTRPRSE\DRILLDN\EntLicence.pas',
  DisplayDetailsFrame in 'DisplayDetailsFrame.pas' {fraDisplaysDets: TFrame},
  EntLic in '..\..\ENTRPRSE\MULTCOMP\ENTLIC.PAS',
  BrowseF in 'BrowseF.pas' {frmBrowseForLITE},
  oIRISLicence in '..\IRIS Licencing\oIRISLicence.pas',
  ELITE_COM_TLB in '..\IRIS Licencing\ELITE_COM_TLB.pas',
  CheckListFrame in 'CheckListFrame.pas' {fraCheckList: TFrame},
  ManualWiz1Frame in 'ManualWiz1Frame.pas' {fraManualWiz1: TFrame},
  ManualWiz2Frame in 'ManualWiz2Frame.pas' {fraManualWiz2: TFrame},
  WizdMsg in 'WizdMsg.pas',
  DownloadFrame in 'DownloadFrame.pas' {fraDownload: TFrame},
  OSErrorFrame in 'OSErrorFrame.pas' {fraOSError: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.HelpFile := 'Setup.Chm';
  Application.CreateForm(TfrmAutorun, frmAutorun);
  Application.Run;
end.
