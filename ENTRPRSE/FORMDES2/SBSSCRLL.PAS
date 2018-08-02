{ Contains a customised version of TScrollingWincontrol and TScrollBox }
unit SbsScrll;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses Messages, Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  { Forward declarations }
  TCustomScrollingWinControl = class;

  { TSBSControlScrollBar }
  TSBSScrollBarKind = (sbHorizontal, sbVertical);
  TSBSScrollBarInc = 1..32767;

  TSBSControlScrollBar = class(TPersistent)
  private
    FControl: TCustomScrollingWinControl;
    FIncrement: TSBSScrollBarInc;
    FPosition: Integer;
    FRange: Integer;
    FCalcRange: Integer;
    FKind: TSBSScrollBarKind;
    FMargin: Word;
    FVisible: Boolean;
    FTracking: Boolean;
    constructor Create(AControl: TCustomScrollingWinControl; AKind: TSBSScrollBarKind);
    {procedure CalcAutoRange;}
    function ControlSize(ControlSB, AssumeSB: Boolean): Integer;
    {procedure DoSetRange(Value: Integer); } { Move to public }
    function GetScrollPos: Integer;
    function NeedsScrollBarVisible: Boolean;
    procedure ScrollMessage(var Msg: TWMScroll);
    procedure SetPosition(Value: Integer);
    procedure SetRange(Value: Integer);
    procedure SetVisible(Value: Boolean);
    function IsRangeStored: Boolean;
    procedure Update(ControlSB, AssumeSB: Boolean);
  public
    procedure Assign(Source: TPersistent); override;
    property Kind: TSBSScrollBarKind read FKind;
    property ScrollPos: Integer read GetScrollPos;
    procedure DoSetRange(Value: Integer); { moved from private }
  published
    property Margin: Word read FMargin write FMargin default 0;
    property Increment: TSBSScrollBarInc read FIncrement write FIncrement default 8;
    property Range: Integer read FRange write SetRange stored IsRangeStored default 0;
    property Position: Integer read FPosition write SetPosition default 0;
    property Tracking: Boolean read FTracking write FTracking default False;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

  { TCustomScrollingWinControl }
  TCustomScrollingWinControl = class(TCustomControl)
  private
    FHorzScrollBar: TSBSControlScrollBar;
    FVertScrollBar: TSBSControlScrollBar;
    FAutoScroll: Boolean;
    FSizing: Boolean;
    FUpdatingScrollBars: Boolean;
    FReserved: Byte;
    {procedure CalcAutoRange;}
    procedure ScaleScrollBars(M, D: Integer);
    procedure SetAutoScroll(Value: Boolean);
    procedure SetHorzScrollBar(Value: TSBSControlScrollBar);
    procedure SetVertScrollBar(Value: TSBSControlScrollBar);
    procedure UpdateScrollBars;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
  protected
    procedure AutoScrollInView(AControl: TControl);
    procedure ChangeScale(M, D: Integer); override;
    procedure CreateWnd; override;
    procedure AlignControls(AControl: TControl; var ARect: TRect); override;
    property AutoScroll: Boolean read FAutoScroll write SetAutoScroll default True;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ScrollInView(AControl: TControl);

    { Moved from published }
    property HorzScrollBar: TSBSControlScrollBar read FHorzScrollBar write SetHorzScrollBar;
    { Moved from published }
    { BUG: Changed SetHorzScrollBar to SetVertScrollBar }
    property VertScrollBar: TSBSControlScrollBar read FVertScrollBar write SetVertScrollBar;
  end;

  { TScrollBox }
  TSBSBorderStyle = bsNone..bsSingle;

  TSBSScrollBox = class(TCustomScrollingWinControl)
  private
    FBorderStyle: TSBSBorderStyle;
    FReserved: Byte;
    FOnResize: TNotifyEvent;
    procedure SeTSBSBorderStyle(Value: TSBSBorderStyle);
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMNCHitTest(var Message: TMessage); message WM_NCHITTEST;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Resize; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    {property AutoScroll;}
    property BorderStyle: TSBSBorderStyle read FBorderStyle write SeTSBSBorderStyle default bsSingle;
    property DragCursor;
    property DragMode;
    property Enabled;
    {property Color;}
    property Ctl3D;
    {property Font;}
    {property ParentColor;}
    {property ParentCtl3D;}
    {property ParentFont;}
    {property ParentShowHint;}
    property PopupMenu;
    {property ShowHint;}
    property TabOrder;
    property TabStop;
    property Visible;

    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize: TNotifyEvent read FOnResize write FOnResize;
  end;

Implementation

function Max(X, Y: Integer): Integer;
begin
  Result := X;
  if Y > X then Result := Y;
end;

