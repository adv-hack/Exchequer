unit GlobalTypes;

interface

uses
  RpDefine, RpDevice, // RAVE
  Classes, Graphics, Types, Messages, // Delphi
  //EntLicence, // exchequer
  {$IFDEF REP_ENGINE}
  // HM 01/04/05: Removed as not needed
  //RptPersist,
  {$ENDIF}
  CtrlPrms,
  VarConst
{$IFDEF REP_ENGINE}
  , ExBtTh1u
{$ENDIF REP_ENGINE}
  ; // my own

const
  // MH 17/10/2016 2017-R1 ABSEXCH-17754: New colour scheme for VRW
  DefaultBackgroundColour : TColor = $00ebebeb;  // Advanced approved Light Grey
  DefaultFontColour : TColor = $00636363;        // Advanced approved Dark Grey

  SECURITY_PARAMETER = 'JLHABB';

  REPORT_FILE_EXTENSION = '.ERF';

  REPORT_SUB_DIRECTORY = 'REPORTS\';

  // HM 01/03/05: Moved to history.pas
  //GUI_VERSION = 'PREVIEW 2.22';

type
  PFontRec = ^TFontRec;
  TFontRec = record
    Colour : TColor;
    Height : Integer;
    Pitch : TFontPitch;
    Size : Integer;
    Style : TFontStyles; 
  end;

const
  FONT_NAME_SIZE = 32;

var
  // globally used debug stringlist...
  // just add debug to this list and it will be save to file
  // c:\rw_debug.log on application exit.
  slDebug : TStringList;

  FRegionFontList : TStringList;

type
  TProgressMonitorEvent = procedure(PercentComplete : SmallInt; var AAbort : Boolean) of object;

  TEnterpriseFiles = ( PLACE_HOLDER,
      Customer, Supplier, Document_Header,
      Document_Details, Nominal, Stock,
      Cost_Centre, Department, Fixed_Asset_Register,
      Bill_Of_Materials, Job_Costing, Multi_Loc_Stock,
      User_List, Discount_Matrix, Job_Notes,
      Serial_Batch, Analysis_Codes, Job_Types,
      Time_Rates, FIFO, Employees, Job_Records, Job_Actuals,
      Job_Retentions, Job_Budgets, Locations,
      Stock_Locations, Matched_Payments, Customer_Notes,
      Supplier_Notes, Stock_Notes, Trans_Notes, CIS_Vouchers, Multi_Bins );

  TReportDesignMode = ( CONTROL_CREATION, CONTROL_MANAGEMENT );

  TActiveRegion = ( NONE, HEADER_ACTIVE, BODY_ACTIVE, FOOTER_ACTIVE );

  TReportTreeMode = ( IGNORE, TREE_CLOSE, TREE_EDIT, TREE_ADD, TREE_PRINT, TREE_DELETE,
                      TREE_NODE_MOVE, TREE_NODE_DROP, TREE_NODE_COPY, TREE_IMPORT_REPORT );

  TWizardMode = ( NEW_REPORT, CHANGE_SORT_ORDER );

  TRegionIconID = ( REPORT_HEADER_ICON, PAGE_HEADER_ICON, SECTION_HEADER_ICON, DETAIL_LINES_ICON,
                                                             SECTION_FOOTER_ICON, PAGE_FOOTER_ICON, REPORT_FOOTER_ICON );

  TTotalUpdateMethod = ( RESET_TOTAL, UPDATE_TOTAL );

  TAlignNotifyType = (LIST_ADDITION, LIST_REMOVAL,
                       FIND_ALIGN_LEFT, FIND_ALIGN_RIGHT, FIND_ALIGN_TOP, FIND_ALIGN_BOTTOM,
                         SET_ALIGN_LEFT, SET_ALIGN_RIGHT, SET_ALIGN_TOP, SET_ALIGN_BOTTOM);

  TSelectDefinition = ( NO_DEFINITION, SELECTION_CRITERIA, PRINT_IF_CRITERIA, FORMULA_DEFINE );
                         
const
  // the proportions of the report regions to each other, expressed as a percentage of the overall page height
  aRegionProportions : array [HEADER_ACTIVE..FOOTER_ACTIVE] of Byte = (20, 65, 15);

  // Height of the region '(in)active' banner
  REGION_BANNER_HEIGHT = 20;
  // Margin of 'paper', backgound panel and region dividers from left and/or top of scrollbox in report designer.
  BACKGROUND_MARGIN = 5;

  REPORT_HEADER = 1;
  PAGE_HEADER = 2;
  LINES = 3;
  PAGE_FOOTER = 4;
  REPORT_FOOTER = 5;

  aRegionNames : array [1..5] of ShortString =
  ('REPORT_HEADER',
   'PAGE_HEADER',
   'LINES',
   'PAGE_FOOTER',
   'REPORT_FOOTER');

  SECTION = 'SECTION';
  HEADER = 'HEADER';
  FOOTER = 'FOOTER';

  // Report Control Status -- Removed, as not used, and doesn't compile under
  // Delphi 6 Service Pack 2
{
  NO_STATUS = 00h;
  CONTROL_CREATED = 01h;
  CONTROL_APPEARANCE_CHANGE = 02h;
  CONTROL_SELECTED = 04h;
  CONTROL_DESELECTED = 08h;
  CONTROL_PICKED = 16h;
  CONTROL_MOVING = 32h;
  CONTROL_DROPPED = 64h;
  CONTROL_RESIZE = 128h;
  CONTROL_STATIC = 256h;
  CONTROL_MULTI_SELECTED = 512h;
  CONTROL_DOUBLE_CLICKED = 1024h;
}
  // Useful defines to make the code read easier :)
  NULL_CHAR = #0;
  TAB_CHAR = #9;

const
  // Used in DDFuncs.pas in LoadFieldList()
  TBL_CODE_LGTH = 2;

