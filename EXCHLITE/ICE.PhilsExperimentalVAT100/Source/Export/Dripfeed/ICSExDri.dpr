library ICSExDri;

uses
  ComServ,
  IrisClientSync_TLB in 'IrisClientSync_TLB.pas',
  oExporter in 'oExporter.pas' {DripfeedDataExporter: CoClass},
  DSRExport_TLB in '..\..\ExportBox\DSRExport_TLB.pas',
  uEXCHBaseClass in '..\..\Common\uEXCHBaseClass.pas',
  uExportBaseClass in '..\..\Common\uExportBaseClass.pas',
  uBaseExportManager in '..\..\Common\uBaseExportManager.pas',
  uDripfeedExportManager in '..\..\Common\uDripfeedExportManager.pas',
  uDripfeedExport in '..\..\Common\uDripfeedExport.pas',
  uTransactionTracker in '..\..\Common\uTransactionTracker.pas',
  EntLicence in '..\..\..\..\..\ENTRPRSE\DRILLDN\EntLicence.pas',
  uICEDripFeed in '..\..\..\..\..\ENTRPRSE\R&D\uICEDripFeed.pas',
  uHistory in 'X:\EXCHLITE\ICE\Source\Common\uHistory.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
