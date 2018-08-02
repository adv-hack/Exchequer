unit History;
{
  This is the IAO-compatible version, for Exchequer 5.71 onwards.
}
interface

const
  ExchVer = 'v2016.R1.';  // Exchequer Version
  LITEVer = 'v1.00';  // LITE/IAO Version

  RWBuildVer        = '221';   // Build Number - common across Exch & IAO
  {$IFNDEF SENTREPENG}
  RepEngineBuildVer = '271';   // Build Number - common across Exch & IAO
  {$ELSE}
  RepEngineBuildVer = '271';   // Build Number - common across Exch & IAO
  {$ENDIF}

function EntRWVer: string;
function RepEngineVer: string;

implementation

uses EntLicence, ExchequerRelease;

function EntRWVer: string;
begin
  if (EnterpriseLicence.elProductType in [ptLITECust, ptLITEAcct]) then
    Result := LiteVer + '.' + RWBuildVer
  else
    Result := ExchequerModuleVersion(emEntRW, RWBuildVer);
end;

function RepEngineVer: string;
begin
  if (EnterpriseLicence.elProductType in [ptLITECust, ptLITEAcct]) then
    Result := LiteVer + '.' + RepEngineBuildVer
  else
    Result := ExchequerModuleVersion(emRepEngine, RepEngineBuildVer);
end;

