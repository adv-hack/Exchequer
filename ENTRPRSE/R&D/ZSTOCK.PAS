unit ZStock;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU;

type
  TCOMStock = class(TAutoIntfObject, ICOMStock, ICOMStock2, ICOMStock3, ICOMStock4, ICOMStock5, ICOMStock6)
  private
    FEntSysObj : TEnterpriseSystem;
  protected
    function  Get_AccessRights: TRecordAccessStatus; safecall;
    function  Get_DataChanged: WordBool; safecall;
    function  Get_stCode: WideString; safecall;
    procedure Set_stCode(const Value: WideString); safecall;
    function  Get_stDesc(Index: Integer): WideString; safecall;
    procedure Set_stDesc(Index: Integer; const Value: WideString); safecall;
    function  Get_stAltCode: WideString; safecall;
    procedure Set_stAltCode(const Value: WideString); safecall;
    function  Get_stSuppTemp: WideString; safecall;
    procedure Set_stSuppTemp(const Value: WideString); safecall;
    function  Get_stSalesGL: Integer; safecall;
    procedure Set_stSalesGL(Value: Integer); safecall;
    function  Get_stCOSGL: Integer; safecall;
    procedure Set_stCOSGL(Value: Integer); safecall;
    function  Get_stPandLGL: Integer; safecall;
    procedure Set_stPandLGL(Value: Integer); safecall;
    function  Get_stBalSheetGL: Integer; safecall;
    procedure Set_stBalSheetGL(Value: Integer); safecall;
    function  Get_stWIPGL: Integer; safecall;
    procedure Set_stWIPGL(Value: Integer); safecall;
    function  Get_stReOrderFlag: WordBool; safecall;
    procedure Set_stReOrderFlag(Value: WordBool); safecall;
    function  Get_stMinFlg: WordBool; safecall;
    procedure Set_stMinFlg(Value: WordBool); safecall;
    function  Get_stStockFolio: Integer; safecall;
    procedure Set_stStockFolio(Value: Integer); safecall;
    function  Get_stStockCat: WideString; safecall;
    procedure Set_stStockCat(const Value: WideString); safecall;
    function  Get_stStockType: WideString; safecall;
    procedure Set_stStockType(const Value: WideString); safecall;
    function  Get_stUnitOfStock: WideString; safecall;
    procedure Set_stUnitOfStock(const Value: WideString); safecall;
    function  Get_stUnitOfSale: WideString; safecall;
    procedure Set_stUnitOfSale(const Value: WideString); safecall;
    function  Get_stUnitOfPurch: WideString; safecall;
    procedure Set_stUnitOfPurch(const Value: WideString); safecall;
    function  Get_stCostPriceCur: TCurrencyType; safecall;
    procedure Set_stCostPriceCur(Value: TCurrencyType); safecall;
    function  Get_stCostPrice: Double; safecall;
    procedure Set_stCostPrice(Value: Double); safecall;
    function  Get_stSalesUnits: Double; safecall;
    procedure Set_stSalesUnits(Value: Double); safecall;
    function  Get_stPurchUnits: Double; safecall;
    procedure Set_stPurchUnits(Value: Double); safecall;
    function  Get_stVATCode: WideString; safecall;
    procedure Set_stVATCode(const Value: WideString); safecall;
    function  Get_stCostCentre: WideString; safecall;
    procedure Set_stCostCentre(const Value: WideString); safecall;
    function  Get_stDepartment: WideString; safecall;
    procedure Set_stDepartment(const Value: WideString); safecall;
    function  Get_stQtyInStock: Double; safecall;
    procedure Set_stQtyInStock(Value: Double); safecall;
    function  Get_stQtyPosted: Double; safecall;
    procedure Set_stQtyPosted(Value: Double); safecall;
    function  Get_stQtyAllocated: Double; safecall;
    procedure Set_stQtyAllocated(Value: Double); safecall;
    function  Get_stQtyOnOrder: Double; safecall;
    procedure Set_stQtyOnOrder(Value: Double); safecall;
    function  Get_stQtyMin: Double; safecall;
    procedure Set_stQtyMin(Value: Double); safecall;
    function  Get_stQtyMax: Double; safecall;
    procedure Set_stQtyMax(Value: Double); safecall;
    function  Get_stReOrderQty: Double; safecall;
    procedure Set_stReOrderQty(Value: Double); safecall;
    function  Get_stKitOnPurch: WordBool; safecall;
    procedure Set_stKitOnPurch(Value: WordBool); safecall;
    function  Get_stShowAsKit: WordBool; safecall;
    procedure Set_stShowAsKit(Value: WordBool); safecall;
    function  Get_stCommodCode: WideString; safecall;
    procedure Set_stCommodCode(const Value: WideString); safecall;
    function  Get_stSaleUnWeight: Double; safecall;
    procedure Set_stSaleUnWeight(Value: Double); safecall;
    function  Get_stPurchUnWeight: Double; safecall;
    procedure Set_stPurchUnWeight(Value: Double); safecall;
    function  Get_stSSDUnit: WideString; safecall;
    procedure Set_stSSDUnit(const Value: WideString); safecall;
    function  Get_stSSDSalesUnit: Double; safecall;
    procedure Set_stSSDSalesUnit(Value: Double); safecall;
    function  Get_stBinLocation: WideString; safecall;
    procedure Set_stBinLocation(const Value: WideString); safecall;
    function  Get_stStkFlg: WordBool; safecall;
    procedure Set_stStkFlg(Value: WordBool); safecall;
    function  Get_stCovPr: Smallint; safecall;
    procedure Set_stCovPr(Value: Smallint); safecall;
    function  Get_stCovPrUnit: WideString; safecall;
    procedure Set_stCovPrUnit(const Value: WideString); safecall;
    function  Get_stCovMinPr: Smallint; safecall;
    procedure Set_stCovMinPr(Value: Smallint); safecall;
    function  Get_stCovMinUnit: WideString; safecall;
    procedure Set_stCovMinUnit(const Value: WideString); safecall;
    function  Get_stSupplier: WideString; safecall;
    procedure Set_stSupplier(const Value: WideString); safecall;
    function  Get_stQtyFreeze: Double; safecall;
    procedure Set_stQtyFreeze(Value: Double); safecall;
    function  Get_stCovSold: Double; safecall;
    procedure Set_stCovSold(Value: Double); safecall;
    function  Get_stUseCover: WordBool; safecall;
    procedure Set_stUseCover(Value: WordBool); safecall;
    function  Get_stCovMaxPr: Smallint; safecall;
    procedure Set_stCovMaxPr(Value: Smallint); safecall;
    function  Get_stCovMaxUnit: WideString; safecall;
    procedure Set_stCovMaxUnit(const Value: WideString); safecall;
    function  Get_stReOrderCur: Smallint; safecall;
    procedure Set_stReOrderCur(Value: Smallint); safecall;
    function  Get_stReOrderPrice: Double; safecall;
    procedure Set_stReOrderPrice(Value: Double); safecall;
    function  Get_stReOrderDate: WideString; safecall;
    procedure Set_stReOrderDate(const Value: WideString); safecall;
    function  Get_stQtyTake: Double; safecall;
    procedure Set_stQtyTake(Value: Double); safecall;
    function  Get_stStkValType: WideString; safecall;
    procedure Set_stStkValType(const Value: WideString); safecall;
    function  Get_stQtyPicked: Double; safecall;
    procedure Set_stQtyPicked(Value: Double); safecall;
    function  Get_stLastUsed: WideString; safecall;
    procedure Set_stLastUsed(const Value: WideString); safecall;
    function  Get_stCalcPack: WordBool; safecall;
    procedure Set_stCalcPack(Value: WordBool); safecall;
    function  Get_stJobAnal: WideString; safecall;
    procedure Set_stJobAnal(const Value: WideString); safecall;
    function  Get_stStkUser1: WideString; safecall;
    procedure Set_stStkUser1(const Value: WideString); safecall;
    function  Get_stStkUser2: WideString; safecall;
    procedure Set_stStkUser2(const Value: WideString); safecall;
    function  Get_stBarCode: WideString; safecall;
    procedure Set_stBarCode(const Value: WideString); safecall;
    function  Get_stROCostCentre: WideString; safecall;
    procedure Set_stROCostCentre(const Value: WideString); safecall;
    function  Get_stRODepartment: WideString; safecall;
    procedure Set_stRODepartment(const Value: WideString); safecall;
    function  Get_stLocation: WideString; safecall;
    procedure Set_stLocation(const Value: WideString); safecall;
    function  Get_stPricePack: WordBool; safecall;
    procedure Set_stPricePack(Value: WordBool); safecall;
    function  Get_stDPackQty: WordBool; safecall;
    procedure Set_stDPackQty(Value: WordBool); safecall;
    function  Get_stKitPrice: WordBool; safecall;
    procedure Set_stKitPrice(Value: WordBool); safecall;
    function  Get_stStkUser3: WideString; safecall;
    procedure Set_stStkUser3(const Value: WideString); safecall;
    function  Get_stStkUser4: WideString; safecall;
    procedure Set_stStkUser4(const Value: WideString); safecall;
    function  Get_stSerNoWAvg: Smallint; safecall;
    procedure Set_stSerNoWAvg(Value: Smallint); safecall;
    function  Get_stStkSizeCol: Smallint; safecall;
    function  Get_stSSDDUplift: Double; safecall;
    procedure Set_stSSDDUplift(Value: Double); safecall;
    function  Get_stSSDCountry: WideString; safecall;
    procedure Set_stSSDCountry(const Value: WideString); safecall;
    function  Get_stTimeChange: WideString; safecall;
    function  Get_stSVATIncFlg: WideString; safecall;
    procedure Set_stSVATIncFlg(const Value: WideString); safecall;
    function  Get_stSSDAUpLift: Double; safecall;
    procedure Set_stSSDAUpLift(Value: Double); safecall;
    function  Get_stLastOpo: WideString; safecall;
    procedure Set_stLastOpo(const Value: WideString); safecall;
    function  Get_stImageFile: WideString; safecall;
    procedure Set_stImageFile(const Value: WideString); safecall;
    function  Get_stSaleBandsCur(const Index: WideString): TCurrencyType; safecall;
    procedure Set_stSaleBandsCur(const Index: WideString; Value: TCurrencyType); safecall;
    function  Get_stSaleBandsPrice(const Index: WideString): Double; safecall;
    procedure Set_stSaleBandsPrice(const Index: WideString; Value: Double); safecall;

    // ICOMStock2 properties
    function Get_stUseForEbus: WordBool; safecall;
    procedure Set_stUseForEbus(Value: WordBool); safecall;
    function Get_stWebLiveCatalog: WideString; safecall;
    procedure Set_stWebLiveCatalog(const Value: WideString); safecall;
    function Get_stWebPrevCatalog: WideString; safecall;
    procedure Set_stWebPrevCatalog(const Value: WideString); safecall;
    function Get_stWOPROLeadTime: Integer; safecall;
    procedure Set_stWOPROLeadTime(Value: Integer); safecall;
    function Get_stWOPAssemblyHours: Integer; safecall;
    procedure Set_stWOPAssemblyHours(Value: Integer); safecall;
    function Get_stWOPAssemblyMins: Integer; safecall;
    procedure Set_stWOPAssemblyMins(Value: Integer); safecall;
    function Get_stWOPAutoCalcTime: WordBool; safecall;
    procedure Set_stWOPAutoCalcTime(Value: WordBool); safecall;
    function Get_stWOPMinEconBuild: Double; safecall;
    procedure Set_stWOPMinEconBuild(Value: Double); safecall;
    function Get_stWOPIssuedWIPGL: Integer; safecall;
    procedure Set_stWOPIssuedWIPGL(Value: Integer); safecall;
    function Get_stQtyAllocWOR: Double; safecall;
    procedure Set_stQtyAllocWOR(Value: Double); safecall;
    function Get_stQtyIssuedWOR: Double; safecall;
    procedure Set_stQtyIssuedWOR(Value: Double); safecall;
    function Get_stQtyPickedWOR: Double; safecall;
    procedure Set_stQtyPickedWOR(Value: Double); safecall;

    // ICOMStock3 properties
    function Get_stUsesBins: WordBool; safecall;
    procedure Set_stUsesBins(Value: WordBool); safecall;

    // ICOMStock4
    function Get_stSalesWarrantyLength: Integer; safecall;
    procedure Set_stSalesWarrantyLength(Value: Integer); safecall;
    function Get_stSalesWarrantyUnits: Enterprise_TLB.TStockWarrantyUnits; safecall;
    procedure Set_stSalesWarrantyUnits(Value: Enterprise_TLB.TStockWarrantyUnits); safecall;
    function Get_stManufacturerWarrantyLength: Integer; safecall;
    procedure Set_stManufacturerWarrantyLength(Value: Integer); safecall;
    function Get_stManufacturerWarrantyUnits: Enterprise_TLB.TStockWarrantyUnits; safecall;
    procedure Set_stManufacturerWarrantyUnits(Value: Enterprise_TLB.TStockWarrantyUnits); safecall;
    function Get_stSalesReturnGL: Integer; safecall;
    procedure Set_stSalesReturnGL(Value: Integer); safecall;
    function Get_stPurchaseReturnGL: Integer; safecall;
    procedure Set_stPurchaseReturnGL(Value: Integer); safecall;
    function Get_stSalesReturnQty: Double; safecall;
    procedure Set_stSalesReturnQty(Value: Double); safecall;
    function Get_stPurchaseReturnQty: Double; safecall;
    procedure Set_stPurchaseReturnQty(Value: Double); safecall;
    function Get_stRestockCharge: Double; safecall;
    procedure Set_stRestockCharge(Value: Double); safecall;
    function Get_stRestockFlag: Enterprise_TLB.TStockRestockChargeType; safecall;
    procedure Set_stRestockFlag(Value: Enterprise_TLB.TStockRestockChargeType); safecall;

    // ICOMStock5
    function Get_stStkUser5: WideString; safecall;
    procedure Set_stStkUser5(const Value: WideString); safecall;
    function Get_stStkUser6: WideString; safecall;
    procedure Set_stStkUser6(const Value: WideString); safecall;
    function Get_stStkUser7: WideString; safecall;
    procedure Set_stStkUser7(const Value: WideString); safecall;
    function Get_stStkUser8: WideString; safecall;
    procedure Set_stStkUser8(const Value: WideString); safecall;
    function Get_stStkUser9: WideString; safecall;
    procedure Set_stStkUser9(const Value: WideString); safecall;
    function Get_stStkUser10: WideString; safecall;
    procedure Set_stStkUser10(const Value: WideString); safecall;

    // ICOMStock6 - MH 08/09/2014 v7.1 ABSEXCH-15052
    function Get_stIsService: WordBool; safecall;
    procedure Set_stIsService(Value: WordBool); safecall;
  public
    Constructor Create;

    Procedure InitStock(EntSysObj : TEnterpriseSystem);
  End; { TCOMStock }

