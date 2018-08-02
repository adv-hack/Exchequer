unit SysSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TKPickList, ExtCtrls, Menus, StdCtrls, ComCtrls, Enterprise01_TLB,
  uExDatasets, uBtrieveDataset, uMultiList, uDBMultiList, BTConst, BTUtil,
  EnterToTab;

const
  {$IFDEF EX600}
    sVersionNo = '010';
//    sVersionNo = 'v6.00.008';
  {$ELSE}
    sVersionNo = 'v5.71.008';
  {$ENDIF}

type
  TfrmWEEESetup = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Import1: TMenuItem;
    Export1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    pcTabs: TPageControl;
    tsGeneral: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cmbStockFlagUDF: TComboBox;
    cmbCustomerUDF: TComboBox;
    cmbSupplierUDF: TComboBox;
    cmbTXLineUDF: TComboBox;
    btnOK: TButton;
    tsReportCats: TTabSheet;
    btnAddCat: TButton;
    btnEditCat: TButton;
    btnDeleteCat: TButton;
    Help1: TMenuItem;
    About1: TMenuItem;
    Label6: TLabel;
    cmbCompany: TComboBox;
    mlReportCats: TDBMultiList;
    bdsReportCats: TBtrieveDataset;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    cbShowWEEEValuePopup: TCheckBox;
    EnterToTab1: TEnterToTab;
    Label1: TLabel;
    Label7: TLabel;
    mlReportSubCats: TDBMultiList;
    bdsReportSubCats: TBtrieveDataset;
    Reports1: TMenuItem;
    RunWEEEReport1: TMenuItem;
    cmbStockEMCUDF: TComboBox;
    cmbStockITCUDF: TComboBox;
    Label8: TLabel;
    Label9: TLabel;
    btnAddSubCat: TButton;
    btnEditSubCat: TButton;
    btnDeleteSubCat: TButton;
    procedure Image1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAddCatClick(Sender: TObject);
    procedure btnEditCatClick(Sender: TObject);
    procedure lbReportCatsClick(Sender: TObject);
    procedure btnDeleteCatClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure lbReportCatsDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmbCompanyChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure bdsReportCatsGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure mlReportCatsRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure edProductGroupChange(Sender: TObject);
    procedure edProductGroupExit(Sender: TObject);
    procedure btnGroupBrowseClick(Sender: TObject);
    procedure Export1Click(Sender: TObject);
    procedure Import1Click(Sender: TObject);
    procedure bdsReportSubCatsGetFieldValue(Sender: TObject;
      PData: Pointer; FieldName: String; var FieldValue: String);
    procedure StockUDFChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnAddSubCatClick(Sender: TObject);
    procedure btnEditSubCatClick(Sender: TObject);
    procedure mlReportSubCatsRowDblClick(Sender: TObject;
      RowIndex: Integer);
    procedure mlReportCatsChangeSelection(Sender: TObject);
    procedure RunWEEEReport1Click(Sender: TObject);
  private
    iCurrentCompanyIndex : integer;
    function WriteSetupToINI : boolean;
    procedure ReadSetupFromINI;
    procedure EnableDisable;
    { Public declarations }
  end;

var
  frmWEEESetup: TfrmWEEESetup;

implementation

uses
  ReportCriteria, ReportCatDetails, BTFiles, SecCodes, ComObj, WEEEProc, StrUtil, APIUtil
  , MiscUtil, inifiles, FileUtil, Import, ETStrU, ExchequerRelease;

{$R *.dfm}

procedure TfrmWEEESetup.Image1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmWEEESetup.Exit1Click(Sender: TObject);
begin
  btnOKClick(btnOK);
end;

