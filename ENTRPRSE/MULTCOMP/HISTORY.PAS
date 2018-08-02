unit History;

interface

Function CurrVersion_Comp : ShortString;

implementation

Uses EntLicence, ExchequerRelease;

Const
  // MCM Version Number
  //ExchVer_Reg = 'Exchequer 2015 R1';  // Exchequer Version
  LITEVer_Reg = 'v1.00';  // LITE/IAO Version

  BuildVer_MCM = '255';   // EntReg Build Number - common across Exch & IAO

  // NOTE: The build number should be incremented for any new version leaving
  // the department, even if just to QA for testing.

Function CurrVersion_Comp : ShortString;
Begin // CurrVersion_Comp
  If (EnterpriseLicence.elProductType In [ptLITECust, ptLITEAcct]) Then
    // IRIS Accounts Office
    Result := LITEVer_Reg + '.' + BuildVer_MCM
  Else
    // Exchequer
    Result := ExchequerModuleVersion(emMCM, BuildVer_MCM);
End; // CurrVersion_Comp


(****************************************************************************

MCM Version History
===================

Build 255   15/02/2018   Exchequer 2018 R1
-----------------------------------------------------------------------------------------
  PR       ABSEXCH-19303 - Amended  Compon\MultiList\uSettings.pas to use the Owner when
           opening Pervasive files so that it can use encrypted files

Build 254   13/02/2018   Exchequer 2018 R1
-----------------------------------------------------------------------------------------
  PR       ABSEXCH-19303 - Amended time in log from msecs to secs; Fixed issue
           with uninitialised variable causing all estimates to show as 1 minute.

Build 253   12/02/2018   Exchequer 2018 R1
-----------------------------------------------------------------------------------------
  PR       ABSEXCH-19303 - Fixes to data encryption function

Build 252   01/02/2018   Exchequer 2018 R1
-----------------------------------------------------------------------------------------
  PR       ABSEXCH-19303 - Fixes to data encryption function

Build 251   31/01/2018   Exchequer 2018 R1
-----------------------------------------------------------------------------------------
  MH       ABSEXCH-19682 - Extended Add Company dialog to distinguish 2018-R1 companies from
           earlier versions.

Build 250   21/11/2017   Exchequer 2018 R1
-----------------------------------------------------------------------------------------
  MH       ABSEXCH-19452 - Licencing Changes for GDPR - Modified Pervasive File Encryption in
           Multi-Company Manager to check the new Pervasive File Encryption module release code


Build 249   13/11/2017   Exchequer 2018 R1
-----------------------------------------------------------------------------------------
  PR       ABSEXCH-19303: Added ability to encrypt Pervasive Data Files.


Build 248   23/01/2017   Exchequer 2017 R1
-----------------------------------------------------------------------------------------
  MH       ABSEXCH-13259: Copied User Count mods from the abandonded v7.1 branch which
           simplify the User Count process by removing the ExchqSS element.  This reduces
           the scope for locking errors massively and should also improve performance.


Build 247   12/01/2017   Exchequer 2017 R1
-----------------------------------------------------------------------------------------
  MH       ABSEXCH-17996: Added support for Information Table into Module Release Codes


Build 246   14/11/2016   Exchequer 2016 R3
-----------------------------------------------------------------------------------------
  MH       Corrected branding issues on Bureau Login


Build 245   22/10/2015   Exchequer 2016 R1
-----------------------------------------------------------------------------------------
  MH       Added Atom/RWM leak fix into EntComp/EntComp2 as they are dynamically loaded/
           unloaded for the User Count Security  


Build 244   28/07/2015
-----------------------------------------------------------------------------------------
  MH       Updated company version detection code after v7.0.14 merge to check for
           v7.0.14 data files - Misc\SystemSetup.Dat and Misc\VAT100.Dat


v7.1.243    21/01/2015
-----------------------------------------------------------------------------------------
  MH       ABSEXCH-16058: Added checks for OPVATPay.dat into Attach Company
  

v7.0.10.242  02/06/2014
-----------------------------------------------------------------------------------------
  MH       ABSEXCH-15404: Added PE Flags to force entire component to be loaded into memory


v7.0.5.241  09/07/2013
-----------------------------------------------------------------------------------------
  MH       Rebrand for Advanced


v7.0.4.240  09/05/2013
-----------------------------------------------------------------------------------------
  MH       Rebuilt to pickup support for Windows 7 / 8 / Server 2012


Build 239  26/02/2013
-----------------------------------------------------------------------------------------
  MH       ABSEXCH-13994 - User Count Security - Added password protected UI allowing individual
           user count records to be selected and removed


Build 238  18/02/2013
-----------------------------------------------------------------------------------------
  MH       ABSEXCH-13994 - User Count Security - Scan for apps and drop workstation sessions automatically


Build 237  11/02/2013
-----------------------------------------------------------------------------------------
  MH       ABSEXCH-13857: Added Export To Analytics checkbox to Company Detail window


Build 236  20/11/2012
-----------------------------------------------------------------------------------------
  MH       Rebuilt to pickup changes to Help|About dialog for SBE


Build 235  08/08/2012
-----------------------------------------------------------------------------------------
  MH       Modified UI colours


Build 234  26/06/2012
-----------------------------------------------------------------------------------------
  MH       Renamed BudgetHistory file to GLBudgetHistory


Build 233  22/06/2012
-----------------------------------------------------------------------------------------
  MH       Extended Add Company dialog for v7.0 CurrencyHistory.Dat/BudgetHistory file


Build 232  17/02/2012
-----------------------------------------------------------------------------------------
  MH       Extended Add Company dialog for v6.10 QtyBreak.Dat file


Build 231  19/10/2011
-----------------------------------------------------------------------------------------
  MH       Extended Add Company dialog for v6.9 Custom Fields file


Build 230  02/03/2011
-----------------------------------------------------------------------------------------
  MH       Extended Add Company dialog for v6.7 Audit directory


Build 229  09/02/2011
-----------------------------------------------------------------------------------------
  MH       Rebuilt to pickup changes to printer components


Build 228  09/11/2010
-----------------------------------------------------------------------------------------
  MH       Added support for v6.5


Build 227  10/03/2010
-----------------------------------------------------------------------------------------
  MH       Recompiled to pick up Windows 7 Date fix in ETDATEU


Build 226  15/02/2010
-----------------------------------------------------------------------------------------
  MH       Modified Attach Company to support separate SQL and Pervasive data version,
           updated SQL Edition code for v6.3.


Build 225  08/02/2010
-----------------------------------------------------------------------------------------
  MH       Added CheckPlugInLicence (PlugInSec.Pas) to allow Exchequer to check Plug-In
           licences on startup.


Build 224  18/01/2010
-----------------------------------------------------------------------------------------
  MH       Added AddLoginRefWithCoCode into the User Count Security to allow the Company
           Code to be returned to Enter1 to be published in the Customisation


Build 223  13/08/2009
-----------------------------------------------------------------------------------------
  MH       Modified Add Company Directory dialog FOR SQL as I seem to have overlooked that in
           build 222 below.  As no way to identify differences at the file level I had to modify
           Company.Sys to include a version number that the Dir Dlg can check.  FRv6.01.224



Build 222  13/05/2009
-----------------------------------------------------------------------------------------
  MH       Modified Add Company Directory dialog to detect new v6.01 files.

           Fixed bug (FRv6.01.018) where Pervasive Edition systems got the following error when saving the company details:-

             'EntComp.CompDet.TestExclusivity: This routine is not SQL compatible and should not be used'


Build 221  12/03/2009
-----------------------------------------------------------------------------------------
  MH       Added Bang menu option, controlled by /Bang parameter, to test MadExcept.


Build 220  18/09/2008
-----------------------------------------------------------------------------------------
  MH       Rebuilt to pickup fixes to GetFirst/GetNext in oBtrieveFile


Build 219  16/09/2008
-----------------------------------------------------------------------------------------
  MH       Removed the rounding validity check added in 218


Build 218  12/09/2008
-----------------------------------------------------------------------------------------
  MH       Added a validity check into ShowCompMan to check the Exchequer SQL Rounding
           Function is installed and working.


Build 217  27/08/2008
-----------------------------------------------------------------------------------------
  MH       Removed exclusive checks for SQL when adding companies as it isn't technically
           possible to do the check until AFTER it is in the Company table, at which point
           it is a bit late.

           Modified Add for SQL to update the company record with the correct data type
           after the company has been added.


Build 216  07/08/2008
-----------------------------------------------------------------------------------------
  MH       Rebuilt which fixes crash in logged in user report!


Build 215  15/07/2008
-----------------------------------------------------------------------------------------
  MH       Modified exclusive check when storing the Company Details as under SQL you need
           to use the original path otherwise BtrvSQL.Dll can't match it up to a company code. 


Build 214  02/07/2008
-----------------------------------------------------------------------------------------
  MH       Recompiled to pickup a fix in SQLUtils.Pas for exclusive checks


Build 213  16/06/08
-----------------------------------------------------------------------------------------
  MH       Modified to call SQLUtils.ExclusiveAccess instead of using Open_File with -4
           when running as SQL.


Build 212  13/06/08
-----------------------------------------------------------------------------------------
  MH       FRv6.00.243 - Removed Pervasive wording in Help|About text.
           FRv6.00.247 - Options screen defaulting to design-time position.


Build 211  06/06/08
-----------------------------------------------------------------------------------------
  MH       Added %CODE% macro into Backup/Restore command lines as Barry required it for
           SQL Backup.

Build 210  03/06/08
-----------------------------------------------------------------------------------------
  MH       Modified the Edit Company dialog so that the Browse button is available under
           SQL if the company path is invalid.


Build 209  16/11/07
-----------------------------------------------------------------------------------------
  MH       Fixed bug in Bureau Module MCM where View company showed the Company Options
           record because the routine was working off Company.Dat rather than GroupCmp.Dat
           which was used by the list.


Build 208  26/10/07
-----------------------------------------------------------------------------------------
  CS       Added InitCompDLLEx2 and TermCompDLL3.


Build 207  27/09/07
-----------------------------------------------------------------------------------------
  MH       Fixed a bug in TCompanyIdCacheType.BuildCache (CompId.Pas) caused by a temporary
           workaround for the SQL project being reversed out incorrectly.


Build 206  26/09/07
-----------------------------------------------------------------------------------------
  MH       Modified the MCM to use WinExec to run the Scheduler, eBusiness and Sentimail
           as under windows VISTA they will then run without the user being asked for
           Confirmation - FRv6.00.080


Build 205  21/09/07
-----------------------------------------------------------------------------------------
  MH       Modified CheckForDelete (ChkDelet.Pas) to call ValidCompany when checking subdirectories
           as this looks for Company.Sys.

  MH       Modified the Company Details dialog to check for Company.Sys when saving the company
           record, in previous Exchequer versions it had checked for ExchqSS.Dat which is no
           longer valid because of the SQL Edition. 


Build 204  12/09/07
-----------------------------------------------------------------------------------------
  CS       Added ExScreen into the DLL, and the FIXSCREEN directive, to fix the
           problem with the TMS components on the print preview form
           (fault log FRv6.00.031).

Build 203  13/08/07
-----------------------------------------------------------------------------------------
  MH       Fixed bug in Company Details where invalid characters can be typed into the code
           field, this is dis-allowed from v6.00 for SQL compatiblity.  Written so that
           editing a company doesn't complain for backward compatibility.

           Added EntComp_ShareScreen function to allow Screen objecct to be set by Splash
           Screen to workaround problems with HTML Help sending active windows to the background


Build 202  10/08/07
-----------------------------------------------------------------------------------------
  MH       Modified the Delete Company function to not call SQLUtils.ExclusiveAccess as
           that crashes for the Pervasive Edition.


           13/06/07
-----------------------------------------------------------------------------------------
  MH  IAO  Modified the Company Options dialog to allow the Bureau Options to be shown for
           IAO if IAOBUREAU.INF is present.

           This was done for Accounts Office Online which is an IAO version of VAO.


Build 201  29/05/07
-----------------------------------------------------------------------------------------
  MH  Exch  Modified Bureau Login to have separate Pervasive and SQL branding


Build 200  01/05/07
-----------------------------------------------------------------------------------------
  MH  Exch  Recompiled for v6.00


Build 173  04/06/07
-----------------------------------------------------------------------------------------
  MH  Exch  Modified non-Bureau company list so that the Backup/Restore menu options are
            only available if the paths in the Company Options have been set.


Build 172  01/06/07
-----------------------------------------------------------------------------------------
  MH  Exch  Modified non-Bureau company list so that Rebuild is only available under the
            MCM password.  Bureau Module not changed after discussions with RP.


Build 171  30/01/07
-----------------------------------------------------------------------------------------
  MH  Exch  Compiled as v5.71 for release


Build 171  30/11/06
-----------------------------------------------------------------------------------------
  MH  IAO       Added a data type flag into CompanyDetRec and SyssMod to allow IAO to
                exclude demo datasets from the count of companies used

  MH  IAO       Modified the GetActualCompanyCount routine to return the number of
                non-demo companies

  MH  IAO/Exch  Modified Help|About to correctly pluralise the company count messages

  MH  Exch/IAO  Modified the Company Details dialog to show a . in the bottom left
                corner of demo data companies.

  Mh  IAO       Modified Add Company to check the data type on the select dir dialog
                before checking the company count licence

  MH  IAO       Modified the Add Company dialog not to check the company count licence
                when saving as it doesn't know the data type and it has already been
                checked in the select dir dialog.

  MH  Exch/IAO  Modified the company check routine to return error 107 Invalid Data Type
                if the data type flag in CompanyDetRec and SyssMod^ don't match up.


Build 170  22/11/06
-----------------------------------------------------------------------------------------
  MH  Exch     Fixed Bureau User Detail dialog where the Code/Name labels were behind
               the GroupBox - no idea when this happened, most likely when I added the
               scheduler option.


Build 169  13/11/06
-----------------------------------------------------------------------------------------
  MH Exch      Added command line parameters to enable the resetting of keyboard delay,
               keyboard repeat rate and screen saver activation under Windows Vista:-

                 /DoKBDelay
                 /DoKBSpeed
                 /DoScrSave


Build 168  10/11/06
-----------------------------------------------------------------------------------------
  MH Exch      Modified resizing of Module Release Code dialog as under Vista RC2 it comes
               up with the buttons hanging off the bottom of the form.  Added minimum size
               setting as well.

               Modified resizing code on the Bureau Group Detail window as the panel containing
               the buttons was going off the bottom of the form.


Build 167  23/10/06
-----------------------------------------------------------------------------------------
  MH  Exch     Added Scheduler option to File and popup menus off the Companies List.  Added
               a new security entry in the user profile to cover this within the Bureau module.


Build 166  06/09/06
-----------------------------------------------------------------------------------------
  MH  Exch/IAO   Rebuilt to pickup changes to default Btrieve 6.15 Compression Buffer Size
                 to 8k for TAS Books compatibility.


Build 165  02/08/06
-----------------------------------------------------------------------------------------
  MH  Exch/IAO   Modified ShowCompMan in DllComp.Pas to detect btrieve errors opening
                 MiscF and for 161's report it as too many users or expired demo licence


Build 164  20/07/06
-----------------------------------------------------------------------------------------
  MH  IAO        Added Grace Period flag to replication


Build 163  18/07/06
-----------------------------------------------------------------------------------------
  MH  IAO        Mods to the Activation to support the 30-day grace period, this included
                 resetting the Syss.GracePeriod flag on receipt of a valid activation
                 code and modifying the messages within the activation dialog to better
                 represent the state the user was in.


Build 162  25/05/06
-----------------------------------------------------------------------------------------
  MH  IAO        Rebuilt to pickup updated licencing components.


Build 161  12/05/06
-----------------------------------------------------------------------------------------
  MH  IAO        Added backdoor into MCM to allow access to the old Exchequer release code
                 dialog to bypass the IRIS Activation. Create c:\{C87AD61D-0BF0-434C-B4DA-12A02297F1CB}
                 and then login with MCM password and the Exchequer Security Release Code
                 Dialog is available on the file menu.


Build 160  11/05/06
-----------------------------------------------------------------------------------------
  MH  IAO        Modified the Update Licence dialog to have a close button.

  MH  IAO        Changed the expiry message on the Activation dialog as it was out by a
                 day, and also reported '1 days' remaining.



Build 159  10/04/06
-----------------------------------------------------------------------------------------
 MH   Modified the Add Company - Browse dialog to be aware of IAO and to stop IAO
      datasets being loaded into Exchequer and vicey versa.

      Also made dialog aware of v5.50 onwards as it was totally out of date.



Build 158  06/02/06
-----------------------------------------------------------------------------------------
 MH   Split out version numbers and created CurrVersion_Comp function to support usage
      within LITE and Exchequer with different version numbers but a common build number.



v5.70.157  22/09/05
----------------------
  MH       Released for v5.70


b570.156    11/08/05
----------------------
  MH       Rebranded text on windows and messages


b570.155    01/08/05
----------------------
  MH       Added Goods Return release code


v5.61.154   27/06/05
----------------------
  MH       Rebuilt to pick up fixes to the MultiList components which had a problem
           loading data if the user switched around the Code and Company columns
           on the Company List.
            

v5.61.153   28/02/05
-----------------------
  HM       Added the Visual RW module release code into ModRels.Pas and SetModu.Pas


v5.61.152   09/02/05
-----------------------
  HM       Added the backdoor password disablement (b561.151) into the
           replication as it was only happening for the root dir company.


v5.61.151   02/02/05
-----------------------
  HM       Released for v5.61


b561.151   14/12/04
-----------------------
  HM       Changed SCD_SetupLicence to disable the Daily Password when installing
           or upgrading a VAO system.  The Director's password can be used instead.


b561.150   07/12/04
------------------
  HM       Various mods to the Bureau Module for VAO after VAO meeting to
           discuss operations:-

             * Removed Add/Edit/Delete/Backup/Restore from Company List and
               user password options

             * The Bureau Admin will have access to the special functions in
               the Rebuild Module

             * Added a Change PWord option to the Companies List for the Bureau
               Admin

             * Removed the MCM Options and Licencing options


b561.149   22/11/04
------------------
  HM       Built for QA to test the v5.61 licencing mods detailed against b560.148


v5.60.149  22/09/04
-------------------
  HM       Released for v5.60.001


b560.148  26/08/04
------------------
  HM       Reverted version back to b560 as v5.60.001 has been re-inserted into
           the schedule as the next release.

  HM       Modified ModRels to set the Full Stock Control release code under
           EN561 compiler definition.  Added the Release Code into SetModU
           as well under EN561.

  HM       Modified ModRels to set the Theme No from the CD Licence.

  HM       Added the User Count Licencing info dialog into the standard MCM
           List triggering off a double-click on the form.  Need a special
           licencing file to enable it, see code for details.


b561.147  18/08/04
------------------
  HM       Modified SCD_SetupWorkstation and SCD_SetupLocalBtrieve in EntComp2.Dll
           to setup the SystemDir parameter.


v5.60.146 14/05/04
------------------
  HM       Released for v5.60

b560.146  04/05/04
-------------------
  HM       Removed the MAPI Emailing option from the Security Release Code
           wizard when running under Windows 2003 Server as it was causing
           the setup program to terminate instantly without an error messages.


b560.145  29/04/04
-------------------
  HM       Rebuilt to pickup changes to the P.SQL 8 Client-Server settings
           which turn off the local cache engine, which was causing problems.

  HM       Changed the company options dialog so that it didn't ask for the
           current Bureau pword when logged in as SYSTEM.


b560.144  21/04/04
-------------------
  HM       Changed the find company dialog used when adding companies as part
           of the directory validation routine was breaking the DBMultiList on
           the Maintain Companies window if you cancelled the add.  The effect
           was that the list only displayed a single row and was caused because
           the validation was doing a GetEqual on another index without restoring
           the position.

b560.143  02/03/04
-------------------
  HM       Applied ENTER key tabbing to Group Detail, User Detail and MCM Find
           windows.

  HM       Changed MCM Find to select the first item in the results list on
           completion of the search if any results found.  Can't move focus as
           that feature of the multilist doesn't appear to work

  HM       Changed Company List window so the list wasn't the activecontrol as
           that was stopping the cursor up/down from working somehow.


b560.142  18/02/04
-------------------
  HM       Took out the re-display of the Splash Screen when the Bureau Login
           closes as it can have a flicker effect as it shows and then hides
           when the Bureau MCM list appears.

  HM       Changed the Edit button in the Maintain Companies List to clear
           the cache of company information and refresh the list as if you
           edited the company to fix a path it wasn't updating the error status.

  HM       Tracked down the disappearing start bar icon fix in CompList and
           applied it to the Standard MCM and Bureau Login windows.  Basically
           it was using the Windows API to reshow the application icon after
           hiding the splash screen.  Sneaky!

  HM       Changed the double-click/view button on the Groups List so that it
           defaults the detail window to the companies tab if there are no
           companies linked to the group, else the users tab.  (Requested by EL)



b560.141   12/02/04
-------------------
  HM       Rewrote all the form resizing to use the OnResize event instead of
           Anchors as Delphi was screwing it all up under Windows XP as the
           caption bars and borders are thicker, but Delphi was making the
           client area smaller instead of the Form Height/Width larger!!!  The
           effect of this was to run all the lists/page controls off the bottom
           and right of the resizeable screens (which is most of them). 


b560.140   11/02/04
-------------------
  HM       Release for demo'ing the Bureau Module at the Channel forum:-

             Implemented the Bureau Module

             Added Apps & Vals release code into module release code dlg


v5.52.139  18/11/03
-------------------
  HM       Released for v5.52


b552.139   29/10/03
--------------------
  HM       Changed the parameters being passed into the E-Business module to
           include the path or the selected company data set.


b552.138   15/10/03
--------------------
  HM       Mods to SetupReg for Pervasive.SQL v8 Client-Server and Workgroup.

           Added several functions for Workgroup Engine support.


b552.137   26/08/03
--------------------
  HM       Mods to SetupReg because of weird pathing errors registering the Graph
           Control using RegisterCOMServer, reverted to previous system from Jan 2002.


b552.136   11/08/03
--------------------
  HM       Mods to Company List to prevent the XP Tray Icon Corruption, see
           TForm_CompanyList.FormCreate for more details.


b552.135   06/08/03
--------------------
  HM       Mods to AddLoginRef in UserSec.Pas because a window was found where
           if one app was logging in whilst another was logging out on the same
           workstation the machine logging in could be left with the waiting for
           a record lock window displayed.


b552.134   28/07/03
--------------------
  HM       Mods to SCD_ReplicateLicence in ReplSysF.Pas so that the data file
           sizes are checked during upgrades for the 4Gb limit


b552.133   22/07/03
--------------------
  HM       Mods to SCD_LoadWSOptions in wsData.Pas to support Pervasive.SQL v8
           in the workstation setup.

  HM       Changed SCD_SetupWorkstation and WorkStationSetup in BtFuncs.Pas to
           support Pervasive.SQL v8 for the workstation setup.


v5.51.132  24/03/03
--------------------
  HM       Released for v5.51


v5.50.131  24/03/03
--------------------
  HM       Released for v5.50


b550.131   06/03/03
--------------------
  HM       Added RemoveLoginRefEx into UserSec.Pas which will return a boolean
           flag to indicate whether a login reference has been removed, this
           will be used to fix the toolkit user count corruption which was
           caused by the SysF usercount being decremented even though there
           wasn't a corresponding entry in CompF.


b550.130   05/02/03
--------------------
  HM       Fixed the Data Copy wizard for the setup as it wasn't copying all
           the system setup records.

  HM       Added a new option in the MCM Options to show the Exchequer button,
           this defaults to OFF as requested by EL/GM so that we can identify
           Exchequer users.

  HM       Added checks on data file sizes when opening companies.


b550.219   31/01/03
--------------------
  Released with v5.50 Beta



v5.00.129  15/08/02   Bug
                      ~~~
                      Modified the routine in CompList.Pas that checks for the presence of Sentimail
                      as it was checking for SentHook.Exe which Paul had removed from the system.

v5.00.128  02/07/02   Version incremented to identify 2nd release of .001 with fixed Toolkit DLL
                      and COM Toolkit.

v5.00.127  07/06/02   Mods 
                      ~~~~
                      Rebuilt to pick up correction to XP Lists

v5.00.126  08/05/02   Released for v5.00.001

b500.126   23/04/02   Bug
                      ~~~
                      Modified the Check for Logged In Users report as it was leaving behind the
                      temporary report file if no errors were found.

b500.125   23/04/02   Mod
                      ~~~
                      Modified the Check for Logged In Users report so that it deletes an files
                      in the SWAP sub-directory for company data sets that are not in use.

b500.124   22/04/02   Bug
                      ~~~
                      Modified the code that runs Enterprise from the MCM Company List so that 
                      after doing the Btrieve reset it re-opens Company.Dat.  This fixes the
                      'issue' with the Client-Server version beeping as the MCM closes.

v5.00.123  02/04/02   Released for Enterprise v5.00

b500.123   27/03/02   Mod
                      ~~~
                      Changed TCompObj so that it wasn't expecting Dictnary.dat in the Reports\
                      subdirectory of each company data set.

                      Bug
                      ~~~
                      Changed the setting of the VAT Period in EntInitU when adding a blank company
                      as it wasn't working correctly for February.


b500.122   18/03/02   Mod
                      ~~~
                      Rebuilt to pickup changes in Plug-In RelCode calculation designed to reduce
                      the chances of different Plug-Ins generating the same Release Codes. 

b500.121   14/03/02   Bug
                      ~~~
                      Rebuilt to pickup Abbrevia 3.02 components as the v3.01 components were
                      generating CRC errors on some machines in Enterprise.

b500.120   26/02/02   Bug
                      ~~~
                      Made changes to UpdateEntLic in ModRels as the process of updating the
                      Module User Counts in the Enterprise Licence was failing for Auto-Upgrades
                      and Upgrades with modules left as Auto.

b500.116   24/01/02   Bug
                      ~~~
                      Fixed the Popup Menu on the Company List as it was crashing when the dlg
                      is used from within Enterprise, as the OnPopup was referencing elements
                      of the main mennu components that had already been destroyed.

b500.115   24/01/02   Bug
                      ~~~
                      Changed the SetupReg module to use RegisterCOMServer instead of RegSvr32 
                      after various problems on different Win98 machines.

b500.114   24/01/02   More Bugz
                      ~~~~~~~~~
                      Rewrote Resynchronise Companies to regenerate Sec/RelCodes as required
                      after changing the ESN.

                      Fixed the Plug-In User Count Security as the Security Code being generated
                      hadn't been updated for the ESN based release codes.

                      Fixed the Reset button on the Plug-Ins tab of the release code dialog
                      as it hadn't been updated for the ESN based release codes.

                      Added support for the Thrid-Party Security Password into the MCM which
                      gives access only to the Plug-In Release Code area.

b500.113   23/01/02   Bugz
                      ~~~~
                      Changed the checking of the E-Business and Sentimail Release Codes
                      during the startup, as when they expired the replication routine was
                      closing Company.Dat, which meant the Btrieve List was empty.

                      Also changed the routine to open PwrdF as this is used by TrackSecUpdates
                      and caused an error 3 if either code had expired.

                      Modified the Module Release Code dialog as the ESN hadn't been read by
                      the time it was setting the Security Code for expired modules, this
                      meant that they were getting a new Security Code for an all-zero ESN.

b500.112   22/01/02   Mod
                      ~~~
                      Changed the Add Company wizard to warn users to run Check All Accounts
                      and Check All Stock.

b500.103   24/10/01   Mod
                      ~~~
                      Fixed the Save Position code in the MCM so that it saves the position
                      when you close the MCM as well as open the company data set

b500.xxx              Mods
                      ~~~~
                      Various Mods for new v5.00 security features

b440.100   11/07/01   Converted to v4.40 Format

----------------------------------------------------------------------

b432.036   09/07/01   Mod
                      ~~~
                      Extended the About Dialog to contain the number of companies in the MCM,
                      needed as preparation for v4.40 where dealers are going to have to report
                      the company count prior to getting an upgrade for a customer.

b432.035   13/06/01   Mod
                      ~~~
                      Extended the Btrieve Initialisation to enforce valid settings on the 
                      HKEY_LOCAL_MACHINE\SOFTWARE\Btrieve Technologies\Microkernel Engine\Version  
                      6.15\Microkernel Interface\Settings\Target Engine entry which had been 
                      corrupted on Paul Sparkes machine causing the setup to fail with an error
                      10120 when replicating files to sub-companies. 

v4.32.034             Released


b431.033   08/03/01   Mods
                      ~~~~
                      Changed the message in the Release code replication reporting an invalid
                      ESN to be more precise as to the problem, apparently it was causing a lot
                      of worry in NZ.

                      Changed the Data copy Wizard to copy the additional User Security record
                      added in v4.31.

b431.032   26/02/01   Bugs
                      ~~~
                      Changed the Security Warning dialog to report codes expiring today as
                      expiring today instead of as expired.  This caused people to think there
                      was a security flaw.

                      Changed the Email and Fax output from the security warning dialog to 
                      report expired expiry dates as EXPIRED not dd/mm/yyyy.

b431.031   26/02/01   Mod
                      ~~~
                      Got Eduardo's conversion routine working, problems caused by him doing
                      a Btrieve reset thereby taking out the open MCM database!

b431.030   20/02/01   Mod
                      ~~~
                      Started to add support for Eduardo's conversion program in the setup
                      program.

b431.029   30/01/01   Mod
                      ~~~
                      Added Trade Counter, Std WOP and Pro WOP module release codes and
                      hid the Print button as the print out was never used and isn't needed
                      in SCuD versions of Enterprise.

b431.028   26/01/01   Mod
                      ~~~
                      Added an exported function for Hooks to maintain and control a 30-Day/
                      Full Release Code mechanism.

b431.027   25/01/01   Mod
                      ~~~
                      Changed Resync companies to detect zero ESN's in SyssF and to load
                      ESN from Entrprse.Dat.  If still zero it will generate a random ESN.

v4.31.026  15/12/00   Released for v4.31.005

b431.026              Mod
                      ~~~
                      Changed SCD_EntCompanyWizard so new DEMO companies are added into the
                      MCM with ZZZZ codes, as requested by Des.

v4.31.025             Released


b431.021   14/11/00   Mod
                      ~~~
                      Changed Resynchronise Companies to set the ESN in Entrprse.Dat as well.

b431.020   09/11/00   Bug?
                      ~~~
                      Changed TForm_CompanyList.FormClose so that caFree wasn't being set if
                      running the MCM from the splash.  The splash code was freeing the form
                      and this was potentially causing serious errors.

b431.019   08/11/00   Bug
                      ~~~
                      Fixed the ESN in the About dialog and fixed the RSYNC parameter, both
                      had been broken when ExMainCoPath was set in .017

b431.018   06/11/00   Bug
                      ~~~
                      Fixed 2 bugs in setup where licence was being written back to the
                      Entrprse directory on the CD. 

b431.017   ??/11/00   Bug
                      ~~~
                      Modified the MCM startup routines to set ExMainCoPath, otherwise
                      TrackSecUpdates wasn't updating the licence if users entered release
                      codes.

b431.016   30/10/00   Bug
                      ~~~
                      Fixed ModRels.Pas as it was losing the Toolkit DLL release code
                      when upgrading from Full Runtime to Full Developer status.  Would
                      also have problems when downgrading from Full Developer to 30-Day
                      Runtime and when upgrading from 30-Day Runtime to Full Developer.

b431.013   11/09/00   Mod for Derek
                      ~~~~~~~~~~~~~
                      Changed Add Company to generate Demo Companies as ZZZ?? codes. 

b431.012   17/08/00   Mods
                      ~~~~
                      Changed the EBus .EXE name to EBusAdmn.Exe

v4.31.011  17/08/00   Released for Enterprise v4.31.004

b431.010
       21/07/00       Mods
                      ~~~~
                      Added a show/hide flag on 'Check for Users' in MCM.

v4.31.009             Bug
       17/07/00       ~~~
                      Modified File|Login to correctly Encode the password, as there were
                      intermittant problems with wrong keys being used.
                     

b431.008              Mods
       27/06/00       ~~~~
                      Modified Release Code wizard to update SysF when it generates a 
                      new release code.

b431.007              Mods (Ent .003 Beta)
       22/06/00       ~~~~
                      Added following sections into workstation registry setup for P.SQL
                      2000 & ODBC:-
 
                        Pervasive Software\Microkernel Router\Version 7\Settings
                        Pervasive Software\Btrieve Requester\Version 7\Settings
                        Pervasive Software\Scalable SQL Requester\Version 4.01\Settings

                      Bug
                      ~~~
                      Added Dispose to GlobComp in CompanyList.Store_FormCoord.

b431.005              Bug 
       24/05/00  HM   ~~~
                      Modified Password entry dialog to explicitly specify the
                      encryption key as was getting problems entering the MCM password.
                      (Possibly classing with decryption of licence)

                      Modified TForm_CompanyList.Check4EBus as wasn't closing SYSF, meant
                      rebuild on SysF in main company failed.

                      Mods
                      ~~~~
                      Modified Rebuild Module menu opt to close the MCM, as the MCM uses
                      MiscF for storing Window Positions, this means that it cannot be
                      rebuilt while the MCM is running.

b431.004
                 HM   Mods
                      ~~~~
                      Extended parameters being passed into Rebuild Module

b431.003
                 HM   Mods
                      ~~~~
                      Added support for Rebuild Module

b431.002
       15/05/00  HM   Bug
                      ~~~
                      Modified the Data Copy Wizard so that it copies the Job Totals
                      across when copying Jobs.  Otherwise you don't get any Totals 
                      records!

v4.31  25/04/00  HM   Released

b430d.512
       03/04/00  HM   Bug
                      ~~~
                      Modified the Workstation Setup as was getting error 35 when registering
                      the COM Customisation in a Local Program Files directory.

b430d.511
       22/03/00  HM   Mods
                      ~~~~
                      Integrated Paperless Module into Main and Workstation Setups.

b430d.510
       13/03/00  HM   Mods
                      ~~~~
                      Added Check For Users option into Tools Menu which runs through all
                      companies doing an Exclusive check to see if anyone logged in. Requested
                      so people can use it prior to doing backups.

b430d.504
       04/01/00  HM   Mods
                      ~~~~
                      Rebuilt to pick up changes to the directory testing routines, designed
                      to reduce sharing errors caused by simultaneous startups.

b430.500
       02/09/99  HM   Converted to Delphi 4                                  

------------------------------------------------------------------------------------------

b430g.217
       14/04/00  HM   Bug
                      ~~~
                      Modified MCM_SECWIZARD as Result wasn't being correctly set if errors
                      occurred within SCD_SECWARNWIZARD or ReplicateEntLicence.

v4.30f 09/02/00  HM   Bug
                      ~~~
                      Mod'd the workstation setup routines as the Btrieve Client-Server
                      Requester flag wasn't being correctly initialised. 

v4.30e 16/12/99  HM   Released

b430d.215
       04/11/99  HM   Bug(ger)
                      ~~~~~~~~
                      Fixed bug in the email registration utility where it was sending
                      in the user count security code instead of the system security
                      code.

b430d.214
       03/11/99  HM   Mods
                      ~~~~
                      Modified the Release Code Wizard to delete the .ERC file created
                      when sending in an email.

b430d.213
       18/10/99  HM   Mods
                      ~~~~
                      Modified Add Company in MCM to detect v4.30c as different from
                      v4.30-v4.30b, and insist on a data conversion for the latter.

b430d.212
       13/10/99  MH   Mods
                      ~~~~
                      Applied Help Context ID's to setup screens.


b430d.211
       11/10/99  MH   Mods
                      ~~~~
                      Rebuilt to pick up logo changes to SETUPBAS.

                      Bugs
                      ~~~~
                      Added automatic copying of JBF and SKF folio numbers where relevent
                      and of the duplicate security record.

b430d.210
       07/10/99  MH   Mods
                      ~~~~
                      Modified MCM_SECWIZARD to return status codes.

b430d.209
       06/10/99  HM   Bugs
                      ~~~~
                      Added missing System Setup Records:- GCurR, EDI1R..EDI3R into the
                      Data Copy Wizard.

b430d.208
       24/09/99  HM   Bug
                      ~~~
                      Modified the ERC routines to have 5 address lines not 6 as was 
                      causing a range check error writing the ERC from the registration
                      wizard for emails.

b430d.207
       06/09/99  HM   Mods
                      ~~~~
                      Extended the replication function to check for MISC\EXCHQCHK.DAT
                      at Eduardo's request. 

b430d.204
       19/08/99  HM   Bug/Mods 
                      ~~~~~~~~
                      Modified SCD_SetupLicence to check the security info is consistent
                      across ENTRPRSE.DAT, SysR and PwrdF.

                      Fixed a bug where it was taking the Serial Number from the ENTRPRSE.DAT
                      instead of ENTRPRSE.LIC when setting the ESN on a pre-SCuD upgrade. this
                      meant you usually got an ESN with 4 0's.

b430d.203
       17/08/99  HM   Mods 
                      ~~~~
                      Modified the call to Help|About to display the ESN. No changes
                      made to aboutU.

b430d.202
       12/08/99  HM   Mods 
                      ~~~~
                      Rebuilt to pick up changes to release code calculation

b430d.201
       11/08/99  HM   Mods - Initial SCD build
                      ~~~~
                      Finished tweaking the Release Code wizard.

       04/08/99  HM   Mods
                      ~~~~
                      Added /CODIR: command line switch to Exch/Ent buttons in Company List

       Ongoing   HM   Misc mods/functions for Single-CD Setup


v4.30d 27/04/99  HM   Mods 
                      ~~~~
                      Modified the Exchequer button to auto-close the MCM after running
                      Exchequer, as the MISC\ file being open was causing problems in the
                      Rebuild Module and with Special Functions.
  
v4.30c ?

b430.134
       20/04/99  HM   Mods
                      ~~~~
                      Added options for REX.BAT name to options in MCM to allow the MCM
                      to run different batch files under different O/S.

v4.30b 12/04/99  HM   Mods
                      ~~~~
                      Added Pervasive.SQL 7 Requesters settings to registry initialisation.

b430.133
       26/03/99  HM   Bugs
                      ~~~~
                      Modified the Delete Company checking to check that no companies
                      existed in the directory or any subdirectories. Someone had
                      accidently deleted there entire accounts because of a flaw in
                      the error checking.

v4.30a 26/01/99  HM   Released

b430.132
       05/02/98  HM   Bug (Potentially)
                      ~~~
                      Modified the initialisation of the P.SQL settings to check
                      whether the value exists in the registry, not doing this had
                      caused problems with EntReg.

v4.30a 07/01/99  HM   Mod (DL for Testing)
                      ~~~ 
                      Modified the Help|About text to display the main directory
                      path at the bottom if the company paths are being displayed.
                      Reqested by DL (Support) to make talking users through upgrades
                      easier/quicker.

v4.30  04/01/99  HM   Released

b430.131
       24/12/98  HM   Recompiled for RP3

b430.130
       22/12/98  HM   v4.30 Beta Compile

v4.24c 10/12/98  MH   Bug
                      ~~~
                      Got error 35 running Entrprse with MCM on local
                      program files after installing the MCM locally
                      and not on the network files. 

v4.24b 24/11/98  MH   Release Version to ship with new Setup/v4.24b

b423b.121
       20/10/98  MH   Mods
                      ~~~~
                      Increased the Max Locks btrieve setting to 1000
                      from 200 in EntRegU.
b423b.120
       15/10/98  MH   Mods
                      ~~~~
                      Added options to hide the paths and backup option
                      within the multi-company manager, so they are
                      only visible under the MCM Password or daily
                      password.

                      Changed the Add Company Dialog so it requires a
                      version v4.30 company.

b423b.119
       07/10/98  MH   Mods
                      ~~~~
                      Added routines to slow down high keyboard repeat
                      rates and disables screen savers whilst the 
                      companies list is disabled. The Keyboard Rate on
                      v. fast PII machines has cause Access Violations
                      in Enterprise.

b423b.118
       16/09/98  MH   Mods
                      ~~~~
                      Initialized the Scaleable SQL v4 settings to
                      Local=Yes, Requester=No,Logins=10, Target=0
                      as recommended by Fiona of Btrieve Tech Support
                      when initializing the Btrieve Settings.

                      (NOTE: Can be reset by EntReg if DDF's installed)

b423b.117
       08/09/98  MH   Bug
                      ~~~
                      The Run Exchequer button on the MCM list was
                      incorrectly checking the MCOMPMAN directory
                      not the directory containing the company data.

b423b.116
       14/08/98  MH   Mods
                      ~~~~
                      Changed the Options dialog in the MCM to have
                      a Deinstall MCM option.

b423b.115
       06/08/98  MH   Mods
                      ~~~~
                      Changed the Security Warning screen so double
                      clicking on the Enterprise Bitmap enabled the
                      button immediately.

b423b.114
       13/07/98  MH   Mods
                      ~~~~
                      Extended the Licence Modules dialog to handle
                      Telesales and Account Stock Analysis release
                      codes.

b423b.113
       30/06/98  MH   Mods
                      ~~~~
                      Changed InitCompany to copy the module release
                      codes in from the ExchQSS.Dat shipped in the CD
                      root when installing Enterprise with Demo Data. 

                      Modified InitCompany to detect installation of
                      Demo Company and to not run the Company Setup
                      Wizard.

b423b.112
       19/06/98  MH   Modz
                      ~~~~
                      Modified Entrprse.Exe to pass in the Network path
                      from ENTWREPL.INI to the Multi-Company Manager
                      which uses to pickup the COMPANY.DAT. 

b110.423b
       15/05/98  MH   Modz
                      ~~~~ 
                      Modified the Add Company dialog to check there is
                      a valid drive letter.

b108.423b
       09/04/98  MH   Modz
                      ~~~~
                      Modified the directory rights checking to write
                      logfiles for any warning and to stop running if
                      any log file failed or disk space < 200k.

v4.23b 09/04/98  MH   Bug
                      ~~~
                      The calculation of the next VAT period in the
                      Company Wizard was incorrectly using short dates,
                      although this didn't seem to cause a problem 
                      several sites had had a problem with it.

v4.23a 31/03/98  MH   Mod
                      ~~~
                      Modified SetCLServer in EntRegU to set the 
                      Pervasive.SQL registry entries as well. 

v4.23  30/03/98  MH   Bug 
                      ~~~
                      Recompiled to pickup change of CustRec from 940
                      back to 939 bytes.   

                      Modified directory checking on Exchequer button
                      to not check the DOCS and FORMS directories which
                      may not be present for systems using the 
                      Connectivity Kit MCM.

v4.22  26/03/98  MH   Bug 
                      ~~~
                      Modified the Data Copy wizard because it failed
                      when using a non-RW CD to install a new company
                      and copy the data from an RW company.

b108   13/03/98  MH   Mods
                      ~~~~
                      Modified the Data Copy Wizard to have lots of
                      Application.ProcessMessages during the copy
                      stage so the window can be moved. This will 
                      allow us to discover which file errors are
                      occuring in.   

b107   12/03/98  MH   Mods
                      ~~~~
                      Extended directory checking to check for system
                      attribute, and to check subdirectories of Enterprise.

b106   25/02/98  MH   Mods
                      ~~~~
                      Added various directory checking routines into
                      ENTRPRSE.EXE and ENTCOMP.DLL which check the
                      disk space, directory rights, etc.

v4.21e 
b105   21/01/98  MH   Bugs
                      ~~~~
                      Bug in Data Copy wizard was causing the copying
                      to return a fail code if the system setup was
                      being copied. This was because it got a status
                      9 (EOF) at the end, which was being taken as an
                      error. Fixed by changing error 9's to 0 at the
                      end of the process method.

                      Another bug in the data copy wizard caused the
                      copy to fail if you did a select all, but didn't
                      have the report writer installed, as it got an
                      error 12 attempting to process REPORTS.DAT.

                      Mods
                      ~~~~
                      Modified InitCompany to copy the Module Release
                      record from the main company to new companies.

                      Modified the Data Copy Wizard to copy the
                      Module Release record with the System Setup
                      Flags.

v4.21d 16/01/98  MH   Possible Bug
                      ~~~~~~~~~~~~
                      Getting a GPF at several sites when unloading
                      Enterprise in EntComp.DLL. Found DebugWin was 
                      included in the DLL as a hangover from some 
                      debugging. Removed to see if it made a difference.
                      

v4.21c 12/01/98  MH   Bug
                      ~~~
                      Fixed Delete Company which wasn't managing to 
                      delete any files because of the spaces on the
                      end of the company paths.
          
                      Mod
                      ~~~
                      Changed the Company Initialisation Wizard to
                      have the company Name before the Code, and to
                      default the code whenever the name is changed.

v4.21b 23/12/97  MH   Mod
                      ~~~
                      Modified the Backup/Restore section in the MCM to
                      allow %DRIVE% and %PATH% macros in the command
                      line.

v4.21a 18/12/97  MH   Mod
                      ~~~
                      Changed the Data Copy wizard to have an option
                      on the stock tab for the Alternate Stock Codes.
                      This would previously been copied (inadvertantly)
                      with the Locations & Stock/Location XRef records.

v4.21  18/11/97  MH   Mod
                      ===
                      Modified the modules release dialog to disable
                      the print button if no printers defined.

v4.20b 25/09/97  MH   Mod
          -           ===
       09/10/97       Modified behaviour of Multi-Company Manager
                      for Exchequer Enterprise Connectivity Toolkit.
                      Company List now checks for ENTER1.EXE and 
                      hides the Run enterprise menu options and
                      buttons. The Add wizard will allow an Exchequer
                      to be added in no Enter1.Exe is found.

                      Added EntRegConnect function to be called from
                      the Connectivity Kit setup program to register
                      OLE and configure btrieve.

                      Added EntCompanyWiz to control adding of companies
                      for the Connectivity Kit setup program. Modified
                      Company List to have a Mode 3 which is used by
                      the wizard.


v4.20a 18/09/97  MH   Mod
                      ===
                      Added the EntRunBtrieve function to allow the
                      setup program to run Btrieve. Needed because of
                      a bug in WISE.

v4.20  19/08/97  MH   Release Version

b104   19/08/97  MH   Mod
                      ===
                      Updated Module Release window.

b103   13/08/97  MH   Mod
                      ===
                      Modified Add Dialog in Multi-Company Manager to
                      detect v4.20 by checking for the Module Release
                      record. Does not now allow v4.10 companies to
                      be added.

b102   31/07/97  MH   Mod
                      ===
                      Modified password logon so release codes are only
                      available if logged in with the system password.

b101   30/07/97  MH   Mod
                      ===
                      Added dialog for Module Release Codes.

b100   27/06/97  MH   Bug
                      ===
                      Changed the WISE Functions from CDECL to STDCALL on
                      the advice of Wise Tech Support. This was because they
                      were crashing the While loop in the setup script.

v4.10b 06/05/97  MH   Mod
                      ===
                      Changed the company detail dialog so the path can be
                      typed manually into the path edit box. validation is 
                      done on the Save button.

v4.10a 21/04/97  MH   Bug
                      ===
                      Cannot run Exchequer from MCM on Rob's machine 
                      because it still had long file names in the command
                      to run the batch file. Worked OK on my machine and
                      under Win95.

v4.10  25/03/97  MH   Release Version

b018   21/03/97  MH   Mods
                      ====
                      Multi-Company Manager linked into help in EntRead.Hlp.

b017   17/03/97  MH   Bugs
                      ====
                      Modified the section which runs Enter1 when you select a 
                      company in the MCM so that it closes the files and resets
                      Btrieve before running Enter1. This fixes a problem with
                      the Win95 networking client which causes the program to 
                      wait during startup until other users on different network 
                      clients have logged out.

b016   13/03/97  MH   Bugs
                      ====
                      Set Cancel flag on on Close button in company list, and
                      changed the shortcut on the Exchequer button to X as C
                      is used for Close.

b015   14/02/97  MH   Bugs
                      ====
                      Fixed a bug in the 'Exchequer' button - the WinExec line
                      had been commented out accidently.

                      Fixed a bug in the find company dialog, it was not padding
                      the path when it checked to see if the data was already
                      a registered company.

                      Added the Security Expiry warning dialog.

b014   11/02/97  MH   Mods
                      ====
                      Added a 'Exchequer' button into the Multi-Company Manager 
                      which causes exchequer to be run for the company.

                      Modified the Data Copy wizard to uses the sbsDiskFree
                      function in DiskU, so it can handle larger amounts of free
                      disk space.

b013   10/02/97  MH   Mods
                      ====
                      Changed Entrprse.Exe to pass the command line parameters
                      into the multi-company manager, and the multi-company manager
                      to pass them into Enter1.Exe when executing a company.

b012   31/01/97  MH   Mods
                      ====
                      Changed the data copy options so that setup flags
                      are selected if nominals are selected. Also added
                      a popup menu with select all/select none.

                      Changed the data copy wizard so that it calculates
                      the required disk space and checks for it.

                      Changed the data copy wizard so that it deletes the
                      contents of the stock and nominal files before copying
                      the new company data in.

b010   17/01/97  MH   Mods
                      ====
                      Changed "Nominal Controls Codes" to "General Ledger
                      Accounts" in the data copy wizard.

b009   15/01/97  MH   Mods
                      ====
                      Added info msg to InitCompany telling users to
                      remember the company code.

                      Modified the Copy Data Wizard so the buttons have
                      the correct captions, and confirmation messages
                      are displayed.

                      Modified the Multi-Company manager so that the 
                      add, edit, delete options aren't available from
                      within Enterprise.

                      Modified Add Existing Company in the MCM so it
                      distinguishes between v4.0x and v4.1x files by
                      looking for MLOCSTK.DAT.
                    

b008   14/01/97       Initial Release of Beta Setup Program


****************************************************************************)

end.