type
  TPaperParams = record
    ssPaperName : ShortString;
    siPaperIndex : SmallInt;
    siHeightPixels : SmallInt;
    siWidthPixels  : SmallInt;
    siHeightMM : SmallInt;
    siWidthMM  : SmallInt;
  end;

  TDecimalPlaces = record
    siQtyDecimals,
    siSalesDecimals,
    siCostDecimals : SmallInt;
  end;

{
  TMiscOptions = (
    DUMMY_OPTION,
    XLS_OPEN_AUTO,
    XLS_SHOW_HEADFOOT,
    XLS_SHOW_TOTALS,
    HTML_OPEN_AUTO,
    DBF_OPEN_AUTO,
    CSV_OPEN_AUTO
  );
}

  // Array indexes for PrintMethodParams.pmMiscOptions
  TPrintMethodOptions = (
    XLS_AUTO_OPEN = 1,
    XLS_SHOW_REPORT_HEADER,
    XLS_SHOW_PAGE_HEADER,
    XLS_SHOW_SECTION_HEADER,
    XLS_SHOW_REPORT_LINES,
    XLS_SHOW_SECTION_FOOTER,
    XLS_SHOW_PAGE_FOOTER,
    XLS_SHOW_REPORT_FOOTER,
    HTML_AUTO_OPEN,
    DBF_AUTO_OPEN,
    CSV_AUTO_OPEN,
    GEN_NO_MESSAGES,  //PR: 15/02/2011
    // CJS 2014-07-09 - ABSEXCH-15307 - CSV headers on export from VRW
    CSV_SHOW_SECTION_HEADER
  );

  TPrintMethodParams = record
    pmPrintMethod   : Byte;        // Flag: 0=Printer, 1=Fax, 2=Email, 3=XML, 4=File, 5=Excel, 6=Text, 7=HTML
    pmBatch         : Boolean;     // Flag: Printing a batch - disable To details as specified later
    pmTypes         : LongInt;     // Flag: 2=Allow Fax, 4=AllowEmail, 8=AllowXML, 16=AllowExcel, 32=HTML
    pmCoverSheet    : string[8];   // Cover Sheet
    pmFaxMethod     : Byte;        // Fax: Send method:- 0=Enterprise, 1=MAPI
    pmFaxPrinter    : SmallInt;    // Fax: Selected Printer
    pmFaxFrom       : string[50];  // Fax: From Name
    pmFaxFromNo     : string[30];  // Fax: From Fax Number
    pmFaxTo         : string[50];  // Fax: To Name
    pmFaxToNo       : string[30];  // Fax: To Fax Number
    pmFaxMsg        : AnsiString;  // Fax: Message (max 255)
    pmEmailMAPI     : Boolean;     // Email: Send using MAPI
    pmEmailFrom     : string[50];  // Email: From Name
    pmEmailFromAd   : string[50];  // Email: From Address
    pmEmailTo       : AnsiString;  // Email: Name
    pmEmailToAddr   : AnsiString;  // Email: Addr
    pmEmailCc       : AnsiString;
    pmEmailBcc      : AnsiString;
    pmEmailSubj     : AnsiString;  // Email: Subject
    pmEmailMsg      : AnsiString;  // Email: Message (max 255)
    pmEmailAttach   : AnsiString;  // Email: Attachments (for future use - maybe)
    pmEmailPriority : Byte;        // Email: Priority - 0=Low, 1=Normal, 2=High
    pmEmailReader   : Boolean;     // Email: Attach Acrobat/Exchequer Reader
    pmEmailZIP      : Byte;        // Email: ZIP Attachment as self-extracting .EXE
    pmEmailAtType   : Byte;        // Email: Attachment methodology:- 0-RPPro, 1-Adobe, 2-RAVE PDF, 3-RAVE HTML
    pmFaxPriority   : Byte;        // Fax: Priority:- 0=Urgent, 1=Normal, 2=OffPeak
    pmXMLType       : Byte;        // XML Method: 0=File, 1=Email
    pmXMLCreateHTML : Boolean;     // XML: Also create HTML file
    pmXMLFileDir    : ANSIString;  // XML: Path to save .XML File in
    pmEmailFName    : string[30];  // Email form attachment name
    // Array of miscellaneous booleans for storing misc options from print dialog
    // Print to Excel : 1=Open XLS automatically, 2=Hide Page Headers/Footers, 3=Hide Totals
    // Print to HTMl  : 1=Open .HTML automatically
    // 10 = When printing a form which is account based, override cover sheets from account details
    pmMiscOptions   : array [1..30] of Boolean;
  end;

  TTestModeParams = record
    TestMode : Boolean;
    SampleCount : SmallInt;
    RefreshStart, RefreshEnd : Boolean;
    FirstRecPos, LastRecPos : LongInt;
  end;

  TReportConstructInfo = record
    ssLoggedInUser : ShortString;
    ssMainFile : ShortString;
    byMainFileNum : Byte;
    byOrigMainFileNum : Byte;
    // byIndexID can only set for Document Header (3) Document Details (4) and Job Actuals (23)
    // see also the aIndexedFiles array below.
    byIndexID : Byte;
    iBTrvKeyPath : Integer;
    ssReportTempRaveName : ShortString;
    PaperParameters : TPaperParams;
    oPaperOrientation : TOrientation;
    PrintMethodParams : TPrintMethodParams;
    TestModeParams : TTestModeParams;

    // HM 09/03/05: Added input field info for main file index
    IndexInput : TInputLineRecord;
  end;

const
  NUMBER_OF_INDEXED_FILES = 3;
  aIndexedFiles : array [1..NUMBER_OF_INDEXED_FILES] of Byte = (3, 4, 23);

