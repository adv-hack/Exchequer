unit RepTreeIF;

interface

uses
  Classes;

type
  // Base interface used by Sentimail & the Tools Menu for accessing the Report
  // Tree functionality.  This interface cannot be changed without breaking
  // Sentimail & the Tools Menu.
  IReportTree_Interface = interface
    ['{9D0154D3-9E6D-479C-9D6C-8E03283E827E}']

    // --- Internal Methods to implement Public Properties ---
    procedure SetDataPath(const DataPath : ShortString);
    function GetTreeSecurity : ShortString;
    procedure SetTreeSecurity(const UserID : ShortString);

    // ------------------ Public Properties ------------------
    property CompanyDataSetPath : ShortString write SetDataPath;
    property ReportTreeSecurity : ShortString read GetTreeSecurity write SetTreeSecurity;

    // ------------------- Public Methods --------------------
    function GetFirstReport(var TreeNodeType, TreeNodeName, TreeNodeDesc,
                                TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString;
                            var AllowEditReport : boolean) : LongInt; stdcall;

    function GetNextReport(var TreeNodeType, TreeNodeName, TreeNodeDesc,
                               TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString;
                           var AllowEditReport : boolean) : LongInt; stdcall;

    function GetGEqual(const Key : ShortString;
                         var TreeNodeType, TreeNodeName, TreeNodeDesc,
                             TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString;
                         var AllowEditReport : boolean) : LongInt; stdcall;

    function GetNext(var TreeNodeType, TreeNodeName, TreeNodeDesc,
                         TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString;
                     var AllowEditReport : boolean) : LongInt; stdcall;

    function RestorePosition(const iPos : longint) : Longint; stdcall;

    function SavePosition(var iPos : longint) : Longint; stdcall;

  end;

  //=========================================================================

  // Permission types for user based security on the report tree
  TReportPermissionType = (rptHidden=0,        // Hide Group/Report
                           rptShowEdit=1,      // Show Group/Report, Allow Reports to be edited & printed
                           rptPrintOnly=2);    // N/A for Groups, Allow Reports only to be printed

  // Interface for a specific users details for a specific report, accessed via
  // properties of IReportSecurity
  IUserReportSecurity = Interface
    ['{425080B6-2BBC-4963-9F15-7808338FBD50}']
    // --- Internal Methods to implement Public Properties ---
    Function GetName : ShortString;
    Function GetPermission : TReportPermissionType;
    Procedure SetPermission (Value : TReportPermissionType);

    // ------------------ Public Properties ------------------
    Property ursName : ShortString Read GetName;
    Property ursPermission : TReportPermissionType Read GetPermission Write SetPermission;

    // ------------------- Public Methods --------------------
  End; // IUserReportSecurity

  //------------------------------

  // Items types within the Report Tree
  TReportType = (rtGroup, rtReport);

  // Interface containing all security information for a single group or
  // report for all users, accessed via IRWReportTree_Interface.GetSecurity
  IReportSecurity = Interface
    ['{0EA75E7C-19D3-4DA6-8001-2EB60C521BFB}']
    // --- Internal Methods to implement Public Properties ---
    Function GetReportCode : ShortString;
    Function GetReportDesc : ShortString;
    Function GetReportFile : ShortString;
    Function GetType : TReportType;
    Function GetPermittedUserCount : SmallInt;
    Function GetPermittedUsers (Index: SmallInt) : IUserReportSecurity;
    Function GetPermittedUsersByName (Name: ShortString) : IUserReportSecurity;

    // ------------------ Public Properties ------------------
    Property rsReportCode : ShortString Read GetReportCode;
    Property rsReportDesc : ShortString Read GetReportDesc;
    Property rsReportFile : ShortString Read GetReportFile;
    Property rsType : TReportType Read GetType;
    Property rsPermittedUserCount : SmallInt Read GetPermittedUserCount;
    Property rsPermittedUsers [Index: SmallInt] : IUserReportSecurity Read GetPermittedUsers;
    Property rsPermittedUsersByName [Name: ShortString] : IUserReportSecurity Read GetPermittedUsersByName;

    // ------------------- Public Methods --------------------
    Function IndexOf (Const Name: ShortString) : LongInt;
    Procedure Save;
  End; // IReportSecurity

  //------------------------------

  // Extended version used by EntRW only, this interface can be changed as long
  // as both sides are rebuilt
  IRWReportTree_Interface = interface(IReportTree_Interface)
    ['{143B4D8D-64E6-4F8B-817D-754C8452CD49}']

    // --- Internal Methods to implement Public Properties ---
    function GetTreeSecurity : ShortString;
    procedure SetTreeSecurity(const UserID : ShortString);

    function GetNodeName : ShortString;
    procedure SetNodeName(const ssNodeName : ShortString);

    function GetNodeDescription : ShortString;

    // ------------------ Public Properties ------------------
    property NodeName : ShortString read GetNodeName write SetNodeName;
    property NodeDescription : ShortString read GetNodeDescription;

    // ------------------- Public Methods --------------------
    function AddTreeNode(const TreeNodeType, TreeNodeName, TreeNodeDesc,
                               TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString) : LongInt; stdcall;

    function EditTreeNode(const TreeNodeType, TreeNodeName, TreeNodeDesc,
                               TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString) : LongInt; stdcall;

    function CopyTreeNode(const TreeNodeType, TreeNodeName, TreeNodeDesc,
                               TreeNodeParent, TreeNodeChild,
                               OldFileName, NewFileName, LastRun : ShortString) : LongInt; stdcall;

    function DeleteTreeNode(const TreeNodeType, TreeNodeName : ShortString) : LongInt; stdcall;

    // Used by the Report Engine to get the report details for printing, returns
    // TRUE if the user is allowed to print the report
    Function GetReportForPrinting(Const NodeName : ShortString; Var NodeDesc, FileName : ShortString) : Boolean;

    // Returns a security object for the specified report
    Function GetSecurity(Const ReportCode : ShortString) : IReportSecurity;
  end;

  //------------------------------

  // Debug Interface used by EntRW.Exe
  IReportTreeDebug = Interface(IRWReportTree_Interface)
    ['{507194E0-217D-4CE8-B493-EB10691C5D93}']
    // --- Internal Methods to implement Public Properties ---

    // ------------------ Public Properties ------------------

    // ------------------- Public Methods --------------------
    Procedure DumpReportSecurity;
    Procedure DumpReportTree;
  End; // IReportTreeDebug


implementation

end.

