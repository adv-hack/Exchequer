unit FileVirtualisation;

interface

// Returns TRUE if we are running Vista and the specified Drive is a local hard disk, in
// this situation we should check for File Virtualisation
Function DoVirtualisationChecks (Drive : ANSIString) : Boolean;

// Windows Vista Virtualisation test, returns TRUE if the specified directory
// is present in the VirtualStore for the current user.  Intended for use when
// TestVirtualisation won't work, such as EntRegX which always runs as admin
Function IsVirtualisedDirectory (TestPath : ShortString) : Boolean;

// Windows Vista File Virtualisation test, returns TRUE if file virtualisation
// was detected, else FALSE
Function TestVirtualisation (TestPath : ShortString; Const IniFile : ShortString = 'VFVTest.Ini') : Boolean;

implementation

Uses Classes, Dialogs, IniFiles, SysUtils, Windows, ShFolder, APIUtil, DiskUtil;

//=========================================================================

// Returns the path in the File Virtualistation store for specified file
Function VirtualStorePath (Const Filename : ANSIString) : ANSIString;
Const
  SHGFP_TYPE_CURRENT = 0;
Var
  Path : Array[0..Max_Path] Of Char;
Begin // VirtualStorePath
  // Get Local Application Data path from the shell
  FillChar(Path, SizeOf(Path), #0);
  SHGetFolderPath(0, CSIDL_LOCAL_APPDATA, 0, SHGFP_TYPE_CURRENT, Path);
  Result := IncludeTrailingPathDelimiter(Path);

  // Append the path of the file as well
  Result := Result + 'VirtualStore\' + Copy(Filename, 4, Length(Filename));
End; // VirtualStorePath

//-------------------------------------------------------------------------

// Returns TRUE if we are running Vista and the specified Drive is a local hard disk, in
// this situation we should check for File Virtualisation
Function DoVirtualisationChecks (Drive : ANSIString) : Boolean;
Begin // DoVirtualisationChecks
  // MH 08/05/2013 v7.0.4 ABSEXCH-12022: Added support for Windows 7, Windows 8 and Windows Server 2012
  If (GetWindowsVersion >= wvVista) Then
    Result := (GetDriveType(PChar(Drive)) = DRIVE_FIXED)
  Else
    Result := False;
End; // DoVirtualisationChecks

//-------------------------------------------------------------------------

// Windows Vista Virtualisation test, returns TRUE if the specified directory
// is present in the VirtualStore for the current user
Function IsVirtualisedDirectory (TestPath : ShortString) : Boolean;
Begin // IsVirtualisedDirectory
  Result := False;

  // Step 1: Check for Windows Vista local hard disk
  If DoVirtualisationChecks(ExtractFileDrive(TestPath)) Then
  Begin
    // Step 2: Check whether the directory exists off the VirtualStore folder
    Result := DirectoryExists(VirtualStorePath(IncludeTrailingPathDelimiter(TestPath)));
ShowMessage ('UseName: ' + WinGetUserName);
ShowMessage ('IsVirtualisedDirectory (TestPath=' + TestPath + #13 + ', VirtualStore=' + VirtualStorePath(IncludeTrailingPathDelimiter(TestPath)) + ')');
  End; // If DoVirtualisationChecks(ExtractFileDrive(TestPath))
End; // IsVirtualisedDirectory

//-------------------------------------------------------------------------

// Windows Vista File Virtualisation test, returns TRUE if file virtualisation
// was detected, else FALSE
Function TestVirtualisation (TestPath : ShortString; Const IniFile : ShortString = 'VFVTest.Ini') : Boolean;
Var
  sFile : ANSIString;
Begin // TestVirtualisation
  Result := False;

  // Step 1: Check for Windows Vista local hard disk
  If DoVirtualisationChecks(ExtractFileDrive(TestPath)) Then
  Begin
    // Step 2: Check for the .INI file we are going to write to
    sFile := IncludeTrailingPathDelimiter(TestPath) + IniFile;
    If FileExists(sFile) Then
    Begin
      // Step 3: Write to FVTest.Ini which is installed with the system
      With TIniFile.Create(sFile) Do
      Begin
        Try
          WriteString('Users', WinGetUserName, FormatDateTime('hh:nn:ss.zzz dd-mm-yyyy', Now));
        Finally
          Free;
        End; // Try..Finally
      End; // With TIniFile.Create(sFile)

      // Step 4: Check whether it is in the File Virtualisation Directory, this could be because
      // of Step 3 or from a previous test - to disable file virtualisation
      Result := FileExists(VirtualStorePath(SFile));
    End // If FileExists(TestPath + 'FVTest.Ini')
    Else
      // Ini file missing - err on side of caution and raise error
      Result := True;
//ShowMessage ('Test File: ' + sFile + #13 + 'VirtualStore: ' + VirtualStorePath(SFile));
  End; // If DoVirtualisationChecks(ExtractFileDrive(TestPath))
End; // TestVirtualisation

end.
