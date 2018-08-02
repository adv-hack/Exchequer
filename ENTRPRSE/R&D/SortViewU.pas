unit SortViewU;

interface

uses Messages, SysUtils, Controls, Forms, Classes, StdCtrls, ExtCtrls,
  AdvCircularProgress, VarSortV, GlobVar, SQLCallerU, ADOConnect;

const
  WM_CANCEL_BUILDFILE = WM_USER + 1000;

type

  TUserSortViewDefaults = class(TObject)
  private
    FSearchKey: Str255;
    procedure SetDefaultView(const Value: LongInt);
    procedure SetListType(const Value: TSortViewListType);
    procedure SetUserID(const Value: Str30);
    function GetDefaultView: LongInt;
    function GetListType: TSortViewListType;
    function GetUserID: Str30;
  public
    function FindDefault(ForUserID: string; ForListType: TSortViewListType): Integer;
    function Find(ForUserID: string): Integer;
    function First: Integer;
    function Last: Integer;
    function Next: Integer;
    function Prior: Integer;
    function Update(ForUserID: Str30; ForListType: TSortViewListType; ViewID: LongInt): Integer;
    property UserID: Str30 read GetUserID write SetUserID;
    property ListType: TSortViewListType read GetListType write SetListType;
    property DefaultView: LongInt read GetDefaultView write SetDefaultView;
  end;

  TSortViewProgressPanel = class(TPanel)
    procedure CancelButtonClick(Sender: TObject);
  private
    FCancelled: Boolean;
    FProgressCtrl: TAdvCircularProgress;
    FTitlePanel: TPanel;
    FProgressLabel: TLabel;
    FCancelButton: TButton;
    procedure WMCancelBuildFile(var Msg: TMessage); message WM_CANCEL_BUILDFILE;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateLayout(ParentControl: TWinControl);
    procedure UpdateProgress(Count: Integer);
    property Cancelled: Boolean read FCancelled write FCancelled;
  end;

  { Note: 'main file' in the comments means the file which is being listed, as
    opposed to the temporary file which is being used for the sort order. The
    system works by using a temporary file for the sort order, and then looking
    up the matching record in the main file whenever the actual record details
    are needed. }
  TBaseSortView = class(TObject)
  private
    FActiveViewID: Integer;
    FIsBuildingFile: Boolean;
    FEnabled: Boolean;
    FHostListIndexNo: LongInt;
    FHostListFileNo: LongInt;
    FHostListSearchKey: ShortString;
    FHostLongIntLink: Boolean;
    FListDesc: ShortString;
    FListType: TSortViewListType;
    FSortCount: LongInt;
    FSearchKey: str255;
    FUserDefaults: TUserSortViewDefaults;
    FListID: Integer;
    FOnFilter: TSortViewOnFilter;
    FOnSetFilter: TSortViewOnSetFilter;
    FProgressPanel: TSortViewProgressPanel;
    FHostPanel: TWinControl;
    FLockFile: TextFile;
    FStockCode: string;
    FJobCode: string;
    { CJS - 2012-07-20: ABSEXCH-12962 - Sort View SQL Mods }
    FSQLCaller: TSQLCaller;
  protected
    { Checks that the current record matches all the filter values, and returns
      False if any of them don't. This function assumes that the actual file
      being listed is positioned on the correct record (i.e. that SyncRecord
      has been called successfully). }
    function CheckSortViewFilter : Boolean;

    //PL 04/01/2017 2017-R1 ABSEXCH-17809 : Default list values for Status field in Sort View of Trader > Ledger is not correct.
    function GetResolvedFilterValue(aFilterId:Integer; aFilterValue:String) : String; virtual;

    { Checks that that current record matches the details in the supplied
      filter. This is called by CheckSortViewFilter for each active string
      filter. }
    function EvaluateStringFilter(const Filter: TSortViewFilterInfoRecType): Boolean;

    { Checks that that current record matches the details in the supplied
      filter. This is called by CheckSortViewFilter for each active float
      filter. }
    function EvaluateFloatFilter(const Filter: TSortViewFilterInfoRecType): Boolean;

    { This must be overridden by descendant classes, and should return the data
      type (currently fdtString or fdtFloat ) for the field identified by
      FilterFieldId. It is used by CheckSortViewFilter to determine which
      Evaluate... function should be called for each filter. }
    function GetFilterDataType(const FilterFieldId: LongInt): TSortViewFilterDataType; virtual; abstract;

    { Property access function for the Filters array property. }
    function GetFilters(Index: Integer): PSortViewFilterInfoRecType;

    { These must be overridden by descendant classes, and should return the
      value of the field identified by FilterFieldId. They can assume that the
      main file is positioned on the current record. }
    function GetStringFilterValue(const FilterFieldId: LongInt): ShortString; virtual; abstract;
    function GetFloatFilterValue(const FilterFieldId: LongInt): Double; virtual; abstract;

    { Property access function for the Sorts array property. }
    function GetSorts(Index: Integer): PSortViewSortInfoRecType;

    { This must be overridden by descendant classes, and should return the
      value of the field identified by the Sort record. It can assume that the
      main file is positioned on the current record, and it should make use of
      the AdjustSort...Value functions to ensure that the string returned is
      formatted for sorting correctly. }
    function GetSortValue(const Sort: TSortViewSortInfoRecType): ShortString; virtual; abstract;

    { These must be overridden by descendant classes, and should return the
      values of the fields that can be used to uniquely identify record in the
      main file. Most files will only need one or two of these functions -- the
      others should return a null value. }
    function GetSourceDataStr: ShortString; virtual; abstract;
    function GetSourceDataFolio: LongInt; virtual; abstract;
    function GetSourceLineNo: LongInt; virtual; abstract;

    { Returns an inverted version of the supplied string, suitable for sorting
      a list in descending order. }
    function InvertSortStringValue(const SortString: ShortString): ShortString;

    { Returns an adjusted version of the supplied date string, suitable for
      sorting a list (padded, and inverted if necessary). }
    function AdjustSortDateStringValue(const SortString: ShortString; Sort: TSortViewSortInfoRecType): ShortString;

    { Returns an adjusted version of the supplied string, suitable for
      sorting a list (padded, and inverted if necessary). }
    function AdjustSortStringValue(const SortString: ShortString; Sort: TSortViewSortInfoRecType): ShortString;

    { Returns a formatted string version of the supplied value, suitable for
      sorting a list (padded, and inverted if necessary). }
    function AdjustSortFloatValue(Value: double; Sort: TSortViewSortInfoRecType): ShortString;

    { CJS - 2012-07-20: ABSEXCH-12962 - Sort View SQL Mods }
    { SQL Caller support -- these functions are for the SQL-only modifications
      to the Sort View system, and need to be overridden by descendant classes
      to set up the fields as required by the specific Sort View. }

    function UseStoredProcedure: Boolean; virtual;
    procedure PrepareFields; virtual; abstract;
    procedure ReadRecord; virtual; abstract;
    function GetSQLSortValue(const Sort: TSortViewSortInfoRecType): ShortString; virtual; abstract;
    function GetSQLSourceDataStr: ShortString; virtual; abstract;
    function GetSQLSourceDataFolio: LongInt; virtual; abstract;
    function GetSQLSourceLineNo: LongInt; virtual; abstract;

    {
      --------------------------------------------------------------------------
      Lock Files: These are only used when running against a SQL database, and
      keep track of whether or not a SortView table is active, deleting the
      table when it is no longer required.
      --------------------------------------------------------------------------
    }

    { Returns the filename to use for the lock file. }
    function LockFilename: string;

    { Opens a lock file against the specified name, creating one if it does not
      already exist. }
    procedure PrepareLockFile(Filename: string);

    { Creates a new lock file against the specified name. The file must not
      already exist. Returns False if the file cannot be created, otherwise
      returns True. This is only called from PrepareLockFile(). }
    function CreateLockFile(Filename: string): Boolean;

    { Opens the specified lock file, which must exist. This is only called from
      PrepareLockFile(). }
    procedure OpenLockFile(Filename: string);

    { Attempts to delete the specified lock file. Returns True if this succeeds, or
      False if the file cannot be deleted. }
    function ReleaseLockFile(Filename: string): Boolean;

    { Attempts to delete all lock files for the current work station, and for each
      successful deletion, deletes any SQL table with the same name. }
    class procedure ClearLockFiles();

    { Property access functions. }
    procedure SetEnabled(const Value: Boolean);
    procedure SetHostListFileNo(const Value: LongInt);
    procedure SetHostListIndexNo(const Value: LongInt);
    procedure SetHostListSearchKey(const Value: ShortString);
    procedure SetListDesc(const Value: ShortString);
    procedure SetSortViewDesc(const Value: ShortString);
    procedure SetSortCount(const Value: LongInt);
    procedure SetListType(const Value: TSortViewListType);
    procedure SetSearchKey(const Value: str255);
    function GetFilterCount: LongInt;
    function GetSortViewDesc: ShortString;
    procedure SetUserID(const Value: Str30);
    function GetUserID: Str30;
    function GetListType: TSortViewListType;

    { Returns the temporary file name for the current session. }
    function TempFileName: string;

    { Returns the basic temporary file name, specific to the current
      workstation.

      Note: This is only a class function because it needs to be called by
      another class function, RemoveTempFiles. }
    class function BaseTempFileName: string;
  public
    { Returns the Field ID that matches the position in the list of filter
      fields available for this Sort View. By default this simply returns
      the supplied list index, which was the original behaviour of the sort
      views. Individual Sort Views should override this function if they want
      to use a different mapping of index to field id. }
    function GetFieldIDFromListIndex(ItemIndex: Integer): Integer; virtual;

    { Given a Field ID, this returns the index position of the matching entry
      in the list of filter fields available for this Sort View. By default this
      simply returns the list index, therefore assuming a direct mapping between
      the two values (i.e. the FieldID is simply the position of the item in the
      list). Individual Sort Views should override this function if they want to
      use a different mapping of field id to index. }
    function GetListIndexFromFieldID(FieldID: Integer): Integer; virtual;

    { Applies the Sort View, creating the temporary file. The correct record in
      the Sort View file must be selected before calling this function. }
    function Apply: Integer;

    { Removes the temporary files that were created by this workstation,
      provided they are not in use. Returns False if any of the files cannot
      be deleted. }
    class function RemoveTempFiles: Boolean;

    { Cancels building the current temporary file. Has no effect if the
      temporary file is not currently in the process of being built. }
    procedure CancelBuild;

    { Standard constructor and destructor. }
    constructor Create;
    destructor Destroy; override;

    { Adds a new Sort View record, using the details currently in SortViewRec. }
    function Add: Integer;

    { Locates the Sort View record which matches the given key, returning a
      standard Btrieve result code. This uses the SVListTypeK index, so the
      search is against the list type (svltCustomer..svltJobLedger), the user
      id, and the description. }
    function Find(Key: Str255): Integer;

    { Locates the Sort View record which matches the given View Id, returning a
      standard Btrieve result code. }
    function FindByID(ViewID: Integer): Integer;

    { Simple navigation functions for the Sort View file. }
    function First: Integer;
    function Last: Integer;
    function Next: Integer;
    function Prior: Integer;

    { CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View }
    { Locates and navigates to the default Sort View for the current user and
      Sort View Type. Returns False if no default can be found for this user
      and type. }
    function LoadDefaultSortView: Boolean;

    { Returns the next available List ID for the temporary file. This is
      assigned when a new list is created. }
    function NextListID: LongInt;

    { Returns the next available Sort View ID. This is used by Add, to set a
      unique id for the record. }
    function NextViewID: LongInt;

    { Deletes the current Sort View record, returning a standard Btrieve result
      code. }
    function Delete: Integer;

    { Returns a search key which can be used to search for global Sort View
      records (i.e. records which are not assigned to a specific user) for the
      list type (svltCustomer..svltJobLedger) of the current Sort View class.
      This requires ListType to be set correctly -- this should be done by
      the constructor of each descendant class. }
    function GlobalSearchKey: Str255;

    { Returns a search key which can be used to search for all records for the
      list type (svltCustomer..svltJobLedger) of the current Sort View class.
      This requires ListType to be set correctly -- this should be done by
      the constructor of each descendant class. }
    function ListTypeSearchKey: Str255;

    { Creates the temporary file for the workstation and session, provided it
      is not currently open, returning a standard Btrieve result code. If the
      file is already open, it returns 0. }
    function CreateTempFile: Integer;

    { Populates the temporary file (creating it if necessary) with records for
      the currently defined sort. The Host... properties must be set correctly
      before calling this function, and the main file must be open. This will
      set the ListID property to identify the list that has been created.

      This will return a standard Btrieve result code. If any record cannot be
      added to the list, the function will exit. If the validation of the
      current Sort View fails, an exception will be raised. }
    function BuildTempFile: Integer;

    { Closes the current view (identified by ListID -- if this is -1, no action
      will be taken), deleting all the matching records from the temporary
      file. }
    function CloseView: Integer;

    { This must be overridden by descendant classes, and should locate the
      record in the main file which matches the relevant source data values from
      SortTempRec (SourceDataStr, SourceDataFolio, SourceLineNo).

      See SortCust.pas for an example. }
    function SyncRecord: Integer; virtual; abstract;

    { This can be overridden by descendant classes if they need to look up
      details from other tables when filtering records. The base function does
      nothing and returns 0. The Btrieve status-code should be returned by
      descendant versions.

      See SortJob.pas for an example. }
    function SyncFilter: Integer; virtual;

    { This must be overridden by descendant classes, and should locate the
      record in the temporary file which matches the relevant data values from
      the current record in the main file. It needs to include the List ID as
      the first part of the search string, and should follow this with the
      values that match those returned by SourceDataStr, SourceDataFolio, and
      SourceLineNo. The STLinkStrK index should be used for string values, and
      the STLinkFolioK index should be used for Folio and Line Number values.

      See SortCust.pas for an example. }
    function SyncTemp: Integer; virtual; abstract;

    function CheckListFilter : Boolean; virtual;

    { These are called by the Sort View Configuration dialog, and should be
      overridden by descendant classes to fill the supplied strings with the
      descriptive names of the available sort fields and filter fields. }
    procedure PopulateSortFields(List: TStrings); virtual; abstract;
    procedure PopulateFilterFields(List: TStrings); virtual; abstract;

    { Refreshes the active Sort View, rebuilding the temporary list. After
      calling this, the Sort View file will be on the record for the active
      Sort View. }
    function Refresh: Integer;

    { Updates the current Sort View record, using the details currently in
      SortViewRec. }
    function Update: Integer;

    { Returns the string to use for locating Sort View records against the
      list type and the current user. }
    function UserSearchKey: Str255;

    { Checks that the Sort View record contains valid information, and returns
      an appropriate result code (svveOk if the record is valid). }
    function ValidateForAdd: TSortViewValidationErrorType;
    function ValidateForEdit(ViewID: LongInt): TSortViewValidationErrorType;
    function ValidateForApply(ViewID: LongInt): TSortViewValidationErrorType;

    { Checks that the current Sort View record has at least the minimum
      required information in it. }
    function ViewIsComplete: TSortViewValidationErrorType;

    { Checks that the current Sort View record does not contain an invalid
      configuration. }
    function ViewIsValid: TSortViewValidationErrorType;

    { Returns True if the current record in the temporary table matches the
      List ID. }
    function InList: Boolean;

    { This determines whether the Sort View is currently active -- i.e. whether
      it is being used to control a list display. }
    property Enabled : Boolean read FEnabled write SetEnabled;

    property FilterCount : LongInt read GetFilterCount;
    property Filters[Index: LongInt]: PSortViewFilterInfoRecType read GetFilters;

    { This is the user-friendly description for the list, and will be displayed
      as the caption of the Sort View Options dialog. Each descendant class
      should set this appropriately. }
    property ListDesc : ShortString read FListDesc write SetListDesc;

    property ActiveViewID: Integer read FActiveViewID;
    property FilterDataType[const Index: Integer]: TSortViewFilterDataType read GetFilterDataType;
    property ListID: Integer read FListID;
    property ListType: TSortViewListType read GetListType write SetListType;
    property SearchKey: str255 read FSearchKey write SetSearchKey;
    property SortCount : LongInt read FSortCount write SetSortCount;
    property Sorts[Index: LongInt]: PSortViewSortInfoRecType read GetSorts;
    property SortViewDesc : ShortString read GetSortViewDesc write SetSortViewDesc;
    property HostListSearchKey : ShortString read FHostListSearchKey write SetHostListSearchKey;
    property HostListFileNo : LongInt read FHostListFileNo write SetHostListFileNo;
    property HostListIndexNo : LongInt read FHostListIndexNo write SetHostListIndexNo;
    property HostLongIntLink: Boolean read FHostLongIntLink write FHostLongIntLink;
    property UserID: Str30 read GetUserID write SetUserID;
    property UserDefaults: TUserSortViewDefaults read FUserDefaults;
    { CJS - 2012-07-20: ABSEXCH-12962 - Sort View SQL Mods }
    property SQLCaller: TSQLCaller read FSQLCaller;
    property StockCode: string read FStockCode write FStockCode;
    property JobCode: string read FJobCode write FJobCode;

    { OnFilter and OnSetFilter match with PassFilter and SetFilter in TMULCtrl,
      and by default will be assigned those functions. They can be redirected
      to other functions if required by particular descendant classes. }
    property OnFilter: TSortViewOnFilter read FOnFilter write FOnFilter;
    property OnSetFilter: TSortViewOnSetFilter read FOnSetFilter write FOnSetFilter;

    property IsBuildingFile: Boolean read FIsBuildingFile;

    property HostPanel: TWinControl read FHostPanel write FHostPanel;
  end;

