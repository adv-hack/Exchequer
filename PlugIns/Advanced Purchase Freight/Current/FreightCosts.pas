unit FreightCosts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , CustAbsU, Dialogs, StdCtrls, ComCtrls, PSUpliftPROC, TEditVal, ExtCtrls
  , Enterprise01_TLB, MathUtil, EnterToTab, EtMiscU;

type
  TfrmFreightCosts = class(TForm)
    pcTabs: TPageControl;
    tsExclusions: TTabSheet;
    btnApply: TButton;
    btnCancel: TButton;
    tsFreight: TTabSheet;
    Label1: TLabel;
    cmbCurrency: TComboBox;
    panValues: TPanel;
    Shape1: TShape;
    lCat2Desc: TLabel;
    lP2: TLabel;
    lP3: TLabel;
    lP4: TLabel;
    lCat3Desc: TLabel;
    lCat4Desc: TLabel;
    lCat5Desc: TLabel;
    lCat6Desc: TLabel;
    lCat2: TLabel;
    lCat3: TLabel;
    lCat4: TLabel;
    Label13: TLabel;
    lTotalUplift: TLabel;
    Shape2: TShape;
    Shape3: TShape;
    Shape6: TShape;
    Shape7: TShape;
    edCat2P: TCurrencyEdit;
    edCat3P: TCurrencyEdit;
    edCat4P: TCurrencyEdit;
    edCat5: TCurrencyEdit;
    edCat6: TCurrencyEdit;
    panPercent: TPanel;
    Shape8: TShape;
    panValue: TPanel;
    Shape9: TShape;
    Label17: TLabel;
    lTotReceived: TLabel;
    cbLineTypes: TCheckBox;
    cbNonStock: TCheckBox;
    cbBOMKits: TCheckBox;
    Label10: TLabel;
    lTotReceivedValue: TLabel;
    lApportUplift: TLabel;
    lUnitUplift: TLabel;
    Shape11: TShape;
    Shape12: TShape;
    Shape13: TShape;
    lCat1Desc: TLabel;
    lCat7Desc: TLabel;
    edCat7: TCurrencyEdit;
    edCat1: TCurrencyEdit;
    EnterToTab1: TEnterToTab;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label19: TLabel;
    Label20: TLabel;
    Label22: TLabel;
    rbQuantity: TRadioButton;
    rbValue: TRadioButton;
    rbWeight: TRadioButton;
    Bevel3: TBevel;
    Label2: TLabel;
    lTotReceivedWeight: TLabel;
    Panel1: TPanel;
    Shape5: TShape;
    lCat1: TLabel;
    lCat5: TLabel;
    lCat6: TLabel;
    lCat7: TLabel;
    Shape16: TShape;
    Shape17: TShape;
    Shape18: TShape;
    Shape19: TShape;
    Shape20: TShape;
    lCat8: TLabel;
    lCat9: TLabel;
    lCat10: TLabel;
    edCat2: TCurrencyEdit;
    edCat3: TCurrencyEdit;
    edCat4: TCurrencyEdit;
    edCat8: TCurrencyEdit;
    edCat9: TCurrencyEdit;
    edCat10: TCurrencyEdit;
    lCat8Desc: TLabel;
    lCat9Desc: TLabel;
    lCat10Desc: TLabel;
    edCat1P: TCurrencyEdit;
    lP1: TLabel;
    edCat5P: TCurrencyEdit;
    lP5: TLabel;
    edCat6P: TCurrencyEdit;
    lP6: TLabel;
    edCat7P: TCurrencyEdit;
    lP7: TLabel;
    edCat8P: TCurrencyEdit;
    lP8: TLabel;
    edCat9P: TCurrencyEdit;
    lP9: TLabel;
    edCat10P: TCurrencyEdit;
    lP10: TLabel;
    Bevel4: TBevel;
    Shape4: TShape;
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure ChangeValues(Sender: TObject);
    procedure IncludeClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure cmbCurrencyChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RBChange(Sender: TObject);
  private
    iCurrentCcy, iNoOfQtyDecs, iNoOfValueDecs : byte;
    function IsBOMKit(sStockCode : string) : boolean;
    procedure EnableDisable;
  public
    iDefaultCcy : integer;
    rTotalUplift, rTotReceivedValue, rTotReceivedWeight, rTotReceived : real;
    oEventData : TAbsEnterpriseSystem;
//    oEventData.Transaction : TAbsInvoice;
    procedure GetReceivedTotals(var rTotReceived : real; var rTotValue : real; var rTotWeight : real);
  end;

var
  frmFreightCosts: TfrmFreightCosts;

implementation
uses
  Math, APIUtil, MiscUtil, StrUtil, HandlerU;

{$R *.dfm}

