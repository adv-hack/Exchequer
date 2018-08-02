unit DLLInt;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses {ShareMem, }Classes, Dialogs, Globvar, GlobType, RpDevice, RpBase, SBSList{, FormUtil};

Const
  SBSFormDLL  =  'EXPAFORM.DLL';

Function sbsForm_Initialise (    SysInfo : SystemInfoType;
                             Var CRTab   : Boolean) : Boolean; External SBSFormDLL;
{$IFDEF FDES}
  // HM 03/04/02: Added sbsForm_Initialise2 to allow Form Designer to support
  //              classis Toolbar look.
  Function sbsForm_Initialise2 (    SysInfo          : SystemInfoType;
                                Var CRTab, ClassicTB : Boolean) : Boolean; External SBSFormDLL;
{$ENDIF}

Procedure sbsForm_DeInitialise;   External SBSFormDLL;
Function sbsForm_GetDllVer : String;   External SBSFormDLL;

Function ValidFormDef (Const FilePath : SplitFnameType;
                       Const WantMsg  : Boolean) : Boolean; External SBSFormDLL;

Function OpenFormDef (Const Filename   : String;
                      Var   HedRec     : fdHeaderRecType;
                      Var   StrRec     : fdFormStringsType;
                      Var   ListHandle : TSBSList) : Boolean; External SBSFormDLL;

Procedure SaveFormDef (Const Filename   : String;
                       Const HedRec     : fdHeaderRecType;
                       Const StrRec     : fdFormStringsType;
                       Var   ListHandle : TSBSList); External SBSFormDLL;

Function DeleteFormDef (Const DefName : Str255) : Boolean;   External SBSFormDLL;

{$IFDEF FDES}
Procedure PrintPageBorders (Const HedRec   : fdHeaderRecType;
                            Const PrnSetup : TSBSPrintSetupInfo); External SBSFormDLL;
Procedure PrintLabelBorders (Const HedRec   : fdHeaderRecType;
                             Const PrnSetup : TSBSPrintSetupInfo); External SBSFormDLL;

Function PrintFormDef (Const HedRec     : fdHeaderRecType;
                       Const StrRec     : fdFormStringsType;
                       Var   ListHandle : TSBSList;
                       Const Preview    : Boolean;
                       Const PrnSetup   : TSBSPrintSetupInfo) : Boolean; External SBSFormDLL;
{$ENDIF}

Function DbFieldOptions (Var ControlDef : FormDefRecType;
                         Var Controls   : TSBSList) : Boolean; External SBSFormDLL;
Function DbTableOptions (Var ControlDef : FormDefRecType;
                         Var ColumnList : TSBSList;
                         Var ControlList : TSBSList) : Boolean;  External SBSFormDLL;
Function FormulaOptions (Var ControlDef : FormDefRecType;
                         Var Controls   : TSBSList) : Boolean;  External SBSFormDLL;

Procedure SetupFormDefinitions;   External SBSFormDLL;
Procedure MaintainPaperSizes;   External SBSFormDLL;
Function SelectPaperSize (Var PaperSizeRec : PaperSizeType) : Boolean;  External SBSFormDLL;

Procedure DisplayAbout;  External SBSFormDLL;

Function PrintBatch_ClearBatch : Boolean; External SBSFormDLL;
Function PrintBatch_AddJob (Const PrBatch : PrintBatchRecType) : Boolean; External SBSFormDLL;
{Function PrintBatch_Print (Const WinTitle : ShortString;
                           Const NoCopies : SmallInt) : Boolean; External SBSFormDLL;}
Function PrintBatch_Print (Const WinTitle : ShortString;
                           Const PrnInfo  : TSBSPrintSetupInfo) : Boolean; External SBSFormDLL;

Function IfDescr (Const IfRec : fdIfInfoType) : String; External SBSFormDLL;
Procedure IfDialog (Var   IfRec     : fdIfInfoType;
                    Const ControlId : String10;
                    Var   Controls  : TSBSList); External SBSFormDLL;

{Procedure PreviewPrintFile (Const PrintFile, WinTitle : ShortString;
                            Const PrinterNo           : SmallInt;
                            Const NoCopies            : SmallInt); External SBSFormDLL;}
Procedure PreviewPrintFile (Const PrnInfo             : TSBSPrintSetupInfo;
                            Const PrintFile, WinTitle : ShortString); External SBSFormDLL;
{Procedure PrintFileTo (Const Preview             : Boolean;
                       Const PrintFile, WinTitle : ShortString;
                       Const PrinterNo           : SmallInt;
                       Const NoCopies            : SmallInt); External SBSFormDLL;}
Procedure PrintFileTo (Const PrnInfo             : TSBSPrintSetupInfo;
                       Const PrintFile, WinTitle : ShortString); External SBSFormDLL;

Function PrintInCreate : Boolean; External SBSFormDLL;

Function GetFileDescr (Const FNo : SmallInt) : ShortString;  External SBSFormDLL;

Function GetCompanyName : ShortString; External SBSFormDLL;

Function GetFormCopies (Const Filename : String) : SmallInt; External SBSFormDLL;

{ Returns Printer, Copies, Orientation from formdef file }
Function GetFormInfo (Const Filename : String) : FormInfoType; External SBSFormDLL;

{ Returns a number indicating the form type: 0-Virtual, 1=EFD, 2=PCC }
Function GetFormType (Const Filename : String) : Byte; External SBSFormDLL;

{$IFDEF FDES}
  Procedure TestLabels (FormName : String8); External SBSFormDLL;
{$ENDIF}

{ Returns number of active preview windows }
Function NumPrevWins : LongInt; External SBSFormDLL;

{$IFDEF TRADE}
  { HM 08/02/01: Closes all active preview windows }
  Procedure NFClosePrevWindows; External SBSFormDLL;
{$ENDIF}

{ DOS Printer XRef }
Procedure PrinterControlCodes; External SBSFormDLL;

{ DOS Printer Defaults }
Procedure PCCDefaulDlg; External SBSFormDLL;

{$IFDEF FDES}
  { Prints a report on the data dictionary to file }
  Procedure PrintDDReport; External SBSFormDLL;

  Procedure GetTempFilePath (Var TempPath : ShortString); StdCall; External SBSFormDLL;

  Procedure MaintainSignatures; StdCall; External SBSFormDLL;
{$ENDIF}

Procedure DeletePrintFile (Const PrintFile : String); StdCall; External SBSFormDLL;

implementation


end.
