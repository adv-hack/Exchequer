unit TransactionLine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CustAbsU, StdCtrls, ExtCtrls, Grids, ValEdit;

type
  TFrmTransactionLine = class(TForm)
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
    LTXLine : TAbsInvLine5;
    LHandlerID : integer;
  end;

var
  FrmTransactionLine: TFrmTransactionLine;

implementation
uses
  MathUtil;
{$R *.dfm}


procedure TFrmTransactionLine.FillProperties;
begin
  with LTXLine do begin
    vlProperties.Values['tlFolio'] := IntToStr(tlFolio);
    vlProperties.Values['tlLinePos'] := IntToStr(tlLinePos);
    vlProperties.Values['tlRunNo'] := IntToStr(tlRunNo);
    vlProperties.Values['tlGLCode'] := IntToStr(tlGLCode);
    vlProperties.Values['tlShowInGL'] := IntToStr(tlShowInGL);
    vlProperties.Values['tlCurrency'] := IntToStr(tlCurrency);
    vlProperties.Values['tlYear'] := IntToStr(tlYear);
    vlProperties.Values['tlPeriod'] := IntToStr(tlPeriod);
    vlProperties.Values['tlCostCentre'] := tlCostCentre;
    vlProperties.Values['tlDepartment'] := tlDepartment;
    vlProperties.Values['tlStockCode'] := tlStockCode;
    vlProperties.Values['tlLineNo'] := IntToStr(tlLineNo);
    vlProperties.Values['tlLineClass'] := tlLineClass;
//    vlProperties.Values['tlDocType'] := tlDocType;
    vlProperties.Values['tlQty'] := FloatToStr(tlQty);
    vlProperties.Values['tlQtyMul'] := FloatToStr(tlQtyMul);
    vlProperties.Values['tlNetValue'] := FloatToStr(tlNetValue);
    vlProperties.Values['tlDiscount'] := FloatToStr(tlDiscount);
    vlProperties.Values['tlVATCode'] := tlVATCode;
    vlProperties.Values['tlVATAmount'] := FloatToStr(tlVATAmount);
    vlProperties.Values['tlPayStatus'] := tlPayStatus;
    vlProperties.Values['tlPrevGLBal'] := FloatToStr(tlPrevGLBal);
    vlProperties.Values['tlRecStatus'] := IntToStr(tlRecStatus);
    vlProperties.Values['tlDiscFlag'] := tlDiscFlag;
    vlProperties.Values['tlQtyWOFF'] := FloatToStr(tlQtyWOFF);
    vlProperties.Values['tlQtyDel'] := FloatToStr(tlQtyDel);
    vlProperties.Values['tlCost'] := FloatToStr(tlCost);
    vlProperties.Values['tlAcCode'] := tlAcCode;
    vlProperties.Values['tlTransDate'] := tlTransDate;
    vlProperties.Values['tlItemNo'] := tlItemNo;
    vlProperties.Values['tlDescr'] := tlDescr;
    vlProperties.Values['tlJobCode'] := tlJobCode;
    vlProperties.Values['tlJobAnal'] := tlJobAnal;
    vlProperties.Values['tlCompanyRate'] := FloatToStr(tlCompanyRate);
    vlProperties.Values['tlDailyRate'] := FloatToStr(tlDailyRate);
    vlProperties.Values['tlUnitWeight'] := FloatToStr(tlUnitWeight);
    vlProperties.Values['tlStockDeductQty'] := FloatToStr(tlStockDeductQty);
    vlProperties.Values['tlBOMKitLink'] := IntToStr(tlBOMKitLink);
    vlProperties.Values['tlOrderFolio'] := IntToStr(tlOrderFolio);
    vlProperties.Values['tlOrderLineNo'] := IntToStr(tlOrderLineNo);
    vlProperties.Values['tlLocation'] := tlLocation;
    vlProperties.Values['tlQtyPicked'] := FloatToStr(tlQtyPicked);
    vlProperties.Values['tlQtyPickedWO'] := FloatToStr(tlQtyPickedWO);
    vlProperties.Values['tlUseQtyMul'] := BoolToStr(tlUseQtyMul);
    vlProperties.Values['tlNoSerialNos'] := FloatToStr(tlNoSerialNos);
    vlProperties.Values['tlCOSGL'] := IntToStr(tlCOSGL);
    vlProperties.Values['tlOurRef'] := tlOurRef;
