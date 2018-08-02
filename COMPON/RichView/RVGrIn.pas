
{*******************************************************}
{                                                       }
{       RichView                                        }
{       Basic class for graphic interface               }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}



unit RVGrIn;

interface

{$I RV_Defs.inc}

uses Windows, Graphics, Controls, Classes,
     {$IFDEF RICHVIEWDEF4}
     ImgList,
     {$ENDIF}
     RVTypes;

type
  TRVGraphicInterface = class
    public
      procedure TextOut_A(Canvas: TCanvas; X, Y: Integer; Str: PRVAnsiChar; Length: Integer); virtual; abstract;
      {$IFNDEF RVDONOTUSEUNICODE}
      procedure TextOut_W(Canvas: TCanvas; X, Y: Integer; Str: PRVUnicodeChar; Length: Integer); virtual; abstract;
      {$ENDIF}
      procedure TextOut_(Canvas: TCanvas; X, Y: Integer; Str: PChar; Length: Integer); virtual; abstract;

      procedure ExtTextOut_A(Canvas: TCanvas; X, Y: Integer; Options: Longint;
        Rect: PRect; Str: PRVAnsiChar; Length: Integer; Dx: PInteger); virtual; abstract;
      {$IFNDEF RVDONOTUSEUNICODE}
      procedure ExtTextOut_W(Canvas: TCanvas; X, Y: Integer; Options: Longint;
        Rect: PRect; Str: PRVUnicodeChar; Length: Integer; Dx: PInteger); virtual; abstract;
      {$ENDIF}
      procedure ExtTextOut_(Canvas: TCanvas; X, Y: Integer; Options: Longint;
        Rect: PRect; Str: PChar; Length: Integer; Dx: PInteger); virtual; abstract;

      procedure DrawText(Canvas: TCanvas; Str: PChar; Length: Integer;
        var R: TRect; Alignment: TAlignment); virtual; abstract;

      procedure GetTextExtentPoint32_A(Canvas: TCanvas; Str: PRVAnsiChar; Length: Integer;
        var Size: TSize); virtual; abstract;
      {$IFNDEF RVDONOTUSEUNICODE}
      procedure GetTextExtentPoint32_W(Canvas: TCanvas; Str: PRVUnicodeChar; Length: Integer;
        var Size: TSize); virtual; abstract;
      {$ENDIF}
      procedure GetTextExtentPoint32_(Canvas: TCanvas; Str: PChar; Length: Integer;
        var Size: TSize); virtual; abstract;

      function TextWidth(Canvas: TCanvas; const S: String): Integer;
      function TextHeight(Canvas: TCanvas; const S: String): Integer;

      procedure GetTextExtentExPoint_A(Canvas: TCanvas; Str: PRVAnsiChar;
        Length, MaxExtent: Integer; PFit, PDX: PInteger; var Size: TSize); virtual; abstract;
      {$IFNDEF RVDONOTUSEUNICODE}
      procedure GetTextExtentExPoint_W(Canvas: TCanvas; Str: PRVUnicodeChar;
        Length, MaxExtent: Integer; PFit, PDX: PInteger; var Size: TSize); virtual; abstract;
      {$ENDIF}

      // Return value: text size (as TSmallPoint) or zero on failure
      function GetCharacterPlacement_A(Canvas: TCanvas; Str: PRVAnsiChar;
        Length: Integer; var Results: TGCPResultsA;
        Ligate: Boolean): Cardinal; virtual; abstract;
      {$IFNDEF RVDONOTUSEUNICODE}
      // It's safe to declare Results as TGCPResultsA, because Unicode fields are not used
      function GetCharacterPlacement_W(Canvas: TCanvas; Str: PRVUnicodeChar;
        Length: Integer; var Results: TGCPResultsA;
        Ligate: Boolean): Cardinal; virtual; abstract;
      {$ENDIF}

      function GetOutlineTextMetrics(Canvas: TCanvas; Size: Cardinal;
        POTM: POutlineTextmetric): Cardinal; virtual; abstract;
      function GetTextMetrics(Canvas: TCanvas; var TM: TTextMetric): Boolean; virtual; abstract;
      function FontHasLigationGlyphs(Canvas: TCanvas): Boolean; virtual; abstract;

      procedure SetTextAlign(Canvas: TCanvas; Flags: Cardinal); virtual; abstract;
      function GetTextAlign(Canvas: TCanvas): Cardinal; virtual; abstract;

      function GetTextCharacterExtra(Canvas: TCanvas): Integer; virtual; abstract;
      procedure SetTextCharacterExtra(Canvas: TCanvas; CharExtra: Integer); virtual; abstract;

      // assigns LogFont to Canvas.Font, does not store old font
      procedure SetLogFont(Canvas: TCanvas; const LogFont: TLogFont); virtual; abstract;
      // returns Canvas.Font.Handle
      function GetFontHandle(Canvas: TCanvas): Cardinal; virtual;
      // assigns FontHandle to Canvas.Font, returns old handle which can be used to restore old font
      function SetFontHandle(Canvas: TCanvas; const FontHandle: Cardinal): Cardinal; virtual; abstract;

      procedure SetDiagonalBrush(Canvas: TCanvas; BackColor, ForeColor: TColor;
        XOrg, YOrg: Integer); virtual; abstract;

      function CreateScreenCanvas: TCanvas; virtual; abstract;
      procedure DestroyScreenCanvas(Canvas: TCanvas); virtual; abstract;
      function CreateCompatibleCanvas(Canvas: TCanvas): TCanvas; virtual; abstract;
      procedure DestroyCompatibleCanvas(Canvas: TCanvas); virtual; abstract;
      // CreatePrinterCanvas must be destroyed by DestroyCompatibleCanvas
      function CreatePrinterCanvas: TCanvas; virtual; abstract;

      procedure GetViewportExtEx(Canvas: TCanvas; var Size: TSize); virtual; abstract;
      procedure GetViewportOrgEx(Canvas: TCanvas; var Point: TPoint); virtual; abstract;
      procedure GetWindowExtEx(Canvas: TCanvas; var Size: TSize); virtual; abstract;
      procedure GetWindowOrgEx(Canvas: TCanvas; var Point: TPoint); virtual; abstract;
      procedure SetViewportExtEx(Canvas: TCanvas; XExt, YExt: Integer; Size: PSize); virtual; abstract;
      procedure SetViewportOrgEx(Canvas: TCanvas; X, Y: Integer; Point: PPoint); virtual; abstract;
      procedure SetWindowExtEx(Canvas: TCanvas; XExt, YExt: Integer; Size: PSize); virtual; abstract;
      procedure SetWindowOrgEx(Canvas: TCanvas; X, Y: Integer; Point: PPoint); virtual; abstract;
      function GetMapMode(Canvas: TCanvas): Integer; virtual; abstract;
      function SetMapMode(Canvas: TCanvas; Mode: Integer): Integer; virtual; abstract;

      procedure InvalidateRect(Control: TWinControl; lpRect: PRect); virtual; abstract;

      procedure IntersectClipRect(Canvas: TCanvas; X1, Y1, X2, Y2: Integer); virtual; abstract;
      // returns information to restore old region
      procedure IntersectClipRectEx(Canvas: TCanvas; X1, Y1, X2, Y2: Integer;
        var Rgn: HRGN; var RgnValid: Boolean); virtual; abstract;
      procedure RestoreClipRgn(Canvas: TCanvas;
        Rgn: Cardinal; RgnValid: Boolean); virtual; abstract;

      function SaveCanvasState(Canvas: TCanvas): Integer; virtual; abstract;
      procedure RestoreCanvasState(Canvas: TCanvas; State: Integer); virtual; abstract;

      procedure FillRect(Canvas: TCanvas; const R: TRect); virtual;
      // fills rectangle without modifying Canvas properties, so it can be used between
      // SaveCanvasState and RestoreCanvasState
      procedure FillColorRect(Canvas: TCanvas; const R: TRect; Color: TColor); virtual; abstract;
      procedure Rectangle(Canvas: TCanvas; X1, Y1, X2, Y2: Integer); virtual;
      procedure Polyline(Canvas: TCanvas; var Points; Count: Integer); virtual; abstract;
      procedure Polygon(Canvas: TCanvas; const Points: array of TPoint); virtual;
      procedure Ellipse(Canvas: TCanvas; X1, Y1, X2, Y2: Integer);
      procedure DrawFocusRect(Canvas: TCanvas; const Rect: TRect); virtual;
      procedure MoveTo(Canvas: TCanvas; X, Y: Integer); virtual;
      procedure LineTo(Canvas: TCanvas; X, Y: Integer); virtual;
      procedure Line(Canvas: TCanvas; X1, Y1, X2, Y2: Integer);
      // draws drag&drop caret
      procedure LineDragDropCaret(Canvas: TCanvas; X, Y1, Y2: Integer);
      // draw table resizing line, vertical
      procedure DrawTableResizeVLine(Canvas: TCanvas; X, Y1, Y2: Integer);
      // draw table resizing line, horizontal
      procedure DrawTableResizeHLine(Canvas: TCanvas; X1, X2, Y: Integer);

      procedure DrawBitmap(Canvas: TCanvas; X, Y: Integer; bmp: TBitmap); virtual; abstract;
      procedure StretchDrawBitmap(Canvas: TCanvas; const R: TRect; bmp: TBitmap); virtual; abstract;
      procedure DrawGraphic(Canvas: TCanvas; X, Y: Integer; Graphic: TGraphic); virtual;
      procedure StretchDrawGraphic(Canvas: TCanvas; const R: TRect; Graphic: TGraphic); virtual;
      procedure PrintBitmap(Canvas: TCanvas; const R: TRect; bmp: TBitmap); virtual;
      procedure CopyRect(DestCanvas: TCanvas; const Dest: TRect;
        SourceCanvas: TCanvas; const Source: TRect); virtual;
      procedure DrawImageList(Canvas: TCanvas; ImageList: TCustomImageList; Index: Integer;
        X, Y: Integer; BlendColor: TColor); virtual; abstract;

      function GetDeviceCaps(Canvas: TCanvas; Index: Integer): Integer; virtual; abstract;
  end;

