unit SSetup;

{ nfrewer440 16:26 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , LicRec, EntLic, ComCtrls, StdCtrls, ExtCtrls, BTSupU1, TEditVal, TKUtil
  , CentData, LicUtil, MiscUtil;

{$I EXCHDLL.INC}

type
  TItemInfo = Class
    ID : Integer;
    constructor create(iNo : integer);
  end;{TItemInfo}

  TFrmSetup = class(TForm)
    pcSetup: TPageControl;
    tsGeneral: TTabSheet;
    btnClose: TButton;
    btnSave: TButton;
    lTillCurrency: TLabel;
    TabSheet2: TTabSheet;
    lStockLoc: TLabel;
    edStockLocation: TEdit;
    Label9: TLabel;
    Bevel1: TBevel;
    lDelTerms: TLabel;
    lMOT: TLabel;
    OpenDialog1: TOpenDialog;
    cmbCurrency: TComboBox;
    cmbDeliveryTerms: TComboBox;
    cmbModeOfTrans: TComboBox;
    tsCashDrawer: TTabSheet;
    cbOpenDrawerOnCash: TCheckBox;
    cbOpenDrawerOnCard: TCheckBox;
    cbOpenDrawerOnCheque: TCheckBox;
    cbOpenDrawerOnAccount: TCheckBox;
    tsNominals: TTabSheet;
    Label4: TLabel;
    edCashNom: TEdit;
    Label6: TLabel;
    edChequeNom: TEdit;
    Label12: TLabel;
    edWriteOffNom: TEdit;
    tsPrinting: TTabSheet;
    Bevel6: TBevel;
    Bevel7: TBevel;
    Bevel8: TBevel;
    edKickOutCodes: TEdit;
    Label18: TLabel;
    Label19: TLabel;
    cmbCashDrawerCOM: TComboBox;
    btnTestKick: TButton;
    tsCreditCards: TTabSheet;
    lvCards: TListView;
    btnEditCard: TButton;
    Label7: TLabel;
    edCashCustType: TEdit;
    lCashGLDesc: TLabel;
    lChequeGLDesc: TLabel;
    lWriteOffGLDesc: TLabel;
    Bevel11: TBevel;
    Bevel12: TBevel;
    Label21: TLabel;
    cmbCompany: TComboBox;
    pcPrinting: TPageControl;
    TabSheet6: TTabSheet;
    Bevel14: TBevel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    edReceiptForm: TEdit;
    btnBrowse1: TButton;
    cmbReceiptPrinter: TComboBox;
    cmbRecPrintPaper: TComboBox;
    cmbRecPrintBin: TComboBox;
    TabSheet5: TTabSheet;
    TabSheet7: TTabSheet;
    Label16: TLabel;
    Bevel5: TBevel;
    Label17: TLabel;
    edInvoiceForm: TEdit;
    Label23: TLabel;
    cmbInvPrintPaper: TComboBox;
    Label26: TLabel;
    cmbInvPrintBin: TComboBox;
    cmbInvoicePrinter: TComboBox;
    btnBrowse2: TButton;
    Label2: TLabel;
    Label5: TLabel;
    Bevel2: TBevel;
    Label8: TLabel;
    cmbOrderPrinter: TComboBox;
    btnBrowse3: TButton;
    edOrderForm: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    cmbOrderPaper: TComboBox;
    cmbOrderBin: TComboBox;
    Label28: TLabel;
    tsTransactions: TTabSheet;
    Panel1: TPanel;
    Label29: TLabel;
    Bevel3: TBevel;
    rbSINs: TRadioButton;
    rbPickedSORs: TRadioButton;
    rbUnpickedSORs: TRadioButton;
    Panel2: TPanel;
    Label30: TLabel;
    Bevel4: TBevel;
    rbNegSINs: TRadioButton;
    rbNegSRFs: TRadioButton;
    tsOperational: TTabSheet;
    cbAutoAddLine: TCheckBox;
    cbModifyVATRate: TCheckBox;
    Label1: TLabel;
    rbAFLogin: TRadioButton;
    rbAFNewTX: TRadioButton;
    Bevel15: TBevel;
    Bevel9: TBevel;
    cbRoundChange: TCheckBox;
    Label22: TLabel;
    edRoundto: TCurrencyEdit;
    Bevel10: TBevel;
    Bevel16: TBevel;
    Label31: TLabel;
    rbEntDiscounts: TRadioButton;
    rbTCMDiscounts: TRadioButton;
    Bevel17: TBevel;
    Bevel18: TBevel;
    Label32: TLabel;
    Label33: TLabel;
    cbUseDefaultAcc: TCheckBox;
    lAccCode: TLabel;
    edAccCode: TEdit;
    cbFilterSerialByLoc: TCheckBox;
    tsNonStock: TTabSheet;
    ldefGLCode: TLabel;
    edNonStockNom: TEdit;
    lNonStockGLDesc: TLabel;
    rbUseDefaults: TRadioButton;
    Bevel13: TBevel;
    rbDefaultFromStockItem: TRadioButton;
    lDefVATCode: TLabel;
    lStockItem: TLabel;
    edNonStockItem: TEdit;
    Bevel19: TBevel;
    Bevel20: TBevel;
    cmbVATRate: TComboBox;
    Label20: TLabel;
    tsCCDept: TTabSheet;
    Label34: TLabel;
    Bevel21: TBevel;
    rbCCDefaults: TRadioButton;
    rbCCEnterprise: TRadioButton;
    Label35: TLabel;
    edCC: TEdit;
    Label36: TLabel;
    edDept: TEdit;
    rbCCCustomer: TRadioButton;
    Bevel22: TBevel;
    Label37: TLabel;
    cbDepositsOnCashCust: TCheckBox;
    cmbBaudRate: TComboBox;
    Label38: TLabel;
    Bevel23: TBevel;
    cbAllowWriteOffs4CashCust: TCheckBox;
    Bevel24: TBevel;
    cbKeepOrigLayawayDate: TCheckBox;
    Label39: TLabel;
    Panel3: TPanel;
    lSORTagNo: TLabel;
    edSORTagNo: TEdit;
    rbDefTag: TRadioButton;
    rbCustTag: TRadioButton;
    rbCustDefTag: TRadioButton;
    cbCashback: TCheckBox;
    cbDeliveryAddress: TCheckBox;
    Bevel25: TBevel;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure NominalExit(Sender: TObject);
    procedure btnBrowseForForm(Sender: TObject);
    procedure edStockLocationExit(Sender: TObject);
    procedure SetChanged(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnTestKickClick(Sender: TObject);
    procedure lvCardsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure btnEditCardClick(Sender: TObject);
    procedure cmbPrinterClick(Sender: TObject);
    procedure cmbCompanyChange(Sender: TObject);
    procedure edAccCodeExit(Sender: TObject);
    procedure cbUseDefaultAccClick(Sender: TObject);
    procedure rbUseDefaultsClick(Sender: TObject);
    procedure edNonStockItemExit(Sender: TObject);
    procedure edCCExit(Sender: TObject);
    procedure edDeptExit(Sender: TObject);
    procedure rbSINsClick(Sender: TObject);
    procedure pcSetupChange(Sender: TObject);
  private
    bStartup, bEntPro, bSPOPInstalled, bChanged : boolean;
    iLockPos : integer;
    iCurrency : integer;
    procedure FillFormFromSetupRec;
    procedure FillSetupRecFromForm;
    Function SaveSettings : boolean;
    Function ValidateRecord : boolean;
    Procedure WMCustGetRec(Var Message : TMessage); Message WM_CustGetRec;
    Procedure ChangePage(NewPage  :  Integer);
    procedure SetIndexByItem(cmbCombo : TComboBox; iIDToFind : Integer);
    function GetGLDesc(iNom : integer) : string;
    Procedure FillCurrencyCombo;
    procedure GetEntSystemSetup;
  public
    { Public declarations }
  end;

var
  FrmSetup: TFrmSetup;

implementation
uses
  StartUp, EPOSComn, GlobVar, EPOSCnst, BtrvU2, APIUtil, EntLkup, StrUtil, UseDLLU, ValCfg
  , EPOSKey, Printers, EPOSProc, EditCard, RPDevice, PSProc, TillName;

{$R *.DFM}

{TItemInfo}

constructor TItemInfo.create(iNo : integer);
begin
  inherited create;
  ID := iNo;
end;{create}


{TFrmSetup}

procedure TFrmSetup.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmSetup.FormCreate(Sender: TObject);
//var
//  iPos, iStatus : smallint;

  function IsSPOPInstalled : boolean;
  var
    LicenceInfo : EntLicenceRecType;
    LicencePath : shortstring;
  begin
    LicencePath := GetMultiCompDir + EntLicFName;
    if ReadEntLic(LicencePath, LicenceInfo) then Result := LicenceInfo.LicEntModVer = 2
    else Result := FALSE;
  end;{IsSPOPUInstalled}

var
  oCentTillInfo : TCentralTillInfo;
  
begin{FormCreate}

  bStartup := TRUE;

  Caption := 'Trade Counter System Setup';

  bEntPro := IsEnterprisePro;

  cmbReceiptPrinter.Items := Printer.Printers;
  cmbInvoicePrinter.Items := Printer.Printers;
  cmbOrderPrinter.Items := Printer.Printers;

  if cmbReceiptPrinter.Items.Count > 0 then
  begin
    cmbReceiptPrinter.ItemIndex := 0;
    cmbPrinterClick(cmbReceiptPrinter);
  end;

  if cmbInvoicePrinter.Items.Count > 0 then
  begin
    cmbInvoicePrinter.ItemIndex := 0;
    cmbPrinterClick(cmbInvoicePrinter);
  end;

  if cmbOrderPrinter.Items.Count > 0 then
  begin
    cmbOrderPrinter.ItemIndex := 0;
    cmbPrinterClick(cmbReceiptPrinter);
  end;{if}

  FillCompanyCombo(cmbCompany);
  cmbCompanyChange(cmbCompany);

  FillVatCombo(cmbVatRate);

  // NF: 27/04/2007 Removed as file is not SQL compatible
//  if OpenEPOSBtrv(EPOSSysF) then
//    begin
      {Get and lock record}
//      if GetEPOSRec(EPOSSysF, TRUE, iLockPos) = 0 then
//        begin

        oCentTillInfo := TCentralTillInfo.Load(iTillNo);

        if Assigned(oCentTillInfo) then
        begin

          SetupRecord := oCentTillInfo.SetupRec;
          oCentTillInfo.Unload;

          GetEntSystemSetup;

          FillFormFromSetupRec;

          cmbCurrency.Enabled := not bEntPro;
          lTillCurrency.Enabled := cmbCurrency.Enabled;
          if not bEntPro then FillCurrencyCombo;

          pcSetup.ActivePageIndex := 0;
          pcPrinting.ActivePageIndex := 0;

          bChanged := FALSE;
          btnSave.Enabled := FALSE;
          btnTestKick.Enabled := TRUE;

          bSPOPInstalled := IsSPOPInstalled;
          rbPickedSORs.Enabled := bSPOPInstalled;
          rbUnpickedSORs.Enabled := bSPOPInstalled;

          pcSetupChange(nil);

      end else
      begin
        PostMessage(Self.Handle,WM_Close,0,0);{on startup, close form on no setuprec}
      end;{if}

//    end
//  else begin
//    PostMessage(Self.Handle,WM_Close,0,0);{on startup, close form on cannot find btrieve file}
//  end;{if}

  bStartup := FALSE;
end;{FormCreate}

procedure TFrmSetup.FormDestroy(Sender: TObject);
begin
//  Close_File(F[EposSysF]); // NF: 27/04/2007 Removed as file is not SQL compatible
  Ex_CloseData;
end;

procedure TFrmSetup.btnSaveClick(Sender: TObject);
begin
  SaveSettings;
end;

procedure TFrmSetup.FillFormFromSetupRec;
var
  iPos : integer;

begin
  // NF: 27/04/2007 Removed as file is not SQL compatible
//  SetupRecord := EposSysRec.EposSetup;

  with SetupRecord do begin

    // General Tab

    if TillCompany = '' then
      begin
        // Select Main Company
        For iPos := 0 to cmbCompany.Items.Count - 1 do begin
          if Trim(UpperCase(TCompanyInfo(cmbCompany.Items.Objects[iPos]).CompanyRec.CompPath))
          = Trim(UpperCase(eBSetDrive))
          then begin
            cmbCompany.ItemIndex := iPos;
            cmbCompanyChange(cmbCompany);
          end;
        end;{for}
      end
    else begin
      // select company defined in system setup
      For iPos := 0 to cmbCompany.Items.Count - 1 do begin
        if (TCompanyInfo(cmbCompany.Items.Objects[iPos]).CompanyRec.CompCode = TillCompany) then
        begin
          cmbCompany.ItemIndex := iPos;
          cmbCompanyChange(cmbCompany);
        end;
      end;{for}
    end;{if}
    sCurrCompPath := Trim(TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).CompanyRec.CompPath);
    iCurrency := TillCurrency;
    edCashCustType.Text := UpperCase(CashCustType);
    case DiscountType of
      0 : rbTCMDiscounts.Checked := TRUE;
      1 : rbEntDiscounts.Checked := TRUE;
    end;{case}
    cbDepositsOnCashCust.Checked := not NoDepositsOnCashCust;
    cbAllowWriteOffs4CashCust.Checked := AllowWriteOffs4CashCustomers;

    // Operational tab
    Case AfterTender of
      atLogin : rbAFLogin.Checked := TRUE;
      atNewTx : rbAFNewTX.Checked := TRUE;
    end;{case}
    cbAutoAddLine.Checked := AutoAddLine;
    cbModifyVATRate.Checked := AllowModifyVATRate;
    cbKeepOrigLayawayDate.checked := KeepOriginalLayawayDate;
    cbCashback.checked := CashbackOnOtherMOPs;
    cbDeliveryAddress.checked := GetDelAddrFromCustAddr;

    cbRoundChange.Checked := RoundChange;
    edRoundto.Text := FormatFloat('#########0.00', RoundChangeTo);

    // Printing tab

    // Receipt printing
    cmbReceiptPrinter.ItemIndex := cmbReceiptPrinter.Items.IndexOf(ReceiptPrinter);
    if cmbReceiptPrinter.ItemIndex = -1 then cmbReceiptPrinter.ItemIndex := 0;
    cmbPrinterClick(cmbReceiptPrinter);
    edReceiptForm.Text := ReceiptFormName;
    SetIndexByItem(cmbRecPrintPaper, RecPrintPaper);
    SetIndexByItem(cmbRecPrintBin, RecPrintBin);

    // Invoice printing
    cmbInvoicePrinter.ItemIndex := cmbInvoicePrinter.Items.IndexOf(InvoicePrinter);
    if cmbInvoicePrinter.ItemIndex = -1 then cmbInvoicePrinter.ItemIndex := 0;
    cmbPrinterClick(cmbInvoicePrinter);
    edInvoiceForm.Text := InvoiceFormName;
    SetIndexByItem(cmbInvPrintPaper, InvPrintPaper);
    SetIndexByItem(cmbInvPrintBin, InvPrintBin);

    // Order printing
    cmbOrderPrinter.ItemIndex := cmbOrderPrinter.Items.IndexOf(OrderPrinter);
    if cmbOrderPrinter.ItemIndex = -1 then cmbOrderPrinter.ItemIndex := 0;
    cmbPrinterClick(cmbOrderPrinter);
    edOrderForm.Text := OrderFormName;
    SetIndexByItem(cmbOrderPaper, OrderPrintPaper);
    SetIndexByItem(cmbOrderBin, OrderPrintBin);

    // Transactions Tab
    Case TransactionType of
       0 : rbSINs.Checked := TRUE;
       1 : rbPickedSORs.Checked := TRUE;
       2 : rbUnpickedSORs.Checked := TRUE;
    end;{Case}
    Case NegativeTXType of
       0 : rbNegSINs.Checked := TRUE;
       1 : rbNegSRFs.Checked := TRUE;
    end;{Case}
    edSORTagNo.Text := IntToStr(TransactionTagNo);
    case TagNoFrom of
      0 : rbDefTag.checked := TRUE;
      1 : rbCustTag.checked := TRUE;
      2 : rbCustDefTag.checked := TRUE;
    end;{case}


    {G/L Codes Tab}
    edCashNom.Text := IntToStr(MOPNomCodes[pbCash]);
    edChequeNom.Text := IntToStr(MOPNomCodes[pbCheque]);
    edWriteOffNom.Text := IntToStr(WriteOffNomCode);
    lCashGLDesc.Caption := GetGLDesc(MOPNomCodes[pbCash]);
    lChequeGLDesc.Caption := GetGLDesc(MOPNomCodes[pbCheque]);
    lWriteOffGLDesc.Caption := GetGLDesc(WriteOffNomCode);

    {Defaults Tab}
    cbUseDefaultAcc.Checked := UseDefAccCode = 1;
    edAccCode.Text := DefaultAccountCode;
    For iPos := 0 to cmbDeliveryTerms.Items.Count - 1 do begin
      if (Copy(cmbDeliveryTerms.Items[iPos],1,3) = DefSSDDeliveryTerms) then cmbDeliveryTerms.ItemIndex := iPos;
    end;{for}
    cmbModeOfTrans.ItemIndex := DefSSDModeOfTrans - 1;
    edStockLocation.Text := DefStockLocation;
    if TKSysRec.MultiLocn > 0 then cbFilterSerialByLoc.Checked := FilterSerialBinByLocation = 1
    else cbFilterSerialByLoc.Checked := FALSE;

    {Cash Drawer Tab}
    edKickOutCodes.Text := CashDrawerKick;
    cmbCashDrawerCOM.ItemIndex := CashDrawerCOM - 1;
    cmbBaudRate.ItemIndex := CashDrawerBaudRate;
    cbOpenDrawerOnCash.Checked := CashDrawerOpenOn[pbCash];
    cbOpenDrawerOnCard.Checked := CashDrawerOpenOn[pbCard];
    cbOpenDrawerOnCheque.Checked := CashDrawerOpenOn[pbCheque];
    cbOpenDrawerOnAccount.Checked := CashDrawerOpenOn[pbAccount];

    {Credit Cards Tab}
    For iPos := 0 to 19 do begin
      With lvCards.Items.Add do begin
        Caption := IntToStr(iPos + 1);
        SubItems.Add(CreditCards[iPos].Desc);
        SubItems.Add(IntToStr(CreditCards[iPos].GLCode));
      end;{with}
    end;{for}
    lvCards.Selected := lvCards.Items.Item[0];

    // Non Stock Tab
    case TakeNonStockDefaultFrom of
      0 : rbUseDefaults.Checked := TRUE;
      1 : rbDefaultFromStockItem.Checked := TRUE;
    end;{case}
    edNonStockNom.Text := IntToStr(DefNonStockNomCode);
    lNonStockGLDesc.Caption := GetGLDesc(DefNonStockNomCode);
    edNonStockItem.Text := NonStockItemCode;
    HighlightVATRate(NonStockVATCode, cmbVATRate);

    // CC / Dept tab
    case CCDeptMode of
      0 : rbCCCustomer.Checked := TRUE;
      1 : rbCCEnterprise.Checked := TRUE;
      2 : rbCCDefaults.Checked := TRUE;
    end;{case}
    edCC.Text := DefCostCentre;
    edDept.Text := DefDepartment;

  end;{with}
end;

procedure TFrmSetup.FillSetupRecFromForm;
var
  iPos : integer;
begin
  with SetupRecord do begin

    // General tab
    TillCompany := TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).CompanyRec.CompCode;

    if bEntPro then TillCurrency := 0
    else TillCurrency := TItemInfo(cmbCurrency.Items.Objects[cmbCurrency.ItemIndex]).ID;

    CashCustType := UpperCase(edCashCustType.Text);
    DiscountType := Ord(rbEntDiscounts.Checked);
    NoDepositsOnCashCust := not cbDepositsOnCashCust.Checked;
    AllowWriteOffs4CashCustomers := cbAllowWriteOffs4CashCust.Checked;

    // Operational tab
    AutoAddLine := cbAutoAddLine.Checked;
    AllowModifyVATRate := cbModifyVATRate.Checked;
    AfterTender := Ord(rbAFLogin.Checked);
    RoundChange := cbRoundChange.Checked;
    RoundChangeTo := StrToFloatDef(edRoundto.Text, 0);
    KeepOriginalLayawayDate := cbKeepOrigLayawayDate.checked;
    CashbackOnOtherMOPs := cbCashback.checked;
    GetDelAddrFromCustAddr := cbDeliveryAddress.checked;

    // Printing tab
    // Receipt Printing
    if cmbReceiptPrinter.ItemIndex >= 0 then ReceiptPrinter := cmbReceiptPrinter.Items[cmbReceiptPrinter.ItemIndex];
    ReceiptFormName := edReceiptForm.Text;
    if cmbRecPrintPaper.ItemIndex >= 0 then RecPrintPaper := TItemInfo(cmbRecPrintPaper.Items.Objects[cmbRecPrintPaper.ItemIndex]).ID;
    if cmbRecPrintBin.ItemIndex >= 0 then RecPrintBin := TItemInfo(cmbRecPrintBin.Items.Objects[cmbRecPrintBin.ItemIndex]).ID
    else RecPrintBin := -1;
    // Invoice Printing
    if cmbInvoicePrinter.ItemIndex >= 0 then InvoicePrinter := cmbInvoicePrinter.Items[cmbInvoicePrinter.ItemIndex];
    InvoiceFormName := edInvoiceForm.Text;
    if cmbInvPrintPaper.ItemIndex >= 0 then InvPrintPaper := TItemInfo(cmbInvPrintPaper.Items.Objects[cmbInvPrintPaper.ItemIndex]).ID;
    if cmbInvPrintBin.ItemIndex >= 0 then InvPrintBin := TItemInfo(cmbInvPrintBin.Items.Objects[cmbInvPrintBin.ItemIndex]).ID
    else InvPrintBin := -1;
    // Order Printing
    if cmbOrderPrinter.ItemIndex >= 0 then OrderPrinter := cmbOrderPrinter.Items[cmbOrderPrinter.ItemIndex];
    OrderFormName := edOrderForm.Text;
    if cmbOrderPaper.ItemIndex >= 0 then OrderPrintPaper := TItemInfo(cmbOrderPaper.Items.Objects[cmbOrderPaper.ItemIndex]).ID;
    if cmbOrderBin.ItemIndex >= 0 then OrderPrintBin := TItemInfo(cmbOrderBin.Items.Objects[cmbOrderBin.ItemIndex]).ID
    else OrderPrintBin := -1;

    // Transactions Tab
    if rbSINs.Checked then TransactionType := 0;
    if rbPickedSORs.Checked then TransactionType := 1;
    if rbUnpickedSORs.Checked then TransactionType := 2;

    if StrToIntDef(edSORTagNo.Text,0) < 0 then TransactionTagNo := 0
    else TransactionTagNo := StrToIntDef(edSORTagNo.Text,0);
    if TransactionTagNo < 0 then TransactionTagNo := 0;
    edSORTagNo.Text := IntToStr(TransactionTagNo);

    if rbDefTag.checked then TagNoFrom := 0;
    if rbCustTag.checked then TagNoFrom := 1;
    if rbCustDefTag.checked then TagNoFrom := 2;

    if rbNegSINs.Checked then NegativeTXType := 0;
    if rbNegSRFs.Checked then NegativeTXType := 1;


    {G/L Codes tab}
    MOPNomCodes[pbCash] := StrToIntDef(edCashNom.Text, 0);
    MOPNomCodes[pbCheque] := StrToIntDef(edChequeNom.Text, 0);
    WriteOffNomCode := StrToIntDef(edWriteOffNom.Text, 0);

    {Defaults Tab}
    UseDefAccCode := Ord(cbUseDefaultAcc.Checked);
    DefaultAccountCode := edAccCode.Text;
    DefSSDDeliveryTerms := Copy(cmbDeliveryTerms.Items[cmbDeliveryTerms.ItemIndex],1,3);
    DefSSDModeOfTrans := cmbModeOfTrans.ItemIndex + 1;
    DefStockLocation := edStockLocation.Text;
    FilterSerialBinByLocation := Ord(cbFilterSerialByLoc.Checked);

    {Cash Drawer Tab}
    CashDrawerKick := edKickOutCodes.Text;
    CashDrawerCOM := cmbCashDrawerCOM.ItemIndex + 1;
    CashDrawerBaudRate := cmbBaudRate.ItemIndex;
    CashDrawerOpenOn[pbCash] := cbOpenDrawerOnCash.Checked;
    CashDrawerOpenOn[pbCard] := cbOpenDrawerOnCard.Checked;
    CashDrawerOpenOn[pbCheque] := cbOpenDrawerOnCheque.Checked;
    CashDrawerOpenOn[pbAccount] := cbOpenDrawerOnAccount.Checked;

    {Credit Cards Tab}
    For iPos := 0 to 19 do begin
      With lvCards.Items.Item[iPos] do begin
        CreditCards[iPos].Desc := SubItems[0];
        CreditCards[iPos].GLCode := StrToIntDef(SubItems[1], 0);
      end;{with}
    end;{for}

    // Non Stock Tab
    TakeNonStockDefaultFrom := Ord(rbDefaultFromStockItem.Checked);
    DefNonStockNomCode := StrToIntDef(edNonStockNom.Text, 0);
    NonStockItemCode := edNonStockItem.Text;
    NonStockVATCode := TVATInfo(cmbVATRate.Items.Objects[cmbVATRate.ItemIndex]).cCode;

    // CC / Dept tab
    if rbCCCustomer.Checked then CCDeptMode := 0
    else begin
      if rbCCEnterprise.Checked then CCDeptMode := 1
      else begin
        if rbCCDefaults.Checked then CCDeptMode := 2;
      end;{if}
    end;{if}

    DefCostCentre := edCC.Text;
    DefDepartment := edDept.Text;

  end;{with}
