unit PwUpgrade;

{ markd6 17:09 06/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses SysUtils,
     ComCtrls,
     VarConst;


Function SetPermissions(   iVersion  :  Integer;
                            Verbose  :  Boolean;
                        Var ProgBar  :  TProgressBar)  :  Integer;

Function NeedToUpgradePermissions(     iVersion       :  Integer;
                                  Var  ErrStr         :  String;
                                  Var  TotalProgress  :  LongInt;
                                       ForceRun       :  Boolean)  :  Boolean;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  GlobVar,
  Dialogs,
  Forms,
  ETStrU,
  ETMiscU,
  VarRec2U,
  BtrvU2,
  CommonU,
  UA_Const;



Const

   // User Access constants from UA_Const.Pas
   // PKR. 07/01/2016. ABSEXCH-17082. Intrastat
   //RB 06/12/2017 2018-R1 ABSEXCH-19478: 5.2.2 User Permissions - Insert into DB in GEUpgrde + Update User Profile Tree
   Permissions  :  Array[uaAddCostCentre..uaJobCostingEmployeeRecordsStatus] of PassListType =

{* EL: Note, you must set both PassNo, & PassLNo for index purposes.
On page 1 onwards, PassNo is record order relative to page only so it will always start
at 1 for each new page as Passno is a byte

*}

    ((PassList:''; PassGrp:uagCCDep; PassNo:83;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Cost Centre - Allow Add';
                        PassPage:02;  PassLNo:uaAddCostCentre),

     (PassList:''; PassGrp:uagCCDep; PassNo:83;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Cost Centre - Allow Edit';
                        PassPage:02;  PassLNo:uaEditCostCentre),

     (PassList:''; PassGrp:uagCCDep; PassNo:84;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Cost Centre - Allow Delete';
                        PassPage:02;  PassLNo:uaDeleteCostCentre),

     (PassList:''; PassGrp:uagCCDep; PassNo:85;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Department - Allow Add';
                        PassPage:02;  PassLNo:uaAddDepartment),

     (PassList:''; PassGrp:uagCCDep; PassNo:85;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Department - Allow Edit';
                        PassPage:02;  PassLNo:uaEditDepartment),

     (PassList:''; PassGrp:uagCCDep; PassNo:86;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Department - Allow Delete';
                        PassPage:02;  PassLNo:uaDeleteDepartment),


     (PassList:''; PassGrp:uagSortView; PassNo:90;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Sort View - Allow Access';
                        PassPage:02;  PassLNo:uaAccessSortView),

     (PassList:''; PassGrp:uagSortView; PassNo:91;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Sort View - Allow Add';
                        PassPage:02;  PassLNo:uaAddSortView),

     (PassList:''; PassGrp:uagSortView; PassNo:92;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Sort View - Allow Edit';
                        PassPage:02;  PassLNo:uaEditSortView),

     (PassList:''; PassGrp:uagSortView; PassNo:93;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Sort View - Allow Delete';
                        PassPage:02;  PassLNo:uaDeleteSortView),

     (PassList:''; PassGrp:uagUtilities; PassNo:94;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Utilities - Access to eBanking';
                        PassPage:02;  PassLNo:uaAccessEbanking),

     // MH 28/02/2011 v6.7 ABSEXCH-10687:
     // CS 04/03/2013 v7.0.2 ABSEXCH-14074
     (PassList:''; PassGrp:uagUtilities; PassNo:95;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Utilities - Access to System Audit';
                        PassPage:02;  PassLNo:uaAccessTraderAudit),

     // CJS 02/03/2011 v6.7 ABSEXCH-10901:
     (PassList:''; PassGrp:uagCustomerDetails; PassNo:96;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Customer Details - Allow Unallocate All Transactions';
                        PassPage:02;  PassLNo:uaUnallocateAllCustomerTransactions),

     (PassList:''; PassGrp:uagSupplierDetails; PassNo:97;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'SupplierDetails - Allow Unallocate All Transactions';
                        PassPage:02;  PassLNo:uaUnallocateAllSupplierTransactions),

     // MH 30/03/2011 v6.7 ABSEXCH-10689:
     (PassList:''; PassGrp:uagCustomerDetails; PassNo:98;  Spare1:(0,0,0,0,0,0,0,0);
                   PassDesc:'Customer Details - View Bank/Card Details';
                   PassPage:02;  PassLNo:uaCustomerViewBankDets),

     (PassList:''; PassGrp:uagSupplierDetails; PassNo:99;  Spare1:(0,0,0,0,0,0,0,0);
                   PassDesc:'SupplierDetails - View Bank/Card Details';
                   PassPage:02;  PassLNo:uaSupplierViewBankDets),

     //PR: 04/10/2011 v6.9
     (PassList:''; PassGrp:uagUtilities; PassNo:100;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Utilities - Access to Custom Fields';
                        PassPage:02;  PassLNo:uaAccessCustomFields),

     //PR: 04/09/2013 MRD  Add consumer permissions
     (PassList:''; PassGrp:uagConsumerRecords; PassNo:101;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Add';
                        PassPage:02;  PassLNo:uaAddConsumer),

     (PassList:''; PassGrp:uagConsumerRecords; PassNo:102;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Edit';
                        PassPage:02;  PassLNo:uaEditConsumer),

     (PassList:''; PassGrp:uagConsumerRecords; PassNo:103;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - View Bank/Card Details';
                        PassPage:02;  PassLNo:uaViewConsumerBank),

     (PassList:''; PassGrp:uagConsumerRecords; PassNo:104;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Allow Bank Details Edit';
                        PassPage:02;  PassLNo:uaEditConsumerBank),

     (PassList:''; PassGrp:uagConsumerRecords; PassNo:105;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Allow Credit Limit Edit';
                        PassPage:02;  PassLNo:uaEditConsumerCreditLimit),

     (PassList:''; PassGrp:uagConsumerRecords; PassNo:106;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Find Records';
                        PassPage:02;  PassLNo:uaFindConsumer),

     (PassList:''; PassGrp:uagConsumerRecords; PassNo:107;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Delete Records';
                        PassPage:02;  PassLNo:uaDeleteConsumer),

     (PassList:''; PassGrp:uagConsumerRecords; PassNo:108;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Print';
                        PassPage:02;  PassLNo:uaPrintConsumer),


     (PassList:''; PassGrp:uagConsumerDiscounts; PassNo:108;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Discounts';
                        PassPage:02;  PassLNo:uaViewConsumerDiscounts),


     (PassList:''; PassGrp:uagConsumerDiscounts; PassNo:108;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Discounts - Add';
                        PassPage:02;  PassLNo:uaAddConsumerDiscount),

     (PassList:''; PassGrp:uagConsumerDiscounts; PassNo:109;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Discounts - Edit';
                        PassPage:02;  PassLNo:uaEditConsumerDiscount),


     (PassList:''; PassGrp:uagConsumerDiscounts; PassNo:110;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Discounts - Delete';
                        PassPage:02;  PassLNo:uaDeleteConsumerDiscount),

     (PassList:''; PassGrp:uagConsumerDiscounts; PassNo:111;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Discounts - Copy';
                        PassPage:02;  PassLNo:uaCopyConsumerDiscount),

     (PassList:''; PassGrp:uagConsumerDiscounts; PassNo:112;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Discounts - Check';
                        PassPage:02;  PassLNo:uaCheckConsumerDiscounts),

//=============================================
     (PassList:''; PassGrp:uagConsumerMisc; PassNo:113;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Access to';
                        PassPage:02;  PassLNo:uaConsumerDetailsAccess),

     (PassList:''; PassGrp:uagConsumerMisc; PassNo:114;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - View Ledger';
                        PassPage:02;  PassLNo:uaConsumerViewLedger),

     (PassList:''; PassGrp:uagConsumerMisc; PassNo:115;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Check/Re-Calc Allocations';
                        PassPage:02;  PassLNo:uaConsumerCheckAlloc),

     (PassList:''; PassGrp:uagConsumerMisc; PassNo:116;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Allow Unallocate All Transactions';
                        PassPage:02;  PassLNo:uaUnallocateAllConsumerTransactions),

     (PassList:''; PassGrp:uagConsumerMisc; PassNo:117;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - View Order Ledger';
                        PassPage:02;  PassLNo:uaConsumerViewOrderLedger),

     (PassList:''; PassGrp:uagConsumerMisc; PassNo:118;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - View Returns Ledger';
                        PassPage:02;  PassLNo:uaConsumerReturns),

//=============================================
     (PassList:''; PassGrp:uagConsumerMisc; PassNo:119;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - View History';
                        PassPage:02;  PassLNo:uaConsumerViewHistory),

     (PassList:''; PassGrp:uagConsumerMisc; PassNo:120;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - View Balance Information';
                        PassPage:02;  PassLNo:uaConsumerViewBalance),

     (PassList:''; PassGrp:uagConsumerMisc; PassNo:121;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Access to Notes';
                        PassPage:02;  PassLNo:uaConsumerAccessNotes),

     (PassList:''; PassGrp:uagConsumerMisc; PassNo:122;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Status';
                        PassPage:02;  PassLNo:uaConsumerStatus),

     (PassList:''; PassGrp:uagConsumerMisc; PassNo:123;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Unallocate Transactions';
                        PassPage:02;  PassLNo:uaConsumerUnallocTrans),

     (PassList:''; PassGrp:uagConsumerMisc; PassNo:124;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Allow Copy Reverse';
                        PassPage:02;  PassLNo:uaConsumerCopyReverse),

//=============================================
     (PassList:''; PassGrp:uagConsumerMisc; PassNo:125;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Allow Settle';
                        PassPage:02;  PassLNo:uaConsumerSettle),

     (PassList:''; PassGrp:uagConsumerMisc; PassNo:126;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Allow Allocate';
                        PassPage:02;  PassLNo:uaConsumerAllocate),

     (PassList:''; PassGrp:uagConsumerMisc; PassNo:127;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Use Wizard to Allocate';
                        PassPage:02;  PassLNo:uaConsumerAllocWizard),

     (PassList:''; PassGrp:uagConsumerMisc; PassNo:128;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Allow Block Unallocate';
                        PassPage:02;  PassLNo:uaConsumerBlockUnalloc),

     (PassList:''; PassGrp:uagConsumerMisc; PassNo:129;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Stock Analysis - Delete Entry';
                        PassPage:02;  PassLNo:uaConsumerDeleteStockAnal),

     (PassList:''; PassGrp:uagConsumerMisc; PassNo:130;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Access to Links';
                        PassPage:02;  PassLNo:uaConsumerAccessLinks),

     //PR: 22/01/2014 Re-added after overwritten
     // CJS 2013-08-02 - ABSEXCH-14408 - Added entry for 'Enforce Hold Flag' (020600)
     (PassList:''; PassGrp:uagPurchaseDaybook; PassNo:101;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Purchase - Enforce Hold Flag';
                        PassPage:02;  PassLNo:uaEnforceHoldFlag),

     //PR: 21/01/2014 MRD2.4.09 Added Auto-Receipt permissions in order to keep array correct; however, they
     //will be excluded during upgrade by the function IncludePermissions
     //PR: 29/07/2014 changed for Order Payments (T011)
     (PassList:''; PassGrp:uagOrderPayments; PassNo:131;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Sales Orders - Allow Order Payments Payment';
                        PassPage:02;  PassLNo:uaSORAllowOrderPaymentsPayment),

     (PassList:''; PassGrp:uagOrderPayments; PassNo:132;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Sales Orders - Default Order Payments Payment On';
                        PassPage:02;  PassLNo:uaSORDefaultOrderPaymentsPaymentOn),

     // MH 11/09/2014 ABSEXCH-15607: Corrected description to comply with HLD
     (PassList:''; PassGrp:uagCustomerDetails; PassNo:133;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Customer Details - Allow Order Payments Edit';
                        PassPage:02;  PassLNo:uaCustomerAllowOrderPaymentsEdit),

     // MH 11/09/2014 ABSEXCH-15607: Corrected description to comply with HLD
     (PassList:''; PassGrp:uagConsumerRecords; PassNo:134;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Consumer Details - Allow Order Payments Edit';
                        PassPage:02;  PassLNo:uaConsumerAllowOrderPaymentsEdit),

     //PR: 21/01/2014 MRD2.4.09 Contact Roles
     (PassList:''; PassGrp:uagCustomerDetails; PassNo:135;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Customer Details - Allow Roles Edit';
                        PassPage:02;  PassLNo:uaEditCustomerRoles),

     (PassList:''; PassGrp:uagSupplierDetails; PassNo:136;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Supplier Details - Allow Roles Edit';
                        PassPage:02;  PassLNo:uaEditSupplierRoles),

      // CJS 2014-07-08 - ABSEXCH-13227 - Password option for budget records
     (PassList:''; PassGrp:uagJobCosting; PassNo:137;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Job Costing - Access Job Budgets Menu';
                        PassPage:02;  PassLNo:uaAccessJobBudgetsMenu),


     //PR: 29/07/2014 Added for Order Payments (T011)
     (PassList:''; PassGrp:uagOrderPayments; PassNo:138;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Sales Orders - Allow Order Payments Refund';
                        PassPage:02;  PassLNo:uaSORAllowOrderPaymentsRefund),

     (PassList:''; PassGrp:uagOrderPayments; PassNo:139;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Sales Orders - Sales Delivery Notes - Allow Order Payments Payment';
                        PassPage:02;  PassLNo:uaSDNAllowOrderPaymentsPayment),

     (PassList:''; PassGrp:uagOrderPayments; PassNo:140;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Sales Invoices - Allow Order Payments Payment';
                        PassPage:02;  PassLNo:uaSINAllowOrderPaymentsPayment),

     (PassList:''; PassGrp:uagOrderPayments; PassNo:141;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Sales Invoices - Allow Order Payments Refund';
                        PassPage:02;  PassLNo:uaSINAllowOrderPaymentsRefund),

     (PassList:''; PassGrp:uagOrderPayments; PassNo:142;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Allow Credit Card Payments';
                        PassPage:02;  PassLNo:uaAllowCreditCardPayment),

     (PassList:''; PassGrp:uagOrderPayments; PassNo:143;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Allow Credit Card Refunds';
                        PassPage:02;  PassLNo:uaAllowCreditCardRefund),

     (PassList:''; PassGrp:uagUtilities; PassNo:144;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Utilities - Access to Credit Card Payment Gateway';
                        PassPage:02;  PassLNo:uaAccessToCCPaymentGateway),

     // MH 16/06/2015 Exch-R1 ABSEXCH-16543: Added user permission for End of Day Payments Report
     (PassList:''; PassGrp:uagCreditControlReports; PassNo:145;  Spare1:(0,0,0,0,0,0,0,0);
                   PassDesc:'Reports - Print End of Day Payments Report';
                        PassPage:02;  PassLNo:uaAccessEndOfDayPaymentsReport),

     // PKR. 07/01/2016. ABSEXCH-17082. Intrastat
     (PassList:''; PassGrp:uagUtilities; PassNo:146;  Spare1:(0,0,0,0,0,0,0,0);
                   PassDesc:'Utilities - Intrastat - Access to Intrastat Control Centre';
                        PassPage:02;  PassLNo:uaIntrastatAccessIntrastatControlCentre),

     (PassList:''; PassGrp:uagUtilities; PassNo:147;  Spare1:(0,0,0,0,0,0,0,0);
                   PassDesc:'Utilities - Intrastat - Change Settings';
                        PassPage:02;  PassLNo:uaIntrastatChangeSettings),

     (PassList:''; PassGrp:uagUtilities; PassNo:148;  Spare1:(0,0,0,0,0,0,0,0);
                   PassDesc:'Utilities - Intrastat - Close Period';
                        PassPage:02;  PassLNo:uaIntrastatClosePeriod),

     (PassList:''; PassGrp:uagStockReports; PassNo:149;  Spare1:(0,0,0,0,0,0,0,0);
                   PassDesc:'Reports - Reconciliation/Valuation Report';
                        PassPage:02;  PassLNo:uaReconciliationValuationReport),

     (PassList:''; PassGrp:uagStockReports; PassNo:150;  Spare1:(0,0,0,0,0,0,0,0);
                   PassDesc:'Reports - Finished Goods Reconciliation Report';
                        PassPage:02;  PassLNo:uaFinishedGoodsReport),

     (PassList:''; PassGrp:uagStockReports; PassNo:151;  Spare1:(0,0,0,0,0,0,0,0);
                   PassDesc:'Reports - Stock Aging Report';
                        PassPage:02;  PassLNo:uaStockAgingReport),

     (PassList:''; PassGrp:uagJobCosting; PassNo:152;  Spare1:(0,0,0,0,0,0,0,0);
                   PassDesc:'Job Costing - Reports, Sub-Contractors List';
                        PassPage:02;  PassLNo:uaSubContractorsReport),

     //RB 06/12/2017 2018-R1 ABSEXCH-19478: 5.2.2 User Permissions - Insert into DB in GEUpgrde + Update User Profile Tree
     (PassList:''; PassGrp:uagPIITree; PassNo:153;  Spare1:(0,0,0,0,0,0,0,0);
                   PassDesc:'Access for Customer/Consumer';
                        PassPage:02;  PassLNo:uaAccessForCustomerConsumer),

     (PassList:''; PassGrp:uagPIITree; PassNo:154;  Spare1:(0,0,0,0,0,0,0,0);
                   PassDesc:'Access for Supplier';
                        PassPage:02;  PassLNo:uaAccessForSupplier),

     (PassList:''; PassGrp:uagPIITree; PassNo:155;  Spare1:(0,0,0,0,0,0,0,0);
                   PassDesc:'Access for Employee';
                        PassPage:02;  PassLNo:uaAccessForEmployee),

     (PassList:''; PassGrp:uagPIITree; PassNo:156;  Spare1:(0,0,0,0,0,0,0,0);
                   PassDesc:'Allow Edit/Delete';
                        PassPage:02;  PassLNo:uaAllowEditDelete),

     (PassList:''; PassGrp:uagAnonymisationControlCentre; PassNo:157;  Spare1:(0,0,0,0,0,0,0,0);
                   PassDesc:'Access to Anonymisation Control Centre';
                        PassPage:02;  PassLNo:uaAccessToAnonymisationControlCentre),

     (PassList:''; PassGrp:uagAnonymisationControlCentre; PassNo:158;  Spare1:(0,0,0,0,0,0,0,0);
                   PassDesc:'Anonymise Customer/Consumer';
                        PassPage:02;  PassLNo:uaAnonymiseCustomerConsumer),

     (PassList:''; PassGrp:uagAnonymisationControlCentre; PassNo:159;  Spare1:(0,0,0,0,0,0,0,0);
                   PassDesc:'Anonymise Supplier';
                        PassPage:02;  PassLNo:uaAnonymiseSupplier),

     (PassList:''; PassGrp:uagAnonymisationControlCentre; PassNo:160;  Spare1:(0,0,0,0,0,0,0,0);
                   PassDesc:'Anonymise Employee';
                        PassPage:02;  PassLNo:uaAnonymiseEmployee),

     (PassList:''; PassGrp:uagAnonymisationControlCentre; PassNo:161;  Spare1:(0,0,0,0,0,0,0,0);
                   PassDesc:'Access to GDPR Configuration';
                        PassPage:02;  PassLNo:uaAccessToGDPRConfiguration),

     (PassList:''; PassGrp:uagEmployees; PassNo:162;  Spare1:(0,0,0,0,0,0,0,0);
                   PassDesc:'Job Costing - Employee Records, Status';
                        PassPage:02;  PassLNo:uaJobCostingEmployeeRecordsStatus)
  );







  { Result

    -1 Routine failed to initilaise, prob caused by bad Btrieve installation or bad dir

     0 = Success

     1-255  Btrieve error in file PwrdF

  }

//PR: 21/01/2014 MRD2.4.09 Function to exclude Auto-Receipt passwords until they are needed
//PR: 29/07/2014 Always true for order payments. Keep function in case we need to add new permissions
//               to Exchequer before Order Payments is released.
function IncludePermission(PermissionNo : integer) : Boolean;
begin
  Result := True;

//  Result := (PermissionNo < uaSalesQuotesAllowOrderPayments) or (PermissionNo > uaConsumerAllowOrderPaymentEdit);
end;


Function SetPermissions(   iVersion  :  Integer;
                            Verbose  :  Boolean;
                        Var ProgBar  :  TProgressBar)  :  Integer;


var
   KeyF          :   Str255;

   NextNo        :   LongInt;

Begin
  Result:=-1; {Never got started}

  Open_System(PWrdF,PWrdF);

  try

    // For NextNo:=PermissionNos[iLatestVersion] to PermissionNos[iLatestVersion + 1] do

    // CJS 02/03/2011 v6.7 ABSEXCH-10901:
    for NextNo := Low(Permissions) to High(Permissions) do
    //PR: 21/01/2014 MRD2.4.09 Check function to exclude Auto-Receipt passwords until they are needed
    if IncludePermission(NextNo) then
    With PassWord do
    Begin
      Result:=0;

      Application.ProcessMessages;

      KeyF:='L'+#0+SetPadNo(Form_Int(Permissions[NextNo].PassGrp,0),3)+SetPadNo(Form_Int(Permissions[NextNo].PassLNo,0),3);

      Status:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,0,KeyF);

      If (Status=0) then
        Status:=Delete_Rec(F[PWrdF],PWrdF,0);

      FillChar(PassWord,Sizeof(PassWord),0);

      RecPfix:='L';

      PassListRec:=Permissions[NextNo];

      FillChar(PassListRec.Spare2,Sizeof(PassListRec.Spare2),0);

      PassListRec.PassList:=SetPadNo(Form_Int(PassListRec.PassGrp,0),3)+SetPadNo(Form_Int(PassListRec.PassLNo,0),3);

      Inc(TotalCount);

      If (Verbose) and (Assigned(ProgBar)) then
        ProgBar.Position:=TotalCount;

      Application.ProcessMessages;

      Status:=Add_Rec(F[PWrdF],PWrdF,RecPtr[PWrdF]^,0);

      If (Result=0) then {* only show this once *}
        Report_BError(PwrdF,Status);

      If (Status<>0) then
        Result:=Status;

      //Writeln(PassListRec.PassDesc,' - Status: ',Status:5);
    end;
  Finally
    Close_Files(True);
  end; {Try..}
