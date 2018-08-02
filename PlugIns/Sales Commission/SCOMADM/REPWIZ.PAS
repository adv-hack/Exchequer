unit RepWiz;

interface

uses
  {$IFDEF PRE_571002_MULTILIST}
    Enterprise01_TLB,
  {$ELSE}
    EnterpriseBeta_TLB,
  {$ENDIF}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ExtCtrls, ComCtrls, Buttons, uExDatasets,
  uComTKDataset, uMultiList, uDBMultiList, Enterprise01_TLB, VarConst, Reports,
  Key, uBtrieveDataset, BtrvU2, GlobVar, StrUtil, MiscUtil, Menus, uSettings;

type
  TfrmRepWizard = class(TForm)
    pcWizard: TPageControl;
    tsFilters: TTabSheet;
    tsRanges: TTabSheet;
    tsConditions: TTabSheet;
    btnNext: TButton;
    btnPrevious: TButton;
    btnCancel: TButton;
    tsTXtype: TTabSheet;
    Bevel5: TBevel;
    Bevel6: TBevel;
    lTXCurrency: TLabel;
    cbFilterByTXCurrency: TCheckBox;
    cbOnlyIncludePaidOffTXs: TCheckBox;
    lConvertCurrency: TLabel;
    cbGeneratePJI: TCheckBox;
    Label8: TLabel;
    lbTXs: TCheckListBox;
    tsCustomer: TTabSheet;
    Bevel2: TBevel;
    Bevel1: TBevel;
    lIncludeCustAccType: TLabel;
    edIncludeCustAccType: TEdit;
    cbFilterByCustAccType: TCheckBox;
    Label7: TLabel;
    Label9: TLabel;
    edDateFrom: TDateTimePicker;
    Label10: TLabel;
    Label11: TLabel;
    edDateTo: TDateTimePicker;
    Label12: TLabel;
    rbPickSalesCodes: TRadioButton;
    rbPickSalesCodeTypes: TRadioButton;
    Bevel7: TBevel;
    Bevel8: TBevel;
    TabSheet1: TTabSheet;
    Bevel9: TBevel;
    Bevel10: TBevel;
    Bevel11: TBevel;
    Bevel12: TBevel;
    rbProduct: TRadioButton;
    rbProdGroup: TRadioButton;
    mlCustomers: TDBMultiList;
    cdsCustomers: TComTKDataset;
    Label1: TLabel;
    cmbTXCurrency: TComboBox;
    mlSalesCodes: TDBMultiList;
    bdsSalesCode: TBtrieveDataset;
    Bevel15: TBevel;
    Bevel16: TBevel;
    Label2: TLabel;
    mlSalesCodeTypes: TDBMultiList;
    bdsSalesCodeType: TBtrieveDataset;
    cdsProducts: TComTKDataset;
    mlProducts: TDBMultiList;
    cdsProdGroup: TComTKDataset;
    mlProdGroups: TDBMultiList;
    cmbConvertCurrency: TComboBox;
    cbCostAllocLineCost: TCheckBox;
    pmMain: TPopupMenu;
    Properties1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    btnCuSelectAll: TButton;
    btnTXSelectAll: TButton;
    btnPrSelectAll: TButton;
    btnPGSelectAll: TButton;
    btnSCSelectAll: TButton;
    btnSCTSelectAll: TButton;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel13: TBevel;
    Bevel14: TBevel;
    Bevel17: TBevel;
    Bevel18: TBevel;
    procedure btnNextClick(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure pcWizardChange(Sender: TObject);
    procedure lSelectAllCoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SelectDeselectAll(Sender: TObject);
    procedure SelectDeselectAllMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SelectDeselectAllMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cdsCustomersGetFieldValue(Sender: TObject; ID: IDispatch;
      FieldName: String; var FieldValue: String);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure MultiListRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure MultiListMultiSelect(Sender: TObject);
    procedure pcWizardChanging(Sender: TObject; var AllowChange: Boolean);
    procedure edDateChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbFilterByCustAccTypeClick(Sender: TObject);
    procedure lbTXsClickCheck(Sender: TObject);
    procedure panTXSelectAllClick(Sender: TObject);
    procedure cbFilterByTXCurrencyClick(Sender: TObject);
    procedure bdsSalesCodeGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure bdsSalesCodeFilterRecord(Sender: TObject; PData: Pointer;
      var Include: Boolean);
    procedure rbPickSalesCodesClick(Sender: TObject);
    procedure bdsSalesCodeTypeGetFieldValue(Sender: TObject;
      PData: Pointer; FieldName: String; var FieldValue: String);
    procedure Button3Click(Sender: TObject);
    procedure cdsProductsGetFieldValue(Sender: TObject; ID: IDispatch;
      FieldName: String; var FieldValue: String);
    procedure cdsProductsFilterRecord(Sender: TObject; ID: IDispatch;
      var Include: Boolean);
    procedure cdsProdGroupFilterRecord(Sender: TObject; ID: IDispatch;
      var Include: Boolean);
    procedure rbProductClick(Sender: TObject);
    procedure cbGeneratePJIClick(Sender: TObject);
    procedure cmbConvertCurrencyChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Properties1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    bRestore, bSelectAll : boolean;
    procedure SaveAllSettings;
    procedure LoadAllSettings;
    procedure PageChange;
    procedure FillReportCriteria;
  public

  end;

var
  frmRepWizard: TfrmRepWizard;

implementation
uses
  SComProc;

{$R *.dfm}

procedure TfrmRepWizard.btnNextClick(Sender: TObject);
begin
  if btnNext.Caption = '&Run Report' then
    begin
      FillReportCriteria;
      ModReports.ReportCriteria.FillAllListObjects;
      ModReports.PrintSalesCommission;
    end
  else begin
    pcWizard.ActivePage := pcWizard.Pages[pcWizard.ActivePage.PageIndex + 1];
    PageChange;
  end;{if}
end;

procedure TfrmRepWizard.btnPreviousClick(Sender: TObject);
begin
  pcWizard.ActivePage := pcWizard.Pages[pcWizard.ActivePage.PageIndex - 1];
  PageChange;
end;

procedure TfrmRepWizard.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmRepWizard.pcWizardChange(Sender: TObject);
begin
  PageChange;
end;

procedure TfrmRepWizard.FillReportCriteria;
var
  KeyS : Str255;
  iFound : integer;

  procedure GetCustomersPicked;
  begin{GetCustomersPicked}
    ModReports.ReportCriteria.slCustomers.Assign(mlCustomers.MultiSelected);
  end;{GetCustomersPicked}

  procedure GetSalesCodesPicked;
  begin{GetSalesCodesPicked}
    ModReports.ReportCriteria.slSalesCodes.Assign(mlSalesCodes.MultiSelected);
  end;{GetSalesCodesPicked}

  procedure GetSalesCodeTypesPicked;
  begin{GetSalesCodeTypesPicked}
    ModReports.ReportCriteria.slSalesCodeTypes.Assign(mlSalesCodeTypes.MultiSelected);
  end;{GetSalesCodeTypesPicked}

  procedure GetProductsPicked;
  begin{GetProductsPicked}
    ModReports.ReportCriteria.slProducts.Assign(mlProducts.MultiSelected);
  end;{GetProductsPicked}

  procedure GetProdGroupsPicked;
  begin{GetProdGroupsPicked}
    ModReports.ReportCriteria.slProdGroups.Assign(mlProdGroups.MultiSelected);
  end;{GetProdGroupsPicked}

  procedure FillTXTypesToInclude;
  var
    iPos : integer;
  begin{FillTXTypesToInclude}
    ClearList(ModReports.ReportCriteria.slTXTypes);
    for iPos := 0 to lbTXs.count -1 do begin
      if lbTXs.checked[iPos] then begin
        ModReports.ReportCriteria.slTXTypes.Add(Copy(lbTXs.Items[iPos],length(lbTXs.Items[iPos]) - 3,3));
      end;{if}
    end;{for}
  end;{FillTXTypesToInclude}

begin{FillReportCriteria}
  with ModReports.ReportCriteria do begin
    // page 1
    dDateFrom := edDateFrom.Date;
    dDateTo := edDateTo.Date;

    // page 2
    GetCustomersPicked;
    bFilterByCustAccType := cbFilterByCustAccType.Checked;
    sIncludeCustAccType := edIncludeCustAccType.text;

    // page 3
    FillTXTypesToInclude;
    bOnlyIncludePaidOffTXs := cbOnlyIncludePaidOffTXs.Checked;
    bFilterByTXCurrency := cbFilterByTXCurrency.checked;
    iTXCurrencyFilter := cmbTXCurrency.ItemIndex + 1;

    // page 4
    GetProductsPicked;
    GetProdGroupsPicked;

    // page 5
    GetSalesCodesPicked;
    GetSalesCodeTypesPicked;
    bPickSalesCodes := rbPickSalesCodes.checked;

    // page 6
    iConvertCurrency := cmbConvertCurrency.ItemIndex + 1;
    bGeneratePJI := cbGeneratePJI.checked;
    bCostAllocLineCost := cbCostAllocLineCost.Checked;

  end;{with}
end;{FillReportCriteria}

procedure TfrmRepWizard.PageChange;

  function GetCheckCount(CheckListBox : TCheckListBox) : integer;
  var
    iPos : integer;
  begin{GetCheckCount}
    Result := 0;
    for iPos := 0 to lbTXs.count -1 do begin
      if lbTXs.checked[iPos] then Result := Result + 1;
    end;{for}
  end;{GetCheckCount}

begin{PageChange}
  btnPrevious.enabled := pcWizard.ActivePage.PageIndex <> 0;
//  btnNext.enabled := pcWizard.ActivePage.PageIndex <> (pcWizard.PageCount - 1);
  btnNext.enabled := true;

  FillReportCriteria;

  if btnNext.enabled then begin
    btnNext.Caption := '&Next >>';
    with ModReports.ReportCriteria do begin
      case pcWizard.ActivePage.PageIndex of
        0 : if (edDateFrom.Date - edDateTo.Date) > 0 then btnNext.enabled := FALSE;
        1 : if slCustomers.Count = 0 then btnNext.enabled := FALSE;
        2 : if GetCheckCount(lbTXs) = 0 then btnNext.enabled := FALSE;
        3 : begin
          if rbProduct.Checked and (slProducts.Count <= 0) then btnNext.enabled := FALSE;
          if rbProdGroup.Checked and (slProdGroups.Count <= 0) then btnNext.enabled := FALSE;
        end;
        4 : begin
          if rbPickSalesCodes.Checked and (slSalesCodes.Count <= 0) then btnNext.enabled := FALSE;
          if rbPickSalesCodeTypes.Checked and (slSalesCodeTypes.Count <= 0) then btnNext.enabled := FALSE;
        end;
        5 : btnNext.Caption := '&Run Report';
      end;{case}
    end;{with}
  end;{if}
end;

procedure TfrmRepWizard.lSelectAllCoMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  TLabel(Sender).Font.Style := [fsUnderline];
end;

procedure TfrmRepWizard.SelectDeselectAll(Sender: TObject);

  procedure SelectDeselect(sName : string; bSetTo : boolean);
  var
    iPos : integer;
    lbListBox : TCheckListBox;
    mlMultiList : TDBMultiList;
  begin{SelectDeselect}
    lbListBox := nil;
    mlMultiList := nil;
//    if sName = 'panCoSelectAll' then lbListBox := lbCompanies;
    if sName = 'btnCuSelectAll' then mlMultiList := mlCustomers;
    if sName = 'btnTXSelectAll' then lbListBox := lbTxs;
    if sName = 'btnSCSelectAll' then mlMultiList := mlSalesCodes;
    if sName = 'btnSCTSelectAll' then mlMultiList := mlSalesCodeTypes;
    if sName = 'btnPrSelectAll' then mlMultiList := mlProducts;
    if sName = 'btnPGSelectAll' then mlMultiList := mlProdGroups;

    if lbListBox <> nil then begin
      For iPos := 0 to lbListBox.Items.Count -1 do lbListBox.Checked[iPos] := bSetTo;
    end;{if}

    if mlMultiList <> nil then begin
      if bSetTo then mlMultiList.MultiSelectAll
      else mlMultiList.MultiSelectClear;
    end;{if}
  end;{SelectDeselect}

begin{SelectDeselectAll}
  bSelectAll := TRUE;
  screen.Cursor := crHourglass;
  with TPanel(Sender) do begin

    SelectDeselect(Name, Tag = 1);

    Case Tag of
      // Deselect all clicked
      0 : begin
        Caption := 'Select All';
        Tag := 1;
      end;

      // Select all clicked
      1 : begin
        Caption := 'Deselect All';
        Tag := 0;
      end;
    end;{case}
  end;{with}
  screen.Cursor := crDefault;
  bSelectAll := FALSE;
  PageChange;
end;

procedure TfrmRepWizard.SelectDeselectAllMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TPanel(Sender).Font.Style := [fsBold];
end;

procedure TfrmRepWizard.SelectDeselectAllMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TPanel(Sender).Font.Style := [];
end;

procedure TfrmRepWizard.cdsCustomersGetFieldValue(Sender: TObject;
  ID: IDispatch; FieldName: String; var FieldValue: String);
begin
  with (ID as IAccount) do begin
    case FieldName[1] of
      'C' : FieldValue := acCode;
      'D' : FieldValue := acCompany;
    end;{case}
  end;{with}
end;

procedure TfrmRepWizard.FormShow(Sender: TObject);

  procedure SelectTXDefaults;
  var
    iPos : integer;
  begin{SelectTXDefaults}
    for iPos := 0 to lbTXs.count - 1 do begin
      if iPos in [0..5] then lbTXs.Checked[iPos] := TRUE;
    end;{for}
  end;{SelectTXDefaults}

begin{FormShow}
  ModReports.ReportCriteria := TReportCriteria.create;

  pcWizard.ActivePage := pcWizard.Pages[0];

  edDateFrom.Date := SysUtils.Date;
  edDateTo.Date := SysUtils.Date;

  // init customer list
  {$IFDEF PRE_571002_MULTILIST}
    cdsCustomers.ToolkitObject := oToolkit.customer as IBtrieveFunctions2;
    cdsProducts.ToolkitObject := oToolkit.Stock as IBtrieveFunctions2;
    cdsProdGroup.ToolkitObject := oToolkit.Stock as IBtrieveFunctions2;
  {$ELSE}
    cdsCustomers.ToolkitObject := oToolkit.customer as IDatabaseFunctions;
    cdsProducts.ToolkitObject := oToolkit.Stock as IDatabaseFunctions;
    cdsProdGroup.ToolkitObject := oToolkit.Stock as IDatabaseFunctions;
  {$ENDIF}
  mlCustomers.Dataset := cdsCustomers;
  mlProducts.Dataset := cdsProducts;
  mlProdGroups.Dataset := cdsProdGroup;

  // init sales code List
  bdsSalesCode.FileName := FileNames[SalesCodeF];
  mlSalesCodes.Active := TRUE;

  // init sales code List
  bdsSalesCodeType.FileName := FileNames[SalesCodeTypeF];
  mlSalesCodeTypes.Active := TRUE;

  SelectTXDefaults;

  cbFilterByTXCurrency.Enabled := (oToolkit.SystemSetup.ssCurrencyVersion <> enProfessional);
  cmbConvertCurrency.Enabled := cbFilterByTXCurrency.Enabled;
  lConvertCurrency.Enabled := cbFilterByTXCurrency.Enabled;

  if cbFilterByTXCurrency.Enabled then
  begin
    FillCurrencyCombo(cmbTXCurrency);
    cmbTXCurrency.ItemIndex := 0;

    FillCurrencyCombo(cmbConvertCurrency);
    cmbConvertCurrency.ItemIndex := 0;
  end;

end;{FormShow}

procedure TfrmRepWizard.Button1Click(Sender: TObject);
var
  iPos : integer;
  sString : string;
begin
  FillReportCriteria;
  sString := '';
  For iPos := 0 to ModReports.ReportCriteria.slSalesCodes.count - 1 do begin
    sString := sString + ModReports.ReportCriteria.slSalesCodes[iPos] + ', ';
  end;{for}
  ShowMessage(sString);
end;

procedure TfrmRepWizard.MultiListRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  with Sender as TDBMultiList
  do MultiSelect(DesignColumns[0].Items[Selected], RowIndex);
end;

procedure TfrmRepWizard.MultiListMultiSelect(Sender: TObject);
begin
 if not bSelectAll then PageChange;
end;

procedure TfrmRepWizard.pcWizardChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange := (btnNext.enabled
  and (btnNext.caption = '&Next >>') and (pcWizard.ActivePage = pcWizard.Pages[pcWizard.ActivePage.PageIndex + 1]))
  or (btnPrevious.enabled
  and (pcWizard.ActivePage = pcWizard.Pages[pcWizard.ActivePage.PageIndex - 1]))
end;

procedure TfrmRepWizard.edDateChange(Sender: TObject);
begin
  PageChange;
end;

procedure TfrmRepWizard.FormDestroy(Sender: TObject);
begin
  ModReports.ReportCriteria.Destroy;
end;

procedure TfrmRepWizard.cbFilterByCustAccTypeClick(Sender: TObject);
begin
  edIncludeCustAccType.Enabled := cbFilterByCustAccType.Checked;
  lIncludeCustAccType.Enabled := edIncludeCustAccType.Enabled;
end;

procedure TfrmRepWizard.lbTXsClickCheck(Sender: TObject);
begin
  PageChange;
end;

procedure TfrmRepWizard.panTXSelectAllClick(Sender: TObject);
begin
  SelectDeselectAll(Sender);
end;

procedure TfrmRepWizard.cbFilterByTXCurrencyClick(Sender: TObject);
begin
  cmbTXCurrency.Enabled := cbFilterByTXCurrency.Checked;
  lTXCurrency.Enabled := cmbTXCurrency.Enabled;
end;

procedure TfrmRepWizard.bdsSalesCodeGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
begin
  with TSalesCodeRec(PData^) do begin
    case FieldName[1] of
      'C' : FieldValue := scSalesCode;
      'D' : FieldValue := scDescription;
    end;{case}
  end;{with}
end;

procedure TfrmRepWizard.bdsSalesCodeFilterRecord(Sender: TObject;
  PData: Pointer; var Include: Boolean);
begin
  with TSalesCodeRec(PData^) do begin
    Include := scStatus = 1;
  end;{with}
end;

procedure TfrmRepWizard.rbPickSalesCodesClick(Sender: TObject);
begin
  PageChange;

  mlSalesCodes.Enabled := rbPickSalesCodes.Checked;
  btnSCSelectAll.Enabled := mlSalesCodes.Enabled;
  mlSalesCodeTypes.Enabled := not mlSalesCodes.Enabled;
  btnSCTSelectAll.Enabled := mlSalesCodeTypes.Enabled;

  if mlSalesCodes.Enabled then mlSalesCodeTypes.MultiSelectClear
  else mlSalesCodes.MultiSelectClear;
end;

procedure TfrmRepWizard.bdsSalesCodeTypeGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
begin
  with TSalesCodeTypeRec(PData^) do begin
    case FieldName[1] of
      'D' : FieldValue := sctDescription;
    end;{case}
  end;{with}
end;

procedure TfrmRepWizard.Button3Click(Sender: TObject);
var
  sString : string;
  iPos : integer;
begin
  sString := '';
  For iPos := 0 to ModReports.ReportCriteria.slCustomers.count - 1 do begin
    sString := sString + ModReports.ReportCriteria.slCustomers[iPos] + ', ';
  end;{for}
  ShowMessage('slCustomers : ' + sString);

  sString := '';
  For iPos := 0 to ModReports.ReportCriteria.slSalesCodes.count - 1 do begin
    sString := sString + ModReports.ReportCriteria.slSalesCodes[iPos] + ', ';
  end;{for}
  ShowMessage('slSalesCodes : ' + sString);

  sString := '';
  For iPos := 0 to ModReports.ReportCriteria.slSalesCodeTypes.count - 1 do begin
    sString := sString + ModReports.ReportCriteria.slSalesCodeTypes[iPos] + ', ';
  end;{for}
  ShowMessage('slSalesCodeTypes : ' + sString);
end;

procedure TfrmRepWizard.cdsProductsGetFieldValue(Sender: TObject;
  ID: IDispatch; FieldName: String; var FieldValue: String);
begin
  with (ID as IStock) do begin
    case FieldName[1] of
      'C' : FieldValue := stCode;
      'D' : FieldValue := stDesc[1];
    end;{case}
  end;{with}
end;

procedure TfrmRepWizard.cdsProductsFilterRecord(Sender: TObject;
  ID: IDispatch; var Include: Boolean);
begin
  with (ID as IStock) do begin
    Include := stType in [stTypeProduct, stTypeDescription, stTypeBillOfMaterials];
  end;{with}
end;

procedure TfrmRepWizard.cdsProdGroupFilterRecord(Sender: TObject;
  ID: IDispatch; var Include: Boolean);
begin
  with (ID as IStock) do begin
    Include := stType = stTypeGroup;
  end;{with}
end;

procedure TfrmRepWizard.rbProductClick(Sender: TObject);
begin
  PageChange;

  mlProducts.Enabled := rbProduct.Checked;
  btnPrSelectAll.Enabled := mlProducts.Enabled;
  mlProdGroups.Enabled := not mlProducts.Enabled;
  btnPGSelectAll.Enabled := mlProdGroups.Enabled;

  if mlProducts.Enabled then mlProdGroups.MultiSelectClear
  else mlProducts.MultiSelectClear;
end;

procedure TfrmRepWizard.cbGeneratePJIClick(Sender: TObject);
begin
  PageChange;
end;

procedure TfrmRepWizard.cmbConvertCurrencyChange(Sender: TObject);
begin
  PageChange;
end;

procedure TfrmRepWizard.FormCreate(Sender: TObject);
begin
  bRestore := FALSE;
  LoadAllSettings;
end;

procedure TfrmRepWizard.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;
end;

procedure TfrmRepWizard.LoadAllSettings;
begin
  oSettings.LoadForm(Self);
  oSettings.LoadParentToControl(Self.Name, Self.Name, edDateFrom);
  oSettings.ColorFieldsFrom(edDateFrom, Self);
  oSettings.LoadList(mlCustomers, Self.Name);
  oSettings.CopyList(mlCustomers, mlProducts);
  oSettings.CopyList(mlCustomers, mlProdGroups);
  oSettings.CopyList(mlCustomers, mlSalesCodes);
  oSettings.CopyList(mlCustomers, mlSalesCodeTypes);
end;

procedure TfrmRepWizard.SaveAllSettings;
begin
  oSettings.SaveParentFromControl(edDateFrom, Self.Name);
  oSettings.SaveList(mlCustomers, Self.Name);
  if SaveCoordinates1.checked then oSettings.SaveForm(Self);
end;

procedure TfrmRepWizard.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(mlCustomers, Self.Name, edDateFrom) of
    mrOK : begin
      oSettings.ColorFieldsFrom(edDateFrom, Self);
      oSettings.CopyList(mlCustomers, mlProducts);
      oSettings.CopyList(mlCustomers, mlProdGroups);
      oSettings.CopyList(mlCustomers, mlSalesCodes);
      oSettings.CopyList(mlCustomers, mlSalesCodeTypes);
    end;
    mrRestoreDefaults : begin
      oSettings.RestoreListDefaults(mlCustomers, Self.Name);
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TfrmRepWizard.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TfrmRepWizard.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

end.
