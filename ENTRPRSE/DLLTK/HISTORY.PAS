(* Internal Modifications Documentation
   ====================================
Version & Date

TKDLL~705.300  08/07/2013
--------------------------------------------------------------------------------
CS: ABSEXCH-14438

    Updated branding and copyright (removed 'Iris' from messages)

TKDLL~70.299  05/03/2013
--------------------------------------------------------------------------------
CS: ABSEXCH-14003 - Added audit trail to EX_STORECURRENCY

TKDLL~70.295  13/11/2012
--------------------------------------------------------------------------------
CS: ABSEXCH-13585

    Corrected EX_UPDATEUPLIFT2() in Uplift.pas to call EX_GETLINESERIALNOS()
    with LineNo rather than AbsLineNo.

    Corrected Get_LineSerial() in DLLSrBOM.pas to prevent it returning error 9
    if it encounters the end of the file while building the list of serial
    numbers.

    Both of these were causing an error 1001 in the Advanced Freight Uplift
    plugin when trying to apply the uplift on an inserted (not added)
    transaction line.

TKDLL552.158  05/09/03
-----------------------------------------------------------
PR: Change: Added functions for multi-bins.

TKDLL551.157  8/07/03
-----------------------------------------------------------
PR: Change: Made lsQtyFreeze writable in EX_STORESTOCKLOC

TKDLL551.156  25/06/03
-----------------------------------------------------------
PR: Bugfix: Fixed problem with rounding on Noms with vat.
PR: Bugfix: Fixed problem with updating Noms with vat.
PR: Change: Added field to TBatchNomRec - Inactive : WordBool.

TKDLL551.155  20/06/03
-----------------------------------------------------------
PR: Change: TBatchEmplRec.CertType extended to accept '7' (4P) and '8' (5P)

TKDLL551.153  3/06/03
-----------------------------------------------------------
PR: Change: Added LabourPLOnly to TBatchEmplRec.

TKDLL551.151-2  2/06/03
-----------------------------------------------------------
PR: Change: Added handling for vat on noms.

TKDLL550.150  16/04/03
-----------------------------------------------------------
PR: Change: Allow WOR to be used for Ex_StoreSerialBatch & Ex_UseSerialBatch.

TKDLL550.149  11/04/03
-----------------------------------------------------------
PR: Change: Amended initialization routines so no error messages are shown.

TKDLL550.148  08/04/03
-----------------------------------------------------------
PR: BUGFIX: Change to Ex_StoreTrans to fix problem with inclusive vat and settlement discounts.

TKDLL550.146  27/03/03
-----------------------------------------------------------
PR: BUGFIX: Ex_StoreJobEmployee wasn't validating the Supplier code correctly.
PR: BUGFIX: Ex_StoreJobTimeRate wasn't validating an empty employee code correctly.

TKDLL550.145  10/03/03
-----------------------------------------------------------
PR: BUGFIX: Ex_StoreJobAnalysis wasn't checking that analysis category and type were a valid combination.
PR: BUGFIX: Ex_StoreJobTimeRate wasn't checking that analysis category was a valid type for time rates.


TKDLL550.144  10/03/03
-----------------------------------------------------------
PR: Added No_Trans_To_Closed_Jobs switch to ExchDll.ini to prevent transactions being
    imported to closed jobs.

TKDLL550.143  09/03/03
-----------------------------------------------------------
PR: Ensured that Ex_StoreJobAnalysis, Ex_StoreJobTimeRate, Ex_StoreJobType were setting code fields to UpperCase.

TKDLL550.141  21/02/03
-----------------------------------------------------------
PR: Change to EX_STORESTKALT to allow altcodes to be added for customers as well as suppliers

TKDLL550.140  20/02/03
-----------------------------------------------------------
PR: Change to Ex_UseSerialBatch to allow ADJs to be used as docs.

TKDLL550.139  12/02/03
-----------------------------------------------------------
PR: Fix to Ex_StoreTrans which still wasn't calculating the cost of Boms correctly using average.

TKDLL550.138  10/02/03
-----------------------------------------------------------
PR: Fix to Ex_StoreTrans which wasn't calculating the cost of Boms correctly using average.

TKDLL550.137  30/01/03
-----------------------------------------------------------
PR: Fix to Ex_StoreTrans which wasn't calculating the cost of Boms correctly using average.

TKDLL500.135  10/12/02
-----------------------------------------------------------
PR: Change to Ex_StoreTrans to ensure that edited delivery notes can be invoiced correctly
PR: Added Ex_StoreJobTimeRate function
PR: Added Ex_StoreJobType function
PR: Added Ex_StoreJobAnalysis function
PR: Added Ex_StoreEmployee function.
PR: Added extra fields to TBatchEmplRec: SelfBill, GroupCert, CertType, UserDef3, UserDef4.

TKDLL500.133  19/11/02
-----------------------------------------------------------
PR: Fix to Ex_GetTrans which wasn't returning the correct line qty for split pack lines.

TKDLL500.130  15/11/02
-----------------------------------------------------------
PR: Fixed bug in Ex_GetNotes where lock was not released if error 30002 returned.

TKDLL500.129  13/11/02
-----------------------------------------------------------
HM: Modified Discount rounding in Ex_StoreTrans so % discounts are rounded to 4dp allowing
    discounts of 1.25%

TKDLL500.128  12/11/02
-----------------------------------------------------------
PR: Fix to EX_CALCSTOCKPRICE to ensure split pack price is calculated correctly when
    'Show stock levels as Sales Units (packs)' is not checked on stock record.
PR: Change to EX_STORETRANS: Discount field on transaction line is rounded to 2 decimal
    places to correspond with Enterprise.
PR: Added DeductBOMComponents field to TBatchSysRec.
PR: Amended EX_STORESERIALBATCH to allow SCRs as InDoc

TKDLL500.127  08/11/02
-----------------------------------------------------------
HM: Discussed Ex_UpdatePayInRef with Eduardo and restored check for Posted Transactions as
    it will screw up one of the Bank Rec reports.  The check can be removed again if people
    do complain.

TKDLL500.126  07/11/02
-----------------------------------------------------------
HM: Made changes to User Count Security in InitDLLMain to increase robustness.

TKDLL500.125  17/10/02
-----------------------------------------------------------
PR: Change to EX_CALCSTOCKPRICE which under some circumstances was taking price from stock record when it
    should be from location record.
PR: Added WOR fields lsQtyAllocWOR, lsQtyIssueWOR, lsQtyPickWOR (read-only), and
    lsWOPWIPGL (read/write) to TBatchSLRec.
PR: Change to Ex_UpdatePayInRef to allow SRIs as well as SRCs and to remove check for posted trans.

TKDLL500.124  16/10/02
-----------------------------------------------------------
PR: Fix to Ex_UnuseSerialBatch which wasn't updating transaction line serial qty.

TKDLL500.123  04/10/02
-----------------------------------------------------------
PR: Fix to EX_STORETRANS to ensure that ADJs with BOMs where KitLink = 1 create
    lines on NOMs when posted

TKDLL500.121  31/08/02
-----------------------------------------------------------
PR: Added IncNetValue to TBatchTLRec to store original values when vat is inclusive (Read Only)
PR: Changed Ex_StoreTrans so that can't pick lines on transaction on credit hold.
PR: Changed Ex_StoreTrans so that StockCode, Location & VAT can't be set on Nominal transactions.
PR: Ex_TranCanBeUpdated wasn't checking transaction type correctly.

TKDLL500.120  14/08/02
-----------------------------------------------------------
PR:  Added Ex_UnuseSerialBatch function.

TKDLL500.119  11/08/02
-----------------------------------------------------------
PR: Added QtyPickWOR field to TBatchSKRec (Read Only).  Indicates Qty issued now, but not processed.

TKDLL500.118  08/08/02
-----------------------------------------------------------
PR: Fix to EX_STORESTKALT. In some circumstances a record was stored even if
it had an invalid stock code.

PR: Fix to Ex_StoreTrans: When Deduct_BOM_Stock was set, lines weren't getting
description, cost or GL.

TKDLL500.117  07/08/02
-----------------------------------------------------------
PR: Fix to Ex_StoreTrans for Split Packs.

TKDLL500.116  31/07/02
-----------------------------------------------------------
PR: Added ShowAsKit field to TBatchSKRec.  Indicates exploded BOM on sales.

TKDLL500.115  24/07/02
-----------------------------------------------------------
PR: Added TimeChange and TimeCreate fields to TBatchTHRec.  These are read-only
and are set automatically by the toolkit when saving a transaction.

TKDLL500.114  23/07/02
-----------------------------------------------------------
PR: Fix to Ex_StoreTrans for Split Packs.

TKDLL500.113  17/07/02
-----------------------------------------------------------
PR: Added EX_UPDATELINEDATE to allow line dates to be changed regardless of
status of transaction.  Requested by 5 Star for Metro Imaging.

PR: Fix to Ex_StoreTrans. When adding BOMs and deducting components from stock,
line descriptions, gl codes and costs weren't added properly.

TKDLL500.112  04/07/02
-----------------------------------------------------------
PR: Fix to Ex_StoreGLAccount as it wasn't storing some transactions.


TKDLL500.111  28/06/02
-----------------------------------------------------------
HM: Emergency mods to Ex_StoreTrans as it was automatically removing all
    CC/Dept Codes from lines on non-ADJ/NOM transactions, and wasn't
    validating the CC/Dept Codes anyway.

TKDLL500.110 11/06/2002
-----------------------------------------------------------
PR: Amended EX_STORESTOCKLOC so that lsStkFlag is set if StockTake Qty has been changed

TKDLL500.109 07/06/2002

PR: Amended Ex_StoreTrans to deal correctly (I hope) with split packs.


TKDLL500.108 28/05/2002
-----------------------------------------------------------
HM: Rebuilt to pick up internal changes to the job costing routines by Eduardo.


TKDLL500.107 08/05/2002
-----------------------------------------------------------
PR: Amended EX_STORETRANS so that CCs & Departments can be saved for zero cost & total lines

PR: Added TBatchLinkRec structure and functions EX_GETLINK, EX_STORELINK, EX_DELETELINk

PR: Modified EX_STOREDISCMATRIX to allow discounts to be stored for groups


TKDLL500.106 05/04/02 - Enterprise v5.00 Release
------------------------------------------------
HM: Major rewrite to remove ShareMem (BorldnMM.Dll) from the uses clause as the
    Delphi 6.0 version of ShareMem was causing VB to crash when exiting apps.

    The Toolkit DLL now uses SBSFORM2.DLL for printing - this is a modified version
    of SBSFORM.DLL which has a different interface allowing it to be used without
    ShareMem.

    The Security subsystem is now using EntComp2.Dll for Security as this doesn't
    use ShareMem.

TKDLL500.104  02/04/02
----------------------
PR: Added EX_UPDATEPAYINREF function to allow PayInRef field on SRCs to be edited.

HM: Added DefTagNo : SmallInt to TBatchCURec to store the Default Tag Number, also
    added error 30016 to Ex_StoreAccount for its validation.


TKDLL500.103
--------------------------------------------------
PR: Added EX_STORECURRENCY function.  Currently allows DailyRate to be changed;
    Results are
      0         OK
      3         Database not open
      84        Record locked
      30001     Invalid currency number
      30002     Daily Rate must be > 0
      30003     Unable to find currency record
      32766     Incorrect record size
      32767     Record not intialised

PR: Modified EX_STOREGLACCOUNT so that it is no longer possible to change the gltype

PR: Modified EX_STORESTOCK so that it is no longer possible to change the StockType


TKDLL500.102
--------------------------------------------------
NF: New Function added EX_GETCOMPANYID. This is for the Trade Counter Security
    To get the Company ID needed to call the Security Object. This is supposed
    to be an undocumented Function.

PR: Modified Ex_GetDiscMatrix so that it will only return Discount Records -
    previously it wasn't checking.

PR: Modified Ex_StoreSerialBatch and Ex_UseSerialBatch to correctly
    validate the Serial Number's uniqueness within the stock item -
    they previously was detecting matching SNo's for other stock codes.

PR: Modified Ex_GetTrans to correctly initialise the transaction lines
    - rogue characters were being detected in VB after the end of strings

PR: Modified Ex_StoreTrans so that the Stock Code was padded to 16 chars
    before validation for lines being delivered - previously one was
    trimmed and the other wasn't resulting in validation errors for stock
    codes of less than 16 chars.

PR: Added validation for WOP transaction lines.  Added errors
      30123 - Line 1 of WOP transaction - not a BOM
      30124 - Line 1 of WOP transaction - qty is 0
      30125 - Gl on transaction line is not correct for the stock item/location


PR: Added validation for WOP transaction headers.  Added Errors
      30219 - invalid MLoc code in header.

PR: Modified transaction line validation to validate reconcile field - in
    transactions posted to GL must be between 0 & 3 else set to 0. Except
    timesheets which were already validated.

HM:  Modified the rounding of the line total validation to fix
     the error 30109's being experienced in NZ.  This mod was
     done in TKDLL4.32/436.060.



TKDLL500.101 26/11/01 - Developer Showcase Release
--------------------------------------------------

NOTE: Forced to remove new security because of problems in COMTK.

HM:  Changed Ex_StoreDiscMatrix to allow currency=0

HM:  Changed TBatchTHRec.Tagged to SmallInt from WordBool to support the new
     Tag No's

HM:  Added error 30218 into Ex_StoreTrans - Invalid Tagged field - must be in
     range 0..99

HM:  Modified Ex_InitDLL to check the user count security, the following errors
     were added:-

       32763   Unknown error checking User Count Security - Check Last Error String
       32764   User Count Exceeded
       32765   Logged in User Counts corrupted (run Logged In users Report to fix)
       32766   Failed to load User Count Security Functions

HM:  Added instance locking to prevent one instance being used by multiple apps,
     this is likely to happen with Delphi DLL Customisation as they would all
     share the same instance of the Toolkit DLL:-

       32762   This instance of the Toolkit is already in use

HM:  Added checking that the Company Data Set is one that is in the active MCM,
     otherwise that allows the security to be worked around:-

       32761   This Company Data Set is not part of the active Enterprise Installation

HM:  Added EX_GETUSERPROFILE function and TUserProfileType to retrieve the Ent5.00
     user profile information.


TKDLL4.32/436.056 - 07/09/01
----------------------------
HM: Modified how Ex_UseSerialBatch was identifying the selected records
    as it wasn't checking locations, BatchChild, Qty Free, etc...
    In sites with duplicate Batch Numbers it could use the wrong Batch
    Record.

TKDLL4.32/436.055 - 31/08/01
----------------------------
NF: Plugged memory leak, due to no disposes on 2 variables.


TKDLL4.32/436.054 - 13/08/01
----------------------------
HM: Extended Ex_StoreTrans to automatically pad the Job Code and Analysis Code to
    10 characters as this was preventing NOM's from being posted from the Job
    Daybook.

HM: Fixed Ex_StoreTrans so the Line Type Totals are zeroed before each calculation,
    the routine to calculate them was called twice - causing the totals to be
    doubled.  I think this was caused during the v4.31 mods for trans editing.

HM: Modified the reading of the Default CC/Dept's from ExchDll.Ini so that
    they are padded to 3 characters, this was causing problems in the Windows
    Import Module with 2 character codes as Ex_StoreTrans obviously isn't
    reformatting the CC/Depts correctly before validating them!

TKDLL4.32/436.053 - 02/08/01
----------------------------
HM: Modified Ex_StoreTrans to explicitly save and restore the cost price on
    sales transactions if the Auto_Set_Stock_Cost is set to OFF.  This only
    happens for Standard, Last Cost and Serial valuation methods.

    Previously if the specified cost was zero it was being set to the
    correct cost automatically.


TKDLL4.32/436.052 (Released with Enterprise v4.32.001)
------------------------------------------------------
HM: Modified Ex_EntDateToPeriod to calculate the Period/Year in the same way
   as Enterprise - wasn't working the same if > 12 periods per year.

HM: Published the extended transaction editing ability from .045U and .047U


TKDLL4.32/436.051 (Minerva Software)
------------------------------------
HM - Bug FIX: Extended the ShowCase mod in .050 to apply to all trans types.


TKDLL4.32/436.050 (Minerva Software)
------------------------------------
HM - Bug FIX: Modified Ex_StoreTrans to set ShowCase for ADJ transactions, was
     causing the stock qty to be changed in Enterprise when editing lines.


TKDLL4.32/436.049 (InfoSpeed)
-----------------------------
HM -  Bug Fix: Modified Ex_StoreTrans to calculate the trans Period and Year in
      the same way as Enterprise.


TKDLL4.32/436.048
---------------------------------------------------------

NF -    In Ex_StoreTrans / Function ValidateEachTL. Changed TrueReal to Round_Up
        because TrueReal was rounding 18.525 to 18.52, not 18.53
        P.S. this was done after consulting with HM !


HM - 21/06/01 - Fixed the error functions as they didn't support either
     Ex_GetDiscMatrix or Ex_StoreDiscMatrix.



TKDLL4.32/436.047U - Development version for Mario Mifsud
---------------------------------------------------------

HM - Extended Ex_StoreTrans to delete trans lines for PCR,PQU,
     SQU,SCR,PJI,PJC,SJI,SJC transactions if the UPD2 compiler
     directive is specified.

     IFDEF'd out the validation on the Account Code to allow
     updates to change the account code.

     Passed onto Mario - Malta for serious testing


TKDLL4.32/436.046
-----------------
HM - Mods to UpdateExBal in BTS1 to bring it in sync with UpdateBal in SYSU1

HM - Changed Ex_CalcStockPrice and underlying functions to implement Locations,
     previously the price lookup had ignored any overridden prices at locations.


TKDLL4.32/436.045U - Development version for Mario Mifsud
---------------------------------------------------------

HM - Extended Ex_StoreTrans to support PCR,PQU,SQU,SCR,PJI,PJC,SJI,SJC if the
     UPD2 compiler directive is specified.

     Passed onto Mario - Malta for serious testing

HM - Ex_StoreTrans also left a record lock hanging on transaction lines being
     changed because B_UPDATE doesn't release multiple-record locks.


TKDLL4.31/436.044 - Ongoing
------------------------------

HM - Extended customer record to support Paperless's EDZ format attachments


TKDLL4.31/436.043 - 26.03.2001
------------------------------

SM - In Ex_GetAccountBalance, added SerachMode 7 for Budget OLE value request by Mark.


TKDLL4.31/436.042 - 15.03.2001
------------------------------
- Neil - New fields added to TBatchSysRec :
  UseCrLimitChk, UseCreditChk, StopBadDr, UsePick4All, FreeExAll & WksODue.

- Neil - Changed project source so that it picks up the names of the modules in the list and in find.

- Mark - Modified Ex_GetStockBOM and Ex_StoreStockBOM to support variable size arrays, with a
         maximum size of 5,000 items.


TKDLL4.31/436.041 - 15.03.2001
------------------------------
- Mark - Modified Ex_CalcStockPrice to initialise local variables, as it was
  causing the Line discount character to be returned as chr(1), which is invalid!

- Mark - Modified Ex_GetStockBOM as it was retunring a range check error if there
  were more than 500 Bill Of Materials items.

TKDLL4.31/436.040 - 09.03.2001
------------------------------
- Neil - New function EX_REMOVEDISCOUNTS has been added. This will return an
  unrounded netprice (it doesn't work at the moment !).

TKDLL4.31/436.039 - 08.03.2001
------------------------------
- Returning Range check error from Ex_storeNotes has been fixed.

TKDLL4.31/436.038 - 07.03.2001
------------------------------
- Calculating Charge Amount for NZ - for some reasons, the customer record
  was not the same as Job record's customer code. Modified to search the record
  before calculating.


TKDLL4.31/436.037 - 06.03.2001
------------------------------
- Mark - Changed the component unit cost calculation in Ex_StoreStockBOM as it
  was setting the unit cost to the total cost, NOT the unit cost, and also
  incorrectly rounding it to Sales decimals when it should be Cost decimals.

- Mark - Modified Ex_StoreTrans when running in eBusiness mode NOT to zero the
  Header and Line Company Rates, as this was causing problems posting lines into
  Enterprise from the eBusiness Module.

- Neil - New Function added EX_CHECKMODULERELEASECODE to check to see if a module
  has been released.


TKDLL4.31/436.036 - 26.02.2001
------------------------------
- Allow to search Serial/Batch records by Stock Code in Ex_getSerialBatch function.
  - Stock Code field has to be assigned in the record structure
  - Serial No and Batch no fields must be blank
  - Ex_getGEq should be used to search for the first record and Ex_GetNext
    can be used to search the next record
  - The developer has to check the required Stock Code and returned stock code


TKDLL4.31/436.035 - 19.02.2001
------------------------------
- PayFactor and PayRate fields have been added in the TBatchJobRateRec.
  The record size remains the same.


TKDLL4.31/436.034 - 14.02.2001
------------------------------

- To update the Charge Amount value in the Job Actual record has been added.
  And also added the condition to assign the Cost Price of Stock in the ADJ record.
  (requested by NZ)

- Little Neil - Ex_GetTaxWord - new function to get the description of Tax
  (this will normally return 'VAT').

- Mark - Ex_GetAccountBalance - Modified the Committed call as it was corrupting
  the Net Sales figures.

- Mark - Modified Ex_InitDLL to call ex_CloseData instead of Ex_CloseDLL when
  the release code check fails, as when used in a hook it was resetting
  Enterprise's btrieve files as well.


TKDLL4.31/436.033 - 06.12.2000
------------------------------

- Ex_StoreNotes has been modified to allow Updating Notes, requested by Little Neil
  (NF: I'm not that little !)
  (HM: You are compared to either Simon!).


TKDLL4.31/436.032 - 04.12.2000
------------------------------

- Mark - Modified the Btrieve usage in Ex_GetLocation as the STEP operations
  weren't working properly and this was highlighted by the .031 mods.

TKDLL4.31/436.031 - 30.11.2000
------------------------------

- If TL is Payment line and SRC,SRI,PPI,PPY, then VATCode is set as #0.
  ( Reported by Cooper Parry - VAT History was incorrect )

- Mark - Modified Ex_GetLocation so that it fails as soon as it finishes
  retrieving location records, instead of running to the end of file.

- Allows to Update transaction if status is "Printed".
  Requested by Sam Smith and Jolyon.


TKDLL4.31/436.030 - 15.11.2000
------------------------------
- Ex_UpdateDueDate function has been added.


TKDLL4.31/436.029 - 03.11.2000
------------------------------

- Mark has added Ex_GetEntData function.
- Added DoNotUpdateTL field in TBatchSerialRec and
  CalPrFromDate in TBatchSysRec.
- In StoreSerialBatch function, added updating trans. line's Serial Qty value,
  requested by Tony of ISN.

TKDLL4.31/436.028 - 24.10.2000
------------------------------

- "IsEBusTran" has been added in VarConst : not to update Account/Stock when
  using Ex_StoreTrans for EBusiness transaction.

- Added checking condition before updating Account balance and Stock deduction
  in DLLTH_UP. (Need to confirm with EL for CXRate[Off]=0 problem but compiled
  as this version for NF )

- CS_ChangeDocTxLate function has been added for NF to use for Card System.


TKDLL4.31/436.027 - 11.10.2000  { Released version }
------------------------------
( This is the released version for developers day. Ex_StoreEBusTrans function
  has been deleted from HELP file for it has to be modified not to update
  accounts and stock ...)

- Added function Ex_GetStockByFolio
- The new field, PriceByStkUnit has been added in TBatchSKRec and the
  error code is 30296.
- In Ex_StoreSerialBatch unction, POR has been allowed as an out document,
  requested by Tony of ISN and approved by EL.

- Ex_LastErrorDesc function has been added to return the error description of the
  last function's error code.

- Added NoteFor and RepeatDays in TBatchNotesRec. Error code 30007 for "NoteFor" field.


TKDLL4.31/436.026 - 09.10.2000
------------------------------
- Allow ROCurrency and ROCPrice to be updated on the stock record
- Added OrderAllocStock to TBatchSysRec
- Error code 30217 has been added for E-Bus trans Doc Type validation.
  Though this is only applicable to the Windows Import, I preferred to use the new
  error code for easy maintenance.
- In Ex_GetStock, Stock Code has been padded to 16 before searching the record,
  otherwise it does not return the record if B_GetEq is used.

TKDLL4.31/436.025 - 29.09.2000
------------------------------

- In Trans validation, if Job Code and AnalCode are valid, assign appropriate NomCode
  depending on the Job Status.

- If stock code field is used for PayInRef, Multi-Location code should not validated.
  It has been added in MlocStk of TL validation.

- Added Ex_StoreEBusTran

- Need to add the following in the HELP.
  Header Total Cost calculation has been added.
  If stock valuation type is FIFO or Serial, "AutoSetStockCost" switch would be ignored.
  For other stock valuation types, if the switch is ON and line cost is Zero,
  the stock's cost price would be assigned in TL.
  Based on above criteria, Header Total Cost would be calculated by the DLL.

- Header Total Weight is also calculated by the DLL.

- New field SOPConsHO has been added in TBatchCURec.
  Record size remains the same.


TKDLL4.31/436.024 - 21.09.2000
------------------------------
- EX_CALCLINETAX added.
- EX_GETCORRECTVATCODE added.
- 13.09.2000 ( DLL version no. has not been changed )
  TotalCost and TotalWeight fields would be calculated and assigned
  IF ONLY the records are imported via Windows Import. (by EL's advice)


TKDLL4.31/436.023 - 12.09.2000
------------------------------

- Added ComitVal field in THistoryBalRec for Committed Amount
  to be returned from Ex_GetAccountBal function.
- The new function Ex_CalculateTransTotal has been added to retrieve the
  total value inclusive or exclusive of VAriance.
- In Ex_StoreStock, added to change Syss.NeedBMUp if the stock cost price or
  cost price currency has been changed.


TKDLL4.31/436.022 - 05.09.2000
------------------------------
Ex_StoreTrans - added the condition in error 30102, invalid Line VAT rate.

TKDLL4.31/436.021 - 05.09.2000
------------------------------
- If Ex_StoreTrans is used with B_Update, SerialQty should be assigned from the
  original Id record. (Need to send this version to Tony of ISN-SimplyBusiness).

TKDLL4.31/436.020 - 29.08.2000
------------------------------
- DLLMiscU.Pas has been added and Misc. functions have been moved from other units
  to DLLMiscU unit.
- MLocStk (Location Code) in TL record has been padded if it is not blank.

TKDLL4.31/436.019 - 18.07.2000
------------------------------
- Allow SOR type in Ex_UseSerialBatch function requested by Simply Business.

TKDLL4.31/436.018 - 07.07.2000
------------------------------
- Fixed PayInRef problem for QBS : For payment group items/transactions
  with Part Cleared status could not be changed the status (clear/unclear)


TKDLL4.31/436.017 - 04.07.2000
------------------------------
- ShowDate in Ex_StoreNotes has been added.
- Fixed for not deducting MLoc stock.

TKDLL4.31/436.016 - 23.06.2000
------------------------------
- Set the new field COSConvRate as follow if the Id is the new line.
  COSConvRate:=SyssCurr^.Currencies[Currency].CRates[UseCoDayRate];
- The new function Ex_FileSize has been added in DLL01U.
- JobCode and AnalCode for TSH have been set using FullJobCode() for not posting
  TSH from Job Pre-Posting.

TKDLL4.31/436.015 - 22.06.2000
------------------------------
- Fixed for incorrect account balance if transactions are imported via windows import.

TKDLL4.31/436.015 - 20.06.2000
------------------------------
- Added TECommsSysRec and function Ex_GetECommsData
- Modified TBatchSysRec to include all the user defined field names and 'hide' flags
- Ex_Conv_Tcurr function has been added for internal use only, for Uplift Hook.

TKDLL4.31/436.014 - 12.06.2000
------------------------------
- SOPKeepRate added to TBatchTHRec

TKDLL4.31/436.013 - 09.06.2000
------------------------------
- Account names were being copied to 30 chars (AccNamLen changed from 30 to 45)
- New function : Ex_Security Check
- MultiLocation = on, Stock record with blank default, read and then update
  returned Error 30291.  Modified validation.
- Added StkLinkLT to Stock record structure

TKDLL4.31/436.012 - 26.05.2000
------------------------------
- Error codes 30011 and 30012 were round the wrong way on Ex_StoreAccount
- Ex_StoreNotes and Ex_GetNotes now handle job costing notes
- Amended record locking generally. Toolkit uses wait locks so if a record is locked
  it shows the "record locked dialog".  User can either "Retry" or "Cancel".  If you
  click the latter the function returns true, but the locked parameter is set to false.
  This is then mapped as a status 84.

TKDLL4.31/436.011 - 23.05.2000
------------------------------
- Added SSDCountry to stock and transaction line records
- Allow currency 0 when adding a GL code


TKDLL4.31/436.010 - 12.05.2000
------------------------------
- TransRefNo being set from Inv.OurRef, should be Id.DocPRef


TKDLL4.31/436.009 - 19.04.2000 (Released version)
------------------------------
The version number has been confirmed by EL.
TKDLL4.31 = Enterprise Version Number
436.009   = DLL Version Number

- External Document status is now allowed to be edited.

- Error Code 30700 and 30701 have been added. These are considered as Warning
  message. In Ex_StoreTrans for updating.
  30700 = The line has the SOP link, cannot be deleted.
  30701 = The line has the delivered quantiry, cannot be deleted.

b436.008 - 13/04/00
-------------------

- Error code 30121 has been added in Ex_StoreTrans for NOM transaction.
- Stock code validation in Ex_StoreTrans has been moved before calculating
  Totals and CC/Dept validation, otherwise Cost Price=0 if AutoSetStockCost is ON.
- Added FinYearStart to TBatchSysRec
- Ex_StoreTrans - External Transaction Status has been modified for updating.
- SRC and PPY have been removed from DueDate validation for Due Date is mandatory
  field for SRC and PPY.
- AllocStat added to TBatchTHRec structure


b436.007 - 10/04/00
-------------------
- Added Ex_StoreTransDetl - allows 4 user defined fields on the transaction line to be
  updated
- Ex_StoreTransHed added other 2 user defined fields
- Added Get_ReadIniValue, Get_UnlockRecord, Get_StoreTransHedOrDetl, Ex_OverrideIni,
  Ex_GetJobType to DllErrU
- Ex_StoreTrans no longer validates multi-location fields for time sheets

- Customer Stock Analysis updating has been added for Ex_StoreTrans. The module
  release code either 5 or 6 has to be valid for this updating, but no error
  message.
- Added validation for the last 6 digits of OurRef that must be numeric.

b436.006 - 27/03/00
-------------------
- Ex_GetJob was locking NomF and not JobF - fixed
- Add Ex_UnlockRecord to unlock a generic record - pass in file number and position
- Fixed Ex_GetRecWithAddress to map indexes on transaction header / detail files
  (Toolkit uses different numbers to those actually in code)

b436.006 - 27/03/00
-------------------
- Modified Toolkiit for WordBool problem where D5 WordBool True = -1 and D2
  WordBool True = 1. This caused major problems in VB Apps. Redefing WordBool
  as SmallInt and changed code accordingly.

  NOTE: Always check the False value (0), not the True value which can be any
  non-zero value.   

b436.005 - 16/03/2000
---------------------
- ABSLineNo has been moved before LineNo is assigned as ReceiptCode
  to fix for not displaying correct Desc. in Job DayBook.
- ebusPwrd now properly encrypted on writing and decrypted on reading
- UnitK, UnitS, UnitP extended to 10 characters each from 7

b436.004 - 28/02/2000
---------------------
Stock record's Job anal.Code validation has been added.

b436.003 - 17/02/2000
---------------------
Mainly for Edit Trans. in Ex_StoreTrans (Continuous Improvement)
Changed E-mail field TBatchCURec now string 100
Altered Spare to 131 for word alignment

b436.002 - 04/02/2000 (v4.31 Release Candidate 1)
---------------------
The Toolkit has been extensively re-organised internally to reduce its
memory footprint.

Added Ex_GetTLArray and Ex_GetTLArrayLine to allow Transaction Line
Arrays to be used for reading transactions in Visual Basic.

04/02/2000 - EX_READINIVALUE added to InitDLLU

b436.001 - 27/01/2000 (Beta Released)
-------------------------------------

Edit Trans. has been allowed in this version.

These two functions were not added in the Help file.
24/01/2000 - Ex_TranCanBeUpdated has been added in DllTH01U
           - TempBLoc field has been added in Stock Record.
             (internal update field)
13/01/2000 - Ex_OverrideINI added to InitDLLU

21/12/99

- TH VAT Analysis has been changed to 21.
- VAT Code validation has been modified as follows :
      - For Customer, Supplier, Stock and Job Header, 24 valid codes
        (exclusive of "M") S E Z 1..9 A D T X I B C F G R W Y
      - For TH VAT Analysis, exclusive of A D M I, hence,
        S E Z 1..9 T X B C F G R W Y
      - For TL, exclusive of "I", S E Z 1..9 A D T X M B C F G R W Y

- Added VATIncFlg and QtyPick (ReadOnly) in TL Record & validation.

10/12/99 - Added 2 User Defined Fields in TBatchJHRec for NZ.

08/12/99
--------
- Ex_GetVATRate now returns the description of the VAT rate
- TBatchVATRec record structure changed to include VATDesc and VATSpare

24/11/99
--------
- Added WebPrevCat to Stock record code
- Added WebLiveCat & WebPrevCat to Customer record code


4.36 - 10/11/99
---------------
- Released version with Enterprise 4.31.
- Record structures have been changed, Cust/Supp, Stock, GL, TH & TL,
  System (for Currency).
- Check password has been modified for encryption.
- Trans. line - check currency against Nominal's default currency.



b435c.025 - 20/10/99
--------------------
- Updating Hold status has been modified in Ex_StoreTransHed function.
  To send Fern Computer
- Tagged field has been allowed to update in header record + in Ex_StoreTransHed.

b435c.024 - 14/10/99
--------------------
- To solve SRI rounding problem for NZ, change Round() to Round_Up() for Payment
  line total.

b435c.023 - 11/10/99  (Thanks for your help!)
--------------------
HM - Added EX_SETCALCLINECOUNT to provide a cutout facility for
     GetActualLineCount as performance hit of counting lines was too bad in
     certain circumstances. System defaults to counting.

b435c.022 - 07.10.99
--------------------
HM - Modified GetActualLineCount, added in b435c.018, to save and restore the
     record position in the Details Lines file, previously it was leaving the
     Detail File in Index 0 at the end of the transactions lines. This caused
     error 7's and records to be missed in developers existing systems.

b435c.021 - 30.09.99
--------------------
- Header's Total line count := LineCount + 2
  Otherwise, ABSLineNo is duplicated when lines are added or inserted.


b435c.020 - 24.09.99
--------------------
- To allow zero in Hold Status field.

b435c.019 - 23.09.99
--------------------
- For SOR, POR - (Total Order Outstanding = InvNetVAl - DiscAmount)  

b435c.018 - 22.09.99
--------------------
- Header record's TLineCount (Total no. of transaction lines) has been modified to return
  actual total no. of lines in Ex_GetTrans, Ex_GetTransHed and Ex_GetTotalTransLines.
- Ex_GetTrans, not returning Stock Code for ADJ record has been fixed.
- In Ex_UseSerialBatch, added error codes :-
     30019 - UsedQty must be <> 0
     30020 - Unable to update Line's Serial Quantity

b435c.017 - 21.09.99
--------------------
- Jim added routine Ex_GetLineTotal
- Ex_StoreAutoBank has been modified for not updating Total correctly.
- Added if TSH, total Qty = Inv.TotalInvoiced.
- AcYr & AcPr validation has been enhanced.

b435c.016 - 02.09.99
--------------------
- Jim -> added new fields to TBatchSysRec
  UserVatReg, PeriodsPerYr, CCDepts, IntraStat, ExchangeRate
- Jim -> fixed size of spare on TBatchAutoBankRec
- Jim -> added new fields to TBatchEmplRec CC, Dep
- Ex_StoreMatch function has been modified to set AllocStat and UntilDate fileds.
- If SOR/POR, Total OutStanding field is assigned as InvNetValue to display
  on Ledger Daybook.
    

b435c.015 - 25.08.99
--------------------
- New fields have been added in the Bank Record.
- EX_STOREAUTOBANK has been modified to add Bank Code and Sort code to be validated
  if assigned.


b435c.014 - 19.08.99
--------------------
- "Default_VAT_Code" has been added in the INI file for KEVIN HORLOCK's Request.
- Using Default VAT Code and Currency have been added in Transaction.


b435c.013 - 18.08.99
--------------------
- If TSH record, Inv.BatchLink = FullCustcode(EmployeeCode), otherwise,
  Enterprise posting returns ERangeCheck error.


b435c.012 - 12.08.99
--------------------
- NZ reported that line description should not be overwritten if it has data.
- Ex_StoreEachBOMLine's Btrieve error message has been modified.
 

b435c.011 - 28.07.99
--------------------

- Added MultiLocn to TBatchSysRec returnded by Ex_GetSysData (Jim).
- POR updates InStockQty as (-) for multi-location stock which has been fixed and
  sent to NZ.

b435c.010 - 15.07.99
--------------------
Sent to New Zealand for Average Cost and BOM deduction.

- 14.07.99
  EL confirmed that DLL should update only for BOM with "Kitting Disabled".
  TL's KitLink field should be set to 1 for the following conditions:-
  (1). ADJ with Build status
  (2). BOM is "Sales & Pur. Explode" and Stock Folio is set in the kit lines
  (3). If there is no stock code, description lines only and have more than one
       description line, the first line's Folio Number should be assigned in the
       KitLink of other lines.

  (2) and (3) have not been implemented in the DLL yet.
  Therefore, Kitlink should be set to Zero except ADJ with Build status.

- Main changes are for not deducting BOM components correctly.
  Changes made in Stock_Deduct, Gen_StockDeduct and Store_EId.
  All chages are with date 09/07/99.

- Modified all FIFO functions in FIFOLU.PAS to be the same as shared
  R&D\FIFOL2U.Pas.

b435c.009 - 14.07.99
--------------------
- PayInRef field validation has been modified.


b435c.008 - 07.07.99
--------------------
- If "/AUTO" is assigned in DueDate field of TH record,
  DueDate is calculated as TransDate+Customer's PaymentTerms.
- Not deducting stock for Purchase Transactions has been modified.
- Mark has modified Form functions.
- Added PriceDP, CostDP, QuantityDP to TBatchSysRec record and assigned values in
  EX_GETSYSDATA (DLL01U - by Jim)
- To return OurRef, Folio number and other default saved fields to be returned
  if Ex_StoreTrans return zero.


Jim - 23/06/99
Added record structure TBatchJobType to exchdll.inc
Added new routine Ex_GetJobType (DllJobU) and modified project to export
Modified UsedDLLU to include new routine
Modified routine ExJobToJob (called by Ex_StoreJob) -
  error 300012 also raised when blank 3 char Job Type (as well as not found)


b435c.007 - Mark - 22/06/99
---------------------------
Rebuilt without debugging as debug version was working OK.

b435c.006 - Mark - 22/06/99
---------------------------
Debug version built for Ben Davies - Cooper Parry. Debugging added into EX_INITDLL
under compiler definition HM, was getting error 18'2 all the time.

Jim - 09/06/1999
DLLTH01U - Added functions Extract_PayRef1 & Extract_PayRef2 provided by EAL
Modified Procedure IdToExId to return correct pay in reference for SRC and SRI
transations irrelevant of posting status.


4.35c (27.05.99)
----------------
- Released this version with Enterprise 4.30b.

b435a.005 (05.05.99)
--------------------
  (By Jim)

- Added DirectCust and DirectSupp to TBatchSysRec returnded by Ex_GetSysData

- Unit DLLTH01U
  Added FUNCTION EX_STORETRANSHED = Updates selected fields from the transaction header.

- Fixed Ex_GetGLAccount to not raise an EConvert Error when passing an alpha search value
  when using key 0 (numeric GL code). Now returns error 4.

- Ex_InitBtrieve - Modified to calls Check4BtrvOK and return smallint

- Error code 18 (Exchdll.ini file not found) has been added in EX_InitDLL function.

-

b435a.004 (23.04.99)
--------------------
- Ex_StoreMatch has been modified.
  Though Ref.No has been assigned as 9 characters, extra 3 characters have been
  assigned in the DOCCode which is String[12].
  (For Cooper Parry)

b435a.003 (22.04.99)
--------------------
- Ex_GetRecordAddress and Ex_GetRecWithAddress functions have been added.
- Ex_GetCCDep function has been modified for not returning record with B_GetFirst
  command.

  (Added / Modified by Jim in April 99...)

- InitDLLU : Added
  FUNCTION EX_CLOSEDATA = Closes all files without a Btrieve reset
  Routine HeapVarTidy - Disposes of dynamic variables allocated in Ex_InitDLL,
  called from DClose_Files.
  Modified Open_Sys so that when checking for the presence of the system Btrieve file
  it returns error 12 and not an error 20.
  Added DynamicVarsAllocated global boolean

- Added unit DLLBTGen with routines ...
   FUNCTION EX_BTRIEVEFINDREC = Generic wrapper around Find_Rec routine
   FUNCTION EX_BTRIEVEGETPOS = Return current physical position
   FUNCTION EX_BTRIEVESETPOS = Set position to that of physical position
   FUNCTION EX_BTRIEVERECCOUNT = Return record count for specific files

- The following functions in new unit TLBatch.Pas was added by Mark for VB users. (20.04.99)
  EX_INITSTRUCTURE
  EX_CREATETLARRAY
  EX_ADDTLARRAYLINE
  EX_DESTROYTLARRAY


b435a.002 (01.04.99)
--------------------
(Sent to New Zealand)
- VAT Exchange rate has been modified to be compatible with Ent. version 4.30a.

b435a.001 (16.03.99)
--------------------
(Sent to Alan Austin)
- Ex_CheckPassword has been modified.
- PayInRef not displaying and Stock Adj. not showing in the Stock Ledger
  have been fixed.



4.35a (24.02.99) (Released Version)
-------------------
// This version number has been introduced according to version control structure

- Modified Job Record - ALineCount - initialized as 1000 for the new record.
- DetLTotal function has been copied from R&D\ComnU2.Pas for changes.
- Modified not to override stock cost in StoreTrans if the switch
  "Auto_Set_Stock_Cost" is OFF.
  
435-B4 (19.02.99)
-----------------
- Added Ex_GetDiscMatrix function.
  (Sent to Pallidium)

435-B3 (08.02.99)
-----------------
- (02.02.99) Euro Triangulation conversion has been enhanced.
  Conv_TCurr function has been copied for 16 bits.
- (05.02.99) Get and Store of Stock Alternative Codes have been added.

4.35  (27.01.99)
----------------

- Released this version.

4.35-B2  (26.01.99)
-------------------

- Multi Location Code for Transaction Line has been modified as check only
  if Syss.UseMloc is ON.

- SOPInvCode validation has been added in the customer record.

- If transaction line is payment line PayInRef should be assigned in the
  Stock Code field as maximum 15 characters. (21.01.99)

4.35-B1  (07.01.99)
-------------------

- This version must be used with Enterprise version 4.3 & above.
- Added EX_StoreDiscMatrix function.
- Tested Euro Conversion with modified Currency Functions.
- Added Ex_ConvertAmount function.
- Added validation for Transaction Type.
- Added PackQty validation.


434c-B2  (09/10.11.98)
---------------------

- Checking of passing record(s) size has been validated for Ex_GetLineSerialNo.
- Added Ex_GetJobEmployee, Ex_GetJobTimeRate and Ex_GetJobAnalCode functions.
- Stock Record - if update, reserved fields were not assigned from the original
  record. Fixed.
- 16.11.98 Added Def.Settlement Discount fields in the customer record.
- 19.11.98 Added Def.Form Set No. in the customer record.


434c-B1  (06.11.98)
-------------------
- Validation of customer code and job analysis code of the Job Header record in
  Ex_StoreJob function has been modified as if the job type is not Contract,
  customer code and job analysis code are mandatory fileds for the job record.

- Creation of "Show Total" of the job record has been added when the job header
  record is created for Job Costing Windows version.

434b-B5a (13.10.98)
-------------------
- If -1 is assigned in Accounting periods, the current Exchequer periods
  will be assigned.
- Recompiled 16 & 32 Bit for Conv_TCurr function.

*)
