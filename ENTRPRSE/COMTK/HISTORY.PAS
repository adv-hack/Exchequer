unit History;

interface

{
--------------------------------------------------------------------------------
TKCOM~70.525  13/11/2012
--------------------------------------------------------------------------------
CS: ABSEXCH-13585

    Changes to DLL Toolkit code:

      Corrected EX_UPDATEUPLIFT2() in Uplift.pas to call EX_GETLINESERIALNOS()
      with LineNo rather than AbsLineNo.

      Corrected Get_LineSerial() in DLLSrBOM.pas to prevent it returning error 9
      if it encounters the end of the file while building the list of serial
      numbers.

      Both of these were causing an error 1001 in the Advanced Freight Uplift
      plugin when trying to apply the uplift on an inserted (not added)
      transaction line.
--------------------------------------------------------------------------------
TKCOM-561.258   03/05/2005
PR: Recompiled for 5.61

TKCOM-560.257   28/01/2005
PR: BUGFIX: On transaction lines with certain split pack products, the quantity was being altered when the line was
edited in Enterprise.

TKCOM-560.256   26/01/2005
PR: BUGFIX: Extended IStock.stBinLoc from 8 characters to 10 to match Enterprise.



TKCOM-560.245  25/10/2004
=========================
PR: BUGFIX: ITransactionLine.ExplodeBom was not always adding CC and Dept correctly.

TKCOM-560.244  21/10/2004
=========================
PR:  BUGFIX:  ITransactionLineAsWOR.ExplodeBom was not adding the bom lines.

TKCOM-560.243  18/10/2004
=========================
PR:  BUGFIX: Fixed problem where links were not found after a transaction had been converted.

PR:  BUGFIX: Fixed problem where IConvert.Execute was returning a 30003 error when lines had been written off.
PR:  BUGFIX: Fixed problem where ISerialBatch.snInDate was not always read correctly. (TKDLL560.182)
PR:  BUGFIX: Fixed problem where adding SINs through Batch Transactions was updating the customer's balance twice.
PR:  BUGFIX: Fixed problem where ITransaction.ImportDefaults was not setting thTransportNature correctly.

PR:  BUGFIX: Fixed problem where tlQtyMul was not stored correctly when saving after update. (TKDLL560.182)

TKCOM-560.242  8/10/2004
========================
PR:  BUGFIX: Fixed problem where Auto-Transactions were not stored correctly after update.

TKCOM-560.240  28/9/2004
========================
PR:  BUGFIX: Fixed problem where data files were not always closed on CloseData.
PR:  BUGFIX: Fixed problem where tlQtyMul was not stored correctly when saving after update.

TKCOM-560.241  27/9/2004
========================
PR:  BUGFIX: Fixed problem where tlReconciliationDate was not being read correctly.

TKCOM-560.236  20/9/2004
========================
PR:  BUGFIX: Fixed problem where update transaction lines were losing their reference to the alt stock code database.

TKCOM-560.235  15/9/2004
========================
PR:  BUGFIX: Fixed problem with Links being added to the wrong object.
PR:  BUGFIX: Fixed problem where, in certain circumstances, data file handles were not released correctly when CloseToolkit was called.

TKCOM-560.234  15/9/2004
========================
PR:  BUGFIX: Fixed problem where serial number count on Transaction Lines was not being set correctly.
PR:  BUGFIX: Fixed problem with Alternate Stock Codes being added to the wrong stock record.

TKCOM-560.232  2/9/2004
========================
PR:  BUGFIX: Fixed problem where internal Transaction Header LineCount was not being set correctly, resulting in lines added in Enterprise appearing out of order.

TKCOM-560.231  2/9/2004
=======================
CHANGE: Made registry modifications for company selection.

Documentation Update  21/07/04
HM: Added a tutorial for Microsoft Visual Basic.NET 2003 and Microsoft C# 2003.

TKCOM-560.229  16/7/2004
========================
PR:  BUGFIX: Fixed problem where if Auto Set Period was True it would set the period on a transaction that was being updated.

TKCOM-560.224  5/7/2004
=======================
PR:  BUGFIX: Fixed Catastrophic Failure during IBackToBackOrder.Execute.
PR: CHANGE: Added ITransactionLineSerialBatch3 interface with UseBatch method to allow quantity to be specified when using batch numbers. Extended Delete function on  IMatching
 interface to allow financial matching to be deleted.

TKCOM-560.221  11/6/2004
========================
PR:  BUGFIX: Fixed problem where payment lines were not being stored correctly.

TKCOM-560.220  27/5/2004
========================
PR:  BUGFIX: Fixed problem with ITransction.UpdateEx not updating batch members.

TKCOM-560.219  18/5/2004
========================
PR:  BUGFIX: Fixed problem with notes on serial numbers not always being found.
PR:  BUGFIX: Fixed problem during transaction conversion where PDN lines with zero quantity caused the process to hang.

TKCOM-560.218  14/5/2004
========================
CHANGE: Added AddDescriptionLines method and tlAsApplication property to ITransactionLine3 interface. Added thAsApplication property to ITransaction3 interface. Added jrApplications  property to IJob3 interface to encapsulate Apps and Values functionality. Added IEmployee4 interface with emTimeRateRules property.

TKCOM-560.217  2/03/2004
========================
PR: CHANGE: Added ExplodeBom method to ITransactionLine3 interface.

TKCOM-560.212  24/02/2004
=========================
PR: CHANGE: Added IAccount2.Print and IStock2.Print methods to allow the Customer and Stock records to be printed.  Added IPrintFormList2.AddForms to allow separate print jobs to be merged, for example to generate a Range of Document type output within a single preview window or EDF file.

TKCOM-560.208  20/01/2004
=========================
PR: CHANGE: Added interfaces ITransaction3, ISystemSetup3, ISerialBatch2, ISerialBatchDetails2.

TKCOM-560.207  19/01/2004
=========================
PR: CHANGE: Added interfaces IMultiBin, ITransactionLine3.

TKCOM-560.206  12/01/2004
=========================
PR: CHANGE: First build of 560. Added the following interfaces: IAccount2, IStock2, IAltStockCode, ISalesAnalysis.

TKCOM-552.204  10/12/2003
=========================
PR:  BUGFIX: IBackToBackOrder.Execute was sometimes causing a Catastrophic Failure.


Phase 1 & 2 Mods for version 5.50 release:
28/11/2003     TKCOM-552.203
===============================
PR: BUGFIX: IStockBOMList was not closing files on destroy if its interface mode was imClone.

19/11/2003     TKCOM-552.202
===============================
PR: BUGFIX: IConvertList was sometimes causing a Catastrophic Failure because member interfaces were being destroyed
            prematurely.

17/11/2003     TKCOM-552.201
===============================
PR: BUGFIX: Fixed 30505 error when saving updated SDN where qty had been changed in Ent.

26/09/2003     TKCOM-552.200
===============================
PR: BUGFIX: IMatching.Delete was not deleting custom matches correctly.

08/09/2003     TKCOM-552.199
===============================
PR: BUGFIX: Transaction.Save was changing gl codes
PR: BUGFIX: Fixed rounding error on ITransaction.Save

02/09/2003     TKCOM-552.198
===============================
PR: BUGFIX: Fixed problem storing JobBudgets
PR: BUGFIX: Fixed access violation during ITransaction.UpdateTotals

27/08/2003     TKCOM-552.197
===============================
PR: BUGFIX: Made changes to ITransaction.Save to ensure that totals are always calculated correctly.

18/08/2003     TKCOM-552.196
===============================
PR: BUGFIX: Fixed problem with SettlementDiscount in ITransaction.Save.

18/07/2003     TKCOM-552.194
===============================
PR: BUGFIX: Fixed problem causing Catastrophic Error in IBackToBack.Execute.

14/07/2003     TKCOM-552.193
===============================
PR: Change: Transaction line was not loading serial batches on all types of transactions.

11/07/2003     TKCOM-552.191
===============================
PR: Change: Changed way that ITransactionLineSerialBatch handles Btrieve files to fix problems with
            error 87 when loading large transactions.

08/07/2003     TKCOM-552.190
===============================
PR: Changed way Btrieve files are closed to avoid problems caused by COM sub-system taking its time to free objects.

08/07/2003     TKCOM-551.189
===============================
PR: BUGFIX: Transactions with a BOM which wasn't the first line in the transaction were losing earlier
            lines when saved.


25/06/2003     TKCOM-551.188
===============================
PR: Change: Added IJobInvoiceTransaction3 with jiCost & jiQty properties (read-only)
PR: BUGFIX: IJobInvoice defaults to currency 1 (or 0 if not multi-currency)
PR: BUGFIX: Sam Smith's problem with job actual closing job file is fixed (i hope).
PR: BUGFIX: Fixed vat code error on ITransaction.UpdateEx(umNonFinancial)
PR: BUGFIX: Fixed problem with Cancel on UpdateEx.
PR: BUGFIX: Fixed problem with updating Noms with vat plus potential rounding issue with vat on Noms.
PR: BUGFIX: Description lines were being validated for vat codes.
PR: BUGFIX: JobActual object was causing problems with Job object when freed.

06/06/2003     TKCOM-551.187
===============================
PR: Change: Added handling for vat on noms via the following interfaces and properties:
            ITransactionAsNOM2.tnVatIO  - (vioNA, vioInput, vioOutput)
            ITransactionLineAsNOM2.tlnNomVatType - (nlvNA, nlvAuto, nlvManual)
            Also added IEmployee3 interface with emLabourViaPL property (WordBool)
PR: BUGFIX: Error 13 during IBackToBackOrder.Execute was caused by not treating Euro system as Multicurrency

30/05/2003     TKCOM-551.186
===============================
PR: Change: IJobInvoiceTransaction2 added - has jiCharge property.
PR: Change: umNonFinancial constant added to TTransactionUpdateMode enumeration. When passed as
            a parameter to ITransaction.ExUpdateEx allows non-financial lines to be added, edited &
            deleted from partially settled transactions.

15/05/2003     TKCOM-550.185
===============================
PR: BUGFIX: Error 13 during Transaction Conversions was caused by not treating Euro system as Multicurrency.

13/05/2003     TKCOM-550.183
===============================
PR: BUGFIX: IJobBudget, IJobActual, IJobRetention weren't closing btrieve files when destroyed

08/05/2003     TKCOM-550.182
===============================
PR: Change  Allow SerialBatch.Add to add serial numbers that have been used.
PR: BUGFIX: Under some circumstances JobInvoice wasn't tagging the right actuals.

07/05/2003     TKCOM-550.181
===============================
PR: BUGFIX: JobBudgets weren't being reinitialized with new JobCode when navigating to new Job Record.
PR: BUGFIX: Saving an JobBudget update object was always returning 84.

11/04/2003     TKCOM-550.180
===============================
PR: BUGFIX: Transaction.Save wasn't updating picked qty in mloc record.
PR: BUGFIX: Using SerialNumbers on ADJs & WORs that had been created in Ent was ignoring sign when
            updating SerialQty on line.

11/04/2003     TKCOM-550.179
===============================
PR: Change: Removed error dialogs when problems finding or opening btrieve files

HM: BUGFIX: Added correct handling of LastErrorString into TPrintJob.PrintToTempFile.

PR: Change: Allowed WORs to be used as docs for Serial Numbers.


08/04/2003     TKCOM-550.178
===============================
Change to ITransaction.Save to fix problems with inclusive vat and settlement discount. (TKDLL550.148)


02/04/2003     TKCOM-550.177
===============================
PR: Removed beta from version no

28/03/2003     TKCOM-550.176b
===============================
PR: BUGFIX: Removed 30000 (posted) validation from IJobActual.UpdateCharge, as in Enterprise it
    is possible to update the charge at any point.
PR: BUGFIX: Improved validation on ITimeRate.Save (TKDLL550.146)
PR: BUGFIX: IEmployee.Save wasn't validating Supplier Code correctly. (TKDLL550.146)
PR: Changed IJobBudget.Index from integer to TJobBudgetIndex enumerated type (currently, only value is 0)


26/03/2003     TKCOM-550.175b
===============================
PR: BUGFIX: Modified IAnalysisJobBudget.Delete and ITimeAndStockJobBudget.Delete to return 30001 error if
    there are any transactions for the budget.
PR: CHANGE: IAnalysisJobBudget.Add and ITimeAndStockJobBudget.Add were returning
    generic IJobBudget interfaces. Changed to return specific interfaces.
PR: BUGFIX: IJobRetention.Save was giving invalid department error even with valid dept.
PR: BUGFIX: IJobAnalysis.Save wasn't checking that analysis category and type were a valid combination.
PR: BUGFIX: ITimeRate.Save wasn't checking that analysis category was a valid type for time rates.
PR: BUGFIX: IAnalysisJobBudget and ITimeAndStockJobBudget .jbAnalysisCodeI wasn't being assigned correctly

20/03/2003      TKCOM-550.174b
===============================
PR: ITimeRate2.Save wasn't validating the AnalysisCode correctly.
HM: Added Print method to IJob2.
HM: ITransaction2.Print extended to print Job Costing Backing Sheets

17/03/2003      TKCOM-550.173b
===============================
PR: Added emLinks : ILinks property to IEmployee2
PR: Bugfix: IJobAnalysis2.Save wasn't padding the code field correctly.

14/03/2003      TKCOM-550.172b
===============================
PR: Changed parameters of IJobRetention build index methods to eliminate JobCode parameter.
PR: Bugfix: IJobAnalysis2.Save was insisting on UpliftGL even if uplift was zero.

13/03/2003      TKCOM-550.171b
===============================
PR: Changed IJobAnalysis2.anCISTaxType to be TCISTaxType.
PR: Bugfix: Added check that Employee added as subcontractor has valid Supplier Code
PR: Bugfix: Ensured that codes for new JobCosting types were saved into Enterprise as Upper Case.
PR: Bugfix: Added 30006 error to ITimeRates.Save, where attempting to add Employee time rate which
    doesn't already exist as a global time rate.
PR: Bugfix: IGeneralLedger - glPage and glRevalue weren't saving correctly. Changed to use the
    same rules as Enterprise.
PR: Bugfix: It was possible to add a qtybreak to an IStock object in add mode. Changed to disallow this.
PR: Set default currency and StartDate when IJob is added.

11/03/2003      TKCOM-550.170b
===============================
PR: Changed names of CIS & cost apportionment fields on ITransaction2 and ITransactionLine2 to bring
    them into line with customisation objects.

10/03/2003      TKCOM-550.169b
===============================
PR: Bugfix to rectify problem where SDN & PDN lines weren't being deleted correctly.

07/03/2003      TKCOM-550.168b
===============================
HM: Bugfix to rectify problems with usercount.

05/03/2003      TKCOM-550.167b
===============================
PR: Bugfix - IJobBudget.Delete method was not deleting the budget correctly.

28/02/2003      TKCOM-550.166b
===============================
PR: Added ImportDefaultsForUser method into ITransactionLine2 to allow enhanced security defaults to be adhered to.
PR: Added CIS functionality into ITransaction.Save to add CIS tax withheld line to appropriate transactions.
    (TKDLL550.141)

25/02/2003      TKCOM-550.165b
===============================
PR: Added CIS Fields to ITransaction2, ITransactionLine2, IEmployee2, IJobAnalysis2, IJobActual, IJobRetention,
    IJobBudget.

24/02/2003      TKCOM-550.164b
===============================
PR: Added IJobInvoice object to allow access to functionality of Enterprise Job Invoicing Wizard

21/02/2003      TKCOM-550.163b
===============================
PR: Bugfix. Transaction conversion was not adding SPOP matching correctly.
PR: Bugfix. EntDllSP.Dll was not always being initialised with the correct data directory.

19/02/2003      TKCOM-550.161b
===============================
PR: Added CIS fields to system setup + Added ICISVoucher interface

18/02/2003      TKCOM-550.160b
==============================
PR: Added IJobBudget interfaces - ISummaryJobBudget, IAnalysisJobBudget, ITimeAndStockJobBudget

13/02/2003      TKCOM-550.159b
==============================
PR: Added IJob2 interface with IJobActual and IJobRetention interfaces.

12/02/2003      TKCOM-550.158b
==============================
PR: Added IMatching2 with AddCustom method to support custom matching.

07/02/2003      TKCOM-550.157b
==============================
PR: Added IEmployee2 and ITimeRates2 with Save functions.

05/02/2003      TKCOM-550.156b
==============================
PR: Changed Version to 550. Added IJobType2 and IJobAnalysis2 with Save functions.

17/01/2003      TKCOM-501.155b
===============================
PR: Bugfix: In some circumstances ITransactionDetails was causing a Catastrophic Failure when accessed
    a second time.

17/01/2003      TKCOM-501.155b
===============================
PR: Bugfix: ITransactionLineAsPayLine.plChequeNo was wrongly declared as an integer. Changed to
    widestring.
PR: Bugfix: After converting transactions, ITransaction.Save was returning errors. Fixed.
PR: Improved suppression of exceptions in the ObjectBrowser when running in the Delphi IDE.


11/12/2002      TKCOM-501.154b
===============================
PR: Added ITransactionLineAsPayLine.UpdatePayInRef method
PR: Added ITransactionLine2.UpdateUplift method
PR: Added ITransaction2.UpdateEx method to add dll functions Ex_StoreTransHed, Ex_StoreTransDetl,
    Ex_UpdateDueDate, Ex_UpdateLineDate
PR: Added ITransactionLine2.tlDocType

4/12/2002      TKCOM-501.153b
===============================
PR: Changed ITransactionDetails.BuildReconcileIndex to BuildRecStatusIndex
PR: Added ITransaction2.thTagNo
PR: Added ITransactionLine2.tlYear, tlPeriod and tlNomMode.

24/10/2002      TKCOM-500.152b
===============================
PR:  Added ITransactionAsBatch interface to give Batch Transaction support.
PR:  Added IBackToBackOrder interface
PR:  Added ITransactionLineAsPayLine interface

27/09/2002      TKCOM-500.151b
===============================
PR:  Added ITransactionLineAsWOR with ExplodeBOM method

26/09/2002      TKCOM-500.150b
===============================
PR:  Added IBackToBackOrder interface to ITransaction2
PR:  Added Copy and Reverse methods to ITransaction2
PR:  Added Transaction Conversions - IConvert, ISingleConvert, IConvertList,
     ISystemProcesses

PR:  Added ILinks interface + thLinks property to ITransaction2
PR:  Added Alternative Views to ITransaction2: AsADJ, AsNOM, AsTSH, AsWOR
PR:  Added ISystemSetupFormDefinitionSet Interface + new property
     ssFormDefinitionSet to ISystemSetup2
PR:  Added ISystemSetupPaperless2 Interface with extra properties for
     company fax/email signatures
PR:  Added ISystemSetup2 Interface with extra properties for WOP settings
PR:  Added ISystemSetupUserFields2 interface with extra properties
PR:  Added IToolkit2 interface with extra properties
      TransactionDetails : ITransactionDetails
      UserProfile : IUserProfile

PR:  Added IUserProfile interface
PR:  Added ITransactionDetails Interface;}

implementation

end.

