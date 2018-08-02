library ExpaFORM;

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
  FirstU in 'X:\ENTRPRSE\FORMDES2\FirstU.pas',
  FormFile in 'X:\ENTRPRSE\FORMDES2\FORMFILE.PAS',
  Globtype in 'X:\ENTRPRSE\FORMDES2\Globtype.pas',
  BTSFrmU1 in 'X:\ENTRPRSE\R&D\BTSFrmU1.pas' {BTWaitLock},
  BTSupU1 in 'X:\ENTRPRSE\R&D\Btsupu1.pas',
  BTSupU2 in 'X:\ENTRPRSE\R&D\Btsupu2.pas',
  GlobVar in 'X:\ENTRPRSE\R&D\Globvar.pas',
  BtKeys1U in 'X:\ENTRPRSE\R&D\Btkeys1u.pas',
  VarConst in 'X:\ENTRPRSE\R&D\Varconst.pas',
  Register in 'X:\ENTRPRSE\FORMDES2\register.pas',
  FormDets in 'X:\ENTRPRSE\FORMDES2\FormDets.pas',
  PrntForm in 'X:\ENTRPRSE\FORMDES2\PRNTFORM.PAS' {Form_PrintTest},
  printU in 'X:\ENTRPRSE\FORMDES2\printU.pas',
  options in 'X:\ENTRPRSE\FORMDES2\options.pas',
  datadict in 'X:\ENTRPRSE\FORMDES2\datadict.pas',
  selfld2 in 'X:\ENTRPRSE\FORMDES2\selfld2.pas' {Form_SelectField2},
  ETStrU in 'X:\SBSLIB\WIN\WIN32\Etstru.pas',
  VarRPOSU in 'X:\SBSLIB\WIN\EXCOMMON\Varrposu.pas',
  VarFPOSU in 'X:\ENTRPRSE\r&d\varfposu.pas',
  tableopt in 'X:\ENTRPRSE\FORMDES2\tableopt.pas' {Form_TableOptions},
  coltype in 'X:\ENTRPRSE\FORMDES2\coltype.pas' {Form_FieldType},
  tablfunc in 'X:\ENTRPRSE\FORMDES2\tablfunc.pas',
  Frmlacol in 'X:\ENTRPRSE\FORMDES2\Frmlacol.pas' {Form_AddFormulaCol},
  PaprSize in 'X:\ENTRPRSE\FORMDES2\PaprSize.pas' {Form_PaperSizes},
  formutil in 'X:\ENTRPRSE\FORMDES2\formutil.pas',
  psizedlg in 'X:\ENTRPRSE\FORMDES2\psizedlg.pas' {Form_SizeDialog},
  AboutU in 'X:\ENTRPRSE\R&D\Aboutu.pas' {AboutFrm},
  dbfldopt in 'X:\ENTRPRSE\FORMDES2\Dbfldopt.pas' {Form_DbFldOpt},
  Dbfldcol in 'X:\ENTRPRSE\FORMDES2\Dbfldcol.pas' {Form_AddFieldCol},
  DicLinkU in 'X:\ENTRPRSE\FORMDES2\Diclinku.pas',
  InvListU in 'X:\ENTRPRSE\r&d\InvListU.pas',
  rpcommon in 'X:\ENTRPRSE\FORMDES2\rpcommon.pas',
  Parser in 'X:\ENTRPRSE\FORMDES2\Parser.pas',
  ifoption in 'X:\ENTRPRSE\FORMDES2\ifoption.pas' {Form_IfOptions},
  CurrncyU in 'X:\ENTRPRSE\R&D\Currncyu.pas',
  frmlaopt in 'X:\ENTRPRSE\FORMDES2\FRMLAOPT.PAS' {Form_FormulaOptions},
  prntprev in 'X:\ENTRPRSE\FORMDES2\Prntprev.pas' {Form_PrintPreview},
  syslist in 'X:\ENTRPRSE\FORMDES2\syslist.pas' {SysFrmLst},
  sysfdet in 'X:\ENTRPRSE\FORMDES2\sysfdet.pas' {SysFrmDet},
  LblDlg1U in 'X:\ENTRPRSE\FORMDES2\LblDlg1U.pas' {BaseLabelDialog},
  LabelDlg in 'X:\ENTRPRSE\FORMDES2\LabelDlg.pas' {BaseLabelDialog1},
  Recurse in 'X:\ENTRPRSE\FORMDES2\Recurse.pas',
  RecursEr in 'X:\ENTRPRSE\FORMDES2\RecursEr.pas' {FormRecurseErr},
  DicLnk2U in 'X:\ENTRPRSE\FORMDES2\Diclnk2u.pas',
  PageDlg in 'X:\ENTRPRSE\FORMDES2\PageDlg.pas' {PageSetupDlg},
  Btrvu2 in 'X:\sbslib\win\win32\btrvu2.pas',
  Eprntdef in 'X:\ENTRPRSE\FORMDES2\Eprntdef.pas',
  PrnCodes in 'X:\ENTRPRSE\FORMDES2\PrnCodes.pas' {Form_PrnCodes},
  PrintPCC in 'X:\ENTRPRSE\FORMDES2\PrintPCC.pas' {Form_PrintPCC},
  PCCUtils in 'X:\ENTRPRSE\FORMDES2\PCCUtils.pas',
  PCCDeflt in 'X:\ENTRPRSE\FORMDES2\PCCDeflt.pas' {Form_PCCDefaults},
  CommsInt in 'X:\ENTRPRSE\ENTCOMMS\Commsint.pas',
  PCCToEFP in 'X:\ENTRPRSE\FORMDES2\PCCToEFP.pas' {frmConvertPCC},
  PrnXML in 'X:\ENTRPRSE\FORMDES2\Prnxml.pas',
  XmlInt in 'X:\ENTRPRSE\FORMDES2\Xmlint.pas',
  CompUtil in 'X:\ENTRPRSE\MULTCOMP\Computil.pas',
  Excep3U in 'X:\ENTRPRSE\R&D\Excep3U.pas',
  EmailSig in 'X:\ENTRPRSE\FORMDES2\EmailSig.pas' {frmSignatures},
  XMLFUNCS in 'X:\EBUS2\XMLDLL\Xmlfuncs.pas',
  APIUtil in 'X:\ENTRPRSE\Funcs\Apiutil.pas',
  DocSort in 'X:\ENTRPRSE\FORMDES2\DocSort.pas',
  FileUtil in 'X:\ENTRPRSE\FUNCS\FILEUTIL.PAS',
  BinData in 'X:\ENTRPRSE\FORMDES2\BinData.pas',
  History in 'X:\ENTRPRSE\FORMDES2\History.pas',
  SavePos in 'X:\ENTRPRSE\FUNCS\SavePos.pas',
  ScratchF in 'X:\ENTRPRSE\FORMDES2\ScratchF.pas',
  SCRATCHO in 'X:\ENTRPRSE\FORMDES2\SCRATCHO.PAS',
  HIBC in 'X:\ENTRPRSE\FORMDES2\HIBC.pas';

{$R Arrows.RES}


Var
  TempApp     : TApplication;
  TempPrinter : TPrinter;
  ExitSave    : Pointer;
TempSc : TScreen;

Procedure sbsForm_DeInitialise; Export;
begin
  { Close the field select window }
  If Assigned (Form_SelectField2) Then Begin
    Form_SelectField2.Release;
    Form_SelectField2 := Nil;
  End; { If }

  { Free any preview windows floating about }
  FreePrevWins;

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
  { Make sure its turned off for Enterprise }
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
  GetTempFilePath,
  DisplayAbout;
Begin
  ExitSave:=ExitProc;
  ExitProc:=@Ex_Abort;
end.
