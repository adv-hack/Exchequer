unit VRWReportIF;
{
  Interface for creating, saving, loading, and printing reports.
}
interface

uses Classes, Graphics, ExtCtrls, CtrlPrms,
  {$IFDEF KPI}
  VRWRawBMPStore,
  {$ELSE}
  GlobalTypes,
  {$ENDIF}
  GuiVar, RPDevice,
  VRWPaperSizesIF;

type
  TReportFileFormat = (EDF_FILE, EDZ_FILE, INTERNAL_PDF_FILE, ADOBE_PDF_FILE,
                       DBF_FILE, XLS_FILE, CSV_FILE, HTML_FILE);

//  TOptionArray = array[1..10] of Boolean;
  //PR: 15/02/2011
  TOptionArray = array[1..30] of Boolean; //PR: 15/02/2011 Extend to 30 to match underlying record

  TRegionType = (rtUnknown, rtRepHdr, rtPageHdr, rtSectionHdr, rtRepLines,
                 rtSectionFtr, rtPageFtr, rtRepFtr);

  TControlType = (ctUnknown, ctText, ctImage, ctLine, ctBox, ctField, ctFormula);

  TTotalType = (ttUnknown, ttNone, ttTotal, ttCount, ttRangeFilter, ttCalc);

  TLineOrientation = (loVertical, loHorizontal);

  TVRWBoxLineIndex = (biLeft, biTop, biRight, biBottom);
  TVRWBoxLineProperties = record
    FvcLineStyle: TPenStyle;
    FvcLineColor: TColor;
    FvcLineWidth: Byte;
  end;
  TVRWBoxLinePropertiesArray = array[biLeft..biBottom] of TVRWBoxLineProperties;
  TVRWFontProperties = record
    Name: ShortString;
    Size: Integer;
    Style: TFontStyles;
    Color: TColor;
  end;
  TVRWRangeFilterProperties = record
    FrfName: ShortString;
    FrfDescription: ShortString;
    FrfType: SmallInt;
    FrfAlwaysAsk: Boolean;
    FrfFromValue: ShortString;
    FrfToValue: ShortString;
  end;
  TVRWControlProperties = record
    { Basic control properties }
    Font: TVRWFontProperties;          // Only used for clipboard handling
    Filter: TVRWRangeFilterProperties; // Only used for clipboard handling
    FvcType: TControlType;
    FvcTop: SmallInt;
    FvcLeft: SmallInt;
    FvcWidth: SmallInt;
    FvcHeight: SmallInt;
    FvcZOrder: SmallInt;
    FvcVisible: Boolean;
    FvcPrintIf: ShortString;
    FvcCaption: ShortString;
    FvcName: ShortString;
    FvcFieldFormat: ShortString;
    FvcText: ShortString;
    FvcDeleted: Boolean;
    FvcRegionName: ShortString;
    { Image control properties }
    FvcFolio: ShortString;
    { Line control properties }
    FvcLineOrientation: TLineOrientation;
    FvcLineLength: SmallInt;
    FvcPenColor: TColor;
    FvcPenMode: Byte;
    FvcPenStyle: Byte;
    FvcPenWidth: SmallInt;
    { Box control properties }
    BoxLines: TVRWBoxLinePropertiesArray; // Only used for clipboard handling
    FvcFilled: Boolean;
    FvcFillColor: TColor;
    { Field control properties }
    FvcFieldName: ShortString;
    FvcSortOrder: ShortString;
    FvcSelectCriteria: ShortString;
    FvcPrintField: Boolean;
    FvcSubTotal: Boolean;
    FvcPageBreak: Boolean;
    FvcRecalcBreak : Boolean;
    FvcSelectSummary: Boolean;
    FvcInputLine: TInputLineRecord; // Redundant -- see FvcRangeFilter
    FvcVarNo: LongInt;
    FvcVarLen: Byte;
    FvcVarDesc: ShortString;
    FvcVarType: Byte; //  2,3,6,7,9 - real, double, integer, longint, currency
    FvcVarNoDecs: Byte;
    FvcPeriodField: Boolean;
    FvcPeriod: ShortString;
    FvcYear: ShortString;
    FvcParsedInputLine: ShortString;  // Redundant
    FvcCurrency: Byte;
    FvcFieldIdx: SmallInt;
    { Formula control properties }
    FvcComments: ShortString;
    FvcFormulaDefinition: ShortString;
    FvcDecimalPlaces: Byte;
    FvcTotalType: TTotalType;
    FvcFormulaName: ShortString;
  end;

  IVRWPrintMethodParams = interface
    ['{97B6BA4A-6287-41F6-9B39-7A659963727B}']
    { Property access methods }
    function GetpmBatch: Boolean;
    function GetpmCoverSheet: ShortString;
    function GetpmEmailAttach: AnsiString;
    function GetpmEmailAtType: Byte;
    function GetpmEmailBcc: AnsiString;
    function GetpmEmailCc: AnsiString;
    function GetpmEmailFName: ShortString;
    function GetpmEmailFrom: ShortString;
    function GetpmEmailFromAd: ShortString;
    function GetpmEmailMAPI: Boolean;
    function GetpmEmailMsg: AnsiString;
    function GetpmEmailPriority: Byte;
    function GetpmEmailReader: Boolean;
    function GetpmEmailSubj: AnsiString;
    function GetpmEmailTo: AnsiString;
    function GetpmEmailToAddr: AnsiString;
    function GetpmEmailZIP: Byte;
    function GetpmFaxFrom: ShortString;
    function GetpmFaxFromNo: ShortString;
    function GetpmFaxMethod: Byte;
    function GetpmFaxMsg: AnsiString;
    function GetpmFaxPrinter: SmallInt;
    function GetpmFaxPriority: Byte;
    function GetpmFaxTo: ShortString;
    function GetpmFaxToNo: ShortString;
    function GetpmMiscOptions: TOptionArray;
    function GetpmPrintMethod: Byte;
    function GetpmTypes: LongInt;
    function GetpmXMLCreateHTML: Boolean;
    function GetpmXMLFileDir: ANSIString;
    function GetpmXMLType: Byte;
    procedure SetpmBatch(const Value: Boolean);
    procedure SetpmCoverSheet(const Value: ShortString);
    procedure SetpmEmailAttach(const Value: AnsiString);
    procedure SetpmEmailAtType(const Value: Byte);
    procedure SetpmEmailBcc(const Value: AnsiString);
    procedure SetpmEmailCc(const Value: AnsiString);
    procedure SetpmEmailFName(const Value: ShortString);
    procedure SetpmEmailFrom(const Value: ShortString);
    procedure SetpmEmailFromAd(const Value: ShortString);
    procedure SetpmEmailMAPI(const Value: Boolean);
    procedure SetpmEmailMsg(const Value: AnsiString);
    procedure SetpmEmailPriority(const Value: Byte);
    procedure SetpmEmailReader(const Value: Boolean);
    procedure SetpmEmailSubj(const Value: AnsiString);
    procedure SetpmEmailTo(const Value: AnsiString);
    procedure SetpmEmailToAddr(const Value: AnsiString);
    procedure SetpmEmailZIP(const Value: Byte);
    procedure SetpmFaxFrom(const Value: ShortString);
    procedure SetpmFaxFromNo(const Value: ShortString);
    procedure SetpmFaxMethod(const Value: Byte);
    procedure SetpmFaxMsg(const Value: AnsiString);
    procedure SetpmFaxPrinter(const Value: SmallInt);
    procedure SetpmFaxPriority(const Value: Byte);
    procedure SetpmFaxTo(const Value: ShortString);
    procedure SetpmFaxToNo(const Value: ShortString);
    procedure SetpmMiscOptions(const Value: TOptionArray);
    procedure SetpmPrintMethod(const Value: Byte);
    procedure SetpmTypes(const Value: LongInt);
    procedure SetpmXMLCreateHTML(const Value: Boolean);
    procedure SetpmXMLFileDir(const Value: ANSIString);
    procedure SetpmXMLType(const Value: Byte);

    { Properties }
    property pmPrintMethod: Byte
      read GetpmPrintMethod
      write SetpmPrintMethod;

    property pmBatch: Boolean
      read GetpmBatch
      write SetpmBatch;

    property pmTypes: LongInt
      read GetpmTypes
      write SetpmTypes;

    property pmCoverSheet: ShortString
      read GetpmCoverSheet
      write SetpmCoverSheet;

    property pmFaxMethod: Byte
      read GetpmFaxMethod
      write SetpmFaxMethod;

    property pmFaxPrinter: SmallInt
      read GetpmFaxPrinter
      write SetpmFaxPrinter;

    property pmFaxFrom: ShortString
      read GetpmFaxFrom
      write SetpmFaxFrom;

    property pmFaxFromNo: ShortString
      read GetpmFaxFromNo
      write SetpmFaxFromNo;

    property pmFaxTo: ShortString
      read GetpmFaxTo
      write SetpmFaxTo;

    property pmFaxToNo: ShortString
      read GetpmFaxToNo
      write SetpmFaxToNo;

    property pmFaxMsg: AnsiString
      read GetpmFaxMsg
      write SetpmFaxMsg;

    property pmEmailMAPI: Boolean
      read GetpmEmailMAPI
      write SetpmEmailMAPI;

    property pmEmailFrom: ShortString
      read GetpmEmailFrom
      write SetpmEmailFrom;

    property pmEmailFromAd: ShortString
      read GetpmEmailFromAd
      write SetpmEmailFromAd;

    property pmEmailTo: AnsiString
      read GetpmEmailTo
      write SetpmEmailTo;

    property pmEmailToAddr: AnsiString
      read GetpmEmailToAddr
      write SetpmEmailToAddr;

    property pmEmailCc: AnsiString
      read GetpmEmailCc
      write SetpmEmailCc;

    property pmEmailBcc: AnsiString
      read GetpmEmailBcc
      write SetpmEmailBcc;

    property pmEmailSubj: AnsiString
      read GetpmEmailSubj
      write SetpmEmailSubj;

    property pmEmailMsg: AnsiString
      read GetpmEmailMsg
      write SetpmEmailMsg;

    property pmEmailAttach: AnsiString
      read GetpmEmailAttach
      write SetpmEmailAttach;

    property pmEmailPriority: Byte
      read GetpmEmailPriority
      write SetpmEmailPriority;

    property pmEmailReader: Boolean
      read GetpmEmailReader
      write SetpmEmailReader;

    property pmEmailZIP: Byte
      read GetpmEmailZIP
      write SetpmEmailZIP;

    property pmEmailAtType: Byte
      read GetpmEmailAtType
      write SetpmEmailAtType;

    property pmFaxPriority: Byte
      read GetpmFaxPriority
      write SetpmFaxPriority;

    property pmXMLType: Byte
      read GetpmXMLType
      write SetpmXMLType;

    property pmXMLCreateHTML: Boolean
      read GetpmXMLCreateHTML
      write SetpmXMLCreateHTML;

    property pmXMLFileDir: ANSIString
      read GetpmXMLFileDir
      write SetpmXMLFileDir;

    property pmEmailFName: ShortString
      read GetpmEmailFName
      write SetpmEmailFName;

    property pmMiscOptions: TOptionArray
      read GetpmMiscOptions
      write SetpmMiscOptions;
  end;

  IVRWTestModeParams = interface
    ['{A7CDB994-1779-4E9B-8FF9-2F296880C012}']
    { --- Property access methods ------------------------------------------- }
    function GetTmTestMode: Boolean;
    procedure SetTmTestMode(const Value: Boolean);

    function GetTmSampleCount: SmallInt;
    procedure SetTmSampleCount(const Value: SmallInt);

    function GetTmRefreshStart: Boolean;
    procedure SetTmRefreshStart(const Value: Boolean);

    function GetTmRefreshEnd: Boolean;
    procedure SetTmRefreshEnd(const Value: Boolean);

    function GetTmFirstRecPos: LongInt;
    procedure SetTmFirstRecPos(const Value: LongInt);

    function GetTmLastRecPos: LongInt;
    procedure SetTmLastRecPos(const Value: LongInt);
    
    { --- Properties -------------------------------------------------------- }
    property tmTestMode: Boolean
      read GetTmTestMode
      write SetTmTestMode;

    property tmSampleCount: SmallInt
      read GetTmSampleCount
      write SetTmSampleCount;

    property tmRefreshStart: Boolean
      read GetTmRefreshStart
      write SetTmRefreshStart;

    property tmRefreshEnd: Boolean
      read GetTmRefreshEnd
      write SetTmRefreshEnd;

    property tmFirstRecPos: LongInt
      read GetTmFirstRecPos
      write SetTmFirstRecPos;

    property tmLastRecPos: LongInt
      read GetTmLastRecPos
      write SetTmLastRecPos;

  end;

  // Generic interface for objects which implement a specific import type
  IVRWFont = Interface
    ['{A8BADC8E-4279-41D6-A60A-6B64A2D3E84E}']
    // --- Internal Methods to implement Public Properties ---
    Function GetName : ShortString;
    Procedure SetName (Const Value : ShortString);
    Function GetSize : Integer;
    Procedure SetSize(Value : Integer);
    Function GetStyle : TFontStyles;
    Procedure SetStyle(Value : TFontStyles);
    Function GetColor : TColor;
    Procedure SetColor(Value : TColor);
    // ------------------ Public Properties ------------------
    // ------------------- Public Methods --------------------
    Property Name : ShortString Read GetName Write SetName;
    Property Size : Integer Read GetSize Write SetSize;
    Property Style : TFontStyles Read GetStyle Write SetStyle;
    Property Color : TColor Read GetColor Write SetColor;
  End; // IVRWFont

  IVRWBaseInputField = interface
    { --- Property access methods -------------------------------------------- }

    function GetRfName: ShortString;
    procedure SetRfName(const Value: ShortString);

    function GetRfDescription: ShortString;
    procedure SetRfDescription(const Value: ShortString);

    function GetRfType: SmallInt;
    procedure SetRfType(const Value: SmallInt);

    function GetRfAlwaysAsk: Boolean;
    procedure SetRfAlwaysAsk(const Value: Boolean);

    function GetRfFromValue: ShortString;
    procedure SetRfFromValue(const Value: ShortString);

    function GetRfToValue: ShortString;
    procedure SetRfToValue(const Value: ShortString);

    { --- Methods ------------------------------------------------------------ }
    function GetRangeString(RangeData: ShortString): ShortString;

    { --- Properties --------------------------------------------------------- }

    property rfName: ShortString
      read GetRfName
      write SetRfName;

    property rfDescription: ShortString
      read GetRfDescription
      write SetRfDescription;

    property rfType: SmallInt
      read GetRfType
      write SetRfType;

    property rfAlwaysAsk: Boolean
      read GetRfAlwaysAsk
      write SetRfAlwaysAsk;

    property rfFromValue: ShortString
      read GetRfFromValue
      write SetRfFromValue;

    property rfToValue: ShortString
      read GetRfToValue
      write SetRfToValue;

  end;

  IVRWRangeFilter = interface(IVRWBaseInputField)
  end;

  IVRWInputField = interface(IVRWBaseInputField)

    { --- Property access methods -------------------------------------------- }
    function GetRfID: Integer;
    procedure SetRfID(const Value: Integer);

    { --- Properties --------------------------------------------------------- }

    property rfId: Integer
      read GetRfID
      write SetRfID;

  end;

  { Forward declaration of report interface }
  IVRWReport = interface;

  { Base interface for report designer controls }
  IVRWControl = interface
  ['{7BD037E4-829E-492F-974D-97F1253C73B6}']

    { --- Property access methods -------------------------------------------- }

    function GetVcReport: IVRWReport;
    procedure SetVcReport(const Value: IVRWReport);

    function GetVcType: TControlType;
    procedure SetVcType(const Value: TControlType);

    function GetVcTop: SmallInt;
    procedure SetVcTop(const Value: SmallInt);

    function GetVcLeft: SmallInt;
    procedure SetVcLeft(const Value: SmallInt);

    function GetVcWidth: SmallInt;
    procedure SetVcWidth(const Value: SmallInt);

    function GetVcHeight: SmallInt;
    procedure SetVcHeight(const Value: SmallInt);

    function GetVcZOrder: SmallInt;
    procedure SetVcZOrder(const Value: SmallInt);

    function GetVcVisible: Boolean;
    procedure SetVcVisible(const Value: Boolean);

    function GetVcPrintIf: ShortString;
    procedure SetVcPrintIf(const Value: ShortString);

    function GetVcFont: IVRWFont;
    //procedure SetVcFont(const Value: IVRWFont);

    function GetVcCaption: ShortString;
    procedure SetVcCaption(const Value: ShortString);

    function GetVcName: ShortString;
    procedure SetVcName(const Value: ShortString);

    function GetVcFieldFormat: ShortString;
    procedure SetVcFieldFormat(const Value: ShortString);

    function GetVcText: ShortString;
    procedure SetVcText(const Value: ShortString);

    function GetVcDeleted: Boolean;
    procedure SetVcDeleted(const Value: Boolean);

    function GetVcRegionName: ShortString;
    procedure SetVcRegionName(const Value: ShortString);

    function GetProperties: TVRWControlProperties;
    procedure SetProperties(const Value: TVRWControlProperties);

    { --- Properties --------------------------------------------------------- }

    property vcReport: IVRWReport read GetVcReport write SetVcReport;
    property vcType: TControlType read GetVcType write SetVcType;
    property vcTop: SmallInt read GetVcTop write SetVcTop;
    property vcLeft: SmallInt read GetVcLeft write SetVcLeft;
    property vcWidth: SmallInt read GetVcWidth write SetVcWidth;
    property vcHeight: SmallInt read GetVcHeight write SetVcHeight;
    property vcZOrder: SmallInt read GetVcZOrder write SetVcZOrder;
    property vcVisible: Boolean read GetVcVisible write SetVcVisible;
    property vcPrintIf: ShortString read GetVcPrintIf write SetVcPrintIf;
    property vcFont: IVRWFont read GetVcFont; { write SetVcFont;}
    property vcCaption: ShortString read GetVcCaption write SetVcCaption;
    property vcName: ShortString read GetVcName write SetVcName;
    property vcFieldFormat: ShortString read GetVcFieldFormat write SetVcFieldFormat;
    property vcText: ShortString read GetVcText write SetVcText;
    property vcDeleted: Boolean read GetVcDeleted write SetVcDeleted;
    property vcRegionName: ShortString read GetVcRegionName write SetVcRegionName;

  end;

  TVRWOnPasteControl = procedure(Control: IVRWControl) of object;

  { Interfaces for report designer controls }
  IVRWTextControl = interface(IVRWControl)
  ['{0F5DEAD5-6000-438C-B9C6-9FC9CAF692D3}']
  end;

  IVRWImageControl = interface(IVRWControl)
  ['{9A2EAA4D-5DD9-40D8-A3EA-202FA832808F}']

    { --- Property access methods -------------------------------------------- }

    function GetVcFolio: ShortString;
    procedure SetVcFolio(const Value: ShortString);

    function GetVcImage: TImage;

    function GetVcImageStream: TMemoryStream;

    function GetVcBMPStore: TRawBMPStore;

    function GetVcBMPIndex: Integer;
    procedure SetVcBMPIndex(const Value: Integer);

    { --- General methods ---------------------------------------------------- }
    procedure LoadImage(const Filename: string);
    procedure ReadImageBuffer;

    { --- Properties --------------------------------------------------------- }

    { Identifies the bitmap in the list of bitmaps. This is only used for
      compatibility with the old version of the report designer. }
    property vcFolio : ShortString
      read GetVcFolio
      write SetVcFolio;

    { Holds the actual bitmap }
    property vcImage: TImage
      read GetVcImage;

    property vcImageStream: TMemoryStream
      read GetvcImageStream;

    property vcBMPStore: TRawBMPStore
      read GetvcBMPStore;

    { Holds the graphic index, to be used by the Rave Report Writer bitmap
      caching. }
    property vcBMPIndex: Integer
      read GetVcBMPIndex
      write SetVcBMPIndex;

  end;

  IVRWLineControl = interface(IVRWControl)
  ['{817126A6-BB63-4A63-934F-508A2034D63D}']

    { --- Property access methods -------------------------------------------- }

    function GetVcLineOrientation: TLineOrientation;
    procedure SetVcLineOrientation(const Value: TLineOrientation);

    function GetVcLineLength: SmallInt;
    procedure SetVcLineLength(const Value: SmallInt);

    function GetVcPenColor: TColor;
    procedure SetVcPenColor(const Value: TColor);

    function GetVcPenMode: Byte;
    procedure SetVcPenMode(const Value: Byte);

    function GetVcPenStyle: Byte;
    procedure SetVcPenStyle(const Value: Byte);

    function GetVcPenWidth: SmallInt;
    procedure SetVcPenWidth(const Value: SmallInt);

    { --- Properties --------------------------------------------------------- }

    property vcLineOrientation: TLineOrientation
      read GetVcLineOrientation
      write SetVcLineOrientation;

    property vcLineLength: SmallInt
      read GetVcLineLength
      write SetVcLineLength;

    property vcPenColor: TColor
      read GetVcPenColor
      write SetVcPenColor;

    property vcPenMode: Byte
      read GetVcPenMode
      write SetVcPenMode;

    property vcPenStyle: Byte
      read GetVcPenStyle
      write SetVcPenStyle;

    property vcPenWidth: SmallInt
      read GetVcPenWidth
      write SetVcPenWidth;

  end;

  IVRWBoxLine = interface
    ['{39BFF309-E865-46AF-B510-F2B427D95EAD}']
    // --- Internal Methods to implement Public Properties ---
    function GetvcLineStyle: TPenStyle;
    procedure SetvcLineStyle (const Value: TPenStyle);

    function GetvcLineColor: TColor;
    procedure SetvcLineColor (const Value: TColor);

    function GetvcLineWidth: Byte;
    procedure SetvcLineWidth (const Value: Byte);

    // ------------------ Public Properties ------------------
    property vcLineStyle: TPenStyle
      read GetvcLineStyle
      write SetvcLineStyle;

    property vcLineColor: TColor
      read GetvcLineColor
      write SetvcLineColor;

    property vcLineWidth: Byte
      read GetvcLineWidth
      write SetvcLineWidth;

    // ------------------- Public Methods --------------------
  End; // IVRWBoxLine

  TVRWBoxLineArray = array[biLeft..biBottom] of IVRWBoxLine;

  IVRWBoxControl = interface(IVRWControl)
  ['{6252A1E0-20EC-4DBB-8B1A-1713C6BA9B78}']
    // --- Internal Methods to implement Public Properties ---
    function GetVcFilled: Boolean;
    procedure SetVcFilled(const Value: Boolean);

    function GetVcFillColor: TColor;
    procedure SetVcFillColor(const Value: TColor);

    function GetVcBoxLine(Index: TVRWBoxLineIndex): IVRWBoxLine;
    procedure SetVcBoxLine(Index: TVRWBoxLineIndex; const Value: IVRWBoxLine);

    // ------------------ Public Properties ------------------
    property vcFilled : Boolean
      read GetvcFilled
      write SetvcFilled;

    property vcFillColor : TColor
      read GetvcFillColor
      write SetvcFillColor;

    property vcBoxLines[Index : TVRWBoxLineIndex] : IVRWBoxLine
      read GetvcBoxLine
      write SetvcBoxLine;
  end;

  IVRWFieldControl = interface(IVRWControl)
  ['{B5FFF9B9-E658-4AC9-BF2B-B449701A13B0}']

    { --- Property access methods -------------------------------------------- }

    function GetVcCurrency: Byte;
    procedure SetVcCurrency(const Value: Byte);

    function GetVcFieldIdx: SmallInt;
    procedure SetVcFieldIdx(const Value: SmallInt);

    function GetVcFieldName: ShortString;
    procedure SetVcFieldName(const Value: ShortString);

    function GetVcInputLine: IVRWInputField;
    procedure SetVcInputLine(const Value: IVRWInputField);

    function GetVcPageBreak: Boolean;
    procedure SetVcPageBreak(const Value: Boolean);

    function GetVcParsedInputLine: ShortString;
    procedure SetVcParsedInputLine(const Value: ShortString);

    function GetVcPeriod: ShortString;
    procedure SetVcPeriod(const Value: ShortString);

    function GetVcPeriodField: Boolean;
    procedure SetVcPeriodField(const Value: Boolean);

    function GetVcPrintField: Boolean;
    procedure SetVcPrintField(const Value: Boolean);

    function GetVcRecalcBreak: Boolean;
    procedure SetVcRecalcBreak(const Value: Boolean);

    function GetVcSelectCriteria: ShortString;
    procedure SetVcSelectCriteria(const Value: ShortString);

    function GetVcSelectSummary: Boolean;
    procedure SetVcSelectSummary(const Value: Boolean);

    function GetVcSortOrder: ShortString;
    procedure SetVcSortOrder(const Value: ShortString);

    function GetVcSubTotal: Boolean;
    procedure SetVcSubTotal(const Value: Boolean);

    function GetVcVarDesc: ShortString;
    procedure SetVcVarDesc(const Value: ShortString);

    function GetVcVarLen: Byte;
    procedure SetVcVarLen(const Value: Byte);

    function GetVcVarNo: LongInt;
    procedure SetVcVarNo(const Value: LongInt);

    function GetVcVarNoDecs: Byte;
    procedure SetVcVarNoDecs(const Value: Byte);

    function GetVcVarType: Byte;
    procedure SetVcVarType(const Value: Byte);

    function GetVcYear: ShortString;
    procedure SetVcYear(const Value: ShortString);

    function GetVcRangeFilter: IVRWRangeFilter;

    { --- Properties --------------------------------------------------------- }

    property vcFieldName: ShortString
      read GetVcFieldName
      write SetVcFieldName;

    property vcSortOrder: ShortString
      read GetVcSortOrder
      write SetVcSortOrder;

    property vcSelectCriteria: ShortString
      read GetVcSelectCriteria
      write SetVcSelectCriteria;

    property vcPrintField: Boolean
      read GetVcPrintField
      write SetVcPrintField;

    property vcSubTotal: Boolean
      read GetVcSubTotal
      write SetVcSubTotal;

    property vcPageBreak: Boolean
      read GetVcPageBreak
      write SetVcPageBreak;

    property vcRecalcBreak: Boolean
      read GetVcRecalcBreak
      write SetVcRecalcBreak;

    property vcSelectSummary: Boolean
      read GetVcSelectSummary
      write SetVcSelectSummary;

    property vcInputLine : IVRWInputField
      read GetVcInputLine
      write SetVcInputLine;

    property vcVarNo: LongInt
      read GetVcVarNo
      write SetVcVarNo;

    property vcVarLen: Byte
      read GetVcVarLen
      write SetVcVarLen;

    property vcVarDesc: ShortString
      read GetVcVarDesc
      write SetVcVarDesc;

    property vcVarType: Byte
      read GetVcVarType
      write SetVcVarType;

    property vcVarNoDecs: Byte
      read GetVcVarNoDecs
      write SetVcVarNoDecs;

    property vcPeriodField: Boolean
      read GetVcPeriodField
      write SetVcPeriodField;

    property vcPeriod: ShortString
      read GetVcPeriod
      write SetVcPeriod;

    property vcYear: ShortString
      read GetVcYear
      write SetVcYear;

    property vcParsedInputLine: ShortString
      read GetVcParsedInputLine
      write SetVcParsedInputLine;

    property vcCurrency: Byte
      read GetVcCurrency
      write SetVcCurrency;

    property vcFieldIdx: SmallInt
      read GetVcFieldIdx
      write SetVcFieldIdx;

    property vcRangeFilter: IVRWRangeFilter
      read GetVcRangeFilter;

  end;

  IVRWFormulaControl = interface(IVRWControl)
  ['{0B2C3AE1-2C83-412F-8923-9E6F91CA57F7}']

    { --- Property access methods -------------------------------------------- }

    function GetVcComments: ShortString;
    procedure SetVcComments(const Value: ShortString);

    function GetVcFormulaDefinition: ShortString;
    procedure SetVcFormulaDefinition(const Value: ShortString);

    function GetVcDecimalPlaces: Byte;
    procedure SetVcDecimalPlaces(const Value: Byte);

    function GetVcTotalType: TTotalType;
    procedure SetVcTotalType(const Value: TTotalType);

    function GetVcFormulaName: ShortString;
    procedure SetVcFormulaName(const Value: ShortString);

    function GetVcSortOrder: ShortString;
    procedure SetVcSortOrder(const Value: ShortString);

    function GetVcPageBreak: Boolean;
    procedure SetVcPageBreak(const Value: Boolean);

    function GetVcPrintField: Boolean;
    procedure SetVcPrintField(const Value: Boolean);

    function GetVcFieldIdx: SmallInt;
    procedure SetVcFieldIdx(const Value: SmallInt);

    function GetVcPeriod: ShortString;
    procedure SetVcPeriod(const Value: ShortString);

    function GetVcYear: ShortString;
    procedure SetVcYear(const Value: ShortString);

    function GetVcCurrency: Byte;
    procedure SetVcCurrency(const Value: Byte);

    { --- Properties --------------------------------------------------------- }

    property vcComments: ShortString
      read GetVcComments
      write SetVcComments;

    property vcFormulaDefinition: ShortString
      read GetVcFormulaDefinition
      write SetVcFormulaDefinition;

    property vcDecimalPlaces: Byte
      read GetVcDecimalPlaces
      write SetVcDecimalPlaces;

    property vcTotalType: TTotalType
      read GetVcTotalType
      write SetVcTotalType;

    property vcFormulaName: ShortString
      read GetVcFormulaName
      write SetVcFormulaName;

    property vcSortOrder: ShortString
      read GetVcSortOrder
      write SetVcSortOrder;

    property vcPrintField: Boolean
      read GetVcPrintField
      write SetVcPrintField;

    property vcPageBreak: Boolean
      read GetVcPageBreak
      write SetVcPageBreak;

    property vcFieldIdx: SmallInt
      read GetVcFieldIdx
      write SetVcFieldIdx;

    property vcPeriod: ShortString
      read GetVcPeriod
      write SetVcPeriod;

    property vcYear: ShortString
      read GetVcYear
      write SetVcYear;

    property vcCurrency: Byte
      read GetVcCurrency
      write SetVcCurrency;

  end;

  { Interface to maintain a list of report designer controls }
  IVRWControlList = interface
  ['{4B054782-DE2F-46F7-B31C-945789393331}']

    { --- Property access methods -------------------------------------------- }

    function GetClItem(Index: Integer): IVRWControl;
    procedure SetClItem(Index: Integer; Value: IVRWControl);

    function GetClControl(Index: ShortString): IVRWControl;
    procedure SetClControl(Index: ShortString; Value: IVRWControl);

    function GetClCount: SmallInt;

    function GetClRegionName: ShortString;
    procedure SetClRegionName(const Value: ShortString);

    { --- Properties --------------------------------------------------------- }

    { List of controls }
    property clItems[Index: Integer]: IVRWControl
      read GetClItem
      write SetClItem;

    property clControls[Index: ShortString]: IVRWControl
      read GetClControl
      write SetClControl; default;

    property clCount: SmallInt
      read GetClCount;

    property clRegionName: ShortString
      read GetClRegionName
      write SetClRegionName;

    { --- Methods ------------------------------------------------------------ }

    { Creates a new IVRWControl and adds it to the list. If no name is
      specified, a name will be created automatically. The new control will
      be registered with the owner report (the report maintains its own list
      of all the controls, separate to the individual lists of controls
      maintained by each report region). }
    function Add(Owner: IVRWReport; ControlType: TControlType;
      ControlName: string = ''): IVRWControl;

    { Unregisters the specified control from the report, and marks it as
      deleted -- the control will still be available to the report, but will
      not be saved when the report is saved. }
    procedure Delete(Control: IVRWControl); overload;
    procedure Delete(ControlName: ShortString); overload;
    procedure Delete(ControlIndex: SmallInt); overload;

    { Appends an existing control to the list. }
    procedure Append(Control: IVRWControl);

    { Removes a control from the list }
    procedure Remove(Control: IVRWControl); overload;
    procedure Remove(ControlName: ShortString); overload;
    procedure Remove(ControlIndex: SmallInt); overload;

    { Transfers a control to another control-list }
    procedure Transfer(Control: IVRWControl;
      Target: IVRWControlList); overload;
    procedure Transfer(ControlName: ShortString;
      Target: IVRWControlList); overload;
    procedure Transfer(ControlIndex: SmallInt;
      Target: IVRWControlList); overload;

    { Clears the list }
    procedure Clear;

    { Moves the control to the start of the list }
    procedure BringToFront(Control: IVRWControl);

    { Moves the control to the end of the list }
    procedure SendToBack(Control: IVRWControl);

  end;

  IVRWInputFieldList = interface
  ['{7E391739-A1A0-45CF-9516-20AF8527B1F6}']

    { --- Property access methods -------------------------------------------- }

    function GetRfItem(Index: Integer): IVRWInputField;
    procedure SetRfItem(Index: Integer; Value: IVRWInputField);

    function GetRfCount: SmallInt;

    { --- Properties --------------------------------------------------------- }

    { List of controls }
    property rfItems[Index: Integer]: IVRWInputField
      read GetRfItem
      write SetRfItem;

    property rfCount: SmallInt
      read GetRfCount;

    { --- Methods ------------------------------------------------------------ }

    function Add: IVRWInputField;
    procedure Clear;

  end;

  { Interface for a report region (section) }
  IVRWRegion = interface
  ['{D4873060-30E3-468E-96C3-94298ED2FF2F}']

    { --- Property access methods -------------------------------------------- }

    function GetRgReport: IVRWReport;
    procedure SetRgReport(const Value: IVRWReport);

    function GetRgControls: IVRWControlList;

    function GetRgName: ShortString;
    procedure SetRgName(const Value: ShortString);

    function GetRgDescription: ShortString;
    procedure SetRgDescription(const Value: ShortString);

    function GetRgType: TRegionType;
    procedure SetRgType(const Value: TRegionType);

    function GetRgSectionNumber: SmallInt;
    procedure SetRgSectionNumber(const Value: SmallInt);

    function GetRgControlCount: SmallInt;

    function GetRgTop: SmallInt;
    procedure SetRgTop(const Value: SmallInt);

    function GetRgHeight: SmallInt;
    procedure SetRgHeight(const Value: SmallInt);

    function GetRgVisible: Boolean;
    procedure SetRgVisible(const Value: Boolean);

    function GetRgIndexNumber: LongInt;
    procedure SetRgIndexNumber(const Value: LongInt);

    function GetRgLeft: SmallInt;
    procedure SetRgLeft(const Value: SmallInt);

    { --- Properties --------------------------------------------------------- }

    property rgReport: IVRWReport
      read GetRgReport
      write SetRgReport;

    property rgControls: IVRWControlList
      read GetRgControls;

    property rgName: ShortString
      read GetRgName
      write SetRgName;

    property rgDescription: ShortString
      read GetRgDescription
      write SetRgDescription;

    property rgType: TRegionType
      read GetRgType
      write SetRgType;

    property rgSectionNumber: SmallInt
      read GetRgSectionNumber
      write SetRgSectionNumber;

    property rgControlCount: SmallInt
      read GetRgControlCount;

    property rgTop: SmallInt
      read GetRgTop
      write SetRgTop;

    property rgHeight: SmallInt
      read GetRgHeight
      write SetRgHeight;

    property rgVisible: Boolean
      read GetRgVisible
      write SetRgVisible;

    { rgIndexNumber is used for sorting regions (and especially section
      regions) into the correct order }
    property rgIndexNumber: LongInt
      read GetRgIndexNumber
      write SetRgIndexNumber;

    { rgLeft is only used when auto-generating controls while converting from
      old reports }
    property rgLeft: SmallInt
      read GetRgLeft
      write SetRgLeft;

    { --- Methods ------------------------------------------------------------ }

    { Clears all the controls from the region }
    procedure Clear;

  end;

  { Interface to maintain a list of report regions (sections) }
  IVRWRegionList = interface
  ['{EC3EC0AA-9148-4AE5-B768-A4AE9A3365EE}']

    { --- Property access methods -------------------------------------------- }

    function GetRlItem(Index: Integer): IVRWRegion;
    procedure SetRlItem(Index: Integer; Value: IVRWRegion);

    function GetRlRegion(Index: ShortString): IVRWRegion;
    procedure SetRlRegion(Index: ShortString; Value: IVRWRegion);

    function GetRlCount: SmallInt;

    { --- Properties --------------------------------------------------------- }

    property rlItems[Index: Integer]: IVRWRegion
      read GetRlItem
      write SetRlItem;

    property rlRegions[Index: ShortString]: IVRWRegion
      read GetRlRegion
      write SetRlRegion; default;

    property rlCount: SmallInt
      read GetRlCount;

    { --- Methods ------------------------------------------------------------ }

    { Creates a new IVRWRegion and adds it to the list. If no name is
      specified, a name will be created automatically, and the section number
      will be added to the end of the name. If a name is specified, it is
      assumed to be the complete name (this would normally be used when loading
      a report), and the Section Number will be ignored. }
    function Add(Owner: IVRWReport; RegionType: TRegionType;
      SectionNumber: SmallInt = 0; RegionName: ShortString = ''): IVRWRegion;

    { Clears all the regions }
    procedure Clear;

    { Sorts the regions into the correct order -- this is intended for use when
      new sections are added, to ensure that the section regions end up in the
      correct place }
    procedure Sort;

    { Renumbers the sections so that they are numbered consecutively }
    procedure Renumber;

    { Deletes the specified region }
    procedure Delete(Region: IVRWRegion); overload;
    procedure Delete(RegionName: ShortString); overload;
    procedure Delete(RegionIndex: SmallInt); overload;

  end;

  { Interface for reports }
  IVRWReport = interface
  ['{F0820243-EAF4-4F3B-9241-9E365B8991B3}']

    { --- Property access methods -------------------------------------------- }

    function GetVrVersion: ShortString;
    procedure SetVrVersion(const Value: ShortString);

    function GetVrFilename: ShortString;
    procedure SetVrFilename(const Value: ShortString);

    function GetVrName: ShortString;
    procedure SetVrName(const Value: ShortString);

    function GetVrDescription: ShortString;
    procedure SetVrDescription(const Value: ShortString);

    function GetVrMainFile: ShortString;
    procedure SetVrMainFile(const Value: ShortString);

    function GetVrMainFileNum: Byte;
    procedure SetVrMainFileNum(const Value: Byte);

    function GetVrIndexID: Byte;
    procedure SetVrIndexID(const Value: Byte);

