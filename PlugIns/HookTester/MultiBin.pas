unit MultiBin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CustAbsU, StdCtrls, ExtCtrls, Grids, ValEdit, StrUtil;

type
  TFrmMultiBin = class(TForm)
    vlProperties: TValueListEditor;
    Panel1: TPanel;
    btnSaveEdits: TButton;
    btnClose: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveEditsClick(Sender: TObject);
  private
    procedure FillProperties;
  public
    LMultiBin : TAbsMultiBin2;
    LHandlerID : integer;
  end;

var
  FrmMultiBin: TFrmMultiBin;

implementation
uses
  MathUtil;
{$R *.dfm}


procedure TFrmMultiBin.FillProperties;
begin
  with LMultiBin do begin
    vlProperties.Values['brBinCode'] := brBinCode;
    vlProperties.Values['brStockFolio'] := IntToStr(brStockFolio);
    vlProperties.Values['brPickingPriority'] := brPickingPriority;
    vlProperties.Values['brUseByDate'] := brUseByDate;
    vlProperties.Values['brUnitOfMeasurement'] := brUnitOfMeasurement;
    vlProperties.Values['brAutoPickMode'] := IntToStr(brAutoPickMode);
    vlProperties.Values['brTagNo'] := IntToStr(brTagNo);
    vlProperties.Values['brQty'] := FloatToStr(brQty);
    vlProperties.Values['brQtyUsed'] := FloatToStr(brQtyUsed);
    vlProperties.Values['brCapacity'] := FloatToStr(brCapacity);
    vlProperties.Values['brCostPrice'] := FloatToStr(brCostPrice);
    vlProperties.Values['brCostPriceCurrency'] := IntToStr(brCostPriceCurrency);
    vlProperties.Values['brSalesPrice'] := FloatToStr(brSalesPrice);
    vlProperties.Values['brSalesPriceCurrency'] := IntToStr(brSalesPriceCurrency);
    vlProperties.Values['brInDate'] := brInDate;
    vlProperties.Values['brInOrderRef'] := brInOrderRef;
    vlProperties.Values['brInOrderLine'] := IntToStr(brInOrderLine);
    vlProperties.Values['brInDocRef'] := brInOrderRef;
    vlProperties.Values['brInDocLine'] := IntToStr(brInOrderLine);
    vlProperties.Values['brInLocation'] := brInLocation;
    vlProperties.Values['brUsedRec'] := booleanToStr(brUsedRec);
    vlProperties.Values['brSold'] := booleanToStr(brSold);
    vlProperties.Values['brOutDate'] := brOutDate;
    vlProperties.Values['brOutOrderRef'] := brOutOrderRef;
    vlProperties.Values['brOutOrderLine'] := IntToStr(brOutOrderLine);
    vlProperties.Values['brOutDocRef'] := brOutOrderRef;
    vlProperties.Values['brOutDocLine'] := IntToStr(brOutOrderLine);
    vlProperties.Values['brOutLocation'] := brOutLocation;
    vlProperties.Values['brCompanyRate'] := FloatToStr(brCompanyRate);
    vlProperties.Values['brDailyRate'] := FloatToStr(brDailyRate);
    vlProperties.Values['brUseORate'] := IntToStr(brUseORate);
// {32} Property brTriangulation : TAbsCurrencyTriangulation Read GetTriangulation;
    vlProperties.Values['brReturned'] := BooleanToStr(brReturned);
  end;{with}
  btnSaveEdits.enabled := NumberIn(LHandlerID, []);
end;

procedure TFrmMultiBin.FormShow(Sender: TObject);
begin
  FillProperties;
end;

procedure TFrmMultiBin.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TFrmMultiBin.btnSaveEditsClick(Sender: TObject);
begin
  with LMultiBin do begin
{    case LHandlerID of
      103103, 103104 : begin
        bsBinCode := vlProperties.Values['bsBinCode'];
      end;
    end;{case}
  end;{with}
  FillProperties;
end;

end.
