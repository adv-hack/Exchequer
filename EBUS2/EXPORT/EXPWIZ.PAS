unit ExpWiz;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, eBusUtil, eBusCnst,
  StdCtrls, ExtCtrls, ComCtrls, TEditVal, Inifiles, eBusBtrv, StrUtil, CSVUtils, eBusVar
  , BrwseDir, FileUtil, FileCtrl, APIUtil, PathUtil;

type
  TfrmExportWizard = class(TForm)
    btnNext: TButton;
    btnPrevious: TButton;
    Bevel1: TBevel;
    nbWizard: TNotebook;
    Label1: TLabel;
    btnCancel: TButton;
    Label2: TLabel;
    rbeBisXML: TRadioButton;
    rbCSV: TRadioButton;
    rbDragnet: TRadioButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    rbFTP: TRadioButton;
    rbEmail: TRadioButton;
    rbFile: TRadioButton;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    edDescription: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    cmbCustRec: TComboBox;
    Label18: TLabel;
    Label19: TLabel;
    cbOutSalesTX: TCheckBox;
    cbOutSalesOrders: TCheckBox;
    cbOutPurchTX: TCheckBox;
    cbOutPurchOrders: TCheckBox;
    Label20: TLabel;
    Label21: TLabel;
    cbCompress: TCheckBox;
    Label22: TLabel;
    Label23: TLabel;
    cbMonday: TCheckBox;
    cbTuesday: TCheckBox;
    cbWednesday: TCheckBox;
    cbThursday: TCheckBox;
    cbFriday: TCheckBox;
    cbSaturday: TCheckBox;
    cbSunday: TCheckBox;
    Label24: TLabel;
    Label25: TLabel;
    rbMins: TRadioButton;
    Label26: TLabel;
    rbMinsBetween: TRadioButton;
    Label27: TLabel;
    dtBetweenStart: TDateTimePicker;
    Label28: TLabel;
    dtBetweenEnd: TDateTimePicker;
    dtSpecific: TDateTimePicker;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    cbActive: TCheckBox;
    cbCustIgnoreWebFlag: TCheckBox;
    Label32: TLabel;
    edCustMap: TEdit;
    lCustCSVMap: TLabel;
    btnCustMapBrowse: TButton;
    Label16: TLabel;
    cmbStockRec: TComboBox;
    Label33: TLabel;
    cbStockIgnoreWebFlag: TCheckBox;
    edStockMap: TEdit;
    btnStockMapBrowse: TButton;
    Label38: TLabel;
    Label39: TLabel;
    edStockGroupMap: TEdit;
    btnStockGroupMapBrowse: TButton;
    lStockGroupDesc: TLabel;
    lStockGroup: TLabel;
    cbStockGroupIgnoreWebFlag: TCheckBox;
    bvSGCSVMap: TBevel;
    bvTXCSVMap: TBevel;
    edOutMap: TEdit;
    btnOutMapBrowse: TButton;
    lOutCSVMap: TLabel;
    Panel1: TPanel;
    Image1: TImage;
    edMins: TCurrencyEdit;
    edMinsBetween: TCurrencyEdit;
    rbSpecific: TRadioButton;
    btnHelp: TButton;
    bvCustLine: TBevel;
    lCustMapDescTit: TLabel;
    lCustMapDesc: TLabel;
    lStockMapDesc: TLabel;
    lStockGrpMapDesc: TLabel;
    lTXMapDescTit: TLabel;
    lTXMapDesc: TLabel;
    edCustFilename: TEdit;
    lCustDir: TLabel;
    edCustDir: TEdit;
    edStockDir: TEdit;
    lStockDir: TLabel;
    edStockFilename: TEdit;
    lStockCSVMap: TLabel;
    lStockMapDescTit: TLabel;
    bvStockGroupLine: TBevel;
    edStockGroupDir: TEdit;
    lStockGroupDir: TLabel;
    edStockGroupFileName: TEdit;
    lStockGroupCSVMap: TLabel;
    lStockGrpMapDescTit: TLabel;
    edTXHedFilename: TEdit;
    lTXDir: TLabel;
    edTXLinesFilename: TEdit;
    edStockLocFilename: TEdit;
    lTXHedFile: TLabel;
    lTXLinesFile: TLabel;
    lStockLocFilename: TLabel;
    lCustFilename: TLabel;
    lStockFilename: TLabel;
    lStockGroupFileName: TLabel;
    edTXDir: TEdit;
    cmbDragnetCat: TComboBox;
    bevel: TBevel;
    btnSGDirBrowse: TButton;
    btnStockDirBrowse: TButton;
    btnCustDirBrowse: TButton;
    Bevel9: TBevel;
    btnTXDirBrowse: TButton;
    bvTXLine: TBevel;
    btnCustFileLock: TButton;
    btnSGroupFileLock: TButton;
    btnTXFileLock: TButton;
    btnStockFileLock: TButton;
    cbExportStockGroups: TCheckBox;
    lStockFilter: TLabel;
    edStockFilter: TEdit;
    lCOMPriceDir: TLabel;
    edCOMPriceDir: TEdit;
    btnCOMPriceDirBrowse: TButton;
    rbCOMUpdate: TRadioButton;
    rbCOMComplete: TRadioButton;
    cbCOMPricing: TCheckBox;
    Label17: TLabel;
    Label34: TLabel;
    cbIgnoreStockFlag: TCheckBox;
    cbIgnoreCustFlag: TCheckBox;
    btnSave: TButton;
    edRunCommand: TEdit;
    Label35: TLabel;
    Label36: TLabel;
    Bevel2: TBevel;
    Label37: TLabel;
    btnCommandBrowse: TButton;
    OpenDialog1: TOpenDialog;
    lStockWebFilter: TLabel;
    edStockWebFilter: TEdit;
    cmbStockWebFilter: TComboBox;
    lCustAccType: TLabel;
    edCustAccTypeFilter: TEdit;
    cmbCustAccTypeFilter: TComboBox;
    procedure btnPreviousClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure nbWizardPageChanged(Sender: TObject);
    procedure edDescriptionChange(Sender: TObject);
    procedure cmbCustRecChange(Sender: TObject);
    procedure btnCustMapBrowseClick(Sender: TObject);
    procedure btnStockMapBrowseClick(Sender: TObject);
    procedure cmbStockRecChange(Sender: TObject);
    procedure btnStockGroupMapBrowseClick(Sender: TObject);
    procedure edOutMapChange(Sender: TObject);
    procedure btnOutMapBrowseClick(Sender: TObject);
    procedure timeradioclick(Sender: TObject);
    procedure DirBrowse(Sender: TObject);
    procedure btnCustFileLockClick(Sender: TObject);
    procedure cbExportStockGroupsClick(Sender: TObject);
    procedure edStockFilterExit(Sender: TObject);
    procedure cbCOMPricingClick(Sender: TObject);
    procedure FileNameExit(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCommandBrowseClick(Sender: TObject);
  private
    sMapFileDirectory : string;
    bStockSeparateFiles, bTXSeparateFiles : boolean;
    FormMode : TFormActivate;
    aFLFilenames : array [1..4] of string12;
    aFLExtensions : array [1..4] of string3;
    aFLType : array [1..4] of byte;
    procedure BrowseForAMapFile(sType : shortstring; lLabel : TLabel; edEdit : TEdit);
    procedure SetNextButtonCaption;
    Procedure CustRecEnable;
    Procedure StockRecEnable;
    Procedure StockGroupRecEnable;
    Procedure OutstandingEnable;
    procedure COMPricingEnable;
    Procedure FillWizardFromExport(ExportSettings : TEBusExport);
    Procedure FillExportFromWizard(var ExportSettings : TEBusExport);
    Procedure FillFileFromWizard(var FileSettings : TEBusFile);
    Procedure FillWizardFromFile(FileSettings : TEBusFile);
    Procedure SaveExportSettings;
    Procedure SaveFileSettings;
    Procedure FillCustCombo;
    Procedure FillStockCombo;
{    Procedure FillStockGroupCombo;}
    Procedure FillDragCatCombo;
    procedure ShowCSVMapDetails(MapFileRec : TMapFileRec; lLabel : TLabel; edEdit : TEdit);
    function CheckCSVMapFiles : boolean;
    function CheckInputValidity : boolean;
    Procedure SaveExportAndClose;
  public
    sExportCode : string20;
    constructor CreateWithMode(FormActivate : TFormActivate; ExportCode : String20);
    { Public declarations }
  end;

{var
  frmExportWizard: TfrmExportWizard;}

implementation
uses
  ExpMan, FileSel, BtrvU2, FileLock, MiscUtil, EntLkUp, SQLUtils;

{$R *.DFM}

const
  idxCOMPricing = 7;

constructor TfrmExportWizard.CreateWithMode(FormActivate : TFormActivate; ExportCode : String20);
begin
  FormMode := FormActivate;
  sExportCode := ExportCode;
  inherited Create(Application);
end;

procedure TfrmExportWizard.btnPreviousClick(Sender: TObject);
begin
  nbWizard.PageIndex := nbWizard.PageIndex - 1;
  if SQLUtils.UsingSQL and (nbWizard.PageIndex = idxCOMPricing) then
    nbWizard.PageIndex := nbWizard.PageIndex - 1;
  btnPrevious.Enabled := nbWizard.PageIndex > 0;
  SetNextButtonCaption;
end;

Procedure TfrmExportWizard.SaveExportAndClose;
begin
  if CheckInputValidity and CheckCSVMapFiles then begin
    SaveExportSettings;
    SaveFileSettings;
    ModalResult := mrOK;
  end;{if}
end;

procedure TfrmExportWizard.btnNextClick(Sender: TObject);
begin
  if btnNext.Caption = '&Finish' then SaveExportAndClose
  else begin
    nbWizard.PageIndex := nbWizard.PageIndex + 1;
    if SQLUtils.UsingSQL and (nbWizard.PageIndex = idxCOMPricing) then
      nbWizard.PageIndex := nbWizard.PageIndex + 1;
    btnPrevious.Enabled := TRUE;
    btnNext.Enabled := (FormMode = actAdd) or (nbWizard.PageIndex <> (nbWizard.Pages.Count - 1));
    SetNextButtonCaption;
  end;{if}
end;

procedure TfrmExportWizard.FormCreate(Sender: TObject);
{var
  sDefCustDir, sDefStockDir, sDefStockGroupDir, sDefTransDir : string;}
begin
  edMins.displayformat := '###0'; {cos this gets reset @ run-time - nice}
  edMinsBetween.displayformat := '###0'; {cos this gets reset @ run-time - nice}
  nbWizard.PageIndex := 0;

  FillCustCombo;
  FillStockCombo;
{  FillStockGroupCombo;}
  FillDragCatCombo;

  sMapFileDirectory := GetMapFileDir;

  btnSave.Visible := FormMode = actEdit;

  case FormMode of
    actAdd : begin
      {fill with file defaults}
      with TEBusBtrieveFile.Create(TRUE) do begin
        OpenFile;
        CompanyCode := sCompanyCode;
        if FindRecordWithDefaults = 0 then begin
          with FileSettings do begin
            edCustDir.Text := FileCustomerDir;
            edStockDir.Text := FileStockDir;
            edStockGroupDir.Text := FileStockGroupDir;
            edTXDir.Text := FileTransDir;
            edCOMPriceDir.Text := FileCOMPriceDir;
          end;{with}
        end;{if}
        CloseFile;
      end;

      bTXSeparateFiles := FALSE;
      bStockSeparateFiles := FALSE;

      {populate File Locking with defaults from company}
      with TEBusBtrieveCompany.Create(TRUE) do begin
        OpenFile;
        CompanyCode := sCompanyCode;
        if FindRecordWithDefaults = 0 then begin
          with CompanySettings do begin
            aFLFilenames[1] := CompCustLockFile;
            aFLFilenames[2] := CompStockLockFile;
            aFLFilenames[3] := CompStockGrpLockFile;
            aFLFilenames[4] := CompTransLockFile;

            aFLExtensions[1] := CompCustLockExt;
            aFLExtensions[2] := CompStockLockExt;
            aFLExtensions[3] := CompStockGrpLockExt;
            aFLExtensions[4] := CompTransLockExt;

            aFLType[1] := CompCustLockMethod;
            aFLType[2] := CompStockLockMethod;
            aFLType[3] := CompStockGrpMethod;
            aFLType[4] := CompTransLockMethod;
          end;{with}
        end;{if}
        CloseFile;
      end;
    end;

    actEdit : begin
      with TEBusBtrieveExport.Create(TRUE) do begin
        OpenFile;
        CompanyCode := sCompanyCode;
        ExportCode := sExportCode;
        if FindRecord = 0 then FillWizardFromExport(ExportSettings);
        CloseFile;
        Free;
      end;{with}

      with TEBusBtrieveFile.Create(TRUE) do begin
        OpenFile;
        CompanyCode := sCompanyCode;
        ExportCode := sExportCode;
        if (FindRecord = 0) then FillWizardFromFile(FileSettings);
        CloseFile;
        Free;
      end;{with}
    end;
  end;{case}
  edDescriptionChange(nil);
end;

procedure TfrmExportWizard.SetNextButtonCaption;
begin
  if (FormMode <> actEdit) and (nbWizard.PageIndex = (nbWizard.Pages.Count - 1)) then btnNext.Caption := '&Finish'
  else btnNext.Caption := '&Next  >>';
end;

procedure TfrmExportWizard.btnCancelClick(Sender: TObject);
begin
  Close;
end;

Procedure TfrmExportWizard.CustRecEnable;
var
  bGenEnable : boolean;
begin
  bGenEnable := (cmbCustRec.Text <> 'No') and (cmbCustRec.ItemIndex <> -1);

  lCustCSVMap.Visible := rbCSV.Checked;
  lCustCSVMap.Enabled := rbCSV.Checked and bGenEnable;
  edCustMap.Visible := rbCSV.Checked;
  edCustMap.Enabled := rbCSV.Checked and bGenEnable;
  btnCustMapBrowse.Visible := rbCSV.Checked;
  btnCustMapBrowse.Enabled := rbCSV.Checked and bGenEnable;
  lCustMapDescTit.Visible := rbCSV.Checked;
  lCustMapDescTit.Enabled := rbCSV.Checked and bGenEnable;
  lCustMapDesc.Visible := rbCSV.Checked;
  lCustMapDesc.Enabled := rbCSV.Checked and bGenEnable;
//  bvCustCSVMap.Visible := rbCSV.Checked;
  bvCustLine.Visible := rbCSV.Checked;

  btnNext.Enabled := (not (cmbCustRec.ItemIndex = -1))
  and (not ((Trim(edCustFilename.Text) = '') and (cmbCustRec.Text <> 'No')))
  and (not (rbCSV.Checked and (Trim(edCustMap.Text) = '') and (cmbCustRec.Text <> 'No')))
  and (not ((Trim(edCustDir.Text) = '') and rbFile.Checked and (cmbCustRec.Text <> 'No')));

  cbCustIgnoreWebFlag.Enabled := bGenEnable;

  lCustAccType.Enabled := bGenEnable;
  edCustAccTypeFilter.Enabled := bGenEnable;
  cmbCustAccTypeFilter.Enabled := bGenEnable;
//  edCustAccTypeFilterChange(nil);

  lCustFilename.Enabled := bGenEnable;
  edCustFilename.Enabled := bGenEnable;
  lCustDir.Enabled := bGenEnable and rbFile.Checked;
  edCustDir.Enabled := bGenEnable and rbFile.Checked;
  btnCustFileLock.Enabled := bGenEnable and rbFile.Checked;
  btnCustDirBrowse.Enabled := bGenEnable and rbFile.Checked;
end;

Procedure TfrmExportWizard.StockRecEnable;
var
  bGenEnable : boolean;
begin
  bGenEnable := (cmbStockRec.ItemIndex <> -1) and (cmbStockRec.Text <> 'No');

  lStockCSVMap.Visible := rbCSV.Checked;
  lStockCSVMap.Enabled := rbCSV.Checked and bGenEnable;
  edStockMap.Visible := rbCSV.Checked;
  edStockMap.Enabled := rbCSV.Checked and bGenEnable;
  btnStockMapBrowse.Visible := rbCSV.Checked;
  btnStockMapBrowse.Enabled := rbCSV.Checked and bGenEnable;
  lStockMapDescTit.Visible := rbCSV.Checked;
  lStockMapDescTit.Enabled := rbCSV.Checked and bGenEnable;
  lStockMapDesc.Visible := rbCSV.Checked;
  lStockMapDesc.Enabled := rbCSV.Checked and bGenEnable;
//  bvStockCSVMap.Visible := rbCSV.Checked;


  btnNext.Enabled := (not (cmbStockRec.ItemIndex = -1))
  and (not (rbCSV.Checked and (Trim(edStockMap.Text) = '') and (cmbStockRec.Text <> 'No')))
  and (not ((Trim(edStockFilename.Text) = '') and (cmbStockRec.Text <> 'No')))
  and (not ((Trim(edStockLocFilename.Text) = '') and rbCSV.Checked and bStockSeparateFiles and (cmbStockRec.Text <> 'No')))
  and (not ((Trim(edStockDir.Text) = '') and rbFile.Checked and (cmbStockRec.Text <> 'No')));

  cbStockIgnoreWebFlag.Enabled := bGenEnable;
//  cbStockLocation.Enabled := bGenEnable;
  edStockFilter.Enabled := bGenEnable;
  lStockFilter.Enabled := bGenEnable;
  lStockWebFilter.Enabled := bGenEnable;
  edStockWebFilter.Enabled := bGenEnable;
  cmbStockWebFilter.Enabled := bGenEnable;
//  edStockWebFilterChange(nil);

  edStockFilename.Enabled := bGenEnable;
  lStockFilename.Enabled := bGenEnable;

  edStockLocFilename.Visible := rbCSV.Checked ;
  edStockLocFilename.Enabled := bStockSeparateFiles and bGenEnable and rbCSV.Checked ;

  lStockLocFilename.Visible := rbCSV.Checked ;
  lStockLocFilename.Enabled := bStockSeparateFiles and bGenEnable and rbCSV.Checked ;

  edStockDir.Enabled := rbFile.Checked and bGenEnable;
  btnStockFileLock.Enabled := rbFile.Checked and bGenEnable;
  lStockDir.Enabled := rbFile.Checked and bGenEnable;
  btnStockDirBrowse.Enabled := rbFile.Checked and bGenEnable;
end;

Procedure TfrmExportWizard.StockGroupRecEnable;
begin
  edStockGroupMap.Enabled := rbCSV.Checked and cbExportStockGroups.Checked;
  btnStockGroupMapBrowse.Enabled := rbCSV.Checked and cbExportStockGroups.Checked;
  lStockGrpMapDescTit.Enabled := rbCSV.Checked and cbExportStockGroups.Checked;
  lStockGrpMapDesc.Enabled := rbCSV.Checked and cbExportStockGroups.Checked;
  lStockGroupCSVMap.Enabled := rbCSV.Checked and cbExportStockGroups.Checked;

  edStockGroupMap.Visible := rbCSV.Checked;
  btnStockGroupMapBrowse.Visible := rbCSV.Checked;
  lStockGrpMapDescTit.Visible := rbCSV.Checked;
  lStockGrpMapDesc.Visible := rbCSV.Checked;
  lStockGroupCSVMap.Visible := rbCSV.Checked;
  bvSGCSVMap.Visible := rbCSV.Checked;
  bvStockGroupLine.Visible := rbCSV.Checked;

{ btnNext.Enabled := (not rbDragNet.Checked and ((not (cmbStockGroupRec.ItemIndex = -1))
  and (not ((Trim(edStockGroupFileName.Text) = '') and (cmbStockGroupRec.Text <> 'No')))
  and (not (rbCSV.Checked and (Trim(edStockGroupMap.Text) = '') and (cmbStockGroupRec.Text <> 'No')))
  and (not ((Trim(edStockGroupDir.Text) = '') and rbFile.Checked and (cmbStockGroupRec.Text <> 'No')))))
  or (rbDragNet.Checked and (cmbDragnetCat.ItemIndex <> -1));}

{  btnNext.Enabled := (not rbDragNet.Checked
  and ((not ((Trim(edStockGroupFileName.Text) = '') ))
  and (not (rbCSV.Checked and (Trim(edStockGroupMap.Text) = '') ))
  and (not ((Trim(edStockGroupDir.Text) = '') and rbFile.Checked ))))
  or (rbDragNet.Checked and (cmbDragnetCat.ItemIndex <> -1));}

  btnNext.Enabled := (not rbDragNet.Checked
  and ((not ((Trim(edStockGroupFileName.Text) = '') and cbExportStockGroups.Checked))
  and (not (rbCSV.Checked and (Trim(edStockGroupMap.Text) = '') and cbExportStockGroups.Checked))
  and (not ((Trim(edStockGroupDir.Text) = '') and rbFile.Checked and cbExportStockGroups.Checked))))
  or (rbDragNet.Checked and (cmbDragnetCat.ItemIndex <> -1));

  cbStockGroupIgnoreWebFlag.Enabled := cbExportStockGroups.Checked;
  edStockGroupFileName.Enabled := cbExportStockGroups.Checked;
  lStockGroupFileName.Enabled := cbExportStockGroups.Checked;

  edStockGroupDir.Enabled := rbFile.Checked and cbExportStockGroups.Checked;
  btnSGroupFileLock.Enabled := rbFile.Checked and cbExportStockGroups.Checked;
  lStockGroupDir.Enabled := rbFile.Checked and cbExportStockGroups.Checked;
  btnSGDirBrowse.Enabled := rbFile.Checked and cbExportStockGroups.Checked;
end;

Procedure TfrmExportWizard.OutstandingEnable;
var
  bEnable : boolean;
begin
  bEnable := (cbOutSalesTX.Checked or cbOutSalesOrders.Checked or cbOutPurchTX.Checked
  or cbOutPurchOrders.Checked);

  btnNext.Enabled := (not (bEnable and (Trim(edTXHedFilename.Text) = '')))
  and (not (bEnable and bTXSeparateFiles and rbCSV.Checked and (Trim(edTXLinesFilename.Text) = '')))
  and (not (bEnable and rbFile.Checked  and (Trim(edTXDir.Text) = '')))
  and (not (bEnable and rbCSV.Checked and (Trim(edOutMap.Text) = '')));

  if rbCSV.Checked and bTXSeparateFiles then lTXHedFile.Caption := 'Transaction Header Filename :'
  else lTXHedFile.Caption := 'Transaction Export Filename :';

  edTXHedFilename.Enabled := bEnable;
  lTXHedFile.Enabled := bEnable;

  lTXLinesFile.Visible := rbCSV.Checked;
  lTXLinesFile.Enabled := bEnable and bTXSeparateFiles and rbCSV.Checked;

  edTXLinesFilename.Visible := rbCSV.Checked;
  edTXLinesFilename.Enabled := bEnable and bTXSeparateFiles and rbCSV.Checked;

  edTXDir.Enabled := bEnable and rbFile.Checked;
  lTXDir.Enabled := bEnable and rbFile.Checked;
  btnTXDirBrowse.Enabled := bEnable and rbFile.Checked;
  btnTXFileLock.Enabled := bEnable and rbFile.Checked;

  lOutCSVMap.Enabled := rbCSV.Checked and bEnable;
  edOutMap.Enabled := rbCSV.Checked and bEnable;
  btnOutMapBrowse.Enabled := rbCSV.Checked and bEnable;
  lTXMapDescTit.Enabled := rbCSV.Checked and bEnable;
  lTXMapDesc.Enabled := rbCSV.Checked and bEnable;

  lOutCSVMap.Visible := rbCSV.Checked;
  edOutMap.Visible := rbCSV.Checked;
  btnOutMapBrowse.Visible := rbCSV.Checked;
  lTXMapDescTit.Visible := rbCSV.Checked;
  lTXMapDesc.Visible := rbCSV.Checked;
  bvTXCSVMap.Visible := rbCSV.Checked;
  bvTXLine.Visible := rbCSV.Checked;
end;

procedure TfrmExportWizard.COMPricingEnable;
var
  bEnable : boolean;
begin
  bEnable := cbCOMPricing.Checked;

  rbCOMComplete.Enabled := bEnable;
  rbCOMUpdate.Enabled := bEnable;

  edCOMPriceDir.Enabled := bEnable and rbFile.Checked;
  lCOMPriceDir.Enabled := bEnable and rbFile.Checked;
  btnCOMPriceDirBrowse.Enabled := bEnable and rbFile.Checked;

  cbIgnoreCustFlag.Enabled := bEnable;
  cbIgnoreStockFlag.Enabled := bEnable;
end;

procedure TfrmExportWizard.nbWizardPageChanged(Sender: TObject);
begin
  if nbWizard.ActivePage = 'pgDescription' then
    begin
      edDescriptionChange(nil);
    end
  else begin
    if nbWizard.ActivePage = 'pgCustomerRecords' then
      begin
        {pgCustomerRecords}
        FillCustCombo;
        CustRecEnable;
      end
    else begin
      if nbWizard.ActivePage = 'pgStockRecords' then
        begin
          {pgStockRecords}
          FillStockCombo;
          StockRecEnable;
        end
      else begin
        if nbWizard.ActivePage = 'pgStockGroupRecords' then
          begin
            {pgStockGroupRecords}
            cbStockGroupIgnoreWebFlag.Visible := not rbDragnet.Checked;
            bvSGCSVMap.Visible := not rbDragnet.Checked;
            lStockGroupCSVMap.Visible := not rbDragnet.Checked;
            edStockGroupMap.Visible := not rbDragnet.Checked;
            btnStockGroupMapBrowse.Visible := not rbDragnet.Checked;
{            lSGR.Visible := not rbDragnet.Checked;}
            edStockGroupFileName.Visible := not rbDragnet.Checked;
            lStockGroupFileName.Visible := not rbDragnet.Checked;
            edStockGroupDir.Visible := not rbDragnet.Checked;
            lStockGroupDir.Visible := not rbDragnet.Checked;
            lStockGrpMapDescTit.Visible := not rbDragnet.Checked;
            lStockGrpMapDesc.Visible := not rbDragnet.Checked;
            bvStockGroupLine.Visible := not rbDragnet.Checked;
{            cmbStockGroupRec.Visible := not rbDragnet.Checked;}
            cbExportStockGroups.Visible := not rbDragnet.Checked;
            bevel.Visible := not rbDragnet.Checked;
            btnSGDirBrowse.Visible := not rbDragnet.Checked;

            cmbDragnetCat.Visible := rbDragnet.Checked;

            if rbDragnet.Checked then
              begin
                lStockGroup.Caption := 'Dragnet Catalogue';
                lStockGroupDesc.Caption := 'Please choose a dragnet catalogue.';
{                lSGExport.Caption := 'Catalogue :';}
              end
            else begin
              lStockGroup.Caption := 'Stock Group Records';
              lStockGroupDesc.Caption := 'Please choose which stock group records you wish to export.';
{              lSGExport.Caption := 'Export All Stock Group Records';}
{              FillStockGroupCombo;}
            end;{if}
            StockGroupRecEnable;
          end
        else begin
          if nbWizard.ActivePage = 'pgOutstanding' then
            begin
              OutstandingEnable;
            end
          else begin
            if nbWizard.ActivePage = 'pgTimeScheduling' then
              begin
                timeradioclick(nil);
              end
            else begin
              if nbWizard.ActivePage = 'pgCOMPricing' then
              begin
                COMPricingEnable;
              end
              else begin
                btnNext.Enabled := TRUE;
              end;{if}
            end;{if}
          end;{if}
        end;{if}
      end;{if}
    end;{if}
  end;{if}
end;

procedure TfrmExportWizard.edDescriptionChange(Sender: TObject);
begin
  btnNext.Enabled := Trim(edDescription.Text) <> '';
end;

procedure TfrmExportWizard.cmbCustRecChange(Sender: TObject);
begin
  CustRecEnable;
end;

procedure TfrmExportWizard.btnCustMapBrowseClick(Sender: TObject);
begin
  BrowseForAMapFile('Account', lCustMapDesc, edCustMap);
end;

procedure TfrmExportWizard.BrowseForAMapFile(sType : shortstring; lLabel : TLabel; edEdit : TEdit);
var
  FrmSelectMapFile : TFrmSelectMapFile;
begin
  FrmSelectMapFile := TFrmSelectMapFile.Create(Self);
  try
    FrmSelectMapFile.sDirectory := sMapFileDirectory;
    FrmSelectMapFile.ExportType := CSVTypeNameToEnum(sType);
    with FrmSelectMapFile do begin
      if ShowModal = mrOK then ShowCSVMapDetails(MapFileRec, lLabel, edEdit);
    end;{with}
  finally
    FrmSelectMapFile.Release;
  end;{try}
end;

procedure TfrmExportWizard.ShowCSVMapDetails(MapFileRec : TMapFileRec; lLabel : TLabel; edEdit : TEdit);
begin
  with MapFileRec do begin
    case ExportType of
      etTXHeader : bTXSeparateFiles := ExportFormat = efBothSeparate;
      etStockHeader : bStockSeparateFiles := ExportFormat = efBothSeparate;
    end;{case}
    lLabel.Caption := Description;
    edEdit.Text := Filename;
  end;{with}
end;


procedure TfrmExportWizard.btnStockMapBrowseClick(Sender: TObject);
begin
  BrowseForAMapFile('Stock', lStockMapDesc, edStockMap);
end;

procedure TfrmExportWizard.cmbStockRecChange(Sender: TObject);
begin
  StockRecEnable;
end;

procedure TfrmExportWizard.btnStockGroupMapBrowseClick(Sender: TObject);
begin
  BrowseForAMapFile('StockGroup', lStockGrpMapDesc,edStockGroupMap);
end;

procedure TfrmExportWizard.edOutMapChange(Sender: TObject);
begin
  OutstandingEnable;
end;

procedure TfrmExportWizard.btnOutMapBrowseClick(Sender: TObject);
begin
  BrowseForAMapFile('TXHeader',lTXMapDesc, edOutMap);
end;

procedure TfrmExportWizard.timeradioclick(Sender: TObject);
begin
  edMins.Enabled := rbMins.Checked;

  edMinsBetween.Enabled := rbMinsBetween.Checked;
  dtBetweenStart.Enabled := rbMinsBetween.Checked;
  dtBetweenEnd.Enabled := rbMinsBetween.Checked;

  dtSpecific.Enabled := rbSpecific.Checked;
end;

Procedure TfrmExportWizard.FillWizardFromExport(ExportSettings : TEBusExport);
var
  iPos : integer;

  function SetRecordModeTo(iMode : Byte): ShortString;
  begin
    Case iMode of
      0 : Result := 'No';
      1 : Result := 'Updated';
      2 : Result := 'All';
    end;{case}
  end;{SetRecordModeFrom}

begin{FillWizardFromExport}
  with ExportSettings do begin
    edDescription.Text := ExptDescription;

    {Export Type}
    case ExptDataType of
      'X' : rbeBisXML.Checked := TRUE;
      'C' : rbCSV.Checked := TRUE;
      'D' : rbDragnet.Checked := TRUE;
    end;{case}

    {Transport Mode}
    case ExptTransportType of
      'F' : rbFTP.Checked := TRUE;
      'E' : rbEmail.Checked  := TRUE;
      'D' : rbFile.Checked := TRUE;
    end;{case}

    {File Locking Arrays}
    aFLFilenames[1] := ExptCustLockFile;
    aFLFilenames[2] := ExptStockLockFile;
    aFLFilenames[3] := ExptStockGrpLockFile;
    aFLFilenames[4] := ExptTransLockFile;

    aFLExtensions[1] := ExptCustLockExt;
    aFLExtensions[2] := ExptStockLockExt;
    aFLExtensions[3] := ExptStockGrpLockExt;
    aFLExtensions[4] := ExptTransLockExt;

    aFLType[1] := ExptCustLockMethod;
    aFLType[2] := ExptStockLockMethod;
    aFLType[3] := ExptStockGrpMethod;
    aFLType[4] := ExptTransLockMethod;

    {Customer Records}
    cmbCustRec.Text := SetRecordModeTo(ExptCustomers);
    cmbCustRec.ItemIndex := cmbCustRec.Items.IndexOf(SetRecordModeTo(ExptCustomers));

    cbCustIgnoreWebFlag.Checked := ExptIgnoreCustWebInc = 1;
    edCustAccTypeFilter.Text := ExptCustAccTypeFilter;
    cmbCustAccTypeFilter.ItemIndex := ExptCustAccTypeFilterFlag;

    edCustFilename.Text := ExptCustFileName;
    ShowCSVMapDetails(GetMapFileRec(sMapFileDirectory + ExptCSVCustMAPFile), lCustMapDesc, edCustMap);

    {Stock Records}
    cmbStockRec.ItemIndex := cmbStockRec.Items.IndexOf(SetRecordModeTo(ExptStock));

    cbStockIgnoreWebFlag.Checked := ExptIgnoreStockWebInc = 1;
//    cbStockLocation.Checked := ExptUpdatedStockLocation = 1;
    edStockFilter.Text := ExptStockFilter;
    edStockWebFilter.Text := ExptStockWebFilter;
    cmbStockWebFilter.ItemIndex := ExptStockWebFilterFlag;

    edStockFilename.Text := ExptStockFileName;
    edStockLocFilename.Text := ExptStockLocFileName;
    ShowCSVMapDetails(GetMapFileRec(sMapFileDirectory + ExptCSVStockMAPFile), lStockMapDesc, edStockMap);

    if rbDragnet.Checked then
      begin
        {Dragnet Catalogue}
        if (cmbDragnetCat.Items.Count = 0) or (ExptCatalogues = '') then cmbDragnetCat.ItemIndex := 0
        else begin
          for iPos := 0 to cmbDragnetCat.Items.Count - 1 do begin
            if cmbDragnetCat.Items[iPos][1] = ExptCatalogues then cmbDragnetCat.ItemIndex := iPos;
          end;{for}
        end;{if}
      end
    else begin
      {Stock Groups}
{      cmbStockGroupRec.ItemIndex := cmbStockGroupRec.Items.IndexOf(SetRecordModeTo(ExptStockGroups));}
      cbExportStockGroups.Checked := ExptStockGroups > 0;
      cbStockGroupIgnoreWebFlag.Checked := ExptIgnoreStockGrpWebInc = 1;
      edStockGroupFileName.Text := ExptStockGroupFileName;
      ShowCSVMapDetails(GetMapFileRec(sMapFileDirectory + ExptCSVStockGrpMAPFile), lStockGrpMapDesc, edStockGroupMap);
    end;{if}

    {Outstanding Transactions}
    cbOutSalesOrders.Checked := ExptIncCurSalesOrders = 1;
    cbOutSalesTX.Checked := ExptIncCurSalesTrans = 1;
    cbOutPurchOrders.Checked := ExptIncCurPurchOrders = 1;
    cbOutPurchTX.Checked := ExptIncCurPurchTrans = 1;
    edTXHedFilename.Text := ExptTransFileName;
    edTXLinesFilename.Text := ExptTransLinesFileName;
    ShowCSVMapDetails(GetMapFileRec(sMapFileDirectory + ExptCSVTransMAPFile), lTXMapDesc, edOutMap);

    {Scheduling Info}
    cbMonday.Checked := DayBitEnabled(ExptDaysOfWeek,dowMonday);
    cbTuesday.Checked := DayBitEnabled(ExptDaysOfWeek,dowTuesday);
    cbWednesday.Checked := DayBitEnabled(ExptDaysOfWeek,dowWednesday);
    cbThursday.Checked := DayBitEnabled(ExptDaysOfWeek,dowThursday);
    cbFriday.Checked := DayBitEnabled(ExptDaysOfWeek,dowFriday);
    cbSaturday.Checked := DayBitEnabled(ExptDaysOfWeek,dowSaturday);
    cbSunday.Checked := DayBitEnabled(ExptDaysOfWeek,dowSunday);

    case ExptTimeType of
      1 : begin
        rbSpecific.Checked := TRUE;
        dtSpecific.DateTime := ExptTime1;
      end;

      2 : begin
        rbMins.Checked := TRUE;
        edMins.Text := IntToStr(ExptFrequency);
      end;

      3 : begin
        rbMinsBetween.Checked := TRUE;
        edMinsBetween.Text := IntToStr(ExptFrequency);
        dtBetweenStart.DateTime := ExptTime1;
        dtBetweenEnd.DateTime := ExptTime2;
      end;
    end;{case}

    {COM Pricing}
    cbCOMPricing.Checked := ExptIncCOMPricing > 0;
    if cbCOMPricing.Checked then
    begin
      rbCOMComplete.Checked := ExptIncCOMPricing = 1;
      rbCOMUpdate.Checked := ExptIncCOMPricing = 2;
      cbIgnoreCustFlag.Checked := ExptIgnoreCOMCustInc > 0;
      cbIgnoreStockFlag.Checked := ExptIgnoreCOMStockInc > 0;
    end
    else
    begin
      rbCOMComplete.Enabled := false;
      rbCOMUpdate.Enabled := false;
      cbIgnoreCustFlag.Enabled := false;
      cbIgnoreStockFlag.Enabled := false;
    end;

    {additional}
    cbCompress.Checked := ExptZipFiles = 1;
    edRunCommand.Text := ExptCommandLine;

    {Active}
    cbActive.Checked := ExptActive = 1;

  end;{with}
end;

Procedure TfrmExportWizard.FillExportFromWizard(var ExportSettings : TEBusExport);

  function GetRecordModeFrom(sSelection : string): byte;
  begin
    sSelection := Uppercase(sSelection);
    if sSelection = 'NO' then Result := 0
    else begin
      if sSelection = 'UPDATED' then Result := 1
      else begin
        if sSelection = 'ALL' then Result := 2;
      end;{if}
    end;{if}
  end;{GetRecordModeFrom}

begin
  with ExportSettings do begin
    ExptDescription := edDescription.Text;

    {Export Type}
    if rbeBisXML.Checked then ExptDataType := 'X'
    else begin
      if rbCSV.Checked then ExptDataType := 'C'
      else begin
        if rbDragnet.Checked then ExptDataType := 'D';
      end;{if}
    end;{if}

    {Transport Mode}
    if rbFTP.Checked then ExptTransportType := 'F'
    else begin
      if rbEmail.Checked then ExptTransportType := 'E'
      else begin
        if rbFile.Checked then ExptTransportType := 'D';
      end;{if}
    end;{if}

    {Customer Records}
    ExptCustomers := GetRecordModeFrom(cmbCustRec.Items[cmbCustRec.ItemIndex]);

    ExptIgnoreCustWebInc := Ord(cbCustIgnoreWebFlag.Checked);
    ExptCustAccTypeFilter := edCustAccTypeFilter.Text;
    ExptCustAccTypeFilterFlag := cmbCustAccTypeFilter.ItemIndex;

    ExptCustFileName := edCustFilename.Text;
    ExptCSVCustMAPFile := edCustMap.Text;

    {Stock Records}
    ExptStock := GetRecordModeFrom(cmbStockRec.Items[cmbStockRec.ItemIndex]);

    ExptIgnoreStockWebInc := Ord(cbStockIgnoreWebFlag.Checked);
//    ExptUpdatedStockLocation := Ord(cbStockLocation.Checked);
    ExptStockFilter := edStockFilter.Text;
    ExptStockWebFilter := edStockWebFilter.Text;
    ExptStockWebFilterFlag := cmbStockWebFilter.ItemIndex;

    ExptStockFileName := edStockFilename.Text;
    ExptStockLocFileName := edStockLocFilename.Text;
    ExptCSVStockMAPFile := edStockMap.Text;

    {File Locking}
    ExptCustLockFile := aFLFilenames[1];
    ExptStockLockFile := aFLFilenames[2];
    ExptStockGrpLockFile := aFLFilenames[3];
    ExptTransLockFile := aFLFilenames[4];

    ExptCustLockExt := aFLExtensions[1];
    ExptStockLockExt := aFLExtensions[2];
    ExptStockGrpLockExt := aFLExtensions[3];
    ExptTransLockExt := aFLExtensions[4];

    ExptCustLockMethod := aFLType[1];
    ExptStockLockMethod := aFLType[2];
    ExptStockGrpMethod := aFLType[3];
    ExptTransLockMethod := aFLType[4];

    if rbDragnet.Checked then
      begin
        {Dragnet Catalogue}
        if cmbDragnetCat.ItemIndex = 0 then ExptCatalogues := ''
        else ExptCatalogues := cmbDragnetCat.Items[cmbDragnetCat.ItemIndex][1];
      end
    else begin
      {Stock Groups}
      if cbExportStockGroups.Checked then ExptStockGroups := 2
      else ExptStockGroups := 0;
      {ExptStockGroups := 2;GetRecordModeFrom(cmbStockGroupRec.Items[cmbStockGroupRec.ItemIndex]);}
      ExptIgnoreStockGrpWebInc := Ord(cbStockGroupIgnoreWebFlag.Checked);
      ExptStockGroupFileName := edStockGroupFileName.Text;
      ExptCSVStockGrpMAPFile := edStockGroupMap.Text;
    end;{if}

    {Outstanding Transactions}
    ExptIncCurSalesOrders := Ord(cbOutSalesOrders.Checked);
    ExptIncCurSalesTrans := Ord(cbOutSalesTX.Checked);
    ExptIncCurPurchOrders := Ord(cbOutPurchOrders.Checked);
    ExptIncCurPurchTrans := Ord(cbOutPurchTX.Checked);
    ExptTransFileName := edTXHedFilename.Text;
    ExptTransLinesFileName := edTXLinesFilename.Text;
    ExptCSVTransMAPFile := edOutMap.Text;

    {Scheduling Info}
    ExptDaysOfWeek := DaysOfWeekToByte([cbMonday.Checked, cbTuesday.Checked,cbWednesday.Checked
    ,cbThursday.Checked,cbFriday.Checked, cbSaturday.Checked, cbSunday.Checked]);

    if rbMins.Checked then
      begin
        ExptTimeType := 2;
        ExptFrequency := StrToInt(edMins.Text);
      end
    else begin
      if rbMinsBetween.Checked then
        begin
          ExptTimeType := 3;
          ExptFrequency := StrToInt(edMinsBetween.Text);

          ExptTime1 := dtBetweenStart.DateTime;
          ReplaceDate(ExptTime1, 0);

          ExptTime2 := dtBetweenEnd.DateTime;
          ReplaceDate(ExptTime2, 0);
        end
      else begin
        if rbSpecific.Checked then begin
          ExptTimeType := 1;

          ExptTime1 := dtSpecific.DateTime;
          ReplaceDate(ExptTime1, 0);
        end;{if}
      end;{if}
    end;{if}

    {COM Pricing}
    if rbCOMComplete.Enabled then
      if rbCOMComplete.Checked then
        ExptIncCOMPricing := 1
      else
        ExptIncCOMPricing := 2
    else
      ExptIncCOMPricing := 0;

    if cbIgnoreCustFlag.Checked then
      ExptIgnoreCOMCustInc := 1
    else
      ExptIgnoreCOMCustInc := 0;

    if cbIgnoreStockFlag.Checked then
      ExptIgnoreCOMStockInc := 1
    else
      ExptIgnoreCOMStockInc := 0;

    {additional}
    ExptZipFiles := Ord(cbCompress.Checked);
    ExptCommandLine := edRunCommand.Text;

    {Active}
    ExptActive := Ord(cbActive.Checked);

  end;{with}
end;

Procedure TfrmExportWizard.FillFileFromWizard(var FileSettings : TEBusFile);
begin
  with FileSettings do begin
    FileCustomerDir := IncludeTrailingBackslash(edCustDir.Text);
    FileStockDir := IncludeTrailingBackslash(edStockDir.Text);
    FileStockGroupDir := IncludeTrailingBackslash(edStockGroupDir.Text);
    FileTransDir := IncludeTrailingBackslash(edTXDir.Text);
    FileCOMPriceDir := IncludeTrailingBackslash(edCOMPriceDir.Text);
  end;{with}
end;

Procedure TfrmExportWizard.FillWizardFromFile(FileSettings : TEBusFile);
begin
  with FileSettings do begin
    edCustDir.Text := FileCustomerDir;
    edStockDir.Text := FileStockDir;
    edStockGroupDir.Text := FileStockGroupDir;
    edTXDir.Text := FileTransDir;
    edCOMPriceDir.Text := FileCOMPriceDir;
  end;{with}
end;

Procedure TfrmExportWizard.SaveExportSettings;
var
  iLockPos : integer;
  bLock : boolean;
begin
  with TEBusBtrieveExport.Create(TRUE) do begin
    OpenFile;
    CompanyCode := sCompanyCode;

    case FormMode of
      actAdd : begin
        BlankRecord;
        FillExportFromWizard(ExportSettings);
        sExportCode := GetExportCode;
        ExportCode := sExportCode;
        AddRecord;
      end;

      actEdit : begin
        ExportCode := sExportCode;
        bLock := TRUE;
        if (FindRecord(bLock, iLockPos, B_GetEq) = 0) then begin
          FillExportFromWizard(ExportSettings);
          UpdateRecord;
          UnlockRecord(iLockPos);
        end;{if}
      end;
    end;{case}

    CloseFile;
    Free;
  end;{with}
end;

Procedure TfrmExportWizard.SaveFileSettings;
var
  bLock : boolean;
  iLockPos : integer;
begin
{  if (edCustDir.Text <> sDefCustDir) or (edStockDir.Text <> sDefStockDir)
  or (edStockGroupDir.Text <> sDefStockGroupDir) or (edTXDir.Text <> sDefTransDir) then begin}
    with TEBusBtrieveFile.Create(TRUE) do begin
      OpenFile;
      ExportCode := sExportCode;
      CompanyCode := sCompanyCode;

      case FormMode of
        actAdd : begin
          BlankRecord;
          FillFileFromWizard(FileSettings);
          AddRecord;
        end;

        actEdit : begin
          if (FindRecord(bLock, iLockPos, B_GetEq) = 0) then
            begin
              FillFileFromWizard(FileSettings);
              UpdateRecord;
              UnlockRecord(iLockPos);
            end
          else begin
            BlankRecord;
            FillFileFromWizard(FileSettings);
            AddRecord;
          end;{if}
        end;
      end;{case}

      CloseFile;
      Free;
    end;{with}
{  end;{if}
end;

Procedure TfrmExportWizard.FillCustCombo;
var
  sPrevValue : string;
begin
  with cmbCustRec, Items do begin
    sPrevValue := Items[ItemIndex];
    ClearList(Items);
    Add('All');
    Add('No');
    if rbeBisXML.Checked or rbCSV.Checked then Add('Updated');
    if sPrevValue = '' then
      ItemIndex := 1
    else
      ItemIndex := IndexOf(sPrevValue);
  end;{with}
end;

Procedure TfrmExportWizard.FillStockCombo;
var
  sPrevValue : string;
begin
  with cmbStockRec, Items do begin
    sPrevValue := Items[ItemIndex];
    ClearList(Items);
    Add('All');
    Add('No');
    if rbeBisXML.Checked or rbCSV.Checked then Add('Updated');
    if sPrevValue = '' then
      ItemIndex := 1
    else
      ItemIndex := IndexOf(sPrevValue);
  end;{with}
end;

(*Procedure TfrmExportWizard.FillStockGroupCombo;
var
  sPrevValue : string;
begin
  with cmbStockGroupRec, Items do begin
    sPrevValue := Items[ItemIndex];
    ClearList(Items);
    Add('All');
    Add('No');
    if rbeBisXML.Checked or rbCSV.Checked then Add('Updated');
    ItemIndex := IndexOf(sPrevValue);
  end;{with}
end;*)

Procedure TfrmExportWizard.FillDragCatCombo;
var
  iStatus : integer;
begin
  with cmbDragnetCat, Items do begin
    Add('(none)');

    with TEBusBtrieveCatalogue.Create(TRUE) do begin
      CompanyCode := sCompanyCode;
      OpenFile;

      iStatus := FindRecord(B_GetFirst);
      while (iStatus = 0) do begin
        Add(CatalogueSettings.CatTitle);
        iStatus := FindRecord(B_GetNext);
      end;{while}

      CloseFile;
    end;{with}
    ItemIndex := 0;
  end;{with}
end;

procedure TfrmExportWizard.DirBrowse(Sender: TObject);
begin
  with TBrowseDirDialog.Create do
    try
      if Sender = btnCustDirBrowse then
        Directory := edCustDir.Text;
      if Sender = btnStockDirBrowse then
        Directory := edStockDir.Text;
      if Sender = btnSGDirBrowse then
        Directory := edStockGroupDir.Text;
      if Sender = btnTXDirBrowse then
        Directory := edTXDir.Text;
      if Sender = btnCOMPriceDirBrowse then
        Directory := edCOMPriceDir.Text;


      if Execute then begin

        if length(Directory) > 80 then begin
          Directory := PathToShort(Directory);
          if length(Directory) > 80 then begin
            MsgBox('The Directory you have selected is, even when converted to a short path, greater than the maximum limit (80).'
            + #13 + 'You will need to specify a different directory.',mtWarning,[mbOK],mbOK,'Path Exceeded Maximum Length');
            Directory := '';
          end;{if}
        end;{if}

        if Sender = btnCustDirBrowse then
          edCustDir.Text := Directory;
        if Sender = btnStockDirBrowse then
          edStockDir.Text := Directory;
        if Sender = btnSGDirBrowse then
          edStockGroupDir.Text := Directory;
        if Sender = btnTXDirBrowse then
          edTXDir.Text := Directory;
        if Sender = btnCOMPriceDirBrowse then
          edCOMPriceDir.Text := Directory;
      end;
    finally
      Free;
    end;
end;

function TfrmExportWizard.CheckInputValidity : boolean;
var
  sMessage, sFilename : string;
  NewActiveControl : TWinControl;
  bAnyOSTX : boolean;
  iNewPageIndex : byte;
begin
  bAnyOSTX := cbOutSalesOrders.Checked or cbOutSalesTX.Checked or cbOutPurchOrders.Checked
  or cbOutPurchTX.Checked;

  Result := FALSE;

  {Customer Records Page}
  iNewPageIndex := 3;
  sFilename := edCustFilename.Text;
  if (cmbCustRec.Text = 'No') or Check83ValidFileWithExt(sFileName, '') then
    begin
      edCustFilename.Text := sFilename;
      if (not rbFile.Checked) or (cmbCustRec.Text = 'No') or DirectoryExists(edCustDir.Text) then
        begin
          sFilename := edCustMap.Text;
          if (not rbCSV.Checked) or (cmbCustRec.Text = 'No') or Check83ValidFileWithExt(sFileName, 'MAP') then
            begin
              edCustMap.Text := sFilename;

              {Stock Records Page}
              iNewPageIndex := 4;
              sFilename := edStockFilename.Text;
              if (cmbStockRec.Text = 'No') or Check83ValidFileWithExt(sFileName, '') then
                begin
                  edStockFilename.Text := sFilename;
                  sFilename := edStockLocFilename.Text;
                  if (cmbStockRec.Text = 'No') or (not rbCSV.Checked) or (not bStockSeparateFiles) or Check83ValidFileWithExt(sFileName, '') then
                    begin
                      edStockLocFilename.Text := sFilename;
                      if (not rbFile.Checked) or (cmbStockRec.Text = 'No') or DirectoryExists(edStockDir.Text) then
                        begin
                          sFilename := edStockMap.Text;
                          if (not rbCSV.Checked) or (cmbStockRec.Text = 'No') or Check83ValidFileWithExt(sFileName, 'MAP') then
                            begin
                              edStockMap.Text := sFilename;

                              {Stock Group Records Page}
                              iNewPageIndex := 5;
                              sFilename := edStockGroupFileName.Text;
                              if (rbDragnet.Checked) or (not cbExportStockGroups.Checked) or Check83ValidFileWithExt(sFileName, '') then
                                begin
                                  edStockGroupFileName.Text := sFilename;
                                  if (rbDragnet.Checked) or (not rbFile.Checked) or (not cbExportStockGroups.Checked) or DirectoryExists(edStockGroupDir.Text) then
                                    begin
                                      sFilename := edStockGroupMap.Text;
                                      if (rbDragnet.Checked) or (not rbCSV.Checked) or (not cbExportStockGroups.Checked) or Check83ValidFileWithExt(sFileName, 'MAP') then
                                        begin
                                          edStockGroupMap.Text := sFilename;

                                         {Outstanding Transactions Page}
                                          iNewPageIndex := 6;
                                          sFilename := edTXHedFilename.Text;
                                          if (not bAnyOSTX) or Check83ValidFileWithExt(sFileName, '') then
                                            begin
                                              edTXHedFilename.Text := sFilename;
                                              sFilename := edTXLinesFilename.Text;
                                              if (not bAnyOSTX) or (not rbCSV.Checked) or (not bTXSeparateFiles) or Check83ValidFileWithExt(sFileName, '') then
                                                begin
                                                  edTXLinesFilename.Text := sFilename;
                                                  if (not bAnyOSTX) or (not rbFile.Checked) or DirectoryExists(edTXDir.Text) then
                                                    begin
                                                      sFilename := edOutMap.Text;
                                                      if (not bAnyOSTX) or (not rbCSV.Checked) or Check83ValidFileWithExt(sFileName, 'MAP') then
                                                        begin
                                                          edOutMap.Text := sFilename;

                                                          {COM Pricing Options Page}
                                                          iNewPageIndex := 7;
                                                          sFileName := edCOMPriceDir.Text;
                                                          if (not cbCOMPricing.Checked) or (not rbFile.Checked) or DirectoryExists(edCOMPriceDir.Text) then
                                                          begin

                                                            {only warn if commandline file not found}
{                                                           if (Trim(edRunCommand.Text) <> '') then begin
                                                              if Pos(' ', edRunCommand.Text) = 0 then sFilename := edRunCommand.Text
                                                              else sFilename := copy(edRunCommand.Text,1, (Pos(' ', edRunCommand.Text) -1));

                                                              if (not FileExists(edRunCommand.Text))
                                                              then MsgBox('The Command line file that you have entered is not currently accessable.'
                                                              ,mtWarning,[mbOK],mbOK,'File does not exist');
                                                            end;{if}

                                                            Result := TRUE; {at last !}
                                                          end
                                                          else begin
                                                            sMessage := 'Invalid directory entered in Upload COM Pricing ''Directory'' Field.';
                                                            NewActiveControl := edCOMPriceDir;
                                                          end;
                                                          {Outstanding Transactions Page}
                                                        end
                                                      else begin
                                                        sMessage := 'Invalid filename entered in Outstanding Transactions ''CSV Map File'' Field.';
                                                        NewActiveControl := edOutMap;
                                                      end;{if}
                                                    end
                                                  else begin
                                                    sMessage := 'Invalid directory entered in Outstanding Transactions ''Directory'' Field.';
                                                    NewActiveControl := edTXDir;
                                                  end;{if}
                                                end
                                              else begin
                                                sMessage := 'Invalid filename entered in Outstanding Transactions ''Lines Filename'' Field.';
                                                NewActiveControl := edTXLinesFilename;
                                              end;{if}
                                            end
                                          else begin
                                            sMessage := 'Invalid filename entered in Outstanding Transactions ''Export Filename'' Field.';
                                            NewActiveControl := edTXHedFilename;
                                          end;{if}

                                          {Stock Group Records Page}
                                        end
                                      else begin
                                        sMessage := 'Invalid filename entered in Stock Group Records ''CSV Map File'' Field.';
                                        NewActiveControl := edStockGroupMap;
                                      end;{if}
                                    end
                                  else begin
                                    sMessage := 'Invalid directory entered in Stock Group Records ''Directory'' Field.';
                                    NewActiveControl := edStockGroupDir;
                                  end;{if}
                                end
                              else begin
                                sMessage := 'Invalid filename entered in Stock Group Records ''Filename'' Field.';
                                NewActiveControl := edStockGroupFileName;
                              end;{if}

                              {Stock Records Page}
                            end
                          else begin
                            sMessage := 'Invalid filename entered in Stock Records ''CSV Map File'' Field.';
                            NewActiveControl := edStockMap;
                          end;{if}
                        end
                      else begin
                        sMessage := 'Invalid directory entered in Stock Records ''Directory'' Field.';
                        NewActiveControl := edStockDir;
                      end;{if}
                    end
                  else begin
                    sMessage := 'Invalid filename entered in Stock Records ''Locations Filename'' Field.';
                    NewActiveControl := edStockLocFilename;
                  end;{if}
                end
              else begin
                sMessage := 'Invalid filename entered in Stock Records ''Stock Filename'' Field.';
                NewActiveControl := edStockFilename;
              end;{if}

              {Customer Records Page}
            end
          else begin
            sMessage := 'Invalid filename entered in Customer ''CSV Map File'' Field.';
            NewActiveControl := edCustMap;
          end;{if}
        end
      else begin
        sMessage := 'Invalid directory entered in Customer Records ''Directory'' Field.';
        NewActiveControl := edCustDir;
      end;{if}
    end
  else begin
    sMessage := 'Invalid filename entered in Customer Records ''Filename'' Field.';
    NewActiveControl := edCustFilename;
  end;{if}

  if not Result then begin
    MsgBox(sMessage,mtError,[mbOk],mbOK,'Invalid Entry');
    nbWizard.PageIndex := iNewPageIndex;
    ActiveControl := NewActiveControl;
    SetNextButtonCaption;
  end;{if}
end;

function TfrmExportWizard.CheckCSVMapFiles: boolean;
// Notes : Checks that the user's chosen CSV map file both exists and is of the
//         correct type.
type
  TMapFileError = (mfeNone, mfeMissing, mfeTypeMismatch);
var
  MapFileError : TMapFileError;
  NewPageIndex : byte;
  NewActiveControl : TWinControl;
  ErrMsg,
  FileName,
  FileDesc : string;
  CSVType : TExportType;

  function CheckMapFile : boolean;
  var
    MapFileRec : TMapFileRec;
    FullFileName : string;
  begin
    FullFileName := IncludeTrailingBackslash(sMapFileDirectory) + FileName;
    Result := FileExists(FullFileName);
    if not Result then
      MapFileError := mfeMissing
    else
    begin
      MapFileRec := GetMapFileRec(FullFileName);
      Result := MapFileRec.ExportType = CSVType;
      if not Result then
        MapFileError := mfeTypeMismatch
    end;
  end;

begin
  Result := true;
  if not rbCSV.Checked then
    exit;

  MapFileError := mfeNone;
  // Customer page
  if (cmbCustRec.Text <> 'No') then
  begin
    NewPageIndex := 3;
    NewActiveControl := edCustMap;
    FileName := edCustMap.Text;
    FileDesc := 'customer';
    CSVType := etAccount;
    Result := CheckMapFile;
  end;

  // Stock page
  if Result and (cmbStockRec.Text <> 'No') then
  begin
    NewPageIndex := 4;
    NewActiveControl := edStockMap;
    FileName := edStockMap.Text;
    FileDesc := 'stock';
    CSVType := etStockHeader;
    Result := CheckMapFile;
  end;

  // Stock group page
  if Result and cbExportStockGroups.Checked then
  begin
    NewPageIndex := 5;
    NewActiveControl := edStockGroupMap;
    FileName := edStockGroupMap.Text;
    FileDesc := 'stock group';
    CSVType := etStockGroup;
    Result := CheckMapFile;
  end;

  if Result and (cbOutSalesOrders.Checked or cbOutPurchOrders.Checked or
    cbOutSalesTx.Checked or cbOutPurchTX.Checked) then
  begin
    NewPageIndex := 6;
    NewActiveControl := edOutMap;
    FileName := edOutMap.Text;
    FileDesc := 'transactions';
    CSVType := etTXHeader;
    Result := CheckMapFile;
  end;

  if not Result then
  begin
    ErrMsg := Format('The specified %s CSV map file %s', [FileDesc, FileName]);
    if MapFileError = mfeMissing then
      ErrMsg := Format('%s is missing' + #13#10 +
        'in the map file directory %s', [ErrMsg, sMapFileDirectory])
    else
      ErrMsg := ErrMsg + #13#10 + 'is of the incorrect type';

    MsgBox(ErrMsg, mtError, [mbOk], mbOK, 'Invalid Entry');
    nbWizard.PageIndex := NewPageIndex;
    ActiveControl := NewActiveControl;
    SetNextButtonCaption;
  end;
end;

procedure TfrmExportWizard.btnCustFileLockClick(Sender: TObject);
var
  frmFileLocking: TfrmFileLocking;
  iFileNo : byte;
begin
  frmFileLocking := TfrmFileLocking.Create(Self);
  with frmFileLocking do begin
    try
      iFileNo := TButton(Sender).Tag;

      edFilename.Text := aFLFilenames[iFileNo];
      edExtension.Text := aFLExtensions[iFileNo];
      cmbStockLockType.ItemIndex := aFLType[iFileNo];

      if edFilename.Text <> '' then rbFilename.Checked := TRUE;

      if ShowModal = mrOK then begin
        if rbFilename.Checked then
          begin
            aFLFilenames[iFileNo] := edFilename.Text;
            aFLExtensions[iFileNo] := '';
          end
        else begin
          aFLFilenames[iFileNo] := '';
          aFLExtensions[iFileNo] := edExtension.Text;
        end;{if}
        aFLType[iFileNo] := cmbStockLockType.ItemIndex;
      end;{if}
    finally
      Release;
    end;{try}
  end;{with}
end;

procedure TfrmExportWizard.cbExportStockGroupsClick(Sender: TObject);
begin
  StockGroupRecEnable;
end;

procedure TfrmExportWizard.edStockFilterExit(Sender: TObject);
var
  sStockCode : string20;
  sCompPath : string;
begin
  if (ActiveControl <> btnCancel) and (ActiveControl <> nil) and (Trim(edStockFilter.Text) <> '') then begin
    sStockCode := edStockFilter.Text;
    sCompPath := GetCompanyDirFromCode(sCompanyCode);
    if DoGetStock(self, sCompPath, sStockCode, sStockCode, [stkGroup, stkProduct, stkBOM],
      vmShowList, true) then
      edStockFilter.Text := sStockCode
    else
      ActiveControl := TWinControl(Sender);
  end;{if}
end;

procedure TfrmExportWizard.cbCOMPricingClick(Sender: TObject);
begin
  COMPricingEnable;
end;

procedure TfrmExportWizard.FileNameExit(Sender: TObject);
var
  edtLocal : TEdit;
  FileName : string;
begin
  if (ActiveControl = btnCancel) or not (Sender is TEdit) then
    exit;

  edtLocal := Sender as TEdit;
  FileName := edtLocal.Text;
  if Check83ValidFileWithExt(FileName, '') then
  begin
    if ExtractFileExt(FileName) = '' then
    begin
      if rbeBisXML.Checked then
        FileName := ChangeFileExt(FileName, '.XML')
      else
        FileName := ChangeFileExt(FileName, '.CSV');
      edtLocal.Text := FileName;
    end;
  end
  else
  begin
    MsgBox('Invalid file name', mtError, [mbOk], mbOK, 'Invalid Entry');
    edtLocal.SetFocus;
  end;
end;

procedure TfrmExportWizard.btnHelpClick(Sender: TObject);
// Notes: The pages on a TNotebook are TPages, and appear to have very little in the
//        way of exposed properties.  It's possible to set the HelpContext IDs in the
//        Object Inspector but how do you access them?
var
  HelpCtx : longint;
begin
  case nbWizard.PageIndex of
    0: HelpCtx := 0;
    1: HelpCtx := 41;
    2: HelpCtx := 43;
    3: HelpCtx := 45;
    4: HelpCtx := 46;
    5: HelpCtx := 49;
    6: HelpCtx := 0;
    7: HelpCtx := 0;
    8: HelpCtx := 51;
    9: HelpCtx := 51;
   10: HelpCtx := 52;
   11: HelpCtx := 0;
  end;
  Application.HelpCommand(HELP_CONTEXT, HelpCtx);
end;


procedure TfrmExportWizard.btnSaveClick(Sender: TObject);
begin
  SaveExportAndClose;
end;

procedure TfrmExportWizard.btnCommandBrowseClick(Sender: TObject);
begin
  with OpenDialog1 do begin
    InitialDir := ExtractFilePath(edRunCommand.Text);
    if Execute then edRunCommand.Text := Files[0];
  end;{with}
end;

end.