const
  MAX_PAPER_SIZES = 68;
  RW_PAPER_WIDTH = 1;
  RW_PAPER_HEIGHT = 2;
  aRWPaperSizes : array[1..MAX_PAPER_SIZES,1..2] of SmallInt =
  ((300,275), // DMPAPER_LETTER       = 1   Letter 8 12 x 11 in
   (300,275), // DMPAPER_LETTERSMALL  = 2   Letter Small 8 12 x 11 in
   (275,425), // DMPAPER_TABLOID      = 3   Tabloid 11 x 17 in
   (425,275), // DMPAPER_LEDGER       = 4   Ledger 17 x 11 in
   (300,350), // DMPAPER_LEGAL        = 5   Legal 8 12 x 14 in
   (300,300), // DMPAPER_STATEMENT    = 6   Statement 5 12 x 8 12 in
   (350,300), // DMPAPER_EXECUTIVE    = 7   Executive 7 14 x 10 12 in
   (297,420), // DMPAPER_A3           = 8   A3 297 x 420 mm
   (210,297), // DMPAPER_A4           = 9   A4 210 x 297 mm
   (210,297), // DMPAPER_A4SMALL      = 10  A4 Small 210 x 297 mm
   (148,210), // DMPAPER_A5           = 11  A5 148 x 210 mm
   (250,354), // DMPAPER_B4           = 12  B4 (JIS) 250 x 354
   (182,257), // DMPAPER_B5           = 13  B5 (JIS) 182 x 257 mm
   (300,325), // DMPAPER_FOLIO        = 14  Folio 8 12 x 13 in
   (215,275), // DMPAPER_QUARTO       = 15  Quarto 215 x 275 mm
   (250,350), // DMPAPER_10X14        = 16  10x14 in
   (275,425), // DMPAPER_11X17        = 17  11x17 in
   (300,275), // DMPAPER_NOTE         = 18  Note 8 12 x 11 in
   (78,203),  // DMPAPER_ENV_9        = 19  Envelope #9 3 78 x 8 78
   (103,237), // DMPAPER_ENV_10       = 20  Envelope #10 4 18 x 9 12
   (112,259), // DMPAPER_ENV_11       = 21  Envelope #11 4 12 x 10 38
   (118,275), // DMPAPER_ENV_12       = 22  Envelope #12 4 \276 x 11
   (125,300), // DMPAPER_ENV_14       = 23  Envelope #14 5 x 11 12
   (0,0),     // DMPAPER_CSHEET       = 24  C size sheet
   (0,0),     // DMPAPER_DSHEET       = 25  D size sheet
   (0,0),     // DMPAPER_ESHEET       = 26  E size sheet
   (110,220), // DMPAPER_ENV_DL       = 27  Envelope DL 110 x 220mm
   (162,229), // DMPAPER_ENV_C5       = 28  Envelope C5 162 x 229 mm
   (324,458), // DMPAPER_ENV_C3       = 29  Envelope C3  324 x 458 mm
   (229,324), // DMPAPER_ENV_C4       = 30  Envelope C4  229 x 324 mm
   (114,162), // DMPAPER_ENV_C6       = 31  Envelope C6  114 x 162 mm
   (114,229), // DMPAPER_ENV_C65      = 32  Envelope C65 114 x 229 mm
   (250,353), // DMPAPER_ENV_B4       = 33  Envelope B4  250 x 353 mm
   (176,250), // DMPAPER_ENV_B5       = 34  Envelope B5  176 x 250 mm
   (176,125), // DMPAPER_ENV_B6       = 35  Envelope B6  176 x 125 mm
   (110,230), // DMPAPER_ENV_ITALY    = 36  Envelope 110 x 230 mm
   (96,187),  // DMPAPER_ENV_MONARCH  = 37  Envelope Monarch 3.875 x 7.5 in
   (90,162),  // DMPAPER_ENV_PERSONAL = 38  6 34 Envelope 3 58 x 6 12 in
   (371,275), // DMPAPER_FANFOLD_US   = 39  US Std Fanfold 14 78 x 11 in
   (300,300), // DMPAPER_FANFOLD_STD_GERMAN   = 40  German Std Fanfold 8 12 x 12 in
   (300,325), // DMPAPER_FANFOLD_LGL_GERMAN   = 41  German Legal Fanfold 8 12 x 13 in
   (250,353), // DMPAPER_ISO_B4               = 42  B4 (ISO) 250 x 353 mm
   (100,148), // DMPAPER_JAPANESE_POSTCARD    = 43  Japanese Postcard 100 x 148 mm
   (225,275), // DMPAPER_9X11                 = 44  9 x 11 in
   (250,275), // DMPAPER_10X11                = 45  10 x 11 in
   (375,275), // DMPAPER_15X11                = 46  15 x 11 in
   (220,220), // DMPAPER_ENV_INVITE           = 47  Envelope Invite 220 x 220 mm
   (0,0),     // DMPAPER_RESERVED_48          = 48  RESERVED--DO NOT USE
   (0,0),     // DMPAPER_RESERVED_49          = 49  RESERVED--DO NOT USE
   (243,300), // DMPAPER_LETTER_EXTRA         = 50  Letter Extra 9 \275 x 12 in
   (243,375), // DMPAPER_LEGAL_EXTRA          = 51  Legal Extra 9 \275 x 15 in
   (292,450), // DMPAPER_TABLOID_EXTRA        = 52  Tabloid Extra 11.69 x 18 in
   (231,317), // DMPAPER_A4_EXTRA             = 53  A4 Extra 9.27 x 12.69 in
   (218,275), // DMPAPER_LETTER_TRANSVERSE    = 54  Letter Transverse 8 \275 x 11 in
   (210,297), // DMPAPER_A4_TRANSVERSE        = 55  A4 Transverse 210 x 297 mm
   (243,300), // DMPAPER_LETTER_EXTRA_TRANSVERSE = 56  Letter Extra Transverse 9\275 x 12 in
   (227,356), // DMPAPER_A_PLUS               = 57  SuperASuperAA4 227 x 356 mm
   (305,487), // DMPAPER_B_PLUS               = 58  SuperBSuperBA3 305 x 487 mm
   (212,317), // DMPAPER_LETTER_PLUS          = 59  Letter Plus 8.5 x 12.69 in
   (210,330), // DMPAPER_A4_PLUS              = 60  A4 Plus 210 x 330 mm
   (148,210), // DMPAPER_A5_TRANSVERSE        = 61  A5 Transverse 148 x 210 mm
   (182,257), // DMPAPER_B5_TRANSVERSE        = 62  B5 (JIS) Transverse 182 x 257 mm
   (322,445), // DMPAPER_A3_EXTRA             = 63  A3 Extra 322 x 445 mm
   (174,235), // DMPAPER_A5_EXTRA             = 64  A5 Extra 174 x 235 mm
   (201,276), // DMPAPER_B5_EXTRA             = 65  B5 (ISO) Extra 201 x 276 mm
   (420,594), // DMPAPER_A2                   = 66  A2 420 x 594 mm
   (297,420), // DMPAPER_A3_TRANSVERSE        = 67  A3 Transverse 297 x 420 mm
   (332,445)); // DMPAPER_A3_EXTRA_TRANSVERSE = 68  A3 Extra Transverse 322 x 445 mm

