unit oMCMSec;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{$WARN SYMBOL_PLATFORM OFF}
interface

Uses Classes, Dialogs, Forms, Messages, SysUtils, Windows;

Type
  TSecuritySystem = (ssEnterprise, ssToolkit, ssTrade);

  // Maps onto InitCompDll in DLLComp.Pas
  TInitEntCompFunc = Procedure (DataPath : ShortString);

  // Maps onto TermCompDll2 in DLLComp.Pas
  TTermEntCompFunc = Procedure;

  // Maps onto GetCurrentUserCounts in UserSec.Pas
  TGetUserCountsFunc = Function (Const SysId                       : Char;
                                 Var   TotalLicenced, LicencesUsed : SmallInt) : LongInt;

  // Maps onto GetSystemUserInstances in UserSec.Pas
  TGetSysUserInstancesFunc = Function (Const SysId      : Char;
                                       Const CompanyId  : LongInt;
                                       Var   TotalUsers : SmallInt) : LongInt;

  // Maps onto RemoveCIDLoginRef in UserSec.Pas
  TResetCIDUserCounts = Function (Const CompanyId  : LongInt) : LongInt;

  // MH 11/01/2013 v7.1 ABSEXCH-13259: Extended to allow toolkit counts only to be removed
  // MH 23/01/2017 2017-R1 ABSEXCH-13259: Copied in from the abandoned v7.1 branch
  // Maps onto RemoveCIDLoginRefEx in UserSec.Pas
  TResetCIDUserCountsEx = Function (Const CompanyId : LongInt; Const RemoveExchequer, RemoveToolkit, RemoveTrade : Boolean) : LongInt;

  // Maps onto AddLoginRef in UserSec.Pas - replaced by AddLoginRefWithCoCode (see below)
  TOldAddLoginRefFunc = Function (Const SysId      : Char;
                                  Const CompanyId  : LongInt;
                                        WStationId : ShortString;
                                        UserId     : ShortString) : LongInt;


  // Maps onto AddLoginRefWithCoCode in UserSec.Pas
  TAddLoginRefFunc = Function (Const SysId      : Char;
                               Const CompanyId  : LongInt;
                                     WStationId : ShortString;
                                     UserId     : ShortString;
                               Var   CompCode   : ShortString) : LongInt;

  // Maps onto RemoveLoginRef in UserSec.Pas, removes an existing Company / Workstation Cross-Reference Record
  TRemoveLoginRefFunc = Function (Const SysId      : Char;
                                  Const CompanyId  : LongInt;
                                        WStationId : ShortString;
                                        UserId     : ShortString) : LongInt;

  {$IFDEF EXDLL}
  // Maps onto RemoveLoginRefEx in UserSec.Pas, an extended version of RemoveLoginRef that returns
  // a flag to indicate whether a Company / Workstation Cross-Reference Record was removed
  TRemoveLoginRefExFunc = Function (Const SysId      : Char;
                                    Const CompanyId  : LongInt;
                                          WStationId : ShortString;
                                          UserId     : ShortString;
                                    Var   Removed    : Boolean) : LongInt;
  {$ENDIF}

  // Maps onto LockControlRec in UserSec.Pas
  TLockControlRecFunc = Function (Const SysId : Char) : LongInt;

  // Maps onto UnlockControlRec in UserSec.Pas
  TUnlockControlRecFunc = Procedure (Const SysId : Char);

  // Maps onto CheckPlugInLicence in PlugInSec.Pas
  TCheckPlugInLicence = Function (Const PlugInCode : ShortString) : LongInt; StdCall;

Const
  //cmUserCount      = 'U';      { Enterprise Global User Count }
  //cmTKUserCount    = 'T';      { Toolkit Global User Count }
  //cmTradeUserCount = 'R';      { Trade Counter Global User Count }
  SystemSecurityChars : Array [TSecuritySystem] Of Char = ('U', 'T', 'R');