implementation

uses ComServ, CustIntU, ZUtils;

{-------------------------------------------------------------------------------------------------}

Constructor TCOMStock.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMStock6);

End; { Create }

{-----------------------------------------}

Procedure TCOMStock.InitStock(EntSysObj : TEnterpriseSystem);
Begin { InitGLCode }
  FEntSysObj := EntSysObj;

End; { InitGLCode }

{-----------------------------------------}

function TCOMStock.Get_AccessRights: TRecordAccessStatus;
Begin { Get_AccessRights }
  Result := Ord(FEntSysObj.Stock.AccessRights);
End; { Get_AccessRights }

{-----------------------------------------}

function TCOMStock.Get_DataChanged: WordBool;
Begin { Get_DataChanged }
  Result := FEntSysObj.Stock.DataChanged;
End; { Get_DataChanged }

{-----------------------------------------}

function TCOMStock.Get_stCode: WideString;
Begin { Get_stCode }
  Result := FEntSysObj.Stock.stCode;
End; { Get_stCode }

procedure TCOMStock.Set_stCode(const Value: WideString);
Begin { Set_stCode }
  FEntSysObj.Stock.stCode := Value;
End; { Set_stCode }

{-----------------------------------------}

function TCOMStock.Get_stDesc(Index: Integer): WideString;
Begin { Get_stDesc }
  Result := FEntSysObj.Stock.stDesc[Index];
