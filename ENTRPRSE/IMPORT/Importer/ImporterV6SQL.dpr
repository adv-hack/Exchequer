program ImporterV6SQL;

{******************************************************************************}
{                                 Importer                                     }
{                                 ========                                     }
{                                                                              }
{ The DBA (TDBA) and TImportToolkit are the only object classes that contain   }
{ any Exchequer-specific code. Future amendments should ensure that this       }
{ remains the case.                                                            }
{                                                                              }
{******************************************************************************}

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  ShareMem,
  {$IFDEF IMPv6}
    D6OnHelpFix,
    conHTMLHelp,
  {$ENDIF}
  Forms,
  dialogs,
  windows,
  sysutils,
  main in 'main.pas' {frmMain},
  Login in 'Login.pas' {frmLogin},
  EditRecord in 'EditRecord.pas' {frmEditRecord},
  TIniClass in 'TIniClass.pas',
  MapMaint in 'MapMaint.pas' {frmMapMaint},
  FileViewer in 'FileViewer.pas' {frmFileViewer},
  IniMaint in 'IniMaint.pas' {frmIniMaint},
  Utils in 'Utils.pas',
  GlobalConsts in 'GlobalConsts.pas',
  GlobalTypes in 'GlobalTypes.pas',
  IniRecMaint in 'IniRecMaint.pas' {frmIniRecMaint},
  RecordSizes in 'RecordSizes.pas' {frmRecordSizes},
  TImportJobClass in 'TImportJobClass.pas',
  TMapsClass in 'TMapsClass.pas',
  TBuildImportJobsClass in 'TBuildImportJobsClass.pas',
  TJobQueueClass in 'TJobQueueClass.pas',
  TFindFilesClass in 'TFindFilesClass.pas',
  TRecordMgrClass in 'TRecordMgrClass.pas',
  TAutoIncClass in 'TAutoIncClass.pas',
  TStdImpFileClass in 'TStdImpFileClass.pas',
  TDBAClass in 'TDBAClass.pas',
  TLoggerClass in 'TLoggerClass.pas',
  TErrors in 'TErrors.pas',
  DefaultSettings in 'DefaultSettings.pas' {frmDefaultSettings},
  Wizard in 'Wizard.pas' {frmWizard},
  Scheduler in 'Scheduler.pas' {frmScheduler},
  JobQueue in 'JobQueue.pas' {frmJobQueue},
  EditBox in 'EditBox.pas' {frmEditBox},
  ViewLogFile in 'ViewLogFile.pas' {frmViewLogFile},
  TrayIcon in 'TrayIcon.PAS' {frmTrayIcon},
  TScheduleClass in 'TScheduleClass.pas',
  TPosterClass in 'TPosterClass.pas',
  VAOUtil in 'x:\ENTRPRSE\FUNCS\VAOUtil.pas',
  Btrvu2 in 'x:\SBSLIB\WIN\WIN32\BTRVU2.PAS',
  ECBUtil in 'x:\ENTRPRSE\FUNCS\ECBUtil.pas',
  TImportToolkitClass in 'TImportToolkitClass.pas',
  EntLicence in 'x:\ENTRPRSE\DRILLDN\EntLicence.pas',
  TBtrvFileClass in 'TBtrvFileClass.pas',
  Confirm in 'Confirm.pas' {frmConfirm},
  Patches in 'Patches.pas' {frmPatches},
  About in 'About.pas' {frmAbout},
  TBigIniClass in 'TBigIniClass.pas',
  TCSVClass in 'TCSVClass.pas';

{$R *.res}
{$R WINXPMAN.RES}

