unit VRWReportU;
{
  Implementation of the interfaces in VRWReportIF, for creating, saving,
  loading, and printing reports
}
interface

uses SysUtils, Classes, Graphics, ExtCtrls, CtrlPrms, VRWReportIF,
  VRWReportFileU, GUIEng, GuiVar, GlobType, GlobalTypes, RPDevice,
  VRWClipboardManagerIF, VRWClipboardManagerU, VRWPaperSizesIF,
  oRepEngineManager, VRWReportDataIF;

type
  TVRWPrintMethodParams = class(TInterfacedObject, IVRWPrintMethodParams)
  private
    FpmEmailTo: AnsiString;
    FpmEmailMsg: AnsiString;
    FpmEmailSubj: AnsiString;
    FpmEmailAttach: AnsiString;
    FpmEmailBcc: AnsiString;
    FpmFaxMsg: AnsiString;
    FpmEmailToAddr: AnsiString;
    FpmXMLFileDir: ANSIString;
    FpmEmailCc: AnsiString;
    FpmEmailMAPI: Boolean;
    FpmBatch: Boolean;
    FpmXMLCreateHTML: Boolean;
    FpmEmailReader: Boolean;
    FpmEmailPriority: Byte;
    FpmEmailAtType: Byte;
    FpmPrintMethod: Byte;
    FpmEmailZIP: Byte;
    FpmFaxMethod: Byte;
    FpmXMLType: Byte;
    FpmFaxPriority: Byte;
    FpmTypes: LongInt;
    FpmCoverSheet: ShortString;
    FpmEmailFName: ShortString;
    FpmFaxFromNo: ShortString;
    FpmFaxToNo: ShortString;
    FpmFaxTo: ShortString;
    FpmFaxFrom: ShortString;
    FpmEmailFromAd: ShortString;
    FpmEmailFrom: ShortString;
    FpmFaxPrinter: SmallInt;
    FpmMiscOptions: TOptionArray;
    { Implementation of property access methods }
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
  public
    constructor Create;
  end;

  TVRWTestModeParams = class(TInterfacedObject, IVRWTestModeParams)
  private
    FtmTestMode: Boolean;
    FtmSampleCount: SmallInt;
    FtmRefreshStart: Boolean;
    FtmRefreshEnd: Boolean;
    FtmFirstRecPos: LongInt;
    FtmLastRecPos: LongInt;

    { --- Implementation of property access methods ------------------------- }
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
  end;

  TVRWFont = class(TInterfacedObject, IVRWFont)
  Private
    FFont : TFont;
    Function GetName : ShortString;
    Procedure SetName (Const Value : ShortString);
    Function GetSize : Integer;
    Procedure SetSize(Value : Integer);
    Function GetStyle : TFontStyles;
    Procedure SetStyle(Value : TFontStyles);
    Function GetColor : TColor;
    Procedure SetColor(Value : TColor);
  Public
    Constructor Create (Font : TFont);
  End; // TVRWFont


  TVRWRangeFilter = class(TInterfacedObject, IVRWRangeFilter)
  private
    FrfName: ShortString;
    FrfDescription: ShortString;
    FrfType: SmallInt;
    FrfAlwaysAsk: Boolean;
    FrfFromValue: ShortString;
    FrfToValue: ShortString;

    { --- Implementation of property access methods -------------------------- }

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

    function GetRangeString(RangeData: ShortString): ShortString;
  end;

  TVRWInputField = class(TInterfacedObject, IVRWInputField)
  private
    FrfID: Integer;
    FrfName: ShortString;
    FrfDescription: ShortString;
    FrfType: SmallInt;
    FrfAlwaysAsk: Boolean;
    FrfFromValue: ShortString;
    FrfToValue: ShortString;

    { --- Implementation of property access methods -------------------------- }

    function GetRfID: Integer;
    procedure SetRfID(const Value: Integer);

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

    function GetRangeString(RangeData: ShortString): ShortString;
  end;

  { Base class for report designer controls }
  TVRWControl = class(TInterfacedObject, IVRWControl)
  private
    Properties: TVRWControlProperties;
    FFontIntf : IVRWFont;
    FvcReport: IVRWReport;
    FvcFont: TFont;
{
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
}

    { --- Implementation of property access methods -------------------------- }

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
    //procedure SetVcFont(Const Value: IVRWFont);

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

  public

    constructor Create;
    destructor Destroy; override;

    function GetProperties: TVRWControlProperties;
    procedure SetProperties(const Value: TVRWControlProperties);

  end;

  { Classes for report designer controls }
  TVRWTextControl = class(TVRWControl, IVRWTextControl)
  end;

  TVRWImageControl = class(TVRWControl, IVRWImageControl)
  private
//    FvcFolio: ShortString;
    FvcImage: TImage;
    FvcImageStream: TMemoryStream;
    FvcBMPStore: TRawBMPStore;
    FvcBMPIndex: Integer;

    { --- Implementation of property access methods -------------------------- }

    function GetVcFolio: ShortString;
    procedure SetVcFolio(const Value: ShortString);

    function GetVcImage: TImage;

    function GetVcImageStream: TMemoryStream;

    function GetVcBMPStore: TRawBMPStore;

    function GetVcBMPIndex: Integer;
    procedure SetVcBMPIndex(const Value: Integer);

  public

    constructor Create;
    destructor Destroy; override;

    procedure LoadImage(const Filename: string);
    procedure ReadImageBuffer;

  end;

  TVRWLineControl = class(TVRWControl, IVRWLineControl)
  private
{
    FvcLineOrientation: TLineOrientation;
    FvcLineLength: SmallInt;
    FvcPenColor: TColor;
    FvcPenMode: Byte;
    FvcPenStyle: Byte;
    FvcPenWidth: SmallInt;
}
    { --- Implementation of property access methods -------------------------- }

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

  public

    constructor Create;

  end;

  TVRWBoxLine = class(TInterfacedObject, IVRWBoxLine)
  private
    FvcLineStyle: TPenStyle;
    FvcLineColor: TColor;
    FvcLineWidth: Byte;

    { --- Implementation of property access methods -------------------------- }

    function GetvcLineStyle: TPenStyle;
    procedure SetvcLineStyle (const Value: TPenStyle);

    function GetvcLineColor: TColor;
    procedure SetvcLineColor (const Value: TColor);

    function GetvcLineWidth: Byte;
    procedure SetvcLineWidth (const Value: Byte);
  end;

  TVRWBoxControl = class(TVRWControl, IVRWBoxControl)
  private
{
    FvcFilled: Boolean;
    FvcFillColor: TColor;
}
    FvcBoxLines: TVRWBoxLineArray;

    { --- Implementation of property access methods -------------------------- }

    function GetVcFilled: Boolean;
    procedure SetVcFilled(const Value: Boolean);

    function GetVcFillColor: TColor;
    procedure SetVcFillColor(const Value: TColor);

    function GetVcBoxLine(Index: TVRWBoxLineIndex): IVRWBoxLine;
    procedure SetVcBoxLine(Index: TVRWBoxLineIndex; const Value: IVRWBoxLine);
  public

    constructor Create;
    destructor Destroy; override;

  end;

  TVRWFieldControl = class(TVRWControl, IVRWFieldControl)
  private
    FvcInputLine: IVRWInputField; // Redundant -- see FvcRangeFilter
    FvcRangeFilter: IVRWRangeFilter;
{
    FvcFieldName: ShortString;
    FvcSortOrder: ShortString;
    FvcSelectCriteria: ShortString;
    FvcPrintField: Boolean;
    FvcSubTotal: Boolean;
    FvcPageBreak: Boolean;
    FvcRecalcBreak : Boolean;
    FvcSelectSummary: Boolean;
    FvcVarNo: LongInt;
    FvcVarLen: Byte;
    FvcVarDesc: ShortString;
    FvcVarType: Byte;
    FvcVarNoDecs: Byte;
    FvcPeriodField: Boolean;
    FvcPeriod: ShortString;
    FvcYear: ShortString;
    FvcParsedInputLine: ShortString;  // Redundant
    FvcCurrency: Byte;
    FvcFieldIdx: SmallInt;
}

    { --- Implementation of property access methods -------------------------- }

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

  public
    constructor Create;
    destructor Destroy; override;
  end;

  TVRWFormulaControl = class(TVRWControl, IVRWFormulaControl)
  private
{
    FvcComments: ShortString;
    FvcFormulaDefinition: ShortString;
    FvcDecimalPlaces: Byte;
    FvcTotalType: TTotalType;
    FvcFormulaName: ShortString;
    FvcSortOrder: ShortString;
    FvcPrintField: Boolean;
    FvcFieldIdx: SmallInt;
    FvcPeriod: ShortString;
    FvcYear: ShortString;
    FvcCurrency: Byte;
}

    { --- Implementation of property access methods -------------------------- }

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

    function GetVcPrintField: Boolean;
    procedure SetVcPrintField(const Value: Boolean);

    function GetVcPageBreak: Boolean;
    procedure SetVcPageBreak(const Value: Boolean);

    function GetVcFieldIdx: SmallInt;
    procedure SetVcFieldIdx(const Value: SmallInt);

    function GetVcPeriod: ShortString;
    procedure SetVcPeriod(const Value: ShortString);

    function GetVcYear: ShortString;
    procedure SetVcYear(const Value: ShortString);

    function GetVcCurrency: Byte;
    procedure SetVcCurrency(const Value: Byte);

  public
    constructor Create;
  end;

  { Class to maintain a list of report designer controls }
  TVRWControlList = class(TInterfacedObject, IVRWControlList)
  private
    FList: TInterfaceList;
    FclRegionName: ShortString;

    { --- Implementation of property access methods -------------------------- }

    function GetClItem(Index: Integer): IVRWControl;
    procedure SetClItem(Index: Integer; Value: IVRWControl);

    function GetClControl(Index: ShortString): IVRWControl;
    procedure SetClControl(Index: ShortString; Value: IVRWControl);

    function GetClCount: SmallInt;

    function GetClRegionName: ShortString;
    procedure SetClRegionName(const Value: ShortString);

  public
    constructor Create;
    destructor Destroy; override;

    { --- Implementation of interface methods -------------------------------- }

    function Add(Owner: IVRWReport; ControlType: TControlType;
      ControlName: string = ''): IVRWControl;

    procedure Delete(Control: IVRWControl); overload;
    procedure Delete(ControlName: ShortString); overload;
    procedure Delete(ControlIndex: SmallInt); overload;

    procedure Append(Control: IVRWControl);

    procedure Remove(Control: IVRWControl); overload;
    procedure Remove(ControlName: ShortString); overload;
    procedure Remove(ControlIndex: SmallInt); overload;

    procedure Transfer(Control: IVRWControl;
      Target: IVRWControlList); overload;
    procedure Transfer(ControlName: ShortString;
      Target: IVRWControlList); overload;
    procedure Transfer(ControlIndex: SmallInt;
      Target: IVRWControlList); overload;

    procedure Clear;

    procedure BringToFront(Control: IVRWControl);
    procedure SendToBack(Control: IVRWControl);

  end;

  { Class for a report region (section) }
  TVRWRegion = class(TInterfacedObject, IVRWRegion)
  private
    FrgReport: IVRWReport;
    FrgControls: IVRWControlList;
    FrgName: ShortString;
    FrgDescription: ShortString;
    FrgType: TRegionType;
    FrgSectionNumber: SmallInt;
    FrgTop: SmallInt;
    FrgLeft: SmallInt;
    FrgHeight: SmallInt;
    FrgVisible: Boolean;
    FrgIndexNumber: LongInt;

    { --- Implementation of property access methods -------------------------- }

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

    { --- Support routines --------------------------------------------------- }

  public
    constructor Create;
    destructor Destroy; override;

    { --- Implementation of interface methods -------------------------------- }

    procedure Clear;

  end;

  { Class to maintain a list of report regions (sections) }
  TVRWRegionList = class(TInterfacedObject, IVRWRegionList)
  private
    FList: TInterfaceList;

    { --- Implementation of property access methods -------------------------- }

    function GetRlItem(Index: Integer): IVRWRegion;
    procedure SetRlItem(Index: Integer; Value: IVRWRegion);

    function GetRlRegion(Index: ShortString): IVRWRegion;
    procedure SetRlRegion(Index: ShortString; Value: IVRWRegion);

    function GetRlCount: SmallInt;

    { --- Implementation of interface methods -------------------------------- }

    function Add(Owner: IVRWReport; RegionType: TRegionType;
      SectionNumber: SmallInt = 0; RegionName: ShortString = ''): IVRWRegion;

    procedure Clear;

    procedure Delete(Region: IVRWRegion); overload;
    procedure Delete(RegionName: ShortString); overload;
    procedure Delete(RegionIndex: SmallInt); overload;

    { --- Support methods ---------------------------------------------------- }

    function CreateRegionName(RegionType: TRegionType;
      SectionNumber: SmallInt): ShortString;

    procedure Sort;

    procedure Renumber;

  public
    constructor Create;
    destructor Destroy; override;
  end;

  TVRWInputFieldList = class(TInterfacedObject, IVRWInputFieldList)
  private
    FList: TInterfaceList;

    { --- Implementation of property access methods -------------------------- }

    function GetRfItem(Index: Integer): IVRWInputField;
    procedure SetRfItem(Index: Integer; Value: IVRWInputField);

    function GetRfCount: SmallInt;
    
  public
    constructor Create;
    destructor Destroy; override;

    { --- Implementation of interface methods -------------------------------- }

    function Add: IVRWInputField;
    procedure Clear;

  end;

  { Main class for handling reports }
  TVRWReport = class(TInterfacedObject, IVRWReport, IVRWReport2, IVRWReport3,
                     IVRWClipboardManager)
  private
    FParser: TReportWriterEngine;
    FClipboardManager: IVRWClipboardManager;
    FvrControls: IVRWControlList;
    FvrRegions: IVRWRegionList;
    FvrVersion: ShortString;
    FvrFilename: ShortString;
    FvrName: ShortString;
    FvrDescription: ShortString;
    FvrMainFile: ShortString;
    FvrMainFileNum: Byte;
    FvrIndexID: Byte;
    FvrPaperOrientation: Byte;
    FvrIsWizardBased: Boolean;
    FvrOnPrintRecord: TOnCheckRecordProc;
    FvrOnFirstPass: TOnCheckRecordProc;
    FvrOnSecondPass: TOnCheckRecordProc;
    FvrFont: TFont;
    FvrPrintMethodParams: IVRWPrintMethodParams;
    FvrTestModeParams: IVRWTestModeParams;
    FvrRangeFilter: IVRWRangeFilter;
    FvrPaperSizes: IVRWPaperSizes;
    FvrPaperCode: ShortString;
    FvrReportFileName: ShortString;
    FvrDataPath: ShortString;
    FvrUserID: ShortString;
    FvrInputFields: IVRWInputFieldList;

    FFontIntf : IVRWFont;
    FRepEngineManager: IRepEngineManager;

    { --- Implementation of property access methods -------------------------- }

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

    function GetVrUserID: ShortString;
    procedure SetVrUserID(const Value: ShortString);

    function GetVrInputFields: IVRWInputFieldList;

    { --- Support routines --------------------------------------------------- }

    function ArrayToOptionArray(BooleanArray: array of Boolean): TOptionArray;

  public

    constructor Create(Manager: IRepEngineManager);
    destructor Destroy; override;
    function ParserCallBack(const ValueIdentifier, ValueName: string;
      var ErrorCode: SmallInt; var ErrorString : ShortString;
      var ErrorWord : ShortString): ResultValueType;
    procedure AddInputFieldsToParser;

    { --- Implementation of interface methods -------------------------------- }

    procedure Clear;

    procedure Read(const FileName: ShortString);

    procedure Write(WithCompression: Boolean = True);

    function Print(const FileName: ShortString; ExternalCall: Boolean = False): Boolean;

    procedure RegisterControl(Control: IVRWControl);

    procedure UnregisterControl(Control: IVRWControl);

    function CreateUniqueControlName(ControlType: TControlType): ShortString;

    function CreateUniqueFormulaName: ShortString;

    function ValidateFormula(FormulaDefinition: string): string;

    function ValidateSelectionCriteria(SelectionCriteria: string): string;

    procedure UpdateFormulaReferences(const OldName, NewName: ShortString);

    procedure ReadPrintMethodParams(FromPrinterInfo: TSBSPrintSetupInfo);

    procedure WritePrintMethodParams(var ToPrinterInfo: TSBSPrintSetupInfo);

    function FindFieldControl(FieldName: string): IVRWFieldControl;

    function FindFormulaControl(FormulaName: string): IVRWFormulaControl;

    procedure ClearClipboard;

    procedure CopyToClipboard(Control: IVRWControl);

    procedure CommitClipboard;

    procedure PasteFromClipboard(Report: IVRWReport; IntoRegion: IVRWRegion = nil; OnPaste: TVRWOnPasteControl = nil);

    function CanPaste: Boolean;

    function CheckSecurity(ForUser: ShortString): Boolean;
    
  end;