end;

procedure TFrmSetup.NominalExit(Sender: TObject);
var
  sNom : string;
  iCode, iNom : integer;
begin
  if (ActiveControl <> rbDefaultFromStockItem) then begin
    sNom := TEdit(Sender).Text;
    Val(TEdit(Sender).Text, iNom, iCode);
    if DoGetNom(Self, sCurrCompPath, sNom, iNom, [nomProfitAndLoss, nomBalanceSheet], vmShowList, TRUE)
    then TEdit(Sender).Text := IntToStr(iNom)
    else ActiveControl := TWinControl(Sender);

    case TWinControl(Sender).Tag of
      1 : lCashGLDesc.Caption := GetGLDesc(iNom);
      2 : lChequeGLDesc.Caption := GetGLDesc(iNom);
      3 : lWriteOffGLDesc.Caption := GetGLDesc(iNom);
      4 : lNonStockGLDesc.Caption := GetGLDesc(iNom);
    end;{case}
  end;{if}
end;

procedure TFrmSetup.btnBrowseForForm(Sender: TObject);
var
  sFormName : string12;
begin
  OpenDialog1.InitialDir := sCurrCompPath + 'FORMS\';
  OpenDialog1.Filter := 'Exchequer form files|*.EFX;*.DEF; ';
  if OpenDialog1.Execute then begin
    if UpperCase(ExtractShortPathName(ExtractFilePath(OpenDialog1.FileName))) = UpperCase(sCurrCompPath + 'FORMS\') then
      begin
        sFormName := ExtractFileName(ExtractShortPathName(OpenDialog1.FileName));
        if TButton(Sender).Name = 'btnBrowse1' then
          begin
            // Receipt
            edReceiptForm.Text := ChangeFileExt(sFormName,'')
          end
        else begin
          if TButton(Sender).Name = 'btnBrowse2' then
            begin
              // Invoice
              edInvoiceForm.Text := ChangeFileExt(sFormName,'');
            end
          else begin
            // Order
            edOrderForm.Text := ChangeFileExt(sFormName,'');
          end;{if}
        end;{if}
      end
    else begin
      MsgBox('You must select a form from the current company''s "FORMS" directory.',mtInformation,[mbOK],mbOK,'Invalid Form');
    end;{if}
  end;{if}
end;

procedure TFrmSetup.edStockLocationExit(Sender: TObject);
var
  sLocation : string10;
begin
  sLocation := TEdit(Sender).Text;
  if DoGetMLoc(Self, sCurrCompPath, sLocation, sLocation, vmShowList, TRUE)
  then TEdit(Sender).Text := sLocation
  else ActiveControl := TWinControl(Sender);
end;

procedure TFrmSetup.SetChanged(Sender: TObject);
begin
  bChanged := TRUE;
  btnSave.Enabled := TRUE;
  btnTestKick.Enabled := FALSE;
end;

procedure TFrmSetup.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if bChanged and (MsgBox('You have made changes to the system setup.' + #13 + #13
  + 'Do you wish to save these changes ?',mtWarning,[mbYes,mbNo],mbYes,'Save Changes') = mrYes)
  then CanClose := SaveSettings;
end;

Function TFrmSetup.SaveSettings : boolean;
var
  iStatus : smallint;
  oTillInfo : TTillInfo;
  oCentTillInfo : TCentralTillInfo;
begin
  Result := FALSE;

  FillSetupRecFromForm;

  iStatus := 0;
  if ValidateRecord then begin
    // NF: 27/04/2007 Removed as file is not SQL compatible
    (*
    {Perform a get direct using previously stored position}
    move(iLockPos,RecPtr[EposSysF]^,sizeof(iLockPos));
    iStatus := GetDirect(F[EposSysF], EposSysF, RecPtr[EposSysF]^,0, 0);
    if iStatus = 0 then begin
      EposSysRec.EposSetup := SetupRecord;
      {Save Record}
      iStatus := Put_Rec(F[EposSysF], EposSysF, RecPtr[EposSysF]^, 0);
      if iStatus = 0 then begin
        {Unlock Record}
        iStatus := UnLockMultiSing(F[EposSysF], EposSysF, iLockPos);
        if iStatus = 0 then begin*)
          Result := TRUE;
          btnSave.Enabled := FALSE;
          btnTestKick.Enabled := TRUE;
          bChanged := FALSE;

          // update global till list
          oTillInfo := TTillInfo.Load(TRUE);
          if oTillInfo.LastErrorNo = 0 then begin
{            if iTillNo > oTillInfo.Names.Count then
              begin
                // Till doesn't exist in the till list so add an entry
                oTillInfo.Companies.Add(TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).CompanyRec.CompCode);
                oTillInfo.Names.Add('Till #' + IntToStr(iTillNo));
              end
            else begin}
              // update till's details in the global till list
