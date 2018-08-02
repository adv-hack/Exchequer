unit VAOUtil;

interface

Type
  TSystemMode = (smNormal, smVAO, smLocalProgramFiles);

  //------------------------------

  IVAOInformation = Interface
    ['{4B3E5EB1-4EE9-4C95-B2BE-9EC956F7956F}']

    // Internal Methods to implement Public Properties
    Function Get_AppsDir : ShortString;
    Function Get_CompanyDir : ShortString;
    Function Get_HideBitmaps : Boolean;
    Function Get_Mode : TSystemMode;

    // Public Properties
    Property vaoAppsDir : ShortString Read Get_AppsDir;
    Property vaoCompanyDir : ShortString Read Get_CompanyDir;
    Property vaoHideBitmaps : Boolean Read Get_HideBitmaps;
    Property vaoMode : TSystemMode Read Get_Mode;

    // Public Methods

    // Returns True if the path from Application.Exename matches the path in
    // HKEY_CURRENT_USER. Only check for .EXE's running from the Exchequer
    // directory.  Always returns True if not running in smVAO Mode.
    Function IsCorrectDir : Boolean;

    // Returns a string description of vaoMode
    Function ModeToStr (Mode : TSystemMode) : ShortString;

    // Returns TRUE if the DirPath is a valid Exchequer Local Program Files directory
    Function ValidEnterpriseLPFDir (DirPath : ShortString) : Boolean;

    // Returns TRUE if the DirPath is a valid Exchequer Dataset directory
    Function ValidEnterpriseDatasetDir (DirPath : ShortString) : Boolean;

    // Returns TRUE if the DirPath is a valid Exchequer main directory
    Function ValidEnterpriseMainDir (DirPath : ShortString) : Boolean;

    function Get_UseSubCompany : Boolean;
    function Get_SubCompanyDir : String;
    procedure Set_UseSubCompany(const aUseSubCompany : Boolean);
    procedure Set_SubCompanyDir(const aSubCompanyDir : String);

    property UseSubCompany : Boolean read  Get_UseSubCompany write Set_UseSubCompany;
    property vaoSubCompanyDir : String Read Get_SubCompanyDir write Set_SubCompanyDir;
  End; // IVAOInformation


// Public method - used from other modules to access an instance of the VAO
// Information class which is auto-created on first use
Function VAOInfo : IVAOInformation;

// Public method - used from other modules to reset the VAOInfo object to
// pickup registry changes
Procedure ResetVAOInfo;

// Checks whether the supplied path contains a valid Exchequer company.
function ValidCompany(FilePath: string): Boolean;

// Checks whether the supplied path contains a valid Exchequer system.
function ValidSystem(ForPath: string): Boolean;

implementation

Uses Dialogs, Forms, IniFiles, Registry, SysUtils,
  Windows;

Type
  // Class implements the IVAOInformation interface
  TVAOInformation = Class (TInterfacedObject, IVAOInformation)
  Private
    FAppsDir : ShortString;
    FCompanyDir : ShortString;
    FHideBitmaps : Boolean;
    FMode : TSystemMode;

    FUseSubComp : Boolean;
    FSubCompanyDir : String;

    // Returns the Network directory path from EntWRepl.Ini if set
    Function GetLocalProgramsPath (Var LPFPath : ShortString) : Boolean;

    // Uses GetModuleFileName to get the .EXE/.DLL path for the Applications Directory
    Function GetModulePath : ShortString;

    // Returns the registered OLE Server path from the Registry
    Function GetOLEServerPath (Var OLEServerPath : ShortString) : Boolean;

    // Returns the VAO Registry path from HKEY_CURRENT_USER
    Function GetVAORegistryPath (Var VAORegPath : ShortString) : Boolean;
  Protected
    Function Get_AppsDir : ShortString;
    Function Get_CompanyDir : ShortString;
    Function Get_HideBitmaps : Boolean;
    Function Get_Mode : TSystemMode;

    Function ModeToStr (Mode : TSystemMode) : ShortString;

    // Returns True if the path from Application.Exename matches the path in
    // HKEY_CURRENT_USER. Only check for .EXE's running from the Enterprise
    // directory.  Always returns True if not running in smVAO Mode.
    Function IsCorrectDir : Boolean;

    function Get_UseSubCompany : Boolean;
    function Get_SubCompanyDir : String;
    procedure Set_UseSubCompany(const aUseSubCompany : Boolean);
    procedure Set_SubCompanyDir(const aSubCompanyDir : String);
    
  Public
    Constructor Create;

    // Returns TRUE if the DirPath is a valid Exchequer Local Program Files directory
    Function ValidEnterpriseLPFDir (DirPath : ShortString) : Boolean;

    // Returns TRUE if the DirPath is a valid Exchequer Dataset directory
    Function ValidEnterpriseDatasetDir (DirPath : ShortString) : Boolean;

    // Returns TRUE if the DirPath is a valid Exchequer main directory
    Function ValidEnterpriseMainDir (DirPath : ShortString) : Boolean;
  End; // TVAOInformation

