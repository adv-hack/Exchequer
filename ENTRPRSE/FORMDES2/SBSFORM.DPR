library sbsForm;

{ Important note about DLL memory management: ShareMem must be the
the first unit in your interface section's USES clause if your DLL
exports any procedures or functions that pass string parameters or
function results.  This applies to all strings passed to and from
your DLL--even those that are nested in records and classes. ShareMem
is the interface unit to the DELPHIMM.DLL, which must be deployed
along with your DLL. To avoid using DELPHIMM.DLL, pass string
information using PChar or ShortString parameters. }

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  SysUtils,
  Classes,
  Dialogs,
  Forms,
  Printers,
  Windows,
  FirstU in 'FirstU.pas',
  FormFile in 'FORMFILE.PAS',
  Globtype in 'Globtype.pas',
  BTSFrmU1 in 'W:\Entrprse\R&D\BTSFrmU1.pas' {BTWaitLock},
  BTSupU1 in 'W:\Entrprse\R&D\Btsupu1.pas',
  BTSupU2 in 'W:\Entrprse\R&D\Btsupu2.pas',
  GlobVar in 'W:\Entrprse\R&D\Globvar.pas',
  BtKeys1U in 'W:\Entrprse\R&D\Btkeys1u.pas',
  VarConst in 'W:\Entrprse\R&D\Varconst.pas',
  Register in 'register.pas',
  FormDets in 'FormDets.pas',
  PrntForm in 'PRNTFORM.PAS' {Form_PrintTest},
  printU in 'printU.pas',
  options in 'options.pas',
  datadict in 'datadict.pas',
  selfld2 in 'selfld2.pas' {Form_SelectField2},
  ETStrU in 'W:\SBSLIB\WIN\WIN32\Etstru.pas',
  VarRPOSU in 'W:\SBSLIB\WIN\EXCOMMON\Varrposu.pas',
  VarFPOSU in 'W:\Entrprse\r&d\varfposu.pas',
  tableopt in 'tableopt.pas' {Form_TableOptions},
  coltype in 'coltype.pas' {Form_FieldType},
  tablfunc in 'tablfunc.pas',
  Frmlacol in 'Frmlacol.pas' {Form_AddFormulaCol},
  PaprSize in 'PaprSize.pas' {Form_PaperSizes},
  formutil in 'formutil.pas',
  psizedlg in 'psizedlg.pas' {Form_SizeDialog},
  AboutU in 'W:\Entrprse\R&D\Aboutu.pas' {AboutFrm},
  dbfldopt in 'Dbfldopt.pas' {Form_DbFldOpt},
  Dbfldcol in 'Dbfldcol.pas' {Form_AddFieldCol},
  DicLinkU in 'Diclinku.pas',
  InvListU in 'W:\Entrprse\r&d\InvListU.pas',
  rpcommon in 'rpcommon.pas',
  Parser in 'Parser.pas',
  ifoption in 'ifoption.pas' {Form_IfOptions},
  CurrncyU in 'W:\Entrprse\R&D\Currncyu.pas',
  frmlaopt in 'FRMLAOPT.PAS' {Form_FormulaOptions},
  prntprev in 'Prntprev.pas' {Form_PrintPreview},
  syslist in 'syslist.pas' {SysFrmLst},
  sysfdet in 'sysfdet.pas' {SysFrmDet},
  LblDlg1U in 'LblDlg1U.pas' {BaseLabelDialog},
  LabelDlg in 'LabelDlg.pas' {BaseLabelDialog1},
  Recurse in 'Recurse.pas',
  RecursEr in 'RecursEr.pas' {FormRecurseErr},
  DicLnk2U in 'Diclnk2u.pas',
  PageDlg in 'PageDlg.pas' {PageSetupDlg},
  Btrvu2 in 'W:\sbslib\win\win32\btrvu2.pas',
  Eprntdef in 'Eprntdef.pas',
  PrnCodes in 'PrnCodes.pas' {Form_PrnCodes},
  PrintPCC in 'PrintPCC.pas' {Form_PrintPCC},
  PCCUtils in 'PCCUtils.pas',
  PCCDeflt in 'PCCDeflt.pas' {Form_PCCDefaults},
  CommsInt in 'W:\Entrprse\ENTCOMMS\Commsint.pas',
  PCCToEFP in 'PCCToEFP.pas' {frmConvertPCC},
  PrnXML in 'Prnxml.pas',
  XmlInt in 'Xmlint.pas',
  CompUtil in 'W:\Entrprse\MULTCOMP\Computil.pas',
  Excep3U in 'W:\Entrprse\R&D\Excep3U.pas',
  EmailSig in 'EmailSig.pas' {frmSignatures},
  XMLFUNCS in 'W:\EBUS2\XMLDLL\Xmlfuncs.pas',
  APIUtil in 'W:\Entrprse\Funcs\Apiutil.pas',
  DocSort in 'DocSort.pas',
  FileUtil in 'W:\Entrprse\FUNCS\FILEUTIL.PAS',
  BinData in 'BinData.pas',
  History in 'History.pas',
  SavePos in 'W:\Entrprse\FUNCS\SavePos.pas',
  ScratchF in 'ScratchF.pas',
  SCRATCHO in 'SCRATCHO.PAS',
  HIBC in 'HIBC.pas',
  EntLicence in 'W:\Entrprse\DRILLDN\EntLicence.pas',
  PickListUtil in 'PickListUtil.pas',
  XMLFileU in 'XMLFileU.pas',
  VAOUtil in 'W:\Entrprse\FUNCS\VAOUtil.pas',
  CustomFieldsIntf In 'W:\Entrprse\R&D\CustomFieldsIntf.Pas',

  // MH 04/11/2013 v7.x MRD2.4.24: Added Load Role function to load a specific contacts details on demand
  // RB 05/07/2017 Moved AdoConnect.pas to Funcs folder
  ADOConnect in '\Entrprse\Funcs\ADOConnect.pas',
  oBtrieveFile in '\Entrprse\MultComp\oBtrieveFile.pas',
  oAccountContactBtrieveFile in '\Entrprse\R&D\AccountContacts\oAccountContactBtrieveFile.Pas',
  oContactRoleBtrieveFile in '\Entrprse\R&D\AccountContacts\oContactRoleBtrieveFile.Pas',
  oAccountContactRoleBtrieveFile in '\Entrprse\R&D\AccountContacts\oAccountContactRoleBtrieveFile.Pas',
  AccountContactRoleUtil in '\Entrprse\R&D\AccountContacts\AccountContactRoleUtil.Pas',
  ContactsManager in '\Entrprse\R&D\AccountContacts\ContactsManager.pas',
  ContactsManagerSQL in '\Entrprse\R&D\AccountContacts\ContactsManagerSQL.pas',
  ContactsManagerPerv in '\Entrprse\R&D\AccountContacts\ContactsManagerPerv.pas',
  oFDAccountContacts,

  // MH 26/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
  CountryCodeUtils in '\Entrprse\Funcs\CountryCodeUtils.pas',
  CountryCodes in '\Entrprse\Funcs\CountryCodes.pas',

  // MH 01/11/2013 v7.x MRD2.4.24: Added Load Role function to load a specific contacts details on demand
  SQLUtils in '\Entrprse\Funcs\SQLUtils.pas',

  // MH 16/09/2014 Order Payments: Added support for printing SRC's as VAT Receipts
  oOPVATPayBtrieveFile in '\Entrprse\R&D\OrderPayments\oOPVATPayBtrieveFile.pas',
  OPVATPaySingleton in 'OPVATPaySingleton.pas',
  oOPPreviousVATTracker in 'oOPPreviousVATTracker.pas',

  oSerialBatch in 'oSerialBatch.pas';

