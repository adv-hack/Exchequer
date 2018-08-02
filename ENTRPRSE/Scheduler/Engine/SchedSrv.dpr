program SchedSrv;

uses
  Sharemem,
  HideMadExcept,
  SvcMgr,
  Serv1 in 'Serv1.pas' {IRISExchequerScheduler: TService},
  Mainf in 'Mainf.PAS' {frmScheduler},
  SysUtils,
  AccountContactRoleUtil in 'w:\ENTRPRSE\R&D\AccountContacts\AccountContactRoleUtil.pas',
  ContactsManager in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManager.pas',
  oAccountContactBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oAccountContactBtrieveFile.pas',
  oAccountContactRoleBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oAccountContactRoleBtrieveFile.pas',
  oContactRoleBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oContactRoleBtrieveFile.pas',
  ContactsManagerPerv in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManagerPerv.pas',
  ContactsManagerSQL in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManagerSQL.pas',
  CustRolesFrame in 'w:\ENTRPRSE\R&D\AccountContacts\CustRolesFrame.pas',
  ContactEditor in 'w:\ENTRPRSE\R&D\AccountContacts\ContactEditor.pas',
  oTakePPD in 'w:\ENTRPRSE\R&D\PPD\oTakePPD.pas',
  PPDLedgerF in 'w:\ENTRPRSE\R&D\PPD\PPDLedgerF.pas',
  oPPDLedgerTransactions in 'w:\ENTRPRSE\R&D\PPD\oPPDLedgerTransactions.pas',

    // Order Payments
    oOPVATPayBtrieveFile in 'w:\Entrprse\R&D\OrderPayments\oOPVATPayBtrieveFile.pas',
    oOPVATPayMemoryList in 'w:\Entrprse\R&D\OrderPayments\oOPVATPayMemoryList.pas',
    oCreditCardGateway in 'w:\Entrprse\R&D\OrderPayments\oCreditCardGateway.pas',
    OrderPaymentsInterfaces in 'w:\Entrprse\R&D\OrderPayments\OrderPaymentsInterfaces.pas',
    oOrderPaymentsBaseTransactionInfo in 'w:\Entrprse\R&D\OrderPayments\oOrderPaymentsBaseTransactionInfo.pas',
    oOrderPaymentsTransactionInfo in 'w:\Entrprse\R&D\OrderPayments\oOrderPaymentsTransactionInfo.pas',
    oOrderPaymentsTransactionPaymentInfo in 'w:\Entrprse\R&D\OrderPayments\oOrderPaymentsTransactionPaymentInfo.pas',
    RefundF in 'w:\Entrprse\R&D\OrderPayments\RefundF.pas',
    RefundPaymentFrame in 'w:\Entrprse\R&D\OrderPayments\RefundPaymentFrame.pas',
    RefundQuantityF in 'w:\Entrprse\R&D\OrderPayments\RefundQuantityF.pas',
    oOrderPaymentsRefundManager in 'w:\Entrprse\R&D\OrderPayments\oOrderPaymentsRefundManager.pas',
    PaymentF in 'w:\Entrprse\R&D\OrderPayments\PaymentF.pas',
    oOPPayment in 'w:\Entrprse\R&D\OrderPayments\oOPPayment.pas',
    oOrderPaymentsSRC in 'w:\Entrprse\R&D\OrderPayments\oOrderPaymentsSRC.pas',
    OrdPayCustomisation in 'w:\Entrprse\R&D\OrderPayments\OrdPayCustomisation.pas',
    OrderPaymentsInvoiceMatching in 'w:\Entrprse\R&D\OrderPayments\OrderPaymentsInvoiceMatching.pas',
    PasswordAuthorisationF in 'w:\Entrprse\R&D\OrderPayments\PasswordAuthorisationF.pas',
    OrderPaymentsMatching in 'w:\Entrprse\R&D\OrderPayments\OrderPaymentsMatching.pas',
    TxStatusF in 'w:\Entrprse\R&D\OrderPayments\TxStatusF.pas',
    ExchequerPaymentGateway_TLB in 'w:\Entrprse\R&D\OrderPayments\ExchequerPaymentGateway_TLB.pas',
    System_TLB in 'w:\Entrprse\R&D\OrderPayments\System_TLB.pas',
    System_Windows_Forms_TLB in 'w:\Entrprse\R&D\OrderPayments\System_Windows_Forms_TLB.pas',
    Accessibility_TLB in 'w:\Entrprse\R&D\OrderPayments\Accessibility_TLB.pas',
    OrderPaymentsUnmatchedReceipts in 'w:\Entrprse\R&D\OrderPayments\OrderPaymentsUnmatchedReceipts.pas',
    TransCancelF in 'w:\Entrprse\R&D\OrderPayments\TransCancelF.pas',
    CISWrite in 'w:\Entrprse\CISXml\CISWrite.pas',
    CISXCnst in 'w:\Entrprse\CISXml\CISXCnst.pas',
    InternetFiling_TLB in 'w:\Entrprse\CISXml\InternetFiling_TLB.pas',
    mscorlib_TLB in 'w:\Entrprse\CISXml\mscorlib_TLB.pas',
  OrderPaymentFuncs in '..\..\R&D\OrderPayments\OrderPaymentFuncs.pas',
  oOPOrderAuditNotes in 'w:\ENTRPRSE\R&D\OrderPayments\oOPOrderAuditNotes.pas',
  OrderPaymentsTrackerF in '\Entrprse\R&D\OrderPayments\OrderPaymentsTrackerF.pas',
  EntLicence in '\entrprse\drilldn\EntLicence.pas', {Lic/Branding Object} // PS/TG 02/02/2016 - ABSEXCH-17220 - Check All Stock Level, SQL improvements
  // VAT 100 Submission
  vatReturnDBManager in '\ENTRPRSE\R&D\VAT100Submission\vatReturnDBManager.pas',
  vatReturnDBManagerPerv in '\ENTRPRSE\R&D\VAT100Submission\vatReturnDBManagerPerv.pas',
  vatReturnDBManagerSQL in '\ENTRPRSE\R&D\VAT100Submission\vatReturnDBManagerSQL.pas',
  vatReturnDetail in '\ENTRPRSE\R&D\VAT100Submission\vatReturnDetail.pas',
  vatReturnHistory in '\ENTRPRSE\R&D\VAT100Submission\vatReturnHistory.pas',
  vatReturnSummary in '\ENTRPRSE\R&D\VAT100Submission\vatReturnSummary.pas',
  vatUtils in '\ENTRPRSE\R&D\VAT100Submission\vatUtils.pas';



{$R *.RES}
{$R Arrows.RES}

var
  sParam : string;

begin
  Application.Initialize;
  Application.CreateForm(TIRISExchequerScheduler, IRISExchequerScheduler);
  sParam := UpperCase(ParamStr(1));
  if (sParam <> '/INSTALL') and (sParam <> '/UNINSTALL') then
  begin
    //PR: 13/12/2013 ABSEXCH-14845 Try to map network drive from ini file first.
    MapDriveFromIniFile;

    Application.CreateForm(TfrmScheduler, frmScheduler);
  end;
  Application.Run;
end.
