unit ecCrashParam;

// this unit is probably a bit difficult to understand
// for some of the exception types the program needs to be restarted
// e.g. you can't raise a unit init. exception without restarting the program
// in that case we restart with a parameter indicating the wanted exception type
// however, if madExcept restarts the program from the exception box,
// it starts it with the full command line including all parameters
// to avoid that, we hack the command line after having extracted the parameters
// the application does all the dirty work, the dll calls the application
// for the finalization exceptions we don't restart the program
// for that we just set the crash parameter, again the application does the work

interface

// which crash param do we have?
var CrashParam : pchar = nil;

// set the current crash param
procedure SetCrashParam (value: pchar);

implementation

uses Windows, madStrings;

procedure SetCrashParam(value: pchar);
// set the crash param
var pc1 : pchar;
    ch1 : char;
begin
  pc1 := CrashParam;
  repeat
    ch1 := value^;
    pc1^ := ch1;
    inc(pc1);
    inc(value);
  until ch1 = #0;
end;

procedure InitCrashParam;
var map : dword;
    new : boolean;
begin
  // first create/open a named memory mapped file buffer for the crash param
  map := CreateFileMappingA(dword(-1), nil, PAGE_READWRITE, 0, MAX_PATH + 1,
                            PAnsiChar('madCrashParam' + IntToHexEx(GetCurrentProcessID)));
  // did the named buffer already exist or is it new?
  new := GetLastError = 0;
  // map the buffer into our memory context
  CrashParam := MapViewOfFile(map, FILE_MAP_ALL_ACCESS, 0, 0, 0);
  if new then begin
    // the buffer was new, so let's fill it with the command line parameters
    SetCrashParam(pchar(ParamStr(1)));
    // after that kill the parameters from the command line
    GetCommandLine[Length(ParamStr(0)) + 1] := #0;
  end;
end;

initialization
  InitCrashParam;
end.