//              oTillInfo.Names[iTillNo - 1] := 'Till #' + IntToStr(iTillNo);
              TTillObject(oTillInfo.Names.Objects[iTillNo - 1]).CompanyCode
              := TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).CompanyRec.CompCode;

//              oTillInfo.Companies[iTillNo - 1] := TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).CompanyRec.CompCode;
//            end;{if}
            oTillInfo.SaveListEdits;
            oTillInfo.Unload;
          end;{if}

          // update central copy of all till setup info
          oCentTillInfo := TCentralTillInfo.Load(iTillNo);
          with oCentTillInfo do begin
            SetupRec := SetupRecord;
            SaveTillInfo;
            Unload;
          end;{with}
//        end;{if}
//      end;{if}
//    end;{if}
  end;{if}
//  Report_BError(EposSysF,iStatus); // NF: 27/04/2007 Removed as file is not SQL compatible
end;

Function TFrmSetup.ValidateRecord : boolean;
var
  sMessage : string;
  iNewSubPageIndex, iNewPageIndex : integer;
  NewActiveControl : TWinControl;
begin
  sMessage := '';

  ValidatePrinting(sMessage);
  if sMessage = '' then
    begin
      ValidateGLCodes(sMessage);
      if sMessage = '' then
        begin
          ValidateDefaults(sMessage);
          if sMessage = '' then
            begin
              ValidateCCDept(sMessage);
              if sMessage = '' then
                begin

                end
              else begin
                {Set active control for CC / Dept tab error}
                if sMessage = 'Default Cost Centre' then NewActiveControl := edCC
                else NewActiveControl := edDept;
                iNewPageIndex := 9;
              end;{if}
            end
          else begin
            {Set active control for defaults tab error}
            if sMessage = 'Stock Location' then NewActiveControl := edStockLocation;
            iNewPageIndex := 5;
          end;{if}
        end
      else begin
        {Set active control for GL Code Error}
        if sMessage = 'Cash Payment G/L Code' then NewActiveControl := edCashNom;
        if sMessage = 'Cheque Payment G/L Code' then NewActiveControl := edChequeNom;
        if sMessage = 'Write-Off G/L Code' then NewActiveControl := edWriteOffNom;
        iNewPageIndex := 4;
        if sMessage = 'Non-Stock Default G/L Code' then begin
          NewActiveControl := edNonStockNom;
          iNewPageIndex := 8;
        end;{if}

        if sMessage = 'Non-Stock Stock Code' then begin
          NewActiveControl := edNonStockItem;
          iNewPageIndex := 8;
        end;{if}

      end;{if}
    end
  else begin
    {Set Active Control for Printing tab error}
    if sMessage = 'Receipt Form Name' then begin
      NewActiveControl := edReceiptForm;
      iNewSubPageIndex := 0;
    end;{if}

    if sMessage = 'Invoice Form Name' then begin
      NewActiveControl := edInvoiceForm;
      iNewSubPageIndex := 1;
    end;

    if sMessage = 'Order Form Name' then begin
      NewActiveControl := edOrderForm;
      iNewSubPageIndex := 2;
    end;{if}

    iNewPageIndex := 2;
  end;{if}


  if sMessage <> '' then
    begin
      {Show Error}
      MsgBox('There has been an input error in the following field : ' + sMessage + #13 + #13
      + 'Please enter a valid value in this field.',mtError,[mbOK],mbOK,'Input Error');
      pcSetup.ActivePageIndex := iNewPageIndex;
      pcPrinting.ActivePageIndex := iNewSubPageIndex;

      ActiveControl := NewActiveControl;
      if NewActiveControl is TEdit then TEdit(NewActiveControl).SelectAll;
    end
  else begin
    {Check the currency of the GL Codes Input}
    if not CheckGLCurrency(sMessage) then begin
      iNewPageIndex := 4;
      if sMessage = 'Cash Payment G/L Code' then NewActiveControl := edCashNom;
      if sMessage = 'Cheque Payment G/L Code' then NewActiveControl := edChequeNom;
      if sMessage = 'Write-Off G/L Code' then NewActiveControl := edWriteOffNom;

      if sMessage = 'Non-Stock Default G/L Code' then begin
        NewActiveControl := edNonStockNom;
        iNewPageIndex := 8;
      end;{if}

      if Copy(sMessage,1,11) = 'Credit Card' then begin
        NewActiveControl := lvCards;
        iNewPageIndex := 7;
      end;{if}

      MsgBox('The currency of the following GL code does not match the Till Currency : ' + sMessage + #13 + #13
      + 'Please enter a GL Code of the correct currency in this field.',mtError,[mbOK],mbOK,'GL Currency Error');
      pcSetup.ActivePageIndex := iNewPageIndex;
      ActiveControl := NewActiveControl;
      if NewActiveControl is TEdit then TEdit(NewActiveControl).SelectAll;
    end;{if}
  end;{if}

  Result := sMessage = '';
