program ENSURVEY;

{$ALIGN 1}

{$REALCOMPATIBILITY ON}

uses
  Forms,
  SetupBas in '..\..\SETUP\SETUPBAS.PAS' {SetupTemplate},
  MainF in 'MAINF.PAS' {frmMainForm},
  oCompF in 'oCompF.pas',
  LicRec in '..\..\..\SBSLIB\WIN\EXCOMMON\LICREC.PAS',
  EntLic in '..\ENTLIC.PAS',
  oEntList in 'oEntList.pas',
  ResultsF in 'ResultsF.pas' {frmResults},
  SCANENTF in 'SCANENTF.PAS' {frmScanEnterprise},
  SurveyF in 'SurveyF.pas' {frmCustSurvey},
  oSysF in 'oSysF.pas',
  Contkey in 'X:\BESPOKE\EXCHEQR\CONTACTS\DLLHOOK\CONTKEY.PAS';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Pre-Upgrade Survey';
  Application.CreateForm(TfrmMainForm, frmMainForm);
  Application.Run;
end.