const
  MAINTITLE: pchar   = 'Exchequer Importer v'; // length=20, so only check windows with titles > 19
{* The design-time caption of the main form is deliberately set so that it doesn't match MAINTITLE and
   therefore doesn't get selected by EnumCallBack below when debugging with main.pas open.*}
  TITLELENGTH: integer = 20;
  BUTTONTITLE: pchar = 'Importer - Exchequer';

var
  CurrentWnd: HWND; // the handle of the main window
  ButtonWnd: HWND;  // The handle of the button on the task bar

        function EnumCallBack(ThisWnd: HWND; LParam: lparam): bool; stdcall;
        var
          WindowText: array[0..31] of char;
          WindowClass: array[0..12] of char;
        begin
          Result := True; // continue until all top-level windows have been enumerated
          if (GetWindowTextLength(ThisWnd) > TITLELENGTH - 1) then begin // don't need to check every window
            GetWindowText(ThisWnd, WindowText, TITLELENGTH + 1);
            GetClassName(ThisWnd, WindowClass, 13);
            if (string(WindowClass) = 'TApplication') and (string(WindowText) = BUTTONTITLE) then
              ButtonWnd := ThisWnd // this is the button on the task bar
            else
              if (string(WindowClass) = 'TfrmMain') and (string(WindowText) = MAINTITLE) then
                CurrentWnd := ThisWnd; // this is the main window if it hasn't been minimised to the task bar
          end;
        end;

function AlreadyRunning: Boolean;
// If another instance of Importer is running then display it.
// If it's Scheduler running in the system tray it won't be displayed but this
// new instance will still exit.
var
  MutexHandle: THandle;
begin
  result := False;
  MutexHandle := CreateMutex(nil, TRUE, MAINTITLE); // try to create a uniquely-named Mutex
  if MutexHandle <> 0 then
    if GetLastError = ERROR_ALREADY_EXISTS then // another instance already owns this Mutex
      result := True;                           // which means Importer.exe is already running.

  if result then begin // if already running, find the main window and display it.
    CurrentWnd := 0;   // the main window
    ButtonWnd  := 0;   // the button on the taskbar
    EnumWindows(@EnumCallBack, 0);                     // find all top-level windows
    if (ButtonWnd <> 0) and (IsIconic(ButtonWnd)) then // if a TApplication is minimized you have to restore the taskbar button
      ShowWindow(ButtonWnd, SW_RESTORE)                // not the main window.
    else
      if (CurrentWnd <> 0) and IsWindowVisible(CurrentWnd) then // ignore if not visible as this indicates running in Scheduler mode
        SetForegroundWindow(CurrentWnd);
  end;
end;

function ImporterLicensed: boolean;
begin
  result := EnterpriseLicence.elModules[modImpMod] <> mrNone;
  if not result then
    MessageBox(GetDesktopWindow, 'Importer is not licensed for use', 'Exchequer Importer', mb_OK);
end;

begin
  {$IFDEF IMPv6}  // Licensing only appropriate from Exchequer v6 onwards.
    if not EnterpriseLicence.IsLITE then // Licensing doesn't get checked in an AIO environment, only in an Exchequer environment
      if not ImporterLicensed then EXIT;
  {$ENDIF}
  Application.Initialize;
  if EnterpriseLicence.IsLITE then begin
    Application.Title  := 'Importer - IRIS Accounts Office';
    MAINTITLE          := 'IRIS Accounts Office Importer v';
    TITLELENGTH        := 31;
    BUTTONTITLE        := 'Importer - IRIS Accounts Office';
  end
  else
    Application.Title    := 'Importer - Exchequer'; // so users can distinguish the taskbar button from Exchequer's
  {$IFDEF IMPv6}
    Application.HelpFile := 'Importer.chm';
  {$ELSE}
    Application.HelpFile := 'Importer.hlp';
  {$ENDIF}
  ApplyUpdPatches;                           // make sure UPD patches get applied soonest even if next line exits the program
  if AlreadyRunning then exit;               // only allow one instance of Importer.exe
  if SchedulerMode then begin                // set in initialization of GlobalConsts
    Application.ShowMainForm := false;       // also need visible=false set in dfm in main.pas, quirk of MDI
    Application.CreateForm(TfrmTrayIcon, frmTrayIcon);
    TfrmScheduler.Show('', false);           // Starts up Scheduler but doesn't show the window.
  end
  else
    TfrmLogin.Show;
  if LoginOK or SchedulerMode then begin
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
  end;

{* Delphi has an annoying habit of changing this code if you add a new form to the project *}
{* Here's a copy to check against *}
{
  {$IFDEF IMPv6)  // Licensing only appropriate from Enterprise v6 onwards.
    if not EnterpriseLicence.IsLITE then // Licensing doesn't get checked in an AIO environment, only in an Exchequer environment
      if not ImporterLicensed then EXIT;
  {$ENDIF)
  Application.Initialize;
  if EnterpriseLicence.IsLITE then begin
    Application.Title  := 'Importer - IRIS Accounts Office';
    MAINTITLE          := 'IRIS Accounts Office Importer v';
    TITLELENGTH        := 31;
    BUTTONTITLE        := 'Importer - IRIS Accounts Office';
  end
  else
    Application.Title    := 'Importer - Exchequer'; // so users can distinguish the taskbar button from Exchequer's
  {$IFDEF IMPv6)
    Application.HelpFile := 'Importer.chm';
  {$ELSE)
    Application.HelpFile := 'Importer.hlp';
  {$ENDIF)
  ApplyUpdPatches;                           // make sure UPD patches get applied soonest even if next line exits the program
  if AlreadyRunning then exit;               // only allow one instance of Importer.exe
  if SchedulerMode then begin                // set in initialization of GlobalConsts
    Application.ShowMainForm := false;       // also need visible=false set in dfm in main.pas, quirk of MDI
    Application.CreateForm(TfrmTrayIcon, frmTrayIcon);
  TfrmScheduler.Show('', false);           // Starts up Scheduler but doesn't show the window.
  end
  else
    TfrmLogin.Show;
  if LoginOK or SchedulerMode then begin
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
  end;
}
end.

