
{*******************************************************}
{                                                       }
{       RichView                                        }
{       TRVBackground: background for RichView,         }
{       table, or table cell.                           }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVBack;

{$I RV_Defs.inc}

interface
uses SysUtils, Windows, Classes, Graphics,
     {$IFNDEF RVDONOTUSEJPEGIMAGE}
     Jpeg,
     {$ENDIF}
     RVStyle, RVScroll, RVFuncs, RVGrIn;

type
  TRVBackground = class
    private
      ImageCopy: TGraphic;
      function GetBitmap: TBitmap;
      function GetItemBackStyle: TRVItemBackgroundStyle;
      procedure SetItemBackStyle(const Value: TRVItemBackgroundStyle);
    public
      Style: TBackgroundStyle;
      Image: TGraphic;
      constructor Create(CreateBitmap: Boolean);
      destructor Destroy; override;
      function ScrollRequiresFullRedraw: Boolean;
      procedure UpdatePaletted(PaletteAction: TRVPaletteAction;Palette: HPALETTE; LogPalette: PLogPalette);
      procedure Draw(Canvas: TCanvas; Rect: TRect;
        HOffs, VOffs, Left, Top, Width,Height: Integer; Color: TColor;
        Clipping, PrintSimulation: Boolean; GraphicInterface: TRVGraphicInterface);
      procedure Print(Canvas: TCanvas; ARect, AFullRect: TRect; const sad: TRVScreenAndDevice;
        Color: TColor; Preview: Boolean; LogPalette: PLogPalette;
        PrintingRVData: TPersistent; ItemBackgroundLayer: Integer;
        GraphicInterface: TRVGraphicInterface);
      function Empty: Boolean;
      function Visible: Boolean;
      function IsSemitransparent: Boolean;
      procedure FreeImage;
      procedure AssignImage(AImage: TGraphic; ARVData: TPersistent; Copy: Boolean);
      property Bitmap: TBitmap read GetBitmap;
      property ItemBackStyle: TRVItemBackgroundStyle read GetItemBackStyle write SetItemBackStyle;
  end;

implementation

uses CRVData, PtRVData;

{============================== TRVBackground =================================}
constructor TRVBackground.Create(CreateBitmap: Boolean);
begin
  inherited Create;
  if CreateBitmap then
    Image := TBitmap.Create;
  Style  := bsNoBitmap;
end;
{------------------------------------------------------------------------------}
destructor TRVBackground.Destroy;
begin
  Image.Free;
  ImageCopy.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
function TRVBackground.ScrollRequiresFullRedraw: Boolean;
begin
  if Image.Empty then
    Result := False
  else begin
    case Style of
      bsNoBitmap, bsTiledAndScrolled:
        Result := False;
      //bsStretched, bsTiled, bsCentered, corners:
      else
        Result := True;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVBackground.UpdatePaletted(PaletteAction: TRVPaletteAction;
                             Palette: HPALETTE; LogPalette: PLogPalette);
begin
  ImageCopy.Free;
  ImageCopy := nil;
  if Image=nil then
    exit;
  case PaletteAction of
    rvpaAssignPalette:
      if (LogPalette<>nil) and not Image.Empty then
        RV_SetPaletteToPicture(Image,LogPalette);
    rvpaCreateCopies,rvpaCreateCopiesEx:
      if (LogPalette<>nil) and not Image.Empty then begin
        {$IFNDEF RVDONOTUSEJPEGIMAGE}
        if (PaletteAction=rvpaCreateCopiesEx) and
          (Image is TJpegImage) then
          ImageCopy := TBitmap.Create
        else
        {$ENDIF}
          ImageCopy := RV_CreateGraphics(TGraphicClass(Image.ClassType));
        ImageCopy.Assign(Image);
        RV_SetPaletteToPicture(ImageCopy,LogPalette);
        if ImageCopy is TBitmap then
          TBitmap(ImageCopy).IgnorePalette := True;
      end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVBackground.Print(Canvas: TCanvas; ARect, AFullRect: TRect;
  const sad: TRVScreenAndDevice; Color: TColor; Preview: Boolean; LogPalette: PLogPalette;
  PrintingRVData: TPersistent; ItemBackgroundLayer: Integer;
  GraphicInterface: TRVGraphicInterface);