implementation

uses Dialogs, VRWReportGeneratorU, VRWPaperSizesU, ETDateU, VarConst,
     // MH 06/02/2017 ABSEXCH-14925 2017-R1: Added support for extra image types
     ImageConversionFuncs;

//=========================================================================

Constructor TVRWFont.Create (Font : TFont);
Begin // Create
  Inherited Create;
  FFont := Font;
End; // Create

//-------------------------------------------------------------------------

Function TVRWFont.GetName : ShortString;
Begin // GetName
  Result := FFont.Name;
End; // GetName
Procedure TVRWFont.SetName (Const Value : ShortString);
Begin // SetName
  FFont.Name := Value;
End; // SetName

//------------------------------

Function TVRWFont.GetSize : Integer;
Begin // GetSize
  Result := FFont.Size;
End; // GetSize
Procedure TVRWFont.SetSize(Value : Integer);
Begin // SetSize
  FFont.Size := Value;
End; // SetSize

//------------------------------

Function TVRWFont.GetStyle : TFontStyles;
Begin // GetStyle
  Result := FFont.Style;
End; // GetStyle
Procedure TVRWFont.SetStyle(Value : TFontStyles);
Begin // SetStyle
  FFont.Style := Value;
End; // SetStyle

//------------------------------

Function TVRWFont.GetColor : TColor;
Begin // GetColor
  Result := FFont.Color;
End; // GetColor
Procedure TVRWFont.SetColor(Value : TColor);
Begin // SetColor
  FFont.Color := Value;
End; // SetColor

//=========================================================================

{ TVRWControl }

constructor TVRWControl.Create;
begin
  inherited Create;
  FvcFont       := TFont.Create;
  FvcFont.Name  := 'Arial';
  FvcFont.Size  := 9;
  FvcFont.Color := clWindowText;
  FvcFont.Style := [];
  FFontIntf     := TVRWFont.Create(FvcFont);
  Properties.FvcDeleted := False;
  Properties.FvcVisible := True;
end;

destructor TVRWControl.Destroy;
begin
  FvcReport := nil;
  FreeAndNil(FvcFont);
  FFontIntf := NIL;
  inherited;
end;

function TVRWControl.GetProperties: TVRWControlProperties;
begin
  { Update the properties which need special handling }
  Properties.Font.Name  := FvcFont.Name;
  Properties.Font.Size  := FvcFont.Size;
  Properties.Font.Color := FvcFont.Color;
  Properties.Font.Style := FvcFont.Style;

  if Supports(self, IVRWFieldControl) then
  with self as IVRWFieldControl do
  begin
    Properties.Filter.FrfName := vcRangeFilter.rfName;
    Properties.Filter.FrfDescription := vcRangeFilter.rfDescription;
    Properties.Filter.FrfType := vcRangeFilter.rfType;
    Properties.Filter.FrfAlwaysAsk := vcRangeFilter.rfAlwaysAsk;
    Properties.Filter.FrfFromValue := vcRangeFilter.rfFromValue;
    Properties.Filter.FrfToValue := vcRangeFilter.rfToValue;
  end;

  if Supports(self, IVRWBoxControl) then
  with self as IVRWBoxControl do
  begin
    Properties.BoxLines[biLeft].FvcLineStyle := vcBoxLines[biLeft].vcLineStyle;
    Properties.BoxLines[biLeft].FvcLineColor := vcBoxLines[biLeft].vcLineColor;
    Properties.BoxLines[biLeft].FvcLineWidth := vcBoxLines[biLeft].vcLineWidth;

    Properties.BoxLines[biTop].FvcLineStyle := vcBoxLines[biTop].vcLineStyle;
    Properties.BoxLines[biTop].FvcLineColor := vcBoxLines[biTop].vcLineColor;
    Properties.BoxLines[biTop].FvcLineWidth := vcBoxLines[biTop].vcLineWidth;

    Properties.BoxLines[biRight].FvcLineStyle := vcBoxLines[biRight].vcLineStyle;
    Properties.BoxLines[biRight].FvcLineColor := vcBoxLines[biRight].vcLineColor;
    Properties.BoxLines[biRight].FvcLineWidth := vcBoxLines[biRight].vcLineWidth;

    Properties.BoxLines[biBottom].FvcLineStyle := vcBoxLines[biBottom].vcLineStyle;
    Properties.BoxLines[biBottom].FvcLineColor := vcBoxLines[biBottom].vcLineColor;
    Properties.BoxLines[biBottom].FvcLineWidth := vcBoxLines[biBottom].vcLineWidth;
  end;

  Result := Properties;
end;

function TVRWControl.GetVcCaption: ShortString;
begin
  Result := Properties.FvcCaption;
end;

function TVRWControl.GetVcDeleted: Boolean;
begin
  Result := Properties.FvcDeleted;
end;

function TVRWControl.GetVcFieldFormat: ShortString;
begin
  Result := Properties.FvcFieldFormat;
end;

function TVRWControl.GetVcFont: IVRWFont;
begin
  Result := FFontIntf;//FvcFont;
end;

function TVRWControl.GetVcHeight: SmallInt;
begin
  Result := Properties.FvcHeight;
end;

function TVRWControl.GetVcLeft: SmallInt;
begin
  Result := Properties.FvcLeft;
end;

function TVRWControl.GetVcName: ShortString;
begin
  Result := Properties.FvcName;
end;

function TVRWControl.GetVcPrintIf: ShortString;
begin
  Result := Properties.FvcPrintIf;
end;

function TVRWControl.GetVcRegionName: ShortString;
begin
  Result := Properties.FvcRegionName;
end;

function TVRWControl.GetVcReport: IVRWReport;
begin
  Result := FvcReport;
end;

function TVRWControl.GetVcText: ShortString;
begin
  Result := Properties.FvcText;
end;

function TVRWControl.GetVcTop: SmallInt;
begin
  Result := Properties.FvcTop;
end;

function TVRWControl.GetVcType: TControlType;
begin
  Result := Properties.FvcType;
end;

function TVRWControl.GetVcVisible: Boolean;
begin
  Result := Properties.FvcVisible;
end;

function TVRWControl.GetVcWidth: SmallInt;
begin
  Result := Properties.FvcWidth;
end;

function TVRWControl.GetVcZOrder: SmallInt;
begin
  Result := Properties.FvcZOrder;
end;

procedure TVRWControl.SetProperties(const Value: TVRWControlProperties);
begin
  Properties := Value;
  { Update the properties which need special handling }
  FvcFont.Name  := Properties.Font.Name;
  FvcFont.Size  := Properties.Font.Size;
  FvcFont.Color := Properties.Font.Color;
  FvcFont.Style := Properties.Font.Style;

  if Supports(self, IVRWFieldControl) then
  with self as IVRWFieldControl do
  begin
    vcRangeFilter.rfName        := Properties.Filter.FrfName;
    vcRangeFilter.rfDescription := Properties.Filter.FrfDescription;
    vcRangeFilter.rfType        := Properties.Filter.FrfType;
    vcRangeFilter.rfAlwaysAsk   := Properties.Filter.FrfAlwaysAsk;
    vcRangeFilter.rfFromValue   := Properties.Filter.FrfFromValue;
    vcRangeFilter.rfToValue     := Properties.Filter.FrfToValue;
  end;

  if Supports(self, IVRWBoxControl) then
  with self as IVRWBoxControl do
  begin
    vcBoxLines[biLeft].vcLineStyle := Properties.BoxLines[biLeft].FvcLineStyle;
    vcBoxLines[biLeft].vcLineColor := Properties.BoxLines[biLeft].FvcLineColor;
    vcBoxLines[biLeft].vcLineWidth := Properties.BoxLines[biLeft].FvcLineWidth;

    vcBoxLines[biTop].vcLineStyle := Properties.BoxLines[biTop].FvcLineStyle;
    vcBoxLines[biTop].vcLineColor := Properties.BoxLines[biTop].FvcLineColor;
    vcBoxLines[biTop].vcLineWidth := Properties.BoxLines[biTop].FvcLineWidth;

    vcBoxLines[biRight].vcLineStyle := Properties.BoxLines[biRight].FvcLineStyle;
    vcBoxLines[biRight].vcLineColor := Properties.BoxLines[biRight].FvcLineColor;
    vcBoxLines[biRight].vcLineWidth := Properties.BoxLines[biRight].FvcLineWidth;

    vcBoxLines[biBottom].vcLineStyle := Properties.BoxLines[biBottom].FvcLineStyle;
    vcBoxLines[biBottom].vcLineColor := Properties.BoxLines[biBottom].FvcLineColor;
    vcBoxLines[biBottom].vcLineWidth := Properties.BoxLines[biBottom].FvcLineWidth;
  end;
end;

procedure TVRWControl.SetVcCaption(const Value: ShortString);
begin
  Properties.FvcCaption := Value;
end;

procedure TVRWControl.SetVcDeleted(const Value: Boolean);
begin
  Properties.FvcDeleted := Value;
end;

procedure TVRWControl.SetVcFieldFormat(const Value: ShortString);
begin
  Properties.FvcFieldFormat := Value;
end;

//procedure TVRWControl.SetVcFont(Const Value: IVRWFont);
//begin
//  //FvcFont.Assign(Value);
//end;

