
{*******************************************************}
{                                                       }
{       RichView                                        }
{       TCustomRVPrintPreview is an ancestor class      }
{       for print previewer.                            }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit CRVPP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  RVScroll, Printers;
{$I RV_Defs.inc}
{$R CRVPP}
const
  crRVZoomIn  = 102;
  crRVZoomOut = 103;
type
{-----------------------------------------------------------------------}
  TRVClickMode = (rvcmNone, rvcmSwitchZoom);
{-----------------------------------------------------------------------}
  TRVMarginsPen = class (TPen)
    property Style default psClear;
    property Color default clSilver;
  end;

  TRVPAPen = class (TPen)
    property Style default psClear;
    property Color default clRed;
  end;

  TCustomRVPrintPreview = class(TRVScroller)
  private
    { Private declarations }
    SavedZoomPercent: Integer;
    FPageNo: Integer;
    FZoomPercent: Integer;
    FZoomMode: TRVZoomMode;
    FPageWidth, FPageHeight, FPhysPageWidth, FPhysPageHeight: Integer;
    FPhysMargins: TRect;
    FZoomInCursor: TCursor;
    FZoomOutCursor: TCursor;
    FZoomChanged: TNotifyEvent;
    FMarginsPen: TRVMarginsPen;
    FPrintableAreaPen: TRVPAPen;
    FClickMode: TRVClickMode;
    FPageBorderColor: TColor;
    FShadowColor: TColor;
    FShadowWidth: Integer;
    FPageBorderWidth: Integer;
    FBackgroundMargin: Integer;
    procedure SetZoomPercent(const Value: Integer);
    procedure SetZoomMode(const Value: TRVZoomMode);
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure SetZoomInCursor(const Value: TCursor);
    procedure SetZoomOutCursor(const Value: TCursor);
    procedure SetMarginsPen(const Value: TRVMarginsPen);
    procedure SetPrintableAreaPen(const Value: TRVPAPen);
  protected
    { Protected declarations }
    function CanDrawContents: Boolean; dynamic;
    procedure DrawContents(Canvas:TCanvas; const R: TRect); dynamic;
    procedure DrawMargins(Canvas:TCanvas; const R: TRect;
      PageNo: Integer); virtual;
    procedure DrawPrintableAreaBorder(Canvas:TCanvas; const R: TRect;
      PageNo: Integer); virtual;
    function GetPreview100PercentWidth: Integer; dynamic;
    function GetPreview100PercentHeight: Integer; dynamic;
    function GetPhysMargins: TRect; dynamic;
    function GetPageCount: Integer; dynamic;
    procedure Paint; override;
    procedure Loaded; override;
    procedure Click; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function GetDefSmallStep: Integer; override;
    procedure UpdateCursor;
    procedure SetPageNo(const Value: Integer); virtual;

    property ZoomInCursor: TCursor read FZoomInCursor write SetZoomInCursor default crRVZoomIn;
    property ZoomOutCursor: TCursor read FZoomOutCursor write SetZoomOutCursor default crRVZoomOut;
    property OnZoomChanged: TNotifyEvent read FZoomChanged  write FZoomChanged;
    property MarginsPen: TRVMarginsPen read FMarginsPen write SetMarginsPen;
    property PrintableAreaPen: TRVPAPen read FPrintableAreaPen write SetPrintableAreaPen;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetZoom(Percent: Integer);
    procedure First;
    procedure Last;
    procedure Next;
    procedure Prev;
    procedure UpdateView;
    property PageNo: Integer read FPageNo write SetPageNo;
    property ZoomPercent:Integer read FZoomPercent write SetZoomPercent;
    property ZoomMode:TRVZoomMode read FZoomMode write SetZoomMode;
    property ClickMode: TRVClickMode read FClickMode write FClickMode default rvcmSwitchZoom;
    property PageBorderColor: TColor read FPageBorderColor write FPageBorderColor default clHighlight;
    property PageBorderWidth: Integer read FPageBorderWidth write FPageBorderWidth default 2;
    property ShadowColor: TColor read FShadowColor write FShadowColor default cl3DDkShadow;
    property ShadowWidth: Integer read FShadowWidth write FShadowWidth default 4;
    property BackgroundMargin: Integer read FBackgroundMargin write FBackgroundMargin default 20;
  published
    property Color default clBtnShadow;
  end;

