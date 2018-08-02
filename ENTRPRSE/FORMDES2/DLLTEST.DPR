Program dlltest;

{ Important note about DLL memory management: ShareMem must be the
the first unit in your interface section's USES clause if your DLL
exports any procedures or functions that pass string parameters or
function results.  This applies to all strings passed to and from
your DLL--even those that are nested in records and classes. ShareMem
is the interface unit to the DELPHIMM.DLL, which must be deployed
along with your DLL. To avoid using DELPHIMM.DLL, pass string
information using PChar or ShortString parameters. }


uses
  ShareMem,
  SysUtils,
  Classes,
  Dialogs,
  Forms,
  Printers,
  FormFile in 'FormFile.pas',
  Globtype in 'Globtype.pas',
  BTSFrmU1 in '\ENTRPRSE\R&D\BTSFrmU1.pas' {BTWaitLock},
  BTSupU1 in '\ENTRPRSE\R&D\Btsupu1.pas',
  GlobVar in '\ENTRPRSE\R&D\Globvar.pas',
  BtKeys1U in '\ENTRPRSE\R&D\Btkeys1u.pas',
  VarConst in '\ENTRPRSE\R&D\Varconst.pas',
  Register in 'register.pas',
  FormDets in 'FormDets.pas',
  PrntForm in 'PrntForm.pas' {Form_PrintTest},
  printU in 'printU.pas',
  options in 'options.pas',
  datadict in 'datadict.pas',
  selfield in 'selfield.pas' {Form_SelectField},
  ETStrU in '\SBSLIB\WIN\WIN32\Etstru.pas',
  VarRPOSU in '\SBSLIB\WIN\EXCOMMON\Varrposu.pas',
  VarFPOSU in '\entrprse\r&d\varfposu.pas',
  tableopt in 'tableopt.pas' {Form_TableOptions},
  coltype in 'coltype.pas' {Form_FieldType},
  tablfunc in 'tablfunc.pas',
  Frmlacol in 'Frmlacol.pas' {Form_AddFormulaCol},
  PaprSize in 'PaprSize.pas' {Form_PaperSizes},
  formutil in 'formutil.pas',
  psizedlg in 'psizedlg.pas' {Form_SizeDialog},
  BtSupu2 in '\ENTRPRSE\R&D\Btsupu2.pas',
  AboutU in '\ENTRPRSE\R&D\Aboutu.pas' {AboutFrm},
  dbfldopt in 'Dbfldopt.pas' {Form_DbFldOpt},
  Dbfldcol in 'Dbfldcol.pas' {Form_AddFieldCol},
  DicLinkU in 'Diclinku.pas',
  InvListU in '\entrprse\r&d\InvListU.pas',
  rpcommon in 'rpcommon.pas',
  Parser in 'Parser.pas',
  ifoption in 'ifoption.pas' {Form_IfOptions},
  CurrncyU in '\ENTRPRSE\R&D\Currncyu.pas',
  frmlaopt in 'Frmlaopt.pas' {Form_FormulaOptions},
  PrevPCC in 'PrevPCC.pas' {Form_PrevPCC},
  syslist in 'syslist.pas' {SysFrmLst},
  sysfdet in 'sysfdet.pas' {SysFrmDet},
  LblDlg1U in 'LblDlg1U.pas' {BaseLabelDialog},
  LabelDlg in 'LabelDlg.pas' {BaseLabelDialog1},
  Recurse in 'Recurse.pas',
  RecursEr in 'RecursEr.pas' {FormRecurseErr},
  DicLnk2U in 'Diclnk2u.pas',
  PageDlg in 'PageDlg.pas' {PageSetupDlg},
  Btrvu2 in '\sbslib\win\win32\btrvu2.pas',
  Eprntdef in 'Eprntdef.pas',
  PrnCodes in 'PrnCodes.pas' {Form_PrnCodes},
  PrintPCC in 'PrintPCC.pas' {Form_PrintPCC},
  PCCUtils in 'PCCUtils.pas',
  TestU in 'TestU.pas' {Form_MDIMain},
  prntprev in 'Prntprev.pas' {Form_PrintPreview},
  PCCOpts in 'PCCOpts.pas' {Form_PCCOpts},
  debugwin in 'Debugwin.pas';


{$R Arrows.RES}


Var
  TempApp     : TApplication;
  TempPrinter : TPrinter;
  ExitSave    : Pointer;

Procedure sbsForm_DeInitialise; Export;
begin
  { Close the field select window }
  If Assigned (Form_SelectField) Then Begin
    Form_SelectField.Release;
    Form_SelectField := Nil;
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

  { Close Btrieve }
End;

Function sbsForm_Initialise (    SysInfo : SystemInfoType;
                             Var CRTab   : Boolean) : Boolean; Export;
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

  SetDrive := SysInfo.ExDataPath;

  { Open all data files }
  Open_System(1,TotFiles);

  { Open form designer data Files - merge with normal }
  If FF_OpenFiles Then Begin
    { Load system records }
    FF_Loadsys;
    TxLateCR := Syss.TxLateCR;
    CRTab := Syss.TxLateCR;

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

Begin
  Application.Title := 'SBSForm.DLL Testing Utility';
  Application.CreateForm(TForm_MDIMain, Form_MDIMain);
  Application.Run;
end.