procedure TfrmWEEESetup.btnOKClick(Sender: TObject);
begin
{  if WriteSetupToINI then
  begin
    oToolkit.CloseToolkit;
    CloseFiles;
    Close;
  end;{if}
  Close;
end;

procedure TfrmWEEESetup.FormCreate(Sender: TObject);

  procedure InitToolkit;
  var
    iSelectIndex, iPos : integer;
    CompanyInfo : TCompanyInfo;
    a, b, c : LongInt;
  begin{InitToolkit}
    // Create COM Toolkit object
    oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

    // Check it created OK
    If Assigned(oToolkit) Then Begin

      EncodeOpCode(97, a, b, c);
      oToolkit.Configuration.SetDebugMode(a, b, c);
      oToolkit.Configuration.AutoSetTransCurrencyRates := TRUE;

      iSelectIndex := 0;
      For iPos := 1 to oToolkit.Company.cmCount do begin
        CompanyInfo := TCompanyInfo.Create;
        CompanyInfo.CompanyRec.Path := Trim(oToolkit.Company.cmCompany[iPos].coPath);
        CompanyInfo.CompanyRec.Name := Trim(oToolkit.Company.cmCompany[iPos].coName);
        CompanyInfo.CompanyRec.Code := Trim(oToolkit.Company.cmCompany[iPos].coCode);
        cmbCompany.Items.AddObject(oToolkit.Company.cmCompany[iPos].coName, CompanyInfo);

        if oToolkit.Enterprise.enRunning
        and ((uppercase(CompanyInfo.CompanyRec.Path)) = (uppercase(Trim(oToolkit.Enterprise.enCompanyPath))))
        then iSelectIndex := iPos -1;
      end;{for}

      // select current or first company
      cmbCompany.ItemIndex := iSelectIndex;
      cmbCompanyChange(cmbCompany);

    End { If Assigned(oToolkit) }
    Else
      // Failed to create COM Object
      ShowMessage ('Cannot create COM Toolkit instance');
  end;{InitToolkit}

begin
  oToolkit := nil;
  InitToolkit;

  ReadSetupFromINI;
  pcTabs.ActivePage := tsGeneral;
//  if lbReportCats.Items.Count > 0 then lbReportCats.ItemIndex := 0;
  EnableDisable;
end;

procedure TfrmWEEESetup.ReadSetupFromINI;
var
  WEEEini : Tinifile;
begin
  WEEEini := Tinifile.Create(CompanyRec.Path + sWEEEiniName);
  cmbStockFlagUDF.ItemIndex := WEEEini.ReadInteger('Setup','StockFlagUDF',1) - 1;
  cmbStockEMCUDF.ItemIndex := WEEEini.ReadInteger('Setup','StockEMCUDF',1) - 1;
  cmbStockITCUDF.ItemIndex := WEEEini.ReadInteger('Setup','StockITCUDF',1) - 1;
  cmbCustomerUDF.ItemIndex := WEEEini.ReadInteger('Setup','CustomerUDF',1) - 1;
  cmbSupplierUDF.ItemIndex := WEEEini.ReadInteger('Setup','SupplierUDF',1) - 1;
  cmbTXLineUDF.ItemIndex := WEEEini.ReadInteger('Setup','TXLineUDF',1) - 1;
//  edProductGroup.Text := WEEEini.ReadString('Setup','ProductGroup','');
  cbShowWEEEValuePopup.checked := UpperCase(Trim(WEEEini.ReadString('Setup','ShowWEEEValuePopup','NO'))) = 'YES';
  WEEEini.Free;
end;

function TfrmWEEESetup.WriteSetupToINI : boolean;
var
  WEEEini : Tinifile;
begin
  if (cmbStockFlagUDF.ItemIndex = cmbStockEMCUDF.ItemIndex)
  or (cmbStockFlagUDF.ItemIndex = cmbStockITCUDF.ItemIndex)
  or (cmbStockEMCUDF.ItemIndex = cmbStockITCUDF.ItemIndex) then
  begin
    MsgBox('You cannot have duplicate values in the Stock UD Field Settings', mtWarning
    , [mbOK], mbOK, 'Stock UD Fields');
    Result := FALSE;
  end else
  begin
    Result := TRUE;
    WEEEini := Tinifile.Create(CompanyRec.Path + sWEEEiniName);
    WEEEini.WriteInteger('Setup','StockFlagUDF', cmbStockFlagUDF.ItemIndex + 1);
    WEEEini.WriteInteger('Setup','StockEMCUDF', cmbStockEMCUDF.ItemIndex + 1);
    WEEEini.WriteInteger('Setup','StockITCUDF', cmbStockITCUDF.ItemIndex + 1);
    WEEEini.WriteInteger('Setup','CustomerUDF',cmbCustomerUDF.ItemIndex + 1);
    WEEEini.WriteInteger('Setup','SupplierUDF', cmbSupplierUDF.ItemIndex + 1);
    WEEEini.WriteInteger('Setup','TXLineUDF',cmbTXLineUDF.ItemIndex + 1);
  //  WEEEini.WriteString('Setup','ProductGroup',edProductGroup.Text);

    if cbShowWEEEValuePopup.Checked then WEEEini.WriteString('Setup','ShowWEEEValuePopup','YES')
    else WEEEini.WriteString('Setup','ShowWEEEValuePopup','NO');

    WEEEini.EraseSection('Report Categories');
    WEEEini.Free;
  end;{if}
end;

procedure TfrmWEEESetup.btnAddCatClick(Sender: TObject);
//var
//  sNewCat : string;
begin
  with TFrmReportCatDetails.Create(self) do
  begin
    FormMode := fmAdd;
    CategoryMode := cmCategory;
    FillChar(ReportCat, Sizeof(ReportCat), #0);
    if ShowModal = mrOK then
    begin
      mlReportCats.RefreshDB;
      EnableDisable;
    end;{if}
    Release;
  end;{with}
{  if InputQuery('Add Report Category', 'New Category :', sNewCat) then
  begin
    lbReportCats.items.Add(sNewCat);
    if lbReportCats.Items.Count > 0 then lbReportCats.ItemIndex := 0;
    EnableDisable;
  end;{if}
end;

procedure TfrmWEEESetup.EnableDisable;
begin
  btnEditCat.enabled := mlReportCats.Selected >= 0;
  btnDeleteCat.enabled := btnEditCat.enabled;
  btnAddSubCat.Enabled := btnEditCat.enabled;
  btnEditSubCat.Enabled := btnEditCat.enabled and (mlReportSubCats.Selected >= 0);
end;

procedure TfrmWEEESetup.btnEditCatClick(Sender: TObject);
//var
//  sCat : string;
begin
  with TFrmReportCatDetails.Create(self) do
  begin
    FormMode := fmEdit;
    CategoryMode := cmCategory;
    ReportCat := TWEEEReportCatRec(bdsReportCats.GetRecord^);
    if ShowModal = mrOK then
    begin
      mlReportCats.RefreshDB;
      EnableDisable;
    end;{if}
    Release;
  end;{with}
{  sCat := lbReportCats.items[lbReportCats.itemindex];
  if InputQuery('Edit Report Category', 'Category :', sCat) then
  begin
    lbReportCats.items[lbReportCats.itemindex] := sCat;
    EnableDisable;
  end;{if}
end;

procedure TfrmWEEESetup.lbReportCatsClick(Sender: TObject);
begin
  EnableDisable;
end;

procedure TfrmWEEESetup.btnDeleteCatClick(Sender: TObject);
var
  BTRec : TBTRec;
  pRecord : pointer;
  LReportCat : TWEEEReportCatRec;
begin
  pRecord := bdsReportCats.GetRecord;
  if pRecord <> nil then
  begin
    if MsgBox('Are you sure you want to delete this Report Category ?'
    ,mtConfirmation, [mbYes, mbNo], mbNo, 'Delete Report Category') = mrYes then
    begin
      // delete record
      FillChar(BTRec.KeyS,SizeOf(BTRec.KeyS),#0);
      BTRec.KeyS := BTFullNomKey(TWEEEReportCatRec(pRecord^).wrcFolioNo) + IDX_DUMMY_CHAR;
      BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEReportCatF], LReportCat
      , btBufferSize[WEEEReportCatF], wrcIdxFolio, BTRec.KeyS);
      if BTRec.Status = 0 then begin
        BTRec.Status := BTDeleteRecord(btFileVar[WEEEReportCatF], LReportCat
        , btBufferSize[WEEEReportCatF], wrcIdxFolio);
        BTShowError(BTRec.Status, 'BTDeleteRecord', btFileName[WEEEReportCatF]);
        mlReportCats.RefreshDB;
        EnableDisable;
      end;{if}
    end;{if}
  end;{if}
end;

procedure TfrmWEEESetup.About1Click(Sender: TObject);
begin
  MsgBox('WEEE Plug-In Setup' + #13#13 +
         ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + #13#13 +
         GetCopyrightMessage + #13 +
         'All Rights Reserved.', mtInformation ,[mbOK], mbOK, 'About WEEE Plug-In Setup');
end;

procedure TfrmWEEESetup.lbReportCatsDblClick(Sender: TObject);
begin
  btnEditCatClick(btnEditCat);
end;

procedure TfrmWEEESetup.FormDestroy(Sender: TObject);
begin
  If Assigned(oToolkit) Then Begin
    // Close COM Toolkit and remove reference
    oToolkit.CloseToolkit;
    oToolkit := NIL;
  End; { If Assigned(oToolkit) }
end;

procedure TfrmWEEESetup.cmbCompanyChange(Sender: TObject);
var
  FuncRes : integer;
begin
  Screen.Cursor := crHourglass;
  if (oToolkit.Status = tkOpen) Then begin
    if WriteSetupToINI then
    begin
      // Close all
      oToolkit.CloseToolkit;
      CloseFiles;
      mlReportCats.Active := FALSE;
      mlReportSubCats.Active := FALSE;
      iCurrentCompanyIndex := cmbCompany.ItemIndex;
    end else
    begin
      cmbCompany.ItemIndex := iCurrentCompanyIndex;
      Screen.Cursor := crDefault;
      Exit;
    end;
  end;{if}

  With oToolkit Do Begin
    // Open Default Company
    CompanyRec := TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).CompanyRec;
    oToolkit.Configuration.DataDirectory := CompanyRec.Path;

    FuncRes := OpenToolkit;

    // Check it opened OK
    If (FuncRes = 0) then
    begin
      OpenFiles;
      ReadSetupFromINI;
      bdsReportCats.FileName := CompanyRec.Path + btFileName[WEEEReportCatF];
      bdsReportSubCats.FileName := CompanyRec.Path + btFileName[WEEEReportSubCatF];
      mlReportCats.Active := TRUE;
      mlReportCats.RefreshDB;
      mlReportSubCats.Active := TRUE;
      mlReportSubCats.RefreshDB;
      EnableDisable;
    end
    else begin
      // Error opening Toolkit - display error
      ShowMessage ('The following error occurred opening the Toolkit:-'#13#13
      + QuotedStr(oToolkit.LastErrorString));
    end;{if}

  End; { With OToolkit }
  EnableDisable;
  Screen.Cursor := crDefault;
end;

procedure TfrmWEEESetup.FormActivate(Sender: TObject);
begin
  if oToolkit = nil then close;
end;

procedure TfrmWEEESetup.bdsReportCatsGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
begin
  with TWEEEReportCatRec(PData^) do begin
    case FieldName[1] of
      'C' : FieldValue := Trim(wrcCode);
      'D' : FieldValue := Trim(wrcDescription);
    end;
  end;
end;

procedure TfrmWEEESetup.mlReportCatsRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  if btnEditCat.Enabled then btnEditCatClick(btnEditCat);
end;

procedure TfrmWEEESetup.edProductGroupChange(Sender: TObject);
begin
(*  lProductName.Caption := '';
  with oToolkit.Stock do begin
    Index := stIdxCode;
    if GetEqual(BuildCodeIndex(edProductGroup.text)) = 0
    then begin
//      if (stType in [stTypeProduct, stTypeDescription, stTypeBillOfMaterials])
//      then begin
        lProductName.Caption := stDesc[1];
//        edPrice.Value := GetEntStockPrice(stCode);
//        edPrice.Value := 0;
//      end;
    end;{if}
  end;{with}
  EnableDisable;*)
end;

procedure TfrmWEEESetup.edProductGroupExit(Sender: TObject);
begin
//  edProductGroup.text := UpperCase(edProductGroup.text);
end;

procedure TfrmWEEESetup.btnGroupBrowseClick(Sender: TObject);
{var
  oStock : IStock;}
begin
(*  with TfrmTKPickList.CreateWith(self, oToolkit) do begin
    plType := plProductGroup;
    sFind := edProductGroup.Text;
    iSearchCol := 0;
    if showmodal = mrOK then begin
      case plType of
        plProductGroup : begin
          oStock := ctkDataSet.GetRecord as IStock;
          edProductGroup.Text := oStock.stCode;
        end;
      end;{case}
    end;{if}
    release;
  end;{with}*)
end;

procedure TfrmWEEESetup.Export1Click(Sender: TObject);
const
  CSVFilename = 'WEEEProd.csv';
var
  iNoOfRecords{, iStatus} : integer;
  sPath : string;
  WEEEProductDetails : TWEEEProdRec;
  BTRec : TBTRec;

  function GetReportCategory(iFolio : integer) : string;
  var
    ReportCat : TWEEEReportCatRec;
  begin{GetReportCategory}
    BTRec.KeyS := BTFullNomKey(iFolio) + IDX_DUMMY_CHAR;
    BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEReportCatF], ReportCat
    , btBufferSize[WEEEReportCatF], wrcIdxFolio, BTRec.KeyS);
    if BTRec.Status = 0 then Result := '"' + Trim(ReportCat.wrcCode) + '","' + Trim(ReportCat.wrcDescription) + '"'
    else Result := '"",""';
  end;{GetReportCategory}

  function GetReportSubCategory(iFolio : integer) : string;
  var
    ReportSubCat : TWEEEReportSubCatRec;
  begin{GetReportSubCategory}
    BTRec.KeyS := BTFullNomKey(iFolio) + IDX_DUMMY_CHAR;
    BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEReportSubCatF], ReportSubCat
    , btBufferSize[WEEEReportSubCatF], wscIdxFolio, BTRec.KeyS);
    if BTRec.Status = 0 then Result := '"' + Trim(ReportSubCat.wscCode) + '","' + Trim(ReportSubCat.wscDescription) + '"'
    else Result := '"",""';
  end;{GetReportSubCategory}

