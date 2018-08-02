;
; Exchequer Credit Card Add-in installer.
;
;============================================================================== 
; This is an Inno Setup script to create an installer for the Credit Card Add-in.
;
; Inno Setup is free, open-source software available from http://www.jrsoftware.org
; It is tried and trusted and happens to be the most popular free setup creator usedworldwide.
;============================================================================== 
;
; This installer copies the DLLs required for the Credit Card Add-in and the 
; Exchequer Payments Portal.
; It Registers DLLs that need registering, and calls the Exchequer EnterpriseSecurity.ThirdParty
; COM object to add a 30-day licence for the Add-in.
;
; The Uninstaller unregisters the DLLs, and removes them.
; It does NOT remove the licence, which means that it is possible for the add-in 
;  to be licenced but not actually installed.
;
; Change History
; ==============
; Who  Version       Date          JIRA       Description
; PKR  1.0.0.0    18/11/2014        ~~        Initial version - simple installer
; PKR  1.0.1.1    19/11/2014        ~~        Added licence handling
; PKR  1.0.2.2    20/11/2014  ABSEXCH-15840   Added registration of DLLs. 
;                             ABSEXCH-15839   Fixed up reading Registry for Exchequer root directory (WOW6432Node problem)
;                                             Changed Browse so that DefaultDirName is not appended to the selected path
; PKR  1.0.2.3    21/11/2014  ABSEXCH-15842   Changed registration and unregistration of DLLs.
; PKR  1.0.2.4    24/11/2014  ABSEXCH-15842   Credit Card config updated.  Toolkit uses backdoor.
; PKR  1.0.2.5    25/11/2014        ~~        Force installation directory without user choice
;                                             Changed installation directory to be sub-directory of Exchequer root.
; PKR  1.0.2.6    25/11/2014  ABSEXCH-15850   Correct handling of sub-companies with toolkit
;                             ABSEXCH-15851   Added Company Code to config drop-down list.
; PKR  1.0.2.7    27/11/2014  ABSEXCH-15858, ABSEXCH-15859, ABSEXCH-15860.
; PKR  1.0.2.8    02/12/2014  ABSEXCH-15868, ABSEXCH-15869, ABSEXCH-15858, ABSEXCH-15860, ABSEXCH-15881
; PKR  1.0.2.9    02/12/2014  ABSEXCH-15860   revisited
; PKR  1.0.2.10   02/12/2014  ABSEXCH-15860   revisited
; PKR  1.0.2.11   04/12/2014  ABSEXCH-15889   Removed Interop.Enterprise.dll
;                                             New Portal assemblies.
; PKR  1.0.2.12   05/12/2014  ABSEXCH-15903   Add horizontal scroll bar to Config table.
; PKR  1.0.2.13   05/12/2014  ABSEXCH-15902   Fixed Config Update when Merchant ID name changes.
; PKR  1.0.2.14   11/12/2014  ABSEXCH-15856   Indicator to show that something is happening after clicking Take Payment.
; PKR  1.0.2.15   15/12/2014  ABSEXCH-15876   Refunds
; PKR  1.0.3.16   19/12/2014                  Initial Data Recovery code (to CSV only)
; PKR  1.0.4.17   05/01/2015        ~~        Added Newtonsoft.Json.dll required to get the status of the Portal
; PKR  1.0.4.18   09/01/2015  ABSEXCH-16003, 15997, 15995, 15978, 15976, 15971, 15959, 15954, 15871
; PKR  1.0.4.19   15/01/2015        ~~        CheckTokenStatus in Portal is now tri-state.
; PKR  1.0.5.20   29/01/2015        ~~        CheckTokenStatus in Portal is now 8-state. Auth Only working.
; PKR  1.0.5.21   30/01/2015        ~~        Build for new Gateway COM Object.
; PKR  1.0.5.22   30/01/2015        ~~        Build for new Gateway COM Object.
; PKR  1.0.5.23   03/02/2015  ABSEXCH-16112   
; PKR  1.0.5.24   12/02/2015  ABSEXCH-16121   Corrected Exchequer Installation directory for config location.
;                                             Restructured Add-in due to Portal changes (Login/Logout) and 
; PKR  1.0.5.25   12/02/2015  ABSEXCH-16169   Removed Interop.Enterprise04.dll, which was added by mistake
; PKR  1.0.5.26   17/02/2015        ~~        Reflects changes in the portal
; PKR  1.0.5.27   18/02/2015  ABSEXCH-16171, ABSEXCH-16173  Population of MCM company list, Payment Defaults correction. 
; PKR  1.0.5.28   19/02/2015  ABSEXCH-16192   Corrected Toolkit open/close.       
; PKR  1.0.5.29   19/02/2015  ABSEXCH-16097   Disaster Recovery create SRCs
;                             ABSEXCH-16104   Disaster Recovery recreate SOR headers
; PKR  1.0.5.30   24/02/2015        ~~        New Gateway COM Object
; PKR  1.0.5.31   27/02/2015  Seven JIRAs    
; PKR  1.0.5.32   04/03/2015  ABSEXCH-16213   Drop-down lists on config table (GL Codes, CC, Depts)
;                             ABSEXCH-16216   All or nothing validation on config table (GL Codes, CC, Depts)
;                             ABSEXCH-16223   Part payment recovery.
; PKR  1.0.5.33   09/03/2015  ABSEXCH-16213   Incorrect GL Codes listed in drop-down on config form
;                             ABSEXCH-16221   Data restore outside specified timeframe
;                             ABSEXCH-16247   Payments Defaults not being picked up correctly
;                             ABSEXCH-16254   Stock code going in wrong field
; PKR  1.0.5.34   18/03/2015  ABSEXCH-16202   Worldpay error when no Portal shopping basket
;                             ABSEXCH-16255   Part Payments not being restored correctly
;                             ABSEXCH-16256   Part Refundss not being restored correctly
;                             ABSEXCH-16262   Merchant IDs deleted at the portal not being deleted in config
; PKR. 1.0.6.35   27/03/2015  ABSEXCH-16121   Put the BespokeFuncs.dll in {sys}
;                             ABSEXCH-16171
;                             ABSEXCH-16262   Delete company from config after delete from Portal
; PKR. 1.0.6.36   27/03/2015  ABSEXCH-16256   Mismatched part refunds
;                             ABSEXCH-16262   Delete company from config after delete from Portal (revisited due to misunderstanding) 
;                             ABSEXCH-16304   Object Reference message when cancelling Authorise Only.  
; PKR. 1.0.6.37   10/04/2015  ABSEXCH-16104   Disaster recovery now encodes special characters in XML customData
;                             ABSEXCH-16329   Disaster Recovery Restore Complete indicater added
; PKR. 1.0.6.38   29/04/2015  ABSEXCH-16215   Toolkit no longer stays in memory
;                             ABSEXCH-16303   Correct error message from Portal displayed after unwinding embedded Exceptions
; PKR. 1.0.6.39   07/05/2015        ~         Rebuild with signed assemblies
; PKR. 1.0.6.40   26/05/2015        ~         Rebuild with UNsigned assemblies
; PKR. 1.0.7.41   27/05/2015  ABSEXCH-16453   Rebuild with Portal assemblies signed at build-time
; PKR  1.0.7.42   27/07/2015        ~         Intermediate fix 
; PKR  1.0.7.43   29/07/2015  ABSEXCH-16683   Card Authentication and Payment Authorisation.
; PKR  1.0.7.44   29/07/2015  ABSEXCH-16703   Refunds stopped working.
; PKR  1.0.7.45   30/07/2015  ABSEXCH-16655   Data Recovery stopped working (due to toolkit changes).
; PKR  1.0.7.46   31/07/2015  ABSEXCH-16655   End date on Data Recovery fix.
; CJS  1.0.7.047  05/08/2015        ~         Merged changes into main 2015 R1 branch
; CJS  1.0.7.48   10/08/2015  ABSEXCH-16466   Retry-on-logout implemention
; CJS  1.0,7.49   10/08/2015        ?         ?
; PKR  1.0.7.50   19/08/2015        ~         New COM Client (0.5.0.2) for Chamberlain multi-site redirect
; PKR  1.0.7.51   21/08/2015  ABSEXCH-16655   Data Restore fixes
; PKR  1.0.8.52   28/08/2015  ABSEXCH-16426   Registration of assemblies produced warnings
;                             ABSEXCH-16762   Error in config for companies with fewer than 6 characters in code
;                             ABSEXCH-16787   Toolkit stays in memory
; PKR  1.0.8.53   03/09/2015        ~         New COM Client (0.5.0.5) for error redirect to URL
; PKR  1.0.9.54   00/09/2015  ABSEXCH-16830   Check for .NET 4.5.1 or higher.
;                             ABSEXCH-16344   Part refunds not recreated correctly
;                             ABSEXCH-16785   Data restore not working for Location in lines.
; PKR  1.0.9.55   23/09/2015  ABSEXCH-16344   Part refunds not being restored correctly
;                             ABSEXCH-16655   Data restore not working - invalid account code
;                             ABSEXCH-16846   Data Restore not working for Authenticated Payments and refunds
; PKR  1.0.9.56   28/09/2015  ABSEXCH-16655   Data Restore not working when Recreate Orders disabled.
; PKR  1.0.9.57   01/10/2015  ABSEXCH-16655   Data Restore not working when Recreate Orders disabled.
; PKR  1.0.9.58   02/10/2015  ABSEXCH-16655   Data Restore not working when Recreate Orders disabled.
; PKR  1.0.9.59   02/10/2015  ABSEXCH-16655   Data Restore not working - Refunds cause Object Reference exception.
; PKR  1.0.9.60   02/10/2015  ABSEXCH-16655   Data Restore not working - Refunds
; PKR  1.0.9.61   16/10/2015        ~         Rebuild for new COM Client
; PKR  1.0.9.62   18/05/2016        ~         Rebuild for new COM Client (0.6.0.0)
; SS   1.0.9.63   05/10/2016  ABSEXCH-16786   Change App Version No to make in sync with Exchequer.
;------------------------------------------------------------------------------

