{*******************************************************}
{                                                       }
{       Delphi Visual Component Library                 }
{                                                       }
{       Copyright (c) 1995 Borland International        }
{                                                       }
{*******************************************************}

unit SBSOutl;
 {$WARN UNIT_DEPRECATED OFF}
interface

{$R SBSOutL}

uses Windows, Messages, Forms, Classes, Graphics, Menus, StdCtrls, Grids,
  Controls, SysUtils,ETMiscU,ETStrU,OutLine;

{$LONGSTRINGS ON}

type
  CCNomFiltType  =  Array[False..True] of String[10];
  TSBSAttachMode = TAttachMode;

  TCustomSBSOut = class;

  OutNomType  =  Record
                   OutNomCode,
                   OutNomCat,
                   OutDepth,
                   BeenDepth    :  LongInt;

                   LastLoc      :  String[10];
                   OutStkCode,

                   {$IFNDEF RW_GUI}
                     OutStkCat    :  String[20];
                     {$ELSE}
                     OutStkCat    :  String[30];
                   {$ENDIF} // RW_GUI

                   LastCCFilt   :  CCNomFiltType;

                   OutViewCode:  String[50];

                   OutViewNomLink,

                   OutNomType   :  Char;

                   LastPr,

                   LastPrTo,
                   LastYr,
                   LastCr,
                   LastTxCr,
                   LastDMode,
                   LastCommitMode,
                   OutJTNo      :  Word;

                   StkQty,
                   StkCost      :  Double;

                   MoreLink,
                   LastYTD,
                   NotOpen,
                   HideValue,
                   LastHValue,
                   LastSQty,
                   ShowAsBar,
                   PRateMode,
                   BeenEdit,
                   HedTotal     :  Boolean;

                   OBOMLink     :  ShortString;
                   OBOMAddr     :  LongInt;

                   LastDrCr     :  Array[1..4] of Double;

                   {$IFDEF RW}
                     IsDummy    : Boolean;
                     GrpDesc    : ShortString;
                     GrpPword   : String[8];
                   {$ENDIF}
                 end; {Rec..}


  {* EL Big Glyph*}
  {This entire section of constatnts has been replaced so we can get in an extra bitmap}

  TBitmapArrayRange = 0..8;
  EOutlineChange = procedure (Sender: TObject; Index: LongInt) of object;
  TOutlineStyle = (osText, osPlusMinusText, osPictureText,
    osPlusMinusPictureText, osTreeText, osTreePictureText);
  TOutlineBitmap = (obPlus, obMinus, obOpen, obClose, obLeaf,obLeaf2,obLeaf3,obLeaf4,obLeaf5);
  TOutlineBitmaps = set of TOutlineBitmap;
  TBitmapArray = array[TBitmapArrayRange] of TBitmap;

{ TOutlineNode }

{ The TOutlineNode is an encapsulation of an outliner item.  Access
  to a TOutlineNode is via the container class TOutline.  Each
  TOutlineNode contains user defined text and data.
  An item is also capable of containing up to 16368 sub-items.
  TOutlineNodes are also persistent.

  A TOutlineNode item can be interrogated about its current state :
    Expanded
      Whether the node is open or closed.
    Index
      The current Index of the node.  This changes as items are inserted and
      deleted.  The index will range from 1..n
    Level
      The current depth of the node with 1 being the top level
    HasItems
      Whether the item contains items
    IsVisible
      Whether the item is capable of being displayed. This value is only
      True if all its parent items are visible
    TopItem
      Obtains the parent of the item that resides at level 1
    FullPath
      Returns the fully qualified name of the item starting from its
      level 1 parent.  Each item is separated by the separator string
      specified in the TOutline Container
    Text
      Used to set and get the items text value
    Data
      Used to get and set the items data }

  TSBSOutLNode = class(TPersistent)
  private
    FList: TList;
    FText: string;
    FData: Pointer;
    FParent: TSBSOutLNode;
    FIndex: LongInt;
    FState,
    fUseLeaf2,
    fShowCheckBox, {* EL Big Glyph*}
    fCBChecked : Boolean; {* EL Big Glyph*}
    FOutline: TCustomSBSOut;
    FExpandCount: LongInt;
    fUseLeafx :  TOutLineBitmap; {* EL Big Glyph*}

    procedure ChangeExpandedCount(Value: LongInt);
    procedure CloseNode;
    procedure Clear;
    procedure Error(const ErrorString: string);
    function GetExpandedNodeCount: LongInt;
    function GetFullPath: string;
    function GetIndex: LongInt;
    function GetLastIndex: LongInt;
    function GetLevel: Cardinal;
    function GetList: TList;
    function GetMaxDisplayWidth(Value: Cardinal): Cardinal;
    function GetNode(Index: LongInt): TSBSOutLNode;
    function GetTopItem: Longint;
    function GetVisibleParent: TSBSOutLNode;
    function HasChildren: Boolean;
    function HasVisibleParent: Boolean;
    procedure ReIndex(StartNode, EndNode: TSBSOutLNode; NewIndex: LongInt;
      IncludeStart: Boolean);
    procedure Repaint;
    function Resync(var NewIndex: LongInt; EndNode: TSBSOutLNode): Boolean;
    procedure SetExpandedState(Value: Boolean);
    procedure SetGoodIndex;
    procedure SetHorzScrollBar;
    procedure SetLevel(Level: Cardinal);
    procedure SetText(const Value: string);
  protected
    constructor Create(AOwner: TCustomSBSOut);
    function GetVisibleNode(TargetCount: LongInt): TSBSOutLNode;
    function AddNode(Value: TSBSOutLNode): LongInt;
    function InsertNode(Index: LongInt; Value: TSBSOutLNode): LongInt;
    function GetNodeAtIndex(TargetIndex: LongInt): TSBSOutLNode;
    function GetDataItem(Value: Pointer): LongInt;
    function GetTextItem(const Value: string): LongInt;
    function HasAsParent(Value: TSBSOutLNode): Boolean;
    function GetRowOfNode(TargetNode: TSBSOutLNode;
      var RowCount: Longint): Boolean;
    procedure Remove(Value: TSBSOutLNode);
    procedure WriteNode(Buffer: PChar; Stream: TStream);
    property Outline: TCustomSBSOut read FOutline;
    property List: TList read GetList;
    property ExpandCount: LongInt read FExpandCount;
    property Items[Index: LongInt]: TSBSOutLNode read GetNode; default;
  public
    destructor Destroy; override;
    procedure ChangeLevelBy(Value: TChangeRange);
    procedure Collapse;
    procedure Expand;
    procedure FullExpand;
    function GetDisplayWidth: Integer;
    function GetFirstChild: LongInt;
    function GetLastChild: LongInt;
    function GetNextChild(Value: LongInt): LongInt;
    function GetPrevChild(Value: LongInt): LongInt;
    procedure MoveTo(Destination: LongInt; AttachMode: TSBSAttachMode);
    property Parent: TSBSOutLNode read FParent;
    property Expanded: Boolean read FState write SetExpandedState;
    property Text: string read FText write SetText;
    property Data: Pointer read FData write FData;
    property Index: LongInt read GetIndex;
    property Level: Cardinal read GetLevel write SetLevel;
    property HasItems: Boolean read HasChildren;
    property IsVisible: Boolean read HasVisibleParent;
    property ShowCheckBox : Boolean read fShowCheckBox write fShowCheckBox; {* EL Big Glyph*}
    property CheckBoxChecked : Boolean read fCBChecked write fCBChecked;    {* EL Big Glyph*}
    property UseLeaf2  : Boolean read fUseLeaf2 write fUseLeaf2 ;    {* EL Big Glyph*}
    property UseLeafx  : TOutLineBitmap read fUseLeafx write fUseLeafx ;    {* EL Big Glyph*}


    property TopItem: Longint read GetTopItem;
    property FullPath: string read GetFullPath;
  end;

{ TCustomSBSOut }

{ The TCustomSBSOut object is a container class for TSBSOutLNodes.
  All TOutlineNodes contained within a TOutline are presented
  to the user as a flat array of TOutlineNodes, with a parent
  TOutlineNode containing an index value that is one less than
  its first child (if it has any children).

  Interaction with a TOutlineNode is typically accomplished through
  the TCustomSBSOut using the following properties:
    CurItem
      Reads and writes the current item
    ItemCount
      Returns the total number of TOutlineNodes with the TCustomSBSOut.
      Note this can be computationally expensive as all indexes will
      be forced to be updated!!
    Items
      Allows Linear indexing into the hierarchical list of TOutlineNodes
    SelectedItem
      Returns the Index of the TOutlineNode which has the focus or 0 if
      no TOutlineNode has been selected

  The TCustomSBSOut has a number of properties which will affect all
  TOutlineNodes owned by the TCustomSBSOut:
    OutlineStyle
      Sets the visual style of the outliner
    ItemSeparator
      Sets the delimiting string for all TOutlineNodes
    PicturePlus, PictureMinus, PictureOpen, PictureClosed, PictureLeaf
      Sets custom bitmaps for these items }


  TOutlineType = (otStandard, otOwnerDraw);
  TOutlineOption = (ooDrawTreeRoot, ooDrawFocusRect, ooStretchBitmaps);
  TOutlineOptions = set of TOutlineOption;


  TUpdateNode  =  Procedure (Sender  :  TObject;
                        Var Node    :  TSBSOutLNode;
                            Row     :  Integer)   of object;

{$WARNINGS OFF}
  TCustomSBSOut= class(TCustomGrid)
  private
    FBlockInsert: Boolean;
    FRootNode: TSBSOutLNode;
    FGoodNode: TSBSOutLNode;
    UpdateCount: Integer;
    FCurItem: TSBSOutLNode;
    FSeparator: string;
    FFontSize: Integer;
    FStrings: TStrings;
    FUserBitmaps: TOutLineBitmaps;
    FOldBitmaps: TOutlineBitmaps;
    FPictures: TBitmapArray;
    FOnExpand: EOutlineChange;
    FOnCollapse: EOutlineChange;
    FOutlineStyle: TOutlineStyle;
//    FMaskColor: TColor;
    FItemHeight: Integer;
    FStyle: TOutlineType;
    FOptions: TOutlineOptions;
    FIgnoreScrollResize: Boolean;
    FSelectedItem: TSBSOutLNode;
    FOnDrawItem: TDrawItemEvent;
    FSettingWidth: Boolean;
    FSettingHeight: Boolean;

    fDDStop,
    fTreeReady,
    fHideText     :  Boolean;
    FNoValCol,
    FSetCol       :  Byte;

    FColValue     :  Double;
    fColFmt       :  ShortString;

    FColsX,
    FCalcIdx,
    FItemHeightDelta
                  :  Integer;  {* EL Big Glyph*}

    LevelHotSpots :  Array[0..20] of Integer;

    fBarColor,
    fBarTextColor,
    fHLBarColor,
    fHLBarTextColor,
    fTreeColor   {* EL Big Glyph*}
                  :  TColor;


    FOnNeedValue  :  TNotifyEvent;
    FOnUpdateNode,
    FNodeChkHotSpot
                  :  TUpdateNode;

    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    function GetItemCount: LongInt;
    function AttachNode(Index: LongInt; Str: string;
      Ptr: Pointer; AttachMode: TAttachMode): LongInt;
    function Get(Index: LongInt): TSBSOutLNode;
    function GetSelectedItem: LongInt;
    procedure SetSelectedItem(Value: Longint);
    function CompareNodes(Value1, Value2: TSBSOutLNode): TOutlineNodeCompare;
    procedure Error(const ErrorString: string);
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    function ResizeGrid: Boolean;
    procedure DoExpand(Node: TSBSOutLNode);
    procedure Init;
    procedure MoveNode(Destination, Source: LongInt;
      AttachMode: TAttachMode);
    procedure ClearBitmap(var Bitmap: TBitmap; Kind: TOutlineBitmap);
    procedure ChangeBitmap(Value: TBitmap; Kind: TOutlineBitmap);
    procedure SetRowHeight;
    procedure SetCurItem(Value: LongInt);
    procedure CreateGlyph;
    procedure SetStrings(Value: TStrings);
    function GetStrings: TStrings;
    function IsCurItem(Value: LongInt): Boolean;
    procedure SetPicture(Index: Integer; Value: TBitmap);
    function GetPicture(Index: Integer): TBitmap;
    procedure DrawPictures(BitMaps: array of TBitmap; ARect: TRect;
                           IndentLevel  :  Integer);

    procedure DrawText(Node: TSBSOutLNode; Rect: TRect);
    procedure SetOutlineStyle(Value: TOutlineStyle);
    procedure DrawTree(ARect: TRect; Node: TSBSOutLNode);