procedure TVRWControl.SetVcHeight(const Value: SmallInt);
begin
  Properties.FvcHeight := Value;
end;

procedure TVRWControl.SetVcLeft(const Value: SmallInt);
begin
  Properties.FvcLeft := Value;
end;

procedure TVRWControl.SetVcName(const Value: ShortString);
begin
  Properties.FvcName := Value;
end;

procedure TVRWControl.SetVcPrintIf(const Value: ShortString);
begin
  Properties.FvcPrintIf := Value;
end;

procedure TVRWControl.SetVcRegionName(const Value: ShortString);
begin
  Properties.FvcRegionName := Value;
end;

procedure TVRWControl.SetVcReport(const Value: IVRWReport);
begin
  FvcReport := Value;
end;

procedure TVRWControl.SetVcText(const Value: ShortString);
begin
  Properties.FvcText := Value;
end;

procedure TVRWControl.SetVcTop(const Value: SmallInt);
begin
  Properties.FvcTop := Value;
end;

procedure TVRWControl.SetVcType(const Value: TControlType);
begin
  Properties.FvcType := Value;
end;

procedure TVRWControl.SetVcVisible(const Value: Boolean);
begin
  Properties.FvcVisible := Value;
end;

procedure TVRWControl.SetVcWidth(const Value: SmallInt);
begin
  Properties.FvcWidth := Value;
end;

procedure TVRWControl.SetVcZOrder(const Value: SmallInt);
begin
  Properties.FvcZOrder := Value;
end;

{ TVRWControlList }

function TVRWControlList.Add(Owner: IVRWReport; ControlType: TControlType;
  ControlName: string): IVRWControl;
begin
  if (Owner <> nil) then
  begin
    { Create a control of the requested type }
    case ControlType of
      ctText:    Result := TVRWTextControl.Create;
      ctImage:   Result := TVRWImageControl.Create;
      ctLine:    Result := TVRWLineControl.Create;
      ctBox:     Result := TVRWBoxControl.Create;
      ctField:   Result := TVRWFieldControl.Create;
      ctFormula: Result := TVRWFormulaControl.Create;
    end;
    { If no name was supplied, request a suitable one from IVRWReport. }
    if (Trim(ControlName) = '') then
      ControlName := Owner.CreateUniqueControlName(ControlType);
    { For formula controls, assign a default name }
    if ControlType = ctFormula then
      (Result as IVRWFormulaControl).vcFormulaName := Owner.CreateUniqueFormulaName;
    { Set the owner, control name, and default values }
    Result.vcReport     := Owner;
    Result.vcRegionName := FclRegionName;
    Result.vcType       := ControlType;
    Result.vcName       := ControlName;
    Result.vcCaption    := '';
    Result.vcTop        := 10;
    Result.vcLeft       := 10;
    Result.vcHeight     := 21;
    Result.vcWidth      := 80;
    Result.vcVisible    := True;
    Result.vcFont.Name  := Owner.vrFont.Name;
    Result.vcFont.Size  := Owner.vrFont.Size;
    Result.vcFont.Style := Owner.vrFont.Style;
    Result.vcFont.Color := Owner.vrFont.Color;
    { Register the control with the report (which needs to know about controls
      which have been created) }
    Owner.RegisterControl(Result);
    { Add the control to the internal list }
    FList.Add(Result);
  end
  else
  begin
    { Strictly speaking, this is an error -- the Owner should never be nil --
      but we cannot easily handle this error from within a DLL. Just return nil
      and expect the controlling program to deal with it. }
    Result := nil;
  end;
end;

procedure TVRWControlList.Append(Control: IVRWControl);
begin
  FList.Add(Control);
end;

procedure TVRWControlList.Clear;
begin
  FList.Clear;
end;

constructor TVRWControlList.Create;
begin
  inherited Create;
  FList := TInterfaceList.Create;
end;

procedure TVRWControlList.Delete(Control: IVRWControl);
var
  Entry: Integer;
begin
  Entry := FList.IndexOf(Control);
  Delete(Entry);
end;

procedure TVRWControlList.Delete(ControlName: ShortString);
var
  Entry: Integer;
  Item: IVRWControl;
begin
  for Entry := 0 to FList.Count - 1 do
  begin
    Item := IVRWControl(FList[Entry]);
    if SameText(Item.vcName, ControlName) then
    begin
      Item := nil;
      Delete(Entry);
      Break;
    end;
    Item := nil;
  end;
end;

procedure TVRWControlList.Delete(ControlIndex: SmallInt);
var
  Control: IVRWControl;
begin
  { Get the control and unregister it from the report }
  Control := IVRWControl(FList[ControlIndex]);
  Control.vcReport.UnregisterControl(Control);
  { Make sure the reference is cleared }
  Control := nil;
  { Delete the control from the internal list }
  FList.Delete(ControlIndex);
end;

destructor TVRWControlList.Destroy;
begin
  FList.Clear;
  FreeAndNil(FList);
  inherited;
end;

function TVRWControlList.GetClControl(Index: ShortString): IVRWControl;
var
  Entry: Integer;
begin
  Result := nil;
  for Entry := 0 to FList.Count - 1 do
  begin
    Result := IVRWControl(FList[Entry]);
    if SameText(Result.vcName, Index) then
      Break;
    Result := nil;
  end;
end;

function TVRWControlList.GetClItem(Index: Integer): IVRWControl;
begin
  Result := IVRWControl(FList[Index]);
end;

function TVRWControlList.GetClCount: SmallInt;
begin
  Result := FList.Count;
end;

procedure TVRWControlList.Remove(Control: IVRWControl);
//var
//  Entry: Integer;
begin
//  Entry := FList.IndexOf(Control);
  Remove(Control.vcName);
end;

procedure TVRWControlList.Remove(ControlIndex: SmallInt);
begin
  if (ControlIndex > -1) then
    FList.Delete(ControlIndex);
end;

procedure TVRWControlList.Remove(ControlName: ShortString);
var
  Entry: Integer;
  Item: IVRWControl;
begin
  for Entry := 0 to FList.Count - 1 do
  begin
    Item := IVRWControl(FList[Entry]);
    if SameText(Item.vcName, ControlName) then
    begin
      Item := nil;
      Remove(Entry);
      Break;
    end;
    Item := nil;
  end;
end;

procedure TVRWControlList.SetClControl(Index: ShortString;
  Value: IVRWControl);
var
  Entry: Integer;
  Item: IVRWControl;
begin
  for Entry := 0 to FList.Count - 1 do
  begin
    Item := IVRWControl(FList[Entry]);
    if SameText(Item.vcName, Index) then
    begin
      { Make sure any existing references are cleared }
      FList[Entry] := nil;
      Item := nil;
      { Install the new reference }
      FList[Entry] := Value;
      Break;
    end;
    Item := nil;
  end;
end;

procedure TVRWControlList.SetClItem(Index: Integer; Value: IVRWControl);
begin
  { Make sure any existing reference is cleared }
  FList[Index] := nil;
  { Install the new reference }
  FList[Index] := Value;
end;

procedure TVRWControlList.Transfer(Control: IVRWControl;
  Target: IVRWControlList);
begin
  Remove(Control);
  Target.Append(Control);
end;

procedure TVRWControlList.Transfer(ControlName: ShortString;
  Target: IVRWControlList);
var
  Control: IVRWControl;
begin
  Control := GetClControl(ControlName);
  Transfer(Control, Target);
  Control := nil;
end;

procedure TVRWControlList.Transfer(ControlIndex: SmallInt;
  Target: IVRWControlList);
var
  Control: IVRWControl;
begin
  Control := GetClItem(ControlIndex);
  Transfer(Control, Target);
  Control := nil;
end;

function TVRWControlList.GetClRegionName: ShortString;
begin
  Result := FclRegionName;
end;

procedure TVRWControlList.SetClRegionName(const Value: ShortString);
var
  Entry: Integer;
  Item: IVRWControl;
begin
  FclRegionName := Value;
  for Entry := 0 to FList.Count - 1 do
  begin
    Item := IVRWControl(FList[Entry]);
    Item.vcRegionName := Value;
  end;
end;

procedure TVRWControlList.BringToFront(Control: IVRWControl);
begin
  Remove(Control);
  FList.Add(Control);
end;

procedure TVRWControlList.SendToBack(Control: IVRWControl);
begin
  Remove(Control);
  FList.Insert(0, Control);
end;

{ TVRWRegion }

procedure TVRWRegion.Clear;
begin
  FrgControls.Clear;
end;

constructor TVRWRegion.Create;
begin
  inherited Create;
  FrgControls := TVRWControlList.Create;
  FrgVisible  := True;
end;

destructor TVRWRegion.Destroy;
begin
  FrgReport   := nil;
  FrgControls := nil;
  inherited;
end;

function TVRWRegion.GetRgControlCount: SmallInt;
begin
  Result := FrgControls.GetClCount;
end;

function TVRWRegion.GetRgControls: IVRWControlList;
begin
  Result := FrgControls;
end;

function TVRWRegion.GetRgDescription: ShortString;
begin
  Result := FrgDescription;
end;

function TVRWRegion.GetRgHeight: SmallInt;
begin
  Result := FrgHeight;
end;

function TVRWRegion.GetRgIndexNumber: LongInt;
begin
  Result := FrgIndexNumber;
end;

function TVRWRegion.GetRgLeft: SmallInt;
begin
  Result := FrgLeft;
end;

function TVRWRegion.GetRgName: ShortString;
begin
  Result := FrgName;
end;

function TVRWRegion.GetRgReport: IVRWReport;
begin
  Result := FrgReport;
end;

function TVRWRegion.GetRgSectionNumber: SmallInt;
begin
  Result := FrgSectionNumber;
end;

function TVRWRegion.GetRgTop: SmallInt;
begin
  Result := FrgTop;
end;

function TVRWRegion.GetRgType: TRegionType;
begin
  Result := FrgType;
end;

function TVRWRegion.GetRgVisible: Boolean;
begin
  Result := FrgVisible;
end;

procedure TVRWRegion.SetRgDescription(const Value: ShortString);
begin
  FrgDescription := Value;
end;

procedure TVRWRegion.SetRgHeight(const Value: SmallInt);
begin
  FrgHeight := Value;
end;

procedure TVRWRegion.SetRgIndexNumber(const Value: LongInt);
begin
  FrgIndexNumber := Value;
end;

procedure TVRWRegion.SetRgLeft(const Value: SmallInt);
begin
  FrgLeft := Value;
end;

procedure TVRWRegion.SetRgName(const Value: ShortString);
begin
  FrgName := Value;
  FrgControls.clRegionName := FrgName;
end;

procedure TVRWRegion.SetRgReport(const Value: IVRWReport);
begin
  FrgReport := Value;
end;

procedure TVRWRegion.SetRgSectionNumber(const Value: SmallInt);
begin
  FrgSectionNumber := Value;
end;

procedure TVRWRegion.SetRgTop(const Value: SmallInt);
begin
  FrgTop := Value;
end;

procedure TVRWRegion.SetRgType(const Value: TRegionType);
begin
  FrgType := Value;
end;

procedure TVRWRegion.SetRgVisible(const Value: Boolean);
begin
  FrgVisible := Value;
end;

{ TVRWRegionList }

function TVRWRegionList.Add(Owner: IVRWReport; RegionType: TRegionType;
  SectionNumber: SmallInt; RegionName: ShortString): IVRWRegion;
var
  BaseIndex: LongInt;
begin
  Result := TVRWRegion.Create;
  if (Trim(RegionName) = '') then
    RegionName := CreateRegionName(RegionType, SectionNumber);
  { Set the name, type, and default values }
  Result.rgType          := RegionType;
  Result.rgName          := RegionName;
  Result.rgReport        := Owner;
  Result.rgTop           := 0;
  Result.rgHeight        := 10;
  Result.rgDescription   := RegionName;
  Result.rgSectionNumber := SectionNumber;

  { Set the index number (for sorting). Note that this works on the basis that
    TRegionType enumerated values are in the order expected by the report, and
    results (at the time of writing) in the following index numbers:

      rtRepHdr     : 10000
      rtPageHdr    : 20000
      rtSectionHdr : 30000 + SectionNumber
      rtRepLines   : 40000
      rtSectionFtr : 50000 - SectionNumber
      rtPageFtr    : 60000
      rtRepFtr     : 70000
  }
  BaseIndex := 10000 * Ord(RegionType);
  if (RegionType = rtSectionHdr) then
    Result.rgIndexNumber := BaseIndex + SectionNumber
  else if (RegionType = rtSectionFtr) then
    Result.rgIndexNumber := BaseIndex - SectionNumber
  else
    Result.rgIndexNumber := BaseIndex;

  FList.Add(Result);
end;

procedure TVRWRegionList.Clear;
var
  RegionIndex: Integer;
begin
  for RegionIndex := 0 to FList.Count - 1 do
    IVRWRegion(FList[RegionIndex]).Clear;
  FList.Clear;
end;

constructor TVRWRegionList.Create;
begin
  inherited Create;
  FList := TInterfaceList.Create;
