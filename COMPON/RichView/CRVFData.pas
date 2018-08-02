
{*******************************************************}
{                                                       }
{       RichView                                        }
{       TCustomRVFormattedData is a basic class         }
{       representing RichView document with             }
{       formatting.                                     }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit CRVFData;

interface
{$I RV_Defs.inc}
uses {$IFDEF RICHVIEWDEF2009}AnsiStrings,{$ENDIF}
     SysUtils, Windows, Messages, Classes, Graphics, Controls, Clipbrd,
     Forms,
     RVFuncs, RVStyle, RVItem, CRVData, DLines, RVScroll, RVBack, RVUni,
    {$IFNDEF RVDONOTUSEDRAGDROP}
     ActiveX, RVDragDrop,
    {$ENDIF}
     RVClasses, RVTypes, RVGrIn;

{$IFDEF RVNORANGECHECK}
{$R-}
{$ENDIF}

const MINEXACTLINESPACING = 4;

type
  TRVDrawItemPosition = (rvdpStrict, rvdpBetterAbove, rvdpBetterBelow);

  TCustomRVFormattedData = class;
{-----------------------------------------------------------------------}
  TRVJumpInfo = class
    public
     RVData: TCustomRVFormattedData;
     l,t,w,h: Integer;
     id, DrawItemNo: Integer;
     Cursor: TCursor;
  end;

  TRVSoftPageBreakInfo = class
  public
    ItemNo, Offset, ExtraData: Integer;
  end;

  TRVSoftPageBreakList = class (TRVList)
  public
    //function FindItem(ItemNo: Integer): Integer;
  end;

  TRVDataDrawHyperlinkEvent = procedure (RVData: TCustomRVData;
    ItemNo: Integer; R: TRect) of object;

  TRVRepaintOperation = (rvrrInvalidate, rvrrUpdate);
  TRVRepaintEvent = procedure (Sender: TControl;
    Operation: TRVRepaintOperation; Rect: PRect) of object;



  TRVSelectingState = (rvsesInWord, rvsesOutsideWord, rvsesFreeMode,
                       rvsesParaMode);
  { TRVSelectingInfo: information about the selection process (with mouse).
    For internal use (used as FSelectingInfo field of TCustomRVFormattedData.
    This field is allocated while user is making selection.
    Contains two set of fields: for starting and for ending parts of selection
    (bounds of word containing selection end, actual selection position).      }
  TRVSelectingInfo = class
    public
      DrawItemSOffs, DrawItemEOffs, DrawItemSWordOffs1, DrawItemSWordOffs2,
      DrawItemEWordOffs1, DrawItemEWordOffs2: Integer;
      DrawItemSNo, DrawItemENo: Integer;
      SWordState, EWordState: TRVSelectingState;
      procedure InitE(ASWordState: TRVSelectingState);
      function IsAboveSWord(ADrawItemNo, ADrawItemOffs: Integer): Boolean;
      function IsBelowSWord(ADrawItemNo, ADrawItemOffs: Integer): Boolean;
      function IsInSWord(ADrawItemNo, ADrawItemOffs: Integer): Boolean;
      function AreWordsEqual: Boolean;
      function IsEWord(ADrawItemNo,
        ADrawItemWordOffs1, ADrawItemWordOffs2: Integer): Boolean;
      function IsEFreeStateNeeded(ADrawItemNo, ADrawItemOffs: Integer): Boolean;
  end;
  {--------------------------------------------------------------------------- }
  {$IFNDEF RVDONOTUSEDRAGDROP}
  { TCustomRVFormattedData: information about drag&drop caret location.
    See: TCustomRVFormattedData.GetDragDropCaretInfo                           }
  TRVDragDropCaretInfo = class
    public
      X,Y,                       // coordinates relative to RVData top-left
      Height,                    // caret height
      ItemNo, ItemOffs: Integer; // item index and offset in item, in RVData
      RVData: TCustomRVData;     // RVData containing d&d caret
      RefCount: Integer;
  end;
  {$ENDIF}

  TRVFontInfoCacheItem = class
  public
    LastBiDiMode: TRVBiDiMode;
    Canvas: TCanvas;
    TextMetric: TTextMetric;
    ExtraFontInfo: TRVExtraFontInfo;
    FontInfo: TFontInfo;
    VerticalOffset: Integer;
    EmptyLineHeight: Integer;
    HyphenWidth: Integer;
  end;
  PRVFontInfoCacheItem = ^TRVFontInfoCacheItem;

  TRVFontInfoCache = class (TRVList)
  protected
    FCanvas, FDrawCanvas: TCanvas;
    FRVStyle: TRVStyle;
    FCanUseCustomPPI: Boolean;
    FOwner: TObject;
    FInvalidItem: TRVFontInfoCacheItem;
    function GetItems(Index: Integer): TRVFontInfoCacheItem; virtual; abstract;
  public
    CurParaBiDiMode: TRVBiDiMode;
    IgnoreParaBiDiMode: Boolean;
    LastTextStyle: Integer;
    constructor Create(const AData: TCustomRVFormattedData;
      const ARVStyle: TRVStyle; const ACanvas, ADrawCanvas: TCanvas;
      ACanUseCustomPPI: Boolean); virtual;
    procedure Clear; {$IFDEF RICHVIEWDEF4}override;{$ENDIF}
    property Items[Index: Integer]: TRVFontInfoCacheItem read GetItems; default;
    property Owner: TObject read FOwner;
  end;

  TRVFormatParams = record
    x, baseline, prevdesc, prevabove:Integer;
    IsParaSectionStart: Boolean;
    LineWidth, LineStartX, LineStartY, LastDrawItem, VerticalOffs: Integer;
    LeftIndent, RightIndent, FirstIndent,
    LastTextStyle, UnadjustedLeftIndent, UnadjustedRightSide,
    FirstParaItemNo: Integer;
    LineHeightAbove, LineHeightBelow: Integer;
    TextLength, MaxLength: Integer;
    NoCaching, Reformatting: Boolean;
    DontFSL, NeedRecalcY, LineHasFloating: Boolean;
    LastTabDrawItemNo: Integer;
    LastTabAlign: TRVTabAlign;
    LastTabPosition: Integer;
    SpaceEaten: Boolean;
    FontInfoCache: TRVFontInfoCache;
    FormatCanvas: TCanvas;
    TextMetric: TTextMetric;
    AllowWordWrap: Boolean;
    FloatingDrawItems: TRVFloatingDrawItems;
    FloatingDrawItemsInThisParaSection: TList;
    CanBeFloatingAtTheBeginning, MovedDownBecauseOfFloating: Boolean;
    UseFormatCanvas: Boolean;
  end;
  {--------------------------------------------------------------------------- }
  { TCustomRVFormattedData: RichView document with formatting.                 }
  TCustomRVFormattedData = class (TCustomRVData)
    private
      LastRaisedCP: TRVCPInfo;
      FXORDrawing: TMouseMoveEvent;
      FCaptureMouseItem: TCustomRVItemInfo;
      FSelectingInfo: TRVSelectingInfo;
      //FZoomPercent: Integer;
      //LastSelectionRect: TRect;
      function FindDrawItemAtPos(X, Y: Integer): Integer;
      procedure CopyTextA_;
      procedure CopyTextW_;
      procedure CopyImage_;
      {$IFNDEF RVDONOTUSERVF}
      procedure CopyRVF_(Color: TColor; Background: TRVBackground);
      {$ENDIF}
      {$IFNDEF RVDONOTUSERTF}
      procedure CopyRTF_(Color: TColor; Background: TRVBackground);
      {$ENDIF}
      procedure StartFormatting;
      procedure EndFormatting;
      procedure SearchHotItem(X, Y, HOffs, VOffs: Integer);
      procedure AdjustSelection;
      //procedure SetZoomPercent(const Value: Integer);
    protected
      { Protected declarations }
      XorImageDrawn: Boolean;
      MouseX, MouseY: Integer;
      Jumps: TList;
      nJmps: Integer;
      LastItemFormatted: Integer;
      LastJumpMovedAbove, LastDIMovedAbove: Integer;
      LastRVDataMovedAbove: TCustomRVFormattedData;
      LastJumpDowned: Integer;
      FPartialSelectedItem: TCustomRVItemInfo;
      AlreadyFormatted: Boolean;
      FSoftPageBreaks: TRVSoftPageBreakList;
      FClickedDrawItemNo: Integer;
      FOnRepaint: TRVRepaintEvent;
      { Soft page breaks }
      function GetSoftPageBreaks: TRVSoftPageBreakList; virtual;
      { Inplace }
      function GetInplaceEditor: TControl; dynamic;
      procedure DestroyInplaceEditor; dynamic;
      { Clearing }
      procedure ClearLastJump;
      { Item info: hidden text support }
      function GetItemParaEx(ItemNo: Integer): Integer;
      function IsParaStartEx(ItemNo: Integer): Boolean;
      function IsFromNewLineEx(ItemNo: Integer): Boolean;
      function IsLastParaSectionItemEx(ItemNo: Integer): Boolean;
      function IsLastParaItemEx(ItemNo: Integer): Boolean;
      function GetFirstParaItemEx(ItemNo: Integer): Integer;
      function GetFirstParaSectionItemEx(ItemNo: Integer): Integer;
      function GetFirstNonHiddenItemNo: Integer;
      function GetLastNonHiddenItemNo: Integer;
      procedure ExpandToParaEx(ItemNo1,ItemNo2: Integer;
        var FirstItemNo, LastItemNo: Integer);
      procedure ExpandToParaSectionEx(ItemNo1,ItemNo2: Integer;
        var FirstItemNo, LastItemNo: Integer);
      function GetPrevNonHiddenItemNo(ItemNo: Integer): Integer;
      function GetNextNonHiddenItemNo(ItemNo: Integer): Integer;
      { Drawing item info }
      function IsDrawItemParaStart(DrawItemNo: Integer): Boolean;
      function IsDrawItemItemStart(DrawItemNo: Integer): Boolean;
      function IsDrawItemParaSectionStart(DrawItemNo: Integer): Boolean;
      function IsDrawItemParaEnd(DrawItemNo: Integer): Boolean;
      function IsDrawItemFromNewLine(DrawItemNo: Integer): Boolean;
      function IsDrawItemLastOnWrappedLine(DrawItemNo: Integer): Boolean;
      function GetDrawItemStyle(DrawItemNo: Integer): Integer;
      function IsSpaceBetweenDrawItems(DrawItemNo: Integer): Boolean;
      { Drawing }
      procedure PostPaintTo(Canvas: TCanvas;
        HOffs, VOffs, FirstDrawItemNo, LastDrawItemNo: Integer;
        PrintMode, StrictTop, StrictBottom: Boolean); virtual;
      { Selecting }
      procedure FindDrawItemForSel(X, Y: Integer; var No, Offs: Integer; Strict,
        IgnoreFloating: Boolean);
      function FindFloatingAt(DItemNo, X, Y: Integer): Integer;
      function AdjustSelectionByMode(X,Y: Integer): Boolean;
      function AdjustLineSelection(X,Y: Integer): Boolean;
      procedure ExpandSelectionToLines(OneLine: Boolean);
      procedure DeselectPartiallySelectedItem(NewPartiallySelected: TCustomRVItemInfo); dynamic;
      procedure SetPartialSelectedItem(Item: TCustomRVItemInfo); virtual;
      { Selection info }
      function IsSelectionTopDown: Boolean;
      function DItem_InsideSelection(DItemNo, DItemOffs: Integer;
        IncludeBorders: Boolean): Boolean;
      function GetClientSelectionRect: TRect;
      {$IFNDEF RVDONOTUSEDRAGDROP}
      { Drag & drop: drop to }
      procedure DrawDragDropCaret(Canvas: TCanvas; OnlyForSelf: Boolean);
      { Drag & drop: drop from }
      function CanStartDragging: Boolean; dynamic;
      function InitDragging(var DropSource: TRVDropSource; var OKEffect: Integer): Boolean; dynamic;
      procedure DoneDragging(FDeleteSelection: Boolean); dynamic;
      procedure SetClickCoords(X, Y: Integer); dynamic;
      function CanStartDragBecauseMouseMoved(X, Y: Integer): Boolean; dynamic;
      {$ENDIF}
      { Formatting }
      procedure FinishScreenLine(const sad: TRVScreenAndDevice;
        IsParaSectionFinished: Boolean; var ExtraSpace: Integer; var Params: TRVFormatParams);
      procedure UpdateLastTab(var Params: TRVFormatParams);
      procedure FormatAddFloating(var Params: TRVFormatParams; const sad: TRVScreenAndDevice;
        DrawItemNo: Integer; var Y: Integer);
      procedure FormatLine(const Text, OrigText: TRVRawByteString;
        Len, ItemNo: Integer; Canvas: TCanvas; var sad: TRVScreenAndDevice;
        var Params: TRVFormatParams);
      procedure GetSADForFormatting(Canvas: TCanvas; var sad: TRVScreenAndDevice);  virtual;
      procedure Formatted(FirstItemNo, LastItemNo: Integer; Partial: Boolean); dynamic;
      procedure DoAfterFormat; dynamic;
      procedure GetWrapPlaceAfterItem(var ItemNo, Offs: Integer);
      { Misc. }
      function IsHidden(ItemNo: Integer): Boolean;
      function IsHiddenItem(Item: TCustomRVItemInfo): Boolean;
      function IsParaSectionHidden(FirstItemNo: Integer): Boolean;
      function CanShowSpecialCharacters: Boolean;
      procedure ConcateItems(FirstItemNo: Integer);
      function InsideWord(DrawItemNo, DrawItemOffs: Integer): Boolean;
      procedure GetWordBounds(DrawItemNo, DrawItemOffs: Integer;
        var DrawItemWordOffs1, DrawItemWordOffs2: Integer);
      procedure GetScreenLineBounds(DrawItemNo: Integer; var First, Last: Integer);
      procedure AfterDeleteStyles(Data: TRVDeleteUnusedStylesData); override;
      procedure InternalFreeItem(item: TCustomRVItemInfo; Clearing: Boolean); override;
      function GetFirstItemMarker(var ListNo, Level: Integer): Boolean; virtual;
      procedure GetIndents(ItemNo: Integer; IsParaSectionStart: Boolean;
        var FirstParaItemNo: Integer; var LeftIndent, RightIndent,
        FirstIndent: Integer {TRVStyleLength});
      function GetRVDataExtraVOffs: Integer; virtual;
      {$IFNDEF RVDONOTUSELISTS}
      function GetListLevelForItem(ItemNo: Integer): TRVListLevel;
      {$ENDIF}
      function GetMaxIndent(ItemNo: Integer; var FirstParaItemNo: Integer;
        sad: PRVScreenAndDevice): Integer;
      procedure RVFGetLimits(SaveScope: TRVFSaveScope;
        var StartItem, EndItem, StartOffs, EndOffs: Integer;
        var StartPart, EndPart: TRVMultiDrawItemPart;
        var SelectedItem: TCustomRVItemInfo); override;
      procedure GetMouseClientCoords(Control: TWinControl; var X, Y: Integer); dynamic;
      { Live spelling }
      {$IFNDEF RVDONOTUSELIVESPELL}
      procedure LiveSpellingCheckCurrentItem; dynamic;
      {$ENDIF}
    public
      FActiveItem: TCustomRVItemInfo;
      DocumentWidth: Integer;
      DocumentHeight, TextWidth,FocusedItemNo: Integer;
      DrawItems: TRVDrawLines;
      FSelStartNo, FSelEndNo, FSelStartOffs, FSelEndOffs: Integer;
      procedure CreateFontInfoCache(ACanvas, AFormatCanvas: TCanvas); dynamic;
      procedure DestroyFontInfoCache(var Cache: TRVFontInfoCache); dynamic;
      function GetFontInfoCache(ACanvas, AFormatCanvas: TCanvas;
        RVData: TCustomRVFormattedData): TRVFontInfoCache; dynamic;
      { Create & Destroy }
      constructor Create;
      destructor Destroy; override;
      { Clearing }
      procedure ClearTemporal;virtual;
      procedure Clear; override;
      { Soft page breaks }
      procedure AssignSoftPageBreaks(RVPrint: TComponent);
      procedure AssignSoftPageBreak(CustomMultiPagePtblRVData: TCustomRVFormattedData;
        PageNo: Integer);
      function ClearSoftPageBreaks: Boolean;
      { Focused items }
      function GetNextFocusedItem(ItemNo: Integer; GoForward: Boolean;
        var TopLevelRVData: TCustomRVFormattedData;
        var TopLevelItemNo: Integer): Integer;
      procedure ClearFocus;
      procedure AdjustFocus(NewFocusedItemNo: Integer;
        TopLevelRVData: TPersistent; TopLevelItemNo: Integer); dynamic;
      { Animation }
      {$IFNDEF RVDONOTUSEANIMATION}
      function AllowAnimation: Boolean; dynamic;
      procedure InsertAnimator(var Animator: TObject); dynamic;
      procedure ResetAniBackground; dynamic;
      {$ENDIF}
      { Size and position of document }
      procedure GetOrigin(var ALeft, ATop: Integer); virtual;
      procedure GetOriginEx(var ALeft, ATop: Integer); dynamic;
      procedure ConvertCoordToAbsRootData(var X, Y: Integer);
      function GetAreaWidth: Integer; virtual;                abstract;
      function GetAreaHeight: Integer; virtual;                abstract;
      function GetLeftMargin: Integer; virtual;               abstract;
      function GetRightMargin: Integer; virtual;              abstract;
      function GetTopMargin: Integer; virtual;                abstract;
      function GetBottomMargin: Integer; virtual;             abstract;
      function GetMinTextWidth: Integer; virtual;             abstract;
      function GetMaxTextWidth: Integer; virtual;             abstract;
      function GetWidth: Integer; virtual; abstract;
      function GetHeight: Integer; virtual; abstract;
      procedure SetDocumentAreaSize(Width,Height: Integer;
        UpdateH: Boolean); virtual; abstract;
      function CalculateEmptyParaSectionWidth(ItemNo: Integer;
        var FirstParaItemNo: Integer; sad: PRVScreenAndDevice; Canvas: TCanvas): Integer;
      function CalculateParaSectionMinWidth(StartItemNo: Integer;
        var FirstParaItemNo: Integer; sad: PRVScreenAndDevice;
        Canvas: TCanvas): Integer;
      function CalculateMinItemsWidthNoWrap(StartItemNo, EndItemNo: Integer;
        sad: PRVScreenAndDevice; Canvas: TCanvas; IgnoreFloating: Boolean): Integer;
      function CalculateParaSectionMinWidthDef(StartItemNo: Integer): Integer;
      function CalculateParaSectionsMinWidth(StartItemNo, EndItemNo: Integer;
        var FirstParaItemNo: Integer; sad: PRVScreenAndDevice;
        Canvas: TCanvas): Integer;
      function CalculateParaSectionsMinWidthDef(StartItemNo, EndItemNo: Integer): Integer;
      function CalculateMinItemWidthWrap(ItemNo: Integer;
        sad: PRVScreenAndDevice; Canvas: TCanvas; IgnoreFloating: Boolean): Integer;
      function CalculateMinItemsWidthPlusWrap(StartItemNo, EndItemNo: Integer;
        var FirstParaItemNo: Integer; sad: PRVScreenAndDevice;
        Canvas: TCanvas): Integer;
      function CalculateMinItemWidthPlusEx(ItemNo: Integer): Integer;
      function CalculateMinItemsWidthPlusEx(StartItemNo, EndItemNo: Integer): Integer;
      function CalculateMinDocWidthPlus(FirstItemNo: Integer;
        sad: PRVScreenAndDevice; Canvas: TCanvas): Integer;
      function CalculateMinWidthAfterInsert(item:TCustomRVItemInfo; InsertItemNo: Integer): Integer;
      function CalculateMinLineWidth(FirstItemNo: Integer;
        sad: PRVScreenAndDevice; Canvas: TCanvas): Integer;
      { Coordinates }
      procedure ResetSubCoords; dynamic;
      function GetDrawItemNo(BoundLine: Integer; Option: Integer): Integer;
      function GetItemCoords(ItemNo: Integer;var Left,Top: Integer): Boolean;
      function GetItemClientCoords(ItemNo: Integer;var Left,Top: Integer): Boolean;
      function ClientToScreen(const p: TPoint): TPoint; dynamic;
      function ScreenToClient(const p: TPoint): TPoint; dynamic;
      {$IFNDEF RVDONOTUSESMARTPOPUP}
      procedure AdjustSpecialControlsCoords(RVData: TCustomRVFormattedData); dynamic;
      {$ENDIF}
      procedure AdjustChildrenCoords;
      { Get ... at (X,Y) }
      procedure GetWordAtR(X, Y: Integer; var RVData: TCustomRVFormattedData;
        var ItemNo: Integer; var Word: TRVRawByteString);
      function FindWordAtR(var Word: TRVRawByteString; X, Y: Integer; var StyleNo,
        ItemNo, Offs: Integer; var RVData: TCustomRVFormattedData;
        ClientCoords: Boolean): Boolean;
      procedure GetItemAt(X,Y: Integer; var ItemNo, OffsetInItem: Integer);
      procedure GetItemAtEx(X,Y: Integer; var RVData: TCustomRVFormattedData;
        var ItemNo, OffsetInItem: Integer; Strict, ClosestSubRVData: Boolean;
        var InSubRVDataOwnerItem: Boolean);
      { Scrolling }
      procedure ShowRectangle(Left, Top, Width, Height: Integer); dynamic;
      procedure AdjustVScrollUnits; virtual; abstract;
      function GetHOffs: Integer; virtual;
      function GetVOffs: Integer; virtual;
      procedure ScrollTo(Y: Integer; Redraw: Boolean); virtual; abstract;
      procedure HScrollTo(X: Integer); virtual; abstract;
      function GetVSmallStep: Integer; virtual; abstract;
      procedure AfterVScroll;
      procedure OnTimerScroll;
      { Calling events }
      procedure DoCopy; dynamic;
      function IsAssignedCopy: Boolean; dynamic;
      function IsAssignedRVMouseUp: Boolean; dynamic; abstract;
      function IsAssignedRVMouseDown: Boolean; dynamic; abstract;
      function IsAssignedRVRightClick: Boolean; dynamic;
      function IsAssignedJump: Boolean; dynamic; abstract;
      function IsAssignedRVDblClick: Boolean; dynamic;
      function IsAssignedCheckpointVisible: Boolean; dynamic; abstract;
      procedure DoRVMouseUp(Button: TMouseButton; Shift: TShiftState;
        ItemNo, X, Y: Integer); dynamic; abstract;
      procedure DoRVMouseDown(Button: TMouseButton; Shift: TShiftState;
                            ItemNo, X, Y: Integer); dynamic; abstract;
      procedure DoRVRightClick(const ClickedWord: TRVRawByteString;
        StyleNo, X, Y: Integer);dynamic;
      procedure DoJump(id: Integer); dynamic; abstract;
      procedure DoGetItemCursor(RVData: TCustomRVData; ItemNo: Integer;
        var Cursor: TCursor); dynamic;
      procedure DoRVMouseMove(id: Integer); dynamic; abstract;
      procedure DoRVDblClick(const ClickedWord: TRVRawByteString; StyleNo: Integer); dynamic;
      procedure DoSelect; dynamic;
      procedure DoCheckpointVisible(CheckpointData: TCheckpointData); dynamic; abstract;
      procedure DoCurrentTextStyleConversion(var StyleNo: Integer;
        ParaStyleNo, ItemNo, UserData: Integer; ToWholeParagraphs: Boolean); dynamic;
      procedure DoDrawHyperlink(RVData: TCustomRVData; ItemNo: Integer; R: TRect); dynamic;
      { Properties }
      function GetNormalCursor: TCursor; dynamic; abstract;
      function GetCPEventKind: TCPEventKind; dynamic;
      function GetBackground: TRVBackground; virtual; abstract;
      function GetCanvas: TCanvas; virtual;
      procedure SetCursor(Cursor: TCursor); dynamic;
      function GetEditor: TWinControl; dynamic;
      { Mouse }
      procedure MouseLeave;
      procedure MouseMove(Shift: TShiftState; X, Y: Integer); dynamic;
      procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);dynamic;
      procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);dynamic;
      procedure DblClick;
      procedure DblClickAt(const p: TPoint);
      procedure TripleClick;
      procedure AdjustMouseUpSelection; dynamic;
      { Mouse capture }
      procedure SetMouseCapture(Item: TCustomRVItemInfo;  var Left,Top: Integer);
      procedure ReleaseMouseCapture(Item: TCustomRVItemInfo);
      {$IFNDEF RVDONOTUSEDRAGDROP}
      { Drag & drop: drop to }
      function GetDragDropCaretInfo: TRVDragDropCaretInfo; dynamic;
      procedure SetDragDropCaretTo(X,Y: Integer);
      procedure RemoveDragDropCaret;
      procedure SetDragDropCaret(ItemNo, Offs: Integer);
      { Drag & drop: drop from }
      procedure DoDrag;
      function IsDragging: Boolean; dynamic;
      {$ENDIF}
      { Insertion and protection (used in editor or by drag&drop) }
      function CanInsertHere(ItemNo, Offs: Integer): Boolean;
      function IsProtected(ItemNo: Integer; Option: TRVProtectOption): Boolean;
      function IsParaProtected(ParaNo: Integer; Option: TRVParaOption): Boolean;
      function IsItemParaProtected(ItemNo: Integer): Boolean;
      function IsSticking(FirstItemNo: Integer; NoSound: Boolean): Boolean;
      { Drawing }
      function GetFormatCanvas: TCanvas; 
      function GetFormatCanvasEx(DefCanvas: TCanvas): TCanvas; virtual;      
      procedure DrawBackground(Canvas: TCanvas; r: TRect;
        GraphicInterface: TRVGraphicInterface); virtual;
      procedure PaintTo(Canvas: TCanvas; AClipRect: TRect;
        StrictTop, StrictBottom, InplaceOnMainCanvas, PrintMode: Boolean;
        ExtraXOffs, ExtraYOffs, MinItemNo, MaxItemNo: Integer);
      procedure GetItemBackground(ItemNo: Integer; r: TRect; MakeImageRect: Boolean;
        var Color: TColor; var bmp: TBitmap;
        var UseBitmap: Boolean; GraphicInterface: TRVGraphicInterface); virtual;
      { Redrawing }
      procedure InvalidateJumpRect(id: Integer);
      procedure Refresh;
      procedure UpdateView;
      procedure Invalidate;
      procedure InvalidateRect(const r: TRect);
      { Palette }
      procedure UpdateBackgroundPaletteInfo(Background: TRVBackground);
      function UpdatingBackgroundPalette: Boolean;
      { Drawing XOR }
      procedure XorDrawing; virtual;
      procedure XorDrawingEx(X,Y: Integer);
      function ClearXorDrawing: Boolean;
      procedure AssignXorDrawing(P: TMouseMoveEvent);
      function UsingThisXorDrawing(P: TMouseMoveEvent): Boolean;
      procedure UnAssignXorDrawing(P: TMouseMoveEvent);
      { Formatting }
      function GetStandardDrawLineInfoClass(item: TCustomRVItemInfo;
        para: TParaInfo): TRVDrawLineInfoClass;
      procedure AdjustDrawItemsForFormatParas(
        var StartDrawItemNo, EndDrawItemNo: Integer;
        ItemsInserted: Integer);
      procedure FormatParas(StartDrawItemNo, EndDrawItemNo, ItemsInserted: Integer);
      procedure StartPartialFormatting; virtual;
      procedure FormatParasExact(StartDrawItemNo, EndDrawItemNo,
        ItemsInserted: Integer; NoCaching: Boolean);
      procedure Format_(OnlyResized, ForceFormat, NoScroll: Boolean;
        depth: Integer; Canvas: TCanvas; OnlyTail, NoCaching, Reformatting,
        CallOnFormat: Boolean); virtual;
      procedure Format(NoCaching: Boolean);
      procedure ChangeDItemWidth(DItemNo, NewWidth: Integer);
      procedure Hiding;
      { Selecting }
      procedure DoSetSelectionBounds(StartItemNo, StartItemOffs, EndItemNo,
        EndItemOffs: Integer);
      procedure SetSelectionBounds(StartItemNo, StartItemOffs, EndItemNo,
        EndItemOffs: Integer);
      function SearchTextR(Down, MatchCase, WholeWord, FromStart, Unicode,
        MultiItem: Boolean; s: TRVRawByteString): Boolean;
      procedure SelectWordAt(X, Y: Integer);
      function SelectControl(AControl: TControl): Boolean;
      procedure Deselect(NewPartiallySelected: TCustomRVItemInfo;
        MakeEvent: Boolean); dynamic;
      procedure SelectAll;
      procedure SelectLine(ItemNo, Offs: Integer);
      procedure RestoreSelBounds(StartNo, EndNo, StartOffs, EndOffs: Integer);
      procedure SrchSelectIt(StartItemNo, StartOffs, EndItemNo, EndOffs: Integer;
        Invert: Boolean); dynamic;
      procedure SrchStart(Down, FromStart: Boolean; var strt, offs: Integer);dynamic;
      { Chosen RVData & Item }
      procedure AssignChosenRVData(RVData: TCustomRVFormattedData;
        Item: TCustomRVItemInfo); dynamic;
      procedure SilentReplaceChosenRVData(RVData: TCustomRVFormattedData); dynamic;
      procedure UnassignChosenRVData(RVData: TCustomRVData); dynamic;
      procedure ChooseMe;
      { Get selection }
      function SelectionExists(AllowReset: Boolean;
        UsePartialSelected: Boolean): Boolean;
      procedure GetSelectionBounds(var StartItemNo, StartItemOffs, EndItemNo,
        EndItemOffs: Integer; Normalize: Boolean);
      procedure GetSelBounds(var StartNo, EndNo, StartOffs, EndOffs: Integer;
        Normalize: Boolean); dynamic;
      procedure StoreSelBounds(var StartNo, EndNo, StartOffs, EndOffs: Integer;
        Normalize: Boolean);
      procedure GetSelectionBoundsEx(var StartItemNo, StartItemOffs, EndItemNo,
        EndItemOffs: Integer; Normalize: Boolean); dynamic;
      procedure GetSelStart(var DINo, DIOffs: Integer);dynamic;
      function GetSelTextR(Unicode: Boolean): TRVRawByteString;
      function GetSelectedImage: TGraphic;
      function GetSelectionRect: TRect;
      { Selection misc. }
      function ExpandSelectionToParagraph(OnlyIfMultiple: Boolean): Boolean;      
      procedure DoOnSelection(AllowScrolling: Boolean); dynamic;
      function Item_InsideSelection(ItemNo, ItemOffs: Integer; IncludeBorders: Boolean): Boolean;
      { Checkpoints }
      procedure GetCheckpointXY(CheckpointData: TCheckpointData; var X, Y: Integer);
      function  GetCheckpointYEx(CheckpointData: TCheckpointData): Integer;
      { Hypertext }
      procedure BuildJumpsCoords(var StartJumpNo: Integer; jumps: TList);
      procedure ClearJumps;
      procedure AdjustJumpsCoords;
      function  GetJumpPointY(id: Integer): Integer;
      function  GetJumpPointItemNo(id: Integer): Integer;
      procedure GetJumpPointLocation(id: Integer; var RVData: TCustomRVFormattedData; var ItemNo: Integer);
      { Copying to the Clipboard }
      {$IFNDEF RVDONOTUSERVF}
      procedure CopyRVF(Color: TColor; Background: TRVBackground);
      {$ENDIF}
      {$IFNDEF RVDONOTUSERTF}
      procedure CopyRTF(Color: TColor; Background: TRVBackground);
      {$ENDIF}
      procedure CopyTextA;
      procedure CopyTextW;
      procedure CopyText;
      procedure CopyImage;
      procedure Copy(Color: TColor; Background: TRVBackground);
      function  CopyDef(Color: TColor; Background: TRVBackground): Boolean;
      { Items and drawitems indices, line numbers }
      function GetLineNo(ItemNo, ItemOffs: Integer): Integer;
      procedure GetParaBoundsEx(DINo1, DINo2: Integer; var ParaStart, ParaEnd: Integer;
        IncludeAdjacent: Boolean);
      function GetFirstVisible(TopLine: Integer): Integer;
      function GetFirstItemVisible: Integer; dynamic;
      function GetLastItemVisible: Integer; dynamic;
      function GetOffsBeforeDrawItem(DrawItemNo: Integer): Integer;
      function GetOffsAfterDrawItem(DrawItemNo: Integer): Integer;
      procedure DrawItem2Item(DrawItemNo, DrawItemOffs: Integer; var ItemNo, ItemOffs: Integer);
      procedure Item2DrawItem(ItemNo, ItemOffs: Integer; var DrawItemNo, DrawItemOffs: Integer;
        PosIfHidden: TRVDrawItemPosition{$IFDEF RICHVIEWDEF4}=rvdpBetterBelow{$ENDIF});
      procedure Item2FirstDrawItem(ItemNo: Integer; var DrawItemNo: Integer);
      procedure Item2LastDrawItem(ItemNo: Integer; var DrawItemNo: Integer);
      function FindDrawItemByItem(ItemNo: Integer): Integer;
      procedure InvalidateDrawItem(DrawItemNo, Spacing: Integer);
      { Deleting }
      procedure DeleteItems(FirstItemNo, Count: Integer); override;
      procedure DeleteParas(FirstItemNo, LastItemNo: Integer);
      { Others }
      procedure Normalize;
      procedure SetControlHint(const Hint: String); dynamic;
      function GetItemPart(ItemNo, OffsetInItem: Integer): Integer;
      { Properties }
      property PartialSelectedItem: TCustomRVItemInfo
        read FPartialSelectedItem write SetPartialSelectedItem;
      property CaptureMouseItem: TCustomRVItemInfo read FCaptureMouseItem;
      property SoftPageBreaks: TRVSoftPageBreakList read GetSoftPageBreaks;
      //property ZoomPercent:Integer read FZoomPercent write SetZoomPercent;
      { Selection Info }
      function IsMultiParagraphSelection: Boolean;
      property OnRepaint: TRVRepaintEvent read FOnRepaint write FOnRepaint;
  end;

const
  RichViewSafeFormatting:Boolean = False;
  RichViewShowGhostSpaces: Boolean = False;

implementation
uses RichView,
    {$IFNDEF RVDONOTUSELIVESPELL}
    RVWordPaint,
    {$ENDIF}
    {$IFNDEF RVDONOTUSELISTS}
    RVMarker,
    {$ENDIF}
    RVCtrlData, RVStr, PtblRV, PtRVData;
{==============================================================================}
const gdinFirstVisible        = 1;
const gdinLastCompleteVisible = 2;
const gdinLastVisible         = 3;
const MAXLINELENGTH           = 1000;
{------------------------------------------------------------------------------}
function MyStrRScanA(Str: PRVAnsiChar; Chr: TRVAnsiChar; Length: Integer): PRVAnsiChar;
begin
  Result := Str+Length-1;
  while Result>=Str do begin
    if Result^=Chr then
      exit;
    dec(Result);
  end;
  Result := nil;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEUNICODE}
{
function MyStrRScanW(Str: PChar; Chr: Char; Length: Integer): PChar;
begin
  Result := Str+(Length-1)*2;
  while Result>=Str do begin
    if (Result^=Chr) and ((Result+1)^=#0) then
      exit;
    dec(Result, 2);
  end;
  Result := nil;
end;
}
{$ENDIF}
{------------------------------------------------------------------------------}
function max(a,b: Integer): Integer;
begin
  if a>b then
    max := a
  else
    max := b;
end;
{================================ TRVSelectingInfo ============================}
{ Initializing ending values with the starting values                          }
procedure TRVSelectingInfo.InitE(ASWordState: TRVSelectingState);
begin
  DrawItemEOffs := DrawItemSOffs;
  DrawItemENo := DrawItemSNo;
  DrawItemEWordOffs1 := DrawItemSWordOffs1;
  DrawItemEWordOffs2 := DrawItemSWordOffs2;
  if ASWordState=rvsesParaMode then begin
    SWordState := rvsesParaMode;
    EWordState := rvsesParaMode;
    end
  else begin
    SWordState := ASWordState;
    EWordState := rvsesInWord;
  end;
end;
{------------------------------------------------------------------------------}
{ Is (ADrawItemNo, ADrawItemOffs) in inside the starting word?                 }
function TRVSelectingInfo.IsInSWord(ADrawItemNo, ADrawItemOffs: Integer): Boolean;
begin
  Result := (ADrawItemNo=DrawItemSNo) and
            (ADrawItemOffs>=DrawItemSWordOffs1) and
            (ADrawItemOffs<=DrawItemSWordOffs2)
end;
{------------------------------------------------------------------------------}
{ Is (ADrawItemNo, ADrawItemOffs) below the starting word?                     }
function TRVSelectingInfo.IsBelowSWord(ADrawItemNo, ADrawItemOffs: Integer): Boolean;
begin
  Result := (ADrawItemNo>DrawItemSNo) or
            ((ADrawItemNo=DrawItemSNo) and (ADrawItemOffs>DrawItemSWordOffs2));
end;
{------------------------------------------------------------------------------}
{ Is (ADrawItemNo, ADrawItemOffs) above the starting word?                     }
function TRVSelectingInfo.IsAboveSWord(ADrawItemNo, ADrawItemOffs: Integer): Boolean;
begin
  Result := (ADrawItemNo<DrawItemSNo) or
            ((ADrawItemNo=DrawItemSNo) and (ADrawItemOffs<DrawItemSWordOffs1));
end;
{------------------------------------------------------------------------------}
{ Are the positions of the ending and the starting words equal?                }
function TRVSelectingInfo.AreWordsEqual: Boolean;
begin
  Result := (DrawItemENo=DrawItemSNo) and
            (DrawItemEWordOffs1=DrawItemSWordOffs1) and
            (DrawItemEWordOffs2=DrawItemSWordOffs2);
end;
{------------------------------------------------------------------------------}
{ Are the parameters equal to the ending word?                                 }
function TRVSelectingInfo.IsEWord(ADrawItemNo,
  ADrawItemWordOffs1, ADrawItemWordOffs2: Integer): Boolean;
begin
  Result := (DrawItemENo=DrawItemENo) and
            (DrawItemEWordOffs1=ADrawItemWordOffs1) and
            (DrawItemEWordOffs2=ADrawItemWordOffs2);
end;
{------------------------------------------------------------------------------}
{ Should we change EWordState to rvsesFreeMode?
  This function assumes that the ending point of the selection
  (ADrawItemNo, ADrawItemOffs) is inside the ending word                       }
function TRVSelectingInfo.IsEFreeStateNeeded(ADrawItemNo,
  ADrawItemOffs: Integer): Boolean;
begin
  Result :=
    (IsAboveSWord(ADrawItemNo,ADrawItemOffs) and (ADrawItemOffs>DrawItemEOffs))
    or
    (IsBelowSWord(ADrawItemNo,ADrawItemOffs) and (ADrawItemOffs<DrawItemEOffs));
end;
{=========================== TRVSoftPageBreakList =============================}
(*function TRVSoftPageBreakList.FindItem(ItemNo: Integer): Integer;
var a,b,no: Integer;
  {....................................}
  procedure AdjustResult(var R: Integer);
  begin
    while (R>0) and (TRVSoftPageBreakInfo(Items[R-1]).ItemNo=ItemNo) do
      dec(R);

  end;
  {....................................}
begin
  a := 0;
  b := Count-1;
  while b-a>1 do begin
    Result := (a+b) div 2;
    no := TRVSoftPageBreakInfo(Items[Result]).ItemNo;
    if no=ItemNo then begin
      AdjustResult(Result);
      exit;
    end;
    if no<ItemNo then
      a := Result
    else
      b := Result;
  end;
  if TRVSoftPageBreakInfo(Items[a]).ItemNo=ItemNo then
    Result := a
  else if TRVSoftPageBreakInfo(Items[b]).ItemNo=ItemNo then
    Result := b
  else
    Result := -1;
  AdjustResult(Result);
end;*)
{============================ TCustomRVFormattedData ==========================}
constructor TCustomRVFormattedData.Create;
begin
  inherited Create;
  DrawItems := TRVDrawLines.Create;
  Jumps     := TList.Create;
  FSelStartNo    := -1;
  FSelEndNo      := -1;
  FSelStartOffs  := 0;
  FSelEndOffs    := 0;
  TextWidth      := -1;
  DocumentWidth  := -1;
  DocumentHeight := 0;//GetTopMargin;
  LastItemFormatted  := -1;
  LastJumpMovedAbove := -1;
  LastDIMovedAbove   := -1;
  LastJumpDowned     := -1;
  FocusedItemNo      := -1;
  FActiveItem        := nil;
  FPartialSelectedItem :=  nil;
  //FZoomPercent       := 100;
end;
{------------------------------------------------------------------------------}
destructor TCustomRVFormattedData.Destroy;
begin
  ClearTemporal;
  DrawItems.Free;
  DrawItems := nil;
  Jumps.Free;
  Jumps  := nil;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.ClearLastJump;
begin
  if LastRVDataMovedAbove<>nil then begin
    LastRVDataMovedAbove.State := LastRVDataMovedAbove.State - [rvstDrawHover];
    LastRVDataMovedAbove.LastJumpMovedAbove := -1;
    LastRVDataMovedAbove.LastJumpDowned     := -1;
    DoRVMouseMove(-1);
  end;
  State := State - [rvstDrawHover];
  LastJumpMovedAbove := -1;
  LastJumpDowned     := -1;
  LastRVDataMovedAbove := nil;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.ClearJumps;
var i: Integer;
begin
  if Jumps<>nil then begin
    for i:=0 to Jumps.Count-1 do
      TObject(Jumps[i]).Free;
    Jumps.Clear;
    ClearLastJump;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.ClearTemporal;
var i: Integer;
begin
  if DrawItems<>nil then begin
    for i:=0 to DrawItems.Count-1 do
      DrawItems[i].Free;
    DrawItems.Clear;
    ClearJumps;
    nJmps        := 0;
    FActiveItem  := nil;
    //FPartialSelectedItem := nil;
    FCaptureMouseItem := nil;
    LastDIMovedAbove := -1;
    LastRVDataMovedAbove := nil;
    State := State - [ rvstMakingSelection, rvstLineSelection, rvstDrawHover];
    LastRaisedCP := nil;
    FClickedDrawItemNo := -1;
    FSelectingInfo.Free;
    FSelectingInfo := nil;
    LastItemFormatted := -1;
    DocumentHeight := GetTopMargin+GetBottomMargin;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.Clear;
var Clearing: Boolean;
begin
  Clearing := rvstClearing in State;
  Include(State, rvstClearing);
  try
    ClearSoftPageBreaks;
    Deselect(nil, True);
    ClearTemporal;
    inherited Clear;
  finally
    if not Clearing then
      Exclude(State, rvstClearing);
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.Deselect(NewPartiallySelected: TCustomRVItemInfo;
                                          MakeEvent: Boolean);
begin
  if rvstDeselecting in State then
    exit;
  State := State + [rvstDeselecting];
  try
    State := State - [rvstMakingSelection, rvstLineSelection];
    FSelStartNo   := -1;
    FSelEndNo     := -1;
    FSelStartOffs := 0;
    FSelEndOffs   := 0;
    if (FocusedItemNo>=0) and (FocusedItemNo<ItemCount) then
      GetItem(FocusedItemNo).ClearFocus;
    FocusedItemNo := -1;
    DeselectPartiallySelectedItem(NewPartiallySelected);
    if MakeEvent then
      DoSelect;
  finally
    State := State - [rvstDeselecting];
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.SelectAll;
begin
  if Items.Count=0 then
    exit;
  {$IFNDEF RVDONOTUSELIVESPELL}
  LiveSpellingCheckCurrentItem;
  {$ENDIF}
  DestroyInplaceEditor;
  DeselectPartiallySelectedItem(nil);
  FSelStartNo   := 0;
  FSelEndNo     := DrawItems.Count-1;
  FSelStartOffs := GetOffsBeforeDrawItem(0);
  FSelEndOffs   := GetOffsAfterDrawItem(FSelEndNo);
  DoOnSelection(False);
  DoSelect;
end;

procedure TCustomRVFormattedData.ConcateItems(FirstItemNo: Integer);
var item1,item2: TCustomRVItemInfo;
begin
  item1 := GetItem(FirstItemNo);
  item2 := GetItem(FirstItemNo+1);
  if ((rvioUnicode in item1.ItemOptions)<>
     (rvioUnicode in item2.ItemOptions)) and
     (Items[FirstItemNo+1]<>'') then begin
    item2.SameAsPrev := item1.SameAsPrev;
    item2.BR := item1.BR;
    FreeItem(FirstItemNo, False);
    Items.Delete(FirstItemNo);
    end
  else begin
    Items[FirstItemNo] := Items[FirstItemNo]+Items[FirstItemNo+1];
    FreeItem(FirstItemNo+1, False);
    Items.Delete(FirstItemNo+1);
  end;
end;
{------------------------------------------------------------------------------}
// Is the ItemNo-th item hidden?
function TCustomRVFormattedData.IsHidden(ItemNo: Integer): Boolean;
{$IFNDEF RVDONOTUSELISTS}
var i: Integer;
{$ENDIF}
begin
  if (rvoShowHiddenText in Options) then begin
    Result := False;
    exit;
  end;
  if GetItemStyle(ItemNo)<0 then begin
    Result := TRVNonTextItemInfo(GetItem(ItemNo)).Hidden;
    {$IFNDEF RVDONOTUSELISTS}
    // hiding paragraph marker if the whole paragraph section is hidden
    if not Result and (GetItemStyle(ItemNo)=rvsListMarker) then begin
      for i := ItemNo+1 to ItemCount-1 do begin
        if IsFromNewLine(i) then
          break;
        if not IsHidden(i) then
          exit;
      end;
      Result := True;
    end;
    {$ENDIF}
    end
  else
    Result := rvteoHidden in GetRVStyle.TextStyles[GetItemStyle(ItemNo)].Options;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.IsHiddenItem(Item: TCustomRVItemInfo): Boolean;
begin
  if (rvoShowHiddenText in Options) then begin
    Result := False;
    exit;
  end;
  if Item.StyleNo<0 then
    Result := TRVNonTextItemInfo(Item).Hidden
  else
    Result := rvteoHidden in GetRVStyle.TextStyles[GetActualStyle(Item)].Options;
end;
{------------------------------------------------------------------------------}
// Are all items in the paragraph section started from FirstItemNo hidden?
function TCustomRVFormattedData.IsParaSectionHidden(FirstItemNo: Integer): Boolean;
var i: Integer;
begin
  if (rvoShowHiddenText in Options) then begin
    Result := False;
    exit;
  end;
  Result := IsHidden(FirstItemNo);
  if not Result then
    exit;
  for i := FirstItemNo+1 to ItemCount-1 do begin
    if IsFromNewLine(i) then
      exit;
    if not IsHidden(i) then begin
      Result := False;
      exit;
    end;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.CanShowSpecialCharacters: Boolean;
begin
  Result := (rvoShowSpecialCharacters in Options) and
    not (rvstNoSpecialCharacters in State);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.Normalize;
var li, li2: TCustomRVItemInfo;
    i: Integer;
begin
  for i := ItemCount-1 downto 1 do begin
    li := GetItem(i-1);
    li2 := GetItem(i);
    if RV_CanConcateItems(i-1, li,li2,False,True) then
      ConcateItems(i-1);
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.SetControlHint(const Hint: String);
begin
  TCustomRVFormattedData(GetAbsoluteRootData).SetControlHint(Hint);
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetOffsBeforeDrawItem(DrawItemNo: Integer): Integer;
begin
  if GetDrawItemStyle(DrawItemNo)<0 then
    Result := 0
  else
    Result := 1;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetOffsAfterDrawItem(DrawItemNo: Integer): Integer;
begin
  if GetDrawItemStyle(DrawItemNo)<0 then
    Result := 1
  else
    Result := DrawItems[DrawItemNo].Length+1;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.FormatAddFloating(var Params: TRVFormatParams;
  const sad: TRVScreenAndDevice; DrawItemNo: Integer; var Y: Integer);
var Item: TRVRectItemInfo;
    LWidth: Integer;
begin
  if Params.FloatingDrawItems=nil then
    Params.FloatingDrawItems := TRVFloatingDrawItems.Create;
  Item := GetItem(DrawItems[DrawItemNo].ItemNo) as TRVRectItemInfo;
  with TRVFloatingDrawLineInfo(DrawItems[DrawItemNo]) do begin
    FloatTop := Y;
    case Item.VAlign of
      rvvaLeft:
        FloatType := rvdifLeft;
      rvvaRight:
        FloatType := rvdifRight;
    end;
    FloatWidth := Item.GetWidthEx(GetRVStyle, @sad);
    FloatHeight := Item.GetHeightEx(GetRVStyle, @sad);
    FloatLeft := Params.UnadjustedLeftIndent;//sad.LeftMargin + Params.LeftIndent;
    LWidth := Params.UnadjustedRightSide-Params.UnadjustedLeftIndent;//Params.LineWidth;
    Params.FloatingDrawItems.AdjustLineSize(Params.UnadjustedLeftIndent,
      FloatWidth, Params.UnadjustedRightSide,
      FloatTop, FloatLeft, LWidth, False,
      Item.ClearLeft or Item.PageBreakBefore,
      Item.ClearRight or Item.PageBreakBefore,
      Params.FloatingDrawItemsInThisParaSection);
    Y := FloatTop;
    if FloatType=rvdifRight then
      FloatLeft := FloatLeft+LWidth-FloatWidth;
  end;
  Params.FloatingDrawItems.Add(DrawItems[DrawItemNo]);
  if Params.FloatingDrawItemsInThisParaSection=nil then
    Params.FloatingDrawItemsInThisParaSection := TList.Create;
  Params.FloatingDrawItemsInThisParaSection.Add(DrawItems[DrawItemNo]);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.FinishScreenLine(const sad: TRVScreenAndDevice;
  IsParaSectionFinished: Boolean; var ExtraSpace: Integer;
  var Params: TRVFormatParams);
var  pi: TParaInfo;
     BiDiMode: TRVBiDiMode;
     Alignment: TRVAlignment;
     LineEndX: Integer;
  {.......................................................}
  procedure RearrangeMarker(FirstDrawItem, LastDrawItem: Integer);
  var extrax, i: Integer;
  begin
    if not GetItem(DrawItems[FirstDrawItem].ItemNo).SameAsPrev and
       (DrawItems[FirstDrawItem].Offs<=GetOffsBeforeItem(DrawItems[FirstDrawItem].ItemNo)) then begin
       {$IFNDEF RVDONOTUSELISTS}
       if (GetItemStyle(DrawItems[FirstDrawItem].ItemNo)=rvsListMarker) then begin
         extrax := RV_XToDevice(
           -TRVMarkerItemInfo(GetItem(DrawItems[FirstDrawItem].ItemNo)).GetLeftOverhang,
           sad);
         end
       else
       {$ENDIF}
       begin
         extrax := GetRVStyle.GetAsDevicePixelsX(pi.FirstIndent, @sad);
       end;
      if extrax<>0 then
        for i := FirstDrawItem to LastDrawItem do
          dec(DrawItems[i].Left, extrax);
    end;
  end;
  {.......................................................}
  function GetDrawItemBiDi(DrawItemNo: Integer; var Start, Ending: TRVBiDiMode): Boolean;
  var item: TCustomRVItemInfo;
      Locale: Cardinal;
      Len: Integer;
      s: TRVRawByteString;
      CharTypes: PWordArray;
  begin
    Start  := BiDiMode;
    Ending := BiDiMode;
    Result := True;
    item := GetItem(DrawItems[DrawItemNo].ItemNo);
    if item.StyleNo<0 then
      exit;
    s := DrawItems.GetString(DrawItemNo, Items);
    if s='' then
      exit;
    {$IFNDEF RVDONOTUSEUNICODE}
    if GetRVStyle.TextStyles[GetActualStyle(item)].Unicode then
      Len := Length(s) div 2
    else
    {$ENDIF}
      Len := Length(s);
    Locale := GetStyleLocale(GetActualStyle(item));
    if GetRVStyle.TextStyles[GetActualStyle(item)].BiDiMode<>rvbdUnspecified then begin
      Start  := GetRVStyle.TextStyles[GetActualStyle(item)].BiDiMode;
      Ending := GetRVStyle.TextStyles[GetActualStyle(item)].BiDiMode;
    end;
    GetMem(CharTypes, Len*sizeof(Word));
    try
      {$IFNDEF RVDONOTUSEUNICODE}
      if GetRVStyle.TextStyles[GetActualStyle(item)].Unicode then
        GetStringTypeExW(Locale, CT_CTYPE2, Pointer(s), Len, CharTypes^)
      else
      {$ENDIF}
        GetStringTypeExA(Locale, CT_CTYPE2, Pointer(s), Len, CharTypes^);
      case CharTypes[0] of
        C2_LEFTTORIGHT:
          Start := rvbdLeftToRight;
        C2_RIGHTTOLEFT:
          Start := rvbdRightToLeft;
      end;
      case CharTypes[Len-1] of
        C2_LEFTTORIGHT:
          Ending := rvbdLeftToRight;
        C2_RIGHTTOLEFT:
          Ending := rvbdRightToLeft;
      end;
    finally
      FreeMem(CharTypes);
    end;
  end;
  {.......................................................}
  function RearrangeLineEx(LastDrawItem: Integer): Boolean;
  var FirstDrawItem, i,insertpoint: Integer;
      curx: Integer;
      diorder, extrax: TRVIntegerList;
      CurBiDi, PrevBiDi, StartBiDi, EndBiDi: TRVBiDiMode;
  begin
    Result := True;
    if BiDiMode=rvbdUnspecified then
      exit;
    FirstDrawItem := LastDrawItem;
    while (FirstDrawItem>0) and not DrawItems[FirstDrawItem].FromNewLine do
      dec(FirstDrawItem);
    if BiDiMode=rvbdRightToLeft then
      RearrangeMarker(FirstDrawItem, LastDrawItem);
    if FirstDrawItem=LastDrawItem then
      exit;
    insertpoint := 0;
    diorder := TRVIntegerList.Create;
    extrax  := TRVIntegerList.Create;
    try
      PrevBiDi := BiDiMode;
      for i := FirstDrawItem to LastDrawItem do begin
        if not GetDrawItemBiDi(i, StartBiDi, EndBiDi) then begin
          diorder.Free;
          Result := False;
          exit;
        end;
        CurBiDi := BiDiMode;
        if PrevBiDi=StartBiDi then
          CurBiDi := PrevBiDi;
        PrevBiDi := EndBiDi;
        if CurBiDi=rvbdLeftToRight then begin
          if BiDiMode=rvbdLeftToRight then
            insertpoint := diorder.Count
          else if insertpoint<diorder.Count then
            inc(insertpoint);
          end
        else if BiDiMode=rvbdRightToLeft then
          insertpoint := 0;
        diorder.Insert(insertpoint, i);
      end;
      for i := 0 to diorder.Count-1 do
        if diorder[i]>FirstDrawItem then
          extrax.Add(DrawItems[diorder[i]].Left-(DrawItems[diorder[i]-1].Left+DrawItems[diorder[i]-1].Width))
        else
          extrax.Add(0);
      curx := DrawItems[FirstDrawItem].Left;
      for i := 0 to diorder.Count-1 do begin
        DrawItems[diorder[i]].Left := curx;
        inc(curx, DrawItems[diorder[i]].Width+extrax[i]);
      end;
    finally
      diorder.Free;
      extrax.Free;
    end;
  end;
  {.......................................................}
  procedure RearrangeLine(LastDrawItem: Integer);
  var FirstDrawItem, i: Integer;
      curx, extrax: Integer;
  begin
    if BiDiMode<>rvbdRightToLeft then
      exit;
    FirstDrawItem := LastDrawItem;
    while (FirstDrawItem>0) and not DrawItems[FirstDrawItem].FromNewLine do
      dec(FirstDrawItem);
    RearrangeMarker(FirstDrawItem, LastDrawItem);
    if FirstDrawItem=LastDrawItem then
      exit;
    curx := DrawItems[FirstDrawItem].Left;
    for i := LastDrawItem downto FirstDrawItem do begin
      if i>FirstDrawItem then
        extrax := DrawItems[i].Left-(DrawItems[i-1].Left+DrawItems[i-1].Width)
      else
        extrax := 0;
      DrawItems[i].Left := curx;
      inc(curx, DrawItems[i].Width+extrax);
    end;
  end;
  {.......................................................}
  { Returns a number of pixels, to add to the baseline of the next line to shift
    it down }
  function ProcessVAlign(LastDrawItem: Integer): Integer;
  var FirstDrawItem, i, LineTop, LineBottom, NewLineTop, NewLineBottom: Integer;
  begin
    Result := 0;
    FirstDrawItem := LastDrawItem;
    // finding the screen line start
    while (FirstDrawItem>0) and not DrawItems[FirstDrawItem].FromNewLine do
      dec(FirstDrawItem);
    // calculating top and bottom line coordinates, excluding not-aligned items
    if pi.LineSpacingType=rvlsLineHeightExact then begin
      LineTop := Params.BaseLine-Params.LineHeightAbove;
      LineBottom := Params.BaseLine+Params.LineHeightBelow;
      end
    else begin
      if pi.LineSpacingType=rvlsLineHeightAtLeast then begin
        LineTop := Params.BaseLine-Params.LineHeightAbove;
        LineBottom := Params.BaseLine+Params.LineHeightBelow;
        end
      else begin
        LineTop := DrawItems[FirstDrawItem].Top;
        LineBottom := LineTop;
      end;
      for i := FirstDrawItem to LastDrawItem do
        if not ((GetItem(DrawItems[i].ItemNo) is TRVRectItemInfo) and
                (TRVRectItemInfo(GetItem(DrawItems[i].ItemNo)).VAlign in
                  [rvvaAbsTop,rvvaAbsBottom, rvvaAbsMiddle])) then begin
          if LineTop>DrawItems[i].Top then
            LineTop := DrawItems[i].Top;
          if LineBottom<DrawItems[i].Top+DrawItems[i].Height then
            LineBottom := DrawItems[i].Top+DrawItems[i].Height;
        end;
    end;
    // aligning not aligned items, without moving other items in the same line
    // calculating top and bottom coordinates of these items after aligning
    NewLineTop := LineTop;
    NewLineBottom := LineBottom;
    for i := FirstDrawItem to LastDrawItem do
      if (GetItem(DrawItems[i].ItemNo) is TRVRectItemInfo) then begin
        case TRVRectItemInfo(GetItem(DrawItems[i].ItemNo)).VAlign of
          rvvaAbsTop:
            begin
              {$IFDEF RVUSEBASELINE}
              inc(DrawItems[i].BaseLine, LineTop-DrawItems[i].Top);
              {$ENDIF}
              DrawItems[i].Top := LineTop;
            end;
          rvvaAbsBottom:
            begin
              {$IFDEF RVUSEBASELINE}
              inc(DrawItems[i].BaseLine, LineBottom-DrawItems[i].Height-DrawItems[i].Top);
              {$ENDIF}
              DrawItems[i].Top := LineBottom-DrawItems[i].Height;
            end;
          rvvaAbsMiddle:
            begin
              {$IFDEF RVUSEBASELINE}
              inc(DrawItems[i].BaseLine,
                (LineTop+LineBottom-DrawItems[i].Height) div 2 - DrawItems[i].Top);
              {$ENDIF}
              DrawItems[i].Top := (LineTop+LineBottom-DrawItems[i].Height) div 2;
            end;
        end;
        if TRVRectItemInfo(GetItem(DrawItems[i].ItemNo)).VAlign in
            [rvvaAbsTop,rvvaAbsBottom, rvvaAbsMiddle] then begin
          if NewLineTop>DrawItems[i].Top then
            NewLineTop := DrawItems[i].Top;
          if NewLineBottom<DrawItems[i].Top+DrawItems[i].Height then
            NewLineBottom := DrawItems[i].Top+DrawItems[i].Height;
        end;
      end;
    // moving the line down, if necessary
    if (NewLineTop<LineTop) and (pi.LineSpacingType<>rvlsLineHeightExact) then begin
      for i := FirstDrawItem to LastDrawItem do begin
        dec(DrawItems[i].Top, NewLineTop-LineTop);
        {$IFDEF RVUSEBASELINE}
        dec(DrawItems[i].BaseLine, NewLineTop-LineTop);
        {$ENDIF}
      end;
      dec(NewLineBottom, NewLineTop-LineTop);
    end;
    // calculating extra offset for the next line
    if NewLineBottom>LineBottom then
      Result := NewLineBottom-LineBottom;
  end;
  {.......................................................}
  procedure ProcessFloating(LastDrawItem: Integer);
  var FirstDrawItem, i, LineBottomY, ContentTop, ContentBottom,
      ItemVeryBottom, ItemTop, ItemBottom: Integer;
      Beginning: Boolean;
  begin
    FirstDrawItem := LastDrawItem;
    while (FirstDrawItem>0) and not DrawItems[FirstDrawItem].FromNewLine do
      dec(FirstDrawItem);
    ContentTop := DrawItems[FirstDrawItem].Top;
    ContentBottom := ContentTop+DrawItems[FirstDrawItem].Height;
    LineBottomY := ContentBottom+DrawItems[FirstDrawItem].ExtraSpaceBelow;
    for i := FirstDrawItem+1 to LastDrawItem do begin
      ItemTop := DrawItems[i].Top;
      ItemBottom := ItemTop + DrawItems[i].Height;
      ItemVeryBottom := ItemBottom+DrawItems[i].ExtraSpaceBelow;
      if ItemTop<ContentTop then
        ContentTop := ItemTop;
      if ItemBottom>ContentBottom then
        ContentBottom := ItemBottom;
      if ItemVeryBottom>LineBottomY then
        LineBottomY := ItemVeryBottom;
    end;
    inc(LineBottomY, ExtraSpace);
    if (ContentBottom-ContentTop<RichViewFloatingPlaceHolderHeight) then
      ContentTop := ContentBottom-RichViewFloatingPlaceHolderHeight;
    {
    if ContentBottom-ContentTop>=RichViewFloatingPlaceHolderHeight+3 then begin
      inc(ContentTop, 3);
      dec(ContentBottom, 3);
    end;
    }
    Beginning := True;
    for i := FirstDrawItem to LastDrawItem do
      if DrawItems[i] is TRVFloatingDrawLineInfo then begin
        DrawItems[i].Top := ContentTop;
        DrawItems[i].Height := ContentBottom-ContentTop;
        if not Beginning then // floating items at the beginning of this line are already processed
          FormatAddFloating(Params, sad, i, LineBottomY);
        end
      else
        Beginning := False;
  end;
  {.......................................................}
var i, j, dx, min,max, VCorrection: Integer;
    fl: Boolean;
    dli: TRVDrawLineInfo;
    item: TCustomRVItemInfo;
    SpaceCount, strt: Integer;
    s:  TRVRawByteString;
    ParaNo: Integer;
    RVStyle: TRVStyle;
begin
  ExtraSpace := 0;
  if Params.DontFSL then begin
    Params.DontFSL := False;
    exit;
  end;
  RVStyle := GetRVStyle;
  LineEndX := Params.LineStartX+Params.LineWidth;
  i := Params.LastDrawItem-1;
  if i=-1 then
    exit;
  dli := DrawItems[i];
  item := GetItem(dli.ItemNo);
  if item.GetBoolValue(rvbpFullWidth) then
    exit;
  ParaNo := GetItemParaEx(dli.ItemNo);
  pi := RVStyle.ParaStyles[ParaNo];
  BiDiMode := GetParaBiDiMode(ParaNo);
  Alignment := pi.Alignment;
  if Alignment=rvaJustify then
    case BiDiMode of
      rvbdLeftToRight:
        Alignment := rvaLeft;
      rvbdRightToLeft:
        Alignment := rvaRight;
    end;
  if (Alignment = rvaLeft) or ((Alignment = rvaJustify) and IsParaSectionFinished) then
    dx := 0
  else begin
    dx := LineEndX - (dli.Left+dli.Width);
    if Alignment = rvaCenter then begin
      dx := dx div 2;
      if dx<0 then
        dx := 0;
    end;
  end;

  if Params.NeedRecalcY then
    VCorrection := ProcessVAlign(i)
  else
    VCorrection := 0;

  case pi.LineSpacingType of
    rvlsSpaceBetween:
      if pi.LineSpacing>=0 then
        ExtraSpace := RVStyle.GetAsDevicePixelsY(pi.LineSpacing, @sad);
    rvlsPercent:
      begin
        if (pi.LineSpacing<>100) and (pi.LineSpacing>=50) then begin
          j := i;
          min := 0;
          max := 0;
          fl  := True;
          repeat
            if GetDrawItemStyle(j)>=0 then begin
              if fl or (DrawItems[j].Top<min) then
                min := DrawItems[j].Top;
              if fl or (DrawItems[j].Top+DrawItems[j].Height>max) then
                max := DrawItems[j].Top+DrawItems[j].Height;
              fl := False;
            end;
            dec(j);
          until (j<0) or DrawItems[j+1].FromNewLine;
          if not fl then
            ExtraSpace := (max-min)*(pi.LineSpacing-100) div 100;
        end;
      end;
    rvlsLineHeightAtLeast, rvlsLineHeightExact:
      {if pi.LineSpacing>=0 then} begin
        j := i;
        min := 0;
        max := 0;
        fl := True;
        repeat
          if fl or (DrawItems[j].Top<min) then
            min := DrawItems[j].Top;
          if fl or (DrawItems[j].Top+DrawItems[j].Height>max) then
            max := DrawItems[j].Top+DrawItems[j].Height;
          fl := False;
          dec(j);
        until (j<0) or DrawItems[j+1].FromNewLine;
        ExtraSpace := Params.LineHeightAbove-(Params.BaseLine-min);
        if (pi.LineSpacingType=rvlsLineHeightAtLeast) and (ExtraSpace<0) then
          ExtraSpace := 0;
        if ExtraSpace<>0 then begin
          j := i;
          repeat
            DrawItems[j].ExtraSpaceAbove := ExtraSpace;
            dec(j);
          until (j<0) or DrawItems[j+1].FromNewLine;
        end;
        ExtraSpace := Params.LineHeightBelow-(max-Params.BaseLine);
        if (pi.LineSpacingType=rvlsLineHeightAtLeast) and (ExtraSpace<0) then
          ExtraSpace := 0;        
      end;
  end;
  if ExtraSpace<>0 then begin
    j := i;
    repeat
      DrawItems[j].ExtraSpaceBelow := ExtraSpace;
      dec(j);
    until (j<0) or DrawItems[j+1].FromNewLine;
  end;
  inc(ExtraSpace, VCorrection);
  if (pi.LineSpacingType=rvlsLineHeightExact) or
     ((pi.LineSpacingType=rvlsLineHeightAtLeast) {and (ExtraSpace<0)}) then
    ExtraSpace := 0;
  if (Alignment = rvaJustify) and not IsParaSectionFinished then begin
    if DrawItems[i].FromNewLine then
      exit;
    SpaceCount := 0;
    while (i>=0) and not DrawItems[i].FromNewLine and (GetDrawItemStyle(i)<>rvsTab) do
      with DrawItems[i] do begin
        if (GetItemStyle(ItemNo)>=0) then begin
          s := DrawItems.GetString(i,Items);
          if (System.Length(s)>0) and RVU_IsSpace(s, 1, GetItemOptions(ItemNo)) then
            inc(SpaceCount)
        end;
        dec(i);
      end;
    strt := i+1;
    for i := strt to Params.LastDrawItem-1 do
      with DrawItems[i] do begin
        if (GetItemStyle(ItemNo)>=0) then begin
          s := DrawItems.GetString(i,Items);
          if (System.Length(s)>0) and RVU_IsSpace(s, 1, GetItemOptions(ItemNo)) then begin
            SpaceAtLeft := dx div SpaceCount;
            inc(Width,SpaceAtLeft);
            dec(dx,SpaceAtLeft);
            dec(SpaceCount);
          end;
        end;
        if not FromNewLine then
          Left := DrawItems[i-1].Left+DrawItems[i-1].Width;
      end;
    RearrangeLineEx(Params.LastDrawItem-1);
    if Params.LineHasFloating then
      ProcessFloating(Params.LastDrawItem-1);
    exit;
  end;
  while (i>=0) do begin
    with DrawItems[i] do begin
      inc(Left,dx);
      if FromNewLine then begin
        RearrangeLineEx(Params.LastDrawItem-1);
        if Params.LineHasFloating then
          ProcessFloating(Params.LastDrawItem-1);
        exit;
      end;
    end;
    dec(i);
  end;
  if Params.LineHasFloating then
    ProcessFloating(Params.LastDrawItem-1);
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetFirstItemMarker(var ListNo, Level: Integer): Boolean;
begin
  ListNo := -1;
  Level  := -1;
  Result := False;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetRVDataExtraVOffs: Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
// Indents are returned measured in GetRVStyle.Units
procedure TCustomRVFormattedData.GetIndents(ItemNo: Integer; IsParaSectionStart: Boolean;
  var FirstParaItemNo: Integer; var LeftIndent, RightIndent,
  FirstIndent: Integer {TRVStyleLength});
var RVStyle: TRVStyle;
    item   : TCustomRVItemInfo;
    {$IFNDEF RVDONOTUSELISTS}
    item2  : TCustomRVItemInfo;
    bidimode: TRVBiDiMode;
    ListNo, Level: Integer;
    {$ENDIF}
    pi     : TParaInfo;
    ParaNo, FirstParaSectionItemNo: Integer;
begin
  RVStyle := GetRVStyle;
  item  := GetItem(ItemNo);
  if FirstParaItemNo<0 then
    FirstParaItemNo := GetFirstParaItemEx(ItemNo);
  ParaNo := GetItemPara(FirstParaItemNo);
  {$IFNDEF RVDONOTUSELISTS}
  bidimode := GetParaBiDiMode(ParaNo);
  {$ENDIF}
  pi    := RVStyle.ParaStyles[ParaNo];
  FirstIndent := 0;
  if (rvstFirstParaAborted in State) then begin
    if FirstParaItemNo=GetFirstNonHiddenItemNo then
      IsParaSectionStart := False;
  end;
  if IsParaSectionStart then begin
    {$IFNDEF RVDONOTUSELISTS}
    item2 := GetItem(FirstParaItemNo);
    if (item2.StyleNo=rvsListMarker) and (TRVMarkerItemInfo(item2).GetLevelInfo(RVStyle)<>nil) then
      if bidimode=rvbdRightToLeft then begin
        FirstParaSectionItemNo := GetFirstParaSectionItemEx(ItemNo);
        if not GetItem(FirstParaSectionItemNo).BR then
          RightIndent := TRVMarkerItemInfo(item2).GetLevelInfo(RVStyle).MarkerIndent
        else
          RightIndent := TRVMarkerItemInfo(item2).GetLevelInfo(RVStyle).LeftIndent;
        LeftIndent  := pi.LeftIndent;
        end
      else begin
        FirstParaSectionItemNo := GetFirstParaSectionItemEx(ItemNo);
        if not GetItem(FirstParaSectionItemNo).BR then
          LeftIndent := TRVMarkerItemInfo(item2).GetLevelInfo(RVStyle).MarkerIndent
        else
          LeftIndent := TRVMarkerItemInfo(item2).GetLevelInfo(RVStyle).LeftIndent;
        RightIndent  := pi.RightIndent;
      end
    else
    {$ENDIF}
    begin
      if not item.GetBoolValue(rvbpFullWidth) then begin
        FirstParaSectionItemNo := GetFirstParaSectionItemEx(ItemNo);
        if not GetItem(FirstParaSectionItemNo).BR then
          FirstIndent := pi.FirstIndent;
      end;
      LeftIndent := pi.LeftIndent;
      RightIndent := pi.RightIndent;
    end;
    end
  else begin
    {$IFNDEF RVDONOTUSELISTS}
    item2 := GetItem(FirstParaItemNo);
    if (item2.StyleNo=rvsListMarker) and (TRVMarkerItemInfo(item2).GetLevelInfo(RVStyle)<>nil) then begin
      if bidimode=rvbdRightToLeft then begin
        RightIndent := TRVMarkerItemInfo(item2).GetLevelInfo(RVStyle).LeftIndent;
        LeftIndent  := pi.LeftIndent;
        end
      else begin
        LeftIndent := TRVMarkerItemInfo(item2).GetLevelInfo(RVStyle).LeftIndent;
        RightIndent  := pi.RightIndent;
      end                                
      end
    else if (FirstParaItemNo=GetFirstNonHiddenItemNo) and (rvstFirstParaAborted in State) and
      GetFirstItemMarker(ListNo, Level) then begin
      if bidimode=rvbdRightToLeft then begin
        RightIndent := RVGetLevelInfo(RVStyle, ListNo, Level).LeftIndent;
        LeftIndent  := pi.LeftIndent;
        end
      else begin
        LeftIndent := RVGetLevelInfo(RVStyle, ListNo, Level).LeftIndent;
        RightIndent  := pi.RightIndent;
      end
      end
    else
    {$ENDIF}
    begin
      LeftIndent := pi.LeftIndent;
      RightIndent := pi.RightIndent;
    end;
  end;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSELISTS}
function TCustomRVFormattedData.GetListLevelForItem(ItemNo: Integer): TRVListLevel;
var item   : TCustomRVItemInfo;
    ListNo, Level: Integer;
begin
  ItemNo := GetFirstParaItemEx(ItemNo);
  item := GetItem(ItemNo);
  if (item.StyleNo=rvsListMarker) and (TRVMarkerItemInfo(item).GetLevelInfo(GetRVStyle)<>nil) then
    Result := TRVMarkerItemInfo(item).GetLevelInfo(GetRVStyle)
  else if (ItemNo=GetFirstNonHiddenItemNo) and (rvstFirstParaAborted in State) and GetFirstItemMarker(ListNo, Level) then
    Result := RVGetLevelInfo(GetRVStyle, ListNo, Level)
  else
    Result := nil;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
// Returns the sum of all indents for the paragraph containing the ItemNo-th item.
// (in pixels)
// The sum is returned for the first line or not, depending on where indents are
// greater.
// Let ip(v) returns v, if v>=0; or 0, if v<0.
// For markered LTR paragraphs, this is
//   level.LeftIndent+ip(level.FirstIndent)+para.RightIndent
// For markered LTR paragraphs, this is
//   level.LeftIndent+ip(level.FirstIndent)+para.LeftIndent
// For unmarkered paragraphs, this is
//   para.LeftIndent+para.RightIndent+ip(para.FirstIndent)
// FirstParaItemNo is the index of the first item in this paragraph. On input,
// it may be equal to -1; in this case, it is calculated by this method
function TCustomRVFormattedData.GetMaxIndent(ItemNo: Integer;
  var FirstParaItemNo: Integer; sad: PRVScreenAndDevice): Integer;
var item: TCustomRVItemInfo;
    pi     : TParaInfo;
    {$IFNDEF RVDONOTUSELISTS}
    bidimode: TRVBiDiMode;
    levelinfo: TRVListLevel;
    {$ENDIF}
    ParaNo: Integer;
    RVStyle: TRVStyle;
begin
  RVStyle := GetRVStyle;
  item  := GetItem(ItemNo);
  ParaNo := GetItemParaEx(ItemNo);
  {$IFNDEF RVDONOTUSELISTS}
  bidimode := GetParaBiDiMode(ParaNo);
  {$ENDIF}
  pi    := GetRVStyle.ParaStyles[ParaNo];
  {$IFNDEF RVDONOTUSELISTS}
  if FirstParaItemNo<0 then
    FirstParaItemNo := GetFirstParaItemEx(ItemNo);
  levelinfo := GetListLevelForItem(FirstParaItemNo);
  if levelinfo<>nil then begin
    Result := RVStyle.GetAsDevicePixelsX(levelinfo.LeftIndent, sad);
    if levelinfo.FirstIndent>0 then
      inc(Result, RVStyle.GetAsDevicePixelsX(levelinfo.FirstIndent, sad));
    if bidimode=rvbdRightToLeft then
      inc(Result, RVStyle.GetAsDevicePixelsX(pi.LeftIndent, sad))
    else
      inc(Result, RVStyle.GetAsDevicePixelsX(pi.RightIndent, sad));
    end
  else
  {$ENDIF}
  begin
    Result := RVStyle.GetAsDevicePixelsX(pi.LeftIndent,sad)+
      RVStyle.GetAsDevicePixelsX(pi.RightIndent,sad);
    if (pi.FirstIndent>0) and not item.GetBoolValue(rvbpFullWidth) then
      inc(Result, RVStyle.GetAsDevicePixelsX(pi.FirstIndent,sad));
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.UpdateLastTab(var Params: TRVFormatParams);
var FreeSpace, i, XShift: Integer;
    LastDrawItem, TabDrawItem: TRVDrawLineInfo;
begin
  if Params.LastTabDrawItemNo<0 then
    exit;
  LastDrawItem := DrawItems[Params.LastDrawItem-1];
  TabDrawItem  := DrawItems[Params.LastTabDrawItemNo];
  XShift := Params.x - (LastDrawItem.Left+LastDrawItem.Width);
  if Params.LastTabPosition>Params.LineStartX+Params.LineWidth then
    Params.LastTabPosition := Params.LineStartX+Params.LineWidth;
  case Params.LastTabAlign of
    rvtaRight:
      begin
        FreeSpace := Params.LastTabPosition-(LastDrawItem.Left+LastDrawItem.Width);
      end;
    rvtaCenter:
      begin
        FreeSpace := Params.LastTabPosition+
          (Params.LastTabPosition-TabDrawItem.Left-TabDrawItem.Width)-
          (LastDrawItem.Left+LastDrawItem.Width);
        FreeSpace := FreeSpace div 2;
      end;
    else
      FreeSpace := 0;
  end;
  if FreeSpace<0 then
    FreeSpace := 0;
  if FreeSpace>=0 then
    inc(TabDrawItem.Width, FreeSpace);
  if FreeSpace>=0 then begin
    for i := Params.LastTabDrawItemNo+1 to Params.LastDrawItem-1 do
      inc(DrawItems[i].Left, FreeSpace);
    Params.x := LastDrawItem.Left+LastDrawItem.Width+XShift;
  end;
  Params.LastTabDrawItemNo := -1;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetStandardDrawLineInfoClass(
  item: TCustomRVItemInfo; para: TParaInfo): TRVDrawLineInfoClass;
  {................................................................}
  function GetForStandardLineSpacing: TRVDrawLineInfoClass;
  begin
    if (para.Alignment<>rvaJustify)
      {$IFNDEF RVDONOTUSELISTS}and (item.StyleNo<>rvsListMarker){$ENDIF} then
      Result := TRVDrawLineInfo
    else
      Result := TRVJustifyDrawLineInfo;
  end;
  {................................................................}

begin
  if item.GetBoolValue(rvbpFloating) then begin
    Result := TRVFloatingDrawLineInfo;
    exit;
  end;
  //if para=nil then // commented 16 oct 2010; hidden text support: pi must not be nil
  //  para := GetRVStyle.ParaStyles[item.ParaNo];
  case para.LineSpacingType of
    rvlsLineHeightExact, rvlsLineHeightAtLeast:
      Result := TRVComplexLineHeightDrawLineInfo;
    rvlsPercent:
      if para.LineSpacing=100 then
        Result := GetForStandardLineSpacing
      else
        Result := TRVSimpleLineHeightDrawLineInfo;
    rvlsSpaceBetween:
      if para.LineSpacing=0 then
        Result := GetForStandardLineSpacing
      else
        Result := TRVSimpleLineHeightDrawLineInfo;
    else
      Result := nil;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.FormatLine(const Text, OrigText: TRVRawByteString;
  Len, ItemNo: Integer; Canvas: TCanvas; var sad: TRVScreenAndDevice;
  var Params: TRVFormatParams);
var sourceStrPtr,
    {$IFNDEF RVDONOTUSEUNICODE}
    OrigSourceStrPtr,
    {$ENDIF}
    strForAdd, strSpacePos: PRVAnsiChar;
    sourceStrPtrLen: Integer;
    sz: TSize;
    max,max2,j, y, OldY: Integer;
    dli: TRVDrawLineInfo;
    newline, AtStart, WidthAlreadyReCalculated:Boolean;
    jmpinfo: TRVJumpInfo;
    Offs, ActualStyleNo: Integer;
    pi: TParaInfo;
    SpaceTillTheEndOfLine, ExtraSpaceBelowLine: Integer;
    li: TCustomRVItemInfo;
    RVStyle: TRVStyle;
    {$IFNDEF RVDONOTUSEUNICODE}
    IsUnicodeItem: Boolean;
    {$ENDIF}
  {.......................................................}
  {$IFNDEF RVDONOTUSEUNICODE}
  function AdjustMaxFitR(value: Integer): Integer;
  var PStart, PCur, PCur2: PRVAnsiChar;
  begin
     Result := value;
     PStart := sourceStrPtr;
     // we cannot use CharNextW() because string does not have WideChar(0) at the end
     while True do begin
       if (Result=0) or (Result=sourceStrPtrLen) then
         exit;
       PCur := PStart + (Result+1)*2;
       PCur2 := PRVAnsiChar(CharPrevW(Pointer(PStart), Pointer(PCur)));
       if PCur2=PStart+(Result)*2 then
         exit;
       inc(Result);
     end;
  end;
  {.......................................................}
  function AdjustMaxFitL(value: Integer): Integer;
  var PStart, PCur, PCur2: PRVAnsiChar;
  begin
     Result := value;
     RVU_GetTextExtentPoint32W(Params.FormatCanvas, Pointer(sourceStrPtr), Result,
       sz, RVStyle.GraphicInterface);
     if Params.UseFormatCanvas then begin
       sz.cx := RVConvertFromFormatCanvas(sz.cx, True);
       sz.cy := RVConvertFromFormatCanvas(sz.cy, True);
     end;
     if sz.cx<=SpaceTillTheEndOfLine then
       exit;
     PStart := sourceStrPtr;
     PCur := PStart + (Result-1)*2;
     PCur2 := PRVAnsiChar(CharPrevW(Pointer(PStart), Pointer(PCur)));
     Result := (PCur2-PStart) div 2;
  end;
  {$ENDIF}
  {.......................................................}
  function MaxFitSafe: Integer; // out: sz
  {$IFNDEF RVDONOTUSEUNICODE}
  var r: Integer;
  {$ENDIF}
  var MaxLen: Integer;
  begin
    MaxLen := sourceStrPtrLen;
    if (Params.MaxLength>0) and (Params.MaxLength-Params.TextLength<MaxLen) and
       not ((rvpaoNoWrap in pi.Options) or not Params.AllowWordWrap) then
      MaxLen := Params.MaxLength-Params.TextLength;
    if (rvpaoNoWrap in pi.Options) or not Params.AllowWordWrap then
      Result := MaxLen
    else begin
      RVU_GetTextExtentExPointPC(Params.FormatCanvas, SourceStrPtr, MaxLen,
        RVConvertToFormatCanvas(SpaceTillTheEndOfLine, Params.UseFormatCanvas),
        Result, nil, li.ItemOptions, sz, RVStyle.GraphicInterface);
      if Params.UseFormatCanvas then begin
        sz.cx := RVConvertFromFormatCanvas(sz.cx, True);
        sz.cy := RVConvertFromFormatCanvas(sz.cy, True);
      end;
      {$IFNDEF RVDONOTUSEUNICODE}
      if IsUnicodeItem then begin
        {$IFNDEF RVDONOTUSESOFTHYPHENS}
        if (Result>0) and
          (PRVWordArray(OrigSourceStrPtr)[Result-1]=UNI_SOFT_HYPHEN) and
          (PRVWordArray(SourceStrPtr)[Result-1]=UNI_ZERO_WIDTH_SPACE) then begin
          inc(sz.cx, Params.FontInfoCache[ActualStyleNo].HyphenWidth);
          if sz.cx>SpaceTillTheEndOfLine then
            dec(Result);
        end;
        // we do not allow to break just before the soft hyphen
        if (Result>0) and (Result<sourceStrPtrLen) and
           (PRVWordArray(OrigSourceStrPtr)[Result]=UNI_SOFT_HYPHEN) then
          dec(Result);
        {$ENDIF}
      end;
      if IsUnicodeItem and RVNT then begin
        r := Result;
        Result := AdjustMaxFitR(r);
      end;
      {$ENDIF}
    end;
  end;
  {.......................................................}
  function MaxFitA: Integer; // out: sz
  var maxlo, maxhi, cxlo, cxhi : Integer;
      MaxLen: Integer;
  begin
    MaxLen := sourceStrPtrLen;
    if (Params.MaxLength>0) and (Params.MaxLength-Params.TextLength<MaxLen) and
       not ((rvpaoNoWrap in pi.Options) or not Params.AllowWordWrap) then
      MaxLen := Params.MaxLength-Params.TextLength;
    if RichViewSafeFormatting or
      (not RVNT and ((rvflPrinting in Flags) or Params.UseFormatCanvas)) then begin
      Result := MaxFitSafe;
      exit;
    end;
    { First, find the length of the whole string }
    RVStyle.GraphicInterface.GetTextExtentPoint32_A(Params.FormatCanvas,
      sourceStrPtr, MaxLen, sz);
    if Params.UseFormatCanvas then begin
      sz.cx := RVConvertFromFormatCanvas(sz.cx, True);
      sz.cy := RVConvertFromFormatCanvas(sz.cy, True);
    end;
    if (rvpaoNoWrap in pi.Options) or not Params.AllowWordWrap or
      ((sz.cx <= SpaceTillTheEndOfLine) and (sz.cx>=0)) then
      { it will fit on the line }
      Result := MaxLen
    else begin
      maxlo := 0;
      maxhi := MaxLen;
      cxlo := 0;
      cxhi := sz.cx;
      Result := 0;
      while maxhi > (maxlo + 1) do begin
        { make the best estimate of where max should be }
        if cxhi=cxlo then
          inc(cxhi);
        Result := maxlo + (maxhi - maxlo) * (SpaceTillTheEndOfLine - cxlo) div (cxhi - cxlo);
        if Result <= maxlo then
          Result := maxlo + 1;
        if Result >= maxhi then
          Result := maxhi - 1;
        RVStyle.GraphicInterface.GetTextExtentPoint32_A(Params.FormatCanvas,
          sourceStrPtr,Result,sz);
        if Params.UseFormatCanvas then begin
          sz.cx := RVConvertFromFormatCanvas(sz.cx, True);
          sz.cy := RVConvertFromFormatCanvas(sz.cy, True);
        end;
        { if sz.cx = SpaceTillTheEndOfLine then max is correct }
        if sz.cx = SpaceTillTheEndOfLine then begin
          maxlo := Result;
          maxhi := Result;
          end
        else if (sz.cx < SpaceTillTheEndOfLine) and (sz.cx>0) then begin
          maxlo := Result;
          cxlo := sz.cx;
          end
        else { sz.cx > SpaceTillTheEndOfLine } begin
          maxhi := Result;
          cxhi := sz.cx;
        end;
      end;
      if Result<>maxlo then begin
        RVStyle.GraphicInterface.GetTextExtentPoint32_A(Params.FormatCanvas,
          sourceStrPtr,maxlo,sz);
        if Params.UseFormatCanvas then begin
          sz.cx := RVConvertFromFormatCanvas(sz.cx, True);
          sz.cy := RVConvertFromFormatCanvas(sz.cy, True);
        end;
      end;
      Result := maxlo;
    end
  end;
  {.......................................................}
  {$IFNDEF RVDONOTUSEUNICODE}
  function MaxFitW: Integer; // out: sz
  var maxlo, maxhi, cxlo, cxhi, MaxLen : Integer;
      {$IFNDEF RVDONOTUSESOFTHYPHENS}
      HyphenWidth: Integer;
      {$ENDIF}
  begin
    if RichViewSafeFormatting or
      ({not RVNT and }((rvflPrinting in Flags) or Params.UseFormatCanvas)) then begin
      Result := MaxFitSafe;
      exit;
    end;
    MaxLen := sourceStrPtrLen;
    if (Params.MaxLength>0) and (Params.MaxLength-Params.TextLength<MaxLen) and
      not ((rvpaoNoWrap in pi.Options) or not Params.AllowWordWrap) then
      MaxLen := Params.MaxLength-Params.TextLength;
    {$IFNDEF RVDONOTUSESOFTHYPHENS}
    HyphenWidth := 0;
    {$ENDIF}
    { First, find the length of the whole string }
    RVU_GetTextExtentPoint32W(Params.FormatCanvas, Pointer(sourceStrPtr), MaxLen,
      sz, RVStyle.GraphicInterface);
    if Params.UseFormatCanvas then begin
      sz.cx := RVConvertFromFormatCanvas(sz.cx, True);
      sz.cy := RVConvertFromFormatCanvas(sz.cy, True);
    end;
    if (rvpaoNoWrap in pi.Options) or not Params.AllowWordWrap or
       ((sz.cx <= SpaceTillTheEndOfLine) and (sz.cx>=0)) then
      { it will fit on the line }
      Result := MaxLen
    else begin
      maxlo := 0;
      maxhi := MaxLen;
      cxlo := 0;
      cxhi := sz.cx;
      Result := 0;
      while maxhi > (maxlo + 1) do begin
        { make the best estimate of where max should be }
        if cxhi=cxlo then
          inc(cxhi);
        Result := maxlo + (maxhi - maxlo) * (SpaceTillTheEndOfLine - cxlo) div (cxhi - cxlo);
        if Result <= maxlo then
          Result := maxlo + 1;
        if Result >= maxhi then
          Result := maxhi - 1;
        RVU_GetTextExtentPoint32W(Params.FormatCanvas, Pointer(sourceStrPtr),
          Result, sz, RVStyle.GraphicInterface);
        if Params.UseFormatCanvas then begin
          sz.cx := RVConvertFromFormatCanvas(sz.cx, True);
          sz.cy := RVConvertFromFormatCanvas(sz.cy, True);
        end;
        {$IFNDEF RVDONOTUSESOFTHYPHENS}
        if (PRVWordArray(OrigSourceStrPtr)[Result-1]=UNI_SOFT_HYPHEN) and
           (PRVWordArray(SourceStrPtr)[Result-1]=UNI_ZERO_WIDTH_SPACE) then begin
          if HyphenWidth=0 then
            HyphenWidth := Params.FontInfoCache[ActualStyleNo].HyphenWidth;
          inc(sz.cx,HyphenWidth);
        end;
        {$ENDIF}
        { if sz.cx = SpaceTillTheEndOfLine then max is correct }
        if sz.cx = SpaceTillTheEndOfLine then begin
          maxlo := Result;
          maxhi := Result;
          end
        else if (sz.cx < SpaceTillTheEndOfLine) and (sz.cx>0)  then begin
          maxlo := Result;
          cxlo := sz.cx;
          end
        else { sz.cx > SpaceTillTheEndOfLine } begin
          maxhi := Result;
          cxhi := sz.cx;
        end;
      end;
      {$IFNDEF RVDONOTUSESOFTHYPHENS}
      // we do not allow to break just before the soft hyphen
      if (maxlo>0) and (maxlo<sourceStrPtrLen) and
         (PRVWordArray(OrigSourceStrPtr)[maxlo]=UNI_SOFT_HYPHEN) then
        dec(maxlo);
      {$ENDIF}
      maxhi := Result;
      // Adjusting combined characters
      if RVNT then begin
        Result := AdjustMaxFitR(maxlo);
        if Result<>maxlo then
          Result := AdjustMaxFitL(Result);
        end
      else
        Result := maxlo;
      if maxhi<>maxlo then begin
        RVU_GetTextExtentPoint32W(Params.FormatCanvas, Pointer(sourceStrPtr),
          Result, sz, RVStyle.GraphicInterface);
        if Params.UseFormatCanvas then begin
          sz.cx := RVConvertFromFormatCanvas(sz.cx, True);
          sz.cy := RVConvertFromFormatCanvas(sz.cy, True);
        end;
        {$IFNDEF RVDONOTUSESOFTHYPHENS}
        if (Result>0) and
           (PRVWordArray(OrigSourceStrPtr)[Result-1]=UNI_SOFT_HYPHEN) and
           (PRVWordArray(SourceStrPtr)[Result-1]=UNI_ZERO_WIDTH_SPACE) then begin
          if HyphenWidth=0 then
            HyphenWidth := Params.FontInfoCache[ActualStyleNo].HyphenWidth;
          inc(sz.cx,HyphenWidth);
        end;
        {$ENDIF}
      end;
    end
  end;
  {$ENDIF}
  {.......................................................}
  procedure AdjustLineWidthForFloating(li: TCustomRVItemInfo);
  var OldY: Integer;
  begin
    if Params.FloatingDrawItems<>nil then begin
       OldY := Y;
       inc(Params.LineWidth, Params.FirstIndent);
       inc(Params.LeftIndent, sad.LeftMargin);
       Params.FloatingDrawItems.AdjustLineSize(Params.UnadjustedLeftIndent,
         CalculateMinLineWidth(ItemNo, @sad, {Params.Format}Canvas),
         Params.UnadjustedRightSide,
         Y, Params.LeftIndent, Params.LineWidth, True,
         li.ClearLeft or li.PageBreakBefore,
         li.ClearRight or li.PageBreakBefore,
         Params.FloatingDrawItemsInThisParaSection);
       Params.LastTextStyle := -1;
       dec(Params.LeftIndent, sad.LeftMargin);
       inc(Params.baseline, Y-OldY);
       Params.MovedDownBecauseOfFloating := Y<>OldY;
       end
    else
      Params.MovedDownBecauseOfFloating := False;
    dec(Params.LineWidth, Params.FirstIndent);
    Params.LineStartX := sad.LeftMargin+Params.LeftIndent;
    inc(Params.LineStartX, Params.FirstIndent);
  end;  
  {.......................................................}
  procedure OnStartNewLine(li: TCustomRVItemInfo; wrapping: Boolean);
  var dli: TRVDrawLineInfo;
      SpaceAtEnd: Boolean;
      StyleNo, PrevItemNo: Integer;
  begin
     if not Params.SpaceEaten and wrapping and (Params.LastDrawItem>0) then begin
       dli := DrawItems[Params.LastDrawItem-1];
       StyleNo := GetItemStyle(dli.ItemNo);
       if StyleNo>=0 then begin
        {$IFNDEF RVDONOTUSEUNICODE}
        if rvioUnicode in GetItemOptions(dli.ItemNo) then
          SpaceAtEnd := (dli.Length>0) and
            (PWord(PRVAnsiChar(Items[dli.ItemNo])+(dli.Offs+dli.Length-2)*2)^=ord(' '))
        else
        {$ENDIF}
          SpaceAtEnd := (dli.Length>0) and
            (Items[dli.ItemNo][dli.Offs+dli.Length-1]=' ');
         if SpaceAtEnd and not IsDrawItemFromNewLine(Params.LastDrawItem-1) then begin
           if (dli.Length=1) and (Params.LastDrawItem-2>=0) and
             (dli.ItemNo=DrawItems[Params.LastDrawItem-2].ItemNo) and
             not dli.FromNewLine then begin
             DrawItems.Delete(Params.LastDrawItem-1);
             dec(Params.LastDrawItem);
             end
           else begin
             dec(dli.Length);
             RVStyle.ApplyStyle(Params.FormatCanvas, StyleNo, GetItemBiDiMode(dli.ItemNo),
               rvflCanUseCustomPPI in Flags, nil, False, Params.UseFormatCanvas);
             dli.Width := RVConvertFromFormatCanvas(
               RVU_TextWidth(DrawItems.GetString(Params.LastDrawItem-1, Items),
                 Params.FormatCanvas, GetItemOptions(dli.ItemNo), RVStyle.GraphicInterface),
                 Params.UseFormatCanvas);
             if (GetItemStyle(ItemNo)>=0) and (GetItemStyle(ItemNo)<>StyleNo) then
               RVStyle.ApplyStyle(Params.FormatCanvas, GetItemStyle(ItemNo), GetItemBiDiMode(ItemNo),
                 rvflCanUseCustomPPI in Flags, nil, False, Params.UseFormatCanvas);
           end;
           Params.SpaceEaten := True;
         end;
       end;
     end;
     {$IFNDEF RVDONOTUSESOFTHYPHENS}
     // if the last draw item on the previous (just formed) line is finihed with
     // the soft hyphen, increasing its Width by the hyphen width
     if wrapping and (Params.LastDrawItem-1>=0) and (Params.LastDrawItem-1<DrawItems.Count) and
        (not CanShowSpecialCharacters or not (rvscSoftHyphen in RVVisibleSpecialCharacters))  then begin
       dli := DrawItems[Params.LastDrawItem-1];
       if (rvioUnicode in GetItemOptions(dli.ItemNo)) and (dli.Length>0) and
          (PRVWordArray(PRVAnsiChar(DrawItems.GetString(Params.LastDrawItem-1, Items)))[dli.Length-1]=UNI_SOFT_HYPHEN) then begin
         Params.FontInfoCache.IgnoreParaBiDiMode := True;
         inc(dli.Width, Params.FontInfoCache[GetActualStyle(GetItem(dli.ItemNo))].HyphenWidth);
         Params.FontInfoCache.IgnoreParaBiDiMode := False;
       end;
     end;
     {$ENDIF}
     UpdateLastTab(Params);
     FinishScreenLine(sad, Params.IsParaSectionStart, ExtraSpaceBelowLine, Params);
     pi := RVStyle.ParaStyles[GetItemParaEx(ItemNo)];
     GetIndents(ItemNo, Params.IsParaSectionStart, Params.FirstParaItemNo,
       Params.LeftIndent, Params.RightIndent, Params.FirstIndent);
     Params.LeftIndent  := RVStyle.GetAsDevicePixelsX(Params.LeftIndent, @sad);
     Params.RightIndent := RVStyle.GetAsDevicePixelsX(Params.RightIndent, @sad);
     Params.FirstIndent := RVStyle.GetAsDevicePixelsX(Params.FirstIndent, @sad);
     if Params.FirstParaItemNo<0 then
       Params.FirstParaItemNo := GetFirstParaItemEx(ItemNo);
     if Params.IsParaSectionStart and (ItemNo=Params.FirstParaItemNo) then begin
       PrevItemNo := GetPrevNonHiddenItemNo(Params.FirstParaItemNo);
       if PrevItemNo>=0 then
         inc(Params.prevdesc,
           RVStyle.GetAsDevicePixelsY(RVStyle.ParaStyles[GetItemParaEx(PrevItemNo)].SpaceAfter, @sad));
       inc(Params.prevdesc, RVStyle.GetAsDevicePixelsY(pi.SpaceBefore, @sad));
     end;
     inc(Params.baseline, ExtraSpaceBelowLine);
     y := Params.baseline+Params.prevdesc;
     if (rvpaoNoWrap in pi.Options) or not Params.AllowWordWrap then
       Params.LineWidth := DocumentWidth - (Params.LeftIndent+Params.RightIndent)
     else
       Params.LineWidth := TextWidth - (Params.LeftIndent+Params.RightIndent);
     Params.UnadjustedLeftIndent := sad.LeftMargin+Params.LeftIndent;
     Params.UnadjustedRightSide := sad.LeftMargin+Params.LeftIndent+Params.LineWidth;
     if not wrapping then begin
       Params.FloatingDrawItemsInThisParaSection.Free;
       Params.FloatingDrawItemsInThisParaSection := nil;
     end;
     AdjustLineWidthForFloating(li);
     Params.LineStartY := y;     
     Params.TextLength := 0;
     Params.LineHasFloating := False;
     Params.NeedRecalcY := False;
     if (pi.LineSpacingType in [rvlsLineHeightAtLeast, rvlsLineHeightExact]) {and
        (pi.LineSpacing>0)} then begin
       Params.LineHeightBelow := RVStyle.GetAsDevicePixelsY(pi.LineSpacing, @sad);
       if Params.LineHeightBelow<MINEXACTLINESPACING then
         Params.LineHeightBelow := MINEXACTLINESPACING;
       Params.LineHeightAbove := Round(Params.LineHeightBelow*0.8);
       dec(Params.LineHeightBelow, Params.LineHeightAbove);
     end;
     Params.CanBeFloatingAtTheBeginning := True;
  end;
  {.......................................................}
  procedure AdjustLineHeight(h: Integer);
  begin
    if Params.prevabove < h then begin
      j := Params.LastDrawItem-1;
      if j>=0 then begin
        if pi.LineSpacingType=rvlsLineHeightExact then
          exit;
        repeat
          inc(DrawItems[j].Top,h-Params.prevabove);
          {$IFDEF RVUSEBASELINE}
          inc(DrawItems[j].BaseLine,h-Params.prevabove);
          {$ENDIF}
          dec(j);
        until DrawItems[j+1].FromNewLine;
      end;
      inc(Params.baseline,h-Params.prevabove);
      Params.prevabove := h;
    end;
  end;
  {.......................................................}
  procedure OnNonText(li: TRVRectItemInfo; dli: TRVDrawLineInfo);
  var above, VerticalOffs: Integer;
      i, w,h,desc,hshift: Integer;
      TabLeader: String;
      TabAlign: TRVTabAlign;
      TabPos: Integer;
      Floating: Boolean;
  begin
    hshift := 0;
    if not ShareItems then
      li.Unhiding(Self);
    li.OnDocWidthChange(
      TextWidth -
        (RVStyle.GetAsDevicePixelsX(pi.LeftIndent, @sad)+
         RVStyle.GetAsDevicePixelsX(pi.RightIndent, @sad)+
         RVStyle.GetAsDevicePixelsX(pi.FirstIndent, @sad)),
      dli, rvflPrinting in Flags, Canvas, Self, @sad, hshift, desc, Params.NoCaching,
      Params.Reformatting, Params.UseFormatCanvas);
    if li.GetBoolValue(rvbpDrawingChangesFont) then
      Params.LastTextStyle := -1;
    Floating := li.GetBoolValue(rvbpFloating);
    if Floating then begin
      w := 0;
      h := 1;
      desc := 0;
      end
    else if li.GetBoolValueEx(rvbpActualPrintSize, RVStyle) then begin
      w := dli.Width;
      h := dli.Height;
      end
    else begin
      w := li.GetWidthEx(RVStyle, @sad);
      h := li.GetHeightEx(RVStyle, @sad);
      desc := RV_YToDevice(desc, sad);
    end;
    if li.StyleNo=rvsTab then begin
      UpdateLastTab(Params);
      RVStyle.GetNextTab(li.ParaNo, Params.LineStartX+Params.x, sad, TabPos,
        TabLeader, TabAlign, GetBiDiMode, Params.LeftIndent, Params.RightIndent);
      w := TabPos-(Params.LineStartX+Params.x);
      if Params.x+w<=Params.LineWidth then
        case TabAlign of
          rvtaRight:
            w := 0;
          rvtaCenter:
            begin
              w := w-(Params.LineStartX+Params.LineWidth-TabPos);
              if w<0 then
                w := 0;
            end;
        end;
      dli.Width := w;
    end;
    if Floating then
      VerticalOffs := 0
    else if li.AssociatedTextStyleNo>=0 then
      VerticalOffs := Params.FontInfoCache[li.AssociatedTextStyleNo].VerticalOffset
    else if li.VShiftAbs then
      VerticalOffs := RVStyle.GetAsDevicePixelsY(li.VShift, @sad)
    else
      VerticalOffs := MulDiv(h, li.VShift, 100);
    dli.SetSize(w, h);
    if IsFromNewLineEx(ItemNo) or
      (dli is TRVMultiDrawItemInfo)
      or
      (
        ((Params.x+w > Params.LineWidth) or
         ((Params.MaxLength>0) and (Params.TextLength=Params.MaxLength)))
        and
        not ((rvpaoNoWrap in pi.Options) or not Params.AllowWordWrap)
        {$IFNDEF RVDONOTUSELISTS}
        and not ((ItemNo>0) and (GetItemStyle(ItemNo-1)=rvsListMarker))
        {$ENDIF}
      ) then begin
      if not IsFromNewLineEx(ItemNo) then // was: li.SameAsPrev
        Params.IsParaSectionStart := False;
      OnStartNewLine(li, not Params.IsParaSectionStart);
      dli.FloatingAboveUsed := Params.MovedDownBecauseOfFloating or
        ((Params.FloatingDrawItems<>nil) and (Params.FloatingDrawItems.Count>0));
      dli.FromNewLine := True;
      dli.FromNewPara := IsFromNewLineEx(ItemNo); //IsParaStartEx(ItemNo);
      Params.x :=0;
      case li.VAlign of
        rvvaBaseline, rvvaLeft, rvvaRight:
          Params.prevabove := h-desc;
        rvvaMiddle:
          Params.prevabove := h div 2;
        else
          begin
            Params.NeedRecalcY := True;
            Params.prevabove := 0;
          end;
      end;
      inc(Params.prevabove, VerticalOffs);
      if (pi.LineSpacingType=rvlsLineHeightExact) or
         ((pi.LineSpacingType=rvlsLineHeightAtLeast) and (Params.prevabove<Params.LineHeightAbove)) then begin
        dec(y, Params.prevabove+VerticalOffs);
        Params.prevabove := Params.LineHeightAbove;
        inc(y, Params.prevabove);
      end;
      inc (Params.baseline,Params.prevdesc+Params.prevabove);
      if not (li.VAlign in [rvvaAbsTop, rvvaAbsBottom, rvvaAbsMiddle]) then
        Params.prevdesc := h-Params.prevabove
      else
        Params.prevdesc := 0;
      end
    else begin
      pi := RVStyle.ParaStyles[GetItemParaEx(ItemNo)];
      case li.VAlign of
        rvvaBaseline, rvvaLeft, rvvaRight:
          above := h-desc;
        rvvaMiddle:
          above := h div 2;
        else begin
          Params.NeedRecalcY := True;
          above := 0;
        end;
      end;
      AdjustLineHeight(above+VerticalOffs);
      y := Params.baseline - above-VerticalOffs;
      if not (li.VAlign in [rvvaAbsTop, rvvaAbsBottom, rvvaAbsMiddle]) and
         (Params.prevdesc < (h-above-VerticalOffs)) then
        Params.prevdesc := (h-above-VerticalOffs);
      dli.FromNewLine := False;
      dli.FloatingAboveUsed := DrawItems[Params.LastDrawItem-1].FloatingAboveUsed;
      inc(Params.TextLength);
    end;
    if (pi.LineSpacingType=rvlsLineHeightExact) or
      ((pi.LineSpacingType=rvlsLineHeightAtLeast) and (Params.prevDesc<Params.LineHeightBelow)) then
      Params.prevDesc := Params.LineHeightBelow;
    dli.Left := Params.LineStartX+Params.x+hshift;
    if li.StyleNo=rvsTab then begin
      RVStyle.GetNextTab(GetItemParaEx(ItemNo), dli.Left, sad, TabPos, TabLeader, TabAlign,
        GetBiDiMode, Params.LeftIndent, Params.RightIndent);
      TRVTabItemInfo(li).Leader := TabLeader;
      w := TabPos-dli.Left;
      case TabAlign of
        rvtaRight:
          begin
            w := 0;
            Params.LastTabDrawItemNo := Params.LastDrawItem;
            Params.LastTabAlign := TabAlign;
            Params.LastTabPosition := TabPos;
          end;
        rvtaCenter:
          begin
            w := w-(Params.LineStartX+Params.LineWidth-TabPos);
            if w<0 then
              w := 0;
            Params.LastTabDrawItemNo := Params.LastDrawItem;
            Params.LastTabAlign := TabAlign;
            Params.LastTabPosition := TabPos;
          end;
      end;
      dli.Width := w;
    end;
    inc(Params.x, w+hshift);
    dli.Top :=  y;
    dli.ItemNo := ItemNo;
    dli.SetSize(w, h);
    dli.Offs := 0;
    dli.Length := 0;
    if not ShareItems then
      li.DrawItemNo := Params.LastDrawItem;
    DrawItems.Insert(Params.LastDrawItem, dli);

    if rvflUseJumps in Flags then
      li.BuildJumps(dli.Left, dli.Top, nJmps, jumps);

    //AdjustCP(li);

    if not Floating then
      Params.CanBeFloatingAtTheBeginning := False;
    // processing floating object at the beginning of the line
    // (others will be processed when the line is formed)
    if Floating then begin
      if Params.CanBeFloatingAtTheBeginning then begin
        FormatAddFloating(Params, sad, Params.LastDrawItem, Params.LineStartY);
        AdjustLineWidthForFloating(li);
        dli.Left := Params.LineStartX+Params.x+hshift;
        for i := Params.LastDrawItem downto 0 do begin
          DrawItems[i].Left := dli.Left;
          if DrawItems[i].FromNewLine then
            break;
        end;
      end;
      Params.LineHasFloating := True;
    end;
    inc(Params.LastDrawItem);
  end;
  {.......................................................}
  procedure ApplyFont(li: TCustomRVItemInfo);
  begin
    ActualStyleNo := GetActualStyle(li);
    if ActualStyleNo<>Params.LastTextStyle then begin
      Params.FontInfoCache.LastTextStyle := Params.LastTextStyle;
      Params.FontInfoCache.CurParaBiDiMode := GetParaBiDiMode(GetItemPara(ItemNo));
      with Params.FontInfoCache[ActualStyleNo] do begin
        Params.LastTextStyle := ActualStyleNo;
        Params.TextMetric    := TextMetric;
        Params.VerticalOffs  := VerticalOffset;
        Params.FormatCanvas  := {Params.FontInfoCache[ActualStyleNo].}Canvas;
      end;
      if (RVStyle.TextStyles[ActualStyleNo].CharSpacing<>0) and
        (sad.ppixScreen<>sad.ppixDevice) and
        (GetItemBiDiMode(ItemNo)=rvbdUnspecified) then
        RVStyle.GraphicInterface.SetTextCharacterExtra(Params.FormatCanvas,
          RVStyle.GetAsDevicePixelsX(RVStyle.TextStyles[ActualStyleNo].CharSpacing,
            @sad));
    end;
  end;
  {.......................................................}
  function NextItemsCanBePlacedOnThisLine(CurDrawItemWidth: Integer): Boolean;
  var i,j, offs, RestOfWidth: Integer;
      s: TRVRawByteString;
      ItemOptions: TRVItemOptions;
      sz: TSize;
      TextLength: Integer;
  begin
    Result := True;
    TextLength := 0;
    if Params.MaxLength>0 then
      TextLength := Params.TextLength+sourceStrPtrLen;
    if (rvpaoNoWrap in pi.Options) or not Params.AllowWordWrap then
      exit;
    RestOfWidth := SpaceTillTheEndOfLine-CurDrawItemWidth;
    i := ItemNo;
    GetWrapPlaceAfterItem(i, offs);
    if i<=ItemNo then
      exit;
    if (offs<=GetOffsBeforeItem(i)) then begin
      dec(i);
      offs := GetOffsAfterItem(i);
    end;
    {$IFNDEF RVDONOTUSEUNICODE}
    if (i=ItemNo) and IsUnicodeItem and
       (PRVWordArray(OrigSourceStrPtr)[sourceStrPtrLen-1]=UNI_SOFT_HYPHEN) then begin
      dec(RestOfWidth, Params.FontInfoCache[ActualStyleNo].HyphenWidth);
      if RestOfWidth<0 then begin
        Result := False;
        exit;
      end;
    end;
    {$ENDIF}
    for j := ItemNo+1 to i do begin
      if (j=i) and (offs<=GetOffsBeforeItem(j)) then
        break;
      if IsHidden(j) then
        continue;
      ApplyFont(GetItem(j));
      ItemOptions := GetItemOptions(j);
      s := GetItemTextR(j);
      if j=i then
        s := RVU_Copy(s, 1, offs-1, ItemOptions);
      s := RV_ReturnProcessedString(s,
        RVStyle.TextStyles[Params.LastTextStyle], i=j,
        CanShowSpecialCharacters, False);
      if Params.MaxLength>0 then begin
        inc(TextLength, RVU_Length(s, ItemOptions));
        if TextLength>Params.MaxLength then begin
          Result := False;
          ApplyFont(li);
          exit;
        end;
      end;
      if s<>'' then begin
        {$IFNDEF RVDONOTUSEUNICODE}
        if rvioUnicode in ItemOptions then
          RVU_GetTextExtentPoint32W(Params.FormatCanvas, Pointer(s), Length(s) div 2,
            sz, RVStyle.GraphicInterface)
        else
        {$ENDIF}
          RVStyle.GraphicInterface.GetTextExtentPoint32_A(Params.FormatCanvas,
            Pointer(s),Length(s),sz);
        if Params.UseFormatCanvas then begin
          sz.cx := RVConvertFromFormatCanvas(sz.cx, True);
          sz.cy := RVConvertFromFormatCanvas(sz.cy, True);
        end;
        dec(RestOfWidth, sz.cx);
        if RestOfWidth<0 then begin
          Result := False;
          ApplyFont(li);
          exit;
        end;
      end;
    end;
    ApplyFont(li);
  end;
  {.......................................................}
  function AllowSplitBefore: Boolean;
  var i, PrevItemNo, offs: Integer;
  begin
    Result := True;
    if (RVStyle.LineWrapMode<>rvWrapNormal) or (ItemNo=0) or
      IsFromNewLineEx(ItemNo) then
      exit;
    i := GetPrevNonHiddenItemNo(ItemNo);
    if (i<0) or (GetItemStyle(i)<0) then
      exit;
    PrevItemNo := i;
    GetWrapPlaceAfterItem(i, offs);
    Result := (i=PrevItemNo) or ((i=ItemNo) and (Offs<=GetOffsBeforeItem(ItemNo)));
  end;
  {.......................................................}
  function GetLengthDecrement: Integer;
  {$IFNDEF RVDONOTUSEUNICODE}
  var i: Integer;
      PStr: PRVWordArray;
  {$ENDIF}
  begin
   {$IFNDEF RVDONOTUSEUNICODE}
    if IsUnicodeItem then begin
      PStr := PRVWordArray(SourceStrPtr);
      Result := 0;
      for i := sourceStrPtrLen-1 downto 0 do
        if PStr[i]=UNI_Space then
          inc(Result)
        else
          break;
      inc(Result);
      if (Result>sourceStrPtrLen) then
        Result := 1;
      end
    else
    {$ENDIF}
      Result := 1;
  end;
  {.......................................................}
  procedure CalculateStringSize(Str: PRVAnsiChar; Length: Integer); // out: cx
  begin
    {$IFNDEF RVDONOTUSEUNICODE}
    if IsUnicodeItem then
      RVU_GetTextExtentPoint32W(Params.FormatCanvas, Pointer(Str), Length, sz,
        RVStyle.GraphicInterface)
    else
    {$ENDIF}
      RVStyle.GraphicInterface.GetTextExtentPoint32_A(Params.FormatCanvas,
        Str, Length ,sz);
    if Params.UseFormatCanvas then begin
      sz.cx := RVConvertFromFormatCanvas(sz.cx, True);
      sz.cy := RVConvertFromFormatCanvas(sz.cy, True);
    end;
  end;
  {.......................................................}
  procedure AddTextDrawItem(Offs, Length: Integer);
  var dli: TRVDrawLineInfo;
  begin
    dli := GetStandardDrawLineInfoClass(li, pi).Create;
    dli.ItemNo := ItemNo;
    dli.Offs := Offs;
    if not newline then begin {continue line}
      AdjustLineHeight(Params.TextMetric.tmAscent+Params.VerticalOffs);
      y := Params.baseline - (Params.TextMetric.tmAscent+Params.VerticalOffs);
      dli.FromNewLine := False;
      dli.FloatingAboveUsed := DrawItems[Params.LastDrawItem-1].FloatingAboveUsed;
      end
    else  begin { new line }
      dli.FromNewLine := True;
      dli.FromNewPara := (Offs<=1) and IsFromNewLineEx(ItemNo); //IsParaStartEx(ItemNo);
      dli.FloatingAboveUsed := Params.MovedDownBecauseOfFloating or
        ((Params.FloatingDrawItems<>nil) and (Params.FloatingDrawItems.Count>0));
      Params.x :=0;
      Params.prevabove := Params.TextMetric.tmAscent+Params.VerticalOffs;
      if (pi.LineSpacingType=rvlsLineHeightExact) or
       ((pi.LineSpacingType=rvlsLineHeightAtLeast) and (Params.prevabove<Params.LineHeightAbove)) then begin
        Params.prevabove := Params.LineHeightAbove;
        y := Params.baseline + (Params.prevDesc+Params.prevabove) -
          (Params.TextMetric.tmAscent+Params.VerticalOffs);
       end;
      inc(Params.baseline, Params.prevDesc+Params.prevabove);
    end;
    dli.Left   :=Params.LineStartX+Params.x;
    dli.Top    := y;
    {$IFDEF RVUSEBASELINE}
    dli.BaseLine := Params.baseline-Params.VerticalOffs;
    {$ENDIF}
    dli.Width  := sz.cx;
    dli.Height := sz.cy;
    dli.Length := Length;
    inc(Params.TextLength, Length);
    DrawItems.Insert(Params.LastDrawItem, dli);
    if AtStart and not ShareItems then
      li.DrawItemNo := Params.LastDrawItem;
    inc(Params.LastDrawItem);
    if (rvflUseJumps in Flags) and RVStyle.TextStyles[ActualStyleNo].Jump then begin
      jmpinfo := TRVJumpInfo.Create;
      jmpinfo.w := sz.cx;
      jmpinfo.h := sz.cy;
      jmpinfo.id := nJmps;
      jmpinfo.DrawItemNo := Params.LastDrawItem-1;
      jmpinfo.Cursor := RVStyle.TextStyles[ActualStyleNo].JumpCursor;
      jmpinfo.RVData := Self;
      jumps.Add(jmpinfo);
    end;
    if newline or (Params.prevDesc < Params.TextMetric.tmDescent-Params.VerticalOffs) then
       Params.prevDesc := Params.TextMetric.tmDescent-Params.VerticalOffs;
    if (pi.LineSpacingType=rvlsLineHeightExact) or
      ((pi.LineSpacingType=rvlsLineHeightAtLeast) and (Params.prevDesc<Params.LineHeightBelow)) then
      Params.prevDesc := Params.LineHeightBelow;
    inc(Params.x,sz.cx);
  end;
  {.......................................................}
  procedure AddTextDrawItemsWordByWord(Offs, Length: Integer);
  var SpacePos, TmpStr: PRVAnsiChar;
      FirstTime: Boolean;
      WordLen: Integer;
  begin
    FirstTime := True;
    while Length>0 do begin
      TmpStr := StrForAdd;
      {$IFNDEF RVDONOTUSEUNICODE}
      if IsUnicodeItem then begin
        if (PWord(TmpStr)^ = UNI_SPACE) then
          inc(PRVAnsiChar(TmpStr), 2);
        SpacePos := RVU_StrScanW(TmpStr, UNI_SPACE, Length)
        end
      else
      {$ENDIF}
      begin
        if (TmpStr^ = ' ') then
          inc(TmpStr);
        SpacePos := StrScan(TmpStr, ' ');
      end;
      if SpacePos=nil then begin
        if FirstTime then begin
          // this line has no spaces (except for, may be, leading space)
          if not WidthAlreadyReCalculated and
            (((max<>max2) or (rvpaoNoWrap in pi.Options) or not Params.AllowWordWrap)) then
            CalculateStringSize(strForAdd, max);
          AddTextDrawItem(Offs, Length);
          exit;
        end;
        WordLen := Length;
        end
      else begin
        WordLen := SpacePos-StrForAdd;
        {$IFNDEF RVDONOTUSEUNICODE}
        if IsUnicodeItem then
          WordLen := WordLen div 2;
        {$ENDIF}
        if WordLen>Length then
          WordLen := Length;
      end;
      CalculateStringSize(strForAdd, WordLen);
      AddTextDrawItem(Offs, WordLen);
      inc(offs, WordLen);            
      inc(StrForAdd, WordLen);
      {$IFNDEF RVDONOTUSEUNICODE}
      if IsUnicodeItem then
        inc(StrForAdd, WordLen);
      {$ENDIF}
      dec(Length, WordLen);
      FirstTime := False;
      newline := False;
      AtStart := False;
    end;
  end;
  {.......................................................}
var HShift, Desc: Integer;
    NextItemsCanBePlacedOnLine, LengthDecremented: Boolean;
begin
  HShift := 0;
  Desc   := 0;
  RVStyle := GetRVStyle;
  li := GetItem(ItemNo);
  pi := RVStyle.ParaStyles[GetItemParaEx(ItemNo)];
  if IsFromNewLineEx(ItemNo) then begin // not li.SameAsPrev
    Params.IsParaSectionStart := True;
    Params.SpaceEaten := False;
  end;
  {
  if LineWidth<0 then
    OnStartNewLine(not li.BR, li);
  }
  if li.StyleNo<0 then begin
    if li is TRVRectItemInfo then begin
      // rvsComponent, rvsHotspot, rvsBullet, rvsPicture:
      if rvflAllowCustomDrawItems in Flags then
        dli := li.CreatePrintingDrawItem(Self, pi, sad)
      else
        dli := GetStandardDrawLineInfoClass(li, pi).Create;
      OnNonText(TRVRectItemInfo(li), dli);
      if li.GetBoolValue(rvbpDrawingChangesFont) then
        Params.LastTextStyle := -1;
      if li.GetBoolValueEx(rvbpJump, RVStyle) then begin
        if rvflUseJumps in Flags then begin
          jmpinfo     := TRVJumpInfo.Create;
          jmpinfo.w   := dli.ObjectWidth;
          jmpinfo.h   := dli.ObjectHeight;
          jmpinfo.id  := nJmps;
          jmpinfo.DrawItemNo := Params.LastDrawItem-1;
          jmpinfo.Cursor := li.GetHypertextCursor(RVStyle);
          jmpinfo.RVData := Self;
          jumps.Add(jmpinfo);
        end;
        GetItem(ItemNo).JumpID := nJmps;
        inc(nJmps);
      end;
      end
    else begin
      UpdateLastTab(Params);
      FinishScreenLine(sad, True, ExtraSpaceBelowLine, Params);
      Params.FloatingDrawItemsInThisParaSection.Free;
      Params.FloatingDrawItemsInThisParaSection := nil;
      inc(Params.baseline, ExtraSpaceBelowLine);
      if ItemNo>0 then
        inc(Params.prevdesc,
          RVStyle.GetAsDevicePixelsY(RVStyle.ParaStyles[GetItemParaEx(ItemNo-1)].SpaceAfter, @sad));
      if li.GetBoolValue(rvbpIgnorePara) then begin
        inc(Params.prevdesc,
          RVStyle.GetAsDevicePixelsY(RVStyle.ParaStyles[0].SpaceBefore, @sad));
        Params.LeftIndent := 0;
        Params.RightIndent := 0;
        end
      else begin
        inc(Params.prevdesc,
          RVStyle.GetAsDevicePixelsY(RVStyle.ParaStyles[GetItemParaEx(ItemNo)].SpaceBefore, @sad));
        Params.LeftIndent := RVStyle.GetAsDevicePixelsX(pi.LeftIndent, @sad);
        Params.RightIndent := RVStyle.GetAsDevicePixelsX(pi.RightIndent, @sad);
      end;
      y := Params.baseline+Params.prevdesc;
      Params.LineWidth := TextWidth - (Params.LeftIndent+Params.RightIndent);
      inc(Params.LeftIndent, sad.LeftMargin);
      Params.UnadjustedLeftIndent := Params.LeftIndent;
      Params.UnadjustedRightSide := Params.LeftIndent+Params.LineWidth;      
      OldY := Y;
      if Params.FloatingDrawItems<>nil then begin
        Params.FloatingDrawItems.AdjustLineSize(Params.UnadjustedLeftIndent,
          CalculateMinLineWidth(ItemNo, @sad, {Params.Format}Canvas),
          Params.UnadjustedRightSide,
          y, Params.LeftIndent, Params.LineWidth, True,
          li.ClearLeft or li.PageBreakBefore,
          li.ClearRight or li.PageBreakBefore,
          Params.FloatingDrawItemsInThisParaSection);
        Params.LastTextStyle := -1;
      end;
      dec(Params.LeftIndent, sad.LeftMargin);
      Params.LineStartX := sad.LeftMargin+Params.LeftIndent;
      if rvflAllowCustomDrawItems in Flags then
        dli := li.CreatePrintingDrawItem(Self, pi, sad)
      else
        dli := GetStandardDrawLineInfoClass(li, pi).Create;

      //if li.StyleNo=rvsBreak then
      //  dli := GetStandardDrawLineInfoClass(li, pi).CreateEx(Params.LineStartX,
      //    y, Params.LineWidth, y5+y5+1, ItemNo, True)
      //else begin

      if not ShareItems then
        li.Unhiding(Self);
      li.OnDocWidthChange(Params.LineWidth, dli, rvflPrinting in Flags,
        Canvas, Self, @sad, HShift, Desc, Params.NoCaching,
        Params.Reformatting, Params.UseFormatCanvas);
      if li.GetBoolValue(rvbpDrawingChangesFont) then
        Params.LastTextStyle := -1;
      if not li.GetBoolValueEx(rvbpActualPrintSize, RVStyle) then
        dli.SetSize(
          TRVFullLineItemInfo(li).GetWidthEx(RVStyle, @sad),
          TRVFullLineItemInfo(li).GetHeightEx(RVStyle, @sad));
      if not li.GetBoolValue(rvbpIgnorePara) then
        case pi.Alignment of
          rvaRight:
            inc(Params.LineStartX, Params.LineWidth-dli.Width);
          rvaCenter:
            begin
              inc(Params.LineStartX, (Params.LineWidth-dli.Width) div 2);
              if Params.LineStartX<0 then
                Params.LineStartX := 0;
            end;
        end
      else begin
        inc(Params.LineStartX, (Params.LineWidth-dli.Width) div 2);
        if Params.LineStartX<0 then
          Params.LineStartX := 0;
      end;
      dli.SetData(Params.LineStartX+HShift, y, ItemNo,True);

      dli.FloatingAboveUsed := (Y<>OldY) or
        ((Params.FloatingDrawItems<>nil) and (Params.FloatingDrawItems.Count>0));
      if not ShareItems then
        li.DrawItemNo := Params.LastDrawItem;
      DrawItems.Insert(Params.LastDrawItem, dli);

      if rvflUseJumps in Flags then
        li.BuildJumps(dli.Left, dli.Top, nJmps, jumps);

      //AdjustCP(li);
      inc(Params.LastDrawItem);
      //if li.StyleNo=rvsBreak then begin
      //  inc (Params.baseline,Params.prevdesc+y5+1);
      //  Params.prevdesc  := y5;
      //  Params.prevabove := y5;
      //  end
      //else begin
        inc (Params.baseline,Params.prevdesc+dli.Height+Y-OldY);
        Params.prevabove := dli.Height;
        Params.prevdesc  := 0;
      //end;
      end
      end
  else begin // text
     {$IFNDEF RVDONOTUSEUNICODE}
     IsUnicodeItem := rvioUnicode in li.ItemOptions;
     if IsUnicodeItem then begin
       sourceStrPtr := PRVAnsiChar(Text);
       OrigSourceStrPtr := PRVAnsiChar(OrigText);
       end
     else
     {$ENDIF}
     begin
       sourceStrPtr := PRVAnsiChar(Text);
       {$IFNDEF RVDONOTUSEUNICODE}
       OrigSourceStrPtr := PRVAnsiChar(OrigText);
       {$ENDIF}
     end;
     sourceStrPtrLen := Len;
     ApplyFont(li);
     AtStart := True;
     if sourceStrPtrLen=0 then begin {empty string}
       sz.cy := Params.FontInfoCache[ActualStyleNo].EmptyLineHeight;
       sz.cx := 0;
       if IsFromNewLineEx(ItemNo) then begin
         OnStartNewLine(li, False);
         if Params.LastTextStyle<0 then
           ApplyFont(li);
         Params.x :=0;
         Params.prevabove := Params.TextMetric.tmAscent+Params.VerticalOffs;
         if (pi.LineSpacingType=rvlsLineHeightExact) or
           ((pi.LineSpacingType=rvlsLineHeightAtLeast) and (Params.prevabove<Params.LineHeightAbove)) then begin
           Params.prevabove := Params.LineHeightAbove;
           y := Params.baseline + (Params.prevDesc+Params.prevabove) -
             (Params.TextMetric.tmAscent+Params.VerticalOffs);
         end;
         inc(Params.baseline, Params.prevDesc+Params.prevabove);
         Params.prevDesc := Params.TextMetric.tmDescent-Params.VerticalOffs;
         end
       else begin
         AdjustLineHeight(Params.TextMetric.tmAscent+Params.VerticalOffs);
         y := Params.baseline - (Params.TextMetric.tmAscent+Params.VerticalOffs);
         if Params.prevDesc < Params.TextMetric.tmDescent-Params.VerticalOffs then
           Params.prevDesc := Params.TextMetric.tmDescent-Params.VerticalOffs;
       end;
       Params.CanBeFloatingAtTheBeginning := False;
       if (pi.LineSpacingType=rvlsLineHeightExact) or
         ((pi.LineSpacingType=rvlsLineHeightAtLeast) and (Params.prevDesc<Params.LineHeightBelow)) then
         Params.prevDesc := Params.LineHeightBelow;
       dli := GetStandardDrawLineInfoClass(li, pi).CreateEx(
         Params.LineStartX+Params.x, y, sz.cx, sz.cy, ItemNo, IsFromNewLineEx(ItemNo));
       if dli.FromNewLine then
         dli.FloatingAboveUsed := Params.MovedDownBecauseOfFloating or
           ((Params.FloatingDrawItems<>nil) and (Params.FloatingDrawItems.Count>0))
       else
         dli.FloatingAboveUsed := DrawItems[Params.LastDrawItem-1].FloatingAboveUsed;
       {$IFDEF RVUSEBASELINE}
       dli.BaseLine := Params.baseline-Params.VerticalOffs;
       {$ENDIF}
       dli.Offs := 1;
       inc(Params.x, sz.cx);
       if RVStyle.TextStyles[ActualStyleNo].Jump then
         GetItem(ItemNo).JumpID := -3;
       dli.Length := 0;
       if AtStart and not ShareItems then
         li.DrawItemNo := Params.LastDrawItem;
       DrawItems.Insert(Params.LastDrawItem, dli);
       //AdjustCP(li);
       inc(Params.LastDrawItem);
       exit;
     end;
     newline := AtStart and IsFromNewLineEx(ItemNo);
     NextItemsCanBePlacedOnLine := True;
     while sourceStrPtrLen>0 do begin
       if newline and NextItemsCanBePlacedOnLine then begin
         // placing this text on a new line
         OnStartNewLine(li, not Params.IsParaSectionStart);
         if Params.LastTextStyle<0 then
           ApplyFont(li);
         Params.x:=0;
         // if possible, "eating" the space at the beginning of the line
         if (rvflTrim in Flags) and not Params.SpaceEaten and
            not Params.IsParaSectionStart and (sourceStrPtrLen>1) then
           {$IFNDEF RVDONOTUSEUNICODE}
           if IsUnicodeItem then begin
             if PWord(sourceStrPtr)^=ord(' ') then begin
               inc(sourceStrPtr,2);
               inc(OrigSourceStrPtr, 2);
               dec(sourceStrPtrLen);
             end;
             end
           else
           {$ENDIF}
           if sourceStrPtr^=' ' then begin
             inc(sourceStrPtr);
             {$IFNDEF RVDONOTUSEUNICODE}
             inc(OrigSourceStrPtr);
             {$ENDIF}
             dec(sourceStrPtrLen);
           end;
         Params.SpaceEaten := False;
       end;
       Params.CanBeFloatingAtTheBeginning := False;
       SpaceTillTheEndOfLine := Params.LineWidth-Params.x;
       if SpaceTillTheEndOfLine<0 then
         SpaceTillTheEndOfLine := 0;
       LengthDecremented := False;
       // calculating how many characters can be placed on this line
       if (Params.MaxLength>0) and (Params.TextLength>=Params.MaxLength) and
         not ((rvpaoNoWrap in pi.Options) or not Params.AllowWordWrap) then
         // Here we can place nothing because of MaxLength limitation
         max := 0
       else if not NextItemsCanBePlacedOnLine then begin
         // We are here because this text can be placed on this line,
         // but it should be placed together with the subsequent item(s),
         // and it cannot.
         // Here we place as much characters as possible, but not all
         // (we decrease text length by 1+count of spaces at the end)
         max := sourceStrPtrLen-GetLengthDecrement;
         LengthDecremented := max<sourceStrPtrLen;
         if (Params.MaxLength>0) and (Params.MaxLength-Params.TextLength<max) then begin
           LengthDecremented := sourceStrPtrLen >= Params.MaxLength-Params.TextLength;
           max := Params.MaxLength-Params.TextLength;
         end;
         end
       else begin
         // The most normal case: finding the maximal count of characters that
         // fit in the line width
         {$IFNDEF RVDONOTUSEUNICODE}
         if IsUnicodeItem then
           max := MaxFitW
         else
         {$ENDIF}
           max := MaxFitA;
       end;
       max2 := max;
       {sourceStrPtr2 := sourceStrPtr;}
       if max=0 then // if we cannot place this text on the line at all
         if newline  // if we cannot move this text to the new line
         {$IFNDEF RVDONOTUSELISTS}
         or (AtStart and (ItemNo>0) and (GetItemStyle(ItemNo-1)=rvsListMarker))
         {$ENDIF}
          then begin
            // if this item cannot be placed on this line by itself,
            // placing the minimal possible count of characters
            if not LengthDecremented then begin
               max := 1;
               {$IFNDEF RVDONOTUSEUNICODE}
               if RVNT and IsUnicodeItem then
                 max := AdjustMaxFitR(max);
               {$ENDIF}
            end;
            // if this item cannot be placed on this line because of subsequent
            // items, we do nothing. Later, this situation will be processed
            // by the code marked {**} (the whole item will be placed on the line)
           end
         else begin
           // moving this item to the new line
           Params.x:=0;
           Params.IsParaSectionStart := False;
           newline := true;
           NextItemsCanBePlacedOnLine := True;
           continue;
         end;
       if (max<sourceStrPtrLen) and (RVStyle.LineWrapMode<>rvWrapAnywhere) then begin // if the rest of item cannot be placed on the line completely
           // trying to find better position for wrapping, i.e.
           // searching where to split string, no more than max characters + (possible space char)
           {$IFNDEF RVDONOTUSEUNICODE}
           if IsUnicodeItem then begin
             strSpacePos := RVU_FindLineBreak(PRVWordArray(OrigSourceStrPtr), max,
               max+1=sourceStrPtrLen, not NextItemsCanBePlacedOnLine); // MyStrRScanW(sourceStrPtr,' ',max)
             if (strSpacePos<>nil) then
               strSpacePos := sourceStrPtr + (strSpacePos-OrigSourceStrPtr);
             end
           else
           {$ENDIF}
           begin
             if max+1=sourceStrPtrLen then
               strSpacePos := MyStrRScanA(sourceStrPtr,' ',max)
             else
               strSpacePos := MyStrRScanA(sourceStrPtr,' ',max+1);
           end;
           // probably the space character is right after max;
           // if yes, we include it in the string for this line
           // this space will be "eaten" later
           if (strSpacePos=nil) and (rvflTrim in Flags) and not LengthDecremented and
              ((max+1<sourceStrPtrLen) or not IsLastParaSectionItemEx(ItemNo))
             then begin
             {$IFNDEF RVDONOTUSEUNICODE}
             if IsUnicodeItem then begin
               if PRVWordArray(sourceStrPtr)[max]=UNI_Space then begin
                 strSpacePos := sourceStrPtr+max*2;
                 inc(max);
               end;
               end
             else
             {$ENDIF}
             begin
               if sourceStrPtr[max]=' ' then begin
                 strSpacePos := sourceStrPtr+max;
                 inc(max);
               end;
             end;
           end;
           if strSpacePos<>nil then begin  // if this item can be split...
             {if not LengthDecremented then begin // if this length of this item was not
                                          // decreased because it cannot be placed together with
                                          // the subsequent text items
             }
               // if split on space, "eating" this space
               {$IFNDEF RVDONOTUSEUNICODE}
               if IsUnicodeItem then begin
                 if (rvflTrim in Flags) and (PRVWordArray(strSpacePos)[0]=UNI_Space) and
                   (strSpacePos<>sourceStrPtr) then begin
                   max := (strSpacePos-sourceStrPtr) div 2;
                   Params.SpaceEaten := True;
                   end
                 else
                   max := (strSpacePos-sourceStrPtr) div 2+1;
                 end
               else
               {$ENDIF}
               begin
                 if (rvflTrim in Flags) and (strSpacePos<>sourceStrPtr) then begin
                   max := strSpacePos-sourceStrPtr;
                   Params.SpaceEaten := True;
                   end
                 else
                   max := strSpacePos-sourceStrPtr+1;
               end;
            // end;
             end
           else if not (newline // if the item cannot be split, and if we can move it
                                // to the new line
           {$IFNDEF RVDONOTUSELISTS}
           or (AtStart and (ItemNo>0) and (GetItemStyle(ItemNo-1)=rvsListMarker))
           {$ENDIF}
           )
           then begin
             if not AllowSplitBefore then begin // If splitting before this item is not recommended...
               // At this point, we realize that there is no good place to split this text {*}
               if LengthDecremented then // If this text can be placed completely,
                                         // but the subsequent item(s) cannot,
                 max := sourceStrPtrLen // then we place it completely;
                   // line break will be in next items (in not a good place
                   // as well, but in this situation we should place on this
                   // line as much text as possible).
                   // Othwerwise, this item will be split (not in a good place,
                   // but as close to the end as possiblem to place
                   // as much text as possible on the line)
               end
             else begin
               // Moving this item to the new line
               Params.IsParaSectionStart := False;
               newline := True;
               NextItemsCanBePlacedOnLine := True;
               continue;
             end;
             end
           else // {**} if the item cannot be split, and if we cannot move it
                // to the new line, then the same situation as {*} above
             if LengthDecremented then
               max := sourceStrPtrLen;
       end;
       WidthAlreadyReCalculated := False;
       if NextItemsCanBePlacedOnLine and
         (RVStyle.LineWrapMode=rvWrapNormal) and
         (max>0) and
         not (rvpaoNoWrap in pi.Options) and Params.AllowWordWrap and
         ((Params.SpaceEaten and (sourceStrPtrLen+1=max)) or
          (not Params.SpaceEaten and (sourceStrPtrLen=max))) then begin
         if (max<>max2) then begin
           CalculateStringSize(sourceStrPtr, max);
           WidthAlreadyReCalculated := True;
         end;
         // checking if the text can be placed on the line together with the next items
         NextItemsCanBePlacedOnLine := NextItemsCanBePlacedOnThisLine(sz.cx);
         if not NextItemsCanBePlacedOnLine then
           continue;
       end;
       NextItemsCanBePlacedOnLine := True;
       {$IFNDEF RVDONOTUSEUNICODE}
       if IsUnicodeItem then begin
         Offs := (sourceStrPtr - PRVAnsiChar(Text)) div 2+1;
         StrForAdd := sourceStrPtr;
         inc(sourceStrPtr,max*2);
         inc(OrigSourceStrPtr, max*2);
         dec(sourceStrPtrLen,max);
         if Params.SpaceEaten then begin
           inc(sourceStrPtr, 2);
           inc(OrigSourceStrPtr, 2);
           dec(sourceStrPtrLen);
           //Params.SpaceEaten := sourceStrPtrLen=0;
         end;
         end
       else
       {$ENDIF}
       begin
         Offs := sourceStrPtr - PRVAnsiChar(Text)+1;
         StrForAdd := sourceStrPtr;
         inc(sourceStrPtr,max);
         {$IFNDEF RVDONOTUSEUNICODE}
         inc(OrigSourceStrPtr,max);
         {$ENDIF}
         dec(sourceStrPtrLen,max);
         if Params.SpaceEaten then begin
           inc(sourceStrPtr);
           {$IFNDEF RVDONOTUSEUNICODE}
           inc(OrigsourceStrPtr);
           {$ENDIF}
           dec(sourceStrPtrLen);
           //Params.SpaceEaten := sourceStrPtrLen=0;
         end;
       end;
       if (newline or (max<>0)) then begin
         if pi.Alignment<>rvaJustify then begin
           if not WidthAlreadyReCalculated and
             (((max<>max2) or (rvpaoNoWrap in pi.Options) or not Params.AllowWordWrap)) then
             CalculateStringSize(strForAdd, max);
           AddTextDrawItem(Offs, max);
           end
         else begin
           AddTextDrawItemsWordByWord(Offs, max);
         end;
         newline := True;
         Params.IsParaSectionStart := False;
         AtStart := False;
         end
       else
         newline := true;
     end; { while }
     if RVStyle.TextStyles[ActualStyleNo].Jump then begin
       GetItem(ItemNo).JumpID := nJmps;
       inc(nJmps);
     end;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetHOffs: Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetVOffs: Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.Format(NoCaching: Boolean);
begin
  Format_(False, True, False, 0, GetFormatCanvas, False, NoCaching, False, False);
end;
{------------------------------------------------------------------------------}
{ Changes drawing item's width and adjusts positions of other drawing items
  in the same line }
procedure TCustomRVFormattedData.ChangeDItemWidth(DItemNo, NewWidth: Integer);
var i, dx, ParaNo: Integer;
  StartDItemNo, EndDItemNo, SpaceCount, dx2, dl, DeltaSpaceAtLeft: Integer;
  s: TRVRawByteString;
  Alignment: TRVAlignment;
begin
  dx := NewWidth-DrawItems[DItemNo].Width;
  DrawItems[DItemNo].Width := NewWidth;
  if dx=0 then
    exit;
  ParaNo := GetItemParaEx(DrawItems[DItemNo].ItemNo);
  Alignment := GetRVStyle.ParaStyles[ParaNo].Alignment;
  if Alignment=rvaJustify then
    case GetParaBiDiMode(ParaNo) of
      rvbdLeftToRight:
        Alignment := rvaLeft;
      rvbdRightToLeft:
        Alignment := rvaRight;
    end;
  case Alignment of
    rvaLeft, rvaCenter:
      for i := DItemNo+1 to DrawItems.Count-1 do begin
        if DrawItems[i].FromNewLine then
          break;
        inc(DrawItems[i].Left, dx);
      end;
    rvaRight:
      for i := DItemNo downto 0 do begin
        dec(DrawItems[i].Left, dx);
        if DrawItems[i].FromNewLine then
          break;
      end;
    rvaJustify:
      begin
        StartDItemNo := 0;
        EndDItemNo := DrawItems.Count-1;
        for i := DItemNo downto 0 do
          if DrawItems[i].FromNewLine then begin
            StartDItemNo := i;
            break;
          end;
        for i := DItemNo+1 to DrawItems.Count-1 do
          if DrawItems[i].FromNewLine then begin
            EndDItemNo := i-1;
            break;
          end;
        SpaceCount := 0;
        for i := StartDItemNo to EndDItemNo do
          with DrawItems[i] do
            if (GetItemStyle(ItemNo)>=0) then begin
              s := DrawItems.GetString(i,Items);
              if (System.Length(s)>0) and RVU_IsSpace(s, 1, GetItemOptions(ItemNo)) then
                inc(SpaceCount)
            end;
        if SpaceCount>0 then begin
          dl := 0;
          dx2 := dx;
          for i := StartDItemNo to EndDItemNo do
            with DrawItems[i] do begin
              inc(Left, dl);
              if (dx2<>0) and (GetItemStyle(ItemNo)>=0) then begin
                s := DrawItems.GetString(i,Items);
                if (System.Length(s)>0) and RVU_IsSpace(s, 1, GetItemOptions(ItemNo)) then begin
                  DeltaSpaceAtLeft := dx2 div SpaceCount;
                  if SpaceAtLeft-DeltaSpaceAtLeft<0 then
                    DeltaSpaceAtLeft := SpaceAtLeft;
                  SpaceAtLeft := SpaceAtLeft-DeltaSpaceAtLeft;
                  dec(dl, DeltaSpaceAtLeft);
                  dec(Width, DeltaSpaceAtLeft);
                  dec(dx2, DeltaSpaceAtLeft);
                  dec(SpaceCount);
                end;
              end;
            end;
        end;
        for i := DItemNo+1 to DrawItems.Count-1 do begin
          if DrawItems[i].FromNewLine then
            break;
          inc(DrawItems[i].Left, dx);
        end;
      end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.Hiding;
var i: Integer;
begin
  for i := 0 to ItemCount-1 do
    GetItem(i).Hiding;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.GetSADForFormatting(Canvas: TCanvas;
  var sad: TRVScreenAndDevice);
begin
//  ApplyZoom(Canvas);
  RV_InfoAboutSaD(sad, Canvas, GetRVStyle.GraphicInterface);
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetFormatCanvas: TCanvas;
begin
  Result := TCustomRVFormattedData(GetRootData).GetFormatCanvasEx(GetCanvas);
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetFormatCanvasEx(DefCanvas: TCanvas): TCanvas;
begin
  Result := TCustomRVFormattedData(GetRootData).GetFormatCanvasEx(DefCanvas);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.Format_(OnlyResized, ForceFormat,
  NoScroll: Boolean; depth: Integer; Canvas: TCanvas;
  OnlyTail, NoCaching, Reformatting, CallOnFormat: Boolean);
var i: Integer;
    oldtextwidth, olddocumentwidth, cw, ch: Integer;
    sad: TRVScreenAndDevice;
    FirstItemNo: Integer;
    StartNo, EndNo, StartOffs, EndOffs: Integer;
    DevMinTextWidth, DevMaxTextWidth: Integer;
    FV, DeltaFV: Integer;
    RVStyle: TRVStyle;
    ExtraSpaceBelowLine: Integer;
    Params: TRVFormatParams;
begin
   if AlreadyFormatted then begin
     AlreadyFormatted := False;
     exit;
   end;
   if (depth>1) or (GetRVStyle=nil) or (rvstSkipformatting in State) or
      (OnlyTail and (LastItemFormatted>=ItemCount-1)) then
     exit;
   if Canvas=nil then
     Canvas := GetFormatCanvas;
   if depth=0 then begin
     StartFormatting;
   end;
   try
     Params.SpaceEaten := False;
     Params.LastTabDrawItemNo := -1;
     Params.NoCaching := NoCaching;
     Params.Reformatting := Reformatting;
     Params.FirstParaItemNo := -1;
     Params.LastTextStyle := -1;
     Params.IsParaSectionStart := True;
     Params.TextLength := 0;
     Params.MaxLength := GetMaxLength;
     Params.NeedRecalcY := False;
     Params.AllowWordWrap := IsWordWrapAllowed;
     Params.FloatingDrawItems := nil;
     Params.FloatingDrawItemsInThisParaSection := nil;
     Params.LineHasFloating := False;
     FV := -1;     { avoiding warings }
     DeltaFV := 0; { avoiding warings }
     if depth=0 then begin
        if OnlyResized then begin
          StoreSelBounds(StartNo, EndNo, StartOffs, EndOffs, False);
          if not NoScroll then begin
            FV := GetDrawItemNo(GetVOffs, gdinFirstVisible);
            if FV>=DrawItems.Count then
              FV:=DrawItems.Count-1;
            if FV>=0 then  begin
              Item2FirstDrawItem(DrawItems[FV].ItemNo, FV);
              if FV>=0 then begin
                DeltaFV := GetVOffs-DrawItems[FV].Top;
                FV := DrawItems[FV].ItemNo;
              end;
            end;
          end;
        end;
        if OnlyTail then
          FV := GetVOffs;
     end;

     oldtextwidth := TextWidth;
     olddocumentwidth := DocumentWidth;

     GetSADForFormatting(Canvas, sad);

     sad.LeftMargin  := RV_XToDevice(GetLeftMargin,  sad);
     sad.RightMargin := RV_XToDevice(GetRightMargin, sad);

     if OnlyTail then
       FirstItemNo := LastItemFormatted+1
     else
       FirstItemNo := 0;

     DocumentWidth := max(
       GetWidth-(sad.LeftMargin+sad.RightMargin),
       CalculateMinDocWidthPlus(FirstItemNo, @sad, Canvas));
     DevMinTextWidth := RV_XToDevice(GetMinTextWidth, sad);
     DevMaxTextWidth := RV_XToDevice(GetMaxTextWidth, sad);
     if DocumentWidth<DevMinTextWidth then
       DocumentWidth := DevMinTextWidth;
     if rvoClientTextWidth in Options then begin
       TextWidth := GetWidth-(sad.LeftMargin+sad.RightMargin);
       if TextWidth<DevMinTextWidth then
         TextWidth := DevMinTextWidth;
     end
     else begin
       if (DevMaxTextWidth>0) and (DocumentWidth>DevMaxTextWidth) then
         TextWidth := DevMaxTextWidth
       else
         TextWidth := DocumentWidth;
     end;
     if not (OnlyResized and (TextWidth=OldTextWidth) and (DocumentWidth=OldDocumentWidth)) or ForceFormat then begin
       if OnlyTail then begin
          Params.baseline := DocumentHeight-GetBottomMargin;
          if LastItemFormatted>=0 then
            dec(Params.baseline,
              GetRVStyle.GetAsDevicePixelsY(
                GetRVStyle.ParaStyles[GetItemParaEx(LastItemFormatted)].SpaceAfter,
                @sad));
          end
       else begin
          FirstItemNo := 0;
          Params.baseline  := GetTopMargin;
          ClearTemporal;
       end;
       Params.x:=0;
       Params.prevdesc :=0;
       Params.LastDrawItem := DrawItems.Count;
       Params.DontFSL := True;
       Params.LineWidth := -1;
       Params.LineStartX := 0;
       RVStyle   := GetRVStyle;       
       CreateFontInfoCache(GetCanvas, Canvas);
       Params.FontInfoCache := GetFontInfoCache(GetCanvas, Canvas, Self);
       Params.FormatCanvas := Canvas;
       Params.UseFormatCanvas := GetFormatCanvasEx(nil)<>nil;
       for i:= FirstItemNo to ItemCount-1 do
         if not IsHidden(i) then
           with GetItem(i) do begin
             if IsParaStartEx(i) then
               Params.FirstParaItemNo := i;
             if StyleNo>=0 then
               FormatLine(
                 RV_ReturnProcessedString(Items[i],
                   RVStyle.TextStyles[GetActualStyleNo(RVStyle)], False,
                     CanShowSpecialCharacters, False),
                 Items[i],
                 {$IFNDEF RVDONOTUSEUNICODE}
                 RVU_Length(Items[i], ItemOptions),
                 {$ELSE}
                 Length(Items[i]),
                 {$ENDIF}
                 i, Canvas, sad, Params)
             else
               FormatLine('', '', Length(Items[i]), i, Canvas, sad, Params)
           end
         else
           if not ShareItems then begin
             GetItem(i).DrawItemNo := -1;
             GetItem(i).Hiding;
           end;
       UpdateLastTab(Params);
       FinishScreenLine(sad, not (rvstLastParaAborted in State),
         ExtraSpaceBelowLine, Params);
       DestroyFontInfoCache(Params.FontInfoCache);
       DocumentHeight := Params.baseline+Params.prevdesc+GetBottomMargin+ExtraSpaceBelowLine;
       if GetLastNonHiddenItemNo>=0 then
         inc(DocumentHeight, GetRVStyle.GetAsDevicePixelsY(
           GetRVStyle.ParaStyles[GetItemParaEx(GetLastNonHiddenItemNo)].SpaceAfter,
           @sad));
       i := Params.FloatingDrawItems.GetFloatBottom+GetBottomMargin;
       if i>DocumentHeight then
         DocumentHeight := i;
       AdjustVScrollUnits;
       AdjustJumpsCoords;
       end
     else;
      // AdjustChildrenCoords;
     cw := GetWidth;
     ch := GetHeight;
     AlreadyFormatted := True;
     SetDocumentAreaSize(DocumentWidth+GetLeftMargin+GetRightMargin, DocumentHeight, True);
     AlreadyFormatted := False;
     if (cw<>GetWidth) or (ch<>GetHeight) then begin
       //EndFormatting;
       //ScrollTo(OldY);
       EndFormatting;
       Format_(OnlyResized, ForceFormat, False, depth+1, Canvas, False,
         NoCaching, Reformatting, False);
       StartFormatting;
     end;
     if (depth=0) then begin
       if OnlyResized and not NoScroll then begin
         FV := FindDrawItemByItem(FV);
         if FV<>-1 then
           ScrollTo(DrawItems[FV].Top+DeltaFV,False)
         else
           ScrollTo(0,False);
       end;
       AdjustChildrenCoords;
       if OnlyTail then begin
         if rvoScrollToEnd in Options then
           ScrollTo(DocumentHeight,False)
         else
           ScrollTo(FV,False);
  //       AdjustChildrenCoords;
       end;
       if OnlyResized then
         RestoreSelBounds(StartNo, EndNo, StartOffs, EndOffs);
     end;
   finally
     Params.FloatingDrawItems.Free;
     Params.FloatingDrawItemsInThisParaSection.Free;
     if (depth=0) then begin
       EndFormatting;
       LastItemFormatted := Items.Count-1;
       Formatted(0,Items.Count-1, False); // <- wrong for FormatTail
       DoAfterFormat;
     end;
   end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.GetSelBounds(var StartNo, EndNo,
  StartOffs, EndOffs: Integer; Normalize: Boolean);
begin
  if not Normalize or (FSelStartNo <= FSelEndNo) then begin
    StartNo := FSelStartNo;
    EndNo   := FSelEndNo;
    if not Normalize or not ((StartNo=EndNo) and (FSelStartOffs>FSelEndOffs)) then begin
      StartOffs := FSelStartOffs;
      EndOffs   := FSelEndOffs;
      end
    else begin
      StartOffs := FSelEndOffs;
      EndOffs   := FSelStartOffs;
    end;
    end
  else begin
    StartNo := FSelEndNo;
    EndNo   := FSelStartNo;
    StartOffs := FSelEndOffs;
    EndOffs   := FSelStartOffs;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.GetScreenLineBounds(DrawItemNo: Integer;
                                                     var First, Last: Integer);
begin
  First := DrawItemNo;
  while (First>0) and not DrawItems[First].FromNewLine do
    dec(First);
  Last := DrawItemNo+1;
  while (Last<DrawItems.Count) and not DrawItems[Last].FromNewLine do
    inc(Last);
  dec(Last);
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.FindFloatingAt(DItemNo, X, Y: Integer): Integer;
var i, j: Integer;
    Below: Boolean;
    FloatDItem: TRVFloatingDrawLineInfo;
begin
  // searching for the first line started below Y
  j := DrawItems.Count-1;
  Below := False;
  for i := DItemNo to j do begin
    if DrawItems[i].FromNewLine then begin
      if Below then
        break;
      Below := True;
      j := i;
    end;
    if DrawItems[i].Top < Y then
      Below := False;
  end;
  // going up
  Below := False;
  for i := j downto 0 do begin
    if DrawItems[i] is TRVFloatingDrawLineInfo then begin
      FloatDItem := TRVFloatingDrawLineInfo(DrawItems[i]);
      if (Y>=FloatDItem.FloatTop) and (Y<=FloatDItem.FloatBottom) and
         (X>=FloatDItem.FloatLeft) and (X<=FloatDItem.FloatRight) then begin
        Result := i;
        exit;
      end;
    end;
    if DrawItems[i].Top<Y then
      Below := True;
    if DrawItems[i].FromNewLine and Below and not DrawItems[i].FloatingAboveUsed then
      break;
  end;
  Result := -1;
end;
{------------------------------------------------------------------------------}
var SortDrawItems: TRVDrawLines;

function CompareCoords(Item1, Item2: Pointer): Integer;
begin
  Result := SortDrawItems[Integer(Item1)].Left-SortDrawItems[Integer(Item2)].Left;
end;

procedure TCustomRVFormattedData.FindDrawItemForSel(X,Y: Integer;
  var No, Offs: Integer; Strict, IgnoreFloating: Boolean);
var
    styleno,i, a,b,mid, midtop, midbottom, midleft, midright, beginline, endline,
    min, minsign, cur: Integer;
    firstinline,lastinline, delta, CharX: Integer;
    dli: TRVDrawLineInfo;
    arr: PRVIntegerArray;
    Canvas: TCanvas;
    s: TRVRawByteString;
    BiDiMode:TRVBiDiMode;
    order, revorder: TRVIntegerList;
    UseFormatCanvas: Boolean;
    ItemBiDiMode: TRVBiDiMode;
begin
  Canvas := GetFormatCanvas;
  UseFormatCanvas := Canvas<>GetCanvas;
  No := -1;
  Offs := -1;
  if DrawItems.Count = 0 then
    exit;
  dli := DrawItems[0];
  if (dli.Top+dli.Height>Y) then
    mid := 0
  else begin
    a := 1;
    b := DrawItems.Count-1;
    while (b-a)>1 do begin
      mid := (a+b) div 2;
      if (DrawItems[mid].Top-DrawItems[mid].ExtraSpaceAbove<=Y) then
        a := mid
      else
        b := mid;
    end;
    mid := a;
    if DrawItems[b].Top-DrawItems[b].ExtraSpaceAbove<=Y then
      mid := b;
  end;
  GetScreenLineBounds(mid, beginline, endline);
  if endline<>DrawItems.Count-1 then begin
    // may be the next line is better?
    b := endline+2;
    while b<DrawItems.Count do begin
      if DrawItems[b].FromNewLine then break;
      inc(b);
    end;
    dec(b);
    a := mid;
    for i := endline+1 to b do
      if DrawItems[i].Top-DrawItems[i].ExtraSpaceAbove<=Y then begin
        a := i;
        break;
      end;
    if a<>mid then begin
      beginline := endline+1;
      endline   := b;
    end;
  end;

  if not IgnoreFloating then begin
    No := FindFloatingAt(beginline, X, Y);
    if No>=0 then begin
      Offs := 1;
      exit;
    end;
  end;

  // calculating line bounds (in pixels)
  midtop    := DrawItems[mid].Top-DrawItems[mid].ExtraSpaceAbove;
  midbottom := DrawItems[mid].Top + DrawItems[mid].Height;
  midleft   := DrawItems[mid].Left;
  midright  := midleft+DrawItems[mid].Width;

  for i:= beginline to endline do begin
    dli := DrawItems[i];
    if dli.Top-dli.ExtraSpaceAbove < midtop then
      midtop := dli.Top-dli.ExtraSpaceAbove;
    if dli.Top+dli.Height > midbottom then
      midbottom := dli.Top + dli.Height;
    if dli.Left < midleft then
      midleft := dli.Left;
    if dli.Left+dli.Width > midright then
      midright := dli.Left + dli.Width;
  end;
  BiDiMode := GetParaBiDiMode(GetItemParaEx(DrawItems[beginline].ItemNo));
  if BiDiMode<>rvbdUnspecified then begin
    order := TRVIntegerList.Create;
    for i:= beginline to endline do
      order.Add(i);
    SortDrawItems := DrawItems;
    TList(order).Sort(CompareCoords);
    SortDrawItems := nil;
    revorder := TRVIntegerList.CreateEx(endline-beginline+1,0);
    for i:= beginline to endline do
      revorder[order[i-beginline]-beginline] := i;
    end
  else begin
    order := nil;
    revorder := nil;
  end;
  if BiDiMode=rvbdRightToLeft then begin
    firstinline := endline;
    lastinline  := beginline;
    delta       := -1;
    end
  else begin
    firstinline := beginline;
    lastinline  := endline;
    delta       := +1;
  end;
  for i:= beginline to endline do begin
    dli := DrawItems[i];
    if (
         (Strict and (dli.Left<=X) and (dli.Left+dli.Width>X) and
         (Y>=dli.Top-dli.ExtraSpaceAbove) and (Y<=dli.Top+dli.Height))
       or
         (not Strict and (order=nil) and
          (
           ((dli.Left<=X) and ((i=lastinline) or (DrawItems[i+delta].Left>X)))
           or
           ((i=firstinline) and (X<dli.Left))
           )
         )
       or
         (not Strict and (order<>nil) and
          (
           ((dli.Left<=X) and ((revorder[i-beginline]=endline) or (DrawItems[order[revorder[i-beginline]-beginline+1]].Left>X)))
           or
           ((revorder[i-beginline]=beginline) and (X<dli.Left))
           )
         )
       )
       then begin
      styleno := GetItemStyle(dli.ItemNo);
      No := i;
      Offs := 0;
      if styleno>=0 then begin
        GetRVStyle.ApplyStyle(Canvas, StyleNo, GetParaBiDiMode(GetItemParaEx(dli.ItemNo)),
          True, nil, False, UseFormatCanvas);
        s := DrawItems.GetString(i,Items);
        s := RV_ReturnProcessedString(s, GetRVStyle.TextStyles[StyleNo],
          IsDrawItemLastOnWrappedLine(i), CanShowSpecialCharacters, False);
        if Length(s)>0 then begin
          GetMem(arr, (dli.Length+2)*sizeof(Integer));
          try
            ItemBiDiMode := GetItemBiDiMode(dli.ItemNo);
            if (ItemBiDiMode<>rvbdUnspecified) and
               RVU_GetTextCaretPos(Canvas, s, arr, GetItemOptions(dli.ItemNo),
                 RVConvertToFormatCanvas(dli.Width-dli.SpaceAtLeft, UseFormatCanvas),
                 RVConvertToFormatCanvas(2, UseFormatCanvas),
                 GetRVStyle.GraphicInterface) then begin
              if UseFormatCanvas then
                for a := 0 to dli.Length do
                  arr[a] := RVConvertFromFormatCanvas(arr[a], True);
              min := Abs(X-arr[0]-dli.Left-dli.SpaceAtLeft);
              offs := 0;
              for a := 0 to dli.Length do begin
                CharX := arr[a]+dli.Left+dli.SpaceAtLeft;
                if (Abs(X-CharX)<min) or
                   ((a>0) and (Abs(X-CharX)=min) and
                     (((ItemBiDiMode=rvbdLeftToRight) and (X>CharX)) or
                      ((ItemBiDiMode=rvbdRightToLeft) and (X<CharX))))
                 then begin
                  Offs := a;
                  min := Abs(X-CharX);
                 end;
              end;
              if (Offs<Length(s)) and (Offs>0)and (NextCharStr(s, dli.ItemNo, Offs)>Offs+1) then
                Offs := NextCharStr(s, dli.ItemNo, Offs)-1;
              end
            else begin
              RVU_GetTextExtentExPoint(Canvas, s, MaxInt, b, arr,
                GetItemOptions(dli.ItemNo), GetRVStyle.GraphicInterface);
              if UseFormatCanvas then 
                for a := 0 to dli.Length do
                  arr[a] := RVConvertFromFormatCanvas(arr[a], True);                
              minsign := X-dli.Left;
              min := Abs(minsign);
              offs := 0;
              for a := 1 to b do begin
                cur := X-arr[a-1]-dli.Left-dli.SpaceAtLeft;
                if (abs(cur)<min) or
                   ((abs(cur)=min) and
                    (((cur<0) and (BiDiMode=rvbdRightToLeft)) or
                     ((cur>=0) and (BiDiMode<>rvbdRightToLeft)))) then begin
                  Offs := a;
                  minsign := cur;
                  min := Abs(minsign);
                end;
              end;
              if (Offs<Length(s)) and (Offs>0)and (NextCharStr(s, dli.ItemNo, Offs)>Offs+1) then
                Offs := NextCharStr(s, dli.ItemNo, Offs)-1;
            end;
            inc(Offs);
            if Offs>DrawItems[i].Length+1 then
              Offs := DrawItems[i].Length+1;
            if (Offs < 1) and (DrawItems[i].Length>0) then
              Offs := 1;
          finally
            FreeMem(arr);
          end;
          end
        else begin
          Offs := 1;
        end;
        end
      else begin
        Offs := (1-delta) div 2; 
        if X > dli.Left + dli.Width div 2 then begin
          {State := State + [rvstClickedBeyondItem];}
          Offs := (1+delta) div 2;
        end;
      end;
    end;
  end;
  order.Free;
  revorder.Free;
  {$IFNDEF RVDONOTUSELISTS}
  if (No>=0) and not Strict then begin
    if GetDrawItemStyle(No)=rvsListMarker then begin
      inc(No);
      Offs := GetOffsBeforeDrawItem(No);
    end;
  end;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.RestoreSelBounds(StartNo, EndNo,
  StartOffs, EndOffs: Integer);
begin
  Item2DrawItem(StartNo, StartOffs, {->} FSelStartNo, FSelStartOffs, rvdpBetterBelow);
  Item2DrawItem(EndNo,   EndOffs,   {->} FSelEndNo,   FSelEndOffs, rvdpBetterBelow);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.StoreSelBounds(var StartNo, EndNo,
  StartOffs, EndOffs: Integer; Normalize: Boolean);
var SelStartNo, SelEndNo, SelStartOffs, SelEndOffs: Integer;
begin
  GetSelBounds(SelStartNo, SelEndNo, SelStartOffs, SelEndOffs, Normalize);
  DrawItem2Item(SelStartNo,SelStartOffs, {->} StartNo,StartOffs);
  DrawItem2Item(SelEndNo,  SelEndOffs,   {->} EndNo,  EndOffs);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.DrawItem2Item(DrawItemNo, DrawItemOffs: Integer;
                             var ItemNo, ItemOffs: Integer);
var dli: TRVDrawLineInfo;
begin
  ItemNo := -1;
  if (DrawItemNo = -1) or (DrawItemNo>=DrawItems.Count) then exit;
  dli := DrawItems[DrawItemNo];
  if GetItemStyle(dli.ItemNo)>=0 then
    ItemOffs := DrawItemOffs + dli.Offs-1
  else
    ItemOffs := DrawItemOffs;
  ItemNo := dli.ItemNo;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.Item2DrawItem(ItemNo, ItemOffs: Integer;
  var DrawItemNo, DrawItemOffs: Integer; PosIfHidden: TRVDrawItemPosition);
var item: TCustomRVItemInfo;
    i: Integer;
begin
  DrawItemNo := -1;
  if ItemNo = -1 then
    exit;
  if IsHidden(ItemNo) and (GetItem(ItemNo).DrawItemNo<0) then begin
    i := -1;
    case PosIfHidden of
      rvdpStrict:
        exit;
      rvdpBetterAbove:
        begin
          i := GetPrevNonHiddenItemNo(ItemNo);
          if i<0 then begin
            i := GetNextNonHiddenItemNo(ItemNo);
            if i>=0 then
              ItemOffs := GetOffsBeforeItem(i);
            end
          else
            ItemOffs := GetOffsAfterItem(i);
        end;
      rvdpBetterBelow:
        begin
          i := GetNextNonHiddenItemNo(ItemNo);
          if i<0 then begin
            i := GetPrevNonHiddenItemNo(ItemNo);
            if i>=0 then
              ItemOffs := GetOffsAfterItem(i);
            end
          else
            ItemOffs := GetOffsBeforeItem(i);
        end;
    end;
    if i<0 then
      exit;
    ItemNo := i;
  end;
  item := GetItem(ItemNo);
  DrawItemNo := item.DrawItemNo;
  if item.StyleNo<0 then begin
    DrawItemOffs := ItemOffs-DrawItems[DrawItemNo].Offs;
    exit;
  end;
  DrawItemOffs := ItemOffs-DrawItems[DrawItemNo].Offs+1;
  for i := DrawItemNo+1 to DrawItems.Count-1 do begin
    if (DrawItems[i].ItemNo<>ItemNo) or
       ((DrawItems[i].Offs>=ItemOffs) and not (DrawItems[i-1].Offs+DrawItems[i-1].Length<ItemOffs)) then begin
      DrawItemNo   := i-1;
      DrawItemOffs := ItemOffs-DrawItems[DrawItemNo].Offs+1;
      if (GetDrawItemStyle(DrawItemNo)>=0) and
         (DrawItemOffs>DrawItems[DrawItemNo].Length+DrawItems[DrawItemNo].Offs) then begin
        DrawItemNo   := i;
        if DrawItems[DrawItemNo].Offs<=GetOffsBeforeDrawItem(DrawItemNo) then begin
          DrawItemNo := i;
          DrawItemOffs := DrawItems[DrawItemNo].Offs;
          end
        else begin
          DrawItemNo := i-1;
          DrawItemOffs := GetOffsAfterDrawItem(DrawItemNo);
        end;
      end;
      break;
    end;
    if i=DrawItems.Count-1 then begin
      DrawItemNo   := i;
      DrawItemOffs := ItemOffs-DrawItems[DrawItemNo].Offs+1;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.Item2FirstDrawItem(ItemNo: Integer;
  var DrawItemNo: Integer);
begin
  DrawItemNo := -1;
  if ItemNo = -1 then
    exit;
  Item2DrawItem(ItemNo, GetOffsBeforeItem(ItemNo), DrawItemNo, ItemNo, rvdpBetterBelow);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.Item2LastDrawItem(ItemNo: Integer; var DrawItemNo: Integer);
begin
  DrawItemNo := -1;
  if ItemNo = -1 then
    exit;
  Item2DrawItem(ItemNo, GetOffsAfterItem(ItemNo), DrawItemNo, ItemNo, rvdpBetterBelow);
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetDrawItemNo(BoundLine, Option: Integer): Integer;
var
    a,b,mid: Integer;
begin
  if DrawItems.Count = 0 then begin
     Result := -1;
     exit;
  end;
  if DrawItems[0].Top>=BoundLine then begin
     Result := 0;
     exit;
  end;
  if (Option=gdinLastVisible) and (DrawItems[DrawItems.Count-1].Top<BoundLine) then begin
     Result := DrawItems.Count-1;
     exit;
  end;
  a := 1;
  b := DrawItems.Count-1;
  mid := a;
  if Option = gdinLastCompleteVisible then begin
  {
    while (b-a)>1 do begin
      mid := (a+b) div 2;
      if (TRVDrawLineInfo(DrawItems.Objects[mid]).Top+TRVDrawLineInfo(DrawItems.Objects[mid]).Height>BoundLine) then
          b := mid
      else
          a := mid;
    end;
    if mid>= DrawItems.Count then mid := DrawItems.Count-1;
    while (mid>0) and (TRVDrawLineInfo(DrawItems.Objects[mid]).Top+TRVDrawLineInfo(DrawItems.Objects[mid]).Height>BoundLine) do dec(mid);

      if (mid>0) then dec(mid);
      while (mid>0) and not TRVDrawLineInfo(DrawItems.Objects[mid]).FromNewLine do dec(mid);
      if (mid>0) then dec(mid);
    end
    }
  end
  else begin
    while (b-a)>1 do begin
      mid := (a+b) div 2;
      if (DrawItems[mid].Top>=BoundLine) then begin
          if (DrawItems[mid-1].Top<BoundLine) then break;
          b := mid;
        end
      else
        a := mid;
    end;
    if mid>= DrawItems.Count then mid := DrawItems.Count-1;
    if Option = gdinFirstVisible then begin
      while (mid>0) and not DrawItems[mid].FromNewLine do dec(mid);
      if (mid>0) then dec(mid);
      while (mid>0) and not DrawItems[mid].FromNewLine do dec(mid);
      if (mid>0) then dec(mid);
      end
    else
      while DrawItems[mid].Top<BoundLine do inc(mid);
  end;
  Result := mid;
end;
{------------------------------------------------------------------------------}
// This function is used to calculate minimal possible line width to determine
// if this line can be placed between side-aligned items
// This function can be used both for wrapped and no-wrapped paragraphs.
// This function does not take left and right indents into account, only the
// first line indent (even if negative)
function TCustomRVFormattedData.CalculateMinLineWidth(FirstItemNo: Integer;
  sad: PRVScreenAndDevice; Canvas: TCanvas): Integer;
var LastItemNo, ItemNo: Integer;
begin
  ItemNo := FirstItemNo;
  if not (rvpaoNoWrap in GetRVStyle.ParaStyles[GetItemParaEx(FirstItemNo)].Options) and
     IsWordWrapAllowed then begin
    {$IFNDEF RVDONOTUSELISTS}
    if (GetItemStyle(FirstItemNo)=rvsListMarker) and (FirstItemNo+1<Items.Count) then
      inc(FirstItemNo);
    {$ENDIF}
    // using a minimal width of this item (may be with the preceding marker
    Result := CalculateMinItemWidthWrap(FirstItemNo, sad, Canvas, True);
    end
  else begin
    // calculating width of the whole paragraph section, since for no-wrap
    // paragraphs, line = section
    ExpandToParaSectionEx(FirstItemNo, FirstItemNo, FirstItemNo, LastItemNo);
    Result := CalculateMinItemsWidthNoWrap(FirstItemNo, LastItemNo, sad, Canvas,
      True);
  end;
  FirstItemNo := GetFirstParaItemEx(FirstItemNo);
  {$IFNDEF RVDONOTUSELISTS}
  if GetListLevelForItem(FirstItemNo)=nil then
  {$ENDIF}
    if (ItemNo=FirstItemNo) and not IsHidden(FirstItemNo) and
      not GetItem(ItemNo).GetBoolValue(rvbpFullWidth)  then
      inc(Result,
        GetRVStyle.GetAsDevicePixelsX(
          GetRVStyle.ParaStyles[GetItemParaEx(FirstItemNo)].FirstIndent, @sad));
end;
{------------------------------------------------------------------------------}
// Calculating minimal possible width for paragraph sections containing
// items in the given range.
// This is a maximum of min widths of all paragraph sections
// Works both for normal and no-wrap paragraphs
function TCustomRVFormattedData.CalculateParaSectionsMinWidth(StartItemNo,
  EndItemNo: Integer; var FirstParaItemNo: Integer; sad: PRVScreenAndDevice;
  Canvas: TCanvas): Integer;
var i,w: Integer;
begin
  ExpandToParaSectionEx(StartItemNo, EndItemNo, StartItemNo, EndItemNo);
  Result := 0;
  for i := StartItemNo to EndItemNo do begin
    if IsParaStartEx(i) and not IsHidden(i) then
      FirstParaItemNo := i;
    if IsFromNewLineEx(i) then begin
      w := CalculateParaSectionMinWidth(i, FirstParaItemNo, sad, Canvas);
      if w>Result then
        Result := w;
    end;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.CalculateParaSectionsMinWidthDef(StartItemNo,
  EndItemNo: Integer): Integer;
var FirstParaItemNo: Integer;
begin
  FirstParaItemNo := -1;
  Result := CalculateParaSectionsMinWidth(StartItemNo, EndItemNo, FirstParaItemNo, nil, nil);
end;
{------------------------------------------------------------------------------}
// Calculating total indents for the paragraph section
function TCustomRVFormattedData.CalculateEmptyParaSectionWidth(ItemNo: Integer;
  var FirstParaItemNo: Integer; sad: PRVScreenAndDevice; Canvas: TCanvas): Integer;
begin
  ItemNo := GetFirstParaSectionItemEx(ItemNo);
  if IsParaSectionHidden(ItemNo) then begin
    Result := 0;
    exit;
  end;
  Result := GetMaxIndent(ItemNo, FirstParaItemNo, sad);
end;
{------------------------------------------------------------------------------}
// The result is measured in device pixels

// Calculates sum of minimal widths of all items in the given range
// (for text items, uses their full widths)
// (for floating items, only maximal of their width is taken into account; or
//  they are ignored at all)
// This function is useful for no-wrap paragraphs
function TCustomRVFormattedData.CalculateMinItemsWidthNoWrap(
  StartItemNo, EndItemNo: Integer; sad: PRVScreenAndDevice; Canvas: TCanvas;
  IgnoreFloating: Boolean): Integer;
var i, w, FloatWidth: Integer;
    item: TCustomRVItemInfo;
    RVStyle: TRVStyle;
    sz: TSize;
    UseFormatCanvas: Boolean;
begin
  Result := 0;
  FloatWidth := 0;
  RVStyle := GetRVStyle;
  UseFormatCanvas := GetCanvas<>GetFormatCanvas;
  for i := StartItemNo to EndItemNo do
    if not IsHidden(i) then begin
      item := GetItem(i);
      if item.StyleNo>=0 then
        with RVStyle.TextStyles[GetActualStyle(item)] do begin
          Apply(Canvas, GetParaBiDiMode(GetItemParaEx(i)), rvflCanUseCustomPPI in Flags,
            nil, False, UseFormatCanvas, RVStyle.GraphicInterface);
          {$IFNDEF RVDONOTUSEUNICODE}
          if Unicode then begin
            RVU_GetTextExtentPoint32W(Canvas, Pointer(Items[i]), Length(Items[i]) div 2,
              sz, RVStyle.GraphicInterface);
            inc(Result, RVConvertFromFormatCanvas(sz.cx, UseFormatCanvas));
            end
          else
          {$ENDIF}
          begin
            RVStyle.GraphicInterface.GetTextExtentPoint32_A(Canvas,
              PRVAnsiChar(Items[i]), Length(Items[i]), sz);
            inc(Result, RVConvertFromFormatCanvas(sz.cx, UseFormatCanvas));
          end;
        end
      else if not item.GetBoolValue(rvbpFloating) then
        inc(Result, item.GetMinWidth(sad, Canvas,Self))
      else if not IgnoreFloating then begin
        w := item.GetMinWidth(sad, Canvas,Self);
        if w>FloatWidth then
          FloatWidth := w;
      end;
      end
    else
      if not ShareItems then
        GetItem(i).DrawItemNo := -1;
  if FloatWidth>Result then
    Result := FloatWidth;
end;
{------------------------------------------------------------------------------}
// Calculates minimal possible width for paragraph section containing
// StartItemNo-th item.
// Works both for normal paragraphs (calls CalculateMinItemsWidthPlusWrap)
// and for no-wrap paragraphs (calculates sum of widths of all items)
function TCustomRVFormattedData.CalculateParaSectionMinWidth(StartItemNo: Integer;
  var FirstParaItemNo: Integer; sad: PRVScreenAndDevice;
  Canvas: TCanvas): Integer;
var EndItemNo: Integer;
begin
  if Canvas=nil then
    Canvas := GetFormatCanvas;
  ExpandToParaSectionEx(StartItemNo, StartItemNo, StartItemNo, EndItemNo);
  if not (rvpaoNoWrap in GetRVStyle.ParaStyles[GetItemParaEx(StartItemNo)].Options) and
     IsWordWrapAllowed then
    Result := CalculateMinItemsWidthPlusWrap(StartItemNo, EndItemNo, FirstParaItemNo, sad, Canvas)
  else
    Result :=
      CalculateEmptyParaSectionWidth(StartItemNo, FirstParaItemNo, sad, Canvas)+
      CalculateMinItemsWidthNoWrap(StartItemNo, EndItemNo, sad, Canvas, False);
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.CalculateParaSectionMinWidthDef(StartItemNo: Integer): Integer;
var FirstParaItemNo: Integer;
begin
  FirstParaItemNo := -1;
  Result := CalculateParaSectionMinWidth(StartItemNo, FirstParaItemNo,nil,nil);
end;
{------------------------------------------------------------------------------}
// Calculates a minimal possible width for the given range of items in
// normal (i.e. wrappable) paragraphs
// This is a maximum of individual widths of items in this range.
function TCustomRVFormattedData.CalculateMinItemsWidthPlusWrap(StartItemNo, EndItemNo: Integer;
  var FirstParaItemNo: Integer; sad: PRVScreenAndDevice;
  Canvas: TCanvas): Integer;
var i,w, epsw: Integer;
begin
  Result := 0;
  if StartItemNo>EndItemNo then
    exit;
  epsw := CalculateEmptyParaSectionWidth(StartItemNo, FirstParaItemNo, sad, Canvas);
  for i := StartItemNo to EndItemNo do begin
    if IsParaStartEx(i) and not IsHidden(i) then
      FirstParaItemNo := i;
    if IsFromNewLineEx(i) and (i<>StartItemNo) then
      epsw := CalculateEmptyParaSectionWidth(i, FirstParaItemNo, sad, Canvas);
    w := epsw+CalculateMinItemWidthWrap(i, sad, Canvas, False);
    if w>Result then
      Result := w;
  end;
end;
{------------------------------------------------------------------------------}
// The result is measured in device pixels

// Calculates a minimal possible width for the given item in
// normal (i.e. wrappable) paragraphs
// If this is an item preceded by a marker, this function returns
// a sum of min widths of this item and marker.
function TCustomRVFormattedData.CalculateMinItemWidthWrap(
  ItemNo: Integer; sad: PRVScreenAndDevice; Canvas: TCanvas;
  IgnoreFloating: Boolean): Integer;
var item: TCustomRVItemInfo;
    {$IFNDEF RVDONOTUSELISTS}
    PrevItemNo: Integer;
    {$ENDIF}
begin
  if IsHidden(ItemNo) then begin
    Result := 0;
    exit;
  end;
  item := GetItem(ItemNo);
  if IgnoreFloating and item.GetBoolValue(rvbpFloating) then
    Result := 0
  else
    Result := item.GetMinWidth(sad, Canvas, Self);
  {$IFNDEF RVDONOTUSELISTS}
  if item.SameAsPrev and (ItemNo>0) then begin
    PrevItemNo := GetPrevNonHiddenItemNo(ItemNo);
    if PrevItemNo>=0 then begin
      item := GetItem(PrevItemNo);
      if item.StyleNo=rvsListMarker then
        inc(Result, item.GetMinWidth(sad, Canvas, Self));
    end;
  end;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
// Calculates a minimal possible width for the paragraph section containing
// the given item (both for wrappable and no-wrap paragraphs)
function TCustomRVFormattedData.CalculateMinItemWidthPlusEx(ItemNo: Integer): Integer;
var FirstParaItemNo: Integer;
begin
  FirstParaItemNo := -1;
  Result := CalculateParaSectionMinWidth(ItemNo, FirstParaItemNo, nil, GetFormatCanvas);
end;
{------------------------------------------------------------------------------}
// Calculates a minimal possible width for the given range of items
// (both for wrappable and no-wrap paragraphs)
function TCustomRVFormattedData.CalculateMinItemsWidthPlusEx(StartItemNo,
  EndItemNo: Integer): Integer;
var dummy, sno, eno,w: Integer;
    FirstParaItemNo: Integer;
begin
  if StartItemNo>EndItemNo then begin
    Result := 0;
    exit;
  end;
  FirstParaItemNo := -1;
  ExpandToParaSectionEx(StartItemNo, StartItemNo, dummy,eno);
  if (rvpaoNoWrap in GetRVStyle.ParaStyles[GetItemParaEx(StartItemNo)].Options) or
     not IsWordWrapAllowed then
    Result := CalculateParaSectionMinWidthDef(StartItemNo)
  else begin
    if eno>EndItemNo then
      eno := EndItemNo;
    Result := CalculateMinItemsWidthPlusWrap(StartItemNo, eno, FirstParaItemNo, nil,
      GetFormatCanvas);
  end;
  if eno>=EndItemNo then
    exit;
  ExpandToParaSectionEx(EndItemNo, EndItemNo, sno, dummy);
  if (rvpaoNoWrap in GetRVStyle.ParaStyles[GetItemParaEx(EndItemNo)].Options) or
     not IsWordWrapAllowed then
    w := CalculateParaSectionMinWidth(EndItemNo, FirstParaItemNo, nil,
      GetFormatCanvas)
  else begin
    if sno<StartItemNo then
      eno := StartItemNo;
    w := CalculateMinItemsWidthPlusWrap(sno, EndItemNo, FirstParaItemNo, nil,
      GetFormatCanvas);
  end;
  if w>Result then
    Result := w;
  if sno<=eno then
    exit;
  w := CalculateParaSectionsMinWidth(eno, sno, FirstParaItemNo, nil,nil);
  if w>Result then
    Result := w;
end;
{------------------------------------------------------------------------------}
// Calculates the minimal possible width for the part of document starting from
// the FirstItemNo-th item
function TCustomRVFormattedData.CalculateMinDocWidthPlus(FirstItemNo: Integer;
  sad: PRVScreenAndDevice; Canvas: TCanvas): Integer;
begin
  if (sad<>nil) and (sad.ppixScreen=sad.ppixDevice) and
     (sad.ppiyScreen=sad.ppiyDevice) then
    sad := nil;
  Result := CalculateParaSectionsMinWidth(FirstItemNo, ItemCount-1, FirstItemNo,
    sad, Canvas);
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.CalculateMinWidthAfterInsert(
  item: TCustomRVItemInfo; InsertItemNo: Integer): Integer;
begin
  if IsHiddenItem(item) then
    Result := 0
  else
    Result := item.GetMinWidth(nil,nil,Self);
  if (rvpaoNoWrap in GetRVStyle.ParaStyles[GetItemParaEx(InsertItemNo)].Options) or
     not IsWordWrapAllowed then
    inc(Result,CalculateParaSectionMinWidthDef(InsertItemNo));
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.AdjustJumpsCoords;
var i,x,y: Integer;
    jumpinfo: TRVJumpInfo;
begin
  for i:= 0 to Jumps.Count-1 do begin
    jumpinfo := TRVJumpInfo(Jumps[i]);
    jumpinfo.RVData.GetOrigin(x,y);
    dec(y, GetRVDataExtraVOffs);
    jumpinfo.l := x+jumpinfo.RVData.DrawItems[jumpinfo.DrawItemNo].ObjectLeft;
    jumpinfo.t := y+jumpinfo.RVData.DrawItems[jumpinfo.DrawItemNo].ObjectTop;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.AdjustChildrenCoords;
var i: Integer; 
  ditem: TRVDrawLineInfo;
  item : TCustomRVItemInfo;
  ControlParent: TWinControl;
  RVStyle: TRVStyle;
begin
  if (rvflShareContents in Flags) or (GetParentControl.ControlCount=0) or
     (rvstDoNotMoveChildren in State) then exit;
  ControlParent := GetRootData.GetParentControl;
  if ControlParent <> nil then
    ControlParent.DisableAlign;
  try
    RVStyle := GetRVStyle;
    for i:=0 to DrawItems.Count-1 do begin
      ditem := DrawItems[i];
      item := GetItem(ditem.ItemNo);
      if item.StyleNo<0 then
        TRVNonTextItemInfo(item).AdjustInserted(
          ditem.ObjectLeft-GetHOffs, ditem.ObjectTop-GetVOffs, True, RVStyle);
    end;
    {$IFNDEF RVDONOTUSESMARTPOPUP}
    TCustomRVFormattedData(GetAbsoluteRootData).AdjustSpecialControlsCoords(Self);
    {$ENDIF}
  finally
    if ControlParent <> nil then begin
      ControlParent.ControlState := ControlParent.ControlState - [csAlignmentNeeded];
      ControlParent.EnableAlign;
    end;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.FindDrawItemByItem(ItemNo: Integer): Integer;
var i: Integer;
begin
  Result := -1;
  if ItemNo = -1 then exit;
  for i :=0 to DrawItems.Count-1 do
    if DrawItems[i].ItemNo = ItemNo then begin
      Result := i;
      exit;
    end;
  //Assert(Result<>-1, 'Can''t FindDrawLineByLine');
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.FindDrawItemAtPos(X,Y: Integer): Integer;
var
    a,b,mid, midtop: Integer;
    dli: TRVDrawLineInfo;
    Below: Boolean;
begin
  if DrawItems.Count = 0 then begin
     Result := -1;
     exit;
  end;
  dli := DrawItems[0];
  if (dli.Top-dli.ExtraSpaceAbove<=Y) and (dli.Top+dli.Height>Y) and
     (dli.Left<=X) and (dli.Left+dli.Width>X) then begin
     Result := 0;
     exit;
  end;
  if DrawItems.Count = 1 then begin
     Result := -1;
     exit;
  end;
  a := 1;
  b := DrawItems.Count-1;
  while (b-a)>1 do begin
    mid := (a+b) div 2;
    if (DrawItems[mid].Top-DrawItems[mid].ExtraSpaceAbove<=Y) then
      a := mid
    else
      b := mid;
  end;
  mid := a;
  midtop := DrawItems[mid].Top-DrawItems[mid].ExtraSpaceAbove;
  while (mid>=1) and
         (DrawItems[mid-1].Top+
          DrawItems[mid-1].Height>midtop) do dec(mid);
  Below := False;
  while (mid<DrawItems.Count) do begin
    dli := DrawItems[mid];
    if dli.FromNewLine then begin
      if Below then
        break;
      Below := True;
    end;
    if dli.Top-dli.ExtraSpaceAbove<Y then
      Below := False;
    if ((dli.Top-dli.ExtraSpaceAbove<=Y) or (dli.Top<=Y)) and (dli.Top+dli.Height>Y) and
     (dli.Left<=X) and (dli.Left+dli.Width>X) then begin
        Result := mid;
        exit;
    end;
    inc(mid);
  end;
  if mid = DrawItems.Count then
    dec(mid);
  Result := FindFloatingAt(mid, X, Y);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.InvalidateDrawItem(DrawItemNo, Spacing: Integer);
var R: TRect;
    //X, Y: Integer;
begin
  //GetOrigin(X, Y);
  ResetSubCoords;
  with DrawItems[DrawItemNo] do
    R := Bounds(Left, Top, Width, Height);
  InflateRect(R, Spacing, Spacing);
  OffsetRect(R, {X}-GetHOffs, {Y}-GetVOffs);
  //if (R.Bottom>0) and (R.Top<TCustomRVFormattedData(GetRootData).GetHeight) then
    InvalidateRect(R);
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetFirstVisible(TopLine: Integer): Integer;
begin
   Result := GetDrawItemNo(TopLine,gdinFirstVisible);
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetFirstItemVisible: Integer;
var v: Integer;
begin
   v := GetDrawItemNo(GetVOffs, gdinFirstVisible);
   if v>=DrawItems.Count then
     v := DrawItems.Count-1;
   if v<0 then
     Result := -1
   else
     Result := DrawItems[v].ItemNo;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetLastItemVisible: Integer;
var v: Integer;
begin
   v := GetDrawItemNo(GetVOffs+GetHeight, gdinLastVisible);
   if v>=DrawItems.Count then
     v := DrawItems.Count-1;
   if v<0 then
     Result := -1
   else
     Result := DrawItems[v].ItemNo;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.DrawBackground(Canvas: TCanvas; r: TRect;
  GraphicInterface: TRVGraphicInterface);
var X, Y: Integer;
begin
  GetOrigin(X, Y);
  GetBackground.Draw(Canvas, r, GetHOffs+X, GetVOffs+Y, 0, 0, GetWidth, GetHeight,
    GetColor, False, False, GraphicInterface);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.PaintTo(Canvas: TCanvas; AClipRect: TRect;
 StrictTop, StrictBottom, InplaceOnMainCanvas, PrintMode: Boolean;
 ExtraXOffs, ExtraYOffs, MinItemNo, MaxItemNo: Integer);
var i, yshift, xshift, fullwidth, selwidth, ditemselstart, ditemselend,
    ditemselstart2, ditemselend2: Integer;
    dli:TRVDrawLineInfo;
    li: TCustomRVItemInfo;
    HoverNow, res: Boolean;
    s : TRVRawByteString;
    StartNo, EndNo, StartOffs, EndOffs: Integer;
    LastDrawnStyle: Integer;
    RVStyle: TRVStyle;
    BiDiMode: TRVBiDiMode;
    DefaultTextDrawState: TRVTextDrawStates;
    DefaultDrawState: TRVItemDrawStates;
    FirstDLine, LastDLine: Integer;
    LineTopY, LineBottomY: Integer;
    ShowSpecialCharacters: Boolean;
    FormatCanvas, Canvas2: TCanvas;
    ShiftedClipRect: TRect;
    FloatingDrawItems: TRVFloatingDrawItems;
  {.......................................................}
  procedure AdjustFirstDLine; // if StrictTop
  var BelowTop: Boolean;
    i: Integer;
  begin
    BelowTop := False;
    for i := FirstDLine to LastDLine do begin
      if DrawItems[i].FromNewLine then
        if BelowTop then
          break
        else
          FirstDLine := i;
      if DrawItems[i].Top>=ShiftedClipRect.Top then
        BelowTop := True;
    end;
  end;    
  {.......................................................}
    // drawing paragraph backgrounds and frames...
    // in: FirstDLine, RVStyle
    // in-out: LastDLine
    procedure DrawParagraphsBacks;
    var i,// j,
         AParaNo, MaxTextWidth: Integer;
        dli: TRVDrawLineInfo;
        BRect, BRect1: TRect;
        BelowBottom: Boolean;
    begin
      BelowBottom := False;
      i := FirstDLine;
      while (i>0) and not IsDrawItemParaStart(i) do
        dec(i);
      MaxTextWidth := GetMaxTextWidth;
      while i<DrawItems.Count do begin
        //j := i;
        dli := DrawItems[i];
        if BelowBottom and dli.FromNewLine then begin
          if LastDLine>i then
            LastDLine := i;
          break;
        end;
        if IsParaStartEx(dli.ItemNo) and
          (dli.ItemNo>=MinItemNo) and (dli.ItemNo<=MaxItemNo) and
          (GetItem(dli.ItemNo).StyleNo<>rvsBreak) and
          (
          (RVStyle.ParaStyles[GetItemParaEx(dli.ItemNo)].Border.Style<>rvbNone) or
          (RVStyle.ParaStyles[GetItemParaEx(dli.ItemNo)].Background.Color<>clNone) or
           Assigned(RVStyle.OnDrawParaBack)
          ) then begin
          AParaNo := GetItemParaEx(dli.ItemNo);
          with RVStyle.ParaStyles[AParaNo] do begin
            BRect.Left := GetLeftMargin+RVStyle.GetAsPixels(LeftIndent);
            if FirstIndent<0 then
              inc(BRect.Left, RVStyle.GetAsPixels(FirstIndent));
            if rvoClientTextWidth in Self.Options then
              BRect.Right := GetWidth-(GetRightMargin+RVStyle.GetAsPixels(RightIndent))
            else if MaxTextWidth>0 then
              BRect.Right := GetLeftMargin+MaxTextWidth-RVStyle.GetAsPixels(RightIndent)
            else
              BRect.Right := GetAreaWidth-(GetRightMargin+RVStyle.GetAsPixels(RightIndent));
            if dli.Left+dli.Width>BRect.Right then
              BRect.Right := dli.Left+dli.Width;
          end;
          BRect.Top := dli.Top-dli.ExtraSpaceAbove;
          BRect.Bottom := dli.Top+dli.Height+dli.ExtraSpaceBelow;
          inc(i);
          while (i<DrawItems.Count) and
              ((DrawItems[i].ItemNo=DrawItems[i-1].ItemNo) or
               not IsParaStartEx(DrawItems[i].ItemNo)) do begin
            dli := DrawItems[i];
            if dli.Top-dli.ExtraSpaceAbove<BRect.Top then
              BRect.Top := dli.Top-dli.ExtraSpaceAbove;
            if dli.Top+dli.Height+dli.ExtraSpaceBelow>BRect.Bottom then
              BRect.Bottom := dli.Top+dli.Height+dli.ExtraSpaceBelow;
            if dli.Left+dli.Width>BRect.Right then
              BRect.Right := dli.Left+dli.Width;
            if BelowBottom and dli.FromNewLine and (LastDLine>i) then
               LastDLine := i;
            if (dli.Top>ShiftedClipRect.Bottom) and (GetMaxTextWidth=0) then
              BelowBottom := True;
            inc(i);
          end;
          {
          if (FloatingDrawItems<>nil) and (FloatingDrawItems.Count>0) then begin
            dec(BRect.Right, BRect.Left-1);
            FloatingDrawItems.AdjustLineSize(BRect.Left, 0, BRect.Left+BRect.Right,
              BRect.Top, BRect.Left, BRect.Right, True);
            inc(BRect.Right, BRect.Left-1);
          end;
          }
          OffsetRect(BRect, -xshift, -yshift);
          dec(BRect.Right);
          dec(BRect.Bottom);          
          BRect1 := BRect;
          RVStyle.ParaStyles[AParaNo].Background.PrepareDraw(BRect1, RVStyle);
          RVStyle.ItemNo := DrawItems[i-1].ItemNo;
          RVStyle.RVData := Self;
          RVStyle.DrawParaBack(Canvas, AParaNo, BRect1, False, rvcmColor);
          RVStyle.ParaStyles[AParaNo].Border.Draw(BRect, Canvas, RVStyle, RVStyle.GraphicInterface);
          end
        else
          inc(i);
        {
        while j<i do begin
          dli := DrawItems[j];
          if dli is TRVFloatingDrawLineInfo then begin
            if FloatingDrawItems=nil then
              FloatingDrawItems := TRVFloatingDrawItems.Create;
              FloatingDrawItems.Add(dli);
          end;
          inc(j);
        end;
        }
        if dli.Top>ShiftedClipRect.Bottom then
          BelowBottom := True;
      end;
    end;
  {.......................................................}
    procedure DrawTextBacks;
    var i, StyleNo, ItemNo: Integer;
        R: TRect;
        dli: TRVDrawLineInfo;
        item: TCustomRVItemInfo;
        TextDrawState: TRVTextDrawStates;
    begin
      i := FirstDLine;
      while i<=LastDLine do begin
        dli := DrawItems[i];
        ItemNo := dli.ItemNo;
        item := GetItem(ItemNo);
        if (item.StyleNo>=0) and (dli.ItemNo>=MinItemNo) and (dli.ItemNo<=MaxItemNo) then begin
          TextDrawState := [];
          StyleNo := item.GetActualStyleNo(RVStyle);
          if RVStyle.TextStyles[StyleNo].Jump and
             (rvstDrawHover in State) and
             (LastJumpMovedAbove<>-1) and (item.JumpID = LastJumpMovedAbove) then
            Include(TextDrawState, rvtsHover);
          R := Bounds(dli.Left-xshift, dli.Top-yshift, dli.Width, dli.Height);
          inc(i);
          //if GetItemBiDiMode(ItemNo)=rvbdUnspecified then
            while (i<=LastDLine) and (GetItemStyle(DrawItems[i].ItemNo)=StyleNo)
              and not DrawItems[i].FromNewLine do begin
                dli := DrawItems[i];
                if R.Left>dli.Left-xshift then
                  R.Left := dli.Left-xshift;
                if R.Right<dli.Left+dli.Width-xshift then
                  R.Right := dli.Left+dli.Width-xshift;
                inc(i);
            end;
          RVStyle.DrawTextBack(Canvas, ItemNo, StyleNo,
            Self, R.Left, R.Top, R.Right-R.Left, R.Bottom-R.Top,
            TextDrawState);
          end
        else
          inc(i);
      end;
    end;
  {.......................................................}
    function GetSelDrawState: TRVTextDrawStates;
    begin
      Result := [rvtsSelected];
      if rvtsControlFocused in DefaultTextDrawState then
        Include(Result, rvtsControlFocused);
      if HoverNow then
        Include(Result, rvtsHover);
    end;
  {.......................................................}
    procedure DrawText(X,Y,W, Offs, DItemNo, StyleNo: Integer; const s: TRVRawByteString;
      IsStart, IsEnd, Selected, SBAdded: Boolean);
                       // in : dli, Canvas, xshift, yshift, hovernow
    var SpaceAtLeft: Integer;
    var DrawState: TRVTextDrawStates;
        s2: TRVRawByteString;
    begin
      {
      if s='' then begin
        Canvas.Pen.Color := clBlue;
        Canvas.Pen.Style := psSolid;
        Canvas.Ellipse(x-10-xshift,y-10-yshift,x+10-xshift,y+10-yshift);
      end;
      }
      DrawState := DefaultTextDrawState;
      if Selected then Include(DrawState, rvtsSelected);
      if HoverNow then
        Include(DrawState, rvtsHover);
      if Assigned(RVStyle.OnDrawStyleText) then begin
        if IsStart then begin
          Include(DrawState, rvtsDrawItemStart);
          if dli.Offs=1 then
            Include(DrawState, rvtsItemStart);
        end;
        if IsEnd then begin
          Include(DrawState, rvtsDrawItemEnd);
          if dli.Offs+dli.Length-1=ItemLength(dli.ItemNo) then
            Include(DrawState, rvtsItemEnd);
        end;
      end;
      RVStyle.ApplyStyleColor(Canvas, StyleNo, DrawState, False, rvcmColor);
      if IsStart then begin
        SpaceAtLeft := dli.SpaceAtLeft;
        if not SBAdded then
          inc(W,SpaceAtLeft);
        end
      else begin
        SpaceAtLeft := 0;
        inc(X, dli.SpaceAtLeft);
        if SBAdded then
          dec(W,dli.SpaceAtLeft);
      end;
      s2 := s;
      if ShowSpecialCharacters then begin
        Include(DrawState, rvtsSpecialCharacters);
        if RichViewShowGhostSpaces and IsEnd and
           IsSpaceBetweenDrawItems(DItemNo) and
           (not Selected or
           (rvstCompletelySelected in State) or
            not (DItemNo=EndNo)) then begin
            {$IFNDEF RVDONOTUSEUNICODE}
            if rvioUnicode in li.ItemOptions then
              s2 := s2+' '#0
            else
            {$ENDIF}
              s2 := s2+' ';
        end;
      end;
      if Selected and (RVStyle.SelectionStyle=rvssLines) and (W>0) then
        RVStyle.GraphicInterface.FillRect(Canvas,
          Rect(X-xshift-1, LineTopY-yshift, X-xshift+W+1, LineBottomY-yshift));
      RVStyle.DrawStyleText(s2, Canvas, dli.ItemNo, Offs+dli.Offs-1, StyleNo, Self,
        SpaceAtLeft,
        X-xshift, Y-yshift, W, dli.Height,
        {$IFDEF RVUSEBASELINE}dli.BaseLine-yshift{$ELSE}0{$ENDIF},
        DrawState, InplaceOnMainCanvas,
        InplaceOnMainCanvas, rvcmColor, BiDiMode, FormatCanvas);
    end;
  {.......................................................}
  function GetLineTopY(DrawItemNo: Integer): Integer;
  var i: Integer;
  begin
    Result := DrawItems[DrawItemNo].Top;
    for i := DrawItemNo downto 0 do begin
      if DrawItems[i].Top<Result then
        Result := DrawItems[i].Top;
      if DrawItems[i].FromNewLine then
        break;
    end;
    for i := DrawItemNo+1 to DrawItems.Count-1 do begin
      if DrawItems[i].FromNewLine then
        break;
      if DrawItems[i].Top<Result then
        Result := DrawItems[i].Top;
    end;
  end;
  {.......................................................}
  procedure DrawSoftPageBreaks;
  var FirstPB, i,DItemNo, Offs, Y, PBItemNo: Integer;
      dli: TRVDrawLineInfo;
      PBInfo: TRVSoftPageBreakInfo;
      FSoftPageBreaks: TRVSoftPageBreakList;
  begin
    if DrawItems.Count=0 then
      exit;
    FSoftPageBreaks := SoftPageBreaks;
    FirstPB := -1;
    dli := DrawItems[FirstDLine];
    for i := 0 to FSoftPageBreaks.Count-1 do begin
      PBItemNo := TRVSoftPageBreakInfo(FSoftPageBreaks.Items[i]).ItemNo;
      if (PBItemNo>=dli.ItemNo) and (PBItemNo>=MinItemNo) and (PBItemNo<=MaxItemNo) then begin
        FirstPB := i;
        break;
      end;
    end;
    if FirstPB<0 then
      exit;
    for i := FirstPB to FSoftPageBreaks.Count-1 do begin
      PBInfo := TRVSoftPageBreakInfo(FSoftPageBreaks.Items[i]);
      if not IsHidden(PBInfo.ItemNo) and (PBInfo.ItemNo>=MinItemNo) and (PBInfo.ItemNo<=MaxItemNo) then begin
        Item2DrawItem(PBInfo.ItemNo, PBInfo.Offset, DItemNo, Offs, rvdpBetterBelow);
        if DItemNo>LastDLine then
          exit;
        if (DItemNo=0) and (PBInfo.ExtraData<0) then
          continue;
        if PBInfo.ExtraData>=0 then
          Y := DrawItems[DItemNo].Top+GetItem(PBInfo.ItemNo).GetSoftPageBreakDY(PBInfo.ExtraData)
        else
          Y := GetLineTopY(DItemNo);
        RVStyle.DrawPageBreak(Canvas, Y-yshift-1, xshift, rvpbSoftPageBreak,
          GetParentControl, Self, PBInfo.ItemNo);
      end;
    end;
  end;
  {.......................................................}
  procedure GetLineVerticalBounds(FirstDrawItemNo: Integer;
    var LineTopY, LineBottomY: Integer);
  var i, LastDrawItemNo: Integer;
      ditem: TRVDrawLineInfo;
  begin
    ditem := DrawItems[FirstDrawItemNo];
    LineTopY := ditem.Top;
    LineBottomY := LineTopY+ditem.Height+ditem.ExtraSpaceBelow;
    if (FirstDrawItemNo+1>=DrawItems.Count) or
       DrawItems[FirstDrawItemNo+1].FromNewLine then
       LastDrawItemNo := FirstDrawItemNo
    else begin
      LastDrawItemNo := DrawItems.Count-1;
      for i := FirstDrawItemNo+1 to DrawItems.Count-1 do begin
        ditem := DrawItems[i];
        if ditem.FromNewLine then begin
          LastDrawItemNo := i-1;
          break;
        end;
        if LineTopY>ditem.Top then
          LineTopY := ditem.Top;
        if LineBottomY<ditem.Top+ditem.Height+ditem.ExtraSpaceBelow then
          LineBottomY := ditem.Top+ditem.Height+ditem.ExtraSpaceBelow;
      end;
    end;
    if IsDrawItemParaStart(FirstDrawItemNo) then
      dec(LineTopY, RVStyle.GetAsPixels(RVStyle.ParaStyles[GetItemParaEx(
        DrawItems[FirstDrawItemNo].ItemNo)].SpaceBefore));
    if IsDrawItemParaEnd(LastDrawItemNo) then
      inc(LineBottomY, RVStyle.GetAsPixels(RVStyle.ParaStyles[GetItemParaEx(
        DrawItems[FirstDrawItemNo].ItemNo)].SpaceAfter));
  end;
  {.......................................................}
  function UseLineSelection(ditem: TRVDrawLineInfo): Boolean;
  begin
    Result := (FSelStartNo>=0) and (RVStyle.SelectionStyle=rvssLines) and
      (GetItemBiDiMode(ditem.ItemNo)=rvbdUnspecified);
  end;
  {.......................................................}
  procedure DrawParaAttrs(Left,Top: Integer; const Sz: TSize;
    ParaStyle: TParaInfo; ParaBreak: Boolean; BiDiMode: TRVBiDiMode;
    After: Boolean);
  var Points: array[0..2] of TPoint;
      ColorApplied, IconsDrawn: Boolean;
      Len: Integer;
      CurLeft, CurTop: Integer;
      s: TRVRawByteString;
      NumSz: TSize;
      procedure ApplyColor;
      begin
        if ColorApplied then
          exit;
        Canvas.Brush.Style := bsSolid;
        Canvas.Brush.Color := Canvas.Font.Color;
        Canvas.Pen.Style := psSolid;
        Canvas.Pen.Color := Canvas.Font.Color;
        ColorApplied := True;
      end;
  begin
    ColorApplied := False;
    Len := (Sz.cy*2) div 5;
    IconsDrawn := False;
    CurLeft := Left;
    CurTop := Top;
    if ParaBreak then begin
      if ParaStyle.BiDiMode<>rvbdUnspecified then begin
        ApplyColor;
        if ParaStyle.BiDiMode=rvbdLeftToRight then begin
          Points[0].X := CurLeft+Sz.cx+2;
          Points[1].X := Points[0].X;
          Points[0].Y := CurTop;
          Points[1].Y := CurTop+Len;
          Points[2].Y := (Points[0].Y+Points[1].Y) div 2;
          Points[2].X := Points[0].X+(Points[1].Y-Points[0].Y) div 2;
          CurLeft := Points[0].X;
          end
        else begin
          Points[0].X := CurLeft-2;
          Points[1].X := Points[0].X;
          Points[0].Y := CurTop;
          Points[1].Y := CurTop+Len;
          Points[2].Y := (Points[0].Y+Points[1].Y) div 2;
          Points[2].X := Points[0].X-(Points[1].Y-Points[0].Y) div 2;
          CurLeft := Points[2].X;
        end;
        CurTop := Points[1].Y+2;
        RVStyle.GraphicInterface.Polygon(Canvas, Points);
        IconsDrawn := True;
        end
      else
        inc(CurLeft, Sz.cx+2);
      if not ParaStyle.IsHeading(9) and ((ParaStyle.Options *
        [rvpaoKeepWithNext,rvpaoKeepLinesTogether,rvpaoWidowOrphanControl])<>[]) then begin
        ApplyColor;
        RVStyle.GraphicInterface.Rectangle(Canvas, CurLeft,CurTop,CurLeft+Len,CurTop+Len);
        IconsDrawn := True;
      end;
      if ParaStyle.IsHeading(9) then begin
        Canvas.Font.Name := RVFONT_WINGDINGS;
        Canvas.Font.Style := [];
        Canvas.Font.Charset := SYMBOL_CHARSET;
        s := TRVAnsiChar(139+ParaStyle.OutlineLevel);
        RVStyle.GraphicInterface.GetTextExtentPoint32_A(Canvas,
          PRVAnsiChar(s), 1, NumSz);
        if (After and (BiDiMode=rvbdRightToLeft)) or
           (not After and (BiDiMode<>rvbdRightToLeft))then begin
          dec(Left, NumSz.cx);
          if IconsDrawn then
            dec(Left, Len);
          end
        else begin
          inc(Left, Sz.cx);
          if IconsDrawn then
            inc(Left, Len);
        end;
        Canvas.Brush.Style := bsClear;
        RVStyle.GraphicInterface.TextOut_A(Canvas, Left, Top, PRVAnsiChar(s), Length(s));
        LastDrawnStyle := -1;
      end;
    end;
  end;
  {.......................................................}
  procedure DrawParaMark(DrawItemNo: Integer; After: Boolean);
  var BiDiMode: TRVBiDiMode;
      Left, Top: Integer;
      s: TRVRawByteString;
      sz: TSize;
      ditem: TRVDrawLineInfo;
      ParaBreak: Boolean;
  begin
    if After then begin
      if (DrawItemNo+1<DrawItems.Count) and
         ((DrawItems[DrawItemNo].ItemNo=DrawItems[DrawItemNo+1].ItemNo) or
          not IsFromNewLineEx(DrawItems[DrawItemNo+1].ItemNo)) then
        exit
      end
    else begin
      if ((DrawItemNo>0) and (DrawItems[DrawItemNo].ItemNo=DrawItems[DrawItemNo-1].ItemNo)) or
          not IsFromNewLineEx(DrawItems[DrawItemNo].ItemNo) then
        exit;
    end;
    ditem := DrawItems[DrawItemNo];
    if LastDrawnStyle<0 then
      if GetItemStyle(DrawItems[DrawItemNo].ItemNo)>0 then
        LastDrawnStyle := GetItemStyle(DrawItems[DrawItemNo].ItemNo)
      else
        LastDrawnStyle := 0;
    BiDiMode := GetParaBiDiMode(GetItemParaEx(ditem.ItemNo));
    RVStyle.ApplyStyle(Canvas, LastDrawnStyle, BiDiMode, True, nil, False,
      False);
    RVStyle.ApplyStyleColor(Canvas, LastDrawnStyle, [], False, rvcmColor);
    if FormatCanvas<>Canvas then
      LastDrawnStyle := -1;
    if RVStyle.SpecialCharactersColor<>clNone then
      Canvas.Font.Color := RVStyle.SpecialCharactersColor;
    if {$IFDEF RICHVIEWCBDEF3}(Canvas.Font.Charset=SYMBOL_CHARSET) or{$ENDIF}
       (AnsiCompareText(Canvas.Font.Name, RVFONT_SYMBOL)=0) or
       (AnsiCompareText(Canvas.Font.Name, RVFONT_WINGDINGS)=0) then begin
      LastDrawnStyle := -1;
      Canvas.Font.Name := 'Arial';
      {$IFDEF RICHVIEWCBDEF3}
      Canvas.Font.CHARSET := DEFAULT_CHARSET;
      {$ENDIF}
    end;
    if After then
      ParaBreak := (DrawItemNo+1=DrawItems.Count) or IsParaStartEx(DrawItems[DrawItemNo+1].ItemNo)
    else
      ParaBreak := IsParaStartEx(DrawItems[DrawItemNo].ItemNo);
    if ParaBreak and (RVParagraphMarks=rvpmStandard) then
      s := #$B6
    else begin
      {$IFDEF RICHVIEWCBDEF3}
      Canvas.Font.Charset := SYMBOL_CHARSET;
      {$ENDIF}
      Canvas.Font.Name := RVFONT_SYMBOL;
      if ParaBreak or (RVParagraphMarks=rvpmStandard) then
        s := #$BF
      else
        s := #$AF;
      {
      Canvas.Font.Name := RVFONT_WINGDINGS;
      s := #$C3;
      }
      LastDrawnStyle := -1;
    end;
    RVStyle.GraphicInterface.GetTextExtentPoint32_A(Canvas,
      PRVAnsiChar(s), 1, sz);
    if (After and (BiDiMode<>rvbdRightToLeft)) or
       (not After and (BiDiMode=rvbdRightToLeft)) then
      Left := ditem.Left+ditem.Width
    else
      Left := ditem.Left-sz.cx;
    dec(Left, xshift);
    Top := ditem.Top+ditem.Height-yshift-sz.cy;
    RVStyle.GraphicInterface.TextOut_A(Canvas, Left, Top, PRVAnsiChar(s), Length(s));
    if rvscParagraphAttrs in RVVisibleSpecialCharacters then
      DrawParaAttrs(Left,Top, sz, RVStyle.ParaStyles[GetItemParaEx(ditem.ItemNo)],
        ParaBreak, BiDiMode, After);
  end;
  {.......................................................}
  {$IFNDEF RVDONOTUSELIVESPELL}
  procedure GetSubItemRect(DItemNo, StartOffs, EndOffs, StyleNo: Integer;
    ditem: TRVDrawLineInfo; var r: TRect);
  var s: TRVRawByteString;
      res: Boolean;
      LStartOffs, LEndOffs: Integer;
  begin
    dec(StartOffs, ditem.Offs-1);
    if StartOffs<1 then
      StartOffs := 1;
    dec(EndOffs, ditem.Offs-1);
    if EndOffs>ditem.Length then
      EndOffs := ditem.Length;
    s  := DrawItems.GetString(DItemNo,Items);
    if BiDiMode<>rvbdUnspecified then begin
      LStartOffs := StartOffs;
      LEndOffs := EndOffs;
      s := RV_ReturnProcessedStringEx(s, RVStyle.TextStyles[StyleNo],
        (StartOffs>=GetOffsAfterDrawItem(DItemNo)) and IsDrawItemLastOnWrappedLine(DItemNo),
           ShowSpecialCharacters, True, LStartOffs, LEndOffs);
      res := RVU_GetTextRangeCoords(FormatCanvas, s, LStartOffs, LEndOffs-LStartOffs+1,
        GetItemOptions(ditem.ItemNo),
        RVConvertToFormatCanvas(ditem.Width-ditem.SpaceAtLeft, FormatCanvas<>Canvas),
        RVConvertToFormatCanvas(2, FormatCanvas<>Canvas),
        r.Left, r.Right, RVStyle.GraphicInterface);
      end
    else
      res := False;
    if not res then begin
      if StartOffs>1 then begin
        s := DrawItems.GetSubString(DItemNo, Items, 1, StartOffs-1);
        s  := RV_ReturnProcessedString(s, RVStyle.TextStyles[StyleNo], False,
          ShowSpecialCharacters, True);
        r.Left := RVU_TextWidth(s, FormatCanvas, GetItemOptions(ditem.ItemNo),
          RVStyle.GraphicInterface);
        end
      else
        r.Left := 0;
      s := DrawItems.GetSubString(DItemNo, Items, StartOffs, EndOffs-StartOffs+1);
      s := RV_ReturnProcessedString(s, RVStyle.TextStyles[StyleNo],
        (EndOffs+1>=GetOffsAfterDrawItem(DItemNo)) and IsDrawItemLastOnWrappedLine(DItemNo),
        ShowSpecialCharacters, True);
      r.Right := r.Left+ RVU_TextWidth(s, FormatCanvas, GetItemOptions(ditem.ItemNo),
        RVStyle.GraphicInterface);
    end;
    r.Top := 0;
    r.Bottom := ditem.Height;
  end;
  {.......................................................}
  procedure DrawWordPainters;
  var i,j, Offs1, Offs2: Integer;
      List: TRVWordPainterList;
      ditem: TRVDrawLineInfo;
      r: TRect;
      StyleNo: Integer;
  begin
    LastDrawnStyle := -1;
    for i := FirstDLine to LastDLine do begin
      ditem := DrawItems[i];
      if (ditem.ItemNo<MinItemNo) then
        continue;
      if (ditem.ItemNo>MaxItemNo) then
        exit;
      if StrictBottom and (ditem.Top+ditem.Height>ShiftedClipRect.Bottom) then
        exit;
      if GetItem(DrawItems[i].ItemNo).WordPaintList<>nil then begin
        StyleNo := GetActualStyle(GetItem(ditem.ItemNo));
        if StyleNo<>LastDrawnStyle then begin
          LastDrawnStyle := StyleNo;
          RVStyle.ApplyStyle(FormatCanvas, StyleNo, GetParaBiDiMode(GetItemParaEx(ditem.ItemNo)),
            True, nil, False, FormatCanvas<>Canvas); 
        end;
        BiDiMode := GetParaBiDiMode(GetItemParaEx(ditem.ItemNo));
        List := GetItem(ditem.ItemNo).WordPaintList;
        for j := 0 to List.Count-1 do begin
          Offs1 := List[j].StartOffs;
          Offs2  := Offs1+List[j].Length;
          if (ditem.Offs>Offs2) or (ditem.Offs+ditem.Length<Offs1) then
            continue;
          GetSubItemRect(i, Offs1, Offs2-1, StyleNo, ditem, r);
          if FormatCanvas<>Canvas then begin
            r.Left := RVConvertFromFormatCanvas(r.Left, True);
            r.Right := RVConvertFromFormatCanvas(r.Right, True);
          end;
          OffsetRect(r, ditem.Left+ditem.SpaceAtLeft-xshift, ditem.Top-yshift);
          List[j].Draw(Canvas, ditem, Self, r, j);
        end;
      end;
    end;
  end;
  {$ENDIF}
  {.......................................................}
  procedure PaintAsBitmap(X, Y: Integer; DrawItem: TRVDrawLineInfo;
    Item: TCustomRVItemInfo);
  var bmp: TBitmap;
  begin
    bmp := TBitmap.Create;
    try
      bmp.Width := Item.GetImageWidth(RVStyle);
      bmp.Height := Item.GetImageHeight(RVStyle);
      Item.PrintToBitmap(bmp, False, GetParentControl as TCustomRichView, DrawItem,
        -1, rvcmColor);
      RV_PictureToDevice(Canvas,
        X+RVStyle.GetAsPixels(Item.GetBorderWidth),
        Y+RVStyle.GetAsPixels(Item.GetBorderHeight),
        Item.GetImageWidth(RVStyle), Item.GetImageHeight(RVStyle),
        nil, bmp, False, RVStyle.GraphicInterface);
    finally
      bmp.Free;
    end;
  end;
  {.......................................................}
  procedure DrawNonText(AllowDrawPlaceHolder: Boolean);
  var DrawState: TRVItemDrawStates;
      Left, Top: Integer;
  begin
    DrawState := DefaultDrawState;
    if not PrintMode and (((StartNo<=i) and (EndNo>=i) and
      not ((EndNo=i) and (EndOffs=0)) and
      not ((StartNo=i) and (StartOffs=1))) or
      (rvstCompletelySelected in State)) then
      Include(DrawState,rvidsSelected);
    if PrintMode then
      Include(DrawState,rvidsPrinting);
    if (rvstDrawHover in State) and
       (LastJumpMovedAbove<>-1) and (li.JumpID = LastJumpMovedAbove) and
       li.GetBoolValueEx(rvbpJump, RVStyle) then
      Include(DrawState, rvidsHover);
    if GetParaBiDiMode(GetItemParaEx(dli.ItemNo))=rvbdRightToLeft then
      Include(DrawState, rvidsRTL);
    if ShowSpecialCharacters then
      Include(DrawState, rvidsShowSpecialCharacters);
    if (li = FActiveItem) then
      Include(DrawState, rvidsCurrent);
    if (rvflCanUseCustomPPI in Flags) then
      Include(DrawState, rvidsCanUseCustomPPI);
    if InplaceOnMainCanvas then
      Include(DrawState, rvidsDrawInplaceOnMainCanvas);
    if PrintMode then
      Include(DrawState, rvidsPrintSimulation);
    if not li.GetBoolValue(rvbpFullWidth) then begin
      // controls, pictures, bullets, hotspots, etc.
        if (rvidsSelected in DrawState) and UseLineSelection(dli)
          {$IFNDEF RVDONOTUSELISTS} and (li.StyleNo<>rvsListMarker) {$ENDIF}
          then begin
          if rvidsControlFocused in DefaultDrawState then
            Canvas.Brush.Color := RVStyle.SelColor
          else
            Canvas.Brush.Color := RVStyle.InactiveSelColor;
          if Canvas.Brush.Color<>clNone then begin
            Canvas.Brush.Style := bsSolid;
            RVStyle.GraphicInterface.FillRect(Canvas,
              Rect(dli.Left-xshift, LineTopY-yshift,
                dli.Left-xshift+dli.Width, LineBottomY-yshift));
          end;
          Canvas.Brush.Style := bsClear;
        end;
      if dli is TRVFloatingDrawLineInfo then begin
        Left := TRVFloatingDrawLineInfo(dli).FloatLeft-xshift;
        Top  := TRVFloatingDrawLineInfo(dli).FloatTop-yshift;
        if AllowDrawPlaceHolder and not PrintMode and
          (RVStyle.FloatingLineColor<>clNone) and
          (
            (li=FActiveItem) or
            (
              ShowSpecialCharacters and
              (rvcFloatingLines in RVVisibleSpecialCharacters)
            )
          ) then begin
          Canvas.Pen.Width := 1;
          Canvas.Pen.Style := psSolid;
          Canvas.Pen.Color := RVStyle.FloatingLineColor;
          RVStyle.GraphicInterface.Line(Canvas,
            dli.Left-xshift, dli.Top-yshift,
            dli.Left-xshift, dli.Top+dli.Height-yshift);
          RVDrawLineBetweenRects(Left, Top,
            TRVFloatingDrawLineInfo(dli).FloatWidth,
            TRVFloatingDrawLineInfo(dli).FloatHeight,
            dli.Left-xshift, dli.Top-yshift,
            dli.Width, 0, Canvas, RVStyle.GraphicInterface);
        end;
        end
      else begin
        Left := dli.Left-xshift;
        Top  := dli.Top-yshift;
      end;
      if PrintMode and li.GetBoolValueEx(rvbpPrintToBMP, RVStyle) then
        PaintAsBitmap(Left, Top, dli, li)
      else
        li.Paint(Left, Top, Canvas, DrawState, RVStyle, dli)
      end
    else begin
      // breaks, tables
      if rvoClientTextWidth in Options then
        fullwidth := GetWidth
      else begin
        fullwidth := GetAreaWidth;
        if (GetMaxTextWidth>0) and (GetMaxTextWidth+GetLeftMargin+GetRightMargin<fullwidth) then
          fullwidth := GetMaxTextWidth+GetLeftMargin+GetRightMargin;
      end;
      li.PaintFullWidth(dli.Left-xshift+ExtraXOffs, fullwidth-GetRightMargin-xshift+ExtraXOffs,
        dli.Top-yshift+ExtraYOffs, Canvas, DrawState, RVStyle, AClipRect, dli,
        ExtraXOffs, ExtraYOffs);
    end;
  end;
  {.......................................................}

  var
    //TextDrawState: TRVTextDrawStates;
    LastDLine2: Integer;
    FontHandle: HFont;
    ParaNo, StyleNo: Integer;
begin
  FormatCanvas := GetFormatCanvasEx(Canvas);
  RVStyle := GetRVStyle;
  GetSelBounds(StartNo, EndNo, StartOffs, EndOffs, True);
  ShiftedClipRect := AClipRect;

  yshift := GetVOffs;
  xshift := GetHOffs;
  OffsetRect(ShiftedClipRect,xshift,yshift);
  inc(yshift, AClipRect.Top+ExtraYOffs);
  inc(xshift, AClipRect.Left+ExtraXOffs);
  OffsetRect(AClipRect,-AClipRect.Left,-AClipRect.Top);
  Canvas.Brush.Style := bsClear;
  LastDrawnStyle := -1;
  BiDiMode       := rvbdUnspecified;
  DefaultTextDrawState := [];
  DefaultDrawState := [];
  ShowSpecialCharacters := CanShowSpecialCharacters and not PrintMode;
  if TRVScroller(GetParentControl).FocusedEx then begin
    Include(DefaultTextDrawState, rvtsControlFocused);
    Include(DefaultDrawState, rvidsControlFocused);
  end;
  if not TRVScroller(GetParentControl).EnabledEx then begin
    Include(DefaultTextDrawState, rvtstControlDisabled);
    Include(DefaultDrawState, rvidsControlDisabled);
  end;
   {
  if GetMaxTextWidth<>0 then begin
    Canvas.Pen.Color := clBtnFace;
    Canvas.MoveTo(GetLeftMargin+GetMaxTextWidth-xshift, AClipRect.Top);
    Canvas.LineTo(GetLeftMargin+GetMaxTextWidth-xshift, AClipRect.Bottom);
  end;
   }

  FirstDLine := GetFirstVisible(ShiftedClipRect.Top);
  if FirstDLine<0 then
    exit;
  LastDLine  := DrawItems.Count-1;

  // drawing floating items from above
  if FirstDLine>0 then
    FloatingDrawItems := TRVFloatingDrawItems.Create
  else
    FloatingDrawItems := nil;
  try
    if StrictTop then
      AdjustFirstDLine;
    DrawParagraphsBacks;
    if FloatingDrawItems<>nil then begin
      FloatingDrawItems.FillFloatingAboveDrawItem(FirstDLine, DrawItems);
      for i := 0 to FloatingDrawItems.Count-1 do begin
        dli := FloatingDrawItems[i];
        if (dli.ItemNo>=MinItemNo) and (dli.ItemNo<=MaxItemNo) then begin
          li := GetItem(dli.ItemNo);
          DrawNonText(False);
        end;
      end;
    end;
  finally
    FloatingDrawItems.Free;
  end;
  // drawing items...
  if Assigned(RVStyle.OnDrawTextBack) then
    DrawTextBacks;
  // drawing soft page breaks
  if (SoftPageBreaks<>nil) and (rvoShowPageBreaks in Options) then
    DrawSoftPageBreaks;
  LineTopY := 0;
  LineBottomY := 0;
  LastDLine2 := LastDLine;
  for i:= FirstDLine to LastDLine2 do begin
    dli := DrawItems[i];
    if StrictBottom and (dli.Top+dli.Height>ShiftedClipRect.Bottom) then
      continue;
    if (dli.ItemNo<MinItemNo) then
      continue;
    if (dli.ItemNo>MaxItemNo) then
      break;
    LastDLine := i;
    if dli.FromNewLine and UseLineSelection(dli) then
      GetLineVerticalBounds(i, LineTopY, LineBottomY);
    li := GetItem(dli.ItemNo);
    StyleNo := GetActualStyle(li);
    ParaNo := GetItemParaEx(dli.ItemNo);
    if (rvioPageBreakBefore in li.ItemOptions) and
       (rvoShowPageBreaks in Options) and
       ((i=0) or (DrawItems[i-1].ItemNo<>dli.ItemNo))
       then begin
      RVStyle.DrawPageBreak(Canvas, GetLineTopY(i)-yshift-1, xshift,
        rvpbPageBreak, GetParentControl, Self, dli.ItemNo);
      LastDrawnStyle := -1;
    end;
    if not PrintMode and (li.Checkpoint<>nil) and (rvoShowCheckpoints in Options) and
       ((i=0) or (DrawItems[i-1].ItemNo<>dli.ItemNo)) then begin
      RVStyle.DrawCheckpoint(Canvas, dli.Left-xshift, dli.Top-yshift,
        0, GetParentControl.Width,
        Self, dli.ItemNo, xshift, li.Checkpoint.RaiseEvent,
        GetParentControl);
      LastDrawnStyle := -1;
    end;
    if li.GetBoolValueEx(rvbpJump, RVStyle) then
      DoDrawHyperlink(Self, dli.ItemNo,
        Bounds(dli.Left, dli.Top, dli.Width, dli.Height));
    if StyleNo>=0 then begin { text }
      if StyleNo<>LastDrawnStyle then begin
        LastDrawnStyle := StyleNo;
        RVStyle.ApplyStyle(Canvas, StyleNo, GetParaBiDiMode(ParaNo), True,
          nil, False, FormatCanvas<>Canvas);
      end;
      BiDiMode := GetItemBiDiMode(dli.ItemNo);
      HoverNow := RVStyle.TextStyles[StyleNo].Jump and (rvstDrawHover in State) and
                 (LastJumpMovedAbove<>-1) and (li.JumpID = LastJumpMovedAbove);
      if PrintMode or (((StartNo>i) or (EndNo<i)) and
         not (rvstCompletelySelected in State)) then begin {not selected}
        DrawText(dli.Left, dli.Top, dli.Width, 1, i, StyleNo,
          RV_ReturnProcessedString(DrawItems.GetString(i,Items),
            RVStyle.TextStyles[StyleNo], IsDrawItemLastOnWrappedLine(i),
            ShowSpecialCharacters, True),
          True, True, False,True);
        end
      else if (rvstCompletelySelected in State) or
          (((StartNo<i) or ((StartNo=i) and (StartOffs<=1))) and {selected completely}
           (((EndNo>i)) or ((EndNo=i) and (EndOffs>DrawItems[i].Length)))) then begin
        DrawText(dli.Left, dli.Top, dli.Width, 1, i, StyleNo,
          RV_ReturnProcessedString(DrawItems.GetString(i,Items),
            RVStyle.TextStyles[StyleNo], IsDrawItemLastOnWrappedLine(i),
            ShowSpecialCharacters, True),
          True, True, True, True);
        end
      else begin { selected partially }
        DrawText(dli.Left, dli.Top, dli.Width, 1, i, StyleNo,
          RV_ReturnProcessedString(DrawItems.GetString(i,Items),
            RVStyle.TextStyles[StyleNo], IsDrawItemLastOnWrappedLine(i),
            ShowSpecialCharacters, True),
          True, True, False,True);
        if (i<>StartNo) or (StartOffs<=1) then
          ditemselstart := 1
        else
          ditemselstart := StartOffs;
        if (i<>EndNo) or (EndOffs>dli.Length) then
          ditemselend := dli.Length
        else
          ditemselend := EndOffs-1;
        if ditemselend<ditemselstart then begin
          if ShowSpecialCharacters and (rvscParagraph in RVVisibleSpecialCharacters) then begin
            {$IFDEF RVDRAWPARAMARKSBEFORE}
            DrawParaMark(i, False);
            {$ENDIF}
            DrawParaMark(i, True);
          end;
          continue;
        end;
        s  := DrawItems.GetString(i,Items);
        if BiDiMode<>rvbdUnspecified then begin
          ditemselstart2 := ditemselstart;
          ditemselend2   := ditemselend+1;
          s := RV_ReturnProcessedStringEx(s, RVStyle.TextStyles[StyleNo],
            (ditemselend>=GetOffsAfterDrawItem(i)) and IsDrawItemLastOnWrappedLine(i),
            ShowSpecialCharacters, True, ditemselstart2, ditemselend2);
          RVStyle.ApplyStyleColor(Canvas, StyleNo, GetSelDrawState, False, rvcmColor);
          if InplaceOnMainCanvas and (FormatCanvas<>Canvas) then begin
            RVStyle.GraphicInterface.SetTextAlign(FormatCanvas,
              RVStyle.GraphicInterface.GetTextAlign(Canvas));
            RVStyle.GraphicInterface.SetTextCharacterExtra(FormatCanvas,
              RVStyle.GraphicInterface.GetTextCharacterExtra(Canvas));
            FontHandle := RVStyle.GraphicInterface.SetFontHandle(FormatCanvas,
              RVStyle.GraphicInterface.GetFontHandle(Canvas));
            end
          else
            FontHandle := 0;
          try
            res := RVU_DrawSelectedTextEx(dli.Left+dli.SpaceAtLeft-xshift,
              dli.Top-yshift, dli.Width-dli.SpaceAtLeft,
              s, Canvas, FormatCanvas, ditemselstart2, ditemselend2-1, li.ItemOptions,
              BiDiMode, Canvas<>FormatCanvas, RVStyle.GraphicInterface);
          finally
            if FontHandle<>0 then begin
              RVStyle.GraphicInterface.SetFontHandle(FormatCanvas, FontHandle);
            end;
          end;
          end
        else
          res := False;
        if not res then begin
          if InplaceOnMainCanvas and (FormatCanvas<>Canvas) then begin
            RVStyle.GraphicInterface.SetTextAlign(FormatCanvas,
              RVStyle.GraphicInterface.GetTextAlign(Canvas));
            RVStyle.GraphicInterface.SetTextCharacterExtra(FormatCanvas,
              RVStyle.GraphicInterface.GetTextCharacterExtra(Canvas));
            FontHandle := RVStyle.GraphicInterface.SetFontHandle(FormatCanvas,
              RVStyle.GraphicInterface.GetFontHandle(Canvas));
            Canvas2 := FormatCanvas;
            end
          else begin
            Canvas2 := Canvas;
            FontHandle := 0;
          end;
          try
            if ditemselstart>1 then begin
              s := DrawItems.GetSubString(i, Items, 1, ditemselstart-1);
              s  := RV_ReturnProcessedString(s, RVStyle.TextStyles[StyleNo], False,
                ShowSpecialCharacters, True);
              fullwidth := RVConvertFromFormatCanvas(
                RVU_TextWidth(s, Canvas2, li.ItemOptions, RVStyle.GraphicInterface),
                FormatCanvas<>Canvas);
              end
            else
              fullwidth := 0;
            s := DrawItems.GetSubString(i, Items, ditemselstart, ditemselend-ditemselstart+1);
            s := RV_ReturnProcessedString(s, RVStyle.TextStyles[StyleNo],
              (ditemselend+1>=GetOffsAfterDrawItem(i)) and IsDrawItemLastOnWrappedLine(i),
                ShowSpecialCharacters, True);
            //if Assigned(RVStyle.OnDrawStyleText) or
            //  (RVStyle.SelectionStyle=rvssLines) then begin
              selwidth := RVConvertFromFormatCanvas(
                RVU_TextWidth(s, Canvas2, li.ItemOptions, RVStyle.GraphicInterface),
                FormatCanvas<>Canvas);              
            //  end
            //else
            //  selwidth := 0;
          finally
            if FontHandle<>0 then
              RVStyle.GraphicInterface.SetFontHandle(FormatCanvas, FontHandle);
          end;
          DrawText(dli.Left+fullwidth, dli.Top, selwidth, ditemselstart, i, StyleNo,
                   s, ditemselstart<=1, ditemselend>=dli.Length, True, False);
        end;
      end;
      if ShowSpecialCharacters and
        (rvscParagraph in RVVisibleSpecialCharacters) then begin
        {$IFDEF RVDRAWPARAMARKSBEFORE}
        DrawParaMark(i, False);
        {$ENDIF}
        DrawParaMark(i, True);
      end;
      continue;
    end;
    DrawNonText(True);
    if ShowSpecialCharacters and (rvscParagraph in RVVisibleSpecialCharacters) then begin
      {$IFDEF RVDRAWPARAMARKSBEFORE}
      DrawParaMark(i, False);
      {$ENDIF}
      DrawParaMark(i, True);
    end;
    if li.GetBoolValue(rvbpDrawingChangesFont) then
      LastDrawnStyle := -1;
  end;
  {$IFNDEF RVDONOTUSELIVESPELL}
  if not PrintMode then
    DrawWordPainters;
  {$ENDIF}
  if not PrintMode and (NotAddedCP<>nil) and (rvoShowCheckpoints in Options) and
    (Items.Count-1<=MinItemNo) and (Items.Count-1<=MaxItemNo) then
    RVStyle.DrawCheckpoint(Canvas, -1, DocumentHeight-yshift-GetBottomMargin,
      0, GetParentControl.Width,
      Self, -1, xshift, NotAddedCP.RaiseEvent, GetParentControl);
  PostPaintTo(Canvas, xshift, yshift, FirstDLine, LastDLine,
    PrintMode, StrictTop, StrictBottom);
  {$IFDEF RVWATERMARK}
  if rvflRoot in Flags then begin
    Canvas.Brush.Style := bsClear;
    Canvas.Font.Name := 'Arial';
    Canvas.Font.Size := 8;
    Canvas.Font.Style := [];
    Canvas.Font.Color := clRed;
    Canvas.TextOut(-xshift+GetWidth-80, -yshift, 'unregistered');
  end;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.GetItemBackground(ItemNo: Integer; r: TRect;
  MakeImageRect: Boolean;
  var Color: TColor; var bmp: TBitmap; var UseBitmap: Boolean;
  GraphicInterface: TRVGraphicInterface);
var item: TRVRectItemInfo;
    ditem: TRVDrawLineInfo;
    RVStyle: TRVStyle;
begin
  UseBitmap := False;
  Color := GetRVStyle.ParaStyles[GetItemParaEx(ItemNo)].Background.Color;
  if Color<>clNone then
    exit;
  Color := GetColor;
  if (GetBackground=nil) or (GetBackground.Style=bsNoBitmap) then
    exit;
  if bmp=nil then
    bmp := TBitmap.Create;
  item := TRVRectItemInfo(GetItem(ItemNo));
  if (item.DrawItemNo<0) or (item.DrawItemNo>=DrawItems.Count) then
    exit;
  UseBitmap := True;
  ditem := DrawItems[item.DrawItemNo];
  RVStyle := GetRVStyle;
  if MakeImageRect then
    r := Bounds(
      ditem.Left+RVStyle.GetAsPixels(item.GetBorderWidth),
      ditem.Top+RVStyle.GetAsPixels(item.GetBorderHeight),
      item.GetImageWidth(RVStyle), item.GetImageHeight(RVStyle));
  bmp.Width := r.Right-r.Left;
  bmp.Height := r.Bottom-r.Top;
  bmp.Canvas.Brush.Style := bsSolid;
  bmp.Canvas.Brush.Color := Color;
  GraphicInterface.FillRect(bmp.Canvas, Rect(0,0,bmp.Width,bmp.Height));
  OffsetRect(r, -GetHOffs, -GetVOffs);
  DrawBackground(bmp.Canvas, r, GraphicInterface);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.PostPaintTo(Canvas: TCanvas;
  HOffs, VOffs, FirstDrawItemNo, LastDrawItemNo: Integer;
  PrintMode, StrictTop, StrictBottom: Boolean);
begin

end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.MouseLeave;
var id: Integer;
begin
  if not (rvflUseJumps in Flags) then
    exit;
  if LastRVDataMovedAbove<>nil then
    id := LastRVDataMovedAbove.LastJumpMovedAbove
  else
    id := -1;
  ClearLastJump;
  if id<>-1 then
    InvalidateJumpRect(id);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.InvalidateJumpRect(id: Integer);
var rec: TRect;
    i : Integer;
begin
   if GetRVStyle.FullRedraw then
     Invalidate
   else begin
     for i:=0 to Jumps.Count -1 do
       if id = TRVJumpInfo(Jumps[i]).id then
         with TRVJumpInfo(Jumps[i]) do begin
           rec := Bounds(l-GetHOffs-5, t-GetVOffs-5, w+10, h+10);
           InvalidateRect(rec);
         end;
   end;
   UpdateView;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.Invalidate;
begin
  if GetParentControl<>nil then
    GetParentControl.Invalidate;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.Refresh;
begin
  if GetParentControl<>nil then
    GetParentControl.Refresh;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.UpdateView;
begin
  if GetParentControl<>nil then
    GetParentControl.Update;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.InvalidateRect(const r: TRect);
begin
  if (GetParentControl<>nil) and GetParentControl.HandleAllocated and (GetRVStyle<>nil) then begin
    GetRVStyle.GraphicInterface.InvalidateRect(GetParentControl, @r);
    if Assigned(TCustomRVFormattedData(GetAbsoluteRootData).OnRepaint) then
      TCustomRVFormattedData(GetAbsoluteRootData).OnRepaint(GetParentControl, rvrrInvalidate, @r);
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.SearchHotItem(X,Y,HOffs,VOffs: Integer);
begin
  if FCaptureMouseItem<>nil then
    exit;
  inc(X, HOffs);
  inc(Y, VOffs);
  if (LastDIMovedAbove<>-1) then
   if (LastDIMovedAbove>=DrawItems.Count) then
     LastDIMovedAbove := -1
   else
     with DrawItems[LastDIMovedAbove] do
       if not RV_PointInRect(X,Y, Left,Top-ExtraSpaceAbove,Width,Height) then
         LastDIMovedAbove := -1;
  if LastDIMovedAbove=-1 then
    LastDIMovedAbove := FindDrawItemAtPos(X,Y);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.MouseMove(Shift: TShiftState; X, Y: Integer);
var  JumpFound: Boolean;
     VOffs, HOffs: Integer;
    //SelRect: TRect;
    {...................................................}
    procedure DisplayRVDataHint;
    begin
      if rvoShowItemHints in GetOptions then
        SetControlHint(GetItemHint(Self, -1, ''));
    end;
    {...................................................}
    function MouseMoveHotItem(HOffs,VOffs: Integer): Boolean;
    {$IFNDEF RVDONOTUSEDRAGDROP}
    var DItemNo, DItemOffs: Integer;
    {$ENDIF}
    var Cursor: TCursor;
    begin
      SearchHotItem(X,Y,HOffs,VOffs);
      if (LastDIMovedAbove<>-1) then
        with DrawItems[LastDIMovedAbove] do begin
          Result := GetItem(ItemNo).MouseMove(Shift,
            X-(Left-GetHOffs),Y-(Top-GetVOffs), ItemNo, Self);
          {$IFNDEF RVDONOTUSEDRAGDROP}
          if not Result and not (ssShift in Shift) and CanStartDragging then begin
            FindDrawItemForSel(X+HOffs, Y+VOffs, DItemNo, DItemOffs, True, False);
            if (DItemNo>=0) and DItem_InsideSelection(DItemNo, DItemOffs, True) then begin
              SetCursor(crArrow);
              Result := True;
            end;
          end;
          {$ENDIF}
          if not Result then begin
            Cursor := crNone;
            DoGetItemCursor(Self, ItemNo, Cursor);
            Result := Cursor<>crNone;
            if Result then
              SetCursor(Cursor);
          end;
        end
      else begin
        if not (rvstMakingSelection in State) then
          DisplayRVDataHint;
        Result := False;
      end;
    end;
    {...................................................}
    function IsSelectionChanged(OldSelStartNo, OldSelStartOffs,
      OldSelEndNo, OldSelEndOffs: Integer): Boolean;
    begin
      Result := (OldSelStartNo<>FSelStartNo) or
        (OldSelStartOffs<>FSelStartOffs) or
        (OldSelEndNo<>FSelEndNo) or
        (OldSelEndOffs<>FSelEndOffs);
    end;
    {...................................................}
    procedure ChangeSelection;
    var xs,ys,VPos,HPos,Width,Height: Integer;
        OldSelStartNo, OldSelStartOffs, OldSelEndNo, OldSelEndOffs: Integer;
    begin
      HPos := GetHOffs;
      VPos := GetVOffs;
      if rvstMakingSelection in State  then begin
        OldSelStartNo := FSelStartNo;
        OldSelStartOffs := FSelStartOffs;
        OldSelEndNo := FSelEndNo;
        OldSelEndOffs := FSelEndOffs;
        ys := y;
        if not (rvflMouseXYAlwaysCorrect in Flags) then begin
          Height := GetHeight;
          if ys<0 then
            ys := 0
          else if ys>Height then
            ys := Height;
        end;
        xs := x;
        if not (rvflMouseXYAlwaysCorrect in Flags) then begin
          Width := GetWidth;
          if xs<0 then
            xs := 0
          else if xs>Width then
            xs := Width;
        end;
        if rvstLineSelection in State then begin
          if AdjustLineSelection(xs+HPos, ys+VPos) then begin
            ExpandSelectionToLines(False);
            if IsSelectionChanged(OldSelStartNo, OldSelStartOffs, OldSelEndNo, OldSelEndOffs) then begin
              DoOnSelection(False);
              Refresh;
            end;
          end;
          end
        else if AdjustSelectionByMode(xs+HPos, ys+VPos) then begin
          if IsSelectionChanged(OldSelStartNo, OldSelStartOffs, OldSelEndNo, OldSelEndOffs) then begin
            DoOnSelection(True);
            Refresh;
          end;
        end;
      end;
    end;
    {...................................................}
    function HighlightJump: Boolean;
    var i,HPos, VPos: Integer;
        item: TCustomRVItemInfo;
    begin
      HPos := GetHOffs;
      VPos := GetVOffs;
      for i:=0 to jumps.Count-1 do
        with TRVJumpInfo(Jumps[i]) do
          if RV_PointInRect(X ,Y, l-HPos, t-VPos, w, h) then begin
            Result := True;
            SetCursor(TRVJumpInfo(Jumps[i]).Cursor);
            if (LastRVDataMovedAbove=nil) or (LastRVDataMovedAbove.LastJumpMovedAbove<>id) then
              DoRVMouseMove(id+FirstJumpNo);
            if (LastRVDataMovedAbove<>nil) and (rvstDrawHover in LastRVDataMovedAbove.State) and
               (LastRVDataMovedAbove.LastJumpMovedAbove<>id) then begin
              LastRVDataMovedAbove.State := LastRVDataMovedAbove.State - [rvstDrawHover];
              InvalidateJumpRect(LastRVDataMovedAbove.LastJumpMovedAbove);
            end;
            RVData.LastJumpMovedAbove := id;
            item := RVData.GetItem(RVData.DrawItems[DrawItemNo].ItemNo);
            item.MouseMove(Shift, X-(RVData.DrawItems[DrawItemNo].Left-HPos),
              Y-(RVData.DrawItems[DrawItemNo].Top-VPos),
              RVData.DrawItems[DrawItemNo].ItemNo, RVData);
            LastRVDataMovedAbove := RVData;
            if not (rvstDrawHover in RVData.State) then begin
              if not item.GetBoolValueEx(rvbpHotColdJump,GetRVStyle) then
                exit;
              RVData.State := RVData.State + [rvstDrawHover];
              InvalidateJumpRect(RVData.LastJumpMovedAbove);
            end;
            exit;
          end;
      Result := False;
    end;
    {...................................................}
begin
  if GetRVStyle=nil then exit;
  if (rvstMakingSelection in State) and not (ssLeft in Shift) then begin
    State := State-[rvstMakingSelection];
    FSelectingInfo.Free;
    FSelectingInfo := nil;
    //MouseUp(mbLeft, Shift, X, Y);
  end;
  HOffs := GetHOffs;
  VOffs := GetVOffs;
  ClearXorDrawing;
  if FCaptureMouseItem=nil then begin
    {$IFNDEF RVDONOTUSEDRAGDROP}
    if (rvstStartingDragDrop in GetAbsoluteRootData.State) and
      CanStartDragBecauseMouseMoved(X+HOffs, Y+HOffs) then begin
      PostMessage(GetAbsoluteRootData.GetParentControl.Handle, WM_RVDRAGDROP, 0, 0);
      exit;
    end;
    {$ENDIF}
    ChangeSelection;
    if (GetRVStyle.LineSelectCursor<>crNone) and not (rvstMakingSelection in State) and
      (GetBiDiMode<>rvbdRightToLeft) and
      (X+HOffs<GetLeftMargin) and (rvoAllowSelection in Options) then begin
      DisplayRVDataHint;
      SetCursor(GetRVStyle.LineSelectCursor)
      end
    else begin
      if rvflUseJumps in Flags then begin
        JumpFound := HighlightJump;
        if not JumpFound then begin
          if (LastRVDataMovedAbove<>nil) then begin
            LastRVDataMovedAbove.State := LastRVDataMovedAbove.State - [rvstDrawHover];
            InvalidateJumpRect(LastRVDataMovedAbove.LastJumpMovedAbove);
            LastRVDataMovedAbove.LastJumpMovedAbove := -1;
            LastRVDataMovedAbove := nil;
            DoRVMouseMove(-1);
          end;
          if not MouseMoveHotItem(HOffs,VOffs) then
            SetCursor(GetNormalCursor);
        end
        end
      else
        if not MouseMoveHotItem(HOffs,VOffs) then
          SetCursor(GetNormalCursor);
    end;
    end
  else
    if not MouseMoveHotItem(HOffs,VOffs) then
      SetCursor(GetNormalCursor);

  XorDrawingEx(X,Y);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.MouseDown(Button: TMouseButton; Shift: TShiftState;
                                           X, Y: Integer);
var i,StyleNo, ItemNo, Offs, Dummy, HOffs, VOffs: Integer;
    ClickedWord: TRVRawByteString;
    {$IFNDEF RVDONOTUSEDRAGDROP}
    ItemNo2, Offs2: Integer;
    {$ENDIF}
    RVData: TCustomRVFormattedData;
begin
 {$IFNDEF RVDONOTUSELIVESPELL}
  LiveSpellingCheckCurrentItem;
 {$ENDIF}
  HOffs := GetHOffs;
  VOffs := GetVOffs;
  begin
    SearchHotItem(X,Y, HOffs,VOffs);
    FClickedDrawItemNo := LastDIMovedAbove;
    if LastDIMovedAbove<>-1 then begin
      ItemNo := DrawItems[LastDIMovedAbove].ItemNo;
      if (FPartialSelectedItem<>GetItem(ItemNo)) and
         (GetChosenItem<>GetItem(ItemNo)) then begin
        DeselectPartiallySelectedItem(nil);
        if not (ssDouble in Shift) then
          Windows.SetFocus(GetParentControl.Handle);
      end;
      if LastDIMovedAbove<>-1 then
        with DrawItems[LastDIMovedAbove] do begin
           if (GetInplaceEditor<>nil) and
             not GetItem(ItemNo).OwnsInplaceEditor(GetInplaceEditor) then begin
               DestroyInplaceEditor;
               if not (ssDouble in Shift) then
                 Windows.SetFocus(GetParentControl.Handle);
             end;
           GetItem(ItemNo).MouseDown(Button, Shift, X-(Left-HOffs),Y-(Top-VOffs),
             ItemNo, Self);
        end;
      end
    else begin
      ItemNo := -1;
      DestroyInplaceEditor;
      if not (ssDouble in Shift) then
        Windows.SetFocus(GetParentControl.Handle);
    end;
    if (GetInplaceEditor=nil) and IsAssignedRVMouseDown then
      DoRVMouseDown(Button, Shift, ItemNo, X, Y);
    if (GetInplaceEditor=nil) and (Button=mbLeft) then begin
      LastJumpDowned := -1;
      for i:=0 to Jumps.Count-1 do
        with TRVJumpInfo(Jumps[i]) do
        if (X>=l-HOffs) and (X<=l+w-HOffs) and
           (Y>=t-VOffs) and (Y<=t+h-VOffs) then begin
          LastJumpDowned := id;
          break;
        end;
    end;
    if (FCaptureMouseItem<>nil) or (GetInplaceEditor<>nil) then begin
      if LastDIMovedAbove<>-1 then begin
        FSelStartNo := LastDIMovedAbove;
        FSelEndNo := LastDIMovedAbove;
        FSelStartOffs := 1;
        FSelEndOffs   := 1;
        DoOnSelection(True);
      end;
      exit;
    end;
  end;
  if (Button = mbLeft) and {not (rvstIgnoreNextMouseDown in State)}not (ssDouble in Shift) and not
     (rvstStartingDragDrop in GetAbsoluteRootData.State) then begin
    if (rvoSingleClick in Options) and IsAssignedRVDblClick  and
       FindWordAtR(Clickedword, X, Y, StyleNo, ItemNo, Dummy, RVData, True) then
      DoRVDblClick(ClickedWord, StyleNo);
    if (rvoAllowSelection in Options) and  (ssLeft in Shift) then begin
      State := State - [rvstLineSelection];
      DeselectPartiallySelectedItem(nil);
      GetSelStart(FSelStartNo,FSelStartOffs);
      FindDrawItemForSel(X+HOffs, Y+VOffs, ItemNo, Offs, False, False);
      {$IFNDEF RVDONOTUSEDRAGDROP}
      ItemNo2 := -1;
      if DItem_InsideSelection(ItemNo, Offs, True) then
        FindDrawItemForSel(X+HOffs, Y+VOffs, ItemNo2, Offs2, True, False);
      if (ItemNo2>=0) and not (ssShift in Shift) and (X+HOffs>=GetLeftMargin) and
         DItem_InsideSelection(ItemNo2, Offs2, True) and CanStartDragging then begin
        GetAbsoluteRootData.State := GetAbsoluteRootData.State+[rvstStartingDragDrop];
        //PostMessage(GetAbsoluteRootData.GetParentControl.Handle, WM_RVDRAGDROP, 0, 0);
        SetClickCoords(X+HOffs, Y+HOffs);
        end
      else
      {$ENDIF}
      begin
        FSelEndNo := ItemNo;
        FSelEndOffs := Offs;
        if not (ssShift in Shift) or (FSelStartNo=-1) then begin
          FSelStartNo   := FSelEndNo;
          FSelStartOffs := FSelEndOffs;
        end;
        if (FSelEndNo<>-1) then begin
          State := State + [rvstMakingSelection];
          FSelectingInfo.Free;
          FSelectingInfo := nil;
          if (GetRVStyle.LineSelectCursor<>crNone) and (GetBiDiMode<>rvbdRightToLeft) and
             (X+HOffs<GetLeftMargin) and
             not (ssShift in Shift) then begin
            State := State + [rvstLineSelection];
            ExpandSelectionToLines(True);
            end
          else begin
            if (GetRVStyle.SelectionMode in [rvsmWord, rvsmParagraph]) then begin
              FSelectingInfo := TRVSelectingInfo.Create;
              FSelectingInfo.DrawItemSOffs := FSelStartOffs;
              FSelectingInfo.DrawItemEOffs := FSelStartOffs;
              FSelectingInfo.DrawItemSNo   := FSelStartNo;
              if GetRVStyle.SelectionMode = rvsmParagraph then begin
                FSelectingInfo.InitE(rvsesParaMode);
                if ssShift in Shift then
                  AdjustSelectionByMode(X+HOffs, Y+VOffs);
                end
              else begin
                if InsideWord(FSelStartNo, FSelStartOffs) then begin
                  GetWordBounds(FSelStartNo, FSelStartOffs,
                    FSelectingInfo.DrawItemSWordOffs1, FSelectingInfo.DrawItemSWordOffs2);;
                  FSelectingInfo.InitE(rvsesInWord)
                  end
                else
                  FSelectingInfo.InitE(rvsesFreeMode);
              end;
            end;
          end;
          end
        else
          State := State - [rvstMakingSelection];
        DoOnSelection(not (rvstMakingSelection in State));
        Invalidate;
      end;
      //LastSelectionRect := GetClientSelectionRect;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.MouseUp(Button: TMouseButton; Shift: TShiftState;
                                   X, Y: Integer);
var i, StyleNo, no, xs, ys: Integer;
    ClickedWord: TRVRawByteString;
    p: TPoint;
    DoNotJump: Boolean;
    ItemNo, Dummy: Integer;
    HOffs, VOffs, Width, Height: Integer;
    RVData: TCustomRVFormattedData;
    {............................................................}
    procedure ResetSelection(OnlyIfCursorInside: Boolean);
    var  ASelStartNo, ASelEndNo, ASelStartOffs, ASelEndOffs: Integer;
         ItemNo, ItemOffs: Integer;
    begin
      GetSelBounds(ASelStartNo, ASelEndNo, ASelStartOffs, ASelEndOffs, True);
      FindDrawItemForSel(X+HOffs, Y+VOffs, ItemNo, ItemOffs, False, False);
      if (ItemNo<>-1) and
         not OnlyIfCursorInside or
         ((((ItemNo<ASelStartNo) or ((ItemNo=ASelStartNo) and (ItemOffs<ASelStartOffs))) or
         ((ItemNo>ASelEndNo)    or ((ItemNo=ASelEndNo)   and (ItemOffs>ASelEndOffs))))) then begin
        FSelStartNo   := ItemNo;
        FSelStartOffs := ItemOffs;
        FSelEndNo   := ItemNo;
        FSelEndOffs := ItemOffs;
        AdjustMouseUpSelection;
        DoOnSelection(True);
        if SelectionExists(False, False) then
          ChooseMe;
        Refresh;
        DoSelect;
      end;
    end;
    {............................................................}
begin
  HOffs := GetHOffs;
  VOffs := GetVOffs;
  Height := GetHeight;
  Width := GetWidth;
  if (Button=mbLeft) and (rvstStartingDragDrop in GetAbsoluteRootData.State) then begin
    GetAbsoluteRootData.State := GetAbsoluteRootData.State-[rvstStartingDragDrop];
    ResetSelection(False);
  end;
  DoNotJump := SelectionExists(True, True);
  {$IFDEF RVMUDESELECT}
  if rvstMidSelClicked in State then begin
    State := State - [rvstMidSelClicked];
    Deselect(nil, True);
    Invalidate;
  end;
  {$ENDIF}
  if FCaptureMouseItem=nil then begin
    //State := State - [rvstIgnoreNextMouseDown];
    if (rvstMakingSelection in State) and (Button = mbLeft) then begin
      ys := y;
      if not (rvflMouseXYAlwaysCorrect in Flags) then
        if ys<0 then
          ys := 0
        else if ys>Height then
          ys := Height;
      xs := x;
      if not (rvflMouseXYAlwaysCorrect in Flags) then
        if xs<0 then
          xs := 0
        else if xs>Width then
          xs := Width;
      if rvstLineSelection in State then
        AdjustLineSelection(xs+HOffs, ys+VOffs)
      else
        AdjustSelectionByMode(xs+HOffs, ys+VOffs);
      State := State - [rvstMakingSelection, rvstLineSelection];
      FSelectingInfo.Free;
      FSelectingInfo := nil;
      SearchHotItem(X,Y, HOffs,VOffs);
      AdjustMouseUpSelection;
      DoOnSelection(True);
      if SelectionExists(False, False) then
        ChooseMe;
      Invalidate;
      DoSelect;
    end;
    if (rvoRClickDeselects in Options) and (Button = mbRight) then
      ResetSelection(True);
  end;

  SearchHotItem(X,Y, HOffs,VOffs);
  if LastDIMovedAbove<>-1 then begin
    ItemNo := DrawItems[LastDIMovedAbove].ItemNo;
    with DrawItems[LastDIMovedAbove] do
      GetItem(ItemNo).MouseUp(Button, Shift, X-(Left-HOffs),Y-(Top-VOffs),
        ItemNo, Self);
    end
  else
    ItemNo := -1;
  if FCaptureMouseItem<>nil then exit;
  if not DoNotJump and
     (Button in [mbLeft, mbRight]) and
     (ItemNo<>-1) and
     GetItem(ItemNo).GetBoolValueEx(rvbpAllowsFocus, GetRVStyle) and
     (GetRootData is TRVControlData) and
     (TRVControlData(GetRootData).TabNavigation<>rvtnNone)
   then begin
     AdjustFocus(ItemNo, Self, ItemNo);
     GetItem(ItemNo).Focusing;
  end;
  if IsAssignedRVMouseUp then
    DoRVMouseUp(Button, Shift, ItemNo, X, Y);
  if (Button = mbRight) and IsAssignedRVRightClick and
     FindWordAtR(ClickedWord, X,Y, StyleNo,no, Dummy, RVData, True) then begin
    p := ClientToScreen(Point(X,Y));
    DoRVRightClick(ClickedWord, StyleNo, p.X, p.Y);
  end;
  if Button <> mbLeft then exit;
  if (LastJumpDowned=-1) or not IsAssignedJump or DoNotJump then
    exit;
  for i:=0 to Jumps.Count-1 do
    with TRVJumpInfo(Jumps[i]) do
      if (LastJumpDowned=id) and
         (X>=l-HOffs) and (X<=l+w-HOffs) and
         (Y>=t-VOffs) and (Y<=t+h-VOffs) then begin
        LastJumpDowned:=-1;
        DoJump(id+FirstJumpNo);
        exit;
      end;
  LastJumpDowned:=-1;
  FClickedDrawItemNo :=-1;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.DblClick;
var p: TPoint;
begin
  GetCursorPos(p);
  p := ScreenToClient(p);
  DblClickAt(p);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.DblClickAt(const p: TPoint);
var
  StyleNo, ItemNo, Offs: Integer;
  ClickedWord: TRVRawByteString;
  RVData: TCustomRVFormattedData;
begin
  if (not (rvoSingleClick  in Options) and IsAssignedRVDblClick) or
     (rvoDblClickSelectsWord in Options) then begin
    if (rvoDblClickSelectsWord in Options) and (rvoAllowSelection in Options) then begin
      if FindWordAtR(ClickedWord, p.X, p.Y, StyleNo, ItemNo, Offs, RVData, True) then begin
        if StyleNo>=0 then
          RVData.SetSelectionBounds(ItemNo, Offs, ItemNo,
            Offs+RVU_Length(clickedword,RVData.GetItemOptions(ItemNo)))
        else
          RVData.SetSelectionBounds(ItemNo, 0, ItemNo, 1);
        RVData.ChooseMe;
        //RVData.State := RVData.State + [rvstIgnoreNextMouseDown];
        RVData.State := RVData.State - [rvstMakingSelection];
        Invalidate;
        State := State - [rvstMakingSelection];
        DoRVDblClick(ClickedWord, StyleNo);
        //State := State + [rvstIgnoreNextMouseDown];
      end;
      exit;
    end;
    if IsAssignedRVDblClick and
       FindWordAtR(ClickedWord, p.X, p.Y, StyleNo, ItemNo, Offs, RVData, True) then
       DoRVDblClick(ClickedWord, StyleNo);
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.TripleClick;
var StartItemNo, StartItemOffs, EndItemNo, EndItemOffs: Integer;
begin
  if GetChosenRVData<>nil then
    TCustomRVFormattedData(GetChosenRVData).TripleClick
  else if (rvoDblClickSelectsWord in Options) and (rvoAllowSelection in Options) then begin
    GetSelectionBoundsEx(StartItemNo, StartItemOffs, EndItemNo, EndItemOffs, True);
    if StartItemNo<0 then
      exit;
    ExpandToParaEx(StartItemNo, EndItemNo, StartItemNo, EndItemNo);
    SetSelectionBounds(StartItemNo, GetOffsBeforeItem(StartItemNo),
      EndItemNo, GetOffsAfterItem(EndItemNo));
    Invalidate;    
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.DeleteItems(FirstItemNo, Count: Integer);
begin
  Deselect(nil, True);
  inherited DeleteItems(FirstItemNo, Count);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.DeleteParas(FirstItemNo, LastItemNo: Integer);
var FirstItemNo2, LastItemNo2,
    FirstDItemNo, LastDItemNo, tmp: Integer;
begin
  ExpandToPara(FirstItemNo, LastItemNo, FirstItemNo, LastItemNo);
  FirstItemNo2 := FirstItemNo;
  LastItemNo2  := LastItemNo;
  if FirstItemNo2>0 then
    dec(FirstItemNo2);
  if LastItemNo2<Items.Count-1 then
    inc(LastItemNo2);
  ExpandToParaEx(FirstItemNo2, LastItemNo2, FirstItemNo2, LastItemNo2);
  Item2FirstDrawItem(FirstItemNo2, FirstDItemNo);
  Item2FirstDrawItem(LastItemNo2, LastDItemNo);
  DeleteItems(FirstItemNo, LastItemNo-FirstItemNo+1);
  FormatParasExact(FirstDItemNo,LastDItemNo, - (LastItemNo-FirstItemNo+1), False);
  ClearJumps;  
  tmp := 0;
  BuildJumpsCoords(tmp, jumps);
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.SelectionExists(AllowReset: Boolean;UsePartialSelected: Boolean): Boolean;
var StartNo, EndNo, StartOffs, EndOffs: Integer;
begin
  {$IFNDEF RVDONOTUSEINPLACE}
  if (GetChosenRVData<>nil) then begin
    Result := TCustomRVFormattedData(GetChosenRVData).SelectionExists(AllowReset, UsePartialSelected);
    exit;
  end;
  {$ENDIF}
  if rvstMakingSelection in State then
    AllowReset := False;
  if UsePartialSelected and
     (FPartialSelectedItem<>nil) and
     FPartialSelectedItem.PartiallySelected then begin
    Result := True;
    exit;
  end;
  GetSelBounds(StartNo, EndNo, StartOffs, EndOffs, True);
  if (StartNo <> -1) and
    (
      ((StartNo=EndNo) and (StartOffs=EndOffs)) or
      ((StartNo+1=EndNo) and (StartOffs>=GetOffsAfterDrawItem(StartNo))
        and (EndOffs<=GetOffsBeforeDrawItem(EndNo)) and not IsDrawItemFromNewLine(EndNo))
    ) then begin
    if AllowReset then
      Deselect(FPartialSelectedItem, False);
    Result := False;
    exit;
  end;
  Result :=  (StartNo<>-1) and (EndNo<>-1);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.SetCursor(Cursor: TCursor);
begin
  GetParentControl.Cursor := Cursor;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.ClientToScreen(const p: TPoint): TPoint;
begin
  Result := GetParentControl.ClientToScreen(p);
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.ScreenToClient(const p: TPoint): TPoint;
begin
  Result := GetParentControl.ScreenToClient(p);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.GetSelStart(var DINo, DIOffs: Integer);
begin
  SelectionExists(True, False);
  DINo   := FSelStartNo;
  DIOffs := FSelStartOffs;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetSelectedImage: TGraphic;
var StartNo, EndNo, StartOffs, EndOffs,Index: Integer;
begin
  {$IFNDEF RVDONOTUSEINPLACE}
  if (GetChosenRVData<>nil) then begin
    Result := TCustomRVFormattedData(GetChosenRVData).GetSelectedImage;
    exit;
  end;
  {$ENDIF}
  Result := nil;
  StoreSelBounds(StartNo, EndNo, StartOffs, EndOffs, True);
  if (StartNo=-1) then exit;
  case EndNo-StartNo of
    0:
      begin
        if (StartOffs>0) or (EndOffs<1) then exit;
        Index := StartNo;
      end;
    1:
      begin
        if StartOffs>GetOffsBeforeItem(StartNo) then begin
          if StartOffs<GetOffsAfterItem(StartNo) then exit;
          if EndOffs<GetOffsAfterItem(EndNo) then exit;
          Index := StartNo+1
          end
        else if EndOffs<GetOffsAfterItem(EndNo) then begin
          if EndOffs>GetOffsBeforeItem(EndNo) then exit;
          if StartOffs>GetOffsBeforeItem(StartNo) then exit;
          Index := StartNo
          end
        else
          exit;
      end;
    2:
      begin
        if StartOffs<GetOffsAfterItem(StartNo) then exit;
        if EndOffs>GetOffsBeforeItem(EndNo) then exit;
        Index := StartNo+1;
      end;
    else
      exit;
  end;
  Result := GetItem(Index).AsImage;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetSelTextR(Unicode: Boolean): TRVRawByteString;
var Stream: TRVMemoryStream;
begin
  {$IFNDEF RVDONOTUSEINPLACE}
  if (GetChosenRVData<>nil) then begin
    Result := TCustomRVFormattedData(GetChosenRVData).GetSelTextR(Unicode);
    exit;
  end;
  {$ENDIF}
  if not SelectionExists(False, True) then begin
    Result := '';
    exit;
  end;
  Stream := TRVMemoryStream.Create;
  try
    if SaveTextToStream('', Stream, 80, True, True, Unicode, False) then begin
      SetLength(Result, Stream.Size);
      Stream.Position := 0;
      Stream.ReadBuffer(PRVAnsiChar(Result)^, Stream.Size);
      end
    else
      Result := '';
  finally
    Stream.Free;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.SrchSelectIt(StartItemNo, StartOffs,
  EndItemNo, EndOffs: Integer; Invert: Boolean);
begin
  {$IFNDEF RVDONOTUSELIVESPELL}
  LiveSpellingCheckCurrentItem;
  {$ENDIF}
  DeselectPartiallySelectedItem(nil);
  if not Invert then
    RestoreSelBounds(StartItemNo, EndItemNo, StartOffs, EndOffs)
  else
    RestoreSelBounds(EndItemNo, StartItemNo, EndOffs, StartOffs);
  with DrawItems[FSelStartNo] do
    ShowRectangle(Left,Top,Width,Height);
  Invalidate;
  DoOnSelection(True);
  DoSelect;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.SrchStart(Down, FromStart: Boolean; var strt, offs: Integer);
var  sl,so: Integer;
begin
  if FromStart then begin
    if Down then begin
      strt := GetFirstNonHiddenItemNo;
      offs := GetOffsBeforeItem(strt);
      end
    else begin
      strt := GetLastNonHiddenItemNo;
      offs := GetOffsAfterItem(strt)+1;
    end;
    exit;
  end;
  if SelectionExists(True, False) then begin
    StoreSelBounds(sl, strt, so, offs, False);
    end
  else begin
    if Down then begin
      strt := GetFirstItemVisible;
      offs := GetOffsBeforeItem(strt);
      end
    else begin
      strt := GetLastItemVisible;
      offs := GetOffsAfterItem(strt)+1;
    end;
  end;
  if strt<0 then strt := 0;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.SearchTextR(Down, MatchCase, WholeWord,
  FromStart, Unicode, MultiItem: Boolean; s: TRVRawByteString):Boolean;
var CodePage: TRVCodePage;
    {....................................................}
    function GetSrchTextLength(const s: TRVRawByteString): Integer;
    begin
      Result := Length(s);
      if Unicode then
        Result := Result div 2;
    end;
    {....................................................}
    function FwdPos(const substr, astr: TRVRawByteString): Integer;
    var offs,r,roffs: Integer;
        str: TRVRawByteString;
    begin
      str := astr;
      Result := 0;
      offs := 0;
      r := Pos(substr, str);
      if WholeWord then begin
        while r <> 0 do begin
          roffs := offs+r;
          if ((roffs = 1) or ((roffs > 1) and IsDelimiter(astr, roffs-1, [], CodePage))) and
             (((roffs+Length(substr)) > Length(astr)) or
              (((roffs+Length(substr))<= Length(astr)) and
              IsDelimiter(astr, roffs+Length(substr), [], CodePage)))
              then begin
            Result := roffs;
            exit;
          end;
          str := System.Copy(str,r+Length(substr),Length(str));
          inc(offs, r+Length(substr)-1);
          r := Pos(substr, str);
        end;
        end
      else
        Result := r;
    end;
    {....................................................}
    {$IFNDEF RVDONOTUSEUNICODE}
    function FwdPosW(const substr, astr: TRVRawByteString): Integer;
    var SubStrPtr, StrPtr, StrPtrInit, FoundStr: PRVAnsiChar;
        BeforeStr, AfterStr: PWord;
        LenStr, LenSubStr: Integer;
    begin
      Result := 0;
      StrPtr := PRVAnsiChar(astr);
      StrPtrInit := StrPtr;
      SubStrPtr := PRVAnsiChar(substr);
      LenStr := Length(astr) div 2;
      LenSubStr := Length(substr) div 2;
      FoundStr := StrPosLW(StrPtr, SubStrPtr, LenStr, LenSubStr);
      if WholeWord then begin
        while FoundStr<>nil do begin
          BeforeStr := PWord(PRVAnsiChar(FoundStr)-2);
          AfterStr  := PWord(PRVAnsiChar(FoundStr)+Length(substr));
          if ((FoundStr = StrPtrInit) or IsDelimiterW(TRVUnicodeChar(BeforeStr^))) and
             ((AfterStr^ = 0) or IsDelimiterW(TRVUnicodeChar(AfterStr^))) then begin
            Result := (FoundStr-StrPtrInit) div 2+1;
            exit;
          end;
          if AfterStr^ = 0 then
            exit;
          StrPtr := Pointer(AfterStr);
          LenStr := (Length(astr) - (StrPtr-StrPtrInit)) div 2;
          FoundStr := StrPosLW(StrPtr, SubStrPtr, LenStr, LenSubStr);
        end;
        end
      else
        if FoundStr<>nil then
          Result := (FoundStr-StrPtrInit) div 2+1
    end;
    {$ENDIF}
    {....................................................}
    function RevPos(substr, str: TRVRawByteString): Integer;
    var offs,r: Integer;
    begin
      Result := 0;
      offs   := 0;
      while Length(str)<>0 do begin
        r := FwdPos(Substr, str);
        if r=0 then exit;
        Result := offs + r;
        str := System.Copy(str,r+1,Length(str));
        inc(offs, r);
      end;
    end;
    {....................................................}
    {$IFNDEF RVDONOTUSEUNICODE}
    function RevPosW(substr, str: TRVRawByteString): Integer;
    var offs,r: Integer;
    begin
      Result := 0;
      offs   := 0;
      while Length(str)<>0 do begin
        r := FwdPosW(substr, str);
        if r=0 then exit;
        Result := offs + r;
        str := System.Copy(str,(r+1)*2-1, Length(str));
        inc(offs, r);
      end;
    end;
    {$ENDIF}
    {....................................................}
    function SearchInItem(item: TCustomRVItemInfo; StoreSub: TRVStoreSubRVData;
      SubRVData: TCustomRVFormattedData): Boolean;
    var SubPos: TRVSubRVDataPos;
    begin
      if Down then
        SubPos := rvdNext
      else
        SubPos := rvdPrev;
      Result := TCustomRVFormattedData(SubRVData.GetRVData).SearchTextR(Down,
        MatchCase, WholeWord, FromStart, Unicode, MultiItem, s);
      if not Result then
        repeat
          SubRVData := TCustomRVFormattedData(item.GetSubRVData(StoreSub,SubPos));
          if SubRVData=nil then
            break;
          Result := TCustomRVFormattedData(SubRVData.GetRVData).SearchTextR(Down,
            MatchCase, WholeWord, FromStart, Unicode, MultiItem, s);
        until Result;
      if Result then
        item.ChooseSubRVData(StoreSub);
      StoreSub.Free;
    end;
    {....................................................}
    {$IFNDEF RVDONOTUSEUNICODE}
    // editorstring, soughtstring - ANSI strings
    // Offs, Len measured in 1bytes
    procedure UpdateUnicodePos(const editorstring, soughtstring: TRVRawByteString;
      ItemOptions: TRVItemOptions; var Offs, Len: Integer);
    var s: TRVRawByteString;
    begin
      if not (rvioUnicode in ItemOptions) then
        exit;
      s := RVU_AnsiToUnicode(GetDefaultCodePage, soughtstring);
      Len := Length(s) div 2;
      s := System.Copy(editorstring, 1, Offs-1);
      s := RVU_AnsiToUnicode(GetDefaultCodePage, s);
      Offs := Length(s) div 2+1;
    end;
    {....................................................}
    // editorstring, soughtstring - raw Unicode strings
    // Offs, Len measured in 2bytes
    procedure UpdateAnsiPos(const editorstring, soughtstring: TRVRawByteString;
      ItemOptions: TRVItemOptions; var Offs, Len: Integer;
      CodePage: TRVCodePage);
    var s: TRVRawByteString;
    begin
      if rvioUnicode in ItemOptions then
        exit;
      s := RVU_UnicodeToAnsi(CodePage, soughtstring);
      Len := Length(s);
      s := System.Copy(editorstring, 1, (Offs-1)*2);
      s := RVU_UnicodeToAnsi(CodePage, s);
      Offs := Length(s)+1;
    end;
    {$ENDIF}
    {....................................................}
    procedure UpdatePos(const editorstring, soughtstring: TRVRawByteString;
      var Offs, Len: Integer; ItemNo: Integer);
    begin
      {$IFNDEF RVDONOTUSEUNICODE}
      if Unicode then
        UpdateAnsiPos(editorstring, soughtstring, GetItemOptions(ItemNo),
          Offs, Len, GetItemCodePage(ItemNo))
      else
        UpdateUnicodePos(editorstring, soughtstring, GetItemOptions(ItemNo),
          Offs, Len);
      {$ENDIF}
    end;
    {....................................................}
    {$IFNDEF RVDONOTUSEUNICODE}
    // EditorString - ANSI strings
    // Offs measured in 1bytes
    procedure UpdatePosInUnicodeItem(const EditorString: TRVRawByteString;
      ItemNo: Integer; var Offs: Integer);
    var s: TRVRawByteString;
    begin
      if (GetItemStyle(ItemNo)<0) or not (rvioUnicode in GetItemOptions(ItemNo)) then
        exit;
      s := System.Copy(EditorString, 1, Offs-1);
      s := RVU_AnsiToUnicode(GetDefaultCodePage, s);
      Offs := Length(s) div 2+1;
    end;
    {....................................................}
    // EditorString - raw Unicode strings
    // Offs measured in 2bytes
    procedure UpdatePosInAnsiItem(const EditorString: TRVRawByteString;
      ItemNo: Integer; var Offs: Integer);
    var s: TRVRawByteString;
    begin
      if (GetItemStyle(ItemNo)<0) or (rvioUnicode in GetItemOptions(ItemNo)) then
        exit;
      s := System.Copy(EditorString, 1, (Offs-1)*2);
      s := RVU_UnicodeToAnsi(GetItemCodePage(ItemNo), s);
      Offs := Length(s)+1;
    end;
    {$ENDIF}
    {....................................................}
    procedure UpdatePosInItem(const EditorString: TRVRawByteString;
      ItemNo: Integer; var Offs: Integer);
    begin
      {$IFNDEF RVDONOTUSEUNICODE}
      if Unicode then
        UpdatePosInAnsiItem(EditorString, ItemNo, Offs)
      else
        UpdatePosInUnicodeItem(EditorString, ItemNo, Offs);
      {$ENDIF}
    end;
    {....................................................}
    function GetStringToCompare(const s: TRVRawByteString): TRVRawByteString;
    {$IFNDEF RVDONOTUSEUNICODE}
    var tmp: TRVRawByteString;
    {$ENDIF}
    begin
      if MatchCase then
        Result := s
      else
        {$IFNDEF RVDONOTUSEUNICODE}
        if not Unicode then
        {$ENDIF}
          Result := {$IFDEF RICHVIEWDEF2009}AnsiStrings.{$ENDIF}AnsiUpperCase(s)
        {$IFNDEF RVDONOTUSEUNICODE}
        else if RVNT then begin
          SetString(tmp, PRVAnsiChar(s), Length(s));
          CharUpperBuffW(Pointer(tmp), Length(tmp) div 2);
          Result := tmp;
          end
        else
          Result := s;
        {$ENDIF}
    end;
    {....................................................}
    function GetItemString(const s: TRVRawByteString; ItemNo: Integer): TRVRawByteString;
    {$IFNDEF RVDONOTUSEUNICODE}
    var ItemOptions: TRVItemOptions;
    {$ENDIF}
    begin
      {$IFNDEF RVDONOTUSEUNICODE}
      ItemOptions := GetItemOptions(ItemNo);
      if (rvioUnicode in ItemOptions) and not Unicode then
        Result := RVU_UnicodeToAnsi(GetDefaultCodePage, s)
      else if not (rvioUnicode in ItemOptions) and Unicode then
        Result := RVU_AnsiToUnicode(GetItemCodePage(ItemNo), s)
      else
      {$ENDIF}
        Result := s;
      Result := GetStringToCompare(Result);
    end;
    {....................................................}
var strt, offs, len, i, so,
    FirstAccumItemOffs, FirstAccumItemNo: Integer;
    AccumItemLengths, AccumItemNos: TRVIntegerList;
    ItemText, AccumText: TRVRawByteString;
    item: TCustomRVItemInfo;
    StoreSub: TRVStoreSubRVData;
    SubPos: TRVSubRVDataPos;
    SubRVData: TCustomRVFormattedData;
    {....................................................}
    function SearchInAccumText: Boolean;
    var i, OffsInAccumText, Offs1, Offs2, Len: Integer;
        StartItemNo, EndItemNo, StartOffs, EndOffs, SrchStartOffs, SrchEndOffs: Integer;
    begin
      if (AccumText='') or (FirstAccumItemNo<0) then begin
        FirstAccumItemNo := -1;
        AccumText := '';
        AccumItemLengths.Clear;
        AccumItemNos.Clear;
        Result := False;
        exit;
      end;
      if not Down then begin
        {$IFNDEF RVDONOTUSEUNICODE}
        if not Unicode then
        {$ENDIF}
          SrchStartOffs := RevPos(s, AccumText)
        {$IFNDEF RVDONOTUSEUNICODE}
        else
          SrchStartOffs := RevPosW(s, AccumText);
        {$ENDIF};
        end
      else begin
        {$IFNDEF RVDONOTUSEUNICODE}
        if not Unicode then
        {$ENDIF}
          SrchStartOffs := FwdPos(s, AccumText)
        {$IFNDEF RVDONOTUSEUNICODE}
        else
          SrchStartOffs := FwdPosW(s, AccumText);
        {$ENDIF};
      end;
      Result := SrchStartOffs<>0;
      if not Result then begin
        FirstAccumItemNo := -1;
        AccumText := '';
        AccumItemLengths.Clear;
        AccumItemNos.Clear;
        exit;
      end;
      OffsInAccumText := 1;
      Len := GetSrchTextLength(s);
      SrchEndOffs := SrchStartOffs+Len;
      StartItemNo := -1;
      EndItemNo := -1;
      StartOffs := -1;
      EndOffs := -1;
      Offs1 := -1;
      Offs2 := -1;
      for i := 0 to AccumItemLengths.Count-1 do begin
        if (StartItemNo<0) and
          (SrchStartOffs<OffsInAccumText+AccumItemLengths[i]) then begin
          StartItemNo := AccumItemNos[i];
          StartOffs := SrchStartOffs-OffsInAccumText+1;
          Offs1 := OffsInAccumText;
        end;
        if SrchEndOffs<=OffsInAccumText+AccumItemLengths[i] then begin
          EndItemNo := AccumItemNos[i];
          EndOffs := SrchEndOffs-OffsInAccumText+1;
          Offs2 := OffsInAccumText;
          break;
        end;
        inc(OffsInAccumText, AccumItemLengths[i]);
      end;
      UpdatePosInItem(System.Copy(AccumText, Offs1, Length(AccumText)), StartItemNo, StartOffs);
      UpdatePosInItem(System.Copy(AccumText, Offs2, Length(AccumText)), EndItemNo, EndOffs);
      if FirstAccumItemOffs>=0 then begin
        if StartItemNo=FirstAccumItemNo then
          inc(StartOffs, FirstAccumItemOffs-1)
        else if GetItemStyle(StartItemNo)<0 then
          dec(StartOffs);
        if EndItemNo=FirstAccumItemNo then
          inc(EndOffs, FirstAccumItemOffs-1)
        else if GetItemStyle(EndItemNo)<0 then
          dec(EndOffs);
      end;
      TCustomRVFormattedData(Edit()).SrchSelectIt(StartItemNo, StartOffs, EndItemNo, EndOffs, not Down);
    end;
    {....................................................}
begin
  Result := False;
  if (s='') or (ItemCount=0) then
    exit;
  s := GetStringToCompare(s);
  StoreSub := nil;
  item := nil;
  if not FromStart then begin
    item := GetChosenItem;
    if item=nil then
      item := PartialSelectedItem;
    if item<>nil then begin
      if Down then
        SubPos := rvdChosenDown
      else
        SubPos := rvdChosenUp;
      SubRVData := TCustomRVFormattedData(item.GetSubRVData(StoreSub, SubPos));
      if SubRVData<>nil then begin
        Result := SearchInItem(item, StoreSub, SubRVData);
        if Result then
          exit;
      end;
    end;
  end;
  if Down then
    SubPos := rvdFirst
  else
    SubPos := rvdLast;
  SrchStart(Down, FromStart, strt, offs);
  if (strt>=ItemCount) or (strt<0) then
    exit;
  FirstAccumItemNo := -1;
  FirstAccumItemOffs := -1;
  AccumText := '';
  if MultiItem then begin
    AccumItemLengths := TRVIntegerList.Create;
    AccumItemNos := TRVIntegerList.Create;
    end
  else begin
    AccumItemLengths := nil;
    AccumItemNos := nil;
  end;
  if GetItem(strt)=item then begin
    if Down then
      inc(strt)
    else
      dec(strt);
    if (strt>=ItemCount) or (strt<0) then begin
      AccumItemLengths.Free;
      AccumItemNos.Free;
      exit;
    end;
    end
  else if (GetItemStyle(strt)>=0) and not IsHidden(strt) then begin
    if not Down then begin
      ItemText := RVU_Copy(Items[strt], 1, offs-1, GetItemOptions(strt));
      offs := 1;
      end
    else
      ItemText := RVU_Copy(Items[strt], offs, RVU_Length(Items[strt],
        GetItemOptions(strt)), GetItemOptions(strt));
    ItemText := GetItemString(ItemText, strt);
    CodePage := GetItemCodePage(strt);
    if MultiItem then begin
      FirstAccumItemNo := strt;
      FirstAccumItemOffs := offs;
      AccumItemLengths.Add(GetSrchTextLength(ItemText));
      AccumItemNos.Add(strt);
      AccumText := ItemText;
      end
    else begin
      {$IFNDEF RVDONOTUSEUNICODE}
      if not Unicode then
      {$ENDIF}
        if not Down then
          so := RevPos(s, ItemText)
        else
          so := FwdPos(s, ItemText)
      {$IFNDEF RVDONOTUSEUNICODE}
      else
        if not Down then
          so := RevPosW(s, ItemText)
        else
          so := FwdPosW(s, ItemText);
      {$ENDIF};
      if so<>0 then begin
        Result := True;
        len := GetSrchTextLength(s);
        UpdatePos(ItemText, s, so, len, strt);
        TCustomRVFormattedData(Edit()).SrchSelectIt(strt, offs+so-1, strt, offs+so-1+len, not Down);
        exit;
      end;
    end;
    if Down then
      inc(strt)
    else
      dec(strt);
  end;
  if not Down then begin
    // search in reverse direction...
    if MultiItem and (FirstAccumItemNo>=0) and IsFromNewLineEx(FirstAccumItemNo) and
      SearchInAccumText then begin
      Result := True;
      AccumItemLengths.Free;
      AccumItemNos.Free;
      exit;
    end;
    for i := strt downto 0 do
      if not IsHidden(i) then begin
        if GetItemStyle(i)>=0 then begin
          // processing a text item
          ItemText := GetItemString(Items[i], i);
          CodePage := GetItemCodePage(i);
          if MultiItem then begin
            FirstAccumItemNo := i;
            FirstAccumItemOffs := 1;
            AccumText := ItemText+AccumText;
            AccumItemLengths.Insert(0, GetSrchTextLength(ItemText));
            AccumItemNos.Insert(0, i);
            end
          else begin
            {$IFNDEF RVDONOTUSEUNICODE}
            if not Unicode then
            {$ENDIF}
              offs := RevPos(s, ItemText)
            {$IFNDEF RVDONOTUSEUNICODE}
            else
              offs := RevPosW(s, ItemText);
            {$ENDIF};
            if offs<>0 then begin
              Result := True;
              len := GetSrchTextLength(s);
              UpdatePos(ItemText, s, offs, len, i);
              TCustomRVFormattedData(Edit()).SrchSelectIt(i, offs, i, offs+len, not Down);
              exit;
            end;
          end
          end
        else if GetItemStyle(i)=rvsTab then begin
          // processing a tab item
          if MultiItem then begin
            FirstAccumItemNo := i;
            FirstAccumItemOffs := 0;
            if not Unicode then
              AccumText := #9+AccumText
            else
              AccumText := #9#0+AccumText;
            AccumItemLengths.Insert(0, 1);
            AccumItemNos.Insert(0, i);
            end
          else if (not Unicode and (s=#9)) or (Unicode and (s=#9#0)) then begin
            TCustomRVFormattedData(Edit()).SrchSelectIt(i, 0, i, 1, not Down);
            Result := True;
            exit;
          end;
          end
        else begin
          // processing other items
          if MultiItem and SearchInAccumText then begin
            Result := True;
            AccumItemLengths.Free;
            AccumItemNos.Free;
            exit;
          end;
          item := GetItem(i);
          SubRVData := TCustomRVFormattedData(item.GetSubRVData(StoreSub, SubPos));
          if SubRVData<>nil then begin
            Result := SearchInItem(item, StoreSub, SubRVData);
            if Result then begin
              AccumItemLengths.Free;
              AccumItemNos.Free;
             exit;
            end;
          end;
        end;
        if MultiItem and (IsFromNewLineEx(i) or (i=0)) and SearchInAccumText then begin
          Result := True;
          AccumItemLengths.Free;
          AccumItemNos.Free;
          exit;
        end;
      end;
    end
  else begin
    // searching in normal direction...
    for i := strt to ItemCount-1 do
      if not IsHidden(i) then begin
        if MultiItem and IsFromNewLineEx(i) and SearchInAccumText then begin
          Result := True;
          AccumItemLengths.Free;
          AccumItemNos.Free;
          exit;
        end;
        if GetItemStyle(i)>=0 then begin
          // processing a text item
          ItemText := GetItemString(Items[i], i);
          CodePage := GetItemCodePage(i);
          if MultiItem then begin
            if FirstAccumItemNo<0 then begin
              FirstAccumItemNo := i;
              FirstAccumItemOffs := 1;
            end;
            AccumText := AccumText+ItemText;
            AccumItemLengths.Add(GetSrchTextLength(ItemText));
            AccumItemNos.Add(i);
            end
          else begin
            {$IFNDEF RVDONOTUSEUNICODE}
            if not Unicode then
            {$ENDIF}
              offs := FwdPos(s, ItemText)
            {$IFNDEF RVDONOTUSEUNICODE}
            else
              offs := FwdPosW(s, ItemText);
            {$ENDIF};
            if offs<>0 then begin
              Result := True;
              len := GetSrchTextLength(s);
              UpdatePos(ItemText, s, offs, len, i);
              TCustomRVFormattedData(Edit()).SrchSelectIt(i, offs, i, offs+len, not Down);
              exit;
            end;
          end
          end
        else if GetItemStyle(i)=rvsTab then begin
          // processing a tab item
          if MultiItem then begin
            if FirstAccumItemNo<0 then begin
              FirstAccumItemNo := i;
              FirstAccumItemOffs := 0;
            end;
            if not Unicode then
              AccumText := AccumText+#9
            else
              AccumText := AccumText+#9#0;
            AccumItemLengths.Add(1);
            AccumItemNos.Add(i);
            end
          else if (not Unicode and (s=#9)) or (Unicode and (s=#9#0)) then begin
            TCustomRVFormattedData(Edit()).SrchSelectIt(i, 0, i, 1, not Down);
            Result := True;
            exit;
          end
          end
        else begin
          // processing other items
          if MultiItem and SearchInAccumText then begin
            Result := True;
            AccumItemLengths.Free;
            AccumItemNos.Free;
            exit;
          end;
          item := GetItem(i);
          SubRVData := TCustomRVFormattedData(item.GetSubRVData(StoreSub, SubPos));
          if SubRVData<>nil then begin
            Result := SearchInItem(item, StoreSub, SubRVData);
            if Result then begin
              AccumItemLengths.Free;
              AccumItemNos.Free;
              exit;
            end;
          end;
        end;
      end;
      if MultiItem then
        Result := SearchInAccumText;
    end;
  AccumItemLengths.Free;
  AccumItemNos.Free;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.GetSelectionBounds(var StartItemNo, StartItemOffs,
                                 EndItemNo, EndItemOffs: Integer;
                                 Normalize: Boolean);
begin
  StoreSelBounds(StartItemNo, EndItemNo, StartItemOffs, EndItemOffs, Normalize);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.GetSelectionBoundsEx(var StartItemNo,
  StartItemOffs, EndItemNo, EndItemOffs: Integer; Normalize: Boolean);
begin
  GetSelectionBounds(StartItemNo, StartItemOffs, EndItemNo, EndItemOffs, Normalize);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.AdjustSelection;
begin
  if (FSelStartNo<0) or (FSelEndNo<0) then
    exit;
  if FSelStartOffs<GetOffsBeforeDrawItem(FSelStartNo) then
    FSelStartOffs := GetOffsBeforeDrawItem(FSelStartNo);
  if FSelStartOffs>GetOffsAfterDrawItem(FSelStartNo) then
    FSelStartOffs := GetOffsAfterDrawItem(FSelStartNo);
  if FSelEndOffs<GetOffsBeforeDrawItem(FSelEndNo) then
    FSelEndOffs := GetOffsBeforeDrawItem(FSelEndNo);
  if FSelEndOffs>GetOffsAfterDrawItem(FSelEndNo) then
    FSelEndOffs := GetOffsAfterDrawItem(FSelEndNo);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.DoSetSelectionBounds(StartItemNo, StartItemOffs,
                                 EndItemNo, EndItemOffs: Integer);
begin
  DeselectPartiallySelectedItem(nil);
  DestroyInplaceEditor;
  {$IFNDEF RVDONOTUSELISTS}
  if (StartItemNo>=0) and (EndItemNo>=0) then begin
    if (StartItemNo+1<Items.Count) and (GetItemStyle(StartItemNo)=rvsListMarker) then begin
      inc(StartItemNo);
      StartItemOffs := GetOffsBeforeItem(StartItemNo);
    end;
    if (EndItemNo+1<Items.Count) and (GetItemStyle(EndItemNo)=rvsListMarker) then begin
      inc(EndItemNo);
      EndItemOffs := GetOffsBeforeItem(EndItemNo);
    end;
  end;
  {$ENDIF}
  RestoreSelBounds(StartItemNo, EndItemNo, StartItemOffs, EndItemOffs);
  AdjustSelection;  
//  if GetRVStyle.SelectionMode=rvsmParagraph then
//    ExpandSelectionToParagraph(True);
  DoOnSelection(True);
  DoSelect;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.SetSelectionBounds(StartItemNo, StartItemOffs,
                                 EndItemNo, EndItemOffs: Integer);
begin
  {$IFNDEF RVDONOTUSELIVESPELL}
  LiveSpellingCheckCurrentItem;
  {$ENDIF}
  DoSetSelectionBounds(StartItemNo, StartItemOffs, EndItemNo, EndItemOffs);
end;
{------------------------------------------------------------------------------}
{ X, Y - client coordinates }
procedure TCustomRVFormattedData.GetWordAtR(X,Y: Integer;
  var RVData: TCustomRVFormattedData; var ItemNo: Integer;
  var Word: TRVRawByteString);
var StyleNo, Offs: Integer;
begin
  if not FindWordAtR(Word, X,Y, StyleNo, ItemNo, Offs, RVData, True) then begin
    ItemNo := -1;
    Word := '';
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetClientSelectionRect: TRect;
var i: Integer;
    StartNo, EndNo, StartOffs, EndOffs, x,y: Integer;
    R: TRect;
begin
  // This is very rough function for returning selection rectangle
  // It does not count offsets in text items.
  {$IFNDEF RVDONOTUSEINPLACE}
  if (GetChosenRVData<>nil) then begin
    Result := TCustomRVFormattedData(GetChosenRVData).GetClientSelectionRect;
    exit;
  end;
  {$ENDIF}
  if SelectionExists(False, False) then begin
    ResetSubCoords;
    GetSelBounds(StartNo, EndNo, StartOffs, EndOffs, True);
    Result := Rect(0,0,0,0);
    for i:= StartNo to EndNo do begin
      with DrawItems[i] do
        R := Bounds(Left-GetHOffs,Top-GetVOffs, Width, Height);
      UnionRect(Result, Result, R);
    end;
    R := Rect(0,0,GetWidth,GetHeight);
    IntersectRect(Result, Result, R);
    GetOrigin(x,y);
    OffsetRect(Result, x,y);
    end
  else begin
    GetOriginEx(x,y);
    Result := Bounds(x,y,GetWidth,GetHeight);
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.OnTimerScroll;
begin
  //LastSelectionRect.Left := 1;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetSelectionRect:TRect;
var P: TPoint;
begin
  {$IFNDEF RVDONOTUSEINPLACE}
  if (GetInplaceEditor<>nil) and (GetInplaceEditor is TCustomRichView) then begin
    Result := TCustomRichView(GetInplaceEditor).RVData.GetSelectionRect;
    exit;
  end;
  {$ENDIF}
  Result := GetClientSelectionRect;
  P := Point(0,0);
  P := ClientToScreen(P);
  OffsetRect(Result, P.x, P.y);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.SelectWordAt(X,Y: Integer);
var StyleNo, ItemNo, Offs: Integer;
    Word: TRVRawByteString;
    RVData: TCustomRVFormattedData;
begin
  if not (rvoAllowSelection in Options) then exit;
  if FindWordAtR(Word, X, Y, StyleNo, ItemNo, Offs, RVData, True) then begin
    if StyleNo>=0 then
      RVData.SetSelectionBounds(ItemNo, Offs, ItemNo, Offs+RVU_Length(Word, RVData.GetItemOptions(ItemNo)))
    else
      RVData.SetSelectionBounds(ItemNo, 0, ItemNo, 1);
    Invalidate;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.GetCheckpointXY(CheckpointData: TCheckpointData;
                                                 var X,Y: Integer);
begin
  if CheckpointData = nil then
    raise ERichViewError.Create(errRVNil);
  if CheckpointData = NotAddedCP then begin
    X := 0;
    Y := DocumentHeight;
    end
  else
    with TRVCPInfo(CheckpointData) do begin
      if (ItemInfo=nil) or (ItemInfo.DrawItemNo=-1) then
        raise ERichViewError.Create(errRVNotFormatted);
      X := DrawItems[ItemInfo.DrawItemNo].Left;
      Y := DrawItems[ItemInfo.DrawItemNo].Top;
    end;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetCheckpointYEx(CheckpointData: TCheckpointData): Integer;
begin
  if CheckpointData = nil then
    raise ERichViewError.Create(errRVNil);
  if CheckpointData = NotAddedCP then
    Result := DocumentHeight
  else
    with TRVCPInfo(CheckpointData) do begin
      if (ItemInfo=nil) or (ItemInfo.DrawItemNo=-1) then
        raise ERichViewError.Create(errRVNotFormatted);
      Result := DrawItems[ItemInfo.DrawItemNo].Top;
    end;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetJumpPointY(id: Integer): Integer;
var i: Integer;
begin
  {$IFNDEF RVDONOTUSEINPLACE}
  if (GetChosenRVData<>nil) then begin
    Result := TCustomRVFormattedData(GetChosenRVData).GetJumpPointY(id);
    if Result>0 then
      exit;
  end;
  {$ENDIF}
  Result := 0;
  for i := 0 to Jumps.Count-1 do
   if  TRVJumpInfo(Jumps[i]).id = id-FirstJumpNo then begin
     Result := TRVJumpInfo(Jumps[i]).t;
     exit;
   end;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetJumpPointItemNo(id: Integer): Integer;
var i: Integer;
begin
  {$IFNDEF RVDONOTUSEINPLACE}
  if (GetChosenRVData<>nil) then begin
    Result := TCustomRVFormattedData(GetChosenRVData).GetJumpPointItemNo(id);
    if Result>=0 then
      exit;
  end;
  {$ENDIF}
  Result := -1;
  for i :=0 to Jumps.Count-1 do
    if TRVJumpInfo(Jumps[i]).id = id-FirstJumpNo then begin
      Result := TRVJumpInfo(Jumps[i]).RVData.DrawItems[TRVJumpInfo(Jumps[i]).DrawItemNo].ItemNo;
      exit;
    end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.GetJumpPointLocation(id: Integer;
  var RVData: TCustomRVFormattedData; var ItemNo: Integer);
var i: Integer;
begin
  {$IFNDEF RVDONOTUSEINPLACE}
  if (GetChosenRVData<>nil) then begin
    TCustomRVFormattedData(GetChosenRVData).GetJumpPointLocation(id,RVData,ItemNo);
    if ItemNo>=0 then
      exit;
  end;
  {$ENDIF}
  ItemNo := -1;
  RVData := nil;
  for i :=0 to Jumps.Count-1 do
    if TRVJumpInfo(Jumps[i]).id = id-FirstJumpNo then begin
      RVData := TRVJumpInfo(Jumps[i]).RVData;
      ItemNo := RVData.DrawItems[TRVJumpInfo(Jumps[i]).DrawItemNo].ItemNo;
      exit;
    end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.CopyTextA_;
var mem: Cardinal;
    ptr: PRVAnsiChar;
    s: TRVAnsiString;
begin
  if SelectionExists(True, True) then begin
    s := GetSelTextR(False);
    mem := GlobalAlloc(GMEM_MOVEABLE or GMEM_DDESHARE, Length(s)+1);
    if mem=0 then raise ERichViewError.Create(errRVNoMemory);
    ptr := PRVAnsiChar(GlobalLock(mem));
    Move(PRVAnsiChar(s)^,ptr^, Length(s));
    ptr[Length(s)] := #0;
    GlobalUnlock(mem);
    Clipboard.SetAsHandle(CF_TEXT ,mem);
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.CopyTextW_;
var mem: Cardinal;
    ptr: Pointer;
    s: TRVRawByteString;
    zero: Word;
begin
  if SelectionExists(True, True) then begin
    s := GetSelTextR(True);
    mem := GlobalAlloc(GMEM_MOVEABLE or GMEM_DDESHARE, Length(s)+2);
    if mem=0 then raise ERichViewError.Create(errRVNoMemory);
    ptr := GlobalLock(mem);
    Move(PRVAnsiChar(s)^,ptr^, Length(s));
    zero := 0;
    Move(zero,(PRVAnsiChar(ptr)+Length(s))^, 2);
    GlobalUnlock(mem);
    Clipboard.SetAsHandle(CF_UNICODETEXT ,mem);
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.CopyImage_;
var gr: TGraphic;
begin
  gr := GetSelectedImage;
  if gr<>nil then
    try
      Clipboard.Assign(gr);
    except;
    end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.Copy(Color: TColor; Background: TRVBackground);
begin
  {$IFNDEF RVDONOTUSEINPLACE}
  if (GetChosenRVData<>nil) then begin
    TCustomRVFormattedData(GetChosenRVData).Copy(clNone, nil);
    exit;
  end;
  {$ENDIF}
  if SelectionExists(True, True) then begin
    Clipboard.Clear;
    Clipboard.Open;
    try
      DoCopy;
      {$IFNDEF RVDONOTUSERVF}
      CopyRVF_(Color, Background);
      {$ENDIF}
      CopyTextA_;
      CopyImage_;
      {$IFNDEF RVDONOTUSEUNICODE}
      CopyTextW_;
      {$ENDIF}
      {$IFNDEF RVDONOTUSERTF}
      CopyRTF_(Color, Background);
      {$ENDIF}
    finally
      Clipboard.Close;
    end;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.CopyDef(Color: TColor; Background: TRVBackground): Boolean;
begin
  {$IFNDEF RVDONOTUSEINPLACE}
  if (GetChosenRVData<>nil) then begin
    Result := TCustomRVFormattedData(GetChosenRVData).CopyDef(clNone, nil);
    exit;
  end;
  {$ENDIF}
  Result := ((rvoAutoCopyText in Options) or
             {$IFNDEF RVDONOTUSERVF}
             (rvoAutoCopyRVF in Options) or
             {$ENDIF}
             {$IFNDEF RVDONOTUSEUNICODE}
             (rvoAutoCopyUnicodeText in Options) or
             {$ENDIF}
             {$IFNDEF RVDONOTUSERTF}
             (rvoAutoCopyRTF in Options) or
             {$ENDIF}
             (rvoAutoCopyImage in Options) or
             IsAssignedCopy
             );
  if Result and SelectionExists(True, True) then begin
    Clipboard.Clear;
    Clipboard.Open;
    try
      DoCopy;
      {$IFNDEF RVDONOTUSERVF}
      if (rvoAutoCopyRVF in Options) then CopyRVF_(Color, Background);
      {$ENDIF}
      if (rvoAutoCopyText in Options) and not (RVNT and (rvoAutoCopyUnicodeText in Options)) then CopyTextA_;
      if (rvoAutoCopyImage in Options) then CopyImage_;
      {$IFNDEF RVDONOTUSEUNICODE}
      if (rvoAutoCopyUnicodeText in Options) then CopyTextW_;
      {$ENDIF}
      {$IFNDEF RVDONOTUSERTF}
      if (rvoAutoCopyRTF in Options) then CopyRTF_(Color, Background);
      {$ENDIF}
    finally
      Clipboard.Close;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.CopyImage;
begin
  {$IFNDEF RVDONOTUSEINPLACE}
  if (GetChosenRVData<>nil) then begin
    TCustomRVFormattedData(GetChosenRVData).CopyImage;
    exit;
  end;
  {$ENDIF}
  if SelectionExists(True, True) then begin
    Clipboard.Clear;
    CopyImage_;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.CopyTextA;
begin
  {$IFNDEF RVDONOTUSEINPLACE}
  if (GetChosenRVData<>nil) then begin
    TCustomRVFormattedData(GetChosenRVData).CopyTextA;
    exit;
  end;
  {$ENDIF}
  if SelectionExists(True, True) then begin
    Clipboard.Clear;
    CopyTextA_;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.CopyTextW;
begin
  {$IFNDEF RVDONOTUSEINPLACE}
  if (GetChosenRVData<>nil) then begin
    TCustomRVFormattedData(GetChosenRVData).CopyTextW;
    exit;
  end;
  {$ENDIF}
  if SelectionExists(True, True) then begin
    Clipboard.Clear;
    CopyTextW_;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.CopyText;
begin
  {$IFDEF RVUNICODESTR}
  CopyTextW;
  {$ELSE}
  CopyTextA;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERTF}
procedure TCustomRVFormattedData.CopyRTF(Color: TColor; Background: TRVBackground);
begin
  {$IFNDEF RVDONOTUSEINPLACE}
  if (GetChosenRVData<>nil) then begin
    TCustomRVFormattedData(GetChosenRVData).CopyRTF(clNone, nil);
    exit;
  end;
  {$ENDIF}
  if SelectionExists(True, True) then begin
    Clipboard.Clear;
    CopyRTF_(Color, Background);
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.CopyRTF_(Color: TColor; Background: TRVBackground);
var mem: Cardinal;
    ptr: Pointer;
    Stream: TRVMemoryStream;
begin
  Stream := TRVMemoryStream.Create;
  try
     SaveRTFToStream(Stream, '', True, 0, Color, Background,
       nil, nil, nil, nil, nil, 0.0, True, False, nil, nil);
     mem := GlobalAlloc(GMEM_MOVEABLE or GMEM_DDESHARE, Stream.Size);
     if mem=0 then raise ERichViewError.Create(errRVNoMemory);
     ptr := GlobalLock(mem);
     Move(Stream.Memory^,ptr^,Stream.Size);
     GlobalUnlock(mem);
  finally
    Stream.Free;
  end;
  Clipboard.SetAsHandle(CFRV_RTF, mem);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.RVFGetLimits(SaveScope: TRVFSaveScope;
                             var StartItem, EndItem, StartOffs, EndOffs: Integer;
                             var StartPart, EndPart: TRVMultiDrawItemPart;
                             var SelectedItem: TCustomRVItemInfo);
begin
  if SaveScope=rvfss_Selection then begin
    StartPart := nil;
    EndPart   := nil;
    SelectedItem := nil;
    if PartialSelectedItem=nil then
      StoreSelBounds(StartItem, EndItem, StartOffs, EndOffs, True)
    else
      SelectedItem := PartialSelectedItem;
    end
  else
    inherited RVFGetLimits(SaveScope, StartItem, EndItem, StartOffs, EndOffs,
      StartPart, EndPart, SelectedItem);
end;
{$IFNDEF RVDONOTUSERVF}
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.CopyRVF_(Color: TColor; Background: TRVBackground);
var mem: Cardinal;
    ptr: Pointer;
    Size: Integer;
    Stream: TRVMemoryStream;
begin
  Stream := TRVMemoryStream.Create;
  try
     Size := 0;
     Stream.WriteBuffer(Size, SizeOf(Size));
     SaveRVFToStream(Stream, True, Color, Background, nil, True);
     Size := Stream.Position-SizeOf(Size);
     Stream.Position := 0;
     Stream.WriteBuffer(Size, SizeOf(Size));
     mem := GlobalAlloc(GMEM_MOVEABLE or GMEM_DDESHARE, Stream.Size);
     if mem=0 then raise ERichViewError.Create(errRVNoMemory);
     ptr := GlobalLock(mem);
     Move(Stream.Memory^,ptr^,Stream.Size);
     GlobalUnlock(mem);
  finally
    Stream.Free;
  end;
  Clipboard.SetAsHandle(CFRV_RVF,mem);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.CopyRVF(Color: TColor; Background: TRVBackground);
begin
  {$IFNDEF RVDONOTUSEINPLACE}
  if (GetChosenRVData<>nil) then begin
    TCustomRVFormattedData(GetChosenRVData).CopyRVF(clNone, nil);
    exit;
  end;
  {$ENDIF}
  if SelectionExists(True,True) then begin
    Clipboard.Clear;
    CopyRVF_(Color, Background);
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.AfterVScroll;
var CP: TRVCPInfo;
    y, ymin, ymax: Integer;
    {..........................................................}
    function FindCPBefore(EndCP: TRVCPInfo): TRVCPInfo;
    begin
      Result := EndCP;
      while (Result<>nil) and (not Result.RaiseEvent) do
        Result := Result.Prev;
    end;
    {..........................................................}
begin
  if not IsAssignedCheckpointVisible or (GetCPEventKind=cpeNone) then
    exit;
  ymin := GetVOffs;
  ymax := ymin+GetHeight;
  CP := FirstCP;
  case GetCPEventKind  of
    cpeWhenVisible: // raise event for first visible cp
      begin
        while CP<>nil do begin
          if CP.RaiseEvent then begin
            if CP.ItemInfo.DrawItemNo=-1 then exit; // not formatted
            y := DrawItems[CP.ItemInfo.DrawItemNo].Top;
            if y>=ymin then begin
              if y>ymax then begin
                if LastRaisedCP<>nil then begin
                  LastRaisedCP := nil;
                  DoCheckpointVisible(nil);
                end;
                exit;
              end;
              if CP=LastRaisedCP then exit;
              LastRaisedCP := CP;
              DoCheckpointVisible(CP);
              exit;
            end;
          end;
          CP := CP.Next;
        end;
        if (NotAddedCP<>nil) and (NotAddedCP.RaiseEvent) and (NotAddedCP<>LastRaisedCP) and
           (DocumentHeight<ymax) then begin
          LastRaisedCP := NotAddedCP;
          DoCheckpointVisible(NotAddedCP);
          exit;
        end;
        if LastRaisedCP<>nil then begin
          LastRaisedCP := nil;
          DoCheckpointVisible(nil);
        end;
      end;
    cpeAsSectionStart: // raise event for first visible cp
                       // if there is no such cp, raise event for the closest cp
                       // before visible area
      begin
        while CP<>nil do begin
          if CP.RaiseEvent then begin
            if CP.ItemInfo.DrawItemNo=-1 then exit; // not formatted
            y := DrawItems[CP.ItemInfo.DrawItemNo].Top;
            if y>=ymin then begin
              if y>ymax then
                CP := FindCPBefore(CP.Prev);
              if CP<>nil then begin
                if CP=LastRaisedCP then exit;
                LastRaisedCP := CP;
                DoCheckpointVisible(CP);
              end;
              exit;
            end;
          end;
          CP := CP.Next;
        end;
        if (NotAddedCP<>nil) and (NotAddedCP.RaiseEvent) and (DocumentHeight<ymax) then begin
          if NotAddedCP=LastRaisedCP then exit;
          LastRaisedCP := NotAddedCP;
          DoCheckpointVisible(NotAddedCP);
          exit;
        end;
        CP := FindCPBefore(LastCP);
        if CP<>nil then begin
          y := DrawItems[CP.ItemInfo.DrawItemNo].Top;
          if y<=ymin then begin
            if CP=LastRaisedCP then exit;
            LastRaisedCP := CP;
            DoCheckpointVisible(CP);
            exit;
          end;
        end;
      end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.UpdateBackgroundPaletteInfo(Background: TRVBackground);
begin
  State := State + [rvstChangingBkPalette];
  Background.UpdatePaletted(GetDoInPaletteMode, GetRVPalette, GetRVLogPalette);
  State := State - [rvstChangingBkPalette];
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.UpdatingBackgroundPalette: Boolean;
begin
  Result := rvstChangingBkPalette in State;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.StartFormatting;
begin
   State := State + [rvstSkipformatting];
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.EndFormatting;
begin
   State := State - [rvstSkipformatting];
end;
{------------------------------------------------------------------------------}
// Returns the paragraph bounds for using in FormatParasExact.
// Takes hidden items into account. Includes adjacent paragraphs.
procedure TCustomRVFormattedData.GetParaBoundsEx(DINo1, DINo2: Integer; var ParaStart,
  ParaEnd: Integer; IncludeAdjacent: Boolean);
begin
  { calculating paragraphs bounds }
  ParaStart := DINo1;
  while (ParaStart>0) do begin
    if DrawItems[ParaStart].FromNewPara then
      break;
    dec(ParaStart);
  end;
  if IncludeAdjacent then begin
    { and prev. paragraph...}
    if ParaStart<>0 then
      dec(ParaStart);
    while (ParaStart>0) do begin
      if DrawItems[ParaStart].FromNewPara then
        break;
      dec(ParaStart);
    end;
  end;

  ParaEnd := DINo2+1;
  while (ParaEnd<DrawItems.Count) do begin
    if DrawItems[ParaEnd].FromNewPara then
      break;
    inc(ParaEnd);
  end;
  if IncludeAdjacent then begin
    { and next paragraph...}
    inc(ParaEnd);
    while (ParaEnd<DrawItems.Count) do begin
      if DrawItems[ParaEnd].FromNewPara then
        break;
      inc(ParaEnd);
    end;
  end;
  dec(ParaEnd);
  if ParaEnd>=DrawItems.Count then
    ParaEnd := DrawItems.Count-1;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.AdjustDrawItemsForFormatParas(
  var StartDrawItemNo, EndDrawItemNo: Integer; ItemsInserted: Integer);
begin
  GetParaBoundsEx(StartDrawItemNo, EndDrawItemNo, StartDrawItemNo, EndDrawItemNo, False);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.FormatParas(StartDrawItemNo, EndDrawItemNo,
  ItemsInserted: Integer);
begin
  AdjustDrawItemsForFormatParas(StartDrawItemNo, EndDrawItemNo, ItemsInserted);
  FormatParasExact(StartDrawItemNo, EndDrawItemNo, ItemsInserted, False);
end;
{-----------------------------------------------------------------------}
procedure TCustomRVFormattedData.StartPartialFormatting;
begin

end;
{-----------------------------------------------------------------------}
procedure TCustomRVFormattedData.FormatParasExact(StartDrawItemNo,EndDrawItemNo,
  ItemsInserted: Integer; NoCaching: Boolean);
var RepaintRect: TRect;

  function GetParagraphBottom(EndDrawItemNo: Integer):Integer;
  var i: Integer;
  begin
   Result := GetTopMargin;
   i := EndDrawItemNo;
   while (i>=0) do
     with DrawItems[i] do begin
       if Top+Height+ExtraSpaceBelow>Result then
         Result := Top+Height+ExtraSpaceBelow;
       if FromNewLine then
         break;
       dec(i);
     end;
  end;

  function GetParagraphTop(StartDrawItemNo: Integer):Integer;
  var i: Integer;
  begin
   Result := DrawItems[StartDrawItemNo].Top-DrawItems[StartDrawItemNo].ExtraSpaceAbove;
   i := StartDrawItemNo+1;
   while (i<DrawItems.Count) and
         not DrawItems[i].FromNewLine do
     with DrawItems[i] do begin
       if Top-ExtraSpaceAbove<Result then
         Result := Top-ExtraSpaceAbove;
       inc(i);
     end;
  end;

  procedure FormatParasExact_(var StartItemNo,EndItemNo: Integer);
  var PrevParBottom, ParBottom, NextParTop: Integer;
    i: Integer;
    sad: TRVScreenAndDevice;
    DLC//, a,b
    : Integer;
    Canvas: TCanvas;
    item: TCustomRVItemInfo;
    RVStyle: TRVStyle;
    ExtraSpaceBelowLine: Integer;
    SavedVOffs, LastItemNo, EndDrawItemNo2, EndItemNo2: Integer;
    Params: TRVFormatParams;
  begin
    Canvas := GetFormatCanvas;
    RVStyle := GetRVStyle;    
    DLC := DrawItems.Count;
    Params.UseFormatCanvas := Canvas<>GetCanvas;
    Params.SpaceEaten := False;
    Params.NoCaching := NoCaching;
    Params.LastTextStyle := -1;
    Params.FirstParaItemNo := -1;
    Params.NeedRecalcY := False;
    Params.AllowWordWrap := IsWordWrapAllowed;
    EndDrawItemNo2 :=  EndDrawItemNo;
    for i := EndDrawItemNo+1 to DrawItems.Count-1 do
      if not DrawItems[i].FloatingAboveUsed then begin
        if EndDrawItemNo2>EndDrawItemNo then
          AdjustDrawItemsForFormatParas(StartDrawItemNo, EndDrawItemNo2, ItemsInserted);
        break;
        end
      else
        EndDrawItemNo2 := i;
    if StartDrawItemNo=0 then
      StartItemNo := 0
    else
      StartItemNo := DrawItems[StartDrawItemNo-1].ItemNo+1;
    if EndDrawItemNo=DrawItems.Count-1 then
      EndItemNo := ItemCount-1
    else
      EndItemNo := DrawItems[EndDrawItemNo+1].ItemNo+ItemsInserted-1;
    if EndDrawItemNo2=DrawItems.Count-1 then
      EndItemNo2 := ItemCount-1
    else
      EndItemNo2 := DrawItems[EndDrawItemNo2+1].ItemNo+ItemsInserted-1;

    if EndItemNo2>EndItemNo then begin
      EndItemNo := EndItemNo2;
      EndDrawItemNo := EndDrawItemNo2;
    end;
    AdjustInItemsRange(StartItemNo);
    //if EndItemNo<StartItemNo then
    //  EndItemNo := StartItemNo;
    if EndItemNo<-1 then
      EndItemNo := -1;
    //AdjustInItemsRange(EndItemNo);

    PrevParBottom := GetParagraphBottom(StartDrawItemNo-1);
    if EndDrawItemNo<>DrawItems.Count-1 then
       NextParTop := GetParagraphTop(EndDrawItemNo+1)
    else
       NextParTop := -1;

    RepaintRect.Top := PrevParBottom-10-GetVOffs;
    RepaintRect.Left := 0;
    RepaintRect.Right := GetWidth;

    Params.x := 0;
    Params.prevdesc := 0;
    Params.prevabove := 0;
    Params.baseline := PrevParBottom;
    Params.LastTabDrawItemNo := -1;
    GetSADForFormatting(GetFormatCanvas, sad);
    sad.LeftMargin :=  RV_XToDevice(GetLeftMargin,  sad);
    sad.RightMargin := RV_XToDevice(GetRightMargin, sad);
    Params.IsParaSectionStart := True;
    Params.LineWidth   := 0;
    Params.LineStartX  := 0;
    Params.LastDrawItem := StartDrawItemNo;
    Params.TextLength := 0;
    Params.MaxLength := GetMaxLength;
    Params.LineHasFloating := False;
    Params.FloatingDrawItemsInThisParaSection := nil;
    if DrawItems[StartDrawItemNo].FloatingAboveUsed then begin
      Params.FloatingDrawItems := TRVFloatingDrawItems.Create;
      Params.FloatingDrawItems.FillFloatingCrossingY(PrevParBottom, StartDrawItemNo, DrawItems);
      end
    else
      Params.FloatingDrawItems := nil;
    DrawItems.MarkForDelete(StartDrawItemNo,EndDrawItemNo);

    Params.DontFSL := True;

    CreateFontInfoCache(GetCanvas, Canvas);
    Params.FontInfoCache := GetFontInfoCache(GetCanvas, Canvas, Self);
    Params.FormatCanvas := Canvas;
    try
      while True do begin
        for i:=StartItemNo to EndItemNo do
          if not IsHidden(i) then
            with GetItem(i) do begin
              if IsParaStartEx(i) then
                Params.FirstParaItemNo := i;
              if (StyleNo>=0) then
                FormatLine(
                  RV_ReturnProcessedString(Items[i],
                    RVStyle.TextStyles[GetActualStyleNo(RVStyle)], False,
                      CanShowSpecialCharacters, False),
                  Items[i],
                  {$IFNDEF RVDONOTUSEUNICODE}
                  RVU_Length(Items[i], ItemOptions),
                  {$ELSE}
                  Length(Items[i]),
                  {$ENDIF}
                  i, Canvas, sad, Params)
              else
                FormatLine('', '', Length(Items[i]), i, Canvas, sad, Params);
            end
          else if not ShareItems then begin
            GetItem(i).DrawItemNo := -1;
            GetItem(i).Hiding;
          end;
        if (EndItemNo=ItemCount-1) or
          (((Params.FloatingDrawItems=nil) or (Params.FloatingDrawItems.Count=0))
            and not Params.LineHasFloating) then
          break;
        DrawItems.DeleteMarked;
        if ItemsInserted<>0 then begin
          for i := Params.LastDrawItem to DrawItems.Count-1 do
            inc(DrawItems[i].ItemNo, ItemsInserted);
          ItemsInserted := 0;
        end;
        if DLC<>DrawItems.Count then begin
          for i := EndItemNo+1 to ItemCount-1 do
            inc(GetItem(i).DrawItemNo, DrawItems.Count-DLC);
          DLC := DrawItems.Count;
        end;
        //a := StartItemNo; // debug
        //b := EndItemNo;   // debug
        StartItemNo := EndItemNo+1;
        EndItemNo := StartItemNo;
        ExpandToParaSectionEx(StartItemNo, EndItemNo, StartItemNo, EndItemNo);
        Item2FirstDrawItem(StartItemNo, StartDrawItemNo);
        //if StartDrawItemNo<>Params.LastDrawItem then // debug
        //  beep;                                      // debug
        Params.LastDrawItem := StartDrawItemNo;
        Item2LastDrawItem(EndItemNo, EndDrawItemNo);
        if EndDrawItemNo<>DrawItems.Count-1 then
          NextParTop := GetParagraphTop(EndDrawItemNo+1)
        else
          NextParTop := -1;
        DrawItems.MarkForDelete(StartDrawItemNo,EndDrawItemNo);
      end;
      UpdateLastTab(Params);
      FinishScreenLine(sad, True, ExtraSpaceBelowLine, Params);
    finally
      DestroyFontInfoCache(Params.FontInfoCache);
    end;
    inc(Params.baseline, ExtraSpaceBelowLine);
    DrawItems.DeleteMarked;

    if (EndItemNo>=0) and IsLastParaItemEx(EndItemNo) then
      inc(Params.prevdesc,
        RVStyle.GetAsPixels(
          RVStyle.ParaStyles[GetItemParaEx(EndItemNo)].SpaceAfter));
    i := GetNextNonHiddenItemNo(EndItemNo);
    if (i>=0) and IsParaStartEx(i) then
      inc(Params.prevdesc,
        RVStyle.GetAsPixels(
          RVStyle.ParaStyles[GetItemParaEx(i)].SpaceBefore));
    RepaintRect.Bottom := Params.baseline+Params.prevdesc+10-GetVOffs;
    if (ItemsInserted<>0) or (DLC<>DrawItems.Count) or
       (NextParTop<>Params.baseline+Params.prevdesc) then begin
      ParBottom := Params.baseline+Params.prevdesc;
      // RepaintRect.Bottom := GetHeight;
      if Params.LastDrawItem=0 then
        LastItemNo := -1
      else
        LastItemNo := DrawItems[Params.LastDrawItem-1].ItemNo;
      for i:=Params.LastDrawItem to DrawItems.Count-1 do
        with DrawItems[i] do begin
          Top := Top-NextParTop+(Params.baseline+Params.prevdesc);
          {$IFDEF RVUSEBASELINE}
          BaseLine := BaseLine-NextParTop+(Params.baseline+Params.prevdesc);
          {$ENDIF}
          if Top+Height>ParBottom then
            ParBottom := Top+Height;
          ItemNo := ItemNo + ItemsInserted;
          item := GetItem(ItemNo);
          if item.GetBoolValue(rvbpFloating) then begin
            TRVFloatingDrawLineInfo(DrawItems[i]).FloatTop :=
              TRVFloatingDrawLineInfo(DrawItems[i]).FloatTop-NextParTop+
              (Params.baseline+Params.prevdesc);
            if TRVFloatingDrawLineInfo(DrawItems[i]).FloatBottom>ParBottom then
              ParBottom := TRVFloatingDrawLineInfo(DrawItems[i]).FloatBottom+Height;
          end;
          if ItemNo<>LastItemNo then begin
            item.DrawItemNo := i;
            LastItemNo := ItemNo;
          end;
        end;
      if (EndItemNo<Items.Count-1) then
        inc(ParBottom,
          RVStyle.GetAsPixels(
            RVStyle.ParaStyles[GetItemParaEx(Items.Count-1)].SpaceAfter));
      i := Params.FloatingDrawItems.GetFloatBottom;
      if i>ParBottom then
        ParBottom := i;
      RepaintRect.Bottom := ParBottom-GetVOffs+10;
      if DocumentHeight-GetBottomMargin+10>RepaintRect.Bottom then
        RepaintRect.Bottom := DocumentHeight-GetBottomMargin+10;
      if RepaintRect.Bottom>GetHeight then
        RepaintRect.Bottom := GetHeight;
      if DocumentHeight <> (ParBottom+GetBottomMargin) then begin
        SavedVOffs := GetVOffs;
        DocumentHeight := ParBottom+GetBottomMargin;
        AdjustVScrollUnits;
        AlreadyFormatted := True;
        SetDocumentAreaSize(GetAreaWidth, DocumentHeight, False);
        AlreadyFormatted := False;
        if SavedVOffs<>GetVOffs then
          RepaintRect := GetParentControl.ClientRect;
      end;
    end;
    Params.FloatingDrawItems.Free;
    Params.FloatingDrawItemsInThisParaSection.Free;
    AdjustChildrenCoords;
    LastItemFormatted := Items.Count-1;
  end;
var StartItemNo,EndItemNo: Integer;
begin
  StartPartialFormatting;
  Include(GetAbsoluteRootData.State, rvstFormattingPart);
  try
    FormatParasExact_(StartItemNo,EndItemNo);
  finally
    Exclude(GetAbsoluteRootData.State, rvstFormattingPart);
  end;
  InvalidateRect(RepaintRect);
  Formatted(StartItemNo,EndItemNo,True);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.DoOnSelection(AllowScrolling: Boolean);
begin
  {$IFNDEF RVDONOTUSEANIMATION}
  ResetAniBackground;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.XorDrawing;
begin
  if Assigned(FXORDrawing) then begin
    FXORDrawing(Self, [], MouseX, MouseY);
    XorImageDrawn := not XorImageDrawn;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.XorDrawingEx(X, Y: Integer);
begin
  MouseX := X;
  MouseY := Y;
  XorDrawing;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.UnAssignXorDrawing(P: TMouseMoveEvent);
begin
  if @FXORDrawing=@P then begin
    if XorImageDrawn and not (csDestroying in GetParentControl.ComponentState) then
      XorDrawing;
    FXORDrawing := nil;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.AssignXorDrawing(P: TMouseMoveEvent);
begin
  if XorImageDrawn then
    XorDrawing;
  FXORDrawing := P;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.UsingThisXorDrawing(P: TMouseMoveEvent): Boolean;
begin
  Result := @FXORDrawing=@P;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.ClearXorDrawing: Boolean;
begin
  Result := XorImageDrawn;
  if XorImageDrawn then
    XorDrawing;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.InternalFreeItem(item: TCustomRVItemInfo;
  Clearing: Boolean);
begin
  if item=FCaptureMouseItem then
    FCaptureMouseItem := nil;
//  if item=GetChosenItem then
//    UnassignChosenRVData(GetChosenRVData);
  inherited InternalFreeItem(item, Clearing);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.ReleaseMouseCapture(Item: TCustomRVItemInfo);
begin
  if Item=FCaptureMouseItem then
    FCaptureMouseItem := nil;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.SetMouseCapture(Item: TCustomRVItemInfo;
                                                 var Left,Top: Integer);
begin
  if (LastDIMovedAbove<0) or (LastDIMovedAbove>=DrawItems.Count) or
     (Item <> GetItem(DrawItems[LastDIMovedAbove].ItemNo)) then
    Item2FirstDrawItem(Items.IndexOfObject(Item),LastDIMovedAbove);
  Left := DrawItems[LastDIMovedAbove].Left;
  Top := DrawItems[LastDIMovedAbove].Top;
  FCaptureMouseItem := Item;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetCPEventKind: TCPEventKind;
begin
  Result := TCustomRVFormattedData(GetAbsoluteRootData).GetCPEventKind;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.DoSelect;
begin
  TCustomRVFormattedData(GetAbsoluteRootData).DoSelect;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.DoCurrentTextStyleConversion(
  var StyleNo: Integer; ParaStyleNo, ItemNo, UserData: Integer;
  ToWholeParagraphs: Boolean);
begin
  if not (rvflRoot in Flags) then
    TCustomRVFormattedData(GetAbsoluteRootData).DoCurrentTextStyleConversion(
      StyleNo, ParaStyleNo, ItemNo, UserData, ToWholeParagraphs);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.DoDrawHyperlink(RVData: TCustomRVData;
  ItemNo: Integer; R: TRect);
begin
  TCustomRVFormattedData(GetAbsoluteRootData).DoDrawHyperlink(RVData, ItemNo, R);
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.IsAssignedRVDblClick: Boolean;
begin
   Result := TCustomRVFormattedData(GetAbsoluteRootData).IsAssignedRVDblClick;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.DoRVDblClick(const ClickedWord: TRVRawByteString;
  StyleNo: Integer);
begin
  TCustomRVFormattedData(GetAbsoluteRootData).DoRVDblClick(ClickedWord, StyleNo);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.DoGetItemCursor(RVData: TCustomRVData;
  ItemNo: Integer; var Cursor: TCursor);
begin
  TCustomRVFormattedData(GetAbsoluteRootData).DoGetItemCursor(RVData,
    ItemNo, Cursor);
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.IsAssignedRVRightClick: Boolean;
begin
  Result := TCustomRVFormattedData(GetAbsoluteRootData).IsAssignedRVRightClick;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.DoRVRightClick(const ClickedWord: TRVRawByteString;
  StyleNo, X, Y: Integer);
begin
  TCustomRVFormattedData(GetAbsoluteRootData).DoRVRightClick(ClickedWord,
    StyleNo, X,Y);
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetCanvas: TCanvas;
begin
  Result := TCustomRVFormattedData(GetRootData).GetCanvas;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.DeselectPartiallySelectedItem(NewPartiallySelected: TCustomRVItemInfo);
begin
  if (FPartialSelectedItem<>nil) and (FPartialSelectedItem<>NewPartiallySelected) then begin
    //if not (csDestroying in GetParentControl.ComponentState) then
      FPartialSelectedItem.DeselectPartial;
    FPartialSelectedItem := nil;
  end;
  if (GetChosenItem<>nil) and (GetChosenItem<>NewPartiallySelected) then begin
    if not (csDestroying in GetParentControl.ComponentState) then
      UnassignChosenRVData(GetChosenRVData);
  end;  
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.SetPartialSelectedItem(Item: TCustomRVItemInfo);
begin
  if FPartialSelectedItem<>Item then begin
    Deselect(Item, True);
    FPartialSelectedItem := Item;
    DoSelect;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetItemCoords(ItemNo: Integer; var Left, Top: Integer): Boolean;
begin
  Item2FirstDrawItem(ItemNo, ItemNo);
  Result := ItemNo<>-1;
  if Result then begin
    Left := DrawItems[ItemNo].Left;
    Top := DrawItems[ItemNo].Top;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetItemClientCoords(ItemNo: Integer; var Left, Top: Integer): Boolean;
begin
  Result := GetItemCoords(ItemNo, Left, Top);
  if Result then begin
    dec(Left, GetHOffs);
    dec(Top, GetVOffs);
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.DoCopy;
var root: TCustomRVData;
begin
  root := GetRootData;
  if root is TCustomRVFormattedData then
    TCustomRVFormattedData(GetRootData).DoCopy;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.IsAssignedCopy: Boolean;
var root: TCustomRVData;
begin
  root := GetRootData;
  if root is TCustomRVFormattedData then
    Result := TCustomRVFormattedData(GetRootData).IsAssignedCopy
  else
    Result := False;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.AssignChosenRVData(RVData: TCustomRVFormattedData;
                                                    Item: TCustomRVItemInfo);
begin

end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.SilentReplaceChosenRVData(RVData: TCustomRVFormattedData);
begin

end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.UnassignChosenRVData(RVData: TCustomRVData);
begin
  Include(State,rvstForceStyleChangeEvent);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.ChooseMe;
var ItemNo: Integer;
    Location: TRVStoreSubRVData;
begin
  if rvflRootEditor in GetAbsoluteRootData.Flags then
    exit;
  if GetParentData=nil then
    exit;
  if TCustomRVFormattedData(GetParentData).GetChosenRVData=Self then
    exit;
  Location := nil;
  GetParentInfo(ItemNo, Location);
  if (ItemNo>=0) and (Location<>nil) then
    GetParentData.GetRVData.GetItem(ItemNo).ChooseSubRVData(Location);
  Location.Free;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.Formatted(FirstItemNo, LastItemNo: Integer;Partial: Boolean);
begin

end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.DoAfterFormat;
begin

end;
{------------------------------------------------------------------------------}
// Input: ItemNo - index of TEXT item, potentially last on the line
// Output: ItemNo, Offs - position for wrapping
procedure TCustomRVFormattedData.GetWrapPlaceAfterItem(var ItemNo, Offs: Integer);
var s1, s2: TRVRawByteString;
    {$IFNDEF RVDONOTUSEUNICODE}
    Unicode1, Unicode2: Boolean;
    PrevChar, LastChar: Word;
    SpacesBefore: Boolean;
    PotentialBreakItemNo, PotentialBreakOffs: Integer;
    {$ENDIF}
    p: Integer;
    {..................................................................}
    // Returns the last non-space characters (in Ch) starting from the ItemNo-th item
    // Returns SpaceAfter=True if there are 1 or more spaced after this character
    // This function processes only Unicode text items in the same paragraph.
    // If such character is not found, returns 0 in Ch
    procedure FindPrevNonSpace(var Ch: Word; var SpacesAfter: Boolean);
    var i,j: Integer;
        Str: PWordArray;
    begin
      SpacesAfter := False;
      Ch := 0;
      for i := ItemNo downto 0 do
        if not IsHidden(i) then begin
          if (GetItemStyle(i)<0) or not (rvioUnicode in GetItemOptions(i)) then
            break;
          Str := PWordArray(GetItemTextR(i));
          for j := Length(GetItemTextR(i)) div 2 - 1 downto 0 do
            if Str[j]=UNI_Space then
              SpacesAfter := True
            else begin
              Ch := Str[j];
              exit;
            end;
          if IsFromNewLineEx(i) then
            break;
        end;
    end;
    {..................................................................}
begin
  Offs := GetOffsAfterItem(ItemNo);
  s1 := GetItemTextR(ItemNo);
  {$IFNDEF RVDONOTUSEUNICODE}
  Unicode1 := rvioUnicode in GetItemOptions(ItemNo);
  {$ENDIF}
  if {$IFNDEF RVDONOTUSEUNICODE}not Unicode1 and{$ENDIF}
     (s1<>'') and (s1[Length(s1)]=' ') then
    exit;
  {$IFNDEF RVDONOTUSEUNICODE}
  if Unicode1 then
    FindPrevNonSpace(PrevChar, SpacesBefore)
  else begin
    PrevChar := 0;
    SpacesBefore := False;
  end;
  PotentialBreakItemNo := ItemNo;
  PotentialBreakOffs := Offs;
  {$ENDIF}
  while (ItemNo+1<ItemCount) and
    (IsHidden(ItemNo+1) or (not IsFromNewLineEx(ItemNo+1) and (GetItemStyle(ItemNo+1)>=0))) do begin
    if not IsHidden(ItemNo+1) then begin
      s2 := GetItemTextR(ItemNo+1);
      {$IFNDEF RVDONOTUSEUNICODE}
      Unicode2 := rvioUnicode in GetItemOptions(ItemNo+1);
      {$ENDIF}
      if s2<>'' then begin
        {$IFNDEF RVDONOTUSEUNICODE}
        if not Unicode2 then begin
          if SpacesBefore and (PotentialBreakItemNo>=0) then begin // previous item was Unicode ended with spaces
            ItemNo := PotentialBreakItemNo;
            Offs := PotentialBreakOffs;
            exit;
          end;
        {$ENDIF}
          p := RVPos(' ', s2);
          if p=1 then
            exit;
          if p>0 then begin
            inc(ItemNo);
            Offs := p;
            exit;
          end;
        {$IFNDEF RVDONOTUSEUNICODE}
          PotentialBreakItemNo := -1;
          LastChar := 0;
          SpacesBefore := False;
          end
        else begin
          if not Unicode1 then begin
            if ((s2[1]=' ') and (s2[2]=#0)) then
              exit;
            PrevChar := ord('A');
            SpacesBefore := False;
          end;
          p := RVU_FindFirstLineBreak(s2, PrevChar, SpacesBefore, LastChar);
          if p<0 then begin // break in previous place
            ItemNo := PotentialBreakItemNo;
            Offs := PotentialBreakOffs;
            exit;
          end;
          if LastChar=0 then begin // break in this item
            inc(ItemNo);
            Offs := p+1;
            exit;
          end;
          if LastChar=UNI_Space then begin // this item consists of spaces
            if PrevChar=0 then
              exit;
            if PotentialBreakItemNo<0 then begin
              PotentialBreakItemNo := ItemNo;
              PotentialBreakOffs := Offs;
            end;
            SpacesBefore := True;
            end
          else begin
            PotentialBreakItemNo := ItemNo+1; // possible break place
            PotentialBreakOffs := p+1;
            SpacesBefore := p<>Length(s2) div 2;
            PrevChar := LastChar;
          end;
        end;
        {$ENDIF}
      end;
      Offs := Length(s2)+1;
      s1 := s2;
      {$IFNDEF RVDONOTUSEUNICODE}
      Unicode1 := Unicode2;
      {$ENDIF}
    end;
    inc(ItemNo);
  end;
  {$IFNDEF RVDONOTUSEUNICODE}
  if PotentialBreakItemNo>=0 then begin
    ItemNo := PotentialBreakItemNo;
    Offs := PotentialBreakOffs;
  end;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetInplaceEditor: TControl;
begin
  Result := nil
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.DestroyInplaceEditor;
begin

end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetNextFocusedItem(ItemNo: Integer; GoForward: Boolean;
                                  var TopLevelRVData: TCustomRVFormattedData;
                                  var TopLevelItemNo: Integer): Integer;
var i: Integer;
    Style: TRVStyle;
    {...........................................}
    function CheckItem(ItemNo: Integer): Boolean;
    begin
      if GetItem(i).GetBoolValueEx(rvbpAllowsFocus, Style) then begin
        TopLevelRVData := Self;
        TopLevelItemNo := ItemNo;
        Result := True;
        exit;
      end;
      Result := GetItem(i).MoveFocus(GoForward, TPersistent(TopLevelRVData), TopLevelItemNo);
    end;
    {...........................................}
begin
  if (FocusedItemNo<0) or (FocusedItemNo>=Items.Count) then
    FocusedItemNo := -1;
  Style := GetRVStyle;
  if GoForward then begin
    if (ItemNo<0) or
       GetItem(ItemNo).GetBoolValueEx(rvbpAllowsFocus, Style) then
      inc(ItemNo);
    for i := ItemNo to Items.Count-1 do
      if CheckItem(i) then begin
        Result := i;
        exit;
      end;
    end
  else begin
    if ItemNo<0 then
      ItemNo := Items.Count;
    if (ItemNo=Items.Count) or
       GetItem(ItemNo).GetBoolValueEx(rvbpAllowsFocus, Style) then
      dec(ItemNo);
    for i := ItemNo downto 0 do
      if CheckItem(i) then begin
        Result := i;
        exit;
      end;
  end;
  Result := -1;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.ClearFocus;
begin
  if (FocusedItemNo<0) or (FocusedItemNo>=Items.Count) then
    FocusedItemNo := -1;
  if FocusedItemNo<>-1 then
    GetItem(FocusedItemNo).ClearFocus;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.AdjustFocus(NewFocusedItemNo: Integer;
                  TopLevelRVData: TPersistent; TopLevelItemNo: Integer);
begin
  FocusedItemNo := NewFocusedItemNo;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.ShowRectangle(Left, Top, Width, Height: Integer);
begin
  if (Left<GetHOffs) then begin
    HScrollTo(Left-GetWidth div 4);
    end
  else if (Left+Width>GetHOffs+GetWidth) then begin
    HScrollTo(Left-GetWidth div 4);
  end;

  if (Top+Height>GetVOffs+GetHeight-GetVSmallStep*2) and (Top<GetVOffs+GetVSmallStep) then exit;

  if (Top+Height>GetVOffs+GetHeight) then begin
     ScrollTo(Top+Height-GetHeight+GetVSmallStep,True);
    end
  else if (Top<GetVOffs) then begin
     ScrollTo(Top,True);
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.BuildJumpsCoords(var StartJumpNo: Integer; jumps: TList);
var i: Integer;
    LastItemNo,tmp: Integer;
    jmpinfo: TRVJumpInfo;
    Style: TRVStyle;
    item: TCustomRVItemInfo;
begin
  if jumps=nil then
    jumps := Self.jumps;
  Style := GetRVStyle;
  if Style=nil then exit;
  nJmps := 0;
  LastItemNo := -1;
  for i := 0 to DrawItems.Count-1 do begin
    item := GetItem(DrawItems[i].ItemNo);
    if item.GetBoolValueEx(rvbpJump, Style) then
      with DrawItems[i] do begin
        jmpinfo     := TRVJumpInfo.Create;
        jmpinfo.l   := ObjectLeft;
        jmpinfo.t   := ObjectTop;
        jmpinfo.w   := ObjectWidth;
        jmpinfo.h   := ObjectHeight;
        jmpinfo.id  := nJmps+StartJumpNo;
        if LastItemNo=DrawItems[i].ItemNo then
          dec(jmpinfo.id);
        jmpinfo.RVData := Self;
        jmpinfo.DrawItemNo := i;
        GetItem(DrawItems[i].ItemNo).JumpID := jmpinfo.id;
        if (item.StyleNo<0) then
          jmpinfo.Cursor := item.GetHypertextCursor(Style)
        else
          jmpinfo.Cursor := Style.TextStyles[GetActualStyle(item)].JumpCursor;
        jumps.Add(jmpinfo);
        if LastItemNo<>DrawItems[i].ItemNo then begin
           inc(nJmps);
           LastItemNo := DrawItems[i].ItemNo;
        end;
      end
    else if item.StyleNo<0 then
      with DrawItems[i] do begin
        tmp := nJmps+ StartJumpNo;
        item.BuildJumps(Left, Top, tmp, jumps);
        nJmps := tmp-StartJumpNo;
      end;
  end;
  inc(StartJumpNo,nJmps);
end;
{------------------------------------------------------------------------------}
{ Coordinates of the top left corner of this RVData relative to the closest
  top left of the parent RichView's document (the root one or inplace editor)
  (overriden in TRVTableCellData)                                              }
procedure TCustomRVFormattedData.GetOrigin(var ALeft, ATop: Integer);
begin
  ALeft := 0;
  ATop := 0;
end;
{------------------------------------------------------------------------------}
{ Coordinates of the top left corner of this RVData relative to the top left of
  the root parent RichView's document
  (overriden in TRVTableCellData, TRVTableInplaceRVData)                       }
procedure TCustomRVFormattedData.GetOriginEx(var ALeft, ATop: Integer);
begin
  ALeft := 0;
  ATop := 0;
end;
{------------------------------------------------------------------------------}
{ Converts coordinates from coordinates related to this RVData to
  coordinates related to the absolute root data }
procedure TCustomRVFormattedData.ConvertCoordToAbsRootData(var X, Y: Integer);
var AX, AY: Integer;
begin
  GetOriginEx(AX, AY);
  inc(X, AX);
  inc(Y, AY);
end;
{------------------------------------------------------------------------------}
{ Is the specified position (drawing item, offset in it) inside the selection?
  Beginning and end of the selection are treated as a selection if
  IncludeBorders=True
}
function TCustomRVFormattedData.DItem_InsideSelection(DItemNo,
  DItemOffs: Integer; IncludeBorders: Boolean): Boolean;
var sno,soff,eno,eoff: Integer;
begin
  Result := False;
  if not SelectionExists(False, False) then
    exit;
  GetSelBounds(sno, eno, soff,eoff, True);
  if IncludeBorders then
    Result := (sno>=0) and
     ((DItemNo>sno) or ((DItemNo=sno) and (DItemOffs>=soff))) and
     ((DItemNo<eno) or ((DItemNo=eno) and (DItemOffs<=eoff)))
  else
    Result := (sno>=0) and
     ((DItemNo>sno) or ((DItemNo=sno) and (DItemOffs>soff))) and
     ((DItemNo<eno) or ((DItemNo=eno) and (DItemOffs<eoff)))
end;
{------------------------------------------------------------------------------}
{ Is the specified position (item, offset in it) inside the selection?
  Unlike DItem_InsideSelection, checks if the current RVData is completely
  selected in its parent RVData.
  Beginning and end of the selection are treated as a selection if
  IncludeBorders=True                                                          }
function  TCustomRVFormattedData.Item_InsideSelection(ItemNo, ItemOffs: Integer;
  IncludeBorders: Boolean): Boolean;
var sno,soff,eno,eoff: Integer;
    PItemNo: Integer;
    Location: TRVStoreSubRVData;
begin
  Result := False;
  if GetParentData<>nil then begin
    GetParentInfo(PItemNo, Location);
    Location.Free;
    if (PItemNo>=0) then
      Result := TCustomRVFormattedData(GetParentData).Item_InsideSelection(PItemNo, 0, True);
  end;
  if Result then
    exit;
  if not SelectionExists(False, False) then
    exit;
  GetSelectionBounds(sno, soff, eno, eoff, True);
  if (sno<0) or ((sno=eno) and (soff=eoff)) then
    exit;
  if IncludeBorders then
    Result :=
      ((ItemNo>sno) or ((ItemNo=sno) and (ItemOffs>=soff))) and
      ((ItemNo<eno) or ((ItemNo=eno) and (ItemOffs<=eoff)))
  else
    Result :=
      ((ItemNo>sno) or ((ItemNo=sno) and (ItemOffs>soff))) and
      ((ItemNo<eno) or ((ItemNo=eno) and (ItemOffs<eoff)))
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.AfterDeleteStyles(Data: TRVDeleteUnusedStylesData);
{$IFNDEF RVDONOTUSEINPLACE}
var inplace: TControl;
{$ENDIF}
begin
  {$IFNDEF RVDONOTUSEINPLACE}
  inplace := GetInplaceEditor;
  if inplace is TCustomRichView then
    TCustomRichView(inplace).RVData.AfterDeleteStyles(Data);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
{ X, Y - document coordinates }
procedure TCustomRVFormattedData.GetItemAt(X, Y: Integer; var ItemNo,
  OffsetInItem: Integer);
begin
  FindDrawItemForSel(X, Y, ItemNo, OffsetInItem, True, False);
  if ItemNo<>-1 then
    DrawItem2Item(ItemNo, OffsetInItem, ItemNo, OffsetInItem);
end;
{------------------------------------------------------------------------------}
{ X, Y - document coordinates }
procedure TCustomRVFormattedData.GetItemAtEx(X,Y: Integer;
  var RVData: TCustomRVFormattedData; var ItemNo, OffsetInItem: Integer;
  Strict, ClosestSubRVData: Boolean; var InSubRVDataOwnerItem: Boolean);
var AX, AY, BX,BY: Integer;
begin
  InSubRVDataOwnerItem := False;
  RVData := Self;
  FindDrawItemForSel(X, Y, ItemNo, OffsetInItem, Strict, False);
  if ItemNo>=0 then begin
    DrawItem2Item(ItemNo, OffsetInItem, ItemNo, OffsetInItem);
    GetItemCoords(ItemNo, AX, AY);
    RVData := TCustomRVFormattedData(GetItem(ItemNo).GetSubRVDataAt(X-AX,Y-AY,
      ClosestSubRVData));
    if RVData=nil then begin
      RVData := Self;
      InSubRVDataOwnerItem := GetItem(ItemNo).GetBoolValue(rvbpHasSubRVData);
      end
    else begin
      RVData.GetOriginEx(BX,BY);
      GetOriginEx(AX,AY);
      X := X+AX-BX;
      Y := Y+AY-BY;
      RVData.GetItemAtEx(X,Y, RVData, ItemNo, OffsetInItem, Strict,
        ClosestSubRVData, InSubRVDataOwnerItem);
    end;
  end;
end;
{------------------------------------------------------------------------------}
{ X, Y - document coordinates or client coordinates, depending on ClientCoords }
function TCustomRVFormattedData.FindWordAtR(var Word: TRVRawByteString; X,Y: Integer;
  var StyleNo, ItemNo, Offs: Integer;
  var RVData: TCustomRVFormattedData;
  ClientCoords: Boolean): Boolean;
var
    Len: Integer;
    ItemOptions: TRVItemOptions;
    AX, AY, BX, BY: Integer;
    CodePage: TRVCodePage;
begin
  if ClientCoords then begin
    GetOrigin(AX, AY);
    inc(X, -AX+GetHOffs);
    inc(Y, -AY+GetVOffs);
  end;
  Result := False;
  RVData := Self;
  FindDrawItemForSel(X, Y, ItemNo, Offs, True, False);
  if ItemNo>=0 then begin
    DrawItem2Item(ItemNo, Offs, ItemNo, Offs);
    GetItemCoords(ItemNo, AX, AY);
    RVData := TCustomRVFormattedData(GetItem(ItemNo).GetSubRVDataAt(X-AX,Y-AY,False));
    if RVData=nil then begin
      RVData := Self;
      Word   := Items[ItemNo];
      CodePage := GetItemCodePage(ItemNo);
      StyleNo := GetItemStyle(ItemNo);
      if StyleNo>=0 then begin
        ItemOptions := GetItemOptions(ItemNo);
        if IsDelimiter(Word, Offs, ItemOptions, CodePage) then begin
          Word := '';
          Result := True;
          exit;
        end;
        while (Offs>1) and not IsDelimiter(Word, Offs-1, ItemOptions, CodePage) do
          dec(Offs);
        Len := 1;
        while (Offs+Len-1<RVU_Length(Word,ItemOptions)) and
          not IsDelimiter(Word, Offs+Len, ItemOptions, CodePage) do
          inc(Len);
        Word := RVU_Copy(Word, Offs, Len, ItemOptions);
      end;
      Result := True;
      end
    else begin
      RVData.GetOriginEx(BX,BY);
      GetOriginEx(AX,AY);
      X := X+AX-BX;
      Y := Y+AY-BY;
      Result := RVData.FindWordAtR(Word, X,Y, StyleNo, ItemNo, Offs, RVData, False);
    end;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetEditor: TWinControl;
begin
  Result := nil;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.ResetSubCoords;
begin

end;
{------------------------------------------------------------------------------}
{ Selects the screen line containing (ItemNo, Offs) location.                  }
procedure TCustomRVFormattedData.SelectLine(ItemNo, Offs: Integer);
var DItemNo, DOffs: Integer;
    DStrt, DEnd: Integer;
    ItemNo1,ItemNo2,Offs1, Offs2: Integer;
begin
  Item2DrawItem(ItemNo,Offs,DItemNo,DOffs, rvdpBetterBelow);
  DStrt := DItemNo;
  while not DrawItems[DStrt].FromNewLine do
    dec(DStrt);
  DEnd := DItemNo+1;
  while (DEnd<Items.Count) and not DrawItems[DEnd].FromNewLine do
    inc(DEnd);
  dec(DEnd);
  DrawItem2Item(DStrt, GetOffsBeforeDrawItem(Dstrt), ItemNo1, Offs1);
  DrawItem2Item(DEnd, GetOffsAfterDrawItem(DEnd), ItemNo2, Offs2);
  SetSelectionBounds(ItemNo1, Offs1, ItemNo2, Offs2);
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetSoftPageBreaks: TRVSoftPageBreakList;
begin
  Result := FSoftPageBreaks;
end;
{------------------------------------------------------------------------------}
{ Fills the list of soft page breaks by information form RVPrint (must be of
  TCustomRVPrint class).
  RVPrint must be formatted for printing.                                      }
procedure TCustomRVFormattedData.AssignSoftPageBreaks(RVPrint: TComponent);
var i: Integer;
begin
  ClearSoftPageBreaks;
  FSoftPageBreaks := TRVSoftPageBreakList.Create;
  for i := 2 to TCustomMultiPagePtblRVData(TCustomRVPrint(RVPrint).rv.RVData).Pages.Count do
    AssignSoftPageBreak(TCustomRVPrint(RVPrint).rv.RVData, i);
  if rvoShowPageBreaks in Options then
    Invalidate;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.AssignSoftPageBreak(
  CustomMultiPagePtblRVData: TCustomRVFormattedData; PageNo: Integer);
var Item: TRVSoftPageBreakInfo;
    RVData: TCustomMultiPagePtblRVData;
begin
  if FSoftPageBreaks=nil then
    FSoftPageBreaks := TRVSoftPageBreakList.Create;

  RVData := TCustomMultiPagePtblRVData(CustomMultiPagePtblRVData);

  if not RVData.IsComplexSoftPageBreak(PageNo) then begin
    Item := TRVSoftPageBreakInfo.Create;
    RVData.GetFirstItemOnPageEx(PageNo, item.ItemNo, item.Offset, item.ExtraData);
    FSoftPageBreaks.Add(Item);
    end
  else
    RVData.AssignComplexSoftPageBreakToItem(PageNo, Self);
end;
{------------------------------------------------------------------------------}
{ Clears, destorys and nils the list of soft page breaks                       }
function TCustomRVFormattedData.ClearSoftPageBreaks: Boolean;
var i: Integer;
begin
  if rvstPreserveSoftPageBreaks in State then begin
    Result := False;
    exit;
  end;
  Result := FSoftPageBreaks<>nil;
  if Result then begin
    FSoftPageBreaks.Free;
    FSoftPageBreaks := nil;
    for i := 0 to GetRVData.ItemCount-1 do
      GetRVData.GetItem(i).ClearSoftPageBreaks;
  end;
end;
{------------------------------------------------------------------------------}
{ Returns a line number of location (ItemNo, ItemOffs). Line numbers are
  started from 1. Line number are counted from the beginning of each RVData.
  This method is relatively slow: iteration from the beginning of this RVData
  items.                                                                       }
function TCustomRVFormattedData.GetLineNo(ItemNo, ItemOffs: Integer): Integer;
var i, DItemNo, DItemOffs: Integer;
    f: Boolean;
begin
  Result := 0;
  f := True;
  try
    Item2DrawItem(ItemNo, ItemOffs, DItemNo, DItemOffs, rvdpBetterBelow);
  except
    f := False;
  end;
  if not f then
    exit;
  for i := DItemNo downto 0 do
    if DrawItems[i].FromNewLine then
      inc(Result);
end;
{------------------------------------------------------------------------------}
{ Called in MouseUp. Adjusts selection. Overriden in TRVEditRVData (where
  selects resizable item if needed)                                            } 
procedure TCustomRVFormattedData.AdjustMouseUpSelection;
begin

end;
{------------------------------------------------------------------------------}
{ Searching for the item containing AControl and selecting it. Search is
  recursive, it includes nested RVData-s.                                      }
function TCustomRVFormattedData.SelectControl(AControl: TControl): Boolean;
    {........................................................}
    function SearchInItem(item: TCustomRVItemInfo): Boolean;
    var SubRVData: TCustomRVFormattedData;
        StoreSub: TRVStoreSubRVData;
    begin
      Result := False;
      SubRVData := TCustomRVFormattedData(item.GetSubRVData(StoreSub, rvdFirst));
      if SubRVData=nil then
        exit;
      repeat
        Result := TCustomRVFormattedData(SubRVData.GetRVData).SelectControl(AControl);
        if Result then
          break;
        SubRVData := TCustomRVFormattedData(item.GetSubRVData(StoreSub, rvdNext));
      until SubRVData=nil;
      StoreSub.Free;
    end;
    {........................................................}    
var i: Integer;
    RVData: TCustomRVFormattedData;
begin
  Result := False;
  for i := 0 to ItemCount-1 do
    if GetItemStyle(i)<0 then begin
      if (GetItem(i) is TRVControlItemInfo) and
         GetItem(i).OwnsControl(AControl) then begin
         RVData := TCustomRVFormattedData(Edit);
         RVData.SetSelectionBounds(i, 0, i, 1);
         RVData.Invalidate;
         Result := True;
         exit;
      end;
      Result := SearchInItem(GetItem(i));
      if Result then
        break;
    end;
end;
{------------------------------------------------------------------------------}
{ Returns True if the position (DrawItemNo,DrawItemOffs) is inside a word      }
function TCustomRVFormattedData.InsideWord(DrawItemNo,
  DrawItemOffs: Integer): Boolean;
var s: TRVRawByteString;
    StyleNo : Integer;
    ItemOptions: TRVItemOptions;
    CodePage: TRVCodePage;
begin
  Result := False;
  StyleNo := GetDrawItemStyle(DrawItemNo);
  CodePage := GetStyleCodePage(StyleNo);
  if (StyleNo<0) or
     (DrawItemOffs<=GetOffsBeforeDrawItem(DrawItemNo)) or
     (DrawItemOffs>=GetOffsAfterDrawItem(DrawItemNo)) then
    exit;
  s := DrawItems.GetString(DrawItemNo, Items);
  ItemOptions := GetItemOptions(DrawItems[DrawItemNo].ItemNo);
  Result := not IsDelimiter(s, DrawItemOffs-1, ItemOptions, CodePage) and
            not IsDelimiter(s, DrawItemOffs, ItemOptions, CodePage);
end;
{------------------------------------------------------------------------------}
{ Returns bounds of word containing position (DrawItemNo,DrawItemOffs).
  Returns:
  DrawItemWordOffs1 - index of the first word character (1-based),
  DrawItemWordOffs2 - index of the first character after the word (1-based).
  This procedure assumes that position is inside word (check by InsideWord())  }
procedure TCustomRVFormattedData.GetWordBounds(DrawItemNo,
  DrawItemOffs: Integer; var DrawItemWordOffs1, DrawItemWordOffs2: Integer);
var s: TRVRawByteString;
    ItemOptions: TRVItemOptions;
    Len: Integer;
    CodePage: TRVCodePage;
begin
  s := DrawItems.GetString(DrawItemNo, Items);
  ItemOptions := GetItemOptions(DrawItems[DrawItemNo].ItemNo);
  CodePage := GetItemCodePage(DrawItems[DrawItemNo].ItemNo);
  DrawItemWordOffs1 := DrawItemOffs-1;
  while (DrawItemWordOffs1-1>0) and
        not IsDelimiter(s, DrawItemWordOffs1-1, ItemOptions, CodePage) do
    dec(DrawItemWordOffs1);
  DrawItemWordOffs2 := DrawItemOffs;
  Len := RVU_Length(s, ItemOptions);
  while (DrawItemWordOffs2<=Len) and
        not IsDelimiter(s, DrawItemWordOffs2, ItemOptions, CodePage) do
    inc(DrawItemWordOffs2);
end;
{------------------------------------------------------------------------------}
{ Adjusts selection bounds depending on RVStyle.SelectionMode.
  (X,Y) is coordinate of mouse making selection (relative to the top left
  corner of the document).
  Returns True if the new selection bounds are different from their previous
  values.                                                                      }
function TCustomRVFormattedData.AdjustSelectionByMode(X, Y: Integer): Boolean;
var w1, w2: Integer;
    AdjustSelEnd: Boolean;
    OldSelSNo, OldSelENo, OldSelSOffs, OldSelEOffs: Integer;
    DrawItemNo, DrawItemOffs: Integer;
    {...........................................................}
    function IsSelectionChanged: Boolean;
    begin
      Result := (OldSelSNo<>FSelStartNo) or (OldSelENo<>FSelEndNo) or
        (OldSelSOffs<>FSelStartOffs) or (OldSelEOffs<>FSelEndOffs);
    end;
    {...........................................................}
begin
  GetSelectionBounds(OldSelSNo, OldSelSOffs, OldSelENo, OldSelEOffs, False);
  FindDrawItemForSel(X, Y, DrawItemNo, DrawItemOffs, False, False);
  if FSelectingInfo<>nil then begin
    if FSelectingInfo.SWordState=rvsesParaMode then begin
      FSelectingInfo.DrawItemENo := DrawItemNo;
      FSelectingInfo.DrawItemEOffs := DrawItemOffs;
      FSelStartNo   := FSelectingInfo.DrawItemSNo;
      FSelStartOffs := FSelectingInfo.DrawItemSOffs;
      FSelEndNo     := DrawItemNo;
      FSelEndOffs   := DrawItemOffs;
      ExpandSelectionToParagraph(True);
      Result := IsSelectionChanged;
      exit;
    end;
    AdjustSelEnd := True;
    // 1. Adjusting selection start
    case FSelectingInfo.SWordState of
      rvsesInWord: // mouse is inside the initial word
        begin
          // checking mouse leaving the initial word
          // when it leaves, setting SWordState := rvsesOutsideWord and
          // adjusting the selection start to the word bound
          if FSelectingInfo.IsAboveSWord(DrawItemNo, DrawItemOffs) then begin
            FSelectingInfo.SWordState := rvsesOutsideWord;
            FSelStartOffs := FSelectingInfo.DrawItemSWordOffs2;
            end
          else if FSelectingInfo.IsBelowSWord(DrawItemNo, DrawItemOffs) then begin
            FSelectingInfo.SWordState := rvsesOutsideWord;
            FSelStartOffs := FSelectingInfo.DrawItemSWordOffs1;
            end
          else
            AdjustSelEnd := False;
        end;
      rvsesOutsideWord: // mouse is outside the initial word
        begin
          // checking mouse returning to the initial word
          // when it returns, stopping adjusting the selection start,
          // setting SWordState := rvsesFreeMode
          if FSelectingInfo.IsInSWord(DrawItemNo, DrawItemOffs) then begin
            FSelStartOffs := FSelectingInfo.DrawItemSOffs;
            FSelectingInfo.SWordState := rvsesFreeMode;
            AdjustSelEnd := False;
          end;
        end;
    end;
    // 1. Adjusting selection end
    if AdjustSelEnd then begin
      if InsideWord(DrawItemNo, DrawItemOffs) then begin
        GetWordBounds(DrawItemNo, DrawItemOffs, w1, w2);
        if FSelectingInfo.IsEWord(DrawItemNo, w1, w2) then
          // mouse is in the same word as before
          case FSelectingInfo.EWordState of
            rvsesInWord:
              begin
                // if it's moved in backward direction, allowing selection
                // by characters (setting EWordState := rvsesFreeMode)
                if FSelectingInfo.IsEFreeStateNeeded(DrawItemNo, DrawItemOffs) then begin
                  FSelectingInfo.EWordState := rvsesFreeMode;
                  AdjustSelEnd := False;
                  end
                else
                // if it's moved in forward direction, updating DrawItemEOffs
                  FSelectingInfo.DrawItemEOffs := DrawItemOffs;
              end;
            rvsesFreeMode:
              AdjustSelEnd := False;
          end
        else begin
          // mouse is entered a new word
          FSelectingInfo.EWordState := rvsesInWord;
          FSelectingInfo.DrawItemEWordOffs1 := w1;
          FSelectingInfo.DrawItemEWordOffs2 := w2;
          FSelectingInfo.DrawItemEOffs := DrawItemOffs;
        end;
        // adjusting the selection end
        if AdjustSelEnd then
          if FSelectingInfo.IsAboveSWord(DrawItemNo, DrawItemOffs) then begin
            DrawItemOffs := w1;
            end
          else if FSelectingInfo.IsBelowSWord(DrawItemNo, DrawItemOffs) then begin
            DrawItemOffs := w2;
          end;
        end
      else begin
        // mouse is outside word
        FSelectingInfo.EWordState := rvsesInWord;
        FSelectingInfo.DrawItemEWordOffs1 := -1;
        FSelectingInfo.DrawItemEWordOffs2 := -1;
      end;
    end;
  end;
  FSelEndNo := DrawItemNo;
  FSelEndOffs := DrawItemOffs;
  Result := IsSelectionChanged;
end;
{------------------------------------------------------------------------------}
{ Making selection by lines.
  (X,Y) is coordinate of mouse making selection (relative to the top left
  corner of the document).                                                     }
function TCustomRVFormattedData.AdjustLineSelection(X, Y: Integer): Boolean;
var OldSelSNo, OldSelENo, OldSelSOffs, OldSelEOffs: Integer;
    {...........................................................}
    function IsSelectionChanged: Boolean;
    begin
      Result := (OldSelSNo<>FSelStartNo) or (OldSelENo<>FSelEndNo) or
        (OldSelSOffs<>FSelStartOffs) or (OldSelEOffs<>FSelEndOffs);
    end;
    {...........................................................}
begin
  GetSelectionBounds(OldSelSNo, OldSelSOffs, OldSelENo, OldSelEOffs, False);
  FindDrawItemForSel(X, Y, FSelEndNo, FSelEndOffs, False, False);
  ExpandSelectionToLines(False);
  if GetRVStyle.SelectionMode=rvsmParagraph then
    ExpandSelectionToParagraph(True);
  Result := IsSelectionChanged;
end;
{------------------------------------------------------------------------------}
{ Expands the selection (if it is not empty) to the paragraphs boundaries
  Does nothing if OnlyIfMultiple=True and selection does not include
  more than 1 paragraph.                                                       }
function TCustomRVFormattedData.ExpandSelectionToParagraph(
  OnlyIfMultiple: Boolean): Boolean;
  {..........................................................}
  procedure ExpandUp(var DrawItemNo, DrawItemOffs: Integer);
  begin
    while DrawItemNo>0 do begin
      if IsDrawItemParaStart(DrawItemNo) then
        break;
      dec(DrawItemNo);
    end;
    DrawItemOffs := GetOffsBeforeDrawItem(DrawItemNo);
  end;
  {..........................................................}
  procedure ExpandDown(var DrawItemNo, DrawItemOffs: Integer);
  begin
    while DrawItemNo+1<DrawItems.Count do begin
      if IsDrawItemParaStart(DrawItemNo+1) then
        break;
      inc(DrawItemNo);
    end;
    DrawItemOffs := GetOffsAfterDrawItem(DrawItemNo);
  end;
begin
  Result := (FSelStartNo>=0) and
     not ((FSelStartNo=FSelEndNo) and (FSelStartOffs=FSelEndOffs));
  if not Result then
    exit;
  Result := not OnlyIfMultiple or IsMultiParagraphSelection;
  if not Result then
    exit;
  if IsSelectionTopDown then begin
    ExpandUp(FSelStartNo, FSelStartOffs);
    ExpandDown(FSelEndNo, FSelEndOffs);
    end
  else begin
    ExpandDown(FSelStartNo, FSelStartOffs);
    ExpandUp(FSelEndNo, FSelEndOffs);
  end;
end;
{------------------------------------------------------------------------------}
{ If OneLine=False, expands selection to the lines boundaries.
  If OneLine=True, selects the line containing the beginning of selection,
  from the beginning to the end of the line                                    }
procedure TCustomRVFormattedData.ExpandSelectionToLines(OneLine: Boolean);
{..........................................................}
  procedure ExpandUp(var DrawItemNo, DrawItemOffs: Integer);
  begin
    while (DrawItemNo>0) and not DrawItems[DrawItemNo].FromNewLine do
      dec(DrawItemNo);
    DrawItemOffs := GetOffsBeforeDrawItem(DrawItemNo);
  end;
  {..........................................................}
  procedure ExpandDown(var DrawItemNo, DrawItemOffs: Integer);
  begin
    while (DrawItemNo+1<DrawItems.Count) and
      not DrawItems[DrawItemNo+1].FromNewLine do
      inc(DrawItemNo);
    DrawItemOffs := GetOffsAfterDrawItem(DrawItemNo);
  end;
  {..........................................................}
begin
  if FSelStartNo<0 then
    exit;
  if OneLine then begin
    FSelEndNo := FSelStartNo;
    ExpandUp(FSelStartNo, FSelStartOffs);
    ExpandDown(FSelEndNo, FSelEndOffs);
    end
  else begin
    if IsSelectionTopDown then begin
      ExpandUp(FSelStartNo, FSelStartOffs);
      ExpandDown(FSelEndNo, FSelEndOffs);
      end
    else begin
      ExpandDown(FSelStartNo, FSelStartOffs);
      ExpandUp(FSelEndNo, FSelEndOffs);
    end;
  end;
end;
{------------------------------------------------------------------------------}
{ Returns True if the selection is in top-down direction.                     }
function TCustomRVFormattedData.IsSelectionTopDown: Boolean;
begin
  Result := (FSelStartNo<FSelEndNo) or
    ((FSelStartNo=FSelEndNo) and (FSelStartOffs<=FSelEndOffs));
end;
{------------------------------------------------------------------------------}
{ Returns True if the drawing item starts a new paragraph.                     }
// Takes hidden text into account
function TCustomRVFormattedData.IsDrawItemParaStart(DrawItemNo: Integer): Boolean;
begin
  Result := (DrawItemNo=0) or
    ((DrawItems[DrawItemNo].ItemNo<>DrawItems[DrawItemNo-1].ItemNo) and
     IsParaStartEx(DrawItems[DrawItemNo].ItemNo));
end;
{------------------------------------------------------------------------------}
{ Returns True if the drawing item is the first drawing item for an item }
function TCustomRVFormattedData.IsDrawItemItemStart(DrawItemNo: Integer): Boolean;
begin
  Result := (DrawItemNo=0) or
    (DrawItems[DrawItemNo].ItemNo<>DrawItems[DrawItemNo-1].ItemNo);
end;
{------------------------------------------------------------------------------}
{ Returns True if the drawing item starts a new paragraph or section inside
  paragraph }
  // Takes hidden text into account
function TCustomRVFormattedData.IsDrawItemParaSectionStart(DrawItemNo: Integer): Boolean;
begin
  Result := (DrawItemNo=0) or
    ((DrawItems[DrawItemNo].ItemNo<>DrawItems[DrawItemNo-1].ItemNo) and
     IsFromNewLineEx(DrawItems[DrawItemNo].ItemNo));
end;
{------------------------------------------------------------------------------}
{ Returns True if the drawing item ends a paragraph.                           }
// Takes hidden text into account
function TCustomRVFormattedData.IsDrawItemParaEnd(DrawItemNo: Integer): Boolean;
begin
  Result := (DrawItemNo=DrawItems.Count-1) or IsDrawItemParaStart(DrawItemNo+1);
end;
{------------------------------------------------------------------------------}
{ Returns true, if the given DrawItem either starts a new line
  or follows a marker                                                          }
function TCustomRVFormattedData.IsDrawItemFromNewLine(DrawItemNo: Integer): Boolean;
begin
  Result := DrawItems[DrawItemNo].FromNewLine;
  {$IFNDEF RVDONOTUSELISTS}
  if not Result and (DrawItemNo>0) and
    (DrawItems[DrawItemNo].ItemNo<>DrawItems[DrawItemNo-1].ItemNo) and
    (GetDrawItemStyle(DrawItemNo-1)=rvsListMarker) then
    Result := True;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
{ Returns true, if the given DrawItem is the last item on the line, and this
  line is not the last line of the paragraph }
function TCustomRVFormattedData.IsDrawItemLastOnWrappedLine(DrawItemNo: Integer): Boolean;
begin
  Result := (DrawItemNo<DrawItems.Count-1) and DrawItems[DrawItemNo+1].FromNewLine and
   not IsDrawItemParaSectionStart(DrawItemNo+1);
end;
{------------------------------------------------------------------------------}
{ Returns the style of item associated with the given drawing item
  // Result := GetItemStyle(DrawItems[DrawItemNo].ItemNo)                      }
function TCustomRVFormattedData.GetDrawItemStyle(DrawItemNo: Integer): Integer;
begin
  Result := GetItem(DrawItems[DrawItemNo].ItemNo).StyleNo;
end;
{------------------------------------------------------------------------------}
{ Returns True if there is a character (space) missed between the DrawItemNo-th
  and the next drawing item }
function TCustomRVFormattedData.IsSpaceBetweenDrawItems(DrawItemNo: Integer): Boolean;
var ditem: TRVDrawLineInfo;
begin
  Result := False;
  ditem := DrawItems[DrawItemNo];
  if ditem.Offs+ditem.Length-1>=ItemLength(ditem.ItemNo) then
    exit;
  if (DrawItemNo+1<DrawItems.Count) and (DrawItems[DrawItemNo+1].ItemNo=ditem.ItemNo) and
     (DrawItems[DrawItemNo+1].Offs = ditem.Offs+ditem.Length) then
    exit;
  Result := True;
end;
{------------------------------------------------------------------------------}
{ Returns True, if the selection includes more than one paragraphs (at least
  partially.                                                                   }
function TCustomRVFormattedData.IsMultiParagraphSelection: Boolean;
var StartDrawItemNo, EndDrawItemNo, i: Integer;
begin
  Result := FSelStartNo>=0;
  if not Result then
    exit;
  if IsSelectionTopDown then begin
    StartDrawItemNo := FSelStartNo;
    EndDrawItemNo   := FSelEndNo;
    end
  else begin
    StartDrawItemNo := FSelEndNo;
    EndDrawItemNo   := FSelStartNo;
  end;
  Result := False;
  for i := StartDrawItemNo+1 to EndDrawItemNo do
    if IsDrawItemParaStart(i) then begin
      Result := True;
      exit;
    end;
end;
{$IFNDEF RVDONOTUSEDRAGDROP}
{------------------------------------------------------------------------------}
{ Drag&Drop: IDropTarget related                                               }
{------------------------------------------------------------------------------}
{ Sets the position of drag&drop target to (X,Y).
  (X,Y) - client coordinates.
  Usually it's called for the root (or inplace editor's) RVData.
  Calls SetDragDropCaret for the RVData containing
  d&d caret. Redraws d&d caret. Scrolls to make it visible.                    }
procedure TCustomRVFormattedData.SetDragDropCaretTo(X,Y: Integer);
var RVData: TCustomRVFormattedData;
    ItemNo, Offs: Integer;
    DragDropCaretInfo: TRVDragDropCaretInfo;
var NoScroll: Boolean;
begin
  inc(X, GetHOffs);
  inc(Y, GetVOffs);
  DrawDragDropCaret(GetCanvas, False);
  GetItemAtEx(X,Y, RVData, ItemNo, Offs, False, False, NoScroll);
  if (RVData<>nil) and (ItemNo>=0) then
    RVData.SetDragDropCaret(ItemNo, Offs);
  DrawDragDropCaret(GetCanvas, False);
  if not NoScroll then begin
    DragDropCaretInfo := GetDragDropCaretInfo;
    if DragDropCaretInfo<>nil then
      with DragDropCaretInfo do
        TCustomRVFormattedData(RVData).ShowRectangle(X, Y, 1, Height);
  end;
end;
{------------------------------------------------------------------------------}
{ Draw drag&drop caret. Usually called to remove it.                           }
procedure TCustomRVFormattedData.RemoveDragDropCaret;
begin
  DrawDragDropCaret(GetCanvas, False);
end;
{------------------------------------------------------------------------------}
{ Sets the position of drag&drop caret
  (fills the field of GetDragDropCaretInfo)                                    }
procedure TCustomRVFormattedData.SetDragDropCaret(ItemNo, Offs: Integer);
var s: TRVRawByteString;
    StyleNo, DItemNo, DOffs, max: Integer;
    ItemOptions: TRVItemOptions;
    arr: PRVIntegerArray;
    ditem: TRVDrawLineInfo;
    DragDropCaretInfo: TRVDragDropCaretInfo;
    UseFormatCanvas: Boolean;
begin
  DragDropCaretInfo := GetDragDropCaretInfo;
  if DragDropCaretInfo=nil then
    exit;
  DragDropCaretInfo.RVData := Self;
  DragDropCaretInfo.ItemNo := ItemNo;
  DragDropCaretInfo.ItemOffs := Offs;
  StyleNo := GetActualStyle(GetItem(ItemNo));
  Item2DrawItem(ItemNo, Offs, DItemNo, DOffs, rvdpBetterBelow);
  ditem := DrawItems[DItemNo];
  DragDropCaretInfo.Y := ditem.Top;
  DragDropCaretInfo.Height := ditem.Height;
  DragDropCaretInfo.X := ditem.Left;
  UseFormatCanvas := GetFormatCanvasEx(nil)<>nil;
  if (StyleNo>=0) and (ditem.Length>0) then begin
    GetRVStyle.ApplyStyle(GetFormatCanvas, StyleNo, GetParaBiDiMode(GetItemParaEx(ItemNo)),
      True, nil, False, UseFormatCanvas);
    ItemOptions := GetItemOptions(ItemNo);
    s := DrawItems.GetString(DItemNo,Items);
    s := RV_ReturnProcessedString(s, GetRVStyle.TextStyles[StyleNo],
      IsDrawItemLastOnWrappedLine(DItemNo), CanShowSpecialCharacters, False);
    GetMem(arr, (ditem.Length+2)*sizeof(Integer));
    try
      if (GetItemBiDiMode(ItemNo)=rvbdUnspecified) or
        not RVU_GetTextCaretPos(GetFormatCanvas, s, arr, ItemOptions,
          RVConvertToFormatCanvas(ditem.Width-ditem.SpaceAtLeft, UseFormatCanvas),
          RVConvertToFormatCanvas(2, UseFormatCanvas),
          GetRVStyle.GraphicInterface) then begin
        if DOffs=1 then
          DragDropCaretInfo.X := ditem.Left
        else begin
          RVU_GetTextExtentExPoint(GetFormatCanvas, s, MaxInt, max, arr, ItemOptions,
            GetRVStyle.GraphicInterface);
          DragDropCaretInfo.X := ditem.Left+RVConvertFromFormatCanvas(arr[DOffs-2], UseFormatCanvas);
        end;
        end
      else
        DragDropCaretInfo.X := ditem.Left+RVConvertFromFormatCanvas(arr[DOffs-1], UseFormatCanvas);
    finally
      FreeMem(arr);
    end;
    end
  else if Offs<=GetOffsBeforeItem(ItemNo) then
    DragDropCaretInfo.X := ditem.Left
  else
    DragDropCaretInfo.X := ditem.Left+ditem.Width;
end;
{------------------------------------------------------------------------------}
{ Returns information about drag&drop caret location.
  Returned value <> nil only if dragging to this RichViewEdit is in process.
  Physically, returned object is a field of the root TRichViewEdit.
  This method is overriden in TRVEditRVData and
  in TRichViewRVData (returns nil)                                             }
function TCustomRVFormattedData.GetDragDropCaretInfo: TRVDragDropCaretInfo;
begin
  Result := TCustomRVFormattedData(GetAbsoluteRootData).GetDragDropCaretInfo;
end;
{------------------------------------------------------------------------------}
{ Drawing drag&drop caret (using inverted color).
  Draws something only when d&d cursor is above the editor.
  If OnlyForSelf, drawing is performed only if this RVData contains
  d&d caret. Otherwise, drawing is performed by RVData contained d&d caret.
  Canvas - canvas for drawing to. If drawing is performed not by this RVData,
  its own Canvas is used instead.                                              }
procedure TCustomRVFormattedData.DrawDragDropCaret(Canvas: TCanvas;
  OnlyForSelf: Boolean);
var DragDropCaretInfo: TRVDragDropCaretInfo;
    dx,dy: Integer;
begin
  DragDropCaretInfo := GetDragDropCaretInfo;
  if (DragDropCaretInfo=nil) or (DragDropCaretInfo.RVData=nil) then
    exit;
  if (DragDropCaretInfo.RVData<>Self) then begin
    if not OnlyForSelf then
      TCustomRVFormattedData(DragDropCaretInfo.RVData).DrawDragDropCaret(
        TCustomRVFormattedData(DragDropCaretInfo.RVData).GetCanvas, True);
    exit;
  end;
  Canvas.Pen.Mode := pmNot;
  Canvas.Pen.Width := 1;
  Canvas.Brush.Style := bsClear;
  Canvas.Pen.Style := psDot;
  GetOrigin(dx,dy);
  dec(dy, GetRVDataExtraVOffs);  
  dec(dx, TCustomRVFormattedData(GetRootData).GetHOffs);
  dec(dy, TCustomRVFormattedData(GetRootData).GetVOffs);
  GetRVStyle.GraphicInterface.LineDragDropCaret(Canvas, dx+DragDropCaretInfo.X,
    DragDropCaretInfo.Y+dy, DragDropCaretInfo.Y+DragDropCaretInfo.Height+dy);
  Canvas.Pen.Style := psSolid;
  Canvas.Pen.Mode := pmCopy;
end;
{------------------------------------------------------------------------------}
{ Drag&Drop: IDropSource related                                               }
{------------------------------------------------------------------------------}
{ Can dragging from this TRichView be started?
  Overriden in TRichViewRVData.                                                }
function TCustomRVFormattedData.CanStartDragging: Boolean;
begin
  Result := TCustomRVFormattedData(GetAbsoluteRootData).CanStartDragging;
end;
{------------------------------------------------------------------------------}
{ Is dragging from this TRichView in process? Overriden in TRichViewRVData.    }
function TCustomRVFormattedData.IsDragging: Boolean;
begin
  Result := TCustomRVFormattedData(GetAbsoluteRootData).IsDragging;
end;
{------------------------------------------------------------------------------}
{ Stores click coordinates. Overriden in TRichViewRVData }
procedure TCustomRVFormattedData.SetClickCoords(X, Y: Integer);
begin
  ConvertCoordToAbsRootData(X, Y);
  TCustomRVFormattedData(GetAbsoluteRootData).SetClickCoords(X, Y);
end;
{------------------------------------------------------------------------------}
{ Is mouse moved far enough from the click point to start dragging? }
function TCustomRVFormattedData.CanStartDragBecauseMouseMoved(X, Y: Integer): Boolean;
begin
  ConvertCoordToAbsRootData(X, Y);
  Result := TCustomRVFormattedData(GetAbsoluteRootData).
    CanStartDragBecauseMouseMoved(X, Y);
end;
{------------------------------------------------------------------------------}
{ Initializing dragging. Overriden in TRichViewRVData.
  Returns True on success.
  Returns DropSource and OKEffect for call of DoDragDrop.                      }
function TCustomRVFormattedData.InitDragging(var DropSource: TRVDropSource;
  var OKEffect: Integer): Boolean;
begin
  Result := TCustomRVFormattedData(GetAbsoluteRootData).InitDragging(DropSource, OKEffect);
end;
{------------------------------------------------------------------------------}
{ Finalizing dragging. Overriden in TRichViewRVData.                           }
procedure TCustomRVFormattedData.DoneDragging(FDeleteSelection: Boolean);
begin
  TCustomRVFormattedData(GetAbsoluteRootData).DoneDragging(FDeleteSelection);
end;
{------------------------------------------------------------------------------}
type
  TSHDoDragDrop = function (hwnd: HWND; dataObj: IDataObject;
    dropSource: IDropSource; dwOKEffects: Longint;
    var dwEffect: Longint): HResult; stdcall;

function RVDoDragDrop(hwnd: HWND; dataObj: IDataObject; dropSource: IDropSource;
  dwOKEffects: Longint; var dwEffect: Longint): HResult;
{var hLib: HINST;
    SHDoDragDrop: TShDoDragDrop;
}
begin
{
  Result := 0;
  SHDoDragDrop := nil;
  if Win32Platform = VER_PLATFORM_WIN32_NT then begin
    hLib := LoadLibrary('shell32.dll');
    try
      SHDoDragDrop := GetProcAddress(hLib, 'SHDoDragDrop');
      if Assigned(SHDoDragDrop) then
        Result := SHDoDragDrop(hwnd, dataObj, dropSource, dwOKEffects, dwEffect);
    finally
      FreeLibrary(hLib);
    end;
  end;
  if not Assigned(SHDoDragDrop) then
}
    Result := DoDragDrop(dataObj, dropSource, dwOKEffects, dwEffect);
end;
{------------------------------------------------------------------------------}
{ Perform drag & drop from this RVData (called only for absolute root RVData)  }
procedure TCustomRVFormattedData.DoDrag;
var Effect, OKEffect: LongInt;
    DropSource: TRVDropSource;
begin
  State := State-[rvstStartingDragDrop]+[rvstCanDragDropDeleteSelection];
  if InitDragging(DropSource, OKEffect) then begin
    RVDoDragDrop(GetParentControl.Handle, DropSource as IDataObject, DropSource as IDropSource,
      OKEffect, Effect);
    DoneDragging((Effect=DROPEFFECT_MOVE) and (rvstCanDragDropDeleteSelection in State));
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ Returns true, if insertion in the specified location is possible.
  Used by drag&drop functions.                                                 }
function TCustomRVFormattedData.CanInsertHere(ItemNo, Offs: Integer): Boolean;
begin
  Result := False;
  if IsItemParaProtected(ItemNo) then
    exit;
  if Offs<=GetOffsBeforeItem(ItemNo) then
    Result := not IsSticking(ItemNo-1, True)
  else if Offs>=GetOffsAfterItem(ItemNo) then
    Result := not IsSticking(ItemNo, True)
  else
    Result := not IsProtected(ItemNo, rvprModifyProtect);
end;
{------------------------------------------------------------------------------}
{ Returns true if the ItemNo-th item has the specified protection.
  There is a special processing of rvprDeleteProtect - for non-text items,
  their DeleteProtect property is returned.
  This function used in editor and by CanInsertHere().                         }
function TCustomRVFormattedData.IsProtected(ItemNo: Integer;
  Option: TRVProtectOption): Boolean;
var item: TCustomRVItemInfo;
    TextStyleNo: Integer;
begin
  item := GetItem(ItemNo);
  if item.StyleNo>=0 then
    Result := Option in GetRVStyle.TextStyles[GetActualStyle(item)].Protection
  else begin
    TextStyleNo := item.AssociatedTextStyleNo;
    if TextStyleNo>=0 then
      Result := Option in GetRVStyle.TextStyles[TextStyleNo].Protection
    else
      Result := False;
    if Option = rvprDeleteProtect then
      Result := Result or TRVNonTextItemInfo(item).DeleteProtect
  end;
end;
{------------------------------------------------------------------------------}
{ Returns true if the ParaNo-th paragraph style has the specified option.
  This function used in editor and by CanInsertHere().                         }
function TCustomRVFormattedData.IsParaProtected(ParaNo: Integer;
  Option: TRVParaOption): Boolean;
begin
  Result := Option in GetRVStyle.ParaStyles[ParaNo].Options;
end;
{------------------------------------------------------------------------------}
{ Returns true if the ItemNo-th item's paragraph style is read-only.
  This function used in editor and by CanInsertHere().                         }
function TCustomRVFormattedData.IsItemParaProtected(ItemNo: Integer): Boolean;
begin
  Result := IsParaProtected(GetItemParaEx(ItemNo), rvpaoReadOnly);
end;
{------------------------------------------------------------------------------}
{ Returns true if insertion between FirstItemNo and (FirstItemNo+1) items is
  forbidden.
  FirstItemNo=-1 and FirstItemNo=Items.Count-1 are valid indices.
  This function used in editor and by CanInsertHere().
  If the function returns True and not NoSound, the function beeps             }
function TCustomRVFormattedData.IsSticking(FirstItemNo: Integer;
  NoSound: Boolean): Boolean;
begin
  if (FirstItemNo=-1) then
    Result := IsProtected(0, rvprStickToTop)
  else if (FirstItemNo=Items.Count-1) then
    Result := IsProtected(FirstItemNo, rvprStickToBottom)
  else
    Result := (IsProtected(FirstItemNo, rvprSticking) and
              IsProtected(FirstItemNo+1, rvprSticking)) or
              (IsProtected(FirstItemNo, rvprSticking2) and
              IsProtected(FirstItemNo+1, rvprSticking2)) or
              (IsProtected(FirstItemNo, rvprSticking3) and
              IsProtected(FirstItemNo+1, rvprSticking3));
  if Result and not NoSound then
    Beep;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSELIVESPELL}
procedure TCustomRVFormattedData.LiveSpellingCheckCurrentItem;
begin
  if not (rvflRoot in Flags) then
    TCustomRVFormattedData(GetAbsoluteRootData).LiveSpellingCheckCurrentItem;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEANIMATION}
procedure TCustomRVFormattedData.InsertAnimator(var Animator: TObject);
begin
  TCustomRVFormattedData(GetAbsoluteRootData).InsertAnimator(Animator);
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.AllowAnimation: Boolean;
begin
  Result := TCustomRVFormattedData(GetAbsoluteRootData).AllowAnimation;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.ResetAniBackground;
begin
  TCustomRVFormattedData(GetAbsoluteRootData).ResetAniBackground;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESMARTPOPUP}
procedure TCustomRVFormattedData.AdjustSpecialControlsCoords(
  RVData: TCustomRVFormattedData);
begin

end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.CreateFontInfoCache(ACanvas, AFormatCanvas: TCanvas);
begin

end;
{------------------------------------------------------------------------------}
procedure TCustomRVFormattedData.DestroyFontInfoCache(var Cache: TRVFontInfoCache);
begin
  if (Cache<>nil) and (Cache.FOwner=Self) then begin
    Cache.Free;
    Cache := nil;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetFontInfoCache(ACanvas, AFormatCanvas: TCanvas;
  RVData: TCustomRVFormattedData): TRVFontInfoCache;
begin
  Result := TCustomRVFormattedData(GetAbsoluteRootData).GetFontInfoCache(ACanvas,AFormatCanvas,Self);
end;
{------------------------------------------------------------------------------}
function TCustomRVFormattedData.GetItemPart(ItemNo,
  OffsetInItem: Integer): Integer;
var
  i, DrawItemNo, DrawItemOffs : Integer;
begin
  Result := -1;
  If (ItemNo = -1) or (ItemNo >= ItemCount) then
    exit;
  Item2DrawItem(ItemNo, OffsetInItem, DrawItemNo, DrawItemOffs, rvdpStrict);
  if DrawItemNo<0 then
    exit;
  for i := DrawItemNo downto 0 do
    if DrawItems[i].ItemNo=ItemNo then
      inc(Result)
    else
      break;
end;
{------------------------------------------------------------------------------}
{ This method is for ScaleRichView }
procedure TCustomRVFormattedData.GetMouseClientCoords(Control: TWinControl;
  var X, Y: Integer);
begin
  TCustomRVFormattedData(GetAbsoluteRootData).GetMouseClientCoords(Control, X, Y);
end;
{------------------------------------------------------------------------------}
// Returns the item paragraph style index, taking hidden text into account
function TCustomRVFormattedData.GetItemParaEx(ItemNo: Integer): Integer;
var i: Integer;
begin
  Result := GetItem(ItemNo).ParaNo;
  if not (rvoShowHiddenText in Options) and not IsHidden(ItemNo) then begin
    // if some text is hidden, the style of item is the style of the first
    // visible preceding parastart item; or, if the hidden text starts
    // a new paragraph, it is the style of the first hidden item
    for i := ItemNo downto 0 do
      if not IsHidden(i) then begin
        if (i<ItemNo) and IsParaStart(i+1) then begin
          // parastart in hidden item i+1
          Result := GetItem(i+1).ParaNo;
          exit;
        end;
        if IsParaStart(i) then begin
          Result := GetItem(i).ParaNo;
          exit;
        end;
      end;
  end;
end;
{------------------------------------------------------------------------------}
// Is this item starts a paragraph? This function takes hidden text into account
function TCustomRVFormattedData.IsParaStartEx(ItemNo: Integer): Boolean;
var i: Integer;
begin
  Result := IsParaStart(ItemNo);
  if not Result and not (rvoShowHiddenText in Options) and not IsHidden(ItemNo) then begin
    // this item may still start a paragraph, if it is the first visible item
    for i := ItemNo-1 downto 0 do
      if not IsHidden(i) then begin
        Result := GetItem(i).GetBoolValue(rvbpFullWidth);
        if not Result then
          Result := IsParaStart(i+1); // may be parastart in hidden item i+1
        exit;
      end;
    Result := True;
  end;
end;
{------------------------------------------------------------------------------}
// Is this item starts a paragraph or its section? This function takes hidden text into account
function TCustomRVFormattedData.IsFromNewLineEx(ItemNo: Integer): Boolean;
var i: Integer;
begin
  Result := IsFromNewLine(ItemNo);
  if not Result and not (rvoShowHiddenText in Options) and not IsHidden(ItemNo) then begin
    // this item may still start a paragraph, if it is the first visible item
    for i := ItemNo-1 downto 0 do
      if not IsHidden(i) then begin
        Result := GetItem(i).GetBoolValue(rvbpFullWidth);
        if not Result then
          Result := IsFromNewLine(i+1); // may be newline in hidden item i+1
        exit;
      end;
    Result := True;
  end;
end;
{------------------------------------------------------------------------------}
// Is this item ends a paragraph or its section? This function takes hidden text into account
function TCustomRVFormattedData.IsLastParaSectionItemEx(ItemNo: Integer): Boolean;
var NextItemNo: Integer;
begin
  NextItemNo := GetNextNonHiddenItemNo(ItemNo);
  if NextItemNo>=0 then
    Result := IsFromNewLineEx(NextItemNo)
  else
    Result := True;
end;
{------------------------------------------------------------------------------}
// Is this item ends a paragraph? This function takes hidden text into account
function TCustomRVFormattedData.IsLastParaItemEx(ItemNo: Integer): Boolean;
var NextItemNo: Integer;
begin
  NextItemNo := GetNextNonHiddenItemNo(ItemNo);
  if NextItemNo>=0 then
    Result := IsParaStartEx(NextItemNo)
  else
    Result := True;
end;
{------------------------------------------------------------------------------}
// Returns the first item in the paragraph, where the ItemNo-th item belongs.
// Takes hidden text into account
function TCustomRVFormattedData.GetFirstParaItemEx(ItemNo: Integer): Integer;
begin
  Result := ItemNo;
  while (Result>0) and not IsParaStartEx(Result) do
    dec(Result);
end;
{------------------------------------------------------------------------------}
// Returns the first item in the paragraph section , where the ItemNo-th item belongs.
// Takes hidden text into account
function TCustomRVFormattedData.GetFirstParaSectionItemEx(ItemNo: Integer): Integer;
begin
  Result := ItemNo;
  while (Result>0) and not IsFromNewLineEx(Result) do
    dec(Result);
end;
{------------------------------------------------------------------------------}
// Returns the index of the first item that is not hidden
function TCustomRVFormattedData.GetFirstNonHiddenItemNo: Integer;
var i: Integer;
begin
  Result := -1;
  for i := 0 to ItemCount-1 do
    if not IsHidden(i) then begin
      Result := i;
      exit;
    end;
end;
{------------------------------------------------------------------------------}
// Returns the index of the last item that is not hidden
function TCustomRVFormattedData.GetLastNonHiddenItemNo: Integer;
var i: Integer;
begin
  Result := -1;
  for i := ItemCount-1 downto 0 do
    if not IsHidden(i) then begin
      Result := i;
      exit;
    end;
end;
{------------------------------------------------------------------------------}
// Returns the first and the last item of paragraph containing
//  the given range of items
// Takes hidden text into account
procedure TCustomRVFormattedData.ExpandToParaEx(ItemNo1,ItemNo2: Integer;
  var FirstItemNo, LastItemNo: Integer);
begin
  FirstItemNo := ItemNo1;
  while (FirstItemNo>0) and (IsHidden(FirstItemNo) or not IsParaStartEx(FirstItemNo)) do
    dec(FirstItemNo);
  LastItemNo := ItemNo2+1;
  while (LastItemNo<Items.Count) and (IsHidden(LastItemNo) or not IsParaStartEx(LastItemNo)) do
    inc(LastItemNo);
  dec(LastItemNo);
end;
{------------------------------------------------------------------------------}
// Returns the first and the last item of paragraph section containing
//  the given range of items
// Takes hidden text into account
procedure TCustomRVFormattedData.ExpandToParaSectionEx(ItemNo1,ItemNo2: Integer;
  var FirstItemNo, LastItemNo: Integer);
begin
  FirstItemNo := ItemNo1;
  while (FirstItemNo>0) and (IsHidden(FirstItemNo) or not IsFromNewLineEx(FirstItemNo)) do
    dec(FirstItemNo);
  LastItemNo := ItemNo2+1;
  while (LastItemNo<Items.Count) and (IsHidden(LastItemNo) or not IsFromNewLineEx(LastItemNo)) do
    inc(LastItemNo);
  dec(LastItemNo);
end;
{------------------------------------------------------------------------------}
// Returns the previous non-hidden item, or -1 if not not found
function TCustomRVFormattedData.GetPrevNonHiddenItemNo(ItemNo: Integer): Integer;
begin
  Result := ItemNo-1;
  while Result>=0 do begin
    if not IsHidden(Result) then
      exit;
    dec(Result);
  end;
end;
{------------------------------------------------------------------------------}
// Returns the next non-hidden item, or -1 if not not found
function TCustomRVFormattedData.GetNextNonHiddenItemNo(ItemNo: Integer): Integer;
begin
  Result := ItemNo+1;
  while Result<ItemCount do begin
    if not IsHidden(Result) then
      exit;
    inc(Result);
  end;
  Result := -1;
end;
{=========================== TRVFontInfoCache =================================}
constructor TRVFontInfoCache.Create(const AData: TCustomRVFormattedData;
  const ARVStyle: TRVStyle; const ACanvas, ADrawCanvas: TCanvas;
  ACanUseCustomPPI: Boolean);
var i: Integer;
begin
  FRVStyle := ARVStyle;
  FCanvas := ACanvas;
  FDrawCanvas := ADrawCanvas;
  FCanUseCustomPPI := ACanUseCustomPPI;
  FOwner := AData;
  LastTextStyle := -1;
  Capacity := ARVStyle.TextStyles.Count;
  for i := 0 to ARVStyle.TextStyles.Count-1 do
    Add(nil);
end;
{------------------------------------------------------------------------------}
procedure TRVFontInfoCache.Clear;
begin
  inherited Clear;
  FInvalidItem.Free;
  FInvalidItem := nil;
end;

end.







