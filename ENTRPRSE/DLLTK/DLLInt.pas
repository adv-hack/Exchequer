unit DLLInt;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }
{$WARNINGS OFF}

interface

Uses Classes, Dialogs, Globvar, GlobType, RpDevice, RpBase, SBSList{, FormUtil};

Const
  SBSFormDLL  =  'SBSFORM.DLL';

Function sbsForm_Initialise (    SysInfo : SystemInfoType;
                             Var CRTab   : Boolean) : Boolean;
{$IFDEF FDES}
  // HM 03/04/02: Added sbsForm_Initialise2 to allow Form Designer to support
  //              classis Toolbar look.
  Function sbsForm_Initialise2 (    SysInfo          : SystemInfoType;
                                Var CRTab, ClassicTB : Boolean) : Boolean;
{$ENDIF}

Procedure sbsForm_DeInitialise;   External SBSFormDLL;
Function sbsForm_GetDllVer : String;   External SBSFormDLL;

Function ValidFormDef (Const FilePath : SplitFnameType;
                       Const WantMsg  : Boolean) : Boolean;

Function OpenFormDef (Const Filename   : String;
                      Var   HedRec     : fdHeaderRecType;
                      Var   StrRec     : fdFormStringsType;
                      Var   ListHandle : TSBSList) : Boolean;

Procedure SaveFormDef (Const Filename   : String;
                       Const HedRec     : fdHeaderRecType;
                       Const StrRec     : fdFormStringsType;
                       Var   ListHandle : TSBSList);

Function DeleteFormDef (Const DefName : Str255) : Boolean;   External SBSFormDLL;

{$IFDEF FDES}
Procedure PrintPageBorders (Const HedRec   : fdHeaderRecType;
                            Const PrnSetup : TSBSPrintSetupInfo);
Procedure PrintLabelBorders (Const HedRec   : fdHeaderRecType;
                             Const PrnSetup : TSBSPrintSetupInfo);

Function PrintFormDef (Const HedRec     : fdHeaderRecType;
                       Const StrRec     : fdFormStringsType;
                       Var   ListHandle : TSBSList;
                       Const Preview    : Boolean;
                       Const PrnSetup   : TSBSPrintSetupInfo) : Boolean;
{$ENDIF}

Function DbFieldOptions (Var ControlDef : FormDefRecType;
                         Var Controls   : TSBSList) : Boolean;
Function DbTableOptions (Var ControlDef : FormDefRecType;
                         Var ColumnList : TSBSList;
                         Var ControlList : TSBSList) : Boolean;  External SBSFormDLL;
Function FormulaOptions (Var ControlDef : FormDefRecType;
                         Var Controls   : TSBSList) : Boolean;  External SBSFormDLL;

Procedure SetupFormDefinitions;   External SBSFormDLL;
Procedure MaintainPaperSizes;   External SBSFormDLL;
Function SelectPaperSize (Var PaperSizeRec : PaperSizeType) : Boolean;  External SBSFormDLL;

Procedure DisplayAbout;  External SBSFormDLL;

Function PrintBatch_ClearBatch : Boolean;
Function PrintBatch_AddJob (Const PrBatch : PrintBatchRecType) : Boolean;
{Function PrintBatch_Print (Const WinTitle : ShortString;
                           Const NoCopies : SmallInt) : Boolean;}
Function PrintBatch_Print (Const WinTitle : ShortString;
                           Const PrnInfo  : TSBSPrintSetupInfo) : Boolean;

Function IfDescr (Const IfRec : fdIfInfoType) : String;
Procedure IfDialog (Var   IfRec     : fdIfInfoType;
                    Const ControlId : String10;
                    Var   Controls  : TSBSList);

{Procedure PreviewPrintFile (Const PrintFile, WinTitle : ShortString;
                            Const PrinterNo           : SmallInt;
                            Const NoCopies            : SmallInt);}
Procedure PreviewPrintFile (Const PrnInfo             : TSBSPrintSetupInfo;
                            Const PrintFile, WinTitle : ShortString);
{Procedure PrintFileTo (Const Preview             : Boolean;
                       Const PrintFile, WinTitle : ShortString;
                       Const PrinterNo           : SmallInt;
                       Const NoCopies            : SmallInt);}
Procedure PrintFileTo (Const PrnInfo             : TSBSPrintSetupInfo;
                       Const PrintFile, WinTitle : ShortString);

Function PrintInCreate : Boolean;

Function GetFileDescr (Const FNo : SmallInt) : ShortString;  External SBSFormDLL;

Function GetCompanyName : ShortString;

Function GetFormCopies (Const Filename : String) : SmallInt;

{ Returns Printer, Copies, Orientation from formdef file }
Function GetFormInfo (Const Filename : String) : FormInfoType;

{ Returns a number indicating the form type: 0-Virtual, 1=EFD, 2=PCC }
Function GetFormType (Const Filename : String) : Byte;

{$IFDEF FDES}
  Procedure TestLabels (FormName : String8);
{$ENDIF}

{ Returns number of active preview windows }
Function NumPrevWins : LongInt;

{.IFDEF TRADE}
  { HM 08/02/01: Closes all active preview windows }
  { EL 10/03/2006: v5.71. Exposed this routine as FormTidy in EparentU requires it to force any non thread preview windows to shut before exiting *}
  Procedure NFClosePrevWindows;
{.ENDIF}

{ DOS Printer XRef }
Procedure PrinterControlCodes;

