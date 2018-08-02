unit zTeleLin;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU;

type
  TCOMTeleSalesLine = class(TAutoIntfObject, ICOMTeleSalesLine)
  private
    FEntSysObj : TEnterpriseSystem;
    FTelesales : TAbsTelesalesLine;

  protected
    { Property methods }
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_telCustCode: WideString; safecall;
    procedure Set_telCustCode(const Value: WideString); safecall;
    function Get_telStockCode: WideString; safecall;
    procedure Set_telStockCode(const Value: WideString); safecall;
    function Get_telRepeatQty: Double; safecall;
    procedure Set_telRepeatQty(Value: Double); safecall;
    function Get_telLastSaleDate: WideString; safecall;
    procedure Set_telLastSaleDate(const Value: WideString); safecall;
    function Get_telDisplayOrder: Integer; safecall;
    procedure Set_telDisplayOrder(Value: Integer); safecall;
    function Get_telLastPrice: Double; safecall;
    procedure Set_telLastPrice(Value: Double); safecall;
    function Get_telLastPriceCurr: Integer; safecall;
    procedure Set_telLastPriceCurr(Value: Integer); safecall;
    function Get_telJobCode: WideString; safecall;
    procedure Set_telJobCode(const Value: WideString); safecall;
    function Get_telJobAnal: WideString; safecall;
    procedure Set_telJobAnal(const Value: WideString); safecall;
    function Get_telLocation: WideString; safecall;
    procedure Set_telLocation(const Value: WideString); safecall;
    function Get_telGLCode: Integer; safecall;
    procedure Set_telGLCode(Value: Integer); safecall;
    function Get_telCostCentre: WideString; safecall;
    procedure Set_telCostCentre(const Value: WideString); safecall;
    function Get_telDepartment: WideString; safecall;
    procedure Set_telDepartment(const Value: WideString); safecall;
    function Get_telQty: Double; safecall;
    procedure Set_telQty(Value: Double); safecall;
    function Get_telNetValue: Double; safecall;
    procedure Set_telNetValue(Value: Double); safecall;
    function Get_telDiscount: Double; safecall;
    procedure Set_telDiscount(Value: Double); safecall;
    function Get_telVATCode: WideString; safecall;
    procedure Set_telVATCode(const Value: WideString); safecall;
    function Get_telCost: Double; safecall;
    procedure Set_telCost(Value: Double); safecall;
    function Get_telDescr(Index: Integer): WideString; safecall;
    procedure Set_telDescr(Index: Integer; const Value: WideString); safecall;
    function Get_telVATAmount: Double; safecall;
    procedure Set_telVATAmount(Value: Double); safecall;
    function Get_telPriceByPack: WordBool; safecall;
    procedure Set_telPriceByPack(Value: WordBool); safecall;
    function Get_telQtyInPack: Double; safecall;
    procedure Set_telQtyInPack(Value: Double); safecall;
    function Get_telQtyMul: Double; safecall;
    procedure Set_telQtyMul(Value: Double); safecall;
    function Get_telDiscFlag: WideString; safecall;
    procedure Set_telDiscFlag(const Value: WideString); safecall;
    function Get_telEntered: WordBool; safecall;
    procedure Set_telEntered(Value: WordBool); safecall;
    function Get_telCalcPack: WordBool; safecall;
    procedure Set_telCalcPack(Value: WordBool); safecall;
    function Get_telShowAsPacks: WordBool; safecall;
    procedure Set_telShowAsPacks(Value: WordBool); safecall;
    function Get_telLineType: Integer; safecall;
    procedure Set_telLineType(Value: Integer); safecall;
    function Get_telPriceMultiplier: Double; safecall;
    procedure Set_telPriceMultiplier(Value: Double); safecall;
    function Get_telInclusiveVATCode: WideString; safecall;
    procedure Set_telInclusiveVATCode(const Value: WideString); safecall;
  public
    Constructor Create;

    Procedure InitTeleLine(EntSysObj : TEnterpriseSystem);
  End; { TCOMTeleSalesLine }


