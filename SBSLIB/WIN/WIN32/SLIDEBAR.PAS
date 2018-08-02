unit SlideBar;

interface

{$R SLIDEBAR.RES}

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus;

type
  TBarStyle    = (bsLowered,bsRaised);
  TOrientation = (orVertical,orHorizontal);
  TThumbStyle  = (tsBar1,tsBar2,tsBar3,tsBar4,tsCircle1,tsSquare1,
                  tsDiamond1,tsDiamond2,tsDiamond3,tsDiamond4);
  TSlideBar = class(TCustomControl)
  private
    FFocusColor              : TColor;
    FHandCursor              : Boolean;
    FLabels2,
    FLabels                  : TStringList;
    FMax,FMin,FPosition      : Integer;
    FOrientation             : TOrientation;

    FStyle                   : TBarStyle;
    FThickness               : Byte;
    FThumbStyle              : TThumbStyle;
    FTicks                   : Boolean;
    FOnChange                : TNotifyEvent;
    ThumbBmp,MaskBmp,BkgdBmp : TBitmap;
    DragVal,HalfTW,HalfTH    : Integer;
    ThumbRect                : TRect;
    TempDC                   : HDC;
    HandPointer              : HCursor;
    OriginalCursor           : HCursor;
    fBkGdBmp                 : TBitmap;


    procedure BuildList;
    procedure SetLabels(A: TStringList);
    procedure SetMax(A: Integer);
    procedure SetMin(A: Integer);
    procedure SetOrientation(A: TOrientation);
    procedure SetPosition(A: Integer);
    procedure SetStyle(A: TBarStyle);

    procedure SetThickness(A: Byte);
    procedure SetThumbStyle(A: TThumbStyle);
    procedure SetTicks(A: Boolean);
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMSize(var Message: TWMSize);             message WM_SIZE;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  protected
    Dragging                 : Boolean;
    procedure Paint; override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    function  NewPosition(WhereX,WhereY: Integer): Integer;
    function  IsVert: Boolean;
    procedure RemoveThumbBar;
    procedure DrawThumbBar;
    procedure DrawTrench;
    procedure SaveBackground;
    procedure WhereIsBar;
    procedure PaintBox;
    procedure SetTLColor;
    procedure SetBRColor;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CurrentLabel: String;
  published
    property Enabled;
    property FocusColor: TColor read FFocusColor
                         write FFocusColor default clBlack;

    property HandCursor: Boolean read FHandCursor
                         write FHandCursor default True;
    property Labels: TStringList read FLabels write SetLabels;
    property Labels2: TStringList read FLabels2 write SetLabels;
    property Max: Integer read FMax write SetMax default 10;
    property Min: Integer read FMin write SetMin default 1;
    property Orientation: TOrientation read FOrientation
                          write SetOrientation default orHorizontal;
    property ParentShowHint;
    property Position: Integer read FPosition write SetPosition default 1;
    property PopupMenu;
    property ShowHint;

    property Style: TBarStyle read FStyle write SetStyle default
 bsLowered;
    property TabStop default True;
    property TabOrder;
    property Thickness: Byte read FThickness write SetThickness default 1;
    property ThumbStyle: TThumbStyle read FThumbStyle
                         write SetThumbStyle default tsCircle1;
    property Ticks: Boolean read FTicks write SetTicks default True;
    property Visible;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;

  end;

procedure Register;

implementation


Const
  gcw_HCursor       = (-12);
  
function MinInt(A,B: Integer): Integer;
begin
  If A > B Then MinInt := B Else MinInt := A;
end;

function MaxInt(A,B: Integer): Integer;
begin
  If A > B Then MaxInt := A Else MaxInt := B;
end;

procedure Register;
begin
  RegisterComponents('Standard', [TSlideBar]);
end;

(******************
 TSlideBar Methods
******************)