{ DOS Printer Defaults }
Procedure PCCDefaulDlg;

{$IFDEF FDES}
  { Prints a report on the data dictionary to file }
  Procedure PrintDDReport;

  Procedure GetTempFilePath (Var TempPath : ShortString); StdCall;

  Procedure MaintainSignatures; StdCall;
{$ENDIF}

Procedure DeletePrintFile (Const PrintFile : String); StdCall;

implementation

Function sbsForm_Initialise (    SysInfo : SystemInfoType;
                             Var CRTab   : Boolean) : Boolean;
begin
end;
{$IFDEF FDES}
  // HM 03/04/02: Added sbsForm_Initialise2 to allow Form Designer to support
  //              classis Toolbar look.
  Function sbsForm_Initialise2 (    SysInfo          : SystemInfoType;
                                Var CRTab, ClassicTB : Boolean) : Boolean;
{$ENDIF}

Function ValidFormDef (Const FilePath : SplitFnameType;
                       Const WantMsg  : Boolean) : Boolean;
begin
end;

Function OpenFormDef (Const Filename   : String;
                      Var   HedRec     : fdHeaderRecType;
                      Var   StrRec     : fdFormStringsType;
                      Var   ListHandle : TSBSList) : Boolean;
begin
end;

Procedure SaveFormDef (Const Filename   : String;
                       Const HedRec     : fdHeaderRecType;
                       Const StrRec     : fdFormStringsType;
                       Var   ListHandle : TSBSList);
begin
end;

{$IFDEF FDES}
Procedure PrintPageBorders (Const HedRec   : fdHeaderRecType;
                            Const PrnSetup : TSBSPrintSetupInfo);
begin
end;
Procedure PrintLabelBorders (Const HedRec   : fdHeaderRecType;
                             Const PrnSetup : TSBSPrintSetupInfo);
begin
end;

Function PrintFormDef (Const HedRec     : fdHeaderRecType;
                       Const StrRec     : fdFormStringsType;
                       Var   ListHandle : TSBSList;
                       Const Preview    : Boolean;
                       Const PrnSetup   : TSBSPrintSetupInfo) : Boolean;
begin
end;
{$ENDIF}

Function DbFieldOptions (Var ControlDef : FormDefRecType;
                         Var Controls   : TSBSList) : Boolean;
begin
end;



Function PrintBatch_ClearBatch : Boolean;
begin
end;
Function PrintBatch_AddJob (Const PrBatch : PrintBatchRecType) : Boolean;
begin
end;
{Function PrintBatch_Print (Const WinTitle : ShortString;
                           Const NoCopies : SmallInt) : Boolean;}
Function PrintBatch_Print (Const WinTitle : ShortString;
                           Const PrnInfo  : TSBSPrintSetupInfo) : Boolean;
begin
end;

Function IfDescr (Const IfRec : fdIfInfoType) : String;
begin
end;
Procedure IfDialog (Var   IfRec     : fdIfInfoType;
                    Const ControlId : String10;
                    Var   Controls  : TSBSList);
begin
end;

{Procedure PreviewPrintFile (Const PrintFile, WinTitle : ShortString;
                            Const PrinterNo           : SmallInt;
                            Const NoCopies            : SmallInt);}
Procedure PreviewPrintFile (Const PrnInfo             : TSBSPrintSetupInfo;
                            Const PrintFile, WinTitle : ShortString);
begin
end;
{Procedure PrintFileTo (Const Preview             : Boolean;
                       Const PrintFile, WinTitle : ShortString;
                       Const PrinterNo           : SmallInt;
                       Const NoCopies            : SmallInt);}
Procedure PrintFileTo (Const PrnInfo             : TSBSPrintSetupInfo;
                       Const PrintFile, WinTitle : ShortString);
begin
end;

Function PrintInCreate : Boolean;
begin
end;


Function GetCompanyName : ShortString;
begin
end;

Function GetFormCopies (Const Filename : String) : SmallInt;
begin
end;

{ Returns Printer, Copies, Orientation from formdef file }
Function GetFormInfo (Const Filename : String) : FormInfoType;
begin
end;

{ Returns a number indicating the form type: 0-Virtual, 1=EFD, 2=PCC }
Function GetFormType (Const Filename : String) : Byte;
begin
end;

{$IFDEF FDES}
  Procedure TestLabels (FormName : String8);
begin
end;
{$ENDIF}

{ Returns number of active preview windows }
Function NumPrevWins : LongInt;
begin
end;

{.IFDEF TRADE}
  { HM 08/02/01: Closes all active preview windows }
  { EL 10/03/2006: v5.71. Exposed this routine as FormTidy in EparentU requires it to force any non thread preview windows to shut before exiting *}
  Procedure NFClosePrevWindows;
begin
end;
{.ENDIF}

{ DOS Printer XRef }
Procedure PrinterControlCodes;
begin
end;

{ DOS Printer Defaults }
Procedure PCCDefaulDlg;
begin
end;

{$IFDEF FDES}
  { Prints a report on the data dictionary to file }
  Procedure PrintDDReport;
begin
end;

  Procedure GetTempFilePath (Var TempPath : ShortString); StdCall;
begin
end;

  Procedure MaintainSignatures; StdCall;
begin
end;
{$ENDIF}

Procedure DeletePrintFile (Const PrintFile : String); StdCall;
begin
end;

{$WARNINGS ON}

end.
