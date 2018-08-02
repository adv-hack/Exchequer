unit PreReqs;

interface

Uses Controls, Registry, SysUtils, Windows;

Type
  // Pre-Requesites in dependance order
  TPreReqCheckType = (prcNetwork=0, prcClient=1, prcExchDSR=2);
  TPreReqIndex = (priWinInstaller=0, priMSXML40=1, priMDAC=2, priNetFramework=3, priSQLExpress=4, priLicencing=5, priPSQLWGE=6);
  TPreReqStatus = (prsInstalled=0, prsMissing=1);

  //------------------------------

  TPreRequisites = Class(TObject)
  Private
    FPreReqCheckType : TPreReqCheckType;
    FClientDir : ShortString;

    FPreReqChecks : Array [TPreReqIndex] Of TPreReqStatus;

    // Checks for the presence of the Windows Installer v3.1
    Procedure CheckForWinInst31;

    // Checks for the presence of the MS XML 4.0 Parser for ICE
    Procedure CheckForMSXML4;

    // Checks for the presence of the MDAC 2.8 SP1 - required by SQL Express
    Procedure CheckForMDAC28;

    // Checks for the presence of the .NET Framework v2.0
    Procedure CheckForNetFramework;

    // Checks for the presence of the IRIS Licencing Subsystem
    Procedure CheckForIRISLicencing;

    // Checks for the presence of MS SQL Server Express 2005
    Procedure CheckForSQLExpress;

    // Checks for the presence of the Pervasive.SQL Client, Server and Workgroup Engines
    Procedure CheckForPervasive;

    Function GetAllChecksPassed : Boolean;
    Function GetPreReqStatus (Index:TPreReqIndex) : TPreReqStatus;
  Public
    // Returns TRUE if all the Pre-Requisit checks passed successfully
    Property AllChecksPassed : Boolean Read GetAllChecksPassed;
    // Returns the individual status of the Pre-Requisit check
    Property PreReqStatus [Index:TPreReqIndex] : TPreReqStatus Read GetPreReqStatus;

    Constructor Create (Const PreReqCheckType : TPreReqCheckType; Const ClientDir : ShortString = '');

    // Performs the pre-requisit checks (called automatically on creation of object)
    Procedure CheckPreReqs;
  End; // TPreRequisites

implementation

Uses DotNet, Dialogs, DebugU, APIUtil, OSChecks, PervInfo;

//=========================================================================

Constructor TPreRequisites.Create (Const PreReqCheckType : TPreReqCheckType; Const ClientDir : ShortString = '');
Begin // Create
  Inherited Create;

  FPreReqCheckType := PreReqCheckType;
  FClientDir := IncludeTrailingPathDelimiter(ClientDir);

  CheckPreReqs;
End; // Create

//-------------------------------------------------------------------------

// Performs the pre-requisit checks
Procedure TPreRequisites.CheckPreReqs;
Var
  iPreReq : TPreReqIndex;
Begin // CheckPreReqs
  // Initialise all pre-reqs to Missing
  For iPreReq := Low(iPreReq) To High(iPreReq) Do
  Begin
    FPreReqChecks[iPreReq] := prsMissing;
  End; // For iPreReq

  // Check for presence of pre-requesits --------------------

  // Windows Installer 3.1
  CheckForWinInst31;

  // MS XML 4.0 Parser
  CheckForMSXML4;

  // .NET Framework 2.0
  CheckForNetFramework;

  // IRISSOFTWARE named instance of SQL Server or SQL Express 2005
  // MH 12/09/08: Don't check for the Dashboard running under Exchequer
  If (FPreReqCheckType <> prcExchDSR) Then
    CheckForSQLExpress;

  // Check for the presence of the MDAC 2.8 SP1 - required by SQL Express
  If (FPreReqChecks[priSQLExpress] = prsInstalled) Then
    // SQL Server Express already installed - don't bother with MDAC
    FPreReqChecks[priMDAC] := prsInstalled
  Else
    CheckForMDAC28;

  // Check for the presence of the Pervasive.SQL Workgroup Engine
  // MH 02/11/06: Don't check for the Dashboard running under Exchequer
  If (FPreReqCheckType <> prcExchDSR) Then
    CheckForPervasive;

  // IRIS Licencing sub-system - for network installs this automatically fails if the
  // IRISSOFTWARE named instance is missing
  // MH 02/11/06: Doesn't apply to the Dashboard running under Exchequer
  If ((FPreReqCheckType = prcClient) Or (FPreReqChecks[priSQLExpress] = prsInstalled) And (FPreReqCheckType <> prcExchDSR)) Then
    CheckForIRISLicencing;