Type
  TMCMSecurity = Class(TObject)
  Private
    // Company Id of data set in use
    FCompanyId    : LongInt;

    // Property indicating the current security system
    FSystem       : TSecuritySystem;

    // Windows Workstation Name
    FWorkstationId : ShortString;

    // Windows User Id
    FUserId : ShortString;

    // Company Code - returned by AddLoginRef
    FCompanyCode : ShortString;

    // Handle to the loaded instance of EntComp.Dll
    FEntCompDLL   : THandle;

    // Handle to the InitCompDll func which initialises EntComp.Dll for use
    FInitCompFunc : TInitEntCompFunc;

    // Handle to the TermpCompDll2 func which shuts down EntComp.Dll without doing a Btrv Reset
    FTermEntCompFunc : TTermEntCompFunc;

    // Maps onto GetCurrentUserCounts in UserSec.Pas, used to get the current and licenced user counts
    FUserCountsFunc : TGetUserCountsFunc;

    // Maps onto GetSystemUserInstances in UserSec.Pas, used to identify the number of
    // users registered as logged in to a specific company data set for a sp4ecific system
    FGetSysUserInstancesFunc : TGetSysUserInstancesFunc;

    // Maps onto RemoveCIDLoginRef in UserSec.Pas, used to reset the Company User Count Security records
    FResetCIDCountsFunc : TResetCIDUserCounts;

    // MH 11/01/2013 v7.1 ABSEXCH-13259: Extended to allow toolkit counts only to be removed
    // MH 23/01/2017 2017-R1 ABSEXCH-13259: Copied in from the abandoned v7.1 branch
    // Maps onto RemoveCIDLoginRefEx in UserSec.Pas, used to reset the Company User Count Security records
    FResetCIDCountsExFunc : TResetCIDUserCountsEx;

    // Maps onto AddLoginRef in UserSec.Pas, used to add a Company / Workstation Cross-Reference record
    FAddLoginRefFunc : TAddLoginRefFunc;

    // Legacy function - replaced by AddLoginRef above
    FOldAddLoginRefFunc : TOldAddLoginRefFunc;

    // Maps onto RemoveLoginRef in UserSec.Pas, removes an existing Company / Workstation Cross-Reference Record
    FRemoveLoginRefFunc : TRemoveLoginRefFunc;

    {$IFDEF EXDLL}
    // Maps onto RemoveLoginRefEx in UserSec.Pas, removes an existing Company / Workstation Cross-Reference Record
    FRemoveLoginRefExFunc : TRemoveLoginRefExFunc;
    {$ENDIF}

    // Stores the result of the FLockControlRecFunc call
    FLockRes : LongInt;
    // Maps onto LockControlRec in UserSec.Pas
    FLockControlRecFunc : TLockControlRecFunc;
    // Maps onto UnlockControlRec in UserSec.Pas
    FUnlockControlRecFunc : TUnlockControlRecFunc;

    // Maps onto CheckPlugInLicence in PlugInSec.Pas
    FCheckPlugInLicence : TCheckPlugInLicence;

    function GetModuleLicence (Const WantType : Byte) : SmallInt;
  Protected
    Function GetLicenceCount : SmallInt;
    Function GetLicencesUsed : SmallInt;
    Function GetTotalUsers : SmallInt;

    procedure ResetFuncHandles;
  Public
    // Company Code - set by AddLoginRef/AddLoginRefEx
    Property msCompanyCode : ShortString Read FCompanyCode;

    // Company Id of data set in use
    Property msCompanyId : LongInt Read FCompanyId Write FCompanyId;

    // Number of users Licenced for the current module (msSystem)
    Property msLicenceCount : SmallInt Read GetLicenceCount;

    // Number of user licences s in use for the current module (msSystem)
    Property msLicencesUsed : SmallInt Read GetLicencesUsed;

    // Property indicating the current security system
    Property msSystem : TSecuritySystem Read FSystem Write FSystem;

    // Number of users using for the current module (msSystem)
    Property msTotalUsers : SmallInt Read GetTotalUsers;

    // Windows Workstation Name
    Property msWorkstationId : ShortString Read FWorkstationId;

    // Windows User Id
    Property msUserId : ShortString Read FUserId;


    Constructor Create (Const SystemId : TSecuritySystem; Const CompanyId : LongInt; Const DLLPath : ShortString = '');
    Destructor Destroy; Override;

    // Adds a Company / Workstation Cross-Reference record
    Function AddLoginRef : Boolean;
    Function AddLoginRefEx : LongInt;

    // Returns an error string for an error status returned by the
    // AddLoginRef / AddLoginRefEx functions
    Function AddLoginRefErr (Const ErrNo : LongInt) : ShortString;

    // Returns True if EntComp.Dll was successfully loaded and the function handles retrieved
    function Loaded : Boolean;

    // Removes a Company / Workstation Cross-Reference record. NOTE: This does not reset
    // the User Counts stored within ExchQss.Dat, these must be reset by the calling application.
    Function RemoveLoginRef : Boolean;
    Function RemoveLoginRefEx : LongInt;
    {$IFDEF EXDLL}
    Function RemoveLoginRefExBool (Var Removed : Boolean) : Boolean;
    {$ENDIF}


    // Resets all User Counts for the system - called after a successfull exclusive check
    Procedure ResetSystemSecurity;
    Function  ResetSystemSecurityEx : LongInt;

    // MH 11/01/2013 v7.1 ABSEXCH-13259: Extended to allow toolkit counts only to be removed
    // MH 23/01/2017 2017-R1 ABSEXCH-13259: Copied in from the abandoned v7.1 branch
    // Resets the Toolkit User Counts for the Company - called after a successfull exclusive check
    Function ResetToolkitSecurityEx : LongInt;

    // MH 16/01/06: Modified to use a record lock mechanism so that only one toolkit instance
    // can Login/Logout at a time in an attempt to kill User Count Corruption which appears
    // to be caused by the parallel nature of the code before this time.
    Function LockControlRec : Boolean;
    Procedure UnlockControlRec;

    // MH 08/01/2010: Added function to check on Plug-In Release Code statuses
    //
    //   0   Not Licenced
    //   1   30-Day Licence
    //   2   Full Licence
    // -ve   Error - panic!
    //
    Function CheckPlugInLicence (Const PlugInCode : ShortString) : LongInt;
  End; { TMCMSecurity }