//    function GetVrKeyPath: Integer;
//    procedure SetVrKeyPath(const Value: Integer);

    function GetVrPaperOrientation: Byte;
    procedure SetVrPaperOrientation(const Value: Byte);

    function GetVrIsWizardBased: Boolean;
    procedure SetVrIsWizardBased(const Value: Boolean);

    function GetVrRegions: IVRWRegionList;

    function GetVrControls: IVRWControlList;

    function GetVrOnPrintRecord: TOnCheckRecordProc;
    procedure SetVrOnPrintRecord(const Value: TOnCheckRecordProc);

    function GetVrOnFirstPass: TOnCheckRecordProc;
    procedure SetVrOnFirstPass(const Value: TOnCheckRecordProc);

    function GetVrOnSecondPass: TOnCheckRecordProc;
    procedure SetVrOnSecondPass(const Value: TOnCheckRecordProc);

    function GetVrFont: IVRWFont;

    function GetVrRangeFilter: IVRWRangeFilter;

    function GetVrPrintMethodParams: IVRWPrintMethodParams;

    function GetVrTestModeParams: IVRWTestModeParams;

    function GetVrPaperSizes: IVRWPaperSizes;

    function GetVrPaperCode: ShortString;
    procedure SetVrPaperCode(const Value: ShortString);

    function GetVrReportFileName: ShortString;

    function GetVrDataPath: ShortString;
    procedure SetVrDataPath(const Value: ShortString);

    { Clears the report }
    procedure Clear;

    { Reads the report from the specified report file }
    procedure Read(const FileName: ShortString);

    { Writes the report to a report file }
    procedure Write(WithCompression: Boolean = True);

    { Prints the report. Returns False if the print run was cancelled. }
    function Print(const FileName: ShortString; ExternalCall: Boolean = False): Boolean;

    { Adds a control to the list of controls for this report. This method
      should only be used by the Add method of IVRWControlList. }
    procedure RegisterControl(Control: IVRWControl);

    { Removes a control from the list controls for this report. This method
      should only be used by the Delete method of IVRWControlList. }
    procedure UnregisterControl(Control: IVRWControl);

    { Returns a control name that is unique across the whole report. This is
      generally only used by IVRWControlList.Add when creating a new control }
    function CreateUniqueControlName(ControlType: TControlType): ShortString;

    { Returns a formula name that is unique across the whole report. This is
      generally only used by IVRWControlList.Add when creating a new control }
    function CreateUniqueFormulaName: ShortString;

    { Validates the supplied formula, making sure that it is well-formed, and
      that it does not reference any unknown fields. Returns a description of
      any errors found, or an empty string if the formula was valid. }
    function ValidateFormula(FormulaDefinition: string): string;

    function ValidateSelectionCriteria(SelectionCriteria: string): string;

    { Updates any FML[] references to the original formula name, replacing
      them with the new formula name. }
    procedure UpdateFormulaReferences(const OldName, NewName: ShortString);

    { Reads the print method params from the supplied printer information
      record }
    procedure ReadPrintMethodParams(FromPrinterInfo: TSBSPrintSetupInfo);

    { Writes the print method params from the report to the supplied printer
      information record }
    procedure WritePrintMethodParams(var ToPrinterInfo: TSBSPrintSetupInfo);

    { Locates and returns the field control which matches the supplied
      field name. Returns nil if a matching control cannot be found. }
    function FindFieldControl(FieldName: string): IVRWFieldControl;

    { Locates and returns the formula control which matches the supplied
      formula name. Returns nil if a matching control cannot be found. }
    function FindFormulaControl(FormulaName: string): IVRWFormulaControl;

    { Clears all controls from list of pending items for the clipboard. }
    procedure ClearClipboard;

    { Adds the control to the list of pending items for the clipboard. }
    procedure CopyToClipboard(Control: IVRWControl);

    { Copies all the pending items to the clipboard, and clears the list }
    procedure CommitClipboard;

    { Pastes the control(s) from the clipboard. }
    procedure PasteFromClipboard(Report: IVRWReport; IntoRegion: IVRWRegion = nil; OnPaste: TVRWOnPasteControl = nil);

    { Returns True if there are any controls on the clipboard }
    function CanPaste: Boolean;

    { Returns True if the specified user has rights to view/print this file }
    function CheckSecurity(ForUser: ShortString): Boolean;

    { --- Properties --------------------------------------------------------- }

    { Version number of the report }
    property vrVersion: ShortString
      read GetVrVersion
      write SetVrVersion;

    { Full filename (including path) of the report file }
    property vrFilename: ShortString
      read GetVrFilename
      write SetVrFilename;

    { User-assigned title of report }
    property vrName: ShortString
      read GetVrName
      write SetVrName;

    { User-assigned description for the report }
    property vrDescription: ShortString
      read GetVrDescription
      write SetVrDescription;

    { Filename, as used by the Btrieve access routines }
    property vrMainFile: ShortString
      read GetVrMainFile
      write SetVrMainFile;

    { File number, as used by the Btrieve access routines }
    property vrMainFileNum: Byte
      read GetVrMainFileNum
      write SetVrMainFileNum;

    { Index ID, as used by the Btrieve access routines }
    property vrIndexID: Byte
      read GetVrIndexID
      write SetVrIndexID;

    { Btrieve index number }
