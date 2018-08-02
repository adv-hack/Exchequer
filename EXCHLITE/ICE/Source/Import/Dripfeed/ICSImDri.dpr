library ICSImDri;

uses
  ComServ,
  DSRImport_TLB in '..\..\ImportBox\DSRImport_TLB.pas',
  uEXCHBaseClass in '..\..\Common\uEXCHBaseClass.pas',
  uBaseClass in '..\..\Common\uBaseClass.pas',
  uImportBaseClass in '..\..\Common\uImportBaseClass.pas',
  IrisClientSync_TLB in 'IrisClientSync_TLB.pas',
  oImporter in 'oImporter.pas' {DripfeedDataImporter: CoClass},
  uDripfeedImport in '..\..\Common\uDripfeedImport.pas',
  EntLicence in 'X:\ENTRPRSE\DRILLDN\EntLicence.pas',
  uClientLicence in 'X:\EXCHLITE\ICE\Source\Common\uClientLicence.pas',
  uTransactionTracker in 'X:\EXCHLITE\ICE\Source\Common\uTransactionTracker.pas',
  uHistory in 'X:\EXCHLITE\ICE\Source\Common\uHistory.pas',
  uCrossReference in 'X:\EXCHLITE\ICE\Source\Common\uCrossReference.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