End; { Get_stDesc }

procedure TCOMStock.Set_stDesc(Index: Integer; const Value: WideString);
Begin { Set_stDesc }
  FEntSysObj.Stock.stDesc[Index] := Value;
End; { Set_stDesc }

{-----------------------------------------}

function TCOMStock.Get_stAltCode: WideString;
Begin { Get_stAltCode }
  Result := FEntSysObj.Stock.stAltCode;
End; { Get_stAltCode }

procedure TCOMStock.Set_stAltCode(const Value: WideString);
Begin { Set_stAltCode }
  FEntSysObj.Stock.stAltCode := Value;
End; { Set_stAltCode }

{-----------------------------------------}

function TCOMStock.Get_stSuppTemp: WideString;
Begin { Get_stSuppTemp }
  Result := FEntSysObj.Stock.stSuppTemp;
End; { Get_stSuppTemp }

procedure TCOMStock.Set_stSuppTemp(const Value: WideString);
Begin { Set_stSuppTemp }
  FEntSysObj.Stock.stSuppTemp := Value;
End; { Set_stSuppTemp }

{-----------------------------------------}

function TCOMStock.Get_stSalesGL: Integer;
Begin { Get_stSalesGL }
  Result := FEntSysObj.Stock.stSalesGL;
End; { Get_stSalesGL }

procedure TCOMStock.Set_stSalesGL(Value: Integer);
Begin { Set_stSalesGL }
  FEntSysObj.Stock.stSalesGL := Value;
End; { Set_stSalesGL }

{-----------------------------------------}

function TCOMStock.Get_stCOSGL: Integer;
Begin { Get_stCOSGL }
  Result := FEntSysObj.Stock.stCOSGL;
End; { Get_stCOSGL }

procedure TCOMStock.Set_stCOSGL(Value: Integer);
Begin { Set_stCOSGL }
  FEntSysObj.Stock.stCOSGL := Value;
End; { Set_stCOSGL }

{-----------------------------------------}

function TCOMStock.Get_stPandLGL: Integer;
Begin { Get_stPandLGL }
  Result := FEntSysObj.Stock.stPandLGL;
End; { Get_stPandLGL }

procedure TCOMStock.Set_stPandLGL(Value: Integer);
Begin { Set_stPandLGL }
  FEntSysObj.Stock.stPandLGL := Value;
End; { Set_stPandLGL }

{-----------------------------------------}

function TCOMStock.Get_stBalSheetGL: Integer;
Begin { Get_stBalSheetGL }
  Result := FEntSysObj.Stock.stBalSheetGL;
End; { Get_stBalSheetGL }

procedure TCOMStock.Set_stBalSheetGL(Value: Integer);
Begin { Set_stBalSheetGL }
  FEntSysObj.Stock.stBalSheetGL := Value;
End; { Set_stBalSheetGL }

{-----------------------------------------}

function TCOMStock.Get_stWIPGL: Integer;
Begin { Get_stWIPGL }
  Result := FEntSysObj.Stock.stWIPGL;
End; { Get_stWIPGL }

procedure TCOMStock.Set_stWIPGL(Value: Integer);
Begin { Set_stWIPGL }
  FEntSysObj.Stock.stWIPGL := Value;
End; { Set_stWIPGL }

{-----------------------------------------}

function TCOMStock.Get_stReOrderFlag: WordBool;
Begin { Get_stReOrderFlag }
  Result := FEntSysObj.Stock.stReOrderFlag;
End; { Get_stReOrderFlag }

procedure TCOMStock.Set_stReOrderFlag(Value: WordBool);
Begin { Set_stReOrderFlag }
  FEntSysObj.Stock.stReOrderFlag := Value;
End; { Set_stReOrderFlag }

{-----------------------------------------}

function TCOMStock.Get_stMinFlg: WordBool;
Begin { Get_stMinFlg }
  Result := FEntSysObj.Stock.stMinFlg;
End; { Get_stMinFlg }

procedure TCOMStock.Set_stMinFlg(Value: WordBool);
Begin { Set_stMinFlg }
  FEntSysObj.Stock.stMinFlg := Value;
End; { Set_stMinFlg }

{-----------------------------------------}

function TCOMStock.Get_stStockFolio: Integer;
Begin { Get_stStockFolio }
  Result := FEntSysObj.Stock.stStockFolio;
End; { Get_stStockFolio }

procedure TCOMStock.Set_stStockFolio(Value: Integer);
Begin { Set_stStockFolio }
  FEntSysObj.Stock.stStockFolio := Value;
End; { Set_stStockFolio }

{-----------------------------------------}

function TCOMStock.Get_stStockCat: WideString;
Begin { Get_stStockCat }
  Result := FEntSysObj.Stock.stStockCat;
End; { Get_stStockCat }

procedure TCOMStock.Set_stStockCat(const Value: WideString);
Begin { Set_stStockCat }
  FEntSysObj.Stock.stStockCat := Value;
End; { Set_stStockCat }

{-----------------------------------------}

function TCOMStock.Get_stStockType: WideString;
Begin { Get_stStockType }
  Result := FEntSysObj.Stock.stStockType;
End; { Get_stStockType }

procedure TCOMStock.Set_stStockType(const Value: WideString);
Begin { Set_stStockType }
  FEntSysObj.Stock.stStockType := WideStrToChar (Value, ' ');
End; { Set_stStockType }

{-----------------------------------------}

function TCOMStock.Get_stUnitOfStock: WideString;
Begin { Get_stUnitOfStock }
  Result := FEntSysObj.Stock.stUnitOfStock;
End; { Get_stUnitOfStock }

procedure TCOMStock.Set_stUnitOfStock(const Value: WideString);
Begin { Set_stUnitOfStock }
  FEntSysObj.Stock.stUnitOfStock := Value;
End; { Set_stUnitOfStock }

{-----------------------------------------}

function TCOMStock.Get_stUnitOfSale: WideString;
Begin { Get_stUnitOfSale }
  Result := FEntSysObj.Stock.stUnitOfSale;
End; { Get_stUnitOfSale }

procedure TCOMStock.Set_stUnitOfSale(const Value: WideString);
Begin { Set_stUnitOfSale }
  FEntSysObj.Stock.stUnitOfSale := Value;
End; { Set_stUnitOfSale }

{-----------------------------------------}

function TCOMStock.Get_stUnitOfPurch: WideString;
Begin { Get_stUnitOfPurch }
  Result := FEntSysObj.Stock.stUnitOfPurch;
End; { Get_stUnitOfPurch }

procedure TCOMStock.Set_stUnitOfPurch(const Value: WideString);
Begin { Set_stUnitOfPurch }
  FEntSysObj.Stock.stUnitOfPurch := Value;
End; { Set_stUnitOfPurch }

{-----------------------------------------}

function TCOMStock.Get_stCostPriceCur: TCurrencyType;
Begin { Get_stCostPriceCur }
  Result := FEntSysObj.Stock.stCostPriceCur;