Var
  // Variable stores a reference to the Singleton interface which is returned
  // by the public method.
  iVAOInfo : IVAOInformation;

//=========================================================================

Function VAOInfo : IVAOInformation;
Begin // VAOInfo
  // Check whether the singleton has already been created, if not then create it
  If (Not Assigned(iVAOInfo)) Then
    iVAOInfo := TVAOInformation.Create;

  // return the reference to the singleton interface stored in the private local variable
  Result := iVAOInfo;
End; // VAOInfo

//------------------------------

// Public method - used from other modules to reset the VAOInfo object to
// pickup registry changes
Procedure ResetVAOInfo;
Begin // ResetVAOInfo
  iVAOInfo := NIL;
End; // ResetVAOInfo

//------------------------------

// Checks whether the supplied path contains a valid Exchequer company.
function ValidCompany(FilePath: string): Boolean;
var
  Path: string;
begin
  Result := False;
  if (Trim(FilePath) <> '') then
    Path := IncludeTrailingPathDelimiter(FilePath)
  else
    Path := FilePath;
  if (DirectoryExists(Path) and
    FileExists(Path + 'COMPANY.SYS')) then
      Result := True;
end;

// -----------------------------------------------------------------------------

// Checks whether the supplied path contains a valid Exchequer system.
function ValidSystem(ForPath: string): Boolean;
var
  Path: string;
begin
  Result := False;
  if (Trim(ForPath) <> '') then
    Path := IncludeTrailingPathDelimiter(ForPath)
  else
    Path := ForPath;
  if (DirectoryExists(Path + 'LIB') and
      FileExists(Path + 'ENTER1.EXE') and
      FileExists(Path + 'ENTRPRSE.DAT') and
      FileExists(Path + 'EXCHEQR.SYS')) then
    Result := True;
end;

//=========================================================================

// Exceptions
// ==========
//
//   TVAOInformation.Create
//
//     TVAOInformation (1) - The OLE Server on this workstation is incorrectly configured
//     TVAOInformation (2) - The VAO Directory information on this workstation is incorrectly configured
//     TVAOInformation (3) - The Local Program File information in the active system is incorrectly configured
//
//   GetModulePath:-
//
//     TVAOInformation (100) - Unable to extract module pathing information
//

Constructor TVAOInformation.Create;
Var
  PathOK : Boolean;
