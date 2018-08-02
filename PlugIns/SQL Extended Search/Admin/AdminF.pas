unit AdminF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EnterToTab, StdCtrls, bkgroup, oSettings, CheckLst, ComCtrls, Math,
  Menus;

type
  TfrmAdmin = class(TForm)
    EnterToTab1: TEnterToTab;
    btnOK: TButton;
    btnCancel: TButton;
    PageControl1: TPageControl;
    tabshCustomers: TTabSheet;
    chkCUCode: TCheckBox;
    chkCUAddress1: TCheckBox;
    chkCUDelAddress1: TCheckBox;
    chkCUPhone2: TCheckBox;
    chkCUAccType: TCheckBox;
    chkCUVATNo: TCheckBox;
    chkCUArea: TCheckBox;
    chkCUUser1: TCheckBox;
    chkCUPhone3: TCheckBox;
    chkCUDelAddress2: TCheckBox;
    chkCUAddress2: TCheckBox;
    chkCUCompany: TCheckBox;
    chkCUContact: TCheckBox;
    chkCUAddress3: TCheckBox;
    chkCUDelAddress3: TCheckBox;
    chkCUEMailID: TCheckBox;
    chkCUUser2: TCheckBox;
    chkCUUser3: TCheckBox;
    chkCUTheirAccount: TCheckBox;
    chkCUDelAddress4: TCheckBox;
    chkCUAddress4: TCheckBox;
    chkCUPhone1: TCheckBox;
    chkCUPostCode: TCheckBox;
    chkCUAddress5: TCheckBox;
    chkCUDelAddress5: TCheckBox;
    chkCUInvoiceTo: TCheckBox;
    chkCUUser4: TCheckBox;
    Label4: TLabel;
    chkCUUser5: TCheckBox;
    chkCUUser6: TCheckBox;
    chkCUUser7: TCheckBox;
    chkCUUser8: TCheckBox;
    chkCUUser9: TCheckBox;
    chkCUUser10: TCheckBox;
    tabshStock: TTabSheet;
    chkSTCode: TCheckBox;
    chkSTDesc5: TCheckBox;
    chkSTBarCode: TCheckBox;
    chkSTUser1: TCheckBox;
    Label11: TLabel;
    cmbDescLines: TComboBox;
    chkSTUser2: TCheckBox;
    chkSTBinCode: TCheckBox;
    chkSTDesc6: TCheckBox;
    chkSTDesc1: TCheckBox;
    chkSTDesc2: TCheckBox;
    chkSTPrefSupp: TCheckBox;
    chkSTUnitStock: TCheckBox;
    chkSTUser3: TCheckBox;
    chkSTUser4: TCheckBox;
    chkSTUnitPurchase: TCheckBox;
    chkSTAltCode: TCheckBox;
    chkSTDesc3: TCheckBox;
    chkSTDesc4: TCheckBox;
    chkSTLocation: TCheckBox;
    chkSTUnitSale: TCheckBox;
    Label5: TLabel;
    chkSTUser5: TCheckBox;
    chkSTUser6: TCheckBox;
    chkSTUser7: TCheckBox;
    chkSTUser8: TCheckBox;
    chkSTUser9: TCheckBox;
    chkSTUser10: TCheckBox;
    tabshJobCosting: TTabSheet;
    Label6: TLabel;
    chkJCCode: TCheckBox;
    chkJCAltCode: TCheckBox;
    chkJCUser3: TCheckBox;
    chkJCUser4: TCheckBox;
    chkJCJobType: TCheckBox;
    chkJCDesc1: TCheckBox;
    chkJCJobContact: TCheckBox;
    chkJCSORRef: TCheckBox;
    chkJCUser1: TCheckBox;
    chkJCJobManager: TCheckBox;
    chkJCCustCode: TCheckBox;
    chkJCUser2: TCheckBox;
    chkJCUser5: TCheckBox;
    chkJCUser6: TCheckBox;
    chkJCUser7: TCheckBox;
    chkJCUser8: TCheckBox;
    chkJCUser9: TCheckBox;
    chkJCUser10: TCheckBox;
    TabSheet1: TTabSheet;
    lblMaxRows: TLabel;
    Label1: TLabel;
    edtMaxRows: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    edtConnectionTimeout: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtCommandTimeout: TEdit;
    Label10: TLabel;
    Label9: TLabel;
    udMaxRows: TUpDown;
    udConnectionTimeout: TUpDown;
    udCommandTimeout: TUpDown;
    CustomerPopumMenu: TPopupMenu;
    CustomerCheckAll1: TMenuItem;
    CustomerUnCheckAll1: TMenuItem;
    StockPopumMenu: TPopupMenu;
    StockCheckAll1: TMenuItem;
    StockUnCheckAll1: TMenuItem;
    JobCostingPopupMenu1: TPopupMenu;
    JobCostingCheckAll1: TMenuItem;
    JobCostingUnCheckAll1: TMenuItem;
    chkCULinkActive: TCheckBox;
    chkSTLinkActive: TCheckBox;
    chkJCLinkActive: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure CustomerCheckAll1Click(Sender: TObject);
    procedure CustomerUnCheckAll1Click(Sender: TObject);
    procedure StockCheckAll1Click(Sender: TObject);
    procedure StockUnCheckAll1Click(Sender: TObject);
    procedure JobCostingCheckAll1Click(Sender: TObject);
    procedure JobCostingUnCheckAll1Click(Sender: TObject);
    procedure chkCULinkActiveClick(Sender: TObject);
    procedure chkSTLinkActiveClick(Sender: TObject);
    procedure chkJCLinkActiveClick(Sender: TObject);
  private
    { Private declarations }
    procedure PopulateFields;
    procedure SetupCustSuppSearchFields(bool_enabled : Boolean);
    procedure SetupStockSearchFields(bool_enabled : Boolean);
    procedure SetupJobCostingSearchFields(bool_enabled : Boolean);
    procedure CheckCustSuppSearchFields(bool_checked : Boolean);
    procedure CheckStockSearchFields(bool_checked : Boolean);
    procedure CheckJobCostingSearchFields(bool_checked : Boolean);
  public
    { Public declarations }
  end;