const
// Pixels := Round(MM * ScalingFactor)
// MM := Round(Pixels / ScalingFactor)
// It's been changed from 3.2 to 3.0 because...
// 3.0 is the scaling factor that Form Designer uses and...
// with 3.2 there appeared to be a rounding issue with some of the scaling from pixels to paper
// and fields that appeared to be evenly lined up where out of position when printed (to screen or paper)
//  ScalingFactor = 3.2;
  ScalingFactor = 3.0;

  // HM 03/03/05: Changed the delimiter to a character more unlikely to be within
  // the data returned from the formula parser.
  ReportRowFieldDelimiter = #9; //'~';

var
  GRWSecurityOK : Boolean;

  ReportConstructInfo : TReportConstructInfo;
  EnterpriseDPs : TDecimalPlaces;

  bGReportChanged : boolean;

  //EntLic : TEnterpriseLicence;

  GReportPath : ShortString;
  GReportUser : ShortString;

  GAllowTreeSecurity : Boolean;

  GRWDebug : boolean;

type
  TFileRef = class(TObject)
    frFileName : ShortString;
    frFileIndex : SmallInt;

    constructor Create;
  end;

  TRawBMPStore = class(TObject)
    iBMPSize : Integer;
    pBMP : Pointer;

    constructor Create;
    destructor Destroy; override;
  end;

  TPrintBaseParams = class(TObject)
  public
    ControlType : TCtrlType;
    ControlBorder : TRect;

    constructor Create;
    destructor Destroy; override;
  end;

  TPrintTextParams = class(TPrintBaseParams)
  public
    szText : PChar;
    ftTextFont : TFont;

    constructor Create;
    destructor Destroy; override;
  end;

  TPrintLineParams = class(TPrintBaseParams)
  public
    LineExtents : TRect;
    LineWidth : SmallInt;
    LineColor : TColor;
    LineStyle : TPenStyle;
    LineOrientation : TLineOrientation;

    constructor Create;
    destructor Destroy; override;
  end;

  TPrintImageParams = class(TPrintBaseParams)
  public
    bmImage : TBitMap;

    constructor Create;
    destructor Destroy; override;
  end;

  TDataSetFormatting = record
    // L   Left justified
    // R   Right justified
    // R%  Right justified with trailing %
    // B   Blank if value is 0 (zero)
    // C   Centre field
    // C-  Centre field using - to pad it out
    ssFieldFormat : ShortString;
    // 1-9 A-D eg 1A 3B
    ssSortOrder : ShortString;
    bPrintField,                 // print field...overrides PrintIf
    bSubTotal,                   // sub total in the section footer.
    bSummaryOnly,                // summary only, report contains totals only for this field
    bReCalcBreak,                // re-calculate on break
    bSelectOnSummary : Boolean;  // select on summary
    PageBreakOnChange : Boolean; // if this is a sorted field then do a page break when it changes value
  end;

  TPrintDataSet = class(TPrintBaseParams)
  public
    ftTextFont : TFont;
    DBVarName : ShortString;
    ssSelectionCriteria,
    ssPrintIf : ShortString;
    siFieldNumber : SmallInt;
    DataFormatting : TDataSetFormatting;
    lstDataSet : TStringList;
    ssParsedInputLine : ShortString;
    DBVarType : Byte;
    DBFieldLen : Byte;
    DBNoDecs : Byte;

    constructor Create;
    destructor Destroy; override;
  end;

  TPrintFormulaParams = class(TPrintBaseParams)
  public
    ftTextFont : TFont;
    TotalType : TTotalType; 
    szTotalText : PChar;
    lstDataSet : TStringList;

    // used by totalling field so that they can pick out the field from 
    // the data set that is the field that the formula is totalling.
    ssFmlName : ShortString;
    siFieldNumber : Smallint;
    ssFormulaDefinition : ShortString;
    byDecPlaces : Byte;
    // L   Left justified
    // R   Right justified
    // R%  Right justified with trailing %
    // B   Blank if value is 0 (zero)
    // C   Centre field
    // C-  Centre field using - to pad it out
    ssFieldFormat : ShortString;

    bPrintField : Boolean;

    constructor Create;
    destructor Destroy; override;
  end;

  procedure SetPaperParams(var PaperParams : TPaperParams; const PrinterInfo : TSBSPrintSetupInfo);
  procedure GetPrintMethodParams(const PrintMethodParams : TPrintMethodParams; var PrinterInfo : TSBSPrintSetupInfo);
  procedure SetPrintMethodParams(var PrintMethodParams : TPrintMethodParams; const PrinterInfo : TSBSPrintSetupInfo);
  procedure ResetPrintMethodParams;

