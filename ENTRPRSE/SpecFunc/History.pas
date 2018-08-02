unit History;

interface

uses SysUtils;

function SFVersion: string;

implementation

{
================================================================================
History
================================================================================
--------------------------------------------------------------------------------
Date         Version     By   Amendments
--------------------------------------------------------------------------------
06/06/2018   Build 072   MH   ABSEXCH-20720 - mods to remove variance lines causing currency issues 
--------------------------------------------------------------------------------
20/02/2018   Build 071   PR   ABSEXCH-19781 Added check for SQL in
                              IsDataEncrypted function.
--------------------------------------------------------------------------------
29/11/2017   Build 070   PR   ABSEXCH-19503 Added Data Encryption to Rebuild
--------------------------------------------------------------------------------
30/08/2017   Build 069   PR   SF 166 - ABSEXCH-19162 Fix doubled-up settlement
                              caused by ABSEXCH-19160.
                              Added as patch to v2016 R2
--------------------------------------------------------------------------------
29/06/2017   Build 068   PR   SF 165 - ABSEXCH-18340 Set posted transaction
                              run numbers to their line run numbers (Denmaur).
                              Added as patch to v2016 R2
--------------------------------------------------------------------------------
27/02/2017   Build 066   PR   SF 12 - ABSEXCH-18340 Removed local variable
                              Status in UN_HistSPOP, as it was causing problem.
--------------------------------------------------------------------------------
14/09/2016   Build 065   PR   SF 163 - ABSEXCH-17636 Remove History records with
                                       year of > 2017 (Spotless)
--------------------------------------------------------------------------------
09/09/2016   Build 064   PR   SF 162 - ABSEXCH-17700 - Delete redundant control
                              lines (Crane Asia)
--------------------------------------------------------------------------------
27/04/2016   Build 063   CS   SF 157 - ABSEXCH-16737 - re-order transactions
                              after SQL migration
--------------------------------------------------------------------------------
21/04/2016   Build 062   CS   SF 160 - ABSEXCH-17432 - SF to clear transaction
                              Intrastat details
--------------------------------------------------------------------------------
25/11/2015   Build 061   PR   SF 159 - Clean System Setup Data ABSEXCH-17001
--------------------------------------------------------------------------------
06/10/2015   Build 060   CS   ABSEXCH-16838 - SF 158 - update transaction
                              delivery address country codes
--------------------------------------------------------------------------------
05/10/2015   Build 059   CS   ABSEXCH-16340 - SF 157 - Reorder Transactions,
                              for 2015 R1, SQL only (a new version will be
                              required whenever new fields are added to
                              DOCUMENT).
--------------------------------------------------------------------------------
07/07/2015   Build 058   MH   Updated version for Exchequer 2015 R1

                              ABSEXCH-16370: Extend SF149 to set Delivery Country
--------------------------------------------------------------------------------
30/06/2015   7.0.14.054  CS   Removed SF55 and SF56, as they refer to System
                              Setup fields which no longer exist
--------------------------------------------------------------------------------
03/03/2015   7.0.14.053  CS   Added SF154 to remove tab characters from
                              transaction lines
--------------------------------------------------------------------------------
19/01/2015   7.1.057     CS   SF 151 to populate country codes on Account
                              Contact table.
--------------------------------------------------------------------------------
12/01/2015   7.1.056     CS   Updated version number
--------------------------------------------------------------------------------
03/12/2014   7.x.ORD.055 CS   Order Payments - Phase 6 - T110 - Extended Purge
                              Orders process to include Order Payments
--------------------------------------------------------------------------------
02/12/2014   7.x.ORD.054 CS   Fix to SF 149 - ABSEXCH-15894
--------------------------------------------------------------------------------
02/12/2014   7.x.ORD.053 CS   Order Payments - Phase 6 - T224 - Added SF149 to
                              update the Country Code field in CUSTSUPP
--------------------------------------------------------------------------------
01/12/2014   7.x.ORD.052 CS   Order Payments - Phase 6 - T109 - Added SF148 to
                              clear legacy Credit Card fields in CUSTSUPP
--------------------------------------------------------------------------------
09/10/2014   7.0.12.052  CS   Copied SF135 and SF147 from earlier versions
--------------------------------------------------------------------------------
04/12/2013   7.0.8.051   CS   Recompiled for Consumer Ledger
--------------------------------------------------------------------------------
21/10/2013   7.0.7.050   CS   ABSEXCH-14703 - Added SF136 for copying Delivery
                              Address[5] to Postcode
--------------------------------------------------------------------------------
15/07/2013   7.0.4.049   CS   ABSEXCH-14438 - Removed unused 'About' dialog
--------------------------------------------------------------------------------
15/05/2013   7.0.048     CS   ABSEXCH-13001 - amended Windows OS check
--------------------------------------------------------------------------------
17/04/2013   7.0.047     CS   ABSEXCH-14239 - SF 134 - fix corrupted UntilDate
                              fields
--------------------------------------------------------------------------------
09/11/2012   7.0.046     CS   ABSEXCH-13692 - Purge Suppliers fails after Purge
                              Customers
--------------------------------------------------------------------------------
30/10/2012   7.0.045     CS   ABSEXCH-13639 - Audit Date and Purge Year
--------------------------------------------------------------------------------
18/10/2012   7.0.044     CS   ABSEXCH-13548 - Check audit date for purge
--------------------------------------------------------------------------------
04/09/2012   7.0.043     CS   Added SF 132 - data fix for Transaction Line Dates
--------------------------------------------------------------------------------
15/08/2012   7.0.042     CS   ABSEXCH-13240 - Purge omits some transactions -
                              added thAmountSettled field.
--------------------------------------------------------------------------------
17/07/2012   7.0.041     CS   Add SQL support for the Purge routines
--------------------------------------------------------------------------------
23/05/2012   6.10.040    CS   Added SF 130 & 131 - data fix for Transactions
                              with no lines
--------------------------------------------------------------------------------
29/03/2012   6.10.039    PR   Fixed issue where report was listing total number
                              of records rather than number of records in file
                              ABSEXCH-12118.
--------------------------------------------------------------------------------
14/03/2012   6.10.038    PR   Added message to rebuild report if record count in
                              header disagrees with number of records found.
--------------------------------------------------------------------------------
09/03/2012   6.10.037    PR   Added SF 129 to delete WOR lines with no header.
--------------------------------------------------------------------------------
08/03/2012   6.10.036    PR   Added SF 128 to delete WORs with no lines.
--------------------------------------------------------------------------------
04/01/2012   6.9.035     CS   Minor corrections to SF 126 and SF 127.
--------------------------------------------------------------------------------
23/11/2011   6.9.034     CS   Corrected SF 50 & 51 to correctly unallocate
                              records under SQL.
--------------------------------------------------------------------------------
26/10/2011   6.9.033     CS   Corrected SF 50 & 51 to correctly delete Matching
                              records under SQL.
--------------------------------------------------------------------------------
20/10/2011   6.9.032     CS   Added SF 127 to move SRN/PRNs to the correct daybook
--------------------------------------------------------------------------------
20/10/2011   6.9.031     CS   Added SF 126 to posted WORs with O/S quantities
--------------------------------------------------------------------------------
17/06/2011   6.7.030     CS   Changed version number.
--------------------------------------------------------------------------------
24/05/2011   6.7.029     CS   Changed version number.
--------------------------------------------------------------------------------
06/05/2011   6.7.028     CS   Reinstated the check for posted records in SF4 so
                              that it does not attempt to create missing
                              Transaction Headers from posted Transaction Lines.
--------------------------------------------------------------------------------
13/04/2011   6.7.027     CS   Added SF125, as Windows version of SETAFOLO.
--------------------------------------------------------------------------------
08/07/2010   6.3.024     CS   Added SF124 to reset invalid NOMMODE values (for
                              Alex Reid).
--------------------------------------------------------------------------------
10/03/2010   6.3.023     CS   Recompiled to pick up fix for date formats under
                              Windows 7
--------------------------------------------------------------------------------
13/01/2010   6.3.022     CS   Amended minimum default purge year to 1980.
--------------------------------------------------------------------------------
04/01/2010   6.01.021    CS   Added SF123 to delete unused (zero-valued) Stock
                              Location records, for Alex Reid.
--------------------------------------------------------------------------------
24/11/2009   6.01.020    CS   Copied SF11 from Exchequer DOS -- this reformats
                              Stock Codes, ensuring that they are correctly
                              padded with spaces.
--------------------------------------------------------------------------------
24/03/2009   6.01.019    CS   Added SF122 to copy info from stock records to
                              transaction lines (FirstServe). This is part of a
                              fix for missing Cost of Sales figures. FirstServe
                              will put the missing figures into the Web
                              Catalogue field on stock items, and this function
                              will then copy them to UDF4 on all the SIN and
                              SRC transaction lines which reference those stock
                              items.
--------------------------------------------------------------------------------
28/01/2009   6.01.018    CS   Added SF121 to populate account codes in PPY/SRC
                              transactions
--------------------------------------------------------------------------------
11/12/2008   6.01.017    MH   Added SF120 to fix PJC/PJI transactions
--------------------------------------------------------------------------------
10/12/2008   6.01.016    MH   Copied SF 118 from v6.00.003
--------------------------------------------------------------------------------
Ver 015 was a v6.00.002 release for SF 119 - (Fission IT Ltd)
Ver 014 was a v6.00.003 release for SF 118
Ver 013 was a v6.00.002 release for SF 118
--------------------------------------------------------------------------------
26/11/2008   6.00.012    CS   Amended Special Function 108, for Genisys, to
                              correct the line type of the transaction line.
--------------------------------------------------------------------------------
02/10/2008   6.00.011    CS   Prevented Special Functions option from being
                              available without an MCM Password.
--------------------------------------------------------------------------------
Note: 6.00.010 was a specific fix for a customer, and is not included in this
version.
--------------------------------------------------------------------------------
22/04/2008   6.00.009    CS   Added Special Function 116: Clear corrupt YTD
                              History records from G/L and CC/Dep History.

                              (Originally written by Eduardo in the Rebuild
                               module, but copied to here.)
--------------------------------------------------------------------------------
Date         Version     By   Amendments
--------------------------------------------------------------------------------
27/03/2008   6.00.008    CS   Added SRC support to Special Function 88.

--------------------------------------------------------------------------------
Date         Version     By   Amendments
--------------------------------------------------------------------------------
22/01/2008   6.00.007    CS   Special Function 12 (Return outstanding orders
                              from history) was not working correctly where
                              quantities were fractional, as the function was
                              truncating the values when checking for non-zero
                              quantities.

                              To avoid problems with existing users, the number
                              of decimal places to be checked has been added as
                              an optional parameter to the routine which
                              actually checks and updates the transactions.
                              Function 12 passes 0 to this routine, so that it
                              works as before. A new function, 115, has been
                              added which asks the user for the number of
                              decimal places, defaulting to the system setting,
                              and passes this value to the routine.
--------------------------------------------------------------------------------
02/11/2007   6.00.006    MH   Rebuilt to pick up index changes on InvF and IDetailF
--------------------------------------------------------------------------------
17/10/2007   6.00.005    CS   The maximum available purge year is now set to two
                              years before the current year. The minimum year
                              is set to the last purge year (if any), or the
                              same as the maximum purge year.
--------------------------------------------------------------------------------
01/10/2007   6.00.004    CS   Purge Accounting Data now uses the AuditYr system
                              setting (which holds the last Purge Year) instead
                              of the AuditDate system setting (which holds the
                              last Audit Year).
--------------------------------------------------------------------------------
28/09/2007   6.00.003    CS   Purge Accounting Data is now correctly picking up
                              the correct Audit Year.

                              Purge Orders is now correctly passing the selected
                              year and period to the actual purge routine.

                              Purge Accounting Data no longer deletes the
                              Direct Customer and Direct Supplier accounts.
--------------------------------------------------------------------------------
25/09/2007   6.00.002    CS   Included additional warning messages for the
                              Purge Orders routine.
--------------------------------------------------------------------------------
24/09/2007   6.00.001    CS   Fixed Purge Accounts year (FRv6.00.085,
                              FRv6.00.086, FRv6.00.089).

                              Amended warning messages (FRv6.00.087,
                              FRv6.00.088).
--------------------------------------------------------------------------------
12/09/2007   6.00.000    CS   Added History unit, and version label.

                              Corrected the checking of command-line parameters
                              to look for 1 or 2 instead of 0 or 1.
--------------------------------------------------------------------------------
}

Uses ExchequerRelease;


//function SFMajor: string;
//// Major part of version number.
//begin
//  Result := '7';
//end;

// -----------------------------------------------------------------------------

//function SFMinor: string;
//// Minor part of version number.
//begin
//  Result := '1';
//end;

// -----------------------------------------------------------------------------

function SFBuild: string;
// Build number
begin
  Result := '072';
end;

// -----------------------------------------------------------------------------

function SFVersion: string;
// Full version string
begin
//  Result := Format('v%s.%s.%s', [SFMajor, SFMinor, SFBuild]);

  // MH 07/07/2015 2015-R1: Updated version number generation
  Result := ExchequerModuleVersion (emSpecialFunctions, SFBuild);
end;

// -----------------------------------------------------------------------------

end.