Begin // Create
  Inherited Create;

  FUseSubComp := False;
  FSubCompanyDir := EmptyStr;

  // Default to standard mode
  FMode := smNormal;

  // Check command-line parameters
  FHideBitmaps := FindCmdLineSwitch('NL:', ['-', '/'], True);

  // MH 03/07/07: Modified for setup to check for ExchequerInstallDir environment variable as
  // the SQL mods totally break the install as the registered path of the OLE Server is checked
  // everywhere data is accessed - which is a bit of a bugger when you are trying to install.
  // If present take ExchequerInstallDir as gospel
  FAppsDir := SysUtils.GetEnvironmentVariable('ExchequerInstallDir');
  If DirectoryExists(FAppsDir) And FileExists(FAppsDir + 'Entrprse.Dat') Then
  Begin
    { TODO : Finish - do we need to check for VAO and LPF?}
    FCompanyDir := FAppsDir;
  End // If DirectoryExists(FAppsDir) And FileExists(FAppsDir + 'Entrprse.Dat'))
  Else
  Begin
    // Use GetModuleFileName to get the .EXE/.DLL path for the Applications Directory
    FAppsDir := GetModulePath;

    // Check that it is a valid Exchequer or Exchequer Local Program Files directory
    If (Not ValidEnterpriseLPFDir(FAppsDir)) Then
    Begin
      // Invalid dir - Get path of the registered OLE Server from the Windows Registry
      PathOK := GetOLEServerPath(FAppsDir);
      If (Not PathOK) Or (Not ValidEnterpriseLPFDir (FAppsDir)) Then
      Begin
        // Error - not pathing information to work from
        Raise Exception.Create ('TVAOInformation (1) - The OLE Server on this workstation is incorrectly configured, please contact your Technical Support');
      End; // If (Not PathOK) Or (Not ValidEnterpriseLPFDir (OLEServerPath))
    End; // If Not ValidEnterpriseLPFDir(FAppsDir)

    FAppsDir := IncludeTrailingPathDelimiter(FAppsDir);

    // Valid Ent programs dir - check for VAO.INF to see if the VAO system is in use
    If FileExists (FAppsDir + 'VAO.INF') Then
    Begin
      // Got VAO flag file - extract VAO path from Windows Registry
      PathOK := GetVAORegistryPath(FCompanyDir);

      If PathOK And ValidEnterpriseMainDir(FCompanyDir) Then
      Begin
        // AOK
        FMode := smVAO;
      End // If PathOK And ValidEnterpriseMainDir(FCompanyDir)
      Else
        Raise Exception.Create ('TVAOInformation (2) - The IAOO Directory information on this workstation is incorrectly configured, please contact your Technical Support');
    End // If FileExists (FAppsDir + 'VAO.INF')
    Else
    Begin
      // Not VAO - Check for Local Program Files
      If FileExists (FAppsDir + 'ENTWREPL.INI') Then
      Begin
        // Get the path from EntWRepl.Ini
        PathOK := GetLocalProgramsPath(FCompanyDir);

        If PathOK And ValidEnterpriseMainDir(FCompanyDir) Then
        Begin
          // AOK
          FMode := smLocalProgramFiles;
        End // If PathOK And ValidEnterpriseMainDir(FCompanyDir)
        Else
        Begin
          // LPF path is invalid - check applications directory
          If ValidEnterpriseMainDir(FAppsDir) Then
            FCompanyDir := FAppsDir
          Else
            Raise Exception.Create ('TVAOInformation (3) - The Local Program File information in the active system is incorrectly configured, please contact your Technical Support');
        End; // If (Not PathOK) Or (Not ValidEnterpriseMainDir(FCompanyDir))
      End // If FileExists (FAppsDir + 'ENTWREPL.INI')
      Else
      Begin
        // Standard install
        FCompanyDir := FAppsDir;
      End; // Else
    End; // Else
  End; // Else
End; // Create

//-------------------------------------------------------------------------

Function TVAOInformation.Get_AppsDir : ShortString;
Begin // Get_AppsDir
  Result := FAppsDir;
End; // Get_AppsDir

//------------------------------

Function TVAOInformation.Get_CompanyDir : ShortString;
Begin // Get_CompanyDir
  if (FUseSubComp) and (FSubCompanyDir <> EmptyStr) then
    Result := FSubCompanyDir
  else
    Result := FCompanyDir;
End; // Get_CompanyDir

//------------------------------

Function TVAOInformation.Get_HideBitmaps : Boolean;
Begin // Get_HideBitmaps
  Result := FHideBitmaps;
End; // Get_HideBitmaps

//------------------------------

Function TVAOInformation.Get_Mode : TSystemMode;
Begin // Get_Mode
  Result := FMode;
End; // Get_Mode

//-------------------------------------------------------------------------

// Uses GetModuleFileName to get the .EXE/.DLL path for the Applications Directory
Function TVAOInformation.GetModulePath : ShortString;
Var
  Buffer   : PChar;
  Len      : SmallInt;
Begin // GetModulePath
  Buffer := StrAlloc (255);
  Try
    Len := GetModuleFileName(HInstance, Buffer, StrBufSize(Buffer));
    If (Len > 0) Then
      Result := ExtractFilePath(Buffer)
    Else
      Raise Exception.Create ('TVAOInformation (100) - Unable to extract module pathing information, please contact your Technical Support');
  Finally
    StrDispose(Buffer);
  End; // Try..Finally
End; // GetModulePath

//-------------------------------------------------------------------------

// Returns the registered OLE Server path from the Registry
Function TVAOInformation.GetOLEServerPath (Var OLEServerPath : ShortString) : Boolean;
Var
  TmpStr : ShortString;
