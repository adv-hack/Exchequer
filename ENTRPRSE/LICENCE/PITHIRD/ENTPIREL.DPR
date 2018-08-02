program EntPIRel;

uses
  Forms,
  DetailF in 'DETAILF.PAS' {frmDetail},
  SplashF in 'SPLASHF.PAS' {frmSplash},
  oPlugLic in '..\PILICGEN\OPLUGLIC.PAS',
  ESNImpU in '..\ESNIMPU.PAS',
  LicRec in '..\..\..\SBSLIB\WIN\EXCOMMON\LICREC.PAS',
  SerialU in '..\..\MULTCOMP\SERIALU.PAS',
  LicFuncU in '..\..\..\SBSLIB\WIN\EXCOMMON\LICFUNCU.PAS',
  Contkey in 'CONTKEY.PAS',
  SecSup2U in '..\..\R&D\SECSUP2U.PAS',
  Phonetic in '..\..\FUNCS\PHONETIC.PAS',
  SetupBas in '..\..\SETUP\SETUPBAS.PAS' {SetupTemplate},
  AboutF in 'AboutF.pas' {frmPlugInAbout},
  oConfig in 'X:\ENTRPRSE\LICENCE\PITHIRD\OCONFIG.PAS',
  PWordDlg in 'X:\ENTRPRSE\MULTCOMP\PWORDDLG.PAS' {PasswordDialog};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Enterprise Plug-In Release Code Utility';
  Application.CreateForm(TfrmSplash, frmSplash);
  Application.Run;
end.