type
// HM 21/04/05: Extended object to handle routine operations on it
//  TSectionObj = class(TObject)
//    ssSectionName : ShortString;
//    EnabledOnReport : Boolean;
//    // The DefaultSections are RH, PH, LINES, PF and RF....*not* the Section Headers and Footers
//    DefaultSection : Boolean;
//
//    constructor Create;
//  end;
  TSectionType = (sstUnknown, sstRepHdr, sstPageHdr, sstSectionHdr, sstRepLines, sstSectionFtr, sstPageFtr, sstRepFtr);

  TSectionObj = class(TObject)
  Private
    FSectionName : ShortString;
    FSectionNumber : SmallInt;
    FSectionType : TSectionType;
    Function GetSectionCrudeName : ShortString;
    Procedure SetSectionName (Value : ShortString);
  Public
    //ssSectionName : ShortString;
    EnabledOnReport : Boolean;
    // The DefaultSections are RH, PH, LINES, PF and RF....*not* the Section Headers and Footers
    DefaultSection : Boolean;

    Property ssSectionCrudeName : ShortString Read GetSectionCrudeName;
    Property ssSectionName : ShortString Read FSectionName Write SetSectionName;
    Property ssSectionNumber : SmallInt Read FSectionNumber;
    Property ssSectionType : TSectionType Read FSectionType;

    Constructor Create; Overload;
    Constructor Create (SectionName : ShortString); Overload;
  end;

//  TWizardReportType = (wrtReport, wrtGroup);

//  TBasicReportInfo = record
//    ssReportName : ShortString;
//    ssReportDesc : ShortString;
//    wrType       : TWizardReportType;
//    oPaperOrientation : TOrientation;
//  end;

//  TMainReportFileInfo = record
//    ssMainFileName : ShortString;
//    siMainDbFile : SmallInt;
//    siIndex : SmallInt; // not always set, dependant on the siMainDbFile value
//  end;

  TDBFieldPrmsObj = class(TObject)
    VarNo  : LongInt;
    VarLen : Byte;
    VarDesc : ShortString;
    VarType : Byte;
    VarPeriod : Boolean;
    VarDecType : Byte;
    VarDecNo : Byte;

    constructor Create;
  end;

  TDatabaseFields = record
    dbFields : TStringList;  // NOTE: TDBFieldObj in objects property
  end;

  TDrillDownObj = class(TObject)
    ddLevelNo : Byte;
    ddMode : Byte;
    ddKeyString : ShortString;
    ddFileNo : SmallInt;
    ddIndexNo : SmallInt;

    constructor Create;
  end;

  TDBRowObj = class(TObject)
    ssRowString : ShortString;
    // a TStringList of TDrillDownObj, one for each field in ssRowString indexed by the field content
    slDrillDownInfo : TStringList;

    constructor Create;
    destructor Destroy; override;
  end;

  TSortOrder = (SORT_ASCENDING, SORT_DESCENDING);

  TSortObj = class(TObject)
    FieldName : ShortString;
    SortOrder : TSortOrder;
    PageBreak : boolean;

    constructor Create;
    destructor Destroy; override;
  end;

  TSortPage = record
    SortObjList : TStringList;
  end;

  TFilterObj = class(TObject)
    FilterDefinition : ShortString;

    constructor Create;
  end;

  TFieldFilters = record
    FilterList : TStringList;
  end;

//  TDBFieldColumn = Record
//    DictRect : DataVarType;
//    Caption  : ShortString;
//    //SubTotal : Boolean;
//  End; // TDBFieldColumn

//  TReportWizardParams = class(TObject)
//    wrReportName : ShortString;
//    wrReportDesc : ShortString;
//    wrType       : TWizardReportType;     // Type: wrtGroup or wrtReport
//    //oPaperOrientation : TOrientation;
//
//    wrMainFileName : ShortString;         // Description of Report File, e.g. Transaction Headers
//    wrMainDbFile : SmallInt;              // Id number of report file
//    wrIndex : SmallInt;                   // Is number of index for report file, 0 if N/A
//
//    wrDBFields List : TList;                   // List of ^TDBFieldColumn
//
//    //BasicReportInfo : TBasicReportInfo;
//    //MainReportFileInfo : TMainReportFileInfo;
//    //DatabaseFields : TDatabaseFields;
//    SortPage : TSortPage;
//    FieldFilters : TFieldFilters;
//    ReportSections : TStringList;
//
//    constructor Create;
//    destructor Destroy; override;
//  end;


// Calculates the RW Version No used by the Data Dictionary from the Licencing
// Information
Function VRWVersionNo : Byte;

{$IFDEF REP_ENGINE}
function Create_VRWReportFiles: Boolean;
{$ENDIF REP_ENGINE}

implementation

uses
  VarFPOSU,
  SysUtils,
{$IFDEF EX600}
  FileUtil,
  GlobVar,
{$ENDIF}
  EntLicence;
//  RWOpenF;

//=========================================================================

// Calculates the RW Version No used by the Data Dictionary from the Licencing
// Information:-
//
//   1    STD
//   2    STD+STK
//   3    Prof
//   4    Prof+STK
//   5    Prof+SPOP
//   6    Prof+SPOP+JC
//   7    MC
//   8    MC+STK
//   9    MC+SPOP
//   11   MC+SPOP+JC
//
Function VRWVersionNo : Byte;
Begin // VRWVersionNo
  With EnterpriseLicence Do
  Begin
    // Work out the version of the RW
    If elIsMultiCcy Then
    Begin
      // Euro / Global
      Result := 7;
      Result := Result + Byte(elModuleVersion);

      If (elModules[ModJobCost] <> mrNone) Then
        Result := 11;          // Work-around
//      Result := Result + 2;  // Correct
    End // If elIsMultiCcy
    Else
    Begin
      // Professional
      Result := 3;
      Result := Result + Byte(elModuleVersion);

      If (elModules[ModJobCost] <> mrNone) Then
        Result := 6;
//        Result := Result + 1;
    End; // Else

  End; // With EnterpriseLicence
//    Result := Result + Byte(elModuleVersion);
End; // VRWVersionNo

//=========================================================================

constructor TFileRef.Create;
begin
  inherited Create;

  frFileName := '';
  frFileIndex := 0;
end;

//=========================================================================

constructor TRawBMPStore.Create;
begin
  inherited Create;

  iBMPSize := 0;
  pBMP := nil;
end;

//------------------------------

