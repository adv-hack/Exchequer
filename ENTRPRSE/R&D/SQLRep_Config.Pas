Unit SQLRep_Config;
{
  Contains the TSQLReportsConfiguration class, and the matching function to
  access the singleton instance of this class, for retrieving the values to use
  for various report and process settings.

  If you add new entries to this class, please update the documention for it.
  This is currently to be found here:

    http://gateway/sites/group/Product_Dev/ABS/v7.0.14/Development/Forms/AllItems.aspx

  The document filename is "Exchequer v7.0.14 - SQL Config.docx"
}

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses SysUtils;

Type
  // MH 04/01/2018 2017-R1 ABSEXCH-19316: Added new SQL Posting Status
  TSQLPostingStatusEnum = (psPending=0, psPassed=1, psFailed=2);

  // Generic interface for objects which implement a specific import type
  ISQLReportsConfiguration = Interface
    ['{5C373F1E-1D61-4C00-B255-5E043097DD98}']
    // --- Internal Methods to implement Public Properties ---
    Function GetReportTimeoutInSeconds : LongInt;
    Function GetUseSQLConsolidatedAgedCreditors : Boolean;
    Function GetUseSQLConsolidatedAgedDebtors : Boolean;
    Function GetUseSQLSimplifiedTrialBalance : Boolean;
    Function GetUseSQLFullTrialBalance : Boolean;
    Function GetUseSQLGLPrePosting: Boolean;
    Function GetUseSQLSalesDaybookReport : Boolean;
    Function GetUseSQLPurchaseDaybookReport : Boolean;
    Function GetUseSQLGLHistoryReport : Boolean;
    // CJS 2012-03-19 - ABSEXCH-12203 - Check All Accounts, SQL improvements
    Function GetUseSQLCheckAllAccounts: Boolean;
    Function GetOLETimeoutInSeconds : LongInt;
    Function GetUseAgeingStoredProc : Boolean;
    // CJS 2013-06-18 - ABSEXCH-14012 - OLE performance mods
    Function GetUseOLESaveNominalBudgetSP : Boolean;

    // MH 19/06/2012 ABSEXCH-12965 v7.0: Added support for additional Daybook Reports
    Function GetUseSQLDocumentAnalysisReport : Boolean;
    Function GetUseSQLReceiptsReport : Boolean;
    Function GetUseSQLPaymentsReport : Boolean;
    Function GetUseSQLSalesOrderReport : Boolean;
    Function GetUseSQLPurchaseOrderReport : Boolean;
    Function GetUseSQLNominalReport : Boolean;

    // CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View
    function GetUseDefaultSortViews: Boolean;

    // CJS 2013-03-26 - ABSEXCH-14174 - Partial Unpost Optimisations
    Function GetUsePartialUnpostOptimisations: Boolean;

    // MH 28/03/2013 v7.0.3 ABSEXCH-13218: Added Update Category Level optimisation
    Function GetUseSQLUpdateCategoryLevels : Boolean;
    Function GetUpdateCategoryLevelsTimeoutInSeconds : Integer;

    // MH 05/08/2013 v7.0.5 ABSEXCH-13630: Added direct SQL query into Invoice Tagged Deliveries
    function GetUseSQLInvoiceTaggedDeliveries : Boolean;

    // MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added pre-load to OLE Server's Internal GL/CC/Dept Caching
    Function GetUseOLEPreloadCaching : Boolean;

    // MH 03/02/2014 v7.0.9 ABSEXCH-15005: Added SQL improvements into Check All Job Totals
    Function GetUseCheckAllJobTotals : Boolean;

    // CJS 2014-06-27 - ABSEXCH-15398 - OLE Performance - ENTGLJOBACTUAL
    Function GetUseOLESQLTransactionLines: Boolean;

    // CJS 2015-02-23 - ABSEXCH-15785 - SQL version of Update all Contracts
    Function GetUseSQLUpdateJobCategoriesAndContracts: Boolean;

    // CJS 2015-02-23 - ABSEXCH-16133 - SQL version of Check All Job Totals
    Function GetUseSQLCheckAllJobs: Boolean;

    // MH 23/04/2015 v7.0.14 ABSEXCH-15749: Copied ABSEXCH-15725 Update Build Costs from v7.0.11 Post
    Function GetUseSQLUpdateBuildCosts : Boolean;

    // CJS 2015-04-24 - ABSEXCH-16352 - Job Posting doubling committed balances
    Function GetDeleteCommitmentHistoryTimeoutInSeconds: Integer;

    // CJS 2016-03-24 - ABSEXCH-17381 - Check CC-Dept Balances - SQL improvements
    Function GetCheckCCDeptBalancesTimeoutInSeconds: Integer;

    // CJS 2016-04-12 - ABSEXCH-17382 - GL Budget roll up - SQL improvements
    Function GetUseSQLRollupGLBudgets: Boolean;
    Function GetRollupGLBudgetsTimeoutInSeconds: Integer;

    // CJS 2016-04-22 - ABSEXCH-17272 - Add Individual Job Budget Update
    Function GetRollupJobBudgetsTimeoutInSeconds: Integer;

    // CJS 2016-04-26 - ABSEXCH-16737 - re-order transactions after SQL migration
    Function GetReorderTransactionsTimeoutInSeconds: Integer;

    // CJS 2016-05-18 - ABSEXCH-16367 - SQL OLE EntCustNetSales DrillDown performance
    Function GetUseEntCustNetSalesOptimisation: Boolean;

    // PS/TG 02/02/2016 - ABSEXCH-17220 - Check All Stock Level, SQL improvements
    Function GetUseSQLCheckAllStockLevel: Boolean;
    Function GetCheckAllStockLevelTimeoutInSeconds: LongInt;

    {SS 24/02/2017 2017-R1:ABSEXCH-18399:SBT and PBT transctions should be excluded from single daybook posting.}
    Function GetLegacyDayBookPostingUsingSQL: Boolean;

    //SS 30/03/2017 2017-R1:ABSEXCH-18509:Daybook Posting Failing on Large Datasets.
    Function GetSQLDayBookPostingTimeoutInSeconds: LongInt;

    // MH 04/01/2018 2017-R1 ABSEXCH-19316: Added new SQL Posting Status
    Function GetSQLPostingStatus (Company : String) : TSQLPostingStatusEnum;
    Function GetSQLConfigExists : Boolean;

    // ------------------ Public Properties ------------------
    // 'Hidden' settings from SQLConfig.Ini in main Exchequer directory

    // for SQL Reports
    Property ReportTimeoutInSeconds : LongInt Read GetReportTimeoutInSeconds;
    Property UseSQLConsolidatedAgedCreditors : Boolean Read GetUseSQLConsolidatedAgedCreditors;
    Property UseSQLConsolidatedAgedDebtors : Boolean Read GetUseSQLConsolidatedAgedDebtors;
    Property UseSQLSimplifiedTrialBalance : Boolean Read GetUseSQLSimplifiedTrialBalance;
    Property UseSQLFullTrialBalance : Boolean Read GetUseSQLFullTrialBalance;
    Property UseSQLGLPrePosting: Boolean Read GetUseSQLGLPrePosting;
    Property UseSQLSalesDaybookReport : Boolean Read GetUseSQLSalesDaybookReport;
    Property UseSQLPurchaseDaybookReport : Boolean Read GetUseSQLPurchaseDaybookReport;
    Property UseSQLGLHistoryReport : Boolean Read GetUseSQLGLHistoryReport;
    // CJS 2012-03-19 - ABSEXCH-12203 - Check All Accounts, SQL improvements
    Property UseSQLCheckAllAccounts : Boolean Read GetUseSQLCheckAllAccounts;

    // MH 19/06/2012 ABSEXCH-12965 v7.0: Added support for additional Daybook Reports
    Property UseSQLDocumentAnalysisReport : Boolean Read GetUseSQLDocumentAnalysisReport;
    Property UseSQLReceiptsReport : Boolean Read GetUseSQLReceiptsReport;
    Property UseSQLPaymentsReport : Boolean Read GetUseSQLPaymentsReport;
    Property UseSQLSalesOrderReport : Boolean Read GetUseSQLSalesOrderReport;
    Property UseSQLPurchaseOrderReport : Boolean Read GetUseSQLPurchaseOrderReport;
    Property UseSQLNominalReport : Boolean Read GetUseSQLNominalReport;

    // for OLE Server
    Property OLETimeoutInSeconds : LongInt Read GetOLETimeoutInSeconds;
    Property UseAgeingStoredProc : Boolean Read GetUseAgeingStoredProc;
    // CJS 2013-06-18 - ABSEXCH-14012 - OLE performance mods
    Property UseOLESaveNominalBudgetSP : Boolean Read GetUseOLESaveNominalBudgetSP;

    // CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View
    property UseDefaultSortViews: Boolean read GetUseDefaultSortViews;

    // CJS 2013-03-26 - ABSEXCH-14174 - Partial Unpost Optimisations
    property UsePartialUnpostOptimisations: Boolean read GetUsePartialUnpostOptimisations;

    // MH 28/03/2013 v7.0.3 ABSEXCH-13218: Added Update Category Level optimisation
    property UseSQLUpdateCategoryLevels : Boolean read GetUseSQLUpdateCategoryLevels;
    property UpdateCategoryLevelsTimeoutInSeconds : LongInt Read GetUpdateCategoryLevelsTimeoutInSeconds;

    // MH 05/08/2013 v7.0.5 ABSEXCH-13630: Added direct SQL query into Invoice Tagged Deliveries
    Property UseSQLInvoiceTaggedDeliveries : Boolean Read GetUseSQLInvoiceTaggedDeliveries;

    // MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added pre-load to OLE Server's Internal GL/CC/Dept Caching
    Property UseOLEPreloadCaching : Boolean Read GetUseOLEPreloadCaching;

    // MH 03/02/2014 v7.0.9 ABSEXCH-15005: Added SQL improvements into Check All Job Totals
    Property UseCheckAllJobTotals : Boolean Read GetUseCheckAllJobTotals;

    // CJS 2014-06-27 - ABSEXCH-15398 - OLE Performance - ENTGLJOBACTUAL
    Property UseOLESQLTransactionLines: Boolean Read GetUseOLESQLTransactionLines;

    // CJS 2015-02-23 - ABSEXCH-15785 - SQL version of Update all Contracts
    Property UseSQLUpdateJobCategoriesAndContracts: Boolean Read GetUseSQLUpdateJobCategoriesAndContracts;

    // CJS 2015-02-23 - ABSEXCH-16133 - SQL version of Check All Job Totals
    Property UseSQLCheckAllJobs: Boolean read GetUseSQLCheckAllJobs;

    // MH 23/04/2015 v7.0.14 ABSEXCH-15749: Copied ABSEXCH-15725 Update Build Costs from v7.0.11 Post
    Property UseSQLUpdateBuildCosts : Boolean Read GetUseSQLUpdateBuildCosts;

    // CJS 2015-04-24 - ABSEXCH-16352 - Job Posting doubling committed balances
    Property DeleteCommitmentHistoryTimeoutInSeconds: Integer read GetDeleteCommitmentHistoryTimeoutInSeconds;

    // CJS 2016-03-24 - ABSEXCH-17381 - Check CC-Dept Balances - SQL improvements
    Property CheckCCDeptBalancesTimeoutInSeconds: Integer read GetCheckCCDeptBalancesTimeoutInSeconds;

    // CJS 2016-04-12 - ABSEXCH-17382 - GL Budget roll up - SQL improvements
    Property UseSQLRollupGLBudgets: Boolean Read GetUseSQLRollupGLBudgets;
    Property RollupGLBudgetsTimeoutInSeconds: Integer Read GetRollupGLBudgetsTimeoutInSeconds;

    // CJS 2016-04-22 - ABSEXCH-17272 - Add Individual Job Budget Update
    Property RollupJobBudgetsTimeoutInSeconds: Integer read GetRollupJobBudgetsTimeoutInSeconds;

    // CJS 2016-04-26 - ABSEXCH-16737 - re-order transactions after SQL migration
    Property ReorderTransactionsTimeoutInSeconds: Integer read GetReorderTransactionsTimeoutInSeconds;

    // CJS 2016-05-18 - ABSEXCH-16367 - SQL OLE EntCustNetSales DrillDown performance
    Property UseEntCustNetSalesOptimisation: Boolean read GetUseEntCustNetSalesOptimisation;

    // PS/TG 02/02/2016 - ABSEXCH-17220 - Check All Stock Level, SQL improvements
    Property UseSQLCheckAllStockLevel: Boolean Read GetUseSQLCheckAllStockLevel;
    Property CheckAllStockLevelTimeoutInSeconds: LongInt Read GetCheckAllStockLevelTimeoutInSeconds;

    {SS 24/02/2017 2017-R1:ABSEXCH-18399:SBT and PBT transctions should be excluded from single daybook posting.}
    Property LegacyDayBookPostingUsingSQL: Boolean Read GetLegacyDayBookPostingUsingSQL;

    //SS 30/03/2017 2017-R1:ABSEXCH-18509:Daybook Posting Failing on Large Datasets.
    Property SQLDayBookPostingTimeoutInSeconds: LongInt Read GetSQLDayBookPostingTimeoutInSeconds;

    // MH 04/01/2018 2017-R1 ABSEXCH-19316: Added new SQL Posting Status
    Property SQLPostingStatus [Company : String] : TSQLPostingStatusEnum Read GetSQLPostingStatus;
    Property SQLConfigExists : Boolean Read GetSQLConfigExists;

    // ------------------- Public Methods --------------------

    // MH 04/01/2018 2017-R1 ABSEXCH-19316: Added new SQL Posting Status
    Procedure SetSQLPostingStatus(Const Company : String; Const NewStatus : TSQLPostingStatusEnum);
    // Returns TRUE if the specified setting exists
    Function SettingExists(Const Section, IDent : String) : Boolean;
    // Deletes the specified key
    Procedure DeleteKey(Const Section, Ident : String);
  End; // ISQLReportsConfiguration