constructor TSlideBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Height := 15;
  Width := 100;
  ThumbBmp := TBitmap.Create;
  MaskBmp := TBitmap.Create;
  BkgdBmp := TBitmap.Create;
  HandPointer := LoadCursor(HInstance, 'HandPointer');
  FFocusColor := clBlack;
  FHandCursor := True;

  FLabels := TStringList.Create;
  FLabels2 := TStringList.Create;

  FMin := 1;
  FMax := 10;
  FOrientation := orHorizontal;
  FPosition := 1;
  FStyle := bsLowered;
  FThickness := 1;
  FTicks := True;
  Dragging := False;
  DragVal := 0;
  ThumbStyle := tsCircle1;
  TabStop := True;
  fBkgdBmp := TBitmap.Create;
  BuildList;
end;

destructor TSlideBar.Destroy;
begin
  FLabels.Free;
  FLabels2.Free;
  ThumbBmp.Free;
  MaskBmp.Free;
  BkgdBmp.Free;
  fBkgdBmp.Free;
  inherited Destroy;
end;

procedure TSlideBar.CMEnter(var Message: TCMGotFocus);
begin
  inherited;

  Refresh;
end;

procedure TSlideBar.CMExit(var Message: TCMExit);
begin
  inherited;
  Refresh;
end;

function TSlideBar.IsVert: Boolean;
begin
  IsVert := (Orientation = orVertical);
end;

procedure TSlideBar.KeyDown(var Key: Word; Shift: TShiftState);
var
  b : Integer;
begin
  b := MaxInt(1,(Max-Min) div 10);
  case Key of
    VK_PRIOR : if (Position-b) > Min then
                 Position := Position - b else Position := Min;
    VK_NEXT  : if (Position+b) < Max then

                 Position := Position + b else Position := Max;
    VK_END   : if IsVert then Position := Min else Position := Max;
    VK_HOME  : if IsVert then Position := Max else Position := Min;
    VK_LEFT  : if Position > Min then Position := Position - 1;
    VK_UP    : if Position < Max then Position := Position + 1;
    VK_RIGHT : if Position < Max then Position := Position + 1;
    VK_DOWN  : if Position > Min then Position := Position - 1;
  end;
end;

procedure TSlideBar.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;

  OriginalCursor := GetClassWord(Handle, GCW_HCURSOR);
end;

procedure TSlideBar.WMSize(var Message: TWMSize);
begin
  if Height > Width then
    Orientation := orVertical else Orientation := orHorizontal;
end;

procedure TSlideBar.SetLabels(A: TStringList);
begin
  FLabels.Assign(A);
end;

procedure TSlideBar.SetMin(A: Integer);
begin
  FMin := A;
  Refresh;
end;

procedure TSlideBar.SetMax(A: Integer);
begin
  FMax := A;
  Refresh;
end;

procedure TSlideBar.SetOrientation(A: TOrientation);
begin

  FOrientation := A;
  Refresh;
end;

procedure TSlideBar.SetPosition(A: Integer);
begin
  if csDesigning in ComponentState then
    begin
      if (A >= Min) and (A <= Max) Then FPosition := A;
      Refresh;
    end
  else
    begin
      RemoveThumbBar;
      if (A >= Min) and (A <= Max) Then FPosition := A;
      WhereIsBar;
      SaveBackground;
      DrawThumbBar;
      if Assigned(FOnChange) then FOnChange(Self);
    end;
end;

procedure TSlideBar.SetStyle(A: TBarStyle);
begin
  FStyle := A;
  Refresh;
end;

procedure TSlideBar.SetThickness(A: Byte);
begin
  If (A > 0) and (A < 6) then
    begin FThickness := A; Refresh; end;
end;

