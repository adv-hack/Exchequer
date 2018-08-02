Unit DataFileInfo;

Interface

Uses SysUtils;

Type
  // Enumeration lists all the files to be checked by the Pre-Upgrade Survey
  TExchequerDataFiles = (
                          // Root company only tables
                          edfCompany,         // Company.Dat
                          edfGroupCmp,
                          edfGroups,          // Groups.Dat
                          edfGroupUsr,        // GroupUsr.Dat
                          edfContact,         // Contact.Dat
                          edfEbus,            // Ebus.Dat
                          edfEmpPay,          // JC\EmpPay.Dat
                          edfFaxes,           // FaxSrv\Faxes.Dat
                          edfImportJob,       // Misc\ImportJob.Dat
                          edfMCPay,           // JC\MCPay.Dat
                          edfPAAuth,          // Workflow\PAAuth.Dat
                          edfPAComp,          // Workflow\PAComp.Dat
                          edfPAEAR,           // Workflow\PAEAR.Dat
                          edfPAGlobal,        // Workflow\PAGlobal.Dat
                          edfPAUser,          // Workflow\PAUser.Dat
                          edfSchedCfg,        // SchedCfg.Dat
                          edfSentSys,         // SentSys.Dat
                          edfTillName,        // Trade\TillName.Dat
                          edfTools,           // Tools.Dat

                          // Per Company Tables
                          {$IFDEF SQLSurvey}
                          edfAllocWizardSession,  // Normalised SQL Table
                          edfAnalysisCodeBudget,  // Normalised SQL Table
                          {$ENDIF}
                          edfCCDeptV,         // CCDeptV.Dat
                          edfColSet,          // Misc\ColSet.Dat
                          edfCommssn,         // SalesCom\Commssn.Dat
                          {$IFDEF SQLSurvey}
                          edfCustomerDiscount,      // Normalised SQL Table
                          edfCustomerStockAnalysis, // Normalised SQL Table
                          {$ENDIF}
                          edfCustomFields,    // Misc\CustomFields.Dat
                          edfCustSupp,        // Cust\CustSupp.Dat
                          edfDetails,         // Trans\Details.Dat
                          edfDocument,        // Trans\Document.Dat
                          edfEbusDetl,        // Ebus\EbusDetl.Dat
                          edfEbusDoc,         // Ebus\EbusDoc.Dat
                          edfEbusLkup,        // Ebus\EbusLkup.Dat
                          edfEbusNote,        // Ebus\EbusNote.Dat
                          edfExchqChk,        // Misc\ExchqChk.Dat
                          edfExchqNum,        // ExchqNum.Dat
                          edfExchqSS,         // ExchqSS.Dat
                          edfExStkChk,        // Misc\ExStkChk.Dat
                          {$IFDEF SQLSurvey}
                          edfFinancialMatching,  // Normalised SQL Table
                          {$ENDIF}
                          edfHistory,         // Trans\History.Dat
                          edfHistPurge,       // Trans\HistPrge.Dat
                          edfJobCtrl,         // Jobs\JobCtrl.Dat
                          edfJobDet,          // Jobs\JobDet.Dat
                          edfJobHead,         // Jobs\JobHead.Dat
                          edfJobMisc,         // Jobs\JobMisc.Dat
                          {$IFDEF SQLSurvey}
                          edfJobTotalsBudget,   // Normalised SQL Table
                          {$ENDIF}
                          edfLBin,            // Trade\LBin.Dat
                          edfLHeader,         // Trade\LHeader.Dat
                          edfLLines,          // Trade\LLines.Dat
                          {$IFDEF SQLSurvey}
                          edfLocation,        // Normalised SQL Table
                          {$ENDIF}
                          edfLSerial,         // Trade\LSerial.Dat
                          edfMLocStk,         // Stock\MLocStk.Dat
                          edfMultiBuy,        // Misc\MultiBuy.Dat
                          edfNominal,         // Trans\Nominal.Dat
                          edfNomView,         // Trans\NomView.Dat
                          edfPaprSize,        // Forms\PaprSize.Dat
                          edfParSet,          // Misc\ParSet.Dat
                          edfPPCust,          // PromPay\PPCust.Dat
                          edfPPDebt,          // PromPay\PPDebt.Dat
                          edfPPSetup,         // PromPay\PPSetup.Dat
                          edfQtyBreak,         // Misc\QtyBreak.Dat
                          edfSaleCode,        // SalesCom\SaleCode.Dat
                          edfSchedule,        // Schedule\Schedule.Dat
                          edfSCType,          // SalesCom\SCType.Dat
                          edfSent,            // Smail\Sent.Dat
                          edfSentLine,        // Smail\SentLine.Dat
                          {$IFDEF SQLSurvey}
                          edfSerialBatch,     // Normalised SQL Table
                          {$ENDIF}
                          edfSettings,        // Misc\Settings.Dat
                          edfSortView,        // Misc\SortView.Dat
                          edfStock,           // Stock\Stock.Dat
                          {$IFDEF SQLSurvey}
                          edfStockLocation,   // Normalised SQL Table
                          {$ENDIF}
                          edfSVUsrDef,        // Misc\SVUsrDef.Dat
                          {$IFDEF SQLSurvey}
                          edfTransactionNote, // Normalised SQL Table
                          {$ENDIF}
                          edfUDEntity,        // UDEntity.Dat
                          edfUDField,         // UDField.Dat
                          edfUDItem,          // UDItem.Dat
                          edfVatOpt,          // VatPer\VatOpt.Dat
                          edfVatPrd,          // VatPer\VatPrd.Dat
                          edfVRWSec,          // Reports\VRWSec.Dat
                          edfVRWTree,         // Reports\VRWTree.Dat
                          edfWinSet,          // Misc\WinSet.Dat
                          edfWRWReports       // Reports/Reports.Dat
                        );

  //------------------------------

  // Generic interface for objects which implement a specific import type
  IExchequerDataFileInfo = Interface
    ['{3E08FBED-48DF-492B-A244-F742995E469F}']
    // --- Internal Methods to implement Public Properties ---
    Function GetFileType : TExchequerDataFiles;
    Function GetCommon : Boolean;
    Function GetOptional : Boolean;
    Function GetFilename : ShortString;
    Function GetSubDirectory : ShortString;

    // ------------------ Public Properties ------------------
    Property dfiFileType : TExchequerDataFiles Read GetFileType;
    // Indicates if file/table is in the common schema / root company only
    Property dfiCommon : Boolean Read GetCommon;
    // Indicates if the file/table is for an optional component and can be missing
    Property dfiOptional : Boolean Read GetOptional;
    Property dfiFilename : ShortString Read GetFilename;
    Property dfiSubDirectory : ShortString Read GetSubDirectory;

    // ------------------- Public Methods --------------------
  End; // IExchequerDataFileInfo

  //------------------------------