// MH 08/01/2018 2017-R1 ABSEXCH-19316: Setup needs to change the path
Function SQLReportsConfiguration (Const OverridePath : String = '') : ISQLReportsConfiguration;

Implementation

Uses Forms, IniFiles, SHA3HashUtil;

Type
  TSQLReportsConfiguration = Class(TInterfacedObject, ISQLReportsConfiguration)
  Private
    // MH 08/01/2018 2017-R1 ABSEXCH-19316: Setup needs to change the path
    FIniPath : String;

    FReportTimeoutInSeconds : LongInt;
    FUseSQLConsolidatedAgedCreditors : Boolean;
    FUseSQLConsolidatedAgedDebtors : Boolean;
    FUseSQLSimplifiedTrialBalance : Boolean;
    FUseSQLFullTrialBalance : Boolean;
    FUseSQLGLPrePosting: Boolean;
    FUseSQLSalesDaybookReport : Boolean;
    FUseSQLPurchaseDaybookReport : Boolean;
    FUseSQLGLHistoryReport: Boolean;
    // CJS 2012-03-19 - ABSEXCH-12203 - Check All Accounts, SQL improvements
    FUseSQLCheckAllAccounts: Boolean;
    FOLETimeoutInSeconds : LongInt;
    FUseAgeingStoredProc : Boolean;
    // CJS 2013-06-18 - ABSEXCH-14012 - OLE performance mods
    FUseOLESaveNominalBudgetSP: Boolean;

    // MH 19/06/2012 ABSEXCH-12965 v7.0: Added support for additional Daybook Reports
    FUseSQLDocumentAnalysisReport : Boolean;
    FUseSQLReceiptsReport : Boolean;
    FUseSQLPaymentsReport : Boolean;
    FUseSQLSalesOrderReport : Boolean;
    FUseSQLPurchaseOrderReport : Boolean;
    FUseSQLNominalReport : Boolean;

    // CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View
    FUseDefaultSortViews: Boolean;

    // CJS 2013-03-26 - ABSEXCH-14174 - Partial Unpost Optimisations
    FUsePartialUnpostOptimisations: Boolean;

    // MH 28/03/2013 v7.0.3 ABSEXCH-13218: Added Update Category Level optimisation
    FUseSQLUpdateCategoryLevels : Boolean;
    FUpdateCategoryLevelsTimeoutInSeconds : Integer;

    // MH 05/08/2013 v7.0.5 ABSEXCH-13630: Added direct SQL query into Invoice Tagged Deliveries
    FUseSQLInvoiceTaggedDeliveries : Boolean;

    // MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added pre-load to OLE Server's Internal GL/CC/Dept Caching
    FUseOLEPreloadCaching : Boolean;

    // MH 03/02/2014 v7.0.9 ABSEXCH-15005: Added SQL improvements into Check All Job Totals
    FUseCheckAllJobTotals : Boolean;

    // CJS 2014-06-27 - ABSEXCH-15398 - OLE Performance - ENTGLJOBACTUAL
    FUseOLESQLTransactionLines: Boolean;

    // CJS 2015-02-23 - ABSEXCH-15785 - SQL version of Update all Contracts
    FUseSQLUpdateJobCategoriesAndContracts: Boolean;

    // CJS 2015-02-23 - ABSEXCH-16133 - SQL version of Check All Job Totals
    FUseSQLCheckAllJobs: Boolean;

    // MH 23/04/2015 v7.0.14 ABSEXCH-15749: Copied ABSEXCH-15725 Update Build Costs from v7.0.11 Post
    FUseSQLUpdateBuildCosts : Boolean;

    // CJS 2015-04-24 - ABSEXCH-16352 - Job Posting doubling committed balances
    FDeleteCommitmentHistoryTimeoutInSeconds: Integer;

    // CJS 2016-03-24 - ABSEXCH-17381 - Check CC-Dept Balances - SQL improvements
    FCheckCCDeptBalancesTimeoutInSeconds: Integer;

    // CJS 2016-04-12 - ABSEXCH-17382 - GL Budget roll up - SQL improvements
    FUseSQLRollupGLBudgets: Boolean;
    FRollupGLBudgetsTimeoutInSeconds: Integer;

    // CJS 2016-04-22 - ABSEXCH-17272 - Add Individual Job Budget Update
    FRollupJobBudgetsTimeoutInSeconds: Integer;

    // CJS 2016-04-26 - ABSEXCH-16737 - re-order transactions after SQL migration
    FReorderTransactionsTimeoutInSeconds: Integer;

    // CJS 2016-05-18 - ABSEXCH-16367 - SQL OLE EntCustNetSales DrillDown performance
    FUseEntCustNetSalesOptimisation: Boolean;

    // PS/TG 02/02/2016 - ABSEXCH-17220 - Check All Stock Level, SQL improvements
    FUseSQLCheckAllStockLevel: Boolean;
    FCheckAllStockLevelTimeoutInSeconds: LongInt;
    
    {SS 24/02/2017 2017-R1:ABSEXCH-18399:SBT and PBT transctions should be excluded from single daybook posting.}
    FLegacyDayBookPostingUsingSQL : Boolean;

    //SS 30/03/2017 2017-R1:ABSEXCH-18509:Daybook Posting Failing on Large Datasets.
    FSQLDayBookPostingTimeoutInSeconds: LongInt;

    Procedure LoadSettings;
  Protected
    // ISQLReportsConfiguration
    Function GetReportTimeoutInSeconds : LongInt;
    Function GetUseSQLConsolidatedAgedCreditors : Boolean;
    Function GetUseSQLConsolidatedAgedDebtors : Boolean;
    Function GetUseSQLSimplifiedTrialBalance : Boolean;
    Function GetUseSQLFullTrialBalance : Boolean;
    Function GetUseSQLGLPrePosting: Boolean;
    Function GetUseSQLSalesDaybookReport : Boolean;
    Function GetUseSQLPurchaseDaybookReport : Boolean;
    Function GetUseSQLGLHistoryReport : Boolean;
    // CJS 2012-03-19 - ABSEXCH-12203 - Check All Accounts, SQL improvements
    Function GetUseSQLCheckAllAccounts: Boolean;
    Function GetOLETimeoutInSeconds : LongInt;
    Function GetUseAgeingStoredProc : Boolean;
    // CJS 2013-06-18 - ABSEXCH-14012 - OLE performance mods
    Function GetUseOLESaveNominalBudgetSP : Boolean;

    // MH 19/06/2012 ABSEXCH-12965 v7.0: Added support for additional Daybook Reports
    Function GetUseSQLDocumentAnalysisReport : Boolean;
    Function GetUseSQLReceiptsReport : Boolean;
    Function GetUseSQLPaymentsReport : Boolean;
    Function GetUseSQLSalesOrderReport : Boolean;
    Function GetUseSQLPurchaseOrderReport : Boolean;
    Function GetUseSQLNominalReport : Boolean;
    // CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View
    function GetUseDefaultSortViews: Boolean;
    // CJS 2013-03-26 - ABSEXCH-14174 - Partial Unpost Optimisations
    function GetUsePartialUnpostOptimisations: Boolean;
    
    {SS 24/02/2017 2017-R1:ABSEXCH-18399:SBT and PBT transctions should be excluded from single daybook posting.}
    function GetLegacyDayBookPostingUsingSQL: Boolean;

    // MH 28/03/2013 v7.0.3 ABSEXCH-13218: Added Update Category Level optimisation
    Function GetUseSQLUpdateCategoryLevels : Boolean;
    Function GetUpdateCategoryLevelsTimeoutInSeconds : Integer;

    // MH 05/08/2013 v7.0.5 ABSEXCH-13630: Added direct SQL query into Invoice Tagged Deliveries
    function GetUseSQLInvoiceTaggedDeliveries : Boolean;

    // MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added pre-load to OLE Server's Internal GL/CC/Dept Caching
    Function GetUseOLEPreloadCaching : Boolean;

    // MH 03/02/2014 v7.0.9 ABSEXCH-15005: Added SQL improvements into Check All Job Totals
    Function GetUseCheckAllJobTotals : Boolean;

    // CJS 2014-06-27 - ABSEXCH-15398 - OLE Performance - ENTGLJOBACTUAL
    Function GetUseOLESQLTransactionLines: Boolean;

    // CJS 2015-02-23 - ABSEXCH-15785 - SQL version of Update all Contracts
    Function GetUseSQLUpdateJobCategoriesAndContracts: Boolean;

    // CJS 2015-02-23 - ABSEXCH-16133 - SQL version of Check All Job Totals
    Function GetUseSQLCheckAllJobs: Boolean;

    // MH 23/04/2015 v7.0.14 ABSEXCH-15749: Copied ABSEXCH-15725 Update Build Costs from v7.0.11 Post
    Function GetUseSQLUpdateBuildCosts : Boolean;

    // CJS 2015-04-24 - ABSEXCH-16352 - Job Posting doubling committed balances
    Function GetDeleteCommitmentHistoryTimeoutInSeconds: Integer;

    // CJS 2016-03-24 - ABSEXCH-17381 - Check CC-Dept Balances - SQL improvements
    Function GetCheckCCDeptBalancesTimeoutInSeconds: Integer;

    // CJS 2016-04-12 - ABSEXCH-17382 - GL Budget roll up - SQL improvements
    Function GetUseSQLRollupGLBudgets: Boolean;
    Function GetRollupGLBudgetsTimeoutInSeconds: Integer;

    // CJS 2016-04-22 - ABSEXCH-17272 - Add Individual Job Budget Update
    Function GetRollupJobBudgetsTimeoutInSeconds: Integer;

    // CJS 2016-04-26 - ABSEXCH-16737 - re-order transactions after SQL migration
    Function GetReorderTransactionsTimeoutInSeconds: Integer;

    // CJS 2016-05-18 - ABSEXCH-16367 - SQL OLE EntCustNetSales DrillDown performance
    Function GetUseEntCustNetSalesOptimisation: Boolean;

    // PS/TG 02/02/2016 - ABSEXCH-17220 - Check All Stock Level, SQL improvements
    Function GetUseSQLCheckAllStockLevel: Boolean;
    Function GetCheckAllStockLevelTimeoutInSeconds: LongInt;

    //SS 30/03/2017 2017-R1:ABSEXCH-18509:Daybook Posting Failing on Large Datasets.
    Function GetSQLDayBookPostingTimeoutInSeconds: LongInt;

    // MH 04/01/2018 2017-R1 ABSEXCH-19316: Added new SQL Posting Status
    Function GetSQLPostingStatus (Company : String) : TSQLPostingStatusEnum;

    // MH 04/01/2018 2017-R1 ABSEXCH-19316: Added new SQL Posting Status
    Procedure SetSQLPostingStatus(Const Company : String; Const NewStatus : TSQLPostingStatusEnum);
    Function GetSQLConfigExists : Boolean;
    // Returns TRUE if the specified setting exists
    Function SettingExists(Const Section, Ident : String) : Boolean;
    // Deletes the specified key
    Procedure DeleteKey(Const Section, Ident : String);
  Public
    Constructor Create (Const IniPath : String);
  End; // TSQLReportsConfiguration

