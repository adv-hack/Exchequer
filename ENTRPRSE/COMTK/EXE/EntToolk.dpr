program EntToolk;

uses
  madExcept,
  madLinkDisAsm,
  madListModules,
  ControlsAtomFix in '\Entrprse\Funcs\ControlsAtomFix.pas',
  Forms,
  Windows,
  mainf04 in 'x:\entrprse\comtk\mainf04.pas' {Form1},
  Enterprise04_TLB in 'Enterprise04_TLB.pas',
  oToolKit in '..\oToolKit.pas',

  oOrderPaymentDetails in 'w:\Entrprse\COMTK\oOrderPaymentDetails.pas',
  oOPVATPayBtrieveFile in 'W:\Entrprse\R&D\OrderPayments\oOPVATPayBtrieveFile.pas',
  OrderPaymentsInterfaces in '\Entrprse\R&D\OrderPayments\OrderPaymentsInterfaces.pas',
  oOrderPaymentsTransactionPaymentInfo in '\Entrprse\R&D\OrderPayments\oOrderPaymentsTransactionPaymentInfo.pas',
  oOrderPaymentsBaseTransactionInfo in '\Entrprse\R&D\OrderPayments\oOrderPaymentsBaseTransactionInfo.pas',
  oOrderPayments in 'w:\Entrprse\COMTK\oOrderPayments.pas',
  oOPPayment in '\Entrprse\R&D\OrderPayments\oOPPayment.pas',
  oOPVATPayMemoryList in '\Entrprse\R&D\OrderPayments\oOPVATPayMemoryList.pas',
  oCreditCardGateway in '\Entrprse\R&D\OrderPayments\oCreditCardGateway.pas',
  oOrderPaymentsTransactionInfo in '\Entrprse\R&D\OrderPayments\oOrderPaymentsTransactionInfo.pas',
  oOrderPaymentsSRC in 'w:\Entrprse\R&D\OrderPayments\oOrderPaymentsSRC.pas',
  oOrderPaymentsRefundManager in '\Entrprse\R&D\OrderPayments\oOrderPaymentsRefundManager.pas',
  oOrderPaymentRefundPayments in 'w:\Entrprse\COMTK\oOrderPaymentRefundPayments.pas',
  oOrderPaymentMatching in 'w:\Entrprse\COMTK\oOrderPaymentMatching.pas',
  OrderPaymentsMatching in '\Entrprse\R&D\OrderPayments\OrderPaymentsMatching.pas',
  oOPOrderAuditNotes in '\Entrprse\R&D\OrderPayments\oOPOrderAuditNotes.pas',
    TxStatusF in '\Entrprse\R&D\OrderPayments\TxStatusF.pas',
    ExchequerPaymentGateway_TLB in '\Entrprse\R&D\OrderPayments\ExchequerPaymentGateway_TLB.pas',
    System_TLB in '\Entrprse\R&D\OrderPayments\System_TLB.pas',
    System_Windows_Forms_TLB in '\Entrprse\R&D\OrderPayments\System_Windows_Forms_TLB.pas',
    Accessibility_TLB in '\Entrprse\R&D\OrderPayments\Accessibility_TLB.pas',
    MSCorLib_TLB in '\entrprse\CISXML\MSCorLib_TLB.pas',

  AccountContactRoleUtil in 'w:\ENTRPRSE\R&D\AccountContacts\AccountContactRoleUtil.pas',
  ContactsManager in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManager.pas',
  oAccountContactBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oAccountContactBtrieveFile.pas',
  oAccountContactRoleBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oAccountContactRoleBtrieveFile.pas',
  oContactRoleBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oContactRoleBtrieveFile.pas',
  ContactsManagerPerv in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManagerPerv.pas',
  ContactsManagerSQL in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManagerSQL.pas',
  TransCancelF in '\Entrprse\R&D\OrderPayments\TransCancelF.pas',
  CreditCardUtils in '..\CreditCardUtils.pas',
  oTakePPD in '\Entrprse\R&D\PPD\oTakePPD.pas',

  IntrastatXML in '\ENTRPRSE\R&D\Intrastat\IntrastatXML.pas',

  //PR: 05/09/2017 Added for password complexity changes v2017 R2
  PasswordComplexityConst in 'w:\Entrprse\R&D\Password Complexity\PasswordComplexityConst.pas',
  SHA3_256 in 'w:\Compon\SHA3_256Hash\SHA3_256.pas',
  Mem_Util in 'w:\Compon\SHA3_256Hash\Mem_Util.pas',
  Hash in 'w:\Compon\SHA3_256Hash\Hash.pas',
  BTypes in 'w:\Compon\SHA3_256Hash\BTypes.pas',
  SHA3 in 'w:\Compon\SHA3_256Hash\SHA3.pas';


{$R *.TLB}

{$R *.res}

// MH 30/05/2014 v7.0.10 ABSEXCH-15404: Added PE Flags to force entire component to be loaded into memory
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}

begin
  Application.Initialize;
  Application.Title := 'Exchequer COM Toolkit (EXE)';
  Application.ShowMainForm := False;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