{ Returns the sepcified list type in a format suitable for a search string }
function ListTypeKey(ListType: TSortViewListType): Char;

{ Returns the specified user id padded to make it suitable for searching
  and storing. }
function FullUserIDKey(Key: string): Str30;

{ Returns the specified description padded to make it suitable for searching
  and storing. }
function FullDescrKey(Key: string): Str100;

implementation

uses Graphics, Dialogs, Windows, BtrvU2, VarConst, APIUtil, EtStrU, SavePos,
     StrUtil, SQLUtils, SysU1, SQLRep_Config;

// =============================================================================

function ListTypeKey(ListType: TSortViewListType): Char;
begin
  Result := Char(Ord(ListType));
end;

// -----------------------------------------------------------------------------

function FullUserIDKey(Key: string): Str30;
var
  Len: Integer;
begin
  Len := SizeOf(SortViewRec.svrUserId) - 1;
  Result := Copy(Key + StringOfChar(' ', Len), 1, Len);
end;

// -----------------------------------------------------------------------------

function FullDescrKey(Key: string): Str100;
var
  Len: Integer;
begin
  Len := SizeOf(SortViewRec.svrDescr) - 1;
  Result := Copy(Key + StringOfChar(' ', Len), 1, Len);
end;

// =============================================================================
// TSortView
// =============================================================================