implementation
uses RVStr;

{========================== TCustomRVPrintPreview ============================}
constructor TCustomRVPrintPreview.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Screen.Cursors[crRVZoomIn] := LoadCursor(hInstance,RVRC_ZOOMIN_CURSOR);
  Screen.Cursors[crRVZoomOut] := LoadCursor(hInstance,RVRC_ZOOMOUT_CURSOR);
  BorderStyle := bsSingle;
  Width  := 100;
  Height := 100;
  PageNo := 1;
  FullRedraw := False;
  ZoomInCursor := crRVZoomIn;
  ZoomOutCursor := crRVZoomOut;
  SavedZoomPercent := 50;
  FZoomPercent := 100;
  FClickMode := rvcmSwitchZoom;
  FMarginsPen := TRVMarginsPen.Create;
  FMarginsPen.Style := psClear;
  FMarginsPen.Color := clSilver;
  FPrintableAreaPen := TRVPAPen.Create;
  FPrintableAreaPen.Style := psClear;
  FPrintableAreaPen.Color := clRed;
  FScrollFactor := 10;
  {$IFDEF RICHVIEWDEF4}
  FWheelStep := 20;
  {$ENDIF}
  Color := clBtnShadow;
  ShadowColor := cl3DDkShadow;
  PageBorderColor := clHighlight;
  ShadowWidth := 4;
  PageBorderWidth := 2;
  BackgroundMargin := 20;
end;
{-----------------------------------------------------------------------}
destructor TCustomRVPrintPreview.Destroy;
begin
  FMarginsPen.Free;
  FPrintableAreaPen.Free;
  inherited Destroy;
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.Loaded;
begin
  inherited Loaded;
  UpdateView;
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.Click;
begin
  inherited;
  case ClickMode of
    rvcmSwitchZoom:
      begin
        ZoomMode := rvzmCustom;
        if ZoomPercent=100 then
          ZoomPercent := SavedZoomPercent
        else
          ZoomPercent := 100;
      end;
  end;
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.SetMarginsPen(const Value: TRVMarginsPen);
begin
  FMarginsPen.Assign(Value);
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.SetPrintableAreaPen(const Value: TRVPAPen);
begin
  FPrintableAreaPen.Assign(Value);
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.WMSize(var Message: TWMSize);
begin
  UpdateView;
end;
{-----------------------------------------------------------------------}
function TCustomRVPrintPreview.GetDefSmallStep: Integer;
begin
  Result := 1;
end;
{-----------------------------------------------------------------------}
function TCustomRVPrintPreview.GetPreview100PercentWidth: Integer;
begin
  Result := -1;
end;
{-----------------------------------------------------------------------}
function TCustomRVPrintPreview.GetPreview100PercentHeight: Integer;
begin
  Result := -1;
end;
{-----------------------------------------------------------------------}
function TCustomRVPrintPreview.GetPhysMargins: TRect;
begin
  Result := Rect(0,0,0,0);
end;
{-----------------------------------------------------------------------}
function TCustomRVPrintPreview.GetPageCount: Integer;
begin
  Result := 1;
end;

{-----------------------------------------------------------------------}
function TCustomRVPrintPreview.CanDrawContents: Boolean;
begin
  Result := True;
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.DrawContents(Canvas:TCanvas; const R: TRect);
begin
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.DrawMargins(Canvas: TCanvas;
  const R: TRect; PageNo: Integer);
