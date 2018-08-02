unit History;

interface

// Current Exchequer EntReg version
Function CurrVersion_Reg : ShortString;

// Current LITE EntReg version
Function LITEVersion_Reg : ShortString;

implementation

uses
  ExchequerRelease;

Const
  // EntReg Version Number
//  ExchVer_Reg = 'v7.0.5';  // Exchequer Version
  LITEVer_Reg = 'v1.00';  // LITE/IAO Version

  BuildVer_Reg = '072';   // EntReg Build Number - common across Exch & IAO

  // NOTE: The build number should be incremented for any new version leaving
  // the department, even if just to QA for testing.

//-------------------------------------------------------------------------

// Current Exchequer EntReg version
Function CurrVersion_Reg : ShortString;
Begin // CurrVersion_Reg
  Result := ExchequerModuleVersion (emEntReg, BuildVer_Reg);
End; // CurrVersion_Reg

//------------------------------

// Current LITE EntReg version
Function LITEVersion_Reg : ShortString;
Begin // LITEVersion_Reg
  Result := LITEVer_Reg + '.' + BuildVer_Reg;
End; // LITEVersion_Reg

(****************************************************************************

EntReg Version History
======================

Build 072      15/03/2018
------------------------------------------------------------------------------------
 MH       Added support for XLUtils.dll


Build v2015 R1      21/04/2015
------------------------------------------------------------------------------------
 PKR      Changed to use centralised ExchequerRelease version number.

Build v7.0.5.070    11/07/2013
------------------------------------------------------------------------------------
 CS       Removed references to Iris

Build v7.0.4.069    09/05/2013
------------------------------------------------------------------------------------
 MH       Rebuilt to pickup support for Windows 7 / 8 / Server 2012


Build v7.0.068    10/09/2012
------------------------------------------------------------------------------------
 MH       Changed to v7.0 Branding


Build v6.4.067    23/04/2010
------------------------------------------------------------------------------------
 MH       Added support for .Exe version of Data Query COM Object


Build 066  11/10/07  MH  Mod
                         ~~~
                         Rebuild to pickup changes to registration of fax components.


Build 065  27/09/07  MH  Mod
                         ~~~
                         Added option to register the fax components


Build 064  18/09/07  MH  Mod
                         ~~~
                         Applied generic IRIS v6.00 icon


Build 063  01/08/07  MH  Mod
                         ~~~
                         Added "(EXE)"/"(DLL)" into COM Toolkit descriptions when registering
                         so we can identify which is causing the problem if necessary.

                         Corrected fonting.

Build 062  16/07/07  MH  Mod
                         ~~~
                         Added registration of EnterOLE.CHM as this enables Excel to find the help


Build 061  29/06/07  MH  Mod
                         ~~~
                         Moved OLE Server to register first as its path is used by SQL version
                         during registration of COM Customisation


Build 060  28/06/07  MH  Mod
                         ~~~
                         Mods to registration of OCX's as the existing RunApp/RegSvr32 method
                         was failing in certain directories (Users\AppData\Roaming) whilst working
                         in others.  Now using the same RegisterComServer call as .DLL's.

                         Changed the handling of the /VirtualStore: parameter as to get around long
                         filenames it is now passed embedded in double-quotes.


Build 059  22/06/07  MH  Mod
                         ~~~
                         Added Vista File Virtualisation check into FormCreate of main form


Build 058  17/05/07  MH  Mod
                         ~~~
                         Added support into Exchequer section for adding the path into
                         HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\HTMLHelp\1.x\ItssRestrictions\UrlAllowList
                         to enable HTML Help off a network drive. 


Build 057  17/05/07  MH  Mod
                         ~~~
                         Added support into Exchequer section for registering the Spell Checker


Build 056  16/05/07  MH  Mod
                         ~~~
                         Modified registration of COM Toolkits to register both the


Build 055  10/05/07  MH  Mod
                         ~~~
                         Fixed pathing bug in EntReg2U.ValidOk which was causing error 11's in Enter1.EXe
                         when registering the COM Customisation.  This appears to be an inherited fault
                         which has only just started causing the problem ???


Build 054  10/05/07  MH  Mod
                         ~~~
                         Modified setting of BtrieveMode to run off the Exchequer C/S licence flag


Build 053  01/05/07  MH  Mod
                         ~~~
                         Renamed to EntRegX to comply with Vista Elevation utility


Build 052  01/05/07  MH  Mod
                         ~~~
                         Removed database options for Exchequer


Build 051  08/03/07  MH  Mod
                         ~~~
                         Rebuilt with v6.00 Licensing


Build 050  26/02/07  MH  Mod
                         ~~~
                         Rebranded CIS Dashboard to GovLink


Build 049  21/02/07  MH  Mod
                         ~~~
                         Rebuilt to pickup pathing changes in RegCom due to GetWindowsDirectory
                         not working under 2003 with Terminal Services


Build 048  09/01/07  MH  Mod
                         ~~~
                         Renamed Outlook Today to Ourlook Dynamic Dashboard


Build 047  09/01/07  MH  Bug
                         ~~~
                         Corrected spelling of CSNF Extensions - formally Extentions


Build 046  13/12/06  MH  Mods
                         ~~~~
                         Renamed Client-Sync to ClientLink for IAO and CIS Dashboard for Exchequer


Build 045  06/12/06  MH  Mods
                         ~~~~
                         Explicitely imported XP manifest into main form - implicit importation
                         through {$R *.RES} meant it worked on XP but not on Vista.


Build 044  28/11/06  MH  Mods
                         ~~~~
                         Modified to use unregister the Toolkit DLL


Build 043  17/11/06  MH  Mods
                         ~~~~
                         Modified to use RegCom.Pas for registering COM Objects instead of SetupReg.

                         Added Registration of SentEvnt.Dll which was in Workstation Setup but missing
                         from EntReg;


Build 042  25/10/06  MH  Mods
                         ~~~~
                         Added support for registering the Outlook Today KPI Plug-Ins via KPI.COM

                         Added support for Exchequer to register the Dashboard Plug-Ins via ICS.COM


Build 041  19/10/06  MH  Mods
                         ~~~~
                         Added support for registering the Exchequer Scheduler as part of the COM TK


Build 040  06/09/06  MH  Mods
                         ~~~~
                         Increased Compression Buffer size for TAS Books compatibility


Build 039  17/05/06  MH  Mods
                         ~~~~
                         Added support for IAO using Btrive v6.15 Engine

                         Added support for setting the Btr 6.15 Home Directory to the root of the windows drive


Build 038  17/05/06  MH  Mods
                         ~~~~
                         Added registration of RemotingClientLib.dll


Build 037  21/03/06  MH  Mods
                         ~~~~
                         Added registration of EntLib.001


Build 036  09/03/06  MH  Mods
                         ~~~~
                         Modified the configuration of the DB Engine to detect LITE and to
                         only configure the full Pervasive.SQL Workgroup Engine install, previously
                         it had been doing the standard Btr 6.15 + WGE + C/S settings which were
                         jumping up and down all over the correct WGE settings.


Build 035  28/02/06  MH  Mods
                         ~~~~
                         Modified detection of Workstation Engine to use registry instead of
                         files in the Exch\BIN directory - which won't exist for LITE


Build 034  14/02/06  MH  Mods
                         ~~~~
                         Added in separate options page for LITE and added an ICE Option

                         Added code to read through ICS.COM and register all the DLL's/EXE's
                         listed within it.  This file should be used for all the ICE plug-ins
                         so that the workstation setup and EntReg don't nead to be aware of
                         them in detail. 


Build 033  06/02/06  MH  Mods
                         ~~~~
                         Rebranded for IAO

                         Suppressed Client-Server options

                         Modified names be product neutral

                         Changed to have independant IAO and Exchequer version numbers


v5.71.032  25/01/06  MH  Mod
                         ~~~
                         Added check for and registration of out-of-process COM Toolkit if present.


v5.70.031  27/10/05  MH  Bug
                         ~~~
                         Discovered a pathing issue in the registration of COM Customisation where
                         you got Btrieve Error 12's if you didn't have an EntWRepl.Ini.  This will
                         probably not affect Exchequer but was found when testing a LITE installation.


v5.70.030  19/08/05  MH  Rebranded 


v5.61.029  02/02/05  MH  Released for v5.61


v5.60.029  22/11/04  MH  Bug!
                         ~~~~
                         Corrected Tab Order


v5.60.028  22/11/04  MH  Mods
                         ~~~~
                         Changed Fix button to allow execution without any
                         check boxes being selected, this allows just the VAO
                         system directory to be set.


v5.60.027  22/09/04  MH  Released for v5.60.001


b561.027   05/08/04  MH  Mods
                         ~~~~
                         Added code to put the SystemDir value into the registry
                         off HKEY_CURRENT_USER\Software\Exchequer\Enterprise to
                         indicate the location of the main Enterprise directory
                         for the VAO system to use.


v5.60.026  14/05/04  HM  Released for v5.60

b560.026   22/04/04  HM  Mods
                         ~~~~
                         Added code to set the P.SQL 8 Use Cache Engine flag to
                         false in the Microkernal Router section for Client-Server
                         sites at the request of Des/Dave.

v5.52.025  18/11/03  HM  Released for v5.52


b552.025   13/10/03  HM  Mods
                         ~~~~
                         Extended to set BtrieveMode

                         Also picks up mods made to SetupReg for the Stup Program which will
                         cause the Workgroup Engine stuff to be setup.

                         Changed SetupReg to initialise the Splash Screen flag to No for the
                         v8 Requesters.

b551.024   17/07/03  HM  Mods
                         ~~~~~~~
                         Extended the Btrieve Registry setup objects to create the Pervasive SQL
                         Client keys and added the registration of BIN\MKC.DLL for P.SQL v8

b551.023   09/07/03  HM  Bug Fix
                         ~~~~~~~
                         Extended the Btrieve Registry setup objects to create the Load Retries
                         key in the HKEY_LM\SOFTWARE\Btrieve Technologies\Microkernel Workstation
                         Engine\Version  6.15\Microkernel Interface\Settings\ section of the registry.

                         It is believed that this key was being created when Enterprise was run
                         causing the user to require unnecessary rights to modify the registry.


v5.51.022  27/06/03  HM  Released

v5.50.021  24/03/03  HM  Released

b550.021   04/02/03  HM  Mods
                         ~~~~
                         Added Data Query DLL and Drill-Down EXE into the OLE
                         Server registration section.

                         Localised the Version number from VerModU to this file.

b550.020   30/01/03  HM  Released for v5.50 Beta CD

b501.019   03/01/03  HM  Released with Beta COM Toolkit

b500.018   18/09/02  HM  Mods
                         ~~~~
                         Bundled support for ActiveX Preview component into the COM
                         Toolkit section.


  *** Version history from Aug00 to Aug02 lost ***

-----------------------------------------------------------------------------------------

b431.003   26/07/00  HM  Mods
                         ~~~~
                         Modified the initialisation of the Pervasive sections to create
                         the keys if their section exists.  This was on advice from DL, 
                         based on customer experiences. 

v4.31.002  12/06/00  HM  Bug 
                         ~~~
                         Modified the registration of the OLE Server. On fast machines the
                         test instance of the OLE being created after the WinExec command
                         was causing the re-registration of the OLE in the old directory
                         as both were running up simulataeously and interfering.
                       
b431.001             HM  Mods
                         ~~~~
                         Added following sections into workstation registry setup for 
                         P.SQL 2000 & ODBC:-
 
                           Pervasive Software\Microkernel Router\Version 7\Settings
                           Pervasive Software\Btrieve Requester\Version 7\Settings
                           Pervasive Software\Scalable SQL Requester\Version 4.01\Settings

v4.31      25/04/00  HM  Released

b430e.553
       03/04/00  HM   Bug
                      ~~~
                      Modified the COM Customisation Setup as was getting error 35 when
                      registering the COM Customisation in a Local Program Files directory.

b430e.550 30/09/99  HM  Converted to Delphi 5

b430e.500 31/08/99  HM  Converted to Delphi 4

-----------------------------------------------------------------------------------------

v4.30f    11/10/99  HM  Mods
                        ~~~~
                        Rebuilt to pickup logo change to SETUPBAS.

v4.30e    ????????  ??  ??????

v4.30d    12/04/99  MH  Release Version

b430.114  07/04/99  HM  Mods
                        ~~~~
                        Mods to P,sqL Settings.

b430.113  06/04/99  HM  Mods
                        ~~~~
                        Did various mods for P.SQL Requester Settings

v4.30c    26/02/99  HM  Released

b430.112  08/02/99  HM  Bug
                        ~~~
                        Previous mod failed because it was using RegObj instead of RegO,
                        it always failed to see the key, hence it fixed the error by never
                        trying to set the value!

v4.30b    01/02/99  HM  Bug
                        ~~~
                        Modified the setting of the Pervasive.SQL Btrieve/ODBC registry
                        keys to check to see if the setting existed. Under certain setups
                        they hadn't existed.

v4.30a    20/01/99  HM  Mod
                        ~~~
                        Added checking to see if the multi-user/single-user settings 
                        existed in the Btrieve registry section.

v4.30     04/01/99  HM  Released

b430.111  24/12/98  MH  Recompiled for RP3

b430.110  22/12/98  MH  v4.30 Beta Release

v4.24e    26/11/98  MH  Bug (in Delphi NOT my code)
                        ~~~
                        Modified EntReg to use a modified TRegistry
                        component, TEntRegistry, which will work under
                        NT if the user doesn't have admin rights. 

                        Fixed a bug in the setting of the 'Scalable 
                        SQL Requester' settings which caused them not
                        to be set.

v4.24d    20/11/98  MH  Mod
                        ~~~
                        Modified the Setup button to say Fix if ran
                        automatically from the splash screen.

v4.24c    20/10/98  MH  Mod
                        ~~~  
                        Increased the default number of record locks
                        per client from 200 to 1000 on EL's instruction.

v4.24b    07/10/98  MH  Bug
                        ~~~  
                        Modified setting of Scaleable SQL Local/Requester
                        flags for NT As they are Integers not Strings
                        in NT4.
 
b423.102  15/09/98  MH  Mods
                        ~~~~
                        Added support for setting the Scaleable SQL
                        Settings used by ODBC.

b423.101  14/08/98  MH  Mods
                        ~~~~
                        Added an option to allow the installation/
                        removal of the multi-company manager.

b423.100  13/08/98  MH  Mods
                        ~~~~
                        Rewrote EntReg to be based on the standard 
                        setup dialog and to ask which options it
                        should perform.

01/04/98   MH   Modified EntReg to initialise the Pervasive.SQL 
                Local/Requester Settings.

05/01/98   MH   Modified EntReg to check for things before running
                them, as I need to supply it with the Toolkit DLL
                which doesn't have the Graph or Ole Server.

28/11/97   MH   Changed UpdateBtrieve to set "Max Transactions"
                to 15 or higher.

****************************************************************************)

end.