function TBaseSortView.Add: Integer;
var
  Added: Boolean;
begin
  Result := 0;
  Added := False;
  while not Added do
  begin
    SortViewRec.svrViewId := NextViewID;
    SortViewRec.svrListType := ListType;
    SortViewRec.svrUserId := FullUserIDKey(SortViewRec.svrUserId);
    SortViewRec.svrDescr := FullDescrKey(SortViewRec.svrDescr);
    Result := Add_Rec(F[SortViewF], SortViewF, RecPtr[SortViewF]^, SVViewK);
    if (Result = 0) then
      Added := True
    { If Result = 5 we have had a race condition where someone else has managed
      to add a Sort View using the View ID that we just obtained. In this case,
      go round the loop and try again. For any other error, simply return the
      error code. }
    else if (Result <> 5) then
      break;
  end;
end;

// -----------------------------------------------------------------------------

function TBaseSortView.AdjustSortDateStringValue(
  const SortString: ShortString;
  Sort: TSortViewSortInfoRecType): ShortString;
begin
  Result := AdjustSortStringValue(SortString, Sort);
end;

// -----------------------------------------------------------------------------

function TBaseSortView.AdjustSortFloatValue(Value: double;
  Sort: TSortViewSortInfoRecType): ShortString;
var
  i: Integer;
  MustInvert: Boolean;
const
  ReversedNumbers: array[45..57] of Char = ('-', '.', '/', '9', '8', '7', '6', '5', '4', '3', '2', '1', '0');
begin
  Result := FormatFloat('000000000000.000000', Abs(Value));

  // Adjust the sort string to ensure the correct order
  MustInvert := ((Sort.svsAscending) and (Value < 0)) or
                ((not Sort.svsAscending) and (Value > 0));
  if MustInvert then
  begin
    for i := 1 to Length(Result) do
    begin
      Result[i] := ReversedNumbers[Ord(Result[i])];
    end;
  end;

  if (Value = 0) then
  begin
    if Sort.svsAscending then
      Result := '+' + Result
    else
      Result := '-' + Result;
  end
  else if (Value < 0) then
  begin
    if Sort.svsAscending then
      Result := '(' + Result + ')'
    else
      Result := '-' + Result;
  end
  else
    Result := '+' + Result;

end;

// -----------------------------------------------------------------------------

function TBaseSortView.AdjustSortStringValue(const SortString: ShortString;
  Sort: TSortViewSortInfoRecType): ShortString;
begin
  if not Sort.svsAscending then
    Result := InvertSortStringValue(SortString)
  else
    Result := SortString;
  Result := PadString(psRight, Result, ' ', SizeOf(SortTempRec.svtField1));
end;

// -----------------------------------------------------------------------------

function TBaseSortView.Apply: Integer;
begin
  CancelBuild;
  Result := BuildTempFile;
  FActiveViewID := SortViewRec.svrViewId;
end;

// -----------------------------------------------------------------------------

class function TBaseSortView.BaseTempFileName: string;
var
  BaseWorkstationName: string;
  WorkstationName: string;
  CharPos: Integer;
begin
  BaseWorkstationName := WinGetComputerName;
  for CharPos := 1 to Length(BaseWorkstationName) do
  begin
    if (Ord(BaseWorkstationName[CharPos]) in [48..57, 65..90, 97..122]) then
      WorkstationName := WorkStationName + BaseWorkstationName[CharPos];
  end;
  WorkstationName := StringOfChar('_', 10) + WorkstationName;
  Result := 'SORTV' + Copy(WorkstationName, Length(WorkstationName) - 9, 10);
end;

// -----------------------------------------------------------------------------

function TBaseSortView.BuildTempFile: Integer;
var
  FuncRes: Integer;
  Folio, Count: Integer;
  Key: Str255;
//  RecCount: Integer;
  RecModulus: Integer;
  ValidationResult: TSortViewValidationErrorType;
  Cancelled: Boolean;

  Qry: string;
  CompanyCode: string;
