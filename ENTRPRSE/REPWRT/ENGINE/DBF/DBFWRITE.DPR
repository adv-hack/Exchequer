library DbfWrite;

uses
  ComServ,
  EnterpriseDBF_TLB in 'EnterpriseDBF_TLB.pas',
  oDbfMain in 'oDbfMain.pas' {DBFWriter: CoClass},
  DbfMod in 'DBFMOD.PAS' {dmDbf: TDataModule};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
