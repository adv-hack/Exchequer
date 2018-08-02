{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPTXFilr;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Dialogs,
  Forms, StdCtrls, RPDefine, RPBase, RPDevice;

type
  PTextItem = ^TTextItem;
  TTextItem = packed record
    Col: integer;
    Line: integer;
    Data: string;
  end; { TTextItem }

{*************************************************************************}
{                            class TTextFiler                             }
{*************************************************************************}

  TTextFiler = class(TBaseReport)
  protected
    FOutputFileName: TFileName; { Filename of text file }
    FOutputFile: text; { Text file to write to }
    FCPI: double; { Characters per inch }
    FLPI: double; { Lines per inch }
    PageList: TList; { List of LineLists which are lists of TTextItems }
    FLeftBorder: double; { Spacing on left of page }
    FTopBorder: double; { Spacing on top of page }
    FFormFeed: boolean; { Show FormFeedStr be printed? }
    FFormFeedStr: string; { String to print for form feed }

    function ColAt(Pos: double): integer;
    function LineAt(Pos: double): integer;
    procedure ClearPageList;
    procedure AddTextItem(TextItem: PTextItem;
                          Line: integer);
    procedure WriteStr(Value: string);
    procedure WritePage;

  { Abstract Output Methods - protected }
    procedure PrintText(Text: string;
                        Pos: double);
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
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetTextExtent(Value: string): TSize; override;

    procedure Start; override;
    procedure Finish; override;
    procedure NewPage; override;
    procedure NewPara; override;
    function TextWidth(Text: string): double; override;
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
    procedure PrintDataStream(Stream: TStream;
                              BufSize: longint); override;
    procedure Rectangle(X1,Y1,X2,Y2: double); override;
    procedure RoundRect(X1,Y1,X2,Y2,X3,Y3: double); override;
    procedure StretchDraw(const Rect: TRect;
                                Graphic: TGraphic); override;
    procedure TabRectangle(X1,Y1,X2,Y2: double); override;
    procedure TextRect(      Rect: TRect;
                             X,Y: double;
                       const Text: string); override;

  { Public properties }
    property FormFeedStr: string read FFormFeedStr write FFormFeedStr;
  published
    property FileName: TFileName read FOutputFileName write FOutputFileName;
    property TopBorder: double read FTopBorder write FTopBorder;
    property LeftBorder: double read FLeftBorder write FLeftBorder;
    property CPI: double read FCPI write FCPI;
    property LPI: double read FLPI write FLPI;
    property FormFeed: boolean read FFormFeed write FFormFeed default true;
    property StatusLabel;
    property StatusFormat;
    property StatusText;
    property Units;
    property UnitsFactor;
    property MarginLeft;
    property MarginRight;
    property MarginTop;
    property MarginBottom;

  { Event properties - potential published }
    property OnPrint;
    property OnPrintPage;
    property OnBeforePrint;
    property OnAfterPrint;
    property OnNewPage;
    property OnNewColumn;
    property OnPrintHeader;
    property OnPrintFooter;
    property OnEndOfSection;
  end; { TTextFiler }

implementation

  function MakeSpaces(Count: byte): string;

  begin { MakeSpaces }
    SetLength(Result,Count);
    If Count > 0 then begin
      FillChar(Result[1],SizeOf(Result[1]) * Count,' ');
    end; { if }
  end;  { MakeSpaces }

{*************************************************************************}
{                            class TTextFiler                             }
{*************************************************************************}

  constructor TTextFiler.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);
    FOutputFileName := '';
    PageList := TList.Create;
    FFormFeed := true;
    FFormFeedStr := #12;
    FCPI := 10;
    FLPI := 6;
  end;  { Create }

  destructor TTextFiler.Destroy;

  begin { Destroy }
    ClearPageList;
    PageList.Free;
    inherited Destroy;
  end;  { Destroy }

  function TTextFiler.GetTextExtent(Value: string): TSize;

  begin { GetTextExtent }
    Result.cX := Round(TextWidth(Value) * XDPI);
  end;  { GetTextExtent }

  function TTextFiler.ColAt(Pos: double): integer;

  begin { ColAt }
    Result := Round((OriginX + Pos - FLeftBorder) * CPI + 0.4999);
    If Result < 1 then begin
      Result := 1;
    end; { if }
  end;  { ColAt }

  function TTextFiler.LineAt(Pos: double): integer;

  begin { LineAt }
    Result := Round((OriginY + Pos - FTopBorder) * LPI + 0.4999);
    If Result < 1 then begin
      Result := 1;
    end; { if }
  end;  { LineAt }

  procedure TTextFiler.ClearPageList;

  begin { ClearPageList }
    With PageList do begin
      While Count > 0 do begin
        With TList(Items[Count - 1]) do begin
          While Count > 0 do begin { Delete all TextItems }
            Dispose(PTextItem(Items[Count - 1]));
            Delete(Count - 1);
          end; { while }
          Free; { Free LineList }
        end; { with }
        Delete(Count - 1); { Delete LineList from PageList }
      end; { while }
    end; { with }
  end;  { ClearPageList }

  procedure TTextFiler.AddTextItem(TextItem: PTextItem;
                                   Line: integer);

  var
    I1: integer;

  begin { AddTextItem }
    While PageList.Count < Line do begin { Add LineLists }
      PageList.Add(TList.Create);
    end; { while }
    With TList(PageList[Line - 1]) do begin { Find insert spot }
      For I1 := 0 to (Count - 1) do begin
        If PTextItem(Items[I1])^.Col > TextItem^.Col then begin
          Insert(I1,TextItem);
          Exit;
        end; { if }
      end; { for }
      Add(TextItem);
    end; { with }
  end;  { AddTextItem }

  procedure TTextFiler.WriteStr(Value: string);

  begin { WriteStr }
    Write(FOutputFile,Value);
  end;  { WriteStr }

  procedure TTextFiler.WritePage;

  var
    I1: integer;
    Line: integer;
    LineList: TList;
    TextItem: PTextItem;
    CurrentPos: integer;

  begin { WritePage }
  { Process through PageList and output TextItems }
    For Line := 1 to PageList.Count do begin
      LineList := PageList[Line - 1];
      CurrentPos := 1;
      For I1 := 0 to LineList.Count - 1 do begin
        TextItem := PTextItem(LineList[I1]);
        With TextItem^ do begin
          If Col > CurrentPos then begin
            WriteStr(MakeSpaces(Col - CurrentPos));
          end else if Col < CurrentPos then begin
            WriteStr(#13 + MakeSpaces(Col - 1));
          end; { else }
          WriteStr(Data);
          CurrentPos := Col + Length(Data); { Need to strip out escape chars }
        end; { with }
      end; { for }
      WriteStr(#13#10);
    end; { for }

    If FormFeed then begin
      WriteStr(FormFeedStr);
    end; { if }
    ClearPageList;
  end;  { WritePage }

{ Text Output routines }

  procedure TTextFiler.PrintText(Text: string;
                                 Pos: double);

  var
    TextItem: PTextItem;

  begin { PrintText }
  { Create TTextItem }
    New(TextItem);
    With TextItem^ do begin
      Col := ColAt(Pos);
      Data := Text;
    end; { with }
    AddTextItem(TextItem,LineAt(FCursorYPos));
    FCursorXPos := Pos + TextWidth(Text);
  end;  { PrintText }

  procedure TTextFiler.PrintCenterInch(Text: string;
                                       Pos: double);

  begin { PrintCenterInch }
    CheckPrinting;
    If OutputInvalid or (Text = '') then Exit;
    PrintText(Text,Pos - (TextWidth(Text) / 2.0));
    ProcessMessages;
  end;  { PrintCenterInch }

  procedure TTextFiler.PrintLeftInch(Text: string;
                                     Pos: double);

  begin { PrintLeftInch }
    CheckPrinting;
    If OutputInvalid or (Text = '') then Exit;
    PrintText(Text,Pos);
    ProcessMessages;
  end;  { PrintLeftInch }

  procedure TTextFiler.PrintRightInch(Text: string;
                                      Pos: double);

  begin { PrintRightInch }
    CheckPrinting;
    If OutputInvalid or (Text = '') then Exit;
    PrintText(Text,Pos - TextWidth(Text));
    ProcessMessages;
  end;  { PrintRightInch }

  procedure TTextFiler.PrintBlockInch(Text: string;
                                      Pos: double;
                                      Width: double);

  begin { PrintBlockInch }
    CheckPrinting;
    If OutputInvalid or (Text = '') then Exit;
    PrintText(Text,Pos);
    ProcessMessages;
  end;  { PrintBlockInch }

  function TTextFiler.Destination: TDestination;

  begin { Destination }
    Result := destCustomFile;
  end;  { Destination }

  function TTextFiler.GetCanvas: TCanvas;

  begin { GetCanvas }
    If NoPrinters then begin
      Result := (Owner as TForm).Canvas;
    end else begin
      Result := LocalDevice.Canvas;
    end; { else }
  end;  { GetCanvas }

  function TTextFiler.TextWidth(Text: string): double;

  begin { TextWidth }
    Result := Length(Text) / CPI;
  end;  { TextWidth }

  procedure TTextFiler.NewPage;

  begin { NewPage }
    PrintFooterEvent;
    ExecuteReportEvent(EndPageList);

    WritePage;
    inherited NewPage;

    ExecuteReportEvent(BeginPageList);
    NewPageEvent;
    If FColumns > 1 then begin
      NewColumnEvent;
    end; { if }
    PrintHeaderEvent;
  end;  { NewPage }

  procedure TTextFiler.NewPara;

  var
    Line: integer;

  begin { NewPara }
    Line := LineAt(FCursorYPos);
    While PageList.Count < Line do begin { Add LineLists }
      PageList.Add(TList.Create);
    end; { while }
  end;  { NewPara }

  procedure TTextFiler.PrintData(Value: string);

  begin { PrintData }
    WriteStr(Value);
  end;  { PrintData }

{ Unsupported graphics output functions }
  procedure TTextFiler.Arc(X1,Y1,X2,Y2,X3,Y3,X4,Y4: double); begin end;
  procedure TTextFiler.BrushCopy(const Dest: TRect;
                                       Bitmap: TBitmap;
                                 const Source: TRect;
                                       Color: TColor); begin end;
  procedure TTextFiler.Chord(X1,Y1,X2,Y2,X3,Y3,X4,Y4: double); begin end;
  procedure TTextFiler.CopyRect(const Dest: TRect;
                                      Canvas: TCanvas;
                                const Source: TRect); begin end;
  procedure TTextFiler.Draw(X,Y: double;
                            Graphic: TGraphic); begin end;
  procedure TTextFiler.DrawFocusRect(const Rect: TRect); begin end;
  procedure TTextFiler.Ellipse(X1,Y1,X2,Y2: double); begin end;
  procedure TTextFiler.FillRect(const Rect: TRect); begin end;
  procedure TTextFiler.FloodFill(X,Y: double;
                                 Color: TColor;
                                 FillStyle: TFillStyle); begin end;
  procedure TTextFiler.FrameRect(const Rect: TRect); begin end;
  procedure TTextFiler.LineTo(X,Y: double); begin end;
  procedure TTextFiler.MoveTo(X,Y: double); begin end;
  procedure TTextFiler.Pie(X1,Y1,X2,Y2,X3,Y3,X4,Y4: double); begin end;
  procedure TTextFiler.Polygon(const Points: array of TPoint); begin end;
  procedure TTextFiler.Polyline(const Points: array of TPoint); begin end;
  procedure TTextFiler.PrintBitmap(X,Y: double;
                                   ScaleX,ScaleY: double;
                                   Bitmap: TBitmap); begin end;
  procedure TTextFiler.PrintBitmapRect(X1,Y1,X2,Y2: double;
                                      Bitmap: TBitmap); begin end;
  procedure TTextFiler.PrintImageRect(X1,Y1,X2,Y2: double;
                                      ImageStream: TStream;
                                      ImageType: string); begin end;
  procedure TTextFiler.PrintDataStream(Stream: TStream;
                                       BufSize: longint); begin end;
  procedure TTextFiler.Rectangle(X1,Y1,X2,Y2: double); begin end;
  procedure TTextFiler.RoundRect(X1,Y1,X2,Y2,X3,Y3: double); begin end;
  procedure TTextFiler.StretchDraw(const Rect: TRect;
                                         Graphic: TGraphic); begin end;
  procedure TTextFiler.TabRectangle(X1,Y1,X2,Y2: double); begin end;
  procedure TTextFiler.TextRect(      Rect: TRect;
                                      X,Y: double;
                                const Text: string); begin end;

  procedure TTextFiler.Start;

  begin { Start }
    CheckNotPrinting;

    ReportDateTime := Now;
    FCurrentPage := 0;
    JobPages := 0;
    FAborted := false;

    BeforePrintEvent;

  { Create output file }
    try
      AssignFile(FOutputFile,FOutputFileName);
      Rewrite(FOutputFile);
    except
      CloseFile(FOutputFile);
      MessageDlg(Trans('Error initializing text output file'),mtError,[mbOk],0);
      Exit;
    end; { try }

    ResetPrinter;
    FPrinting := true;

  { Init canvas }
    If (RPDev = nil) or NoPrinters then begin
      FXDPI := LocalDevice.XDPI;
      FYDPI := LocalDevice.YDPI;
      StrPCopy(FDriver,Trans('Text Export'));
      StrPCopy(FDevice,Trans('Text Export'));
      StrPCopy(FPort,FOutputFileName);
    end else begin
      RPDev.State := dsIC;
    end; { else }

    GrabFontOnChange;

  { Init first page }
    Reset;
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

  procedure TTextFiler.Finish;

  begin { Finish }
    try
    { Print the last footer }
      If not FAborted then begin
        PrintFooterEvent;
      end; { if }
      If not FAborted then begin
        ExecuteReportEvent(EndPageList);
      end; { if }

    { Write out contents of last page to output file }
      WritePage;

    { Close output file }
      CloseFile(FOutputFile);
    finally
      ReleaseFontOnChange;
      FPrinting := false;
      AfterPrintEvent;
    end; { try }
  end;  { Finish }

end.