var
  frmAdmin: TfrmAdmin;

implementation

{$R *.dfm}

Uses History, ExchequerRelease;

//=========================================================================

procedure TfrmAdmin.FormCreate(Sender: TObject);
begin
  Application.Title := ExtendedSearchName + ' Admin Build ' + ExtendedSearchVer;
  Caption := Application.Title;

  PopulateFields;
end;

//-------------------------------------------------------------------------

procedure TfrmAdmin.PopulateFields;
Begin // PopulateFields

  chkCULinkActive.Checked       := Settings.CULinkActive;
  chkSTLinkActive.Checked       := Settings.STLinkActive;
  chkJCLinkActive.Checked       := Settings.JCLinkActive;

  chkCUCode.Checked             := Settings.CUCode;
  chkCUCompany.Checked          := Settings.CUCompany;
  chkCUAddress1.Checked         := Settings.CUAddress1;
  chkCUAddress2.Checked         := Settings.CUAddress2;
  chkCUAddress3.Checked         := Settings.CUAddress3;
  chkCUAddress4.Checked         := Settings.CUAddress4;
  chkCUAddress5.Checked         := Settings.CUAddress5;
  chkCUPostCode.Checked         := Settings.CUPostCode;
  chkCUDelAddress1.Checked      := Settings.CUDelAddress1;
  chkCUDelAddress2.Checked      := Settings.CUDelAddress2;
  chkCUDelAddress3.Checked      := Settings.CUDelAddress3;
  chkCUDelAddress4.Checked      := Settings.CUDelAddress4;
  chkCUDelAddress5.Checked      := Settings.CUDelAddress5;
  chkCUContact.Checked          := Settings.CUContact;
  chkCUPhone1.Checked           := Settings.CUPhone1;
  chkCUPhone2.Checked           := Settings.CUPhone2;
  chkCUPhone3.Checked           := Settings.CUPhone3;
  chkCUEMailID.Checked          := Settings.CUEMailID;
  chkCUTheirAccount.Checked     := Settings.CUTheirAccount;
  chkCUInvoiceTo.Checked        := Settings.CUInvoiceTo;
  chkCUAccType.Checked          := Settings.CUAccType;
  chkCUUser1.Checked            := Settings.CUUser1;
  chkCUUser2.Checked            := Settings.CUUser2;
  chkCUUser3.Checked            := Settings.CUUser3;
  chkCUUser4.Checked            := Settings.CUUser4;

  // CA  09/06/2012   v7.0  ABSEXCH-12236: - Extend Search adding 18 UserDef Fields
  chkCUUser5.Checked            := Settings.CUUser5;
  chkCUUser6.Checked            := Settings.CUUser6;
  chkCUUser7.Checked            := Settings.CUUser7;
  chkCUUser8.Checked            := Settings.CUUser8;
  chkCUUser9.Checked            := Settings.CUUser9;
  chkCUUser10.Checked           := Settings.CUUser10;


  chkCUVATNo.Checked            := Settings.CUVATNo;
  chkCUArea.Checked             := Settings.CUArea;

  chkSTCode.Checked             := Settings.STCode;
  chkSTDesc1.Checked            := Settings.STDesc1;
  chkSTDesc2.Checked            := Settings.STDesc2;
  chkSTDesc3.Checked            := Settings.STDesc3;
  chkSTDesc4.Checked            := Settings.STDesc4;
  chkSTDesc5.Checked            := Settings.STDesc5;
  chkSTDesc6.Checked            := Settings.STDesc6;
  chkSTPrefSupp.Checked         := Settings.STPrefSupp;
  chkSTAltCode.Checked          := Settings.STAltCode;
  chkSTLocation.Checked         := Settings.STLocation;
  chkSTBarCode.Checked          := Settings.STBarCode;
  chkSTBinCode.Checked          := Settings.STBinCode;
  chkSTUnitStock.Checked        := Settings.STUnitStock;
  chkSTUnitPurchase.Checked     := Settings.STUnitPurchase;
  chkSTUnitSale.Checked         := Settings.STUnitSale;
  chkSTUser1.Checked            := Settings.STUser1;
  chkSTUser2.Checked            := Settings.STUser2;
  chkSTUser3.Checked            := Settings.STUser3;
  chkSTUser4.Checked            := Settings.STUser4;

  // CA  09/06/2012   v7.0  ABSEXCH-12236: - Extend Search adding 18 UserDef Fields
  chkSTUser5.Checked            := Settings.STUser5;
  chkSTUser6.Checked            := Settings.STUser6;
  chkSTUser7.Checked            := Settings.STUser7;
  chkSTUser8.Checked            := Settings.STUser8;
  chkSTUser9.Checked            := Settings.STUser9;
  chkSTUser10.Checked           := Settings.STUser10;

  cmbDescLines.ItemIndex        := IfThen(Settings.STAppendDesc, 1, 0);

  chkJCCode.Checked             := Settings.JCCode;
  chkJCDesc1.Checked            := Settings.JCDesc1;
  chkJCJobContact.Checked       := Settings.JCJobContact;
  chkJCJobManager.Checked       := Settings.JCJobManager;
  chkJCCustCode.Checked         := Settings.JCCustCode;
  chkJCAltCode.Checked          := Settings.JCAltCode;
  chkJCJobType.Checked          := Settings.JCJobType;
  chkJCSORRef.Checked           := Settings.JCSORRef;
  chkJCUser1.Checked            := Settings.JCUser1;
  chkJCUser2.Checked            := Settings.JCUser2;
  chkJCUser3.Checked            := Settings.JCUser3;
  chkJCUser4.Checked            := Settings.JCUser4;

  // CA  09/06/2012   v7.0  ABSEXCH-12236: - Extend Search adding 18 UserDef Fields
  chkJCUser5.Checked            := Settings.JCUser5;
  chkJCUser6.Checked            := Settings.JCUser6;
  chkJCUser7.Checked            := Settings.JCUser7;
  chkJCUser8.Checked            := Settings.JCUser8;
  chkJCUser9.Checked            := Settings.JCUser9;
  chkJCUser10.Checked           := Settings.JCUser10;

  udMaxRows.Position            := Settings.MaxRowsReturned;
  udConnectionTimeout.Position  := Settings.ConnectionTimeout;
  udCommandTimeout.Position     := Settings.CommandTimeout;