end;

procedure TFrmSetup.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
{  If (Key = VK_F1) and (Not (ssAlt In Shift))
  then Application.HelpCommand(HELP_Finder,0);}
end;

procedure TFrmSetup.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

Procedure TFrmSetup.WMCustGetRec(Var Message  :  TMessage);
Begin
  With Message do begin
    Case WParam of
      175 : begin
        With pcSetup do begin
          ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);
        end;{with}
      end;
    end; {Case..}
  end;{with}

  Inherited;
end;

Procedure TFrmSetup.ChangePage(NewPage : Integer);
Begin
  If (pcSetup.ActivePageIndex <> NewPage) then begin
    With pcSetup do begin
      If (Pages[NewPage].TabVisible) then ActivePage := Pages[NewPage];
    end;{with}
  end;{if}
end; {Proc..}

procedure TFrmSetup.btnTestKickClick(Sender: TObject);
begin
  OpenCashDrawer(SetupRecord.CashDrawerCOM, SetupRecord.CashDrawerBaudRate, SetupRecord.CashDrawerKick);
end;

procedure TFrmSetup.lvCardsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  btnEditCard.Enabled := lvCards.Selected <> nil;
end;

procedure TFrmSetup.btnEditCardClick(Sender: TObject);
begin
  with TFrmCardDetails.Create(Self) do begin
    try
      edDescription.Text := lvCards.Selected.SubItems[0];
      edGLCode.Text := lvCards.Selected.SubItems[1];
      if ShowModal = mrOK then begin
        lvCards.Selected.SubItems[0] := edDescription.Text;
        lvCards.Selected.SubItems[1] := edGLCode.Text;
        SetChanged(nil);
      end;{if}
    finally
      Release;
    end;{try}
  end;{with}
