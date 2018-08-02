unit StockOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , BTFiles, Dialogs, CustAbsU, ExtCtrls, StdCtrls, TEditVal, WEEEProc
  , Enterprise01_TLB, TKPickList, MiscUtil, EnterToTab;

type
  TfrmStockOptions = class(TForm)
    lStockCode: TLabel;
    lDesc1: TLabel;
    lDesc2: TLabel;
    lDesc3: TLabel;
    lDesc4: TLabel;
    lDesc5: TLabel;
    panWEEEDetails: TPanel;
    Bevel2: TBevel;
    Label3: TLabel;
    Bevel1: TBevel;
    lchargeperkg: TLabel;
    lNoOfKgs: TLabel;
    lSetCharge: TLabel;
    lCharge: TLabel;
    Label8: TLabel;
    edSetValue: TCurrencyEdit;
    edChargePerKg: TCurrencyEdit;
    edNoOfKg: TCurrencyEdit;
    rbSetValue: TRadioButton;
    rbCalcValue: TRadioButton;
    cmbReportCat: TComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    Bevel3: TBevel;
    Bevel4: TBevel;
    lDesc6: TLabel;
    Label1: TLabel;
    EnterToTab1: TEnterToTab;
    cmbReportSubCat: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edChargeStockCodeChange(Sender: TObject);
    procedure edChargeStockCodeExit(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure ChangeValueMethod(Sender: TObject);
    procedure ChargeChange(Sender: TObject);
    procedure cmbReportCatChange(Sender: TObject);
  private
//    bStockCodeOK : boolean;
    FormMode : TFormMode;
    WEEEProductDetails : TWEEEProdRec;
    procedure FillReportSubCategoryList;
  public
    oStock : TAbsStock3;
  end;

var
  frmStockOptions: TfrmStockOptions;

implementation
uses
  APIUtil, StrUtil, BTUtil, BTConst;

{$R *.dfm}

procedure TfrmStockOptions.FormShow(Sender: TObject);
var
  iPos, iHeightToLose, iNoOfUselessDescLines : integer;

  procedure FillReportCategoryList;
  var
    BTRec : TBTRec;
    LReportCat : TWEEEReportCatRec;
    ReportCatInfo : TReportCatInfo;
  begin{FillReportCategoryList}
    ClearList(cmbReportCat.Items);
    BTRec.Status := BTFindRecord(BT_GetFirst, btFileVar[WEEEReportCatF], LReportCat
    , btBufferSize[WEEEReportCatF], wrcIdxCode, BTRec.KeyS);
    while BTRec.Status = 0 do
    begin
      // add cat into list
      ReportCatInfo := TReportCatInfo.Create;
      ReportCatInfo.Details := LReportCat;
      cmbReportCat.Items.AddObject(Trim(LReportCat.wrcCode) + ' : '
      + Trim(LReportCat.wrcDescription), ReportCatInfo);

      // next record
      BTRec.Status := BTFindRecord(BT_GetNext, btFileVar[WEEEReportCatF], LReportCat
      , btBufferSize[WEEEReportCatF], wrcIdxCode, BTRec.KeyS);
    end;{while}
  end;{FillReportCategoryList}

  procedure FillDetails;
  var
    BTRec : TBTRec;

    procedure Record2Form;
    var
      iPos : integer;
    begin{Record2Form}
      // select report category
      For iPos := 0 to cmbReportCat.Items.Count -1 do
      begin
        if TReportCatInfo(cmbReportCat.Items.Objects[iPos]).Details.wrcFolioNo
        = WEEEProductDetails.wpReportCatFolio then
        begin
          cmbReportCat.Itemindex := iPos;
          FillReportSubCategoryList;
          break;
        end;{if}
      end;{for}

      // select report Sub category
      For iPos := 0 to cmbReportSubCat.Items.Count -1 do
      begin
        if TReportSubCatInfo(cmbReportSubCat.Items.Objects[iPos]).Details.wscFolioNo
        = WEEEProductDetails.wpReportSubCatFolio then
        begin
          cmbReportSubCat.Itemindex := iPos;
          break;
        end;{if}
      end;{for}

//      edChargeStockCode.Text := WEEEProductDetails.wpExtraChargeStockCode;
//      edProducer.Text := WEEEProductDetails.wpProducer;

      if WEEEProductDetails.wpChargeType = CT_SET_VALUE then rbSetValue.Checked := TRUE
      else rbCalcValue.Checked := TRUE;
      edSetValue.Value := WEEEProductDetails.wpSetValue;
      edChargePerKg.Value := WEEEProductDetails.wpValuePerKilo;
      edNoOfKg.Value := WEEEProductDetails.wpNoOfKilos;
    end;{Record2Form}

  begin{FillDetails}
    BTRec.KeyS := PadString(psRight, oStock.stCode, ' ', 16);
    BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEProdF], WEEEProductDetails
    , btBufferSize[WEEEProdF], wpIdxStockCode, BTRec.KeyS);
    if BTRec.Status = 0 then
    begin
      FormMode := fmEdit;
      Record2Form;
    end else
    begin
      FormMode := fmAdd;
      FillChar(WEEEProductDetails, SizeOf(WEEEProductDetails), #0);
      WEEEProductDetails.wpStockCode := oStock.stCode;
    end;{if}
  end;{FillDetails}

begin
//  bStockCodeOK := FALSE;
  edSetValue.displayformat := '#######0.' + StringOfChar('0', oToolkit.SystemSetup.ssSalesDecimals);

  lStockCode.Caption := oStock.stCode;
  lDesc1.Caption := oStock.stDesc[1];
  lDesc2.Caption := oStock.stDesc[2];
  lDesc3.Caption := oStock.stDesc[3];
  lDesc4.Caption := oStock.stDesc[4];
  lDesc5.Caption := oStock.stDesc[5];
  lDesc6.Caption := oStock.stDesc[6];

  iNoOfUselessDescLines := 0;
  For iPos := 6 downto 1 do begin
    if Trim(oStock.stDesc[iPos]) = ''
    then inc(iNoOfUselessDescLines)
    else break;
  end;{for}

  iHeightToLose := (iNoOfUselessDescLines * 16);
  ClientHeight := ClientHeight - iHeightToLose;
  panWEEEDetails.Top := panWEEEDetails.Top - iHeightToLose;

  OpenFiles;
  FillReportCategoryList;
  FillReportSubCategoryList;
  FillDetails;

  ChangeValueMethod(nil);
end;

procedure TfrmStockOptions.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmStockOptions.btnOKClick(Sender: TObject);

  function Validate : boolean;
  var
    iError : integer;
  const
    asErrors : array [1..2] of string = ('Report Category', 'Report Sub Category');
  begin{Validate}
    iError := 0;
    if cmbReportCat.ItemIndex = -1 then iError := 1
    else begin
      if cmbReportSubCat.ItemIndex = -1 then iError := 2;
{      if not bStockCodeOK then iError := 2
      else begin
      end;{if}
    end;{if}

    Result := iError = 0;

    if iError > 0 then
    begin
      MsgBox('Validation Error : ' + asErrors[iError], mtError, [mbOK],mbOk, 'Validation Error');
      case iError of
        1 : ActiveControl := cmbReportCat;
        2 : ActiveControl := cmbReportSubCat;
      end;{case}
    end;
  end;{Validate}

  procedure Form2Record;
  begin
    WEEEProductDetails.wpReportCatFolio
    := TReportCatInfo(cmbReportCat.Items.Objects[cmbReportCat.ItemIndex]).Details.wrcFolioNo;
    WEEEProductDetails.wpReportSubCatFolio
    := TReportSubCatInfo(cmbReportSubCat.Items.Objects[cmbReportSubCat.ItemIndex]).Details.wscFolioNo;
//    WEEEProductDetails.wpExtraChargeStockCode := edChargeStockCode.Text;
//    WEEEProductDetails.wpProducer := edProducer.Text;

    if rbSetValue.Checked then WEEEProductDetails.wpChargeType := CT_SET_VALUE
    else WEEEProductDetails.wpChargeType := CT_CALC_VALUE;
    WEEEProductDetails.wpSetValue := StrToFloatDef(edSetValue.Text, 0);
    WEEEProductDetails.wpValuePerKilo := StrToFloatDef(edChargePerKg.Text, 0);
    WEEEProductDetails.wpNoOfKilos := StrToFloatDef(edNoOfKg.Text, 0);
    WEEEProductDetails.wpValue := StrToFloatDef(lCharge.Caption, 0);
  end;

var
  BTRec : TBTRec;
  LWEEEProductDetails : TWEEEProdRec;

begin
  if Validate then
  begin
    Form2Record;

    case FormMode of
      fmAdd : begin
        BTRec.Status := BTAddRecord(btFileVar[WEEEProdF], WEEEProductDetails
        , btBufferSize[WEEEProdF], 0);
        BTShowError(BTRec.Status, 'BTAddRecord', CompanyRec.Path + btFileName[WEEEProdF]);
      end;

      fmEdit : begin
        BTRec.KeyS := PadString(psRight, WEEEProductDetails.wpStockCode, ' ', 16);
        BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEProdF], LWEEEProductDetails
        , btBufferSize[WEEEProdF], wpIdxStockCode, BTRec.KeyS);
        if BTRec.Status = 0 then
        begin
          BTRec.Status := BTUpdateRecord(btFileVar[WEEEProdF], WEEEProductDetails
          , btBufferSize[WEEEProdF], wrcIdxFolio, BTRec.KeyS);
          BTShowError(BTRec.Status, 'BTUpdateRecord', CompanyRec.Path + btFileName[WEEEProdF]);
        end else
        begin
          BTShowError(BTRec.Status, 'BTFindRecord', CompanyRec.Path + btFileName[WEEEProdF]);
        end;{if}
      end;
    end;{case}
    if BTRec.Status = 0 then Close;
  end;{if}