{ TSBSControlScrollBar }
constructor TSBSControlScrollBar.Create(AControl: TCustomScrollingWinControl;
  AKind: TSBSScrollBarKind);
begin
  inherited Create;
  FControl := AControl;
  FKind := AKind;
  FIncrement := 8;
  FVisible := True;
end;

procedure TSBSControlScrollBar.Assign(Source: TPersistent);
begin
  if Source is TSBSControlScrollBar then
  begin
    Visible := TSBSControlScrollBar(Source).Visible;
    Range := TSBSControlScrollBar(Source).Range;
    Position := TSBSControlScrollBar(Source).Position;
    Increment := TSBSControlScrollBar(Source).Increment;
    Exit;
  end;
  inherited Assign(Source);
end;

(*
procedure TSBSControlScrollBar.CalcAutoRange;
var
  I: Integer;
  NewRange, AlignMargin: Integer;

  procedure ProcessHorz(Control: TControl);
  begin
    if Control.Visible then
      case TForm(Control).Align of
        alNone: NewRange := Max(NewRange, Position + Control.Left + Control.Width);
        alRight: Inc(AlignMargin, Control.Width);
      end;
  end;

  procedure ProcessVert(Control: TControl);
  begin
    if Control.Visible then
      case TForm(Control).Align of
        alNone: NewRange := Max(NewRange, Position + Control.Top + Control.Height);
        alBottom: Inc(AlignMargin, Control.Height);
      end;
  end;

begin
  if FControl.FAutoScroll then
  begin
    NewRange := 0;
    AlignMargin := 0;
    for I := 0 to FControl.ControlCount - 1 do
      if Kind = sbHorizontal then
        ProcessHorz(FControl.Controls[I]) else
        ProcessVert(FControl.Controls[I]);
    DoSetRange(NewRange + AlignMargin + Margin);
  end;
end;
*)
function TSBSControlScrollBar.ControlSize(ControlSB, AssumeSB: Boolean): Integer;
var
  BorderAdjust: Integer;

  {
  function ScrollBarVisible(Code: Word): Boolean;
  var
    WRect, CRect: TRect;
    Difference: Integer;
  begin
    GetWindowRect(FControl.Handle, WRect);
    GetClientRect(FControl.Handle, CRect);
    ClientToScreen(FControl.Handle, CRect.BottomRight);
    if Code = SB_VERT then
      Result := WRect.Right - CRect.Right >= GetSystemMetrics(SM_CXHSCROLL) else
      Result := WRect.Bottom - CRect.Bottom >= GetSystemMetrics(SM_CYVSCROLL);
  end;
  }

  function ScrollBarVisible(Code: Word): Boolean;
  var
    Style: Longint;
  begin
    Style := WS_HSCROLL;
    if Code = SB_VERT then Style := WS_VSCROLL;
    Result := GetWindowLong(FControl.Handle, GWL_STYLE) and Style <> 0;
  end;

  function Adjustment(Code, Metric: Word): Integer;
  begin
    Result := 0;
    if not ControlSB then
      if AssumeSB and not ScrollBarVisible(Code) then
        Result := -(GetSystemMetrics(Metric) - BorderAdjust)
      else if not AssumeSB and ScrollBarVisible(Code) then
        Result := GetSystemMetrics(Metric) - BorderAdjust;
  end;

begin
  BorderAdjust := Integer(GetWindowLong(FControl.Handle, GWL_STYLE) and
    (WS_BORDER or WS_THICKFRAME) <> 0);
  if Kind = sbVertical then
    Result := FControl.ClientHeight + Adjustment(SB_HORZ, SM_CXHSCROLL) else
    Result := FControl.ClientWidth + Adjustment(SB_VERT, SM_CYVSCROLL);
end;

function TSBSControlScrollBar.GetScrollPos: Integer;
begin
  Result := 0;
  if Visible then Result := Position;
end;

function TSBSControlScrollBar.NeedsScrollBarVisible: Boolean;
begin
  Result := FRange > ControlSize(False, False);
end;

procedure TSBSControlScrollBar.ScrollMessage(var Msg: TWMScroll);
begin
  with Msg do
    case ScrollCode of
      SB_LINEUP: SetPosition(FPosition - FIncrement);
      SB_LINEDOWN: SetPosition(FPosition + FIncrement);
      SB_PAGEUP: SetPosition(FPosition - ControlSize(True, False));
      SB_PAGEDOWN: SetPosition(FPosition + ControlSize(True, False));
      SB_THUMBPOSITION: SetPosition(Pos);
      SB_THUMBTRACK: if Tracking then SetPosition(Pos);
      SB_TOP: SetPosition(0);
      SB_BOTTOM: SetPosition(FCalcRange);
      SB_ENDSCROLL: begin end;
    end;