Var
  iTSQLReportsConfiguration : ISQLReportsConfiguration;
  oSQLReportsConfiguration : TSQLReportsConfiguration;

//=========================================================================

// MH 08/01/2018 2017-R1 ABSEXCH-19316: Setup needs to change the path
Function SQLReportsConfiguration (Const OverridePath : String = '') : ISQLReportsConfiguration;
Var
  sIniPath : String;
Begin // SQLReportsConfiguration
  If (Not Assigned (iTSQLReportsConfiguration)) Then
  Begin
    If (OverridePath <> '') Then
      sIniPath := IncludeTrailingPathDelimiter(OverridePath) + 'SQLConfig.Ini'
    Else
      sIniPath := ExtractFilePath(Application.ExeName) + 'SQLConfig.Ini';

    oSQLReportsConfiguration := TSQLReportsConfiguration.Create(sIniPath);
    iTSQLReportsConfiguration := oSQLReportsConfiguration;
  End; // If (Not Assigned (iTSQLReportsConfiguration))

  // return the reference to the singleton interface stored in the private local variable
  Result := iTSQLReportsConfiguration;
End; // SQLReportsConfiguration

//=========================================================================

Constructor TSQLReportsConfiguration.Create (Const IniPath : String);
Begin // Create
  Inherited Create;

  // MH 08/01/2018 2017-R1 ABSEXCH-19316: Setup needs to change the path
  FIniPath := IniPath;

  FReportTimeoutInSeconds := 900;
  FUseSQLConsolidatedAgedCreditors := True;
  FUseSQLConsolidatedAgedDebtors := True;
  FUseSQLSimplifiedTrialBalance := True;
  FUseSQLFullTrialBalance := True;
  FUseSQLGLPrePosting := True;
  FUseSQLSalesDaybookReport := True;
  FUseSQLPurchaseDaybookReport := True;
  FUseSQLGLHistoryReport := True;
  // CJS 2012-03-19 - ABSEXCH-12203 - Check All Accounts, SQL improvements
  FUseSQLCheckAllAccounts := True;
  FOLETimeoutInSeconds := 30;
  FUseAgeingStoredProc := True;

  // CJS 2013-06-21 - ABSEXCH-14012 - OLE performance mods
  FUseOLESaveNominalBudgetSP := True;

  // MH 19/06/2012 ABSEXCH-12965 v7.0: Added support for additional Daybook Reports
  FUseSQLDocumentAnalysisReport := True;
  FUseSQLReceiptsReport := True;
  FUseSQLPaymentsReport := True;
  FUseSQLSalesOrderReport := True;
  FUseSQLPurchaseOrderReport := True;
  FUseSQLNominalReport := True;

  { CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View }
  FUseDefaultSortViews := True;

  // CJS 2013-03-26 - ABSEXCH-14174 - Partial Unpost Optimisations
  FUsePartialUnpostOptimisations := True;

  // MH 28/03/2013 v7.0.3 ABSEXCH-13218: Added Update Category Level optimisation
  FUseSQLUpdateCategoryLevels := True;
  FUpdateCategoryLevelsTimeoutInSeconds := (60 * 15);  // Default 15 mins

  // MH 05/08/2013 v7.0.5 ABSEXCH-13630: Added direct SQL query into Invoice Tagged Deliveries
  FUseSQLInvoiceTaggedDeliveries := True;

  // MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added pre-load to OLE Server's Internal GL/CC/Dept Caching
  FUseOLEPreloadCaching := True;

  // MH 03/02/2014 v7.0.9 ABSEXCH-15005: Added SQL improvements into Check All Job Totals
  FUseCheckAllJobTotals := True;

  // CJS 2014-06-27 - ABSEXCH-15398 - OLE Performance - ENTGLJOBACTUAL
  FUseOLESQLTransactionLines := True;

  // CJS 2015-02-23 - ABSEXCH-15785 - SQL version of Update all Contracts
  FUseSQLUpdateJobCategoriesAndContracts := True;

  // CJS 2015-02-23 - ABSEXCH-16133 - SQL version of Check All Job Totals
  FUseSQLCheckAllJobs := True;

  // MH 23/04/2015 v7.0.14 ABSEXCH-15749: Copied ABSEXCH-15725 Update Build Costs from v7.0.11 Post
  FUseSQLUpdateBuildCosts := True;

  // CJS 2015-04-24 - ABSEXCH-16352 - Job Posting doubling committed balances
  //PR 27/06/2017 ABSEXCH-18860 Increased default to 1 hour at request of JW/GK
  FDeleteCommitmentHistoryTimeoutInSeconds := 3600;

  // CJS 2016-03-24 - ABSEXCH-17381 - Check CC-Dept Balances - SQL improvements
  FCheckCCDeptBalancesTimeoutInSeconds := 3600;

  // CJS 2016-04-12 - ABSEXCH-17382 - GL Budget roll up - SQL improvements
  FUseSQLRollupGLBudgets := True;
  FRollupGLBudgetsTimeoutInSeconds := 3600;

  // CJS 2016-04-22 - ABSEXCH-17272 - Add Individual Job Budget Update
  FRollupJobBudgetsTimeoutInSeconds := 3600;

  // CJS 2016-04-26 - ABSEXCH-16737 - re-order transactions after SQL migration
  FReorderTransactionsTimeoutInSeconds := 0;

  // CJS 2016-05-18 - ABSEXCH-16367 - SQL OLE EntCustNetSales DrillDown performance
  FUseEntCustNetSalesOptimisation := True;

  // PS/TG 02/02/2016 - ABSEXCH-17220 - Check All Stock Level, SQL improvements
  FUseSQLCheckAllStockLevel := True;
  FCheckAllStockLevelTimeoutInSeconds := 3600;
  
  {SS 24/02/2017 2017-R1:ABSEXCH-18399:SBT and PBT transctions should be excluded from single daybook posting.}
  FLegacyDayBookPostingUsingSQL := True;

  //SS 30/03/2017 2017-R1:ABSEXCH-18509:Daybook Posting Failing on Large Datasets.
  //PR 27/06/2017 ABSEXCH-18898 Increased default to 8 hrs at request of JW/GK
  FSQLDayBookPostingTimeoutInSeconds := 3600 * 8;

  LoadSettings;