implementation

Uses
  TermServ,     // Terminal Server Interface
  {$IFDEF EXDLL}
    ErrLogs,
  {$ENDIF} // EXDLL
  VAOUtil,
  APIUtil;

//-------------------------------------------------------------------------

constructor TMCMSecurity.Create (Const SystemId  : TSecuritySystem;
                                 Const CompanyId : LongInt;
                                 Const DLLPath  : ShortString = '');
Const
  {$IF Defined(COMTK) or Defined(EXDLL)}     {*V5TKSMEM - Added EXDLL for Toolkit DLL }
    DLLName = 'ENTCOMP2.DLL';
  {$ELSE}
    DLLName = 'ENTCOMP.DLL';
  {$IFEND}
Var
  LibPath : ANSIString;

  //-----------------------------------

  // MH 20/03/2017 2017-R1 ABSEXCH-18431: Switched to using a fixed name for all Terminal Services
  // sessions to reduce problems with Ghost Users when users don't close sessions properly
  Function FixedTerminalServicesMode : Boolean;
  Const
    FlagFilename = 'TSMODE.SESSION';
  Begin // FixedTerminalServicesMode
    If (DLLPath <> '') Then
	  // Look in specified directory
      Result := Not FileExists(IncludeTrailingBackslash(DLLPath) + FlagFilename)
    Else
      // Look in Company.Dat directory
      Result := Not FileExists(VAOInfo.vaoCompanyDir + FlagFilename);
  End; // FixedTerminalServicesMode

  //-----------------------------------

begin
  Inherited Create;

  FCompanyId := CompanyId;
  FSystem := SystemId;
  FCompanyCode := '';

  {$IFDEF EXDLL}
  FLockRes := -1;
  {$ENDIF}

  ResetFuncHandles;

  // HM 30/07/03: Extended to check for Terminal Services and use SessionId
  Try
    // Get global TerminalServices object
    With TerminalServices Do
    Begin
      // Check to see if running under Terminal Server
      If IsTerminalServerSession Then
      Begin
        // MH 20/03/2017 2017-R1 ABSEXCH-18431: Switched to using a fixed name for all Terminal Services
        // sessions to reduce problems with Ghost Users when users don't close sessions properly
        If FixedTerminalServicesMode Then
          FWorkstationId := 'TerminalServices'
        Else
          // Running under Terminal Server use SessionId instead of Computer Name
          FWorkstationId := 'TS-Session:' + IntToStr(SessionId)
      End // If IsTerminalServerSession
      Else
        // Not running under Terminal Server or some sort of error
        FWorkstationId := UpperCase(WinGetComputerName);
    End; { With TerminalServices }
  Except
    On Exception Do
      // Windows Workstation Name
      FWorkstationId := UpperCase(WinGetComputerName);
  End;

  // Windows User Id
  FUserId := UpperCase(WinGetUserName);

  // Dynamically load EntComp.Dll
  If (Trim (DLLPath) <> '') Then
    LibPath := IncludeTrailingBackslash(DLLPath) + DLLName
  Else
    LibPath := DLLName;
  FEntCompDLL := LoadLibrary(PCHAR(LibPath));
  If (FEntCompDLL > HInstance_Error) Then
  Begin
    // Get Handle for InitCompDLL function
    FInitCompFunc := GetProcAddress(FEntCompDLL, 'InitCompDllEx2');