var i, j: Integer;
    OffsRect: TRect;
    bmp: TBitmap;
    gr: TGraphic;
    DCIdx, BmpWidth, BmpHeight, DX, DY: Integer;
    pt: TPoint;
    RVData: TCustomPrintableRVData;

    procedure DrawBitmapAt(Left, Top: Integer);
    var bmp2: TBitmap;
        w, h, x, y: Integer;
    begin
      if RV_IsGraphicTransparent(gr) and (Color=clNone) then begin
        RVData.DrawBackToBitmap( RV_XToScreen(Left+DX, sad), RV_YToScreen(Top+DY, sad),
          bmp, sad, ItemBackgroundLayer, True);
        GraphicInterface.DrawGraphic(bmp.Canvas, 0, 0, gr);
      end;
      bmp2 := bmp;
      try
        if (Left<ARect.Left) or (Top<ARect.Top) or
           (Left+RV_XToDevice(bmp.Width, sad)>ARect.Right) or
           (Top+RV_YToDevice(bmp.Height, sad)>ARect.Bottom) then begin
          x := 0;
          y := 0;
          bmp2 := TBitmap.Create;
          w := bmp.Width;
          if Left<ARect.Left then begin
            dec(w, RV_XToScreen(ARect.Left-Left, sad));
            dec(x, RV_XToScreen(ARect.Left-Left, sad));
          end;
          if RV_XToScreen(Left, sad)+bmp.Width>RV_XToScreen(ARect.Right,sad) then
            dec(w, RV_XToScreen(Left, sad)+bmp.Width-RV_XToScreen(ARect.Right,sad));
          h := bmp.Height;
          if Top<RV_YToScreen(ARect.Top, sad) then begin
            dec(h, RV_YToScreen(ARect.Top-Top, sad));
            dec(y, RV_YToScreen(ARect.Top-Top, sad));
          end;
          if RV_YToScreen(Top, sad)+bmp.Height>RV_YToScreen(ARect.Bottom, sad) then
            dec(h, RV_YToScreen(Top, sad)+bmp.Height-RV_YToScreen(ARect.Bottom, sad));
          if (w>0) and (h>0) then begin
            bmp2.Width := w;
            bmp2.Height := h;
            GraphicInterface.DrawGraphic(bmp2.Canvas, x, y, bmp);
            if Left<ARect.Left then
              Left := ARect.Left;
            if Top<ARect.Top then
              Top := ARect.Top;
            end
          else begin
            bmp2.Free;
            bmp2 := nil;
          end;
        end;
        if bmp2<>nil then
          RV_PictureToDevice(Canvas, Left, Top, bmp2.Width, bmp2.Height, @sad,
            bmp2, Preview, GraphicInterface);
      finally
        if bmp2<>bmp then
          bmp2.Free;
      end;
    end;

    procedure DrawBitmapAtEx(Left, Top, Width, Height: Integer);
    begin
      if RV_IsGraphicTransparent(gr) and (Color=clNone) then begin
        bmp.Width := RV_XToScreen(Width, sad);
        bmp.Height := RV_YToScreen(Height, sad);
        RVData.DrawBackToBitmap(
          RV_XToScreen(Left+DX, sad), RV_YToScreen(Top+DY, sad),
          bmp, sad, ItemBackgroundLayer, True);
        GraphicInterface.StretchDrawGraphic(bmp.Canvas,
          Rect(0,0,bmp.Width,bmp.Height),gr);
        RV_PictureToDevice(Canvas, Left, Top, bmp.Width, bmp.Height, @sad, bmp,
          Preview, GraphicInterface);
        end
      else
        RV_PictureToDevice(Canvas, Left, Top,
          RV_XToScreen(Width, sad), RV_YToScreen(Height, sad), @sad, bmp, Preview,
          GraphicInterface);
    end;

