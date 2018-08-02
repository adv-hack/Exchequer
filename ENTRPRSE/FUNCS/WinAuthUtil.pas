unit WinAuthUtil;

interface

  function GetWindowDomainName: String;
  function GetWindowUserName(ADomainName: Boolean = False): string;
  function WindowAuthenticate(const AUser, APassword, ADomain: String): Boolean;

implementation

uses Types, SysUtils, Windows;

//------------------------------------------------------------------------------
//function to Get current windows Domain Name
function GetWindowDomainName: String;
var
  lDomainName : array[0..30] of char;
  sDomainName : ShortString;
  lSize : DWORD;
begin
  lSize := 30;
  ExpandEnvironmentStrings(PChar('%USERDOMAIN%'), lDomainName, lSize);
  Result := LDomainName;
end;

//------------------------------------------------------------------------------
//function to Get current  windows user Name
function GetWindowUserName(ADomainName: Boolean = False): string;
const
  cnMaxUserNameLen = 254;
var
  lUserName: string;
  ldwUserNameLen: DWORD;
begin
  ldwUserNameLen := cnMaxUserNameLen - 1;
  SetLength(lUserName, cnMaxUserNameLen);
  GetUserName(PChar(lUserName), ldwUserNameLen);
  SetLength(lUserName, ldwUserNameLen);
  Result := Trim(lUserName);
  if ADomainName then
    Result :=Trim(GetWindowDomainName+ '\' + Result);
end;

//------------------------------------------------------------------------------
//function to validate current user's windows login
function WindowAuthenticate(const AUser, APassword, ADomain: String): Boolean;
var
  Retvar: boolean;
  LHandle: THandle;
begin
  Retvar := LogonUser(PChar(AUser),
                                PChar(ADomain),
                                PChar(APassword),
                                LOGON32_LOGON_NETWORK,
                                LOGON32_PROVIDER_DEFAULT,
                                LHandle);

  if Retvar then
    CloseHandle(LHandle);

  Result := Retvar;
end;

//------------------------------------------------------------------------------

end.
