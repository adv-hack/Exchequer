
{*******************************************************}
{                                                       }
{       RichView                                        }
{       Win32 graphic interface                         }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}


unit RVWinGrIn;

interface

{$I RV_Defs.inc}

uses Windows, Graphics, Classes, Controls, CommCtrl,
     {$IFDEF RICHVIEWDEF4}
     ImgList,
     {$ENDIF}
     RVGrIn, RVTypes;

type
  TRVWinGraphicInterface = class (TRVGraphicInterface)
    public
      procedure TextOut_A(Canvas: TCanvas; X, Y: Integer; Str: PRVAnsiChar; Length: Integer); override;
      {$IFNDEF RVDONOTUSEUNICODE}
      procedure TextOut_W(Canvas: TCanvas; X, Y: Integer; Str: PRVUnicodeChar; Length: Integer); override;
      {$ENDIF}
      procedure TextOut_(Canvas: TCanvas; X, Y: Integer; Str: PChar; Length: Integer); override;

      procedure ExtTextOut_A(Canvas: TCanvas; X, Y: Integer; Options: Longint;
        Rect: PRect; Str: PRVAnsiChar; Length: Integer; Dx: PInteger); override;
      {$IFNDEF RVDONOTUSEUNICODE}
      procedure ExtTextOut_W(Canvas: TCanvas; X, Y: Integer; Options: Longint;
        Rect: PRect; Str: PRVUnicodeChar; Length: Integer; Dx: PInteger); override;
      {$ENDIF}
      procedure ExtTextOut_(Canvas: TCanvas; X, Y: Integer; Options: Longint;
        Rect: PRect; Str: PChar; Length: Integer; Dx: PInteger); override;

      procedure DrawText(Canvas: TCanvas; Str: PChar; Length: Integer;
        var R: TRect; Alignment: TAlignment); override;

      procedure GetTextExtentPoint32_A(Canvas: TCanvas; Str: PRVAnsiChar; Length: Integer;
        var Size: TSize); override;
      {$IFNDEF RVDONOTUSEUNICODE}
      procedure GetTextExtentPoint32_W(Canvas: TCanvas; Str: PRVUnicodeChar; Length: Integer;
        var Size: TSize); override;
      {$ENDIF}
      procedure GetTextExtentPoint32_(Canvas: TCanvas; Str: PChar; Length: Integer;
        var Size: TSize); override;

      procedure GetTextExtentExPoint_A(Canvas: TCanvas; Str: PRVAnsiChar;
        Length, MaxExtent: Integer; PFit, PDX: PInteger; var Size: TSize); override;
      {$IFNDEF RVDONOTUSEUNICODE}
      procedure GetTextExtentExPoint_W(Canvas: TCanvas; Str: PRVUnicodeChar;
        Length, MaxExtent: Integer; PFit, PDX: PInteger; var Size: TSize); override;
      {$ENDIF}

      function GetCharacterPlacement_A(Canvas: TCanvas; Str: PRVAnsiChar;
        Length: Integer; var Results: TGCPResultsA;
        Ligate: Boolean): Cardinal; override;
      {$IFNDEF RVDONOTUSEUNICODE}
      // It's safe to declare Results as TGCPResultsA, because Unicode fields are not used
      function GetCharacterPlacement_W(Canvas: TCanvas; Str: PRVUnicodeChar;
        Length: Integer; var Results: TGCPResultsA;
        Ligate: Boolean): Cardinal; override;
      {$ENDIF}

      function GetOutlineTextMetrics(Canvas: TCanvas; Size: Cardinal;
        POTM: POutlineTextmetric): Cardinal; override;
      function GetTextMetrics(Canvas: TCanvas; var TM: TTextMetric): Boolean; override;
      function FontHasLigationGlyphs(Canvas: TCanvas): Boolean; override;

      procedure SetTextAlign(Canvas: TCanvas; Flags: Cardinal); override;
      function GetTextAlign(Canvas: TCanvas): Cardinal; override;

      function GetTextCharacterExtra(Canvas: TCanvas): Integer; override;
      procedure SetTextCharacterExtra(Canvas: TCanvas; CharExtra: Integer); override;

      procedure SetLogFont(Canvas: TCanvas; const LogFont: TLogFont); override;
      function SetFontHandle(Canvas: TCanvas; const FontHandle: Cardinal): Cardinal; override;

      procedure SetDiagonalBrush(Canvas: TCanvas; BackColor, ForeColor: TColor;
        XOrg, YOrg: Integer); override;

      procedure GetViewportExtEx(Canvas: TCanvas; var Size: TSize); override;
      procedure GetViewportOrgEx(Canvas: TCanvas; var Point: TPoint); override;
      procedure GetWindowExtEx(Canvas: TCanvas; var Size: TSize); override;
      procedure GetWindowOrgEx(Canvas: TCanvas; var Point: TPoint); override;
      procedure SetViewportExtEx(Canvas: TCanvas; XExt, YExt: Integer; Size: PSize); override;
      procedure SetViewportOrgEx(Canvas: TCanvas; X, Y: Integer; Point: PPoint); override;
      procedure SetWindowExtEx(Canvas: TCanvas; XExt, YExt: Integer; Size: PSize); override;
      procedure SetWindowOrgEx(Canvas: TCanvas; X, Y: Integer; Point: PPoint); override;
      function GetMapMode(Canvas: TCanvas): Integer; override;
      function SetMapMode(Canvas: TCanvas; Mode: Integer): Integer; override;

      procedure InvalidateRect(Control: TWinControl; lpRect: PRect); override;

      procedure IntersectClipRect(Canvas: TCanvas; X1, Y1, X2, Y2: Integer); override;
      procedure IntersectClipRectEx(Canvas: TCanvas; X1, Y1, X2, Y2: Integer;
        var Rgn: HRGN; var RgnValid: Boolean); override;
      procedure RestoreClipRgn(Canvas: TCanvas;
        Rgn: Cardinal; RgnValid: Boolean); override;

      function SaveCanvasState(Canvas: TCanvas): Integer; override;
      procedure RestoreCanvasState(Canvas: TCanvas; State: Integer); override;

      procedure FillColorRect(Canvas: TCanvas; const R: TRect; Color: TColor); override;
      procedure Polyline(Canvas: TCanvas; var Points; Count: Integer); override;

      procedure DrawBitmap(Canvas: TCanvas; X, Y: Integer; bmp: TBitmap); override;
      procedure StretchDrawBitmap(Canvas: TCanvas; const R: TRect; bmp: TBitmap); override;
      procedure PrintBitmap(Canvas: TCanvas; const R: TRect; bmp: TBitmap); override;
      procedure DrawImageList(Canvas: TCanvas; ImageList: TCustomImageList;
        Index: Integer; X, Y: Integer; BlendColor: TColor); override;

      function CreateScreenCanvas: TCanvas; override;
      procedure DestroyScreenCanvas(Canvas: TCanvas); override;
      function CreateCompatibleCanvas(Canvas: TCanvas): TCanvas; override;
      procedure DestroyCompatibleCanvas(Canvas: TCanvas); override;
      function CreatePrinterCanvas: TCanvas; override;

      function GetDeviceCaps(Canvas: TCanvas; Index: Integer): Integer; override;
  end;

