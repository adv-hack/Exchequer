unit zCcyTri;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU;

type
  TCOMCurrencyTriangulation = class(TAutoIntfObject, ICOMCurrencyTriangulation)
  private
    FCcyTri : TAbsCurrencyTriangulation;
  protected
    { Property methods }
    function Get_tcRate: Double; safecall;
    procedure Set_tcRate(Value: Double); safecall;
    function Get_tcEuro: Integer; safecall;
    procedure Set_tcEuro(Value: Integer); safecall;
    function Get_tcInvert: WordBool; safecall;
    procedure Set_tcInvert(Value: WordBool); safecall;
    function Get_tcFloat: WordBool; safecall;
    procedure Set_tcFloat(Value: WordBool); safecall;
  public
    Constructor Create;
    procedure InitCcyTri(CcyTri: TAbsCurrencyTriangulation);
  End; { TCOMCurrencyTriangulation }

implementation

uses ComServ, CustIntU, ZUtils;

//=========================================================================

Constructor TCOMCurrencyTriangulation.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMCurrencyTriangulation);

  FCcyTri := Nil;
End; { Create }

//-------------------------------------------------------------------------

procedure TCOMCurrencyTriangulation.InitCcyTri(CcyTri: TAbsCurrencyTriangulation);
begin
  FCcyTri := CcyTri;
end;

//-------------------------------------------------------------------------

function TCOMCurrencyTriangulation.Get_tcRate: Double;
begin
  Result := FCcyTri.tcRate;
end;

procedure TCOMCurrencyTriangulation.Set_tcRate(Value: Double);
begin
  FCcyTri.tcRate := Value;
end;

//------------------------------

function TCOMCurrencyTriangulation.Get_tcEuro: Integer;
begin
  Result := FCcyTri.tcEuro;
end;

procedure TCOMCurrencyTriangulation.Set_tcEuro(Value: Integer);
begin
  FCcyTri.tcEuro := Value;
end;

//------------------------------

function TCOMCurrencyTriangulation.Get_tcInvert: WordBool;
begin
  Result := FCcyTri.tcInvert;
end;

procedure TCOMCurrencyTriangulation.Set_tcInvert(Value: WordBool);
begin
  FCcyTri.tcInvert := Value;
end;

//------------------------------

function TCOMCurrencyTriangulation.Get_tcFloat: WordBool;
begin
  Result := FCcyTri.tcFloat;
end;

procedure TCOMCurrencyTriangulation.Set_tcFloat(Value: WordBool);
begin
  FCcyTri.tcFloat := Value;
end;

//=========================================================================

end.
