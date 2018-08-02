{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPCanvas;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, RPDefine, RPBase, RPDevice, RPRPTF;

type
{*************************************************************************}
{                            class TCanvasReport                          }
{*************************************************************************}

  TCanvasReport = class(TBaseReport)
  protected
    procedure PrintAlign(Text: string;
                         Pos: double;
                         Flags: integer);
    procedure PrintRightWidth(Text: string;
                              Width: double);

  { Abstract Output Methods - protected }
    procedure PrintCenterInch(Text: string;
                              Pos: double); override;
    procedure PrintLeftInch(Text: string;
                            Pos: double); override;
    procedure PrintRightInch(Text: string;
                             Pos: double); override;
    procedure PrintBlockInch(Text: string;
                             Pos: double;
                             Width: double); override;
  public
  { Output Methods - override as public }
    procedure Arc(X1,Y1,X2,Y2,X3,Y3,X4,Y4: double); override;
    procedure BrushCopy(const Dest: TRect;
                              Bitmap: TBitmap;
                        const Source: TRect;
                              Color: TColor); override;
    procedure Chord(X1,Y1,X2,Y2,X3,Y3,X4,Y4: double); override;
    procedure CopyRect(const Dest: TRect;
                             Canvas: TCanvas;
                       const Source: TRect); override;
    procedure Draw(X,Y: double;
                    Graphic: TGraphic); override;
    procedure DrawFocusRect(const Rect: TRect); override;
    procedure Ellipse(X1,Y1,X2,Y2: double); override;
    procedure FillRect(const Rect: TRect); override;
    procedure FloodFill(X,Y: double;
                        Color: TColor;
                        FillStyle: TFillStyle); override;
    procedure FrameRect(const Rect: TRect); override;
    procedure LineTo(X,Y: double); override;
    procedure MoveTo(X,Y: double); override;
    procedure Pie(X1,Y1,X2,Y2,X3,Y3,X4,Y4: double); override;
    procedure Polygon(const Points: array of TPoint); override;
    procedure Polyline(const Points: array of TPoint); override;
    procedure PrintBitmap(X,Y: double;
                          ScaleX,ScaleY: double;
                          Bitmap: TBitmap); override;
    procedure PrintBitmapRect(X1,Y1,X2,Y2: double;
                              Bitmap: TBitmap); override;
    procedure PrintImageRect(X1,Y1,X2,Y2: double;
                             ImageStream: TStream;
                             ImageType: string); override;
    procedure Rectangle(X1,Y1,X2,Y2: double); override;
    procedure RoundRect(X1,Y1,X2,Y2,X3,Y3: double); override;
    procedure StretchDraw(const Rect: TRect;
                                Graphic: TGraphic); override;
    procedure TabRectangle(X1,Y1,X2,Y2: double); override;
    procedure TextRect(      Rect: TRect;
                             X,Y: double;
                       const Text: string); override;
    procedure PrintData(Value: string); override;
    procedure PrintDataStream(Stream: TStream;
                              BufSize: longint); override;
    procedure NewPage; override;

    { User Defined }
    procedure ExtTextRect(      Rect : TRect;
                                Just : Byte;
                          const Text : string); override;
    procedure TextRect2(      Rect: TRect;
                              X,Y: double;
                              Just: Byte;
                        const Text: string); override;
    procedure PrintBitmapRect2(X1,Y1,X2,Y2: double;
                              Bitmap: TBitmap); override;
    // RPDD - HM 27/11/02: Added Drill-Down support
    procedure DrillDownArea (Const X1, Y1, X2, Y2 : Double;
                             Const LevelNo        : Byte;
                             Const DDS1           : ShortString;
                             Const DDI1, DDI2     : SmallInt;
                             Const DDB1           : Byte); override;
  end; { TCanvasReport }

implementation

{ Misc functions }

function GetFirstWord(var Line: string): string;

var
  I1: integer;
  Found: boolean;
  SpacePos: integer;

begin { GetFirstWord }
{ Find first space after first non-space }
  SpacePos := 0;
  Found := false;
  For I1 := 1 to Length(Line) do begin
    If Found then begin
      If Line[I1] = ' ' then begin
        SpacePos := I1;
        Break;
      end; { if }
    end else begin
      Found := Line[I1] <> ' ';
    end; { else }
  end; { for }

  If SpacePos = 0 then begin
    Result := Line; { Use Line as a whole word }
    Line := '';
  end else begin
    Result := Copy(Line,1,SpacePos - 1); { Get first word }
    Delete(Line,1,SpacePos - 1); { Delete first word from Line }
  end; { else }
end;  { GetFirstWord }

function GetSpaces(var Line: string): string;

var
  I1: integer;

begin { GetSpaces }
  Result := '';
  For I1 := 1 to Length(Line) do begin
    If Line[I1] <> ' ' then begin
      Delete(Line,1,I1 - 1);
      Exit;
    end; { if }
    Result := Result + ' ';
  end; { for }
  Line := '';
end;  { GetSpaces }

function CountSpaces(Text: string): integer;

var
  I1: integer;
  Before: boolean;
  BeforeSpaces: integer;
  Spaces: integer;
  AfterSpaces: integer;

begin { CountSpaces }
{ Count the number of spaces in Text between first and last word }
  Before := true;
  BeforeSpaces := 0;
  Spaces := 0;
  AfterSpaces := 0;
  For I1 := 1 to Length(Text) do begin
    If Text[I1] = ' ' then begin
      If Before then begin
        Inc(BeforeSpaces);
      end; { if }
      Inc(Spaces);
      Inc(AfterSpaces);
    end else begin
      Before := false;
      AfterSpaces := 0;
    end; { else }
  end; { for }
  Result := Spaces - (BeforeSpaces + AfterSpaces);
end;  { CountSpaces }

{*************************************************************************}
{                            class TCanvasReport                          }
{*************************************************************************}

{ Output routines }
procedure TCanvasReport.PrintAlign(Text: string;
                                   Pos: double;
                                   Flags: integer);

var
  BkMode: integer;
  Y1: longint;
  OutFlags: integer;
  Format: longint;
  Rect: TRect;

begin { PrintAlign }
  BKMode := SetBkMode(Canvas.Handle,Ord(FTextBKMode) + 1);
  SelectRPFont;

  OutFlags := Flags or TA_NOUPDATECP;
  Format := DT_LEFT or DT_TOP or DT_SINGLELINE or DT_NOCLIP or DT_NOPREFIX;
  If BaseFont.Superscript then begin
    OutFlags := OutFlags or TA_TOP;
    Y1 := YI2D(YU2I((FontTop + LineTop) / 2.0));
  end else if BaseFont.Subscript then begin
    OutFlags := OutFlags or TA_BOTTOM;
    Y1 := YU2D(FontBottom) + 1;
  end else begin
    Case BaseFont.Align of
      faTop: begin
        OutFlags := OutFlags or TA_TOP;
        Y1 := YI2D(YU2I(FontTop) - BaseFont.InternalLeading);
      end;
      faBaseline: begin
        OutFlags := OutFlags or TA_BASELINE;
        Y1 := YU2D(FontBaseline) + 1;
      end;
      else begin { faBottom }
        OutFlags := OutFlags or TA_BOTTOM;
        Y1 := YU2D(FontBottom) + 1;
      end;
    end; { case }
  end; { else }

  SetTextAlign(Canvas.Handle,OutFlags);
  If Text <> '' then begin
    If UseDrawText then begin
      Rect.Left := XI2D(Pos);
      Rect.Top := Y1;
      Rect.Right := Rect.Left + 10000;
      Rect.Bottom := Rect.Top + 10000;
      WinProcs.DrawText(Canvas.Handle,@Text[1],Length(Text),Rect,Format);
    end else begin
      WinProcs.TextOut(Canvas.Handle,XI2D(Pos),Y1,@Text[1],Length(Text));
    end; { else }
  end; { if }
  SelectCanvasFont;
  SetBkMode(Canvas.Handle,BkMode);

  Case Flags of
    TA_LEFT: begin
      FCursorXPos := Pos;
      AdjustXY(TextWidth(Text));
    end;
    TA_CENTER: begin
      FCursorXPos := Pos;
      AdjustXY(TextWidth(Text) / 2.0);
    end;
    TA_RIGHT: begin
      FCursorXPos := Pos;
    end;
  end; { case }
end;  { PrintAlign }

procedure TCanvasReport.PrintCenterInch(Text: string;
                                        Pos: double);

begin { PrintCenterInch }
  CheckPrinting;
  If OutputInvalid then Exit;

  If IgnoreRPTF or (System.Pos(RPTFPrefix,Text) = 0) then begin
    PrintAlign(Text,Pos,TA_CENTER);
  end else begin
    PrintLeftInch(Text,Pos - (RPTFTextWidth(Self,Text) / ((FZoom / 100.0) * XDPI * 2.0)));
  end; { else }
end;  { PrintCenterInch }

procedure TCanvasReport.PrintLeftInch(Text: string;
                                      Pos: double);

var
  I1: longint;
  S1: string;

begin { PrintLeftInch }
  CheckPrinting;
  If OutputInvalid then Exit;

  If IgnoreRPTF or (System.Pos(RPTFPrefix,Text) = 0) then begin
    PrintAlign(Text,Pos,TA_LEFT);
  end else begin
    I1 := 1;
    While I1 <= Length(Text) do begin
      S1 := NextPiece(Self,Text,I1);
      PrintAlign(S1,Pos,TA_LEFT);
      Pos := Pos + XU2I(TextWidth(S1)) * (100.0 / FZoom);
    end; { while }
  end; { else }
end;  { PrintLeftInch }

procedure TCanvasReport.PrintRightInch(Text: string;
                                       Pos: double);

begin { PrintRightInch }
  CheckPrinting;
  If OutputInvalid then Exit;

  If IgnoreRPTF or (System.Pos(RPTFPrefix,Text) = 0) then begin
    PrintAlign(Text,Pos,TA_RIGHT);
  end else begin
    PrintLeftInch(Text,Pos - (RPTFTextWidth(Self,Text) / XDPI) * (100.0 / FZoom));
  end; { else }
end;  { PrintRightInch }

procedure TCanvasReport.PrintRightWidth(Text: string; Width: double);
var
  LTextWidth: double;
  Spaces: integer;
  SpaceStr: string;
  SpaceWidth: double;
begin { PrintRightWidth }
{ Print a block of spaces to fill the front space width }
  PushPos;
  SpaceWidth := Width - TextWidth(Text);
  LTextWidth := TextWidth(' ');
  Spaces := 0;
  if LTextWidth > 0 then begin
    Spaces := Trunc(SpaceWidth / LTextWidth);
  end;
  If Spaces > 0 then begin
    SetLength(SpaceStr,Spaces);
    Spaces := Length(SpaceStr);
    FillChar(SpaceStr[1],Spaces,' ');
    PushPos;
    PrintAlign(SpaceStr,FCursorXPos,TA_LEFT);
    PopPos;
  end; { if }
  AdjustXY(SpaceWidth);
  PrintAlign(' ',FCursorXPos,TA_RIGHT);
  PopPos;

{ Print Text right aligned }
  AdjustXY(Width);
  PrintAlign(Text,FCursorXPos,TA_RIGHT);
end;  { PrintRightWidth }

procedure TCanvasReport.PrintBlockInch(Text: string;
                                       Pos: double;
                                       Width: double);

var
  CurrWord: string;
  Spaces: integer;
  SpaceWidth: double;
  I1: integer;

begin { PrintBlockInch }
  CheckPrinting;
  If OutputInvalid then Exit;

{ Count the number of spaces in Text }
  Spaces := CountSpaces(Text);
  If Spaces = 0 then begin { Process each letter as a word }
  { Insert spaces in between each letter pair }
    I1 := 2;
    While I1 <= Length(Text) do begin
      If (Text[I1 - 1] <> ' ') and (Text[I1] <> ' ') then begin { Insert Space }
        Insert(' ',Text,I1);
        Inc(Spaces);
        Inc(I1);
      end; { if }
      Inc(I1);
    end; { while }
  end; { if }
  If Spaces = 0 then begin
    Spaces := 1;
  end; { if }

{ Figure out the width for each internal space }
  SpaceWidth := TextWidth(' ') + ((((XI2U(Width) * FScaleX * FZoom) / 10000.0) -
   TextWidth(Text)) / Spaces);

{ Print first word left aligned, middle and last words right aligned }
  CurrWord := GetFirstWord(Text);
  PrintAlign(CurrWord,Pos,TA_LEFT);
  While Text <> '' do begin
    Spaces := Length(GetSpaces(Text));
    CurrWord := GetFirstWord(Text);
    PrintRightWidth(CurrWord,TextWidth(CurrWord) + (Spaces * SpaceWidth));
  end; { while }
end;  { PrintBlockInch }

procedure TCanvasReport.PrintData(Value: string);

begin { PrintData }
  CheckPrinting;
  If OutputInvalid or (Value = '') then Exit;

  LocalDevice.RawOut(Value[1],Length(Value));
end;  { PrintData }

procedure TCanvasReport.PrintDataStream(Stream: TStream;
                                        BufSize: longint);

const
  BufMax = 4096;

type
  PBuffer = ^TBuffer;
  TBuffer = record
    Size: word;
    Data: array[1..BufMax] of byte;
  end; { TBuffer }

var
  Buffer: PBuffer;
  I1: integer;
  I2: integer;

begin { PrintDataStream }
  CheckPrinting;
  If OutputInvalid then Exit;
  If BufSize = 0 then begin
    BufSize := Stream.Size - Stream.Position;
  end; { if }
  New(Buffer);
  try
    I2 := (BufSize div BufMax) + 1;
    For I1 := 1 to I2 do begin
    { Figure out size of this chunk }
      If I1 = I2 then begin { Last piece }
        Buffer^.Size := BufSize mod BufMax;
      end else begin { BufMax sized chunk }
        Buffer^.Size := BufMax;
      end; { else }

      If Buffer^.Size > 0 then begin
      { Move data from stream to buffer and pass to Escape }
        Stream.ReadBuffer(Buffer^.Data,Buffer^.Size);
        LocalDevice.RawOut(Buffer^.Data,Buffer^.Size);
      end; { if }
    end; { for }
  finally
    Dispose(Buffer);
  end; { tryf }
end;  { PrintDataStream }

procedure TCanvasReport.Arc(X1,Y1,X2,Y2,X3,Y3,X4,Y4: double);

begin { Arc }
  CheckPrinting;
  If OutputInvalid then Exit;

  Canvas.Arc(XU2D(X1),YU2D(Y1),XU2D(X2),YU2D(Y2),XU2D(X3),YU2D(Y3),XU2D(X4),
   YU2D(Y4));
end;  { Arc }

procedure TCanvasReport.BrushCopy(const Dest: TRect;
                                        Bitmap: TBitmap;
                                  const Source: TRect;
                                        Color: TColor);

begin { BrushCopy }
  CheckPrinting;
  If OutputInvalid then Exit;

  Canvas.BrushCopy(Dest,BitMap,Source,Color);
end;  { BrushCopy }

procedure TCanvasReport.Chord(X1,Y1,X2,Y2,X3,Y3,X4,Y4: double);

begin { Chord }
  CheckPrinting;
  If OutputInvalid then Exit;

  Canvas.Chord(XU2D(X1),YU2D(Y1),XU2D(X2),YU2D(Y2),XU2D(X3),YU2D(Y3),XU2D(X4),
   YU2D(Y4));
end;  { Chord }

procedure TCanvasReport.CopyRect(const Dest: TRect;
                                       Canvas: TCanvas;
                                 const Source: TRect);

begin { CopyRect }
  CheckPrinting;
  If OutputInvalid then Exit;

  Canvas.CopyRect(Dest,Canvas,Source);
end;  { CopyRect }

procedure TCanvasReport.Draw(X,Y: double;
                             Graphic: TGraphic);

begin { Draw }
  CheckPrinting;
  If OutputInvalid then Exit;

  Canvas.Draw(XU2D(X),YU2D(Y),Graphic);
end;  { Draw }

procedure TCanvasReport.DrawFocusRect(const Rect: TRect);

begin { DrawFocusRect }
  CheckPrinting;
  If OutputInvalid then Exit;

  Canvas.DrawFocusRect(Rect);
end;  { DrawFocusRect }

procedure TCanvasReport.Ellipse(X1,Y1,X2,Y2: double);

var
  F1: double;
  PA,PA2: integer;

begin { Ellipse }
  CheckPrinting;
  If OutputInvalid then Exit;

  If X1 > X2 then begin
    F1 := X1;
    X1 := X2;
    X2 := F1;
  end; { if }
  If Y1 > Y2 then begin
    F1 := Y1;
    Y1 := Y2;
    Y2 := F1;
  end; { if }
  If Canvas.Pen.Style = psClear then begin
    PA := 0;
    PA2 := 0;
  end else if (Canvas.Pen.Style = psInsideFrame) or (FrameMode = fmSplit) then begin
    PA := 0;
    PA2 := 1;
  end else if (FrameMode = fmInside) then begin
    PA := Canvas.Pen.Width div 2;
    PA2 := Canvas.Pen.Width - PA;
  end else begin { FrameMode = fmOutside }
    PA := -Canvas.Pen.Width div 2;
    PA2 := PA - Canvas.Pen.Width;
  end; { else }
  Canvas.Ellipse(XU2D(X1) + PA,YU2D(Y1) + PA,XU2D(X2) - PA2 + 2,YU2D(Y2) - PA2 + 2);
end;  { Ellipse }

procedure TCanvasReport.FillRect(const Rect: TRect);

begin { FillRect }
  CheckPrinting;
  If OutputInvalid then Exit;

  Canvas.FillRect(Rect);
end;  { FillRect }

procedure TCanvasReport.FloodFill(X,Y: double;
                                  Color: TColor;
                                  FillStyle: TFillStyle);

begin { FloodFill }
  CheckPrinting;
  If OutputInvalid then Exit;

  Canvas.FloodFill(XU2D(X),YU2D(Y),Color,FillStyle);
end;  { FloodFill }

procedure TCanvasReport.FrameRect(const Rect: TRect);

begin { FrameRect }
  CheckPrinting;
  If OutputInvalid then Exit;

  Canvas.FrameRect(Rect);
end;  { FrameRect }

procedure TCanvasReport.LineTo(X,Y: double);

var
  SaveX, SaveY: double;

begin { LineTo }
  CheckPrinting;
  If OutputInvalid then Exit;

  SaveX := LastLineX;
  SaveY := LastLineY;
  If NoBufferLine then begin
    Canvas.LineTo(XU2D(X),YU2D(Y));
  end else if not BufferLine(X,Y) then begin
    Canvas.MoveTo(XU2D(SaveX - OriginX),YU2D(SaveY - OriginY));
    Canvas.LineTo(XU2D(X),YU2D(Y));
  end; { else }
end;  { LineTo }

procedure TCanvasReport.MoveTo(X,Y: double);

begin { MoveTo }
  CheckPrinting;
  If OutputInvalid then Exit;

  If NoBufferLine then begin
    Canvas.MoveTo(XU2D(X),YU2D(Y));
  end; { if }
  LastLineX := X + OriginX;
  LastLineY := Y + OriginY;
end;  { MoveTo }

procedure TCanvasReport.Pie(X1,Y1,X2,Y2,X3,Y3,X4,Y4: double);

begin { Pie }
  CheckPrinting;
  If OutputInvalid then Exit;

  Canvas.Pie(XU2D(X1),YU2D(Y1),XU2D(X2),YU2D(Y2),XU2D(X3),YU2D(Y3),XU2D(X4),
   YU2D(Y4));
end;  { Pie }

procedure TCanvasReport.Polygon(const Points: array of TPoint);

begin { Polygon }
  CheckPrinting;
  If OutputInvalid then Exit;

  Canvas.Polygon(Points);
end;  { Polygon }

procedure TCanvasReport.Polyline(const Points: array of TPoint);

begin { Polyline }
  CheckPrinting;
  If OutputInvalid then Exit;

  Canvas.Polyline(Points);
end;  { Polyline }

procedure TCanvasReport.PrintBitmap(X,Y: double;
                                    ScaleX,ScaleY: double;
                                    Bitmap: TBitmap);

var
  Info: PBitmapInfo;
  InfoSize: DWORD;
  ImageSize: DWORD;
  Image: pointer;
  ImageHandle: THandle;
  DrawMode: longint;

begin { PrintBitmap }
  CheckPrinting;
  If OutputInvalid then Exit;

  With Bitmap do begin
    GetDIBSizes(Handle,InfoSize,ImageSize);
    GetMem(Info,InfoSize);
    try
      If ImageSize < 65535 then begin
        GetMem(Image,ImageSize);
        ImageHandle := 0;
      end else begin
        ImageHandle := GlobalAlloc(GMEM_MOVEABLE,ImageSize);
        Image := GlobalLock(ImageHandle);
      end; { else }
      try
        GetDIB(Handle,Palette,Info^,Image^);
        With Info^.bmiHeader do begin
          If FTransparentBitmaps then begin
            DrawMode := SRCAND;
          end else begin
            DrawMode := SRCCOPY;
          end; { else }
          StretchDIBits(self.Canvas.Handle,XU2D(X),YU2D(Y),
           Round(Width * ScaleX),Round(Height * ScaleY),
           0,0,biWidth,biHeight,Image,Info^,DIB_RGB_COLORS,DrawMode);
        end; { with }
      finally
        If ImageSize < 65535 then begin
          FreeMem(Image,ImageSize);
        end else begin
          GlobalUnlock(ImageHandle);
          GlobalFree(ImageHandle);
        end; { else }
      end; { try }
    finally
      FreeMem(Info,InfoSize);
    end; { try }
  end; { with }
end;  { PrintBitmap }

procedure TCanvasReport.PrintBitmapRect(X1,Y1,X2,Y2: double;
                                        Bitmap: TBitmap);

var
  Info: PBitmapInfo;
  InfoSize: DWORD;
  ImageSize: DWORD;
  Image: pointer;
  ImageHandle: THandle;
  DrawMode: longint;

begin { PrintBitmapRect }
  CheckPrinting;
  If OutputInvalid then Exit;

  With Bitmap do begin
    GetDIBSizes(Handle,InfoSize,ImageSize);
    GetMem(Info,InfoSize);
    try
      If ImageSize < 65535 then begin
        GetMem(Image,ImageSize);
        ImageHandle := 0;
      end else begin
        ImageHandle := GlobalAlloc(GMEM_MOVEABLE,ImageSize);
        Image := GlobalLock(ImageHandle);
      end; { else }
      try
        GetDIB(Handle,Palette,Info^,Image^);
        With Info^.bmiHeader do begin
          If FTransparentBitmaps then begin
            DrawMode := SRCAND;
          end else begin
            DrawMode := SRCCOPY;
          end; { else }
          StretchDIBits(self.Canvas.Handle,XU2D(X1),YU2D(Y1),
           XU2D(X2) - XU2D(X1),YU2D(Y2) - YU2D(Y1),0,0,
           biWidth,biHeight,Image,Info^,DIB_RGB_COLORS,DrawMode);
        end; { with }
      finally
        If ImageSize < 65535 then begin
          FreeMem(Image,ImageSize);
        end else begin
          GlobalUnlock(ImageHandle);
          GlobalFree(ImageHandle);
        end; { else }
      end; { try }
    finally
      FreeMem(Info,InfoSize);
    end; { try }
  end; { with }
end;  { PrintBitmapRect }

procedure TCanvasReport.PrintImageRect(X1,Y1,X2,Y2: double;
                                       ImageStream: TStream;
                                       ImageType: string);

var
  Bitmap: TBitmap;

begin { PrintImageRect }
  If Assigned(FOnDecodeImage) then begin
    Bitmap := TBitmap.Create;
    try
      FOnDecodeImage(self,ImageStream,ImageType,Bitmap);
      PrintBitmapRect(X1,Y1,X2,Y2,Bitmap);
    finally
      Bitmap.Free;
    end; { tryf }
  end; { if }
end;  { PrintImageRect }

procedure TCanvasReport.Rectangle(X1,Y1,X2,Y2: double);

var
  F1: double;
  PA,PA2: integer;

begin { Rectangle }
  CheckPrinting;
  If OutputInvalid then Exit;

  If X1 > X2 then begin
    F1 := X1;
    X1 := X2;
    X2 := F1;
  end; { if }
  If Y1 > Y2 then begin
    F1 := Y1;
    Y1 := Y2;
    Y2 := F1;
  end; { if }
  If Canvas.Pen.Style = psClear then begin
    PA := 0;
    PA2 := 0;
  end else if (Canvas.Pen.Style = psInsideFrame) or (FrameMode = fmSplit) then begin
    PA := 0;
    PA2 := 1;
  end else if (FrameMode = fmInside) then begin
    PA := Canvas.Pen.Width div 2;
    PA2 := Canvas.Pen.Width - PA;
  end else begin { FrameMode = fmOutside }
    PA := -Canvas.Pen.Width div 2;
    PA2 := PA - Canvas.Pen.Width;
  end; { else }
  Canvas.Rectangle(XU2D(X1) + PA,YU2D(Y1) + PA,XU2D(X2) - PA2 + 2,YU2D(Y2) - PA2 + 2);
end;  { Rectangle }

procedure TCanvasReport.TabRectangle(X1,Y1,X2,Y2: double);

begin { TabRectangle }
  CheckPrinting;
  If OutputInvalid then Exit;

  Canvas.Rectangle(XU2D(X1),YU2D(Y1),XU2D(X2) + 1,YU2D(Y2) + 1);
end;  { TabRectangle }

procedure TCanvasReport.RoundRect(X1,Y1,X2,Y2,X3,Y3: double);

begin { RoundRect }
  CheckPrinting;
  If OutputInvalid then Exit;

  Canvas.RoundRect(XU2D(X1),YU2D(Y1),XU2D(X2),YU2D(Y2),Round(XU2I(X3) *
   (FScaleX * FZoom / 10000.0) * XDPI),Round(YU2I(Y3) * (FScaleY * FZoom /
   10000.0) * YDPI));
end;  { RoundRect }

procedure TCanvasReport.StretchDraw(const Rect: TRect;
                                          Graphic: TGraphic);

begin { StretchDraw }
  CheckPrinting;
  If OutputInvalid then Exit;

  Canvas.StretchDraw(Rect,Graphic);
end;  { StretchDraw }

procedure TCanvasReport.TextRect(      Rect: TRect;
                                       X,Y: double;
                                 const Text: string);
var
  Options: word;
begin { TextRect }
  CheckPrinting;
  If OutputInvalid or (Text = '') then Exit;

  With Canvas do begin
    SelectRPFont;
    SetTextAlign(Handle,TA_LEFT or TA_BASELINE);
    Options := ETO_CLIPPED;
    If Brush.Style <> bsClear then begin
      Options := Options or ETO_OPAQUE;
    end; { if }
    WinProcs.ExtTextOut(Handle,XU2D(X),YU2D(Y),Options,@Rect,@Text[1],
     Length(Text),nil);
    SelectCanvasFont;
  end; { with }
end;  { TextRect }

procedure TCanvasReport.NewPage;
begin { NewPage }
  inherited NewPage;
  LocalDevice.NewPageSelect(not FPageInvalid);
  InitPrinter;
end;  { NewPage }

  procedure TCanvasReport.ExtTextRect(      Rect : TRect;
                                            Just : Byte;
                                      const Text : string);
  Var
    Flags  : Word;
    TheStr : PChar;
  Begin { ExtTextRect }
    CheckPrinting;
    If OutputInvalid then Exit;

    With Canvas do begin
      SelectRPFont;

      TheStr := StrAlloc (Length (Text) + 1);
      StrPCopy (TheStr, Text);
      Flags := Just Or DT_VCENTER Or DT_EXPANDTABS Or DT_WORDBREAK Or DT_NOPREFIX ;
      DrawText (Canvas.Handle, TheStr, Length(TheStr), Rect, Flags);
      StrDispose (TheStr);

      SelectCanvasFont;
    End; { With }
  End;  { ExtTextRect }

  procedure TCanvasReport.TextRect2(      Rect : TRect;
                                          X,Y  : double;
                                          Just : Byte;
                                    const Text : string);
  var
    Options: word;
  begin { TextRect }
    CheckPrinting;
    If OutputInvalid or (Text = '') then Exit;

    With Canvas do begin
      SelectRPFont;

      If ((Just And DT_LEFT)   = DT_LEFT)   Then SetTextAlign(Handle,TA_LEFT or TA_BOTTOM);
      If ((Just And DT_CENTER) = DT_CENTER) Then SetTextAlign(Handle,TA_CENTER or TA_BOTTOM);
      If ((Just And DT_RIGHT)  = DT_RIGHT)  Then SetTextAlign(Handle,TA_RIGHT or TA_BOTTOM);

      Options := ETO_CLIPPED;
      If Brush.Style <> bsClear then begin
        Options := Options or ETO_OPAQUE;
      end; { if }


      WinProcs.ExtTextOut(Handle,XU2D(X),YU2D(Y),Options,@Rect,@Text[1],
       Length(Text),nil);

      SelectCanvasFont;
    end; { with }
  End; { TextRect2 }


  procedure TCanvasReport.PrintBitmapRect2(X1,Y1,X2,Y2: double;
                                           Bitmap: TBitmap);
  Begin { PrintBitmapRect2 }
    { Redirect to normal bitmap printing routine }
    PrintBitmapRect(X1,Y1,X2,Y2,Bitmap);
  End; { PrintBitmapRect2 }


  // RPDD - HM 27/11/02: Added Drill-Down support
  procedure TCanvasReport.DrillDownArea (Const X1, Y1, X2, Y2 : Double;
                                         Const LevelNo        : Byte;
                                         Const DDS1           : ShortString;
                                         Const DDI1, DDI2     : SmallInt;
                                         Const DDB1           : Byte); 
  Begin { DrillDownArea }

    // No Implementation - This code will only be used when printing direct
    // to printer - in which case you don't need drill-down support.  

  End; { DrillDownArea }

end.