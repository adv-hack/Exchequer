program EXSURVEY;

{$ALIGN 1}

{$REALCOMPATIBILITY ON}

uses
  Forms,
  First in 'Common\First.pas',
  BaseF in 'Common\BaseF.PAS' {SetupTemplate},
  oBaseDataClasses in 'Common\oBaseDataClasses.pas',
  DataFileInfo in 'Common\DataFileInfo.pas',
  IntroductionF in 'Common\IntroductionF.PAS' {frmMainForm},
  LicRec in '..\..\..\SBSLIB\WIN\EXCOMMON\LICREC.PAS',
  EntLic in '..\..\multcomp\ENTLIC.PAS',
  oSurveyStore in 'Common\oSurveyStore.PAS',
  SendResultsF in 'Common\SendResultsF.Pas' {frmResults},
  ScanCompaniesF in 'Common\ScanCompaniesF.PAS' {frmScanEnterprise},
  SurveyF in 'Common\SurveyF.PAS' {frmCustSurvey},
  DebugU in 'Common\DebugU.pas',
  SurveyBaseFrame in 'Common\SurveyBaseFrame.pas' {SurveyFrameBase: TFrame},
  SurveyOSFrame in 'Common\SurveyOSFrame.pas' {SurveyFrameOperatingSystems: TFrame},
  SurveyMarketingFrame in 'Common\SurveyMarketingFrame.pas' {SurveyFrameMarketing: TFrame},
  SurveyContactFrame in 'Common\SurveyContactFrame.pas' {SurveyFrameContactDetails: TFrame},
  SurveyOfficeFrame in 'Common\SurveyOfficeFrame.pas' {SurveyFrameOfficeVersions: TFrame},
  History in 'Common\History.pas',
  CompanySysAnalysis in 'Common\CompanySysAnalysis.pas',
  ConvUtil in 'Common\ConvUtil.pas',
  oSurveyDriveSpace in 'Common\oSurveyDriveSpace.pas',
  oSurveyPlugIn in 'Common\oSurveyPlugIn.PAS';

{$R *.res}
{$R x:\entrprse\formdes2\winxpman.res}

begin
  Application.Initialize;
  Application.Title := 'Exchequer v7.0 Pre-Upgrade Survey';
  Application.CreateForm(TfrmMainForm, frmMainForm);
  Application.Run;
end.