End; // PopulateFields

//-------------------------------------------------------------------------

procedure TfrmAdmin.btnOKClick(Sender: TObject);
begin
  // Update the .Ini file and Close

  Settings.CULinkActive         := chkCULinkActive.Checked;
  Settings.STLinkActive         := chkSTLinkActive.Checked;
  Settings.JCLinkActive         := chkJCLinkActive.Checked;

  Settings.CUCode               := chkCUCode.Checked;
  Settings.CUCompany            := chkCUCompany.Checked;
  Settings.CUAddress1           := chkCUAddress1.Checked;
  Settings.CUAddress2           := chkCUAddress2.Checked;
  Settings.CUAddress3           := chkCUAddress3.Checked;
  Settings.CUAddress4           := chkCUAddress4.Checked;
  Settings.CUAddress5           := chkCUAddress5.Checked;
  Settings.CUPostCode           := chkCUPostCode.Checked;
  Settings.CUDelAddress1        := chkCUDelAddress1.Checked;
  Settings.CUDelAddress2        := chkCUDelAddress2.Checked;
  Settings.CUDelAddress3        := chkCUDelAddress3.Checked;
  Settings.CUDelAddress4        := chkCUDelAddress4.Checked;
  Settings.CUDelAddress5        := chkCUDelAddress5.Checked;
  Settings.CUContact            := chkCUContact.Checked;
  Settings.CUPhone1             := chkCUPhone1.Checked;
  Settings.CUPhone2             := chkCUPhone2.Checked;
  Settings.CUPhone3             := chkCUPhone3.Checked;
  Settings.CUEMailID            := chkCUEMailID.Checked;
  Settings.CUTheirAccount       := chkCUTheirAccount.Checked;
  Settings.CUInvoiceTo          := chkCUInvoiceTo.Checked;
  Settings.CUAccType            := chkCUAccType.Checked;
  Settings.CUUser1              := chkCUUser1.Checked;
  Settings.CUUser2              := chkCUUser2.Checked;
  Settings.CUUser3              := chkCUUser3.Checked;
  Settings.CUUser4              := chkCUUser4.Checked;
  Settings.CUUser5              := chkCUUser5.Checked;
  Settings.CUUser6              := chkCUUser6.Checked;
  Settings.CUUser7              := chkCUUser7.Checked;
  Settings.CUUser8              := chkCUUser8.Checked;
  Settings.CUUser9              := chkCUUser9.Checked;
  Settings.CUUser10             := chkCUUser10.Checked;
  Settings.CUVATNo              := chkCUVATNo.Checked;
  Settings.CUArea               := chkCUArea.Checked;

  Settings.STCode               := chkSTCode.Checked;
  Settings.STDesc1              := chkSTDesc1.Checked;
  Settings.STDesc2              := chkSTDesc2.Checked;
  Settings.STDesc3              := chkSTDesc3.Checked;
  Settings.STDesc4              := chkSTDesc4.Checked;
  Settings.STDesc5              := chkSTDesc5.Checked;
  Settings.STDesc6              := chkSTDesc6.Checked;
  Settings.STPrefSupp           := chkSTPrefSupp.Checked;
  Settings.STAltCode            := chkSTAltCode.Checked;
  Settings.STLocation           := chkSTLocation.Checked;
  Settings.STBarCode            := chkSTBarCode.Checked;
  Settings.STBinCode            := chkSTBinCode.Checked;
  Settings.STUnitStock          := chkSTUnitStock.Checked;
  Settings.STUnitPurchase       := chkSTUnitPurchase.Checked;
  Settings.STUnitSale           := chkSTUnitSale.Checked;
  Settings.STUser1              := chkSTUser1.Checked;
  Settings.STUser2              := chkSTUser2.Checked;
  Settings.STUser3              := chkSTUser3.Checked;
  Settings.STUser4              := chkSTUser4.Checked;
  Settings.STUser5              := chkSTUser5.Checked;
  Settings.STUser6              := chkSTUser6.Checked;
  Settings.STUser7              := chkSTUser7.Checked;
  Settings.STUser8              := chkSTUser8.Checked;
  Settings.STUser9              := chkSTUser9.Checked;
  Settings.STUser10             := chkSTUser10.Checked;
  Settings.STAppendDesc         := (cmbDescLines.ItemIndex = 1);

  Settings.JCCode               := chkJCCode.Checked;
  Settings.JCDesc1              := chkJCDesc1.Checked;
  Settings.JCJobContact         := chkJCJobContact.Checked;
  Settings.JCJobManager         := chkJCJobManager.Checked;
  Settings.JCCustCode           := chkJCCustCode.Checked;
  Settings.JCAltCode            := chkJCAltCode.Checked;
  Settings.JCJobType            := chkJCJobType.Checked;
  Settings.JCSORRef             := chkJCSORRef.Checked;
  Settings.JCUser1              := chkJCUser1.Checked;
  Settings.JCUser2              := chkJCUser2.Checked;
  Settings.JCUser3              := chkJCUser3.Checked;
  Settings.JCUser4              := chkJCUser4.Checked;
  Settings.JCUser5              := chkJCUser5.Checked;
  Settings.JCUser6              := chkJCUser6.Checked;
  Settings.JCUser7              := chkJCUser7.Checked;
  Settings.JCUser8              := chkJCUser8.Checked;
  Settings.JCUser9              := chkJCUser9.Checked;
  Settings.JCUser10             := chkJCUser10.Checked;

  Settings.MaxRowsReturned      := udMaxRows.Position;
  Settings.ConnectionTimeout    := udConnectionTimeout.Position;
  Settings.CommandTimeout       := udCommandTimeout.Position;

  Settings.SaveSettings;

  Close;
