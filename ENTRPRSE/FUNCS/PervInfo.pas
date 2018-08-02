unit PervInfo;

interface

Type
  TWorkgroupVersion = (wvNA, wv8, wv86, wv87, wv9, wv9SP2, wv10, wv11, wv12, wv13);

Const
  // These versions of the Workgroup Engine should be upgraded to a supported version
  UpdateWorkgroupVersions = [wvNA, wv8, wv86];

Type
  // Generic interface for objects which implement a specific import type
  IPervasiveInfo = Interface
    ['{1FB3A155-D650-4C4E-A62B-A0B2287CA703}']
    // --- Internal Methods to implement Public Properties ---
    Function GetBtrieveInstalled : Boolean;
    Function GetClientInstallDir : ShortString;
    Function GetClientInstalled : Boolean;
    Function GetClientVersion : Double;
    Function GetServerInstallDir : ShortString;
    Function GetServerInstalled : Boolean;
    Function GetServerVersion : Double;
    Function GetWorkgroupDirectory : ShortString;
    Function GetWorkgroupInstalled : Boolean;
    Function GetWorkgroupVersion : TWorkgroupVersion;

    // ------------------ Public Properties ------------------
    Property BtrieveInstalled : Boolean Read GetBtrieveInstalled;
    Property ClientInstallDir : ShortString Read GetClientInstallDir;
    Property ClientInstalled : Boolean Read GetClientInstalled;
    Property ClientVersion : Double Read GetClientVersion;
    Property ServerInstallDir : ShortString Read GetServerInstallDir;
    Property ServerInstalled : Boolean Read GetServerInstalled;
    Property ServerVersion : Double Read GetServerVersion;
    Property WorkgroupDirectory : ShortString Read GetWorkgroupDirectory;
    Property WorkgroupInstalled : Boolean Read GetWorkgroupInstalled;
    Property WorkgroupVersion : TWorkgroupVersion Read GetWorkgroupVersion;

    // ------------------- Public Methods --------------------

  End; // IPervasiveInfo

  //------------------------------

  // The Btrieve v6.15 Info object links into registry entries added by the
  // IRIS Accounts Office Btrieve v6.15 Pre-installer which is used to
  // insert Btrieve v6.15 into the IAO directory prior to installing or
  // upgrading IAO - Bodgetastic
  //
  //   [HKEY_CURRENT_USER\Software\IRIS\IRIS Accounts Office\Btrieve615]
  //   "PreInstalled"=dword:00000001
  //   "PreInstallDir"="C:\\IAOFFICE\\CRYSTAL\\"
  //
  IBtrieve615Info = Interface
    ['{146C259E-2B4F-4B0C-AF58-87F5C38734B4}']
    // --- Internal Methods to implement Public Properties ---
    Function GetGotBtr615BackDoor : Boolean;
    Function GetBtr615Directory : ShortString;

    // ------------------ Public Properties ------------------
    Property GotBtr615BackDoor : Boolean Read GetGotBtr615BackDoor;
    Property Btr615Directory : ShortString Read GetBtr615Directory;

    // ------------------- Public Methods --------------------
  End; // IBtrieve615Info


Function PervasiveInfo : IPervasiveInfo;
Function Btrieve615Info : IBtrieve615Info;

implementation

Uses Windows, Registry, SysUtils;

Type
  TPervasiveInfo = Class(TInterfacedObject, IPervasiveInfo)
  Private
    FBtrieveInstalled : Boolean;
    FClientInstalled : Boolean;
    FClientInstallDir : ShortString;
    FClientVersion : Double;
    FServerInstalled : Boolean;
    FServerInstallDir : ShortString;
    FServerVersion : Double;
    FWorkgroupDirectory : ShortString;
    FWorkgroupInstalled : Boolean;
    FWorkgroupVersion : TWorkgroupVersion;
  Protected
    Function GetBtrieveInstalled : Boolean;
    Function GetClientInstallDir : ShortString;
    Function GetClientInstalled : Boolean;
    Function GetClientVersion : Double;
    Function GetServerInstallDir : ShortString;
    Function GetServerInstalled : Boolean;
    Function GetServerVersion : Double;
    Function GetWorkgroupDirectory : ShortString;
    Function GetWorkgroupInstalled : Boolean;
    Function GetWorkgroupVersion : TWorkgroupVersion;
  Public
    Constructor Create;
  End; // TPervasiveInfo

  //------------------------------

  TBtrieve615Info = Class(TInterfacedObject, IBtrieve615Info)
  Private
    FGotBtr615BackDoor : Boolean;
    FBtr615Directory : ShortString;
  Protected
    Function GetGotBtr615BackDoor : Boolean;
    Function GetBtr615Directory : ShortString;
  Public
    Constructor Create;
  End; // TBtrieve615Info