end;

function TVRWRegionList.CreateRegionName(
  RegionType: TRegionType; SectionNumber: SmallInt): ShortString;
{ Creates a region name based on the supplied type. For Sections, the
  SectionNumber should also be specified and will be added to the name. This
  function does not check that the resulting name is unique. }
var
  BaseName: ShortString;
begin
  case RegionType of
    rtUnknown:    BaseName := 'Unknown ';
    rtRepHdr:     BaseName := 'Report Header ';
    rtPageHdr:    BaseName := 'Page Header ';
    rtSectionHdr: BaseName := 'Section Header ';
    rtRepLines:   BaseName := 'Report Line ';
    rtSectionFtr: BaseName := 'Section Footer ';
    rtPageFtr:    BaseName := 'Page Footer ';
    rtRepFtr:     BaseName := 'Report Footer ';
  end;
  if (SectionNumber <> 0) then
    Result := BaseName + IntToStr(SectionNumber)
  else
    Result := Trim(BaseName);
end;

procedure TVRWRegionList.Delete(Region: IVRWRegion);
var
  Entry: Integer;
begin
  Entry := FList.IndexOf(Region);
  Delete(Entry);
end;

procedure TVRWRegionList.Delete(RegionName: ShortString);
var
  Entry: Integer;
  Item: IVRWRegion;
begin
  for Entry := 0 to FList.Count - 1 do
  begin
    Item := IVRWRegion(FList[Entry]);
    if SameText(Item.rgName, RegionName) then
    begin
      Item := nil;
      Delete(Entry);
      Break;
    end;
    Item := nil;
  end;
end;

procedure TVRWRegionList.Delete(RegionIndex: SmallInt);
var
  Region: IVRWRegion;
begin
  { Get the region and clear the controls }
  Region := IVRWRegion(FList[RegionIndex]);
  Region.Clear;
  { Make sure the reference is cleared }
  Region := nil;
  { Delete the region from the internal list }
  FList.Delete(RegionIndex);
end;

destructor TVRWRegionList.Destroy;
begin
  FList.Clear;
  FreeAndNil(FList);
  inherited;
end;

function TVRWRegionList.GetRlCount: SmallInt;
begin
  Result := FList.Count;
end;

function TVRWRegionList.GetRlItem(Index: Integer): IVRWRegion;
begin
  Result := IVRWRegion(FList[Index]);
end;

function TVRWRegionList.GetRlRegion(Index: ShortString): IVRWRegion;
var
  Entry: Integer;
begin
  Result := nil;
  for Entry := 0 to FList.Count - 1 do
  begin
    Result := IVRWRegion(FList[Entry]);
    if SameText(Result.rgName, Index) then
      Break;
    Result := nil;
  end;
end;

procedure TVRWRegionList.Renumber;
var
  SectionNumber: Integer;
  Entry: Integer;
  Item: IVRWRegion;
begin
  SectionNumber := 1;
  for Entry := 0 to FList.Count - 1 do
  begin
    Item := IVRWRegion(FList[Entry]);
    if (Item.rgType = rtSectionHdr) then
    begin
      Item.rgSectionNumber := SectionNumber;
      Item.rgName := 'Section Header ' + IntToStr(Item.rgSectionNumber);
      Item.rgDescription := Item.rgName;
      Item.rgControls.clRegionName := Item.rgName;
      Inc(SectionNumber);
    end
    else if (Item.rgType = rtSectionFtr) then
    begin
      Dec(SectionNumber);
      Item.rgSectionNumber := SectionNumber;
      Item.rgName := 'Section Footer ' + IntToStr(Item.rgSectionNumber);
      Item.rgDescription := Item.rgName;
      Item.rgControls.clRegionName := Item.rgName;
    end;
  end;
end;

procedure TVRWRegionList.SetRlItem(Index: Integer; Value: IVRWRegion);
begin
  { Make sure any existing reference is released }
  FList[Index] := nil;
  { Install the new reference }
  FList[Index] := Value;
end;

procedure TVRWRegionList.SetRlRegion(Index: ShortString;
  Value: IVRWRegion);
var
  Entry: Integer;
  Item: IVRWRegion;
begin
  for Entry := 0 to FList.Count - 1 do
  begin
    Item := IVRWRegion(FList[Entry]);
    if SameText(Item.rgName, Index) then
    begin
      { Make sure any existing references are released }
      FList[Entry] := nil;
      Item := nil;
      { Install the new reference }
      FList[Entry] := Value;
      Break;
    end;
    Item := nil;
  end;
end;

procedure TVRWRegionList.Sort;
var
  i, j: Integer;
begin
  { Simple bubble-sort, based on the region index numbers }
  for i := FList.Count - 1 downto 0 do
  begin
    for j := 0 to FList.Count - 2 do
    begin
      if ((FList[j] as IVRWRegion).rgIndexNumber >
          (FList[j + 1] as IVRWRegion).rgIndexNumber) then
        FList.Exchange(j, j + 1);
    end;
  end;
end;

{ TVRWReport }

procedure TVRWReport.Clear;
begin
  FvrControls.Clear;
  FvrRegions.Clear;
  FvrVersion          := '';
  FvrFilename         := '';
  FvrName             := '';
  FvrDescription      := '';
  FvrPaperOrientation := 0;
  FvrIsWizardBased    := False;
end;

constructor TVRWReport.Create(Manager: IRepEngineManager);
begin
  inherited Create;
  FvrRegions  := TVRWRegionList.Create;
  FvrControls := TVRWControlList.Create;
  FvrInputFields := TVRWInputFieldList.Create;
  FvrPrintMethodParams := TVRWPrintMethodParams.Create;
  FvrTestModeParams := TVRWTestModeParams.Create;
  FParser := TReportWriterEngine.Create;
  FvrFont       := TFont.Create;
  FvrFont.Name  := 'Arial';
  FvrFont.Size  := 9;
  FvrFont.Color := clWindowText;
  FvrFont.Style := [];
  FFontIntf     := TVRWFont.Create(FvrFont);
  FvrRangeFilter := TVRWRangeFilter.Create;
  FvrPaperSizes := TVRWPaperSizes.Create;
  FvrPaperSizes.ReadAll;
  FvrPaperCode  := 'A4';
  FClipboardManager := TVRWClipboardManager.Create;
  FRepEngineManager := Manager;
end;

function TVRWReport.CreateUniqueControlName(
  ControlType: TControlType): ShortString;
var
  BaseName: ShortString;
  BaseExtension: SmallInt;
begin
  { Create a base name, using the control type }
  case ControlType of
    ctText:    BaseName := 'Text ';
    ctImage:   BaseName := 'Image ';
    ctLine:    BaseName := 'Line ';
    ctBox:     BaseName := 'Box ';
    ctField:   BaseName := 'Field ';
    ctFormula: BaseName := 'Formula ';
  end;
  { Create a full name by adding a numeric extension to the base name,
    incrementing the extension until we find a name which is not currently in
    use }
  BaseExtension := 0;
  repeat
    BaseExtension := BaseExtension + 1;
    Result := BaseName + IntToStr(BaseExtension);
  until (FvrControls[Result] = nil);
end;

destructor TVRWReport.Destroy;
begin
  FvrPaperSizes := nil;
  FClipboardManager := nil;
  FParser.Free;
  FvrRangeFilter := nil;
  FvrPrintMethodParams := nil;
  FvrInputFields := nil;
  FvrControls := nil;
  FvrRegions  := nil;
  FRepEngineManager := nil;
  inherited;
end;

function TVRWReport.FindFieldControl(FieldName: string): IVRWFieldControl;
var
  Entry: Integer;
begin
  Result := nil;
  for Entry := 0 to FvrControls.clCount - 1 do
  begin
    if Supports(FvrControls.clItems[Entry], IVRWFieldControl) then
    begin
      Result := FvrControls.clItems[Entry] as IVRWFieldControl;
      if Uppercase(Trim(Result.vcFieldName)) = Uppercase(Trim(FieldName)) then
        Break;
      Result := nil;
    end;
  end;
end;

function TVRWReport.FindFormulaControl(FormulaName: string): IVRWFormulaControl;
{ Searches for the formula control which contains the specified formula, and
  returns a reference to the control. Returns nil if it cannot be found. }
var
  Entry: Integer;
begin
  Result := nil;
  for Entry := 0 to FvrControls.clCount - 1 do
  begin
    if Supports(FvrControls.clItems[Entry], IVRWFormulaControl) then
    begin
      Result := FvrControls.clItems[Entry] as IVRWFormulaControl;
      if Uppercase(Result.vcFormulaName) = Uppercase(FormulaName) then
        Break;
      Result := nil;
    end;
  end;
end;

function TVRWReport.GetVrControls: IVRWControlList;
begin
  Result := FvrControls;
end;

function TVRWReport.GetVrDescription: ShortString;
begin
  Result := FvrDescription;
end;

function TVRWReport.GetVrFilename: ShortString;
begin
  Result := FvrFilename;
end;

function TVRWReport.GetVrFont: IVRWFont;
begin
  Result := FFontIntf;//FvcFont;
end;

function TVRWReport.GetVrIndexID: Byte;
begin
  Result := FvrIndexID;
end;

function TVRWReport.GetVrIsWizardBased: Boolean;
begin
  Result := FvrIsWizardBased;
end;

{
function TVRWReport.GetVrKeyPath: Integer;
begin
  Result := FvrKeyPath;
end;
}

function TVRWReport.GetVrMainFile: ShortString;
begin
  Result := FvrMainFile;
end;

function TVRWReport.GetVrMainFileNum: Byte;
begin
  Result := FvrMainFileNum;
end;

function TVRWReport.GetVrName: ShortString;
begin
  Result := FvrName;
end;

function TVRWReport.GetVrOnFirstPass: TOnCheckRecordProc;
begin
  Result := FvrOnFirstPass;
end;

function TVRWReport.GetVrOnPrintRecord: TOnCheckRecordProc;
begin
  Result := FvrOnPrintRecord;
end;

function TVRWReport.GetVrOnSecondPass: TOnCheckRecordProc;
begin
  Result := FvrOnSecondPass;
end;

function TVRWReport.GetVrPaperOrientation: Byte;
begin
  Result := FvrPaperOrientation;
end;

function TVRWReport.GetVrPaperSizes: IVRWPaperSizes;
begin
  Result := FvrPaperSizes;
end;

function TVRWReport.GetVrPrintMethodParams: IVRWPrintMethodParams;
begin
  Result := FvrPrintMethodParams;
end;

function TVRWReport.GetVrRangeFilter: IVRWRangeFilter;
begin
  Result := FvrRangeFilter;
{
  Result := TVRWRangeFilter.Create;
  with ReportConstructInfo.IndexInput do
  begin
    Result.rfName        := ssName;
    Result.rfDescription := ssDescription;
    Result.rfType        := siType;
    Result.rfAlwaysAsk   := bAlwaysAsk;
    Result.rfFromValue   := ssFromValue;
    Result.rfToValue     := ssToValue;
  end;
}
end;

function TVRWReport.GetVrRegions: IVRWRegionList;
begin
  Result := FvrRegions;
end;

function TVRWReport.GetVrVersion: ShortString;
begin
  Result := FvrVersion;
end;

function TVRWReport.ParserCallBack(const ValueIdentifier,
  ValueName: string; var ErrorCode: SmallInt; var ErrorString : ShortString;
  var ErrorWord : ShortString): ResultValueType;

  function ExtractTotalName(FromString: string): string;
  var
    CharStart, CharEnd: Integer;
  begin
    Result := '';
    FromString := Trim(Uppercase(ValueName));
    { Check for DBF indentifier }
    CharStart := Pos('DBF', FromString);
    { If no DBF identifier is found, look for an FML (formula) identifier
      instead }
    if (CharStart = 0) then
      CharStart := Pos('FML', FromString);
    { If an identifier was found... }
    if (CharStart > 0) then
    begin
      { ...extract the name from inside the square brackets }
      Result := Copy(FromString, CharStart + 4, Length(FromString));
      CharEnd := Pos(']', Result);
      if (CharEnd = 0) then
        CharEnd := Length(FromString) + 1;
      Result := Copy(Result, 1, CharEnd - 1);
    end;
  end;

var
  TotalName: string;
  Entry: Integer;
  Control: IVRWControl;
  Found: Boolean;
begin
  Result.StrResult := '';
  Result.DblResult := 0.00;
  if (Uppercase(ValueIdentifier) = 'TOTALFIELD') then
  begin
    { Retrieve the total from the Totals handler }
    TotalName := Trim(ExtractTotalName(ValueName));
    if (TotalName <> '') then
    begin
      { Make sure that the report includes a formula or a database field
        against this name }
      if FindFieldControl(TotalName) = nil then
      begin
        { Field not found. Look for formula instead. }
        if FindFormulaControl(TotalName) = nil then
        begin
          ErrorCode := 2; // Bad field
          ErrorWord := TotalName;
          ErrorString := 'Field ' + TotalName + ' not found in report';
        end;
      end;
    end;
  end
  else if (Uppercase(ValueIdentifier) = 'DBF') then
  begin
    { Make sure that the report includes a database field against this name }
    if FindFieldControl(ValueName) = nil then
    begin
      ErrorCode := 2; // Bad field
      ErrorWord := ValueName;
      ErrorString := 'Field ' + ValueName + ' not found in report';
    end;
  end
  else if (Uppercase(ValueIdentifier) = 'FML') then
  begin
    { Make sure that the report includes a formula against this name }
    if FindFormulaControl(ValueName) = nil then
    begin
      ErrorCode := 2; // Bad field
      ErrorWord := ValueName;
      ErrorString := 'Formula ' + ValueName + ' not found in report';
    end;
  end;
