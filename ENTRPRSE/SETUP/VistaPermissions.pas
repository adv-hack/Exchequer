unit VistaPermissions;

interface

Uses SysUtils, Windows, WiseAPI;

// Called from the setup to grant full control to all users to a specified directory
function SCD_SetVistaDirPermissions(var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

Uses APIUtil, Dialogs;

// Called from the setup to grant full control to all users to a specified directory
function SCD_SetVistaDirPermissions(var DLLParams: ParamRec): LongBool;
Var
  V_CheckDir : String;
  sDrive : ANSIString;
Begin // SCD_SetVistaDirPermissions
  Result := False;

  // Check for Vista
  // MH 08/05/2013 v7.0.4 ABSEXCH-12022: Added support for Windows 7, Windows 8 and Windows Server 2012
  If (GetWindowsVersion >= wvVista) Then
  Begin
    // Get path from setup and check for local hard drive
    GetVariable(DLLParams, 'V_CHECKDIR', V_CheckDir);
    sDrive := ExtractFileDrive(V_CheckDir);
    If (GetDriveType(PCHAR(sDrive)) = DRIVE_FIXED) Then
    Begin
      // Check directory exists - hard to set permissions on a directory that doesn't exist!
      If DirectoryExists(V_CheckDir) Then
      Begin
        // Set Permissions
//ShowMessage (IncludeTrailingPathDelimiter(WinGetWindowsSystemDir) + 'icacls.exe ' + V_CheckDir + ' /grant Everyone:f /T');
        RunApp(IncludeTrailingPathDelimiter(WinGetWindowsSystemDir) + 'icacls.exe ' + V_CheckDir + ' /grant Everyone:f /T', True);
      End; // If DirectoryExists(V_CheckDir)
    End; // If (GetDriveType(PCHAR(sDrive)) = DRIVE_FIXED)
  End; // If (GetWindowsVersion >= wvVista)
End; // SCD_SetVistaDirPermissions

end.