//=========================================================================

Function PervasiveInfo : IPervasiveInfo;
Begin // PervasiveInfo
  Result := TPervasiveInfo.Create;
End; // PervasiveInfo

//=========================================================================

Constructor TPervasiveInfo.Create;
Const
  KEY_WOW64_64KEY        = $0100;
Var
  oReg : TRegistry;
  sVal : ShortString;

  Function GetVersion : Double;
  Var
    VerLevel : ShortString;
  Begin // GetVersion
    Result := 0.0;

    If oReg.ValueExists('VersionLevel') Then
    Begin
      VerLevel := oReg.ReadString('VersionLevel');
      Result := StrToFloatDef(VerLevel, 0.0);
    End; // If oReg.ValueExists('VersionLevel')
  End; // GetVersion

  //------------------------------

  // Bodge for 64-bit Pervasive support - in oreder to read the correct registry entries we need to know
  // whether to look at the 32-bit or 64-bit section of the registry in advance
  Function Got64BitPervasive : Boolean;
  Var
    oReg : TRegistry;
  Begin // Got64BitPervasive
    // MH 29/11/2016 2017-R1 ABSEXCH-17864: Rewrote registry check
    Result := False;

    oReg := TRegistry.Create;
    Try
      oReg.Access := KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS Or KEY_WOW64_64KEY;
      oReg.RootKey := HKEY_LOCAL_MACHINE;

//      Result := oReg.KeyExists('HKEY_LOCAL_MACHINE\SOFTWARE\Pervasive Software\Products\Pervasive.SQL Client') Or
//                oReg.KeyExists('HKEY_LOCAL_MACHINE\SOFTWARE\Pervasive Software\Products\Pervasive.SQL NT Server');

      // MH 29/11/2016 2017-R1 ABSEXCH-17864: Rewrote registry checks as KeyExists was failing on Windows 2016, a
      // process of experimentation showed that if the Parent Key was opened then it started working - no idea why
      // as it worked on prior versions on Windows since 2011
      If oReg.KeyExists('SOFTWARE\Pervasive Software\Products') Then
      Begin
        If oReg.OpenKey('SOFTWARE\Pervasive Software\Products', False) Then
        Begin
          Result := oReg.KeyExists('Pervasive.SQL Client') Or oReg.KeyExists('Pervasive.SQL NT Server');

          oReg.CloseKey;
        End; // If oReg.OpenKey('SOFTWARE\Pervasive Software\Products')
      End; // If oReg.KeyExists('SOFTWARE\Pervasive Software\Products')
    Finally
      oReg.Free;
    End; // Try..Finally
  End; // Got64BitPervasive

  //------------------------------