end;

//-------------------------------------------------------------------------

procedure TfrmAdmin.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAdmin.CheckCustSuppSearchFields(bool_checked : Boolean);
Begin
  chkCUCode.Checked             := bool_checked;
  chkCUCompany.Checked          := bool_checked;
  chkCUAddress1.Checked         := bool_checked;
  chkCUAddress2.Checked         := bool_checked;
  chkCUAddress3.Checked         := bool_checked;
  chkCUAddress4.Checked         := bool_checked;
  chkCUAddress5.Checked         := bool_checked;
  chkCUPostCode.Checked         := bool_checked;
  chkCUDelAddress1.Checked      := bool_checked;
  chkCUDelAddress2.Checked      := bool_checked;
  chkCUDelAddress3.Checked      := bool_checked;
  chkCUDelAddress4.Checked      := bool_checked;
  chkCUDelAddress5.Checked      := bool_checked;
  chkCUContact.Checked          := bool_checked;
  chkCUPhone1.Checked           := bool_checked;
  chkCUPhone2.Checked           := bool_checked;
  chkCUPhone3.Checked           := bool_checked;
  chkCUEMailID.Checked          := bool_checked;
  chkCUTheirAccount.Checked     := bool_checked;
  chkCUInvoiceTo.Checked        := bool_checked;
  chkCUAccType.Checked          := bool_checked;
  chkCUUser1.Checked            := bool_checked;
  chkCUUser2.Checked            := bool_checked;
  chkCUUser3.Checked            := bool_checked;
  chkCUUser4.Checked            := bool_checked;
  chkCUUser5.Checked            := bool_checked;
  chkCUUser6.Checked            := bool_checked;
  chkCUUser7.Checked            := bool_checked;
  chkCUUser8.Checked            := bool_checked;
  chkCUUser9.Checked            := bool_checked;
  chkCUUser10.Checked           := bool_checked;
  chkCUVATNo.Checked            := bool_checked;
  chkCUArea.Checked             := bool_checked;