End; { Get_stCostPriceCur }

procedure TCOMStock.Set_stCostPriceCur(Value: TCurrencyType);
Begin { Set_stCostPriceCur }
  FEntSysObj.Stock.stCostPriceCur := Value;
End; { Set_stCostPriceCur }

{-----------------------------------------}

function TCOMStock.Get_stCostPrice: Double;
Begin { Get_stCostPrice }
  Result := FEntSysObj.Stock.stCostPrice;
End; { Get_stCostPrice }

procedure TCOMStock.Set_stCostPrice(Value: Double);
Begin { Set_stCostPrice }
  FEntSysObj.Stock.stCostPrice := Value;
End; { Set_stCostPrice }

{-----------------------------------------}

function TCOMStock.Get_stSalesUnits: Double;
Begin { Get_stSalesUnits }
  Result := FEntSysObj.Stock.stSalesUnits;
End; { Get_stSalesUnits }

procedure TCOMStock.Set_stSalesUnits(Value: Double);
Begin { Set_stSalesUnits }
  FEntSysObj.Stock.stSalesUnits := Value;
End; { Set_stSalesUnits }

{-----------------------------------------}

function TCOMStock.Get_stPurchUnits: Double;
Begin { Get_stPurchUnits }
  Result := FEntSysObj.Stock.stPurchUnits;
End; { Get_stPurchUnits }

procedure TCOMStock.Set_stPurchUnits(Value: Double);
Begin { Set_stPurchUnits }
  FEntSysObj.Stock.stPurchUnits := Value;
End; { Set_stPurchUnits }

{-----------------------------------------}

function TCOMStock.Get_stVATCode: WideString;
Begin { Get_stVATCode }
  Result := FEntSysObj.Stock.stVATCode;
End; { Get_stVATCode }

procedure TCOMStock.Set_stVATCode(const Value: WideString);
Begin { Set_stVATCode }
  FEntSysObj.Stock.stVATCode := WideStrToChar (Value, ' ');
End; { Set_stVATCode }

{-----------------------------------------}

function TCOMStock.Get_stCostCentre: WideString;
Begin { Get_stCostCentre }
  Result := FEntSysObj.Stock.stCostCentre;
End; { Get_stCostCentre }

procedure TCOMStock.Set_stCostCentre(const Value: WideString);
Begin { Set_stCostCentre }
  FEntSysObj.Stock.stCostCentre := Value;
End; { Set_stCostCentre }

{-----------------------------------------}

function TCOMStock.Get_stDepartment: WideString;
Begin { Get_stDepartment }
  Result := FEntSysObj.Stock.stDepartment;
End; { Get_stDepartment }

procedure TCOMStock.Set_stDepartment(const Value: WideString);
Begin { Set_stDepartment }
  FEntSysObj.Stock.stDepartment := Value;
End; { Set_stDepartment }

{-----------------------------------------}

function TCOMStock.Get_stQtyInStock: Double;
Begin { Get_stQtyInStock }
  Result := FEntSysObj.Stock.stQtyInStock;
End; { Get_stQtyInStock }

procedure TCOMStock.Set_stQtyInStock(Value: Double);
Begin { Set_stQtyInStock }
  FEntSysObj.Stock.stQtyInStock := Value;
End; { Set_stQtyInStock }

{-----------------------------------------}

function TCOMStock.Get_stQtyPosted: Double;
Begin { Get_stQtyPosted }
  Result := FEntSysObj.Stock.stQtyPosted;
End; { Get_stQtyPosted }

procedure TCOMStock.Set_stQtyPosted(Value: Double);
Begin { Set_stQtyPosted }
  FEntSysObj.Stock.stQtyPosted := Value;
End; { Set_stQtyPosted }

{-----------------------------------------}

function TCOMStock.Get_stQtyAllocated: Double;
Begin { Get_stQtyAllocated }
  Result := FEntSysObj.Stock.stQtyAllocated;
End; { Get_stQtyAllocated }

procedure TCOMStock.Set_stQtyAllocated(Value: Double);
Begin { Set_stQtyAllocated }
  FEntSysObj.Stock.stQtyAllocated := Value;
End; { Set_stQtyAllocated }

{-----------------------------------------}

function TCOMStock.Get_stQtyOnOrder: Double;
Begin { Get_stQtyOnOrder }
  Result := FEntSysObj.Stock.stQtyOnOrder;
End; { Get_stQtyOnOrder }

procedure TCOMStock.Set_stQtyOnOrder(Value: Double);
Begin { Set_stQtyOnOrder }
  FEntSysObj.Stock.stQtyOnOrder := Value;
End; { Set_stQtyOnOrder }

{-----------------------------------------}

function TCOMStock.Get_stQtyMin: Double;
Begin { Get_stQtyMin }
  Result := FEntSysObj.Stock.stQtyMin;
End; { Get_stQtyMin }

procedure TCOMStock.Set_stQtyMin(Value: Double);
Begin { Set_stQtyMin }
  FEntSysObj.Stock.stQtyMin := Value;
End; { Set_stQtyMin }

{-----------------------------------------}

function TCOMStock.Get_stQtyMax: Double;
Begin { Get_stQtyMax }
  Result := FEntSysObj.Stock.stQtyMax;
End; { Get_stQtyMax }

procedure TCOMStock.Set_stQtyMax(Value: Double);
Begin { Set_stQtyMax }
  FEntSysObj.Stock.stQtyMax := Value;
End; { Set_stQtyMax }

{-----------------------------------------}

function TCOMStock.Get_stReOrderQty: Double;
Begin { Get_stReOrderQty }
  Result := FEntSysObj.Stock.stReOrderQty;
End; { Get_stReOrderQty }

procedure TCOMStock.Set_stReOrderQty(Value: Double);
Begin { Set_stReOrderQty }
  FEntSysObj.Stock.stReOrderQty := Value;
End; { Set_stReOrderQty }

{-----------------------------------------}

function TCOMStock.Get_stKitOnPurch: WordBool;
Begin { Get_stKitOnPurch }
  Result := FEntSysObj.Stock.stKitOnPurch;
End; { Get_stKitOnPurch }

procedure TCOMStock.Set_stKitOnPurch(Value: WordBool);
Begin { Set_stKitOnPurch }
  FEntSysObj.Stock.stKitOnPurch := Value;
End; { Set_stKitOnPurch }

{-----------------------------------------}

function TCOMStock.Get_stShowAsKit: WordBool;
Begin { Get_stShowAsKit }
  Result := FEntSysObj.Stock.stShowAsKit;
End; { Get_stShowAsKit }

procedure TCOMStock.Set_stShowAsKit(Value: WordBool);
Begin { Set_stShowAsKit }
  FEntSysObj.Stock.stShowAsKit := Value;
End; { Set_stShowAsKit }

{-----------------------------------------}

function TCOMStock.Get_stCommodCode: WideString;
Begin { Get_stCommodCode }
  Result := FEntSysObj.Stock.stCommodCode;
End; { Get_stCommodCode }

procedure TCOMStock.Set_stCommodCode(const Value: WideString);
Begin { Set_stCommodCode }
  FEntSysObj.Stock.stCommodCode := Value;
End; { Set_stCommodCode }

{-----------------------------------------}

function TCOMStock.Get_stSaleUnWeight: Double;
Begin { Get_stSaleUnWeight }
  Result := FEntSysObj.Stock.stSaleUnWeight;
End; { Get_stSaleUnWeight }

procedure TCOMStock.Set_stSaleUnWeight(Value: Double);
Begin { Set_stSaleUnWeight }
  FEntSysObj.Stock.stSaleUnWeight := Value;
End; { Set_stSaleUnWeight }

{-----------------------------------------}