Begin // Create
  Inherited Create;

  FWorkgroupDirectory := '';
  FWorkgroupInstalled := False;
  FWorkgroupVersion := wvNA;
  FClientInstalled := False;
  FClientInstallDir := '';
  FClientVersion := 0.0;
  FServerInstalled := False;
  FServerInstallDir := '';
  FServerVersion := 0.0;
  FBtrieveInstalled := False;

  oReg := TRegistry.Create;
  Try
    // MH 14/09/2011 v6.8: 64-Bit - need to go to 64-bit key, otherwise we will get redirected to the WOW6432 section which doesn't contain the detail
    oReg.Access := KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS;
    If Got64BitPervasive Then
      oReg.Access := oReg.Access Or KEY_WOW64_64KEY;
    oReg.RootKey := HKEY_LOCAL_MACHINE;

    // Check for Btrieve - Any Type
    If oReg.OpenKey('SOFTWARE\Btrieve Technologies', False) Then
    Begin
      Try
        FBtrieveInstalled := True;
      Finally
        oReg.CloseKey;
      End; // Try..Finally
    End; // If oReg.OpenKey('SOFTWARE\Btrieve Technologies', False)

    // Check for Client-Server Requesters  -------------------
    If oReg.OpenKey('SOFTWARE\Pervasive Software\Products\Pervasive.SQL Client\InstallInfo', False) Then
    Begin
      Try
        FClientInstalled := True;
        FClientInstallDir := oReg.ReadString('InstallDir');
        FClientVersion := GetVersion;
      Finally
        oReg.CloseKey;
      End; // Try..Finally
    End; // If oReg.OpenKey('SOFTWARE\Pervasive Software\Products\Pervasive.SQL Client\InstallInfo', False)

    // Check for Client-Server Engine ------------------------
    If oReg.OpenKey('SOFTWARE\Pervasive Software\Products\Pervasive.SQL NT Server\InstallInfo', False) Then
    Begin
      Try
        FServerInstalled := True;
        FServerInstallDir := oReg.ReadString('InstallDir');
        FServerVersion := GetVersion;
      Finally
        oReg.CloseKey;
      End; // Try..Finally
    End // If oReg.OpenKey('SOFTWARE\Pervasive Software\Products\Pervasive.SQL Client\InstallInfo', False)
    Else If oReg.OpenKey('SOFTWARE\Pervasive Software\Products\Pervasive.SQL 2000 NT Server\InstallInfo', False) Then
    Begin
      Try
        FServerInstalled := True;
        FServerInstallDir := oReg.ReadString('InstallDir');
        FServerVersion := GetVersion;
      Finally
        oReg.CloseKey;
      End; // Try..Finally
    End; // If oReg.OpenKey('SOFTWARE\Pervasive Software\Products\Pervasive.SQL 2000 NT Server\InstallInfo', False)

    // Check for Workgroup Engine ----------------------------
    If oReg.OpenKey('SOFTWARE\Pervasive Software\Products\Pervasive.SQL Workgroup\InstallInfo', False) Then
    Begin
      Try
        // Workgroup Version
        sVal := oReg.ReadString('VersionLevel');
        If (sVal = '8.10') Then
          FWorkgroupVersion := wv8
        Else If (sVal = '8.60') Then
          FWorkgroupVersion := wv86
        Else If (sVal = '8.70') Then
          FWorkgroupVersion := wv87
        Else If (sVal = '9.00') Then
          FWorkgroupVersion := wv9
        Else If (sVal = '9.50') Then
          FWorkgroupVersion := wv9SP2
        //Else If (sVal = '10.0') Then
        Else If (Copy(sVal,1,3) = '10.') Then
          FWorkgroupVersion := wv10
        // MH 14/09/2011: Added support for Pervasive.SQL v11
        Else If (Copy(sVal,1,3) = '11.') Then
          FWorkgroupVersion := wv11
        // MH 02/03/2015 v7.0.13 ABSEXCH-16232: Added support for Pervasive 12
        Else If (Copy(sVal,1,3) = '12.') Then
          FWorkgroupVersion := wv12
        // MH 06/07/2017 2017-R1 ABSEXCH-18952: Added support for Pervasive 13 aka Actian Zen
        Else If (Copy(sVal,1,3) = '13.') Then
          FWorkgroupVersion := wv13;
        FWorkgroupInstalled := (FWorkgroupVersion <> wvNA);

        // Workgroup Dirirectory
        sVal := IncludeTrailingPathDelimiter(oReg.ReadString('InstallDir')) + 'BIN';
        If DirectoryExists(sVal) Then
          FWorkgroupDirectory := sVal;
      Finally
        oReg.CloseKey;
      End; // Try..Finally
    End; // If oReg.OpenKey('SOFTWARE\Pervasive Software\Products\Pervasive.SQL Workgroup\InstallInfo', False)
  Finally
    oReg.Free;
  End; // Try..Finally
End; // Create

//-------------------------------------------------------------------------

Function TPervasiveInfo.GetBtrieveInstalled : Boolean;
Begin // GetBtrieveInstalled
  Result := FBtrieveInstalled;
