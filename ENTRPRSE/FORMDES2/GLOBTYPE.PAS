{ Contains the Global Structures used for the form Designer }
unit Globtype;

{$H-}
interface

Uses Classes,
     Dialogs,
     Messages,
     Graphics,
     SysUtils,
     Forms,
     GlobVar;

{$ALIGN 1}

Const
  WM_PrintProgress = WM_USER + $101;   { Also in Splash1U.Pas }
  WM_PrintAbort    = WM_USER + $102;
  WM_InPrint       = WM_USER + $103;   { Also in Splash1U.Pas }

  DesignerMajorVersion = 0;
  DesignerMinorVersion = 10;
  MinDesMajVersion = DesignerMajorVersion;
  MaxDesMajVersion = DesignerMajorVersion;
  MinDesMinVersion = DesignerMinorVersion;
  MaxDesMinVersion = DesignerMinorVersion;

  MinControlWidth = 10;
  MinControlHeight = 10;

  CRLF            = #13#10;
  VerParamStr     = '/EXV:';
  PathParamStr    = '/DIR:';
  DefaultPixPerMM = 3;

// CJS 08/02/2007 v6.00: Changed file extensions for new XML format.
{$IFDEF EX600}
  DefExtension       = 'EFX';
  DefDotExtension    = '.EFX';
  OldDefExtension    = 'EFD';
  OldDefDotExtension = '.EFD';
{$ELSE}
  DefExtension    = 'EFD';
  DefDotExtension = '.EFD';
  OldDefExtension    = 'XFD';
  OldDefDotExtension = '.XFD';
{$ENDIF}

  FormsPath       = 'Forms\';

  { Exchequer Printer Control Code forms }
  DefPCCExtension = 'DEF';

  { Form Modes (pbDefMode) }
  fmAllDocs      = 1;   { All Documents }
  fmRemitAdv     = 2;   { Remittance Advice }
  fmStatemLay    = 3;   { Statement Layout }
  fmDebtChaseL   = 4;   { Debt Cahse Letters }
  fmTradeHist    = 5;   { Trading History }
  fmBatchDoc     = 6;   { Batch Document }
  fmNomTxfr      = 7;   { Nom Txfr }
  fmAccDets      = 8;   { Account Details }
  fmLabelRun     = 9;   { Labels (Run) }
  fmLabelSngl    = 10;  { Label (Single) }
  fmStockRec     = 11;  { Stock Record }
  fmStockAdj     = 12;  { Stock Adjust }
  fmPickLstCons  = 13;  { Picking List Consolidated }
  fmPickLstSngl  = 14;  { Picking List Single }
  fmConsignNote  = 15;  { Consignment Note }
  fmDelivLabel   = 16;  { Delivery Label }
  fmStockNote    = 17;  { Stock Notes }
  fmDocSerialNo  = 18;  { Document with Serial Nos. }
  fmProductLabel = 19;  { Product Labels }
  fmSnglProduct  = 20;  { Single Product Label }
  fmProdViaDeliv = 21;  { Product Labels via Delivery Run }
  fmStateAgeMnth = 22;  { Statements with As @ Ageing, and including details for month }
  fmTimeSheet    = 23;  { Time Sheets }
  fmJCBackingSh  = 24;  { Job Costing Backing Sheet }
  fmJCRec        = 25;  { Job Costing Record }
  fmLabel        = 26;  { Label - any sort }
  { Reserved       27   { Used internally by Exchequer for WOP Picking Lists }
  fmSerialLabel  = 28;  { Serial Number Labels }
  fmTransNotes   = 29;  { Forms Toolkit - Trans Header + Trans Notes in Table }
  fmCISVoucher   = 30;  { CIS Vouchers }

  // MH 15/09/2014: Extended for Order Payment Payment/Refund transactions
  fmOrdPayVATReceipt = 31; { Order Payments - printing SRC as VAT Receipt }

  // HM 07/02/01: Added support for printing hidden ADJ lines
  fmADJSort      = 101; { ADJ - Hidden lines and Sorting turned on }

  // HM 15/02/01: Added support for sorting Transaction Lines
  fmTransSort    = 102;

  // HM 02/09/03: Added support for Picking Lists with Bins
  fmPickListBins     = 103; // Single
  fmPickListConsBins = 104; // Consolidated

  // MH 07/11/06:
  fmSortedPickingList = 105;  // Sorted Single Picking List - No Bins & No Serial/Batch
  fmSortedConsPickingList = 106;  // Sorted Consolidated Picking List - No Bins & No Serial/Batch

  // HM 24/02/04: Added Custom Trading History for COM Toolkit
  fmCustomTradingHistory = 201;

  fmLabelSet = [fmLabel, fmSerialLabel];

Type
  String8  = String[8];
  String10 = String[10];
  String16 = String[16];
  String20 = String[20];
  String30 = String[30];
  String32 = String[32];
  String50 = String[50];
  String64 = String[64];
  String100 = String[100];
  String139 = String[139];
  String200 = String[200];
  String255 = String[255];

  fhNameType = String30;
  PathType   = String30;
  FormsListType = Array [1..1] Of fhNameType;
  FormsListPtrType = ^FormsListType;

  RepTypeType = (rtNone,
                 rtTestForm,  rtTestLabel,  rtTestReport,
                 rtDevForm,   rtDevLabel,   rtDevReport,
                 rtBatch,     rtBatchLabel);


  TPageStructureType = (stPageHead, stBodyHead, stBody, stBodyFoot, stPageFoot);
  TPageStructureSet = Set Of TPageStructureType;

  TSBSDragLineType = (lnVertical, lnHorizontal, lnTLToBR, lnBLToTR);


  { Type of Form: Form, Label, Report }
  fdFormTypeType   = (ftForm, ftLabel, ftReport);
  fdFormTypeSet    = Set Of fdFormTypeType;

  { ? }
  fdRepClassType   = (fdrHeader,       fdrPageHead, fdrPageBodyHead, fdrPageBody,
                      fdrPageBodyFoot, fdrPageFoot, fdrColumn);

  { ? }
  fdFieldClassType = (fdcHeader,     fdcText,     fdcLine,       fdcBitmap,
                      fdcTable,      fdcPage,     fdcFormula,    fdcBox,
                      fdcDbfield,    fdcFieldCol, fdcFormulaCol, fdcMaxSize,
                      fdcGroup,      fdcStrings);

  { ? }
  fdOrientationType = (fdoPortrait, fdoLandscape);

  { BarCode Type }
  // HM 12/01/03: Added support for Health Industry Bar Code (HIBC)
  fdBarCodeType = (bcNone,    bcCode39, bcCode128, bcInter25, bcCodabar,
                   bcPostnet, bcUPCA,   bcUPCE,    bcEAN8,    bcEAN13,
                   bcHIBC);

  ResultValueType = Record
    StrResult     : String;
    DblResult     : Double;
  End; { ResultValueType }

  SplitFnameType = Record
    Path         : ShortString;
    Name         : ShortString;
    Extension    : ShortString;
    PathName     : ShortString;
    Filename     : ShortString;
  End; { SplitFnameType }

  { Paper Sizes - stores the default sizes set up by the user }
  PaperSizeType = Record
    psUser        : Boolean;      { Defined by user }
    psDescr       : fhNameType;
    psHeight      : Word;
    psWidth       : Word;
    psTopWaste    : Word;
    psBottomWaste : Word;
    psLeftWaste   : Word;
    psRightWaste  : Word;
    Spare         : Array [1..50] Of Char;
  End; { PaperSizeType }

  { Stores a font }
  fdFontDefType = Record
    ffName  :  String32;        { Font Name }
    ffSize  :  Integer;         { Font Size }
    ffColor :  TColor;          { Font Color }
    ffStyle :  TFontStyles;     { Bold, Italic, etc }
    ffPitch :  TFontPitch;      {}
    ffHeight:  Integer;         {}
  End; { fdFontDefType }
  { If this structure is changed update FontsAreEqual in FormUtil.Pas }

  { Defines a controls if condition }
  fdIfInfoType = Record
    fiIf       : String[200];
  End; { fdIfInfoType }

  { fdHeaderRecType: Stores details about the form structure }
  {                  1 per form                              }
  fdHeaderRecType = Record
    fhMajVer      : Word;
    fhMinVer      : Word;

    fhFormType    : fdFormTypeType;

    fhFormDescr   : fhNameType;
    fhCopies      : Byte;

    fhPaperWidth  : Word;
    fhPaperHeight : Word;
    fhTopWaste    : Word;
    fhLeftWaste   : Word;
    fhRightWaste  : Word;
    fhBottomWaste : Word;
    fhSections    : TPageStructureSet;
    fhOrientation : fdOrientationType;
    fhFont        : fdFontDefType;
    fhHeaderSep   : Word;
    fhBodyHeadSep : Word;
    fhBodySep     : Word;
    fhBodyFootSep : Word;
    fhContinue    : String255;               { actually 8.3 filename }
    fhSerialNo    : Byte;
    fhSNoWidth    : Word;

    fhPrinter     : String20;
    fhBinNo       : LongInt;                 { Windows Printer Bin Number }
    fhPaperNo     : LongInt;                 { Windows Paper No }

    { Label dimension and layout. Added 18/02/97 MH }
    fhLblTop      : Word;                    { top of label 1 }
    fhLblLeft     : Word;                    { left of label 1 }
    fhLblWidth    : Word;                    { label width }
    fhLblHeight   : Word;                    { label height }
    fhLblCols     : Byte;                    { labels across }
    fhLblRows     : Byte;                    { labels down }
    fhLblColGap   : Word;                    { Horizontal gap between labels }
    fhLblRowGap   : Word;                    { Vertical gap between labels }
    fhPurpose     : Byte;                    { Use for Form/Label }

    fhInpSNo      : Boolean;                 { Show Input Serial Numbers }

    // HM v4.32 06/02/01: Added support for printing hidden ADJ lines
    fhPrintAdjBom : Byte;

    // HM v4.32 -6/02/01: Added support for sorting normal documents
    fhDocSortMode : Byte;

    // HM 28/08/03 v5.52: Added Bin and Expiry Date support to Serial Numbers
    fhShowBins    : Boolean;
    fhShowUseBy   : Boolean;

    // HM 03/11/03 v5.52: Added flag to sort Picking Lists in StockCode+BinPriority order
    fhStockOrder  : Boolean;

    // HM 14/01/04: v5.60 Added flag to control whether Additional Description Lines are shown on Picking Lists
    fhShowAddDesc : Boolean;

    // MH 18/04/06: IAO/v5.71 - Added a flag to suppress the updating of the Debt Chase Letter information on Transactions
    fhSuppressDL  : Boolean;

    // MH 04/09/06: IAO/v5.71 - Added additional flags for picking lists
    fhShowDescOnly: Boolean;  // Include non-stock/description only lines in single picking lists
    fhInclNewLines: Boolean;  // Include TL's with 0 Picking Run Number

    // MH 13/03/09: v6.01 - Added additional additional flags for picking lists
    fhExplodeBoMs : Boolean; // Explode Hidden Bill of Materials Line into Picking Lists

    fhSpare       : Array [1..47] Of Char;
  End; { fdHeaderRecType }

  fdFormStringsType = Record
    fsSVStrs        : Array [1..10] Of String30;
    fsSpare         : Array [1..640] Of Char;
  End; { fdFormStringsType }
  fdFormStringsTypePtr = ^fdFormStringsType;

  { fdTextRecType: Stores details about a Text field }
  {                1 per text field                  }
  fdTextRecType = Record
    ftXPos        : Word;
    ftYPos        : Word;
    ftWidth       : Word;
    ftHeight      : Word;
    ftText        : Str255;
    ftFont        : fdFontDefType;
    ftJustify     : TAlignment;
    ftIf          : fdIfInfoType;

    // HM 13/11/00: Added support for Symbol Fonts
    ftSymbolFont  : Boolean;

    ftSpare       : Array [1..76] Of Char;
  End; { fdTextRecType }

  { fdLineRecType: Stores details about a Line }
  {                1 per Line                  }
  fdLineRecType = Record
    flXPos1       : Word;
    flYPos1       : Word;
    flXPos2       : Word;
    flYPos2       : Word;
    flPenWidth    : Byte;
    flColor       : TColor;
    flType        : TSBSDragLineType;
    flIf          : fdIfInfoType;

    flSpare       : Array [1..89] Of Char;
  End; { fdLineRecType }

  { fdBitmapRecType: Stores details about a Bitmap field }
  {                  1 per bitmap field                  }
  fdBitmapRecType = Record
    fbXPos        : Word;
    fbYPos        : Word;
    fbWidth       : Word;
    fbHeight      : Word;
    fbBitmapPath  : Str255;
    fbIf          : fdIfInfoType;

    fbSpare       : Array [1..89] Of Char;
  End; { fdBitmapRecType }

  { fdPageRecType: Stores details about a Page no field }
  {                1 per Page no field                  }
  fdPageRecType = Record
    fpXPos        : Word;
    fpYPos        : Word;
    fpWidth       : Word;
    fpHeight      : Word;
    fpLeading     : String50;
    fpTrailing    : String50;
    fpFont        : fdFontDefType;
    fpIf          : fdIfInfoType;
    fpJustify     : TAlignment;

    fpSpare       : Array [1..88] Of Char;
  End; { fdPageRecType }

  { fdBoxRecType: Stores details about a box field }
  {               1 per box field                  }
  fdBoxRecType = Record
    fxXPos         : Word;
    fxYPos         : Word;
    fxWidth        : Word;
    fxHeight       : Word;
    fxPenWidth     : Word;
    fxPenColor     : TColor;
    fxLeftBorder   : Boolean;
    fxTopBorder    : Boolean;
    fxRightBorder  : Boolean;
    fxBottomBorder : Boolean;
    fxFill         : Boolean;
    fxIf           : fdIfInfoType;

    fxSpare        : Array [1..89] Of Char;
  End; { fdBoxRecType }

  { fdDbFieldRecType: Stores details about a Database Field control }
  {                   1 per Database Field control                  }
  fdDbFieldRecType = Record
    fdXPos        : Word;
    fdYPos        : Word;
    fdWidth       : Word;
    fdHeight      : Word;
    fdFont        : fdFontDefType;
    fdSpare2      : SmallInt;       { SPARE }
    fdShortCode   : String10;
    fdFieldLen    : Byte;
    fdDecs        : Byte;
    fdAlign       : TAlignment;
    fdBlankIfZero : Boolean;
    fdIf          : fdIfInfoType;

    fdSpare       : Array [1..88] Of Char;
  End; { fdDbFieldRecType }

  { fdDbFieldColType: Stores details about a Database Field control }
  fdDbFieldColType = Record
    fdTitle       : String50;
    fdWidth       : SmallInt;
    fdSpare2      : SmallInt;    { SPARE }
    fdShortCode   : String10;
    fdFieldLen    : Byte;
    fdAlign       : TAlignment;
    fdColFont     : fdFontDefType;
    fdWantSep     : Boolean;
    fdDecs        : Byte;
    fdHidden      : Boolean;
    fdBlankIfZero : Boolean;
    fdIf          : fdIfInfoType;

    fdSpare       : Array [1..87] Of Char;
  End; { fdDbFieldColType }

  { fdTableRecType: Stores details about a Database Table control }
  fdTableRecType = Record
    frXPos       : Word;
    frYPos       : Word;
    frWidth      : Word;
    frHeight     : Word;
    {frTitleFont  : fdFontDefType;}

    frFonts        : Array [1..1] Of fdFontDefType;
    frFontSpare    : Array [1..5] Of fdFontDefType;
    frEnable       : Array [1..11] Of Boolean;
    frEnableSpare  : Array [1..11] Of Boolean;
    frPenWidth     : Array [1..10] Of Byte;
    frPenWSpare    : Array [1..10] Of Byte;
    frColour       : Array [1..10] Of TColor;
    frColourSpare  : Array [1..10] Of TColor;
    frSizes        : Array [1..2] Of Integer;
    frSizeSpare    : Array [1..10] Of Integer;
    frIf           : fdIfInfoType;

    frSpare        : Array [1..89] Of Char;
  End; { fdTableRecType }

  { fdFormulaRecType: Stores details about a formula field }
  fdFormulaRecType = Record
    ffXPos        : Word;
    ffYPos        : Word;
    ffWidth       : Word;
    ffHeight      : Word;
    ffFont        : fdFontDefType;
    ffFormula     : String200;
    ffDecs        : Byte;
    ffAlign       : TAlignment;
    ffBlankIfZero : Boolean;
    ffIf          : fdIfInfoType;
    ffHidden      : Boolean;

    { MH 20/08/97: Added for Bar Code support }
    ffBarCode     : fdBarCodeType;
    ffBCFlag1     : LongInt;
    ffBCFlag2     : LongInt;
    ffBCFlag3     : LongInt;

    ffSpare       : Array [1..74] Of Char;
  End; { fdFormulaRecType }

  { fdDbFormulaColType: holds details about a Formula Column in a Table }
  {                     control.                                        }
  fdDbFormulaColType = Record
    ffTitle       : String50;
    ffWidth       : SmallInt;
    ffAlign       : TAlignment;
    ffColFont     : fdFontDefType;
    ffWantSep     : Boolean;
    ffFormula     : String200;
    ffDecs        : Byte;
    ffHidden      : Boolean;
    ffBlankIfZero : Boolean;
    ffIf          : fdIfInfoType;

    { MH 20/08/97: Added for Bar Code support }
    ffBarCode     : fdBarCodeType;
    ffBCFlag1     : LongInt;
    ffBCFlag2     : LongInt;
    ffBCFlag3     : LongInt;

    ffSpare       : Array [1..74] Of Char;
  End; { fdDbFormulaColType }

  fdGroupRecType = Record
    fgXPos       : Word;
    fgYPos       : Word;
    fgWidth      : Word;
    fgHeight     : Word;
    fgIf         : fdIfInfoType;
    fgRows       : Array [1..50] Of Word;
    fgSpare      : Array [1..500] Of Byte;
  End; { fdGroupRecType }

  fdMaxSizeType = Record
    Max : Array [1..960] Of Char;
  End; { fdMaxSizeType }

  { FormDef: Stores a field of the form }
  { 0: fdRepClass + fdFieldOrder }
  FormDefRecType = Record
    fdRepClass   : fdRepClassType;
    fdFieldOrder : Word;               { Creation Order of controls }
    fdControlId  : String10;
    fdGroup      : String10;
    fdSpare      : Array [1..8] Of Char;

    Case fdFieldClass : fdFieldClassType Of
      fdcHeader     : (Header      : fdHeaderRecType);
      fdcStrings    : (FormStrings : fdFormStringsType);
      fdcText       : (Text        : fdTextRecType);
      fdcLine       : (Line        : fdLineRecType);
      fdcBitmap     : (Bitmap      : fdBitmapRecType);
      fdcBox        : (Box         : fdBoxRecType);
      fdcPage       : (PageNo      : fdPageRecType);
      fdcDbfield    : (DbField     : fdDbFieldRecType);
      fdcTable      : (Table       : fdTableRecType);
      fdcFieldCol   : (FieldCol    : fdDbFieldColType);
      fdcFormulaCol : (FormulaCol  : fdDbFormulaColType);
      fdcFormula    : (Formula     : fdFormulaRecType);
      fdcGroup      : (Group       : fdGroupRecType);
      fdcMaxSize    : (MaxSize     : fdMaxSizeType);
  End; { FormDefRecType }

  TFormDefListObjType = Class (TObject)
    FormDef    : FormDefRecType;
    ValueSet   : Boolean;
    CurrString : String;          { String value of current row }
    CurrValue  : Double;          { Double value of current row }
    LastString : String;          { String value of previous row }
    LastValue  : Double;          { Double value of previous row }
    TotalValue : Double;          { Running total for row }
    Constructor Create;
  Public
    Function GetIf : fdIfInfoType;
  End; { TFormDefListObjType }

  { Clipboard record structure }
  FormDefClipType = Record
    NoItems : SmallInt;
    Items   : Array [1..50] Of FormDefRecType;
  End; { FormDefClipType }

  { Print Batch }
  BatchRepInfoType = Record
    { NOTE: The batching structures are not used by the }
    {       Form Designer EXE.                          }
    StaAgedDate  :  Str10;
    ShowMonthDoc,
    SepCr,
    UseScr,
    FoundSta     :  Boolean;
    RepPtr       :  Pointer;
    ThisCr       :  Byte;
    //CrFlags      :  Array[0..30] of Boolean;
    CrFlags      :  Array[0..90] of Boolean;     { HM 08/05/00: fixed as wasn't updated in v4.31 code changes }
    SFName       :  Str255;
    DebtLetter   :  Byte;     { 1 - 3 }
  End; { BatchRepInfoType }

  { v5.01. EL 25/10/2002.  Print Serial Number Stock Label supporting Record. }

  BatchRepSNoInfoType = Record
    RecSize     :  SmallInt;  {Validation check size of record}

    SNoRecAddr  :  LongInt;   {Btrieve record address}

    SNoKey      :  Str255;    {SerialNo Key}

    Spare       :  Array[1..500] of Byte;

  end;
  pBatchRepSNoInfoType = ^BatchRepSNoInfoType;

  PrintBatchRecType = Record
    {pbPrinterNo : Integer;              { Printer number to print it on }
    {pbPreview   : Boolean;              { True = Print to Preview, False = Print To Printer }
    pbDefMode   : Integer;              { Mode of form }
    pbEFDName   : String8;              { 8 char name of EFD file }
    pbMainFNum  : Integer;              { Number of table driving file }
    pbMainKPath : Integer;              { key of table driving file}
    pbMainKRef  : Str255;               { key to match for table }
    pbTablFNum  : Integer;              { Number of table driving file }
    pbTablKPath : Integer;              { key of table driving file}
    pbTablKRef  : Str255;               { key to match for table }
    pbDescr     : Str100;               { Description displayed on error }

    { IFDEF MH}
    pbLabel1    : Byte;                 { Number of 1st label to print to }
    pbLbCopies  : Byte;                 { Number of iterations of label }
    pbTestMode  : Boolean;              { True = Print Controls as Test Mode }
    { ENDIF}

    pbRepInfo   : BatchRepInfoType;
  End; { PrintBatchRecType }

  TPrintBatchObjType = Class (TObject)
    PrintBatch : PrintBatchRecType;
  End; { TFormDefListObjType }


  { System information }
  SystemInfoType = Record
    ExVersionNo      : LongInt;
    MainForm         : TForm;
    AppHandle        : TApplication;
    {$If Defined(FORMTK)}
    ExDataPath       : ShortString;
    {$Else}
    ExDataPath       : String50;
    {$IfEnd}
    ControllerHandle : Pointer;
    DefaultFont      : TFont;
    FormDesVer       : String30;
    DebugOpen        : Boolean;
    AppPrinter       : TObject;
    {$If Defined(FORMTK)}
    EnterprisePath   : ShortString;
    {$IfEnd}
  End; { SystemInfoType }

  TIfLabelEvent = procedure(Sender: TObject; IfLabel: TObject) of object;

  { Used by GetFormInfo }
  FormInfoType = Record
    Copies     : SmallInt;
    PrinterNo  : SmallInt;
    Orient     : fdOrientationType;
    BinNo      : LongInt;
    PaperNo    : LongInt;

    { IFDEF MH}
    FormHeader : fdHeaderRecType;
    { ENDIF}
  End; { FormInfoType }

  // RPDD HM 28/11/02: Added Drill-Down support
  EntCopyDataRecType = Record
    DataId  : SmallInt;

    Case SmallInt of
      // Maximum Size record
      0  : (
            Spare : Array [1..1020] Of Byte;
           );

      // Preview Drill-Down Info
      1  : (
            ddLevelNo    : Byte;
            ddKeyString  : ShortString;  // DDS1
            ddFileNo     : SmallInt;     // DDI1
            ddIndexNo    : SmallInt;     // DDI2
            ddMode       : Byte;         // DDB1
           );
  End; { PreviewDrillDownRecType }

Var
  SystemInfo : SystemInfoType;
  TxLateCR   : Boolean;
  ClassicTB  : Boolean;
  {$If Defined(FORMTK)}
  LastErDesc : ANSIString;
  {$IfEnd}

implementation

Constructor TFormDefListObjType.Create;
Begin
  Inherited Create;

  ValueSet   := False;
  CurrString := '';
  CurrValue  := 0.0;
  LastString := '';
  LastValue  := 0.0;
  TotalValue := 0.0;
End;

Function TFormDefListObjType.GetIf : fdIfInfoType;
Begin
  FillChar (Result, SizeOf (Result), #0);

  Case FormDef.fdFieldClass Of
    fdcText       : Result := FormDef.Text.ftIf;
    fdcLine       : Result := FormDef.Line.flIf;
    fdcBitmap     : Result := FormDef.Bitmap.fbIf;
    fdcTable      : Result := FormDef.Table.frIf;
    fdcPage       : Result := FormDef.PageNo.fpIf;
    fdcFormula    : Result := FormDef.Formula.ffIf;
    fdcBox        : Result := FormDef.Box.fxIf;
    fdcDbfield    : Result := FormDef.DbField.fdIf;
    fdcGroup      : Result := FormDef.Group.fgIf;
    fdcFieldCol   : Result := FormDef.FieldCol.fdIf;
    fdcFormulaCol : Result := FormDef.FormulaCol.ffIf;
  End; { Case }
End;

Initialization
//ShowMessage ('PreviewDrillDownRecType: ' + IntToStr(SizeOf(PreviewDrillDownRecType)));
//ShowMessage ('PaperSizeType: ' + IntToStr(SizeOf(PaperSizeType)));

  TxLateCR := False;
  ClassicTB := False;

  FillChar (SystemInfo, SizeOf (SystemInfo), #0);
  With SystemInfo Do Begin
    ExVersionNo := 1;  { Bog Standard with no nothing }
    MainForm         := Nil;
    AppHandle        := Nil;
    ControllerHandle := Nil;
    DefaultFont      := Nil;
    DebugOpen        := False;
    AppPrinter       := Nil;
  End; { With }
end.