function TCOMStock.Get_stPurchUnWeight: Double;
Begin { Get_stPurchUnWeight }
  Result := FEntSysObj.Stock.stPurchUnWeight;
End; { Get_stPurchUnWeight }

procedure TCOMStock.Set_stPurchUnWeight(Value: Double);
Begin { Set_stPurchUnWeight }
  FEntSysObj.Stock.stPurchUnWeight := Value;
End; { Set_stPurchUnWeight }

{-----------------------------------------}

function TCOMStock.Get_stSSDUnit: WideString;
Begin { Get_stSSDUnit }
  Result := FEntSysObj.Stock.stSSDUnit;
End; { Get_stSSDUnit }

procedure TCOMStock.Set_stSSDUnit(const Value: WideString);
Begin { Set_stSSDUnit }
  FEntSysObj.Stock.stSSDUnit := Value;
End; { Set_stSSDUnit }

{-----------------------------------------}

function TCOMStock.Get_stSSDSalesUnit: Double;
Begin { Get_stSSDSalesUnit }
  Result := FEntSysObj.Stock.stSSDSalesUnit;
End; { Get_stSSDSalesUnit }

procedure TCOMStock.Set_stSSDSalesUnit(Value: Double);
Begin { Set_stSSDSalesUnit }
  FEntSysObj.Stock.stSSDSalesUnit := Value;
End; { Set_stSSDSalesUnit }

{-----------------------------------------}

function TCOMStock.Get_stBinLocation: WideString;
Begin { Get_stBinLocation }
  Result := FEntSysObj.Stock.stBinLocation;
End; { Get_stBinLocation }

procedure TCOMStock.Set_stBinLocation(const Value: WideString);
Begin { Set_stBinLocation }
  FEntSysObj.Stock.stBinLocation := Value;
End; { Set_stBinLocation }

{-----------------------------------------}

function TCOMStock.Get_stStkFlg: WordBool;
Begin { Get_stStkFlg }
  Result := FEntSysObj.Stock.stStkFlg;
End; { Get_stStkFlg }

procedure TCOMStock.Set_stStkFlg(Value: WordBool);
Begin { Set_stStkFlg }
  FEntSysObj.Stock.stStkFlg := Value;
End; { Set_stStkFlg }

{-----------------------------------------}

function TCOMStock.Get_stCovPr: SmallInt;
Begin { Get_stCovPr }
  Result := FEntSysObj.Stock.stCovPr;
End; { Get_stCovPr }

procedure TCOMStock.Set_stCovPr(Value: SmallInt);
Begin { Set_stCovPr }
  FEntSysObj.Stock.stCovPr := Value;
End; { Set_stCovPr }

{-----------------------------------------}

function TCOMStock.Get_stCovPrUnit: WideString;
Begin { Get_stCovPrUnit }
  Result := FEntSysObj.Stock.stCovPrUnit;
End; { Get_stCovPrUnit }

procedure TCOMStock.Set_stCovPrUnit(const Value: WideString);
Begin { Set_stCovPrUnit }
  FEntSysObj.Stock.stCovPrUnit := WideStrToChar (Value, ' ');
End; { Set_stCovPrUnit }

{-----------------------------------------}

function TCOMStock.Get_stCovMinPr: SmallInt;
Begin { Get_stCovMinPr }
  Result := FEntSysObj.Stock.stCovMinPr;
End; { Get_stCovMinPr }

procedure TCOMStock.Set_stCovMinPr(Value: SmallInt);
Begin { Set_stCovMinPr }
  FEntSysObj.Stock.stCovMinPr := Value;
End; { Set_stCovMinPr }

{-----------------------------------------}

function TCOMStock.Get_stCovMinUnit: WideString;
Begin { Get_stCovMinUnit }
  Result := FEntSysObj.Stock.stCovMinUnit;
End; { Get_stCovMinUnit }

procedure TCOMStock.Set_stCovMinUnit(const Value: WideString);
Begin { Set_stCovMinUnit }
  FEntSysObj.Stock.stCovMinUnit := WideStrToChar (Value, ' ');
End; { Set_stCovMinUnit }

{-----------------------------------------}

function TCOMStock.Get_stSupplier: WideString;
Begin { Get_stSupplier }
  Result := FEntSysObj.Stock.stSupplier;
End; { Get_stSupplier }

procedure TCOMStock.Set_stSupplier(const Value: WideString);
Begin { Set_stSupplier }
  FEntSysObj.Stock.stSupplier := Value;
End; { Set_stSupplier }

{-----------------------------------------}

function TCOMStock.Get_stQtyFreeze: Double;
Begin { Get_stQtyFreeze }
  Result := FEntSysObj.Stock.stQtyFreeze;
End; { Get_stQtyFreeze }

procedure TCOMStock.Set_stQtyFreeze(Value: Double);
Begin { Set_stQtyFreeze }
  FEntSysObj.Stock.stQtyFreeze := Value;
End; { Set_stQtyFreeze }

{-----------------------------------------}

function TCOMStock.Get_stCovSold: Double;
Begin { Get_stCovSold }
  Result := FEntSysObj.Stock.stCovSold;
End; { Get_stCovSold }

procedure TCOMStock.Set_stCovSold(Value: Double);
Begin { Set_stCovSold }
  FEntSysObj.Stock.stCovSold := Value;
End; { Set_stCovSold }

{-----------------------------------------}

function TCOMStock.Get_stUseCover: WordBool;
Begin { Get_stUseCover }
  Result := FEntSysObj.Stock.stUseCover;
End; { Get_stUseCover }

procedure TCOMStock.Set_stUseCover(Value: WordBool);
Begin { Set_stUseCover }
  FEntSysObj.Stock.stUseCover := Value;
End; { Set_stUseCover }

{-----------------------------------------}

function TCOMStock.Get_stCovMaxPr: SmallInt;
Begin { Get_stCovMaxPr }
  Result := FEntSysObj.Stock.stCovMaxPr;
End; { Get_stCovMaxPr }

procedure TCOMStock.Set_stCovMaxPr(Value: SmallInt);
Begin { Set_stCovMaxPr }
  FEntSysObj.Stock.stCovMaxPr := Value;
End; { Set_stCovMaxPr }

{-----------------------------------------}

function TCOMStock.Get_stCovMaxUnit: WideString;
Begin { Get_stCovMaxUnit }
  Result := FEntSysObj.Stock.stCovMaxUnit;
End; { Get_stCovMaxUnit }

procedure TCOMStock.Set_stCovMaxUnit(const Value: WideString);
Begin { Set_stCovMaxUnit }
  FEntSysObj.Stock.stCovMaxUnit := WideStrToChar (Value, ' ');
End; { Set_stCovMaxUnit }

{-----------------------------------------}

function TCOMStock.Get_stReOrderCur: SmallInt;
Begin { Get_stReOrderCur }
  Result := FEntSysObj.Stock.stReOrderCur;
End; { Get_stReOrderCur }

procedure TCOMStock.Set_stReOrderCur(Value: SmallInt);
Begin { Set_stReOrderCur }
  FEntSysObj.Stock.stReOrderCur := Value;
End; { Set_stReOrderCur }

{-----------------------------------------}

function TCOMStock.Get_stReOrderPrice: Double;
Begin { Get_stReOrderPrice }
  Result := FEntSysObj.Stock.stReOrderPrice;
End; { Get_stReOrderPrice }

procedure TCOMStock.Set_stReOrderPrice(Value: Double);
Begin { Set_stReOrderPrice }
  FEntSysObj.Stock.stReOrderPrice := Value;
End; { Set_stReOrderPrice }

{-----------------------------------------}

function TCOMStock.Get_stReOrderDate: WideString;
Begin { Get_stReOrderDate }
  Result := FEntSysObj.Stock.stReOrderDate;
End; { Get_stReOrderDate }

