unit FBITestHarness;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Project1_TLB, StdVcl;

type
  TTFBI_Callback = class(TAutoObject, ITFBI_Callback)
  protected
    { Protected declarations }
  end;

implementation

uses ComServ;

initialization
  TAutoObjectFactory.Create(ComServer, TTFBI_Callback, Class_TFBI_Callback,
    ciMultiInstance, tmApartment);
end.