{$R Arrows.RES}
{$R *.RES}

// MH 30/05/2014 v7.0.10 ABSEXCH-15404: Added PE Flags to force entire component to be loaded into memory
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}


Var
  TempApp     : TApplication;
  TempPrinter : TPrinter;
  ExitSave    : Pointer;
  TempScreen  : TScreen;

Procedure sbsForm_DeInitialise; Export;
begin
  // MH 16/09/2014 Order Payments: Added support for printing SRC's as VAT Receipts
  OPVATPaySingleton_ShutdownCompany;

  // MH 05/01/2015 v7.1: shutdown the tracker object for reporting previously declared VAT
  ResetOrderPaymentsPreviousVATTracker;

  // MH 01/11/2013 v7.x MRD2.4.24: Added Load Role function to load a specific contacts details on demand
  If SQLUtils.UsingSQL Then
  Begin
    FDAccountContacts_CloseDown;
    TerminateGlobalADOConnection;
  End; // If SQLUtils.UsingSQL

  { Close the field select window }
  If Assigned (Form_SelectField2) Then Begin
    Form_SelectField2.Release;
    Form_SelectField2 := Nil;
  End; { If }

  { Free any preview windows floating about }
  FreePrevWins;

  // MH 25/10/2011 v6.9: Added Custom Fields info object
  ClearCustomFields;

  { Close Files }
  FF_CloseFiles (True); { True = ?? }

  {If Assigned (TempPrinter) Then Begin
    SetNewDevice(TempPrinter);
    TempPrinter := Nil;
  End; { If }

  { Restore application handle }
  If Assigned (TempApp) Then Begin
    Application := TempApp;
    TempApp := Nil;
  End; { If }

  If Assigned(TempScreen) Then
  Begin
    forms.Screen := TempScreen;
    TempScreen := Nil;
  End; // If Assigned(TempScreen)

  { Close Btrieve }
End;

// HM 03/04/02: Added sbsForm_Initialise2 to allow Form Designer to support
//              classis Toolbar look.
Function sbsForm_Initialise2 (    SysInfo          : SystemInfoType;
                              Var CRTab, ClassicTB : Boolean) : Boolean; Export;
Type
  VerRec   =  Record
                Ver,Rel  :  Integer;
                Typ      :  Char;
              end;
Var
  n       : Byte;
  ConRec  : Array[1..3] of VerRec;
begin
  Result := True;

  SystemInfo := SysInfo;
  { Make sure its turned off for Exchequer }
  {SystemInfo.DebugOpen := SystemInfo.DebugOpen And
                          Assigned(SystemInfo.ControllerHandle);}

  { Replace Application with EXE's application  }
  TempApp := Application;
  Application := SysInfo.AppHandle;
  {TempPrinter := SetNewDevice(SysInfo.AppPrinter);}
  TempScreen := NIL;

  // HM 18/03/02: Modified code to create default path in no data set path is specified
  If (Trim(SysInfo.ExDataPath) = '') Then
    // No pathing information supplied - base path on EXE Dir + EntWRepl.Ini
    SetDrive := GetEnterpriseDirectory
  Else
    // Use supplied path
    SetDrive := SysInfo.ExDataPath;

  AssignBOwner(ExBTOWNER);

  // MH 23/08/2017 2017-R2 ABSEXCH-19166: Moved Global ADO Connection initialisation as it is being used earlier
  // MH 01/11/2013 v7.x MRD2.4.24: Added Load Role function to load a specific contacts details on demand
  If SQLUtils.UsingSQL Then
    InitialiseGlobalADOConnection (SetDrive);

  // MH 25/10/2011 v6.9: Added Custom Fields info object
  SetCustomFieldsPath(SetDrive);

  { Open all data files }
  Open_System(1,TotFiles);

  { Open form designer data Files - merge with normal }
  If FF_OpenFiles Then Begin
    { Load system records }
    FF_Loadsys;
    TxLateCR := Syss.TxLateCR;
    CRTab := Syss.TxLateCR;
    ClassicTB := Syss.UseClassToolB;

    { Initialise global arrays }
    Init_STDVATList;
    Init_STDCurrList;
    Init_STDDocTList;

    {$IFDEF STK}
      Init_STDStkTList;
      Init_STDValList;
    {$ENDIF}

    Set_SDefDecs;

    (*  HM 27/2/97 Moved to PrintFormDef in PrintU.Pas so updates to invoices are loaded
    { Get data into records for printing }
    FF_GetData;
    *)

    { Load DOS-type printer stuff }
    InitPrnCodes;
  End { If }
  Else Begin
    sbsForm_DeInitialise;
    Result := False;
  End; { Else }
end;

Function sbsForm_Initialise (    SysInfo : SystemInfoType;
                             Var CRTab   : Boolean) : Boolean; Export;
Var
  Dummy : Boolean;
Begin { sbsForm_Initialise }
  Result := sbsForm_Initialise2 (SysInfo, CRTab, Dummy);
End; { sbsForm_Initialise }


procedure sbsForm_DispRecSizes;
begin
  If Debug then Begin
    ShowMessage ('FormDefRecType: ' + IntToStr (SizeOf(FormDefRecType)) + #13#10 +
                 'Header: '#9 + IntToStr (SizeOf (fdHeaderRecType)) + #13#10 +
                 'Strings: '#9#9 + IntToStr (SizeOf (fdFormStringsType)) + #13#10 +
                 'Text: '#9#9 + IntToStr (SizeOf (fdTextRecType)) + #13#10 +
                 'Line: '#9#9 + IntToStr (SizeOf (fdLineRecType)) + #13#10 +
                 'Bitmap: '#9#9 + IntToStr (SizeOf (fdBitmapRecType)) + #13#10 +
                 'Page: '#9#9 + IntToStr (SizeOf (fdPageRecType)) + #13#10 +
                 'Box: '#9#9 + IntToStr (SizeOf (fdBoxRecType)) + #13#10 +
                 'Dbfield: '#9#9 + IntToStr (SizeOf (fdDbFieldRecType)) + #13#10 +
                 'Table: '#9#9 + IntToStr (SizeOf (fdTableRecType)) + #13#10 +
                 'FieldCol: '#9 + IntToStr (SizeOf (fdDbFieldColType)) + #13#10 +
                 'FormCol: '#9 + IntToStr (SizeOf (fdDbFormulaColType)) + #13#10 +
                 'Formula: '#9 + IntToStr (SizeOf (fdFormulaRecType)) + #13#10 +
                 'Group: '#9#9 + IntToStr (SizeOf (fdGroupRecType)) + #13#10 +
                 'MaxSize: '#9 + IntToStr (SizeOf (fdMaxSizeType)));
  End; { If }
end;


Procedure DisplayAbout;
Var
  Form_About : TAboutFrm;
begin
  Form_About := TAboutFrm.Create(Application);
  Try
    {If Debug Then sbsForm_DispRecSizes;}
    Form_About.ShowModal;
  Finally
    Form_About.Free;
  End;
end;

//-------------------------------------------------------------------------

// MH 07/06/07: Added to try and workaround problems with HTML Help and the
// form being made inactive/sent to back
Procedure sbsForm_ShareScreen (Const ParentScreen : TScreen); StdCall; Export;
Begin // sbsForm_ShareScreen
  TempScreen := forms.Screen;
  forms.Screen := ParentScreen;
End; // sbsForm_ShareScreen

//-------------------------------------------------------------------------

Function sbsForm_GetDllVer : String; Export;
begin
  // HM 12/08/03: Moved SbsForm version to local History.Pas
  Result := SbsFormVer;
end;


Procedure Ex_Abort;  far;
Begin
  ExitProc:=ExitSave;

  { HM 01/04/99: Modified as calling wrong close function }
  //Close_Files(BOn);
  FF_CloseFiles (BOn);
end;

Procedure sbsForm_TestProc; Export;
begin
  ShowMessage (SetDrive);

  If Assigned(SystemInfo.MainForm) Then
    ShowMessage (SystemInfo.MainForm.Caption);
end;

Exports
  { FormFile.Pas }
  GetCompanyName,

  { DataDict.Pas }
  GetFileDescr,
  PrintDDReport,

  { Register.Pas }
  SaveFormDef,
  OpenFormDef,
  DeleteFormDef,
  ValidFormDef,
  GetFormCopies,
  GetFormInfo,
  GetFormType,

  { PrntForm.Pas }
  PreviewPrintFile,
  PrintFileTo,
  PrintFileToEx,
  PrintInCreate,
  NumPrevWins,
  FreePrevWins,
  NFClosePrevWindows,

  { PrintU.Pas }
  PrintPageBorders,
  PrintLabelBorders,
  PrintFormDef,
  PrintBatch_ClearBatch,
  PrintBatch_AddJob,
  PrintBatch_Print,
  TestLabels,

  { Options.Pas }
  DbFieldOptions,
  DbTableOptions,
  FormulaOptions,

  { PaprSize.Pas }
  MaintainPaperSizes,
  SelectPaperSize,

  { SysList.Pas }
  SetupFormDefinitions,

  { FormUtil.Pas }
  ExVerIsStandard,
  ExVerIsProf,
  ExVerIsMultiCcy,
  ExVerIsStock,
  ExVerIsSPOP,

  { IfOption.Pas}
  IfDescr,
  IfDialog,

  { PrnCodes.Pas}
  PrinterControlCodes,

  { PCCDeflt.Pas }
  PCCDefaulDlg,

  { PrntPrev.Pas }
  DeletePrintFile,

  { EmailSig.Pas }
  MaintainSignatures,

  { This module }
  sbsForm_TestProc,
  sbsForm_Initialise,
  sbsForm_Initialise2,
  sbsForm_DeInitialise,
  sbsForm_DispRecSizes,
  sbsForm_GetDllVer,
  sbsForm_ShareScreen,
  GetTempFilePath,
  DisplayAbout;
Begin
  ExitSave:=ExitProc;
  ExitProc:=@Ex_Abort;
end.