procedure TCOMStock.Set_stReOrderDate(const Value: WideString);
Begin { Set_stReOrderDate }
  FEntSysObj.Stock.stReOrderDate := Value;
End; { Set_stReOrderDate }

{-----------------------------------------}

function TCOMStock.Get_stQtyTake: Double;
Begin { Get_stQtyTake }
  Result := FEntSysObj.Stock.stQtyTake;
End; { Get_stQtyTake }

procedure TCOMStock.Set_stQtyTake(Value: Double);
Begin { Set_stQtyTake }
  FEntSysObj.Stock.stQtyTake := Value;
End; { Set_stQtyTake }

{-----------------------------------------}

function TCOMStock.Get_stStkValType: WideString;
Begin { Get_stStkValType }
  Result := FEntSysObj.Stock.stStkValType;
End; { Get_stStkValType }

procedure TCOMStock.Set_stStkValType(const Value: WideString);
Begin { Set_stStkValType }
  FEntSysObj.Stock.stStkValType := WideStrToChar (Value, ' ');
End; { Set_stStkValType }

{-----------------------------------------}

function TCOMStock.Get_stQtyPicked: Double;
Begin { Get_stQtyPicked }
  Result := FEntSysObj.Stock.stQtyPicked;
End; { Get_stQtyPicked }

procedure TCOMStock.Set_stQtyPicked(Value: Double);
Begin { Set_stQtyPicked }
  FEntSysObj.Stock.stQtyPicked := Value;
End; { Set_stQtyPicked }

{-----------------------------------------}

function TCOMStock.Get_stLastUsed: WideString;
Begin { Get_stLastUsed }
  Result := FEntSysObj.Stock.stLastUsed;
End; { Get_stLastUsed }

procedure TCOMStock.Set_stLastUsed(const Value: WideString);
Begin { Set_stLastUsed }
  FEntSysObj.Stock.stLastUsed := Value;
End; { Set_stLastUsed }

{-----------------------------------------}

function TCOMStock.Get_stCalcPack: WordBool;
Begin { Get_stCalcPack }
  Result := FEntSysObj.Stock.stCalcPack;
End; { Get_stCalcPack }

procedure TCOMStock.Set_stCalcPack(Value: WordBool);
Begin { Set_stCalcPack }
  FEntSysObj.Stock.stCalcPack := Value;
End; { Set_stCalcPack }

{-----------------------------------------}

function TCOMStock.Get_stJobAnal: WideString;
Begin { Get_stJobAnal }
  Result := FEntSysObj.Stock.stJobAnal;
End; { Get_stJobAnal }

procedure TCOMStock.Set_stJobAnal(const Value: WideString);
Begin { Set_stJobAnal }
  FEntSysObj.Stock.stJobAnal := Value;
End; { Set_stJobAnal }

{-----------------------------------------}

function TCOMStock.Get_stStkUser1: WideString;
Begin { Get_stStkUser1 }
  Result := FEntSysObj.Stock.stStkUser1;
End; { Get_stStkUser1 }

procedure TCOMStock.Set_stStkUser1(const Value: WideString);
Begin { Set_stStkUser1 }
  FEntSysObj.Stock.stStkUser1 := Value;
End; { Set_stStkUser1 }

{-----------------------------------------}

function TCOMStock.Get_stStkUser2: WideString;
Begin { Get_stStkUser2 }
  Result := FEntSysObj.Stock.stStkUser2;
End; { Get_stStkUser2 }

procedure TCOMStock.Set_stStkUser2(const Value: WideString);
Begin { Set_stStkUser2 }
  FEntSysObj.Stock.stStkUser2 := Value;
End; { Set_stStkUser2 }

{-----------------------------------------}

function TCOMStock.Get_stBarCode: WideString;
Begin { Get_stBarCode }
  Result := FEntSysObj.Stock.stBarCode;
End; { Get_stBarCode }

procedure TCOMStock.Set_stBarCode(const Value: WideString);
Begin { Set_stBarCode }
  FEntSysObj.Stock.stBarCode := Value;
End; { Set_stBarCode }

{-----------------------------------------}

function TCOMStock.Get_stROCostCentre: WideString;
Begin { Get_stROCostCentre }
  Result := FEntSysObj.Stock.stROCostCentre;
End; { Get_stROCostCentre }

procedure TCOMStock.Set_stROCostCentre(const Value: WideString);
Begin { Set_stROCostCentre }
  FEntSysObj.Stock.stROCostCentre := Value;
End; { Set_stROCostCentre }

{-----------------------------------------}

function TCOMStock.Get_stRODepartment: WideString;
Begin { Get_stRODepartment }
  Result := FEntSysObj.Stock.stRODepartment;
End; { Get_stRODepartment }

procedure TCOMStock.Set_stRODepartment(const Value: WideString);
Begin { Set_stRODepartment }
  FEntSysObj.Stock.stRODepartment := Value;
End; { Set_stRODepartment }

{-----------------------------------------}

function TCOMStock.Get_stLocation: WideString;
Begin { Get_stLocation }
  Result := FEntSysObj.Stock.stLocation;
End; { Get_stLocation }

procedure TCOMStock.Set_stLocation(const Value: WideString);
Begin { Set_stLocation }
  FEntSysObj.Stock.stLocation := Value;
End; { Set_stLocation }

{-----------------------------------------}

function TCOMStock.Get_stPricePack: WordBool;
Begin { Get_stPricePack }
  Result := FEntSysObj.Stock.stPricePack;
End; { Get_stPricePack }

procedure TCOMStock.Set_stPricePack(Value: WordBool);
Begin { Set_stPricePack }
  FEntSysObj.Stock.stPricePack := Value;
End; { Set_stPricePack }

{-----------------------------------------}

function TCOMStock.Get_stDPackQty: WordBool;
Begin { Get_stDPackQty }
  Result := FEntSysObj.Stock.stDPackQty;
End; { Get_stDPackQty }

procedure TCOMStock.Set_stDPackQty(Value: WordBool);
Begin { Set_stDPackQty }
  FEntSysObj.Stock.stDPackQty := Value;
End; { Set_stDPackQty }

{-----------------------------------------}

function TCOMStock.Get_stKitPrice: WordBool;
Begin { Get_stKitPrice }
  Result := FEntSysObj.Stock.stKitPrice;
End; { Get_stKitPrice }

procedure TCOMStock.Set_stKitPrice(Value: WordBool);
Begin { Set_stKitPrice }
  FEntSysObj.Stock.stKitPrice := Value;
End; { Set_stKitPrice }

{-----------------------------------------}

function TCOMStock.Get_stStkUser3: WideString;
Begin { Get_stStkUser3 }
  Result := FEntSysObj.Stock.stStkUser3;
End; { Get_stStkUser3 }

procedure TCOMStock.Set_stStkUser3(const Value: WideString);
Begin { Set_stStkUser3 }
  FEntSysObj.Stock.stStkUser3 := Value;
End; { Set_stStkUser3 }

{-----------------------------------------}

function TCOMStock.Get_stStkUser4: WideString;
Begin { Get_stStkUser4 }
  Result := FEntSysObj.Stock.stStkUser4;
End; { Get_stStkUser4 }

procedure TCOMStock.Set_stStkUser4(const Value: WideString);
Begin { Set_stStkUser4 }
  FEntSysObj.Stock.stStkUser4 := Value;
End; { Set_stStkUser4 }

{-----------------------------------------}

function TCOMStock.Get_stSerNoWAvg: SmallInt;
Begin { Get_stSerNoWAvg }
  Result := FEntSysObj.Stock.stSerNoWAvg;
End; { Get_stSerNoWAvg }

procedure TCOMStock.Set_stSerNoWAvg(Value: SmallInt);
Begin { Set_stSerNoWAvg }
  FEntSysObj.Stock.stSerNoWAvg := Value;