implementation
uses RVFuncs, PtblRV;

{=============================== TRVWinGraphicInterface =======================}

procedure TRVWinGraphicInterface.TextOut_A(Canvas: TCanvas; X, Y: Integer;
  Str: PRVAnsiChar; Length: Integer);
begin
  Windows.TextOutA(Canvas.Handle, X, Y, Str, Length);
end;

{$IFNDEF RVDONOTUSEUNICODE}
procedure TRVWinGraphicInterface.TextOut_W(Canvas: TCanvas; X, Y: Integer;
  Str: PRVUnicodeChar; Length: Integer);
begin
  Windows.TextOutW(Canvas.Handle, X, Y, Str, Length);
end;
{$ENDIF}

procedure TRVWinGraphicInterface.TextOut_(Canvas: TCanvas; X, Y: Integer;
  Str: PChar; Length: Integer);
begin
  Windows.TextOut(Canvas.Handle, X, Y, Str, Length);
end;
{------------------------------------------------------------------------------}
procedure TRVWinGraphicInterface.ExtTextOut_A(Canvas: TCanvas; X, Y,
  Options: Integer; Rect: PRect; Str: PRVAnsiChar; Length: Integer;
  Dx: PInteger);
begin
  Windows.ExtTextOutA(Canvas.Handle, X, Y, Options, Rect, Str, Length, Dx);
