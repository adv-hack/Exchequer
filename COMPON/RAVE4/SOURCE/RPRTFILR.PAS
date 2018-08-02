{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPRTFilr;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, RPDefine, RPBase, RPDevice, RPRPTF;

type
{*************************************************************************}
{                            class TRTFFiler                              }
{*************************************************************************}

  TRTFFiler = class(TBaseReport)
  protected
    FStream: TStream;
    FStreamMode: TStreamMode;
    UseFinal: boolean;
    WorkFile: Integer;
    WorkFileName: string;
    FinalStream: TStream;
    OnNewPara: boolean;
    OnNewDoc: boolean;
    FOutputFileName: TFileName;
    FontTable: TStringList;
    LastGraphicX: double;
    LastGraphicY: double;

  { Abstract Output Methods - protected }
    procedure PrintText(Text: string);
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

    procedure WriteStr(Value: string);
    procedure WriteLine(Value: string);
    procedure WriteXTwips(Command: string;
                          Value: double);
    procedure WriteYTwips(Command: string;
                          Value: double);
    procedure WritePara(Justify: TTabJustify);
    function GetFontIndex: integer;
    procedure WriteFont;
    procedure WriteBinary(var Buffer;
                              Size: longint);
    procedure WriteText(Text: string);
    procedure WriteGraphicPen;
    procedure WriteGraphicBrush;
    procedure WriteGraphicRect(X1,Y1,X2,Y2: double);
    procedure WriteGraphicHeader;
  public
    property Stream: TStream read FStream write FStream;

  { Report Methods - public }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Start; override;
    procedure Finish; override;
    procedure NewPara; override;
    procedure NewPage; override;
    procedure PrintMemo(MemoBuf: TBaseMemoBuf;
                        Lines: longint;
                        PrintTabs: boolean); override;
    procedure Tab(LeftWidth: integer;
                  RightWidth: integer;
                  TopWidth: integer;
                  BottomWidth: integer;
                  ShadeOverride: integer); override;
    procedure TabRectangle(X1,Y1,X2,Y2: double); override;

  { Supported drawing functions }
    procedure Ellipse(X1,Y1,X2,Y2: double); override;
    procedure LineTo(X,Y: double); override;
    procedure MoveTo(X,Y: double); override;
    procedure Rectangle(X1,Y1,X2,Y2: double); override;
    procedure RoundRect(X1,Y1,X2,Y2,X3,Y3: double); override;
    procedure TextRect(      Rect: TRect;
                             X,Y: double;
                       const Text: string); override;
    procedure PrintData(Value: string); override;

  { Unsupported drawing functions }
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
    procedure FillRect(const Rect: TRect); override;
    procedure FloodFill(X,Y: double;
                        Color: TColor;
                        FillStyle: TFillStyle); override;
    procedure FrameRect(const Rect: TRect); override;
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
    procedure StretchDraw(const Rect: TRect;
                                Graphic: TGraphic); override;
    procedure PrintDataStream(Stream: TStream;
                              BufSize: longint); override;

  published
    property FirstPage;
    property LastPage;
    property StatusLabel;
    property StatusFormat;
    property StatusText;
    property LineHeightMethod default lhmFont;
    property LinesPerInch;
    property Units;
    property UnitsFactor;
    property MarginLeft;
    property MarginRight;
    property MarginTop;
    property MarginBottom;
    property Orientation;
    property FileName: TFileName read FOutputFileName write FOutputFileName;
    property StreamMode: TStreamMode read FStreamMode write FStreamMode default smMemory;

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
  end; { TRTFFiler }

implementation

{*************************************************************************}
{                            class TRTFFiler                              }
{*************************************************************************}

  constructor TRTFFiler.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);

    LineHeightMethod := lhmFont;
    UseFinal := false;
    FOutputFileName := '';
  end;  { Create }

  destructor TRTFFiler.Destroy;

  begin { Destroy }
    inherited Destroy;
  end;  { Destroy }

  function TRTFFiler.Destination: TDestination;

  begin { Destination }
    Result := destCustomFile;
  end;  { Destination }

  function TRTFFiler.GetCanvas: TCanvas;

  begin { GetCanvas }
    If NoPrinters then begin
      Result := (Owner as TForm).Canvas;
    end else begin
      Result := LocalDevice.Canvas;
    end; { else }
  end;  { GetCanvas }

  procedure TRTFFiler.WriteStr(Value: string);

  begin { WriteStr }
    If Value = '' then Exit;
    If UseFinal then begin
      FinalStream.WriteBuffer(Value[1],Length(Value));
    end else begin
      FileWrite(WorkFile,Value[1],Length(Value));
    end; { else }
  end;  { WriteStr }

  procedure TRTFFiler.WriteLine(Value: string);

  begin { WriteLine }
    WriteStr(Value + #13#10);
  end;  { WriteLine }

  procedure TRTFFiler.WriteXTwips(Command: string;
                                  Value: double);

  begin { WriteXTwips }
    WriteStr(Command + IntToStr(Round(XU2I(Value) * 1440)));
  end;  { WriteXTwips }

  procedure TRTFFiler.WriteYTwips(Command: string;
                                  Value: double);

  begin { WriteYTwips }
    WriteStr(Command + IntToStr(Round(YU2I(Value) * 1440)));
  end;  { WriteYTwips }

  procedure TRTFFiler.WritePara(Justify: TTabJustify);

  var
    TempTab: PTab;
    TempJust: TPrintJustify;

  begin { WritePara }
    If OnNewDoc then begin
      WriteStr('\paperw' + IntToStr(Round(1440 * XU2I(PageWidth))));
      WriteStr('\paperh' + IntToStr(Round(1440 * YU2I(PageHeight))));
      WriteStr('\margl' + IntToStr(Round(1440 * XU2I(FLeftMarginWidth))));
      WriteStr('\margr' + IntToStr(Round(1440 * XU2I(FRightMarginWidth))));
      WriteStr('\margt' + IntToStr(Round(1440 * YU2I(FTopMarginWidth))));
      WriteStr('\margb' + IntToStr(Round(1440 * YU2I(FBottomMarginWidth))));
      If Orientation = poLandscape then begin
        WriteStr('\landscape');
      end; { if }
      WriteStr('\lytprtmet');
      OnNewDoc := false;
    end; { if }

    If OnNewPara then begin
      If ParaJustify = tjNone then begin
        ParaJustify := Justify;
      end; { if }
      WriteLine(''); { Begin new line }
      Case ParaJustify of
        tjLeft: WriteStr('\pard\ql ');
        tjRight: WriteStr('\pard\qr ');
        tjCenter: WriteStr('\pard\qc ');
        tjBlock: WriteStr('\pard\qj ');
      end; { case }
      OnNewPara := false;

    { Output tab settings if any }
      TempTab := TabHead;
      While Assigned(TempTab) do begin
        With TempTab^ do begin
          If TabJustify = tjNone then begin
            TempJust := Justify;
          end else begin
            TempJust := TPrintJustify(TabJustify);
          end; { else }
          Case TempJust of
            pjCenter: begin
              WriteStr('\tqc\tx' + IntToStr(Round(1440 * (Pos - FLeftMargin +
               Width / 2.0))));
            end;
            pjRight: begin
              WriteStr('\tqr\tx' + IntToStr(Round(1440 * (Pos - FLeftMargin +
               Width - Margin))));
            end;
            else begin
              WriteStr('\tx' + IntToStr(Round(1440 * (Pos - FLeftMargin +
               Margin))));
            end;
          end; { case }
          TempTab := TempTab^.Next;
        end; { with }
      end; { while }
    end; { if }
  end;  { WritePara }

  function TRTFFiler.GetFontIndex: integer;

  var
    I1: integer;

  begin { GetFontIndex }
    Result := -1;
    For I1 := 0 to (FontTable.Count - 1) do begin
      If UpperCase(FontTable[I1]) = UpperCase(BaseFont.Name) then begin
        Result := I1;
        Break;
      end; { if }
    end; { for }
    If Result < 0 then begin
      FontTable.Add(BaseFont.Name);
      Result := FontTable.Count - 1;
    end; { if }
  end;  { GetFontIndex }

  procedure TRTFFiler.WriteFont;

  begin { WriteFont }
    SelectRPFont;
    With BaseFont do begin
    { Write out font characteristics }
      WriteStr('\f' + IntToStr(GetFontIndex) + '\fs' + IntToStr(Round(Size * 2)));
      If Bold then begin
        WriteStr('\b');
      end else begin
        WriteStr('\b0');
      end; { else }
      If Italic then begin
        WriteStr('\i');
      end else begin
        WriteStr('\i0');
      end; { else }
      If Underline then begin
        WriteStr('\ul');
      end else begin
        WriteStr('\ul0');
      end; { else }
      If Strikeout then begin
        WriteStr('\strike');
      end else begin
        WriteStr('\strike0');
      end; { else }
      If Superscript then begin
        WriteStr('\super');
      end else if SubScript then begin
        WriteStr('\sub');
      end else begin
        WriteStr('\nosupersub');
      end; { else }
    end; { with }
    WriteStr(' ');
    SelectCanvasFont;
  end;  { WriteFont }

  procedure TRTFFiler.WriteBinary(var Buffer;
                                      Size: longint);

  const
    HexDigit: string[16] = '0123456789abcdef';

  var
    B1: PByte;
    Count: byte;

  begin { WriteBinary }
    B1 := @Buffer;
    Count := 0;
    While Size > 0 do begin
      WriteStr(HexDigit[B1^ div 16 + 1] + HexDigit[B1^ mod 16 + 1]);
      Dec(Size);
      Inc(Count);
      Inc(B1);
      If (Count = 64) or (Size = 0) then begin
        WriteLine('');
        Count := 0;
      end; { if }
    end; { while }
  end;  { WriteBinary }

  procedure TRTFFiler.WriteText(Text: string);

  var
    I1: integer;

  begin { WriteText }
  { Look for any special characters }
    I1 := 0;
    While I1 < Length(Text) do begin
      Inc(I1);
      If Text[I1] in ['\','{','}'] then begin
        Insert('\',Text,I1);
        Inc(I1);
      end; { if }
    end; { while }
    WriteStr(Text);
  end;  { WriteText }

{ Text Output routines }

  procedure TRTFFiler.PrintText(Text: string);

  var
    I1: longint;
    S1: string;

  begin { PrintText }
    If IgnoreRPTF or (System.Pos(RPTFPrefix,Text) = 0) then begin
      WriteFont;
      WriteText(Text);
    end else begin
      I1 := 1;
      While I1 <= Length(Text) do begin
        S1 := NextPiece(Self,Text,I1);
        WriteFont;
        WriteText(S1);
      end; { while }
    end; { else }
  end;  { PrintText }

  procedure TRTFFiler.PrintCenterInch(Text: string;
                                      Pos: double);

  begin { PrintCenterInch }
    CheckPrinting;
    If OutputInvalid or (Text = '') then Exit;

    WritePara(tjCenter);
    PrintText(Text);

    ProcessMessages;
  end;  { PrintCenterInch }

  procedure TRTFFiler.PrintLeftInch(Text: string;
                                    Pos: double);

  begin { PrintLeftInch }
    CheckPrinting;
    If OutputInvalid or (Text = '') then Exit;

    WritePara(tjLeft);
    PrintText(Text);

    ProcessMessages;
  end;  { PrintLeftInch }

  procedure TRTFFiler.PrintRightInch(Text: string;
                                     Pos: double);

  begin { PrintRightInch }
    CheckPrinting;
    If OutputInvalid or (Text = '') then Exit;

    WritePara(tjRight);
    PrintText(Text);

    ProcessMessages;
  end;  { PrintRightInch }

  procedure TRTFFiler.PrintBlockInch(Text: string;
                                     Pos: double;
                                     Width: double);

  begin { PrintBlockInch }
    CheckPrinting;
    If OutputInvalid or (Text = '') then Exit;

    WritePara(tjBlock);
    PrintText(Text);

    ProcessMessages;
  end;  { PrintBlockInch }

  procedure TRTFFiler.NewPara;

  begin { NewPara }
    WriteStr('\par ');
    OnNewPara := true;
    ParaJustify := tjNone;
  end;  { NewPara }

  procedure TRTFFiler.NewPage;

  begin { NewPage }
    PrintFooterEvent;
    ExecuteReportEvent(EndPageList);

    inherited NewPage;
    WriteStr('\page ');

    ExecuteReportEvent(BeginPageList);
    NewPageEvent;
    If FColumns > 1 then begin
      NewColumnEvent;
    end; { if }
    PrintHeaderEvent;
  end;  { NewPage }

  procedure TRTFFiler.PrintMemo(MemoBuf: TBaseMemoBuf;
                                Lines: longint;
                                PrintTabs: boolean);

  begin { PrintMemo }
    With MemoBuf do begin
      Case RTFMode of
        0,1: begin { Indented memos }
          KeepSpaces := true;
          HardLines := false;
          WritePara(TTabJustify(Justify));
          WriteStr('\li' + IntToStr(Round(1440 * (XU2I(PrintStart) -
           FLeftMargin))));
          WriteStr('\ri' + IntToStr(Round(1440 * (FRightMargin -
           XU2I(PrintEnd)))) + ' ');
        end;
        2: begin { Tabbed memos }
          KeepSpaces := false;
          HardLines := true;
        end;
      end; { case }
    end; { with }
    inherited PrintMemo(MemoBuf,Lines,PrintTabs);
  end;  { PrintMemo }

  procedure TRTFFiler.Tab(LeftWidth: integer;
                          RightWidth: integer;
                          TopWidth: integer;
                          BottomWidth: integer;
                          ShadeOverride: integer);

  begin { Tab }
    WritePara(tjLeft);
    WriteFont;
    inherited Tab(LeftWidth,RightWidth,TopWidth,BottomWidth,ShadeOverride);
    If OnTab and ((XI2U(CurrentTab^.Pos + CurrentTab^.Margin) > MarginLeft) or
     (CurrentTab^.Justify <> pjLeft)) then begin
      WriteStr('\tab ');
    end; { if }
  end;  { Tab }

{ Graphics output functions }

  procedure TRTFFiler.WriteGraphicPen;

  begin { WriteGraphicPen }
    Case Canvas.Pen.Style of
      psSolid: WriteStr('\dplinesolid');
      psDash: WriteStr('\dplinedash');
      psDot: WriteStr('\dplinedot');
      psDashDot: WriteStr('\dplinedado');
      psDashDotDot: WriteStr('\dplinedadodo');
      psClear: WriteStr('\dplinehollow');
    end; { case }
    WriteStr('\dplinecor' + IntToStr(GetRValue(Canvas.Pen.Color)));
    WriteStr('\dplinecog' + IntToStr(GetGValue(Canvas.Pen.Color)));
    WriteStr('\dplinecob' + IntToStr(GetBValue(Canvas.Pen.Color)));
    WriteXTwips('\dplinew',XI2U(Canvas.Pen.Width / FXDPI));
  end;  { WriteGraphicPen }

  procedure TRTFFiler.WriteGraphicBrush;

  begin { WriteGraphicBrush }
    WriteStr('\dpfillfgcr255\dpfillfgcg255\dpfillfgcb255');
    WriteStr('\dpfillbgcr' + IntToStr(GetRValue(Canvas.Brush.Color)));
    WriteStr('\dpfillbgcg' + IntToStr(GetGValue(Canvas.Brush.Color)));
    WriteStr('\dpfillbgcb' + IntToStr(GetBValue(Canvas.Brush.Color)));
    WriteStr('\dpfillpat');
    Case Canvas.Brush.Style of
      bsClear: WriteStr('0');
      bsSolid: WriteStr('1');
      bsHorizontal: WriteStr('20');
      bsVertical: WriteStr('21');
      bsFDiagonal: WriteStr('22');
      bsBDiagonal: WriteStr('23');
      bsCross: WriteStr('24');
      bsDiagCross: WriteStr('25');
    end; { case }
  end;  { WriteGraphicBrush }

  procedure TRTFFiler.WriteGraphicRect(X1,Y1,X2,Y2: double);

  begin { WriteGraphicRect }
    If X1 < X2 then begin
      WriteXTwips('\dpx',X1);
    end else begin
      WriteXTwips('\dpx',X2);
    end; { else }
    If Y1 < Y2 then begin
      WriteYTwips('\dpy',Y1);
    end else begin
      WriteYTwips('\dpy',Y2);
    end; { else }
    WriteXTwips('\dpxsize',Abs(X1 - X2));
    WriteYTwips('\dpysize',Abs(Y1 - Y2));
  end;  { WriteGraphicRect }

  procedure TRTFFiler.WriteGraphicHeader;

  begin { WriteGraphicHeader }
    WriteLine('');
    WriteStr('{\*\do\dolock\dobxpage\dobypage');
  end;  { WriteGraphicHeader }

  procedure TRTFFiler.Ellipse(X1,Y1,X2,Y2: double);

  begin { Ellipse }
    WriteGraphicHeader;
    WriteStr('\dpellipse');
    WriteGraphicRect(X1,Y1,X2,Y2);
    WriteGraphicPen;
    WriteGraphicBrush;
    WriteStr('}');
  end;  { Ellipse }

  procedure TRTFFiler.LineTo(X,Y: double);

  var
    CompareX: boolean;
    CompareY: boolean;

  begin { LineTo }
    WriteGraphicHeader;
    WriteStr('\dpline');
    CompareX := X <= LastGraphicX;
    CompareY := Y <= LastGraphicY;
    WriteXTwips('\dpptx',0);
    If CompareX = CompareY then begin
      WriteYTwips('\dppty',0);
      WriteXTwips('\dpptx',Abs(X - LastGraphicX));
      WriteYTwips('\dppty',Abs(Y - LastGraphicY));
    end else begin
      WriteYTwips('\dppty',Abs(Y - LastGraphicY));
      WriteXTwips('\dpptx',Abs(X - LastGraphicX));
      WriteYTwips('\dppty',0);
    end; { else }
    WriteGraphicRect(X,Y,LastGraphicX,LastGraphicY);
    WriteGraphicPen;
    WriteStr('}');
    MoveTo(X,Y);
  end;  { LineTo }

  procedure TRTFFiler.MoveTo(X,Y: double);

  begin { MoveTo }
    LastGraphicX := X;
    LastGraphicY := Y;
  end;  { MoveTo }

  procedure TRTFFiler.Rectangle(X1,Y1,X2,Y2: double);

  begin { Rectangle }
    WriteGraphicHeader;
    WriteStr('\dprect');
    WriteGraphicRect(X1,Y1,X2,Y2);
    WriteGraphicPen;
    WriteGraphicBrush;
    WriteStr('}');
  end;  { Rectangle }

  procedure TRTFFiler.RoundRect(X1,Y1,X2,Y2,X3,Y3: double);

  begin { RoundRect }
    WriteGraphicHeader;
    WriteStr('\dprect\dproundr');
    WriteGraphicRect(X1,Y1,X2,Y2);
    WriteGraphicPen;
    WriteGraphicBrush;
    WriteStr('}');
  end;  { RoundRect }

  procedure TRTFFiler.TextRect(      Rect: TRect;
                                     X,Y: double;
                               const Text: string);

  begin { TextRect }
    WriteFont;
    WriteGraphicHeader;
    WriteStr('\dptxbx\dptxbxmar20');
    WriteStr('{\dptxbxtext {\f' + IntToStr(GetFontIndex) + '\fs' +
     IntToStr(Round(BaseFont.Size * 2)) + ' ');
    WriteText(Text);
    WriteStr('\par}}');
    WriteGraphicRect(XD2U(Rect.Left),YD2U(Rect.Top),XD2U(Rect.Right),YD2U(Rect.Bottom));
    WriteStr('\dplinehollow\dplinecor0\dplinecog0\dplinecob0\dplinew1');
    WriteStr('\dpfillfgcr255\dpfillfgcg255\dpfillfgcb255');
    WriteStr('\dpfillbgcr255\dpfillbgcg255\dpfillbgcb255\dpfillpat0');
    WriteStr('}');
  end;  { TextRect }

  procedure TRTFFiler.PrintData(Value: string);

  begin { PrintData }
    WriteStr(Value);
  end;  { PrintData }

  procedure TRTFFiler.TabRectangle(X1,Y1,X2,Y2: double);

  begin { TabRectangle }
  end;  { TabRectangle }

(* Test output of bitmap data
  procedure TRTFFiler.PrintBitmapRect(X1,Y1,X2,Y2: double;
                                      Bitmap: TBitmap);

  var
    MetaFile: TMetaFile;
    MetaStream: TMemoryStream;

  begin { PrintBitmapRect }
    MetaFile := TMetaFile.Create;
    With MetaFile do begin
      Enhanced := false;
      Width := Bitmap.Width;
      Height := Bitmap.Height;
    end; { with }
    With TMetafileCanvas.Create(MetaFile,0) do try
      Draw(0,0,Bitmap);
    finally
      Free;
    end; { with }
    MetaStream := TMemoryStream.Create;
    MetaFile.SaveToStream(MetaStream);
    WriteBinary(MetaStream.Memory^,MetaStream.Size);
    MetaStream.Free;
    MetaFile.Free;
  end;  { PrintBitmapRect }
*)

{ Unsupported graphics output functions }
  procedure TRTFFiler.Arc(X1,Y1,X2,Y2,X3,Y3,X4,Y4: double); begin end;
  procedure TRTFFiler.BrushCopy(const Dest: TRect;
                                      Bitmap: TBitmap;
                                const Source: TRect;
                                      Color: TColor); begin end;
  procedure TRTFFiler.Chord(X1,Y1,X2,Y2,X3,Y3,X4,Y4: double); begin end;
  procedure TRTFFiler.CopyRect(const Dest: TRect;
                                     Canvas: TCanvas;
                               const Source: TRect); begin end;
  procedure TRTFFiler.Draw(X,Y: double;
                           Graphic: TGraphic); begin end;
  procedure TRTFFiler.DrawFocusRect(const Rect: TRect); begin end;
  procedure TRTFFiler.FillRect(const Rect: TRect); begin end;
  procedure TRTFFiler.FloodFill(X,Y: double;
                                Color: TColor;
                                FillStyle: TFillStyle); begin end;
  procedure TRTFFiler.FrameRect(const Rect: TRect); begin end;
  procedure TRTFFiler.Pie(X1,Y1,X2,Y2,X3,Y3,X4,Y4: double); begin end;
  procedure TRTFFiler.Polygon(const Points: array of TPoint); begin end;
  procedure TRTFFiler.Polyline(const Points: array of TPoint); begin end;
  procedure TRTFFiler.PrintBitmap(X,Y: double;
                                  ScaleX,ScaleY: double;
                                  Bitmap: TBitmap); begin end;
  procedure TRTFFiler.PrintBitmapRect(X1,Y1,X2,Y2: double;
                                      Bitmap: TBitmap); begin end;
  procedure TRTFFiler.PrintImageRect(X1,Y1,X2,Y2: double;
                                     ImageStream: TStream;
                                     ImageType: string); begin end;
  procedure TRTFFiler.StretchDraw(const Rect: TRect;
                                    Graphic: TGraphic); begin end;
  procedure TRTFFiler.PrintDataStream(Stream: TStream;
                                      BufSize: longint); begin end;

  procedure TRTFFiler.Start;

  var
    S1,S2: string[20];
    TempName: PChar;

  begin { Start }
    CheckNotPrinting;

    ReportDateTime := Now;
    FontTable := TStringList.Create;
    FCurrentPage := 0;
    JobPages := 0;
    OnNewPara := true;
    OnNewDoc := true;
    FAborted := false;
    BeforePrintEvent;

  { Create work file }
    try
      S1 := 'RP'#0;
      S2 := '.'#0;
      GetMem(TempName,260);
      GetTempFileName(@S2[1],@S1[1],0,TempName);
      WorkFileName := StrPas(TempName);
      WorkFile := FileCreate(StrPas(TempName));
      FreeMem(TempName,260);

    except
      FileClose(WorkFile);
      MessageDlg(Trans('Error initializing work file'),mtError,[mbOk],0);
      Exit;
    end; { try }

  { Write out job header }
    ResetPrinter;
    FPrinting := true;

  { Init canvas }
    If NoPrinters or (RPDev = nil) then begin
      FXDPI := LocalDevice.XDPI;
      FYDPI := LocalDevice.YDPI;
      StrPCopy(FDriver,Trans('RTF Export'));
      StrPCopy(FDevice,Trans('RTF Export'));
      StrPCopy(FPort,Trans('RTF'));
    end else begin
      RPDev.State := dsIC;
    end; { else }

    GrabFontOnChange;

  { Init first page }
    PushTabs;
    Reset;
    PopTabs;
    Inc(FCurrentPage);
    FPageInvalid := (FCurrentPage < FFirstPage) or (FCurrentPage > FLastPage);
    If not FPageInvalid then begin
      Inc(JobPages);
    end; { if }

    UpdateStatus; { Update status for first page }

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

  procedure TRTFFiler.Finish;

  var
    I1: integer;
    Buf: pointer;
    InNum: integer;
    S1: string[4];
    S2: string[145];
    TempPath: string[128];

  begin { Finish }
    try
    { Print the last footer }
      If not FAborted then begin
        PrintFooterEvent;
      end; { if }
      If not FAborted then begin
        ExecuteReportEvent(EndPageList);
      end; { if }

    { Create final file }
      Case FStreamMode of
        smMemory: begin
          FinalStream := TMemoryStream.Create;
        end;
        smTempFile: begin
          S1 := 'RP'#0;
          SetLength(TempPath,GetTempPath(SizeOf(TempPath) - 1,@TempPath[1]));
          GetTempFileName(@TempPath[1],@S1[1],0,@S2[1]);
          FOutputFileName := StrPas(@S2[1]);
          FinalStream := TFileStream.Create(FOutputFileName,fmCreate);
        end;
        smFile: begin
          FinalStream := TFileStream.Create(FOutputFileName,fmCreate);
        end;
        smUser: begin
          If FStream = nil then begin
            RaiseError(Trans('StreamMode is smUser but Stream is nil'));
          end; { if }
          FinalStream := FStream;
          FinalStream.Position := 0;
        end;
      end; { case }

    { Transfer items to final file along with fonts and colors }
      UseFinal := true;

    { Write the header }
      WriteLine('{\rtf1\ansi');

    { Write the font table }
      WriteLine('{\fonttbl');
      For I1 := 0 to (FontTable.Count - 1) do begin
        WriteLine('{\f' + IntToStr(I1) + '\fcharset0\fprq0 ' + FontTable[I1] + ';}');
      end; { for }
      WriteLine('}');

    { Transfer all items in WorkFile to FinalFile }
      FileSeek(WorkFile,0,0);
      GetMem(Buf,4096);
      InNum := 4096;
      Repeat
        InNum := FileRead(WorkFile,Buf^,InNum);
        FinalStream.WriteBuffer(Buf^,InNum);
      until InNum = 0;
      FreeMem(Buf,4096);
      FontTable.Free;

    { Finish off RTF stream }
      WriteLine('}');

    { Close final file }
      UseFinal := false;
      If FStreamMode = smMemory then begin
        With FinalStream as TMemoryStream do begin
          SaveToFile(FOutputFilename);
        end; { with }
      end; { if }
      If (FStreamMode <> smUser) and (FinalStream <> nil) then begin
        FinalStream.Free;
      end; { if }

    { Close/Erase work file }
      FileClose(WorkFile);
      SysUtils.DeleteFile(WorkFileName);
    finally
      ReleaseFontOnChange;
      FPrinting := false;
      AfterPrintEvent;
    end; { try }
  end;  { Finish }

end.