end;

function TVRWReport.Print(const FileName: ShortString; ExternalCall: Boolean = False): Boolean;
var
  Generator: TVRWReportGenerator;
  Error: string;
begin
  Generator := TVRWReportGenerator.Create;
  try
    if (Trim(Filename) <> '') then
      Read(FileName);
    Generator.OnCheckRecord := FvrOnPrintRecord;
    Generator.OnFirstPass   := FvrOnFirstPass;
    Generator.OnSecondPass  := FvrOnSecondPass;
    Generator.UserID        := FvrUserID;

    if Generator.Print(self, ExternalCall) then
    begin
      Result := not Generator.Cancelled;
      FvrReportFileName := Generator.ReportFileName;
    end
    else
    begin
      Error := Generator.Error;
      Result := False;
    end;
    if (not Result) and (Trim(Error) <> '') then
      raise Exception.Create(Error);
//      ShowMessage(Error);
  finally
    Generator.Free;
  end;
end;

procedure TVRWReport.Read(const FileName: ShortString);
var
  ReportFile: IVRWReportFile;
  ReportFileName, ReportFilePath: string;
  Version: SmallInt;
begin
  { Create the correct ReportFile object for the file format }
  ReportFile := GetVRWReportFile(FileName, Version);
  if (ReportFile = nil) then
    raise EFOpenError.Create('Unsupported file version: ' + IntToStr(Version))
  else
  try
    { Set up the required ReportFile properties }
    SetVrFilename(FileName);
    { Get the path. If no path is included, use the existing datapath }
    ReportFilePath := ExtractFilePath(FileName);
    if (ReportFilePath = '') then
      ReportFilePath := FvrDataPath + 'REPORTS\';

    ReportFileName := ExtractFileName(FileName);
    
    ReportFile.Init(self, ReportFilePath, ReportFileName);
    { Read the report }
    ReportFile.Read;
    FvrRegions.Renumber;
  finally
    { Release the interface reference }
    ReportFile := nil;
  end;
end;

function TVRWReport.ArrayToOptionArray(
  BooleanArray: array of Boolean): TOptionArray;
var
  OptionPos: Integer;
  FromPos, ToPos: Integer;
begin
  FromPos := Low(BooleanArray);
  ToPos   := Low(Result);
  while (FromPos <= High(BooleanArray)) and (ToPos <= High(Result)) do
  begin
    Result[ToPos] := BooleanArray[FromPos];
    Inc(FromPos);
    Inc(ToPos);
  end;
end;

procedure TVRWReport.ReadPrintMethodParams(
  FromPrinterInfo: TSBSPrintSetupInfo);
var
  siOptIdx : SmallInt;
begin
  FvrPrintMethodParams.pmPrintMethod    := FromPrinterInfo.fePrintMethod;
  FvrPrintMethodParams.pmBatch          := FromPrinterInfo.feBatch;
  FvrPrintMethodParams.pmTypes          := FromPrinterInfo.feTypes;
  FvrPrintMethodParams.pmCoverSheet     := FromPrinterInfo.feCoverSheet;
  FvrPrintMethodParams.pmFaxMethod      := FromPrinterInfo.feFaxMethod;
  FvrPrintMethodParams.pmFaxPrinter     := FromPrinterInfo.feFaxPrinter;
  FvrPrintMethodParams.pmFaxFrom        := FromPrinterInfo.feFaxFrom;
  FvrPrintMethodParams.pmFaxFromNo      := FromPrinterInfo.feFaxFromNo;
  FvrPrintMethodParams.pmFaxTo          := FromPrinterInfo.feFaxTo;
  FvrPrintMethodParams.pmFaxToNo        := FromPrinterInfo.feFaxToNo;
  FvrPrintMethodParams.pmFaxMsg         := FromPrinterInfo.feFaxMsg;
  FvrPrintMethodParams.pmEmailMAPI      := FromPrinterInfo.feEmailMAPI;
  FvrPrintMethodParams.pmEmailFrom      := FromPrinterInfo.feEmailFrom;
  FvrPrintMethodParams.pmEmailFromAd    := FromPrinterInfo.feEmailFromAd;
  FvrPrintMethodParams.pmEmailTo        := FromPrinterInfo.feEmailTo;
  FvrPrintMethodParams.pmEmailToAddr    := FromPrinterInfo.feEmailToAddr;
  FvrPrintMethodParams.pmEmailCc        := FromPrinterInfo.feEmailCc;
  FvrPrintMethodParams.pmEmailBcc       := FromPrinterInfo.feEmailBcc;
  FvrPrintMethodParams.pmEmailSubj      := FromPrinterInfo.feEmailSubj;
  FvrPrintMethodParams.pmEmailMsg       := FromPrinterInfo.feEmailMsg;
  FvrPrintMethodParams.pmEmailAttach    := FromPrinterInfo.feEmailAttach;
  FvrPrintMethodParams.pmEmailPriority  := FromPrinterInfo.feEmailPriority;
  FvrPrintMethodParams.pmEmailReader    := FromPrinterInfo.feEmailReader;
  FvrPrintMethodParams.pmEmailZIP       := FromPrinterInfo.feEmailZIP;
  FvrPrintMethodParams.pmEmailAtType    := FromPrinterInfo.feEmailAtType;
  FvrPrintMethodParams.pmFaxPriority    := FromPrinterInfo.feFaxPriority;
  FvrPrintMethodParams.pmXMLType        := FromPrinterInfo.feXMLType;
  FvrPrintMethodParams.pmXMLCreateHTML  := FromPrinterInfo.feXMLCreateHTML;
  FvrPrintMethodParams.pmXMLFileDir     := FromPrinterInfo.feXMLFileDir;
  FvrPrintMethodParams.pmEmailFName     := FromPrinterInfo.feEmailFName;
  FvrPrintMethodParams.pmMiscOptions    := ArrayToOptionArray(FromPrinterInfo.feMiscOptions);
end;

procedure TVRWReport.RegisterControl(Control: IVRWControl);
begin
  FvrControls.Append(Control);
end;

procedure TVRWReport.SetVrDescription(const Value: ShortString);
begin
  FvrDescription := Value;
end;

procedure TVRWReport.SetVrFilename(const Value: ShortString);
begin
  FvrFilename := Value;
end;

procedure TVRWReport.SetVrIndexID(const Value: Byte);
begin
  FvrIndexID := Value;
end;

procedure TVRWReport.SetVrIsWizardBased(const Value: Boolean);
begin
  FvrIsWizardBased := Value;
end;

{
procedure TVRWReport.SetVrKeyPath(const Value: Integer);
begin
  FvrKeyPath := Value;
end;
}

procedure TVRWReport.SetVrMainFile(const Value: ShortString);
begin
  FvrMainFile := Value;
end;

procedure TVRWReport.SetVrMainFileNum(const Value: Byte);
begin
  FvrMainFileNum := Value;
end;

procedure TVRWReport.SetVrName(const Value: ShortString);
begin
  FvrName := Value;
end;

procedure TVRWReport.SetVrOnFirstPass(const Value: TOnCheckRecordProc);
begin
  FvrOnFirstPass := Value;
end;

procedure TVRWReport.SetVrOnPrintRecord(const Value: TOnCheckRecordProc);
begin
  FvrOnPrintRecord := Value;
end;

procedure TVRWReport.SetVrOnSecondPass(const Value: TOnCheckRecordProc);
begin
  FvrOnSecondPass := Value;
end;

procedure TVRWReport.SetVrPaperOrientation(const Value: Byte);
begin
  FvrPaperOrientation := Value;
end;

procedure TVRWReport.SetVrVersion(const Value: ShortString);
begin
  FvrVersion := Value;
end;

procedure TVRWReport.UnregisterControl(Control: IVRWControl);
begin
  FvrControls.Remove(Control);
end;

function TVRWReport.ValidateFormula(FormulaDefinition: string): string;
var
  ErrorCode: SmallInt;
const
  Identifiers: array[0..5] of string =
  (
    'TOTALFIELD',
    'COUNTFIELD',
    'INFO',
    'DBF',
    'FML',
    'INP'
  );
begin
  AddInputFieldsToParser;
  FParser.SetCustomIDs(Identifiers);
  FParser.GetCustomValue := ParserCallBack;
  ErrorCode := FParser.ValidateCalculation(FormulaDefinition);
//  FParser.CustomParse(FormulaDefinition, Identifiers, ParserCallback,
//    ErrorCode);
  if (ErrorCode <> 0) then
  begin
    Result := 'Error ' + IntToStr(ErrorCode) + ': ' +
              FParser.ValidationErrorString;
  end;
end;

procedure TVRWReport.Write(WithCompression: Boolean);
var
  ReportFile: IVRWReportFile;
  ReportFileName, ReportFilePath: string;
  Version: SmallInt;
begin
  { Create the correct ReportFile object for the file format. }
  Version := 2;
  ReportFile := GetVRWReportFileWriter(Version);
  if (ReportFile = nil) then
    ShowMessage('Unsupported file version: ' + IntToStr(Version))
  else
  try
    { Set up the required ReportFile properties }
    ReportFilePath := ExtractFilePath(GetVrFileName);
    ReportFileName := ExtractFileName(GetVrFileName);
    ReportFile.Init(self, ReportFilePath, ReportFileName);
    { Write the report }
    ReportFile.Write(WithCompression);
  finally
    { Release the interface reference }
    ReportFile := nil;
  end;
end;

procedure TVRWReport.WritePrintMethodParams(
  var ToPrinterInfo: TSBSPrintSetupInfo);
var
  siOptIdx : SmallInt;
begin
  ToPrinterInfo.fePrintMethod   := FvrPrintMethodParams.pmPrintMethod;
  ToPrinterInfo.feBatch         := FvrPrintMethodParams.pmBatch;
  ToPrinterInfo.feTypes         := FvrPrintMethodParams.pmTypes;
  ToPrinterInfo.feCoverSheet    := FvrPrintMethodParams.pmCoverSheet;
  ToPrinterInfo.feFaxMethod     := FvrPrintMethodParams.pmFaxMethod;
  ToPrinterInfo.feFaxPrinter    := FvrPrintMethodParams.pmFaxPrinter;
  ToPrinterInfo.feFaxFrom       := FvrPrintMethodParams.pmFaxFrom;
  ToPrinterInfo.feFaxFromNo     := FvrPrintMethodParams.pmFaxFromNo;
  ToPrinterInfo.feFaxTo         := FvrPrintMethodParams.pmFaxTo;
  ToPrinterInfo.feFaxToNo       := FvrPrintMethodParams.pmFaxToNo;
  ToPrinterInfo.feFaxMsg        := FvrPrintMethodParams.pmFaxMsg;
  ToPrinterInfo.feEmailMAPI     := FvrPrintMethodParams.pmEmailMAPI;
  ToPrinterInfo.feEmailFrom     := FvrPrintMethodParams.pmEmailFrom;
  ToPrinterInfo.feEmailFromAd   := FvrPrintMethodParams.pmEmailFromAd;
  ToPrinterInfo.feEmailTo       := FvrPrintMethodParams.pmEmailTo;
  ToPrinterInfo.feEmailToAddr   := FvrPrintMethodParams.pmEmailToAddr;
  ToPrinterInfo.feEmailCc       := FvrPrintMethodParams.pmEmailCc;
  ToPrinterInfo.feEmailBcc      := FvrPrintMethodParams.pmEmailBcc;
  ToPrinterInfo.feEmailSubj     := FvrPrintMethodParams.pmEmailSubj;
  ToPrinterInfo.feEmailMsg      := FvrPrintMethodParams.pmEmailMsg;
  ToPrinterInfo.feEmailAttach   := FvrPrintMethodParams.pmEmailAttach;
  ToPrinterInfo.feEmailPriority := FvrPrintMethodParams.pmEmailPriority;
  ToPrinterInfo.feEmailReader   := FvrPrintMethodParams.pmEmailReader;
  ToPrinterInfo.feEmailZIP      := FvrPrintMethodParams.pmEmailZIP;
  ToPrinterInfo.feEmailAtType   := FvrPrintMethodParams.pmEmailAtType;
  ToPrinterInfo.feFaxPriority   := FvrPrintMethodParams.pmFaxPriority;
  ToPrinterInfo.feXMLType       := FvrPrintMethodParams.pmXMLType;
  ToPrinterInfo.feXMLCreateHTML := FvrPrintMethodParams.pmXMLCreateHTML;
  ToPrinterInfo.feXMLFileDir    := FvrPrintMethodParams.pmXMLFileDir;
  ToPrinterInfo.feEmailFName    := FvrPrintMethodParams.pmEmailFName;
  for siOptIdx := Low(ToPrinterInfo.feMiscOptions) to High(ToPrinterInfo.feMiscOptions) do
    ToPrinterInfo.feMiscOptions[siOptIdx] := FvrPrintMethodParams.pmMiscOptions[siOptidx];