destructor TRawBMPStore.Destroy;
begin
  if (assigned(pBMP)) then
    FreeMem(pBMP);

  inherited Destroy;
end;

//=========================================================================

constructor TPrintBaseParams.Create;
begin
  inherited Create;
end;

//------------------------------

destructor TPrintBaseParams.Destroy;
begin
  inherited Destroy;
end;

//=========================================================================

constructor TPrintTextParams.Create;
begin
  inherited Create;

  ControlType := REPORT_TEXT;

  szText := StrAlloc(255);
  FillChar(szText^, 255, 0);
  ftTextFont := TFont.Create;
end;

//------------------------------

destructor TPrintTextParams.Destroy;
begin
  StrDispose(szText);
  ftTextFont.Free;

  inherited Destroy;
end;

//=========================================================================

constructor TPrintLineParams.Create;
begin
  inherited Create;

  ControlType := REPORT_LINE;
end;

//------------------------------

destructor TPrintLineParams.Destroy;
begin
  inherited Destroy;
end;

//=========================================================================

constructor TPrintImageParams.Create;
begin
  inherited Create;

  ControlType := REPORT_IMAGE;
  bmImage := TBitMap.Create;
end;

//------------------------------

destructor TPrintImageParams.Destroy;
begin
  bmImage.Free;

  inherited Destroy;
end;

//=========================================================================

constructor TPrintDataSet.Create;
begin
  inherited Create;

  ControlType := REPORT_DB_FIELD;

  DBVarName := '';

  ssSelectionCriteria := '';
  ssPrintIf := '';

  siFieldNumber := -1;

  ftTextFont := TFont.Create;
  lstDataSet := TStringList.Create;

  with DataFormatting do
  begin
    ssFieldFormat := '';
    ssSortOrder := '';
    bPrintField := TRUE;
    bSubTotal := FALSE;
    bSummaryOnly := FALSE;
    bReCalcBreak := FALSE;
    bSelectOnSummary := FALSE;
    PageBreakOnChange := FALSE;
  end;

  ssParsedInputLine := '';

end;

//------------------------------

destructor TPrintDataSet.Destroy;
begin
  while (lstDataSet.Count > 0) do
    lstDataSet.Delete(0);
  lstDataSet.Free;

  ftTextFont.Free;

  inherited Destroy
end;

//=========================================================================

constructor TPrintFormulaParams.Create;
begin
  inherited Create;

  ControlType := REPORT_FORMULA;

  TotalType := NO_TOTAL;

  siFieldNumber := 0;
  byDecPlaces := 0;
  ssFieldFormat := 'L';

  bPrintField := TRUE;

  ssFormulaDefinition := '';
  ssFmlName := '';

  szTotalText := StrAlloc(255);
  FillChar(szTotalText^, 254, chr(0));
  szTotalText := StrPCopy(szTotalText,'0');

  lstDataSet := TStringList.Create;

  ftTextFont := TFont.Create;
end;

//------------------------------

destructor TPrintFormulaParams.Destroy;
begin
  StrDispose(szTotalText);

  while (lstDataSet.Count > 0) do
    lstDataSet.Delete(0);
  lstDataSet.Free;

  ftTextFont.Free;

  inherited Destroy;
end;

//=========================================================================

constructor TSectionObj.Create;
begin
  inherited Create;

  FSectionName := '';
  FSectionNumber := 0;
  FSectionType := sstUnknown;

  EnabledOnReport := TRUE;
  DefaultSection := TRUE;
end;
Constructor TSectionObj.Create (SectionName : ShortString);
Begin // Create
  inherited Create;

  FSectionNumber := 0;
  FSectionType := sstUnknown;
  EnabledOnReport := TRUE;
  DefaultSection := TRUE;

  SetSectionName(SectionName);
End; // Create

//-------------------------------------------------------------------------

Function TSectionObj.GetSectionCrudeName : ShortString;
Begin // GetSectionCrudeName
  Case FSectionType Of
    sstRepHdr     : Result := 'REPORT_HEADER';
    sstPageHdr    : Result := 'PAGE_HEADER';
    sstSectionHdr : Result := 'SECTION' + IntToStr(FSectionNumber) + 'HEADER';
    sstRepLines   : Result := 'LINES';
    sstSectionFtr : Result := 'SECTION' + IntToStr(FSectionNumber) + 'FOOTER';
    sstPageFtr    : Result := 'PAGE_FOOTER';
    sstRepFtr     : Result := 'REPORT_FOOTER';
  Else
    Raise Exception.Create('TSectionObj.GetSectionCrudeName: Unidentified Section Type (' + IntToStr(Ord(FSectionType)) + ')');
  End; // Case FSectionType
End; // GetSectionCrudeName

//------------------------------

Procedure TSectionObj.SetSectionName (Value : ShortString);
Var
  ErrCode : Integer;
Begin // SetSectionName
  FSectionName := Value;
  FSectionNumber := 0;

  // Convert to uppercase for checks as wizard produces mixed-case text
  Value := UpperCase(Trim(Value));
  If (Pos('SECTION', Value) > 0) Then
  Begin
    // 'SECTION1HEADER'/'SECTION1FOOTER' or 'Section 1 Header (ACACTYPE)'/'Section 1 Footer (ACACTYPE)'
    // must check this first as the dictionary field may matchup with later checks
    Delete (Value, 1, 7);
    If (Pos('HEADER', Value) > 0) Then
    Begin
      FSectionType := sstSectionHdr;
      Delete (Value, Pos('HEADER', Value), Length(Value))
    End // If (Pos('HEADER', Value) > 0)
    Else
    Begin
      FSectionType := sstSectionFtr;
      Delete (Value, Pos('FOOTER', Value), Length(Value))
    End; // Else

    // Extract Section Id
    Val(Trim(Value), FSectionNumber, ErrCode);
    If (ErrCode <> 0) Then Raise Exception.Create ('TSectionObj.SetSectionName: Unable to identify Section Number for ' + QuotedStr(FSectionName));
  End // If (Pos('SECTION', Value) > 0)
  Else If (Pos('LINES', Value) > 0) Then
    // 'LINES' or 'Report Lines'
    FSectionType := sstRepLines
  Else If (Pos('REPORT', Value) > 0) Then
  Begin
    // Report Header or Footer
    If (Pos('HEADER', Value) > 0) Then
      FSectionType := sstRepHdr
    Else
      FSectionType := sstRepFtr;
  End // If (Pos('REPORT', Value) > 0)
  Else If (Pos('PAGE', Value) > 0) Then
  Begin
    // Report Header or Footer
    If (Pos('HEADER', Value) > 0) Then
      FSectionType := sstPageHdr
    Else
      FSectionType := sstPageFtr;
  End // If (Pos('PAGE', Value) > 0)
  Else
    Raise Exception.Create ('TSectionObj.SetSectionName: Unidentified Section ' + QuotedStr(Value));

  DefaultSection := (FSectionType In [sstRepHdr, sstPageHdr, sstRepLines, sstPageFtr, sstRepFtr]);
