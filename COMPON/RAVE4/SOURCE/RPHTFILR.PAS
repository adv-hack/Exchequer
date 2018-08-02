{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPHTFilr;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, RPDefine, RPBase, RPDevice;

type
{*************************************************************************}
{                         class TRPHTMLFiler                              }
{*************************************************************************}

  TRPHTMLFiler = class(TBaseReport)
  protected
    FStream: TStream;
    FStreamMode: TStreamMode;
    UseFinal: boolean;
    WorkFile:  integer;
    WorkFileName: string;
    FinalStream: TStream;
    OnNewPara: boolean;
    OnNewDoc: boolean;
    FOutputFileName: TFileName;
    FInputFileName: TFileName;
    FReplaceToken: string;
    FontTable: TStringList;
    LastGraphicX: double;
    LastGraphicY: double;
    FTitle: string;
    FTableTagStarted: boolean;
    FInTabCell: boolean;
    FTableAttributes: string;
    FParagraphAttributes: string;
    FMasterFileLines: TStringList;
    FTokenEndText: string;
    FRow: integer;
    FCol: integer;
    FScreenDPI: integer;
    FUseTrueType: boolean;
    FEndTabWritten: boolean;

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

    procedure WriteStr(Value: string);
    procedure WriteLine(Value: string);
    procedure WritePageIntro;
    procedure WriteBegFile;
    procedure WriteEndFile;
    procedure WriteBegFont;
    procedure WriteEndFont;
    procedure WriteBinary(var Buffer;
                              Size: longint);
    procedure WriteText(Text: string);
    procedure WriteGraphicPen;
    procedure WriteGraphicBrush;
    procedure WriteGraphicRect(X1,Y1,X2,Y2: double);
    procedure WriteGraphicHeader;
    procedure WriteTable(Text: string; Pos: double; Width: double; Justify: TPrintJustify);
  public
    property Stream: TStream read FStream write FStream;

  { Report Methods - public }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Start; override;
    procedure Finish; override;
    procedure NewPara; override;
    procedure NewPage; override;
    procedure Tab(LeftWidth: integer;
                  RightWidth: integer;
                  TopWidth: integer;
                  BottomWidth: integer;
                  ShadeOverride: integer); override;
    procedure TabRectangle(X1,Y1,X2,Y2: double); override;
    procedure PrintHyperLink(URL, Attributes, Text: string);
    procedure PrintHyperLinkStart(URL, Attributes: string);
    procedure PrintHyperLinkEnd;

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

    procedure PrintImage(URL: string;
                         Width: double;
                         Height: double;
                         Attributes: string);

  published
    property StatusLabel;
    property StatusFormat;
    property StatusText;
    property Units;
    property UnitsFactor;
    property FileName: TFileName read FOutputFileName write FOutputFileName;
    property ReplaceFileName: TFileName read FInputFileName write FInputFileName;
    property ReplaceToken: string read FReplaceToken write FReplaceToken;
    property ScreenDPI: integer read FScreenDPI write FScreenDPI default 96;
    property StreamMode: TStreamMode read FStreamMode write FStreamMode default smMemory;
    property Title: string read FTitle write FTitle;
    property TableAttributes: string read FTableAttributes write FTableAttributes;
    property ParagraphAttributes: string read FParagraphAttributes write FParagraphAttributes;
    property UseTrueType: boolean read FUseTrueType write FUseTrueType;

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
  end; { TRPHTMLFiler }

implementation

const
  CrLfStr = #13#10;

{*************************************************************************}
{                         class TRPHTMLFiler                              }
{*************************************************************************}

  constructor TRPHTMLFiler.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);

    FOutputFileName := '';
    FScreenDPI := 96;
    FEndTabWritten := true;
  end;  { Create }

  destructor TRPHTMLFiler.Destroy;

  begin { Destroy }
    inherited Destroy;
  end;  { Destroy }

  function TRPHTMLFiler.Destination: TDestination;

  begin { Destination }
    Result := destCustomFile;
  end;  { Destination }

  function TRPHTMLFiler.GetCanvas: TCanvas;

  begin { GetCanvas }
    If NoPrinters then begin
      Result := (Owner as TForm).Canvas;
    end else begin
      Result := LocalDevice.Canvas;
    end; { else }
  end;  { GetCanvas }

  procedure TRPHTMLFiler.WriteStr(Value: string);

  begin { WriteStr }
    If Value = '' then Exit;
    If UseFinal then begin
      FinalStream.WriteBuffer(Value[1],Length(Value));
    end else begin
      FileWrite(WorkFile,Value[1],Length(Value));
    end; { else }
  end;  { WriteStr }

  procedure TRPHTMLFiler.WriteLine(Value: string);

  begin { WriteLine }
    WriteStr(Value + '<br>' + CrLfStr);
  end;  { WriteLine }

  procedure TRPHTMLFiler.WritePageIntro;

  begin { WritePageIntro }
    WriteStr('<html>' + CrLfStr + CrLfStr);
    If Trim(Title) <> '' then begin
      WriteStr('<head>' + CrLfStr);
      WriteStr('  <title>' + Title + '</title>' + CrLfStr);
      WriteStr('</head>' + CrLfStr + CrLfStr);
    end; { if }
    WriteStr('<body>' + CrLfStr + CrLfStr);
  end;  { WritePageIntro }

  procedure TRPHTMLFiler.WriteBegFont;

  var
    I1: integer;

  begin { WriteBegFont }
    SelectRPFont;
    With BaseFont do begin

      If Bold then begin
        WriteStr('<b>');
      end; { else }
      If Italic then begin
        WriteStr('<i>');
      end; { else }
      If Underline then begin
        WriteStr('<u>');
      end; { else }

      If not UseTrueType then begin
        If (BaseFont.Name = 'Courier') or (BaseFont.Name = 'Courier New') then begin
          WriteStr(' <pre>');
        end;
      end; { if }

    { Write out font characteristics }
      WriteStr('<font');

      If UseTrueType then begin
        WriteStr(' face="' + BaseFont.Name + '" ');
      end; { if }

      WriteStr(' size="');
      I1 := Round(Size);
      If I1 <= 8 then begin
        WriteStr('1">');
      end else if I1 <= 10 then begin
        WriteStr('2">');
      end else if I1 <= 12 then begin
        WriteStr('3">');
      end else if I1 <= 14 then begin
        WriteStr('4">');
      end else if I1 <= 18 then begin
        WriteStr('5">');
      end else if I1 <= 24 then begin
        WriteStr('6">');
      end else begin
        WriteStr('7">');
      end;

    end; { with }
    SelectCanvasFont;
  end;  { WriteBegFont }

  procedure TRPHTMLFiler.WriteEndFont;

  begin { WriteEndFont }
    SelectRPFont;
    With BaseFont do begin

      WriteStr('</font>');

      If Underline then begin
        WriteStr('</u>');
      end; { else }

      If Italic then begin
        WriteStr('</i>');
      end; { else }

      If Bold then begin
        WriteStr('</b>');
      end; { else }

      If not UseTrueType then begin
        If (BaseFont.Name = 'Courier') or (BaseFont.Name = 'Courier New') then begin
          WriteStr('</pre>');
        end;
      end; { if }

    end; { with }
    SelectCanvasFont;
  end;  { WriteEndFont }

  procedure TRPHTMLFiler.WriteBinary(var Buffer;
                                      Size: longint);

  begin { WriteBinary }
  end;  { WriteBinary }

  procedure TRPHTMLFiler.WriteText(Text: string);

  begin { WriteText }
    WriteBegFont;
    WriteStr(Text);
    WriteEndFont;
  end;  { WriteText }

  procedure TRPHTMLFiler.WriteTable(Text: string; Pos: double; Width: double;
                                                  Justify: TPrintJustify);
  begin { WriteTable }
    If OnTab then begin
      Case Justify of
        pjLeft: begin
          If FEndTabWritten then begin
            WriteStr('<td align="left" width="' +
                        IntToStr(round(CurrentTab^.Width * ScreenDPI)) + '">' + CrLfStr);
            FEndTabWritten := false;
          end; { if }
          WriteBegFont;
          WriteStr(Text + CrLfStr);
          WriteEndFont;
        end; { pjLeft }
        pjBlock: begin
          If FEndTabWritten then begin
            WriteStr('<td width="' +
                      IntToStr(round(CurrentTab^.Width * ScreenDPI)) + '">' + CrLfStr);
            FEndTabWritten := false;
          end; { if }
          WriteStr('<p align="justify">');
          WriteBegFont;
          WriteStr(Text + CrLfStr);
          WriteEndFont;
          WriteStr('</p>' + CrLfStr);
        end; { pjBlock }
        pjCenter: begin
          If FEndTabWritten then begin
            WriteStr('<td align="center" width="' +
                      IntToStr(round(CurrentTab^.Width * ScreenDPI)) + '">' + CrLfStr);
            FEndTabWritten := false;
          end; { if }
          WriteBegFont;
          WriteStr(Text + CrLfStr);
          WriteEndFont;
        end; { pjCenter }
        pjRight: begin
          If FEndTabWritten then begin
            WriteStr('<td align="right" width="' +
                      IntToStr(round(CurrentTab^.Width * ScreenDPI)) + '">' + CrLfStr);
            FEndTabWritten := false;
          end; { if }
          WriteBegFont;
          WriteStr(Text + CrLfStr);
          WriteEndFont;
        end; { pjRight }
      end; { case }
      FInTabCell := true;
      OnTab := false;
    end else begin
      Case Justify of
        pjLeft: begin
          WriteStr('<table border="0" cellpadding="0" cellspacing="0" width="100%">' + CrLfStr);
          WriteStr('<tr>' + CrLfStr);
          WriteStr('<td width="' + IntToStr(Round(Pos * ScreenDPI)) + '">');
          WriteStr('&nbsp;</td>' + CrLfStr);
          WriteStr('<td width="' + IntToStr(round(Width * ScreenDPI)) + '">');
          WriteStr('<p align="left">');
          WriteBegFont;
          WriteStr(Text);
          WriteEndFont;
          WriteStr('</p>' + CrLfStr);
          WriteStr('</td>' + CrLfStr);
          WriteStr('<tr>' + CrLfStr);
          WriteStr('</table>' + CrLfStr);
        end;
        pjBlock: begin
          WriteStr('<table border="0" cellpadding="0" cellspacing="0" width="100%">' + CrLfStr);
          WriteStr('<tr>' + CrLfStr);
          WriteStr('<td width="' + IntToStr(Round(Pos * ScreenDPI)) + '">');
          WriteStr('&nbsp;</td>' + CrLfStr);
          WriteStr('<td width="' + IntToStr(round(Width * ScreenDPI)) + '">');
          WriteStr('<p align="justify">');
          WriteBegFont;
          WriteStr(Text);
          WriteEndFont;
          WriteStr('</p>' + CrLfStr);
          WriteStr('</td>' + CrLfStr);
          WriteStr('<tr>' + CrLfStr);
          WriteStr('</table>' + CrLfStr);
        end;
        pjCenter: begin
          WriteStr('<table border="0" cellpadding="0" cellspacing="0" width="');
          WriteStr(IntToStr(Round(Width * ScreenDPI)) + '">' + CrLfStr);
          WriteStr('<tr>' + CrLfStr);
          WriteStr('<td align="center">');
          WriteBegFont;
          WriteStr(Text + CrLfStr);
          WriteEndFont;
          WriteStr('</td>' + CrLfStr);
          WriteStr('<tr>' + CrLfStr);
          WriteStr('</table>' + CrLfStr);
        end; { pjCenter }
        pjRight: begin
          WriteStr('<table border="0" cellpadding="0" cellspacing="0" width="');
          WriteStr(IntToStr(Round(Width * ScreenDPI)) + '">' + CrLfStr);
          WriteStr('<tr>' + CrLfStr);
          WriteStr('<td align="right">');
          WriteBegFont;
          WriteStr(Text + CrLfStr);
          WriteEndFont;
          WriteStr('</td>' + CrLfStr);
          WriteStr('<tr>' + CrLfStr);
          WriteStr('</table>' + CrLfStr);
        end; { pjCenter }
      end; { case }
    end; { else }
  end;  { WriteTable }