End; // Create

//------------------------------

Procedure TSQLReportsConfiguration.LoadSettings;
Var
  oIniFile : TIniFile;
Begin // LoadSettings
  If FileExists(FIniPath) Then
  Begin
    oIniFile := TIniFile.Create(FIniPath);
    Try
      FReportTimeoutInSeconds := oIniFile.ReadInteger('Reports', 'ReportTimeoutSecs', 900);
      FUseSQLConsolidatedAgedCreditors := oIniFile.ReadBool('Reports', 'ConsolidatedAgedCreditors', True);
      FUseSQLConsolidatedAgedDebtors := oIniFile.ReadBool('Reports', 'ConsolidatedAgedDebtors', True);
      FUseSQLSimplifiedTrialBalance := oIniFile.ReadBool('Reports', 'SimplifiedTB', True);
      FUseSQLFullTrialBalance := oIniFile.ReadBool('Reports', 'FullTB', True);
      FUseSQLGLPrePosting := oIniFile.ReadBool('Reports', 'GLPrePosting', True);
      FUseSQLSalesDaybookReport := oIniFile.ReadBool('Reports', 'SalesDaybook', True);
      FUseSQLPurchaseDaybookReport := oIniFile.ReadBool('Reports', 'PurchaseDaybook', True);
      FUseSQLGLHistoryReport := oIniFile.ReadBool('Reports', 'GLHistory', True);
      // CJS 2012-03-19 - ABSEXCH-12203 - Check All Accounts, SQL improvements
      FUseSQLCheckAllAccounts := oIniFile.ReadBool('Processes', 'CheckAllAccounts', True);
      FOLETimeoutInSeconds := oIniFile.ReadInteger('OLE', 'OLETimeoutSecs', 30);
      FUseAgeingStoredProc := oIniFile.ReadBool('OLE', 'UseAccountAgeingSP', True);
      // CJS 2013-06-18 - ABSEXCH-14012 - OLE performance mods
      FUseOLESaveNominalBudgetSP := oIniFile.ReadBool('OLE', 'UseOLESaveNominalBudgetSP', True);

      // MH 19/06/2012 ABSEXCH-12965 v7.0: Added support for additional Daybook Reports
      FUseSQLDocumentAnalysisReport := oIniFile.ReadBool('Reports', 'DocumentAnalysis', True);
      FUseSQLReceiptsReport := oIniFile.ReadBool('Reports', 'ReceiptsDaybook', True);
      FUseSQLPaymentsReport := oIniFile.ReadBool('Reports', 'PaymentsDaybook', True);
      FUseSQLSalesOrderReport := oIniFile.ReadBool('Reports', 'SalesOrderDaybook', True);
      FUseSQLPurchaseOrderReport := oIniFile.ReadBool('Reports', 'PurchaseOrderDaybook', True);
      FUseSQLNominalReport := oIniFile.ReadBool('Reports', 'NominalDaybook', True);

      // CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View
      FUseDefaultSortViews := oIniFile.ReadBool('SortViews', 'UseDefaultSortViews', True);

      // CJS 2013-03-26 - ABSEXCH-14174 - Partial Unpost Optimisations
      FUsePartialUnpostOptimisations := oIniFile.ReadBool('Posting', 'UsePartialUnpostOptimisations', True);

      {SS 24/02/2017 2017-R1:ABSEXCH-18399:SBT and PBT transctions should be excluded from single daybook posting.}
      FLegacyDayBookPostingUsingSQL := oIniFile.ReadBool('Posting', 'DayBookPostingUsingSQL', True);
      //SS 30/03/2017 2017-R1:ABSEXCH-18509:Daybook Posting Failing on Large Datasets.
      //PR 27/06/2017 ABSEXCH-18898 Increased default to 8 hrs at request of JW/GK
      FSQLDayBookPostingTimeoutInSeconds := oIniFile.ReadInteger ('Posting', 'SQLDayBookPostingTimeoutInSeconds', 3600 * 8);

      // MH 28/03/2013 v7.0.3 ABSEXCH-13218: Added Update Category Level optimisation
      FUseSQLUpdateCategoryLevels := oIniFile.ReadBool('JobCosting', 'UpdateCategoryLevels', True);
      FUpdateCategoryLevelsTimeoutInSeconds := oIniFile.ReadInteger('JobCosting', 'UpdateCategoryLevelsTimeoutSecs', 60 * 15);

      // MH 05/08/2013 v7.0.5 ABSEXCH-13630: Added direct SQL query into Invoice Tagged Deliveries
      FUseSQLInvoiceTaggedDeliveries := oIniFile.ReadBool('Processes', 'UseInvoiceTaggedDeliveries', True);

      // MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added pre-load to OLE Server's Internal GL/CC/Dept Caching
      FUseOLEPreloadCaching := oIniFile.ReadBool('OLE', 'UseOLEPreloadCaching', True);

      // MH 03/02/2014 v7.0.9 ABSEXCH-15005: Added SQL improvements into Check All Job Totals
      FUseCheckAllJobTotals := oIniFile.ReadBool('JobCosting', 'UseCheckAllJobTotals', True);

      // CJS 2014-06-27 - ABSEXCH-15398 - OLE Performance - ENTGLJOBACTUAL
      FUseOLESQLTransactionLines := oIniFile.ReadBool('OLE', 'UseOLESQLTransactionLines', True);

      // CJS 2015-02-23 - ABSEXCH-15785 - SQL version of Update all Contracts
      FUseSQLUpdateJobCategoriesAndContracts := oIniFile.ReadBool('JobCosting', 'UseSQLUpdateJobCategoriesAndContracts', True);

      // CJS 2015-02-23 - ABSEXCH-16133 - SQL version of Check All Job Totals
      FUseSQLCheckAllJobs := oIniFile.ReadBool('JobCosting', 'UseSQLCheckAllJobs', True);

      // MH 23/04/2015 v7.0.14 ABSEXCH-15749: Copied ABSEXCH-15725 Update Build Costs from v7.0.11 Post
      FUseSQLUpdateBuildCosts := oIniFile.ReadBool('Processes', 'UseSQLUpdateBuildCosts', True);

      // CJS 2015-04-24 - ABSEXCH-16352 - Job Posting doubling committed balances
      //PR 27/06/2017 ABSEXCH-18860 Increased default to 1 hour at request of JW/GK
      FDeleteCommitmentHistoryTimeoutInSeconds := oIniFile.ReadInteger('Posting', 'DeleteCommitmentHistoryTimeoutInSeconds', 3600);

      // CJS 2016-03-24 - ABSEXCH-17381 - Check CC-Dept Balances - SQL improvements
      FCheckCCDeptBalancesTimeoutInSeconds := oIniFile.ReadInteger('DataRebuild', 'CheckCCDeptBalancesTimeoutInSeconds', 3600);

      // CJS 2016-04-12 - ABSEXCH-17382 - GL Budget roll up - SQL improvements
      FUseSQLRollupGLBudgets := oIniFile.ReadBool('Processes', 'UseSQLRollupGLBudgets', True);
      FRollupGLBudgetsTimeoutInSeconds := oIniFile.ReadInteger('Processes', 'RollupGLBudgetsTimeoutInSeconds', 3600);

      // CJS 2016-04-22 - ABSEXCH-17272 - Add Individual Job Budget Update
      FRollupJobBudgetsTimeoutInSeconds := oIniFile.ReadInteger('Processes', 'RollupJobBudgetsTimeoutInSeconds', 3600);

      // CJS 2016-04-26 - ABSEXCH-16737 - re-order transactions after SQL migration
      FReorderTransactionsTimeoutInSeconds := oIniFile.ReadInteger('Processes', 'ReorderTransactionsTimeoutInSeconds', 0);

      // CJS 2016-05-18 - ABSEXCH-16367 - SQL OLE EntCustNetSales DrillDown performance
      FUseEntCustNetSalesOptimisation := oIniFile.ReadBool('OLE', 'UseEntCustNetSalesOptimisation', True);

      // PS/TG 02/02/2016 - ABSEXCH-17220 - Check All Stock Level, SQL improvements
      FUseSQLCheckAllStockLevel := oIniFile.ReadBool('Processes', 'CheckAllStockLevel', True);
      FCheckAllStockLevelTimeoutInSeconds := oIniFile.ReadInteger ('Processes', 'CheckAllStockLevelTimeoutSecs', 3600);
    Finally
      oIniFile.Free;
    End; // Try..Finally
  End; // If FileExists(FIniPath)
