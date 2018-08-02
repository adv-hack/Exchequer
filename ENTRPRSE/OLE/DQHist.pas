unit DQHist;

interface

Function DataQueryVersion : ShortString;

Implementation

Uses Brand, ExchequerRelease;

Const
  // Excel Data Query Build Number
  BuildVer_DQ = '022';   // EntReg Build Number - common across Exch & IAO

  // NOTE: The build number should be incremented for any new version leaving
  // the department, even if just to QA for testing.

// Current Data Query Engine version for Exchequer|IAO
Function DataQueryVersion : ShortString;
Begin // DataQueryVersion
  {$IFDEF EXEVER}
    Result := ExchequerModuleVersion (emExcelDataQuery, BuildVer_DQ + ' (EXE)');
  {$ELSE}
    Result := ExchequerModuleVersion (emExcelDataQuery, BuildVer_DQ + ' (DLL)');
  {$ENDIF}
End; // DataQueryVersion


(*****************************************************************************

Exchequer Data Query Wizard
======================================

Build 022   29/11/2016
----------------------------------------------------------------------------
  MH        ABSEXCH-17754
              * Corrected size of Login dialog to correspond with branding bitmaps
              * Removed borders / captions as per Excchequer Login dialog
            

Build v7.0.14.021  29/05/2015
----------------------------------------------------------------------------
  MH        Updated for copyright/company name changes


Build v7.0.8.020  28/11/2013
----------------------------------------------------------------------------
  MH       ABSEXCH-14797: Extended for Customer/Consumer filter


Build v7.0.5.019  10/07/2013
----------------------------------------------------------------------------
  CA       Rebranded for Advanced


Build v7.0.2.018  12/03/2013
----------------------------------------------------------------------------
  CA       ABSEXCH-13290: Added Login dialog and checks on user permissions


Build v7.0.017  10/09/2012
----------------------------------------------------------------------------
  MH       Updated for v7.0 version & branding


Build v6.4.016  08/09/08
----------------------------------------------------------------------------
  MH       Added .Exe variant for Excel 2010 64-bit support - 64-bit processes
           cannot load 32-bit In-Process COM objects.  Modified .Exe variant to
           use In-Process COM Toolkit to improve performance.

           Modified Help to point to EnterOLE.Chm.


Build 015  08/09/08
----------------------------------------------------------------------------
  MH       Modified to use Out-of-Process COM Toolkit (.EXE) to avoid issues under
           SQL with creating the .DLL toolkit.


Build 014  13/02/08
----------------------------------------------------------------------------
  MH       Fixed problem in ImportF1 where it was checking for ExchqSS.Dat in the
           company directories, this caused an access violation under SQL as no
           companies were being listed.

  MH       Corrected fonts on dialogs to Arial.


Build 013  08/11/07
----------------------------------------------------------------------------
  MH       Rebuilt for v6.00


Build 012  31/03/06
----------------------------------------------------------------------------

  MH       Took minimise/maximise buttons off wizard dialogs

  MH       Corrected Help Context Id's

  MH       Added dynamic branding so it works for IAO and Exchequer


v5.70.011  28/07/05
===================
  MH   Rebranded and changed verno

v5.61.010  02/02/05
===================
  HM   Released for v5.61


b561.010  15/08/04
==================
  HM   Changes to how the licence is loaded for VAO Compatibility


b560.009  09/08/04
==================
  HM   Added CMDialogKey system to the three forms in the wizard to convert
       Enter keys into Tab keys.  The usual system for Enter->Tab didn't work.


b560.008  09/08/04
==================
  HM   Corrected MaxLength settings on filter dialog, most were set to 6 except
       for CC/Dept (3), Accounts (6) and Stock (16).
     

b560.007  17/06/04
==================
 HM  Extended Job Import to allow filtering by Job Status

v5.60.006  14/05/04
===================
 HM  Released for v5.50


v5.52.006  18/11/03
===================
 HM  Released for v5.52


v5.51.006  27/06/03
===================
 HM  Released for v5.51


v5.50.005  24/03/03
===================
 HM  Released for v5.50


b550.005   31/01/03
===================
HM   Updated version for v5.50 Beta CD

HM   Rebuilt to pickup D6 TListView fix for Windows XP

b501.004   20/01/03
===================
HM   Modified the Filter Criterion for Job Parent Codes and Stock Parent
     Codes to allow root items to be imported by specifying a blank parent

b501.003   03/12/02
===================
HM   Modified the Filter Criterion dialog as the bitmap wasn't sizing
     correctly for GL, Job and Stock Filters.


b501.002   19/11/02
===================
HM   Modified the GL Parent Code validation to allow 0 to be specified as
     a parent so root GL Codes can be imported.


b501.001   18/11/02
======================
HM   Initial release after development

*****************************************************************************)

end.