{ Text Output routines }

  procedure TRPHTMLFiler.PrintCenterInch(Text: string;
                                         Pos: double);

  begin { PrintCenterInch }
    WriteTable(Text, Pos, Pos * 2, pjCenter);
  end;  { PrintCenterInch }

  procedure TRPHTMLFiler.PrintLeftInch(Text: string;
                                       Pos: double);

  begin { PrintLeftInch }
    WriteTable(Text, Pos, 0, pjLeft);
  end;  { PrintLeftInch }

  procedure TRPHTMLFiler.PrintRightInch(Text: string;
                                        Pos: double);

  begin { PrintRightInch }
    WriteTable(Text, Pos, Pos, pjRight);
  end;  { PrintRightInch }

  procedure TRPHTMLFiler.PrintBlockInch(Text: string;
                                        Pos: double;
                                        Width: double);

  begin { PrintBlockInch }
    WriteTable(Text, Pos, Width, pjBlock);
  end;  { PrintBlockInch }

  procedure TRPHTMLFiler.NewPara;

  begin { NewPara }
    If FInTabCell then begin
      WriteStr('</td></tr>' + CrLfStr + CrLfStr);
      FInTabCell := false;
      FEndTabWritten := true;
      exit;
    end else begin
      If FTableTagStarted then begin
        WriteStr('</table>' + CrLfStr + CrLfStr);
        WriteStr('</td>' + CrLfStr + '</tr>' + CrLfStr + '</table>' + CrLfStr);
        FTableTagStarted := false;
      end; { if }
    end; { if }
    PrintData(CrLfStr + '<p');
    If Trim(ParagraphAttributes) <> '' then begin
      PrintData(' ' +Trim(ParagraphAttributes) + '>' + CrLfStr);
    end else begin
      PrintData('>' + CrLfStr);
    end; { else }
  end;  { NewPara }

  procedure TRPHTMLFiler.NewPage;

  begin { NewPage }
  end;  { NewPage }

  procedure TRPHTMLFiler.Tab(LeftWidth: integer;
                          RightWidth: integer;
                          TopWidth: integer;
                          BottomWidth: integer;
                          ShadeOverride: integer);

  begin { Tab }
    If OnTab then begin
      WriteStr('</td>' + CrLfStr);
      PrintLeftInch('&nbsp;',CurrentTab^.Pos);
      WriteStr('</td>' + CrLfStr);
      FEndTabWritten := true;
    end else begin
      If FInTabCell and (not FEndTabWritten) then begin
        WriteStr('</td>' + CrLfStr);
        FEndTabWritten := true;
      end; { if }
      If (not FTableTagStarted) and (not FInTabCell) then begin
        WriteStr(CrLfStr + '<table border="0" cellpadding="0" cellspacing="0">' + CrLfStr);
        WriteStr('<tr>' + CrLfStr + CrLfStr);
        WriteStr('<td width="' + IntToStr(round(TabHead^.Pos * ScreenDPI)) + '">' + CrLfStr);
        WriteStr('&nbsp;</td>' + CrLfStr);
        WriteStr('<td>' + CrLfStr + CrLfStr);

        If Trim(FTableAttributes) = '' then begin
          If TabHead^.Left or TabHead^.Right or TabHead^.Top or TabHead^.Bottom then begin
            WriteStr(CrLfStr + '<table border="1" cellpadding="0" cellspacing="0">' + CrLfStr);
          end else begin
            WriteStr(CrLfStr + '<table border="0" cellpadding="0" cellspacing="0">' + CrLfStr);
          end; { else }
        end else begin
          WriteStr(CrLfStr + '<table ' + FTableAttributes + '>' + CrLfStr);
        end; { else }
        FTableTagStarted := true;
      end; { if }
    end; { else }
    inherited Tab(LeftWidth,RightWidth,TopWidth,BottomWidth,ShadeOverride);
  end;  { Tab }