end;

procedure TSBSControlScrollBar.SetPosition(Value: Integer);
var
  Code: Word;
  Form: TCustomForm;
  OldPos: Integer;
begin
  if csReading in FControl.ComponentState then
    FPosition := Value
  else
  begin
    if Value > FCalcRange then Value := FCalcRange
    else if Value < 0 then Value := 0;
    if Kind = sbHorizontal then
      Code := SB_HORZ else
      Code := SB_VERT;
    if Value <> FPosition then
    begin
      OldPos := FPosition;
      FPosition := Value;
      if Kind = sbHorizontal then
        FControl.ScrollBy(OldPos - Value, 0) else
        FControl.ScrollBy(0, OldPos - Value);
      Form := GetParentForm(FControl);
      if (Form <> nil) and (Form.Designer <> nil) then Form.Designer.Modified;
    end;
    if Windows.GetScrollPos(FControl.Handle, Code) <> FPosition then
      SetScrollPos(FControl.Handle, Code, FPosition, True);
  end;
end;

procedure TSBSControlScrollBar.DoSetRange(Value: Integer);
begin
  FRange := Value;
  if FRange < 0 then FRange := 0;
  FControl.UpdateScrollBars;
end;

procedure TSBSControlScrollBar.SetRange(Value: Integer);
begin
  FControl.FAutoScroll := False;
  DoSetRange(Value);
end;

function TSBSControlScrollBar.IsRangeStored: Boolean;
begin
  Result := not FControl.AutoScroll;
end;

procedure TSBSControlScrollBar.SetVisible(Value: Boolean);
begin
  FVisible := Value;
  FControl.UpdateScrollBars;
end;

procedure TSBSControlScrollBar.Update(ControlSB, AssumeSB: Boolean);
var
  Code: Word;
  ScrollInfo: TScrollInfo;
begin
  FCalcRange := 0;
  Code := SB_HORZ;
  if Kind = sbVertical then Code := SB_VERT;
  if Visible then
  begin
    FCalcRange := Range - ControlSize(ControlSB, AssumeSB);
    if FCalcRange < 0 then FCalcRange := 0;
  end;
  ScrollInfo.cbSize := SizeOf(ScrollInfo);
  ScrollInfo.fMask := SIF_ALL;
  ScrollInfo.nMin := 0;
  ScrollInfo.nMax := Range;
  ScrollInfo.nPage := ControlSize(ControlSB, AssumeSB) + 1;
  ScrollInfo.nPos := FPosition;
  ScrollInfo.nTrackPos := FPosition;
  SetScrollInfo(FControl.Handle, Code, ScrollInfo, True);
  {
  SetScrollRange(FControl.Handle, Code, 0, FCalcRange, True);
  SetPosition(FPosition);
  }
end;

{ TCustomScrollingWinControl }

constructor TCustomScrollingWinControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHorzScrollBar := TSBSControlScrollBar.Create(Self, sbHorizontal);
  FVertScrollBar := TSBSControlScrollBar.Create(Self, sbVertical);
  FAutoScroll := True;
end;

destructor TCustomScrollingWinControl.Destroy;
begin
  FHorzScrollBar.Free;
  FVertScrollBar.Free;
  inherited Destroy;
end;

procedure TCustomScrollingWinControl.CreateWnd;
begin
  inherited CreateWnd;
  UpdateScrollBars;
end;

procedure TCustomScrollingWinControl.AlignControls(AControl: TControl; var ARect: TRect);
begin
  {CalcAutoRange;}
  ARect := Bounds(-HorzScrollBar.Position, -VertScrollBar.Position,
    Max(HorzScrollBar.Range, ClientWidth), Max(ClientHeight, VertScrollBar.Range));
  inherited AlignControls(AControl, ARect);
end;
(*
procedure TCustomScrollingWinControl.CalcAutoRange;
begin
  if not FSizing then
  begin
    HorzScrollBar.CalcAutoRange;
    VertScrollBar.CalcAutoRange;
  end;
end;
*)
procedure TCustomScrollingWinControl.SetAutoScroll(Value: Boolean);
begin
  if FAutoScroll <> Value then
  begin
    FAutoScroll := Value;
    {if Value then CalcAutoRange else}
    if Not Value then
    begin
      HorzScrollBar.Range := 0;
      VertScrollBar.Range := 0;
    end;
  end;
end;

procedure TCustomScrollingWinControl.SetHorzScrollBar(Value: TSBSControlScrollBar);
begin
  FHorzScrollBar.Assign(Value);
end;

procedure TCustomScrollingWinControl.SetVertScrollBar(Value: TSBSControlScrollBar);
begin
  FVertScrollBar.Assign(Value);
end;