end;
{$IFNDEF RVDONOTUSEUNICODE}
procedure TRVWinGraphicInterface.ExtTextOut_W(Canvas: TCanvas; X, Y,
  Options: Integer; Rect: PRect; Str: PRVUnicodeChar; Length: Integer;
  Dx: PInteger);
begin
  Windows.ExtTextOutW(Canvas.Handle, X, Y, Options, Rect, Str, Length, Dx);
end;
{$ENDIF}

procedure TRVWinGraphicInterface.ExtTextOut_(Canvas: TCanvas; X, Y,
  Options: Integer; Rect: PRect; Str: PChar; Length: Integer;
  Dx: PInteger);
begin
  Windows.ExtTextOut(Canvas.Handle, X, Y, Options, Rect, Str, Length, Dx);
end;
{------------------------------------------------------------------------------}
procedure TRVWinGraphicInterface.DrawText(Canvas: TCanvas; Str: PChar; Length: Integer;
  var R: TRect; Alignment: TAlignment);
var DTOption: Integer;
begin
  case Alignment of
    taRightJustify:
      DTOption := DT_RIGHT;
    taCenter:
      DTOption := DT_CENTER;
    else
      DTOption := DT_LEFT;
  end;
  Windows.DrawText(Canvas.Handle, Str, Length, R,
    DT_SINGLELINE or DT_NOCLIP or DTOption);
end;
{------------------------------------------------------------------------------}
procedure TRVWinGraphicInterface.GetTextExtentPoint32_A(Canvas: TCanvas;
  Str: PRVAnsiChar; Length: Integer; var Size: TSize);
begin
  Windows.GetTextExtentPoint32A(Canvas.Handle, Str, Length, Size);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEUNICODE}
procedure TRVWinGraphicInterface.GetTextExtentPoint32_W(Canvas: TCanvas;
  Str: PRVUnicodeChar; Length: Integer; var Size: TSize);
begin
  Windows.GetTextExtentPoint32W(Canvas.Handle, Str, Length, Size);
end;
{$ENDIF}
procedure TRVWinGraphicInterface.GetTextExtentPoint32_(Canvas: TCanvas;
  Str: PChar; Length: Integer; var Size: TSize);
begin
  Windows.GetTextExtentPoint32(Canvas.Handle, Str, Length, Size);
end;
{------------------------------------------------------------------------------}
procedure TRVWinGraphicInterface.GetTextExtentExPoint_A(Canvas: TCanvas;
  Str: PRVAnsiChar; Length, MaxExtent: Integer; PFit, PDX: PInteger;
  var Size: TSize);
begin
  Windows.GetTextExtentExPointA(Canvas.Handle, Str, Length, MaxExtent,
    {$IFDEF RICHVIEWDEF4}PFit, PDx,{$ELSE}PFit^, PInteger(PDx)^,{$ENDIF}
    Size);
end;

{$IFNDEF RVDONOTUSEUNICODE}
procedure TRVWinGraphicInterface.GetTextExtentExPoint_W(Canvas: TCanvas;
  Str: PRVUnicodeChar; Length, MaxExtent: Integer; PFit, PDX: PInteger;
  var Size: TSize);
begin
  Windows.GetTextExtentExPointW(Canvas.Handle, Str, Length, MaxExtent,
    {$IFDEF RICHVIEWDEF4}PFit, PDx,{$ELSE}PFit^, PInteger(PDx)^,{$ENDIF}
    Size);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
const
  GETCHARACTERPLACEMENTFLAGS = {GCP_USEKERNING or }GCP_REORDER or GCP_GLYPHSHAPE or GCP_DIACRITIC;
{
  Delphi declares these functions incorrectly, so we redefine them here
}
function GetCharacterPlacementA(DC: HDC; p2: PRVAnsiChar; p3, p4: Integer;
  var p5: TGCPResultsA; p6: Cardinal): Cardinal; stdcall;
  external gdi32 name 'GetCharacterPlacementA';
// It's safe to declare p5 as TGCPResultsA, because Unicode fields are not used
function GetCharacterPlacementW(DC: HDC; p2: PRVUnicodeChar; p3, p4: Integer;
  var p5: TGCPResultsA; p6: Cardinal): Cardinal; stdcall;
  external gdi32 name 'GetCharacterPlacementW';

