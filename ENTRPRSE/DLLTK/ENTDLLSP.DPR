library EntDllSp;
{$WARN SYMBOL_PLATFORM OFF}
{$REALCOMPATIBILITY ON}
uses
  ControlsAtomFix in '\Entrprse\Funcs\ControlsAtomFix.pas',
  spdlinit in 'spdlinit.pas',
  DllConv in 'DllConv.pas',
  SpDllErr in 'SpDllErr.pas',
  SpReturn in 'SpReturn.pas',
  AccountContactRoleUtil in 'w:\ENTRPRSE\R&D\AccountContacts\AccountContactRoleUtil.pas',
  ContactsManager in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManager.pas',
  oAccountContactBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oAccountContactBtrieveFile.pas',
  oAccountContactRoleBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oAccountContactRoleBtrieveFile.pas',
  oContactRoleBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oContactRoleBtrieveFile.pas',
  ContactsManagerPerv in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManagerPerv.pas',
  ContactsManagerSQL in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManagerSQL.pas',
  CustRolesFrame in 'w:\ENTRPRSE\R&D\AccountContacts\CustRolesFrame.pas',
  ContactEditor in 'w:\ENTRPRSE\R&D\AccountContacts\ContactEditor.pas',
  EntLicence in 'w:\ENTRPRSE\DrillDn\EntLicence.pas',
  oTakePPD in '\Entrprse\R&D\PPD\oTakePPD.pas',
  oPPDLedgerTransactions in '\Entrprse\R&D\PPD\oPPDLedgerTransactions.pas',
  PPDLedgerF in '\Entrprse\R&D\PPD\PPDLedgerF.pas',

    // Order Payments
    MSCorLib_TLB in '\entrprse\CISXML\MSCorLib_TLB.pas',
    oOPVATPayBtrieveFile in '\Entrprse\R&D\OrderPayments\oOPVATPayBtrieveFile.pas',
    oOPVATPayMemoryList in '\Entrprse\R&D\OrderPayments\oOPVATPayMemoryList.pas',
    oCreditCardGateway in '\Entrprse\R&D\OrderPayments\oCreditCardGateway.pas',
    OrderPaymentsInterfaces in '\Entrprse\R&D\OrderPayments\OrderPaymentsInterfaces.pas',
    oOrderPaymentsBaseTransactionInfo in '\Entrprse\R&D\OrderPayments\oOrderPaymentsBaseTransactionInfo.pas',
    oOrderPaymentsTransactionInfo in '\Entrprse\R&D\OrderPayments\oOrderPaymentsTransactionInfo.pas',
    oOrderPaymentsTransactionPaymentInfo in '\Entrprse\R&D\OrderPayments\oOrderPaymentsTransactionPaymentInfo.pas',
    oOrderPaymentsRefundManager in '\Entrprse\R&D\OrderPayments\oOrderPaymentsRefundManager.pas',
    oOPPayment in '\Entrprse\R&D\OrderPayments\oOPPayment.pas',
    oOrderPaymentsSRC in '\Entrprse\R&D\OrderPayments\oOrderPaymentsSRC.pas',
    OrdPayCustomisation in '\Entrprse\R&D\OrderPayments\OrdPayCustomisation.pas',
    OrderPaymentsInvoiceMatching in '\Entrprse\R&D\OrderPayments\OrderPaymentsInvoiceMatching.pas',
    PasswordAuthorisationF in '\Entrprse\R&D\OrderPayments\PasswordAuthorisationF.pas',
    OrderPaymentsMatching in '\Entrprse\R&D\OrderPayments\OrderPaymentsMatching.pas',
    TxStatusF in '\Entrprse\R&D\OrderPayments\TxStatusF.pas',
    ExchequerPaymentGateway_TLB in '\Entrprse\R&D\OrderPayments\ExchequerPaymentGateway_TLB.pas',
    System_TLB in '\Entrprse\R&D\OrderPayments\System_TLB.pas',
    System_Windows_Forms_TLB in '\Entrprse\R&D\OrderPayments\System_Windows_Forms_TLB.pas',
    Accessibility_TLB in '\Entrprse\R&D\OrderPayments\Accessibility_TLB.pas',
    TransCancelF in '\Entrprse\R&D\OrderPayments\TransCancelF.pas',
    OrderPaymentsUnmatchedReceipts in '\Entrprse\R&D\OrderPayments\OrderPaymentsUnmatchedReceipts.pas',
	oOPOrderAuditNotes in '\Entrprse\R&D\OrderPayments\oOPOrderAuditNotes.pas',
  OrderPaymentsTrackerF in '\Entrprse\R&D\OrderPayments\OrderPaymentsTrackerF.pas',
  vatReturnDBManager in '\ENTRPRSE\R&D\VAT100Submission\vatReturnDBManager.pas',
  vatReturnDBManagerPerv in '\ENTRPRSE\R&D\VAT100Submission\vatReturnDBManagerPerv.pas',
  vatReturnDBManagerSQL in '\ENTRPRSE\R&D\VAT100Submission\vatReturnDBManagerSQL.pas',
  vatReturnDetail in '\ENTRPRSE\R&D\VAT100Submission\vatReturnDetail.pas',
  vatReturnHistory in '\ENTRPRSE\R&D\VAT100Submission\vatReturnHistory.pas',
  vatReturnSummary in '\ENTRPRSE\R&D\VAT100Submission\vatReturnSummary.pas',
  vatUtils in '\ENTRPRSE\R&D\VAT100Submission\vatUtils.pas',

  //PR: 05/09/2017 Added for password complexity changes v2017 R2
  PasswordComplexityConst in 'w:\Entrprse\R&D\Password Complexity\PasswordComplexityConst.pas',
  SHA3_256 in 'w:\Compon\SHA3_256Hash\SHA3_256.pas',
  Mem_Util in 'w:\Compon\SHA3_256Hash\Mem_Util.pas',
  Hash in 'w:\Compon\SHA3_256Hash\Hash.pas',
  BTypes in 'w:\Compon\SHA3_256Hash\BTypes.pas',
  SHA3 in 'w:\Compon\SHA3_256Hash\SHA3.pas',

  // Intrastat ----------------------
  IntrastatXML in '\Entrprse\R&D\Intrastat\IntrastatXML.pas',
  IntrastatDetailsF in '\Entrprse\R&D\Intrastat\IntrastatDetailsF.pas', {TIntrastatDetailsFrm}

  // GDPR ----------------------------
  GDPRConst in '\Entrprse\R&D\GDPR\GDPRConst.pas'

  ;


{$R *.res}

Exports
  SP_INITDLL  Index 1,             {SpDlInit.pas}
  SP_CLOSEDLL  Index 2,            {SpDlInit.pas}
  SP_VERSION  Index 3,             {SpDlInit.pas}
  SP_CHECKCONVERSION  Index 4,     {DllConv.pas}
  SP_CONVERTTRANSACTION  Index 5,  {DllConv.pas}
  SP_COPYTRANSACTION  Index 6,     {DllConv.pas}
  SP_REVERSETRANSACTION  Index 7,
  SP_BACKTOBACKORDER Index 8,      {DllConv.pas}
  SP_INITDLLPATH Index 9,          {SpDlInit.pas}
  SP_SETRELEASECODE Index 10,      {SpDlInit.pas}
  SP_CREATERETURN Index 11,        {SpReturn.pas}
  SP_ACTIONRETURN Index 12,        {SpReturn.pas}
  SP_UPDATERECONCILEFLAG Index 13; {DllConv.pas}

end.
