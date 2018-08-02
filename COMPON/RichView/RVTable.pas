{*******************************************************}
{                                                       }
{       RichView                                        }
{       TRVTableItemInfo: RichView item type            }
{       representing tables. Related types.             }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}


unit RVTable;
interface

{$I RV_Defs.inc}

uses  {$IFDEF RICHVIEWDEF2009}AnsiStrings,{$ENDIF}
     Windows, SysUtils, Classes, Graphics, Controls, Forms,
     RVClasses, RVItem, RVDataList, CRVData, CRVFData, RVStyle, RVFuncs,
     RVRVData, RVERVData,
     DLines, RVBack,
     {$IFNDEF RVDONOTUSELISTS}
     RVMarker,
     {$ENDIF}
     {$IFNDEF RVDONOTUSESEQ}
     RVSeqItem, RVNote,
     {$ENDIF}
     RVScroll,RichView, RVEdit, RVFMisc, PtblRV, PtRVData, TypInfo, RVUni, RVUndo,
     RVStr, RVGrIn, RVTypes;

{.$DEFINE RVDEBUGTABLE}

{$IFNDEF RICHVIEWCBDEF3}
{$O-}
{$ENDIF}


const
  rvsTable = -60;

  {$R RVTable.res}
  crRVSelectRow = 104;
  crRVSelectCol = 105;

type
  TRVCellHAlign   = (rvcLeft, rvcCenter, rvcRight);
  TRVCellVAlign   = (rvcTop,  rvcMiddle, rvcBottom, rvcVDefault);

  TRVTableOption = (rvtoEditing, rvtoRowSizing, rvtoColSizing,
                    rvtoRowSelect, rvtoColSelect, rvtoNoCellSelect,
                    rvtoRTFSaveCellPixelBestWidth,
                    rvtoRTFAllowAutofit,
                    rvtoHideGridLines, rvtoOverlappingCorners, rvtoCellBelowBorders,
                    rvtoIgnoreContentWidth, rvtoIgnoreContentHeight);
  TRVTableOptions = set of TRVTableOption;

  TRVTablePrintOption = (rvtoHalftoneBorders, rvtoRowsSplit, {rvtoNoCellsSplit, }
    rvtoWhiteBackground);
  TRVTablePrintOptions = set of TRVTablePrintOption;

const
  RVTABLEDEFAULTOPTIONS = [rvtoEditing, rvtoRowSizing, rvtoColSizing,
                           rvtoRowSelect, rvtoColSelect];
  RVTABLEDEFAULTPRINTOPTIONS = [rvtoHalftoneBorders,rvtoRowsSplit];
type

  TRVTableBorderStyle = (rvtbRaised, rvtbLowered, rvtbColor, rvtbRaisedColor, rvtbLoweredColor);


  TRVHTMLLength = type Integer; // > 0 - pixels
                                // = 0 - undefined
                                // < 0 - percents

  TRVTableRow = class;
  TRVTableRows = class;
  TRVTableItemInfo = class;

  TRVCellEditingEvent = procedure (Sender: TRVTableItemInfo;
    Row, Col : Integer; Automatic: Boolean; var AllowEdit: Boolean) of object;
  TRVCellEndEditEvent = procedure (Sender: TRVTableItemInfo; Row, Col: Integer;
    Clearing: Boolean) of object;

  TRVTablePrintPart = class;
  TCellPtblRVData = class;

  TRVTableCellData = class (TRVItemFormattedData)
    private
      FColor: TColor;
      FVAlign: TRVCellVAlign;
      FBestWidth: TRVHTMLLength;
      FBestHeight: TRVStyleLength;
      FRowSpan: Integer;
      FColSpan: Integer;
      FLeft, FTop, FWidth, FHeight: Integer;
      FVisibleBorders: TRVBooleanRect;
      //FReservedRVData: TCustomRVData;
      FChosenRVData: TCustomRVFormattedData;
      FChosenItem: TCustomRVItemInfo;
      ContainerUndoItem: TRVUndoInfo;
      FBorderColor: TColor;
      FBorderLightColor: TColor;
      FBackground: TRVBackground;
      FBackgroundImageFileName: String;
      {$IFNDEF RVDONOTUSEITEMHINTS}
      FHint: String;
      {$ENDIF}
      procedure SetBestHeight(const Value: TRVStyleLength);
      procedure SetBestWidth(const Value: TRVHTMLLength);
      procedure SetVisibleBorders(const Value: TRVBooleanRect);
      function CanClear: Boolean;
      procedure SetColor(const Value: TColor);
      function GetBackgroundImage: TGraphic;
      function GetBackgroundStyle: TRVItemBackgroundStyle;
      procedure SetBackgroundImage_(const Value: TGraphic; Copy: Boolean);
      procedure SetBackgroundImage(const Value: TGraphic);
      procedure SetBackgroundStyle(const Value: TRVItemBackgroundStyle);
      procedure BackgroundImageWriter(Stream: TStream);
      procedure BackgroundImageReader(Stream: TStream);
      function StoreVisibleBorders: Boolean;
    protected
      procedure DefineProperties(Filer: TFiler); override;
      procedure AssignSizeFrom(Cell:TRVTableCellData);
      function GetRealVAlign: TRVCellVAlign;
      function SupportsPageBreaks: Boolean; override;
      function GetOptions: TRVOptions; override;
      procedure DataWriter(Stream: TStream); override;      
    public
      { methods for internal processing }
      procedure GetItemBackground(ItemNo: Integer; r: TRect;
        MakeImageRect: Boolean; var Color: TColor; var bmp: TBitmap;
        var UseBitmap: Boolean; GraphicInterface: TRVGraphicInterface); override;
      procedure ResetSubCoords; override;
      function GetBackground: TRVBackground; override;
      function GetExtraVOffs: Integer;
      function IsTransparent: Boolean;
      procedure GetParentInfo(var ParentItemNo: Integer;
        var Location: TRVStoreSubRVData); override;
      function GetTable: TRVTableItemInfo;
      function GetItemHint(RVData: TCustomRVData; ItemNo: Integer;
        const UpperRVDataHint: String): String; override;
      procedure AssignAttributesFrom(Cell:TRVTableCellData;
        IncludeSize: Boolean; DivColSpan, DivRowSpan: Integer);
      procedure Deselect(NewPartiallySelected: TCustomRVItemInfo;
        MakeEvent: Boolean); override;
      function GetEditor: TWinControl; override;
      procedure GetOrigin(var ALeft, ATop: Integer); override;
      procedure GetOriginEx(var ALeft, ATop: Integer); override;
      function GetWidth: Integer; override;
      function GetHeight: Integer; override;
      function GetColor: TColor; override;
      function GetHOffs: Integer; override;
      function GetVOffs: Integer; override;
      function GetAreaWidth: Integer; override;
      procedure AssignChosenRVData(RVData: TCustomRVFormattedData;
        Item: TCustomRVItemInfo); override;
      procedure UnassignChosenRVData(RVData: TCustomRVData); override;
      function GetChosenRVData: TCustomRVData; override;
      function GetChosenItem: TCustomRVItemInfo; override;
      procedure MovingToUndoList(AContainerUndoItem: TRVUndoInfo);
      procedure MovingFromUndoList;
      function GetCellHeight(IgnoreContentHeight: Boolean): Integer;
//      function GetWidthInFixedTable(TableWidth: Integer): Integer;
      function GetMinWidth(sad: PRVScreenAndDevice; Canvas: TCanvas): Integer;
      function HasData(CheckStyles: Boolean): Boolean;
      function GetRVData: TCustomRVData; override;
      procedure DoSelect; override;
      procedure ControlAction(RVData: TCustomRVData; ControlAction: TRVControlAction;
      ItemNo: Integer; Item: TCustomRVItemInfo); override;
      procedure ControlAction2(RVData: TCustomRVData; ControlAction: TRVControlAction;
        ItemNo: Integer; var Control: TControl); override;
      procedure ItemAction(ItemAction: TRVItemAction; Item: TCustomRVItemInfo;
        var Text: TRVRawByteString; RVData: TCustomRVData); override;
      procedure AdjustFocus(NewFocusedItemNo: Integer;
        TopLevelRVData: TPersistent; TopLevelItemNo: Integer); override;
      { public methods and properties }
      constructor Create(ARow: TRVTableRow);
      destructor Destroy; override;
      {$IFNDEF RVDONOTUSELISTS}
      function GetMarkers(AllowCreate: Boolean): TRVMarkerList; override;
      {$ENDIF}
      {$IFNDEF RVDONOTUSESEQ}
      function GetSeqList(AllowCreate: Boolean): TRVSeqList; override;
      {$ENDIF}

      function Edit: TCustomRVData; override;
      procedure ConvertToDifferentUnits(NewUnits: TRVStyleUnits;
        RVStyle: TRVStyle; ConvertItems: Boolean); override;

      property Left:Integer read FLeft;
      property Top:Integer  read FTop;
      property Height:Integer read FHeight;
      property Width:Integer read FWidth;

      property ColSpan: Integer read FColSpan;
      property RowSpan: Integer read FRowSpan;

    published
      { published properties }
      property Color: TColor                  read FColor          write SetColor      default clNone;
      property BorderColor: TColor            read FBorderColor    write FBorderColor  default clNone;
      property BorderLightColor: TColor       read FBorderLightColor write FBorderLightColor default clNone;
      property BestWidth: TRVHTMLLength       read FBestWidth      write SetBestWidth  default 0;
      property BestHeight: TRVStyleLength     read FBestHeight     write SetBestHeight default 0;
      property VisibleBorders: TRVBooleanRect read FVisibleBorders write SetVisibleBorders stored StoreVisibleBorders;
      property VAlign: TRVCellVAlign          read FVAlign         write FVAlign       default rvcVDefault;
      property BackgroundImage: TGraphic read GetBackgroundImage write SetBackgroundImage stored False;
      property BackgroundStyle: TRVItemBackgroundStyle read GetBackgroundStyle write SetBackgroundStyle default rvbsColor;
      property BackgroundImageFileName: String read FBackgroundImageFileName
        write FBackgroundImageFileName;
      {$IFNDEF RVDONOTUSEITEMHINTS}
      property Hint: String read FHint write FHint;
      {$ENDIF}
  end;

  TRVTableRow = class (TRVDataList)
    private
      FVAlign: TRVCellVAlign;
      FPageBreakBefore: Boolean;
      function Get(Index: Integer): TRVTableCellData;
      procedure Put(Index: Integer; const Value: TRVTableCellData);
      procedure InsertEmpty(Index: Integer);
      procedure InsertPointer(Index: Integer; Item: TRVTableCellData);
    protected
      FRows: TRVTableRows;
      function GetParentRVData: TCustomRVData; override;
      function HasCellsInRange(Index, RangeStart, Count: Integer): Boolean;
    public
      constructor Create(nCols: Integer; ARows: TRVTableRows; MainRVData: TCustomRVData);
      function Add: TRVTableCellData;
      function Insert(Index: Integer): TRVTableCellData;
      function GetHeight(IgnoreContentHeight: Boolean): Integer;
      function GetBestHeight: TRVStyleLength;
      property VAlign: TRVCellVAlign read FVAlign write FVAlign default rvcTop;
      property PageBreakBefore: Boolean read FPageBreakBefore write FPageBreakBefore default False;
      property Items[Index: Integer]: TRVTableCellData read Get write Put; default;
  end;

  TRVTableRows = class (TRVList)
    private
      function Get(Index: Integer): TRVTableRow;
      procedure Put(Index: Integer; const Value: TRVTableRow);
      function GetMinColWidth(Col: Integer; sad: PRVScreenAndDevice;
                              Canvas: TCanvas): Integer;
      function GetPercentColWidth(Col, TableWidth: Integer): Integer;
      function IsPercentWidthColumn(Col: Integer): Boolean;
      function GetRVSLengthColWidth(Col: Integer): TRVStyleLength;
      function StartMergeCells(TopRow, LeftCol:Integer;
                               var ColSpan, RowSpan: Integer): Boolean;
    protected
      FMainRVData: TCustomRVData;
      FTable     : TRVTableItemInfo;
      function GetColCount: Integer;
      function IsEmptyRows(TopRow, LeftCol, ColSpan, RowSpan,
        TopRow2, RowSpan2: Integer): Boolean;
      function IsEmptyCols(TopRow, LeftCol, ColSpan,
        RowSpan, LeftCol2, ColSpan2: Integer): Boolean;
      function GetBestWidth(TopRow, LeftCol, ColSpan, RowSpan: Integer): Integer;
      procedure UnmergeCell(Row,Col: Integer; UnmergeRows, UnmergeCols: Boolean);
      procedure UnmergeCells(TopRow, LeftCol, ColSpan, RowSpan: Integer;
        UnmergeRows, UnmergeCols: Boolean);
      procedure InsertRows(Index, Count, CopyIndex: Integer; DivideHeights: Boolean);
      procedure InsertCols(Index, Count, CopyIndex: Integer; DivideWidths: Boolean);
      procedure DeleteRows(Index, Count: Integer; DecreaseHeight: Boolean);
      procedure DeleteCols(Index, Count: Integer; DecreaseWidth: Boolean);
      function SplitCellVertically(Row, Col, ColCount: Integer): Integer;
      function SplitCellsVertically(TopRow, LeftCol, ColSpan, RowSpan,
        ColCount: Integer):Integer;
      function SplitCellHorizontally(Row, Col, RowCount: Integer): Integer;
      function SplitCellsHorizontally(TopRow, LeftCol, ColSpan, RowSpan,
        RowCount: Integer):Integer;
      procedure MovingToUndoList(Row, Col, ColSpan, RowSpan: Integer;
        AContainerUndoItem: TRVUndoInfo);
      procedure MovingFromUndoList(Row, Col, ColSpan, RowSpan: Integer);
      procedure Do_BeforeInsertRows(ItemNo,Row,Count: Integer);
      procedure Do_InsertRows(Row,Count: Integer);
      procedure Do_UnInsertRows(Row,Count: Integer);
      procedure Do_BeforeInsertCell(ItemNo,Row,Col: Integer);
      procedure Do_BeforeSpreadOverEmptyCells(ItemNo, Row, Col, ColSpan: Integer);
      procedure Do_SpreadOverEmptyCells(Row, Col, ColSpan: Integer);
      procedure Do_UnSpreadOverEmptyCells(Row, Col, ColSpan: Integer);
      procedure Do_SetSpan(ItemNo,Row, Col, Span: Integer; IsColSpan: Boolean);
      procedure Do_BeforeFreeEmptyCells(ItemNo,Row, Col, ColSpan, RowSpan: Integer);
      procedure Do_FreeEmptyCells(Row, Col, ColSpan, RowSpan: Integer);
      procedure Do_UnFreeEmptyCells(Row, Col, ColSpan, RowSpan: Integer);
      procedure Do_ChangeEmptyCellStyles(ItemNo, Row, Col, StyleNo, ParaNo: Integer);
      procedure Do_BeforeInsertEmptyCells(ItemNo,Row, Col, ColCount, RowCount: Integer);
      procedure Do_InsertEmptyCells(Row, Col, ColCount, RowCount: Integer);
      procedure Do_UnInsertEmptyCells(Row, Col, ColCount, RowCount: Integer);
      procedure Do_BeforeSplitCellHorz(ItemNo,Row,Col,Row2: Integer; DecreaseHeight: Boolean);
      procedure Do_SplitCellHorz(Row,Col,Row2: Integer; DecreaseHeight: Boolean);
      procedure Do_UnSplitCellHorz(Row,Col,Row2: Integer; OldBestHeight: Integer);
      procedure Do_BeforeSplitCellVert(ItemNo,Row,Col,Col2: Integer; DecreaseWidth: Boolean);
      procedure Do_SplitCellVert(Row,Col,Col2: Integer; DecreaseWidth: Boolean);
      procedure Do_UnSplitCellVert(Row,Col,Col2: Integer; OldBestWidth: Integer);
      function Do_BeforeDeleteRows(ItemNo,Row,Count: Integer): TRVUndoInfo;
      procedure Do_DeleteRows(ItemNo,Row,Count: Integer; ui: TRVUndoInfo);
      procedure Do_UnDeleteRows(Row: Integer; RowList: TList);
      function Do_BeforeDeleteCols(ItemNo,Col,Count: Integer): TRVUndoInfo;
      procedure Do_DeleteCols(ItemNo,Col,Count: Integer;ui: TRVUndoInfo);
      procedure Do_UnDeleteCols(Col: Integer; CellList: TList);
      function Do_BeforeMergeCells(ItemNo, Row,Col, ColSpan, RowSpan: Integer): TRVUndoInfo;
      procedure Do_MergeCells(ItemNo, Row,Col, ColSpan, RowSpan: Integer;
        ui: TRVUndoInfo; ChangeBestWidth: Boolean);
      procedure Do_UndoMergeCells(ItemNo, Row,Col, OldColSpan, OldRowSpan: Integer;
        MergedItemsList: TRVList; OldBestWidth: TRVHTMLLength);
      procedure Do_BeforeUnmergeCell(ItemNo, Row,Col: Integer; UnmergeRows, UnmergeCols: Boolean);
      procedure Do_UnmergeCell(ItemNo, Row,Col: Integer; UnmergeRows, UnmergeCols: Boolean);
      procedure Do_UndoUnmergeCell(ItemNo, Row,Col: Integer;
        OldColSpan, OldRowSpan: Integer; OldBestWidth: TRVHTMLLength;
        OldBestHeight: Integer);
      function Do_BeforeClearCells(ItemNo: Integer; RowList, ColList: TRVIntegerList;
        var CellsList: TList): TRVUndoInfo;
        procedure Do_AfterFillingCells(CellsList: TList; RowList, ColList: TRVIntegerList;
        ui: TRVUndoInfo);
      procedure Do_ClearCells(CellsList: TList; RowList, ColList: TRVIntegerList;
        ui: TRVUndoInfo);
      procedure Do_UnClearCells(CellsList: TList; RowList, ColList: TRVIntegerList);
      procedure InsertPointer(Index: Integer; Item: TRVTableRow);
    public
      constructor Create(nRows, nCols: Integer; AMainRVData: TCustomRVData;
                         ATable: TRVTableItemInfo);
      destructor Destroy; override;
      procedure MergeCells(TopRow, LeftCol, ColSpan, RowSpan: Integer;
                           AllowMergeRC, ChangeBestWidth: Boolean);
      function Empty: Boolean;
      function Add(nCols: Integer): TRVTableRow;
      function GetMainCell(ARow,ACol: Integer; var MRow, MCol: Integer): TRVTableCellData;
      function Insert(Index, nCols: Integer): TRVTableRow;
      procedure Reset(nRows, nCols: Integer);
      function CanMergeCells(TopRow, LeftCol, ColSpan, RowSpan: Integer;
                             AllowMergeRC: Boolean): Boolean;
      property Items[Index: Integer]: TRVTableRow read Get write Put; default;
  end;

  TRVTableInplaceParamStorage = record
    Stored: Boolean;
    StartNo, EndNo, StartOffs, EndOffs: Integer;
    Row, Col: Integer;
    PartialSelected: TCustomRVItemInfo;
  end;

  TRVTableItemFormattingInfo = class
    private
      ColWidths, RowHeights, ColStarts,RowStarts: TRVIntegerList;
      FWidth, FHeight: Integer;
    public
      Rows : TRVList;    
      constructor Create(CreateRows:Boolean);
      destructor Destroy; override;
      procedure Clear;
      procedure QuickClear;
  end;

  TRVCellDirection = (rvcdLeft, rvcdUp, rvcdRight, rvcdDown,
                      rvcdDocTop, rvcdDocBottom,
                      rvcdNext, rvcdPrev);

  TRVTableDrawBorderEvent = procedure (Sender: TRVTableItemInfo;
    Canvas: TCanvas; Left,Top,Right,Bottom: Integer;
    Width: TRVStyleLength;
    LightColor, Color, BackgroundColor: TColor;
    Style: TRVTableBorderStyle; Printing: Boolean;
    VisibleBorders: TRVBooleanRect; Row, Col: Integer;
    var DoDefault: Boolean) of object;

  TRVTableState = (rvtsInserted, rvtsEditMode, rvtsModified, rvtsFormatInplace,
     rvtsVerticalDraggedRule, rvtsDRChangeTableWidth,
     rvtsJustCreated, rvtsInplaceIsReformatting, rvtsSelExists);
  TRVTableStates = set of TRVTableState;

  TRVTableStreamSaveInfo = class
    public
      Part: TRVTablePrintPart;
      CellPage: Integer;
      CellPtblRVData: TCellPtblRVData;
      TopRow, LeftCol, RowCount, ColCount: Integer;
      SaveHeadingRows, SelectionOnly: Boolean;
      LoadResult: Boolean;
      constructor Create(table: TRVTableItemInfo);
  end;


  TRVTableItemInfo = class (TRVFullLineItemInfo)
    private
      FPrintCell: TRVTableCellData;
      FPrintCellRect: TRect;
      FOnCellEditing: TRVCellEditingEvent;
      FOnCellEndEdit: TRVCellEndEditEvent;
      FState: TRVTableStates;
      CachedItemNo: Integer;
      MyTop, MyLeft: Integer;
      MyClientTop, MyClientLeft: Integer;
      MouseRow, MouseCol: Integer;
      DRMin, DRMax, DRNo, DRCoord, DRDelta: Integer;
      FRows: TRVTableRows;
      FCellVSpacing, FCellHSpacing: TRVStyleLength;
      FCellHPadding, FCellVPadding: TRVStyleLength;
      FBestWidth: TRVHTMLLength;
      FBorderWidth: TRVStyleLength;
      FBorderColor: TColor;
      FColor: TColor;
      FCellBorderWidth: TRVStyleLength;
      FHRuleWidth: TRVStyleLength;
      FVRuleWidth: TRVStyleLength;
      FHRuleColor: TColor;
      FCellBorderColor: TColor;
      FVRuleColor: TColor;
      FBorderStyle: TRVTableBorderStyle;
      FCellBorderStyle: TRVTableBorderStyle;
      FBorderHSpacing: TRVStyleLength;
      FBorderVSpacing: TRVStyleLength;
      FHOutermostRule: Boolean;
      FVOutermostRule: Boolean;
      FCellBorderLightColor: TColor;
      FBorderLightColor: TColor;
      FSelStartCol, FSelStartRow, FSelColOffs, FSelRowOffs: Integer;
      BusyCount: Integer;
      FOptions: TRVTableOptions;
      FPrintOptions: TRVTablePrintOptions;
      FStoredInplace: TRVTableInplaceParamStorage;
      FMinWidthPlus, FInplaceMinWidthPlus: Integer;
      FTextRowSeparator: String;
      FTextColSeparator: String;
      FocusedCellRow,FocusedCellCol: Integer;
      ChosenCellRow,ChosenCellCol: Integer;
      FOnDrawBorder: TRVTableDrawBorderEvent;
      FHeadingRowCount: Integer;
      FBackground: TRVBackground;
      FBackgroundImageFileName: String;
      FVisibleBorders: TRVBooleanRect;
      FStreamSaveInfo: TRVTableStreamSaveInfo;
      function StoreCellPadding: Boolean;
      function StoreCellHPadding: Boolean;
      function StoreCellVPadding: Boolean;      
      function GetItemNoInRootDocument: Integer;
      function GetCells(Row, Col: Integer): TRVTableCellData;
      procedure SetCells(Row, Col: Integer; const Value: TRVTableCellData);
      procedure SetBestWidth(const Value: TRVHTMLLength);
      function GetColNo(X: Integer): Integer;
      function GetRowNo(Y: Integer): Integer;
      function GetCrossed(Coord: Integer;List: TRVIntegerList): Integer;
      procedure UpdateCellXCoords(Fmt: TRVTableItemFormattingInfo; NoCaching, Reformatting: Boolean);
      procedure UpdateCellYCoords(Fmt: TRVTableItemFormattingInfo);
      function GetHorzExtraPix: Integer;
      //function GetHorzExtra: TRVStyleLength;
      procedure InplaceEditorChange(Sender: TCustomRichViewEdit; ClearRedo: Boolean);
      procedure InplaceEditorCaretGetout(Sender: TCustomRichViewEdit; Direction: TRVGetOutDirection);
      procedure InplaceEditorMouseDown(Sender: TCustomRichView; Button: TMouseButton; Shift: TShiftState; ItemNo, X, Y: Integer);
      procedure InplaceEditorMouseUp(Sender: TCustomRichView; Button: TMouseButton; Shift: TShiftState; ItemNo, X, Y: Integer);
      procedure InplaceEditorMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
      procedure InplaceEditorDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
      procedure InplaceEditorDragDrop(Sender, Source: TObject; X, Y: Integer);
      procedure DestroyInplace(ReformatCell:Boolean);
      procedure StoreRVSelection(RVData: TCustomRVFormattedData;
                             var storage: TRVTableInplaceParamStorage);
      procedure RestoreRVSelection(RVData: TCustomRVFormattedData;
                             const storage: TRVTableInplaceParamStorage);
      procedure Init(nRows, nCols: Integer; AMainRVData: TCustomRVData);
      procedure CellsWriter(Writer: TWriter);
      procedure CellsReader(Reader: TReader);
      procedure ClearTemporal;
      procedure SetBorderColor(const Value: TColor);
      procedure SetBorderHSpacing(const Value: TRVStyleLength);
      procedure SetBorderLightColor(const Value: TColor);
      procedure SetBorderStyle(const Value: TRVTableBorderStyle);
      procedure SetBorderVSpacing(const Value: TRVStyleLength);
      procedure SetBorderWidth(const Value: TRVStyleLength);
      procedure SetCellBorderColorProp(const Value: TColor);
      procedure SetCellBorderLightColorProp(const Value: TColor);
      procedure SetCellBorderWidth(const Value: TRVStyleLength);
      procedure SetCellHSpacing(const Value: TRVStyleLength);
      procedure SetCellHPadding(const Value: TRVStyleLength);
      procedure SetCellVPadding(const Value: TRVStyleLength);
      procedure SetCellPadding(const Value: TRVStyleLength);
      procedure SetCellVSpacing(const Value: TRVStyleLength);
      procedure SetColor(const Value: TColor);
      procedure SetHOutermostRule(const Value: Boolean);
      procedure SetHRuleColor(const Value: TColor);
      procedure SetHRuleWidth(const Value: TRVStyleLength);
      procedure SetVOutermostRule(const Value: Boolean);
      procedure SetVRuleColor(const Value: TColor);
      procedure SetVRuleWidth(const Value: TRVStyleLength);
      procedure SetCellBorderStyle(const Value: TRVTableBorderStyle);
      procedure SetIntProperty(const PropertyName: String; Value: LongInt;
        AffectSize, AffectWidth: Boolean);
      procedure SetCellIntProperty(ItemNo: Integer; const PropertyName: String;
        Value: LongInt; Row,Col: Integer; AffectSize, AffectWidth: Boolean);
      procedure SetCellStrProperty(ItemNo: Integer; const PropertyName: String;
        const Value: String; Row,Col: Integer);
      function IsFixedWidthTable: Boolean;
      function CompletelySelected: Boolean;
      procedure UnAssignActiveCell;
      function DoOnCellEditing(Row,Col: Integer; Automatic: Boolean): Boolean;
      function IsInEditor: Boolean;
      procedure SetHeadingRowCount(const Value: Integer);
      function GetBackgroundImage: TGraphic;
      procedure SetBackgroundImage_(const Value: TGraphic; Copy: Boolean);
      procedure SetBackgroundImage(const Value: TGraphic);
      function GetBackgroundStyle: TRVItemBackgroundStyle;
      procedure SetBackgroundStyle(const Value: TRVItemBackgroundStyle);
      procedure BackgroundImageWriter(Stream: TStream);
      procedure BackgroundImageReader(Stream: TStream);
      procedure ResetLiveSpell;
      procedure SetVisibleBorders(const Value: TRVBooleanRect);
      function StoreVisibleBorders: Boolean;
      procedure DoSaveRVF(Stream: TStream; RVData: TPersistent;
        ItemNo, ParaNo: Integer; Part: TRVMultiDrawItemPart;
        ForceSameAsPrev, SelectionOnly: Boolean);
      function GetColCount: Integer;
      function GetRowCount: Integer;
      function GetCellPadding: TRVStyleLength;
      procedure ExpandColsForMinWidthConstrained(Row, Col, Width: Integer;
        ColWidths: TRVIntegerList; var PixColWidths: TRVIntegerList;
        var MinColsWidth: Integer);
    protected
      Fmt: TRVTableItemFormattingInfo;
      cursad: PRVScreenAndDevice;
      procedure XorDrawing(Sender: TObject; Shift: TShiftState; X, Y: Integer);
      procedure DefineProperties(Filer: TFiler); override;

      procedure DrawBorder(Canvas: TCanvas;
        Left,Top,Right,Bottom: Integer; Width: TRVStyleLength;
        LightColor, Color, BackgroundColor: TColor;
        Style: TRVTableBorderStyle; DrawEvenEmptyBorder, Editing, Printing: Boolean;
        const ClipRect: TRect; VisibleBorders: TRVBooleanRect;
        r,c: Integer; ColorMode: TRVColorMode; GraphicInterface: TRVGraphicInterface);
      function GetCellAt_(X,Y: Integer; var Row,Col: Integer; IgnoreBorders: Boolean): Boolean;
      procedure UpdateCellSel;
      procedure PaintTo(Left, Right, Top: Integer; Canvas: TCanvas;
        State: TRVItemDrawStates; Style: TRVStyle; Fmt: TRVTableItemFormattingInfo;
        UseHeadingRowCount: Boolean; const ClipRect: TRect; ColorMode: TRVColorMode;
        RVData: TCustomPrintableRVData; Part: TRVTablePrintPart;
        ExtraX, ExtraY: Integer);
      function GetDevX(x: Integer): Integer;
      function GetDevY(y: Integer): Integer;
      procedure InternalOnDocWidthChange(DocWidth: Integer;
        Fmt: TRVTableItemFormattingInfo; Canvas: TCanvas;
        NoCaching, Reformatting, UseFormatCanvas: Boolean;
        GraphicInterface: TRVGraphicInterface);
      procedure Change;
      procedure ChangeEx(ClearRedo: Boolean);
      function BeginModify(ItemNo: Integer): Integer;
      procedure EndModify(ItemNo, Data: Integer);
      function GetTableColor(UseParentBackground: Boolean): TColor;
      function GetCellColor(Cell: TRVTableCellData): TColor;
      function GetCellColor2(Cell: TRVTableCellData): TColor;
      function CanSeeBackgroundThroughCell(Cell: TRVTableCellData): Boolean;
      function CanSplitAtRow(Row: Integer): Boolean;
      function GetSplitRowBelow(Row: Integer): Integer;
      function GetSplitRowAbove(Row: Integer): Integer;
      function BeforeChange: Boolean;
      function CanChange: Boolean;
      function CanChangeEx: Boolean;
      procedure InitUndo;
      procedure DoneUndo;
      procedure AssignCellAttributes(ItemNo,Row,Col: Integer; SourceCell: TRVTableCellData;
                                     IncludeSize: Boolean;
                                     DivColSpan, DivRowSpan: Integer);
      procedure SetCellBestWidth_(ItemNo: Integer; Value: TRVHTMLLength; Row,Col: Integer);
      procedure SetCellBestHeight_(ItemNo: Integer; Value: TRVStyleLength;
        Row,Col: Integer);
      procedure SetCellColor_(ItemNo: Integer; Value: TColor; Row,Col: Integer);
      procedure SetCellBackgroundStyle_(ItemNo: Integer;
        Value: TRVItemBackgroundStyle; Row,Col: Integer);
      procedure SetCellBackgroundImageFileName_(ItemNo: Integer; const Value: String;
        Row,Col: Integer);
      {$IFNDEF RVDONOTUSEITEMHINTS}
      procedure SetCellHint_(ItemNo: Integer; const Value: String; Row,Col: Integer);
      {$ENDIF}
      procedure SetCellVisibleBorders_(ItemNo: Integer;
        Left, Top, Right, Bottom: Boolean; Row,Col: Integer);
      procedure SetCellBorderColor_(ItemNo: Integer; Value: TColor; Row,Col: Integer);
      procedure SetCellBorderLightColor_(ItemNo: Integer; Value: TColor; Row,Col: Integer);
      procedure SetCellVAlign_(ItemNo: Integer; Value: TRVCellVAlign; Row,Col: Integer);
      procedure SetRowVAlign_(ItemNo: Integer; Value: TRVCellVAlign; Row: Integer);
      function GetEditorItemNoForUndo: Integer;
      function CreateTemporalEditor: TCustomRichViewEdit;
      procedure ApplyToCells(ConvType: TRVEStyleConversionType; UserData: Integer;
        SelectedOnly: Boolean);
      procedure ValidateFocused;
      procedure ValidateChosen;
      function CellIsChosen: Boolean;
      procedure AdjustFocus(Row,Col: Integer; TopLevelRVData: TPersistent; TopLevelItemNo: Integer);
      function UndoEnabled: Boolean;
      procedure ChooseSubRVData_(r,c: Integer);
      procedure EditCell_(Row,Col: Integer; Unquestioning: Boolean);
      function GetRVFExtraPropertyCount: Integer; override;
      procedure SaveRVFExtraProperties(Stream: TStream); override;
      function RowsHavePageBreaksBefore(StartRow, EndRow: Integer): Boolean;
      function  GetNormalizedSelectionBoundsEx(IncludeEditedCell: Boolean;
        var TopRow, LeftCol, ColSpan, RowSpan: Integer): Boolean;
      function DoGetMinWidth(sad: PRVScreenAndDevice; Canvas: TCanvas; UseTableWidth: Boolean): Integer;
    public
      FMakingSelection: Boolean;
      FInplaceEditor: TCustomRichViewEdit;
      function GetHeight(RVStyle: TRVStyle): Integer; override;
      function GetWidth(RVStyle: TRVStyle): Integer; override;      
      function CanUseHeadingRowCount: Boolean;
      procedure DrawBackgroundUnderCell(Canvas: TCanvas; Cell: TRVTableCellData;
        const Rect: TRect; GraphicInterface: TRVGraphicInterface);
      function IsSemiTransparentBackground: Boolean;
      procedure ClearSoftPageBreaks; override;
      function GetSoftPageBreakDY(Data: Integer): Integer; override;
      function GetMyItemNo: Integer;
      procedure SaveRowsToStream(Stream: TStream; Index, Count: Integer);
      procedure SaveRectangleToStream(Stream: TStream;
        TopRow, LeftCol, RowCount, ColCount: Integer; SelectionOnly: Boolean);
      procedure ResetSubCoords; override;
      function GetSubRVDataAt(X,Y: Integer; ReturnClosest: Boolean): TPersistent; override;
      function GetCellWhichOwnsControl(AControl: TControl; var ARow,ACol, AItemNo: Integer): Boolean;
      function AdjustFocusToControl(Control: TControl; var TopLevelRVData: TPersistent; var TopLevelItemNo: Integer):Boolean;override;
      procedure Print(Canvas: TCanvas; x, y, x2: Integer; Preview, Correction: Boolean;
        const sad: TRVScreenAndDevice; RichView: TRVScroller; dli: TRVDrawLineInfo;
        Part: Integer; ColorMode: TRVColorMode; RVData: TPersistent); override;
      procedure CreateInplace(ItemNo, Row, Col: Integer; BuildJumps,
        CaretAtStart, CaretAtEnd, SetTime, Unquestioning: Boolean);
      procedure SetInplaceBounds(Left, Top, Width, Height: Integer);
      function StartSelecting(Row,Col: Integer; FromKeyboard: Boolean): Boolean;
      procedure MovingToUndoList(ItemNo: Integer; RVData, AContainerUndoItem: TObject); override;
      procedure MovingFromUndoList(ItemNo: Integer; RVData: TObject); override;
      procedure Hiding; override;
      procedure FinalizeUndoGroup; override;
      procedure AdjustInserted(x,y: Integer; adjusty: Boolean; RVStyle: TRVStyle); override;
      function OwnsControl(AControl: TControl): Boolean; override;
      function OwnsInplaceEditor(AEditor: TControl): Boolean; override;
      function GetMinWidth(sad: PRVScreenAndDevice; Canvas: TCanvas; RVData: TPersistent): Integer; override;
      procedure PaintFullWidth(Left, Right, Top: Integer; Canvas: TCanvas; State: TRVItemDrawStates;
        Style: TRVStyle; const ClipRect: TRect; dli: TRVDrawLineInfo;
        ExtraX, ExtraY: Integer); override;
      procedure OnDocWidthChange(DocWidth: Integer; dli: TRVDrawLineInfo;
        Printing: Boolean; Canvas: TCanvas; RVData: TPersistent; sad: PRVScreenAndDevice;
        var HShift, Desc: Integer; NoCaching, Reformatting, UseFormatCanvas: Boolean); override;
      procedure ResizeRow(Index, Height: Integer);
      procedure ResizeCol(Index, Width: Integer; Shift: Boolean);
      function MouseMove(Shift: TShiftState; X,Y,ItemNo: Integer; RVData: TObject):Boolean; override;
      function MouseDown(Button: TMouseButton; Shift: TShiftState; X,Y,ItemNo: Integer; RVData: TObject):Boolean; override;
      function MouseUp(Button: TMouseButton; Shift: TShiftState; X,Y,ItemNo: Integer; RVData: TObject):Boolean; override;
      procedure DeselectPartial; override;
      procedure MergeInplaceUndo(DestroyLists: Boolean);
      procedure InplaceDeleted(Clearing: Boolean);
      function PartiallySelected: Boolean; override;
      function CanDeletePartiallySelected: Boolean; override;
      procedure DoAfterFillingRows(Row, Count: Integer);
      procedure DeletePartiallySelected; override;
      function GetBoolValue(Prop: TRVItemBoolProperty): Boolean; override;
      function GetBoolValueEx(Prop: TRVItemBoolPropertyEx; RVStyle: TRVStyle): Boolean; override;
      procedure SaveRVF(Stream: TStream; RVData: TPersistent;
        ItemNo, ParaNo: Integer; const Name: TRVRawByteString; Part: TRVMultiDrawItemPart;
        ForceSameAsPrev: Boolean); override;
      procedure SaveRVFSelection(Stream: TStream; RVData: TPersistent;
        ItemNo, ParaNo: Integer); override;
      procedure SaveTextSelection(Stream: TStream; RVData: TPersistent;
        LineWidth: Integer;
        const Path: String; TextOnly,Unicode: Boolean); override;
      function ReadRVFLine(const s: TRVRawByteString; RVData: TPersistent;
        ReadType, LineNo, LineCount: Integer; var Name: TRVRawByteString;
        var ReadMode: TRVFReadMode; var ReadState: TRVFReadState;
        UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean; override;
      procedure BeforeLoading(FileFormat: TRVLoadFormat); override;
      procedure AfterLoading(FileFormat: TRVLoadFormat); override;
     function CreatePrintingDrawItem(RVData, ParaStyle: TObject;
        const sad: TRVScreenAndDevice): TRVDrawLineInfo; override;
      procedure DrawBackgroundForPrinting(Canvas: TCanvas;
        const Rect, FullRect: TRect; ColorMode: TRVColorMode;
        ItemBackgroundLayer: Integer; GraphicInterface: TRVGraphicInterface); override;
      procedure SaveInplace;
      procedure RestoreInplace;
      procedure UpdateStoredInplaceSelection;
      procedure StartExport; override;
      procedure EndExport; override;
      procedure MarkStylesInUse(Data: TRVDeleteUnusedStylesData); override;
      procedure UpdateStyles(Data: TRVDeleteUnusedStylesData); override;
      procedure Inserting(RVData: TObject; var Text: TRVRawByteString; Safe: Boolean); override;
      procedure Inserted(RVData: TObject; ItemNo: Integer); override;
      procedure BeforeUndoChangeProperty; override;
      procedure AfterUndoChangeProperty; override;
      procedure ApplyStyleConversionToSubRVDatas(UserData: Integer;
        SelectedOnly: Boolean; ConvType: TRVEStyleConversionType); override;
      function GetCellTo(Row,Col: Integer; Dir:TRVCellDirection;
        var NewRow,NewCol: Integer; Quiet, CanAddRow: Boolean): Boolean;
      {$IFNDEF RVDONOTUSERTF}
      procedure SaveRTF(Stream: TStream; const Path: String;
        RVData: TPersistent; ItemNo: Integer;
        TwipsPerPixel: Double; Level: Integer; ColorList: TRVColorList;
        StyleToFont, ListOverrideOffsetsList1, ListOverrideOffsetsList2: TRVIntegerList;
        FontTable: TRVList; HiddenParent: Boolean); override;
      procedure FillRTFTables(ColorList: TRVColorList; ListOverrideCountList: TRVIntegerList;
        RVData: TPersistent); override;
      {$ENDIF}
      function AsText(LineWidth: Integer; RVData: TPersistent;
        const Text: TRVRawByteString; const Path: String;
        TextOnly,Unicode: Boolean): TRVRawByteString; override;
      {$IFNDEF RVDONOTUSEHTML}
      procedure SaveToHTML(Stream: TStream; RVData: TPersistent;
        ItemNo: Integer; const Text: TRVRawByteString; const Path,
        imgSavePrefix: String; var imgSaveNo: Integer;
        CurrentFileColor: TColor; SaveOptions: TRVSaveOptions;
        UseCSS: Boolean; Bullets: TRVList); override;
      {$ENDIF}
      function EnterItem(From: TRVEnterDirection; Coord: Integer): Boolean; override;
      procedure BuildJumps(Left,Top: Integer; var StartJumpNo: Integer; jumps: TList); override;
      function GetSubRVData(var StoreState: TRVStoreSubRVData; Position: TRVSubRVDataPos): TPersistent; override;
      procedure ChooseSubRVData(StoreState: TRVStoreSubRVData); override;
      procedure CleanUpChosen; override;
      { Public }
      constructor Create(RVData: TPersistent); override;
      constructor CreateEx(nRows, nCols: Integer; AMainRVData: TCustomRVData);
      destructor Destroy; override;
      procedure UnmergeCells(TopRow, LeftCol, ColSpan, RowSpan: Integer; UnmergeRows, UnmergeCols: Boolean);
      function CanMergeCells(TopRow, LeftCol, ColSpan, RowSpan: Integer;
                             AllowMergeRC: Boolean): Boolean;
      procedure MergeCells(TopRow, LeftCol, ColSpan, RowSpan: Integer; AllowMergeRC: Boolean);
      procedure MergeSelectedCells(AllowMergeRC: Boolean);
      function CanMergeSelectedCells(AllowMergeRC: Boolean): Boolean;
      procedure UnmergeSelectedCells(UnmergeRows, UnmergeCols: Boolean);
      procedure SplitSelectedCellsVertically(ColCount: Integer);
      procedure SplitSelectedCellsHorizontally(RowCount: Integer);
      function  IsCellSelected(Row, Col: Integer): Boolean;
      procedure InsertRows(Index, Count, CopyIndex: Integer
                           {$IFDEF RICHVIEWDEF4};Select:Boolean=True{$ENDIF});
      procedure InsertCols(Index, Count, CopyIndex: Integer
                           {$IFDEF RICHVIEWDEF4};Select:Boolean=True{$ENDIF});
      procedure InsertColsLeft(Count: Integer);
      procedure InsertColsRight(Count: Integer);
      procedure InsertRowsAbove(Count: Integer);
      procedure InsertRowsBelow(Count: Integer);
      procedure DeleteRows(Index, Count: Integer; DecreaseHeight: Boolean);
      procedure DeleteCols(Index, Count: Integer; DecreaseWidth: Boolean);
      procedure DeleteSelectedRows;
      procedure DeleteSelectedCols;
      procedure DeleteEmptyRows;
      procedure DeleteEmptyCols;
      function  GetCellAt(X,Y: Integer; var Row,Col: Integer;
        IgnoreBorders: Boolean {$IFDEF RICHVIEWDEF4}=False{$ENDIF}): Boolean;
      function GetVerticalRuleNo(X: Integer; var MinX, ZeroChangeX: Integer): Integer;
      function GetHorizontalRuleNo(Y: Integer; var MinY, ZeroChangeY: Integer): Integer;      
      procedure Select(StartRow, StartCol, RowOffs, ColOffs: Integer);
      procedure Deselect;
      procedure SelectRows(StartRow, Count: Integer);
      procedure SelectCols(StartCol, Count: Integer);
      function  GetSelectionBounds(var StartRow, StartCol, RowOffs, ColOffs: Integer): Boolean;
      function  GetNormalizedSelectionBounds(IncludeEditedCell: Boolean;
        var TopRow, LeftCol, ColSpan, RowSpan: Integer): Boolean;
      function GetEditedCell(var Row,Col: Integer): TCustomRichViewEdit;
      procedure SaveToStream(Stream: TStream);
      procedure LoadFromStream(Stream: TStream);
      procedure LoadFromStreamEx(Stream: TStream; StartRow: Integer);
      procedure EditCell(Row,Col: Integer);
      procedure Changed;
      // Data
      property Rows: TRVTableRows read FRows;
      property Cells[Row, Col: Integer]: TRVTableCellData read GetCells write SetCells;

      procedure SetCellBestWidth(Value: TRVHTMLLength; Row,Col: Integer);
      procedure SetCellBestHeight(Value: TRVStyleLength; Row,Col: Integer);
      procedure SetCellColor(Value: TColor; Row,Col: Integer);
      procedure SetCellBackgroundStyle(Value: TRVItemBackgroundStyle; Row,Col: Integer);      
      procedure SetCellBackgroundImage(Value: TGraphic; Row,Col: Integer);
      procedure SetCellBackgroundImageFileName(const Value: String; Row,Col: Integer);
      {$IFNDEF RVDONOTUSEITEMHINTS}
      procedure SetCellHint(const Value: String; Row,Col: Integer);
      {$ENDIF}
      procedure SetCellVisibleBorders(Left, Top, Right, Bottom: Boolean; Row,Col: Integer);
      procedure SetTableVisibleBorders(Left, Top, Right, Bottom: Boolean);
      procedure SetCellBorderColor(Value: TColor; Row,Col: Integer);
      procedure SetCellBorderLightColor(Value: TColor; Row,Col: Integer);
      procedure SetCellVAlign(Value: TRVCellVAlign; Row,Col: Integer);
      procedure SetRowVAlign(Value: TRVCellVAlign; Row: Integer);
      function MoveFocus(GoForward: Boolean; var TopLevelRVData: TPersistent; var  TopLevelItemNo: Integer): Boolean; override;
      procedure ClearFocus; override;
      procedure GetCellPosition(Cell: TRVTableCellData; var Row, Col: Integer);
      procedure AssignProperties(Source: TRVTableItemInfo);
      function SetExtraStrProperty(Prop: TRVExtraItemStrProperty;
        const Value: String): Boolean; override;
      function GetExtraStrProperty(Prop: TRVExtraItemStrProperty;
        var Value: String): Boolean; override;
      procedure KeyDown(Key: Word; Shift: Boolean); override;
      property BackgroundImageFileName: String read FBackgroundImageFileName
        write FBackgroundImageFileName;
      property RowCount: Integer read GetRowCount;
      property ColCount: Integer read GetColCount;
      property State: TRVTableStates read FState write FState;
      procedure ConvertToDifferentUnits(NewUnits: TRVStyleUnits;
        RVStyle: TRVStyle; Recursive: Boolean); override;
      function GetRVStyle: TRVStyle;
    published
      { Published properties }
      // Table:
      property Options: TRVTableOptions read FOptions write FOptions default RVTABLEDEFAULTOPTIONS;
      property PrintOptions: TRVTablePrintOptions read FPrintOptions write FPrintOptions default RVTABLEDEFAULTPRINTOPTIONS;
      property BestWidth: TRVHTMLLength read FBestWidth write SetBestWidth default 0;
      property Color: TColor read FColor write SetColor default clWindow;
      property BackgroundImage: TGraphic read GetBackgroundImage write SetBackgroundImage stored False;
      property BackgroundStyle: TRVItemBackgroundStyle read GetBackgroundStyle write SetBackgroundStyle default rvbsColor;
      property HeadingRowCount: Integer read FHeadingRowCount write SetHeadingRowCount default 0;
      property TextRowSeparator: String read FTextRowSeparator write FTextRowSeparator;
      property TextColSeparator: String read FTextColSeparator write FTextColSeparator;
      // Border around the table:
      property BorderWidth: TRVStyleLength read FBorderWidth write SetBorderWidth default 0;
      property BorderColor: TColor read FBorderColor write SetBorderColor default clWindowText;
      property BorderLightColor: TColor read FBorderLightColor write SetBorderLightColor default clBtnHighlight;
      property BorderStyle: TRVTableBorderStyle read FBorderStyle write SetBorderStyle default rvtbRaised;
      property BorderVSpacing: TRVStyleLength read FBorderVSpacing write SetBorderVSpacing default 2;
      property BorderHSpacing: TRVStyleLength read FBorderHSpacing write SetBorderHSpacing default 2;
      property VisibleBorders: TRVBooleanRect read FVisibleBorders write SetVisibleBorders stored StoreVisibleBorders;
      // Cells:
      property CellBorderWidth: TRVStyleLength read FCellBorderWidth write SetCellBorderWidth default 0;
      property CellBorderColor: TColor read FCellBorderColor write SetCellBorderColorProp default clWindowText;
      property CellBorderLightColor: TColor read FCellBorderLightColor write SetCellBorderLightColorProp default clBtnHighlight;
      property CellHPadding: TRVStyleLength read FCellHPadding write SetCellHPadding stored StoreCellHPadding;
      property CellVPadding: TRVStyleLength read FCellVPadding write SetCellVPadding stored StoreCellVPadding;
      property CellPadding: TRVStyleLength read GetCellPadding write SetCellPadding stored StoreCellPadding default 1;
      property CellBorderStyle: TRVTableBorderStyle read FCellBorderStyle write SetCellBorderStyle default rvtbLowered;
      // Between cells:
      property VRuleWidth: TRVStyleLength read FVRuleWidth write SetVRuleWidth default 0;
      property VRuleColor: TColor read FVRuleColor write SetVRuleColor default clWindowText;
      property HRuleWidth: TRVStyleLength read FHRuleWidth write SetHRuleWidth default 0;
      property HRuleColor: TColor  read FHRuleColor write SetHRuleColor default clWindowText;
      property CellVSpacing: TRVStyleLength read FCellVSpacing write SetCellVSpacing default 2;
      property CellHSpacing: TRVStyleLength read FCellHSpacing write SetCellHSpacing default 2;
      property VOutermostRule: Boolean read FVOutermostRule write SetVOutermostRule default False;
      property HOutermostRule: Boolean read FHOutermostRule write SetHOutermostRule default False;
      // Events
      property OnCellEditing: TRVCellEditingEvent read FOnCellEditing write FOnCellEditing;
      property OnCellEndEdit: TRVCellEndEditEvent read FOnCellEndEdit write FOnCellEndEdit;
      property OnDrawBorder: TRVTableDrawBorderEvent read FOnDrawBorder write FOnDrawBorder;

  end;

  TRVTableStoreSubRVData = class (TRVStoreSubRVData)
    public
      Row, Col: Integer;
      constructor Create(ARow, ACol: Integer);
      function Duplicate: TRVStoreSubRVData; override;
      function Compare(StoreSub: TRVStoreSubRVData): Integer; override;
  end;

  TRVTablePrintPart = class (TRVMultiDrawItemPart)
    public
      FTableTopCutLine, FTableBottomCutLine,
      FRowStarts, FRowIndices: TRVIntegerList;
      FRowFinished: Boolean;
      FHeadingHeight: Integer;
      FFmtRef: TRVTableItemFormattingInfo;
      function GetSoftPageBreakInfo: Integer; override;
      function IsComplexSoftPageBreak(DrawItem: TRVDrawLineInfo): Boolean; override;
      procedure AssignSoftPageBreaksToItem(DrawItem: TRVDrawLineInfo;
        Item: TCustomRVItemInfo); override;
      constructor Create(ATable: TRVTableItemInfo);
      destructor Destroy; override;
      procedure UpdateRowStarts(Index, RowSpan, Height: Integer);
  end;

  TRVTablePrintInfo = class (TRVMultiDrawItemInfo)
    private
      sad: TRVScreenAndDevice;
      FTable: TRVTableItemInfo;
      FHeadingRowCount: Integer;
      {$IFNDEF RVDONOTUSESEQ}
      procedure AddFootnotes(var FootnoteRVDataList: TRVFootnoteRefList;
        var Height: Integer; FootnotesChangeHeight: Boolean; RowCount: Integer);
      procedure RemoveFootnotes(var FootnoteRVDataList: TRVFootnoteRefList;
        var Height: Integer; FootnotesChangeHeight: Boolean; RowCount: Integer);
      procedure DecHeightByFootnotes_(var Height: Integer;
        var ThisPageHasFootnotes: Boolean; RowCount: Integer);
      {$ENDIF}
    public
      Fmt: TRVTableItemFormattingInfo;
      constructor Create(ATable: TRVTableItemInfo);
      procedure SetSize(AWidth, AHeight: Integer); override;
      destructor Destroy; override;
      function InitSplit(const Sad: TRVScreenAndDevice) : Boolean; override;
      function CanSplitFirst(Y: Integer; const Sad: TRVScreenAndDevice;
        FirstOnPage, PageHasFootnotes, FootnotesChangeHeight: Boolean): Boolean; override;
      function SplitAt(Y: Integer; const Sad: TRVScreenAndDevice;
        FirstOnPage: Boolean; var FootnoteRVDataList: TList;
        var MaxHeight: Integer; FootnotesChangeHeight: Boolean): Boolean; override;
      procedure ResetPages(var FootnoteRVDataList: TRVFootnoteRefList;
        var ReleasedHeightAfterFootnotes: Integer;
        FootnotesChangeHeight: Boolean); override;
      procedure UnformatLastPage(var FootnoteRVDataList: TRVFootnoteRefList;
        var ReleasedHeightAfterFootnotes: Integer;
        FootnotesChangeHeight: Boolean); override;
      {$IFNDEF RVDONOTUSESEQ}
      procedure AddAllFootnotes(var FootnoteRVDataList: TRVFootnoteRefList;
        var Height: Integer; FootnotesChangeHeight: Boolean); override;
      procedure RemoveAllFootnotes(var FootnoteRVDataList: TRVFootnoteRefList;
        var Height: Integer; FootnotesChangeHeight: Boolean); override;
      procedure DecHeightByFootnotes(var Height: Integer;
        var ThisPageHasFootnotes: Boolean); override;
      {$ENDIF}
      function GetPartNo(RVData: TCustomRVData;
        ItemNo, OffsInItem: Integer): Integer; override;
  end;

  TRVPageFormatSaveRec = record
    DrawItemNo, StartAt, StartY, Y, EndAt, PagesCount: Integer;
    Splitting: Boolean;
  end;

  TCellPtblRVData = class (TRectPtblRVData)
    private
      DrawItemNo, StartAt, StartY, Y, CurPageNo, EndAt: Integer;
      Splitting: Boolean;
      PrevPageInfo: TRVPageFormatSaveRec;
      procedure ResetDrawItems(StartDItemNo: Integer;
        var FootnoteRVDataList: TRVFootnoteRefList; ResetAll, InHeader: Boolean;
        var ReleasedHeightAfterFootnotes: Integer;
        FootnotesChangeHeight: Boolean);
    protected
      procedure SetEndAt(Value: Integer); override;
    public
      function GetRVStyle: TRVStyle; override;
      function FormatNextPage(var AMaxHeight: Integer;
        var FootnoteRVDataList: TRVFootnoteRefList; FootnotesChangeHeight: Boolean): Boolean;
      procedure UnformatLastPage(var FootnoteRVDataList: TRVFootnoteRefList;
        var ReleasedHeightAfterFootnotes: Integer; FootnotesChangeHeight: Boolean);
      procedure ResetPages(var FootnoteRVDataList: TRVFootnoteRefList;
        var ReleasedHeightAfterFootnotes: Integer; FootnotesChangeHeight, InHeader: Boolean);
      function Finished: Boolean;
  end;  

  ERVTableInplaceError = class (Exception);

const RichViewTableGridStyle: TPenStyle = psDot;    // in editor
      RichViewTableGridStyle2: TPenStyle = psClear; // in viewer
      RichViewTableGridColor: TColor = clBtnFace;
      RichViewTableDefaultRTFAutofit: Boolean = False;
      RichViewTableAutoAddRow: Boolean = True;

implementation
uses RVTInplace;
const errMerge = 'Parameters for cell merging are not correct';
      errIso   = 'Cannot perform operation for isolated cell';
      errReadCells  = 'Wrong end of cells list';
      errInplaceBusy = 'Cannot destroy cell inplace editor at this time';
      errInvalidIndex = 'Invalid row or column index';
      errInternalError = 'Internal error';
{======================= TRVTableTemporalEditorData ===========================}
type
  TRVTableTemporalEditorData = class (TRVEditRVData)
    public
      function GetAbsoluteParentData: TCustomRVData; override;
      function GetAbsoluteRootData: TCustomRVData; override;
  end;
{------------------------------------------------------------------------------}
function TRVTableTemporalEditorData.GetAbsoluteParentData: TCustomRVData;
begin
  if RichView.Parent=nil then
    Result := nil
  else
    Result := (RichView.Parent as TCustomRichViewEdit).RVData;
end;
{------------------------------------------------------------------------------}
function TRVTableTemporalEditorData.GetAbsoluteRootData: TCustomRVData;
begin
  if RichView.Parent=nil then
    Result := nil
  else
    Result := (RichView.Parent as TCustomRichViewEdit).RVData.GetAbsoluteRootData;
end;
{============================== TRVTableTemporalEditor ========================}
type
  TRVTableTemporalEditor = class (TCustomRichViewEdit)
    public
       function GetDataClass: TRichViewRVDataClass; override;
       constructor Create2(AParent: TWinControl);
  end;
{------------------------------------------------------------------------------}
constructor TRVTableTemporalEditor.Create2(AParent: TWinControl);
begin
  inherited Create(nil);
  Visible := False;
  Parent := AParent;
  TRVEditRVData(RVData).UndoList.FRVData := TCustomRVFormattedData(RVData.GetAbsoluteRootData);
  TRVEditRVData(RVData).RedoList.FRVData := TCustomRVFormattedData(RVData.GetAbsoluteRootData);  
end;
{------------------------------------------------------------------------------}
function TRVTableTemporalEditor.GetDataClass: TRichViewRVDataClass;
begin
  Result := TRVTableTemporalEditorData;
end;
{=============================== TD ===========================================}
type
  TD = class (TComponent)
    private
      FCellCount: Integer;
      FRVTableSW: TComponent;
    protected
      procedure Loaded; override;
    public
      FCell: TRVTableCellData;
      constructor Create(AOwner: TComponent); override;
      procedure DecRef;
    published
      property C: TRVTableCellData read FCell write FCell;
  end;
{------------------------------------------------------------------------------}
constructor TD.Create(AOwner: TComponent);
begin
  inherited;
  FCellCount := 1;
end;
{------------------------------------------------------------------------------}
procedure TD.Loaded;
begin
  inherited;
  DecRef;
end;
{------------------------------------------------------------------------------}
procedure TD.DecRef;
begin
  dec(FCellCount);
  if FCellCount=0 then
    FRVTableSW.Free;
end;
{============================= TRVTableSW =====================================}
type
  TRVTableSW = class (TComponent)
    public
      FTable: TRVTableItemInfo;
      FTD: TD;
    protected
       procedure DefineProperties(Filer: TFiler); override;
       procedure RowVAlignWriter(Writer: TWriter);
       procedure RowVAlignReader(Reader: TReader);
       function RowVAlignHasData: Boolean;
       procedure RowPageBreakBeforeWriter(Writer: TWriter);
       procedure RowPageBreakBeforeReader(Reader: TReader);
       function RowPageBreakBeforeHasData: Boolean;
    public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
    published
      property T: TRVTableItemInfo read FTable write FTable;
  end;
{------------------------------------------------------------------------------}
constructor TRVTableSW.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTD := TD.Create(nil);
  FTD.FRVTableSW := Self;
end;
{------------------------------------------------------------------------------}
destructor TRVTableSW.Destroy;
begin
  FTD.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
procedure TRVTableSW.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('C', T.CellsReader, T.CellsWriter, True);
  Filer.DefineProperty('RowVAlign', RowVAlignReader, RowVAlignWriter, RowVAlignHasData);
  Filer.DefineProperty('RowPageBreakBefore', RowPageBreakBeforeReader,
    RowPageBreakBeforeWriter, RowPageBreakBeforeHasData);
end;
{------------------------------------------------------------------------------}
function TRVTableSW.RowVAlignHasData: Boolean;
var r, count: Integer;
begin
  Result := False;
  if T.FStreamSaveInfo.SaveHeadingRows then begin
    count := T.HeadingRowCount;
    if count>T.RowCount then
      count := T.RowCount;
    for r := 0 to count-1 do
      if T.Rows[r].VAlign<>rvcTop then begin
        Result := True;
        exit;
      end;
  end;
  for r := T.FStreamSaveInfo.TopRow to T.FStreamSaveInfo.TopRow+T.FStreamSaveInfo.RowCount-1 do
    if (r<T.RowCount) and (T.Rows[r].VAlign<>rvcTop) then begin
      Result := True;
      exit;
    end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableSW.RowVAlignReader(Reader: TReader);
var r: Integer;
begin
  Reader.ReadListBegin;
  for r := 0 to T.RowCount-1 do
    T.Rows[T.FStreamSaveInfo.TopRow+r].VAlign := TRVCellVAlign(Reader.ReadInteger);
  Reader.ReadListEnd;
end;
{------------------------------------------------------------------------------}
procedure TRVTableSW.RowVAlignWriter(Writer: TWriter);
var r, count: Integer;
begin
  Writer.WriteListBegin;
  if T.FStreamSaveInfo.SaveHeadingRows then begin
    count := T.HeadingRowCount;
    if count>T.RowCount then
      count := T.RowCount;
    for r := 0 to count-1 do
      Writer.WriteInteger(Integer(T.Rows[r].VAlign));
  end;
  for r := T.FStreamSaveInfo.TopRow to T.FStreamSaveInfo.TopRow+T.FStreamSaveInfo.RowCount-1 do
    Writer.WriteInteger(Integer(T.Rows[r].VAlign));
  Writer.WriteListEnd;
end;
{------------------------------------------------------------------------------}
function TRVTableSW.RowPageBreakBeforeHasData: Boolean;
var r, count: Integer;
begin
  Result := False;
  if T.FStreamSaveInfo.SaveHeadingRows then begin
    count := T.HeadingRowCount;
    if count>T.RowCount then
      count := T.RowCount;
    for r := 0 to count-1 do
      if T.Rows[r].PageBreakBefore then begin
        Result := True;
        exit;
      end;
  end;
  for r := T.FStreamSaveInfo.TopRow to T.FStreamSaveInfo.TopRow+T.FStreamSaveInfo.RowCount-1 do
    if (r<T.RowCount) and T.Rows[r].PageBreakBefore then begin
      Result := True;
      exit;
    end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableSW.RowPageBreakBeforeReader(Reader: TReader);
var r: Integer;
begin
  Reader.ReadListBegin;
  for r := 0 to T.RowCount-1 do
    T.Rows[T.FStreamSaveInfo.TopRow+r].PageBreakBefore := Reader.ReadBoolean;
  Reader.ReadListEnd;
end;
{------------------------------------------------------------------------------}
procedure TRVTableSW.RowPageBreakBeforeWriter(Writer: TWriter);
var r, count: Integer;
begin
  Writer.WriteListBegin;
  if T.FStreamSaveInfo.SaveHeadingRows then begin
    count := T.HeadingRowCount;
    if count>T.RowCount then
      count := T.RowCount;
    for r := 0 to count-1 do
      Writer.WriteBoolean(T.Rows[r].PageBreakBefore);
  end;
  for r := T.FStreamSaveInfo.TopRow to T.FStreamSaveInfo.TopRow+T.FStreamSaveInfo.RowCount-1 do
    Writer.WriteBoolean(T.Rows[r].PageBreakBefore);
  Writer.WriteListEnd;
end;
{============================ TRVTableStreamSaveInfo ==========================}
// Constructor. This class is used to store a range of cells to save, or a
// starting cell position to load. It is created on the time of saving/loading,
// then destroyed immediately.
constructor TRVTableStreamSaveInfo.Create(table: TRVTableItemInfo);
begin
  inherited Create;
  RowCount := table.RowCount;
  ColCount := table.ColCount;
  LoadResult := True;
end;
{====================== TRVTableStoreSubRVData ================================}
{ Constructor. This class is used to define a location of RVData (cell) in the
  table. }
constructor TRVTableStoreSubRVData.Create(ARow, ACol: Integer);
begin
  inherited Create;
  Row := ARow;
  Col := ACol;
end;
{------------------------------------------------------------------------------}
{ Returns a copy of itself. }
function TRVTableStoreSubRVData.Duplicate: TRVStoreSubRVData;
begin
  Result := TRVTableStoreSubRVData.Create(Row,Col);
end;
{------------------------------------------------------------------------------}
{ Compares itself with StoreSub. Self and StoreSub must be of the same item.
  Return value: 0 if the same subdocument, <0 if Self is before StoreSub,
    > 0 if Self is after StoreSub. }
function TRVTableStoreSubRVData.Compare(StoreSub: TRVStoreSubRVData): Integer;
begin
  Result := Row - (StoreSub as TRVTableStoreSubRVData).Row;
  if Result=0 then
    Result := Col - TRVTableStoreSubRVData(StoreSub).Col;
end;
{========================== TRVTablePrintPart =================================}
function TRVTablePrintPart.IsComplexSoftPageBreak(
  DrawItem: TRVDrawLineInfo): Boolean;
var c: Integer;
    Table: TRVTableItemInfo;
begin
  Result := False;
  if FTableTopCutLine=nil then
    exit;
  Result := True;
  Table := (DrawItem as TRVTablePrintInfo).FTable;
  for c := 0 to Table.ColCount-1 do
    if FTableTopCutLine[c]>1 then
      exit;
  Result := False;
end;
{------------------------------------------------------------------------------}
procedure TRVTablePrintPart.AssignSoftPageBreaksToItem(DrawItem: TRVDrawLineInfo;
  Item: TCustomRVItemInfo);
var c, mr, mc: Integer;
    Table: TRVTableItemInfo;
begin
  if FTableTopCutLine=nil then
    exit;
  Table := Item as TRVTableItemInfo; // (DrawItem as TRVTablePrintInfo).FTable;
  for c := 0 to Table.ColCount-1 do
    if FTableTopCutLine[c]>1 then begin
      Table.Rows.GetMainCell(FRowIndices[0], c, mr, mc);
      Table.Cells[mr, mc].AssignSoftPageBreak((DrawItem as TRVTablePrintInfo).Fmt.Rows[mr*Table.ColCount+mc],
        FTableTopCutLine[c]);
    end;
end;
{------------------------------------------------------------------------------}
function TRVTablePrintPart.GetSoftPageBreakInfo: Integer;
begin
  Result := FRowIndices[0];
end;
{------------------------------------------------------------------------------}
constructor TRVTablePrintPart.Create(ATable: TRVTableItemInfo);
begin
  inherited Create;
  FRowStarts    := TRVIntegerList.Create;
  FRowIndices   := TRVIntegerList.Create;
end;
{------------------------------------------------------------------------------}
destructor TRVTablePrintPart.Destroy;
begin
  FTableTopCutLine.Free;
  FTableBottomCutLine.Free;  
  FRowStarts.Free;
  FRowIndices.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
procedure TRVTablePrintPart.UpdateRowStarts(Index, RowSpan,
  Height: Integer);
var i, v, idx: Integer;
begin
  if FRowStarts.Count=0 then begin
    v := 0;
    idx := 0;
    end
  else begin
    v := FRowStarts[FRowStarts.Count-1];
    idx := FRowIndices[FRowIndices.Count-1];
    inc(Height, FRowStarts[Index]);
  end;
  for i := FRowStarts.Count to Index+RowSpan do begin
    FRowStarts.Add(v);
    inc(idx);
    FRowIndices.Add(idx);
  end;
  if FRowStarts[Index+RowSpan]<Height then begin
    FRowStarts[Index+RowSpan] := Height;
    {
    v := Height-FRowStarts[Index+RowSpan];
    for i := Index+RowSpan to FRowStarts.Count-1 do
      FRowStarts[i] := FRowStarts[i]+v;
    }
  end;
end;
{============================== TRVTablePrintInfo =============================}
constructor TRVTablePrintInfo.Create(ATable: TRVTableItemInfo);
begin
  inherited Create;
  FTable := ATable;
  Fmt := TRVTableItemFormattingInfo.Create(True);
  if FTable.CanUseHeadingRowCount then begin
    FHeadingRowCount := FTable.FHeadingRowCount;
    if FHeadingRowCount>FTable.RowCount then
      FHeadingRowCount := FTable.RowCount;
  end;
end;
{------------------------------------------------------------------------------}
destructor TRVTablePrintInfo.Destroy;
begin
  Fmt.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
function TRVTablePrintInfo.InitSplit(const Sad: TRVScreenAndDevice): Boolean;
begin
  if not ((rvtoRowsSplit in FTable.PrintOptions) or
      FTable.RowsHavePageBreaksBefore(-1, -1))
     or
      (FHeadingRowCount>=FTable.RowCount) then begin
    Result := False;
    exit;
  end;
  PartsList.Add(nil);
  Result := True;
end;
{------------------------------------------------------------------------------}
function TRVTablePrintInfo.CanSplitFirst(Y: Integer;
  const Sad: TRVScreenAndDevice; FirstOnPage,
  PageHasFootnotes, FootnotesChangeHeight: Boolean): Boolean;
var BorderHeight, StartHeight, ExtraCellHeight,
    DeltaBottomHeight, RemainingHeight, c, mr, mc, ColCount,
    HeightAfterFootnotes: Integer;
var RVStyle: TRVStyle;
begin
  if PartsList.Count=0 then begin
    Result := False;
    exit;
  end;
  RVStyle := FTable.GetRVStyle;
  BorderHeight :=
    RVStyle.GetAsDevicePixelsY(FTable.BorderWidth, @Sad)+
    RVStyle.GetAsDevicePixelsY(FTable.BorderVSpacing, @Sad);
  StartHeight :=
    Fmt.RowStarts[FHeadingRowCount]-
    RVStyle.GetAsDevicePixelsY(FTable.CellBorderWidth, @SaD);
  {$IFNDEF RVDONOTUSESEQ}
  if FootnotesChangeHeight and (FHeadingRowCount>0) then begin
    c := 0;
    DecHeightByFootnotes_(c, PageHasFootnotes, FHeadingRowCount);
    dec(StartHeight, c);
  end;
  {$ENDIF}

  ExtraCellHeight :=
    RVStyle.GetAsDevicePixelsY(FTable.CellVPadding, @SaD)+
    RVStyle.GetAsDevicePixelsY(FTable.CellBorderWidth, @SaD)*2;
  DeltaBottomHeight := BorderHeight;
  dec(Y, DeltaBottomHeight);
  RemainingHeight := Y - StartHeight - ExtraCellHeight;

  ColCount := FTable.ColCount;
  HeightAfterFootnotes := RemainingHeight;
  {$IFNDEF RVDONOTUSESEQ}
  c := 0;  
  if FootnotesChangeHeight then begin
    Result := True;
    while c<ColCount do begin
      FTable.Rows.GetMainCell(FHeadingRowCount, c, mr, mc);
      if (Fmt.Rows[mr*ColCount+mc]<>nil) and
        not TCellPtblRVData(Fmt.Rows[mr*ColCount+mc]).CanPlaceFirstPageHere(
        HeightAfterFootnotes, FirstOnPage, sad, PageHasFootnotes, True) then
        Result := False;
      if RemainingHeight<>HeightAfterFootnotes then
        PageHasFootnotes := True;
      inc(c, FTable.Cells[mr,mc].ColSpan);
    end;
    if not Result or (RemainingHeight=HeightAfterFootnotes) then
      exit;
  end;
  {$ENDIF}
  c := 0;
  Result := False;
  while c<ColCount do begin
    FTable.Rows.GetMainCell(FHeadingRowCount, c, mr, mc);
    if not FirstOnPage and
       (RVStyle.GetAsDevicePixelsY(FTable.Cells[mr,mc].BestHeight, @SaD)+ExtraCellHeight-1
       >HeightAfterFootnotes) then
      exit;
    if (Fmt.Rows[mr*ColCount+mc]<>nil) and
      not TCellPtblRVData(Fmt.Rows[mr*ColCount+mc]).CanPlaceFirstPageHere(
      HeightAfterFootnotes, FirstOnPage, sad, False, False) then
      exit;
    inc(c, FTable.Cells[mr,mc].ColSpan);
  end;
  Result := True;
end;
{------------------------------------------------------------------------------}
procedure TRVTablePrintInfo.ResetPages(var FootnoteRVDataList: TRVFootnoteRefList;
  var ReleasedHeightAfterFootnotes: Integer;
  FootnotesChangeHeight: Boolean);
var c, r, ColCount {, i, mr, mc}: Integer;
    {lastpart, part: TRVTablePrintPart;}
begin
  if PartsList.Count=0 then begin
    if FootnoteRVDataList<>nil then
      RemoveAllFootnotes(FootnoteRVDataList, ReleasedHeightAfterFootnotes,
        FootnotesChangeHeight);
    exit;
  end;

  ColCount := FTable.ColCount;
  for r := 0 to FTable.RowCount-1 do
    for c := 0 to ColCount-1 do
      if Fmt.Rows[r*ColCount+c]<>nil then
        TCellPtblRVData(Fmt.Rows[r*ColCount+c]).ResetPages(FootnoteRVDataList,
            ReleasedHeightAfterFootnotes, FootnotesChangeHeight,
            r<FHeadingRowCount);
  {

  for i := 0 to PartsList.Count-1 do begin
    part := TRVTablePrintPart(PartsList[i]);
    if part=nil then
      continue;
    if part.FTableTopCutLine<>nil then begin
      lastpart := TRVTablePrintPart(PartsList[i-1]);
      r := lastpart.FRowIndices[lastpart.FRowIndices.Count-2];
      c := ColCount-1;
      while c>=0 do begin
        FTable.Rows.GetMainCell(r, c, mr, mc);
        if Fmt.Rows[mr*ColCount+mc]<>nil then
          TCellPtblRVData(Fmt.Rows[mr*ColCount+mc]).ResetPages(FootnoteRVDataList,
            ReleasedHeightAfterFootnotes, FootnotesChangeHeight);
        c := mc-1;
      end;
    end;
    if part.FTableBottomCutLine<>nil then begin
      r := part.FRowIndices[part.FRowIndices.Count-2];
      c := ColCount-1;
      while c>=0 do begin
        FTable.Rows.GetMainCell(r, c, mr, mc);
        if Fmt.Rows[mr*ColCount+mc]<>nil then
          TCellPtblRVData(Fmt.Rows[mr*ColCount+mc]).ResetPages(FootnoteRVDataList,
            ReleasedHeightAfterFootnotes, FootnotesChangeHeight);
        c := mc-1;
      end;
    end;
  end;
  }
  inherited ResetPages(FootnoteRVDataList, ReleasedHeightAfterFootnotes,
    FootnotesChangeHeight);
end;
{------------------------------------------------------------------------------}
procedure TRVTablePrintInfo.UnformatLastPage(var FootnoteRVDataList: TRVFootnoteRefList;
  var ReleasedHeightAfterFootnotes: Integer;
  FootnotesChangeHeight: Boolean);
var i, c, r, mr, mc, FirstRow, ColCount: Integer;
    part: TRVTablePrintPart;
begin
  if PartsList.Count=0 then begin
    RemoveAllFootnotes(FootnoteRVDataList, ReleasedHeightAfterFootnotes,
      FootnotesChangeHeight);
    exit;
  end;
  ColCount := FTable.ColCount;
  for i := PartsList.Count-1 downto 0 do begin
    part := TRVTablePrintPart(PartsList[i]);
    if part=nil then
      continue;
    FirstRow := part.FRowIndices[0];
    if part.FTableTopCutLine<>nil then begin
      r := FirstRow;
      for c := 0 to ColCount-1 do
        if part.FTableTopCutLine[c]>0 then begin
          FTable.Rows.GetMainCell(r, c, mr, mc);
          if Fmt.Rows[mr*ColCount+mc]<>nil then
            TCellPtblRVData(Fmt.Rows[mr*ColCount+mc]).UnformatLastPage(FootnoteRVDataList,
              ReleasedHeightAfterFootnotes, FootnotesChangeHeight);
        end;
    end;
    for r := FirstRow+1 to part.FRowIndices[part.FRowIndices.Count-2] do
      for c := 0 to ColCount-1 do
        if Fmt.Rows[r*ColCount+c]<>nil then
            TCellPtblRVData(Fmt.Rows[r*ColCount+c]).ResetPages(FootnoteRVDataList,
              ReleasedHeightAfterFootnotes, FootnotesChangeHeight,
              r<FHeadingRowCount);
    PartsList.Delete(i);
    break;
  end;
  inherited UnformatLastPage(FootnoteRVDataList, ReleasedHeightAfterFootnotes,
    FootnotesChangeHeight);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESEQ}
procedure TRVTablePrintInfo.AddFootnotes(var FootnoteRVDataList: TRVFootnoteRefList;
  var Height: Integer; FootnotesChangeHeight: Boolean; RowCount: Integer);
var  i,r,c, ColCount: Integer;
     DrawItem: TRVDrawLineInfo;
     FootnoteRVData: TRVFootnotePtblRVData;
     CellPtblRVData: TCellPtblRVData;
begin
  ColCount := FTable.ColCount;
  for r := 0 to RowCount-1 do
    for c := 0 to ColCount-1 do begin
      CellPtblRVData := TCellPtblRVData(Fmt.Rows[r*ColCount+c]);
      if CellPtblRVData<>nil then
        for i := 0 to CellPtblRVData.DrawItems.Count-1 do begin
          DrawItem := CellPtblRVData.DrawItems[i];
          if (CellPtblRVData.GetItem(DrawItem.ItemNo) is TRVFootnoteItemInfo) then begin
            FootnoteRVData := CellPtblRVData.GetFootnoteRVData(
              TRVFootnoteItemInfo(CellPtblRVData.GetItem(DrawItem.ItemNo)));
            if (FootnoteRVDataList<>nil) and
               (FootnoteRVDataList.GetFootnoteIndex(
                TRVFootnoteItemInfo(CellPtblRVData.GetItem(DrawItem.ItemNo)))>=0) then
              continue;
            if DrawItem is TRVFootnoteDrawItem then begin
              TRVFootnoteDrawItem(DrawItem).DocumentRVData := FootnoteRVData;
              FootnoteRVData.FootnoteItemRVData := CellPtblRVData;
              FootnoteRVData.FootnoteDItemNo := i;
            end;
            if FootnotesChangeHeight then
              dec(Height, FootnoteRVData.DocumentHeight);
            if FootnoteRVDataList=nil then begin
              FootnoteRVDataList := TRVFootnoteRefList.Create;
              if FootnotesChangeHeight then
                dec(Height, CellPtblRVData.GetNoteSeparatorHeight);
            end;
            FootnoteRVDataList.Add(FootnoteRVData);
          end;
          if DrawItem is TRVMultiDrawItemInfo then
            TRVMultiDrawItemInfo(DrawItem).AddAllFootnotes(FootnoteRVDataList,
              Height, FootnotesChangeHeight);
        end;
    end;
end;
{------------------------------------------------------------------------------}
procedure TRVTablePrintInfo.RemoveFootnotes(var FootnoteRVDataList: TRVFootnoteRefList;
  var Height: Integer; FootnotesChangeHeight: Boolean; RowCount: Integer);
var  i,r,c, ColCount, FootnoteRefIndex: Integer;
     DrawItem: TRVDrawLineInfo;
     CellPtblRVData: TCellPtblRVData;
begin
  ColCount := FTable.ColCount;
  for r := 0 to RowCount-1 do
    for c := 0 to ColCount-1 do begin
      CellPtblRVData := TCellPtblRVData(Fmt.Rows[r*ColCount+c]);
      if CellPtblRVData<>nil then
        for i := 0 to CellPtblRVData.DrawItems.Count-1 do begin
          DrawItem := CellPtblRVData.DrawItems[i];
          if (CellPtblRVData.GetItem(DrawItem.ItemNo) is TRVFootnoteItemInfo) then begin
            FootnoteRefIndex := FootnoteRVDataList.GetFootnoteIndex(
              TRVFootnoteItemInfo(CellPtblRVData.GetItem(DrawItem.ItemNo)));
            FootnoteRVDataList.Delete(FootnoteRefIndex);
            if FootnoteRVDataList.Count=0 then begin
              FootnoteRVDataList.Free;
              FootnoteRVDataList := nil;
            end;
          end;
          if DrawItem is TRVMultiDrawItemInfo then
            TRVMultiDrawItemInfo(DrawItem).RemoveAllFootnotes(FootnoteRVDataList,
              Height, FootnotesChangeHeight);
        end;
    end;
end;
{------------------------------------------------------------------------------}
procedure TRVTablePrintInfo.DecHeightByFootnotes_(var Height: Integer;
  var ThisPageHasFootnotes: Boolean; RowCount: Integer);
var  i,r,c, ColCount: Integer;
     DrawItem: TRVDrawLineInfo;
     FootnoteRVData: TRVFootnotePtblRVData;
     CellPtblRVData: TCellPtblRVData;
begin
  ColCount := FTable.ColCount;
  for r := 0 to RowCount-1 do
    for c := 0 to ColCount-1 do begin
      CellPtblRVData := TCellPtblRVData(Fmt.Rows[r*ColCount+c]);
      if CellPtblRVData<>nil then
        for i := 0 to CellPtblRVData.DrawItems.Count-1 do begin
          DrawItem := CellPtblRVData.DrawItems[i];
          if (CellPtblRVData.GetItem(DrawItem.ItemNo) is TRVFootnoteItemInfo) then begin
            FootnoteRVData := CellPtblRVData.GetFootnoteRVData(
              TRVFootnoteItemInfo(CellPtblRVData.GetItem(DrawItem.ItemNo)));
            dec(Height, FootnoteRVData.DocumentHeight);
            if not ThisPageHasFootnotes then begin
              ThisPageHasFootnotes := True;
              dec(Height, CellPtblRVData.GetNoteSeparatorHeight);
            end;
          end;
          if DrawItem is TRVMultiDrawItemInfo then
            TRVMultiDrawItemInfo(DrawItem).DecHeightByFootnotes(Height,
              ThisPageHasFootnotes);
        end;
    end;
end;
{------------------------------------------------------------------------------}
procedure TRVTablePrintInfo.AddAllFootnotes(
  var FootnoteRVDataList: TRVFootnoteRefList; var Height: Integer;
  FootnotesChangeHeight: Boolean);
begin
  AddFootnotes(FootnoteRVDataList, Height, FootnotesChangeHeight, FTable.RowCount);
end;
{------------------------------------------------------------------------------}
procedure TRVTablePrintInfo.DecHeightByFootnotes(var Height: Integer;
  var ThisPageHasFootnotes: Boolean);
begin
  DecHeightByFootnotes_(Height, ThisPageHasFootnotes, FTable.RowCount)
end;
{------------------------------------------------------------------------------}
procedure TRVTablePrintInfo.RemoveAllFootnotes(
  var FootnoteRVDataList: TRVFootnoteRefList; var Height: Integer;
  FootnotesChangeHeight: Boolean);
begin
  RemoveFootnotes(FootnoteRVDataList, Height, FootnotesChangeHeight,
    FTable.RowCount);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRVTablePrintInfo.SplitAt(Y: Integer; const Sad: TRVScreenAndDevice;
  FirstOnPage: Boolean; var FootnoteRVDataList: TList;
  var MaxHeight: Integer; FootnotesChangeHeight: Boolean): Boolean;
var BorderHeight, StartHeight, mr, mc, r, FirstRow, c, ColCount, ExtraCellHeight,
    CellPage, {$IFNDEF RVDONOTUSESEQ}OldY,{$ENDIF}
    DeltaBottomHeight, RemainingHeight, HeightAfterFootnotes, LastY: Integer;
    IgnoreFootnotesRow: Integer;
    lastpart, part: TRVTablePrintPart;
    idx, idx2: Integer;
    CanStartPartialRow, PageHasFootnotes: Boolean;
    CellPtblRVData: TCellPtblRVData;
    RVStyle: TRVStyle;
    {................................................................}
    // Returns cell height in device pixels
    function GetCellHeight(r,c, CurrentRow, CellPage: Integer;
      var MaxHeight: Integer; var RowFinished: Boolean;
      ThereWereFootnotesAlready: Boolean): Integer;
    var h{$IFNDEF RVDONOTUSESEQ}, OldMaxHeight{$ENDIF}: Integer;
        CellPtblRVData: TCellPtblRVData;
    begin
      if CellPage=0 then begin
        Result := 0;
        exit;
      end;
      Result := RVStyle.GetAsDevicePixelsY(FTable.Cells[r,c].BestHeight, @SaD);
      if (Result+ExtraCellHeight-1>MaxHeight) and (idx=0) and FirstOnPage then
        Result := MaxHeight-(ExtraCellHeight-1);
      if (CellPage>=1) and
         not ((rvtoIgnoreContentHeight in FTable.Options) and (FTable.Cells[r,c].BestHeight>0)) then begin
        CellPtblRVData := TCellPtblRVData(Fmt.Rows[r*ColCount+c]);
        if CellPtblRVData=nil then begin
          h := RV_YToDevice(FTable.Cells[r,c].GetHeight, SaD);
          end
        else begin
          {$IFNDEF RVDONOTUSESEQ}
          OldMaxHeight := MaxHeight;
          {$ENDIF}
          if CellPage=1 then begin
            {$IFDEF RVDONOTUSESEQ}
            h := CellPtblRVData.DocumentHeight;
            if h>MaxHeight then
            {$ENDIF}
            begin
              CellPtblRVData.FormatNextPage(MaxHeight,
                TRVFootnoteRefList(FootnoteRVDataList),
                FootnotesChangeHeight and (r>IgnoreFootnotesRow));
              if CellPtblRVData.Finished then
                h := CellPtblRVData.EndAt
              else
                h := MaxHeight+100;
              CellPtblRVData.ResetPages(TRVFootnoteRefList(FootnoteRVDataList),
                MaxHeight, False, False);
              {$IFNDEF RVDONOTUSESEQ}
              if ThereWereFootnotesAlready and (OldMaxHeight<>MaxHeight) then
                inc(MaxHeight, CellPtblRVData.GetNoteSeparatorHeight);
              {$ENDIF}
            end
            end
          else begin
            CellPtblRVData.FormatNextPage(MaxHeight,
              TRVFootnoteRefList(FootnoteRVDataList),
               FootnotesChangeHeight and (r>IgnoreFootnotesRow));
            {$IFNDEF RVDONOTUSESEQ}
            if ThereWereFootnotesAlready and (OldMaxHeight<>MaxHeight) then
              inc(MaxHeight, CellPtblRVData.GetNoteSeparatorHeight);
            {$ENDIF}
            if CellPtblRVData.Finished then
              h := CellPtblRVData.EndAt
            else begin
              h := MaxHeight;
              RowFinished := False;
            end;
          end;
        end;
        if h>Result then
          Result := h;
      end;
      inc(Result, ExtraCellHeight-1);
    end;
    {................................................................}
    function GetPartHeight: Integer;
    begin
      Result := part.FRowStarts[part.FRowStarts.Count-1]+DeltaBottomHeight;
    end;
    {................................................................}
    {$IFNDEF RVDONOTUSESEQ}
    procedure AddFootnotesInList(FirstRow, LastRow: Integer);
    var r, c, mr, mc: Integer;
        CellPtblRVData: TCellPtblRVData;
        LargeHeight: Integer;
    begin
      if LastRow=FTable.RowCount then
        dec(LastRow);
      LargeHeight := $FFFFFFF;
      for r := FirstRow to LastRow do begin
        c := ColCount-1;
        while c>=0 do begin
          FTable.Rows.GetMainCell(r, c, mr, mc);
          if (part.FTableTopCutLine<>nil) and (mr<=FirstRow) and
             (part.FTableTopCutLine[mc]=0) then begin
            c := mc-1;
            continue;
          end;
          CellPtblRVData := TCellPtblRVData(Fmt.Rows[mr*ColCount+mc]);
          if (CellPtblRVData<>nil) and (CellPtblRVData.Pages=nil) then
            CellPtblRVData.FormatNextPage(LargeHeight,
              TRVFootnoteRefList(FootnoteRVDataList), False);
          c := mc-1;
        end;
      end;
    end;
    {$ENDIF}
    {................................................................}
var CellBorderWidthPix, BorderWidthPix, BorderVSpacingPix,
    CellVPaddingPix, CellVSpacingPix: Integer;
begin
  Result := False;
  RVStyle := FTable.GetRVStyle;
  ColCount := FTable.ColCount;
  {$IFDEF RVDONOTUSESEQ}
  PageHasFootnotes := False;
  {$ENDIF}
  if (PartsList.Count>1) then begin
    lastpart := TRVTablePrintPart(PartsList.Items[PartsList.Count-1]);
    if lastpart=nil then
      lastpart := TRVTablePrintPart(PartsList.Items[PartsList.Count-2]);
    r := lastpart.FRowIndices[lastpart.FRowIndices.Count-2];
    if lastpart.FRowFinished then
      inc(r);
    if r=FTable.RowCount then
      exit;
    end
  else begin
    lastpart := nil;
    r := FHeadingRowCount;
  end;
  Result := True;
  BorderWidthPix     := RVStyle.GetAsDevicePixelsY(FTable.BorderWidth, @SaD);
  CellBorderWidthPix := RVStyle.GetAsDevicePixelsY(FTable.CellBorderWidth, @SaD);
  BorderVSpacingPix  := RVStyle.GetAsDevicePixelsY(FTable.BorderVSpacing, @SaD);
  CellVPaddingPix    := RVStyle.GetAsDevicePixelsY(FTable.CellVPadding, @SaD);
  CellVSpacingPix    := RVStyle.GetAsDevicePixelsY(FTable.CellVSpacing, @SaD);

  BorderHeight := BorderWidthPix+BorderVSpacingPix;
  StartHeight := Fmt.RowStarts[FHeadingRowCount]-CellBorderWidthPix;
  {$IFNDEF RVDONOTUSESEQ}
  if (lastpart=nil) and (FHeadingRowCount>0)  then begin
    ExtraCellHeight := 0;
    AddFootnotes(TRVFootnoteRefList(FootnoteRVDataList), ExtraCellHeight,
      FootnotesChangeHeight, FHeadingRowCount);
    inc(MaxHeight, ExtraCellHeight);
    inc(Y, ExtraCellHeight);    
  end;
  {$ENDIF}
  // StartHeight := BorderHeight;
  ExtraCellHeight := (CellVPaddingPix+CellBorderWidthPix)*2+CellVSpacingPix;
  DeltaBottomHeight := BorderHeight-CellVSpacingPix;
  dec(Y, DeltaBottomHeight);
  {$IFNDEF RVDONOTUSESEQ}
  OldY := Y;
  {$ENDIF}
  part := TRVTablePrintPart.Create(FTable);
  part.FFmtRef := Fmt;
  part.FHeadingHeight := Fmt.RowStarts[FHeadingRowCount]-Fmt.RowStarts[0];
  PartsList[PartsList.Count-1] := part;
  PartsList.Add(nil);
  part.FRowStarts.Add(StartHeight);
  part.FRowIndices.Add(r);
  part.FRowFinished := True;
  idx := 0;
  if lastpart<>nil then begin
    part.FTableTopCutLine := lastpart.FTableBottomCutLine;
    lastpart.FTableBottomCutLine := nil;
  end;
  FirstRow := r;
  IgnoreFootnotesRow := -1;
  while r<FTable.RowCount do begin
    RemainingHeight := Y - part.FRowStarts[idx]-ExtraCellHeight;
    HeightAfterFootnotes := RemainingHeight;
    for c := 0 to ColCount-1 do begin
      if (idx=0) and (part.FTableTopCutLine<>nil) then begin
        CellPage := part.FTableTopCutLine[c];
        if CellPage>=1 then
          FTable.Rows.GetMainCell(r,c,mr,mc);
        end
      else begin
        CellPage := 1;
        mr := r;
        mc := c;
      end;
      if (CellPage>0) and (FTable.Cells[mr, mc]<>nil) then begin
        part.UpdateRowStarts(idx, FTable.Cells[mr, mc].RowSpan-(r-mr),
          GetCellHeight(mr, mc, r, CellPage, HeightAfterFootnotes,
            part.FRowFinished,
            (r>IgnoreFootnotesRow) and (FootnoteRVDataList=nil) and (HeightAfterFootnotes<>RemainingHeight)));
        if r<=IgnoreFootnotesRow then
          HeightAfterFootnotes := RemainingHeight;
      end;
    end;
    {$IFNDEF RVDONOTUSESEQ}
    if (r>IgnoreFootnotesRow) and (HeightAfterFootnotes<>RemainingHeight) then begin
      for c := 0 to ColCount-1 do begin
        if (idx=0) and (part.FTableTopCutLine<>nil) then begin
          CellPage := part.FTableTopCutLine[c];
          if CellPage>=1 then
            FTable.Rows.GetMainCell(r,c,mr,mc);
          end
        else begin
          CellPage := 1;
          mr := r;
          mc := c;
        end;
        if (CellPage>0) and (TCellPtblRVData(Fmt.Rows[mr*ColCount+mc])<>nil) then
          TCellPtblRVData(Fmt.Rows[mr*ColCount+mc]).UnformatLastPage(
            TRVFootnoteRefList(FootnoteRVDataList), HeightAfterFootnotes, False);
      end;
      if HeightAfterFootnotes<0 then
        HeightAfterFootnotes := 0;
      dec(Y, RemainingHeight-HeightAfterFootnotes);
      IgnoreFootnotesRow := r;
      r := FirstRow;
      idx := 0;
      part.FRowStarts.Clear;
      part.FRowIndices.Clear;
      part.FRowStarts.Add(StartHeight);
      part.FRowIndices.Add(r);
      part.FRowFinished := True;
      continue;
    end;
    {$ENDIF}
    if (not part.FRowFinished and (r+1=FTable.RowCount)) or
       ((r+1<FTable.RowCount) and FTable.Rows[r+1].PageBreakBefore) or
       ((part.FRowStarts.Count>idx+1) and (part.FRowStarts[idx+1]>=Y-1)) then begin
      dec(idx);
      part.FRowStarts.Count := idx+2;
      part.FRowIndices.Count := idx+2;
      break;
    end;
    inc(r);
    inc(idx);
  end;
  part.Height := GetPartHeight;
  if part.FRowFinished and (r=FTable.RowCount) then begin
    {$IFNDEF RVDONOTUSESEQ}
    if (IgnoreFootnotesRow>=0) or not FootnotesChangeHeight then begin
      AddFootnotesInList(FirstRow, r-1);
      dec(MaxHeight, OldY-Y);
    end;
    {$ENDIF}
    PartsList.Delete(PartsList.Count-1);
    Result := False;
    exit;
  end;
  if part.FRowStarts.Count>1 then
    FirstOnPage := False;
  { Checking if it's possible to add one more row, which will be split between
    pages }
  RemainingHeight := Y - part.FRowStarts[part.FRowStarts.Count-1] - ExtraCellHeight;
  HeightAfterFootnotes := RemainingHeight;
  CanStartPartialRow := True;
  if part.FRowStarts.Count>1 then begin
    {$IFNDEF RVDONOTUSESEQ}
    PageHasFootnotes := FootnoteRVDataList<>nil;
    if FootnotesChangeHeight then begin
      c := 0;
      while c<ColCount do begin
        FTable.Rows.GetMainCell(r, c, mr, mc);
        if (mr=r) and (RVStyle.GetAsDevicePixelsY(FTable.Cells[mr,mc].BestHeight, @SaD)+ExtraCellHeight-1
          >HeightAfterFootnotes) then
          CanStartPartialRow := False;
        if (mr=r) and (Fmt.Rows[mr*ColCount+mc]<>nil) and
           not TCellPtblRVData(Fmt.Rows[mr*ColCount+mc]).CanPlaceFirstPageHere(
             HeightAfterFootnotes, FirstOnPage, sad, PageHasFootnotes,
             r>IgnoreFootnotesRow) then
          CanStartPartialRow := False;
        inc(c, FTable.Cells[mr,mc].ColSpan);
      end;
    end;
    if CanStartPartialRow and
      ((HeightAfterFootnotes<>RemainingHeight) or not FootnotesChangeHeight) then
    {$ENDIF}
    begin
      c := 0;
      while c<ColCount do begin
        FTable.Rows.GetMainCell(r, c, mr, mc);
        if (mr=r) and (RVStyle.GetAsDevicePixelsY(FTable.Cells[mr,mc].BestHeight, @SaD)+ExtraCellHeight-1
          >HeightAfterFootnotes) then begin
          CanStartPartialRow := False;
          break;
        end;
        if (mr=r) and (Fmt.Rows[mr*ColCount+mc]<>nil) and
           not TCellPtblRVData(Fmt.Rows[mr*ColCount+mc]).CanPlaceFirstPageHere(
             HeightAfterFootnotes, FirstOnPage, sad, PageHasFootnotes,
             r>IgnoreFootnotesRow) then begin
          CanStartPartialRow := False;
          break;
        end;
        inc(c, FTable.Cells[mr,mc].ColSpan);
      end;
    end;
  end;
  if not CanStartPartialRow then
    dec(r);

  { -- Adding a new partial row (if possible).
       Filling FTableBottomCutLine for the last row -- }

  { Possible cases for some bottom cell
    (where BMC is a value assigned to BottomCutLine for this cell):
    (* 1 *) Cell content was finished before this page. BMC = 0
    (* 2 *) Cell content is not finished. BMC = next page
    If cell content is finished on this page ...
      (* 3 *) if cell is not finished (because of RowSpan), BMC = 0
      else ...
        (* 4 *) if CanStartPartialRow=False (i.e. this row is finished on this page), BMC = 1
        (* 3 *) if CanStartPartialRow=True (i.e. this row is split), BMC = 0

    (* 0 * ) For nil-cells, BMC = 0
  }
  part.FTableBottomCutLine := TRVIntegerList.CreateEx(ColCount, 0); (* 0 *)
  c := ColCount-1;
  LastY := 0;
  while c>=0 do begin
    FTable.Rows.GetMainCell(r, c, mr, mc);
    if (part.FTableTopCutLine<>nil) and (mr<=FirstRow) and
       (part.FTableTopCutLine[mc]=0) then begin
      c := mc-1;
      continue; (* 1 *)
    end;
    part.FTableBottomCutLine[mc] := 1; (* 4 *)
    CellPtblRVData := TCellPtblRVData(Fmt.Rows[mr*ColCount+mc]);
    if CellPtblRVData<>nil then begin
      idx2 := part.FRowStarts.Count-1-(r-mr);
      if not CanStartPartialRow then
        dec(idx2);
      if idx2<0 then
        idx2 := 0;
      RemainingHeight := Y - part.FRowStarts[idx2] - ExtraCellHeight;
      if (CellPtblRVData.Pages=nil) and not
          ((rvtoIgnoreContentHeight in FTable.Options) and
          (FTable.Cells[mr,mc].BestHeight>0))  then
        CellPtblRVData.FormatNextPage(RemainingHeight,
          TRVFootnoteRefList(FootnoteRVDataList), False);
      if (CellPtblRVData.Pages<>nil) and not CellPtblRVData.Finished then begin
        part.FTableBottomCutLine[mc] := CellPtblRVData.CurPageNo+1; (* 2 *)
        part.FRowFinished := False;
        end
      else begin
        if (rvtoIgnoreContentHeight in FTable.Options) and
          (FTable.Cells[mr,mc].BestHeight>0) then begin
          if LastY<part.FRowStarts[idx2]+RVStyle.GetAsDevicePixelsY(FTable.Cells[mr,mc].BestHeight, @SaD)+ExtraCellHeight then
            LastY := part.FRowStarts[idx2]+RVStyle.GetAsDevicePixelsY(FTable.Cells[mr,mc].BestHeight, @SaD)+ExtraCellHeight;
          end
        else begin
          if LastY<part.FRowStarts[idx2]+CellPtblRVData.EndAt+ExtraCellHeight then
            LastY := part.FRowStarts[idx2]+CellPtblRVData.EndAt+ExtraCellHeight;
        end;
        if CanStartPartialRow or (mr+FTable.Cells[mr,mc].RowSpan>r+1) then
          part.FTableBottomCutLine[mc] := 0; (* 3 *)
      end;
    end;
    c := mc-1;
  end;
  {$IFNDEF RVDONOTUSESEQ}
  if (IgnoreFootnotesRow>=0) or not FootnotesChangeHeight then begin
    AddFootnotesInList(FirstRow, r);
    dec(MaxHeight, OldY-Y);
  end;
  {$ENDIF}

  if CanStartPartialRow then begin
    if part.FRowFinished then
      part.FRowStarts.Add(LastY)
    else
      part.FRowStarts.Add(Y);
    part.FRowIndices.Add(r);
    part.Height := GetPartHeight;
  end;
  if part.FRowFinished then begin
    part.FTableBottomCutLine.Free;
    part.FTableBottomCutLine := nil;
    if r=FTable.RowCount-1 then begin
      PartsList.Delete(PartsList.Count-1);
      Result := False;
    end;
    end
  else begin
    part.FRowStarts[part.FRowStarts.Count-1] := Y;
    part.Height := GetPartHeight;
  end;
  if not CanStartPartialRow then
    part.FRowFinished := True;
end;
{------------------------------------------------------------------------------}
procedure TRVTablePrintInfo.SetSize(AWidth, AHeight: Integer);
begin
  // do nothing
end;
{------------------------------------------------------------------------------}
{ Returns the index of part containing the given position, or -1 if not found }
function TRVTablePrintInfo.GetPartNo(RVData: TCustomRVData;
  ItemNo, OffsInItem: Integer): Integer;
var r,c,PartNo, StartCellPageNo: Integer;
    part: TRVTablePrintPart;
begin
  Result := -1;
  for r := 0 to FTable.RowCount-1 do
    for c := 0 to FTable.ColCount-1 do
      if (FTable.Cells[r,c]<>nil) then begin
        Result := TCellPtblRVData(Fmt.Rows[r*FTable.ColCount+c]).GetPageNo(RVData,
          ItemNo, OffsInItem, FTable.Cells[r,c]);
        if Result>0 then begin
          for PartNo := 0 to PartsList.Count-1 do begin
            part := TRVTablePrintPart(PartsList[PartNo]);
            if part.FRowIndices[0]>r then begin
              Result := PartNo-1;
              exit;
              end
            else if part.FRowIndices[0]=r then begin
              if part.FTableTopCutLine<>nil then
                StartCellPageNo := part.FTableTopCutLine[c]
              else
                StartCellPageNo := 1;
              Result := PartNo+Result-StartCellPageNo;
              exit;
            end;
          end;
          Result := PartsList.Count-1;
          exit;
        end;
      end;
end;
{=========================== TCellPtblRVData ==================================}
function TCellPtblRVData.GetRVStyle: TRVStyle;
begin
  Result := FSourceDataForPrinting.GetRVStyle;
end;
{------------------------------------------------------------------------------}
function TCellPtblRVData.FormatNextPage(var AMaxHeight: Integer;
  var FootnoteRVDataList: TRVFootnoteRefList;
  FootnotesChangeHeight: Boolean): Boolean;
begin
  Result := not Finished;
  if Result then begin
    if Pages=nil then begin
      Pages := TRVPageCollection.Create;
      CurPageNo := 0;
    end;
    PrevPageInfo.DrawItemNo := DrawItemNo;
    PrevPageInfo.StartAt    := StartAt;
    PrevPageInfo.StartY     := StartY;
    PrevPageInfo.Y          := Y;
    PrevPageInfo.EndAt      := EndAt;
    PrevPageInfo.Splitting  := Splitting;
    PrevPageInfo.PagesCount := Pages.Count;
    inherited FormatNextPage(DrawItemNo, StartAt, StartY, Y,
      Splitting, AMaxHeight, FootnoteRVDataList, FootnotesChangeHeight);
    inc(CurPageNo);
  end;
end;
{------------------------------------------------------------------------------}
procedure TCellPtblRVData.ResetDrawItems(StartDItemNo: Integer;
  var FootnoteRVDataList: TRVFootnoteRefList; ResetAll, InHeader: Boolean;
  var ReleasedHeightAfterFootnotes: Integer;
  FootnotesChangeHeight: Boolean);
var i, EndDItemNo: Integer;
    {$IFNDEF RVDONOTUSESEQ}
    Footnote: TRVFootnoteItemInfo;
    FootnoteRefIndex: Integer;
    {$ENDIF}
begin
  if InHeader then begin
    StartDItemNo := 0;
    EndDItemNo := DrawItems.Count-1;
    end
  else begin
    EndDItemNo := DrawItemNo-1;
    if Splitting then
      inc(EndDItemNo);
    if EndDItemNo>=DrawItems.Count then
      EndDItemNo := DrawItems.Count-1;
  end;
  for i := StartDItemNo to EndDItemNo do begin
    if DrawItems[i] is TRVMultiDrawItemInfo then
      if ResetAll or (i>StartDItemNo) then
        TRVMultiDrawItemInfo(DrawItems[i]).ResetPages(FootnoteRVDataList,
          ReleasedHeightAfterFootnotes, FootnotesChangeHeight)
      else if (Splitting and (i=EndDItemNo)) then
        TRVMultiDrawItemInfo(DrawItems[i]).UnformatLastPage(FootnoteRVDataList,
          ReleasedHeightAfterFootnotes, FootnotesChangeHeight);
    {$IFNDEF RVDONOTUSESEQ}
    if (FootnoteRVDataList<>nil) and not IgnoreFootnotes and
       (GetItem(DrawItems[i].ItemNo) is TRVFootnoteItemInfo) then begin
      Footnote := TRVFootnoteItemInfo(GetItem(DrawItems[i].ItemNo));
      FootnoteRefIndex := FootnoteRVDataList.GetFootnoteIndex(Footnote);
      if FootnotesChangeHeight then
        inc(ReleasedHeightAfterFootnotes, FootnoteRVDataList[FootnoteRefIndex].DocumentHeight);
      if FootnoteRefIndex>=0 then begin
        FootnoteRVDataList.Delete(FootnoteRefIndex);
        if FootnoteRVDataList.Count=0 then begin
          FootnoteRVDataList.Free;
          FootnoteRVDataList := nil;
          if FootnotesChangeHeight then
            inc(ReleasedHeightAfterFootnotes, GetNoteSeparatorHeight);
        end;
      end;
    end;
    {$ENDIF}
  end;
end;
{------------------------------------------------------------------------------}
procedure TCellPtblRVData.UnformatLastPage(var FootnoteRVDataList: TRVFootnoteRefList;
  var ReleasedHeightAfterFootnotes: Integer;
  FootnotesChangeHeight: Boolean);
begin
  if Pages=nil then
    exit;
  if CurPageNo=1 then begin
    ResetPages(FootnoteRVDataList, ReleasedHeightAfterFootnotes,
      FootnotesChangeHeight, False);
    exit;
  end;
  ResetDrawItems(PrevPageInfo.DrawItemNo, FootnoteRVDataList, False, False,
    ReleasedHeightAfterFootnotes, FootnotesChangeHeight);
  DrawItemNo := PrevPageInfo.DrawItemNo;
  StartAt    := PrevPageInfo.StartAt;
  StartY     := PrevPageInfo.StartY;
  Y          := PrevPageInfo.Y;
  EndAt      := PrevPageInfo.EndAt;
  Splitting  := PrevPageInfo.Splitting;
  while Pages.Count>PrevPageInfo.PagesCount do
    Pages[Pages.Count-1].Free;
  dec(CurPageNo);
end;
{------------------------------------------------------------------------------}
{ Can be called if FormatPages was called only once }
procedure TCellPtblRVData.ResetPages(var FootnoteRVDataList: TRVFootnoteRefList;
  var ReleasedHeightAfterFootnotes: Integer; FootnotesChangeHeight, InHeader: Boolean);
begin
  ResetDrawItems(0, FootnoteRVDataList, True, InHeader,
    ReleasedHeightAfterFootnotes, FootnotesChangeHeight);
  Pages.Free;
  Pages := nil;
  DrawItemNo := 0;
end;
{------------------------------------------------------------------------------}
procedure TCellPtblRVData.SetEndAt(Value: Integer);
begin
  EndAt := Value;
end;
{------------------------------------------------------------------------------}
function TCellPtblRVData.Finished: Boolean;
begin
  Result := (DrawItems.Count=0) or (DrawItemNo>=DrawItems.Count);
end;
{------------------------------------------------------------------------------}
type

  TRVUndoModifyCellIntProperty = class(TRVUndoModifyItemIntProperty)
    public
      Row, Col: Integer;
      procedure Undo(RVData: TRichViewRVData); override;
      procedure SetOppositeUndoInfoProps(UndoInfo: TRVUndoModifyItemProps); override;
  end;

  TRVUndoModifyCellStrProperty = class(TRVUndoModifyItemIntProperty)
    public
      Row, Col: Integer;
      procedure Undo(RVData: TRichViewRVData); override;
      procedure SetOppositeUndoInfoProps(UndoInfo: TRVUndoModifyItemProps); override;
  end;

  TRVUndoModifyVisibleBorders = class(TRVUndoModifyItemProps)
    public
      Row, Col: Integer;
      Left, Right, Top, Bottom: Boolean;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoModifyBackgroundImage = class(TRVUndoModifyItemProps)
    public
      Row, Col: Integer;
      Image: TGraphic;
      procedure Undo(RVData: TRichViewRVData); override;
      destructor Destroy; override;
  end;

  TRVUndoModifyCellIntProperties = class(TRVUndoModifyItemIntProperties)
    public
       Row, Col: Integer;
      procedure Undo(RVData: TRichViewRVData); override;
      procedure SetOppositeUndoInfoProps(UndoInfo: TRVUndoModifyItemProps); override;
  end;

  TRVUndoRowVAlign = class(TRVUndoModifyItemProps)
    public
      Row: Integer;
      OldVAlign: TRVCellVAlign;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoInsertTableRows = class(TRVUndoModifyItemProps)
    public
      Row, Count: Integer;
      Flag: Boolean;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoInsertTableCell = class(TRVUndoModifyItemProps)
    public
      Row, Col: Integer;
      Flag: Boolean;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoSpreadOverEmptyCells = class(TRVUndoModifyItemProps)
    public
      Row, Col, ColSpan: Integer;
      Flag: Boolean;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoSpan = class(TRVUndoModifyItemProps)
    public
      IsColSpan: Boolean;
      Row, Col, OldSpan: Integer;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoFreeEmptyCell = class(TRVUndoModifyItemProps)
    public
      Flag: Boolean;
      Row, Col, ColSpan, RowSpan: Integer;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoChangeEmptyCellStyles = class(TRVUndoModifyItemProps)
    public
      Row, Col, StyleNo, ParaNo: Integer;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoInsertEmptyCell = class(TRVUndoModifyItemProps)
    public
      Flag: Boolean;
      Row, Col, ColCount, RowCount: Integer;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoCellSpitHorz = class(TRVUndoModifyItemProps)
    public
      Flag, DecreaseHeight: Boolean;
      Row, Col, Row2, OldBestHeight: Integer;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoCellSpitVert = class(TRVUndoModifyItemProps)
    public
      Flag, DecreaseWidth: Boolean;
      Row, Col, Col2: Integer;
      OldBestWidth: TRVHTMLLength;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoDeleteRows = class(TRVUndoModifyItemProps)
    public
      Flag: Boolean;
      Row, Count: Integer;
      Rows: TList;
      procedure Undo(RVData: TRichViewRVData); override;
      destructor Destroy; override;
  end;

  TCustomRVUndoWithCells  = class(TRVUndoModifyItemProps)
    public
      Flag: Boolean;
      CellsList: TList;
      destructor Destroy; override;
  end;

  TRVUndoDeleteCols = class(TCustomRVUndoWithCells)
    public
      Col, Count: Integer;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoCellsClear = class (TCustomRVUndoWithCells)
    public
      RowList, ColList: TRVIntegerList;
      procedure Undo(RVData: TRichViewRVData); override;
      destructor Destroy; override;
  end;

  TRVUndoMergeItem = class
    public
      Row,Col,ItemCount: Integer;
      Cell: TRVTableCellData;
      constructor Create(Table: TRVTableItemInfo; ARow,ACol,AVampRow,AVampCol: Integer);
  end;

  TRVUndoMerge = class(TRVUndoModifyItemProps)
    public
      Flag: Boolean;
      Row, Col, OldColSpan, OldRowSpan, NewColSpan,NewRowSpan: Integer;
      OldBestWidth: TRVHTMLLength;
      MergedItemsList: TRVList;
      procedure Undo(RVData: TRichViewRVData); override;
      destructor Destroy; override;
  end;

  TRVUndoUnmerge = class(TRVUndoModifyItemProps)
    public
      Flag, UnmergeCols, UnmergeRows: Boolean;
      Row, Col, OldColSpan, OldRowSpan, OldBestHeight: Integer;
      OldBestWidth: TRVHTMLLength;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoCellModify = class(TRVCompositeUndo)
    public
      Row,Col, CaretItemNo, CaretOffs: Integer;
      procedure Undo(RVData: TRichViewRVData); override;
      function RequiresFormattedDocBefore: Boolean; override;
  end;

  TRVUndoMultiCellsModify = class(TRVCompositeUndo)
    public
      RowList, ColList, CountList: TRVIntegerList;
      OldW: Integer;
      procedure Undo(RVData: TRichViewRVData); override;
      destructor Destroy; override;
      function RequiresFormat: Boolean; override;
      function RequiresFullReformat1(RVData: TRichViewRVData): Boolean; override;
      function RequiresFullReformat2(RVData: TRichViewRVData): Boolean; override;
  end;


function AddTableUndoInfo(RVData: TRichViewRVData; UndoInfoClass: TRVUndoInfoClass;
                             ItemNo: Integer;
                             AffectSize, AffectWidth: Boolean): TRVUndoModifyItemProps;
var List: TRVUndoList;
begin
  List := TRVEditRVData(RVData).GetUndoList;
  if List<>nil then begin
    Result := TRVUndoModifyItemProps(UndoInfoClass.Create);
    Result.Action := rvuModifyItem;
    Result.ItemNo := ItemNo;
    Result.AffectSize   := AffectSize;
    Result.AffectWidth  := AffectWidth;
    List.AddInfo(Result, TCustomRichViewEdit(RVData.RichView));
    end
  else
    Result := nil;
end;
{======================== TRVUndoModifyCellIntProperty ========================}
procedure TRVUndoModifyCellIntProperty.SetOppositeUndoInfoProps(UndoInfo: TRVUndoModifyItemProps);
begin
  if UndoInfo<>nil then begin
    (UndoInfo as TRVUndoModifyCellIntProperty).Row := Row;
    TRVUndoModifyCellIntProperty(UndoInfo).Col := Col;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoModifyCellIntProperty.Undo(RVData: TRichViewRVData);
var table: TRVTableItemInfo;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  table.Changed;
  SubObject := table.Cells[Row,Col];
  inherited Undo(RVData);
end;
{======================== TRVUndoModifyCellStrProperty ========================}
procedure TRVUndoModifyCellStrProperty.SetOppositeUndoInfoProps(UndoInfo: TRVUndoModifyItemProps);
begin
  if UndoInfo<>nil then begin
    (UndoInfo as TRVUndoModifyCellStrProperty).Row := Row;
    TRVUndoModifyCellStrProperty(UndoInfo).Col := Col;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoModifyCellStrProperty.Undo(RVData: TRichViewRVData);
var table: TRVTableItemInfo;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  table.Changed;
  SubObject := table.Cells[Row,Col];
  inherited Undo(RVData);
end;
{====================== TRVUndoModifyVisibleBorders ===========================}
procedure TRVUndoModifyVisibleBorders.Undo(RVData: TRichViewRVData);
var table: TRVTableItemInfo;
    ui: TRVUndoModifyVisibleBorders;
    VB: TRVBooleanRect;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  if (Row>=0) and (Col>=0) then begin
    SubObject := table.Cells[Row,Col];
    VB        := table.Cells[Row,Col].VisibleBorders;
    end
  else begin
    SubObject := nil;
    VB        := table.VisibleBorders;
  end;
  ui := TRVUndoModifyVisibleBorders(AddTableUndoInfo(RVData, TRVUndoModifyVisibleBorders, ItemNo, False, False));
  if ui<>nil then begin
    ui.Row    := Row;
    ui.Col    := Col;
    ui.Left   := VB.Left;
    ui.Top    := VB.Top;
    ui.Right  := VB.Right;
    ui.Bottom := VB.Bottom;
  end;
  VB.SetValues(Left, Top, Right, Bottom);
  table.Changed;
end;
{======================= TRVUndoModifyBackgroundImage =========================}
destructor TRVUndoModifyBackgroundImage.Destroy;
begin
  Image.Free;
  inherited;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoModifyBackgroundImage.Undo(RVData: TRichViewRVData);
var table: TRVTableItemInfo;
    cell: TRVTableCellData;
    ui: TRVUndoModifyBackgroundImage;
    LImage: TGraphic;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  if (Row>=0) and (Col>=0) then begin
    SubObject := table.Cells[Row,Col];
    Cell      := table.Cells[Row,Col];
    LImage     := Cell.BackgroundImage;
    end
  else begin
    Cell := nil;
    SubObject := nil;
    LImage := table.BackgroundImage;
  end;
  ui := TRVUndoModifyBackgroundImage(AddTableUndoInfo(RVData, TRVUndoModifyBackgroundImage, ItemNo, False, False));
  if ui<>nil then begin
    ui.Row    := Row;
    ui.Col    := Col;
    ui.Image  := LImage;
  end;
  if Cell=nil then
    Table.SetBackgroundImage_(Image, False)
  else
    Cell.SetBackgroundImage_(Image, False);
  Image := nil;
  table.Changed;
end;
{========================= TRVUndoRowVAlign ===================================}
procedure TRVUndoRowVAlign.Undo(RVData: TRichViewRVData);
var table: TRVTableItemInfo;
    ui: TRVUndoRowVAlign;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  ui := TRVUndoRowVAlign(AddTableUndoInfo(RVData, TRVUndoRowVAlign, ItemNo, True, False));
  if ui<>nil then begin
    ui.OldVAlign := table.Rows[Row].VAlign;
    ui.Row       := Row;
  end;
  table.Rows[Row].VAlign := OldVAlign;
  table.Changed;
end;
{=========================== TRVUndoModifyCellIntProperties ===================}
procedure TRVUndoModifyCellIntProperties.SetOppositeUndoInfoProps(
  UndoInfo: TRVUndoModifyItemProps);
begin
  if UndoInfo<>nil then begin
    (UndoInfo as TRVUndoModifyCellIntProperties).Row := Row;
    TRVUndoModifyCellIntProperties(UndoInfo).Col := Col;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoModifyCellIntProperties.Undo(RVData: TRichViewRVData);
var table: TRVTableItemInfo;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  table.Changed;
  SubObject := table.Cells[Row,Col];
  inherited Undo(RVData);
end;
{============================ TRVUndoFreeEmptyCell ============================}
procedure TRVUndoChangeEmptyCellStyles.Undo(RVData: TRichViewRVData);
var ui: TRVUndoChangeEmptyCellStyles;
    table: TRVTableItemInfo;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  ui := TRVUndoChangeEmptyCellStyles(AddTableUndoInfo(RVData, TRVUndoChangeEmptyCellStyles,
    ItemNo, True, True));
  if ui<>nil then begin
    ui.Row := Row;
    ui.Col := Col;
    ui.StyleNo := table.Cells[Row,Col].GetItemStyle(0);
    ui.ParaNo := table.Cells[Row,Col].GetItemPara(0);
  end;
  table.Cells[Row,Col].Clear;
  {$IFNDEF RVDONOTUSEUNICODE}
  table.Cells[Row,Col].AddNLATag('', StyleNo, ParaNo, 0);
  {$ELSE}
  table.Cells[Row,Col].AddNL('', StyleNo, ParaNo);
  {$ENDIF}
  table.Changed;
end;
{========================= TRVUndoInsertTableRows =============================}
procedure TRVUndoInsertTableRows.Undo(RVData: TRichViewRVData);
var ui: TRVUndoInsertTableRows;
    table: TRVTableItemInfo;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  ui := TRVUndoInsertTableRows(AddTableUndoInfo(RVData, TRVUndoInsertTableRows,
                             ItemNo, True, True));
  if ui<>nil then begin
    ui.Flag   := not Flag;
    ui.Row          := Row;
    ui.Count        := Count;
  end;
  if Flag then
    table.Rows.Do_InsertRows(Row,Count)
  else
    table.Rows.Do_UnInsertRows(Row,Count);
  table.Changed;
end;
{========================= TRVUndoInsertTableCell =============================}
procedure TRVUndoInsertTableCell.Undo(RVData: TRichViewRVData);
var ui: TRVUndoInsertTableCell;
    table: TRVTableItemInfo;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  ui := TRVUndoInsertTableCell(AddTableUndoInfo(RVData, TRVUndoInsertTableCell,
                             ItemNo, True, True));
  if ui<>nil then begin
    ui.Flag   := not Flag;
    ui.Row    := Row;
    ui.Col    := Col;
  end;
  if Flag then
    table.Rows[Row].Insert(Col)
  else
    table.Rows[Row].Delete(Col);
  table.Changed;
end;
{========================== TRVUndoSpreadOverEmptyCells =======================}
procedure TRVUndoSpreadOverEmptyCells.Undo(RVData: TRichViewRVData);
var ui: TRVUndoSpreadOverEmptyCells;
    table: TRVTableItemInfo;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  ui := TRVUndoSpreadOverEmptyCells(AddTableUndoInfo(RVData, TRVUndoSpreadOverEmptyCells,
                             ItemNo, True, True));
  if ui<>nil then begin
    ui.Flag   := not Flag;
    ui.Row          := Row;
    ui.Col          := Col;
    ui.ColSpan      := ColSpan;
  end;
  if Flag then
    table.Rows.Do_SpreadOverEmptyCells(Row,Col,ColSpan)
  else
    table.Rows.Do_UnSpreadOverEmptyCells(Row,Col,ColSpan);
  table.Changed;
end;
{=============================== TRVUndoSpan ==================================}
procedure TRVUndoSpan.Undo(RVData: TRichViewRVData);
var ui: TRVUndoSpan;
    table: TRVTableItemInfo;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  ui := TRVUndoSpan(AddTableUndoInfo(RVData, TRVUndoSpan,
                             ItemNo, True, True));
  if ui<>nil then begin
    ui.IsColSpan := IsColSpan;
    if IsColSpan then
      ui.OldSpan := table.Cells[Row,Col].ColSpan
    else
      ui.OldSpan := table.Cells[Row,Col].RowSpan;
    ui.Row          := Row;
    ui.Col          := Col;
  end;
  if IsColSpan then
    table.Cells[Row,Col].FColSpan := OldSpan
  else
    table.Cells[Row,Col].FRowSpan := OldSpan;
  table.Changed;
end;
{============================ TRVUndoFreeEmptyCell ============================}
procedure TRVUndoFreeEmptyCell.Undo(RVData: TRichViewRVData);
var ui: TRVUndoFreeEmptyCell;
    table: TRVTableItemInfo;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  ui := TRVUndoFreeEmptyCell(AddTableUndoInfo(RVData, TRVUndoFreeEmptyCell,
                             ItemNo, True, True));
  if ui<>nil then begin
    ui.Flag         := not Flag;
    ui.Row          := Row;
    ui.Col          := Col;
    ui.ColSpan      := ColSpan;
    ui.RowSpan      := RowSpan;
  end;
  if Flag then
    table.Rows.Do_FreeEmptyCells(Row,Col,ColSpan,RowSpan)
  else
    table.Rows.Do_UnFreeEmptyCells(Row,Col,ColSpan,RowSpan);
  table.Changed;
end;
{========================== TRVUndoInsertEmptyCell ============================}
procedure TRVUndoInsertEmptyCell.Undo(RVData: TRichViewRVData);
var ui: TRVUndoInsertEmptyCell;
    table: TRVTableItemInfo;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  ui := TRVUndoInsertEmptyCell(AddTableUndoInfo(RVData, TRVUndoInsertEmptyCell,
                             ItemNo, True, True));
  if ui<>nil then begin
    ui.Flag         := not Flag;
    ui.Row          := Row;
    ui.Col          := Col;
    ui.ColCount     := ColCount;
    ui.RowCount     := RowCount;
  end;
  if Flag then
    table.Rows.Do_InsertEmptyCells(Row,Col,ColCount,RowCount)
  else
    table.Rows.Do_UnInsertEmptyCells(Row,Col,ColCount,RowCount);
  table.Changed;
end;
{============================ TRVUndoCellSpitHorz =============================}
procedure TRVUndoCellSpitHorz.Undo(RVData: TRichViewRVData);
var ui: TRVUndoCellSpitHorz;
    table: TRVTableItemInfo;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  ui := TRVUndoCellSpitHorz(AddTableUndoInfo(RVData, TRVUndoCellSpitHorz,
                             ItemNo, True, False));
  if ui<>nil then begin
    ui.Flag         := not Flag;
    ui.Row          := Row;
    ui.Col          := Col;
    ui.Row2         := Row2;
    ui.OldBestHeight := OldBestHeight;
    ui.DecreaseHeight := DecreaseHeight;
  end;
  if Flag then
    table.Rows.Do_SplitCellHorz(Row,Col,Row2,DecreaseHeight)
  else
    table.Rows.Do_UnSplitCellHorz(Row,Col,Row2,OldBestHeight);
  table.Changed;
end;
{============================== TRVUndoCellSpitVert ===========================}
procedure TRVUndoCellSpitVert.Undo(RVData: TRichViewRVData);
var ui: TRVUndoCellSpitVert;
    table: TRVTableItemInfo;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  ui := TRVUndoCellSpitVert(AddTableUndoInfo(RVData, TRVUndoCellSpitVert,
                             ItemNo, True, True));
  if ui<>nil then begin
    ui.Flag         := not Flag;
    ui.Row          := Row;
    ui.Col          := Col;
    ui.Col2         := Col2;
    ui.OldBestWidth := OldBestWidth;
    ui.DecreaseWidth := DecreaseWidth;
  end;
  if Flag then
    table.Rows.Do_SplitCellVert(Row,Col,Col2,DecreaseWidth)
  else
    table.Rows.Do_UnSplitCellVert(Row,Col,Col2,OldBestWidth);
  table.Changed;
end;
{============================== TRVUndoDeleteRows =============================}
procedure TRVUndoDeleteRows.Undo(RVData: TRichViewRVData);
var ui: TRVUndoDeleteRows;
    table: TRVTableItemInfo;
    i: Integer;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  ui := TRVUndoDeleteRows(AddTableUndoInfo(RVData, TRVUndoDeleteRows,
                             ItemNo, True, True));
  if ui<>nil then begin
    ui.Flag         := not Flag;
    ui.Row          := Row;
    ui.Count        := Count;
    if Flag then begin
      ui.Rows := TList.Create;
      for i := 0 to Count-1 do
        ui.Rows.Add(table.Rows[Row+i]);
    end;
  end;
  if Flag then
    table.Rows.Do_DeleteRows(ItemNo, Row,Count,ui)
  else
    table.Rows.Do_UnDeleteRows(Row, Rows);
  table.Changed;
end;
{------------------------------------------------------------------------------}
destructor TRVUndoDeleteRows.Destroy;
var i: Integer;
begin
  if Rows<>nil then begin
    for i := 0 to Rows.Count-1 do
      TObject(Rows[i]).Free;
    Rows.Free;
  end;
  inherited Destroy;
end;
{================================= TCustomRVUndoWithCells =====================}
destructor TCustomRVUndoWithCells.Destroy;
var i: Integer;
begin
  if CellsList<>nil then begin
    for i := 0 to CellsList.Count-1 do
      TObject(CellsList[i]).Free;
    CellsList.Free;
  end;
  inherited Destroy;
end;
{=========================== TRVUndoDeleteCols ================================}
procedure TRVUndoDeleteCols.Undo(RVData: TRichViewRVData);
var ui: TRVUndoDeleteCols;
    table: TRVTableItemInfo;
    r,c: Integer;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  ui := TRVUndoDeleteCols(AddTableUndoInfo(RVData, TRVUndoDeleteCols,
                             ItemNo, True, True));
  if ui<>nil then begin
    ui.Flag         := not Flag;
    ui.Col          := Col;
    ui.Count        := Count;
    if Flag then begin
      ui.CellsList := TList.Create;
      for r := 0 to table.RowCount-1 do
        for c := Count-1 downto 0 do
          ui.CellsList.Add(table.Cells[r,Col+c]);
    end;
  end;
  if Flag then
    table.Rows.Do_DeleteCols(ItemNo, Col,Count, ui)
  else
    table.Rows.Do_UnDeleteCols(Col, CellsList);
  table.Changed;
end;
{================================= TRVUndoCellsClear ==========================}
destructor TRVUndoCellsClear.Destroy;
begin
  RowList.Free;
  ColList.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoCellsClear.Undo(RVData: TRichViewRVData);
var ui: TRVUndoCellsClear;
    table: TRVTableItemInfo;
    NewCellsList: TList;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  NewCellsList := nil;
  ui := TRVUndoCellsClear(AddTableUndoInfo(RVData, TRVUndoCellsClear,
                             ItemNo, True, True));
  if ui<>nil then begin
    ui.Flag         := not Flag;
    ui.RowList      := TRVIntegerList.CreateCopy(RowList);
    ui.ColList      := TRVIntegerList.CreateCopy(ColList);
    if Flag then begin
      ui.CellsList := TList.Create;
      NewCellsList := ui.CellsList;
    end;
  end;
  if Flag then
    table.Rows.Do_ClearCells(NewCellsList, RowList, ColList, ui)
  else
    table.Rows.Do_UnClearCells(CellsList, RowList, ColList);
  table.Changed;
end;
{=============================== TRVUndoMergeItem =============================}
constructor TRVUndoMergeItem.Create(Table: TRVTableItemInfo; ARow, ACol,
  AVampRow, AVampCol: Integer);
begin
  inherited Create;
  Row := ARow;
  Col := ACol;
  Cell := Table.Cells[Row,Col];
  if Cell.HasData(False) then
    ItemCount := Cell.Items.Count
  else
    ItemCount := 0;
end;
{============================== TRVUndoMerge ==================================}
procedure TRVUndoMerge.Undo(RVData: TRichViewRVData);
var ui: TRVUndoMerge;
    table: TRVTableItemInfo;
    r,c: Integer;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  ui := TRVUndoMerge(AddTableUndoInfo(RVData, TRVUndoMerge,
                             ItemNo, True, True));
  if ui<>nil then begin
    ui.Flag         := not Flag;
    ui.Row          := Row;
    ui.Col          := Col;
    ui.OldColSpan   := OldColSpan;
    ui.OldRowSpan   := OldRowSpan;
    ui.NewColSpan   := NewColSpan;
    ui.NewRowSpan   := NewRowSpan;
    ui.OldBestWidth := OldBestWidth;
    if Flag then begin
      ui.MergedItemsList := TRVList.Create;
      for r := Row to Row+NewRowSpan-1 do
        for c := Col to Col+NewColSpan-1 do
          if (table.Cells[r,c]<>nil) and
             (table.Cells[r,c]<>table.Cells[Row,Col]) then
          ui.MergedItemsList.Add(TRVUndoMergeItem.Create(table,r,c,Row,Col));
    end;
  end;
  if Flag then
    table.Rows.Do_MergeCells(ItemNo, Row,Col, NewColSpan, NewRowSpan, ui, True)
  else
    table.Rows.Do_UndoMergeCells(ItemNo, Row,Col, OldColSpan, OldRowSpan, MergedItemsList,OldBestWidth);
  table.Changed;
end;
{------------------------------------------------------------------------------}
destructor TRVUndoMerge.Destroy;
var i: Integer;
begin
  if MergedItemsList<>nil then begin
    for i := 0 to MergedItemsList.Count-1 do
      TRVUndoMergeItem(MergedItemsList[i]).Cell.Free;
    MergedItemsList.Free;
  end;
  inherited Destroy;
end;
{================================ TRVUndoUnmerge ==============================}
procedure TRVUndoUnmerge.Undo(RVData: TRichViewRVData);
var ui: TRVUndoUnmerge;
    table: TRVTableItemInfo;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  ui := TRVUndoUnmerge(AddTableUndoInfo(RVData, TRVUndoUnmerge,
                             ItemNo, True, True));
  if ui<>nil then begin
    ui.Flag         := not Flag;
    ui.Row          := Row;
    ui.Col          := Col;
    ui.OldColSpan   := OldColSpan;
    ui.OldRowSpan   := OldRowSpan;
    ui.UnmergeCols  := UnmergeCols;
    ui.UnmergeRows  := UnmergeRows;
    ui.OldBestWidth  := OldBestWidth;
    ui.OldBestHeight := OldBestHeight;
  end;
  if Flag then
    table.Rows.Do_UnmergeCell(ItemNo, Row,Col, UnmergeRows, UnmergeCols)
  else
    table.Rows.Do_UndoUnmergeCell(ItemNo, Row,Col, OldColSpan, OldRowSpan,
                              OldBestWidth, OldBestHeight);
  table.Changed;
end;
{============================= TRVUndoCellModify ==============================}
procedure TRVUndoCellModify.Undo(RVData: TRichViewRVData);
var
  table: TRVTableItemInfo;
  ERow,ECol,i: Integer;
  List: TRVUndoList;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  table.GetEditedCell(ERow,ECol);
  if (ERow<>Row) or (ECol<>Col) then
    table.EditCell_(Row,Col,True);
  if IsRedo then
    List := TRVEditRVData(table.FInplaceEditor.RVData).RedoList
  else
    List := TRVEditRVData(table.FInplaceEditor.RVData).UndoList;
  for i := 0 to UndoList.Count-1 do begin
    List.AddInfos(TObject(UndoList.Items[i]) as TRVUndoInfos, table.FInplaceEditor);
  end;
  for i := UndoList.Count-1 downto 0 do
    UndoList.DeleteAsPointer(i);
  table.FInplaceEditor.SetSelectionBounds(CaretItemNo, CaretOffs,CaretItemNo, CaretOffs);
  table.FInplaceEditor.SetFReadOnly(True);
  if IsRedo then
    PostMessage(table.FInplaceEditor.Handle, WM_RVINPLACEREDO,0,0)
  else
    PostMessage(table.FInplaceEditor.Handle, WM_RVINPLACEUNDO,0,0)
end;
{------------------------------------------------------------------------------}
function TRVUndoCellModify.RequiresFormattedDocBefore: Boolean;
begin
  Result := True;
end;
{========================== TRVUndoMultiCellsModify ===========================}
destructor TRVUndoMultiCellsModify.Destroy;
begin
  RowList.Free;
  ColList.Free;
  CountList.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
function TRVUndoMultiCellsModify.RequiresFormat: Boolean;
begin
  Result := True;
end;
{------------------------------------------------------------------------------}
function TRVUndoMultiCellsModify.RequiresFullReformat1(
  RVData: TRichViewRVData): Boolean;
begin
  OldW := RVData.CalculateMinItemWidthPlusEx(ItemNo);
  Result := OldW >= RVData.DocumentWidth;
end;
{------------------------------------------------------------------------------}
function TRVUndoMultiCellsModify.RequiresFullReformat2(
  RVData: TRichViewRVData): Boolean;
var NewW: Integer;
begin
  NewW := RVData.CalculateMinItemWidthPlusEx(ItemNo);
  Result :=  (NewW<>OldW) and (NewW>RVData.DocumentWidth);
end;
{------------------------------------------------------------------------------}
procedure TRVUndoMultiCellsModify.Undo(RVData: TRichViewRVData);
var ui: TRVUndoMultiCellsModify;
    table: TRVTableItemInfo;
    Editor: TCustomRichViewEdit;
    i: Integer;
begin
  table := RVData.GetItem(ItemNo) as TRVTableItemInfo;
  ui := TRVUndoMultiCellsModify(AddTableUndoInfo(RVData, TRVUndoMultiCellsModify,
                             ItemNo, True, True));
  if ui<>nil then begin
    ui.IsRedo       := not IsRedo;
    ui.RowList      := TRVIntegerList.Create;
    ui.ColList      := TRVIntegerList.Create;
    ui.CountList    := TRVIntegerList.Create;
    ui.UndoList     := TRVUndoList.Create(GetUndoListOwnerRVData);
  end;
  Editor := table.CreateTemporalEditor;
  try
    while UndoList.Count>0 do begin
      Editor.RVData.Clear;
      Editor.RVData.DrainFrom(table.Cells[RowList[0],ColList[0]]);
      Editor.Format;
      Editor.SelectAll;
      for i := 0 to CountList[0]-1 do begin
        TRVEditRVData(Editor.RVData).UndoList.AddInfos(TObject(UndoList.Items[0]) as TRVUndoInfos, Editor);
        UndoList.DeleteAsPointer(0);
      end;
      Editor.RVData.State := Editor.RVData.State + [rvstSkipFormatting];
      Editor.Undo;
      Editor.RVData.State := Editor.RVData.State - [rvstSkipFormatting];
      if ui<>nil then begin
        ui.RowList.Add(RowList[0]);
        ui.ColList.Add(ColList[0]);
        ui.CountList.Add(TRVEditRVData(Editor.RVData).RedoList.Count);
        for i := 0 to TRVEditRVData(Editor.RVData).RedoList.Count-1 do
          ui.UndoList.AddInfos(TObject(TRVEditRVData(Editor.RVData).RedoList.Items[i]) as TRVUndoInfos, nil);
        for i := TRVEditRVData(Editor.RVData).RedoList.Count-1 downto 0 do
          TRVEditRVData(Editor.RVData).RedoList.DeleteAsPointer(i);
      end;
      table.Cells[RowList[0],ColList[0]].DrainFrom(Editor.RVData);
      RowList.Delete(0);
      ColList.Delete(0);
      CountList.Delete(0);
    end;
  finally
    Editor.Free;
  end;
  table.Changed;
end;
{========================== TRVTableCellData ==================================}
constructor TRVTableCellData.Create(ARow: TRVTableRow);
begin
  inherited Create(ARow);
  FVisibleBorders := TRVBooleanRect.Create(True);
  FColSpan := 1;
  FRowSpan := 1;
  FColor            := clNone;
  FBorderColor      := clNone;
  FBorderLightColor := clNone;
  FValign  := rvcVDefault;
  State    := [];
  {$IFNDEF RVDONOTUSEUNICODE}
  AddNLATag('',0,0,0);
  {$ELSE}
  AddNL('',0,0);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
destructor TRVTableCellData.Destroy;
begin
  FVisibleBorders.Free;
  FBackground.Free;
  FBackground := nil;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.Edit: TCustomRVData;
var table: TRVTableItemInfo;
    Row,Col: Integer;
begin
  Result := GetRVData;
  if Result<>Self then
    exit;
  table := GetTable;
  table.GetCellPosition(Self,Row,Col);
  table.EditCell(Row,Col);
  Result := GetRVData;
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.GetTable: TRVTableItemInfo;
begin
  if (ContainerUndoItem<>nil) or (FList=nil) or (TRVTableRow(FList).FRows=nil) then
    Result := nil
  else
    Result := TRVTableRow(FList).FRows.FTable;
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.GetParentInfo(var ParentItemNo: Integer;
                                     var Location: TRVStoreSubRVData);
var r,c: Integer;
    table: TRVTableItemInfo;
begin
  table := GetTable;
  table.GetCellPosition(Self, r, c);
  Location := TRVTableStoreSubRVData.Create(r,c);
  ParentItemNo := table.GetMyItemNo;
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.GetItemHint(RVData: TCustomRVData; ItemNo: Integer;
  const UpperRVDataHint: String): String;
begin
  Result := GetAbsoluteParentData.GetItemHint(RVData, ItemNo,
    {$IFNDEF RVDONOTUSEITEMHINTS}Hint{$ELSE}UpperRVDataHint{$ENDIF});
  if Result='' then
    Result := {$IFNDEF RVDONOTUSEITEMHINTS}Hint{$ELSE}UpperRVDataHint{$ENDIF};
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.IsTransparent: Boolean;
begin
  Result := (Color=clNone);
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.SetBestHeight(const Value: TRVStyleLength);
begin
  FBestHeight := Value;
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.SetBestWidth(const Value: TRVHTMLLength);
begin
  FBestWidth := Value;
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.SetColor(const Value: TColor);
var table: TRVTableItemInfo;
begin
  FColor := Value;
  table := GetTable;
  if table=nil then exit;
  if (table.FInplaceEditor<>nil) and (TRVTableInplaceEdit(table.FInplaceEditor).FCell=Self) then begin
    table.FInplaceEditor.Color := table.GetCellColor(Self);
    TRVTableInplaceEdit(table.FInplaceEditor).Transparent := table.CanSeeBackgroundThroughCell(Self);
  end;
  {$IFNDEF RVDONOTUSEANIMATION}
  if table.Rows.FMainRVData is TCustomRVFormattedData then
    TCustomRVFormattedData(table.Rows.FMainRVData).ResetAniBackground;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.GetBackgroundImage: TGraphic;
begin
  if FBackground<>nil then
    Result := FBackground.Image
  else
    Result := nil;
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.GetBackgroundStyle: TRVItemBackgroundStyle;
begin
  if FBackground<>nil then
    Result := FBackground.ItemBackStyle
  else
    Result := rvbsColor;
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.SetBackgroundImage_(const Value: TGraphic; Copy: Boolean);
var table: TRVTableItemInfo;
begin
  table := GetTable;
  if Value=BackgroundImage then
    exit;
  if (FBackground=nil) and (Value<>nil) and not Value.Empty then
    FBackground := TRVBackground.Create(False);
  if FBackground<>nil then begin
    FBackground.AssignImage(Value, table.Rows.FMainRVData, Copy);
    if FBackground.Empty then begin
      FBackground.Free;
      FBackground := nil;
    end
  end;
  if (table.FInplaceEditor<>nil) and (TRVTableInplaceEdit(table.FInplaceEditor).FCell=Self) then
    table.FInplaceEditor.Invalidate;
  {$IFNDEF RVDONOTUSEANIMATION}
  if table.Rows.FMainRVData is TCustomRVFormattedData then
    TCustomRVFormattedData(table.Rows.FMainRVData).ResetAniBackground;
  {$ENDIF}    
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.SetBackgroundImage(const Value: TGraphic);
begin
  SetBackgroundImage_(Value, True);
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.SetBackgroundStyle(
  const Value: TRVItemBackgroundStyle);
var table: TRVTableItemInfo;  
begin
  if Value=BackgroundStyle then
    exit;
  if (FBackground=nil) and (Value<>rvbsColor) then
    FBackground := TRVBackground.Create(False);
  if FBackground<>nil then begin
    FBackground.ItemBackStyle := Value;
    if FBackground.Empty then begin
      FBackground.Free;
      FBackground := nil;
    end
  end;
  table := GetTable;
  if (table.FInplaceEditor<>nil) and (TRVTableInplaceEdit(table.FInplaceEditor).FCell=Self) then
    table.FInplaceEditor.Invalidate;
  {$IFNDEF RVDONOTUSEANIMATION}
  if table.Rows.FMainRVData is TCustomRVFormattedData then
    TCustomRVFormattedData(table.Rows.FMainRVData).ResetAniBackground;
  {$ENDIF}    
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.BackgroundImageReader(Stream: TStream);
var s: TRVAnsiString;
    v: Integer;
    gr: TGraphic;
    GraphicClassName: String;
begin
  if Stream.Size=Stream.Position then
    exit;
  Stream.ReadBuffer(v, sizeof(v));
  SetLength(s, v);
  Stream.ReadBuffer(PRVAnsiChar(s)^, v);
  {$IFDEF RVUNICODESTR}
  GraphicClassName := String(s);
  {$ELSE}
  GraphicClassName := s;
  {$ENDIF}
  gr := RV_CreateGraphics(TGraphicClass(GetClass(GraphicClassName)));
  RVFLoadPictureBinary2(Stream, gr);
  BackgroundImage := gr;
  gr.Free;
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.BackgroundImageWriter(Stream: TStream);
var s: TRVAnsiString;
    v: Integer;
begin
  s := TRVAnsiString(FBackground.Image.ClassName);
  v := Length(s);
  Stream.WriteBuffer(v, sizeof(v));
  Stream.WriteBuffer(PRVAnsiChar(s)^, v);
  RVFSavePictureBinary(Stream, FBackground.Image);
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.GetBackground: TRVBackground;
begin
  Result := FBackground;
end;
{------------------------------------------------------------------------------}
type
  TBackgroundKind =
    (bckTransparent, bckColor, bckImage, bckSemitransparent);
procedure TRVTableCellData.GetItemBackground(ItemNo: Integer; r: TRect;
  MakeImageRect: Boolean; var Color: TColor; var bmp: TBitmap;
  var UseBitmap: Boolean; GraphicInterface: TRVGraphicInterface);
var item: TRVRectItemInfo;
    ditem: TRVDrawLineInfo;
    table: TRVTableItemInfo;
    ParentRect: TRect;
    CellBK, TableBK: TBackgroundKind;
    ParaColor: TColor;
    TableX, TableY: Integer;
    CHP, CVP, CellVPaddingPix, CellHPaddingPix, BorderWidthPix, BorderHeightPix: Integer;
    RVStyle: TRVStyle;

    procedure MakeBitmap;
    begin
      UseBitmap := True;
      if bmp=nil then
        bmp := TBitmap.Create;
      bmp.Width := r.Right-r.Left;
      bmp.Height := r.Bottom-r.Top;
      bmp.Canvas.Brush.Style := bsSolid;
      if Color<>clNone then begin
        bmp.Canvas.Brush.Color := Color;
        GraphicInterface.FillRect(bmp.Canvas, Rect(0,0,bmp.Width,bmp.Height));
      end;
    end;

begin
  UseBitmap := False;
  Color := GetRVStyle.ParaStyles[GetRVData.GetItemPara(ItemNo)].Background.Color;
  if Color<>clNone then
    exit;
  table := GetTable;
  if (rvstCompletelySelected in State) or table.CompletelySelected then begin
    Color := GetRVStyle.SelColor;
    if Color<>clNone then
      exit;
  end;
  RVStyle := GetRVStyle;
  Color := Self.Color;
  item := TRVRectItemInfo(GetRVData.GetItem(ItemNo));
  ditem := TCustomRVFormattedData(GetRVData).DrawItems[item.DrawItemNo];
  CellVPaddingPix := RVStyle.GetAsPixels(table.CellVPadding);
  CellHPaddingPix := RVStyle.GetAsPixels(table.CellHPadding);
  BorderWidthPix  := RVStyle.GetAsPixels(item.GetBorderWidth);
  BorderHeightPix := RVStyle.GetAsPixels(item.GetBorderHeight);

  if GetRVData=Self then begin
    CHP := CellHPaddingPix;
    CVP := CellVPaddingPix;
    end
  else begin
    CHP := 0;
    CVP := 0;
  end;
  if MakeImageRect then
    r := Bounds(
      ditem.Left+BorderWidthPix+CHP, ditem.Top+BorderHeightPix+CVP,
      item.GetImageWidth(RVStyle), item.GetImageHeight(RVStyle));
  if BackgroundStyle=rvbsColor then
    if Color=clNone then
      CellBK := bckTransparent
    else
      CellBk := bckColor
  else
    if (Color=clNone) and FBackground.IsSemitransparent then
      CellBk := bckSemitransparent
    else
      CellBk := bckImage;
  case CellBk of
    bckColor:
      exit;
    bckImage:
      begin
        MakeBitmap;
        FBackground.Draw(bmp.Canvas, r, 0, 0, 0, 0, Width, Height, Color, False,
          False, GraphicInterface);
        exit;
      end;
  end;
  ParaColor := table.FRows.FMainRVData.GetRVStyle.ParaStyles[
   table.FRows.FMainRVData.GetItemPara(table.GetMyItemNo)
   ].Background.Color;
  if table.BackgroundStyle=rvbsColor then
    if (table.Color=clNone) and (ParaColor=clNone) then
      TableBK := bckTransparent
    else
      TableBk := bckColor
  else
    if (table.Color=clNone) and (ParaColor=clNone) and table.FBackground.IsSemitransparent then
      TableBk := bckSemitransparent
    else
      TableBk := bckImage;
  case TableBk of
    bckColor:
      begin
        Color := table.Color;
        if Color=clNone then
          Color := ParaColor;
        if CellBk=bckTransparent then
          exit;
        MakeBitmap;
        FBackground.Draw(bmp.Canvas, r, 0, 0, 0, 0, Width, Height, Color, False,
          False, GraphicInterface);
        exit;
      end;
    bckImage:
      begin
        Color := table.Color;
        if Color=clNone then
          Color := ParaColor;
        MakeBitmap;
        table.FBackground.Draw(bmp.Canvas, r, 0, 0, -Left, -Top,
          table.GetWidth(GetRVStyle), table.GetHeight(GetRVStyle),
          Color, False, False, GraphicInterface);
        if CellBk<>bckTransparent then
          FBackground.Draw(bmp.Canvas, r, 0, 0, 0, 0, Width, Height, clNone,
            False, False, GraphicInterface);
        exit;
      end;
  end;
  TCustomRVFormattedData(table.Rows.FMainRVData).GetItemCoords(table.GetMyItemNo,
    TableX, TableY);
    ParentRect := Bounds(
      TableX+Left + CellHPaddingPix+BorderWidthPix  + ditem.Left,
      TableY+Top  + CellVPaddingPix+BorderHeightPix + ditem.Top,
      r.Right-r.Left, r.Bottom-r.Top);
  TCustomRVFormattedData(table.Rows.FMainRVData).GetItemBackground(
    table.GetMyItemNo, ParentRect, False, Color, bmp, UseBitmap, GraphicInterface);
  if TableBk=bckSemitransparent then begin
    if not UseBitmap then
      MakeBitmap;
    table.FBackground.Draw(bmp.Canvas, r, 0, 0, -Left, -Top,
      table.GetWidth(GetRVStyle), table.GetHeight(GetRVStyle),
      table.Color, False, False, GraphicInterface);
  end;
  if CellBk=bckSemitransparent then begin
    if not UseBitmap then
      MakeBitmap;
    FBackground.Draw(bmp.Canvas, r, 0, 0, 0, 0, Width, Height, clNone, False,
      False, GraphicInterface);
  end;
end;
{------------------------------------------------------------------------------}
// Returns the cell content height, in screen pixels.
// This function cannot be called to calculate sizes for printing
function TRVTableCellData.GetCellHeight(IgnoreContentHeight: Boolean): Integer;
begin
  if (BestHeight=0) or not IgnoreContentHeight then begin
    if (TRVTableRow(FList).FRows.FTable.FInplaceEditor<>nil) and
       (TRVTableInplaceEdit(TRVTableRow(FList).FRows.FTable.FInplaceEditor).FCell=Self) then begin
      Result := TRVTableRow(FList).FRows.FTable.FInplaceEditor.DocumentHeight-
        GetRVStyle.GetAsPixels(TRVTableRow(FList).FRows.FTable.CellVPadding)*2;
      end
    else
      Result := DocumentHeight;
    end
  else
    Result := 0;
  if (BestHeight>0) and (GetRVStyle.GetAsPixels(BestHeight)>Result) then
    Result := GetRVStyle.GetAsPixels(BestHeight);
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.GetMinWidth(sad: PRVScreenAndDevice; Canvas: TCanvas): Integer;
var ARVData: TCustomRVData;
begin
  ARVData := GetRVData;
  if (ARVData.Items.Count=0) then begin
    Result := 0;
    exit;
  end;
  if ((ARVData.Items.Count=1) and (ARVData.GetItemStyle(0)>=0) and (ARVData.Items[0]='')) then begin
    with GetRVStyle.ParaStyles[ARVData.GetItemPara(0)] do
      Result :=
        GetRVStyle.GetAsDevicePixelsX(LeftIndent, sad)+
        GetRVStyle.GetAsDevicePixelsX(RightIndent, sad)+
        GetRVStyle.GetAsDevicePixelsX(FirstIndent, sad);
    exit;
  end;
  if (TRVTableRow(FList).FRows.FTable.FInplaceEditor<>nil) and
     (TRVTableInplaceEdit(TRVTableRow(FList).FRows.FTable.FInplaceEditor).FCell=Self) then
    Result := TRVTableRow(FList).FRows.FTable.FInplaceEditor.RVData.CalculateMinDocWidthPlus(0,sad, Canvas)
  else begin
    Result := CalculateMinDocWidthPlus(0, sad, Canvas);
    if Result=0 then
      Result := 10; // temporal;
  end;
end;
{------------------------------------------------------------------------------}
{
function TRVTableCellData.GetWidthInFixedTable(TableWidth: Integer): Integer;
begin
  if BestWidth>0 then
    Result := BestWidth
  else if BestWidth<0 then
    Result := -TableWidth*BestWidth div 100
  else
    Result := GetMinWidth;
end;
}
{------------------------------------------------------------------------------}
function TRVTableCellData.GetHeight: Integer;
begin
  Result := Height-GetRVStyle.GetAsPixels(GetTable.CellVPadding)*2;
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.GetWidth: Integer;
begin
  Result := Width-GetRVStyle.GetAsPixels(GetTable.CellHPadding)*2;
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.GetAreaWidth: Integer;
begin
  Result := GetWidth;
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.GetColor: TColor;
begin
  Result := GetTable.GetCellColor(Self); // Result := clNone;
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.AssignChosenRVData(RVData: TCustomRVFormattedData;
                                              Item: TCustomRVItemInfo);
var r,c: Integer;
begin
  GetTable.GetCellPosition(Self,r,c);
  GetTable.ChooseSubRVData_(r,c);
  inherited;
  {
  with GetTable do
    if not FInserted or FEditMode then
      exit;
  }
  if FChosenRVData<>RVData then
    UnassignChosenRVData(FChosenRVData);
  FChosenRVData := RVData;
  FChosenItem   := Item;
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.UnassignChosenRVData(RVData: TCustomRVData);
begin
  inherited;
  if rvstUnAssigningChosen in State then
    exit;
  State := State+[rvstUnAssigningChosen];
  if GetRVData is TCustomRVFormattedData then
    TCustomRVFormattedData(GetRVData).State := State + [rvstUnAssigningChosen];
  try
    {
    with GetTable do
      if not FInserted or FEditMode then
        exit;
    }
    if (RVData=FChosenRVData) or
       ((FChosenRVData<>nil) and (TCustomRVData(FChosenRVData).GetRVData=RVData)) then begin
      if FChosenRVData<>nil then
        TCustomRVFormattedData(FChosenRVData.GetRVData).Deselect(nil,False);
       FChosenRVData := nil;
       if FChosenItem<>nil then
         FChosenItem.CleanUpChosen;
       FChosenItem   := nil;
    end;
  finally
    if GetRVData is TCustomRVFormattedData then
      TCustomRVFormattedData(GetRVData).State := State-[rvstUnAssigningChosen];
    State := State-[rvstUnAssigningChosen];
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.GetChosenRVData: TCustomRVData;
begin
  Result := FChosenRVData;
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.GetChosenItem: TCustomRVItemInfo;
begin
  Result := FChosenItem;
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.GetHOffs: Integer;
var table: TRVTableItemInfo;
begin
  table := GetTable;
  Result := - (table.MyClientLeft +
    GetRVStyle.GetAsPixels(table.CellHPadding) +
    Left);
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.GetVOffs: Integer;
var table: TRVTableItemInfo;
begin
  table := GetTable;
  Result := - (table.MyClientTop +
    GetRVStyle.GetAsPixels(table.CellVPadding) +
    GetExtraVOffs + Top);
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.GetEditor: TWinControl;
begin
  Result := TRVTableRow(FList).FRows.FTable.FInplaceEditor;
  if (Result<>nil) and
     (TRVTableInplaceEdit(Result).FCell<>Self) then
    Result := nil;
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.Deselect(
  NewPartiallySelected: TCustomRVItemInfo; MakeEvent: Boolean);
var table: TRVTableItemInfo;
begin
  inherited;
  if ContainerUndoItem<>nil then
    exit;
  if rvstDeselecting in State then
    exit;
  State := State + [rvstDeselecting];
  if GetRVData is TCustomRVFormattedData then
    TCustomRVFormattedData(GetRVData).State := TCustomRVFormattedData(GetRVData).State + [rvstDeselecting];
  try
    table := GetTable;
    if (NewPartiallySelected=nil) and (table<>nil) and (table.FRows.FMainRVData is TCustomRVFormattedData) then
      TCustomRVFormattedData(table.FRows.FMainRVData).UnassignChosenRVData(Self);
  finally
    if GetRVData is TCustomRVFormattedData then
      TCustomRVFormattedData(GetRVData).State := TCustomRVFormattedData(GetRVData).State - [rvstDeselecting];
    State := State - [rvstDeselecting];
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.ResetSubCoords;
begin
  inherited;
  TCustomRVFormattedData(GetParentData).ResetSubCoords;
  GetTable.ResetSubCoords;
end;
{------------------------------------------------------------------------------}
{ Coordinates of the top left corner of this RVData relative to the closest
  parent RichView (root one or inplace editor)                                 }
procedure TRVTableCellData.GetOrigin(var ALeft, ATop: Integer);
var table: TRVTableItemInfo;
    x,y: Integer;
begin
  table := GetTable;
  TCustomRVFormattedData(table.FRows.FMainRVData).GetOrigin(x,y);
  TCustomRVFormattedData(table.FRows.FMainRVData).GetItemCoords(table.GetMyItemNo, ALeft, ATop);
  inc(ALeft, x + FLeft+ GetRVStyle.GetAsPixels(table.CellHPadding));
  inc(ATop,  y + FTop + GetRVStyle.GetAsPixels(table.CellVPadding));
  inc(ATop,GetExtraVOffs);
end;
{------------------------------------------------------------------------------}
{ Coordinates of the top left corner of this RVData relative to the root
  parent RichView                                                              }
procedure TRVTableCellData.GetOriginEx(var ALeft, ATop: Integer);
var table: TRVTableItemInfo;
    x,y: Integer;
begin
  table := GetTable;
  TCustomRVFormattedData(table.FRows.FMainRVData).GetOriginEx(x,y);
  TCustomRVFormattedData(table.FRows.FMainRVData).GetItemCoords(table.GetMyItemNo, ALeft, ATop);
  inc(ALeft, x + FLeft + GetRVStyle.GetAsPixels(table.CellHPadding));
  inc(ATop,  y + FTop  + GetRVStyle.GetAsPixels(table.CellVPadding));
  inc(ATop,GetExtraVOffs);
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.MovingToUndoList(AContainerUndoItem: TRVUndoInfo);
var i: Integer;
begin
  {$IFNDEF RVDONOTUSELIVESPELL}
  TCustomRichView(TRichViewRVData(GetAbsoluteRootData).RichView).RemoveRVDataFromLiveSpelling(Self);
  {$ENDIF}
  for i := 0 to Items.Count-1 do
    GetItem(i).MovingToUndoList(i,Self,AContainerUndoItem);
  ContainerUndoItem := AContainerUndoItem;
  FList := nil;    
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.MovingFromUndoList;
var i: Integer;
begin
  ContainerUndoItem := nil;
  for i := 0 to Items.Count-1 do
    GetItem(i).MovingFromUndoList(i,Self);
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.SetVisibleBorders(const Value: TRVBooleanRect);
begin
  FVisibleBorders.Assign(Value);
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.StoreVisibleBorders: Boolean;
begin
  Result := not FVisibleBorders.IsAllEqual(True);
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.HasData(CheckStyles: Boolean): Boolean;
begin
  with GetRVData do
    Result :=
       (Items.Count>1) or
      (
        (Items.Count=1) and
        not
        (
         (GetItemCheckpoint(0)=nil) and
         (
           (CheckStyles and (GetItemStyle(0)=0) and (GetItemPara(0)=0) and (Items[0]='')) or
           (not CheckStyles and (GetItemStyle(0)>=0) and (Items[0]=''))
         )
        )
      )
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineBinaryProperty( 'Data', DataReader, DataWriter,
    not (rvstDoNotSaveContent in State) and HasData(True));
  Filer.DefineBinaryProperty('BackgroundImg', BackgroundImageReader, BackgroundImageWriter,
    not (rvstDoNotSaveContent in State) and (FBackground<>nil) and not FBackground.Empty);
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.GetRVData: TCustomRVData;
begin
  if (TRVTableRow(FList).FRows.FTable.FInplaceEditor<>nil) and
     (TRVTableInplaceEdit(TRVTableRow(FList).FRows.FTable.FInplaceEditor).FCell=Self) then
    Result := TRVTableInplaceEdit(TRVTableRow(FList).FRows.FTable.FInplaceEditor).RVData
  else
    Result := Self;
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.DataWriter(Stream: TStream);
var StartPos,Size: Integer;
    Layout: TRVLayoutInfo;
begin
  if (GetTable.FStreamSaveInfo.CellPtblRVData=nil) or
     (GetTable.FStreamSaveInfo.CellPtblRVData.Pages=nil) then begin
    inherited DataWriter(Stream);
    exit;
  end;
  Size := 0;
  StartPos := Stream.Position;
  Stream.WriteBuffer(Size, SizeOf(Size));

  if GetTable.FStreamSaveInfo.CellPage>0 then begin
    Layout := TRVLayoutInfo.Create;
    try
      GetTable.FStreamSaveInfo.CellPtblRVData.SavePageAsRVF(Stream,
        GetTable.FStreamSaveInfo.CellPage, clNone, nil, Layout);
    finally
      Layout.Free;
    end;
  end;
  Size := Stream.Position-SizeOf(Size)-StartPos;
  Stream.Position := StartPos;
  Stream.WriteBuffer(Size, SizeOf(Size));
  Stream.Position := StartPos+SizeOf(Size)+Size;
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.AssignAttributesFrom(Cell: TRVTableCellData;
                                                IncludeSize: Boolean;
                                                DivColSpan, DivRowSpan: Integer);
begin
  FColor            := Cell.Color;
  FBorderColor      := Cell.BorderColor;
  FBorderLightColor := Cell.BorderLightColor;
  VisibleBorders.Assign(Cell.VisibleBorders);
  FValign := Cell.VAlign;
  BackgroundImage := Cell.BackgroundImage;
  BackgroundStyle := Cell.BackgroundStyle;
  BackgroundImageFileName := Cell.BackgroundImageFileName;
  {$IFNDEF RVDONOTUSEITEMHINTS}
  Hint := Cell.Hint;
  {$ENDIF}
  if IncludeSize then begin
    FBestWidth := Cell.FBestWidth div DivColSpan;
    FBestHeight := Cell.FBestHeight div DivRowSpan;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.AssignSizeFrom(Cell:TRVTableCellData);
begin
  FLeft := Cell.FLeft;
  FTop := Cell.FTop;
  FWidth := Cell.FWidth;
  FHeight := Cell.FHeight;  
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.GetRealVAlign: TRVCellVAlign;
begin
  if VAlign<>rvcVDefault then
    Result := VAlign
  else begin
    Result := TRVTableRow(FList).VAlign;
    if Result=rvcVDefault then
      Result := rvcMiddle;
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.GetExtraVOffs: Integer;
var RVData: TCustomRVFormattedData;
begin
  case GetRealVAlign of
    rvcBottom:
      begin
        RVData := TCustomRVFormattedData(GetRVData);
        Result := Height-RVData.DocumentHeight;
        if RVData=Self then
          dec(Result, GetRVStyle.GetAsPixels(GetTable.CellVPadding)*2);
      end;
    rvcMiddle:
      begin
        RVData := TCustomRVFormattedData(GetRVData);
        Result := (Height-RVData.DocumentHeight) div 2;
        if RVData=Self then
          dec(Result, GetRVStyle.GetAsPixels(GetTable.CellVPadding));
      end;
    else
      Result := 0;
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.GetOptions: TRVOptions;
begin
  if ContainerUndoItem<>nil then
    Result := ContainerUndoItem.GetUndoListOwnerRVData.Options
  else
    Result := inherited GetOptions;
  Exclude(Result, rvoClientTextWidth);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSELISTS}
function TRVTableCellData.GetMarkers(AllowCreate: Boolean): TRVMarkerList;
begin
  if ContainerUndoItem<>nil then
    Result := nil // in undo list
  else begin
    if (GetTable.GetMyItemNo<0) then
      Result := nil // not inserted yet
    else
      Result := inherited GetMarkers(AllowCreate);
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESEQ}
function TRVTableCellData.GetSeqList(AllowCreate: Boolean): TRVSeqList;
begin
  if ContainerUndoItem<>nil then
    Result := nil // in undo list
  else begin
    if (GetTable.GetMyItemNo<0) then
      Result := nil // not inserted yet
    else
      Result := inherited GetSeqList(AllowCreate);
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRVTableCellData.SupportsPageBreaks: Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.DoSelect;
begin
  // do not perform inherited actions
end;
{------------------------------------------------------------------------------}
function TRVTableCellData.CanClear: Boolean;
var i: Integer;
    item: TCustomRVItemInfo;
    RVStyle: TRVStyle;
begin
  Result := True;
  RVStyle := GetRVStyle;
  if RVStyle=nil then
    exit;
  for i := 0 to Items.Count-1 do begin
    item := GetItem(i);
    if ((item.StyleNo>=0) and (rvprDeleteProtect in RVStyle.TextStyles[item.StyleNo].Protection)) or
       ((item.StyleNo<0) and TRVNonTextItemInfo(item).DeleteProtect) then begin
      Result := False;
      exit;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.ControlAction(RVData: TCustomRVData;
  ControlAction: TRVControlAction; ItemNo: Integer; Item: TCustomRVItemInfo);
begin
  if item is TRVControlItemInfo then
    ControlAction2(RVData, ControlAction, ItemNo,
      TRVControlItemInfo(Item).Control);
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.ControlAction2(RVData: TCustomRVData;
  ControlAction: TRVControlAction; ItemNo: Integer; var Control: TControl);
begin
  if ContainerUndoItem<>nil then begin
    if ControlAction=rvcaDestroy then
      ControlAction := rvcaDestroyInUndoList;
    ContainerUndoItem.GetUndoListOwnerRVData.ControlAction2(
      RVData, ControlAction,-1,Control)
    end
  else begin
    TRVTableRow(FList).FRows.FMainRVData.GetAbsoluteRootData.ControlAction2(
      RVData, ControlAction, ItemNo, Control);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.ItemAction(ItemAction: TRVItemAction; Item: TCustomRVItemInfo;
  var Text: TRVRawByteString; RVData: TCustomRVData);
begin
  if ContainerUndoItem<>nil then
    ContainerUndoItem.GetUndoListOwnerRVData.ItemAction(ItemAction, Item, Text, RVData)
  else
    TRVTableRow(FList).FRows.FMainRVData.ItemAction(ItemAction, Item, Text, RVData);
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.AdjustFocus(NewFocusedItemNo: Integer;
  TopLevelRVData: TPersistent; TopLevelItemNo: Integer);
var r,c: Integer;
begin
  inherited AdjustFocus(NewFocusedItemNo, TopLevelRVData, TopLevelItemNo);
  with GetTable do begin
    GetCellPosition(Self,r,c);
    AdjustFocus(r,c,TopLevelRVData,TopLevelItemNo);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableCellData.ConvertToDifferentUnits(NewUnits: TRVStyleUnits;
  RVStyle: TRVStyle; ConvertItems: Boolean);
begin
  inherited;
  BestHeight := RVStyle.GetAsDifferentUnits(BestHeight, NewUnits);
  if BestWidth>0 then
    BestWidth := RVStyle.GetAsDifferentUnits(BestWidth, NewUnits);
end;
{=============================== TRVTableRow ==================================}
constructor TRVTableRow.Create(nCols: Integer; ARows: TRVTableRows;
                               MainRVData: TCustomRVData);
var i: Integer;
begin
  inherited Create(MainRVData);
  FRows    := ARows;
  Capacity := nCols;
  Valign   := rvcTop;
  for i := 0 to nCols-1 do
    Add
end;
{------------------------------------------------------------------------------}
function TRVTableRow.GetParentRVData: TCustomRVData;
begin
  Result := FRows.FMainRVData;
end;
{------------------------------------------------------------------------------}
function TRVTableRow.HasCellsInRange(Index, RangeStart, Count: Integer): Boolean;
var c, RangeEnd, LastCellRow: Integer;
begin
  Result := False;
  if RangeStart>Index then
    exit;
  RangeEnd := RangeStart+Count-1;
  for c := 0 to Self.Count-1 do
    if Items[c]<>nil then begin
      LastCellRow := Index+Items[c].RowSpan-1;
      if LastCellRow<=RangeEnd then begin
        Result := True;
        exit;
      end;
    end;
end;
{------------------------------------------------------------------------------}
function TRVTableRow.Add: TRVTableCellData;
begin
  Result := TRVTableCellData.Create(Self);
  inherited Add(Result);
end;
{------------------------------------------------------------------------------}
function TRVTableRow.Insert(Index: Integer): TRVTableCellData;
begin
  Result := TRVTableCellData.Create(Self);
  inherited Insert(Index, Result);
end;
{------------------------------------------------------------------------------}
procedure TRVTableRow.InsertEmpty(Index: Integer);
begin
  inherited Insert(Index, nil);
end;
{------------------------------------------------------------------------------}
procedure TRVTableRow.InsertPointer(Index: Integer; Item: TRVTableCellData);
begin
  if Item<>nil then
    Item.FList := Self;
  inherited Insert(Index, Item);
end;
{------------------------------------------------------------------------------}
function TRVTableRow.Get(Index: Integer): TRVTableCellData;
begin
  Result := TRVTableCellData(inherited Get(Index));
end;
{------------------------------------------------------------------------------}
procedure TRVTableRow.Put(Index: Integer; const Value: TRVTableCellData);
begin
  if Value<>nil then
    Value.FList := Self;
  inherited Put(Index, Value);
end;
{------------------------------------------------------------------------------}
// Returns the greatest BestHeight in this row (among rows with RowSpan=1)
function TRVTableRow.GetBestHeight: TRVStyleLength;
var i: Integer;
    h: TRVStyleLength;
begin
  Result := 0;
  for i := 0 to Count-1 do
    if (Items[i]<>nil) and (Items[i].RowSpan<=1) then begin
      h := Items[i].BestHeight;
      if h>Result then
        Result := h;
    end;
end;
{------------------------------------------------------------------------------}
// Returns row height in screen pixels.
// Cannot be used to calculate sizes for printing
function TRVTableRow.GetHeight(IgnoreContentHeight: Boolean): Integer;
var i,h: Integer;
begin
  Result := 0;
  for i := 0 to Count-1 do
    if (Items[i]<>nil) and (Items[i].RowSpan<=1) then begin
      h := Items[i].GetCellHeight(IgnoreContentHeight);
      if h>Result then
        Result := h;
    end;
  if Result = 0 then
    Result := 10; // temporary
end;
{============================== TRVTableRows ==================================}
constructor TRVTableRows.Create(nRows, nCols: Integer; AMainRVData: TCustomRVData;
                                ATable: TRVTableItemInfo);
begin
  inherited Create;
  FMainRVData := AMainRVData;
  FTable      := ATable;
  Reset(nRows, nCols);
end;
{------------------------------------------------------------------------------}
destructor TRVTableRows.Destroy;
begin
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Reset(nRows, nCols: Integer);
var i: Integer;
begin
  Clear;
  Capacity := nRows;
  for i := 0 to nRows-1 do
    Add(nCols);
end;
{------------------------------------------------------------------------------}
function TRVTableRows.Empty: Boolean;
begin
  Result := (Count=0) or (Items[0].Count=0);
end;
{------------------------------------------------------------------------------}
function TRVTableRows.Add(nCols: Integer): TRVTableRow;
begin
  Result := TRVTableRow.Create(nCols, Self, FMainRVData);
  inherited Add(Result);
end;
{------------------------------------------------------------------------------}
function TRVTableRows.Insert(Index, nCols: Integer): TRVTableRow;
begin
  Result := TRVTableRow.Create(nCols, Self, FMainRVData);
  inherited Insert(Index, Result);
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.InsertPointer(Index: Integer; Item: TRVTableRow);
begin
  Item.FRows := Self;
  inherited Insert(Index, Item);
end;
{------------------------------------------------------------------------------}
function TRVTableRows.Get(Index: Integer): TRVTableRow;
begin
  Result := TRVTableRow(inherited Get(Index));
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Put(Index: Integer; const Value: TRVTableRow);
begin
  Value.FRows := Self;
  inherited Put(Index, Value);
end;
{------------------------------------------------------------------------------}
// Returns BestWidth for a cell that will be a result of merging of the given
// cell range.
// The result is measured in 0 / % / TRVStyleUnits
function TRVTableRows.GetBestWidth(TopRow, LeftCol, ColSpan, RowSpan: Integer): Integer;
var r,c,bw: Integer;
begin
  Result := 0;
  for r := TopRow to TopRow+RowSpan-1 do begin
    bw := 0;
    with Items[r] do
      for c := LeftCol to LeftCol+ColSpan-1 do
        if Items[c]<>nil then begin
          if Items[c].BestWidth>0 then begin
            if bw>=0 then
              inc(bw,Items[c].BestWidth);
            end
          else if Items[c].BestWidth<0 then begin
            if bw>0 then
              bw := 0;
            inc(bw,Items[c].BestWidth);
          end;
        end;
    if ((Result>=0) and ((bw<0) or (bw>Result))) or
       ((Result<0) and (bw<Result)) then
      Result := bw;
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableRows.IsEmptyCols(TopRow, LeftCol, ColSpan, RowSpan, LeftCol2, ColSpan2: Integer): Boolean;
var r,c: Integer;
    empty: Boolean;
begin
  Result := True;
  for r := TopRow to TopRow+RowSpan-1 do begin
    empty := True;
    for c := LeftCol to LeftCol+ColSpan-1 do
      if Items[r].Items[c]<>nil then begin
        empty := False;
        break;
      end;
    if empty then
      for c := LeftCol2 to LeftCol2+ColSpan2-1 do
        if Items[r].Items[c]<>nil then begin
          empty := False;
          break;
        end;
    if empty then
      exit;
  end;
  Result := False;
end;
{------------------------------------------------------------------------------}
function TRVTableRows.GetColCount: Integer;
begin
  if Count>0 then
    Result := Items[0].Count
  else
    Result := 0;
end;
{------------------------------------------------------------------------------}
function TRVTableRows.IsEmptyRows(TopRow, LeftCol, ColSpan, RowSpan, TopRow2, RowSpan2: Integer): Boolean;
var r,c: Integer;
    empty: Boolean;
begin
  Result := True;
  for c := LeftCol to LeftCol+ColSpan-1 do begin
    empty := True;
    for r := TopRow to TopRow+RowSpan-1 do
      if Items[r].Items[c]<>nil then begin
        empty := False;
        break;
      end;
    if empty then
      for r := TopRow2 to TopRow2+RowSpan2-1 do
        if Items[r].Items[c]<>nil then begin
          empty := False;
          break;
        end;
    if empty then
      exit;
  end;
  Result := False;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.UnmergeCell(Row, Col: Integer; UnmergeRows, UnmergeCols: Boolean);
var MainCell: TRVTableCellData;
    ItemNo: Integer;
begin
  MainCell := Items[Row].Items[Col];
  if (MainCell=nil) or
     (((MainCell.ColSpan=1) or not UnmergeCols) and
      ((MainCell.RowSpan=1) or not UnmergeRows)) then
    exit;
  ItemNo := FTable.GetEditorItemNoForUndo;
  Do_BeforeUnmergeCell(ItemNo, Row, Col, UnmergeRows, UnmergeCols);
  Do_UnmergeCell(ItemNo, Row, Col, UnmergeRows, UnmergeCols);  
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.UnmergeCells(TopRow, LeftCol, ColSpan, RowSpan: Integer;
                                    UnmergeRows, UnmergeCols: Boolean);
var r,c: Integer;
begin
  for r := TopRow+RowSpan-1 downto TopRow do
    for c := LeftCol+ColSpan-1 downto LeftCol do
      UnmergeCell(r, c, UnmergeRows, UnmergeCols);
end;
{------------------------------------------------------------------------------}
function TRVTableRows.StartMergeCells(TopRow, LeftCol: Integer;
                                      var ColSpan, RowSpan: Integer): Boolean;
var MainCell: TRVTableCellData;
begin
  Result := False;
  if TopRow+RowSpan>Count then
    RowSpan := Count - TopRow;
  if LeftCol+ColSpan>Items[TopRow].Count then
    ColSpan := Items[TopRow].Count - LeftCol;
  if (RowSpan<2) and (ColSpan<2) then exit;
  if (RowSpan<1) or (ColSpan<1) then
    raise ERichViewError.Create(errMerge);
  MainCell := Items[TopRow].Items[LeftCol];
  Result := (MainCell<>nil) and
            (
            (MainCell.RowSpan<RowSpan)
            or
            (MainCell.ColSpan<ColSpan)
            );
end;
{------------------------------------------------------------------------------}
function TRVTableRows.CanMergeCells(TopRow, LeftCol, ColSpan, RowSpan: Integer;
                                    AllowMergeRC: Boolean): Boolean;
var r,c,mr,mc: Integer;
    MainCell, Cell: TRVTableCellData;
    Flag: Boolean;
    {...............................................}
begin
  Result := StartMergeCells(TopRow, LeftCol, ColSpan, RowSpan);
  if not Result then
    exit;
  Result := False;
  MainCell := GetMainCell(TopRow, LeftCol, mr, mc);
  Flag := False;
  for r := TopRow to TopRow+RowSpan-1 do
    with Items[r] do
      for c := LeftCol to LeftCol+ColSpan-1 do begin
        if Items[c]<>nil then begin
          Cell := Items[c];
          mr := r;
          mc := c;
          end
        else
          Cell := GetMainCell(r,c,mr,mc);
        if (mr<TopRow) or (mc<LeftCol) or
           (mr+Cell.RowSpan>TopRow+RowSpan) or
           (mc+Cell.ColSpan>LeftCol+ColSpan) then
          exit;
        if Cell<>MainCell then
          Flag := True;
      end;
  if AllowMergeRC then begin
    Result := Flag;
    exit;
  end;
  // testing if merging removes row
  if (ColSpan>1) and
     IsEmptyRows(0, LeftCol+1, ColSpan-1, TopRow, TopRow+RowSpan, Count-(TopRow+RowSpan)) then
    exit;
  if (RowSpan>1) and
     IsEmptyCols(TopRow+1, 0, LeftCol, RowSpan-1, LeftCol+ColSpan, Items[0].Count-(LeftCol+ColSpan)) then
    exit;
  Result := True;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.MergeCells(TopRow, LeftCol, ColSpan, RowSpan: Integer;
                                  AllowMergeRC, ChangeBestWidth: Boolean);
var ItemNo: Integer;
    ui: TRVUndoInfo;
begin
  if not StartMergeCells(TopRow, LeftCol, ColSpan, RowSpan) then
    exit;
  if not CanMergeCells(TopRow, LeftCol, ColSpan, RowSpan, AllowMergeRC) then begin
    FMainRVData.Beep;
    exit;
  end;
  ItemNo := FTable.GetEditorItemNoForUndo;
  ui := Do_BeforeMergeCells(ItemNo, TopRow,LeftCol,ColSpan,RowSpan);
  Do_MergeCells(ItemNo, TopRow,LeftCol,ColSpan,RowSpan, ui, ChangeBestWidth);
end;
{------------------------------------------------------------------------------}
// Returns the minimal allowed Column width, in device pixels
function TRVTableRows.GetMinColWidth(Col: Integer; sad: PRVScreenAndDevice;
  Canvas: TCanvas): Integer;
var i,w: Integer;
begin
  Result := 0;
  for i := 0 to Count-1 do
    if (Items[i].Items[Col]<>nil) and
       (Items[i].Items[Col].ColSpan<=1) then begin
      w := Items[i].Items[Col].GetMinWidth(sad, Canvas);
      if (w>Result) then
        Result := w;
    end;
end;
{------------------------------------------------------------------------------}
function TRVTableRows.IsPercentWidthColumn(Col: Integer): Boolean;
var i,a,b: Integer;
    Cell:  TRVTableCellData;
begin
  for i := 0 to Count-1 do
    if (Items[i].Items[Col]<>nil) then begin
      if (Items[i].Items[Col].ColSpan<=1) then begin
        if (Items[i].Items[Col].BestWidth<0) then begin
          Result := True;
          exit;
        end;
      end
      end
    else begin
      Cell := GetMainCell(i,Col,a,b);
      if (Cell.BestWidth<0)  and
         (
         (Col=Items[i].Count-1) or
         (Items[i].Items[Col+1]<>nil) or
         (Cell<>GetMainCell(i,Col+1,a,b))
         ) then begin
        Result := True;
        exit;
      end;
    end;
  Result := False;
end;
{------------------------------------------------------------------------------}
// Returns width of the column Col, assuming that its width is in %
// (if no %-width cells, returns 0)
function TRVTableRows.GetPercentColWidth(Col, TableWidth: Integer): Integer;
var i,w: Integer;
begin
  Result := 0;
  for i := 0 to Count-1 do
    if (Items[i].Items[Col]<>nil) and
       (Items[i].Items[Col].ColSpan<=1) then begin
      w := Items[i].Items[Col].BestWidth;
      if (w<0) then begin
        w := -w*TableWidth div 100;
        if (w>Result) then
          Result := w;
      end;
    end;
end;
{------------------------------------------------------------------------------}
// Returns width of the column Col, assuming that its width is in TRVStyleUnits
// (if it has %-width cells, returns 0)
function TRVTableRows.GetRVSLengthColWidth(Col: Integer): TRVStyleLength;
var i,w: Integer;
begin
  Result := 0;
  for i := 0 to Count-1 do
    if (Items[i].Items[Col]<>nil) and
       (Items[i].Items[Col].ColSpan<=1) then begin
      w := Items[i].Items[Col].BestWidth;
      if w<0 then begin
        Result := 0;
        exit;
      end;
      if (w>Result) then
        Result := w;
    end;
end;
{------------------------------------------------------------------------------}
function TRVTableRows.GetMainCell(ARow, ACol: Integer; var MRow, MCol: Integer): TRVTableCellData;
begin
  MRow := ARow;
  MCol := ACol;
  if Items[MRow][MCol]<>nil then begin
    Result := Items[MRow][MCol];
    exit;
  end;
  while True do
    with Items[MRow] do begin
      while (Items[MCol]=nil) and (MCol>0) do
        dec(MCol);
      if (Items[MCol]<>nil) and
         (Items[MCol].ColSpan>ACol-MCol) and
         (Items[MCol].RowSpan>ARow-MRow) then begin
        Result := Items[MCol];
        exit;
      end;
      MCol := ACol;
      dec(MRow);
      //Assert(MRow>=0);
    end;
  Result := Items[MRow].Items[MCol];
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.MovingFromUndoList(Row, Col, ColSpan,
  RowSpan: Integer);
var r,c: Integer;
begin
  for r := Row to Row+RowSpan-1 do
    with Items[r] do
      for c := Col to Col+ColSpan-1 do
        if (Items[c]<>nil) then begin
          Items[c].FList := Self.Items[r];
          Items[c].MovingFromUndoList;
        end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.MovingToUndoList(Row, Col, ColSpan,
  RowSpan: Integer; AContainerUndoItem: TRVUndoInfo);
var r,c: Integer;
begin
  for r := Row to Row+RowSpan-1 do
    with Items[r] do
      for c := Col to Col+ColSpan-1 do
        if (Items[c]<>nil) then begin
          Items[c].MovingToUndoList(AContainerUndoItem);
          Items[c].FList := nil;
        end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_BeforeInsertRows(ItemNo,Row,Count: Integer);
var ui: TRVUndoInsertTableRows;
begin
  if (rvtsInserted in FTable.FState) and FTable.IsInEditor then begin
    if ItemNo=-1 then
      ItemNo := FTable.GetMyItemNo;
    ui := TRVUndoInsertTableRows(
             AddTableUndoInfo(TRVEditRVData(FMainRVData), TRVUndoInsertTableRows,
                             ItemNo, True, True));
    if ui<>nil then begin
      ui.Row          := Row;
      ui.Count        := Count;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_InsertRows(Row, Count: Integer);
var r: Integer;
begin
  for r := 0 to Count-1 do
    Insert(Row, GetColCount);
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_UnInsertRows(Row, Count: Integer);
var r: Integer;
begin
  for r := 0 to Count-1 do
    Delete(Row);
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_BeforeInsertCell(ItemNo, Row, Col: Integer);
var ui: TRVUndoInsertTableCell;
begin
  if (rvtsInserted in FTable.FState) and FTable.IsInEditor then begin
    if ItemNo=-1 then
      ItemNo := FTable.GetMyItemNo;
    ui := TRVUndoInsertTableCell(
             AddTableUndoInfo(TRVEditRVData(FMainRVData), TRVUndoInsertTableCell,
                             ItemNo, True, True));
    if ui<>nil then begin
      ui.Row        := Row;
      ui.Col        := Col;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_BeforeSpreadOverEmptyCells(ItemNo, Row, Col,
  ColSpan: Integer);
var ui: TRVUndoSpreadOverEmptyCells;
begin
  if (rvtsInserted in FTable.FState) and FTable.IsInEditor then begin
    ui := TRVUndoSpreadOverEmptyCells(
             AddTableUndoInfo(TRVEditRVData(FMainRVData), TRVUndoSpreadOverEmptyCells,
                             ItemNo, True, True));
    if ui<>nil then begin
      ui.Row := Row;
      ui.Col := Col;
      ui.ColSpan := ColSpan;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_SpreadOverEmptyCells(Row, Col, ColSpan: Integer);
var c: Integer;
begin
  Items[Row][Col].FColSpan := ColSpan;
  for c := Col+1 to Col+ColSpan-1 do begin
    Items[Row][c].Free;
    Items[Row][c] := nil;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_UnSpreadOverEmptyCells(Row, Col, ColSpan: Integer);
var c: Integer;
begin
  Items[Row][Col].FColSpan := 1;
  for c := Col+1 to Col+ColSpan-1 do begin
    //Assert(Items[Row][c]=nil);
    Items[Row][c] := TRVTableCellData.Create(Items[Row]);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_SetSpan(ItemNo, Row, Col, Span: Integer;
  IsColSpan: Boolean);
var ui: TRVUndoSpan;
begin
  if (IsColSpan     and (Items[Row][Col].FColSpan = Span)) or
     (not IsColSpan and (Items[Row][Col].FRowSpan = Span)) then
    exit;
  if (rvtsInserted in FTable.FState) and FTable.IsInEditor then begin
    if ItemNo=-1 then
      ItemNo := FTable.GetMyItemNo;
    ui := TRVUndoSpan(
             AddTableUndoInfo(TRVEditRVData(FMainRVData), TRVUndoSpan,
                             ItemNo, True, IsColSpan));
    if ui<>nil then begin
      ui.Row := Row;
      ui.Col := Col;
      ui.IsColSpan := IsColSpan;
      if IsColSpan then
        ui.OldSpan := Items[Row][Col].ColSpan
      else
        ui.OldSpan := Items[Row][Col].RowSpan;
    end;
  end;
  if IsColSpan then
    Items[Row][Col].FColSpan := Span
  else
    Items[Row][Col].FRowSpan := Span;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_ChangeEmptyCellStyles(ItemNo, Row, Col, StyleNo,
  ParaNo: Integer);
var ui: TRVUndoChangeEmptyCellStyles;
begin
  if (rvtsInserted in FTable.FState) and FTable.IsInEditor then begin
    if ItemNo=-1 then
      ItemNo := FTable.GetMyItemNo;
    ui := TRVUndoChangeEmptyCellStyles(
      AddTableUndoInfo(TRVEditRVData(FMainRVData), TRVUndoChangeEmptyCellStyles,
        ItemNo, True, True));
    if ui<>nil then begin
      ui.Row := Row;
      ui.Col := Col;
      ui.StyleNo := Items[Row][Col].GetItemStyle(0);
      ui.ParaNo := Items[Row][Col].GetItemPara(0);
    end;
    Items[Row][Col].Clear;
    {$IFNDEF RVDONOTUSEUNICODE}
    Items[Row][Col].AddNLATag('', StyleNo, ParaNo, 0);
    {$ELSE}
    Items[Row][Col].AddNL('', StyleNo, ParaNo);
    {$ENDIF}
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_BeforeFreeEmptyCells(ItemNo, Row, Col, ColSpan,
  RowSpan: Integer);
var ui: TRVUndoFreeEmptyCell;
begin
  if (rvtsInserted in FTable.FState) and FTable.IsInEditor then begin
    ui := TRVUndoFreeEmptyCell(
             AddTableUndoInfo(TRVEditRVData(FMainRVData), TRVUndoFreeEmptyCell,
                             ItemNo, True, True));
    if ui<>nil then begin
      ui.Row := Row;
      ui.Col := Col;
      ui.RowSpan := RowSpan;
      ui.ColSpan := ColSpan;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_FreeEmptyCells(Row, Col, ColSpan,
  RowSpan: Integer);
var r,c: Integer;
begin
  for r := Row to Row+RowSpan-1 do
    for c := Col to Col+ColSpan-1 do begin
      Items[r][c].Free;
      Items[r][c] := nil;
    end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_UnFreeEmptyCells(Row, Col, ColSpan,
  RowSpan: Integer);
var r,c: Integer;
begin
  for r := Row to Row+RowSpan-1 do
    for c := Col to Col+ColSpan-1 do begin
      //Assert(Items[r][c]=nil);
      Items[r][c] := TRVTableCellData.Create(Items[r]);
    end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_BeforeInsertEmptyCells(ItemNo, Row, Col, ColCount,
  RowCount: Integer);
var ui: TRVUndoInsertEmptyCell;
begin
  if (rvtsInserted in FTable.FState) and FTable.IsInEditor and (ColCount>0) and (RowCount>0) then begin
    ui := TRVUndoInsertEmptyCell(
             AddTableUndoInfo(TRVEditRVData(FMainRVData), TRVUndoInsertEmptyCell,
                             ItemNo, True, True));
    if ui<>nil then begin
      ui.Row := Row;
      ui.Col := Col;
      ui.RowCount := RowCount;
      ui.ColCount := ColCount;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_InsertEmptyCells(Row, Col, ColCount,
  RowCount: Integer);
var r,c: Integer;
begin
  for r := Row to Row+RowCount-1 do
    for c := Col to Col+ColCount-1 do begin
      Items[r].InsertEmpty(Col);
    end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_UnInsertEmptyCells(Row, Col, ColCount,
  RowCount: Integer);
var r,c: Integer;
begin
  for r := Row to Row+RowCount-1 do
    for c := Col to Col+ColCount-1 do begin
      Items[r].Delete(Col);
    end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_BeforeSplitCellHorz(ItemNo,Row,Col,Row2: Integer; DecreaseHeight: Boolean);
var ui: TRVUndoCellSpitHorz;
begin
  if (rvtsInserted in FTable.FState) and FTable.IsInEditor then begin
    ui := TRVUndoCellSpitHorz(
             AddTableUndoInfo(TRVEditRVData(FMainRVData), TRVUndoCellSpitHorz,
                             ItemNo, True, False));
    if ui<>nil then begin
      ui.Row := Row;
      ui.Col := Col;
      ui.Row2 := Row2;
      ui.DecreaseHeight := DecreaseHeight;
      ui.OldBestHeight := Items[Row][Col].BestHeight;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_SplitCellHorz(Row,Col,Row2: Integer; DecreaseHeight: Boolean);
var MainCell,NewCell: TRVTableCellData;
begin
  MainCell := Items[Row][Col];
  NewCell := TRVTableCellData.Create(Items[Row2]);
  NewCell.AssignAttributesFrom(MainCell,True,1,1);
  NewCell.FColSpan := MainCell.ColSpan;
  NewCell.FRowSpan := Row+MainCell.RowSpan-Row2;
  NewCell.FBestHeight := MainCell.BestHeight * NewCell.RowSpan div MainCell.RowSpan;
  Items[Row2][Col] := NewCell;
  if DecreaseHeight then
    MainCell.BestHeight := MainCell.BestHeight * (MainCell.RowSpan-NewCell.RowSpan) div MainCell.RowSpan;
  MainCell.FRowSpan := MainCell.RowSpan-NewCell.RowSpan;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_UnSplitCellHorz(Row,Col,Row2: Integer; OldBestHeight: Integer);
var MainCell,NewCell: TRVTableCellData;
begin
  MainCell := Items[Row][Col];
  NewCell  := Items[Row2][Col];
  MainCell.BestHeight := OldBestHeight;
  inc(MainCell.FRowSpan, NewCell.FRowSpan);
  NewCell.Free;
  Items[Row2][Col] := nil;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_BeforeSplitCellVert(ItemNo, Row, Col,
  Col2: Integer; DecreaseWidth: Boolean);
var ui: TRVUndoCellSpitVert;
begin
  if (rvtsInserted in FTable.FState) and FTable.IsInEditor then begin
    ui := TRVUndoCellSpitVert(
             AddTableUndoInfo(TRVEditRVData(FMainRVData), TRVUndoCellSpitVert,
                             ItemNo, True, True));
    if ui<>nil then begin
      ui.Row := Row;
      ui.Col := Col;
      ui.Col2 := Col2;
      ui.DecreaseWidth := DecreaseWidth;
      ui.OldBestWidth := Items[Row][Col].BestWidth;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_SplitCellVert(Row, Col, Col2: Integer;
  DecreaseWidth: Boolean);
var MainCell,NewCell: TRVTableCellData;  
begin
  MainCell := Items[Row][Col];
  NewCell := TRVTableCellData.Create(Items[Row]);
  NewCell.AssignAttributesFrom(MainCell,True,1,1);
  NewCell.FRowSpan := MainCell.RowSpan;
  NewCell.FColSpan := Col+MainCell.ColSpan-Col2;
  NewCell.FBestWidth := MainCell.BestWidth * NewCell.ColSpan div MainCell.ColSpan;
  Items[Row][Col2] := NewCell;
  if DecreaseWidth then
    MainCell.BestWidth := MainCell.BestWidth * (MainCell.ColSpan-NewCell.ColSpan) div MainCell.ColSpan;
  MainCell.FColSpan := MainCell.ColSpan-NewCell.ColSpan;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_UnSplitCellVert(Row, Col, Col2,
  OldBestWidth: Integer);
var MainCell,NewCell: TRVTableCellData;
begin
  MainCell := Items[Row][Col];
  NewCell  := Items[Row][Col2];
  MainCell.BestWidth := OldBestWidth;
  inc(MainCell.FColSpan, NewCell.FColSpan);
  NewCell.Free;
  Items[Row][Col2] := nil;
end;
{------------------------------------------------------------------------------}
function TRVTableRows.Do_BeforeDeleteRows(ItemNo, Row, Count: Integer): TRVUndoInfo;
var ui: TRVUndoDeleteRows;
    i: Integer;
begin
  ui := nil;
  if (rvtsInserted in FTable.FState) and FTable.IsInEditor then begin
    ui := TRVUndoDeleteRows(AddTableUndoInfo(TRVEditRVData(FMainRVData), TRVUndoDeleteRows,
                            ItemNo, True, True));
    if ui<>nil then begin
      ui.Row          := Row;
      ui.Count        := Count;
      ui.Rows := TList.Create;
      for i := 0 to Count-1 do
        ui.Rows.Add(FTable.Rows[Row+i]);
    end;
  end;
  Result := ui;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_DeleteRows(ItemNo, Row, Count: Integer; ui: TRVUndoInfo);
begin
  if ItemNo=-1 then
    while Count>0 do begin
      Delete(Row);
      dec(Count);
    end
  else begin
    MovingToUndoList(Row,0,Items[Row].Count,Count,ui);
    while Count>0 do begin
      DeleteAsPointer(Row);
      dec(Count);
    end
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_UnDeleteRows(Row: Integer; RowList: TList);
var i,c: Integer;
begin
  for i := RowList.Count-1 downto 0 do begin
    InsertPointer(Row, RowList[i]);
    for c := 0 to Items[Row].Count-1 do
      if Items[Row][c]<>nil then
        Items[Row][c].FList := Items[Row];
  end;
  MovingFromUndoList(Row,0,Items[Row].Count,RowList.Count);
  RowList.Clear;
end;
{------------------------------------------------------------------------------}
function TRVTableRows.Do_BeforeDeleteCols(ItemNo, Col, Count: Integer): TRVUndoInfo;
var ui: TRVUndoDeleteCols;
    r,c: Integer;
begin
  ui := nil;
  if (rvtsInserted in FTable.FState) and FTable.IsInEditor then begin
    ui := TRVUndoDeleteCols(AddTableUndoInfo(TRVEditRVData(FMainRVData), TRVUndoDeleteCols,
                            ItemNo, True, True));
    if ui<>nil then begin
      ui.Col          := Col;
      ui.Count        := Count;
      ui.CellsList := TList.Create;
      for r := 0 to Self.Count-1 do
        for c := Count-1 downto 0 do
          ui.CellsList.Add(Items[r][Col+c]);
    end;
  end;
  Result := ui;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_DeleteCols(ItemNo, Col, Count: Integer; ui: TRVUndoInfo);
var r,c: Integer;
begin
  if ItemNo=-1 then
    for r := 0 to Self.Count-1 do
      for c := 0 to Count-1 do
        Items[r].Delete(Col)
  else begin
    MovingToUndoList(0,Col,Count,Self.Count, ui);
    for r := 0 to Self.Count-1 do
      for c := 0 to Count-1 do
        Items[r].DeleteAsPointer(Col);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_UnDeleteCols(Col: Integer; CellList: TList);
var r,c,idx,DelCount: Integer;
begin
  idx := 0;
  DelCount := CellList.Count div Self.Count;
  for r := 0 to Self.Count-1 do
    for c := 0 to DelCount-1 do begin
      Items[r].InsertPointer(Col, CellList.Items[idx]);
      inc(idx);
    end;
  MovingFromUndoList(0,Col,DelCount,Self.Count);
  CellList.Clear;
end;
{------------------------------------------------------------------------------}
function TRVTableRows.Do_BeforeClearCells(ItemNo: Integer; RowList, ColList: TRVIntegerList;
                                           var CellsList: TList): TRVUndoInfo;
var ui: TRVUndoCellsClear;
begin
  ui := nil;
  CellsList := nil;
  if (rvtsInserted in FTable.FState) and FTable.IsInEditor then begin
    ui := TRVUndoCellsClear(AddTableUndoInfo(TRVEditRVData(FMainRVData), TRVUndoCellsClear,
                            ItemNo, True, True));
    if ui<>nil then begin
      ui.RowList := TRVIntegerList.CreateCopy(RowList);
      ui.ColList := TRVIntegerList.CreateCopy(ColList);
      ui.CellsList := TList.Create;
      CellsList  := ui.CellsList;
    end;
  end;
  Result := ui;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_AfterFillingCells(CellsList: TList;
  RowList, ColList: TRVIntegerList; ui: TRVUndoInfo);
begin
end;
{------------------------------------------------------------------------------}
function GetFirstTextStyleNo(RVData: TCustomRVData): Integer;
var i: Integer;
begin
  Result := 0;
  for i := 0 to RVData.ItemCount-1 do
    if (RVData.GetItemStyle(i)>=0) and (RVData.GetItemTag(i)=0) then begin
      Result := RVData.GetItemStyle(i);
      exit;
    end;
end;
function GetFirstParaStyleNo(RVData: TCustomRVData): Integer;
begin
  if RVData.ItemCount>0 then
    Result := RVData.GetItemPara(0)
  else
    Result := 0;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_ClearCells(CellsList: TList; RowList, ColList: TRVIntegerList;
  ui: TRVUndoInfo);
var i, ParaNo, StyleNo: Integer;
    Cell,Cell2: TRVTableCellData;
    ChosenCell: TCustomRVData;
begin
  for i := 0 to RowList.Count-1 do begin
    Cell := Items[RowList[i]][ColList[i]];
    StyleNo := GetFirstTextStyleNo(Cell.GetRVData);
    ParaNo := GetFirstParaStyleNo(Cell.GetRVData);
    if CellsList<>nil then begin
      if (FMainRVData is TCustomRVFormattedData) and (TCustomRVFormattedData(FMainRVData).GetChosenRVData<>nil) then
        ChosenCell := TCustomRVFormattedData(FMainRVData).GetChosenRVData.GetSourceRVData
      else
        ChosenCell := nil;
      CellsList.Add(Cell);
      Cell.Deselect(nil, True);
      Cell.State := Cell.State - [rvstCompletelySelected];
      Cell.MovingToUndoList(ui);
      Cell2 := TRVTableCellData.Create(Items[RowList[i]]);
      Items[RowList[i]][ColList[i]] :=  Cell2;
      Cell2.AssignAttributesFrom(Cell,True,1,1);
      Cell2.AssignSizeFrom(Cell);
      Cell2.Clear;
      {$IFNDEF RVDONOTUSEUNICODE}
      Cell2.AddNLATag('', StyleNo, ParaNo,0);
      {$ELSE}
      Cell2.AddNL('', StyleNo, ParaNo);
      {$ENDIF}
      Cell2.FColSpan := Cell.ColSpan;
      Cell2.FRowSpan := Cell.RowSpan;
      if ChosenCell=Cell then
        TCustomRVFormattedData(FMainRVData).SilentReplaceChosenRVData(Cell2);
      end
    else begin
      Cell.Clear;
      {$IFNDEF RVDONOTUSEUNICODE}
      Cell.AddNLATag('', StyleNo, ParaNo,0);
      {$ELSE}
      Cell.AddNL('', StyleNo, ParaNo);
      {$ENDIF}
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_UnClearCells(CellsList: TList;RowList, ColList: TRVIntegerList);
var i: Integer;
    ChosenCell: TCustomRVData;
begin
  if (FMainRVData is TCustomRVFormattedData) and (TCustomRVFormattedData(FMainRVData).GetChosenRVData<>nil) then
    ChosenCell := TCustomRVFormattedData(FMainRVData).GetChosenRVData.GetSourceRVData
  else
    ChosenCell := nil;
  for i := 0 to RowList.Count-1 do begin
    if ChosenCell=Items[RowList[i]][ColList[i]] then
      TCustomRVFormattedData(FMainRVData).SilentReplaceChosenRVData(TRVTableCellData(CellsList.Items[i]));
    Items[RowList[i]][ColList[i]].Free;
    Items[RowList[i]][ColList[i]] := TRVTableCellData(CellsList.Items[i]);
    TRVTableCellData(CellsList.Items[i]).MovingFromUndoList;    
  end;
  CellsList.Clear;
end;
{------------------------------------------------------------------------------}
function TRVTableRows.Do_BeforeMergeCells(ItemNo, Row, Col, ColSpan, RowSpan: Integer):TRVUndoInfo;
var ui: TRVUndoMerge;
    r,c: Integer;
begin
  ui := nil;
  if (rvtsInserted in FTable.FState) and FTable.IsInEditor then begin
    ui := TRVUndoMerge(AddTableUndoInfo(TRVEditRVData(FMainRVData), TRVUndoMerge,
                               ItemNo, True, True));
    if ui<>nil then begin
      ui.Row          := Row;
      ui.Col          := Col;
      ui.OldColSpan   := Items[Row][Col].ColSpan;
      ui.OldRowSpan   := Items[Row][Col].RowSpan;
      ui.NewColSpan   := ColSpan;
      ui.NewRowSpan   := RowSpan;
      ui.OldBestWidth := Items[Row][Col].BestWidth;
      ui.MergedItemsList := TRVList.Create;
      for r := Row to Row+RowSpan-1 do
        for c := Col to Col+ColSpan-1 do
          if (Items[r][c]<>nil) and
             (Items[r][c]<>Items[Row][Col]) then
          ui.MergedItemsList.Add(TRVUndoMergeItem.Create(FTable,r,c,Row,Col));
    end;
  end;
  Result := ui;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_MergeCells(ItemNo, Row, Col, ColSpan, RowSpan: Integer;
                                     ui: TRVUndoInfo; ChangeBestWidth: Boolean);
var r,c: Integer;
    Vampire, Victim: TRVTableCellData;
begin
  Vampire := Items[Row][Col];
  if ChangeBestWidth then
    Vampire.FBestWidth := GetBestWidth(Row, Col, ColSpan, RowSpan);
  for r := Row to Row+RowSpan-1 do
    for c := Col to Col+ColSpan-1 do begin
      Victim := Items[r].Items[c];
      if (Victim<>Vampire) and (Victim<>nil) then begin
        if Victim.HasData(False) then
          Vampire.DrainFrom(Victim);
        if ItemNo=-1 then
          Victim.Free
        else begin
          Victim.MovingToUndoList(ui);
          Victim.State := Victim.State - [rvstCompletelySelected];
        end;
        Items[r][c] := nil;
      end;
    end;
  Vampire.FColSpan := ColSpan;
  Vampire.FRowSpan := RowSpan;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_UndoMergeCells(ItemNo, Row, Col, OldColSpan, OldRowSpan: Integer;
                                         MergedItemsList: TRVList;
                                         OldBestWidth: TRVHTMLLength);
var i,j,ItemIndex: Integer;
    Vampire: TRVTableCellData;
    UnmergeData: TRVUndoMergeItem;
begin
  Vampire := Items[Row][Col];
  Vampire.FBestWidth := OldBestWidth;
  ItemIndex := Vampire.Items.Count;
  for i := MergedItemsList.Count-1 downto 0 do begin
    UnmergeData := TRVUndoMergeItem(MergedItemsList.Items[i]);
    UnmergeData.Cell.MovingFromUndoList;
    Items[UnmergeData.Row][UnmergeData.Col] := UnmergeData.Cell;
    UnmergeData.Cell.FList := Items[UnmergeData.Row];
    dec(ItemIndex,UnmergeData.ItemCount);
    for j := ItemIndex to ItemIndex+UnmergeData.ItemCount-1 do
      UnmergeData.Cell.AddItemAsIsR(Vampire.Items[j], TCustomRVItemInfo(Vampire.Items.Objects[j]));
  end;
  while Vampire.Items.Count>ItemIndex do
    Vampire.Items.Delete(Vampire.Items.Count-1);
  Vampire.FColSpan := OldColSpan;
  Vampire.FRowSpan := OldRowSpan;
  MergedItemsList.Clear;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_BeforeUnmergeCell(ItemNo, Row, Col: Integer;
  UnmergeRows, UnmergeCols: Boolean);
var ui: TRVUndoUnmerge;
begin
  if (rvtsInserted in FTable.FState) and FTable.IsInEditor then begin
    ui := TRVUndoUnmerge(AddTableUndoInfo(TRVEditRVData(FMainRVData), TRVUndoUnmerge,
                               ItemNo, True, True));
    if ui<>nil then begin
      ui.Row          := Row;
      ui.Col          := Col;
      ui.OldColSpan   := Items[Row][Col].ColSpan;
      ui.OldRowSpan   := Items[Row][Col].RowSpan;
      ui.UnmergeCols   := UnmergeCols;
      ui.UnmergeRows   := UnmergeRows;
      ui.OldBestWidth := Items[Row][Col].BestWidth;
      ui.OldBestHeight := Items[Row][Col].BestHeight;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_UnmergeCell(ItemNo, Row, Col: Integer;
  UnmergeRows, UnmergeCols: Boolean);
var r,w,h, RowSpan: Integer;
    MainCell: TRVTableCellData;
    {.................................................}
    procedure DoUnmergeCols(Row, RowSpan: Integer);
    var c: Integer;
        MainCell: TRVTableCellData;
    begin
      MainCell := Items[Row][Col];
      for c := Col+1 to Col+MainCell.ColSpan-1 do begin
        Items[Row][c] := TRVTableCellData.Create(Items[Row]);
        Items[Row][c].BestWidth := w;
        Items[Row][c].FRowSpan := RowSpan;
        Items[Row][c].AssignAttributesFrom(MainCell,False,0,0);
    end;
    MainCell.FColSpan := 1;
    MainCell.BestWidth := w;
    end;
    {.................................................}
begin
  MainCell := Items[Row][Col];
  if UnmergeCols then begin
    w := MainCell.BestWidth div MainCell.ColSpan;
    if w=0 then
      if MainCell.BestWidth>0 then
        w := 1
      else if MainCell.BestWidth<0 then
        w := -1;
    end
  else
    w := MainCell.BestWidth;

  if UnmergeRows then begin
    h := MainCell.BestHeight div MainCell.RowSpan;
    RowSpan := MainCell.RowSpan;
    for r := Row+1 to Row+RowSpan-1 do begin
      Items[r][Col] := TRVTableCellData.Create(Items[r]);
      Items[r][Col].AssignAttributesFrom( MainCell,True,1,MainCell.RowSpan);
      Items[r][Col].FColSpan := MainCell.ColSpan;
    end;
    MainCell.FRowSpan := 1;
    MainCell.BestHeight := h;
    if UnmergeCols then
      for r := Row to Row+RowSpan-1 do
        DoUnmergeCols(r, 1);
    end
  else if UnmergeCols then
    DoUnmergeCols(Row, MainCell.RowSpan);
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.Do_UndoUnmergeCell(ItemNo, Row, Col: Integer;
                                          OldColSpan, OldRowSpan: Integer;
                                          OldBestWidth: TRVHTMLLength;
                                          OldBestHeight: Integer);
var r,c: Integer;
    MainCell: TRVTableCellData;
begin
  MainCell := Items[Row][Col];
  if OldRowSpan<>MainCell.RowSpan then
    for r := Row+1 to Row+OldRowSpan-1 do
      for c := Col to Col+OldColSpan-1 do begin
        Items[r][c].Free;
        Items[r][c] := nil;
      end;
  if OldColSpan<>MainCell.ColSpan then
    for c := Col+1 to Col+OldColSpan-1 do begin
      Items[Row][c].Free;
      Items[Row][c] := nil;
    end;
  MainCell.FColSpan := OldColSpan;
  MainCell.FRowSpan := OldRowSpan;
  MainCell.FBestWidth  := OldBestWidth;
  MainCell.FBestHeight := OldBestHeight;  
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.InsertCols(Index, Count, CopyIndex: Integer;
                                  DivideWidths: Boolean);
var r,c,mr,mc: Integer;
    ItemNo: Integer;
    cell: TRVTableCellData;
    ForbiddenRows: TRVIntegerList;
begin
  if (Index<0) or (Index>Items[0].Count) or
     (CopyIndex<-1) or (CopyIndex>=Items[0].Count) then
    raise ERichViewError.Create(errInvalidIndex);
  ItemNo := FTable.GetEditorItemNoForUndo;
  if ItemNo<>-1 then
    TRVEditRVData(FMainRVData).Do_ItemModifyTerminator(ItemNo, True);
  ForbiddenRows := TRVIntegerList.CreateEx(Self.Count,0);
  try
    if Index<>Items[0].Count then begin
      r := Self.Count-1;
      while r>=0 do begin
        cell := GetMainCell(r,Index,mr,mc);
        if (mc<Index) and (mc+cell.ColSpan-1>=Index) then begin
          for c := mr to mr+cell.RowSpan-1 do
            ForbiddenRows[c] := 1;
          Do_SetSpan(ItemNo, mr, mc, cell.FColSpan+Count, True);
        end;
        r := mr-1;
      end;
    end;
    r := 0;
    while r<Self.Count do begin
      if ForbiddenRows[r]=0 then begin
        if CopyIndex<>-1 then
          cell := Items[r][CopyIndex]
        else
          cell := nil;
        if (cell<>nil) and DivideWidths then
          FTable.SetCellBestWidth_(ItemNo, cell.BestWidth * cell.ColSpan div (cell.ColSpan+Count),r,CopyIndex);
        for c := 0 to Count-1 do begin
          Do_BeforeInsertCell(ItemNo,r,Index);
          Items[r].Insert(Index);
          if cell<>nil then begin
            FTable.AssignCellAttributes(ItemNo, r, Index, cell, True, Cell.ColSpan,1);
            Do_ChangeEmptyCellStyles(ItemNo, r, Index,
              GetFirstTextStyleNo(cell.GetRVData), GetFirstParaStyleNo(cell.GetRVData));
            Do_SetSpan(ItemNo, r, Index, cell.RowSpan, False);
          end;
        end;
        if cell=nil then
          inc(r)
        else begin
          Do_BeforeInsertEmptyCells(ItemNo,r+1,Index,Count,Cell.RowSpan-1);
          Do_InsertEmptyCells(r+1,Index,Count,Cell.RowSpan-1);
          inc(r,cell.RowSpan);
        end;
        end
      else begin
        Do_BeforeInsertEmptyCells(ItemNo,r,Index,Count,1);
        Do_InsertEmptyCells(r,Index,Count,1);
        inc(r);
      end;
    end;
  finally
    ForbiddenRows.Free;
    if ItemNo<>-1 then
      TRVEditRVData(FMainRVData).Do_ItemModifyTerminator(ItemNo, False);    
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.InsertRows(Index, Count, CopyIndex: Integer;
                                  DivideHeights: Boolean);
var r,c,mr,mc: Integer;
    cell: TRVTableCellData;
    ForbiddenCols: TRVIntegerList;
    ItemNo, ColCount: Integer;
begin
  if (Index<0) or (Index>Self.Count) or
     (CopyIndex<-1) or (CopyIndex>=Self.Count) then
    raise ERichViewError.Create(errInvalidIndex);
  ItemNo := FTable.GetEditorItemNoForUndo;
  if ItemNo<>-1 then
    TRVEditRVData(FMainRVData).Do_ItemModifyTerminator(ItemNo, True);
  ColCount := GetColCount;
  ForbiddenCols := TRVIntegerList.CreateEx(ColCount,0);
  try
    if Index<>Self.Count then begin
      c := ColCount-1;
      while c>=0 do begin
        cell := GetMainCell(Index,c, mr,mc);
        if (mr<Index) and (mr+cell.RowSpan-1>=Index) then begin
          for r := mc to mc+cell.ColSpan-1 do
            ForbiddenCols[r] := 1;
          Do_SetSpan(ItemNo, mr, mc, cell.FRowSpan+Count, False);
        end;
        c := mc-1;
      end;
    end;
    if CopyIndex>=Index then
      inc(CopyIndex,Count);
    Do_BeforeInsertRows(ItemNo, Index,Count);
    Do_InsertRows(Index,Count);
    c := 0;
    while c<ColCount do
      if ForbiddenCols[c]=0 then begin
        if CopyIndex<>-1 then
          cell := Items[CopyIndex][c]
        else
          cell := nil;
        if cell<>nil then begin
          if DivideHeights then
            FTable.SetCellBestHeight_(ItemNo, cell.BestHeight * cell.RowSpan div (cell.RowSpan+Count), CopyIndex,c);
          for r := 0 to Count-1 do begin
            FTable.AssignCellAttributes(ItemNo, Index+r, c, cell, True, 1, cell.RowSpan);
            Do_ChangeEmptyCellStyles(ItemNo, Index+r, c,
              GetFirstTextStyleNo(cell.GetRVData), GetFirstParaStyleNo(cell.GetRVData));
            Do_BeforeSpreadOverEmptyCells(ItemNo, Index+r, c, cell.ColSpan);
            Do_SpreadOverEmptyCells(Index+r, c, cell.ColSpan);
          end;
          inc(c,cell.ColSpan);
          end
        else
          inc(c);
        end
      else begin
        Do_BeforeFreeEmptyCells(ItemNo, Index, c, 1, Count);
        Do_FreeEmptyCells(Index, c, 1, Count);
        inc(c);
      end;
  finally
    ForbiddenCols.Free;
    if ItemNo<>-1 then
      TRVEditRVData(FMainRVData).Do_ItemModifyTerminator(ItemNo, False);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.DeleteRows(Index, Count: Integer; DecreaseHeight: Boolean);
var c,mr,mc,span: Integer;
    cell: TRVTableCellData;
    ItemNo: Integer;
    ui: TRVUndoInfo;
begin
  if (Index<0) or (Index>=Self.Count) or (Count<=0) or
     ((Index=0) and (Count>Self.Count)) then
    raise ERichViewError.Create(errInvalidIndex);
  if Count+Index>Self.Count then
    Count := Self.Count-Index;

  ItemNo := FTable.GetEditorItemNoForUndo;
  if ItemNo<>-1 then
    TRVEditRVData(FMainRVData).Do_ItemModifyTerminator(ItemNo, True);
  try
    c := Items[0].Count-1;
    while c>=0 do begin
      cell := GetMainCell(Index+Count-1,c,mr,mc);
      if mr+cell.RowSpan-1>Index+Count-1 then
        if mr>=Index then begin
          Do_BeforeSplitCellHorz(ItemNo,mr,mc,Index+Count,DecreaseHeight);
          Do_SplitCellHorz(mr,mc,Index+Count,DecreaseHeight);
        end;
      c := mc-1;
    end;
    c := Items[0].Count-1;
    while c>=0 do begin
      cell := GetMainCell(Index,c,mr,mc);
      if mr<Index then begin
        if mr+cell.RowSpan-1<=Index+Count-1 then
          span := (Index-mr)
        else
          span := cell.RowSpan-Count;
        if DecreaseHeight then
          FTable.SetCellBestHeight_(ItemNo, cell.BestHeight * span div cell.RowSpan, mr, mc);
        Do_SetSpan(ItemNo,mr,mc,span,False);
      end;
      c := mc-1;
    end;
    ui := Do_BeforeDeleteRows(ItemNo,Index,Count);
    Do_DeleteRows(ItemNo,Index,Count, ui);
  finally
    if ItemNo<>-1 then
      TRVEditRVData(FMainRVData).Do_ItemModifyTerminator(ItemNo, False);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableRows.DeleteCols(Index, Count: Integer; DecreaseWidth: Boolean);
var r,mr,mc,span: Integer;
    cell: TRVTableCellData;
    ItemNo: Integer;
    ui: TRVUndoInfo;
begin
  if (Index<0) or (Index>=Items[0].Count) or (Count<=0) or
     ((Index=0) and (Count>Items[0].Count)) then
    raise ERichViewError.Create(errInvalidIndex);
  if Count+Index>Items[0].Count then
    Count := Items[0].Count-Index;
  ItemNo := FTable.GetEditorItemNoForUndo;
  if ItemNo<>-1 then
    TRVEditRVData(FMainRVData).Do_ItemModifyTerminator(ItemNo, True);
  try
    r := Self.Count-1;
    while r>=0 do begin
      cell := GetMainCell(r,Index+Count-1,mr,mc);
      if mc+cell.ColSpan-1>Index+Count-1 then
        if mc>=Index then begin
          Do_BeforeSplitCellVert(ItemNo,mr,mc,Index+Count,DecreaseWidth);
          Do_SplitCellVert(mr,mc,Index+Count,DecreaseWidth);
        end;
      r := mr-1;
    end;
    r := Self.Count-1;
    while r>=0 do begin
      cell := GetMainCell(r,Index,mr,mc);
      if mc<Index then begin
        if mc+cell.ColSpan-1<=Index+Count-1 then
          span := (Index-mc)
        else
          span := cell.ColSpan-Count;
        if DecreaseWidth then
          FTable.SetCellBestWidth_(ItemNo, cell.BestWidth * span div cell.ColSpan, mr, mc);
        Do_SetSpan(ItemNo,mr,mc,span,True);
      end;
      r := mr-1;
    end;
    ui := Do_BeforeDeleteCols(ItemNo,Index,Count);
    Do_DeleteCols(ItemNo,Index,Count, ui);
  finally
    if ItemNo<>-1 then
      TRVEditRVData(FMainRVData).Do_ItemModifyTerminator(ItemNo, False);
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableRows.SplitCellVertically(Row, Col, ColCount: Integer): Integer;
var OldColSpan, r, c,mr,mc,mr2,mc2,
    NewColCount, NewColSpan: Integer;
    MainCell,Cell,Cell2: TRVTableCellData;
begin
  Result := 0;
  if ColCount<=1 then
    exit;
  MainCell := Items[Row][Col];
  if MainCell=nil then
    exit;
  OldColSpan := MainCell.ColSpan;
  if OldColSpan>1 then
    UnmergeCell(Row,Col, False, True);
  if OldColSpan<ColCount then begin
    Result := ColCount-OldColSpan;
    for c := Col+OldColSpan-1 downto Col do begin
      if (ColCount=0) or (OldColSpan=0) then
        exit;
      NewColCount := ColCount div OldColSpan;
      InsertCols(c+1, NewColCount-1,c, True);
      r := Count-1;
      while r>=0 do begin
        Cell := GetMainCell(r, c, mr, mc);
        if (mr<>Row) then begin
          Cell2 := GetMainCell(mr, c+NewColCount-1, mr2, mc2);
          inc(mc2, Cell2.ColSpan);
          MergeCells(mr,mc, mc2-mc, Cell.RowSpan, True, True);
        end;
        r := mr-1;
      end;
      dec(ColCount,NewColCount);
      dec(OldColSpan);
    end;
    end
  else if OldColSpan>ColCount then begin
    c := Col+OldColSpan-1;
    while c>=Col do begin
      if (ColCount=0) or (OldColSpan=0) then
        exit;
      NewColSpan := OldColSpan div ColCount;
      dec(c,NewColSpan-1);
      MergeCells(Row, c, NewColSpan, Items[Row][c].RowSpan, True, True);
      dec(OldColSpan, NewColSpan);
      dec(ColCount);
      dec(c);
    end;
    //Assert(ColCount=0);
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableRows.SplitCellHorizontally(Row, Col, RowCount: Integer): Integer;
var OldRowSpan, r, c,mr,mc,mr2,mc2,
    NewRowCount, NewRowSpan: Integer;
    MainCell, Cell, Cell2: TRVTableCellData;
begin
  Result := 0;
  if RowCount<=1 then
    exit;
  MainCell := Items[Row][Col];
  if MainCell=nil then
    exit;
  OldRowSpan := MainCell.RowSpan;
  if OldRowSpan>1 then
    UnmergeCell(Row,Col, True, False);
  if OldRowSpan<RowCount then begin
    Result := RowCount-OldRowSpan;
    for r := Row+OldRowSpan-1 downto Row do begin
      if (RowCount=0) or (OldRowSpan=0) then
        exit;
      NewRowCount := RowCount div OldRowSpan;
      InsertRows(r+1, NewRowCount-1,r, True);
      c := Items[0].Count-1;
      while c>=0 do begin
        Cell := GetMainCell(r, c, mr, mc);
        if (mc<>Col) then begin
          Cell2 := GetMainCell(r+NewRowCount-1, mc, mr2, mc2);
          inc(mr2, Cell2.RowSpan);
          MergeCells(mr,mc, Cell.ColSpan, mr2-mr, True, True);
        end;
        c := mc-1;
      end;
      dec(RowCount,NewRowCount);
      dec(OldRowSpan);
    end;
    end
  else if OldRowSpan>RowCount then begin
    r := Row+OldRowSpan-1;
    while r>=Row do begin
      if (RowCount=0) or (OldRowSpan=0) then
        exit;
      NewRowSpan := OldRowSpan div RowCount;
      dec(r,NewRowSpan-1);
      MergeCells(r, Col, Items[r][Col].ColSpan, NewRowSpan,True, True);
      dec(OldRowSpan, NewRowSpan);
      dec(RowCount);
      dec(r);
    end;
    //Assert(RowCount=0);
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableRows.SplitCellsHorizontally(TopRow, LeftCol, ColSpan,
  RowSpan, RowCount: Integer): Integer;
var r,c,rowadded{,r2,Span}: Integer;
begin
  Result := 0;
  for r := TopRow+RowSpan-1 downto TopRow do begin
    rowadded := 0;
    for c := LeftCol to LeftCol+ColSpan-1 do
      if Items[r][c]<>nil then begin
        {
        if rowadded>0 then begin
          Span := 0;
          for r2 := r+1 to r+rowadded do
            if Items[r2][c]<>nil then
              inc(Span);
          if (Span>0) then begin
            MergeCells(r,c, Items[r][c].ColSpan,Items[r][c].RowSpan+Span,True,True);
          end;
        end;
        }
        inc(rowadded, SplitCellHorizontally(r,c,RowCount));
      end;
    inc(Result,rowadded);
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableRows.SplitCellsVertically(TopRow, LeftCol, ColSpan,
  RowSpan, ColCount: Integer): Integer;
var r,c,coladded{,c2,Span}: Integer;
begin
  Result := 0;
  for c := LeftCol+ColSpan-1 downto LeftCol do begin
    coladded := 0;
    for r := TopRow to TopRow+RowSpan-1 do
      if Items[r][c]<>nil then begin
        {
        if coladded>0 then begin
          Span := 0;
          for c2 := c+1 to c+coladded do
            if Items[r][c2]<>nil then
              inc(Span);
          if (Span>0) then begin
            MergeCells(r,c, Items[r][c].ColSpan+Span,Items[r][c].RowSpan,True,True);
          end;
        end;
        }
        inc(coladded, SplitCellVertically(r,c,ColCount));
      end;
    inc(Result,coladded);
  end;
end;
{========================= TRVTableItemFormattingInfo =========================}
constructor TRVTableItemFormattingInfo.Create(CreateRows:Boolean);
begin
  inherited Create;
  ColWidths  := TRVIntegerList.Create;
  ColStarts  := TRVIntegerList.Create;
  RowHeights := TRVIntegerList.Create;
  RowStarts  := TRVIntegerList.Create;
  if CreateRows then
    Rows := TRVList.Create;
end;
{------------------------------------------------------------------------------}
destructor TRVTableItemFormattingInfo.Destroy;
begin
  ColWidths.Free;
  ColStarts.Free;
  RowHeights.Free;
  RowStarts.Free;
  Rows.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemFormattingInfo.Clear;
begin
  ColWidths.Clear;
  ColStarts.Clear;
  RowHeights.Clear;
  RowStarts.Clear;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemFormattingInfo.QuickClear;
begin
  ColWidths.Count := 0;
  ColStarts.Count := 0;
  RowHeights.Count := 0;
  RowStarts.Count := 0;
end;
{========================== TRVTableItemInfo ==================================}
constructor TRVTableItemInfo.Create(RVData: TPersistent);
begin
  inherited Create(RVData);
  Init(1,1, TCustomRVData(RVData));
  Include(FState, rvtsJustCreated);
end;
{------------------------------------------------------------------------------}
constructor TRVTableItemInfo.CreateEx(nRows, nCols: Integer; AMainRVData: TCustomRVData);
begin
  inherited Create(AMainRVData);
  Init(nRows,nCols, AMainRVData);
  Include(FState, rvtsJustCreated);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.Init(nRows, nCols: Integer; AMainRVData: TCustomRVData);
begin

  Fmt := TRVTableItemFormattingInfo.Create(False);
  StyleNo := rvsTable;
  FRows := TRVTableRows.Create(nRows, nCols, TCustomRVFormattedData(AMainRVData), Self);
  FBorderWidth     := 0;
  FCellBorderWidth := 0;
  FBorderStyle     := rvtbRaised;
  FCellBorderStyle := rvtbLowered;
  FHRuleColor      := clWindowText;
  FVRuleColor      := clWindowText;
  FBorderColor     := clWindowText;
  FCellBorderColor := clWindowText;
  FCellBorderLightColor := clBtnHighlight;
  FBorderLightColor := clBtnHighlight;
  FCellVSpacing    := 2;
  FCellHSpacing    := 2;
  FBorderVSpacing  := 2;
  FBorderHSpacing  := 2;
  FCellHPadding    := 1;
  FCellVPadding    := 1;
  FHRuleWidth      := 0;
  FVRuleWidth      := 0;
  FColor       := clWindow;
  FSelStartCol := -1;
  FSelStartRow := -1;
  FSelColOffs := 0;
  FSelRowOffs := 0;
  FOptions    := RVTABLEDEFAULTOPTIONS;
  FPrintOptions := RVTABLEDEFAULTPRINTOPTIONS;
  Screen.Cursors[crRVSelectCol] := LoadCursor(hInstance, 'RV_SELECTCOL_CURSOR');
  Screen.Cursors[crRVSelectRow] := LoadCursor(hInstance, 'RV_SELECTROW_CURSOR');
  TextRowSeparator := #13#10;
  TextColSeparator := #13#10;
  FocusedCellRow := -1;
  FocusedCellCol := -1;
  ChosenCellRow := -1;
  ChosenCellCol := -1;
  FVisibleBorders := TRVBooleanRect.Create(True);
end;
{------------------------------------------------------------------------------}
destructor TRVTableItemInfo.Destroy;
begin
  ClearTemporal;
  FRows.Free;
  Fmt.Free;
  FBackground.Free;
  FVisibleBorders.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.ClearTemporal;
begin
  if FRows.FMainRVData<>nil then begin
    DestroyInplace(False);
    if FRows.FMainRVData is TCustomRVFormattedData then
      with TCustomRVFormattedData(FRows.FMainRVData) do begin
        UnAssignXorDrawing(Self.XorDrawing);
        ReleaseMouseCapture(Self);
      end;
  end;
  Fmt.Clear;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetHeight(RVStyle: TRVStyle): Integer;
begin
  Result := Fmt.FHeight;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetWidth(RVStyle: TRVStyle): Integer;
begin
  Result := Fmt.FWidth;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetCells(Row, Col: Integer): TRVTableCellData;
begin
  Result := FRows.Items[Row].Items[Col];
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCells(Row, Col: Integer;
  const Value: TRVTableCellData);
begin
  if FRows.Items[Row].Items[Col]<>nil then
    FRows.Items[Row].Items[Col].Assign(Value);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.PaintFullWidth(Left, Right, Top: Integer;
  Canvas: TCanvas; State: TRVItemDrawStates; Style: TRVStyle; const ClipRect: TRect;
  dli: TRVDrawLineInfo; ExtraX, ExtraY: Integer);
begin
  PaintTo(Left, Right, Top, Canvas, State, Style, Fmt, False,
    ClipRect, rvcmColor, nil, nil, ExtraX, ExtraY)
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.PaintTo(Left, Right, Top: Integer;
  Canvas: TCanvas; State: TRVItemDrawStates; Style: TRVStyle;
  Fmt: TRVTableItemFormattingInfo; UseHeadingRowCount: Boolean;
  const ClipRect: TRect; ColorMode: TRVColorMode;
  RVData: TCustomPrintableRVData; Part: TRVTablePrintPart;
  ExtraX, ExtraY: Integer);
var r,c,l,t,h: Integer;
    VRules, HRules, Editing: Boolean;
    DH, DV, DHHalf, DVHalf: Integer;
    SelColor: TColor;
    ClipRect2: TRect;
    RVStyle: TRVStyle;
    CellBorderWidthVPix, CellBorderWidthHPix,
    CellHSpacingPix, CellVSpacingPix,
    CellHPaddingPix, CellVPaddingPix,
    BorderWidthVPix, BorderWidthHPix,
    BorderHSpacingPix, BorderVSpacingPix: Integer;
    {...............................................}
    procedure InitPixLength;
    begin
      CellBorderWidthHPix := RVStyle.GetAsDevicePixelsX(CellBorderWidth, cursad);
      CellBorderWidthVPix := RVStyle.GetAsDevicePixelsY(CellBorderWidth, cursad);

      CellHSpacingPix := RVStyle.GetAsDevicePixelsX(CellHSpacing, cursad);
      CellVSpacingPix := RVStyle.GetAsDevicePixelsY(CellVSpacing, cursad);

      CellHPaddingPix := RVStyle.GetAsDevicePixelsX(CellHPadding, cursad);
      CellVPaddingPix := RVStyle.GetAsDevicePixelsY(CellVPadding, cursad);

      BorderWidthHPix := RVStyle.GetAsDevicePixelsX(BorderWidth, cursad);
      BorderWidthVPix := RVStyle.GetAsDevicePixelsY(BorderWidth, cursad);

      BorderHSpacingPix := RVStyle.GetAsDevicePixelsX(BorderHSpacing, cursad);
      BorderVSpacingPix := RVStyle.GetAsDevicePixelsY(BorderVSpacing, cursad);
    end;
    {...............................................}
    procedure DrawVLine2(X,Y1,Y2,Width: Integer);
    begin
      dec(Y1, ExtraY);
      dec(Y2, ExtraY);
      if Y1<ClipRect2.Top-1 then
        Y1 := ClipRect2.Top-1;
      if Y2>ClipRect2.Bottom+1 then
        Y2 := ClipRect2.Bottom+1;
      dec(X, Width div 2 + ExtraX);
      while Width>0 do begin
        Style.GraphicInterface.Line(Canvas, X,Y1, X,Y2);
        inc(X);
        dec(Width);
      end;
    end;
    {...............................................}
    procedure DrawHLine(Y,X1,X2,Width: Integer);
    begin
      dec(Y, Width div 2 + ExtraY);
      dec(X1, ExtraX);
      dec(X2, ExtraX);
      while Width>0 do begin
        Style.GraphicInterface.Line(Canvas, X1,Y, X2,Y);
        inc(Y);
        dec(Width);
      end;
    end;
    {...............................................}
    function GetExtraPrnVOffs(CellHeight,RowHeight: Integer; VAlign: TRVCellVAlign): Integer;
    begin
      case VAlign of
        rvcMiddle:
          Result := (RowHeight-CellHeight) div 2;
        rvcBottom:
          Result := (RowHeight-CellHeight);
        else
          Result := 0;
      end;
    end;
    {...............................................}
    procedure DrawBackground(const BorderRect: TRect);
    var Clr: TColor;
        BorderRect2: TRect;
    begin
      if FBackground<>nil then begin
        if FColor=clNone then
          Clr := clNone
        else if (Fmt.Rows<>nil) and (rvtoWhiteBackground in PrintOptions) then
          Clr := clWhite
        else
          Clr := RV_GetBackColor(FColor, ColorMode);
        IntersectRect(BorderRect2, BorderRect, ClipRect);
        OffsetRect(BorderRect2, -ExtraX, -ExtraY);
        if Fmt.Rows=nil then
          FBackground.Draw(Canvas, BorderRect2, 0, 0, Left-ExtraX, Top-ExtraY, Fmt.FWidth, Fmt.FHeight,
            Clr, True, rvidsPrintSimulation in State, Style.GraphicInterface)
        else
          FBackground.Print(Canvas, BorderRect2, BorderRect, cursad^, Clr, rvidsPreview in State,
            FRows.FMainRVData.GetRVLogPalette, RVData, 0, Style.GraphicInterface);
        end
      else if FColor<>clNone then begin
        if (Fmt.Rows<>nil) and (rvtoWhiteBackground in PrintOptions) then
          Canvas.Brush.Color := clWhite
        else
          Canvas.Brush.Color := RV_GetBackColor(FColor, ColorMode);
        IntersectRect(BorderRect2, BorderRect, ClipRect);
        OffsetRect(BorderRect2, -ExtraX, -ExtraY);
        Style.GraphicInterface.FillRect(Canvas, BorderRect2);
      end;
    end;
    {...............................................}
    procedure DrawVRules(const BorderRect: TRect);
    var RuleWidth, StartCol, ROffs, c, l: Integer;
    begin
      if VRules then begin
        RuleWidth := RVStyle.GetAsDevicePixelsX(VRuleWidth, cursad);
        DHHalf := (CellHSpacingPix+CellBorderWidthHPix*2+1) div 2;
        StartCol := GetCrossed(ClipRect.Left-Left-
          (BorderWidthHPix+CellHSpacingPix+BorderHSpacingPix), Fmt.ColStarts);
        if HRules and FHOutermostRule then
          ROffs := BorderWidthVPix+BorderVSpacingPix div 2
        else
          ROffs := 0;
        Canvas.Pen.Color := FVRuleColor;
        if FVOutermostRule and (StartCol=0) then begin
          l := Left+BorderWidthHPix+BorderHSpacingPix div 2;
          DrawVLine2(l, BorderRect.Top+ROffs, BorderRect.Bottom-ROffs, RuleWidth);
        end;
        for c := StartCol to ColCount-2 do begin
          l := Left+Fmt.ColStarts[c+1]-DHHalf;
          if l-RuleWidth>ClipRect.Right then
            break;
          DrawVLine2(l, BorderRect.Top+ROffs, BorderRect.Bottom-ROffs, RuleWidth);
        end;
        if FVOutermostRule then begin
          l := Left+Fmt.FWidth-(BorderWidthHPix+BorderHSpacingPix div 2)-1;
          if VRuleWidth mod 2 = 0 then
            inc(l);
          DrawVLine2(l, BorderRect.Top+ROffs, BorderRect.Bottom-ROffs, RuleWidth);
        end;
      end;
    end;
    {...............................................}
    procedure DrawHRules(const BorderRect: TRect; hrc, StartRow, LastRow: Integer);
    var RuleWidth, ROffs, r, t, sr: Integer;
    begin
      if HRules then begin
        RuleWidth := RVStyle.GetAsDevicePixelsY(HRuleWidth, cursad);
        DVHalf := (CellVSpacingPix+CellBorderWidthVPix*2+1) div 2;
        if VRules and FVOutermostRule then
          ROffs := BorderWidthHPix+BorderHSpacingPix div 2
        else
          ROffs := 0;
        Canvas.Pen.Color := FHRuleColor;
        if FHOutermostRule and ((StartRow<2) or (Fmt.Rows<>nil)) then begin
          t := BorderRect.Top+BorderWidthVPix+BorderVSpacingPix div 2;
          DrawHLine(t, Left+ROffs, Left+Fmt.FWidth-ROffs, RuleWidth);
        end;
        if hrc>0 then
          for r := 0 to hrc-2 do begin
            t := Top+Fmt.RowStarts[r+1]-DVHalf;
            if t-RuleWidth>ClipRect.Bottom then
              break;
            DrawHLine(t, Left+ROffs, Left+Fmt.FWidth-ROffs, RuleWidth);
          end;
        if LastRow>=StartRow then begin
          if (Fmt.Rows<>nil) and (Part=nil) then
            dec(Top, Fmt.RowStarts[StartRow]-Fmt.RowStarts[hrc]);
          sr := StartRow;
          if hrc>0 then
            dec(sr);
          if sr<0 then
            sr := 0;
          for r := sr to LastRow-1 do begin
            if Part=nil then
              t := Top+Fmt.RowStarts[r+1]-DVHalf
            else
              t := Top+Part.FRowStarts[r-StartRow+1]+CellBorderWidthVPix-DVHalf;
            if t-RuleWidth>ClipRect.Bottom then
              break;
            DrawHLine(t, Left+ROffs, Left+Fmt.FWidth-ROffs, RuleWidth);
          end;
          if (Fmt.Rows<>nil) and (Part=nil) then
            inc(Top, Fmt.RowStarts[StartRow]-Fmt.RowStarts[hrc]);
        end;
        if FHOutermostRule then begin
          t := BorderRect.Bottom-(BorderWidthVPix+BorderVSpacingPix div 2)-1;
          if RuleWidth mod 2 = 0 then
            inc(t);
          DrawHLine(t, Left+ROffs, Left+Fmt.FWidth-ROffs, RuleWidth);
        end;
      end;
    end;
    {...............................................}
    procedure DrawCell(r,c,h, DV, DH, l,t, RowFromTop, CellPage: Integer;
      Canvas: TCanvas; const ClipRect, BorderRect: TRect; DrawContent: Boolean);
    var cw,ch, i,idx, DocHeight: Integer;
        Cell: TRVTableCellData;
        CanDrawBitmappedBack,WasSelected: Boolean;
        CellColor: TColor;
        CPD: TCellPtblRVData;
        BColor, BLColor: TColor;
        CellRect, CellRect2: TRect;
        Rgn: HRGN;
        RgnValid: Boolean;
        {$IFDEF RVDEBUGTABLE}
        DebugText: String;
        {$ENDIF}
    begin
      Cell := Cells[r,c];
      if Fmt.Rows=nil then begin
        idx := 0;
        ch  := Cell.FHeight;
        cw  := Cell.FWidth;
        end
      else begin
        idx := r*ColCount+c;
        if Fmt.Rows[idx]<>nil then begin
          ch := TCellPtblRVData(Fmt.Rows[idx]).Height + CellVPaddingPix*2;
          cw := TCellPtblRVData(Fmt.Rows[idx]).Width  + CellHPaddingPix*2;
          end
        else begin
          ch := h + CellVPaddingPix*2;
          for i := 1 to Cell.RowSpan-1 do
            inc(ch, Fmt.RowHeights[r+i]+DV);
          cw := Fmt.ColWidths[c] + CellHPaddingPix*2;
          for i := 1 to Cell.ColSpan-1 do
            inc(cw, Fmt.ColWidths[c+i]+DH);
        end;
        if (Part<>nil) and (RowFromTop>=0) then begin
          ch := RowFromTop+(r-Part.FRowIndices[RowFromTop])+Cell.RowSpan;
          if ch>=Part.FRowStarts.Count then
            ch := Part.FRowStarts.Count-1;
          ch := Part.FRowStarts[ch]-Part.FRowStarts[RowFromTop]-
            (CellVSpacingPix+CellBorderWidthVPix*2);
        end;
      end;
      CellColor := clNone;
      if rvidsSelected in State then begin
        WasSelected := rvstCompletelySelected in Cells[r,c].State;
        CellColor := SelColor;
        Include(Cells[r,c].State, rvstCompletelySelected);
        CanDrawBitmappedBack := False;
        end
      else begin
        CanDrawBitmappedBack := not ((Fmt.Rows=nil) and IsCellSelected(r,c) and
          not (rvidsPrinting in State));
        if not CanDrawBitmappedBack then
          CellColor := SelColor;
        WasSelected := True;
      end;
      if not CanDrawBitmappedBack then
        CanDrawBitmappedBack := SelColor=clNone;
      if CellColor=clNone then
        CellColor := Cells[r,c].Color;
      if (Fmt.Rows=nil) and (CellColor=clNone) and (FInplaceEditor<>nil) and
         (TRVTableInplaceEdit(FInplaceEditor).FCell=Cell) and
         TRVTableInplaceEdit(FInplaceEditor).NormalScrolling and
         not (rvidsDrawInplaceOnMainCanvas in State) then
        CellColor := clWindow;
      if (CellColor<>clNone) or (Cell.FBackground<>nil) then begin
        if (Fmt.Rows<>nil) and (rvtoWhiteBackground in PrintOptions) then
          CellColor := clWhite;
        CellColor := RV_GetBackColor(CellColor, ColorMode);
        Canvas.Brush.Color := CellColor;
        Canvas.Pen.Color   := CellColor;
        CellRect := Bounds(l, t, cw, ch);
        if rvtoCellBelowBorders in Options then
          InflateRect(CellRect, CellBorderWidthHPix, CellBorderWidthVPix);
        if (Fmt.Rows=nil) and (FInplaceEditor<>nil) and
           (TRVTableInplaceEdit(FInplaceEditor).FCell=Cell) and
           TRVTableInplaceEdit(FInplaceEditor).NormalScrolling and
           not (rvidsDrawInplaceOnMainCanvas in State) then begin
          Style.GraphicInterface.SetDiagonalBrush(Canvas,
            CellColor, CellBorderColor, l, t);
          CanDrawBitmappedBack := False;
        end;
        if CanDrawBitmappedBack and (Cell.FBackground<>nil) then begin
          if Fmt.Rows=nil then
            Cell.FBackground.Draw(Canvas, CellRect, 0, 0, CellRect.Left, CellRect.Top,
              CellRect.Right-CellRect.Left, CellRect.Bottom-CellRect.Top, CellColor,
                True, rvidsPrintSimulation in State, Style.GraphicInterface)
          else begin
            CellRect2 := CellRect;
            OffsetRect(CellRect2,-CellRect2.Left,-CellRect2.Top);
            OffsetRect(CellRect2,BorderRect.Left,BorderRect.Top);
            Cell.FBackground.Print(Canvas, CellRect, CellRect2, cursad^, CellColor,
              rvidsPreview in State, FRows.FMainRVData.GetRVLogPalette, RVData, 1,
              Style.GraphicInterface);
          end;
          end
        else if CellColor<>clNone then
          Style.GraphicInterface.FillRect(Canvas, CellRect);
        Canvas.Brush.Style := bsSolid;
      end;
      if DrawContent then begin
        if Fmt.Rows=nil then begin
          Style.GraphicInterface.IntersectClipRectEx(Canvas, l, t, l+cw, t+ch,
            Rgn, RgnValid);
          try
            if (rvidsDrawInplaceOnMainCanvas in State) and
               (FInplaceEditor<>nil) and
               (TRVTableInplaceEdit(FInplaceEditor).FRow=r) and
               (TRVTableInplaceEdit(FInplaceEditor).FCol=c) then begin
              TRVTableInplaceRVData(FInplaceEditor.RVData).DrawOnParentMode := True;
              try
                FInplaceEditor.RVData.PaintTo(Canvas, ClipRect, False, False,
                rvidsDrawInplaceOnMainCanvas in State, rvidsPrintSimulation in State,
                ExtraX, ExtraY, 0, FInplaceEditor.RVData.ItemCount-1);
              finally
                TRVTableInplaceRVData(FInplaceEditor.RVData).DrawOnParentMode := False;
              end;
            end;
            Cell.PaintTo(Canvas, ClipRect, False, False,
              rvidsDrawInplaceOnMainCanvas in State, rvidsPrintSimulation in State,
              ExtraX, ExtraY, 0, Cell.ItemCount-1);
          finally
            Style.GraphicInterface.RestoreClipRgn(Canvas, Rgn, RgnValid);
          end;
          {$IFDEF RVDEBUGTABLE}
          if Cell.BestWidth>0 then begin
            Canvas.Pen.Style := psSolid;
            Canvas.Pen.Color := clRed;
            Style.GraphicInterface.Line(Canvas,
              l+CellHPadding,                t+1,
              l+CellHPadding+Cell.BestWidth, t+1);
          end;
          if Cell.BestHeight>0 then begin
            Canvas.Pen.Style := psSolid;
            Canvas.Pen.Color := clGreen;
            Style.GraphicInterface.Line(Canvas,
              l, t+CellVPadding,
              l, t+CellVPadding+Cell.BestHeight);
          end;
          Canvas.Font.Color := clBlack;
          Canvas.Font.Name := 'Small Fonts';
          Canvas.Font.Size := 6;
          DebugText := IntToStr(Cells[r,c].BestWidth)+','+IntToStr(Cells[r,c].BestHeight);
          Style.GraphicInterface.TextOut_(Canvas, l,t,
            PChar(DebugText), Length(DebugText));
          {$ENDIF}

          end
        else begin
          if Fmt.Rows[idx]<>nil then begin
            CPD := TCellPtblRVData(Fmt.Rows[idx]);
            CPD.Left := Left;
            if (CPD.Pages<>nil) and (CellPage<=CPD.Pages.Count) then
              DocHeight := CPD.Pages[CellPage-1].DocumentHeight
            else
              DocHeight := CPD.DocumentHeight;
            CPD.Top := Top + GetExtraPrnVOffs(DocHeight,
              ch-CellVPaddingPix*2, Cells[r,c].GetRealVAlign);
            if (Part<>nil) and (RowFromTop>=0) then
              CPD.DY := Part.FRowStarts[RowFromTop]+CellVPaddingPix+CellBorderWidthVPix;
            FPrintCell := Cell;
            Style.GraphicInterface.IntersectClipRectEx(Canvas, l, t, l+cw, t+ch,
              Rgn, RgnValid);
            try
              FPrintCellRect := Bounds(l,t,cw,ch);
              OffsetRect(FPrintCellRect,-BorderRect.Left,-BorderRect.Top);
              RV_RectToScreen(FPrintCellRect, cursad^);
              CPD.AssignItemsFrom(Cells[r,c].GetRVData);
              if (FInplaceEditor<>nil) and (TRVTableInplaceEdit(FInplaceEditor).FCell=Cells[r,c]) then begin
                CPD.FSourceDataForPrinting := TRVTableInplaceEdit(FInplaceEditor).FCell;
                CPD.DrawPage(CellPage, Canvas, rvidsPreview in State, rvidsPreviewCorrection in State);
                CPD.FSourceDataForPrinting := Cells[r,c];
                end
              else begin
                CPD.DrawPage(CellPage, Canvas, rvidsPreview in State, rvidsPreviewCorrection in State);
              end;
              FPrintCell := nil;
            finally
              Style.GraphicInterface.RestoreClipRgn(Canvas, Rgn, RgnValid);
            end;
          end;
        end;
      end;
      if Cell.BorderColor <> clNone then
        BColor := Cell.BorderColor
      else
        BColor := CellBorderColor;
      if Cell.BorderLightColor <> clNone then
        BLColor := Cell.BorderLightColor
      else
        BLColor := CellBorderLightColor;
      DrawBorder(Canvas, l-CellBorderWidthHPix,t-CellBorderWidthVPix,
        l+cw+CellBorderWidthHPix,t+ch+CellBorderWidthVPix,
        FCellBorderWidth, BLColor, BColor, Color, CellBorderStyle,
        not (rvtoHideGridLines in Options), Editing,
        rvidsPrinting in State, ClipRect2, Cell.VisibleBorders, r, c, ColorMode,
        Style.GraphicInterface);
      if not WasSelected then
        Exclude(Cell.State, rvstCompletelySelected);
    end;
    {...............................................}
var StartRow, LastRow:Integer;
    mr,mc, hrc, CellPage: Integer;
    BorderRect: TRect;
begin
  RVStyle := GetRVStyle;

  InitPixLength;

  if TRVScroller(Rows.FMainRVData.GetRootData.GetParentControl).FocusedEx then
    SelColor := Rows.FMainRVData.GetRVStyle.SelColor
  else
    SelColor := Rows.FMainRVData.GetRVStyle.InactiveSelColor;
  //Editing := rvtsEditMode in FState;
  //if Editing then
    Editing := (FRows.FMainRVData.GetAbsoluteRootData is TRVEditRVData) and
      not TCustomRichViewEdit(TRVEditRVData(FRows.FMainRVData.GetAbsoluteRootData).RichView).ReadOnly;
  MyClientLeft := Left;
  MyClientTop  := Top;
  ClipRect2 := ClipRect;
  OffsetRect(ClipRect2, -ExtraX, -ExtraY);
  VRules := (FVRuleWidth<>0) and (FVRuleColor<>clNone);
  HRules := (FHRuleWidth<>0) and (FHRuleColor<>clNone);
  DH := CellHPaddingPix+CellHSpacingPix+CellHPaddingPix+CellBorderWidthHPix*2;
  DV := CellVPaddingPix+CellVSpacingPix+CellVPaddingPix+CellBorderWidthVPix*2;
  if Fmt.Rows=nil then begin
    StartRow := GetCrossed(ClipRect.Top-Top-BorderWidthVPix, Fmt.RowStarts);
    LastRow  := RowCount-1;
    BorderRect := Bounds(Left,Top,Fmt.FWidth,Fmt.FHeight);
    hrc := 0;
    end
  else begin
    if Part<>nil then begin
      StartRow := Part.FRowIndices[0];
      LastRow  := Part.FRowIndices[Part.FRowIndices.Count-2];
      end
    else begin
      StartRow := 0;
      LastRow  := RowCount-1;
    end;
    if UseHeadingRowCount then begin
      hrc := HeadingRowCount;
      if hrc>StartRow then
        hrc := StartRow;
      end
    else
      hrc := 0;
    BorderRect := Bounds(Left, Top, Fmt.FWidth,
      Fmt.RowStarts[0]+Fmt.FHeight-Fmt.RowStarts[RowCount-1]-
      Fmt.RowHeights[RowCount-1]);
    if LastRow>=StartRow then
      if Part=nil then
        inc(BorderRect.Bottom,
          Fmt.RowStarts[LastRow]+Fmt.RowHeights[LastRow]-Fmt.RowStarts[StartRow])
      else
        BorderRect.Bottom := Top+Part.Height-Part.FHeadingHeight;
    if hrc>0 then begin
      inc(BorderRect.Bottom,
        Fmt.RowStarts[hrc-1]+Fmt.RowHeights[hrc-1]-Fmt.RowStarts[0]);
      if LastRow>=StartRow then
        inc(BorderRect.Bottom,
          Fmt.RowStarts[hrc]-(Fmt.RowStarts[hrc-1]+Fmt.RowHeights[hrc-1]));
    end;
    //dec(Top, Fmt.RowStarts[FromRow]-Fmt.RowStarts[0]);
  end;
  DrawBackground(BorderRect);
  Canvas.Pen.Width := 1;
  Canvas.Pen.Style := psSolid;
  DrawVRules(BorderRect);
  DrawHRules(BorderRect, hrc, StartRow, LastRow);
  DrawBorder(Canvas, BorderRect.Left-ExtraX,BorderRect.Top-ExtraY,
    BorderRect.Right-ExtraX,BorderRect.Bottom-ExtraY, BorderWidth, BorderLightColor, BorderColor,
    Rows.FMainRVData.GetColor, BorderStyle,
    not (rvtoHideGridLines in Options), Editing,
    rvidsPrinting in State,  ClipRect2, VisibleBorders, -1, -1, ColorMode,
    Style.GraphicInterface);
  if (StartRow>0) and (StartRow<RowCount) and (Part=nil) then begin
    c := ColCount-1;
    while c>=0 do begin
      Rows.GetMainCell(StartRow,c,mr,mc);
      if mr<StartRow then
        DrawCell(mr, mc, Fmt.RowHeights[mr], DV, DH,
                 Fmt.ColStarts[mc]+Left-ExtraX,Fmt.RowStarts[mr]+Top-ExtraY, -1, 1,
                 Canvas, ClipRect, BorderRect, True);
      c := mc-1;
    end;
  end;
  if hrc>0 then
    for r := 0 to hrc-1 do begin
      t := Fmt.RowStarts[r]+Top;
      if t-CellBorderWidthVPix>ClipRect.Bottom then
        break;
      h := Fmt.RowHeights[r];
      for c := 0 to ColCount-1 do begin
        l := Fmt.ColStarts[c]+Left;
        if l-CellBorderWidthHPix>ClipRect.Right then break;
        if Cells[r,c]<>nil then
          DrawCell(r,c,h, DV, DH, l-ExtraX,t-ExtraY, -1, 1, Canvas, ClipRect, BorderRect, True);
      end;
    end;
  if LastRow>=StartRow then begin
    if (Fmt.Rows<>nil) and (Part=nil) then
      dec(Top, Fmt.RowStarts[StartRow]-Fmt.RowStarts[hrc]);
    for r := StartRow to LastRow do begin
      if Part=nil then
        t := Fmt.RowStarts[r]
      else
        t := Part.FRowStarts[r-StartRow]+CellBorderWidthVPix;
      inc(t, Top);
      if t-CellBorderWidthVPix>ClipRect.Bottom then
        break;
      h := Fmt.RowHeights[r];
      for c := 0 to ColCount-1 do begin
        l := Fmt.ColStarts[c]+Left;
        if l-CellBorderWidthHPix>ClipRect.Right then
          break;
        if (Part<>nil) and (r=StartRow) and (Part.FTableTopCutLine<>nil) then
          CellPage := Part.FTableTopCutLine[c]
        else
          CellPage := 1;
        if Cells[r,c]<>nil then
          DrawCell(r,c,h, DV, DH, l-ExtraX,t-ExtraY, r-StartRow, CellPage, Canvas, ClipRect,
            BorderRect, CellPage>=1)
        else if (Part<>nil) and (r=StartRow) then begin
          Rows.GetMainCell(r,c,mr,mc);
          if (c=mc) then
            DrawCell(mr,mc,h, DV, DH, l-ExtraX,t-ExtraY, r-StartRow, CellPage, Canvas, ClipRect,
              BorderRect, (CellPage>=1) and ((r=mr) or (Part.FTableTopCutLine<>nil)));
        end;
      end;
      if (r>0) and (RVData=nil) and (rvoShowPageBreaks in Rows.FMainRVData.Options) and
         (Rows.FMainRVData is TCustomRVFormattedData) and
         Rows[r].PageBreakBefore then begin
        Style.DrawPageBreak(Canvas, t, TCustomRVFormattedData(Rows.FMainRVData).GetHOffs,
          rvpbPageBreak, Rows.FMainRVData.GetParentControl,
          Rows.FMainRVData, GetMyItemNo);
      end;
    end;
  end;
  Canvas.Pen.Width := 1;
  {
  if Part<>nil then begin
    Canvas.Pen.Color := clRed;
    for c := 0 to Part.FRowStarts.Count-1 do begin
      Canvas.MoveTo(Left-10, Top+Part.FRowStarts[c]);
      Canvas.LineTo(Left+30, Top+Part.FRowStarts[c]);
    end;
    Canvas.Pen.Color := clBlue;
    for c := 0 to Fmt.RowStarts.Count-1 do begin
      Canvas.MoveTo(Left-10, Top+Fmt.RowStarts[c]-RV_YToDevice(CellBorderWidth, cursad^));
      Canvas.LineTo(Left+30, Top+Fmt.RowStarts[c]-RV_YToDevice(CellBorderWidth, cursad^));
    end;
  end;
  }
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.DrawBackgroundUnderCell(Canvas: TCanvas;
  Cell: TRVTableCellData; const Rect: TRect; GraphicInterface: TRVGraphicInterface);
var r: TRect;
    Clr: TColor;
begin
  Clr := GetTableColor(False);
  if FBackground<>nil then
    FBackground.Draw(Canvas, Rect, 0, 0,
      -Cell.Left, -Cell.Top-Cell.GetExtraVOffs,
      GetWidth(GetRVStyle), GetHeight(GetRVStyle), Clr, False, False,
      GraphicInterface)
  else if Clr<>clNone then begin
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := Clr;
    r := Rect;
    OffsetRect(r, -r.Left, -r.Top);
    GraphicInterface.FillRect(Canvas, r);
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.IsSemiTransparentBackground: Boolean;
begin
  Result := (FColor=clNone) and (FBackground<>nil) and FBackground.IsSemitransparent; 
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetHorzExtraPix: Integer;
var RVStyle: TRVStyle;
begin
  RVStyle := GetRVStyle;
  Result :=
    ((RVStyle.GetAsDevicePixelsX(BorderWidth, cursad)+
      RVStyle.GetAsDevicePixelsX(BorderHSpacing, cursad))*2+
     RVStyle.GetAsDevicePixelsX(CellHSpacing, cursad)*(ColCount-1))+
    ColCount*RVStyle.GetAsDevicePixelsX(CellBorderWidth, cursad)*2;
end;
{------------------------------------------------------------------------------}
{
function TRVTableItemInfo.GetHorzExtra: TRVStyleLength;
begin
  Result := ((BorderWidth+BorderHSpacing)*2+
    CellHSpacing*(ColCount-1))+ColCount*CellBorderWidth*2;
end;
}
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetMinWidth(sad: PRVScreenAndDevice; Canvas: TCanvas;
  RVData: TPersistent): Integer;
begin
  Result := DoGetMinWidth(sad, Canvas, True);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.DoGetMinWidth(sad: PRVScreenAndDevice; Canvas: TCanvas;
  UseTableWidth: Boolean): Integer;
var ColWidths: TRVIntegerList;
    MinColsWidth, CellHPaddingPix, BorderWidthPix, BorderHSpacingPix,
    CellHSpacingPix, CellBorderWidthPix: Integer;
    RVStyle: TRVStyle;
    {.................................................}
    procedure CalcMinWidths;
    var c,w,w2: Integer;
    begin
      MinColsWidth := 0;
      for c := 0 to ColCount-1 do begin
        if rvtoIgnoreContentWidth in Options then
          w := 0
        else
          w := Rows.GetMinColWidth(c,sad,Canvas);
        if (BestWidth=0) and UseTableWidth then begin
          w2 := RVStyle.GetAsDevicePixelsX(Rows.GetRVSLengthColWidth(c), cursad);
          if w2>w then
            w := w2;
        end;
        inc(MinColsWidth, w);
        ColWidths.Add(w);
      end;
    end;
    {.................................................}
    procedure ExpandCols(Row,Col, Width, Depth: Integer);
    var c, oldw, neww, savedw, pureoldw, DH, UnsizedCount, DblPadding: Integer;
        Cell: TRVTableCellData;
        AddProportionally: Boolean;
    const MAXDEPTH = 30;
    begin
      if Width<=0 then
        exit;
      AddProportionally := {True or }(Depth>MAXDEPTH);
      savedw := Width;
      inc(Width, CellHPaddingPix*2);
      Cell := Cells[Row,Col];
      DH := CellHPaddingPix+CellHSpacingPix+CellHPaddingPix+CellBorderWidthPix*2;
      oldw := -CellHSpacingPix-CellBorderWidthPix*2;
      pureoldw := 0;
      UnsizedCount := 0;
      DblPadding := CellHPaddingPix*2;
      for c := Col to Col+Cell.ColSpan-1 do begin
        inc(oldw, ColWidths[c]+DH);
        if AddProportionally and (ColWidths[c]+DblPadding=0) then
          inc(pureoldw, 1)
        else
          inc(pureoldw, ColWidths[c]+DblPadding);
        inc(UnsizedCount);
      end;
      if AddProportionally then begin
        for c := Col to Col+Cell.ColSpan-1 do begin
          oldw := ColWidths[c]+DblPadding;
          if oldw=0 then
            inc(oldw);
          Width := MulDiv(oldw,DH,pureoldw);
          ColWidths[c] := Width-DblPadding;
          dec(pureoldw, oldw);
          dec(DH,Width);
          inc(MinColsWidth, Width-oldw);
        end;
        exit;
      end;
      if (oldw<Width) and (UnsizedCount<>0) then begin
        DH := Width-oldw;
        inc(DH, pureoldw);
        for c := Col to Col+Cell.ColSpan-1 do begin
          if (UnsizedCount=0) or (DH<=0) then
            break;
          oldw := ColWidths[c]+DblPadding;
          neww := Round(DH/UnsizedCount);
          if oldw>=neww then begin
            dec(DH, oldw);
            dec(UnsizedCount);
          end;
        end;
        for c := Col to Col+Cell.ColSpan-1 do begin
          if (UnsizedCount=0) or (DH<=0) then
            break;
          oldw := ColWidths[c]+DblPadding;
          neww := Round(DH/UnsizedCount);
          if oldw<neww then begin
            ColWidths[c] := neww-DblPadding;
            inc(MinColsWidth, neww-oldw);
            dec(DH, neww);
            dec(UnsizedCount);
          end;
        end;
        ExpandCols(Row,Col, savedw, Depth+1);
      end;
    end;
    {.................................................}
    procedure CalcMinWidthsSpan;
    var r,c,w,w2: Integer;
        PixColWidths: TRVIntegerList;
    begin
      PixColWidths := nil;
      try
        for r := 0 to RowCount-1 do
          with Rows[r] do
            for c := 0 to ColCount-1 do
              if (Items[c]<>nil) and (Items[c].ColSpan>1) then begin
                if rvtoIgnoreContentWidth in Options then
                  w := 0
                else
                  w := Items[c].GetMinWidth(sad,Canvas);
                if (BestWidth=0) and UseTableWidth then begin
                  w2 := RVStyle.GetAsDevicePixelsX(Items[c].BestWidth, cursad);
                  if w2>w then
                    w := w2;
                  ExpandCols(r,c, w, 0);
                  end
                else
                  ExpandColsForMinWidthConstrained(r, c, w,
                    ColWidths, PixColWidths, MinColsWidth);
              end;
      finally
        PixColWidths.Free;
      end;
    end;
    {.................................................}
var oldsad: PRVScreenAndDevice;
begin
  RVStyle := GetRVStyle;
  oldsad := cursad;
  cursad := sad;
  try
   CellHPaddingPix := RVStyle.GetAsDevicePixelsX(CellHPadding, cursad);
   BorderWidthPix  := RVStyle.GetAsDevicePixelsX(BorderWidth,  cursad);
   BorderHSpacingPix  := RVStyle.GetAsDevicePixelsX(BorderHSpacing, cursad);
   CellHSpacingPix    := RVStyle.GetAsDevicePixelsX(CellHSpacing, cursad);
   CellBorderWidthPix := RVStyle.GetAsDevicePixelsX(CellBorderWidth, cursad);
    if Rows.Empty then begin
      Result := (BorderWidthPix+BorderHSpacingPix)*2;
      cursad := oldsad;
      exit;
    end;
    Result := GetHorzExtraPix+CellHPaddingPix*ColCount*2;
    MinColsWidth := 0;
    ColWidths := TRVIntegerList.Create;
    try
      CalcMinWidths;
      CalcMinWidthsSpan;
    finally
      ColWidths.Free;
    end;
    inc(Result, MinColsWidth);
    if UseTableWidth and (RVStyle.GetAsDevicePixelsX(BestWidth, cursad)>Result) then
      Result := RVStyle.GetAsDevicePixelsX(BestWidth, cursad);
  finally
    cursad := oldsad;
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.IsFixedWidthTable: Boolean;
var r,c,mr,mc: Integer;
    cell: TRVTableCellData;
    definedwidth: Boolean;
begin
  Result := False;
  if Rows.IsEmptyRows(0,0,ColCount,RowCount,0,0) then
    exit;
  for c := 0 to ColCount-1 do begin
    definedwidth := False;
    for r := 0 to RowCount-1 do begin
      cell := Rows.GetMainCell(r,c,mr,mc);
      if cell.BestWidth<0 then
        exit;
      if (mc+cell.ColSpan-1=c) and (cell.BestWidth>0) then
        definedwidth := True;
    end;
    if not definedwidth then
      exit;
  end;
  Result := True;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.OnDocWidthChange(DocWidth: Integer; dli: TRVDrawLineInfo;
  Printing: Boolean; Canvas: TCanvas; RVData: TPersistent; sad: PRVScreenAndDevice;
  var HShift, Desc: Integer; NoCaching, Reformatting, UseFormatCanvas: Boolean);
begin
  HShift := 0;
  Desc   := 0;
  if not Printing then begin
    if (rvtsModified in FState) then begin
      Exclude(FState, rvtsModified);
      Fmt.FWidth := 0;
    end;
    InternalOnDocWidthChange(DocWidth, Fmt, Canvas, NoCaching, Reformatting,
      UseFormatCanvas, TCustomRVData(RVData).GetRVStyle.GraphicInterface)
    end
  else
    try
      cursad := @(TRVTablePrintInfo(dli).sad);
      InternalOnDocWidthChange(DocWidth, (dli as TRVTablePrintInfo).Fmt, Canvas,
        False, False, False,
        TCustomRVData(RVData).GetRVStyle.GraphicInterface);
      dli.Width := TRVTablePrintInfo(dli).Fmt.FWidth;
      dli.Height := TRVTablePrintInfo(dli).Fmt.FHeight;
    finally
      cursad := nil;
    end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.ExpandColsForMinWidthConstrained(Row,Col, Width: Integer;
  ColWidths: TRVIntegerList; var PixColWidths: TRVIntegerList;
  var MinColsWidth: Integer);
var c, oldw, DH: Integer;
    Cell: TRVTableCellData;
    PureOldWidth, OldWidth: Integer;
    PurePixWidth, PixWidth, PixColCount, MinOtherWidth: Integer;
    AllowedCols: TRVIntegerList;
    Changed: Boolean;
    RVStyle: TRVStyle;
    CellHPaddingPix, DblCellHPaddingPix, CellHSpacingPix, CellBorderWidthPix: Integer;
    {.............................................................}
    procedure DistributeToMakeEqual;
    var c, UnsizedCount, Count, TotalWidth, w: Integer;
    begin
      Count := Cell.ColSpan;
      AllowedCols := TRVIntegerList.CreateEx(Count, 1);
      try
        // allowing only columns with non-pixels sizes
        for c := 0 to Cell.ColSpan-1 do
          if PixColWidths[Col+c]<>0 then begin
            AllowedCols[c] := 0;
            dec(Count);
          end;
        if Count>0 then begin
          UnsizedCount := Count;
          TotalWidth := Width-OldWidth+PureOldWidth;
          w := TotalWidth div UnsizedCount; // ideal column width
          // excluding too wide columns
          repeat
            Changed := False;
            for c := 0 to Cell.ColSpan-1 do
              if (AllowedCols[c]<>0) and (ColWidths[Col+c]+DblCellHPaddingPix>w) then begin
                dec(UnsizedCount);
                dec(TotalWidth, ColWidths[Col+c]+DblCellHPaddingPix);
                AllowedCols[c] := 0;
                Changed := True;
              end;
            if UnsizedCount=0 then
              break;
            if Changed then
              w := TotalWidth div UnsizedCount; // ideal column width
          until not Changed;
          if UnsizedCount=0 then begin
            // must not happen...
            for c := 0 to Cell.ColSpan-1 do
              if PixColWidths[Col+c]=0 then
                AllowedCols[c] := 1;
            TotalWidth := Width-OldWidth+PureOldWidth;
            UnsizedCount := Count;
            w := TotalWidth div UnsizedCount;
          end;
          // distributing widths
          for c := 0 to Cell.ColSpan-1 do
            if AllowedCols[c]<>0 then begin
              oldw := ColWidths[Col+c]+DblCellHPaddingPix;
              if oldw<w then begin
                ColWidths[Col+c] := w-DblCellHPaddingPix;
                inc(MinColsWidth, w-oldw);
                dec(TotalWidth, w);
                dec(UnsizedCount);
                if UnsizedCount=0 then
                  break;
                w := TotalWidth div UnsizedCount;
              end;
            end;
        end;
      finally
        AllowedCols.Free;
      end;
    end;
    {.............................................................}
    procedure DistributeProportionally(DoNotExceed: Boolean);
    var c, UnsizedCount, Count, TotalWidth, w, StoredPurePixWidth,
        CurTotalWidth, CurPurePixWidth: Integer;
    begin
      Count := Cell.ColSpan;
      StoredPurePixWidth := PurePixWidth;
      AllowedCols := TRVIntegerList.CreateEx(Count, 1);
      try
        // allowing only columns with pixels sizes
        for c := 0 to Cell.ColSpan-1 do
          if PixColWidths[Col+c]=0 then begin
            AllowedCols[c] := 0;
            dec(Count);
          end;
        UnsizedCount := Count;
        TotalWidth := Width-PixWidth+PurePixWidth;
        // excluding too wide columns
        repeat
          Changed := False;
          CurPurePixWidth := PurePixWidth;
          CurTotalWidth := TotalWidth;
          for c := 0 to Cell.ColSpan-1 do
            if (AllowedCols[c]<>0) then begin
              oldw := ColWidths[Col+c]+DblCellHPaddingPix;
              w := MulDiv(PixColWidths[Col+c]+DblCellHPaddingPix, CurTotalWidth, CurPurePixWidth);
              if DoNotExceed and (w>PixColWidths[Col+c]+DblCellHPaddingPix) then
                w := PixColWidths[Col+c]+DblCellHPaddingPix;
              if (oldw>w) then begin
                dec(UnsizedCount);
                dec(TotalWidth, oldw);
                dec(PurePixWidth, PixColWidths[Col+c]+DblCellHPaddingPix);
                AllowedCols[c] := 0;
                Changed := True;
              end;
            end;
          if UnsizedCount=0 then
            break;
        until not Changed;
        if UnsizedCount=0 then begin
          // must not happen...
          for c := 0 to Cell.ColSpan-1 do
            if PixColWidths[Col+c]<>0 then
              AllowedCols[c] := 1;
          PurePixWidth := StoredPurePixWidth;
          UnsizedCount := Count;
        end;
        // distributing widths
        for c := 0 to Cell.ColSpan-1 do
          if AllowedCols[c]<>0 then begin
            oldw := ColWidths[Col+c]+DblCellHPaddingPix;
            w := MulDiv(PixColWidths[Col+c]+DblCellHPaddingPix, TotalWidth, PurePixWidth);
            if DoNotExceed and (w>PixColWidths[Col+c]+DblCellHPaddingPix) then
              w := PixColWidths[Col+c]+DblCellHPaddingPix;
            if oldw<w then begin
              ColWidths[Col+c] := w-DblCellHPaddingPix;
              dec(TotalWidth, w);
              dec(PurePixWidth, PixColWidths[Col+c]+DblCellHPaddingPix);
              inc(MinColsWidth, w-oldw);
              dec(UnsizedCount);
              if UnsizedCount=0 then
                break;
            end;
          end;
      finally
        AllowedCols.Free;
      end;
    end;
    {.............................................................}

begin
  if Width=0 then
    exit;
  RVStyle := GetRVStyle;
  CellHPaddingPix    := RVStyle.GetAsDevicePixelsX(CellHPadding, cursad);
  DblCellHPaddingPix := CellHPaddingPix*2;
  CellHSpacingPix    := RVStyle.GetAsDevicePixelsX(CellHSpacing, cursad);
  CellBorderWidthPix := RVStyle.GetAsDevicePixelsX(CellBorderWidth, cursad);
  inc(Width, DblCellHPaddingPix);
  Cell := Cells[Row,Col];
  DH := CellHPaddingPix+CellHSpacingPix+CellHPaddingPix+CellBorderWidthPix*2;
  // calculating existing width of all spanned columns
  OldWidth := -(CellHSpacingPix+CellBorderWidthPix*2);
  PureOldWidth := 0;
  for c := Col to Col+Cell.ColSpan-1 do begin
    inc(OldWidth, ColWidths[c]+DH);
    inc(PureOldWidth, ColWidths[c]+DblCellHPaddingPix);
  end;
  if OldWidth>=Width then
    exit;
  // if array of pixel-widths of columns was not created before, doing it now
  if PixColWidths=nil then begin
    PixColWidths := TRVIntegerList.CreateEx(ColCount, 0);
    for c := 0 to ColCount-1 do
      PixColWidths[c] := RVStyle.GetAsDevicePixelsX(Rows.GetRVSLengthColWidth(c), cursad);
  end;
  // calculating a count of pixel-width columns spanned by this cell,
  // total widths of pix and non-pix columns
  PixColCount := 0;
  PixWidth := -(CellHSpacingPix+CellBorderWidthPix*2);
  PurePixWidth := 0;
  MinOtherWidth := 0;
  for c := Col to Col+Cell.ColSpan-1 do
    if PixColWidths[c]<>0 then begin
      inc(PixWidth, PixColWidths[c]+DH);
      inc(PurePixWidth, PixColWidths[c]+DblCellHPaddingPix);
      inc(PixColCount);
      end
    else
      inc(MinOtherWidth, ColWidths[c]+DH);

  if PixColCount=0 then begin
    // (1) no pixel-width columns; distributing Width among all spanned cells,
    // trying to make their widths as equal as possible
     DistributeToMakeEqual;
    end
  else if (PixColCount=Cell.ColSpan) or (PixWidth>=Width) then begin
    // (2) all columns have widths defined in pixes, or width of columns in pixels is
    // wider than possible; distributing Width among pixel-with columns proportionally
    dec(Width, MinOtherWidth);
    DistributeProportionally(False);
    end
  else begin
    // first, distributing all possible width among pixel-width columns
    // next, distributing among all other columns
    dec(Width, MinOtherWidth);
    DistributeProportionally(True);
    inc(Width, MinOtherWidth);
    for c := Col to Col+Cell.ColSpan-1 do
      if PixColWidths[c]<>0 then
        dec(Width, ColWidths[c]+DblCellHPaddingPix);
    DistributeToMakeEqual;
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetRVStyle: TRVStyle;
begin
  Result := Rows.FMainRVData.GetRVStyle;
end;
{------------------------------------------------------------------------------}
const CWAW_DEFAULT = 0;
      CWAW_SPANNEDPIX = 1;
      CWAW_PIX = 2;
      CWAW_SPANNEDPRC = 3;
      CWAW_PRC = 4;
      CWAW_MAX = 5;

procedure TRVTableItemInfo.InternalOnDocWidthChange(DocWidth: Integer;
  Fmt: TRVTableItemFormattingInfo; Canvas: TCanvas;
  NoCaching, Reformatting, UseFormatCanvas: Boolean;
  GraphicInterface: TRVGraphicInterface);
var r,c,w,w2,w3, PureWidth, SumColWidth, MinColsWidth, ExtraWidth: Integer;
    ColsWithAssignedWidths: TRVIntegerList;
    FixedWidthCount,AssignedCount: Integer;
    FixedWidth, IsCalcMinWidthsSpanDone: Boolean;
    RVStyle: TRVStyle;
    CellHPaddingPix, DblCellHPaddingPix, CellVPaddingPix,
    CellHSpacingPix, CellVSpacingPix,
    CellBorderWidthHPix, CellBorderWidthVPix,
    BorderWidthHPix, BorderWidthVPix,
    BorderHSpacingPix, BorderVSpacingPix: Integer;
    {.................................................}
    procedure CalcMinWidths;
    var c,w: Integer;
    begin
      MinColsWidth := 0;
      for c := 0 to ColCount-1 do begin
        if (rvtoIgnoreContentWidth in Options) then
          w := 0
        else
          w := Rows.GetMinColWidth(c,cursad,Canvas);
        inc(MinColsWidth, w);
        Fmt.ColWidths.Add(w);
      end;
    end;
    {.................................................}
    procedure ExpandCols(Row,Col, Width, CWALim: Integer; ChangeMins: Boolean;
      Depth: Integer);
    var c, oldw, pureoldw, DH, UnsizedCount, neww, savedw, zerocnt: Integer;
        Cell: TRVTableCellData;
        Lim: Integer;
        AddProportionally: Boolean;
    const MAXDEPTH = 30;
    begin
      if Width=0 then
        exit;
      if ChangeMins then begin
        //ChangeMins := False;
        CWALim := CWAW_MAX;
      end;
      AddProportionally := True or {not ChangeMins or} (Depth>MAXDEPTH);
      savedw := Width;

      inc(Width, DblCellHPaddingPix);
      Cell := Cells[Row,Col];
      DH := CellHPaddingPix+CellHSpacingPix+CellHPaddingPix+CellBorderWidthHPix*2;
      Lim := 0;
      zerocnt := 0;
      repeat
        oldw := -CellHSpacingPix-CellBorderWidthHPix*2;
        UnsizedCount := 0;
        pureoldw := 0;
        for c := Col to Col+Cell.ColSpan-1 do begin
          inc(oldw, Fmt.ColWidths[c]+DH);
          if {ChangeMins or}(ColsWithAssignedWidths=nil) or (ColsWithAssignedWidths[c]<=Lim) then begin
            if AddProportionally and (Fmt.ColWidths[c]+DblCellHPaddingPix=0) then begin
              inc(pureoldw);
              inc(zerocnt);
              end
            else
              inc(pureoldw, Fmt.ColWidths[c]+DblCellHPaddingPix);
            inc(UnsizedCount);
          end;
        end;
        inc(Lim);
      until {ChangeMins or} (Lim>CWALim) or (UnsizedCount>0);
      dec(Lim);
      if (oldw<Width) and (UnsizedCount<>0) then begin
        DH := Width-oldw;
        if {not ChangeMins and} not FixedWidth then begin
          if DH>ExtraWidth then
            DH := ExtraWidth;
          if AddProportionally then
            dec(ExtraWidth, DH+zerocnt);
        end;
        inc(DH, pureoldw);
        if AddProportionally then begin
          for c := Col to Col+Cell.ColSpan-1 do
            if {ChangeMins or}(ColsWithAssignedWidths=nil) or (ColsWithAssignedWidths[c]<=Lim) then begin
              oldw := Fmt.ColWidths[c]+DblCellHPaddingPix;
              if oldw=0 then
                inc(oldw);
              Width := MulDiv(oldw,DH,pureoldw);
              Fmt.ColWidths[c] := Width-DblCellHPaddingPix;
              dec(pureoldw, oldw);
              dec(DH,Width);
              if ChangeMins then begin
                inc(MinColsWidth, Width-oldw);
              end;
            end;
          end
        else begin
          for c := Col to Col+Cell.ColSpan-1 do begin
            if (UnsizedCount=0) or (DH<=0) then
              break;
            if {ChangeMins or}(ColsWithAssignedWidths=nil) or (ColsWithAssignedWidths[c]<=Lim) then begin
              oldw := Fmt.ColWidths[c]+DblCellHPaddingPix;
              neww := Round(DH/UnsizedCount);
              if oldw>=neww then begin
                dec(DH, oldw);
                dec(UnsizedCount);
              end;
            end;
          end;
          for c := Col to Col+Cell.ColSpan-1 do begin
            if (UnsizedCount=0) or (DH<=0) then
              break;
            if {ChangeMins or}(ColsWithAssignedWidths=nil) or (ColsWithAssignedWidths[c]<=Lim) then begin
              oldw := Fmt.ColWidths[c]+DblCellHPaddingPix;
              neww := Round(DH/UnsizedCount);
              if oldw<neww then begin
                Fmt.ColWidths[c] := neww-DblCellHPaddingPix;
                if ChangeMins then
                  inc(MinColsWidth, neww-oldw);
                dec(DH, neww);
                if {not ChangeMins and} not FixedWidth then
                  dec(ExtraWidth, neww-oldw);
                dec(UnsizedCount);
              end;
            end;
          end;
          if {ChangeMins or} FixedWidth or (ExtraWidth>0) then
            ExpandCols(Row,Col, savedw, CWALim, ChangeMins, Depth+1);
        end;
      end;
    end;
    {.................................................}
    procedure CalcMinWidthsSpan;
    var r,c: Integer;
    begin
      if (rvtoIgnoreContentWidth in Options) or IsCalcMinWidthsSpanDone then
        exit;
      for r := 0 to RowCount-1 do
        with Rows[r] do
          for c := 0 to ColCount-1 do
            if (Items[c]<>nil) and (Items[c].ColSpan>1) then
              ExpandCols(r,c, Items[c].GetMinWidth(cursad,Canvas),
                CWAW_MAX, True, 0);
      IsCalcMinWidthsSpanDone := True;
    end;
    {.................................................}
    procedure CalcMinWidthsSpanConstrained;
    var r,c: Integer;
        PixColWidths: TRVIntegerList;
    begin
      if (rvtoIgnoreContentWidth in Options) or IsCalcMinWidthsSpanDone then
        exit;
      PixColWidths := nil;
      try
        for r := 0 to RowCount-1 do
          with Rows[r] do
            for c := 0 to ColCount-1 do
              if (Items[c]<>nil) and (Items[c].ColSpan>1) then
                ExpandColsForMinWidthConstrained(r, c,
                  Items[c].GetMinWidth(cursad,Canvas), Fmt.ColWidths,
                    PixColWidths, MinColsWidth);
      finally
         PixColWidths.Free;
      end;
      IsCalcMinWidthsSpanDone := True;
    end;
    {.................................................}
    procedure CalcPercentWidths;
    var c,w,pw,NonDistribWidth: Integer;
        Widths: TRVIntegerList;
    begin
      ExtraWidth := PureWidth-MinColsWidth;
      NonDistribWidth := 0;
      Widths := TRVIntegerList.CreateEx(ColCount,0);
      try
        pw := 0;
        for c := 0 to ColCount-1 do begin
          w := Rows.GetPercentColWidth(c, SumColWidth)-DblCellHPaddingPix;
          if w<0 then
            w := 0;
          Widths[c] := w;
          if w>Fmt.ColWidths[c] then begin
            inc(pw,w);
            inc(NonDistribWidth, Fmt.ColWidths[c]);
            inc(ExtraWidth, Fmt.ColWidths[c]);
          end;
        end;
        if pw=0 then
          exit;
        if pw<ExtraWidth then
          pw := ExtraWidth;
        for c := 0 to ColCount-1 do begin
          if Widths[c]=0 then
            continue;
          if Widths[c]<=Fmt.ColWidths[c] then begin
            ColsWithAssignedWidths[c] := CWAW_PRC;
            inc(AssignedCount);
            continue;
          end;
          dec(NonDistribWidth, Fmt.ColWidths[c]);
          w := MulDiv(Widths[c], ExtraWidth,pw);
          dec(pw, Widths[c]);
          if w>0 then begin
            ColsWithAssignedWidths[c] := CWAW_PRC;
            inc(AssignedCount);
          end;
          if w>ExtraWidth-NonDistribWidth then
            w := ExtraWidth-NonDistribWidth;
          if w>Fmt.ColWidths[c] then
            Fmt.ColWidths[c] := w;
          dec(ExtraWidth, Fmt.ColWidths[c]);
          if (ExtraWidth=0) and (NonDistribWidth=0) then
            break;
        end;
    finally
      Widths.Free;
    end;

      {
      ExtraWidth := PureWidth-MinColsWidth;
      for c := 0 to Rows[0].Count-1 do begin
        w := Rows.GetPercentColWidth(c, SumColWidth)-GetDevX(CellPadding*2);
        if w>0 then begin
          ColsWithAssignedWidths[c] := 2;
          inc(AssignedCount);
        end;
        if w>Fmt.ColWidths[c] then begin
          inc(ExtraWidth, Fmt.ColWidths[c]);
          if w>ExtraWidth then
            w := ExtraWidth;
          Fmt.ColWidths[c] := w;
          dec(ExtraWidth,w);
          if ExtraWidth=0 then break;
        end;
      end;
      }
    end;
    {.................................................}
    procedure CalcPercentWidthsSpan;
    var r,c,w,i: Integer;
    begin
      if ExtraWidth<=0 then
        exit;
      for r := 0 to RowCount-1 do
        with Rows[r] do
          for c := 0 to ColCount-1 do
            if (Items[c]<>nil) and (Items[c].ColSpan>1) and
               (Items[c].BestWidth<0) then begin
              w := MulDiv(-Items[c].BestWidth, SumColWidth, 100)
                -DblCellHPaddingPix;
              ExpandCols(r,c,w, CWAW_PRC, False, 0);
            end;
      for r := 0 to RowCount-1 do
        with Rows[r] do
          for c := 0 to ColCount-1 do
            if (Items[c]<>nil) and (Items[c].ColSpan>1) and
               (Items[c].BestWidth<0) then begin
              for i := 0 to Items[c].ColSpan-1 do
                if ColsWithAssignedWidths[c+i]=0 then begin
                  ColsWithAssignedWidths[c+i] := CWAW_SPANNEDPRC;
                  inc(AssignedCount);
                end;
            end;
    end;
    {.................................................}
    { Calculates widths of pixel-width columns in tables having
      width=sum of column widths }
    procedure CalcFixedWidths;
    var c,w: Integer;
    begin
      if not FixedWidth then
        exit;
      for c := 0 to ColCount-1 do
        if ColsWithAssignedWidths[c]=CWAW_DEFAULT then begin
          w := RVStyle.GetAsDevicePixelsX(Rows.GetRVSLengthColWidth(c), cursad);
          if w>0 then begin
            ColsWithAssignedWidths[c] := CWAW_PIX;
            inc(AssignedCount);
            inc(FixedWidthCount);
          end;
          if w>Fmt.ColWidths[c] then
            Fmt.ColWidths[c] := w;
        end;
    end;
    {.................................................}
    { Calculates widths of pixel-width columns in tables having
      width<>sum of column widths. This function does not distribute extra width
      larger than necessary. If extra width is less than necessary, it distributes
      lack of width between affected columns proportionally }
    procedure CalcFixedWidths2;
    var c,w, aw, fw: Integer;
        Widths: TRVIntegerList;
    begin
      if FixedWidth or (ExtraWidth<=0) then
        exit;
      Widths := TRVIntegerList.CreateEx(ColCount,0);
      try
        aw := 0;
        for c := 0 to ColCount-1 do
          if ColsWithAssignedWidths[c]=CWAW_DEFAULT then begin
            w := RVStyle.GetAsDevicePixelsX(Rows.GetRVSLengthColWidth(c), cursad);
            if w>0 then begin
              ColsWithAssignedWidths[c] := CWAW_PIX;
              inc(AssignedCount);
              inc(FixedWidthCount);
            end;
            if w>Fmt.ColWidths[c] then begin
              Widths[c] := w;
              inc(aw, w);
              inc(ExtraWidth, Fmt.ColWidths[c]);
            end;
          end;
        fw := aw;
        if aw>ExtraWidth then
          aw := ExtraWidth;
        if fw>0 then
          for c := 0 to ColCount-1 do
            if (ColsWithAssignedWidths[c]=CWAW_PIX) and (Widths[c]>0) then begin
              w := MulDiv(Widths[c], aw, fw);
              if w>ExtraWidth then
                w := ExtraWidth;
              if w<Fmt.ColWidths[c] then
                w := Fmt.ColWidths[c];
              dec(ExtraWidth,w);
              Fmt.ColWidths[c] := w;
              dec(fw, Widths[c]);
              dec(aw, w);
            end;
      finally
        Widths.Free;
      end;
    end;
    {.................................................}
    procedure CalcFixedWidthsSpan;
    var r,c,w,i: Integer;
    begin
      if not FixedWidth and (ExtraWidth<=0) then exit;
      for r := 0 to RowCount-1 do
        with Rows[r] do
          for c := 0 to ColCount-1 do
            if (Items[c]<>nil) and (Items[c].ColSpan>1) and
               (Items[c].BestWidth>0) then begin
              w := RVStyle.GetAsDevicePixelsX(Items[c].BestWidth, cursad);
              ExpandCols(r,c,w, CWAW_PIX, False, 0);
            end;
      for r := 0 to RowCount-1 do
        with Rows[r] do
          for c := 0 to ColCount-1 do
            if (Items[c]<>nil) and (Items[c].ColSpan>1) and
               (Items[c].BestWidth>0) then begin
              for i := 0 to Items[c].ColSpan-1 do
                if ColsWithAssignedWidths[c+i]=CWAW_DEFAULT then begin
                  ColsWithAssignedWidths[c+i] := CWAW_SPANNEDPIX;
                  inc(AssignedCount);
                  inc(FixedWidthCount);
                end;
            end;
    end;
    {.................................................}
    procedure ExpandRows(Row,Col: Integer);
    var r,h,h2,oldh, pureoldh, pureoldh2, DV: Integer;
        EmptyRows: Boolean;
        Cell: TRVTableCellData;
    begin
      Cell := Cells[Row,Col];
      DV :=
        CellVPaddingPix+CellVSpacingPix+CellVPaddingPix+CellBorderWidthVPix*2;
      if Fmt.Rows=nil then
        h :=  Cell.GetCellHeight(rvtoIgnoreContentHeight in Options)+
          RVStyle.GetAsPixels(CellVPadding)*2
      else begin
        h := RVStyle.GetAsDevicePixelsY(Cell.BestHeight, cursad);
        if ((h=0) or not (rvtoIgnoreContentHeight in Options)) and
           (Fmt.Rows[Row*ColCount+Col]<>nil) then begin
          h2 := TCellPtblRVData(Fmt.Rows[Row*ColCount+Col]).DocumentHeight;
          if h2>h then
            h := h2;
        end;
        inc(h, CellVPaddingPix*2);
      end;
      oldh := -CellVSpacingPix-CellBorderWidthVPix*2;
      pureoldh := 0;
      pureoldh2 := 0;
      EmptyRows := False;
      for r := Row to Row+Cell.RowSpan-1 do begin
        inc(oldh, Fmt.RowHeights[r]+DV);
        inc(pureoldh, Fmt.RowHeights[r]);
        if not Rows[r].HasCellsInRange(r, Row, Cell.RowSpan) then begin
          inc(pureoldh2, Fmt.RowHeights[r]);
          EmptyRows := True;
        end;
      end;
      if EmptyRows then
        pureoldh := pureoldh2;
      if oldh<h then begin
        DV := h-oldh;
        inc(Fmt.FHeight, DV);
        for r := Row to Row+Cell.RowSpan-1 do
          if not (EmptyRows and Rows[r].HasCellsInRange(r, Row, Cell.RowSpan)) then begin
            oldh := Fmt.RowHeights[r];
            h := MulDiv(oldh,DV,pureoldh);
            Fmt.RowHeights[r] := Integer(Fmt.RowHeights.Items[r])+h;
            dec(pureoldh, oldh);
            dec(DV,h);
          end;
      end;
    end;
    {.................................................}
    {
    function IsEmptyContentColumn(Col: Integer): Boolean;
    var r,len: Integer;
        RVData: TCustomRVData;
        s: TRVAnsiString;
    begin
      Result := False;
      for r := 0 to RowCount-1 do begin
        if (Cells[r, Col]=nil) or (Cells[r, Col].ColSpan>1) then
          Continue;
        RVData := Cells[r, Col].GetRVData;
        if RVData.ItemCount>1 then
          exit;
        if RVData.ItemCount=0 then
          Continue;
        if RVData.GetItemStyle(0)<0 then
          exit;
        len := RVU_Length(RVData.Items[0], RVData.GetItemOptions(0));
        if len=0 then
          Continue;
        if len>1 then
          exit;
        s := RVData.GetItemTextA(0);
        if (s[1]<>' ') and (s[1]<>#$A0) then
          exit;
      end;
      Result := True;
    end;
    }
    {.................................................}
    // This procedure distributes the remaining with among columns with BestWidth=0
    // This is a final step.
    // This space is distributed equally
    procedure ExpandDefWidthCols;
    var c, w: Integer;
    begin
      if ColsWithAssignedWidths.Count=AssignedCount then
        exit;
      for c := 0 to ColCount-1 do
        if ColsWithAssignedWidths[c]=CWAW_DEFAULT then begin
          w := ExtraWidth div (ColsWithAssignedWidths.Count-AssignedCount);
          Fmt.ColWidths[c] := Fmt.ColWidths[c]+w;
          dec(ExtraWidth,w);
          inc(AssignedCount);
          if ExtraWidth<=0 then
            break;
        end;
    end;
    {.................................................}
var NewWidth, HorExtra, MinW: Integer;
begin
  RVStyle := GetRVStyle;
  CellHPaddingPix    := RVStyle.GetAsDevicePixelsX(CellHPadding, cursad);
  DblCellHPaddingPix := CellHPaddingPix*2;
  CellVPaddingPix    := RVStyle.GetAsDevicePixelsY(CellVPadding, cursad);

  CellHSpacingPix    := RVStyle.GetAsDevicePixelsX(CellHSpacing, cursad);
  CellVSpacingPix    := RVStyle.GetAsDevicePixelsY(CellVSpacing, cursad);

  CellBorderWidthHPix := RVStyle.GetAsDevicePixelsX(CellBorderWidth, cursad);
  CellBorderWidthVPix := RVStyle.GetAsDevicePixelsY(CellBorderWidth, cursad);

  BorderWidthHPix     := RVStyle.GetAsDevicePixelsX(BorderWidth, cursad);
  BorderWidthVPix     := RVStyle.GetAsDevicePixelsY(BorderWidth, cursad);

  BorderHSpacingPix  := RVStyle.GetAsDevicePixelsX(BorderHSpacing, cursad);
  BorderVSpacingPix  := RVStyle.GetAsDevicePixelsY(BorderVSpacing, cursad);
  if Rows.Empty then begin
    Fmt.FWidth  := (BorderWidthHPix+BorderHSpacingPix)*2;
    Fmt.FHeight := (BorderWidthVPix+BorderVSpacingPix)*2;
    exit;
  end;
  HorExtra := GetHorzExtraPix;
  FixedWidth := False;
  if BestWidth>0 then
    NewWidth := RVStyle.GetAsDevicePixelsX(BestWidth, cursad)
  else if BestWidth<0 then
    NewWidth := -BestWidth*DocWidth div 100
  else begin
    FixedWidth := IsFixedWidthTable;
    if not FixedWidth then begin //  temporary
      NewWidth := DoGetMinWidth(cursad, Canvas, True);
      if DocWidth>NewWidth then
        NewWidth := DocWidth;
      end
    else
      NewWidth := 0; //CalcPixelWidth;
      //inc(NewWidth, HorExtra+GetDevX(CellPadding*Rows[0].Count*2));
  end;
  if (NewWidth<>0) and (NewWidth=Fmt.FWidth) and not NoCaching then
    exit;
  Fmt.FWidth := NewWidth;
  if Rows.Empty then
    exit;
  ColsWithAssignedWidths := nil;
  if not FixedWidth then begin
    SumColWidth := Fmt.FWidth - HorExtra;
    PureWidth := SumColWidth - DblCellHPaddingPix*ColCount;
    end
  else begin
    SumColWidth := 0;
    PureWidth   := 0;
    ExtraWidth  := 0;
  end;
  Fmt.QuickClear;
  // Calculating minimal widths
  CalcMinWidths;
  IsCalcMinWidthsSpanDone := False;
  if not FixedWidth then
    MinW := DoGetMinWidth(cursad, Canvas, False)
  else
    MinW := 0;
  if not FixedWidth and (MinW>=Fmt.FWidth) then begin
    // Table is too narrow. Setting all width to minimums
    CalcMinWidthsSpanConstrained;
    Fmt.FWidth := MinW;
    end
  else begin
    ColsWithAssignedWidths := TRVIntegerList.Create;
    try
      AssignedCount := 0;
      FixedWidthCount := 0;
      ColsWithAssignedWidths.Capacity := Fmt.ColWidths.Count;
      for c := 0 to Fmt.ColWidths.Count-1 do
        ColsWithAssignedWidths.Add(CWAW_DEFAULT);
      // Setting widths for autosizing cols...
      if not FixedWidth then begin
        CalcPercentWidths;
        CalcPercentWidthsSpan;
      end;
      // Setting widths for fixed cols...
      CalcFixedWidths;
      CalcFixedWidths2;
      CalcMinWidthsSpan;      
      CalcFixedWidthsSpan;
      CalcMinWidthsSpan;      
      if FixedWidth then begin
        Fmt.FWidth := HorExtra+DblCellHPaddingPix*ColCount;
        for c := 0 to ColCount-1 do
          inc(Fmt.FWidth, Fmt.ColWidths[c]);
        end
      else if ExtraWidth>0 then
        if AssignedCount<ColsWithAssignedWidths.Count then
          // Setting widths for other cols...
          ExpandDefWidthCols
        else if FixedWidthCount>0 then begin
          // Expanding fixed width cols.
          w2 := 0;
          for c := 0 to ColCount-1 do
            if not Rows.IsPercentWidthColumn(c) then begin
              w := Rows.GetRVSLengthColWidth(c);
              if w=0 then
                w := 1;
              ColsWithAssignedWidths[c] := w;
              inc(w2,w);
              end
            else
              ColsWithAssignedWidths[c] := 0;
          for c := 0 to ColCount-1 do begin
            w3 := ColsWithAssignedWidths[c];
            if w3<>0 then begin
              w := MulDiv(ExtraWidth, w3, w2);
              Fmt.ColWidths[c] := Fmt.ColWidths[c]+w;
              dec(ExtraWidth,w);
              dec(w2, w3);
              if ExtraWidth<=0 then break;
            end;
          end
          end
        else begin
          // Expanding all cols
         w2 := 0;
         for c := 0 to ColCount-1 do
          if Rows.IsPercentWidthColumn(c) then begin
            w := Rows.GetPercentColWidth(c, SumColWidth)-DblCellHPaddingPix;
            if w<=0 then
              w := 1;
            ColsWithAssignedWidths[c] := w;
            inc(w2,w);
          end;
          for c := 0 to ColCount-1 do begin
            if Rows.IsPercentWidthColumn(c) then begin
              w3 := ColsWithAssignedWidths[c];
              w := MulDiv(ExtraWidth, w3, w2);
              if w>ExtraWidth then
                w := ExtraWidth;
              Fmt.ColWidths[c] := Fmt.ColWidths[c]+w;
              dec(ExtraWidth,w);
              dec(w2, w3);
              if ExtraWidth<=0 then break;
            end;
          end;
        end;
    finally
      ColsWithAssignedWidths.Free;
    end;
  end;
  // Note: for table with undefined width algorithm must be completely different...
  UpdateCellXCoords(Fmt, NoCaching, Reformatting);
  Fmt.FHeight := (CellVPaddingPix*RowCount+BorderWidthVPix+BorderVSpacingPix)*2+
    (CellVSpacingPix*(RowCount-1))+RowCount*CellBorderWidthVPix*2;
  Fmt.RowHeights.Capacity := RowCount;
  Fmt.RowStarts.Count := RowCount;
  // pass 1...
  if Fmt.Rows=nil then
    for r := 0 to RowCount-1 do begin
      w := Rows[r].GetHeight(rvtoIgnoreContentHeight in Options);
      Fmt.RowHeights.Add(w);
      inc(Fmt.FHeight, w);
    end
  else
    for r := 0 to RowCount-1 do begin
      with Rows[r] do begin
        w := RVStyle.GetAsDevicePixelsY(GetBestHeight, cursad);
        if (w=0) or not (rvtoIgnoreContentHeight in Options) then
          for c := 0 to Count-1 do
            if (Items[c]<>nil) and (Items[c].RowSpan=1) and
               ((Items[c].BestHeight=0) or
                 not (rvtoIgnoreContentHeight in Options)) then begin 
              if Fmt.Rows[r*Count+c]<>nil then
                w2 := TCellPtblRVData(Fmt.Rows[r*Count+c]).DocumentHeight
              else begin
                w2 := GetDevY(Items[c].DocumentHeight);
                if w2=0 then begin
                  if (Items[c].GetRVData.ItemCount>0) and (Items[c].GetRVData.GetItemStyle(0)>=0) then begin
                    RVStyle.ApplyStyle(Canvas,
                      Items[c].GetRVData.GetItemStyle(0), rvbdUnspecified,
                      False, nil, False, False);
                    w2 := GraphicInterface.TextHeight(Canvas, ' ');
                    with RVStyle.ParaStyles[Items[c].GetRVData.GetItemPara(0)] do
                      inc(w2,
                        RVStyle.GetAsDevicePixelsY(SpaceBefore, cursad)+
                        RVStyle.GetAsDevicePixelsY(SpaceAfter, cursad));
                  end;
                end;
              end;
              if w2>w then
                w := w2;
            end;
      end;
      if w=0 then
        w := 10; // temporal
      Fmt.RowHeights.Add(w);
      inc(Fmt.FHeight, w);
    end;
  // pass 2...
  for r := 0 to RowCount-1 do
    with Rows[r] do
      for c := 0 to Count-1 do
        if (Items[c]<>nil) and (Items[c].RowSpan>1) then
          ExpandRows(r,c);
  UpdateCellYCoords(Fmt);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.DrawBorder(Canvas: TCanvas;
  Left, Top, Right, Bottom: Integer; Width: TRVStyleLength;
  LightColor, Color, BackgroundColor: TColor;
  Style: TRVTableBorderStyle; DrawEvenEmptyBorder, Editing, Printing: Boolean;
  const ClipRect: TRect; VisibleBorders: TRVBooleanRect;
  r,c: Integer; ColorMode: TRVColorMode; GraphicInterface: TRVGraphicInterface);
var i,y1,y2,incr: Integer;
    par: array [0..2] of TPoint;
    DrawGridLines: Boolean;
    {..........................................}
    procedure ClipY(var y1,y2: Integer; const ClipRect: TRect);
    begin
      if y1<ClipRect.Top-1 then
        y1 := ClipRect.Top-1;
      if y2>ClipRect.Bottom+1 then
        y2 := ClipRect.Bottom+1;
    end;
    {..........................................}
    function HasTopLine: Boolean;
    var r2,c2: Integer;
    begin
      if r<0 then
        Result := False
      else if r=0 then
        Result := (BorderVSpacing<0) and (BorderWidth>0) and VisibleBorders.Top
      else
        Result := (CellVSpacing<0) and Rows.GetMainCell(r-1,c,r2,c2).VisibleBorders.Bottom;
    end;
    {..........................................}
    function HasBottomLine: Boolean;
    var r2,c2: Integer;
    begin
      if r<0 then
        Result := False
      else begin
        r2 := r+Cells[r,c].RowSpan-1;
        if r2=RowCount-1 then
          Result := (BorderVSpacing<0) and (BorderWidth>0) and VisibleBorders.Bottom
        else
          Result := (CellVSpacing<0) and Rows.GetMainCell(r2+1,c,r2,c2).VisibleBorders.Top;
      end;
    end;
    {..........................................}
    function HasLeftLine: Boolean;
    var r2,c2: Integer;
    begin
      if c<0 then
        Result := False
      else if c=0 then
        Result := (BorderHSpacing<0) and (BorderWidth>0) and VisibleBorders.Left
      else
        Result := (CellHSpacing<0) and Rows.GetMainCell(r,c-1,r2,c2).VisibleBorders.Right;
    end;
    {..........................................}
    function HasRightLine: Boolean;
    var r2,c2: Integer;
    begin
      if c<0 then
        Result := False
      else begin
        c2 := c+Cells[r,c].ColSpan-1;
        if c2=ColCount-1 then
          Result := (BorderHSpacing<0) and (BorderWidth>0) and VisibleBorders.Right
        else
          Result := (CellHSpacing<0) and Rows.GetMainCell(r,c2+1,r2,c2).VisibleBorders.Left;
      end;
    end;
    {..........................................}
var DoDefault: Boolean;
    GridStyle: TPenStyle;
begin
  if (ClipRect.Left>Right) or
     (ClipRect.Right<Left) or
     (ClipRect.Top>Bottom) or
     (ClipRect.Bottom<Top) then
    exit;
  if Assigned(FOnDrawBorder) then begin
    DoDefault := True;
    FOnDrawBorder(Self, Canvas, Left, Top, Right, Bottom, Width, LightColor, Color,
    BackgroundColor, Style, Printing, VisibleBorders, r, c, DoDefault);
    if not DoDefault then
      exit;
  end;
  if Editing then
    GridStyle := RichViewTableGridStyle
  else
    GridStyle := RichViewTableGridStyle2;
  DrawGridLines := DrawEvenEmptyBorder and not Printing and (GridStyle<>psClear);
  if Width=0 then begin
    if not DrawGridLines then
      exit;
    Canvas.Pen.Width := 1;
    Canvas.Brush.Color := clNone;
    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Style := GridStyle;
    Canvas.Pen.Color := RichViewTableGridColor;
    GraphicInterface.Rectangle(Canvas, Left,Top,Right,Bottom);
    Canvas.Pen.Mode := pmCopy;
    Canvas.Pen.Style := psSolid;
    exit;
  end;
  if DrawGridLines and (VisibleBorders<>nil) and not VisibleBorders.IsAllEqual(True) then begin
    Canvas.Pen.Width := 1;
    Canvas.Brush.Color := clNone;
    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Style := GridStyle;
    Canvas.Pen.Color := RichViewTableGridColor;
    if not VisibleBorders.Top and not HasTopLine then
      GraphicInterface.Line(Canvas, Left,Top, Right,Top);
    if not VisibleBorders.Bottom and not HasBottomLine then
      GraphicInterface.Line(Canvas, Left,Bottom-1, Right,Bottom-1);
    if not VisibleBorders.Left and not HasLeftLine then begin
      y1 := Top;
      y2 := Bottom;
      ClipY(y1,y2,ClipRect);
      GraphicInterface.Line(Canvas, Left,y1, Left,y2);
    end;
    if not VisibleBorders.Right and not HasRightLine then begin
      y1 := Top;
      y2 := Bottom;
      ClipY(y1,y2,ClipRect);
      GraphicInterface.Line(Canvas, Right-1,y1, Right-1,y2);
    end;
    Canvas.Pen.Mode := pmCopy;
    Canvas.Pen.Style := psSolid;
  end;

  Canvas.Brush.Style := bsClear;
  if Style in [rvtbRaised, rvtbLowered, rvtbRaisedColor, rvtbLoweredColor] then begin
    dec(Right);
    dec(Bottom);
    Width := GetRVStyle.GetAsDevicePixelsY(Width, cursad);
    // 3d frame
    case Style of
      rvtbRaised:
        begin
          if ColorToRGB(BackgroundColor)=ColorToRGB(clBtnHighlight) then
            Canvas.Pen.Color := RV_GetColor(clBtnFace, ColorMode)
          else
            Canvas.Pen.Color := RV_GetColor(clBtnHighlight, ColorMode)
        end;
      rvtbRaisedColor:
        Canvas.Pen.Color := RV_GetColor(LightColor, ColorMode);
      rvtbLoweredColor:
        Canvas.Pen.Color := RV_GetColor(Color, ColorMode);
      else {rvtbLowered}
        Canvas.Pen.Color := RV_GetColor(clBtnShadow, ColorMode);
    end;
    if Printing and (rvtoHalftoneBorders in PrintOptions) then begin
      if (cursad<>nil) and (cursad.ppiyScreen<cursad.ppiyDevice) then begin
        Canvas.Pen.Width := Width+1;
        dec(Left);
        dec(Top);
      end;
      Canvas.Pen.Style := psInsideFrame;
      Width := Width div 2;
      inc(Left,Width);
      inc(Top,Width);
      dec(Right,Width);
      dec(Bottom,Width);
      Width := 1;
      incr := 0;
      end
    else begin
      Canvas.Pen.Width := 1;
      Canvas.Pen.Style := psSolid;
      incr := 1;
    end;
    with par[0] do begin x := Left;  y := Bottom; end;
    with par[1] do begin x := Left;  y := Top;    end;
    with par[2] do begin x := Right; y := Top;    end;
    for i := 0 to Width-1 do begin
      //Canvas.Polyline(par);  <- does not work for looooong tables
      if (VisibleBorders=nil) or (VisibleBorders.Top) then begin
        with par[1] do GraphicInterface.MoveTo(Canvas, x, y);
        with par[2] do GraphicInterface.LineTo(Canvas, x+incr, y);
      end;
      if (VisibleBorders=nil) or (VisibleBorders.Left) then begin
        y1 := par[1].y;
        y2 := par[0].y;
        ClipY(y1,y2,ClipRect);
        GraphicInterface.Line(Canvas, par[1].x,y1, par[0].x,y2+incr);
      end;
      with par[0] do begin inc(x); dec(y); end;
      with par[1] do begin inc(x); inc(y); end;
      with par[2] do begin dec(x); inc(y); end;
    end;
    case Style of
      rvtbRaised:
        Canvas.Pen.Color := RV_GetColor(clBtnShadow, ColorMode);
      rvtbRaisedColor:
        Canvas.Pen.Color := RV_GetColor(Color, ColorMode);
      rvtbLoweredColor:
        Canvas.Pen.Color := RV_GetColor(LightColor, ColorMode);
      else {rvtbLowered}
        begin
          if ColorToRGB(BackgroundColor)=ColorToRGB(clBtnHighlight) then
            Canvas.Pen.Color := RV_GetColor(clBtnFace, ColorMode)
          else
            Canvas.Pen.Color := RV_GetColor(clBtnHighlight, ColorMode);
        end;
    end;
    with par[0] do begin x := Right; y := Top;    end;
    with par[1] do begin x := Right; y := Bottom; end;
    with par[2] do begin x := Left;  y := Bottom; end;
    for i := 0 to Width-1 do begin
      //Canvas.Polyline(par);  <- does not work for looooong tables
      if (VisibleBorders=nil) or (VisibleBorders.Bottom) then begin
        with par[2] do GraphicInterface.MoveTo(Canvas, x,y);
        with par[1] do GraphicInterface.LineTo(Canvas, x+incr,y);
      end;
      if (VisibleBorders=nil) or (VisibleBorders.Right) then begin
        y1 := par[0].y;
        y2 := par[1].y;
        ClipY(y1,y2,ClipRect);
        GraphicInterface.Line(Canvas, par[0].x,y1, par[1].x,y2+incr);
      end;
      with par[0] do begin dec(x); inc(y); end;
      with par[1] do begin dec(x); dec(y); end;
      with par[2] do begin inc(x); dec(y); end;
    end;
    end
  else begin
    // Single frame
    if Color=clNone then exit;
    Canvas.Pen.Color := RV_GetColor(Color, ColorMode);
    if (RVNT or (Bottom-Top<32000)) and
       ((VisibleBorders=nil) or
       (VisibleBorders.Left and VisibleBorders.Right and
        VisibleBorders.Top and VisibleBorders.Bottom)) then begin
      Canvas.Pen.Width := GetRVStyle.GetAsDevicePixelsY(Width, cursad);
      if Printing and (cursad<>nil) and (cursad.ppiyScreen<cursad.ppiyDevice) then begin
        Canvas.Pen.Width := Canvas.Pen.Width+1;
        dec(Left);
        dec(Top);
      end;
      Canvas.Pen.Style := psInsideFrame;
      GraphicInterface.Rectangle(Canvas, Left, Top, Right, Bottom);
      Canvas.Pen.Width := 1;
      Canvas.Pen.Style := psSolid;
      end
    else begin
      Width := GetRVStyle.GetAsDevicePixelsY(Width, cursad);
      if Printing and (cursad<>nil) and (cursad.ppiyScreen<cursad.ppiyDevice) then begin
        inc(Width);
        dec(Top);
        dec(Left);
      end;
      if Printing and (rvtoHalftoneBorders in PrintOptions) then begin
        Canvas.Pen.Width := Width;
        Canvas.Pen.Style := psInsideFrame;
        Width := Width div 2;
        inc(Left,Width);
        inc(Top,Width);
        dec(Right,Width);
        dec(Bottom,Width);
        Width := 1;
        end
      else begin
        Canvas.Pen.Width := 1;
        Canvas.Pen.Style := psSolid;
      end;
      dec(Right);
      dec(Bottom);

      if rvtoOverlappingCorners in Options then begin
        for i := 0 to Width-1 do begin // idea of Harley Pebley
          y1 := Top;
          y2 := Bottom+1;
          ClipY(y1,y2,ClipRect);
          if (VisibleBorders=nil) or VisibleBorders.Left then
            GraphicInterface.Line(Canvas, Left+i,y1, Left+i,y2);
          if (VisibleBorders=nil) or VisibleBorders.Right then
            GraphicInterface.Line(Canvas, Right-i,y1, Right-i,y2);
          if (VisibleBorders=nil) or VisibleBorders.Top then
            GraphicInterface.Line(Canvas, Left,Top+i, Right+1,Top+i);
          if (VisibleBorders=nil) or VisibleBorders.Bottom then
            GraphicInterface.Line(Canvas, Left,Bottom-i, Right+1,Bottom-i);
        end
        end
      else
        for i := 0 to Width-1 do begin
          if (VisibleBorders=nil) or VisibleBorders.Left then begin
            y1 := Top;
            y2 := Bottom+1;
            ClipY(y1,y2,ClipRect);
            GraphicInterface.Line(Canvas, Left,y1, Left,y2);
          end;
          if (VisibleBorders=nil) or VisibleBorders.Right then begin
            y1 := Top;
            y2 := Bottom+1;
            ClipY(y1,y2,ClipRect);
            GraphicInterface.Line(Canvas, Right,y1, Right,y2);
          end;
          if (VisibleBorders=nil) or VisibleBorders.Top then
            GraphicInterface.Line(Canvas, Left,Top, Right+1,Top);
          if (VisibleBorders=nil) or VisibleBorders.Bottom then
            GraphicInterface.Line(Canvas, Left,Bottom, Right+1,Bottom);
          inc(Left);
          inc(Top);
          dec(Right);
          dec(Bottom);
        end;
    end;
  end;
  Canvas.Pen.Style := psSolid;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetVerticalRuleNo(X: Integer; var MinX, ZeroChangeX: Integer): Integer;
var i, DH,l: Integer;
 {..................................}
 function InEps(v, delta: Integer): Boolean;
 begin
   delta := delta div 2;
   if delta<2 then delta := 2;
   Result := abs(v-X)<=delta;
 end;
 {..................................}
begin
 Result := -1;
 if (X<0) or (X>Fmt.FWidth) then exit;
 DH := GetRVStyle.GetAsPixels(CellHSpacing)+
   GetRVStyle.GetAsPixels(FCellBorderWidth)*2;
 l := GetRVStyle.GetAsPixels(BorderWidth)+
   GetRVStyle.GetAsPixels(BorderHSpacing)+
   GetRVStyle.GetAsPixels(CellBorderWidth);
 if InEps(l div 2, l) then begin
   Result := 0;
   MinX := -1;
   ZeroChangeX := l div 2;
   exit;
 end;
 if InEps(Fmt.FWidth - l div 2, l) then begin
   Result := ColCount;
   MinX := Fmt.ColStarts[Result-1];
   ZeroChangeX := Fmt.FWidth - l div 2;
   exit;
 end;
 for i := 0 to ColCount-2 do begin
   l := Fmt.ColStarts[i+1];
   if InEps(l-DH div 2, DH) then begin
     Result := i+1;
     MinX := Fmt.ColStarts[Result-1];
     ZeroChangeX := l-(DH+1) div 2;
     exit;
   end;
 end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetHorizontalRuleNo(Y: Integer; var MinY, ZeroChangeY: Integer): Integer;
var i, DV,t: Integer;
 {..................................}
 function InEps(v, delta: Integer): Boolean;
 begin
   delta := delta div 2;
   if delta<2 then delta := 2;
   Result := abs(v-Y)<=delta;
 end;
 {..................................}
begin
 Result := -1;
 if (Y<0) or (Y>Fmt.FHeight) then exit;
 DV := GetRVStyle.GetAsPixels(CellVSpacing)+
   GetRVStyle.GetAsPixels(FCellBorderWidth)*2;
 t := GetRVStyle.GetAsPixels(BorderWidth)+
   GetRVStyle.GetAsPixels(BorderVSpacing)+
   GetRVStyle.GetAsPixels(CellBorderWidth);
 if InEps(t div 2, t) then begin
   Result := 0;
   MinY := -1;
   ZeroChangeY := t div 2;
   exit;
 end;
 if InEps(Fmt.FHeight - t div 2, t) then begin
   Result := RowCount;
   MinY := Fmt.RowStarts[Result-1];
   ZeroChangeY := Fmt.FHeight - t div 2;
   exit;
 end;
 for i := 0 to RowCount-2 do begin
   t := Fmt.RowStarts[i+1];
   if InEps(t-DV div 2, DV) then begin
     Result := i+1;
     MinY := Fmt.RowStarts[Result-1];
     ZeroChangeY := t-(DV+1) div 2;
     exit;
   end;
 end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetColNo(X: Integer): Integer;
var c:Integer;
begin
  Result := -1;
  for c := 0 to ColCount-1 do begin
    if X<Fmt.ColStarts[c] then
      exit;
    if X<=Fmt.ColStarts[c]+Fmt.ColWidths[c] then begin
      Result := c;
      exit;
    end;
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetRowNo(Y: Integer): Integer;
var r:Integer;
begin
  Result := -1;
  for r := 0 to RowCount-1 do begin
    if Y<Fmt.RowStarts[r] then
      exit;
    if Y<=Fmt.RowStarts[r]+Fmt.RowHeights[r] then begin
      Result := r;
      exit;
    end;
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetCrossed(Coord: Integer;List: TRVIntegerList): Integer;
var a,b:Integer;
begin
  if List.Count<2 then begin
    Result := 0;
    exit;
  end;
  if Coord>=List[List.Count-1] then begin
    Result := List.Count-1;
    exit;
  end;
  a := 0;
  b := List.Count-1;
  while b-a>1 do begin
    Result := (b+a) div 2;
    if List[Result]<Coord then
      a := Result
    else
      b := Result;
  end;
  Result := a;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.MouseMove(Shift: TShiftState; X, Y,ItemNo: Integer; RVData: TObject): Boolean;
var Row,Col, RuleNo,a,b: Integer;
    NewSelColOffs, NewSelRowOffs, CellHPaddingPix, CellVPaddingPix: Integer;
    Redraw: Boolean;
begin
  if Rows.Empty or TCustomRVFormattedData(Rows.FMainRVData).UsingThisXorDrawing(XORDrawing) then begin
    Result := False;
    exit;
  end;
  if FMakingSelection and not (ssLeft in Shift) then
    MouseUp(mbLeft, Shift-[ssLeft, ssRight, ssMiddle], X, Y, ItemNo, RVData);

  MyClientTop := 0;
  MyClientLeft := 0;
  Result := True;
  if BusyCount>0 then exit;
  if GetCellAt(X, Y, Row, Col, False) then begin
    if FMakingSelection and (ssLeft in Shift) then begin
      NewSelColOffs := Col-FSelStartCol;
      NewSelRowOffs := Row-FSelStartRow;
      Redraw :=  (FSelColOffs<>NewSelColOffs) or
                 (FSelRowOffs<>NewSelRowOffs);
      FSelColOffs := NewSelColOffs;
      FSelRowOffs := NewSelRowOffs;
      if (FSelColOffs<>0) or (FSelRowOffs<>0) then
        Include(FState, rvtsSelExists)
      else
        Exclude(FState, rvtsSelExists);      
      if Redraw then begin
        UpdateCellSel;
        TCustomRVFormattedData(Rows.FMainRVData).Invalidate;
        if FInplaceEditor<>nil then
          TRVTableInplaceEdit(FInplaceEditor).SelectCompletely(rvtsSelExists in FState);
      end;
    end;
    if not FMakingSelection or not (rvtsSelExists in FState) and (Cells[Row,Col].GetRVData=Cells[Row,Col]) then begin
      CellHPaddingPix := GetRVStyle.GetAsPixels(CellHPadding);
      CellVPaddingPix := GetRVStyle.GetAsPixels(CellVPadding);
      with Cells[Row,Col] do begin
        if RV_PointInRect(X, Y,
          Left+CellHPaddingPix, Top+CellVPaddingPix,
          Width-CellHPaddingPix*2, Height-CellVPaddingPix*2) then begin
          MouseMove(Shift, X, Y);
          Result := True;
          exit;
        end;
      end;
    end
    end
  else begin
    RuleNo := GetVerticalRuleNo(X,a,b);
    if (rvtoRowSelect in Options) and (RuleNo=0) and
       (rvoAllowSelection in TCustomRVFormattedData(RVData).Options) then begin
      TCustomRVFormattedData(RVData).SetCursor(crRVSelectRow);
      exit;
    end;
    if CanChangeEx and (rvtoColSizing in Options) and (RuleNo>0) then begin
      TCustomRVFormattedData(RVData).SetCursor(crHSplit);
      exit;
    end;
    RuleNo := GetHorizontalRuleNo(Y,a,b);
    if (rvtoColSelect in Options) and (RuleNo=0) and
       (rvoAllowSelection in TCustomRVFormattedData(RVData).Options) then begin
      TCustomRVFormattedData(RVData).SetCursor(crRVSelectCol);
      exit;
    end;
    if CanChangeEx and (rvtoRowSizing in Options) and (RuleNo>0) then begin
      TCustomRVFormattedData(RVData).SetCursor(crVSplit);
      exit;
    end;
  end;
  TCustomRVFormattedData(RVData).SetCursor(crArrow);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.XorDrawing(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var Offs: Integer;
    Canvas: TCanvas;
begin
  Offs := 0;
  Canvas := TCustomRVFormattedData(Sender).GetCanvas;
  with Canvas do begin
    Pen.Mode := pmNot;
    Pen.Width := 1;
    Brush.Style := bsClear;
    Pen.Style := psSolid;
    if not (rvtsVerticalDraggedRule in FState) then begin
      if (DRMin<>-1) or (DRMax<>-1) then
        Offs := MyTop-TCustomRVFormattedData(Rows.FMainRVData).GetVOffs;
      if (DRMin<>-1) and (Y<DRMin+Offs) then
        Y := DRMin+Offs;
      if (DRMax<>-1) and (Y<DRMax+Offs) then
        Y := DRMax+Offs;
      Rows.FMainRVData.GetRVStyle.GraphicInterface.DrawTableResizeHLine(Canvas,
        0, TCustomRVFormattedData(Sender).GetWidth, Y);
      end
    else begin
      if (DRMin<>-1) or (DRMax<>-1) then
        Offs := MyLeft-TCustomRVFormattedData(Rows.FMainRVData).GetHOffs;
      if (DRMin<>-1) and (X<DRMin+Offs) then
        X := DRMin+Offs;
      if (DRMax<>-1) and (X<DRMax+Offs) then
        X := DRMax+Offs;
      Rows.FMainRVData.GetRVStyle.GraphicInterface.DrawTableResizeVLine(Canvas,
        X, 0, TCustomRVFormattedData(Sender).GetHeight);
    end;
    Pen.Mode := pmCopy;
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.DoOnCellEditing(Row,Col: Integer; Automatic: Boolean): Boolean;
begin
  Result := True;
  if Assigned(FOnCellEditing) then
    FOnCellEditing(Self, Row, Col, Automatic, Result);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.CreateInplace(ItemNo, Row, Col: Integer;
  BuildJumps, CaretAtStart, CaretAtEnd, SetTime, Unquestioning: Boolean);
var RVData: TCustomRVFormattedData;
    tie: TRVTableInplaceEdit;
    Idx, Offs, ExtraVOffs: Integer;
    CI: Boolean;
    RootRVData: TCustomRVData;
begin
  if not (rvtsInserted in FState) or not IsInEditor or
  (not Unquestioning and not DoOnCellEditing(Row,Col, False)) then
    exit;
  RootRVData := FRows.FMainRVData.GetAbsoluteRootData;
  CI := rvstCreatingInplace in RootRVData.State;
  RootRVData.State := RootRVData.State + [rvstCreatingInplace];
  try
    if ItemNo=-1 then
      ItemNo := GetMyItemNo;
    DestroyInplace(True);
    DeselectPartial;
    TCustomRVFormattedData(FRows.FMainRVData).PartialSelectedItem := nil;
    TCustomRVFormattedData(FRows.FMainRVData).FActiveItem := nil;
    TCustomRVFormattedData(FRows.FMainRVData).RestoreSelBounds(ItemNo, ItemNo, 1, 1);
    TCustomRVFormattedData(FRows.FMainRVData).DoOnSelection(False);
    //Deselect;
    ExtraVOffs := Cells[Row,Col].GetExtraVOffs;
    RVData := TCustomRVFormattedData(FRows.FMainRVData);
    if IsInEditor and TCustomRichViewEdit(TRichViewRVData(RVData).RichView).ReadOnly then
      BuildJumps := True;
    FMinWidthPlus := RVData.CalculateMinItemWidthPlusEx(ItemNo);
    tie := TRVTableInplaceEdit.Create(nil);
    FInplaceEditor := tie;
    tie.Options := TRichViewRVData(RVData).GetOptions;
    tie.OnChangeEx := InplaceEditorChange;
    tie.OnCaretGetOut := InplaceEditorCaretGetout;
    if RVData is TRichViewRVData then begin
      tie.RVData.State := tie.RVData.State+[rvstSkipFormatting];
      try
        tie.BiDiMode := TCustomRichView(TRichViewRVData(RVData).RichView).BiDiMode;
      finally
        tie.RVData.State := tie.RVData.State-[rvstSkipFormatting];
      end;
      tie.Cursor := TCustomRichView(TRichViewRVData(RVData).RichView).Cursor;
      tie.Delimiters := TCustomRichView(TRichViewRVData(RVData).RichView).Delimiters;
      tie.AssignEvents(TCustomRichView(TRichViewRVData(RVData).RichView));
      tie.RVFTextStylesReadMode := TCustomRichView(TRichViewRVData(RVData).RichView).RVFTextStylesReadMode;
      tie.RVFParaStylesReadMode := TCustomRichView(TRichViewRVData(RVData).RichView).RVFParaStylesReadMode;
      tie.OnRVMouseDown := InplaceEditorMouseDown;
      tie.OnRVMouseUp   := InplaceEditorMouseUp;
      tie.OnMouseMove   := InplaceEditorMouseMove;
      tie.OnDragOver    := InplaceEditorDragOver;
      tie.OnDragDrop    := InplaceEditorDragDrop;
      if RVData is TRVEditRVData then
        with TCustomRichViewEdit(TRVEditRVData(RVData).RichView) do begin
          tie.EditorOptions := EditorOptions + [rvoWantTabs];
          tie.CustomCaretInterval := CustomCaretInterval;
          if UndoLimit<>0 then
            tie.UndoLimit := -1 // temporal solution
          else
            tie.UndoLimit := 0;
        end;
    end;
    tie.Color := GetCellColor(Cells[Row,Col]);
    tie.Transparent := CanSeeBackgroundThroughCell(Cells[Row,Col]);
    tie.SetParentRVData(RVData);
    tie.FCell := Cells[Row,Col];
    tie.Parent := TCustomRVData(RVData).GetParentControl;
    tie.RVData.DrainFrom(Cells[Row,Col]);
    tie.SetCell(Row, Col, Self,
      GetRVStyle.GetAsPixels(CellHPadding), GetRVStyle.GetAsPixels(CellVPadding));
    tie.VScrollVisible := False;
    tie.HScrollVisible := False;
    RVData.GetItemClientCoords(ItemNo, MyLeft, MyTop);
    with Cells[Row,Col] do
      SetInplaceBounds(MyLeft+Left, MyTop+Top+ExtraVOffs, Width, Height-ExtraVOffs);
    tie.Format;
    if tie.ClientHeight<tie.RVData.DocumentHeight then begin
      tie.NormalScrolling := True;
      {$IFDEF RICHVIEWDEF4}
      tie.WheelStep := TRichViewEdit(TRichViewRVData(RVData).RichView).WheelStep;
      {$ENDIF}
    end;
    if SetTime then
     tie.FClickTime := GetMessageTime;
    //tie.FirstJumpNo := Cells[Row,Col].FirstJumpNo;
    if BuildJumps then
      TRVTableInplaceRVData(tie.RVData).BuildJumpsCoords(True);
    tie.Visible := True;
    RVData.AssignChosenRVData(Cells[Row,Col], Self);
    ChosenCellRow := Row;
    ChosenCellCol := Col;
    FInplaceMinWidthPlus := tie.RVData.CalculateMinDocWidthPlus(0,nil,nil);
  finally
    if not CI then
      RootRVData.State := RootRVData.State - [rvstCreatingInplace];
  end;
  if CaretAtEnd then begin
    Idx :=  tie.ItemCount-1;
    Offs := tie.GetOffsAfterItem(Idx);
    tie.SetSelectionBounds(Idx,Offs,Idx,Offs);
  end;
  if CaretAtStart then begin
    Idx :=  0;
    Offs := tie.GetOffsBeforeItem(Idx);
    tie.SetSelectionBounds(Idx,Offs,Idx,Offs);
  end;
  if CaretAtStart or CaretAtEnd then begin
    tie.CurTextStyleChange;
    tie.CurParaStyleChange;
  end;
  RootRVData.State := RootRVData.State+[rvstNoKillFocusEvents];
  try
    tie.SetFocusSilent;
  finally
    RootRVData.State := RootRVData.State-[rvstNoKillFocusEvents];
  end;
  if rvflUseJumps in RootRVData.Flags then
    TRVEditRVData(RootRVData).BuildJumpsCoords(False);
  TRVEditRVData(tie.RVData).ActivateCustomCaretTimer;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y,ItemNo: Integer; RVData: TObject): Boolean;
var Row,Col, ERow, ECol: Integer;
    VDRNo,HDRNo:Integer;
    OldInplace: Boolean;
    OldParaNo, OldStyleNo, CellHPaddingPix, CellVPaddingPix: Integer;
begin
  Result  := False;
  if Rows.Empty then
    exit;
  if FMakingSelection and (Button=mbLeft) then
    MouseUp(mbLeft, Shift-[ssLeft, ssRight, ssMiddle], X, Y, ItemNo, RVData);
 if (BusyCount>0) or
     (ssDouble in Shift)
     //(rvstIgnoreNextMouseDown in TCustomRVFormattedData(Rows.FMainRVData).State)
     then exit;
  if (Button in [mbLeft, mbRight]) and
     CanChange and (rvtoEditing in Options) and
     GetCellAt(X, Y, Row, Col, False) then begin
    if (Button=mbRight) and (IsCellSelected(Row,Col) or CompletelySelected) then
      exit;
    OldInplace := (GetEditedCell(ERow,ECol)<>nil) and (ERow=Row) and (ECol=Col);
    CreateInplace(ItemNo, Row, Col, ssCtrl in Shift, False, False, Button=mbLeft, False);
    if (GetEditedCell(ERow,ECol)<>nil) and (ERow=Row) and (ECol=Col) then begin
      SetCaptureControl(FInplaceEditor);
      if not OldInplace then begin
        OldParaNo := FInplaceEditor.CurParaStyleNo;
        OldStyleNo := FInplaceEditor.CurTextStyleNo;
        end
      else begin
        OldParaNo := 0; // avoiding warnings
        OldStyleNo := 0;
      end;
      with Cells[Row,Col] do
        FInplaceEditor.MouseDown(Button, Shift, X-Left, Y-Top-GetExtraVOffs);
      if not OldInplace then begin
        if OldStyleNo = FInplaceEditor.CurTextStyleNo then
          FInplaceEditor.CurTextStyleChange;
        if OldParaNo = FInplaceEditor.CurParaStyleNo then
          FInplaceEditor.CurParaStyleChange;
      end;
      exit;
    end;
  end;
  MyClientTop := 0;
  MyClientLeft := 0;
  if GetCellAt(X, Y, Row, Col, False) then begin
    DestroyInplace(True);
    if Rows.FMainRVData is TRVEditRVData then
      Rows.FMainRVData.GetParentControl.SetFocus;
    if Button=mbLeft then begin
      {
      TCustomRVFormattedData(Rows.FMainRVData).State := TCustomRVFormattedData(Rows.FMainRVData).State+[rvstNoScroll];
      try
        TCustomRVFormattedData(Rows.FMainRVData).SetSelectionBounds(ItemNo, 1, ItemNo, 1);
      finally
        TCustomRVFormattedData(Rows.FMainRVData).State := TCustomRVFormattedData(Rows.FMainRVData).State-[rvstNoScroll];
      end;
      }
      MyClientTop := 0;
      MyClientLeft := 0;
    end;
    if Button = mbLeft then begin
      TCustomRVFormattedData(Rows.FMainRVData).AssignChosenRVData(Cells[Row,Col], Self);
      ChosenCellRow := Row;
      ChosenCellCol := Col;
    end;
    CellHPaddingPix := GetRVStyle.GetAsPixels(CellHPadding);
    CellVPaddingPix := GetRVStyle.GetAsPixels(CellVPadding);
    with Cells[Row,Col] do begin
      if RV_PointInRect(X, Y,
        Left+CellHPaddingPix, Top+CellVPaddingPix,
        Width-CellHPaddingPix*2, Height-CellVPaddingPix*2) then begin
        MouseDown(Button, Shift, X, Y);
      end;
      if (Button=mbLeft) and not (rvstStartingDragDrop in Rows.FMainRVData.GetAbsoluteRootData.State) and
        StartSelecting(Row,Col,False) then begin
        TCustomRVFormattedData(RVData).SetMouseCapture(Self,MyLeft,MyTop);
        TCustomRVFormattedData(Rows.FMainRVData).Invalidate;
      end;
      exit;
    end;
  end;

  if (Button<>mbLeft) or
     not ((rvtoRowSizing in Options) or (rvtoColSizing in Options) or
          (rvtoColSelect in Options) or (rvtoRowSelect in Options)) then begin
    DestroyInplace(True);
    Rows.FMainRVData.GetParentControl.SetFocus;
    exit;
  end;
  if (CanChange and (rvtoColSizing in Options)) or (rvtoRowSelect in Options) then begin
    VDRNo := GetVerticalRuleNo(X, DRMin, DRDelta);
    DRCoord := X;
    end
  else
    VDRNo := -1;
  if (VDRNo>0) and CanChange and (rvtoColSizing in Options) then begin
    DRNo := VDRNo;
    dec(DRDelta,X);
    TCustomRVFormattedData(RVData).AssignXorDrawing(XorDrawing);
    TCustomRVFormattedData(RVData).SetMouseCapture(Self,MyLeft,MyTop);
    DRMax := -1;
    if ssShift in Shift then
      Include(FState, rvtsDRChangeTableWidth)
    else
      Exclude(FState, rvtsDRChangeTableWidth);
    Include(FState, rvtsVerticalDraggedRule);
    SaveInplace;
    end
  else begin
    if (CanChange and (rvtoRowSizing in Options)) or (rvtoColSelect in Options) then begin
      HDRNo := GetHorizontalRuleNo(Y,DRMin,DRDelta);
      DRCoord := Y;
      end
    else
      HDRNo := -1;
    if (HDRNo>0) and CanChange and (rvtoRowSizing in Options) then begin
      DRNo := HDRNo;
      dec(DRDelta,Y);
      TCustomRVFormattedData(RVData).AssignXorDrawing(XorDrawing);
      TCustomRVFormattedData(RVData).SetMouseCapture(Self,MyLeft,MyTop);
      DRMax := -1;
      Exclude(FState, rvtsVerticalDraggedRule);
      SaveInplace;
      end
    else if (HDRNo=0) and (rvtoColSelect in Options) then begin
      Col := GetColNo(X);
      if Col>=0 then begin
        SelectCols(Col,1);
        TCustomRVFormattedData(RVData).SetMouseCapture(Self,MyLeft,MyTop);
      end;
      end
    else if (VDRNo=0) and (rvtoRowSelect in Options) then begin
      Row := GetRowNo(Y);
      if Row>=0 then begin
        SelectRows(Row,1);
        TCustomRVFormattedData(RVData).SetMouseCapture(Self,MyLeft,MyTop);
      end;
      end
//    else
//      DestroyInplace(True);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.ResizeRow(Index, Height: Integer);
  {...........................................}
  procedure SetHeight(r,h,y: Integer);
  var c,a,b,a1,b1: Integer;
      Changed: Boolean;
      Cell: TRVTableCellData;
      RVStyle: TRVStyle;
  begin
    a := h;
    RVStyle := GetRVStyle;
    dec(h, RVStyle.GetAsPixels(CellVPadding)*2);
    if r<RowCount-1 then
      dec(h, RVStyle.GetAsPixels(CellVSpacing) div 2 + RVStyle.GetAsPixels(CellBorderWidth))
    else
      dec(h, (RVStyle.GetAsPixels(BorderWidth)+RVStyle.GetAsPixels(BorderVSpacing)+
        RVStyle.GetAsPixels(CellBorderWidth)+1) div 2);
    inc(y, h-a);
    if h<0 then
      h := 0;
    h := GetRVStyle.PixelsToUnits(h);
    Changed := False;
    with Rows[r] do begin
      for c := 0 to Count-1 do
        if (Items[c]<>nil) and (Items[c].RowSpan=1) then begin
          SetCellBestHeight(h,r,c);
          Changed := True;
        end;
      for c := 0 to Count-1 do
        if (Items[c]=nil) then begin
          Cell := Rows.GetMainCell(r,c,a,b);
          if a=r then continue;
          if (r=RowCount-1) or
             (Cells[r+1,c]<>nil) or
             (Cell<>Rows.GetMainCell(r+1,c,a1,b1)) then begin
            if Changed then
              h := 0
            else begin
              h := y-Cell.Top;
              if h<0 then
                h := 0;
            end;

            SetCellBestHeight(GetRVStyle.PixelsToUnits(h),a,b);
          end;
        end;
    end;
  end;
  {........................................}
var edit: TCustomRichViewEdit;
begin
  InitUndo;
  try
    SetHeight(Index, Height, Fmt.RowStarts[Index]+Height);
  finally
    DoneUndo;
  end;
  Fmt.FWidth := 0;
  if (Rows.FMainRVData is TRVEditRVData) then begin
    TRVEditRVData(Rows.FMainRVData).Reformat(False, False, False, GetMyItemNo, False);
    TCustomRVFormattedData(Rows.FMainRVData).Invalidate;
    Change;
    Edit := Rows.FMainRVData.GetAbsoluteRootData.GetParentControl as TCustomRichViewEdit;
    if Assigned(Edit.OnItemResize) then
      Edit.OnItemResize(Edit, TCustomRVFormattedData(Rows.FMainRVData),
        GetMyItemNo, 0, Index);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.ResizeCol(Index, Width: Integer; Shift: Boolean);
  {...........................................}
  procedure SetWidth(c,w,x: Integer; Decrement: Boolean);
  var r,a,b,a1,b1,oldw: Integer;
      //Changed: Boolean;
      Cell: TRVTableCellData;
      RVStyle: TRVStyle;
      CellHPaddingPix, CellHSpacingPix, CellBorderWidthPix,
      BorderWidthPix, BorderHSpacingPix: Integer;
  begin
    RVStyle := GetRVStyle;
    CellHSpacingPix := RVStyle.GetAsPixels(CellHSpacing);
    CellBorderWidthPix := RVStyle.GetAsPixels(CellBorderWidth);
    CellHPaddingPix := RVStyle.GetAsPixels(CellHPadding);
    BorderWidthPix := RVStyle.GetAsPixels(BorderWidth);
    BorderHSpacingPix := RVStyle.GetAsPixels(BorderHSpacing);
    oldw := w-CellHPaddingPix*2;    
    if Decrement then begin
      if c<ColCount-1 then
        x := Fmt.ColStarts[c+1] - (CellBorderWidthPix+(CellHSpacingPix+1) div 2)
      else
        x := Fmt.FWidth - (BorderWidthPix+BorderHSpacingPix+CellBorderWidthPix) div 2;
      x  := x + (Fmt.ColStarts[c]-Fmt.ColStarts[c-1] - (CellHSpacingPix+1) div 2) -
        w - CellBorderWidthPix;
      w := x - Fmt.ColStarts[c];
    end;
    a := w;
    dec(w, CellHPaddingPix*2);
    if c<ColCount-1 then begin
      dec(w, CellBorderWidthPix);
      dec(w, CellHSpacingPix div 2);
      end
    else
      dec(w, (BorderWidthPix+BorderHSpacingPix+CellBorderWidthPix+1) div 2);

    if w<=0 then
      w := 1;
    w := GetRVStyle.PixelsToUnits(w);
    //Changed := False;
    for r := 0 to RowCount-1 do
      if (Cells[r,c]<>nil) and (Cells[r,c].ColSpan=1) then begin
        SetCellBestWidth(w,r,c);
        //Changed := True;
      end;
    for r := 0 to RowCount-1 do
      if (Cells[r,c]=nil) then begin
        Cell := Rows.GetMainCell(r,c,a,b);
        if (b=c) or Decrement then continue;
        if (c=ColCount-1) or
           (Cells[r,c+1]<>nil) or
           (Cell<>Rows.GetMainCell(r,c+1,a1,b1)) then begin
          //if Changed then
          //  w := 0
          //else begin
          // // w := x-Cell.Left;
            w := Cell.Width - Fmt.ColWidths[c]+oldw;
            if w<=0 then
              w := 1;
          //end;
          SetCellBestWidth(GetRVStyle.PixelsToUnits(w),a,b)
        end;
      end;
  end;
  {...........................................}
  procedure SetPercentWidth(c: Integer; w: TRVStyleLength; x: Integer; Decrement: Boolean);
  var r,a,b,a1,b1, he: Integer;
      Changed: Boolean;
      Cell: TRVTableCellData;
      RVStyle: TRVStyle;
      CellHSpacingPix, CellBorderWidthPix,
      BorderWidthPix, BorderHSpacingPix: Integer;
  begin
    RVStyle := GetRVStyle;
    CellHSpacingPix := RVStyle.GetAsPixels(CellHSpacing);
    CellBorderWidthPix := RVStyle.GetAsPixels(CellBorderWidth);
    BorderWidthPix := RVStyle.GetAsPixels(BorderWidth);
    BorderHSpacingPix := RVStyle.GetAsPixels(BorderHSpacing);
    he := GetHorzExtraPix;
    a := w;
    if c<ColCount-1 then begin
      dec(w, CellBorderWidthPix);
      dec(w, CellHSpacingPix div 2);
      end
    else
      dec(w, (BorderWidthPix+BorderHSpacingPix+CellBorderWidthPix) div 2);
    inc(x, w-a);
    w := - w*100 div (Fmt.FWidth-he);
    if w>=0 then w := -1;
    Changed := False;
    for r := 0 to RowCount-1 do
      if (Cells[r,c]<>nil) and (Cells[r,c].ColSpan=1) then begin
        SetCellBestWidth(w,r,c);
        Changed := True;
      end;
    for r := 0 to RowCount-1 do
      if (Cells[r,c]=nil) then begin
        Cell := Rows.GetMainCell(r,c,a,b);
        if b=c then continue;
        if (c=ColCount-1) or
           (Cells[r,c+1]<>nil) or
           (Cell<>Rows.GetMainCell(r,c+1,a1,b1)) then begin
          if Changed then
            w := 0
          else begin
            w := -(x-Cell.Left)*100 div (Fmt.FWidth-he);
            if w>=0 then
              w := -1;
          end;
          SetCellBestWidth(w,a,b);
        end;
      end;
  end;
  {...........................................}
var pc: Boolean;
    data: Integer;
    Edit: TCustomRichViewEdit;
begin
  data := BeginModify(GetMyItemNo);
  pc := Rows.IsPercentWidthColumn(Index);
  InitUndo;
  try
    if pc then begin
      SetPercentWidth(Index, Width, Fmt.ColStarts[Index]+Width, False);
      end
    else begin
      SetWidth(Index, Width, Fmt.ColStarts[Index]+Width, False);
      if not Shift and (Index+1<>ColCount) and
         not Rows.IsPercentWidthColumn(Index+1) then
        SetWidth(Index+1, Width, Fmt.ColStarts[Index]+Width, True);
    end;
  finally
    DoneUndo;
  end;
  Fmt.FWidth := 0;
  EndModify(GetMyItemNo, Data);
  Change;
  Edit := Rows.FMainRVData.GetAbsoluteRootData.GetParentControl as TCustomRichViewEdit;
  if Assigned(Edit.OnItemResize) then
    Edit.OnItemResize(Edit, TCustomRVFormattedData(Rows.FMainRVData),
      GetMyItemNo, 1, Index);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y,ItemNo: Integer; RVData: TObject): Boolean;
var Row,Col, CellHPaddingPix, CellVPaddingPix: Integer;
begin
  Result := False;
  if Rows.Empty then
    exit;
  if BusyCount>0 then exit;
  MyClientTop := 0;
  MyClientLeft := 0;
  CellHPaddingPix := GetRVStyle.GetAsPixels(CellHPadding);
  CellVPaddingPix := GetRVStyle.GetAsPixels(CellVPadding);
  if (Button=mbLeft) then begin
    if TCustomRVFormattedData(RVData).UsingThisXorDrawing(XORDrawing) then begin
      TCustomRVFormattedData(RVData).UnAssignXorDrawing(XorDrawing);
      if BeforeChange then
        if rvtsVerticalDraggedRule in FState then begin
          if DRCoord<>X then
            ResizeCol(DRNo-1, X-DRMin+DRDelta, rvtsDRChangeTableWidth in FState);
          end
        else begin
          if DRCoord<>Y then
            ResizeRow(DRNo-1, Y-DRMin+DRDelta);
        end;
      TCustomRVFormattedData(RVData).ReleaseMouseCapture(Self);
      RestoreInplace;
      exit;
    end;
    //TCustomRVFormattedData(RVData).GetItemClientCoords(ItemNo, MyClientTop,MyC
    MyClientTop := 0;
    MyClientLeft := 0;
    if FMakingSelection then begin
      if FInplaceEditor=nil then begin
        with Cells[FSelStartRow,FSelStartCol] do begin
          MouseUp(Button, Shift, X, Y);
        end;
        if (TCustomRVFormattedData(FRows.FMainRVData).GetChosenRVData<>nil) and
           (rvstCompletelySelected in TCustomRVFormattedData(FRows.FMainRVData).GetChosenRVData.State) then
          TCustomRVFormattedData(FRows.FMainRVData).UnassignChosenRVData(TCustomRVFormattedData(FRows.FMainRVData).GetChosenRVData);
      end
      end
    else
      if FInplaceEditor=nil then begin
        if GetCellAt(X, Y, Row, Col, False) then begin
          with Cells[Row,Col] do
            if RV_PointInRect(X, Y,
              Left+CellHPaddingPix, Top+CellVPaddingPix,
              Width-CellHPaddingPix*2, Height-CellVPaddingPix*2) then
              MouseUp(Button, Shift, X, Y);
        end;
      end;
    TCustomRVFormattedData(RVData).ReleaseMouseCapture(Self);
    FStoredInplace.Stored := False;
    FMakingSelection := False;
    end
  else if FInplaceEditor=nil then begin
    if GetCellAt(X, Y, Row, Col, False) then begin
      with Cells[Row,Col] do
        if RV_PointInRect(X, Y,
          Left+CellHPaddingPix, Top+CellVPaddingPix,
          Width-CellHPaddingPix*2, Height-CellVPaddingPix*2) then begin
          MouseUp(Button, Shift, X, Y);
          if (Button=mbRight) and (rvoRClickDeselects in Rows.FMainRVData.Options) and
             not IsCellSelected(Row,Col) and not CompletelySelected
             and not ((ChosenCellRow=Row) and (ChosenCellCol=Col) and CellIsChosen)
             and (GetChosenItem=nil)
             then begin
            TCustomRVFormattedData(Rows.FMainRVData).SetSelectionBounds(ItemNo, 1, ItemNo, 1);
          end;
        end;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.UpdateCellXCoords(Fmt: TRVTableItemFormattingInfo;
  NoCaching, Reformatting: Boolean);
var r,c,l,w,i, cw: Integer;
    AllDH, StartAllDH, CurDH, Cnt, iew: Integer;
    FormattingPart: Boolean;
    RVStyle: TRVStyle;
    CellHSpacingPix, CellHPaddingPix, DblCellHPaddingPix,
    CellBorderWidthPix, BorderWidthPix, BorderHSpacingPix: Integer;
begin
  RVStyle := GetRVStyle;
  CellHSpacingPix := RVStyle.GetAsDevicePixelsX(CellHSpacing, cursad);
  CellHPaddingPix := RVStyle.GetAsDevicePixelsX(CellHPadding, cursad);
  DblCellHPaddingPix := CellHPaddingPix*2;
  CellBorderWidthPix := RVStyle.GetAsDevicePixelsX(CellBorderWidth, cursad);
  BorderWidthPix := RVStyle.GetAsDevicePixelsX(BorderWidth, cursad);
  BorderHSpacingPix := RVStyle.GetAsDevicePixelsX(BorderHSpacing, cursad);

  Cnt := ColCount;
  Fmt.ColStarts.Count := Cnt;
  AllDH := (CellHSpacingPix+(CellHPaddingPix+CellBorderWidthPix)*2)*Cnt;
  StartAllDH := AllDH;
  l := BorderWidthPix+BorderHSpacingPix+CellBorderWidthPix;
  for c := 0 to ColCount-1 do begin
    Fmt.ColStarts[c] := l;
    CurDH := AllDH div Cnt;
    dec(AllDH,CurDH);
    inc(l, Fmt.ColWidths[c]+CurDH);
    dec(Cnt);
  end;
  for r := 0 to RowCount-1 do begin
    for c := 0 to ColCount-1 do begin
      l := Fmt.ColStarts[c];
      w := Fmt.ColWidths[c];
      if Cells[r,c]<>nil then begin
        cw := w + DblCellHPaddingPix;
        for i := 1 to Cells[r,c].ColSpan-1 do
          inc(cw, Fmt.ColWidths[c+i]);
        inc(cw, MulDiv(StartAllDH,Cells[r,c].ColSpan-1,ColCount));
        if Fmt.Rows=nil then
          with Cells[r,c] do begin
            FLeft := l;
            FWidth  := cw;
          end
        else
          if Fmt.Rows[r*ColCount+c]<>nil then
            with TCellPtblRVData(Fmt.Rows[r*ColCount+c]) do begin
              DX := l+CellHPaddingPix;
              Width := cw-DblCellHPaddingPix;
            end;
      end;
    end;
  end;
  if Fmt.Rows=nil then begin
    FormattingPart := rvstFormattingPart in Rows.FMainRVData.GetAbsoluteRootData.State;
    Include(Rows.FMainRVData.GetAbsoluteRootData.State, rvstFormattingPart);
    try
      for r := 0 to RowCount-1 do
        with Rows[r] do
          for c := 0 to Count-1 do
            if (Items[c]<>nil) then begin
              Items[c].State := Items[c].State+[rvstDoNotMoveChildren];
              try
               Items[c].Format(NoCaching);
              finally
                Items[c].State := Items[c].State-[rvstDoNotMoveChildren];
              end;
            end;
      if (FInplaceEditor<>nil) and
         (TRVTableInplaceEdit(FInplaceEditor).FCell<>nil)  then begin
          Include(FState, rvtsInplaceIsReformatting);
          try
            iew := FInplaceEditor.Width;
            FInplaceEditor.Width := TRVTableInplaceEdit(FInplaceEditor).FCell.Width;
            if (iew=FInplaceEditor.Width) and Reformatting then
              FInplaceEditor.Reformat;
          finally
            Exclude(FState, rvtsInplaceIsReformatting);
          end;
      end;
    finally
      if not FormattingPart then
        Exclude(Rows.FMainRVData.GetAbsoluteRootData.State, rvstFormattingPart);
    end;
    end
  else begin
    for r := 0 to Fmt.Rows.Count-1 do
      if Fmt.Rows[r]<>nil then
        TCellPtblRVData(Fmt.Rows[r]).Format(NoCaching);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.UpdateCellYCoords(Fmt: TRVTableItemFormattingInfo);
var r,c,t,h, i, ch: Integer;
    StartAllDV,AllDV,CurDV,Cnt: Integer;
    RVStyle: TRVStyle;
    CellVSpacingPix, CellVPaddingPix, DblCellVPaddingPix,
    CellBorderWidthPix, BorderWidthPix, BorderVSpacingPix: Integer;
begin
  RVStyle := GetRVStyle;
  CellVSpacingPix := RVStyle.GetAsDevicePixelsY(CellVSpacing, cursad);
  CellVPaddingPix := RVStyle.GetAsDevicePixelsY(CellVPadding, cursad);
  DblCellVPaddingPix := CellVPaddingPix*2;
  CellBorderWidthPix := RVStyle.GetAsDevicePixelsY(CellBorderWidth, cursad);
  BorderWidthPix := RVStyle.GetAsDevicePixelsY(BorderWidth, cursad);
  BorderVSpacingPix := RVStyle.GetAsDevicePixelsY(BorderVSpacing, cursad);
  AllDV := (CellVSpacingPix+(CellVPaddingPix+CellBorderWidthPix)*2)*RowCount;
  StartAllDV := AllDV;
  t := BorderWidthPix+BorderVSpacingPix+CellBorderWidthPix;
  Cnt := RowCount;
  for r := 0 to RowCount-1 do begin
    h := Fmt.RowHeights[r];
    Fmt.RowStarts[r] := t;
    for c := 0 to ColCount-1 do begin
      if Cells[r,c]<>nil then begin
        ch := h + DblCellVPaddingPix;
        for i := 1 to Cells[r,c].RowSpan-1 do
          inc(ch, Fmt.RowHeights[r+i]);
        inc(ch, MulDiv(StartAllDV,Cells[r,c].RowSpan-1,RowCount));
        if Fmt.Rows=nil then
          with Cells[r,c] do begin
            FTop  := t;
            FHeight := ch;
          end
        else
          if Fmt.Rows[r*ColCount+c]<>nil then
            with TCellPtblRVData(Fmt.Rows[r*ColCount+c]) do begin
              DY  := t+CellVPaddingPix;
              Height := ch-DblCellVPaddingPix;
            end;
      end;
    end;
    CurDV := AllDV div Cnt;
    dec(AllDV,CurDV);
    inc(t, h+CurDV);
    dec(Cnt);
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetCellAt_(X, Y: Integer; var Row,Col: Integer;
  IgnoreBorders: Boolean): Boolean;
var r,c,dx,dy,dh,dv: Integer;
begin
  dh := GetRVStyle.GetAsPixels(CellHSpacing)+
    GetRVStyle.GetAsPixels(CellBorderWidth)*2;
  if dh<3 then
    dh := 3-dh
  else
    dh := 0;
  dv := GetRVStyle.GetAsPixels(CellVSpacing)+
    GetRVStyle.GetAsPixels(CellBorderWidth)*2;
  if dv<3 then
    dv := 3-dv
  else
    dv := 0;
  Result := False;
  dx := Cells[0,0].Left;
  dy := Cells[0,0].Top;
  if not RV_PointInRect(X,Y,dx+1,dy+1,Fmt.FWidth-dx*2-2,Fmt.FHeight-dy*2-2) then exit;
  row := RowCount-1; // to change to bsearch !
  for r := 0 to RowCount-2 do
    if Fmt.RowStarts[r+1]>Y then begin
      row := r;
      break;
    end;
  with Rows[row] do begin
    col := Count-1;
    for c := 0 to Count-2 do // to change to bsearch !
      if (Fmt.ColStarts[c+1]>X) then begin
        col := c;
        break;
      end;
  end;
  Rows.GetMainCell(row, col, row, col);
  if IgnoreBorders then
    Result := True
  else
    with Cells[row,col]  do
      Result := RV_PointInRect(X,Y, Left+1+(dh div 2),Top+1+(dv div 2),Width-2-dh,Height-2-dv);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetCellAt(X, Y: Integer; var Row, Col: Integer;
  IgnoreBorders: Boolean {$IFDEF RICHVIEWDEF4}=False{$ENDIF}): Boolean;
begin
  if (MouseRow>=0) and (MouseRow<RowCount) and
     (MouseCol>=0) and (MouseCol<ColCount) and
     (Cells[MouseRow, MouseCol]<>nil) then
    with Cells[MouseRow, MouseCol] do
      if RV_PointInRect(X,Y, Left+1, Top+1, Width-2, Height-2) then begin
        Row := MouseRow;
        Col := MouseCol;
        Result := True;
        exit;
      end;
  Result := GetCellAt_(X,Y, Row, Col, IgnoreBorders);
  if Result then begin
    MouseRow := Row;
    MouseCol := Col;
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.IsCellSelected(Row, Col: Integer): Boolean;
var l,t,w,h: Integer;
    Cell: TRVTableCellData;
begin

  Result := False;
  if not (rvtsSelExists in FState) then
    exit;
  Cell := FRows.GetMainCell(Row,Col,Row,Col);
  GetNormalizedSelectionBounds(False, t,l,w,h);
  if not (rvtsSelExists in FState) then
    exit;
  Result := (Col+Cell.ColSpan>l) and (Col<l+w) and
            (Row+Cell.RowSpan>t) and (Row<t+h);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.InsertCols(Index, Count, CopyIndex: Integer
                                      {$IFDEF RICHVIEWDEF4};Select:Boolean=True{$ENDIF});
begin
  if (Index<0) or (Index>ColCount) or
     (CopyIndex<-1) or (CopyIndex>=ColCount) then
    raise ERichViewError.Create(errInvalidIndex);
  DestroyInplace(True);
  InitUndo;
  try
    Rows.InsertCols(Index, Count, CopyIndex, False);
  finally
    DoneUndo;
  end;
  {$IFDEF RICHVIEWDEF4}
  if Select then
    SelectCols(Index, Count);
  {$ENDIF}
  ResetLiveSpell;  
  Changed;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.InsertRows(Index, Count, CopyIndex: Integer
                                      {$IFDEF RICHVIEWDEF4};Select:Boolean=True{$ENDIF});
begin
  if (Index<0) or (Index>RowCount) or
     (CopyIndex<-1) or (CopyIndex>=RowCount) then
    raise ERichViewError.Create(errInvalidIndex);
  DestroyInplace(True);
  InitUndo;
  try
    Rows.InsertRows(Index, Count, CopyIndex, False);
  finally
    DoneUndo;
  end;
  {$IFDEF RICHVIEWDEF4}
  if Select then
    SelectRows(Index, Count);
  {$ENDIF}
  ResetLiveSpell;  
  Changed;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.InsertColsLeft(Count: Integer);
var r,c,cs,rs: Integer;
begin
  if not GetNormalizedSelectionBounds(True, r,c,cs,rs) then begin
    Rows.FMainRVData.Beep;
    exit;
  end;
  InsertCols(c, Count, c);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.InsertColsRight(Count: Integer);
var r,c,cs,rs: Integer;
begin
  if not GetNormalizedSelectionBounds(True, r,c,cs,rs) then begin
    Rows.FMainRVData.Beep;
    exit;
  end;
  InsertCols(c+cs, Count, c+cs-1);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.InsertRowsAbove(Count: Integer);
var r,c,cs,rs: Integer;
begin
  if not GetNormalizedSelectionBounds(True, r,c,cs,rs) then begin
    Rows.FMainRVData.Beep;
    exit;
  end;
  InsertRows(r, Count, r);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.InsertRowsBelow(Count: Integer);
var r,c,cs,rs: Integer;
begin
  if not GetNormalizedSelectionBounds(True, r,c,cs,rs) then begin
    Rows.FMainRVData.Beep;
    exit;
  end;
  InsertRows(r+rs, Count, r+rs-1);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.DeleteRows(Index, Count: Integer;
                                      DecreaseHeight: Boolean);
var er,ec,mr,mc: Integer;
begin
  if Rows.Empty then
    exit;
  if (Index<0) or (Index>=RowCount) or (Count<=0) or
     ((Index=0) and (Count>RowCount)) then
    raise ERichViewError.Create(errInvalidIndex);
  if GetEditedCell(er,ec)<>nil then begin
    if er>=Index+Count then
      dec(er, Count)
  end;
  DestroyInplace(True);
  Deselect;
  InitUndo;
  try
    Rows.DeleteRows(Index,Count,DecreaseHeight);
  finally
    DoneUndo;
  end;
  if (RowCount>0)  and (rvtoEditing in Options) then begin
    if er<0 then begin
      ec := 0;
      er := Index;
    end;
    if er>=RowCount then
      er := RowCount-1;
    Rows.GetMainCell(er,ec,mr,mc);
    CreateInplace(-1, mr,mc, False, True, False, False, False);
  end;
  ResetLiveSpell;  
  Changed;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.DeleteCols(Index, Count: Integer; DecreaseWidth: Boolean);
var er,ec,mr,mc: Integer;
begin
  if Rows.Empty then
    exit;
  if (Index<0) or (Index>=ColCount) or (Count<=0) or
     ((Index=0) and (Count>ColCount)) then
    raise ERichViewError.Create(errInvalidIndex);
  if GetEditedCell(er,ec)<>nil then begin
    if ec>=Index+Count then
      dec(ec, Count)
  end;
  DestroyInplace(True);
  Deselect;
    InitUndo;
  try
    Rows.DeleteCols(Index,Count,DecreaseWidth);
  finally
    DoneUndo;
  end;
  if (RowCount>0) and (ColCount>0) and CanChange and (rvtoEditing in Options) then begin
    if er<0 then begin
      er := 0;
      ec := Index;
    end;
    if ec>=ColCount then
      ec := ColCount-1;
    Rows.GetMainCell(er,ec,mr,mc);
    CreateInplace(-1, mr,mc, False, True, False, False, False);
  end;
  ResetLiveSpell;  
  Changed;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.DeleteSelectedRows;
var r,c,cs,rs: Integer;
begin
  if not GetNormalizedSelectionBounds(True, r,c,cs,rs) then begin
    Rows.FMainRVData.Beep;
    exit;
  end;
  DeleteRows(r, rs, True);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.DeleteSelectedCols;
var r,c,cs,rs: Integer;
begin
  if not GetNormalizedSelectionBounds(True, r,c,cs,rs) then begin
    Rows.FMainRVData.Beep;
    exit;
  end;
  DeleteCols(c, cs, True);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.DeleteEmptyCols;
var r,c: Integer;
    empty: Boolean;
begin
  if Rows.Empty then
    exit;
  for c := ColCount-1 downto 0 do begin
    empty := True;
    for r := 0 to RowCount-1 do
      if Cells[r,c]<>nil then begin
        empty := False;
        break;
      end;
    if empty then
      DeleteCols(c,1,False);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.DeleteEmptyRows;
var r,c: Integer;
    empty: Boolean;
begin
  for r := RowCount-1 downto 0 do begin
    empty := True;
    for c := 0 to ColCount-1 do
      if Cells[r,c]<>nil then begin
        empty := False;
        break;
      end;
    if empty then
      DeleteRows(r,1,False);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.Deselect;
begin
  {
  if FInplaceEditor<>nil then begin
    FInplaceEditor.Deselect;
    FInplaceEditor.Invalidate;
    exit;
  end;
  }
  DestroyInplace(True);
  Exclude(FState, rvtsSelExists);
  FSelStartCol := -1;
  FSelStartRow := -1;
  FMakingSelection := False;
  FSelColOffs  := 0;
  FSelRowOffs  := 0;
  UpdateCellSel;
  UnAssignActiveCell;
  if Rows.FMainRVData is TCustomRVFormattedData then begin
    TCustomRVFormattedData(Rows.FMainRVData).Invalidate;
    TCustomRVFormattedData(Rows.FMainRVData).DoSelect;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.Select(StartRow, StartCol, RowOffs, ColOffs: Integer);
begin
  if not (rvtsInserted in FState) then
    exit;
  DestroyInplace(True);
  if not (Rows.FMainRVData is TCustomRVFormattedData) then
    exit;
  if not (rvoAllowSelection in Rows.FMainRVData.Options) then
    exit;
  TCustomRVFormattedData(Rows.FMainRVData).PartialSelectedItem := Self;
  Include(FState, rvtsSelExists);
  FSelStartCol := StartCol;
  FSelStartRow := StartRow;
  FSelColOffs  := ColOffs;
  FSelRowOffs  := RowOffs;
  UpdateCellSel;
  if Rows.FMainRVData is TCustomRVFormattedData then begin
    TCustomRVFormattedData(Rows.FMainRVData).Invalidate;
    TCustomRVFormattedData(Rows.FMainRVData).DoSelect;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SelectCols(StartCol, Count: Integer);
begin
  Select(0, StartCol, RowCount-1, Count-1);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SelectRows(StartRow, Count: Integer);
begin
  Select(StartRow, 0, Count-1, ColCount-1);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetSelectionBounds(var StartRow, StartCol,
                                                 RowOffs, ColOffs: Integer): Boolean;
begin
  StartCol := FSelStartCol;
  StartRow := FSelStartRow;
  ColOffs  := FSelColOffs;
  RowOffs  := FSelRowOffs;
  Result := rvtsSelExists in FState;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetNormalizedSelectionBounds(IncludeEditedCell: Boolean;
     var TopRow, LeftCol, ColSpan, RowSpan: Integer): Boolean;
var r,c: Integer;
    Cell: TRVTableCellData;
begin

  if ((FSelStartRow<0) or (FSelStartCol<0)) and
     (rvtsSelExists in FState) then begin
    Exclude(FState, rvtsSelExists);
    TCustomRVFormattedData(FRows.FMainRVData).ReleaseMouseCapture(Self);
    if (TCustomRVFormattedData(FRows.FMainRVData).GetChosenRVData<>nil) then
      TCustomRVFormattedData(FRows.FMainRVData).SilentReplaceChosenRVData(nil);
    FMakingSelection := False;
  end;

  if not (rvtsSelExists in FState) then begin
    if IncludeEditedCell and (FInplaceEditor<>nil) then begin
      TopRow := TRVTableInplaceEdit(FInplaceEditor).FRow;
      LeftCol := TRVTableInplaceEdit(FInplaceEditor).FCol;
      Cell := Cells[TopRow,LeftCol];
      ColSpan := Cell.ColSpan;
      RowSpan := Cell.RowSpan;
      Result := True;
      exit;
      end
    else
      Result := False;
    exit;
  end;
  Cell := Rows.GetMainCell(FSelStartRow,FSelStartCol,TopRow,LeftCol);
  ColSpan := LeftCol+Cell.ColSpan-1;
  RowSpan := TopRow+Cell.RowSpan-1;
  Cell := Rows.GetMainCell(FSelStartRow+FSelRowOffs,
                           FSelStartCol+FSelColOffs,
                           r,c);
  if r<TopRow then
    TopRow := r;
  if c<LeftCol then
    LeftCol := c;
  if r+Cell.RowSpan-1>RowSpan then
    RowSpan := r+Cell.RowSpan-1;
  if c+Cell.ColSpan-1>ColSpan then
    ColSpan := c+Cell.ColSpan-1;
  dec(ColSpan, LeftCol-1);
  dec(RowSpan, TopRow-1);
  Result   := True;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetNormalizedSelectionBoundsEx(IncludeEditedCell: Boolean;
     var TopRow, LeftCol, ColSpan, RowSpan: Integer): Boolean;
var r, c, dr, dc, mr, mc: Integer;
    Cell: TRVTableCellData;
begin

  if ((FSelStartRow<0) or (FSelStartCol<0)) and
     (rvtsSelExists in FState) then begin
    Exclude(FState, rvtsSelExists);
    TCustomRVFormattedData(FRows.FMainRVData).ReleaseMouseCapture(Self);
    if (TCustomRVFormattedData(FRows.FMainRVData).GetChosenRVData<>nil) then
      TCustomRVFormattedData(FRows.FMainRVData).SilentReplaceChosenRVData(nil);
    FMakingSelection := False;
  end;

  if not (rvtsSelExists in FState) then begin
    if IncludeEditedCell and (FInplaceEditor<>nil) then begin
      TopRow := TRVTableInplaceEdit(FInplaceEditor).FRow;
      LeftCol := TRVTableInplaceEdit(FInplaceEditor).FCol;
      Cell := Cells[TopRow,LeftCol];
      ColSpan := Cell.ColSpan;
      RowSpan := Cell.RowSpan;
      Result := True;
      exit;
      end
    else
      Result := False;
    exit;
  end;

  TopRow  := RowCount;
  LeftCol := ColCount;
  ColSpan := -1;
  RowSpan := -1;
  
  if FSelRowOffs>=0 then
    dr := 1
  else
    dr := -1;
  if FSelColOffs>=0 then
    dc := 1
  else
    dc := -1;
  // checking the first row in the selection
  r := FSelStartRow;
  c := FSelStartCol;
  while True do begin
    Cell := Rows.GetMainCell(r, c, mr, mc);
    if mr<TopRow then
      TopRow := mr;
    if mr+Cell.RowSpan-1>RowSpan then
      RowSpan := mr+Cell.RowSpan-1;
    if c=FSelStartCol+FSelColOffs then
      break;
    inc(c, dc);
  end;
  // checking the last row in the selection
  r := FSelStartRow+FSelRowOffs;
  c := FSelStartCol;
  while True do begin
    Cell := Rows.GetMainCell(r, c, mr, mc);
    if mr<TopRow then
      TopRow := mr;
    if mr+Cell.RowSpan-1>RowSpan then
      RowSpan := mr+Cell.RowSpan-1;
    if c=FSelStartCol+FSelColOffs then
      break;
    inc(c, dc);
  end;
  // checking the first selected column
  c := FSelStartCol;
  r := FSelStartRow;
  while True do begin
    Cell := Rows.GetMainCell(r, c, mr, mc);
    if mc<LeftCol then
      LeftCol := mc;
    if mc+Cell.ColSpan-1>ColSpan then
      ColSpan := mc+Cell.ColSpan-1;
    if r=FSelStartRow+FSelRowOffs then
      break;
    inc(r, dr);
  end;
  // checking the last selected column
  c := FSelStartCol+FSelColOffs;
  r := FSelStartRow;
  while True do begin
    Cell := Rows.GetMainCell(r, c, mr, mc);
    if mc<LeftCol then
      LeftCol := mc;
    if mc+Cell.ColSpan-1>ColSpan then
      ColSpan := mc+Cell.ColSpan-1;
    if r=FSelStartRow+FSelRowOffs then
      break;
    inc(r, dr);
  end;
  dec(ColSpan, LeftCol-1);
  dec(RowSpan, TopRow-1);
  Result   := True;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.UpdateCellSel;
var r,c: Integer;
begin
  for r := 0 to RowCount-1 do
    with Rows[r] do
      for c := 0 to Count-1 do
        if Items[c]<>nil then begin
          if IsCellSelected(r,c) then
            Include(Items[c].State, rvstCompletelySelected)
          else begin
            if not ({not CanChange and} (r=FSelStartRow) and (c=FSelStartCol)) then
              Items[c].Deselect(nil, True);
            Exclude(Items[c].State, rvstCompletelySelected);
          end;
        end;
  {$IFNDEF RVDONOTUSEANIMATION}
  if Rows.FMainRVData is TCustomRVFormattedData then
    TCustomRVFormattedData(Rows.FMainRVData).ResetAniBackground;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.DeselectPartial;
begin
  Deselect;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.PartiallySelected: Boolean;
begin
  Result := rvtsSelExists in FState;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.AdjustInserted(x, y: Integer; adjusty: Boolean; RVStyle: TRVStyle);
var r,c: Integer;
begin
  if (FInplaceEditor<>nil) and
     (TRVTableInplaceEdit(FInplaceEditor).FCell<>nil) then
    with TRVTableInplaceEdit(FInplaceEditor).FCell do begin
      FInplaceEditor.Tag := y+Top+GetExtraVOffs;
      SetInplaceBounds(x+Left, RV_GetYByTag(FInplaceEditor), Width, Height-GetExtraVOffs);
      FInplaceEditor.RVData.Format_(True,False,False,0,FInplaceEditor.Canvas,
      False,False,False,False{!});
    end;
  MyClientLeft := x;
  MyClientTop  := y;
  for r := 0 to RowCount-1 do begin
    with Rows[r] do
      for c := 0 to Count-1 do
        if Items[c]<>nil then
          Items[c].AdjustChildrenCoords;
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.OwnsControl(AControl: TControl): Boolean;
var r,c,i: Integer;
begin
  Result := GetCellWhichOwnsControl(AControl, r,c,i);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.OwnsInplaceEditor(AEditor: TControl): Boolean;
begin
  Result := FInplaceEditor=AEditor;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetCellWhichOwnsControl(AControl: TControl; var ARow,ACol,AItemNo: Integer): Boolean;
var r,c: Integer;
begin
  for r := 0 to RowCount-1 do
    with Rows[r] do
      for c := 0 to Count-1 do
        if (Items[c]<>nil) then begin
          AItemNo := Items[c].GetRVData.FindControlItemNo(AControl);
          if (AItemNo<>-1) then begin
            ARow := r;
            ACol := c;
            Result := True;
            exit;
          end;
        end;
  Result := False;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.MergeInplaceUndo(DestroyLists: Boolean);
  {........................................................}
  procedure AddList(var List: TRVUndoList; DestList: TRVUndoList; IsRedo: Boolean);
  var ui: TRVUndoCellModify;
      UndoLimit: Integer;
  begin
//    DestList.PopIfEmpty;
    if List.Count>0 then begin
      UndoLimit := List.Limit;
      if IsRedo then
        TRVEditRVData(FRows.FMainRVData).BeginRedoSequence(rvutModifyItem,'')
      else
        TRVEditRVData(FRows.FMainRVData).BeginUndoSequence(rvutModifyItem, False);
      ui := TRVUndoCellModify.Create;
      ui.Row := TRVTableInplaceEdit(FInplaceEditor).FRow;
      ui.Col := TRVTableInplaceEdit(FInplaceEditor).FCol;
      ui.CaretItemNo := FInplaceEditor.CurItemNo;
      ui.CaretOffs   := FInplaceEditor.OffsetInCurItem;
      ui.UndoList := List;
      ui.Action := rvuModifyItem;
      ui.ItemNo := GetEditorItemNoForUndo;
      ui.IsRedo := IsRedo;
      DestList.AddInfo(ui, TCustomRichViewEdit(TRVEditRVData(FRows.FMainRVData).RichView));
      TRVUndoInfos(DestList.Items[DestList.Count-1]).CaretItemNo :=  TRVUndoInfos(List.Items[List.Count-1]).CaretItemNo;
      TRVUndoInfos(DestList.Items[DestList.Count-1]).CaretOffs :=  TRVUndoInfos(List.Items[List.Count-1]).CaretOffs;
      if DestroyLists then
        List := nil
      else begin
        List  := TRVUndoList.Create(DestList.FRVData);
        List.Limit := UndoLimit;
      end;
      end
    else
      DestList.PopIfEmpty;
  end;
  {........................................................}
begin
  if FInplaceEditor=nil then
    exit;
  AddList(TRVEditRVData(FInplaceEditor.RVData).UndoList,
          TRVEditRVData(FRows.FMainRVData).UndoList, False);
  AddList(TRVEditRVData(FInplaceEditor.RVData).RedoList,
          TRVEditRVData(FRows.FMainRVData).RedoList, True);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.InplaceDeleted(Clearing: Boolean);
var Clr: Boolean;
    strg: TRVTableInplaceParamStorage;
    Cell: TCustomRVFormattedData;
    RVData: TRichViewRVData;
    Row, Col: Integer;
    ie: TCustomRichViewEdit;
    FormattingPart: Boolean;
begin
  Clr := Clearing or (rvstClearing in TCustomRVFormattedData(Rows.FMainRVData.GetAbsoluteRootData).State) or
         not FRows.FMainRVData.GetParentControl.HandleAllocated;
  MergeInplaceUndo(True);
  Cell := TRVTableInplaceEdit(FInplaceEditor).FCell;
  Row  := TRVTableInplaceEdit(FInplaceEditor).FRow;
  Col  := TRVTableInplaceEdit(FInplaceEditor).FCol;
  StoreRVSelection(FInplaceEditor.RVData, strg);
  Cell.DrainFrom(FInplaceEditor.RVData);

  if not Clr then begin
    TCustomRVFormattedData(Rows.FMainRVData).GetItemClientCoords(GetMyItemNo,MyClientLeft,MyClientTop);
    ie := FInplaceEditor;
    FInplaceEditor := nil;
    FormattingPart := rvstFormattingPart in Rows.FMainRVData.GetAbsoluteRootData.State;
    Include(Rows.FMainRVData.GetAbsoluteRootData.State, rvstFormattingPart);
    try
      Cell.Format(False);
    finally
      if not FormattingPart then
        Exclude(Rows.FMainRVData.GetAbsoluteRootData.State, rvstFormattingPart);      
    end;
    FInplaceEditor := ie;
    RestoreRVSelection(Cell, strg);
  end;
  FInplaceEditor := nil;
  if not Clr then begin
    TRVEditRVData(Rows.FMainRVData).Invalidate;
    TCustomRichViewEdit(TRichViewRVData(Rows.FMainRVData.GetRootData).RichView).AfterCaretMove;
    RVData := FRows.FMainRVData.GetRootData as TRichViewRVData;
    if IsInEditor and TCustomRichViewEdit(RVData.RichView).ReadOnly then
      TRVEditRVData(RVData).BuildJumpsCoords(True);
  end;
  if Assigned(FOnCellEndEdit) then
    FOnCellEndEdit(Self, Row, Col, Clr);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.MovingToUndoList(ItemNo: Integer;
  RVData, AContainerUndoItem: TObject);
begin
  DestroyInplace(False);
  if RowCount>0 then
    Rows.MovingToUndoList(0,0,ColCount,RowCount, TRVUndoInfo(AContainerUndoItem));
  Rows.FMainRVData := nil;
  inherited MovingToUndoList(ItemNo, RVData, AContainerUndoItem);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.MovingFromUndoList(ItemNo: Integer;
  RVData: TObject);
begin
  Rows.FMainRVData := TCustomRVData(RVData);
  if RowCount>0 then
    Rows.MovingFromUndoList(0,0,ColCount,RowCount);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.Hiding;
var r,c: Integer;
begin
  inherited Hiding;
  for r := 0 to RowCount-1 do
    for c := 0 to ColCount-1 do
      if Cells[r,c]<>nil then
        TCustomRVFormattedData(Cells[r,c].GetRVData).Hiding;
  ClearTemporal;        
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.FinalizeUndoGroup;
begin
  MergeInplaceUndo(False);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.InplaceEditorChange(Sender: TCustomRichViewEdit; ClearRedo: Boolean);
var FullReformat: Boolean;
    nwp: Integer;
    L,T,W,H: Integer;
begin
  if not (rvtsInplaceIsReformatting in FState) and
     (FInplaceEditor<>nil) and TRVTableInplaceEdit(FInplaceEditor).Resized then begin
    Fmt.FWidth := 0;
    Include(FState, rvtsInplaceIsReformatting);
    L := FInplaceEditor.Left;
    T := FInplaceEditor.Top;
    W := FInplaceEditor.Width;
    H := FInplaceEditor.Height;
    try
      nwp := FInplaceEditor.RVData.CalculateMinDocWidthPlus(0,nil,nil);
      FullReformat := FInplaceMinWidthPlus<>nwp;
      if FullReformat then begin
        FInplaceMinWidthPlus := nwp;
        nwp := TCustomRVFormattedData(Rows.FMainRVData).CalculateMinItemWidthPlusEx(GetMyItemNo);
        FullReformat := (nwp<>FMinWidthPlus) and
                        ((nwp>TCustomRVFormattedData(Rows.FMainRVData).DocumentWidth) or
                        (FMinWidthPlus>=TCustomRVFormattedData(Rows.FMainRVData).DocumentWidth));
        FMinWidthPlus := nwp;
      end;
      TRVEditRVData(Rows.FMainRVData).Reformat(FullReformat, False, True,
                          GetMyItemNo,
                          False);

    finally
      TRVTableInplaceEdit(FInplaceEditor).Resized;
      Exclude(FState, rvtsInplaceIsReformatting);
    end;
    if (L<>FInplaceEditor.Left) or (T<>FInplaceEditor.Top) or
       (W<>FInplaceEditor.Width) or (H<>FInplaceEditor.Height) then
      TCustomRVFormattedData(Rows.FMainRVData).Refresh;
  end;
  ChangeEx(ClearRedo);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.DestroyInplace(ReformatCell:Boolean);
var X: Integer;
begin
  if FInplaceEditor<>nil then begin
    if csDestroying in FInplaceEditor.ComponentState then
      exit;
    //if False and TRVTableInplaceEdit(FInplaceEditor).Busy then
    //  raise ERVTableInplaceError.Create(errInplaceBusy);
    if not ReformatCell then
      TRVTableInplaceEdit(FInplaceEditor).SetClearingState
    else
      TCustomRVFormattedData(FRows.FMainRVData).UnassignChosenRVData(TRVTableInplaceEdit(FInplaceEditor).FCell);
    X := TRVEditRVData(FRows.FMainRVData).GetUpDownMovingX;
    FInplaceEditor.Free;
    FInplaceEditor := nil;
    TRVEditRVData(FRows.FMainRVData).SetUpDownMovingX(X);    
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.StartSelecting(Row,Col: Integer;
  FromKeyboard: Boolean):Boolean;
begin
  Result := False;
  if not (rvoAllowSelection in Rows.FMainRVData.Options) or
     (rvtoNoCellSelect in Options) then
    exit;
  FStoredInplace.Stored := FInplaceEditor<>nil;
  if FStoredInplace.Stored then begin
    StoreRVSelection(FInplaceEditor.RVData, FStoredInplace);
    FStoredInplace.Row := TRVTableInplaceEdit(FInplaceEditor).FRow;
    FStoredInplace.Col := TRVTableInplaceEdit(FInplaceEditor).FCol;
  end;
  FSelStartCol := Col;
  FSelStartRow := Row;
  FSelColOffs := 0;
  FSelRowOffs := 0;
  if FromKeyboard then
    Include(FState, rvtsSelExists)
  else
    Exclude(FState, rvtsSelExists);
  TCustomRVFormattedData(FRows.FMainRVData).PartialSelectedItem := Self;
  if not FromKeyBoard then
    TCustomRVFormattedData(FRows.FMainRVData).SetMouseCapture(Self,MyLeft,MyTop);
  UpdateCellSel;
  FMakingSelection := not FromKeyboard;
  Result := True;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetBoolValue(Prop: TRVItemBoolProperty): Boolean;
begin
  case Prop of
    rvbpDrawingChangesFont, rvbpCanSaveUnicode,
    rvbpAlwaysInText, rvbpHasSubRVData, rvbpNoHTML_P:
      Result := True;
    else
      Result := inherited GetBoolValue(Prop);
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetBoolValueEx(Prop: TRVItemBoolPropertyEx; RVStyle: TRVStyle): Boolean;
begin
  case Prop of
    rvbpPrintToBMP:
      Result := False;
    else
      Result := inherited GetBoolValueEx(Prop, RVStyle);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.StoreRVSelection(RVData: TCustomRVFormattedData;
  var storage: TRVTableInplaceParamStorage);
begin
  with storage do begin
    RVData.GetSelectionBoundsEx(StartNo, StartOffs, EndNo, EndOffs, False);
    PartialSelected := RVData.PartialSelectedItem;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.RestoreRVSelection(RVData: TCustomRVFormattedData;
  const storage: TRVTableInplaceParamStorage);
begin
  with storage do begin
    RVData.SetSelectionBounds(StartNo, StartOffs, EndNo, EndOffs);
    if PartialSelected<>nil then
      RVData.PartialSelectedItem := PartialSelected;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SaveInplace;
begin
  if FInplaceEditor<>nil then begin
    //if TRVTableInplaceEdit(FInplaceEditor).Busy then
    //  raise ERVTableInplaceError.Create(errInplaceBusy);
    StoreRVSelection(FInplaceEditor.RVData, FStoredInplace);
    FStoredInplace.Row := TRVTableInplaceEdit(FInplaceEditor).FRow;
    FStoredInplace.Col := TRVTableInplaceEdit(FInplaceEditor).FCol;
    FStoredInplace.Stored := True;
    DestroyInplace(True);
    end
  else begin
    // FStoredInplace.Stored := False;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.UpdateStoredInplaceSelection;
begin
  if (FInplaceEditor<>nil) and FStoredInplace.Stored and
    (FStoredInplace.Row=TRVTableInplaceEdit(FInplaceEditor).FRow) and
    (FStoredInplace.Col=TRVTableInplaceEdit(FInplaceEditor).FCol) then
    StoreRVSelection(FInplaceEditor.RVData, FStoredInplace);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.RestoreInplace;
begin
  if FStoredInplace.Stored then begin
    CreateInplace(-1, FStoredInplace.Row, FStoredInplace.Col, False, True, False, False, True);
    if FInplaceEditor=nil then
      exit;
    RestoreRVSelection(FInplaceEditor.RVData, FStoredInplace);
    FInplaceEditor.Invalidate;
    FStoredInplace.Stored := False;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.InplaceEditorCaretGetout(Sender: TCustomRichViewEdit;
  Direction: TRVGetOutDirection);
var Dir: TRVCellDirection;
    KeyboardState: TKeyboardState;
    Key: Word;
begin
  GetKeyboardState(KeyboardState);
  if KeyboardState[VK_SHIFT] and $80 <> 0 then begin
    case Direction of
      rvdLeft:  Key := VK_LEFT;
      rvdUp:    Key := VK_UP;
      rvdRight: Key := VK_RIGHT;
      rvdDown:  Key := VK_DOWN;
      else      exit;
    end;
    PostMessage(FInplaceEditor.Handle,  WM_RVEXPANDSEL, Key,  0);
    end
  else begin
    Dir := TRVCellDirection(ord(Direction));
    PostMessage(FInplaceEditor.Handle,  WM_RVMOVEEDITOR, ord(Dir),  0);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.InplaceEditorMouseDown(Sender: TCustomRichView;
  Button: TMouseButton; Shift: TShiftState; ItemNo, X, Y: Integer);
var p: TPoint;
    data: TRVMouseUpDownMessageData;
begin
  if (Rows.FMainRVData is TCustomRVFormattedData) then begin
    p := FInplaceEditor.ClientToScreen(Point(X,Y));
    p := TCustomRVFormattedData(Rows.FMainRVData).GetParentControl.ScreenToClient(p);
    data := TRVMouseUpDownMessageData.Create;
    data.Event  := rvetRVMouseDown;
    data.X      := p.X;
    data.Y      := p.Y;
    data.ItemNo := GetItemNoInRootDocument;
    data.Shift  := Shift;
    data.Button := Button;
    PostMessage(TCustomRVFormattedData(Rows.FMainRVData).GetParentControl.Handle,
      WM_RVEVENT, Integer(data), 0);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.InplaceEditorMouseUp(Sender: TCustomRichView;
  Button: TMouseButton; Shift: TShiftState; ItemNo, X, Y: Integer);
var p: TPoint;
    data: TRVMouseUpDownMessageData;
begin
  if (Rows.FMainRVData is TCustomRVFormattedData) then begin
    p := FInplaceEditor.ClientToScreen(Point(X,Y));
    p := TCustomRVFormattedData(Rows.FMainRVData).GetParentControl.ScreenToClient(p);
    data := TRVMouseUpDownMessageData.Create;
    data.Event  := rvetRVMouseUp;
    data.X      := p.X;
    data.Y      := p.Y;
    data.ItemNo := GetItemNoInRootDocument;
    data.Shift  := Shift;
    data.Button := Button;
    PostMessage(TCustomRVFormattedData(Rows.FMainRVData).GetParentControl.Handle,
      WM_RVEVENT, Integer(data), 0);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.InplaceEditorMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var editor: TCustomRichViewEdit;
begin
  editor := TCustomRichViewEdit(TRVEditRVData(Rows.FMainRVData).RichView);
  if Assigned(editor.OnMouseMove) then
    editor.OnMouseMove(editor, Shift, X+TControl(Sender).Left, Y+TControl(Sender).Top);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.InplaceEditorDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var editor: TCustomRichViewEdit;
begin
  editor := TCustomRichViewEdit(TRVEditRVData(Rows.FMainRVData).RichView);
  if Assigned(editor.OnDragOver) then
    editor.OnDragOver(editor, Source, X+TControl(Sender).Left, Y+TControl(Sender).Top, State, Accept);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.InplaceEditorDragDrop(Sender, Source: TObject; X, Y: Integer);
var editor: TCustomRichViewEdit;
begin
  editor := TCustomRichViewEdit(TRVEditRVData(Rows.FMainRVData).RichView);
  if Assigned(editor.OnDragDrop) then
    editor.OnDragDrop(editor, Source, X+TControl(Sender).Left, Y+TControl(Sender).Top);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.DoSaveRVF(Stream: TStream; RVData: TPersistent;
        ItemNo, ParaNo: Integer; Part: TRVMultiDrawItemPart;
        ForceSameAsPrev, SelectionOnly: Boolean);
var SaveType, LineCount: Integer;
    StreamWrapper: TRVTableSW;
    OldStreamSaveInfo: TRVTableStreamSaveInfo;
begin
  LineCount := 3+GetRVFExtraPropertyCount;
  if rvfoSaveBinary in TCustomRVData(RVData).RVFOptions then
    SaveType := 2 // save binary
  else
    SaveType := 0; // save hex dump
  RVFWriteLine(Stream,
   {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%d %d %s %d %d %s %s',
          [StyleNo, LineCount,
           RVFSavePara(TCustomRVData(RVData).GetRVStyle,
                        rvfoUseStyleNames in TCustomRVData(RVData).RVFOptions,
                        ParaNo),
           Byte(ItemOptions) and RVItemOptionsMask,
           SaveType,
           RVFSaveTag(rvoTagsArePChars in TCustomRVData(RVData).Options,Tag),
           SaveRVFHeaderTail(RVData)]));
   RVFWriteLine(Stream, ItemText);
   SaveRVFExtraProperties(Stream);
   RVFWriteLine(Stream, '1');
   OldStreamSaveInfo := FStreamSaveInfo;
   try
     StreamWrapper := TRVTableSW.Create(nil);
     FStreamSaveInfo := TRVTableStreamSaveInfo.Create(Self);
     try
       if (Part<>nil) and (Part is TRVTablePrintPart) then begin
         FStreamSaveInfo.SaveHeadingRows := True;
         FStreamSaveInfo.Part := TRVTablePrintPart(Part);
         FStreamSaveInfo.TopRow := TRVTablePrintPart(Part).FRowIndices[0];
         FStreamSaveInfo.RowCount := TRVTablePrintPart(Part).FRowIndices.Count-1;
       end;
       if SelectionOnly then begin
         FStreamSaveInfo.SelectionOnly := True;
         with FStreamSaveInfo do
           GetNormalizedSelectionBoundsEx(False, TopRow, LeftCol, ColCount, RowCount);
      end;
       StreamWrapper.T := Self;
       if rvfoSaveBinary in TCustomRVData(RVData).RVFOptions then
         RVFSaveControlBinary(Stream, StreamWrapper)
       else
         RVFWriteLine(Stream, RVFSaveControl(StreamWrapper));
     finally
       StreamWrapper.Free;
       FStreamSaveInfo.Free;
     end;
   finally
     FStreamSaveInfo := OldStreamSaveInfo;
   end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SaveRVF(Stream: TStream; RVData: TPersistent;
  ItemNo, ParaNo: Integer; const Name: TRVRawByteString; Part: TRVMultiDrawItemPart;
  ForceSameAsPrev: Boolean);
begin
  DoSaveRVF(Stream, RVData, ItemNo, ParaNo, Part, ForceSameAsPrev, False);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SaveRVFSelection(Stream: TStream; RVData: TPersistent;
  ItemNo, ParaNo: Integer);
begin
  DoSaveRVF(Stream, RVData, ItemNo, ParaNo, nil, False, True);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.ReadRVFLine(const s: TRVRawByteString; RVData: TPersistent;
  ReadType, LineNo, LineCount: Integer; var Name: TRVRawByteString;
  var ReadMode: TRVFReadMode; var ReadState: TRVFReadState;
  UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean;
var StreamWrapper: TRVTableSW;
    OldStreamSaveInfo: TRVTableStreamSaveInfo;
begin
  Result := True;
  if LineNo=0 then begin
    Name := s;
    exit;
  end;
  case LineCount-LineNo of
    2:
      begin
        //  do nothing; this line contains version of table stream format; currently '1'
        if ReadType=2 then
          ReadMode := rmBeforeBinary;
      end;
    1:
      begin
        OldStreamSaveInfo := FStreamSaveInfo;
        try
          StreamWrapper := TRVTableSW.Create(nil);
          FStreamSaveInfo := TRVTableStreamSaveInfo.Create(Self);
          try
            StreamWrapper.T := Self;
            if ReadType=2 then
              Result := RVFLoadControlBinary(s, TComponent(StreamWrapper), '',
                nil, nil)
            else
              Result := RVFLoadControl(s, TComponent(StreamWrapper), '',
                nil, nil);
            Result := Result and FStreamSaveInfo.LoadResult;
            ReadState := rstSkip;
          finally
            StreamWrapper.FTD.DecRef;
            FStreamSaveInfo.Free;
          end;
        finally
          FStreamSaveInfo := OldStreamSaveInfo;
        end;
      end;
    else
      SetExtraPropertyFromRVFStr(s, UTF8Strings);
  end;
end;
{------------------------------------------------------------------------------}
// rvtsJustCreated is set in constructor. This method is called just after
// constructor when loading table from RTF or RVF.
procedure TRVTableItemInfo.BeforeLoading(FileFormat: TRVLoadFormat);
begin
  if FileFormat in [rvlfRVF, rvlfRTF, rvlfOther] then
    Exclude(FState, rvtsJustCreated);
end;
{------------------------------------------------------------------------------}

// This function is used to update list of marker when table is inserted from
// RVF or RTF
// When inserting nested tables, this method is called only for root table
// See also comments to Inserted
procedure TRVTableItemInfo.AfterLoading(FileFormat: TRVLoadFormat);
var r,c,i: Integer;
begin
  for r := 0 to RowCount-1 do
    for c := 0 to ColCount-1 do
      if Cells[r,c]<>nil then
        with Cells[r,c].GetRVData do
          for i := 0 to Items.Count-1 do begin
            {$IFNDEF RVDONOTUSESEQ}
            AddSeqInList(i);
            {$ENDIF}
            {$IFNDEF RVDONOTUSELISTS}
            AddMarkerInList(i);
            {$ENDIF}
            GetItem(i).AfterLoading(FileFormat);
          end;
end;
{------------------------------------------------------------------------------}
procedure ReadError;
begin
  raise EReadError.Create(errReadCells);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.CellsReader(Reader: TReader);
var r,c, RowCount, ColCount, colspan,rowspan: Integer;
    CellWrapper:TD;
begin
  ClearTemporal;
  RowCount := Reader.ReadInteger;
  if RowCount=0 then begin
    Rows.Reset(0,0);
    exit;
  end;
  ColCount := Reader.ReadInteger;
  if FStreamSaveInfo.TopRow=0 then
    Rows.Reset(RowCount,ColCount)
  else
    if ColCount>Rows[0].Count then
      ReadError;
  Reader.ReadListBegin;
  CellWrapper := (Reader.Root as TRVTableSW).FTD;
  for r := FStreamSaveInfo.TopRow to FStreamSaveInfo.TopRow+RowCount-1 do
    for c := 0 to ColCount-1 do
      if Cells[r,c]<>nil then begin
        if Reader.EndOfList then
          ReadError;
        colspan := Reader.ReadInteger;
        rowspan := Reader.ReadInteger;
        Rows.MergeCells(r,c,colspan,rowspan,True,True);
        CellWrapper.C := Cells[r,c];
        try
          Reader.ReadComponent(CellWrapper);
        except
          FStreamSaveInfo.LoadResult := False;
        end;
        if not FStreamSaveInfo.LoadResult then
          exit;
        inc(CellWrapper.FCellCount);
      end;
  if not Reader.EndOfList then
    ReadError;
  Reader.ReadListEnd;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.CellsWriter(Writer: TWriter);
var CellWrapper:TD;
    r, count: Integer;
    {........................................................}
    procedure WriteRow(r: Integer; Heading: Boolean);
    var c, mr,mc, ColSpan, RowSpan: Integer;
        Cell, MainCell, MainColCell: TRVTableCellData;
    begin
      MainCell := nil;
      MainColCell := nil;
      for c := FStreamSaveInfo.LeftCol to FStreamSaveInfo.LeftCol+FStreamSaveInfo.ColCount-1 do begin
        if not Heading and (FStreamSaveInfo.Part<>nil) and
           (r=FStreamSaveInfo.TopRow) and (FStreamSaveInfo.Part.FTableTopCutLine<>nil) then
          FStreamSaveInfo.CellPage := FStreamSaveInfo.Part.FTableTopCutLine[c]
        else
          FStreamSaveInfo.CellPage := 1;
        if not Heading and (FStreamSaveInfo.Part<>nil) then
          FStreamSaveInfo.CellPtblRVData := FStreamSaveInfo.Part.FFmtRef.Rows[r*ColCount+c]
        else
          FStreamSaveInfo.CellPtblRVData := nil;
        Cell := nil;
        if Cells[r,c]<>nil then begin
          mr := r;
          mc := c;
          Cell := Cells[r,c];
          end
        else if not Heading then begin
          if FStreamSaveInfo.Part<>nil then begin
            if r=FStreamSaveInfo.TopRow then begin
              Cell := Rows.GetMainCell(r,c, mr, mc);
              if c<>mc then
                Cell := nil;
            end
            end
          else if (r=FStreamSaveInfo.TopRow) or (c=FStreamSaveInfo.LeftCol) then begin
            Cell := Rows.GetMainCell(r,c, mr, mc);
            if ((mr<FStreamSaveInfo.TopRow) or (mc<FStreamSaveInfo.LeftCol)) and
              (Cell<>MainCell) and (Cell<>MainColCell) then begin
              MainCell := Cell;
              if c=FStreamSaveInfo.LeftCol then
                MainColCell := Cell;
              end
            else
              Cell := nil;
          end
        end;
        if Cell<>nil then begin
          CellWrapper.C := Cell;
          ColSpan := Cell.ColSpan;
          inc(ColSpan, mc-c);
          if ColSpan>FStreamSaveInfo.LeftCol+FStreamSaveInfo.ColCount-c then
            ColSpan := FStreamSaveInfo.LeftCol+FStreamSaveInfo.ColCount-c;
          RowSpan := Cell.RowSpan;
          inc(RowSpan, mr-r);
          if RowSpan>FStreamSaveInfo.TopRow+FStreamSaveInfo.RowCount-r then
            RowSpan := FStreamSaveInfo.TopRow+FStreamSaveInfo.RowCount-r;
          Writer.WriteInteger(ColSpan);
          Writer.WriteInteger(RowSpan);
          if (FStreamSaveInfo.SelectionOnly and not IsCellSelected(mr, mc)) then
            Include(Cell.State, rvstDoNotSaveContent);
          try
            Writer.WriteComponent(CellWrapper);
          finally
            Exclude(Cell.State, rvstDoNotSaveContent);
          end;
        end;
      end;
    end;
    {........................................................}
begin
  StartExport;
  try
    if FStreamSaveInfo.SaveHeadingRows then begin
      count := HeadingRowCount;
      if count>RowCount then
        count := RowCount;
      end
    else
      count := 0;
    Writer.WriteInteger(FStreamSaveInfo.RowCount+count);
    if FStreamSaveInfo.RowCount+count>0 then begin
      Writer.WriteInteger(FStreamSaveInfo.ColCount);
      Writer.WriteListBegin;
      CellWrapper := (Writer.Root as TRVTableSW).FTD;
      for r := 0 to count-1 do
        WriteRow(r, True);
      for r := FStreamSaveInfo.TopRow to FStreamSaveInfo.TopRow+FStreamSaveInfo.RowCount-1 do
        WriteRow(r, False);
      Writer.WriteListEnd;
    end;
  finally
    EndExport;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.Print(Canvas: TCanvas; x, y, x2: Integer;
  Preview, Correction: Boolean; const sad: TRVScreenAndDevice;
  RichView: TRVScroller; dli: TRVDrawLineInfo;
  Part: Integer; ColorMode: TRVColorMode; RVData: TPersistent);
var State: TRVItemDrawStates;
    TablePart : TRVTablePrintPart;
    UHRC: Boolean;
begin
  if Part>=0 then begin
    TablePart := TRVTablePrintPart((dli as TRVTablePrintInfo).PartsList[Part]);
    UHRC := TRVTablePrintInfo(dli).FHeadingRowCount>0;
    end
  else begin
    UHRC := False;
    TablePart := nil;
  end;
  State := [rvidsPrinting];
  if Preview then
    Include(State, rvidsPreview);
  if Correction then
    Include(State, rvidsPreviewCorrection);
  cursad := @(TRVTablePrintInfo(dli).sad);
  try
    PaintTo(x,x2,y, Canvas, State, TCustomRVData(RVData).GetRVStyle,
      TRVTablePrintInfo(dli).Fmt, UHRC,
      Rect(x,y,x+TRVTablePrintInfo(dli).Fmt.FWidth,y+TRVTablePrintInfo(dli).Fmt.FHeight),
      ColorMode, TCustomPrintableRVData(RVData), TablePart, 0, 0);
  finally
    cursad := nil;
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.CreatePrintingDrawItem(RVData, ParaStyle: TObject;
  const sad: TRVScreenAndDevice): TRVDrawLineInfo;
var r,c: Integer;
    item : TCellPtblRVData;
    data: TCustomRVFormattedData;
    Cell: TRVTableCellData;
begin
  Result := TRVTablePrintInfo.Create(Self);
  TRVTablePrintInfo(Result).sad := sad;
  TRVTablePrintInfo(Result).Fmt.Rows.Capacity := RowCount*ColCount;
  for r := 0 to RowCount-1 do
    for c := 0 to ColCount-1 do begin
      Cell := Cells[r,c];
      if (Cell<>nil) then begin
        data := TCustomRVFormattedData(Cell.GetRVData);
        {if (Cell.ColSpan=1) and (Cell.RowSpan=1) and not Cell.HasData(True) then
          data := nil;}
        if data<>nil then begin
          item := TCellPtblRVData.Create(
                  (TCustomRVData(RVData).GetRootData as TCustomMainPtblRVData).RichView,
                  data, RVData as TCustomPrintableRVData);
          item.FColor := GetCellColor(Cell);
          item.ParentDrawsBack := True;
          item.Transparent := Cell.IsTransparent;
          if rvstFirstParaAborted in Cell.State then begin
            Include(item.State, rvstFirstParaAborted);
            item.FFirstParaListNo := Cell.FFirstParaListNo;
            item.FFirstParaLevel  := Cell.FFirstParaLevel;
          end;
          if rvstLastParaAborted in Cell.State then
            Include(item.State, rvstLastParaAborted);
          end
        else
          item := nil;
        end
      else
        item := nil;
      TRVTablePrintInfo(Result).Fmt.Rows.Add(item);
    end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.DrawBackgroundForPrinting(Canvas: TCanvas;
  const Rect, FullRect: TRect; ColorMode: TRVColorMode; ItemBackgroundLayer: Integer;
  GraphicInterface: TRVGraphicInterface);
var Clr: TColor;
    r: TRect;
begin
  if ItemBackgroundLayer=0 then
    exit;
  if FColor=clNone then
    Clr := clNone
  else if (rvtoWhiteBackground in PrintOptions) then
    Clr := clWhite
  else
    Clr := RV_GetBackColor(FColor, ColorMode);
  if FBackground<>nil then begin
    FBackground.Draw(Canvas, Rect, 0, 0, FullRect.Left, FullRect.Top,
      FullRect.Right-FullRect.Left, FullRect.Bottom-FullRect.Top, Clr,
      False, False, GraphicInterface);
    end
  else if Clr<>clNone then begin
    Canvas.Brush.Color := Clr;
    Canvas.Brush.Style := bsSolid;
    GraphicInterface.FillRect(Canvas, Rect);
  end;
  if (ItemBackgroundLayer=1) or (FPrintCell=nil) then
    exit;
  if FPrintCell.Color=clNone then
    Clr := clNone
  else if (rvtoWhiteBackground in PrintOptions) then
    Clr := clWhite
  else
    Clr := RV_GetBackColor(FPrintCell.Color, ColorMode);
  if FPrintCell.FBackground<>nil then begin
    r := FPrintCellRect;
    OffsetRect(r, -Rect.Left+FullRect.Left, -Rect.Top+FullRect.Top);
    FPrintCell.FBackground.Draw(Canvas, Rect, 0, 0, r.Left, r.Top,
      r.Right-r.Left, r.Bottom-r.Top, Clr, True, False, GraphicInterface);
    end
  else if Clr<>clNone then begin
    Canvas.Brush.Color := Clr;
    Canvas.Brush.Style := bsSolid;
    GraphicInterface.FillRect(Canvas, Rect);
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetDevX(x: Integer): Integer;
begin
  if cursad=nil then
    Result := x
  else
    Result := MulDiv(x, cursad.ppixDevice, cursad.ppixScreen);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetDevY(y: Integer): Integer;
begin
  if cursad=nil then
    Result := y
  else
    Result := MulDiv(y, cursad.ppiyDevice, cursad.ppiyScreen);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.LoadFromStreamEx(Stream: TStream; StartRow: Integer);
var StreamWrapper :TRVTableSW;
begin
   if FStreamSaveInfo<>nil then
     raise ERichViewError.Create(errRVError);
   FStreamSaveInfo := TRVTableStreamSaveInfo.Create(Self);
   StreamWrapper := TRVTableSW.Create(nil);
   try
     FStreamSaveInfo.TopRow := StartRow;
     FStreamSaveInfo.RowCount := 0;
     StreamWrapper.T := Self;
     Stream.ReadComponent(StreamWrapper);
   finally
     StreamWrapper.FTD.DecRef;
     FStreamSaveInfo.Free;
     FStreamSaveInfo := nil;
   end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.LoadFromStream(Stream: TStream);
begin
  LoadFromStreamEx(Stream, 0);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SaveRowsToStream(Stream: TStream; Index,
  Count: Integer);
begin
  SaveRectangleToStream(Stream, Index, 0, Count, ColCount, False);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SaveRectangleToStream(Stream: TStream; TopRow, LeftCol,
  RowCount, ColCount: Integer; SelectionOnly: Boolean);
var StreamWrapper :TRVTableSW;
begin
   if FStreamSaveInfo<>nil then
     raise ERichViewError.Create(errRVError);
  FStreamSaveInfo := TRVTableStreamSaveInfo.Create(Self);
  StreamWrapper := TRVTableSW.Create(nil);
  try
    FStreamSaveInfo.TopRow := TopRow;
    FStreamSaveInfo.RowCount := RowCount;
    FStreamSaveInfo.LeftCol := LeftCol;
    FStreamSaveInfo.ColCount := ColCount;
    FStreamSaveInfo.SelectionOnly := SelectionOnly;
    StreamWrapper.T := Self;
    Stream.WriteComponent(StreamWrapper);
  finally
    StreamWrapper.Free;
    FStreamSaveInfo.Free;
    FStreamSaveInfo := nil;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SaveToStream(Stream: TStream);
begin
  SaveRowsToStream(Stream, 0, RowCount);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.StartExport;
begin
  inc(BusyCount);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.EndExport;
begin
  dec(BusyCount);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.Inserting(RVData: TObject; var Text: TRVRawByteString;
  Safe: Boolean);
var r,c: Integer;
begin
  Rows.FMainRVData := TCustomRVData(RVData);
  if RVData<>nil then
    Include(FState, rvtsInserted)
  else
    Exclude(FState, rvtsInserted);
  if (rvtsInserted in FState) and (TCustomRVData(RVData).GetRootData is TRVEditRVData) then
    Include(FState, rvtsEditMode)
  else
    Exclude(FState, rvtsEditMode);
  for r := 0 to RowCount-1 do begin
    for c := 0 to ColCount-1 do
      if (Cells[r,c]<>nil) then begin
        if Cells[r,c].ItemCount=0 then
          {$IFNDEF RVDONOTUSEUNICODE}
          Cells[r,c].AddNLATag('',0,0,0);
          {$ELSE}
          Cells[r,c].AddNL('',0,0);          
          {$ENDIF}
        Cells[r,c].FList := Rows[r];
        Cells[r,c].Inserting(Cells[r,c], Safe);
      end;
  end;
  inherited Inserting(RVData, Text, Safe);
end;
{------------------------------------------------------------------------------}
// This method is called after the table is inserted in RVData.
// We processing only the first direct inserting
// For RVF and RTF, we use AfterLoading
procedure TRVTableItemInfo.Inserted(RVData: TObject; ItemNo: Integer);
var r,c,i: Integer;
    CellRVData: TCustomRVData;
    Location: TRVStoreSubRVData;
begin
  inherited;
  if not (rvtsJustCreated in FState) then
    exit;

  // May be this table was inserted in table that was not inserted yet?
  // If yes, exiting (this procedure will be called later again recursively when
  // the parent table will be inserted).
  if not (rvflRoot in TCustomRVData(RVData).Flags) then begin
    TCustomRVData(RVData).GetParentInfo(i, Location);
    Location.Free;
    if i<0 then
      exit;
  end;

  try
    for r := 0 to RowCount-1 do
      for c := 0 to ColCount-1 do
        if Cells[r,c]<>nil then begin
          CellRVData := Cells[r,c].GetRVData;
          for i := 0 to CellRVData.Items.Count-1 do begin
            {$IFNDEF RVDONOTUSESEQ}
            CellRVData.AddSeqInList(i);
            {$ENDIF}
            {$IFNDEF RVDONOTUSELISTS}
            CellRVData.AddMarkerInList(i);
            {$ENDIF}
            CellRVData.GetItem(i).Inserted(CellRVData, i);
          end;
        end;
  finally
    Exclude(FState, rvtsJustCreated);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.BackgroundImageReader(Stream: TStream);
var s: TRVAnsiString;
    v: Integer;
    gr: TGraphic;
    GraphicClassName: String;
begin
  Stream.ReadBuffer(v, sizeof(v));
  SetLength(s, v);
  Stream.ReadBuffer(PRVAnsiChar(s)^, v);
  {$IFDEF RVUNICODESTR}
  GraphicClassName := String(s);
  {$ELSE}
  GraphicClassName := s;
  {$ENDIF}
  gr := RV_CreateGraphics(TGraphicClass(GetClass(GraphicClassName)));
  RVFLoadPictureBinary2(Stream, gr);
  BackgroundImage := gr;
  gr.Free;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.BackgroundImageWriter(Stream: TStream);
var s: TRVAnsiString;
    v: Integer;
begin
  s := TRVAnsiString(FBackground.Image.ClassName);
  v := Length(s);
  Stream.WriteBuffer(v, sizeof(v));
  Stream.WriteBuffer(PRVAnsiChar(s)^, v);
  RVFSavePictureBinary(Stream, FBackground.Image);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineBinaryProperty('BackgroundImg', BackgroundImageReader, BackgroundImageWriter,
    (FBackground<>nil) and not FBackground.Empty);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetBestWidth(const Value: TRVHTMLLength);
begin
  if rvtsInserted in FState then
    SetIntProperty('BestWidth', ord(Value), True, True)
  else
    FBestWidth := Value;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetBorderColor(const Value: TColor);
begin
  if rvtsInserted in FState then
    SetIntProperty('BorderColor', ord(Value), False, False)
  else
    FBorderColor := Value;
end;

procedure TRVTableItemInfo.SetBorderHSpacing(const Value: TRVStyleLength);
begin
  if rvtsInserted in FState then
    SetIntProperty('BorderHSpacing', ord(Value), True, True)
  else
    FBorderHSpacing := Value;
end;

procedure TRVTableItemInfo.SetBorderLightColor(const Value: TColor);
begin
  if rvtsInserted in FState then
    SetIntProperty('BorderLightColor', ord(Value), False, False)
  else
    FBorderLightColor := Value;
end;

procedure TRVTableItemInfo.SetBorderStyle(const Value: TRVTableBorderStyle);
begin
  if rvtsInserted in FState then
    SetIntProperty('BorderStyle', ord(Value), False, False)
  else
    FBorderStyle := Value;
end;

procedure TRVTableItemInfo.SetBorderVSpacing(const Value: TRVStyleLength);
begin
  if rvtsInserted in FState then
    SetIntProperty('BorderVSpacing', ord(Value), True, False)
  else
    FBorderVSpacing := Value;
end;

procedure TRVTableItemInfo.SetBorderWidth(const Value: TRVStyleLength);
begin
  if rvtsInserted in FState then
    SetIntProperty('BorderWidth', ord(Value), True, True)
  else
    FBorderWidth := Value;
end;

procedure TRVTableItemInfo.SetCellBorderColorProp(const Value: TColor);
begin
  if rvtsInserted in FState then
    SetIntProperty('CellBorderColor', ord(Value), False, False)
  else
    FCellBorderColor := Value;
end;

procedure TRVTableItemInfo.SetCellBorderLightColorProp(const Value: TColor);
begin
  if rvtsInserted in FState then
    SetIntProperty('CellBorderLightColor', ord(Value), False, False)
  else
    FCellBorderLightColor := Value;
end;

procedure TRVTableItemInfo.SetCellBorderWidth(const Value: TRVStyleLength);
begin
  if rvtsInserted in FState then
    SetIntProperty('CellBorderWidth', ord(Value), True, True)
  else
    FCellBorderWidth := Value;
end;

procedure TRVTableItemInfo.SetCellHSpacing(const Value: TRVStyleLength);
begin
  if rvtsInserted in FState then
    SetIntProperty('CellHSpacing', ord(Value), True, True)
  else
    FCellHSpacing := Value;
end;

procedure TRVTableItemInfo.SetCellHPadding(const Value: TRVStyleLength);
begin
  if rvtsInserted in FState then begin
    if FInplaceEditor<>nil then begin
      FInplaceEditor.LeftMargin   := GetRVStyle.GetAsPixels(Value);
      FInplaceEditor.RightMargin  := FInplaceEditor.LeftMargin;
      Include(FState, rvtsFormatInplace);
    end;
    SetIntProperty('CellHPadding', ord(Value), True, True)
    end
  else
    FCellHPadding := Value;
end;

procedure TRVTableItemInfo.SetCellVPadding(const Value: TRVStyleLength);
begin
  if rvtsInserted in FState then begin
    if FInplaceEditor<>nil then begin
      FInplaceEditor.TopMargin    := GetRVStyle.GetAsPixels(Value);
      FInplaceEditor.BottomMargin := FInplaceEditor.TopMargin;
      Include(FState, rvtsFormatInplace);
    end;
    SetIntProperty('CellVPadding', ord(Value), True, True)
    end
  else
    FCellVPadding := Value;
end;

procedure TRVTableItemInfo.SetCellPadding(const Value: TRVStyleLength);
begin
  if rvtsInserted in FState then begin
    if FInplaceEditor<>nil then begin
      FInplaceEditor.LeftMargin   := GetRVStyle.GetAsPixels(Value);
      FInplaceEditor.TopMargin    := FInplaceEditor.LeftMargin;
      FInplaceEditor.RightMargin  := FInplaceEditor.LeftMargin;
      FInplaceEditor.BottomMargin := FInplaceEditor.LeftMargin;
      Include(FState, rvtsFormatInplace);
    end;
    SetIntProperty('CellHPadding', ord(Value), True, True) ;
    SetIntProperty('CellVPadding', ord(Value), True, True);
    end
  else begin
    FCellHPadding := Value;
    FCellVPadding := Value;
  end;
end;

function TRVTableItemInfo.GetCellPadding: TRVStyleLength;
begin
  Result := Round((CellHPadding+CellVPadding)/2);
end;

procedure TRVTableItemInfo.SetCellVSpacing(const Value: TRVStyleLength);
begin
  if rvtsInserted in FState then
    SetIntProperty('CellVSpacing', ord(Value), True, False)
  else
    FCellVSpacing := Value;
end;

procedure TRVTableItemInfo.SetColor(const Value: TColor);
begin
  if rvtsInserted in FState then
    SetIntProperty('Color', ord(Value), False, False)
  else
    FColor := Value;
  if FInplaceEditor<>nil then begin
    FInplaceEditor.Color := GetCellColor(TRVTableInplaceEdit(FInplaceEditor).FCell);
    TRVTableInplaceEdit(FInplaceEditor).Transparent :=
      CanSeeBackgroundThroughCell(TRVTableInplaceEdit(FInplaceEditor).FCell);
  end;
  {$IFNDEF RVDONOTUSEANIMATION}
  if Rows.FMainRVData is TCustomRVFormattedData then
    TCustomRVFormattedData(Rows.FMainRVData).ResetAniBackground;
  {$ENDIF}
end;

procedure TRVTableItemInfo.SetHeadingRowCount(const Value: Integer);
begin
  if rvtsInserted in FState then
    SetIntProperty('HeadingRowCount', ord(Value), False, False)
  else
    FHeadingRowCount := Value;
end;

procedure TRVTableItemInfo.SetHOutermostRule(const Value: Boolean);
begin
  if rvtsInserted in FState then
    SetIntProperty('HOutermostRule', ord(Value), False, False)
  else
    FHOutermostRule := Value;
end;

procedure TRVTableItemInfo.SetHRuleColor(const Value: TColor);
begin
  if rvtsInserted in FState then
    SetIntProperty('HRuleColor', ord(Value), False, False)
  else
    FHRuleColor := Value;
end;

procedure TRVTableItemInfo.SetHRuleWidth(const Value: TRVStyleLength);
begin
  if rvtsInserted in FState then
    SetIntProperty('HRuleWidth', ord(Value), False, False)
  else
    FHRuleWidth := Value;
end;

procedure TRVTableItemInfo.SetVOutermostRule(const Value: Boolean);
begin
  if rvtsInserted in FState then
    SetIntProperty('VOutermostRule', ord(Value), False, False)
  else
    FVOutermostRule := Value;
end;

procedure TRVTableItemInfo.SetVRuleColor(const Value: TColor);
begin
  if rvtsInserted in FState then
    SetIntProperty('VRuleColor', ord(Value), False, False)
  else
    FVRuleColor := Value;
end;

procedure TRVTableItemInfo.SetVRuleWidth(const Value: TRVStyleLength);
begin
  if rvtsInserted in FState then
    SetIntProperty('VRuleWidth', ord(Value), False, False)
  else
    FVRuleWidth := Value;
end;

procedure TRVTableItemInfo.SetCellBorderStyle(
  const Value: TRVTableBorderStyle);
begin
  if rvtsInserted in FState then
    SetIntProperty('CellBorderStyle', ord(Value), False, False)
  else
    FCellBorderStyle := Value;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCellIntProperty(ItemNo: Integer; const PropertyName: String;
  Value: LongInt; Row, Col: Integer; AffectSize, AffectWidth: Boolean);
var fi:Boolean;
    ui: TRVUndoModifyCellIntProperty;
begin
  if (rvtsInserted in FState) and IsInEditor then
    try
      Exclude(FState, rvtsInserted);
      if ItemNo=-1 then
        ItemNo := GetMyItemNo;
      TRVEditRVData(FRows.FMainRVData).BeginUndoSequence(rvutModifyItem, True);
      ui := TRVUndoModifyCellIntProperty(
        TRVEditRVData(FRows.FMainRVData).Do_ModifyItemIntProperty(
          ItemNo, Cells[Row,Col], PropertyName, Value,
          AffectSize, AffectWidth, TRVUndoModifyCellIntProperty));
      if ui<>nil then begin
        ui.Row := Row;
        ui.Col := Col;
      end;
    finally
      Include(FState, rvtsInserted);
    end
  else begin
    fi := rvtsInserted in FState;
    try
      Exclude(FState, rvtsInserted);
      SetOrdProp(Cells[Row,Col], GetPropInfo(Cells[Row,Col].ClassInfo,  PropertyName), Value);
    finally
      if fi then
        Include(FState, rvtsInserted);
    end;
  end;
  Changed;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCellStrProperty(ItemNo: Integer;
  const PropertyName: String; const Value: String; Row, Col: Integer);
var fi:Boolean;
    ui: TRVUndoModifyCellStrProperty;
begin
  if (rvtsInserted in FState) and IsInEditor then
    try
      Exclude(FState, rvtsInserted);
      if ItemNo=-1 then
        ItemNo := GetMyItemNo;
      TRVEditRVData(FRows.FMainRVData).BeginUndoSequence(rvutModifyItem, True);
      ui := TRVUndoModifyCellStrProperty(TRVEditRVData(FRows.FMainRVData).Do_ModifyItemStrProperty(
        ItemNo, Cells[Row,Col], PropertyName, Value,
        TRVUndoModifyCellStrProperty));
      if ui<>nil then begin
        ui.Row := Row;
        ui.Col := Col;
      end;
    finally
      Include(FState, rvtsInserted);
    end
  else begin
    fi := rvtsInserted in FState;
    try
      Exclude(FState, rvtsInserted);
      SetStrProp(Cells[Row,Col], GetPropInfo(Cells[Row,Col].ClassInfo,  PropertyName), Value);
    finally
      if fi then
        Include(FState, rvtsInserted);
    end;
  end;
  Changed;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.AssignCellAttributes(ItemNo,Row, Col: Integer;
  SourceCell: TRVTableCellData;IncludeSize: Boolean;
  DivColSpan, DivRowSpan: Integer);
var ui: TRVUndoModifyCellIntProperties;
    Cell: TRVTableCellData;
    PropList: TStringList;
begin
  Cell := Cells[Row,Col];
  if (rvtsInserted in FState) and IsInEditor then
    try
      if ItemNo=-1 then
        ItemNo := GetMyItemNo;
      with SourceCell.VisibleBorders do
        SetCellVisibleBorders_(ItemNo, Left,Top,Right,Bottom,Row,Col);
      SetCellBackgroundImage(SourceCell.BackgroundImage, Row,Col);
      SetCellBackgroundImageFileName_(ItemNo, SourceCell.BackgroundImageFileName, Row, Col);
      {$IFNDEF RVDONOTUSEITEMHINTS}
      SetCellHint_(ItemNo, SourceCell.Hint, Row, Col);
      {$ENDIF}
      PropList := TStringList.Create;
      try
        PropList.AddObject('Color', TObject(SourceCell.Color));
        PropList.AddObject('BorderColor', TObject(SourceCell.BorderColor));
        PropList.AddObject('BorderLightColor', TObject(SourceCell.BorderLightColor));
        PropList.AddObject('VAlign', TObject(SourceCell.VAlign));
        PropList.AddObject('BackgroundStyle', TObject(SourceCell.BackgroundStyle));        
        if IncludeSize then begin
          PropList.AddObject('BestWidth', TObject(SourceCell.BestWidth div DivColSpan));
          PropList.AddObject('BestHeight', TObject(SourceCell.BestHeight div DivRowSpan));
        end;
        TRVEditRVData(FRows.FMainRVData).BeginUndoSequence(rvutModifyItem, True);
        ui := TRVEditRVData(FRows.FMainRVData).Do_ModifyItemIntProperties(
        ItemNo, Cell, PropList,
        IncludeSize, IncludeSize, TRVUndoModifyCellIntProperties) as TRVUndoModifyCellIntProperties;
        if ui<>nil then begin
          ui.Row := Row;
          ui.Col := Col;
        end;
      finally
        PropList.Free;
      end;
    finally
      Include(FState, rvtsInserted);
    end
  else begin
    Cells[Row,Col].AssignAttributesFrom(SourceCell, IncludeSize, DivColSpan, DivRowSpan);
  end;
  Changed;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetIntProperty(const PropertyName: String;
  Value: LongInt; AffectSize, AffectWidth: Boolean);
var fi:Boolean;
begin
  if (rvtsInserted in FState) and IsInEditor then
    try
      MergeInplaceUndo(False);
      Exclude(FState, rvtsInserted);
      TRVEditRVData(FRows.FMainRVData).BeginUndoSequence(rvutModifyItem, True);
      TRVEditRVData(FRows.FMainRVData).Do_ModifyItemIntProperty(
        GetMyItemNo, Self, PropertyName, Value,
        AffectSize, AffectWidth, TRVUndoModifyItemIntProperty);
      TCustomRVFormattedData(Rows.FMainRVData).Invalidate;
    finally
      Include(FState, rvtsInserted);
    end
  else begin
    fi := rvtsInserted in FState;
    try
      Exclude(FState, rvtsInserted);
      SetOrdProp(Self, GetPropInfo(Self.ClassInfo,  PropertyName), Value);
    finally
      if fi then
        Include(FState, rvtsInserted);
    end;
  end;
  Changed;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.BeforeUndoChangeProperty;
begin
  Exclude(FState, rvtsInserted)
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.AfterUndoChangeProperty;
begin
  Include(FState, rvtsInserted);
  Changed;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SplitSelectedCellsVertically(ColCount: Integer);
var r,c,cs,rs: Integer;
    ColsAdded: Integer;
begin
  if not GetNormalizedSelectionBounds(True, r,c,cs,rs) then
    exit;
  DestroyInplace(True);
  InitUndo;
  try
    ColsAdded := Rows.SplitCellsVertically(r,c,cs,rs, ColCount);
    Select(r,c,rs-1,cs+ColsAdded-1);    
  finally
    DoneUndo;
  end;
  ResetLiveSpell;
  Changed;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SplitSelectedCellsHorizontally(
  RowCount: Integer);
var r,c,cs,rs: Integer;
    RowsAdded: Integer;
begin
  if not GetNormalizedSelectionBounds(True, r,c,cs,rs) then
    exit;
  DestroyInplace(True);
  InitUndo;
  try
    RowsAdded := Rows.SplitCellsHorizontally(r,c,cs,rs, RowCount);
    Select(r,c,rs+RowsAdded-1,cs-1);
  finally
    DoneUndo;
  end;
  ResetLiveSpell;
  Changed;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.CanMergeSelectedCells(AllowMergeRC: Boolean): Boolean;
var r,c,cs,rs: Integer;
begin
  Result := False;
  if not (rvtsSelExists in FState) then
    exit;
  GetNormalizedSelectionBounds(False, r,c,cs,rs);
  Result := Rows.CanMergeCells(r,c,cs,rs, AllowMergeRC);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.CanMergeCells(TopRow, LeftCol, ColSpan,
  RowSpan: Integer; AllowMergeRC: Boolean): Boolean;
begin
  Result := Rows.CanMergeCells(TopRow, LeftCol, ColSpan, RowSpan, AllowMergeRC);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.MergeCells(TopRow, LeftCol, ColSpan,
  RowSpan: Integer; AllowMergeRC: Boolean);
begin
  DestroyInplace(True);
  InitUndo;
  try
    Rows.MergeCells(TopRow, LeftCol, ColSpan, RowSpan, AllowMergeRC, True);
  finally
    DoneUndo;
  end;
  ResetLiveSpell;
  Changed;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.MergeSelectedCells(AllowMergeRC: Boolean);
var r,c,cs,rs: Integer;
begin
  if not (rvtsSelExists in FState) then
    exit;
  GetNormalizedSelectionBounds(False, r,c,cs,rs);
  MergeCells(r,c,cs,rs,AllowMergeRC);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.UnmergeCells(TopRow, LeftCol, ColSpan,
  RowSpan: Integer; UnmergeRows, UnmergeCols: Boolean);
begin
  SaveInplace;
  InitUndo;
  try
    Rows.UnmergeCells(TopRow, LeftCol, ColSpan, RowSpan, UnmergeRows, UnmergeCols);
  finally
    DoneUndo;
    RestoreInplace;
    ResetLiveSpell;
    Changed;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.UnmergeSelectedCells(UnmergeRows, UnmergeCols: Boolean);
var r,c,cs,rs: Integer;
begin
  if not GetNormalizedSelectionBounds(True, r,c,cs,rs) then
    exit;
  UnmergeCells(r,c,cs,rs,UnmergeRows, UnmergeCols);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetEditedCell(var Row, Col: Integer): TCustomRichViewEdit;
begin
  if FInplaceEditor<>nil then begin
    Result := FInplaceEditor;
    Row := TRVTableInplaceEdit(FInplaceEditor).FRow;
    Col := TRVTableInplaceEdit(FInplaceEditor).FCol;
    end
  else begin
    Result := nil;
    Row := -1;
    Col := -1;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.Change;
begin
  ChangeEx(True);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.ChangeEx(ClearRedo: Boolean);
begin
  if (rvtsInserted in FState) and (Rows.FMainRVData is TRVEditRVData) then
    TRVEditRVData(Rows.FMainRVData).ChangeEx(ClearRedo);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.BeginModify(ItemNo: Integer): Integer;
begin
  if (rvtsInserted in FState) and (Rows.FMainRVData is TRVEditRVData) then
    TRVEditRVData(Rows.FMainRVData).BeginItemModify(ItemNo, Result)
  else
    Result := 0;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.EndModify(ItemNo, Data: Integer);
begin
  if (rvtsInserted in FState) and (Rows.FMainRVData is TRVEditRVData) then
    TRVEditRVData(Rows.FMainRVData).EndItemModify(ItemNo, data);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.CreateTemporalEditor: TCustomRichViewEdit;
var ParentEditor: TCustomRichViewEdit;
begin
  ParentEditor := TRVEditRVData(Rows.FMainRVData).RichView as TCustomRichViewEdit;
  Result := TRVTableTemporalEditor.Create2(ParentEditor);
  Result.Options := ParentEditor.Options;
  Result.EditorOptions := ParentEditor.EditorOptions;
  Result.Style := ParentEditor.Style;
  Result.RVData.State := Result.RVData.State+[rvstSkipFormatting];
  try
    Result.BiDiMode := ParentEditor.BiDiMode;
  finally
    Result.RVData.State := Result.RVData.State-[rvstSkipFormatting];
  end;
  if ParentEditor.UndoLimit=0 then
    Result.UndoLimit := 0
  else
    Result.UndoLimit := -1;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.ApplyToCells(ConvType: TRVEStyleConversionType;
  UserData: Integer; SelectedOnly: Boolean);
var tr,lc,rs,cs,r,c,i: Integer;
    ItemNo, Data: Integer;
    Editor: TCustomRichViewEdit;
    ParentEditor: TCustomRichViewEdit;
    ui: TRVUndoMultiCellsModify;
begin
  if not (rvtoEditing in Options) then
    exit;
  ItemNo := GetMyItemNo;
  Data := 0;
  if SelectedOnly then begin
    if not GetNormalizedSelectionBounds(False, tr, lc,cs,rs) or not BeforeChange then
      exit;
    Data := BeginModify(ItemNo);
    InitUndo;
  end;
  Editor := CreateTemporalEditor;
  try
    ParentEditor := TCustomRichViewEdit(TRVEditRVData(Rows.FMainRVData).RichView);
    ui := TRVUndoMultiCellsModify(
             AddTableUndoInfo(TRVEditRVData(Rows.FMainRVData), TRVUndoMultiCellsModify,
                             ItemNo, True, True));
    if ui<>nil then begin
      ui.ItemNo := ItemNo;
      ui.UndoList  := TRVUndoList.Create(TCustomRVFormattedData(ParentEditor.RVData.GetAbsoluteRootData));
      ui.RowList   := TRVIntegerList.Create;
      ui.ColList   := TRVIntegerList.Create;
      ui.CountList := TRVIntegerList.Create;
    end;
    Editor.FCurStyleConversion := ParentEditor.FCurStyleConversion;
    case ConvType of
      rvscParaStyleConversion:
        Editor.OnParaStyleConversion := ParentEditor.OnParaStyleConversion;
      rvscTextStyleConversion:
        Editor.OnStyleConversion := ParentEditor.OnStyleConversion;
    end;
    for r := 0 to RowCount-1 do
      with Rows[r] do
        for c := 0 to Count-1 do
          if (Items[c]<>nil) and (not SelectedOnly or IsCellSelected(r,c)) and
             DoOnCellEditing(r,c,True) then begin
            Editor.RVData.Clear;
            Editor.RVData.DrainFrom(Items[c]);
            Editor.Format;
            Editor.SelectAll;
            Editor.RVData.State := Editor.RVData.State + [rvstSkipFormatting];
            case ConvType of
              rvscParaStyle:
                Editor.ApplyParaStyle(UserData);
              rvscTextStyle:
                Editor.ApplyTextStyle(UserData);
              rvscParaStyleConversion:
                Editor.ApplyParaStyleConversion(UserData, True);
              rvscTextStyleConversion:
                Editor.ApplyStyleConversion(UserData, True);
              {$IFNDEF RVDONOTUSESTYLETEMPLATES}
              rvscParaStyleTemplate:
                Editor.ApplyParaStyleTemplate(UserData, True);
              rvscTextStyleTemplate:
                Editor.ApplyTextStyleTemplate(UserData, False, True);
              {$ENDIF}
            end;
            Editor.RVData.State := Editor.RVData.State - [rvstSkipFormatting];
            if TRVEditRVData(Editor.RVData).UndoList.Count>0 then begin
              if ui<>nil then begin
                ui.RowList.Add(r);
                ui.ColList.Add(c);
                ui.CountList.Add(TRVEditRVData(Editor.RVData).UndoList.Count);
                for i := 0 to TRVEditRVData(Editor.RVData).UndoList.Count-1 do
                  ui.UndoList.AddInfos(TObject(TRVEditRVData(Editor.RVData).UndoList.Items[i]) as TRVUndoInfos, nil);
                for i := TRVEditRVData(Editor.RVData).UndoList.Count-1 downto 0 do
                  TRVEditRVData(Editor.RVData).UndoList.DeleteAsPointer(i);
              end;
            end;
            Changed;            
            Items[c].DrainFrom(Editor.RVData);
          end;
  finally
    Editor.Free;
  end;
  if ConvType in [rvscTextStyle, rvscTextStyleConversion, rvscTextStyleTemplate] then
    ResetLiveSpell;
  if SelectedOnly then begin
    if rvtsModified in FState then
      EndModify(ItemNo, Data);
    DoneUndo;
    Change;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.ApplyStyleConversionToSubRVDatas(UserData: Integer;
  SelectedOnly: Boolean; ConvType: TRVEStyleConversionType);
begin
  ApplyToCells(ConvType, UserData, SelectedOnly);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.CanDeletePartiallySelected: Boolean;
var tr,lc,rs,cs,r,c: Integer;
begin
  Result := rvtoEditing in Options;
  if not Result then
    exit;
  if not GetNormalizedSelectionBounds(False, tr, lc,cs,rs) then
    exit;
  if not (Rows.FMainRVData is TRVEditRVData) then
    exit;
  for r := 0 to RowCount-1 do
    with Rows[r] do
      for c := 0 to Count-1 do
        if (Items[c]<>nil) and IsCellSelected(r,c) then
          if not Items[c].CanClear then begin
            Result := False;
            exit;
          end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.DeletePartiallySelected;
var tr,lc,rs,cs,r,c: Integer;
    ItemNo, Data: Integer;
    RowList, ColList: TRVIntegerList;
    CellsList: TList;
    ui: TRVUndoInfo;
begin
  if not GetNormalizedSelectionBounds(False, tr, lc,cs,rs) or not BeforeChange then
    exit;
  ItemNo := GetMyItemNo;
  RowList := TRVIntegerList.Create;
  ColList := TRVIntegerList.Create;
  try
    for r := 0 to RowCount-1 do
      with Rows[r] do
        for c := 0 to Count-1 do
          if (Items[c]<>nil) and IsCellSelected(r,c) and
             DoOnCellEditing(r,c, True) then begin
             RowList.Add(r);
             ColList.Add(c);
          end;
    if RowList.Count>0 then begin
      Data := BeginModify(ItemNo);
      InitUndo;
      try
        ui := Rows.Do_BeforeClearCells(ItemNo, RowList, ColList, CellsList);
        Rows.Do_ClearCells(CellsList, RowList, ColList, ui);
      finally
        DoneUndo;
        EndModify(ItemNo,Data);
        ResetLiveSpell;
        Change;
      end;
    end;
  finally
    RowList.Free;
    ColList.Free;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.DoAfterFillingRows(Row, Count: Integer);
var r,c: Integer;
    ItemNo: Integer;
    RowList, ColList: TRVIntegerList;
    CellsList: TList;
    ui: TRVUndoInfo;
begin
  if (Count=0) or (Row>=RowCount) then
    exit;
  if Row+Count>RowCount then
    Count := RowCount-Row;
  ItemNo := GetEditorItemNoForUndo;
  RowList := TRVIntegerList.Create;
  ColList := TRVIntegerList.Create;
  try
    for r := Row to Row+Count-1 do
      for c := 0 to ColCount-1 do
        if Cells[r,c]<>nil then begin
          RowList.Add(r);
          ColList.Add(c);
        end;
    if RowList.Count>0 then begin
      InitUndo;
      try
        ui := Rows.Do_BeforeClearCells(ItemNo, RowList, ColList, CellsList);
        if ui<>nil then begin
          TRVUndoCellsClear(ui).CellsList.Free;
          TRVUndoCellsClear(ui).CellsList := nil;
          TRVUndoCellsClear(ui).Flag := True;
        end;
      finally
        DoneUndo;
        Change;
      end;
    end;
  finally
    RowList.Free;
    ColList.Free;
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetCellTo(Row, Col: Integer;
  Dir: TRVCellDirection; var NewRow, NewCol: Integer;
  Quiet, CanAddRow: Boolean): Boolean;
var r,c: Integer;
    data: Integer;
begin
  case Dir of
    rvcdUp:
      begin
        Result := Row>0;
        if Result then
          Rows.GetMainCell(Row-1,Col,NewRow,NewCol);
      end;
    rvcdLeft:
      begin
        Result := (Col>0) or (Row>0) ;
        if Result then
          if Col>0 then
            Rows.GetMainCell(Row,Col-1,NewRow,NewCol)
          else
            Result := GetCellTo(Row, Col, rvcdPrev, NewRow,NewCol, True, False);
      end;
    rvcdRight:
      begin
        Result := (Col+Cells[Row,Col].ColSpan<ColCount) or
                  (Row+Cells[Row,Col].RowSpan<RowCount);
        if Result then
          if (Col+Cells[Row,Col].ColSpan<ColCount) then
            Rows.GetMainCell(Row,Col+Cells[Row,Col].ColSpan,NewRow,NewCol)
          else
            Result := GetCellTo(Row, Col, rvcdNext, NewRow,NewCol, True, False);
      end;
    rvcdDown:
      begin
        Result := Row+Cells[Row,Col].RowSpan<RowCount;
        if Result then
          Rows.GetMainCell(Row+Cells[Row,Col].RowSpan,Col,NewRow,NewCol);
      end;
    rvcdNext:
      begin
        NewRow := Row;
        NewCol := Col+1;
        Result := True;
        while NewCol<ColCount do begin
          if Cells[NewRow,NewCol]<>nil then
            exit;
          inc(NewCol);
        end;
        for r := Row+1 to RowCount-1 do
          for c := 0 to ColCount-1 do
            if (Cells[r,c]<>nil) then begin
              NewRow := r;
              NewCol := c;
              exit;
            end;
        if (rvtsInserted in FState) and IsInEditor and CanAddRow and BeforeChange then begin
          data := BeginModify(GetMyItemNo);
          try
            InsertRows(RowCount, 1, RowCount-1 {$IFDEF RICHVIEWDEF4}, False{$ENDIF});
          finally
            EndModify(GetMyItemNo, data);
            Change;
          end;
          Result := GetCellTo(Row, Col, Dir, NewRow, NewCol, Quiet, False);
          exit;
        end;
        Result := False;
        if not Quiet then Beep;
      end;
    rvcdPrev:
      begin
        NewRow := Row;
        NewCol := Col-1;
        Result := True;
        while NewCol>=0 do begin
          if Cells[NewRow,NewCol]<>nil then
            exit;
          dec(NewCol);
        end;
        for r := Row-1 downto 0 do
          for c := ColCount-1 downto 0 do
            if (Cells[r,c]<>nil) then begin
              NewRow := r;
              NewCol := c;
              exit;
            end;
        Result := False;
        if not Quiet then Beep;
      end;
    else
      Result := False;
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.CanSeeBackgroundThroughCell(Cell: TRVTableCellData): Boolean;
begin
  Result := (Cell.Color=clNone) and (Color=clNone);
  if Result and (Rows.FMainRVData is TCustomRVFormattedData) then
    Result := Rows.FMainRVData.GetRVStyle.ParaStyles[ParaNo].Background.Color=clNone;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetTableColor(UseParentBackground: Boolean): TColor;
begin
  Result := Color;
  if Result=clNone then
    if Rows.FMainRVData is TCustomRVFormattedData then begin
      Result := Rows.FMainRVData.GetRVStyle.ParaStyles[ParaNo].Background.Color;
      if UseParentBackground and (Result=clNone) then
        Result := TCustomRVFormattedData(Rows.FMainRVData).GetColor;
    end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetCellColor(Cell: TRVTableCellData): TColor;
begin
  Result := Cell.Color;
  if Result=clNone then begin
    Result := Color;
    if Result=clNone then
      if Rows.FMainRVData is TCustomRVFormattedData then begin
        Result := Rows.FMainRVData.GetRVStyle.ParaStyles[ParaNo].Background.Color;
        if Result=clNone then
          Result := TCustomRVFormattedData(Rows.FMainRVData).GetColor;
      end;
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetCellColor2(Cell: TRVTableCellData): TColor;
begin
  Result := Cell.Color;
  if Result=clNone then
    Result := Color;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.CanSplitAtRow(Row: Integer): Boolean;
var c,mr,mc: Integer;
    Cell:TRVTableCellData;
begin
  Result := True;
  c := ColCount-1;
  while c>=0 do begin
    Cell := Rows.GetMainCell(Row,c,mr,mc);
    if mr+Cell.RowSpan-1>Row then begin
      Result := False;
      exit;
    end;
    c := mc-1;
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetSplitRowBelow(Row: Integer): Integer;
var r,c,mr,mc: Integer;
    Cell:TRVTableCellData;
    CanSplit:Boolean;
begin
  r := Row;
  while r<RowCount-1 do begin
    c := ColCount-1;
    CanSplit := True;
    while c>=0 do begin
      Cell := Rows.GetMainCell(r,c,mr,mc);
      mr := mr+Cell.RowSpan-1;
      if mr>r then begin
        r := mr;
        CanSplit := False;
        break;
      end;
      c := mc-1;
    end;
    if CanSplit then
      break;
  end;
  Result := r;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetSplitRowAbove(Row: Integer): Integer;
var r,c,mr,mc: Integer;
    CanSplit:Boolean;
begin
  r := Row;
  while r>0 do begin
    c := ColCount-1;
    CanSplit := True;
    while c>=0 do begin
      Rows.GetMainCell(r,c,mr,mc);
      if mr<r then begin
        r := mr;
        CanSplit := False;
        break;
      end;
      c := mc-1;
    end;
    if CanSplit then
      break;
  end;
  Result := r;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERTF}
procedure TRVTableItemInfo.FillRTFTables(ColorList: TRVColorList;
  ListOverrideCountList: TRVIntegerList; RVData: TPersistent); 
var r,c: Integer;
begin
  ColorList.AddUnique(Color);
  case BorderStyle of
    rvtbRaised, rvtbLowered:
      begin
        ColorList.AddUnique(clBtnHighlight);
        ColorList.AddUnique(clBtnShadow);
        ColorList.AddUnique(clBtnFace);
      end;
    rvtbColor:
      ColorList.AddUnique(BorderColor);
    rvtbRaisedColor, rvtbLoweredColor:
      begin
        ColorList.AddUnique(BorderColor);
        ColorList.AddUnique(BorderLightColor);
      end;
  end;
  case CellBorderStyle of
    rvtbRaised, rvtbLowered:
      begin
        ColorList.AddUnique(clBtnHighlight);
        ColorList.AddUnique(clBtnShadow);
        ColorList.AddUnique(clBtnFace);
      end;
    rvtbColor:
      ColorList.AddUnique(CellBorderColor);
    rvtbRaisedColor, rvtbLoweredColor:
      begin
        ColorList.AddUnique(CellBorderColor);
        ColorList.AddUnique(CellBorderLightColor);
      end;
  end;
  if VRuleWidth>0 then
    ColorList.AddUnique(VRuleColor);
  if HRuleWidth>0 then
    ColorList.AddUnique(HRuleColor);
  for r := 0 to RowCount-1 do
    with Rows[r] do
      for c := 0 to Count-1 do
        if (Items[c]<>nil) then begin
          ColorList.AddUnique(Items[c].Color);
          ColorList.AddUnique(Items[c].BorderColor);
          ColorList.AddUnique(Items[c].BorderLightColor);
          Items[c].MakeRTFTables(ColorList, ListOverrideCountList, False);
        end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SaveRTF(Stream: TStream; const Path: String;
  RVData: TPersistent; ItemNo: Integer; TwipsPerPixel: Double;
  Level: Integer; ColorList: TRVColorList;
  StyleToFont, ListOverrideOffsetsList1, ListOverrideOffsetsList2: TRVIntegerList;
  FontTable: TRVList; HiddenParent: Boolean);
var RVStyle: TRVStyle;
  {......................................................}
  function GetBorderString(BorderStyle:TRVTableBorderStyle; Width: Integer;  Color: Integer): TRVAnsiString;
  begin
    case BorderStyle of
      rvtbColor:
        Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\brdrs\brdrw%d\brdrcf%d',[Width,ColorList.IndexOf(Pointer(Color))]);
      rvtbLowered:
        Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\brdrinset\brdrw%d',[Width]);
      rvtbRaised:
        Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\brdroutset\brdrw%d',[Width]);
      rvtbLoweredColor:
        Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\brdrs\brdrw%d\brdrcf%d',[Width,ColorList.IndexOf(Pointer(Color))]);
      rvtbRaisedColor:
        Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\brdrs\brdrw%d\brdrcf%d',[Width,ColorList.IndexOf(Pointer(Color))]);
    end;
  end;
  {......................................................}
  procedure SaveBorder(BorderStyle:TRVTableBorderStyle; Width: TRVStyleLength;
    Color, LightColor: TColor; VisibleBorders: TRVBooleanRect;
    const prefix: TRVAnsiString; MainRow, MainCol, Row, Col: Integer);
  var LTColor,RBColor: TColor;
      WidthTw: Integer;

    function IsLeftSideVisible: Boolean;
    begin
      Result := (VisibleBorders=nil);
      if Result then
        exit;
      Result := {(Col=MainCol) and }VisibleBorders.Left;
    end;
    function IsTopSideVisible: Boolean;
    begin
      Result := (VisibleBorders=nil);
      if Result then
        exit;
      Result := {(Row=MainRow) and }VisibleBorders.Top;
    end;
    function IsRightSideVisible: Boolean;
    begin
      Result := (VisibleBorders=nil);
      if Result then
        exit;
      Result := {(Col=MainCol+Cells[MainRow,MainCol].ColSpan-1) and }VisibleBorders.Right;
    end;

    function IsBottomSideVisible: Boolean;
    begin
      Result := (VisibleBorders=nil);
      if Result then
        exit;
      Result := {(Row=MainRow+Cells[MainRow,MainCol].RowSpan-1) and }VisibleBorders.Bottom;
    end;

  begin
    if Width<=0 then
      exit;
    WidthTw := RVStyle.GetAsTwips(Width);
    case BorderStyle of
      rvtbRaisedColor:
        begin
          LTColor := LightColor;
          RBColor := Color;
        end;
      rvtbLoweredColor:
        begin
          LTColor := Color;
          RBColor := LightColor;
        end;
      else
        begin
          LTColor := Color;
          RBColor := Color;
        end;
    end;
    if IsLeftSideVisible then
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\%sbrdrl%s', [prefix, GetBorderString(BorderStyle, WidthTw, LTColor)]));
    if IsTopSideVisible then
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\%sbrdrt%s', [prefix, GetBorderString(BorderStyle, WidthTw, LTColor)]));
    if IsRightSideVisible then
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\%sbrdrr%s', [prefix, GetBorderString(BorderStyle, WidthTw, RBColor)]));
    if IsBottomSideVisible then
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\%sbrdrb%s', [prefix, GetBorderString(BorderStyle, WidthTw, RBColor)]));
  end;
  {......................................................}
var r,c,mr,mc,h: Integer;
  Nested: Boolean;
  NestS,s: TRVAnsiString;
  Cell: TRVTableCellData;
  valHTw,valVTw, valTTw,valBTw, TableIndentTw: Integer;
  gaph2, Right: TRVStyleLength;
  BColor, BLColor: TColor;
begin
  if (Fmt.FWidth=0) or (DrawItemNo<0) then begin
    h := 0;
    if FRows.FMainRVData is TCustomRVFormattedData then
      h :=  TCustomRVFormattedData(FRows.FMainRVData).DocumentWidth;
    if h<=0 then
      h := 600;
    OnDocWidthChange(h, nil, False,nil, FRows.FMainRVData,nil,r,r,False,False,False);
  end;
  RVStyle := Rows.FMainRVData.GetRVStyle;
  Nested := Level>0;
  NestS := '';
  TableIndentTw := RVStyle.GetAsTwips(RVStyle.ParaStyles[ParaNo].LeftIndent);
  for r := 0 to RowCount-1 do begin
    //if Rows[r].PageBreakBefore then
    //  RVFWrite(Stream, '\page');
    if Nested then
      NestS := '\*\nesttableprops';
    RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('{%s',[NestS]));
    case TCustomRVData(RVData).GetRVStyle.ParaStyles[TCustomRVData(RVData).GetItemPara(ItemNo)].Alignment of
      rvaRight:
        s := '\trqr';
      rvaCenter:
        s := '\trqc';
    end;
    gaph2 := (CellHSpacing+(CellHPadding+CellBorderWidth)*2);
    if gaph2<0 then
      gaph2 := 0;
    RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\trowd%s\trgaph%d\trleft%d',
      [s, RVStyle.GetAsTwips(Round(gaph2/2)), TableIndentTw]));
    if Level+1<>1 then
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\itap%d', [Level+1]));
    if r<HeadingRowCount then
      RVFWrite(Stream, '\trhdr');
    h := Rows[r].GetBestHeight;
    if h>0 then
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\trrh%d',[RVStyle.GetAsTwips(h)]));
    valHTw := RVStyle.GetAsTwips(CellHPadding);
    valVTw := RVStyle.GetAsTwips(CellVPadding);
    RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\trpaddl%d\trpaddt%d\trpaddr%d\trpaddb%d\trpaddfl3\trpaddft3\trpaddfr3\trpaddfb3',
      [valHTw,valVTw,valHTw,valVTw]));

    if (CellHSpacing>=0) or (CellVSpacing>=0) or (BorderVSpacing>0) then begin
      valHTw := Round(RVStyle.GetAsTwips(CellHSpacing)/2);
      if r=0 then
        valTTw := Round(RVStyle.GetAsTwips(BorderVSpacing)/2)
      else
        valTTw := Round(RVStyle.GetAsTwips(CellVSpacing)/2);
      if r=RowCount-1 then
        valBTw := Round(RVStyle.GetAsTwips(BorderVSpacing)/2)
      else
        valBTw := Round(RVStyle.GetAsTwips(CellVSpacing)/2);
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\trspdl%d\trspdr%d\trspdfl3\trspdfr3',[valHTw,valHTw]));
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\trspdt%d\trspdft3',[valTTw]));
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\trspdb%d\trspdfb3',[valBTw]));
    end;
    (* does not work...
    val1 := Round(BorderHSpacing*TwipsPerPixel);
    RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\trftsWidthB3\trftsWidthB3\trwWidthB%d\trwWidthA%d',[val1,val1]));
    *)
    if BestWidth>0 then
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(
        '\trwWidth%d\trftsWidth3',
        [RVStyle.GetAsTwips(BestWidth+BorderWidth*2)]))
    else if BestWidth<0 then
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\trwWidth%d\trftsWidth2',[-BestWidth*50]))
    else begin
      RVFWrite(Stream, '\trftsWidth1');
      if RichViewTableDefaultRTFAutofit or (rvtoRTFAllowAutofit in Options) then
        RVFWrite(Stream, '\trautofit1');
    end;
    if not (rvtoRowsSplit in PrintOptions) then
      RVFWrite(Stream, '\trkeep\trkeepfollow');
    if (r=RowCount-1) and not Nested then
      RVFWrite(Stream, '\lastrow');
    if RVStyle.Units=rvstuPixels then
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\richviewtbw%d',[BestWidth])) // for RichView only
    else
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\richviewtbwtw%d',[BestWidth])); // for RichView only
    SaveBorder(BorderStyle, BorderWidth, BorderColor, BorderLightColor, VisibleBorders, 'tr',
      -1, -1, -1, -1);
    RVFWrite(Stream, Rows.FMainRVData.GetExtraRTFCode(rv_rtfs_RowProps, Self, r, -1, False));
    if Hidden or HiddenParent then
      RVFWrite(Stream, '\v');
    with Rows[r] do begin
      for c := 0 to Count-1 do begin
        Cell := Rows.GetMainCell(r,c,mr,mc);
        if c>mc then
          continue;
        if Items[c]=nil then begin
          if (r=mr) and (Cell.RowSpan>1) then
            RVFWrite(Stream, '\clvmgf');
          if (r>mr)  then
            RVFWrite(Stream, '\clvmrg');
          end
        else begin
          if (Cell.RowSpan>1) then
            RVFWrite(Stream, '\clvmgf');
        end;
        if Items[c]<>nil then begin
          if Cell.BestWidth>0 then begin
            if rvtoRTFSaveCellPixelBestWidth in Options then
              RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(
                '\clwWidth%d\clftsWidth3',[RVStyle.GetAsTwips(Cell.BestWidth)]))
            else
              RVFWrite(Stream, '\clwWidth0')
            end
          else if Cell.BestWidth<0 then
            RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\clwWidth%d\clftsWidth2',[-Cell.BestWidth*50]))
          else
            RVFWrite(Stream,'\clftsWidth1');
         if RVStyle.Units=rvstuPixels then
           RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(
             '\richviewcbw%d\richviewcbh%d',[Cell.BestWidth,Cell.BestHeight])) // for RichView only
         else
           RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(
             '\richviewcbwtw%d\richviewcbhtw%d',[Cell.BestWidth,Cell.BestHeight])) // for RichView only         
        end;
        if Cell.BorderColor<>clNone then
          BColor := Cell.BorderColor
        else
          BColor := CellBorderColor;
        if Cell.BorderLightColor<>clNone then
          BLColor := Cell.BorderLightColor
        else
          BLColor := CellBorderLightColor;
        SaveBorder(CellBorderStyle, CellBorderWidth, BColor, BLColor, Cell.VisibleBorders, 'cl',
          mr, mc, r, c);
        if GetCellColor2(Cell)<>clNone then
          RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\clcbpat%d',[ColorList.IndexOf(Pointer(GetCellColor2(Cell)))]));
        case Cell.GetRealVAlign of
          //rvcTop: {default}
          //  RVFWrite(Stream, '\clvertalt');
          rvcMiddle:
            RVFWrite(Stream, '\clvertalc');
          rvcBottom:
            RVFWrite(Stream, '\clvertalb');
        end;
        RVFWrite(Stream, Rows.FMainRVData.GetExtraRTFCode(rv_rtfs_CellProps, Self, r, c, False));
        //Right := Fmt.ColStarts[c]+Fmt.ColWidths[c];
        Right := RVStyle.PixelsToUnits(Fmt.ColStarts[mc+Cell.ColSpan-1]+Fmt.ColWidths[mc+Cell.ColSpan-1])+CellHPadding*2;
        RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(
          '\cellx%d',[RVStyle.GetAsTwips(Round(Right+CellHSpacing/2))+TableIndentTw]));
      end;
      RVFWrite(Stream, '\pard\intbl');
      if Level+1<>1 then
        RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\itap%d', [Level+1]));
      RVFWrite(Stream, '{');
      //if Hidden or HiddenParent then
      //  RVFWrite(Stream, '\v');      
      for c := 0 to Count-1 do begin
        Rows.GetMainCell(r,c,mr,mc);
        if c>mc then
          continue;
        RVFWrite(Stream, '{');
        if (Items[c]<>nil) then begin
          Items[c].GetRVData.SaveRTFToStream(Stream, Path, False, Level+1, clNone, nil,
          ColorList, StyleToFont, ListOverrideOffsetsList1, ListOverrideOffsetsList2,
          TRVRTFFontTable(FontTable), TwipsPerPixel, True, Hidden or HiddenParent, nil, nil);
        end;
        if Nested then
          NestS := 'nest';
        RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\%scell}',[NestS]));
      end;
    end;
    RVFWrite(Stream, '}\pard\intbl');
    if Level+1<>1 then
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\itap%d', [Level+1]));
    if Nested then
      NestS := 'nest';
    RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\%srow}',[NestS]));
  end;
  Include(TCustomRVData(RVData).State, rvstRTFSkipPar);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEHTML}
procedure TRVTableItemInfo.SaveToHTML(Stream: TStream; RVData: TPersistent;
  ItemNo: Integer;
  const Text: TRVRawByteString; const Path, imgSavePrefix: String; var imgSaveNo: Integer;
  CurrentFileColor: TColor; SaveOptions: TRVSaveOptions; UseCSS: Boolean;
  Bullets: TRVList);
var ThisUseCSS: Boolean;
    CellSpacing: TRVStyleLength;
    RVStyle: TRVStyle;
const VAlignStr: array[TRVCellVAlign] of TRVAnsiString =
    ('top', 'middle', 'bottom', '');
  {.....................................................}
  function GetHTMLLength(v: TRVHTMLLength; ForHTMLAttr: Boolean): TRVAnsiString;
  begin
    if v=0 then
      Result := ''
    else if v>0 then
      if ForHTMLAttr then
        Result := RVIntToStr(RVStyle.GetAsPixels(v))
      else
        Result := RVStyle.GetCSSSize(v)
    else begin
      Result := RVIntToStr(-v)+'%';
      if ForHTMLAttr then
        Result := '"'+Result+'"';    
    end;
  end;
  {.....................................................}
  function GetCellCSS(Cell: TRVTableCellData): TRVAnsiString;
  var BColor, BLColor: TColor;
  begin
    Result := '';
    if not ThisUseCSS then
      exit;
    if (Cell<>nil) and (Cell.BorderColor<>clNone) then
      BColor := Cell.BorderColor
    else
      BColor := CellBorderColor;
    if (Cell<>nil) and (Cell.BorderLightColor<>clNone) then
      BLColor := Cell.BorderLightColor
    else
      BLColor := CellBorderLightColor;
    {$IFNDEF RVPBEARCOMPAT}
    if (((CellBorderWidth<>BorderWidth) or (RVStyle.GetAsPixels(BorderWidth)>1)) and
       not ((RVStyle.GetAsPixels(CellBorderWidth)=1) and (RVStyle.GetAsPixels(BorderWidth)>1))) or
       (RVStyle.PixelsToUnits(RVStyle.GetAsPixels(CellBorderWidth))<>CellBorderWidth) then
    {$ENDIF}
      Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('border-width : %s;', [RVStyle.GetCSSSize(CellBorderWidth)]);
    if CellBorderWidth>0 then
      case CellBorderStyle of
        rvtbColor:
          (*
          if BorderWidth=0 then
            RV_AddStr(Result, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('border-color: %s; border-style: solid;',
                [RV_GetHTMLRGBStr(BColor, False)]))
          else
          *)
            RV_AddStrA(Result, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('border-color: %s; border-style: solid;',
                [RV_GetHTMLRGBStr(BColor, False)]));
        rvtbRaisedColor:
          RV_AddStrA(Result, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('border-color : %s %s %s %s; border-style: solid;',
            [RV_GetHTMLRGBStr(BLColor, False),RV_GetHTMLRGBStr(BColor, False),
             RV_GetHTMLRGBStr(BColor, False),RV_GetHTMLRGBStr(BLColor, False)]));
        rvtbLoweredColor:
          {if (BColor<>BorderColor) or (BLColor<>BorderLightColor) or
             not (BorderStyle in [rvtbLoweredColor,rvtbRaisedColor]) then }
            RV_AddStrA(Result, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('border-color : %s %s %s %s; border-style: solid;',
              [RV_GetHTMLRGBStr(BColor, False),RV_GetHTMLRGBStr(BLColor, False),
               RV_GetHTMLRGBStr(BLColor, False), RV_GetHTMLRGBStr(BColor, False)]));
        rvtbRaised:
          RV_AddStrA(Result, 'border-style: outset;');
        rvtbLowered:
          RV_AddStrA(Result, 'border-style: inset;');
      end;
  end;
  {.....................................................}
  function GetBackgroundFileName(Background: TRVBackground; Color: TColor;
    ItemNo: Integer; ARVData: TCustomRVData;
    const BackgroundImageFileName: String) : TRVAnsiString;
  var Location: String;
      DoDefault: Boolean;
  begin
    Result := '';
    if (Background=nil) or not Background.Visible then
      exit;
    if Color=clNone then
      Color := CurrentFileColor;
    if (BackgroundImageFileName<>'') and (rvsoUseItemImageFileNames in SaveOptions) then
      Location := RVExtractRelativePath(Path, BackgroundImageFileName)
    else
      Location := '';
    ARVData.HTMLSaveImage(ARVData, ItemNo, Path, Color, Location, DoDefault);
    if DoDefault then begin
      if (BackgroundImageFileName<>'') and (rvsoUseItemImageFileNames in SaveOptions) then
        Location := RVExtractRelativePath(Path, BackgroundImageFileName)
      else
        Location := TCustomRVData(RVData).DoSavePicture(rvsfHTML, imgSavePrefix, Path,
          imgSaveNo, rvsoOverrideImages in SaveOptions, Color, Background.Image);
    end;
    if Location<>'' then
      Result := StringToHTMLString(RV_GetHTMLPath(Location), SaveOptions, ARVData.GetRVStyle);
  end;
  {.....................................................}
  function GetThisCellCSS(Cell : TRVTableCellData; const DefCss: TRVAnsiString): TRVAnsiString;
  var bss, s: TRVAnsiString;
  begin
    if (Cell.BorderColor<>clNone) or (Cell.BorderLightColor<>clNone) then
      Result := GetCellCSS(Cell)
    else
      Result := DefCss;
    if not ThisUseCSS then
      exit;
    if (Cell.FBackground=nil) or not Cell.FBackground.Visible then
      bss := ''
    else begin
      if Cell.BackgroundStyle in [rvbsCentered, rvbsStretched] then
        bss := 'background-position: center center; background-repeat: no-repeat;'
      else if BackgroundStyle in [rvbsCentered, rvbsStretched] then
        bss := 'background-position: left top; background-repeat: repeat;'
      else
        bss := '';
      if UseCSS then begin
        s := GetBackgroundFileName (Cell.FBackground, GetCellColor(Cell), -1, Cell,
          Cell.BackgroundImageFileName);
        if s<>'' then
          RV_AddStrA(bss, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('background-image: url(''%s'');', [s]));
      end;
    end;
    RV_AddStrA(Result, bss);
    if CellBorderWidth>0 then begin
      if not Cell.VisibleBorders.Top then
        RV_AddStrA(Result, 'border-top: none;');
      if not Cell.VisibleBorders.Right then
        RV_AddStrA(Result, 'border-right: none;');
      if not Cell.VisibleBorders.Bottom then
        RV_AddStrA(Result, 'border-bottom: none;');
      if not Cell.VisibleBorders.Left then
        RV_AddStrA(Result, 'border-left: none;');
    end;
    if Cell.Color<>Color then begin
      s := RV_GetHTMLRGBStr(Cell.Color, False);
      if s<>'' then
        RV_AddStrA(Result, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('background-color: %s;', [s]));
    end;
    if UseCSS and (rvsoXHTML in SaveOptions) then begin
      s := GetHTMLLength(Cell.BestWidth, False);
      if s<>'' then
        RV_AddStrA(Result, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('width: %s;', [s]));
      s := GetHTMLLength(Cell.BestHeight, False);
      if s<>'' then
        RV_AddStrA(Result, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('height: %s;', [s]));
    end;
    if Result<>'' then
      Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(' style="%s"',[Result]);
  end;
  {.....................................................}
  function GetRules: TRVAnsiString;
  begin
    {
    if HRuleWidth>0 then
     if VRuleWidth>0 then
       Result := 'all'
     else
       Result := 'cols'
    else
     if VRuleWidth>0 then
       Result := 'rows'
     else
    }
       Result := ''
   end;
  {.....................................................}
  function AddAttribute(const Name, Value, DefValue: TRVAnsiString): TRVAnsiString;
  begin
    if (Value<>DefValue) and (Value<>'') then
      Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(' %s=%s',[Name, RV_HTMLGetStrAttrVal(Value, SaveOptions)])
    else
      Result := '';
  end;
  {.....................................................}
  function AddBorderColorAttr(BorderStyle: TRVTableBorderStyle;
    BorderColor, BorderLightColor: TColor): TRVAnsiString;
  begin
    Result := '';
    if UseCSS then
      exit;
    case BorderStyle of
      rvtbColor:
        Result := AddAttribute('bordercolor', RV_GetHTMLRGBStr(BorderColor, True), '');
      rvtbRaisedColor:
        begin
          Result := AddAttribute('bordercolorlight', RV_GetHTMLRGBStr(BorderLightColor, True), '')+
                    AddAttribute('bordercolordark', RV_GetHTMLRGBStr(BorderColor, True), '');
        end;
      rvtbLoweredColor:
        begin
          Result := AddAttribute('bordercolorlight', RV_GetHTMLRGBStr(BorderColor, True), '')+
                    AddAttribute('bordercolordark', RV_GetHTMLRGBStr(BorderLightColor, True), '');
        end;
    end;
  end;
  {.....................................................}
  function GetTableCSS: TRVAnsiString;
  var s: TRVAnsiString;
  begin
    Result := '';
    if not ThisUseCSS then
      exit;
    if BorderWidth>0 then begin
      case BorderStyle of
        rvtbLoweredColor:
          Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('border-color: %s %s %s %s; border-style: solid;',
            [RV_GetHTMLRGBStr(BorderColor, False),RV_GetHTMLRGBStr(BorderLightColor, False),
             RV_GetHTMLRGBStr(BorderLightColor, False), RV_GetHTMLRGBStr(BorderColor, False)]);
        rvtbRaisedColor:
          Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('border-color: %s %s %s %s; border-style: solid;',
            [RV_GetHTMLRGBStr(BorderLightColor, False),RV_GetHTMLRGBStr(BorderColor, False),
             RV_GetHTMLRGBStr(BorderColor, False), RV_GetHTMLRGBStr(BorderLightColor, False)]);
        rvtbLowered:
          Result := 'border-style: inset;';
        rvtbColor:
          if UseCSS then
            Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('border-color: %s; border-style: solid;', [RV_GetHTMLRGBStr(BorderColor, False)]);
      end;
      {$IFNDEF RVPBEARCOMPAT}
      if RVStyle.PixelsToUnits(RVStyle.GetAsPixels(BorderWidth))<>BorderWidth then
      {$ENDIF}
        RV_AddStrA(Result, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('border-width: %s;', [RVStyle.GetCSSSize(BorderWidth)]));
      end
    else
      Result := 'border-width: 0px;';
    if BackgroundStyle in [rvbsCentered, rvbsStretched] then
      RV_AddStrA(Result, 'background-position: center center; background-repeat: no-repeat;');
    if UseCSS and (FBackground<>nil) and FBackground.Visible then begin
      s := GetBackgroundFileName(FBackground, Color, ItemNo, TCustomRVData(RVData),
        BackgroundImageFileName);
      if s<>'' then
        RV_AddStrA(Result, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('background-image: url(''%s'');', [s]));
    end;
    s := RV_GetHTMLRGBStr(Color, False);
    if s<>'' then
      RV_AddStrA(Result, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('background-color: %s;', [s]));
    if CellSpacing<0 then
      RV_AddStrA(Result, 'border-collapse: collapse;');
    if BorderWidth>0 then begin
      if not VisibleBorders.Top then
        RV_AddStrA(Result, 'border-top: none;');
      if not VisibleBorders.Right then
        RV_AddStrA(Result, 'border-right: none;');
      if not VisibleBorders.Bottom then
        RV_AddStrA(Result, 'border-bottom: none;');
      if not VisibleBorders.Left then
        RV_AddStrA(Result, 'border-left: none;');
    end;
    if Result<>'' then
      Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(' style="%s"',[Result]);
  end;
  {.....................................................}
  function AddTableBorderAttribute: TRVAnsiString;
  begin
    if not ThisUseCSS or (BorderWidth>0) or (CellBorderWidth=0) then
      Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(' border=%s',
        [RV_HTMLGetIntAttrVal(RVStyle.GetAsPixels(BorderWidth), SaveOptions)])
    else
      Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(' border=%s',
        [RV_HTMLGetIntAttrVal(1, SaveOptions)])
  end;
  {.....................................................}
  function AddBackgroundAttribute(Background: TRVBackground; RealColor, Color, DefColor: TColor;
    ItemNo: Integer; ARVData: TCustomRVData;
    const BackgroundImageFileName: String) : TRVAnsiString;
  var Location: TRVAnsiString;
  begin
    Result := '';
    if not UseCSS then
      Result := AddAttribute('bgcolor', RV_GetHTMLRGBStr(Color, True), RV_GetHTMLRGBStr(DefColor, True));
    if UseCSS or (Background=nil) or not Background.Visible then
      exit;
    Location := GetBackgroundFileName(Background, RealColor, ItemNo, ARVData, BackgroundImageFileName);
    if Location<>'' then
      Result := Result+{$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(' background="%s"', [Location]);
  end;
  {.....................................................}
  function AddWidthAndHeightAttrs(Cell: TRVTableCellData): TRVAnsiString;
  begin
    if not UseCSS or not (rvsoXHTML in SaveOptions) then
      Result := AddAttribute('width', GetHTMLLength(Cell.BestWidth, True), '')+
                AddAttribute('height', GetHTMLLength(Cell.BestHeight, True), '');
  end;
  {.....................................................}
  {
  function GetTableAlign: String;
  begin
    case TCustomRVData(Rows.FMainRVData).GetRVStyle.ParaStyles[ParaNo].Alignment of
      rvaCenter:
        Result := 'center';
      rvaRight:
        Result := 'right';
      else
        Result := 'left';
    end;
  end;
  }
var
  Cell: TRVTableCellData;
  r,c: Integer;
  Options:TRVSaveOptions;
  CellCSS: TRVAnsiString;
begin
  RVStyle := GetRVStyle;
  ThisUseCSS := UseCSS or (rvsoForceNonTextCSS in SaveOptions);
  CellCSS := GetCellCSS(nil);
  Options  := SaveOptions;
  Include(Options, rvsoMiddleOnly);
  Exclude(Options, rvsoFirstOnly);
  Exclude(Options, rvsoLastOnly);
  CellSpacing := Round((CellVSpacing+CellHSpacing)/2);
  RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<table%s%s%s%s%s%s%s%s>',
    [
     //AddAttribute('align', GetTableAlign, ''),
     AddAttribute('width', GetHTMLLength(BestWidth, True), ''),
     AddTableBorderAttribute,
     AddAttribute('cellpadding', RVIntToStr(RVStyle.GetAsPixels(CellPadding)), ''),
     AddBorderColorAttr(BorderStyle, BorderColor, BorderLightColor),
     AddAttribute('cellspacing', RVIntToStr(RVStyle.GetAsPixels(CellSpacing)), ''),
     AddAttribute('rules',GetRules,''),
     AddBackgroundAttribute(FBackground, Color, Color, clNone, ItemNo, TCustomRVData(RVData),
       BackgroundImageFileName),
     GetTableCSS]));
  for r := 0 to RowCount-1 do begin
    RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<tr%s>',[AddAttribute('valign', VAlignStr[Rows[r].VAlign], '')]));
    for c := 0 to ColCount-1 do
      if Cells[r,c]<>nil then begin
        Cell := Cells[r,c];
        RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<td%s%s%s%s%s%s>',
          [
          AddAttribute('colspan', RVIntToStr(Cell.ColSpan), '1'),
          AddAttribute('rowspan', RVIntToStr(Cell.RowSpan), '1'),
          AddWidthAndHeightAttrs(Cell),
          AddAttribute('valign', VAlignStr[Cell.VAlign], ''),
          AddBackgroundAttribute(Cell.FBackground, GetCellColor(Cell),
            Cell.Color, Color, -1, Cell, Cell.BackgroundImageFileName),
          GetThisCellCSS(Cell, CellCSS)
          ]));
        if Cell.HasData(True) then
          if UseCSS then
            Cell.GetRVData.SaveHTMLToStreamEx(Stream, Path, '', imgSavePrefix, '','', '',Options,
                                    GetCellColor(Cell), CurrentFileColor, imgSaveNo,
                                    0,0,0,0,nil,Bullets)
          else
            Cell.GetRVData.SaveHTMLToStream(Stream,Path, '', imgSavePrefix,  Options,
                                  GetCellColor(Cell), imgSaveNo,
                                  0,0,0,0,nil,Bullets)
        else
          RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<br%s>',[RV_HTMLGetEndingSlash(SaveOptions)]));
        RVFWriteLine(Stream, '</td>');
      end;
    RVFWriteLine(Stream, '</tr>');
  end;
  RVFWriteLine(Stream, '</table>');
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRVTableItemInfo.AsText(LineWidth: Integer; RVData: TPersistent;
  const Text: TRVRawByteString; const Path: String; TextOnly,Unicode: Boolean): TRVRawByteString;
var r,c: Integer;
    Stream: TRVMemoryStream;
    RSep,CSep:TRVRawByteString;
begin
  Result := '';
  RSep := RVU_StringToRawByteString(TextRowSeparator, Unicode,
    TCustomRVData(RVData).GetRVStyle.DefCodePage);
  CSep := RVU_StringToRawByteString(TextColSeparator, Unicode,
    TCustomRVData(RVData).GetRVStyle.DefCodePage);
  Stream := TRVMemoryStream.Create;
  try
    for r := 0 to RowCount-1 do begin
      for c := 0 to ColCount-1 do begin
        if Cells[r,c]<>nil then
          Cells[r,c].GetRVData.SaveTextToStream(Path, Stream, LineWidth,  False,
            TextOnly, Unicode, False);
        if c<ColCount-1 then
          RVFWrite(Stream, CSep);
      end;
      if r<RowCount-1 then
        RVFWrite(Stream, RSep);
    end;
    Stream.Position := 0;
    SetLength(Result,Stream.Size);
    Stream.ReadBuffer(PRVAnsiChar(Result)^,Stream.Size);
  finally
    Stream.Free;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SaveTextSelection(Stream: TStream; RVData: TPersistent;
  LineWidth: Integer; const Path: String; TextOnly,Unicode: Boolean);
var r,c: Integer;
    RSep,CSep:TRVRawByteString;
    FirstCellInRow: Boolean;
begin
  RSep := RVU_StringToRawByteString(TextRowSeparator, Unicode,
    TCustomRVData(RVData).GetRVStyle.DefCodePage);
  CSep := RVU_StringToRawByteString(TextColSeparator, Unicode,
    TCustomRVData(RVData).GetRVStyle.DefCodePage);
  for r := 0 to RowCount-1 do begin
    FirstCellInRow := True;
    for c := 0 to ColCount-1 do
      if (Cells[r,c]<>nil) and IsCellSelected(r,c) then begin
        if not FirstCellInRow then
          RVFWrite(Stream, CSep);
        FirstCellInRow := False;
        Cells[r,c].GetRVData.SaveTextToStream(Path, Stream, LineWidth,  False,
            TextOnly, Unicode, False);
      end;
    if not FirstCellInRow then
      RVFWrite(Stream, RSep);
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.BeforeChange: Boolean;
begin
  Result := IsInEditor and
            TCustomRichViewEdit(TRVEditRVData(Rows.FMainRVData).RichView).BeforeChange(True);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.CanChange: Boolean;
begin
  Result := IsInEditor;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.CanChangeEx: Boolean;
begin
  Result := FRows.FMainRVData.GetAbsoluteRootData is TRVEditRVData;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCellBestHeight_(ItemNo: Integer;
  Value: TRVStyleLength; Row,Col: Integer);
begin
  SetCellIntProperty(ItemNo, 'BestHeight', LongInt(Value), Row, Col, True, False);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCellBestWidth_(ItemNo: Integer;
  Value: TRVHTMLLength; Row, Col: Integer);
begin
  SetCellIntProperty(ItemNo, 'BestWidth', LongInt(Value), Row, Col, True, True);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCellColor_(ItemNo: Integer; Value: TColor;
  Row, Col: Integer);
begin
  SetCellIntProperty(ItemNo, 'Color', LongInt(Value), Row, Col, False, False);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCellBackgroundStyle_(ItemNo: Integer;
  Value: TRVItemBackgroundStyle; Row,Col: Integer);
begin
  SetCellIntProperty(ItemNo, 'BackgroundStyle', LongInt(Value), Row, Col, False, False);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCellBackgroundImageFileName_(ItemNo: Integer;
  const Value: String; Row,Col: Integer);
begin
  SetCellStrProperty(ItemNo, 'BackgroundImageFileName', Value, Row, Col);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEITEMHINTS}
procedure TRVTableItemInfo.SetCellHint_(ItemNo: Integer; const Value: String;
  Row,Col: Integer);
begin
  SetCellStrProperty(ItemNo, 'Hint', Value, Row, Col);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCellVisibleBorders_(ItemNo: Integer; Left, Top, Right, Bottom: Boolean; Row,Col: Integer);
var ui: TRVUndoModifyVisibleBorders;
    Cell: TRVTableCellData;
begin
  Cell := Cells[Row, Col];
  if Cell.VisibleBorders.IsEqual2(Left,Top,Right,Bottom) then
    exit;
  if (rvtsInserted in FState) and IsInEditor then begin
    if ItemNo=-1 then
      ItemNo := GetMyItemNo;
    TRVEditRVData(FRows.FMainRVData).BeginUndoSequence(rvutModifyItem, True);
    ui := TRVUndoModifyVisibleBorders(AddTableUndoInfo(TRichViewRVData(FRows.FMainRVData), TRVUndoModifyVisibleBorders, ItemNo, False, False));
    if ui<>nil then begin
      ui.Row    := Row;
      ui.Col    := Col;
      ui.Left   := Cell.VisibleBorders.Left;
      ui.Top    := Cell.VisibleBorders.Top;
      ui.Right  := Cell.VisibleBorders.Right;
      ui.Bottom := Cell.VisibleBorders.Bottom;
    end;
  end;
  Cell.VisibleBorders.SetValues(Left,Top,Right,Bottom);
  Changed;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetTableVisibleBorders(Left, Top, Right, Bottom: Boolean);
var ui: TRVUndoModifyVisibleBorders;
    ItemNo: Integer;
begin
  if VisibleBorders.IsEqual2(Left,Top,Right,Bottom) then
    exit;
  if (rvtsInserted in FState) and IsInEditor then begin
    ItemNo := GetMyItemNo;
    TRVEditRVData(FRows.FMainRVData).BeginUndoSequence(rvutModifyItem, True);
    ui := TRVUndoModifyVisibleBorders(AddTableUndoInfo(TRichViewRVData(FRows.FMainRVData), TRVUndoModifyVisibleBorders, ItemNo, False, False));
    if ui<>nil then begin
      ui.Row    := -1;
      ui.Col    := -1;
      ui.Left   := VisibleBorders.Left;
      ui.Top    := VisibleBorders.Top;
      ui.Right  := VisibleBorders.Right;
      ui.Bottom := VisibleBorders.Bottom;
    end;
  end;
  VisibleBorders.SetValues(Left,Top,Right,Bottom);
  Changed;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCellBorderColor_(ItemNo: Integer; Value: TColor;
  Row, Col: Integer);
begin
  SetCellIntProperty(ItemNo, 'BorderColor', LongInt(Value), Row, Col, False, False);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCellBorderLightColor_(ItemNo: Integer; Value: TColor;
  Row, Col: Integer);
begin
  SetCellIntProperty(ItemNo, 'BorderLightColor', LongInt(Value), Row, Col, False, False);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCellVAlign_(ItemNo: Integer; Value: TRVCellVAlign; Row,Col: Integer);
begin
  SetCellIntProperty(ItemNo, 'VAlign', LongInt(Value), Row, Col, True, False);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetRowVAlign_(ItemNo: Integer;
  Value: TRVCellVAlign; Row: Integer);
var
    ui: TRVUndoRowVAlign;
begin
  if Rows[Row].VAlign<>Value then begin
    if (rvtsInserted in FState) and IsInEditor then begin
      MergeInplaceUndo(False);
      TRVEditRVData(FRows.FMainRVData).BeginUndoSequence(rvutModifyItem, True);
      if ItemNo=-1 then
        ItemNo := GetMyItemNo;
      ui := TRVUndoRowVAlign(AddTableUndoInfo(TRVEditRVData(FRows.FMainRVData), TRVUndoRowVAlign, ItemNo, True, False));
      if ui<>nil then begin
        ui.OldVAlign := Rows[Row].VAlign;
        ui.Row       := Row;
      end;
    end;
    Rows[Row].VAlign := Value;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCellBestHeight(Value: TRVStyleLength; Row,Col: Integer);
begin
  SetCellBestHeight_(-1, Value, Row, Col);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCellBestWidth(Value: TRVHTMLLength; Row,
  Col: Integer);
begin
  SetCellBestWidth_(-1, Value, Row, Col);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCellColor(Value: TColor; Row, Col: Integer);
begin
  SetCellColor_(-1, Value, Row, Col);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCellBackgroundStyle(Value: TRVItemBackgroundStyle; Row,Col: Integer);
begin
  SetCellBackgroundStyle_(-1, Value, Row, Col);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCellVisibleBorders(Left, Top, Right, Bottom: Boolean; Row,Col: Integer);
begin
  SetCellVisibleBorders_(-1, Left, Top, Right, Bottom, Row,Col);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCellBorderColor(Value: TColor; Row, Col: Integer);
begin
  SetCellBorderColor_(-1, Value, Row, Col);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCellBorderLightColor(Value: TColor; Row, Col: Integer);
begin
  SetCellBorderLightColor_(-1, Value, Row, Col);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCellVAlign(Value: TRVCellVAlign; Row,
  Col: Integer);
begin
  SetCellVAlign_(-1, Value, Row, Col);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetRowVAlign(Value: TRVCellVAlign; Row: Integer);
begin
  SetRowVAlign_(-1, Value, Row);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.DoneUndo;
begin
  if (rvtsInserted in FState) and (FRows.FMainRVData is TRVEditRVData) then
    TRVEditRVData(FRows.FMainRVData).SetUndoGroupMode(False);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.InitUndo;
begin
  if (rvtsInserted in FState) and (FRows.FMainRVData is TRVEditRVData) then begin
    TRVEditRVData(FRows.FMainRVData).BeginUndoSequence(rvutModifyItem, True);
    TRVEditRVData(FRows.FMainRVData).SetUndoGroupMode(True);
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetEditorItemNoForUndo: Integer;
begin
  if (rvtsInserted in FState) and IsInEditor and UndoEnabled then
    Result := GetMyItemNo
  else
    Result := -1;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.IsInEditor: Boolean;
begin
  Result := FRows.FMainRVData is TRVEditRVData;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetMyItemNo: Integer;
begin
  if (CachedItemNo<0) or (CachedItemNo>=FRows.FMainRVData.Items.Count) or
     (FRows.FMainRVData.GetItem(CachedItemNo)<>Self) then
    CachedItemNo := FRows.FMainRVData.GetItemNo(Self);
  Result := CachedItemNo;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.EditCell_(Row,Col: Integer; Unquestioning: Boolean);
var PRow,PCol: Integer;
    Ptable : TRVTableItemInfo;
begin
  if not (rvtsInserted in FState) then
    exit;
  if not (rvtsEditMode in FState) then begin
    if FRows.FMainRVData is TCustomRVFormattedData then
      TCustomRVFormattedData(FRows.FMainRVData).AssignChosenRVData(Cells[Row,Col], Self);
    exit;
  end;
  if not Unquestioning and not (rvtoEditing in Options) then
    exit;
  if FRows.FMainRVData is TRVTableCellData then begin
    Ptable := TRVTableCellData(FRows.FMainRVData).GetTable;
    Ptable.GetCellPosition(TRVTableCellData(FRows.FMainRVData), PRow, PCol);
    if PRow=-1 then
      ERichViewError.Create(errInternalError);
    Ptable.EditCell_(PRow, PCol, Unquestioning);
  end;
  if FRows.FMainRVData is TRVTableCellData then
    exit;
  CreateInplace(-1, Row, Col, False, True, False, False, Unquestioning);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.EditCell(Row, Col: Integer);
begin
  EditCell_(Row,Col,False);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.EnterItem(From: TRVEnterDirection; Coord: Integer): Boolean;
var r,c: Integer;
begin
  Result := False;
  if Rows.Empty or not (rvtoEditing in Options) then
    exit;
  case From of
    rvedLeft:
      begin
        CreateInplace(-1, 0, 0, False, True, False, False, False);
        Result := True;
      end;
    rvedRight:
      begin
        Rows.GetMainCell(RowCount-1, ColCount-1, r,c);
        CreateInplace(-1, r,c, False, False, True, False, False);
        Result := True;
      end;
    rvedTop:
      begin
        c := GetColNo(Coord);
        if c<0 then exit;
        Rows.GetMainCell(0,c, r,c);
        CreateInplace(-1, r,c, False, True, True, False, False);
        Result := True;
      end;
    rvedBottom:
      begin
        c := GetColNo(Coord);
        if c<0 then exit;
        Rows.GetMainCell(RowCount-1,c, r,c);
        CreateInplace(-1, r,c, False, False, True, False, False);
        Result := True;
      end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.BuildJumps(Left,Top: Integer; var StartJumpNo: Integer;
  jumps: TList);
var r,c, i, cnt: Integer;
    CellHPaddingPix, CellVPaddingPix: Integer;
begin
  CellHPaddingPix := GetRVStyle.GetAsPixels(CellHPadding);
  CellVPaddingPix := GetRVStyle.GetAsPixels(CellVPadding);
  for r := 0 to RowCount-1 do
    for c := 0 to ColCount-1 do
      if Cells[r,c]<>nil then begin
        cnt := jumps.Count;
        Cells[r,c].FirstJumpNo := FRows.FMainRVData.FirstJumpNo ;//StartJumpNo;
        if (FInplaceEditor<>nil) and (TRVTableInplaceEdit(FInplaceEditor).FCell=Cells[r,c]) then begin
          FInplaceEditor.FirstJumpNo := StartJumpNo+FRows.FMainRVData.FirstJumpNo;
          StartJumpNo := FInplaceEditor.FirstJumpNo+TRVTableInplaceRVData(TRVTableInplaceEdit(FInplaceEditor).RVData).ReallyBuildJumpsCoords-FRows.FMainRVData.FirstJumpNo;
          end
        else begin
          Cells[r,c].BuildJumpsCoords(StartJumpNo, jumps);
          for i := cnt to jumps.Count-1 do
            with TRVJumpInfo(jumps.Items[i]) do begin
              inc(l, Left+Cells[r,c].Left+CellHPaddingPix);
              inc(t, Top+Cells[r,c].Top+CellVPaddingPix+Cells[r,c].GetExtraVOffs);
            end;
        end;
      end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.Changed;
begin
  Include(FState, rvtsModified);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.ValidateFocused;
begin
  if (FocusedCellRow<0) or (FocusedCellRow>=RowCount) or
     (FocusedCellCol<0) or (FocusedCellCol>=ColCount) then begin
    FocusedCellRow := -1;
    FocusedCellCol := -1;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.ValidateChosen;
begin
  if (ChosenCellRow<0) or (ChosenCellRow>=RowCount) or
     (ChosenCellCol<0) or (ChosenCellCol>=ColCount) then begin
    ChosenCellRow := -1;
    ChosenCellCol := -1;
  end;
  if (ChosenCellRow<>-1) and (ChosenCellCol<>-1) then
    Rows.GetMainCell(ChosenCellRow, ChosenCellCol, ChosenCellRow, ChosenCellCol);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.MoveFocus(GoForward: Boolean;
                                    var TopLevelRVData: TPersistent;
                                    var TopLevelItemNo: Integer): Boolean;
var Cell: TCustomRVFormattedData;
    Dir: TRVCellDirection;
begin
  ValidateFocused;
  Result := False;
  if (FocusedCellRow=-1) then
  if GoForward then begin
    FocusedCellRow := 0;
    FocusedCellCol := 0;
    end
  else
    Rows.GetMainCell(RowCount-1, ColCount-1,FocusedCellRow,FocusedCellCol);
  if GoForward then
    Dir := rvcdNext
  else
    Dir := rvcdPrev;
  while True do begin
    Cell := Cells[FocusedCellRow,FocusedCellCol];
    Cell.FocusedItemNo := Cell.GetNextFocusedItem(Cell.FocusedItemNo, GoForward, TCustomRVFormattedData(TopLevelRVData), TopLevelItemNo);
    if Cell.FocusedItemNo<>-1 then begin
      Result := True;
      exit;
    end;
    if not GetCellTo(FocusedCellRow, FocusedCellCol, Dir, FocusedCellRow,
      FocusedCellCol, True, False) then begin
      FocusedCellRow := -1;
      FocusedCellCol := -1;
      exit;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.ClearFocus;
begin
  ValidateFocused;
  if (FocusedCellRow<>-1) then begin
    Cells[FocusedCellRow,FocusedCellCol].ClearFocus;
    FocusedCellRow := -1;
    FocusedCellCol := -1;
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.CellIsChosen: Boolean;
begin
  Result := False;
  ValidateChosen;
  if ChosenCellRow=-1 then
    exit;
  Result := Cells[ChosenCellRow,ChosenCellCol].SelectionExists(False,True);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.GetCellPosition(Cell: TRVTableCellData; var Row,
  Col: Integer);
var r: Integer;
begin
  Row := -1;
  Col := -1;
  for r := 0 to RowCount-1 do begin
    Col := Rows[r].IndexOf(Cell);
    if Col<>-1 then begin
      Row := r;
      exit;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.AdjustFocus(Row, Col: Integer;
  TopLevelRVData: TPersistent; TopLevelItemNo: Integer);
begin
  FocusedCellRow := Row;
  FocusedCellCol := Col;
  TCustomRVFormattedData(FRows.FMainRVData).AdjustFocus(GetMyItemNo,TopLevelRVData,TopLevelItemNo);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.AdjustFocusToControl(Control: TControl;
  var TopLevelRVData: TPersistent; var TopLevelItemNo: Integer): Boolean;
var r,c,ItemNo: Integer;
    item: TCustomRVItemInfo;
begin
  Result := GetCellWhichOwnsControl(Control, r, c, ItemNo);
  if Result then begin
    FocusedCellRow := r;
    FocusedCellCol := c;
    Cells[r,c].FocusedItemNo := ItemNo;
    item := Cells[r,c].GetItem(ItemNo);
    item.AdjustFocusToControl(Control,TopLevelRVData,TopLevelItemNo);
    if item.GetBoolValue(rvbpImmediateControlOwner) then begin
      TopLevelItemNo := ItemNo;
      TopLevelRVData := Cells[r,c];
    end;
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.UndoEnabled: Boolean;
begin

  Result := (rvtsInserted in FState) and
            (Rows.FMainRVData.GetRootData is TRVEditRVData) and
            (TCustomRichViewEdit(TRVEditRVData(Rows.FMainRVData.GetRootData).RichView).UndoLimit<>0);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.MarkStylesInUse(Data: TRVDeleteUnusedStylesData);
var r,c: Integer;
begin
  inherited MarkStylesInUse(Data);
  for r := 0 to RowCount-1 do
    for c := 0 to ColCount-1 do
      if Cells[r,c]<>nil then
        Cells[r,c].GetRVData.DoMarkStylesInUse(Data);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.UpdateStyles(Data: TRVDeleteUnusedStylesData);
var r,c: Integer;
begin
  inherited UpdateStyles(Data);
  for r := 0 to RowCount-1 do
    for c := 0 to ColCount-1 do
      if Cells[r,c]<>nil then
        Cells[r,c].GetRVData.DoUpdateStyles(Data);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.CompletelySelected: Boolean;
var SN,EN,SO,EO,No: Integer;
begin
  Result := Rows.FMainRVData is TCustomRVFormattedData;
  if not Result then
    exit;
  if rvstCompletelySelected in Rows.FMainRVData.State then
    exit;
  TCustomRVFormattedData(Rows.FMainRVData).GetSelectionBounds(SN,SO,EN,EO,True);
  Result := (SN>=0) and (EN>=0);
  if not Result then
    exit;
  No := GetMyItemNo;
  Result := ((No>SN) or ((No=SN) and (SO=0))) and
            ((No<EN) or ((No=EN) and (EO=1)));
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetSubRVDataAt(X, Y: Integer; ReturnClosest: Boolean): TPersistent;
var Row, Col: Integer;
begin
  if GetCellAt(X, Y, Row, Col, ReturnClosest) then
    Result := Cells[Row,Col].GetRVData
  else
    Result := nil;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.UnAssignActiveCell;
begin
  ValidateChosen;
  if (ChosenCellRow<>-1) and (ChosenCellCol<>-1) and
     (Rows.FMainRVData is TCustomRVFormattedData) then
    TCustomRVFormattedData(Rows.FMainRVData).UnassignChosenRVData(Cells[ChosenCellRow,ChosenCellCol]);
  ChosenCellRow := -1;
  ChosenCellCol := -1;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.CleanUpChosen;
begin
  ValidateChosen;
  if ChosenCellRow<>-1 then
    TCustomRVFormattedData(Cells[ChosenCellRow,ChosenCellCol].GetRVData).Deselect(nil,False);
  ChosenCellRow := -1;
  ChosenCellCol := -1;
  DestroyInplace(True);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetSubRVData(var StoreState: TRVStoreSubRVData;
  Position: TRVSubRVDataPos): TPersistent;
var r,c,cs,rs: Integer;
    Dir: TRVCellDirection;
begin
  Result := nil;
  case Position of
    rvdFirst:
      begin
        if (ColCount=0) or (RowCount=0) then
          exit;
        StoreState := TRVTableStoreSubRVData.Create(0,0);
        Result := Cells[0,0];
      end;
    rvdLast:
      begin
        if (ColCount=0) or (RowCount=0) then
          exit;      
        r := RowCount-1;
        c := ColCount-1;
        if Cells[r,c]<>nil then begin
          StoreState := TRVTableStoreSubRVData.Create(r,c);
          Result := Cells[r,c];
          end
        else if GetCellTo(r,c, rvcdPrev, r, c, True, False) then begin
          StoreState := TRVTableStoreSubRVData.Create(r,c);
          Result := Cells[r,c];
        end;
      end;
    rvdChosenUp,rvdChosenDown:
      begin
        StoreState := nil;
        if GetNormalizedSelectionBounds(True,r,c,cs,rs) then begin
          if Position=rvdChosenUp then begin
            inc(r,rs-1);
            inc(c,cs-1);
          end;
          Result := FRows.GetMainCell(r,c,r,c);
          StoreState := TRVTableStoreSubRVData.Create(r,c);
          end
        else begin
          ValidateChosen;
          if ChosenCellRow<>-1 then begin
            StoreState := TRVTableStoreSubRVData.Create(ChosenCellRow,ChosenCellCol);
            Result := Cells[ChosenCellRow,ChosenCellCol];
          end;
        end;
      end;
    rvdNext, rvdPrev:
      begin
        if Position=rvdNext then
          Dir := rvcdNext
        else
          Dir := rvcdPrev;
        r := TRVTableStoreSubRVData(StoreState).Row;
        c := TRVTableStoreSubRVData(StoreState).Col;
        if GetCellTo(r,c, Dir, r, c, True, False) then begin
          TRVTableStoreSubRVData(StoreState).Row := r;
          TRVTableStoreSubRVData(StoreState).Col := c;
          Result := Cells[r,c];
        end;
      end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.ChooseSubRVData_(r, c: Integer);
var no, no1,no2,off1,off2: Integer;
begin
  if (ChosenCellRow=r) and (ChosenCellCol=c) then
    exit;
  TCustomRVFormattedData(Cells[r,c].GetRVData).GetSelectionBounds(no1,off1,no2,off2,False);
  no := GetMyItemNo;
  TCustomRVFormattedData(FRows.FMainRVData).SetSelectionBounds(no,1,no,1);
  (FRows.FMainRVData as TCustomRVFormattedData).AssignChosenRVData(Cells[r,c], Self);
  ChosenCellRow := r;
  ChosenCellCol := c;
  if (rvtsEditMode in FState) and (rvtsInserted in FState) then
    EditCell(ChosenCellRow,ChosenCellCol);
  TCustomRVFormattedData(Cells[r,c].GetRVData).SetSelectionBounds(no1,off1,no2,off2);
  TCustomRVFormattedData(Cells[r,c].GetRVData).Invalidate;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.ChooseSubRVData(StoreState: TRVStoreSubRVData);
begin
  ChooseSubRVData_(TRVTableStoreSubRVData(StoreState).Row,
                   TRVTableStoreSubRVData(StoreState).Col);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.ResetSubCoords;
begin
  if FRows.FMainRVData is TCustomRVFormattedData then
    TCustomRVFormattedData(FRows.FMainRVData).GetItemClientCoords(GetMyItemNo,
      MyClientLeft, MyClientTop);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetSoftPageBreakDY(Data: Integer): Integer;
begin
  if Data>=Fmt.RowStarts.Count then
    Result := Fmt.FHeight
  else
    Result := Fmt.RowStarts[Data];
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.ClearSoftPageBreaks;
var r,c: Integer;
begin
  for r := 0 to RowCount-1 do
    for c := 0 to ColCount-1 do
      if Cells[r,c]<>nil then
        Cells[r,c].ClearSoftPageBreaks;
end;
{------------------------------------------------------------------------------}
const MAXINPLACESIZE = 10000;
procedure TRVTableItemInfo.SetInplaceBounds(Left, Top, Width,
  Height: Integer);
begin
  if not Assigned(TRVTableInplaceEdit(FInplaceEditor).OnGetFormatCanvas) then begin
    TRVTableInplaceEdit(FInplaceEditor).NormalScrolling := Height>MAXINPLACESIZE;
    TRVTableInplaceEdit(FInplaceEditor).FullRedraw := TRVTableInplaceEdit(FInplaceEditor).NormalScrolling;
    if Height>MAXINPLACESIZE then
      Height := MAXINPLACESIZE;
  end;
  FInplaceEditor.SetBounds(Left, Top, Width, Height);
  if rvtsFormatInplace in FState then begin
    FInplaceEditor.RVData.TextWidth := -1;
    FInplaceEditor.RVData.DocumentWidth := -1;
    FInplaceEditor.RVData.Format_(True,False,True,0,FInplaceEditor.GetFormatCanvas(FInplaceEditor.Canvas),
      False,False,False,False{!});
  end;
  if (FInplaceEditor.RVData.DocumentHeight>0) and
     (Height<FInplaceEditor.RVData.DocumentHeight) then
    TRVTableInplaceEdit(FInplaceEditor).NormalScrolling := True;
  Exclude(FState, rvtsFormatInplace);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.CanUseHeadingRowCount: Boolean;
var c,hrc, mr, mc: Integer;
    cell: TRVTableCellData;
begin
  Result := False;
  hrc := HeadingRowCount;
  if hrc>RowCount then
    hrc := RowCount;
  if hrc=0 then
    exit;
  for c := 0 to ColCount-1 do begin
    cell := Rows.GetMainCell(hrc-1,c,mr,mc);
    if mr+cell.RowSpan>hrc then
      exit;
  end;
  Result := True;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetBackgroundImage: TGraphic;
begin
  if FBackground<>nil then
    Result := FBackground.Image
  else
    Result := nil;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetBackgroundImage_(const Value: TGraphic; Copy: Boolean);
begin
  if Value=BackgroundImage then
    exit;
  if (FBackground=nil) and (Value<>nil) and not Value.Empty then
    FBackground := TRVBackground.Create(False);
  if FBackground<>nil then begin
    FBackground.AssignImage(Value, Rows.FMainRVData, Copy);
    if FBackground.Empty then begin
      FBackground.Free;
      FBackground := nil;
    end
  end;
  if FInplaceEditor<>nil then
    FInplaceEditor.Invalidate;
  {$IFNDEF RVDONOTUSEANIMATION}
  if Rows.FMainRVData is TCustomRVFormattedData then
    TCustomRVFormattedData(Rows.FMainRVData).ResetAniBackground;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetBackgroundImage(const Value: TGraphic);
var ui: TRVUndoModifyBackgroundImage;
begin
  if Value=BackgroundImage then
    exit;
  if (rvtsInserted in FState) and IsInEditor then begin
    MergeInplaceUndo(False);
    TRVEditRVData(FRows.FMainRVData).BeginUndoSequence(rvutModifyItem, True);
    ui := TRVUndoModifyBackgroundImage(
             AddTableUndoInfo(TRVEditRVData(FRows.FMainRVData), TRVUndoModifyBackgroundImage,
             GetMyItemNo, False, False));
    if ui<>nil then begin
      ui.Row := -1;
      ui.Col := -1;
      ui.Image := GetBackgroundImage;
      SetBackgroundImage_(nil, False);
    end;
  end;
  SetBackgroundImage_(Value, True);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetVisibleBorders(const Value: TRVBooleanRect);
begin
  FVisibleBorders.Assign(Value);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.StoreVisibleBorders: Boolean;
begin
  Result := not FVisibleBorders.IsAllEqual(True);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCellBackgroundImage(Value: TGraphic; Row,Col: Integer);
var ui: TRVUndoModifyBackgroundImage;
    Cell: TRVTableCellData;
begin
  Cell := Cells[Row,Col];
  if Value=Cell.BackgroundImage then
    exit;
  if (rvtsInserted in FState) and IsInEditor then begin
    MergeInplaceUndo(False);
    TRVEditRVData(FRows.FMainRVData).BeginUndoSequence(rvutModifyItem, True);
    ui := TRVUndoModifyBackgroundImage(
             AddTableUndoInfo(TRVEditRVData(FRows.FMainRVData), TRVUndoModifyBackgroundImage,
             GetMyItemNo, False, False));
    if ui<>nil then begin
      ui.Row := Row;
      ui.Col := Col;
      ui.Image := Cell.GetBackgroundImage;
      Cell.SetBackgroundImage_(nil, False);
    end;
  end;
  Cell.SetBackgroundImage_(Value, True);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetCellBackgroundImageFileName(const Value: String;
  Row,Col: Integer);
begin
  SetCellBackgroundImageFileName_(-1, Value, Row,Col);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEITEMHINTS}
procedure TRVTableItemInfo.SetCellHint(const Value: String; Row,Col: Integer);
begin
  SetCellHint_(-1, Value, Row,Col);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetBackgroundStyle: TRVItemBackgroundStyle;
begin
  if FBackground<>nil then
    Result := FBackground.ItemBackStyle
  else
    Result := rvbsColor;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SetBackgroundStyle(
  const Value: TRVItemBackgroundStyle);
begin
  if Value=BackgroundStyle then
    exit;
  if rvtsInserted in FState then begin
    SetIntProperty('BackgroundStyle', ord(Value), False, False);
    exit;
  end;
  if (FBackground=nil) and (Value<>rvbsColor) then
    FBackground := TRVBackground.Create(False);
  if FBackground<>nil then begin
    FBackground.ItemBackStyle := Value;
    if FBackground.Empty then begin
      FBackground.Free;
      FBackground := nil;
    end
  end;
  if FInplaceEditor<>nil then
    FInplaceEditor.Invalidate;
  {$IFNDEF RVDONOTUSEANIMATION}
  if Rows.FMainRVData is TCustomRVFormattedData then
    TCustomRVFormattedData(Rows.FMainRVData).ResetAniBackground;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetRVFExtraPropertyCount: Integer;
begin
  Result := inherited GetRVFExtraPropertyCount;
  if BackgroundImageFileName<>'' then
    inc(Result);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.SaveRVFExtraProperties(Stream: TStream);
begin
  inherited SaveRVFExtraProperties(Stream);
  if BackgroundImageFileName<>'' then
    WriteRVFExtraStrPropertyStr(Stream, rvespImageFileName, BackgroundImageFileName);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetExtraStrProperty(
  Prop: TRVExtraItemStrProperty; var Value: String): Boolean;
begin
  case Prop of
    rvespImageFileName:
      begin
        Value := BackgroundImageFileName;
        Result := True;
      end;
    else
      Result := inherited GetExtraStrProperty(Prop, Value);
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.SetExtraStrProperty(
  Prop: TRVExtraItemStrProperty; const Value: String): Boolean;
begin
  case Prop of
    rvespImageFileName:
      begin
        BackgroundImageFileName := Value;
        Result := True;
      end;
    else
      Result := inherited SetExtraStrProperty(Prop, Value);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.KeyDown(Key: Word; Shift: Boolean);
begin
  if not (rvtsSelExists in State)  or
     not (rvoAllowSelection in Rows.FMainRVData.Options) or
     (rvtoNoCellSelect in Options) then
    exit;
  case Key of
    VK_RIGHT:
      begin
        if FSelStartCol+FSelColOffs>=ColCount-1 then
          exit;
        inc(FSelColOffs);
      end;
    VK_LEFT:
      begin
        if FSelStartCol+FSelColOffs<=0 then
          exit;
        dec(FSelColOffs);
      end;
    VK_DOWN:
      begin
        if FSelStartRow+FSelRowOffs>=RowCount-1 then
          exit;
        inc(FSelRowOffs);
      end;
    VK_UP:
      begin
        if FSelStartRow+FSelRowOffs<=0 then
          exit;
        dec(FSelRowOffs);
      end;
  end;
  if (FSelColOffs<>0) or (FSelRowOffs<>0) then
    Include(FState, rvtsSelExists)
  else if FStoredInplace.Stored then
    Exclude(FState, rvtsSelExists);
  UpdateCellSel;
  TCustomRVFormattedData(Rows.FMainRVData).Invalidate;
  if not (rvtsSelExists in FState) then begin
    RestoreInplace;
    FStoredInplace.Stored := False;
  end;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.GetItemNoInRootDocument: Integer;
var RVData: TCustomRVData;
    Location: TRVStoreSubRVData;
    ParentItemNo: Integer;
begin
  RVData := Rows.FMainRVData;
  ParentItemNo := GetMyItemNo;
  Result := ParentItemNo;
  repeat
    RVData.GetParentInfo(ParentItemNo, Location);
    Location.Free;
    if ParentItemNo>=0 then begin
      Result := ParentItemNo;
      RVData := RVData.GetAbsoluteParentData;
    end;
  until ParentItemNo<0;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.AssignProperties(Source: TRVTableItemInfo);
begin
  Options := Source.Options;
  PrintOptions := Source.PrintOptions;
  BestWidth := Source.BestWidth;
  Color := Source.Color;
  BackgroundImage := Source.BackgroundImage;
  BackgroundStyle := Source.BackgroundStyle;
  BackgroundImageFileName := Source.BackgroundImageFileName;
  HeadingRowCount := Source.HeadingRowCount;
  TextRowSeparator := Source.TextRowSeparator;
  TextColSeparator := Source.TextColSeparator;
  BorderWidth := Source.BorderWidth;
  BorderColor := Source.BorderColor;
  BorderLightColor := Source.BorderLightColor;
  BorderStyle := Source.BorderStyle;
  BorderVSpacing := Source.BorderVSpacing;
  BorderHSpacing := Source.BorderHSpacing;
  CellBorderWidth := Source.CellBorderWidth;
  CellBorderColor := Source.CellBorderColor;
  CellBorderLightColor := Source.CellBorderLightColor;
  CellHPadding := Source.CellHPadding;
  CellVPadding := Source.CellVPadding;
  CellBorderStyle := Source.CellBorderStyle;
  VRuleWidth := Source.VRuleWidth;
  VRuleColor := Source.VRuleColor;
  HRuleWidth := Source.HRuleWidth;
  HRuleColor := Source.HRuleColor;
  CellVSpacing := Source.CellVSpacing;
  CellHSpacing := Source.CellHSpacing;
  VOutermostRule := Source.VOutermostRule;
  HOutermostRule := Source.HOutermostRule;
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.ResetLiveSpell;
begin
  {$IFNDEF RVDONOTUSELIVESPELL}
  if GetMyItemNo>=0 then
    TCustomRichView(Rows.FMainRVData.GetAbsoluteRootData.GetParentControl).
      LaterSetBackLiveSpellingTo(Rows.FMainRVData.GetSourceRVData, GetMyItemNo, 0);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.RowsHavePageBreaksBefore(StartRow, EndRow: Integer): Boolean;
var r: Integer;
begin
  Result := False;
  if StartRow<0 then
    StartRow := HeadingRowCount+1;
  if EndRow<0 then
    EndRow := RowCount-1;
  for r := StartRow to EndRow do
    if Rows[r].PageBreakBefore then begin
      Result := True;
      exit;
    end;
end;
{------------------------------------------------------------------------------}
{ Returns a number of columns }
function TRVTableItemInfo.GetColCount: Integer;
begin
  if Rows.Count<>0 then
    Result := Rows[0].Count
  else
    Result := 0
end;
{------------------------------------------------------------------------------}
{ Returns a number of rows }
function TRVTableItemInfo.GetRowCount: Integer;
begin
  Result := Rows.Count;
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.StoreCellPadding: Boolean;
begin
  Result := (CellHPadding=CellVPadding) and (CellHPadding<>1);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.StoreCellHPadding: Boolean;
begin
  Result := (CellHPadding<>CellVPadding) and (CellHPadding<>1);
end;
{------------------------------------------------------------------------------}
function TRVTableItemInfo.StoreCellVPadding: Boolean;
begin
  Result := (CellHPadding<>CellVPadding) and (CellVPadding<>1);
end;
{------------------------------------------------------------------------------}
procedure TRVTableItemInfo.ConvertToDifferentUnits(NewUnits: TRVStyleUnits;
  RVStyle: TRVStyle; Recursive: Boolean);
var r,c: Integer;
    Inserted: Boolean;
begin
  inherited;
  for r := 0 to RowCount-1 do
    for c := 0 to ColCount-1 do
      if Cells[r,c]<>nil then
        Cells[r,c].ConvertToDifferentUnits(NewUnits, RVStyle, Recursive);
  Inserted := rvtsInserted in FState;
  FState := FState - [rvtsInserted];
  try
    BorderWidth     := RVStyle.GetAsDifferentUnits(BorderWidth, NewUnits);
    BorderVSpacing  := RVStyle.GetAsDifferentUnits(BorderVSpacing, NewUnits);
    BorderHSpacing  := RVStyle.GetAsDifferentUnits(BorderHSpacing, NewUnits);
    CellBorderWidth := RVStyle.GetAsDifferentUnits(CellBorderWidth, NewUnits);
    CellHPadding    := RVStyle.GetAsDifferentUnits(CellHPadding, NewUnits);
    CellVPadding    := RVStyle.GetAsDifferentUnits(CellVPadding, NewUnits);
    VRuleWidth      := RVStyle.GetAsDifferentUnits(VRuleWidth, NewUnits);
    HRuleWidth      := RVStyle.GetAsDifferentUnits(HRuleWidth, NewUnits);
    CellVSpacing    := RVStyle.GetAsDifferentUnits(CellVSpacing, NewUnits);
    CellHSpacing    := RVStyle.GetAsDifferentUnits(CellHSpacing, NewUnits);
    if BestWidth>0 then
      BestWidth     := RVStyle.GetAsDifferentUnits(BestWidth, NewUnits);
  finally
    if Inserted then
      FState := FState + [rvtsInserted];
  end;
end;

initialization
  RegisterRichViewItemClass(rvsTable, TRVTableItemInfo);

end.