End; { Set_stSerNoWAvg }

{-----------------------------------------}

function TCOMStock.Get_stStkSizeCol: SmallInt;
Begin { Get_stStkSizeCol }
  Result := FEntSysObj.Stock.stStkSizeCol;
End; { Get_stStkSizeCol }

{-----------------------------------------}

function TCOMStock.Get_stSSDDUplift: Double;
Begin { Get_stSSDDUplift }
  Result := FEntSysObj.Stock.stSSDDUplift;
End; { Get_stSSDDUplift }

procedure TCOMStock.Set_stSSDDUplift(Value: Double);
Begin { Set_stSSDDUplift }
  FEntSysObj.Stock.stSSDDUplift := Value;
End; { Set_stSSDDUplift }

{-----------------------------------------}

function TCOMStock.Get_stSSDCountry: WideString;
Begin { Get_stSSDCountry }
  Result := FEntSysObj.Stock.stSSDCountry;
End; { Get_stSSDCountry }

procedure TCOMStock.Set_stSSDCountry(const Value: WideString);
Begin { Set_stSSDCountry }
  FEntSysObj.Stock.stSSDCountry := Value;
End; { Set_stSSDCountry }

{-----------------------------------------}

function TCOMStock.Get_stTimeChange: WideString;
Begin { Get_stTimeChange }
  Result := FEntSysObj.Stock.stTimeChange;
End; { Get_stTimeChange }

{-----------------------------------------}

function TCOMStock.Get_stSVATIncFlg: WideString;
Begin { Get_stSVATIncFlg }
  Result := FEntSysObj.Stock.stSVATIncFlg;
End; { Get_stSVATIncFlg }

procedure TCOMStock.Set_stSVATIncFlg(const Value: WideString);
Begin { Set_stSVATIncFlg }
  FEntSysObj.Stock.stSVATIncFlg := WideStrToChar (Value, ' ');
End; { Set_stSVATIncFlg }

{-----------------------------------------}

function TCOMStock.Get_stSSDAUpLift: Double;
Begin { Get_stSSDAUpLift }
  Result := FEntSysObj.Stock.stSSDAUpLift;
End; { Get_stSSDAUpLift }

procedure TCOMStock.Set_stSSDAUpLift(Value: Double);
Begin { Set_stSSDAUpLift }
  FEntSysObj.Stock.stSSDAUpLift := Value;
End; { Set_stSSDAUpLift }

{-----------------------------------------}

function TCOMStock.Get_stLastOpo: WideString;
Begin { Get_stLastOpo }
  Result := FEntSysObj.Stock.stLastOpo;
End; { Get_stLastOpo }

procedure TCOMStock.Set_stLastOpo(const Value: WideString);
Begin { Set_stLastOpo }
  FEntSysObj.Stock.stLastOpo := Value;
End; { Set_stLastOpo }

{-----------------------------------------}

function TCOMStock.Get_stImageFile: WideString;
Begin { Get_stImageFile }
  Result := FEntSysObj.Stock.stImageFile;
End; { Get_stImageFile }

procedure TCOMStock.Set_stImageFile(const Value: WideString);
Begin { Set_stImageFile }
  FEntSysObj.Stock.stImageFile := Value;
End; { Set_stImageFile }

{-----------------------------------------}

function TCOMStock.Get_stSaleBandsCur(const Index: WideString): TCurrencyType;
Begin { Get_stSaleBandsCur }
  Result := FEntSysObj.Stock.stSaleBandsCur[WideStrToChar (Index, ' ')];
End; { Get_stSaleBandsCur }

procedure TCOMStock.Set_stSaleBandsCur(const Index: WideString; Value: TCurrencyType);
Begin { Set_stSaleBandsCur }
  FEntSysObj.Stock.stSaleBandsCur[WideStrToChar (Index, ' ')] := Value;
End; { Set_stSaleBandsCur }

{-----------------------------------------}

function TCOMStock.Get_stSaleBandsPrice(const Index: WideString): Double;
Begin { Get_stSaleBandsPrice }
  Result := FEntSysObj.Stock.stSaleBandsPrice[WideStrToChar (Index, ' ')];
End; { Get_stSaleBandsPrice }

procedure TCOMStock.Set_stSaleBandsPrice(const Index: WideString; Value: Double);
Begin { Set_stSaleBandsPrice }
  FEntSysObj.Stock.stSaleBandsPrice[WideStrToChar (Index, ' ')] := Value;
End; { Set_stSaleBandsPrice }

{-------------------------------------------------------------------------------------------------}

//
// ICOMStock2 properties
//

function TCOMStock.Get_stUseForEbus: WordBool;
begin
  Result := FEntSysObj.Stock.stUseForEbus;
end;

procedure TCOMStock.Set_stUseForEbus(Value: WordBool);
begin
  FEntSysObj.Stock.stUseForEbus := Value;
end;

{-----------------------------------------}

function TCOMStock.Get_stWebLiveCatalog: WideString;
begin
  Result := FEntSysObj.Stock.stWebLiveCatalog;
end;

procedure TCOMStock.Set_stWebLiveCatalog(const Value: WideString);
begin
  FEntSysObj.Stock.stWebLiveCatalog := Value;
end;

{-----------------------------------------}

function TCOMStock.Get_stWebPrevCatalog: WideString;
begin
  Result := FEntSysObj.Stock.stWebPrevCatalog;
end;

procedure TCOMStock.Set_stWebPrevCatalog(const Value: WideString);
begin
  FEntSysObj.Stock.stWebPrevCatalog := Value;
end;

{-----------------------------------------}

function TCOMStock.Get_stWOPROLeadTime: Integer;
begin
  Result := FEntSysObj.Stock.stWOPROLeadTime;
end;

procedure TCOMStock.Set_stWOPROLeadTime(Value: Integer);
begin
  FEntSysObj.Stock.stWOPROLeadTime := Value;
end;

{-----------------------------------------}

function TCOMStock.Get_stWOPAssemblyHours: Integer;
begin
  Result := FEntSysObj.Stock.stWOPAssemblyHours;
end;

procedure TCOMStock.Set_stWOPAssemblyHours(Value: Integer);
begin
  FEntSysObj.Stock.stWOPAssemblyHours := Value;
end;

{-----------------------------------------}

function TCOMStock.Get_stWOPAssemblyMins: Integer;
begin
  Result := FEntSysObj.Stock.stWOPAssemblyMins;
end;

procedure TCOMStock.Set_stWOPAssemblyMins(Value: Integer);
begin
  FEntSysObj.Stock.stWOPAssemblyMins := Value;
end;

{-----------------------------------------}

function TCOMStock.Get_stWOPAutoCalcTime: WordBool;
begin
  Result := FEntSysObj.Stock.stWOPAutoCalcTime;
end;

procedure TCOMStock.Set_stWOPAutoCalcTime(Value: WordBool);
begin
  FEntSysObj.Stock.stWOPAutoCalcTime := Value;
end;

{-----------------------------------------}

function TCOMStock.Get_stWOPMinEconBuild: Double;
begin
  Result := FEntSysObj.Stock.stWOPMinEconBuild;
end;

procedure TCOMStock.Set_stWOPMinEconBuild(Value: Double);
begin
  FEntSysObj.Stock.stWOPMinEconBuild := Value;
end;

{-----------------------------------------}

function TCOMStock.Get_stWOPIssuedWIPGL: Integer;
begin
  Result := FEntSysObj.Stock.stWOPIssuedWIPGL;
end;

procedure TCOMStock.Set_stWOPIssuedWIPGL(Value: Integer);
begin
  FEntSysObj.Stock.stWOPIssuedWIPGL := Value;
end;

{-----------------------------------------}

function TCOMStock.Get_stQtyAllocWOR: Double;
begin
  Result := FEntSysObj.Stock.stQtyAllocWOR;
