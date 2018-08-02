unit History;

interface

Const
  // CD Licence Generator Build Number
  CurrVer_CDGenLic = '361';
  //
  // NOTE: The build number should be incremented for any new version leaving
  // the department, even if just to QA for testing.

  // Versions of Enterprise supported by this Licence Generator
  EntVersions = '2018 R1';


implementation

(****************************************************************************

VERSION HISTORY
===============

Build 360 - 19/09/2016
--------------------------------------------------------------------------------
  MH    ABSEXCH-17720: Protect Auto-Upgrade licences using a command-line switch /SupportAutoUpgrade


Build 359 - 03/12/2014
--------------------------------------------------------------------------------
  MH    ABSEXCH-15896: Modified Edit Licence so that it doesn't turn on Full Stock on the
        Exchequer Version dialog

        ABSEXCH-15897: Extended details written to LicLog.csv to include the database type on
        the end of the Exchequer Edition, e.g. Global/SOPS/CS/25/MSSQL 


Build 358 - 12/07/2013
--------------------------------------------------------------------------------
  MH    Removed 'Iris' from application names on Installation Type dialog


Build 357 - 16/11/2012
--------------------------------------------------------------------------------
  MH    v7.0 - Added Small Business Edition support


Build 356 - 31/03/2010
--------------------------------------------
  HM    Added ability to Edit existing licences to correct details


Build 355 - 22/07/08
--------------------------------------------
  HM    Modified to automatically disable the Windows Report Writer module for new install licences


Build 354 - 30/01/08
--------------------------------------------
  HM    Rebuilt at request of QA (I think they have lost 353!)


Build 353 - 05/11/07
--------------------------------------------
  HM    Extended Max Company Count from 999 to 9999


Build 352 - 21/09/07
--------------------------------------------
  HM    Extended Auto-Upgrade to have a Pervasive.SQL and MS SQL Server variants,
        this is required so that the installer knows which DB to use.


Build 351 - 24/04/07
--------------------------------------------
  HM    Modified Importer Licensing to support 30-day


Build 350 - 06/03/07
--------------------------------------------
  HM    Modified for v6.00 licence changes


Build 322 - 09/01/07
--------------------------------------------
  HM    Added Outlook Dynamic Dashboard


Build 321 - 30/10/06
--------------------------------------------
  HM    Corrected spelling of eBanking and eBusiness


Build 320 - 26/10/06
--------------------------------------------
  HM    Added eBanking module support, appended to end of LicLog.Csv


Build 319 - 23/08/05
--------------------------------------------
  HM    Added Full Stock, VRW and Goods Returns into the LicLog.CSV file replacing
        the three spare module fields


Build 318 - 21/07/05
--------------------------------------------
  HM    Added Goods Returns module licence


Build 317 - 01/03/05
--------------------------------------------
  HM    Added Visual Report Writer module licence into the plain text at the
        start of the licence.


Build 316 - 28/02/05
--------------------------------------------
  HM    Added Visual Report Writer module licence


Build 315 - 05/10/04
--------------------------------------------
  HM    Modified the WriteLicenceDets routine which writes the readable text
        into the licence file as it was crashing for Auto-Upgrades because the
        Edition No is always 0 which isn't a valid Edition.

  HM    Changed the security checks in MainF to support the H:\ADMIN\LIC561\ dir.


Build 314 - 27/08/04
--------------------------------------------
  HM    Added James into the licence checks in MainF


Build 313 - 24/08/04
--------------------------------------------
  HM    Added Edition/Theme to Enterprise Version page and the Confirm page

  HM    Added Full Stock Control to Modules and Confirm page

  HM    Updated licence header text to include Edition and Full Stock Control 


Build 312 - 02/10/03
--------------------------------------------
  HM    Extended for the Workgroup Engine Licencing in Enterprise v5.52

  HM    Hid utilities menu and the option to generate ESN based passwords
        as people should be using WebRel.






b550.311 - 30/07/03
--------------------------------------------
  HM    Changed the WRTransmit ShellExecute command


b550.310 - 27/06/03
--------------------------------------------
  HM    Started this history file

  HM    Modified WriteLicenceDets in WriteLic as the status for CIS/RCT and
        App & Vals was being written wrongly into the header text within the
        .LIC file.



****************************************************************************)

end.
