unit VRWReportDataIF;
{
  Interface unit for the Visual Report Writer Report Data Reader. This is a
  replacement for the existing IReportTree_Interface and
  IRWReportTree_Interface interfaces in X:\Entrprse\GUIRW\Common\RepTreeIF.pas.

  See VRWReportDataU for the classes which implement these interfaces.
}
interface

uses GlobVar, RepTreeIF;

type
  TVRWReportDataMode = (rtmView, rtmAdd, rtmUpdate);

  IVRWReportDataEditor = interface;

  IVRWReportData = interface
  ['{423D30D4-EBBC-4421-B003-CFE2581589FC}']
    // --- Internal methods to implement general properties -------------------

    // Datapath holds the path to the Enterprise folder (the reports will be
    //  in a \REPORTS sub-folder).
    function GetDatapath: ShortString;
    procedure SetDatapath(const Datapath : ShortString);

    // Index is the currently active index for the data file.
    function GetIndex: Integer;
    procedure SetIndex(const Value: Integer);

    // UserID is the log-in ID of the current user.
    function GetUserID: ShortString;
    procedure SetUserID(const Value: ShortString);

    // CanView holds whether or not the current user has permissions to
    // view the currently selected record.
    function GetCanView: Boolean;

    // CanEdit holds whether or not the current user has permission to
    // edit the currently selected record.
    function GetCanEdit: Boolean;

    // ShowHiddenRecords will include all records in data navigation, even if
    // the current user does not have rights to view them.
    function GetShowHiddenRecords: Boolean;
    procedure SetShowHiddenRecords(const Value: Boolean);

    // --- Internal methods to implement properties mapping to data fields ----

    function GetRtNodeType: char;
    function GetRtRepName: str50;
    function GetRtRepDesc: str255;
    function GetRtParentName: str50;
    function GetRtFileName: str80;
    function GetRtLastRun: TDateTime;
    function GetRtLastRunUser: str10;
    function GetRtPositionNumber: LongInt;

    // --- Interface methods --------------------------------------------------

    // Returns an editable interface for adding new records (IVRWReportData is
    // read-only).
    function Add: IVRWReportDataEditor;

    // Returns a string suitable for searching the FileName index.
    function BuildFileNameIndex(const FileName: string): str80;

    // Returns a string suitable for searching the RepName index.
    function BuildRepNameIndex(const RepName: string): str50;

    // Returns a string suitable for searching the ParentName index. If
    // PositionNumber is greater than -1 it will be included in the returned
    // search string
    function BuildParentNameIndex(const ParentName: string;
      PositionNumber: Integer = -1): string;

    // Returns True if the current user has permission to print the specified
    // report.
    function CanPrint(const ReportName: ShortString; var NodeDesc,
      FileName: ShortString; ForToolsMenu: Boolean = False): Boolean;

    // Returns true if the user is allowed access to this report, and also
    // returns true or false in the CanEdit parameter.
    function CheckUserPermissions(const ReportName: ShortString;
      var CanEdit: boolean): boolean;

    // Clears the fields of the internal data record.
    procedure ClearFields;

    // Copies the current report file and record }
    function CopyReport(const ToFileName, NewReportName,
      NewReportDesc: string): LongInt;

    // Deletes the specified record, any/all child records attached to it,
    // and the actual report file (if it exists)
    function Delete(const ReportName: string): LongInt;

    // Debug support: prints the Report Security data to a CSV file
    procedure DumpReportSecurity;

    // Debug support: prints the Report Tree data to a CSV file
    procedure DumpReportTree;

    // Returns True if there is a record with the specified File Name
    function FileNameExists(const FileName: string): Boolean;

    // Locates the record with the specified file name (file names are
    // unique).
    function FindByFileName(const FileName: string): LongInt;

    // Locates the record with the specified report name (report names are
    // unique).
    function FindByName(const ReportName: string): LongInt;

    // Locates the record with the specified Parent and Order Number. If no
    // order number is specified, locates the first record against the
    // parent.
    function FindByParent(const ParentName: string; PositionNumber: Integer = 0): LongInt;

    // Locates the record in the data file which matches the supplied
    // string.
    function GetEqual(const Key: ShortString): LongInt;

    // Locates the first record in the data file which matches the supplied
    // string.
    function GetGreaterThanOrEqual(const Key: ShortString): LongInt;

    // Locates the first record against the current index.
    function GetFirst: LongInt;

    // Locates the last record against the current index.
    function GetLast: LongInt;

    // Locates the next record against the current index.
    function GetNext: LongInt;

    // Locates the first child record for the specified parent record.
    function GetFirstChild(const ParentName: string): LongInt;

    // Locates the next child record. Assumes that the current record is a
    // valid child record and returns 9 (end-of-file) if the next record is
    // not against the same parent.
    function GetNextChild: LongInt;

    // Locates the previous record against the current index.
    function GetPrevious: LongInt;

    // Locates the previous child record. Assumes that the current record is a
    // valid child record and returns 9 (end-of-file) if the previous record is
    // not against the same parent.
    function GetPreviousChild: LongInt;

    // Returns a security object for the specified report
    function GetSecurity(const ReportName: ShortString): IReportSecurity;

    // Inserts the record at a new location in the report hierarchy. If the
    // specified position number is currently in use, the position numbers of
    // the subsequent records under the parent record will be changed.
    function InsertAt(ParentName: string; PositionNumber: Integer): LongInt;

    // Returns True if there are no records against the specified Parent Name
    // and Order Number.
    function IsUnique(const ParentName: string; PositionNumber: Integer): Boolean;

    // Creates a file name, based on the supplied name, ensuring that the
    //  result is unique.
    function MakeUniqueFileName(const FileName: ShortString): ShortString;

    // Creates a report name, based on the supplied name, ensuring that the
    // result is unique.
    function MakeUniqueReportName(const ReportName: ShortString): ShortString;

    // Moves the current child record up one position. If it is already the
    // first child against its parent this method returns 9 (end-of-file).
    function MoveUp: LongInt;

    // Moves the current child record down one position. If it is the last
    // child against its parent this method returns 9 (end-of-file).
    function MoveDown: LongInt;

    // Moves the record to a new location in the report hierarchy. If
    // TargetName references a folder, the record becomes the last child record
    // in the folder. If TargetName references a report, the record becomes the
    // record immediately preceding the target (in other words, it is inserted
    // at the target's position). MoveTo should only be used for moving records
    // to different folders. To move a record inside a folder, use MoveUp and
    // MoveDown.
    function MoveTo(TargetName: string): LongInt;

    // Reads the current record from the data file into the internal record.
    // This is normally only required if the data has been changed elsewhere,
    // such as by Update.Save.
    function Read: LongInt;

    // Returns True if there is a record against the specified Report Name
    function ReportExists(const ReportName: string): Boolean;

    // Returns to a previously saved position in the data file. RecordPosition
    // assumed to have been obtained by a previous call to SavePosition.
    function RestorePosition(const RecordPosition: LongInt): LongInt;

    // Saves the current position in the data file. On return, RecordPosition
    // will hold the physical address of the record, and can be passed to
    // RestorePosition (see above) to return to the record.
    function SavePosition(var RecordPosition: LongInt): LongInt;

    // Returns an editable interface for updating records (IVRWReportData is
    // read-only).
    function Update: IVRWReportDataEditor;

    // --- General properties -------------------------------------------------

    // Enterprise path
    property Datapath: ShortString read GetDatapath write SetDatapath;

    // User log-in name
    property UserID: ShortString read GetUserID write SetUserID;

    // Index number. Changing this property value will change the active
    // index.
    property Index: Integer read GetIndex write SetIndex;

    // Is the user allowed to view the record?
    property CanView: Boolean read GetCanView;

    // Is the user allowed to edit the record?
    property CanEdit: Boolean read GetCanEdit;

    // --- Properties mapping to data fields ----------------------------------

    // Tree node type -- (H)eading or (R)eport
    property rtNodeType: char read GetRtNodeType;

    // Report name (unique, used for indexing and searching)
    property rtRepName: str50 read GetRtRepName;

    // Report title, displayed as node caption in tree
    property rtRepDesc: str255 read GetRtRepDesc;

    // Parent name, blank for top-level nodes
    property rtParentName: str50 read GetRtParentName;

    // Report file name
    property rtFileName: str80 read GetRtFileName;

    // Date and time that the report was last run
    property rtLastRun: TDateTime read GetRtLastRun;

    // Last user to run the report
    property rtLastRunUser: str10 read GetRtLastRunUser;

    // Order number, for sort order of reports
    property rtPositionNumber: LongInt read GetRtPositionNumber;

    // Records which the user does not have permission to view will be
    // excluded from any data access or movement (GetNext, MoveUp, etc.) if
    // this flag is set to False. It defaults to True;
    property ShowHiddenRecords: Boolean
      read GetShowHiddenRecords
      write SetShowHiddenRecords;

  end;

  IVRWReportDataEditor = interface(IVRWReportData)
    ['{B5243BBF-6606-47E0-BEAB-A004F85BCCE0}']
    // --- Internal methods to implement general properties -------------------

    function GetIsLocked: Boolean;

    // --- Internal methods to implement properties mapping to data fields ----

    procedure SetRtNodeType(const Value: Char);
    procedure SetRtRepName(const Value: str50);
    procedure SetRtRepDesc(const Value: str255);
    procedure SetRtParentName(const Value: str50);
    procedure SetRtFileName(const Value: str80);
    procedure SetRtLastRun(const Value: TDateTime);
    procedure SetRtLastRunUser(const Value: str10);
    procedure SetRtPositionNumber(const Value: LongInt);

    // --- Interface methods --------------------------------------------------

    function Save: LongInt;

    // --- General properties -------------------------------------------------

    // Holds True if the record is locked ready for editing. Only valid for
    // updating records.
    property IsLocked: Boolean read GetIsLocked;

    // --- Properties mapping to data fields ----------------------------------
    // The read-only properties from ancestor interface are replaced here with
    // read-write properties.

    property rtNodeType: char read GetRtNodeType write SetRtNodeType;
    property rtRepName: str50 read GetRtRepName write SetRtRepName;
    property rtRepDesc: str255 read GetRtRepDesc write SetRtRepDesc;
    property rtParentName: str50 read GetRtParentName write SetRtParentName;
    property rtFileName: str80 read GetRtFileName write SetRtFileName;
    property rtLastRun: TDateTime read GetRtLastRun write SetRtLastRun;
    property rtLastRunUser: str10 read GetRtLastRunUser write SetRtLastRunUser;
    property rtPositionNumber: LongInt read GetRtPositionNumber write SetRtPositionNumber;
  end;

implementation

end.