//    procedure SetMaskColor(Value: TColor);
    procedure SetItemHeight(Value: Integer);
    procedure SetStyle(Value: TOutlineType);
    procedure SetOutlineOptions(Value: TOutlineOptions);
    function StoreBitmap(Index: Integer): Boolean;
    procedure ReadBinaryData(Stream: TStream);
    procedure WriteBinaryData(Stream: TStream);
    procedure SetHorzScrollBar;
    procedure ResetSelectedItem;
    procedure SetRowFromNode(Node: TSBSOutLNode);
  protected
    procedure Loaded; override;
    procedure Click; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    function SetGoodIndex(Value: TSBSOutLNode): TSBSOutLNode;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); override;
    procedure DblClick; override;
    procedure SetLevel (Node: TSBSOutLNode; CurLevel, NewLevel: Cardinal);
    function BadIndex(Value: TSBSOutLNode): Boolean;
    procedure DeleteNode(Node: TSBSOutLNode; CurIndex: LongInt);
    procedure Expand(Index: LongInt); dynamic;
    procedure Collapse(Index: LongInt); dynamic;
    procedure DefineProperties(Filer: TFiler); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Move(Destination, Source: LongInt; AttachMode: TAttachMode);
    procedure SetDisplayWidth(Value: Integer);
    property Lines: TStrings read GetStrings write SetStrings;
    property OutlineStyle: TOutlineStyle read FOutlineStyle write SetOutlineStyle default osTreePictureText;
    property OnExpand: EOutlineChange read FOnExpand write FOnExpand;
    property OnCollapse: EOutlineChange read FOnCollapse write FOnCollapse;
    property Options: TOutlineOptions read FOptions write SetOutlineOptions
      default [ooDrawTreeRoot, ooDrawFocusRect];
    property Style: TOutlineType read FStyle write SetStyle default otStandard;
    property ItemHeight: Integer read FItemHeight write SetItemHeight;
    property OnDrawItem: TDrawItemEvent read FOnDrawItem write FOnDrawItem;
    property ItemSeparator: string read FSeparator write FSeparator;
    property PicturePlus: TBitmap index 0 read GetPicture write SetPicture stored StoreBitmap;
    property PictureMinus: TBitmap index 1 read GetPicture write SetPicture stored StoreBitmap;
    property PictureOpen: TBitmap index 2 read GetPicture write SetPicture stored StoreBitmap;
    property PictureClosed: TBitmap index 3 read GetPicture write SetPicture stored StoreBitmap;
    property PictureLeaf: TBitmap index 4 read GetPicture write SetPicture stored StoreBitmap;
    property PictureLeaf2: TBitmap index 5 read GetPicture write SetPicture stored StoreBitmap; {* EL Big Glyph*}
    property PictureLeaf3: TBitmap index 6 read GetPicture write SetPicture stored StoreBitmap; {* EL Big Glyph*}
    property PictureLeaf4: TBitmap index 7 read GetPicture write SetPicture stored StoreBitmap; {* EL Big Glyph*}
    property PictureLeaf5: TBitmap index 8 read GetPicture write SetPicture stored StoreBitmap; {* EL Big Glyph*}
    property BarColor  :  TColor read fBarColor write fBarColor;
    property BarTextColor  :  TColor read fBarTextColor write fBarTextColor;
    property HLBarColor  :  TColor read fHLBarColor write fHLBarColor;
    property HLBarTextColor  :  TColor read fHLBarTextColor write fHLBarTextColor;

    property TreeColor  :  TColor read fTreeColor write fTreeColor; {* EL Big Glyph*}

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Add(Index: LongInt; const Text: string): LongInt;
    function AddChild(Index: LongInt; const Text: string): LongInt;
    function AddChildObject(Index: LongInt; const Text: string; const Data: Pointer): LongInt;
    function AddObject(Index: LongInt; const Text: string; const Data: Pointer): LongInt;

    Procedure AssignChild(Const Value       :  TCustomSBSOut;
                                Idx,
                                OldIndex    :  Integer);
    procedure Assign(Const Value  :  TCustomSBSOut);

    function Insert(Index: LongInt; const Text: string): LongInt;
    function InsertObject(Index: LongInt; const Text: string; const Data: Pointer): LongInt;
    procedure Delete(Index: LongInt);
    function GetDataItem(Value: Pointer): Longint;
    function GetNodeDisplayWidth(Node: TSBSOutLNode): Integer;
    function GetTextItem(const Value: string): Longint;
    function GetItem(X, Y: Integer): LongInt;
    procedure FullExpand;
    procedure FullCollapse;
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(const FileName: string);
    procedure SaveToStream(Stream: TStream);
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure SetUpdateState(Value: Boolean);
    procedure Clear;

    Function FindxNCode(NCode  :  Pointer)  :  Integer;

    Procedure ExpandxNCode(NCode  :  Pointer;
                           ExPCol :  Boolean);

    property ItemCount: LongInt read GetItemCount;
    property Items[Index: LongInt]: TSBSOutLNode read Get; default;
    property SelectedItem: Longint read GetSelectedItem write SetSelectedItem;
    property Row;
    property Canvas;

    Property  SetCol    :  Byte read FSetCol write FSetCol;
    Property  ColValue  :  Double read FColValue write FColValue;
    Property  ColFmt    :  ShortString read fColFmt write fColFmt;
    Property  CalcIdx   :  LongInt read FCalcIdx write FCalcIdx;

    Property  HideText  :  Boolean read fHideText write fHideText;

    Property  StopDD    :  Boolean read fDDStop write fDDStop ;

    Property  TreeReady :  Boolean read fTreeReady write fTreeReady;

    Property  ColsX     :  LongInt read FColsX write FColsX;

    Property  ShowValCol  :  Byte read FNoValCol write FNoValCol;

    property ItemSpace    :  Integer read FItemHeightDelta write FItemHeightDelta;   {* EL Big Glyph*}

    Property OnNeedValue  :  TNotifyEvent read FOnNeedValue write FOnNeedValue;

    Property OnUpdateNode :  TUpdateNode read FOnUpdateNode write FOnUpdateNode;

    Property OnNodeChkHotSpot :  TUpdateNode read FNodeChkHotSpot write FNodeChkHotSpot;

  end;
   {$WARNINGS ON}

  TSBSOutlineB = class(TCustomSBSOut)
  published
    property Lines;
    property OutlineStyle;
    property OnExpand;
    property OnCollapse;
    property Options;
    property Style;
    property ItemHeight;
    property ItemSpace;  {* EL Big Glyph*}
    property OnDrawItem;
    property Align;
    property Anchors;    // HM 06/02/04: Published Anchors property to simplfy resizing
    property BarColor;
    property BarTextColor;
    property HLBarColor;
    property HLBarTextColor;
    property Enabled;
    property Font;
    property Color;
    property ParentColor;
    property ParentCtl3D;
    property Ctl3D;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property DragMode;
    property DragCursor;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnDblClick;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property BorderStyle;
    property ItemSeparator;
    property PicturePlus;
    property PictureMinus;
    property PictureOpen;
    property PictureClosed;
    property PictureLeaf;
    property PictureLeaf2; {* EL Big Glyph*}
    property PictureLeaf3; {* EL Big Glyph*}
    property PictureLeaf4; {* EL Big Glyph*}
    property PictureLeaf5; {* EL Big Glyph*}
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property PopupMenu;
    property ScrollBars;
    Property  ShowValCol;
    Property OnNeedValue;
    Property OnUpdateNode;
    Property OnNodeChkHotSpot;
    property TreeColor; {* EL Big Glyph*}

  end;

  TSBSOutlineC = class(TSBSOutlineB)
  Protected
    FColValue : ShortString;

    procedure DrawCell (ACol, ARow: Longint;
                        ARect: TRect;
                        AState: TGridDrawState); OverRide;
  Public
    Property ColValue : ShortString read FColValue write FColValue;
  End;

procedure Register;

implementation

uses Consts{,
  Dialogs};

const
  MaxLevels = 255;
  TAB = Chr(9);
  InvalidIndex = -1;
  BitmapWidth = 14;
  BitmapHeight = 14;

Var
  InDesignMode  :  Boolean;

type

{ TOutlineStrings }

  TOutlineStrings = class(TStrings)
  private
    Outline: TCustomSBSOut;
    procedure ReadData(Reader: TReader);
    procedure WriteData(Writer: TWriter);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    function Get(Index: Integer): string; override;
    function GetCount: Integer; override;
  public
    function Add(const S: string): Integer; override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
    procedure PutObject(Index: Integer; AObject: TObject); override;
    function GetObject(Index: Integer): TObject; override;
  end;