(****************************************************************************

VERSION HISTORY    (ER=EntRW, RE=RepEngine)
==============

06/02/2017  EntRW build 221
            RepEngine build 271
-------------------------------------------------------------
  MH        ABSEXCH-14925: Added support for extra image types


17/10/2016  EntRW      Build 220
-------------------------------------------------------------
  MH        ABSEXCH-17754: Changed colour scheme from pink/purple to light grey/dark grey


17/10/2016  EntRW      Build 219
            RepEngine  Build 270
-------------------------------------------------------------
  MH        ABSEXCH-17754: Updated Toolbar bitmaps


30/08/2016  RepEngine v2016.R1.269
-------------------------------------------------------------
  PR        ABSEXCH-12521: Fixed issue where program wasn't opening .xlsx file

22/08/2016  RepEngine v2016.R1.268
-------------------------------------------------------------
  PR        ABSEXCH-12521: Added .xlsx output format

22/01/2016  RepEngine v2016.R1.267
-------------------------------------------------------------
  PKR       ABSEXCH-17110: Rebuilt to pick up changes for Intrastat

10/11/2015  RepEngine v2016.R1.266
-------------------------------------------------------------
  PR        ABSEXCH-15491: Amended to cope with SYSREPC in SQL

19/06/2015  RepEngine v7.0.14.265
-------------------------------------------------------------
  MH        ABSEXCH-16284: Rebuilt to pickup changes to Transaction PPD Total fields


01/04/2015  RepEngine v7.0.14.264
-------------------------------------------------------------
  PR        ABSEXCH-16313 - Fixed issue where report lines were being duplicated


  26/03/2015  RepEngine v7.0.14.263
-------------------------------------------------------------
  MH        ABSEXCH-16284: Rebuilt to pickup new fields for Prompt Payment Discounts


08/10/2014  RepEngine v7.0.12
-------------------------------------------------------------
  MH        Rebranded from v7.1 to v7.0.12

22/07/2014  RepEngine v7.0.11.261
-------------------------------------------------------------
  PR        ABSEXCH-16202 - Fixed issue where formula wasn't using correct dec places

09/07/2014  RepEngine v7.0.11.260
-------------------------------------------------------------
  CS        ABSEXCH-15307 - Added option to include section headers on CSV export

24/06/2014  RepEngine v7.0.10.259
-------------------------------------------------------------
  PR        ABSEXCH-11693: Added code to enforce recalculation of formulas in footers on second pass.

02/06/2014  RepEngine v7.0.10.258
-------------------------------------------------------------
  MH        ABSEXCH-15404: Added PE Flags to force entire component to be loaded into memory

27/03/2014  RepEngine/SentRepEngine v7.0.9.257
-------------------------------------------------------------
  PR        ABSEXCH-15214: Added handling to prevent engine from processing Id records with FolioRef = 0 on
	    new indexes.

03/02/2014  RepEngine/SentRepEngine v7.0.9.256
            EntRW v7.0.9.217
-------------------------------------------------------------
  PR        ABSEXCH-15121: Fix for tables being closed behind the scenes.

03/02/2014  RepEngine/SentRepEngine v7.0.9.256
            EntRW v7.0.9.217
-------------------------------------------------------------
  PR        ABSEXCH-14974: Added handling for Account Contact Roles table.

08/01/2013  RepEngine/SentRepEngine v7.0.8.252
-------------------------------------------------------------
  PR        ABSEXCH-14854: Added handling for new indexes in Details.dat

28/10/2013  RepEngine/SentRepEngine v7.0.7.250
-------------------------------------------------------------
  PR        ABSEXCH-14705: Recompiled to pick up Transaction Originator fields


18/10/2013  RepEngine/SentRepEngine v7.0.7.249
-------------------------------------------------------------
  PR        ABSEXCH-14703: Recompiled to pick up Delivery Postcode fields


27/09/2013  RepEngine/SentRepEngine v7.0.6.248
-------------------------------------------------------------
  PR        ABSEXCH-14640: Recompiled to pickup Job Record CC/Dept fields

09/09/2013  RepEngine/SentRepEngine v7.0.6.247
-------------------------------------------------------------
  MH        ABSEXCH-14598: Recompiled to pickup changes for SEPA/IBAN fields


12/07/2013 EntRW v7.0.5.216   ABSEXCH-14438
-------------------------------------------------------------
  CS            Updated version number and copyright

10/09/2012 RepEngine/EntRW v7.0.245   ABSEXCH-12952
-------------------------------------------------------------
  CS            Updated version number and copyright

13/03/2012 RepEngine/SentRepEngine v6.10.244   ABSEXCH-10199
-------------------------------------------------------------
  PR            Added handling to DiclinkU for new THOSACTV field


13/03/2012 EntRW v6.10.214   RepEngine/SentRepEngine v6.9.243
-------------------------------------------------------------
  MH            ABSEXCH-11937 - Modified to write RAVE temp files to Win\Temp
                instead of Exchequer SWAP filder.+


02/03/2012 RepEngine/SentRepEngine v6.9.242   ABSEXCH-12596
-------------------------------------------------------------
  MH            Rebuild to pickup mods for new TLTHRESH field


28/02/2012 RepEngine/SentRepEngine v6.9.241   ABSEXCH-2357
-----------------------------------------------------
  MH            Removed ABSEXCH-2357 mod from THOSACTU (aka 2058) as inclusion
                of variance/revaluation appears to be causing problems


<Unspecified changes by PRutherford>


01/10/2011 RepEngine v6.9.237   ABSEXCH-11577
-----------------------------------------------------
  CS    (RE)    Adding saving/loading of vcPageBreak property on Formulas.

04/04/2011 RepEngine v6.7.235   ABSEXCH-10689
-----------------------------------------------------
  PR    (RE)    Modified report ovbect to load user permissions.

        (RE)    Rebuilt to pickup changes to Trader Bank.Card Details


16/02/2011 RepEngine v6.5.230
-----------------------------------------------------
  PR            Fixed problem with Adobe PDF 9 & 10 (ABSEXCH-10677)


09/02/2011 EntRW v6.6.210 / RepEngine v6.6.232
-----------------------------------------------------
  CS   (ER/RE)  Updated version numbers


24/01/2011 EntRW v6.6.208 / RepEngine v6.6.231
-----------------------------------------------------
  CS   (RE)     Corrected output of multiple values for the same field in CSV
                and DBF.


11/01/2011 EntRW v6.6.208 / RepEngine v6.6.230
-----------------------------------------------------
  CS   (ER/RE)  Rebuilt for GUI validation improvements in v6.6


26/03/2010 EntRW v6.5.207 / RepEngine v6.5.229
-----------------------------------------------------
  MH            Rebuilt for v6.5 to pickup new data dictionary fields


02/06/2010 EntRW v6.4.207 / RepEngine v6.4.229
-----------------------------------------------------

  PR   (RE)     Changes to let SQL text file caching work with totals and
                calculated fields.


26/03/2010 EntRW v6.3.207 / RepEngine v6.3.228
-----------------------------------------------------
  PR   (RE)     Amendments to RepObjCU (in RepWrt).


10/03/2010 EntRW v6.3.207 / RepEngine v6.3.227
-----------------------------------------------------

  CS   (RE)     Recompiled to pick up date format fix for Windows 7.

01/03/10   RepEngine v6.3.226
-----------------------------------------------------

  MH   (RE)     Modified TdMTExLocal.Create to create Client Id's with a VR prefix
                for RepEngine.Dll as it was clashing with the Report Thread in
                Exchequer causing blank reports.


15/02/10   EntRW v6.3.206 / RepEngine v6.3.225
-----------------------------------------------------

  PR   (RE)     Amended RepEngine to accommodate database normalisation changes.

02/02/10   EntRW v6.3.206 / RepEngine v6.3.224
-----------------------------------------------------

  CS   (RE)     Recompiled to pick up Web Extension fields.

01/12/09   EntRW v6.3.206 / RepEngine v6.3.223
-----------------------------------------------------

  PR   (RE)     Removed SQL caching (found problem with formula calculations).

23/11/09   EntRW v6.3.206 / RepEngine v6.3.222
-----------------------------------------------------

  CS   (ER/RE)  Corrected handling of American format dates.

08/10/09   EntRW v6.3.205 / RepEngine v6.3.220
-----------------------------------------------------

  CS   (ER/RE)  Corrected handling of American format dates.

21/09/09   EntRW v6.00.204 / RepEngine v6.2.219
-----------------------------------------------------

  CS   (RE)     Prevented SendMessage from Report Generator when there is no
                Application MainForm (as with Sentimail).

11/09/09   EntRW v6.00.204 / RepEngine v6.2.218
-----------------------------------------------------

  CS   (RE)     Recompiled to pick up EC Sales fields and 6.2 version number

31/07/09   EntRW v6.00.203 / RepEngine v6.01.217
-----------------------------------------------------

  CS   (RE)     Corrections to support Outlook Dynamic Dashboard VRW Control.

28/07/09   EntRW v6.00.203 / RepEngine v6.01.216
-----------------------------------------------------

  CS   (RE)     Amendments to support Outlook Dynamic Dashboard VRW Control.

24/07/09   EntRW v6.00.203 / RepEngine v6.01.215
-----------------------------------------------------

  CS   (RE)     Corrected the export of date fields to DBF.

22/07/09   EntRW v6.00.203 / RepEngine v6.01.214
-----------------------------------------------------

  CS   (RE)     Suppressed "no preview windows" SendMessage when running under
                external applications (such as Sentimail) which have no main
                window.

09/07/09   EntRW v6.00.203 / RepEngine v6.00.213
-----------------------------------------------------

  CS   (RE)     Corrected validation of data Input Fields referenced in formula
                fields.

09/07/09   EntRW v6.00.203 / RepEngine v6.00.212
-----------------------------------------------------

  CS   (ER)     Added check for references to Input Fields when the user tries
                to delete one.

08/07/09   EntRW v6.00.202 / RepEngine v6.00.212
-----------------------------------------------------

  CS   (RE)     Corrected checking for section breaks against formula fields.

08/07/09   EntRW v6.00.202 / RepEngine v6.00.211
-----------------------------------------------------

  CS   (RE)     Modified to send messages to the main form of the owning
                application when preview windows are closed or are not
                required. This is used by VRWCOM.exe so that it knows to
                release the COM object reference.

08/07/09   EntRW v6.00.202 / RepEngine v6.00.210
-----------------------------------------------------

  PR   (RE)     Fixes for using Formulas which refer to formulas which use
                Input Lines.

03/07/09   EntRW v6.00.202 / RepEngine v6.00.209
-----------------------------------------------------

  CS   (RE)     Changed the Range Filter editor so that viewing/editing Range
                Filters no longer deletes the Input Fields.

                Fault Log: 20080214121043

02/07/09   EntRW v6.00.201 / RepEngine v6.00.208
-----------------------------------------------------

  CS   (RE)     Changed output to CSV so that values are output in the onscreen
                order, rather than the order in which the controls were added.

                Fault Log: 20090120152452

23/06/09   EntRW v6.00.201 / RepEngine v6.00.207
-----------------------------------------------------

  CS   (RE)     Recompiled RepEngine to pick up changes to temporary files for
                SQL (SCRTCH1U.pas).

16/06/09   EntRW v6.00.201 / RepEngine v6.00.206
-----------------------------------------------------

  CS   (RE)     Recompiled RepEngine to pick up changes to Data Dictionary for
                Advanced Discounts.

11/06/09   EntRW v6.00.201 / RepEngine v6.00.205
-----------------------------------------------------

  CS   (RE)     Amended the Print Preview check to ensure that if we are not
                running under ENTER1 the preview form is simply shown modeless,
                rather than attempting to display the form as an MDI Child.

10/06/09   EntRW v6.00.201 / RepEngine v6.00.204
-----------------------------------------------------

  PR   (ER/RE)  Added Multibuy Discount Data Dictionary fields.


29/05/09   EntRW v6.00.200 / RepEngine v6.00.203
-----------------------------------------------------

  CS   (RE)     Added Data Dictionary field cache as a performance enhancement.

19/05/09   EntRW v6.00.200 / RepEngine v6.00.202
-----------------------------------------------------

  CS   (RE)     F0022: Further corrections to the calculation of total fields
                into report totals, in particular where report totals are based
                on formulas or total fields in section footers.

                Copied from v6.00.003

09/04/09   EntRW v6.00.200 / RepEngine v6.00.201
-----------------------------------------------------

  CS   (RE)     F0022: Additional corrections to the calculation of total fields
                into report totals, in particular where report totals are based
                on formulas or total fields in section footers.

01/04/09   EntRW v6.00.200 / RepEngine v6.00.200
-----------------------------------------------------

  CS   (RE)     Corrected the calculation of total fields into report totals.

08/10/08   EntRW v6.00.105 / RepEngine v6.00.104
-----------------------------------------------------

  CS   (RE)     Amended the deletion of security records when deleting a
                report, for compatibility with the SQL Emulator, and to ensure
                that locks are always cleared.

17/09/08   EntRW v6.00.105 / RepEngine v6.00.0103
-----------------------------------------------------

  CS   (ER/RE)  Recompiled for Exchequer SQL code-freeze.

18/03/08   EntRW v6.00.104 / RepEngine v6.00.102
-----------------------------------------------------

  CS   (ER)     Removed the Convert WRW Report menu option when running under
                SQL.

19/02/08   EntRW v6.00.103 / RepEngine v6.00.102
-----------------------------------------------------

  CS   (ER)     Amended EntRW and RWReader.DLL for compatibility with SQL
                (RWReader is Pervasive-only, and needs to be loaded
                 dynamically).

    ============================================================================
    v 6.00.003 VERSION HISTORY    (ER=EntRW, RE=RepEngine)
    ============================================================================
    v 6.00.003 contains some bug fixes which happened after the source code for
    v 6.01 was split off. These bug fixed have been included in 6.01, but the
    version numbers obviously conflict. This is a copy of the relevant notes
    from the v 6.00.003 code base.

    13/01/09   EntRW v6.00.107 / RepEngine v6.00.107
    -----------------------------------------------------

      CS   (RE)     Corrected the export of numeric formulae to CSV.

    21/11/08   EntRW v6.00.107 / RepEngine v6.00.106
    -----------------------------------------------------

      CS   (ER/RE)  Recompiled to pick up new fields for Job Budget Currency.

    01/11/07   EntRW v6.00.106 / RepEngine v6.00.105
    -----------------------------------------------------

      PR   (RE)     Input Lines should now work correctly in calculated fields.

      PR   (ER)     Changed to use v6 icon.


    31/10/07   EntRW v6.00.105 / RepEngine v6.00.104
    -----------------------------------------------------

      CS   (ER/RE)  Input Lines in formulae should now set the 'string formula'
                    flag correctly.

                    Validation of Input Lines in formulae should correctly identify
                    input lines when more than one has been defined.

    31/10/07   EntRW v6.00.104 / RepEngine v6.00.103
    -----------------------------------------------------

      CS   (ER/RE)  Corrected the validation of formulae so that invalid input
                    lines are reported.

                    Amended the double-click insertion of operators into formula
                    fields so that the required leading and trailing spaces are
                    included.

    29/10/07   EntRW v6.00.103 / RepEngine v6.00.102
    -----------------------------------------------------

      CS   (ER)     The buttons on the Input Lines Edit dialog are now aligned, and
                    the columns on the Input Lines dialog are consistently
                    justified.

                    The Input Lines section in the Formula Properties dialog is now
                    populated correctly.

                    The tab order of the controls on the Input Lines Edit dialog is
                    now correct.

                    The Input Line 'Name' field on the Input Lines Edit dialog is
                    now labelled correctly.

                    The Input Lines dialog now correctly displays the values for
                    the edited/added input line.

    ============================================================================
    End of v 6.00.003 VERSION HISTORY
    ============================================================================

17/09/07   EntRW v6.00.102 / RepEngine v6.00.102
-----------------------------------------------------

  CS   (RE)     Corrected checking for page break on report footers.


07/09/07   EntRW v6.00.102 / RepEngine v6.00.101
-----------------------------------------------------

  CS   (ER/RE)  Added support for Input Lines.


15/05/07   EntRW v6.00.101 / RepEngine v6.00.100
-----------------------------------------------------

  CS   (ER)     Amended to include the new graphics, and the new HTML Help
                Files.

15/05/07   EntRW v6.00.100 / RepEngine v6.00.100
-----------------------------------------------------

  CS   (ER/RE)  Changing version number and build for Exchequer 6.00.

15/05/07   EntRW v5.71.088 / RepEngine v5.71.089
-----------------------------------------------------

  CS   (RE)     Recompiling to pick up bug fix.

09/05/07   EntRW v5.71.088 / RepEngine v5.71.088
-----------------------------------------------------

  CS   (RE)     Formula results were not always being rounded correctly.

30/03/07   EntRW v5.71.088 / RepEngine v5.71.087
-----------------------------------------------------

  PR   (RE)     20060725160234, 20060725142013: Some formulas are not being
                calculated properly, esp. where there are negative numbers.

07/03/07   EntRW v5.71.088 / RepEngine v5.71.087
-----------------------------------------------------

  CS   (RE)     Recompiled RepEngine to pick up new CIS field.

13/02/07   EntRW v5.71.088 / RepEngine v5.71.086
-----------------------------------------------------

  CS   (ER/RE)  Recompiled RepEngine to pick up changes to CU fields, and
                corrected Help About to display the version number as read
                from the DLL.

23/11/06   EntRW v5.71.087 / RepEngine v5.71.085
-----------------------------------------------------

  CS   (ER/RE)  Recompiled to pick up Data Dictionary changes.

07/06/06   EntRW v5.71.086 / RepEngine v5.71.084
-----------------------------------------------------

  CS   (ER)    Serial Batch was still appearing in Report Wizard and Report
               Properties. This has now been fixed.

07/06/06   EntRW v5.71.085 / RepEngine v5.71.084
-----------------------------------------------------

  CS   (ER)    Removed Location and Serial Batch fields from Report Wizard
               and Report Properties.

22/05/06   EntRW v5.71.084 / RepEngine v5.71.084
-----------------------------------------------------

  CS   (ER)    Removed Location and Serial Batch fields from the Select
               Field drop-downs for IAO.

03/05/06   EntRW v5.71.083 / RepEngine v5.71.084
-----------------------------------------------------

  CS   (ER)    Updated the branding details in the About dialog.

21/04/06   EntRW v5.71.082 / RepEngine v5.71.084
-----------------------------------------------------

  CS   (ER)    Ref 20060331165051

               Range filter on THPERIOD no longer displays as a floating-point
               value when being edited before printing.

21/04/06   EntRW v5.71.081 / RepEngine v5.71.083
-----------------------------------------------------

  CS   (RE)    Ref 20060130132033
               Ref 20051220143845
               Ref 20060303093232
               Ref 20060217151811
               Ref 20060411165935

               All total fields now include the values from the last record in
               the report.

  CS   (RE)    Ref 20051212192428

               Section totals now print on the current page (if there is room)
               instead of the next page. (The totals were appearing on the next
               page if the report included more than one section header/footer,
               and one of the sections had a page break specified.)

  CS   (ER)    Ref 20060331165051

               Range filter on THPERIOD no longer displays as a floating-point
               value.

  CS   (RE)    Ref 20060124154740
               Ref 20060202140443

               Outputting reports to CSV and DBF no longer includes hidden
               fields.

               (This was previously fixed for formula fields, but not for
                database fields. It now works correctly for all fields. )

  CS   (RE)    Ref 20060302144742

               Numeric fields sent to Excel should now appear in the correct
               columns.

20/04/06   EntRW v5.71.080 / RepEngine v5.71.082
-----------------------------------------------------

  CS   (RE)    Reports now correctly include the last record in all section
               totals and grand totals.

11/04/06   EntRW v5.71.080 / RepEngine v5.71.081
-----------------------------------------------------

  CS   (RE)    Printing a report to DBF after deleting a field no longer causes
               an access violation.

05/04/06   EntRW v5.71.080 / RepEngine v5.71.080
-----------------------------------------------------

  CS   (ER)    Ref 20060118163519

               The INI file for Paper Sizes (VRWPaper.INI) has been changed. The
               new version will be shipped with the next release, and contains
               the following settings:

                 A3            297 x 420
                 A4            210 x 297
                 Letter        216 x 279
                 Executive     184 x 267
                 Legal         216 x 356
                 A5            148 x 210
                 B4            250 x 354
                 B5            182 x 257

               A3 and Legal have been added.

               Executive has been changed, as the size in the original INI file
               was incorrect. Reports which used the Executive size will need
               to be amended.

               Note that the original size for Executive was actually using the
               Legal dimensions.

  CS   (RE)    Ref 20051219134751
               Ref 20060125141029

               Where reports contain more than one section, page breaks are now
               applied to the correct sections.

  CS   (RE)    Ref 20060124154740
               Ref 20060202140443

               Outputting reports to CSV and DBF.

               When the report is outputted to CSV or DBF it no longer outputs
               hidden fields.

               Formulas with text strings and PrintIfs now work correctly when
               outputting to CSV and DBF.

  CS   (RE)    Ref 20060202154901

               Deleted fields are no longer output to CSV or DBF.

  CS   (ER)    Ref 20060202140443

               Printers can now be set for individual users (instead of using
               the default report printer from system settings).

  CS   (ER)    Ref 20060127132938

               If you change the main database after you have gone through
               the wizard, then add report properties to the report header, it
               now correctly displays the details of the new database, not the
               old one.

  CS   (RE)    Including the THCURR field in reports which are output to CSV
               or DBF now works correctly.

21/03/06   EntRW v5.70.069 / RepEngine v5.70.070
-----------------------------------------------------

  CS   (ER)    Amended the Select Database Field dialog to exclude non-IAO
               fields when running under IAO.

15/02/06   EntRW v5.70.068 / RepEngine v5.70.070
-----------------------------------------------------

  CS   (ER)    The "blank on zero" check box for field/formula properties now
               works correctly.

  CS   (ER)    When a formula name was changed, other formula fields which
               referenced the formula were updated to match, but references in
               PrintIf statements and Selection Criteria were not. This has now
               been fixed - all references are now updated.

10/02/06   EntRW v5.70.067 / RepEngine v5.70.070
-----------------------------------------------------

  CS   (RE)    In VRWReportU.pas, amended Read so that if an invalid report
               version is detected it raises an exception rather than showing
               a message.

14/12/05   EntRW v5.70.067 / RepEngine v5.70.069
-----------------------------------------------------

  CS   (RE)    Modified fix (.067) in RWOpenF for Client-Server performance
               as that code was needed by EntRW.

  MH   (ER)    Rewrote filtering code on the Select DB Field dialog as it was
               incorrectly filtering on the Form Designer SC/MC versions and
               not the actual system version.  This was causing fields like
               TLORACC to be filtered out incorrectly.


24/11/05   RepEngine v5.70.068
-----------------------------------------------------

  CS   (RE)    Corrected printing of integer values, so that they do not
               include decimal places or commas in the formatted output.

23/11/05   RepEngine v5.70.067
-----------------------------------------------------

  CS   (RE)    Removed OpenFiles from initialisation sequence (was causing
               excessive delay on start-up of Exchequer).

15/11/05   v5.70.066 / v5.70.066
-----------------------------------------------------

  CS   (RE)    Export to Excel amended to put the negative sign on the left,
               and to ensure that there are no commas or extraneous spaces in
               the numeric fields.

  CS   (ER)    For the selection of DB fields, fixed the VRW version number so
               that Job Costing fields are included when required.

13/10/05   v5.70.065 / v5.70.065
-----------------------------------------------------

  CS   (RE)    On a new install, if you added a report to the Tools menu, the
               first time you tried to print the report from the menu it gave
               an access violation. (This happened because it was trying to
               create a file in the SWAP directory, but this directory had
               not been created).


07/10/05   b570.064 / b570.064
-----------------------------------------------------

  CS   (RE)    Amended security checking so that the Tools menu does not
               give erroneous 'insufficient rights' errors.


05/10/05   b570.063 / b570.063
-----------------------------------------------------

  CS   (RE)    Sorting based on formulae now works correctly.

  CS   (ER)    Dropping a report onto an 'empty report' entry (which should add
               the dropped report into the same group and remove the 'empty
               report' entry) was not adding the report to the correct group in
               the data, leaving the Report Tree and the data out-of-sync. This
               has now been fixed.

  CS   (RE)    When cancelling the printing of a report, if the user
               you selected Yes on the Cancel, an empty message dialog was
               displayed. This has now been removed.


05/10/05   b570.062 / b570.062
-----------------------------------------------------

  CS   (ER)    Formula controls now handle the Period/Year settings
               correctly.

  CS   (ER)    The Tools Menu now uses the access rights settings for
               reports -- users cannot print reports if the report has
               been marked as hidden in the Report Tree.

               [This requires the new ENTCUSTM.DLL]

21/09/05   b570.061 / b570.061
-----------------------------------------------------

  CS   (ER)    In the Formula Properties dialog, the functions list column
               header now displays a caption appropriate to the current
               selected options (Fields, Formulae, or Functions).

  CS   (ER)    The Field Filter tab in the Report Wizard has now been changed
               to Selection Criteria.

  CS   (RE)    If() formulae now return the correct results for string
               expressions (previously the final character of strings were
               being truncated).

  CS   (RE)    Numeric field formats are now set correctly when converting
               from Windows Report Writer reports.


  CS   (ER)    Print Previewing a report from the Tools Menu was giving an
               access violation when the mouse moved over toolbar buttons.
               This is being caused by the hint system -- tooltip hints have
               now been removed from all dialogs inside the RepEngine.DLL.

  CS   (ER)    The DB Field Properties dialog now validates the field name.


21/09/05   b570.060 / b570.060
-----------------------------------------------------

  CS   (ER)    Converter reports now display the correct Main File in the
               Report Properties dialog.

  CS   (ER/RE) Converted reports now correctly populate the Type combo-box on
               the Range Filter Details dialog.

  CS   (ER/RE) Converted reports now display the file name when Report
               Property controls are added to the report.

Outstanding Issue:

  When converted reports include hidden formula and field controls, if
  there are a lot of these it will sometimes overlap them and cause
  display refresh problems.

20/09/05   b570.059 / b570.059
-----------------------------------------------------

  CS   (ER)    The Report Wizard now creates unique formula names for sub-
               total controls.

  CS   (ER)    The Range Filter List dialog now has the correct help.

  CS   (RE)    Printing a newly-created report before saving it no longer
               gives the "Could not find report entry to update" error.

  CS   (ER)    When adding the Report Properties to the Report, Range Filters
               are now marked as string formulae.

19/09/05   b570.058 / b570.058
-----------------------------------------------------

  CS   (ER)    Total Formula Names added by the wizard no longer have spaces
               in them.

  CS   (ER)    The Report Wizard now creates unique formula names for sub-
               total controls.

  CS   (ER)    The Index Range Filter details are no longer blanked out when
               the Report Properties dialog is opened.

  CS   (ER/RE) Decimal place settings are now handled correctly.

  CS   (RE)    The 'New page on section break' option now works correctly.

  CS   (RE)    Grand totals now work correctly.

  CS   (ER)    The Font Example text has now been changed to a simple
               alphabet and numbers.

16/09/05   b570.057 / b570.057
-----------------------------------------------------

  CS   (ER/RE) Changed default font from Arial 8 to Arial 9.

15/09/05   b570.056 / b570.056
-----------------------------------------------------

  CS   (ER)    Updated Help Context IDs.

  CS   (ER)    Creating a new report with a large number of sub-totals now
               puts the totals across multiple rows, and ensures that the
               lines above the totals are the same width as the totals.

  CS   (ER)    Altered the Report Tree display to eliminate the gap
               down the right-hand side.

  CS   (ER)    In the Report Wizard, the Select Fields dialog no longer
               displays the previous code in the Find Field edit box.

  CS   (ER)    The PrintCompanyName formula no longer loses characters from
               the end of the name.

  CS   (ER)    Reports were being mis-numbered when added to and moved in the
               Report Tree, which was causing various errors when moving reports
               around the tree.

  CS   (ER)    Imported and converted reports are now prevented from having
               blank report names.

  CS   (ER)    When new report groups are added, they are now correctly
               selected and scrolled into view if necessary.

  CS   (ER)    Changing a report name and description now correctly updates
               the name and description in the report itself (rather than
               just in the Report Tree).

  CS   (ER)    Tab order fixed in Report Properties dialog.

  CS   (ER)    Report Names are now forced to uppercase.

  CS   (ER)    Validation of report names has been corrected.

  CS   (ER)    Clicking on a highlighted 'Add Control' button now unselects
               the option correctly.

  CS   (ER)    Cursor keys now work in the Controls Tree.

  CS   (ER)    When controls are automatically adjusted to fit on page, the
               correct page dimensions are now used for calculating the new
               positions.

  CS   (ER)    YTD and Periods now work correctly for database fields.

  CS   (ER)    The 'Last Printed' date is now set correctly in the Report
               Tree for new reports which are printed from the Report Designer
               before being saved.

  CS   (ER)    CountField is now allowed in Print Ifs and Section Criteria.

  CS   (ER)    The correct default font is now used for new reports.

  CS   (ER)    Formulas now display the negative sign on the right-hand side,
               instead of the left-hand side.

  CS   (RE)    Totals are now take into account the Print If results.

  CS   (RE)    CountField does now works correctly when the field being counted
               has a Print If attached.

  CS   (ER)    On the Report Controls window the column labels now size and
               align correctly.

  CS   (ER)    When adding a new report through the wizard, the string formula
               tick box no longer appears on the Field Filters Properties.

  CS   (ER)    The Field List on the Report Wizard dialog now correctly
               maintains the display of the 'Total' column.

08/09/05   b570.055 / b570.055
-----------------------------------------------------

  CS   (ER)    Imported files now give the option to change the report/file name
               and description.

  CS   (ER)    Files can now be imported even if they are already in the Reports
               folder. (Note that importing a file which already exists in the
               Report Tree will create a copy of the report).

  CS   (ER)    When horizontally resizing the Control Tree window it now
               stretches the Field column, which contains formulae, rather than
               the status column.

  CS   (ER)    The Copy Report dialog now correctly displays the description of
               the report.

  CS   (ER)    When adding 'Report Property' fields, Range Filter controls are
               now displayed correctly and left-justified.

  CS   (ER)    If you select move down on a list item in the Add Report Wizard
               Sorting Screen without anything selected on the list, this
               caused a List Index Out of Bounds error. This has now been fixed.

  CS   (ER)    The DateToText now populates the formula box correctly.

  CS   (RE)    The negative sign on the right hand side of values was causing
               incorrect alignment on reports. The positioning of non-negative
               numbers has been adjusted so that negative and non-negative
               values now line up correctly.

  CS   (ER)    The Convert Form now maximises correctly.

  CS   (ER)    The Find dialog no longer displays a horizontal scroll bar.

  CS   (ER)    When adding a Formula in the Formula Editor dialog it now only
               ticks the String Formula box if the formula being added is
               actually a string formula.

  CS   (ER)    Included the ability to specify sub-total fields in the Report
               Wizard. This automatically creates sub-total formula controls
               for all the selected fields, in each section and in the report
               footer.

  CS   (ER)    NumberToText now populates the formula box correctly.

  CS   (RE)    The default size of the Print Preview form has been increased.

  CS   (RE)    Wheel support on the print preview has been improved, so that
               if you move the wheel down whilst at the bottom of the page it
               goes to the top of the next page (and the reverse for the top).

  CS   (RE)    The autocreated PageNumber and PageData formulae for new reports
               now use simple spaces instead of the <SPACE> instruction, as the
               Formula Parser now handles spaces correctly.

  CS   (RE)    On the DBF page of the Print dialog, the 'Open' option
               is no longer ticked if the option is disabled.

  CS   (ER)    When printing, the Default Font option is now disabled.

  CS   (ER)    In the Formula Editor, if the String Formula box is ticked, the
               formatting is automatically changed to right-aligned.

  CS   (ER)    In the Formula Editor, INFO[REPORTNAME] and INFO[REPORTDESC]
               have been added to the Other options.

  CS   (ER)    The Add Report Wizard now displays section names as 'Section
               Header' followed by the number (instead of inserting the number
               in-between 'Section' and 'Header'), to be consistent with
               the rest of the Visual Report Writer.

  CS   (ER)    In Report Properties, the last option text has been amended
               to refer to 'Visual Report Writer'.

  CS   (ER)    In the Formula Editor, if a formula begins with a double-quote,
               it is assumed that it must be a string formula, and the String
               Formula check-box is automatically ticked and disabled, to
               prevent the user unticking it erroneously.

  CS   (ER)    The Controls Tree dialog now includes the sort order in the
               status column of Controls Tree.

  CS   (ER/RE) Exporting a report to CSV now correctly auto-opens the file if
               the auto-open option was selected on the Print dialog.

  CS   (ER/RE) Export to XLS now includes options to include or exclude the
               various report sections.

  CS   (RE)    When exporting to HTML or PDF, lines are now exported correctly
               as lines rather than boxes.

  CS   (ER)    Export to HTML and Excel now allow the Print Preview window to
               be displayed first, and to export from there (using the Print
               button).

  CS   (ER)    The 'last printed' information is now correctly updated in the
               Report Tree.

  CS   (ER)    When changing paper sizes, the Report Designer now correctly
               forces all controls to be entirely within the new page size,
               instead of allowing them to overlap the side of the page.

  CS   (RE)    Export to DBF and CSV now includes *all* data from the report
               (except for totals), instead of just the report lines.

  CS   (ER)    When printing from the Report Tree, the buttons and menu
               options (except for Cancel and Close) are disabled until the
               report finishes printing.

  CS   (ER)    When a sorted DBField is edited, its data dictionary field is
               changed, the section header/footer is now updated immediately.

  CS   (ER)    In the DB Field Properties dialog the Percentage tick-box is now
               only available for float fields.

  CS   (ER)    In the DB Field Properties dialog and the Formula Editor dialog,
               the Percentage tick-box is now set correctly when the dialog is
               displayed.

  CS   (ER)    In the Formula Editor dialog, for string formulae the Percentage
               and Blank If Zero options are now disabled.

  CS   (ER)    In the Controls Tree the only option now available for deleted
               controls is Restore.

  CS   (ER)    All the dialogs have been amended to display correctly when
               Large Fonts or Extra Large Fonts are selected in Windows'
               display settings.

  CS   (ER/RE) When report sections are deleted in the Controls Tree, any
               remaining sections are renumbered so that sections are always
               numbered consecutively.

01/09/05   b570.054 / b570.054
-----------------------------------------------------
  CS   (ER)    Formula Properties dialog no longer shows deleted fields and
               formulas in the list.

  CS   (ER)    'Disabled' images included for toolbar buttons.

  CS   (RE)    Mouse-wheel now works in Print Preview.

  CS   (RE)    Print Preview now has the correct Report Writer icon.

  CS   (RE)    Help buttons added to Print dialog and Range Filter dialogs.

  CS   (ER)    Under Windows XP, with the XP Theme in use, the Field Selection
               dialog was not displaying correctly when called from the Field
               Properties dialog. This has now been fixed.

  CS   (RE)    Section footers are now printed in the correct order.

  CS   (RE)    Totals and grand totals now work correctly.

  CS   (RE)    Section headers are now only printed on the relevant section
               breaks, instead of printing at any break.

  CS   (RE)    Controls which are restored after being deleted were not being
               saved.

  CS   (RE)    If a background bitmap is included which covers the entire
               Report Lines section, white bands were appearing between the
               report lines. This has now been fixed.

  CS   (RE)    If the user attempts to load a large bitmap (>1Mb) into a
               report, they are warned and given the chance to abort.

  CS   (ER)    On the Controls Tree dialog, the right-click menu sometimes had
               the wrong options enabled (esp if going from a right-click on
               a formula control to a right-click on a field control). This
               has now been fixed.

  CS   (ER)    The Controls Tree window now maximizes correctly, filling the
               whole desktop area except for the Windows taskbar.

  CS   (ER)    The Control Tree 'regions and controls' display no longer goes
               off the bottom of the dialog.

  CS   (RE)    Copying a totalling formula from one section to another, or
               dragging a totalling formula from one section to another, now
               procedures correct totals.

  CS   (ER)    The String Formula checkbox now only appears when editing a
               formula, and does not appear for the Selection Criteria or
               Print If dialogs.

  CS   (RE)    The Range Filter type can now be changed on the Range Filter
               Details dialog from both the control and the Report Range
               Filters dialog.

  CS   (RE)    The "?" context help button has been removed from the Control
               Trees dialog, as Windows does not correctly handle context help
               buttons for resizeable dialogs.

31/08/05   b570.053 / b570.053
-----------------------------------------------------
  CS   (ER)    Fonts made consistent across all dialogs.

  CS   (ER)    Application icon replaced.

  CS   (ER)    Report region icons on Report Controls tree fixed.

  CS   (ER)    Ensured that right-click menu on Report Controls is only
               available when controls are selected.

  CS   (ER)    Removed Font option for image controls.

  CS   (ER)    Removed the option to delete non-section-break regions.

  CS   (ER)    Updated the 'delete' caption on the right-click menu so that
               it displays 'restore' for deleted controls.

  CS   (ER)    Removed gap from multilist (in Create Report wizard).

  CS   (ER)    Corrected 'move up' and 'move down' options on multilists in
               Create Report wizard.

  CS   (ER)    Added highlighting to 'add control' icons on the toolbar, so
               that the currently selected control type is visible.

  CS   (ER)    Corrected the display of the 'delete' option on the Report
               Designer menu.

  CS   (ER)    Added user-confirmation to the 'cancel' for the Create Report
               wizard.

  CS   (ER)    Ensured that box controls update as soon as their properties
               are changed.

  CS   (ER)    Removed the invalid line types when a line width other than
               1 is selected, in the Line Properties dialog.

  CS   (RE)    Prevented hidden regions from printing.

  CS   (ER)    Added automatic detection of string functions.

  CS   (RE)    Defaulted the Refresh Start and End Records values, for Report
               Properties.

  CS   (ER)    Ensured that the Edit Filter option on the Report Properties
               dialog is only available when required.

  CS   (RE)    Ensured that total fields are correctly copied over when
               converting old reports.

  CS   (RE)    Corrected the positioning of footer sections.

  CS   (ER)    Restricted the security rights for the SYSTEM user, so that
               they only have access to Security, Find, and Close.

  CS   (RE)    Corrected the handling of PrintIf filters where there is more
               than on control against the same database field.

  CS   (ER)    Prevented the 'Status bar' caption from appearing in the Report
               Designed status bar.

  CS   (ER)    After adding a control, it is now automatically selected.

  CS   (ER)    Changing a formula name now updates other references to that
               formula.

  CS   (ER)    Formula names are no longer case-sensitive.

  CS   (RE)    Report Footers are now at the end of the report, instead of
               below the last Page Footer

  CS   (ER)    Clears the index filter if the report index is changed (on the
               Report Properties dialog).

  CS   (ER)    Enabled the 'edit' option for groups.

  CS   (ER)    Corrected copying of new reports in the Report Tree.

  CS   (ER)    Adding controls via the Controls menu, or using the short-cut
               keys now works correctly.

  CS   (ER)    Report Properties now cannot be accessed while printing.


22/08/05   b570.052 / b570.052
-----------------------------------------------------
  CS   (ER)    Dbl-click folders on Report tree no longer launches 'edit'.

  CS   (ER)    Controls Tree -- fixed AV on clicking +/- button if row not
               highlighted.

  CS   (ER)    Controls Tree -- buttons not enabled if row is not highlighted.

  CS   (ER)    Prevented Windows from reporting app as Not Responding when
               loading a large report.

  CS   (RE)    TotalFields now total correctly.

  CS   (RE)    Formula controls now have default formula name.

  CS   (ER)    The Designer now shows the formula name, not the definition.

  CS   (RE)    Text Fields now default the text to blank, instead of the
               control name.

  CS   (RE)    Formula controls now default to right-align, and 2 decimal
               places.

  CS   (RE)    Importing old reports -- correct brackets added to TotalField
               formulae.

  CS   (RE)    Formulae are now renamed on paste.

  CS   (ER)    'Force controls on-page' prevented from activating erroneously.

  CS   (RE)    Colours are now printed on the report.

  CS   (ER)    Controls Tree -- Delete Region now works from pop-up menu.

  CS   (ER)    Formula names no longer allow spaces.

  CS   (RE)    Copy Report now renames the underlying report.

  CS   (ER)    Editing Group Headers trims any extraneous spaces from the name.

  CS   (ER)    Copy Report no longer allows spaces, and renumbers consistently.

  CS   (RE)    Report Header Fields (company name, etc.) now appear in the Page
               Header, not the Report Header.

  CS   (ER)    Fields and formulae allow % signs to be included.

  CS   (ER)    Move, print, edit and copy buttons are now disabled if the actual
               report file (.ERF) is missing.

  CS   (ER)    Help About now shows Exchequer and IRIS Enterprise Software.

  CS   (ER)    Editing of report description field fixed to 255 characters.

  CS   (ER)    Report window and Find Report window amended to be XP friendly.

  CS   (ER)    Right Click Print now enabled on Report Tree.

  CS   (ER)    Report Defaults within VRW Properties now update the Report Tree.

  CS   (ER)    Restore Default Position added to right-click menu for Report
               Tree.


21/07/05   b570.051 / b570.051
-----------------------------------------------------

*** MAY-JULY - Major rewrite of Designer (MH) and Back-End (CS) ***


13/05/05    EntRW v5.61.045 / v5.61.041
-----------------------------------------------------
  CS   (RE)    Attempting to print a report from the Tools menu when the report
               has been deleted from the report tree now displays a 'failed to
               load report' error instead of an exception.

13/05/05    EntRW v5.61.045 / v5.61.040
-----------------------------------------------------
  CS   (ER)    Adding a subgroup to a previously empty group was losing the
               subgroup. This now works correctly.

       (ER)    Empty groups can now be deleted.

       (ER)    Group descriptions are now correctly copied into the group
               header edit dialog.

       (ER)    The group header edit dialog now validates the group name, and
               will not allow it to be blank, or to be the same as another
               group's name.

       (ER)    The report wizard's handling of 'next', 'cancel' and 'finish'
               has been changed so that the cancel option is always available.

       (ER)    The Report Properties dialog has been hidden from the end user
               (but is still available for debugging).

10/05/05    EntRW v5.61.044 / v5.61.040
-----------------------------------------------------
  CS   (ER)    Corrected display/resize of Report Tree window when using
               Windows Themes.

       (ER)    Changed display of 'Cancel Drop' button, and added equivalent
               pop-up menu option.

09/05/05    EntRW v5.61.043 / v5.61.040
-----------------------------------------------------
  CS   (ER/RE) Changed Move/Drop functionality on Report Tree to correctly
               take into account reports/groups which are hidden because of
               security.

  CS   (ER)    Changed Report Tree to allow Move/Drop to be cancelled.

  CS   (ER)    Changed Report Tree to display user-friendly message if the
               user tries to create a group header with a name which is already
               in use.

05/05/05    EntRW v5.61.042 / v5.61.039
-----------------------------------------------------
  MH   (ER)    Changed the Text Properties dialog so that it appears over the
               text control unless that would take it off the sides of the
               screen.

  MH   (ER)    Changed the Text Properties dialog so that the Font button is
               shown all the time instead of only if you double-clicked on the
               control to access the dialog.

  MH   (ER)    Changed the Formula Name/Notes dialog so that it appears over
               the forumla control unless that would take it off the sides of
               the screen.

  MH   (ER)    Added a help menu into the Report Designer window for users
               who don't know about the F1 key.

  MH   (RE)    The Print menu option on the popup menu in the Preview Window
               didn't work.

  MH   (ER)    Set Report Properties dialog to center over designer window -
               WLR 20050429132610

  MH   (ER)    Fixed bug in Range Filters List under XP where Delphi wasn't
               vertically resizing the list correctly when the form loaded,
               turned off auto-resizing and manually coded it - WLR 20050429104735

  MH   (ER)    Corrected minor sizing bug in Report Display Properties dialog
               under Win XP.

  MH   (ER)    Removed blank area around right/bottom sides of DB Field Properties
               dialog, added the help icon into the caption and separated the button
               panel from the frame in the fields tab.

  CS   (ER)    Rewrote Report Tree. Replaced SBSOutline Report Tree with
               Virtual Tree View component. Reproduced original functionality,
               and added improved handling for re-arranging the report tree
               structure.

  CS   (RE)    Replaced data access classes. Amended original data access
               routines to use the new versions (so that adding reports
               via Tools | Options still works, even though it uses the old
               routines).

27/04/05    EntRW v5.61.041 / v5.61.038
-----------------------------------------------------
  MH   (RE)    Changed TAccessFilter.UpdateTotals to detect a TotalField on a
               non-existant DB Field and to set it to 0, instead of crashing
               with a Range Check Error.

  MH   (ER)    Fixed a bug in the Formula dialog which meant that it was listing
               the formula being edited in the formulas section so you could
               write recursive forumulae.  (TfrmDesignWindow.BuildControlList)

  MH   (ER)    Modified the Report Tree to correctly set the path for Settings.Dat.


26/04/05    EntRW v5.61.040 / v5.61.037
-----------------------------------------------------
  MH   (ER)    Continued rewrite of the Sections dialog interupted by the training
               course submission:-

                 * Rewrote the Swap Sections code as it failed completely when
                   working on sections created by the Add Report Wizard.

                 * Rewrote the Remove Sections code as it failed completely when
                   working on sections created by the Add Report Wizard. (Deju Vu!)

                 * Added in a check to stop users hiding ALL the sections which
                   caused the designer to crash with an EStringList error - "List
                   Index Out of Bounds".

  MH   (ER)    Modified TfrmDesignWindow.ReorderReportRegions which is used after
               the Sections dialog has closed as it was causing Access Violations
               if two sections had been switched around.

  MH   (ER)    Modified TfrmDesignWindow.AddRemoveHeaderFooter as it was causing
               a 'List Index Out Of Bounds' error if you removed a Section in the
               Sections dialog on a new report that hadn't been saved.

  MH   (ER)    Made some changes to Range Filters so the List is more likely to
               appear when you have a corrupted Range Filter.

  MH   (ER)    Modified TfrmDesignWindow.BuildReport which creates the report
               after the Report Wizard as the memory used for DBFields in the
               LINES section of the report wasn't being initialized correctly -
               this was a POSSIBLE cause of a corrupt range filter I had got
               whilst testing on 25/04.

  MH   (ER)    Fixed a bug in the code used to create the regions/sections when
               loading a report.

               Basically the code was assuming that sections started from 1 and
               ran sequentially, however I had a report where I had sections 1-3
               and deleted section 1 leaving 2 & 3, when reloading the report
               they came in as 1 & 2 but as section 1 didn't exist in the file
               it was invalid.  After going into the sections dialog and coming
               out the invalid section 1 just disappeared.

  MH   (ER)    Modified the code creating the report controls as it was leaking
               multiple 2k memory blocks and incorrectly freeing memory that was
               still in use, potentially causing corruption, strange errors or
               Access Violations.  

  MH   (ER)    Added the places bar onto the Import Report dialog. 

  MH   (ER)    Added Context Help icon to following windows:-

                 Sections window off Report Designer


25/04/05    EntRW v5.61.039 / v5.61.036 (Submitted for training course)
-----------------------------------------------------------------------
  MH   (ER)    Changed loading of Report Tree as the 'Empty Folder' items were
               missing their parent information, this caused items added after
               selecting the 'Empty Folder' to appear in the root.

               NOTE: Adam was getting them to appear randomly around the tree.

  MH   (ER)    Modified the code on the DB Field Range Filter menu option as it
               was setting the Input Line name if blank, but this was causing
               various problems when printing the report if the dialog was
               cancelled.  Now if it sets the name but the dialog is cancelled
               it will blank the name again.

               NOTE: I think this is because Andy was using the name being set
               to indicate whether the Range Filter is defined or not, if the
               dialog was cancelled the name is set but everything else is still
               blank.

  MH   (RE)    Made changes to the initialisation of the report engine in
               TAccessFilter.BuildSelection when printing a report to supress
               the dodgy range filters caused by the item above.  This may also
               fix the EInvalidInput errors.

  MH   (ER)    Modified the SWAP button in the report sections dialog as at my
               resolution (1152x86) the popup menu was appearing by the right
               hand edge of the screen rather than over the button.

               NOTE: There was a horrid bodge in the code which probably made
               it appear correctly at whatever resolution Andy was running!

  MH   (ER)    Rewrote the Sections dialog off the Report Designer as it was
               suffering from an acute case of crapness, I'm not sure if anything
   NOTE:       except the close button was working 100%.
   THIS
    IS         The buttons were not enabling correctly and if you added a new
   STILL       section on a new report you got 'This sort has already been defined'
    IN         and 'List Index out of Bounds' errors when exiting the dialog.
 PROGRESS
               Basically Andy was defining the Section Header Names in two
               completely different ways - from the Designer it was "SECTION1HEADER"
               and from the Wizard "Section 1 Header (ACACTYPE)" - most of the
               code handled the former and screwed up with the latter.

               NOTE: I don't think I've ever seen so much crap code in such
               a small space before, if we could patent the compression system
               we could make a fortune :-)

               NOTE 2: This dialog needs totally retesting.


