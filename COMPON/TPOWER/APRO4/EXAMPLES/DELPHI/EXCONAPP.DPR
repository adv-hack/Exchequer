{***********************************************************}
{*                      ExConApp.PAS                       *}
{*      Copyright (c) TurboPower Software 1997,98          *}
{*                 All rights reserved.                    *}
{***********************************************************}

{**********************Description**************************}
{*This is a simple example that demonstrates how to make a *}
{*32-bit console application implementing a winsock telnet *}
{*application using a Win32 console as the terminal window.*}
{*    Note: This is just a demonstration. A real           *}
{*          application would need to be optimized with    *}
{*          respect to user I/O.                           *}
{***********************************************************}


{$APPTYPE CONSOLE}
program ExConApp;
{$DEFINE UseANSI}
              {Define this to have the app. request ANSI escapes from the host}
                  {Add ANSI.SYS to Windows 95's CONFIG.SYS to use the emulator}

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}
uses
  Windows,
  ooMisc,
  AdPort,
  AdWnPort;

var
  ApdWinsockPort1 : TApdWinsockPort;
  IH : THandle;
  IR : TInputRecord;
  NumberRead : DWORD;

function IsWinNT : Boolean;
var
  Osi : TOSVersionInfo;
begin
  Osi.dwOSVersionInfoSize := sizeof(Osi);
  GetVersionEx(Osi);
  Result := (Osi.dwPlatformID = Ver_Platform_Win32_NT);
end;

procedure TriggerHandler(Msg, wParam : Cardinal; lParam : Longint);
begin
  if Msg = apw_TriggerAvail then
    while wParam > 0 do begin
      write(ApdWinsockPort1.GetChar);
      dec(wParam);
    end;
end;

begin
  if ParamCount <> 1 then begin
    writeln('Use: ExConApp <host name> (eg: ExConApp bbs.turbopower.com)');
    write('Press <CR>');
    readln;
    halt;
  end;
  SetConsoleTitle('ExConApp. Attempting to connect.... Press Ctrl-Break to quit.');
  IH := GetStdHandle(STD_INPUT_HANDLE);
  ApdWinsockPort1 := TApdWinsockPort.Create(nil);
  try
    with ApdWinsockPort1 do begin
      WsAddress := ParamStr(1);
      WsPort := 'telnet';
      DeviceLayer := dlWinsock;
      Open := True;
    end;
    SetConsoleTitle('ExConApp Connected. Press Ctrl-Break to quit.');
    with ApdWinsockPort1 do
      if Open then begin
        Dispatcher.RegisterProcTriggerHandler(TriggerHandler);
        {$IFDEF UseANSI}
        if not IsWinNT then
          PutString(#$1B'[3;1R'#13); {Enable ANSI emulation from the host}
        {$ENDIF}
        repeat
          PeekConsoleInput(IH,IR,1,NumberRead);
          if NumberRead = 0 then
            SafeYield
          else begin
            ReadConsoleInput(IH,IR,1,NumberRead);
            {$IFDEF Delphi4}
            if (IR.EventType = KEY_EVENT) and (IR.Event.KeyEvent.bKeyDown) then
              PutChar(IR.Event.KeyEvent.AsciiChar);
            {$ELSEIF}
            if (IR.EventType = KEY_EVENT) and (IR.KeyEvent.bKeyDown) then
              PutChar(IR.KeyEvent.AsciiChar);
            {$ENDIF}
          end;
        until not Open;
      end;
  finally
    ApdWinsockPort1.Free;
  end;
end.