begin
  DCIdx := GraphicInterface.SaveCanvasState(Canvas);
  DX := ARect.Left-AFullRect.Left;
  DY := ARect.Top -AFullRect.Top;
  GraphicInterface.GetWindowOrgEx(Canvas, pt);
  GraphicInterface.SetWindowOrgEx(Canvas, pt.x-ARect.Left, pt.y-ARect.Top, @pt);
  OffsetRect(ARect, -ARect.Left, -ARect.Top);
  try
    if ImageCopy=nil then
      gr := Image
    else
      gr := ImageCopy;
    RVData := PrintingRVData as TCustomPrintableRVData;
    if (Color<>clNone) and
      ((gr=nil) or gr.Empty or (Style in [bsNoBitmap, bsCentered, bsTopLeft,
        bsTopRight, bsBottomLeft, bsBottomRight])) then begin
       OffsRect := ARect;
       OffsetRect(OffsRect, -ARect.Left, -ARect.Top);
       GraphicInterface.FillColorRect(Canvas, OffsRect, Color);
    end;
    if (gr<>nil) and not gr.Empty then begin
      bmp := TBitmap.Create;
      try
        bmp.Width := gr.Width;
        bmp.Height := gr.Height;
        BmpWidth  := RV_XToDevice(bmp.Width, sad);
        BmpHeight := RV_YToDevice(bmp.Height, sad);
        if LogPalette<>nil then
          bmp.Palette := CreatePalette(LogPalette^);
        if Color<>clNone then begin
          bmp.Canvas.Brush.Color := Color;
          GraphicInterface.FillRect(bmp.Canvas, Rect(0,0,bmp.Width,bmp.Height));
        end;
        if not RV_IsGraphicTransparent(gr) or (Color<>clNone) then
          GraphicInterface.DrawGraphic(bmp.Canvas, 0,0, gr);
        case Style of
          bsCentered:
            DrawBitmapAt(-ARect.Left+((AFullRect.Right-AFullRect.Left)-bmpWidth) div 2,
                         -ARect.Top+((AFullRect.Bottom-AFullRect.Top)-bmpHeight) div 2);
          bsTopLeft:
            DrawBitmapAt(-ARect.Left+AFullRect.Left, -ARect.Top+AFullRect.Top);
          bsTopRight:
            DrawBitmapAt(-ARect.Left+AFullRect.Right-bmpWidth, -ARect.Top+AFullRect.Top);
          bsBottomLeft:
            DrawBitmapAt(-ARect.Left+AFullRect.Left, -ARect.Top+AFullRect.Bottom-bmpHeight);
          bsBottomRight:
            DrawBitmapAt(-ARect.Left+AFullRect.Right-bmpWidth,
                         -ARect.Top+AFullRect.Bottom-bmpHeight);
          bsTiled, bsTiledAndScrolled:
            for i:= ARect.Top div bmpHeight to ARect.Bottom div bmpHeight do
              for j:= ARect.Left div bmpWidth to ARect.Right div bmpWidth do
                DrawBitmapAt(j*bmpWidth-ARect.Left,i*bmpHeight-ARect.Top);
          bsStretched:
            DrawBitmapAtEx(-ARect.Left, -ARect.Top,
              AFullRect.Right-AFullRect.Left, AFullRect.Bottom-AFullRect.Top);
        end;
      finally
        bmp.Free;
      end;
    end;
  finally
    GraphicInterface.SetWindowOrgEx(Canvas, pt.x, pt.y, nil);
    GraphicInterface.RestoreCanvasState(Canvas, DCIdx);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVBackground.Draw(Canvas: TCanvas; Rect: TRect;
  HOffs, VOffs, Left, Top, Width, Height: Integer;
  Color: TColor; Clipping, PrintSimulation: Boolean;
  GraphicInterface: TRVGraphicInterface);
