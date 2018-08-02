unit dial;

interface

uses Windows;

function LoadInet : Boolean;
procedure FreeInet;
function DialInet : Boolean;
procedure HangUp;



var
  _InternetAutodial : function(dwFlags: DWORD; dwReserved: DWORD): BOOL; stdcall;
  _InternetAutodialHangup : function (dwReserved: DWORD): BOOL; stdcall;
  InetLib : THandle;



implementation



function LoadInet : Boolean;
begin
  InetLib := LoadLibrary('Wininet.dll');
  if InetLib <> 0 then
  begin
    _InternetAutodial := GetProcAddress(InetLib, 'InternetAutodial');
    _InternetAutodialHangup := GetProcAddress(InetLib, 'InternetAutodialHangup');

    Result := (@_InternetAutodial <> nil) and (@_InternetAutodialHangup <> nil);

  end
  else
    Result := False;
end;

procedure FreeInet;
begin
  FreeLibrary(InetLib);
end;

function DialInet : Boolean;
begin
  Result := _InternetAutodial(2, 0);
end;

procedure HangUp;
begin
   _InternetAutoDialHangup(0);
end;

end.
 