//    FInitCompFunc := GetProcAddress(FEntCompDLL, 'InitCompDllEx');

    // Get Handle for TermCompDll2 function
    FTermEntCompFunc := GetProcAddress(FEntCompDLL, 'TermCompDll3');
//    FTermEntCompFunc := GetProcAddress(FEntCompDLL, 'TermCompDll2');

    // Handle for GetCurrentUserCounts function in UserSec.Pas
    FUserCountsFunc := GetProcAddress(FEntCompDLL, 'GetCurrentUserCounts');

    // Handle for the GetSystemUserInstances function in UserSec.Pas
    FGetSysUserInstancesFunc := GetProcAddress(FEntCompDLL, 'GetSystemUserInstances');

    // Handle onto RemoveCIDLoginRef
    FResetCIDCountsFunc := GetProcAddress(FEntCompDLL, 'RemoveCIDLoginRef');

    // MH 11/01/2013 v7.1 ABSEXCH-13259: Extended to allow toolkit counts only to be removed
    // MH 23/01/2017 2017-R1 ABSEXCH-13259: Copied in from the abandoned v7.1 branch
    // Handle onto RemoveCIDLoginRefEx
    FResetCIDCountsExFunc := GetProcAddress(FEntCompDLL, 'RemoveCIDLoginRefEx');

    // Maps onto AddLoginRef in UserSec.Pas, used to add a Company / Workstation Cross-Reference record
    FAddLoginRefFunc := GetProcAddress(FEntCompDLL, 'AddLoginRefWithCoCode');

    // Legacy function - replaced by AddLoginRef above
    FOldAddLoginRefFunc := GetProcAddress(FEntCompDLL, 'AddLoginRef');

    // Maps onto RemoveLoginRef in UserSec.Pas, removes an existing Company / Workstation Cross-Reference Record
    FRemoveLoginRefFunc := GetProcAddress(FEntCompDLL, 'RemoveLoginRef');

    {$IFDEF EXDLL}
    // Maps onto RemoveLoginRef in UserSec.Pas, removes an existing Company / Workstation Cross-Reference Record
    FRemoveLoginRefExFunc := GetProcAddress(FEntCompDLL, 'RemoveLoginRefEx');
    {$ENDIF}

    // Maps onto LockControlRec in UserSec.Pas
    FLockControlRecFunc := GetProcAddress(FEntCompDLL, 'LockControlRec');

    // Maps onto UnlockControlRec in UserSec.Pas
    FUnlockControlRecFunc := GetProcAddress(FEntCompDLL, 'UnlockControlRec');

    // Maps onto CheckPlugInLicence in PlugInSec.Pas
    FCheckPlugInLicence := GetProcAddress(FEntCompDLL, 'CheckPlugInLicence');
  End; { If (FEntCompDLL > HInstance_Error) }

  // Check that the Security Object created OK and could load EntComp.DLL
  If Loaded Then
    // Initialise EntComp.Dll
    // HM 17/08/04: Changed pathing to be VAO aware
    //FInitCompFunc (DLLPath)
    FInitCompFunc (VAOInfo.vaoCompanyDir)
  Else Begin
    // Could not load DLL or one of the functions
    //PR 11/04/03 If in Dll or Com toolkit, raise an exception rather than showing a message
  {$IF Defined(COMTK) or Defined(EXDLL)}
    raise Exception.Create('Unable to load the Security Sub-System');
  {$ELSE}
    MessageDlg ('Unable to load the Security Sub-System, please contact your Technical Support', mtError, [mbOk], 0);
    Halt;
  {$IFEND}
  End; { If ... }
end;

//-----------------------------------------

