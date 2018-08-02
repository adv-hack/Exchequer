library WebRel;    // <-- deploy
//program WebRel; // <-- testing

uses
  IWInitISAPI,
  uWRServer in 'uWRServer.pas' {WRServer: TDataModule},
  uWRHome in 'UWRHOME.PAS' {frmHome: TIWForm1},
  uWRData in 'UWRDATA.PAS' {WRData: TDataModule},
  uWRSite in 'UWRSITE.PAS' {frmSite: TIWAppForm},
  uWRIntEntx in 'uWRIntEntx.pas' {frmIntEntx: TIWAppForm},
  uWRExtEntx in 'uWRExtEntx.pas' {frmExtEntx: TIWAppForm},
  uPermissionIDs in '..\..\..\SQL\SecAdmin2\uPermissionIDs.pas',
  uWRIntMods in 'uWRIntMods.pas' {frmIntMods: TIWAppForm},
  uWRIntOther in 'uWRIntOther.pas' {frmIntOther: TIWAppForm},
  uWRIntVect in 'uWRIntVect.pas' {frmIntVect: TIWAppForm},
  uWRIntPlugs in 'uWRIntPlugs.pas' {frmIntPlugs: TIWAppForm},
  uWRIntNone in 'uWRIntNone.pas' {frmIntNone: TIWAppForm},
  uCodeIDs in 'UCODEIDS.PAS',
  uWRDealers in 'uWRDealers.pas' {frmDealers: TIWAppForm},
  uWRModules in 'uWRModules.pas' {frmModules: TIWAppForm},
  uWRCustomers in 'uWRCustomers.pas' {frmCustomers: TIWAppForm},
  uWRUsers in 'UWRUSERS.PAS' {frmUsers: TIWAppForm},
  uWRedDealers in 'uWRedDealers.pas' {frmedDealers: TIWAppForm},
  uWRedUsers in 'uWRedUsers.pas' {frmedUsers: TIWAppForm},
  uWRedCustomers in 'uWRedCustomers.pas' {frmedCustomers: TIWAppForm},
  uWRExtNone in 'uWRExtNone.pas' {frmExtNone: TIWAppForm},
  uWRExtOther in 'uWRExtOther.pas' {frmExtOther: TIWAppForm},
  uWRExtTkit in 'uWRExtTkit.pas' {frmExtTkit: TIWAppForm},
  uWRSecAudit in 'uWRSecAudit.pas' {frmSecAudit: TIWAppForm},
  UWRADMIN in 'UWRADMIN.PAS' {frmAdmin: TIWAppForm},
  uWRedESNs in 'uWRedESNs.pas' {frmedESNs: TIWAppForm},
  uWRSpecESN in 'uWRSpecESN.pas' {frmSpecESN: TIWAppForm},
  uWRAdAudit in 'uWRAdAudit.pas' {frmAdminAudit: TIWAppForm},
  uWRThresholds in 'uWRThresholds.pas' {frmThresholds: TIWAppForm},
  SecSup2U in '..\..\..\ENTRPRSE\R&D\SECSUP2U.PAS',
  GlobVar in '..\..\..\ENTRPRSE\R&D\GLOBVAR.PAS',
  uCodeGen in 'UCODEGEN.PAS',
  ActiveX,
  uWRInstrx in 'uWRInstrx.pas' {frmInstructions: TIWAppForm},
  uWREmail in 'uWREmail.pas' {frmEmail: TIWAppForm},
  uWRExtMods in 'uWRExtMods.pas' {frmExtMods: TIWAppForm},
  LicFuncU in '..\..\..\SBSLIB\WIN\EXCOMMON\LICFUNCU.PAS',
  LicRec in '..\..\..\SBSLIB\WIN\EXCOMMON\LICREC.PAS',
  uWRExtPlug in 'uWRExtPlug.pas' {frmExtPlugs: TIWAppForm},
  uWRExtVect in 'uWRExtVect.pas' {frmExtVect: TIWAppForm};

{$R *.res}

begin

  IWRun(TfrmHome, TWRServer);

end.