end;

function TVRWReport.GetVrTestModeParams: IVRWTestModeParams;
begin
  Result := FvrTestModeParams;
end;

procedure TVRWReport.ClearClipboard;
begin
  FClipboardManager.ClearClipboard;
end;

procedure TVRWReport.CommitClipboard;
begin
  FClipboardManager.CommitClipboard;
end;

procedure TVRWReport.CopyToClipboard(Control: IVRWControl);
begin
  FClipboardManager.CopyToClipboard(Control);
end;

procedure TVRWReport.PasteFromClipboard(Report: IVRWReport;
  IntoRegion: IVRWRegion; OnPaste: TVRWOnPasteControl);
begin
  FClipboardManager.PasteFromClipboard(Report, IntoRegion, OnPaste);
end;

function TVRWReport.ValidateSelectionCriteria(
  SelectionCriteria: string): string;
var
  ErrorCode: SmallInt;
const
  Identifiers: array[0..5] of string =
  (
    'TOTALFIELD',
    'COUNTFIELD',
    'INFO',
    'DBF',
    'FML',
    'INP'
  );
begin
  AddInputFieldsToParser;
  FParser.SetCustomIDs(Identifiers);
  FParser.GetCustomValue := ParserCallBack;
  if FParser.ValidateFilter(SelectionCriteria) <> 0 then
    Result := FParser.ValidationErrorString
  else
    Result := '';
end;

function TVRWReport.CanPaste: Boolean;
begin
  Result := FClipboardManager.CanPaste;
end;

function TVRWReport.GetVrPaperCode: ShortString;
begin
  Result := FvrPaperCode;
end;

procedure TVRWReport.SetVrPaperCode(const Value: ShortString);
begin
  FvrPaperCode := Value;
end;

function TVRWReport.GetVrReportFileName: ShortString;
begin
  Result := FvrReportFileName;
end;

function TVRWReport.GetVrDataPath: ShortString;
begin
  Result := FvrDataPath;
end;

procedure TVRWReport.SetVrDataPath(const Value: ShortString);
begin
  FvrDataPath := IncludeTrailingPathDelimiter(Value);
  if not SameText(Trim(FRepEngineManager.DataDirectory), Trim(FvrDataPath)) then
    FRepEngineManager.DataDirectory := FvrDataPath;
end;

function TVRWReport.CreateUniqueFormulaName: ShortString;
var
  BaseName: ShortString;
  BaseExtension: SmallInt;
begin
  { Create a base name }
  BaseName := 'Formula';
  { Create a full name by adding a numeric extension to the base name,
    incrementing the extension until we find a name which is not currently in
    use }
  BaseExtension := 0;
  repeat
    BaseExtension := BaseExtension + 1;
    Result := BaseName + IntToStr(BaseExtension);
  until (FindFormulaControl(Result) = nil);
end;

procedure TVRWReport.UpdateFormulaReferences(const OldName,
  NewName: ShortString);
var
  ControlNo: Integer;
  FmlControl: IVRWFormulaControl;
  StdControl: IVRWControl;
  DbfControl: IVRWFieldControl;
  SearchFor, ReplaceWith, Definition: ShortString;
  StartPos: Integer;
begin
  SearchFor := 'FML[' + UpperCase(OldName) + ']';
  ReplaceWith := 'FML[' + NewName + ']';
  for ControlNo := 0 to FvrControls.clCount - 1 do
  begin
    { Update formulae }
    if Supports(FvrControls.clItems[ControlNo], IVRWFormulaControl) then
    begin
      FmlControl := FvrControls.clItems[ControlNo] as IVRWFormulaControl;
      try
        Definition := FmlControl.vcFormulaDefinition;
        Definition := StringReplace(Definition, SearchFor, ReplaceWith, [rfReplaceAll, rfIgnoreCase]);
        FmlControl.vcFormulaDefinition := Definition;
      finally
        FmlControl := nil;
      end;
    end;
    { Update Selection Criteria }
    if Supports(FvrControls.clItems[ControlNo], IVRWFieldControl) then
    begin
      DbfControl := FvrControls.clItems[ControlNo] as IVRWFieldControl;
      try
        Definition := DbfControl.vcSelectCriteria;
        Definition := StringReplace(Definition, SearchFor, ReplaceWith, [rfReplaceAll, rfIgnoreCase]);
        DbfControl.vcSelectCriteria := Definition;
      finally
        DbfControl := nil;
      end;
    end;
    { Update PrintIf statements }
    if Supports(FvrControls.clItems[ControlNo], IVRWControl) then
    begin
      StdControl := FvrControls.clItems[ControlNo] as IVRWControl;
      try
        Definition := StdControl.vcPrintIf;
        Definition := StringReplace(Definition, SearchFor, ReplaceWith, [rfReplaceAll, rfIgnoreCase]);
        StdControl.vcPrintIf := Definition;
      finally
        StdControl := nil;
      end;
    end;
  end;
end;

function TVRWReport.CheckSecurity(ForUser: ShortString): Boolean;
{ For use by the Tools menu }
var
  ReportData: IVRWReportData;
  Desc: ShortString;
begin
  ReportData := FRepEngineManager.VRWReportData;
  ReportData.UserID := ForUser;
  Result := ReportData.CanPrint(FvrName, Desc, FvrFileName, True);
  if not Result then
    ShowMessage('You do not have sufficient rights for this report');
end;

function TVRWReport.GetVrUserID: ShortString;
begin
  Result := FvrUserID;
end;

procedure TVRWReport.SetVrUserID(const Value: ShortString);
begin
  FvrUserID := Value;
end;

function TVRWReport.GetVrInputFields: IVRWInputFieldList;
begin
  Result := FvrInputFields;
end;

procedure TVRWReport.AddInputFieldsToParser;
var
  i: Integer;
begin
   FParser.ClearInputs;
  for i := 0 to self.FvrInputFields.rfCount - 1 do
    with FParser.AddInput do
    begin
      Name := self.FvrInputFields.rfItems[i].rfName;
      InputType := self.FvrInputFields.rfItems[i].rfType;
      StringFrom := self.FvrInputFields.rfItems[i].rfFromValue;
      StringTo := self.FvrInputFields.rfItems[i].rfToValue;
      if (InputType = 1) then // Date
      begin
        { Dates are stored in DDMMYYYY format, but need to be in YYYYMMDD for the
          validation routines. }
        If (Length(StringFrom) = 8) Then
          StringFrom := Copy(StringFrom, 5, 4) + Copy(StringFrom, 3, 2) + Copy(StringFrom, 1, 2);
        If (Length(StringTo) = 8) Then
          StringTo := Copy(StringTo, 5, 4) + Copy(StringTo, 3, 2) + Copy(StringTo, 1, 2);
      end;
    end;
end;

{ TVRWFormulaControl }

constructor TVRWFormulaControl.Create;
begin
  inherited Create;
  Properties.FvcPrintField    := True;
  Properties.FvcFieldFormat   := 'R';
  Properties.FvcDecimalPlaces := 2;
end;

function TVRWFormulaControl.GetVcComments: ShortString;
begin
  Result := Properties.FvcComments;
end;

function TVRWFormulaControl.GetVcCurrency: Byte;
begin
  Result := Properties.FvcCurrency;
end;

function TVRWFormulaControl.GetVcDecimalPlaces: Byte;
begin
  Result := Properties.FvcDecimalPlaces;
end;

function TVRWFormulaControl.GetVcFieldIdx: SmallInt;
begin
  Result := Properties.FvcFieldIdx;
end;

function TVRWFormulaControl.GetVcFormulaDefinition: ShortString;
begin
  Result := Properties.FvcFormulaDefinition;
end;

function TVRWFormulaControl.GetVcFormulaName: ShortString;
begin
  Result := Properties.FvcFormulaName;
end;

function TVRWFormulaControl.GetVcPageBreak: Boolean;
begin
  Result := Properties.FvcPageBreak;
end;

function TVRWFormulaControl.GetVcPeriod: ShortString;
begin
  Result := Properties.FvcPeriod;
end;

function TVRWFormulaControl.GetVcPrintField: Boolean;
begin
  Result := Properties.FvcPrintField;
end;

function TVRWFormulaControl.GetVcSortOrder: ShortString;
begin
  Result := Properties.FvcSortOrder;
end;

function TVRWFormulaControl.GetVcTotalType: TTotalType;
begin
  Result := Properties.FvcTotalType;
end;

function TVRWFormulaControl.GetVcYear: ShortString;
begin
  Result := Properties.FvcYear;
end;

procedure TVRWFormulaControl.SetVcComments(const Value: ShortString);
begin
  Properties.FvcComments := Value;
end;

procedure TVRWFormulaControl.SetVcCurrency(const Value: Byte);
begin
  Properties.FvcCurrency := Value;
end;

procedure TVRWFormulaControl.SetVcDecimalPlaces(const Value: Byte);
begin
  Properties.FvcDecimalPlaces := Value;
end;

procedure TVRWFormulaControl.SetVcFieldIdx(const Value: SmallInt);
begin
  Properties.FvcFieldIdx := Value;
end;

procedure TVRWFormulaControl.SetVcFormulaDefinition(
  const Value: ShortString);
begin
  Properties.FvcFormulaDefinition := Value;
end;

procedure TVRWFormulaControl.SetVcFormulaName(const Value: ShortString);
begin
  Properties.FvcFormulaName := Value;
end;

procedure TVRWFormulaControl.SetVcPageBreak(const Value: Boolean);
begin
  Properties.FvcPageBreak := Value;
end;

procedure TVRWFormulaControl.SetVcPeriod(const Value: ShortString);
begin
  Properties.FvcPeriod := Value;
end;

procedure TVRWFormulaControl.SetVcPrintField(const Value: Boolean);
begin
  Properties.FvcPrintField := Value;
end;

procedure TVRWFormulaControl.SetVcSortOrder(const Value: ShortString);
begin
  Properties.FvcSortOrder := Value;
end;

procedure TVRWFormulaControl.SetVcTotalType(const Value: TTotalType);
begin
  Properties.FvcTotalType := Value;
end;

procedure TVRWFormulaControl.SetVcYear(const Value: ShortString);
begin
  Properties.FvcYear := Value;
end;

{ TVRWLineControl }

constructor TVRWLineControl.Create;
begin
  inherited Create;
  Properties.FvcLineOrientation := loHorizontal;
  Properties.FvcLineLength      := Properties.FvcWidth;
end;

function TVRWLineControl.GetVcLineLength: SmallInt;
begin
  Result := Properties.FvcLineLength;
end;

function TVRWLineControl.GetVcLineOrientation: TLineOrientation;
begin
  Result := Properties.FvcLineOrientation;
end;

function TVRWLineControl.GetVcPenColor: TColor;
begin
  Result := Properties.FvcPenColor;
end;

function TVRWLineControl.GetVcPenMode: Byte;
begin
  Result := Properties.FvcPenMode;
end;

function TVRWLineControl.GetVcPenStyle: Byte;
begin
  Result := Properties.FvcPenStyle;
end;

function TVRWLineControl.GetVcPenWidth: SmallInt;
begin
  Result := Properties.FvcPenWidth;
end;

procedure TVRWLineControl.SetVcLineLength(const Value: SmallInt);
begin
  Properties.FvcLineLength := Value;
end;

procedure TVRWLineControl.SetVcLineOrientation(
  const Value: TLineOrientation);
begin
  Properties.FvcLineOrientation := Value;
end;

procedure TVRWLineControl.SetVcPenColor(const Value: TColor);
begin
  Properties.FvcPenColor := Value;
end;

procedure TVRWLineControl.SetVcPenMode(const Value: Byte);
begin
  Properties.FvcPenMode := Value;
end;

procedure TVRWLineControl.SetVcPenStyle(const Value: Byte);
begin
  Properties.FvcPenStyle := Value;
end;

procedure TVRWLineControl.SetVcPenWidth(const Value: SmallInt);
begin
  Properties.FvcPenWidth := Value;
end;

{ TVRWImageControl }

constructor TVRWImageControl.Create;
begin
  inherited Create;
  FvcImage := TImage.Create(nil);
  FvcImage.AutoSize := True;
  FvcImageStream := TMemoryStream.Create;
  FvcBMPStore := TRawBMPStore.Create;
  FvcBMPIndex := 0;
end;

destructor TVRWImageControl.Destroy;
begin
  FreeAndNil(FvcImage);
  FreeAndNil(FvcImageStream);
  FreeAndNil(FvcBMPStore);
  inherited;
end;

function TVRWImageControl.GetVcBMPIndex: Integer;
begin
  Result := FvcBMPIndex;
end;

function TVRWImageControl.GetVcBMPStore: TRawBMPStore;
begin
  Result := FvcBMPStore;