End; // SetSectionName

//=========================================================================

constructor TDBFieldPrmsObj.Create;
begin
  inherited Create;

  VarNo := 0;
  VarLen := 0;
  VarType := 0;
  VarDesc := '';
  VarPeriod := FALSE;
  VarDecType := 0;
  VarDecNo := 0;
end;

//=========================================================================

constructor TDrillDownObj.Create;
begin
  inherited Create;

  ddLevelNo := 0;
  ddMode := 0;
  ddKeyString := '';
  ddFileNo := 0;
  ddIndexNo := 0;
end;

//=========================================================================

constructor TDBRowObj.Create;
begin
  inherited Create;

  ssRowString := '';
  slDrillDownInfo := TStringList.Create;
end;

//------------------------------

destructor TDBRowObj.Destroy;
begin
  while (slDrillDownInfo.Count > 0) do
    slDrillDownInfo.Delete(0);
  slDrillDownInfo.Free;

  inherited Destroy;
end;

//=========================================================================

//constructor TReportWizardParams.Create;
//begin
//  inherited Create;
//
//  wrReportName := '';
//  wrReportDesc := '';
//  wrType       := wrtReport;
//  //oPaperOrientation := poPortrait;
//
//  wrMainFileName := '';
//  wrMainDbFile := 0;
//  wrIndex := 0;
//
//  wrDBFields := TList.Create;
//
//  //DatabaseFields dbFields := TStringList.Create;
//  SortPage.SortObjList := TStringList.Create;
//  FieldFilters.FilterList := TStringList.Create;
//  ReportSections := TStringList.Create;
//
//end;
//
////------------------------------
//
//destructor TReportWizardParams.Destroy;
//Var
//  pDBField : ^DataVarType;
//begin
//  While (wrDBFields.Count > 0) Do
//  Begin
//    pDBField := wrDBFields[0];
//    FreeMem(pDBField, SizeOf(pDBField^));
//
//    wrDBFields.Delete(0);
//  End; // While (wrDBFields.Count > 0)
//  FreeAndNIL(wrDBFields);
//
////  while (DatabaseFields.dbFields.Count > 0) do
////    DatabaseFields.dbFields.Delete(0);
////  DatabaseFields.dbFields.Free;
//
//  while (SortPage.SortObjList.Count > 0) do
//  begin
//    TSortObj(SortPage.SortObjList.Objects[0]).Free;
//    SortPage.SortObjList.Delete(0);
//  end;
//  SortPage.SortObjList.Free;
//
//  while (FieldFilters.FilterList.Count > 0) do
//  begin
//    TFilterObj(FieldFilters.FilterList.Objects[0]).Free;
//    FieldFilters.FilterList.Delete(0);
//  end;
//  FieldFilters.FilterList.Free;
//
//  while (ReportSections.Count > 0) do
//  begin
//    TSectionObj(ReportSections.Objects[0]).Free;
//    ReportSections.Delete(0);
//  end;
//  ReportSections.Free;
//
//  inherited Destroy;
//end;
//
////=========================================================================

constructor TSortObj.Create;
begin
  inherited Create;

  SortOrder := SORT_ASCENDING;
  PageBreak := TRUE;
end;

//------------------------------

destructor TSortObj.Destroy;
begin
  inherited Destroy;
end;

//=========================================================================

constructor TFilterObj.Create;
begin
  inherited Create;

  FilterDefinition := '';
end;

//=========================================================================

procedure SetPaperParams(var PaperParams : TPaperParams; const PrinterInfo : TSBSPrintSetupInfo);
var
  siWidthMargin : SmallInt;
begin
  with PaperParams do
  begin
    ssPaperName := PrinterInfo.FormName;

    if (PrinterInfo.FormNo >= Low(aRWPaperSizes)) and
       (PrinterInfo.FormNo <= High(aRWPaperSizes)) then
    begin
      siHeightMM := aRWPaperSizes[PrinterInfo.FormNo][RW_PAPER_HEIGHT];
      siWidthMM := aRWPaperSizes[PrinterInfo.FormNo][RW_PAPER_WIDTH];
    end
    else
    begin // set a default JIC
      siHeightMM := aRWPaperSizes[9][RW_PAPER_HEIGHT];
      siWidthMM := aRWPaperSizes[9][RW_PAPER_WIDTH];
    end;

    siHeightPixels := Round(siHeightMM * ScalingFactor);

    siWidthPixels  := Round(siWidthMM * ScalingFactor);

  end; // with PaperParameters do...
end;

//-------------------------------------------------------------------------

procedure GetPrintMethodParams(const PrintMethodParams : TPrintMethodParams; var PrinterInfo : TSBSPrintSetupInfo);
var
  siOptIdx : SmallInt;
