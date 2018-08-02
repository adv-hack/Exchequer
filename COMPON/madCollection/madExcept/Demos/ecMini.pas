unit ecMini;

// this unit has no imports and is listed first in the project's uses clause
// as a result it gets initialized very early and finalized very late
// that's good to put exception trackers to a test

interface

implementation

uses ecCrashParam;

type
  // our own exception class, this way we don't need to import SysUtils
  Exception = class(TObject)
  private
    FMessage : string;
  public
    constructor Create (const msg: string);
    property Message : string read FMessage write FMessage;
  end;

constructor Exception.Create(const msg: string);
begin
  FMessage := msg;
end;

// does the crash parameter say that our mini unit should raise an exception?
initialization
  if CrashParam = '/EarlyUnitInitialization' then
    raise Exception.Create('Demo "early unit initialization".');
finalization
  if CrashParam = '/LateUnitFinalization' then
    raise Exception.Create('Demo "late unit finalization".');
end.
