unit PageComp;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, SbsScrll, GlobType, SBSList;

const
  msgidx_Position = 0;
  msgidx_ControlInfo = 1;
  msgidx_ApplHints = 1;

type
  TSBSPaperSize = class;
  TSBSPaperGrid = class;
  TSBSPaperBmp = class;
  TSBSSepBar = class;
  TSBSPage = class;
  TSBSController = class;

  TFormDetails = class(TPersistent)
  private
    FController   : TSBSController;
    fhFormType    : fdFormTypeType;       { Type: Form, Label, Report }
    fhFormDescr   : fhNameType;           { Name/Description }
    fhFormPath    : String;               { Path for detail file }
    fhContinue    : PathType;             { Path for continuation file }
    fhPaperWidth  : Word;
    fhPaperHeight : Word;
    fhTopWaste    : Word;
    fhLeftWaste   : Word;
    fhRightWaste  : Word;
    fhBottomWaste : Word;
    fhSections    : TPageStructureSet;
    fhOrientation : fdOrientationType;
    fhCopies      : Byte;
    fhDefaultFont : TFont;
    fhHeaderSep   : Word;
    fhBodyHeadSep : Word;
    fhBodySep     : Word;
    fhBodyFootSep : Word;
    Loading       : Boolean;              { True if properties are being loaded through regrec or hedrec }
    SVStrs        : Array [1..10] Of String30;
    fhSerNo       : Byte;
    fhSerNoWidth  : Word;
    fhShowInpSNo  : Boolean;
    fhPrinter     : ShortString;
    fhBinId       : LongInt;
    fhPaperId     : LongInt;

    { Label dimension and layout. Added 18/02/97 MH }
    fhLbTop       : Word;  { top of label 1 }
    fhLbLeft      : Word;  { left of label 1 }
    fhLbWidth     : Word;  { label width }
    fhLbHeight    : Word;  { label height }
    fhLbCols      : Byte;  { labels across }
    fhLbRows      : Byte;  { labels down }
    fhLbColGap    : Word;  { Horizontal gap between labels }
    fhLbRowGap    : Word;  { Vertical gap between labels }
    fhPurpose     : Byte;  { Use for Form/Label }

    // HM v4.32 06/02/01: Added support for printing hidden ADJ lines
    fhPrintAdjBom : Byte;

    // HM v4.32 -6/02/01: Added support for sorting normal documents
    fhDocSortMode : Byte;

    // HM 28/08/03: Extended Serial no support and added Multi-Bin Support
    fhShowBins    : Boolean;
    fhShowUseBy   : Boolean;

    // HM 03/11/03 v5.52: Added flag to sort Picking Lists in StockCode+BinPriority order
    fhStockOrder  : Boolean;

    // HM 14/01/04: v5.60 Added flag to control whether Additional Description Lines are shown on Picking Lists
    fhShowAddDesc : Boolean;

    // MH 18/04/06: IAO/v5.71 - Added a flag to suppress the updating of the Debt Chase Letter information on Transactions
    fhSuppressDL  : Boolean;

    // MH 04/09/06: IAO/v5.71 - Added additional flags for picking lists
    fhShowDescOnly: Boolean;  // Include non-stock/description only lines in single picking lists
    fhInclNewLines: Boolean;  // Include TL's with 0 Picking Run Number

    // MH 13/03/09: v6.01 - Added additional additional flags for picking lists
    fhExplodeBoMs : Boolean; // Explode Hidden Bill of Materials Line into Picking Lists
  protected
    Procedure SetFormType(Value : fdFormTypeType);
    Procedure SetPaperHeight(Value : Word);
    Procedure SetPaperWidth(Value : Word);
    Procedure SetTopMargin(Value : Word);
    Procedure SetBottomMargin(Value : Word);
    Procedure SetLeftMargin(Value : Word);
    Procedure SetRightMargin(Value : Word);
    Procedure SetSections(Value : TPageStructureSet);
    Procedure SetDefaultFont(Value : TFont);
    Procedure SetHeaderSep(Value : Word);
    Procedure SetBodyHeadSep(Value : Word);
    Procedure SetBodySep(Value : Word);
    Procedure SetBodyFootSep(Value : Word);
    Procedure SetOrientation(Value : fdOrientationType);
    Procedure SetDefPrinter(Value : ShortString);
    Procedure SetBinId(Value : LongInt);
    Procedure SetPaperId(Value : LongInt);

    Procedure SetLbTop(Value : Word);
    Procedure SetLbLeft(Value : Word);
    Procedure SetLbWidth(Value : Word);
    Procedure SetLbHeight(Value : Word);
    Procedure SetLbCols(Value : Byte);
    Procedure SetLbRows(Value : Byte);
    Procedure SetLbColGap(Value : Word);
    Procedure SetLbRowGap(Value : Word);
    Procedure SetPurpose(Value : Byte);

    Procedure RecalcLabelMargins;
  public
    ChangesMade : Boolean;

    constructor Create(AControl: TSBSController);
    destructor Destroy; Override;

    Procedure InitDefaultForm;
    Procedure InitDefaultLabel;
    Function GetWorkingHeight : LongInt;
    Function GetWorkingWidth : LongInt;
    Procedure ResetSections;
    Function ValidateName : Boolean;
    Function ValidatePath : Boolean;
    Function GetRepClass (TheControl : TControl) : fdRepClassType;

    Procedure StrRecToDetails (Const StrRec : fdFormStringsType);
    Procedure DetailsToStrRec (Var StrRec : fdFormStringsType);
    Procedure HedRecToDetails (Const HedRec : fdHeaderRecType);
    Procedure DetailsToHedRec (Var HedRec : fdHeaderRecType);
  published
    Property ftFormType : fdFormTypeType read fhFormType write SetFormType;
    Property ftFormDescr : fhNameType read fhFormDescr write fhFormDescr;
    Property ftFormPath : String read fhFormPath write fhFormPath;
    Property ftContinue : PathType read fhContinue write fhContinue;
    Property ftPaperWidth  : Word read fhPaperWidth write SetPaperWidth;
    Property ftPaperHeight : Word read fhPaperHeight write SetPaperHeight;
    Property ftTopMargin : Word read fhTopWaste write SetTopMargin;
    Property ftLeftMargin   : Word read fhLeftWaste write SetLeftMargin;
    Property ftRightMargin  : Word read fhRightWaste write SetRightMargin;
    Property ftBottomMargin : Word read fhBottomWaste write SetBottomMargin;
    Property ftSections    : TPageStructureSet read fhSections write SetSections;
    Property ftOrientation : fdOrientationType read fhOrientation write SetOrientation;
    Property ftCopies      : Byte read fhCopies write fhCopies;
    Property ftDefaultFont : TFont read fhDefaultFont write SetDefaultFont;
    Property ftHeaderSep   : Word read fhHeaderSep write SetHeaderSep;
    Property ftBodyHeadSep : Word read fhBodyHeadSep write SetBodyHeadSep;
    Property ftBodySep     : Word read fhBodySep write SetBodySep;
    Property ftBodyFootSep : Word read fhBodyFootSep write SetBodyFootSep;
    Property ftPrinter     : ShortString read fhPrinter write SetDefPrinter;
    Property ftBinId       : LongInt read fhBinId write SetBinId;
    Property ftPaperId     : LongInt read fhPaperId write SetPaperId;

    Property ftLbTop       : Word read fhLbTop write SetLbTop;
    Property ftLbLeft      : Word read fhLbLeft write SetLbLeft;
    Property ftLbWidth     : Word read fhLbWidth write SetLbWidth;
    Property ftLbHeight    : Word read fhLbHeight write SetLbHeight;
    Property ftLbCols      : Byte read fhLbCols write SetLbCols;
    Property ftLbRows      : Byte read fhLbRows write SetLbRows;
    Property ftLbColGap    : Word read fhLbColGap write SetLbColGap;
    Property ftLbRowGap    : Word read fhLbRowGap write SetLbRowGap;
    Property ftPurpose     : Byte read fhPurpose write SetPurpose;

  End; { TFormDetails }

  TSBSControlType = (ctText,    ctBitmap,  ctBox,       ctLine,
                     ctDbField, ctDbTable, ctDbFormula, ctPage,
                     ctGroup);

  TSBSController = class(TComponent)
  private
    { Private declarations }
    FFormDetails   : TFormDetails;

    FPaper         : TSBSPaperSize;
    FGrid          : TSBSPaperGrid;
    FPage          : TSBSPage;

    FTextMenu      : TPopupMenu;
    FBitmapMenu    : TPopupMenu;
    FBoxMenu       : TPopupMenu;
    FLineMenu      : TPopupMenu;
    FDbFieldMenu   : TPopupMenu;
    FDbTableMenu   : TPopupMenu;
    FDbFormulaMenu : TPopupMenu;
    FPageNoMenu    : TPopupMenu;
    FGroupMenu     : TPopupMenu;

    FOnTextOptions    : TNotifyEvent;
    FOnBitmapOptions  : TNotifyEvent;
    FOnBoxOptions     : TNotifyEvent;
    FOnLineOptions    : TNotifyEvent;
    FOnFieldOptions   : TNotifyEvent;
    FOnTableOptions   : TNotifyEvent;
    FOnFormulaOptions : TNotifyEvent;
    FOnPageNoOptions  : TNotifyEvent;
    FOnGroupOptions   : TNotifyEvent;
    FOnIf             : TIfLabelEvent;
    FOnZOrder         : TNotifyEvent;

    FTextHelpCntxt    : THelpContext;
    FBitmapHelpCntxt  : THelpContext;
    FBoxHelpCntxt     : THelpContext;
    FLineHelpCntxt    : THelpContext;
    FFieldHelpCntxt   : THelpContext;
    FTableHelpCntxt   : THelpContext;
    FFormulaHelpCntxt : THelpContext;
    FPageNoCntxt      : THelpContext;
    FGroupHelpCntxt   : THelpContext;

    LastTable         : TControl;   { Last table control added }

    procedure SetPaper(Value: TSBSPaperSize);
    procedure SetGrid(Value: TSBSPaperGrid);
    Function  FindControlId (Const FindId : String10) : Boolean;
    Procedure SetControlId (Var   Control : TControl;
                            Const Prefix  : String10);
  protected
  public
    { Public declarations }
    CurrControl : TControl;
    ControlList : TSBSList;
    HistoryList : TSBSList;
    SelectList  : TSBSList;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Assign(Source: TPersistent);

    Procedure ClearControlList;
    Procedure ClearHistoryList;
    Procedure ClearSelectList;

    Function IsSelected (Const TheControl : TControl) : Boolean;

    Procedure SetCurrControl (Sender: TControl);
    Procedure DeleteControl (Sender: TControl);
    Procedure DeleteSelected;
    Procedure DeallocateControl (Sender: TControl);

    procedure NewControlPos (TheControl : TControl);
    procedure ScreenRectToClient (Var OrigRect : TRect);
    procedure ChangeZOrder;
    Procedure SetZOrders;
    Procedure ControlToFront;
    Procedure ControlToBack;
    Procedure PaintControlPage (TheControlRect : TRect);
    Procedure PaintTopControls (PaintControl : TControl);
    Procedure PaintControlRects (PaintControl : TControl);
    Procedure PaintControlFores (TheControlRect : TRect);
    Procedure AlignControl;
    Procedure UpdateBitmap;
    Procedure RedrawVisible;

    Function  ControlOptions : Boolean;
    Procedure ControlFont;
    Procedure EditIf;
    procedure CreateNewControl (ControlType : TSBSControlType);
    procedure CreateControl (Const ControlDef : FormDefRecType;Const AddToSel : Boolean);
    procedure ChangeMade;

    Function PaperHandleSet : Boolean;
    Function GridHandleSet : Boolean;
    Function PageHandleSet : Boolean;

    Procedure EditCopy;
    Procedure EditPaste;
    Procedure EditCut;

    Procedure Control1;
    Procedure Control2;

    Function  GetGroup (Const TheControl : TControl) : String10;

    Procedure SelectArea (Const SelectRect : TRect);
    Procedure SelectControl (Const TheControl : TControl;
                             Const Append     : Boolean);
    Procedure DeSelectControl (Const TheControl : TControl);
    Procedure SelectMove (Const TheControl : TControl;
                          Const XOff, YOff : SmallInt;
                          Const Mode       : Byte);
    Function JustMe (Const TheControl : TControl) : Boolean;
    Function BmpCovered (Const TheControl : TControl) : Boolean;
  published
    { Published declarations }
    property Paper: TSBSPaperSize read FPaper write SetPaper;
    property Grid: TSBSPaperGrid read FGrid write SetGrid;
    Property Page : TSBSPage read FPage write FPage;
    Property FormDetails : TFormDetails read FFormDetails write FFormDetails;
    Property Popup_Text : TPopupMenu read FTextMenu write FTextMenu;
    Property Popup_Bitmap : TPopupMenu read FBitmapMenu write FBitmapMenu;
    Property Popup_Box : TPopupMenu read FBoxMenu write FBoxMenu;
    Property Popup_Line : TPopupMenu read FLineMenu write FLineMenu;
    Property Popup_DbField : TPopupMenu read FDbFieldMenu write FDbFieldMenu;
    Property Popup_DbTable : TPopupMenu read FDbTableMenu write FDbTableMenu;
    Property Popup_DbFormula : TPopupMenu read FDbFormulaMenu write FDbFormulaMenu;
    Property Popup_Pageno : TPopupMenu read FPageNoMenu write FPageNoMenu;
    Property Popup_Group : TPopupMenu read FGroupMenu write FGroupMenu;
    {property OnWalkList: TWalkTypeEvent read FOnWalkList write FOnWalkList;}
    Property OnTextOptions : TNotifyEvent read FOnTextOptions write FOnTextOptions;
    Property OnBitmapOptions : TNotifyEvent read FOnBitmapOptions write FOnBitmapOptions;
    Property OnBoxOptions : TNotifyEvent read FOnBoxOptions write FOnBoxOptions;
    Property OnLineOptions : TNotifyEvent read FOnLineOptions write FOnLineOptions;
    Property OnFieldOptions : TNotifyEvent read FOnFieldOptions write FOnFieldOptions;
    Property OnTableOptions : TNotifyEvent read FOnTableOptions write FOnTableOptions;
    Property OnFormulaOptions : TNotifyEvent read FOnFormulaOptions write FOnFormulaOptions;
    Property OnPageNoOptions : TNotifyEvent read FOnPageNoOptions write FOnPageNoOptions;
    Property OnGroupOptions : TNotifyEvent read FOnGroupOptions write FOnGroupOptions;
    Property OnIf : TIfLabelEvent read FOnIf write FOnIf;
    Property OnZOrder : TNotifyEvent read FOnZOrder write FOnZOrder;
    Property Help_Text : THelpContext read FTextHelpCntxt write FTextHelpCntxt;
    Property Help_Bitmap : THelpContext read FBitmapHelpCntxt write FBitmapHelpCntxt;
    Property Help_Box : THelpContext read FBoxHelpCntxt write FBoxHelpCntxt;
    Property Help_Line : THelpContext read FLineHelpCntxt write FLineHelpCntxt;
    Property Help_Field : THelpContext read FFieldHelpCntxt write FFieldHelpCntxt;
    Property Help_Table : THelpContext read FTableHelpCntxt write FTableHelpCntxt;
    Property Help_Formula : THelpContext read FFormulaHelpCntxt write FFormulaHelpCntxt;
    Property Help_PageNo : THelpContext read FPageNoCntxt write FPageNoCntxt;
    Property Help_Group : THelpContext read FGroupHelpCntxt write FGroupHelpCntxt;
  end;

  TSBSPaperSize = class(TPersistent)
  private
    FController : TSBSController;
    {FParentPage: TSBSPage;}
    FDeskColour: TColor;       { Colour behind page }
    FShade: TBitmap;           { Bitmap pattern for paper shading }
    FScaling: Single;          { Pixels to the mm }
    FPageHeight: LongInt;      { Height of full backgound page (mm) }
    FPageWidth: LongInt;       { Width of full backgound page (mm)}
    FBorderWidth: LongInt;     { Width of border around backgound page (pixels) }
    FPaperHeight: LongInt;     { Height of paper (mm) }
    FPaperWidth: LongInt;      { Width of paper (mm) }
    {FTop: LongInt;             { Top margin (mm) }
    {FLeft: LongInt;            { Left Margin (mm) }
    {FRight: LongInt;           { Right Margin (mm) }
    {FBottom: LongInt;          { Bottom Margin (mm) }
    {FWidth: LongInt;           { Printable Width (mm) }
    {FHeight: LongInt;          { Printable Height (mm) }
    {procedure SetTop(Value: LongInt);}
    {procedure SetLeft(Value: LongInt);}
    {procedure SetWidth(Value: LongInt);}
    {procedure SetHeight(Value: LongInt);}
    procedure SetBorderWidth(Value: LongInt);
    procedure SetPageWidth(Value: LongInt);
    procedure SetPageHeight(Value: LongInt);
    procedure SetScaling(Value: Single);
    procedure SetShade(Value: TBitmap);
    procedure SetDeskColour(Value: TColor);
    {procedure SetPaperWidth(Value: LongInt);
    procedure SetPaperHeight(Value: LongInt);}
    {procedure SetRight(Value: LongInt);}
    {procedure SetBottom(Value: LongInt);}
  public
    psHeight : LongInt; { Printable width (calculated) }
    psWidth  : LongInt; { Printable height (calculated) }

    constructor Create(AController : TSBSController);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent);
    procedure Paint(TheCanvas: TCanvas);

    function InPixels(Const InMM : LongInt) : LongInt;
    function InMM(Const InPixels : LongInt) : LongInt;

    procedure SetScrollBars;
  published
    {property psTop: LongInt read FTop write SetTop;}
    {property psLeft: LongInt read FLeft write SetLeft;}
    {property psWidth: LongInt read FWidth write SetWidth;}
    {property psHeight: LongInt read FHeight write SetHeight;}
    property psBorderWidth: LongInt read FBorderWidth write SetBorderWidth;
    property psPageHeight: LongInt read FPageHeight write SetPageHeight;
    property psPageWidth: LongInt read FPageWidth write SetPageWidth;
    property psScaling: Single read FScaling write SetScaling;
    property psShade: TBitmap read FShade write SetShade;
    property psDeskColour: TColor read FDeskColour write SetDeskColour;
    {property psPaperHeight: LongInt read FPaperHeight write SetPaperHeight;
    property psPaperWidth: LongInt read FPaperWidth write SetPaperWidth;}
    {property psRight : LongInt read FRight write SetRight;}
    {property psBottom : LongInt read FBottom write SetBottom;}
  End;

  TSBSPaperGrid = class(TPersistent)
  private
    FController : TSBSController;

    FDisplayGrid : Boolean;
    FSnapToGrid  : Boolean;
    FXSpacing    : LongInt;
    FYSpacing    : LongInt;
  public
    constructor Create(AController: TSBSController);

    Procedure SetDisplayGrid(Value : Boolean);
    Procedure SetSnapToGrid(Value : Boolean);
    Procedure SetXSpace(Value : LongInt);
    Procedure SetYSpace(Value : LongInt);
    procedure Assign(Source: TPersistent);
    procedure Paint(TheCanvas: TCanvas);
    Procedure SetXYSpace(X, Y : LongInt);

    procedure ScreenSnapToGrid (Var   Rect : TRect;
                                Const Mode : Byte);

    procedure SnapControlToGrid (      aControl : TControl;
                                 Const Force    : Boolean;
                                 Const Mode     : Byte);

    procedure SnapToGrid (Var   cTop,cLeft,cHeight,cWidth : Integer;
                          Const Force                     : Boolean;
                          Const Mode                      : Byte);

    Procedure GetGridSizes (Var   GridRect     : TRect;
                            Var   GridX, GridY : Integer;
                            Const Drawing      : Boolean);
  published
    property grDisplayGrid : Boolean read FDisplayGrid write SetDisplayGrid;
    property grSnapToGrid  : Boolean read FSnapToGrid write SetSnapToGrid;
    property grXSpacing    : LongInt read FXSpacing write SetXSpace;
    property grYSpacing    : LongInt read FYSpacing write SetYSpace;
  End;

  TSBSPaperBmp = class(TBitmap)
  private
    FParentPage: TSBSPage;
  public
    constructor Create(AControl: TSBSPage); 
    procedure UpdateBitmap;
  End;

  TSBSSepBar = class(TCustomControl)
  private
    FPage       : TSBSPage;
    FIndex      : Byte;
    FDragging   : Boolean;
    FSepColour  : TColor;
    FEnable     : Boolean;
    FName       : String;
    FMoveTop    : Integer;
    OrigMoveTop : Integer;
  protected
    DrawRect   : TRect;
    procedure Paint; override;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure SetEnable(Value : Boolean);
    Procedure DrawMoveBox;
  public
    constructor Create(AOwner: TComponent); override;
    Procedure SetPosition (Index : Byte;NameStr:String;Enable: Boolean;NewTop: LongInt; SepColour : TColor);
    Function  TopOk (Y : Integer) : Integer;
    procedure PaintControl;
  published
    Property Enable : Boolean read FEnable write SetEnable;
  end;

  TMessageEvent = procedure(Sender: TObject; Idx: Integer; Msg: String) of object;

  TSBSPage = class(TSBSScrollBox)
  private
    { Private declarations }
    FController          : TSBSController;
    FBitmap              : TSBSPaperBmp;
    FOnMessage           : TMessageEvent;
    FSections            : Array [1..4] Of TSBSSepBar;
    FDefaultFont         : TFont;
    FStartX, FStartY     : LongInt;
    FDragRect            : TRect;
    FInCapture           : Boolean;
    Procedure DrawBox (Var StartRect, EndRect : TRect);
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  protected
    { Protected declarations }
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure Loaded; override;
    procedure Paint; override;
  public
    { Public declarations }
    property Canvas;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DispMsg (Idx : Integer; MsgStr : String);
    procedure DispCursorPos;
    procedure SetSeparatorsToBack;
    Procedure PaintRect (PRect : TRect);

    Procedure CheckMousePos (      DragControl : TControl;
                             Const XOff, YOff  : Integer);
    Procedure CheckMoveRect (Var EndRect : TRect);

    Procedure CheckMouseSizePos (DragControl : TControl);

    Function ControllerHandleSet : Boolean;
    Function PaperHandleSet : Boolean;
    Function GridHandleSet : Boolean;
  published
    { Published declarations }
    property Controller : TSBSController read FController write FController;
    property DefaultFont : TFont read FDefaultFont write FDefaultFont;
    property OnMessage: TMessageEvent read FOnMessage write FOnMessage;
  end;

procedure Register;

implementation

Uses SbsDrag, SBSFuncs, ClipBrd;

Var
  CF_DragControl : Word;
  EmptyRect      : TRect;

procedure Register;
begin
  RegisterComponents('SbsForm', [TSBSPage, TSBSController]);
end;


{**********************************************************************}
{* TFormDetails: This contains all the details about the page.        *}
{**********************************************************************}
{$I FormDets.Inc}


{**********************************************************************}
{* TSBSController: This controls the addition and management of the   *}
{*                 Drag controls and gives access to all components.  *}
{**********************************************************************}
{$I SbsContl.Inc}

{*********************************************************************}
{* TSBSPaperSize: This stores all the details about the page size    *}
{*                and the printable area.                            *}
{*********************************************************************}
{$I SbsPaper.Inc}

{*********************************************************************}
{* TSBSPaperGrid: This stores all the details about the grid and has *}
{*                methods to draw it.                                *}
{*********************************************************************}
{$I sbsgrid.inc}

{**********************************************************************}
{* TSBSPaperBmp: This object contains a bitmap upon which the page is *}
{*               drawn by the paper and grid objects.                 *}
{**********************************************************************}
{$I sbsbmp.inc}

{********************************************************************}
{* TSBSSepBar: This controls is a dividing line between the various *}
{*             sections on the page                                 *}
{********************************************************************}
{$I SBSSep.inc}

{****************************************************************}
{* TSBSPage: This stores all the details about the page and has *}
{*           methods to draw it.                                *}
{****************************************************************}
{$I SbsPage.inc}

Initialization
  CF_DragControl := RegisterClipBoardFormat ('CF_ENTDRAGCONTROL');
  EmptyRect := Rect (0, 0, 0, 0);
end.