// Returns an IExchequerDataFileInfo instance for he specified file
Function ExchequerDataFiles (Const FileType : TExchequerDataFiles) : IExchequerDataFileInfo;

Implementation

Type
  // Different validation methods to be applied to files
  TInstallationCheckMode = (
                             icmStandardFile,
                             icmHistoryPurge,
                             icmEBusiness,
                             icmTradeCounter,
                             icmFaxing,
                             icmImporter,
                             icmJobCard,
                             icmRepWrt,
                             icmScheduler,
                             icmSentimail,
                             icmVRW,
                             icmAuthorisePlugIn,
                             icmCCDeptPlugIn,
                             icmContactsPlugIn,
                             icmPromptPayPlugIn,
                             icmSalesCommPlugIn,
                             icmUserFieldsPlugIn,
                             icmVATPeriodPlugIn
                           );

  //------------------------------

  TExchequerDataFileInfo = Class(TInterfacedObject, IExchequerDataFileInfo)
  Private
    FFileType : TExchequerDataFiles;
    FCommon : Boolean;
    FOptional : Boolean;
    FFilename : ShortString;
    FSubDirectory : ShortString;
    FInstallationCheckMode : TInstallationCheckMode;

    // IExchequerDataFileInfo
    Function GetFileType : TExchequerDataFiles;
    Function GetCommon : Boolean;
    Function GetOptional : Boolean;
    Function GetFilename : ShortString;
    Function GetSubDirectory : ShortString;
  Public
    Constructor Create (Const FileType : TExchequerDataFiles; Const Common, Optional : Boolean; Const Filename, SubDirectory : ShortString; Const InstallationCheckMode : TInstallationCheckMode);
  End; // TExchequerDataFileInfo

//=========================================================================