destructor TMCMSecurity.Destroy;
begin
  // De-Initialise EntComp.Dll
  If Assigned(FTermEntCompFunc) Then FTermEntCompFunc;

  // Unload EntComp.Dll
  ResetFuncHandles;
  If (FEntCompDLL > HInstance_Error) Then FreeLibrary (FEntCompDLL);
  FEntCompDLL := 0;

  Inherited Destroy;
end;

//-----------------------------------------

// Returns True if EntComp.Dll was successfully loaded and the function handles retrieved
function TMCMSecurity.Loaded : Boolean;
Begin { Loaded }
  Result := (FEntCompDLL > HInstance_Error) And
            Assigned (FInitCompFunc) And
            Assigned (FTermEntCompFunc) And
            Assigned (FUserCountsFunc) And
            Assigned (FGetSysUserInstancesFunc) And
            Assigned (FResetCIDCountsFunc) And
            // MH 11/01/2013 v7.1 ABSEXCH-13259: Extended to allow toolkit counts only to be removed
            // MH 23/01/2017 2017-R1 ABSEXCH-13259: Copied in from the abandoned v7.1 branch
            Assigned (FResetCIDCountsExFunc) And
            (Assigned (FAddLoginRefFunc) Or Assigned(FOldAddLoginRefFunc)) And
            {$IFDEF EXDLL}
            Assigned (FRemoveLoginRefExFunc) And
            {$ENDIF}
            Assigned (FRemoveLoginRefFunc);
End; { Loaded }

//-----------------------------------------

procedure TMCMSecurity.ResetFuncHandles;
Begin { ResetFuncHandles }
  FInitCompFunc := NIL;
  FTermEntCompFunc := NIL;
  FUserCountsFunc := NIL;
  FGetSysUserInstancesFunc := NIL;
  FResetCIDCountsFunc := NIL;
  // MH 11/01/2013 v7.1 ABSEXCH-13259: Extended to allow toolkit counts only to be removed
  // MH 23/01/2017 2017-R1 ABSEXCH-13259: Copied in from the abandoned v7.1 branch
  FResetCIDCountsExFunc := NIL;
  FAddLoginRefFunc := NIL;
  FOldAddLoginRefFunc := NIL;
  FRemoveLoginRefFunc := NIL;
  {$IFDEF EXDLL}
  FRemoveLoginRefExFunc := NIL;
  {$ENDIF}
End; { ResetFuncHandles }

//-----------------------------------------

// Resets all User Counts for the system - called after a successfull exclusive check
Function TMCMSecurity.ResetSystemSecurityEx : LongInt;
begin
  If Assigned (FResetCIDCountsFunc) Then
    Result := FResetCIDCountsFunc (FCompanyId)
  Else
    Result := -1;
end;

//------------------------------

// MH 11/01/2013 v7.1 ABSEXCH-13259: Extended to allow toolkit counts only to be removed
// MH 23/01/2017 2017-R1 ABSEXCH-13259: Copied in from the abandoned v7.1 branch
// Resets the Toolkit User Counts for the Company - called after a successfull exclusive check
Function TMCMSecurity.ResetToolkitSecurityEx : LongInt;
begin
  If Assigned (FResetCIDCountsExFunc) Then
    Result := FResetCIDCountsExFunc (FCompanyId, False, True, False)
  Else
    Result := -1;
end;

//-----------------------------------------
// Resets all User Counts for the system - called after a successfull exclusive check
procedure TMCMSecurity.ResetSystemSecurity;
Var
  Res : LongInt;
begin
  Res := ResetSystemSecurityEx;

  If (Res <> 0) Then
    MessageDlg ('The following error was returned by FResetCIDCountsFunc in oMCMSec.Pas' +
                #13#13 + 'Error ' + IntToStr(Res) + #13#13 + 'Please contact your technical support',
                mtError, [mbOk], 0);
end;

//-----------------------------------------

// Gets the number of users licenced for the module
function TMCMSecurity.GetLicenceCount: SmallInt;
begin
  Result := GetModuleLicence (0);
end;

// Gets the number of users currently using the module
function TMCMSecurity.GetLicencesUsed: SmallInt;
begin
  Result := GetModuleLicence (1);
end;

function TMCMSecurity.GetModuleLicence (Const WantType : Byte) : SmallInt;
Var
  Res                          : LongInt;
  TotalLicenced, CurrentlyUsed : SmallInt;
  CrapFixStr                   : ShortString;
