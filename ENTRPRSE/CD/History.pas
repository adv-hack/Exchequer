unit History;

interface

Const
  // Current Exchequer CD Auto-run version
  CurrVer_SetupAutoRun = 'Build 334';

implementation

(****************************************************************************

CD Auto-run Version History
===========================

Build 334  16/11/2017   (2018 R1)
---------------------------------------------------------------------
  MH    Rebuilt to support changes for new GDPR Release Codes and 2018-R1 Licence Version
   

Build 333  13/10/2016   (2017 R1)
---------------------------------------------------------------------
  MH    Completely redid the main window UI for branding reasons


Build 332  28/05/2015   (v7.0.14)
---------------------------------------------------------------------
  MH    Recompiled to pickup modified copyright


Build 331  21/07/2014   (v7.0.11)
---------------------------------------------------------------------
  MH    ABSEXCH-15467: Removed CD Serial Number Check


Build 330  08/01/13     (v7.0.5)
---------------------------------------------------------------------
  MH    Mod     Rebranded for Advanced


Build 329  19/11/12     (v7.0)
---------------------------------------------------------------------
  MH    Mod     Added support for Small Business Edition


Build 328  10/09/12     (v7.0)
---------------------------------------------------------------------
  MH    Mod     Updated branding for v7.0 and changed copyright to 2013

Build 327  26/10/11     (v6.9)
---------------------------------------------------------------------
  MH    Mod     Updated copyright to 2012


Build 326  05/03/09     (v6.01)
---------------------------------------------------------------------
  MH    Mod     Removed SQL Demo Version on MR's instruction


Build 325  07/01/09     (v6.01)
---------------------------------------------------------------------
  MH    Mod     Removed SQLOnly compiler definition to reinstate support for the Pervasive Edition

  MH    Mod     Updated copyright in about message and on-form to 2009


Build 324  06/02/08
---------------------------------------------------------------------
  MH    Mod     Removed 'Exchequer Demo (Pervasive Edition)' option for v6.00 SQL Edition release

  MH    Mod     Stopped support of Pervasive Edition licences for v6.00 SQL Edition release


Build 323  31/10/07
---------------------------------------------------------------------
  MH    Mod     Removed 'Exchequer Demo (Microsoft SQL Edition)' option for v6.00 Pervasive Edition release


Build 322  09/10/07
---------------------------------------------------------------------
  MH    Mod     Updated Icon


Build 321  21/09/07
---------------------------------------------------------------------
  MH    Mod     Changed to handle P.SQL and MS SQL variants of the Auto-Upgrade


Build 320  06/03/07
---------------------------------------------------------------------
  MH    Mod     Rebuilt to pickup new v6.00 licence structures

  MH    Mod     Modified licence checks to reject MS SQL licences


Build 313  02/02/07
---------------------------------------------------------------------
  MH    Bug     Fixed bug in alpha sorting of modules which caused the first module to be lost


Build 312  09/01/07
---------------------------------------------------------------------
  MH    Mod     Recompiled to pickup support for Outlook Dynamic Dashboard

  MH    Mod     Modified Read Licence dialog to list modules in alphabetical order


Build 311  11/12/06
---------------------------------------------------------------------
  MH    Bug     Modified TreeView in Read Licence dialog to prevent paths being edited


Build 310  28/11/06
---------------------------------------------------------------------
  MH    Bug     Added missing XP manifest

  MH    Bug     Corrected version description as you got double forward slashes
                on client-server licences

  MH    Mod     Modified the display of licence details to auto-expand the module
                details, moved the CD info to the top and the DB info before the
                modules so all info was visible.

  MH    Mod     Created History.Pas and moved version into it from VerModu.pas


Build 309  27/11/06
---------------------------------------------------------------------
  MH    Mod    Rewrote the Read Licence dialog to use the ShellTreeView control
               instead of the Drive/Directory controls as under Windows Vista
               mapped network drives weren't showing up.

****************************************************************************)
end.
