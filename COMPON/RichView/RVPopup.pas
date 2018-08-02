unit RVPopup;

interface

{$I RV_Defs.inc}
{$IFNDEF RVDONOTUSESMARTPOPUP}

uses Windows, Messages, Classes, Graphics, Controls, Menus,
  {$IFDEF RICHVIEWDEF4}
  ImgList,
  {$ENDIF}
  {$IFDEF RICHVIEWDEF6}
  Types,
  {$ENDIF}
  RVScroll, RVItem, CRVData;


type
  TRVSmartPopupButton = class;

  TRVSmartPopupProperties = class (TPersistent)
  private
    FImageIndex: Integer;
    FImageList: TCustomImageList;
    FColor: TColor;
    FHoverLineColor: TColor;
    FLineColor: TColor;
    FHoverColor: TColor;
    FMenu: TPopupMenu;
    FHint: String;
    FShortCut: TShortCut;
    FButtonType: TRVSmartPopupType;
    FButton: TRVSmartPopupButton;
    FPosition: TRVSmartPopupPosition;
    procedure SetImageIndex(const Value: Integer);
    procedure SetImageList(const Value: TCustomImageList);
    procedure SetColor(const Value: TColor);
    procedure SetHoverColor(const Value: TColor);
    procedure SetHoverLineColor(const Value: TColor);
    procedure SetLineColor(const Value: TColor);
    procedure SetHint(const Value: String);
    function StoreHint: Boolean;
  public
    RichView: TRVScroller;
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure SetButtonState(Hot: Boolean);
  published
    property ImageIndex: Integer read FImageIndex write SetImageIndex default 0;
    property ImageList: TCustomImageList read FImageList write SetImageList;
    property Color: TColor read FColor write SetColor default clWindow;
    property HoverColor: TColor read FHoverColor write SetHoverColor default clInfoBk;
    property LineColor: TColor read FLineColor write SetLineColor default clHighlight;
    property HoverLineColor: TColor read FHoverLineColor write SetHoverLineColor default clInfoText;
    property Menu: TPopupMenu read FMenu write FMenu;
    property Hint: String read FHint write SetHint stored StoreHint;
    property ShortCut: TShortCut read FShortCut write FShortCut default $6028;
    property ButtonType: TRVSmartPopupType read FButtonType write FButtonType default rvsptDropDown;
    property Position: TRVSmartPopupPosition read FPosition write FPosition default rvsppBottomRight;
  end;

  TRVSmartPopupButton = class (TCustomControl)
  private
    FHot, FAlwaysHot: Boolean;
    FSmartPopupProperties: TRVSmartPopupProperties;
    procedure SetSmartPopupProperties(
      const Value: TRVSmartPopupProperties);
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;    
  protected
    procedure Paint; override;
  public
    Item: TCustomRVItemInfo;
    RVData: TCustomRVData;
    ItemNo: Integer;
    destructor Destroy; override;
    procedure Click; override;
    property SmartPopupProperties: TRVSmartPopupProperties
      read FSmartPopupProperties write SetSmartPopupProperties;
  end;

{$ENDIF}

implementation
uses RVRVData, RichView, Forms;
{$IFNDEF RVDONOTUSESMARTPOPUP}
{================================= TRVSmartPopup ==============================}
constructor TRVSmartPopupProperties.Create;
begin
  inherited Create;
  FColor          := clWindow;
  FHoverColor     := clInfoBk;
  FLineColor      := clHighlight;
  FHoverLineColor := clInfoText;
  FShortCut       := $6028; // Ctrl+Shift+Down;
  FButtonType     := rvsptDropDown;
  FPosition       := rvsppBottomRight;
end;
{------------------------------------------------------------------------------}
procedure TRVSmartPopupProperties.Assign(Source: TPersistent);
begin
  if Source is TRVSmartPopupProperties then begin
    FImageList      := TRVSmartPopupProperties(Source).ImageList;
    FImageIndex     := TRVSmartPopupProperties(Source).ImageIndex;
    FColor          := TRVSmartPopupProperties(Source).Color;
    FHoverColor     := TRVSmartPopupProperties(Source).HoverColor;
    FLineColor      := TRVSmartPopupProperties(Source).LineColor;
    FHoverLineColor := TRVSmartPopupProperties(Source).HoverLineColor;
    FShortCut       := TRVSmartPopupProperties(Source).ShortCut;
    FButtonType     := TRVSmartPopupProperties(Source).ButtonType;
    FHint           := TRVSmartPopupProperties(Source).Hint;
    FMenu           := TRVSmartPopupProperties(Source).Menu;
    FPosition       := TRVSmartPopupProperties(Source).Position;
    end
  else
    inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
procedure TRVSmartPopupProperties.SetColor(const Value: TColor);
begin
  FColor := Value;
  if FButton<>nil then
    FButton.Invalidate;
end;
{------------------------------------------------------------------------------}
procedure TRVSmartPopupProperties.SetHint(const Value: String);
begin
  FHint := Value;
  if FButton<>nil then
    FButton.Hint := FHint;
end;
{------------------------------------------------------------------------------}
procedure TRVSmartPopupProperties.SetHoverColor(const Value: TColor);
begin
  FHoverColor := Value;
  if FButton<>nil then
    FButton.Invalidate;
end;
{------------------------------------------------------------------------------}
procedure TRVSmartPopupProperties.SetHoverLineColor(const Value: TColor);
begin
  FHoverLineColor := Value;
  if FButton<>nil then
    FButton.Invalidate;