end;

function TVRWImageControl.GetVcFolio: ShortString;
begin
  Result := Properties.FvcFolio;
end;

function TVRWImageControl.GetVcImage: TImage;
begin
  Result := FvcImage;
end;

function TVRWImageControl.GetVcImageStream: TMemoryStream;
begin
  Result := FvcImageStream;
end;

procedure TVRWImageControl.LoadImage(const Filename: string);
begin
  // MH 06/02/2017 ABSEXCH-14925 2017-R1: Added support for extra image types
  LoadImageFromFile (Filename, FvcImage.Picture.Bitmap);

  FvcImageStream.Clear;
  FvcImage.Picture.Bitmap.SaveToStream(FvcImageStream);
  ReadImageBuffer;
end;

procedure TVRWImageControl.ReadImageBuffer;
var
  BMPSize: Integer;
begin
  BMPSize := FvcImageStream.Size;
  FvcImageStream.Position := 0;
  if (BMPSize > 0) then
  begin
    FvcBMPStore.iBMPSize := BMPSize;
    GetMem(FvcBMPStore.pBMP, BMPSize);
    FvcBMPStore.iBMPSize := BMPSize;
    try
      { Copy the image data from the stream into the BMP Store. Routines
        outside the DLL can use the BMP store to get the image data (the image
        data cannot be retrieved directly from the vcImage object, because any
        attempt to access the vcImage bitmap from outside the DLL results in
        the bitmap being cleared, for unknown reasons). }
      FvcImageStream.ReadBuffer(FvcBMPStore.pBMP^, BMPSize);
    except

    end;
  end;
  FvcImageStream.Position := 0;
end;

procedure TVRWImageControl.SetVcBMPIndex(const Value: Integer);
begin
  FvcBMPIndex := Value;
end;

procedure TVRWImageControl.SetVcFolio(const Value: ShortString);
begin
  Properties.FvcFolio := Value;
end;

{ TVRWFieldControl }

constructor TVRWFieldControl.Create;
begin
  inherited Create;
  FvcRangeFilter := TVRWRangeFilter.Create;
  FvcInputLine   := TVRWInputField.Create;
  Properties.FvcPrintField  := True;
end;

destructor TVRWFieldControl.Destroy;
begin
  FvcRangeFilter := nil;
  inherited;
end;

function TVRWFieldControl.GetVcCurrency: Byte;
begin
  Result := Properties.FvcCurrency;
end;

function TVRWFieldControl.GetVcFieldIdx: SmallInt;
begin
  Result := Properties.FvcFieldIdx;
end;

function TVRWFieldControl.GetVcFieldName: ShortString;
begin
  Result := Properties.FvcFieldName;
end;

function TVRWFieldControl.GetVcInputLine: IVRWInputField;
begin
  Result := FvcInputLine;
end;

function TVRWFieldControl.GetVcPageBreak: Boolean;
begin
  Result := Properties.FvcPageBreak;
end;

function TVRWFieldControl.GetVcParsedInputLine: ShortString;
begin
  Result := Properties.FvcParsedInputLine;
end;

function TVRWFieldControl.GetVcPeriod: ShortString;
begin
  Result := Properties.FvcPeriod;
end;

function TVRWFieldControl.GetVcPeriodField: Boolean;
begin
  Result := Properties.FvcPeriodField;
end;

function TVRWFieldControl.GetVcPrintField: Boolean;
begin
  Result := Properties.FvcPrintField;
end;

function TVRWFieldControl.GetVcRangeFilter: IVRWRangeFilter;
begin
  Result := FvcRangeFilter;
end;

function TVRWFieldControl.GetVcRecalcBreak: Boolean;
begin
  Result := Properties.FvcRecalcBreak;
end;

function TVRWFieldControl.GetVcSelectCriteria: ShortString;
begin
  Result := Properties.FvcSelectCriteria;
end;

function TVRWFieldControl.GetVcSelectSummary: Boolean;
begin
  Result := Properties.FvcSelectSummary;
end;

function TVRWFieldControl.GetVcSortOrder: ShortString;
begin
  Result := Properties.FvcSortOrder;
end;

function TVRWFieldControl.GetVcSubTotal: Boolean;
begin
  Result := Properties.FvcSubTotal;
end;

function TVRWFieldControl.GetVcVarDesc: ShortString;
begin
  Result := Properties.FvcVarDesc;
end;

function TVRWFieldControl.GetVcVarLen: Byte;
begin
  Result := Properties.FvcVarLen;
end;

function TVRWFieldControl.GetVcVarNo: LongInt;
begin
  Result := Properties.FvcVarNo;
end;

function TVRWFieldControl.GetVcVarNoDecs: Byte;
begin
  Result := Properties.FvcVarNoDecs;
end;

function TVRWFieldControl.GetVcVarType: Byte;
begin
  Result := Properties.FvcVarType;
end;

function TVRWFieldControl.GetVcYear: ShortString;
begin
  Result := Properties.FvcYear;
end;

procedure TVRWFieldControl.SetVcCurrency(const Value: Byte);
begin
  Properties.FvcCurrency := Value;
end;

procedure TVRWFieldControl.SetVcFieldIdx(const Value: SmallInt);
begin
  Properties.FvcFieldIdx := Value;
end;

procedure TVRWFieldControl.SetVcFieldName(const Value: ShortString);
begin
  Properties.FvcFieldName := Value;
end;

procedure TVRWFieldControl.SetVcInputLine(const Value: IVRWInputField);
begin
  FvcInputLine := Value;
end;

procedure TVRWFieldControl.SetVcPageBreak(const Value: Boolean);
begin
  Properties.FvcPageBreak := Value;
end;

procedure TVRWFieldControl.SetVcParsedInputLine(const Value: ShortString);
begin
  Properties.FvcParsedInputLine := Value;
end;

procedure TVRWFieldControl.SetVcPeriod(const Value: ShortString);
begin
  Properties.FvcPeriod := Value;
end;

procedure TVRWFieldControl.SetVcPeriodField(const Value: Boolean);
begin
  Properties.FvcPeriodField := Value;
end;

procedure TVRWFieldControl.SetVcPrintField(const Value: Boolean);
begin
  Properties.FvcPrintField := Value;
end;

procedure TVRWFieldControl.SetVcRecalcBreak(const Value: Boolean);
begin
  Properties.FvcRecalcBreak := Value;
end;

procedure TVRWFieldControl.SetVcSelectCriteria(const Value: ShortString);
begin
  Properties.FvcSelectCriteria := Value;
end;

procedure TVRWFieldControl.SetVcSelectSummary(const Value: Boolean);
begin
  Properties.FvcSelectSummary := Value;
end;

procedure TVRWFieldControl.SetVcSortOrder(const Value: ShortString);
begin
  Properties.FvcSortOrder := Value;
end;

procedure TVRWFieldControl.SetVcSubTotal(const Value: Boolean);
begin
  Properties.FvcSubTotal := Value;
end;

procedure TVRWFieldControl.SetVcVarDesc(const Value: ShortString);
begin
  Properties.FvcVarDesc := Value;
end;

procedure TVRWFieldControl.SetVcVarLen(const Value: Byte);
begin
  Properties.FvcVarLen := Value;
end;

procedure TVRWFieldControl.SetVcVarNo(const Value: LongInt);
begin
  Properties.FvcVarNo := Value;
end;

procedure TVRWFieldControl.SetVcVarNoDecs(const Value: Byte);
begin
  Properties.FvcVarNoDecs := Value;
end;

procedure TVRWFieldControl.SetVcVarType(const Value: Byte);
begin
  Properties.FvcVarType := Value;
end;

procedure TVRWFieldControl.SetVcYear(const Value: ShortString);
begin
  Properties.FvcYear := Value;
end;

{ TVRWRangeFilter }

function TVRWRangeFilter.GetRangeString(
  RangeData: ShortString): ShortString;
begin
  // Can't use trim as currencies are stored as binary
  If (Length(RangeData) > 0) Then
  Begin
    Case FrfType Of
      // Date - DDMMYYYY
      1  : Begin
             Result := POutDate(Copy(RangeData, 5, 4) + Copy (RangeData, 3, 2) + Copy (RangeData, 1, 2));

           End; // Date

      // Period - MMYYYY
      2  : Begin
             Result := Copy(RangeData, 1, 2) + '/' + Copy (RangeData, 3, 4);
           End; // Period

      // Currency
      5  : With SyssCurr^.Currencies[Ord(RangeData[1])] Do
             Result := SSymb + ' - ' + Desc;
    Else
      Result := RangeData;
    End; // Case FRangeFilter.rfType
  End // If (Trim(RangeData) <> '')
  Else
    // MH 18/04/05: Added Else as was getting corrupted output with blank values
    Result := '';
end;

function TVRWRangeFilter.GetRfAlwaysAsk: Boolean;
begin
  Result := FrfAlwaysAsk;
end;

function TVRWRangeFilter.GetRfDescription: ShortString;
begin
  Result := FrfDescription;
end;

function TVRWRangeFilter.GetRfFromValue: ShortString;
begin
  Result := FrfFromValue;
end;

function TVRWRangeFilter.GetRfName: ShortString;
begin
  Result := FrfName;
end;

function TVRWRangeFilter.GetRfToValue: ShortString;
begin
  Result := FrfToValue;
end;

function TVRWRangeFilter.GetRfType: SmallInt;
begin
  Result := FrfType;
end;

procedure TVRWRangeFilter.SetRfAlwaysAsk(const Value: Boolean);
begin
  FrfAlwaysAsk := Value;
end;

procedure TVRWRangeFilter.SetRfDescription(const Value: ShortString);
begin
  FrfDescription := Value;
end;

procedure TVRWRangeFilter.SetRfFromValue(const Value: ShortString);
begin
  FrfFromValue := Value;
end;

procedure TVRWRangeFilter.SetRfName(const Value: ShortString);
begin
  FrfName := Value;
end;

procedure TVRWRangeFilter.SetRfToValue(const Value: ShortString);
begin
  FrfToValue := Value;
end;

procedure TVRWRangeFilter.SetRfType(const Value: SmallInt);
begin
  FrfType := Value;
end;

{ TVRWInputField }

function TVRWInputField.GetRangeString(
  RangeData: ShortString): ShortString;
begin
  // Can't use trim as currencies are stored as binary
  If (Length(RangeData) > 0) Then
  Begin
    Case FrfType Of
      // Date - DDMMYYYY
      1  : Begin
             Result := POutDate(Copy(RangeData, 5, 4) + Copy (RangeData, 3, 2) + Copy (RangeData, 1, 2));

           End; // Date

      // Period - MMYYYY
      2  : Begin
             Result := Copy(RangeData, 1, 2) + '/' + Copy (RangeData, 3, 4);
           End; // Period

      // Currency
      5  : With SyssCurr^.Currencies[Ord(RangeData[1])] Do
             Result := SSymb + ' - ' + Desc;
    Else
      Result := RangeData;
    End; // Case FrfType
  End // If (Trim(RangeData) <> '')
  Else
    // MH 18/04/05: Added Else as was getting corrupted output with blank values
    Result := '';
end;

function TVRWInputField.GetRfAlwaysAsk: Boolean;
begin
  Result := FrfAlwaysAsk;
end;

function TVRWInputField.GetRfDescription: ShortString;
begin
  Result := FrfDescription;
end;

function TVRWInputField.GetRfFromValue: ShortString;
begin
  Result := FrfFromValue;
end;

function TVRWInputField.GetRfID: Integer;
begin
  Result := FrfID;
end;

function TVRWInputField.GetRfName: ShortString;
begin
  Result := FrfName;
end;

function TVRWInputField.GetRfToValue: ShortString;
begin
  Result := FrfToValue;
end;

function TVRWInputField.GetRfType: SmallInt;
begin
  Result := FrfType;
end;

procedure TVRWInputField.SetRfAlwaysAsk(const Value: Boolean);
begin
  FrfAlwaysAsk := Value;
end;

procedure TVRWInputField.SetRfDescription(const Value: ShortString);
begin
  FrfDescription := Value;
end;

procedure TVRWInputField.SetRfFromValue(const Value: ShortString);
begin
  FrfFromValue := Value;
end;

procedure TVRWInputField.SetRfID(const Value: Integer);
begin
  FrfID := Value;
end;

procedure TVRWInputField.SetRfName(const Value: ShortString);
begin
  FrfName := Value;
end;

procedure TVRWInputField.SetRfToValue(const Value: ShortString);
begin
  FrfToValue := Value;
end;

procedure TVRWInputField.SetRfType(const Value: SmallInt);
begin
  FrfType := Value;
end;

{ TVRWBoxLine }

function TVRWBoxLine.GetvcLineColor: TColor;
begin
  Result := FvcLineColor;
end;

function TVRWBoxLine.GetvcLineStyle: TPenStyle;
begin
  Result := FvcLineStyle;
end;

function TVRWBoxLine.GetvcLineWidth: Byte;
begin
  Result := FvcLineWidth;
end;

procedure TVRWBoxLine.SetvcLineColor(const Value: TColor);
begin
  FvcLineColor := Value;
end;

