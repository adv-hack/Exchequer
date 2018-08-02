Unit uImpersonator;

Interface

Uses Windows, Classes, SysUtils;

Type

  TProfileInfo = Record
    dwSize: DWORD;
    dwFlags: DWORD;
    lpUserName: PChar;
    lpProfilePath: PChar;
    lpDefaultPath: PChar;
    lpServerName: PChar;
    lpPolicyPath: PChar;
    hProfile: HKEY;
  End;

  TImpersonator = Class
  Private
    fTokenHandle: THandle;
    fImpersonating: boolean;
    fProfileLoaded: boolean;
    fProfileInfo: TProfileInfo;
    Procedure Impersonate;
    Function GetImpersonating: boolean;
    Function GetHKCURootKey: HKEY;
  Public
    Constructor Create(Const domain, user, password: String);
    Constructor CreateLoggedOn; // Impersonate the currently logged on user.

    Destructor Destroy; Override;

    Property Impersonating: boolean Read GetImpersonating;
    Property HKCURootKey: HKEY Read GetHKCURootKey;
    property TokenHandle: THandle read fTokenHandle;
  End;

Const
  PI_NOUI = 1; // Prevents displaying of messages
  PI_APPLYPOLICY = 2; // Apply NT4 style policy

Function LoadUserProfile(hToken: THandle; Var profileInfo:
  TProfileInfo): BOOL; stdcall;
Function UnloadUserProfile(hToken, HKEY: THandle): BOOL; stdcall;
Function GetCurrentUserName: String;
Function OpenProcessHandle(Const process: String): THandle;

Implementation

Uses psapi;

Function LoadUserProfile(hToken: THandle; Var profileInfo:
  TProfileInfo): BOOL; External 'userenv.dll' name 'LoadUserProfileA';
Function UnLoadUserProfile(hToken, HKEY: THandle): BOOL; External
'userenv.dll';

Function OpenProcessHandle(Const process: String): THandle;
Var
  buffer, pid: PDWORD;
  bufLen, cbNeeded: DWORD;
  hp: THandle;
  fileName: Array[0..256] Of char;
  i: Integer;
Begin
  result := 0;
  bufLen := 65536;
  GetMem(buffer, bufLen);
  Try
    If EnumProcesses(buffer, bufLen, cbNeeded) Then
    Begin
      pid := buffer;
      For i := 0 To cbNeeded Div sizeof(DWORD) - 1 Do
      Begin
        hp := OpenProcess(PROCESS_VM_READ Or PROCESS_QUERY_INFORMATION, False,
          pid^);
        If hp <> 0 Then
        Try
          If (GetModuleBaseName(hp, 0, fileName, sizeof(fileName)) > 0) And
            (CompareText(fileName, process) = 0) Then
          Begin
            result := hp;
            break
          End
        Finally
          If result = 0 Then
            CloseHandle(hp)
        End;

        Inc(pid)
      End
    End
  Finally
    FreeMem(buffer)
  End
End;

Function GetExplorerProcessToken: THandle;
Var
  explorerProcessHandle: THandle;
Begin
  explorerProcessHandle := OpenProcessHandle('explorer.exe');
  If explorerProcesshandle <> 0 Then
  Try
    If Not OpenProcessToken(explorerProcessHandle, TOKEN_QUERY Or TOKEN_IMPERSONATE
      Or TOKEN_DUPLICATE, result) Then
      RaiseLastOSError;
  Finally
    CloseHandle(explorerProcessHandle)
  End
  Else
    result := INVALID_HANDLE_VALUE;
End;

Function GetCurrentUserName: String;
Var
  unLen: DWORD;
Begin
  unLen := 512;
  SetLength(result, unLen);
  GetUserName(PChar(result), unLen);
  result := PChar(result);
End;

{ TImpersonator }

Constructor TImpersonator.Create(Const domain, user, password: String);
Begin
(*
  LOGON32_LOGON_INTERACTIVE = 2;
  LOGON32_LOGON_NETWORK = 3;
  LOGON32_LOGON_BATCH = 4;
  LOGON32_LOGON_SERVICE = 5;

*)

  If LogonUser(PChar(user), PChar(domain), PChar(password),
    LOGON32_LOGON_INTERACTIVE or LOGON32_LOGON_NETWORK or LOGON32_LOGON_SERVICE, LOGON32_PROVIDER_DEFAULT, fTokenHandle) Then
    Impersonate;
End;

Procedure TImpersonator.Impersonate;
Var
  userName: String;
Begin
  fImpersonating := ImpersonateLoggedOnUser(fTokenHandle);
  If fImpersonating Then
  Begin
    userName := GetCurrentUserName;

    ZeroMemory(@fProfileInfo, sizeof(fProfileInfo));
    fProfileInfo.dwSize := sizeof(fProfileInfo);
    fProfileInfo.lpUserName := PChar(userName);
    fProfileInfo.dwFlags := PI_APPLYPOLICY;
    fprofileLoaded := LoadUserProfile(fTokenHandle, fProfileInfo);
  End
End;

Constructor TImpersonator.CreateLoggedOn;
Begin
  fTokenHandle := GetExplorerProcessToken;

  If fTokenHandle <> INVALID_HANDLE_VALUE Then
    Impersonate;
End;

Destructor TImpersonator.Destroy;
Begin
  If fProfileLoaded Then
    UnloadUserProfile(fTokenHandle, fProfileInfo.hProfile);

  If fImpersonating Then
    RevertToSelf;

  CloseHandle(fTokenHandle);
End;

Function TImpersonator.GetImpersonating: boolean;
Begin
  result := fImpersonating And fProfileLoaded;
End;

Function TImpersonator.GetHKCURootKey: HKEY;
Begin
  result := fProfileInfo.hProfile
End;

End.