implementation

uses ComServ, CustIntU, ZUtils;

//=========================================================================

constructor TCOMTeleSalesLine.Create;
begin
  Inherited Create (ComServer.TypeLib, ICOMTeleSalesLine);

  FEntSysObj := Nil;
end;

//-------------------------------------------------------------------------

procedure TCOMTeleSalesLine.InitTeleLine(EntSysObj: TEnterpriseSystem);
begin
  FEntSysObj := EntSysObj;
  FTelesales := EntSysObj.Telesales.teSalesLine;
end;

//-------------------------------------------------------------------------


function TCOMTeleSalesLine.Get_AccessRights: TRecordAccessStatus;
begin
  Result := Ord(FTelesales.AccessRights);
end;

//------------------------------

function TCOMTeleSalesLine.Get_telCustCode: WideString;
begin
  Result := FTelesales.telCustCode;
end;

procedure TCOMTeleSalesLine.Set_telCustCode(const Value: WideString);
begin
  FTelesales.telCustCode := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telStockCode: WideString;
begin
  Result := FTelesales.telStockCode;
end;

procedure TCOMTeleSalesLine.Set_telStockCode(const Value: WideString);
begin
  FTelesales.telStockCode := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telRepeatQty: Double;
begin
  Result := FTelesales.telRepeatQty;
end;

procedure TCOMTeleSalesLine.Set_telRepeatQty(Value: Double);
begin
  FTelesales.telRepeatQty := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telLastSaleDate: WideString;
begin
  Result := FTelesales.telLastSaleDate;
end;

procedure TCOMTeleSalesLine.Set_telLastSaleDate(const Value: WideString);
begin
  FTelesales.telLastSaleDate := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telDisplayOrder: Integer;
begin
  Result := FTelesales.telDisplayOrder;
end;

procedure TCOMTeleSalesLine.Set_telDisplayOrder(Value: Integer);
begin
  FTelesales.telDisplayOrder := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telLastPrice: Double;
begin
  Result := FTelesales.telLastPrice;
end;

procedure TCOMTeleSalesLine.Set_telLastPrice(Value: Double);
begin
  FTelesales.telLastPrice := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telLastPriceCurr: Integer;
begin
  Result := FTelesales.telLastPriceCurr;
end;

procedure TCOMTeleSalesLine.Set_telLastPriceCurr(Value: Integer);
begin
  FTelesales.telLastPriceCurr := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telJobCode: WideString;
begin
  Result := FTelesales.telJobCode;
end;

procedure TCOMTeleSalesLine.Set_telJobCode(const Value: WideString);
begin
  FTelesales.telJobCode := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telJobAnal: WideString;
begin
  Result := FTelesales.telJobAnal;
end;

procedure TCOMTeleSalesLine.Set_telJobAnal(const Value: WideString);
begin
  FTelesales.telJobAnal := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telLocation: WideString;
begin
  Result := FTelesales.telLocation;
end;

procedure TCOMTeleSalesLine.Set_telLocation(const Value: WideString);
begin
  FTelesales.telLocation := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telGLCode: Integer;
begin
  Result := FTelesales.telGLCode;
end;

procedure TCOMTeleSalesLine.Set_telGLCode(Value: Integer);
begin
  FTelesales.telGLCode := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telCostCentre: WideString;
begin
  Result := FTelesales.telCostCentre;
end;

procedure TCOMTeleSalesLine.Set_telCostCentre(const Value: WideString);
begin
  FTelesales.telCostCentre := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telDepartment: WideString;
begin
  Result := FTelesales.telDepartment;
end;

procedure TCOMTeleSalesLine.Set_telDepartment(const Value: WideString);
begin
  FTelesales.telDepartment := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telQty: Double;
begin
  Result := FTelesales.telQty;
end;

procedure TCOMTeleSalesLine.Set_telQty(Value: Double);
begin
  FTelesales.telQty := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telNetValue: Double;
