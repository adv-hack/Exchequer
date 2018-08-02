unit History;

interface

// Current Exchequer/IAO EnterOLE version
Function CurrVersion_OLE : ShortString;

implementation

Uses ExchequerRelease;

Const

  BuildVer_OLE = '157';   // EntReg Build Number - common across Exch & IAO

  // NOTE: The build number should be incremented for any new version leaving
  // the department, even if just to QA for testing.

// Current Exchequer/IAO EnterOLE version
Function CurrVersion_OLE : ShortString;
Begin // CurrVersion_OLE
    Result := ExchequerModuleVersion (emOLEServer, BuildVer_OLE);
End; // CurrVersion_OLE


(**************************************************************************************

//
// IMPORTANT NOTE: Must be compiled on a Delphi 6 Update Pack 1 machine (see Build 080)
//

EnterOLE Version History
========================

26/06/2018  EnterOLE build 157
------------------------------
  HV        ABSEXCH-20793: provided support for entry in anonymisation control center if user changes Account Status to from OLE.

03/01/2018  EnterOLE build 156
------------------------------
  MH        ABSEXCH-19552: Added check on Employee Status into Add TSH function


29/11/2016  EnterOLE build 155
----------------------------------------
  MH        ABSEXCH-17754: Removed borders from Login dialog as per Exchequer Login dlg


29/10/2016  EnterOLE build 154
----------------------------------------
  MH        Merged Sprint 10 changes from Advanced India - ABSEXCH-17736


16/09/2016  EnterOLE build 153
----------------------------------------
  MH        Merged Sprint 7 changes from Advanced India - ABSEXCH-12531 / 14589 / 15847 / 16676

02/09/2016  EnterOLE build 152
----------------------------------------
  MH        Merged Sprint 6 changes from Advanced India - ABSEXCH-12531 / 14589 / 15847 / 16676

01/06/2016  EnterOLE build 151
----------------------------------------
  MH
   ABSEXCH-17488: Added support for 10 character TARIC Codes

06/05/2016  EnterOLE build 150
----------------------------------------
  MH        ABSEXCH-17353: Added Revised Budgets 1-5 to GL History

11/02/2016  EnterOLE build 149
----------------------------------------
  PKR       ABSEXCH-17252: Allow Mode of Transport to be set to 0 (or blank in Excel)
            which will reset it back to default and show it as blank in Exchequer.


10/02/2016  EnterOLE build 148
----------------------------------------
  PKR       ABSEXCH-17252: Return an error value when saving Intrastat fields
            (Mode of Transport, Default to QR Code, Delivery Terms) when the trader's
            EC Member flag is not set.


04/02/2016  EnterOLE build 147
----------------------------------------
  PKR       ABSEXCH-17242: Validate Commodity Code


25/01/2016  EnterOLE build 146
----------------------------------------
  PKR       ABSEXCH-17111: Added Default to QR for Customers/Consumers


18/01/2016  EnterOLE build 145
----------------------------------------
  MH        ABSEXCH-17099: Removed Country of Origin from Stock Record for UK Companies


18/11/2015  EnterOLE build 144
----------------------------------------
  PR        Amended TEnterpriseServer.SaveStockMiscVal to take account of WOR Allocated qty when
            calculating free qty (ABSEXCH--10246 for Enter1)


28/07/2015  EnterOLE build 143
----------------------------------------
  MH        Fixed up after merge


21/07/2015  EnterOLE build 142
----------------------------------------
  MH        Merged v7.0.14 into 2015-R1


26/06/2015  EnterOLE v7.0.14.141
----------------------------------------
  MH        Modified versioning for Exchequer 2015 R1


20/05/2015  EnterOLE v7.0.14.140
----------------------------------------
  MH        ABSEXCH-16284: Added PPD OLE Functions


04/03/2015  EnterOLE build 139
----------------------------------------
  MH        ABSEXCH-16600: Added validation of PPD Percentage and Days


02/12/2014  EnterOLE OrdPay.139
----------------------------------------
  MH        ABSEXCH-15836: Added Read-Write support for new account Country fields


22/10/2014  EnterOLE OrdPay.138
----------------------------------------
  MH        Added Read-Write support for new customer Order Payments fields


09/10/2014  EnterOLE v7.0.12.139
----------------------------------------
  MH        ABSEXCH-15632: Added Auto-Reversing Support to AddNOMLines


08/10/2014  EnterOLE v7.0.12.138
----------------------------------------
  MH        Rebranded from v7.1 to v7.0.12


09/09/2014  EnterOLE v7.1.138
----------------------------------------
  MH        ABSEXCH-15052 - Added Read/Write support for new Stock IsService flag


18/07/2014  EnterOLE v7.0.11.137
----------------------------------------
  MH        ABSEXCH-15521 - Copied new CheckUserPermission routine in from v7.0.4


07/07/2014  EnterOLE v7.0.11.136
----------------------------------------
  CS        ABSEXCH-15398 - OLE Performance - ENTGLJOBACTUAL - amended to use
            stored procedure


02/07/2014  EnterOLE v7.0.11.134
----------------------------------------
  CS        ABSEXCH-15398 - OLE Performance - ENTGLJOBACTUAL


10/06/2014  EnterOLE v7.0.11.133
----------------------------------------
  MH        ABSEXCH-15424: Changed type to TMemoField due to DB change


28/10/2013  EnterOLE v7.0.7.132
----------------------------------------
  MH        ABSEXCH-14705: Added Transaction Originator fields


18/10/2013  EnterOLE v7.0.7.131
----------------------------------------
  MH        ABSEXCH-14703: Added Delivery Postcode functions


10/09/2013  EnterOLE v7.0.6.130
----------------------------------------
  MH        ABSEXCH-14598: Added SEPA/IBAN fields


20/08/2013  EnterOLE v7.0.6.129
----------------------------------------
  MH        ABSEXCH-14534: Added caching on Job Records and Analysis Code Records and
                           modified JC History funcs and Job Record Read and Analysis Code
                           Read functions to use them - see JIRA for full list.


19/08/2013  EnterOLE v7.0.6.128
----------------------------------------
  MH        ABSEXCH-14534: Modified company object to auto-load the Nominal/CC/Dept caching in the
                           SQL Edition when the caching object is created.


10/07/2013  EnterOLE v7.0.5.127
----------------------------------------
  MH        Recompiled for v7.0.5 + branding mods


19/06/2013  v7.0.4.126
----------------------------------------
  CS       ABSEXCH-14012: Added stored-procedure version of SaveNominalValue,
           for performance reasons.

12/02/2013  v7.0.2.125
----------------------------------------
  MH       ABSEXCH-13580: Added memory map to allow company login details to be provided by
           Exchequer 365 in advance of the OLE Server running up.


20/07/2012  v7.0.124
----------------------------------------
  PR       Fix for ABSEXCH-13183: Revision history record wasn't being added correctly if a new ytd record for the year was being
           added.


07/06/2012  v7.0.123
----------------------------------------
  PR       Amended TEnterpriseServer.SaveNominalValue to add a record to the BudgetHistory file whenever
           a revised budget is stored.  ABSEXCH-12957

16/05/2012  v6.10.122
----------------------------------------
  MH       Extended range of Purchase/Sales Intrastat Field to +/- 100


02/05/2012  v6.10.121
----------------------------------------
  MH       EIRE v6.10.1 version of .120 fix


02/05/2012  v6.10.120
----------------------------------------
  MH       ABSEXCH-12891: Disabled SQL check as someone removed the stored procedure in v6.9!


04/04/2012  v6.10.119 - v6.10.1 EIRE RCT
----------------------------------------
  MH       Extended SaveStockMiscVal to support Intrastat Uplift Arrivals/Despatch% (ABSEXCH-12547/ABSEXCH-12548)


09/03/2012  v6.10.118
---------------------
  MH       REbuilt to pickup fixes to trader audit (ABSEXCH-12127)



29/11/2011  v6.9.117
--------------------
  MH       ABSEXCH-12226 - Corrected Copyright


23/11/2011  v6.9.116
--------------------
  MH       ABSEXCH-12075 - Audit Notes not being written for NOM's


22/11/2011  v6.9.115
--------------------
  MH       Audit Notes not being written for EntJCJobSaveXXX functions


03/11/2011  v6.9.114
--------------------
  MH       Added support for 10 UDEFs for the job records
           Extended AddTSHLinesErrorDesc to support 10 header and line udef fields
           Extended AddNomLines to support 10 header and line udef fields


27/10/2011  v6.9.113
--------------------
  GS       ABSEXCH-11706 - added support for 10 UDEFs for the customer, supplier and stock records


18/10/2011  v6.8.112
--------------------
  PR       ABSEXCH-12005 - Recompiled to pick up fix in EntLoggingClass for CPU hogging.


07/09/2011  v6.8.111
--------------------
  MH       ABSEXCH-11673 - Added stored procedure call into SQL account ageing function


26/08/2011  v6.8.110
--------------------
  MH       ABSEXCH-11673 - Added caching mechanisms into account ageing functions and nominal history function


19/05/2011  v6.7.109
--------------------
  MH       ABSEXCH-11374 - Rebuilt to pickup fix to LTotal_Profit_To_Date as it was always using
           the root company when called from the OLE Server


18/03/2011  v6.7.107
--------------------
  MH       ABSEXCH-11090 - Added EntAddNomTxfrLinesUDF for Jelf


03/03/2011  v6.7.106
--------------------
  MH       Added Trader Audit Trail


23/04/2010  v6.4.105
--------------------
  MH       Automated the build under FinalBuilder


04/02/2010  v6.3.104
--------------------
  MH       Modified Add Timesheet functions to set the new thWeekMonth field in addition
           to the existing DiscDays field


26/06/2009  v6.01.103
---------------------
  MH       Modified GetJCBudgetValue so that for contracts with missing budget records it
           builds a list of the jobs within the contract and returns the sum for the individual
           jobs instead


08/06/2009  v6.01.102
---------------------
  MH       Corrected GL Views functions to check permission 567


19/11/2008  Build 100
---------------------
  MH       Merged in .080/.081/.082 changes below from MD Events build


       27/10/2008  Build 082 MD
       ------------------------
         MH       Added support for saving Job Anal Budget Currency into SaveJCBudgetValue


       23/10/2008  Build 081 MD
       ------------------------
         MH       Fixed a bug in GetJCBudgetValue which meant CS's Job Anal Budget Currency Mods didn't
                  execute.


       28/01/08   Build 080
       --------------------
         CS       Added support for Job Budget currencies.


14/08/08   Build 083
--------------------------------------
  MH       Applied branding changes to Login dialog


12/08/08   Build 082
--------------------------------------
  MH       Recompiled to pickup SQLUtils API changes for Total_Profit_To_Date


22/07/08   Build 081
--------------------------------------
  MH       Recompiled to pickup SQLUtils API changes


26/02/08   Build 080
--------------------------------------
  MH       Recompiled as discovered that Update Pack 2 (as on CS machine) causes Invalid Data Type
           errors in the XLA whenever the OLE Server functions are called resulting in cells being
           set to #VALUE.


14/08/07   Build 079
--------------------------------------
  MH       Modified to use HTML Help


01/08/07   Build 078
--------------------------------------
  MH       Updated Branding/Icon, corrected font on main form


21/03/07   (for v5.71.002)
--------------------------------------
  MH       Extended GetJCBudgetValue and SaveJCBudgetValue to support the Recharge and
           Overhead Charge% fields on the Job Analysis Budget window


05/06/07   EnterOLE.Exe Build 078
--------------------------------------
  MH       Fixed a bug in the OLE Login dialog where the EditMask setting was causing
           underscores to be stripped out of the user id


29/03/07   EnterOLE.Exe Build 077
--------------------------------------
  MH       Modified the OLE Login dialog to support separate background bitmap for SQL.


21/03/07   EnterOLE.Exe Build 076
--------------------------------------
  MH       Modified GetStockValue for Qty Used periods 101-199 to subtract the previous
           years YTD as it is incorrectly included.


11/12/06   EnterOLE.Exe Build 075
--------------------------------------
  MH       Modified error message for Noble Denton


06/11/06   EnterOLE.Exe Build 074
--------------------------------------
  MH       Added "Their A/C for Us" into Customer/Supplier Read/Write functions


19/10/06   EnterOLE.Exe Build 073
--------------------------------------
  MH       Modified Save Stock GL Code functions to support GL Classes


13/10/06   EnterOLE.Exe Build 072
--------------------------------------
  MH       Extended AddTSHLinesErrorDesc to support Transaction Date as well.

           NOTE: This requires an updated EntStk2.Xla and breaks the Noble Denton XLA 


06/10/06   EnterOLE.Exe Build 071
--------------------------------------
  MH       Added backdoor into SaveStockMiscInt for IAO to allow the Stock/GL Codes to
           be updated without an OLE Save release code


25/09/06   EnterOLE.Exe Build 070
--------------------------------------
  MH       Fixed bug in AddTSHLinesErrorDesc where the Noble Denton check on the Time
           Rate Job Code was using the Job Code from the wrong record causing it to
           fail under certain circumstances.
           

21/06/06   EnterOLE.Exe Build 069
--------------------------------------
  MH       Added new AddTSHLinesErrorDesc function as a superset of AddTSHLinesEx with
           additional validation options and the ability to return error descriptions.

           This work was done for a custom XLA for Noble Denton, there should be no
           changes to the existing Exchequer AddTSH functions.


21/06/06   EnterOLE.Exe Build 068
--------------------------------------
  CS       Added new G/L View functions:

            EntGL.xla:
              EntGLAddInVer
              EntGLViewActual
              EntGLViewBudget
              EntGLViewBudget2
              EntGLViewCredit
              EntGLViewDebit
              EntGLViewName
              EntGLViewAltCode
              EntGLViewLinkCode
            
            EntGL2.xla:  
              EntGLSaveAddInVer
              EntGLViewSaveAltCode
              EntGLViewSaveName
              EntGLViewSaveBudget
              EntGLViewSaveBudget2

           Moved all the existing G/L functions into EntGL and EntGL2.

13/04/06   EnterOLE.Exe Build 067
--------------------------------------
  MH       Modified Add NOM and Add TSH functions to set ILineCount to the next line
           number not the number of lines.

  MH       Added new EntStkReorder and EntStkLocReorder functions for Supplier/CC/Dept

  MH       Modified the Login dialog to check the expiry flag on the user profile.

  MH       Modified GetCustSalesPrice as it was incorrectly resetting the price to the original if no qty breaks defined

  MH       Modified Add Timesheet functions to allow -ve hours.

  MH       Added Customer/Supplier Get/Set Tag Number functions

  MH       Added Stock Type into GetStockmiscStr

  MH       Added Job Type into GetJobMiscStr

  MH       Added Job QS Code into GetJobMiscStr/SaveJobMiscStr

  MH       Added a ResetJCGL parameter into AddNomLines to allow the resetting of GL Codes for Jobs to be disabled

  MH       Fixed various incorrect padding/uppercasing problems for Stock/Cust/Job functions

  MH       Extended Cust/Supp Value functions to support Revised Budget


07/04/06   EnterOLE.Exe Build 066
--------------------------------------
  MH       Modified OLE Server to intelligently switch between IAO and Exchequer
           branding depending on where it is installed.


24/11/05   EnterOLE.Exe v5.70.065
--------------------------------------
  MH       Extended .064 with more rules:-

             * Customers cannot be A and can only be D if an EC Member

             * Customers cannot be D and can only be A if an EC Member

             * Stock cannot be either A or D


24/11/05   EnterOLE.Exe v5.70.064
--------------------------------------
  MH       Modified the Cust/Supp/Stock default VAT Code functions to handle Inclusive
           VAT Codes correctly:-

             EntCustVATCode, EntSuppVATCode, EntStkVATCode
             =============================================
             For normal VAT these will continue to return the VAT Code in the same
             manner, e.g. 'S', but for inclusive VAT this will return both codes
             together e.g. ‘IS’.

             EntCustSaveVATCode, EntSuppSaveVATCode, EntStkSaveVATCode
             =========================================================
             These have been modified so that they will take a normal VAT Code or
             the VAT Code plus Inclusive VAT Code in the formats ‘S’ and ‘IS’.


22/09/05   EnterOLE.EXe v5.70.063
--------------------------------------
  MH       Released for v5.70


19/08/04   EnterOLE.Exe b570.063
--------------------------------------
  MH       Rebranded for IRIS Enterprise Software / Exchequer


17/08/05   EnterOLE.Exe b570.061
--------------------------------------
  MH       Fixed a bug in the Warranty validation where passing in a string
           over 4 chars caused the warranty to be reset to 0 days.


02/08/05   EnterOLE.Exe b570.061
----------------------------------------
  MH       Moved the Stock Restocking Charge to the string functions to allow
           a percentage to be specified.

  MH       Changed the Warranty Length for Stock Sales/Manufacturing warranties
           to max out at 99 in the same way Exchequer does.

  MH       Modified SaveLocationMiscStr / SaveLocationMiscInt to check the
           override flags prior to setting the CC/Dept and GL Codes.


02/08/05   EnterOLE.Exe b570.060
----------------------------------------
  HM       Added Goods Returns functions for Stock & Stock-Locations

  MH       Added loadsa functions for reading & updating Location records


07/04/05   EnterOLE.Exe b561.059
----------------------------------------
  HM       Rebuild to pickup Base33 OurRef changes done by EL for v5.61.001


25/02/05   EnterOLE.Exe v5.61.058
----------------------------------------
  HM       Released for v5.61


25/02/05   EnterOLE.Exe b561.058
----------------------------------------
  HM       Added security into several functions missing security.



14/02/05   EnterOLE.Exe b561.057
----------------------------------------
  HM       Applied corrected v5.61 OLE Passwords for Job Analysis Codes


03/02/05   EnterOLE.Exe b561.056
----------------------------------------
  HM       Rebuilt with EL's v5.61 Code.

  HM       Applied new v5.61 OLE Passwords

  HM       Modified EntCustSalesPrice to use Today for the date specific
           discounts.


03/02/05   ENTFUNCS.xla v5.61.146
           ENTFUNC2.xla v5.61.141
           ENTSTK.xla  v5.61.142
           ENTSTK2.xla v5.61.144
           EntApps.xla v5.61.002
----------------------------------------
  HM       Released for v5.61


21/12/04   EnterOle.EXe b561.055
----------------------------------------
  HM       Modified SaveCustValue for creation of the YTD.


16/12/04
----------------------------------------
  HM       Modified SaveJCBudgetValue with Eduardo for creation of the YTD
           figures.  Noticed in EL's code that Customers do have YTD Balances
           even though they aren't in YTDSet.


14/12/04   EnterOle.EXe b561.055
----------------------------------------
  HM       Various wild stabs in the dark at fixing the bug with B/C GL codes
           not carrying forward the previous years YTD total when a new YTD
           entry is created by SaveNominalValue.


29/11/04   EnterOLE.Exe b561.054
           EntStk2.Xla  b561.143
----------------------------------------
  HM       Extended AddTSHLinesEx to support the header user defined fiels and
           the UDF1 and UDF2 on the lines.


23/11/04   EnterOle.Exe b561.053
----------------------------------------
  HM       Fixed bug in .052 where the ROFlg shouldn't be set if the ROQty = 0


22/11/04   EnterOle.Exe b561.052
----------------------------------------
  HM       Fixed bug in .051 where the ROFlg wasn't being set so Enter1.Exe
           was ignoring the changes even though they showed up on screen.


22/11/04   EnterOle.Exe b561.051
           EntStk.Xla   b561.142
           EntStk2.Xla  b561.142
----------------------------------------
  HM       Added Get/Save Stock/Loc Re-Order Qty functions

22/09/04   EnterOle.Exe v5.60.050
----------------------------------------
  HM       Released for v5.60.001


06/08/04    EnterOLE.Exe b561.050
----------------------------------------
  HM       Did mods for the VAO system so that it detected VAO (VAO.INF)
           and picked up the pathing from the registry key in current user.

           Also hid the system menu menu options and hard coded bitmaps to
           hidden when running under VAO.


23/06/04    EnterOLE.Exe b560.049
----------------------------------------
  HM       Extended EntJCAddContract to set the Start Date to todays date


16/06/04    EnterOLE.Exe b560.048
            EntFuncs.Xla b560.146
            EntStk.Xla   b560.141
            EntStk2.Xla  b560.141
----------------------------------------
  HM       Added EntJCAddContract to allow Contracts to be added into the Job
           Tree.

  HM       Extended GetAcMiscVal to return the BOrdVal for EntCustExtOrderValue.

  HM       Extended GetStockMiscStr to return textual descriptions of the
           Valuation method


14/05/04    EnterOLE.Exe v5.60.047
            EntFuncs.Xla v5.60.145
            EntFunc2.Xla v5.60.138
            EntStk.Xla   v5.60.140
            EntStk2.Xla  v5.60.140
            EntApps.Xla  v5.60.002
----------------------------------------
  HM       Released for v5.60


20/04/04    EnterOLE.Exe b560.047
----------------------------------------
  HM       Modified AddTSHLinesEx to check the CIS Type before checking the
           CIS Expiry Date


20/04/04    EnterOLE.Exe b560.046
----------------------------------------
  HM       Modified AddTSHLinesEx as the rules off the employee record for
           selecting the rate to use were different (screwy!) to my interpretation
           of the docs.


14/04/04    EnterOLE.Exe b560.045
----------------------------------------
  HM       Fixed a bug in SaveAnalMiscStr which didn't allow the Deduct CIS Tax
           field to be set to 0 for N/A.

  HM       Modified AddTSHLinesEx to check that the Job is a Job not a contract.

  HM       Modified AddTSHLinesEx to support Job Pay Rates and use the rules off
           the employee record for selecting the rate.


17/03/04    EnterOLE.Exe b560.044
----------------------------------------
  HM       Added new funcs for Apps & Vals

  HM       Fixed bug in SaveJCBudgetValue where it wasn't setting the correct
           budget field when creating new history records.

23/02/04    EnterOLE.Exe b560.043
----------------------------------------
  HM       Rebuilt with the JC, EN560 and JAP compiler defs in preparation
           for v5.60 and adding Applications through the OLE Server.


11/02/04    EnterOLE.Exe b560.042
----------------------------------------
  HM       Rebuilt for testing with v5.60 App/Vals


18/11/03    EnterOLE.Exe v5.52.041
            EntFuncs.Xla v5.52.143
            EntFunc2.Xla v5.52.138
            EntStk.Xla   v5.52.139
            EntStk2.Xla  v5.52.139
----------------------------------------
  HM       Released for v5.52


03/11/03    EnterOle.Exe b552.041
----------------------------------------
  HM       Recompiled to pick up a bug fix to OLEBtrO.Pas by EL - something to
           do with the currency on Job Actuals. (Micron).


23/10/03    EnterOle.Exe b552.040
----------------------------------------
  HM       Modified AddNomTransfer and AddNomLines to enforce the ForceJC
           and Inactive flags on the NOM's.


24/09/03    EnterOle.Exe b552.039
----------------------------------------
  HM       Modified AddNomTransfer and AddNomLines to initialise the TH currency
           to 0 for Prof and 1 for Euro/Global and to set the header exchange
           rates accordingly.


18/09/03    EnterOle.Exe b552.038
            EntStk.Xla   b552.139
----------------------------------------
  HM       Extended GetStockMiscVal to return the QtyAllocated/lsQtyAlloc
           field that was replaced on 23/05/03 as EntStkQtyOSSOR/EntStkLocOSSOR


18/08/03    EnterOle.Exe b552.037
            EntFuncs.Xla b552.143
            EntFunc2.Xla b552.138
----------------------------------------
  HM       Added Get/Save Status functions for customer/Supplier.


04/08/03    EnterOle.Exe b552.036
            EntStk2.Xla  b552.139
----------------------------------------
  HM       Completed changes to TdOLEExLocal.LUpdate_JobAct after consultation
           with EL.

  HM       Added EntJCAddJob to allow new Jobs to be created


16/07/03    EnterOle.Exe b551.035
----------------------------------------
  HM       Fixed TdOLEExLocal.LUpdate_JobAct where the charge wasn't being set
           correctly.


27/06/03    EnterOle.Exe v5.51.034
            EntFuncs.Xla b551.141
            EntFunc2.Xla b551.135
            EntStk.Xla   v5.50.137
            EntStk2.Xla  v5.50.136
----------------------------------------
  HM       Rebuilt with Release Version No's for v5.51


02/06/03    EnterOle.Exe b551.033
            EntFuncs.Xla b551.141
            EntFunc2.Xla b551.135
----------------------------------------
  HM       Modified EntAddTimesheet and EntAddTimesheetWithCosts to check the
           new v5.51 Employee flag which controls whether Timesheets can be
           added for them.  If they can't the Invalid Employee Code error is
           returned.

  HM       Added EntAddNOMVATLines into EntFunc2.Xla, modified the standard
           AddNomLines routine in OleServr.Pas to also support VAT.


25/05/03    EnterOle.Exe b551.032
            EntFuncs.Xla b551.140
----------------------------------------
  HM       Added Customer & Supplier committed balance functions


23/05/03    EnterOle     b551.031
            EntFuncs.Xla b551.139
            EntStk2.Xla  b551.137
----------------------------------------
  HM       Extended SaveJobMiscStr to support the Job Manager field and added
           EntJCJobSaveManager into EntStk2.Xla.

  HM       Modified GetStockMiscVal to take the 'Picking Order Allocates Stock'
           flag into account when calculating the Allocation Qty.

  HM       Modified SaveStockMiscVal to reset the MinFlg/lsMinFlg properties
           on the Stock and Stock-Location records when the Minimum Stock Level
           is changed.

  HM       Extended GetAcMiscStr to support the Invoice and Statement delivery
           mode fields.  Added EntCustInvoiceDeliveryMode, EntCustStatementDeliveryMode,
           EntSuppInvoiceDeliveryMode and EntSuppRemittanceDeliveryMode into
           EntFuncs.Xla.

  HM       Extended SaveAcMiscStr to support the Invoice and Statement delivery
           mode fields.  Added




19/05/03    EnterOle     b551.030
----------------------------------------
  HM       Fixed a case sensitivity problem in SaveStockMiscVal when updating
           the Stock Sales Price - if you passed the Band in lower case it wasn't
           recognized.


24/03/03    EnterOLE     v5.50.029
            EntFuncs.Xla v5.50.138
            EntFunc2.Xla v5.50.133
            EntStk.Xla   v5.50.137
            EntStk2.Xla  v5.50.136
            EntData.Xla  v5.50.004
----------------------------------------
  HM       Released for v5.50


EnterOLE b550.029 - 17/03/03
--------------------------------

  HM       Changed TEnterpriseServer.GetJCBudgetValue to support the 1xx
           period system for Actual Value & Qty.  This mod will affect the
           EntJCAnal, EntJCStk and entJCTot functions.

  HM       Localised the Version number from VerModU to this file.


-----------------------------------------------------------------------------

EnterOLE.Exe b550.027    Mod
                         ~~~
                         Changed EntAddTimesheet to reject Revenue Analysis Codes as invalid.

EnterOLE.Exe b550.026    Mods
+ EntFuncs.Xla b550.138  ~~~~
                         Modified the Save Alaysis Code functions for improved validation
                         and added error 574

EnterOLE.Exe b550.025    Mods
+ EntStk.Xla   b550.137  ~~~~
+ EntStk2.Xla  b550.136	 Added Get/Save support for Analysis Code record

EnterOLE.Exe b500.022  Mods
                       ~~~
                       Extended GetStockMiscVal to support WOR Quantities.

EnterOLE.Exe v5.00.021 Released 02/07/02 for next build
+ EntFuncs.Xla v5.00.136
+ EntFunc2.Xla v5.00.131
+ EntStk.Xla   v5.00.134
+ EntStk2.Xla  v5.00.135

EnterOLE.Exe b500.021  Bug Fix
                       ~~~~~~~
                       Fixed EntAddNomTxfrLines to convert JobCode to uppercase.

EnterOLE.Exe b500.020  Mods
                       ~~~
                       Added Read/Write support for WOP Fields on Stock record.

EnterOLE.Exe v5.00.019 Released


EnterOLE.Exe b500.019  Bug
                       ~~~
                       Changed EntAddTSH funcs to return an error if sub-contractor
                       certificates have expired.

EnterOLE.Exe b500.018  Mods
                       ~~~~
                       Changed the EntAddtimeSheet functions to ignore 0 hour lines
                       instead of returning a validation error.

EnterOLE.Exe v5.00.017 Bug
                       ~~~
                       Rebuilt for 5.00.001 to pick up changes to the internal Job
                       Costing routines whan adding transactions.

EnterOLE.Exe v5.00.016 Released for Enterprise v5.00
+ EntFuncs.Xla v5.00.134
+ EntFunc2.Xla v5.00.130
+ EntStk.Xla   v5.00.133
+ EntStk2.Xla  v5.00.134

EnterOLE.Exe b500.015  Mods
+ EntFuncs.XLA .134    ~~~~
+ EntStk2.XLA  .134    Added EntAddtimesheetWithCosts function to allow the Hourly 
                       Cost information to be specified when adding Timesheets.

EnterOLE.Exe b500.012  Mods
                       ~~~~
                       Upgraded Login bitmap to new v5.00 bitmap

EnterOLE.EXe v500.010  Mods
                       ~~~~
                       Rebuilt to use new security module from v5.00 security mods
                       and updated the build automation routines for v500/Delphi6.

EnterOLe.EXE b500.xxx  V5.00 Mods
+ Excel Add-Ins        ~~~~~~~~~~
                       Added EntAddTimesheet and Employee, Pay-Rate name functions

                       Modified the Job Budget function to create missing budget 
                       records where necessary.

                       Extended GL History functions to handle the combined CC/Dept
                       history.

----------------------------------------------------------------------------------

EnterOLE.Exe b431.005  Mods
                       ~~~~
                       Extended GetAcMiscStr and SaveAcMiscStr to support the new EmlZipAtc
                       format for EDZ support.

		       Extended GetStockMiscStr to return the Parent Code as string 29. 

EnterOLE.Exe v4.31.004 ????

EnterOLE.Exe 4.31.003  Mods
     14/08/00          ~~~~
                       Changed EntAddNomTransfer and EntAddNomTxfrLines to check the
                       Job Status.

EnterOle.Exe b431.002  Mods
     24/07/00          ~~~~
                       Changed OLE Server and EntFunc2.XLA to support zero value lines
                       in EntAddNomTxfrLines, and to filter them out in the OLE Server
                       before adding the Transaction. 

EnterOle.Exe v4.31.001 Bug
     25/05/00          ~~~
                       Changed GetNominalValue so previous years total not subtracted for
                       101-199 values for budgets.   

EnterOle.Exe v4.31     Released 25/04/00

EnterOLE.Exe b430c.562 Bug
                       ~~~
                       Modified the Password Checking and PrimeLoginDets function as it
                       was failing if the password wasn't padded out to 8 before encryption.
                       It appears that some passwords are and some aren't. 

EnterOLE.Exe b430c.560 Mod
                       ~~~
                       Modified GetNomStats in OLEStatU.Pas as the NCode parameter was
                       too short, this was believed to be breaking the CC/DP Commitment
                       history.

EnterOLE.Exe b430c.559 Mod
                       ~~~
                       Rebuilt as Eduardo has change Cust.EmailAddr

EnterOLE.Exe b430c.558 Bug
                       ~~~
                       Applied index fix supplied by EL to Cust and Stock Save functions.

EnterOLE.Exe b430c.556 Bug
                       ~~~
                       Applied fix supplied by EL to Customer Aging functions.

EnterOLE.Exe b430c.555 Mods
                       ~~~~
                       Modified the Stock/Location Save functions to create the StkLoc
                       record where necessary.

EnterOLE.EXE b430c.554
EntFuncs.Xla b000.115
                       Mods
                       ~~~~
                       Implemented the OLE Save Functions Release Code

EnterOLE.EXE b430c.553, All Add-Ins b000.113
                       Mods
                       ~~~~
                       Changed the SaveStkLoc functions to return error 561 stock/
                       location field disabled if the stockLoc field is disabled on
                       the location record.

EnterOLE.EXE b430c.550 Converted to Delphi 5

EnterOLE.EXE b430b.501 Mods
                       ~~~~
                       Modified the Login dialog for v4.31's encrypted passwords.

EnterOLE.EXE b430b.500 Converted To Delphi 4 
                       ~~~~~~~~~~~~~~~~~~~~~

------------------------------------------------------------------------------------------

ENTEROLE.EXE v4.30e
        16/12/99  HM   Released 

ENTEROLE.EXE b430d.252
        15/12/99  HM   Test version for Omega to address errors on shutdown caused by 4.30d
                       being compiled as Debug. 

ENTEROLE.EXE v4.30d    
        11/10/99  HM   Added new logo to form.

ENTEROLE.EXE v4.30c    Released
                       ~~~~~~~~

EnterOLE.EXE b430b.250
        17/06/99  HM   Bug
                       ~~~
                       Modified AddNom functions to set ILineCount and ABSLineNo fields on
                       Invoice and Lines. This was causing a problem when editing unposted
                       Noms as Enterprise considered all lines to be line 0.

EnterOLE.EXE v4.30b
        24/05/99  HM   Mod
                       ~~~
                       Modified the GetJCBudgetValue function to return 0 instead of Invalid
                       Budget if the budget record doesn't exist in the history.

EnterOLE.EXE b430a.249
         15/04/99  HM   Bug
                        ~~~
                        Modified AddNomTrans functions to ensure Ccy, CXRate, VatCRate and
                        OrigRate are all set correctly.

EnterOLE.EXE b430a.248
         18/03/99  HM   Bug
                        ~~~
                        Extended GetNominalValue for periods 101-199 so that it worked for
                        header types as well. It relies on the P&L start control code being
                        correctly set in system setup.  

EnterOLE.EXE b430a.247
         12/03/99  HM   Bug
                        ~~~
                        Extended GetNominalValue for periods 101-199 so that it subtracted
                        the previous years end of year value to give a true yearly total
                        for control GL codes.     

EnterOLE.EXE b430a.246
         08/03/99  MH   Bugz
                        ~~~~
                        Modified GetJCBudgetValue so that it works with currencies other
                        than Consolidated.

EnterOLE.EXE & ENTFUNCS.XLA
v4.30a   26/02/99  MH   Released

EnterOLE.EXE & ENTFUNCS.XLA
b430.245 25/02/99  MH   Bug
                        ~~~
                        Modified SaveAcMiscInt to allow 0 Control codes to be written 
                        to customers.

EnterOLE.EXE & ENTFUNCS.XLA
b430.244 02/02/99  MH   Bug
                        ~~~
                        Applied Currency Conversion mods as dictated by EAL.

EnterOLE.EXE & ENTFUNCS.XLA
b430.243 29/01/99  MH   Mod
                        ~~~
                        Added functions to get/save the stock intrastat fields.

EnterOLE.EXE & ENTFUNCS.XLA
b430.242 26/01/99  MH   Mod
                        ~~~
                        Added Alternate Stock Codes functions to get and save data. 

EnterOLE.EXE & ENTFUNCS.XLA
v4.30    04/01/99  MH   Released                       

EnterOLE.EXE 
b430.241 24/12/98  MH   Recompiled for RP3

EnterOLE.EXE & ENTFUNCS.XLA
b430.240 22/12/98  MH   V4.30 Beta Release                       

EnterOLE.EXE & ENTFUNCS.XLA
b423.237 07/10/98  MH   Mod
                        ~~~
                        Changed the OLE Server to disable screen savers
                        whilst the main form is displayed.

EnterOLE.EXE
b423.236 05/10/98  MH   Bug (ger)
                        ~~~~~~~~~
                        Fixed a rounding bug in AddNomLines where it 
                        was checking for a total of zero: there wasn't
                        any rounding!!! Nice one, mark.

EnterOLE.EXE
b423.235 20/09/98  MH   Bugz
             -          ~~~~
         28/09/98       Fixed bugs in AddNomTransfer discovered whilst writing 
                        AddNomLines:

                          * Stopped From and To GL Codes allowing control codes
                            to be used.

                          * Stopped Job Code allowing Contracts to be specified.

                          * Improved Job/Anal validation so both have to be 
                            specified. Previously only 1 could be specified.
 
                        Mods
                        ~~~~
                        Added the AddNomLines function to allow arrays of details
                        to be used for adding multi-line (2+) nominal transfers.


EnterOLE.EXE & ENTFUNCS.XLA
b423.234 15/09/98  MH   Bugz
                        ~~~~
                        Modified the Company Objects to check the Company
                        directory for DEFMC044.SYS to identify Multi-Ccy
                        installations.

                        Modified AddNomTransfer to check the Multi-Ccy flag
                        when validating the currency, previously the Ccy   
                        had to be set to 1 for Single-Ccy systems which 
                        could cause problems. 

                        Also modified AddNomTransfer so that it didn't set
                        the CC/Dept fields on lines if CC/Depts were turned 
                        off.

                        Fixed GetCCDepRec as it was accidently returning
                        Cost Centre records for Departments if they shared
                        the same code and the CC Record was already loaded,
                        and vicey versah.

                        Removed GetJobString from the public functions list
                        in the XLA.

                        Modified ValidCCDept to allow blank strings, this 
                        had previously required the CC/Dept to always be set
                        to something even if not using CC/Dept's.

                        Changed GetCurrencyName to report 'Single Currency' 
                        for Ccy 0 and a currency error for >0 in Single-Ccy
                        Systems.

                        Modified the Currency Rate and Triangulation fields
                        to check for the Multi-Ccy flag and return a currency
                        error in Single-Ccy systems.


EnterOLE.EXE
b423.233 19/08/98  MH   Bugz
                        ~~~~
                        Modified SaveStockValue to stop the Cost Price being
                        saved to Bill Of Materials Headers. Also now updates
                        the 'Update Build Costs' flag when setting the Cost
                        Price.

                        When accessing the Cost/RO prices on the location it
                        shouldn't have been checking the Override Prices flag
                        on the Location Record.

EnterOLE.EXE
b423.232 11/08/98  MH   Mods
                        ~~~~
                        Updated security checking in OLE Server to reflect
                        the data being used. Was previously pretty random
                        as to which function checked what item.

EnterOLE.EXE & EntFuncs.XLA
b423.231 07/08/98  MH   Mods (Teminos)
                        ~~~~
                        Modified EntGLJobActual to have an Analysis Code
                        and Stock Code and to work by Period Range insteat
                        of date range.

                        Added entJCJobCustomer function to return the
                        Customer Code from the Job Record.

EnterOLE.EXE 
b423.230 30/07/98  MH   Bug!
                        ~~~~
                        GetCurrencyRate was giving a Divide By Zero for
                        Inverted currencies with a zero daily/company 
                        rate.

EnterOLE.EXE 
b423.229 22/07/98  MH   Mods
                        ~~~~
                        Modified EntCurrTriRate to return 1.0 instead
                        of 0.0.

                        Modified EntCompanyRate and EntDailyRate to
                        check the 1/x flag and to return 1.0 instead 
                        of 0.0.

EnterOLE.EXE & EntFuncs.XLA
b423.228 20/07/98  MH   Mods
                        ~~~~
                        Added EntCurrInvertRate, EntCurrFloatRate, 
                        EntCurrTriCurr, EntCurrTriRate functions to give 
                        access to the Currency Triangulation details added 
                        for Euro compliancy.

                        Bugs
                        ~~~~
                        Changed EntDailyRate and EntCompanyRate so they
                        report currency 30 as invalid, they previously
                        returned 0 as the rate.

EnterOLE.EXE & EntFuncs.XLA
b423.227 14/07/98  MH   Mods
                        ~~~~
                        Extended GetAcMiscStr and SaveAcMiscStr to
                        allow the retrieval and storage of Customer/
                        Supplier Delivery Addresses.

                        Added EntGLJobActual to report on the Job
                        Actuals with filtering on dates, CC, Dept,
                        Account, Location. Currency, GL Code.

EnterOLE.EXE 
b423.226 17/06/98  MH   Mod 
                        ~~~
                        Modified VarConst to check the ENTWREPL.INI
                        file for an offset directory in replication
                        systems.

EnterOLE.EXE & EntFuncs.XLA
b225     20/05/98  MH   Mods
            -           ~~~~
         27/05/98       Added Customer Telesales history functions and
                        updated the help context id's and descriptions.

EnterOLE.EXE & EntFuncs.XLA
b224   19/05/98  MH   Mods
                      ~~~~
                      Extended GetStockMiscVal in OLE Server to give
                      access to the stock/location quantity fields and
                      added EntStkQtyxxx functions into XLA.

EnterOLE.EXE & EntFuncs.XLA
b223   18/05/98  MH   Mods
                      ~~~~
                      Added descriptions and context Id's to new 
                      XLA functions.

                      Bugz
                      ~~~~
                      Fixed the bug with the GL functions and the
                      1xx periods (CTD for period/year) and balance
                      sheet GL's where it was including the previous
                      years YTD as well.

EnterOLE.EXE & EntFuncs.XLA
b222   12/05/98  MH   Mods
           -          ~~~~
       13/05/98       Added EntTxLateCcy to converts amounts from
                      one currency to another.

                      Mods for Lanworks, Geoff Roberts and Geoff Sharpe
                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      Added following functions for accessing and
                      storing the customer/supplier details:

                        GetAcMiscStr
                        GetAcMiscInt
                        GetAcMiscVal
                        SaveAcMiscStr
                        SaveAcMiscInt
                        SaveAcMiscVal 

                      These give 67 new EntCustxxx/EntSuppxxx functions
                      in the Excel Add-In for customers/supliers.


EnterOLE.EXE & EntFuncs.XLA
b221   08/05/98  MH   Mods
                      ~~~~
                      Added EntCustSalesPrice and EntSuppSalesPrice
                      functions to return the stock item sales/purch
                      price including any discounts due.

EnterOLE.EXE & EntFuncs.XLA
b220   06/05/98  MH   Mods
                      ~~~~
                      Added EntCustAgedBalance/EntSuppAgedBalance 
                      functions for Gloria which calculates the 
                      aged balances in the same way as the object
                      credit controller in Enterprise.



EnterOLE.EXE & EntFuncs.XLA
b219   05/05/98  MH   Mods
                      ~~~~
                      Added progress dialog into EntGLGetTxMovement
                      function.

EnterOLE.EXE & EntFuncs.XLA
b218   28/04/98  MH   Mods
           -           ~~~~
       01/05/98       Added EntGLGetTxMovement function for Tomkins.
 
                      Added Preferred Supplier and BarCode into 
                      GetStockString and SaveStockString functions


EnterOLE.EXE & ENTFUNCS.XLA
v4.23  30/03/98  MH   Bug
                      ~~~
                      Recompiled to pickup change of CustRec from 940
                      back to 939 bytes.   

EnterOLE.EXE & ENTFUNCS.XLA
v4.22  26/03/98  MH   Release Version
                      ~~~~~~~~~~~~~~~

XLA
b217   16/03/98  MH   Mods
                      ~~~~
                      Added routines for open/close XLA testing.

EnterOLE.EXE
b217   04/03/98  MH   Bug
                      ~~~
                      Modified SaveStockMiscVal to set the StkFlg
                      flag when updating the Stock Take Quantity. This
                      ommission meant that the changed value was ignored.

EnterOle.Exe & XLA
b216   09/12/97  MH   Mods
                      ====
                      Added the CTD Period offset into the history 
                      functions. Adding 100 to the period will 
                      activate it.

                      Modified the Job Costing functions to validate
                      the PostComm parameters as P or C.

                      Modified the Security Checking to be disabled
                      if the user has logged in with the Daily System
                      Password.
                      

EnterOle.Exe & XLA
v4.20a 27/08/97  MH   Mods
          -           ====
       08/09/97       Modified Period/Year on History Functions for
                      CTD and F6 Period/Year access.

                      Split XLA source code into several modules 
                      because Excel couldn't handle the size of the
                      code. This meant I also had to re-enter all
                      the descriptions and context id's again.
                      Microsoft making things easier! Not!!!!
                      
                      Added Job Budgets History functions to access
                      Total, Analysis and Stock History.

                      Modified the Stock Value functions to access
                      the stock take and freeze quantities on Stock
                      and stock location records.

                      Added functions to return Daily and Company Rates

v4.20  19/08/97  MH   Release Version
                      
b215   12/08/97  MH   Mods
                      ====
                      Added GetJobTotalStr and GetJobBudgetValue functions
                      for use with the Crystal U2L. Not added into Excel
                      XLA.

b214   08/07/97  MH   Mods
                      ====
                      Added a DocSign function which returns a constant
                      which can be used to sign document amounts.

b213   22/05/97  MH   Mods
                      ====
                      Added a EntDouble function to the XLA which calls
                      ConvertInts in the OLE Server. These are to support the 
                      ODBC facilities added in the ODBC Kit.

EnterOle.Exe & EntFuncs.XLA
b212   13/05/97  MH   Mods
                      ====
                      Linked new functions to help
 
EnterOle.Exe & EntFuncs.XLA
b210   28/04/97  MH   Modz
          -           ====
       01/05/97       Added Multi-Location Stock functions to XLA. Modified
                      GetStockValue, SaveStockValue, GetStockMiscInt,
                      SaveStockMiscInt, GetStockMiscVal, SaveStockMiscVal
                      to take a location code. Added GetLocationName to 
                      return the location name. Added GetCurrencyName to 
                      return the currency description from system setup.

EntFuncs.XLA
4.10c  25/04/97  MH   Bug/Mod
                      =======
                      Discovered I have to compile the Add-In without
                      any spreadsheets attached to the Add-In module.
                      Otherwise Excel97 tries to recalculate them.

EntFuncs.XLA
4.10b  18/04/97  MH   Bug/Mod
                      =======
                      Added a new 1st parameter to EntAddNomTransfer. It
                      is a string that must be set to yes in order to add
                      the nominal transfer. This is intended to stop excel 
                      adding a dozen from within the function wizard. When
                      the user wants to add the transfer they must manually
                      edit the cell.

EntFuncs.XLA
4.10a  15/04/97  MH   Bug
                      ===
                      EntAddNomTransfer wasn't validating the Cost Centre
                      and Department Codes.

EnterOle.Exe
       08/04/97  MH   Mod
                      ===
                      Added Help context Id to Server Form.

v4.10  19/03/97  MH   Initial Release

EnterOle.Exe
b204   12/03/97  MH   Bug
                      ===
                      Fixed bug in GLCC/GLDP functions which meant it was returning the 
                      GL figures, not the CC/DP figures. Was caused by system records not 
                      not being set, modified OpenCompany to set them.

EntFuncs.XLA
b204   04/03/97  MH   Bug
                      ===
                      Fixed bug that meant a space on the front of codes, meant an invalid
                      code message was displayed. Changed the Validxxxx functions to 
                      Trim spaces off.

EntFuncs.XLA
b203   13/02/97  MH   Bug
                      ===
                      Changed the error generation for double/long functions as it
                      was causing error dialogs to appear. All double/long functions
                      have been changed to variants so they can return an error
                      string.

b203   17/01/97  MH   Mods
                      ====
                      Changed the functions for enhanced error reporting in
                      Excel. All string functions now display a string detailing 
                      the error. All number functions will display #VALUE!.

                      Bugs
                      ====
                      Fixed bugs in SaveStockxxx functions where the key was
                      being build incorrectly causing it to update the first
                      stock item with the specified code matching. ie PROD1
                      would update PROD1A if PROD1 didn't exist.

b202   15/01/97- MH   Mods
       16/01/97       ====
                      Added Cost Centre & Department budgeting by modifying
                      parameters into GetNominalValue and SaveNominal Value.

                      Added GetCompanyName function to allow the company name
                      to be shown on spreadsheets.

                      Bugs
                      ====
                      Fixed bug in SaveNominalValue which would cause duplicate
                      lines to be added into the nominal codes history, becuase
                      it was setting up the NHIST record instead of the LNHIST
                      record.

                      Modified OLEStatU for GetCustStats and GetNomStats which
                      were using Syss instead of LSyss.

v4.10a 15/01/97  MH   Mods
                      ====
                      Modified the OLE server to give a display companies
                      option on the system menu. This causes a list of the
                      companies to be shown in the about list.

                      Hard coded Syss.TXLateCR on as it was causing Enter not
                      to Tab on the login screen, this made it look as 
                      though the user code was invalid.

v4.10  14/01/97       Initial Release of Multi-Company Manager


****************************************************************************)

End.