18/04/05    EntRW v5.61.038 / v5.61.035
-----------------------------------------------------
  MH   (ER)    Changed AddReportPropertiesText to properly initialise the controls
               created when the 'Print Report Properties' option is used.  This was
               probably causing the 'corrupt' range filters experienced.

  MH   (ER/RE) Changed the Range Filter List window as it was sometimes displaying
               corrupted values when the From/To Range Field was left blank.

  MH   (ER/RE) Changed the Range Filter Detail window as the exit field was only
               firing if the current control wasn't the OK button, this should
               have been the Cancel button.

               NOTE: This only caused a problem when printing the report as the
               "Always ask the user for input" field was disabled and this
               caused the foxus to move straight to the OK button.

  MH   (RE)    Fixed a typo in the Range Filter Detail window which meant the popup
               Department List on exiting the control didn't popup.

  MH   (RE)    Changed the Continue/Close button in Range Filter List when printing
               to prevent the window being closed if any Range Filters are still
               blank or Start > End value.

               NOTE: This can only check those that appear in the list.

  MH   (RE)    Changed description on Close button in Range Filter List when
               printing to Continue.

  MH   (ER/RE) Changed the Range Filter Detail window to check that the Start value
               is <= the End Value.

  MH   (ER)    Added the Help icon into the caption bar of the Report Writer Properties
               dialog available on the File Menu in the RepTree to see if that solved
               David's problems with not understanding F1.

