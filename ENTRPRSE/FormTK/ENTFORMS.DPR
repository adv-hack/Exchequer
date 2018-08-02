program EntForms;

uses
  madExcept,
  madLinkDisAsm,
  madListModules,
  ControlsAtomFix in '\Entrprse\Funcs\ControlsAtomFix.pas',
  Forms,
  Windows,
  FormFile in 'W:\Entrprse\Formdes2\FORMFILE.PAS',
  Globtype in 'W:\Entrprse\Formdes2\Globtype.pas',
  BTSFrmU1 in 'W:\Entrprse\R&D\BTSFrmU1.pas' {BTWaitLock},
  BTSupU1 in 'W:\Entrprse\R&D\Btsupu1.pas',
  BTSupU2 in 'W:\Entrprse\R&D\Btsupu2.pas',
  GlobVar in 'W:\Entrprse\R&D\Globvar.pas',
  BtKeys1U in 'W:\Entrprse\R&D\Btkeys1u.pas',
  VarConst in 'W:\Entrprse\R&D\Varconst.pas',
  MainF in 'MAINF.PAS' {frmFormToolkit},
  EnterpriseForms_TLB in 'EnterpriseForms_TLB.pas',
  oMain in 'oMain.pas' {PrintingToolkit: CoClass},
  oConfig in 'OCONFIG.PAS',
  oPrntJob in 'oPrntJob.pas',
  oFormLst in 'OFORMLST.PAS',
  oFormDet in 'OFORMDet.PAS',
  MiscFunc in 'MISCFUNC.PAS',
  History in 'History.pas',
  oPrinters in 'oPrinters.pas',
  oStrList in 'oStrList.pas',
  oFuncs in 'OFUNCS.PAS',
  oTmpFile in 'oTmpFile.pas',
  OPJFAX in 'OPJFAX.PAS',
  oPJEmail in 'oPJEmail.pas',
  oPJFile in 'oPJFile.pas',
  oEmlArr in 'oEmlArr.pas',
  oEmlAtt in 'oEmlAtt.pas',
  DelTemp in 'DelTemp.pas',
  oFormInf in 'oFormInf.PAS',
  oFTKLic in 'LicGen\OFTKLIC.PAS',
  Base34 in 'W:\Entrprse\BASE36\BASE34.PAS',
  oImpDefs in 'oImpDefs.pas',

  // MH 14/07/2015 v7.0.14: Added as the new XMLFuncs.pas in Entrprse\Funcs was being picked up instead
  XMLFuncs in '\EBus2\XMLDLL\XMLFuncs.pas',

  // MH 04/11/2013 v7.x MRD2.4.24: Added Load Role function to load a specific contacts details on demand
  oBtrieveFile in '\Entrprse\MultComp\oBtrieveFile.pas',
  oAccountContactBtrieveFile in '\Entrprse\R&D\AccountContacts\oAccountContactBtrieveFile.Pas',
  oContactRoleBtrieveFile in '\Entrprse\R&D\AccountContacts\oContactRoleBtrieveFile.Pas',
  oAccountContactRoleBtrieveFile in '\Entrprse\R&D\AccountContacts\oAccountContactRoleBtrieveFile.Pas',
  AccountContactRoleUtil in '\Entrprse\R&D\AccountContacts\AccountContactRoleUtil.Pas',
  ContactsManager in '\Entrprse\R&D\AccountContacts\ContactsManager.pas',
  ContactsManagerSQL in '\Entrprse\R&D\AccountContacts\ContactsManagerSQL.pas',
  ContactsManagerPerv in '\Entrprse\R&D\AccountContacts\ContactsManagerPerv.pas',
  oFDAccountContacts in '\Entrprse\FormDes2\oFDAccountContacts.pas',

  // MH 17/09/2014 Order Payments: Added support for printing SRC's as VAT Receipts
  oOPVATPayBtrieveFile in '\Entrprse\R&D\OrderPayments\oOPVATPayBtrieveFile.pas',
  OPVATPaySingleton in '\Entrprse\FormDes2\OPVATPaySingleton.pas',

  EntLicence in 'W:\ENTRPRSE\DRILLDN\EntLicence.pas';

{$R *.TLB}

{$R *.res}

// MH 30/05/2014 v7.0.10 ABSEXCH-15404: Added PE Flags to force entire component to be loaded into memory
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}

begin
  Application.Initialize;
  Application.ShowMainForm := False;
  { CJS - 2013-07-08 - ABSEXCH-14438 - update branding and copyright }
  Application.Title := 'Exchequer Form Printing Toolkit';
  Application.CreateForm(TfrmFormToolkit, frmFormToolkit);
  Application.Run;
end.