function GetBufStart(Buffer: PChar; var Level: Cardinal): PChar;
begin
  Level := 0;
  while Buffer^ in [' ', #9] do
  begin
    Inc(Buffer);
    Inc(Level);
  end;
  Result := Buffer;
end;

function PutString(BufPtr: PChar; const S: string): PChar;
var
  I: Integer;
begin
  for I := 1 to Length(S) do
  begin
    BufPtr^ := S[I];
    Inc(BufPtr);
  end;
  Word(Pointer(BufPtr)^) := $0A0D;
  Inc(BufPtr, 2);
  Result := BufPtr;
end;

Function DecFromStr(S  :  String)  :  Integer;


Var
  n,l  :  Integer;


Begin
  l:=Length(S);

  n:=Pos(DecimalSeparator,S);

  Result:=l-n;

  If (Pos('-',S)=l) or (Pos(' ',S)=l) then
    Result:=Result-1;

  If (Result<0) then
    Result:=0;
end;

{TOutlineNode}

constructor TSBSOutLNode.Create(AOwner: TCustomSBSOut);
begin
  FOutline := AOwner;

  
end;

destructor TSBSOutLNode.Destroy;
var
  CurIndex: LongInt;
  LastNode: Boolean;
begin
  CurIndex := 0;
  with Outline do
    if FRootNode = Self then FIgnoreScrollResize := True;
  try
    if Parent <> nil then CurIndex := Outline.FCurItem.Index;
    if FList <> nil then Clear;

    if Outline.FSelectedItem = Self then Outline.ResetSelectedItem;
    if Parent <> nil then
    begin
      LastNode := Parent.List.Last = Self;
      Parent.Remove(Self);
      if Parent.List.Count = 0 then
        Outline.SetRowFromNode(Parent)
      else if LastNode then
        Outline.SetRowFromNode(TSBSOutLNode(Parent.List.Last));
      Outline.DeleteNode(Self, CurIndex);
    end;
  finally
    with Outline do
      if FRootNode = Self then FIgnoreScrollResize := False;
  end;
  inherited Destroy;
end;

procedure TSBSOutLNode.Clear;
var
  I: Integer;
  Node: TSBSOutLNode;
begin
  for I := 0 to FList.Count - 1 do
  begin
    Node := FList.Items[I];
    Node.FParent := nil;
    Node.Destroy;
  end;
  FList.Destroy;
  FList := nil;
end;

procedure TSBSOutLNode.SetHorzScrollBar;
begin
  if (Parent <> nil) and Parent.Expanded then
    Outline.SetHorzScrollBar;
end;

function TSBSOutLNode.GetList: TList;
begin
  if FList = nil then FList := TList.Create;
  Result := FList;
end;

function TSBSOutLNode.GetNode(Index: LongInt): TSBSOutLNode;
begin
  Result := List[Index];
end;

function TSBSOutLNode.GetLastIndex: LongInt;
begin
  if List.Count <> 0 then
    Result := TSBSOutLNode(List.Last).GetLastIndex
  else
    Result := Index;
end;

procedure TSBSOutLNode.SetText(const Value: string);
var
 NodeRow: LongInt;
begin
  FText := Value;
  if not Assigned(FParent) then Exit;

  if Parent.Expanded then
  begin
    NodeRow := 0;
    with Outline do
    begin
      FRootNode.GetRowOfNode(Self, NodeRow);
      InvalidateCell(0, NodeRow - 2);
    end;
  end;
  SetHorzScrollBar;
end;

procedure TSBSOutLNode.ChangeExpandedCount(Value: LongInt);
begin
  if not Expanded then Exit;
  Inc(FExpandCount, Value);
  if Parent <> nil then Parent.ChangeExpandedCount(Value);
end;

function TSBSOutLNode.GetIndex: LongInt;
begin
  if Outline.BadIndex(Self) then SetGoodIndex;
  Result := FIndex;
end;

function TSBSOutLNode.GetLevel: Cardinal;
var
  Node: TSBSOutLNode;
begin
  Result := 0;
  Node := Parent;
  while Node <> nil do
  begin
    Inc(Result);
    Node := Node.Parent;
  end;
end;

procedure TSBSOutLNode.SetLevel(Level: Cardinal);
var
  CurLevel: Cardinal;
begin
  CurLevel := GetLevel;
  if Level = CurLevel then Exit;
  Outline.SetLevel(Self, CurLevel, Level);
end;

procedure TSBSOutLNode.ChangeLevelBy(Value: TChangeRange);
begin
{$WARNINGS OFF}
  Level := Level + Value;
{$WARNINGS ON}
end;

function TSBSOutLNode.GetDisplayWidth: Integer;
begin
  Result := Outline.GetNodeDisplayWidth(Self);
end;

function TSBSOutLNode.HasVisibleParent: Boolean;
begin
  Result := (Parent <> nil) and (Parent.Expanded);
end;

function TSBSOutLNode.GetVisibleParent: TSBSOutLNode;
begin
  Result := Self;
  while (Result.Parent <> nil) and not Result.Parent.Expanded do
    Result := Result.Parent;
end;

function TSBSOutLNode.GetFullPath: string;
begin
  if Parent <> nil then
    if Parent.Parent <> nil then
      Result := Parent.GetFullPath + Outline.ItemSeparator + Text
    else
      Result := Text
  else Result := EmptyStr;
end;

function TSBSOutLNode.HasAsParent(Value: TSBSOutLNode): Boolean;
begin
  if Self = Value then
    Result := True
  else if Parent <> nil then Result := Parent.HasAsParent(Value)
  else Result := False;
end;

function TSBSOutLNode.GetTopItem: Longint;
var
  Node: TSBSOutLNode;
begin
  Result := 0;
  if Parent = nil then Exit;
  Node := Self;
  while Node.Parent <> nil do
  begin
    if Node.Parent.Parent = nil then
      Result := Node.FIndex;
    Node := Node.Parent;
  end;
end;

function TSBSOutLNode.GetFirstChild: LongInt;
begin
  if List.Count > 0 then Result := Items[0].Index
  else Result := InvalidIndex;
end;

function TSBSOutLNode.GetLastChild: LongInt;
begin
  if List.Count > 0 then Result := Items[List.Count - 1].Index
  else Result := InvalidIndex;
end;

function TSBSOutLNode.GetNextChild(Value: LongInt): LongInt;
var
 I: Integer;
begin
  Result := InvalidIndex;
  for I := 0 to List.Count - 1 do
  begin
    if Items[I].Index = Value then
    begin
      if I < List.Count - 1 then Result := Items[I + 1].Index;
      Break;
    end;
  end;
end;

function TSBSOutLNode.GetPrevChild(Value: LongInt): LongInt;
var
 I: Integer;
begin
  Result := InvalidIndex;
  for I := List.Count - 1 downto 0 do
  begin
    if Items[I].Index = Value then
    begin
      if I > 0 then Result := Items[I - 1].Index;
      Break;
    end;
  end;
end;

procedure TSBSOutLNode.MoveTo(Destination: LongInt; AttachMode: TSBSAttachMode);
begin
  Outline.Move(Destination, Index, AttachMode);
end;

procedure TSBSOutLNode.FullExpand;
var
  I: Integer;
begin
  if HasItems then
  begin
    Expanded := True;
    for I := 0 to List.Count - 1 do
      Items[I].FullExpand;
  end;
end;

function TSBSOutLNode.GetRowOfNode(TargetNode: TSBSOutLNode;
  var RowCount: Longint): Boolean;
var
  I: Integer;
begin
  Inc(RowCount);
  if TargetNode = Self then
  begin
    Result := True;
    Exit;
  end;

  Result := False;
  if not Expanded then Exit;

  for I := 0 to List.Count - 1 do
  begin
    Result := Items[I].GetRowOfNode(TargetNode, RowCount);
    if Result then Exit
  end;
end;

function TSBSOutLNode.GetVisibleNode(TargetCount: LongInt): TSBSOutLNode;
var
  I, J: Integer;
  ExpandedCount, NodeCount, NodesParsed: LongInt;
  Node: TSBSOutLNode;
  Count: Integer;
begin
  if TargetCount = 0 then
  begin
    Result := Self;
    Exit;
  end;

  Result := nil;
  Count := List.Count;
  NodesParsed := 0;

  { Quick exit if we are lucky }
  if ExpandCount = Count then
  begin
    Result := Items[TargetCount - 1];
    Exit;
  end;

  I := 0;
  while I <= Count - 1 do
  begin
    for J := I to Count - 1 do
      if Items[J].Expanded then Break;

    if J > I then
    begin
      if J - I >= TargetCount then
      begin
        Result := Items[I + TargetCount - 1];
        Break;
      end;
      Dec(TargetCount, J - I);
    end;

    Node := Items[J];
    NodeCount := Node.ExpandCount + 1;
    ExpandedCount := NodeCount + J - I;

    Inc(NodesParsed, ExpandedCount);
    if NodeCount >= TargetCount then
    begin
      Result := Node.GetVisibleNode(Pred(TargetCount));
      Break;
    end
    else if ExpandCount - NodesParsed = Count - (J + 1) then
    begin
      Result := Items[TargetCount - NodeCount + J];
      Exit;
    end
    else begin
      Dec(TargetCount, NodeCount);
      I := J;
    end;
    Inc(I);
  end;
  if Result = nil then Error(SOutlineIndexError);
end;

function TSBSOutLNode.GetNodeAtIndex(TargetIndex: LongInt): TSBSOutLNode;
var
  I: Integer;
  Node: TSBSOutLNode;
  Lower: Integer;
  Upper: Integer;

  function RecurseNode: TSBSOutLNode;
  begin
    if Node.Index = TargetIndex then
      Result := Node
    else
      Result := Node.GetNodeAtIndex(TargetIndex);
  end;

begin
  if TargetIndex = Index then
  begin
    Result := Self;
    Exit;
  end;

  Lower := 0;
  Upper := List.Count - 1;
  Result := nil;
  while Upper >= Lower do
  begin
    I := (Lower + Upper) div 2;
    Node := Items[I];
    if Lower = Upper then
    begin
      Result := RecurseNode;
      Break;
    end
    else if Node.Index > TargetIndex then Upper := Pred(I)
    else if (Node.Index < TargetIndex) and (I < Upper) and
      (Items[I + 1].Index <= TargetIndex) then Lower := Succ(I)
    else begin
      Result := RecurseNode;
      Break;
    end;
  end;
  if Result = nil then Raise OutlineError.Create;
end;

function TSBSOutLNode.GetDataItem(Value: Pointer): LongInt;
var
  I: Integer;
begin
  if Value = Data then
  begin
    Result := Index;
    Exit;
  end;

  Result := 0;
  for I := 0 to List.Count - 1 do
  begin
    Result := Items[I].GetDataItem(Value);
    if Result <> 0 then Break;
  end;
end;

function TSBSOutLNode.GetTextItem(const Value: string): LongInt;
var
  I: Integer;
begin
  if Value = Text then
  begin
    Result := Index;
    Exit;
  end;

  Result := 0;
  for I := 0 to List.Count - 1 do
  begin
    Result := Items[I].GetTextItem(Value);
    if Result <> 0 then Break;
  end;
end;

procedure TSBSOutLNode.Expand;
begin
  Expanded := True;
end;

procedure TSBSOutLNode.Collapse;
begin
  Expanded := False;
end;

procedure TSBSOutLNode.SetExpandedState(Value: Boolean);
var
  ParentNode: TSBSOutLNode;
begin
  if FState <> Value then
  begin
    if Value then
    begin
      ParentNode := Self.Parent;
      while ParentNode <> nil do
      begin
        if not ParentNode.Expanded then Error(SOutlineExpandError);
        ParentNode := ParentNode.Parent;
      end;
      Outline.Expand(Index);

      {* EL. This check added so that lower level child codes never get set as expanded,
         otherwise repeated calls to that level only worked everyother time, as
         expanded was being set *}

      If (HasItems) or (InDesignMode) then
        FState := True;

      ChangeExpandedCount(List.Count);
    end
    else begin
      CloseNode;
      if List.Count > 0 then ChangeExpandedCount(-List.Count);
      if Outline.ResizeGrid then Outline.Invalidate;
      Outline.Collapse(Index);
      FState := False;
    end;
    SetHorzScrollBar;
    Repaint;
  end;
end;

procedure TSBSOutLNode.CloseNode;
var
  I: Integer;
begin
  for I := 0 to List.Count - 1 do
    Items[I].CloseNode;
  if List.Count > 0 then ChangeExpandedCount(-List.Count);
  FState := False;
end;

procedure TSBSOutLNode.Repaint;
begin
  if Outline <> nil then
    if Outline.ResizeGrid then  {* This line used to say Not outline.ReSizeGrid, but stopped working correctly *}
    Begin
      Outline.Invalidate;
    end;
end;

procedure TSBSOutLNode.SetGoodIndex;
var
  StartNode: TSBSOutLNode;
  ParentNode: TSBSOutLNode;
begin
  StartNode := Outline.SetGoodIndex(Self);
  ParentNode := StartNode.Parent;
  if ParentNode <> nil then
    ParentNode.ReIndex(StartNode, Self, StartNode.FIndex, True)
  else if Self <> Outline.FRootNode then
    FIndex := Succ(StartNode.FIndex);
  Outline.FGoodNode := Self;
end;

function TSBSOutLNode.AddNode(Value: TSBSOutLNode): LongInt;
begin
  List.Add(Value);
  Value.FParent := Self;
  ChangeExpandedCount(Value.ExpandCount + 1);
  if not Outline.FBlockInsert then Value.SetGoodIndex;
  with Value do
  begin
    Result := FIndex;
    SetHorzScrollBar;
  end;
end;

function TSBSOutLNode.InsertNode(Index: LongInt; Value: TSBSOutLNode): LongInt;
var
  CurIndex: LongInt;
  I: Integer;
begin
  for I := 0 to List.Count - 1 do
  begin
    CurIndex := Items[I].FIndex;
    if CurIndex = Index then
    begin
      List.Insert(I, Value);
      Value.FParent := Self;
      Break;
    end;
  end;
  ChangeExpandedCount(Value.ExpandCount + 1);
  if not Outline.FBlockInsert then Value.SetGoodIndex;
  with Value do
  begin
    Result := FIndex;
    SetHorzScrollBar;
  end;
end;

procedure TSBSOutLNode.Remove(Value: TSBSOutLNode);
var
  Index: Integer;
begin
  Index := List.IndexOf(Value);
  if Index <> 0 then
    Outline.SetGoodIndex(Items[Index - 1])
  else
    Outline.SetGoodIndex(Self);
  List.Delete(Index);
  ChangeExpandedCount(-(Value.ExpandCount + 1));
  if (List.Count = 0) and (Parent <> nil) then Expanded := False;
  SetHorzScrollBar;
end;

procedure TSBSOutLNode.ReIndex(StartNode, EndNode: TSBSOutLNode;
  NewIndex: LongInt; IncludeStart: Boolean);
var
  I: Integer;
begin
  for I := List.IndexOf(StartNode) to List.Count - 1 do
  begin
    if IncludeStart then
    begin
      if Items[I].Resync(NewIndex, EndNode) then Exit;
    end
    else
      IncludeStart := True;
  end;

  if Parent <> nil then
    Parent.ReIndex(Self, EndNode, NewIndex, False);
end;

function TSBSOutLNode.Resync(var NewIndex: LongInt; EndNode: TSBSOutLNode): Boolean;
var
  I: Integer;
begin
  FIndex := NewIndex;
  if EndNode = Self then
  begin
    Result := True;
    Exit;
  end;

  Result := False;
  Inc(NewIndex);
  for I := 0 to List.Count - 1 do
  begin
    Result := Items[I].Resync(NewIndex, EndNode);
    if Result then Exit;
  end;
end;

function TSBSOutLNode.GetExpandedNodeCount: LongInt;
var
  I : Integer;
begin
  Result := 1;
  if Expanded then
    for I := 0 to List.Count - 1 do
      Inc(Result, Items[I].GetExpandedNodeCount);
end;


function TSBSOutLNode.GetMaxDisplayWidth(Value: Cardinal): Cardinal;
var
  I : Integer;
  Width: Cardinal;
begin
  Width := GetDisplayWidth;
  if Width > Value then Result := Width
  else Result := Value;
  if Expanded then
    for I := 0 to List.Count - 1 do
      Result := Items[I].GetMaxDisplayWidth(Result);
end;

procedure TSBSOutLNode.Error(const ErrorString: string);
begin
  raise EOutlineError.Create(ErrorString);
end;

function TSBSOutLNode.HasChildren: Boolean;
begin
  Result := List.Count > 0;
end;

procedure TSBSOutLNode.WriteNode(Buffer: PChar; Stream: TStream);
var
  BufPtr: PChar;
  NodeLevel: Word;
  I: Integer;
begin
  if Parent <> nil then
  begin
    BufPtr := Buffer;
    NodeLevel := Level;
    while NodeLevel > 1 do
    begin
      BufPtr^ := Tab;
      Dec(NodeLevel);
      Inc(BufPtr);
    end;
    BufPtr := PutString(BufPtr, Text);
    Stream.WriteBuffer(Buffer[0], BufPtr - Buffer);
  end;
  for I := 0 to List.Count - 1 do
    Items[I].WriteNode(Buffer, Stream);
end;

{ TOutlineStrings }

function TOutlineStrings.Get(Index: Integer): string;
var
  Node: TSBSOutLNode;
  Level: Word;
  I: Integer;
begin
  Node := Outline[Index + 1];
  Level := Node.Level;
  Result := EmptyStr;
  for I := 0 to Level - 2 do
    Result := Result + TAB;
  Result := Result + Node.Text;
end;

function TOutlineStrings.GetCount: Integer;
begin
  Result := Outline.ItemCount;
end;

procedure TOutlineStrings.Clear;
begin
  Outline.Clear;
end;

procedure TOutlineStrings.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty('Nodes', ReadData, WriteData, Outline.ItemCount > 0);
end;

procedure TOutlineStrings.ReadData(Reader: TReader);
var
  StringList: TStringList;
  MemStream: TMemoryStream;
begin
  Reader.ReadListBegin;
  StringList := TStringList.Create;
  try
    while not Reader.EndOfList do StringList.Add(Reader.ReadString);
    MemStream := TMemoryStream.Create;
    try
      StringList.SaveToStream(MemStream);
      MemStream.Position := 0;
      Outline.LoadFromStream(MemStream);
    finally
      MemStream.Free;
    end;
  finally
    StringList.Free;
  end;
  Reader.ReadListEnd;
end;

procedure TOutlineStrings.WriteData(Writer: TWriter);
var
  I: Integer;
  MemStream: TMemoryStream;
  StringList: TStringList;
begin
  Writer.WriteListBegin;
  MemStream := TMemoryStream.Create;
  try
    Outline.SaveToStream(MemStream);
    MemStream.Position := 0;
    StringList := TStringList.Create;
    try
      StringList.LoadFromStream(MemStream);
      for I := 0 to StringList.Count - 1 do
        Writer.WriteString(StringList.Strings[I]);
    finally
      StringList.Free;
    end;
  finally
    MemStream.Free;
  end;
  Writer.WriteListEnd;
end;

function TOutlineStrings.Add(const S: string): Integer;
var
  Level, OldLevel, I: Cardinal;
  NewStr: string;
  NumNodes: LongInt;
  LastNode: TSBSOutLNode;
begin
  NewStr := GetBufStart(PChar(S), Level);
  NumNodes := Outline.ItemCount;
  if NumNodes > 0 then LastNode := Outline[Outline.ItemCount]
  else LastNode := Outline.FRootNode;
  OldLevel := LastNode.Level;
  if (Level > OldLevel) or (LastNode = Outline.FRootNode) then
  begin
    if Level - OldLevel > 1 then Outline.Error(SOutlineFileLoad);
  end
  else begin
    for I := OldLevel downto Level + 1 do
    begin
      LastNode := LastNode.Parent;
      if not Assigned(LastNode) then Outline.Error(SOutlineFileLoad);
    end;
  end;
  Result := Outline.AddChild(LastNode.Index, NewStr) - 1;
end;

procedure TOutlineStrings.Delete(Index: Integer);
begin
  Outline.Delete(Index + 1);
end;

procedure TOutlineStrings.Insert(Index: Integer; const S: string);
begin
  Outline.Insert(Index + 1, S);
end;

procedure TOutlineStrings.PutObject(Index: Integer; AObject: TObject);
var
  Node: TSBSOutLNode;
begin
  Node := Outline[Index + 1];
  Node.Data := Pointer(AObject);
end;

function TOutlineStrings.GetObject(Index: Integer): TObject;
begin
  Result := TObject(Outline[Index + 1].Data);
end;


{TCustomSBSOut}

const
  Images: array[TBitmapArrayRange] of PChar = ('PLUS', 'MINUS', 'OPEN', 'CLOSED', 'LEAF','LEAF2','LEAF3','LEAF4','LEAF5');

constructor TCustomSBSOut.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 121;
  Height := 97;
  Color := clWindow;
  BarColor:=clHighlight;
  BarTextColor:=clHighlightText;
  HLBarColor:=clBlack;
  HLBarTextColor:=clWhite;

  fTreeColor:=clGray;
  FItemHeightDelta:=0;
  fTreeReady:=False;

  ParentColor := False;
  SetRowHeight;
  RowCount := 0;
  ColCount := 1;
  FixedCols := 0;
  FixedRows := 0;
  DefaultDrawing := False;
  Init;
  FStrings := TOutlineStrings.Create;
  TOutlineStrings(FStrings).Outline := Self;
  inherited Options := [];
  Options := [ooDrawTreeRoot, ooDrawFocusRect];
  ItemSeparator := '\';
  FOutlineStyle := osTreePictureText;

  fHideText:=False;
  fDDStop:=False;

  CreateGlyph;

  FillChar(LevelHotSpots,Sizeof(LevelHotSpots),0);
end;

destructor TCustomSBSOut.Destroy;
var
  I: Integer;
begin
  FStrings.Free;
  FRootNode.Free;
  for I := Low(FPictures) to High(FPictures) do FPictures[I].Free;
  inherited Destroy;
end;

procedure TCustomSBSOut.Init;
begin
  if FRootNode = nil then FRootNode := TSBSOutLNode.Create(Self);
  FRootNode.FState := True;
  ResetSelectedItem;
  FGoodNode := FRootNode;
  FCurItem := FRootNode;
  FBlockInsert := False;
  UpdateCount := 0;
  ResizeGrid;
end;

procedure TCustomSBSOut.CreateGlyph;
var
  I: Integer;
begin
  FUserBitmaps := [];
  FOldBitmaps := [];
  for I := Low(FPictures) to High(FPictures) do
  begin
    FPictures[I] := TBitmap.Create;
    FPictures[I].Handle := LoadBitmap(HInstance, Images[I]);
  end;
end;

procedure TCustomSBSOut.SetRowHeight;
var
  ScreenDC: HDC;
begin
  if Style <> otOwnerDraw then
  begin
    ScreenDC := GetDC(0);
    try
      FFontSize := MulDiv(Font.Size, GetDeviceCaps(ScreenDC, LOGPIXELSY), 72);
      DefaultRowHeight := MulDiv(FFontSize, 120, 100)+(ItemSpace div 2) ; {* EL Big Glyph*}
      
      FItemHeight := DefaultRowHeight;
    finally
      ReleaseDC(0, ScreenDC);
    end;
  end
end;

procedure TCustomSBSOut.Clear;
begin
  FRootNode.Destroy;
  FRootNode := nil;
  Init;
end;

procedure TCustomSBSOut.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('Data', ReadBinaryData, WriteBinaryData,
    FUserBitmaps <> []);
end;

procedure TCustomSBSOut.ReadBinaryData(Stream: TStream);
begin
  Stream.ReadBuffer(FOldBitmaps, SizeOf(FOldBitmaps));
end;

procedure TCustomSBSOut.WriteBinaryData(Stream: TStream);
begin
  Stream.WriteBuffer(FuserBitmaps, SizeOf(FUserBitmaps));
end;

function TCustomSBSOut.IsCurItem(Value: LongInt): Boolean;
begin
  Result := Value = FCurItem.Index;
end;

function TCustomSBSOut.GetItemCount: LongInt;
begin
  Result := FRootNode.GetLastIndex;
end;

procedure TCustomSBSOut.MoveNode(Destination, Source: LongInt;
  AttachMode: TAttachMode);
var
  SourceNode: TSBSOutLNode;
  DestNode: TSBSOutLNode;
  OldParent: TSBSOutLNode;
begin
  SourceNode := nil;
  DestNode := nil;
  if Destination = Source then Exit;
  if IsCurItem(Destination) then
    DestNode := FCurItem
  else
    try
      DestNode := FRootNode.GetNodeAtIndex(Destination);
    except
      on OutlineError do Error(SOutlineIndexError);
    end;

  if IsCurItem(Source) then
    SourceNode := FCurItem
  else
    try
      SourceNode := FRootNode.GetNodeAtIndex(Source);
    except
      on OutlineError do Error(SOutlineIndexError);
    end;

  if DestNode.HasAsParent(SourceNode) then Exit;

  if DestNode.GetLevel > MaxLevels then Error(SOutlineMaxLevels);
  if (FGoodNode = FRootNode) and (FRootNode.List.Count <> 0) then
    TSBSOutLNode(FRootNode[0]).SetGoodIndex;
  OldParent := SourceNode.Parent;
  case AttachMode of
    oaInsert: DestNode.Parent.InsertNode(DestNode.Index, SourceNode);
    oaAddChild: DestNode.AddNode(SourceNode);
    oaAdd: DestNode.Parent.AddNode(SourceNode);
  end;
  if not DestNode.Expanded then SourceNode.Expanded := False;
  OldParent.Remove(SourceNode);
  if not ResizeGrid then Invalidate;
end;

function TCustomSBSOut.AttachNode(Index: LongInt; Str: string;
  Ptr: Pointer; AttachMode: TAttachMode): LongInt;
var
  NewNode: TSBSOutLNode;
  CurrentNode: TSBSOutLNode;
begin
  CurrentNode := nil;
  Result := 0;
  NewNode := TSBSOutLNode.Create(Self);
  with NewNode do
  begin
    Text := Str;
    Data := Ptr;
    FIndex := InvalidIndex;
  end;
  try
    if IsCurItem(Index) then CurrentNode := FCurItem
    else
      try
        CurrentNode := FRootNode.GetNodeAtIndex(Index);
      except
        on OutlineError do Error(SOutlineIndexError);
      end;

    if AttachMode = oaAdd then
    begin
      CurrentNode := CurrentNode.Parent;
      if CurrentNode = nil then Error(SOutlineError);
      AttachMode := oaAddChild;
    end;

    with CurrentNode do
    begin
      case AttachMode of
        oaInsert: Result := Parent.InsertNode(Index, NewNode);
        oaAddChild:
          begin
             if GetLevel > MaxLevels then Error(SOutlineMaxLevels);
             Result := AddNode(NewNode);
          end;
      end;
    end;
    if not ResizeGrid then Invalidate;
  except
    NewNode.Destroy;
    Application.HandleException(Self);
  end;
end;

function TCustomSBSOut.Get(Index: LongInt): TSBSOutLNode;
begin
  Result := nil;
  if IsCurItem(Index) then Result := FCurItem
  else
    try
      Result := FRootNode.GetNodeAtIndex(Index);
    except
      on OutlineError do Error(SOutlineIndexError);
    end;
  if Result = FRootNode then Error(SOutlineError);
end;

function TCustomSBSOut.GetSelectedItem: LongInt;
begin
  if FSelectedItem <> FRootNode then
  begin
    if not FSelectedItem.IsVisible then
      FSelectedItem := FSelectedItem.GetVisibleParent;
  end
  else if FRootNode.List.Count > 0 then
    FSelectedItem := FRootNode.GetVisibleNode(Row + 1);
  Result := FSelectedItem.Index
end;

procedure TCustomSBSOut.ResetSelectedItem;
begin
  FSelectedItem := FRootNode;
end;

procedure TCustomSBSOut.SetRowFromNode(Node: TSBSOutLNode);
var
  RowValue: LongInt;
begin
  if Node <> FRootNode then
  begin
    RowValue := 0;
    FRootNode.GetRowOfNode(Node, RowValue);
    Row := RowValue - 2;
  end;
end;

procedure TCustomSBSOut.SetSelectedItem(Value: Longint);
var
  Node: TSBSOutLNode;
begin
  Node := nil;
  if FBlockInsert then Exit;
  if (Value = 0) and (FRootNode.List.Count > 0) then Value := 1;
  if Value > 0 then
  begin
    if Value = FSelectedItem.Index then Node := FSelectedItem else
    try
      Node := FRootNode.GetNodeAtIndex(Value);
    except
      on OutlineError do Error(SOutlineIndexError);
    end;
    if not Node.IsVisible then Node := Node.GetVisibleParent;
    FSelectedItem := Node;
    SetRowFromNode(Node);
  end
  else Error(SOutlineSelection);
end;

function TCustomSBSOut.Insert(Index: LongInt; const Text: string): LongInt;
begin
  Result := InsertObject(Index, Text, nil);
end;

function TCustomSBSOut.InsertObject(Index: LongInt; const Text: string; const Data: Pointer): LongInt;
begin
  Result := 0;
  if Index > 0 then
    Result := AttachNode(Index, Text, Data, oaInsert)
  else if Index = 0 then AddChildObject(Index, Text, Data)
  else Error(SOutlineError);
  SetCurItem(Index);
end;

function TCustomSBSOut.Add(Index: LongInt; const Text: string): LongInt;
begin
  Result := AddObject(Index, Text, nil);
end;

function TCustomSBSOut.AddObject(Index: LongInt; const Text: string; const Data: Pointer): LongInt;
begin
  Result := 0;
  if Index > 0 then Result := AttachNode(Index, Text, Data, oaAdd)
  else If Index = 0 then Result := AddChildObject(Index, Text, Data)
  else Error(SOutlineError);
  SetCurItem(Index);
end;

function TCustomSBSOut.AddChild(Index: LongInt; const Text: string): LongInt;
begin
  Result := AddChildObject(Index, Text, nil);
end;

function TCustomSBSOut.AddChildObject(Index: LongInt; const Text: string; const Data: Pointer): LongInt;
begin
  Result := 0;
  if Index >= 0 then Result := AttachNode(Index, Text, Data, oaAddChild)
  else Error(SOutlineError);
  SetCurItem(Index);
end;

Procedure TCustomSBSOut.AssignChild(Const Value       :  TCustomSBSOut;
                                          Idx,
                                          OldIndex    :  Integer);

Var
  NewIdx,
  n          :  Integer;

  ONomRec    :  ^OutNomType;

Begin


  Begin

    n:=Value.Items[Idx].GetFirstChild;

    While (n<>-1) do
    Begin

      New(ONomRec);

      ONomRec^:=OutNomType(Value.Items[n].Data^);

      NewIdx:=AddChildObject(OldIndex,Value.Items[n].Text,ONomRec);

      If (Value.Items[n].Expanded) then
        Items[NewIdx].Expand;

      If (Value.Items[n].HasChildren) then
        AssignChild(Value,n,NewIdx);

      n:=Value.Items[Idx].GetNextChild(n);

    end; {Loop..}


  end; {With..}

end;

{$WARNINGS OFF}
Procedure TCustomSBSOut.Assign(Const Value  :  TCustomSBSOut);

Var
  NewIdx,
  n          :  Integer;

  ONomRec    :  ^OutNomType;

Begin
  InDesignMode:=True;
  StopDD:=True;

  Begin

    For n:=1 to Value.ItemCount do
      If (Value.Items[n].Level=1) then
      Begin

        New(ONomRec);

        ONomRec^:=OutNomType(Value.Items[n].Data^);

        NewIdx:=AddChildObject(0,Value.Items[n].Text,ONomRec);

        If (Value.Items[n].Expanded) then
          Items[NewIdx].Expand;

        AssignChild(Value,n,NewIdx);
      end; {If root items}

  end; {With..}

  InDesignMode:=False;
  StopDD:=False;

end;
{$WARNINGS ON}

procedure TCustomSBSOut.Delete(Index: LongInt);
begin
  if Index > 0 then
  begin
    try
      FRootNode.GetNodeAtIndex(Index).Free;
    except
      on OutlineError do Error(SOutlineIndexError);
    end;
  end
  else Error(SOutlineError);
end;

procedure TCustomSBSOut.Move(Destination, Source: LongInt; AttachMode: TAttachMode);
begin
  if (AttachMode = oaAddChild) or (Destination > 0) then
    MoveNode(Destination, Source, AttachMode)
  else Error(SOutlineError);
end;

procedure TCustomSBSOut.DeleteNode(Node: TSBSOutLNode; CurIndex: LongInt);
begin
  if (FGoodNode = FRootNode) and (FRootNode.List.Count <> 0) then
    FRootNode[0].SetGoodIndex;
  try
    FCurItem := FRootNode.GetNodeAtIndex(CurIndex);
  except
    on OutlineError do FCurItem := FRootNode;
  end;
  if (FSelectedItem = FRootNode) and (Node <> FRootNode) then
    GetSelectedItem;
  ResizeGrid;
end;

procedure TCustomSBSOut.SetLevel(Node: TSBSOutLNode; CurLevel, NewLevel: Cardinal);
var
  NumLevels: Integer;

  procedure MoveUp(Node: TSBSOutLNode; NumLevels: Cardinal);
  var
    Parent: TSBSOutLNode;
    I: Cardinal;
    Index: Integer;
  begin
    Parent := Node;
    for I := NumLevels downto 1 do
      Parent := Parent.Parent;
    Index := Parent.Parent.GetNextChild(Parent.Index);
    if Index = InvalidIndex then Node.MoveTo(Parent.Parent.Index, oaAddChild)
    else Node.MoveTo(Index, oaInsert);
  end;

  procedure MoveDown(Node: TSBSOutLNode; NumLevels: Cardinal);
  var
    Parent: TSBSOutLNode;
    I: Cardinal;
  begin
    while NumLevels > 0 do
    begin
      Parent := Node.Parent;
      for I := Parent.List.Count - 1 downto 0 do
        if Parent.Items[I].Index = Node.Index then Break;
      if I > 0 then
      begin
        Parent := Parent.Items[I - 1];
        Node.MoveTo(Parent.Index, oaAddChild);
      end else Error(SOutlineBadLevel);
      Dec(NumLevels);
    end;
  end;

begin
  NumLevels := CurLevel - NewLevel;
  if (NewLevel > 0) then
  begin
    if (NumLevels > 0) then MoveUp(Node, NumLevels)
    else MoveDown(Node, ABS(NumLevels));
  end
  else Error(SOutlineBadLevel);
end;

procedure TCustomSBSOut.Click;
begin
  if FRootNode.List.Count > 0 then
    SelectedItem := FRootNode.GetVisibleNode(Row + 1).Index;
  inherited Click;
end;

procedure TCustomSBSOut.WMSize(var Message: TWMSize);
begin
  inherited;
  if FSettingWidth or FSettingHeight then Exit;
  if (ScrollBars in [ssNone, ssVertical]) or
    ((Style = otOwnerDraw) and Assigned(FOnDrawItem)) then
    DefaultColWidth := ClientWidth
  else SetHorzScrollBar;
end;

procedure TCustomSBSOut.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if FSelectedItem <> FRootNode then
    case Key of
      '+': FSelectedItem.Expanded := True;
      '-': FSelectedItem.Expanded := False;
      '*': FSelectedItem.FullExpand;
    end;
end;

procedure TCustomSBSOut.KeyDown(var Key: Word; Shift: TShiftState);
var
  Node: TSBSOutLNode;
begin
  inherited KeyDown(Key, Shift);
  if FRootNode.List.Count = 0 then Exit;
  Node := FRootNode.GetVisibleNode(Row + 1);
  case Key of
    VK_HOME:
      begin
        SelectedItem := TSBSOutLNode(FRootNode.List.First).Index;
        Exit;
      end;
    VK_END:
      begin
        Node := TSBSOutLNode(FRootNode.List.Last);
        while Node.Expanded do
          Node := TSBSOutLNode(Node.List.Last);
        SelectedItem := Node.Index;
        Exit;
      end;
    VK_RETURN:
      begin
        Node.Expanded := not Node.Expanded;
        Exit;
      end;
    VK_MULTIPLY:
      begin
        if ssCtrl in Shift then
        begin
          FullExpand;
          Exit;
        end;
      end;
    VK_RIGHT:
      begin
        if (not Node.HasItems) or (not Node.Expanded) then MessageBeep(0)
        else SelectedItem := SelectedItem + 1;
        Exit;
      end;
    VK_LEFT:
      begin
        if Node.Parent = FRootNode then MessageBeep(0)
        else SelectedItem := Node.Parent.Index;
        Exit;
      end;
    VK_UP:
      if ssCtrl in Shift then
      begin
        with Node.Parent do
        begin
          if List.First = Node then MessageBeep(0)
          else SelectedItem := Items[List.IndexOf(Node) - 1].Index;
        end;
        Exit;
      end;
    VK_DOWN:
      if ssCtrl in Shift then
      begin
        with Node.Parent do
        begin
          if List.Last = Node then MessageBeep(0)
          else SelectedItem := Items[List.IndexOf(Node) + 1].Index;
        end;
        Exit;
      end;
  end;
  SelectedItem := FRootNode.GetVisibleNode(Row + 1).Index;
end;

procedure TCustomSBSOut.DblClick;
var
  Node: TSBSOutLNode;
begin
  inherited DblClick;
  Node := FSelectedItem;

  if Node <> FRootNode then DoExpand(Node);
end;
{$WARNINGS OFF}
procedure TCustomSBSOut.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);