end;

procedure TFrmSetup.SetIndexByItem(cmbCombo : TComboBox; iIDToFind : Integer);
var
  iPos : integer;
begin
  for iPos := 0 to cmbCombo.Items.Count - 1 do begin
    if TItemInfo(cmbCombo.Items.Objects[iPos]).ID = iIDToFind then cmbCombo.ItemIndex := iPos;
  end;{for}
  if (cmbCombo.ItemIndex = -1) and (cmbCombo.Items.Count > 0) then cmbCombo.ItemIndex := 0;
end;

procedure TFrmSetup.cmbPrinterClick(Sender: TObject);
var
  iPos : integer;
  PaperCombo, BinCombo : TComboBox;
begin
  if TWinControl(Sender).Name = 'cmbReceiptPrinter' then
    begin
      // Receipt Printer
      RpDev.SelectPrinter(cmbReceiptPrinter.Items[cmbReceiptPrinter.ItemIndex], FALSE);
      BinCombo := cmbRecPrintBin;
      PaperCombo := cmbRecPrintPaper;
    end
  else begin
    if TWinControl(Sender).Name = 'cmbInvoicePrinter' then
      begin
        // Invoice Printer
        RpDev.SelectPrinter(cmbInvoicePrinter.Items[cmbInvoicePrinter.ItemIndex], FALSE);
        BinCombo := cmbInvPrintBin;
        PaperCombo := cmbInvPrintPaper;
      end
    else begin
      // Order Printer
      RpDev.SelectPrinter(cmbOrderPrinter.Items[cmbOrderPrinter.ItemIndex], FALSE);
      BinCombo := cmbOrderBin;
      PaperCombo := cmbOrderPaper;
    end;{if}
  end;{if}

  { Load Bins }
  BinCombo.Clear;
  if (RpDev.Bins.Count > 0) then begin
    for iPos := 0 To Pred(RpDev.Bins.Count) do begin
      BinCombo.Items.AddObject(RpDev.Bins[iPos], TItemInfo.Create(LongInt(RpDev.Bins.Objects[iPos])));
    end; { If }
    BinCombo.ItemIndex := 0;
  end; { If }

  { Load Paper }
  PaperCombo.Clear;
  If (RpDev.Papers.Count > 0) Then Begin
    For iPos := 0 To Pred(RpDev.Papers.Count) Do Begin
      PaperCombo.Items.AddObject(RpDev.Papers[iPos], TItemInfo.Create(LongInt(RpDev.Papers.Objects[iPos])));
    End; { For }
    PaperCombo.ItemIndex := 0;
  End; { If }