function TRVWinGraphicInterface.GetCharacterPlacement_A(Canvas: TCanvas;
  Str: PRVAnsiChar; Length: Integer; var Results: TGCPResultsA;
  Ligate: Boolean): Cardinal;
var Flags: Cardinal;
begin
  Flags := GETCHARACTERPLACEMENTFLAGS;
  if Ligate then
    Flags := Flags or GCP_LIGATE;
  Result := RVWinGrIn.GetCharacterPlacementA(Canvas.Handle, Str,
    Length, 0, Results, Flags);
end;
{$IFNDEF RVDONOTUSEUNICODE}
function TRVWinGraphicInterface.GetCharacterPlacement_W(Canvas: TCanvas;
  Str: PRVUnicodeChar; Length: Integer;
  var Results: TGCPResultsA; Ligate: Boolean): Cardinal;
var Flags: Cardinal;
begin
  Flags := GETCHARACTERPLACEMENTFLAGS;
  if Ligate then
    Flags := Flags or GCP_LIGATE;
  Result := RVWinGrIn.GetCharacterPlacementW(Canvas.Handle, Str,
    Length, 0, Results, Flags);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRVWinGraphicInterface.GetOutlineTextMetrics(Canvas: TCanvas; Size: Cardinal;
  POTM: POutlineTextmetric): Cardinal;
begin
  Result := Windows.GetOutlineTextMetrics(Canvas.Handle, Size, POTM);
end;
{------------------------------------------------------------------------------}
function TRVWinGraphicInterface.GetTextMetrics(Canvas: TCanvas; var TM: TTextMetric): Boolean;
begin
  FillChar(TM, sizeof(TM), 0);
  Result := Windows.GetTextMetrics(Canvas.Handle, TM);
end;

function TRVWinGraphicInterface.FontHasLigationGlyphs(Canvas: TCanvas): Boolean;
begin
  Result := (GetFontLanguageInfo(Canvas.Handle) and GCP_LIGATE)<>0;
end;
{------------------------------------------------------------------------------}
function TRVWinGraphicInterface.GetTextAlign(Canvas: TCanvas): Cardinal;
begin
  Result := Windows.GetTextAlign(Canvas.Handle);
end;

procedure TRVWinGraphicInterface.SetTextAlign(Canvas: TCanvas; Flags: Cardinal);
begin
  Windows.SetTextAlign(Canvas.Handle, Flags);
end;
{------------------------------------------------------------------------------}
function TRVWinGraphicInterface.GetTextCharacterExtra(
  Canvas: TCanvas): Integer;
begin
  Result := Windows.GetTextCharacterExtra(Canvas.Handle);
end;

procedure TRVWinGraphicInterface.SetTextCharacterExtra(Canvas: TCanvas; CharExtra: Integer);
begin
  Windows.SetTextCharacterExtra(Canvas.Handle, CharExtra);
end;
{------------------------------------------------------------------------------}
procedure TRVWinGraphicInterface.SetLogFont(Canvas: TCanvas;
  const LogFont: TLogFont);
begin
  Canvas.Font.Handle := CreateFontIndirect(LogFont);
end;
{------------------------------------------------------------------------------}
function TRVWinGraphicInterface.SetFontHandle(Canvas: TCanvas; const FontHandle: Cardinal): Cardinal;
begin
  Result := SelectObject(Canvas.Handle, FontHandle);
end;
{------------------------------------------------------------------------------}
procedure TRVWinGraphicInterface.SetDiagonalBrush(Canvas: TCanvas;
  BackColor, ForeColor: TColor; XOrg, YOrg: Integer);
{$IFNDEF RICHVIEWCBDEF3}
var pt: TPoint;
{$ENDIF}
begin
  SetBkColor(Canvas.Handle, ColorToRGB(BackColor));
  Canvas.Brush.Style := bsFDiagonal;
  Canvas.Brush.Color := ForeColor;
  SetBrushOrgEx(Canvas.Handle, XOrg, YOrg,
    {$IFNDEF RICHVIEWCBDEF3}pt{$ELSE}nil{$ENDIF});
  SetBkMode(Canvas.Handle, OPAQUE);
  SetBkColor(Canvas.Handle, ColorToRGB(BackColor));
end;
{------------------------------------------------------------------------------}
procedure TRVWinGraphicInterface.GetViewportExtEx(Canvas: TCanvas;
  var Size: TSize);
