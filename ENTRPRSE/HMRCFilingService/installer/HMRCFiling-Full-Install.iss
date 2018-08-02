; NOTE. This installer requires Admin privileges.  
; Run Inno Setup as Admin to test from within.

#define MyAppName "Exchequer HMRC Filing Service"
#define MyAppVersion "9.1.18.23"
#define SETUPVersion "9.1.18.23"
#define MyAppPublisher "Advanced Business Software & Solutions Ltd"
#define MyAppURL "http://www.exchequer.com/"
#define MyAppExeName "HMRCFilingService.exe"

; SELECT FOR REQUIRED BUILD...
;#define DEBUG
#define RELEASE

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{4FFA44A6-DD4B-4616-8648-6E068BDAF3F9}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;VersionInfoVersion={#MyAppVersion}
VersionInfoVersion={#SETUPVersion}
VersionInfoProductVersion={#MyAppVersion}

AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DisableDirPage=yes
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
OutputBaseFilename=SetupHMRCFS
SetupIconFile=..\..\..\ENTRPRSE\BITMAPS\Exchequer 2017 R1 Graphics\Icons\adv_ico.ico
Compression=lzma
SolidCompression=yes
; This is required to allow a shortcut to be added to CommonStartup
PrivilegesRequired=admin

#ifdef RELEASE
  OutputDir=.\output\v{#MyAppVersion}\release
#else
  OutputDir=.\output\v{#MyAppVersion}\debug
; For testing on network installations
;  OutputDir="E:\ExchMapped\HMRC Filing Service"
;  OutputDir="C:\EXCHEQR\e2015R1.1\HMRC Filing Service"
#endif

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Messages]
WelcomeLabel1=Welcome to the [name] Setup Wizard
WelcomeLabel2=%n%n%n%n%nPlease refer to the Technical Documentation by clicking Help before installing this software.%n%n%n%n%n%n%n

[Dirs]
Name: "{pf}\{#MyAppName}"

[Files]
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

; Added \x86\ because VS added that in when changing the Release build from Any CPU to x86 
  Source: "..\CS\obj\x86\Release\BespokeFuncs.dll"; DestDir: "{app}"; Flags: ignoreversion

#ifdef RELEASE
  Source: "..\CS\bin\x86\Release\HMRCFilingService.exe"; DestDir: "{app}"; Flags: ignoreversion;
  Source: "..\CS\GUUConsole\bin\x86\Release\GUU.exe"; DestDir: "{app}"; Flags: ignoreversion;  
#else
  Source: "..\CS\bin\x86\Debug\HMRCFilingService.exe"; DestDir: "{app}"; Flags: ignoreversion;
  Source: "..\CS\GUUConsole\bin\x86\Debug\GUU.exe"; DestDir: "{app}"; Flags: ignoreversion;
#endif

[Run]
; Run the service with a command line parameter of --install.  This will cause 
; the program to self install as a service and start up. (See the Main function
; of the service application for further details)

Filename: "{app}\{#MyAppExeName}"; Parameters: "--install"; flags : nowait;
; This variant for debugging only...
;Filename: "{app}\{#MyAppExeName}"; Parameters: "--installonly"; flags : nowait;

[UninstallRun]
; Run the service with a command line parameter of --uninstall so that it stops
; and uninstalls itself as a service before the uninstaller attempts to remove it.
Filename: "{app}\{#MyAppExeName}"; Parameters: "--uninstall";

[Code]

const
  DRIVE_UNKNOWN = 0; // The drive type cannot be determined.
  DRIVE_NO_ROOT_DIR = 1; // The root path is invalid. For example, no volume is mounted at the path.
  DRIVE_REMOVABLE = 2; // The disk can be removed from the drive.
  DRIVE_FIXED = 3; // The disk cannot be removed from the drive.
  DRIVE_REMOTE = 4; // The drive is a remote (network) drive.
  DRIVE_CDROM = 5; // The drive is a CD-ROM drive.
  DRIVE_RAMDISK = 6; // The drive is a RAM disk.
  
var
  PreReqPage : TOutputMsgWizardPage;   // Displays a message about checking for prerequisites
  CancelWithoutPrompt : boolean;  // Allows the Installer to close without confirmation
  ComputerName : string;
  mappedINIfile : TArrayOfString;
  toolkit      : variant;
  exchMap      : string;
  uncMap       : string;
  uncDrive     : string;

  HelpButton : TNewButton ;

//-----------------------------------------------------------------------------
procedure ShowMessage(theMessage : string);
begin
  MsgBox(theMessage, mbInformation, mb_Ok);
end;

//-----------------------------------------------------------------------------
function Create_PrereqPage(predecessor : integer) : integer;
begin
  PreReqPage := CreateOutputMsgPage(predecessor,
    'Pre-install Checks', 'Checking for Pre-requisites.', 
    'The HMRC Filing Service requires .NET 4.5.2 or higher.'#13#10#13#10 + 
    '.NET 4.5.2 or higher found.  Installation of HMRC Filing Service may proceed.');
  result := PreReqPage.ID;
end;    

//-----------------------------------------------------------------------------
// PKR. 02/11/2015. ABSEXCH-17008. Add a Hep button to the HMRC Filing Service installer.
// NB. Button is only displayed if a Readme.txt file exists in the source directory.
//-----------------------------------------------------------------------------
procedure HelpButtonOnClick(Sender: TObject);
var
  HelpPath : string;
  params   : string;
  ErrorCode : integer;
begin
  HelpPath := ExpandConstant('{src}') + '\readme.txt';

  ShellExec('open', HelpPath, '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

//-----------------------------------------------------------------------------
procedure CreateHelpButton(ParentForm : TSetupForm; 
                           X          : integer;
                           Y          : integer;
                           W          : integer;
                           H          : integer);

begin
  HelpButton         := TNewButton.Create (ParentForm);
  HelpButton.Left    := X;
  HelpButton.Top     := Y;
  HelpButton.Width   := W;
  HelpButton.Height  := H;
  HelpButton.Caption := '&Help';
  HelpButton.OnClick := @HelpButtonOnClick;
  HelpButton.Parent  := ParentForm;
end ;

//-----------------------------------------------------------------------------
procedure CreateCustomWizardPages;
var
  LastId : integer;
begin
  LastId := wpWelcome;
  LastId := Create_PrereqPage(LastId);
end;

//-----------------------------------------------------------------------------
// This runs before the wizard is created.
procedure InitializeWizard;
begin
  CreateCustomWizardPages;
  CancelWithoutPrompt := false;
  ComputerName := GetComputerNameString;

  WizardForm.WelcomeLabel2.Font.Style := [fsBold]; //Bold

  CreateHelpButton (WizardForm, ScaleX (200), WizardForm.CancelButton.Top, WizardForm.CancelButton.Width, WizardForm.CancelButton.Height) ;

  // Get the Exchequer directory
  toolkit := CreateOleObject('Enterprise04.Toolkit');
  exchMap := toolkit.Configuration.EnterpriseDirectory;
  // Get its UNC form
  // MH 26/10/2015 ABSEXCH-16991: Fixed issue where directory wasn't being recognised due to case-sensitivity
  uncMap  := Uppercase(ExpandUNCFilename(exchMap));
end;


//-----------------------------------------------------------------------------
function GetLogicalDriveStrings( nLenDrives: LongInt; lpDrives: String ): Integer;
external 'GetLogicalDriveStringsW@kernel32.dll stdcall';

function GetDriveType( lpDisk: String ): Integer;
external 'GetDriveTypeW@kernel32.dll stdcall';

//-----------------------------------------------------------------------------
procedure CancelButtonClick(CurPageID: Integer; var Cancel, Confirm: Boolean);
begin
  if CurPageID <> wpInstalling then
    Confirm := not CancelWithoutPrompt;
end;

//-----------------------------------------------------------------------------
// This function is a modified version of one obtained from StackOverflow.  
// Some of it is unnecessary for our needs, but it works.
// Modified to pass in the Release value to look for.
function IsDotNetDetected(version: string; servicePack: cardinal; aRelease : DWORD): boolean;
// Indicates whether the specified version and service pack of the .NET Framework is installed.
//
// version -- Specify one of these strings for the required .NET Framework version:
//    'v1.1.4322'     .NET Framework 1.1
//    'v2.0.50727'    .NET Framework 2.0
//    'v3.0'          .NET Framework 3.0
//    'v3.5'          .NET Framework 3.5
//    'v4\Client'     .NET Framework 4.0 Client Profile
//    'v4\Full'       .NET Framework 4.0 Full Installation
//    'v4.5'          .NET Framework 4.5
//
// service -- Specify any non-negative integer for the required service pack level:
//    0               No service packs required
//    1, 2, etc.      Service pack 1, 2, etc. required
//
// aRelease -- Used for .NET 4.5 onwards. Specify one of the following values
// For reference, other possible values for Release are:
//    378389  .NET Framework 4.5
//    378675  .NET Framework 4.5.1 installed on Windows 8.1 or Windows Server 2012 R2
//    378758  .NET Framework 4.5.1 installed on Windows 8, Windows 7 SP1, or Windows Vista SP2
//    379893  .NET Framework 4.5.2
//    393295  .NET Framework 4.6   On Windows 10 systems
//    393297  .NET Framework 4.6   On all other OS versions
// Note that for 4.5.1 and 4.6, either determine the OS version first, or make 2 calls.
var
  key: string;
  install, release, serviceCount: cardinal;
  check45, success: boolean;
begin
  // .NET 4.5 installs as update to .NET 4.0 Full
  if version = 'v4.5' then 
  begin
    version := 'v4\Full';
    check45 := true;
  end 
  else
  begin
    check45 := false;
  end;

  // installation key group for all .NET versions
  key := 'SOFTWARE\Microsoft\NET Framework Setup\NDP\' + version;

  // .NET 3.0 uses value InstallSuccess in subkey Setup
  if Pos('v3.0', version) = 1 then 
  begin
    success := RegQueryDWordValue(HKLM, key + '\Setup', 'InstallSuccess', install);
  end 
  else 
  begin
    success := RegQueryDWordValue(HKLM, key, 'Install', install);
  end;

  // .NET 4.0/4.5 uses value Servicing instead of SP
  if Pos('v4', version) = 1 then 
  begin
    success := success and RegQueryDWordValue(HKLM, key, 'Servicing', serviceCount);
  end 
  else 
  begin
    success := success and RegQueryDWordValue(HKLM, key, 'SP', serviceCount);
  end;

  // .NET 4.5 uses additional value Release
  if check45 then 
  begin
    success := success and RegQueryDWordValue(HKLM, key, 'Release', release);
    success := success and (release >= aRelease); // v4.5.2
  end;

  result := success and (install = 1) and (serviceCount >= servicePack);
end;


//-----------------------------------------------------------------------------
// This runs right at the beginning of execution of Setup.
function InitializeSetup(): Boolean;
begin
  result := true;
end;


//-----------------------------------------------------------------------------
procedure CurPageChanged(CurPageID: Integer);
var
  installDrive : string;
  driveLetters : string;
  driveType    : integer;
  lenLetters   : integer;
  index        : integer;
  drive        : string;

  mIndex        : integer;
  pPos          : integer;

  debugMsg      : string;
  dTypeStr      : string;

  coManager     : variant;
  coIndex       : integer;
  coPath        : string;
  coDrive       : string;
begin
  HelpButton.Visible := (CurPageId = wpWelcome) and (FileExists(ExpandConstant('{src}') + '\readme.txt'));

  if (CurPageId = PreReqPage.ID) then
  begin
    //. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
    // Check for .NET 4.5.2 (Release 379893 = 4.5.2)
    if not IsDotNetDetected('v4.5', 0, 379893) then 
    begin
      MsgBox('HMRC Filing Service requires Microsoft .NET Framework 4.5.2.'#13#13
             'Please use Windows Update to install this version,'#13
             'and then re-run this setup program.', mbInformation, MB_OK);

      CancelWithoutPrompt := true; 
      WizardForm.Close;
    end;

    // Check that this is being installed from a mapped drive
    installDrive := ExpandConstant('{src}');
    // MH 26/10/2015 ABSEXCH-16991: Fixed issue where directory wasn't being recognised due to case-sensitivity
    uncDrive := Uppercase(ExpandUNCFilename(installDrive));
    
    //#ifdef DEBUG
//    ShowMessage('EnterpriseDirectory : ' + exchMap + ' (' + uncMap + ')');
//    ShowMessage('Installer location  : ' + installDrive + ' (' + uncDrive + ')');
//#endif

    // MH 26/10/2015 ABSEXCH-16991: Fixed issue where directory wasn't being recognised due to case-sensitivity
    pPos := Pos(uncMap, uncDrive);
    if (pPos <> 1) then
    begin
      MsgBox('The HMRC Filing Service must be installed from the HMRC Filing Service folder within the Exchequer folder.', mbError, MB_OK);
      CancelWithoutPrompt := true; 
      WizardForm.Close;
    end;

    //. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
    // Build a list of mapped drives

    // Get all drives letters of the system
//    driveletters := StringOfChar( ' ', 64 );
//    lenletters := GetLogicalDriveStrings( 63, driveletters );
//    SetLength( driveletters , lenletters );
    // The string returned by GetLogicalDriveStrings is null-separated, with an extra null on the end.
    // Like this (where # represents null):
    // C:\#E:\#W:\#X:\##

    // Check the MCM companies for their mapped drive letters
    mIndex := 0;
    coManager := toolkit.Company;
    for coIndex := 1 to coManager.cmCount do
    begin
      coPath := coManager.cmCompany[coIndex].coPath;
      coDrive := ExtractFileDrive(coPath);

      uncDrive := ExpandUNCFilename(ExpandConstant('{drive:' + coDrive + '}'));
      // We need to add the drive mapping to the list

      // Get the drive type so that we don't include removable drives
      driveType := GetDriveType(drive);
#ifdef DEBUG
      if driveType = DRIVE_UNKNOWN then dTypeStr := 'DRIVE_UNKNOWN';
      if driveType = DRIVE_NO_ROOT_DIR then dTypeStr := 'DRIVE_NO_ROOT_DIR';
      if driveType = DRIVE_REMOVABLE then dTypeStr := 'DRIVE_REMOVABLE';
      if driveType = DRIVE_FIXED then dTypeStr := 'DRIVE_FIXED';
      if driveType = DRIVE_REMOTE then dTypeStr := 'DRIVE_REMOTE';
      if driveType = DRIVE_CDROM then dTypeStr := 'DRIVE_CDROM';
      if driveType = DRIVE_RAMDISK then dTypeStr := 'DRIVE_RAMDISK';

      debugMsg := debugMsg + Format('Drive %s maps to %s'#13#10, [drive, uncDrive]);
#endif

      if (driveType = DRIVE_REMOTE) or (driveType = DRIVE_FIXED) then
      begin
        SetLength(mappedINIFile, mIndex+1);

        mappedINIFile[mIndex] := coDrive + '=' + uncDrive;
        inc(mIndex);
      end
    end;

    CreateDir(ExpandConstant('{pf}\{#MyAppName}'));
    SaveStringsToFile(ExpandConstant('{pf}\{#MyAppName}') + '\MappedDrives.ini', mappedINIFile, false);
  end;

  if (CurPageId = wpFinished) then
  begin
    // Write the INI file to the installation directory. false=overwrite
//    SaveStringsToFile(ExpandConstant('{pf}\{#MyAppName}') + '\MappedDrives.ini', mappedINIFile, false);
  end;

end;