End; // LoadSettings

//-------------------------------------------------------------------------

// MH 04/01/2018 2017-R1 ABSEXCH-19316: Added new SQL Posting Status
Function TSQLReportsConfiguration.GetSQLConfigExists : Boolean;
Begin // GetSQLConfigExists
  Result := FileExists(FIniPath);
End; // GetSQLConfigExists

//-----------------------------------

Function TSQLReportsConfiguration.GetReportTimeoutInSeconds : LongInt;
Begin // GetReportTimeoutInSeconds
  Result := FReportTimeoutInSeconds;
End; // GetReportTimeoutInSeconds

//------------------------------

Function TSQLReportsConfiguration.GetUseSQLConsolidatedAgedCreditors : Boolean;
Begin // GetUseSQLConsolidatedAgedCreditors
  Result := FUseSQLConsolidatedAgedCreditors;
End; // GetUseSQLConsolidatedAgedCreditors

//------------------------------

Function TSQLReportsConfiguration.GetUseSQLConsolidatedAgedDebtors : Boolean;
Begin // GetUseSQLConsolidatedAgedDebtors
  Result := FUseSQLConsolidatedAgedDebtors;
End; // GetUseSQLConsolidatedAgedDebtors

//------------------------------

Function TSQLReportsConfiguration.GetUseSQLSimplifiedTrialBalance : Boolean;
Begin // GetUseSQLSimplifiedTrialBalance
  Result := FUseSQLSimplifiedTrialBalance;
