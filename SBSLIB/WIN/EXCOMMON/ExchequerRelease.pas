Unit ExchequerRelease;

Interface

Const
  // Major Exchequer Release Name
  ExchequerReleaseName = 'Exchequer 2018 R1.1';

Type
  // Modules utilising the ExchequerModuleVersion function - allows for custom behaviour if necessary
  enumExchequerModule = (emMCM, emFormDesigner, emSBSForm, emOLEServer,
                         emEntRW, emRepEngine,
                         emExcelDataQuery, emExcelDataQueryAddIn,
                         emExcelDrillDown, emExcelDrillDownAddIn,
                         emTradeCounter, emTradeCounterAdmin,
                         emExtendedSearch, emOutlookDynamicDashboard,
                         emEbusinessAdmin, emEbusinessImport,
                         emEbusinessExport, emEbusinessSettings,
                         emEbusinessXMLDLL, ebEbusinessXMLWriter,
                         emSentimail, emImporter, emEBanking,
                         emScheduler, emEarnie, emJobCard, emFax,
                         emEntReg, emSpecialFunctions, emTestCOM,
                         emCDLicenceViewer, emGenericPlugIn, emAuthorise,
                         emDocNos
                        );

// Returns a module version number string incorporation the Major Exchequer Release Name
Function ExchequerModuleVersion (Const Module : enumExchequerModule; Const ModuleBuildNo : ShortString) : ShortString;

Implementation

Uses SysUtils;

// Returns a module version number string incorporation the Major Exchequer Release Name
Function ExchequerModuleVersion (Const Module : enumExchequerModule; Const ModuleBuildNo : ShortString) : ShortString;
Begin // ExchequerModuleVersion
  Result := ExchequerReleaseName + ' Build ' + Trim(ModuleBuildNo);
End; // ExchequerModuleVersion

End.