procedure TSlideBar.SetThumbStyle(A: TThumbStyle);
begin
  If ThumbStyle <> A then
    begin
      FThumbStyle := A;
      case ThumbStyle of
        tsBar1     :   ThumbBmp.Handle := LoadBitmap(HInstance,'Bar1');
        tsBar2     :   ThumbBmp.Handle := LoadBitmap(HInstance,'Bar2');
        tsBar3     :   ThumbBmp.Handle := LoadBitmap(HInstance,'Bar3');
        tsBar4     :   ThumbBmp.Handle := LoadBitmap(HInstance,'Bar4');

        tsCircle1  :   ThumbBmp.Handle := LoadBitmap(HInstance,'Circle1');
        tsSquare1  :   ThumbBmp.Handle := LoadBitmap(HInstance,'Square1');
        tsDiamond1 :   ThumbBmp.Handle := LoadBitmap(HInstance,'Diamond1');
        tsDiamond2 :   ThumbBmp.Handle := LoadBitmap(HInstance,'Diamond2');
        tsDiamond3 :   ThumbBmp.Handle := LoadBitmap(HInstance,'Diamond3');
        tsDiamond4 :   ThumbBmp.Handle := LoadBitmap(HInstance,'Diamond4');
      end;
      case ThumbStyle of
        tsBar1     :   MaskBmp.Handle := LoadBitmap(HInstance,'Bar1Mask');
        tsBar2     :   MaskBmp.Handle := LoadBitmap(HInstance,'Bar2Mask');
        tsBar3     :   MaskBmp.Handle := LoadBitmap(HInstance,'Bar3Mask');
        tsBar4     :   MaskBmp.Handle := LoadBitmap(HInstance,'Bar4Mask');
        tsCircle1  :   MaskBmp.Handle := LoadBitmap(HInstance,'Circle1Mask');
        tsSquare1  :   MaskBmp.Handle := LoadBitmap(HInstance,'Square1Mask');
        tsDiamond1 :   MaskBmp.Handle := LoadBitmap(HInstance,'Diamond1Mask');

        tsDiamond2 :   MaskBmp.Handle := LoadBitmap(HInstance,'Diamond2Mask');
        tsDiamond3 :   MaskBmp.Handle := LoadBitmap(HInstance,'Diamond3Mask');
        tsDiamond4 :   MaskBmp.Handle := LoadBitmap(HInstance,'Diamond4Mask');
      end;
      HalfTH := ThumbBmp.Height div 2;
      HalfTW := ThumbBmp.Width div 2;
      Refresh;
    end;
end;

procedure TSlideBar.SetTicks(A: Boolean);
begin
  FTicks := A;
  Refresh;
end;

procedure TSlideBar.BuildList;

Var
  n      :  Integer;
  HList  :  String;

Begin
  HList:='';



  With Labels2 do
  Begin

    For n:=1989 to 1999 do
      Add(IntToStr(n));

    For n:=0 to Pred(Count) do
      HList:=HList+Labels2[n]+'     ';

  end;

  try
    With fBkgdBmp,Canvas do
    Begin

      Width:=TextWidth(HList);
      Height:=TextHeight(HList);

      Pen.Color:=clBlack;
      Pen.Style:=psSolid;
      Font.Color:=clBlack;
      Brush.Color:=clWhite;
      TextOut(0,0,HList);

    end; {With..}

  except

    fBkgdBmp.Free;

  end; {try..}
end; {Proc.}

function TSlideBar.CurrentLabel: String;
begin
  if ((Position-Min+1) <= Labels.Count) and (Position >= Min) then
    CurrentLabel := Labels[Position-Min]

  else
    CurrentLabel := '<Un-Defined>';
end;

function TSlideBar.NewPosition(WhereX,WhereY: Integer): Integer;
var
  H1,W1 : Integer;
begin
  {Calculate the nearest position to where the mouse is located}
  H1 := Height-HalfTH;
  W1 := Width-HalfTW;
  if IsVert then
    Result := Round(((H1-WhereY)/H1)*(Max-Min)+Min)
  else
    Result := Round((WhereX/W1)*(Max-Min)+Min);
  Result := MinInt(MaxInt(Result,Min),Max);
end;

procedure TSlideBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

var
  A,B,C,D,E : Integer;
begin
  if Button <> mbLeft then exit;
  C := Position-1;
  D := Position;
  E := Position+1;
  {B is the center of the ThumbBar}
  if IsVert then B := ThumbRect.Top+HalfTH else B := ThumbRect.Left+HalfTW;
  if Dragging then
    A := NewPosition(X,Y)
  else
    if IsVert then
      if Y < B then A := E else if Y > B then A := C else A := D
    else

      if X < B then A := C else if X > B then A := E else A := D;
  A := MinInt(MaxInt(A,Min),Max);
  Dragging := False;
  Position := A;
