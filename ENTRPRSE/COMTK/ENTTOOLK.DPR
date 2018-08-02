library EntToolk;

{$REALCOMPATIBILITY ON}

uses
  madExcept,
  madLinkDisAsm,
  madListModules,
  ControlsAtomFix in '\Entrprse\Funcs\ControlsAtomFix.pas',
  Comserv,
  FirstU,
  Forms,
  Windows,
  MainF in 'MainF.pas' {Form2},
  oToolKit in 'oToolKit.pas',
  oCust in 'oCust.pas',
  Enterprise01_TLB in 'Enterprise01_TLB.pas',
  OTrans in 'OTrans.pas',
  oBtrieve in 'oBtrieve.pas',
  oAddr in 'oAddr.pas',
  Crypto in '\Entrprse\MULTCOMP\Crypto.pas',
  MiscFunc in 'MiscFunc.Pas',
  VarToolK in 'VarToolK.pas',
  oCustBal in 'oCustBal.pas',
  Ofuncs in 'Ofuncs.pas',
  oLines in 'oLines.pas',
  oLine in 'oLine.pas',
  oSetup in 'oSetup.pas',
  oStock in 'oStock.pas',
  Ostock2 in 'Ostock2.pas',
  oConfig in 'oConfig.pas',
  MemMap in '\Entrprse\R&D\Memmap.pas',
  oEntrprs in 'oEntrprs.pas',
  oGL in 'oGL.pas',
  OLoc in 'OLoc.pas',
  oCCDept in 'oCCDept.pas',
  oCompany in 'oCompany.pas',
  oStkLoc in 'oStkLoc.pas',
  oNotes in 'oNotes.pas',
  oJobCost in 'oJobCost.pas',
  oJob in 'oJob.pas',
  oMatch in 'oMatch.pas',
  oAcDisc in 'oAcDisc.pas',
  oEBus in 'oEBus.pas',
  oQtyBrk in 'oQtyBrk.pas',
  oJobType in 'oJobType.pas',
  oJobAnal in 'oJobAnal.pas',
  comdll1 in 'Browser\COMDLL1.PAS',
  intform in 'Browser\IntForm.pas' {frmInterface},
  oSTKBOM in 'oSTKBOM.pas',
  OStkBomL in 'OStkBomL.PAS',
  oEmploy in 'oEmploy.pas',
  oRates in 'oRates.pas',
  oSerial in 'oSerial.pas',
  OLINESNO in 'OLINESNO.PAS',
  SecCodes in 'SECCODES.PAS',
  LogFile in 'LogFile.pas',
  LicRec in '\sbslib\win\excommon\LicRec.pas',
  oUser in 'oUser.pas',
  oDetails in 'oDetails.pas',
  oViews in 'oViews.pas',
  oViewLns in 'oViewLns.pas',
  OLINKS in 'OLINKS.PAS',
  oAuto in 'oAuto.pas',
  oConvert in 'oConvert.pas',
  oB2B in 'oB2B.pas',
  oTmpFile in 'oTmpFile.pas',
  DelTemp in '\Entrprse\FormTK\DELTEMP.PAS',
  oPJEmail in 'oPJEmail.pas',
  OPJEMAIL2 in 'OPJEMAIL2.PAS',
  oPJEmail3 in 'oPJEmail3.pas',
  oPJFile in 'oPJFile.PAS',
  oFormInf in 'oFormInf.pas',
  oDataLst in 'oDataLst.pas',
  oJobAct in 'oJobAct.pas',
  oJobRet in 'oJobRet.pas',
  oJobBud in 'oJobBud.pas',
  oVoucher in 'oVoucher.pas',
  oJobInv in 'oJobInv.pas',
  oCcyTri in 'oCcyTri.pas',
  oAltStk in 'oAltStk.pas',
  oMultBin in 'oMultBin.pas',
  oLineBin in 'oLineBin.pas',
  oCSAnal in 'oCSAnal.pas',
  oAppView in 'oAppView.pas',
  oJobApps in 'oJobApps.pas',
  COMTKVER in 'COMTKVER.pas',
  TransBd in 'TransBd.pas',
  oReturns in 'oReturns.pas',
  dll_abstl in '\Entrprse\DLLTK\dll_abstl.pas',
  oBanking in 'oBanking.pas',
  oBankAcc in 'oBankAcc.pas',
  Validate in '\Entrprse\DLLTK\Validate.pas',
  TkSQL in 'TkSQL.pas',
  Profile in 'Profile.pas',
  CacheStat in 'CacheStat.pas',
  oMultiBuy in 'oMultiBuy.pas',
  TKTTDCalc in '..\DLLTK\TKTTDCalc.pas',
  CRECache in '..\FUNCS\CRECache.pas',

  oOrderPaymentDetails in 'oOrderPaymentDetails.pas',
  oOPVATPayBtrieveFile in 'W:\Entrprse\R&D\OrderPayments\oOPVATPayBtrieveFile.pas',
  OrderPaymentsInterfaces in '\Entrprse\R&D\OrderPayments\OrderPaymentsInterfaces.pas',
  oOrderPaymentsTransactionPaymentInfo in '\Entrprse\R&D\OrderPayments\oOrderPaymentsTransactionPaymentInfo.pas',
  oOrderPaymentsBaseTransactionInfo in '\Entrprse\R&D\OrderPayments\oOrderPaymentsBaseTransactionInfo.pas',
  oOrderPayments in 'oOrderPayments.pas',
  oOPPayment in '\Entrprse\R&D\OrderPayments\oOPPayment.pas',
  oOPVATPayMemoryList in '\Entrprse\R&D\OrderPayments\oOPVATPayMemoryList.pas',
  oCreditCardGateway in '\Entrprse\R&D\OrderPayments\oCreditCardGateway.pas',
  oOrderPaymentsTransactionInfo in '\Entrprse\R&D\OrderPayments\oOrderPaymentsTransactionInfo.pas',
  oOrderPaymentsSRC in 'w:\Entrprse\R&D\OrderPayments\oOrderPaymentsSRC.pas',
  oOrderPaymentsRefundManager in '\Entrprse\R&D\OrderPayments\oOrderPaymentsRefundManager.pas',
  oOrderPaymentRefundPayments in 'oOrderPaymentRefundPayments.pas',
  OrderPaymentsMatching in '\Entrprse\R&D\OrderPayments\OrderPaymentsMatching.pas',
  oOrderPaymentMatching in 'w:\Entrprse\COMTK\oOrderPaymentMatching.pas',
  ExchequerPaymentGateway_TLB in 'W:\Entrprse\R&D\OrderPayments\ExchequerPaymentGateway_TLB.pas',
  MSCorLib_TLB in '\entrprse\CISXML\MSCorLib_TLB.pas',
  
  oContactRoles in 'oContactRoles.pas',
  oAccountContact in 'oAccountContact.pas',
  AccountContactRoleUtil in 'w:\ENTRPRSE\R&D\AccountContacts\AccountContactRoleUtil.pas',
  ContactsManager in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManager.pas',
  oAccountContactBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oAccountContactBtrieveFile.pas',
  oAccountContactRoleBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oAccountContactRoleBtrieveFile.pas',
  oContactRoleBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oContactRoleBtrieveFile.pas',
  ContactsManagerPerv in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManagerPerv.pas',
  ContactsManagerSQL in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManagerSQL.pas',
  TxStatusF in '\Entrprse\R&D\OrderPayments\TxStatusF.pas',
  System_TLB in '\Entrprse\R&D\OrderPayments\System_TLB.pas',
  System_Windows_Forms_TLB in '\Entrprse\R&D\OrderPayments\System_Windows_Forms_TLB.pas',
  Accessibility_TLB in '\Entrprse\R&D\OrderPayments\Accessibility_TLB.pas',
  TransCancelF in '\Entrprse\R&D\OrderPayments\TransCancelF.pas',
  oOPOrderAuditNotes in '\Entrprse\R&D\OrderPayments\oOPOrderAuditNotes.pas',
  CreditCardUtils in 'CreditCardUtils.pas',
  
  oTakePPD in '\Entrprse\R&D\PPD\oTakePPD.pas',
  oVAT100 in 'oVAT100.pas',
  oVAT100BtrieveFile in 'w:\SBSLIB\WIN\EXCOMMON\oVAT100BtrieveFile.pas',
  oBtrieveFile in 'w:\ENTRPRSE\MULTCOMP\oBtrieveFile.pas',

  oFormsToolkitPoolManager in 'oFormsToolkitPoolManager.pas',
  IntrastatXML in '\ENTRPRSE\R&D\Intrastat\IntrastatXML.pas',

  //PR: 05/09/2017 Added for password complexity changes v2017 R2
  PasswordComplexityConst in 'w:\Entrprse\R&D\Password Complexity\PasswordComplexityConst.pas',
  SHA3_256 in 'w:\Compon\SHA3_256Hash\SHA3_256.pas',
  Mem_Util in 'w:\Compon\SHA3_256Hash\Mem_Util.pas',
  Hash in 'w:\Compon\SHA3_256Hash\Hash.pas',
  BTypes in 'w:\Compon\SHA3_256Hash\BTypes.pas',
  SHA3 in 'w:\Compon\SHA3_256Hash\SHA3.pas',

  //AP: 26/12/2017 Added for GDPR changes v2018 R1
  GDPRConst in 'W:\ENTRPRSE\R&D\GDPR\GDPRConst.pas',
  oAnonymisationDiaryObjIntf in 'W:\ENTRPRSE\R&D\GDPR\oAnonymisationDiaryObjIntf.pas',
  oAnonymisationDiaryObjDetail in 'W:\ENTRPRSE\R&D\GDPR\oAnonymisationDiaryObjDetail.pas';

{$IFNDEF WANTEXE}
  exports
    DllGetClassObject,
    DllCanUnloadNow,
    DllRegisterServer,
    DllUnregisterServer;
{$ENDIF}

{$R *.TLB}

{$R *.RES}

// MH 30/05/2014 v7.0.10 ABSEXCH-15404: Added PE Flags to force entire component to be loaded into memory
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}

{$IFDEF WANTEXE}
begin
  Application.Initialize;
  Application.Title := '';
  Application.ShowMainForm := False;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
{$ENDIF}
end.