begin
  Windows.GetViewportExtEx(Canvas.Handle, Size);
end;

procedure TRVWinGraphicInterface.GetViewportOrgEx(Canvas: TCanvas;
  var Point: TPoint);
begin
  Windows.GetViewportOrgEx(Canvas.Handle, Point);
end;

procedure TRVWinGraphicInterface.GetWindowExtEx(Canvas: TCanvas;
  var Size: TSize);
begin
  Windows.GetWindowExtEx(Canvas.Handle, Size);
end;

procedure TRVWinGraphicInterface.GetWindowOrgEx(Canvas: TCanvas;
  var Point: TPoint);
begin
  Windows.GetWindowOrgEx(Canvas.Handle, Point);
end;

procedure TRVWinGraphicInterface.SetViewportExtEx(Canvas: TCanvas; XExt,
  YExt: Integer; Size: PSize);
begin
  Windows.SetViewportExtEx(Canvas.Handle, XExt, YExt, Size);
end;

procedure TRVWinGraphicInterface.SetViewportOrgEx(Canvas: TCanvas; X,
  Y: Integer; Point: PPoint);
begin
  Windows.SetViewportOrgEx(Canvas.Handle, X, Y, Point);
end;

procedure TRVWinGraphicInterface.SetWindowExtEx(Canvas: TCanvas; XExt,
  YExt: Integer; Size: PSize);
begin
  Windows.SetWindowExtEx(Canvas.Handle, XExt, YExt, Size);
end;

procedure TRVWinGraphicInterface.SetWindowOrgEx(Canvas: TCanvas; X,
  Y: Integer; Point: PPoint);
begin
  Windows.SetWindowOrgEx(Canvas.Handle, X, Y, Point);
end;
{------------------------------------------------------------------------------}
function TRVWinGraphicInterface.GetMapMode(Canvas: TCanvas): Integer;
begin
  Result := Windows.GetMapMode(Canvas.Handle);
end;

function TRVWinGraphicInterface.SetMapMode(Canvas: TCanvas; Mode: Integer): Integer;
begin
  Result := Windows.SetMapMode(Canvas.Handle, Mode);
end;
{------------------------------------------------------------------------------}
procedure TRVWinGraphicInterface.InvalidateRect(Control: TWinControl;
  lpRect: PRect);
begin
  Windows.InvalidateRect(Control.Handle, lpRect, False)
end;
{------------------------------------------------------------------------------}
procedure TRVWinGraphicInterface.RestoreCanvasState(Canvas: TCanvas;
  State: Integer);
begin
  Windows.RestoreDC(Canvas.Handle, State);
end;

function TRVWinGraphicInterface.SaveCanvasState(Canvas: TCanvas): Integer;
begin
  Result := Windows.SaveDC(Canvas.Handle);
end;
{------------------------------------------------------------------------------}
procedure TRVWinGraphicInterface.IntersectClipRect(Canvas: TCanvas; X1, Y1,
  X2, Y2: Integer);
begin
  Windows.IntersectClipRect(Canvas.Handle, X1, Y1, X2, Y2);
end;

procedure TRVWinGraphicInterface.IntersectClipRectEx(Canvas: TCanvas;
  X1, Y1, X2, Y2: Integer; var Rgn: HRGN; var RgnValid: Boolean);
begin
  rgn := CreateRectRgn(0,0,1,1);
  RgnValid := GetClipRgn(Canvas.Handle, rgn)=1;
  Windows.IntersectClipRect(Canvas.Handle, X1, Y1, X2, Y2);
end;

procedure TRVWinGraphicInterface.RestoreClipRgn(Canvas: TCanvas;
  Rgn: Cardinal; RgnValid: Boolean);
begin
  if RgnValid then
    Windows.SelectClipRgn(Canvas.Handle, rgn)
  else
    Windows.SelectClipRgn(Canvas.Handle, 0);
  DeleteObject(rgn);
end;
{------------------------------------------------------------------------------}
procedure TRVWinGraphicInterface.FillColorRect(Canvas: TCanvas;
  const R: TRect; Color: TColor);
var hbr: HBRUSH;
begin
  hbr := CreateSolidBrush(ColorToRGB(Color));
  Windows.FillRect(Canvas.Handle, R, hbr);
  DeleteObject(hbr);
