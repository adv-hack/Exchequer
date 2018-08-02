unit zStkLoc;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU;

Type
  TCOMStockLocation = class(TAutoIntfObject, ICOMStockLocation)
  private
    FEntSysObj : TEnterpriseSystem;
    FStkLoc    : TAbsStockLocation;
  protected
    { Property methods }
    function Get_AccessRights: TRecordAccessStatus; safecall;

    function Get_slStockCode: WideString; safecall;
    procedure Set_slStockCode(const Value: WideString); safecall;
    function Get_slLocationCode: WideString; safecall;
    procedure Set_slLocationCode(const Value: WideString); safecall;
    function Get_slQtyInStock: Double; safecall;
    procedure Set_slQtyInStock(Value: Double); safecall;
    function Get_slQtyOnOrder: Double; safecall;
    procedure Set_slQtyOnOrder(Value: Double); safecall;
    function Get_slQtyAllocated: Double; safecall;
    procedure Set_slQtyAllocated(Value: Double); safecall;
    function Get_slQtyPicked: Double; safecall;
    procedure Set_slQtyPicked(Value: Double); safecall;
    function Get_slQtyMin: Double; safecall;
    procedure Set_slQtyMin(Value: Double); safecall;
    function Get_slQtyMax: Double; safecall;
    procedure Set_slQtyMax(Value: Double); safecall;
    function Get_slQtyFreeze: Double; safecall;
    procedure Set_slQtyFreeze(Value: Double); safecall;
    function Get_slReorderQty: Double; safecall;
    procedure Set_slReorderQty(Value: Double); safecall;
    function Get_slReorderCur: TCurrencyType; safecall;
    procedure Set_slReorderCur(Value: TCurrencyType); safecall;
    function Get_slReorderPrice: Double; safecall;
    procedure Set_slReorderPrice(Value: Double); safecall;
    function Get_slReorderDate: WideString; safecall;
    procedure Set_slReorderDate(const Value: WideString); safecall;
    function Get_slReorderCostCentre: WideString; safecall;
    procedure Set_slReorderCostCentre(const Value: WideString); safecall;
    function Get_slReorderDepartment: WideString; safecall;
    procedure Set_slReorderDepartment(const Value: WideString); safecall;
    function Get_slCostCentre: WideString; safecall;
    procedure Set_slCostCentre(const Value: WideString); safecall;
    function Get_slDepartment: WideString; safecall;
    procedure Set_slDepartment(const Value: WideString); safecall;
    function Get_slBinLocation: WideString; safecall;
    procedure Set_slBinLocation(const Value: WideString); safecall;
    function Get_slCostPriceCur: TCurrencyType; safecall;
    procedure Set_slCostPriceCur(Value: TCurrencyType); safecall;
    function Get_slCostPrice: Double; safecall;
    procedure Set_slCostPrice(Value: Double); safecall;
    function Get_slBelowMinLevel: WordBool; safecall;
    procedure Set_slBelowMinLevel(Value: WordBool); safecall;
    function Get_slSuppTemp: WideString; safecall;
    procedure Set_slSuppTemp(const Value: WideString); safecall;
    function Get_slSupplier: WideString; safecall;
    procedure Set_slSupplier(const Value: WideString); safecall;
    function Get_slLastUsed: WideString; safecall;
    procedure Set_slLastUsed(const Value: WideString); safecall;
    function Get_slQtyPosted: Double; safecall;
    procedure Set_slQtyPosted(Value: Double); safecall;
    function Get_slQtyStockTake: Double; safecall;
    procedure Set_slQtyStockTake(Value: Double); safecall;
    function Get_slTimeChange: WideString; safecall;
    procedure Set_slTimeChange(const Value: WideString); safecall;
    function Get_slSalesGL: Integer; safecall;
    procedure Set_slSalesGL(Value: Integer); safecall;
    function Get_slCostOfSalesGL: Integer; safecall;
    procedure Set_slCostOfSalesGL(Value: Integer); safecall;
    function Get_slPandLGL: Integer; safecall;
    procedure Set_slPandLGL(Value: Integer); safecall;
    function Get_slBalSheetGL: Integer; safecall;
    procedure Set_slBalSheetGL(Value: Integer); safecall;
    function Get_slWIPGL: Integer; safecall;
    procedure Set_slWIPGL(Value: Integer); safecall;
    function Get_slSaleBandsCur(const Index: WideString): TCurrencyType; safecall;
    procedure Set_slSaleBandsCur(const Index: WideString; Value: TCurrencyType); safecall;
    function Get_slSaleBandsPrice(const Index: WideString): Double; safecall;
    procedure Set_slSaleBandsPrice(const Index: WideString; Value: Double); safecall;
    function Get_slQtyFree: Double; safecall;
    function Get_slPurchaseReturnGL: Integer; safecall;
    procedure Set_slPurchaseReturnGL(Value: Integer); safecall;
    function Get_slPurchaseReturnQty: Double; safecall;
    procedure Set_slPurchaseReturnQty(Value: Double); safecall;
    function Get_slManufacturerWarrantyLength: Integer; safecall;
    procedure Set_slManufacturerWarrantyLength(Value: Integer); safecall;
    function Get_slManufacturerWarrantyUnits: Enterprise_TLB.TStockWarrantyUnits; safecall;
    procedure Set_slManufacturerWarrantyUnits(Value: Enterprise_TLB.TStockWarrantyUnits); safecall;
    function Get_slRestockCharge: Double; safecall;
    procedure Set_slRestockCharge(Value: Double); safecall;
    function Get_slSalesReturnGL: Integer; safecall;
    procedure Set_slSalesReturnGL(Value: Integer); safecall;
    function Get_slSalesReturnQty: Double; safecall;
    procedure Set_slSalesReturnQty(Value: Double); safecall;
    function Get_slSalesWarrantyLength: Integer; safecall;
    procedure Set_slSalesWarrantyLength(Value: Integer); safecall;
    function Get_slSalesWarrantyUnits: Enterprise_TLB.TStockWarrantyUnits; safecall;
    procedure Set_slSalesWarrantyUnits(Value: Enterprise_TLB.TStockWarrantyUnits); safecall;
  public
    Constructor Create;
    Destructor Destroy; Override;

    procedure InitStockLocation(EntSysObj: TEnterpriseSystem);
  End; // TCOMTCOMStockLocationLocation