End; // GetUseSQLSimplifiedTrialBalance

//------------------------------

Function TSQLReportsConfiguration.GetUseSQLFullTrialBalance : Boolean;
Begin // GetUseSQLFullTrialBalance
  Result := FUseSQLFullTrialBalance;
End; // GetUseSQLFullTrialBalance

//------------------------------

function TSQLReportsConfiguration.GetUseSQLGLPrePosting: Boolean;
begin
  Result := FUseSQLGLPrePosting;
end;

//------------------------------

Function TSQLReportsConfiguration.GetUseSQLSalesDaybookReport : Boolean;
Begin // GetUseSQLSalesDaybookReport
  Result := FUseSQLSalesDaybookReport;
End; // GetUseSQLSalesDaybookReport

Function TSQLReportsConfiguration.GetUseSQLPurchaseDaybookReport : Boolean;
Begin // GetUseSQLPurchaseDaybookReport
  Result := FUseSQLPurchaseDaybookReport;
End; // GetUseSQLPurchaseDaybookReport

//------------------------------

// MH 19/06/2012 ABSEXCH-12965 v7.0: Added support for additional Daybook Reports
Function TSQLReportsConfiguration.GetUseSQLDocumentAnalysisReport : Boolean;
Begin // UseSQLDocumentAnalysisReport
  Result := FUseSQLDocumentAnalysisReport;
