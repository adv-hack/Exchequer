unit EnableButtonsF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, AdvGlowButton, ComCtrls, Buttons;

type
  TfrmEnablecustomButtons = class(TForm)
    PageControl1: TPageControl;
    custlst2Sheet: TTabSheet;
    custr3uSheet: TTabSheet;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    chkCustLst1: TCheckBox;
    chkCustLst2: TCheckBox;
    chkCustLst3: TCheckBox;
    chkCustLst4: TCheckBox;
    chkCustLst5: TCheckBox;
    chkCustLst6: TCheckBox;
    chkSuppLst1: TCheckBox;
    chkSuppLst2: TCheckBox;
    chkSuppLst3: TCheckBox;
    chkSuppLst4: TCheckBox;
    chkSuppLst5: TCheckBox;
    chkSuppLst6: TCheckBox;
    jobmn2uSheet: TTabSheet;
    daybk2Sheet: TTabSheet;
    jobdbk2uSheet: TTabSheet;
    stockuSheet: TTabSheet;
    saletx2uSheet: TTabSheet;
    stkdjuSheet: TTabSheet;
    wordoc2uSheet: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Bevel1: TBevel;
    Label2: TLabel;
    Bevel2: TBevel;
    Label3: TLabel;
    Bevel3: TBevel;
    Label4: TLabel;
    Bevel4: TBevel;
    Label5: TLabel;
    Bevel5: TBevel;
    Label6: TLabel;
    chkSalesDBkQuotes1: TCheckBox;
    chkSalesDBkQuotes2: TCheckBox;
    chkSalesDBkAuto1: TCheckBox;
    chkSalesDBkAuto2: TCheckBox;
    chkSalesDBkHistory1: TCheckBox;
    chkSalesDBkHistory2: TCheckBox;
    chkSalesDBkOrders1: TCheckBox;
    chkSalesDBkOrders2: TCheckBox;
    chkSalesDBkOrderHistory1: TCheckBox;
    chkSalesDBkOrderHistory2: TCheckBox;
    chkSalesDBkMain1: TCheckBox;
    chkSalesDBkMain2: TCheckBox;
    chkSalesDBkQuotes3: TCheckBox;
    chkSalesDBkQuotes4: TCheckBox;
    chkSalesDBkAuto3: TCheckBox;
    chkSalesDBkAuto4: TCheckBox;
    chkSalesDBkHistory3: TCheckBox;
    chkSalesDBkHistory4: TCheckBox;
    chkSalesDBkOrders3: TCheckBox;
    chkSalesDBkOrders4: TCheckBox;
    chkSalesDBkOrderHistory3: TCheckBox;
    chkSalesDBkOrderHistory4: TCheckBox;
    chkSalesDBkMain3: TCheckBox;
    chkSalesDBkMain4: TCheckBox;
    chkSalesDBkQuotes5: TCheckBox;
    chkSalesDBkQuotes6: TCheckBox;
    chkSalesDBkAuto5: TCheckBox;
    chkSalesDBkAuto6: TCheckBox;
    chkSalesDBkHistory5: TCheckBox;
    chkSalesDBkHistory6: TCheckBox;
    chkSalesDBkOrders5: TCheckBox;
    chkSalesDBkOrders6: TCheckBox;
    chkSalesDBkOrderHistory5: TCheckBox;
    chkSalesDBkOrderHistory6: TCheckBox;
    chkSalesDBkMain5: TCheckBox;
    chkSalesDBkMain6: TCheckBox;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    Bevel6: TBevel;
    Label8: TLabel;
    Bevel7: TBevel;
    Label9: TLabel;
    Bevel8: TBevel;
    Label10: TLabel;
    Bevel9: TBevel;
    Label11: TLabel;
    Bevel10: TBevel;
    Label12: TLabel;
    chkPurchDBkMain1: TCheckBox;
    chkPurchDBkMain2: TCheckBox;
    chkPurchDBkQuotes1: TCheckBox;
    chkPurchDBkQuotes2: TCheckBox;
    chkPurchDBkAuto1: TCheckBox;
    chkPurchDBkAuto2: TCheckBox;
    chkPurchDBkHistory1: TCheckBox;
    chkPurchDBkHistory2: TCheckBox;
    chkPurchDBkOrders1: TCheckBox;
    chkPurchDBkOrders2: TCheckBox;
    chkPurchDBkOrderHistory1: TCheckBox;
    chkPurchDBkOrderHistory2: TCheckBox;
    GroupBox3: TGroupBox;
    Label13: TLabel;
    Bevel11: TBevel;
    Label14: TLabel;
    Bevel12: TBevel;
    Label15: TLabel;
    chkNomDBkMain1: TCheckBox;
    chkNomDBkMain2: TCheckBox;
    chkNomDBkAuto1: TCheckBox;
    chkNomDBkAuto2: TCheckBox;
    chkNomDBkHistory1: TCheckBox;
    chkNomDBkHistory2: TCheckBox;
    chkPurchDBkMain3: TCheckBox;
    chkPurchDBkMain4: TCheckBox;
    chkPurchDBkQuotes3: TCheckBox;
    chkPurchDBkQuotes4: TCheckBox;
    chkPurchDBkAuto3: TCheckBox;
    chkPurchDBkAuto4: TCheckBox;
    chkPurchDBkHistory3: TCheckBox;
    chkPurchDBkHistory4: TCheckBox;
    chkPurchDBkOrders3: TCheckBox;
    chkPurchDBkOrders4: TCheckBox;
    chkPurchDBkOrderHistory3: TCheckBox;
    chkPurchDBkOrderHistory4: TCheckBox;
    chkPurchDBkMain5: TCheckBox;
    chkPurchDBkMain6: TCheckBox;
    chkPurchDBkQuotes5: TCheckBox;
    chkPurchDBkQuotes6: TCheckBox;
    chkPurchDBkAuto5: TCheckBox;
    chkPurchDBkAuto6: TCheckBox;
    chkPurchDBkHistory5: TCheckBox;
    chkPurchDBkHistory6: TCheckBox;
    chkPurchDBkOrders5: TCheckBox;
    chkPurchDBkOrders6: TCheckBox;
    chkPurchDBkOrderHistory5: TCheckBox;
    chkPurchDBkOrderHistory6: TCheckBox;
    chkNomDBkMain3: TCheckBox;
    chkNomDBkMain4: TCheckBox;
    chkNomDBkAuto3: TCheckBox;
    chkNomDBkAuto4: TCheckBox;
    chkNomDBkHistory3: TCheckBox;
    chkNomDBkHistory4: TCheckBox;
    chkNomDBkMain5: TCheckBox;
    chkNomDBkMain6: TCheckBox;
    chkNomDBkAuto5: TCheckBox;
    chkNomDBkAuto6: TCheckBox;
    chkNomDBkHistory5: TCheckBox;
    chkNomDBkHistory6: TCheckBox;
    controlPanel: TPanel;
    btnSetHookPointStatus: TButton;
    GroupBox6: TGroupBox;
    chkCustLedger1: TCheckBox;
    chkCustLedger2: TCheckBox;
    chkCustLedger3: TCheckBox;
    chkCustLedger4: TCheckBox;
    chkCustLedger5: TCheckBox;
    chkCustLedger6: TCheckBox;
    GroupBox7: TGroupBox;
    chkSuppLedger1: TCheckBox;
    chkSuppLedger2: TCheckBox;
    chkSuppLedger3: TCheckBox;
    chkSuppLedger4: TCheckBox;
    chkSuppLedger5: TCheckBox;
    chkSuppLedger6: TCheckBox;
    GroupBox8: TGroupBox;
    Label17: TLabel;
    Bevel13: TBevel;
    Label18: TLabel;
    Bevel14: TBevel;
    Label19: TLabel;
    Bevel15: TBevel;
    Label20: TLabel;
    Bevel16: TBevel;
    Label21: TLabel;
    chkJobNotes1: TCheckBox;
    chkJobNotes2: TCheckBox;
    chkJobLedger1: TCheckBox;
    chkJobLedger2: TCheckBox;
    chkJobPurchRet1: TCheckBox;
    chkJobPurchRet2: TCheckBox;
    chkJobSalesRet1: TCheckBox;
    chkJobSalesRet2: TCheckBox;
    chkJobMain1: TCheckBox;
    chkJobMain2: TCheckBox;
    chkJobNotes3: TCheckBox;
    chkJobNotes4: TCheckBox;
    chkJobLedger3: TCheckBox;
    chkJobLedger4: TCheckBox;
    chkJobPurchRet3: TCheckBox;
    chkJobPurchRet4: TCheckBox;
    chkJobSalesRet3: TCheckBox;
    chkJobSalesRet4: TCheckBox;
    chkJobMain3: TCheckBox;
    chkJobMain4: TCheckBox;
    chkJobNotes5: TCheckBox;
    chkJobNotes6: TCheckBox;
    chkJobLedger5: TCheckBox;
    chkJobLedger6: TCheckBox;
    chkJobPurchRet5: TCheckBox;
    chkJobPurchRet6: TCheckBox;
    chkJobSalesRet5: TCheckBox;
    chkJobSalesRet6: TCheckBox;
    chkJobMain5: TCheckBox;
    chkJobMain6: TCheckBox;
    GroupBox9: TGroupBox;
    Label22: TLabel;
    Bevel17: TBevel;
    Label23: TLabel;
    Bevel18: TBevel;
    Label24: TLabel;
    Bevel19: TBevel;
    Label25: TLabel;
    Bevel20: TBevel;
    Label26: TLabel;
    chkJobTimesheets1: TCheckBox;
    chkJobTimesheets2: TCheckBox;
    chkJobTimesheetHist1: TCheckBox;
    chkJobTimesheetHist2: TCheckBox;
    chkJobPurchApps1: TCheckBox;
    chkJobPurchApps2: TCheckBox;
    chkJobPurchAppHist1: TCheckBox;
    chkJobPurchAppHist2: TCheckBox;
    chkJobPrePost1: TCheckBox;
    chkJobPrePost2: TCheckBox;
    chkJobTimesheets3: TCheckBox;
    chkJobTimesheets4: TCheckBox;
    chkJobTimesheetHist3: TCheckBox;
    chkJobTimesheetHist4: TCheckBox;
    chkJobPurchApps3: TCheckBox;
    chkJobPurchApps4: TCheckBox;
    chkJobPurchAppHist3: TCheckBox;
    chkJobPurchAppHist4: TCheckBox;
    chkJobPrePost3: TCheckBox;
    chkJobPrePost4: TCheckBox;
    chkJobTimesheets5: TCheckBox;
    chkJobTimesheets6: TCheckBox;
    chkJobTimesheetHist5: TCheckBox;
    chkJobTimesheetHist6: TCheckBox;
    chkJobPurchApps5: TCheckBox;
    chkJobPurchApps6: TCheckBox;
    chkJobPurchAppHist5: TCheckBox;
    chkJobPurchAppHist6: TCheckBox;
    chkJobPrePost5: TCheckBox;
    chkJobPrePost6: TCheckBox;
    Label27: TLabel;
    Bevel21: TBevel;
    Label28: TLabel;
    Bevel22: TBevel;
    Label29: TLabel;
    Bevel23: TBevel;
    Label30: TLabel;
    Bevel24: TBevel;
    chkJobSalesAppHist1: TCheckBox;
    chkJobSalesAppHist2: TCheckBox;
    chkJobPLRetentions1: TCheckBox;
    chkJobPLRetentions2: TCheckBox;
    chkJobSLRetentions1: TCheckBox;
    chkJobSLRetentions2: TCheckBox;
    chkJobSalesApps1: TCheckBox;
    chkJobSalesApps2: TCheckBox;
    chkJobSalesAppHist3: TCheckBox;
    chkJobSalesAppHist4: TCheckBox;
    chkJobPLRetentions3: TCheckBox;
    chkJobPLRetentions4: TCheckBox;
    chkJobSLRetentions3: TCheckBox;
    chkJobSLRetentions4: TCheckBox;
    chkJobSalesApps3: TCheckBox;
    chkJobSalesApps4: TCheckBox;
    chkJobSalesAppHist5: TCheckBox;
    chkJobSalesAppHist6: TCheckBox;
    chkJobPLRetentions5: TCheckBox;
    chkJobPLRetentions6: TCheckBox;
    chkJobSLRetentions5: TCheckBox;
    chkJobSLRetentions6: TCheckBox;
    chkJobSalesApps5: TCheckBox;
    chkJobSalesApps6: TCheckBox;
    GroupBox10: TGroupBox;
    Label31: TLabel;
    Bevel25: TBevel;
    Label32: TLabel;
    Bevel26: TBevel;
    Label33: TLabel;
    Bevel27: TBevel;
    Label34: TLabel;
    Bevel28: TBevel;
    Label35: TLabel;
    Label36: TLabel;
    Bevel29: TBevel;
    Label37: TLabel;
    Bevel30: TBevel;
    Label38: TLabel;
    Bevel31: TBevel;
    Label39: TLabel;
    Bevel32: TBevel;
    chkStockDefaults1: TCheckBox;
    chkStockDefaults2: TCheckBox;
    chkStockVATWeb1: TCheckBox;
    chkStockVATWeb2: TCheckBox;
    chkStockWOP1: TCheckBox;
    chkStockWOP2: TCheckBox;
    chkStockReturns1: TCheckBox;
    chkStockReturns2: TCheckBox;
    chkStockMain1: TCheckBox;
    chkStockMain2: TCheckBox;
    chkStockDefaults3: TCheckBox;
    chkStockDefaults4: TCheckBox;
    chkStockVATWeb3: TCheckBox;
    chkStockVATWeb4: TCheckBox;
    chkStockWOP3: TCheckBox;
    chkStockWOP4: TCheckBox;
    chkStockReturns3: TCheckBox;
    chkStockReturns4: TCheckBox;
    chkStockMain3: TCheckBox;
    chkStockMain4: TCheckBox;
    chkStockDefaults5: TCheckBox;
    chkStockDefaults6: TCheckBox;
    chkStockVATWeb5: TCheckBox;
    chkStockVATWeb6: TCheckBox;
    chkStockWOP5: TCheckBox;
    chkStockWOP6: TCheckBox;
    chkStockReturns5: TCheckBox;
    chkStockReturns6: TCheckBox;
    chkStockMain5: TCheckBox;
    chkStockMain6: TCheckBox;
    chkStockMBDiscounts1: TCheckBox;
    chkStockMBDiscounts2: TCheckBox;
    chkStockLedger1: TCheckBox;
    chkStockLedger2: TCheckBox;
    chkStockValue1: TCheckBox;
    chkStockValue2: TCheckBox;
    chkStockQtyBreaks1: TCheckBox;
    chkStockQtyBreaks2: TCheckBox;
    chkStockMBDiscounts3: TCheckBox;
    chkStockMBDiscounts4: TCheckBox;
    chkStockLedger3: TCheckBox;
    chkStockLedger4: TCheckBox;
    chkStockValue3: TCheckBox;
    chkStockValue4: TCheckBox;
    chkStockQtyBreaks3: TCheckBox;
    chkStockQtyBreaks4: TCheckBox;
    chkStockMBDiscounts5: TCheckBox;
    chkStockMBDiscounts6: TCheckBox;
    chkStockLedger5: TCheckBox;
    chkStockLedger6: TCheckBox;
    chkStockValue5: TCheckBox;
    chkStockValue6: TCheckBox;
    chkStockQtyBreaks5: TCheckBox;
    chkStockQtyBreaks6: TCheckBox;
    Bevel33: TBevel;
    Label40: TLabel;
    chkStockNotes1: TCheckBox;
    chkStockNotes2: TCheckBox;
    chkStockNotes3: TCheckBox;
    chkStockNotes4: TCheckBox;
    chkStockNotes5: TCheckBox;
    chkStockNotes6: TCheckBox;
    Label41: TLabel;
    Bevel34: TBevel;
    Label42: TLabel;
    chkStockBuild1: TCheckBox;
    chkStockBuild2: TCheckBox;
    chkStockSerial1: TCheckBox;
    chkStockSerial2: TCheckBox;
    chkStockBuild3: TCheckBox;
    chkStockBuild4: TCheckBox;
    chkStockSerial3: TCheckBox;
    chkStockSerial4: TCheckBox;
    chkStockBuild5: TCheckBox;
    chkStockBuild6: TCheckBox;
    chkStockSerial5: TCheckBox;
    chkStockSerial6: TCheckBox;
    Label43: TLabel;
    Bevel35: TBevel;
    chkStockBins1: TCheckBox;
    chkStockBins2: TCheckBox;
    chkStockBins3: TCheckBox;
    chkStockBins4: TCheckBox;
    chkStockBins5: TCheckBox;
    chkStockBins6: TCheckBox;
    Bevel36: TBevel;
    Bevel37: TBevel;
    Bevel38: TBevel;
    Bevel39: TBevel;
    Bevel40: TBevel;
    Bevel41: TBevel;
    Bevel42: TBevel;
    GroupBox11: TGroupBox;
    Label44: TLabel;
    Bevel43: TBevel;
    Label45: TLabel;
    Label46: TLabel;
    Bevel45: TBevel;
    Label47: TLabel;
    chkPurchEdit1: TCheckBox;
    chkPurchEdit2: TCheckBox;
    chkSalesView1: TCheckBox;
    chkSalesView2: TCheckBox;
    chkPurchView1: TCheckBox;
    chkPurchView2: TCheckBox;
    chkSalesEdit1: TCheckBox;
    chkSalesEdit2: TCheckBox;
    chkPurchEdit3: TCheckBox;
    chkPurchEdit4: TCheckBox;
    chkSalesView3: TCheckBox;
    chkSalesView4: TCheckBox;
    chkPurchView3: TCheckBox;
    chkPurchView4: TCheckBox;
    chkSalesEdit3: TCheckBox;
    chkSalesEdit4: TCheckBox;
    chkPurchEdit5: TCheckBox;
    chkPurchEdit6: TCheckBox;
    chkSalesView5: TCheckBox;
    chkSalesView6: TCheckBox;
    chkPurchView5: TCheckBox;
    chkPurchView6: TCheckBox;
    chkSalesEdit5: TCheckBox;
    chkSalesEdit6: TCheckBox;
    GroupBox12: TGroupBox;
    Label48: TLabel;
    Bevel46: TBevel;
    Label49: TLabel;
    chkStockView1: TCheckBox;
    chkStockView2: TCheckBox;
    chkStockEdit1: TCheckBox;
    chkStockEdit2: TCheckBox;
    chkStockView3: TCheckBox;
    chkStockView4: TCheckBox;
    chkStockEdit3: TCheckBox;
    chkStockEdit4: TCheckBox;
    chkStockView5: TCheckBox;
    chkStockView6: TCheckBox;
    chkStockEdit5: TCheckBox;
    chkStockEdit6: TCheckBox;
    GroupBox13: TGroupBox;
    Label50: TLabel;
    Bevel47: TBevel;
    Label51: TLabel;
    chkWORView1: TCheckBox;
    chkWORView2: TCheckBox;
    chkWOREdit1: TCheckBox;
    chkWOREdit2: TCheckBox;
    chkWORView3: TCheckBox;
    chkWORView4: TCheckBox;
    chkWOREdit3: TCheckBox;
    chkWOREdit4: TCheckBox;
    chkWORView5: TCheckBox;
    chkWORView6: TCheckBox;
    chkWOREdit5: TCheckBox;
    chkWOREdit6: TCheckBox;
    btnToggleCustList: TSpeedButton;
    btnToggleSuppList: TSpeedButton;
    btnToggleCustLedger: TSpeedButton;
    btnToggleSuppLedger: TSpeedButton;
    btnToggleJobMain: TSpeedButton;
    btnToggleJobNotes: TSpeedButton;
    btnToggleJobLedger: TSpeedButton;
    btnToggleJobPurchRet: TSpeedButton;
    btnToggleJobRet: TSpeedButton;
    btnToggleDaybookMain: TSpeedButton;
    btnToggleDaybookQuotes: TSpeedButton;
    btnToggleDaybookAuto: TSpeedButton;
    btnToggleDaybookHistory: TSpeedButton;
    btnToggleDaybookOrders: TSpeedButton;
    btnToggleDaybookOrderHist: TSpeedButton;
    btnPurchToggleDaybookMain: TSpeedButton;
    btnPurchToggleDaybookQuotes: TSpeedButton;
    btnPurchToggleDaybookAuto: TSpeedButton;
    btnPurchToggleDaybookHist: TSpeedButton;
    btnPurchToggleDaybookOrders: TSpeedButton;
    btnPurchToggleDaybookOrderHist: TSpeedButton;
    btnNomToggleDaybookMain: TSpeedButton;
    btnNomToggleDaybookAuto: TSpeedButton;
    btnNomToggleDaybookHist: TSpeedButton;
    btnToggleJobDbkPrepost: TSpeedButton;
    btnToggleJobDbkTimesheets: TSpeedButton;
    btnToggleJobDbkTSheetHist: TSpeedButton;
    btnToggleJobDbkPurchApps: TSpeedButton;
    btnToggleJobDbkPurchAppHist: TSpeedButton;
    btnToggleJobDbkSalesApps: TSpeedButton;
    btnToggleJobDbkSalesAppHist: TSpeedButton;
    btnToggleJobDbkPLRetent: TSpeedButton;
    btnToggleJobDbkSLRetent: TSpeedButton;
    btnToggleStockMain: TSpeedButton;
    btnToggleStockDefs: TSpeedButton;
    btnToggleStockVatWeb: TSpeedButton;
    btnToggleStockWOP: TSpeedButton;
    btnToggleStockReturns: TSpeedButton;
    btnToggleStockNotes: TSpeedButton;
    btnToggleStockQtyBreaks: TSpeedButton;
    btnToggleStockMultiBuy: TSpeedButton;
    btnToggleStockLedger: TSpeedButton;
    btnToggleStockValue: TSpeedButton;
    btnToggleStockBuild: TSpeedButton;
    btnToggleStockSerial: TSpeedButton;
    btnToggleStockBins: TSpeedButton;
    btnToggleSalesSales: TSpeedButton;
    btnToggleSalesPurch: TSpeedButton;
    btnToggleSalesSalesView: TSpeedButton;
    btnToggleSalesPurchView: TSpeedButton;
    btnToggleStkAdjEdit: TSpeedButton;
    btnToggleStkAdjView: TSpeedButton;
    btnToggleWOREdit: TSpeedButton;
    btnToggleWORView: TSpeedButton;
    Label16: TLabel;
    btnToggleTraderList: TButton;
    btnToggleCustSuppLedger: TButton;
    btnToggleJobRecord: TButton;
    btnToggleAllDaybook: TButton;
    btnToggleJobDaybook: TButton;
    btnToggleStock: TButton;
    btnToggleSales: TButton;
    btnToggleStockAdjust: TButton;
    btnToggleWOR: TButton;
    Label52: TLabel;
    btnToggleEverything: TButton;
    btnRandomCustSupp: TButton;
    btnRandomCustSuppLedger: TButton;
    btnRandomJobRec: TButton;
    btnRandomDaybook: TButton;
    btnRandomJobDbk: TButton;
    btnRandomStock: TButton;
    btnRandomSales: TButton;
    btnRandomStkAdj: TButton;
    btnRandomWOR: TButton;
    btnTraderAllOff: TButton;
    btnLedgerAllOff: TButton;
    btnJobRecAllOff: TButton;
    btnDbkAllOff: TButton;
    btnJobDbkAllOff: TButton;
    btnStockAllOff: TButton;
    btnSalesAllOff: TButton;
    btnStkAdjAllOff: TButton;
    btnWORAllOff: TButton;
    GroupBoxWorDaybook: TGroupBox;
    Label53: TLabel;
    Bevel44: TBevel;
    Bevel48: TBevel;
    Label55: TLabel;
    Bevel49: TBevel;
    Bevel50: TBevel;
    Bevel51: TBevel;
    btnWORToggleDaybookMain: TSpeedButton;
    btnWORToggleDaybookHist: TSpeedButton;
    chkWORDbkMain1: TCheckBox;
    chkWORDbkMain2: TCheckBox;
    chkWORDbkHistory1: TCheckBox;
    chkWORDbkHistory2: TCheckBox;
    chkWORDbkMain3: TCheckBox;
    chkWORDbkMain4: TCheckBox;
    chkWORDbkHistory3: TCheckBox;
    chkWORDbkHistory4: TCheckBox;
    chkWORDbkMain5: TCheckBox;
    chkWORDbkMain6: TCheckBox;
    chkWORDbkHistory5: TCheckBox;
    chkWORDbkHistory6: TCheckBox;
    procedure btnSetHookPointStatusClick(Sender: TObject);
    procedure btnToggleCustListClick(Sender: TObject);
    procedure btnToggleSuppListClick(Sender: TObject);
    procedure btnToggleCustLedgerClick(Sender: TObject);
    procedure btnToggleSuppLedgerClick(Sender: TObject);
    procedure btnToggleJobMainClick(Sender: TObject);
    procedure btnToggleJobNotesClick(Sender: TObject);
    procedure btnToggleJobLedgerClick(Sender: TObject);
    procedure btnToggleJobPurchRetClick(Sender: TObject);
    procedure btnToggleJobRetClick(Sender: TObject);
    procedure btnToggleDaybookMainClick(Sender: TObject);
    procedure btnToggleDaybookQuotesClick(Sender: TObject);
    procedure btnToggleDaybookAutoClick(Sender: TObject);
    procedure btnToggleDaybookHistoryClick(Sender: TObject);
    procedure btnToggleDaybookOrdersClick(Sender: TObject);
    procedure btnToggleDaybookOrderHistClick(Sender: TObject);
    procedure btnPurchToggleDaybookMainClick(Sender: TObject);
    procedure btnPurchToggleDaybookQuotesClick(Sender: TObject);
    procedure btnPurchToggleDaybookAutoClick(Sender: TObject);
    procedure btnPurchToggleDaybookHistClick(Sender: TObject);
    procedure btnPurchToggleDaybookOrdersClick(Sender: TObject);
    procedure btnPurchToggleDaybookOrderHistClick(Sender: TObject);
    procedure btnNomToggleDaybookMainClick(Sender: TObject);
    procedure btnNomToggleDaybookAutoClick(Sender: TObject);
    procedure btnNomToggleDaybookHistClick(Sender: TObject);
    procedure btnToggleJobDbkPrepostClick(Sender: TObject);
    procedure btnToggleJobDbkTimesheetsClick(Sender: TObject);
    procedure btnToggleJobDbkTSheetHistClick(Sender: TObject);
    procedure btnToggleJobDbkPurchAppsClick(Sender: TObject);
    procedure btnToggleJobDbkPurchAppHistClick(Sender: TObject);
    procedure btnToggleJobDbkSalesAppsClick(Sender: TObject);
    procedure btnToggleJobDbkSalesAppHistClick(Sender: TObject);
    procedure btnToggleJobDbkPLRetentClick(Sender: TObject);
    procedure btnToggleJobDbkSLRetentClick(Sender: TObject);
    procedure btnToggleStockMainClick(Sender: TObject);
    procedure btnToggleStockDefsClick(Sender: TObject);
    procedure btnToggleStockVatWebClick(Sender: TObject);
    procedure btnToggleStockWOPClick(Sender: TObject);
    procedure btnToggleStockReturnsClick(Sender: TObject);
    procedure btnToggleStockNotesClick(Sender: TObject);
    procedure btnToggleStockQtyBreaksClick(Sender: TObject);
    procedure btnToggleStockMultiBuyClick(Sender: TObject);
    procedure btnToggleStockLedgerClick(Sender: TObject);
    procedure btnToggleStockValueClick(Sender: TObject);
    procedure btnToggleStockBuildClick(Sender: TObject);
    procedure btnToggleStockSerialClick(Sender: TObject);
    procedure btnToggleStockBinsClick(Sender: TObject);
    procedure btnToggleSalesSalesClick(Sender: TObject);
    procedure btnToggleSalesPurchClick(Sender: TObject);
    procedure btnToggleSalesSalesViewClick(Sender: TObject);
    procedure btnToggleSalesPurchViewClick(Sender: TObject);
    procedure btnToggleStkAdjEditClick(Sender: TObject);
    procedure btnToggleStkAdjViewClick(Sender: TObject);
    procedure btnToggleWOREditClick(Sender: TObject);
    procedure btnToggleWORViewClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure chkChangedClick(Sender: TObject);
    procedure btnToggleTraderListClick(Sender: TObject);
    procedure btnToggleCustSuppLedgerClick(Sender: TObject);
    procedure btnToggleJobRecordClick(Sender: TObject);
    procedure btnToggleAllDaybookClick(Sender: TObject);
    procedure btnToggleJobDaybookClick(Sender: TObject);
    procedure btnToggleStockClick(Sender: TObject);
    procedure btnToggleSalesClick(Sender: TObject);
    procedure btnToggleStockAdjustClick(Sender: TObject);
    procedure btnToggleWORClick(Sender: TObject);
    procedure btnToggleEverythingClick(Sender: TObject);
    procedure btnRandomCustSuppClick(Sender: TObject);
    procedure btnRandomCustSuppLedgerClick(Sender: TObject);
    procedure btnRandomJobRecClick(Sender: TObject);
    procedure btnRandomDaybookClick(Sender: TObject);
    procedure btnRandomJobDbkClick(Sender: TObject);
    procedure btnRandomStockClick(Sender: TObject);
    procedure btnRandomSalesClick(Sender: TObject);
    procedure btnRandomStkAdjClick(Sender: TObject);
    procedure btnRandomWORClick(Sender: TObject);
    procedure btnTraderAllOffClick(Sender: TObject);
    procedure btnLedgerAllOffClick(Sender: TObject);
    procedure btnJobRecAllOffClick(Sender: TObject);
    procedure btnDbkAllOffClick(Sender: TObject);
    procedure btnJobDbkAllOffClick(Sender: TObject);
    procedure btnStockAllOffClick(Sender: TObject);
    procedure btnSalesAllOffClick(Sender: TObject);
    procedure btnStkAdjAllOffClick(Sender: TObject);
    procedure btnWORAllOffClick(Sender: TObject);
    procedure btnWORToggleDaybookMainClick(Sender: TObject);
    procedure btnWORToggleDaybookHistClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEnablecustomButtons: TfrmEnablecustomButtons;