var
  Node    : TSBSOutLNode;
  StartX,
  EndX    : Integer;

begin
  inherited MouseDown(Button, Shift, X, Y);
  ResetSelectedItem;

  StartX:=GetSelectedItem;


  If (fTreeReady) and  (StartX>0) then
  Begin
    Node := FSelectedItem;

    If (Assigned(Node)) and (Node.IsVisible) and (Node.ShowCheckBox) and (Assigned(Node.Data)) then {* EL Big Glyph*}
    Begin
      If (Node.Level<=High(LevelHotSpots)) then
      Begin
        StartX:=LevelHotSpots[Node.Level];
        EndX:=StartX+FPictures[Ord(obPlus)].Width;
      end
      else
      Begin
        StartX:=FPictures[Ord(obOpen)].Width+10+(10*Node.Level);
        EndX:=StartX+FPictures[Ord(obPlus)].Width+10;
      end;


      If (X>=StartX) and (X<=EndX)  and Assigned(OnNodeChkHotSpot)  then {Go and update yourself in case it affects the pics}
        OnNodeChkHotSpot(Self,Node,Node.Index);

    end;
  end;

end;
{$WARNINGS ON}
procedure TCustomSBSOut.FullExpand;
begin
  FRootNode.FullExpand;
end;

procedure TCustomSBSOut.FullCollapse;
var
  I: Integer;
