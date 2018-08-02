unit SysSetup;

{ prutherford440 09:49 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, eBusBtrv,
  StrUtil, ExtCtrls, StdCtrls, ComCtrls, ImgList, TEditVal, Mask, eBusUtil, eBusVar,
  AddComp, APIUtil, UseTKit, UseDLLU, eBusCnst, BrwseDir, FileCtrl, btsupu2;

const
  SECS_PER_DAY = 86400;

type
  TfrmSystemSetup = class(TForm)
    panSettings: TPanel;
    btnEdit: TButton;
    btnOK: TButton;
    nbSettings: TNotebook;
    ImageList1: TImageList;
    btnCancel: TButton;
    btnClose: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    btnCustDirBrowse: TButton;
    Bevel8: TBevel;
    Bevel1: TBevel;
    btnStockDirBrowse: TButton;
    Bevel2: TBevel;
    btnSGDirBrowse: TButton;
    Bevel3: TBevel;
    btnTXDirBrowse: TButton;
    Bevel4: TBevel;
    btnCOMPriceDirBrowse: TButton;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label6: TLabel;
    pcCompany: TPageControl;
    tsImportDefaults: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Bevel11: TBevel;
    pcFTP: TPageControl;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    btnAddCo: TButton;
    edCustExportDir: Text8Pt;
    edStockExportDir: Text8Pt;
    edStockGrpExportDir: Text8Pt;
    edTXExportDir: Text8Pt;
    edCOMPricingDir: Text8Pt;
    btnRemoveCo: TButton;
    pcEmail: TPageControl;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    panEmailServer: TPanel;
    Label34: TLabel;
    rbMAPI: TRadioButton;
    rbSMTP: TRadioButton;
    lServerName: TLabel;
    edServerName: TEdit;
    Bevel19: TBevel;
    Bevel18: TBevel;
    panEmailImport: TPanel;
    Label29: TLabel;
    edEmailAccName: TEdit;
    Label30: TLabel;
    edEmailAccPass: TEdit;
    panEmailNotify: TPanel;
    cbEmailConfirmProcess: TCheckBox;
    cbEmailConfirmReceipt: TCheckBox;
    Label31: TLabel;
    rbNotifyNever: TRadioButton;
    rbNotifyExchange: TRadioButton;
    rbNotifyAllXML: TRadioButton;
    Label28: TLabel;
    edAdminEmail: TEdit;
    panEmailAvail: TPanel;
    cbEmailAvail: TCheckBox;
    panEmailInherit: TPanel;
    cbEmailInherited: TCheckBox;
    Bevel10: TBevel;
    panOptions: TPanel;
    tvOptions: TTreeView;
    panDirInherit: TPanel;
    cbDirInherited: TCheckBox;
    panCompImport: TPanel;
    lCostCentre: TLabel;
    edCostCentre: TEdit;
    lDept: TLabel;
    edDepartment: TEdit;
    edLocation: TEdit;
    Label13: TLabel;
    edCustomer: TEdit;
    Label14: TLabel;
    edSupplier: TEdit;
    cmbVATCode: TComboBox;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    panCompTextFiles: TPanel;
    Bevel5: TBevel;
    btnOrderOKTextBrowse: TButton;
    edOrderOKText: TEdit;
    Bevel6: TBevel;
    btnOrderFailTextBrowse: TButton;
    edOrderFailText: TEdit;
    Bevel7: TBevel;
    btnInvoiceOKTextBrowse: TButton;
    edInvoiceOKText: TEdit;
    Bevel9: TBevel;
    btnInvoiceFailTextBrowse: TButton;
    edInvoiceFailText: TEdit;
    Label21: TLabel;
    Label20: TLabel;
    Label19: TLabel;
    Label18: TLabel;
    panCompOther: TPanel;
    cmbAfterProcess: TComboBox;
    Label27: TLabel;
    cbMaintainTXNo: TCheckBox;
    cbHoldTXHeld: TCheckBox;
    cbHoldTXWarn: TCheckBox;
    Label25: TLabel;
    cmbSetPeriod: TComboBox;
    Label26: TLabel;
    edPeriod: TEditPeriod;
    panFTPInherit: TPanel;
    cbFTPInherited: TCheckBox;
    panFTPSite: TPanel;
    Label38: TLabel;
    edFTPSiteAddress: TEdit;
    Label39: TLabel;
    edFTPSitePort: TCurrencyEdit;
    Label40: TLabel;
    edFTPSiteUser: TEdit;
    Label41: TLabel;
    edFTPSitePass: TEdit;
    panFTPProxy: TPanel;
    Label37: TLabel;
    edFTPProxyAddress: TEdit;
    Label36: TLabel;
    edFTPProxyPort: TCurrencyEdit;
    cbFTPProxyPassive: TCheckBox;
    panFTPDir: TPanel;
    edFTPRootDir: TEdit;
    edFTPCustDir: TEdit;
    edFTPStockDir: TEdit;
    edFTPTXDir: TEdit;
    Label46: TLabel;
    Label44: TLabel;
    Label43: TLabel;
    Label42: TLabel;
    edPurchNom: TEdit;
    edSalesNom: TEdit;
    lLocation: TLabel;
    tsFileLock: TTabSheet;
    PanCompFileLock: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    Bevel13: TBevel;
    Label12: TLabel;
    Bevel14: TBevel;
    Label35: TLabel;
    Bevel15: TBevel;
    Bevel12: TBevel;
    Panel1: TPanel;
    rbCustLockFile: TRadioButton;
    edCustLockFile: TEdit;
    rbCustLockExt: TRadioButton;
    edCustLockExt: TEdit;
    Panel2: TPanel;
    rbStockLockFile: TRadioButton;
    edStockLockFile: TEdit;
    rbStockLockExt: TRadioButton;
    edStockLockExt: TEdit;
    Panel3: TPanel;
    rbSGroupLockFile: TRadioButton;
    edSGroupLockFile: TEdit;
    rbSGroupLockExt: TRadioButton;
    edSGroupLockExt: TEdit;
    Panel4: TPanel;
    rbTXLockFile: TRadioButton;
    edTXLockFile: TEdit;
    rbTXLockExt: TRadioButton;
    edTXLockExt: TEdit;
    cmbCustLockType: TComboBox;
    cmbSGLockType: TComboBox;
    cmbTXLockType: TComboBox;
    Label45: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    cmbStockLockType: TComboBox;
    Label50: TLabel;
    panGlobal: TPanel;
    Label32: TLabel;
    Label33: TLabel;
    edEmailFreq: Text8Pt;
    btnEditText: TButton;
    tabCharges: TTabSheet;
    grpStk: TGroupBox;
    Label51: TLabel;
    edFreightStk: TEdit;
    Label52: TLabel;
    edMiscStk: TEdit;
    Label53: TLabel;
    edDiscStk: TEdit;
    grpDesc: TGroupBox;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    edFreightDesc: TEdit;
    edMiscDesc: TEdit;
    edDiscDesc: TEdit;
    Panel5: TPanel;
    cbUseStockForCharges: TComboBox;
    Label57: TLabel;
    grpLineTypes: TGroupBox;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    cmbFreightTX: TComboBox;
    cmbMiscTX: TComboBox;
    cmbDiscountTX: TComboBox;
    chkReapplyEntPricing: TCheckBox;
    Bevel17: TBevel;
    Bevel20: TBevel;
    Bevel16: TBevel;
    chkAltYourRef: TCheckBox;
    chkUseMatching: TCheckBox;
    chkSentimailEvent: TCheckBox;
    edtPassword: TEdit;
    Label58: TLabel;
    cmbLocOrigin: TComboBox;
    chkUdf1: TCheckBox;
    chkGeneralNotes: TCheckBox;
    chkCCDepFromXml: TCheckBox;
    chkBasda309: TCheckBox;
    chkDescLinesFromXML: TCheckBox;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tvOptionsChange(Sender: TObject; Node: TTreeNode);
    procedure nbSettingsPageChanged(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnAddCoClick(Sender: TObject);
    procedure btnRemoveCoClick(Sender: TObject);
    procedure EmailTypeClick(Sender: TObject);
    procedure cbEmailAvailClick(Sender: TObject);
    procedure cbInheritedClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cmbSetPeriodChange(Sender: TObject);
    procedure edCostCentreExit(Sender: TObject);
    procedure edDepartmentExit(Sender: TObject);
    procedure edLocationExit(Sender: TObject);
    procedure edCustomerExit(Sender: TObject);
    procedure edSupplierExit(Sender: TObject);
    procedure edPurchNomExit(Sender: TObject);
    procedure FileBrowse(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure btnCustDirBrowseClick(Sender: TObject);
    procedure edCustExportDirExit(Sender: TObject);
    procedure EditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure btnEditTextClick(Sender: TObject);
    procedure rbCustLockFileClick(Sender: TObject);
    procedure edEmailFreqExit(Sender: TObject);
    procedure pcCompanyChange(Sender: TObject);
    procedure pcFTPChange(Sender: TObject);
    procedure pcEmailChange(Sender: TObject);
    procedure edFreightStkExit(Sender: TObject);
    procedure cbUseStockForChargesChange(Sender: TObject);
  private

    bImportWarn, bPrevInherited : boolean;
    bCompSettingsOnly : Boolean;
    procedure FillTreeView;

    procedure FillGlobalSettings;
    procedure SaveGlobalSettings;

    procedure FillCompanySettings;
    function SaveCompanySettings : boolean;

    procedure FillFileSettings;
    function SaveFileSettings : boolean;

    procedure FillEmailSettings;
    procedure SaveEmailSettings;

    procedure FillFTPSettings;
    procedure SaveFTPSettings;

    procedure DeleteSettings(BtrieveType : TEBusBtrieveCompCode);
    procedure nbEnableDisable(bEnable : boolean);
    procedure EnableControl(Item : TWinControl; bEnable : boolean);
    procedure EnablePageControl(PageControl : TPageControl; bEnable : boolean);
    procedure GreyInOut;
    procedure FillVATCodes;
    procedure FillTxLineTypes;
  public
    sTextFileDir : string;
    function DoPasswordCheck : Boolean;
    constructor CreateForCompSettingsOnly(AOwner : TComponent);
  end;

var
  frmSystemSetup: TfrmSystemSetup;

implementation

uses
  EntUtil, SelFile, MiscUtil, TKUtil, EntLkup, TextFile, VarConst, PWord, ExchequerRelease;



{$R *.DFM}
Procedure GetDirParam;

Var
  n  :  Integer;

Begin
  ebSetDrive:='';

  For n:=0 to Pred(ParamCount) do
  Begin
    If UpperCase(ParamStr(n))=ebEntDirSw then
    Begin
      ebSetDrive:=IncludeTrailingBackslash(ParamStr(n+1));
      Break;
    end;

  end;


end;


procedure TfrmSystemSetup.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSystemSetup.FormCreate(Sender: TObject);
var
  iResult : Integer;
begin
  Caption := 'eBusiness System Setup - Version: ' + ExchequerModuleVersion(emEbusinessSettings, BuildNo);
  GetDirParam;
  if bCompSettingsOnly then
    FillCompanySettings
  else
  begin
    edFTPSitePort.displayformat := '###0'; {cos this gets reset @ run-time - nice}
    edFTPProxyPort.displayformat := '###0'; {cos this gets reset @ run-time - nice}

    FillTreeView;
    nbSettings.PageIndex := 0;
    pcCompany.ActivePageIndex := 0;
    pcEmail.ActivePageIndex := 0;
    pcFTP.ActivePageIndex := 0;

    sTextFileDir := IncludeTrailingBackslash(GetMultiCompDir) + 'eBus\Text\';

    bImportWarn := FALSE;

    Syss.TxLateCR := True;

    SetToolkitPath(GetMultiCompDir);
    iResult := Ex_InitDLL;
    if iResult = 0 then
    begin
      chkSentimailEvent.Enabled := EX_CHECKMODULERELEASECODE(14) in [1,2];
    end
    else
      chkSentimailEvent.Enabled := False;
    Ex_CloseData;
  end;
end;

procedure TfrmSystemSetup.tvOptionsChange(Sender: TObject; Node: TTreeNode);
var
  BatchSysRec : TBatchSysRec;
  iResult : integer;
begin
  btnRemoveCo.Enabled := (Node.Level = 0) and (tvOptions.Selected.Text <> 'Global');
  nbSettings.visible := (Node.Level = 1) or (Node.Text = 'Global');
  btnEdit.Enabled := (Node.Level = 1) or ((tvOptions.selected <> nil) and (tvOptions.selected.Text = 'Global'));
  case Node.Level of
    0 : begin
      nbSettings.PageIndex := 0;
      if Node.Text = 'Global' then FillGlobalSettings;
    end;

    1 : begin
      if Node.Text = 'Company Settings' then
        begin
          nbSettings.PageIndex := 1;
          FillVATCodes;
          FillTxLineTypes;
          FillCompanySettings;

          iResult := EX_GETSYSDATA(@BatchSysRec, SizeOf(BatchSysRec));
          if iResult = 0 then
            begin
              edCostCentre.Enabled := BatchSysRec.CCDepts;
              lCostCentre.Enabled := BatchSysRec.CCDepts;
              edDepartment.Enabled := BatchSysRec.CCDepts;
              lDept.Enabled := BatchSysRec.CCDepts;

              edLocation.Enabled := BatchSysRec.MultiLocn = 2;
              cmbLocOrigin.Enabled := edLocation.Enabled;
              lLocation.Enabled := BatchSysRec.MultiLocn = 2;
            end
          else ShowMessage('EX_GETECOMMSDATA Error : ' + IntToStr(iResult));

          Ex_CloseData;
        end
      else begin
        if Node.Text = 'Directory Defaults' then
          begin
{            cbDirInherited.Enabled := tvOptions.Selected.Parent.Text <> 'Global';}
            cbDirInherited.Visible := tvOptions.Selected.Parent.Text <> 'Global';
            nbSettings.PageIndex := 2;
            FillFileSettings;
          end
        else begin
          if Node.Text = 'Email Settings' then
            begin
{              cbEmailInherited.Enabled := tvOptions.Selected.Parent.Text <> 'Global';}
              cbEmailInherited.Visible := tvOptions.Selected.Parent.Text <> 'Global';
              nbSettings.PageIndex := 3;
              FillEmailSettings;
            end
          else begin
            if Node.Text = 'FTP Settings' then begin
{              cbFTPInherited.Enabled := tvOptions.Selected.Parent.Text <> 'Global';}
              cbFTPInherited.Visible := tvOptions.Selected.Parent.Text <> 'Global';
              nbSettings.PageIndex := 4;
              FillFTPSettings;
            end;{if}
          end;{if}
        end;{if}
      end;{if}
    end;
  end;{case}
end;

procedure TfrmSystemSetup.FillGlobalSettings;
var
  iSecs, iMins : integer;
  ebus : TEBusBtrieveParams;
begin
    ebus := TEBusBtrieveParams.Create(TRUE);
    with ebus do begin
//  with TEBusBtrieveParams.Create(TRUE) do begin
    try
      Openfile;
      if FindRecord = 0 then begin
        iSecs := ParamsSettings.EntPollFreq MOD 60;
        iMins := ParamsSettings.EntPollFreq DIV 60;
        edEmailFreq.Text := PadString(psLeft,IntToStr(iMins),'0',2) + PadString(psLeft,IntToStr(iSecs),'0',2);
        edtPassword.Text := ParamsSettings.EntSetupPassword;
      end;{if}
      CloseFile;
    finally
      free;
    end;{try}
  end;{with}
end;

procedure TfrmSystemSetup.FillCompanySettings;
var
  stemp : string;
begin
  with TEBusBtrieveCompany.Create(TRUE) do begin
    try
      Openfile;
      CompanyCode := TCompanyInfo(tvOptions.Selected.Parent.Data).CompanyRec.CompCode;
      sTextFileDir := Trim(TCompanyInfo(tvOptions.Selected.Parent.Data).CompanyRec.CompPath) + 'eBus\Text\';
      if FindRecord = 0 then begin
        with CompanySettings do begin
          {import Defaults}
          edCostCentre.Text := CompDefCostCentre;
          edDepartment.Text := CompDefDept;
          //PR: 28/09/2012 ABSEXCH-13432|20/05/2013 ABSEXCH-11905
          chkCCDepFromXML.Checked := CompCCDepFromXML;
          //PR: 11/06/2009 Added switch for Basda eBIS-XML 3.09 schema
          chkBasda309.Checked := CompUseBasda309;
          edLocation.Text := CompDefLocation;

          cmbLocOrigin.ItemIndex := CompLocationOrigin;
          edCustomer.Text := CompDefCustomer;
          edSupplier.Text := CompDefSupplier;
          sTemp := CompDefVATCode + ' - ' + GetVATDescription(CompDefVATCode);
          cmbVATCode.ItemIndex := cmbVATCode.Items.IndexOf(sTemp);
          edPurchNom.Text := IntToStr(CompDefPurchNom);
          edSalesNom.Text := IntToStr(CompDefSalesNom);

          {Text Files}
          edOrderOKText.Text := CompOrdOKTextFile;
          edOrderFailText.Text := CompOrdFailTextFile;
          edInvoiceOKText.Text := CompInvOKTextFile;
          edInvoiceFailText.Text := CompInvFailTextFile;


          {other}
          cmbFreightTX.ItemIndex := CompFreightLine - 1;
          cmbMiscTX.ItemIndex := CompMiscLine - 1;
          cmbDiscountTX.ItemIndex := CompDiscount - 1;

          if cmbMiscTX.ItemIndex = -1 then
            cmbMiscTX.ItemIndex := 1;

          cmbAfterProcess.ItemIndex := CompXMLAfterProcess;
          cbMaintainTXNo.Checked := CompKeepTransNo > 0;
          chkUseMatching.Checked := CompUseMatching;

          cbHoldTXHeld.Checked := CompPostHoldFlag and 1 = 1;
          cbHoldTXWarn.Checked := CompPostHoldFlag and 2 = 2;

          cmbSetPeriod.ItemIndex := CompSetPeriodMethod;
          cmbSetPeriodChange(nil);
          if cmbSetPeriod.ItemIndex = 2 then
            begin
              edPeriod.Eperiod := CompPeriod;
              edPeriod.EYear := CompYear;
            end
          else begin
            edPeriod.Eperiod := 0;
            edPeriod.EYear := 0;
          end;{if}

          {File Locking}
          edCustLockFile.Text := CompCustLockFile;
          edStockLockFile.Text := CompStockLockFile;
          edSGroupLockFile.Text := CompStockGrpLockFile;
          edTXLockFile.Text := CompTransLockFile;
          edCustLockExt.Text := CompCustLockExt;
          edStockLockExt.Text := CompStockLockExt;
          edSGroupLockExt.Text := CompStockGrpLockExt;
          edTXLockExt.Text := CompTransLockExt;

          if edCustLockFile.Text <> '' then rbCustLockFile.Checked := TRUE;
          if edStockLockFile.Text <> '' then rbStockLockFile.Checked := TRUE;
          if edSGroupLockFile.Text <> '' then rbSGroupLockFile.Checked := TRUE;
          if edTXLockFile.Text <> '' then rbTXLockFile.Checked := TRUE;

          cmbCustLockType.ItemIndex := CompCustLockMethod;
          cmbStockLockType.ItemIndex := CompStockLockMethod;
          cmbSGLockType.ItemIndex := CompStockGrpMethod;
          cmbTXLockType.ItemIndex := CompTransLockMethod;

          chkReapplyEntPricing.Checked := CompReapplyPricing <> 0;
          //Temporarily disable reapply pricing checkbox until tested
          //chkReapplyEntPricing.Enabled := False;

          //Charge fields
          cbUseStockForCharges.ItemIndex := CompUseStockForCharges;
          cbUseStockForChargesChange(Self);

          edFreightStk.Text := CompFreightStockCode;
          edMiscStk.Text    := CompMiscStockCode;
          edDiscStk.Text    := CompDiscStockCode;

          if CompFreightDesc <> '' then
            edFreightDesc.Text := CompFreightDesc
          else
            edFreightDesc.Text := DefaultFreightDesc;

          if CompMiscDesc <> '' then
            edMiscDesc.Text := CompMiscDesc
          else
            edMiscDesc.Text := DefaultMiscDesc;

          if CompDiscDesc <> '' then
            edDiscDesc.Text := CompDiscDesc
          else
            edDiscDesc.Text := DefaultDiscDesc;

          chkAltYourRef.Checked := CompYourRefToAltRef;

          grpStk.Enabled := False;
          grpDesc.Enabled := False;
          grpLineTypes.Enabled := False;
          Panel5.Enabled := False;

          chkSentimailEvent.Checked := CompSentimailEvent;
          chkUdf1.Checked := CompImportUDF1;
          chkGeneralNotes.Checked := CompGeneralNotes;

        //PR: 28/09/2012 ABSEXCH-13432|20/05/2013 ABSEXCH-11905
         chkDescLinesFromXML.Checked := CompDescLinesFromXML;

        end;{with}
      end;{if}
      CloseFile;
    finally
      free;
    end;{try}
  end;{with}
end;

procedure TfrmSystemSetup.SaveGlobalSettings;
var
  iSecs, iMins, Status : integer;
begin
  {save settings}
  with TEBusBtrieveParams.Create(TRUE) do begin
    try
      Openfile;
      Status := FindRecord;

      iMins := StrToInt(copy(edEmailFreq.Text,1,2));
      iSecs := StrToInt(copy(edEmailFreq.Text,3,2));
      ParamsSettings.EntPollFreq := (iMins * 60) + iSecs;
      ParamsSettings.EntSetupPassword := edtPassword.Text;
      if Status = 0 then
        UpdateRecord
      else
        if Status = 4 then
          AddRecord;
      CloseFile;
    finally
      free;
    end;{try}
  end;{with}
  bImportWarn := TRUE;
end;

function TfrmSystemSetup.SaveCompanySettings : boolean;
var
  sPurchNom, sSalesNom, sSupplier, sCustCode, sDepartment, sCostCentre, sStockCode : string20;
  sLocation : string10;
  sMessage, sCompPath : string;
  iNewPageIndex, iSalesNom, iPurchNom : integer;
  NewActiveControl : TWinControl;
begin
  {First Validate Company Settings}
  sCompPath := IncludeTrailingBackslash(Trim(TCompanyInfo(tvOptions.Selected.Parent.Data).CompanyRec.CompPath));
  sMessage := '';

  sCostCentre := edCostCentre.Text;
  iNewPageIndex := 0;
  if edCostCentre.Enabled and (not DoGetCCDep(Self,sCompPath, sCostCentre, sCostCentre, TRUE, vmCheckValue, TRUE)) then
    begin
      NewActiveControl := edCostCentre;
      sMessage := 'Import Cost Centre';
    end
  else begin
    sDepartment := edDepartment.Text;
    if edDepartment.Enabled and (not DoGetCCDep(Self, sCompPath, sDepartment, sDepartment, FALSE, vmCheckValue, TRUE)) then
      begin
        NewActiveControl := edDepartment;
        sMessage := 'Import Department';
      end
    else begin
      sLocation := edLocation.Text;
      if edLocation.Enabled and (not DoGetMLoc(Self, sCompPath, sLocation, sLocation, vmCheckValue, TRUE)) then
        begin
          NewActiveControl := edLocation;
          sMessage := 'Import Location';
        end
      else begin
        sCustCode := edCustomer.Text;
        if not DoGetCust(Self, sCompPath, sCustCode, sCustCode, trdCustomer, vmCheckValue, TRUE) then
          begin
            NewActiveControl := edCustomer;
            sMessage := 'Import Customer';
          end
        else begin
          sSupplier := edSupplier.Text;
          if not DoGetCust(Self, sCompPath, sSupplier, sSupplier, trdSupplier, vmCheckValue, TRUE) then
            begin
              NewActiveControl := edSupplier;
              sMessage := 'Import Supplier';
            end
          else begin
            if cmbVATCode.ItemIndex = -1 then
              begin
                NewActiveControl := cmbVATCode;
                sMessage := 'VAT Code';
              end
            else begin
              sPurchNom := edPurchNom.Text;
              iPurchNom := StrToInt(edPurchNom.Text);
              if not DoGetNom(Self, sCompPath, sPurchNom, iPurchNom, [nomProfitAndLoss], vmCheckValue, TRUE) then
                begin
                  NewActiveControl := edPurchNom;
                  sMessage := 'Import Purchase GL Code';
                end
              else begin
                sSalesNom := edSalesNom.Text;
                iSalesNom := StrToInt(edSalesNom.Text);
                if not DoGetNom(Self, sCompPath, sSalesNom, iSalesNom, [nomProfitAndLoss], vmCheckValue, TRUE) then
                  begin
                    NewActiveControl := edSalesNom;
                    sMessage := 'Import Sales GL Code';
                  end
                else begin
                  iNewPageIndex := 1;
                  if (Trim(edOrderOKText.Text) <> '') and (not FileExists(sTextFileDir + edOrderOKText.Text)) then
                    begin
                      NewActiveControl := edOrderOKText;
                      sMessage := 'Order OK Text File';
                    end
                  else begin
                    if (Trim(edOrderFailText.Text) <> '') and (not FileExists(sTextFileDir + edOrderFailText.Text)) then
                      begin
                        NewActiveControl := edOrderFailText;
                        sMessage := 'Order Fail Text File';
                      end
                    else begin
                      if (Trim(edInvoiceOKText.Text) <> '') and (not FileExists(sTextFileDir + edInvoiceOKText.Text)) then
                        begin
                          NewActiveControl := edInvoiceOKText;
                          sMessage := 'Invoice OK Text File';
                        end
                      else begin
                        if (Trim(edInvoiceFailText.Text) <> '') and (not FileExists(sTextFileDir + edInvoiceFailText.Text)) then
                          begin
                            NewActiveControl := edInvoiceFailText;
                            sMessage := 'Invoice Fail Text File';
                          end
                        else begin
                          iNewPageIndex := 3;
                          if cmbFreightTX.ItemIndex = -1 then
                            begin
                              NewActiveControl := cmbFreightTX;
                              sMessage := 'Freight Transaction Line';
                            end
                          else begin
                            if cmbMiscTX.ItemIndex = -1 then
                              begin
                                NewActiveControl := cmbMiscTX;
                                sMessage := 'Misc. Transaction Line';
                              end
                            else begin
                              if cmbDiscountTX.ItemIndex = -1 then
                                begin
                                  NewActiveControl := cmbDiscountTX;
                                  sMessage := 'Discount Transaction Line';
                                end
                              else begin
                                if cmbAfterProcess.ItemIndex = -1 then
                                  begin
                                    NewActiveControl := cmbAfterProcess;
                                    sMessage := 'After Processing XML';
                                  end
                                else begin
                                  if cmbSetPeriod.ItemIndex = -1 then begin
                                    NewActiveControl := cmbSetPeriod;
                                    sMessage := 'Set Period';
                                  end
                                else
                                begin
                                  iNewPageIndex := 4;
                                  if cbUseStockForCharges.ItemIndex = 1 then
                                  begin
                                    sStockCode := edFreightStk.Text;
                                    if not DoGetStock(Self, sCompPath, sStockCode, sStockCode,
                                     [stkProduct], vmCheckValue, TRUE) then
                                    begin
                                      NewActiveControl := edFreightStk;
                                      sMessage := 'Freight Stock Code';
                                    end
                                    else
                                    begin
                                      sStockCode := edMiscStk.Text;
                                      if not DoGetStock(Self, sCompPath, sStockCode, sStockCode,
                                       [stkProduct], vmCheckValue, TRUE) then
                                      begin
                                        NewActiveControl := edMiscStk;
                                        sMessage := 'Misc Stock Code';
                                      end
                                      else
                                      begin
                                        sStockCode := edDiscStk.Text;
                                        if not DoGetStock(Self, sCompPath, sStockCode, sStockCode,
                                                     [stkProduct], vmCheckValue, TRUE) then
                                        begin
                                          NewActiveControl := edDiscStk;
                                          sMessage := 'Discount Stock Code';
                                        end;
                                      end;
                                    end;


                                  end;
                                end;
                                end;{if}
                              end;{if}
                            end;{if}
                          end;{if}
                        end;{if}
                      end;{if}
                    end;{if}
                  end;{if}
                end;{if}
              end;{if}
            end;{if}
          end;{if}
        end;{if}
      end;{if}
    end;{if}
  end;{if}

  if sMessage = '' then
    begin
      {save settings}
      with TEBusBtrieveCompany.Create(TRUE) do begin
        try
          Openfile;
          CompanyCode := TCompanyInfo(tvOptions.Selected.Parent.Data).CompanyRec.CompCode;
          if FindRecord = 0 then begin
            with CompanySettings do begin

              {import Defaults}
              CompDefCostCentre := edCostCentre.Text;
              CompDefDept := edDepartment.Text;
              CompCCDepFromXML := chkCCDepFromXML.Checked;
              //PR: 11/06/2009 Added switch for Basda eBIS-XML 3.09 schema
              CompUseBasda309 := chkBasda309.Checked;
              CompDefLocation := edLocation.Text;
              CompLocationOrigin := cmbLocOrigin.ItemIndex;
              CompDefCustomer := edCustomer.Text;
              CompDefSupplier := edSupplier.Text;
              CompDefVATCode := cmbVATCode.Items[cmbVATCode.ItemIndex][1];
              CompDefPurchNom := StrToInt(edPurchNom.Text);
              CompDefSalesNom := StrToInt(edSalesNom.Text);

              {Text Files}
              CompOrdOKTextFile := edOrderOKText.Text;
              CompOrdFailTextFile := edOrderFailText.Text;
              CompInvOKTextFile := edInvoiceOKText.Text;
              CompInvFailTextFile := edInvoiceFailText.Text;

              {other}
              CompFreightLine := cmbFreightTX.ItemIndex + 1;
              CompMiscLine := cmbMiscTX.ItemIndex + 1;
              CompDiscount := cmbDiscountTX.ItemIndex + 1;

              CompXMLAfterProcess := cmbAfterProcess.ItemIndex;
(* PR 27/11/03 - This was using CompKeepTransNo for maintain transaction no and post as held - not very successfully.

              CompKeepTransNo := Ord(cbMaintainTXNo.Checked);
              CompUseMatching := chkUseMatching.Checked;

              CompKeepTransNo := 0;
              if cbHoldTXHeld.Checked then CompKeepTransNo := CompKeepTransNo + 1;
              if cbHoldTXWarn.Checked then CompKeepTransNo := CompKeepTransNo + 2; *)


              CompKeepTransNo := Ord(cbMaintainTXNo.Checked);
              CompUseMatching := chkUseMatching.Checked;

              CompPostHoldFlag := 0;
              if cbHoldTXHeld.Checked then CompPostHoldFlag := CompPostHoldFlag or 1;
              if cbHoldTXWarn.Checked then CompPostHoldFlag := CompPostHoldFlag or 2;

              CompSetPeriodMethod := cmbSetPeriod.ItemIndex;
              if CompSetPeriodMethod = 2 then begin
                CompPeriod := edPeriod.Eperiod;
                CompYear := edPeriod.EYear;
              end;{if}

              {File Locking}
              if rbCustLockFile.Checked then
                begin
                  CompCustLockFile := edCustLockFile.Text;
                  CompCustLockExt := '';
                end
              else begin
                CompCustLockFile := '';
                CompCustLockExt := edCustLockExt.Text;
              end;{if}

              if rbStockLockFile.Checked then
                begin
                  CompStockLockFile := edStockLockFile.Text;
                  CompStockLockExt := '';
                end
              else begin
                CompStockLockFile := '';
                CompStockLockExt := edStockLockExt.Text;
              end;{if}

              if rbSGroupLockFile.Checked then
                begin
                  CompStockGrpLockFile := edSGroupLockFile.Text;
                  CompStockGrpLockExt := '';
                end
              else begin
                CompStockGrpLockFile := '';
                CompStockGrpLockExt := edSGroupLockExt.Text;
              end;{if}

              if rbTXLockFile.Checked then
                begin
                  CompTransLockFile := edTXLockFile.Text;
                  CompTransLockExt := '';
                end
              else begin
                CompTransLockFile := '';
                CompTransLockExt := edTXLockExt.Text;
              end;{if}

              CompCustLockMethod := cmbCustLockType.ItemIndex;
              CompStockLockMethod := cmbStockLockType.ItemIndex;
              CompStockGrpMethod := cmbSGLockType.ItemIndex;
              CompTransLockMethod := cmbTXLockType.ItemIndex;

              if chkReapplyEntPricing.Checked then
                CompReapplyPricing := 1
              else
                CompReapplyPricing := 0;

              //Charge fields
              CompUseStockForCharges := cbUseStockForCharges.ItemIndex;


              CompFreightStockCode := edFreightStk.Text;
              CompMiscStockCode    := edMiscStk.Text;
              CompDiscStockCode    := edDiscStk.Text;

              CompFreightDesc := edFreightDesc.Text;
              CompMiscDesc    := edMiscDesc.Text;
              CompDiscDesc    := edDiscDesc.Text;

              CompYourRefToAltRef := chkAltYourRef.Checked;

              CompSentimailEvent := chkSentimailEvent.Checked;
              CompImportUDF1 := chkUdf1.Checked;
              CompGeneralNotes := chkGeneralNotes.Checked;

             CompDescLinesFromXML := chkDescLinesFromXML.Checked;
            end;{with}
          end;{if}
          UpdateRecord;
          CloseFile;
        finally
          free;
        end;{try}
      end;{with}
      bImportWarn := TRUE;
    end
  else begin
    {Validation Error}
    MsgBox('An invalid value has been entered into the following field : ''' + sMessage
    + '''' + #13 + #13 + 'Please enter a valid value.',mtError,[mbOK],mbOK,'Validation Error');
    pcCompany.ActivePageIndex := iNewPageIndex;
    ActiveControl := NewActiveControl;
  end;{if}

  Result := sMessage = '';
end;

procedure TfrmSystemSetup.FillFileSettings;
begin
  cbDirInherited.Checked := (tvOptions.Selected.ImageIndex = 3)
  and (tvOptions.Selected.Parent.Text <> 'Global');

  with TEBusBtrieveFile.Create(TRUE) do begin
    try
      Openfile;
      if tvOptions.Selected.ImageIndex = 2 then CompanyCode := TCompanyInfo(tvOptions.Selected.Parent.Data).CompanyRec.CompCode
      else CompanyCode := '';

      if FindRecord = 0 then begin
        with FileSettings do begin
          edCustExportDir.Text := FileCustomerDir;
          edStockExportDir.Text := FileStockDir;
          edStockGrpExportDir.Text := FileStockGroupDir;
          edTXExportDir.Text := FileTransDir;
          edCOMPricingDir.Text := FileCOMPriceDir;
        end;{with}
      end;{if}
      CloseFile;
    finally
      free;
    end;{try}
  end;{with}
end;

function TfrmSystemSetup.SaveFileSettings : boolean;
var
  bUpdate : boolean;
  NewActiveControl : TWinControl;
  sMessage : string;
begin
  sMessage := '';
  if (edCustExportDir.Text <> '') and (not DirectoryExists(edCustExportDir.Text)) then
    begin
      NewActiveControl := edCustExportDir;
      sMessage := 'Customer Export Dir';
    end
  else begin
    if (edStockExportDir.Text <> '') and (not DirectoryExists(edStockExportDir.Text)) then
      begin
        NewActiveControl := edStockExportDir;
        sMessage := 'Stock Export Dir';
      end
    else begin
      if (edStockGrpExportDir.Text <> '') and (not DirectoryExists(edStockGrpExportDir.Text)) then
        begin
          NewActiveControl := edStockGrpExportDir;
          sMessage := 'Stock Group Export Dir';
        end
      else begin
        if (edTXExportDir.Text <> '') and (not DirectoryExists(edTXExportDir.Text)) then
          begin
            NewActiveControl := edTXExportDir;
            sMessage := 'Transactions Export Dir';
          end
        else begin
          if (edCOMPricingDir.Text <> '') and (not DirectoryExists(edCOMPricingDir.Text)) then begin
            NewActiveControl := edCOMPricingDir;
            sMessage := 'COM Pricing Export Dir';
          end;{if}
        end;{if}
      end;{if}
    end;{if}
  end;{if}

  if sMessage = '' then
    begin
      with TEBusBtrieveFile.Create(TRUE) do begin
        try
          Openfile;

          if tvOptions.Selected.Parent.Text = 'Global' then CompanyCode := ''
          else CompanyCode := TCompanyInfo(tvOptions.Selected.Parent.Data).CompanyRec.CompCode;

          bUpdate := FindRecord = 0;

    {      BlankRecord;}
          with FileSettings do begin
            FileCustomerDir := edCustExportDir.Text;
            FileStockDir := edStockExportDir.Text;
            FileStockGroupDir := edStockGrpExportDir.Text;
            FileTransDir := edTXExportDir.Text;
            FileCOMPriceDir := edCOMPricingDir.Text;
          end;{with}

          if bUpdate then UpdateRecord
          else AddRecord;

          CloseFile;
        finally
          free;
        end;{try}
      end;{with}
    end
  else begin
    {Validation Error}
    MsgBox('An invalid value has been entered into the following field : ''' + sMessage
    + '''' + #13 + #13 + 'Please enter a valid value.',mtError,[mbOK],mbOK,'Validation Error');
    ActiveControl := NewActiveControl;
  end;{if}

  Result := sMessage = '';
end;

procedure TfrmSystemSetup.FillEmailSettings;
begin
  cbEmailInherited.Checked := (tvOptions.Selected.ImageIndex = 3)
  and (tvOptions.Selected.Parent.Text <> 'Global');

  with TEBusBtrieveEmail.Create(TRUE) do begin
    try
      Openfile;
      if tvOptions.Selected.ImageIndex = 2 then CompanyCode := TCompanyInfo(tvOptions.Selected.Parent.Data).CompanyRec.CompCode
      else CompanyCode := '';

      if FindRecord = 0 then begin
        with EmailSettings do begin
          cbEmailAvail.Checked := EmailEnabled;
          case EmailType of
            1 : rbMAPI.Checked := TRUE;
            2 : rbSMTP.Checked := TRUE;
          end;{Case}
          edServerName.Text := EmailServerName;
          edEmailAccName.Text := EmailAccountName;
          edEmailAccPass.Text := EmailAccountPassword;
          cbEmailConfirmProcess.Checked := EmailConfirmProcessing > 0;
          cbEmailConfirmReceipt.Checked := EmailNotifySender > 0;
          case EmailNotifyAdmin of
            0 : rbNotifyNever.Checked := TRUE;
            1 : rbNotifyExchange.Checked := TRUE;
            2 : rbNotifyAllXML.Checked := TRUE;
          end;{case}
          edAdminEmail.Text := EmailAdminAddress;
        end;{with}
      end;{if}
      CloseFile;
    finally
      free;
    end;{try}
  end;{with}
end;

procedure TfrmSystemSetup.SaveEmailSettings;
var
  bUpdate : boolean;
begin
  with TEBusBtrieveEmail.Create(TRUE) do begin
    try
      Openfile;

      if tvOptions.Selected.Parent.Text = 'Global' then CompanyCode := ''
      else CompanyCode := TCompanyInfo(tvOptions.Selected.Parent.Data).CompanyRec.CompCode;

      bUpdate := FindRecord = 0;

{      BlankRecord;}
      with EmailSettings do begin
        EmailEnabled := cbEmailAvail.Checked;
        EmailType := Ord(rbSMTP.Checked)  + 1;
        EmailServerName := edServerName.Text;
        EmailAccountName := edEmailAccName.Text;
        EmailAccountPassword := edEmailAccPass.Text;
        EmailConfirmProcessing := Ord(cbEmailConfirmProcess.Checked);
        EmailNotifySender := Ord(cbEmailConfirmReceipt.Checked);
        if rbNotifyNever.Checked then EmailNotifyAdmin := 0
        else begin
          if rbNotifyExchange.Checked then EmailNotifyAdmin := 1
          else begin
            if rbNotifyAllXML.Checked then EmailNotifyAdmin := 2;
          end;{if}
        end;{if}
        EmailAdminAddress := edAdminEmail.Text;
      end;{with}

      if bUpdate then UpdateRecord
      else AddRecord;

      CloseFile;
    finally
      free;
    end;{try}
  end;{with}
  bImportWarn := TRUE;
end;

procedure TfrmSystemSetup.FillFTPSettings;
begin
  cbFTPInherited.Checked := (tvOptions.Selected.ImageIndex = 3)
  and (tvOptions.Selected.Parent.Text <> 'Global');

  with TEBusBtrieveFTP.Create(TRUE) do begin
    try
      Openfile;
      if tvOptions.Selected.ImageIndex = 2 then CompanyCode := TCompanyInfo(tvOptions.Selected.Parent.Data).CompanyRec.CompCode
      else CompanyCode := '';

      if FindRecord = 0 then begin
        with FTPSettings do begin
          edFTPSiteAddress.Text := FTPSiteAddress;
          edFTPSitePort.Text := IntToStr(FTPSitePort);
          edFTPSiteUser.Text := FTPUserName;
          edFTPSitePass.Text := FTPPassword;
          edFTPProxyAddress.Text := FTPProxyAddress;
          edFTPProxyPort.Text := IntToStr(FTPProxyPort);
          cbFTPProxyPassive.Checked := FTPPassiveMode > 0;
          edFTPRootDir.Text := FTPRootDir;
          edFTPCustDir.Text := FTPCustomerDir;
          edFTPStockDir.Text := FTPStockDir;
          edFTPTXDir.Text := FTPTransactionDir;
        end;{with}
      end;{if}
      CloseFile;
    finally
      free;
    end;{try}
  end;{with}
end;

procedure TfrmSystemSetup.SaveFTPSettings;
var
  bUpdate : boolean;
begin
  with TEBusBtrieveFTP.Create(TRUE) do begin
    try
      Openfile;

      if tvOptions.Selected.Parent.Text = 'Global' then CompanyCode := ''
      else CompanyCode := TCompanyInfo(tvOptions.Selected.Parent.Data).CompanyRec.CompCode;

      bUpdate := FindRecord = 0;

{      BlankRecord;}
      with FTPSettings do begin
        FTPSiteAddress := edFTPSiteAddress.Text;
        FTPSitePort := StrToInt(edFTPSitePort.Text);
        FTPUserName := edFTPSiteUser.Text;
        FTPPassword := edFTPSitePass.Text;
        FTPProxyAddress := edFTPProxyAddress.Text;
        FTPProxyPort := StrToInt(edFTPProxyPort.Text);
        FTPPassiveMode := Ord(cbFTPProxyPassive.Checked);
        FTPRootDir := edFTPRootDir.Text;
        FTPCustomerDir := edFTPCustDir.Text;
        FTPStockDir := edFTPStockDir.Text;
        FTPTransactionDir := edFTPTXDir.Text;
      end;{with}

      if bUpdate then UpdateRecord
      else AddRecord;

      CloseFile;
    finally
      free;
    end;{try}
  end;{with}
end;

procedure TfrmSystemSetup.DeleteSettings(BtrieveType : TEBusBtrieveCompCode);
begin
  if tvOptions.Selected.Parent.Text <> 'Global' then begin
    with BtrieveType do begin
      Openfile;
      CompanyCode := TCompanyInfo(tvOptions.Selected.Parent.Data).CompanyRec.CompCode;
      if FindRecord = 0 then DeleteRecord;
      CloseFile;
      Free;
    end;{with}
  end;{if}
end;

procedure TfrmSystemSetup.nbSettingsPageChanged(Sender: TObject);
begin
{}
end;

procedure TfrmSystemSetup.btnEditClick(Sender: TObject);
begin
  GreyInOut;
  case nbSettings.PageIndex of
    0 : panGlobal.Enabled := TRUE;

    1 : nbEnableDisable(TRUE);

    2 : begin
      panDirInherit.Enabled := TRUE;
      cbInheritedClick(cbDirInherited);
      bPrevInherited := cbDirInherited.Checked;
    end;

    3 : begin
      panEmailInherit.Enabled := TRUE;
      cbInheritedClick(cbEmailInherited);
      bPrevInherited := cbEmailInherited.Checked;
    end;

    4 : begin
      panFTPInherit.Enabled := TRUE;
      cbInheritedClick(cbFTPInherited);
      bPrevInherited := cbFTPInherited.Checked;
    end;

  end;{case}
end;

procedure TfrmSystemSetup.nbEnableDisable(bEnable : boolean);
var
  iCont2, iCont : integer;
  Page, Item : TWinControl;
begin
  For iCont := 0 to nbSettings.controlcount - 1 do begin
    Page := TWinControl(nbSettings.Controls[iCont]);
    For iCont2 := 0 to Page.ControlCount - 1 do begin
      Item := TWinControl(Page.Controls[iCont2]);
      if Item.Tag = nbSettings.PageIndex then EnableControl(Item, bEnable);
    end;{for}
  end;{for}
end;{procedure}

procedure TfrmSystemSetup.EnableControl(Item : TWinControl; bEnable : boolean);
begin
  if (Item is TButton) or (Item is TCheckBox) or (Item is TRadioButton) or (Item is TDateTimePicker)
  or (Item is TPanel) then Item.Enabled := bEnable
  else begin
    if Item is Text8pt then Text8pt(Item).ReadOnly := not bEnable
    else begin
      if (Item is TPageControl) then
        begin
          if (TPageControl(Item).Name = 'pcEmail') and bEnable
          then EnablePageControl(TPageControl(Item), cbEmailAvail.Checked and btnOK.Enabled)
          else EnablePageControl(TPageControl(Item), bEnable);
        end
      else begin
        if (Item is Tedit) then
          begin
            if (TEdit(Item).Name = 'edServerName') and bEnable then EmailTypeClick(nil)
            else Item.Enabled := bEnable
          end
        else begin

        end;{if}
      end;
    end;{if}
  end;{if}
end;

procedure TfrmSystemSetup.EnablePageControl(PageControl : TPageControl; bEnable : boolean);
var
  Page : TTabSheet;
  iCont, iCont2 : integer;
begin
  For iCont := 0 to PageControl.controlcount - 1 do begin
    Page := TTabSheet(PageControl.Controls[iCont]);
    For iCont2 := 0 to Page.ControlCount - 1 do TWinControl(Page.Controls[iCont2]).Enabled := bEnable;
  end;{for}
end;

procedure TfrmSystemSetup.btnCancelClick(Sender: TObject);
begin
  GreyInOut;
  nbEnableDisable(FALSE);
  case nbSettings.PageIndex of
    0 : FillGlobalSettings;

    1 : FillCompanySettings;

    2 : begin
      cbDirInherited.Checked := bPrevInherited;
      FillFileSettings;
      panDirInherit.Enabled := FALSE;
    end;

    3 : begin
      cbEmailInherited.Checked := bPrevInherited;
      FillEmailSettings;
      panEmailInherit.Enabled := FALSE;
    end;

    4 : begin
      cbFTPInherited.Checked := bPrevInherited;
      FillFTPSettings;
      panFTPInherit.Enabled := FALSE;
    end;
  end;{case}
end;

procedure TfrmSystemSetup.GreyInOut;
begin
  btnOK.Enabled := not btnOK.Enabled;
  btnCancel.Enabled := not btnCancel.Enabled;
  btnEdit.Enabled := not btnEdit.Enabled;
  btnAddCo.Enabled := not btnAddCo.Enabled;
  panOptions.Enabled := not panOptions.Enabled;
end;

procedure TfrmSystemSetup.btnOKClick(Sender: TObject);
var
  bOK : boolean;
begin
  bOK := TRUE;
  case nbSettings.PageIndex of
    0 : SaveGlobalSettings;

    1 : bOK := SaveCompanySettings;

    2 : begin
      if cbDirInherited.Checked then DeleteSettings(TEBusBtrieveFile.Create(TRUE))
      else bOK := SaveFileSettings;
      panDirInherit.Enabled := not bOK;
    end;

    3: begin
      if cbEmailInherited.Checked then DeleteSettings(TEBusBtrieveEmail.Create(TRUE))
      else SaveEmailSettings;
      panEmailInherit.Enabled := not bOK;
    end;

    4: begin
      if cbFTPInherited.Checked then DeleteSettings(TEBusBtrieveFTP.Create(TRUE))
      else SaveFTPSettings;
      panFTPInherit.Enabled := not bOK;
    end;
  end;{case}

  if bOK then begin
    GreyInOut;
    nbEnableDisable(FALSE);
  end;{if}
end;

procedure TfrmSystemSetup.btnAddCoClick(Sender: TObject);
var
  frmAddCompany : TfrmAddCompany;
  iStatus, iPos : integer;
begin
  frmAddCompany := TfrmAddCompany.Create(self);
  try
    if frmAddCompany.Showmodal = mrOK then begin
      with TEbusBtrieveCompany.Create(TRUE) do begin
        try
          openfile;
          blankrecord;
          CompanyCode := frmAddCompany.sNewCompanyCode;

          {try and work out the transaction line types}
          SetToolkitPath(GetCompanyDirFromCode(Trim(CompanyCode)));
          iStatus := Ex_InitDLL;
          if iStatus <> 0 then ShowMessage('Ex_InitDLL Error : ' + IntToStr(iStatus))
          else begin
            FillTxLineTypes;
            with CompanySettings do begin
              for iPos := 0 to 3 do begin
                if Pos('FREIGHT',UpperCase(cmbFreightTX.Items[iPos])) <> 0
                then CompFreightLine := iPos + 1;
                if Pos('DISCOUNT',UpperCase(cmbDiscountTX.Items[iPos])) <> 0
                then CompDiscount := iPos + 1;
                if Pos('MATERIALS',UpperCase(cmbMiscTX.Items[iPos])) <> 0
                then CompMiscLine := iPos + 1;
              end;{for}
            end;{with}
            Ex_CloseData;
          end;{if}

          with CompanySettings do begin
            CompCustLockExt := 'LCK';
            CompStockLockExt := 'LCK';
            CompStockGrpLockExt := 'LCK';
            CompTransLockExt := 'LCK';
          end;{with}

          AddRecord;
          CloseFile;
        finally
          free;
        end;{try}
      end;{with}
      FillTreeView;
    end;{if}
  finally
    frmAddCompany.Release;
  end;{try}
end;

procedure TfrmSystemSetup.FillTreeView;
var
  slCompanyList : TStringList;
  ChildNode, RootNode : TTreeNode;
  iResult, iPos : integer;
  CompanyInfo : TCompanyInfo;
  SysECommsRec : TSysECommsRec;
begin
  tvOptions.Items.Clear;
  slCompanyList := TStringList.Create;
  FillCompanyList(slCompanyList, fmActive);


  RootNode := tvOptions.Items.Add(nil, 'Global');

  {Directory Defaults}
  ChildNode := tvOptions.Items.AddChild(RootNode, 'Directory Defaults');
  ChildNode.ImageIndex := 3;
  ChildNode.SelectedIndex := 3;
  with TEBusBtrieveFile.Create(TRUE) do begin
    try
      Openfile;
      CompanyCode := '';
      if FindRecord <> 0 then begin
        {Add the global record}
        BlankRecord;
        AddRecord;
      end;{if}
      CloseFile;
    finally
      free;
    end;{try}
  end;{with}


  {Email Settings}
  ChildNode := tvOptions.Items.AddChild(RootNode, 'Email Settings');
  ChildNode.ImageIndex := 3;
  ChildNode.SelectedIndex := 3;
  with TEBusBtrieveEmail.Create(TRUE) do begin
    try
      Openfile;
      CompanyCode := '';
      if FindRecord <> 0 then begin
        {Add the global record}
        BlankRecord;

        {Retrieve the Email Settings from Enterprise main company}
        SetToolkitPath(GetMultiCompDir);
        iResult := Ex_InitDLL;
        if iResult <> 0 then ShowMessage('Ex_InitDLL Error : ' + IntToStr(iResult))
        else begin
          iResult := EX_GETECOMMSDATA(@SysECommsRec, SizeOf(SysECommsRec));
          if iResult = 0 then
            begin
              EmailSettings.EmailType := (Ord(SysECommsRec.UseMAPI)  * -1) + 2;
              EmailSettings.EmailServerName := SysECommsRec.SMTPServerName;
            end
          else ShowMessage('EX_GETECOMMSDATA Error : ' + IntToStr(iResult));
          Ex_CloseData;
        end;{if}

        AddRecord;
      end;{if}
      CloseFile;
    finally
      free;
    end;{try}
  end;{with}

  {FTP Settings}
  ChildNode := tvOptions.Items.AddChild(RootNode, 'FTP Settings');
  ChildNode.ImageIndex := 3;
  ChildNode.SelectedIndex := 3;
  with TEBusBtrieveFTP.Create(TRUE) do begin
    try
      Openfile;
      CompanyCode := '';
      if FindRecord <> 0 then begin
        {Add the global record}
        BlankRecord;
        AddRecord;
      end;{if}
      CloseFile;
    finally
      free;
    end;{try}
  end;{with}

  for iPos := 0 to slCompanyList.Count - 1 do begin
    {add company}
    CompanyInfo := TCompanyInfo.Create;
    CompanyInfo.CompanyRec := TCompanyInfo(slCompanyList.Objects[iPos]).CompanyRec;
    RootNode := tvOptions.Items.AddObject(nil, slCompanyList[iPos], CompanyInfo);
    RootNode.ImageIndex := 1;
    RootNode.SelectedIndex := 1;

    {Company Settings}
    with TEbusBtrieveCompany.Create(TRUE) do begin
      try
        Openfile;
        CompanyCode := CompanyInfo.CompanyRec.CompCode;
        if FindRecord = 0 then begin
          ChildNode := tvOptions.Items.AddChild(RootNode, 'Company Settings');
          ChildNode.ImageIndex := 2;
          ChildNode.SelectedIndex := 2;
        end;{if}
        CloseFile;
      finally
        free;
      end;{try}
    end;{with}

    {Directory Defaults}
    with TEBusBtrieveFile.Create(TRUE) do begin
      try
        Openfile;
        CompanyCode := CompanyInfo.CompanyRec.CompCode;
        if FindRecord = 0 then
          begin
            ChildNode := tvOptions.Items.AddChild(RootNode, 'Directory Defaults');
            ChildNode.ImageIndex := 2;
            ChildNode.SelectedIndex := 2;
          end
        else begin
          CompanyCode := '';
          if FindRecord = 0 then begin
            ChildNode := tvOptions.Items.AddChild(RootNode, 'Directory Defaults');
            ChildNode.ImageIndex := 3;
            ChildNode.SelectedIndex := 3;
          end;{if}
        end;{if}
        CloseFile;
      finally
        free;
      end;{try}
    end;{with}

    {Email Settings}
    with TEBusBtrieveEmail.Create(TRUE) do begin
      try
        Openfile;
        CompanyCode := CompanyInfo.CompanyRec.CompCode;
        if FindRecord = 0 then
          begin
            ChildNode := tvOptions.Items.AddChild(RootNode, 'Email Settings');
            ChildNode.ImageIndex := 2;
            ChildNode.SelectedIndex := 2;
          end
        else begin
          CompanyCode := '';
          if FindRecord = 0 then begin
            ChildNode := tvOptions.Items.AddChild(RootNode, 'Email Settings');
            ChildNode.ImageIndex := 3;
            ChildNode.SelectedIndex := 3;
          end;{if}
        end;{if}
        CloseFile;
      finally
        free;
      end;{try}
    end;{with}

    {FTP Settings}
    with TEBusBtrieveFTP.Create(TRUE) do begin
      try
        Openfile;
        CompanyCode := CompanyInfo.CompanyRec.CompCode;
        if FindRecord = 0 then
          begin
            ChildNode := tvOptions.Items.AddChild(RootNode, 'FTP Settings');
            ChildNode.ImageIndex := 2;
            ChildNode.SelectedIndex := 2;
          end
        else begin
          CompanyCode := '';
          if FindRecord = 0 then begin
            ChildNode := tvOptions.Items.AddChild(RootNode, 'FTP Settings');
            ChildNode.ImageIndex := 3;
            ChildNode.SelectedIndex := 3;
          end;{if}
        end;{if}
        CloseFile;
      finally
        free;
      end;{try}
    end;{with}
  end;{for}

  ClearList(slCompanyList);
  slCompanyList.Free;
end;

procedure TfrmSystemSetup.btnRemoveCoClick(Sender: TObject);
var
  sDelCoCode : ShortString;
  iStatus : integer;
begin
  if MsgBox('Are you sure you want to delete this company and all its settings ?',mtConfirmation
  ,[mbYes, mbNo], mbNo, 'Delete Company') = mrYes then begin
    sDelCoCode := TCompanyInfo(tvOptions.Selected.Data).CompanyRec.CompCode;

    {Company Settings}
    with TEbusBtrieveCompany.Create(TRUE) do begin
      try
        Openfile;
        CompanyCode := sDelCoCode;
        if FindRecord = 0 then DeleteRecord;
        CloseFile;
      finally
        free;
      end;{try}
    end;{with}

    {Directory Defaults}
    with TEBusBtrieveFile.Create(TRUE) do begin
      try
        Openfile;
        CompanyCode := sDelCoCode;
        if FindRecord = 0 then DeleteRecord;
        CloseFile;
      finally
        free;
      end;{try}
    end;{with}

    {Email Settings}
    with TEBusBtrieveEmail.Create(TRUE) do begin
      try
        Openfile;
        CompanyCode := sDelCoCode;
        if FindRecord = 0 then DeleteRecord;
        CloseFile;
      finally
        free;
      end;{try}
    end;{with}

    {FTP Settings}
    with TEBusBtrieveFTP.Create(TRUE) do begin
      try
        Openfile;
        CompanyCode := sDelCoCode;
        if FindRecord = 0 then DeleteRecord;
        CloseFile;
      finally
        free;
      end;{try}
    end;{with}

    {Deactivate all exports associated with the deleted company}
    with TEBusBtrieveExport.Create(TRUE) do begin
      OpenFile;
      CompanyCode := sDelCoCode;
      iStatus := FindRecord(B_GetFirst);
      while (iStatus = 0) do begin
        ExportSettings.ExptActive := 0;
        UpdateRecord;
        iStatus := FindRecord(B_GetNext);
      end;{while}
      CloseFile;
    end;{with}

    FillTreeView;
  end;{if}
end;

procedure TfrmSystemSetup.EmailTypeClick(Sender: TObject);
begin
  lServerName.Enabled := rbSMTP.Checked;
  edServerName.Enabled := rbSMTP.Checked;
end;

procedure TfrmSystemSetup.cbEmailAvailClick(Sender: TObject);
begin
  EnableControl(pcEmail, cbEmailAvail.Checked and btnOK.Enabled);
end;

procedure TfrmSystemSetup.cbInheritedClick(Sender: TObject);
begin
  if tvOptions.Selected.Parent.Text <> 'Global' then begin
    tvOptions.Selected.ImageIndex := Ord(TCheckbox(Sender).Checked) + 2;
    tvOptions.Selected.SelectedIndex := Ord(TCheckbox(Sender).Checked) + 2;
    if TCheckbox(Sender).Checked then begin
      case TCheckbox(Sender).Tag of
        12 : FillFileSettings;
        13 : FillEmailSettings;
        14 : FillFTPSettings;
      end;{case}
    end;{if}
  end;{if}
  nbEnableDisable((not TCheckbox(Sender).Checked) and btnOK.Enabled);
end;

procedure TfrmSystemSetup.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if btnOK.Enabled then begin
    {edit mode}
    if (MsgBox('You are currently editing the system settings.' + #13 + #13 +
    'Do you want to save the changes that you have made ?',mtConfirmation
    ,[mbYes, mbNo], mbYes, 'Save Changes')) = mrYes then btnOKClick(nil);
  end;{if}

  if bImportWarn then MsgBox('Please note that any changes made to the import module settings,'
  + #13 + 'will not take effect until the import module is restarted.',mtInformation,[mbOK],mbOK
  ,'Import Module Settings');
end;

procedure TfrmSystemSetup.cmbSetPeriodChange(Sender: TObject);
begin
  edPeriod.Enabled := cmbSetPeriod.ItemIndex = 2;
end;

procedure TfrmSystemSetup.FillVATCodes;
var
  i : byte;
  Status : integer;
begin
  SetToolkitPath(Trim(TCompanyInfo(tvOptions.Selected.Parent.Data).CompanyRec.CompPath));
  Status := Ex_InitDLL;
  if Status <> 0 then ShowMessage('Ex_InitDLL = ' + IntToStr(Status))
  else begin
    for i := Low(VAT_CODES) to High(VAT_CODES) do cmbVATCode.Items.Add(VAT_CODES[i] + ' - '
    + GetVATDescription(VAT_CODES[i]));
  end;{if}
end;

procedure TfrmSystemSetup.FillTxLineTypes;
var
  iPos, iResult : integer;
  BatchSysRec : TBatchSysRec;
begin
  ClearList(cmbFreightTX.Items);
  FillChar(BatchSysRec, SizeOf(BatchSysRec), 0);

  iResult := EX_GETSYSDATA(@BatchSysRec, SizeOf(BatchSysRec));
  if iResult = 0 then
    begin
      for iPos := 1 to 4 do cmbFreightTX.Items.Add(BatchSysRec.TransLineTypeLabel[iPos]);
      cmbMiscTX.Items.Assign(cmbFreightTX.Items);
      cmbDiscountTX.Items.Assign(cmbFreightTX.Items);
    end
  else ShowMessage('EX_GETSYSDATA Error : ' + IntToStr(iResult));
end;

procedure TfrmSystemSetup.edCostCentreExit(Sender: TObject);
var
  sCostCentre : string20;
begin
  if (ActiveControl <> btnCancel) and (ActiveControl <> nil) and (ActiveControl <> btnClose) then begin
    sCostCentre := edCostCentre.Text;
    if DoGetCCDep(Self, IncludeTrailingBackslash(Trim(TCompanyInfo(tvOptions.Selected.Parent.Data).CompanyRec.CompPath))
    , sCostCentre, sCostCentre, TRUE, vmShowList, TRUE) then edCostCentre.Text := sCostCentre
    else ActiveControl := TWinControl(Sender);
  end;{if}
end;

procedure TfrmSystemSetup.edDepartmentExit(Sender: TObject);
var
  sDept : string20;
begin
  if (ActiveControl <> btnCancel) and (ActiveControl <> nil) and (ActiveControl <> btnClose) then begin
    sDept := edDepartment.Text;
    if DoGetCCDep(Self, IncludeTrailingBackslash(Trim(TCompanyInfo(tvOptions.Selected.Parent.Data).CompanyRec.CompPath))
    , sDept, sDept, FALSE, vmShowList, TRUE) then edDepartment.Text := sDept
    else ActiveControl := TWinControl(Sender);
  end;{if}
end;

procedure TfrmSystemSetup.edLocationExit(Sender: TObject);
var
  sLocation : string10;
begin
  if (ActiveControl <> btnCancel) and (ActiveControl <> nil) and (ActiveControl <> btnClose) then begin
    sLocation := edLocation.Text;
    if DoGetMLoc(Self, IncludeTrailingBackslash(Trim(TCompanyInfo(tvOptions.Selected.Parent.Data).CompanyRec.CompPath))
    , sLocation, sLocation, vmShowList, TRUE) then edLocation.Text := sLocation
    else ActiveControl := TWinControl(Sender);
  end;{if}
end;

procedure TfrmSystemSetup.edCustomerExit(Sender: TObject);
var
  sCustomer : string20;
begin
  if (ActiveControl <> btnCancel) and (ActiveControl <> nil) and (ActiveControl <> btnClose) then begin
    sCustomer := edCustomer.Text;
    if DoGetCust(Self, IncludeTrailingBackslash(Trim(TCompanyInfo(tvOptions.Selected.Parent.Data).CompanyRec.CompPath))
    , sCustomer, sCustomer, trdCustomer, vmShowList, TRUE) then edCustomer.Text := sCustomer
    else ActiveControl := TWinControl(Sender);
  end;{if}
end;

procedure TfrmSystemSetup.edSupplierExit(Sender: TObject);
var
  sSupplier : string20;
begin
  if (ActiveControl <> btnCancel) and (ActiveControl <> nil) and (ActiveControl <> btnClose) then begin
    sSupplier := edSupplier.Text;
    if DoGetCust(Self, IncludeTrailingBackslash(Trim(TCompanyInfo(tvOptions.Selected.Parent.Data).CompanyRec.CompPath))
    , sSupplier, sSupplier, trdSupplier, vmShowList, TRUE) then edSupplier.Text := sSupplier
    else ActiveControl := TWinControl(Sender);
  end;{if}
end;

procedure TfrmSystemSetup.edPurchNomExit(Sender: TObject);
var
  sNom : string20;
  iCode, iNom : integer;
begin
  if (ActiveControl <> btnCancel) and (ActiveControl <> nil) and (ActiveControl <> btnClose) then begin
    sNom := TEdit(Sender).Text;
{    if Trim(edPurchNom.Text) = '' then iNom := 0
    else }Val(TEdit(Sender).Text, iNom, iCode);
    if DoGetNom(Self, IncludeTrailingBackslash(Trim(TCompanyInfo(tvOptions.Selected.Parent.Data).CompanyRec.CompPath))
    , sNom, iNom, [nomProfitAndLoss, nomBalanceSheet], vmShowList, TRUE) then TEdit(Sender).Text := IntToStr(iNom)
    else ActiveControl := TWinControl(Sender);
  end;{if}
end;

procedure TfrmSystemSetup.FileBrowse(Sender: TObject);
var
  FrmSelectFile : TFrmSelectFile;
begin
  FrmSelectFile := TFrmSelectFile.Create(Self);
  try
    with FrmSelectFile do begin
      sDirectory := sTextFileDir;
      sExtension := 'TXT';
      if ShowModal = mrOK then begin
        if TButton(Sender).Name = 'btnOrderOKTextBrowse' then edOrderOKText.Text := lbFiles.Items[lbFiles.ItemIndex]
        else begin
          if TButton(Sender).Name = 'btnOrderFailTextBrowse' then edOrderFailText.Text := lbFiles.Items[lbFiles.ItemIndex]
          else begin
            if TButton(Sender).Name = 'btnInvoiceOKTextBrowse' then edInvoiceOKText.Text := lbFiles.Items[lbFiles.ItemIndex]
            else begin
              if TButton(Sender).Name = 'btnInvoiceFailTextBrowse' then edInvoiceFailText.Text := lbFiles.Items[lbFiles.ItemIndex];
            end;{if}
          end;{if}
        end;{if}
      end;{if}
    end;{with}
  finally
    FrmSelectFile.Release;
  end;{try}
end;

procedure TfrmSystemSetup.Button5Click(Sender: TObject);
begin
 with TEbusBtrieveCompany.Create(TRUE) do begin
   try
     openfile;
     CompanyCode := 'INTE01';
     if FindRecord = 0 then begin
       CompanySettings.CompTransTextDir := 'x:\ebus2\export\text\';
       updaterecord;
     end;{if}
     CloseFile;
   finally
     free;
   end;{try}
 end;{with}
end;

procedure TfrmSystemSetup.btnCustDirBrowseClick(Sender: TObject);
var
  FrmDirBrowse : TFrmDirBrowse;
begin
  FrmDirBrowse := TFrmDirBrowse.Create(self);
  try
    if FrmDirBrowse.ShowModal = mrOK then begin
      if Sender = btnCustDirBrowse then edCustExportDir.Text := IncludeTrailingBackslash(FrmDirBrowse.lbDirectory.Directory)
      else begin
        if Sender = btnStockDirBrowse then edStockExportDir.Text := IncludeTrailingBackslash(FrmDirBrowse.lbDirectory.Directory)
        else begin
          if Sender = btnSGDirBrowse then edStockGrpExportDir.Text := IncludeTrailingBackslash(FrmDirBrowse.lbDirectory.Directory)
          else begin
            if Sender = btnTXDirBrowse then edTXExportDir.Text := IncludeTrailingBackslash(FrmDirBrowse.lbDirectory.Directory)
            else begin
              if Sender = btnCOMPriceDirBrowse then edCOMPricingDir.Text := IncludeTrailingBackslash(FrmDirBrowse.lbDirectory.Directory);
            end;{if}
          end;{if}
        end;{if}
      end;{if}
    end;{if}
  finally
    FrmDirBrowse.Release;
  end;{try}
end;

procedure TfrmSystemSetup.edCustExportDirExit(Sender: TObject);
begin
  if Trim(Text8pt(Sender).Text) <> '' then Text8pt(Sender).Text
  := IncludeTrailingBackslash(Text8pt(Sender).Text);
end;

procedure TfrmSystemSetup.EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
{  GlobFormKeyDown(Sender,Key,Shift,Sender as TWinControl,Self.Handle);}
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TfrmSystemSetup.EditKeyPress(Sender: TObject; var Key: Char);
begin
{  GlobFormKeyPress(Sender,Key,Sender as TWinControl, Self.Handle);}
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TfrmSystemSetup.btnEditTextClick(Sender: TObject);
begin
  with TfrmEditTextFiles.Create(self) do begin
    try
      aFilenames[tfOrderOK] := edOrderOKText.Text;
      aFilenames[tfOrderFail] := edOrderFailText.Text;
      aFilenames[tfInvoiceOK] := edInvoiceOKText.Text;
      aFilenames[tfInvoiceFail] := edInvoiceFailText.Text;
      ShowModal;
    finally
      free;
    end;{try}
  end;{with}
end;

procedure TfrmSystemSetup.rbCustLockFileClick(Sender: TObject);
begin
  edCustLockFile.Enabled := rbCustLockFile.Checked;
  edCustLockExt.Enabled := rbCustLockExt.Checked;
  edStockLockFile.Enabled :=  rbStockLockFile.Checked;
  edStockLockExt.Enabled :=  rbStockLockExt.Checked;
  edSGroupLockFile.Enabled := rbSGroupLockFile.Checked;
  edSGroupLockExt.Enabled := rbSGroupLockExt.Checked;
  edTXLockFile.Enabled := rbTXLockFile.Checked;
  edTXLockExt.Enabled := rbTXLockExt.Checked;
end;

procedure TfrmSystemSetup.edEmailFreqExit(Sender: TObject);
var
  bError : boolean;
  iSecs, iMins : integer;
begin
  bError := false;
  try
    iMins := StrToInt(copy(edEmailFreq.Text,1,2));
    iSecs := StrToInt(copy(edEmailFreq.Text,3,2));
  except
    on EConvertError do bError := true;
  end;

  // Check general range
  bError := bError or (iMins < 0) or (iMins > 99) or (iSecs < 0) or (iSecs > 59);
  // Minimum of 5 secs
  bError := bError or ((iMins = 0) and (iSecs < 5));

  if bError then begin
    MessageDlg('Invalid time input.' + #13 + #13 + 'The valid time range is from 00:05 to 99:59 (mins:secs)', mtWarning, [mbOK], 0);
    SetFocus;
  end;{if}
end;

procedure TfrmSystemSetup.pcCompanyChange(Sender: TObject);
begin
  with pcCompany do
    case ActivePageIndex of
      0: HelpContext := 32;  // Import Defaults
      1: HelpContext := 30;  // Text files
      2: HelpContext := 29;  // File Locking
      3: HelpContext := 23;  // Other
    end;
end;

procedure TfrmSystemSetup.pcFTPChange(Sender: TObject);
begin
  with pcFTP do
    case ActivePageIndex of
      0: HelpContext := 21;  // Site settings
      1: HelpContext := 28;  // Proxy settings
      2: HelpContext := 27;  // Upload directories
    end;
end;

procedure TfrmSystemSetup.pcEmailChange(Sender: TObject);
begin
  with pcEmail do
    case ActivePageIndex of
      0: HelpContext := 7;  // Server
      1: HelpContext := 15; // Import
      2: HelpContext := 17; // Notfication
    end;
  //
end;

procedure TfrmSystemSetup.edFreightStkExit(Sender: TObject);
//Exit routine of all 3 stock code edits
var
  sStockCode : string20;
begin
  if (ActiveControl <> btnCancel) and (ActiveControl <> nil) and (ActiveControl <> btnClose)
     and (ActiveControl <> cbUseStockForCharges) then
  begin
    sStockCode := TEdit(Sender).Text;
    if DoGetStock(Self, IncludeTrailingBackslash(Trim(TCompanyInfo(tvOptions.Selected.Parent.Data).CompanyRec.CompPath))
    , sStockCode, sStockCode, [stkProduct, stkBOM], vmShowList, TRUE) then TEdit(Sender).Text := sStockCode
    else ActiveControl := TWinControl(Sender);
  end;{if}
end;

procedure TfrmSystemSetup.cbUseStockForChargesChange(Sender: TObject);
begin
  Case cbUseStockForCharges.ItemIndex of
    0   :   begin
              grpStk.Visible := False;
              grpDesc.Visible := True;
              grpLineTypes.Visible := True;
            end;
    1   :   begin
              grpStk.Visible := True;
              grpDesc.Visible := False;
              grpLineTypes.Visible := False;
            end;
    end; {case}
end;

function TfrmSystemSetup.DoPasswordCheck : Boolean;
var
  s : String;
  ebus : TEBusBtrieveParams;
begin
  Result := False;
  ebus := TEBusBtrieveParams.Create(TRUE);
  with ebus do begin
    try
      Openfile;
      if FindRecord = 0 then
      begin
        s := ParamsSettings.EntSetupPassword;
        Result := CheckPassword(s);
      end
      else
        raise Exception.Create('Unable to read security settings');
      CloseFile;
    finally
      free;
    end;{try}


  end;{with}
end;

constructor TfrmSystemSetup.CreateForCompSettingsOnly(AOwner: TComponent);
begin
  bCompSettingsOnly := True;
  Create(AOwner);
end;

end.