var i, j: Integer;
    OffsRect: TRect;
    bmp: TBitmap;
    gr: TGraphic;
    DCIdx: Integer;
    pt: TPoint;
    {...............................................................}
    procedure DrawGraphic(X, Y, Width, Height: Integer; gr: TGraphic);
    var bmp: TBitmap;
    begin
      if not PrintSimulation then
        if Width<0 then
          GraphicInterface.DrawGraphic(Canvas, X, Y, gr)
        else
          GraphicInterface.StretchDrawGraphic(Canvas, Bounds(X, Y, Width, Height), gr)
      else begin
        if gr is TBitmap then
          bmp := TBitmap(gr)
        else begin
          bmp := TBitmap.Create;
          try
            bmp.Assign(gr);
          except
            bmp.Width := gr.Width;
            bmp.Height := gr.Height;
            GraphicInterface.DrawGraphic(bmp.Canvas, X, Y, gr);
          end;
        end;
        try
          RV_PictureToDevice(Canvas, X, Y, Width, Height, nil, bmp, False,
            GraphicInterface);
        finally
          if not (gr is TBitmap) then
            bmp.Free;
        end;
      end;
    end;
    {...............................................................}
begin
 if ImageCopy=nil then
   gr := Image
 else
   gr := ImageCopy;
 if Clipping then begin
   DCIdx := GraphicInterface.SaveCanvasState(Canvas);
   with Rect do
     GraphicInterface.IntersectClipRect(Canvas, Left, Top, Right, Bottom);
   GraphicInterface.SetWindowOrgEx(Canvas, -Rect.Left, -Rect.Top, @pt);
   end
 else
   DCIdx := 0;
 try
   OffsetRect(Rect, -Left, -Top);
   if (Color<>clNone) and
     ((gr=nil) or gr.Empty or RV_IsGraphicTransparent(gr) or
     (Style in [bsNoBitmap, bsCentered, bsTopLeft, bsTopRight,
      bsBottomLeft, bsBottomRight])) then begin
     OffsRect := Rect;
     OffsetRect(OffsRect, -Rect.Left, -Rect.Top);
     GraphicInterface.FillColorRect(Canvas, OffsRect, Color);
   end;
   if (gr<>nil) and not gr.Empty then begin
     if (Style<>bsStretched) and (gr is TBitmap) and not PrintSimulation then begin
       bmp := TBitmap(gr);
       case Style of
         bsCentered:
           GraphicInterface.DrawBitmap(Canvas,
             -Rect.Left+(Width-bmp.Width) div 2, -Rect.Top+(Height-bmp.Height) div 2,
             bmp);
         bsTopLeft:
           GraphicInterface.DrawBitmap(Canvas,
             -Rect.Left, -Rect.Top, bmp);
         bsTopRight:
           GraphicInterface.DrawBitmap(Canvas,
             -Rect.Left+(Width-bmp.Width), -Rect.Top, bmp);
         bsBottomLeft:
           GraphicInterface.DrawBitmap(Canvas,
             -Rect.Left, -Rect.Top+(Height-bmp.Height), bmp);
         bsBottomRight:
           GraphicInterface.DrawBitmap(Canvas,
             -Rect.Left+(Width-bmp.Width), -Rect.Top+(Height-bmp.Height), bmp);
         bsTiled:
          for i:= Rect.Top div bmp.Height to Rect.Bottom div bmp.Height do
            for j:= Rect.Left div bmp.Width to Rect.Right div bmp.Width do
              GraphicInterface.DrawBitmap(Canvas,
                j*bmp.Width-Rect.Left,i*bmp.Height-Rect.Top, bmp);
         bsStretched:
            // never called. bad, because does not set SetStretchBltMode
              GraphicInterface.StretchDrawBitmap(Canvas,
                Bounds(-Rect.Left, -Rect.Top, Width, Height), bmp);
         bsTiledAndScrolled:
          for i:= (Rect.Top+VOffs) div bmp.Height to
                  (Rect.Bottom+VOffs) div bmp.Height do
            for j:= (Rect.Left+HOffs) div bmp.Width to
                    (Rect.Right+HOffs) div bmp.Width do
              GraphicInterface.DrawBitmap(Canvas,
                j*bmp.Width-HOffs-Rect.Left,i*bmp.Height-VOffs-Rect.Top, bmp);
       end
       end
     else begin
       case Style of
         bsCentered:
           DrawGraphic(-Rect.Left+(Width-gr.Width) div 2,
           -Rect.Top+(Height-gr.Height) div 2, -1, -1, gr);
         bsTopLeft:
           DrawGraphic(-Rect.Left, -Rect.Top, -1, -1, gr);
         bsTopRight:
           DrawGraphic(-Rect.Left+(Width-gr.Width), -Rect.Top, -1, -1, gr);
         bsBottomLeft:
           DrawGraphic(-Rect.Left, -Rect.Top+(Height-gr.Height), -1, -1, gr);
         bsBottomRight:
           DrawGraphic(-Rect.Left+(Width-gr.Width), -Rect.Top+(Height-gr.Height),
             -1, -1, gr);
         bsTiled:
          for i:= Rect.Top div gr.Height to Rect.Bottom div gr.Height do
            for j:= Rect.Left div gr.Width to Rect.Right div gr.Width do
              DrawGraphic(j*gr.Width-Rect.Left,i*gr.Height-Rect.Top, -1, -1, gr);
         bsStretched:
           DrawGraphic(-Rect.Left, -Rect.Top, Width, Height, gr);
         bsTiledAndScrolled:
          for i:= (Rect.Top+VOffs) div gr.Height to
                  (Rect.Bottom+VOffs) div gr.Height do
            for j:= (Rect.Left+HOffs) div gr.Width to
                    (Rect.Right+HOffs) div gr.Width do
              DrawGraphic(j*gr.Width-HOffs-Rect.Left,i*gr.Height-VOffs-Rect.Top,
                -1, -1, gr);
       end;
     end;
   end;
 finally
   if Clipping then begin
     GraphicInterface.SetWindowOrgEx(Canvas, pt.x, pt.y, nil);
     GraphicInterface.RestoreCanvasState(Canvas, DCIdx);
   end;
 end;