06/04/05    EntRW v5.61.037 / RepEngine v5.61.034
-----------------------------------------------------
  MH   (ER)    Corrected the loading of the Report Tree so that it didn't say
               'no description' for reports without a description.

  MH   (ER)    Added the ability to save the size/position of the Report Tree.

  MH   (RE)    Modified the saving of Groups to uniquely set the Group Id
               Number which should fix the multi-user problem of adding
               groups simultaneously on different workstations.


06/04/05    EntRW v5.61.036 / RepEngine v5.61.033
-----------------------------------------------------
  MH   (ER)    Removed debug message from Report Tree Security, I'd seen it so
               many times the message had become part of the system :-)

  MH   (RE)    Removed unnecessary Open_File, Make_File, Close_File calls from
               TReportPersistor.AddToReportTree which was causing the report
               tree to sometimes blank after saving a report.

  MH   (ER)    Changed the Tree Security to default to highlghting the settings
               column


05/04/05    EntRW v5.61.035 / RepEngine v5.61.032
-----------------------------------------------------
  MH   (ER)    Removed unneeded duplicate RptTreeF.Pas from EntRW project and
               moved source into OLD directory.  Only needed in RepEngine project.

  MH   (ER/RE) Totally rewrote Report Tree Security from scratch, the security
               is in a new data file VRWSEC.DAT which is automatically created
               on startup.

  MH   (ER/RE) Major modifications to btrieve file handling to stop the clash
               with Enter1.Exe's Btrieve Reset on startup causing the 14 second
               delay on Client-Server installs.
               *** Requires total retesting of VRW to ensure it all works ***

  MH   (ER)    Rewrote Find Report dialog off Report Tree, it now works using
               the data in the report tree which includes user security whereas
               before it used the raw RWTree data file which didn't, causing the
               user to see reports they shouldn't.

  MH   (RE)    Made changes to ParseDependancy in TAccessFilter.BuildSelection
               as it wasn't overwriting the original formula when expanding
               sub-formula's that referenced sub-formula's (or something like that!)

  MH   (ER)    Fixed exception going into Formula Control - probably caused by
               recent mods, but you never know...

  PR   (RE)    Fixed problem with tlLineNo and other integers always showing as zero. 

  MH   (ER)    Added a Defaults button into the Report Properties dialog which
               removes the custom colour / font settings


