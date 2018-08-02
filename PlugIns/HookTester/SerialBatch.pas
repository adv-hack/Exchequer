unit SerialBatch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CustAbsU, StdCtrls, ExtCtrls, Grids, ValEdit, StrUtil;

type
  TFrmSerialBatch = class(TForm)
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
    LSerialBatch : TAbsBatchSerial3;
    LHandlerID : integer;
  end;

var
  FrmSerialBatch: TFrmSerialBatch;

implementation
uses
  MathUtil;
{$R *.dfm}


procedure TFrmSerialBatch.FillProperties;
begin
  with LSerialBatch do begin
    vlProperties.Values['bsSerialCode'] := bsSerialCode;
    vlProperties.Values['bsSerialNo'] := bsSerialNo;
    vlProperties.Values['bsBatchNo'] := bsBatchNo;
    vlProperties.Values['bsInDoc'] := bsInDoc;
    vlProperties.Values['bsOutDoc'] := bsOutDoc;
    vlProperties.Values['bsSold'] := BooleanToStr(bsSold);
    vlProperties.Values['bsDateIn'] := bsDateIn;
    vlProperties.Values['bsSerCost'] := FloatToStr(bsSerCost);
    vlProperties.Values['bsSerSell'] := FloatToStr(bsSerSell);
    vlProperties.Values['bsStkFolio'] := IntToStr(bsStkFolio);
    vlProperties.Values['bsDateOut'] := bsDateOut;
    vlProperties.Values['bsSoldLine'] := IntToStr(bsSoldLine);
    vlProperties.Values['bsCurCost'] := IntToStr(bsCurCost);
    vlProperties.Values['bsCurSell'] := IntToStr(bsCurSell);
    vlProperties.Values['bsBuyLine'] := IntToStr(bsBuyLine);
    vlProperties.Values['bsBatchRec'] := BooleanToStr(bsBatchRec);
    vlProperties.Values['bsBuyQty'] := FloatToStr(bsBuyQty);
    vlProperties.Values['bsQtyUsed'] := FloatToStr(bsQtyUsed);
    vlProperties.Values['bsBatchChild'] := BooleanToStr(bsBatchChild);
    vlProperties.Values['bsInMLoc'] := bsInMLoc;
    vlProperties.Values['bsOutMLoc'] := bsOutMLoc;
    vlProperties.Values['bsCompanyRate'] := FloatToStr(bsCompanyRate);
    vlProperties.Values['bsDailyRate'] := FloatToStr(bsDailyRate);
    vlProperties.Values['bsInOrdDoc'] := bsInOrdDoc;
    vlProperties.Values['bsOutOrdDoc'] := bsOutOrdDoc;
    vlProperties.Values['bsInOrdLine'] := IntToStr(bsInOrdLine);
    vlProperties.Values['bsOutOrdLine'] := IntToStr(bsOutOrdLine);
    vlProperties.Values['bsNLineCount'] := IntToStr(bsNLineCount);
    vlProperties.Values['bsNoteFolio'] := IntToStr(bsNoteFolio);
    vlProperties.Values['bsDateUseX'] := bsDateUseX;
    vlProperties.Values['bsSUseORate'] := IntToStr(bsSUseORate);
    vlProperties.Values['bsBinCode'] := bsBinCode;

    // TAbsBatchSerial3
    vlProperties.Values['bsReturned'] := BooleanToStr(bsReturned);
    vlProperties.Values['bsReturnOurRef'] := bsReturnOurRef;
    vlProperties.Values['bsBatchReturnedQty'] := FloatToStr(bsBatchReturnedQty);
    vlProperties.Values['bsReturnLineNo'] := IntToStr(bsReturnLineNo);
  end;{with}
  btnSaveEdits.enabled := NumberIn(LHandlerID, [103103, 103104]);
end;

procedure TFrmSerialBatch.FormShow(Sender: TObject);
begin
  FillProperties;
end;

procedure TFrmSerialBatch.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TFrmSerialBatch.btnSaveEditsClick(Sender: TObject);
begin
  with LSerialBatch do begin
    case LHandlerID of
      103103, 103104 : begin
        bsBinCode := vlProperties.Values['bsBinCode'];
      end;
    end;{case}
  end;{with}
  FillProperties;
end;

end.