end;
{------------------------------------------------------------------------------}
function TRVBackground.GetBitmap: TBitmap;
begin
  Result := TBitmap(Image);
end;
{------------------------------------------------------------------------------}
function TRVBackground.GetItemBackStyle: TRVItemBackgroundStyle;
begin
  case Style of
    bsNoBitmap:
      Result := rvbsColor;
    bsStretched:
      Result := rvbsStretched;
    bsCentered, bsTopLeft, bsTopRight, bsBottomLeft, bsBottomRight:
      Result := rvbsCentered;
    else
      Result := rvbsTiled;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVBackground.SetItemBackStyle(
  const Value: TRVItemBackgroundStyle);
begin
  case Value of
    rvbsColor:
      Style := bsNoBitmap;
    rvbsStretched:
      Style := bsStretched;
    rvbsCentered:
      Style := bsCentered;
    else
      Style := bsTiled;
  end;
end;
{------------------------------------------------------------------------------}
function TRVBackground.Empty: Boolean;
begin
  Result := (Style=bsNoBitmap) and ((Image=nil) or Image.Empty);
end;
{------------------------------------------------------------------------------}
function TRVBackground.Visible: Boolean;
begin
  Result := (Style<>bsNoBitmap) and (Image<>nil) and not Image.Empty;
end;
{------------------------------------------------------------------------------}
procedure TRVBackground.FreeImage;
begin
  Image.Free;
  ImageCopy.Free;
  Image := nil;
  ImageCopy := nil;
end;
{------------------------------------------------------------------------------}
procedure TRVBackground.AssignImage(AImage: TGraphic; ARVData: TPersistent;
  Copy: Boolean);
var RVData: TCustomRVData;
begin
  if AImage=Image then
    exit;
  if Copy then begin
    FreeImage;
    if AImage<>nil then begin
      Image := RV_CreateGraphics(TGraphicClass(AImage.ClassType));
      Image.Assign(AImage);
    end;
    end
  else begin
    Image := AImage;
  end;
  RVData := TCustomRVData(ARVData);
  UpdatePaletted(RVData.GetDoInPaletteMode, RVData.GetRVPalette,
    RVData.GetRVLogPalette);
end;
{------------------------------------------------------------------------------}
function TRVBackground.IsSemitransparent: Boolean;
begin
  // assuming that Color=clNone
  Result := (Image<>nil) and not Image.Empty and
    (RV_IsGraphicTransparent(Image) or (Style in [bsCentered, bsTopLeft,
      bsTopRight, bsBottomLeft, bsBottomRight]));
end;
{------------------------------------------------------------------------------}

end.
