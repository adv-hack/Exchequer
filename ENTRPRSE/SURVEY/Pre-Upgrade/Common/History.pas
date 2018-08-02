unit History;

interface

Const
  SurveyVersion = 'v7.0.5.006';
  {$IFDEF SQLSurvey}
    SurveyType = 'MSSQL';
  {$ELSE}
    SurveyType = 'Pervasive';
  {$ENDIF}

implementation

(*********************************************************************************************

VERSION HISTORY
===============

09/07/2013  v7.0.5.006
--------------------------------------------------------------------------------------------
  MH       Rebranded for Advanced


11/01/2013  v7.0.005
--------------------------------------------------------------------------------------------
  MH       ABSEXCH-13907 - Extended Pervasive version's addition data file analysis to catch
           and report COM Toolkit errors caused by dodgy data.


02/01/2013  v7.0.004
--------------------------------------------------------------------------------------------
  MH      ABSEXCH-13869 - Added licensing checks into the Pervasive version's addition data file
          analysis which uses the COM Toolkit to prevent the COM Toolkit displaying errors when
          accessing an unlicensed component, e.g. Stocck or Job Costing.  Also backdoored the COM
          Toolkit.


22/11/2012  v7.0.003
--------------------------------------------------------------------------------------------
Updated version  MH      Corrected default email address info to IRISEntrprise.co.uk


15/11/2012  v7.0.002
--------------------------------------------------------------------------------------------
  MH      Modified checks for local program files to be SQL compatible

08/11/2012  v7.0.001
--------------------------------------------------------------------------------------------
  MH      Re-engineered for v7 and SQL + Pervasive support


21/02/08  v6.00.011
--------------------------------------------------------------------------------------------
  MH      Modified ESN output as it wasn't being output for v4.30c-v5.00


16/01/08  v6.00.010
--------------------------------------------------------------------------------------------
  NF      Added new field to store the Service Pack of the Network Operating System.


03/01/08  v6.00.009
--------------------------------------------------------------------------------------------
  MH      Re-Applied the .008 changes Chris did as he didn't have rights to save them.


26/11/07  v6.00.008
--------------------------------------------------------------------------------------------
  CS      Corrected file version checking (GetEngineVersion in oBtrieveFile.pas).


06/11/07  v6.00.007
--------------------------------------------------------------------------------------------
  MH      Extended version checks to identify v5.71 by presence of LIB\CORE.EBF and added
          date of Enter1.Exe as corroboration


29/10/07  v6.00.006
--------------------------------------------------------------------------------------------
  MH      Corrected typo on Survey Results dialog


24/10/07  v6.00.005
--------------------------------------------------------------------------------------------
  MH      Modified XML output to catch special characters in Company Code & Plug-In Names

  MH      Modified Contact Details:-

              Fixed bug where a blank Fax Number reported an error on the Address

              Added validation mode for Contact Method = Post

              Added mandatory fields indication dependant on Contact Method

  MH      Modified Survey Results dialog:-

              Removed Copy button

              Re-did instructions using RTF telling them how to do an email


15/10/07  v6.00.004
--------------------------------------------------------------------------------------------
  MH      Added support for trade counter Plug-Ins


11/10/07  v6.00.003
--------------------------------------------------------------------------------------------
  MH      Added Plug-Ins from EntCustm.Ini into the XML


30/07/07  v6.00.002
--------------------------------------------------------------------------------------------
  MH      Fixed a bug where VarConst was opening all the data files unnecessarily


23/07/07- v6.00.001
--------------------------------------------------------------------------------------------
  MH      Copied and re-wrote the v4 survey to v6 specifications.

****************************************************************************)

end.