Begin {  GetModuleLicence }
  Result := 0;

  // *** DO NOT REMOVE THE FOLLOWING CODE ***
  // This code is here to fix an Internal Error C1569 when compiling!
  CrapFixStr := ' ';

  If Assigned (FUserCountsFunc) Then Begin
    Res := FUserCountsFunc (SystemSecurityChars[FSystem], TotalLicenced, CurrentlyUsed);

    If (Res = 0) Then
      Case WantType Of
        0 : Result := TotalLicenced;
        1 : Result := CurrentlyUsed;
      Else
        Raise Exception.Create ('Invalid WantType Value in TMCMSecurity.GetModuleLicence');
      End { Case }
    Else
      MessageDlg ('The following error was returned by FUserCountsFunc in oMCMSec.Pas' +
                  #13#13 + 'Error ' + IntToStr(Res) + #13#13 + 'Please contact your technical support',
                  mtError, [mbOk], 0);
  End; { If Assigned (FUserCountsFunc) }
End; { GetModuleLicence }

//-----------------------------------------

// Gets the total number of uses using the module including duplicate logins for the Company Data Set
function TMCMSecurity.GetTotalUsers: SmallInt;
Var
  Res        : LongInt;
  TotalUsers : SmallInt;
begin
  Result := 0;

  If Assigned (FGetSysUserInstancesFunc) Then Begin
    Res := FGetSysUserInstancesFunc (SystemSecurityChars[FSystem], FCompanyId, TotalUsers);

    If (Res = 0) Then
      Result := TotalUsers
    Else
      MessageDlg ('The following error was returned by FGetSysUserInstancesFunc in oMCMSec.Pas' +
                  #13#13 + 'Error ' + IntToStr(Res) + #13#13 + 'Please contact your technical support',
                  mtError, [mbOk], 0);
  End; { If Assigned (FUserCountsFunc) }
end;

//-----------------------------------------

// Returns an error string for an error status returned by the
// AddLoginRef / AddLoginRefEx functions
Function TMCMSecurity.AddLoginRefErr (Const ErrNo : LongInt) : ShortString;
Begin { AddLoginRefErr }
  Result := 'Error ' + IntToStr(ErrNo) + ' - ';

  Case ErrNo Of
    // AOK
    0        : Result := '';

    // Unknown Error
    1000     : Result := Result + 'Unknown Error';

    // Unknown Exception
    1001     : Result := Result + 'Unknown Exception';

    // User Count Exceeded
    1002     : Result := Result + 'The licenced User Count has already been fully used';

    // Invalid Company Id
    1003     : Result := Result + 'The Company Data Set is not present in the active Multi-Company Manager';
  Else
    Result := Result + 'No Description Available';
  End; { Case ErrNo }
End; { AddLoginRefErr }

//-----------------------------------------

// Adds a Company / Workstation Cross-Reference record
Function TMCMSecurity.AddLoginRef : Boolean;
Var
  Res : LongInt;
Begin { AddLoginRef }
  Res := AddLoginRefEx;

  If (Res = 1002) Then
    // User Count exceeded
    MessageDlg ('You cannot be Logged In because the maximum number of users are already using the system, ' +
                'please try again later', mtError, [mbOk], 0)
  Else
    If (Res > 0) Then
      MessageDlg ('The following error was returned by FAddLoginRefFunc in oMCMSec.Pas' +
                  #13#13 + 'Error ' + IntToStr(Res) + #13#13 + 'Please contact your technical support',
                  mtError, [mbOk], 0);

  Result := (Res <= 0);
End; { AddLoginRef }

// Adds a Company / Workstation Cross-Reference record
Function TMCMSecurity.AddLoginRefEx : LongInt;
Begin { AddLoginRef }
  Result := -1;
  If Assigned(FAddLoginRefFunc) Then
    Result := FAddLoginRefFunc (SystemSecurityChars[FSystem],
                                FCompanyId,
                                FWorkstationId,
                                FUserId,
                                FCompanyCode)
  Else If Assigned(FOldAddLoginRefFunc) Then
    Result := FOldAddLoginRefFunc (SystemSecurityChars[FSystem],
                                   FCompanyId,
                                   FWorkstationId,
                                   FUserId)
End; { AddLoginRef }

//-----------------------------------------