; SELECT FOR REQUIRED BUILD...
;#define DEBUG
#define RELEASE

; Define some constants to make it easier to change attributes later.
#define MyAppName "Exchequer Credit Card Add-in"
; The Add-in version
#define MyAppVersion "9.2.37.53"
; The Installer version
#define CCSETUPVersion "1.0.9.63"
#define MyAppPublisher "Advanced"
#define MyAppURL "http://www.exchequer.com/"

; If the minimum .NET requirement changes, update these.
#define DotNetBase "4.6"
#define DotNetFull "4.6.1"

; The image that appears on the left of the installer wizard front page
; Should be 164 x 314 pixels.
#define BIWizardImage       "WizModernImage-IS.bmp"
; The image that appears top-right on all the other wizard pages.
; Should be 55 x 55 pixels.
#define BISmallWizardImage  "Exch55.bmp"

[Setup]
; For convenience, Inno Setup uses constants representing common folders.
; {app} = the Application destination directory
; {pf}  = Program Files (or Program Files (x86) where appropriate)
; {sys} = System Folder (Eg \Windows\System32\)
; See Inno Setup help for more constants
;
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the Inno Setup IDE)
AppId={{5AACD5E6-4BB2-437A-A60C-3D02787D7E97}
; NOTE: The double opening brace is deliberate - it prevents the compiler from interpreting it as a system constant.

; PKR. Uncomment this line for the release version
; Uninstallable=no

AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}