procedure TfrmFreightCosts.FormShow(Sender: TObject);

  function GetValueFromNoteLine(iLineNo : integer) : double;
  var
    iEqualPos : integer;
  begin{GetValueFromNoteLine}
    Result := 0;
    oToolkit.Stock.stNotes.ntType := ntTypeGeneral;
    if oToolkit.Stock.stNotes.GetEqual(oToolkit.Stock.stNotes.BuildIndex(iLineNo)) = 0 then
    begin
      iEqualPos := Pos('=', oToolkit.Stock.stNotes.ntText);
      if iEqualPos > 0 then
      begin
        Result := StrToFloatDef(Trim(Copy(oToolkit.Stock.stNotes.ntText, iEqualPos+1, 255)), 0);
      end;{if}
    end;{for}
  end;{GetValueFromNoteLine}

var
  iNoteLine, iPos, iStatus, iLine : integer;
  sStockCode : string16;
  arDefaultValues : array [1..10] of double;
  rValue : double;
begin
  lCat1Desc.Visible := SetupRec.CategoryUsed[GL_CAT+1];
  lCat2Desc.Visible := SetupRec.CategoryUsed[GL_CAT+2];
  lCat3Desc.Visible := SetupRec.CategoryUsed[GL_CAT+3];
  lCat4Desc.Visible := SetupRec.CategoryUsed[GL_CAT+4];
  lCat5Desc.Visible := SetupRec.CategoryUsed[GL_CAT+5];
  lCat6Desc.Visible := SetupRec.CategoryUsed[GL_CAT+6];
  lCat7Desc.Visible := SetupRec.CategoryUsed[GL_CAT+7];
  lCat8Desc.Visible := SetupRec.CategoryUsed[GL_CAT+8];
  lCat9Desc.Visible := SetupRec.CategoryUsed[GL_CAT+9];
  lCat10Desc.Visible := SetupRec.CategoryUsed[GL_CAT+10];

  lCat1Desc.Caption := SetupRec.Descriptions[GL_CAT+1] + ' :';
  lCat2Desc.Caption := SetupRec.Descriptions[GL_CAT+2] + ' :';
  lCat3Desc.Caption := SetupRec.Descriptions[GL_CAT+3] + ' :';
  lCat4Desc.Caption := SetupRec.Descriptions[GL_CAT+4] + ' :';
  lCat5Desc.Caption := SetupRec.Descriptions[GL_CAT+5] + ' :';
  lCat6Desc.Caption := SetupRec.Descriptions[GL_CAT+6] + ' :';
  lCat7Desc.Caption := SetupRec.Descriptions[GL_CAT+7] + ' :';
  lCat8Desc.Caption := SetupRec.Descriptions[GL_CAT+8] + ' :';
  lCat9Desc.Caption := SetupRec.Descriptions[GL_CAT+9] + ' :';
  lCat10Desc.Caption := SetupRec.Descriptions[GL_CAT+10] + ' :';

  edCat1P.Visible := (SetupRec.CategoryType[GL_CAT+1] = 'P') and SetupRec.CategoryUsed[GL_CAT+1];
  edCat2P.Visible := (SetupRec.CategoryType[GL_CAT+2] = 'P') and SetupRec.CategoryUsed[GL_CAT+2];
  edCat3P.Visible := (SetupRec.CategoryType[GL_CAT+3] = 'P') and SetupRec.CategoryUsed[GL_CAT+3];
  edCat4P.Visible := (SetupRec.CategoryType[GL_CAT+4] = 'P') and SetupRec.CategoryUsed[GL_CAT+4];
  edCat5P.Visible := (SetupRec.CategoryType[GL_CAT+5] = 'P') and SetupRec.CategoryUsed[GL_CAT+5];
  edCat6P.Visible := (SetupRec.CategoryType[GL_CAT+6] = 'P') and SetupRec.CategoryUsed[GL_CAT+6];
  edCat7P.Visible := (SetupRec.CategoryType[GL_CAT+7] = 'P') and SetupRec.CategoryUsed[GL_CAT+7];
  edCat8P.Visible := (SetupRec.CategoryType[GL_CAT+8] = 'P') and SetupRec.CategoryUsed[GL_CAT+8];
  edCat9P.Visible := (SetupRec.CategoryType[GL_CAT+9] = 'P') and SetupRec.CategoryUsed[GL_CAT+9];
  edCat10P.Visible := (SetupRec.CategoryType[GL_CAT+10] = 'P') and SetupRec.CategoryUsed[GL_CAT+10];

  edCat1.Visible := (SetupRec.CategoryType[GL_CAT+1] = 'V') and SetupRec.CategoryUsed[GL_CAT+1];
  edCat2.Visible := (SetupRec.CategoryType[GL_CAT+2] = 'V') and SetupRec.CategoryUsed[GL_CAT+2];
  edCat3.Visible := (SetupRec.CategoryType[GL_CAT+3] = 'V') and SetupRec.CategoryUsed[GL_CAT+3];
  edCat4.Visible := (SetupRec.CategoryType[GL_CAT+4] = 'V') and SetupRec.CategoryUsed[GL_CAT+4];
  edCat5.Visible := (SetupRec.CategoryType[GL_CAT+5] = 'V') and SetupRec.CategoryUsed[GL_CAT+5];
  edCat6.Visible := (SetupRec.CategoryType[GL_CAT+6] = 'V') and SetupRec.CategoryUsed[GL_CAT+6];
  edCat7.Visible := (SetupRec.CategoryType[GL_CAT+7] = 'V') and SetupRec.CategoryUsed[GL_CAT+7];
  edCat8.Visible := (SetupRec.CategoryType[GL_CAT+8] = 'V') and SetupRec.CategoryUsed[GL_CAT+8];
  edCat9.Visible := (SetupRec.CategoryType[GL_CAT+9] = 'V') and SetupRec.CategoryUsed[GL_CAT+9];
  edCat10.Visible := (SetupRec.CategoryType[GL_CAT+10] = 'V') and SetupRec.CategoryUsed[GL_CAT+10];

  lP1.Visible := SetupRec.CategoryType[GL_CAT+1] = 'P';
  lP2.Visible := SetupRec.CategoryType[GL_CAT+2] = 'P';
  lP3.Visible := SetupRec.CategoryType[GL_CAT+3] = 'P';
  lP4.Visible := SetupRec.CategoryType[GL_CAT+4] = 'P';
  lP5.Visible := SetupRec.CategoryType[GL_CAT+5] = 'P';
  lP6.Visible := SetupRec.CategoryType[GL_CAT+6] = 'P';
  lP7.Visible := SetupRec.CategoryType[GL_CAT+7] = 'P';
  lP8.Visible := SetupRec.CategoryType[GL_CAT+8] = 'P';
  lP9.Visible := SetupRec.CategoryType[GL_CAT+9] = 'P';
  lP10.Visible := SetupRec.CategoryType[GL_CAT+10] = 'P';

  lCat1.Visible := SetupRec.CategoryUsed[GL_CAT+1];
  lCat2.Visible := SetupRec.CategoryUsed[GL_CAT+2];
  lCat3.Visible := SetupRec.CategoryUsed[GL_CAT+3];
  lCat4.Visible := SetupRec.CategoryUsed[GL_CAT+4];
  lCat5.Visible := SetupRec.CategoryUsed[GL_CAT+5];
  lCat6.Visible := SetupRec.CategoryUsed[GL_CAT+6];
  lCat7.Visible := SetupRec.CategoryUsed[GL_CAT+7];
  lCat8.Visible := SetupRec.CategoryUsed[GL_CAT+8];
  lCat9.Visible := SetupRec.CategoryUsed[GL_CAT+9];
  lCat10.Visible := SetupRec.CategoryUsed[GL_CAT+10];

  iNoOfValueDecs := oToolkit.SystemSetup.ssCostDecimals;
  iNoOfQtyDecs := oToolkit.SystemSetup.ssQtyDecimals;

  edCat1.displayformat := '#########0.' +  StringOfChar('0', iNoOfValueDecs);
  edCat2.displayformat := '#########0.' +  StringOfChar('0', iNoOfValueDecs);
  edCat3.displayformat := '#########0.' +  StringOfChar('0', iNoOfValueDecs);
  edCat4.displayformat := '#########0.' +  StringOfChar('0', iNoOfValueDecs);
  edCat5.displayformat := '#########0.' +  StringOfChar('0', iNoOfValueDecs);
  edCat6.displayformat := '#########0.' +  StringOfChar('0', iNoOfValueDecs);
  edCat7.displayformat := '#########0.' +  StringOfChar('0', iNoOfValueDecs);
  edCat8.displayformat := '#########0.' +  StringOfChar('0', iNoOfValueDecs);
  edCat9.displayformat := '#########0.' +  StringOfChar('0', iNoOfValueDecs);
  edCat10.displayformat := '#########0.' +  StringOfChar('0', iNoOfValueDecs);

  edCat1P.displayformat := '##0.00';
  edCat2P.displayformat := '##0.00';
  edCat3P.displayformat := '##0.00';
  edCat4P.displayformat := '##0.00';
  edCat5P.displayformat := '##0.00';
  edCat6P.displayformat := '##0.00';
  edCat7P.displayformat := '##0.00';
  edCat8P.displayformat := '##0.00';
  edCat9P.displayformat := '##0.00';
  edCat10P.displayformat := '##0.00';

  pcTabs.ActivePageIndex := 0;
  FillCurrencyCombo(cmbCurrency, iDefaultCcy);
  cmbCurrencyChange(cmbCurrency);
  lTotReceived.Caption := MoneyToStr(rTotReceived, iNoOfQtyDecs);
  lTotReceivedValue.Caption := MoneyToStr(rTotReceivedValue, iNoOfValueDecs);
  lTotReceivedWeight.Caption := MoneyToStr(rTotReceivedWeight, iNoOfValueDecs);

  rbQuantity.Enabled := SetupRec.bShowQuantity;
  rbValue.Enabled := SetupRec.bShowValue;
  rbWeight.Enabled := SetupRec.bShowWeight;

  case SetupRec.iAllocateDefault of
    1 : rbQuantity.Checked := TRUE;
    2 : rbValue.Checked := TRUE;
    3 : rbWeight.Checked := TRUE;
  end;

  // Read Default Values from Notes - This is a Kato specific routine, controlled by an ini file enrty
  if SetupRec.bReadDefaultValues then
  begin
    FillChar(arDefaultValues, sizeof(arDefaultValues), #0);

    // Go through all lines on the TX
    For iLine := 1 to oEventData.Transaction.thLines.thLineCount do
    begin
      with oToolkit do begin
        // Get the Stock item
        Stock.Index := stIdxCode;
        sStockCode := Trim(oEventData.Transaction.thLines.thLine[iLine].tlStockCode);
        if sStockCode <> '' then // Ignore non-stock items
        begin
          iStatus := Stock.GetEqual(Stock.BuildCodeIndex(sStockCode));
          if iStatus = 0 then
          begin
            // Read all 10 default values from the notes
            For iPos := 1 to 10 do
            begin
              iNoteLine := iPos + 3;
              rValue := GetValueFromNoteLine(iNoteLine);
              arDefaultValues[iPos] := arDefaultValues[iPos] + (rValue
              * oEventData.Transaction.thLines.thLine[iLine].tlQtyPicked) ;
            end;{for}
          end else
          begin
            MsgBox('Stock record not found for : ' + sStockCode, mtError, [mbOK], mbOK, 'Stock Record not found');
          end;{if}
        end;{if}
      end;{with}
    end;{for}

    // Apply Defaults
    For iPos := 1 to 10 do
    begin
      if SetupRec.CategoryUsed[iPos] and (SetupRec.CategoryType[iPos] = 'V') then // only apply to "Value" types
      begin
        case iPos of
          1 : edCat1.Value := arDefaultValues[iPos];
          2 : edCat2.Value := arDefaultValues[iPos];
          3 : edCat3.Value := arDefaultValues[iPos];
          4 : edCat4.Value := arDefaultValues[iPos];
          5 : edCat5.Value := arDefaultValues[iPos];
          6 : edCat6.Value := arDefaultValues[iPos];
          7 : edCat7.Value := arDefaultValues[iPos];
          8 : edCat8.Value := arDefaultValues[iPos];
          9 : edCat9.Value := arDefaultValues[iPos];
          10 : edCat10.Value := arDefaultValues[iPos];
        end;{case}
      end;{if}
    end;
  end;{if}
end;

procedure TfrmFreightCosts.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmFreightCosts.ChangeValues(Sender: TObject);
begin
  if SetupRec.CategoryType[GL_CAT+1] = 'P' then lCat1.Caption := MoneyToStr((StrToFloatDef(edCat1P.Text,0) / 100) * rTotReceivedValue, iNoOfValueDecs)
  else lCat1.Caption := MoneyToStr(StrToFloatDef(edCat1.Text,0),iNoOfValueDecs);
  if SetupRec.CategoryType[GL_CAT+2] = 'P' then lCat2.Caption := MoneyToStr((StrToFloatDef(edCat2P.Text,0) / 100) * rTotReceivedValue, iNoOfValueDecs)
  else lCat2.Caption := MoneyToStr(StrToFloatDef(edCat2.Text,0),iNoOfValueDecs);
  if SetupRec.CategoryType[GL_CAT+3] = 'P' then lCat3.Caption := MoneyToStr((StrToFloatDef(edCat3P.Text,0) / 100) * rTotReceivedValue, iNoOfValueDecs)
  else lCat3.Caption := MoneyToStr(StrToFloatDef(edCat3.Text,0),iNoOfValueDecs);
  if SetupRec.CategoryType[GL_CAT+4] = 'P' then lCat4.Caption := MoneyToStr((StrToFloatDef(edCat4P.Text,0) / 100) * rTotReceivedValue, iNoOfValueDecs)
  else lCat4.Caption := MoneyToStr(StrToFloatDef(edCat4.Text,0),iNoOfValueDecs);
  if SetupRec.CategoryType[GL_CAT+5] = 'P' then lCat5.Caption := MoneyToStr((StrToFloatDef(edCat5P.Text,0) / 100) * rTotReceivedValue, iNoOfValueDecs)
  else lCat5.Caption := MoneyToStr(StrToFloatDef(edCat5.Text,0),iNoOfValueDecs);
  if SetupRec.CategoryType[GL_CAT+6] = 'P' then lCat6.Caption := MoneyToStr((StrToFloatDef(edCat6P.Text,0) / 100) * rTotReceivedValue, iNoOfValueDecs)
  else lCat6.Caption := MoneyToStr(StrToFloatDef(edCat6.Text,0),iNoOfValueDecs);
  if SetupRec.CategoryType[GL_CAT+7] = 'P' then lCat7.Caption := MoneyToStr((StrToFloatDef(edCat7P.Text,0) / 100) * rTotReceivedValue, iNoOfValueDecs)
  else lCat7.Caption := MoneyToStr(StrToFloatDef(edCat7.Text,0),iNoOfValueDecs);
  if SetupRec.CategoryType[GL_CAT+8] = 'P' then lCat8.Caption := MoneyToStr((StrToFloatDef(edCat8P.Text,0) / 100) * rTotReceivedValue, iNoOfValueDecs)
  else lCat8.Caption := MoneyToStr(StrToFloatDef(edCat8.Text,0),iNoOfValueDecs);
  if SetupRec.CategoryType[GL_CAT+9] = 'P' then lCat9.Caption := MoneyToStr((StrToFloatDef(edCat9P.Text,0) / 100) * rTotReceivedValue, iNoOfValueDecs)
  else lCat9.Caption := MoneyToStr(StrToFloatDef(edCat9.Text,0),iNoOfValueDecs);
  if SetupRec.CategoryType[GL_CAT+10] = 'P' then lCat10.Caption := MoneyToStr((StrToFloatDef(edCat10P.Text,0) / 100) * rTotReceivedValue, iNoOfValueDecs)
  else lCat10.Caption := MoneyToStr(StrToFloatDef(edCat10.Text,0),iNoOfValueDecs);

  rTotalUplift := StrToFloatDef(lCat1.Caption,0) + StrToFloatDef(lCat2.Caption,0)
  + StrToFloatDef(lCat3.Caption,0) + StrToFloatDef(lCat4.Caption,0) + StrToFloatDef(lCat5.Caption,0)
  + StrToFloatDef(lCat6.Caption,0) + StrToFloatDef(lCat7.Caption,0) + StrToFloatDef(lCat8.Caption,0)
  + StrToFloatDef(lCat9.Caption,0) + StrToFloatDef(lCat10.Caption,0);

  lTotalUplift.Caption := MoneyToStr(rTotalUplift, iNoOfValueDecs);

  if rbQuantity.Checked then
  begin
    if rTotReceived > 0 then
    begin
//      lApportUplift.Caption := MoneyToStr(rTotalUplift / rTotReceived, iNoOfValueDecs)
//      lApportUplift.Caption := MoneyToStr(SimpleRoundTo(rTotalUplift / rTotReceived, -iNoOfValueDecs), iNoOfValueDecs)
//      lApportUplift.Caption := MoneyToStr(StrToFloatDef(MoneyToStr(SafeDiv(rTotalUplift, rTotReceived), iNoOfValueDecs), 0));
      lApportUplift.Caption := MoneyToStr(Round_Up(SafeDiv(rTotalUplift, rTotReceived), iNoOfValueDecs), iNoOfValueDecs);
    end
    else
    begin
      lApportUplift.Caption := MoneyToStr(0, iNoOfValueDecs);
    end;{if}
  end
  else
  begin
    lApportUplift.Caption := 'N/A';
  end;{if}

  EnableDisable;
end;

procedure TfrmFreightCosts.GetReceivedTotals(var rTotReceived : real; var rTotValue : real
; var rTotWeight : real);
var
  iPos : integer;
begin{GetTotalReceivedValue}
  rTotReceived := 0;
  rTotValue := 0;
  rTotWeight := 0;
  For iPos := 1 to oEventData.Transaction.thLines.thLineCount do
  begin
    if (not cbLineTypes.Checked and (oEventData.Transaction.thLines.thLine[iPos].tlLineType in [0..4]))
    or (not cbNonStock.Checked and (Trim(oEventData.Transaction.thLines.thLine[iPos].tlStockCode) = ''))
    or (not cbBOMKits.Checked and IsBOMKit(oEventData.Transaction.thLines.thLine[iPos].tlStockCode))
    or ((oEventData.Transaction.thLines.thLine[iPos].tlBOMKitLink <> 0)
    and (oEventData.Transaction.thLines.thLine[iPos].tlStockCode <> '')) then // BOM components
    begin
      // Exclude Line
    end else
    begin
      // Include Line
      rTotReceived := rTotReceived + oEventData.Transaction.thLines.thLine[iPos].tlQtyPicked;

//      rTotValue := rTotValue + (oEventData.Transaction.thLines.thLine[iPos].tlQtyPicked
//      * oEventData.Transaction.thLines.thLine[iPos].tlNetValue);

      rTotValue := rTotValue + (oEventData.Transaction.thLines.thLine[iPos].entInvLTotal(TRUE
      , oEventData.Transaction.thDiscSetl) * SafeDiv(oEventData.Transaction.thLines.thLine[iPos].tlQtyPicked
      , oEventData.Transaction.thLines.thLine[iPos].tlQty));

      rTotWeight := rTotWeight + (GetStockWeight(oEventData.Transaction.thLines.thLine[iPos].tlStockCode)
      * oEventData.Transaction.thLines.thLine[iPos].tlQtyPicked);
    end;{if}
  end;{for}

  if oEventData.Transaction.thCurrency <> iCurrentCcy then
  begin
    // MH 27/08/2015 ABSEXGENERIC-384: Modified to use Transaction Rates for currency conversions
    // Convert To Base/Consolidated using Transaction Rate
    rTotValue := oToolkit.Functions.entConvertAmountWithRates(rTotValue,                               // Amount
                                                              True,                                    // ConvertToBase
                                                              oEventData.Transaction.thCurrency,       // RateCurrency
                                                              oEventData.Transaction.thCompanyRate,    // CompanyRate
                                                              oEventData.Transaction.thDailyRate);     // DailyRate

    If (iCurrentCcy <> 1) Then
      // Convert To Selected Currency using Live Rates
      rTotValue := oToolkit.Functions.entConvertAmount(rTotValue,                                      // Amount
                                                       0,                                              // FromCurrency
                                                       iCurrentCcy,                                    // ToCurrency
                                                       oToolkit.SystemSetup.ssCurrencyRateType);       // RateType
  end;{if}
end;{GetTotalReceivedValue}


procedure TfrmFreightCosts.IncludeClick(Sender: TObject);
begin
  GetReceivedTotals(rTotReceived, rTotReceivedValue, rTotReceivedWeight);
  lTotReceived.Caption := MoneyToStr(rTotReceived, iNoOfQtyDecs);
  lTotReceivedValue.Caption := MoneyToStr(rTotReceivedValue, iNoOfValueDecs);
  lTotReceivedWeight.Caption := MoneyToStr(rTotReceivedWeight, iNoOfValueDecs);
  ChangeValues(nil);
end;

procedure TfrmFreightCosts.btnApplyClick(Sender: TObject);
//var
//  rTotalUplifted : real;

  procedure UpdateUplift;
  // Update Uplift Field on all appropriate transaction lines
  var
    iStatus, iLine : integer;
    rTotalUpliftinTXCcy, rLineUplift : real;
    oTransUpdate : ITransaction;
  begin
    // initialise
//    rLineUplift := StrToFloatDef(lApportUplift.Caption, 0);
//    rTotalUplifted := 0;

    // Get Transaction
    oToolkit.Transaction.Index := thIdxOurRef;
    iStatus := oToolkit.Transaction.GetEqual(oToolkit.Transaction.BuildOurRefIndex(oEventData.Transaction.thOurRef));
    if iStatus = 0 then
    begin
      // MH 27/08/2015 ABSEXGENERIC-384: Modified to use Transaction Rates for currency conversions
      rTotalUpliftinTXCcy := ConvertCurrency(StrToFloatDef(lCat1.Caption, 0), iCurrentCcy, oToolkit.Transaction) +
                             ConvertCurrency(StrToFloatDef(lCat2.Caption, 0), iCurrentCcy, oToolkit.Transaction) +
                             ConvertCurrency(StrToFloatDef(lCat3.Caption, 0), iCurrentCcy, oToolkit.Transaction) +
                             ConvertCurrency(StrToFloatDef(lCat4.Caption, 0), iCurrentCcy, oToolkit.Transaction) +
                             ConvertCurrency(StrToFloatDef(lCat5.Caption, 0), iCurrentCcy, oToolkit.Transaction) +
                             ConvertCurrency(StrToFloatDef(lCat6.Caption, 0), iCurrentCcy, oToolkit.Transaction) +
                             ConvertCurrency(StrToFloatDef(lCat7.Caption, 0), iCurrentCcy, oToolkit.Transaction) +
                             ConvertCurrency(StrToFloatDef(lCat8.Caption, 0), iCurrentCcy, oToolkit.Transaction) +
                             ConvertCurrency(StrToFloatDef(lCat9.Caption, 0), iCurrentCcy, oToolkit.Transaction) +
                             ConvertCurrency(StrToFloatDef(lCat10.Caption, 0), iCurrentCcy, oToolkit.Transaction);

{      if rTotReceived > 0 then rLineUplift := StrToFloatDef(MoneyToStr(SafeDiv(rTotalUpliftinTXCcy
      , rTotReceived), iNoOfValueDecs), 0)
      else rLineUplift := 0;}

      if rbQuantity.Checked then
      begin
//        rLineUplift := StrToFloatDef(MoneyToStr(SafeDiv(rTotalUpliftinTXCcy
//        , rTotReceived), iNoOfValueDecs), 0)
        rLineUplift := Round_Up(SafeDiv(rTotalUpliftinTXCcy, rTotReceived), iNoOfValueDecs);

      end;{if}

      if (rLineUplift = 0) and (rbQuantity.Checked) then
      begin
        // no uplift - do nothing
      end else
      begin

        with oToolkit.Transaction do
        begin

          // Convert to TX Currency
{          if iCurrentCcy <> oToolkit.Transaction.thCurrency then
          begin
            rLineUplift := oToolkit.Functions.entConvertAmount(rLineUplift
            ,iCurrentCcy, oToolkit.Transaction.thCurrency
            , oToolkit.SystemSetup.ssCurrencyRateType);
          end;{if}

          // Go through all TX lines
          For iLine := 1 to thLines.thLineCount do
          begin
            if (not cbLineTypes.Checked and (thLines.thLine[iLine].tlLineType in [0..4]))
            or (not cbNonStock.Checked and (Trim(thLines.thLine[iLine].tlStockCode) = ''))
            or (not cbBOMKits.Checked and IsBOMKit(Trim(thLines.thLine[iLine].tlStockCode)))
            or ((thLines.thLine[iLine].tlBOMKitLink <> 0)
            and (thLines.thLine[iLine].tlStockCode <> '')) then // BOM components
            begin
              // Exclude Line
            end else
            begin
              // Update Line Uplift

              // Apportion by Value
              if rbValue.Checked then
              begin
                rLineUplift := ((thLines.thLine[iLine].tlNetValue) / rTotReceivedValue) * rTotalUplift;
              end;{if}

              // Apportion by Weight
              if rbWeight.Checked then
              begin
                rLineUplift := (GetStockWeight(thLines.thLine[iLine].tlStockCode)
                {* thLines.thLine[iLine].tlQtyPicked)} / rTotReceivedWeight) * rTotalUplift;
              end;{if}

              if (Trim(thLines.thLine[iLine].tlStockCode) = '') then
              begin
                // Non-Stock Lines
                // NF: Have to write to tlcost as updateuplift does not work for non-stock items
                oTransUpdate := oToolkit.Transaction.Update;
                oTransUpdate.thLines.thLine[iLine].tlCost := rLineUplift;
                iStatus := oTransUpdate.Save(TRUE);
                if iStatus <> 0 then
                begin
                  MsgBox('oTransUpdate.Save failed with the error code : ' + IntToStr(iStatus)
                  , mtError, [mbOK], mbOK, 'oTransUpdate.Save Error');
                end;
                oTransUpdate := nil;
              end else
              begin
                // Stock Lines
                iStatus := (thLines.thLine[iLine] as ITransactionLine2).UpdateUplift(rLineUplift);
                if iStatus <> 0 then
                begin
                  MsgBox('UpdateUplift failed with the error code : ' + IntToStr(iStatus)
                  , mtError, [mbOK], mbOK, 'UpdateUplift Error');
                end;
    //            thLines.thLine[iLine].tlCost := rLineUplift;
  //              rTotalUplifted := rTotalUplifted + (rLineUplift * thLines.thLine[iLine].tlQtyPicked);
              end;{if}
            end;{if}
          end;{for}
  //        oTransUpdate.Save(TRUE);
        end;{with}
      end;{if}
    end else
    begin
      MsgBox('oToolkit.Transaction.GetEqual (' + oEventData.Transaction.thOurRef
      + ') failed with the error code : ' + IntToStr(iStatus), mtError, [mbOK]
      , mbOK, 'UpdateUplift Error');
    end;{if}
  end;{UpdateUplift}

  procedure AddNotes;

    Function GetNoteText(iNoteNo : integer) : string;
    var
      rValue : real;
    begin{GetNoteText}
      Result := '';
      case iNoteNo of
        // MH 27/08/2015 ABSEXGENERIC-384: Modified to use Transaction Rates for currency conversions
        1  : rValue := ConvertCurrency(StrToFloatDef(lCat1.Caption, 0), iCurrentCcy, oToolkit.Transaction);
        2  : rValue := ConvertCurrency(StrToFloatDef(lCat2.Caption, 0), iCurrentCcy, oToolkit.Transaction);
        3  : rValue := ConvertCurrency(StrToFloatDef(lCat3.Caption, 0), iCurrentCcy, oToolkit.Transaction);
        4  : rValue := ConvertCurrency(StrToFloatDef(lCat4.Caption, 0), iCurrentCcy, oToolkit.Transaction);
        5  : rValue := ConvertCurrency(StrToFloatDef(lCat5.Caption, 0), iCurrentCcy, oToolkit.Transaction);
        6  : rValue := ConvertCurrency(StrToFloatDef(lCat6.Caption, 0), iCurrentCcy, oToolkit.Transaction);
        7  : rValue := ConvertCurrency(StrToFloatDef(lCat7.Caption, 0), iCurrentCcy, oToolkit.Transaction);
        8  : rValue := ConvertCurrency(StrToFloatDef(lCat8.Caption, 0), iCurrentCcy, oToolkit.Transaction);
        9  : rValue := ConvertCurrency(StrToFloatDef(lCat9.Caption, 0), iCurrentCcy, oToolkit.Transaction);
        10 : rValue := ConvertCurrency(StrToFloatDef(lCat10.Caption, 0), iCurrentCcy, oToolkit.Transaction);
      end;{Case}
      Result := SetupRec.Descriptions[iNoteNo] + '=' + MoneyToStr(rValue, iNoOfValueDecs);
    end;{GetNoteText}

    procedure AddNote(iNewLineNo : integer);
    var
      iLine, iStatus : integer;
    begin {AddNote}
      oToolkit.Transaction.thNotes.ntType := ntTypeGeneral;
      with oToolkit.Transaction.thNotes.add do begin
    //        ntType := ntTypeGeneral;
    //        ntDate := DateToStr8(Date);
        ntOperator := oEventData.UserName;
        ntLineNo := iNewLineNo;
        ntText := GetNoteText(iNewLineNo);
        iStatus := Save;
        if iStatus <> 0
        then ShowMessage('Could not Add note.'#13#13'Error No : ' + IntToStr(iStatus));
      end;{with}
    end;{AddNote}

    procedure EditNote(iNewLineNo : integer);
    var
      iLine, iStatus : integer;
      oUpdateNote : INotes;
    begin {EditNote}
      oUpdateNote := oToolkit.Transaction.thNotes.Update;
      if oUpdateNote = nil then
      begin
        ShowMessage('Could not Update note.'#13#13
        + 'oToolkit.Transaction.thNotes.Update Returned nil');
      end else
      begin
        with oUpdateNote do begin
          ntOperator := oEventData.UserName;
          ntLineNo := iNewLineNo;
          ntText := GetNoteText(iNewLineNo);
          iStatus := Save;
          if iStatus <> 0
          then ShowMessage('Could not Update note.'#13#13'Error No : ' + IntToStr(iStatus));
        end;{with}
      end;
    end;{EditNote}

  var
    iPos : integer;
  begin{AddNotes}
    // Delete any existing notes in lines 1..10
    oToolkit.Transaction.thNotes.ntType := ntTypeGeneral;
    For iPos := 1 to 10 do
    begin
      if SetupRec.CategoryUsed[iPos] then
      begin
        if oToolkit.Transaction.thNotes.GetEqual(oToolkit.Transaction.thNotes.BuildIndex(iPos)) = 0
        then EditNote(iPos)
        else AddNote(iPos);
      end;{if}
    end;{for}
  end;{AddNotes}

begin
  Screen.cursor := crHourglass;
  try
    UpdateUplift;
    AddNotes;
  finally
    Screen.cursor := crDefault;
  end;
  ModalResult := mrOK;
end;

function TfrmFreightCosts.IsBOMKit(sStockCode : string) : boolean;
var
  iStatus : integer;
begin{IsBOMKit}
  Result := FALSE;
  oToolkit.Stock.Index := stIdxCode;
  iStatus := oToolkit.Stock.GetEqual(oToolkit.Stock.BuildCodeIndex(Trim(sStockCode)));
  if iStatus = 0 then Result := oToolkit.Stock.stType = stTypeBillOfMaterials;
end;{IsBOMKit}

procedure TfrmFreightCosts.cmbCurrencyChange(Sender: TObject);
begin
  iCurrentCcy := TCurrencyInfo(cmbCurrency.Items.Objects[cmbCurrency.ItemIndex]).CurrencyNo;
  IncludeClick(nil);
end;

procedure TfrmFreightCosts.FormDestroy(Sender: TObject);
begin
  ClearList(cmbCurrency.Items);
end;

procedure TfrmFreightCosts.RBChange(Sender: TObject);
begin
  ChangeValues(Sender);
end;

procedure TfrmFreightCosts.EnableDisable;
begin
  lUnitUplift.Enabled := rbQuantity.Checked;
  lApportUplift.Enabled := lUnitUplift.Enabled;
  btnApply.Enabled := (StrToFloatDef(lApportUplift.Caption, 0) > 0)
  or ((not rbQuantity.Checked) and (StrToFloatDef(lTotalUplift.Caption, 0) > 0));

//  lApportUplift.Caption := 0.00;
end;

end.
