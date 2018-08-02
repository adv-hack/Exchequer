unit NetworkUtil;

interface

// Returns the domain for the logged in user
Function GetNetworkDomain : ShortString;

implementation

Uses Windows;

// Windows API stuff for getting the domain - http://www.delphi3000.com/articles/article_3618.asp

Const
   NERR_Success = 0;

function NetApiBufferAllocate (ByteCount: DWORD; var Buffer: Pointer): DWORD; stdcall; external 'netapi32.dll';
function NetGetDCName(servername: LPCWSTR; domainname: LPCWSTR;
  bufptr: Pointer): DWORD; stdcall; external 'netapi32.dll';
function NetApiBufferFree (Buffer: Pointer): DWORD ; stdcall; external 'netapi32.dll';
Function NetWkstaGetInfo
        (ServerName : LPWSTR;
         Level      : DWORD;
         BufPtr     : Pointer) : Longint; Stdcall;
                external 'netapi32.dll' Name 'NetWkstaGetInfo';

function NetUserEnum(servername: LPCWSTR; level: DWORD; filter: DWORD;
  var bufptr: Pointer; prefmaxlen: DWORD; var entriesread: DWORD;
  var totalentries: DWORD; resume_handle: PDWORD): DWORD; stdcall; external 'netapi32.dll';

type
  WKSTA_INFO_100   = Record
      wki100_platform_id  : DWORD;
      wki100_computername : LPWSTR;
      wki100_langroup     : LPWSTR;
      wki100_ver_major    : DWORD;
      wki100_ver_minor    : DWORD;
                            End;

   LPWKSTA_INFO_100 = ^WKSTA_INFO_100;

  _USER_INFO_0  = record
    usri0_name: LPWSTR;
  end;
  TUserInfo0 = _USER_INFO_0;

//-------------------------------------------------------------------------

function GetNetParam(AParam : integer) : string;
Var
  PBuf  : LPWKSTA_INFO_100;
  Res   : LongInt;
begin
  result := '';
  Res := NetWkstaGetInfo (Nil, 100, @PBuf);
  If Res = NERR_Success Then
    begin
      case AParam of
       0:   Result := string(PBuf^.wki100_computername);
       1:   Result := string(PBuf^.wki100_langroup);
      end;
    end;
end;

//-------------------------------------------------------------------------

// Returns the domain for the logged in user
Function GetNetworkDomain : ShortString;
Begin // GetNetworkDomain
  Result := GetNetParam(1);
End; // GetNetworkDomain

//-------------------------------------------------------------------------

end.
