unit DebugU;

interface

Var
  DebugMode : Boolean;

implementation

Uses SysUtils;

Initialization
  DebugMode := FindCmdLineSwitch('DEBUG', SwitchChars, True);
end.
 