begin
  for I := 0 to FRootNode.List.Count - 1 do
    FRootNode.Items[I].Expanded := False;
end;

procedure TCustomSBSOut.SetHorzScrollBar;
begin
  if (ScrollBars in [ssHorizontal, ssBoth]) and
    (UpdateCount <= 0) and not FIgnoreScrollResize and
    not ((Style = otOwnerDraw) and Assigned(FOnDrawItem)) then
    SetDisplayWidth(FRootNode.GetMaxDisplayWidth(0));
end;

procedure TCustomSBSOut.DoExpand(Node: TSBSOutLNode);
begin
  with Node do
      Expanded := not Expanded;
end;

procedure TCustomSBSOut.BeginUpdate;
begin
  if UpdateCount = 0 then SetUpdateState(True);
  Inc(UpdateCount);
end;

procedure TCustomSBSOut.EndUpdate;
begin
  Dec(UpdateCount);
  if UpdateCount = 0 then SetUpdateState(False);
end;

procedure TCustomSBSOut.SetUpdateState(Value: Boolean);
begin
  if FBlockInsert <> Value then
  begin
    FBlockInsert := Value;
    if not FBlockInsert then
    begin
      if not ResizeGrid then Invalidate;
      if FRootNode.List.Count > 0 then
        TSBSOutLNode(FRootNode.List.First).SetGoodIndex
      else
        FRootNode.SetGoodIndex;
      SetHorzScrollBar;
    end;
  end;
end;

function TCustomSBSOut.ResizeGrid: Boolean;
var
  OldRowCount: LongInt;
begin
  {* Original version pre Aug update *}
  {Result := True;
  if not FBlockInsert then
  begin
    OldRowCount := RowCount;
    FSettingHeight := True;
    try
      RowCount := FRootNode.ExpandCount;
    finally
      FSettingHeight := False;
    end;
    if RowCount = OldRowCount then Result := False;
    if FSelectedItem <> FRootNode then SelectedItem := FSelectedItem.Index;
  end;}
  
  Result := False;
  if not FBlockInsert then
  begin
    OldRowCount := RowCount;
    FSettingHeight := True;
    try
      RowCount := FRootNode.ExpandCount;
    finally
      FSettingHeight := False;
    end;
    Result := RowCount <> OldRowCount;
    if FSelectedItem <> FRootNode then SelectedItem := FSelectedItem.Index;
  end;

end;

function TCustomSBSOut.BadIndex(Value: TSBSOutLNode): Boolean;
begin
  Result := CompareNodes(Value, FGoodNode) = ocGreater;
end;

function TCustomSBSOut.SetGoodIndex(Value: TSBSOutLNode): TSBSOutLNode;
var
  ParentNode: TSBSOutLNode;
  Index: Integer;
  Compare: TOutlineNodeCompare;
begin
  Result := nil;
  Compare := CompareNodes(FGoodNode, Value);

  case Compare of
    ocLess,
    ocSame:
      Result := FGoodNode;
    ocGreater:
      begin
        ParentNode := Value.Parent;
        Index := ParentNode.List.IndexOf(Value);
        if Index <> 0 then
          Result := ParentNode[Index - 1]
        else
          Result := ParentNode;
      end;
    ocInvalid:
      Result := FRootNode;
  end;

  FGoodNode := Result;
end;

function TCustomSBSOut.CompareNodes(Value1, Value2: TSBSOutLNode): TOutlineNodeCompare;
var
  Level1: Integer;
  Level2: Integer;
  Index1: Integer;
  Index2: Integer;
  Value1ParentNode: TSBSOutLNode;
  Value2ParentNode: TSBSOutLNode;
  CommonNode: TSBSOutLNode;

  function GetParentNodeAtLevel(Value: TSBSOutLNode; Level: Integer): TSBSOutLNode;
  begin
    while Level > 0 do
    begin
      Value := Value.Parent;
      Dec(Level);
    end;
  Result := Value;
  end;

begin
  if Value1 = Value2 then
  begin
    Result := ocSame;
    Exit;
  end;

  Value1ParentNode := Value1;
  Value2ParentNode := Value2;

  Level1 := Value1.GetLevel;
  Level2 := Value2.GetLevel;

  if Level1 > Level2 then
    Value1ParentNode := GetParentNodeAtLevel(Value1, Level1 - Level2)
  else if Level2 > Level1 then
    Value2ParentNode := GetParentNodeAtLevel(Value2, Level2 - Level1);

  while Value1ParentNode.Parent <> Value2ParentNode.Parent do
  begin
    Value1ParentNode := Value1ParentNode.Parent;
    Value2ParentNode := Value2ParentNode.Parent;
  end;

  CommonNode := Value1ParentNode.Parent;
  if CommonNode <> nil then
  begin
    Index1 := CommonNode.List.IndexOf(Value1ParentNode);
    Index2 := CommonNode.List.IndexOf(Value2ParentNode);
    if Index1 < Index2 then Result := ocLess
    else if Index2 < Index1 then Result := ocGreater
    else begin
      if Level1 > Level2 then Result := ocGreater
      else if Level1 = Level2 then Result := ocSame
      else Result := ocLess;
    end
  end
  else
    Result := ocInvalid;
end;

function TCustomSBSOut.GetDataItem(Value: Pointer): Longint;
begin
  Result := FRootNode.GetDataItem(Value);
end;

function TCustomSBSOut.GetItem(X, Y: Integer): LongInt;
var
  Value: TGridCoord;
begin
  Result := -1;
  Value := MouseCoord(X, Y);
  with Value do
   if (Y > 0) or (FRootNode.List.Count > 0) then
     Result := FRootNode.GetVisibleNode(Y + 1).Index;
end;

function TCustomSBSOut.GetTextItem(const Value: string): Longint;
begin
  Result := FRootNode.GetTextItem(Value);
end;

procedure TCustomSBSOut.SetCurItem(Value: LongInt);
begin
  if Value < 0 then Error(SInvalidCurrentItem);
  if not IsCurItem(Value) then
    try
      FCurItem := FRootNode.GetNodeAtIndex(Value);
    except
      on OutlineError do Error(SOutlineIndexError);
    end;
end;

procedure TCustomSBSOut.SetOutlineStyle(Value: TOutlineStyle);
begin
  if FOutlineStyle <> Value then
  begin
    FOutlineStyle := Value;
    SetHorzScrollBar;
    Invalidate;
  end;
end;

procedure TCustomSBSOut.CMFontChanged(var Message: TMessage);
begin
  inherited;
  SetRowHeight;
  SetHorzScrollBar;
end;

procedure TCustomSBSOut.SetDisplayWidth(Value: Integer);
begin
  FSettingWidth := True;
  try
    if DefaultColWidth <> Value then DefaultColWidth := Value;
  finally
    FSettingWidth := False;
  end;
end;
{$WARNINGS OFF}
function TCustomSBSOut.GetNodeDisplayWidth(Node: TSBSOutLNode): Integer;
var
  Delta: Integer;
  TextLength: Integer;
  Pad4Chk  :  Integer; {* EL Big Glyph*}
