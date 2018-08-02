{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

{$T-}

unit RPFiler;

interface

uses
  {$IFDEF Linux}
  QGraphics, QControls, QForms, QDialogs, QStdCtrls, QExtCtrls, Types,
  {$ELSE}
  WinTypes, WinProcs, Messages, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  {$ENDIF}
  SysUtils, Classes, RPDefine, RPBase, RPDevice;

const
  OUTBUFSIZE = 16384;
  MAXGRAPHICINDEX = 10;

type
  POutBuf = ^TOutBuf;
  TOutBuf = array[0..(OUTBUFSIZE - 1)] of byte;

{*************************************************************************}
{                            class TReportFiler                           }
{*************************************************************************}

  TReportFiler = class(TBaseReport)
  protected
    SaveBrush: TSaveBrush;
    SaveFont: TSaveFont;
    SavePen: TSavePen;
    WriteAll: boolean;
    OutBuf: POutBuf;
    OutPos: longint;
    AllowMode: byte;

    BrushSaveOnChange: TNotifyEvent;
    PenSaveOnChange: TNotifyEvent;
    GraphicPos: array[1..MAXGRAPHICINDEX] of longint;
    LastGraphicPos: longint;
    ReuseGraphicPos: longint;

    OutputStream: TStream;
    FStream: TStream;
    FOutputFileName: TFileName;
    FStreamMode: TStreamMode;
    FAccuracyMethod: TAccuracyMethod;
    FHoldOutput: boolean;
    PrevPagePos: longint;
    NextPagePos: longint;
    SaveJobPos: longint;
    JobPages: integer;
    AbsolutePage: integer;
    VarList: TStringList;
    LocalDeviceOwned: boolean;

    function FindVarName(VarName: string): integer;
    procedure CreateVarBuf(VarName: string;
                           VarData: string;
                           Defined: boolean;
                           PrevPos: longint);

  { Stream output routines }
    procedure WriteJobHeader;
    procedure FinishJob;
    procedure WritePageHeader;
    procedure FinishPage(LastPage: boolean);

    procedure BrushOnChange(Sender: TObject);
    procedure FontOnChange(Sender: TObject); override;
    procedure PenOnChange(Sender: TObject);

  { Stream output routines }
    procedure WriteByte(Value: byte);
    procedure WriteInteger(Value: smallint);
    procedure WriteLongint(Value: longint);
    procedure WriteText(Value: string);
    procedure WriteFloat(Value: double);
    procedure WriteXY(X,Y: double);
    procedure WriteGraphic(Value: TGraphic);
    procedure WritePoint(Value: TPoint);
    procedure WriteRect(Value: TRect);
    procedure Flush;
    procedure WriteBuf(var Buf;
                           Len: longint);
    procedure WriteBrush;
    procedure WriteFont;
    procedure WritePen;

    procedure SetBKColor(Value: TColor); override;
    procedure SetScaleX(Value: double); override;
    procedure SetScaleY(Value: double); override;
    procedure SetTextBKMode(Value: TBKMode); override;
    procedure SetOrientation(Value: TOrientation); override;
    procedure SetFrameMode(Value: TFrameMode); override;

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

    function Destination: TDestination; override;
    function GetCanvas: TCanvas; override;

  public
  { Report Methods - public }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Start; override;
    procedure Finish; override;
    procedure NewPage; override;
    procedure AbortPage; override;
    procedure ResetLineHeight; override;
    function SelectBin(BinName: string): boolean; override;

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
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    procedure FloodFill(X,Y: double;
                        Color: TColor;
                        FillStyle: TFillStyle); override;
    {$ENDIF}
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
    procedure AllowPreviewOnly; override;
    procedure AllowPrinterOnly; override;
    procedure AllowAll; override;
    procedure UnregisterGraphic(Index: integer); override;
    procedure RegisterGraphic(Index: integer); override;
    procedure ReuseGraphic(Index: integer); override;
    function PIVar(VarName: string): string; override;
    procedure SetPIVar(VarName: string;
                       VarValue: string); override;

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

    property Stream: TStream read FStream write FStream;
    property HoldOutput: boolean read FHoldOutput write FHoldOutput;
  published
  { Properties - redeclare as published }
    property FirstPage;
    property LastPage;
    property StatusLabel;
    property StatusFormat;
    property StatusText;
    property LineHeightMethod;
    property LinesPerInch;
    property Units;
    property UnitsFactor;
    property MarginLeft;
    property MarginRight;
    property MarginTop;
    property MarginBottom;
    property TabShade;
    property Title;
    property Copies;
    property Orientation;
    property TextBKMode;
    property ScaleX;
    property ScaleY;
    property AccuracyMethod: TAccuracyMethod read FAccuracyMethod
     write FAccuracyMethod default amAppearance;
    property FileName: TFileName read FOutputFileName write FOutputFileName;
    property StreamMode: TStreamMode read FStreamMode write FStreamMode
     default smMemory;

  { Event Properties - redeclare as published }
    property OnPrint;
    property OnPrintPage;
    property OnBeforePrint;
    property OnAfterPrint;
    property OnNewPage;
    property OnNewColumn;
    property OnPrintHeader;
    property OnPrintFooter;
    property OnEndOfSection;
  end; { TReportFiler }

  TReportRender = class(TReportFiler)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end; { TReportRender }

implementation

{$IFDEF Linux}
uses
  Libc, MiscKylix;
{$ENDIF}

{*************************************************************************}
{                            class TReportFiler                           }
{*************************************************************************}

  constructor TReportFiler.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);

    FOutputFileName := '';
    FStreamMode := smMemory;

    HoldOutput := false;
    WriteAll := false;
    FAccuracyMethod := amAppearance;
    VarList := TStringList.Create;
  end;  { Create }

  destructor TReportFiler.Destroy;

  begin { Destroy }
    VarList.Free;
    inherited Destroy;
  end;  { Destroy }

  procedure TReportFiler.BrushOnChange(Sender: TObject);

  begin { BrushOnChange }
    If Assigned(BrushSaveOnChange) then begin
      BrushSaveOnChange(Sender);
    end; { if }

    WriteBrush;
  end;  { BrushOnChange }

  procedure TReportFiler.FontOnChange(Sender: TObject);

  begin { FontOnChange }
    inherited FontOnChange(Sender);

    If DisableFontChange then Exit;

    WriteFont;
  end;  { FontOnChange }

  procedure TReportFiler.PenOnChange(Sender: TObject);

  begin { PenOnChange }
    If Assigned(PenSaveOnChange) then begin
      PenSaveOnChange(Sender);
    end; { if }

    WritePen;
  end;  { PenOnChange }

