unit History;

interface

Const
  // Drill-Down COM Object Version Number
  DrillDownVer = 'b551.033';       // BETA Version
  //DrillDownVer = 'v5.51.029';    // RELEASE Version

  // NOTE: The build number should be incremented for any new version leaving
  // the department, even if just to QA for testing.

implementation

(****************************************************************************

VERSION HISTORY
===============


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
