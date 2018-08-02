unit uDBMultiList;

interface

uses
  Forms, Classes, Controls, uMultiList, uScrollBar, uExDatasets, uDBMColumns,
  Dialogs, Windows, StrUtil;

type
  Str20 = string[20];
  TListType = (ltPrimary, ltSort);

  TSearchColumnEvent = procedure(Sender: TObject; ColIndex: integer; var SearchStr: string) of object;
  TSortColumnEvent = procedure(Sender: TObject; ColIndex: integer; SortAsc: boolean) of object;
  TBeforeLoadEvent = procedure(Sender: TObject; var Allow: boolean) of object;
//  TAfterInitEvent = procedure(Sender: TObject) of object;//NF:

  TKeyVariant = class
    fKeyVariant: variant;
  public
    constructor Create(KeyVariant: variant); reintroduce; overload;
    property KeyVar: variant read fKeyVariant;
  end;

  TDBMultiList = class(TMultiList)
  private
    iLastKeyDown : cardinal;
    fExDatasets: TExDatasets;
    fDatasetID: integer;

    fKeyValues: TStringList;
    fSortValues: TStringList;

//    fClearSearchAt: cardinal;
    fKeyScrolling: boolean;
    fMaxRecs: integer;
    fMouseWheeling: boolean;
    fPrimaryLow: variant;
    fPrimaryHigh: variant;
    fScrollWithin: boolean;
    fSearchStr: string;
    fSelectValue: variant;
    fSortKey: string;
    fSortLow: string;
    fSortHigh: string;

    fBoolAffirmative: string;
    fBoolNegative: string;
    fFormatDate: string;
    fFormatTime: string;
    fRefreshKey: integer;

    fOnAfterLoad: TNotifyEvent;
    fOnBeforeLoad: TBeforeLoadEvent;
    fOnSearchColumn: TSearchColumnEvent;
    fOnSortColumn: TSortColumnEvent;
    fAfterInit : TNotifyEvent;//NF:
//    fOnAfterNavigate: TNotifyEvent;//NF:

    fActive : boolean; // NF: allows us to start the list manually;
    fSortColIndex : byte;   // NF: for setting starting sorted column;

    fMultiSelectedRP : TStringList;

    bDestroying : boolean;

    procedure BroadcastMaxRecs(NewMaxRecs: integer);
    procedure BuildKeyList(KeyList: TStringList; ListType: TListType; FieldName: string);
    procedure DatasetSelect(SelectType: TSelectType; NewSelected: integer);
    procedure DoSearch(ColIndex: integer; SearchVar: string);
    procedure LoadCurrentRecord;
//    procedure LoadColumns(ScrollType: TSButtonType; PrimaryHigh: variant; SortHigh: variant; ScrollDown: boolean; ScrollWithin: boolean);
    procedure LoadColumns(ScrollType: TSButtonType; PrimaryHigh: variant; SortHigh: string; ScrollDown: boolean; ScrollWithin: boolean);
    procedure LoadDBMultiList(ScrollType: TSButtonType);
    procedure LoadRecord;
    procedure LoadRecords(RetrievedAsc: boolean);
    procedure LoadShiftedDBM(ScrollType: TSButtonType);
    procedure LocateSearchValue;
//    function BuildBlockDetails(MaxRecs: integer; PrimaryHigh: variant; SortHigh: variant; Scroll: boolean; Search: boolean; Refresh: boolean): TBlockDetails;
    function BuildBlockDetails(MaxRecs: integer; PrimaryHigh: variant; SortHigh: string; Scroll: boolean; Search: boolean; Refresh: boolean): TBlockDetails;
    function ConvertVariant(ColIndex: integer; FieldValue: variant): string;
    function GetDateVariant: variant;
    function GetDateTimeVariant: variant;
    function GetFieldNames: string;
    function GetTimeVariant: variant;
//    function IsAlphaNumeric(Key: Char): boolean;
    function IsDate(TestStr: string): boolean;
    function IsDateTime(TestStr: string): boolean;
    function IsNumeric(TestStr: string; isIntegral: boolean): boolean;
    function IsTime(TestStr: string): boolean;
    function GetScrollAdjustment(Scroll: boolean): integer;
    function RefreshNeeded: boolean;
    procedure SetDataset(const Value: TExDatasets);
    procedure SetActive(const Value: boolean);
    procedure SetSortColIndex(const NewColIndex : Byte);
    procedure StartList; // NF: allows us to start the list manually;