begin
  Result := 0;
  Delta := (DefaultRowHeight - FFontSize) div 2;

  with Canvas do
  begin
    Font := Self.Font;
    TextLength := TextWidth(Node.Text) + 1;
  end;

  Pad4Chk:=(10+(5*Ord(Node.GetLevel>1)))*Ord(Node.ShowCheckBox); {* EL Big Glyph*}
  //Pad4Chk:=10+(5*Ord(Node.GetLevel>1)); {* EL Big Glyph*}

  case OutlineStyle of
    osText: Inc(Result, DefaultRowHeight * (Node.Level - 1));
    osPlusMinusPictureText: Inc(Result, DefaultRowHeight * (Node.Level + 1));
    osPlusMinusText,
    osPictureText: Inc(Result, DefaultRowHeight * Node.Level);
    osTreeText:
      begin
        Inc(Result, DefaultRowHeight * (Node.Level - 1) - Delta);
        if ooDrawTreeRoot in Options then Inc(Result, DefaultRowHeight);
      end;
    osTreePictureText:
      begin
        Inc(Result, DefaultRowHeight * (Node.Level) - Delta);
        if ooDrawTreeRoot in Options then Inc(Result, DefaultRowHeight+ItemSpace+Pad4Chk);
      end;
  end;
  Inc(Result, TextLength);
  if Result < 0 then Result := 0;
end;
{$WARNINGS ON}

procedure TCustomSBSOut.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
var
  Node: TSBSOutLNode;
  Expanded: Boolean;
  HasChildren: Boolean;
  IndentLevel: Word;
  Bitmap1, Bitmap2: TBitmap;
//  TextLength: Integer;
  Delta: Integer;
  InitialLeft: Integer;
  Pad4Chk    :  Integer; {* EL Big Glyph*}
  OrigArect,
  TextRect   :  TRect;

  ONomRec    :  ^OutNomType;

  function GetBitmap(Value: TOutlineBitmap): TBitmap;
  begin
    Result := FPictures[Ord(Value)];
  end;

  procedure DrawFocusCell;

  begin
    {Inc(ARect.Right, TextLength+200);}

    ARect.Right:=OrigARect.Right;

    ARect.Left:=ARect.Left-1;

    if (Row = ARow) and (Node.Text <> '') then
      Canvas.FillRect(ARect);

    ARect.Left:=ARect.Left+1;
  end;


  procedure DrawHLCell;

  Var
    FocusRect  :  TRect;

  begin
    {Inc(ARect.Right, TextLength+200);}
    FocusRect:=ARect;

    FocusRect.Right:=OrigARect.Right;
    FocusRect.Bottom:=FocusRect.Top+DefaultRowHeight;
    Inc(FocusRect.Left, DefaultRowHeight * (IndentLevel -1) - Delta);

    if ooDrawTreeRoot in Options then Inc(FocusRect.Left, DefaultRowHeight);

    FocusRect.Left := FocusRect.Left + DefaultRowHeight+ItemSpace+Pad4Chk-1;   {* EL Big Glyph*}


    if (Row <> ARow) and (Node.Text <> '') then
    Begin
      Canvas.FillRect(FocusRect);

      //ShowMessage('Left : '+IntToStr(FocusRect.Left)+'. Indent '+IntToStr(IndentLevel));
    end;
  end;


  procedure DrawTheValue(Const BlankZ  :  Boolean;
                         Const Value   :  Double;
                         Const GFmt    :  ShortString;
                               MR      :  TRect);

  Const
    GenRealMask   =  '###,###,###,##0.00 ;###,###,###,##0.00-';
    GenNDMask     =  '###,###,###,##0 ;###,###,###,##0-';

    LargeValMask  =  999999999999.99;

  VAR
      R         : TRect;
      S         : String;
      ND        : Integer;

      NomVal    : Double;

      ThisMask  : String[80];


  begin
    NomVal:=Value;

    If (GFmt='') then
    Begin
      {If (ABS(Value)>(LargeValMask/10)) then
        ThisMask:=GenNDMask
      else}
        ThisMask:=GenRealMask
    end
    else
      ThisMask:=GFmt;



    With Canvas do
    Begin

      MR.Right:=ColsX;

      MR.Left:=MR.Right-(TextWidth(FormatFloat(ThisMask,LargeValMask))+10);

      R := MR;

      If (Value<>0) or (Not BlankZ) then
      Begin

        SetTextAlign(Handle, TA_RIGHT); {Windows API function}

        S := FormatFloat(ThisMask,NomVal);

        ND:=DecFromStr(S);

        If (Pos('.', S) > 0) THEN
          R.Right := R.Right - TextWidth(DecimalSeparator+ConstStr('0',ND));

        R.Right:=R.Right-4;

        IF Pos('.', S) > 0 THEN
          S := Copy(S, 1, Pos(DecimalSeparator, S)-1);

        TextRect(R, R.Right, R.Top, S); {note R.Right, not R.Left}

        {S := Form_Real(NomVal,0,2);}
        S := FormatFloat(ThisMask,NomVal);


        IF Pos('.', S) > 0 THEN
          S := Copy(S, Pos(DecimalSeparator, S), 255)
        ELSE
          {S := DecimalSeparator;}  S:='';

        SetTextAlign(Handle, TA_LEFT);
        R.Left := R.Right;
        R.Right := MR.Right;
        TextRect(R, R.Left, R.Top, S);
      end
      else
      Begin
        Canvas.FillRect(R);
      end;

    end; {With..}
  end;


  procedure DrawValue(MR  :  TRect);

  Var
    n     :  Integer;

  Begin
    If (ItemCount>0) then {* Show balances *}
    Begin
      CalcIdx:=Node.Index;

      If (CalcIdx>0) then
      Begin
        If (ShowValCol>0)  then
        Begin

          For n:=1 to ShowValCol do
          Begin
            SetCol:=n;
            ColValue:=0.00;

            If Assigned(OnNeedValue) then
              OnNeedValue(Self);

            DrawTheValue(True,ColValue,ColFmt,MR);

          end;
        end;
      end;

    end;
  end; {Proc..}


  procedure DrawTheText;
  begin

    Inc(ARect.Left,( DefaultRowHeight * (IndentLevel - 1)));
    ARect.Right := ARect.Left;
    DrawFocusCell;
    DrawText(Node, ARect);
  end;




  procedure DrawPlusMinusPicture;
  begin
    Inc(ARect.Left, DefaultRowHeight * (IndentLevel - 1));
    if HasChildren then
    begin
      if Expanded then
      begin
        Bitmap1 := GetBitmap(obMinus);
        Bitmap2 := GetBitmap(obOpen);
      end
      else begin
        Bitmap1 := GetBitmap(obPlus);
        Bitmap2 := GetBitmap(obClose);
      end;
    end
    else begin
      Bitmap1 := nil;
      Bitmap2 := GetBitmap(obLeaf);
    end;
    ARect.Left := ARect.Left + DefaultRowHeight * 2;
    ARect.Right := ARect.Left;
    DrawFocusCell;
    DrawText(Node, ARect);
    Dec(ARect.Left, DefaultRowHeight * 2);
    DrawPictures([Bitmap1, Bitmap2], ARect,IndentLevel);
  end;

  procedure DrawPictureText;
  var
    Style: TOutlineBitmap;
  begin
    Inc(ARect.Left, DefaultRowHeight * (IndentLevel - 1));
    if HasChildren then
    begin
      if Expanded then Style := obOpen
      else Style := obClose
    end
    else Style := obLeaf;
    Bitmap1 := GetBitmap(Style);
    ARect.Left := ARect.Left + DefaultRowHeight;
    ARect.Right := ARect.Left;
    DrawFocusCell;
    DrawText(Node, ARect);
    Dec(ARect.Left, DefaultRowHeight);
    DrawPictures([Bitmap1], ARect,IndentLevel);
  end;

  procedure DrawPlusMinusText;
  var
    Style: TOutlineBitmap;
  begin
    Inc(ARect.Left, DefaultRowHeight * IndentLevel);
    ARect.Right := ARect.Left;
    DrawFocusCell;
    DrawText(Node, ARect);
    if HasChildren then
    begin
      if Expanded then Style := obMinus
      else Style := obPlus;
      Bitmap1 := GetBitmap(Style);
      Dec(ARect.Left, DefaultRowHeight);
      DrawPictures([Bitmap1], ARect,IndentLevel);
    end;
  end;

  procedure DrawTheTree;
  begin
    DrawTree(ARect, Node);
    Inc(ARect.Left, DefaultRowHeight * (IndentLevel - 1) - Delta);
    if ooDrawTreeRoot in Options then Inc(ARect.Left, DefaultRowHeight);
    ARect.Right := ARect.Left + Delta;
    DrawFocusCell;
    Inc(ARect.Left, Delta);
    DrawText(Node, ARect);
  end;

  procedure DrawTreePicture;
  var
    Style: TOutlineBitmap;
  begin
    DrawTree(ARect, Node);
    Inc(ARect.Left, DefaultRowHeight * (IndentLevel -1) - Delta);
    if ooDrawTreeRoot in Options then Inc(ARect.Left, DefaultRowHeight);
    ARect.Left := ARect.Left + DefaultRowHeight+ItemSpace+Pad4Chk;   {* EL Big Glyph*}
    ARect.Right := ARect.Left + Delta;

    //ARect.Right:=ARect.Right+ DefaultRowHeight+ItemSpace+Pad4Chk;   {* EL Big Glyph*}

    DrawFocusCell;

    //SetTextAlign(Canvas.Handle, TA_LEFT);

    //Canvas.TextRect(ARect, ARect.Left, ARect.Top, Node.Text);

    TextRect:=ARect;

    DrawText(Node, ARect);

    Dec(ARect.Left, (DefaultRowHeight - Delta)+ItemSpace+Pad4Chk); {* EL Big Glyph*}

    If (IndentLevel=1) then {* Descrease level 0 again *}
      Dec(ARect.Left, 3);

    if HasChildren then
    begin
      if Expanded then Style := obOpen
      else Style := obClose;
    end
    else
    Begin
      If (Node.UseLeafx<>obPlus) then
        Style := Node.UseLeafx {* EL Big Glyph*}
      else
        Style:=obLeaf;
    end;

    Bitmap1 := GetBitmap(Style);

    If (Node.ShowCheckBox) then {* EL Big Glyph*}
    Begin
      If (Node.CheckBoxChecked) then
        Bitmap2:=GetBitmap(obPlus)
      else
        Bitmap2:=GetBitmap(obMinus);
    end
    else
      Bitmap2:=nil;

    DrawPictures([Bitmap1,BitMap2], ARect,IndentLevel);      {* EL Big Glyph*}
  end;

begin

  OrigARect:=ARect;

  if FRootNode.List.Count = 0 then
  begin
    with Canvas do
    begin
      Brush.Color := Color;
      FillRect(ARect);
    end;
    Exit;
  end;

  if (Style = otOwnerDraw) and Assigned(FOnDrawItem) then
  begin
    if Row = ARow then
    begin
      if GetFocus = Self.Handle then
      begin
        FOnDrawItem(Self, ARow, ARect, [odFocused, odSelected]);
        if ooDrawFocusRect in Options then
          DrawFocusRect(Canvas.Handle, ARect);
      end
      else FOnDrawItem(Self, ARow, ARect, [odSelected])
    end
    else OnDrawItem(Self, ARow, ARect, []);
    Exit;
  end;

  InitialLeft := ARect.Left;
  Delta := (ARect.Bottom - ARect.Top - FFontSize) div 2;


  Node := FRootNode.GetVisibleNode(ARow + 1);

  If Assigned(OnUpdateNode) and (Assigned(Node)) then {Go and update yourself in case it affects the pics}
    OnUpdateNode(Self,Node,ARow);

  Expanded := Node.Expanded;
  HasChildren := Node.HasItems;

  // MH 07/08/07: Increased from 10 to 12 as the graphics are slightly bigger for v6.00 and
  // on Chris' machine they were clipping the text 
  Pad4Chk:=(12+(5*Ord(Node.GetLevel>1)))*Ord(Node.ShowCheckBox); {* EL Big Glyph*}
  //Pad4Chk:=10+(5*Ord(Node.GetLevel>1)); {* EL Big Glyph*}

  ONomRec:=Node.Data;


  with Canvas do
  begin
    Font := Self.Font;
    Brush.Color := Color;
    FillRect(ARect);
//    TextLength := TextWidth(Node.Text) + 1; {* EL Big Glyph*}
    if Row = ARow then
    begin
      Brush.Color := BarColor;
      Font.Color := BarTextColor;
    end;

    If (Expanded) and (HasChildren) then
    Begin
      Font.Style:= [fsBold];
    end
    else
    Begin
      If (ONomRec<>nil) then
      Begin
        If (ONomRec^.HedTotal) then
          Font.Style:=[fsBold,fsUnderline]
        else
          If (ONomRec^.MoreLink) then
            Font.Style:=[fsBold]
          else
            If (ONomRec^.ShowAsBar) and (Row<>ARow) then
            Begin
              Brush.Color := HLBarColor;
              Font.Color := HLBarTextColor;
              IndentLevel := Node.GetLevel;

              DrawHLCell;
            end;
      end;
    end;
  end;

  IndentLevel := Node.GetLevel;

  TextRect:=Arect;


  case OutlineStyle of
    osText: DrawTheText;
    osPlusMinusText: DrawPlusMinusText;
    osPlusMinusPictureText: DrawPlusMinusPicture;
    osPictureText: DrawPictureText;
    osTreeText: DrawTheTree;
    osTreePictureText: DrawTreePicture;
  end;

  DrawValue(TextRect);

  if (Row = ARow) and (Node.Text <> '') then
  begin
    ARect.Left := InitialLeft + DefaultRowHeight * (IndentLevel - 1);
    if OutlineStyle >= osTreeText then
    begin
      Dec(ARect.Left, Delta);
      if ooDrawTreeRoot in Options then Inc(ARect.Left, DefaultRowHeight);
    end;
    if (OutlineStyle <> osText) and (OutlineStyle <> osTreeText) then
      Inc(ARect.Left, DefaultRowHeight+ItemSpace+Pad4Chk); {* EL Big Glyph*}
    if OutlineStyle = osPlusMinusPictureText then
      Inc(ARect.Left, DefaultRowHeight);
    if (GetFocus = Self.Handle) and (ooDrawFocusRect in Options) then
      DrawFocusRect(Canvas.Handle, ARect);
  end;

  If Assigned(FOnDrawItem) then
    OnDrawItem(Self, ARow+1, ARect, []);

