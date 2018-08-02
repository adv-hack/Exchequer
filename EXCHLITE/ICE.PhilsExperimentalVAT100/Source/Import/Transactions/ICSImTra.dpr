library ICSImTra;

uses
  ComServ,
  DSRImport_TLB in '..\..\ImportBox\DSRImport_TLB.pas',
  uEXCHBaseClass in '..\..\Common\uEXCHBaseClass.pas',
  uImportBaseClass in '..\..\Common\uImportBaseClass.pas',
  IrisClientSync_TLB in 'IrisClientSync_TLB.pas',
  oImporter in 'oImporter.pas' {TransactionDataImporter: CoClass},
  uTransactionImport in '..\..\Common\uTransactionImport.pas',
  uHistoryImport in '..\..\Common\uHistoryImport.pas',
  uICEDripFeed in '..\..\..\..\..\ENTRPRSE\R&D\uICEDripFeed.pas',
  EntLicence in '..\..\..\..\..\ENTRPRSE\DRILLDN\EntLicence.pas',
  uTransactionTracker in '..\..\Common\uTransactionTracker.pas',
  uClientLicence in '..\..\Common\uClientLicence.pas',
  uOpeningBalanceImport in '..\..\Common\uOpeningBalanceImport.pas',
  uOBMatchingImport in '..\..\Common\uOBMatchingImport.pas',
  uHistory in '..\..\Common\uHistory.pas',
  uOpeningBalanceDB in '..\..\Common\uOpeningBalanceDB.pas',
  uCrossReference in '..\..\Common\uCrossReference.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
