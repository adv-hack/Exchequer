library ICSExTra;

uses
  ComServ,
  DSRExport_TLB in '..\..\ExportBox\DSRExport_TLB.pas',
  uEXCHBaseClass in '..\..\Common\uEXCHBaseClass.pas',
  uExportBaseClass in '..\..\Common\uExportBaseClass.pas',
  uTransactionExportManager in '..\..\Common\uTransactionExportManager.pas',
  IrisClientSync_TLB in 'IrisClientSync_TLB.pas',
  oExporter in 'oExporter.pas' {TransactionDataExporter: CoClass},
  uTransactionExport in '..\..\Common\uTransactionExport.pas',
  uXMLFileManager in '..\..\Common\uXMLFileManager.pas',
  uXMLWriter in '..\..\Common\uXMLWriter.pas',
  uBaseExportManager in '..\..\Common\uBaseExportManager.pas',
  uTransactionTracker in '..\..\Common\uTransactionTracker.pas',
  uICEDripFeed in '..\..\..\..\..\ENTRPRSE\R&D\uICEDripFeed.pas',
  EntLicence in '..\..\..\..\..\ENTRPRSE\DRILLDN\EntLicence.pas',
  uOpeningBalanceExport in '..\..\Common\uOpeningBalanceExport.pas',
  uOpeningBalanceDB in '..\..\Common\uOpeningBalanceDB.pas',
  uHistory in '..\..\Common\uHistory.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