//    vlProperties.Values['tlLineType'] := tlLineType;
    vlProperties.Values['tlPriceByPack'] := BoolToStr(tlPriceByPack);
    vlProperties.Values['tlQtyInPack'] := FloatToStr(tlQtyInPack);
    vlProperties.Values['tlClearDate'] := tlClearDate;
    vlProperties.Values['tlUserDef1'] := tlUserDef1;
    vlProperties.Values['tlUserDef2'] := tlUserDef2;
    vlProperties.Values['tlUserDef3'] := tlUserDef3;
    vlProperties.Values['tlUserDef4'] := tlUserDef4;
    vlProperties.Values['tlLineSource'] := IntToStr(tlLineSource);
    vlProperties.Values['tlCISRateCode'] := tlCISRateCode;
    vlProperties.Values['tlCISRate'] := FloatToStr(tlCISRate);
    vlProperties.Values['tlCostApport'] := FloatToStr(tlCostApport);
    vlProperties.Values['tlVATInclValue'] := FloatToStr(tlVATInclValue);
//    vlProperties.Values['tlNOMVATType'] := tlNOMVATType;
    vlProperties.Values['tlCISAdjustments'] := FloatToStr(tlCISAdjustments);
    vlProperties.Values['tlAppsDeductType'] := IntToStr(tlAppsDeductType);

    // TAbsInvLine5
    vlProperties.Values['tlSerialReturnQty'] := FloatToStr(tlSerialReturnQty);
    vlProperties.Values['tlBinReturnQty'] := FloatToStr(tlBinReturnQty);
  end;{with}
  btnSaveEdits.enabled := NumberIn(LHandlerID, [102187, 102188, 104002, 104001
  , 104003, 104004, 104006, 104009, 104010, 104011, 104012, 104015, 104016, 104017
  , 104031, 104032, 104033, 104034, 104059, 104087, 105080, 105100, 105101, 105103
  , 190002]);
end;

procedure TFrmTransactionLine.FormShow(Sender: TObject);
begin
  FillProperties;
end;

