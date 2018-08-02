unit oOopFunc;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, ExFuncsOop_TLB, StdVcl;

type
  TExchquerFunctions = class(TAutoObject, IExchquerFunctions)
  protected
    function exRound(Valu: Double; DecPlaces: Integer): Double; safecall;
    { Protected declarations }
  end;

implementation

uses ComServ, EtMiscU;

function TExchquerFunctions.exRound(Valu: Double;
  DecPlaces: Integer): Double;
begin
  Result := Round_Up(Valu, DecPlaces);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExchquerFunctions, Class_ExchquerFunctions,
    ciMultiInstance, tmApartment);
end.
