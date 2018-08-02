unit ecDll;

// in the project (dpr) we have no finalization, so we need a unit in our dll

interface

implementation

uses Windows, SysUtils, ecCrashParam;

// does the crash parameter say that our dll should raise an exception?
initialization
  if CrashParam = '/DllInitialization' then 
    raise Exception.Create('Demo "dll initialization".');
finalization
  if CrashParam = '/DllFinalization' then
    raise Exception.Create('Demo "dll finalization".');
end.
