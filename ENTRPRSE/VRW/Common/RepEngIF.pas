unit RepEngIF;

interface

uses
  Classes, Forms,
  GlobalTypes, CtrlPrms;

var
  Bill : string;

type
  TInputLinePrms = TInputLineRecord;
//  TReportFileFormat = (EDF_FILE, EDZ_FILE, INTERNAL_PDF_FILE, ADOBE_PDF_FILE, DBF_FILE, CSV_FILE, XLS_FILE, HTML_FILE);

  IReport_Interface = interface
    ['{248E4FD2-956A-4BC5-B0A6-B53A1085F42B}']

    // property get/set methods
    procedure SetProgressMonitor(const Monitor : TProgressMonitorEvent);

    procedure SetPaper(const PaperIdx : SmallInt);
    procedure SetPrinter(const PrinterIdx : SmallInt);

    procedure SetDataPath(const DataPath : ShortString);

    function GetReportLocation : ShortString;
    procedure SetSilentRunning(const SilentRunning : Boolean);
    procedure SetWindowParent(const WindowParent : TApplication);

    // public properties
    property Paper : SmallInt write SetPaper;
    property Printer : SmallInt write SetPrinter;

    property CompanyDataSetPath : ShortString write SetDataPath;
    property ProgressEvent : TProgressMonitorEvent write SetProgressMonitor;
    // for Sentimail - once the report is completed the path and filename of the report are here.
    // This is belt and braces really...
    // ...if a report path and filename have not been previously set then there will be one here.
    property CompletedReportLocation : ShortString read GetReportLocation;

    property SilentRunning : Boolean write SetSilentRunning;

    property PreviewWindowParent : TApplication write SetWindowParent;

    // public methods
    function LoadReport(const ReportHnd : TMemoryStream; const UserID : ShortString; const ReportCode : ShortString) : LongInt;
    function SaveReport(const ReportHnd: TMemoryStream; const ReportCode : ShortString) : LongInt;
    function PrintReport(var ReportHnd : TMemoryStream; const ReportCode : ShortString) : LongInt;

    // for Sentimail - the ssReportPath should be the path and the filename including extension
    // Call SetReportTypeLocation before calling PrintReport
//    procedure SetReportTypeLocation(const tReportOutput : TReportFileFormat; const ssReportPath : ShortString);

    // get/set InputLineParameters
    procedure GetReportParameters(var lstReportParams : TList);
    procedure SetReportParameters(const lstReportParams : TList);

  end;

  IRWReport_Interface = interface
    ['{C3BBAF85-72C9-4718-BCDC-0A3CBF387E4B}']

    // property get/set methods
    procedure SetProgressMonitor(const Monitor : TProgressMonitorEvent);

    procedure SetPaper(const PaperIdx : SmallInt);
    procedure SetPrinter(const PrinterIdx : SmallInt);

    procedure SetDataPath(const DataPath : ShortString);

    procedure SetWindowParent(const WindowParent : TApplication);

    procedure SetReportFileName(const sFileName : ShortString);
    function GetReportFileName : ShortString;
    procedure SetReportName(const sReportName : ShortString);
    function GetReportName : ShortString;
    procedure SetReportDesc(const sReportDesc : ShortString);
    function GetReportDesc : ShortString;

    function GetPaperOrientation : Byte;
    procedure SetPaperOrientation(const Orientation : Byte);

    function GetMainFileName : ShortString;
    procedure SetMainFileName(const sMainFileName : ShortString);
    function GetMainDBFile : SmallInt;
    procedure SetMainDBFile(const siMainDBFile : SmallInt);
    function GetDBIdx : SmallInt;
    procedure SetDBIdx(const siDBIdx : SmallInt);
    function GetBTrvKeyPath : Integer;
    procedure SetBTrvKeyPath(const iBTrvKeyPath : Integer);

    function GetWizardBased : Boolean;
    procedure SetWizardBased(const bWizardBased : Boolean);

    function GetReportChanged : Boolean;
    procedure SetReportChanged(const bChanged : Boolean);

    Function GetLoggedInUser : ShortString;
    Procedure SetLoggedInUser (Value : ShortString);

    Function GetConstructInfo : TReportConstructInfo;

    // public properties
    property Paper : SmallInt write SetPaper;
    property Printer : SmallInt write SetPrinter;

    property CompanyDataSetPath : ShortString write SetDataPath;

    property PreviewWindowParent : TApplication write SetWindowParent;

    property ReportFileName : ShortString read GetReportFileName write SetReportFileName;
    property ReportName : ShortString read GetReportName write SetReportName;
    property ReportDesc : ShortString read GetReportDesc write SetReportDesc;
    property PaperOrientation : byte read GetPaperOrientation write SetPaperOrientation;
    property MainFileName : ShortString read GetMainFileName write SetMainFileName;
    property MainDBFile : SmallInt read GetMainDBFile write SetMainDBFile;
    property DBIndex : SmallInt read GetDBIdx write SetDBIdx;
    property BTrvKeyPath : Integer read GetBTrvKeyPath write SetBTrvKeyPath;
    property WizardBased : Boolean read GetWizardBased write SetWizardBased;
    property ReportChange : Boolean read GetReportChanged write SetReportChanged;
    property ProgressEvent : TProgressMonitorEvent write SetProgressMonitor;
    Property LoggedInUser : ShortString Read GetLoggedInUser Write SetLoggedInUser;

    // HM 09/03/05: Added property to allow simple access to Global ReportConstructInfo
    Property ConstructInfo : TReportConstructInfo Read GetConstructInfo;

    // public methods
    function CreateReport(const ReportHnd : TMemoryStream) : LongInt;
    function LoadReport(const ReportHnd : TMemoryStream; const UserID : ShortString; const ReportCode : ShortString) : LongInt;
    function RWSaveReport(const ReportHnd : TMemoryStream; const ReportCode : ShortString) : LongInt;
    function PrintReport(var ReportHnd : TMemoryStream; const ReportCode : ShortString) : LongInt;

    procedure SetReportConstruct(const RptConstruct : TReportConstructInfo);
    function GetReportPrintMethod : TPrintMethodParams;
    function GetTestModeParams : TTestModeParams;

    function GetRegionCount(const ReportHnd : TMemoryStream) : SmallInt;
    procedure ClearRegionBlocks;
    procedure AddRegionBlock(const ReportHnd : TMemoryStream; const pBlock : Pointer; const RegionId : Byte);
    function GetRegionBlock(const ReportHnd : TMemoryStream; const RegionId : Byte) : Pointer;
    function GetRegionBlockByName(const ReportHnd: TMemoryStream; const RegionName : ShortString) : Pointer;
    procedure ClearReportBlocks;
    procedure AddReportBlock(const ReportHnd : TMemoryStream; const pBlock, pBitMaps : Pointer; const RegionId : Byte);
    function GetReportBlock(const ReportHnd : TMemoryStream; const RegionId : Byte; const lstReportBlocks : TList) : Boolean;
    procedure GetImageData(const ReportHnd : TMemoryStream; const RegionId : Byte; const slBitMaps : TStringList);
  end;

implementation

end.
