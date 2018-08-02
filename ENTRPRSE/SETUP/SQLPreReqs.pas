unit SQLPreReqs;

interface

Uses Controls, Registry, SysUtils, Windows;

Type
  TPreReqCheckType = (prcStandard=0);
  // Pre-Requesites in dependance order
  TPreReqIndex = (priWinInstaller=0, priSQLNCli=1);
  TPreReqStatus = (prsInstalled=0, prsMissing=1);

  //------------------------------

  TSQLPreRequisites = Class(TObject)
  Private
    FPreReqCheckType : TPreReqCheckType;
    FClientDir : ShortString;

    FPreReqChecks : Array [TPreReqIndex] Of TPreReqStatus;

    // Checks for the presence of the Windows Installer v3.1
    Procedure CheckForWinInst31;

    // Checks for the presence of the SQL Native Client
    Procedure CheckForSQLNCli;

    Function GetAllChecksPassed : Boolean;
    Function GetPreReqStatus (Index:TPreReqIndex) : TPreReqStatus;
  Public
    // Returns TRUE if all the Pre-Requisit checks passed successfully
    Property AllChecksPassed : Boolean Read GetAllChecksPassed;
    // Returns the individual status of the Pre-Requisit check
    Property PreReqStatus [Index:TPreReqIndex] : TPreReqStatus Read GetPreReqStatus;

    Constructor Create (Const PreReqCheckType : TPreReqCheckType = prcStandard; Const ClientDir : ShortString = '');

    // Performs the pre-requisit checks (called automatically on creation of object)
    Procedure CheckPreReqs;
  End; // TSQLPreRequisites

implementation

Uses DotNet, Dialogs, DebugU, APIUtil, OSChecks, PervInfo;

//=========================================================================

Constructor TSQLPreRequisites.Create (Const PreReqCheckType : TPreReqCheckType = prcStandard; Const ClientDir : ShortString = '');
Begin // Create
  Inherited Create;

  FPreReqCheckType := PreReqCheckType;
  FClientDir := IncludeTrailingPathDelimiter(ClientDir);

  CheckPreReqs;
End; // Create

//-------------------------------------------------------------------------

// Performs the pre-requisit checks
Procedure TSQLPreRequisites.CheckPreReqs;
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

  // SQL Native Client
  CheckForSQLNCli;
End; // CheckPreReqs

//-------------------------------------------------------------------------

// Checks for the presence of the Windows Installer v3.1
Procedure TSQLPreRequisites.CheckForWinInst31;
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
    // MH 08/05/2013 v7.0.4 ABSEXCH-12022: Added support for Windows 7, Windows 8 and Windows Server 2012
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

// Checks for the presence of the SQL Native Client
Procedure TSQLPreRequisites.CheckForSQLNCli;
Var
  oReg : TRegistry;
Begin // CheckForSQLNCli
  oReg := TRegistry.Create;
  Try
    oReg.Access := KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS;
    oReg.RootKey := HKEY_LOCAL_MACHINE;

    // MH 22/07/08: Extended to detect SQL Server 2008 version of SQL Native Client
    If oReg.KeyExists('SOFTWARE\ODBC\ODBCINST.INI\SQL Native Client') Or
       oReg.KeyExists('SOFTWARE\ODBC\ODBCINST.INI\SQL Server Native Client 10.0') Then
    Begin
      FPreReqChecks[priSQLNCli] := prsInstalled;
    End; // If oReg.KeyExists('SOFTWARE\ODBC\ODBCINST.INI\SQL Native Client')
  Finally
    FreeAndNIL(oReg);
  End; // Try..Finally

  If DebugMode Then
  Begin
    If (MessageDlg('SQL Native client Installed', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
      FPreReqChecks[priSQLNCli] := prsInstalled
    Else
      FPreReqChecks[priSQLNCli] := prsMissing;
  End; // If DebugMode
End; // CheckForSQLNCli

//-------------------------------------------------------------------------

// Returns TRUE if all the Pre-Requisit checks passed successfully for the specified type
Function TSQLPreRequisites.GetAllChecksPassed : Boolean;
Begin // GetAllChecksPassed
  If (FPreReqCheckType = prcStandard) Then
    Result := (FPreReqChecks[priWinInstaller] = prsInstalled) And       // Windows Installer 3.1
              (FPreReqChecks[priSQLNCli] = prsInstalled)                // SQL Native client
  Else
    Raise Exception.Create('TSQLPreRequisites.GetAllChecksPassed: Unhandled CheckType');
End; // GetAllChecksPassed

//------------------------------

// Returns the individual status of the Pre-Requisit check
Function TSQLPreRequisites.GetPreReqStatus (Index:TPreReqIndex) : TPreReqStatus;
Begin // GetPreReqStatus
  Result := FPreReqChecks[Index];
End; // GetPreReqStatus

//-------------------------------------------------------------------------

end.