end;
{------------------------------------------------------------------------------}
procedure TRVWinGraphicInterface.Polyline(Canvas: TCanvas; var Points; Count: Integer);
begin
  Windows.Polyline(Canvas.Handle, Points, Count);
end;
{------------------------------------------------------------------------------}
procedure TRVWinGraphicInterface.DrawBitmap(Canvas: TCanvas; X, Y: Integer;
  bmp: TBitmap);
begin
  BitBlt(Canvas.Handle, X, Y, bmp.Width, bmp.Height, bmp.Canvas.Handle, 0, 0, SRCCOPY);
end;

procedure TRVWinGraphicInterface.StretchDrawBitmap(Canvas: TCanvas; const R: TRect;
  bmp: TBitmap);
begin
  StretchBlt(Canvas.Handle, R.Left, R.Top, R.Right-R.Left, R.Bottom-R.Top,
    bmp.Canvas.Handle, 0, 0, bmp.Width, bmp.Height, SRCCOPY);
end;

procedure TRVWinGraphicInterface.PrintBitmap(Canvas: TCanvas;
  const R: TRect; bmp: TBitmap);
begin
   if not RichViewAlternativePicPrint then
     RV_BltTBitmapAsDib(Canvas.Handle, R.Left, R.Top, R.Right-R.Left, R.Bottom-R.Top, bmp)
   else
     RV_PictureToDeviceAlt(Canvas, R.Left, R.Top, R.Right-R.Left, R.Bottom-R.Top, bmp);
end;

procedure TRVWinGraphicInterface.DrawImageList(Canvas: TCanvas;
  ImageList: TCustomImageList; Index, X, Y: Integer; BlendColor: TColor);
var BlendColorRef: TColorRef;
    ILDrawOptions: Integer;
begin
  if BlendColor<>clNone then begin
    BlendColorRef := ColorToRGB(BlendColor);
    ILDrawOptions := ILD_TRANSPARENT or ILD_SELECTED;
    end
  else begin
    BlendColorRef := CLR_NONE;
    ILDrawOptions := ILD_TRANSPARENT;
  end;
  ImageList_DrawEx(ImageList.Handle, Index, Canvas.Handle, X, Y,
    TImageList(ImageList).Width, TImageList(ImageList).Height,
    CLR_NONE, BlendColorRef, ILDrawOptions);

end;
{------------------------------------------------------------------------------}
function TRVWinGraphicInterface.CreateScreenCanvas: TCanvas;
begin
  Result := TCanvas.Create;
  Result.Handle := GetDC(0);
end;

procedure TRVWinGraphicInterface.DestroyScreenCanvas(Canvas: TCanvas);
var DC: HDC;
begin
  DC := Canvas.Handle;
  Canvas.Handle := 0;
  Canvas.Free;
  ReleaseDC(0, DC)
end;

function TRVWinGraphicInterface.CreateCompatibleCanvas(Canvas: TCanvas): TCanvas;
var iMode: Integer;
    XForm: TXForm;
begin
  Result := TCanvas.Create;
  Result.Handle := CreateCompatibleDC(Canvas.Handle);
  iMode := GetGraphicsMode(Canvas.Handle);
  SetGraphicsMode(Result.Handle, iMode);
  if iMode = GM_ADVANCED then begin
    if GetWorldTransform(Canvas.Handle, XForm) then
      SetWorldTransform(Result.Handle, XForm);
  end;
  Result.Font.PixelsPerInch := Canvas.Font.PixelsPerInch;
end;

procedure TRVWinGraphicInterface.DestroyCompatibleCanvas(Canvas: TCanvas);
var DC: HDC;
begin
  DC := Canvas.Handle;
  Canvas.Handle := 0;
  Canvas.Free;
  DeleteDC(DC);
end;

function TRVWinGraphicInterface.CreatePrinterCanvas: TCanvas;
var DC: HDC;
begin
  DC := RV_GetPrinterDC;
  if DC=0 then
    Result := nil
  else begin
    Result := TCanvas.Create;
    Result.Handle := DC;
  end;
end;
{------------------------------------------------------------------------------}
function TRVWinGraphicInterface.GetDeviceCaps(Canvas: TCanvas;
  Index: Integer): Integer;
begin
  Result := Windows.GetDeviceCaps(Canvas.Handle, Index);
end;

end.