end;
{------------------------------------------------------------------------------}
procedure TRVSmartPopupProperties.SetImageIndex(const Value: Integer);
begin
  FImageIndex := Value;
  if FButton<>nil then
    FButton.Invalidate;
end;
{------------------------------------------------------------------------------}
procedure TRVSmartPopupProperties.SetImageList(const Value: TCustomImageList);
begin
  FImageList := Value;
  if FButton<>nil then
    FButton.Invalidate;
end;
{------------------------------------------------------------------------------}
procedure TRVSmartPopupProperties.SetLineColor(const Value: TColor);
begin
  FLineColor := Value;
  if FButton<>nil then
    FButton.Invalidate;
end;
{------------------------------------------------------------------------------}
function TRVSmartPopupProperties.StoreHint: Boolean;
begin
  Result := Hint<>'';
end;
{------------------------------------------------------------------------------}
procedure TRVSmartPopupProperties.SetButtonState(Hot: Boolean);
begin
  if FButton=nil then
    exit;
  FButton.FAlwaysHot := Hot;
  if Hot then
    SendMessage(FButton.Handle, CM_MOUSEENTER, 0, 0)
  else
    SendMessage(FButton.Handle, CM_MOUSELEAVE, 0, 0);
end;
{============================= TRVSmartPopupButton ============================}
procedure TRVSmartPopupButton.CMMouseEnter(var Msg: TMessage);
begin
  if not FHot and (FSmartPopupProperties.ButtonType<>rvsptSimple) then
    Width := Width+10;
  FHot := True;
  Invalidate;
end;
{------------------------------------------------------------------------------}
procedure TRVSmartPopupButton.CMMouseLeave(var Msg: TMessage);
begin
  if FAlwaysHot then
    exit;
  if FHot and (FSmartPopupProperties.ButtonType<>rvsptSimple) then
    Width := Width-10;
  FHot := False;
  Invalidate;
end;
{------------------------------------------------------------------------------}
procedure TRVSmartPopupButton.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;
{------------------------------------------------------------------------------}
procedure TRVSmartPopupButton.Paint;
var PointArray: array[0..2] of TPoint;
    Y: Integer;
begin
  if FHot then begin
    Canvas.Pen.Color   := FSmartPopupProperties.HoverLineColor;
    Canvas.Brush.Color := FSmartPopupProperties.HoverColor;
    end
  else begin
    Canvas.Pen.Color   := FSmartPopupProperties.LineColor;
    Canvas.Brush.Color := FSmartPopupProperties.Color;
  end;
  Canvas.Rectangle(0,0,Width,Height);
  if (FSmartPopupProperties.ImageList<>nil) and
     (FSmartPopupProperties.ImageIndex>=0) and
     (FSmartPopupProperties.ImageIndex<FSmartPopupProperties.ImageList.Count) then
    FSmartPopupProperties.ImageList.Draw(Canvas, 2, 2, FSmartPopupProperties.ImageIndex);
  if FHot then
    case FSmartPopupProperties.ButtonType of
      rvsptDropDown:
        begin
          Canvas.Brush.Color := Canvas.Pen.Color;
          PointArray[0].X := Width-10;
          PointArray[1].X := Width-4;
          PointArray[2].X := Width-7;
          PointArray[0].Y := Height div 2 - 2;
          PointArray[1].Y := PointArray[0].Y;
          PointArray[2].Y := PointArray[0].Y+3;
          Canvas.Polygon(PointArray);
        end;
     rvsptShowDialog:
       begin
         Canvas.Brush.Color := Canvas.Pen.Color;
         Y := Height div 2+2;
         Canvas.MoveTo(Width-10, Y-1);
         Canvas.LineTo(Width-10, Y+1);
         Canvas.MoveTo(Width-7, Y-1);
         Canvas.LineTo(Width-7, Y+1);
         Canvas.MoveTo(Width-4, Y-1);
         Canvas.LineTo(Width-4, Y+1);
       end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVSmartPopupButton.SetSmartPopupProperties(
  const Value: TRVSmartPopupProperties);
begin
  FSmartPopupProperties := Value;
  FSmartPopupProperties.FButton := Self;
  ShowHint := True;
  Hint := FSmartPopupProperties.Hint;
  if Value.ImageList<>nil then begin
    Width  := TImageList(Value.ImageList).Width+4;
    Height := TImageList(Value.ImageList).Height+4;
    end
  else begin
    Width := 20;
    Height := 20;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVSmartPopupButton.Click;
var pt: TPoint;
    rv: TCustomRichView;
begin
  rv := TCustomRichView(TRichViewRVData(RVData.GetAbsoluteRootData).RichView);
  if Assigned(rv.OnSmartPopupClick) then
    rv.OnSmartPopupClick(rv, Self);
  if FSmartPopupProperties.Menu<>nil then begin
    pt := Point(0, Height);
    pt := ClientToScreen(pt);
    FSmartPopupProperties.SetButtonState(True);
    try
      FSmartPopupProperties.Menu.Popup(pt.X, pt.Y);
    finally
      FSmartPopupProperties.SetButtonState(False);
    end;
  end;
end;
{------------------------------------------------------------------------------}
destructor TRVSmartPopupButton.Destroy;
begin
  FSmartPopupProperties.FButton := nil;
  inherited;
end;
{$ENDIF}


end.
