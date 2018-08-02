unit oCcyTri;
{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     GlobVar, VarConst, VarRec2U, MiscFunc, oBtrieve,
     BtrvU2, ExBtTh1U, ExceptIntf;

type
  TTriRecFunc = function : TriCurType of Object;

  TCurrencyTriangulation = class(TAutoIntfObjectEx, ICurrencyTriangulation)
  private
    FTriRec : TTriRecFunc;
  protected
    function Get_tcRate: Double; safecall;
    function Get_tcEuro: Byte; safecall;
    function Get_tcInvert: WordBool; safecall;
    function Get_tcFloat: WordBool; safecall;
  public
    Constructor Create(TriRec : TTriRecFunc);
  end;

implementation

uses
  ComServ;

Constructor TCurrencyTriangulation.Create(TriRec : TTriRecFunc);
begin
  inherited Create(ComServer.TypeLib, ICurrencyTriangulation);
  FTriRec := TriRec;
end;

function TCurrencyTriangulation.Get_tcRate: Double;
begin
  Result := FTriRec.TriRates;
end;

function TCurrencyTriangulation.Get_tcEuro: Byte;
begin
  Result := FTriRec.TriEuro;
end;

function TCurrencyTriangulation.Get_tcInvert: WordBool;
begin
  Result := BoolToWordBool(FTriRec.TriInvert);
end;

function TCurrencyTriangulation.Get_tcFloat: WordBool;
begin
  Result := BoolToWordBool(FTriRec.TriFloat);
end;

end.