implementation

uses ComServ, CustIntU, ZUtils;

//=========================================================================

Constructor TCOMStockLocation.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMStockLocation);

  FEntSysObj := Nil;
End; { Create }

//------------------------------

destructor TCOMStockLocation.Destroy;
begin
  FEntSysObj := NIL;

  inherited;
end;

//-------------------------------------------------------------------------

procedure TCOMStockLocation.InitStockLocation(EntSysObj: TEnterpriseSystem);
begin
  FEntSysObj := EntSysObj;
  FStkLoc  := FEntSysObj.StockLocation;
end;

//-------------------------------------------------------------------------

function TCOMStockLocation.Get_AccessRights: TRecordAccessStatus;
begin
  Result := Ord(FStkLoc.AccessRights);
end;

//-------------------------------------------------------------------------

function TCOMStockLocation.Get_slStockCode: WideString;
begin
  Result := FStkLoc.slStockCode;
end;
procedure TCOMStockLocation.Set_slStockCode(const Value: WideString);
begin
  FStkLoc.slStockCode := Value;
end;

//------------------------------

function TCOMStockLocation.Get_slLocationCode: WideString;
begin
  Result := FStkLoc.slLocationCode;
end;
procedure TCOMStockLocation.Set_slLocationCode(const Value: WideString);
begin
  FStkLoc.slLocationCode := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slQtyInStock: Double;
begin
  Result := FStkLoc.slQtyInStock;
end;
procedure TCOMStockLocation.Set_slQtyInStock(Value: Double);
begin
  FStkLoc.slQtyInStock := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slQtyOnOrder: Double;
begin
  Result := FStkLoc.slQtyOnOrder;
end;
procedure TCOMStockLocation.Set_slQtyOnOrder(Value: Double);
begin
  FStkLoc.slQtyOnOrder := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slQtyAllocated: Double;
begin
  Result := FStkLoc.slQtyAllocated;
end;
procedure TCOMStockLocation.Set_slQtyAllocated(Value: Double);
begin
  FStkLoc.slQtyAllocated := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slQtyPicked: Double;
begin
  Result := FStkLoc.slQtyPicked;
end;
procedure TCOMStockLocation.Set_slQtyPicked(Value: Double);
begin
  FStkLoc.slQtyPicked := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slQtyMin: Double;
begin
  Result := FStkLoc.slQtyMin;
end;
procedure TCOMStockLocation.Set_slQtyMin(Value: Double);
begin
  FStkLoc.slQtyMin := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slQtyMax: Double;
begin
  Result := FStkLoc.slQtyMax;
end;
procedure TCOMStockLocation.Set_slQtyMax(Value: Double);
begin
  FStkLoc.slQtyMax := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slQtyFreeze: Double;
begin
  Result := FStkLoc.slQtyFreeze;