//    property vrKeyPath: Integer
//      read GetVrKeyPath
//      write SetVrKeyPath;

    { Paper orientation: portrait or landscape }
    property vrPaperOrientation: Byte
      read GetVrPaperOrientation
      write SetVrPaperOrientation;

    { Specifies whether or not the report is being accessed from the Report
      Wizard }
    property vrIsWizardBased: Boolean
      read GetVrIsWizardBased
      write SetVrIsWizardBased;

    { List of regions in this report }
    property vrRegions: IVRWRegionList
      read GetVrRegions;

    { List of all controls on the report }
    property vrControls: IVRWControlList
      read GetVrControls;

    { The vrOnPrintRecord procedure (if assigned) will be called on each
      record while the report is being printed. It is passed the current
      record count, the total number of records, and an 'abort' flag which
      can be set to True to cancel the print run. Note that the report uses a
      two-pass routine, so this procedure will actually be called twice for
      every record, once on each pass. }
    property vrOnPrintRecord: TOnCheckRecordProc
      read GetVrOnPrintRecord
      write SetVrOnPrintRecord;

    { Called when the report generator begins the first pass. The record count
      and record total values will both be zero }
    property vrOnFirstPass: TOnCheckRecordProc
      read GetVrOnFirstPass
      write SetVrOnFirstPass;

    { Called when the report generator begins the second pass. The record count
      will be zero, and the record total will hold the number of records that
      will be included in the report. }
    property vrOnSecondPass: TOnCheckRecordProc
      read GetVrOnSecondPass
      write SetVrOnSecondPass;

    { Default font }
    property vrFont: IVRWFont read GetVrFont; { write SetVcFont;}

    property vrPrintMethodParams: IVRWPrintMethodParams
      read GetVrPrintMethodParams;

    { The Index Range Filter for the report }
    property vrRangeFilter: IVRWRangeFilter
      read GetVrRangeFilter;

    { Parameters for test output }
    property vrTestModeParams: IVRWTestModeParams
      read GetVrTestModeParams;

    { Collection of paper sizes }
    property vrPaperSizes: IVRWPaperSizes
      read GetVrPaperSizes;

    { Selected paper size }
    property vrPaperCode: ShortString
      read GetVrPaperCode
      write SetVrPaperCode;

    property vrReportFileName: ShortString
      read GetVrReportFileName;

    property vrDataPath: ShortString
      read GetVrDataPath
      write SetVrDataPath;

  end;

  IVRWReport2 = interface(IVRWReport)
  ['{191CDD0D-4A9D-4545-BDCC-CE0103A88581}']

    { --- Property access methods -------------------------------------------- }
    function GetVrUserID: ShortString;
    procedure SetVrUserID(const Value: ShortString);

    { --- Properties --------------------------------------------------------- }
    property vrUserID: ShortString
      read GetVrUserID
      write SetVrUserID;

  end;

  IVRWReport3 = interface(IVRWReport)
  ['{98CBD46C-93A2-418E-9474-7C7816446B07}']

    { --- Property access methods -------------------------------------------- }
    function GetVrInputFields: IVRWInputFieldList;

    { --- Properties --------------------------------------------------------- }
    property vrInputFields: IVRWInputFieldList
      read GetVrInputFields;

  end;

const
  REPORT_HEADER_NAME = 'Report Header';
  PAGE_HEADER_NAME = 'Page Header';
  SECTION_HEADER_NAME = 'Section Header ';
  REPORT_LINE_NAME = 'Report Line';
  SECTION_FOOTER_NAME = 'Section Footer ';
  PAGE_FOOTER_NAME = 'Page Footer';
  REPORT_FOOTER_NAME = 'Report Footer';

implementation

end.