// Removes a Company / Workstation Cross-Reference record. NOTE: This does not reset
// the User Counts stored within ExchQss.Dat, these must be reset by the calling application.
Function TMCMSecurity.RemoveLoginRefEx : LongInt;
Begin { RemoveLoginRefEx }
  If Assigned(FRemoveLoginRefFunc) Then
    Result := FRemoveLoginRefFunc (SystemSecurityChars[FSystem],
                                   FCompanyId,
                                   FWorkstationId,
                                   FUserId)
  Else
    Result := -1;
End; { RemoveLoginRefEx }

// Removes a Company / Workstation Cross-Reference record. NOTE: This does not reset
// the User Counts stored within ExchQss.Dat, these must be reset by the calling application.
Function TMCMSecurity.RemoveLoginRef : Boolean;
Var
  Res : LongInt;
Begin  { RemoveLoginRef }
  Res := RemoveLoginRefEx;

  If (Res <> 0) Then
    MessageDlg ('The following error was returned by FRemoveLoginRefFunc in oMCMSec.Pas' +
                #13#13 + 'Error ' + IntToStr(Res) + #13#13 + 'Please contact your technical support',
                mtError, [mbOk], 0);

  Result := (Res = 0);
End; { RemoveLoginRef }

{$IFDEF EXDLL}
// Alternate version used by the Toolkits which returns a flag to indicate whether
// a Company / Workstation Cross-Reference record has been removed or not.
Function TMCMSecurity.RemoveLoginRefExBool (Var Removed : Boolean) : Boolean;
Var
  Res : LongInt;
Begin { RemoveLoginRefExBool }
  Removed := False;

  If Assigned(FRemoveLoginRefExFunc) Then Begin
    Res := FRemoveLoginRefExFunc (SystemSecurityChars[FSystem],
                                  FCompanyId,
                                  FWorkstationId,
                                  FUserId,
                                  Removed);

    // HM 05/11/04: Added error logging for Toolkits
    If (Res <> 0) Then RemoveLoginRefErrorLog (Res, FUserId, FWorkstationId);

    Result := (Res = 0);
  End { If Assigned(FRemoveLoginRefExFunc) }
  Else
    Result := False;
End; { RemoveLoginRefExBool }
{$ENDIF}

//-------------------------------------------------------------------------

// MH 16/01/06: Modified to use a record lock mechanism so that only one toolkit instance
// can Login/Logout at a time in an attempt to kill User Count Corruption which appears
// to be caused by the parallel nature of the code before this time.
Function TMCMSecurity.LockControlRec : Boolean;
Begin // LockControlRec
  If Assigned(FLockControlRecFunc) Then
  Begin
    FLockRes := FLockControlRecFunc(SystemSecurityChars[FSystem]);
    Result := (FLockRes = 0);
  End // If Assigned(FLockControlRecFunc)
  Else
    // Functionality not available - failback to normal routine
    Result := True;
End; // LockControlRec

//------------------------------

Procedure TMCMSecurity.UnlockControlRec;
Begin // UnlockControlRec
  If Assigned(FUnlockControlRecFunc) And (FLockRes = 0) Then
  Begin
    FUnlockControlRecFunc(SystemSecurityChars[FSystem]);
    FLockRes := -1;
  End; // If Assigned(FUnlockControlRecFunc)
End; // UnlockControlRec

//-------------------------------------------------------------------------

// MH 08/01/2010: Added function to check on Plug-In Release Code statuses
//
//   0   Not Licenced
//   1   30-Day Licence
//   2   Full Licence
//
//  -1   Function handle not defined
//
Function TMCMSecurity.CheckPlugInLicence (Const PlugInCode : ShortString) : LongInt;
Var
  Res : LongInt;
Begin // CheckPlugInLicence
  Result := -1;
  If Assigned(FCheckPlugInLicence) Then
  Begin
    Res := FCheckPlugInLicence(PlugInCode);
    Case Res Of
      0 : Result := 0; // Not Licensed
      1 : Result := 1; // 30-Day
      2 : Result := 2; // Full Licence
    Else
      MessageDlg ('The following error was returned by CheckPlugInLicence in oMCMSec.Pas' +
                  #13#13 + 'Error ' + IntToStr(Res) + #13#13 + 'Please contact your technical support',
                  mtError, [mbOk], 0);
    End; // Case Res
  End; // If Assigned(FUnlockControlRecFunc)
End; // CheckPlugInLicence

//=========================================================================

end.