procedure TFrmTransactionLine.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TFrmTransactionLine.btnSaveEditsClick(Sender: TObject);
begin
  with LTXLine do begin
    case LHandlerID of
      102188 : begin
        tlNetValue := StrToFloatDef(vlProperties.Values['tlNetValue'], 0);
        tlDiscount := StrToFloatDef(vlProperties.Values['tlDiscount'], 0);
        if Length(vlProperties.Values['tlDiscFlag']) > 0
        then tlDiscFlag := vlProperties.Values['tlDiscFlag'][1];
      end;

      102187 : begin
        tlNetValue := StrToFloatDef(vlProperties.Values['tlNetValue'], 0);
        tlDiscount := StrToFloatDef(vlProperties.Values['tlDiscount'], 0);
        if Length(vlProperties.Values['tlDiscFlag']) > 0
        then tlDiscFlag := vlProperties.Values['tlDiscFlag'][1];
      end;

      104001 : begin
        tlQty := StrToFloatDef(vlProperties.Values['tlQty'], 0);
        tlUserDef1 := vlProperties.Values['tlUserDef1'];
        tlUserDef2 := vlProperties.Values['tlUserDef2'];
        tlUserDef3 := vlProperties.Values['tlUserDef3'];
        tlUserDef4 := vlProperties.Values['tlUserDef4'];
      end;

      104002 : begin
        tlQtyMul := StrToFloatDef(vlProperties.Values['tlQtyMul'], 0);
        tlUserDef1 := vlProperties.Values['tlUserDef1'];
        tlUserDef2 := vlProperties.Values['tlUserDef2'];
        tlUserDef3 := vlProperties.Values['tlUserDef3'];
        tlUserDef4 := vlProperties.Values['tlUserDef4'];
      end;

      104003, 105101, 105103 : begin
        tlUserDef1 := vlProperties.Values['tlUserDef1'];
        tlUserDef2 := vlProperties.Values['tlUserDef2'];
        tlUserDef3 := vlProperties.Values['tlUserDef3'];
        tlUserDef4 := vlProperties.Values['tlUserDef4'];
      end;

      104009 : begin
        tlNetValue := StrToFloatDef(vlProperties.Values['tlNetValue'], 0);
        tlVATInclValue := StrToFloatDef(vlProperties.Values['tlVATInclValue'], 0);
        tlDiscount := StrToFloatDef(vlProperties.Values['tlDiscount'], 0);
        if Length(vlProperties.Values['tlDiscFlag']) > 0
        then tlDiscFlag := vlProperties.Values['tlDiscFlag'][1];
      end;

      104010 : begin
        tlNetValue := StrToFloatDef(vlProperties.Values['tlNetValue'], 0);
        tlDiscount := StrToFloatDef(vlProperties.Values['tlDiscount'], 0);
        if Length(vlProperties.Values['tlDiscFlag']) > 0
        then tlDiscFlag := vlProperties.Values['tlDiscFlag'][1];
        tlJobAnal := vlProperties.Values['tlJobAnal'];
      	tlJobCode := vlProperties.Values['tlJobCode'];
        tlUnitWeight := StrToFloatDef(vlProperties.Values['tlUnitWeight'], 0);
        tlUserDef1 := vlProperties.Values['tlUserDef1'];
        tlUserDef2 := vlProperties.Values['tlUserDef2'];
        tlUserDef3 := vlProperties.Values['tlUserDef3'];
        tlUserDef4 := vlProperties.Values['tlUserDef4'];
      end;

      {104002,} 104004, 104029 : begin
        tlVATInclValue := StrToFloatDef(vlProperties.Values['tlVATInclValue'],0);
        tlNetValue := StrToFloatDef(vlProperties.Values['tlNetValue'], 0);
      end;

      104011 : begin
        tlCost := StrToFloatDef(vlProperties.Values['tlCost'], 0);
        tlNetValue := StrToFloatDef(vlProperties.Values['tlNetValue'], 0);
        tlVATInclValue := StrToFloatDef(vlProperties.Values['tlVATInclValue'],0);
        tlVATCode := vlProperties.Values['tlVATCode'][1];
      end;

      104012 : begin
        tlVATInclValue := StrToFloatDef(vlProperties.Values['tlVATInclValue'],0);
        tlNetValue := StrToFloatDef(vlProperties.Values['tlNetValue'], 0);
        tlUserDef1 := vlProperties.Values['tlUserDef1'];
        tlUserDef2 := vlProperties.Values['tlUserDef2'];
        tlUserDef3 := vlProperties.Values['tlUserDef3'];
        tlUserDef4 := vlProperties.Values['tlUserDef4'];
      end;

      104015 : begin
        tlStockCode := vlProperties.Values['tlStockCode'];
        tlQty := StrToFloatDef(vlProperties.Values['tlQty'],0);
      end;

      104016 : tlCostCentre := vlProperties.Values['tlCostCentre'];
      104017 : tlDepartment := vlProperties.Values['tlDepartment'];
      104031 : tlUserDef1 := vlProperties.Values['tlUserDef1'];
      104032 : tlUserDef2 := vlProperties.Values['tlUserDef2'];
      104033 : tlUserDef3 := vlProperties.Values['tlUserDef3'];
      104034 : tlUserDef4 := vlProperties.Values['tlUserDef4'];
      104059 : tlLocation := vlProperties.Values['tlLocation'];
      104087 : tlQty := StrToFloatDef(vlProperties.Values['tlQty'],0);
      105080 : tlGLCode := StrToIntDef(vlProperties.Values['tlGLCode'], 0);

      105100 : begin
        tlDailyRate := StrToFloatDef(vlProperties.Values['tlDailyRate'], 0);
        tlCurrency := StrToIntDef(vlProperties.Values['tlCurrency'], 0);
        tlUserDef1 := vlProperties.Values['tlUserDef1'];
        tlUserDef2 := vlProperties.Values['tlUserDef2'];
        tlUserDef3 := vlProperties.Values['tlUserDef3'];
        tlUserDef4 := vlProperties.Values['tlUserDef4'];
      end;

      190002 : begin
        tlVATCode := vlProperties.Values['tlVATCode'][1];
        tlVATAmount := StrToFloatDef(vlProperties.Values['tlVATAmount'], 0);
        tlVATInclValue := StrToFloatDef(vlProperties.Values['tlVATInclValue'],0);
      end;

      104006 : begin
        tlVATCode := vlProperties.Values['tlVATCode'][1];
      end;

    end;{case}
  end;{with}
  FillProperties;
end;

end.