End; // CheckPreReqs

//-------------------------------------------------------------------------

// Checks for the presence of the Windows Installer v3.1
Procedure TPreRequisites.CheckForWinInst31;
Var
  sPath : ANSIString;
  V1, V2, V3, V4: Word;
  oOSChecks : TOSChecks;

  // Taken from newsgroup post by Peter Below
  procedure GetBuildInfo(Const FilePath : ANSIString; Var V1, V2, V3, V4: Word);
  var
    VerInfoSize:  DWORD;
    VerInfo:      Pointer;
    VerValueSize: DWORD;
    VerValue:     PVSFixedFileInfo;
    Dummy:        DWORD;
  begin
    VerInfoSize := GetFileVersionInfoSize(PChar(FilePath), Dummy);
    GetMem(VerInfo, VerInfoSize);
    GetFileVersionInfo(PChar(FilePath), 0, VerInfoSize, VerInfo);
    VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
    with VerValue^ do
    begin
      V1 := dwFileVersionMS shr 16;
      V2 := dwFileVersionMS and $FFFF;
      V3 := dwFileVersionLS shr 16;
      V4 := dwFileVersionLS and $FFFF;
    end;
    FreeMem(VerInfo, VerInfoSize);
  end;

Begin // CheckForWinInst31
  // Ignore this check on 2003 as although MSI.DLL is v3.1.4000.1830 it claims this is newer
  // and doesn't need the update!
  oOSChecks := TOSChecks.Create;
  Try
    // MH 13/06/2013 v7.0.4 ABSEXCH-14364: Added support for Windows 7 onwards
    //If (Not (oOSChecks.ocWindowsVersion In [wv2003Server, wv2003TerminalServer, wvVista])) Then
    If (Not (oOSChecks.ocWindowsVersion In [wv2003Server, wv2003TerminalServer])) And (oOSChecks.ocWindowsVersion < wvVista) Then
    Begin
      // Find System32\MSI.DLL and check the version of it
      sPath := WinGetWindowsSystemDir + 'MSI.DLL';
      If FileExists(sPath) Then
      Begin
        // Check for 3.1.4000.2435 or later
        GetBuildInfo(sPath, V1, V2, V3, V4);
        If  (V1 > 3) Or
           ((V1 = 3) And (V2 > 1)) Or
           ((V1 = 3) And (V2 = 1) And (V3 > 4000)) Or
           ((V1 = 3) And (V2 = 1) And (V3 = 4000) And (V4 >= 2435)) Then
        Begin
          FPreReqChecks[priWinInstaller] := prsInstalled
        End; // If (...
      End; // If FileExists(sPath)

      If DebugMode Then
      Begin
        If (MessageDlg('Windows Installer 3.1 Installed', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
          FPreReqChecks[priWinInstaller] := prsInstalled
        Else
          FPreReqChecks[priWinInstaller] := prsMissing;
      End; // If DebugMode
    End // If (Not (oOSChecks.ocWindowsVersion In [wv2003Server, wv2003TerminalServer])) And (oOSChecks.ocWindowsVersion < wvVista)
    Else
      // 2003 allegedly doesn't need it and presumably Vista won't if it is ever released :-)
      FPreReqChecks[priWinInstaller] := prsInstalled
  Finally
    oOSChecks.Free;
  End; // Try..Finally
End; // CheckForWinInst31

//------------------------------

// Checks for the presence of the MS XML 4.0 Parser for ICE
Procedure TPreRequisites.CheckForMSXML4;
Var
  oReg : TRegistry;
Begin // CheckForMSXML4
  oReg := TRegistry.Create;
  Try
    oReg.Access := KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS;
    oReg.RootKey := HKEY_CLASSES_ROOT;

    // Check for COM Object registration Key
    If oReg.KeyExists('Msxml2.DOMDocument.4.0\Clsid') Then
    Begin
      FPreReqChecks[priMSXML40] := prsInstalled;
    End; // If oReg.KeyExists('Msxml2.DOMDocument.4.0\Clsid')
  Finally
    FreeAndNIL(oReg);
  End; // Try..Finally

  If DebugMode Then
  Begin
    If (MessageDlg('MS XML 4.0 Installed', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
      FPreReqChecks[priMSXML40] := prsInstalled
    Else
      FPreReqChecks[priMSXML40] := prsMissing;
  End; // If DebugMode
End; // CheckForMSXML4

//------------------------------

// Checks for the presence of the MDAC 2.8 SP1 - required by SQL Express
Procedure TPreRequisites.CheckForMDAC28;
Var
  oReg : TRegistry;
  sMDACVer : ShortString;
  oOSChecks : TOSChecks;
Begin // CheckForMDAC28
  // Only needed on Win 2000
  oOSChecks := TOSChecks.Create;
  Try
    If (oOSChecks.ocWindowsVersion In [wv2000, wv2000TerminalServer]) Then
    Begin
      // Check for the MDAC Version number in the registry
      oReg := TRegistry.Create;
      Try
        oReg.Access := KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS;
        oReg.RootKey := HKEY_LOCAL_MACHINE;

        If oReg.OpenKey('Software\Microsoft\DataAccess', False) Then
        Begin
          If oReg.ValueExists('FullInstallVer') Then
          Begin
            sMDACVer := oReg.ReadString('FullInstallVer');
            If (sMDACVer >= '2.81.1117.6') Then
              FPreReqChecks[priMDAC] := prsInstalled;
          End; // If oReg.ValueExists('FullInstallVer')
        End; // If oReg.OpenKey('Software\Microsoft\DataAccess', False)
      Finally
        FreeAndNIL(oReg);
      End; // Try..Finally

      If DebugMode Then
      Begin
        If (MessageDlg('MDAC 2.8 SP1 Installed', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
          FPreReqChecks[priMDAC] := prsInstalled
        Else
          FPreReqChecks[priMDAC] := prsMissing;
      End; // If DebugMode
    End // If (oOSChecks.ocWindowsVersion In [wv2000, wv2000TerminalServer])
    Else
      // XP/2003 which allegedly don't need it
      FPreReqChecks[priMDAC] := prsInstalled
  Finally
    oOSChecks.Free;
  End; // Try..Finally
End; // CheckForMDAC28

//------------------------------

// Checks for the presence of the .NET Framework v2.0
Procedure TPreRequisites.CheckForNetFramework;
Begin // CheckForNetFramework
  If DotNetInfo.Net20Installed Then
    FPreReqChecks[priNetFramework] := prsInstalled;

  If DebugMode Then
  Begin
    If (MessageDlg('.NET Framework v2.0 Installed', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
      FPreReqChecks[priNetFramework] := prsInstalled
    Else
      FPreReqChecks[priNetFramework] := prsMissing;
  End; // If DebugMode
End; // CheckForNetFramework

//------------------------------

// Checks for the presence of MS SQL Server or MS SQL Express 2005
Procedure TPreRequisites.CheckForSQLExpress;
Var
  oReg : TRegistry;
Begin // CheckForSQLExpress
  // Check for the SQL Server/Express version number
  oReg := TRegistry.Create;
  Try
    oReg.Access := KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS;
    oReg.RootKey := HKEY_LOCAL_MACHINE;

    // Check for the 'IRISSOFTWARE' named instance
    If oReg.OpenKey('SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL', False) Then
    Begin
      If oReg.ValueExists('IRISSOFTWARE') Then
        FPreReqChecks[priSQLExpress] := prsInstalled;
    End; // If oReg.OpenKey('SOFTWARE\Microsoft\Microsoft SQL Server', False)
  Finally
    FreeAndNIL(oReg);
  End; // Try..Finally

  If DebugMode Then
  Begin
    If (MessageDlg('SQL Express Installed', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
      FPreReqChecks[priSQLExpress] := prsInstalled
    Else
      FPreReqChecks[priSQLExpress] := prsMissing;
  End; // If DebugMode
End; // CheckForSQLExpress

//------------------------------

// Checks for the presence of the IRIS Licencing Subsystem
Procedure TPreRequisites.CheckForIRISLicencing;
Var
  oReg : TRegistry;
  sAppDir : ShortString;
Begin // CheckForIRISLicencing
  // Check whether the COM Object wrapper for the IRIS Licencing Assemblies is registered
  oReg := TRegistry.Create;
  Try
    oReg.Access := KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS;
    oReg.RootKey := HKEY_CLASSES_ROOT;

    // Check for existence of COM Object
    If oReg.KeyExists('Iris.Systems.Licensing') Then
    Begin
      // Check for existence of 'All Users' files
      oReg.RootKey := HKEY_LOCAL_MACHINE;
      If oReg.OpenKey ('SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', False) Then
      Begin
        If oReg.ValueExists('Common AppData') Then
        Begin
          sAppDir := IncludeTrailingPathDelimiter(oReg.ReadString('Common AppData'));
          If FileExists(sAppDir + 'IRIS Software Ltd\ILMDBPS.ENC') Then
            FPreReqChecks[priLicencing] := prsInstalled;
        End; // If oReg.ValueExists('Common AppData')
      End; // If oReg.OpenKey ('SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', False)
    End; // If oReg.KeyExists('Iris.Systems.Licensing')
  Finally
    FreeAndNIL(oReg);
  End; // Try..Finally

  If DebugMode Then
  Begin
    If (MessageDlg('IRIS Licencing Installed', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
      FPreReqChecks[priLicencing] := prsInstalled
    Else
      FPreReqChecks[priLicencing] := prsMissing;
  End; // If DebugMode
End; // CheckForIRISLicencing

//-------------------------------------------------------------------------

// Checks for the presence of the Pervasive.SQL Client, Server and Workgroup Engines
Procedure TPreRequisites.CheckForPervasive;
Var
  Got615 : Boolean;
Begin // CheckForPervasive
  With PervasiveInfo Do
  Begin
    // MH 24/07/06: Split out for Network/Client as for v6.15 checks on the Client (SetupWks) we
    // need to look in the Client Dir as the registry entries will probably be on a different machine
    If (FPreReqCheckType = prcNetwork) Then
      Got615 := Btrieve615Info.GotBtr615BackDoor
    Else
      // Check Pervasive.SQL Workgroup Engine v8.7 or later is installed
      Got615 := FileExists(FClientDir + 'W32MKDE.EXE');

    // MH 24/07/06: Added v6.15 backdoor check
    If WorkgroupInstalled And (Not (WorkgroupVersion In UpdateWorkgroupVersions)) or Got615 Then
      FPreReqChecks[priPSQLWGE] := prsInstalled;
  End; // With PervasiveInfo

  If DebugMode Then
  Begin
    If (MessageDlg('Pervasive.SQL Workgroup Engine Installed', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
      FPreReqChecks[priPSQLWGE] := prsInstalled
    Else
      FPreReqChecks[priPSQLWGE] := prsMissing;
  End; // If DebugMode
End; // CheckForPervasive

//-------------------------------------------------------------------------

// Returns TRUE if all the Pre-Requisit checks passed successfully for the specified type
Function TPreRequisites.GetAllChecksPassed : Boolean;
Begin // GetAllChecksPassed
  If (FPreReqCheckType = prcNetwork) Then
    Result := (FPreReqChecks[priWinInstaller] = prsInstalled) And       // Windows Installer 3.1
              (FPreReqChecks[priMSXML40] = prsInstalled) And            // MS XML 4.0
              (FPreReqChecks[priMDAC] = prsInstalled) And               // MDAC 2.8 SP1
              (FPreReqChecks[priNetFramework] = prsInstalled) And       // .NET Framework 2.0
              (FPreReqChecks[priLicencing] = prsInstalled) And          // IRIS Licencing - Network
              (FPreReqChecks[priSQLExpress] = prsInstalled) And         // SQL Express 2005 - IRISSOFTWARE named instance
              (FPreReqChecks[priPSQLWGE] = prsInstalled)                // Pervasive.SQL Workgroup Engine
  Else If (FPreReqCheckType = prcClient) Then
    Result := (FPreReqChecks[priWinInstaller] = prsInstalled) And       // Windows Installer 3.1
              (FPreReqChecks[priMSXML40] = prsInstalled) And            // MS XML 4.0
              (FPreReqChecks[priNetFramework] = prsInstalled) And       // .NET Framework 2.0
              (FPreReqChecks[priLicencing] = prsInstalled) And          // IRIS Licencing - Client
              (FPreReqChecks[priPSQLWGE] = prsInstalled)                // Pervasive.SQL Workgroup Engine
  Else If (FPreReqCheckType = prcExchDSR) Then
    Result := (FPreReqChecks[priWinInstaller] = prsInstalled) And       // Windows Installer 3.1
              (FPreReqChecks[priMSXML40] = prsInstalled) And            // MS XML 4.0
              (FPreReqChecks[priMDAC] = prsInstalled) And               // MDAC 2.8 SP1
// MH 12/09/08: Don't check for the Dashboard running under Exchequer
//              (FPreReqChecks[priSQLExpress] = prsInstalled) And         // SQL Express 2005 - IRISSOFTWARE named instance
              (FPreReqChecks[priNetFramework] = prsInstalled)           // .NET Framework 2.0
  Else
    Raise Exception.Create('TPreRequisites.GetAllChecksPassed: Unhandled CheckType');
End; // GetAllChecksPassed

//------------------------------

// Returns the individual status of the Pre-Requisit check
Function TPreRequisites.GetPreReqStatus (Index:TPreReqIndex) : TPreReqStatus;
Begin // GetPreReqStatus
  Result := FPreReqChecks[Index];
End; // GetPreReqStatus

//-------------------------------------------------------------------------

end.
