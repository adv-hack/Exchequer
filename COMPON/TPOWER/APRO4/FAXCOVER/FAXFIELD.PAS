unit FaxField;

{$I AWDEFINE.INC}

interface

uses
  {$IFDEF Win32} Windows, {$ELSE} WinTypes, WinProcs, {$ENDIF}
  Messages, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  {$IFDEF DELPHI3} ExtDlgs, {$ENDIF}
  Dialogs, Ruler;


type
  {Records used for saving cover page to a disk file}
  TUserDataArray = array[0..1023] of Byte;

  TPageRecord = packed record
    prVersionNum       : string[11];
    prPageWidthPixels  : LongInt;
    prPageHeightPixels : LongInt;
    prPageWidthInches  : Double;
    prPageHeightInches : Double;
    prIsMetric         : Boolean;
    {Extra field for storing miscellaneous additional data}
    prUserData         : TUserDataArray;
  end;

  TFieldRecord = packed record
    frLeftInches   : Double;
    frTopInches    : Double;
    frWidthInches  : Double;
    frHeightInches : Double;
  end;

  TFontRecord = packed record
    frCharSet       : Byte;
    frColor         : LongInt;
    frHeight        : LongInt;
    frName          : string[255];
    frPitch         : Byte;
    frSize          : LongInt;
    frFontBold      : Boolean;
    frFontItalic    : Boolean;
    frFontUnderline : Boolean;
    frFontStrikeout : Boolean;
  end;

  TStretchModes = (smNone, smDrag, smE, smW, smS, smN, smNE, smSW, smSE, smNW);

  TStretchHandle = class(TPaintBox)
  private
    FHandlePosition : TStretchModes;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner : TComponent); override;
    property HandlePosition : TStretchModes
      read FHandlePosition write FHandlePosition;
  end;

  TStretchHandleArray = array[0..7] of TStretchHandle;

  TBaseField = class(TShape)
  private
    FSelected        : Boolean;
    FStretchMode     : TStretchModes;
    bfStretchHandles : TStretchHandleArray;
  protected
    procedure bfMouseDown(Sender: TObject; Button: TMouseButton;
                          Shift: TShiftState; X, Y: Integer);
    procedure bfMouseUp(Sender: TObject; Button: TMouseButton;
                        Shift: TShiftState; X, Y: Integer);
    procedure bfMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetSelected(IsSelected : Boolean);
    function GetStretchHandleCoords(WhichHandle : TStretchModes) : TPoint;
      {-Returns the coordinates (Left, Top) where the StretchHandle should be drawn}
    procedure Write(Stream : TStream); virtual;
      {-Writes all necessary TBaseField properties out to Stream}
    procedure Read(Stream : TStream); virtual;
      {-Reads BaseField properties from Stream and assigns those properties to Self}
    procedure Draw(ACanvas : TCanvas); virtual; abstract;
      {-Draws Self on ACanvas}
  public
    constructor Create(AOwner: TComponent); override;
    property Selected : Boolean read FSelected write SetSelected;
    property StretchMode : TStretchModes read FStretchMode write FStretchMode;
  end;

  TTextField = class(TBaseField)
  protected
    FMemo : TMemo;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetParent(AParent: TWinControl); override;
    function GetTextHeight : Integer;
      {-Returns the height of one row of text, including external leading, given the
        current font assigned to the field}
    function GetText : string;
    procedure Write(Stream : TStream); override;
      {-Writes all necessary properties out to Stream}
    procedure Read(Stream : TStream); override;
      {-Reads properties from Stream and assigns those properties to Self}
    procedure Draw(ACanvas : TCanvas); override;
      {-Draws Self on ACanvas}
    procedure tfEnter(Sender : TObject);
    procedure tfExit(Sender : TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure MemoDblClick(Sender: TObject);
    procedure SetFocus;
    property Text : string read GetText;
  end;

  TImageField = class(TBaseField)
  protected
    FImage : TImage;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetParent(AParent: TWinControl); override;
    function GetPicture : TPicture;
    procedure Write(Stream : TStream); override;
      {-Writes all necessary properties out to Stream}
    procedure Read(Stream : TStream); override;
      {-Reads properties from Stream and assigns those properties to Self}
    procedure Draw(ACanvas : TCanvas); override;
      {-Draws Self on ACanvas}
  public
    constructor Create(AOwner: TComponent); override;
    procedure ImageDblClick(Sender: TObject);
    property Picture : TPicture read GetPicture;
  end;

  TSelectionChangeEvent = procedure(IsFieldSelected : Boolean) of object;
  TPositionChangeEvent = procedure(Left, Top, Width, Height : Integer) of object;

  TFaxPanel = class(TPanel)
  private
    FShowGrid               : Boolean;
    FSnapToGrid             : Boolean;
    FGridSpacingX           : Integer;
    FGridSpacingY           : Integer;
    FPageWidthInches        : Double;
    FPageHeightInches       : Double;
    FEditMode               : Boolean; {Are we in Edit Mode or Design Mode}
    FStretchMode            : TStretchModes;
    FOnFieldSelectionChange : TSelectionChangeEvent;
    FOnFieldPositionChange  : TPositionChangeEvent;
    FNeedsSaving            : Boolean;

    FPageCount              : Integer;
    FPageNumber             : Integer;
    FSender                 : string;
    FRecipient              : string;
    FPageTitle              : string;
    FStationID              : string;

    fpDragging              : Boolean;
    fpMaxGridLine           : TPoint;
    fpHorzPixelsPerInch     : Double;
    fpVertPixelsPerInch     : Double;
    fpMouseAnchor           : TPoint;
    fpIsMouseDown           : Boolean;
    fpFieldList             : TList;

    function GetFieldCount : Integer;
    function GetField(Index : Integer) : TBaseField;
    function GetSelectedField : TBaseField;
    procedure SetEditMode(Value : Boolean);
    procedure SetPageWidthInches(AWidth : Double);
    procedure SetPageHeightInches(AHeight : Double);
    procedure SetShowGrid(AShowGrid : Boolean);
    procedure SetSnapToGrid(ASnapToGrid : Boolean);
    procedure SetGridSpacingX(GridSpacing : Integer);
    procedure SetGridSpacingY(GridSpacing : Integer);
    procedure AdjustLeftToGrid(var ALeft : Integer);
      {-If SnapToGrid is True, adjusts ALeft to be on the nearest grid line}
    procedure AdjustTopToGrid(var ATop : Integer);
      {-If SnapToGrid is True, adjusts ATop to be on the nearest grid line}
    procedure AdjustWidthToGrid(ALeft : Integer; var AWidth : Integer);
      {-If SnapToGrid is True, adjusts AWidth to be on the nearest grid line.
        Caller should ensure that ALeft is already on a grid line, possibly by
        calling AdjustLeftToGrid.}
    procedure AdjustHeightToGrid(ATop : Integer; var AHeight : Integer);
      {-If SnapToGrid is True, adjusts AHeight to be on the nearest grid line.
        Caller should ensure that ATop is already on a grid line, possibly by
        calling AdjustTopToGrid.}
    function GetDrawAdjustFactor : Double;
    function GetDrawWidth : Integer;
      {-Returns the width that the TCanvas passed to the Draw method should be}
    function GetDrawHeight : Integer;
      {-Returns the height that the TCanvas passed to the Draw method should be}
    procedure SetStretchMode(NewStretchMode : TStretchModes);
    procedure DeselectAllFields;
    procedure DeleteAllFields;
    procedure AddField(Field : TBaseField);

  protected
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Paint; override;
    procedure fpResize(Sender : TObject);
    procedure fpMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure fpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure fpMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FieldSelectionChange(IsFieldSelected : Boolean);
      {-Calls OnFieldSelectionChange event handler when a field becomes
        deselected or when a new field becomes selected}
    procedure FieldPositionChange(ALeft, ATop, AWidth, AHeight : Integer);
      {-Calls OnFieldPositionChange event handler when the location or size of
        the currently-selected field changes}
    procedure FieldChange(Sender : TObject);
    property Canvas;
    property StretchMode : TStretchModes read FStretchMode write SetStretchMode;
    property PageWidthInches : Double read FPageWidthInches write SetPageWidthInches;
    property PageHeightInches : Double read FPageHeightInches write SetPageHeightInches;
    property DrawAdjustFactor : Double read GetDrawAdjustFactor;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function HorzPixelsToInches(P : Integer) : Double;
      {-Returns the value of P converted to inches given the current values of
        Width and PageWidthInches}
    function VertPixelsToInches(P : Integer) : Double;
      {-Returns the value of P converted to inches given the current values of
        Height and PageHeightInches}
    function HorzInchesToPixels(Inches : Double) : Integer;
      {-Returns the value of Inches converted to pixels given the current values
        of Width and PageWidthInches}
    function VertInchesToPixels(Inches : Double) : Integer;
      {-Returns the value of Inches converted to pixels given the current values
        of Height and PageHeightInches}
    procedure SizeMove(Sender : TObject; Key : Word; Shift : TShiftState);
      {-move/size the field}
    function AddTextField : TTextField;
    function AddImageField : TImageField;
    procedure DeleteSelectedField;
      {-Deletes currently selected field}
    procedure CenterSelectedField(IsHorizontal : Boolean);
      {-Centers the currently-selected field within the panel. IsHorizontal
        specifies whether the field will be centered vertically or horizontally.}
    function SelectedFieldsExist : Boolean;
      {-Returns True if the panel contains at least one selected field}
    procedure FieldPositionChangeForSelectedField;
      {-If a selected field exists, calls FieldPositionChange with that field's
        coordinates}
    procedure Write(Stream : TStream);
      {-Writes all defining information out to Stream}
    procedure Read(Stream : TStream);
      {-Reads Stream and loads its properties into Self}
    procedure Draw(ACanvas : TCanvas);
      {-Draws an image of Self, including all fields, on ACanvas}
    property ShowGrid : Boolean read FShowGrid write SetShowGrid;
    property SnapToGrid : Boolean read FSnapToGrid write SetSnapToGrid;
    property GridSpacingX : Integer read FGridSpacingX write SetGridSpacingX;
    property GridSpacingY : Integer read FGridSpacingY write SetGridSpacingY;
    property EditMode : Boolean
      read FEditMode
      write SetEditMode;
    property NeedsSaving : Boolean read FNeedsSaving write FNeedsSaving;
    property OnFieldSelectionChange : TSelectionChangeEvent
      read FOnFieldSelectionChange write FOnFieldSelectionChange;
    property OnFieldPositionChange : TPositionChangeEvent
      read FOnFieldPositionChange write FOnFieldPositionChange;

    {When creating a bitmap for use in creating an APF file, the bitmap's width
     should be set to TFaxPanel.DrawWidth, and the bitmap's height should be
     set to TFaxPanel.DrawHeight.}
    property DrawWidth : Integer read GetDrawWidth;
      {-Returns the width that the TCanvas passed to the Draw method should be}
    property DrawHeight : Integer read GetDrawHeight;
      {-Returns the height that the TCanvas passed to the Draw method should be}
    property FieldCount : Integer
      read GetFieldCount;
    property Field[Index : Integer] : TBaseField
      read GetField;
    property SelectedField : TBaseField
      read GetSelectedField;

    {These properties are the values that are substituted for replacement tags
     when the cover page is saved as an APF file}
    property PageCount : Integer read FPageCount write FPageCount;
      {-Value substituted for $N replacement tag}
    property PageNumber : Integer read FPageNumber write FPageNumber;
      {-Value substituted for $P replacement tag}
    property Sender : string read FSender write FSender;
      {-Value substituted for $F replacement tag}
    property Recipient : string read FRecipient write FRecipient;
      {-Value substituted for $R replacement tag}
    property PageTitle : string read FPageTitle write FPageTitle;
      {-Value substituted for $S replacement tag}
    property StationID : string read FStationID write FStationID;
      {-Value substituted for $I replacement tag}
  end;

  TFaxScrollBox = class(TScrollBox)
  private
    FOnHorzScroll : TScrollEvent;
    FOnVertScroll : TScrollEvent;
    procedure WMHScroll(var Message : TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message : TWMVScroll); message WM_VSCROLL;
  public
    property OnHorzScroll : TScrollEvent read FOnHorzScroll write FOnHorzScroll;
    property OnVertScroll : TScrollEvent read FOnVertScroll write FOnVertScroll;
  end;

  TFaxDesigner = class(TPanel)
  private
    FFaxPanel   : TFaxPanel;
    FIsNew      : Boolean;
    FIsMetric   : Boolean;
    FUserData   : TUserDataArray;
    fdHorzRuler : TRuler;
    fdVertRuler : TRuler;
    fdScrollBox : TFaxScrollBox;
    procedure HorzScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure VertScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    function GetPageWidthPixels : Integer;
    procedure SetPageWidthPixels(AWidth : Integer);
    function GetPageHeightPixels : Integer;
    procedure SetPageHeightPixels(AHeight : Integer);
    function GetPageWidthInches : Double;
    procedure SetPageWidthInches(AWidth : Double);
    function GetPageHeightInches : Double;
    procedure SetPageHeightInches(AHeight : Double);
    procedure SetIsMetric(AIsMetric : Boolean);
    procedure SetMarkPositions(ALeft, ATop, AWidth, AHeight : Integer);
      {-Sets the position of the red position marks on the Ruler bars. To
        suppress drawing of the marks, set to a negative value.}
  protected
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetParent(AParent: TWinControl); override;
  public
    constructor Create(AOwner : TComponent); override;
    procedure Write(Stream : TStream);
      {-Writes all defining information out to Stream}
    procedure Read(Stream : TStream);
      {-Reads Stream and loads its properties into Self}
    property FaxPanel : TFaxPanel read FFaxPanel;
    property PageWidthPixels  : Integer read GetPageWidthPixels write SetPageWidthPixels;
    property PageHeightPixels : Integer read GetPageHeightPixels write SetPageHeightPixels;
    property PageWidthInches  : Double read GetPageWidthInches write SetPageWidthInches;
    property PageHeightInches : Double read GetPageHeightInches write SetPageHeightInches;
    property IsMetric : Boolean read FIsMetric write SetIsMetric;
    property UserData : TUserDataArray read FUserData write FUserData;
      {-Misc data field. Gets written to and read from the Stream when Write or
        Read are called}
    property IsNew : Boolean read FIsNew write FIsNew;
      {-Returns True if this is a new cover page that hasn't been given a real
        name yet. Returns False if this cover page was read in using the Read
        method or if it was written out using the Write method.}
  end;


implementation

uses SysUtils;


const
  ctVersionNum   = '1.00';
  ftTextField    = 0;
  ftImageField   = 1;

  ctGridStart    = 1;
  ctGridSpacingX = 20;
  ctGridSpacingY = 20;
  ctDefaultWidthPixels  = 600;
  ctDefaultHeightPixels = 776;
  ctDefaultWidthInches  = 8.5;
  ctDefaultHeightInches = 11.0;
  ctStretchHandleSize   = 5; {Stretch handles are 5 x 5 pixels}


procedure Constrain(var X : Integer; MinVal, MaxVal : Integer);
  {-Forces an integer between two values}
begin
  if X > MaxVal then
    X := MaxVal
  else if X < MinVal then
    X := MinVal;
end;  { Constrain }

procedure ConvertCoords(Source, Target : TControl; var X, Y : Integer);
  {-Converts Source coordinates X, Y to Target coordinates}
var
  P : TPoint;
begin
  P.X := X;
  P.Y := Y;
  P   := Target.ScreenToClient(Source.ClientToScreen(P));
  X   := P.X;
  Y   := P.Y;
end;


{*** TStretchHandle *}

constructor TStretchHandle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Canvas.Brush.Color := clBlack;
  Canvas.Brush.Style := bsSolid;
  SetBounds(Top, Left, ctStretchHandleSize, ctStretchHandleSize);
end;

procedure TStretchHandle.Paint;
begin
  Canvas.FillRect(Rect(0, 0, Width, Height));
end;

{------------------------------ TBaseField ---------------------------------}

constructor TBaseField.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Brush.Color := clWindow;
  Brush.Style := bsClear;
  DragCursor  := crCross;
  DragMode    := dmManual;
  Pen.Mode    := pmCopy;
  Pen.Style   := psDashDot;
  Pen.Color   := clBlack;
  Pen.Width   := 1;
  Shape       := stRectangle;
  Visible     := False; {Caller must make visible after setting size and position}
  SetSelected(False);
end;

procedure TBaseField.bfMouseDown(Sender: TObject; Button: TMouseButton;
                                 Shift: TShiftState; X, Y: Integer);
begin
  if Parent is TPanel then begin
    {If Sender is one of the StretchHandles, convert its coordinates to our own}
    if Sender is TStretchHandle then
      ConvertCoords(Sender as TStretchHandle, Self, X, Y);
    (Parent as TPanel).OnMouseDown(Self, Button, Shift, X, Y);
  end;
end;

procedure TBaseField.bfMouseUp(Sender: TObject; Button: TMouseButton;
                               Shift: TShiftState; X, Y: Integer);
begin
  if Parent is TPanel then begin
    {If Sender is one of the StretchHandles, convert its coordinates to our own}
    if Sender is TStretchHandle then
      ConvertCoords(Sender as TStretchHandle, Self, X, Y);
    (Parent as TPanel).OnMouseUp(Self, Button, Shift, X, Y);
  end;
end;

procedure TBaseField.bfMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if Parent is TPanel then begin
    {If Sender is one of the StretchHandles, convert its coordinates to our own}
    if Sender is TStretchHandle then begin
      ConvertCoords(Sender as TStretchHandle, Self, X, Y);
      if not (ssLeft in Shift) then
        StretchMode := (Sender as TStretchHandle).HandlePosition;
    end else
      StretchMode := smDrag;
    (Parent as TPanel).OnMouseMove(Self, Shift, X, Y);
  end;
end;

procedure TBaseField.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  I : Integer;
  P : TPoint;
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  {Move all StretchHandles to the proper positions}
  for I := Low(bfStretchHandles) to High(bfStretchHandles) do
    if Assigned(bfStretchHandles[I]) then
      with bfStretchHandles[I] do begin
        P := GetStretchHandleCoords(HandlePosition);
        SetBounds(P.X, P.Y, Width, Height);
      end;
end;  

procedure TBaseField.SetParent(AParent: TWinControl);

  function CreateStretchHandle(WhichHandle : TStretchModes) : TStretchHandle;
  var
    P : TPoint;
  begin
    P := GetStretchHandleCoords(WhichHandle);
    Result := TStretchHandle.Create(Self);
    with Result do begin
      HandlePosition := WhichHandle;
      Parent         := AParent;
      Visible        := Selected;
      OnMouseDown    := bfMouseDown;
      OnMouseUp      := bfMouseUp;
      OnMouseMove    := bfMouseMove;
      SetBounds(P.X, P.Y, Width, Height);
    end;
  end;

const
  ctStretchHandleCorners :
    array[Low(TStretchHandleArray)..High(TStretchHandleArray)] of TStretchModes =
      (smNW, smN, smNE, smE, smSE, smS, smSW, smW);
var
  I : Integer;
begin
  if AParent <> Parent then begin
    inherited SetParent(AParent);
    if Assigned(AParent) then begin
      OnMouseDown := (AParent as TPanel).OnMouseDown;
      OnMouseUp   := (AParent as TPanel).OnMouseUp;
      OnMouseMove := (AParent as TPanel).OnMouseMove;
      {If StretchHandles already exist, destroy them}
      for I := Low(bfStretchHandles) to High(bfStretchHandles) do
        if Assigned(bfStretchHandles[I]) then begin
          bfStretchHandles[I].Free;
          bfStretchHandles[I] := nil;
        end;
      {Create new StretchHandles}
      for I := Low(bfStretchHandles) to High(bfStretchHandles) do
        bfStretchHandles[I] := CreateStretchHandle(ctStretchHandleCorners[I]);
    end else begin
      OnMouseDown := nil;
      OnMouseUp   := nil;
      OnMouseMove := nil;
    end;
  end;
end;

procedure TBaseField.SetSelected(IsSelected : Boolean);
var
  I : Integer;
begin
  if IsSelected <> FSelected then begin
    FSelected := IsSelected;
    for I := Low(bfStretchHandles) to High(bfStretchHandles) do
      with bfStretchHandles[I] do begin
        Visible := FSelected;
        {BringToFront to ensure that if this is a TImageField, StretchHandle
         isn't partially hidden behind the image}
        if FSelected then
          BringToFront;
      end;
    Refresh;
  end;
end;

function TBaseField.GetStretchHandleCoords(WhichHandle : TStretchModes) : TPoint;
  {-Returns the coordinates (Left, Top) where the StretchHandle should be drawn}
var
  Offset : Integer;
begin
  with Result do
    case WhichHandle of
      smNW : begin
               Offset := ctStretchHandleSize div 2;
               X      := Left - Offset;
               Y      := Top - Offset;
             end;
      smN  : begin
               Offset := ctStretchHandleSize div 2;
               X      := Left + (Width div 2) - Offset;
               Y      := Top - Offset;
             end;
      smNE : begin
               Offset := (ctStretchHandleSize + 1) div 2;
               X      := Left + Width - Offset;
               Offset := ctStretchHandleSize div 2;
               Y      := Top - Offset;
             end;
      smE  : begin
               Offset := (ctStretchHandleSize + 1) div 2;
               X      := Left + Width - Offset;
               Offset := ctStretchHandleSize div 2;
               Y      := Top + (Height div 2) - Offset;
             end;
      smSE : begin
               Offset := (ctStretchHandleSize + 1) div 2;
               X      := Left + Width - Offset;
               Y      := Top + Height - Offset;
             end;
      smS  : begin
               Offset := ctStretchHandleSize div 2;
               X      := Left + (Width div 2) - Offset;
               Offset := (ctStretchHandleSize + 1) div 2;
               Y      := Top + Height - Offset;
             end;
      smSW : begin
               Offset := ctStretchHandleSize div 2;
               X      := Left - Offset;
               Offset := (ctStretchHandleSize + 1) div 2;
               Y      := Top + Height - Offset;
             end;
      smW  : begin
               Offset := ctStretchHandleSize div 2;
               X      := Left - Offset;
               Y      := Top + (Height div 2) - Offset;
             end;
      else begin
        X := 0;
        Y := 0;
      end;
    end;
end;

procedure TBaseField.Read(Stream : TStream);
var
  FieldRec : TFieldRecord;
begin
  Stream.ReadBuffer(FieldRec, SizeOf(FieldRec));
  if Parent is TFaxPanel then
    with (Parent as TFaxPanel), FieldRec do begin
      Self.Left   := HorzInchesToPixels(frLeftInches);
      Self.Top    := VertInchesToPixels(frTopInches);
      Self.Width  := HorzInchesToPixels(frWidthInches);
      Self.Height := VertInchesToPixels(frHeightInches);
    end;
end;

procedure TBaseField.Write(Stream : TStream);
var
  FieldRec : TFieldRecord;
begin
  FillChar(FieldRec, SizeOf(FieldRec), 0);
  if Parent is TFaxPanel then
    with (Parent as TFaxPanel), FieldRec do begin
      frLeftInches   := HorzPixelsToInches(Self.Left);
      frTopInches    := VertPixelsToInches(Self.Top);
      frWidthInches  := HorzPixelsToInches(Self.Width);
      frHeightInches := VertPixelsToInches(Self.Height);
    end;
  Stream.WriteBuffer(FieldRec, SizeOf(FieldRec));
end;


{*** TTextField ***}

constructor TTextField.Create(AOwner: TComponent);
const
  ctDefWidth = 200;
begin
  inherited Create(AOwner);

  Pen.Style := psClear;  {Don't need the TShape border because FMemo will have a border}
  FMemo := TMemo.Create(Self);
  with FMemo do begin
    Ctl3D       := False;
    ParentCtl3D := False;
    WordWrap    := True;
    OnMouseDown := bfMouseDown;
    OnMouseUp   := bfMouseUp;
    OnMouseMove := bfMouseMove;
    OnDblClick  := MemoDblClick;
    OnEnter     := tfEnter;
    OnExit      := tfExit;
  end;
  SetBounds(Left, Top, ctDefWidth, Height);
end;

procedure TTextField.Draw(ACanvas : TCanvas);

  procedure ReplaceTags(TagStr     : string;
                  const ReplaceStr : string;
                    var TargetStr  : string);
  var
    Posn    : Integer;
    TempStr : string;
  begin
    TagStr := UpperCase(TagStr);
    repeat
      TempStr := UpperCase(TargetStr);
      Posn    := Pos(TagStr, TempStr);
      if Posn > 0 then begin
        Delete(TargetStr, Posn, Length(TagStr));
        Insert(ReplaceStr, TargetStr, Posn);
      end;
    until Posn = 0;
  end;

var
  I          : Integer;
  X, Y       : Integer;
  TextHeight : Integer;
  S          : string;
  DateStr    : string;
  TimeStr    : string;
begin
  with FMemo do begin
    ACanvas.Font := Font;
    TextHeight := GetTextHeight;

    {Format date string to use for $D replacement tag}
    DateStr := DateToStr(Date);
    {Format time string to use for $T replacement tag}
    TimeStr := TimeToStr(Time);
    Delete(TimeStr, Length(TimeStr) - 5, 4);  {Strip off the seconds}
    TimeStr := LowerCase(TimeStr); {Convert AM or PM to lower case}

    X := Round((Parent as TFaxPanel).DrawAdjustFactor * Self.Left);
    for I := 0 to Lines.Count - 1 do begin
      S := Lines[I];
      {Look for replaceable tags and do replacements as required}
      ReplaceTags('$D', DateStr, S);
      ReplaceTags('$T', TimeStr, S);
      ReplaceTags('$N', IntToStr((Parent as TFaxPanel).PageCount), S);
      ReplaceTags('$P', IntToStr((Parent as TFaxPanel).PageNumber), S);
      ReplaceTags('$F', (Parent as TFaxPanel).Sender, S);
      ReplaceTags('$R', (Parent as TFaxPanel).Recipient, S);
      ReplaceTags('$S', (Parent as TFaxPanel).PageTitle, S);
      ReplaceTags('$I', (Parent as TFaxPanel).StationID, S);

      Y := Round((Parent as TFaxPanel).DrawAdjustFactor * (Self.Top + (I * TextHeight)));
      ACanvas.TextOut(X, Y, S);
    end;
  end;
end;

procedure TTextField.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if Assigned(FMemo) then
    FMemo.SetBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure TTextField.SetParent(AParent: TWinControl);
var
  NewHeight : Integer;
begin
  inherited SetParent(AParent);

  if Assigned(FMemo) then begin
    FMemo.Parent := AParent;
    {If no text has yet been entered, get the height of one row of text for the
     current font, and adjust the field height to match}
    if (FMemo.Text = '') and Assigned(AParent) then begin
      NewHeight := GetTextHeight + 4;
      {If SnapToGrid is enabled, adjust height to fall on a grid line}
      with Parent as TFaxPanel do
        if SnapToGrid then
          AdjustHeightToGrid(Top, NewHeight);
      SetBounds(Left, Top, Width, NewHeight);
    end;
    if AParent is TFaxPanel then
      FMemo.OnChange := (AParent as TFaxPanel).FieldChange;
  end;
end;

procedure TTextField.SetFocus;
begin
  FMemo.SetFocus;
end;

function TTextField.GetTextHeight : Integer;
var
  Canvas     : TCanvas;
  TextMetric : TTextMetric;
begin
  Canvas := TCanvas.Create;
  try
    Canvas.Handle := GetDC(FMemo.Handle);
    try
      Canvas.Font := FMemo.Font;
      GetTextMetrics(Canvas.Handle, TextMetric);
      with TextMetric do
        Result := tmHeight + tmExternalLeading;
    finally
      ReleaseDC(FMemo.Handle, Canvas.Handle);
    end;
  finally
    Canvas.Free;
  end;
end;

procedure TTextField.MemoDblClick(Sender: TObject);
var
  NewHeight  : Integer;
  LineCount  : Integer;
  FontDialog : TFontDialog;
begin
  FontDialog := TFontDialog.Create(nil);
  try
    FontDialog.Font := FMemo.Font;
    if FontDialog.Execute then begin
      FMemo.Font := FontDialog.Font;

      {Adjust field height to allow for the new font size}
      LineCount := FMemo.Lines.Count;
      if LineCount < 1 then
        LineCount := 1;
      NewHeight := GetTextHeight * LineCount + 4;
      Constrain(NewHeight, 0, (Parent as TWinControl).Height - Top);
      {If SnapToGrid is enabled, adjust height to fall on a grid line}
      if (Parent as TFaxPanel).SnapToGrid then
        (Parent as TFaxPanel).AdjustHeightToGrid(Top, NewHeight);
      SetBounds(Left, Top, Width, NewHeight);

      if FSelected then begin
        (Parent as TFaxPanel).FieldPositionChange(Left, Top, Width, Height);
        {Set Ruler position marks to the new coordinates}
        if (Parent as TFaxPanel).Owner is TFaxDesigner then
          ((Parent as TFaxPanel).Owner as TFaxDesigner).SetMarkPositions(Left, Top, Width, Height);
      end;
    end;

    if Parent is TFaxPanel then
      (Parent as TFaxPanel).FieldChange(nil);
  finally
    FontDialog.Free;
  end;
end;

function TTextField.GetText : string;
begin
  if Assigned(FMemo) then
    Result := FMemo.Text
  else
    Result := '';
end;

type
  TLocalMemo = class(TMemo);

procedure TTextField.tfEnter(Sender : TObject);
var
  PF : {$IFDEF DELPHI3}TCustomForm{$ELSE}TForm{$ENDIF};
begin
  if (Parent as TFaxPanel).EditMode then begin
    TLocalMemo(FMemo).SetDesigning(False);
  end else begin
    PF := GetParentForm(FMemo);
    PF.DefocusControl(FMemo, False);
    TLocalMemo(FMemo).SetDesigning(True);
  end;
end;

procedure TTextField.tfExit(Sender : TObject);
begin
  TLocalMemo(FMemo).SetDesigning(True);
end;

procedure TTextField.Read(Stream : TStream);
var
  BufSize : LongInt;
  Buffer  : PChar;
  FontRec : TFontRecord;
begin
  {Read BaseField properties}
  inherited Read(Stream);

  {Read the font properties and assign them to TMemo.Font}
  Stream.ReadBuffer(FontRec, SizeOf(FontRec));
  with FMemo.Font, FontRec do begin
    {$IFDEF DELPHI3}
    CharSet := TFontCharSet(frCharSet);
    {$ENDIF}
    Color   := TColor(frColor);
    Height  := frHeight;
    Name    := frName;
    Pitch   := TFontPitch(frPitch);
    Size    := frSize;
    Style   := [];
    if frFontBold then
      Style := Style + [fsBold];
    if frFontItalic then
      Style := Style + [fsItalic];
    if frFontUnderline then
      Style := Style + [fsUnderline];
    if frFontStrikeout then
      Style := Style + [fsStrikeout];
  end;

  {Read the buffer size needed to store the text}
  Stream.ReadBuffer(BufSize, SizeOf(BufSize));

  {If text exists, read it into the buffer and assign it to the TMemo}
  if BufSize > 1 then begin
    GetMem(Buffer, BufSize);
    try
      FillChar(Buffer^, BufSize, 0);
      Stream.ReadBuffer(Buffer^, BufSize);
      FMemo.Text := StrPas(Buffer);
    finally
      FreeMem(Buffer, BufSize);
    end;
  end;
end;

procedure TTextField.Write(Stream : TStream);
var
  FieldType : Byte;
  BufSize   : LongInt;
  Buffer    : PChar;
  FontRec   : TFontRecord;
begin
  {First thing to write out is the field type}
  FieldType := ftTextField;
  Stream.WriteBuffer(FieldType, SizeOf(FieldType));

  {Write out BaseField properties}
  inherited Write(Stream);

  {Initialize FontRec with the font properties and write it out}
  with FMemo.Font, FontRec do begin
    {$IFDEF DELPHI3}
    frCharSet       := Ord(CharSet);
    {$ELSE}
    frCharSet       := 0;
    {$ENDIF}
    frColor         := Color;
    frHeight        := Height;
    frName          := Name;
    frPitch         := Ord(Pitch);
    frSize          := Size;
    frFontBold      := fsBold in Style;
    frFontItalic    := fsItalic in Style;
    frFontUnderline := fsUnderline in Style;
    frFontStrikeout := fsStrikeout in Style;
  end;
  Stream.WriteBuffer(FontRec, SizeOf(FontRec));

  {Find out how big a buffer we need, and write out the buffer size}
  BufSize := FMemo.GetTextLen + 1; {Add one to allow for null character}
  Stream.WriteBuffer(BufSize, SizeOf(BufSize));

  {If the buffer isn't empty, get the memo text and write it out}
  if BufSize > 1 then begin
    GetMem(Buffer, BufSize);
    try
      FillChar(Buffer^, BufSize, 0);
      FMemo.GetTextBuf(Buffer, BufSize);
      Stream.WriteBuffer(Buffer^, BufSize);
    finally
      FreeMem(Buffer, BufSize);
    end;
  end;
end;

{------------------------------ TImageField --------------------------------}

constructor TImageField.Create(AOwner: TComponent);
const
  DefWidth  = 120;
  DefHeight = 120;
begin
  inherited Create(AOwner);
  FImage := TImage.Create(Self);
  with FImage do begin
    Stretch     := True;
    OnMouseDown := bfMouseDown;
    OnMouseUp   := bfMouseUp;
    OnMouseMove := bfMouseMove;
    OnDblClick  := ImageDblClick;
  end;
  SetBounds(Left, Top, DefWidth, DefHeight);
end;  

procedure TImageField.Draw(ACanvas : TCanvas);
var
  AdjustFactor : Double;
begin
  if not FImage.Picture.Bitmap.Empty then begin
    AdjustFactor := (Parent as TFaxPanel).DrawAdjustFactor;
    ACanvas.StretchDraw(Rect(Round(Left * AdjustFactor), Round(Top * AdjustFactor),
                             Round((Left + Width) * AdjustFactor),
                             Round((Top + Height) * AdjustFactor)),
                        FImage.Picture.Bitmap);
  end;
end;

function TImageField.GetPicture : TPicture;
begin
  if Assigned(FImage) then
    Result := FImage.Picture
  else
    Result := nil;
end;

procedure TImageField.ImageDblClick(Sender: TObject);
var
  {$IFDEF DELPHI3}
  PictureDialog : TOpenPictureDialog;
  {$ELSE}
  PictureDialog : TOpenDialog;
  {$ENDIF}
  I             : Integer;
begin
  {$IFDEF DELPHI3}
  PictureDialog := TOpenPictureDialog.Create(nil);
  {$ELSE}
  PictureDialog := TOpenDialog.Create(nil);
  {$ENDIF}
  try
    {$IFNDEF DELPHI3}
    PictureDialog.Filter := 'Bitmap files|*.BMP';
    {$ENDIF}
    PictureDialog.Options := [ofHideReadOnly, ofFileMustExist,
                              ofPathMustExist, ofNoChangeDir];
    if PictureDialog.Execute then begin
      {$IFNDEF DELPHI3}
      if Uppercase(ExtractFileExt(PictureDialog.FileName)) = '.BMP' then begin
      {$ENDIF}
        FImage.Picture.LoadFromFile(PictureDialog.FileName);
        FImage.Visible := True;
        {Bring all StretchHandles to front so they draw on top of the image}
        for I := Low(bfStretchHandles) to High(bfStretchHandles) do
          bfStretchHandles[I].BringToFront;
        if Parent is TFaxPanel then
          (Parent as TFaxPanel).FieldChange(nil);
      {$IFNDEF DELPHI3}
      end else
        MessageDlg('Not a valid BMP file', mtError, [mbOK], 0);
      {$ENDIF}
    end;
  finally
    PictureDialog.Free;
  end;
end;

procedure TImageField.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  if Assigned(FImage) then
    FImage.SetBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure TImageField.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if Assigned(FImage) then
    FImage.Parent := AParent;
end;

type
  TLocalBitmap = class(TBitmap);

procedure TImageField.Read(Stream : TStream);
var
  IsEmpty : Boolean;
begin
  {Read BaseField properties}
  inherited Read(Stream);

  {Read the IsEmpty value to determine if a bitmap exists}
  Stream.ReadBuffer(IsEmpty, SizeOf(IsEmpty));

  {If we have a bitmap, read it in}
  if not IsEmpty then
    TLocalBitmap(FImage.Picture.Bitmap).ReadData(Stream);
    {ReadData is used because when using SaveToStream/LoadFromStream,
     LoadFromStream assumes that the bitmap occupies the remaining data
     in the stream, therefor no other items can be stored after the bitmap.
     ReadData first reads in the size of the bitmap.
     The WriteData/ReadData routines are protected, but the type-cast using
     a local class alias allow us to access them anyway}
    {FImage.Picture.Bitmap.LoadFromStream(Stream);}
end;

procedure TImageField.Write(Stream : TStream);
var
  FieldType : Byte;
  IsEmpty   : Boolean;
begin
  {First thing to write out is the field type}
  FieldType := ftImageField;
  Stream.WriteBuffer(FieldType, SizeOf(FieldType));

  {Write out BaseField properties}
  inherited Write(Stream);

  {Determine whether a Bitmap is assigned and write this boolean value out}
  IsEmpty := FImage.Picture.Bitmap.Empty;
  Stream.WriteBuffer(IsEmpty, SizeOf(IsEmpty));

  {If we have a bitmap, write it out}
  if not IsEmpty then
    TLocalBitmap(FImage.Picture.Bitmap).WriteData(Stream);
    {WriteData is used because when using SaveToStream/LoadFromStream,
     LoadFromStream assumes that the bitmap occupies the remaining data
     in the stream, therefor no other items can be stored after the bitmap.
     WriteData first writes out the size of the bitmap data.
     The WriteData/ReadData routines are protected, but the type-cast using
     a local class alias allow us to access them anyway}
    {FImage.Picture.Bitmap.SaveToStream(Stream);}
end;


{*** TFaxPanel ***}

constructor TFaxPanel.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FGridSpacingX     := ctGridSpacingX;
  FGridSpacingY     := ctGridSpacingY;
  OnResize          := fpResize;
  OnMouseDown       := fpMouseDown;
  OnMouseUp         := fpMouseUp;
  OnMouseMove       := fpMouseMove;
  fpFieldList       := TList.Create;
end;

destructor TFaxPanel.Destroy;
begin
  {Destroy all items in fpFieldList}
  DeleteAllFields;

  {Now destroy the list itself}
  fpFieldList.Free;
  inherited Destroy;
end;

function TFaxPanel.GetFieldCount : Integer;
begin
  Result := fpFieldList.Count;
end;

function TFaxPanel.GetField(Index : Integer) : TBaseField;
begin
  Result := TBaseField(fpFieldList[Index]);
end;

function TFaxPanel.GetSelectedField : TBaseField;
var
  I      : Integer;
begin
  for I := fpFieldList.Count - 1 downto 0 do begin
    Result := fpFieldList[I];
    if Result.Selected then
      Exit;
  end;
  Result := nil;
end;

procedure TFaxPanel.SetEditMode(Value : Boolean);
var
  I     : Integer;
  Field : TBaseField;
begin
  if Value <> FEditMode then begin
    FEditMode := Value;
    for I := fpFieldList.Count - 1 downto 0 do begin
      Field := fpFieldList[I];
      if Field.Selected and (Field is TTextField) then begin
        TTextField(Field).tfEnter(nil);
        if Value then
          TTextField(Field).SetFocus;
      end;
    end;
  end;
end;

procedure TFaxPanel.SetPageWidthInches(AWidth : Double);
begin
  if AWidth <> FPageWidthInches then begin
    FPageWidthInches := AWidth;
    {Recalc pixels per inch and post position messages if necessary}
    SetBounds(Left, Top, Width, Height);
    FNeedsSaving := True;
  end;
end;

procedure TFaxPanel.SetPageHeightInches(AHeight : Double);
begin
  if AHeight <> FPageHeightInches then begin
    FPageHeightInches := AHeight;
    {SetBounds recalcs pixels per inch and calls OnFieldPositionChange if
     necessary}
    SetBounds(Left, Top, Width, Height);
    FNeedsSaving := True;
  end;
end;  

procedure TFaxPanel.SetShowGrid(AShowGrid : Boolean);
begin
  if AShowGrid <> FShowGrid then begin
    FShowGrid := AShowGrid;
    Invalidate;
  end;
end;

procedure TFaxPanel.SetSnapToGrid(ASnapToGrid : Boolean);
var
  I         : Integer;
  NewLeft   : Integer;
  NewTop    : Integer;
  NewWidth  : Integer;
  NewHeight : Integer;
  Field     : TBaseField;
begin
  if ASnapToGrid <> FSnapToGrid then begin
    FSnapToGrid := ASnapToGrid;
    {If SnapToGrid was just turned on, force all existing fields to snap to the grid}
    if FSnapToGrid then begin
      for I := 0 to fpFieldList.Count - 1 do begin
        Field     := fpFieldList[I];
        NewLeft   := Field.Left;
        NewTop    := Field.Top;
        NewWidth  := Field.Width;
        NewHeight := Field.Height;
        {Adjust coordinates to be on grid lines}
        AdjustLeftToGrid(NewLeft);
        AdjustTopToGrid(NewTop);
        AdjustWidthToGrid(NewLeft, NewWidth);
        AdjustHeightToGrid(NewTop, NewHeight);
        Field.SetBounds(NewLeft, NewTop, NewWidth, NewHeight);
      end;
      FNeedsSaving := True;
    end;
  end;
end;

procedure TFaxPanel.SetGridSpacingX(GridSpacing : Integer);
begin
  if (GridSpacing > 0) and (GridSpacing <> FGridSpacingX) then begin
    FGridSpacingX := GridSpacing;
    fpResize(nil);  {Recalculate fpMaxGridLine}
    if FSnapToGrid then begin
      {Turn SnapToGrid off and back on to force all fields to align to the new grid size}
      SetSnapToGrid(False);
      SetSnapToGrid(True);
    end;
    if FShowGrid then
      Invalidate;
  end;
end;

procedure TFaxPanel.SetGridSpacingY(GridSpacing : Integer);
begin
  if (GridSpacing > 0) and (GridSpacing <> FGridSpacingY) then begin
    FGridSpacingY := GridSpacing;
    fpResize(nil);  {Recalculate fpMaxGridLine}
    if FSnapToGrid then begin
      {Turn SnapToGrid off and back on to force all fields to align to the new grid size}
      SetSnapToGrid(False);
      SetSnapToGrid(True);
    end;
    if FShowGrid then
      Invalidate;
  end;
end;

procedure TFaxPanel.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);

  procedure UpdateFieldPositionsAndSizes(OldWidth, OldHeight : Integer);
  var
    I           : Integer;
    NewLeft     : Integer;
    NewTop      : Integer;
    NewWidth    : Integer;
    NewHeight   : Integer;
    Field       : TBaseField;
    WidthRatio  : Double;
    HeightRatio : Double;
  begin
    if OldWidth = 0 then
      WidthRatio := 0.0
    else
      WidthRatio  := Width / OldWidth;
    if OldHeight = 0 then
      HeightRatio := 0.0
    else
      HeightRatio  := Height / OldHeight;
    for I := fpFieldList.Count - 1 downto 0 do begin
      Field := fpFieldList[I];
      with Field do begin
        NewLeft   := Round(Left * WidthRatio);
        NewTop    := Round(Top * HeightRatio);
        NewWidth  := Round(Width * WidthRatio);
        NewHeight := Round(Height * HeightRatio);
        AdjustLeftToGrid(NewLeft);
        AdjustWidthToGrid(NewLeft, NewWidth);
        AdjustTopToGrid(NewTop);
        AdjustHeightToGrid(NewTop, NewHeight);
        SetBounds(NewLeft, NewTop, NewWidth, NewHeight);
        if Selected then begin
          FieldPositionChange(Left, Top, Width, Height);
          {Set Ruler position marks to the new coordinates}
          if Self.Owner is TFaxDesigner then
            (Self.Owner as TFaxDesigner).SetMarkPositions(Left, Top, Width, Height);
        end;
      end;
    end;
  end;  

var
  OldWidth  : Integer;
  OldHeight : Integer;
begin
  OldWidth  := Width;
  Oldheight := Height;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if FPageWidthInches = 0.0 then
    fpHorzPixelsPerInch := 0.0
  else
    fpHorzPixelsPerInch := Width / FPageWidthInches;
  if FPageHeightInches = 0.0 then
    fpVertPixelsPerInch := 0.0
  else
    fpVertPixelsPerInch := Height / FPageHeightInches;

  {Move and resize all fields so they retain the same relative positions and
   sizes in relation to the FaxPanel size}
  if Assigned(fpFieldList) then
    UpdateFieldPositionsAndSizes(OldWidth, OldHeight);
end;

procedure TFaxPanel.Paint;
var
  X, Y : Integer;
begin
  inherited Paint;
  if FShowGrid then begin
    X := ctGridStart;
    with Canvas do
      while X < Width do begin
        {To improve painting performance, don't draw anything that isn't
         within the current ClipRect}
        if (ClipRect.Left <= X) and (X <= ClipRect.Right) then begin
          Y := ctGridStart;
          while Y < Height do begin
            {To improve painting performance, don't draw anything that isn't
             within the current ClipRect}
            if (ClipRect.Top <= Y) and (Y <= ClipRect.Bottom) then
              Canvas.Pixels[X,Y] := clBlack;
            Y := Y + FGridSpacingY;
          end;
        end;
        X := X + FGridSpacingX;
      end;
  end;
end;

procedure TFaxPanel.fpResize(Sender : TObject);
var
  Extent      : Integer;
  NrGridLines : Integer;
begin
  {Calculate the coordinates of the rightmost and bottommost grid lines given
   the current panel size, and store the results in fpMaxGridLine}
  Extent := Width - ctGridStart;
  NrGridLines := Extent div FGridSpacingX;
  fpMaxGridLine.X := (NrGridLines * FGridSpacingX) + ctGridStart;
  Extent := Height - ctGridStart;
  NrGridLines := Extent div FGridSpacingY;
  fpMaxGridLine.Y := (NrGridLines * FGridSpacingY) + ctGridStart;
end;

procedure TFaxPanel.fpMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {If user clicked on a field, translate the coordinates to MainPanel
   coordinates and set fpMouseAnchor to those coordinates}
  if Sender is TBaseField then begin
    ConvertCoords(Sender as TControl, Self, X, Y);
    fpMouseAnchor := Point(X, Y);
    if (Button = mbLeft) and not (ssDouble in Shift) then
      fpIsMouseDown := True;
  end else
    fpMouseAnchor := Point(X, Y);
end;

procedure TFaxPanel.fpMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  IsFieldSelected : Boolean;
begin
  case Button of
    mbRight : if Sender is TControl then begin
                ConvertCoords(Sender as TControl, Self, X, Y);
                fpMouseAnchor := Point(X, Y);
              end;
    mbLeft :
      begin
        DeselectAllFields;
        IsFieldSelected := False;  {No fields are currently selected}

        {If user clicked on a field, mark it as selected}
        if Sender is TBaseField then begin
          IsFieldSelected := True;
          fpIsMouseDown   := False;
          with Sender as TBaseField do begin
            Selected := True;
            {Set Ruler position marks to the new coordinates}
            (Self.Owner as TFaxDesigner).SetMarkPositions(Left, Top, Width, Height);
          end;
        end else
          {Turn Ruler position marks off since no fields are selected}
          (Self.Owner as TFaxDesigner).SetMarkPositions(-1, -1, -1, -1);

        FieldSelectionChange(IsFieldSelected);
        if IsFieldSelected then
          with Sender as TBaseField do
            FieldPositionChange(Left, Top, Width, Height);
      end;
  end;
end;

procedure TFaxPanel.fpMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  XDiff     : Integer;
  YDiff     : Integer;
  OldLeft   : Integer;
  OldTop    : Integer;
  NewLeft   : Integer;
  NewTop    : Integer;
  NewWidth  : Integer;
  NewHeight : Integer;
begin
  if Sender is TBaseField then begin
    if fpIsMouseDown and (ssLeft in Shift) then begin
      if fpDragging then
        Exit;
      fpDragging := True;
      try
        case (Sender as TBaseField).StretchMode of
          smDrag :
            begin
              {TextFields can't be moved while in Edit Mode}
              if FEditMode and (Sender is TTextField) then
                Exit;
              ConvertCoords(Sender as TControl, Self, X, Y);
              Constrain(X, 0, Width);
              Constrain(Y, 0, Height);
              XDiff := X - fpMouseAnchor.X;
              YDiff := Y - fpMouseAnchor.Y;
              with Sender as TBaseField do begin
                NewLeft := Left + XDiff;
                NewTop  := Top + YDiff;
                {Ensure field remains entirely within Self}
                Constrain(NewLeft, 0, Self.Width  - Width);
                Constrain(NewTop,  0, Self.Height - Height);

                if FSnapToGrid then begin
                  {Adjust NewLeft and NewTop to be on grid lines if necessary}
                  AdjustLeftToGrid(NewLeft);
                  AdjustTopToGrid(NewTop);

                  {Make sure we haven't moved past the rightmost or bottommost grid line}
                  if NewLeft + Width - 1 > fpMaxGridLine.X then
                    NewLeft := NewLeft - FGridSpacingX;
                  if NewTop + Height - 1 > fpMaxGridLine.Y then
                    NewTop := NewTop - FGridSpacingY;
                end;

                OldLeft := Left;
                OldTop  := Top;
                SetBounds(NewLeft, NewTop, Width, Height);
              end;
              {Set fpMouseAnchor to new mouse position, but ONLY if the field
               position has changed. If SnapToGrid is enabled, the field position
               might not have changed even though the mouse position did.}
              fpMouseAnchor.X := fpMouseAnchor.X + NewLeft - OldLeft;
              fpMouseAnchor.Y := fpMouseAnchor.Y + NewTop - OldTop;
            end;
          smE :
            with Sender as TBaseField do begin
              NewWidth := X;
              Constrain(NewWidth, 0, Self.Width - Left);
              AdjustWidthToGrid(Left, NewWidth);

              SetBounds(Left, Top, NewWidth, Height);
              if Width <= 1 then
                StretchMode := smW;
            end;
          smW :
            with Sender as TBaseField do begin
              NewLeft := Left + X;
              {Prevent creeping to right when switching from smW to smE}
              Constrain(NewLeft, 0, Left + Width);
              AdjustLeftToGrid(NewLeft);

              NewWidth := Width + Left - NewLeft;
              Constrain(NewWidth, 0, Self.Width - NewLeft);
              AdjustWidthToGrid(NewLeft, NewWidth);

              SetBounds(NewLeft, Top, NewWidth, Height);
              if Width <= 1 then
                StretchMode := smE;
            end;
          smS :
            with Sender as TBaseField do begin
              NewHeight := Y;
              Constrain(NewHeight, 0, Self.Height - Top);
              AdjustHeightToGrid(Top, NewHeight);

              SetBounds(Left, Top, Width, NewHeight);
              if Height <= 1 then
                StretchMode := smN;
            end;
          smN :
            with Sender as TBaseField do begin
              NewTop := Top + Y;
              {Prevent creeping down when switching from smN to smS}
              Constrain(NewTop, 0, Top + Height);
              AdjustTopToGrid(NewTop);

              NewHeight := Height + Top - NewTop;
              Constrain(NewHeight, 0, Self.Height - NewTop);
              AdjustHeightToGrid(NewTop, NewHeight);

              SetBounds(Left, NewTop, Width, NewHeight);
              if Height <= 1 then
                StretchMode := smS;
            end;
          smNE :
            with Sender as TBaseField do begin
              NewTop := Top + Y;
              {Prevent creeping down when switching from smN? to smS?}
              Constrain(NewTop, 0, Top + Height);
              AdjustTopToGrid(NewTop);

              NewWidth := X;
              Constrain(NewWidth, 0, Self.Width - Left);
              AdjustWidthToGrid(Left, NewWidth);

              NewHeight := Height + Top - NewTop;
              Constrain(NewHeight, 0, Self.Height - NewTop);
              AdjustHeightToGrid(NewTop, NewHeight);

              SetBounds(Left, NewTop, NewWidth, NewHeight);
              if Width <= 1 then begin
                if Height <= 1 then
                  StretchMode := smSW
                else
                  StretchMode := smNW;
              end else if Height <= 1 then
                StretchMode := smSE;
            end;
          smSW :
            with Sender as TBaseField do begin
              NewLeft := Left + X;
              {Prevent creeping to right when switching from smW to smE}
              Constrain(NewLeft, 0, Left + Width);
              AdjustLeftToGrid(NewLeft);

              NewWidth := Width + Left - NewLeft;
              Constrain(NewWidth, 0, Self.Width - NewLeft);
              AdjustWidthToGrid(NewLeft, NewWidth);

              NewHeight := Y;
              Constrain(NewHeight, 0, Self.Height - Top);
              AdjustHeightToGrid(Top, NewHeight);

              SetBounds(NewLeft, Top, NewWidth, NewHeight);
              if Width <= 1 then begin
                if Height <= 1 then
                  StretchMode := smNE
                else
                  StretchMode := smSE;
              end else if Height <= 1 then
                StretchMode := smNW;
            end;
          smSE :
            with Sender as TBaseField do begin
              NewWidth := X;
              Constrain(NewWidth, 0, Self.Width - Left);
              AdjustWidthToGrid(Left, NewWidth);

              NewHeight := Y;
              Constrain(NewHeight, 0, Self.Height - Top);
              AdjustHeightToGrid(Top, NewHeight);

              SetBounds(Left, Top, NewWidth, NewHeight);
              if Width <= 1 then begin
                if Height <= 1 then
                  StretchMode := smNW
                else
                  StretchMode := smSW;
              end else if Height <= 1 then
                StretchMode := smNE;
            end;
          smNW :
            with Sender as TBaseField do begin
              NewLeft := Left + X;
              {Prevent creeping to right when switching from sm?W to sm?E}
              Constrain(NewLeft, 0, Left + Width);
              AdjustLeftToGrid(NewLeft);

              NewWidth := Width + Left - NewLeft;
              Constrain(NewWidth, 0, Self.Width - NewLeft);
              AdjustWidthToGrid(NewLeft, NewWidth);

              NewTop := Top + Y;
              {Prevent creeping down when switching from smN? to smS?}
              Constrain(NewTop, 0, Top + Height);
              AdjustTopToGrid(NewTop);

              NewHeight := Height + Top - NewTop;
              Constrain(NewHeight, 0, Self.Height - NewTop);
              AdjustHeightToGrid(NewTop, NewHeight);

              SetBounds(NewLeft, NewTop, NewWidth, NewHeight);
              if Width <= 1 then begin
                if Height <= 1 then
                  StretchMode := smSE
                else
                  StretchMode := smNE;
              end else if Height <= 1 then
                StretchMode := smSW;
            end;
        end;
        Application.ProcessMessages;
      finally
        fpDragging := False;
      end;

      with Sender as TBaseField do
        if Selected then begin
          FieldPositionChange(Left, Top, Width, Height);
          {Set Ruler position marks to the new coordinates}
          if Self.Owner is TFaxDesigner then
            (Self.Owner as TFaxDesigner).SetMarkPositions(Left, Top, Width, Height);
        end;
      FNeedsSaving := True;
    end;
    StretchMode := (Sender as TBaseField).StretchMode;

  end else
    StretchMode := smNone;
end;

procedure TFaxPanel.SizeMove(Sender : TObject; Key : Word; Shift : TShiftState);
var
  X, Y      : Integer;
  NewWidth  : Integer;
  NewHeight : Integer;
  Delta     : TPoint;
  I, J      : Integer;
  BF        : TBaseField;
begin
  if Sender is TBaseField then begin
    case Key of
      VK_UP    : Delta := Point(0, -1);
      VK_DOWN  : Delta := Point(0, 1);
      VK_RIGHT : Delta := Point(1, 0);
      VK_LEFT  : Delta := Point(-1, 0);
    else
      if (Key = VK_TAB) and (Shift = []) then begin
        {select next object}
        J := -1;
        for I := 0 to FieldCount-1 do
          if Field[I].Selected then begin
            J := I;
            Break;
          end;
        if J >= 0 then begin
          Field[J].Selected := False;
          Inc(J);
          if J >= FieldCount then
            J := 0;
          Field[J].Selected := True;
          Invalidate;
        end;
      end else if (Key = VK_TAB) and (Shift = [ssShift]) then begin
        {select previous object}
        J := -1;
        for I := 0 to FieldCount-1 do
          if Field[I].Selected then begin
            J := I;
            Break;
          end;
        if J >= 0 then begin
          Field[J].Selected := False;
          Dec(J);
          if J < 0 then
            J := FieldCount-1;
          Field[J].Selected := True;
          Invalidate;
        end;
      end;
      Exit;
    end;

    BF := Sender as TBaseField;
    if (ssShift in Shift) then begin
      {size}
      X := BF.Width + Delta.X;
      Y := BF.Height + Delta.Y;
      NewWidth := X;
      NewHeight := Y;
      Constrain(NewWidth, 0, Self.Width - BF.Left);
      Constrain(NewHeight, 0, Self.Height - BF.Top);
      BF.SetBounds(BF.Left, BF.Top, NewWidth, NewHeight);
    end else if (ssCtrl in Shift) then begin
      {move}
      X := BF.Left + Delta.X;
      Y := BF.Top + Delta.Y;
      Constrain(X, 0, Width);
      Constrain(Y, 0, Height);
      {Ensure field remains entirely within Self}
      Constrain(X, 0, Self.Width  - BF.Width);
      Constrain(Y,  0, Self.Height - BF.Height);
      BF.SetBounds(X, Y, BF.Width, BF.Height);
    end;
    
    with Sender as TBaseField do
      if Selected then begin
        FieldPositionChange(Left, Top, Width, Height);
        {Set Ruler position marks to the new coordinates}
        if Self.Owner is TFaxDesigner then
          (Self.Owner as TFaxDesigner).SetMarkPositions(Left, Top, Width, Height);
      end;
    FNeedsSaving := True;
  end;
end;

procedure TFaxPanel.FieldSelectionChange(IsFieldSelected : Boolean);
  {-Calls OnFieldSelectionChange event handler when a field becomes
    deselected or when a new field becomes selected}
begin
  if Assigned(FOnFieldSelectionChange) then
    FOnFieldSelectionChange(IsFieldSelected);
end;

procedure TFaxPanel.FieldPositionChange(ALeft, ATop, AWidth, AHeight : Integer);
  {-Calls OnFieldPositionChange event handler when the location or size of
    the currently-selected field changes}
begin
  if Assigned(FOnFieldPositionChange) then
    FOnFieldPositionChange(ALeft, ATop, AWidth, AHeight);
end;

procedure TFaxPanel.FieldChange(Sender : TObject);
begin
  FNeedsSaving := True;
end;

procedure TFaxPanel.AdjustLeftToGrid(var ALeft : Integer);
begin
  if FSnapToGrid then begin
    if ALeft < ctGridStart then
      ALeft := ctGridStart
    else if ALeft > fpMaxGridLine.X then
      ALeft := fpMaxGridLine.X
    else
      ALeft := (Round((ALeft - ctGridStart) / FGridSpacingX) * FGridSpacingX) + ctGridStart;
  end;
end;  

procedure TFaxPanel.AdjustTopToGrid(var ATop : Integer);
begin
  if FSnapToGrid then begin
    if ATop < ctGridStart then
      ATop := ctGridStart
    else if ATop > fpMaxGridLine.Y then
      ATop := fpMaxGridLine.Y
    else
      ATop := (Round((ATop - ctGridStart) / FGridSpacingY) * FGridSpacingY) + ctGridStart;
  end;
end;

procedure TFaxPanel.AdjustWidthToGrid(ALeft : Integer; var AWidth : Integer);
begin
  if FSnapToGrid then begin
    if AWidth < 0 then
      AWidth := 0
    else if ALeft + AWidth > fpMaxGridLine.X then
      AWidth := fpMaxGridLine.X - ALeft
    else
      AWidth := Round((AWidth) / FGridSpacingX) * FGridSpacingX + 1;
  end;
end;

procedure TFaxPanel.AdjustHeightToGrid(ATop : Integer; var AHeight : Integer);
begin
  if FSnapToGrid then begin
    if AHeight < 0 then
      AHeight := 0
    else if ATop + AHeight > fpMaxGridLine.Y then
      AHeight := fpMaxGridLine.Y - ATop
    else
      AHeight := Round((AHeight) / FGridSpacingY) * FGridSpacingY + 1;
  end;
end;

function TFaxPanel.GetDrawAdjustFactor : Double;
const
  ctFaxWidthInPixels = 1728;  {Faxes are 1728 pixels in width}
begin
  if Width = 0 then
    Result := 0.0
  else
    Result := ((ctFaxWidthInPixels / 2) - 10) / Width;
end;

function TFaxPanel.GetDrawWidth : Integer;
begin
  Result := Round(Width * DrawAdjustFactor);
end;

function TFaxPanel.GetDrawHeight : Integer;
begin
  Result := Round(Height * DrawAdjustFactor);
end;

procedure TFaxPanel.SetStretchMode(NewStretchMode : TStretchModes);
begin
  if NewStretchMode <> FStretchMode then begin
    FStretchMode := NewStretchMode;
    case FStretchMode of
      smN, smS   : Cursor := crSizeNS;
      smE, smW   : Cursor := crSizeWE;
      smNW, smSE : Cursor := crSizeNWSE;
      smNE, smSW : Cursor := crSizeNESW;
      else Cursor := crDefault;
    end;
  end;
end;

procedure TFaxPanel.FieldPositionChangeForSelectedField;
var
  I     : Integer;
  Field : TBaseField;
begin
  for I := 0 to fpFieldList.Count - 1 do begin
    Field := fpFieldList[I];
    with Field do
      if Selected then begin
        FieldPositionChange(Left, Top, Width, Height);
        Break; {Only one field can be selected at a time and we just found it, so exit loop}
      end;
  end;
end;

procedure TFaxPanel.Write(Stream : TStream);
var
  I         : Integer;
  NumFields : LongInt;
  Field     : TBaseField;
begin
  {Write the number of fields to the stream}
  NumFields := fpFieldList.Count;
  Stream.WriteBuffer(NumFields, SizeOf(NumFields));

  {Write out each field's information}
  for I := 0 to fpFieldList.Count - 1 do begin
    Field := fpFieldList[I];
    Field.Write(Stream);
  end;

  {We just saved, so set NeedsSaving to False}
  FNeedsSaving := False;
end;

procedure TFaxPanel.Read(Stream : TStream);
var
  FieldType : Byte;
  I         : Integer;
  NumFields : LongInt;
  Field     : TBaseField;
begin
  {Clear out fpFieldList to ensure we're starting off with an empty FaxPanel}
  DeleteAllFields;

  {Read the number of fields that were written out to the stream}
  Stream.ReadBuffer(NumFields, SizeOf(NumFields));

  {For each field, create a new field of the proper type, and then let it read
   itself in}
  for I := 1 to NumFields do begin
    Field := nil;
    Stream.ReadBuffer(FieldType, SizeOf(FieldType));
    case FieldType of
      ftTextField  : Field := AddTextField;
      ftImageField : Field := AddImageField;
    end;
    if Assigned(Field) then
      Field.Read(Stream);
  end;

  {No changes have been made yet, so set NeedsSaving to False}
  FNeedsSaving := False;
end;

procedure TFaxPanel.Draw(ACanvas : TCanvas);
var
  I     : Integer;
  Field : TBaseField;
begin
  {Draw each field}
  for I := 0 to fpFieldList.Count - 1 do begin
    Field := fpFieldList[I];
    Field.Draw(ACanvas);
  end;
end;

function TFaxPanel.HorzPixelsToInches(P : Integer) : Double;
begin
  if fpHorzPixelsPerInch = 0.0 then
    Result := 0.0
  else
    Result := P / fpHorzPixelsPerInch;
end;

function TFaxPanel.VertPixelsToInches(P : Integer) : Double;
begin
  if fpVertPixelsPerInch = 0.0 then
    Result := 0.0
  else
    Result := P / fpVertPixelsPerInch;
end;

function TFaxPanel.HorzInchesToPixels(Inches : Double) : Integer;
begin
  Result := Round(Inches * fpHorzPixelsPerInch);
end;

function TFaxPanel.VertInchesToPixels(Inches : Double) : Integer;
begin
  Result := Round(Inches * fpVertPixelsPerInch);
end;

procedure TFaxPanel.DeselectAllFields;
var
  I     : Integer;
  Field : TBaseField;
begin
  for I := fpFieldList.Count - 1 downto 0 do begin
    Field := fpFieldList[I];
    Field.Selected := False;
  end;
end;

procedure TFaxPanel.DeleteAllFields;
var
  I     : Integer;
  Field : TBaseField;
begin
  for I := fpFieldList.Count - 1 downto 0 do begin
    Field := fpFieldList[I];
    Field.Free;
    fpFieldList.Remove(fpFieldList[I]);
  end;
  FNeedsSaving := True;
end;

procedure TFaxPanel.AddField(Field : TBaseField);
var
  NewLeft   : Integer;
  NewTop    : Integer;
  NewWidth  : Integer;
  NewHeight : Integer;
begin
  DeselectAllFields;

  NewLeft := fpMouseAnchor.X;
  NewTop  := fpMouseAnchor.Y;
  with Field do begin
    {Update NewLeft and NewTop to ensure new field will be entirely within MainPanel}
    Constrain(NewLeft, 0, Self.Width  - Width);
    Constrain(NewTop,  0, Self.Height - Height);
    NewWidth  := Width;
    NewHeight := Height;
    {If SnapToGrid is enabled, adjust coordinates to be on grid lines}
    if FSnapToGrid then begin
      AdjustLeftToGrid(NewLeft);
      AdjustTopToGrid(NewTop);
      AdjustWidthToGrid(NewLeft, NewWidth);
      AdjustHeightToGrid(NewTop, NewHeight);
    end;
    SetBounds(NewLeft, NewTop, NewWidth, NewHeight);
    Parent   := Self;
    Visible  := True;
    Selected := True; {New fields start out Selected}
  end;
  if Field is TTextField then
    (Field as TTextField).SetFocus;
  fpFieldList.Add(Field);

  FieldSelectionChange(True);
  with Field do
    FieldPositionChange(Left, Top, Width, Height);

  FNeedsSaving := True;

  Inc(fpMouseAnchor.X, 5);
  Inc(fpMouseAnchor.Y, 5);
end;

function TFaxPanel.AddTextField : TTextField;
begin
  Result := TTextField.Create(nil);
  AddField(Result);
end;

function TFaxPanel.AddImageField : TImageField;
begin
  Result := TImageField.Create(nil);
  AddField(Result);
end;

procedure TFaxPanel.DeleteSelectedField;
var
  I     : Integer;
  Field : TBaseField;
begin
  {Delete all fields that are currently selected}
  for I := fpFieldList.Count - 1 downto 0 do begin
    Field := fpFieldList[I];
    if Field.Selected then begin
      Field.Free;
      fpFieldList.Remove(fpFieldList[I]);
      FNeedsSaving := True;
    end;
  end;
  {Turn Ruler position marks off since no fields are selected}
  if Self.Owner is TFaxDesigner then
    (Self.Owner as TFaxDesigner).SetMarkPositions(-1, -1, -1, -1);
end;  

procedure TFaxPanel.CenterSelectedField(IsHorizontal : Boolean);
var
  I      : Integer;
  NewPos : Integer;
  Field  : TBaseField;
begin
  for I := fpFieldList.Count - 1 downto 0 do begin
    Field := fpFieldList[I];
    if Field.Selected then begin
      if IsHorizontal then begin
        NewPos := Round((Width - Field.Width) / 2);
        AdjustLeftToGrid(NewPos);  {Align to grid if SnapToGrid is enabled}
        Field.Left := NewPos;
      end else begin
        NewPos := Round((Height - Field.Height) / 2);
        AdjustTopToGrid(NewPos);  {Align to grid if SnapToGrid is enabled}
        Field.Top := NewPos;
      end;
      with Field do begin
        FieldPositionChange(Left, Top, Width, Height);
        {Set Ruler position marks to the new coordinates}
        if Self.Owner is TFaxDesigner then
          (Self.Owner as TFaxDesigner).SetMarkPositions(Left, Top, Width, Height);
      end;
      FNeedsSaving := True;
      Break;
    end;
  end;
end;

function TFaxPanel.SelectedFieldsExist : Boolean;
var
  I     : Integer;
  Field : TBaseField;
begin
  Result := False;
  for I := 0 to fpFieldList.Count - 1 do begin
    Field := fpFieldList[I];
    if Field.Selected then begin
      Result := True;
      Break;
    end;
  end;
end;


{------------------------------- TFaxScrollBox ------------------------------}

procedure TFaxScrollBox.WMHScroll(var Message : TWMHScroll);
var
  Dummy : Integer;
begin
  inherited;

  if Assigned(FOnHorzScroll) and (Message.ScrollBar = 0) and HorzScrollBar.Visible then
    {Doesn't matter what parameters we pass because they aren't used}
    FOnHorzScroll(nil, scTop, Dummy);
end;

procedure TFaxScrollBox.WMVScroll(var Message : TWMVScroll);
var
  Dummy : Integer;
begin
  inherited;
  if Assigned(FOnVertScroll) and (Message.ScrollBar = 0) and VertScrollBar.Visible then
    {Doesn't matter what parameters we pass because they aren't used}
    FOnVertScroll(nil, scTop, Dummy);
end;


{*** TFaxDesigner ***}

constructor TFaxDesigner.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  Align       := alClient;
  BevelInner  := bvNone;
  BevelOuter  := bvRaised;
  BorderStyle := bsNone;
  FIsNew      := True;

  fdScrollBox := TFaxScrollBox.Create(Self);
  with fdScrollBox do begin
    BorderStyle := bsNone;
    Parent      := Self;
    {$IFDEF Win32}
    HorzScrollBar.Tracking := True;
    VertScrollBar.Tracking := True;
    {$ENDIF}
    OnHorzScroll := HorzScroll;
    OnVertScroll := VertScroll;
  end;

  fdHorzRuler := TRuler.Create(Self);
  with fdHorzRuler do begin
    IsHorizontal := True;
    Parent       := Self;
  end;

  fdVertRuler := TRuler.Create(Self);
  with fdVertRuler do begin
    IsHorizontal := False;
    Parent       := Self;
  end;

  FFaxPanel := TFaxPanel.Create(Self);
  with FFaxPanel do begin
    Color  := clWindow;
    Parent := fdScrollBox;
  end;

  {These access FFaxPanel, so they must be called AFTER FFaxPanel is created}
  SetPageWidthPixels(ctDefaultWidthPixels);
  SetPageHeightPixels(ctDefaultHeightPixels);
  SetPageWidthInches(ctDefaultWidthInches);
  SetPageHeightInches(ctDefaultHeightInches);

  {FaxPanel.NeedsSaving will have been changed to True when we set the Width and
   Height in Inches. No changes have actually been made, so reset it to False.}
  FFaxPanel.NeedsSaving := False;
end;

procedure TFaxDesigner.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  Length    : Integer;
  OldWidth  : Integer;
  OldHeight : Integer;
  Dummy     : Integer;
begin
  OldWidth  := Width;
  OldHeight := Height;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  if Parent <> nil then begin
    fdScrollBox.SetBounds(ALeft + fdVertRuler.Width, ATop + fdHorzRuler.Height,
                          Self.ClientWidth - fdVertRuler.Width,
                          Self.ClientHeight - fdHorzRuler.Height);

    {Ensure that HorzRuler doesn't get longer than the width of the FaxPanel}
    if Self.ClientHeight - fdHorzRuler.Height < FFaxPanel.Height then
      Length := Self.ClientHeight - fdHorzRuler.Height
    else
      Length := FFaxPanel.Height;
    fdVertRuler.SetBounds(0, fdHorzRuler.Height, fdVertRuler.Width, Length);

    {Ensure that VertRuler doesn't get taller than the height of the FaxPanel}
    if Self.ClientWidth - fdVertRuler.Width < FFaxPanel.Width then
      Length := Self.ClientWidth - fdVertRuler.Width
    else
      Length := FFaxPanel.Width;
    fdHorzRuler.SetBounds(fdVertRuler.Width, 0, Length, fdHorzRuler.Height);

    {If the form has been made wider or taller, its possible that the one of the
     rulers might need to "scroll" to match, so call HorzScroll or VertScroll
     as needed. It doesn't matter what parameters we pass because the parameters
     aren't used.}
    if Width <> OldWidth then
      HorzScroll(nil, scTop, Dummy);
    if Height <> OldHeight then
      VertScroll(nil, scTop, Dummy);
  end;
end;  

procedure TFaxDesigner.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if Assigned(AParent) then
    {Now that a Parent is set, call SetBounds to put the Rulers in the correct positions}
    SetBounds(Left, Top, Width, Height);
end;

procedure TFaxDesigner.HorzScroll(Sender: TObject; ScrollCode: TScrollCode;
                              var ScrollPos: Integer);
var
  X, Y : Integer;
begin
  {Find the leftmost FFaxPanel point that is displaying within fdScrollBox}
  X := 0;
  Y := 0;
  ConvertCoords(fdScrollBox, FFaxPanel, X, Y);

  {Scroll fdHorzRuler to match the scroll position of FFaxPanel}
  fdHorzRuler.StartPosition := X;
end; 

procedure TFaxDesigner.VertScroll(Sender: TObject; ScrollCode: TScrollCode;
                              var ScrollPos: Integer);
var
  X, Y : Integer;
begin
  {Find the topmost FFaxPanel point that is displaying within fdScrollBox}
  X := 0;
  Y := 0;
  ConvertCoords(fdScrollBox, FFaxPanel, X, Y);

  {Scroll fdVertRuler to match the scroll position of FFaxPanel}
  fdVertRuler.StartPosition := Y;
end;

function TFaxDesigner.GetPageWidthPixels : Integer;
begin
  Result := FFaxPanel.Width;
end;

procedure TFaxDesigner.SetPageWidthPixels(AWidth : Integer);
var
  Dummy : Integer;
begin
  if FFaxPanel.Width <> AWidth then begin
    FFaxPanel.Width := AWidth;
    if Assigned(fdHorzRuler) then begin
      fdHorzRuler.SizePixels := AWidth;
      {Call SetBounds to force fdHorzRuler to the correct size}
      SetBounds(Left, Top, Width, Height);
      if Parent <> nil then
        HorzScroll(nil, scTop, Dummy);  {Update ruler position}
    end;
  end;
end;

function TFaxDesigner.GetPageHeightPixels : Integer;
begin
  Result := FFaxPanel.Height;
end;

procedure TFaxDesigner.SetPageHeightPixels(AHeight : Integer);
var
  Dummy : Integer;
begin
  if FFaxPanel.Height <> AHeight then begin
    FFaxPanel.Height := AHeight;
    if Assigned(fdVertRuler) then begin
      fdVertRuler.SizePixels := AHeight;
      {Call SetBounds to force fdVertRuler to the correct size}
      SetBounds(Left, Top, Width, Height);
      if Parent <> nil then
        VertScroll(nil, scTop, Dummy);  {Update ruler position}
    end;
  end;
end;

function TFaxDesigner.GetPageWidthInches : Double;
begin
  Result := FFaxPanel.PageWidthInches;
end;

procedure TFaxDesigner.SetPageWidthInches(AWidth : Double);
begin
  if Assigned(fdHorzRuler) then
    fdHorzRuler.SizeInches := AWidth;
  FFaxPanel.PageWidthInches := AWidth;
  {Adjust page height in pixels so the width-to-height ratio of the FaxPanel
   matches the width-to-height ratio of the page size}
  if PageWidthInches <> 0.0 then
    SetPageHeightPixels(Round(PageHeightInches * PageWidthPixels / PageWidthInches));
end; 

function TFaxDesigner.GetPageHeightInches : Double;
begin
  Result := FFaxPanel.PageHeightInches;
end;

procedure TFaxDesigner.SetPageHeightInches(AHeight : Double);
begin
  if Assigned(fdVertRuler) then
    fdVertRuler.SizeInches := AHeight;
  FFaxPanel.PageHeightInches := AHeight;
  {Adjust page height in pixels so the width-to-height ratio of the FaxPanel
   matches the width-to-height ratio of the page size}
  if PageWidthInches <> 0.0 then
    SetPageHeightPixels(Round(PageHeightInches * PageWidthPixels / PageWidthInches));
end;

procedure TFaxDesigner.SetIsMetric(AIsMetric : Boolean);
begin
  if AIsMetric <> FIsMetric then begin
    FIsMetric := AIsMetric;
    if Assigned(fdHorzRuler) then
      fdHorzRuler.IsMetric := AIsMetric;
    if Assigned(fdVertRuler) then
      fdVertRuler.IsMetric := AIsMetric;
    {Update position display to be in the new units of measurement (metric or English)}
    FFaxPanel.FieldPositionChangeForSelectedField;
  end;
end;

procedure TFaxDesigner.SetMarkPositions(ALeft, ATop, AWidth, AHeight : Integer);
begin
  if Assigned(fdHorzRuler) then
    fdHorzRuler.SetMarkPositions(ALeft, ALeft + AWidth);
  if Assigned(fdVertRuler) then
    fdVertRuler.SetMarkPositions(ATop, ATop + AHeight);
end;

procedure TFaxDesigner.Read(Stream : TStream);
var
  PageRec : TPageRecord;
begin
  {Read PageRec and assign its properties to Self}
  Stream.ReadBuffer(PageRec, SizeOf(PageRec));
  with PageRec do begin
    if prVersionNum <> ctVersionNum then begin
      MessageDlg('Version mismatch! Unable to read Fax Cover Page!', mtError, [mbOK], 0);
      Exit;
    end;
    SetPageWidthPixels(prPageWidthPixels);
    SetPageHeightPixels(prPageHeightPixels);
    SetPageWidthInches(prPageWidthInches);
    SetPageHeightInches(prPageHeightInches);
    SetIsMetric(prIsMetric);
    FUserData := prUserData;
  end;

  {Now let the FaxPanel read all of its data}
  FFaxPanel.Read(Stream);

  {Set IsNew to False since this was an already-existing cover page}
  FIsNew := False;
end;

procedure TFaxDesigner.Write(Stream : TStream);
var
  PageRec : TPageRecord;
begin
  {Initialize PageRec with values defining this page layout, and write it out}
  FillChar(PageRec, SizeOf(PageRec), 0);
  with PageRec do begin
    prVersionNum       := ctVersionNum;
    prPageWidthPixels  := GetPageWidthPixels;
    prPageHeightPixels := GetPageHeightPixels;
    prPageWidthInches  := GetPageWidthInches;
    prPageHeightInches := GetPageHeightInches;
    prIsMetric         := FIsMetric;
    prUserData         := FUserData;
  end;
  Stream.WriteBuffer(PageRec, SizeOf(PageRec));

  {Now let the FaxPanel write all of its data out}
  FFaxPanel.Write(Stream);

  {Set IsNew to False since a real name has now been assigned to this cover page}
  FIsNew := False;
end;

end.