End;

procedure TfrmAdmin.CheckStockSearchFields(bool_checked : Boolean);
Begin
  chkSTCode.Checked             := bool_checked;
  chkSTDesc1.Checked            := bool_checked;
  chkSTDesc2.Checked            := bool_checked;
  chkSTDesc3.Checked            := bool_checked;
  chkSTDesc4.Checked            := bool_checked;
  chkSTDesc5.Checked            := bool_checked;
  chkSTDesc6.Checked            := bool_checked;
  chkSTPrefSupp.Checked         := bool_checked;
  chkSTAltCode.Checked          := bool_checked;
  chkSTLocation.Checked         := bool_checked;
  chkSTBarCode.Checked          := bool_checked;
  chkSTBinCode.Checked          := bool_checked;
  chkSTUnitStock.Checked        := bool_checked;
  chkSTUnitPurchase.Checked     := bool_checked;
  chkSTUnitSale.Checked         := bool_checked;
  chkSTUser1.Checked            := bool_checked;
  chkSTUser2.Checked            := bool_checked;
  chkSTUser3.Checked            := bool_checked;
  chkSTUser4.Checked            := bool_checked;
  chkSTUser5.Checked            := bool_checked;
  chkSTUser6.Checked            := bool_checked;
  chkSTUser7.Checked            := bool_checked;
  chkSTUser8.Checked            := bool_checked;
  chkSTUser9.Checked            := bool_checked;
  chkSTUser10.Checked           := bool_checked;