Function ExchequerDataFiles (Const FileType : TExchequerDataFiles) : IExchequerDataFileInfo;
Begin // ExchequerDataFiles
  Case FileType Of
    // Common Tables / Root Company Data Files ----------------------------

    // Company.Dat
    edfCompany         : Result := TExchequerDataFileInfo.Create(FileType, True,  False,  'Company',    '',          icmStandardFile);
    // GroupCmp.Dat
    edfGroupCmp        : Result := TExchequerDataFileInfo.Create(FileType, True,  False,  'GroupCmp',   '',          icmStandardFile);
    // Groups.Dat
    edfGroups          : Result := TExchequerDataFileInfo.Create(FileType, True,  False,  'Groups',     '',          icmStandardFile);
    // GroupUsr.Dat
    edfGroupUsr        : Result := TExchequerDataFileInfo.Create(FileType, True,  False,  'GroupUsr',   '',          icmStandardFile);
    // Contact.Dat
    edfContact         : Result := TExchequerDataFileInfo.Create(FileType, True,  True,   'Contact',    '',          icmContactsPlugIn);
    // Ebus.Dat
    edfEbus            : Result := TExchequerDataFileInfo.Create(FileType, True,  False,  'Ebus',       '',          icmEBusiness);
    // JC\EmpPay.Dat
    edfEmpPay          : Result := TExchequerDataFileInfo.Create(FileType, True,  False,  'EmpPay',     'JC',        icmJobCard);
    // FaxSrv\Faxes.Dat
    edfFaxes           : Result := TExchequerDataFileInfo.Create(FileType, True,  False,  'Faxes',      'FaxSrv',    icmFaxing);
    // Misc\ImportJob.Dat
    edfImportJob       : Result := TExchequerDataFileInfo.Create(FileType, True,  False,  'ImportJob',  'Misc',      icmImporter);
    // JC\MCPay.Dat
    edfMCPay           : Result := TExchequerDataFileInfo.Create(FileType, True,  False,  'MCPay',      'JC',        icmJobCard);
    // Workflow\PAAuth.Dat
    edfPAAuth          : Result := TExchequerDataFileInfo.Create(FileType, True,  True,   'PAAuth',     'Workflow',  icmAuthorisePlugIn);
    // Workflow\PAComp.Dat
    edfPAComp          : Result := TExchequerDataFileInfo.Create(FileType, True,  True,   'PAComp',     'Workflow',  icmAuthorisePlugIn);
    // Workflow\PAEAR.Dat
    edfPAEAR           : Result := TExchequerDataFileInfo.Create(FileType, True,  True,   'PAEAR',      'Workflow',  icmAuthorisePlugIn);
    // Workflow\PAGlobal.Dat
    edfPAGlobal        : Result := TExchequerDataFileInfo.Create(FileType, True,  True,   'PAGlobal',   'Workflow',  icmAuthorisePlugIn);
    // Workflow\PAUser.Dat
    edfPAUser          : Result := TExchequerDataFileInfo.Create(FileType, True,  True,   'PAUser',     'Workflow',  icmAuthorisePlugIn);
    // SchedCfg.Dat
    edfSchedCfg        : Result := TExchequerDataFileInfo.Create(FileType, True,  False,  'SchedCfg',   '',          icmScheduler);
    // SentSys.Dat
    edfSentSys         : Result := TExchequerDataFileInfo.Create(FileType, True,  True,   'SentSys',    '',          icmSentimail);
    // Trade\TillName.Dat
    edfTillName        : Result := TExchequerDataFileInfo.Create(FileType, True,  True,   'TillName',   'Trade',     icmTradeCounter);
    // Tools.Dat
    edfTools           : Result := TExchequerDataFileInfo.Create(FileType, True,  False,  'Tools',      '',          icmStandardFile);

    // Per Company Tables / Data Files ----------------------------

    {$IFDEF SQLSurvey}
    // Normalised SQL Table
    edfAllocWizardSession : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'AllocWizardSession', '', icmStandardFile);
    // Normalised SQL Table
    edfAnalysisCodeBudget : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'AnalysisCodeBudget', '', icmStandardFile);
    {$ENDIF}
    // CCDeptV.Dat
    edfCCDeptV         : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'CCDeptV',    '',          icmCCDeptPlugIn);
    // Misc\ColSet.Dat
    edfColSet          : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'ColSet',     'Misc',      icmStandardFile);
    // SalesCom\Commssn.Dat
    edfCommssn         : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'Commssn',    'SalesCom',  icmSalesCommPlugIn);
    {$IFDEF SQLSurvey}
    // Normalised SQL Table
    edfCustomerDiscount      : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'CustomerDiscount', '', icmStandardFile);
    // Normalised SQL Table
    edfCustomerStockAnalysis : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'CustomerStockAnalysis', '', icmStandardFile);
    {$ENDIF}
    // Misc\CustomFields.Dat
    edfCustomFields    : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'CustomFields','Misc',     icmStandardFile);
    // Cust\CustSupp.Dat
    edfCustSupp        : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'CustSupp',   'Cust',      icmStandardFile);
    // Trans\Details.Dat
    edfDetails         : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'Details',    'Trans',     icmStandardFile);
    // Trans\Document.Dat
    edfDocument        : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'Document',   'Trans',     icmStandardFile);
    // Ebus\EbusDetl.Dat
    edfEbusDetl        : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'EbusDetl',   'Ebus',      icmEBusiness);
    // Ebus\EbusDoc.Dat
    edfEbusDoc         : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'EbusDoc',    'Ebus',      icmEBusiness);
    // Ebus\EbusLkup.Dat
    edfEbusLkup        : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'EbusLkup',   'Ebus',      icmEBusiness);
    // Ebus\EbusNote.Dat
    edfEbusNote        : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'EbusNote',   'Ebus',      icmEBusiness);
    // Misc\ExchqChk.Dat
    edfExchqChk        : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'ExchqChk',   'Misc',      icmStandardFile);
    // ExchqNum.Dat
    edfExchqNum        : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'ExchqNum',   '',          icmStandardFile);
    // ExchqSS.Dat
    edfExchqSS         : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'ExchqSS',    '',          icmStandardFile);
    // Misc\ExStkChk.Dat
    edfExStkChk        : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'ExStkChk',   'Misc',      icmStandardFile);
    {$IFDEF SQLSurvey}
    // Normalised SQL Table
    edfFinancialMatching : Result := TExchequerDataFileInfo.Create(FileType, False, True, 'FinancialMatching', '', icmStandardFile);
    {$ENDIF}
    // Trans\History.Dat
    edfHistory         : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'History',    'Trans',     icmStandardFile);
    // Trans\HistPrge.Dat
    edfHistPurge       : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'HistPrge',   'Trans',     icmHistoryPurge);
    // Jobs\JobCtrl.Dat
    edfJobCtrl         : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'JobCtrl',    'Jobs',      icmStandardFile);
    // Jobs\JobDet.Dat
    edfJobDet          : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'JobDet',     'Jobs',      icmStandardFile);
    // Jobs\JobHead.Dat
    edfJobHead         : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'JobHead',    'Jobs',      icmStandardFile);
    // Jobs\JobMisc.Dat
    edfJobMisc         : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'JobMisc',    'Jobs',      icmStandardFile);
    {$IFDEF SQLSurvey}
    // Normalised SQL Table
    edfJobTotalsBudget : Result := TExchequerDataFileInfo.Create(FileType, False, True, 'JobTotalsBudget', '', icmStandardFile);
    {$ENDIF}
    // Trade\LBin.Dat
    edfLBin            : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'LBin',       'Trade',     icmTradeCounter);
    // Trade\LHeader.Dat
    edfLHeader         : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'LHeader',    'Trade',     icmTradeCounter);
    // Trade\LLines.Dat
    edfLLines          : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'LLines',     'Trade',     icmTradeCounter);
    {$IFDEF SQLSurvey}
    // Normalised SQL Table
    edfLocation        : Result := TExchequerDataFileInfo.Create(FileType, False, True, 'Location', '', icmStandardFile);
    {$ENDIF}
    // Trade\LSerial.Dat
    edfLSerial         : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'LSerial',    'Trade',     icmTradeCounter);
    // Stock\MLocStk.Dat
    edfMLocStk         : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'MLocStk',    'Stock',     icmStandardFile);
    // Misc\MultiBuy.Dat
    edfMultiBuy        : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'MultiBuy',   'Misc',      icmStandardFile);
    // Trans\Nominal.Dat
    edfNominal         : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'Nominal',    'Trans',     icmStandardFile);
    // Trans\NomView.Dat
    edfNomView         : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'NomView',    'Trans',     icmStandardFile);
    // Forms\PaprSize.Dat
    edfPaprSize        : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'PaprSize',   'Forms',     icmStandardFile);
    // Misc\ParSet.Dat
    edfParSet          : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'ParSet',     'Misc',      icmStandardFile);
    // PromPay\PPCust.Dat
    edfPPCust          : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'PPCust',     'PromPay',   icmPromptPayPlugIn);
    // PromPay\PPDebt.Dat
    edfPPDebt          : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'PPDebt',     'PromPay',   icmPromptPayPlugIn);
    // PromPay\PPSetup.Dat
    edfPPSetup         : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'PPSetup',    'PromPay',   icmPromptPayPlugIn);
    // Misc\QtyBreak.Dat
    edfQtyBreak        : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'QtyBreak',   'Misc',      icmStandardFile);
    // SalesCom\SaleCode.Dat
    edfSaleCode        : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'SaleCode',   'SalesCom',  icmSalesCommPlugIn);
    // Schedule\Schedule.Dat
    edfSchedule        : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'Schedule',   'Schedule',  icmStandardFile);
    // SalesCom\SCType.Dat
    edfSCType          : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'SCType',     'SalesCom',  icmSalesCommPlugIn);
    // Smail\Sent.Dat
    edfSent            : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'Sent',       'Smail',     icmSentimail);
    // Smail\SentLine.Dat
    edfSentLine        : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'SentLine',   'Smail',     icmSentimail);
    {$IFDEF SQLSurvey}
    // Normalised SQL Table
    edfSerialBatch     : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'SerialBatch', '',         icmStandardFile);
    {$ENDIF}
    // Misc\Settings.Dat
    edfSettings        : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'Settings',   'Misc',      icmStandardFile);
    // Misc\SortView.Dat
    edfSortView        : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'SortView',   'Misc',      icmStandardFile);
    // Stock\Stock.Dat
    edfStock           : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'Stock',      'Stock',     icmStandardFile);
    {$IFDEF SQLSurvey}
    // Normalised SQL Table
    edfStockLocation   : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'StockLocation', '',       icmStandardFile);
    {$ENDIF}
    // Misc\SVUsrDef.Dat
    edfSVUsrDef        : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'SVUsrDef',   'Misc',      icmStandardFile);
    {$IFDEF SQLSurvey}
    // Normalised SQL Table
    edfTransactionNote : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'TransactionNote', '',     icmStandardFile);
    {$ENDIF}
    // UDEntity.Dat
    edfUDEntity        : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'UDEntity',   '',          icmUserFieldsPlugIn);
    // UDField.Dat
    edfUDField         : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'UDField',    '',          icmUserFieldsPlugIn);
    // UDItem.Dat
    edfUDItem          : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'UDItem',     '',          icmUserFieldsPlugIn);
    // VatPer\VatOpt.Dat
    edfVatOpt          : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'VatOpt',     'VatPer',    icmVATPeriodPlugIn);
    // VatPer\VatPrd.Dat
    edfVatPrd          : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'VatPrd',     'VatPer',    icmVATPeriodPlugIn);
    // Reports\VRWSec.Dat
    edfVRWSec          : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'VRWSec',     'Reports',   icmVRW);
    // Reports\VRWTree.Dat
    edfVRWTree         : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'VRWTree',    'Reports',   icmVRW);
    // Misc\WinSet.Dat
    edfWinSet          : Result := TExchequerDataFileInfo.Create(FileType, False, False,  'WinSet',     'Misc',      icmStandardFile);
    // Reports/Reports.Dat
    edfWRWReports      : Result := TExchequerDataFileInfo.Create(FileType, False, True,   'Reports',    'Reports',   icmRepWrt);
  Else
    Raise Exception.Create('DataFileInfo.ExchequerDataFiles: Unknown FileType (' + IntToStr(Ord(FileType)) + ')');
  End; // Case FileType
