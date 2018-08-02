unit HookProc;

interface
  function GetWindowID(sHookPoint : string) : integer;
  function GetHandlerID(sHookPoint : string) : integer;

implementation
uses
  CustWinU, SysUtils;

function GetWindowID(sHookPoint : string) : integer;
begin
  Result := EnterpriseBase + StrToIntDef(Copy(sHookPoint, 1, Pos('.',sHookPoint)-1), 0);
end;

function GetHandlerID(sHookPoint : string) : integer;
begin
  Result := StrToIntDef(Copy(sHookPoint, Pos('.',sHookPoint)+1, 255), 0);
end;


end.
 