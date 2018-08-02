unit uMultiList;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, uDBMColumns, Dialogs
  , Graphics, Forms, StdCtrls, uScrollBar, IniFiles, Variants, GFXUtil;

type
  TCellRec = record
    sText : string;
    oObject : TObject
  end;

  TRowInfo = Class
    aCols : array of TCellRec;
  end;

  TBroadcastEvent = procedure(BroadcastValue: integer) of object;
  TCellPaintEvent = procedure(Sender: TObject; ColumnIndex: integer; RowIndex: integer; var OwnerText: string; var TextFont: TFont; var TextBrush: TBrush; var TextAlign: TAlignment) of object;
  THeaderDblClickEvent = procedure(Sender: TObject; ColIndex: integer) of object;
  TMultiSelectEvent = procedure(Sender: TObject; var ShiftList: TStringlist; var ControlList: TStringList; Shift: TShiftState; TextIndex: integer) of object;
  TIsMultiSelectedEvent = procedure(Sender: TObject; var MSResult: boolean; var ShiftList: TStringList; var ControlList: TStringList; TextIndex: integer) of object;
  TNavigateEvent = procedure(Sender: TObject; var Allow: boolean; NewSelected: integer) of object;
  TPanelClickEvent = procedure(Sender: TObject; ColIndex: integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
  TRowClickEvent = procedure(Sender: TObject; RowIndex: integer) of object;
  TKeyDownEvent = procedure(Key : Char) of object;


  TUpdateBevelEvent = procedure(const Value: TBevelCut) of object;
  TUpdateBevelWidthEvent = procedure(const Value: TBevelWidth) of object;
  TUpdateBooleanEvent = procedure(const Value: boolean) of object;
  TUpdateBorderEvent = procedure(const Value: TBorderStyle) of object;
  TUpdateColourEvent = procedure(const Value: TColor) of object;
  TUpdateCardinalEvent = procedure(const Value: cardinal) of object;
  TUpdateStringEvent = procedure(const Value: string) of object;

  TColClickedType = (ccNone, ccColumn, ccSplitter, ccDrag);
  TZoneType = (ztNone, ztHeader, ztSplitter, ztColumn);

  TMultiList = class;

  {This class used for object adding to the fControlSelects and fShiftSelects
   stringlists;}

  TSelectDetails = class
  public
    TimeStamp: TDateTime;
    Var1: variant;
    Var2: variant;
  end;

  TSelectRange = record
    RangeLow: variant;
    RangeHigh: variant;
  end;

  TSelectedArray = array of boolean;

  TShiftSelectType = array of TSelectRange;
  TControlSelectType = array of variant;
  TSettings = array of integer;

  TMLBevels = class(TPersistent)
  private
    fMultilist: TMultilist;
    fFrame: TBevelCut;
    fInner: TBevelCut;
    fOuter: TBevelCut;
//    fScrollBar: TBevelCut;
    fWidth: cardinal;
    procedure SetFrame(Value: TBevelCut);
    procedure SetInner(Value: TBevelCut);
    procedure SetOuter(Value: TBevelCut);
//    procedure SetScrollbar(Value: TBevelCut);
    procedure SetWidth(Value: cardinal);
  public
    UpdateFrame: TUpdateBevelEvent;
    UpdateInner: TUpdateBevelEvent;
    UpdateOuter: TUpdateBevelEvent;
//    UpdateScrollbar: TUpdateBevelEvent;
    UpdateWidth: TUpdateBevelWidthEvent;
    constructor Create(AOwner: TMultilist);
  published
    property Frame: TBevelCut read fFrame write SetFrame default bvRaised;
    property Inner: TBevelCut read fInner write SetInner default bvNone;
    property Outer: TBevelCut read fOuter write SetOuter default bvNone;
//    property Scrollbar: TBevelCut read fScrollBar write SetScrollbar default bvNone;
    property Width: cardinal read fWidth write SetWidth default 1;
  end;

  TMLBorders = class(TPersistent)
  private
    fMultilist: TMultilist;
    fInner: TBorderStyle;
    fOuter: TBorderStyle;
//    fScrollbar: TBorderStyle;
    procedure SetInner(Value: TBorderStyle);
    procedure SetOuter(Value: TBorderStyle);
//    procedure SetScrollbar(Value: TBorderStyle);
  public
    UpdateInner: TUpdateBorderEvent;
    UpdateOuter: TUpdateBorderEvent;
//    UpdateScrollbar: TUpdateBorderEvent;
    constructor Create(AOwner: TMultilist);
  published
    property Inner: TBorderStyle read fInner write SetInner default bsSingle;
    property Outer: TBorderStyle read fOuter write SetOuter default bsNone;
//    property Scrollbar: TBorderStyle read fScrollbar write SetScrollbar default bsSingle;
  end;

  TMLColours = class(TPersistent)
  private
    fMultiList: TMultilist;
    fButtons: TColor;
    fFrame: TColor;
    fActiveColumn: TColor;
//    fCellText: TColor;
    fMultiSelection: TColor;
//    fScrollbar: TColor;
    fSelection: TColor;
//    fSelectionText: TColor;
    fSortableTriangle: TColor;
    fSortedTriangle: TColor;
    fSpacer: TColor;
    fSplitter: TColor;
//    procedure SetButtons(Value: TColor);
    procedure SetFrame(Value: TColor);
    procedure SetActiveColumn(Value: TColor);
    procedure SetMultiSelection(Value: TColor);
//    procedure SetScrollbar(Value: TColor);
    procedure SetSelection(Value: TColor);
//    procedure SetSelectionText(Value: TColor);
    procedure SetSortableTriangle(Value: TColor);
    procedure SetSortedTriangle(Value: TColor);
    procedure SetSpacer(Value: TColor);
    procedure SetSplitter(Value: TColor);
  public
//    UpdateButtons: TUpdateColourEvent;
    UpdateFrame: TUpdateColourEvent;
    UpdateActiveColumn: TUpdateColourEvent;
    UpdateMultiSelection: TUpdateColourEvent;
//    UpdateScrollbar: TUpdateColourEvent;
    UpdateSelection: TUpdateColourEvent;
//    UpdateSelectionText: TUpdateColourEvent;
    UpdateSortableTriangle: TUpdateColourEvent;
    UpdateSortedTriangle: TUpdateColourEvent;
    UpdateSpacer: TUpdateColourEvent;
    UpdateSplitter: TUpdateColourEvent;
    constructor Create(AOwner: TMultilist);
  published
//    property Buttons: TColor read fButtons write SetButtons default clBtnFace;
    property Frame: TColor read fFrame write SetFrame default clBtnFace;
    property ActiveColumn: TColor read fActiveColumn write SetActiveColumn default clWindowText;
//    property CellText: TColor read fCellText write fCellText default clWindowText;
    property MultiSelection: TColor read fMultiSelection write SetMultiSelection default clHighlight;
//    property Scrollbar: TColor read fScrollbar write SetScrollbar default clBtnFace;
    property Selection: TColor read fSelection write SetSelection default clHighlight;
//    property SelectionText: TColor read fSelectionText write SetSelectionText default clHighlightText;
    property SortableTriangle: TColor read fSortableTriangle write SetSortableTriangle default clGrayText;
    property SortedTriangle: TColor read fSortedTriangle write SetSortedTriangle default clWindowText;
    property Spacer: TColor read fSpacer write SetSpacer default clBtnFace;
    property Splitter: TColor read fSplitter write SetSplitter default clBtnFace;
  end;

  TMLCustom = class(TPersistent)
  private
    fListName: string;
    fSettingsIni: string;
    fUserName: string;
    fSplitterCursor: TCursor;
  published
    property ListName: string read fListName write fListName;
    property SettingsIni: string read fSettingsIni write fSettingsIni;
    property SplitterCursor: TCursor read fSplitterCursor write fSplitterCursor;
    property UserName: string read fUserName write fUserName;
  end;

  TMLDimensions = class(TPersistent)
  private
    fMultiList: TMultilist;
    fHeaderHeight: cardinal;
//    fScrollbarWidth: cardinal;
    fSpacerWidth: cardinal;
    fSplitterWidth: cardinal;
    procedure SetHeaderHeight(Value: cardinal);
//    procedure SetScrollbarWidth(Value: cardinal);
    procedure SetSpacerWidth(Value: cardinal);
    procedure SetSplitterWidth(Value: cardinal);
  public
    UpdateHeaderHeight: TUpdateCardinalEvent;
//    UpdateScrollbarWidth: TUpdateCardinalEvent;
    UpdateSpacerWidth: TUpdateCardinalEvent;
    UpdateSplitterWidth: TUpdateCardinalEvent;
    constructor Create(AOwner: TMultilist);
  published
    property HeaderHeight: cardinal read fHeaderHeight write SetHeaderHeight default 20;
//    property ScrollbarWidth: cardinal read fScrollbarWidth write SetScrollbarWidth default 22;
    property SpacerWidth: cardinal read fSpacerWidth write SetSpacerWidth default 5;
    property SplitterWidth: cardinal read fSplitterWidth write SetSplitterWidth default 6;
  end;

  TMLOptions = class(TPersistent)
  private
    fMultilist: TMultilist;
    fBoldActiveColumn: boolean;
    fMultiSelection: boolean;
    fMultiSelectIntegrity: boolean;
    fRepeatDelay: cardinal;
    fSearchTimeout: cardinal;
    procedure SetBoldActiveColumn(Value: boolean);
    procedure SetMultiSelection(Value: boolean);
    procedure SetRepeatDelay(Value: cardinal);
    procedure SetSearchTimeout(Value: cardinal);
  public
    UpdateBoldActiveColumn: TUpdateBooleanEvent;
    UpdateMultiSelection: TUpdateBooleanEvent;
    UpdateRepeatDelay: TUpdateCardinalEvent;
    UpdateSearchTimeout: TUpdateCardinalEvent;
    constructor Create(AOwner: TMultilist);
  published
    property BoldActiveColumn: boolean read fBoldActiveColumn write SetBoldActiveColumn default true;
    property MultiSelection: boolean read fMultiSelection write SetMultiSelection default false;
    property MultiSelectIntegrity: boolean read fMultiSelectIntegrity write fMultiSelectIntegrity default false;
    property RepeatDelay: cardinal read fRepeatDelay write SetRepeatDelay default 200;
    property SearchTimeout: cardinal read fSearchTimeout write SetSearchTimeout default 1000;
  end;

  TDBMPanel = class(TCustomPanel)
  private
    fDBMColumns: TDBMColumns;

    {Helper variables;}
    fColDragIndex: integer;
    fColResizing: boolean;
    fControlSelected: array of integer;
    fControlSelects: TStringlist;
    fDoubleClickTime: cardinal;
    fDragCol: integer;
    fLastClickLoc: TPoint;
    fMoveRect: TRect;
    fMinLeft: integer;
    fOriginalRect: TRect;
    fOriginalX: integer;
    fOriginalY: integer;
    fScreenCanvas: HDC;
    fShiftSelected: integer;
    fShiftSelects: TStringList;
    fSortedAsc: boolean;
    fSortedField: string;
    fStoreWidth: integer;
    fTopItem: integer;

    {Property variables;}
    fBevelHeader: TBevelCut;
    fCol: integer;
    fHeaderHeight: integer;
    fMultiSelect: boolean;
    fSortableTriangle: TColor;
    fSortedTriangle: TColor;
    fSelBrushColour: TColor;
    fSelected: integer;
    fSelHeaderColour: TColor;
    fSelHeaderBold: boolean;
    fSelMultiColour: TColor;
    fSelTextColour: TColor;
    fSplitterWidth: integer;
    fSplitterColour: TColor;

    {Event variables;}
    fOnBroadcastWidth: TBroadcastEvent;
    fOnBroadcastMaxRecs: TBroadcastEvent;
    fOnHeaderDblClick: TBroadcastEvent;
    fOnNavigate: TNavigateEvent;
    fOnChangeSelection : TNotifyEvent; //NF:
    fOnCellPaint: TCellPaintEvent;
    fOnHeaderClick: TPanelClickEvent;
    fOnAddSelect: TMultiSelectEvent;
    fOnIsMultiSelected: TIsMultiSelectedEvent;
    fOnSplitterClick: TPanelClickEvent;
    fOnColumnClick: TPanelClickEvent;
    fDoubleClicked : boolean; // NF: to fix a problem that the list kept focus after a double click - even if you have opened a new non-modal window

//TempBitmap : TBitmap;
//    iLastPaint : Cardinal;

    procedure PaintHeader;
    procedure PaintFrame;
    procedure PaintCaptions;
    procedure PaintColumns;
    procedure PaintText;
    procedure PaintSplitter(ColLeft: integer; Column: TDBMColumn; ACanvas : TCanvas = nil);
    procedure PaintSplitterHeader(ColLeft: integer; ACanvas : TCanvas = nil);
//    procedure DrawVertLine(LineColour: TColor; LineLeft: integer; LineTop: integer; LineBottom: integer; ACanvas : TCanvas = nil);
//    procedure DrawHorizLine(LineColour: TColor; LineTop: integer; LineLeft: integer; LineRight: integer; ACanvas : TCanvas = nil);
    procedure DrawMain(BoxColour: TColor; BoxRect: TRect; ACanvas : TCanvas = nil);
    procedure DrawSelectRect(SelectColour: TColor; DrawRect: TRect; bMultiSelect : boolean; ACanvas : TCanvas = nil);
    procedure InvalidateHeader;
    procedure InvalidateColumn(ColumnIndex: integer);
    procedure InvalidateSelected(MoveCursor: boolean; NewSelected: integer);
    procedure InvalidateSpace;
    procedure FlushColumns;
    procedure HighlightDrop(X: integer);
    procedure ResizeColumn;

    {Property methods;}
    procedure SetBevelHeader(NewBevel: TBevelCut);
    procedure SetColumns(const Value: TDBMColumns);
    procedure SetHeaderHeight(NewHeight: integer);
    procedure SetSelected(NewSelected: integer);
    procedure SetSelHeaderBold(const Value: boolean);
    procedure SetSelHeaderColour(const Value: TColor);
    procedure SetSelMultiColour(const Value: TColor);
    procedure SetSplitterWidth(NewWidth: integer);
    procedure SetSplitterColour(NewColour: TColor);

    {Helper functions;}
    function GetBottomItem: integer;
    function GetBevelWidth: integer;
    function GetColumnClicked(X: integer): integer;
    function GetHeaderHeight: integer;
//    function GetMaxRecs: integer;
    function GetTriangleOffset(ColIndex: integer): integer;
    function GetWidthAccrued(ColCount: integer): integer;
    function IsColumnClicked(X: integer): TColClickedType;
    function IsMovingToFirst: boolean;
  protected
    procedure ColumnClick(Sender: TObject; ColumnIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure HeaderClick(Sender: TObject; ColumnIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure SplitterClick(Sender: TObject; ColumnIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseWheelHandler(var Message: TMessage); override;
    procedure DblClick; override;
    procedure Paint; override;

    property OnHeaderClick: TPanelClickEvent read fOnHeaderClick write fOnHeaderClick;
    property OnSplitterClick: TPanelClickEvent read fOnSplitterClick write fOnSplitterClick;
    property OnColumnClick: TPanelClickEvent read fOnColumnClick write fOnColumnClick;
  public
    function GetMaxRecs: integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
//    procedure ClearSelection;
    procedure CompactColumn(ColumnIndex: integer);
    procedure MoveColumn(OldLoc: integer; NewLoc: integer);
    procedure DefaultHandler(var Msg); override;
    function GetScreenX(X: integer): integer;
    function IsMultiSelected(ListIndex: integer): boolean;
    function IsSelected(ListIndex: integer): boolean;
    function ScreenItemsCount: integer;

    property BevelHeader: TBevelCut read fBevelHeader write SetBevelHeader;
    property Col: integer read fCol write fCol;
    property Columns: TDBMColumns read fDBMColumns write SetColumns;
    property DoubleClickTime: cardinal read fDoubleClickTime write fDoubleClickTime;
    property HeaderHeight: integer read fHeaderHeight write SetHeaderHeight;
    property LastClickLoc: TPoint read fLastClickLoc;
    property MultiSelect: boolean read fMultiSelect write fMultiSelect;
    property OnAddSelect: TMultiSelectEvent read fOnAddSelect write fOnAddSelect;
    property OnBroadcastMaxRecs: TBroadcastEvent read fOnBroadcastMaxRecs write fOnBroadcastMaxRecs;
    property OnBroadcastWidth: TBroadcastEvent read fOnBroadcastWidth write fOnBroadcastWidth;
    property OnHeaderDblClick: TBroadcastEvent read fOnHeaderDblClick write fOnHeaderDblClick;
    property OnIsMultiSelected: TIsMultiSelectedEvent read fOnIsMultiSelected write fOnIsMultiSelected;
    property OnCellPaint: TCellPaintEvent read fOnCellPaint write fOnCellPaint;
    property OnNavigate: TNavigateEvent read fOnNavigate write fOnNavigate;
    property OnChangeSelection: TNotifyEvent read fOnChangeSelection write fOnChangeSelection;//NF:
    property SortableTriangle: TColor read fSortableTriangle write fSortableTriangle;
    property SortedTriangle: TColor read fSortedTriangle write fSortedTriangle;
    property SplitterWidth: integer read fSplitterWidth write SetSplitterWidth;
    property SplitterColour: TColor read fSplitterColour write SetSplitterColour;
    property SelBrushColour: TColor read fSelBrushColour write fSelBrushColour default clHighlight;
    property SelHeaderBold: boolean read fSelHeaderBold write SetSelHeaderBold default true;
    property SelHeaderColour: TColor read fSelHeaderColour write SetSelHeaderColour default clBlack;
    property SelMultiColour: TColor read fSelMultiColour write SetSelMultiColour default clHighlight;
    property SelTextColour: TColor read fSelTextColour write fSelTextColour default clHighlightText;
    property Selected: integer read fSelected write SetSelected;
    property SortedField: string read fSortedField write fSortedField;
    property SortedAsc: boolean read fSortedAsc write fSortedAsc default true;
  end;

  TMLCaptureEdit = class(TEdit);

  TDBMScrollBox = class(TScrollingWinControl)
  private
//    fPanel: TDBMPanel;
    fForceScroll: TCustomPanel;
    fKeys: TMLCaptureEdit;

    fTabStop: boolean;
    fBorderInner: TBorderStyle;

    fOnAddSelect: TMultiSelectEvent;
    fOnBroadcastMaxRecs: TBroadcastEvent;
    fOnCellPaint: TCellPaintEvent;
    fOnColumnClick: TPanelClickEvent;
    fOnHeaderClick: TPanelClickEvent;
    fOnHeaderDblClick: TBroadcastEvent;
    fOnIsMultiSelected: TIsMultiSelectedEvent;
    fOnNavigate: TNavigateEvent;
    fOnChangeSelection: TNotifyEvent;
    fOnSplitterClick: TPanelClickEvent;

    procedure NewScrollWidth(NewWidth: integer);
    procedure BroadcastMaxRecs(MaxRecs: integer);
    procedure HeaderDblClick(ColIndex: integer);

    {Property setting;}
    function GetBevelHeader: TBevelCut;
    function GetBevelMainInner: TBevelCut;
    function GetBevelMainOuter: TBevelCut;
    function GetBevelWidth: TBevelWidth;
    function GetCol: integer;
    function GetColour: TColor;
    function GetColumns: TDBMColumns;
    function GetFlickerReduction: boolean;
    function GetHeaderHeight: integer;
    function GetMultiSelect: boolean;
    function GetSelBrushCol: TColor;
    function GetSelHeaderBold: boolean;
    function GetSelHeaderColour: TColor;
    function GetSelMultiColour: TColor;
    function GetSelTextCol: TColor;
    function GetSortableTriangle: TColor;
    function GetSortedTriangle: TColor;
    function GetSplitterColour: TColor;
    function GetSplitterWidth: integer;
    function GetSelected: integer;
    function GetSortedAsc: boolean;
    function GetSortedField: string;
    procedure SetBevelHeader(const Value: TBevelCut);
    procedure SetBevelMainInner(const Value: TBevelCut);
    procedure SetBevelMainOuter(const Value: TBevelCut);
    procedure SetMultiSelect(const Value: boolean);
    procedure SetBevelWidth(const Value: TBevelWidth);
    procedure SetBorderInner(const Value: TBorderStyle);
    procedure SetCol(const Value: integer);
    procedure SetColour(const Value: TColor);
    procedure SetColumns(const Value: TDBMColumns);
    procedure SetFlickerReduction(const Value: boolean);
    procedure SetHeaderHeight(const Value: integer);
    procedure SetSelBrushCol(const Value: TColor);
    procedure SetSelHeaderBold(const Value: boolean);
    procedure SetSelHeaderColour(const Value: TColor);
    procedure SetSelMultiColour(const Value: TColor);
    procedure SetSelected(const Value: integer);
    procedure SetSelTextCol(const Value: TColor);
    procedure SetSortableTriangle(const Value: TColor);
    procedure SetSortedTriangle(const Value: TColor);
    procedure SetSortedAsc(const Value: boolean);
    procedure SetSortedField(const Value: string);
    procedure SetSplitterColour(const Value: TColor);
    procedure SetSplitterWidth(const Value: integer);
    procedure SetTabStop(const Value: boolean);

    {Event Surfacing;}
    procedure PanelAddSelect(Sender: TObject; var ShiftList: TStringlist; var ControlList: TStringList; Shift: TShiftState; TextIndex: integer);
    procedure PanelCellPaint(Sender: TObject; ColumnIndex: integer; RowIndex: integer; var Text: string; var TextFont: TFont; var TextBrush: TBrush; var TextAlign: TAlignment);
    procedure PanelNavigate(Sender: TObject; var Allow: boolean; NewSelected: integer);
    procedure PanelChangeSelection(Sender: TObject);
    procedure PanelHeaderClick(Sender: TObject; ColIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PanelIsMultiSelected(Sender: TObject; var MSResult: boolean; var ShiftList: TStringList; var ControlList: TStringList; TextIndex: integer);
    procedure PanelSplitterClick(Sender: TObject; ColIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PanelColumnClick(Sender: TObject; ColIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    procedure PanelCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
    procedure PanelClick(Sender: TObject);
    procedure PanelDblClick(Sender: TObject);
    procedure PanelDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure PanelDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure PanelEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure PanelEnter(Sender: TObject);
    procedure PanelExit(Sender: TObject);
    procedure PanelKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PanelKeyPress(Sender: TObject; var Key: Char);
    procedure PanelKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PanelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PanelMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure PanelMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure PanelMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure PanelResize(Sender: TObject);
    procedure PanelStartDrag(Sender: TObject; var DragObject: TDragObject);

//    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
//    procedure Paint;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
//    procedure Paint; override;
  public
    fPanel: TDBMPanel;
    procedure Invalidate; override;
    constructor Create(AOwner: TComponent); override;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure InvalidateHeader;
    procedure InvalidateColumns;
    procedure InvalidateSelected(MoveCursor: boolean; NewSelected: integer);
    procedure MoveColumn(OldLoc: integer; NewLoc: integer);
    function CanSelect(NewSelected: integer): boolean;
    function GetControlSelected: TStringlist;
    function GetShiftSelected: TStringlist;
    function IsMultiSelected(ListIndex: integer): boolean;
    function IsSelected(ListIndex: integer): boolean;
    function ScreenItemsCount: integer;
    property Col: integer read GetCol write SetCol;
    property Selected: integer read GetSelected write SetSelected;
    property SortedAsc: boolean read GetSortedAsc write SetSortedAsc default true;
    property SortedField: string read GetSortedField write SetSortedField;

    property BevelHeader: TBevelCut read GetBevelHeader write SetBevelHeader default bvRaised;
    property BevelMainInner: TBevelCut read GetBevelMainInner write SetBevelMainInner default bvNone;
    property BevelMainOuter: TBevelCut read GetBevelMainOuter write SetBevelMainOuter default bvNone;
    property BevelWidth: TBevelWidth read GetBevelWidth write SetBevelWidth default 1;
    property BorderInner: TBorderStyle read fBorderInner write SetBorderInner default bsSingle;
    property Color: TColor read GetColour write SetColour default clBtnFace;
    property Columns: TDBMColumns read GetColumns write SetColumns;
    property FlickerReduction: boolean read GetFlickerReduction write SetFlickerReduction default true;
    property HeaderHeight: integer read GetHeaderHeight write SetHeaderHeight default 30;
    property MultiSelect: boolean read GetMultiSelect write SetMultiSelect default false;
    property SelBrushColour: TColor read GetSelBrushCol write SetSelBrushCol default clHighlight;
    property SelHeaderBold: boolean read GetSelHeaderBold write SetSelHeaderBold default true;
    property SelHeaderColour: TColor read GetSelHeaderColour write SetSelHeaderColour default clBlack;
    property SelMultiColour: TColor read GetSelMultiColour write SetSelMultiColour default clHighlight;
    property SelTextColour: TColor read GetSelTextCol write SetSelTextCol default clHighlightText;
    property SortableTriangle: TColor read GetSortableTriangle write SetSortableTriangle default clGrayText;
    property SortedTriangle: TColor read GetSortedTriangle write SetSortedTriangle default clWindowText;
    property SplitterWidth: integer read GetSplitterWidth write SetSplitterWidth default 6;
    property SplitterColour: TColor read GetSplitterColour write SetSplitterColour default clBtnFace;
    property TabStop: boolean read fTabStop write SetTabStop default true;

    property OnAddSelect: TMultiSelectEvent read fOnAddSelect write fOnAddSelect;
    property OnBroadcastMaxRecs: TBroadcastEvent read fOnBroadcastMaxRecs write fOnBroadcastMaxRecs;
    property OnCellPaint: TCellPaintEvent read fOnCellPaint write fOnCellPaint;
    property OnColumnClick: TPanelClickEvent read fOnColumnClick write fOnColumnClick;
    property OnHeaderClick: TPanelClickEvent read fOnHeaderClick write fOnHeaderClick;
    property OnHeaderDblClick: TBroadcastEvent read fOnHeaderDblClick write fOnHeaderDblClick;
    property OnIsMultiSelected: TIsMultiSelectedEvent read fOnIsMultiSelected write fOnIsMultiSelected;
    property OnNavigate: TNavigateEvent read fOnNavigate write fOnNavigate;
    property OnChangeSelection: TNotifyEvent read fOnChangeSelection write fOnChangeSelection; //NF:
    property OnSplitterClick: TPanelClickEvent read fOnSplitterClick write fOnSplitterClick;
    //PR: 29/04/2010 Made fKeys available to MultiList, to allow keyboard events fo be received correctly when
    //setting focus to multilist
    property FocusCapture : TMLCaptureEdit read fKeys;
  end;

//  TMultiList = class(TCustomPanel)
  TMultiList = class(TCustomPanel)
  private
    iLastKeyDown : cardinal;
    fClearSearchAt: cardinal;
    fSearchStr: string;
    fSpacer: TPanel;
    fUserIni: TInifile;

    fHeaderFont : TFont;
    fHighlightFont : TFont;
    fMultiSelectFont : TFont;

    fBevels: TMLBevels;
    fBorders: TMLBorders;
    fColours: TMLColours;
    fCustom: TMLCustom;
    fDimensions: TMLDimensions;
    fOptions: TMLOptions;

    fBorderOuter: TBorderStyle;
    fSearchTimeout: cardinal;
    fWheelTime: cardinal;

    fOnCellPaint: TCellPaintEvent;
    fOnNavigate: TNavigateEvent;
    fOnChangeSelection : TNotifyEvent; //NF:
    fOnRefreshList : TNotifyEvent; //NF:
    fOnSplitterClick: TPanelClickEvent;
    fOnColumnClick: TPanelClickEvent;
    fOnHeaderClick: TPanelClickEvent;
    fOnHeaderDblClick: THeaderDblClickEvent;
    fOnRowClick: TRowClickEvent;
    fOnRowDblClick: TRowClickEvent;
    fOnScrollClick: TDBScrollClickEvent;
    fOnScrollButtonKeyPress : TKeyDownEvent;
    fOnMultiSelect : TNotifyEvent; //NF:

    fMultiSelected : TSelectedArray;

    procedure SetBevels(Value: TMLBevels);
    procedure SetBorders(Value: TMLBorders);
    procedure SetColours(Value: TMLColours);
    procedure SetCustom(Value: TMLCustom);
    procedure SetDimensions(Value: TMLDimensions);
    procedure SetOptions(Value: TMLOptions);

    procedure SetColour(const Value: TColor);
    procedure SetSearchTimeout(const Value: cardinal);
    procedure WMSize(var Message: TWMSize); message WM_SIZE;

    function GetMultiSelected : TSelectedArray;

    {DBMScrollBox Properties;}
    function GetCol: integer;
    function GetColumns: TDBMColumns;
    function GetSelected: integer;
    function GetSortedAsc: boolean;
    function GetSortedIndex: integer;
    Procedure SetSortedAsc(Value : boolean);
    procedure SetBevelHeader(const Value: TBevelCut);
    procedure SetBevelMainInner(const Value: TBevelCut);
    procedure SetBevelMainOuter(const Value: TBevelCut);
    procedure SetBevelWidth(const Value: TBevelWidth);
    procedure SetBorderInner(const Value: TBorderStyle);
    procedure SetBorderOuter(const Value: TBorderStyle);
    procedure SetCol(const Value: integer);
    procedure SetColumns(const Value: TDBMColumns);
    procedure SetHeaderHeight(const Value: cardinal);
    procedure SetMultiSelect(const Value: boolean);
    procedure SetSelBrushCol(const Value: TColor);
    procedure SetSelHeaderBold(const Value: boolean);
    procedure SetSelHeaderColour(const Value: TColor);
    procedure SetSelMultiColour(const Value: TColor);
//    procedure SetSelTextCol(const Value: TColor);
    procedure SetScrollSpace(const Value: cardinal);
    procedure SetSelected(const Value: integer);
    procedure SetSortableTriangle(const Value: TColor);
    procedure SetSortedTriangle(const Value: TColor);
    procedure SetSpacerColour(const Value: TColor);
    procedure SetSplitterColour(const Value: TColor);
    procedure SetSplitterWidth(const Value: cardinal);

    {TDBScrollBar Properties;}
    function GetFlickerReduction: boolean;
//    function GetScrollImages: TImageList;
    function GetTabStop: boolean;
//    procedure SetBevel(const Value: TBevelCut);
//    procedure SetBorderScroll(const Value: TBorderStyle);
//    procedure SetButtonColor(const Value: TColor);
//    procedure SetFixedColor(const Value: TColor);
    procedure SetFlickerReduction(const Value: boolean);
    procedure SetRepeatDelay(const Value: cardinal);
//    procedure SetScrollImages(const Value: TImageList);
    procedure SetTabStop(const Value: boolean);
//    procedure SetWidth(const Value: cardinal);

    {Event Surfacing;}
    procedure PanelCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
    procedure PanelDblClick(Sender: TObject);
    procedure PanelDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure PanelDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure PanelEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure PanelEnter(Sender: TObject);
    procedure PanelKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PanelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PanelMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure PanelResize(Sender: TObject);
    procedure PanelStartDrag(Sender: TObject; var DragObject: TDragObject);

    procedure PanelAddSelect(Sender: TObject; var ShiftList: TStringlist; var ControlList: TStringList; Shift: TShiftState; TextIndex: integer);
    procedure PanelCellPaint(Sender: TObject; ColumnIndex: integer; RowIndex: integer; var Text: string; var TextFont: TFont; var TextBrush: TBrush; var TextAlign: TAlignment);
    procedure PanelHeaderClick(Sender: TObject; ColIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PanelIsMultiSelected(Sender: TObject; var MSResult: boolean; var ShiftList: TStringList; var ControlList: TStringList; TextIndex: integer);
    procedure PanelNavigate(Sender: TObject; var Allow: boolean; NewSelected: integer);
    procedure PanelChangeSelection(Sender: TObject);
    procedure PanelSplitterClick(Sender: TObject; ColIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    function GetVersionNo : string;
    procedure SetVersionNo(const Value: string);
  protected
    fDBMScrollBox: TDBMScrollBox;
    fScrollBar: TCustomScrollBar;

    procedure AddMultiSelect(var ShiftList: TStringList; var ControlList: TStringlist; Shift: TShiftState; TextIndex: integer; bForceOn : boolean = FALSE);
//    procedure ClearItems; virtual;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure IsInSelection(var MSResult: boolean; var ShiftList: TStringlist; var ControlList: TStringlist; TextIndex: integer); virtual;
    procedure Loaded; override;
    procedure PanelClick(Sender: TObject); virtual;
    procedure PanelColumnClick(Sender: TObject; ColIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure PanelExit(Sender: TObject); virtual;
    procedure PanelHeaderDblClick(ColIndex: integer); virtual;
    procedure PanelKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); virtual;
    procedure PanelKeyPress(Sender: TObject; var Key: Char); virtual;
    procedure PanelMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean); virtual;
    procedure PanelMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean); virtual;
    procedure PanelScrollClick(Sender: TObject; ScrollType: TSButtonType; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure RowClicked(RowIndex: integer); virtual;
    procedure RowDblClicked(RowIndex: integer); virtual;
    function GetDesignColumn(DesignIndex: integer): TDBMColumn;
    function GetDesignIndex(RuntimeIndex: integer): integer;
    function GetRuntimeIndex(DesignIndex: integer): integer;
    function GetSelectVar(TextIndex: integer; Shift: TShiftState; bNew : boolean): variant; virtual;
    function isBetween(Var1, Var2, Var3: variant): boolean;
    function isShiftAllowed: boolean; virtual;
    function Navigate(NewSelected: integer): boolean; virtual;
    //PR: 29/04/2010 Override DoEnter to allow setting focus to fKeys edit on scrollbox - this will allow keyboard events
    //to be received
    procedure DoEnter; override;
//    property SortedAsc: boolean read GetSortedAsc write SetSortedAsc;
  public
    procedure RefreshList;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ClearItems;
//    procedure ClearItems; virtual;
    procedure ApplySettings(Positions: TSettings; Widths: TSettings);
    procedure BeginUpdate;
//    procedure ClearSelection;
    procedure EndUpdate;
    procedure InitialiseUser;
    procedure Invalidate; override;
    procedure ForceRepaint;
    procedure MoveColumn(OldLoc: integer; NewLoc: integer);
    procedure ResetColumns;
    procedure SortColumn(ColIndex: integer; SortAsc: boolean); virtual; //NF:
    procedure DeleteRow(Row : integer);
    procedure MoveRow(FromRow, ToRow : integer);
    procedure SearchColumn(ColIndex: integer; bAsc : boolean; SearchStr: string); virtual;
    procedure ScrollButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ScrollButtonKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ScrollButtonKeyPress(Sender: TObject; var Key: Char);
    function GetControlSelected: TControlSelectType;
    function GetShiftSelected: TShiftSelectType;
    function IsMultiSelected(SelectValue: variant): boolean; virtual;
    function IsSelected(SelectValue: variant): boolean; virtual;
    function ScreenItemsCount: integer;
    function ItemsCount : integer;
    property Col: integer read GetCol write SetCol;
    property DesignColumns[Index: integer]: TDBMColumn read GetDesignColumn;
    property DesignIndexes[Index: integer]: integer read GetDesignIndex;
    property FlickerReduction: boolean read GetFlickerReduction write SetFlickerReduction default true;
    property RuntimeIndexes[Index: integer]: integer read GetRuntimeIndex;
    property Selected: integer read GetSelected write SetSelected;
    // HM 22/01/04: Moved from protected so the AScending/Descending sort order can be accessed
    property SortedAsc: boolean read GetSortedAsc write SetSortedAsc;
    property SortedIndex: integer read GetSortedIndex;
    property MultiSelected : TSelectedArray read GetMultiSelected;
    procedure ForceXPButtons;
    procedure MultiSelect(sItem : string; TextIndex: integer; bForceOn : boolean = FALSE);
    procedure MultiSelectAll; virtual;
    procedure MultiSelectClear; virtual;
    procedure SetMultiSelectedSize;
    function FindColumnNoFromField(sField : string) : integer;

  published
//    property SortedAsc: boolean read GetSortedAsc write SetSortedAsc;
    property Bevels: TMLBevels read fBevels write SetBevels;
    property Borders: TMLBorders read fBorders write SetBorders;
    property Colours: TMLColours read fColours write SetColours;
    property Custom: TMLCustom read fCustom write SetCustom;
    property Dimensions: TMLDimensions read fDimensions write SetDimensions;
    property Options: TMLOptions read fOptions write SetOptions;

    {DBMScrollBox properties;}
    property Columns: TDBMColumns read GetColumns write SetColumns;

    {TDBScrollBar properties;}
//    property ScrollImages: TImageList read GetScrollImages write SetScrollImages;
    property TabStop: boolean read GetTabStop write SetTabStop;

    property OnCellPaint: TCellPaintEvent read fOnCellPaint write fOnCellPaint;
    property OnColumnClick: TPanelClickEvent read fOnColumnClick write fOnColumnClick;
    property OnHeaderClick: TPanelClickEvent read fOnHeaderClick write fOnHeaderClick;
    property OnHeaderDblClick: THeaderDblClickEvent read fOnHeaderDblClick write fOnHeaderDblClick;
    property OnNavigate: TNavigateEvent read fOnNavigate write fOnNavigate;
    property OnChangeSelection: TNotifyEvent read fOnChangeSelection write fOnChangeSelection;//NF:
    property OnRefreshList: TNotifyEvent read fOnRefreshList write fOnRefreshList;//NF:
    property OnRowClick: TRowClickEvent read fOnRowClick write fOnRowClick;
    property OnRowDblClick: TRowClickEvent read fOnRowDblClick write fOnRowDblClick;
    property OnSplitterClick: TPanelClickEvent read fOnSplitterClick write fOnSplitterClick;
    property OnScrollClick: TDBScrollClickEvent read fOnScrollClick write fOnScrollClick;
    property OnScrollButtonKeyPress : TKeyDownEvent read fOnScrollButtonKeyPress write fOnScrollButtonKeyPress;
    property OnMultiSelect: TNotifyEvent read fOnMultiSelect write fOnMultiSelect;//NF:

    property Align;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property PopupMenu;
    property TabOrder;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;
    property Anchors;
    property HeaderFont : TFont read fHeaderFont write fHeaderFont;//NF:
    property HighlightFont : TFont read fHighlightFont write fHighlightFont;//NF:
    property MultiSelectFont : TFont read fMultiSelectFont write fMultiSelectFont;//NF;
    property Version : string read GetVersionNo write SetVersionNo;
  end;

procedure Register;

implementation

{$R DRAGCUR.RES}  // Drag Column Cursor.


procedure Register;
begin
  RegisterComponents('SBS', [TMultiList]);
end;

//*** TMultiList ***************************************************************

constructor TMultiList.Create(AOwner: TComponent);
begin
  {TMultiList is a panel containing three components, the DBMScrollBox, the
   DBScrollBar and a spacing bevel; The events on the former two are mapped to
   TMultiList methods that in turn surface the events to the user;}

  inherited;

  Height:= 250;
  Width:= 425;

  iLastKeyDown := 0;

  BevelOuter := bvNone;
  BevelInner := bvNone;

  fDBMScrollBox:= TDBMScrollBox.Create(Self);
  with fDBMScrollBox do
  begin
    Align:= alClient;
{    Top := 1;
    Left := 1;
    Height := self.Height;
    Width := self.Width - SCROLL_BAR_WIDTH;}

    Parent:= Self;

    OnAddSelect:= Self.PanelAddSelect;
    OnCellPaint:= Self.PanelCellPaint;
    OnColumnClick:= Self.PanelColumnClick;
    OnHeaderClick:= Self.PanelHeaderClick;
    OnHeaderDblClick:= Self.PanelHeaderDblClick;
    OnIsMultiSelected:= Self.PanelIsMultiSelected;
    OnNavigate:= Self.PanelNavigate;
    OnChangeSelection := Self.PanelChangeSelection;
    OnSplitterClick:= Self.PanelSplitterClick;

    OnCanResize:= Self.PanelCanResize;
    OnClick:= Self.PanelClick;
    OnDblClick:= Self.PanelDblClick;
    OnDragDrop:= Self.PanelDragDrop;
    OnDragOver:= Self.PanelDragOver;
    OnEndDrag:= Self.PanelEndDrag;
    OnEnter:= Self.PanelEnter;
    OnExit:= Self.PanelExit;
    OnKeyDown:= Self.PanelKeyDown;
    OnKeyPress:= Self.PanelKeyPress;
    OnKeyUp:= Self.PanelKeyUp;
    OnMouseDown:= Self.PanelMouseDown;
    OnMouseMove:= Self.PanelMouseMove;
    OnMouseUp:= Self.PanelMouseUp;
    OnMouseWheel:= Self.PanelMouseWheel;
    OnMouseWheelDown:= Self.PanelMouseWheelDown;
    OnMouseWheelUp:= Self.PanelMouseWheelUp;
    OnResize:= Self.PanelResize;
    OnStartDrag:= Self.PanelStartDrag;
  end;

  fScrollBar:= TCustomScrollBar.Create(Self);
  fScrollBar.WinControl:= Self;
  fScrollBar.OnScrollClick:= Self.PanelScrollClick;

//  fScrollBar.OnKeyDown:= Self.PanelKeyDown;

  fSpacer:= TPanel.Create(Self);
  fSpacer.Align:= alRight;
  fSpacer.Caption:= '';
  fSpacer.BevelOuter:= bvNone;
  fSpacer.Parent:= Self;

  fHeaderFont := TFont.Create;
  fHeaderFont.Name := 'Arial';
  fHeaderFont.Size := 8;

  fHighlightFont := TFont.Create;
  fHighlightFont.Name := 'Arial';
  fHighlightFont.Size := 8;
  fHighlightFont.Color := clWhite;

  fMultiSelectFont := TFont.Create;
  fMultiSelectFont.Name := 'Arial';
  fMultiSelectFont.Size := 8;
  fHighlightFont.Color := clWhite;

//  SetLength(fMultiSelected, ItemsCount - 1);
  SetLength(fMultiSelected, 0);

  fBevels:= TMLBevels.Create(Self);
  with fBevels do
  begin
    UpdateFrame:= SetBevelHeader;
    UpdateInner:= SetBevelMainInner;
    UpdateOuter:= SetBevelMainOuter;
//    UpdateScrollbar:= SetBevel;
    UpdateWidth:= SetBevelWidth;

    UpdateFrame(Frame);
    UpdateInner(Inner);
    UpdateOuter(Outer);
//    UpdateScrollbar(Scrollbar);
    UpdateWidth(Width);
  end;

  fBorders:= TMLBorders.Create(Self);
  with fBorders do
  begin
    UpdateInner:= SetBorderInner;
    UpdateOuter:= SetBorderOuter;
//    UpdateScrollbar:= SetBorderScroll;

    UpdateInner(Inner);
    UpdateOuter(Outer);
//    UpdateScrollbar(Scrollbar);
  end;

  fColours:= TMLColours.Create(Self);
  with fColours do
  begin
//    UpdateButtons:= SetButtonColor;
    UpdateFrame:= SetColour;
    UpdateActiveColumn:= SetSelHeaderColour;
    UpdateMultiSelection:= SetSelMultiColour;
//    UpdateScrollbar:= SetFixedColor;
    UpdateSelection:= SetSelBrushCol;
//    UpdateSelectionText:= SetSelTextCol;
    UpdateSortableTriangle:= Self.SetSortableTriangle;
    UpdateSortedTriangle:= Self.SetSortedTriangle;
    UpdateSpacer:= SetSpacerColour;
    UpdateSplitter:= SetSplitterColour;

//    UpdateButtons(Buttons);
    UpdateFrame(Frame);
    UpdateActiveColumn(ActiveColumn);
    UpdateMultiSelection(MultiSelection);
//    UpdateScrollbar(Scrollbar);
    UpdateSelection(Selection);
//    UpdateSelectionText(SelectionText);
    UpdateSortableTriangle(SortableTriangle);
    UpdateSortedTriangle(SortedTriangle);
    UpdateSpacer(Spacer);
    UpdateSplitter(Splitter);
  end;

  fCustom:= TMLCustom.Create;
  fCustom.SplitterCursor:= crHSplit;

  fDimensions:= TMLDimensions.Create(Self);
  with fDimensions do
  begin
    UpdateHeaderHeight:= Self.SetHeaderHeight;
//    UpdateScrollbarWidth:= SetWidth;
    UpdateSpacerWidth:= SetScrollSpace;
    UpdateSplitterWidth:= Self.SetSplitterWidth;

    UpdateHeaderHeight(HeaderHeight);
//    UpdateScrollbarWidth(ScrollbarWidth);
    UpdateSpacerWidth(SpacerWidth);
    UpdateSplitterWidth(SplitterWidth);
  end;

  fOptions:= TMLOptions.Create(Self);
  with fOptions do
  begin
    UpdateBoldActiveColumn:= SetSelHeaderBold;
    UpdateMultiSelection:= SetMultiSelect;
    UpdateRepeatDelay:= Self.SetRepeatDelay;
    UpdateSearchTimeout:= Self.SetSearchTimeout;

    UpdateBoldActiveColumn(BoldActiveColumn);
    UpdateMultiSelection(MultiSelection);
    UpdateRepeatDelay(RepeatDelay);
  end;

  fSearchStr := '';

  TabStop:= true;

  if Assigned(fDBMScrollBox.OnBroadcastMaxRecs)
  then fDBMScrollBox.OnBroadcastMaxRecs(fDBMScrollBox.fPanel.GetMaxRecs);
end;

procedure TMultiList.CreateParams(var Params: TCreateParams);
begin
  {BorderOuter toggles the BorderStyle on the MultiList panel; To effect a
   border change, the window must be recreated and the BorderStyle is set
   during CreateParams;}

  inherited CreateParams(Params);

  if fBorderOuter = bsSingle then Params.ExStyle:= Params.ExStyle or WS_EX_CLIENTEDGE;
end;

procedure TMultiList.Loaded;
var
ColIndex: integer;
begin
  {Once the three controls have been created and their properties loaded, ensure
   the ScrollBar and the spacer bevel are aligned correctly, and if necessary
   initialize the column widths and positions per user settings;}

  inherited;

  fScrollBar.Left:= Width;
  for ColIndex:= 0 to Pred(Columns.Count) do Columns[ColIndex].DBMWidth:= Columns[ColIndex].Width;
  if not(csDesigning in ComponentState) and (Custom.SettingsIni <> '') then InitialiseUser;
end;

procedure TMultiList.InitialiseUser;
var
SectionName: string;
WidthInt, PositionInt, ColID: integer;
Positions, Widths: TSettings;
begin
  fUserIni:= TIniFile.Create(Custom.SettingsIni);

  if Assigned(fUserIni) then with fUserIni do
  begin
    if Custom.UserName = '' then Custom.UserName:= 'DEFAULT USER';
    if Custom.ListName = '' then Custom.ListName:= Name;
    SectionName:= Custom.UserName + ' - ' + Custom.ListName;

    ColID:= 0;
    PositionInt:= ReadInteger(SectionName, 'Col0', -1);
    while PositionInt >= 0 do
    begin
      SetLength(Positions, Succ(Length(Positions)));
      Positions[High(Positions)]:= PositionInt;

      inc(ColID);
      PositionInt:= ReadInteger(SectionName, 'Col' + IntToStr(ColID), -1);
    end;

    ColID:= 0;
    WidthInt:= ReadInteger(SectionName, 'ColWidth0', -1);
    while (WidthInt >= 0) and (ColID < Columns.Count) do
    begin
      SetLength(Widths, Succ(Length(Widths)));
      Widths[High(Widths)]:= WidthInt;

      inc(ColID);
      WidthInt:= ReadInteger(SectionName, 'ColWidth' + IntToStr(ColID), -1);
    end;

    ApplySettings(Positions, Widths);
  end;
end;

procedure TMultiList.ApplySettings(Positions: TSettings; Widths: TSettings);
var
ColumnIndex, ColIndex, MaxIndex, ColID: integer;
DBMColumn: TDBMColumn;
begin
  ResetColumns;

  with Columns do
  begin
    ColID:= 0;
    MaxIndex:= Pred(Columns.Count);
    if High(Positions) < MaxIndex then MaxIndex:= High(Positions);

    for ColumnIndex:= 0 to MaxIndex do
    begin
      DBMColumn:= DesignColumns[Positions[ColumnIndex]];
      if Assigned(DBMColumn) then
      begin
        for ColIndex:= 0 to Pred(Columns.Count) do
        begin
          if Columns[ColIndex].DBMCol = DBMColumn.DBMCol then Break;
        end;
        fDBMScrollBox.MoveColumn(ColIndex, ColID);
      end;
      inc(ColID);
    end;

    ColID:= 0;
    MaxIndex:= Pred(Columns.Count);
    if High(Positions) < MaxIndex then MaxIndex:= High(Positions);

    for ColIndex:= 0 to MaxIndex do
    begin
      Columns[ColID].Width:= Widths[ColIndex];
      inc(ColID);
    end;
  end;
end;

procedure TMultiList.ResetColumns;
var
ColIndex: integer;
begin
  for ColIndex:= 0 to Pred(Columns.Count) do
  begin
    fDBMScrollbox.MoveColumn(DesignIndexes[ColIndex], ColIndex);
    Columns[ColIndex].Width:= Columns[ColIndex].DBMWidth;
  end;
end;

destructor TMultiList.Destroy;
var
ColIndex: integer;
SectionName: string;
begin
  {Write current column widths and positions to the inifile specified by the
   IniFileLoc property; Columns are stored in their current sequence;}

  if Assigned(fUserIni) then with fUserIni do
  try
    SectionName:= Custom.UserName + ' - ' + Custom.ListName;
    EraseSection(SectionName);

    for ColIndex:= 0 to Columns.Count - 1 do
    begin
      WriteInteger(SectionName, 'Col' + IntToStr(ColIndex), Columns[ColIndex].DBMCol);
      WriteInteger(SectionName, 'ColWidth' + IntToStr(ColIndex), Columns[ColIndex].Width);
    end;
    UpdateFile;
  finally
    FreeAndNil(fUserIni);
  end;

  if Assigned(fOptions) then FreeAndNil(fOptions);
  if Assigned(fDimensions) then FreeAndNil(fDimensions);
  if Assigned(fCustom) then FreeAndNil(fCustom);
  if Assigned(fColours) then FreeAndNil(fColours);
  if Assigned(fBorders) then FreeAndNil(fBorders);
  if Assigned(fBevels) then FreeAndNil(fBevels);
  if Assigned(fSpacer) then FreeAndNil(fSpacer);
  if Assigned(fHeaderFont) then FreeAndNil(fHeaderFont);
  if Assigned(fHighlightFont) then FreeAndNil(fHighlightFont);
  if Assigned(fMultiSelectFont) then FreeAndNil(fMultiSelectFont);

  SetLength(fMultiSelected, 0);

  inherited;
end;

procedure TMultiList.Invalidate;
begin
  {Allow users to refresh the control;}
//  if Assigned(fDBMScrollBox) then fDBMScrollBox.Invalidate;
//  if Assigned(fDBMScrollBox) then fDBMScrollBox.fPanel.Paint;
end;

{Calls to MultiList BeginUpdate and EndUpdate are passed down to DBMStringList
 to prevent repaint requests while list items are being altered;}

procedure TMultiList.BeginUpdate;
begin
  fDBMScrollBox.BeginUpdate;
end;

procedure TMultiList.EndUpdate;
begin
  fDBMScrollBox.EndUpdate;
end;
(*
procedure TMultiList.ClearSelection;
begin
  {Clears the multi-selection;}
  if Options.MultiSelection then fDBMScrollBox.fPanel.ClearSelection;
  if Assigned(OnMultiSelect) then OnMultiSelect(Self);
end;
*)
procedure TMultiList.AddMultiSelect(var ShiftList: TStringList; var ControlList: TStringlist; Shift: TShiftState; TextIndex: integer; bForceOn : boolean = FALSE);
var
  SelectDetails: TSelectDetails;
  SelectIndex: integer;
  AlreadySelected: boolean;
begin
  {Adds selection details to the relevant selection list, and causes a repaint;
   For both control and select lists, each select is timestamped to reconcile
   Shift and Control selects; In both cases, Var2 holds the key variant from the
   KeyValues list;}

  if Columns.Count <= 0 then Exit;
  if TextIndex > Columns[0].Items.Count - 1 then Exit;
  if (ssShift in Shift) and not(isShiftAllowed) then Exit;

  AlreadySelected:= false;

  SelectDetails:= TSelectDetails.Create;
  with ControlList, SelectDetails do
  try
    TimeStamp:= Now;

   {If shift selecting, destroy all control selects within the new range; Var1
    and Var2 hold the selection bounds;}

    if ssShift in Shift then
    begin
      Var1:= GetSelectVar(Selected, Shift, TRUE);
      Var2:= GetSelectVar(TextIndex, Shift, TRUE);

      // NF: set new MultiSelected property
      if Selected <= TextIndex then
      begin
        for SelectIndex := Selected to TextIndex
        do fMultiSelected[SelectIndex] := TRUE;
      end else
      begin
        for SelectIndex := TextIndex to Selected
        do fMultiSelected[SelectIndex] := TRUE;
      end;{if}

      for SelectIndex:= Count - 1 downto 0 do
      begin
        if isBetween(Var1, Var2, TSelectDetails(Objects[SelectIndex]).Var2) then
        begin
          Objects[SelectIndex].Free;
          Delete(SelectIndex);
        end;
      end;
    end
    else
    begin

      // NF: set new MultiSelected Property
      fMultiSelected[TextIndex] := not fMultiSelected[TextIndex];

      {For Control selects, Var1 holds a boolean indicating whether the
       row has been selected or deselected; If it is determined that a row has already
       been control selected, this boolean is toggled and a new select details object
       is not added;}

      Var1:= true;

//      if not bForceOn then begin
        for SelectIndex:= 0 to Count - 1 do with TSelectDetails(Objects[SelectIndex]) do
        begin
          if VarCompareValue(Var2, GetSelectVar(TextIndex, Shift, FALSE)) = vrEqual then
          begin
//            if bForceOn then exit;
            TimeStamp:= Now;
            Var1:= not Var1;
            AlreadySelected:= true;
            Break;
          end;
        end;
//      end;{if}

      Var2:= GetSelectVar(TextIndex, Shift, TRUE);
    end;

    if AlreadySelected then
      begin
        {if not bForceOn then }FreeAndNil(SelectDetails)
      end
    else begin
      if ssShift in Shift then ShiftList.AddObject('', SelectDetails)
      else ControlList.AddObject('', SelectDetails);
    end;
    fDBMScrollBox.InvalidateColumns;

  except
    FreeAndNil(SelectDetails);
  end;

  if Assigned(OnMultiSelect) then OnMultiSelect(Self);
end;

procedure TMultiList.IsInSelection(var MSResult: boolean; var ShiftList: TStringlist; var ControlList: TStringlist; TextIndex: integer);
//var
//SelectIndex: integer;
//ShiftedAt: TDateTime;
//SelectVar: variant;
begin
  {Move through the Shift selection list examining Var1 and Var2 from the
   SelectDetails objects to see if they straddle the KeyValue associated with
   the TextIndex; Find the highest timestamp for a successful range;}

(*  ShiftedAt:= -1;

  with ShiftList do
  begin
    for SelectIndex:= 0 to Count - 1 do with TSelectDetails(Objects[SelectIndex]) do
    begin
      if isBetween(Var1, Var2, GetSelectVar(TextIndex)) then
      begin
        MSResult:= true;
        if TimeStamp > ShiftedAt then ShiftedAt:= TimeStamp;
      end;
    end;
  end;

  {Move through the Control selection list searching for var2 values equal to
   the KeyValue associated with the TextIndex; If the value was found in the
   shift selection range invert the Control click handling otherwise return Var1
   as the result;}

  with ControlList do
  begin
    for SelectIndex:= 0 to Count - 1 do with TSelectDetails(Objects[SelectIndex]) do
    begin
      SelectVar:= GetSelectVar(TextIndex);
      if VarCompareValue(Var2, SelectVar) = vrEqual then
      begin
        if MSResult and (TimeStamp > ShiftedAt) then MSResult:= not Var1 else MSResult:= Var1;
        Break;
      end;
    end;
  end;*)

  MSResult := fMultiSelected[TextIndex];

end;

function TMultiList.GetSelectVar(TextIndex: integer; Shift: TShiftState; bNew : boolean): variant;
begin
  Result:= TextIndex;
end;

procedure TMultiList.MoveColumn(OldLoc: integer; NewLoc: integer);
begin
  if NewLoc > OldLoc then Inc(NewLoc);
  fDBMScrollBox.MoveColumn(OldLoc, NewLoc);
end;

function TMultiList.GetDesignColumn(DesignIndex: integer): TDBMColumn;
var
  ColumnIndex: integer;
begin
  {This function returns a column using the design index; The developer is
   guaranteed to refer to the design column regardless of whether an end-user
   has moved it;}

  Result:= nil;

  for ColumnIndex:= 0 to Pred(Columns.Count) do with Columns[ColumnIndex] do
  begin
    if DBMCol = DesignIndex then
    begin
      Result:= Columns[ColumnIndex];
      Break;
    end;
  end;
end;

function TMultiList.GetDesignIndex(RuntimeIndex: integer): integer;
begin
  {This function returns the design index for a column using the runtime index;}

  Result:= Columns[RuntimeIndex].DBMCol;
end;

function TMultiList.GetRuntimeIndex(DesignIndex: integer): integer;
var
ColIndex: integer;
begin
  {This function returns the runtime index for a column using the design index;
   The funtion will point to the location of a column given it's initial design
   index;}

  Result:= -1;

  for ColIndex:= 0 to Pred(Columns.Count) do with Columns[ColIndex] do
  begin
    if DBMCol = DesignIndex then
    begin
      Result:= ColIndex;
      Break;
    end;
  end;
end;

procedure TMultiList.ClearItems;
var
  ColIndex: integer;
begin
  {Clears all the items from all columns;}

  for ColIndex:= 0 to Pred(Columns.Count) do begin
    Columns[ColIndex].Items.Clear;
  end;{for}
end;

procedure TMultiList.PanelScrollClick(Sender: TObject; ScrollType: TSButtonType; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
MoveCursor: boolean;
ScreenItems: integer;
begin
  {Clicking on the DBMScrollBar causes the multi-cursor to move; If the control
   or shift keys are depressed, the selection will not change; Surface the
   OnScrollClick event;}

  MoveCursor:= not(ssCtrl in Shift) and not(ssShift in Shift);
  ScreenItems:= ScreenItemsCount;

  if Columns.Count > 0 then with fDBMScrollBox, Columns[0].Items do
  begin
    case ScrollType of
      btTop: if CanSelect(0) then InvalidateSelected(MoveCursor, 0);
      btBottom: if CanSelect(Count - 1) then InvalidateSelected(MoveCursor, Count - 1);
      btOneUp: if CanSelect(Selected - 1) then InvalidateSelected(MoveCursor, Selected - 1);
      btOneDown: if CanSelect(Selected + 1) then InvalidateSelected(MoveCursor, Selected + 1);
      btPageUp:
      begin
        if CanSelect(Selected - ScreenItems + 1) then InvalidateSelected(MoveCursor, Selected - ScreenItems + 1)
        else if CanSelect(0) then InvalidateSelected(MoveCursor, 0);
      end;
      btPageDown:
      begin
        if CanSelect(Selected + ScreenItems - 1) then InvalidateSelected(MoveCursor, Selected + ScreenItems - 1)
        else if CanSelect(Count - 1) then InvalidateSelected(MoveCursor, Count - 1);
      end;
    end;
  end;

  if Assigned(OnScrollClick) and (Sender <> nil)
  then OnScrollClick(Self, ScrollType, Button, Shift, X, Y);
end;

procedure TMultiList.RowClicked(RowIndex: integer);
begin
  if Assigned(OnRowClick) then OnRowClick(Self, RowIndex);
end;

procedure TMultiList.RowDblClicked(RowIndex: integer);
begin
  if Assigned(OnRowDblClick) then OnRowDblClick(Self, RowIndex);
end;

{Handle mouse wheel events in the same manner as arrow up and arrow down; Surface
 the wheel events;}

procedure TMultiList.PanelMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if fWheelTime > GetTickCount then Exit;

  fWheelTime:= GetTickCount + 10;
  if (Columns.Count > 0) and fDBMScrollBox.CanSelect(Selected + 1) then fDBMScrollBox.InvalidateSelected(true, Selected + 1);
  if Assigned(OnMouseWheelDown) then OnMouseWheelDown(Sender, Shift, MousePos, Handled);
end;

procedure TMultiList.PanelMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if fWheelTime > GetTickCount then Exit;

  fWheelTime:= GetTickCount + 10;
  if (Columns.Count > 0) and fDBMScrollBox.CanSelect(Selected - 1) then fDBMScrollBox.InvalidateSelected(true, Selected - 1);
  if Assigned(OnMouseWheelUp) then OnMouseWheelUp(Sender, Shift, MousePos, Handled);
end;

function TMultiList.ScreenItemsCount: integer;
begin
  {Used for page up and page down DBMScrollBar movement and also exposed to users;}

  Result:= fDBMScrollBox.ScreenItemsCount;
end;

function TMultiList.ItemsCount : integer;
begin
  if Columns.Count > 0 then result := Columns[0].Items.Count
  else result := 0;
end;

{Used in multi-selection;}

function TMultiList.IsMultiSelected(SelectValue: variant): boolean;
begin
  Result:= fDBMScrollBox.IsMultiSelected(SelectValue);
end;

function TMultiList.IsSelected(SelectValue: variant): boolean;
begin
  Result:= fDBMScrollBox.IsSelected(SelectValue);
end;

function TMultiList.isBetween(Var1, Var2, Var3: variant): boolean;
begin
  Result:= false;
  if (Var1 <= Var3) and (Var2 >= Var3) then Result:= true;
  if (Var2 <= Var3) and (Var1 >= Var3) then Result:= true;
end;

function TMultiList.isShiftAllowed: boolean;
begin
  Result:= true;
end;

function TMultiList.GetControlSelected: TControlSelectType;
var
ControlSelects: TStringList;
ShiftSelects: TShiftSelectType;
SelectResult: TControlSelectType;
SelectIndex, ShiftIndex: integer;
ShiftFound: boolean;
begin
  {Returns the ControlSelected values, not included in the shift ranges, to the
   caller in a dynamic TControlSelect array;}

  ControlSelects:= fDBMScrollBox.GetControlSelected;
  ShiftSelects:= GetShiftSelected;
  ShiftFound:= false;

  with ControlSelects do
  begin
    for SelectIndex:= 0 to Count - 1 do with TSelectDetails(Objects[SelectIndex]) do
    begin
      for ShiftIndex:= Low(ShiftSelects) to High(ShiftSelects) do with ShiftSelects[ShiftIndex] do
      begin
        if (Var2 >= RangeLow) and (Var2 <= RangeHigh) then
        begin
          ShiftFound:= true;
          Break;
        end;
      end;

      if not ShiftFound and Var1 then
      begin
        SetLength(SelectResult, Length(SelectResult) + 1);
        SelectResult[High(SelectResult)]:= Var2;
      end;
      ShiftFound:= false;
    end;
  end;
  Result:= SelectResult;
end;

function TMultiList.GetShiftSelected: TShiftSelectType;
var
ShiftSelects: TStringList;
SelectResult: TShiftSelectType;
SelectIndex: integer;
begin
  {Return the shift ranges in a dynamic TShiftSelectType array with the lower
   value in RangeLow and the higher in RangeHigh;}

  ShiftSelects:= fDBMScrollBox.GetShiftSelected;

  with ShiftSelects do
  begin
    for SelectIndex:= 0 to Count - 1 do with TSelectDetails(Objects[SelectIndex]) do
    begin
      SetLength(SelectResult, Length(SelectResult) + 1);
      with SelectResult[High(SelectResult)] do
      begin
        if Var1 <= Var2 then RangeLow:= Var1 else RangeLow:= Var2;
        if Var1 <= Var2 then RangeHigh:= Var2 else RangeHigh:= Var1;
      end;
    end;
  end;

  Result:= SelectResult;
end;

//*** TDBMScrollBox ************************************************************

constructor TDBMScrollBox.Create(AOwner: TComponent);
begin
  {DBMScrollBox is a ScrollingWinControl containing three components; The canvas
   from fPanel is used for all painting; fForceScroll is a zero-width panel
   positioned within DBMScrollBox to control the total horizontal scroll width;
   fKeys is a zero-width edit box used to capture key presses where the other
   components cannot;

   fPanel is initialized and aligned to the size of the scrollbox; As fForceScroll
   moves within the scrollbox, fPanel adjusts in size; OnBroadcastWidth is an
   event fired whenever columns are painted; The event triggers NewScrollWidth
   which adjusts the position of fForceScroll accordingly; All fPanel events are
   surfaced to MultiList;

   fKeys key events are also surfaced and handled by MultiList;}

//  TWinControl(Self).ControlStyle := TWinControl(Self).ControlStyle + [csOpaque];
//  TWinControl(Self).ControlState := TWinControl(Self).ControlState + [csCustomPaint];

  inherited;

  fPanel:= TDBMPanel.Create(Self);
  with fPanel do
  begin
    OnBroadcastWidth:= NewScrollWidth;
    OnBroadcastMaxRecs:= BroadcastMaxRecs;
    OnHeaderDblClick:= HeaderDblClick;
    BevelInner:= bvNone;
    BevelOuter:= bvNone;
    Parent:= Self;
    Align:= alClient;

    OnAddSelect:= PanelAddSelect;
    OnCellPaint:= PanelCellPaint;
    OnNavigate:= PanelNavigate;
    OnChangeSelection:= PanelChangeSelection;
    OnHeaderClick:= PanelHeaderClick;
    OnIsMultiSelected:= PanelIsMultiSelected;
    OnColumnClick:= PanelColumnClick;
    OnSplitterClick:= PanelSplitterClick;

    OnCanResize:= PanelCanResize;
    OnClick:= PanelClick;
    OnDblClick:= PanelDblClick;
    OnDragDrop:= PanelDragDrop;
    OnDragOver:= PanelDragOver;
    OnEndDrag:= PanelEndDrag;
    OnEnter:= PanelEnter;
    OnExit:= PanelExit;
    OnMouseDown:= PanelMouseDown;
    OnMouseMove:= PanelMouseMove;
    OnMouseUp:= PanelMouseUp;
    OnMouseWheel:= PanelMouseWheel;
    OnMouseWheelDown:= PanelMouseWheelDown;
    OnMouseWheelUp:= PanelMouseWheelUp;
    OnResize:= PanelResize;
    OnStartDrag:= PanelStartDrag;
  end;

  fForceScroll:= TPanel.Create(Self);
  with fForceScroll do
  begin
    Width:= 0;
    Parent:= Self;
  end;

  fKeys:= TMLCaptureEdit.Create(Self);
  with fKeys do
  begin
    Width:= 0;
    Parent:= Self;
    OnKeyDown:= PanelKeyDown;
    OnKeyPress:= PanelKeyPress;
    OnKeyUp:= PanelKeyUp;
  end;

  BorderInner:= bsSingle;
  VertScrollBar.Visible:= false;
end;

procedure TDBMScrollBox.CreateParams(var Params: TCreateParams);
begin
  {MultiList BorderInner is controlled using the BorderStyle property of
   DBMScrollBox; To toggle this property the window must be recreated and the
   BorderStyle set during CreateParams;}

  inherited CreateParams(Params);

  if fBorderInner = bsSingle then Params.ExStyle:= Params.ExStyle or WS_EX_CLIENTEDGE;
end;

procedure TDBMScrollBox.NewScrollWidth(NewWidth: integer);
begin
  {Position fForceScroll to control the scrollbox area, and ensure the fKeys edit
   is not positioned beyond it;}

  fForceScroll.Left:= NewWidth + fPanel.GetBevelWidth - HorzScrollBar.Position;
  if fKeys.Left > fForceScroll.Left then fKeys.Left:= fForceScroll.Left;
end;

procedure TDBMScrollBox.BroadcastMaxRecs(MaxRecs: integer);
begin
  {Surface the new maximum displayable records from DBMPanel to DBMultilist to
   control the number of database records retrieved;}

  if Assigned(OnBroadcastMaxRecs) then OnBroadcastMaxRecs(MaxRecs);
end;

procedure TDBMScrollBox.HeaderDblClick(ColIndex: integer);
begin
  {Surface Header DblClicks for column sorting;}
  if Assigned(OnHeaderDblClick) then OnHeaderDblClick(ColIndex);
end;

{Pass-through key events to MultiList;}

procedure TDBMScrollBox.PanelKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Assigned(OnKeyDown) then OnKeyDown(Self, Key, Shift);
end;

procedure TDBMScrollBox.PanelKeyPress(Sender: TObject; var Key: Char);
begin
  if Assigned(OnKeyPress) then OnKeyPress(Self, Key);
end;

procedure TDBMScrollBox.PanelKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Assigned(OnKeyUp) then OnKeyUp(Self, Key, Shift);
end;

function TDBMScrollBox.CanSelect(NewSelected: integer): boolean;
var
OldSelected: integer;
begin
  {An item can be selected if the item index is between the first and last
   available item index, and the attempt to change the Selected property succeeds;
   The Selected property is not changed permanently until DBMPanel.InvalidateSelected;
   This is because both the old and the new Selected value must be known for
   invalidation purposes;}

  with fPanel do
  begin
    Result:= true;
    if Columns.Count <= 0 then
    begin
      Result:= false;
      Exit;
    end;

    if NewSelected < 0 then Result:= false;

    if NewSelected >= Columns[0].Items.Count then Result:= false;

    if Result then
    begin
      OldSelected:= Selected;
      Selected:= NewSelected;
      // NF: this does not take into account the fact that the selected line may not have changed
      //     but the info on that line might have (delete_rec)
//      if Selected = OldSelected then Result:= false;
      Selected:= OldSelected;
    end;
  end;
end;

procedure TDBMScrollBox.MoveColumn(OldLoc: integer; NewLoc: integer);
begin
  {Allows TMultiList to move columns on DBMPanel when initializing the display
   for individual users;}

  fPanel.MoveColumn(OldLoc, NewLoc);
end;

procedure TDBMScrollBox.InvalidateHeader;
begin
  {This method is used to TMultiList to move between columns using right and left
   arrow keys; It ensures changes to Col are painted;}

  fPanel.InvalidateHeader;
end;

procedure TDBMScrollBox.InvalidateColumns;
var
ColIndex: integer;
begin
  {Allows TMultiList to repaint all columns;}

  for ColIndex:= 0 to Columns.Count - 1 do fPanel.InvalidateColumn(ColIndex);
end;

procedure TDBMScrollBox.InvalidateSelected(MoveCursor: boolean; NewSelected: integer);
begin
  {This method is exposed for DBMScrollbar to influence selected;}

  fPanel.InvalidateSelected(MoveCursor, NewSelected);
end;

{Used in multi-selection;}

function TDBMScrollBox.GetControlSelected: TStringlist;
begin
  Result:= fPanel.fControlSelects;
end;

function TDBMScrollBox.GetShiftSelected: TStringlist;
begin
  Result:= fPanel.fShiftSelects;
end;

function TDBMScrollBox.IsMultiSelected(ListIndex: integer): boolean;
begin
  Result:= fPanel.IsMultiSelected(ListIndex);
end;

function TDBMScrollBox.IsSelected(ListIndex: integer): boolean;
begin
  Result:= fPanel.IsSelected(ListIndex);
end;

function TDBMScrollBox.ScreenItemsCount: integer;
begin
  {Used by DBMScrollBar for paging up and down;}

  Result:= fPanel.ScreenItemsCount;
end;

{All columns are notified of the MultiList update mode to ensure repaint requests
 are suppressed;}

procedure TDBMScrollBox.BeginUpdate;
var
ColIndex: integer;
begin
  for ColIndex:= 0 to Columns.Count - 1 do Columns[ColIndex].BeginUpdate;
end;

procedure TDBMScrollBox.EndUpdate;
var
ColIndex: integer;
begin
  for ColIndex:= 0 to Columns.Count - 1 do Columns[ColIndex].EndUpdate;
end;

//*** TDBMPanel ****************************************************************

//*** Create and Destroy *******************************************************

constructor TDBMPanel.Create(AOwner: TComponent);
begin
  {DoubleBuffered reduces flicker by painting to an offscreen bitmap and flipping;
   There is a corresponding reduction in refresh rate; fDBMColumns is the
   owned collection for individual DBMColumns;}

  inherited;

//  TempBitmap := TBitmap.Create;
//  iLastPaint := 0;

  DoubleBuffered:= true;
  fDoubleClicked := FALSE; // NF: to fix a problem that the list kept focus after a double click - even if you have opened a new non-modal window
//  DoubleBuffered:= FALSE;

  fDBMColumns:= TDBMColumns.Create(Self);
  fControlSelects:= TStringList.Create;
  fShiftSelects:= TStringList.Create;

  fHeaderHeight:= 30;
  fBevelHeader:= bvRaised;
  fColDragIndex:= -2;   //Inactive;
  fDoubleClickTime:= GetTickCount;
  fSplitterWidth:= 6;
  fSplitterColour:= clBtnFace;
  fSelBrushColour:= clHighlight;
  fSelHeaderColour:= clBlack;
  fSelMultiColour:= clHighlight;
  fSelTextColour:= clHighlightText;
  fSelected:= -1;
  fSelHeaderBold:= true;
  fSortedAsc:= true;
  fStoreWidth:= -1;

  fControlSelected:= nil;
  fShiftSelected:= -1;

  Caption:= '';
end;

destructor TDBMPanel.Destroy;
begin
//  FreeAndNil(TempBitmap);
  FreeAndNil(fShiftSelects);
  FreeAndNil(fControlSelects);
  FreeAndNil(fDBMColumns);

  inherited;
end;

//*** Message Handling *********************************************************

procedure TDBMPanel.DefaultHandler(var Msg);
var
ColIndex: integer;
begin
  {Depending on the message received from a DBMColumn, part of the DBMPanel canvas
   is invalidated;}

  case TMessage(Msg).Msg of
    DBM_CAPTIONCHANGED, DBM_SORTABLECHANGED: InvalidateHeader;
    DBM_COLOURCHANGED, DBM_ALIGNMENTCHANGED, DBM_ITEMSCHANGED: InvalidateColumn(TMessage(Msg).LParam);
    DBM_SELECTCHANGED: InvalidateSelected(true, TMessage(Msg).LParam);
    DBM_COLCREATED, DBM_COLDESTROYED: Invalidate;
    DBM_VISIBLECHANGED:
    begin
      for ColIndex:= TMessage(Msg).LParam to Columns.Count - 1 do InvalidateColumn(ColIndex);
      InvalidateHeader;
      InvalidateSpace;
    end;
    DBM_WIDTHCHANGED:
    begin
      for ColIndex:= TMessage(Msg).LParam to Columns.Count - 1 do InvalidateColumn(ColIndex);
      InvalidateSpace;
    end
    else inherited DefaultHandler(Msg);
  end;
end;

procedure TDBMPanel.InvalidateHeader;
var
InvalidRect: TRect;
BevWidth: integer;
begin
  {Invalidates the top of the panel to the bottom of the header, excluding the
   bevels;}

  BevWidth:= GetBevelWidth;
// InvalidRect:= Rect(BevWidth + 10, BevWidth, Width - BevWidth, GetHeaderHeight);
  InvalidRect:= Rect(BevWidth, BevWidth, Width - BevWidth, GetHeaderHeight);//NF:
  InvalidateRect(Handle, @InvalidRect, true);
end;

procedure TDBMPanel.InvalidateColumn(ColumnIndex: integer);
var
InvalidRect: TRect;
BevWidth, WidthAccrued: integer;
begin
  {Invalidates a vertical slice of the canvas corresponding to a column and its
   splitter, excluding bevels;}

  TMultiList(Owner.Owner).SetMultiSelectedSize;

  BevWidth:= GetBevelWidth;
  WidthAccrued:= GetWidthAccrued(ColumnIndex);

  with Columns[ColumnIndex] do
  begin
    InvalidRect:= Rect(WidthAccrued, BevWidth, WidthAccrued + Width + SplitterWidth + 1, Height - BevWidth);
    InvalidateRect(Handle, @InvalidRect, true);
  end;
end;

procedure TDBMPanel.InvalidateSelected(MoveCursor: boolean; NewSelected: integer);
var
InvalidRect: TRect;
BevWidth, WidthAccrued, HeightAccrued, TextIndex, ItemHeight, BottomItem: integer;
begin
  {First calls the MultiList OnNavigate event to give the user an opportunity
   to disallow the new selection; Only the old selection and the new selection
   are invalidated to minimize flicker; Once the old selection has been invalidated
   the Selected property is updated, and the new selection is painted;}

// if selected = NewSelected then exit; // doesn't work when using scroll buttons

  if not TMultilist(Owner.Owner).Navigate(NewSelected) then Exit;

  with InvalidRect do
  begin
    BevWidth:= GetBevelWidth;
    WidthAccrued:= GetWidthAccrued(Columns.Count);
    HeightAccrued:= GetHeaderHeight;
    ItemHeight:= Canvas.TextHeight('Yy');

    for TextIndex:= fTopItem to Selected - 1 do inc(HeightAccrued, ItemHeight);

    TopLeft:= Point(BevWidth, HeightAccrued - 2);
    BottomRight:= Point(WidthAccrued, HeightAccrued + ItemHeight + 2);
    InvalidateRect(Handle, @InvalidRect, true);

    BottomItem:= GetBottomItem;
    if MoveCursor then Selected:= NewSelected;
    if Selected < fTopItem then
    begin
      fTopItem:= Selected;
      Invalidate;
    end
    else if Selected > BottomItem then
    begin
      fTopItem:= fTopItem + Selected - BottomItem;
      Invalidate;
    end;

    HeightAccrued:= GetHeaderHeight;
    for TextIndex:= fTopItem to Selected - 1 do inc(HeightAccrued, ItemHeight);
    Top:= HeightAccrued;
    Bottom:= HeightAccrued + ItemHeight + 2;
    InvalidateRect(Handle, @InvalidRect, true);
  end;

  if Assigned(OnChangeSelection) then OnChangeSelection(Self);
end;

procedure TDBMPanel.InvalidateSpace;
var
InvalidRect: TRect;
BevWidth, WidthAccrued: integer;
begin
  {Invalidates any canvas space remaining beyond the last column;}

  BevWidth:= GetBevelWidth;
  WidthAccrued:= GetWidthAccrued(Columns.Count);
  InvalidRect:= Rect(WidthAccrued, BevWidth, Width - BevWidth, Height - BevWidth);
  InvalidateRect(Handle, @InvalidRect, true);
end;

//*** Painting *****************************************************************

procedure TDBMPanel.Paint;
begin
  inherited;

//  TempBitmap.Width := Width;
//  TempBitmap.Height := Height;

//  if GetTickCount - iLastPaint > 20 then begin

    PaintHeader;
    PaintFrame;
    PaintCaptions;
    PaintColumns;
    PaintText;
//    TMultilist(Owner.Owner).fScrollBar.PaintScrollBar;

//  end;

//  iLastPaint := GetTickCount;

//  BitBlt(Canvas.Handle, 0, 0, TempBitmap.Width, TempBitmap.Height
//  ,TempBitmap.Canvas.Handle, 0, 0, SRCCOPY);
end;

procedure TDBMPanel.PaintHeader;
var
BevWidth: integer;
begin
  BevWidth:= GetBevelWidth;

  with Canvas do
  begin
    if BevelHeader <> bvNone then
    begin

      //Set the pen colour depending on the state of the BevelHeader;

      case BevelHeader of
        bvRaised, bvSpace: Pen.Color:= clWhite;
        bvLowered: Pen.Color:= clGray;
      end;

      //Draw the top and left line;

      MoveTo(BevWidth, BevWidth);
      LineTo(BevWidth, GetHeaderHeight);
      MoveTo(BevWidth, BevWidth);
      LineTo(Width - BevWidth, BevWidth);

      //Toggle the pen colour;

      case BevelHeader of
        bvRaised, bvSpace: Pen.Color:= clGray;
        bvLowered: Pen.Color:= clWhite;
      end;

      //Draw the right line;

      MoveTo(Width - BevWidth - 1, BevWidth);
      LineTo(Width - BevWidth - 1, GetHeaderHeight);
    end;
  end;
end;

procedure TDBMPanel.PaintFrame;
var
BevWidth: integer;
LineColour: TColor;
begin
  {Note: This procedure does not paint the frame lines above and below each
   column; These lines are painted within PaintColumns;}

  BevWidth:= GetBevelWidth;
  LineColour:= clWhite;

  with Canvas do
  begin
    {Draw the left line on the left side of the frame;}

    if BevelHeader <> bvNone then
    begin
      if BevelHeader = bvLowered then LineColour:= clGray;
      DrawVertLine(LineColour, BevWidth, GetHeaderHeight, Height - BevWidth, Canvas);
    end;

    {Fill the space on the left side of the frame with the appropriate colour;}

    DrawMain(Self.Color, Rect(BevWidth + 1, GetHeaderHeight, BevWidth + SplitterWidth, Height - BevWidth), Canvas);

    {Draw the right line on the left side of the frame;
     Draw the bottom line on the bottom of the frame;
     Draw the right line on the bottom of the frame;}

    if BevelHeader <> bvNone then
    begin
      if LineColour = clWhite then LineColour:= clGray else LineColour:= clWhite;
      DrawVertLine(LineColour, BevWidth + SplitterWidth, GetHeaderHeight, Height - BevWidth - SplitterWidth, Canvas);
      DrawHorizLine(LineColour, Height - BevWidth - 1, BevWidth, Width - BevWidth, Canvas);
      DrawVertLine(LineColour, Width - BevWidth - 1, Height - BevWidth - SplitterWidth, Height - BevWidth, Canvas);
    end;
  end;
end;

procedure TDBMPanel.PaintCaptions;
var
  ColIndex, BevWidth, WidthAccrued: integer;
  DrawRect, HighlightRect: TRect;
//  OriginalColour: TColor;
//  OriginalStyles: TFontStyles;
  OriginalFont : TFont;
  OrderPoints: array of TPoint;
begin
  BevWidth:= GetBevelWidth;
  WidthAccrued:= BevWidth + SplitterWidth;

//  OriginalColour:= Font.Color;
//  OriginalStyles:= Font.Style;
  OriginalFont := Font;

  for ColIndex:= 0 to Columns.Count - 1 do with Canvas, Columns[ColIndex] do
  begin
    if not Visible then Continue;

    if Width > 0 then
    begin

      Font := TMultilist(Owner.Owner).HeaderFont;

      {Selected columns have their text drawn in the highlighted colour;}
{      if ColIndex = Col then
      begin
//        Font.Color:= SelHeaderColour;
//        Font.Color:= TMultilist(Owner.Owner).Font.Color;
        Font := TMultilist(Owner.Owner).HeaderFont;

        if SelHeaderBold then Font.Style:= [fsBold];
      end;}

      DrawRect:= Rect(WidthAccrued + 1, BevWidth + 1, WidthAccrued + Width - 1 - GetTriangleOffset(ColIndex), GetHeaderHeight - 1);
//      DrawRect:= Rect(WidthAccrued + 4, BevWidth + 1, WidthAccrued + Width - 1 - GetTriangleOffset(ColIndex), GetHeaderHeight - 1); //NF:

      if (fColDragIndex >= -1) and (ColIndex = fDragCol) then with DrawRect do
      begin
        Font.Color := TMultilist(Owner.Owner).HighlightFont.color;
//        Font := TMultilist(Owner.Owner).HighlightFont;
//        Font.Color:= SelTextColour;
        Brush.Color:= SelBrushColour;
        Brush.Style:= bsSolid;

        HighlightRect:= Rect(Left, Top - 1, Right + 2, Bottom + 1);
        FillRect(HighlightRect);
        Brush.Style:= bsClear;
      end;

      {The DrawText API ensures no text will be drawn outside of DrawRect; The
       API also handles alignment and wrapping;}

      case Alignment of
        taLeftJustify: DrawText(Handle, PChar(' ' + Caption), Length(Caption) + 1, DrawRect, DrawFormat or DT_LEFT);
//        taLeftJustify: DrawText(Handle, PChar(Caption), Length(Caption), DrawRect, DrawFormat or DT_LEFT);
        taCenter: DrawText(Handle, PChar(Caption), Length(Caption), DrawRect, DrawFormat or DT_CENTER);
        taRightJustify: DrawText(Handle, PChar(Caption), Length(Caption), DrawRect, DrawFormat or DT_RIGHT);
      end;

      {Draw order triangle indicators where necessary;}

//      if {(Field <> '') and} (Width >= 8) then
      if (Field <> '') and (Width >= 8) then
      begin
        if (Field = fSortedField) then
        begin
          Pen.Color:= fSortedTriangle;
          Brush.Color:= fSortedTriangle;
          Brush.Style:= bsSolid;

          SetLength(OrderPoints, 3);
          if fSortedAsc then
          begin
            OrderPoints[0]:= Point(WidthAccrued + Width - 3, GetHeaderHeight - 9);
            OrderPoints[1]:= Point(WidthAccrued + Width - 6, GetHeaderHeight - 3);
            OrderPoints[2]:= Point(WidthAccrued + Width, GetHeaderHeight - 3);
          end
          else
          begin
            OrderPoints[0]:= Point(WidthAccrued + Width - 6, GetHeaderHeight - 9);
            OrderPoints[1]:= Point(WidthAccrued + Width, GetHeaderHeight - 9);
            OrderPoints[2]:= Point(WidthAccrued + Width - 3, GetHeaderHeight - 3);
          end;

          Canvas.Polygon(OrderPoints);
          Brush.Style:= bsClear;
        end
        else if Sortable then
        begin
          Pen.Color:= fSortableTriangle;

          SetLength(OrderPoints, 3);
          OrderPoints[0]:= Point(WidthAccrued + Width - 3, GetHeaderHeight - 9);
          OrderPoints[1]:= Point(WidthAccrued + Width - 6, GetHeaderHeight - 3);
          OrderPoints[2]:= Point(WidthAccrued + Width, GetHeaderHeight - 3);

          Canvas.Polygon(OrderPoints);
        end;
      end;
    end;
    Inc(WidthAccrued, Width + SplitterWidth + 1);
//    Font.Color:= OriginalColour;
//    Font.Style:= OriginalStyles;
    Font := OriginalFont;
  end;
end;

procedure TDBMPanel.PaintColumns;
var
  ColIndex, ColumnIndex, BevWidth, WidthAccrued: integer;
begin

  BevWidth:= GetBevelWidth;
  WidthAccrued:= BevWidth + SplitterWidth + 1;

  for ColIndex:= 0 to Columns.Count - 1 do with Columns[ColIndex] do
  begin
    if not Visible then Continue;

    {For raised bevels, draw a gray and white line above and below the current
     column; Fill the column area with the appropriate colour;}

    if BevelHeader in [bvRaised, bvSpace] then
    begin
      DrawHorizLine(clGray, GetHeaderHeight, WidthAccrued - 1, WidthAccrued + Width + 1, Canvas);
      DrawHorizLine(clWhite, Height - BevWidth - SplitterWidth, WidthAccrued - 1, WidthAccrued + Width + 1, Canvas);
    end;
    DrawMain(Color, Rect(WidthAccrued, GetHeaderHeight + 1, WidthAccrued + Width, Height - BevWidth - SplitterWidth), Canvas);


    {Splitters are painted beyond the current column width; Splitter headers are
     painted to indicate the drop location when columns are being dragged; The
     header is drawn on the splitter preceding the selected column; To ensure a
     splitter header is not drawn on an invisible column, test the next visible
     column against fColDragIndex;}

    Inc(WidthAccrued, Width);

    if fColDragIndex = ColIndex then PaintSplitterHeader(WidthAccrued)
    else if isMovingToFirst then
    begin
      PaintSplitterHeader(GetBevelWidth - 1, Canvas);
      PaintSplitterHeader(GetBevelWidth, Canvas);
    end
    else
    begin
      ColumnIndex:= ColIndex;
      while (ColumnIndex < Columns.Count - 1) and not(Columns[ColumnIndex + 1].Visible) do Inc(ColumnIndex);
      if fColDragIndex = ColumnIndex then PaintSplitterHeader(WidthAccrued, Canvas)
    end;

    PaintSplitter(WidthAccrued, Columns[ColIndex], Canvas);


    {For a lowered frame bevel, draw a white and grey line above and below the
     current column; For a nonexistent frame bevel, draw a small white line above
     the current splitter;}

    case BevelHeader of
      bvLowered:
      begin
        DrawHorizLine(clWhite, GetHeaderHeight, WidthAccrued - Width, WidthAccrued + SplitterWidth, Canvas);
        DrawHorizLine(clGray, Height - BevWidth - SplitterWidth, WidthAccrued - Width, WidthAccrued + SplitterWidth, Canvas);
      end;
      bvNone: DrawHorizLine(clWhite, GetHeaderHeight, WidthAccrued, WidthAccrued + SplitterWidth, Canvas);
    end;
    inc(WidthAccrued, SplitterWidth + 1);
  end;

  {Once all columns are painted, draw bevels above and below the empty space;}

  case BevelHeader of
    bvRaised, bvSpace:
    begin
      DrawHorizLine(clGray, GetHeaderHeight, WidthAccrued - 1, Width - BevWidth, Canvas);
      DrawHorizLine(clWhite, Height - BevWidth - SplitterWidth, WidthAccrued, Width - BevWidth, Canvas);
    end;
    bvLowered:
    begin
      DrawHorizLine(clWhite, GetHeaderHeight, WidthAccrued - 1, Width - BevWidth, Canvas);
      DrawHorizLine(clGray, Height - BevWidth - SplitterWidth, WidthAccrued, Width - BevWidth, Canvas);
    end;
  end;

  {If and only if the total column width has changed, broadcast the new width
   to DBMScrollBox, so the scrollbox can reposition fForceScroll to adjust the
   scrollbox client area;}

  if WidthAccrued <> fStoreWidth then
  begin
    fStoreWidth:= WidthAccrued;
    OnBroadcastWidth(WidthAccrued);
  end;

end;

procedure TDBMPanel.PaintText;
var
ColIndex, ListIndex, WidthAccrued, HeightAccrued, MaxHeight: integer;
OwnerText: ANSIstring;
DrawRect: TRect;
TextFont, OriginalFont: TFont;
TextBrush, OriginalBrush: TBrush;
TextAlign: TAlignment;
begin
  WidthAccrued:= GetBevelWidth + SplitterWidth;
  MaxHeight:= Height - GetBevelWidth - SplitterWidth;

  OriginalFont:= TFont.Create;
  OriginalBrush:= TBrush.Create;
  TextFont:= TFont.Create;
  TextBrush:= TBrush.Create;
  try
    OriginalFont.Assign(Font);
    OriginalBrush.Assign(Brush);
    TextFont.Assign(Font);
    TextBrush.Assign(Brush);


    {Broadcast the number of records capable of being displayed on screen;
     FlushColumns ensures that each column has the same number of items;}

    if Assigned(OnBroadcastMaxRecs) then OnBroadcastMaxRecs(GetMaxRecs);

    {WINDOWS 7 / VISTA Seddons Fix - ABSPLUG-93}
//    FlushColumns;

    for ColIndex:= 0 to Columns.Count - 1 do with Columns[ColIndex] do
    begin
      {Only visible columns have their text painted; Selected must be less than
       or equal to the number of items in the list; This is needed to reset
       selected once columns are cleared;}

      if not Visible then Continue;
      if Selected >= Items.Count then Selected:= Items.Count - 1;
      HeightAccrued:= GetHeaderHeight + 1;

      if Items.IsChanged and (Width > 0) then with Canvas, DrawRect do
      begin
        for ListIndex:= fTopItem to GetBottomItem do
        begin
          {Draw every item in every changed column; Restore the font, text
           alignment and brush for each item; Ensure no items are drawn outside
           of the maximum column height available;}

          Font.Assign(OriginalFont);
          Brush.Assign(OriginalBrush);
          Brush.Color:= Color;
          TextAlign:= Alignment;

          TopLeft:= Point(WidthAccrued + 2, HeightAccrued);
          if HeightAccrued + TextHeight('Yy') > MaxHeight then BottomRight:= Point(WidthAccrued + Width, MaxHeight)
          else BottomRight:= Point(WidthAccrued + Width, HeightAccrued + TextHeight('Yy'));


          {Fire the OnCellPaint event to give the user the chance to alter the
           font, brush, alignment details or the text being drawn; Draw any brush
           changes;}

          {WINDOWS 7 / VISTA Seddons Fix - ABSPLUG-93}
//          OwnerText:= Items[ListIndex];
          if (ListIndex >= 0) and (ListIndex < Items.Count) then OwnerText:= Items[ListIndex]
          else OwnerText := '';

          TextFont.Assign(Font);

          // set multiselect font
          if MultiSelect and IsMultiSelected(ListIndex)
          then TextFont.Assign(TMultilist(Owner.Owner).MultiSelectFont);

          // set Highlight font
          if Selected = ListIndex
          then TextFont.Assign(TMultilist(Owner.Owner).HighlightFont);

          TextBrush.Assign(Brush);
//          TextFont.Color:= TMultilist(Owner.Owner).Colours.CellText;
//          TextFont.Color:= TMultilist(Owner.Owner).Font.Color;
          if Assigned(OnCellPaint) then OnCellPaint(Self, ColIndex, ListIndex, OwnerText, TextFont, TextBrush, TextAlign);
          Brush.Assign(TextBrush);
          Font.Assign(TextFont);

          with DrawRect do FillRect(Rect(Left - 1, Top, Right + 1, Bottom));


          {If an item is selected, paint a box using SelMultiColour and set the
           font colour to SelTextColour;}

          if MultiSelect and IsMultiSelected(ListIndex) then with DrawRect do
          begin
            if Selected = ListIndex - 1 then DrawSelectRect(SelMultiColour, Rect(Left - 1, Top, Right + 1, Bottom + 1), TRUE)
            else DrawSelectRect(SelMultiColour, Rect(Left - 1, Top - 1, Right + 1, Bottom + 1), TRUE);
          end;
          if Selected = ListIndex then with DrawRect do DrawSelectRect(SelBrushColour, Rect(Left - 1, Top - 1, Right + 1, Bottom + 1), FALSE);


          {The DrawText API ensures no text will be drawn outside of DrawRect; The
           API also handles alignment and wrapping;}

          //NF: Added to add an extra gap between the splitter and the text
          DrawRect.Left := DrawRect.Left +1;
          DrawRect.Right := DrawRect.Right -1;

          // HM 22/01/04: Added DT_NoPrefix into flags to prevent '&' turning into underlines
          case TextAlign of
            taLeftJustify: DrawText(Handle, PChar(OwnerText), Length(OwnerText), DrawRect, DT_LEFT or DT_NoPrefix or DT_SINGLELINE);
            taCenter: DrawText(Handle, PChar(OwnerText), Length(OwnerText), DrawRect, DT_CENTER or DT_NoPrefix or DT_SINGLELINE);
            taRightJustify: DrawText(Handle, PChar(OwnerText), Length(OwnerText), DrawRect, DT_RIGHT or DT_NoPrefix or DT_SINGLELINE);
          end;

          inc(HeightAccrued, TextHeight('Yy'));
        end;
      end;
      inc(WidthAccrued, Width + SplitterWidth + 1);
    end;

  finally
    FreeAndNil(TextBrush);
    FreeAndNil(TextFont);
    FreeAndNil(OriginalFont);
  end;
end;

procedure TDBMPanel.PaintSplitter(ColLeft: integer; Column: TDBMColumn; ACanvas : TCanvas = nil);
var
BevWidth: integer;
begin
  BevWidth:= GetBevelWidth;

  if ACanvas = nil then ACanvas := Canvas;

  with ACanvas, Column do
  begin
    {Draws the left line of splitter, the body of the splitter and the righthand
     line;}

    DrawVertLine(clWhite, ColLeft, GetHeaderHeight, Height - BevWidth - SplitterWidth, Canvas);
    DrawMain(SplitterColour, Rect(ColLeft + 1, GetHeaderHeight, ColLeft + SplitterWidth, Height - BevWidth - SplitterWidth + 1), Canvas);
    DrawVertLine(clGray, ColLeft + SplitterWidth, GetHeaderHeight, Height - BevWidth - SplitterWidth, Canvas);

    {Draws the splitter handle on the header;}

    DrawVertLine(clWhite, ColLeft + (SplitterWidth div 2), BevWidth + 4, GetHeaderHeight - 5, Canvas);
    DrawVertLine(clGray, ColLeft + (SplitterWidth div 2) + 1, BevWidth + 5, GetHeaderHeight - 4, Canvas);

    {If the frame bevel is lowered two gray lines are drawn below the splitter;
     If the frame bevel is non-existent, only one is drawn;}

    if BevelHeader in [bvLowered, bvNone] then
    begin
      if BevelHeader = bvLowered then DrawHorizLine(clGray, Height - SplitterWidth - BevWidth - 1, ColLeft, ColLeft + SplitterWidth + 1, Canvas);
      DrawHorizLine(clGray, Height - SplitterWidth - BevWidth, ColLeft, ColLeft + SplitterWidth + 1, Canvas);
    end;
  end;
end;

procedure TDBMPanel.PaintSplitterHeader(ColLeft: integer; ACanvas : TCanvas = nil);
begin
  {Paints the splitter header when columns are being dragged;}

  if ACanvas = nil then ACanvas := Canvas;

  with ACanvas do
  begin
    DrawMain(SelBrushColour, Rect(ColLeft + 1, GetBevelWidth, ColLeft + SplitterWidth + 1, GetHeaderHeight), Canvas);
  end;
end;

procedure TDBMPanel.DrawMain(BoxColour: TColor; BoxRect: TRect; ACanvas : TCanvas = nil);
begin
  {Brushes BoxRect on the DBMPanel canvas using the BoxColour supplied;}

  if ACanvas = nil then ACanvas := Canvas;

  with ACanvas do
  begin
    Brush.Color:= BoxColour;
    Brush.Style:= bsSolid;
    FillRect(BoxRect);
    Brush.Style:= bsClear;
  end;
end;

{Draws horizontal and vertical lines on the DBMPanel canvas, according to the
 parameters supplied;}
{
procedure TDBMPanel.DrawHorizLine(LineColour: TColor; LineTop: integer; LineLeft: integer; LineRight: integer; ACanvas : TCanvas = nil);
begin
  if LineLeft >= LineRight then Exit;

  if ACanvas = nil then ACanvas := Canvas;

  with ACanvas do
  begin
    Pen.Color:= LineColour;
    MoveTo(LineLeft, LineTop);
    LineTo(LineRight, LineTop);
  end;
end;

procedure TDBMPanel.DrawVertLine(LineColour: TColor; LineLeft: integer; LineTop: integer; LineBottom: integer; ACanvas : TCanvas = nil);
begin
  if LineTop >= LineBottom then Exit;

  if ACanvas = nil then ACanvas := Canvas;

  with ACanvas do
  begin
    Pen.Color:= LineColour;
    MoveTo(LineLeft, LineTop);
    LineTo(LineLeft, LineBottom);
  end;
end;}

procedure TDBMPanel.DrawSelectRect(SelectColour: TColor; DrawRect: TRect; bMultiSelect : boolean; ACanvas : TCanvas = nil);
var
SelectRect: TRect;
begin
  {Draws selection bars in SelectColour;}

  if ACanvas = nil then ACanvas := Canvas;

  with ACanvas, DrawRect do
  begin
//    Font.Color:= SelTextColour;
{    if bMultiSelect then Font := TMultilist(Owner.Owner).MultiSelectFont
    else Font := TMultilist(Owner.Owner).HighlightFont;}

    Brush.Color:= SelectColour;
    Brush.Style:= bsSolid;

    SelectRect:= Rect(Left, Top, Right, Bottom);
    FillRect(SelectRect);
    Brush.Style:= bsClear;
  end;
end;

procedure TMultiList.WMSize(var Message: TWMSize);
//var
//  InvalidRect: TRect;
begin
  {Paints over random pixels that appear on the TMultilist panel perimeter
   following resizes;}

  inherited;

  if not(csDesigning in ComponentState) then with Canvas do
  begin
    Brush.Style:= bsSolid;
    Brush.Color:= Color;
    FillRect(ClientRect);
  end;

  fScrollBar.PaintScrollBar;

//  InvalidRect:= Rect(20, 20, 20, 20);
//  InvalidateRect(Handle, @InvalidRect, true);
end;

//*** Mouse Handling ***********************************************************

procedure TDBMPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
BevWidth: integer;
begin
  if not parent.parent.enabled then exit;

  // NF: to fix a problem that the list kept focus after a double click - even if you have opened a new non-modal window
  if fDoubleClicked then
  begin
    fDoubleClicked := FALSE;
    exit;
  end;

  inherited;

  {Whenever a mouse down occurs, the click location is stored in fLastClickLoc;
   This is necessary for the DblClick handler to receive the click location;
   Col stores the column index of the clicked column; This is needed for the
   ResizeColumn procedure called from MouseUp;}

  fLastClickLoc:= Point(X, Y);
  BevWidth:= GetBevelWidth;
  if (X - BevWidth < 0) or (Y - BevWidth < 0) then Exit;

  fDragCol:= GetColumnClicked(X);
  if fDragCol < 0 then Exit;

  {If the header is clicked, determine whether a splitter or column header has
  been clicked; Otherwise determine between a column and splitter;}

  if Y <= GetHeaderHeight then
  begin
    case isColumnClicked(X) of
      ccColumn: begin
        HeaderClick(Self, fDragCol, Button, Shift, X, Y); // column name clicked
      end;
      ccSplitter: SplitterClick(Self, fDragCol, Button, Shift, X, Y); // splitter in header clicked
    end;
  end
  else if Y <= Height - BevWidth - SplitterWidth then
  begin
    // splitter below header clicked
    case isColumnClicked(X) of
      ccColumn: ColumnClick(Self, fDragCol, Button, Shift, X, Y);
      ccSplitter: SplitterClick(Self, fDragCol, Button, Shift, X, Y);
    end;
  end;
end;

procedure TDBMPanel.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewLeft: integer;
  Cur: HCURSOR;
begin
  {If resizing, undraw the previous splitter rect, and calculate the location
   of the next; The splitter rect cannot be drawn to the left of the preceding
   splitter, i.e. a column cannot be resized to a negative width; Note: the
   function isColumnClicked is used in this procedure to determine if the cursor
   is over a splitter; The use of this method has nothing to do with clicking;}

  inherited;



  case isColumnClicked(X) of
    ccNone, ccColumn : Cursor:= crDefault;
    ccDrag : begin
//      columns[0].caption := IntTOStr(fColDragIndex);
//      Cursor := crDrag;
//      Cursor := DragCursor;
//      ShowCursor(TRUE);
      Cur := LoadCursor(HInstance, 'COLDRAG');
      SetCursor(Cur)
    end;
    ccSplitter : Cursor:= TMultilist(Owner.Owner).Custom.SplitterCursor;
//    ccDrag : Cursor:= crDrag;
  end;


  if fColResizing then
  begin
    DrawFocusRect(fScreenCanvas, fMoveRect);
    NewLeft:= fOriginalRect.Left + X - fOriginalX;
    if NewLeft < GetScreenX(fMinLeft) then NewLeft:= GetScreenX(fMinLeft);

    fMoveRect.Left:= NewLeft;
    fMoveRect.Right:= NewLeft + SplitterWidth + 1;
    DrawFocusRect(fScreenCanvas, fMoveRect);
  end
  else if fColDragIndex >= -1 then begin
    HighlightDrop(X);
  end;

end;

procedure TDBMPanel.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {If resizing, release all resources and resize the column; If dragging,
   move the column;}

  inherited;

  if Button = mbLeft then
  begin
    if fColResizing then
    begin
      fColResizing:= false;

      if GetCapture = Handle then ReleaseCapture;
      DrawFocusRect(fScreenCanvas, fMoveRect);
      ReleaseDC(0, fScreenCanvas);
      ResizeColumn;
    end
    else if fColDragIndex >= -1 then
    begin
      if fDragCol <> fColDragIndex + 1 then MoveColumn(fDragCol, fColDragIndex + 1);
      Invalidate;
      fColDragIndex:= -2;   //Inactive;
    end;
  end;
end;

procedure TDBMPanel.DblClick;
var
HeightAccrued, TextIndex: integer;
begin
  {This method fires before MouseDown; Setting fDoubleClickTime prevents the
   MouseDown event from processing the second click; Double-clicking a splitter
   causes the splitter's column to be compacted;}

  // NF: to fix a problem that the list kept focus after a double click - even if you have opened a new non-modal window
  fDoubleClicked := TRUE;

  with fLastClickLoc do
  begin
    if IsColumnClicked(X) <> ccColumn then
    begin
      CompactColumn(fDragCol);
      DoubleClickTime:= GetTickCount + 200;
    end
    else if (Y >= GetBevelWidth) and (Y <= GetHeaderHeight) then
    begin
      // NF: Fixed for fDragCol = -1
      if (fDragCol >= 0) and Assigned(OnHeaderDblClick) then
      begin
        OnHeaderDblClick(fDragCol);
        if Columns[fDragCol].Sortable then begin
          InvalidateHeader;
        end;
      end;
    end
    else if isColumnClicked(X) = ccColumn then with Canvas do
    begin
      HeightAccrued:= GetHeaderHeight + 1;
      for TextIndex:= fTopItem to GetBottomItem do
      begin
        inc(HeightAccrued, TextHeight('Yy'));
        if HeightAccrued >= Y then
        begin
          InvalidateSelected(true, TextIndex);
          TMultilist(Owner.Owner).RowDblClicked(TextIndex);
          Break;
        end;
      end;
    end
    else inherited;
  end;
end;

procedure TDBMPanel.HeaderClick(Sender: TObject; ColumnIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {When the header is clicked repaint it, and surface the click event;}

//  Cursor:= crDrag;
//  application.ProcessMessages;

  if Button = mbLeft then
  begin
    fColDragIndex:= ColumnIndex - 1;
    Col:= ColumnIndex;
    InvalidateHeader;
  end;

  if Assigned(OnHeaderClick) then OnHeaderClick(Self, ColumnIndex, Button, Shift, X, Y);
end;

procedure TDBMPanel.ColumnClick(Sender: TObject; ColumnIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
HeightAccrued, TextIndex: integer;
begin
  {If a column is clicked, determine the selected item and invalidate the old
   and new selections; Surface the column click event;}

  if Button = mbLeft then with Canvas do
  begin
    HeightAccrued:= GetHeaderHeight + 1;
    for TextIndex:= fTopItem to GetBottomItem do
    begin
      inc(HeightAccrued, TextHeight('Yy'));
      if HeightAccrued >= Y then
      begin
        if MultiSelect and (ssShift in Shift) then OnAddSelect(Self, fShiftSelects, fControlSelects, Shift, TextIndex)
        else if MultiSelect and (ssCtrl in Shift) then OnAddSelect(Self, fShiftSelects, fControlSelects, Shift, TextIndex)
        else
        begin
          InvalidateSelected(true, TextIndex);
          TMultilist(Owner.Owner).RowClicked(TextIndex);
        end;
        Break;
      end;
    end;
  end;

  if Assigned(OnColumnClick) then OnColumnClick(Self, ColumnIndex, Button, Shift, X, Y);
end;

procedure TDBMPanel.SplitterClick(Sender: TObject; ColumnIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
WidthAccrued: integer;
begin
  {Capture all mouse movement, draw the first splitter rect to the screen canvas
   and surface the splitter click event;}

  if SplitterWidth <= 0 then Exit;
  WidthAccrued:= GetWidthAccrued(ColumnIndex + 1);

  if Button = mbLeft then
  begin
    SetCapture(Handle);
    fScreenCanvas:= GetDC(0);

    fOriginalX:= X;
    fOriginalY:= Y;

    with Columns[ColumnIndex] do with fOriginalRect do
    begin
      TopLeft:= ClientToScreen(Point(WidthAccrued - SplitterWidth, GetHeaderHeight));
      BottomRight:= ClientToScreen(Point(WidthAccrued, Height - GetBevelWidth - SplitterWidth + 1));
    end;

    fMoveRect:= fOriginalRect;
    DrawFocusRect(fScreenCanvas, fMoveRect);
    Application.ProcessMessages;
    fColResizing:= true;
  end;

  if Assigned(OnSplitterClick) then OnSplitterClick(Self, ColumnIndex, Button, Shift, X, Y);
end;

procedure TDBMPanel.HighlightDrop(X: integer);
var
WidthAccrued, ColIndex: integer;
begin
  {Determines which splitter header is to be highlighted during a column drag;}

  WidthAccrued:= GetBevelWidth + SplitterWidth;
  for ColIndex:= 0 to Columns.Count - 1 do with Columns[ColIndex] do
  begin
    if not Visible then Continue;
    inc(WidthAccrued, Width + SplitterWidth + 1);

    if WidthAccrued > X then
    begin
      if fDragCol < ColIndex then fColDragIndex:= ColIndex else fColDragIndex:= ColIndex - 1;
      InvalidateHeader;
      Break;
    end;
  end;
end;

procedure TDBMPanel.MoveColumn(OldLoc: integer; NewLoc: integer);
var
  iPos : integer;
begin
  {Moves a column when dragged by inserting a new column into the DBMColumns
   collection and removing the old column; Shift the ActiveColumn index, Col,
   with the moving column;}

  if (NewLoc < 0) or (OldLoc < 0) then Exit;
  if (NewLoc > Columns.Count) or (OldLoc > Columns.Count) then Exit;

  Columns.Insert(NewLoc);
  if NewLoc < OldLoc then
  begin
    Columns[NewLoc].Assign(Columns[OldLoc + 1]);
    Columns.Delete(OldLoc + 1);
    Col:= NewLoc;

    For iPos := NewLoc to OldLoc
    do Columns[iPos].CurrentColPos := Columns[iPos].CurrentColPos + 1;
  end
  else
  begin
    Columns[NewLoc].Assign(Columns[OldLoc]);
    Columns.Delete(OldLoc);
    Col:= NewLoc - 1;

    For iPos := OldLoc to NewLoc -2 do
    begin
      Columns[iPos].CurrentColPos := Columns[iPos].CurrentColPos - 1;
    end;{for}
  end;
  Columns[Col].CurrentColPos := Col;
end;

procedure TDBMPanel.ResizeColumn;
var
ColIndex: integer;
begin
  {Adjust the width of the current column by the difference between the final
   and original splitter rects; Invalidate all columns from the resized column
   on and invalidate any leftover space;}

  with Columns[fDragCol] do
  begin
    Width:= Width + fMoveRect.Left - fOriginalRect.Left;
  end;

  for ColIndex:= 0 to Columns.Count - 1 do InvalidateColumn(ColIndex);
  InvalidateSpace;
end;

procedure TDBMPanel.CompactColumn(ColumnIndex: integer);
var
NewWidth, ListIndex, ColIndex: integer;
TextFont, OriginalFont: TFont;
TextBrush: TBrush;
TextAlign: TAlignment;
OwnerText: string;
begin
  {Owner drawn text width must be accounted for when compacting columns; This
   involves calling the OnCellPaint event;

   Determine the maximum text width for the items and caption in column
   ColumnIndex, resize the column and invalidate all columns from the compacted
   column on; Also, invalidate any leftover space;}

  OriginalFont:= TFont.Create;
  TextFont:= TFont.Create;
  TextBrush:= TBrush.Create;
  try
    OriginalFont.Assign(Font);
    TextFont.Assign(Font);
    TextBrush.Assign(Brush);

    NewWidth:= 0;
    with Columns[ColumnIndex], Canvas do
    begin
      for ListIndex:= 0 to Items.Count - 1 do
      begin
        Font.Assign(OriginalFont);
        TextAlign:= Alignment;

        OwnerText:= Items[ListIndex];
        TextFont.Assign(Font);
        if Assigned(OnCellPaint) then OnCellPaint(Self, ColumnIndex, ListIndex, OwnerText, TextFont, TextBrush, TextAlign);
        Font.Assign(TextFont);

        if TextWidth(OwnerText) > NewWidth then NewWidth:= TextWidth(OwnerText);
      end;
      if ColumnIndex = Col then Font.Style:= Font.Style + [fsBold];
      if NewWidth < TextWidth(Caption) then NewWidth:= TextWidth(Caption);
      Width:= NewWidth + GetTriangleOffset(ColumnIndex) + 3;
    end;

    for ColIndex:= ColumnIndex to Columns.Count - 1 do InvalidateColumn(ColIndex);
    InvalidateSpace;

  finally
    FreeAndNil(TextBrush);
    FreeAndNil(TextFont);
    FreeAndNil(OriginalFont);
  end;
end;

procedure TDBMPanel.FlushColumns;
var
ColIndex, MaxItems: integer;
begin
  {Ensure all columns contain the same number of items; Pad those that do not
   with empty items;}

  MaxItems:= 0;

  for ColIndex:= 0 to Columns.Count - 1 do with Columns[ColIndex].Items do
  begin
    if Count > MaxItems then MaxItems:= Count;
  end;

  for ColIndex:= 0 to Columns.Count - 1 do with Columns[ColIndex].Items do
  begin
    while Count < MaxItems do Add('');
  end;
end;
(*
procedure TDBMPanel.ClearSelection;
var
SelectIndex: integer;
begin
  {Empties the fControlSelects and fShiftSelects stringlists; The user will have
   pressed escape or called this public function directly;}

  with fControlSelects do for SelectIndex:= 0 to Count - 1 do Objects[SelectIndex].Free;
  with fShiftSelects do for SelectIndex:= 0 to Count - 1 do Objects[SelectIndex].Free;

  fControlSelects.Clear;
  fShiftSelects.Clear;

  Invalidate;
end;
*)
procedure TDBMPanel.SetSelected(NewSelected: integer);
begin
  {An item may not be selected if there are no columns or items in the columns;}

  if (Columns.Count <= 0) or (Columns[0].Items.Count <= 0) then
  begin
    fSelected:= -1;
    Exit;
  end;

  fSelected:= NewSelected;
end;

procedure TDBMPanel.SetSelHeaderBold(const Value: boolean);
begin
  fSelHeaderBold:= Value;
  Invalidate;
end;

procedure TDBMPanel.SetSelHeaderColour(const Value: TColor);
begin
  fSelHeaderColour:= Value;
  Invalidate;
end;

procedure TDBMPanel.SetSelMultiColour(const Value: TColor);
begin
  fSelMultiColour:= Value;
  Invalidate;
end;

//*** Helper Functions *********************************************************

function TDBMPanel.GetBevelWidth: integer;
begin
  {The BevelWidths must be allowed for throughout the painting process; The width
   to be allowed for is calculated here;}

  Result:= 0;
  if BevelInner <> bvNone then Result:= Result + BevelWidth;
  if BevelOuter <> bvNone then Result:= Result + BevelWidth;
end;

function TDBMPanel.IsColumnClicked(X: integer): TColClickedType;
var
ColIndex, WidthAccrued: integer;
begin
  {fDoubleClickTime ensures that the second click of a double click is processed
   by the double click handler only; The function determines whether a splitter
   or a column was clicked on;}

  if GetTickCount < fDoubleClickTime then
  begin
    Result:= ccNone;
    Exit;
  end
  else begin
    if fColDragIndex > -2 then Result:= ccDrag
    else Result:= ccColumn;
  end;

  WidthAccrued:= SplitterWidth + GetBevelWidth;
  for ColIndex:= 0 to Columns.Count - 1 do with Columns[ColIndex] do
  begin
    if not Visible then Continue;
    
    inc(WidthAccrued, Width);
    if X <= WidthAccrued then Break;

    inc(WidthAccrued, SplitterWidth + 1);
    if X <= WidthAccrued then
    begin
      Result:= ccSplitter;
      Break;
    end;
  end;
end;

function TDBMPanel.IsMovingToFirst: boolean;
var
ColIndex: integer;
begin
  {Determines whether a column-move indicator needs to be drawn on the far left
   of the header;}

  Result:= false;

  ColIndex:= 0;
  while not Columns[ColIndex].Visible do Inc(ColIndex);
  if fColDragIndex = ColIndex - 1 then Result:= true;
end;

function TDBMPanel.GetColumnClicked(X: integer): integer;
var
ColIndex, WidthAccrued: integer;
begin
  {The function returns the column index for the column clicked on; fMinLeft is
   set here, and is used in MouseMove to prevent a column from being resized to
   a width less than zero;}

  Result:= -1;
  if X <= SplitterWidth + GetBevelWidth then Exit;

  WidthAccrued:= SplitterWidth + GetBevelWidth;
  for ColIndex:= 0 to Columns.Count - 1 do with Columns[ColIndex] do
  begin
    if not Visible then Continue;

    inc(WidthAccrued, Width + SplitterWidth + 1);
    if X <= WidthAccrued then
    begin
      fMinLeft:= WidthAccrued - (Width + SplitterWidth);
      Result:= ColIndex;
      Break;
    end;
  end;
end;

function TDBMPanel.GetWidthAccrued(ColCount: integer): integer;
var
WidthAccrued, ColIndex: integer;
begin
  WidthAccrued:= GetBevelWidth + SplitterWidth;
  for ColIndex:= 0 to ColCount - 1 do with Columns[ColIndex] do
  begin
    if Visible then inc(WidthAccrued, Width + SplitterWidth + 1);
  end;
  Result:= WidthAccrued;
end;

function TDBMPanel.GetScreenX(X: integer): integer;
begin
  {Obtains the screen X-coordinate of a point within the scrollbox regardless of
   the horizontal position;}

  Result:= ClientToScreen(Point(X, 0)).X;
end;

function TDBMPanel.ScreenItemsCount: integer;
begin
  {Used by DBMScrollBar for paging up and down;}

//  if Columns.Count <= 0 then Result:= 0 else Result:= GetBottomItem - fTopItem;
  if Columns.Count <= 0 then Result:= 0 else Result:= GetBottomItem - fTopItem + 1;
end;

function TDBMPanel.IsSelected(ListIndex: integer): boolean;
begin
  {A list item is selected if it is the main selection, or it is multi-selected;}

  Result:= false;
  if ListIndex = Selected then Result:= true;
  if isMultiSelected(ListIndex) then Result:= true;
end;

function TDBMPanel.IsMultiSelected(ListIndex: integer): boolean;
var
MultiSelected: boolean;
begin
  {This method surfaces the IsMultiSelected call to TMultilist where TMultiList
   and it descendants can return the result;}

  MultiSelected:= false;
  if Assigned(OnIsMultiSelected) then OnIsMultiSelected(Self, MultiSelected, fShiftSelects, fControlSelects, ListIndex);
  Result:= MultiSelected;
end;

function TDBMPanel.GetBottomItem: integer;
var
TextHt, BottomItem: integer;
begin
  {Calculates the item index of the bottom item in the multi-list given the current
   top item;}

  if Columns.Count <= 0 then
  begin
    Result:= 0;
    Exit;
  end;

  Canvas.Font := TMultilist(Owner.Owner).Font;
  TextHt:= Canvas.TextHeight('Yy');
  BottomItem:= fTopItem + (Height - GetBevelWidth - SplitterWidth - GetHeaderHeight - TextHt - 2) div TextHt;

//  if BottomItem >= Columns[0].Items.Count then Result:= Columns[0].Items.Count - 1 else Result:= BottomItem;
  if BottomItem >= Columns[0].Items.Count
  then begin
{   if Columns[0].Items.Count = 0 then Result:= -1
    else }Result:= Columns[0].Items.Count - 1;
  end else
  begin
    Result:= BottomItem;
  end;{if}
end;

function TDBMPanel.GetMaxRecs: integer;
var
TextHt: integer;
begin
  {Calculates the number of items that can be displayed in a list column; This
   value is used by DBMultiList to determine how many database records need to
   be retrieved;}

  TextHt:= Canvas.TextHeight('Yy');
{  if Font.Height < 0 then TextHt:= ABS(Round(Font.Height * 1.1))
  else TextHt:= Font.Height;}

  Result:= (Height - GetBevelWidth - SplitterWidth - GetHeaderHeight - 2) div TextHt;
end;

function TDBMPanel.GetTriangleOffset(ColIndex: integer): integer;
begin
  {Returns the extra space that must be allowed for by captions when a sorted
   triangle is being drawn;}

  Result:= 0;

  with Columns[ColIndex] do
  begin
    if (Field <> '') and (Width >= 8) and ((Field = fSortedField) or (Sortable)) then Result:= 7;
  end;
end;




//******************************************************************************

//******************************************************************************

//******************************************************************************





//*** TMultiList Property Get/Setting ******************************************

function TMultiList.GetColumns: TDBMColumns;
begin
  Result:= fDBMScrollBox.Columns;
end;

function TMultiList.GetCol: integer;
begin
  Result:= fDBMScrollBox.Col;
end;

function TMultiList.GetSelected: integer;
begin
  Result:= fDBMScrollBox.Selected;
end;

function TMultiList.GetSortedAsc: boolean;
begin
  Result:= fDBMScrollBox.SortedAsc;
end;

Procedure TMultiList.SetSortedAsc(Value : boolean);
begin
  fDBMScrollBox.SortedAsc := Value;
end;

function TMultiList.GetSortedIndex: integer;
var
ColIndex: integer;
begin
  Result:= -1;

  for ColIndex:= 0 to Pred(Columns.Count) do
  begin
    if fDBMScrollBox.SortedField = Columns[ColIndex].Field then Result:= ColIndex;
  end;
end;

procedure TMultiList.SetSelected(const Value: integer);
begin
  if fDBMScrollBox.CanSelect(Value) then fDBMScrollBox.InvalidateSelected(true, Value);
end;

procedure TMultiList.SetBevelHeader(const Value: TBevelCut);
begin
  fDBMScrollBox.BevelHeader:= Value;
end;

procedure TMultiList.SetBevelMainInner(const Value: TBevelCut);
begin
  fDBMScrollBox.BevelMainInner:= Value;
end;

procedure TMultiList.SetBevelMainOuter(const Value: TBevelCut);
begin
  fDBMScrollBox.BevelMainOuter:= Value;
end;

procedure TMultiList.SetBevelWidth(const Value: TBevelWidth);
begin
  fDBMScrollBox.BevelWidth:= Value;
end;

procedure TMultiList.SetCol(const Value: integer);
begin
  fDBMScrollBox.Col:= Value;
end;

procedure TMultiList.SetColour(const Value: TColor);
begin
  fDBMScrollBox.Color:= Value;
end;

procedure TMultiList.SetSearchTimeout(const Value: cardinal);
begin
  fSearchTimeout:= Value;
end;

procedure TMultiList.SetColumns(const Value: TDBMColumns);
begin
  fDBMScrollBox.Columns.Assign(Value);
end;

procedure TMultiList.SetHeaderHeight(const Value: cardinal);
begin
  fDBMScrollBox.HeaderHeight:= Value;
end;

procedure TMultiList.SetMultiSelect(const Value: boolean);
begin
  fDBMScrollBox.MultiSelect:= Value;
end;

procedure TMultiList.SetSortableTriangle(const Value: TColor);
begin
  fDBMScrollBox.SortableTriangle:= Value;
end;

procedure TMultiList.SetSortedTriangle(const Value: TColor);
begin
  fDBMScrollBox.SortedTriangle:= Value;
end;

procedure TMultiList.SetSelBrushCol(const Value: TColor);
begin
  fDBMScrollBox.SelBrushColour:= Value;
end;

procedure TMultiList.SetSelHeaderBold(const Value: boolean);
begin
  fDBMScrollBox.SelHeaderBold:= Value;
end;

procedure TMultiList.SetSelHeaderColour(const Value: TColor);
begin
  fDBMScrollBox.SelHeaderColour:= Value;
end;

procedure TMultiList.SetSelMultiColour(const Value: TColor);
begin
  fDBMScrollBox.SelMultiColour:= Value;
end;
{
procedure TMultiList.SetSelTextCol(const Value: TColor);
begin
  fDBMScrollBox.SelTextColour:= Value;
end;
}
procedure TMultiList.SetScrollSpace(const Value: cardinal);
begin
  {Ensure the width of fSpacer does not exceed that available and that fSpacer
   does not take the rightmost alignment; DBScrollBar must remain rightmost;}

  {$WARNINGS OFF}
//  if Value >= Width - Dimensions.ScrollbarWidth then Exit;
  if Value >= Width - SCROLL_BAR_WIDTH then Exit;

  {$WARNINGS ON}

  with fSpacer do
  begin
    Align:= alNone;
    Left:= 0;
    Width:= Value;
    Align:= alRight;
  end;
end;

procedure TMultiList.SetSpacerColour(const Value: TColor);
begin
  fSpacer.Color:= Value;
end;

procedure TMultiList.SetSplitterColour(const Value: TColor);
begin
  fDBMScrollBox.SplitterColour:= Value;
end;

procedure TMultiList.SetSplitterWidth(const Value: cardinal);
begin
  fDBMScrollBox.SplitterWidth:= Value;
end;

procedure TMultiList.SetBorderInner(const Value: TBorderStyle);
begin
  fDBMScrollBox.BorderInner:= Value;
end;

procedure TMultiList.SetBorderOuter(const Value: TBorderStyle);
begin
  {The window must be recreated to set the BorderStyle;}

  fBorderOuter:= Value;
  RecreateWnd;
end;

function TMultiList.GetFlickerReduction: boolean;
begin
  Result:= fDBMScrollBox.FlickerReduction;
end;

function TMultiList.GetTabStop: boolean;
begin
  Result:= fDBMScrollBox.TabStop;
end;
{
function TMultiList.GetScrollImages: TImageList;
begin
  Result:= fScrollBar.ImageList;
end;

procedure TMultiList.SetBevel(const Value: TBevelCut);
begin
//  fScrollBar.Bevel:= Value;
end;

procedure TMultiList.SetBorderScroll(const Value: TBorderStyle);
begin
  fScrollBar.BorderScroll:= Value;
end;

procedure TMultiList.SetButtonColor(const Value: TColor);
begin
  fScrollBar.ButtonColor:= Value;
end;

procedure TMultiList.SetFixedColor(const Value: TColor);
begin
  fScrollBar.FixedColor:= Value;
end;
}
procedure TMultiList.SetFlickerReduction(const Value: boolean);
begin
  fDBMScrollBox.FlickerReduction:= Value;
end;

procedure TMultiList.SetRepeatDelay(const Value: cardinal);
begin
  fScrollBar.RepeatDelay:= Value;
end;
{
procedure TMultiList.SetWidth(const Value: cardinal);
begin
  fScrollBar.ScrollWidth:= Value;
end;
{
procedure TMultiList.SetScrollImages(const Value: TImageList);
begin
  fScrollBar.ImageList:= Value;
end;
}
procedure TMultiList.SetTabStop(const Value: boolean);
begin
  fDBMScrollBox.TabStop:= Value;
end;

//*** TDBMScrollBox Property Get/Setting ****************************************

function TDBMScrollBox.GetColumns: TDBMColumns;
begin
  Result:= fPanel.fDBMColumns;
end;

function TDBMScrollBox.GetFlickerReduction: boolean;
begin
  Result:= fPanel.DoubleBuffered;
end;

function TDBMScrollBox.GetSortableTriangle: TColor;
begin
  Result:= fPanel.SortableTriangle;
end;

function TDBMScrollBox.GetSortedTriangle: TColor;
begin
  Result:= fPanel.SortedTriangle;
end;

procedure TDBMScrollBox.SetSortableTriangle(const Value: TColor);
begin
  fPanel.SortableTriangle:= Value;
  Invalidate;
end;

procedure TDBMScrollBox.SetSortedTriangle(const Value: TColor);
begin
  fPanel.SortedTriangle:= Value;
  Invalidate;
end;

procedure TDBMScrollBox.SetColumns(const Value: TDBMColumns);
begin
  fPanel.fDBMColumns.Assign(Value);
end;

procedure TDBMScrollBox.SetFlickerReduction(const Value: boolean);
begin
  fPanel.DoubleBuffered:= Value;
end;

function TDBMScrollBox.GetBevelHeader: TBevelCut;
begin
  Result:= fPanel.BevelHeader;
end;

function TDBMScrollBox.GetHeaderHeight: integer;
begin
  Result:= fPanel.HeaderHeight;
end;

function TDBMScrollBox.GetMultiSelect: boolean;
begin
  Result:= fPanel.MultiSelect;
end;

function TDBMScrollBox.GetSplitterColour: TColor;
begin
  Result:= fPanel.SplitterColour;
end;

function TDBMScrollBox.GetSplitterWidth: integer;
begin
  Result:= fPanel.SplitterWidth;
end;

function TDBMScrollBox.GetBevelMainInner: TBevelCut;
begin
  Result:= fPanel.BevelInner;
end;

function TDBMScrollBox.GetBevelMainOuter: TBevelCut;
begin
  Result:= fPanel.BevelOuter;
end;

function TDBMScrollBox.GetBevelWidth: TBevelWidth;
begin
  Result:= fPanel.BevelWidth;
end;

function TDBMScrollBox.GetColour: TColor;
begin
  Result:= fPanel.Color;
end;

function TDBMScrollBox.GetSelBrushCol: TColor;
begin
  Result:= fPanel.SelBrushColour;
end;

function TDBMScrollBox.GetSelHeaderBold: boolean;
begin
  Result:= fPanel.SelHeaderBold;
end;

function TDBMScrollBox.GetSelHeaderColour: TColor;
begin
  Result:= fPanel.SelHeaderColour;
end;

function TDBMScrollBox.GetSelMultiColour: TColor;
begin
  Result:= fPanel.SelMultiColour;
end;

function TDBMScrollBox.GetSelTextCol: TColor;
begin
  Result:= fPanel.SelTextColour;
end;

function TDBMScrollBox.GetSelected: integer;
begin
  Result:= fPanel.Selected;
end;

function TDBMScrollBox.GetSortedAsc: boolean;
begin
  Result:= fPanel.SortedAsc;
end;

function TDBMScrollBox.GetSortedField: string;
begin
  Result:= fPanel.SortedField;
end;

function TDBMScrollBox.GetCol: integer;
begin
  Result:= fPanel.Col;
end;

procedure TDBMScrollBox.SetBevelHeader(const Value: TBevelCut);
begin
  fPanel.BevelHeader:= Value;
end;

procedure TDBMScrollBox.SetHeaderHeight(const Value: integer);
begin
  fPanel.HeaderHeight:= Value;
end;

procedure TDBMScrollBox.SetSplitterColour(const Value: TColor);
begin
  fPanel.SplitterColour:= Value;
end;

procedure TDBMScrollBox.SetSplitterWidth(const Value: integer);
begin
  fPanel.SplitterWidth:= Value;
end;

procedure TDBMScrollBox.SetBevelMainInner(const Value: TBevelCut);
begin
  fPanel.BevelInner:= Value;
end;

procedure TDBMScrollBox.SetBevelMainOuter(const Value: TBevelCut);
begin
  fPanel.BevelOuter:= Value;
end;

procedure TDBMScrollBox.SetBevelWidth(const Value: TBevelWidth);
begin
  fPanel.BevelWidth:= Value;
end;

procedure TDBMScrollBox.SetCol(const Value: integer);
begin
  fPanel.Col:= Value;
end;

procedure TDBMScrollBox.SetColour(const Value: TColor);
begin
  fPanel.Color:= Value;
end;

procedure TDBMScrollBox.SetMultiSelect(const Value: boolean);
begin
  fPanel.MultiSelect:= Value;
end;

procedure TDBMScrollBox.SetSelBrushCol(const Value: TColor);
begin
  fPanel.SelBrushColour:= Value;
end;

procedure TDBMScrollBox.SetSelHeaderBold(const Value: boolean);
begin
  fPanel.SelHeaderBold:= Value;
end;

procedure TDBMScrollBox.SetSelHeaderColour(const Value: TColor);
begin
  fPanel.SelHeaderColour:= Value;
end;

procedure TDBMScrollBox.SetSelMultiColour(const Value: TColor);
begin
  fPanel.SelMultiColour:= Value;
end;

procedure TDBMScrollBox.SetSelTextCol(const Value: TColor);
begin
  fPanel.SelTextColour:= Value;
end;

procedure TDBMScrollBox.SetSelected(const Value: integer);
begin
  fPanel.Selected:= Value;
end;

procedure TDBMScrollBox.SetSortedAsc(const Value: boolean);
begin
  fPanel.SortedAsc:= Value;
end;

procedure TDBMScrollBox.SetSortedField(const Value: string);
begin
  fPanel.SortedField:= Value;
end;

procedure TDBMScrollBox.SetTabStop(const Value: boolean);
begin
  {TabStop is effected by setting the TabStop property on fKeys;}

  fTabStop:= Value;
  fKeys.TabStop:= Value;
end;

procedure TDBMScrollBox.SetBorderInner(const Value: TBorderStyle);
begin
  {The window must be recreated to set the BorderStyle;}

  fBorderInner:= Value;
  RecreateWnd;
end;

//*** TDBMPanel Property Get/Setting *******************************************

procedure TDBMPanel.SetColumns(const Value: TDBMColumns);
begin
  fDBMColumns.Assign(Value);
end;

function TDBMPanel.GetHeaderHeight: integer;
begin
  GetHeaderHeight:= fHeaderHeight + GetBevelWidth;
end;

{DBMPanel display properties require a repaint to update the display;}

procedure TDBMPanel.SetHeaderHeight(NewHeight: integer);
begin
  if NewHeight < 0 then NewHeight:= 0;

  fHeaderHeight:= NewHeight;
  Invalidate;
end;

procedure TDBMPanel.SetBevelHeader(NewBevel: TBevelCut);
begin
  fBevelHeader:= NewBevel;
  Invalidate;
end;

procedure TDBMPanel.SetSplitterWidth(NewWidth: integer);
begin
  if NewWidth < 0 then NewWidth:= 0;

  fSplitterWidth:= NewWidth;
  Invalidate;
end;

procedure TDBMPanel.SetSplitterColour(NewColour: TColor);
begin
  fSplitterColour:= NewColour;
  Invalidate;
end;

//*** Event Redirection ********************************************************

procedure TMultiList.PanelCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  if Assigned(OnCanResize) then OnCanResize(Sender, NewWidth, NewHeight, Resize);
end;

procedure TMultiList.PanelClick(Sender: TObject);
begin
  if Assigned(OnClick) then OnClick(Sender);
end;

procedure TMultiList.PanelColumnClick(Sender: TObject; ColIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(OnColumnClick) then OnColumnClick(Self, ColIndex, Button, Shift, X, Y);
end;

procedure TMultiList.PanelDblClick(Sender: TObject);
begin
  if Assigned(OnDblClick) then OnDblClick(Sender);
end;

procedure TMultiList.PanelDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if Assigned(OnDragDrop) then OnDragDrop(Sender, Source, X, Y);
end;

procedure TMultiList.PanelDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if Assigned(OnDragOver) then OnDragOver(Sender, Source, X, Y, State, Accept);
end;

procedure TMultiList.PanelEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  if Assigned(OnEndDrag) then OnEndDrag(Sender, Target, X, Y);
end;

procedure TMultiList.PanelEnter(Sender: TObject);
begin
  if Assigned(OnEnter) then OnEnter(Sender);
end;

procedure TMultiList.PanelExit(Sender: TObject);
begin
  if Assigned(OnExit) then OnExit(Sender);
end;

procedure TMultiList.PanelHeaderDblClick(ColIndex: integer);
begin
  if Assigned(OnHeaderDblClick) then OnHeaderDblClick(Self, ColIndex);
  if Columns[ColIndex].Sortable then SortColumn(ColIndex, not fDBMScrollBox.SortedAsc);
end;

procedure TMultiList.PanelKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  iTo, iScreenItemsCount, NewCol: integer;
  AShiftSelected : TStringList;
begin
  {Surface the OnKeyDown event; If columns exist, the up or down arrow is pressed,
   and the item can be selected, call InvalidateSelected to change and repaint
   the selected item;}

  // this stops 2 simultaneous key presses command from being executed.
  // occasionally the scroll bar will send it's key down to the list as well as the list capturing it.
  if (GetTickCount - iLastKeyDown < 10)
  and (Key in [VK_RETURN, VK_UP, VK_DOWN, VK_HOME, VK_END, VK_PRIOR, VK_NEXT, VK_RIGHT, VK_LEFT, VK_ESCAPE])
  then exit;
  iLastKeyDown := GetTickCount;

  if Assigned(OnKeyDown) then OnKeyDown(Sender, Key, Shift);
  if Columns.Count <= 0 then Exit;

  with fDBMScrollBox do
  begin
    AShiftSelected := GetShiftSelected;
    case Key of
      VK_RETURN : if Assigned(OnRowDblClick) then OnRowDblClick(Self, Selected);

      VK_UP: begin
        if CanSelect(Selected - 1) then begin
          if MultiSelect and (ssShift in Shift)
          then AddMultiSelect(AShiftSelected, AShiftSelected, Shift, Selected - 1);
          InvalidateSelected(true, Selected - 1);
        end;{if}
      end;

      VK_DOWN: begin
        if CanSelect(Selected + 1) then begin
          if MultiSelect and (ssShift in Shift)
          then AddMultiSelect(AShiftSelected, AShiftSelected, Shift, Selected + 1);
          InvalidateSelected(true, Selected + 1);
        end;{if}
      end;

      VK_HOME : begin
//        if MultiSelect and (ssShift in Shift)
//        then AddMultiSelect(AShiftSelected, AShiftSelected, Shift, 0);
        PanelScrollClick(nil, btTop, mbLeft, [ssLeft], 0,0);
      end;

      VK_END : begin
//        if MultiSelect and (ssShift in Shift)
//        then AddMultiSelect(AShiftSelected, AShiftSelected, Shift, ItemsCount -1);
        PanelScrollClick(nil, btBottom, mbLeft, [ssLeft], 0,0);
      end;

      VK_PRIOR : begin
        iScreenItemsCount := ScreenItemsCount;
        iTo := (Selected - iScreenItemsCount);
        if iTo < 0 then iTo := 0;
        if MultiSelect and (ssShift in Shift)
        then AddMultiSelect(AShiftSelected, AShiftSelected, Shift, iTo);
        PanelScrollClick(nil, btPageUp, mbLeft, [ssLeft], 0,0);
      end;

      VK_NEXT : begin
        iScreenItemsCount := ScreenItemsCount;
        iTo := (Selected + iScreenItemsCount);
        if iTo > (ItemsCount -1) then iTo := ItemsCount - 1;
        if MultiSelect and (ssShift in Shift)
        then AddMultiSelect(AShiftSelected, AShiftSelected, Shift, iTo);
        PanelScrollClick(nil, btPageDown, mbLeft, [ssLeft], 0,0);
      end;

      VK_RIGHT: if Col < Columns.Count - 1 then
      begin
        NewCol:= Succ(Col);
        while not(Columns[NewCol].Visible) and (NewCol < Pred(Columns.Count)) do inc(NewCol);
        if Columns[NewCol].Visible then
        begin
          Col:= NewCol;
          InvalidateHeader;
        end;
      end;

      VK_LEFT: if Col > 0 then
      begin
        NewCol:= Pred(Col);
        while not(Columns[NewCol].Visible) and (NewCol > 0) do dec(NewCol);
        if Columns[NewCol].Visible then
        begin
          Col:= NewCol;
          InvalidateHeader;
        end;
      end;

      VK_ESCAPE: if MultiSelect then MultiSelectClear

      else Key:= 0;

    end;
  end;
end;

procedure TMultiList.PanelKeyPress(Sender: TObject; var Key: Char);

  function IsAlphaNumeric(Key: Char): boolean;
  begin
    {Examines the ASCII code for the given character and returns true if it is alphanumeric;}
    Result:= Ord(Key) in [32, 45, 46, 48..57, 65..90, 97..122];
  end;

begin
  if Assigned(OnKeyPress) then OnKeyPress(Sender, Key);

  if isAlphaNumeric(Key) then
  begin
    if GetTickCount > fClearSearchAt then fSearchStr:= '';
    fClearSearchAt:= GetTickCount + Options.SearchTimeout;
    fSearchStr := fSearchStr + Key;
//    SearchColumn(Col, SortedAsc, fSearchStr);
    SearchColumn(Col, SortedAsc, UpperCase(fSearchStr)); // NF: added uppercase so that first letter find works on files without alt col seq defined. 
  end;{if}
end;

procedure TMultiList.PanelKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Assigned(OnKeyUp) then OnKeyUp(Sender, Key, Shift);
end;

procedure TMultiList.PanelAddSelect(Sender: TObject; var ShiftList: TStringlist; var ControlList: TStringList; Shift: TShiftState; TextIndex: integer);
begin
  AddMultiSelect(ShiftList, ControlList, Shift, TextIndex);
end;

procedure TMultiList.PanelCellPaint(Sender: TObject; ColumnIndex: integer; RowIndex: integer; var Text: string; var TextFont: TFont; var TextBrush: TBrush; var TextAlign: TAlignment);
begin
  if Assigned(OnCellPaint) then OnCellPaint(Sender, ColumnIndex, RowIndex, Text, TextFont, TextBrush, TextAlign);
end;

procedure TMultiList.PanelNavigate(Sender: TObject; var Allow: boolean; NewSelected: integer);
begin
  if Assigned(OnNavigate) then OnNavigate(Sender, Allow, NewSelected);
end;

procedure TMultiList.PanelChangeSelection(Sender: TObject);
begin
  if Assigned(OnChangeSelection) then OnChangeSelection(Sender);
end;

procedure TMultiList.PanelHeaderClick(Sender: TObject; ColIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(OnHeaderClick) then OnHeaderClick(Self, ColIndex, Button, Shift, X, Y);
end;

procedure TMultiList.PanelIsMultiSelected(Sender: TObject; var MSResult: boolean; var ShiftList: TStringList; var ControlList: TStringList; TextIndex: integer);
begin
  IsInSelection(MSResult, ShiftList, ControlList, TextIndex);
end;

procedure TMultiList.PanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {Dragging is enabled here;}

  if Assigned(OnMouseDown) then OnMouseDown(Sender, Button, Shift, X, Y);
  if DragMode = dmAutomatic then BeginDrag(true);
end;

procedure TMultiList.PanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(OnMouseMove) then OnMouseMove(Sender, Shift, X, Y);
end;

procedure TMultiList.PanelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(OnMouseUp) then OnMouseUp(Sender, Button, Shift, X, Y);
end;

procedure TMultiList.PanelMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if Assigned(OnMouseWheel) then OnMouseWheel(Sender, Shift, WheelDelta, MousePos, Handled);
end;

function TMultiList.Navigate(NewSelected: integer): boolean;
var
Allow: boolean;
begin
  Allow:= true;
  if Assigned(OnNavigate) then OnNavigate(Self, Allow, NewSelected);
  Result:= Allow;
end;

procedure TMultiList.PanelResize(Sender: TObject);
begin
  if Assigned(OnResize) then OnResize(Sender);
end;

procedure TMultiList.PanelSplitterClick(Sender: TObject; ColIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(OnSplitterClick) then OnSplitterClick(Self, ColIndex, Button, Shift, X, Y);
end;

procedure TMultiList.PanelStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  if Assigned(OnStartDrag) then OnStartDrag(Sender, DragObject);
end;

procedure TDBMScrollBox.PanelAddSelect(Sender: TObject; var ShiftList: TStringlist; var ControlList: TStringList; Shift: TShiftState; TextIndex: integer);
begin
  if Assigned(OnAddSelect) then OnAddSelect(Sender, ShiftList, ControlList, Shift, TextIndex);
end;

procedure TDBMScrollBox.PanelCellPaint(Sender: TObject; ColumnIndex: integer; RowIndex: integer; var Text: string; var TextFont: TFont; var TextBrush: TBrush; var TextAlign: TAlignment);
begin
  if Assigned(OnCellPaint) then OnCellPaint(Sender, ColumnIndex, RowIndex, Text, TextFont, TextBrush, TextAlign);
end;

procedure TDBMScrollBox.PanelNavigate(Sender: TObject; var Allow: boolean; NewSelected: integer);
begin
  if Assigned(OnNavigate) then OnNavigate(Sender, Allow, NewSelected);
end;

procedure TDBMScrollBox.PanelChangeSelection(Sender: TObject);
begin
  if Assigned(OnChangeSelection) then OnChangeSelection(Sender);
end;

procedure TDBMScrollBox.PanelHeaderClick(Sender: TObject; ColIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(OnHeaderClick) then OnHeaderClick(Self, ColIndex, Button, Shift, X, Y);
end;

procedure TDBMScrollBox.PanelIsMultiSelected(Sender: TObject; var MSResult: boolean; var ShiftList: TStringList; var ControlList: TStringList; TextIndex: integer);
begin
  if Assigned(OnIsMultiSelected) then OnIsMultiSelected(Sender, MSResult, ShiftList, ControlList, TextIndex);
end;

procedure TDBMScrollBox.PanelSplitterClick(Sender: TObject; ColIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(OnSplitterClick) then OnSplitterClick(Self, ColIndex, Button, Shift, X, Y);
end;

procedure TDBMScrollBox.PanelColumnClick(Sender: TObject; ColIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(OnColumnClick) then OnColumnClick(Self, ColIndex, Button, Shift, X, Y);
end;

procedure TDBMScrollBox.PanelClick(Sender: TObject);
begin
  if Assigned(onClick) then onClick(Sender);
end;

procedure TDBMScrollBox.PanelCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  if Assigned(onCanResize) then onCanResize(Sender, NewWidth, NewHeight, Resize);
end;

procedure TDBMScrollBox.PanelDblClick(Sender: TObject);
begin
  if Assigned(onDblClick) then onDblClick(Sender);
end;

procedure TDBMScrollBox.PanelDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if Assigned(onDragDrop) then onDragDrop(Sender, Source, X, Y);
end;

procedure TDBMScrollBox.PanelDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if Assigned(onDragOver) then onDragOver(Sender, Source, X, Y, State, Accept);
end;

procedure TDBMScrollBox.PanelEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  if Assigned(onEndDrag) then onEndDrag(Sender, Target, X, Y);
end;

procedure TDBMScrollBox.PanelEnter(Sender: TObject);
begin
  if Assigned(onEnter) then onEnter(Sender);
end;

procedure TDBMScrollBox.PanelExit(Sender: TObject);
begin
  if Assigned(onExit) then onExit(Sender);
end;

procedure TDBMScrollBox.PanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  fKeys.Left:= X - HorzScrollBar.Position;
  fKeys.SetFocus;
  if Assigned(onMouseDown) then onMouseDown(Sender, Button, Shift, X, Y);
end;

procedure TDBMScrollBox.PanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(onMouseMove) then onMouseMove(Sender, Shift, X, Y);
end;

procedure TDBMScrollBox.PanelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(onMouseUp) then onMouseUp(Sender, Button, Shift, X, Y);
end;

procedure TDBMScrollBox.PanelMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if Assigned(onMouseWheel) then onMouseWheel(Sender, Shift, WheelDelta, MousePos, Handled);
end;

procedure TDBMScrollBox.PanelMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if Assigned(onMouseWheelDown) then onMouseWheelDown(Sender, Shift, MousePos, Handled);
end;

procedure TDBMScrollBox.PanelMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if Assigned(onMouseWheelUp) then onMouseWheelUp(Sender, Shift, MousePos, Handled);
end;

procedure TDBMScrollBox.PanelResize(Sender: TObject);
begin
  if Assigned(onResize) then onResize(Sender);
end;

procedure TDBMScrollBox.PanelStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  if Assigned(onStartDrag) then onStartDrag(Sender, DragObject);
end;

//*** Helper Classes ***********************************************************

//*** TMLBevels ****************************************************************

constructor TMLBevels.Create(AOwner: TMultilist);
begin
  inherited Create;

  fMultilist:= AOwner;
  fFrame:= bvRaised;
  fInner:= bvNone;
  fOuter:= bvNone;
//  fScrollbar:= bvNone;
  fWidth:= 1;
end;

procedure TMLBevels.SetFrame(Value: TBevelCut);
begin
  fFrame:= Value;
  if Assigned(UpdateFrame) then UpdateFrame(Frame);
end;

procedure TMLBevels.SetInner(Value: TBevelCut);
begin
  fInner:= Value;
  if Assigned(UpdateInner) then UpdateInner(Inner);
end;

procedure TMLBevels.SetOuter(Value: TBevelCut);
begin
  fOuter:= Value;
  if Assigned(UpdateOuter) then UpdateOuter(Outer);
end;

{procedure TMLBevels.SetScrollbar(Value: TBevelCut);
begin
//  fScrollbar:= Value;
//  if Assigned(UpdateScrollbar) then UpdateScrollbar(Scrollbar);
end;}

procedure TMLBevels.SetWidth(Value: cardinal);
begin
  fWidth:= Value;
  if Assigned(UpdateWidth) then UpdateWidth(Width);
end;

//*** TMLBorders ***************************************************************

constructor TMLBorders.Create(AOwner: TMultilist);
begin
  inherited Create;

  fMultilist:= AOwner;
  fInner:= bsSingle;
  fOuter:= bsNone;
//  fScrollbar:= bsSingle;
end;

procedure TMLBorders.SetInner(Value: TBorderStyle);
begin
  fInner:= Value;
  if Assigned(UpdateInner) then UpdateInner(Inner);
end;

procedure TMLBorders.SetOuter(Value: TBorderStyle);
begin
  fOuter:= Value;
  if Assigned(UpdateOuter) then UpdateOuter(Outer);
end;

{procedure TMLBorders.SetScrollbar(Value: TBorderStyle);
begin
//  fScrollbar:= Value;
//  if Assigned(UpdateScrollbar) then UpdateScrollbar(Scrollbar);
end;}

//*** TMLColours ***************************************************************

constructor TMLColours.Create(AOwner: TMultilist);
begin
  inherited Create;

  fMultilist:= AOwner;
  fButtons:= clBtnFace;
  fFrame:= clBtnFace;
  fActiveColumn:= clWindowText;
//  fCellText:= clWindowText;
  fMultiSelection:= clHighlight;
//  fScrollbar:= LightenColor(clBtnFace,40);
  fSelection:= clHighLight;
//  fSelectionText:= clHighlightText;
  fSortableTriangle:= clGrayText;
  fSortedTriangle:= clWindowText;
  fSpacer:= clBtnFace;
  fSplitter:= clBtnFace;
end;
{
procedure TMLColours.SetButtons(Value: TColor);
begin
  fButtons:= Value;
  if Assigned(UpdateButtons) then UpdateButtons(Value);
end;
}
procedure TMLColours.SetFrame(Value: TColor);
begin
  fFrame:= Value;
  if Assigned(UpdateFrame) then UpdateFrame(Value);
end;

procedure TMLColours.SetActiveColumn(Value: TColor);
begin
  fActiveColumn:= Value;
  if Assigned(UpdateActiveColumn) then UpdateActiveColumn(Value);
end;

procedure TMLColours.SetMultiSelection(Value: TColor);
begin
  fMultiSelection:= Value;
  if Assigned(UpdateMultiSelection) then UpdateMultiSelection(Value);
end;
{
procedure TMLColours.SetScrollbar(Value: TColor);
begin
  fScrollBar:= Value;
  if Assigned(UpdateScrollbar) then UpdateScrollbar(Value);
end;
}
procedure TMLColours.SetSelection(Value: TColor);
begin
  fSelection:= Value;
  if Assigned(UpdateSelection) then UpdateSelection(Value);
end;
{
procedure TMLColours.SetSelectionText(Value: TColor);
begin
  fSelectionText:= Value;
  if Assigned(UpdateSelectionText) then UpdateSelectionText(Value);
end;
}
procedure TMLColours.SetSortableTriangle(Value: TColor);
begin
  fSortableTriangle:= Value;
  if Assigned(UpdateSortableTriangle) then UpdateSortableTriangle(Value);
end;

procedure TMLColours.SetSortedTriangle(Value: TColor);
begin
  fSortedTriangle:= Value;
  if Assigned(UpdateSortedTriangle) then UpdateSortedTriangle(Value);
end;

procedure TMLColours.SetSpacer(Value: TColor);
begin
  fSpacer:= Value;
  if Assigned(UpdateSpacer) then UpdateSpacer(Value);
end;

procedure TMLColours.SetSplitter(Value: TColor);
begin
  fSplitter:= Value;
  if Assigned(UpdateSplitter) then UpdateSplitter(Value);
end;

//*** TMLDimensions ************************************************************

constructor TMLDimensions.Create(AOwner: TMultilist);
begin
  inherited Create;

  fMultilist:= AOwner;
  fHeaderHeight:= 18;
//  fScrollbarWidth:= 21;
  fSpacerWidth:= 1;
  fSplitterWidth:= 3;
end;

procedure TMLDimensions.SetHeaderHeight(Value: cardinal);
begin
  fHeaderHeight:= Value;
  if Assigned(UpdateHeaderHeight) then UpdateHeaderHeight(Value);
end;
{
procedure TMLDimensions.SetScrollbarWidth(Value: cardinal);
begin
  fScrollbarWidth:= Value;
  if Assigned(UpdateScrollbarWidth) then UpdateScrollbarWidth(Value);
end;
}
procedure TMLDimensions.SetSpacerWidth(Value: cardinal);
begin
  fSpacerWidth:= Value;
  if Assigned(UpdateSpacerWidth) then UpdateSpacerWidth(Value);
end;

procedure TMLDimensions.SetSplitterWidth(Value: cardinal);
begin
  fSplitterWidth:= Value;
  if Assigned(UpdateSplitterWidth) then UpdateSplitterWidth(Value);
end;

//*** TMLOptions ***************************************************************

constructor TMLOptions.Create(AOwner: TMultilist);
begin
  inherited Create;

  fMultilist:= AOwner;
  fBoldActiveColumn:= false;
  fMultiSelection:= false;
  fRepeatDelay:= 200;
  fSearchTimeout:= 1000;
end;

procedure TMLOptions.SetBoldActiveColumn(Value: boolean);
begin
  fBoldActiveColumn:= Value;
  if Assigned(UpdateBoldActiveColumn) then UpdateBoldActiveColumn(Value);
end;

procedure TMLOptions.SetMultiSelection(Value: boolean);
begin
  fMultiSelection:= Value;
  if Assigned(UpdateMultiSelection) then UpdateMultiSelection(Value);
end;

procedure TMLOptions.SetRepeatDelay(Value: cardinal);
begin
  fRepeatDelay:= Value;
  if Assigned(UpdateRepeatDelay) then UpdateRepeatDelay(Value);
end;

procedure TMLOptions.SetSearchTimeout(Value: cardinal);
begin
  fSearchTimeout:= Value;
  if Assigned(UpdateSearchTimeout) then UpdateSearchTimeout(Value);
end;

// *****************************************************************************

procedure TMultiList.SetBevels(Value: TMLBevels);
begin
  with fBevels do
  begin
    Frame:= Value.Frame;
    Inner:= Value.Inner;
    Outer:= Value.Outer;
//    Scrollbar:= Value.Scrollbar;
    Width:= Value.Width;
  end;
end;

procedure TMultiList.SetBorders(Value: TMLBorders);
begin
  with fBorders do
  begin
    Inner:= Value.Inner;
    Outer:= Value.Outer;
//    Scrollbar:= Value.Scrollbar;
  end;
end;

procedure TMultiList.SetColours(Value: TMLColours);
begin
  with fColours do
  begin
//    fButtons:= Value.Buttons;
    fFrame:= Value.Frame;
    fActiveColumn:= Value.ActiveColumn;
    fMultiSelection:= Value.MultiSelection;
//    fScrollbar:= Value.Scrollbar;
    fSelection:= Value.Selection;
//    fSelectionText:= Value.SelectionText;
    fSortableTriangle:= Value.SortableTriangle;
    fSortedTriangle:= Value.SortedTriangle;
    fSpacer:= Value.Spacer;
    fSplitter:= Value.Splitter;
  end;
end;

procedure TMultiList.SetCustom(Value: TMLCustom);
begin
  with fCustom do
  begin
    fListName:= Value.ListName;
    fSettingsIni:= Value.SettingsIni;
    fUserName:= Value.UserName;
  end;
end;

procedure TMultiList.SetDimensions(Value: TMLDimensions);
begin
  with fDimensions do
  begin
    fHeaderHeight:= Value.HeaderHeight;
//    fScrollbarWidth:= Value.ScrollbarWidth;
    fSpacerWidth:= Value.SpacerWidth;
    fSplitterWidth:= Value.SplitterWidth;
  end;
end;

procedure TMultiList.SetOptions(Value: TMLOptions);
begin
  with fOptions do
  begin
    fBoldActiveColumn:= Value.BoldActiveColumn;
    fMultiSelection:= Value.MultiSelection;
    fRepeatDelay:= Value.RepeatDelay;
    fSearchTimeout:= Value.SearchTimeout;
  end;
end;

procedure TMultiList.SortColumn(ColIndex: integer; SortAsc: boolean);
//(Col: integer; bAscending: boolean);
var
  iPos2, iCol, iPos : integer;
  slSort : TStringList;
  RowInfo : TRowInfo;
begin
  Col := ColIndex; //NF: 13/04/06 - Fix for Barry. First Letter find was not working after programatically sorting columns

  // store all the current cells and their objects in a temp string list
  slSort := TStringList.Create;
  for iPos := 0 to Columns[ColIndex].Items.count - 1 do begin
    RowInfo := TRowInfo.Create;
    setLength(RowInfo.aCols, Columns.Count);
    for iCol := 0 to Columns.Count - 1 do begin
      RowInfo.aCols[iCol].sText := Columns[iCol].Items[iPos];
      RowInfo.aCols[iCol].oObject := Columns[iCol].Items.Objects[iPos];
    end;{for}
    slSort.AddObject(Columns[ColIndex].Items[iPos], RowInfo);
  end;{for}

  // CJS: 26/01/2010 - added support for custom sorting.
  if Assigned(Columns[ColIndex].CustomSortHandler) then
    slSort.CustomSort(Columns[ColIndex].CustomSortHandler)
  else
    // Sort temp string list using standard sort
    slSort.Sort;

  // Write sorted values back to the screen list
  if SortAsc then iPos := 0
  else iPos := slSort.count - 1;
  iPos2 := 0;
  while (iPos >= 0) and (iPos <= slSort.count - 1) do begin
    for iCol := 0 to Columns.Count - 1 do begin
      Columns[iCol].Items[iPos] := TRowInfo(slSort.Objects[iPos2]).aCols[iCol].sText;
      Columns[iCol].Items.Objects[iPos] := TRowInfo(slSort.Objects[iPos2]).aCols[iCol].oObject;
    end;{for}

    if SortAsc then Inc(iPos)
    else Dec(iPos);
    inc(iPos2);
  end;{while}

  // Clear temporary StringList
  for iPos := 0 to slSort.count - 1 do begin
    SetLength(TRowInfo(slSort.Objects[iPos]).aCols,0);
    slSort.Objects[iPos].Free;
  end;{for}
  slSort.Clear;

  fDBMScrollBox.SortedAsc := SortAsc;
  fDBMScrollBox.SortedField := Columns[ColIndex].Field;

  // Refresh screen
  Refresh;
end;

procedure TMultiList.DeleteRow(Row : integer);
var
  iPos : integer;
begin
  if Row >= ItemsCount then exit;
  for iPos := 0 to Columns.Count -1 do begin
    Columns[iPos].Items.Delete(Row);
  end;{for}
end;

procedure TMultiList.MoveRow(FromRow, ToRow : integer);
var
  iPos : integer;
begin
  if (FromRow >= ItemsCount) then exit;
  if (ToRow >= ItemsCount) then exit;

  for iPos := 0 to Columns.Count -1 do begin
    Columns[iPos].Items.Move(FromRow, ToRow);
  end;{for}
end;

procedure TMultiList.SearchColumn(ColIndex: integer; bAsc: boolean; SearchStr: string);
var
  iNextBestPos, iPos : integer;
  bFound : boolean;
begin
  bFound := FALSE;
  iNextBestPos := 0;
  for iPos := 0 to ItemsCount - 1 do begin
    if uppercase(Copy(Columns[ColIndex].Items[iPos],1,Length(SearchStr)))
    = UpperCase(SearchStr) then
      begin
        Selected := iPos;
        bFound := TRUE;
        Break;
      end
    else begin
      if (length(SearchStr) > 0) and (length(Columns[ColIndex].Items[iPos][1]) > 0) then begin
        if Ord(UpperCase(Columns[ColIndex].Items[iPos])[1]) <= Ord(UpperCase(SearchStr)[1])
        then iNextBestPos := iPos;
      end;{if}
    end;{if}
  end;{for}

  if not bFound then Selected := iNextBestPos;

//  fSearchStr := SearchStr;
end;

procedure TDBMScrollBox.Invalidate;
begin
//  inherited;
end;

procedure TDBMPanel.MouseWheelHandler(var Message: TMessage);
begin
  inherited;
//  showmessage('mousewheel');
end;

procedure TMultiList.ScrollButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  PanelKeyDown(Sender, Key, Shift);
end;

procedure TMultiList.ScrollButtonKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  PanelKeyUp(Sender, Key, Shift);
end;

procedure TMultiList.ScrollButtonKeyPress(Sender: TObject; var Key: Char);
begin
  PanelKeyPress(Sender, Key);
end;

procedure TMultiList.ForceXPButtons;
begin
  fScrollBar.ForceXP;
end;

procedure TMultiList.MultiSelect(sItem: string; TextIndex: integer; bForceOn : boolean = FALSE);
var
  AShiftList, AControlList : TStringlist;
//  iPos : integer;
begin
//  for TextIndex:= fTopItem to GetBottomItem do
  AControlList := fDBMScrollBox.GetControlSelected;
  AShiftList := fDBMScrollBox.GetShiftSelected;
  AddMultiSelect(AShiftList, AControlList, [ssCtrl], TextIndex, bForceOn);
//  For iPos := 0 to AControlList.count - 1 do AControlList.Objects[iPos].Free;
//  AControlList.Clear;
//  AControlList.Free;
end;

procedure TMultiList.MultiSelectAll;
//var
//  AShiftList, AControlList : TStringlist;
//  iPos : integer;
//  bFound : boolean;
(*  iLastRecPos, iRecPos : integer;

  function AlreadySelected : boolean;
  var
    ControlIndex : integer;
    ControlSelection: TControlSelectType;
  begin{AlreadySelected}
    Result := FALSE;
    ControlSelection := GetControlSelected;
    for ControlIndex := low(ControlSelection) to high(ControlSelection) do
    begin
      if iRecPos = ControlSelection[ControlIndex] then begin
        Result := TRUE;
        exit;
      end;{if}
    end;{for}
  end;{AlreadySelected}
*)
var
  iPos : integer;
begin{MultiSelectAll}

  For iPos := 0 to High(fMultiSelected) do begin
    fMultiSelected[iPos] := TRUE;
  end;{for}
  RefreshList;

(*  if ScreenItemsCount < 0 then exit;

  // fakes a select all !
  PanelScrollClick(nil, btTop, mbLeft, [ssLeft], 0, 0);
  iRecPos := -1;
  Repeat
    iLastRecPos := iRecPos;
    iRecPos := GetSelectVar(Selected, [], FALSE);
    if not AlreadySelected then MultiSelect(DesignColumns[0].Items[Selected], Selected, TRUE);
    PanelScrollClick(nil, btOneDown, mbLeft, [ssLeft], 0, 0);
  until iLastRecPos = iRecPos;*)
end;

procedure TMultiList.RefreshList;
begin
  if Assigned(fDBMScrollBox) then fDBMScrollBox.fPanel.Paint;
  if Assigned(OnRefreshList) then OnRefreshList(self);
end;

function TMultiList.GetMultiSelected: TSelectedArray;
begin
  Result := fMultiSelected;
end;

procedure TMultiList.SetMultiSelectedSize;
var
  bChanged : boolean;
  iPos : integer;
begin
  // only do if multiselect is being used
  if Options.MultiSelection then begin

    // has a new item been added ?
    bChanged := ItemsCount <> High(fMultiSelected) + 1;

    // set the size of the array to the no of items in the list
    if ItemsCount > 0 then SetLength(fMultiSelected,ItemsCount);

    // it an item has been added, then default multiselected to FALSE for that item.
    if bChanged then begin
      For iPos := 0 to High(fMultiSelected) do begin
        fMultiSelected[iPos] := FALSE;
      end;{for}
    end;{if}

  end;{if}
end;

procedure TMultiList.MultiSelectClear;
var
  iPos : integer;
begin{MultiSelectClear}
  For iPos := 0 to High(fMultiSelected) do begin
    fMultiSelected[iPos] := FALSE;
  end;{for}
  RefreshList;
end;

function TMultiList.GetVersionNo: string;
begin
  Result := 'v1.13';
end;

procedure TMultiList.SetVersionNo(const Value: string);
begin
  // do nothing
end;

function TMultiList.FindColumnNoFromField(sField: string): integer;
var
  iPos : integer;
begin
  Result := -1;
  For iPos := 0 to Columns.Count -1 do begin
    if Columns[iPos].Field = sField then
    begin
      Result := iPos;
      Break;
    end;{if}
  end;{for}
end;

procedure TMultiList.ForceRepaint;
begin
  {Allow users to refresh the control;}
  if Assigned(fDBMScrollBox) then fDBMScrollBox.Invalidate;
  if Assigned(fDBMScrollBox) then fDBMScrollBox.fPanel.Paint;
end;

procedure TMultiList.DoEnter;
begin
  //PR: 29/04/2010 Set focus to fKeys edit on scrollbox - this will allow keyboard events
  //to be received correctly.
  fDBMScrollBox.FocusCapture.SetFocus;
  inherited;
end;

end.