begin
  Canvas.Pen := MarginsPen;
  Canvas.Brush.Style := bsClear;
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.DrawPrintableAreaBorder(Canvas: TCanvas;
  const R: TRect; PageNo: Integer);
begin
  Canvas.Pen := PrintableAreaPen;
  Canvas.Brush.Style := bsClear;
  with R do
    Canvas.Rectangle(Left, Top, Right, Bottom);
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.Paint;
var
    w,h: Integer;
    FullRect, PrintableRect: TRect;
    OldPalette: HPALETTE;
    MemBitmap, OldBitmap: HBITMAP;
    MemDC: HDC;
    canv: TCanvas;
//    DCIdx: Integer;
begin
  with ClientRect do
    MemBitmap := CreateCompatibleBitmap(Canvas.Handle, Right-Left, Bottom-Top);
  MemDC := CreateCompatibleDC(0);
  OldBitmap := SelectObject(MemDC, MemBitmap);
  if RVPalette<>0 then begin
    OldPalette := SelectPalette(MemDC, RVPalette, False);
    RealizePalette(MemDC);
    end
  else
    OldPalette := 0;
  canv := TCanvas.Create;
  canv.Handle := MemDC;
  try
    with canv do begin
      Brush.Color := Self.Color;
      Pen.Color := Self.Color;
      FillRect(ClientRect);
      if CanDrawContents then begin
        w := ClientWidth;
        if XSize>w then w := XSize;
        h := ClientHeight;
        if YSize>h then h := YSize;
        FullRect := Bounds(
          (w-FPhysPageWidth)  div 2 - HPos,
          (h-FPhysPageHeight) div 2 - VPos,
          FPhysPageWidth, FPhysPageHeight);
         PrintableRect := Bounds(
           FullRect.Left+FPhysMargins.Left,
           FullRect.Top+FPhysMargins.Top,
           FPageWidth, FPageHeight);
        if ShadowWidth>0 then begin
          OffsetRect(FullRect,ShadowWidth,ShadowWidth);
          Brush.Color := ShadowColor;
          FillRect(FullRect);
          OffsetRect(FullRect,-ShadowWidth,-ShadowWidth);
        end;
        Brush.Color := clWhite;
        FillRect(FullRect);
        //DCIdx := SaveDC(canv.Handle);
        with PrintableRect do
          IntersectClipRect(canv.Handle,Left,Top,Right,Bottom);
        DrawContents(canv, PrintableRect);
        //RestoreDC(canv.Handle,DCIdx);
        SelectClipRgn(canv.Handle,0);
        Pen.Style := psSolid;
        if PageBorderColor<>clNone then begin
          Pen.Width := PageBorderWidth;
          Pen.Color := PageBorderColor;
          Brush.Color := clNone;
          Brush.Style := bsClear;
          with FullRect do
            Rectangle(Left, Top, Right, Bottom);
        end;
        if PrintableAreaPen.Style<>psClear then
          DrawPrintableAreaBorder(canv, PrintableRect, PageNo);
        if MarginsPen.Style<>psClear then
          DrawMargins(canv, PrintableRect, PageNo);
      end;
    end;
    with ClientRect do
      BitBlt(Canvas.Handle, Left, Top, Right-Left, Bottom-Top, MemDC, 0, 0, SRCCOPY);
  finally
    if RVPalette<>0 then
      SelectPalette(MemDC, OldPalette, True);
    SelectObject(MemDC, OldBitmap);
    canv.Handle := 0;
    canv.Free;
    DeleteDC(MemDC);
    DeleteObject(MemBitmap);
  end;
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.SetPageNo(const Value: Integer);
begin
  FPageNo := Value;
  Invalidate;
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.SetZoomMode(const Value: TRVZoomMode);
begin
  FZoomMode := Value;
  UpdateView;
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.SetZoomPercent(const Value: Integer);
var isnew: Boolean;
begin
  isnew := Value<>FZoomPercent;
  if (Value=100) and (FZoomPercent<>100) then
    SavedZoomPercent := FZoomPercent;
  FZoomPercent := Value;
  if not CanDrawContents then exit;
  FPhysMargins := GetPhysMargins;
  FPageWidth  := MulDiv(GetPreview100PercentWidth,  FZoomPercent, 100);
  FPageHeight := MulDiv(GetPreview100PercentHeight, FZoomPercent, 100);
  FPhysPageWidth :=
    MulDiv(GetPreview100PercentWidth+FPhysMargins.Left+FPhysMargins.Right,
      FZoomPercent, 100);
  FPhysPageHeight :=
    MulDiv(GetPreview100PercentHeight+FPhysMargins.Top+FPhysMargins.Bottom,
      FZoomPercent, 100);
  FPhysMargins.Left   := MulDiv(FPhysMargins.Left,   FZoomPercent, 100);
  FPhysMargins.Top    := MulDiv(FPhysMargins.Top,    FZoomPercent, 100);
  FPhysMargins.Right  := MulDiv(FPhysMargins.Right,  FZoomPercent, 100);
  FPhysMargins.Bottom := MulDiv(FPhysMargins.Bottom, FZoomPercent, 100);
  Invalidate;
  case ZoomMode of
    rvzmPageWidth:
      UpdateScrollBars(10, FPhysPageHeight+BackgroundMargin*2, True, True);
    rvzmFullPage:
      UpdateScrollBars(10, 10, True, True);
    rvzmCustom:
      UpdateScrollBars(FPhysPageWidth+BackgroundMargin*2, FPhysPageHeight+BackgroundMargin*2, True, True);
  end;
  UpdateCursor;
  if isnew and Assigned(FZoomChanged) then FZoomChanged(Self);
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.UpdateView;
var ZP,ZP2: Integer;
begin
  if not CanDrawContents then exit;
  case ZoomMode of
    rvzmPageWidth:
      begin
        ZoomPercent := MulDiv(ClientWidth-BackgroundMargin*2, 100, GetPreview100PercentWidth);
      end;
    rvzmFullPage:
      begin
        ZP := MulDiv(Width-GetSystemMetrics(SM_CXHSCROLL)- BackgroundMargin*2, 100, GetPreview100PercentWidth);
        ZP2 := MulDiv(Height-GetSystemMetrics(SM_CYVSCROLL)-BackgroundMargin*2, 100, GetPreview100PercentHeight);
        if ZP2<ZP then
          ZoomPercent := ZP2
        else
          ZoomPercent := ZP;
      end;
    rvzmCustom:
      ZoomPercent := ZoomPercent;
  end;
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.First;
begin
  PageNo := 1;
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.Last;
begin
  if not CanDrawContents then exit;
  PageNo := GetPageCount;
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.Next;
begin
  if not CanDrawContents then exit;
  if PageNo<GetPageCount then
    PageNo := PageNo+1;
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.Prev;
begin
  if PageNo>1 then
    PageNo := PageNo-1;
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.SetZoomInCursor(const Value: TCursor);
begin
  FZoomInCursor := Value;
  UpdateCursor;
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.SetZoomOutCursor(const Value: TCursor);
begin
  FZoomOutCursor := Value;
  UpdateCursor;
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.UpdateCursor;
var ZP: Integer;
begin
  case ClickMode of
    rvcmSwitchZoom:
      begin
        if ZoomPercent=100 then
          ZP := SavedZoomPercent
        else
          ZP := 100;
        if ZoomPercent<ZP then
          Self.Cursor := FZoomInCursor
        else
          Self.Cursor := FZoomOutCursor;
      end;
    rvcmNone:
      begin
        Self.Cursor := crDefault;
      end;
  end;
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.SetZoom(Percent: Integer);
begin
  FZoomMode := rvzmCustom;
  ZoomPercent := Percent;
end;
{-----------------------------------------------------------------------}
procedure TCustomRVPrintPreview.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  SetFocus;
end;


end.