end;

procedure TCustomSBSOut.DrawTree(ARect: TRect; Node: TSBSOutLNode);
var
  Offset: Word;
  Height: Word;
  OldPen: TPen;

  I: Integer;
  ParentNode: TSBSOutLNode;
  IndentLevel: Integer;

Procedure DrawDots(FromX,X,FromY,Y  :  Integer); {* EL Big Glyph*}

Var
  DotOn  :  Byte;
  n,m    :  Integer;

Begin
  DotOn:=0;

  For n:=FromX to X do
  With Canvas do
  Begin
    Inc(DotOn);

    If (DotOn>1) then
      DotOn:=0;

    If (DotOn=1)  then
      Pen.Color:=TreeColor
    else
    Begin
      Pen.Color:=Self.Color;
    end;

    LineTo(N,FromY);
  end; {Loop..}

  Canvas.MoveTo(FromX,FromY);

  DotOn:=0;

  For m:=FromY to Y do
  With Canvas do
  Begin
    Inc(DotOn);

    If (DotOn>1) then
      DotOn:=0;

    If (DotOn=1)  then
      Pen.Color:=TreeColor
    else
      Pen.Color:=Self.Color;

    LineTo(FromX,m);
  end; {Loop..}

end;




begin
  Offset := DefaultRowHeight div 2;
  Height := ARect.Bottom;
  IndentLevel := Node.GetLevel;
  I := IndentLevel - 3;
  if ooDrawTreeRoot in Options then Inc(I);
  OldPen := TPen.Create;
  try
    OldPen.Assign(Canvas.Pen);
    with Canvas do
    begin
      Pen.Color := TreeColor;   {* EL Big Glyph*}
      Pen.Width := 1;
      Pen.Style:=psSolid;      {* EL Big Glyph*}
      try
        ParentNode := Node.Parent;
        while (ParentNode.Parent <> nil) and
          ((ooDrawTreeRoot in Options) or
          (ParentNode.Parent.Parent <> nil)) do
        begin
          with ParentNode.Parent do
          begin
            if List.IndexOf(ParentNode) < List.Count - 1 then
            begin
              Canvas.MoveTo(ARect.Left + DefaultRowHeight * I + Offset, ARect.Top);
              //Canvas.LineTo(ARect.Left + DefaultRowHeight * I + Offset, Height); {* EL Big Glyph*}

              DrawDots(ARect.Left + DefaultRowHeight * I+ Offset,ARect.Left + DefaultRowHeight * I,Arect.Top,Height); {* EL Big Glyph*}

            end;
          end;
          ParentNode := ParentNode.Parent;
          Dec(I);
        end;

        with Node.Parent do
          if List.IndexOf(Node) = List.Count - 1 then
            Height := ARect.Top + Offset;

        if (ooDrawTreeRoot in Options) or (IndentLevel > 1) then
        begin
          if not (ooDrawTreeRoot in Options) then Dec(IndentLevel);
          with ARect do
          begin
            Inc(Left, DefaultRowHeight * (IndentLevel - 1));
            MoveTo(Left + Offset, Top);
            // LineTo(Left + Offset, Height);

            {* EL Big Glyph*}

            DrawDots(Left+OffSet,Left+OffSet,Top,Height);

            MoveTo(Left + Offset-1, Top + Offset);
            //LineTo(Left + Offset + FFontSize div 2, Top + Offset); {* EL Big Glyph*}

            DrawDots(Left+OffSet-1,Left + Offset + FFontSize div 2 +2,Top+Offset,Top+OffSet);

            {* EL Big Glyph*}{This entire section rewritten}
          end;
        end;
      finally
        Pen.Assign(OldPen);
      end;
    end;
  finally
    OldPen.Destroy;
  end;
end;

procedure TCustomSBSOut.DrawPictures(BitMaps: array of TBitmap; ARect: TRect;
                                     IndentLevel  :  Integer);
var
  I: Word;
  Rect: TRect;
  Value: TBitmap;
  Offset: Word;
  Delta: Integer;
  OldTop: Integer;
  OldColor: TColor;
begin
  OldColor := Canvas.Brush.Color;
  Canvas.Brush.Color := Color;
  Offset := (DefaultRowHeight - FFontSize) div 2;
  Rect.Top := ARect.Top {+ Offset}+2;
  Rect.Bottom := Rect.Top + FFontSize;
  for I := Low(Bitmaps) to High(Bitmaps) do
  begin
    Value := BitMaps[I];
    Rect.Left := ARect.Left + Offset;
    Rect.Right := Rect.Left + FFontSize;
    Inc(ARect.Left, DefaultRowHeight);
    if Value <> nil then
    begin
      if not (ooStretchBitmaps in Options) then
      begin
        {if Rect.Top + Value.Height < Rect.Bottom then}
        Rect.Bottom := Rect.Top + Value.Height;
        {if Rect.Left + Value.Width < Rect.Right then} {* EL Big Glyph*}
          Rect.Right := Rect.Left + Value.Width;
        Delta := (FFontSize - (Rect.Bottom - Rect.Top)) div 2;
        if Delta > 0 then
        begin
          Delta := (DefaultRowHeight - (Rect.Bottom - Rect.Top)) div 2;
          OldTop := Rect.Top;
          Rect.Top := ARect.Top + Delta;
          Rect.Bottom := Rect.Bottom - OldTop + Rect.Top;
        end;
        Canvas.BrushCopy(Rect, Value,
          Bounds(0, 0, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top),
          Value.TransparentColor);
      end else
        Canvas.BrushCopy(Rect, Value,
          Bounds(0, 0, Value.Width, Value.Height),
          Value.TransparentColor);

      If (I=1) and (IndentLevel<=High(LevelHotSpots)) then
      Begin
        LevelHotSpots[IndentLevel]:=Rect.Left;
      end;
    end;
  end;
  Canvas.Brush.Color := OldColor;
end;

