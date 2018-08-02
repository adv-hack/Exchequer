unit TermServ;

// Terminal Server/Services Functions

interface

Uses Dialogs, SysUtils, StrUtils, Windows, Registry;

Type
  // NOTE: This class should not be created directly, but used through the
  // TerminalServices function which returns the global instance of it. The
  // global instance caches the info for max performance.
  TTerminalServices = Class(TObject)
  Private
    FIsTerminalServerSession : Boolean;
    FSessionId               : ULong;
  Protected
  Public
    Property IsTerminalServerSession : Boolean Read FIsTerminalServerSession;
    Property SessionId : ULong Read FSessionId;

    // NOTE: This class should not be created directly, but used through the
    // TerminalServices function which returns the global instance of it. The
    // global instance caches the info for max performance.
    Constructor Create;
  End;


// Function returns a Singleton TTerminalServices object which is
// auto-created the first time the function is called and cached
// until application shutdown
Function TerminalServices : TTerminalServices;


//-------------------------------------------------------------------------
Implementation
//-------------------------------------------------------------------------

const
  // Specifies the current server
  WTS_CURRENT_SERVER        = THandle(0);
  WTS_CURRENT_SERVER_HANDLE = THandle(0);
  WTS_CURRENT_SERVER_NAME   = '';

  // Specifies the current session (SessionId)
  WTS_CURRENT_SESSION = DWORD(-1);

  // New constants for GetSystemMetrics
  SM_REMOTESESSION = $1000;
  SM_REMOTECONTROL = $2001;


Type
  // Specifies the type of information to be returned by WTSQuerySessionInformation
  TWtsInfoClass = (WTSInitialProgram,
                   WTSApplicationName,
                   WTSWorkingDirectory,
                   WTSOEMId,
                   WTSSessionId,
                   WTSUserName,
                   WTSWinStationName,
                   WTSDomainName,
                   WTSConnectState,
                   WTSClientBuildNumber,
                   WTSClientName,
                   WTSClientDirectory,
                   WTSClientProductId,
                   WTSClientHardwareId,
                   WTSClientAddress,
                   WTSClientDisplay,
                   WTSClientProtocolType);

  // Function template for dynamically calling WTSQuerySessionInformation
  TWTSQuerySessionInformation = function (    hServer        : THandle;
                                              SessionId      : DWORD;
                                              WTSInfoClass   : TWtsInfoClass;
                                          var ppBuffer       : Pointer;
                                          var pBytesReturned : DWORD): Boolean; stdcall;

  // Function template for dynamically calling WTSFreeMemory
  TWTSFreeMemory = procedure (pMemory: Pointer); stdcall;

Var
  oTerminalServices : TTerminalServices;

//=========================================================================

// Function returns a Singleton TTerminalServices object which is
// auto-created the first time it the function is called and cached
// until application shutdown
Function TerminalServices : TTerminalServices;
Begin // TerminalServices
  // Check to see if local object has been created - if not create it
  If Not Assigned(oTerminalServices) Then
    oTerminalServices := TTerminalServices.Create;

  // Return handle to local TerminalServices object
  Result := oTerminalServices;
End; // TerminalServices

//=========================================================================

Constructor TTerminalServices.Create;
Const
  KEY_WOW64_64KEY = $0100;
Type
  lpULong = ^ULong;
Var
  lpVersionInformation        : TOSVersionInfo;
  _WTSAPI32                   : THandle;
  _WTSQuerySessionInformation : TWTSQuerySessionInformation;
  _WTSFreeMemory              : TWTSFreeMemory;
  Buffer                      : Pointer;
  BytesReturned               : DWORD;
  // MH 13/07/2017 2017-R2 ABSEXCH-18978: Hyper-V VM's being reported as Terminal Server Sessions
  oReg                        : TRegistry;