Begin // GetOLEServerPath
  OLEServerPath := '';

  With TRegistry.Create Do
  Begin
    Try
      Access := KEY_READ;
      RootKey := HKEY_CLASSES_ROOT;

      // Open the OLE Server CLSID key to get the GUID to lookup in the
      // CLSID section - safer than hard-coding the GUID in the code
      If OpenKey('Enterprise.OLEServer\Clsid', False) Then
      Begin
        // Read CLSID stored in default entry }
        TmpStr := ReadString ('');
        CloseKey;

        // Got CLSID - find entry in CLSID Section and check for registered .EXE }
        If OpenKey('Clsid\'+TmpStr+'\LocalServer32', False) Then
        Begin
          // Get path of registered OLE Server .Exe
          TmpStr := ReadString ('');

          // Check the OLE Server actually exists and return the path if OK
          If FileExists (TmpStr) Then
          Begin
            OLEServerPath := ExtractFilePath(TmpStr);
          End; // If FileExists (TmpStr)

          CloseKey;
        End; // If OpenKey('Clsid\'+TmpStr+'\LocalServer32', False)
      End; // If OpenKey('Enterprise.OLEServer\Clsid', False)
    Finally
      Free;
    End; // Try..Finally
  End; // With TRegistry.Create

  // Check the path being returned is set
  Result := (Trim(OLEServerPath) <> '');
End; // GetOLEServerPath

//-------------------------------------------------------------------------

// Returns the VAO Registry path from HKEY_CURRENT_USER
Function TVAOInformation.GetVAORegistryPath (Var VAORegPath : ShortString) : Boolean;
Begin // GetVAORegistryPath
  VAORegPath := '';

  With TRegistry.Create Do
  Begin
    Try
      Access := Key_Read;
      RootKey := HKEY_CURRENT_USER;

      If OpenKey ('Software\Exchequer\Enterprise\', False) Then
        VAORegPath := ReadString('SystemDir');
    Finally
      Free;
    End; // Try..Finally
  End; // With TRegistry.Create

  // Check the path being returned is set
  Result := (Trim(VAORegPath) <> '');
End; // GetVAORegistryPath

//-------------------------------------------------------------------------

// Returns the Network directory path from EntWRepl.Ini if set
Function TVAOInformation.GetLocalProgramsPath (Var LPFPath : ShortString) : Boolean;
Begin // GetLocalProgramsPath
  With TIniFile.Create (FAppsDir + 'ENTWREPL.INI') Do
  Begin
    Try
      // MH 04/06/2015 v7.0.14 ABSEXCH-16490: Added UNC Path support to COM Toolkit / Forms Toolkit
      {$IF Defined(COMTK) Or Defined(FORMTK)}
        LPFPath := ReadString ('UpdateEngine', 'UNCNetworkDir', '');
        If (Trim(LPFPath) = '') Then
      {$IFEnd}
          LPFPath := ReadString ('UpdateEngine', 'NetworkDir', '');
    Finally
      Free;
    End; // Try..Finally
  End; // With TIniFile.Create (FAppsDir + 'ENTWREPL.INI')

  // Check the path being returned
  Result := (Trim(LPFPath) <> '');
  LPFPath := IncludeTrailingPathDelimiter(LPFPath);
End; // GetLocalProgramsPath

//-------------------------------------------------------------------------

Function TVAOInformation.ModeToStr (Mode : TSystemMode) : ShortString;
Begin // ModeToStr
  Case Mode Of
    smNormal            : Result := 'Normal';
    smVAO               : Result := 'VAO';
    smLocalProgramFiles : Result := 'Local Program Files';
  Else
    Raise Exception.Create ('TVAOInformation.ModeToStr - Unknown Mode(' + IntToStr(Ord(Mode)) + ')');
  End; // Case Mode
End; // ModeToStr

//-------------------------------------------------------------------------

// Returns TRUE if the DirPath is a valid Exchequer Local Program Files directory
Function TVAOInformation.ValidEnterpriseLPFDir (DirPath : ShortString) : Boolean;
Begin // ValidEnterpriseLPFDir
  DirPath := IncludeTrailingPathDelimiter(Trim(UpperCase(DirPath)));

  // Check the path is valid
  Result := (Trim(DirPath) <> '\') And DirectoryExists(DirPath);
  If Result Then
  Begin
    // Check for program files
    // MH 11/04/06: Removed EntToolk.Dll as we are moving from .DLL to .EXE
    Result := FileExists (DirPath + 'ENTER1.EXE') And FileExists (DirPath + 'SBSFORM.DLL') And
              FileExists (DirPath + 'ENTCOMP.DLL') And FileExists (DirPath + 'ENTTOOLK.DLL');
  End; // If Result
End; // ValidEnterpriseLPFDir

//-------------------------------------------------------------------------

// Returns TRUE if the DirPath is a valid Exchequer Dataset directory
Function TVAOInformation.ValidEnterpriseDatasetDir (DirPath : ShortString) : Boolean;
Begin // ValidEnterpriseDatasetDir
  DirPath := IncludeTrailingPathDelimiter(Trim(UpperCase(DirPath)));

{$IFDEF EXSQL}
  Result := ValidCompany(DirPath);
{$ELSE}
  // Check the path is valid
  Result := (Trim(DirPath) <> '\') And DirectoryExists(DirPath);
  If Result Then
  Begin
    // Check for data files
    Result := FileExists (DirPath + 'EXCHQSS.DAT') And FileExists (DirPath + 'EXCHQNUM.DAT') And

              FileExists (DirPath + 'CUST\CUSTSUPP.DAT') And

              FileExists (DirPath + 'JOBS\JOBCTRL.DAT') And FileExists (DirPath + 'JOBS\JOBHEAD.DAT') And
              FileExists (DirPath + 'JOBS\JOBDET.DAT') And FileExists (DirPath + 'JOBS\JOBMISC.DAT') And

              FileExists (DirPath + 'MISC\EXCHQCHK.DAT') And FileExists (DirPath + 'MISC\EXSTKCHK.DAT') And

              FileExists (DirPath + 'STOCK\MLOCSTK.DAT') And FileExists (DirPath + 'STOCK\STOCK.DAT') And

              FileExists (DirPath + 'TRANS\DETAILS.DAT') And FileExists (DirPath + 'TRANS\HISTORY.DAT') And
              FileExists (DirPath + 'TRANS\DOCUMENT.DAT') And FileExists (DirPath + 'TRANS\NOMINAL.DAT');
  End; // If Result
{$ENDIF}
End; // ValidEnterpriseDatasetDir

//-------------------------------------------------------------------------

// Returns TRUE if the DirPath is a valid Exchequer main directory
Function TVAOInformation.ValidEnterpriseMainDir (DirPath : ShortString) : Boolean;
Begin // ValidEnterpriseMainDir
  DirPath := IncludeTrailingPathDelimiter(Trim(UpperCase(DirPath)));
{$IFDEF EXSQL}
  Result := ValidSystem(DirPath);
{$ELSE}
  Result := ValidEnterpriseLPFDir(DirPath) And         // Program Files exist
            ValidEnterpriseDatasetDir (DirPath) And    // Dataset exists
            FileExists (DirPath + 'Company.Dat');
{$ENDIF}
End; // ValidEnterpriseMainDir

//-------------------------------------------------------------------------

// Returns True if the path from Application.Exename matches the path in
// HKEY_CURRENT_USER. Only check for .EXE's running from the Exchequer
// directory.  Always returns True if not running in smVAO Mode.
Function TVAOInformation.IsCorrectDir : Boolean;
Var
  VAORegPath : ShortString;
Begin // IsCorrectDir
  If (FMode = smVAO) Then
  Begin
    // NOTE: No need to check path is correctly setup as this happens in the
    // constructor and will raise an exception.
    GetVAORegistryPath (VAORegPath);
    //ShowMessage ('VAORegPath: ' + VAORegPath + #13 + 'ExePath: ' + ExtractFilePath(Application.ExeName));
    Result := (IncludeTrailingPathDelimiter(UpperCase(Trim(VAORegPath))) = IncludeTrailingPathDelimiter(UpperCase(Trim(ExtractFilePath(Application.ExeName)))));
  End // If (FMode = smVAO)
  Else
    // Not running VAO - don't care about directory
    Result := True;
End; // IsCorrectDir

//=========================================================================

function TVAOInformation.Get_SubCompanyDir: String;
begin  
  if (FUseSubComp) and (FSubCompanyDir <> EmptyStr) then
    Result := FSubCompanyDir
  else
    Result := FCompanyDir;
end;


function TVAOInformation.Get_UseSubCompany: Boolean;
begin
  Result := FUseSubComp;
end;

procedure TVAOInformation.Set_SubCompanyDir(const aSubCompanyDir: String);
begin
  FSubCompanyDir := aSubCompanyDir;
end;

procedure TVAOInformation.Set_UseSubCompany(const aUseSubCompany: Boolean);
begin
  FUseSubComp := aUseSubCompany;
end;


Initialization
  // Initialize private variable - don't trust Delphi to do it!
  iVAOInfo := NIL;
Finalization
  // Remove reference to singleton interface - triggers destruction if
  // not still in use elsewhere in the application
  iVAOInfo := NIL;
end.