begin
  Result := FTelesales.telNetValue;
end;

procedure TCOMTeleSalesLine.Set_telNetValue(Value: Double);
begin
  FTelesales.telNetValue := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telDiscount: Double;
begin
  Result := FTelesales.telDiscount;
end;

procedure TCOMTeleSalesLine.Set_telDiscount(Value: Double);
begin
  FTelesales.telDiscount := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telVATCode: WideString;
begin
  Result := FTelesales.telVATCode;
end;

procedure TCOMTeleSalesLine.Set_telVATCode(const Value: WideString);
begin
  FTelesales.telVATCode := WideStrToChar (Value, ' ');
end;

//------------------------------

function TCOMTeleSalesLine.Get_telCost: Double;
begin
  Result := FTelesales.telCost;
end;

procedure TCOMTeleSalesLine.Set_telCost(Value: Double);
begin
  FTelesales.telCost := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telDescr(Index: Integer): WideString;
begin
  Result := FTelesales.telDescr[Index];
end;

procedure TCOMTeleSalesLine.Set_telDescr(Index: Integer; const Value: WideString);
begin
  FTelesales.telDescr[Index] := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telVATAmount: Double;
begin
  Result := FTelesales.telVATAmount;
end;

procedure TCOMTeleSalesLine.Set_telVATAmount(Value: Double);
begin
  FTelesales.telVATAmount := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telPriceByPack: WordBool;
begin
  Result := FTelesales.telPriceByPack;
end;

procedure TCOMTeleSalesLine.Set_telPriceByPack(Value: WordBool);
begin
  FTelesales.telPriceByPack := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telQtyInPack: Double;
begin
  Result := FTelesales.telQtyInPack;
end;

procedure TCOMTeleSalesLine.Set_telQtyInPack(Value: Double);
begin
  FTelesales.telQtyInPack := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telQtyMul: Double;
begin
  Result := FTelesales.telQtyMul;
end;

procedure TCOMTeleSalesLine.Set_telQtyMul(Value: Double);
begin
  FTelesales.telQtyMul := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telDiscFlag: WideString;
begin
  Result := FTelesales.telDiscFlag;
end;

procedure TCOMTeleSalesLine.Set_telDiscFlag(const Value: WideString);
begin
  FTelesales.telDiscFlag := WideStrToChar (Value, ' ');
end;

//------------------------------

function TCOMTeleSalesLine.Get_telEntered: WordBool;
begin
  Result := FTelesales.telEntered;
end;

procedure TCOMTeleSalesLine.Set_telEntered(Value: WordBool);
begin
  FTelesales.telEntered := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telCalcPack: WordBool;
begin
  Result := FTelesales.telCalcPack;
end;

procedure TCOMTeleSalesLine.Set_telCalcPack(Value: WordBool);
begin
  FTelesales.telCalcPack := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telShowAsPacks: WordBool;
begin
  Result := FTelesales.telShowAsPacks;
end;

procedure TCOMTeleSalesLine.Set_telShowAsPacks(Value: WordBool);
begin
  FTelesales.telShowAsPacks := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telLineType: Integer;
begin
  Result := FTelesales.telLineType;
end;

procedure TCOMTeleSalesLine.Set_telLineType(Value: Integer);
begin
  FTelesales.telLineType := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telPriceMultiplier: Double;
begin
  Result := FTelesales.telPriceMultiplier;
end;

procedure TCOMTeleSalesLine.Set_telPriceMultiplier(Value: Double);
begin
  FTelesales.telPriceMultiplier := Value;
end;

//------------------------------

function TCOMTeleSalesLine.Get_telInclusiveVATCode: WideString;
begin
  Result := FTelesales.telInclusiveVATCode;
end;

procedure TCOMTeleSalesLine.Set_telInclusiveVATCode(const Value: WideString);
begin
  FTelesales.telInclusiveVATCode := WideStrToChar (Value, ' ');
end;

//=========================================================================

end.