End; // UseSQLDocumentAnalysisReport

Function TSQLReportsConfiguration.GetUseSQLReceiptsReport : Boolean;
Begin // UseSQLReceiptsReport
  Result := FUseSQLReceiptsReport;
End; // UseSQLReceiptsReport

Function TSQLReportsConfiguration.GetUseSQLPaymentsReport : Boolean;
Begin // UseSQLPaymentsReport
  Result := FUseSQLPaymentsReport;
End; // UseSQLPaymentsReport

Function TSQLReportsConfiguration.GetUseSQLSalesOrderReport : Boolean;
Begin // UseSQLSalesOrderReport
  Result := FUseSQLSalesOrderReport;
End; // UseSQLSalesOrderReport

Function TSQLReportsConfiguration.GetUseSQLPurchaseOrderReport : Boolean;
Begin // UseSQLPurchaseOrderReport
  Result := FUseSQLPurchaseOrderReport;
End; // UseSQLPurchaseOrderReport

Function TSQLReportsConfiguration.GetUseSQLNominalReport : Boolean;
Begin // UseSQLNominalReport
  Result := FUseSQLNominalReport;
End; // UseSQLNominalReport

//-------------------------------------------------------------------------

Function TSQLReportsConfiguration.GetOLETimeoutInSeconds : LongInt;
Begin // GetOLETimeoutInSeconds
  Result := FOLETimeoutInSeconds;
End; // GetOLETimeoutInSeconds

//------------------------------

Function TSQLReportsConfiguration.GetUseAgeingStoredProc : Boolean;
Begin // GetUseAgeingStoredProc
  Result := FUseAgeingStoredProc;
End; // GetUseAgeingStoredProc

//-------------------------------------------------------------------------

function TSQLReportsConfiguration.GetUseOLESaveNominalBudgetSP: Boolean;
begin
  Result := FUseOLESaveNominalBudgetSP;
end;

//-------------------------------------------------------------------------

function TSQLReportsConfiguration.GetUseSQLGLHistoryReport: Boolean;
begin// GetUseSQLGLHistoryReport
  Result := FUseSQLGLHistoryReport;
end;// GetUseSQLGLHistoryReport

//-------------------------------------------------------------------------

// CJS 2012-03-19 - ABSEXCH-12203 - Check All Accounts, SQL improvements
function TSQLReportsConfiguration.GetUseSQLCheckAllAccounts: Boolean;
begin// GetUseSQLCheckAllAccounts
  Result := FUseSQLCheckAllAccounts;
end;// GetUseSQLCheckAllAccounts

//-------------------------------------------------------------------------

// CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View
function TSQLReportsConfiguration.GetUseDefaultSortViews: Boolean;
begin
  Result := FUseDefaultSortViews;
end;

//-------------------------------------------------------------------------

// CJS 2013-03-26 - ABSEXCH-14174 - Partial Unpost Optimisations
function TSQLReportsConfiguration.GetUsePartialUnpostOptimisations: Boolean;
begin
  Result := FUsePartialUnpostOptimisations;
end;

//-------------------------------------------------------------------------

// MH 28/03/2013 v7.0.3 ABSEXCH-13218: Added Update Category Level optimisation
Function TSQLReportsConfiguration.GetUseSQLUpdateCategoryLevels : Boolean;
begin
  Result := FUseSQLUpdateCategoryLevels;
end;

//-------------------------------------------------------------------------

Function TSQLReportsConfiguration.GetUpdateCategoryLevelsTimeoutInSeconds : Integer;
begin
  Result := FUpdateCategoryLevelsTimeoutInSeconds;
end;

//-------------------------------------------------------------------------

// MH 05/08/2013 v7.0.5 ABSEXCH-13630: Added direct SQL query into Invoice Tagged Deliveries
function TSQLReportsConfiguration.GetUseSQLInvoiceTaggedDeliveries : Boolean;
Begin // GetUseSQLInvoiceTaggedDeliveries
  Result := FUseSQLInvoiceTaggedDeliveries;
End; // GetUseSQLInvoiceTaggedDeliveries

//-------------------------------------------------------------------------

// MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added pre-load to OLE Server's Internal GL/CC/Dept Caching
Function TSQLReportsConfiguration.GetUseOLEPreloadCaching : Boolean;
Begin // GetUseOLEPreloadCaching
  Result := FUseOLEPreloadCaching;
End; // GetUseOLEPreloadCaching

//-------------------------------------------------------------------------

// MH 03/02/2014 v7.0.9 ABSEXCH-15005: Added SQL improvements into Check All Job Totals
Function TSQLReportsConfiguration.GetUseCheckAllJobTotals : Boolean;
Begin // GetUseCheckAllJobTotals
  Result := FUseCheckAllJobTotals;
End; // GetUseCheckAllJobTotals

//-------------------------------------------------------------------------

// CJS 2014-06-27 - ABSEXCH-15398 - OLE Performance - ENTGLJOBACTUAL
function TSQLReportsConfiguration.GetUseOLESQLTransactionLines: Boolean;
begin
  Result := FUseOLESQLTransactionLines;
end;

//-------------------------------------------------------------------------

// CJS 2015-02-23 - ABSEXCH-15785 - SQL version of Update all Contracts
function TSQLReportsConfiguration.GetUseSQLUpdateJobCategoriesAndContracts: Boolean;
begin
  Result := FUseSQLUpdateJobCategoriesAndContracts;
end;

//-------------------------------------------------------------------------

// CJS 2015-02-23 - ABSEXCH-16133 - SQL version of Check All Job Totals
function TSQLReportsConfiguration.GetUseSQLCheckAllJobs: Boolean;
begin
  Result := FUseSQLCheckAllJobs;
end;

//-------------------------------------------------------------------------

// MH 23/04/2015 v7.0.14 ABSEXCH-15749: Copied ABSEXCH-15725 SQL Update Build Costs from v7.0.11 Post
Function TSQLReportsConfiguration.GetUseSQLUpdateBuildCosts : Boolean;
Begin // GetUseSQLUpdateBuildCosts
  Result := FUseSQLUpdateBuildCosts;
End; // GetUseSQLUpdateBuildCosts

//-------------------------------------------------------------------------

// CJS 2015-04-24 - v7.0.14 - ABSEXCH-16352 - Job Posting doubling committed balances
function TSQLReportsConfiguration.GetDeleteCommitmentHistoryTimeoutInSeconds: Integer;
begin
  Result := FDeleteCommitmentHistoryTimeoutInSeconds;