begin
  with PrinterInfo, PrintMethodParams do
  begin
    fePrintMethod := pmPrintMethod;
    feBatch := pmBatch;
    feTypes := pmTypes;
    feCoverSheet := pmCoverSheet;
    feFaxMethod := pmFaxMethod;
    feFaxPrinter := pmFaxPrinter;
    feFaxFrom := pmFaxFrom;
    feFaxFromNo := pmFaxFromNo;
    feFaxTo := pmFaxTo;
    feFaxToNo := pmFaxToNo;
    feFaxMsg := pmFaxMsg;
    feEmailMAPI := pmEmailMAPI;
    feEmailFrom := pmEmailFrom;
    feEmailFromAd := pmEmailFromAd;
    feEmailTo := pmEmailTo;
    feEmailToAddr := pmEmailToAddr;
    feEmailCc := pmEmailCc;
    feEmailBcc := pmEmailBcc;
    feEmailSubj := pmEmailSubj;
    feEmailMsg := pmEmailMsg;
    feEmailAttach := pmEmailAttach;
    feEmailPriority := pmEmailPriority;
    feEmailReader := pmEmailReader;
    feEmailZIP := pmEmailZIP;
    feEmailAtType := pmEmailAtType;
    feFaxPriority := pmFaxPriority;
    feXMLType := pmXMLType;
    feXMLCreateHTML := pmXMLCreateHTML;
    feXMLFileDir := pmXMLFileDir;
    feEmailFName := pmEmailFName;
    for siOptIdx := Low(feMiscOptions) to High(feMiscOptions) do
      feMiscOptions[siOptIdx] := pmMiscOptions[siOptidx];
  end; // with PrintMethodParams do...
end;

//------------------------------

procedure SetPrintMethodParams(var PrintMethodParams : TPrintMethodParams; const PrinterInfo : TSBSPrintSetupInfo);
var
  siOptIdx : SmallInt;
begin
  with PrintMethodParams, PrinterInfo do
  begin
    pmPrintMethod := fePrintMethod;
    pmBatch := feBatch;
    pmTypes := feTypes;
    pmCoverSheet := feCoverSheet;
    pmFaxMethod := feFaxMethod;
    pmFaxPrinter := feFaxPrinter;
    pmFaxFrom := feFaxFrom;
    pmFaxFromNo := feFaxFromNo;
    pmFaxTo := feFaxTo;
    pmFaxToNo := feFaxToNo;
    pmFaxMsg := feFaxMsg;
    pmEmailMAPI := feEmailMAPI;
    pmEmailFrom := feEmailFrom;
    pmEmailFromAd := feEmailFromAd;
    pmEmailTo := feEmailTo;
    pmEmailToAddr := feEmailToAddr;
    pmEmailCc := feEmailCc;
    pmEmailBcc := feEmailBcc;
    pmEmailSubj := feEmailSubj;
    pmEmailMsg := feEmailMsg;
    pmEmailAttach := feEmailAttach;
    pmEmailPriority := feEmailPriority;
    pmEmailReader := feEmailReader;
    pmEmailZIP := feEmailZIP;
    pmEmailAtType := feEmailAtType;
    pmFaxPriority := feFaxPriority;
    pmXMLType := feXMLType;
    pmXMLCreateHTML := feXMLCreateHTML;
    pmXMLFileDir := feXMLFileDir;
    pmEmailFName := feEmailFName;
    for siOptIdx := Low(pmMiscOptions) to High(pmMiscOptions) do
      pmMiscOptions[siOptIdx] := feMiscOptions[siOptidx];
  end; // with PrintMethodParams do...
end;

//------------------------------

procedure ResetPrintMethodParams;
var
  siOptIdx : SmallInt;
begin
  with ReportConstructInfo.PrintMethodParams do
  begin
    pmPrintMethod := 0;
    pmBatch := FALSE;
    pmTypes := 0;
    pmCoverSheet := '';
    pmFaxMethod := 0;
    pmFaxPrinter := 0;
    pmFaxFrom := '';
    pmFaxFromNo := '';
    pmFaxTo := '';
    pmFaxToNo := '';
    pmFaxMsg := '';
    pmEmailMAPI := FALSE;
    pmEmailFrom := '';
    pmEmailFromAd := '';
    pmEmailTo := '';
    pmEmailToAddr := '';
    pmEmailCc := '';
    pmEmailBcc := '';
    pmEmailSubj := '';
    pmEmailMsg := '';
    pmEmailAttach := '';
    pmEmailPriority := 0;
    pmEmailReader := FALSE;
    pmEmailZIP := 0;
    pmEmailAtType := 0;
    pmFaxPriority := 0;
    pmXMLType := 0;
    pmXMLCreateHTML := FALSE;
    pmXMLFileDir := '';
    pmEmailFName := '';
    for siOptIdx := Low(pmMiscOptions) to High(pmMiscOptions) do
      pmMiscOptions[siOptIdx] := FALSE;
  end; // with PrintMethodParams do...
end;

//-------------------------------------------------------------------------

{$IFDEF REP_ENGINE}
function Create_VRWReportFiles: Boolean;
{$IFDEF EX600}
var
  StoredSetDrive: string;
{$ENDIF}
begin
  Result:=False;

  New(RepExLocal);

  With RepExLocal^ do
  Begin
    try
      Create(14);

      {$IFDEF RW}
        Open_System ( 1, 15);

{$IFDEF EX600}
        StoredSetDrive := SetDrive;
        SetDrive := GetEnterpriseDirectory;
        Open_System(DictF, DictF);
        SetDrive := StoredSetDrive;
{$ELSE}
        Open_System (DictF, DictF);
{$ENDIF}

      {$ELSE}
        Open_System(1,TotFiles);
      {$ENDIF}

      Result:=True;
    except
      RepExLocal:=nil;
      raise Exception.Create('Unable to create Report Btrieve thread 14.');
    end; {try..}

  end;

end;
{$ENDIF REP_ENGINE}
//-------------------------------------------------------------------------

initialization

  // HM 01/04/05: Removed as this is VERY bad practice
  //EntLic := EnterpriseLicence;

  GRWDebug := FALSE;

  GRWSecurityOK := FALSE;

  GAllowTreeSecurity := FALSE;

  FRegionFontList := nil;

end.