end;
procedure TCOMStockLocation.Set_slQtyFreeze(Value: Double);
begin
  FStkLoc.slQtyFreeze := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slReorderQty: Double;
begin
  Result := FStkLoc.slReorderQty;
end;
procedure TCOMStockLocation.Set_slReorderQty(Value: Double);
begin
  FStkLoc.slReorderQty := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slReorderCur: TCurrencyType;
begin
  Result := FStkLoc.slReorderCur;
end;
procedure TCOMStockLocation.Set_slReorderCur(Value: TCurrencyType);
begin
  FStkLoc.slReorderCur := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slReorderPrice: Double;
begin
  Result := FStkLoc.slReorderPrice;
end;
procedure TCOMStockLocation.Set_slReorderPrice(Value: Double);
begin
  FStkLoc.slReorderPrice := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slReorderDate: WideString;
begin
  Result := FStkLoc.slReorderDate;
end;
procedure TCOMStockLocation.Set_slReorderDate(const Value: WideString);
begin
  FStkLoc.slReorderDate := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slReorderCostCentre: WideString;
begin
  Result := FStkLoc.slReorderCostCentre;
end;
procedure TCOMStockLocation.Set_slReorderCostCentre(const Value: WideString);
begin
  FStkLoc.slReorderCostCentre := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slReorderDepartment: WideString;
begin
  Result := FStkLoc.slReorderDepartment;
end;
procedure TCOMStockLocation.Set_slReorderDepartment(const Value: WideString);
begin
  FStkLoc.slReorderDepartment := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slCostCentre: WideString;
begin
  Result := FStkLoc.slCostCentre;
end;
procedure TCOMStockLocation.Set_slCostCentre(const Value: WideString);
begin
  FStkLoc.slCostCentre := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slDepartment: WideString;
begin
  Result := FStkLoc.slDepartment;
end;
procedure TCOMStockLocation.Set_slDepartment(const Value: WideString);
begin
  FStkLoc.slDepartment := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slBinLocation: WideString;
begin
  Result := FStkLoc.slBinLocation;
end;
procedure TCOMStockLocation.Set_slBinLocation(const Value: WideString);
begin
  FStkLoc.slBinLocation := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slCostPriceCur: TCurrencyType;
begin
  Result := FStkLoc.slCostPriceCur;
end;
procedure TCOMStockLocation.Set_slCostPriceCur(Value: TCurrencyType);
begin
  FStkLoc.slCostPriceCur := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slCostPrice: Double;
begin
  Result := FStkLoc.slCostPrice;
end;
procedure TCOMStockLocation.Set_slCostPrice(Value: Double);
begin
  FStkLoc.slCostPrice := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slBelowMinLevel: WordBool;
begin
  Result := FStkLoc.slBelowMinLevel;
end;
procedure TCOMStockLocation.Set_slBelowMinLevel(Value: WordBool);
begin
  FStkLoc.slBelowMinLevel := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slSuppTemp: WideString;
begin
  Result := FStkLoc.slSuppTemp;
end;
procedure TCOMStockLocation.Set_slSuppTemp(const Value: WideString);
begin
  FStkLoc.slSuppTemp := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slSupplier: WideString;
begin
  Result := FStkLoc.slSupplier;
end;
procedure TCOMStockLocation.Set_slSupplier(const Value: WideString);
begin
  FStkLoc.slSupplier := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slLastUsed: WideString;
begin
  Result := FStkLoc.slLastUsed;
end;
procedure TCOMStockLocation.Set_slLastUsed(const Value: WideString);
begin
  FStkLoc.slLastUsed := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slQtyPosted: Double;
begin
  Result := FStkLoc.slQtyPosted;
end;
procedure TCOMStockLocation.Set_slQtyPosted(Value: Double);
begin
  FStkLoc.slQtyPosted := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slQtyStockTake: Double;
begin
  Result := FStkLoc.slQtyStockTake;
end;
procedure TCOMStockLocation.Set_slQtyStockTake(Value: Double);
begin
  FStkLoc.slQtyStockTake := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slTimeChange: WideString;
begin
  Result := FStkLoc.slTimeChange;
end;
procedure TCOMStockLocation.Set_slTimeChange(const Value: WideString);
begin
  FStkLoc.slTimeChange := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slSalesGL: Integer;
begin
  Result := FStkLoc.slSalesGL;
end;
procedure TCOMStockLocation.Set_slSalesGL(Value: Integer);
begin
  FStkLoc.slSalesGL := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slCostOfSalesGL: Integer;
begin
  Result := FStkLoc.slCostOfSalesGL;
