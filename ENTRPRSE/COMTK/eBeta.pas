unit eBeta;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, EnterpriseBeta_TLB, StdVcl;

type
  TTest = class(TAutoObject, ITest)
  protected
    { Protected declarations }
  end;

implementation

uses ComServ;

initialization
  TAutoObjectFactory.Create(ComServer, TTest, Class_Test,
    ciMultiInstance, tmApartment);
end.