end;

function TFrmSetup.GetGLDesc(iNom : integer) : string;
var
  GLCodeRec : TBatchNomRec;
  pKey : PChar;
  iStatus : SmallInt;
begin
  pKey := StrAlloc(255);
  StrPCopy(pKey, IntToStr(iNom));
  iStatus := EX_GETGLACCOUNT(@GLCodeRec, SizeOf(GLCodeRec),pKey,0,B_GetEq,FALSE);
  if iStatus = 0 then Result := GLCodeRec.Desc
  else begin
    if (iStatus <> 4) then ShowTKError('EX_GETGLACCOUNT', 44, iStatus);
  end;{if}
  StrDispose(pKey);
end;{GetGLDesc}


Procedure TFrmSetup.FillCurrencyCombo;
var
  CurrRec : ^TBatchCurrRec;
  iCurrIndex, CurrNum : smallint;
begin

  ClearList(cmbCurrency.Items);

  new(CurrRec);
  for CurrNum := 1 to 90 do begin
    status := EX_GETCURRENCY(CurrRec, SizeOf(CurrRec^), CurrNum);
    if (status = 0) and (CurrRec.Name <> '') then begin
      cmbCurrency.Items.AddObject(IntToStr(CurrNum) + ' : ' + CurrRec.Name, TItemInfo.Create(CurrNum));
      if iCurrency = CurrNum then iCurrIndex := cmbCurrency.Items.Count - 1;
    end;{if}
  end;{for}
  dispose(CurrRec);
  cmbCurrency.ItemIndex := iCurrIndex;