end;
procedure TCOMStockLocation.Set_slCostOfSalesGL(Value: Integer);
begin
  FStkLoc.slCostOfSalesGL := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slPandLGL: Integer;
begin
  Result := FStkLoc.slPandLGL;
end;
procedure TCOMStockLocation.Set_slPandLGL(Value: Integer);
begin
  FStkLoc.slPandLGL := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slBalSheetGL: Integer;
begin
  Result := FStkLoc.slBalSheetGL;
end;
procedure TCOMStockLocation.Set_slBalSheetGL(Value: Integer);
begin
  FStkLoc.slBalSheetGL := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slWIPGL: Integer;
begin
  Result := FStkLoc.slWIPGL;
end;
procedure TCOMStockLocation.Set_slWIPGL(Value: Integer);
begin
  FStkLoc.slWIPGL := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slSaleBandsCur(const Index: WideString): TCurrencyType;
begin
  Result := FStkLoc.slSaleBandsCur[WideStrToChar (Index, ' ')];
end;
procedure TCOMStockLocation.Set_slSaleBandsCur(const Index: WideString; Value: TCurrencyType);
begin
  FStkLoc.slSaleBandsCur[WideStrToChar (Index, ' ')] := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slSaleBandsPrice(const Index: WideString): Double;
begin
  Result := FStkLoc.slSaleBandsPrice[WideStrToChar (Index, ' ')];
end;
procedure TCOMStockLocation.Set_slSaleBandsPrice(const Index: WideString; Value: Double);
begin
  FStkLoc.slSaleBandsPrice[WideStrToChar (Index, ' ')] := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slQtyFree: Double;
begin
  Result := FStkLoc.slQtyFree;
end;

//-----------------------------------

function TCOMStockLocation.Get_slPurchaseReturnGL: Integer;
begin
  Result := FStkLoc.slPurchaseReturnGL;
end;
procedure TCOMStockLocation.Set_slPurchaseReturnGL(Value: Integer);
begin
  FStkLoc.slPurchaseReturnGL := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slPurchaseReturnQty: Double;
begin
  Result := FStkLoc.slPurchaseReturnQty;
end;
procedure TCOMStockLocation.Set_slPurchaseReturnQty(Value: Double);
begin
  FStkLoc.slPurchaseReturnQty := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slManufacturerWarrantyLength: Integer;
begin
  Result := FStkLoc.slManufacturerWarrantyLength;
end;
procedure TCOMStockLocation.Set_slManufacturerWarrantyLength(Value: Integer);
begin
  FStkLoc.slManufacturerWarrantyLength := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slManufacturerWarrantyUnits: Enterprise_TLB.TStockWarrantyUnits;
begin
  Result := Ord(FStkLoc.slManufacturerWarrantyUnits);
end;
procedure TCOMStockLocation.Set_slManufacturerWarrantyUnits(Value: Enterprise_TLB.TStockWarrantyUnits);
begin
  FStkLoc.slManufacturerWarrantyUnits := CustAbsU.TStockWarrantyUnits(Value);
end;

//-----------------------------------

function TCOMStockLocation.Get_slRestockCharge: Double;
begin
  Result := FStkLoc.slRestockCharge;
end;
procedure TCOMStockLocation.Set_slRestockCharge(Value: Double);
begin
  FStkLoc.slRestockCharge := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slSalesReturnGL: Integer;
begin
  Result := FStkLoc.slSalesReturnGL;
end;
procedure TCOMStockLocation.Set_slSalesReturnGL(Value: Integer);
begin
  FStkLoc.slSalesReturnGL := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slSalesReturnQty: Double;
begin
  Result := FStkLoc.slSalesReturnQty;
end;
procedure TCOMStockLocation.Set_slSalesReturnQty(Value: Double);
begin
  FStkLoc.slSalesReturnQty := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slSalesWarrantyLength: Integer;
begin
  Result := FStkLoc.slSalesWarrantyLength;
end;
procedure TCOMStockLocation.Set_slSalesWarrantyLength(Value: Integer);
begin
  FStkLoc.slSalesWarrantyLength := Value;
end;

//-----------------------------------

function TCOMStockLocation.Get_slSalesWarrantyUnits: Enterprise_TLB.TStockWarrantyUnits;
begin
  Result := Ord(FStkLoc.slSalesWarrantyUnits);
end;
procedure TCOMStockLocation.Set_slSalesWarrantyUnits(Value: Enterprise_TLB.TStockWarrantyUnits);
begin
  FStkLoc.slSalesWarrantyUnits := CustAbsU.TStockWarrantyUnits(Value);
end;

//-----------------------------------

end.

