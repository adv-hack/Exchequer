{*********************************************************}
{*                     PInst.PAS                         *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* A Utility to install the APD Fax Printer Driver.      *}
{*********************************************************}

program PInst;
  {- Utility to install an APD Fax Printer Driver }

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}
  
uses
  WinTypes,
  WinProcs,
  Messages,
  SysUtils,
  Dialogs,
  OoMisc,
  PDrvInNT,
  PDrvInst;

var
  QuietOperation : Boolean;
    { Suppresses success/failure prompts when true}
begin
  QuietOperation := (ParamCount > 0) and (pos('Q',UpperCase(ParamStr(1))) <> 0);
  if IsWinNT then
    InstallDriver32('')
  else
    InstallDriver('APFGEN.DRV');

  if not QuietOperation then
    case DrvInstallError of
      ecOK :
        MessageDlg('APF Fax Printer Driver Installed OK', mtInformation,
                   [mbOK], 0);
      ecUniAlreadyInstalled : ;
      ecUniCannotGetSysDir :
        MessageDlg('Couldn''t determine Windows\System directory',
                   mtError, [mbOK], 0);
      ecUniCannotGetPrinterDriverDir :
        MessageDlg('Couldn''t determine Windows NT printer driver directory',
                   mtError, [mbOK], 0);
      ecUniCannotGetWinDir :
        MessageDlg('Couldn''t determine Windows directory',
                   mtError, [mbOK], 0);
      ecUniUnknownLayout :
        MessageDlg('   -- Unknown Windows Layout --'+#13+
                   'Unable to locate  required  support'+#13+
                   'files',
                   mtError, [mbOK], 0);
      ecUniCannotInstallFile :
        MessageDlg('Unidriver files '+
                   'not installed.  The print driver'+#13+
                   'may not be configured properly.',
                    mtError, [mbOK], 0);
      ecDrvCopyError :
        MessageDlg('Unable to copy printer driver to Windows system directory',
                   mtError, [mbOK], 0);
      ecCannotAddPrinter :
        MessageDlg('Could not install APFGEN.DRV as a Windows printer',
                   mtError, [mbOK], 0);
      ecDrvBadResources :
        MessageDlg('Printer driver file contains bad or missing string resources',
                   mtError, [mbOK], 0);
      ecDrvDriverNotFound :
        MessageDlg(format('A required printer driver file (%s) was not found',[ErrorFile]),
                   mtError, [mbOK], 0);
    else
      MessageDlg('Unknown installation error : '+ IntToStr(DrvInstallError),
                 mtError, [mbOK], 0);
    end;
end.