{ Graphics output functions }

  procedure TRPHTMLFiler.WriteGraphicPen;

  begin { WriteGraphicPen }
  end;  { WriteGraphicPen }

  procedure TRPHTMLFiler.WriteGraphicBrush;

  begin { WriteGraphicBrush }
  end;  { WriteGraphicBrush }

  procedure TRPHTMLFiler.WriteGraphicRect(X1,Y1,X2,Y2: double);

  begin { WriteGraphicRect }
  end;  { WriteGraphicRect }

  procedure TRPHTMLFiler.WriteGraphicHeader;

  begin { WriteGraphicHeader }
  end;  { WriteGraphicHeader }

  procedure TRPHTMLFiler.Ellipse(X1,Y1,X2,Y2: double);

  begin { Ellipse }
  end;  { Ellipse }

  procedure TRPHTMLFiler.LineTo(X,Y: double);

  begin { LineTo }
  end;  { LineTo }

  procedure TRPHTMLFiler.MoveTo(X,Y: double);

  begin { MoveTo }
  end;  { MoveTo }

  procedure TRPHTMLFiler.Rectangle(X1,Y1,X2,Y2: double);

  begin { Rectangle }
  end;  { Rectangle }

  procedure TRPHTMLFiler.RoundRect(X1,Y1,X2,Y2,X3,Y3: double);

  begin { RoundRect }
  end;  { RoundRect }

  procedure TRPHTMLFiler.TextRect(      Rect: TRect;
                                     X,Y: double;
                               const Text: string);

  begin { TextRect }
  end;  { TextRect }

  procedure TRPHTMLFiler.PrintData(Value: string);

  begin { PrintData }
    WriteStr(Value);
  end;  { PrintData }

  procedure TRPHTMLFiler.TabRectangle(X1,Y1,X2,Y2: double);

  begin { TabRectangle }
  end;  { TabRectangle }