Begin // Create
  Inherited Create;

  // Initialise properties to default settings
  FIsTerminalServerSession := False;
  FSessionId := 0;

  Try
    // Get the Version Info to check whether we are running under NT4 or later
    FillChar(lpVersionInformation, Sizeof(lpVersionInformation), 0);
    lpVersionInformation.dwOSVersionInfoSize := Sizeof(lpVersionInformation);
    If GetVersionEx(lpVersionInformation) Then
    Begin
      // Got Info - Check for NT Series OS >= v4
      If (lpVersionInformation.dwPlatformId = VER_PLATFORM_WIN32_NT) And
         (lpVersionInformation.dwMajorVersion >= 4) Then
        // Detect whether we are running under TerminalServices or not
        FIsTerminalServerSession := (GetSystemMetrics (SM_REMOTESESSION) > 0);
    End; // If GetVersionEx(lpVersionInformation)

    // MH 13/07/2017 2017-R2 ABSEXCH-18978: Hyper-V VM's being reported as Terminal Server Sessions
    If FIsTerminalServerSession Then
    Begin
      // Look at the HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Virtual Machine\Guest\Parameters key in
      // the Registry to determine if it is a Hyper-V VM - as far as I know it is only present on VM's
      oReg := TRegistry.Create;
      Try
        oReg.Access := KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS Or KEY_WOW64_64KEY;
        oReg.RootKey := HKEY_LOCAL_MACHINE;

        If oReg.KeyExists('SOFTWARE\Microsoft') Then
        Begin
          If oReg.OpenKey('SOFTWARE\Microsoft', False) Then
          Begin
            // Appears to be some sort of problem checking for 'Virtual Machine' without having opened
            // the parent key first - possibly something to do with the space
            If oReg.KeyExists('Virtual Machine\Guest\Parameters') Then
              FIsTerminalServerSession := False;

            oReg.CloseKey;
          End; // If oReg.OpenKey('SOFTWARE\Microsoft', False)
        End; // If oReg.OpenKey('SOFTWARE\Microsoft\Virtual Machine\Guest', False)
      Finally
        oReg.Free;
      End; // Try..Finally
    End; // If FIsTerminalServerSession

    If FIsTerminalServerSession Then
    Begin
      // Running under Terminal Services - load the Windows Terminal Services
      // API DLL (WTSAPI32.DLL) and use the WTSQuerySessionInformation function
      // to get the Session Id
      _WTSAPI32 := LoadLibrary('WTSAPI32.DLL');

      // Check return value for success
      If (_WTSAPI32 > HInstance_Error) Then
      Begin
        // Try to dynamically get a handle to WTSQuerySessionInformation and WTSFreeMemory
        _WTSQuerySessionInformation := GetProcAddress(_WTSAPI32, 'WTSQuerySessionInformationA');
        _WTSFreeMemory              := GetProcAddress(_WTSAPI32, 'WTSFreeMemory');

        // Check return value for success
        If Assigned(_WTSQuerySessionInformation) And Assigned(_WTSFreeMemory) Then
        Begin
          // Call WTSQuerySessionInformation to retrieve the Session information
          If _WTSQuerySessionInformation(WTS_CURRENT_SERVER_HANDLE,      // hServer        : THandle;
                                         WTS_CURRENT_SESSION,            // SessionId      : DWORD;
                                         WTSSessionId,                   // WTSInfoClass   : TWtsInfoClass;
                                         Buffer,                         // ppBuffer       : Pointer;
                                         BytesReturned) Then             // pBytesReturned : DWORD
          Begin
            // Extract the SessionId from the buffer
            FSessionId := lpULong(Buffer)^;

            // Call WTSFreeMemory to de-allocate Buffer
            _WTSFreeMemory(Buffer);
          End { If _WTSQuerySessionInformation }
          Else
            // Call to WTSQuerySessionInformation failed
            FIsTerminalServerSession := False;
        End // If Assigned(_WTSQuerySessionInformation) And (_WTSFreeMemory)
        Else
          // Error getting API handles
          FIsTerminalServerSession := False;

        // Unload WTSAPI32.DLL
        FreeLibrary(_WTSAPI32);
      End // If (_WTSAPI32 > HInstance_Error)
      Else
        // Error loading WTSAPI32.DLL
        FIsTerminalServerSession := False;
    End; // If FIsTerminalServerSession
  Except
    // Suppress any errors
    On Exception Do
      ;
  End;
End; // Create

//=========================================================================

Initialization
  oTerminalServices := NIL;
Finalization
  If Assigned(oTerminalServices) Then
    FreeAndNIL(oTerminalServices);
end.