end;

procedure TCOMStock.Set_stQtyAllocWOR(Value: Double);
begin
  FEntSysObj.Stock.stQtyAllocWOR := Value;
end;

{-----------------------------------------}

function TCOMStock.Get_stQtyIssuedWOR: Double;
begin
  Result := FEntSysObj.Stock.stQtyIssuedWOR;
end;

procedure TCOMStock.Set_stQtyIssuedWOR(Value: Double);
begin
  FEntSysObj.Stock.stQtyIssuedWOR := Value;
end;

{-----------------------------------------}

function TCOMStock.Get_stQtyPickedWOR: Double;
begin
  Result := FEntSysObj.Stock.stQtyPickedWOR;
end;

procedure TCOMStock.Set_stQtyPickedWOR(Value: Double);
begin
  FEntSysObj.Stock.stQtyPickedWOR := Value;
end;

{-----------------------------------------}

function TCOMStock.Get_stUsesBins: WordBool;
begin
  Result := (FEntSysObj.Stock As TAbsStock2).stUsesBins;
end;

procedure TCOMStock.Set_stUsesBins(Value: WordBool);
begin
  (FEntSysObj.Stock As TAbsStock2).stUsesBins := Value;
end;

{-----------------------------------------}

function TCOMStock.Get_stSalesWarrantyLength: Integer;
begin
  Result := (FEntSysObj.Stock As TAbsStock3).stSalesWarrantyLength;
end;
procedure TCOMStock.Set_stSalesWarrantyLength(Value: Integer);
begin
  (FEntSysObj.Stock As TAbsStock3).stSalesWarrantyLength := Value;
end;

//------------------------------

function TCOMStock.Get_stSalesWarrantyUnits: Enterprise_TLB.TStockWarrantyUnits;
begin
  Result := Ord((FEntSysObj.Stock As TAbsStock3).stSalesWarrantyUnits);
end;
procedure TCOMStock.Set_stSalesWarrantyUnits(Value: Enterprise_TLB.TStockWarrantyUnits);
begin
  (FEntSysObj.Stock As TAbsStock3).stSalesWarrantyUnits := CustAbsU.TStockWarrantyUnits(Value);
end;

//-----------------------------------

function TCOMStock.Get_stManufacturerWarrantyLength: Integer;
begin
  Result := (FEntSysObj.Stock As TAbsStock3).stManufacturerWarrantyLength;
end;
procedure TCOMStock.Set_stManufacturerWarrantyLength(Value: Integer);
begin
  (FEntSysObj.Stock As TAbsStock3).stManufacturerWarrantyLength := Value;
end;

//-----------------------------------

function TCOMStock.Get_stManufacturerWarrantyUnits: Enterprise_TLB.TStockWarrantyUnits;
begin
  Result := Ord((FEntSysObj.Stock As TAbsStock3).stManufacturerWarrantyUnits);
end;
procedure TCOMStock.Set_stManufacturerWarrantyUnits(Value: Enterprise_TLB.TStockWarrantyUnits);
begin
  (FEntSysObj.Stock As TAbsStock3).stManufacturerWarrantyUnits := CustAbsU.TStockWarrantyUnits(Value);
end;

//-----------------------------------

function TCOMStock.Get_stSalesReturnGL: Integer;
begin
  Result := (FEntSysObj.Stock As TAbsStock3).stSalesReturnGL;
end;
procedure TCOMStock.Set_stSalesReturnGL(Value: Integer);
begin
  (FEntSysObj.Stock As TAbsStock3).stSalesReturnGL := Value;
end;

//-----------------------------------

function TCOMStock.Get_stPurchaseReturnGL: Integer;
begin
  Result := (FEntSysObj.Stock As TAbsStock3).stPurchaseReturnGL;
end;
procedure TCOMStock.Set_stPurchaseReturnGL(Value: Integer);
begin
  (FEntSysObj.Stock As TAbsStock3).stPurchaseReturnGL := Value;
end;

//-----------------------------------

function TCOMStock.Get_stSalesReturnQty: Double;
begin
  Result := (FEntSysObj.Stock As TAbsStock3).stSalesReturnQty;
end;
procedure TCOMStock.Set_stSalesReturnQty(Value: Double);
begin
  (FEntSysObj.Stock As TAbsStock3).stSalesReturnQty := Value;
end;

//-----------------------------------

function TCOMStock.Get_stPurchaseReturnQty: Double;
begin
  Result := (FEntSysObj.Stock As TAbsStock3).stPurchaseReturnQty;
end;
procedure TCOMStock.Set_stPurchaseReturnQty(Value: Double);
begin
  (FEntSysObj.Stock As TAbsStock3).stPurchaseReturnQty := Value;
end;

//-----------------------------------

function TCOMStock.Get_stRestockCharge: Double;
begin
  Result := (FEntSysObj.Stock As TAbsStock3).stRestockCharge;
end;
procedure TCOMStock.Set_stRestockCharge(Value: Double);
begin
  (FEntSysObj.Stock As TAbsStock3).stRestockCharge := Value;
end;

//------------------------------

function TCOMStock.Get_stRestockFlag: Enterprise_TLB.TStockRestockChargeType;
begin
  Result := Ord((FEntSysObj.Stock As TAbsStock3).stRestockFlag);
end;
procedure TCOMStock.Set_stRestockFlag(Value: Enterprise_TLB.TStockRestockChargeType);
begin
  (FEntSysObj.Stock As TAbsStock3).stRestockFlag := CustAbsU.TStockRestockChargeType(Value);
end;

//-----------------------------------

function TCOMStock.Get_stStkUser10: WideString;
begin
  Result := (FEntSysObj.Stock as TAbsStock4).stStkUser10;
end;

function TCOMStock.Get_stStkUser5: WideString;
begin
  Result := (FEntSysObj.Stock as TAbsStock4).stStkUser5;
end;

function TCOMStock.Get_stStkUser6: WideString;
begin
  Result := (FEntSysObj.Stock as TAbsStock4).stStkUser6;
end;

function TCOMStock.Get_stStkUser7: WideString;
begin
  Result := (FEntSysObj.Stock as TAbsStock4).stStkUser7;
end;

function TCOMStock.Get_stStkUser8: WideString;
begin
  Result := (FEntSysObj.Stock as TAbsStock4).stStkUser8;
end;

function TCOMStock.Get_stStkUser9: WideString;
begin
  Result := (FEntSysObj.Stock as TAbsStock4).stStkUser9;
end;

procedure TCOMStock.Set_stStkUser10(const Value: WideString);
begin
  (FEntSysObj.Stock as TAbsStock4).stStkUser10 := Value;
end;

procedure TCOMStock.Set_stStkUser5(const Value: WideString);
begin
  (FEntSysObj.Stock as TAbsStock4).stStkUser5 := Value;
end;

procedure TCOMStock.Set_stStkUser6(const Value: WideString);
begin
  (FEntSysObj.Stock as TAbsStock4).stStkUser6 := Value;
end;

procedure TCOMStock.Set_stStkUser7(const Value: WideString);
begin
  (FEntSysObj.Stock as TAbsStock4).stStkUser7 := Value;
end;

procedure TCOMStock.Set_stStkUser8(const Value: WideString);
begin
  (FEntSysObj.Stock as TAbsStock4).stStkUser8 := Value;
end;

procedure TCOMStock.Set_stStkUser9(const Value: WideString);
begin
  (FEntSysObj.Stock as TAbsStock4).stStkUser9 := Value;
end;

//------------------------------

function TCOMStock.Get_stIsService: WordBool;
begin
  Result := (FEntSysObj.Stock as TAbsStock5).stIsService;
end;

procedure TCOMStock.Set_stIsService(Value: WordBool);
begin
  (FEntSysObj.Stock as TAbsStock5).stIsService := Value;
end;

end.

