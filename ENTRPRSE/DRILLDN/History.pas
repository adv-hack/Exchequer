unit History;

interface

function DrillDownVer : ShortString;

implementation

Uses ExchequerRelease;

const
  // Drill-Down COM Object Version Number

  BuildVer_DD = '125';   // EntDrill Build Number - common across Exch & IAO

  // NOTE: The build number should be incremented for any new version leaving
  // the department, even if just to QA for testing.

// Current Drill Down Engine version for Exchequer|IAO
function DrillDownVer : ShortString;
begin // DrillDownVer
  Result := ExchequerModuleVersion (emExcelDrillDown, BuildVer_DD);
end; // DrillDownVer

(****************************************************************************

VERSION HISTORY
===============

Build 125 - 24/05/2017
--------------------------------------------
  MH   ABSEXCH-18546: Fixed fault where GL Drill-down was filtering out lines where the
       first byte of the Posting Run No was #255


Build 123 - 29/11/2016
--------------------------------------------
  MH     ABSEXCH-17754 - Removed borders from Login dialog as per Exch Login


Build 122 - 14/10/2016
--------------------------------------------
  MH     ABSEXCH-17754 - Updated Login dialog for branding changes


Build 121 - 18/05/2016
--------------------------------------------
  CS   ABSEXCH-16367 - SQL OLE EntCustNetSales DrillDown performance

Build 120 - 28/07/2015
--------------------------------------------
  CS   Amendments for 2015 R1 merge

Build 119 - 21/07/2015
--------------------------------------------
  MH   Merged v7.0.14 into Exch 2015 R1 - god be with us


v7.0.14.118   18/06/2015
--------------------------------------------
  MH    ABSEXCH-16554: Updated PPD status field on transaction footer for changes in Enter1 


v7.0.14.117   28/05/2015
--------------------------------------------
  MH    ABSEXCH-16284: Updated for latest changes to SaleTx2U Footer
        ABSEXCH-16468: Zero value SIN showing 'Status: Available'
        

v7.0.14.116   21/05/2015
--------------------------------------------
  MH    ABSEXCH-16284: Updated for latest changes to Prompt Payment Discount fields


v7.0.14.115   25/03/2015
--------------------------------------------
  MH    ABSEXCH-16284: Added Prompt Payment Discount fields


v7.0.13.114 - 26/02/2015
--------------------------------------------
  MH   ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015

v7.0.8.113 - 03/12/2013
--------------------------------------------
  CS   MRD1.1.40 - Amendments for Consumer ledger

v7.0.7.112 - 28/10/2013
--------------------------------------------
  CS   ABSEXCH-14705 - Amendments for Transaction Originator

v7.0.5.111 - 12/07/2013
--------------------------------------------
  MH   Rebranded for Advanced


v7.0.110 - 07/11/2012
--------------------------------------------
  MH   Rebuilt to pickup changes to TSBSPanel painting on column headers


v7.0.109 - 29/10/2012
--------------------------------------------
  MH   ABSEXCH-13620 - Modified UI Colours


v7.0.108 - 11/09/2012
--------------------------------------------
  CS   ABSEXCH-12730 - Corrected CC/Dept filtering for ENTGL..ACTUAL functions.


v7.0.107 - 10/09/2012
--------------------------------------------
  MH   Updated to v7.0 version number / branding


v6.10.106 - 07/03/2012
--------------------------------------------
  MH   ABSEXCH-11389 - Modified entJCAnalActual drill-down as committed wasn't showing up properly


v6.9.105 - 18/01/2012
--------------------------------------------
  MH   ABSEXCH-12227 - tab order corrections on SRC/PPY/ADJ Header UDef fields


v6.9.104 - 05/01/2012
--------------------------------------------
  CS   Reversed out changed from ABSEXCH-11621 -- fix has been pulled from this
       release and will be rescheduled.

v6.9.103 - 29/11/2011
--------------------------------------------
  CS   Corrected tab order on Transaction Headers and NOM Lines.

v6.9.102 - 24/11/2011
--------------------------------------------
  CS   Corrected tab order on WOR Line and corrected arrangement of UDFs on
       SIN Line.

v6.9.101 - 23/11/2011
--------------------------------------------
  GS   Expanded various forms that have user defined fields;
       these forms now have 10 user defined fields, increased from 4

v6.9.100 - 21/11/2011
--------------------------------------------
  CS   Corrected position of buttons on Works Order Line.
       Recompiled to pick up changes to TSBSExtendedForm positioning.

v6.9.099 - 04/11/2011
--------------------------------------------
  MH   Modified to support Custom Fields Business Object, fixed compilation error on TransSOPF


v6.9.098 - 19/10/2011
--------------------------------------------
  CS   ABSEXCH-11621 - Amended fcCustNetSales drill-down to allow the display
       of Supplier data.


v6.7.097 - 13/04/2011
--------------------------------------------
  CS   ABSEXCH-9887 - Corrected the amendments to reduce flickering on extended
       Btrieve calls (SBSComp.pas).

v6.7.096 - 13/04/2011
--------------------------------------------
  MH   ABSEXCH-11124 - Moved SIN thransaction header window so it was on the main
       window and used the default position.


v6.7.095 - 23/03/2011
--------------------------------------------
  MH  ABSEXCH-10164 - Undocumented change by CS


v6.5.094 - 01/12/2010
--------------------------------------------
  MH   ABSEXCH-2930:-

         - Modified filtering in EntJCTotActual drill-down to check for the Apps & Vals
           Posting Run Number (-119) when drilling into the Apps & Vals categories


v6.5.093 - 12/11/2010
--------------------------------------------
  MH   ABSEXCH-2930:-

         - Disabled Extended Btrieve Operations in SQL Edition for Job Actuals
           drill-down as getting Error 65's as the SQL Emulator does not support
           Extended Btrieve Operations on fields outside the variant part of the
           table.

         - Modified Committed Job Actual drill-down to check the JAType as it was
           showing stuff incorrectly.

         - Added special cases for WIP and Profit which show the Job Details from
           other catagories and don't have any themselves.  This had caused empty
           lissts to be shown.

         - Added reference counting mechanism into EnterpriseData object as some
           forms were automatically closing files when they closed - which was a
           problem if there were multiple windows open.


v6.5.092 - 02/11/2010
--------------------------------------------
  MH   ABSEXCH-2976 - Added code to present disabled look to service date fields


v6.5.091 - 14/10/2010
--------------------------------------------
  MH   Added Override Location into standard transaction dialog


v6.4.090 - 23/06/2010
--------------------------------------------
  MH   Updated standard TXLine dialog to match Exchequer's


v6.4.089 - 23/03/2010
--------------------------------------------
  MH   Setup automated build routines


v6.3.088 - 11/03/2010
--------------------------------------------
  MH   Modified resize code on Customer History Drill-Down window as the increased window
       borders under Windows 7 were causing controls to go off the side.

       Modified the Customer History Drill-Down list as the value columns were setup to use
       qty decimals, modified to use 2dp.

v6.3.087 - 11/03/2010
--------------------------------------------
  CS   Recompiled to pick up date format changes for Windows 7

v6.01.086 - 08/06/2009
--------------------------------------------
  MH   Correct User Permissions lookups to use the correct Excel OLE Permissions

v6.01.085 - 01/06/09
--------------------------------------------
  CS   Added display of Multibuy Discounts to drill-down on Transactions and
       Transation Lines.

v6.00.084 - 14/08/08
--------------------------------------------
  MH   Rebuilt for branding changes on the login dialog


v6.00.083 - 18/09/07
--------------------------------------------
  MH   Applied the v6.00 IRIS icon


v5.71.082 - 21/06/06
--------------------------------------------
  CS    Added the G/L View drill-downs.


v5.70.081 - 05/04/06
--------------------------------------------
  CS    The GL Job Actual drill-down now sizes correctly when displayed using
        Windows XP Themes.

  CS    The 'View' button on the Stock drill-down dialogs is now hidden when
        displaying any tabs other than the Ledger tab.

  CS    The Works Order Processing tab and Goods Return tab now only appear if
        these modules are licenced.


v5.70.080 - 05/04/06
--------------------------------------------
  CS    The GL Job Actual drill-down now correctly displays record
        for selected currencies (previously is was only displaying
        records if 'consolidated' was selected).

        The Amount column in the GL Job Actual list is now right-justified.
        Similarly, the Cost and Charge columns on the Job Costing Analysis
        drill-down are now also right-justified.

        In the Stock History form, the Qty Out column is no longer truncating
        the right-hand digits if more than two decimal places are used.

v5.70.047 - 03/04/06
--------------------------------------------
  CS    Corrected security for EntJCAnalActual, EntJCAnalActualQty, and
        EntGLJobActual.

v5.70.046 - 24/03/06
--------------------------------------------
  CS    Security-checking updated so that users are correctly allowed/disallowed
        access to drill-downs, based on their current access rights (previous
        versions were checking security using the wrong codes).

v5.70.045 - 24/03/06
--------------------------------------------
  CS    EntStkQtyUsed, EntStkLocQtyUsed now showing Sales Invoice transactions
        where BOM components were taken from stock.


v5.70.044 - 23/03/06
--------------------------------------------
  CS    EntStkQtyUsed, EntStkLocQtyUsed now showing the correct transactions.

  CS    Posted in Stock figures are now correct for the drill-downs against
        location-based formulae.

  CS    EntStkLocQtySold no longer shows WORs with zero quantities in the
        drill-down.

  CS    EntSuppCommitted no longers shows PCRs in drill down.

  CS    EntSuppCommitted and EntCustCommitted now only show committed
        transactions.

  CS    Drill-down details were sometimes not appearing for EntGLJobActual and
        EntJCAnalActual. This has now been fixed.

  CS    EntCustNetSales drill-down added.

v5.70.043 - 23/02/06
--------------------------------------------
  CS    SORs no longer appear in the ledger tab for EntCustBalance.

  CS    SINs no longer appear in the ledger tab for EntCustCommitted.

  CS    The values for the Main tab and Works Order tab are now correct, and
        respect any location filter which is set.

  CS    Filtering on location, cost center, or location now works correctly
        for EntCustStkQty and EntCustStkSales.

  CS    Drill-down added for EntStkQtyUsed.

v5.70.042 - 24/01/06
--------------------------------------------
  CS    The following functions now support drill-down, including drill-down to
        the individual line entries:

            EntStkQtyOnOrder
            EntStkQtySold
            EntStkQtyAllocated
            EntStkQtyOSSOR
            EntStkQtyInStock
            EntStkQtyPicked

            EntStkWORQtyAllocated
            EntStkWORQtyIssued
            EntStkWORQtyPicked

            EntStkLocQtyAllocated
            EntStkLocQtyInStock
            EntStkLocQtyOnOrder
            EntStkLocQtyOSSOR
            EntStkLocQtyPicked
            EntStkLocQtySold
            EntStkLocQtyUsed

            EntStkLocWORQtyAllocated
            EntStkLocWORQtyIssued
            EntStkLocWORQtyPicked

            EntCustStkQty
            EntCustStkSales
            EntCustAgedBalance
            EntCustBalance
            EntCustCommitted

            EntSuppCommitted
            EntSuppAgedBalance
            EntSuppBalance

        In addition, the Job Costing drill-downs now support further drill-down
        to the individual line entries.

v5.70.041 - 15/11/05
--------------------------------------------
  CS    Added new selection pop-ups:

          EntSelectJob
          EntSelectAnalysis
          EntSelectJobTypes

  CS    Added new drill-downs:

          EntGlJobActual
          EntJCAnalActual
          EntJCAnalActualQty
          EntJCStkActual
          EntJCStkActualQty
          EntJCtotActual
          EntJCtotActualQty

        Notes:
        Drill-down is only available for jobs, not contracts (consistent with
        the existing GL drill-downs).

        The Qty options include both Committed and Posted items (consistent
        with the Excel functions themselves).


v5.70.040 - 22/09/05
--------------------------------------------
  HM    Released for v5.70


b570.040 - 19/08/05
--------------------------------------------
  HM    Rebranded for v5.70 / IRIS


v5.61.039 - 26/04/05
--------------------------------------------
  HM    Rebuilt as it was crashing shutting down if you had done a drill-down
        operation - no code from this project has been changed - must be
        picking up a fix from R&D or something.

        NOTE: I think the OLE Server had a similar problem from memory.


v5.61.038 - 02/02/05
--------------------------------------------
  HM    Released for v5.61


v5.60.038 - 22/09/04
--------------------------------------------
  HM    Released for v5.60.001


b561.038 - 09/08/04
--------------------------------------------
  HM    Changed SetPath.Pas to pickup the correct path from VAOInfo and put
        it into SetDrive automatically during startup.  Changed DDLogin to
        auto-hide bitmaps when running under VAO


v5.60.037 - 14/05/04
--------------------------------------------
  HM    Released for v5.60


v5.52.037 - 18/11/03
--------------------------------------------
  HM    Released for v5.52


b552.037 - 22/10/03
--------------------------------------------
  HM    Modified the handling of WM_WindowPosChanged on the display forms
        so that they check that the form is visible before attempting to
        gain focus - this was causing Windows 98 to lock. 


v5.51.036
--------------------------------------------
  HM    Unexpectedly released with v5.51.001 - hence reversing version number


b552.035
--------------------------------------------
  HM    Fixed a case sensitivity bug in TDrillDown.DrillDown


v5.51.034 - 27/06/03
--------------------------------------------
  HM    Released for v5.51


b551.033 - 05/06/03
--------------------------------------------
  HM    Changed NOM Header window to default to main tab not footer



b551.032 - 14/05/03
--------------------------------------------
  HM    Added VAT Support into the Nominal Transfer Header and Line windows.

  HM    Fixed a bug where the NOM Line window wasn't being de-allocated correctly
        on the header so it caused an AV the second time you opened one.

  HM    Fixed a bug on the NOM Footer where the CC/Dept codes weren't being shown
        when you selected lines.


b551.031 - 13/05/03
--------------------------------------------
  HM    Fixed a bug in ValidFinancialPeriod for Period -99 as it was incorrectly
        setting the Period to 1900 + the F6 period instead of just the F6 Period.


b551.030 - 09/05/03
--------------------------------------------
  HM    Added More Info button into About Dialog to make the Drill-Down Log
        details visible
        

b551.029 - 08/05/03
--------------------------------------------

  HM    Added DisplayAbout method onto COM Object for About Dialog in Excel



****************************************************************************)

end.