{ Stream output routines }

  procedure TReportFiler.WriteByte(Value: byte);

  begin { WriteByte }
    If HoldOutput then Exit;
    WriteBuf(Value,SizeOf(Value));
  end;  { WriteByte }

  procedure TReportFiler.WriteInteger(Value: smallint);

  begin { WriteInteger }
    If HoldOutput then Exit;
    WriteBuf(Value,SizeOf(Value));
  end;  { WriteInteger }

  procedure TReportFiler.WriteLongint(Value: longint);

  begin { WriteLongint }
    If HoldOutput then Exit;
    WriteBuf(Value,SizeOf(Value));
  end;  { WriteLongint }

  procedure TReportFiler.WriteText(Value: string);

  var
    Len: word;
    TempLen: word;

  begin { WriteText }
    If HoldOutput then Exit;
    Len := Length(Value);
    If Len < 192 then begin { Write out all strings < 192 chars as one byte }
      WriteByte(Len);
    end else begin { and all strings >= 192 chars as two bytes up to 16K length }
      TempLen := Len + $C000;
      WriteByte(Hi(TempLen));
      WriteByte(Lo(TempLen));
    end; { else }
    If Len > 0 then begin
      WriteBuf(Value[1],Len);
    end; { if }
  end;  { WriteText }

  procedure TReportFiler.WriteFloat(Value: double);

  var
    SingleVar: single;

  begin { WriteFloat }
    If HoldOutput then Exit;
    SingleVar := Value;
    WriteBuf(SingleVar,SizeOf(SingleVar));
  end;  { WriteFloat }

  procedure TReportFiler.WriteXY(X,Y: double);

  begin { WriteXY }
    WriteFloat((XU2I(X) + FOriginX) * FScaleX / 100.0);
    WriteFloat((YU2I(Y) + FOriginY) * FScaleY / 100.0);
  end;  { WriteXY }

  procedure TReportFiler.WriteGraphic(Value: TGraphic);

  var
    TempStream: TMemoryStream;
    AddKind: byte;

  begin { WriteGraphic }
    If HoldOutput then Exit;

    If ReuseGraphicPos = 0 then begin
      LastGraphicPos := OutputStream.Size + OutPos + 1;
      AddKind := 0;
    end else begin
      LastGraphicPos := ReuseGraphicPos;
      AddKind := 128;
    end; { else }

    If Value is TBitmap then begin
      WriteByte(1 + AddKind);
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    end else if Value is TMetafile then begin
      WriteByte(2 + AddKind);
    {$ENDIF}
    end else if Value is TIcon then begin
      WriteByte(3 + AddKind);
    end else begin { TGraphic }
      WriteByte(4 + AddKind);
    end; { else }

    If ReuseGraphicPos = 0 then begin
      TempStream := TMemoryStream.Create;
      try
        Value.SaveToStream(TempStream);
        WriteLongint(TempStream.Size);
        WriteBuf(TempStream.Memory^,TempStream.Size);
      finally
        TempStream.Free;
      end; { try }
    end else begin
      WriteLongint(ReuseGraphicPos);
      ReuseGraphicPos := 0;
    end; { else }
  end;  { WriteGraphic }

  procedure TReportFiler.WritePoint(Value: TPoint);

  begin { WritePoint }
    If HoldOutput then Exit;
    WriteXY(XD2U(Value.X),YD2U(Value.Y));
  end;  { WritePoint }

  procedure TReportFiler.WriteRect(Value: TRect);

  begin { WriteRect }
    If HoldOutput then Exit;
    WritePoint(Value.TopLeft);
    WritePoint(Value.BottomRight);
  end;  { WriteRect }

  procedure TReportFiler.Flush;

  begin { Flush }
    OutputStream.WriteBuffer(OutBuf^,OutPos);
    OutPos := 0;
  end;  { Flush }

  procedure TReportFiler.WriteBuf(var Buf;
                                      Len: longint);

  begin { WriteBuf }
    If HoldOutput or (Len = 0) then Exit;

    If (Len + OutPos) > OUTBUFSIZE then begin
      Flush;
    end; { if }
    If Len > OUTBUFSIZE then begin
      OutputStream.WriteBuffer(Buf,Len);
    end else begin
      Move(Buf,OutBuf^[OutPos],Len);
      OutPos := OutPos + Len;
    end; { else }
  end;  { WriteBuf }

  procedure TReportFiler.WriteBrush;

  begin { WriteBrush }
    If HoldOutput or not Printing then Exit;
    If OutputInvalid then Exit;
    With Canvas.Brush do begin
      If (Color <> SaveBrush.Color) or WriteAll then begin
        WriteByte(rpcSetBrushColor);
        WriteLongint(Color);
        SaveBrush.Color := Color;
      end; { if }

      If (Style <> SaveBrush.Style) or WriteAll then begin
        WriteByte(rpcSetBrushStyle);
        WriteByte(Ord(Style));
        SaveBrush.Style := Style;
      end; { if }

      If (Bitmap = nil) or Bitmap.Empty then begin
        If SaveBrush.Bitmap or WriteAll then begin
          WriteByte(rpcSetBrushBitmap);
          WriteByte(Ord(false));
          SaveBrush.Bitmap := false;
        end; { if }
      end else begin
        WriteByte(rpcSetBrushBitmap);
        WriteByte(Ord(true));
        WriteGraphic(Bitmap);
        SaveBrush.Bitmap := true;
      end; { else }
    end; { with }
  end;  { WriteBrush }

  procedure TReportFiler.WriteFont;

  var
    X1: double;
    WriteHeight: boolean;

  begin { WriteFont }
    If HoldOutput or not Printing then Exit;
    If OutputInvalid then Exit;
    With BaseFont do begin
      WriteHeight := false;
      If (Name <> SaveFont.Name) or WriteAll then begin
        WriteByte(rpcSetFontName);
        WriteText(Name);
        SaveFont.Name := Name;
        WriteHeight := true;
      end; { if }

      If (Color <> SaveFont.Color) or WriteAll then begin
        WriteByte(rpcSetFontColor);
        WriteLongint(Color);
        SaveFont.Color := Color;
      end; { if }

      If (Pitch <> SaveFont.Pitch) or WriteAll then begin
        WriteByte(rpcSetFontPitch);
        WriteByte(Ord(Pitch));
        SaveFont.Pitch := Pitch;
        WriteHeight := true;
      end; { if }

      If (Charset <> SaveFont.Charset) or WriteAll then begin
        WriteByte(rpcSetFontCharset);
        WriteByte(Charset);
        SaveFont.Charset := Charset;
        WriteHeight := true;
      end; { if }

      If (Bold <> SaveFont.Bold) or WriteAll then begin
        WriteByte(rpcSetFontBold);
        WriteByte(Ord(Bold));
        SaveFont.Bold := Bold;
        WriteHeight := true;
      end; { if }

      If (Italic <> SaveFont.Italic) or WriteAll then begin
        WriteByte(rpcSetFontItalic);
        WriteByte(Ord(Italic));
        SaveFont.Italic := Italic;
        WriteHeight := true;
      end; { if }

      If (Underline <> SaveFont.Underline) or WriteAll then begin
        WriteByte(rpcSetFontUnderline);
        WriteByte(Ord(Underline));
        SaveFont.Underline := Underline;
        WriteHeight := true;
      end; { if }

      If (Strikeout <> SaveFont.Strikeout) or WriteAll then begin
        WriteByte(rpcSetFontStrikeout);
        WriteByte(Ord(Strikeout));
        SaveFont.Strikeout := Strikeout;
        WriteHeight := true;
      end; { if }

      If (Superscript <> SaveFont.Superscript) or WriteAll then begin
        WriteByte(rpcSetFontSuperscript);
        WriteByte(Ord(Superscript));
        SaveFont.Superscript := Superscript;
      end; { if }

      If (Subscript <> SaveFont.Subscript) or WriteAll then begin
        WriteByte(rpcSetFontSubscript);
        WriteByte(Ord(Subscript));
        SaveFont.Subscript := Subscript;
      end; { if }

      If (Rotation <> SaveFont.Rotation) or WriteAll then begin
        WriteByte(rpcSetFontRotation);
        WriteInteger(Rotation);
        SaveFont.Rotation := Rotation;
      end; { if }

      If (Align <> SaveFont.Align) or WriteAll then begin
        WriteByte(rpcSetFontAlign);
        WriteByte(Ord(Align));
        SaveFont.Align := Align;
      end; { if }

    { Height should be last so that entire font will be set up for width match }
      If (Height <> SaveFont.Height) or WriteAll or WriteHeight then begin
        WriteByte(rpcSetFontHeight);
        WriteFloat(Height);
        HoldOutput := true;
        X1 := TextWidth(FontString) * 100.0 / FScaleX;
        HoldOutput := false;
        WriteFloat(X1);
        SaveFont.Size := Size;
        SaveFont.Height := Height;
      end; { if }
    end; { with }
  end;  { WriteFont }

  procedure TReportFiler.WritePen;

  var
    F1: double;

  begin { WritePen }
    If HoldOutput or not Printing then Exit;
    If OutputInvalid then Exit;
    With Canvas.Pen do begin
      If (Color <> SavePen.Color) or WriteAll then begin
        WriteByte(rpcSetPenColor);
        WriteLongint(Color);
        SavePen.Color := Color;
      end; { if }

      If (Mode <> SavePen.Mode) or WriteAll then begin
        WriteByte(rpcSetPenMode);
        WriteByte(Ord(Mode));
        SavePen.Mode := Mode;
      end; { if }

      If (Style <> SavePen.Style) or WriteAll then begin
        WriteByte(rpcSetPenStyle);
        WriteByte(Ord(Style));
        SavePen.Style := Style;
      end; { if }

      F1 := Width / FXDPI;
      If (F1 <> SavePen.Width) or WriteAll then begin
        WriteByte(rpcSetPenWidth);
        WriteFloat(F1);
        SavePen.Width := F1;
      end; { if }
    end; { with }
  end;  { WritePen }

  procedure TReportFiler.WriteJobHeader;

  begin { WriteJobHeader }
    If HoldOutput then Exit;
    WriteByte(rpcJobHeader);
    WriteInteger(2017);

    WriteText(Title);

  { Pages }
    Flush;
    SaveJobPos := OutputStream.Position;
    WriteInteger(0);

  { First,Last Page }
    WriteInteger(FFirstPage);
    WriteInteger(FLastPage);

  { Page Width,Height }
    If NoPrinters then begin
      WriteFloat(XU2I(NoPrinterPageWidth));
      WriteFloat(YU2I(NoPrinterPageHeight));
    end else begin
      WriteFloat(XU2I(PageWidth));
      WriteFloat(YU2I(PageHeight));
    end; { else }

  { Waste dimensions }
    WriteFloat(FLeftWaste);
    WriteFloat(FRightWaste);
    WriteFloat(FTopWaste);
    WriteFloat(FBottomWaste);

  { Printer settings }
    WriteByte(Ord(LocalDevice.Orientation));
    {$IFDEF Linux}
      WriteInteger(265); { Bin - DMBIN_AUTO }
      WriteByte(Ord(Collate)); { Collation - false }
      WriteByte(Ord(Duplex)); { Duplex - dupSimplex }
      WriteInteger(1); { Copies - 1 }

    { Other TDevMode items }
      WriteInteger(DMPAPER_LETTER);
      WriteInteger(0);
      WriteInteger(0);
    //!!PORT!!
    {$ELSE}
    If NoPrinters or (DevMode = nil) then begin
      WriteInteger(265); { Bin - DMBIN_AUTO }
      WriteByte(Ord(Collate)); { Collation - false }
      WriteByte(Ord(Duplex)); { Duplex - dupSimplex }
      WriteInteger(1); { Copies - 1 }

    { Other TDevMode items }
      WriteInteger(DMPAPER_LETTER);
      WriteInteger(0);
      WriteInteger(0);
    end else begin
      WriteInteger(DevMode^.dmDefaultSource);
      WriteByte(Ord(Collate));
      WriteByte(Ord(Duplex));
      WriteInteger(DevMode^.dmCopies);

    { Other TDevMode items }
      WriteInteger(DevMode^.dmPaperSize);
      WriteInteger(DevMode^.dmPaperWidth);
      WriteInteger(DevMode^.dmPaperLength);
    end; { else }
    {$ENDIF}
  { OutputName }
    WriteText(OutputName);
  end;  { WriteJobHeader }

  procedure TReportFiler.FinishJob;

  var
    SavePos: longint;

  begin { FinishJob }
    If HoldOutput then Exit;
  { Write out current page position to previous page header }
    If SaveJobPos > 0 then begin
      Flush;
      SavePos := OutputStream.Position; { Save off current position }
      OutputStream.Position := SaveJobPos; { Positions back to previous page }
    { Write out number of pages in the job }
      OutputStream.WriteBuffer(JobPages,SizeOf(smallint));
      OutputStream.Position := SavePos; { Reset positon back to where it was }
    end; { if }
  end;  { FinishJob }

  procedure TReportFiler.WritePageHeader;

  var
    SavePos: longint;
    F1: double;
    I1: integer;
    I2: longint;

  begin { WritePageHeader }
    If HoldOutput then Exit;
    If FPageInvalid then Exit;

  { Write page header }
    Flush;
    SavePos := OutputStream.Position;
    WriteByte(rpcNewPage);
    WriteLongint(PrevPagePos); { Previous page position }
    PrevPagePos := SavePos;
    Flush;
    NextPagePos := SavePos + 5;
    WriteLongint(0); { Space for next page position }
    WriteInteger(AbsolutePage); { PageNumber }

  { Page Width,Height }
    HoldOutput := true;    { Read in PageWidth with HoldOutput=true so that }
    F1 := XU2I(PageWidth); { font/brush and pen schanges don't get saved from }
    HoldOutput := false;   { a ResetHandle call }
    WriteFloat(F1);
    WriteFloat(YU2I(PageHeight));

  { Brush,Font and Pen Settings }
    WriteAll := true;
    WriteBrush;
    WriteFont;
    WritePen;
    WriteAll := false;

    SetScaleX(ScaleX);
    SetScaleY(ScaleY);
    SetTextBKMode(TextBKMode);
    SetBKColor(BKColor);

  { Write out all known variables }
    For I1 := 0 to (VarList.Count - 1) do begin
      WriteByte(rpcVariableData);
      WriteText(VarList[I1]);
      I2 := longint(VarList.Objects[I1]);
      WriteByte(SizeOf(I2)); { Max buffer size }
      WriteByte(254); { Buffer length - 254 for page pointer }
      WriteBuf(I2,SizeOf(I2));
    end; { for }
  end;  { WritePageHeader }

  procedure TReportFiler.FinishPage(LastPage: boolean);

  var
    SavePos: longint;
    TempPos: longint;

  begin { FinishPage }
    If HoldOutput then Exit;

    If not FPageInvalid then begin
      WriteByte(rpcEndPage); { Finish off last page }
    end; { if }

  { Write out current page position to previous page header }
    If NextPagePos > 0 then begin
      Flush;
      SavePos := OutputStream.Position; { Save off current position }
      OutputStream.Position := NextPagePos; { Positions back to previous page }
      If LastPage then begin { Write out 0 for last page }
        TempPos := 0;
      end else begin { Write out NextPagePos for previous page }
        TempPos := SavePos;
      end; { else }
      OutputStream.WriteBuffer(TempPos,SizeOf(TempPos));
      OutputStream.Position := SavePos; { Reset positon back to where it was }
    end; { if }
  end;  { FinishPage }

{ Property Get/Set routines }

  procedure TReportFiler.SetScaleX(Value: double);

  begin { SetScaleX }
    inherited SetScaleX(Value);
    If OutputInvalid then Exit;
    If Printing then begin
      WriteByte(rpcSetScaleX);
      WriteFloat(ScaleX);
    end; { if }
  end;  { SetScaleX }

  procedure TReportFiler.SetScaleY(Value: double);

  begin { SetScaleY }
    inherited SetScaleY(Value);
    If OutputInvalid then Exit;
    If Printing then begin
      WriteByte(rpcSetScaleY);
      WriteFloat(ScaleY);
    end; { if }
  end;  { SetScaleY }

  procedure TReportFiler.SetTextBKMode(Value: TBKMode);

  begin { SetTextBKMode }
    inherited SetTextBKMode(Value);
    If OutputInvalid then Exit;
    If Printing then begin
      WriteByte(rpcSetTextBKMode);
      WriteByte(Ord(FTextBKMode));
    end; { if }
  end;  { SetTextBKMode }

  procedure TReportFiler.SetBKColor(Value: TColor);

  begin { SetBKColor }
    inherited SetBKColor(Value);
    If OutputInvalid then Exit;
    If Printing then begin
      WriteByte(rpcSetBKColor);
      {$IFDEF Linux}
      //!!PORT!!
      WriteLongint(longint(clBlack));
      {$ELSE}
      WriteLongint(longint(WinProcs.GetBKColor(Canvas.Handle)));
      {$ENDIF}
    end; { if }
  end;  { SetBKColor }

  procedure TReportFiler.SetOrientation(Value: TOrientation);

  begin { SetOrientation }
    inherited SetOrientation(Value);
    If OutputInvalid then Exit;
    If Printing then begin
      WriteByte(rpcSetOrientation);
      WriteByte(Ord(Value));
    end; { if }
  end;  { SetOrientation }

  procedure TReportFiler.SetFrameMode(Value: TFrameMode);

  begin { SetFrameMode }
    inherited SetFrameMode(Value);
    If OutputInvalid then Exit;
    If Printing then begin
      WriteByte(rpcSetFrameMode);
      WriteByte(Ord(Value));
    end; { if }
  end;  { SetFrameMode }

  function TReportFiler.SelectBin(BinName: string): boolean;

  begin { SelectBin }
    Result := inherited SelectBin(BinName);
    If OutputInvalid then Exit;
    If Printing then begin
      WriteByte(rpcSetBin);
      WriteText(BinName);
    end; { if }
  end;  { SelectBin }

{ Output routines }

  procedure TReportFiler.PrintCenterInch(Text: string;
                                         Pos: double);

  var
    Width: double;
    NewPos: double;

  begin { PrintCenterInch }
    CheckPrinting;
    If OutputInvalid then Exit;

    If (FAccuracyMethod = amPositioning) and (BaseFont.Rotation = 0) and
     (System.Pos(#253 + {Trans-}'$RPC',Text) = 0) and (System.Pos(RPTFPrefix,Text) = 0) and
     (System.Pos(' ',Text) <> 0) then begin
      Width := TextWidth(Text) * 10000.0 / (FScaleX * FScaleX);
      NewPos := Pos - (XU2I(Width) / 2.0);
      PrintBlockInch(Text,NewPos,Width);
    end else begin
      WriteByte(rpcCenterText);
      WriteFloat((FCursorYPos + FOriginY) * FScaleY / 100.0);
      WriteText(Text);
      WriteFloat((Pos + FOriginX) * FScaleX / 100.0);

      FCursorXPos := Pos * FScaleX / 100.0;
      AdjustXY((TextWidth(Text) / 2.0) * FScaleX / 100.0);
    end; { else }
    ProcessMessages;
  end;  { PrintCenterInch }

  procedure TReportFiler.PrintLeftInch(Text: string;
                                       Pos: double);

  begin { PrintLeftInch }
    CheckPrinting;
    If OutputInvalid then Exit;

    If (FAccuracyMethod = amPositioning) and (BaseFont.Rotation = 0) and
     (System.Pos(#253 + {Trans-}'$RPC',Text) = 0) and (System.Pos(RPTFPrefix,Text) = 0) and
     (System.Pos(' ',Text) <> 0) then begin
      PrintBlockInch(Text,Pos,TextWidth(Text) * 10000.0 / (FScaleX * FScaleX));
    end else begin
      WriteByte(rpcLeftText);
      WriteFloat((FCursorYPos + FOriginY) * FScaleY / 100.0);
      WriteText(Text);
      WriteFloat((Pos + FOriginX) * FScaleX / 100.0);

      FCursorXPos := Pos * FScaleX / 100.0;
      AdjustXY(TextWidth(Text) * FScaleX / 100.0);
    end; { else }
    ProcessMessages;
  end;  { PrintLeftInch }

  procedure TReportFiler.PrintRightInch(Text: string;
                                        Pos: double);

  var
    Width: double;
    NewPos: double;

  begin { PrintRightInch }
    CheckPrinting;
    If OutputInvalid then Exit;

    If (FAccuracyMethod = amPositioning) and (BaseFont.Rotation = 0) and
     (System.Pos(#253 + {Trans-}'$RPC',Text) = 0) and (System.Pos(RPTFPrefix,Text) = 0) and
     (System.Pos(' ',Text) <> 0) then begin
      Width := TextWidth(Text) * 10000.0 / (FScaleX * FScaleX);
      NewPos := Pos - XU2I(Width);
      PrintBlockInch(Text,NewPos,Width);
    end else begin
      WriteByte(rpcRightText);
      WriteFloat((FCursorYPos + FOriginY) * FScaleY / 100.0);
      WriteText(Text);
      WriteFloat((Pos + FOriginX) * FScaleX / 100.0);

      FCursorXPos := Pos * FScaleX / 100.0;
    end; { else }
    ProcessMessages;
  end;  { PrintRightInch }

  procedure TReportFiler.PrintBlockInch(Text: string;
                                        Pos: double;
                                        Width: double);

  begin { PrintBlockInch }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcBlockText);
    WriteFloat((FCursorYPos + FOriginY) * FScaleY / 100.0);
    WriteText(Text);
    WriteFloat((Pos + FOriginX) * FScaleY / 100.0);
    WriteFloat((XU2I(Width)) * FScaleX / 100.0);

    FCursorXPos := Pos * FScaleX / 100.0;
    AdjustXY(Width * FScaleX / 100.0);

    ProcessMessages;
  end;  { PrintBlockInch }

  function TReportFiler.Destination: TDestination;

  begin { Destination }
    Result := destFile;
  end;  { Destination }

  function TReportFiler.GetCanvas: TCanvas;

  begin { GetCanvas }
    Result := LocalDevice.Canvas;
  end;  { GetCanvas }

{ GDI Functions }

  procedure TReportFiler.Arc(X1,Y1,X2,Y2,X3,Y3,X4,Y4: double);

  begin { Arc }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcArc);
    WriteXY(X1,Y1);
    WriteXY(X2,Y2);
    WriteXY(X3,Y3);
    WriteXY(X4,Y4);
    ProcessMessages;
  end;  { Arc }

  procedure TReportFiler.BrushCopy(const Dest: TRect;
                                         Bitmap: TBitmap;
                                   const Source: TRect;
                                         Color: TColor);

  begin { BrushCopy }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcBrushCopy);
    WriteGraphic(Bitmap);
    WriteRect(Dest);
    WriteRect(Source);
    WriteLongint(Color);
    ProcessMessages;
  end;  { BrushCopy }

  procedure TReportFiler.Chord(X1,Y1,X2,Y2,X3,Y3,X4,Y4: double);

  begin { Chord }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcChord);
    WriteXY(X1,Y1);
    WriteXY(X2,Y2);
    WriteXY(X3,Y3);
    WriteXY(X4,Y4);
    ProcessMessages;
  end;  { Chord }

  procedure TReportFiler.CopyRect(const Dest: TRect;
                                        Canvas: TCanvas;
                                  const Source: TRect);

  begin { CopyRect }
    RaiseError(Trans('CopyRect() not supported in file mode.'));
  end;  { CopyRect }

  procedure TReportFiler.Draw(X,Y: double;
                              Graphic: TGraphic);

  begin { Draw }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcDraw);
    WriteGraphic(Graphic);
    WriteXY(X,Y);
    ProcessMessages;
  end;  { Draw }

  procedure TReportFiler.DrawFocusRect(const Rect: TRect);

  begin { DrawFocusRect }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcDrawFocusRect);
    WriteRect(Rect);
    ProcessMessages;
  end;  { DrawFocusRect }

  procedure TReportFiler.Ellipse(X1,Y1,X2,Y2: double);

  begin { Ellipse }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcEllipse);
    WriteXY(X1,Y1);
    WriteXY(X2,Y2);
    ProcessMessages;
  end;  { Ellipse }

  procedure TReportFiler.FillRect(const Rect: TRect);

  begin { FillRect }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcFillRect);
    WriteRect(Rect);
    ProcessMessages;
  end;  { FillRect }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  procedure TReportFiler.FloodFill(X,Y: double;
                                   Color: TColor;
                                   FillStyle: TFillStyle);

  begin { FloodFill }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcFloodFill);
    WriteXY(X,Y);
    WriteLongint(Color);
    WriteLongint(Ord(FillStyle));
    ProcessMessages;
  end;  { FloodFill }
  {$ENDIF}
  procedure TReportFiler.FrameRect(const Rect: TRect);

  begin { FrameRect }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcFrameRect);
    WriteRect(Rect);
    ProcessMessages;
  end;  { FrameRect }

  procedure TReportFiler.LineTo(X,Y: double);

  var
    SaveX,SaveY: double;

  begin { LineTo }
    CheckPrinting;
    If OutputInvalid then Exit;

    SaveX := LastLineX;
    SaveY := LastLineY;
    If NoBufferLine then begin
      WriteByte(rpcLineTo);
      WriteXY(X,Y);
    end else if not BufferLine(X,Y) then begin
      WriteByte(rpcMoveTo);
      WriteXY(SaveX - OriginX,SaveY - OriginY);
      WriteByte(rpcLineTo);
      WriteXY(X,Y);
    end; { else }
    ProcessMessages;
  end;  { LineTo }

  procedure TReportFiler.MoveTo(X,Y: double);

  begin { MoveTo }
    CheckPrinting;
    If OutputInvalid then Exit;

    If NoBufferLine then begin
      WriteByte(rpcMoveTo);
      WriteXY(X,Y);
    end; { if }
    LastLineX := X + OriginX;
    LastLineY := Y + OriginY;
  end;  { MoveTo }

  procedure TReportFiler.Pie(X1,Y1,X2,Y2,X3,Y3,X4,Y4: double);

  begin { Pie }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcPie);
    WriteXY(X1,Y1);
    WriteXY(X2,Y2);
    WriteXY(X3,Y3);
    WriteXY(X4,Y4);
    ProcessMessages;
  end;  { Pie }

  procedure TReportFiler.Polygon(const Points: array of TPoint);

  var
    L1: longint;

  begin { Polygon }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcPolygon);
    WriteInteger(High(Points));
    For L1 := 0 to High(Points) do begin
      WritePoint(Points[L1]);
    end; { for }
    ProcessMessages;
  end;  { Polygon }

  procedure TReportFiler.Polyline(const Points: array of TPoint);

  var
    L1: longint;

  begin { Polyline }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcPolyLine);
    WriteInteger(High(Points));
    For L1 := 0 to High(Points) do begin
      WritePoint(Points[L1]);
    end; { for }
    ProcessMessages;
  end;  { Polyline }

  procedure TReportFiler.PrintBitmap(X,Y: double;
                                     ScaleX,ScaleY: double;
                                     Bitmap: TBitmap);

  begin { PrintBitmap }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcTransBitmap);
    WriteByte(Ord(TransparentBitmaps));

    WriteByte(rpcPrintBitmap);
    WriteGraphic(Bitmap);
    WriteXY(X,Y);
    WriteFloat(ScaleX);
    WriteFloat(ScaleY);
    ProcessMessages;
  end;  { PrintBitmap }

  procedure TReportFiler.PrintBitmapRect(X1,Y1,X2,Y2: double;
                                         Bitmap: TBitmap);

  begin { PrintBitmapRect }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcTransBitmap);
    WriteByte(Ord(TransparentBitmaps));

    WriteByte(rpcPrintBitmapRect);
    WriteGraphic(Bitmap);
    WriteXY(X1,Y1);
    WriteXY(X2,Y2);
    ProcessMessages;
  end;  { PrintBitmapRect }

  procedure TReportFiler.PrintImageRect(X1,Y1,X2,Y2: double;
                                        ImageStream: TStream;
                                        ImageType: string);

  begin { PrintImageRect }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcTransBitmap);
    WriteByte(Ord(TransparentBitmaps));

    WriteByte(rpcPrintImageRect);
    WriteLongint(ImageStream.Size - ImageStream.Position);
    Flush;
    OutputStream.CopyFrom(ImageStream,ImageStream.Size - ImageStream.Position);
    WriteText(ImageType);
    WriteXY(X1,Y1);
    WriteXY(X2,Y2);
    ProcessMessages;
  end;  { PrintImageRect }

  procedure TReportFiler.Rectangle(X1,Y1,X2,Y2: double);

  begin { Rectangle }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcRectangle);
    WriteXY(X1,Y1);
    WriteXY(X2,Y2);
    ProcessMessages;
  end;  { Rectangle }

  procedure TReportFiler.TabRectangle(X1,Y1,X2,Y2: double);

  begin { TabRectangle }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcTabRectangle);
    WriteXY(X1,Y1);
    WriteXY(X2,Y2);
    ProcessMessages;
  end;  { TabRectangle }

  procedure TReportFiler.RoundRect(X1,Y1,X2,Y2,X3,Y3: double);

  begin { RoundRect }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcRoundRect);
    WriteXY(X1,Y1);
    WriteXY(X2,Y2);
    WriteFloat(XU2I(X3));
    WriteFloat(YU2I(Y3));
    ProcessMessages;
  end;  { RoundRect }

  procedure TReportFiler.StretchDraw(const Rect: TRect;
                                           Graphic: TGraphic);

  begin { StretchDraw }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcStretchDraw);
    WriteGraphic(Graphic);
    WriteRect(Rect);
    ProcessMessages;
  end;  { StretchDraw }

  procedure TReportFiler.TextRect(      Rect: TRect;
                                        X,Y: double;
                                  const Text: string);

  begin { TextRect }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcTextRect);
    WriteRect(Rect);
    WriteXY(X,Y);
    WriteText(Text);
    ProcessMessages;
  end;  { TextRect }

  procedure TReportFiler.PrintData(Value: string);

  begin { PrintData }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcPrintData);
    WriteText(Value);
    ProcessMessages;
  end;  { PrintData }

  procedure TReportFiler.PrintDataStream(Stream: TStream;
                                         BufSize: longint);

  const
    BufMax = 4096;

  var
    Buf: pointer;
    I1,I2,I3: longint;

  begin { PrintDataStream }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcPrintDataStream);
    If BufSize = 0 then begin
      BufSize := Stream.Size - Stream.Position;
    end; { if }
    WriteLongint(BufSize);
    GetMem(Buf,BufMax);
    try
      I2 := (BufSize div BufMax) + 1;
      For I1 := 1 to I2 do begin
      { Figure out size of this chunk }
        If I1 = I2 then begin { Last piece }
          I3 := BufSize mod BufMax;
        end else begin { BufMax sized chunk }
          I3 := BufMax;
        end; { else }

        If I3 > 0 then begin
        { Move data from stream to buffer and pass to Escape }
          Stream.ReadBuffer(Buf^,I3);
          WriteBuf(Buf^,I3);
        end; { if }
      end; { for }
    finally
      FreeMem(Buf,BufMax);
    end; { tryf }
  end;  { PrintDataStream }

  procedure TReportFiler.AllowPreviewOnly;

  begin { AllowPreviewOnly }
    If AllowMode = rpcAllowPreviewOnly then Exit;
    CheckPrinting;
    If OutputInvalid then Exit;
    WriteByte(rpcAllowPreviewOnly);
    AllowMode := rpcAllowPreviewOnly;
  end;  { AllowPreviewOnly }

  procedure TReportFiler.AllowPrinterOnly;

  begin { AllowPrinterOnly }
    If AllowMode = rpcAllowPrinterOnly then Exit;
    CheckPrinting;
    If OutputInvalid then Exit;
    WriteByte(rpcAllowPrinterOnly);
    AllowMode := rpcAllowPrinterOnly;
  end;  { AllowPrinterOnly }

  procedure TReportFiler.AllowAll;

  begin { AllowAll }
    If AllowMode = rpcAllowAll then Exit;
    CheckPrinting;
    If OutputInvalid then Exit;
    WriteByte(rpcAllowAll);
    AllowMode := rpcAllowAll;
  end;  { AllowAll }

  procedure TReportFiler.Start;

  var
    S1: string[4];
    S2: string[145];
    TempPath: string[128];

  begin { Start }
    CheckNotPrinting;

    ReportDateTime := Now;
    AllowMode := rpcAllowAll;

    OutputStream := nil;
    FCurrentPage := 0;
    AbsolutePage := 0;
    PrevPagePos := 0;
    NextPagePos := 0;
    SaveJobPos := 0;
    JobPages := 0;
    VarList.Clear;
    FillChar(GraphicPos,SizeOf(GraphicPos),0);
    FAborted := false;
    BeforePrintEvent;

  { Initialize output stream }
    try
      Case FStreamMode of
        smMemory: begin
          OutputStream := TMemoryStream.Create;
        end;
        smTempFile: begin
          S1 := {Trans-}'RP'#0;
          {$IFDEF Linux}
          S2 := tempnam(nil, PChar(S1[1]));
          S2 := S2 + '.tmp';
          {$ELSE}
          SetLength(TempPath,GetTempPath(SizeOf(TempPath) - 1,@TempPath[1]));
          GetTempFileName(@TempPath[1],@S1[1],0,@S2[1]);
          {$ENDIF}
          FOutputFileName := StrPas(@S2[1]);
          OutputStream := TFileStream.Create(FOutputFileName,fmCreate);
        end;
        smFile: begin
          OutputStream := TFileStream.Create(FOutputFileName,fmCreate);
        end;
        smUser: begin
          If FStream = nil then begin
            RaiseError(Trans('StreamMode is smUser but Stream is nil'));
          end; { if }
          OutputStream := FStream;
          OutputStream.Position := 0;
        end;
      end; { case }
    except
      on E: EStreamError do begin
        If FStreamMode <> smUser then begin
          OutputStream.Free;
        end; { if }
        raise;
      end; { on }
    end; { try }
    GetMem(OutBuf,OUTBUFSIZE);
    OutPos := 0;

  { Write out job header }
    ResetPrinter;
    FPrinting := true;
    WriteJobHeader;
    HoldOutput := true;

  { Init canvas }
    If NoPrinters or (RPDev = nil) or (FLocalDevice <> nil) then begin
      If FLocalDevice = nil then begin
        LocalDeviceOwned := true;
        FLocalDevice := TRPRenderDevice.Create;
      end; { if }
      FXDPI := LocalDevice.XDPI;
      FYDPI := LocalDevice.YDPI;
    end else begin
      RPDev.State := dsIC;
    end; { else }

    GrabFontOnChange;
    BrushSaveOnChange := Canvas.Brush.OnChange;
    Canvas.Brush.OnChange := BrushOnChange;
    PenSaveOnChange := Canvas.Pen.OnChange;
    Canvas.Pen.OnChange := PenOnChange;

  { Init first page }
    PushTabs;
    Reset;
    PopTabs;
    Inc(FCurrentPage);
    FPageInvalid := not PageInRange(FCurrentPage) or FAborted;
    If not FPageInvalid then begin
      Inc(JobPages);
      Inc(AbsolutePage);
    end; { if }

    UpdateStatus; { Update status for first page }

    HoldOutput := false;
    WritePageHeader; { Write current page status }

  { Call OnNewPage and OnPrintHeader for first page }
    If not FAborted then begin
      ExecuteReportEvent(BeginPageList);
    end; { if }
    If not FAborted then begin
      NewPageEvent;
    end; { if }
    If not FAborted then begin
      PrintHeaderEvent;
    end; { if }
  end;  { Start }

  procedure TReportFiler.Finish;

  begin { Finish }
    try
    { Print the last footer }
      If not FAborted then begin
        PrintFooterEvent;
      end; { if }
      If not FAborted then begin
        ExecuteReportEvent(EndPageList);
      end; { if }
      FinishPage(true); { Finish off last page }
      FinishJob; { Finish off job }
      Flush;
      FreeMem(OutBuf,OUTBUFSIZE);
    finally
      Canvas.Brush.OnChange := BrushSaveOnChange;
      Canvas.Pen.OnChange := PenSaveOnChange;
      ReleaseFontOnChange;
      ClearFontList;
      ClearLineLists;
      If LocalDeviceOwned then begin
        LocalDeviceOwned := false;
        FLocalDevice.Free;
        FLocalDevice := nil;
      end; { if }
      try
        If FStreamMode = smMemory then begin
          With OutputStream as TMemoryStream do begin
            SaveToFile(FOutputFilename);
          end; { with }
        end; { if }
        If (FStreamMode <> smUser) and (OutputStream <> nil) then begin
          OutputStream.Free;
        end; { if }
      finally
        FPrinting := false;
        AfterPrintEvent;
      end; { tryf }
    end; { try }
  end;  { Finish }

  procedure TReportFiler.NewPage;

  begin { NewPage }
    PrintFooterEvent;
    ExecuteReportEvent(EndPageList);

    FinishPage(false); { Finish off previous page }

    HoldOutput := true;
    inherited NewPage;
    If not NoPrinters then begin
      InitPrinter;
    end; { if }
    HoldOutput := false;

    If not FPageInvalid then begin
      Inc(JobPages);
      Inc(AbsolutePage);
    end; { if }

    WritePageHeader; { Write current page status }

  { Call OnNewPage and OnPrintHeader for current page }
    ExecuteReportEvent(BeginPageList);
    NewPageEvent;
    If FColumns > 1 then begin
      NewColumnEvent;
    end; { if }
    PrintHeaderEvent;
  end;  { NewPage }

  procedure TReportFiler.AbortPage;

  begin { AbortPage }
    inherited AbortPage;

  { Delete back to previous page header }
    OutputStream.Position := PrevPagePos;
  end;  { AbortPage }

  procedure TReportFiler.ResetLineHeight;

  begin { ResetLineHeight }
    inherited ResetLineHeight;

    If Printing then begin
      If OutputInvalid then Exit;
      WriteByte(rpcResetLineHeight);
      WriteFloat(FAscentHeight);
      WriteFloat(FDescentHeight);
      WriteFloat(FLineHeight);
    end; { if }
  end;  { ResetLineHeight }

  procedure TReportFiler.UnregisterGraphic(Index: integer);

  begin { UnregisterGraphic }
    If (Index >= 1) and (Index <= MAXGRAPHICINDEX) then begin
      GraphicPos[Index] := 0;
    end else begin
      RaiseError({Trans-}'UnregisterGraphic: Index must be between 1 and ' +
       IntToStr(MAXGRAPHICINDEX));
    end; { else }
  end;  { UnregisterGraphic }

  procedure TReportFiler.RegisterGraphic(Index: integer);

  begin { RegisterGraphic }
    If (Index >= 1) and (Index <= MAXGRAPHICINDEX) then begin
      GraphicPos[Index] := LastGraphicPos;
    end else begin
      RaiseError({Trans-}'RegisterGraphic: Index must be between 1 and ' +
       IntToStr(MAXGRAPHICINDEX));
    end; { else }
  end;  { RegisterGraphic }

  procedure TReportFiler.ReuseGraphic(Index: integer);

  begin { ReuseGraphic }
    If (Index >= 1) and (Index <= MAXGRAPHICINDEX) then begin
      ReuseGraphicPos := GraphicPos[Index];
    end else begin
      RaiseError({Trans-}'ReuseGraphic: Index must be between 1 and ' +
       IntToStr(MAXGRAPHICINDEX));
    end; { else }
  end;  { ReuseGraphic }

  function TReportFiler.FindVarName(VarName: string): integer;

  var
    I1: integer;

  begin { FindVarName }
    Result := -1;
    For I1 := 0 to (VarList.Count - 1) do begin
      If CompareText(VarList[I1],VarName) = 0 then begin
        Result := I1;
        Break;
      end; { if }
    end; { for }
  end;  { FindVarName }

  procedure TReportFiler.CreateVarBuf(VarName: string;
                                      VarData: string;
                                      Defined: boolean;
                                      PrevPos: longint);

  var
    Buf: array[1..32] of longint;

  begin { CreateVarBuf }
    WriteByte(rpcVariableData);
    WriteText(VarName);
    Flush;
  { Add VarList item with pointer to buffer where data is supposed to go }
    FillChar(Buf,SizeOf(Buf),0);
    If Defined then begin
      VarList.AddObject(VarName,TObject(-OutputStream.Size));
      WriteByte(Length(VarData)); { Max buffer size }
      WriteByte(Length(VarData)); { Buffer length }
      If Length(VarData) > 0 then begin
        WriteBuf(VarData[1],Length(VarData));
      end; { if }
    end else begin
      VarList.AddObject(VarName,TObject(OutputStream.Size));
      WriteByte(128); { Max buffer size }
      WriteByte(255); { Buffer length - 255 for undefined }
      Buf[1] := PrevPos;
      WriteBuf(Buf,SizeOf(Buf));
    end; { else }
    ProcessMessages;
  end;  { CreateVarBuf }

  function TReportFiler.PIVar(VarName: string): string;

  var
    VarIdx: integer;
    VarLoc: longint;

  begin { PIVar }
    CheckPrinting;
    If OutputInvalid then Exit;

  { Return encoded Variable string }
    Result := {Trans-}#253 + {Trans-}'$RPCV'#252 + VarName + #251;

  { Look for existing VarList item }
    VarIdx := FindVarName(VarName);

  { If not found, add to report file and VarList }
    If VarIdx < 0 then begin
    { Create VarData:Init pointing to 0 }
      CreateVarBuf(VarName,'',false,0);
    end else begin { Found }
      If longint(VarList.Objects[VarIdx]) < 0 then begin { Defined }
        VarLoc := Abs(longint(VarList.Objects[VarIdx]));
        VarList.Delete(VarIdx); { Delete current variable data }
      { Create VarData:Init pointing to existing VarData }
        CreateVarBuf(VarName,'',false,VarLoc);
      end else begin
      { undefined (Init), don't do anything }
      end; { else }
    end; { if }
  end;  { PIVar }

  procedure TReportFiler.SetPIVar(VarName: string;
                                  VarValue: string);

  var
    VarIdx: integer;
    SavePos: longint;
    B1: byte;

  begin { SetPIVar }
    CheckPrinting;
    If OutputInvalid then Exit;

  { Look for existing VarList item }
    VarIdx := FindVarName(VarName);
    If VarIdx < 0 then begin { Not found, Create variable data buffer and set to defined }
    { Create VarData:Defined }
      CreateVarBuf(VarName,VarValue,true,0);
    end else begin { Found VarBuf, set vardata and set to defined }
    { Set VarData:Defined }
      Flush;
      VarList.Objects[VarIdx] := TObject(-longint(VarList.Objects[VarIdx]));
      SavePos := OutputStream.Position;
      OutputStream.Position := Abs(longint(VarList.Objects[VarIdx]));
      B1 := 128;
      OutputStream.WriteBuffer(B1,SizeOf(B1)); { Set max buffer size }
      B1 := Length(VarValue);
      If B1 > 128 then begin
        B1 := 128;
      end; { if }
      OutputStream.WriteBuffer(B1,SizeOf(B1)); { Set buffer length }
      If B1 > 0 then begin
        OutputStream.WriteBuffer(VarValue[1],B1);
      end; { if }
      OutputStream.Position := SavePos;
    end; { else }
  end;  { SetPIVar }

  { User Defined }
  procedure TReportFiler.ExtTextRect(      Rect : TRect;
                                           Just : Byte;
                                     const Text : string);
  Begin { ExtTextRect }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcJustText);
    WriteRect(Rect);
    WriteByte(Just);
    WriteText(Text);
    Application.ProcessMessages;
  End;  { ExtTextRect }

  procedure TReportFiler.TextRect2(      Rect : TRect;
                                         X,Y  : double;
                                         Just : Byte;
                                   const Text : string);
  Begin { TextRect2 }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcTextRect2);
    WriteRect(Rect);
    WriteXY(X,Y);
    WriteByte(Just);
    WriteText(Text);
    Application.ProcessMessages;
  End;  { TextRect2 }

  procedure TReportFiler.PrintBitmapRect2(X1,Y1,X2,Y2: double;
                              Bitmap: TBitmap);
  Begin { PrintBitmapRect2 }
    { Copied from normal PrintBitmapRect handler and modified to }
    { specify as PrintBitmapRect2                                }
    CheckPrinting;
    If OutputInvalid then Exit;

    WriteByte(rpcTransBitmap);
    WriteByte(Ord(TransparentBitmaps));

    WriteByte(rpcPrintBitmapRect2);
    WriteGraphic(Bitmap);
    WriteXY(X1,Y1);
    WriteXY(X2,Y2);
    Application.ProcessMessages;
  End; { PrintBitmapRect2 }

  // RPDD - HM 27/11/02: Added Drill-Down support
  procedure TReportFiler.DrillDownArea (Const X1, Y1, X2, Y2 : Double;
                                        Const LevelNo        : Byte;
                                        Const DDS1           : ShortString;
                                        Const DDI1, DDI2     : SmallInt;
                                        Const DDB1           : Byte);
  Var
    BespokeData  : TMemoryStream;
    ReportStream : TStream;
  Begin { DrillDownArea }
    CheckPrinting;
    If OutputInvalid then Exit;

    BespokeData := TMemoryStream.Create;
    Try
      // Force any cached commands to be written to the report stream before we
      // switch them out
      Flush;

      // Replace the standard output stream with a temporary memory stream to create
      // the data block for the bespoke function using the standard functions
      ReportStream := OutputStream;
      OutputStream := BespokeData;
      Try
        // Use the standard RPPro streaming functions to write the bespoke data to
        // the local stream
        WriteByte(rpcDrillDown);
        WriteXY(X1,Y1);
        WriteXY(X2,Y2);
        WriteByte(LevelNo);
        WriteText(DDS1);
        WriteInteger(DDI1);
        WriteInteger(DDI2);
        WriteByte(DDB1);

        // Force bespoke data commands to be written to the BespokeData stream before
        // restoring the proper Report Stream
        Flush;
      Finally
        // Restore the correct report stream
        OutputStream := ReportStream;
      End;

      // Check the bespoke data has been written successfully
      If (BespokeData.Size > 0) Then Begin
        // Write bespoke data header to report stream
        WriteByte(rpcBespoke);

        // Write bespoke despoke data length to report stream
        WriteLongint(BespokeData.Size);

        // Write bespoke data section  to report stream
        WriteBuf(BespokeData.Memory^,BespokeData.Size);
      End; { If (BespokeData.Size > 0) }
    Finally
      FreeAndNIL(BespokeData);
    End; { try }

    (**
    // Drill-Down Data Block
    WriteByte(rpcDrillDown);
    WriteXY(X1,Y1);
    WriteXY(X2,Y2);
    WriteByte(LevelNo);
    WriteText(DrillDownKey);
    **)

    ProcessMessages;
  End; { DrillDownArea }


{*************************************************************************}
{                            class TReportRender                          }
{*************************************************************************}

  constructor TReportRender.Create(AOwner: TComponent);

  begin { Create }
    LocalDevice := TRPRenderDevice.Create;
    inherited Create(AOwner);
  end;  { Create }

  destructor TReportRender.Destroy;

  begin { Destroy }
    inherited Destroy;
    LocalDevice.Free;
    LocalDevice := nil;
  end;  { Destroy }

end.
