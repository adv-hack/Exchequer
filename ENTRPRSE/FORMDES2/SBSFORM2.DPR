library SBSFORM2;

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
  SysUtils,
  Classes,
  Dialogs,
  Forms,
  Printers,
  FirstU in 'FirstU.pas',
  FormFile in 'FormFile.pas',
  Globtype in 'Globtype.pas',
  BTSFrmU1 in '\Entrprse\R&D\BTSFrmU1.pas' {BTWaitLock},
  BTSupU1 in '\Entrprse\R&D\Btsupu1.pas',
  BTSupU2 in '\Entrprse\R&D\Btsupu2.pas',
  GlobVar in '\Entrprse\R&D\Globvar.pas',
  BtKeys1U in '\Entrprse\R&D\Btkeys1u.pas',
  VarConst in '\Entrprse\R&D\Varconst.pas',
  Register in 'register.pas',
  FormDets in 'FORMDETS.PAS',
  PrntForm in 'PrntForm.pas' {Form_PrintTest},
  printU in 'printU.pas',
  datadict in 'datadict.pas',
  ETStrU in '\SBSLIB\WIN\WIN32\Etstru.pas',
  VarRPOSU in '\SBSLIB\WIN\EXCOMMON\Varrposu.pas',
  VarFPOSU in '\Entrprse\r&d\varfposu.pas',
  formutil in 'formutil.pas',
  DicLinkU in 'Diclinku.pas',
  InvListU in '\Entrprse\r&d\InvListU.pas',
  rpcommon in 'rpcommon.pas',
  Parser in 'Parser.pas',
  CurrncyU in '\Entrprse\R&D\Currncyu.pas',
  prntprev in 'Prntprev.pas' {Form_PrintPreview},
  LblDlg1U in 'LBLDLG1U.PAS' {BaseLabelDialog},
  LabelDlg in 'LABELDLG.PAS' {BaseLabelDialog1},
  Recurse in 'Recurse.pas',
  RecursEr in 'RecursEr.pas' {FormRecurseErr},
  DicLnk2U in 'Diclnk2u.pas',
  PageDlg in 'PAGEDLG.PAS' {PageSetupDlg},
  Btrvu2 in '\sbslib\win\win32\btrvu2.pas',
  Eprntdef in 'Eprntdef.pas',
  PrintPCC in 'PrintPCC.pas' {Form_PrintPCC},
  PCCUtils in 'PCCUtils.pas',
  CommsInt in '\Entrprse\ENTCOMMS\Commsint.pas',
  PCCToEFP in 'PCCTOEFP.PAS' {frmConvertPCC},
  PrnXML in 'Prnxml.pas',
  XmlInt in 'Xmlint.pas',
  CompUtil in '\Entrprse\MULTCOMP\Computil.pas',
  Excep3U in '\Entrprse\R&D\Excep3U.pas',
  XMLFUNCS in '\EBUS2\XMLDLL\Xmlfuncs.pas',
  APIUtil in '\Entrprse\Funcs\Apiutil.pas',
  DocSort in 'DocSort.pas',
  FileUtil in '\Entrprse\FUNCS\FILEUTIL.PAS',
  PrnCodes in 'PRNCODES.PAS' {Form_PrnCodes},
  TKIntf in 'TKIntf.pas',
  History in 'HISTORY.PAS',
  CustomFieldsIntf In '\Entrprse\R&D\CustomFieldsIntf.Pas',

  // MH 04/11/2013 v7.x MRD2.4.24: Added Load Role function to load a specific contacts details on demand
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

  // MH 16/09/2014 Order Payments: Added support for printing SRC's as VAT Receipts
  oOPVATPayBtrieveFile in '\Entrprse\R&D\OrderPayments\oOPVATPayBtrieveFile.pas',
  OPVATPaySingleton in 'OPVATPaySingleton.pas',
  oOPPreviousVATTracker in 'oOPPreviousVATTracker.pas',

  SQLUtils,
  ADOConnect,

  EntLicence in '\ENTRPRSE\DRILLDN\EntLicence.pas';

{$R Arrows.RES}
{$R *.RES}


Var
  TempApp     : TApplication;
  TempPrinter : TPrinter;
  ExitSave    : Pointer;
TempSc : TScreen;

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
  {If Assigned (Form_SelectField2) Then Begin
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

{If Assigned(TempSc) Then Begin
  Screen := TempSc;
  TempSc := Nil;
End; { If }

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

{TempSc := Screen;
Screen := TScreen(SysInfo.AppPrinter);}

  // HM 18/03/02: Modified code to create default path in no data set path is specified
  If (Trim(SysInfo.ExDataPath) = '') Then
    // No pathing information supplied - base path on EXE Dir + EntWRepl.Ini
    SetDrive := GetEnterpriseDirectory
  Else
    // Use supplied path
    SetDrive := SysInfo.ExDataPath;

  AssignBOwner(ExBTOWNER);

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

    // MH 01/11/2013 v7.x MRD2.4.24: Added Load Role function to load a specific contacts details on demand
    If SQLUtils.UsingSQL Then
      InitialiseGlobalADOConnection (SetDrive);
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

Function sbsForm_TKDLL_Initialise (Const MsgForm  : Pointer;
                                   Const DataPath : PChar) : Boolean; StdCall; Export;
Var
  SysInfo          : SystemInfoType;
  Dummy1, Dummy2   : Boolean;
Begin { sbsForm_TKDLL_Initialise }
  FillChar (SysInfo, SizeOf(SysInfo), #0);
  With SysInfo Do Begin
    // Non-Zero/Null/'' defaults
    ExVersionNo      := 11;
    AppHandle        := Application;

    // Specified Fields
    MainForm         := TForm(MsgForm);
    ExDataPath       := DataPath;
  End; { With SysInfo }

  Result := sbsForm_Initialise2 (SysInfo, Dummy1, Dummy2);
End; { sbsForm_TKDLL_Initialise }

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


Function sbsForm_GetDllVer : String; Export;
begin
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

  { FormUtil.Pas }
  ExVerIsStandard,
  ExVerIsProf,
  ExVerIsMultiCcy,
  ExVerIsStock,
  ExVerIsSPOP,

  { PrnCodes.Pas}
  PrinterControlCodes,

  { PrntPrev.Pas }
  DeletePrintFile,

  { TKIntF }
  TKDLL_PrintBatch,           {*V5TKSMEM - Added safe PrintBatch_Print routine for Toolkit DLL }

  { This module }
  sbsForm_TKDLL_Initialise,   {*V5TKSMEM - Added safe intialisation routine for Toolkit DLL }

  sbsForm_TestProc,
  sbsForm_Initialise,
  sbsForm_Initialise2,
  sbsForm_DeInitialise,
  sbsForm_DispRecSizes,
  sbsForm_GetDllVer,
  GetTempFilePath;
Begin
  ExitSave:=ExitProc;
  ExitProc:=@Ex_Abort;
end.
