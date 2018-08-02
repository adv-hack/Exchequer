unit userenv;

interface

uses Windows;


//=============================================================================
//  profinfo.h   -   Header file for profile info structure.
//=============================================================================

type
  PProfileInfoA = ^TProfileInfoA;
  TProfileInfoA = record
    dwSize:        DWORD;          // Set to sizeof(PROFILEINFO) before calling
    dwFlags:       DWORD;          // See PI_ flags defined in userenv.h
    lpUserName:    PChar;          // User name (required)
    lpProfilePath: PChar;          // Roaming profile path (optional, can be NULL)
    lpDefaultPath: PChar;          // Default user profile path (optional, can be NULL)
    lpServerName:  PChar;          // Validating domain controller name in netbios format (optional, can be NULL but group NT4 style policy won't be applied)
    lpPolicyPath:  PChar;          // Path to the NT4 style policy file (optional, can be NULL)
    hProfile:      THandle;        // Filled in by the function.  Registry key handle open to the root.
  end;

  PProfileInfoW = ^TProfileInfoW;
  TProfileInfoW = record
    dwSize:        DWORD;          // Set to sizeof(PROFILEINFO) before calling
    dwFlags:       DWORD;          // See PI_ flags defined in userenv.h
    lpUserName:    PWideChar;      // User name (required)
    lpProfilePath: PWideChar;      // Roaming profile path (optional, can be NULL)
    lpDefaultPath: PWideChar;      // Default user profile path (optional, can be NULL)
    lpServerName:  PWideChar;      // Validating domain controller name in netbios format (optional, can be NULL but group NT4 style policy won't be applied)
    lpPolicyPath:  PWideChar;      // Path to the NT4 style policy file (optional, can be NULL)
    hProfile:      THandle;        // Filled in by the function.  Registry key handle open to the root.
  end;
  TProfileInfo = TProfileInfoA;
  PProfileInfo = ^TProfileInfo;

const
  PI_NOUI        = $00000001;      // Prevents displaying of messages
  PI_APPLYPOLICY = $00000002;      // Apply NT4 style policy
//function LoadUserProfile
// Note:  The caller of this function must have admin privileges on the machine.
//
//        Upon successful return, the hProfile member of the PROFILEINFO
//        structure is a registry key handle opened to the root
//        of the user's hive.  It has been opened with full access. If
//        you need to read or write to the user's registry file, use
//        this key instead of HKEY_CURRENT_USER.  Do not close this
//        handle.  Instead pass it to UnloadUserProfile to close
//        the handle.
//
//=============================================================================
function LoadUserProfile(hToken: THandle; pProfInfo: PProfileInfo): BOOL; stdcall;
function LoadUserProfileA(hToken: THandle; pProfInfo: PProfileInfoA): BOOL; stdcall;
function LoadUserProfileW(hToken: THandle; pProfInfo: PProfileInfoW): BOOL; stdcall;

//=============================================================================
//
// UnloadUserProfile
//
// Unloads a user's profile that was loaded by LoadUserProfile()
//
// hToken        -  Token for the user, returned from LogonUser()
// hProfile      -  hProfile member of the PROFILEINFO structure
//
// Returns:  TRUE if successful
//           FALSE if not.  Call GetLastError() for more details
//
// Note:     The caller of this function must have admin privileges on the machine.
//
//=============================================================================

function UnloadUserProfile(hToken: THandle; hProfile: THandle): BOOL; stdcall;

implementation

const
{$IFDEF MSWINDOWS}
  userenv_dll  = 'userenv.dll';
{$ENDIF}

function LoadUserProfile;  external userenv_dll name 'LoadUserProfileA';
function LoadUserProfileA; external userenv_dll name 'LoadUserProfileA';
function LoadUserProfileW; external userenv_dll name 'LoadUserProfileW';
function UnloadUserProfile;  external userenv_dll name 'UnloadUserProfile';

end.