implementation

{=============================== TRVGraphicInterface ==========================}
function TRVGraphicInterface.GetFontHandle(Canvas: TCanvas): Cardinal;
begin
  Result := Canvas.Font.Handle;
end;
{------------------------------------------------------------------------------}
function TRVGraphicInterface.TextHeight(Canvas: TCanvas;
  const S: String): Integer;
var sz: TSize;
begin
  GetTextExtentPoint32_(Canvas, PChar(s), Length(s), sz);
  Result := sz.cy;
end;

function TRVGraphicInterface.TextWidth(Canvas: TCanvas;
  const S: String): Integer;
var sz: TSize;
begin
  GetTextExtentPoint32_(Canvas, PChar(s), Length(s), sz);
  Result := sz.cx;
end;
{------------------------------------------------------------------------------}
procedure TRVGraphicInterface.FillRect(Canvas: TCanvas; const R: TRect);
begin
  Canvas.FillRect(R);
end;

procedure TRVGraphicInterface.Rectangle(Canvas: TCanvas; X1, Y1, X2, Y2: Integer);
begin
  Canvas.Rectangle(X1, Y1, X2, Y2);
end;

procedure TRVGraphicInterface.Polygon(Canvas: TCanvas; const Points: array of TPoint);
begin
  Canvas.Polygon(Points);