End;

//=========================================================================

Constructor TExchequerDataFileInfo.Create (Const FileType : TExchequerDataFiles; Const Common, Optional : Boolean; Const Filename, SubDirectory : ShortString; Const InstallationCheckMode : TInstallationCheckMode);
Begin // Create
  Inherited Create;

  FFileType := FileType;
  FCommon := Common;
  FOptional := Optional;
  FFilename := Filename;
  FSubDirectory := SubDirectory;
  FInstallationCheckMode := InstallationCheckMode;
End; // Create

//-------------------------------------------------------------------------

Function TExchequerDataFileInfo.GetFileType : TExchequerDataFiles;
Begin // GetFileType
  Result := FFileType;
End; // GetFileType

//------------------------------

Function TExchequerDataFileInfo.GetCommon : Boolean;
Begin // GetCommon
  Result := FCommon;
End; // GetCommon

//------------------------------

Function TExchequerDataFileInfo.GetOptional : Boolean;
Begin // GetOptional
  Result := FOptional;
End; // GetOptional

//------------------------------

Function TExchequerDataFileInfo.GetFilename : ShortString;
Begin // GetFilename
  Result := FFilename;
End; // GetFilename

//------------------------------

Function TExchequerDataFileInfo.GetSubDirectory : ShortString;
Begin // GetSubDirectory
  Result := FSubDirectory;
End; // GetSubDirectory

//=========================================================================

End.