22/03/05    EntRW v5.61.034 / RepEngine v5.61.031
-----------------------------------------------------
  MH   (ER)    Enabled security menu option if /DEBUG param is passed into EntRW.Exe
               to allow testing.

  MH   (ER/RE) Added in Debug menu with Dump Report Tree File option for debugging
               purposes.

  MH   (RE)    Fixed ERangeError in ParseDependancy in DBAccessFilter caused by a
               formula being expanded past the 255 character limit of ShortString.
               Need to convert it to use ANSIString at some point in the future.

  MH   (ER)    Modified sizing of Report Properties dialog by a few pixels so it
               looked better under XP.

  MH   (ER)    Totally rewrote the Range Filter list and Detail window to support
               the Index Range Filter, fixed misc bugs with Value, Date, Period &
               Ccy Range Filters which probably didn't work previously.

  MH   (ER)    Changed the DBField control to use the new Range Filter Detail window.

  MH   (ER)    Changed the Report Properties dialog to use the new Range Filter
               Detail window instead of allowing direct editing.

  MH   (ER)    Narrowed the Description Column on the Formula dialog so you don't
               get a horizontal scrollbar when the vertical scrollbar appears.

  PR   (ER)    Fixed range check error in engine validatefilter function.

  MH   (ER)    Modified the Report Tree to load reports with no parent, this can
               be caused by having 'Empty Folder' selected when you add a report.
               These reports will appear in the root of the Report Tree at the
               bottom.

  MH   (ER)    Fixed bug in Report Tree where Move would chop the end of the
               filename off internally so the report file (ERF) can't be found.
               NOTE: Manually renaming the .ERF so it is 20 characters long will
               reconnect it up.

  MH   (RE)    Modified the Print Dialog as under Local Program Files it was
               causing an OLE Exception when it tried to open the data files in
               the application directory (the LPF dir!) using the COMTK to pickup
               the users printer.

  MH   (ER)    Made a couple of blind fixes to the Add Report Wizard hoping to
               fix the intermittent corrupt range filter problem.  Not hopeful :-(

  MH   (ER)    Modified the Range Filtering so that Period fields, e.g. THPERIOD,
               only allow a Value filter to be specified against them, which should
               work whilst avoiding the problems caused by the Period/Year filter.

  PR   (RE)    Fixed problem with sorting on value field putting zero before -ve
               values

  PR   (RE)    Fixed problem with date range filters not working

  PR   (RE)    Fixed problem where period/year range filter wasn't working for <2000

  PR   (RE)    Range filters on fields with period/year weren't working - fixed.


15/03/05  EntRW      v5.61.033
---------------------------------
  MH      Fixed problem where the reports Last Printed date/time was failing
          to set.

  MH      Fixed 'Invalid Outline Index' error when closing the designer
          window.

  MH      Modified the Report Tree so several functions actually remember
          where you were and reposition you correctly in the tree after it
          is refreshed.


15/03/05  EntRW      v5.61.032
---------------------------------
  MH      Rewrote the RefreshReportTree routine which loads the Report Tree
          in an attempt to avoid all the 'Invalid Outline Index' type errors
          that the existing routine was giving us.

  MH      Modified the popup menu handling as the 'Drop' item was incorrectly
          available when positioned on 'Empty Folder' items, which caused the
          dropped report to go MIA.


14/03/05  EntRW      v5.61.031
          RepEngine  v5.61.030
---------------------------------
  MH      Changed the Report Tree file structure (RWTREE.DAT) to allow 4 chars
          to be used for the Report Id & Parent Id giving us 9,999 reports
          before we have a problem.  This mod will require the users to delete
          RWTREE.DAT and RWUSER.DAT.


14/03/05  EntRW      v5.61.030
---------------------------------

  MH      Modified the Drop command on the Report Tree to collapse the node
          being moved as it appeared to cause misc 'Index Out Of Bounds'
          errors when moving an open folder down the tree.  Up seemed OK!


11/03/05  EntRW      v5.61.029
          RepEngine  v5.61.029
---------------------------------

  MH      Fixed integer overflow errors in the print to DBF routines caused by
          their being more than 32767 rows of data in a report.

  MH      Fixed the File|Find menu option on the Report Tree which previously
          didn't do anything, now it does something :-) 

  MH      Updated Help Menu on Report Tree to include standard help items.

  MH      Removed unneccessary Help Menu on Designer Window.

  MH      Coded Help Context Id's across all forms.

  MH      Fixed Access Violation in the Enter->Tab conversion component used by
          the Report Wizard which intermittently occurred after going back a
          step and pressing F1 for the help.

  MH      Added descriptive text by the Range From/To fields on the Report Properties
          to describe the expected data.

  MH      Changed the Report Tree Caption & Application Title to our standard format
          and changed the Report Designer window caption to 'Report Designer'.

  MH      Added a standard Help|About dialog containing the EXE & DLL version numbers.

  MH      Fixed the minimum size and resizing code on the Report Tree as Andy's version
          sucked and was running the progress bar into the tree control at the bottom
          and leaving a nasty space across the bottom.


10/03/05  Preview 2.28
-----------------------------

  MH      Modified the Report Wizard and the DB Field control as the Print If
          and Record Selection code was duplicated their and still using Lines[0]
          to access the Formula memo meaning that any subsequent lines were being
          list.

  MH      Added a Range Filter into the Report Properties for the indexing.  In
          this initial version it is a basic version without support for popup
          lists in order to meet the 14/03/05 deadline.  The Range Filter will
          not appear in either the Range Filter list off the report designer
          window or off the Range Filter list when the user prints a report.

  MH      Removed Beta Warning at startup because having to accept that dialog
          every freaking time I ran it up under Delphi to test something was
          causing me to get extremely p'd off with the whole thing!

  MH      Temporarily hid the Security menu option off the Report Tree as we are
          99% sure it isn't working properly and don't have time to test and fix
          it.

  MH      Modified the handling of Period/Year range filters as the information
          was being incorrectly passed into Paul's data selection engine.

  MH      Fixed numerous Range Check errors in the printing routines caused by
          their being more than 32767 rows of data in a report.


09/03/05  Preview 2.27
-----------------------------

  PR      Amended engine to allow Period/Year to be used on calculated fields.

  PR      Fixed problem causing ConvertError in report on Stock Locations. Caused by engine
          not correctly checking key and reading Bin records.

  MH      Modified the Formula Dialog to include Period/Year/Currency fields which
          will apply to all DBFields directly referenced within the Formula.

  MH      Modified TAccessFilter.BuildSelection to pass the new Period/Year/Currency
          fields on Formula Controls into Paul's printing engine.  

  MH      Modified the Formula Dialog so that it correctly handles multi-line
          formulae, previously it had been written to only process the first line.

  PR      Trunc function wasn't correctly parsing formulas - eg Trunc(FML[Blah]).



08/03/05  Preview 2.26
-----------------------------

  PR      Fixed problem where IF function would only evaluate first part of multi-part condition.

  PR      Fixed problem in the parser which was giving an erroneous validation error
          for formulae like (a > b) and (c < d) (+ others)

  PR      Modified date routines (DateToNumber, FormatDate) to return zero for
          invalid dates as previously they were raising exceptions.

  HM      Modified the printing routines to use #9 internally instead of ~
          as a separator as any strings including a ~ within the result will
          cause the column to be shifted incorrectly.

  HM      Fixed two range check errors in the totalling routines caused by me
          putting brackets around the parameters on the TotalField call.

  HM      Modified TAccessFilter.GeneratePrintableData and TReportGenerator.PrintRegion to
          handle formulae of type CALC_FIELD which had previously been ignored meaning that
          formulae like "FML[Formula1] - FML[Formula2]" didn't work.

  HM      Modified TReportGenerator.PrintRegion to correctly handle the justification
          and blanking formatting commands as previously it had been incorrectly coded
          to assume incorrect character positions.

  HM      Removed "C-" formatting from the Formula and DB Field dialogs as it isn't
          supported in the existing code and would be complex to implement correctly.

  HM      Limited the range of decimal places to 0..6 for Formula and DB Fields.

  HM      Modified the processing of forumlae (DbAccessFilter-ParseDependancy) to remove
          the leading quote/tilde off formula being brought into other formula as that
          was breaking the parsing routines.

  HM      Modified the processing of forumlae (DbAccessFilter-ParseDependancy) to not
          put brackets into expanded string formula, e.g. "(DBF[ACACC] + DBF[ACCOMP]),
          as that was breaking the parsing routines.

  HM      Extended for formula and filter string lengths in VarRecRP.ReportDetailType
          from 100 to 255 and added a new Range Filter string so that the VRW doesn't
          have to overwrite the Selection Criterion any more.

  HM      Modified the Formula dialog to get rid of problems with Formula's including
          the '#' character in their name.

  MH      Fixed "List Index Out Of Bounds" error adding a report after printing a report.

  MH      Fixed 96k memory leak in DB Fields dialog

  MH      Fixed several memory leaks in Add Report Wizard

  MH      Modified the printing routines to default the Print To dialog to the users
          personal Report Printer.

  PR      Fixed problem in condition evaluator where 'equals' would return success on a partial match.

  PR      Increased length of all strings used in formula and condition evaluating to 255.

  MH      Added a check on the COMTK version into startup as it was crashing with an
          'Interface not supported' error message if the registered COMTK was an older
          version.

  PR      Added RangeFilter property to TRWFieldObject.

  PR      Added PeriodFrom/To & YearFrom/To properties to TRWInputField object.

  MH      Modified the Import Report routine to correctly set the report name.
  

03/03/05  Preview 2.25
-----------------------------
  HM      Modified the designer window so that it recovers from errors when
          printing a report allowing the report to be saved and the window
          to be closed.

  PR      Modified the handling of the scratch file to ensure that we use
          a new scratch file each time.  This is an attempt to avoid various
          error 22's and error 5's in the scratch file, we were unable to
          identify the exact cause of the problems.

  HM      Fixed a Range Check Error in printing that was crashing reports.

  HM      Modified the Period field on the DB Field dialog to be uppercase
          only.


02/03/05  Preview 2.24
-----------------------------
  HM      Rebuilt to pickup fixes to Formula parsing done by Paul.

  HM      Made the formula memo word wrap!   Wow!  Oooh!


01/03/05  Preview 2.23
-----------------------------
  HM      Auto-create the SWAP directory on startup to prevent exceptions

  HM      Added checking of the module release code to ensure the user has
          a licence to run the VRW

  HM      Added checking of the users permissions to ensure the user is
          allowed to use the VRW

  HM      Added the COMTK backdoor routines so we don't need a runtime licence

  HM      Modified TAccessFilter.Create so it isn't creating the unnecessary
          RepExLocal object which opens all the files and is never destroyed
          causing memory and file handles to leak.  Probable cause of err 87's.

  HM      Modified RepExLocal.Destroy to close the global files opened in the
          create, previously they were being left open and leaking file handles,
          probable cause of err 87's.

****************************************************************************)

end.
