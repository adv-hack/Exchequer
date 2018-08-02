unit RunFirst;

{ nfrewer440 10:20 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

var
  GUISupportsTrayIcon : boolean;

implementation

uses Windows, ShellAPI;

function CanSupportTrayIcon : boolean;
// Post : Returns true if tray icon support is available i.e. Win 95 type GUI
var
  ShellLib : THandle;
begin
  Result := false;
  ShellLib := LoadLibrary(shell32);
  if ShellLib > HInstance_Error then
  begin
    Result := Assigned(GetProcAddress(ShellLib,'Shell_NotifyIconA'));
    FreeLibrary(ShellLib);
  end;
end; // CanSupportTrayIcon

initialization
  IsLibrary := true;
end.