end;

procedure TFrmSetup.cmbCompanyChange(Sender: TObject);
begin
  if bStartup then bStartup := FALSE
  else Ex_CloseData;

  sCurrCompPath := Trim(TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).CompanyRec.CompPath);
  OpenDLL(sCurrCompPath);

//  GetEntSystemSetup;

  SetChanged(cmbCompany);

  GetEntSystemSetup;

  if cmbCurrency.ItemIndex > -1 then iCurrency := TItemInfo(cmbCurrency.Items.Objects[cmbCurrency.ItemIndex]).ID;

  if not bEntPro then FillCurrencyCombo;

  if edCashNom.Text <> '' then lCashGLDesc.Caption := GetGLDesc(StrToIntDef(edCashNom.Text, 0));
  if edChequeNom.Text <> '' then lChequeGLDesc.Caption := GetGLDesc(StrToIntDef(edChequeNom.Text, 0));
  if edWriteOffNom.Text <> '' then lWriteOffGLDesc.Caption := GetGLDesc(StrToIntDef(edWriteOffNom.Text, 0));
  if edNonStockNom.Text <> '' then lNonStockGLDesc.Caption := GetGLDesc(StrToIntDef(edNonStockNom.Text, 0));
end;

procedure TFrmSetup.GetEntSystemSetup;
var
  iStatus : smallint;