End;

procedure TfrmAdmin.CheckJobCostingSearchFields(bool_checked : Boolean);
Begin
  chkJCCode.Checked             := bool_checked;
  chkJCDesc1.Checked            := bool_checked;
  chkJCJobContact.Checked       := bool_checked;
  chkJCJobManager.Checked       := bool_checked;
  chkJCCustCode.Checked         := bool_checked;
  chkJCAltCode.Checked          := bool_checked;
  chkJCJobType.Checked          := bool_checked;
  chkJCSORRef.Checked           := bool_checked;
  chkJCUser1.Checked            := bool_checked;
  chkJCUser2.Checked            := bool_checked;
  chkJCUser3.Checked            := bool_checked;
  chkJCUser4.Checked            := bool_checked;
  chkJCUser5.Checked            := bool_checked;
  chkJCUser6.Checked            := bool_checked;
  chkJCUser7.Checked            := bool_checked;
  chkJCUser8.Checked            := bool_checked;
  chkJCUser9.Checked            := bool_checked;
  chkJCUser10.Checked           := bool_checked;
End;

procedure TfrmAdmin.SetupCustSuppSearchFields(bool_enabled : Boolean);
Begin
  chkCUCode.Enabled             := bool_enabled;
  chkCUCompany.Enabled          := bool_enabled;
  chkCUAddress1.Enabled         := bool_enabled;
  chkCUAddress2.Enabled         := bool_enabled;
  chkCUAddress3.Enabled         := bool_enabled;
  chkCUAddress4.Enabled         := bool_enabled;
  chkCUAddress5.Enabled         := bool_enabled;
  chkCUPostCode.Enabled         := bool_enabled;
  chkCUDelAddress1.Enabled      := bool_enabled;
  chkCUDelAddress2.Enabled      := bool_enabled;
  chkCUDelAddress3.Enabled      := bool_enabled;
  chkCUDelAddress4.Enabled      := bool_enabled;
  chkCUDelAddress5.Enabled      := bool_enabled;
  chkCUContact.Enabled          := bool_enabled;
  chkCUPhone1.Enabled           := bool_enabled;
  chkCUPhone2.Enabled           := bool_enabled;
  chkCUPhone3.Enabled           := bool_enabled;
  chkCUEMailID.Enabled          := bool_enabled;
  chkCUTheirAccount.Enabled     := bool_enabled;
  chkCUInvoiceTo.Enabled        := bool_enabled;
  chkCUAccType.Enabled          := bool_enabled;
  chkCUUser1.Enabled            := bool_enabled;
  chkCUUser2.Enabled            := bool_enabled;
  chkCUUser3.Enabled            := bool_enabled;
  chkCUUser4.Enabled            := bool_enabled;
  chkCUUser5.Enabled            := bool_enabled;
  chkCUUser6.Enabled            := bool_enabled;
  chkCUUser7.Enabled            := bool_enabled;
  chkCUUser8.Enabled            := bool_enabled;
  chkCUUser9.Enabled            := bool_enabled;
  chkCUUser10.Enabled           := bool_enabled;
  chkCUVATNo.Enabled            := bool_enabled;
  chkCUArea.Enabled             := bool_enabled;
End;