; At runtime, this gets overwritten with the current Exchequer root directory.
DefaultDirName="C:\Exchequer\"
; When browsing for a location, don't append the DefaultDirName to the chosen folder
AppendDefaultDirName=no
; This can be set to "auto" (default), "yes" or "no".
DirExistsWarning=no

;DefaultGroupName={#MyAppName}
DefaultGroupName=""

DisableProgramGroupPage=yes

VersionInfoProductVersion={#MyAppVersion}
VersionInfoVersion={#CCSETUPVersion}

; This points to the Installer folder.  All other folders are relative to this.
SourceDir="."    

#ifdef RELEASE
OutputDir=output\release
#else
OutputDir=output\debug
#endif

OutputBaseFilename=CC-Addin-setup
SetupIconFile=plugin-icon.ico
DisableDirPage=yes
AlwaysShowDirOnReadyPage=yes
              
Compression=lzma
SolidCompression=yes

; No uninstaller so we don't have to worry about removing the licence info
;Uninstallable=no
UninstallDisplayName={#MyAppName}

UsePreviousAppDir=no
WizardImageFile={#BIWizardImage}
WizardSmallImageFile={#BISmallWizardImage}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
; The files to install.  In this case, there is no .exe file.
; Files are stored locally to the app, and not aded to the GAC.

; To make the credit card add-in accessible to 3rd-party apps, it must be registered with /codebase or
; installed in the GAC.

Source: "..\..\Assemblies\Exchequer.Payments.Portal.COM.Client.dll"; DestDir: "{app}"; Flags: ignoreversion;
#ifdef DEBUG
Source: "..\..\Assemblies\Exchequer.Payments.Portal.COM.Client.dll.config.TEST"; DestDir: "{app}"; Flags: ignoreversion; AfterInstall : RenameConfig;
#else
Source: "..\..\Assemblies\Exchequer.Payments.Portal.COM.Client.dll.config"; DestDir: "{app}"; Flags: ignoreversion;
#endif

Source: "..\..\Assemblies\Exchequer.Payments.Services.Security.dll"; DestDir: "{app}"; Flags: ignoreversion;
; PKR. 02/01/2015. Added to enable us to get the status of the Portal.
Source: "..\..\Assemblies\Newtonsoft.Json.dll"; DestDir: "{app}"; Flags: ignoreversion;

; Support DLLs for toolkit etc.
Source: "..\..\Assemblies\Interop.EnterpriseBeta.dll"; DestDir: "{app}"; Flags: sharedfile uninsnosharedfileprompt;
Source: "..\..\Assemblies\Interop.Enterprise04.dll"; DestDir: "{app}"; Flags: sharedfile uninsnosharedfileprompt;
Source: "..\..\Assemblies\BespokeFuncs.dll"; DestDir: "{app}";

; AfterInstall runs the specified function after the installation process is complete.
; NB. ignoreversion means overwrite regardless of version.
#ifdef RELEASE
  Source: "..\bin\x86\Release\ExchequerPaymentGateway.dll"; DestDir: "{app}"; AfterInstall: CCPostInstall; Flags: ignoreversion;
#else
  Source: "..\bin\x86\Debug\ExchequerPaymentGateway.dll"; DestDir: "{app}"; AfterInstall: CCPostInstall; Flags: ignoreversion;
#endif

; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Run]
; PKR. 21/11/2014  ABSEXCH-15842   Changed method of registration of DLLs.
; After installation, register the .NET assemblies that can be registered.
;
; Note: /codebase only works if the assembly is Strongly Named.
; All other assemblies referenced by the registered assembly must also be strongly named.
; NOTE: Prefix the DLL filename with {app} to force it to be the one we've just installed rather than one that 
; might have been installed previously elsewhere.  Specifying the workingDir as {app} isn't enough.

; PKR. 26/08/2015. ABSEXCH-16426. Registration of Credit Card/Payments Portal assemblies produces a warning message.
; No types to register in the Security DLL
;Filename: "{dotnet40}\RegAsm.exe"; Parameters: "{app}\Exchequer.Payments.Services.Security.dll /codebase"; WorkingDir: {app}; StatusMsg: "Registering libraries..."; Flags: runminimized;
Filename: "{dotnet40}\RegAsm.exe"; Parameters: "{app}\Exchequer.Payments.Portal.COM.Client.dll /codebase"; WorkingDir: {app}; StatusMsg: "Registering libraries..."; Flags: runminimized;
Filename: "{dotnet40}\RegAsm.exe"; Parameters: "{app}\ExchequerPaymentGateway.dll /codebase"; WorkingDir: {app}; StatusMsg: "Registering libraries..."; Flags: runminimized;


[UninstallRun]
; PKR. 21/11/2014  ABSEXCH-15842   Added unregistration of DLLs.
; Before uninstallation, unregister the .NET assemblies that have been registered.
; These are stored locally and not in the GAC, which means that they are exclusive to the Credit Card Add-in.
;  Therefore it should be safe to unregister them.
; NOTE: Prefix the DLL filename with {app} to force it to be the one we've just installed rather than one that 
; might have been installed previously elsewhere.  Specifying the workingDir as {app} isn't enough.
Filename: "{dotnet40}\RegAsm.exe"; Parameters: "{app}\ExchequerPaymentGateway.dll /unregister"; WorkingDir: {app}; Flags: runminimized;
Filename: "{dotnet40}\RegAsm.exe"; Parameters: "{app}\Exchequer.Payments.Portal.COM.Client.dll /unregister"; WorkingDir: {app}; Flags: runminimized;
; PKR. 26/08/2015. ABSEXCH-16426. Registration of Credit Card/Payments Portal assemblies produces a warning message.
; No types to register in the Security DLL
;Filename: "{dotnet40}\RegAsm.exe"; Parameters: "{app}\Exchequer.Payments.Services.Security.dll /unregister"; WorkingDir: {app}; Flags: runminimized;


[Code]
var
  // PKR. 08/09/2015. ABSEXCH-16830.  Installer doesn't check for .NET 4.5.1 or higher
  PreReqPage : TOutputMsgWizardPage;   // Displays a message about checking for prerequisites
  CancelWithoutPrompt : boolean;  // Allows the Installer to close without confirmation
  ComputerName : string;


// Helper function to provide a quick-and-easy ShowMessage dialog similar to the one in Delphi.
procedure ShowMessage(theMessage : string);
begin
  MsgBox(theMessage, mbInformation, mb_Ok);
end;

//-----------------------------------------------------------------------------
  // PKR. 08/09/2015. ABSEXCH-16830.  Installer doesn't check for .NET 4.5.1 or higher
procedure CancelButtonClick(CurPageID: Integer; var Cancel, Confirm: Boolean);
begin
  if CurPageID <> wpInstalling then
    Confirm := not CancelWithoutPrompt;
end;

//-----------------------------------------------------------------------------
  // PKR. 08/09/2015. ABSEXCH-16830.  Installer doesn't check for .NET 4.5.1 or higher
function Create_PrereqPage(predecessor : integer) : integer;
begin
  PreReqPage := CreateOutputMsgPage(predecessor,
    'Pre-install Checks', 'Checking for Pre-requisites.', 
    'The Credit Card Add-in requires .NET {#DotNetFull} or higher.'#13#10#13#10 + 
    '.NET {#DotNetFull} or higher found.  Installation may proceed.');
  result := PreReqPage.ID;
end;    

//-----------------------------------------------------------------------------
  // PKR. 08/09/2015. ABSEXCH-16830.  Installer doesn't check for .NET 4.5.1 or higher
procedure CreateCustomWizardPages;
var
  LastId : integer;
begin
  LastId := wpWelcome;
  LastId := Create_PrereqPage(LastId);
end;

//-----------------------------------------------------------------------------
// PKR. 08/09/2015. ABSEXCH-16830.  Installer doesn't check for .NET 4.5.1 or higher
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
//    394254  .NET Framework 4.6.1 on Windows 10
//    394271  .NET Framework 4.6.1 on other Windows versions
//    394747  .NET Framework 4.6.2 Preview on Windows 10
//    394748  .NET Framework 4.6.2 Preview on other Windows versions
// Note that for 4.5.1 and 4.6, either determine the OS version first, or make 2 calls.
var
  key: string;
  install, release, serviceCount: cardinal;
  check45, success: boolean;
begin
  // .NET 4.5 and higher installs as update to .NET 4.0 Full
  if (version = 'v4.5') or (version = 'v4.6') then 
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
    serviceCount := servicePack; // Not used in .NET 3, so ensure the test works.
    success := RegQueryDWordValue(HKLM, key + '\Setup', 'InstallSuccess', install);
  end 
  else 
  begin
    // Not v3.0
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
    success := success and (release >= aRelease);
  end;

  result := success and (install = 1) and (serviceCount >= servicePack);
end;

//-----------------------------------------------------------------------------
// NOTE: This cannot be undone, so the uninstaller will not remove the licence.
procedure InstallPluginLicence;
// Code adapted from \ENTRPRSE\CUSTOM\EntSecur\DelphiDemo\main.pas
var
  FThirdParty : Variant;
  rc          : integer;
begin
  try
    // Create a security COM object
    FThirdParty := CreateOLEObject('EnterpriseSecurity.ThirdParty');

    FThirdParty.tpSystemIdCode := 'EXCHCREDIT000286';
    FThirdParty.tpSecurityCode := 'Wt3.14159woTbb2s';
    FThirdParty.tpDescription  := 'Credit Card Add-In';
    FThirdParty.tpSecurityType := 0; // System Only
    FThirdParty.tpMessage      := '';

    rc := FThirdParty.ReadSecurity;

    if rc <> 0 then
    begin
      ShowMessage('Failed to register Credit Card Add-in licence');
    end;
  except
    ShowMessage('Failed to create Plug-in Licence handler.'#13#13'(Error ''' + GetExceptionMessage + ''' occurred)');
  end;
end;


//-----------------------------------------------------------------------------
// This runs before the wizard is created.
procedure InitializeWizard;
begin
  // PKR. 08/09/2015. ABSEXCH-16830.  Installer doesn't check for .NET 4.5.1 or higher
  CreateCustomWizardPages;
  CancelWithoutPrompt := false;
  ComputerName := GetComputerNameString;
end;

//-----------------------------------------------------------------------------
// Runs after the last file has been installed
procedure CCPostInstall;
begin
  InstallPluginLicence;
end;


//-----------------------------------------------------------------------------
// Returns the registered OLE Server path from the Registry
Function GetOLEServerPath(Var OLEServerPath : String) : Boolean;
// Code adapted from Function GetOLEServerPath
//  in Entrprse\FUNCS\VAOUtil.pas
var
  OLEServerGUID : String;
begin
  Result := false;
  OLEServerPath := '';

  // See if the OLE Server has been registered.
  if (RegKeyExists(HKEY_CLASSES_ROOT, 'Enterprise.OLEServer\Clsid')) then
  begin
    // Get the GUID for the OLEServer
    if RegQueryStringValue(HKEY_CLASSES_ROOT, 'Enterprise.OLEServer\Clsid', '', OLEServerGUID) then
    begin
      // Now get the path where the OLE Server resides
      if RegQueryStringValue(HKEY_CLASSES_ROOT, 'Clsid\'+OLEServerGUID+'\LocalServer32', '', OLEServerPath) then
      begin
        // Success, so return the path.
        OLEServerPath := ExtractFilePath(OLEServerPath);
        Result := true;
      end
      else
      begin
        // Didn't find it, so we've probably got a WOW6432Node issue going on.
        // We shouldn't have to do this - it should be automatic - but experience says otherwise.
        if RegQueryStringValue(HKEY_CLASSES_ROOT, 'WOW6432Node\Clsid\'+OLEServerGUID+'\LocalServer32', '', OLEServerPath) then
        begin
          // Success, so return the path.
          OLEServerPath := ExtractFilePath(OLEServerPath);
          Result := true;
        end;
      end;
    end;
  end;
end;


//-----------------------------------------------------------------------------
procedure CurPageChanged(CurPageID: Integer);
var
  ExchequerPath : string;
  DotNetRelease : integer;
begin
  // Is this the Select Destination Directory page?
  if CurPageID = wpWelcome then // wpSelectDir then
  begin
    // Determine the Exchequer install directory by looking for the registered
    //  OLE Server in the Registry.
    // If we don't find one, then the default directory remains unchanged.
    if GetOLEServerPath(ExchequerPath) then
    begin
      // Put the directory in as the default location
      WizardForm.DirEdit.Text := ExchequerPath; //  + 'Plugins\CreditCard';
    end;
  end;

  // PKR. 08/09/2015. ABSEXCH-16830.  Installer doesn't check for .NET 4.5.1 or higher
  // Modified to allow easy change by setting the constats at the top of this file.
  if (CurPageId = PreReqPage.ID) then
  begin
    // Check for .NET
    if '{#DotNetFull}' = '4.5'   then DotNetRelease := 378389;
    if '{#DotNetFull}' = '4.5.1' then DotNetRelease := 378675; // 378758 on some versions, but we test for >=
    if '{#DotNetFull}' = '4.5.2' then DotNetRelease := 379893;
    if '{#DotNetFull}' = '4.6'   then DotNetRelease := 393295; // 393297 on some versions
    if '{#DotNetFull}' = '4.6.1' then DotNetRelease := 394254; // 394271 on some versions, but we test for >=
    if '{#DotNetFull}' = '4.6.2' then DotNetRelease := 394747; // (PREVIEW of 4.6.2) 394748 on some versions
    // Add more Version/Release values here as they are issued by Microsoft.
    // The above codes were found at https://msdn.microsoft.com/en-us/library/hh925568(v=vs.110).aspx
    //  but this URL could change.

    // The Azure team built the EPP COM Client with .NET 4.6.1, so everything else had to be upgraded.
    if (not IsDotNetDetected('v{#DotNetBase}', 0, DotNetRelease)) then
    begin
      MsgBox('Credit Card Add-In requires Microsoft .NET Framework {#DotNetFull} or higher.'#13#13
             'Please use Windows Update to install a compatible version,'#13
             'and then re-run this setup program.', mbInformation, MB_OK);

      CancelWithoutPrompt := true; 
      WizardForm.Close;
    end;
  end;
end;

//-----------------------------------------------------------------------------
procedure RenameConfig;
begin
  if (fileExists(ExpandConstant('{app}\Exchequer.Payments.Portal.COM.Client.dll.config'))) then
  begin
    if (not fileExists(ExpandConstant('{app}\Exchequer.Payments.Portal.COM.Client.dll.config.LIVE'))) then
      RenameFile(ExpandConstant('{app}\Exchequer.Payments.Portal.COM.Client.dll.config'), ExpandConstant('{app}\Exchequer.Payments.Portal.COM.Client.dll.config.LIVE'))
    else
      DeleteFile('{app}\Exchequer.Payments.Portal.COM.Client.dll.config.LIVE');
  end;
  RenameFile(ExpandConstant('{app}\Exchequer.Payments.Portal.COM.Client.dll.config.TEST'), ExpandConstant('{app}\Exchequer.Payments.Portal.COM.Client.dll.config'));
end;

//-----------------------------------------------------------------------------
