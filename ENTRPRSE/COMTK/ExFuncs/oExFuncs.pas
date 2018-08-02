unit oExFuncs;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, ExFuncs_TLB, StdVcl;

type
  TExchequerFunctions = class(TAutoObject, IExchequerFunctions)
  protected
    function exRound(Value: Double; DecPlaces: Integer): Double; safecall;
    { Protected declarations }
  end;

implementation

uses ComServ, EtMiscU;

function TExchequerFunctions.exRound(Value: Double;
  DecPlaces: Integer): Double;
begin
  Result := Round_Up(Value, DecPlaces);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExchequerFunctions, Class_ExchequerFunctions,
    ciMultiInstance, tmApartment);
end.