begin
  iStatus := Ex_GetSysData(@TKSysRec, SizeOf(TKSysRec));
  ShowTKError('Ex_GetSysData', 91, iStatus);

  {enable disable fields dependant on Enterprise's system setup}
  lStockLoc.Enabled := TKSysRec.MultiLocn > 0;
  edStockLocation.Enabled := TKSysRec.MultiLocn > 0;
  cbFilterSerialByLoc.Enabled := TKSysRec.MultiLocn > 0;
  lDelTerms.Enabled := TKSysRec.IntraStat;
  cmbDeliveryTerms.Enabled := TKSysRec.IntraStat;
  lMOT.Enabled := TKSysRec.IntraStat;
  cmbModeOfTrans.Enabled := TKSysRec.IntraStat;
  tsCCDept.TabVisible := TKSysRec.CCDepts;
end;


procedure TFrmSetup.edAccCodeExit(Sender: TObject);
var
  sAccountCode : string20;
begin
  sAccountCode := edAccCode.Text;
  if DoGetCust(Self, sCurrCompPath, sAccountCode, sAccountCode, trdCustomer
  , vmShowList, TRUE, ciAccountCode)
  then TEdit(Sender).Text := sAccountCode
  else ActiveControl := TWinControl(Sender);
end;

procedure TFrmSetup.cbUseDefaultAccClick(Sender: TObject);
begin
  edAccCode.Enabled := cbUseDefaultAcc.Checked;
  lAccCode.Enabled := cbUseDefaultAcc.Checked;
  SetChanged(Sender);
end;

procedure TFrmSetup.rbUseDefaultsClick(Sender: TObject);
begin
  edNonStockNom.Enabled := rbUseDefaults.Checked;
  ldefGLCode.Enabled := rbUseDefaults.Checked;
  lNonStockGLDesc.Enabled := rbUseDefaults.Checked;
  cmbVATRate.Enabled := rbUseDefaults.Checked;
  lDefVATCode.Enabled := rbUseDefaults.Checked;

  lStockItem.Enabled := rbDefaultFromStockItem.Checked;
  edNonStockItem.Enabled := rbDefaultFromStockItem.Checked;

  SetChanged(Sender);
end;

procedure TFrmSetup.edNonStockItemExit(Sender: TObject);
var
  sStockCode : String20;
begin
  if (ActiveControl <> rbUseDefaults) then begin
    if DoGetStock(self, sCurrCompPath, edNonStockItem.Text, sStockCode, [stkProduct, stkBOM]
    , vmShowList, TRUE) then
      begin
        edNonStockItem.Text := sStockCode;
      end
    else ActiveControl := TWinControl(Sender);
  end;{if}
end;

procedure TFrmSetup.edCCExit(Sender: TObject);
var
  sCostCentre : String20;
begin
  if (ActiveControl <> btnClose) then begin
    if DoGetCCDep(Self, sCurrCompPath, edCC.Text, sCostCentre, TRUE, vmShowList, TRUE)
    then edCC.Text := sCostCentre
    else ActiveControl := TWinControl(Sender);
  end;{if}
end;

procedure TFrmSetup.edDeptExit(Sender: TObject);
var
  sDepartment : string20;
begin
  if (ActiveControl <> btnClose) then begin
    if DoGetCCDep(Self, sCurrCompPath, edDept.Text, sDepartment, FALSE, vmShowList, TRUE)
    then edDept.Text := sDepartment
    else ActiveControl := TWinControl(Sender);
  end;{if}
end;

procedure TFrmSetup.rbSINsClick(Sender: TObject);
begin
  edSORTagNo.Enabled := rbPickedSORs.Checked or rbUnPickedSORs.Checked;
  lSORTagNo.Enabled := edSORTagNo.Enabled;
  rbDefTag.Enabled := edSORTagNo.Enabled;
  rbCustTag.Enabled := edSORTagNo.Enabled;
  rbCustDefTag.Enabled := edSORTagNo.Enabled;
  SetChanged(nil);
end;

procedure TFrmSetup.pcSetupChange(Sender: TObject);
begin
  case pcSetup.ActivePage.PageIndex of
     0 : HelpContext := 18; // General
     1 : HelpContext := 21; // Operational
     2 : HelpContext := 22; // Printing
     3 : HelpContext := 23; // Transactions
     4 : HelpContext := 19; // GL Codes
     5 : HelpContext := 17; // Defaults
     6 : HelpContext := 14; // Cash Drawer
     7 : HelpContext := 16; // Credit Cards
     8 : HelpContext := 20; // Non Stock
     9 : HelpContext := 15; // CC / Dept
  end;{case}
end;

end.