procedure TCustomScrollingWinControl.UpdateScrollBars;
begin
  if not FUpdatingScrollBars and HandleAllocated then
    try
      FUpdatingScrollBars := True;
      if FVertScrollBar.NeedsScrollBarVisible then
      begin
        FHorzScrollBar.Update(False, True);
        FVertScrollBar.Update(True, False);
      end
      else if FHorzScrollBar.NeedsScrollBarVisible then
      begin
        FVertScrollBar.Update(False, True);
        FHorzScrollBar.Update(True, False);
      end
      else
      begin
        FVertScrollBar.Update(False, False);
        FHorzScrollBar.Update(True, False);
      end;
    finally
      FUpdatingScrollBars := False;
    end;
end;

procedure TCustomScrollingWinControl.AutoScrollInView(AControl: TControl);
begin
  if (AControl <> nil) and not (csLoading in AControl.ComponentState) and
    not (csLoading in ComponentState) then
    ScrollInView(AControl);
end;

procedure TCustomScrollingWinControl.ScrollInView(AControl: TControl);
var
  Rect: TRect;
begin
  if AControl = nil then Exit;
  Rect := AControl.ClientRect;
  Dec(Rect.Left, HorzScrollBar.Margin);
  Inc(Rect.Right, HorzScrollBar.Margin);
  Dec(Rect.Top, VertScrollBar.Margin);
  Inc(Rect.Bottom, VertScrollBar.Margin);
  Rect.TopLeft := ScreenToClient(AControl.ClientToScreen(Rect.TopLeft));
  Rect.BottomRight := ScreenToClient(AControl.ClientToScreen(Rect.BottomRight));
  if Rect.Left < 0 then
    with HorzScrollBar do Position := Position + Rect.Left
  else if Rect.Right > ClientWidth then
  begin
    if Rect.Right - Rect.Left > ClientWidth then
      Rect.Right := Rect.Left + ClientWidth;
    with HorzScrollBar do Position := Position + Rect.Right - ClientWidth;
  end;
  if Rect.Top < 0 then
    with VertScrollBar do Position := Position + Rect.Top
  else if Rect.Bottom > ClientHeight then
  begin
    if Rect.Bottom - Rect.Top > ClientHeight then
      Rect.Bottom := Rect.Top + ClientHeight;
    with VertScrollBar do Position := Position + Rect.Bottom - ClientHeight;
  end;
end;

procedure TCustomScrollingWinControl.ScaleScrollBars(M, D: Integer);
begin
  HorzScrollBar.Position := 0;
  VertScrollBar.Position := 0;
  if not FAutoScroll then
  begin
    HorzScrollBar.Range := MulDiv(HorzScrollBar.Range, M, D);
    VertScrollBar.Range := MulDiv(VertScrollBar.Range, M, D);
  end;
end;

procedure TCustomScrollingWinControl.ChangeScale(M, D: Integer);
begin
  ScaleScrollBars(M, D);
  inherited ChangeScale(M, D);
end;

procedure TCustomScrollingWinControl.WMSize(var Message: TWMSize);
begin
  FSizing := True;
  try
    inherited;
  finally
    FSizing := False;
  end;
  UpdateScrollBars;
end;

procedure TCustomScrollingWinControl.WMHScroll(var Message: TWMHScroll);
begin
  if Message.ScrollBar = 0 then
    FHorzScrollBar.ScrollMessage(Message) else
    inherited;
end;

procedure TCustomScrollingWinControl.WMVScroll(var Message: TWMVScroll);
begin
  if Message.ScrollBar = 0 then
    FVertScrollBar.ScrollMessage(Message) else
    inherited;
end;

{ TSBSScrollBox }

constructor TSBSScrollBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
    csSetCaption, csDoubleClicks];
  Width := 185;
  Height := 41;
  FBorderStyle := bsSingle;
end;

procedure TSBSScrollBox.CreateParams(var Params: TCreateParams);
const
  BorderStyles: array[TSBSBorderStyle] of Longint = (0, WS_BORDER);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or BorderStyles[FBorderStyle];
    WindowClass.style := WindowClass.style or CS_HREDRAW or CS_VREDRAW;
  end;
end;

procedure TSBSScrollBox.Resize;
begin
  if Assigned(FOnResize) then FOnResize(Self);
end;

procedure TSBSScrollBox.SeTSBSBorderStyle(Value: TSBSBorderStyle);
begin
  if Value <> FBorderStyle then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TSBSScrollBox.WMSize(var Message: TWMSize);
begin
  inherited;
  if not (csLoading in ComponentState) then Resize;
  {CalcAutoRange;}
end;

procedure TSBSScrollBox.WMNCHitTest(var Message: TMessage);
begin
  DefaultHandler(Message);
end;

end.

