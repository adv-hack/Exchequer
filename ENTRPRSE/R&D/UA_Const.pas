unit UA_Const;

interface

const

  uaNoAccess   = -1;   // For use as 'always deny access to this function'
  uaFullAccess = -255; // For use as 'always allow access to this function'

  //Constants for User Access Codes

  uaCopySIN = 101;
  uaCopyPIN = 102;
  uaCopyNMT = 140;
  uaCopyADJ = 123;
  uaCopySOR = 163;
  uaCopyPOR = 173;
  uaCopyWOR = 380;
  uaCopySRN = 522;
  uaCopyPRN = 536;

  uagPurchaseDayBook = 20;
  uaPrintSIN = 4;
  uaPrintPIN = 13;
  uaPrintNMT = 103;
  uaPrintADJ = 119;
  uaPrintSOR = 157;
  uaPrintPOR = 167;
  uaPrintWOR = 377;
  uaPrintSRN = 579;
  uaPrintPRN = 533;

  uaSINDaybook = 1;
  uaSORDaybook = 144;
  uaPINDaybook = 10;
  uaPORDaybook = 164;
  uaNMTDaybook = 24;
  uaADJDaybook = 116;
  uaWORDaybook = 373;
  uaSRNDaybook = 575;
  uaPRNDaybook = 529;
  uaTSHDaybook = 217;


  uagCCDep           = 184; //Group for costcentre/department passwords

  uaAddCostCentre    = 583;
  uaEditCostCentre   = 584;
  uaDeleteCostCentre = 585;
  uaAddDepartment    = 586;
  uaEditDepartment   = 587;
  uaDeleteDepartment = 588;

  uasAddCostCentre    = '184583';
  uasEditCostCentre   = '184584';
  uasDeleteCostCentre = '184585';
  uasAddDepartment    = '184586';
  uasEditDepartment   = '184587';
  uasDeleteDepartment = '184588';

  uagSortView = 185;

  uaAccessSortView = 589;
  uaAddSortView    = 590;
  uaEditSortView   = 591;
  uaDeleteSortView = 592;

  uasAccessSortView = '185589';
  uasAddSortView    = '185590';
  uasEditSortView   = '185591';
  uasDeleteSortView = '185592';


  //PR: 02/06/2010 Added Access eBanking to Utilities
  uagUtilities = 69;

  uaAccessEBanking  = 593;

  uasAccessEBanking = '069593';

  // MH 28/02/2011 v6.7 ABSEXCH-10687:
  uaAccessTraderAudit  = 594;
  uasAccessTraderAudit = '069594';

  // CJS 02/03/2011 v6.7 ABSEXCH-10901:
  uagCustomerDetails = 42;
  uagSupplierDetails = 43;

  uaAddCustomer            = 31;
  uaEditCustomer           = 32;
  uaCustomerViewLedger     = 33;
  uaFindCustomer           = 34;
  uaDeleteCustomer         = 35;
  uaCustomerViewOrderLedger= 37;
  uaCustomerViewHistory    = 38;
  uaCustomerAccessLinks    = 39;
  uaPrintCustomer          = 39;
  uaViewCustomerDiscounts  = 47;
  uaCustomerAccessNotes    = 104;
  uaCustomerStatus         = 142;
  uaCustomerUnallocTrans   = 202;
  uaCustomerCopyReverse    = 254;
  uaCustomerSettle         = 281;
  uaCustomerAllocate       = 285;
  uaAddCustomerDiscount    = 287;
  uaEditCustomerDiscount   = 288;
  uaDeleteCustomerDiscount = 289;
  uaCopyCustomerDiscount   = 290;
  uaCustomerViewBalance    = 404;
  uaCheckCustomerDiscounts = 291;
  uaCustomerPartAllocate   = 411;
  uaCustomerViewJobApplications = 463;
  uaCustomerReturns        = 509;
  uaUnallocateAllCustomerTransactions = 595;
  uaUnallocateAllSupplierTransactions = 596;
  uasAddCustomer            = '042031';
  uasEditCustomer           = '042032';
  uasCustomerViewLedger     = '042033';
  uasFindCustomer           = '042034';
  uasDeleteCustomer         = '042035';
  uasCustomerViewOrderLedger= '042037';
  uasCustomerViewHistory    = '042038';
  uasCustomerAccessLinks    = '042039';
  uasPrintCustomer          = '042039';
  uasViewCustomerDiscounts  = '042047';
  uasCustomerStatus         = '042142';
  uasCustomerUnallocTrans   = '042202';
  uasCustomerCopyReverse    = '042254';
  uasCustomerSettle         = '042281';
  uasCustomerAllocate       = '042285';
  uasAddCustomerDiscount    = '042287';
  uasEditCustomerDiscount   = '042288';
  uasDeleteCustomerDiscount = '042289';
  uasCopyCustomerDiscount   = '042290';
  uasCheckCustomerDiscounts = '042291';
  uasCustomerViewBalance    = '042404';
  uasCustomerPartAllocate   = '042411';
  uasCustomerViewJobApplications = '042463';
  uasCustomerReturns        = '042509';
  uasUnallocateAllCustomerTransactions = '042595';

  uaAddSupplier            = 41;
  uaEditSupplier           = 42;
  uaSupplierViewLedger     = 43;
  uaFindSupplier           = 44;
  uaDeleteSupplier         = 45;
  uaSupplierViewHistory    = 48;
  uaSupplierAccessLinks    = 49;
  uaPrintSupplier          = 49;
  uaSupplierAccessNotes    = 105;
  uaSupplierViewOrderLedger= 179;
  uaViewSupplierDiscounts  = 180;
  uaSupplierStatus         = 181;
  uaSupplierUnallocTrans   = 204;
  uaSupplierCopyReverse    = 255;
  uaSupplierSettle         = 282;
  uaSupplierAllocate       = 286;
  uaAddSupplierDiscount    = 292;
  uaEditSupplierDiscount   = 293;
  uaDeleteSupplierDiscount = 294;
  uaCopySupplierDiscount   = 295;
  uaCheckSupplierDiscounts = 296;
  uaSupplierPartAllocate   = 414;
  uaSupplierViewBalance    = 424;
  uaSupplierViewJobApplications = 464;
  uaSupplierReturns        = 510;

  uasAddSupplier            = '043041';
  uasEditSupplier           = '043042';
  uasSupplierViewLedger     = '043043';
  uasFindSupplier           = '043044';
  uasDeleteSupplier         = '043045';
  uasSupplierViewHistory    = '043048';
  uasSupplierAccessLinks    = '043049';
  uasPrintSupplier          = '043049';
  uasSupplierViewOrderLedger= '043179';
  uasViewSupplierDiscounts  = '043180';
  uasSupplierStatus         = '043181';
  uasSupplierUnallocTrans   = '043204';
  uasSupplierCopyReverse    = '043255';
  uasSupplierSettle         = '043282';
  uasSupplierAllocate       = '043286';
  uasAddSupplierDiscount    = '043292';
  uasEditSupplierDiscount   = '043293';
  uasDeleteSupplierDiscount = '043294';
  uasCopySupplierDiscount   = '043295';
  uasCheckSupplierDiscounts = '043296';
  uasSupplierPartAllocate   = '043414';
  uasSupplierViewBalance    = '043424';
  uasSupplierViewJobApplications = '043464';
  uasSupplierReturns        = '043510';
  uasUnallocateAllSupplierTransactions = '043596';

  // MH 28/02/2011 v6.7 ABSEXCH-10687:
  uaCustomerEditBankDets  = 240;
  uaEditCustomerCreditLimit = 241;
  uaCustomerViewBankDets  = 597;
  uasCustomerEditBankDets = '042240';
  uasEditCustomerCreditLimit = '042241';
  uasCustomerViewBankDets = '042597';

  uaSupplierEditBankDets  = 242;
  uaEditSupplierCreditLimit = 243;
  uaSupplierViewBankDets  = 598;
  uasSupplierEditBankDets = '043242';
  uasEditSupplierCreditLimit = '043243';
  uasSupplierViewBankDets = '043598';

  //PR: 04/10/2011 v6.9 New Custom Fields
  uaAccessCustomFields  = 599;
  uasAccessCustomFields = '069599';

  // CJS 2013-08-02 - ABSEXCH-14408 - Added entry for 'Enforce Hold Flag' (020600)
  uaEnforceHoldFlag = 600;
  uasEnforceHoldFlag = '020600';

  //PR: 30/08/2013 MRD 1.1.08
  uagConsumers = 186;

  uagConsumerRecords   = 187;
  uagConsumerDiscounts = 188;
  uagConsumerMisc      = 189;

  //Consumer Records group
  uaAddConsumer       = 636;
  uaEditConsumer      = 601;
  uaViewConsumerBank  = 602;
  uaEditConsumerBank  = 603;
  uaEditConsumerCreditLimit
                      = 604;
  uaFindConsumer      = 605;
  uaDeleteConsumer    = 606;
  uaPrintConsumer     = 607;

  uasAddConsumer       = '187636';
  uasEditConsumer      = '187601';
  uasViewConsumerBank  = '187602';
  uasEditConsumerBank  = '187603';
  uasEditConsumerCreditLimit
                      = '187604';
  uasFindConsumer      = '187605';
  uasDeleteConsumer    = '187606';
  uasPrintConsumer     = '187607';

  //Consumer Discounts Group
  uaViewConsumerDiscounts   = 608;
  uaAddConsumerDiscount     = 609;
  uaEditConsumerDiscount    = 610;
  uaDeleteConsumerDiscount  = 611;
  uaCopyConsumerDiscount    = 612;
  uaCheckConsumerDiscounts  = 613;

  uasViewConsumerDiscounts  = '188608';
  uasAddConsumerDiscount    = '188609';
  uasEditConsumerDiscount   = '188610';
  uasDeleteConsumerDiscount = '188611';
  uasCopyConsumerDiscount   = '188612';
  uasCheckConsumerDiscount  = '188613';

  //Consumer Misc Group  - leave out Works Order Ledger, JC applications, Discounts (declared above)
  uaConsumerDetailsAccess    = 614;
  uaConsumerViewLedger       = 615;
  uaConsumerCheckAlloc       = 616;
  uaUnallocateAllConsumerTransactions = 617;
  uaConsumerViewOrderLedger  = 618;
  uaConsumerReturns          = 619;
  uaConsumerViewHistory      = 620;
  uaConsumerViewBalance      = 621;
  uaConsumerAccessNotes      = 622;
  uaConsumerStatus           = 623;
  uaConsumerUnallocTrans     = 624;
  uaConsumerCopyReverse      = 625;
  uaConsumerSettle           = 626;
  uaConsumerAllocate         = 627;
  uaConsumerAllocWizard      = 628;
  uaConsumerBlockUnalloc     = 629;
  uaConsumerDeleteStockAnal  = 630;
  uaConsumerAccessLinks      = 631;

  uasConsumerDetailsAccess    = '189614';
  uasConsumerViewLedger       = '189615';
  uasConsumerCheckAlloc       = '189616';
  uasUnallocateAllConsumerTransactions = '189617';
  uasConsumerViewOrderLedger  = '189618';
  uasConsumerReturns          = '189619';
  uasConsumerViewHistory      = '189620';
  uasConsumerViewBalance      = '189621';
  uasConsumerAccessNotes      = '189622';
  uasConsumerStatus           = '189623';
  uasConsumerUnallocTrans     = '189624';
  uasConsumerCopyReverse      = '189625';
  uasConsumerSettle           = '189626';
  uasConsumerAllocate         = '189627';
  uasConsumerAllocWizard      = '189628';
  uasConsumerBlockUnalloc     = '189629';
  uasConsumerDeleteStockAnal  = '189630';
  uasConsumerAccessLinks      = '189631';

  // MH: 06/09/2013 MRD 1.2.09: Added user permissions constants for auto-REceipts
  uagSalesTransactions = 019;
  uagSalesOrderTransactions = 035;

  //PR: 29/08/2014 Order Payments T011 Change Auto-Receipt constant identifiers and add more Order Payment constants
  uagOrderPayments = 190;

  uaSORAllowOrderPaymentsPayment     = 632;
  uaSORDefaultOrderPaymentsPaymentOn = 633;
  uaCustomerAllowOrderPaymentsEdit   = 634;
  uaConsumerAllowOrderPaymentsEdit   = 635;

  uasSORAllowOrderPaymentsPayment     = '190632';
  uasSORDefaultOrderPaymentsPaymentOn = '190633';
  uasCustomerAllowOrderPaymentEdit    = '042634';
  uasConsumerAllowOrderPaymentEdit    = '187635';

  uaSORAllowOrderPaymentsRefund  = 640;
  uasSORAllowOrderPaymentsRefund = '190640';

  uaSDNAllowOrderPaymentsPayment = 641;
  uaSINAllowOrderPaymentsPayment = 642;
  uaSINAllowOrderPaymentsRefund   = 643;

  uasSDNAllowOrderPaymentsPayment = '190641';
  uasSINAllowOrderPaymentsPayment = '190642';
  uasSINAllowOrderPaymentsRefund   = '190643';

  uaAllowCreditCardPayment = 644;
  uaAllowCreditCardRefund  = 645;

  uasAllowCreditCardPayment = '190644';
  uasAllowCreditCardRefund  = '190645';

  uaAccessToCCPaymentGateway = 646;
  uasAccessToCCPaymentGateway = '069646';

  // CJS 2013-09-26 - 7.x MRD1.1.15 - Consumer amendments
  uagJobCostingPurchaseApplications = 166;

  uaDeleteJobPurchaseApplication = 441;

  uasDeleteJobPurchaseApplication = '166441';

  uagJobCostingSalesApplications = 168;

  uaDeleteJobSalesApplication = 450;

  uasDeleteJobSalesApplication = '168450';

  //PR: 21/01/2014 MRD 2.4.09
  uaEditCustomerRoles = 637;
  uaEditSupplierRoles = 638;

  uasEditCustomerRoles = '042637';
  uasEditSupplierRoles = '043638';

  // CJS 2014-07-08 - ABSEXCH-13227 - Password option for budget records
  uagJobCosting = 81;

  uaAccessJobBudgetsMenu = 639;
  uasAccessJobBudgetsMenu = '081639';


  // MH 16/06/2015 Exch-R1 ABSEXCH-16543: Added user permission for End of Day Payments Report
  uagCreditControlReports = 51;

  uaAccessEndOfDayPaymentsReport = 647;
  uasAccessEndOfDayPaymentsReport = '051647';

  //----------------------------------------------------------------------------
  // INTRASTAT
  //----------------------------------------------------------------------------
  // PKR. 07/01/2016. ABSEXCH-17082. Intrastat permissions.
  // 069 = Utilities
  uaIntrastatAccessIntrastatControlCentre  =     648;
  uasIntrastatAccessIntrastatControlCentre = '069648';
  uaIntrastatChangeSettings                =     649;
  uasIntrastatChangeSettings               = '069649';
  uaIntrastatClosePeriod                   =     650;
  uasIntrastatClosePeriod                  = '069650';
  //----------------------------------------------------------------------------


