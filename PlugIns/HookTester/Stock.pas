unit Stock;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ValEdit, CustAbsU, StrUtil;

type
  TfrmStock = class(TForm)
    vlProperties: TValueListEditor;
    Panel1: TPanel;
    btnSaveEdits: TButton;
    btnClose: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveEditsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure FillProperties;
  public
    LStock : TAbsStock3;
    LHandlerID : integer;
  end;

var
  frmStock: TfrmStock;

implementation
uses
  MathUtil;

{$R *.dfm}

{ TfrmStock }

procedure TfrmStock.FillProperties;
begin
  with LStock do begin
    vlProperties.Values['stCode'] := LStock.stCode;
    vlProperties.Values['stDesc[1]'] := LStock.stDesc[1];
    vlProperties.Values['stDesc[2]'] := LStock.stDesc[2];
    vlProperties.Values['stDesc[3]'] := LStock.stDesc[3];
    vlProperties.Values['stDesc[4]'] := LStock.stDesc[4];
    vlProperties.Values['stDesc[5]'] := LStock.stDesc[5];
    vlProperties.Values['stAltCode'] := LStock.stAltCode;
    vlProperties.Values['stSuppTemp'] := LStock.stSuppTemp;
    vlProperties.Values['stSalesGL'] := IntToStr(LStock.stSalesGL);
    vlProperties.Values['stCOSGL'] := IntToStr(LStock.stCOSGL);
    vlProperties.Values['stPandLGL'] := IntToStr(LStock.stPandLGL);
    vlProperties.Values['stBalSheetGL'] := IntToStr(LStock.stBalSheetGL);
    vlProperties.Values['stWIPGL'] := IntToStr(LStock.stWIPGL);
    vlProperties.Values['stReOrderFlag'] := BooleanToStr(LStock.stReOrderFlag);
    vlProperties.Values['stMinFlg'] := BooleanToStr(LStock.stMinFlg);
    vlProperties.Values['stStockFolio'] := IntToStr(LStock.stStockFolio);
    vlProperties.Values['stStockCat'] := LStock.stStockCat;
    vlProperties.Values['stStockType'] := LStock.stStockType;
    vlProperties.Values['stUnitOfStock'] := LStock.stUnitOfStock;
    vlProperties.Values['stUnitOfSale'] := LStock.stUnitOfSale;
    vlProperties.Values['stUnitOfPurch'] := LStock.stUnitOfPurch;
    vlProperties.Values['stCostPriceCur'] := IntToStr(LStock.stCostPriceCur);
    vlProperties.Values['stCostPrice'] := FloatToStr(LStock.stCostPrice);
    vlProperties.Values['stSalesUnits'] := FloatToStr(LStock.stSalesUnits);
    vlProperties.Values['stPurchUnits'] := FloatToStr(LStock.stPurchUnits);
    vlProperties.Values['stVATCode'] := LStock.stVATCode;
    vlProperties.Values['stCostCentre'] := LStock.stCostCentre;
    vlProperties.Values['stDepartment'] := LStock.stDepartment;
    vlProperties.Values['stQtyInStock'] := FloatToStr(LStock.stQtyInStock);
    vlProperties.Values['stQtyPosted'] := FloatToStr(LStock.stQtyPosted);
    vlProperties.Values['stQtyAllocated'] := FloatToStr(LStock.stQtyAllocated);
    vlProperties.Values['stQtyOnOrder'] := FloatToStr(LStock.stQtyOnOrder);
    vlProperties.Values['stQtyMin'] := FloatToStr(LStock.stQtyMin);
    vlProperties.Values['stQtyMax'] := FloatToStr(LStock.stQtyMax);
    vlProperties.Values['stReOrderQty'] := FloatToStr(LStock.stReOrderQty);
    vlProperties.Values['stKitOnPurch'] := BooleanToStr(LStock.stKitOnPurch);
    vlProperties.Values['stShowAsKit'] := BooleanToStr(LStock.stShowAsKit);
    vlProperties.Values['stCommodCode'] := LStock.stCommodCode;
    vlProperties.Values['stSaleUnWeight'] := FloatToStr(LStock.stSaleUnWeight);
    vlProperties.Values['stPurchUnWeight'] := FloatToStr(LStock.stPurchUnWeight);
    vlProperties.Values['stSSDUnit'] := LStock.stSSDUnit;
    vlProperties.Values['stSSDSalesUnit'] := FloatToStr(LStock.stSSDSalesUnit);
    vlProperties.Values['stBinLocation'] := LStock.stBinLocation;
    vlProperties.Values['stStkFlg'] := BooleanToStr(LStock.stStkFlg);
    vlProperties.Values['stCovPr'] := IntToStr(LStock.stCovPr);
    vlProperties.Values['stCovPrUnit'] := LStock.stCovPrUnit;
    vlProperties.Values['stCovMinPr'] := IntToStr(LStock.stCovMinPr);
    vlProperties.Values['stCovMinUnit'] := LStock.stCovMinUnit;
    vlProperties.Values['stSupplier'] := LStock.stSupplier;
    vlProperties.Values['stQtyFreeze'] := FloatToStr(LStock.stQtyFreeze);
    vlProperties.Values['stCovSold'] := FloatToStr(LStock.stCovSold);
    vlProperties.Values['stUseCover'] := BooleanToStr(LStock.stUseCover);
    vlProperties.Values['stCovMaxPr'] := IntToStr(LStock.stCovMaxPr);
    vlProperties.Values['stCovMaxUnit'] := LStock.stCovMaxUnit;
    vlProperties.Values['stReOrderCur'] := IntToStr(LStock.stReOrderCur);
    vlProperties.Values['stReOrderPrice'] := FloatToStr(LStock.stReOrderPrice);
    vlProperties.Values['stReOrderDate'] := LStock.stReOrderDate;
    vlProperties.Values['stQtyTake'] := FloatToStr(LStock.stQtyTake);
    vlProperties.Values['stStkValType'] := LStock.stStkValType;
    vlProperties.Values['stQtyPicked'] := FloatToStr(LStock.stQtyPicked);
    vlProperties.Values['stLastUsed'] := LStock.stLastUsed;
    vlProperties.Values['stCalcPack'] := BooleanToStr(LStock.stCalcPack);
    vlProperties.Values['stJobAnal'] := LStock.stJobAnal;
    vlProperties.Values['stStkUser1'] := LStock.stStkUser1;
    vlProperties.Values['stStkUser2'] := LStock.stStkUser2;
    vlProperties.Values['stBarCode'] := LStock.stBarCode;
    vlProperties.Values['stROCostCentre'] := LStock.stROCostCentre;
    vlProperties.Values['stRODepartment'] := LStock.stRODepartment;
    vlProperties.Values['stLocation'] := LStock.stLocation;
    vlProperties.Values['stPricePack'] := BooleanToStr(LStock.stPricePack);
    vlProperties.Values['stDPackQty'] := BooleanToStr(LStock.stDPackQty);
    vlProperties.Values['stKitPrice'] := BooleanToStr(LStock.stKitPrice);
    vlProperties.Values['stUsesBins'] := BooleanToStr(LStock.stUsesBins);

    // TABSStock3
    vlProperties.Values['stSalesWarrantyLength'] := IntToStr(LStock.stSalesWarrantyLength);
    vlProperties.Values['stSalesWarrantyUnits'] := IntToStr(Byte(LStock.stSalesWarrantyUnits));
    vlProperties.Values['stManufacturerWarrantyLength'] := IntToStr(LStock.stManufacturerWarrantyLength);
    vlProperties.Values['stManufacturerWarrantyUnits'] := IntToStr(Byte(LStock.stManufacturerWarrantyUnits));
    vlProperties.Values['stSalesReturnGL'] := IntToStr(LStock.stSalesReturnGL);
    vlProperties.Values['stPurchaseReturnGL'] := IntToStr(LStock.stPurchaseReturnGL);
    vlProperties.Values['stSalesReturnQty'] := FloatToStr(LStock.stSalesReturnQty);
    vlProperties.Values['stPurchaseReturnQty'] := FloatToStr(LStock.stPurchaseReturnQty);
    vlProperties.Values['stRestockCharge'] := FloatToStr(LStock.stRestockCharge);
    vlProperties.Values['stRestockFlag'] := IntToStr(integer(LStock.stRestockFlag));
  end;{with}
  btnSaveEdits.enabled := NumberIn(LHandlerID, [103052, 103002]);
end;

procedure TfrmStock.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmStock.btnSaveEditsClick(Sender: TObject);
begin
  with LStock do begin
    case LHandlerID of
      103002 : begin
        stBarCode := vlProperties.Values['stBarCode'];
        stPurchUnWeight := StrToFloatDef(vlProperties.Values['stPurchUnWeight'], 0);
        stSaleUnWeight := StrToFloatDef(vlProperties.Values['stSaleUnWeight'], 0);
        stStkUser1 := vlProperties.Values['stStkUser1'];
        stStkUser2 := vlProperties.Values['stStkUser2'];
        stStkUser3 := vlProperties.Values['stStkUser3'];
        stStkUser4 := vlProperties.Values['stStkUser4'];
      end;
      103052 : begin
        stReorderDate := vlProperties.Values['stReorderDate'];
      end;
    end;{case}
  end;{with}

  FillProperties;
end;

procedure TfrmStock.FormShow(Sender: TObject);
begin
  FillProperties;
end;

end.
