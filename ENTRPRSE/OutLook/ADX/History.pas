unit History;
{

}
interface

const
  ExchVer  = 'v7.0.5';  // Exchequer Version
  BuildVer = '031';   // Build Number

function KPIVer: string;

implementation

uses ExchequerRelease;

function KPIVer: string;
begin
  Result := ExchequerModuleVersion(emOutlookDynamicDashboard, BuildVer);
  // Result := ExchVer + '.' + BuildVer;
end;

(****************************************************************************

VERSION HISTORY
===============
12/07/2013   KPI v7.0.5.031
  CS  Updated image files for re-branding

09/05/2013   KPI v7.0.4.030
  CS  Copied changes from v7.1 for checking for Windows versions from Vista
      onwards (IKPIAvailablePluginsU.pas)

14/11/2012   KPI v7.0.029
  CS  Updated the logo images on the Banner Configuration dialog, and corrected
      the 'banner on top' settings label to refer to 'IRIS Exchequer' rather
      than simply IRIS.

14/09/2012   KPI v7.0.028
  CS  Updated the version number

10/09/2012   KPI v7.0.027
  CS  Updated the version number

13/01/2011   KPI v6.5.026
  CS  Updated the version number

11/11/2010   KPI v6.4.025
  CS  Updated the display caption for the Outlook Today page

09/09/2010   KPI v6.4.024
  CS  Installed release version of Add-in Express components

21/05/2010   KPI v6.4.023
  CS  Reimplemented missing Configure Label dialog.

21/05/2010   KPI v6.4.022
  CS  ABSEXCH-9847  ODD not working in Office 2010 - installed new version of
      Add-in Express components.

24/07/2009   KPI v6.01.021
  CS  FRv6.01.193 - Amended TKPILayoutManager to correctly translate HTML
      entities when reading them from the user's configuration file.

23/07/2009   KPI v6.01.020
  CS  Updated TKPIHostControl to update the plugin configuration details after
      the user changes the configuration.

21/07/2009   KPI v6.01.019
  CS  Rebuilt the DLLs to fix a problem with Outlook crashing.

15/07/2009   KPI v6.01.018
  CS  Added support for user-defined labels.

26/06/2009   KPI v6.01.017
  CS  Added support for marking a plugin as not currently available (e.g. where
      the plugin is for a module that is not licenced).

24/06/2009   KPI v6.01.016
  CS  Corrected resizing of banner, to prevent access violation (NOTE: the
      access violation is only visible when running under Delphi).

10/07/2008   KPI v6.00.006
  BH  KPIManager.ExclusiveOpInProgress prevents PushData, DrillDown and Configure from
      happening simultaneously. As each is likely to result in a plugin trying to open
      the COM Toolkit this was resulting in error 32762 when it was already open.

09/07/2008   KPI v6.00.005
  BH  Send version and dll path info to each plugin.
      Double-clicking the version number will display the dll path.

04/07/2008   KPI v6.00.004

  BH  Corrected an issue when the user has multiple copies of the same control.
      Set_dpMessageId must be called before a call to CheckIDPFile.

08/02/2007   KPI v5.71.003
--------------------------------------------------------------------------------

  CS  Added checks for the environment path to make sure that Authoris-E
      plugins can find the Exchequer installation directory.

26/01/2007   KPI v5.71.002
--------------------------------------------------------------------------------

  CS  Added refresh after drill-down, and manual refresh (via pop-up menu).


10/01/2007   KPI v5.71.001
--------------------------------------------------------------------------------

  CS  Added licensing and version number.

*)

end.
