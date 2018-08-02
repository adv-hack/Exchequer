program SchedEng;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  D6OnHelpFix,
  conHTMLHelp,
  Forms,
  Windows,
  Mainf in 'Mainf.PAS' {frmScheduler},
  SchThred in 'SchThred.pas',
  Trayf in 'Trayf.pas' {frmSchedTray},
  ChkPrntr,
  VAOUtil,
  PrevInst2,
  LogF in 'LogF.pas',
  EmailSet in 'EmailSet.pas',
  AccountContactRoleUtil in '..\..\R&D\AccountContacts\AccountContactRoleUtil.pas',
  ContactsManager in '..\..\R&D\AccountContacts\ContactsManager.pas',
  oAccountContactBtrieveFile in '..\..\R&D\AccountContacts\oAccountContactBtrieveFile.pas',
  oAccountContactRoleBtrieveFile in '..\..\R&D\AccountContacts\oAccountContactRoleBtrieveFile.pas',
  oContactRoleBtrieveFile in '..\..\R&D\AccountContacts\oContactRoleBtrieveFile.pas',
  ContactsManagerPerv in '..\..\R&D\AccountContacts\ContactsManagerPerv.pas',
  ContactsManagerSQL in '..\..\R&D\AccountContacts\ContactsManagerSQL.pas',
  CustRolesFrame in '..\..\R&D\AccountContacts\CustRolesFrame.pas',
  ContactEditor in '..\..\R&D\AccountContacts\ContactEditor.pas',
  oOPVATPayBtrieveFile in '..\..\R&D\OrderPayments\oOPVATPayBtrieveFile.pas',
  oOPVATPayMemoryList in '..\..\R&D\OrderPayments\oOPVATPayMemoryList.pas',
  oCreditCardGateway in '..\..\R&D\OrderPayments\oCreditCardGateway.pas',
  OrderPaymentsInterfaces in '..\..\R&D\OrderPayments\OrderPaymentsInterfaces.pas',
  oOrderPaymentsBaseTransactionInfo in '..\..\R&D\OrderPayments\oOrderPaymentsBaseTransactionInfo.pas',
  oOrderPaymentsTransactionInfo in '..\..\R&D\OrderPayments\oOrderPaymentsTransactionInfo.pas',
  oOrderPaymentsTransactionPaymentInfo in '..\..\R&D\OrderPayments\oOrderPaymentsTransactionPaymentInfo.pas',
  RefundF in '..\..\R&D\OrderPayments\RefundF.pas',
  RefundPaymentFrame in '..\..\R&D\OrderPayments\RefundPaymentFrame.pas',
  RefundQuantityF in '..\..\R&D\OrderPayments\RefundQuantityF.pas',
  oOrderPaymentsRefundManager in '..\..\R&D\OrderPayments\oOrderPaymentsRefundManager.pas',
  PaymentF in '..\..\R&D\OrderPayments\PaymentF.pas',
  oOPPayment in '..\..\R&D\OrderPayments\oOPPayment.pas',
  oOrderPaymentsSRC in '..\..\R&D\OrderPayments\oOrderPaymentsSRC.pas',
  OrdPayCustomisation in '..\..\R&D\OrderPayments\OrdPayCustomisation.pas',
  OrderPaymentsInvoiceMatching in '..\..\R&D\OrderPayments\OrderPaymentsInvoiceMatching.pas',
  PasswordAuthorisationF in '..\..\R&D\OrderPayments\PasswordAuthorisationF.pas',
  OrderPaymentsMatching in '..\..\R&D\OrderPayments\OrderPaymentsMatching.pas',
  TxStatusF in '..\..\R&D\OrderPayments\TxStatusF.pas',
  ExchequerPaymentGateway_TLB in '..\..\R&D\OrderPayments\ExchequerPaymentGateway_TLB.pas',
  System_TLB in '..\..\R&D\OrderPayments\System_TLB.pas',
  System_Windows_Forms_TLB in '..\..\R&D\OrderPayments\System_Windows_Forms_TLB.pas',
  Accessibility_TLB in '..\..\R&D\OrderPayments\Accessibility_TLB.pas',
  OrderPaymentsUnmatchedReceipts in '..\..\R&D\OrderPayments\OrderPaymentsUnmatchedReceipts.pas',
  TransCancelF in '..\..\R&D\OrderPayments\TransCancelF.pas',
  CISWrite in '..\..\CISXml\CISWrite.pas',
  CISXCnst in '..\..\CISXml\CISXCnst.pas',
  InternetFiling_TLB in '..\..\CISXml\InternetFiling_TLB.pas',
  mscorlib_TLB in '..\..\CISXml\mscorlib_TLB.pas',
  OrderPaymentFuncs in '..\..\R&D\OrderPayments\OrderPaymentFuncs.pas',
  oOPOrderAuditNotes in '..\..\R&D\OrderPayments\oOPOrderAuditNotes.pas',
  IntrastatControlCentreF in '..\..\R&D\Intrastat\IntrastatControlCentreF.pas',
  IntrastatXML in '..\..\R&D\Intrastat\IntrastatXML.pas',
  IntrastatDetailsF in '..\..\R&D\Intrastat\IntrastatDetailsF.pas' {IntrastatDetailsFrm},
  IntrastatDataClass in '..\..\R&D\Intrastat\IntrastatDataClass.pas',
  UKIntrastatReport in '..\..\R&D\Intrastat\UKIntrastatReport.pas',
  vatReturnDBManager in '..\..\R&D\VAT100Submission\vatReturnDBManager.pas',
  vatReturnDBManagerPerv in '..\..\R&D\VAT100Submission\vatReturnDBManagerPerv.pas',
  vatReturnDBManagerSQL in '..\..\R&D\VAT100Submission\vatReturnDBManagerSQL.pas',
  vatReturnDetail in '..\..\R&D\VAT100Submission\vatReturnDetail.pas',
  vatReturnHistory in '..\..\R&D\VAT100Submission\vatReturnHistory.pas',
  vatReturnSummary in '..\..\R&D\VAT100Submission\vatReturnSummary.pas',
  vatUtils in '..\..\R&D\VAT100Submission\vatUtils.pas',
  EntLicence in '..\..\drilldn\EntLicence.pas',
  oTakePPD in '..\..\R&D\PPD\oTakePPD.pas',
  PPDLedgerF in '..\..\R&D\PPD\PPDLedgerF.pas',
  oPPDLedgerTransactions in '..\..\R&D\PPD\oPPDLedgerTransactions.pas',
  OrderPaymentsTrackerF in '..\..\R&D\OrderPayments\OrderPaymentsTrackerF.pas',
  GDPRConst in 'w:\Entrprse\R&D\GDPR\GDPRConst.pas',
  oAnonymisationDiaryObjIntf in 'w:\Entrprse\R&D\GDPR\oAnonymisationDiaryObjIntf.pas',
  oAnonymisationDiaryObjList in 'w:\Entrprse\R&D\GDPR\oAnonymisationDiaryObjList.pas',
  oAnonymisationDiaryObjDetail in 'w:\Entrprse\R&D\GDPR\oAnonymisationDiaryObjDetail.pas',
  oSQLLoadAnonymisationDiary in 'w:\Entrprse\R&D\GDPR\oSQLLoadAnonymisationDiary.pas',
  AnonymisationControlCentreF in 'w:\Entrprse\R&D\GDPR\AnonymisationControlCentreF.pas' {frmAnonymisationControlCentre},
  AnonymiseUtil in 'w:\Entrprse\R&D\GDPR\AnonymiseUtil.pas',
  oContactsFile in 'w:\Entrprse\R&D\GDPR\oContactsFile.pas',
  GDPRConfigF in 'w:\Entrprse\R&D\GDPR\GDPRConfigF.pas'; {TfrmGDPRConfiguration}


{$R *.RES}

{$R Arrows.RES}

{$IFDEF BindingRTLI} {* Include Run time Line Information *}
  {$R *.RLI}
{$ENDIF}


begin
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.Title := 'Exchequer Scheduler';
  Application.HelpFile := 'ExSched.chm';
  if AppIsRunning(False) and (VAOInfo.vaoMode <> smVAO) then EXIT;
  Application.CreateForm(TfrmScheduler, frmScheduler);
  Application.CreateForm(TfrmSchedTray, frmSchedTray);
  Application.Run;
end.