procedure TfrmAdmin.SetupStockSearchFields(bool_enabled : Boolean);
Begin
  chkSTCode.Enabled             := bool_enabled;
  chkSTDesc1.Enabled            := bool_enabled;
  chkSTDesc2.Enabled            := bool_enabled;
  chkSTDesc3.Enabled            := bool_enabled;
  chkSTDesc4.Enabled            := bool_enabled;
  chkSTDesc5.Enabled            := bool_enabled;
  chkSTDesc6.Enabled            := bool_enabled;
  chkSTPrefSupp.Enabled         := bool_enabled;
  chkSTAltCode.Enabled          := bool_enabled;
  chkSTLocation.Enabled         := bool_enabled;
  chkSTBarCode.Enabled          := bool_enabled;
  chkSTBinCode.Enabled          := bool_enabled;
  chkSTUnitStock.Enabled        := bool_enabled;
  chkSTUnitPurchase.Enabled     := bool_enabled;
  chkSTUnitSale.Enabled         := bool_enabled;
  chkSTUser1.Enabled            := bool_enabled;
  chkSTUser2.Enabled            := bool_enabled;
  chkSTUser3.Enabled            := bool_enabled;
  chkSTUser4.Enabled            := bool_enabled;
  chkSTUser5.Enabled            := bool_enabled;
  chkSTUser6.Enabled            := bool_enabled;
  chkSTUser7.Enabled            := bool_enabled;
  chkSTUser8.Enabled            := bool_enabled;
  chkSTUser9.Enabled            := bool_enabled;
  chkSTUser10.Enabled           := bool_enabled;
  cmbDescLines.Enabled          := bool_enabled;
End;

procedure TfrmAdmin.SetupJobCostingSearchFields(bool_enabled : Boolean);
Begin
  chkJCCode.Enabled             := bool_enabled;
  chkJCDesc1.Enabled            := bool_enabled;
  chkJCJobContact.Enabled       := bool_enabled;
  chkJCJobManager.Enabled       := bool_enabled;
  chkJCCustCode.Enabled         := bool_enabled;
  chkJCAltCode.Enabled          := bool_enabled;
  chkJCJobType.Enabled          := bool_enabled;
  chkJCSORRef.Enabled           := bool_enabled;
  chkJCUser1.Enabled            := bool_enabled;
  chkJCUser2.Enabled            := bool_enabled;
  chkJCUser3.Enabled            := bool_enabled;
  chkJCUser4.Enabled            := bool_enabled;
  chkJCUser5.Enabled            := bool_enabled;
  chkJCUser6.Enabled            := bool_enabled;
  chkJCUser7.Enabled            := bool_enabled;
  chkJCUser8.Enabled            := bool_enabled;
  chkJCUser9.Enabled            := bool_enabled;
  chkJCUser10.Enabled           := bool_enabled;
End;

procedure TfrmAdmin.CustomerCheckAll1Click(Sender: TObject);
begin
  CheckCustSuppSearchFields(True);
end;

procedure TfrmAdmin.CustomerUnCheckAll1Click(Sender: TObject);
begin
  CheckCustSuppSearchFields(False);
end;

procedure TfrmAdmin.StockCheckAll1Click(Sender: TObject);
begin
 CheckStockSearchFields(True);
end;

procedure TfrmAdmin.StockUnCheckAll1Click(Sender: TObject);
begin
  CheckStockSearchFields(False);
end;

procedure TfrmAdmin.JobCostingCheckAll1Click(Sender: TObject);
begin
  CheckJobCostingSearchFields(True);
end;

procedure TfrmAdmin.JobCostingUnCheckAll1Click(Sender: TObject);
begin
  CheckJobCostingSearchFields(False);
end;

procedure TfrmAdmin.chkCULinkActiveClick(Sender: TObject);
begin
  SetupCustSuppSearchFields(chkCULinkActive.Checked);
end;

procedure TfrmAdmin.chkSTLinkActiveClick(Sender: TObject);
begin
  SetupStockSearchFields(chkSTLinkActive.Checked);
end;

procedure TfrmAdmin.chkJCLinkActiveClick(Sender: TObject);
begin
  SetupJobCostingSearchFields(chkJCLinkActive.Checked);
end;

end.