begin
  SaveDialog.DefaultExt := 'csv';
  SaveDialog.FileName := CSVFilename;
  if SaveDialog.Execute then
  begin

    sPath := SaveDialog.FileName;

    if FileExists(sPath)
    then DeleteFile(sPath);

    // first record
    BTRec.Status := BTFindRecord(BT_GetFirst, btFileVar[WEEEProdF], WEEEProductDetails
    , btBufferSize[WEEEProdF], wpIdxStockCode, BTRec.KeyS);
    iNoOfRecords := 0;

    while BTRec.Status = 0 do
    begin
      inc(iNoOfRecords);
      AddLineToFile('"' + Trim(WEEEProductDetails.wpStockCode) + '",'
      + MoneyToStr(WEEEProductDetails.wpSetValue, oToolkit.SystemSetup.ssSalesDecimals) + ','
      + MoneyToStr(WEEEProductDetails.wpValuePerKilo, oToolkit.SystemSetup.ssSalesDecimals) + ','
      + MoneyToStr(WEEEProductDetails.wpNoOfKilos, oToolkit.SystemSetup.ssSalesDecimals) + ','
      + IntToStr(WEEEProductDetails.wpChargeType) + ','
      + GetReportCategory(WEEEProductDetails.wpReportCatFolio) + ','
      + GetReportSubCategory(WEEEProductDetails.wpReportSubCatFolio) //+ ','
//        + '"' + WEEEProductDetails.wpExtraChargeStockCode + '"'
      , sPath);

      // next GL
      BTRec.Status := BTFindRecord(BT_GetNext, btFileVar[WEEEProdF], WEEEProductDetails
      , btBufferSize[WEEEProdF], wpIdxStockCode, BTRec.KeyS);
    end;{while}

    MsgBox('Exported ' + IntToStr(iNoOfRecords) + ' records successfully to ' + sPath, mtInformation, [mbOK]
    , mbOK, 'Export to CSV');

  end;{if}