end;

procedure TfrmStockOptions.FormDestroy(Sender: TObject);
begin
  CloseFiles;
end;

procedure TfrmStockOptions.edChargeStockCodeChange(Sender: TObject);
begin
{  lProductName.Caption := '';
  with oToolkit.Stock do begin
    Index := stIdxCode;
    if GetEqual(BuildCodeIndex(edChargeStockCode.text)) = 0
    then begin
      lProductName.Caption := stDesc[1];
//      bStockCodeOK := TRUE;
    end else
    begin
//      bStockCodeOK := FALSE;
    end;{if}
{  end;{with}
//  EnableDisable;
end;

procedure TfrmStockOptions.edChargeStockCodeExit(Sender: TObject);
begin
//  edChargeStockCode.text := UpperCase(edChargeStockCode.text);
end;

procedure TfrmStockOptions.btnBrowseClick(Sender: TObject);
{var
  oStock : IStock;}
begin
{  with TfrmTKPickList.CreateWith(self, oToolkit) do begin
    plType := plProductInAGroup;
    sParentCode := SystemSetupRec.ProductGroup;
    sFind := edChargeStockCode.Text;
    iSearchCol := 0;
    if showmodal = mrOK then begin
      oStock := ctkDataSet.GetRecord as IStock;
      edChargeStockCode.Text := oStock.stCode;
    end;{if}
{    release;
  end;{with}
end;

procedure TfrmStockOptions.ChangeValueMethod(Sender: TObject);
begin
  edSetValue.Enabled := rbSetValue.Checked;
  lSetCharge.Enabled := edSetValue.Enabled;
  edChargePerKg.Enabled :=  rbCalcValue.checked;
  edNoOfKg.Enabled := edChargePerKg.Enabled;
  lchargeperkg.Enabled := edChargePerKg.Enabled;
  lNoOfKgs.Enabled := edChargePerKg.Enabled;
  ChargeChange(nil);
end;

procedure TfrmStockOptions.ChargeChange(Sender: TObject);
begin
  if rbSetValue.Checked then lCharge.Caption := edSetValue.Text
  else lCharge.Caption := MoneyToStr(StrToFloatDef(edChargePerKg.Text, 0)
  * StrToFloatDef(edNoOfKg.Text, 0), oToolkit.SystemSetup.ssSalesDecimals);
end;

procedure TfrmStockOptions.FillReportSubCategoryList;
var
  BTRec : TBTRec;
  LReportSubCat : TWEEEReportSubCatRec;
  ReportSubCatInfo : TReportSubCatInfo;
  iCurrentCatFolio : integer;
begin{FillReportSubCategoryList}
  ClearList(cmbReportSubCat.Items);
  if cmbReportCat.ItemIndex < 0 then exit;
  iCurrentCatFolio := TReportCatInfo(cmbReportCat.Items.Objects[cmbReportCat.ItemIndex]).Details.wrcFolioNo;
  BTRec.KeyS := BTFullNomKey(iCurrentCatFolio);
  BTRec.Status := BTFindRecord(BT_GetGreaterOrEqual, btFileVar[WEEEReportSubCatF], LReportSubCat
  , btBufferSize[WEEEReportSubCatF], wscIdxCatCode, BTRec.KeyS);
  while (BTRec.Status = 0) and (LReportSubCat.wscCatFolioNo = iCurrentCatFolio) do
  begin
    // add cat into list
    ReportSubCatInfo := TReportSubCatInfo.Create;
    ReportSubCatInfo.Details := LReportSubCat;
    cmbReportSubCat.Items.AddObject(Trim(LReportSubCat.wscCode) + ' : '
    + Trim(LReportSubCat.wscDescription), ReportSubCatInfo);

    // next record
    BTRec.Status := BTFindRecord(BT_GetNext, btFileVar[WEEEReportSubCatF], LReportSubCat
    , btBufferSize[WEEEReportSubCatF], wscIdxCatCode, BTRec.KeyS);
  end;{while}
end;{FillReportSubCategoryList}



procedure TfrmStockOptions.cmbReportCatChange(Sender: TObject);
begin
  FillReportSubCategoryList;
end;

end.