//    procedure SetDataset(Value: TMLDimensions);
    Procedure SetSortAsc(Value : boolean);
    function GetSortAsc : boolean;
    function GetMultiSelected : TStringList;
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure PanelClick(Sender: TObject); override;
    procedure PanelColumnClick(Sender: TObject; ColIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure PanelExit(Sender: TObject); override;
    procedure PanelHeaderDblClick(ColIndex: integer); override;
    procedure PanelKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); override;
    procedure PanelKeyPress(Sender: TObject; var Key: Char); override;
    procedure PanelMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean); override;
    procedure PanelMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean); override;
    procedure PanelScrollClick(Sender: TObject; ScrollType: TSButtonType; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure RowClicked(RowIndex: integer); override;
    procedure RowDblClicked(RowIndex: integer); override;
    function GetSelectVar(TextIndex: integer; Shift: TShiftState; bNew : boolean): variant; override;
    function isShiftAllowed: boolean; override;
    function Navigate(NewSelected: integer): boolean; override;
    procedure IsInSelection(var MSResult: boolean; var ShiftList: TStringlist; var ControlList: TStringlist; TextIndex: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RefreshDB;
    procedure SearchColumn(ColIndex: integer; bAsc : boolean; SearchStr: string); override;
    procedure SortColumn(ColIndex: integer; SortAsc: boolean); override;
//    procedure SortList(Col : integer; bAscending : boolean); override; //NF:
    function IsMultiSelected(SelectValue: variant): boolean; override;
    function IsSelected(SelectValue: variant): boolean; override;
    Function FullNomKey(ncode : Longint) : Str20;
    function FullDoubleKey(const Value : Double) : Str20;
    property BoolAffirmative: string read fBoolAffirmative write fBoolAffirmative;
    property BoolNegative: string read fBoolNegative write fBoolNegative;
    property DatasetID: integer read fDatasetID;
    property FormatDate: string read fFormatDate write fFormatDate;
    property FormatTime: string read fFormatTime write fFormatTime;
    property RefreshKey: integer read fRefreshKey write fRefreshKey default VK_F5;
    property MultiSelected : TStringList read GetMultiSelected;
    procedure MultiSelectAll; override;
    procedure MultiSelectClear; override;
    procedure HighlightItem(sFind : string);
    property Position: Variant read FPrimaryLow write FPrimaryLow;
  published
//    property Dataset: TExDatasets read fExDatasets write fExDatasets;
    property Dataset: TExDatasets read fExDatasets write SetDataset;
    property OnAfterLoad: TNotifyEvent read fOnAfterLoad write fOnAfterLoad;
    property OnBeforeLoad: TBeforeLoadEvent read fOnBeforeLoad write fOnBeforeLoad;
    property OnSearchColumn: TSearchColumnEvent read fOnSearchColumn write fOnSearchColumn;
    property OnSortColumn: TSortColumnEvent read fOnSortColumn write fOnSortColumn;
    property OnAfterInit: TNotifyEvent read fAfterInit write fAfterInit; //NF:
//    property OnAfterNavigate: TNotifyEvent read fOnAfterNavigate write fOnAfterNavigate; //NF:
    property Active : boolean read fActive write SetActive;
    property SortColIndex : byte read fSortColIndex write SetSortColIndex;
    property SortAsc: boolean read GetSortAsc write SetSortAsc;
  end;

procedure Register;

implementation

uses Variants, SysUtils, uSQLDatasets;

procedure Register;
begin
  RegisterComponents('SBS', [TDBMultiList]);
end;

//*** TKeyVariant **************************************************************

constructor TKeyVariant.Create(KeyVariant: variant);
begin
  inherited Create;
  
  fKeyVariant:= KeyVariant;
end;

//*** TDBMultiList *************************************************************

//*** Startup and Shutdown *****************************************************

constructor TDBMultiList.Create(AOwner: TComponent);
begin
  {The Bool strings are substitued in the MultiList for boolean field values;
   MaxRecs is an indicator for the number of records that can currently be displayed
   onscreen; Ensure notifications of changes in display availability result in
   changes in record retrieval; fKeyValues and fSortValues maintain a list of
   the current primary key and sort values so that neither need be a displayed
   column;}

  inherited;

  bDestroying := FALSE;

  fMultiSelectedRP := TStringList.Create;
  fMultiSelectedRP.Clear;
//  SetLength(fMultiSelectedRP, 0);

  fBoolAffirmative := 'Yes';
  fBoolNegative := 'No';

  // NF:
  if (csDesigning in ComponentState) then begin
    fSortColIndex := 0;
    fActive := FALSE;
    SortAsc := TRUE;
  end;{if}

  fDBMScrollBox.OnBroadcastMaxRecs:= BroadcastMaxRecs;
  fKeyValues:= TStringList.Create;
  fSortValues:= TStringList.Create;

  fFormatDate:= ShortDateFormat;
  fFormatTime:= 'hh:nn:ss';
  fRefreshKey:= VK_F5;
end;

destructor TDBMultiList.Destroy;
var
VarIndex: integer;
begin
  {Free all key and sort values variant objects and their associated stringlists;}

  bDestroying := TRUE;

  with fSortValues do for VarIndex:= 0 to Count - 1 do Objects[VarIndex].Free;
  with fKeyValues do for VarIndex:= 0 to Count - 1 do Objects[VarIndex].Free;

  FreeAndNil(fSortValues);
  FreeAndNil(fKeyValues);

  fMultiSelectedRP.Free;

  inherited;
end;

procedure TDBMultiList.Loaded;
begin
  {Once all the properties have been set, create an ExDatasets connection passing
   through the necessary connection details; Only do this if Enabled is set
   to true;

   Note: DBMultiList is not populated at this point, but instead when MultiList
   is first painted; On painting, MultiList fires BroadcastMaxRecs which calls
   LoadDBMultiList(btTop) the first time it is fired;}

  inherited;

  if csDesigning in ComponentState then Exit;
  if not Assigned(fExDatasets) then Exit;

{  if Enabled then
  begin
    fSortKey:= fExDatasets.PrimaryKey;
    fDatasetID:= fExDatasets.Open;
 end;}

  // NF: Changed to use new StartList command
  if Enabled and fActive then StartList;

end;

procedure TDBMultiList.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (AComponent = fExDatasets) then fExDatasets:= nil;
end;

//*** TMultiList overrides *****************************************************

function TDBMultilist.Navigate(NewSelected: integer): boolean;
begin
  Result:= inherited Navigate(NewSelected);
  if Result and (NewSelected >= 0) then DatasetSelect(stNavigate, NewSelected);
//  if Assigned(OnAfterNavigate) then OnAfterNavigate(Self);
end;

{When exiting or clicking the control, the partial search string buffer is cleared;}

procedure TDBMultiList.PanelClick(Sender: TObject);
begin
  inherited;

  SearchColumn(Col, SortedAsc, '');
end;

procedure TDBMultiList.PanelColumnClick(Sender: TObject; ColIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {When a column is clicked, the selected item must be refreshed if KeepConnection
   is enabled; }

  inherited;

  if Columns.Count <= 0 then Exit;
  if (fExDatasets = nil) or (not fExDatasets.open) then Exit; //NF:

  if fExDatasets.KeepConnection then with Columns[0].Items do
  begin
    if Selected = 0 then LoadColumns(btOneUp, fPrimaryLow, fSortLow, false, true)
    else LoadColumns(btOneDown, fPrimaryHigh, fSortHigh, true, true);
  end;

  if Selected >= 0 then DatasetSelect(stRecordClick, Selected);
end;

procedure TDBMultiList.PanelExit(Sender: TObject);
begin
  inherited;

  SearchColumn(Col, SortedAsc, '');
end;

procedure TDBMultiList.PanelHeaderDblClick(ColIndex: integer);
begin
  {Double-clicking a header causes the column clicked to be sorted; If the column
   is currently sorted, the sorting is reversed; Otherwise the column is sorted
   in ascending order;}

//  inherited;

  with fDBMScrollBox do
  begin
    fSortColIndex := ColIndex;
    if Columns[ColIndex].Field = SortedField
    then SortColumn(ColIndex, not SortedAsc)
    else SortColumn(ColIndex, true);
  end;
end;

{Mouse wheel events cause the dataset to be scrolled; New events are not processed
 until current events have completed;}

procedure TDBMultiList.PanelMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if fMouseWheeling then Exit;
  fMouseWheeling:= true;

  try
    if Assigned(OnMouseWheelDown) then OnMouseWheelDown(Sender, Shift, MousePos, Handled);
    if ssShift in Shift then LoadShiftedDBM(btOneDown) else LoadDBMultiList(btOneDown);
    Application.ProcessMessages;
  finally
    fMouseWheeling:= false;
  end;
end;

procedure TDBMultiList.PanelMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if fMouseWheeling then Exit;
  fMouseWheeling:= true;

  try
    if Assigned(OnMouseWheelDown) then OnMouseWheelDown(Sender, Shift, MousePos, Handled);
    if ssShift in Shift then LoadShiftedDBM(btOneUp) else LoadDBMultiList(btOneUp);
    Application.ProcessMessages;
  finally
    fMouseWheeling:= false;
  end;
end;

procedure TDBMultiList.PanelKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  NewCol: integer;
  AShiftSelected : TStringList;
  bDoneSomething : boolean;

  Procedure MultiSelectPage;
  var
    sRecPos : string;
    iPos, iIndex : integer;
  begin{MultiSelectPage}
    // fakes a select all !
    sRecPos := '-1';
    For iPos := 1 to ScreenItemsCount do begin
      sRecPos := TKeyVariant(fKeyValues.Objects[Selected]).KeyVar;
      iIndex := fMultiSelectedRP.IndexOf(sRecPos);
      if iIndex = -1 then fMultiSelectedRP.Add(sRecPos);

      case Key of
        VK_PRIOR : PanelScrollClick(nil, btOneUp, mbLeft, [ssShift], 0, 0);
        VK_NEXT : PanelScrollClick(nil, btOneDown, mbLeft, [ssShift], 0, 0);
      end;{case}
    end;{for}
  end;{MultiSelectPage}

begin
  {Surface the KeyDown event and handle the key press only if columns are present;
   fKeyScrolling is used to ignore excess KeyDown events while a key is depressed,
   allowing the component time to paint on each KeyDown event; The Home and End
   keys move to each end of the dataset, Prior (Page Up) and Next (Page Down)
   scroll the dataset by a page; The up and down arrows scroll the dataset by
   one line, while the right and left arrow keys change the current Col;

   Changing Col affects which column partial searches and sorts are run on; The
   Enter key causes a column to be sorted; Pressing any of these keys causes the
   partial search string buffer to be cleared;}

  bDoneSomething := FALSE;

  // this stops 2 simultaneous key presses command from being executed.
  // occasionally the scroll bar will send it's key down to the list as well as the list capturing it.
  if (GetTickCount - iLastKeyDown < 50)
  and (Key in [VK_RETURN, VK_UP, VK_DOWN, VK_HOME, VK_END, VK_PRIOR, VK_NEXT, VK_RIGHT, VK_LEFT, VK_ESCAPE])
  then exit;
  iLastKeyDown := GetTickCount;

  if (Columns.Count <= 0) or fKeyScrolling then Exit;
  fKeyScrolling:= true;

  if Assigned(OnKeyDown) then OnKeyDown(Sender, Key, Shift);

  with fDBMScrollBox do
  try
    AShiftSelected := GetShiftSelected;
    if Key = fRefreshKey then
    begin
      RefreshDB;
      bDoneSomething := TRUE;
    end;{if}

    case Key of

//    VK_HOME: if ssShift in Shift then LoadShiftedDBM(btTop) else LoadDBMultiList(btTop);
      VK_HOME: begin
        LoadDBMultiList(btTop);
        bDoneSomething := TRUE;
      end;

{     VK_HOME: begin
        if MultiSelect and (ssShift in Shift)
        then AddMultiSelect(AShiftSelected, AShiftSelected, Shift, 0)
        else LoadDBMultiList(btTop);
        PanelScrollClick(nil, btTop, mbLeft, [ssLeft], 0,0);
      end;}

//    VK_END: if ssShift in Shift then LoadShiftedDBM(btBottom) else LoadDBMultiList(btBottom);
      VK_END: begin
        LoadDBMultiList(btBottom);
        bDoneSomething := TRUE;
      end;

//      VK_PRIOR: if ssShift in Shift then LoadShiftedDBM(btPageUp) else LoadDBMultiList(btPageUp);
      VK_PRIOR: begin
        if ssShift in Shift then
        begin
          MultiSelectPage;
        end else
        begin
          LoadDBMultiList(btPageUp);
        end;{if}
        bDoneSomething := TRUE;
      end;

//      VK_NEXT: if ssShift in Shift then LoadShiftedDBM(btPageDown) else LoadDBMultiList(btPageDown);
      VK_NEXT:  begin
        if ssShift in Shift then
        begin
          MultiSelectPage;
        end else
        begin
          LoadDBMultiList(btPageDown);
        end;{if}
        bDoneSomething := TRUE;
      end;

      VK_UP: begin
        if ssShift in Shift
        then LoadShiftedDBM(btOneUp)
        else LoadDBMultiList(btOneUp);
        bDoneSomething := TRUE;
      end;

      VK_DOWN: begin
        if ssShift in Shift
        then LoadShiftedDBM(btOneDown)
        else LoadDBMultiList(btOneDown);
        bDoneSomething := TRUE;
      end;

      VK_RIGHT: begin
        if Col < Columns.Count - 1 then
        begin
          NewCol:= Succ(Col);
          while not(Columns[NewCol].Visible) and (NewCol < Pred(Columns.Count)) do inc(NewCol);
          if Columns[NewCol].Visible then
          begin
            Col:= NewCol;
            InvalidateHeader;
            bDoneSomething := TRUE;
          end;{if}
        end;{if}
      end;

      VK_LEFT: begin
        if Col > 0 then
        begin
          NewCol:= Pred(Col);
          while not(Columns[NewCol].Visible) and (NewCol > 0) do dec(NewCol);
          if Columns[NewCol].Visible then
          begin
            Col:= NewCol;
            InvalidateHeader;
            bDoneSomething := TRUE;
          end;{if}
        end;{if}
      end;

      VK_RETURN: begin
        if (ssCtrl in Shift) then
          begin
            if (Columns[Col].Field = SortedField)
            then SortColumn(Col, not SortedAsc)
          else SortColumn(Col, true);
          bDoneSomething := TRUE;
        end else
        begin
          if Assigned(OnRowDblClick) then OnRowDblClick(Self, Selected);
        end;{if}
        end;

      VK_ESCAPE: begin
        if MultiSelect then
        begin
          MultiSelectClear;
          bDoneSomething := TRUE;
        end;{if}
      end;
    end;{case}

    if Key in [VK_ESCAPE, fRefreshKey, VK_HOME, VK_END, VK_PRIOR, VK_NEXT, VK_UP
    , VK_DOWN, VK_RIGHT, VK_LEFT, VK_RETURN] then
    begin
      SearchColumn(Col, SortedAsc, '');
      bDoneSomething := TRUE;
    end;{if}

    if (Selected >= 0) and (Key in [fRefreshKey, VK_HOME, VK_END, VK_PRIOR, VK_NEXT
    , VK_UP, VK_DOWN, VK_RIGHT, VK_LEFT, VK_RETURN]) then
    begin
      DatasetSelect(stKeyPress, Selected);
      bDoneSomething := TRUE;
    end;{if}

  finally
    if bDoneSomething
    then Application.ProcessMessages;
//    if not bDestroying then Application.ProcessMessages;
    fKeyScrolling:= false;
  end;{try}
end;

procedure TDBMultiList.PanelKeyPress(Sender: TObject; var Key: Char);
begin
  {Alphanumeric keys intiate partial searches; The partial search buffer is
   cleared whenever Escape is pressed, the column is changed or the control is
   exited;}

  inherited;

//  if isAlphaNumeric(Key) then
//  begin
//    if GetTickCount > fClearSearchAt then fSearchStr:= '';
//    fClearSearchAt:= GetTickCount + Options.SearchTimeout;
//    SearchColumn(Col, SortedAsc, fSearchStr + Key);
//  end;
end;

procedure TDBMultiList.PanelScrollClick(Sender: TObject; ScrollType: TSButtonType; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {Surface the OnScrollClick event and pass the ScrollType through to
   LoadDBMultiList;}

  if Assigned(OnScrollClick) then OnScrollClick(Self, ScrollType, Button, Shift, X, Y);
  if ssShift in Shift then LoadShiftedDBM(ScrollType) else LoadDBMultiList(ScrollType);

  if Selected >= 0 then DatasetSelect(stScrollbarClick, Selected);
end;

procedure TDBMultiList.RowClicked(RowIndex: integer);
begin
  inherited;
  if Selected >= 0 then DatasetSelect(stRecordClick, Selected);
end;

procedure TDBMultiList.RowDblClicked(RowIndex: integer);
begin
  inherited;
  if Selected >= 0 then DatasetSelect(stRecordDblClick, Selected);
end;

//*** Displaying Data **********************************************************

procedure TDBMultiList.LoadDBMultiList(ScrollType: TSButtonType);
var
KeyValue: variant;
ScrollWithin, Allow: boolean;
begin
  {Passes the necessary scrolltype and member variables through to LoadCurrentRecord
   and invalidates the DBMultiList to update the display; LineUp and LineDown
   pass ScrollWithin false to LoadColumns if the selection is about to move out
   of the available range and ScrollWithin true otherwise; btSearch must also
   reposition the selection;

   Passing in the empty KeyValue variant indicates to TExDatasets that a first
   or last has been called;

   Low values are those displayed at the top of the DBMultiList, high values are
   displayed at the bottom; The nomenclature 'high' and 'low' is based on the
   default sort for the DBMultiList, ASCending; To page up we pass the key and
   sort values from the top of the display for ExDatasets, (fPrimaryLow and
   fSortLow), to return the next page of values; The same applies for line up;
   Paging and lining down use the high values at the bottom of the current
   display;

   If scrolling within the control using LineUp or LineDown, call LoadColumns
   to Refresh the current row after the selection has been moved with
   InvalidateSelected;}

  if not fActive then exit; //NF:
  if csDesigning in ComponentState then Exit;
  if not Assigned(fExDatasets) then Exit;
//  if (Columns.Count <= 0) or not(Enabled) then Exit;
  if (Columns.Count <= 0) then Exit;
  if not (fExDatasets.open) then Exit; //NF:

  Allow:= true;
  if Assigned(OnBeforeLoad) then OnBeforeLoad(Self, Allow);
  if not Allow then Exit;

  if Col >= Columns.Count then Col:= 0;

//  if ScrollType <> btSearch then SearchColumn(Col, SortedAsc, '');
  ScrollWithin:= false;
  VarClear(KeyValue);

  with fDBMScrollBox, Columns[0].Items do
  begin
    if (Selected < 0) and (ScrollType = btOneUp) then Selected:= 0;

    case ScrollType of
      btNil: LoadColumns(ScrollType, fPrimaryLow, fSortLow, true, false);
      btTop: LoadColumns(ScrollType, KeyValue, KeyValue, true, false);
      btBottom: LoadColumns(ScrollType, KeyValue, KeyValue, false, false);
//      btPageUp: LoadColumns(ScrollType, fPrimaryLow, fSortLow, false, false);

      btPageUp: if Selected >= 0 then LoadColumns(ScrollType, TKeyVariant(fKeyValues.Objects[Selected]).KeyVar
      , TKeyVariant(fSortValues.Objects[Selected]).KeyVar
      , false, false);

      btOneUp: if Selected = 0 then LoadColumns(ScrollType, fPrimaryLow, fSortLow, false, false) else if fExDatasets.KeepConnection then ScrollWithin:= true;
//      btPageDown: LoadColumns(ScrollType, fPrimaryLow{fPrimaryHigh}, fSortLow{fSortHigh}, true, false);

      btPageDown: if Selected >= 0 then LoadColumns(ScrollType, TKeyVariant(fKeyValues.Objects[Selected]).KeyVar
      , TKeyVariant(fSortValues.Objects[Selected]).KeyVar
      , true, false);

      btOneDown: if Selected = Count - 1 then LoadColumns(ScrollType, fPrimaryHigh, fSortHigh, true, false) else if fExDatasets.KeepConnection then ScrollWithin:= true;
      btSearch: LoadColumns(btSearch, fPrimaryLow, fSortLow, true, false);
    end;

    case ScrollType of

      // NF: Fix for not reselecting after refresh on delete_rec
      btNil: begin
        if Selected >= Columns[0].Items.Count
        then Selected := Columns[0].Items.Count - 1;
        if CanSelect(Selected) then InvalidateSelected(true, Selected);
      end;

      btTop: if CanSelect(0) then InvalidateSelected(true, 0);
      btBottom: if CanSelect(Count - 1) then InvalidateSelected(true, Count - 1);
      btPageUp: if CanSelect(0) then InvalidateSelected(true, 0);
      btPageDown: if CanSelect(Count - 1) then InvalidateSelected(true, Count - 1);

      btOneUp: begin
        {NF:}
        if (Selected <> 0) and CanSelect(Selected - 1)
        then InvalidateSelected(true, Selected - 1)
        else if (Selected <> -1) then InvalidateSelected(true, Selected);
      end;

      btOneDown: begin
        {NF:}
        if (Selected <> Count - 1) and CanSelect(Selected + 1)
        then InvalidateSelected(true, Selected + 1)
        else if (Selected <> -1) then InvalidateSelected(true, Selected);
      end;

      btSearch: LocateSearchValue;
    end;

    if ScrollWithin then case ScrollType of
      btOneUp: LoadColumns(ScrollType, fPrimaryLow, fSortLow, false, ScrollWithin);
      btOneDown: LoadColumns(ScrollType, fPrimaryHigh, fSortHigh, true, ScrollWithin);
    end;
  end;

  if Assigned(OnAfterLoad) then OnAfterLoad(Self);
end;

procedure TDBMultiList.LocateSearchValue;
type
  TReselect = (rsNoMatch, rsExactMatch, rsGTMatch);
var
  iFound, ItemsIndex : integer;
  Reselect : TReselect;
begin
  {Matches the selection with search value; When searching, PSQL comparisons are
   case-insensitive; When repositioning the selection, string comparisons are
   also case-insensitive;}

  Reselect:= rsNoMatch;
  iFound := 0;
  with Columns[Col] do begin
    try
      case Columns[Col].DataType of
        dtString: begin
          for ItemsIndex:= 0 to Items.Count - 1 do begin
            if UpperCase(Trim(Items[ItemsIndex])) = UpperCase(Trim(fSearchStr)) then
            begin
              // found exact match
              Reselect := rsExactMatch;
              iFound := ItemsIndex;
              Break;
            end
            else begin
              if (UpperCase(Items[ItemsIndex]) >= UpperCase(fSearchStr))
              and (Reselect = rsNoMatch) then
              begin
                // found Greater than match
                Reselect := rsGTMatch;
                iFound := ItemsIndex;
              end;{if}
            end;{if}
          end;{for}
        end;

        dtInteger: begin
          for ItemsIndex:= 0 to Items.Count - 1 do begin
            if (FullNomKey(MoneyStrToIntDef(Items[ItemsIndex], 0)) = fSearchStr) then
            begin
              // found exact match
              Reselect := rsExactMatch;
              iFound := ItemsIndex;
              Break;
            end
            else begin
              if (FullNomKey(MoneyStrToIntDef(Items[ItemsIndex], 0)) >= fSearchStr)
              and (Reselect = rsNoMatch) then
              begin
                // found Greater than match
                Reselect := rsGTMatch;
                iFound := ItemsIndex;
              end;{if}
            end;{if}
          end;{for}
        end;

        dtFloat: begin
          for ItemsIndex:= 0 to Items.Count - 1 do begin
            if (FullDoubleKey(MoneyStrToFloatDef(Items[ItemsIndex], 0)) = fSearchStr) then
            begin
              // found exact match
              Reselect := rsExactMatch;
              iFound := ItemsIndex;
              Break;
            end
            else begin
              if (FullDoubleKey(MoneyStrToFloatDef(Items[ItemsIndex], 0)) >= fSearchStr)
              and (Reselect = rsNoMatch) then
              begin
                // found Greater than match
                Reselect := rsGTMatch;
                iFound := ItemsIndex;
              end;{if}
            end;{if}
          end;{for}
        end;

        // NF: 07/06/2006
        // The Date format on screen must be DD/MM/YYYY or this will not work
        // It's just a botch for now, until we have time to fix this properly
        dtDate: begin
          for ItemsIndex:= 0 to Items.Count - 1 do begin
            if Trim(Items[ItemsIndex]) = DateToStr(Str8ToDate(Trim(fSearchStr))) then
            begin
              // found exact match
              Reselect := rsExactMatch;
              iFound := ItemsIndex;
              Break;
{            end
            else begin
              if (UpperCase(Items[ItemsIndex]) >= UpperCase(fSearchStr))
              and (Reselect = rsNoMatch) then
              begin
                // found Greater than match
                Reselect := rsGTMatch;
                iFound := ItemsIndex;
              end;{if}
            end;{if}
          end;{for}
        end;
      end;{case}

(*    case Columns[Col].DataType of
      dtString: if UpperCase(Items[ItemsIndex]) >= UpperCase(fSearchStr) then Reselect:= true;
      dtInteger: begin
{        if fExDatasets.IsBtrieve then
          begin
            if FullNomKey(StrToIntDef(Items[ItemsIndex],0)) >= fSearchStr
            then Reselect:= true;
          end
        else begin
          if StrToInt(Items[ItemsIndex]) >= StrToInt(fSearchStr) then Reselect:= true;
        end;{if}

        if UpperCase(Items[ItemsIndex]) >= UpperCase(fSearchStr) then Reselect:= true;

      end;
      dtDate: if StrToDate(Items[ItemsIndex]) >= StrToDate(fSearchStr) then Reselect:= true;
      dtTime: if StrToTime(Items[ItemsIndex]) >= StrToTime(fSearchStr) then Reselect:= true;
      dtDateTime: if StrToDateTime(Items[ItemsIndex]) >= StrToDateTime(fSearchStr) then Reselect:= true;
      dtFloat: if StrToFloat(Items[ItemsIndex]) >= StrToFloat(fSearchStr) then Reselect:= true;
      dtCurrency: if StrToCurr(Items[ItemsIndex]) >= StrToCurr(fSearchStr) then Reselect:= true;
    end;*)

      if Reselect in [rsExactMatch, rsGTMatch] then Selected:= iFound
      else if iFound = Items.Count - 1 then Selected:= Items.Count - 1;

    except
      Selected:= 0;
    end;{try}
  end;{with}

  if Columns[Col].DataType in [dtDate, dtTime, dtDateTime] then SearchColumn(Col, SortedAsc, '');
end;

//procedure TDBMultiList.LoadColumns(ScrollType: TSButtonType; PrimaryHigh: variant; SortHigh: variant; ScrollDown: boolean; ScrollWithin: boolean);
procedure TDBMultiList.LoadColumns(ScrollType: TSButtonType; PrimaryHigh: variant; SortHigh: string; ScrollDown: boolean; ScrollWithin: boolean);
var
EndData, RetrievedAsc, Searching, Refreshing: boolean;
BlockDetails: TBlockDetails;
begin
  {Exit if no records are required, we have no columns to display them in, or
   we are trying to scroll the dataset when there are no records to scroll;}

  if not fActive then exit; //NF:
  if (fMaxRecs <= 0) or (Columns.Count <= 0) then Exit;
  if (ScrollType in [btPageUp, btOneUp, btOneDown, btPageDown])
  and (fExDatasets.RecCount[fDatasetID] = 0) then Exit;
  if not fExDatasets.open then Exit; //NF:

  {The order the records are retrieved in corresponds with the scroll direction;
   When scrolling down, the records are retrieved in ascending order; However,
   when scrolling up, the SQL TOP command in TExDatasets requires that the
   records be returned in descending order; RetrievedAsc ensures the DBMultiList
   processes the results in the desired order;}

  RetrievedAsc:= ScrollDown;
  Searching:= ScrollType = btSearch;
  Refreshing:= ScrollType = btNil;

  with fExDatasets do
  begin
    {If the sort column is sorted in reverse, (SortedAsc is false), the scroll
     direction also needs to be reversed; For example, a page up on a descending
     dataset needs to be handled as if it were a page down on an ascending sort;}

    if not fDBMScrollBox.SortedAsc then ScrollDown:= not ScrollDown;

    {When scrolling up or down by one line, only one record is retrieved; Otherwise
     a full page of records is retrieved, (MaxRecs); If scrolling by the line and
     the end of the dataset is reached, (EndData), the display does not require
     updating; If scrolling by the page and the end of the dataset is reached,
     the available records will be received in reverse order;}

    fScrollWithin:= ScrollWithin;

    case ScrollType of
      btOneDown, btOneUp:
      begin
        BlockDetails:= BuildBlockDetails(1, PrimaryHigh, SortHigh, ScrollDown, Searching, false);
        EndData:= GetBlock(fDatasetID, BlockDetails);
        if EndData then Exit;
      end
      else
      begin
        BlockDetails:= BuildBlockDetails(fMaxRecs, PrimaryHigh, SortHigh, ScrollDown, Searching, Refreshing);
        EndData:= GetBlock(fDatasetID, BlockDetails);
        if EndData then RetrievedAsc:= not RetrievedAsc;
      end;
    end;

    {At this point the TExDatasets has prepared the resultset; The records must
     now be iterated through and displayed in TDBMultiList; In the case of
     LineUp and LineDown, only one record need be loaded; The remaining search
     types load a block;}

    if RecCount[fDatasetID] > 0 then
    begin
      if ScrollType in [btOneUp, btOneDown] then LoadRecord else LoadRecords(RetrievedAsc);
    end
    else ClearItems;
  end;
end;

procedure TDBMultiList.LoadRecord;
var
ColIndex: integer;
FieldValue: variant;
begin
  {If KeepConnection is enabled, and we are scrolling through the onscreen
   records and a record has been deleted, inserted or moved, refresh the entire
   page;

   BuildKeyList updates the KeyValues and SortValues StringLists; Only columns
   with associated fields have data loaded; A LineUp requires a new item be
   inserted at the top of the list, and one deleted from the bottom; The reverse
   is true of LineDown; The data is obtained from TExDatasets using the Field
   function, passing in the column's fieldname; The data is then converted from
   a variant to a string;}

  if fScrollWithin then if RefreshNeeded then
  begin
    RefreshDB;
    Exit;
  end;

  BuildKeyList(fKeyValues, ltPrimary, fExDatasets.PrimaryKey);
  BuildKeyList(fSortValues, ltSort, fSortKey);

  BeginUpdate;
  for ColIndex:= 0 to Pred(Columns.Count) do with Columns[ColIndex], Items do
  try
    if Field = '' then Continue;

    if fScrollWithin or (Selected = 0) then
    begin
      FieldValue:= fExDatasets.Field({fDatasetID,} Field, True);
      Insert(Selected, ConvertVariant(ColIndex, FieldValue));
      if fScrollWithin then Delete(Succ(Selected)) else Delete(Pred(Count));
    end
    else
    begin
      FieldValue:= fExDatasets.Field({fDatasetID,} Field, True);
      Add(ConvertVariant(ColIndex, FieldValue));
      Delete(0);
    end;

  finally
    EndUpdate;
  end;
end;

procedure TDBMultiList.LoadRecords(RetrievedAsc: boolean);
var
RecIndex, ColIndex: integer;
begin
  {Clear all the items from the columns and empty the KeyValues and SortValues
   StringLists; }


  for ColIndex:= 0 to Pred(Columns.Count) do Columns[ColIndex].Items.Clear;
  with fKeyValues do for RecIndex:= 0 to Pred(Count) do Objects[RecIndex].Free;
  with fSortValues do for RecIndex:= 0 to Pred(Count) do Objects[RecIndex].Free;
  fKeyValues.Clear;
  fSortValues.Clear;


  {If the records have been retrieved in descending order, move to the end of
   the recordset; Recordsets are often returned in reverse order because of the
   manner in which the TOP command operates; Because of this we need to reverse
   the order in which we read the records into the DBMultiList; If we have sorted
   a column, and truly want the recordset in descending order, this will have
   already been achieved when we called GetBlock with ScrollDown reversed;

   Set the PrimaryLow and SortLow values to the key and sort values corresponding
   with the first record to be listed;}

  with fExDatasets do
  begin
    if RetrievedAsc then GetBlockFirst(fDatasetID) else GetBlockLast(fDatasetID);
    fPrimaryLow:= Field({fDatasetID,} PrimaryKey);
    fSortLow:= Field({fDatasetID,} fSortKey);

    {Iterate through the recordset loading the current records; A recordset in
     descending order will be traversed in reverse; Finally, store the last records
     to be loaded into the list in the Primary and Sort High variables;}

    for RecIndex:= 1 to RecCount[fDatasetID] do
    begin
      LoadCurrentRecord;
      if RetrievedAsc then GetBlockNext(fDatasetID) else GetBlockPrior(fDatasetID);
    end;

    fPrimaryHigh:= Field({fDatasetID,} PrimaryKey);
    fSortHigh:= Field({fDatasetID,} fSortKey);
  end;
  fExDatasets.GetBlockFirst(0);
end;

procedure TDBMultiList.LoadCurrentRecord;
var
ColIndex: integer;
FieldValue: variant;
begin
  {Each record loaded into the DBMultiList must have a corresponding Key and
   Sort value stored in the KeyValues and SortValues list; Do not request fields
   for columns that do not have an empty field property; The variant returned
   from the ExDatasets field function is converted into a string for display;}

  with fExDatasets do
  begin
    fKeyValues.AddObject('', TKeyVariant.Create(Field({fDatasetID,} PrimaryKey)));
    fSortValues.AddObject('', TKeyVariant.Create(Field({fDatasetID,} fSortKey)));
  end;

  BeginUpdate;
  for ColIndex:= 0 to Columns.Count - 1 do with Columns[ColIndex] do
  try

    if Field = '' then Continue;
    FieldValue:= fExDatasets.Field({fDatasetID,} Field, True);
    Items.Add(ConvertVariant(ColIndex, FieldValue));

  finally
    EndUpdate;
  end;
end;

procedure TDBMultiList.BuildKeyList(KeyList: TStringList; ListType: TListType; FieldName: string);
var
RemoveIndex: integer;
begin
  {The KeyValues and SortValues StringLists are needed to track key and sort
   values even if the column is not being displayed; This is necessary during
   line ups and line downs because the Primary Low and Primary High values can
   no longer be set from the bounds of the resultset; They are instead set from
   the StringLists which maintain a list of the currently displayed Key and Sort
   values; These lists are cleared whenever a fresh block of records is returned;

   When moving one line up, a new key value is inserted at the beginning of the
   list, and one is deleted from the end; The same occurs in reverse for line
   downs; For line refreshes when KeepConnection is true, the current key values
   are deleted and the refreshed values are inserted; By doing this, we have the
   correct key and sort values on hand for passing to TExDatasets;}

  with KeyList do
  begin
    if fScrollWithin or (Selected = 0) then
    begin
      InsertObject(Selected, '', TKeyVariant.Create(fExDatasets.Field({fDatasetID,} FieldName)));
      if fScrollWithin then RemoveIndex:= Selected + 1 else RemoveIndex:= Count - 1;
      Objects[RemoveIndex].Free;
      Delete(RemoveIndex);
    end
    else
    begin
      AddObject('', TKeyVariant.Create(fExDatasets.Field({fDatasetID,} FieldName)));
      Objects[0].Free;
      Delete(0);
    end;

    case ListType of
      ltPrimary:
      begin
        fPrimaryHigh:= TKeyVariant(Objects[Count - 1]).KeyVar;
        fPrimaryLow:= TKeyVariant(Objects[0]).KeyVar;
      end;
      ltSort:
      begin
        fSortHigh:= TKeyVariant(Objects[Count - 1]).KeyVar;
        fSortLow:= TKeyVariant(Objects[0]).KeyVar;
      end;
    end;
  end;
end;

//*** DBMultiList Methods ******************************************************

procedure TDBMultiList.SearchColumn(ColIndex: integer; bAsc : boolean; SearchStr: string);
//var
//  vSearch : variant;
begin
  {Only search columns with the Searchable property enabled; If an empty search
   string is passed in, the OnSearch event is still fired; This allows the
   developer to track the current search criteria; Note a column must be sortable
   to allow for searching;

   Assesses the search criteria against the column's datatype; A search must
   satisfy the constraints given by the datatype;}

  if Columns.Count <= 0 then Exit;
  if not(Columns[ColIndex].Sortable) or not(Columns[ColIndex].Searchable) then Exit;

  if Assigned(OnSearchColumn) then OnSearchColumn(Self, ColIndex, SearchStr);
  fSearchStr:= SearchStr;

  if fSearchStr = '' then Exit;

  if (bAsc <> SortedAsc) or (ColIndex <> SortColIndex)
  then begin
    SortedAsc := bAsc;
    SortColIndex := ColIndex;
  end;{if}

(*  case Columns[Col].DataType of
    dtString: DoSearch(ColIndex, SearchStr);
    //NF: Modified to support integer indexes in btrieve
    dtInteger: DoSearch(ColIndex, SearchStr);{begin
      vSearch := SearchStr;
      if fExDatasets.IsBtrieve then DoSearch(ColIndex, vSearch)
      else begin
        if isNumeric(SearchStr, true) then DoSearch(ColIndex, StrToInt(SearchStr));
      end;{if}
//    end;
    dtDate: if isDate(SearchStr) then DoSearch(ColIndex, GetDateVariant);
    dtTime: if isTime(SearchStr) then DoSearch(ColIndex, GetTimeVariant);
    dtDateTime: if isDateTime(SearchStr) then DoSearch(ColIndex, GetDateTimeVariant);
//    dtFloat: if isNumeric(SearchStr, true) then DoSearch(ColIndex, StrToFloat(SearchStr));
//    dtCurrency: if isNumeric(SearchStr, true) then DoSearch(ColIndex, StrToCurr(SearchStr));
    dtFloat: if isNumeric(SearchStr, true) then DoSearch(ColIndex, SearchStr);
    dtCurrency: if isNumeric(SearchStr, true) then DoSearch(ColIndex, SearchStr);
  end;*)

  DoSearch(ColIndex, SearchStr);
end;

procedure TDBMultiList.DoSearch(ColIndex: integer; SearchVar: string);
begin
  {Loads the necessary search fields; fDBMScrollBox requires information to
   paint the order triangle; Loads the DBMultiList with data satisfying the
   search criteria;}

  Col:= ColIndex;
  fDBMScrollBox.SortedField:= Columns[Col].Field;
  fDBMScrollBox.SortedAsc:= true;

  fSortKey:= Columns[Col].Field;
  fSortLow:= SearchVar;

  LoadDBMultiList(btSearch);
end;

procedure TDBMultiList.SortColumn(ColIndex: integer; SortAsc: boolean);
begin
  {Only sort columns with the Sortable property enabled; When a column is sorted
   that column is set to the active column;}

  if not Assigned(fExDatasets) then Exit;
  if Columns.Count <= 0 then Exit;
  if not Columns[ColIndex].Sortable then Exit;

  if Assigned(OnSortColumn) then OnSortColumn(Self, ColIndex, SortAsc);
  // NF: Coded to get the datatype and index number from the column properties
  fExDatasets.SearchIndex := Columns[ColIndex].IndexNo;
  fExDatasets.SearchDataType := Columns[ColIndex].DataType;

  fSortColIndex := ColIndex; // NF: 19/02/2007 Fix for column sorting, was only being set on double click on column header previously.

  with fDBMScrollBox do
  begin
    Col:= ColIndex;

    SortedAsc:= SortAsc;
    SortedField:= Columns[ColIndex].Field;
    fSortKey:= Columns[ColIndex].Field;
  end;

  LoadDBMultiList(btTop);
{
  if not Assigned(fExDatasets) then Exit;
  if Columns.Count <= 0 then Exit;
  if not DesignColumns[ColIndex].Sortable then Exit;

  if Assigned(OnSortColumn) then OnSortColumn(Self, ColIndex, SortAsc);
  // NF: Coded to get the datatype and index number from the column properties
  fExDatasets.SearchIndex := DesignColumns[ColIndex].IndexNo;
  fExDatasets.SearchDataType := DesignColumns[ColIndex].DataType;

  with fDBMScrollBox do
  begin
    Col:= ColIndex;

    SortedAsc:= SortAsc;
    SortedField:= DesignColumns[ColIndex].Field;
    fSortKey:= DesignColumns[ColIndex].Field;
  end;

  LoadDBMultiList(btTop);}
end;

procedure TDBMultiList.BroadcastMaxRecs(NewMaxRecs: integer);
var
OriginalMaxRecs: integer;
begin
  {This method is fired whenever TMultiList repaints; If the number of displayable
   records has changed, (usually due to a resize), DBMultiList is reloaded; This
   occurs on the very first paint and is responsible for populating DBMultiList
   on startup;}

  if csDesigning in ComponentState then Exit;

  OriginalMaxRecs:= fMaxRecs;
  fMaxRecs:= NewMaxRecs;

  if OriginalMaxRecs = 0 then
    begin
      LoadDBMultiList(btTop);
      if Assigned(OnAfterInit) then OnAfterInit(Self);
    end
  else begin
    if OriginalMaxRecs <> NewMaxRecs then LoadDBMultiList(btNil);
  end;{if}
end;

procedure TDBMultiList.RefreshDB;
begin
  {Causes the DBMultiList to be repopulated in the same position;}
  if not fActive then Exit;

  if fDatasetID < 0 then fDatasetID:= fExDatasets.OpenData;
  LoadDBMultiList(btNil);
  if selected = -1 then selected := 0;
end;

//*** Helper Functions *********************************************************

function TDBMultiList.BuildBlockDetails(MaxRecs: integer; PrimaryHigh: variant; SortHigh: string; Scroll: boolean; Search: boolean; Refresh: boolean): TBlockDetails;
var
BlockDetails: TBlockDetails;
ScrollAdjustment: integer;
begin
  {Populates a TBlockDetails record with the details needed by the ExDatasets
   GetBlock method; If the selection is moving within the onscreen records, i.e.
   fScrollWithin is true, set the key values to the previous selection; We want
   to receive the record for the current selection to ensure we have the one
   displayed, otherwise we will refresh the entire page;}

  if fScrollWithin then with Columns.Items[0] do
  begin
    ScrollAdjustment:= GetScrollAdjustment(Scroll);
    PrimaryHigh:= TKeyVariant(fKeyValues.Objects[Selected + ScrollAdjustment]).KeyVar;
    SortHigh:= TKeyVariant(fSortValues.Objects[Selected + ScrollAdjustment]).KeyVar;
  end;

  with BlockDetails do
  begin
    FieldNames:= GetFieldNames;
    KeyValue:= PrimaryHigh;
    SortKey:= fSortKey;
    SortValue:= SortHigh;
    RecCount:= MaxRecs;
//    RecCount:= ScreenItemsCount;
//    if ScreenItemsCount > 0 then RecCount:= ScreenItemsCount;
    ScrollDown:= Scroll;
    Searching:= Search;
    Refreshing:= Refresh;
  end;

  Result:= BlockDetails;
end;

function TDBMultiList.GetScrollAdjustment(Scroll: boolean): integer;
begin
  {This function ensures the correct adjustment is made to reference out the
   primary and sort keys of the selected item;}

  Result:= 1;

  if Columns[0].Items.Count = 1 then Result:= 0
  else if fDBMScrollBox.SortedAsc then
  begin
    if Scroll then Result:= -1;
  end
  else if not Scroll then Result:= -1;
end;

function TDBMultiList.ConvertVariant(ColIndex: integer; FieldValue: variant): string;
begin
  {Takes a variant field value returned from the ExDatasets Field function and
   converts it to a string for display in DBMultiList;}

  Result:= '';

  case VarType(FieldValue) of
    varString, varOleStr: Result:= FieldValue;
    varSmallInt, varInteger, varShortInt, varWord, varLongWord, varInt64: Result:= IntToStr(FieldValue);
    varSingle, varDouble: Result:= FloatToStr(FieldValue);
    varCurrency: Result:= CurrToStr(FieldValue);
    varBoolean: if FieldValue = -1 then Result:= fBoolNegative else Result:= fBoolAffirmative;
    varDate: with Columns[ColIndex] do
    begin
      case DataType of
        dtDate: Result:= FormatDateTime(FormatDate, FieldValue);
        dtTime: Result:= FormatDateTime(FormatTime, FieldValue);
        dtDateTime: Result:= FormatDateTime(FormatDate + ' ' + FormatTime, FieldValue);
      end;
    end;
  end;
end;

function TDBMultiList.RefreshNeeded: boolean;
begin
  {If KeepConnection is true, and the record being refreshed has been deleted,
   a new record has been inserted or the primary or sort key on the new record
   has changed, call for a full page refresh;}

  Result:= false;
  if Columns.Count <= 0 then Exit;

  with Columns[0].Items do with fExDatasets do
  begin
    if TKeyVariant(fKeyValues.Objects[Selected]).KeyVar <> Field({fDatasetID,} PrimaryKey) then Result:= true;
    if TKeyVariant(fSortValues.Objects[Selected]).KeyVar <> Field({fDatasetID,} fSortKey) then Result:= true;
  end;
end;

function TDBMultiList.GetFieldNames: string;
var
ColIndex: integer;
begin
  {Concatenates all column field properties for the ExDatasets SQL statement;
   Note the primary key is always returned regardless of whether it is included
   in the display;}

  Result:= '';

  for ColIndex:= 0 to Columns.Count - 1 do with Columns[ColIndex] do
  begin
    if Field <> '' then Result:= Result + Field + ', ';
  end;
  if Pos(fExDatasets.PrimaryKey, Result) = 0 then Result:= Result + fExDatasets.PrimaryKey + ', ';

  Delete(Result, Length(Result) - 1, 2);
end;
{
function TDBMultiList.IsAlphaNumeric(Key: Char): boolean;
begin
  {Examines the ASCII code for the given character and returns true if it is
   alphanumeric;}

{  Result:= Ord(Key) in [32, 45, 46, 48..57, 65..90, 97..122];
end;
}
function TDBMultiList.IsNumeric(TestStr: string; isIntegral: boolean): boolean;
var
CharIndex, DecCount: integer;
TestChar: Char;
TestFloat: Extended;
begin
  {Examines the ASCII codes for all the characters; If the characters are not
   numeric, a minus sign or decimal point then reset the SearchStr buffer; If the
   last character is a minus sign or decimal point, return false; If they are all
   numeric, converts to an extended and compares with MaxInt; If larger than MaxInt,
   returns false, otherwise true;}

  Result:= true;
  DecCount:= 0;

  try
    for CharIndex:= 1 to Length(TestStr) do
    begin
      TestChar:= TestStr[CharIndex];
      if not(Ord(TestChar) in [45, 46, 48..57]) then Result:= false;
      if (Ord(TestChar) = 45) and (CharIndex > 1) then Result:= false;
      if (Ord(TestChar) = 46) then inc(DecCount);
      if DecCount > 1 then Result:= false;
    end;

    if not Result then SearchColumn(Col, SortedAsc, '')
    else if Ord(TestStr[Length(TestStr)]) in [45, 46] then Result:= false;

    if Result and isIntegral then
    begin
      TestFloat:= StrToFloat(TestStr);
      if Abs(TestFloat) > MAXINT then Result:= false;
    end;
  except
    Result:= false;
  end;
end;

function TDBMultiList.IsDate(TestStr: string): boolean;
begin
  {Ensures searches on dates only occur where the search string buffer contains
   8 numeric characters;}

  Result:= true;
  if Length(TestStr) <> 8 then Result:= false;
  if not isNumeric(TestStr, true) then Result:= false;
end;

function TDBMultiList.IsTime(TestStr: string): boolean;
begin
  {Ensures searches on times only occur where the search string buffer contains
   6 numeric characters;}

  Result:= true;
  if Length(TestStr) <> 6 then Result:= false;
  if not isNumeric(TestStr, true) then Result:= false;
end;

function TDBMultiList.IsDateTime(TestStr: string): boolean;
begin
  {Ensures searches on date times only occur where the search string buffer
   contains 14 numeric characters;}

  Result:= true;
  if Length(TestStr) <> 14 then Result:= false;
  if not isNumeric(TestStr, false) then Result:= false;
end;

function TDBMultiList.GetDateVariant: variant;
begin
  {Builds a date value from the search string buffer;}

  fSearchStr:= Copy(fSearchStr, 1, 2) + '/' + Copy(fSearchStr, 3, 2) + '/' + Copy(fSearchStr, 5, 4);
  Result:= StrToDate(fSearchStr);
end;

function TDBMultiList.GetTimeVariant: variant;
begin
  {Builds a time value from the search string buffer;}

  fSearchStr:= Copy(fSearchStr, 1, 2) + ':' + Copy(fSearchStr, 3, 2) + ':' + Copy(fSearchStr, 5, 2);
  Result:= StrToTime(fSearchStr);
end;

function TDBMultiList.GetDateTimeVariant: variant;
begin
  {Builds a date time value from the search string buffer;}

  fSearchStr:= Copy(fSearchStr, 1, 2) + '/' + Copy(fSearchStr, 3, 2) + '/' + Copy(fSearchStr, 5, 4) + ' ' + Copy(fSearchStr, 9, 2) + ':' + Copy(fSearchStr, 11, 2) + ':' + Copy(fSearchStr, 13, 2);
  Result:= StrToDateTime(fSearchStr);
end;

//*** MultiSelection ***********************************************************

procedure TDBMultiList.LoadShiftedDBM(ScrollType: TSButtonType);
var
ShiftSelected, ControlSelected: TStringList;
begin
  {This method allows rows to be selected when the user holds the shift key and
   uses the buttons, mouse wheel or keyboard to scroll; Store the initial value;
   LoadDBMultiList will move the selection; Call AddMultiSelect with TextIndex
   set to -1 to indicate it will use the stored selection value as one of the
   selection range bounds;}

  if csDesigning in ComponentState then Exit;
  if not Assigned(fExDatasets) then Exit;
  if (Columns.Count <= 0) or not(Enabled) then Exit;

  fSelectValue:= GetSelectVar(Selected, [ssShift], TRUE);
  LoadDBMultiList(ScrollType);

  with fDBMScrollBox do
  begin
    ShiftSelected:= GetShiftSelected;
    ControlSelected:= GetControlSelected;
    AddMultiSelect(ShiftSelected, ControlSelected, [ssShift], -1);
  end;
end;

function TDBMultiList.GetSelectVar(TextIndex: integer; Shift: TShiftState; bNew : boolean): variant;
var
  MultiSelectList: TStringList;
  iIndex, SelectIndex : integer;
begin
  {Multi-selection in TMultiList uses the TextIndex; In TDBMultiList the
   MultiSelectIntegrity option can be used to control whether MultiSelection can
   only be performed for shift ranges when sorting on the primary key; If
   MultiSelectIntegrity is off the list can MultiSelect during sorts on non-unique
   fields; The problem occurs when a user shift clicks on a duplicate field and
   the duplicate is unintentionally included in the shift range; Also, the Btrieve
   dataset does not allow shift ranges with MultiSelectIntegrity on because the
   primary key record addresses are not numerically sequential;

   A TextIndex of -1 indicates the isMultiSelected method of TDBMultiList was
   called, in which case, test the value it was called with; Otherwise pass the
   keyvalue corresponding with the onscreen TextIndex;}

  if TextIndex = -1 then
  begin
    Result:= fSelectValue;
//    TextIndex := StrToInt(fSelectValue);
  end else
  begin
{    if Options.MultiSelectIntegrity then MultiSelectList:= fKeyValues
    else }MultiSelectList:= fSortValues;

    Result:= TKeyVariant(MultiSelectList.Objects[TextIndex]).KeyVar;
  end;

  if bNew then begin
    if Columns.Count <= 0 then Exit;
    if TextIndex > Columns[0].Items.Count - 1 then Exit;
    if (ssShift in Shift) and not(isShiftAllowed) then Exit;

    if ssShift in Shift then
    begin
      // SHIFT
      // NF: set new MultiSelected property
      if Selected <= TextIndex then
      begin
        for SelectIndex := Selected to TextIndex do
        begin
          iIndex := fMultiSelectedRP.IndexOf(TKeyVariant(fKeyValues.Objects[SelectIndex]).KeyVar);
          if iIndex <> -1 then fMultiSelectedRP.Delete(iIndex);
          fMultiSelectedRP.Add(TKeyVariant(fKeyValues.Objects[SelectIndex]).KeyVar);
        end;{for}
      end else
      begin
        for SelectIndex := TextIndex to Selected do
        begin
          iIndex := fMultiSelectedRP.IndexOf(TKeyVariant(fKeyValues.Objects[SelectIndex]).KeyVar);
          if iIndex <> -1 then fMultiSelectedRP.Delete(iIndex);
          fMultiSelectedRP.Add(TKeyVariant(fKeyValues.Objects[SelectIndex]).KeyVar);
        end;{for}
      end;{if}
    end
    else
    begin
      // CONTROL
      // NF: set new MultiSelectedRP Property
      iIndex := fMultiSelectedRP.IndexOf(TKeyVariant(fKeyValues.Objects[TextIndex]).KeyVar);
      if iIndex = -1 then fMultiSelectedRP.Add(TKeyVariant(fKeyValues.Objects[TextIndex]).KeyVar)
      else fMultiSelectedRP.Delete(iIndex);
    end;{if}
  end;{if}

end;

{These IsSelected overrides store the value they are called with and return run
 the inherited function with a TextIndex of -1; This will ultimately indicate
 to GetSelectVar that the stored value is returned to IsInSelection for testing;}

function TDBMultiList.IsMultiSelected(SelectValue: variant): boolean;
begin
  fSelectValue:= SelectValue;
  Result:= inherited IsMultiSelected(-1);
end;

function TDBMultiList.IsSelected(SelectValue: variant): boolean;
begin
  fSelectValue:= SelectValue;
  Result:= inherited IsMultiSelected(-1);
end;

function TDBMultiList.isShiftAllowed: boolean;
begin
  {This override prevents shift selects when DBMultiList is sorted on a column
   other than the primary key and MultiSelectIntegrity is on; If it is not this
   override also prevents MultiSelects on primary key sorts for the Btrieve
   dataset where record addresses used for the primary key are non-sequential;}

  Result:= true;

  with fExDatasets do
  begin
{    if Options.MultiSelectIntegrity then
    begin
      if isBtrieve then Result:= false
      else Result:= fSortKey = PrimaryKey;
    end
    else }if isBtrieve then Result:= fSortKey <> PrimaryKey;
  end;
end;

procedure TDBMultiList.DatasetSelect(SelectType: TSelectType; NewSelected: integer);
begin
  (*with fExDatasets do
  begin
    if isBtrieve then
      begin
{        if(VarType(TKeyVariant(fKeyValues.Objects[NewSelected]).KeyVar) and varTypeMask = varString)
        then //NF:
        else SelectRecord(SelectType, TKeyVariant(fKeyValues.Objects[NewSelected]).KeyVar)}
        if Selected >= 0 then
        SelectRecord(SelectType, TKeyVariant(fKeyValues.Objects[NewSelected]).KeyVar)
      end
    else SelectRecord(SelectType, NewSelected);
  end;*)

{  if Selected >= 0 then
  begin}
    with fExDatasets do
    begin
      if isBtrieve then SelectRecord(SelectType, TKeyVariant(fKeyValues.Objects[NewSelected]).KeyVar)
      else if (fExDatasets is TSQLDatasets) then SelectRecord(SelectType, TKeyVariant(fKeyValues.Objects[NewSelected]).KeyVar)
      else SelectRecord(SelectType, NewSelected);
    end;{with}
{  end;{if}
end;

//******************************************************************************

procedure TDBMultiList.SetDataset(const Value: TExDatasets);
// NF: Added to enable the connection of datasets at run-time
begin
  fExDatasets := Value;
  if fActive then StartList;
end;

procedure TDBMultiList.StartList;
// NF: Starts the list manually;
begin
//  if Enabled then
//  begin

    if Assigned(fDBMScrollBox.OnBroadcastMaxRecs)
    then fDBMScrollBox.OnBroadcastMaxRecs(fDBMScrollBox.fPanel.GetMaxRecs);

    fSortKey:= fExDatasets.PrimaryKey;
    fDatasetID:= fExDatasets.OpenData;
//    fExDatasets.SearchKey := fExDatasets.SearchKey;
    if fDatasetID >= 0 then begin
//      LoadDBMultiList(btTop);

//      SortColumn(fSortColIndex, SortedAsc);
      SortColumn(DesignColumns[fSortColIndex].CurrentColPos, SortedAsc);

//      RefreshDB;                                  // Fill List
//      Selected := 0;        // Highlight first Line
//      if (Selected = -1) and (Columns[0].Items.Count > 0) then Selected := 0;        // Highlight first Line
    end;{if}
//  end;
end;

procedure TDBMultiList.SetActive(const Value: boolean);
// NF: allows us to start the list manually;
begin
  fActive := Value;
  if fActive then
    begin
//      fDataSetID := fExDatasets.OpenData;
      if fExDatasets <> nil then StartList;
    end
  else begin
    ClearItems;
    if Assigned(fExDatasets) and (fDataSetID >= 0) then begin
      fExDatasets.FreeDataset(fDataSetID);
      fDataSetID := -1;
    end;{if}
  end;{if}
end;

Function TDBMultiList.FullNomKey(ncode : Longint) : Str20;
Var
  TmpStr  :  Str20;
Begin
  FillChar(TmpStr,Sizeof(TmpStr),0);
  Move(ncode,TmpStr[1],Sizeof(ncode));
  TmpStr[0]:=Chr(Sizeof(ncode));
  FullNomKey:=TmpStr;
end;

function TDBMultiList.FullDoubleKey(const Value : Double) : Str20;
var
  dTemp : Double;
begin
  FillChar(Result, SizeOf(Result), 0);
  dTemp := Value;
  Move(dTemp, Result[1], SizeOf(dTemp));
  Result[0] := Char(SizeOf(dTemp));
end;

procedure TDBMultiList.SetSortColIndex(const NewColIndex : Byte);
begin
  if NewColIndex > Columns.Count - 1 then exit;
  fSortColIndex := NewColIndex;
//  fSortColIndex := DesignColumns[NewColIndex].IndexNo; //NF 24/06/2005 - should fix blank list on load after moving index column around
  SortColumn(fSortColIndex, SortedAsc);
end;

procedure TDBMultiList.SetSortAsc(Value: boolean);
begin
  SortedAsc := Value;
  SortColumn(fSortColIndex, SortedAsc);
end;

function TDBMultiList.GetSortAsc : boolean;
begin
  Result := SortedAsc;
end;
{
procedure TDBMultiList.SortList(Col: integer; bAscending: boolean);
begin
  // Do nothing
end;
}
function TDBMultiList.GetMultiSelected: TStringList;
begin
  Result := fMultiSelectedRP;
end;

procedure TDBMultiList.IsInSelection(var MSResult: boolean; var ShiftList,
  ControlList: TStringlist; TextIndex: integer);
begin
  MSResult := fMultiSelectedRP.IndexOf(TKeyVariant(fKeyValues.Objects[TextIndex]).KeyVar) <> -1;
//  inherited;
end;

procedure TDBMultiList.MultiSelectAll;
var
  iIndex : integer;
  sLastRecPos, sRecPos : string;
begin{MultiSelectAll}

  if ScreenItemsCount <= 0 then exit;

  // fakes a select all !
  PanelScrollClick(nil, btTop, mbLeft, [ssLeft], 0, 0);
  sRecPos := '-1';
  Repeat
    sLastRecPos := sRecPos;
    sRecPos := TKeyVariant(fKeyValues.Objects[Selected]).KeyVar;

    iIndex := fMultiSelectedRP.IndexOf(sRecPos);
    if iIndex = -1 then fMultiSelectedRP.Add(sRecPos);

    PanelScrollClick(nil, btOneDown, mbLeft, [ssLeft], 0, 0);
  until sLastRecPos = sRecPos;
end;

procedure TDBMultiList.MultiSelectClear;
//var
//  iPos : integer;
begin{MultiSelectClear}
  fMultiSelectedRP.Clear;
  RefreshList;
end;


procedure TDBMultiList.HighlightItem(sFind: string);
begin
  fSearchStr := sFind;
  LocateSearchValue;
end;

end.