End; // GetBtrieveInstalled

//------------------------------

Function TPervasiveInfo.GetClientInstallDir : ShortString;
Begin // GetClientInstallDir
  Result := FClientInstallDir;
End; // GetClientInstallDir

//------------------------------

Function TPervasiveInfo.GetClientInstalled : Boolean;
Begin // GetClientInstalled
  Result := FClientInstalled;
End; // GetClientInstalled

//------------------------------

Function TPervasiveInfo.GetClientVersion : Double;
Begin // GetClientVersion
  Result := FClientVersion;
End; // GetClientVersion

//------------------------------

Function TPervasiveInfo.GetServerInstallDir : ShortString;
Begin // GetServerInstallDir
  Result := FServerInstallDir;
End; // GetServerInstallDir

//------------------------------

Function TPervasiveInfo.GetServerInstalled : Boolean;
Begin // GetServerInstalled
  Result := FServerInstalled;
End; // GetServerInstalled

//------------------------------

Function TPervasiveInfo.GetServerVersion : Double;
Begin // GetServerVersion
  Result := FServerVersion;
End; // GetServerVersion

//------------------------------

Function TPervasiveInfo.GetWorkgroupDirectory : ShortString;
Begin // GetWorkgroupDirectory
  Result := FWorkgroupDirectory;
End; // GetWorkgroupDirectory

//------------------------------

Function TPervasiveInfo.GetWorkgroupInstalled : Boolean;
Begin // GetWorkgroupInstalled
  Result := FWorkgroupInstalled;
End; // GetWorkgroupInstalled

//------------------------------

Function TPervasiveInfo.GetWorkgroupVersion : TWorkgroupVersion;
Begin // GetWorkgroupVersion
  Result := FWorkgroupVersion;
End; // GetWorkgroupVersion

//=========================================================================

Function Btrieve615Info : IBtrieve615Info;
Begin // Btrieve615Info
  Result := TBtrieve615Info.Create;
End; // Btrieve615Info

//=========================================================================

Constructor TBtrieve615Info.Create;
Var
  oReg : TRegistry;
Begin // Create
  Inherited Create;

  FGotBtr615BackDoor := False;
  FBtr615Directory := '';

  oReg := TRegistry.Create;
  Try
    oReg.Access := KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS;
    oReg.RootKey := HKEY_CURRENT_USER;

    // The Btrieve v6.15 Backdoor links into registry entries added by the IRIS Accounts Office
    // Btrieve v6.15 Pre-installer which is used to insert Btrieve v6.15 into the IAO directory
    // prior to installing or upgrading IAO.
    //
    //   [HKEY_CURRENT_USER\Software\IRIS\IRIS Accounts Office\Btrieve615]
    //   "PreInstalled"=dword:00000001
    //   "PreInstallDir"="C:\\IAOFFICE\\CRYSTAL\\"
    //
    If oReg.OpenKey('Software\IRIS\IRIS Accounts Office\Btrieve615', False) Then
    Begin
      Try
        FGotBtr615BackDoor := oReg.ReadBool('PreInstalled');
        If FGotBtr615BackDoor Then
        Begin
          // Extract the directory and check it exists
          FBtr615Directory := oReg.ReadString('PreInstallDir');
          FGotBtr615BackDoor := DirectoryExists(FBtr615Directory);
        End; // If FGotBtr615BackDoor
      Finally
        oReg.CloseKey;
      End; // Try..Finally
    End; // If oReg.OpenKey('Software\IRIS\IRIS Accounts Office\Btrieve615', False)
  Finally
    oReg.Free;
  End; // Try..Finally
End; // Create

//-------------------------------------------------------------------------

Function TBtrieve615Info.GetGotBtr615BackDoor : Boolean;
Begin // GetGotBtr615BackDoor
  Result := FGotBtr615BackDoor;
End; // GetGotBtr615BackDoor

//------------------------------

Function TBtrieve615Info.GetBtr615Directory : ShortString;
Begin // GetBtr615Directory
  Result := FBtr615Directory;
End; // GetBtr615Directory

//-------------------------------------------------------------------------

end.