//PR: 02/05/2017 v2017R1 ABSEXCH-18635 Changes to report tree require new permissions

  //Moved Stock Reports
  uagStockReports = 153;

  uaReconciliationValuationReport = 651;
  uasReconciliationValuationReport = '153651';
  uaFinishedGoodsReport = 652;
  uasFinishedGoodsReport = '153652';
  uaStockAgingReport = 653;
  uasStockAgingReport = '153653';

  uaSubContractorsReport = 654;
  uasSubContractorsReport = '081654';

  //RB 06/12/2017 2018-R1 ABSEXCH-19478: 5.2.2 User Permissions - Insert into DB in GEUpgrde + Update User Profile Tree
  uagPIITree = 71;
  uagAnonymisationControlCentre = 72;
  uagEmployees = 104;

  //PII Tree Group
  uaAccessForCustomerConsumer = 655;
  uaAccessForSupplier = 656;
  uaAccessForEmployee = 657;
  uaAllowEditDelete = 658;

  uasAccessForCustomerConsumer = '071655';
  uasAccessForSupplier = '071656';
  uasAccessForEmployee = '071657';
  uasAllowEditDelete = '071658';

  //Anonymisation Control Centre Group
  uaAccessToAnonymisationControlCentre = 659;
  uaAnonymiseCustomerConsumer = 660;
  uaAnonymiseSupplier = 661;
  uaAnonymiseEmployee = 662;
  uaAccessToGDPRConfiguration = 663;

  uasAccessToAnonymisationControlCentre = '072659';
  uasAnonymiseCustomerConsumer = '072660';
  uasAnonymiseSupplier = '072661';
  uasAnonymiseEmployee = '072662';
  uasAccessToGDPRConfiguration = '072663';

  //Employees Group
  uaJobCostingEmployeeRecordsStatus = 664;

  uasJobCostingEmployeeRecordsStatus = '104664';

// Last Used Permission = 664 - uaJobCostingEmployeeRecordsStatus


implementation

end.