implementation

{$R *.dfm}

Uses CustWinU, HandlerU;

procedure TfrmEnablecustomButtons.btnSetHookPointStatusClick(Sender: TObject);

  //------------------------------

  Function CalcHandlerStatus (Const Checked : Boolean) : Byte;
  Begin // CalcHandlerStatus
    If Checked Then
      Result := 1   // Enabled
    Else
      Result := 0;  // Disabled
  End; // CalcHandlerStatus

  //------------------------------

begin
  // 21/01/2013  PKR  ABSEXCH-13449 - Extend availability of custom buttons
  // Trader List (CustLst2.pas)
  // Customer List                   Base+1000
  CustomHandlersRef.SetHandlerStatus(wiAccount,  11, CalcHandlerStatus(chkCustLst1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiAccount,  12, CalcHandlerStatus(chkCustLst2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiAccount, 141, CalcHandlerStatus(chkCustLst3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiAccount, 142, CalcHandlerStatus(chkCustLst4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiAccount, 143, CalcHandlerStatus(chkCustLst5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiAccount, 144, CalcHandlerStatus(chkCustLst6.Checked));
  
  // Suppliers List
  CustomHandlersRef.SetHandlerStatus(wiAccount,  21, CalcHandlerStatus(chkSuppLst1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiAccount,  22, CalcHandlerStatus(chkSuppLst2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiAccount, 151, CalcHandlerStatus(chkSuppLst3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiAccount, 152, CalcHandlerStatus(chkSuppLst4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiAccount, 153, CalcHandlerStatus(chkSuppLst5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiAccount, 154, CalcHandlerStatus(chkSuppLst6.Checked));

  //----------------------------------------------------------------------------
  // Customer/Supplier Ledger (custr3u.pas)
  // Customer ledger
  CustomHandlersRef.SetHandlerStatus(wiAccount, 120, CalcHandlerStatus(chkCustLedger1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiAccount, 121, CalcHandlerStatus(chkCustLedger2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiAccount, 145, CalcHandlerStatus(chkCustLedger3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiAccount, 146, CalcHandlerStatus(chkCustLedger4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiAccount, 147, CalcHandlerStatus(chkCustLedger5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiAccount, 148, CalcHandlerStatus(chkCustLedger6.Checked));
  
  // Supplier Ledger
  CustomHandlersRef.SetHandlerStatus(wiAccount, 130, CalcHandlerStatus(chkSuppLedger1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiAccount, 131, CalcHandlerStatus(chkSuppLedger2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiAccount, 155, CalcHandlerStatus(chkSuppLedger3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiAccount, 156, CalcHandlerStatus(chkSuppLedger4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiAccount, 157, CalcHandlerStatus(chkSuppLedger5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiAccount, 158, CalcHandlerStatus(chkSuppLedger6.Checked));
  
  //----------------------------------------------------------------------------
  // Job Records (jobmn2u.pas)
  // --- Main Tab ----
  CustomHandlersRef.SetHandlerStatus(wiJobRec,  10, CalcHandlerStatus(chkJobMain1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec,  20, CalcHandlerStatus(chkJobMain2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 140, CalcHandlerStatus(chkJobMain3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 150, CalcHandlerStatus(chkJobMain4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 160, CalcHandlerStatus(chkJobMain5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 170, CalcHandlerStatus(chkJobMain6.Checked));
  // --- Notes Tab ----
  CustomHandlersRef.SetHandlerStatus(wiJobRec,  11, CalcHandlerStatus(chkJobNotes1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec,  21, CalcHandlerStatus(chkJobNotes2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 141, CalcHandlerStatus(chkJobNotes3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 151, CalcHandlerStatus(chkJobNotes4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 161, CalcHandlerStatus(chkJobNotes5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 171, CalcHandlerStatus(chkJobNotes6.Checked));
  // --- Ledger Tab ----
  CustomHandlersRef.SetHandlerStatus(wiJobRec,  12, CalcHandlerStatus(chkJobLedger1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec,  22, CalcHandlerStatus(chkJobLedger2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 142, CalcHandlerStatus(chkJobLedger3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 152, CalcHandlerStatus(chkJobLedger4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 162, CalcHandlerStatus(chkJobLedger5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 172, CalcHandlerStatus(chkJobLedger6.Checked));
  // --- Purchase Retentions Tab ---
  CustomHandlersRef.SetHandlerStatus(wiJobRec,  13, CalcHandlerStatus(chkJobPurchRet1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec,  23, CalcHandlerStatus(chkJobPurchRet2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 143, CalcHandlerStatus(chkJobPurchRet3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 153, CalcHandlerStatus(chkJobPurchRet4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 163, CalcHandlerStatus(chkJobPurchRet5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 173, CalcHandlerStatus(chkJobPurchRet6.Checked));
  // --- Sales Retentions Tab ----
  // Not sure if this section is needed.  PKR.
  CustomHandlersRef.SetHandlerStatus(wiJobRec,  14, CalcHandlerStatus(chkJobSalesRet1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec,  24, CalcHandlerStatus(chkJobSalesRet2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 144, CalcHandlerStatus(chkJobSalesRet3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 154, CalcHandlerStatus(chkJobSalesRet4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 164, CalcHandlerStatus(chkJobSalesRet5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 174, CalcHandlerStatus(chkJobSalesRet6.Checked));

  //----------------------------------------------------------------------------
  // Sales Daybook Custom Buttons  (daybk2.pas)
  // --- Main Tab ----
  CustomHandlersRef.SetHandlerStatus(wiTransaction,  10, CalcHandlerStatus(chkSalesDBkMain1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction,  20, CalcHandlerStatus(chkSalesDBkMain2.Checked));
  // 21/01/2013  PKR  ABSEXCH-13449 - Extend availability of custom buttons
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 361, CalcHandlerStatus(chkSalesDBkMain3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 371, CalcHandlerStatus(chkSalesDBkMain4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 381, CalcHandlerStatus(chkSalesDBkMain5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 391, CalcHandlerStatus(chkSalesDBkMain6.Checked));
  // --- Quotes Tab ----
  CustomHandlersRef.SetHandlerStatus(wiTransaction,  11, CalcHandlerStatus(chkSalesDBkQuotes1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction,  21, CalcHandlerStatus(chkSalesDBkQuotes2.Checked));
  // 21/01/2013  PKR  ABSEXCH-13449 - Extend availability of custom buttons
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 362, CalcHandlerStatus(chkSalesDBkQuotes3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 372, CalcHandlerStatus(chkSalesDBkQuotes4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 382, CalcHandlerStatus(chkSalesDBkQuotes5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 392, CalcHandlerStatus(chkSalesDBkQuotes6.Checked));
  // --- Auto Tab ----
  CustomHandlersRef.SetHandlerStatus(wiTransaction,  12, CalcHandlerStatus(chkSalesDBkAuto1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction,  22, CalcHandlerStatus(chkSalesDBkAuto2.Checked));
  // 21/01/2013  PKR  ABSEXCH-13449 - Extend availability of custom buttons
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 363, CalcHandlerStatus(chkSalesDBkAuto3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 373, CalcHandlerStatus(chkSalesDBkAuto4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 383, CalcHandlerStatus(chkSalesDBkAuto5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 393, CalcHandlerStatus(chkSalesDBkAuto6.Checked));
  // --- History Tab ----
  CustomHandlersRef.SetHandlerStatus(wiTransaction,  13, CalcHandlerStatus(chkSalesDBkHistory1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction,  23, CalcHandlerStatus(chkSalesDBkHistory2.Checked));
  // 21/01/2013  PKR  ABSEXCH-13449 - Extend availability of custom buttons
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 364, CalcHandlerStatus(chkSalesDBkHistory3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 374, CalcHandlerStatus(chkSalesDBkHistory4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 384, CalcHandlerStatus(chkSalesDBkHistory5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 394, CalcHandlerStatus(chkSalesDBkHistory6.Checked));
  // --- Orders Tab ----
  CustomHandlersRef.SetHandlerStatus(wiTransaction,  14, CalcHandlerStatus(chkSalesDBkOrders1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction,  24, CalcHandlerStatus(chkSalesDBkOrders2.Checked));
  // 21/01/2013  PKR  ABSEXCH-13449 - Extend availability of custom buttons
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 365, CalcHandlerStatus(chkSalesDBkOrders3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 375, CalcHandlerStatus(chkSalesDBkOrders4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 385, CalcHandlerStatus(chkSalesDBkOrders5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 395, CalcHandlerStatus(chkSalesDBkOrders6.Checked));
  // --- Order History Tab ----
  CustomHandlersRef.SetHandlerStatus(wiTransaction,  15, CalcHandlerStatus(chkSalesDBkOrderHistory1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction,  25, CalcHandlerStatus(chkSalesDBkOrderHistory2.Checked));
  // 21/01/2013  PKR  ABSEXCH-13449 - Extend availability of custom buttons
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 366, CalcHandlerStatus(chkSalesDBkOrderHistory3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 376, CalcHandlerStatus(chkSalesDBkOrderHistory4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 386, CalcHandlerStatus(chkSalesDBkOrderHistory5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 396, CalcHandlerStatus(chkSalesDBkOrderHistory6.Checked));

  // Purchase Daybook Custom Buttons  (daybk2.pas)
  // --- Main Tab ----
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 110, CalcHandlerStatus(chkPurchDBkMain1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 120, CalcHandlerStatus(chkPurchDBkMain2.Checked));
  // 21/01/2013  PKR  ABSEXCH-13449 - Extend availability of custom buttons
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 401, CalcHandlerStatus(chkPurchDBkMain3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 411, CalcHandlerStatus(chkPurchDBkMain4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 421, CalcHandlerStatus(chkPurchDBkMain5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 431, CalcHandlerStatus(chkPurchDBkMain6.Checked));
  // --- Quotes Tab ----
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 111, CalcHandlerStatus(chkPurchDBkQuotes1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 121, CalcHandlerStatus(chkPurchDBkQuotes2.Checked));
  // 21/01/2013  PKR  ABSEXCH-13449 - Extend availability of custom buttons
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 402, CalcHandlerStatus(chkPurchDBkQuotes3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 412, CalcHandlerStatus(chkPurchDBkQuotes4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 422, CalcHandlerStatus(chkPurchDBkQuotes5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 432, CalcHandlerStatus(chkPurchDBkQuotes6.Checked));
  // --- Auto Tab ----
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 112, CalcHandlerStatus(chkPurchDBkAuto1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 122, CalcHandlerStatus(chkPurchDBkAuto2.Checked));
  // 21/01/2013  PKR  ABSEXCH-13449 - Extend availability of custom buttons
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 403, CalcHandlerStatus(chkPurchDBkAuto3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 413, CalcHandlerStatus(chkPurchDBkAuto4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 423, CalcHandlerStatus(chkPurchDBkAuto5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 433, CalcHandlerStatus(chkPurchDBkAuto6.Checked));
  // --- History Tab ----
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 113, CalcHandlerStatus(chkPurchDBkHistory1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 123, CalcHandlerStatus(chkPurchDBkHistory2.Checked));
  // 21/01/2013  PKR  ABSEXCH-13449 - Extend availability of custom buttons
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 404, CalcHandlerStatus(chkPurchDBkHistory3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 414, CalcHandlerStatus(chkPurchDBkHistory4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 424, CalcHandlerStatus(chkPurchDBkHistory5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 434, CalcHandlerStatus(chkPurchDBkHistory6.Checked));
  // --- Orders Tab ----
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 114, CalcHandlerStatus(chkPurchDBkOrders1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 124, CalcHandlerStatus(chkPurchDBkOrders2.Checked));
  // 21/01/2013  PKR  ABSEXCH-13449 - Extend availability of custom buttons
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 405, CalcHandlerStatus(chkPurchDBkOrders3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 415, CalcHandlerStatus(chkPurchDBkOrders4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 425, CalcHandlerStatus(chkPurchDBkOrders5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 435, CalcHandlerStatus(chkPurchDBkOrders6.Checked));
  // --- Order History Tab ----
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 115, CalcHandlerStatus(chkPurchDBkOrderHistory1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 125, CalcHandlerStatus(chkPurchDBkOrderHistory2.Checked));
  // 21/01/2013  PKR  ABSEXCH-13449 - Extend availability of custom buttons
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 406, CalcHandlerStatus(chkPurchDBkOrderHistory3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 416, CalcHandlerStatus(chkPurchDBkOrderHistory4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 426, CalcHandlerStatus(chkPurchDBkOrderHistory5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 436, CalcHandlerStatus(chkPurchDBkOrderHistory6.Checked));

  // Nominal Daybook Custom Buttons  (daybk2.pas)
  // --- Main Tab ----
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 301, CalcHandlerStatus(chkNomDBkMain1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 311, CalcHandlerStatus(chkNomDBkMain2.Checked));
  // 21/01/2013  PKR  ABSEXCH-13449 - Extend availability of custom buttons
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 321, CalcHandlerStatus(chkNomDBkMain3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 331, CalcHandlerStatus(chkNomDBkMain4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 341, CalcHandlerStatus(chkNomDBkMain5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 351, CalcHandlerStatus(chkNomDBkMain6.Checked));
  // --- Auto Tab ----
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 303, CalcHandlerStatus(chkNomDBkAuto1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 313, CalcHandlerStatus(chkNomDBkAuto2.Checked));
  // 21/01/2013  PKR  ABSEXCH-13449 - Extend availability of custom buttons
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 323, CalcHandlerStatus(chkNomDBkAuto3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 333, CalcHandlerStatus(chkNomDBkAuto4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 343, CalcHandlerStatus(chkNomDBkAuto5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 353, CalcHandlerStatus(chkNomDBkAuto6.Checked));
  // --- History Tab ----
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 304, CalcHandlerStatus(chkNomDBkHistory1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 314, CalcHandlerStatus(chkNomDBkHistory2.Checked));
  // 21/01/2013  PKR  ABSEXCH-13449 - Extend availability of custom buttons
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 324, CalcHandlerStatus(chkNomDBkHistory3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 334, CalcHandlerStatus(chkNomDBkHistory4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 344, CalcHandlerStatus(chkNomDBkHistory5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 354, CalcHandlerStatus(chkNomDBkHistory6.Checked));

  //----------------------------------------------------------------------------
  // 21/01/2013  PKR  ABSEXCH-13449 - Extend availability of custom buttons
  // Job Daybook Custom Buttons  (jobdbk2u.pas) : (wiJobRec = EnterpriseBase + 5000)
  // --- Job Pre-Postings Tab ----
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 120, CalcHandlerStatus(chkJobPrePost1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 130, CalcHandlerStatus(chkJobPrePost2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 220, CalcHandlerStatus(chkJobPrePost3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 230, CalcHandlerStatus(chkJobPrePost4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 240, CalcHandlerStatus(chkJobPrePost5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 250, CalcHandlerStatus(chkJobPrePost6.Checked));
  // --- Time Sheets Tab ----
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 121, CalcHandlerStatus(chkJobTimesheets1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 131, CalcHandlerStatus(chkJobTimesheets2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 221, CalcHandlerStatus(chkJobTimesheets3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 231, CalcHandlerStatus(chkJobTimesheets4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 241, CalcHandlerStatus(chkJobTimesheets5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 251, CalcHandlerStatus(chkJobTimesheets6.Checked));
  // --- Time Sheet History Tab ----
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 122, CalcHandlerStatus(chkJobTimesheetHist1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 132, CalcHandlerStatus(chkJobTimesheetHist2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 222, CalcHandlerStatus(chkJobTimesheetHist3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 232, CalcHandlerStatus(chkJobTimesheetHist4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 242, CalcHandlerStatus(chkJobTimesheetHist5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 252, CalcHandlerStatus(chkJobTimesheetHist6.Checked));
  // --- Purchase Apps Tab ----
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 123, CalcHandlerStatus(chkJobPurchApps1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 133, CalcHandlerStatus(chkJobPurchApps2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 223, CalcHandlerStatus(chkJobPurchApps3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 233, CalcHandlerStatus(chkJobPurchApps4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 243, CalcHandlerStatus(chkJobPurchApps5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 253, CalcHandlerStatus(chkJobPurchApps6.Checked));
  // --- Purchase App History Tab ----
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 124, CalcHandlerStatus(chkJobPurchAppHist1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 134, CalcHandlerStatus(chkJobPurchAppHist2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 224, CalcHandlerStatus(chkJobPurchAppHist3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 234, CalcHandlerStatus(chkJobPurchAppHist4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 244, CalcHandlerStatus(chkJobPurchAppHist5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 254, CalcHandlerStatus(chkJobPurchAppHist6.Checked));
  // --- Sales Apps Tab ----
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 125, CalcHandlerStatus(chkJobSalesApps1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 135, CalcHandlerStatus(chkJobSalesApps2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 225, CalcHandlerStatus(chkJobSalesApps3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 235, CalcHandlerStatus(chkJobSalesApps4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 245, CalcHandlerStatus(chkJobSalesApps5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 255, CalcHandlerStatus(chkJobSalesApps6.Checked));
  // --- Sales App History Tab ----
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 126, CalcHandlerStatus(chkJobSalesAppHist1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 136, CalcHandlerStatus(chkJobSalesAppHist2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 226, CalcHandlerStatus(chkJobSalesAppHist3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 236, CalcHandlerStatus(chkJobSalesAppHist4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 246, CalcHandlerStatus(chkJobSalesAppHist5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 256, CalcHandlerStatus(chkJobSalesAppHist6.Checked));
  // --- P/L Retentions Tab ----
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 127, CalcHandlerStatus(chkJobPLRetentions1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 137, CalcHandlerStatus(chkJobPLRetentions2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 227, CalcHandlerStatus(chkJobPLRetentions3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 237, CalcHandlerStatus(chkJobPLRetentions4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 247, CalcHandlerStatus(chkJobPLRetentions5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 257, CalcHandlerStatus(chkJobPLRetentions6.Checked));
  // --- S/L Retentions Tab ----
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 128, CalcHandlerStatus(chkJobSLRetentions1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 138, CalcHandlerStatus(chkJobSLRetentions2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 228, CalcHandlerStatus(chkJobSLRetentions3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 238, CalcHandlerStatus(chkJobSLRetentions4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 248, CalcHandlerStatus(chkJobSLRetentions5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiJobRec, 258, CalcHandlerStatus(chkJobSLRetentions6.Checked));
  
  //----------------------------------------------------------------------------
  // Stock Record Custom Buttons  (stocku.pas)
  // --- Main Tab ----
  CustomHandlersRef.SetHandlerStatus(wiStock,  80, CalcHandlerStatus(chkStockMain1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock,  90, CalcHandlerStatus(chkStockMain2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 221, CalcHandlerStatus(chkStockMain3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 231, CalcHandlerStatus(chkStockMain4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 241, CalcHandlerStatus(chkStockMain5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 251, CalcHandlerStatus(chkStockMain6.Checked));
  // --- Defaults Tab ----
  CustomHandlersRef.SetHandlerStatus(wiStock,  81, CalcHandlerStatus(chkStockDefaults1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock,  91, CalcHandlerStatus(chkStockDefaults2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 222, CalcHandlerStatus(chkStockDefaults3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 232, CalcHandlerStatus(chkStockDefaults4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 242, CalcHandlerStatus(chkStockDefaults5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 252, CalcHandlerStatus(chkStockDefaults6.Checked));
  // --- VAT/Web Tab ----
  CustomHandlersRef.SetHandlerStatus(wiStock,  88, CalcHandlerStatus(chkStockVATWeb1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock,  98, CalcHandlerStatus(chkStockVATWeb2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 229, CalcHandlerStatus(chkStockVATWeb3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 239, CalcHandlerStatus(chkStockVATWeb4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 249, CalcHandlerStatus(chkStockVATWeb5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 259, CalcHandlerStatus(chkStockVATWeb6.Checked));
  // --- WOP Tab ----
  CustomHandlersRef.SetHandlerStatus(wiStock,  87, CalcHandlerStatus(chkStockWOP1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock,  97, CalcHandlerStatus(chkStockWOP2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 228, CalcHandlerStatus(chkStockWOP3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 238, CalcHandlerStatus(chkStockWOP4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 248, CalcHandlerStatus(chkStockWOP5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 258, CalcHandlerStatus(chkStockWOP6.Checked));
  // --- Returns Tab ----
  CustomHandlersRef.SetHandlerStatus(wiStock,  82, CalcHandlerStatus(chkStockReturns1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock,  92, CalcHandlerStatus(chkStockReturns2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 223, CalcHandlerStatus(chkStockReturns3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 233, CalcHandlerStatus(chkStockReturns4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 243, CalcHandlerStatus(chkStockReturns5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 253, CalcHandlerStatus(chkStockReturns6.Checked));
  // --- Notes Tab ----
  //  *** NONE ***
  // --- Qty Breaks Tab ----
  CustomHandlersRef.SetHandlerStatus(wiStock,  83, CalcHandlerStatus(chkStockQtyBreaks1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock,  93, CalcHandlerStatus(chkStockQtyBreaks2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 224, CalcHandlerStatus(chkStockQtyBreaks3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 234, CalcHandlerStatus(chkStockQtyBreaks4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 244, CalcHandlerStatus(chkStockQtyBreaks5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 254, CalcHandlerStatus(chkStockQtyBreaks6.Checked));
  // --- Multi-buy Discount Tab ----
  CustomHandlersRef.SetHandlerStatus(wiStock, 101, CalcHandlerStatus(chkStockMBDiscounts1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 111, CalcHandlerStatus(chkStockMBDiscounts2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 261, CalcHandlerStatus(chkStockMBDiscounts3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 271, CalcHandlerStatus(chkStockMBDiscounts4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 281, CalcHandlerStatus(chkStockMBDiscounts5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 291, CalcHandlerStatus(chkStockMBDiscounts6.Checked));
  // --- Ledger Tab ----
  CustomHandlersRef.SetHandlerStatus(wiStock,  84, CalcHandlerStatus(chkStockLedger1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock,  94, CalcHandlerStatus(chkStockLedger2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 225, CalcHandlerStatus(chkStockLedger3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 235, CalcHandlerStatus(chkStockLedger4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 245, CalcHandlerStatus(chkStockLedger5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 255, CalcHandlerStatus(chkStockLedger6.Checked));
  // --- Value Tab ----
  CustomHandlersRef.SetHandlerStatus(wiStock,  85, CalcHandlerStatus(chkStockValue1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock,  95, CalcHandlerStatus(chkStockValue2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 226, CalcHandlerStatus(chkStockValue3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 236, CalcHandlerStatus(chkStockValue4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 246, CalcHandlerStatus(chkStockValue5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 256, CalcHandlerStatus(chkStockValue6.Checked));
  // --- Build Tab ----
  CustomHandlersRef.SetHandlerStatus(wiStock,  86, CalcHandlerStatus(chkStockBuild1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock,  96, CalcHandlerStatus(chkStockBuild2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 227, CalcHandlerStatus(chkStockBuild3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 237, CalcHandlerStatus(chkStockBuild4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 247, CalcHandlerStatus(chkStockBuild5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 257, CalcHandlerStatus(chkStockBuild6.Checked));
  // --- Serial Tab ----
  CustomHandlersRef.SetHandlerStatus(wiStock,  89, CalcHandlerStatus(chkStockSerial1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock,  99, CalcHandlerStatus(chkStockSerial2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 230, CalcHandlerStatus(chkStockSerial3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 240, CalcHandlerStatus(chkStockSerial4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 250, CalcHandlerStatus(chkStockSerial5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 260, CalcHandlerStatus(chkStockSerial6.Checked));
  // --- Bins Tab ----
  CustomHandlersRef.SetHandlerStatus(wiStock,  89, CalcHandlerStatus(chkStockBins1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock,  99, CalcHandlerStatus(chkStockBins2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 230, CalcHandlerStatus(chkStockBins3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 240, CalcHandlerStatus(chkStockBins4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 250, CalcHandlerStatus(chkStockBins5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiStock, 260, CalcHandlerStatus(chkStockBins6.Checked));

  //----------------------------------------------------------------------------
  // Sales/Purchase Custom Buttons  (saletx2u.pas)
  // --- Sales Edit ----
  CustomHandlersRef.SetHandlerStatus(wiTransaction,  31, CalcHandlerStatus(chkSalesEdit1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction,  32, CalcHandlerStatus(chkSalesEdit2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 441, CalcHandlerStatus(chkSalesEdit3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 442, CalcHandlerStatus(chkSalesEdit4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 443, CalcHandlerStatus(chkSalesEdit5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 444, CalcHandlerStatus(chkSalesEdit6.Checked));
  // --- Sales View ----
  CustomHandlersRef.SetHandlerStatus(wiTransaction,  41, CalcHandlerStatus(chkPurchEdit1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction,  42, CalcHandlerStatus(chkPurchEdit2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 445, CalcHandlerStatus(chkPurchEdit3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 446, CalcHandlerStatus(chkPurchEdit4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 447, CalcHandlerStatus(chkPurchEdit5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 448, CalcHandlerStatus(chkPurchEdit6.Checked));
  // --- Purchase Edit ----
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 131, CalcHandlerStatus(chkSalesView1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 132, CalcHandlerStatus(chkSalesView2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 541, CalcHandlerStatus(chkSalesView3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 542, CalcHandlerStatus(chkSalesView4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 543, CalcHandlerStatus(chkSalesView5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 544, CalcHandlerStatus(chkSalesView6.Checked));
  // --- Purchase View ----
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 141, CalcHandlerStatus(chkPurchView1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 142, CalcHandlerStatus(chkPurchView2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 545, CalcHandlerStatus(chkPurchView3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 546, CalcHandlerStatus(chkPurchView4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 547, CalcHandlerStatus(chkPurchView5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 548, CalcHandlerStatus(chkPurchView6.Checked));

  //----------------------------------------------------------------------------
  // Stock Custom Buttons  (stkadju.pas)
  // Stock Edit 
  CustomHandlersRef.SetHandlerStatus(wiTransaction,  38, CalcHandlerStatus(chkStockEdit1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction,  39, CalcHandlerStatus(chkStockEdit2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 451, CalcHandlerStatus(chkStockEdit3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 452, CalcHandlerStatus(chkStockEdit4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 453, CalcHandlerStatus(chkStockEdit5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 454, CalcHandlerStatus(chkStockEdit6.Checked));
  // Stock view
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 138, CalcHandlerStatus(chkStockView1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 139, CalcHandlerStatus(chkStockView2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 551, CalcHandlerStatus(chkStockView3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 552, CalcHandlerStatus(chkStockView4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 553, CalcHandlerStatus(chkStockView5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 554, CalcHandlerStatus(chkStockView6.Checked));
  
  //----------------------------------------------------------------------------
  // Works Order Custom Buttons  (wordoc2u.pas)
  // Works Order Edit 
  CustomHandlersRef.SetHandlerStatus(wiTransaction,  43, CalcHandlerStatus(chkWOREdit1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction,  44, CalcHandlerStatus(chkWOREdit2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 455, CalcHandlerStatus(chkWOREdit3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 456, CalcHandlerStatus(chkWOREdit4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 457, CalcHandlerStatus(chkWOREdit5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 458, CalcHandlerStatus(chkWOREdit6.Checked));
  // Works Order view
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 143, CalcHandlerStatus(chkWORView1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 144, CalcHandlerStatus(chkWORView2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 555, CalcHandlerStatus(chkWORView3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 556, CalcHandlerStatus(chkWORView4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 557, CalcHandlerStatus(chkWORView5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 558, CalcHandlerStatus(chkWORView6.Checked));

  //----------------------------------------------------------------------------
  // PKR. 04/11/2015. Add Custom Buttons to Works Order Daybook.
  // Works Order Daybook Custom Buttons  (daybk2.pas)
  // Works Order Daybook Main
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 561, CalcHandlerStatus(chkWORDbkMain1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 562, CalcHandlerStatus(chkWORDbkMain2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 563, CalcHandlerStatus(chkWORDbkMain3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 564, CalcHandlerStatus(chkWORDbkMain4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 565, CalcHandlerStatus(chkWORDbkMain5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 566, CalcHandlerStatus(chkWORDbkMain6.Checked));
  // Works Order Daybook History
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 571, CalcHandlerStatus(chkWORDbkHistory1.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 572, CalcHandlerStatus(chkWORDbkHistory2.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 573, CalcHandlerStatus(chkWORDbkHistory3.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 574, CalcHandlerStatus(chkWORDbkHistory4.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 575, CalcHandlerStatus(chkWORDbkHistory5.Checked));
  CustomHandlersRef.SetHandlerStatus(wiTransaction, 576, CalcHandlerStatus(chkWORDbkHistory6.Checked));

  // Having applied all the changes, restore normality
  controlPanel.Color := clBtnFace;
end;

procedure TfrmEnablecustomButtons.btnToggleCustListClick(Sender: TObject);
begin
  chkCustLst1.Checked := not chkCustLst1.Checked;
  chkCustLst2.Checked := not chkCustLst2.Checked;
  chkCustLst3.Checked := not chkCustLst3.Checked;
  chkCustLst4.Checked := not chkCustLst4.Checked;
  chkCustLst5.Checked := not chkCustLst5.Checked;
  chkCustLst6.Checked := not chkCustLst6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleSuppListClick(Sender: TObject);
begin
  chkSuppLst1.Checked := not chkSuppLst1.Checked;
  chkSuppLst2.Checked := not chkSuppLst2.Checked;
  chkSuppLst3.Checked := not chkSuppLst3.Checked;
  chkSuppLst4.Checked := not chkSuppLst4.Checked;
  chkSuppLst5.Checked := not chkSuppLst5.Checked;
  chkSuppLst6.Checked := not chkSuppLst6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleCustLedgerClick(Sender: TObject);
begin
  chkCustLedger1.Checked := not chkCustLedger1.Checked;
  chkCustLedger2.Checked := not chkCustLedger2.Checked;
  chkCustLedger3.Checked := not chkCustLedger3.Checked;
  chkCustLedger4.Checked := not chkCustLedger4.Checked;
  chkCustLedger5.Checked := not chkCustLedger5.Checked;
  chkCustLedger6.Checked := not chkCustLedger6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleSuppLedgerClick(Sender: TObject);
begin
  chkSuppLedger1.Checked := not chkSuppLedger1.Checked;
  chkSuppLedger2.Checked := not chkSuppLedger2.Checked;
  chkSuppLedger3.Checked := not chkSuppLedger3.Checked;
  chkSuppLedger4.Checked := not chkSuppLedger4.Checked;
  chkSuppLedger5.Checked := not chkSuppLedger5.Checked;
  chkSuppLedger6.Checked := not chkSuppLedger6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleJobMainClick(Sender: TObject);
begin
  chkJobMain1.Checked := not chkJobMain1.Checked;
  chkJobMain2.Checked := not chkJobMain2.Checked;
  chkJobMain3.Checked := not chkJobMain3.Checked;
  chkJobMain4.Checked := not chkJobMain4.Checked;
  chkJobMain5.Checked := not chkJobMain5.Checked;
  chkJobMain6.Checked := not chkJobMain6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleJobNotesClick(Sender: TObject);
begin
  chkJobNotes1.Checked := not chkJobNotes1.Checked;
  chkJobNotes2.Checked := not chkJobNotes2.Checked;
  chkJobNotes3.Checked := not chkJobNotes3.Checked;
  chkJobNotes4.Checked := not chkJobNotes4.Checked;
  chkJobNotes5.Checked := not chkJobNotes5.Checked;
  chkJobNotes6.Checked := not chkJobNotes6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleJobLedgerClick(Sender: TObject);
begin
  chkJobLedger1.Checked := not chkJobLedger1.Checked;
  chkJobLedger2.Checked := not chkJobLedger2.Checked;
  chkJobLedger3.Checked := not chkJobLedger3.Checked;
  chkJobLedger4.Checked := not chkJobLedger4.Checked;
  chkJobLedger5.Checked := not chkJobLedger5.Checked;
  chkJobLedger6.Checked := not chkJobLedger6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleJobPurchRetClick(Sender: TObject);
begin
  chkJobPurchRet1.Checked := not chkJobPurchRet1.Checked;
  chkJobPurchRet2.Checked := not chkJobPurchRet2.Checked;
  chkJobPurchRet3.Checked := not chkJobPurchRet3.Checked;
  chkJobPurchRet4.Checked := not chkJobPurchRet4.Checked;
  chkJobPurchRet5.Checked := not chkJobPurchRet5.Checked;
  chkJobPurchRet6.Checked := not chkJobPurchRet6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleJobRetClick(Sender: TObject);
begin
  chkJobSalesRet1.Checked := not chkJobSalesRet1.Checked;
  chkJobSalesRet2.Checked := not chkJobSalesRet2.Checked;
  chkJobSalesRet3.Checked := not chkJobSalesRet3.Checked;
  chkJobSalesRet4.Checked := not chkJobSalesRet4.Checked;
  chkJobSalesRet5.Checked := not chkJobSalesRet5.Checked;
  chkJobSalesRet6.Checked := not chkJobSalesRet6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleDaybookMainClick(Sender: TObject);
begin
  chkSalesDBkMain1.Checked := not chkSalesDBkMain1.Checked;
  chkSalesDBkMain2.Checked := not chkSalesDBkMain2.Checked;
  chkSalesDBkMain3.Checked := not chkSalesDBkMain3.Checked;
  chkSalesDBkMain4.Checked := not chkSalesDBkMain4.Checked;
  chkSalesDBkMain5.Checked := not chkSalesDBkMain5.Checked;
  chkSalesDBkMain6.Checked := not chkSalesDBkMain6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleDaybookQuotesClick(Sender: TObject);
begin
  chkSalesDBkQuotes1.Checked := not chkSalesDBkQuotes1.Checked;
  chkSalesDBkQuotes2.Checked := not chkSalesDBkQuotes2.Checked;
  chkSalesDBkQuotes3.Checked := not chkSalesDBkQuotes3.Checked;
  chkSalesDBkQuotes4.Checked := not chkSalesDBkQuotes4.Checked;
  chkSalesDBkQuotes5.Checked := not chkSalesDBkQuotes5.Checked;
  chkSalesDBkQuotes6.Checked := not chkSalesDBkQuotes6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleDaybookAutoClick(Sender: TObject);
begin
  chkSalesDBkAuto1.Checked := not chkSalesDBkAuto1.Checked;
  chkSalesDBkAuto2.Checked := not chkSalesDBkAuto2.Checked;
  chkSalesDBkAuto3.Checked := not chkSalesDBkAuto3.Checked;
  chkSalesDBkAuto4.Checked := not chkSalesDBkAuto4.Checked;
  chkSalesDBkAuto5.Checked := not chkSalesDBkAuto5.Checked;
  chkSalesDBkAuto6.Checked := not chkSalesDBkAuto6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleDaybookHistoryClick(Sender: TObject);
begin
  chkSalesDBkHistory1.Checked := not chkSalesDBkHistory1.Checked;
  chkSalesDBkHistory2.Checked := not chkSalesDBkHistory2.Checked;
  chkSalesDBkHistory3.Checked := not chkSalesDBkHistory3.Checked;
  chkSalesDBkHistory4.Checked := not chkSalesDBkHistory4.Checked;
  chkSalesDBkHistory5.Checked := not chkSalesDBkHistory5.Checked;
  chkSalesDBkHistory6.Checked := not chkSalesDBkHistory6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleDaybookOrdersClick(Sender: TObject);
begin
  chkSalesDBkOrders1.Checked := not chkSalesDBkOrders1.Checked;
  chkSalesDBkOrders2.Checked := not chkSalesDBkOrders2.Checked;
  chkSalesDBkOrders3.Checked := not chkSalesDBkOrders3.Checked;
  chkSalesDBkOrders4.Checked := not chkSalesDBkOrders4.Checked;
  chkSalesDBkOrders5.Checked := not chkSalesDBkOrders5.Checked;
  chkSalesDBkOrders6.Checked := not chkSalesDBkOrders6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleDaybookOrderHistClick(Sender: TObject);
begin
  chkSalesDBkOrderHistory1.Checked := not chkSalesDBkOrderHistory1.Checked;
  chkSalesDBkOrderHistory2.Checked := not chkSalesDBkOrderHistory2.Checked;
  chkSalesDBkOrderHistory3.Checked := not chkSalesDBkOrderHistory3.Checked;
  chkSalesDBkOrderHistory4.Checked := not chkSalesDBkOrderHistory4.Checked;
  chkSalesDBkOrderHistory5.Checked := not chkSalesDBkOrderHistory5.Checked;
  chkSalesDBkOrderHistory6.Checked := not chkSalesDBkOrderHistory6.Checked;
end;

procedure TfrmEnablecustomButtons.btnPurchToggleDaybookMainClick(Sender: TObject);
begin
  chkPurchDBkMain1.Checked := not chkPurchDBkMain1.Checked;
  chkPurchDBkMain2.Checked := not chkPurchDBkMain2.Checked;
  chkPurchDBkMain3.Checked := not chkPurchDBkMain3.Checked;
  chkPurchDBkMain4.Checked := not chkPurchDBkMain4.Checked;
  chkPurchDBkMain5.Checked := not chkPurchDBkMain5.Checked;
  chkPurchDBkMain6.Checked := not chkPurchDBkMain6.Checked;
end;

procedure TfrmEnablecustomButtons.btnPurchToggleDaybookQuotesClick(Sender: TObject);
begin
  chkPurchDBkQuotes1.Checked := not chkPurchDBkQuotes1.Checked;
  chkPurchDBkQuotes2.Checked := not chkPurchDBkQuotes2.Checked;
  chkPurchDBkQuotes3.Checked := not chkPurchDBkQuotes3.Checked;
  chkPurchDBkQuotes4.Checked := not chkPurchDBkQuotes4.Checked;
  chkPurchDBkQuotes5.Checked := not chkPurchDBkQuotes5.Checked;
  chkPurchDBkQuotes6.Checked := not chkPurchDBkQuotes6.Checked;
end;

procedure TfrmEnablecustomButtons.btnPurchToggleDaybookAutoClick(Sender: TObject);
begin
  chkPurchDBkAuto1.Checked := not chkPurchDBkAuto1.Checked;
  chkPurchDBkAuto2.Checked := not chkPurchDBkAuto2.Checked;
  chkPurchDBkAuto3.Checked := not chkPurchDBkAuto3.Checked;
  chkPurchDBkAuto4.Checked := not chkPurchDBkAuto4.Checked;
  chkPurchDBkAuto5.Checked := not chkPurchDBkAuto5.Checked;
  chkPurchDBkAuto6.Checked := not chkPurchDBkAuto6.Checked;
end;

procedure TfrmEnablecustomButtons.btnPurchToggleDaybookHistClick(Sender: TObject);
begin
  chkPurchDBkHistory1.Checked := not chkPurchDBkHistory1.Checked;
  chkPurchDBkHistory2.Checked := not chkPurchDBkHistory2.Checked;
  chkPurchDBkHistory3.Checked := not chkPurchDBkHistory3.Checked;
  chkPurchDBkHistory4.Checked := not chkPurchDBkHistory4.Checked;
  chkPurchDBkHistory5.Checked := not chkPurchDBkHistory5.Checked;
  chkPurchDBkHistory6.Checked := not chkPurchDBkHistory6.Checked;
end;

procedure TfrmEnablecustomButtons.btnPurchToggleDaybookOrdersClick(Sender: TObject);
begin
  chkPurchDBkOrders1.Checked := not chkPurchDBkOrders1.Checked;
  chkPurchDBkOrders2.Checked := not chkPurchDBkOrders2.Checked;
  chkPurchDBkOrders3.Checked := not chkPurchDBkOrders3.Checked;
  chkPurchDBkOrders4.Checked := not chkPurchDBkOrders4.Checked;
  chkPurchDBkOrders5.Checked := not chkPurchDBkOrders5.Checked;
  chkPurchDBkOrders6.Checked := not chkPurchDBkOrders6.Checked;
end;

procedure TfrmEnablecustomButtons.btnPurchToggleDaybookOrderHistClick(Sender: TObject);
begin
  chkPurchDBkOrderHistory1.Checked := not chkPurchDBkOrderHistory1.Checked;
  chkPurchDBkOrderHistory2.Checked := not chkPurchDBkOrderHistory2.Checked;
  chkPurchDBkOrderHistory3.Checked := not chkPurchDBkOrderHistory3.Checked;
  chkPurchDBkOrderHistory4.Checked := not chkPurchDBkOrderHistory4.Checked;
  chkPurchDBkOrderHistory5.Checked := not chkPurchDBkOrderHistory5.Checked;
  chkPurchDBkOrderHistory6.Checked := not chkPurchDBkOrderHistory6.Checked;
end;

procedure TfrmEnablecustomButtons.btnNomToggleDaybookMainClick(Sender: TObject);
begin
  chkNomDBkMain1.Checked := not chkNomDBkMain1.Checked;
  chkNomDBkMain2.Checked := not chkNomDBkMain2.Checked;
  chkNomDBkMain3.Checked := not chkNomDBkMain3.Checked;
  chkNomDBkMain4.Checked := not chkNomDBkMain4.Checked;
  chkNomDBkMain5.Checked := not chkNomDBkMain5.Checked;
  chkNomDBkMain6.Checked := not chkNomDBkMain6.Checked;
end;

procedure TfrmEnablecustomButtons.btnNomToggleDaybookAutoClick(Sender: TObject);
begin
  chkNomDBkAuto1.Checked := not chkNomDBkAuto1.Checked;
  chkNomDBkAuto2.Checked := not chkNomDBkAuto2.Checked;
  chkNomDBkAuto3.Checked := not chkNomDBkAuto3.Checked;
  chkNomDBkAuto4.Checked := not chkNomDBkAuto4.Checked;
  chkNomDBkAuto5.Checked := not chkNomDBkAuto5.Checked;
  chkNomDBkAuto6.Checked := not chkNomDBkAuto6.Checked;
end;

procedure TfrmEnablecustomButtons.btnNomToggleDaybookHistClick(Sender: TObject);
begin
  chkNomDBkHistory1.Checked := not chkNomDBkHistory1.Checked;
  chkNomDBkHistory2.Checked := not chkNomDBkHistory2.Checked;
  chkNomDBkHistory3.Checked := not chkNomDBkHistory3.Checked;
  chkNomDBkHistory4.Checked := not chkNomDBkHistory4.Checked;
  chkNomDBkHistory5.Checked := not chkNomDBkHistory5.Checked;
  chkNomDBkHistory6.Checked := not chkNomDBkHistory6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleJobDbkPrepostClick(Sender: TObject);
begin
  chkJobPrePost1.Checked := not chkJobPrePost1.Checked;
  chkJobPrePost2.Checked := not chkJobPrePost2.Checked;
  chkJobPrePost3.Checked := not chkJobPrePost3.Checked;
  chkJobPrePost4.Checked := not chkJobPrePost4.Checked;
  chkJobPrePost5.Checked := not chkJobPrePost5.Checked;
  chkJobPrePost6.Checked := not chkJobPrePost6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleJobDbkTimesheetsClick(Sender: TObject);
begin
  chkJobTimesheets1.Checked := not chkJobTimesheets1.Checked;
  chkJobTimesheets2.Checked := not chkJobTimesheets2.Checked;
  chkJobTimesheets3.Checked := not chkJobTimesheets3.Checked;
  chkJobTimesheets4.Checked := not chkJobTimesheets4.Checked;
  chkJobTimesheets5.Checked := not chkJobTimesheets5.Checked;
  chkJobTimesheets6.Checked := not chkJobTimesheets6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleJobDbkTSheetHistClick(Sender: TObject);
begin
  chkJobTimesheetHist1.Checked := not chkJobTimesheetHist1.Checked;
  chkJobTimesheetHist2.Checked := not chkJobTimesheetHist2.Checked;
  chkJobTimesheetHist3.Checked := not chkJobTimesheetHist3.Checked;
  chkJobTimesheetHist4.Checked := not chkJobTimesheetHist4.Checked;
  chkJobTimesheetHist5.Checked := not chkJobTimesheetHist5.Checked;
  chkJobTimesheetHist6.Checked := not chkJobTimesheetHist6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleJobDbkPurchAppsClick(Sender: TObject);
begin
  chkJobPurchApps1.Checked := not chkJobPurchApps1.Checked;
  chkJobPurchApps2.Checked := not chkJobPurchApps2.Checked;
  chkJobPurchApps3.Checked := not chkJobPurchApps3.Checked;
  chkJobPurchApps4.Checked := not chkJobPurchApps4.Checked;
  chkJobPurchApps5.Checked := not chkJobPurchApps5.Checked;
  chkJobPurchApps6.Checked := not chkJobPurchApps6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleJobDbkPurchAppHistClick(Sender: TObject);
begin
  chkJobPurchAppHist1.Checked := not chkJobPurchAppHist1.Checked;
  chkJobPurchAppHist2.Checked := not chkJobPurchAppHist2.Checked;
  chkJobPurchAppHist3.Checked := not chkJobPurchAppHist3.Checked;
  chkJobPurchAppHist4.Checked := not chkJobPurchAppHist4.Checked;
  chkJobPurchAppHist5.Checked := not chkJobPurchAppHist5.Checked;
  chkJobPurchAppHist6.Checked := not chkJobPurchAppHist6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleJobDbkSalesAppsClick(Sender: TObject);
begin
  chkJobSalesApps1.Checked := not chkJobSalesApps1.Checked;
  chkJobSalesApps2.Checked := not chkJobSalesApps2.Checked;
  chkJobSalesApps3.Checked := not chkJobSalesApps3.Checked;
  chkJobSalesApps4.Checked := not chkJobSalesApps4.Checked;
  chkJobSalesApps5.Checked := not chkJobSalesApps5.Checked;
  chkJobSalesApps6.Checked := not chkJobSalesApps6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleJobDbkSalesAppHistClick(Sender: TObject);
begin
  chkJobSalesAppHist1.Checked := not chkJobSalesAppHist1.Checked;
  chkJobSalesAppHist2.Checked := not chkJobSalesAppHist2.Checked;
  chkJobSalesAppHist3.Checked := not chkJobSalesAppHist3.Checked;
  chkJobSalesAppHist4.Checked := not chkJobSalesAppHist4.Checked;
  chkJobSalesAppHist5.Checked := not chkJobSalesAppHist5.Checked;
  chkJobSalesAppHist6.Checked := not chkJobSalesAppHist6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleJobDbkPLRetentClick(Sender: TObject);
begin
  chkJobPLRetentions1.Checked := not chkJobPLRetentions1.Checked;
  chkJobPLRetentions2.Checked := not chkJobPLRetentions2.Checked;
  chkJobPLRetentions3.Checked := not chkJobPLRetentions3.Checked;
  chkJobPLRetentions4.Checked := not chkJobPLRetentions4.Checked;
  chkJobPLRetentions5.Checked := not chkJobPLRetentions5.Checked;
  chkJobPLRetentions6.Checked := not chkJobPLRetentions6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleJobDbkSLRetentClick(Sender: TObject);
begin
  chkJobSLRetentions1.Checked := not chkJobSLRetentions1.Checked;
  chkJobSLRetentions2.Checked := not chkJobSLRetentions2.Checked;
  chkJobSLRetentions3.Checked := not chkJobSLRetentions3.Checked;
  chkJobSLRetentions4.Checked := not chkJobSLRetentions4.Checked;
  chkJobSLRetentions5.Checked := not chkJobSLRetentions5.Checked;
  chkJobSLRetentions6.Checked := not chkJobSLRetentions6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleStockMainClick(Sender: TObject);
begin
  chkStockMain1.Checked := not chkStockMain1.Checked;
  chkStockMain2.Checked := not chkStockMain2.Checked;
  chkStockMain3.Checked := not chkStockMain3.Checked;
  chkStockMain4.Checked := not chkStockMain4.Checked;
  chkStockMain5.Checked := not chkStockMain5.Checked;
  chkStockMain6.Checked := not chkStockMain6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleStockDefsClick(Sender: TObject);
begin
  chkStockDefaults1.Checked := not chkStockDefaults1.Checked;
  chkStockDefaults2.Checked := not chkStockDefaults2.Checked;
  chkStockDefaults3.Checked := not chkStockDefaults3.Checked;
  chkStockDefaults4.Checked := not chkStockDefaults4.Checked;
  chkStockDefaults5.Checked := not chkStockDefaults5.Checked;
  chkStockDefaults6.Checked := not chkStockDefaults6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleStockVatWebClick(Sender: TObject);
begin
  chkStockVATWeb1.Checked := not chkStockVATWeb1.Checked;
  chkStockVATWeb2.Checked := not chkStockVATWeb2.Checked;
  chkStockVATWeb3.Checked := not chkStockVATWeb3.Checked;
  chkStockVATWeb4.Checked := not chkStockVATWeb4.Checked;
  chkStockVATWeb5.Checked := not chkStockVATWeb5.Checked;
  chkStockVATWeb6.Checked := not chkStockVATWeb6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleStockWOPClick(Sender: TObject);
begin
  chkStockWOP1.Checked := not chkStockWOP1.Checked;
  chkStockWOP2.Checked := not chkStockWOP2.Checked;
  chkStockWOP3.Checked := not chkStockWOP3.Checked;
  chkStockWOP4.Checked := not chkStockWOP4.Checked;
  chkStockWOP5.Checked := not chkStockWOP5.Checked;
  chkStockWOP6.Checked := not chkStockWOP6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleStockReturnsClick(Sender: TObject);
begin
  chkStockReturns1.Checked := not chkStockReturns1.Checked;
  chkStockReturns2.Checked := not chkStockReturns2.Checked;
  chkStockReturns3.Checked := not chkStockReturns3.Checked;
  chkStockReturns4.Checked := not chkStockReturns4.Checked;
  chkStockReturns5.Checked := not chkStockReturns5.Checked;
  chkStockReturns6.Checked := not chkStockReturns6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleStockNotesClick(Sender: TObject);
begin
  chkStockNotes1.Checked := not chkStockNotes1.Checked;
  chkStockNotes2.Checked := not chkStockNotes2.Checked;
  chkStockNotes3.Checked := not chkStockNotes3.Checked;
  chkStockNotes4.Checked := not chkStockNotes4.Checked;
  chkStockNotes5.Checked := not chkStockNotes5.Checked;
  chkStockNotes6.Checked := not chkStockNotes6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleStockQtyBreaksClick(Sender: TObject);
begin
  chkStockQtyBreaks1.Checked := not chkStockQtyBreaks1.Checked;
  chkStockQtyBreaks2.Checked := not chkStockQtyBreaks2.Checked;
  chkStockQtyBreaks3.Checked := not chkStockQtyBreaks3.Checked;
  chkStockQtyBreaks4.Checked := not chkStockQtyBreaks4.Checked;
  chkStockQtyBreaks5.Checked := not chkStockQtyBreaks5.Checked;
  chkStockQtyBreaks6.Checked := not chkStockQtyBreaks6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleStockMultiBuyClick(Sender: TObject);
begin
  chkStockMBDiscounts1.Checked := not chkStockMBDiscounts1.Checked;
  chkStockMBDiscounts2.Checked := not chkStockMBDiscounts2.Checked;
  chkStockMBDiscounts3.Checked := not chkStockMBDiscounts3.Checked;
  chkStockMBDiscounts4.Checked := not chkStockMBDiscounts4.Checked;
  chkStockMBDiscounts5.Checked := not chkStockMBDiscounts5.Checked;
  chkStockMBDiscounts6.Checked := not chkStockMBDiscounts6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleStockLedgerClick(Sender: TObject);
begin
  chkStockLedger1.Checked := not chkStockLedger1.Checked;
  chkStockLedger2.Checked := not chkStockLedger2.Checked;
  chkStockLedger3.Checked := not chkStockLedger3.Checked;
  chkStockLedger4.Checked := not chkStockLedger4.Checked;
  chkStockLedger5.Checked := not chkStockLedger5.Checked;
  chkStockLedger6.Checked := not chkStockLedger6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleStockValueClick(Sender: TObject);
begin
  chkStockValue1.Checked := not chkStockValue1.Checked;
  chkStockValue2.Checked := not chkStockValue2.Checked;
  chkStockValue3.Checked := not chkStockValue3.Checked;
  chkStockValue4.Checked := not chkStockValue4.Checked;
  chkStockValue5.Checked := not chkStockValue5.Checked;
  chkStockValue6.Checked := not chkStockValue6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleStockBuildClick(Sender: TObject);
begin
  chkStockBuild1.Checked := not chkStockBuild1.Checked;
  chkStockBuild2.Checked := not chkStockBuild2.Checked;
  chkStockBuild3.Checked := not chkStockBuild3.Checked;
  chkStockBuild4.Checked := not chkStockBuild4.Checked;
  chkStockBuild5.Checked := not chkStockBuild5.Checked;
  chkStockBuild6.Checked := not chkStockBuild6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleStockSerialClick(Sender: TObject);
begin
  chkStockSerial1.Checked := not chkStockSerial1.Checked;
  chkStockSerial2.Checked := not chkStockSerial2.Checked;
  chkStockSerial3.Checked := not chkStockSerial3.Checked;
  chkStockSerial4.Checked := not chkStockSerial4.Checked;
  chkStockSerial5.Checked := not chkStockSerial5.Checked;
  chkStockSerial6.Checked := not chkStockSerial6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleStockBinsClick(Sender: TObject);
begin
  chkStockBins1.Checked := not chkStockBins1.Checked;
  chkStockBins2.Checked := not chkStockBins2.Checked;
  chkStockBins3.Checked := not chkStockBins3.Checked;
  chkStockBins4.Checked := not chkStockBins4.Checked;
  chkStockBins5.Checked := not chkStockBins5.Checked;
  chkStockBins6.Checked := not chkStockBins6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleSalesSalesClick(Sender: TObject);
begin
  chkSalesEdit1.Checked := not chkSalesEdit1.Checked;
  chkSalesEdit2.Checked := not chkSalesEdit2.Checked;
  chkSalesEdit3.Checked := not chkSalesEdit3.Checked;
  chkSalesEdit4.Checked := not chkSalesEdit4.Checked;
  chkSalesEdit5.Checked := not chkSalesEdit5.Checked;
  chkSalesEdit6.Checked := not chkSalesEdit6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleSalesPurchClick(Sender: TObject);
begin
  chkPurchEdit1.Checked := not chkPurchEdit1.Checked;
  chkPurchEdit2.Checked := not chkPurchEdit2.Checked;
  chkPurchEdit3.Checked := not chkPurchEdit3.Checked;
  chkPurchEdit4.Checked := not chkPurchEdit4.Checked;
  chkPurchEdit5.Checked := not chkPurchEdit5.Checked;
  chkPurchEdit6.Checked := not chkPurchEdit6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleSalesSalesViewClick(Sender: TObject);
begin
  chkSalesView1.Checked := not chkSalesView1.Checked;
  chkSalesView2.Checked := not chkSalesView2.Checked;
  chkSalesView3.Checked := not chkSalesView3.Checked;
  chkSalesView4.Checked := not chkSalesView4.Checked;
  chkSalesView5.Checked := not chkSalesView5.Checked;
  chkSalesView6.Checked := not chkSalesView6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleSalesPurchViewClick(Sender: TObject);
begin
  chkPurchView1.Checked := not chkPurchView1.Checked;
  chkPurchView2.Checked := not chkPurchView2.Checked;
  chkPurchView3.Checked := not chkPurchView3.Checked;
  chkPurchView4.Checked := not chkPurchView4.Checked;
  chkPurchView5.Checked := not chkPurchView5.Checked;
  chkPurchView6.Checked := not chkPurchView6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleStkAdjEditClick(Sender: TObject);
begin
  chkStockEdit1.Checked := not chkStockEdit1.Checked;
  chkStockEdit2.Checked := not chkStockEdit2.Checked;
  chkStockEdit3.Checked := not chkStockEdit3.Checked;
  chkStockEdit4.Checked := not chkStockEdit4.Checked;
  chkStockEdit5.Checked := not chkStockEdit5.Checked;
  chkStockEdit6.Checked := not chkStockEdit6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleStkAdjViewClick(Sender: TObject);
begin
  chkStockView1.Checked := not chkStockView1.Checked;
  chkStockView2.Checked := not chkStockView2.Checked;
  chkStockView3.Checked := not chkStockView3.Checked;
  chkStockView4.Checked := not chkStockView4.Checked;
  chkStockView5.Checked := not chkStockView5.Checked;
  chkStockView6.Checked := not chkStockView6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleWOREditClick(Sender: TObject);
begin
  chkWOREdit1.Checked := not chkWOREdit1.Checked;
  chkWOREdit2.Checked := not chkWOREdit2.Checked;
  chkWOREdit3.Checked := not chkWOREdit3.Checked;
  chkWOREdit4.Checked := not chkWOREdit4.Checked;
  chkWOREdit5.Checked := not chkWOREdit5.Checked;
  chkWOREdit6.Checked := not chkWOREdit6.Checked;
end;

procedure TfrmEnablecustomButtons.btnToggleWORViewClick(Sender: TObject);
begin
  chkWORView1.Checked := not chkWORView1.Checked;
  chkWORView2.Checked := not chkWORView2.Checked;
  chkWORView3.Checked := not chkWORView3.Checked;
  chkWORView4.Checked := not chkWORView4.Checked;
  chkWORView5.Checked := not chkWORView5.Checked;
  chkWORView6.Checked := not chkWORView6.Checked;
end;

procedure TfrmEnablecustomButtons.FormShow(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
  randomize;
end;

procedure TfrmEnablecustomButtons.chkChangedClick(Sender: TObject);
begin
  // A checkbox changed state so highlight the change by making the control panel red.
  controlPanel.color := clRed; 
end;

procedure TfrmEnablecustomButtons.btnToggleTraderListClick(
  Sender: TObject);
begin
  btnToggleCustListClick(Sender);
  btnToggleSuppListClick(Sender);
end;

procedure TfrmEnablecustomButtons.btnToggleCustSuppLedgerClick(
  Sender: TObject);
begin
  btnToggleCustLedgerClick(Sender);
  btnToggleSuppLedgerClick(Sender);
end;

procedure TfrmEnablecustomButtons.btnToggleJobRecordClick(Sender: TObject);
begin
  btnToggleJobMainClick(Sender);
  btnToggleJobNotesClick(Sender);
  btnToggleJobLedgerClick(Sender);
  btnToggleJobPurchRetClick(Sender);
  btnToggleJobRetClick(Sender);
end;

procedure TfrmEnablecustomButtons.btnToggleAllDaybookClick(
  Sender: TObject);
begin
  btnToggleDaybookMainClick(Sender);
  btnToggleDaybookQuotesClick(Sender);
  btnToggleDaybookAutoClick(Sender);
  btnToggleDaybookHistoryClick(Sender);
  btnToggleDaybookOrdersClick(Sender);
  btnToggleDaybookOrderHistClick(Sender);
  btnPurchToggleDaybookMainClick(Sender);
  btnPurchToggleDaybookQuotesClick(Sender);
  btnPurchToggleDaybookAutoClick(Sender);
  btnPurchToggleDaybookHistClick(Sender);
  btnPurchToggleDaybookOrdersClick(Sender);
  btnPurchToggleDaybookOrderHistClick(Sender);
  btnNomToggleDaybookMainClick(Sender);
  btnNomToggleDaybookAutoClick(Sender);
  btnNomToggleDaybookHistClick(Sender);
  // PKR. 04/11/2015. Add Custom Buttons to Works Order Daybook.
  btnWORToggleDaybookMainClick(Sender);
  btnWORToggleDaybookHistClick(Sender);
end;

procedure TfrmEnablecustomButtons.btnToggleJobDaybookClick(
  Sender: TObject);
begin
  btnToggleJobDbkPrepostClick(Sender);
  btnToggleJobDbkTimesheetsClick(Sender);
  btnToggleJobDbkTSheetHistClick(Sender);
  btnToggleJobDbkPurchAppsClick(Sender);
  btnToggleJobDbkPurchAppHistClick(Sender);
  btnToggleJobDbkSalesAppsClick(Sender);
  btnToggleJobDbkSalesAppHistClick(Sender);
  btnToggleJobDbkPLRetentClick(Sender);
  btnToggleJobDbkSLRetentClick(Sender);
end;

procedure TfrmEnablecustomButtons.btnToggleStockClick(Sender: TObject);
begin
  btnToggleStockMainClick(Sender);
  btnToggleStockDefsClick(Sender);
  btnToggleStockVatWebClick(Sender);
  btnToggleStockWOPClick(Sender);
  btnToggleStockReturnsClick(Sender);
  btnToggleStockNotesClick(Sender);
  btnToggleStockQtyBreaksClick(Sender);
  btnToggleStockMultiBuyClick(Sender);
  btnToggleStockLedgerClick(Sender);
  btnToggleStockValueClick(Sender);
  btnToggleStockBuildClick(Sender);
//  btnToggleStockSerialClick(Sender);
//  btnToggleStockBinsClick(Sender);
end;

procedure TfrmEnablecustomButtons.btnToggleSalesClick(Sender: TObject);
begin
  btnToggleSalesSalesClick(Sender);
  btnToggleSalesPurchClick(Sender);
  btnToggleSalesSalesViewClick(Sender);
  btnToggleSalesPurchViewClick(Sender);
end;

procedure TfrmEnablecustomButtons.btnToggleStockAdjustClick(
  Sender: TObject);
begin
  btnToggleStkAdjEditClick(Sender);
  btnToggleStkAdjViewClick(Sender);
end;

procedure TfrmEnablecustomButtons.btnToggleWORClick(Sender: TObject);
begin
  btnToggleWOREditClick(Sender);
  btnToggleWORViewClick(Sender);
end;

procedure TfrmEnablecustomButtons.btnToggleEverythingClick(
  Sender: TObject);
begin
  btnToggleTraderListClick(Sender);
  btnToggleCustSuppLedgerClick(Sender);
  btnToggleJobRecordClick(Sender);
  btnToggleAllDaybookClick(Sender);
  btnToggleJobDaybookClick(Sender);
  btnToggleStockClick(Sender);
  btnToggleSalesClick(Sender);
  btnToggleStockAdjustClick(Sender);
  btnToggleWORClick(Sender);
end;

procedure TfrmEnablecustomButtons.btnRandomCustSuppClick(Sender: TObject);
begin
  chkCustLst1.Checked := random * 100 > 50;
  chkCustLst2.Checked := random * 100 > 50;
  chkCustLst3.Checked := random * 100 > 50;
  chkCustLst4.Checked := random * 100 > 50;
  chkCustLst5.Checked := random * 100 > 50;
  chkCustLst6.Checked := random * 100 > 50;
  
  chkSuppLst1.Checked := random * 100 > 50;
  chkSuppLst2.Checked := random * 100 > 50;
  chkSuppLst3.Checked := random * 100 > 50;
  chkSuppLst4.Checked := random * 100 > 50;
  chkSuppLst5.Checked := random * 100 > 50;
  chkSuppLst6.Checked := random * 100 > 50;
end;

procedure TfrmEnablecustomButtons.btnRandomCustSuppLedgerClick(Sender: TObject);
begin
  chkCustLedger1.Checked := random * 100 > 50;
  chkCustLedger2.Checked := random * 100 > 50;
  chkCustLedger3.Checked := random * 100 > 50;
  chkCustLedger4.Checked := random * 100 > 50;
  chkCustLedger5.Checked := random * 100 > 50;
  chkCustLedger6.Checked := random * 100 > 50;

  chkSuppLedger1.Checked := random * 100 > 50;
  chkSuppLedger2.Checked := random * 100 > 50;
  chkSuppLedger3.Checked := random * 100 > 50;
  chkSuppLedger4.Checked := random * 100 > 50;
  chkSuppLedger5.Checked := random * 100 > 50;
  chkSuppLedger6.Checked := random * 100 > 50;
end;

procedure TfrmEnablecustomButtons.btnRandomJobRecClick(Sender: TObject);
begin
  chkJobMain1.Checked := random * 100 > 50;
  chkJobMain2.Checked := random * 100 > 50;
  chkJobMain3.Checked := random * 100 > 50;
  chkJobMain4.Checked := random * 100 > 50;
  chkJobMain5.Checked := random * 100 > 50;
  chkJobMain6.Checked := random * 100 > 50;

  chkJobNotes1.Checked := random * 100 > 50;
  chkJobNotes2.Checked := random * 100 > 50;
  chkJobNotes3.Checked := random * 100 > 50;
  chkJobNotes4.Checked := random * 100 > 50;
  chkJobNotes5.Checked := random * 100 > 50;
  chkJobNotes6.Checked := random * 100 > 50;

  chkJobLedger1.Checked := random * 100 > 50;
  chkJobLedger2.Checked := random * 100 > 50;
  chkJobLedger3.Checked := random * 100 > 50;
  chkJobLedger4.Checked := random * 100 > 50;
  chkJobLedger5.Checked := random * 100 > 50;
  chkJobLedger6.Checked := random * 100 > 50;
  
  chkJobPurchRet1.Checked := random * 100 > 50;
  chkJobPurchRet2.Checked := random * 100 > 50;
  chkJobPurchRet3.Checked := random * 100 > 50;
  chkJobPurchRet4.Checked := random * 100 > 50;
  chkJobPurchRet5.Checked := random * 100 > 50;
  chkJobPurchRet6.Checked := random * 100 > 50;

  chkJobSalesRet1.Checked := random * 100 > 50;
  chkJobSalesRet2.Checked := random * 100 > 50;
  chkJobSalesRet3.Checked := random * 100 > 50;
  chkJobSalesRet4.Checked := random * 100 > 50;
  chkJobSalesRet5.Checked := random * 100 > 50;
  chkJobSalesRet6.Checked := random * 100 > 50;
end;

procedure TfrmEnablecustomButtons.btnRandomDaybookClick(Sender: TObject);
begin
  chkSalesDBkMain1.Checked := random * 100 > 50;
  chkSalesDBkMain2.Checked := random * 100 > 50;
  chkSalesDBkMain3.Checked := random * 100 > 50;
  chkSalesDBkMain4.Checked := random * 100 > 50;
  chkSalesDBkMain5.Checked := random * 100 > 50;
  chkSalesDBkMain6.Checked := random * 100 > 50;

  chkSalesDBkQuotes1.Checked := random * 100 > 50;
  chkSalesDBkQuotes2.Checked := random * 100 > 50;
  chkSalesDBkQuotes3.Checked := random * 100 > 50;
  chkSalesDBkQuotes4.Checked := random * 100 > 50;
  chkSalesDBkQuotes5.Checked := random * 100 > 50;
  chkSalesDBkQuotes6.Checked := random * 100 > 50;

  chkSalesDBkAuto1.Checked := random * 100 > 50;
  chkSalesDBkAuto2.Checked := random * 100 > 50;
  chkSalesDBkAuto3.Checked := random * 100 > 50;
  chkSalesDBkAuto4.Checked := random * 100 > 50;
  chkSalesDBkAuto5.Checked := random * 100 > 50;
  chkSalesDBkAuto6.Checked := random * 100 > 50;

  chkSalesDBkHistory1.Checked := random * 100 > 50;
  chkSalesDBkHistory2.Checked := random * 100 > 50;
  chkSalesDBkHistory3.Checked := random * 100 > 50;
  chkSalesDBkHistory4.Checked := random * 100 > 50;
  chkSalesDBkHistory5.Checked := random * 100 > 50;
  chkSalesDBkHistory6.Checked := random * 100 > 50;

  chkSalesDBkOrders1.Checked := random * 100 > 50;
  chkSalesDBkOrders2.Checked := random * 100 > 50;
  chkSalesDBkOrders3.Checked := random * 100 > 50;
  chkSalesDBkOrders4.Checked := random * 100 > 50;
  chkSalesDBkOrders5.Checked := random * 100 > 50;
  chkSalesDBkOrders6.Checked := random * 100 > 50;

  chkSalesDBkOrderHistory1.Checked := random * 100 > 50;
  chkSalesDBkOrderHistory2.Checked := random * 100 > 50;
  chkSalesDBkOrderHistory3.Checked := random * 100 > 50;
  chkSalesDBkOrderHistory4.Checked := random * 100 > 50;
  chkSalesDBkOrderHistory5.Checked := random * 100 > 50;
  chkSalesDBkOrderHistory6.Checked := random * 100 > 50;

  chkPurchDBkMain1.Checked := random * 100 > 50;
  chkPurchDBkMain2.Checked := random * 100 > 50;
  chkPurchDBkMain3.Checked := random * 100 > 50;
  chkPurchDBkMain4.Checked := random * 100 > 50;
  chkPurchDBkMain5.Checked := random * 100 > 50;
  chkPurchDBkMain6.Checked := random * 100 > 50;

  chkPurchDBkQuotes1.Checked := random * 100 > 50;
  chkPurchDBkQuotes2.Checked := random * 100 > 50;
  chkPurchDBkQuotes3.Checked := random * 100 > 50;
  chkPurchDBkQuotes4.Checked := random * 100 > 50;
  chkPurchDBkQuotes5.Checked := random * 100 > 50;
  chkPurchDBkQuotes6.Checked := random * 100 > 50;

  chkPurchDBkAuto1.Checked := random * 100 > 50;
  chkPurchDBkAuto2.Checked := random * 100 > 50;
  chkPurchDBkAuto3.Checked := random * 100 > 50;
  chkPurchDBkAuto4.Checked := random * 100 > 50;
  chkPurchDBkAuto5.Checked := random * 100 > 50;
  chkPurchDBkAuto6.Checked := random * 100 > 50;

  chkPurchDBkHistory1.Checked := random * 100 > 50;
  chkPurchDBkHistory2.Checked := random * 100 > 50;
  chkPurchDBkHistory3.Checked := random * 100 > 50;
  chkPurchDBkHistory4.Checked := random * 100 > 50;
  chkPurchDBkHistory5.Checked := random * 100 > 50;
  chkPurchDBkHistory6.Checked := random * 100 > 50;

  chkPurchDBkOrders1.Checked := random * 100 > 50;
  chkPurchDBkOrders2.Checked := random * 100 > 50;
  chkPurchDBkOrders3.Checked := random * 100 > 50;
  chkPurchDBkOrders4.Checked := random * 100 > 50;
  chkPurchDBkOrders5.Checked := random * 100 > 50;
  chkPurchDBkOrders6.Checked := random * 100 > 50;

  chkPurchDBkOrderHistory1.Checked := random * 100 > 50;
  chkPurchDBkOrderHistory2.Checked := random * 100 > 50;
  chkPurchDBkOrderHistory3.Checked := random * 100 > 50;
  chkPurchDBkOrderHistory4.Checked := random * 100 > 50;
  chkPurchDBkOrderHistory5.Checked := random * 100 > 50;
  chkPurchDBkOrderHistory6.Checked := random * 100 > 50;

  chkNomDBkMain1.Checked := random * 100 > 50;
  chkNomDBkMain2.Checked := random * 100 > 50;
  chkNomDBkMain3.Checked := random * 100 > 50;
  chkNomDBkMain4.Checked := random * 100 > 50;
  chkNomDBkMain5.Checked := random * 100 > 50;
  chkNomDBkMain6.Checked := random * 100 > 50;

  chkNomDBkAuto1.Checked := random * 100 > 50;
  chkNomDBkAuto2.Checked := random * 100 > 50;
  chkNomDBkAuto3.Checked := random * 100 > 50;
  chkNomDBkAuto4.Checked := random * 100 > 50;
  chkNomDBkAuto5.Checked := random * 100 > 50;
  chkNomDBkAuto6.Checked := random * 100 > 50;

  chkNomDBkHistory1.Checked := random * 100 > 50;
  chkNomDBkHistory2.Checked := random * 100 > 50;
  chkNomDBkHistory3.Checked := random * 100 > 50;
  chkNomDBkHistory4.Checked := random * 100 > 50;
  chkNomDBkHistory5.Checked := random * 100 > 50;
  chkNomDBkHistory6.Checked := random * 100 > 50;

  // PKR. 04/11/2015. Add Custom Buttons to Works Order Daybook.
  chkWORDBkMain1.Checked := random * 100 > 50;
  chkWORDBkMain2.Checked := random * 100 > 50;
  chkWORDBkMain3.Checked := random * 100 > 50;
  chkWORDBkMain4.Checked := random * 100 > 50;
  chkWORDBkMain5.Checked := random * 100 > 50;
  chkWORDBkMain6.Checked := random * 100 > 50;

  chkWORDBkHistory1.Checked := random * 100 > 50;
  chkWORDBkHistory2.Checked := random * 100 > 50;
  chkWORDBkHistory3.Checked := random * 100 > 50;
  chkWORDBkHistory4.Checked := random * 100 > 50;
  chkWORDBkHistory5.Checked := random * 100 > 50;
  chkWORDBkHistory6.Checked := random * 100 > 50;
end;

procedure TfrmEnablecustomButtons.btnRandomJobDbkClick(Sender: TObject);
begin
  chkJobPrePost1.Checked := random * 100 > 50;
  chkJobPrePost2.Checked := random * 100 > 50;
  chkJobPrePost3.Checked := random * 100 > 50;
  chkJobPrePost4.Checked := random * 100 > 50;
  chkJobPrePost5.Checked := random * 100 > 50;
  chkJobPrePost6.Checked := random * 100 > 50;

  chkJobTimesheets1.Checked := random * 100 > 50;
  chkJobTimesheets2.Checked := random * 100 > 50;
  chkJobTimesheets3.Checked := random * 100 > 50;
  chkJobTimesheets4.Checked := random * 100 > 50;
  chkJobTimesheets5.Checked := random * 100 > 50;
  chkJobTimesheets6.Checked := random * 100 > 50;

  chkJobTimesheetHist1.Checked := random * 100 > 50;
  chkJobTimesheetHist2.Checked := random * 100 > 50;
  chkJobTimesheetHist3.Checked := random * 100 > 50;
  chkJobTimesheetHist4.Checked := random * 100 > 50;
  chkJobTimesheetHist5.Checked := random * 100 > 50;
  chkJobTimesheetHist6.Checked := random * 100 > 50;

  chkJobPurchApps1.Checked := random * 100 > 50;
  chkJobPurchApps2.Checked := random * 100 > 50;
  chkJobPurchApps3.Checked := random * 100 > 50;
  chkJobPurchApps4.Checked := random * 100 > 50;
  chkJobPurchApps5.Checked := random * 100 > 50;
  chkJobPurchApps6.Checked := random * 100 > 50;

  chkJobPurchAppHist1.Checked := random * 100 > 50;
  chkJobPurchAppHist2.Checked := random * 100 > 50;
  chkJobPurchAppHist3.Checked := random * 100 > 50;
  chkJobPurchAppHist4.Checked := random * 100 > 50;
  chkJobPurchAppHist5.Checked := random * 100 > 50;
  chkJobPurchAppHist6.Checked := random * 100 > 50;

  chkJobSalesApps1.Checked := random * 100 > 50;
  chkJobSalesApps2.Checked := random * 100 > 50;
  chkJobSalesApps3.Checked := random * 100 > 50;
  chkJobSalesApps4.Checked := random * 100 > 50;
  chkJobSalesApps5.Checked := random * 100 > 50;
  chkJobSalesApps6.Checked := random * 100 > 50;

  chkJobSalesAppHist1.Checked := random * 100 > 50;
  chkJobSalesAppHist2.Checked := random * 100 > 50;
  chkJobSalesAppHist3.Checked := random * 100 > 50;
  chkJobSalesAppHist4.Checked := random * 100 > 50;
  chkJobSalesAppHist5.Checked := random * 100 > 50;
  chkJobSalesAppHist6.Checked := random * 100 > 50;

  chkJobPLRetentions1.Checked := random * 100 > 50;
  chkJobPLRetentions2.Checked := random * 100 > 50;
  chkJobPLRetentions3.Checked := random * 100 > 50;
  chkJobPLRetentions4.Checked := random * 100 > 50;
  chkJobPLRetentions5.Checked := random * 100 > 50;
  chkJobPLRetentions6.Checked := random * 100 > 50;

  chkJobSLRetentions1.Checked := random * 100 > 50;
  chkJobSLRetentions2.Checked := random * 100 > 50;
  chkJobSLRetentions3.Checked := random * 100 > 50;
  chkJobSLRetentions4.Checked := random * 100 > 50;
  chkJobSLRetentions5.Checked := random * 100 > 50;
  chkJobSLRetentions6.Checked := random * 100 > 50;
end;

procedure TfrmEnablecustomButtons.btnRandomStockClick(Sender: TObject);
begin
  chkStockMain1.Checked := random * 100 > 50;
  chkStockMain2.Checked := random * 100 > 50;
  chkStockMain3.Checked := random * 100 > 50;
  chkStockMain4.Checked := random * 100 > 50;
  chkStockMain5.Checked := random * 100 > 50;
  chkStockMain6.Checked := random * 100 > 50;

  chkStockDefaults1.Checked := random * 100 > 50;
  chkStockDefaults2.Checked := random * 100 > 50;
  chkStockDefaults3.Checked := random * 100 > 50;
  chkStockDefaults4.Checked := random * 100 > 50;
  chkStockDefaults5.Checked := random * 100 > 50;
  chkStockDefaults6.Checked := random * 100 > 50;

  chkStockVATWeb1.Checked := random * 100 > 50;
  chkStockVATWeb2.Checked := random * 100 > 50;
  chkStockVATWeb3.Checked := random * 100 > 50;
  chkStockVATWeb4.Checked := random * 100 > 50;
  chkStockVATWeb5.Checked := random * 100 > 50;
  chkStockVATWeb6.Checked := random * 100 > 50;

  chkStockWOP1.Checked := random * 100 > 50;
  chkStockWOP2.Checked := random * 100 > 50;
  chkStockWOP3.Checked := random * 100 > 50;
  chkStockWOP4.Checked := random * 100 > 50;
  chkStockWOP5.Checked := random * 100 > 50;
  chkStockWOP6.Checked := random * 100 > 50;

  chkStockReturns1.Checked := random * 100 > 50;
  chkStockReturns2.Checked := random * 100 > 50;
  chkStockReturns3.Checked := random * 100 > 50;
  chkStockReturns4.Checked := random * 100 > 50;
  chkStockReturns5.Checked := random * 100 > 50;
  chkStockReturns6.Checked := random * 100 > 50;

  chkStockNotes1.Checked := random * 100 > 50;
  chkStockNotes2.Checked := random * 100 > 50;
  chkStockNotes3.Checked := random * 100 > 50;
  chkStockNotes4.Checked := random * 100 > 50;
  chkStockNotes5.Checked := random * 100 > 50;
  chkStockNotes6.Checked := random * 100 > 50;

  chkStockQtyBreaks1.Checked := random * 100 > 50;
  chkStockQtyBreaks2.Checked := random * 100 > 50;
  chkStockQtyBreaks3.Checked := random * 100 > 50;
  chkStockQtyBreaks4.Checked := random * 100 > 50;
  chkStockQtyBreaks5.Checked := random * 100 > 50;
  chkStockQtyBreaks6.Checked := random * 100 > 50;

  chkStockMBDiscounts1.Checked := random * 100 > 50;
  chkStockMBDiscounts2.Checked := random * 100 > 50;
  chkStockMBDiscounts3.Checked := random * 100 > 50;
  chkStockMBDiscounts4.Checked := random * 100 > 50;
  chkStockMBDiscounts5.Checked := random * 100 > 50;
  chkStockMBDiscounts6.Checked := random * 100 > 50;

  chkStockLedger1.Checked := random * 100 > 50;
  chkStockLedger2.Checked := random * 100 > 50;
  chkStockLedger3.Checked := random * 100 > 50;
  chkStockLedger4.Checked := random * 100 > 50;
  chkStockLedger5.Checked := random * 100 > 50;
  chkStockLedger6.Checked := random * 100 > 50;

  chkStockValue1.Checked := random * 100 > 50;
  chkStockValue2.Checked := random * 100 > 50;
  chkStockValue3.Checked := random * 100 > 50;
  chkStockValue4.Checked := random * 100 > 50;
  chkStockValue5.Checked := random * 100 > 50;
  chkStockValue6.Checked := random * 100 > 50;

  chkStockBuild1.Checked := random * 100 > 50;
  chkStockBuild2.Checked := random * 100 > 50;
  chkStockBuild3.Checked := random * 100 > 50;
  chkStockBuild4.Checked := random * 100 > 50;
  chkStockBuild5.Checked := random * 100 > 50;
  chkStockBuild6.Checked := random * 100 > 50;
(*
  chkStockSerial1.Checked := random * 100 > 50;
  chkStockSerial2.Checked := random * 100 > 50;
  chkStockSerial3.Checked := random * 100 > 50;
  chkStockSerial4.Checked := random * 100 > 50;
  chkStockSerial5.Checked := random * 100 > 50;
  chkStockSerial6.Checked := random * 100 > 50;

  chkStockBins1.Checked := random * 100 > 50;
  chkStockBins2.Checked := random * 100 > 50;
  chkStockBins3.Checked := random * 100 > 50;
  chkStockBins4.Checked := random * 100 > 50;
  chkStockBins5.Checked := random * 100 > 50;
  chkStockBins6.Checked := random * 100 > 50;
*)
end;

procedure TfrmEnablecustomButtons.btnRandomSalesClick(Sender: TObject);
begin
  chkSalesEdit1.Checked := random * 100 > 50;
  chkSalesEdit2.Checked := random * 100 > 50;
  chkSalesEdit3.Checked := random * 100 > 50;
  chkSalesEdit4.Checked := random * 100 > 50;
  chkSalesEdit5.Checked := random * 100 > 50;
  chkSalesEdit6.Checked := random * 100 > 50;

  chkPurchEdit1.Checked := random * 100 > 50;
  chkPurchEdit2.Checked := random * 100 > 50;
  chkPurchEdit3.Checked := random * 100 > 50;
  chkPurchEdit4.Checked := random * 100 > 50;
  chkPurchEdit5.Checked := random * 100 > 50;
  chkPurchEdit6.Checked := random * 100 > 50;

  chkSalesView1.Checked := random * 100 > 50;
  chkSalesView2.Checked := random * 100 > 50;
  chkSalesView3.Checked := random * 100 > 50;
  chkSalesView4.Checked := random * 100 > 50;
  chkSalesView5.Checked := random * 100 > 50;
  chkSalesView6.Checked := random * 100 > 50;

  chkPurchView1.Checked := random * 100 > 50;
  chkPurchView2.Checked := random * 100 > 50;
  chkPurchView3.Checked := random * 100 > 50;
  chkPurchView4.Checked := random * 100 > 50;
  chkPurchView5.Checked := random * 100 > 50;
  chkPurchView6.Checked := random * 100 > 50;
end;

procedure TfrmEnablecustomButtons.btnRandomStkAdjClick(Sender: TObject);
begin
  chkStockEdit1.Checked := random * 100 > 50;
  chkStockEdit2.Checked := random * 100 > 50;
  chkStockEdit3.Checked := random * 100 > 50;
  chkStockEdit4.Checked := random * 100 > 50;
  chkStockEdit5.Checked := random * 100 > 50;
  chkStockEdit6.Checked := random * 100 > 50;

  chkStockView1.Checked := random * 100 > 50;
  chkStockView2.Checked := random * 100 > 50;
  chkStockView3.Checked := random * 100 > 50;
  chkStockView4.Checked := random * 100 > 50;
  chkStockView5.Checked := random * 100 > 50;
  chkStockView6.Checked := random * 100 > 50;
end;

procedure TfrmEnablecustomButtons.btnRandomWORClick(Sender: TObject);
begin
  chkWOREdit1.Checked := random * 100 > 50;
  chkWOREdit2.Checked := random * 100 > 50;
  chkWOREdit3.Checked := random * 100 > 50;
  chkWOREdit4.Checked := random * 100 > 50;
  chkWOREdit5.Checked := random * 100 > 50;
  chkWOREdit6.Checked := random * 100 > 50;

  chkWORView1.Checked := random * 100 > 50;
  chkWORView2.Checked := random * 100 > 50;
  chkWORView3.Checked := random * 100 > 50;
  chkWORView4.Checked := random * 100 > 50;
  chkWORView5.Checked := random * 100 > 50;
  chkWORView6.Checked := random * 100 > 50;
end;

procedure TfrmEnablecustomButtons.btnTraderAllOffClick(Sender: TObject);
begin
  chkCustLst1.Checked := false;
  chkCustLst2.Checked := false;
  chkCustLst3.Checked := false;
  chkCustLst4.Checked := false;
  chkCustLst5.Checked := false;
  chkCustLst6.Checked := false;
  
  chkSuppLst1.Checked := false;
  chkSuppLst2.Checked := false;
  chkSuppLst3.Checked := false;
  chkSuppLst4.Checked := false;
  chkSuppLst5.Checked := false;
  chkSuppLst6.Checked := false;
end;

procedure TfrmEnablecustomButtons.btnLedgerAllOffClick(Sender: TObject);
begin
  chkCustLedger1.Checked := false;
  chkCustLedger2.Checked := false;
  chkCustLedger3.Checked := false;
  chkCustLedger4.Checked := false;
  chkCustLedger5.Checked := false;
  chkCustLedger6.Checked := false;

  chkSuppLedger1.Checked := false;
  chkSuppLedger2.Checked := false;
  chkSuppLedger3.Checked := false;
  chkSuppLedger4.Checked := false;
  chkSuppLedger5.Checked := false;
  chkSuppLedger6.Checked := false;
end;

procedure TfrmEnablecustomButtons.btnJobRecAllOffClick(Sender: TObject);
begin
  chkJobMain1.Checked := false;
  chkJobMain2.Checked := false;
  chkJobMain3.Checked := false;
  chkJobMain4.Checked := false;
  chkJobMain5.Checked := false;
  chkJobMain6.Checked := false;

  chkJobNotes1.Checked := false;
  chkJobNotes2.Checked := false;
  chkJobNotes3.Checked := false;
  chkJobNotes4.Checked := false;
  chkJobNotes5.Checked := false;
  chkJobNotes6.Checked := false;

  chkJobLedger1.Checked := false;
  chkJobLedger2.Checked := false;
  chkJobLedger3.Checked := false;
  chkJobLedger4.Checked := false;
  chkJobLedger5.Checked := false;
  chkJobLedger6.Checked := false;
  
  chkJobPurchRet1.Checked := false;
  chkJobPurchRet2.Checked := false;
  chkJobPurchRet3.Checked := false;
  chkJobPurchRet4.Checked := false;
  chkJobPurchRet5.Checked := false;
  chkJobPurchRet6.Checked := false;

  chkJobSalesRet1.Checked := false;
  chkJobSalesRet2.Checked := false;
  chkJobSalesRet3.Checked := false;
  chkJobSalesRet4.Checked := false;
  chkJobSalesRet5.Checked := false;
  chkJobSalesRet6.Checked := false;
end;

procedure TfrmEnablecustomButtons.btnDbkAllOffClick(Sender: TObject);
begin
  chkSalesDBkMain1.Checked := false;;
  chkSalesDBkMain2.Checked := false;;
  chkSalesDBkMain3.Checked := false;;
  chkSalesDBkMain4.Checked := false;;
  chkSalesDBkMain5.Checked := false;;
  chkSalesDBkMain6.Checked := false;;

  chkSalesDBkQuotes1.Checked := false;;
  chkSalesDBkQuotes2.Checked := false;;
  chkSalesDBkQuotes3.Checked := false;;
  chkSalesDBkQuotes4.Checked := false;;
  chkSalesDBkQuotes5.Checked := false;;
  chkSalesDBkQuotes6.Checked := false;;

  chkSalesDBkAuto1.Checked := false;;
  chkSalesDBkAuto2.Checked := false;;
  chkSalesDBkAuto3.Checked := false;;
  chkSalesDBkAuto4.Checked := false;;
  chkSalesDBkAuto5.Checked := false;;
  chkSalesDBkAuto6.Checked := false;;

  chkSalesDBkHistory1.Checked := false;;
  chkSalesDBkHistory2.Checked := false;;
  chkSalesDBkHistory3.Checked := false;;
  chkSalesDBkHistory4.Checked := false;;
  chkSalesDBkHistory5.Checked := false;;
  chkSalesDBkHistory6.Checked := false;;

  chkSalesDBkOrders1.Checked := false;;
  chkSalesDBkOrders2.Checked := false;;
  chkSalesDBkOrders3.Checked := false;;
  chkSalesDBkOrders4.Checked := false;;
  chkSalesDBkOrders5.Checked := false;;
  chkSalesDBkOrders6.Checked := false;;

  chkSalesDBkOrderHistory1.Checked := false;;
  chkSalesDBkOrderHistory2.Checked := false;;
  chkSalesDBkOrderHistory3.Checked := false;;
  chkSalesDBkOrderHistory4.Checked := false;;
  chkSalesDBkOrderHistory5.Checked := false;;
  chkSalesDBkOrderHistory6.Checked := false;;

  chkPurchDBkMain1.Checked := false;;
  chkPurchDBkMain2.Checked := false;;
  chkPurchDBkMain3.Checked := false;;
  chkPurchDBkMain4.Checked := false;;
  chkPurchDBkMain5.Checked := false;;
  chkPurchDBkMain6.Checked := false;;

  chkPurchDBkQuotes1.Checked := false;;
  chkPurchDBkQuotes2.Checked := false;;
  chkPurchDBkQuotes3.Checked := false;;
  chkPurchDBkQuotes4.Checked := false;;
  chkPurchDBkQuotes5.Checked := false;;
  chkPurchDBkQuotes6.Checked := false;;

  chkPurchDBkAuto1.Checked := false;;
  chkPurchDBkAuto2.Checked := false;;
  chkPurchDBkAuto3.Checked := false;;
  chkPurchDBkAuto4.Checked := false;;
  chkPurchDBkAuto5.Checked := false;;
  chkPurchDBkAuto6.Checked := false;;

  chkPurchDBkHistory1.Checked := false;;
  chkPurchDBkHistory2.Checked := false;;
  chkPurchDBkHistory3.Checked := false;;
  chkPurchDBkHistory4.Checked := false;;
  chkPurchDBkHistory5.Checked := false;;
  chkPurchDBkHistory6.Checked := false;;

  chkPurchDBkOrders1.Checked := false;;
  chkPurchDBkOrders2.Checked := false;;
  chkPurchDBkOrders3.Checked := false;;
  chkPurchDBkOrders4.Checked := false;;
  chkPurchDBkOrders5.Checked := false;;
  chkPurchDBkOrders6.Checked := false;;

  chkPurchDBkOrderHistory1.Checked := false;;
  chkPurchDBkOrderHistory2.Checked := false;;
  chkPurchDBkOrderHistory3.Checked := false;;
  chkPurchDBkOrderHistory4.Checked := false;;
  chkPurchDBkOrderHistory5.Checked := false;;
  chkPurchDBkOrderHistory6.Checked := false;;

  chkNomDBkMain1.Checked := false;;
  chkNomDBkMain2.Checked := false;;
  chkNomDBkMain3.Checked := false;;
  chkNomDBkMain4.Checked := false;;
  chkNomDBkMain5.Checked := false;;
  chkNomDBkMain6.Checked := false;;

  chkNomDBkAuto1.Checked := false;;
  chkNomDBkAuto2.Checked := false;;
  chkNomDBkAuto3.Checked := false;;
  chkNomDBkAuto4.Checked := false;;
  chkNomDBkAuto5.Checked := false;;
  chkNomDBkAuto6.Checked := false;;

  chkNomDBkHistory1.Checked := false;;
  chkNomDBkHistory2.Checked := false;;
  chkNomDBkHistory3.Checked := false;;
  chkNomDBkHistory4.Checked := false;;
  chkNomDBkHistory5.Checked := false;;
  chkNomDBkHistory6.Checked := false;;

  // PKR. 04/11/2015. Add Custom Buttons to Works Order Daybook.
  chkWORDBkMain1.Checked := false;;
  chkWORDBkMain2.Checked := false;;
  chkWORDBkMain3.Checked := false;;
  chkWORDBkMain4.Checked := false;;
  chkWORDBkMain5.Checked := false;;
  chkWORDBkMain6.Checked := false;;

  chkWORDBkHistory1.Checked := false;;
  chkWORDBkHistory2.Checked := false;;
  chkWORDBkHistory3.Checked := false;;
  chkWORDBkHistory4.Checked := false;;
  chkWORDBkHistory5.Checked := false;;
  chkWORDBkHistory6.Checked := false;;
end;

procedure TfrmEnablecustomButtons.btnJobDbkAllOffClick(Sender: TObject);
begin
  chkJobPrePost1.Checked := false;
  chkJobPrePost2.Checked := false;
  chkJobPrePost3.Checked := false;
  chkJobPrePost4.Checked := false;
  chkJobPrePost5.Checked := false;
  chkJobPrePost6.Checked := false;

  chkJobTimesheets1.Checked := false;
  chkJobTimesheets2.Checked := false;
  chkJobTimesheets3.Checked := false;
  chkJobTimesheets4.Checked := false;
  chkJobTimesheets5.Checked := false;
  chkJobTimesheets6.Checked := false;

  chkJobTimesheetHist1.Checked := false;
  chkJobTimesheetHist2.Checked := false;
  chkJobTimesheetHist3.Checked := false;
  chkJobTimesheetHist4.Checked := false;
  chkJobTimesheetHist5.Checked := false;
  chkJobTimesheetHist6.Checked := false;

  chkJobPurchApps1.Checked := false;
  chkJobPurchApps2.Checked := false;
  chkJobPurchApps3.Checked := false;
  chkJobPurchApps4.Checked := false;
  chkJobPurchApps5.Checked := false;
  chkJobPurchApps6.Checked := false;

  chkJobPurchAppHist1.Checked := false;
  chkJobPurchAppHist2.Checked := false;
  chkJobPurchAppHist3.Checked := false;
  chkJobPurchAppHist4.Checked := false;
  chkJobPurchAppHist5.Checked := false;
  chkJobPurchAppHist6.Checked := false;

  chkJobSalesApps1.Checked := false;
  chkJobSalesApps2.Checked := false;
  chkJobSalesApps3.Checked := false;
  chkJobSalesApps4.Checked := false;
  chkJobSalesApps5.Checked := false;
  chkJobSalesApps6.Checked := false;

  chkJobSalesAppHist1.Checked := false;
  chkJobSalesAppHist2.Checked := false;
  chkJobSalesAppHist3.Checked := false;
  chkJobSalesAppHist4.Checked := false;
  chkJobSalesAppHist5.Checked := false;
  chkJobSalesAppHist6.Checked := false;

  chkJobPLRetentions1.Checked := false;
  chkJobPLRetentions2.Checked := false;
  chkJobPLRetentions3.Checked := false;
  chkJobPLRetentions4.Checked := false;
  chkJobPLRetentions5.Checked := false;
  chkJobPLRetentions6.Checked := false;

  chkJobSLRetentions1.Checked := false;
  chkJobSLRetentions2.Checked := false;
  chkJobSLRetentions3.Checked := false;
  chkJobSLRetentions4.Checked := false;
  chkJobSLRetentions5.Checked := false;
  chkJobSLRetentions6.Checked := false;
end;

procedure TfrmEnablecustomButtons.btnStockAllOffClick(Sender: TObject);
begin
  chkStockMain1.Checked := false;
  chkStockMain2.Checked := false;
  chkStockMain3.Checked := false;
  chkStockMain4.Checked := false;
  chkStockMain5.Checked := false;
  chkStockMain6.Checked := false;

  chkStockDefaults1.Checked := false;
  chkStockDefaults2.Checked := false;
  chkStockDefaults3.Checked := false;
  chkStockDefaults4.Checked := false;
  chkStockDefaults5.Checked := false;
  chkStockDefaults6.Checked := false;

  chkStockVATWeb1.Checked := false;
  chkStockVATWeb2.Checked := false;
  chkStockVATWeb3.Checked := false;
  chkStockVATWeb4.Checked := false;
  chkStockVATWeb5.Checked := false;
  chkStockVATWeb6.Checked := false;

  chkStockWOP1.Checked := false;
  chkStockWOP2.Checked := false;
  chkStockWOP3.Checked := false;
  chkStockWOP4.Checked := false;
  chkStockWOP5.Checked := false;
  chkStockWOP6.Checked := false;

  chkStockReturns1.Checked := false;
  chkStockReturns2.Checked := false;
  chkStockReturns3.Checked := false;
  chkStockReturns4.Checked := false;
  chkStockReturns5.Checked := false;
  chkStockReturns6.Checked := false;

  chkStockNotes1.Checked := false;
  chkStockNotes2.Checked := false;
  chkStockNotes3.Checked := false;
  chkStockNotes4.Checked := false;
  chkStockNotes5.Checked := false;
  chkStockNotes6.Checked := false;

  chkStockQtyBreaks1.Checked := false;
  chkStockQtyBreaks2.Checked := false;
  chkStockQtyBreaks3.Checked := false;
  chkStockQtyBreaks4.Checked := false;
  chkStockQtyBreaks5.Checked := false;
  chkStockQtyBreaks6.Checked := false;

  chkStockMBDiscounts1.Checked := false;
  chkStockMBDiscounts2.Checked := false;
  chkStockMBDiscounts3.Checked := false;
  chkStockMBDiscounts4.Checked := false;
  chkStockMBDiscounts5.Checked := false;
  chkStockMBDiscounts6.Checked := false;

  chkStockLedger1.Checked := false;
  chkStockLedger2.Checked := false;
  chkStockLedger3.Checked := false;
  chkStockLedger4.Checked := false;
  chkStockLedger5.Checked := false;
  chkStockLedger6.Checked := false;

  chkStockValue1.Checked := false;
  chkStockValue2.Checked := false;
  chkStockValue3.Checked := false;
  chkStockValue4.Checked := false;
  chkStockValue5.Checked := false;
  chkStockValue6.Checked := false;

  chkStockBuild1.Checked := false;
  chkStockBuild2.Checked := false;
  chkStockBuild3.Checked := false;
  chkStockBuild4.Checked := false;
  chkStockBuild5.Checked := false;
  chkStockBuild6.Checked := false;

  chkStockSerial1.Checked := false;
  chkStockSerial2.Checked := false;
  chkStockSerial3.Checked := false;
  chkStockSerial4.Checked := false;
  chkStockSerial5.Checked := false;
  chkStockSerial6.Checked := false;

  chkStockBins1.Checked := false;
  chkStockBins2.Checked := false;
  chkStockBins3.Checked := false;
  chkStockBins4.Checked := false;
  chkStockBins5.Checked := false;
  chkStockBins6.Checked := false;
end;

procedure TfrmEnablecustomButtons.btnSalesAllOffClick(Sender: TObject);
begin
  chkSalesEdit1.Checked := false;
  chkSalesEdit2.Checked := false;
  chkSalesEdit3.Checked := false;
  chkSalesEdit4.Checked := false;
  chkSalesEdit5.Checked := false;
  chkSalesEdit6.Checked := false;

  chkPurchEdit1.Checked := false;
  chkPurchEdit2.Checked := false;
  chkPurchEdit3.Checked := false;
  chkPurchEdit4.Checked := false;
  chkPurchEdit5.Checked := false;
  chkPurchEdit6.Checked := false;

  chkSalesView1.Checked := false;
  chkSalesView2.Checked := false;
  chkSalesView3.Checked := false;
  chkSalesView4.Checked := false;
  chkSalesView5.Checked := false;
  chkSalesView6.Checked := false;

  chkPurchView1.Checked := false;
  chkPurchView2.Checked := false;
  chkPurchView3.Checked := false;
  chkPurchView4.Checked := false;
  chkPurchView5.Checked := false;
  chkPurchView6.Checked := false;
end;

procedure TfrmEnablecustomButtons.btnStkAdjAllOffClick(Sender: TObject);
begin
  chkStockEdit1.Checked := false;
  chkStockEdit2.Checked := false;
  chkStockEdit3.Checked := false;
  chkStockEdit4.Checked := false;
  chkStockEdit5.Checked := false;
  chkStockEdit6.Checked := false;

  chkStockView1.Checked := false;
  chkStockView2.Checked := false;
  chkStockView3.Checked := false;
  chkStockView4.Checked := false;
  chkStockView5.Checked := false;
  chkStockView6.Checked := false;
end;

procedure TfrmEnablecustomButtons.btnWORAllOffClick(Sender: TObject);
begin
  chkWOREdit1.Checked := false;
  chkWOREdit2.Checked := false;
  chkWOREdit3.Checked := false;
  chkWOREdit4.Checked := false;
  chkWOREdit5.Checked := false;
  chkWOREdit6.Checked := false;

  chkWORView1.Checked := false;
  chkWORView2.Checked := false;
  chkWORView3.Checked := false;
  chkWORView4.Checked := false;
  chkWORView5.Checked := false;
  chkWORView6.Checked := false;
end;

// PKR. 04/11/2015. Add Custom Buttons to Works Order Daybook.
procedure TfrmEnablecustomButtons.btnWORToggleDaybookMainClick(Sender: TObject);
begin
  chkWORDBkMain1.Checked := not chkWORDBkMain1.Checked;
  chkWORDBkMain2.Checked := not chkWORDBkMain2.Checked;
  chkWORDBkMain3.Checked := not chkWORDBkMain3.Checked;
  chkWORDBkMain4.Checked := not chkWORDBkMain4.Checked;
  chkWORDBkMain5.Checked := not chkWORDBkMain5.Checked;
  chkWORDBkMain6.Checked := not chkWORDBkMain6.Checked;
end;

// PKR. 04/11/2015. Add Custom Buttons to Works Order Daybook.
procedure TfrmEnablecustomButtons.btnWORToggleDaybookHistClick(
  Sender: TObject);
begin
  chkWORDBkHistory1.Checked := not chkWORDBkHistory1.Checked;
  chkWORDBkHistory2.Checked := not chkWORDBkHistory2.Checked;
  chkWORDBkHistory3.Checked := not chkWORDBkHistory3.Checked;
  chkWORDBkHistory4.Checked := not chkWORDBkHistory4.Checked;
  chkWORDBkHistory5.Checked := not chkWORDBkHistory5.Checked;
  chkWORDBkHistory6.Checked := not chkWORDBkHistory6.Checked;
end;

end.
