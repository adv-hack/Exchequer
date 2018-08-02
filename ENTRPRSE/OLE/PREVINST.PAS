unit PrevInst;

{ markd6 12:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{ Entire purpose of this module is to be executed first in the    }
{ series of module Initialization's. It will check for a previous }
{ instance of the OLE server and halt if it finds one.            }

interface

Uses Windows;

Type
  PHWND = ^HWND;

function EnumWndProc (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;

implementation

Uses Dialogs, SysUtils;

{$H-}
Type
  Str255 = String[255];
{$H+}

{ Callback function to identify the window }
function EnumWndProc (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;
var
  ClassName : string;
  Tag       : THandle;
begin
  Result := True;
  SetLength (ClassName, 100);
  GetClassName (Hwnd, PChar (ClassName), Length (ClassName));
  ClassName := PChar (Trim(ClassName));

  If (AnsiCompareText (ClassName, 'TForm_EnterpriseOleServer') = 0) then begin
    Tag := GetWindowLong (Hwnd, GWL_USERDATA);
    If (Tag = 1020) Then Begin
      FoundWnd^ := Hwnd;
      Result := False;
    End; { If }
  End; { If }
end;


Procedure CheckForServer;
Var
  OldHWnd : HWnd;
begin
  OldHwnd := 0;
  EnumWindows (@EnumWndProc, Longint(@OldHwnd));
  If (OldHwnd <> 0) Then Begin
    ShowMessage ('The OLE Server is already running');

    Halt; { Die! }
  End; { If }
End;

Initialization
  CheckForServer;
end.