end;

procedure TSlideBar.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SetFocus;
  Dragging := PtInRect(ThumbRect,Point(X,Y));
  If IsVert then DragVal := Y else DragVal := X;
end;

procedure TSlideBar.MouseMove(Shift: TShiftState; X, Y: Integer);
Var
  LastDragVal : Integer;
begin
  if HandCursor then

    SetClassWord(Handle, GCW_HCURSOR, HandPointer)
  else
    SetClassWord(Handle, GCW_HCURSOR, OriginalCursor);
  {Is the left mouse button down and dragging the thumb bar?}
  if (ssLeft in Shift) and Dragging then
    begin
      LastDragVal := DragVal;
      if IsVert then DragVal := Y else DragVal := X;
      {This test eliminates unneccesary repaints}
      if DragVal <> LastDragVal then Position := NewPosition(X,Y);
    end;
end;

procedure TSlideBar.RemoveThumbBar;
begin
  {Place the background bitmap where it was last}

  Canvas.Draw(ThumbRect.Left,ThumbRect.Top,BkgdBmp);
end;

procedure TSlideBar.DrawThumbBar;
var
  TmpBmp  : TBitMap;
  Rect1   : TRect;
begin
  try
    {Define a rectangle to mark the dimensions of the thumbbar}
    Rect1 := Rect(0,0,ThumbBmp.Width,ThumbBmp.Height);
    {Create a working bitmap}

    TmpBmp := TBitmap.Create;
    
    TmpBmp.Height := ThumbBmp.Height;
    TmpBmp.Width := ThumbBmp.Width;
    {Copy the background area onto the working bitmap}
    TmpBmp.Canvas.CopyMode := cmSrcCopy;

    TmpBmp.Canvas.CopyRect(Rect1,BkgdBmp.Canvas,Rect1);
    {Copy the mask onto the working bitmap with SRCAND}
    TmpBmp.Canvas.CopyMode := cmSrcAnd;
    TmpBmp.Canvas.CopyRect(Rect1,MaskBmp.Canvas,Rect1);
    {Copy the thumbbar onto the working bitmap with SRCPAINT}
    TmpBmp.Canvas.CopyMode := cmSrcPaint;
    TmpBmp.Canvas.CopyRect(Rect1,ThumbBmp.Canvas,Rect1);
    {Now draw the thumb bar}
    Canvas.CopyRect(ThumbRect,TmpBmp.Canvas,Rect1);
  finally
    TmpBmp.Free;
  end;

end;


procedure TSlideBar.PaintBox;

Var
  R1,SR  :  TRect;
  Scale  :  Integer;

begin
  Scale:=Position;

  With Canvas do
  Begin
    R1:=Rect(0,15,Width,FbkgdBmp.Height+15);
    SR:=Rect(Scale,0,Width+Scale,fBkgdBmp.Height);

    Pen.Color:=clBlack;
    Pen.Style:=psSolid;
    Font.Color:=clBlack;
    Brush.Color:=clWhite;

    CopyMode:=cmSrcCopy;


    CopyRect(R1,fBkgdBmp.Canvas,SR);

  end; {With..}
end;


procedure TSlideBar.WhereIsBar;
var
  Each          : Real;
  ThumbX,ThumbY : Integer;
begin
  {Calculate where to paint the thumb bar - store in ThumbRect}
  if IsVert then
    begin
      Each := (Height-ThumbBmp.Height)/(Max-Min);
      If Dragging then
        ThumbY := DragVal-HalfTH
      else
        ThumbY := Height-Round(Each*(Position-Min))-ThumbBmp.Height;
      ThumbY := MaxInt(0,MinInt(Height-ThumbBmp.Height,ThumbY));
      ThumbX := (Width-ThumbBmp.Width) div 2;
    end

  else
    begin
      Each := (Width-ThumbBmp.Width)/(Max-Min);
      if Dragging then
        ThumbX := DragVal-HalfTW
      else
        ThumbX := Round(Each*(Position-Min));
      ThumbX := MaxInt(0,MinInt(Width-ThumbBmp.Width,ThumbX));
      ThumbY := 10-(ThumbBmp.Height) div 2;
    end;
  ThumbRect := Rect(ThumbX,ThumbY,ThumbX+ThumbBmp.Width,ThumbY+ThumbBmp.Height);
  PaintBox;