{ Unsupported graphics output functions }
  procedure TRPHTMLFiler.Arc(X1,Y1,X2,Y2,X3,Y3,X4,Y4: double); begin end;
  procedure TRPHTMLFiler.BrushCopy(const Dest: TRect;
                                      Bitmap: TBitmap;
                                const Source: TRect;
                                      Color: TColor); begin end;
  procedure TRPHTMLFiler.Chord(X1,Y1,X2,Y2,X3,Y3,X4,Y4: double); begin end;
  procedure TRPHTMLFiler.CopyRect(const Dest: TRect;
                                     Canvas: TCanvas;
                               const Source: TRect); begin end;
  procedure TRPHTMLFiler.Draw(X,Y: double;
                           Graphic: TGraphic); begin end;
  procedure TRPHTMLFiler.DrawFocusRect(const Rect: TRect); begin end;
  procedure TRPHTMLFiler.FillRect(const Rect: TRect); begin end;
  procedure TRPHTMLFiler.FloodFill(X,Y: double;
                                Color: TColor;
                                FillStyle: TFillStyle); begin end;
  procedure TRPHTMLFiler.FrameRect(const Rect: TRect); begin end;
  procedure TRPHTMLFiler.Pie(X1,Y1,X2,Y2,X3,Y3,X4,Y4: double); begin end;
  procedure TRPHTMLFiler.Polygon(const Points: array of TPoint); begin end;
  procedure TRPHTMLFiler.Polyline(const Points: array of TPoint); begin end;
  procedure TRPHTMLFiler.PrintBitmap(X,Y: double;
                                  ScaleX,ScaleY: double;
                                  Bitmap: TBitmap); begin end;
  procedure TRPHTMLFiler.PrintBitmapRect(X1,Y1,X2,Y2: double;
                                      Bitmap: TBitmap); begin end;
  procedure TRPHTMLFiler.PrintImageRect(X1,Y1,X2,Y2: double;
                                        ImageStream: TStream;
                                        ImageType: string); begin end;
  procedure TRPHTMLFiler.StretchDraw(const Rect: TRect;
                                    Graphic: TGraphic); begin end;
  procedure TRPHTMLFiler.PrintDataStream(Stream: TStream;
                                      BufSize: longint); begin end;

  procedure TRPHTMLFiler.Start;

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

    If (Trim(ReplaceToken) = '') or (Trim(ReplaceFileName) = '') or
       (not FileExists(ReplaceFileName)) then begin
      WritePageIntro; { html, title and body tags }
    end else begin
      WriteBegFile;
    end; { else }

  { Write out job header }
    ResetPrinter;
    FPrinting := true;

  { Init canvas }
    If (RPDev = nil) or NoPrinters then begin
      FXDPI := LocalDevice.XDPI;
      FYDPI := LocalDevice.YDPI;
      StrPCopy(FDriver,Trans('HTML Export'));
      StrPCopy(FDevice,Trans('HTML Export'));
      StrPCopy(FPort,Trans('HTML'));
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

  procedure TRPHTMLFiler.Finish;

  var
    Buf: pointer;
    InNum: integer;
    S1: string[4];
    S2: string[145];
    TempPath: string[128];

  begin { Finish }
    If FTableTagStarted then begin
      WriteStr('</table>' + CrLfStr + CrLfStr);
      WriteStr('</td>' + CrLfStr + '</tr>' + CrLfStr + '</table>' + CrLfStr);
      FTableTagStarted := false;
    end; { if }

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

    { Finish off HTML stream }
      If (Trim(ReplaceToken) = '') or (Trim(ReplaceFileName) = '') or
         (not FileExists(ReplaceFileName)) then begin
        WriteStr(CrLfStr + CrLfStr + '</body>' + CrLfStr + '</html>' + CrLfStr);
      end else begin
        WriteEndFile;
      end; { else }

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

  procedure TRPHTMLFiler.PrintHyperLink(URL, Attributes, Text: string);

  begin { PrintHyperLink }
    PrintData('<a href="' + URL + '"');
    If Trim(Attributes) <> '' then begin
      PrintData(' ' + Attributes);
    end; { if }
    PrintData('>' + Text + '</a>');
  end;  { PrintHyperLink }

  procedure TRPHTMLFiler.PrintHyperLinkStart(URL, Attributes: string);

  begin { PrintHyperLinkStart }
    If FEndTabWritten and FInTabCell then begin
      case CurrentTab^.Justify of
        pjLeft: WriteStr('<td align="left" width="' +
                IntToStr(round(CurrentTab^.Width * ScreenDPI)) + '">' + CrLfStr);
        pjCenter: WriteStr('<td align="center" width="' +
                IntToStr(round(CurrentTab^.Width * ScreenDPI)) + '">' + CrLfStr);
        pjRight: WriteStr('<td align="right" width="' +
                IntToStr(round(CurrentTab^.Width * ScreenDPI)) + '">' + CrLfStr);
        pjBlock: WriteStr('<td align="justify" width="' +
                IntToStr(round(CurrentTab^.Width * ScreenDPI)) + '">' + CrLfStr);
      end;

      FEndTabWritten := false;
    end; { if }

    PrintData('<a href="' + URL + '"');
    If Trim(Attributes) <> '' then begin
      PrintData(' ' + Attributes);
    end; { if }
    PrintData('>');
  end;  { PrintHyperLinkStart }

  procedure TRPHTMLFiler.PrintHyperLinkEnd;

  begin { PrintHyperLinkEnd }
    PrintData('</a>');
  end;  { PrintHyperLinkEnd }

  procedure TRPHTMLFiler.PrintImage(URL: string;
                                    Width: double;
                                    Height: double;
                                    Attributes: string);

  begin { PrintImage }
    PrintData('<img src="' + URL + '"');
    If Width > 0 then begin
      PrintData(' width="' + IntToStr(Round(XU2I(Width) * ScreenDPI)) + '"');
    end else if Width < 0 then begin
      PrintData(' width="' + IntToStr(Abs(Round(XU2I(Width)))) + '"');
    end; { else }
    If Height > 0 then begin
      PrintData(' height="' + IntToStr(Round(YU2I(Height) * ScreenDPI)) + '"');
    end else if Height < 0 then begin
      PrintData(' height="' + IntToStr(Abs(Round(YU2I(Height)))) + '"');
    end; { else }
    If Trim(Attributes) <> '' then begin
      PrintData(' ' + Attributes);
    end; { if }
    PrintData('>' + CrLfStr);
  end;  { PrintImage }

  procedure TRPHTMLFiler.WriteBegFile;

  begin { WriteBegFile }
    FCol := 0;
    FRow := 0;
    FMasterFileLines := TStringList.Create;
    With FMasterFileLines do begin
      LoadFromFile(Trim(ReplaceFileName));
      While (FRow < Count) and (Pos(ReplaceToken, Strings[FRow]) < 1) do begin
        WriteStr(Strings[FRow] + CrLfStr);
        Inc(FRow);
      end;
      FCol := Pos(ReplaceToken, Strings[FRow]);
      If FCol >= 0 then begin
        WriteStr(copy(Strings[FRow], 0, FCol - 1) + CrLfStr);
        FTokenEndText := copy(Strings[FRow], FCol + Length(ReplaceToken), Length(Strings[FRow]));
      end else begin
        FTokenEndText := '';
      end; { else }
    end; { with }
  end;  { WriteBegFile }

  procedure TRPHTMLFiler.WriteEndFile;

  begin { WriteEndFile }
    With FMasterFileLines do begin
      WriteStr(FTokenEndText + CrLfStr);
      Inc(FRow);
      While FRow < Count do begin
        WriteStr(Strings[FRow] + CrLfStr);
        Inc(FRow);
      end; { while }
    end; { with }
    FMasterFileLines.Free;
  end;  { WriteEndFile }

end.