procedure TVRWBoxLine.SetvcLineStyle(const Value: TPenStyle);
begin
  FvcLineStyle := Value;
end;

procedure TVRWBoxLine.SetvcLineWidth(const Value: Byte);
begin
  FvcLineWidth := Value;
end;

{ TVRWBoxControl }

constructor TVRWBoxControl.Create;
var
  i: TVRWBoxLineIndex;
begin
  inherited Create;
  for i := Low(TVRWBoxLineIndex) to High(TVRWBoxLineIndex) do
    FvcBoxLines[i] := TVRWBoxLine.Create;
end;

destructor TVRWBoxControl.Destroy;
var
  i: TVRWBoxLineIndex;
begin
  for i := Low(TVRWBoxLineIndex) to High(TVRWBoxLineIndex) do
    FvcBoxLines[i] := nil;
  inherited;
end;

function TVRWBoxControl.GetVcBoxLine(Index: TVRWBoxLineIndex): IVRWBoxLine;
begin
  Result := FvcBoxLines[Index];
end;

function TVRWBoxControl.GetVcFillColor: TColor;
begin
  Result := Properties.FvcFillColor;
end;

function TVRWBoxControl.GetVcFilled: Boolean;
begin
  Result := Properties.FvcFilled;
end;

procedure TVRWBoxControl.SetVcBoxLine(Index: TVRWBoxLineIndex;
  const Value: IVRWBoxLine);
begin
  FvcBoxLines[Index] := nil;
  FvcBoxLines[Index] := Value;
end;

procedure TVRWBoxControl.SetVcFillColor(const Value: TColor);
begin
  Properties.FvcFillColor := Value;
end;

procedure TVRWBoxControl.SetVcFilled(const Value: Boolean);
begin
  Properties.FvcFilled := Value;
end;

{ TVRWPrintMethodParams }

constructor TVRWPrintMethodParams.Create;
var
  siOptIdx: SmallInt;
begin
  inherited Create;
  for siOptIdx := Low(FpmMiscOptions) to High(FpmMiscOptions) do
    FpmMiscOptions[siOptIdx] := FALSE;
end;

function TVRWPrintMethodParams.GetpmBatch: Boolean;
begin
  Result := FpmBatch;
end;

function TVRWPrintMethodParams.GetpmCoverSheet: ShortString;
begin
  Result := FpmCoverSheet;
end;

function TVRWPrintMethodParams.GetpmEmailAttach: AnsiString;
begin
  Result := FpmEmailAttach;
end;

function TVRWPrintMethodParams.GetpmEmailAtType: Byte;
begin
  Result := FpmEmailAtType;
end;

function TVRWPrintMethodParams.GetpmEmailBcc: AnsiString;
begin
  Result := FpmEmailBcc;
end;

function TVRWPrintMethodParams.GetpmEmailCc: AnsiString;
begin
  Result := FpmEmailCc;
end;

function TVRWPrintMethodParams.GetpmEmailFName: ShortString;
begin
  Result := FpmEmailFName;
end;

function TVRWPrintMethodParams.GetpmEmailFrom: ShortString;
begin
  Result := FpmEmailFrom;
end;

function TVRWPrintMethodParams.GetpmEmailFromAd: ShortString;
begin
  Result := FpmEmailFromAd;
end;

function TVRWPrintMethodParams.GetpmEmailMAPI: Boolean;
begin
  Result := FpmEmailMAPI;
end;

function TVRWPrintMethodParams.GetpmEmailMsg: AnsiString;
begin
  Result := FpmEmailMsg;
end;

function TVRWPrintMethodParams.GetpmEmailPriority: Byte;
begin
  Result := FpmEmailPriority;
end;

function TVRWPrintMethodParams.GetpmEmailReader: Boolean;
begin
  Result := FpmEmailReader;
end;

function TVRWPrintMethodParams.GetpmEmailSubj: AnsiString;
begin
  Result := FpmEmailSubj;
end;

function TVRWPrintMethodParams.GetpmEmailTo: AnsiString;
begin
  Result := FpmEmailTo;
end;

function TVRWPrintMethodParams.GetpmEmailToAddr: AnsiString;
begin
  Result := FpmEmailToAddr;
end;

function TVRWPrintMethodParams.GetpmEmailZIP: Byte;
begin
  Result := FpmEmailZIP;
end;

function TVRWPrintMethodParams.GetpmFaxFrom: ShortString;
begin
  Result := FpmFaxFrom;
end;

function TVRWPrintMethodParams.GetpmFaxFromNo: ShortString;
begin
  Result := FpmFaxFromNo;
end;

function TVRWPrintMethodParams.GetpmFaxMethod: Byte;
begin
  Result := FpmFaxMethod;
end;

function TVRWPrintMethodParams.GetpmFaxMsg: AnsiString;
begin
  Result := FpmFaxMsg;
end;

function TVRWPrintMethodParams.GetpmFaxPrinter: SmallInt;
begin
  Result := FpmFaxPrinter;
end;

function TVRWPrintMethodParams.GetpmFaxPriority: Byte;
begin
  Result := FpmFaxPriority;
end;

function TVRWPrintMethodParams.GetpmFaxTo: ShortString;
begin
  Result := FpmFaxTo;
end;

function TVRWPrintMethodParams.GetpmFaxToNo: ShortString;
begin
  Result := FpmFaxToNo;
end;

function TVRWPrintMethodParams.GetpmMiscOptions: TOptionArray;
begin
  Result := FpmMiscOptions;
end;

function TVRWPrintMethodParams.GetpmPrintMethod: Byte;
begin
  Result := FpmPrintMethod;
end;

function TVRWPrintMethodParams.GetpmTypes: LongInt;
begin
  Result := FpmTypes;
end;

function TVRWPrintMethodParams.GetpmXMLCreateHTML: Boolean;
begin
  Result := FpmXMLCreateHTML;
end;

function TVRWPrintMethodParams.GetpmXMLFileDir: ANSIString;
begin
  Result := FpmXMLFileDir;
end;

function TVRWPrintMethodParams.GetpmXMLType: Byte;
begin
  Result := FpmXMLType;
end;

procedure TVRWPrintMethodParams.SetpmBatch(const Value: Boolean);
begin
  FpmBatch := Value;
end;

procedure TVRWPrintMethodParams.SetpmCoverSheet(const Value: ShortString);
begin
  FpmCoverSheet := Value;
end;

procedure TVRWPrintMethodParams.SetpmEmailAttach(const Value: AnsiString);
begin
  FpmEmailAttach := Value;
end;

procedure TVRWPrintMethodParams.SetpmEmailAtType(const Value: Byte);
begin
  FpmEmailAtType := Value;
end;

procedure TVRWPrintMethodParams.SetpmEmailBcc(const Value: AnsiString);
begin
  FpmEmailBcc := Value;
end;

procedure TVRWPrintMethodParams.SetpmEmailCc(const Value: AnsiString);
begin
  FpmEmailCc := Value;
end;

procedure TVRWPrintMethodParams.SetpmEmailFName(const Value: ShortString);
begin
  FpmEmailFName := Value;
end;

procedure TVRWPrintMethodParams.SetpmEmailFrom(const Value: ShortString);
begin
  FpmEmailFrom := Value;
end;

procedure TVRWPrintMethodParams.SetpmEmailFromAd(const Value: ShortString);
begin
  FpmEmailFromAd := Value;
end;

procedure TVRWPrintMethodParams.SetpmEmailMAPI(const Value: Boolean);
begin
  FpmEmailMAPI := Value;
end;

procedure TVRWPrintMethodParams.SetpmEmailMsg(const Value: AnsiString);
begin
  FpmEmailMsg := Value;
end;

procedure TVRWPrintMethodParams.SetpmEmailPriority(const Value: Byte);
begin
  FpmEmailPriority := Value;
end;

procedure TVRWPrintMethodParams.SetpmEmailReader(const Value: Boolean);
begin
  FpmEmailReader := Value;
end;

procedure TVRWPrintMethodParams.SetpmEmailSubj(const Value: AnsiString);
begin
  FpmEmailSubj := Value;
end;

procedure TVRWPrintMethodParams.SetpmEmailTo(const Value: AnsiString);
begin
  FpmEmailTo := Value;
end;

procedure TVRWPrintMethodParams.SetpmEmailToAddr(const Value: AnsiString);
begin
  FpmEmailToAddr := Value;
end;

procedure TVRWPrintMethodParams.SetpmEmailZIP(const Value: Byte);
begin
  FpmEmailZIP := Value;
end;

procedure TVRWPrintMethodParams.SetpmFaxFrom(const Value: ShortString);
begin
  FpmFaxFrom := Value;
end;

procedure TVRWPrintMethodParams.SetpmFaxFromNo(const Value: ShortString);
begin
  FpmFaxFromNo := Value;
end;

procedure TVRWPrintMethodParams.SetpmFaxMethod(const Value: Byte);
begin
  FpmFaxMethod := Value;
end;

procedure TVRWPrintMethodParams.SetpmFaxMsg(const Value: AnsiString);
begin
  FpmFaxMsg := Value;
end;

procedure TVRWPrintMethodParams.SetpmFaxPrinter(const Value: SmallInt);
begin
  FpmFaxPrinter := Value;
end;

procedure TVRWPrintMethodParams.SetpmFaxPriority(const Value: Byte);
begin
  FpmFaxPriority := Value;
end;

procedure TVRWPrintMethodParams.SetpmFaxTo(const Value: ShortString);
begin
  FpmFaxTo := Value;
end;

procedure TVRWPrintMethodParams.SetpmFaxToNo(const Value: ShortString);
begin
  FpmFaxToNo := Value;
end;

procedure TVRWPrintMethodParams.SetpmMiscOptions(
  const Value: TOptionArray);
begin
  FpmMiscOptions := Value;
end;

procedure TVRWPrintMethodParams.SetpmPrintMethod(const Value: Byte);
begin
  FpmPrintMethod := Value;
end;

procedure TVRWPrintMethodParams.SetpmTypes(const Value: LongInt);
begin
  FpmTypes := Value;
end;

procedure TVRWPrintMethodParams.SetpmXMLCreateHTML(const Value: Boolean);
begin
  FpmXMLCreateHTML := Value;
end;

procedure TVRWPrintMethodParams.SetpmXMLFileDir(const Value: ANSIString);
begin
  FpmXMLFileDir := Value;
end;

procedure TVRWPrintMethodParams.SetpmXMLType(const Value: Byte);
begin
  FpmXMLType := Value;
end;

{ TVRWTestModeParams }

function TVRWTestModeParams.GetTmFirstRecPos: LongInt;
begin
  Result := FtmFirstRecPos;
end;

function TVRWTestModeParams.GetTmLastRecPos: LongInt;
begin
  Result := FtmLastRecPos;
end;

function TVRWTestModeParams.GetTmRefreshEnd: Boolean;
begin
  Result := FtmRefreshEnd;
end;

function TVRWTestModeParams.GetTmRefreshStart: Boolean;
begin
  Result := FtmRefreshStart;
end;

function TVRWTestModeParams.GetTmSampleCount: SmallInt;
begin
  Result := FtmSampleCount;
end;

function TVRWTestModeParams.GetTmTestMode: Boolean;
begin
  Result := FTmTestMode;
end;

procedure TVRWTestModeParams.SetTmFirstRecPos(const Value: Integer);
begin
  FtmFirstRecPos := Value;
end;

procedure TVRWTestModeParams.SetTmLastRecPos(const Value: Integer);
begin
  FtmLastRecPos := Value;
end;

procedure TVRWTestModeParams.SetTmRefreshEnd(const Value: Boolean);
begin
  FtmRefreshEnd := Value;
end;

procedure TVRWTestModeParams.SetTmRefreshStart(const Value: Boolean);
begin
  FtmRefreshStart := Value;
end;

procedure TVRWTestModeParams.SetTmSampleCount(const Value: SmallInt);
begin
  FtmSampleCount := Value;
end;

procedure TVRWTestModeParams.SetTmTestMode(const Value: Boolean);
begin
  FtmTestMode := Value;
end;

{ TVRWInputFieldList }

function TVRWInputFieldList.Add: IVRWInputField;
begin
  Result := TVRWInputField.Create;
  Result.rfName := '<Input Field>';
  FList.Add(Result);
end;

procedure TVRWInputFieldList.Clear;
begin
  FList.Clear;
end;

constructor TVRWInputFieldList.Create;
begin
  inherited Create;
  FList := TInterfaceList.Create;
end;

destructor TVRWInputFieldList.Destroy;
begin
  FList.Clear;
  FreeAndNil(FList);
  inherited;
end;

function TVRWInputFieldList.GetRfCount: SmallInt;
begin
  Result := FList.Count;
end;

function TVRWInputFieldList.GetRfItem(Index: Integer): IVRWInputField;
begin
  Result := IVRWInputField(FList[Index]);
end;

procedure TVRWInputFieldList.SetRfItem(Index: Integer;
  Value: IVRWInputField);
begin
  { Make sure any existing reference is released }
  FList[Index] := nil;
  { Install the new reference }
  FList[Index] := Value;
end;

end.