end;

procedure TRVGraphicInterface.Ellipse(Canvas: TCanvas; X1, Y1, X2, Y2: Integer);
begin
  Canvas.Ellipse(X1, Y1, X2, Y2);
end;

procedure TRVGraphicInterface.DrawFocusRect(Canvas: TCanvas; const Rect: TRect);
begin
  Canvas.DrawFocusRect(Rect);
end;

procedure TRVGraphicInterface.Line(Canvas: TCanvas; X1, Y1, X2, Y2: Integer);
begin
  MoveTo(Canvas, X1, Y1);
  LineTo(Canvas, X2, Y2);
end;

procedure TRVGraphicInterface.LineDragDropCaret(Canvas: TCanvas; X, Y1, Y2: Integer);
var i: Integer;
begin
  for i := Y1 to Y2 do
    if i mod 2=0 then
      Line(Canvas, X, i, X+2, i);
end;
{ Draws vertical line (X,Y1) - (X, Y2).
  Line has the pattern "10101000".
  This line is used when resizing table columns. }
procedure TRVGraphicInterface.DrawTableResizeVLine(Canvas: TCanvas; X, Y1, Y2: Integer);
var
  i: Integer;
begin
  i := Y1;
  while i<Y2 do begin
    Line(Canvas, X, i, X, i+1);
    inc(i, 2);
    Line(Canvas, X, i, X, i+1);
    inc(i, 2);
    Line(Canvas, X, i, X, i+1);
    Inc(i, 4);
  end;
end;
{ Draws horizontal line (X1,Y) - (X2, Y).
  Line has the pattern "10101000".
  This line is used when resizing table rows. }
procedure TRVGraphicInterface.DrawTableResizeHLine(Canvas: TCanvas; X1, X2, Y: Integer);
var
  i: Integer;
begin
  i := X1;
  while i<X2 do begin
      Line(Canvas, i, Y, i+1,Y);
      inc(i, 2);
      Line(Canvas, i, Y, i+1,Y);
      inc(i, 2);
      Line(Canvas, i, Y, i+1,Y);
      Inc(i, 4);
    end;
end;

procedure TRVGraphicInterface.LineTo(Canvas: TCanvas; X, Y: Integer);
begin
  Canvas.LineTo(X, Y);
end;

procedure TRVGraphicInterface.MoveTo(Canvas: TCanvas; X, Y: Integer);
begin
  Canvas.MoveTo(X, Y);
end;
{------------------------------------------------------------------------------}
procedure TRVGraphicInterface.DrawGraphic(Canvas: TCanvas; X, Y: Integer;
  Graphic: TGraphic);
begin
  Canvas.Draw(X, Y, Graphic);
end;

procedure TRVGraphicInterface.StretchDrawGraphic(Canvas: TCanvas;
  const R: TRect; Graphic: TGraphic);
begin
  Canvas.StretchDraw(R, Graphic);
end;

procedure TRVGraphicInterface.PrintBitmap(Canvas: TCanvas; const R: TRect; bmp: TBitmap);
begin
  StretchDrawGraphic(Canvas, R, bmp);
end;

procedure TRVGraphicInterface.CopyRect(DestCanvas: TCanvas; const Dest: TRect;
  SourceCanvas: TCanvas; const Source: TRect);
begin
  DestCanvas.CopyRect(Dest, SourceCanvas, Source);
end;


end.