procedure TCustomSBSOut.DrawText(Node: TSBSOutLNode; Rect: TRect);
begin
  If (Not HideText) then
    Windows.DrawText(Canvas.Handle, PChar(Node.Text), Length(Node.Text), Rect,
                     DT_LEFT or DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
end;

function TCustomSBSOut.StoreBitmap(Index: Integer): Boolean;
begin
  Result := TOutlineBitmap(Index) in FUserBitmaps;
end;

procedure TCustomSBSOut.ClearBitmap(var Bitmap: TBitmap; Kind: TOutlineBitmap);
begin
  if Bitmap <> nil then
  begin
    Bitmap.Free;
    Bitmap := nil;
  end;
end;

procedure TCustomSBSOut.ChangeBitmap(Value: TBitmap; Kind: TOutlineBitmap);
var
  Bitmap: ^TBitmap;
begin
  Bitmap := @FPictures[Ord(Kind)];
  Include(FUserBitmaps, Kind);
  if Value = nil then ClearBitmap(Bitmap^, Kind)
  else Bitmap^.Assign(Value);
  Invalidate;
end;

procedure TCustomSBSOut.SetPicture(Index: Integer; Value: TBitmap);
begin
  ChangeBitmap(Value, TOutlineBitmap(Index));
end;

function TCustomSBSOut.GetPicture(Index: Integer): TBitmap;
begin
  if csLoading in ComponentState then
    Include(FUserBitmaps, TOutlineBitmap(Index));
  Result := FPictures[Index];
end;

procedure TCustomSBSOut.LoadFromFile(const FileName: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;
{
procedure TCustomSBSOut.SetMaskColor(Value: TColor);
begin
  FMaskColor := Value;
  Invalidate;
end;
}
procedure TCustomSBSOut.SetItemHeight(Value: Integer);
begin
  FItemHeight := Value;
  if Style <> otOwnerDraw then SetRowHeight
  else begin
    DefaultRowHeight := ItemHeight;
    FFontSize := MulDiv(ItemHeight, 100, 120);
    Invalidate;
  end;
end;

procedure TCustomSBSOut.SetStyle(Value: TOutlineType);
begin
  if Style <> Value then
  begin
    FStyle := Value;
    if Value = otStandard then SetRowHeight;
  end;
end;

procedure TCustomSBSOut.SetOutlineOptions(Value: TOutlineOptions);
begin
  if Value <> FOptions then
  begin
    FOptions := Value;
    Invalidate;
  end;
end;

function LineStart(Buffer, BufPos: PChar): PChar;
begin
  if BufPos - Buffer - 2 > 0 then
  begin
    Dec(BufPos, 2);
    while (BufPos^ <> #$0D) and (BufPos > Buffer) do Dec(BufPos);
    if BufPos > Buffer then
    begin
      Inc(BufPos);
      if BufPos^ = #$0A then Inc(BufPos);
    end;
    Result := BufPos;
  end
  else Result := Buffer;
end;

function GetString(BufPtr: PChar; var S: string): PChar;
var
  Start: PChar;
begin
  Start := BufPtr;
  while not (BufPtr^ in [#13, #26]) do Inc(BufPtr);
  SetString(S, Start, Integer(BufPtr - Start));
  if BufPtr^ = #13 then Inc(BufPtr);
  if BufPtr^ = #10 then Inc(BufPtr);
  Result := BufPtr;
end;

procedure TCustomSBSOut.LoadFromStream(Stream: TStream);
const
  EOF = Chr($1A);
  BufSize = 4096;
var
  Count: Integer;
  Buffer, BufPtr, BufEnd, BufTop: PChar;
  ParentNode, NewNode: TSBSOutLNode;
  Str: string;
  Level, OldLevel: Cardinal;
  I: Integer;
begin
  GetMem(Buffer, BufSize);
  try
    OldLevel := 0;
    Clear;
    ParentNode := FRootNode;
    BufEnd := Buffer + BufSize;
    BufTop := BufEnd;
    repeat
      Count := BufEnd - BufTop;
      if Count <> 0 then System.Move(BufTop[0], Buffer[0], Count);
      BufTop := Buffer + Count;
      Inc(BufTop, Stream.Read(BufTop[0], BufEnd - BufTop));
      if BufTop < BufEnd then BufTop[0] := EOF else
      begin
        BufTop := LineStart(Buffer, BufTop);
        if BufTop = Buffer then Error(SOutlineLongLine);
      end;
      BufPtr := Buffer;
      while (BufPtr < BufTop) and (BufPtr[0] <> EOF) do
      begin
        BufPtr := GetBufStart(BufPtr, Level);
        BufPtr := GetString(BufPtr, Str);
        NewNode := TSBSOutLNode.Create(Self);
        try
          NewNode.Text := Str;
          if (Level > OldLevel) or (ParentNode = FRootNode) then
          begin
            if Level - OldLevel > 1 then Error(SOutlineFileLoad);
          end
          else
          begin
            for I := OldLevel downto Level do
            begin
              ParentNode := ParentNode.Parent;
              if ParentNode = nil then Error(SOutlineFileLoad);
            end;
          end;
          ParentNode.List.Add(NewNode);
          NewNode.FParent := ParentNode;
          ParentNode := NewNode;
          OldLevel := Level;
        except
          NewNode.Free;
          Raise;
        end;
      end;
    until (BufPtr < BufEnd) and (BufPtr[0] = EOF);
  finally
    FreeMem(Buffer, BufSize);
    if not (csLoading in ComponentState) then Loaded;
  end;
end;

procedure TCustomSBSOut.Loaded;
var
  Item: TOutlineBitmap;
begin
  inherited Loaded;
  with FRootNode do
  begin
    FExpandCount := List.Count;
    Row := 0;
    ResetSelectedItem;
    if not ResizeGrid then Invalidate;
    if List.Count > 0 then
    begin
      TSBSOutLNode(List.First).SetGoodIndex;
      FSelectedItem := List.First;
    end;
    if csDesigning in ComponentState then FullExpand;
  end;
  for Item := obPlus to obLeaf do
    if (Item in FOldBitmaps) and not (Item in FUserBitmaps) then
      ChangeBitmap(nil, Item);
  FOldBitmaps := [];
  SetHorzScrollBar;
end;

procedure TCustomSBSOut.SaveToFile(const FileName: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TCustomSBSOut.SaveToStream(Stream: TStream);
const
  BufSize = 4096;
var
  Buffer: PChar;
begin
  GetMem(Buffer, BufSize);
  try
    FRootNode.WriteNode(Buffer, Stream);
  finally
    FreeMem(Buffer, BufSize);
  end;
end;

procedure TCustomSBSOut.SetStrings(Value: TStrings);
begin
  FStrings.Assign(Value);
  if csDesigning in ComponentState then FRootNode.FullExpand;
  SetHorzScrollBar;
end;

function TCustomSBSOut.GetStrings: TStrings;
begin
  Result := FStrings;
end;

procedure TCustomSBSOut.Error(const ErrorString: string);
begin
  Raise EOutlineError.Create(ErrorString);
end;


procedure TCustomSBSOut.Expand(Index: LongInt);
begin
  if Assigned(FOnExpand) then FOnExpand(Self, Index);
end;

procedure TCustomSBSOut.Collapse(Index: LongInt);
begin
  if Assigned(FOnCollapse) then FOnCollapse(Self, Index);
end;


{ ========= Function to manipulate by data ======== }

Function TCustomSBSOut.FindxNCode(NCode  :  Pointer)  :  Integer;

Var
  n          :  Integer;
  FoundOk    :  Boolean;

Begin
  Result:=-1;

  n:=1;

  FoundOk:=False;

  While (n<=ItemCount) and (Not FoundOk)  do
  Begin
    FoundOk:=((OutNomType(Items[n].Data^).OutNomCode=OutNomType(NCode^).OutNomCode)
           and (OutNomType(Items[n].Data^).HedTotal=OutNomType(NCode^).HedTotal));

    {$IFDEF JC}
      If (FoundOk) and (OutNomType(Items[n].Data^).OutJTNo<>0) then
        FoundOk:=(OutNomType(Items[n].Data^).OutStkCode=OutNomType(NCode^).OutStkCode);
    {$ENDIF}


    If (Not FoundOk) then
      Inc(n);
  end;

  If (FoundOk) then
    Result:=n;

end;

Procedure TCustomSBSOut.ExpandxNCode(NCode  :  Pointer;
                                     ExPCol :  Boolean);

Var
  n  :  Integer;

Begin

  n:=FindxNCode(NCode);

  If (n<>-1) then
  With Items[n] do
    If (IsVisible) then
      Case ExpCol of

        False  :  Collapse;
        True   :  Expand;

      end; {Case..}

end;



{***********************************************************************************}
{*                                                                                 *}
{* Functions for TSBSOutlineC                                                      *}
{*                                                                                 *}
{***********************************************************************************}
procedure TSBSOutlineC.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
var
  Node: TSBSOutLNode;
  Expanded: Boolean;
  HasChildren: Boolean;
  IndentLevel: Word;
  Bitmap1, Bitmap2: TBitmap;
//  TextLength: Integer;
  Delta: Integer;
  InitialLeft: Integer;
  Pad4Chk    :  Integer; {* EL Big Glyph*}
  OrigArect,
  TextRect   :  TRect;

  ONomRec    :  ^OutNomType;

  function GetBitmap(Value: TOutlineBitmap): TBitmap;
  begin
    Result := FPictures[Ord(Value)];
  end;

  procedure DrawFocusCell;
  begin
    {Inc(ARect.Right, TextLength+200);}

    ARect.Right:=OrigARect.Right;

    ARect.Left:=ARect.Left-1;

    if (Row = ARow) and (Node.Text <> '') then
      Canvas.FillRect(ARect);

    ARect.Left:=ARect.Left+1;
  end;


  procedure DrawHLCell;

  Var
    FocusRect  :  TRect;

  begin
    {Inc(ARect.Right, TextLength+200);}
    FocusRect:=ARect;

    FocusRect.Right:=OrigARect.Right;
    FocusRect.Bottom:=FocusRect.Top+DefaultRowHeight;
    Inc(FocusRect.Left, DefaultRowHeight * (IndentLevel -1) - Delta);

    if ooDrawTreeRoot in Options then Inc(FocusRect.Left, DefaultRowHeight);

    FocusRect.Left := FocusRect.Left + DefaultRowHeight+ItemSpace+Pad4Chk-1;   {* EL Big Glyph*}


    if (Row <> ARow) and (Node.Text <> '') then
    Begin
      Canvas.FillRect(FocusRect);

      //ShowMessage('Left : '+IntToStr(FocusRect.Left)+'. Indent '+IntToStr(IndentLevel));
    end;
  end;


  procedure DrawTheValue(Const Value   :  ShortString;
                               MR      :  TRect);

  Const
    GenRealMask   =  '###,###,###,##0.00 ;###,###,###,##0.00-';
    LargeValMask  =  '999999999999.99';
  VAR
      R         : TRect;
      S         : String;
  begin
    With Canvas Do Begin
      MR.Left  := ColsX;
      MR.Right := MR.Left + TextWidth('WwWwWwWwWWwWwWwwWwWwWwWwWw') + 10;

      R := MR;

      S := ColValue;

      SetTextAlign(Handle, TA_LEFT);
      TextRect(R, R.Left, R.Top, S);
    end; {With..}
  end;


  procedure DrawValue(MR  :  TRect);

  Var
    n     :  Integer;

  Begin
    If (ItemCount>0) then {* Show balances *}
    Begin
      CalcIdx:=Node.Index;

      If (ShowValCol>0) and (CalcIdx>0) then
      Begin

        For n:=1 to ShowValCol do
        Begin
          SetCol:=n;
          ColValue:='';

          If Assigned(OnNeedValue) then
            OnNeedValue(Self);

          DrawTheValue(ColValue, MR);
        end;
      end;

    end;
  end; {Proc..}


  procedure DrawTheText;
  begin

    Inc(ARect.Left, DefaultRowHeight * (IndentLevel - 1));
    ARect.Right := ARect.Left;
    DrawFocusCell;
    DrawText(Node, ARect);
  end;




  procedure DrawPlusMinusPicture;
  begin
    Inc(ARect.Left, DefaultRowHeight * (IndentLevel - 1));
    if HasChildren then
    begin
      if Expanded then
      begin
        Bitmap1 := GetBitmap(obMinus);
        Bitmap2 := GetBitmap(obOpen);
      end
      else begin
        Bitmap1 := GetBitmap(obPlus);
        Bitmap2 := GetBitmap(obClose);
      end;
    end
    else begin
      Bitmap1 := nil;
      Bitmap2 := GetBitmap(obLeaf);
    end;
    ARect.Left := ARect.Left + DefaultRowHeight * 2;
    ARect.Right := ARect.Left;
    DrawFocusCell;
    DrawText(Node, ARect);
    Dec(ARect.Left, DefaultRowHeight * 2);
    DrawPictures([Bitmap1, Bitmap2], ARect,IndentLevel);
  end;

  procedure DrawPictureText;
  var
    Style: TOutlineBitmap;
  begin
    Inc(ARect.Left, DefaultRowHeight * (IndentLevel - 1));
    if HasChildren then
    begin
      if Expanded then Style := obOpen
      else Style := obClose
    end
    else Style := obLeaf;
    Bitmap1 := GetBitmap(Style);
    ARect.Left := ARect.Left + DefaultRowHeight;
    ARect.Right := ARect.Left;
    DrawFocusCell;
    DrawText(Node, ARect);
    Dec(ARect.Left, DefaultRowHeight);
    DrawPictures([Bitmap1], ARect,IndentLevel);
  end;

  procedure DrawPlusMinusText;
  var
    Style: TOutlineBitmap;
  begin
    Inc(ARect.Left, DefaultRowHeight * IndentLevel);
    ARect.Right := ARect.Left;
    DrawFocusCell;
    DrawText(Node, ARect);
    if HasChildren then
    begin
      if Expanded then Style := obMinus
      else Style := obPlus;
      Bitmap1 := GetBitmap(Style);
      Dec(ARect.Left, DefaultRowHeight);
      DrawPictures([Bitmap1], ARect,IndentLevel);
    end;
  end;

  procedure DrawTheTree;
  begin
    DrawTree(ARect, Node);
    Inc(ARect.Left, DefaultRowHeight * (IndentLevel - 1) - Delta);
    if ooDrawTreeRoot in Options then Inc(ARect.Left, DefaultRowHeight);
    ARect.Right := ARect.Left + Delta;
    DrawFocusCell;
    Inc(ARect.Left, Delta);
    DrawText(Node, ARect);
  end;

  procedure DrawTreePicture;
  var
    Style: TOutlineBitmap;
  begin
    DrawTree(ARect, Node);
    Inc(ARect.Left, DefaultRowHeight * (IndentLevel -1) - Delta);
    if ooDrawTreeRoot in Options then Inc(ARect.Left, DefaultRowHeight);
    ARect.Left := ARect.Left + DefaultRowHeight+ItemSpace+Pad4Chk;   {* EL Big Glyph*}
    ARect.Right := ARect.Left + Delta;

    //ARect.Right:=ARect.Right+ DefaultRowHeight+ItemSpace+Pad4Chk;   {* EL Big Glyph*}

    DrawFocusCell;

    //SetTextAlign(Canvas.Handle, TA_LEFT);

    //Canvas.TextRect(ARect, ARect.Left, ARect.Top, Node.Text);

    TextRect:=ARect;

    DrawText(Node, ARect);

    Dec(ARect.Left, (DefaultRowHeight - Delta)+ItemSpace+Pad4Chk); {* EL Big Glyph*}

    If (IndentLevel=1) then {* Descrease level 0 again *}
      Dec(ARect.Left, 3);

    if HasChildren then
    begin
      if Expanded then Style := obOpen
      else Style := obClose;
    end
    else
    Begin
      If (Node.UseLeafx<>obPlus) then
        Style := Node.UseLeafx {* EL Big Glyph*}
      else
        Style:=obLeaf;
    end;

    Bitmap1 := GetBitmap(Style);

    If (Node.ShowCheckBox) then {* EL Big Glyph*}
    Begin
      If (Node.CheckBoxChecked) then
        Bitmap2:=GetBitmap(obPlus)
      else
        Bitmap2:=GetBitmap(obMinus);
    end
    else
      Bitmap2:=nil;

    DrawPictures([Bitmap1,BitMap2], ARect,IndentLevel);      {* EL Big Glyph*}
  end;

begin

  OrigARect:=ARect;

  if FRootNode.List.Count = 0 then
  begin
    with Canvas do
    begin
      Brush.Color := Color;
      FillRect(ARect);
    end;
    Exit;
  end;

  if (Style = otOwnerDraw) and Assigned(FOnDrawItem) then
  begin
    if Row = ARow then
    begin
      if GetFocus = Self.Handle then
      begin
        FOnDrawItem(Self, ARow, ARect, [odFocused, odSelected]);
        if ooDrawFocusRect in Options then
          DrawFocusRect(Canvas.Handle, ARect);
      end
      else FOnDrawItem(Self, ARow, ARect, [odSelected])
    end
    else OnDrawItem(Self, ARow, ARect, []);
    Exit;
  end;

  InitialLeft := ARect.Left;
  Delta := (ARect.Bottom - ARect.Top - FFontSize) div 2;


  Node := FRootNode.GetVisibleNode(ARow + 1);

  If Assigned(OnUpdateNode) and (Assigned(Node)) then {Go and update yourself in case it affects the pics}
    OnUpdateNode(Self,Node,ARow);

  Expanded := Node.Expanded;
  HasChildren := Node.HasItems;

  Pad4Chk:=(10+(5*Ord(Node.GetLevel>1)))*Ord(Node.ShowCheckBox); {* EL Big Glyph*}
  //Pad4Chk:=10+(5*Ord(Node.GetLevel>1)); {* EL Big Glyph*}

  ONomRec:=Node.Data;


  with Canvas do
  begin
    Font := Self.Font;
    Brush.Color := Color;
    FillRect(ARect);
//    TextLength := TextWidth(Node.Text) + 1; {* EL Big Glyph*}
    if Row = ARow then
    begin
      Brush.Color := BarColor;
      Font.Color := BarTextColor;
    end;

    If (Expanded) and (HasChildren) then
    Begin
      Font.Style:= [fsBold];
    end
    else
    Begin
      If (ONomRec<>nil) then
      Begin
        If (ONomRec^.HedTotal) then
          Font.Style:=[fsBold,fsUnderline]
        else
          If (ONomRec^.MoreLink) then
            Font.Style:=[fsBold]
          else
            If (ONomRec^.ShowAsBar) and (Row<>ARow) then
            Begin
              Brush.Color := HLBarColor;
              Font.Color := HLBarTextColor;
              IndentLevel := Node.GetLevel;

              DrawHLCell;
            end;
      end;
    end;
  end;

  IndentLevel := Node.GetLevel;

  TextRect:=Arect;


  case OutlineStyle of
    osText: DrawTheText;
    osPlusMinusText: DrawPlusMinusText;
    osPlusMinusPictureText: DrawPlusMinusPicture;
    osPictureText: DrawPictureText;
    osTreeText: DrawTheTree;
    osTreePictureText: DrawTreePicture;
  end;

  DrawValue(TextRect);

  if (Row = ARow) and (Node.Text <> '') then
  begin
    ARect.Left := InitialLeft + DefaultRowHeight * (IndentLevel - 1);
    if OutlineStyle >= osTreeText then
    begin
      Dec(ARect.Left, Delta);
      if ooDrawTreeRoot in Options then Inc(ARect.Left, DefaultRowHeight);
    end;
    if (OutlineStyle <> osText) and (OutlineStyle <> osTreeText) then
      Inc(ARect.Left, DefaultRowHeight+ItemSpace+Pad4Chk); {* EL Big Glyph*}
    if OutlineStyle = osPlusMinusPictureText then
      Inc(ARect.Left, DefaultRowHeight);
    if (GetFocus = Self.Handle) and (ooDrawFocusRect in Options) then
      DrawFocusRect(Canvas.Handle, ARect);
  end;

  If Assigned(FOnDrawItem) then
    OnDrawItem(Self, ARow+1, ARect, []);

end;



procedure Register;
begin
  RegisterComponents('SBS', [TSBSOutLineB, TSBSOutlineC]);
end;


Initialization

  InDesignMode:=False;

end.