end; {Proc..}

//-------------------------------------------------------------------------

// Function to check for the presence of User Permission Master Records for a version
Function NeedToUpgradePermissions(     iVersion       :  Integer;
                                  Var  ErrStr         :  String;
                                  Var  TotalProgress  :  LongInt;
                                       ForceRun       :  Boolean)  :  Boolean;
Var
  KeyF                                      : Str255;
  TestForPermission, NumberOfNewPermissions : LongInt;
Begin // NeedToUpgradePermissions
  { CJS 2013-03-04 - ABSEXCH-14074 - wrong "Audit" label }
  Result := False;

  // iVersion maps onto NoUpgrades in CommonU.Pas
  Case iVersion of
    8 : Begin
           ErrStr := 'v6.4';
           TestForPermission := uaAccessEBanking;      // Already present if this permission exists
           NumberOfNewPermissions := 11;
        End;
    9 : Begin
           ErrStr := 'v6.7';
           TestForPermission := uaAccessTraderAudit;   // Already present if this permission exists
           NumberOfNewPermissions := 5;
        End;
   10 : Begin
           ErrStr := 'v6.9';
           TestForPermission := uaAccessCustomFields;   // Already present if this permission exists
           NumberOfNewPermissions := 1;
        End;
   { CJS 2013-03-04 - ABSEXCH-14074 - wrong "Audit" label }
   11 : Begin
           ErrStr := 'v7.0.2';
           NumberOfNewPermissions := 0;                 // Modifying an existing permission
           Result := True;
        End;
   12 : Begin
           ErrStr := 'v7.0.5';
           NumberOfNewPermissions := 1;
           Result := True;
        End;
   13 : Begin
           ErrStr := 'v7.0.8';
           TestForPermission := uaConsumerAccessLinks; // Already present if this permission exists
           NumberOfNewPermissions := 26;
        End;
   14 : Begin
           ErrStr := 'v7.0.9';
           TestForPermission := uaEditSupplierRoles; // Already present if this permission exists
           NumberOfNewPermissions := 2;
        End;
   15 : Begin
           ErrStr := 'v2015 R1'; //PR: 09/05/2016 ABSEXCH-17421 Changed from invalid version no
           TestForPermission := uaAccessToCCPaymentGateway; // Already present if this permission exists
           NumberOfNewPermissions := 11;
        End;
   16 : Begin
           ErrStr := 'v2016.R1';
           TestForPermission := uaIntrastatClosePeriod; // Already present if this permission exists
           NumberOfNewPermissions := 3;
        End;
   17 : Begin
           ErrStr := 'v2017 R1';
           TestForPermission := uaSubContractorsReport; // Already present if this permission exists
           NumberOfNewPermissions := 4;
        End;
   18 : Begin
           //RB 06/12/2017 2018-R1 ABSEXCH-19478: 5.2.2 User Permissions - Insert into DB in GEUpgrde + Update User Profile Tree
           ErrStr := 'v2018 R1';
           TestForPermission := uaJobCostingEmployeeRecordsStatus; // Already present if this permission exists
           NumberOfNewPermissions := 10;
        End;
  Else
    Raise Exception.Create ('GEUpgrde.NeedToUpgradePermissions: Unsupported Version (' + IntToStr(iVersion) + ')');
  End; // Case iVersion

  if not Result then
  begin
    Open_System(PWrdF,PWrdF);
    try
      KeyF:='L'+#0+SetPadNo(Form_Int(Permissions[TestForPermission].PassGrp,0),3)+SetPadNo(Form_Int(Permissions[TestForPermission].PassLNo,0),3);

      Status:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,0,KeyF);

      Result := (Status = 4) Or ForceRun;

      If (Result) then
        TotalProgress := TotalProgress + NumberOfNewPermissions;
    finally
      Close_Files(True);
    end; {try..}
  end; // if not Result...
End; // NeedToUpgradePermissions

//=========================================================================

end.