end;

procedure TfrmWEEESetup.Import1Click(Sender: TObject);
begin
   with TfrmImport.Create(self) do
   begin
     ShowModal;
     Release;
   end;{with}
end;

procedure TfrmWEEESetup.bdsReportSubCatsGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
begin
  with TWEEEReportSubCatRec(PData^) do begin
    case FieldName[1] of
      'C' : FieldValue := Trim(wscCode);
      'D' : FieldValue := Trim(wscDescription);
    end;
  end;
end;

procedure TfrmWEEESetup.StockUDFChange(Sender: TObject);
begin
  if (cmbStockFlagUDF.ItemIndex = cmbStockEMCUDF.ItemIndex)
  or (cmbStockFlagUDF.ItemIndex = cmbStockITCUDF.ItemIndex)
  or (cmbStockEMCUDF.ItemIndex = cmbStockITCUDF.ItemIndex) then
  begin
    MsgBox('You cannot have duplicate values in the Stock UD Field Settings', mtWarning
    , [mbOK], mbOK, 'Stock UD Fields');
  end;
end;

procedure TfrmWEEESetup.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := WriteSetupToINI;
  if CanClose then
  begin
    oToolkit.CloseToolkit;
    CloseFiles;
  end;{if}
end;

procedure TfrmWEEESetup.btnAddSubCatClick(Sender: TObject);
begin
  with TFrmReportCatDetails.Create(self) do
  begin
    FormMode := fmAdd;
    CategoryMode := cmSubCategory;
    ReportCat := TWEEEReportCatRec(bdsReportCats.GetRecord^);
    FillChar(ReportSubCat, Sizeof(ReportSubCat), #0);
    if ShowModal = mrOK then
    begin
      mlReportSubCats.RefreshDB;
      EnableDisable;
    end;{if}
    Release;
  end;{with}
end;

procedure TfrmWEEESetup.btnEditSubCatClick(Sender: TObject);
begin
  with TFrmReportCatDetails.Create(self) do
  begin
    FormMode := fmEdit;
    CategoryMode := cmSubCategory;
    ReportCat := TWEEEReportCatRec(bdsReportCats.GetRecord^);
    ReportSubCat := TWEEEReportSubCatRec(bdsReportSubCats.GetRecord^);
    if ShowModal = mrOK then
    begin
      mlReportSubCats.RefreshDB;
      EnableDisable;
    end;{if}
    Release;
  end;{with}
end;

procedure TfrmWEEESetup.mlReportSubCatsRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  if btnEditSubCat.Enabled then btnEditSubCatClick(btnEditSubCat);
end;

procedure TfrmWEEESetup.mlReportCatsChangeSelection(Sender: TObject);
begin
  bdsReportSubCats.SearchKey := BTFullNomKey(TWEEEReportCatRec(bdsReportCats.GetRecord^).wrcFolioNo);
  mlReportSubCats.RefreshDB;
end;

procedure TfrmWEEESetup.RunWEEEReport1Click(Sender: TObject);
begin
  with TfrmReportCriteria.Create(self) do
  begin
    showmodal;
    Release;
  end;{with}
end;

end.