end;

//-------------------------------------------------------------------------

// CJS 2015-04-24 - v7.0.14 - ABSEXCH-16352 - Job Posting doubling committed balances
function TSQLReportsConfiguration.GetCheckCCDeptBalancesTimeoutInSeconds: Integer;
begin
  Result := FCheckCCDeptBalancesTimeoutInSeconds;
end;

//-------------------------------------------------------------------------

// CJS 2016-04-12 - ABSEXCH-17382 - GL Budget roll up - SQL improvements
function TSQLReportsConfiguration.GetUseSQLRollupGLBudgets: Boolean;
begin
  Result := FUseSQLRollupGLBudgets;
end;

//-------------------------------------------------------------------------

// CJS 2016-04-12 - ABSEXCH-17382 - GL Budget roll up - SQL improvements
function TSQLReportsConfiguration.GetRollupGLBudgetsTimeoutInSeconds: Integer;
begin
  Result := FRollupGLBudgetsTimeoutInSeconds;
end;

// CJS 2016-04-22 - ABSEXCH-17272 - Add Individual Job Budget Update
function TSQLReportsConfiguration.GetRollupJobBudgetsTimeoutInSeconds: Integer;
begin
  Result := FRollupJobBudgetsTimeoutInSeconds;
end;

function TSQLReportsConfiguration.GetReorderTransactionsTimeoutInSeconds: Integer;
begin
  Result := FReorderTransactionsTimeoutInSeconds;
end;

// CJS 2016-05-18 - ABSEXCH-16367 - SQL OLE EntCustNetSales DrillDown performance
function TSQLReportsConfiguration.GetUseEntCustNetSalesOptimisation: Boolean;
begin
  Result := FUseEntCustNetSalesOptimisation;
end;

//-------------------------------------------------------------------------

// PS/TG 02/02/2016 - ABSEXCH-17220 - Check All Stock Level, SQL improvements
function TSQLReportsConfiguration.GetUseSQLCheckAllStockLevel: Boolean;
begin// GetUseSQLCheckAllStockLevel
  Result := FUseSQLCheckAllStockLevel;
end;// GetUseSQLCheckAllStockLevel

function TSQLReportsConfiguration.GetCheckAllStockLevelTimeoutInSeconds: LongInt;
begin // Get time out for Check all Stock Level
  Result := FCheckAllStockLevelTimeoutInSeconds ;
end;

{SS 24/02/2017 2017-R1:ABSEXCH-18399:SBT and PBT transctions should be excluded from single daybook posting.}
function TSQLReportsConfiguration.GetLegacyDayBookPostingUsingSQL: Boolean;
begin
  Result := FLegacyDayBookPostingUsingSQL;
end;


//SS 30/03/2017 2017-R1:ABSEXCH-18509:Daybook Posting Failing on Large Datasets.
function TSQLReportsConfiguration.GetSQLDayBookPostingTimeoutInSeconds: LongInt;
begin
  Result := FSQLDayBookPostingTimeoutInSeconds;
end;

//-------------------------------------------------------------------------

// MH 04/01/2018 2017-R1 ABSEXCH-19316: Added new SQL Posting Status - this status can be
// changed programmatically and due to the potential damage that can be caused by running SQL
// Posting after someone/something has disabled it I feel it is best to always go to the source .INI
Function TSQLReportsConfiguration.GetSQLPostingStatus (Company : String) : TSQLPostingStatusEnum;
Var
  oIniFile : TIniFile;
  sEntryIdent, sIniStatus, sCalcStatus  : ShortString;
Begin // GetSQLPostingStatus
  If FileExists(FIniPath) Then
  Begin
    oIniFile := TIniFile.Create(FIniPath);
    Try
      sEntryIdent := 'SQLDaybookPosting-' + Trim(Company);

      If oIniFile.ValueExists('Posting', sEntryIdent) Then
      Begin
        // Determine the Posting Status - as it is a Hash we need to compare it
        // against known valid values to identify the current value
        sIniStatus := oIniFile.ReadString ('Posting', sEntryIdent, '');

        // Check for Pending Status
        sCalcStatus := StrToSHA3Hase(Trim(Company) + '=' + IntToStr(Ord(psPending)));
        If (sIniStatus = '') Or (sIniStatus = sCalcStatus) Then
          // No Posting Entry for Company - Posting Status is Pending
          Result := psPending
        Else
        Begin
          // Check for Passed Status
          sCalcStatus := StrToSHA3Hase(Trim(Company) + '=' + IntToStr(Ord(psPassed)));
          If (sIniStatus = sCalcStatus) Then
            // Posting Status is Passed
            Result := psPassed
          Else
            // Assume Failed Status
            Result := psFailed;
        End; // Else
      End // If oIniFile.ValueExists('Posting', sEntryIdent)
      Else
        // No Posting Entry for Company - Posting Status is Pending
        Result := psPending;
    Finally
      oIniFile.Free;
    End; // Try..Finally
  End // If FileExists(FIniPath)
  Else
    // No SQL Config File - Posting Status is Pending
    Result := psPending;
End; // GetSQLPostingStatus

//-----------------------------------

// MH 04/01/2018 2017-R1 ABSEXCH-19316: Added new SQL Posting Status
Procedure TSQLReportsConfiguration.SetSQLPostingStatus(Const Company : String; Const NewStatus : TSQLPostingStatusEnum);
Var
  oIniFile : TIniFile;
  sEntryIdent, sCalcStatus  : ShortString;
Begin // SetSQLPostingStatus
  oIniFile := TIniFile.Create(FIniPath);
  Try
    sEntryIdent := 'SQLDaybookPosting-' + Trim(Company);
    sCalcStatus := StrToSHA3Hase(Trim(Company) + '=' + IntToStr(Ord(NewStatus)));
    oIniFile.WriteString('Posting', sEntryIdent, sCalcStatus);
  Finally
    oIniFile.Free;
  End; // Try..Finally
End; // SetSQLPostingStatus

//-------------------------------------------------------------------------

// Returns TRUE if the specified setting exists
Function TSQLReportsConfiguration.SettingExists(Const Section, Ident : String) : Boolean;
Begin // SettingExists
  With TIniFile.Create(FIniPath) Do
    Try
      Result := ValueExists(Section, Ident);
    Finally
      Free;
    End; // Try..Finally
End; // SettingExists

//-----------------------------------

// Deletes the specified key
Procedure TSQLReportsConfiguration.DeleteKey(Const Section, Ident : String);
Begin // DeleteKey
  With TIniFile.Create(FIniPath) Do
    Try
      DeleteKey(Section, Ident);
    Finally
      Free;
    End; // Try..Finally
End; // DeleteKey

//-------------------------------------------------------------------------

Initialization
  oSQLReportsConfiguration := NIL;
  iTSQLReportsConfiguration := NIL;
Finalization
  oSQLReportsConfiguration := NIL;
  iTSQLReportsConfiguration := NIL;
End.