end;

procedure TSlideBar.SetTLColor;
begin
  {Set the Top/Left color for the trench. Controls raised or lowered styles}
  With Canvas do

    if Style = bsLowered then Pen.Color := clGray else Pen.Color := clWhite;
end;

procedure TSlideBar.SetBRColor;
begin
  {Set the Bottom/Right color for the trench. Controls raised or lowered styles}
  With Canvas do
    if Style = bsRaised then Pen.Color := clGray else Pen.Color := clWhite;
end;

procedure TSlideBar.DrawTrench;
var
  X1,Y1,X2,Y2 : Integer;
  Each        : Real;
  Tmp,TickPos : Integer;
begin
  {This procedure simply draws the slot that the thumb bar will travel through}
  {including the tick-marks. The bar itself is not drawn.}

  with Canvas do begin
    {Calculate the corners of the trench dependant on orientation}
    if IsVert then
      begin
        X1 := (Width div 2) - (Thickness div 2) - 1;
        X2 := X1 + Thickness + 1;
        Y1 := HalfTH;
        Y2 := Height-ThumbBmp.Height+Y1;
      end
    else
      begin
        X1 := HalfTW;
        X2 := Width-ThumbBmp.Width+X1;
        Y1 := 10 - (Thickness div 2) - 1;
        Y2 := Y1 + Thickness + 1;
      end;
    Pen.Style := psSolid;
    {Set the color for the Top & Left edges}

    SetTLColor;
    MoveTo(X2,Y1);
    LineTo(X1,Y1);
    LineTo(X1,Y2);
    {Set the color for the Bottom & Right edges}
    SetBRColor;
    LineTo(X2,Y2);
    LineTo(X2,Y1-1);
    {Now do a filled black rectangle in the center if the control has focus}
    with brush do if Focused then Color := FocusColor else Color := clSilver;
    Pen.Style := psClear;
    {Draw the focus highlight}
    Rectangle(X1+1,Y1+1,X2+1,Y2+1);
    Pen.Style := psSolid;
    {Calculate spacing of tick marks}
    Each := 0;
    if Ticks then
      if (Max-Min) > 0 then

        if IsVert then
          Each := (Height-ThumbBmp.Height)/(Max-Min)
        else
          Each := (Width-ThumbBmp.Width)/(Max-Min);
    {Now draw the tick marks}
    if Ticks then
      for Tmp := Min to Max do
        if IsVert then
          begin
            TickPos := Y2-Trunc(Each*(Tmp-Min))-1;
            if Tmp = Max then TickPos := Y1;
            SetTLColor; MoveTo(X1,TickPos);   LineTo(X1-2,TickPos);
            SetBRColor; MoveTo(X1,TickPos+1); LineTo(X1-2,TickPos+1);
          end
        else

          begin
            TickPos := X1+Trunc(Each*(Tmp-Min));
            if Tmp = Max then TickPos := X2-1;
            SetTLColor; MoveTo(TickPos,Y1);   LineTo(TickPos,Y1-2);
            SetBRColor; MoveTo(TickPos+1,Y1); LineTo(TickPos+1,Y1-2);
          end;
  end;
end;

procedure TSlideBar.SaveBackground;
begin
  {This saves the background image so it can be restored later}
  BkgdBmp.Width := ThumbBmp.Width;
  BkgdBmp.Height := ThumbBmp.Height;
  BkgdBmp.Canvas.CopyRect(Rect(0,0,ThumbBmp.Width,ThumbBmp.Height),
                          Canvas,ThumbRect);

end;

procedure TSlideBar.Paint;
begin
   DrawTrench;
  WhereIsBar;
  SaveBackground;
  DrawThumbBar;
end;

end.
