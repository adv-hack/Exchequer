{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPreview;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, RPBase, RPCanvas, RPFPrint,
  // RPDD - HM 27/11/02: Added Drill-Down support
  DrillImage, DrillList,
  RPDefine, RPDevice;

type
  TDrillDownEvent = procedure (      Sender     : TObject;
                               Const LevelNo    : Byte;
                               Const DDS1       : ShortString;
                               Const DDI1, DDI2 : SmallInt;
                               Const DDB1       : Byte) of object;

{*************************************************************************}
{                            class TFilePreview                           }
{*************************************************************************}

  TFilePreview = class(TFilePrinter)
  protected
    FScrollBox: TScrollBox; { ScrollBox for print preview }
    // RPDD - HM 27/11/02: Added Drill-Down support
    //FImage: TImage; { Image that contains FBitmap }
    FImage: TDrillControl; { Image that contains FBitmap }
    // RPDD - HM 27/11/02: Added Drill-Down support
    FDrillList : TDrillDownAreaList;
    FBitmap: TBitmap; { Bitmap that page is drawn in }
    FZoomInc: integer; { Value that the Zoom inc/dec ZoomFactor }
    FMonochrome: boolean; { Do bitmap in monochrome? }
    FMarginMethod: TMarginMethod; { Keep margin scaled or fixed }
    FMarginPercent: double; { Percent of margin around page }
    FScrollBarWidth: integer; { Width of ScrollBox vertical scroll bar }
    FScrollBarHeight: integer; { Height of ScrollBox horizontal scroll bar }
    FHorzAdj: integer; { Diffence between Width and ClientWidth }
    FVertAdj: integer; { Diffence between Height and ClientHeight }
    FGridPen: TPen;  { Pen to draw the grid with }
    FGridHoriz: double;  { Spacing between horizontal grid lines }
    FGridVert: double;   { Spacing between vertical grid line }
    FShadowDepth: integer;  { Depth for the page shadow }
    FRulerType: TRulerType;  { Characteristics of the ruler to draw }
    RulerWidth: integer;  { Width of the horizontal ruler }
    RulerHeight: integer;  { Width of the vertical ruler }
    FPageInc: integer; { How far does NextPage/PrevPage inc/dec }
    FOnPageChange: TNotifyEvent; { Called when CurrentPage changes }
    FOnZoomChange: TNotifyEvent; { Called when ZoomFactor changes }
    // RPDD - HM 27/11/02: Added Drill-Down support
    FHighlight : Boolean;
    // RPDD - HM 27/11/02: Added Drill-Down support
    FOnDrillDown : TDrillDownEvent;

    procedure PageChangeEvent; virtual;
    procedure ZoomChangeEvent; virtual;

    function Destination: TDestination; override; { destPreview }

    procedure AbsorbIntProp(Reader: TReader);
    procedure DefineProperties(Filer: TFiler); override;
    function GetZoomFactor: double;
    procedure SetZoomFactor(Value: double);
    procedure SetZoomInc(Value: integer);
    function GetZoomPageWidthFactor: double;
    function GetZoomPageFactor: double;
    procedure SetMonochrome(Value: boolean);
    procedure SetShadowDepth(Value: integer);
    procedure SetGridPen(Value: TPen);
    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
    procedure SetScrollBox(Value: TScrollBox);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure PrintPage(PageNum: word); override;
    procedure PrevPage;
    procedure NextPage;
    procedure ZoomIn;
    procedure ZoomOut;
    procedure RedrawPage;
    procedure Clear;

    procedure Start; override;
    procedure Finish; override;
    procedure Execute; override;

    procedure PrintBitmapRect2(X1,Y1,X2,Y2: double;
                              Bitmap: TBitmap); Override;

    // RPDD - HM 27/11/02: Added Drill-Down support
    procedure ImageDrillClick (Sender : TObject; Const X, Y : Integer);
    // RPDD - HM 27/11/02: Added Drill-Down support
    procedure DrillDownArea (Const X1, Y1, X2, Y2 : Double;
                             Const LevelNo        : Byte;
                             Const DDS1           : ShortString;
                             Const DDI1, DDI2     : SmallInt;
                             Const DDB1           : Byte); override;
    // RPDD - HM 02/01/03: Extended Drill-Down support
    Function CheckForDrillArea (      Sender : TObject;
                                Const X, Y   : Integer;
                                Var   dLeft, dTop, dWidth, dHeight : Integer) : Boolean;

    property CurrentPage;
    property ZoomPageWidthFactor: double read GetZoomPageWidthFactor;
    property ZoomPageFactor: double read GetZoomPageFactor;
    // RPDD - HM 27/11/02: Added Drill-Down support
    property Image: TDrillControl read FImage;
  published
    property ScrollBox: TScrollBox read FScrollBox write SetScrollBox;
    property ZoomInc: integer read FZoomInc write SetZoomInc default 10;
    property ZoomFactor: double read GetZoomFactor write SetZoomFactor;
    property Monochrome: boolean read FMonochrome write SetMonochrome default false;
    property MarginMethod: TMarginMethod read FMarginMethod write FMarginMethod
     default mmFixed;
    property MarginPercent: double read FMarginPercent write FMarginPercent;
    property RulerType: TRulerType read FRulerType write FRulerType default rtNone;
    property GridPen: TPen read FGridPen write SetGridPen;
    property GridHoriz: double read FGridHoriz write FGridHoriz;
    property GridVert: double read FGridVert write FGridVert;
    property ShadowDepth: integer read FShadowDepth write SetShadowDepth;
    property PageInc: integer read FPageInc write FPageInc default 1;

    property OnZoomChange: TNotifyEvent read FOnZoomChange write FOnZoomChange;
    property OnPageChange: TNotifyEvent read FOnPageChange write FOnPageChange;

    // RPDD - HM 27/11/02: Added Drill-Down support
    Property Highlight : Boolean Read FHighlight Write FHighlight Default False;
    property OnDrillDown : TDrillDownEvent Read FOnDrillDown write FOnDrillDown;
  end; { TFilePreview }

implementation
{*************************************************************************}
{                            class TFilePreview                           }
{*************************************************************************}

constructor TFilePreview.Create(AOwner: TComponent);
begin { Create }
  inherited;

  FScrollBox := nil;
  FZoomInc := 10;
  FZoom := 100.0;
  FOnPageChange := nil;
  FOnZoomChange := nil;
  FMonochrome := false;
  FMarginPercent := 0.0;
  FMarginMethod := mmFixed;
  FShadowDepth := 0;
  FRulerType := rtNone;
  FGridPen := TPen.Create;
  FGridHoriz := 0;
  FGridVert := 0;
  FPageInc := 1;

  RulerWidth := 0;
  RulerHeight := 0;

  // RPDD - HM 27/11/02: Added Drill-Down support
  FDrillList := TDrillDownAreaList.Create;
end;  { Create }

destructor TFilePreview.Destroy;
begin { Destroy }
  If Printing then begin
    Finish;
  end; { if }
  FGridPen.Free;

  // RPDD - HM 27/11/02: Added Drill-Down support
  FreeAndNIL(FDrillList);

  inherited;
end;  { Destroy }

procedure TFilePreview.AbsorbIntProp(Reader: TReader);

begin { AbsorbIntProp }
  Reader.ReadInteger;
end;  { AbsorbIntProp }

procedure TFilePreview.DefineProperties(Filer: TFiler);

begin { DefineProperties }
  inherited DefineProperties(Filer);
  Filer.DefineProperty('PagesHigh',AbsorbIntProp,nil,false);
  Filer.DefineProperty('PagesWide',AbsorbIntProp,nil,false);
end;  { DefineProperties }

procedure TFilePreview.PageChangeEvent;

begin { PageChangeEvent }
  If Assigned(FOnPageChange) then begin
    FOnPageChange(self);
  end; { if }
end;  { PageChangeEvent }

procedure TFilePreview.ZoomChangeEvent;

begin { ZoomChangeEvent }
  If Assigned(FOnZoomChange) then begin
    FOnZoomChange(self);
  end; { if }
end;  { ZoomChangeEvent }

function TFilePreview.GetZoomFactor: double;
begin { GetZoomFactor }
  Result := FZoom;
end;  { GetZoomFactor }

procedure TFilePreview.SetZoomFactor(Value: double);
begin { SetZoomFactor }
  If Value <= -1.9 then begin { -2 for ZoomPageWidthFactor } {!!!}
    FZoom := ZoomPageWidthFactor;
  end else if Value < 0.0 then begin { -1 for ZoomPageFactor }
    FZoom := ZoomPageFactor;
  end else if Value < MINPREVIEWZOOM then begin
    FZoom := MINPREVIEWZOOM;
  end else if Value > MAXPREVIEWZOOM then begin
    FZoom := MAXPREVIEWZOOM;
  end else begin
    FZoom := Value;
  end; { else }

{ Call the OnZoomChange event }
  ZoomChangeEvent;
  If not Assigned(FOnZoomChange) then begin
    If Printing then begin
      RedrawPage;
    end; { if }
  end; { if }
end;  { SetZoomFactor }

procedure TFilePreview.SetZoomInc(Value: integer);

begin { SetZoomInc }
  FZoomInc := Value;
end;  { SetZoomInc }

procedure TFilePreview.SetMonochrome(Value: boolean);

begin { SetMonochrome }
  If (ShadowDepth > 0) and Value then begin { Warn programmer }
    ShowMessage('Monochrome not allowed while shadows are in effect.'#13 +
     'Change ShadowDepth to 0 first');
  end else begin
    FMonochrome := Value;
  end; { else }
end;  { SetMonochrome }

procedure TFilePreview.SetShadowDepth(Value: integer);

begin { SetShadowDepth }
  If (Value > 0) and Monochrome then begin { Warn programmer }
    ShowMessage('Shadows not allowed while monochrome in effect.'#13 +
     'Change Monochrome to false first');
  end else begin
    FShadowDepth := Value;
  end; { else }
end;  { SetShadowDepth }

procedure TFilePreview.SetGridPen(Value: TPen);

begin { SetGridPen }
  FGridPen.Assign(Value);
end;  { SetGridPen }

function TFilePreview.GetZoomPageWidthFactor: double;

var
  F1: double;
  NewZoom: double;
  Adjustment: integer;
  ScrollWidth: integer;
  ScrollHeight: integer;

begin { GetZoomPageWidthFactor }
  CheckPrinting;

{ Calculate new scrollwidth taking into account the shadow depth }
  ScrollWidth := FScrollBox.Width - ShadowDepth - RulerWidth;
  ScrollHeight := FScrollBox.Height - ShadowDepth - RulerHeight;

{ Calculate new zoom factor for no vertical scroll bar }
  If FMarginMethod = mmScaled then begin
    NewZoom := (ScrollWidth - FHorzAdj) / (PaperWidth * FXDPI *
     (1.0 + FMarginPercent / 50.0));
  end else begin { mmFixed }
    Adjustment := Round(PaperWidth * FXDPI * (FMarginPercent / 100.0));
    NewZoom := (ScrollWidth - (FHorzAdj + Adjustment * 2.0)) /
     (PaperWidth * FXDPI);
  end; { else }

{ Calculate adjustment for above zoom factor }
  F1 := PaperWidth * FXDPI * (FMarginPercent / 100.0);
  If FMarginMethod = mmScaled then begin
    F1 := F1 * NewZoom;
  end; { if }
  Adjustment := Round(F1);

{ Determine if vertical scroll bar will still appear }
  If (PaperHeight * FYDPI * NewZoom + 2 * Adjustment) >
   (ScrollHeight - FVertAdj) then begin
  { Subtract scroll bar width from available width and recalc zoom factor }
    If FMarginMethod = mmScaled then begin
      NewZoom := (ScrollWidth - (FHorzAdj + FScrollBarWidth)) /
       (PaperWidth * FXDPI * (1.0 + FMarginPercent / 50.0));
    end else begin { mmFixed }
      NewZoom := (ScrollWidth - (FHorzAdj + Adjustment * 2.0 +
       FScrollBarWidth)) / (PaperWidth * FXDPI);
    end; { else }
  end; { if }

  Result := NewZoom * 100.0;
end;  { GetZoomPageWidthFactor }

function TFilePreview.GetZoomPageFactor: double;

var
  Z1,Z2: double;
  Adjustment: integer;
  ScrollWidth: integer;
  ScrollHeight: integer;

begin { GetZoomPageFactor }
  CheckPrinting;

{ Calculate new scrollwidth taking into account the shadow depth }
  ScrollWidth := FScrollBox.Width - ShadowDepth - RulerWidth;
  ScrollHeight := FScrollBox.Height - ShadowDepth - RulerHeight;

  If FMarginMethod = mmScaled then begin
    Z1 := (ScrollWidth - 4) / (PaperWidth * FXDPI *
     (1.0 + FMarginPercent / 50.0));
    Z2 := (ScrollHeight - 4) / (PaperHeight * FYDPI +
     (PaperWidth * FXDPI * FMarginPercent / 50.0));
  end else begin { mmFixed }
    Adjustment := Round(PaperWidth * FXDPI * (FMarginPercent / 100.0));
    Z1 := (ScrollWidth - 4 - Adjustment * 2.0) / (PaperWidth * FXDPI);
    Z2 := (ScrollHeight - 4 - Adjustment * 2.0) / (PaperHeight * FYDPI);
  end; { else }

  If Z1 <= Z2 then begin
    Result := Z1 * 100.0;
  end else begin
    Result := Z2 * 100.0;
  end; { else }
end;  { GetZoomPageFactor }

procedure TFilePreview.Notification(AComponent: TComponent;
                                    Operation: TOperation);

begin { Notification }
  inherited Notification(AComponent,Operation);
  If (Operation = opRemove) and (AComponent = FScrollBox) then begin
    FScrollBox := nil;
  end; { if }
end;  { Notification }

procedure TFilePreview.SetScrollBox(Value: TScrollBox);

begin { SetScrollBox }
  FScrollBox := Value;
  If Assigned(Value) then begin
    Value.FreeNotification(self);
  end; { if }
end;  { SetScrollBox }

function TFilePreview.Destination: TDestination;

begin { Destination }
  Result := destPreview;
end;  { Destination }

{ Public Methods }
procedure TFilePreview.PrevPage;

begin { PrevPage }
  If PrevPagePos > 0 then begin
    PrintPage(FCurrentPage - FPageInc);
  end; { if }
end;  { PrevPage }

procedure TFilePreview.NextPage;

begin { NextPage }
  If NextPagePos > 0 then begin
    PrintPage(FCurrentPage + FPageInc);
  end; { if }
end;  { NextPage }

procedure TFilePreview.ZoomIn;

begin { ZoomIn }
  ZoomFactor := ZoomFactor + FZoomInc;
end;  { ZoomIn }

procedure TFilePreview.ZoomOut;
begin { ZoomOut }
  if ZoomFactor > FZoomInc then begin
    ZoomFactor := ZoomFactor - FZoomInc;
  end;
end;  { ZoomOut }

procedure TFilePreview.RedrawPage;
begin { RedrawPage }
  PrintPage(FCurrentPage);
end;  { RedrawPage }

procedure TFilePreview.PrintPage(PageNum: word);
var
  F1: double;
  Margin: double;
  SaveHorzPos: integer;
  SaveVertPos: integer;
  Adjustment: integer;
  RulerColor: TColor;
  TickLength: integer;
  TickHeight: double;
  TickWidth: double;
  Ticks: integer;
  TickNum: integer;
  TickStr: string[3];
  TickMarker: double;
  TickTarget: integer;
  SavePen: TPen;
  GridTarget: integer;
  GridMarker: double;
  SaveCursor: TCursor;
begin { PrintPage }
  If not Printing then Exit;

  If Monochrome then begin
    ShadowDepth := 0;
  end; { if }

  Case RulerType of
    rtNone,rtHorizCm,rtHorizIn: begin
      RulerWidth := 0;
    end;
    else begin
      RulerWidth := 20;
    end;
  end; { case }

  Case RulerType of
    rtNone,rtVertCm,rtVertIn: begin
      RulerHeight := 0;
    end;
    else begin
      RulerHeight := 20;
    end;
  end; { case }

  AddX := RulerWidth;
  AddY := RulerHeight;

  RulerColor := RGB(255,255,128);
  SaveCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    GotoPage(PageNum); { Read in page header }

  { Call the OnPageChange event }
    PageChangeEvent;

    With FScrollBox do begin
      SaveHorzPos := HorzScrollBar.Position;
      HorzScrollBar.Position := 0;
      SaveVertPos := VertScrollBar.Position;
      VertScrollBar.Position := 0;
    end; { with }

  { Initialize bitmap and calculate adjustment values for pseudo page }
    Margin := FMarginPercent / 100.0;
    F1 := PaperWidth * FXDPI;
    If FMarginMethod = mmScaled then begin
      Adjustment := Round(F1 * Margin * FZoom / 100.0);
    end else begin
      Adjustment := Round(F1 * Margin);
    end; { else }
    F1 := F1 * FZoom / 100.0;
    FBitmap.Width := Round(F1) + ShadowDepth + AddX;
    FBitmap.Height := Round(PaperHeight * FYDPI * FZoom / 100.0) +
     ShadowDepth + AddY;

  { Draw psuedo-paper }

  { Draw the shadow first }

  { Lower left corner }
    SetPen(FScrollBox.Color,psSolid,1,pmCopy);
    SetBrush(FScrollBox.Color,bsSolid,nil);
    Canvas.Rectangle(0, FBitmap.Height - ShadowDepth,
     ShadowDepth + AddX,FBitmap.Height);

  { Right Shadow }
    SetPen(clBlack,psSolid,1,pmCopy);
    SetBrush(clBlack,bsSolid,nil);
    Canvas.Rectangle(FBitmap.Width - ShadowDepth, ShadowDepth + AddY,
     FBitMap.Width,FBitmap.Height);

  { Upper Right Corner }
    SetPen(FScrollBox.Color,psSolid,1,pmCopy);
    SetBrush(FScrollBox.Color,bsSolid,nil);
    Canvas.Rectangle(FBitmap.Width - ShadowDepth,0, FBitMap.Width,
     ShadowDepth + AddY);

  { Lower Shadow }
    SetPen(clBlack,psSolid,1,pmCopy);
    SetBrush(clBlack,bsSolid,nil);
    Canvas.Rectangle(ShadowDepth + AddX, FBitmap.Height - ShadowDepth,
     FBitmap.Width,FBitmap.Height);

  { Draw the ruler }
  { Upper left corner shadow }
    If (RulerWidth > 0) and (RulerHeight > 0) then begin
      SetPen(clLtGray,psSolid,1,pmCopy);
      SetBrush(clLtGray,bsSolid,nil);
      Canvas.Rectangle(0,0,AddX, AddY);
    end; { if }

  { Upper right ruler shadow }

    If RulerType in [rtHorizIn,rtHorizCm,rtBothIn,rtBothCm] then begin
      SetPen(clBlack,psSolid,1,pmCopy);
      SetBrush(clBlack,bsSolid,nil);
      Canvas.Rectangle(FBitMap.Width - ShadowDepth,ShadowDepth,
      FBitmap.Width,AddY + ShadowDepth);
     end; { if }

  { Lower left ruler shadow }
    If RulerType in [rtVertIn, rtVertCm,rtBothIn,rtBothCm] then begin
      SetPen(clBlack,psSolid,1,pmCopy);
      SetBrush(clBlack,bsSolid,nil);
      Canvas.Rectangle(ShadowDepth,FBitMap.Height - ShadowDepth,
       AddX + ShadowDepth,FBitMap.Height);
     end; { if }

  { Left side ruler }
    If RulerWidth > 0 then begin
      SetPen(clBlack,psSolid,1,pmCopy);
      SetBrush(RulerColor,bsSolid,nil);
      Canvas.Rectangle(0,AddY,AddX + 1,FBitmap.Height - ShadowDepth);
    end; { if }

  { Top Ruler }
    If RulerHeight > 0 then begin
      SetPen(clBlack,psSolid,1,pmCopy);
      SetBrush(RulerColor,bsSolid,nil);
      Canvas.Rectangle(AddX,0,FBitmap.Width - ShadowDepth,AddY + 1);
    end; { if }

  { Draw ticks and numbers }
    If RulerType <> rtNone then begin
      TickWidth := (FBitmap.Width - ShadowDepth - AddX) / PaperWidth;
      TickHeight := (FBitmap.Height - ShadowDepth - AddY) / PaperHeight;
      TickStr := '';

      With FBitmap.Canvas do begin
        With Font do begin
          Name := 'Arial';
          Size := 7;
          Color := clBlack;
          Style := [];
        end; { with }
        SetBKMode(Handle,TRANSPARENT);
      end; { with }

      Case RulerType of
        rtHorizIn,rtVertIn,rtBothIn: begin
          TickWidth := TickWidth / 8;
          TickHeight := TickHeight / 8;
          Ticks := 8;
        end;
        else begin { rtHorizCm,rtVertCm,rtBothCm }
          TickWidth := TickWidth / 25.4;
          TickHeight := TickHeight / 25.4;
          Ticks := 10;
        end;
      end; { case }

    { Draw horizontal ruler tick marks }
      If RulerType in [rtHorizIn,rtBothIn,rtHorizCm,rtBothCm] then begin
        TickMarker := AddX + TickWidth;
        TickTarget := FBitmap.Width - (ShadowDepth + 1);
        TickNum := 0;

        While Round(TickMarker) <= TickTarget do begin
          Inc(TickNum);

        { Determine which type of tick mark we are on }
          Case RulerType of
            rtHorizIn,rtBothIn: begin
              Case TickNum mod Ticks of
                0: begin { 18 pixels }
                  TickLength := 18;
                  TickStr := IntToStr(TickNum div Ticks);
                end;
                2,6: begin { 10 pixels }
                  TickLength := 10;
                end;
                4: begin { 15 pixels }
                  TickLength := 15;
                end;
                else begin { 1,3,5,7 - 5 pixels }
                  TickLength := 5;
                end;
              end; { case }
            end;
            else begin { rtHorizCm,rtBothCm }
              Case TickNum mod Ticks of
                0: begin { 18 pixels }
                  TickLength := 18;
                  TickStr := IntToStr(TickNum div Ticks);
                end;
                5: begin { 15 pixels }
                  TickLength := 15;
                end;
                else begin { 1,2,3,4,6,7,8,9 - 5 pixels }
                  TickLength := 5;
                end;
              end; { case }
            end;
          end; { case }

        { Draw the tick line }
          FBitmap.Canvas.MoveTo(Round(TickMarker),AddY);
          FBitmap.Canvas.LineTo(Round(TickMarker),AddY - TickLength + 1);

        { Draw the tick string if any }
          If TickStr <> '' then begin
            With FBitmap.Canvas do begin
              Textout(Round(TickMarker) - (TextWidth(TickStr) + 1),0,TickStr);
              TickStr := '';
            end; { with }
          end; { if }

          TickMarker := TickMarker + TickWidth;
        end; { while }
      end; { if }

    { Draw vertical ruler tick marks }
      If RulerType in [rtVertIn,rtBothIn,rtVertCm,rtBothCm] then begin
        TickMarker := AddY + TickHeight;
        TickTarget := FBitmap.Height - (ShadowDepth + 1);
        TickNum := 0;

        While Round(TickMarker) <= TickTarget do begin
          Inc(TickNum);

        { Determine which type of tick mark we are on }
          Case RulerType of
            rtVertIn,rtBothIn: begin
              Case TickNum mod Ticks of
                0: begin { 18 pixels }
                  TickLength := 18;
                  TickStr := IntToStr(TickNum div Ticks);
                end;
                2,6: begin { 10 pixels }
                  TickLength := 10;
                end;
                4: begin { 15 pixels }
                  TickLength := 15;
                end;
                else begin { 1,3,5,7 - 5 pixels }
                  TickLength := 5;
                end;
              end; { case }
            end;
            else begin { rtVertCm,rtBothCm }
              Case TickNum mod Ticks of
                0: begin { 18 pixels }
                  TickLength := 18;
                  TickStr := IntToStr(TickNum div Ticks);
                end;
                5: begin { 15 pixels }
                  TickLength := 15;
                end;
                else begin { 1,2,3,4,6,7,8,9 - 5 pixels }
                  TickLength := 5;
                end;
              end; { case }
            end;
          end; { case }

        { Draw the tick line }
          FBitmap.Canvas.MoveTo(AddX,Round(TickMarker));
          FBitmap.Canvas.LineTo(AddX - TickLength + 1,Round(TickMarker));

        { Draw the tick string if any }
          If TickStr <> '' then begin
            With FBitmap.Canvas do begin
              Textout(2,Round(TickMarker) - (TextHeight(TickStr) + 1),TickStr);
              TickStr := '';
            end; { with }
          end; { if }

          TickMarker := TickMarker + TickHeight;
        end; { while }
      end; { if }
    end; { if }

  { Draw the page }
    SetPen(clBlack,psSolid,1,pmCopy);
    SetBrush(clWhite,bsSolid,nil);
    Canvas.Rectangle(AddX,AddY,FBitmap.Width - ShadowDepth,
     FBitmap.Height - ShadowDepth);

  { Draw the Grid }
  { Horizontal Lines }
    If GridHoriz > 0 then begin
      SavePen := FBitMap.Canvas.Pen;
      FBitmap.Canvas.Pen := FGridPen;
      GridTarget := FBitmap.Height - ShadowDepth;
      GridMarker := AddY + GridHoriz * FYDPI * FZoom / 100.0;
      While Round(GridMarker) < GridTarget do begin
        FBitMap.Canvas.MoveTo(AddX + 1,Round(GridMarker));
        FBitMap.Canvas.LineTo(FBitmap.Width - (ShadowDepth + 1),
         Round(GridMarker));
        GridMarker := GridMarker + GridHoriz * FYDPI * FZoom / 100.0;
      end; { while }
      FBitmap.Canvas.Pen := SavePen;
    end; { if }

  { Vertical Lines }
    If GridVert > 0 then begin
      SavePen := FBitMap.Canvas.Pen;
      FBitmap.Canvas.Pen := FGridPen;
      GridTarget := FBitmap.Width - ShadowDepth;
      GridMarker := AddX + GridVert * FXDPI * FZoom / 100.0;
      While Round(GridMarker) < GridTarget do begin
        FBitMap.Canvas.MoveTo(Round(GridMarker) ,AddY + 1);
        FBitMap.Canvas.LineTo(Round(GridMarker),FBitmap.Height -
         (ShadowDepth + 1));
        GridMarker := GridMarker + GridVert * FXDPI * FZoom / 100.0;
      end; { while }
      FBitmap.Canvas.Pen := SavePen;
    end; { if }

    // RPDD - HM 27/11/02: Added Drill-Down support
    FDrillList.Clear;

    // RPDD - HM 30/03/03: Reset Drill display on zoom/page change
    FImage.Reset;

    inherited PrintPage(PageNum); { Draw page }

  { Initialize Image }
    With FImage do begin
      Top := Adjustment;
      Left := Adjustment;
      Width := FBitmap.Width;
      Height := FBitmap.Height;
      Picture.Bitmap := FBitmap;
    end; { with }

    With FScrollBox do begin
      With HorzScrollBar do begin
        Position := SaveHorzPos;
        Range := FBitmap.Width + 2 * Adjustment;
      end; { with }
      With VertScrollBar do begin
        Position := SaveVertPos;
        Range := FBitmap.Height + 2 * Adjustment;
      end; { with }
    end; { with }
  finally
    Screen.Cursor := SaveCursor;
    ClearFontList;
    ClearLineLists;
  end; { tryf }
end;  { PrintPage }

procedure TFilePreview.Start;

begin { Start }
  If FPrinting then Exit;
  If not Assigned(FScrollBox) then begin
    RaiseError('ScrollBox must be assigned for FilePreview component');
  end; { if }

  FLocalDevice := TRPRenderDevice.Create;
  ReportDateTime := Now;
  ZoomChangeEvent;

  With FScrollBox do begin
  { Calculate scroll bar height }
    HorzScrollBar.Range := ClientWidth * 2;
    FScrollBarHeight := ClientHeight;
    HorzScrollBar.Range := ClientWidth;
    FScrollBarHeight := ClientHeight - FScrollBarHeight;

  { Calculate scroll bar width }
    VertScrollBar.Range := ClientHeight * 2;
    FScrollBarWidth := ClientWidth;
    VertScrollBar.Range := ClientHeight;
    FScrollBarWidth := ClientWidth - FScrollBarWidth;

  { Calculate difference between dimension and client dimension }
    FHorzAdj := Width - ClientWidth;
    FVertAdj := Height - ClientHeight;
  end; { with }

  FBitmap := TBitmap.Create;
  (FLocalDevice as TRPRenderDevice).Canvas := FBitmap.Canvas;
  FBitmap.Canvas.Handle; { Load valid font, pen and brush }
  FBitmap.Monochrome := Monochrome;
  If Assigned(FImage) then begin
    FImage.Free;
  end; { if }
  // RPDD - HM 27/11/02: Added Drill-Down support
  FImage := TDrillControl.Create(FScrollBox.Owner);
  With FImage do begin
    Parent := FScrollBox;
    Align := alNone;
    Top := 0;
    Left := 0;
    Width := 100;
    Height := 100;
    FImage.Highlight := Self.FHighlight;

    // RPDD - HM 27/11/02: Added Drill-Down support
    If Assigned(FOnDrillDown) Then Begin
      // Don't bother doing anything if the OnDrillDown event isn't handled
      OnDrillAvailable := CheckForDrillArea;
      OnDrillClick     := ImageDrillClick;
    End; { If Assigned(FOnDrillDown) }
  end; { with }

  AddX := 0;
  AddY := 0;
  FImage.Canvas.MoveTo(0,0);
  FXDPI := GetDeviceCaps(FImage.Canvas.Handle,LOGPIXELSX);
  FYDPI := GetDeviceCaps(FImage.Canvas.Handle,LOGPIXELSY);

  ReadJobHeader; { Read in job header }
  FCurrentPage := 0;
  PrevPagePos := 0;
  CurrPagePos := 0;
  NextPagePos := FStream.Position;
  FPrinting := true;
  FAborted := false;
  PrintPage(1); { Print first available page }
end;  { Start }

procedure TFilePreview.Finish;

begin { Finish }
  If not FPrinting then Exit;
  FPrinting := false;

{ Unhook from visual component event handlers }
{ FScrollBox.RemoveComponent(FImage); }
{ FImage.Free; }
  FBitmap.Free;

{ Close input stream }
  If FStreamMode <> smUser then begin
    FreeAndNil(FStream);
    JobHeaderRead := false;
  end; { if }

  FLocalDevice.Free;
  FLocalDevice := nil;
end;  { Finish }

procedure TFilePreview.Execute;

begin { Execute }
  Start;
end;  { Execute }

procedure TFilePreview.Clear;

begin { Clear } {!!! New Function }
  FImage.Free;
  FImage := nil;
end;  { Clear }

procedure TFilePreview.PrintBitmapRect2(X1,Y1,X2,Y2: double;
                            Bitmap: TBitmap);
Begin { PrintBitmapRect2 }
  { Don't print it in Previews }
End; { PrintBitmapRect2 }


// RPDD - HM 27/11/02: Added Drill-Down support
// Called by TFilePrinter to record the Drill-Down area details in the
// internal list
procedure TFilePreview.DrillDownArea (Const X1, Y1, X2, Y2 : Double;
                                      Const LevelNo        : Byte;
                                      Const DDS1           : ShortString;
                                      Const DDI1, DDI2     : SmallInt;
                                      Const DDB1           : Byte);
Begin { DrillDownArea }
  // Don't bother doing anything if the OnDrillDown event isn't handled
  If Assigned(FOnDrillDown) Then
    // Add Drill-Down details into the Drill-Down list
    FDrillList.AddDrillDown (XU2D(X1), YU2D(Y1), XU2D(X2), YU2D(Y2),
                             LevelNo, DDS1, DDI1, DDI2, DDB1);
End; { DrillDownArea }


// RPDD - HM 02/01/03: Extended Drill-Down support
// Called by the FImage : TDrillControl component to determine whether the
// mouse pointer is currently positioned on a Drill-Down area
Function TFilePreview.CheckForDrillArea (      Sender : TObject;
                                         Const X, Y   : Integer;
                                         Var   dLeft, dTop, dWidth, dHeight : Integer) : Boolean;
Var
  DrillDets : TDrillDownArea;
Begin { CheckForDrillArea }
  // Don't bother doing anything if the OnDrillDown event isn't handled
  If Assigned(FOnDrillDown) Then Begin
    // Check the Drill-Down list for areas matching the co-ordinates - not
    // interested in using the parameters
    Result := FDrillList.GotDrillDown (X, Y, DrillDets);
    If Result And FHighlight Then Begin
      // Return Co-ords for highlight box
      dLeft   := DrillDets.daX1;
      dTop    := DrillDets.daY1 + 1;
      dWidth  := DrillDets.daX2 - dLeft + 1;
      dHeight := DrillDets.daY2 - dTop + 1;
    End { If Result And FHighlight }
    Else Begin
      dLeft   := 0;
      dTop    := 0;
      dWidth  := 0;
      dHeight := 0;
    End; { Else }
  End { If Assigned(FOnDrillDown) }
  Else
    Result := False;
End; { CheckForDrillArea }


// RPDD - HM 27/11/02: Added Drill-Down support
// Called by the FImage : TDrillControl component whenever a click event
// occurs
procedure TFilePreview.ImageDrillClick (Sender : TObject; Const X, Y : Integer);
Var
  DrillDets : TDrillDownArea;
Begin { ImageDrillClick }
  // Don't bother doing anything if the OnDrillDown event isn't handled
  If Assigned(FOnDrillDown) Then
    // Check the Drill-Down list for areas matching the co-ordinates
    If FDrillList.GotDrillDown (X, Y, DrillDets) Then
      // Got an area - generate the event to the client application
      With DrillDets Do
        FOnDrillDown (Self, daLevelNo, daString1, daInt1, daInt2, daByte1);
End; { ImageDrillClick }

end.