begin
  Result := 0;
  FIsBuildingFile := True;
  ValidationResult := ValidateForApply(SortViewRec.svrViewID);
  if (ValidationResult = svveOk) then
  begin
    try
      CloseView;
      Result := CreateTempFile;
      if (Result = 0) then
      begin
        try
          if (FHostPanel <> nil) and (FProgressPanel = nil) then
          begin
            FProgressPanel := TSortViewProgressPanel.Create(nil);
            FProgressPanel.Parent := FHostPanel;
            FProgressPanel.UpdateLayout(FHostPanel);
            FProgressPanel.Show;
          end
          else if (FProgressPanel <> nil) then
            FProgressPanel.Cancelled := False;
          RecModulus := 10;
{
          RecCount := Used_Recs(F[HostListFileNo], HostListFileNo);
          if (RecCount > 100) then
          begin
            RecModulus := RecCount div 100;
            if (RecModulus = 0) then
              RecModulus := 10;
          end;
}
          Folio := 1;
          FListID := NextListID;
          Count := 0;
          { CJS - 2012-07-20: ABSEXCH-12962 - Sort View SQL Mods }
          if UseStoredProcedure then
          begin
            Key := HostListSearchKey;
            CompanyCode := SQLUtils.GetCompanyCode(SetDrive);
            Qry := Format('EXEC [COMPANY].isp_SortView %d, %d, %d, ''%s'', ''%s''', [SortViewRec.svrViewID, 1900 + GetLocalPr(0).CYr, GetLocalPr(0).CPr, Key, Key]);
            SQLCaller.Select(Qry, CompanyCode);
            if (SQLCaller.ErrorMsg <> '') then
              raise Exception.Create('Error accessing Sort View details: ' + SQLCaller.ErrorMsg);
            PrepareFields;
            Cancelled := False;
            while (not SQLCaller.Records.Eof) and (not Cancelled) do
            begin
              if (FProgressPanel = nil) or (FProgressPanel.Cancelled) then
                Cancelled := True
              else if ((Count mod RecModulus) = 0) then
                FProgressPanel.UpdateProgress(Count);
              Count := Count + 1;
              if ((SyncFilter = 0) and CheckListFilter) then
              begin
                FillChar(SortTempRec, SizeOf(SortTempRec), #0);
                SortTempRec.svtFolio  := Folio;
                SortTempRec.svtListId := ListID;
                SortTempRec.svtField1 := LJVar(GetSQLSortValue(Sorts[1]^), SizeOf(SortTempRec.svtField1) - 1);
                SortTempRec.svtField2 := LJVar(GetSQLSortValue(Sorts[2]^), SizeOf(SortTempRec.svtField2) - 1);
                SortTempRec.svtSourceDataStr := GetSQLSourceDataStr;
                SortTempRec.svtSourceDataFolio := GetSQLSourceDataFolio;
                SortTempRec.svtSourceLineNo := GetSQLSourceLineNo;
                FuncRes := Add_Rec(F[SortTempF], SortTempF, RecPtr[SortTempF]^, STFolioK);
                if (FuncRes <> 0) then
                  break;
                Folio := Folio + 1;
              end;
              SQLCaller.Records.Next;
            end;
            SQLCaller.Close;
          end
          else
          begin
            Key := HostListSearchKey;
            FuncRes := Find_Rec(B_GetGEq, F[HostListFileNo], HostListFileNo, RecPtr[HostListFileNo]^, HostListIndexNo, Key);
            Cancelled := False;
            while (FuncRes = 0) and (Copy(Key, 1, Length(HostListSearchKey)) = HostListSearchKey) and (not Cancelled) do
            begin
              if (FProgressPanel = nil) or (FProgressPanel.Cancelled) then
                Cancelled := True
              else if ((Count mod RecModulus) = 0) then
                FProgressPanel.UpdateProgress(Count);
              Count := Count + 1;
  //            Application.ProcessMessages;
              if ((SyncFilter = 0) and CheckListFilter and CheckSortViewFilter) then
              begin
                FillChar(SortTempRec, SizeOf(SortTempRec), #0);
                SortTempRec.svtFolio  := Folio;
                SortTempRec.svtListId := ListID;
                SortTempRec.svtField1 := LJVar(GetSortValue(Sorts[1]^), SizeOf(SortTempRec.svtField1) - 1);
                SortTempRec.svtField2 := LJVar(GetSortValue(Sorts[2]^), SizeOf(SortTempRec.svtField2) - 1);
                SortTempRec.svtSourceDataStr := GetSourceDataStr;
                SortTempRec.svtSourceDataFolio := GetSourceDataFolio;
                SortTempRec.svtSourceLineNo := GetSourceLineNo;
                FuncRes := Add_Rec(F[SortTempF], SortTempF, RecPtr[SortTempF]^, STFolioK);
                if (FuncRes <> 0) then
                  break;
      //            raise Exception.Create('Failed to add record to temporary file, error #' + IntToStr(FuncRes));
                Folio := Folio + 1;
              end;
              FuncRes := Find_Rec(B_GetNext, F[HostListFileNo], HostListFileNo, RecPtr[HostListFileNo]^, HostListIndexNo, Key);
            end;
          end;
        finally
          if (FProgressPanel <> nil) then
            FreeAndNil(FProgressPanel);
        end;
      end;
    finally
      FIsBuildingFile := False;
    end;
  end
  else
    FIsBuildingFile := False;

{
  else
    raise Exception.Create('SortView record error - ' + SortViewValidationErrorMsg[ValidationResult]);
}
end;

// -----------------------------------------------------------------------------

procedure TBaseSortView.CancelBuild;
begin
  if IsBuildingFile and (FProgressPanel <> nil) then
  begin
    SendMessage(FProgressPanel.Handle, WM_CANCEL_BUILDFILE, 0, 0);
  end;
end;

// -----------------------------------------------------------------------------

function TBaseSortView.CheckListFilter: Boolean;
begin
  if Assigned(FOnFilter) and Assigned(FOnSetFilter) then
    Result := OnFilter(OnSetFilter)
  else
    Result := True;
end;

// -----------------------------------------------------------------------------

function TBaseSortView.CheckSortViewFilter : Boolean;
var
  iFilter: Integer;
begin
  Result := True;
  with SortViewRec do
  begin
    For iFilter := Low(svrFilters) To High(svrFilters) Do
    Begin
      If svrFilters[iFilter].svfEnabled Then
      Begin
        case GetFilterDataType (svrFilters[iFilter].svfFieldId) Of
          fdtString  : Result := Result And EvaluateStringFilter(svrFilters[iFilter]);
          fdtFloat   : Result := Result And EvaluateFloatFilter(svrFilters[iFilter]);
        else
          raise Exception.Create ('CheckSortViewFilter - Invalid Data Type');
        end; // Case GetFilterDataType
      End; // If svrFilters[iFilter].svfEnabled

      If (Not Result) Then
        Break;
    end; // For iFilter
  end;
end;

// -----------------------------------------------------------------------------

class procedure TBaseSortView.ClearLockFiles;
var
  SearchRec: TSearchRec;
  Found: Integer;
  FileList: TStringList;
  i: Integer;
begin
  FileList := TStringList.Create;
  try
    // Build a list of all the temporary files for this workstation.
    Found := FindFirst(SetDrive + 'SWAP\' + BaseTempFileName + '*', 0, SearchRec);
    try
      while (Found = 0) do
      begin
        FileList.Add(SearchRec.Name);
        Found := FindNext(SearchRec);
      end;
    finally
      SysUtils.FindClose(SearchRec);
    end;
    // Attempt to delete the files.
    for i := 0 to FileList.Count - 1 do
    begin
      if SysUtils.DeleteFile(SetDrive + 'SWAP\' + SearchRec.Name) then
        DeleteTable(SetDrive + 'SWAP\' + SearchRec.Name + '.dat');
    end;
  finally
    FileList.Free;
  end;
end;

// -----------------------------------------------------------------------------

function TBaseSortView.CloseView: Integer;

  {$IFDEF EXSQL}
  function SQLDeleteView: Integer;
  var
    Company : ShortString;
    Where : ANSIString;
  begin
    //HV 08/03/2016 2016-R2 ABSEXCH-13367: When applying sort view to multiple tabs, failed to delete sort views,in traders list.
    If TableExists('SWAP\' + TempFileName) Then
    begin
      Company := GetCompanyCode(SetDrive);
      Where := '(' + GetDBColumnName('SWAP\' + TempFileName, 'f_svt_list_id', '') + ' = ' + IntToStr(FListID) + ')';
      Result := DeleteRows(Company, 'SWAP\' + TempFileName, Where);
    end
    else Result := 0;
  end;
  {$ENDIF}

var
  FuncRes: Integer;
  Key: Str255;
begin
  Result := 0;
  if (FListID > 0) then
  begin
    {$IFDEF EXSQL}
    if (SQLUtils.UsingSQL) then
    begin
      Result := SQLDeleteView;
      if (Result <> 0) then
        if SQLUtils.UsingSQL then
          raise Exception.Create('Failed to delete the sort records: ' + SQLUtils.GetSQLErrorInformation(Result))
        else
          raise Exception.Create('Failed to delete the sort records, error ' + IntToStr(Result));
    end
    else
    {$ENDIF}
    begin                             
      Move(FListID, Key[1], SizeOf(FListID));
      Key[0] := Chr(SizeOf(FListID));
      Result := Find_Rec(B_GetGEq, F[SortTempF], SortTempF, RecPtr[SortTempF]^, STFolioK, Key);
      while ((Result = 0) and (SortTempRec.svtListId = FListID)) do
      begin
        Result := Delete_Rec(F[SortTempF], SortTempF, STFolioK);
        if (Result = 0) then
          Result := Find_Rec(B_GetNext, F[SortTempF], SortTempF, RecPtr[SortTempF]^, STFolioK, Key);
      end;
    end;
    {$IFDEF EXSQL}


      if (SQLUtils.UsingSQL) then
      begin
        //TG 08/03/2016 2016-R2 ABSEXCH-13367: When applying sort view to multiple tabs, failed to delete sort views,in traders list.
        If TableExists(SetDrive + FileNames[SortTempF]) Then
        begin
          Result := Close_File(F[SortTempF]);
          Result := Open_File(F[SortTempF], SetDrive + FileNames[SortTempF], 1 * Ord(AccelMode));
        end;
        if (Result <> 0) then
          raise Exception.Create('Failed to clear Emulator cache, error ' + IntToStr(Result));
      end;
    {$ENDIF}
{
    Move(FListID, Key[1], SizeOf(FListID));
    Key[0] := Chr(SizeOf(FListID));
    Result := Find_Rec(B_GetGEq, F[SortTempF], SortTempF, RecPtr[SortTempF]^, STFolioK, Key);
    if not (Result in [4, 9]) and (SortViewRec.svrViewId = FListID) then
      raise Exception.Create('Failed to delete the sort records');
}
    FActiveViewID := -1;
    FListID := -1;
  end
  else
    {
      CJS: 28/03/2011 - ABSEXCH-10106
      No SortView is active. Return the 'table closed' error code, so that the
      calling routine knows this.
    }
    Result := 3;
end;

// -----------------------------------------------------------------------------

constructor TBaseSortView.Create;
begin
  inherited Create;
  RemoveTempFiles;
  FListID := -1;
  FActiveViewID := -1;
  FUserDefaults := TUserSortViewDefaults.Create;
  FHostLongIntLink := False;
  { CJS - 2012-07-20: ABSEXCH-12962 - Sort View SQL Mods }
  if UseStoredProcedure then
    FSQLCaller := TSQLCaller.Create(GlobalADOConnection);
end;

// -----------------------------------------------------------------------------

function TBaseSortView.CreateLockFile(Filename: string): Boolean;
begin
  Result := True;
  Try
    Assign(FLockFile, Filename);
    Rewrite(FLockFile);
    CloseFile(FLockFile);
  Except
    Result := False;
  End;
end;

// -----------------------------------------------------------------------------

function TBaseSortView.CreateTempFile: Integer;
var
  Key: Str255;
begin
  Key := '';
  if (Find_Rec(B_GetFirst, F[SortTempF], SortTempF, RecPtr[SortTempF]^, 0, Key) = 3) then
  begin
    FileNames[SortTempF] := 'SWAP\' + TempFileName;
    Result := Make_File(F[SortTempF], SetDrive + FileNames[SortTempF], FileSpecOfs[SortTempF]^, FileSpecLen[SortTempF]);
    if (Result = 0) then
      Result := Open_File(F[SortTempF], SetDrive + FileNames[SortTempF], 1 * Ord(AccelMode));
  end
  else
    Result := 0;
  if (Result = 0) and SQLUtils.UsingSQL then
    PrepareLockFile(SetDrive + 'SWAP\' + LockFileName);
end;

// -----------------------------------------------------------------------------

function TBaseSortView.Delete: Integer;
begin
  Result := 0;
  { CJS 2012-11-02 - ABSEXCH-13653 - Default Sort View details not deleted }
  // Is this view the Default for this user and sort view type?
  if FUserDefaults.FindDefault(Trim(EntryRec.Login), Self.FListType) = 0 then
  begin
    if SortViewDefaultRec.svuDefaultView = SortViewRec.svrViewID then
      // If so, delete the Default View record
      Result := Delete_Rec(F[SVUDefaultF], SVUDefaultF, SVUserK);
  end;
  // Delete the actual Sort View
  if Result = 0 then
    Result := Delete_Rec(F[SortViewF], SortViewF, SVViewK);
end;

// -----------------------------------------------------------------------------

destructor TBaseSortView.Destroy;
var
  FuncRes: Integer;
begin
  FuncRes := CloseView;
  if not (FuncRes in [0, 3, 9]) then
    ShowMessage('Failed to close Sort View: error #' + IntToStr(FuncRes));
  {
    CJS: 28/03/2011 - ABSEXCH-10106
    Only close and delete the temporary file if a Sort View was actually
    active.
  }
  if (FuncRes <> 3) then
  begin
    if (SQLUtils.UsingSQL and ReleaseLockFile(SetDrive + 'SWAP\' + LockFileName)) then
    begin
      Close_File(F[SortTempF]);
      DeleteTable(SetDrive + 'SWAP\' + TempFileName);
    end
    else if (Used_Recs(F[SortTempF], SortTempF) = 0) then
    begin
      Close_File(F[SortTempF]);
      DeleteTable(SetDrive + 'SWAP\' + TempFileName);
    end;
  end;
  FreeAndNil(FUserDefaults);

  { CJS - 2012-07-20: ABSEXCH-12962 - Sort View SQL Mods }
  if UseStoredProcedure then
    FreeAndNil(FSQLCaller);
    
  inherited;
end;

// -----------------------------------------------------------------------------

function TBaseSortView.EvaluateFloatFilter(
  const Filter: TSortViewFilterInfoRecType): Boolean;
var
  FilterValue, FieldValue: Double;
begin
  FieldValue := GetFloatFilterValue(Filter.svfFieldId);
  FilterValue := StrToFloat(Filter.svfValue);
  case Filter.svfComparison of
    svfcEqual:              Result := (FieldValue = FilterValue);
    svfcNotEqual:           Result := (FieldValue <> FilterValue);
    svfcLessThan:           Result := (FieldValue < FilterValue);
    svfcLessThanOrEqual:    Result := (FieldValue <= FilterValue);
    svfcGreaterThan:        Result := (FieldValue > FilterValue);
    svfcGreaterThanOrEqual: Result := (FieldValue >= FilterValue);
  else
    Result := False; // Invalid comparison type
  end;
end;

// -----------------------------------------------------------------------------
{ PL 04/01/2017 2017-R1 ABSEXCH-17809 : added this Virtual function to resolve
 filter values based on svfFieldId it will return the same values which we
 passed in parameters for other class but in TCustomerLedgerSortView class
 we have an overridden routin }

function TBaseSortView.GetResolvedFilterValue(aFilterId : Integer; aFilterValue:String) : String;
begin
  Result := aFilterValue;
end;

// -----------------------------------------------------------------------------

function TBaseSortView.EvaluateStringFilter(
  const Filter: TSortViewFilterInfoRecType): Boolean;
var
  FilterValue, FieldValue: string;
  PadTo: Integer;
begin
  PadTo := SizeOf(Filter.svfValue) - 1;
  FieldValue := Lowercase(PadString(psRight, GetStringFilterValue(Filter.svfFieldId), ' ', PadTo));
  //PL 04/01/2017 2017-R1 ABSEXCH-17809 : Default list values for Status field in Sort View of Trader > Ledger is not correct.
  FilterValue := GetResolvedFilterValue(Filter.svfFieldId,Filter.svfValue);
  FilterValue := Lowercase(PadString(psRight, FilterValue, ' ', PadTo));

  case Filter.svfComparison of
    svfcEqual:              Result := (FieldValue = FilterValue);
    svfcNotEqual:           Result := (FieldValue <> FilterValue);
    svfcLessThan:           Result := (FieldValue < FilterValue);
    svfcLessThanOrEqual:    Result := (FieldValue <= FilterValue);
    svfcGreaterThan:        Result := (FieldValue > FilterValue);
    svfcGreaterThanOrEqual: Result := (FieldValue >= FilterValue);
    svfcStartsWith:         Result := (Copy(Trim(FieldValue), 1, Length(Trim(FilterValue))) = Trim(FilterValue));
    svfcContains:           Result := (Pos(Trim(FilterValue), FieldValue) > 0);
  else
    Result := False; // Invalid comparison type
  end;
end;

// -----------------------------------------------------------------------------

function TBaseSortView.Find(Key: Str255): Integer;
begin
  FSearchKey := Key;
  Result := Find_Rec(B_GetGEq, F[SortViewF], SortViewF, RecPtr[SortViewF]^, SVListTypeK, FSearchKey);
end;

// -----------------------------------------------------------------------------

function TBaseSortView.FindByID(ViewID: Integer): Integer;
var
  Key: Str255;
begin
  FillChar(Key, SizeOf(Key), 0);
  Move(ViewID, Key[1], SizeOf(ViewID));
  Key[0] := Chr(SizeOf(ViewID));
  Result := Find_Rec(B_GetEq, F[SortViewF], SortViewF, RecPtr[SortViewF]^, SVViewK, Key);
end;

// -----------------------------------------------------------------------------

function TBaseSortView.First: Integer;
begin
  Result := Find_Rec(B_GetFirst, F[SortViewF], SortViewF, RecPtr[SortViewF]^, SVListTypeK, FSearchKey);
end;

// -----------------------------------------------------------------------------

function TBaseSortView.GetFieldIDFromListIndex(
  ItemIndex: Integer): Integer;
begin
  Result := ItemIndex;
end;

// -----------------------------------------------------------------------------

function TBaseSortView.GetFilterCount: LongInt;
begin
  Result := High(SortViewRec.svrFilters);
end;

// -----------------------------------------------------------------------------

function TBaseSortView.GetFilters(Index: Integer): PSortViewFilterInfoRecType;
begin
  if (Index > 0) and (Index <= Length(SortViewRec.svrFilters)) then
    Result := @SortViewRec.svrFilters[Index]
  else
    raise Exception.Create('Invalid index for Filter: ' + IntToStr(Index));
end;

// -----------------------------------------------------------------------------

function TBaseSortView.GetListIndexFromFieldID(FieldID: Integer): Integer;
begin
  Result := FieldID;
end;

function TBaseSortView.GetListType: TSortViewListType;
begin
  Result := FListType;
end;

// -----------------------------------------------------------------------------

function TBaseSortView.GetSorts(Index: Integer): PSortViewSortInfoRecType;
begin
  if (Index > 0) and (Index < Length(SortViewRec.svrSorts)) then
    Result := @SortViewRec.svrSorts[Index]
  else
    raise Exception.Create('Invalid index for Sort: ' + IntToStr(Index));
end;

// -----------------------------------------------------------------------------

function TBaseSortView.GetSortViewDesc: ShortString;
begin
  Result := FullDescrKey(SortViewRec.svrDescr);
end;

// -----------------------------------------------------------------------------

function TBaseSortView.GetUserID: Str30;
begin
  Result := SortViewRec.svrUserId;
end;

// -----------------------------------------------------------------------------

function TBaseSortView.GlobalSearchKey: Str255;
begin
  Result := ListTypeSearchKey + FullUserIDKey('');
end;

// -----------------------------------------------------------------------------

function TBaseSortView.InList: Boolean;
begin
  Result := (SortTempRec.svtListId = self.FListID);
end;

// -----------------------------------------------------------------------------

function TBaseSortView.InvertSortStringValue(
  const SortString: ShortString): ShortString;
var
  UppercaseStr: string;
  i: Integer;
begin
  Result := '';
  UppercaseStr := Uppercase(SortString);
  for i := 1 To Length(UppercaseStr) Do
    Result := Result + Chr(255 - Ord(UppercaseStr[i]));
end;

// -----------------------------------------------------------------------------

function TBaseSortView.Last: Integer;
begin
  Result := Find_Rec(B_GetLast, F[SortViewF], SortViewF, RecPtr[SortViewF]^, SVListTypeK, FSearchKey);
end;

// -----------------------------------------------------------------------------

function TBaseSortView.ListTypeSearchKey: Str255;
begin
  Result := Chr(Ord(ListType));
end;

// -----------------------------------------------------------------------------

{ CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View }
function TBaseSortView.LoadDefaultSortView: Boolean;
var
  FuncRes: Integer;
begin
  Result := False;

  if SQLReportsConfiguration.UseDefaultSortViews then
  begin
    { Try to find a default for the logged-in user and the list type }
    if FUserDefaults.FindDefault(Trim(EntryRec.Login), Self.FListType) = 0 then
    begin
      { Found a default. Retrieve the ID of the default Sort View (note that an
        entry is only added to the Default Sort Views when a default is actually
        set for this user and Sort View type, so if a record exists, it will hold
        a View ID). }
      FActiveViewID := FUserDefaults.DefaultView;
      FuncRes := self.FindByID(FActiveViewID);
      { If the matching Sort View record is found, we can return success (if a
        record is not found, this suggests that something is amiss, but there is
        little that can be done about it at this point). }
      if FuncRes = 0 then
        Result := True;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TBaseSortView.LockFilename: string;
begin
  Result := ChangeFileExt(TempFileName, '');
end;

// -----------------------------------------------------------------------------

function TBaseSortView.Next: Integer;
begin
  Result := Find_Rec(B_GetNext, F[SortViewF], SortViewF, RecPtr[SortViewF]^, SVListTypeK, FSearchKey);
end;

// -----------------------------------------------------------------------------

function TBaseSortView.NextListID: LongInt;
var
  FuncRes: LongInt;
  Key: Str255;
  RecSave: TBtrieveSavePosition;
  Saved: Boolean;
begin
  Result := 1;
//  FuncRes := Used_Recs(F[SortTempF], SortTempF);
  RecSave := TBtrieveSavePosition.Create;
  try
    // Store the record position.
    Saved := RecSave.SaveFilePosition(SortTempF, STFolioK);
    if (Saved) or (RecSave.spStatus = 8) then
    begin
      RecSave.SaveDataBlock(RecPtr[SortTempF], FileRecLen[SortTempF]);
      // Find the last record and return the incremented List ID from it.
      Key := '';
      FuncRes := Find_Rec(B_GetLast, F[SortTempF], SortTempF, RecPtr[SortTempF]^, STFolioK, Key);
      if (FuncRes = 0) then
        Result := SortTempRec.svtListId + 1;
      // Restore the record position.
      if Saved and (RecSave.spRecAddr > 0) and not RecSave.RestoreSavedPosition then
        raise Exception.Create('TSortView.NextListID: Failed to restore record position, error #' + IntToStr(RecSave.spStatus));
      RecSave.RestoreDataBlock(RecPtr[SortTempF]);
    end
    else
      raise Exception.Create('TSortView.NextListID: Failed to save record position, error #' + IntToStr(RecSave.spStatus));
  finally
    RecSave.Free;
  end;
end;

// -----------------------------------------------------------------------------

function TBaseSortView.NextViewID: LongInt;
var
  FuncRes: LongInt;
  Key: Str255;
  RecSave: TBtrieveSavePosition;
  Saved: Boolean;
begin
  Result := 1;
  RecSave := TBtrieveSavePosition.Create;
  try
    // Store the record position.
    Saved := RecSave.SaveFilePosition(SortViewF, SVViewK);
    if (Saved) or (RecSave.spStatus = 8) then
    begin
      RecSave.SaveDataBlock(RecPtr[SortViewF], FileRecLen[SortViewF]);
      // Find the last record and return the incremented View ID from it.
      Key := '';
      FuncRes := Find_Rec(B_GetLast, F[SortViewF], SortViewF, RecPtr[SortViewF]^, SVViewK, Key);
      if (FuncRes = 0) then
        Result := SortViewRec.svrViewId + 1;
      // Restore the record position.
      if Saved and (RecSave.spRecAddr > 0) and not RecSave.RestoreSavedPosition then
        raise Exception.Create('TSortView.NextViewID: Failed to restore record position, error #' + IntToStr(RecSave.spStatus));
      RecSave.RestoreDataBlock(RecPtr[SortViewF]);
    end
    else
      raise Exception.Create('TSortView.NextViewID: Failed to save record position, error #' + IntToStr(RecSave.spStatus));
  finally
    RecSave.Free;
  end;
end;

// -----------------------------------------------------------------------------

procedure TBaseSortView.OpenLockFile(Filename: string);
begin
  AssignFile(FLockFile, Filename);
  Reset(FLockFile);
end;

// -----------------------------------------------------------------------------

procedure TBaseSortView.PrepareLockFile(Filename: string);
begin
  if SysUtils.FileExists(Filename) or CreateLockFile(Filename) then
    OpenLockFile(Filename);
end;

// -----------------------------------------------------------------------------

function TBaseSortView.Prior: Integer;
begin
  Result := Find_Rec(B_GetPrev, F[SortViewF], SortViewF, RecPtr[SortViewF]^, SVListTypeK, FSearchKey);
end;

// -----------------------------------------------------------------------------

function TBaseSortView.Refresh: Integer;
var
  StoredViewID: Integer;
begin
  StoredViewID := ActiveViewID;
  Result := FindByID(ActiveViewID);
  if (Result = 0) then
  begin
    CancelBuild;
    Result := BuildTempFile;
    FActiveViewID := StoredViewID;
  end;
end;

// -----------------------------------------------------------------------------

function TBaseSortView.ReleaseLockFile(Filename: string): Boolean;
begin
{$I-}
  CloseFile(FLockFile);
  if IOResult = 0 then
    Result := SysUtils.DeleteFile(Filename)
  else
    Result := False;
{$I+}
end;

// -----------------------------------------------------------------------------

class function TBaseSortView.RemoveTempFiles: Boolean;
var
  SearchRec: TSearchRec;
  Found: Integer;
  FileList: TStringList;
  i: Integer;
begin
  Result := True;
  FileList := TStringList.Create;
  try
    // Build a list of all the temporary files for this workstation.
    Found := FindFirst(SetDrive + 'SWAP\' + BaseTempFileName + '*.dat', 0, SearchRec);
    try
      while (Found = 0) do
      begin
        FileList.Add(SearchRec.Name);
        Found := FindNext(SearchRec);
      end;
    finally
      SysUtils.FindClose(SearchRec);
    end;
    // Attempt to delete the files.
    for i := 0 to FileList.Count - 1 do
    begin
      SysUtils.DeleteFile(SetDrive + 'SWAP\' + FileList[i]);
    end;
    // If any of the files still exist, report the failure.
    for i := 0 to FileList.Count - 1 do
    begin
      if FileExists(SetDrive + 'SWAP\' + FileList[i]) then
      begin
        Result := False;
        break;
      end;
    end;
  finally
    FileList.Free;
  end;
  ClearLockFiles;
end;

// -----------------------------------------------------------------------------

procedure TBaseSortView.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;
end;

// -----------------------------------------------------------------------------

procedure TBaseSortView.SetHostListFileNo(const Value: LongInt);
begin
  FHostListFileNo := Value;
end;

// -----------------------------------------------------------------------------

procedure TBaseSortView.SetHostListIndexNo(const Value: LongInt);
begin
  FHostListIndexNo := Value;
end;

// -----------------------------------------------------------------------------

procedure TBaseSortView.SetHostListSearchKey(const Value: ShortString);
begin
  FHostListSearchKey := Value;
end;

// -----------------------------------------------------------------------------

procedure TBaseSortView.SetListDesc(const Value: ShortString);
begin
  FListDesc := Value;
end;

// -----------------------------------------------------------------------------

procedure TBaseSortView.SetListType(const Value: TSortViewListType);
begin
  FListType := Value;
end;

// -----------------------------------------------------------------------------

procedure TBaseSortView.SetSearchKey(const Value: str255);
begin
  FSearchKey := Value;
end;

// -----------------------------------------------------------------------------

procedure TBaseSortView.SetSortCount(const Value: LongInt);
begin
  FSortCount := Value;
end;

// -----------------------------------------------------------------------------

procedure TBaseSortView.SetSortViewDesc(const Value: ShortString);
begin
  SortViewRec.svrDescr := FullDescrKey(Value);
end;

// -----------------------------------------------------------------------------

procedure TBaseSortView.SetUserID(const Value: Str30);
begin
  SortViewRec.svrUserId := FullUserIDKey(Value);
end;

// -----------------------------------------------------------------------------

function TBaseSortView.SyncFilter: Integer;
begin
  Result := 0;
end;

// -----------------------------------------------------------------------------

function TBaseSortView.TempFileName: string;
begin
  Result := BaseTempFileName + '_' + Format('%.10d', [GetCurrentProcessId]) + '.dat';
end;

// -----------------------------------------------------------------------------

function TBaseSortView.Update: Integer;
begin
  Result := Put_Rec(F[SortViewF], SortViewF, RecPtr[SortViewF]^, SVViewK);
end;

// -----------------------------------------------------------------------------

function TBaseSortView.UserSearchKey: Str255;
begin
  Result := ListTypeKey(SortViewRec.svrListType) + FullUserIDKey(SortViewRec.svrUserId);
end;

// -----------------------------------------------------------------------------

function TBaseSortView.UseStoredProcedure: Boolean;
begin
  Result := SQLUtils.UsingSQLAlternateFuncs;
end;

// -----------------------------------------------------------------------------

function TBaseSortView.ValidateForAdd: TSortViewValidationErrorType;
var
  FuncRes: LongInt;
  Key: Str255;
  RecSave: TBtrieveSavePosition;
  Saved: Boolean;
begin
  { When adding a record, the description and primary sort must be set, and the
    description must be unique for the current user and list type. }
  Result := ViewIsComplete;
  if (Result = svveOk) then
    Result := ViewIsValid;
  if (Result = svveOk) then
  begin
    RecSave := TBtrieveSavePosition.Create;
    try
      // Store the record position.
      Saved := RecSave.SaveFilePosition(SortViewF, SVViewK);
      if (Saved) or (RecSave.spStatus = 8) then
      begin
        RecSave.SaveDataBlock(RecPtr[SortViewF], FileRecLen[SortViewF]);
        Key := UserSearchKey + FullDescrKey(SortViewRec.svrDescr);
        FuncRes := Find_Rec(B_GetEq, F[SortViewF], SortViewF, RecPtr[SortViewF]^, SVListTypeK, Key);
        if (FuncRes = 0) then
          Result := svveDuplicate;
        // Restore the record position.
        if Saved and (RecSave.spRecAddr > 0) and not RecSave.RestoreSavedPosition then
          raise Exception.Create('TSortView.ValidateForAdd: Failed to restore record position, error #' + IntToStr(RecSave.spStatus));
        RecSave.RestoreDataBlock(RecPtr[SortViewF]);
      end
      else
        raise Exception.Create('TSortView.ValidateForAdd: Failed to save record position, error #' + IntToStr(RecSave.spStatus));
    finally
      RecSave.Free;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TBaseSortView.ValidateForApply(
  ViewID: Integer): TSortViewValidationErrorType;
begin
  Result := svveOk;
end;

// -----------------------------------------------------------------------------

function TBaseSortView.ValidateForEdit(
  ViewID: Integer): TSortViewValidationErrorType;
var
  FuncRes: LongInt;
  Key: Str255;
  RecSave: TBtrieveSavePosition;
  Saved: Boolean;
begin
  Result := ViewIsComplete;
  if (Result = svveOk) then
    Result := ViewIsValid;
  if (Result = svveOk) then
  begin
    RecSave := TBtrieveSavePosition.Create;
    try
      // Store the record position.
      Saved := RecSave.SaveFilePosition(SortViewF, SVViewK);
      if (Saved) or (RecSave.spStatus = 8) then
      begin
        RecSave.SaveDataBlock(RecPtr[SortViewF], FileRecLen[SortViewF]);
        Key := UserSearchKey + FullDescrKey(SortViewRec.svrDescr);
        FuncRes := Find_Rec(B_GetEq, F[SortViewF], SortViewF, RecPtr[SortViewF]^, SVListTypeK, Key);
        if (FuncRes = 0) and (SortViewRec.svrViewId <> ViewID) then
          Result := svveDuplicate;
        // Restore the record position.
        if Saved and (RecSave.spRecAddr > 0) and not RecSave.RestoreSavedPosition then
          raise Exception.Create('TSortView.ValidateForEdit: Failed to restore record position, error #' + IntToStr(RecSave.spStatus));
        RecSave.RestoreDataBlock(RecPtr[SortViewF]);
      end
      else
        raise Exception.Create('TSortView.ValidateForEdit: Failed to save record position, error #' + IntToStr(RecSave.spStatus));
    finally
      RecSave.Free;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TBaseSortView.ViewIsComplete: TSortViewValidationErrorType;
var
  iFilter: Integer;
begin
  Result := svveOk;
  if (Trim(SortViewRec.svrDescr) = '') then
    Result := svveNoDescription
  else if (SortViewRec.svrSorts[1].svsFieldId < 0) then
    Result := svveNoPrimarySort
  else
  begin
    with SortViewRec do
    begin
      for iFilter := Low(svrFilters) to High(svrFilters) do
      begin
        if svrFilters[iFilter].svfEnabled and
           (svrFilters[iFilter].svfComparison = svfcNotDefined) then
        begin
          Result := svveNoCompareType;
        end; // If svrFilters[iFilter].svfEnabled
        if (Result <> svveOk) Then
          Break;
      end; // For iFilter
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TBaseSortView.ViewIsValid: TSortViewValidationErrorType;
var
  iFilter: Integer;
  TestValue: Double;
begin
  Result := svveOk;
  with SortViewRec do
  begin
    for iFilter := Low(svrFilters) to High(svrFilters) do
    begin
      if svrFilters[iFilter].svfEnabled Then
      begin
        if GetFilterDataType (svrFilters[iFilter].svfFieldId) = fdtFloat then
        begin
          try
            TestValue := StrToFloat(SortViewRec.svrFilters[iFilter].svfValue);
          except
            on EConvertError do
            begin
              Result := svveInvalidNumber;
            end;
          end;
        end;
      end; // If svrFilters[iFilter].svfEnabled
      if (Result <> svveOk) Then
        Break;
    end; // For iFilter
  end;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TUserSortViewDefaults
// =============================================================================

function TUserSortViewDefaults.Find(ForUserID: string): Integer;
begin
  FSearchKey := FullUserIDKey(ForUserID);
  Result := Find_Rec(B_GetGEq, F[SVUDefaultF], SVUDefaultF, RecPtr[SVUDefaultF]^, SVUserK, FSearchKey);
  if (SortViewDefaultRec.svuUserId <> ForUserID) then
    Result := 4;
end;

// -----------------------------------------------------------------------------

function TUserSortViewDefaults.FindDefault(ForUserID: string;
  ForListType: TSortViewListType): Integer;
begin
  FSearchKey := FullUserIDKey(ForUserID) + Char(Ord(ForListType));
  Result := Find_Rec(B_GetGEq, F[SVUDefaultF], SVUDefaultF, RecPtr[SVUDefaultF]^, SVUserK, FSearchKey);
  if ((SortViewDefaultRec.svuUserId <> FullUserIDKey(ForUserID)) or (SortViewDefaultRec.svuListType <> ForListType)) then
    Result := 4;
end;

// -----------------------------------------------------------------------------

function TUserSortViewDefaults.First: Integer;
begin
  FSearchKey := '';
  Result := Find_Rec(B_GetFirst, F[SVUDefaultF], SVUDefaultF, RecPtr[SVUDefaultF]^, SVUserK, FSearchKey);
end;

// -----------------------------------------------------------------------------

function TUserSortViewDefaults.GetDefaultView: LongInt;
begin
  Result := SortViewDefaultRec.svuDefaultView;
end;

// -----------------------------------------------------------------------------

function TUserSortViewDefaults.GetListType: TSortViewListType;
begin
  Result := SortViewDefaultRec.svuListType;
end;

// -----------------------------------------------------------------------------

function TUserSortViewDefaults.GetUserID: Str30;
begin
  Result := SortViewDefaultRec.svuUserId;
end;

// -----------------------------------------------------------------------------

function TUserSortViewDefaults.Last: Integer;
begin
  FSearchKey := '';
  Result := Find_Rec(B_GetLast, F[SVUDefaultF], SVUDefaultF, RecPtr[SVUDefaultF]^, SVUserK, FSearchKey);
end;

// -----------------------------------------------------------------------------

function TUserSortViewDefaults.Next: Integer;
begin
  FSearchKey := '';
  Result := Find_Rec(B_GetNext, F[SVUDefaultF], SVUDefaultF, RecPtr[SVUDefaultF]^, SVUserK, FSearchKey);
end;

// -----------------------------------------------------------------------------

function TUserSortViewDefaults.Prior: Integer;
begin
  FSearchKey := '';
  Result := Find_Rec(B_GetPrev, F[SVUDefaultF], SVUDefaultF, RecPtr[SVUDefaultF]^, SVUserK, FSearchKey);
end;

// -----------------------------------------------------------------------------

procedure TUserSortViewDefaults.SetDefaultView(const Value: LongInt);
begin
  SortViewDefaultRec.svuDefaultView := Value;
end;

// -----------------------------------------------------------------------------

procedure TUserSortViewDefaults.SetListType(const Value: TSortViewListType);
begin
  SortViewDefaultRec.svuListType := Value;
end;

// -----------------------------------------------------------------------------

procedure TUserSortViewDefaults.SetUserID(const Value: Str30);
begin
  SortViewDefaultRec.svuUserId := FullUserIDKey(Value);
end;

// -----------------------------------------------------------------------------

function TUserSortViewDefaults.Update(ForUserID: Str30; ForListType: TSortViewListType; ViewID: LongInt): Integer;
begin
  if (FindDefault(ForUserID, ForListType) = 0) then
  begin
    if (SortViewDefaultRec.svuDefaultView = ViewID) then
      SortViewDefaultRec.svuDefaultView := -1
    else
      SortViewDefaultRec.svuDefaultView := ViewID;
    Result := Put_Rec(F[SVUDefaultF], SVUDefaultF, RecPtr[SVUDefaultF]^, SVUserK);
  end
  else
  begin
    SortViewDefaultRec.svuUserId := FullUserIDKey(ForUserID);
    SortViewDefaultRec.svuListType := ForListType;
    SortViewDefaultRec.svuDefaultView := ViewID;
    Result := Add_Rec(F[SVUDefaultF], SVUDefaultF, RecPtr[SVUDefaultF]^, SVUserK);
  end;
end;

// -----------------------------------------------------------------------------

{ TSortViewProgressPanel }

procedure TSortViewProgressPanel.CancelButtonClick(Sender: TObject);
begin
  FCancelled := True;
end;

// -----------------------------------------------------------------------------

constructor TSortViewProgressPanel.Create(AOwner: TComponent);
begin
  inherited;
  DoubleBuffered := True;

  FProgressCtrl := TAdvCircularProgress.Create(self);
  FProgressCtrl.Parent := self;
  FProgressCtrl.Appearance.BackGroundColor := clNone;
  FProgressCtrl.Appearance.BorderColor := clNone;

  FTitlePanel := TPanel.Create(self);
  FTitlePanel.Parent := self;
  FTitlePanel.BevelOuter := bvNone;
  FTitlePanel.Color := clActiveCaption;
  FTitlePanel.Font.Color := clCaptionText;
  FTitlePanel.Alignment := taLeftJustify;
  FTitlePanel.Font.Name := 'Arial';
  FTitlePanel.Font.Style := [fsBold];
  FTitlePanel.Caption := ' Sorting';

  FProgressLabel := TLabel.Create(self);
  FProgressLabel.Parent := self;

  FCancelButton := TButton.Create(self);
  FCancelButton.Parent := self;
  FCancelButton.Caption := 'Cancel';
  FCancelButton.OnClick := CancelButtonClick;

end;

// -----------------------------------------------------------------------------

destructor TSortViewProgressPanel.Destroy;
begin
  FreeAndNil(FTitlePanel);
  FreeAndNil(FProgressCtrl);
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TSortViewProgressPanel.UpdateLayout(ParentControl: TWinControl);
var
  X, Y, W, H: Integer;
begin
  FCancelled := False;

  W := 128;
  H := 128;
  X := (ParentControl.ClientWidth div 2) - (W div 2);
  Y := (ParentControl.ClientHeight div 2) - (H div 2);
  SetBounds(X, Y, W, H);

  X := 4;
  Y := 4;
  W := W - 8;
  FTitlePanel.SetBounds(X, Y, W, 24); // H - (FProgressBar.Height + 12));
  FTitlePanel.Show;

  Y := FTitlePanel.Top + FTitlePanel.Height;
  H := FProgressLabel.Height;

  FProgressLabel.Autosize := False;
  FProgressLabel.SetBounds(X, Y, W, H);
  FProgressLabel.Color := clWindow;
  FProgressLabel.Caption := 'Records sorted: 0';
  FProgressLabel.Show;

  H := FProgressCtrl.Height div 2;
  W := FProgressCtrl.Width div 2;
  X := (ClientWidth div 2) - (W div 2);
  Y := FProgressLabel.Top + FProgressLabel.Height + 4;
  FProgressCtrl.SetBounds(X, Y, W, H);
  FProgressCtrl.Interval := 50;

  { This is a work-around for a bug in the TAdvCircularProgress control, which
    does not enable its internal Timer state properly if the control is created
    at run-time. (The Timer is enabled via the Loaded function, which is only
    called after loading from a Form resource.) }
  FProgressCtrl.Enabled := False;
  FProgressCtrl.Enabled := True;

  FProgressCtrl.Show;

  W := 80;
  H := 21;
  X := (ClientWidth div 2) - (W div 2);
  Y := ClientHeight - (H + 4);
  FCancelButton.SetBounds(X, Y, W, H);
  FCancelButton.Show;

end;

// -----------------------------------------------------------------------------

procedure TSortViewProgressPanel.UpdateProgress(Count: Integer);
begin
  FProgressLabel.Caption := 'Records sorted: ' + IntToStr(Count);
  Application.ProcessMessages;
end;

// -----------------------------------------------------------------------------

procedure TSortViewProgressPanel.WMCancelBuildFile(var Msg: TMessage);
begin
  FCancelled := True;
end;

end.

