{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPRender;

interface

uses
  {$IFDEF Linux}
  QGraphics, Types,
  {$ELSE}
  Graphics,
  Windows,
  {$ENDIF}
  RPDefine,
  Classes,
  SysUtils;

type
  TRPRender = class;

  TRPConverter = class(TObject)
  protected
    FReportDateTime: TDateTime; { DateTime was started }
    FFirstPage: integer; { First valid page }
    FLastPage: integer; { Last valid page }
    //
    fnPageNo, FPageCount: Integer;
    fsTitle: String;
    FStream: TStream;
    fRenderer: TRPRender;
    fReuseGraphic: boolean;
    fwFileVer: Word;
    // Begin Page Info
    flCurrPagePos, flPrevPagePos, flNextPagePos: LongInt;
    // End Page Info
    //
    FXPos: double; // used for last lineto location
    FYPos: double; // used for last lineto location
    procedure GetNextRPTFCommand(RPTFStr: string; var Pos: Integer;
      var Command: char; var Param: string);
    function NextPiece(InStr: string; var Pos: Integer): string;
    procedure ParseRPTF(InStr: string; var Pos: Integer; var TextStr,
      RPTFStr: string);
    procedure ProcessRPTF(RPTFStr: string);
    procedure CreateGraphic(var Value: TGraphic); virtual;
    procedure LoadGraphic(Value: TGraphic); virtual;
    procedure MatchCode(pyValue: byte);
    procedure ProcessPage;
    function ReadByte: Byte;
    function ReadLongint: LongInt;
    function ReadPoint: TPoint;
    procedure ReadPageHeader;
    procedure ReadPen;
    procedure ReadReportHeader;
    function ReadRect: TRect;
    function ReadSmallInt: SmallInt;
    function ReadSingle: Single;
    function ReadString: string;
    property ReportDateTime: TDateTime read FReportDateTime write FReportDateTime;
    function GetDeviceName: string; virtual;
    function GetDriverName: string; virtual;
    function GetPort: string; virtual;
    function GetRelativePage: integer;
    //
    function ConvertMacro(MacroID: TMacroID): string;
    function GetPIVar(VarName: string): string; virtual;
    procedure ProcessString(var Text: string);
    property RelativePage: integer read GetRelativePage;
    property DeviceName: string read GetDeviceName;
    property DriverName: string read GetDriverName;
    property Port: string read GetPort;
  public
    CurrX: Single;
    CurrY: Single;
    Font: TFont;
    FontHeight: Single;
    FontSubscript: boolean;
    FontSuperscript: boolean;
    Brush: TBrush;
    FontRotation: integer;
    Pen: TPen;
    //
    procedure DoBrushColor;
    procedure DoLeftText;
    procedure DoCenterText;
    procedure DoRightText;
    procedure DoPrintSpaces;
    procedure DoRectangle;
    procedure DoArc;
    procedure DoChord;
    procedure DoEllipse;
    procedure DoMoveTo;
    procedure DoLineTo;
    procedure DoSetPenColor;
    procedure DoBrushCopy;
    procedure DoCopyRect;
    procedure DoDraw;
    procedure DoDrawFocusRect;
    procedure DoFillRect;
    procedure DoFloodFill;
    procedure DoFrameRect;
    procedure DoPie;
    procedure DoPolygon;
    procedure DoPolyline;
    procedure DoPrintBitmap;
    procedure DoPrintBitmapRect;
    procedure DoRoundRect;
    procedure DoStretchDraw;
    procedure DoTextRect;
    procedure DoSetFont;
    procedure DoSetTextBkMode;
    procedure DoSetBkColor;
    procedure DoSetScaleX;
    procedure DoSetScaleY;
    procedure DoPrintData;
    procedure DoPrintDataStream;
    procedure DoTransBitmap;
    procedure DoSetFrameMode;
    procedure DoPrintImageRect;
    procedure DoVariableData;
    procedure DoSetBrush;
    procedure DoSetBrushStyle;
    procedure DoSetBrushBitmap;
    procedure DoSetPen;
    procedure DoSetPenMode;
    procedure DoSetPenStyle;
    procedure DoSetPenWidth;
    procedure DoResetLineHeight;
    procedure DoAllowPreviewOnly;
    procedure DoAllowPrinterOnly;
    procedure DoAllowAll;
    procedure DoSetOrientation;
    procedure DoSetBin;
    procedure DoJustText;
    procedure DoTextRect2;
    //
    constructor Create(AStream: TStream; ARenderer: TRPRender); virtual;
    destructor Destroy; override;
    procedure Generate(const APageNo: integer = 0; APageCount: integer = 0); virtual;
    procedure GotoPage(APageNum: integer);
    //
    property FileVer: Word read fwFileVer;
    property Renderer: TRPRender read fRenderer;
    property PageNo: Integer read fnPageNo;
    property PageCount: Integer read FPageCount;
    property Title: string read fsTitle;
    property ReuseGraphic: boolean read fReuseGraphic;
  end; { TRPConverter }

  TRPRender = class(TRPComponent)
  protected
    snPaperWidth, snPaperHeight: Double;
    snPenWidth: Double;
    snFrameMode: TFrameMode;
    FActive: boolean;
    FDisplayName: string;
    FFileExtension: string;

    //
    Converter: TRPConverter;

    procedure SetDisplayName(const Value: string);
    // Drawing Methods
    procedure Arc(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4, pfY4: Double); virtual;
    procedure BrushChanged; virtual;
    procedure Chord(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4, pfY4: Double); virtual;
    procedure CenterText(const psText: String; const pfX, pfY: Double); virtual;
    procedure Ellipse(const pfX1, pfY1, pfX2, pfY2: Double); virtual;
    procedure FontChanged; virtual;
    procedure LeftText(const psText: String; const pfX, pfY: Double); virtual;
    procedure LineTo(const pfX1, pfY1: Double); virtual;
    procedure MoveTo(const pfX1, pfY1: Double); virtual;
    procedure Pie(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4, pfY4: Double); virtual;
    procedure RightText(const psText: String; const pfX, pfY: Double); virtual;
    procedure PenChanged; virtual;
    procedure PrintImageRect(X1,Y1,X2,Y2: double; ImageStream: TStream; ImageType: string); virtual;
    procedure PrintBitmapRect(const X1,Y1,X2,Y2: Double; AGraphic:
      {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}.TBitmap); virtual;
    procedure PrintBitmap(const X1,Y1,ScaleX,ScaleY: Double; AGraphic:
      {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}.TBitmap); virtual;
    procedure StretchDraw(const pRect: TRect; AGraphic: TGraphic); virtual;
    procedure Draw(const pfX1, pfY1: Double; AGraphic: TGraphic); virtual;
    procedure PrintSpaces(const psText: string; const pfX, pfY, pfWidth: Double); virtual;
    procedure Rectangle(const pfX1, pfY1, pfX2, pfY2: Double); virtual;
    procedure FillRect(const pRect: TRect); virtual;
    procedure TextRect(Rect: TRect; X1,Y1: double;S1: string); virtual;
    procedure RoundRect(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3: Double); virtual;
    // Status Update Methods
    procedure DocBegin; virtual;
    procedure DocEnd; virtual;
    procedure PageBegin; virtual;
    procedure PageEnd; virtual;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PrintRender(NDRStream: TStream;
                          OutputFileName: TFileName); virtual;
    property FrameMode: TFrameMode read snFrameMode write snFrameMode;
    property PenWidth: Double read snPenWidth write snPenWidth;
    property PaperWidth: Double read snPaperWidth write snPaperWidth;
    property PaperHeight: Double read snPaperHeight write snPaperHeight;
  published
    property Active: boolean read FActive write FActive default true;
    property DisplayName: string read FDisplayName write SetDisplayName;
    property FileExtension: string read FFileExtension write FFileExtension;
  end; { TRPRender }

  TRPRenderClass = class of TRPRender;

  TRPRenderStream = class(TRPRender)
  protected
    FActiveStream: TStream;
    FOutputStream: TStream;
    FOwnedStream: TStream;
    property ActiveStream: TStream read FActiveStream write FActiveStream;
    procedure SetOutputStream(AStream: TStream);
    procedure Print(const AData: string); virtual;
    procedure PrintF(const AData: string; const AArgs: array of const); virtual;
    procedure PrintLn(const AData: string = ''); virtual;
    procedure PrintLnF(const AData: string; const AArgs: array of const); virtual;
  public
    destructor Destroy; override;
    procedure InitFileStream(const AFileName: string);
    property OutputStream: TStream read FOutputStream write SetOutputStream;
    property OwnedStream: TStream read FOwnedStream;
  end; { TRPRenderStream }

  TRPRenderCanvas = class(TRPRender)
  end;  { TRPRenderCanvas }

  procedure RaveRegisterRender(const DisplayName: string; const RenderObject: TRPRender);
  procedure RaveUnRegisterRender(const DisplayName: string; const RenderObject: TRPRender);
  procedure GetRenderList(const AList: TStrings);
  function GetRenderFilter: string;


var
  RenderList: TStringList = nil;

implementation

//uses
//  Dialogs;

(*****************************************************************************}
( global procedures
(*****************************************************************************)
procedure RaveRegisterRender(const DisplayName: string; const RenderObject: TRPRender);
begin { RaveRegisterRender }
  if not Assigned(RenderList) then begin
    RenderList := TStringList.Create;
  end;
  RenderList.AddObject(DisplayName, RenderObject);
end;  { RaveRegisterRender }

procedure RaveUnRegisterRender(const DisplayName: string; const RenderObject: TRPRender);

var
  Index: integer;

begin { RaveUnRegisterRender }
  If Assigned(RenderList) then begin
    Index := RenderList.IndexOfObject(RenderObject);
    If Index >= 0 then begin
      RenderList.Delete(Index);
    end; { if }
    If RenderList.Count < 1 then begin
      RenderList.Free;
      RenderList := nil;
    end; { if }
  end; { if }
end;  { RaveUnRegisterRender }

procedure GetRenderList(const AList: TStrings);

var
  RenderObject: TRPRender;
  I1: integer;

begin { GetRenderList }
  AList.Clear;
  If Assigned(RenderList) then begin
    for I1 := 0 to RenderList.Count - 1 do begin
      RenderObject := TRPRender(RenderList.Objects[I1]);
      If RenderObject.Active then begin
        AList.AddObject(RenderObject.DisplayName, RenderObject);
      end; { if }
    end; { for }
  end; { if }
end;  { GetRenderList }

function GetRenderFilter: string;

var
  RenderObject: TRPRender;
  I1: integer;

begin
  Result := '';
  If Assigned(RPRender.RenderList) then begin
    With RPRender.RenderList do begin
      for I1 := 0 to Count - 1 do begin
        RenderObject := TRPRender(RPRender.RenderList.Objects[I1]);
        If RenderObject.Active then begin
          If Result = '' then begin
            Result := RenderObject.DisplayName + '|' + RenderObject.FileExtension;
          end else begin
            Result := Result + '|' + RenderObject.DisplayName + '|' + RenderObject.FileExtension;
          end; { else }
        end; { if }
      end; { for }
    end; { with }
  end; { if }
end;

(*****************************************************************************}
( class TRPConverter
(*****************************************************************************)

procedure TRPConverter.DoArc;
var
  X1, X2, X3, X4, Y1, Y2, Y3, Y4: Single;
begin
  inherited;
  X1 := ReadSingle;
  Y1 := ReadSingle;
  X2 := ReadSingle;
  Y2 := ReadSingle;
  X3 := ReadSingle;
  Y3 := ReadSingle;
  X4 := ReadSingle;
  Y4 := ReadSingle;
  Renderer.Arc(X1,Y1,X2,Y2,X3,Y3,X4,Y4);
end;

procedure TRPConverter.DoBrushColor;
begin
  Brush.Color := TColor(ReadLongint);
end;

procedure TRPConverter.DoBrushCopy;
begin
  //CreateGraphic(Graphic);
  ReadRect;
  ReadRect;
  ReadLongint;
  //Rect1 := ReadRect;
  //Rect2 := ReadRect;
  //L1 := ReadLongint;
  //BrushCopy(Rect1,Graphic as TBitmap,Rect2,L1);
  //Graphic.Free;
end;

procedure TRPConverter.DoCenterText;
var
  sText: string;
  X, Y: Single;
  I1: integer;
  S1: string;
  X1: double;

begin
  inherited;
  Y := ReadSingle;
  sText := ReadString;
  X := ReadSingle;
  if length(sText) > 0 then begin
    If Pos(RPTFPrefix,sText) = 0 then begin
      Renderer.CenterText(sText, X, Y);
    end else begin
      I1 := 1;
      X1 := X;
      While I1 <= Length(sText) do begin
        S1 := NextPiece(sText,I1);
        Renderer.CenterText(S1, X1, Y);
        X1 := X1 + (Round(FontHeight * 72) * Length(S1));
      end; { while }
    end; { else }
  end;
end;

procedure TRPConverter.DoChord;
var
  X1, X2, X3, X4, Y1, Y2, Y3, Y4: Single;
begin
  inherited;
  X1 := ReadSingle;
  Y1 := ReadSingle;
  X2 := ReadSingle;
  Y2 := ReadSingle;
  X3 := ReadSingle;
  Y3 := ReadSingle;
  X4 := ReadSingle;
  Y4 := ReadSingle;
  Renderer.Chord(X1,Y1,X2,Y2,X3,Y3,X4,Y4);
end;

procedure TRPConverter.DoCopyRect;
begin
  ReadRect;
  ReadLongint;
  ReadRect;
  //Rect1 := ReadRect;
  //L1 := ReadLongint;
  //Rect2 := ReadRect;
  //CopyRect(Rect1,TCanvas(L1),Rect2);
end;

procedure TRPConverter.DoDraw;

var
  LGraphic: TGraphic;
  X1, Y1: double;

begin
  CreateGraphic(LGraphic);
  try
    X1 := ReadSingle;
    Y1 := ReadSingle;
    Renderer.Draw(X1, Y1, LGraphic);
  finally
    LGraphic.Free;
  end;
end;

procedure TRPConverter.DoDrawFocusRect;
begin
  ReadRect;
  //Rect1 := ReadRect;
  //DrawFocusRect(Rect1);
end;

procedure TRPConverter.DoEllipse;
var
  X1, X2, Y1, Y2: Single;
begin
  inherited;
  X1 := ReadSingle;
  Y1 := ReadSingle;
  X2 := ReadSingle;
  Y2 := ReadSingle;
  Renderer.Ellipse(X1,Y1,X2,Y2);
end;

{ Parse the formatted string InStr and return the next piece of unformatted text
  in TextStr and the RPTF formatting string in RPTFStr }

procedure TRPConverter.ParseRPTF(    InStr: string;
                    var Pos: longint;
                    var TextStr: string;
                    var RPTFStr: string);

var
  Ch: char;

begin { ParseRPTF }
  TextStr := '';
  RPTFStr := '';
  While Pos <= Length(InStr) do begin
    If InStr[Pos] = RPTFPrefix then begin
      If TextStr <> '' then begin { Return with current string pieces }
        Exit;
      end else begin { Build RPTFStr }
        Repeat
          Ch := InStr[Pos];
          RPTFStr := RPTFStr + Ch;
          Inc(Pos);
        until (Pos > Length(InStr)) or (Ch = RPTFSuffix);
      end; { else }
    end else begin
      TextStr := TextStr + InStr[Pos];
      Inc(Pos);
    end; { else }
  end; { while }
end;  { ParseRPTF }

procedure TRPConverter.GetNextRPTFCommand(     RPTFStr: string;
                                           var Pos: longint;
                                           var Command: char;
                                           var Param: string);

begin { GetNextRPTFCommand }
  If Pos = 0 then begin
    Pos := 1;
  end; { if }
  Repeat
  { Find beginning of next RPTF command }
    While (Pos <= Length(RPTFStr)) and
     not (RPTFStr[Pos] in [RPTFPrefix,RPTFInfix]) do begin
      Inc(Pos);
    end; { while }

    If Pos <= Length(RPTFStr) then begin
    { Skip over framing character }
      Inc(Pos);

    { Read command }
      Command := RPTFStr[Pos];
      Inc(Pos);

    { Read parameter(s) }
      Param := '';
      While Pos <= Length(RPTFStr) do begin
        Case RPTFStr[Pos] of
          RPTFInfix: Break;
          RPTFSeparator: begin end; {!!! Start next parameter }
          RPTFSuffix: Break;
          else Param := Param + RPTFStr[Pos];
        end; { case }
        Inc(Pos);
      end; { while }
    end else begin
      Command := RPTFIgnore;
    end; { if }
  until (Pos > Length(RPTFStr)) or (RPTFStr[Pos] in [RPTFInfix,RPTFSuffix]);
end;  { GetNextRPTFCommand }

procedure TRPConverter.ProcessRPTF(RPTFStr: string);

var
  Command: char;
  Param: string;
  Pos: longint;

  procedure SetFontStyle(FontStyle: TFontStyles; AddStyle: boolean);
  begin
    if AddStyle then begin
      Font.Style := Font.Style + FontStyle;
    end else begin
      Font.Style := Font.Style - FontStyle;
    end; { else }
  end;

begin { ProcessRPTF }
{ Process through commands }
  Pos := 0;
  Repeat
    GetNextRPTFCommand(RPTFStr,Pos,Command,Param);

  { Process Command/Param combination }
    Case Command of
      RPTFIgnore: begin end;
      RPTFBold: SetFontStyle([fsBold],(Param = RPTFOn));
      RPTFItalic: SetFontStyle([fsItalic],(Param = RPTFOn));
      RPTFUnderline: SetFontStyle([fsUnderline],(Param = RPTFOn));
      RPTFStrikeout: SetFontStyle([fsStrikeout],(Param = RPTFOn));

      RPTFSuperscript: {Font.Superscript := (Param = RPTFOn)};
      RPTFSubscript: {Font.Subscript := (Param = RPTFOn)};

      RPTFName: Font.Name := Param;
      RPTFSize: begin
        Font.Size := Round(StrToFloat(Param));
        //Font.Height := Round(Converter.Font.Size / 72.0);
      end;
      RPTFColor: Font.Color := StrToInt(Param);
      RPTFPitch: begin
        Case Param[1] of
          'D': Font.Pitch := fpDefault;
          'F': Font.Pitch := fpFixed;
          'V': Font.Pitch := fpVariable;
        end; { case }
      end;
      RPTFResetParagraph: begin
        Font.Name := 'Arial';
        Font.Size := 12;
//        Font.Height := Round(12.0 / 72.0);
        SetFontStyle([fsBold],false);
        SetFontStyle([fsUnderline],false);
        SetFontStyle([fsItalic],false);
        SetFontStyle([fsStrikeout],false);
        Font.Color := clBlack;
        Font.Pitch := fpDefault;
        Font.Charset := DEFAULT_CHARSET;
//        Font.Superscript := false;
//        Font.Subscript := false;
        FontRotation := 0;
//        Font.Width := 0.0;
//        Font.Align := faBaseline;
      end;
      RPTFResetStyle: begin
        SetFontStyle([fsBold],false);
        SetFontStyle([fsUnderline],false);
        SetFontStyle([fsItalic],false);
        SetFontStyle([fsStrikeout],false);
        Font.Color := clBlack;
        Font.Pitch := fpDefault;
        Font.Charset := DEFAULT_CHARSET;
//        Font.Superscript := false;
//        Font.Subscript := false;
        FontRotation := 0;
//        Font.Width := 0.0;
//        Font.Align := faBaseline;
      end;
      RPTFJustify: begin
        Case Param[1] of
          RPTFLeft: begin end;
          RPTFCenter: begin end;
          RPTFRight: begin end;
          RPTFBlock: begin end;
        end; { case }
      end;
    end; { case }
  until Pos > Length(RPTFStr);
  Renderer.FontChanged;
end;  { ProcessRPTF }

function TRPConverter.NextPiece(InStr: string;  var Pos: Integer): string;

var
  RPTFStr: string;

begin { NextPiece }
  ParseRPTF(InStr,Pos,Result,RPTFStr);
  If RPTFStr <> '' then begin
    ProcessRPTF(RPTFStr);
  end; { if }
end;  { NextPiece }

procedure TRPConverter.DoLeftText;
var
  sText: string;
  X, Y: Single;
  I1: integer;
  S1: string;
  X1: double;

begin
  inherited;
  Y := ReadSingle;
  sText := ReadString;
  X := ReadSingle;
  if length(sText) > 0 then begin
    If Pos(RPTFPrefix,sText) = 0 then begin
      Renderer.LeftText(sText, X, Y);
    end else begin
      I1 := 1;
      X1 := X;
      While I1 <= Length(sText) do begin
        S1 := NextPiece(sText,I1);
        Renderer.LeftText(S1, X1, Y);
        X1 := X1 + (Round(FontHeight * 72) * Length(S1));
      end; { while }
    end; { else }
  end;
end;

procedure TRPConverter.DoLineTo;
var
  nX: Single;
  nY: Single;
begin
  nX := ReadSingle;
  nY := ReadSingle;
  Renderer.MoveTo(FXPos,FYPos);
  Renderer.LineTo(nX,nY);
  FXPos := nX;
  FYPos := nY;
end;

procedure TRPConverter.DoMoveTo;
begin
  inherited;
  CurrX := ReadSingle;
  CurrY := ReadSingle;
//  Called from LineTo, don't call it here
//  Renderer.MoveTo(CurrX, CurrY);
  FXPos := CurrX;
  FYPos := CurrY;
end;

procedure TRPConverter.DoPrintSpaces;
var
  sText: String;
  X, Y, Width: Single;
begin
  inherited;
  Y := ReadSingle;
  sText := ReadString;
  X := ReadSingle;
  Width := ReadSingle;
  Renderer.PrintSpaces(sText, X, Y, Width);
end;

procedure TRPConverter.DoRectangle;
var
  X1, X2, Y1, Y2: Single;
begin
  inherited;
  X1 := ReadSingle;
  Y1 := ReadSingle;
  X2 := ReadSingle;
  Y2 := ReadSingle;
  Renderer.Rectangle(X1, Y1, X2, Y2);
end;

procedure TRPConverter.DoRightText;
var
  sText: string;
  X, Y: Single;
  I1: integer;
  S1: string;
  X1: double;

begin
  inherited;
  Y := ReadSingle;
  sText := ReadString;
  X := ReadSingle;
  if length(sText) > 0 then begin
    If Pos(RPTFPrefix,sText) = 0 then begin
      Renderer.RightText(sText, X, Y);
    end else begin
      I1 := 1;
      X1 := X;
      While I1 <= Length(sText) do begin
        S1 := NextPiece(sText,I1);
        Renderer.RightText(S1, X1, Y);
        X1 := X1 + (Round(FontHeight * 72) * Length(S1));
      end; { while }
    end; { else }
  end;
end;

procedure TRPConverter.DoSetPenColor;
begin
  Pen.Color := TColor(ReadLongint);
end;

procedure TRPConverter.Generate(const APageNo: integer; APageCount: integer);
begin
  Renderer.Converter := Self;

  FReportDateTime := Now;

  ReadReportHeader;
  try
    if APageNo = 0 then begin
      Renderer.DocBegin;
      ProcessPage;
      while PageNo < PageCount do begin
        ProcessPage;
      end;
    end else begin
      if APageCount = 0 then begin
        APageCount := PageCount;
      end;
      FPageCount := APageCount;
      Renderer.DocBegin;
      GotoPage(APageNo);
      ProcessPage;
    end;
  finally
    Renderer.DocEnd;
  end;
end;

procedure TRPConverter.GotoPage(APageNum: integer);
begin
  FStream.Position := flCurrPagePos;
  if APageNum = PageNo then begin
    exit;
  end;

  While APageNum < PageNo do begin { Go backwards }
    ReadPageHeader;
    If (flPrevPagePos > 0) and (APageNum <> PageNo) then begin
      FStream.Position := flPrevPagePos;
    end else begin
      FStream.Position := flCurrPagePos;
      Exit;
    end;
  end;

  While APageNum > PageNo do begin { Go forwards }
    ReadPageHeader;
    If (flNextPagePos > 0) and (APageNum <> PageNo) then begin
      FStream.Position := flNextPagePos;
    end else begin
      FStream.Position := flCurrPagePos;
      Exit;
    end;
  end;
end;

procedure TRPConverter.MatchCode(pyValue: byte);
begin
  if ReadByte <> pyValue then begin
    raise Exception.Create('Unexpected code found in report file.');
  end;
end;

procedure TRPConverter.ProcessPage;
begin
  ReadPageHeader;
  Renderer.PageBegin;
  repeat
    Case ReadByte of
      rpcEndPage: Break;
      rpcLeftText: DoLeftText;
      rpcCenterText: DoCenterText;
      rpcRightText: DoRightText;
      rpcPrintSpaces, rpcBlockText: DoPrintSpaces;
      rpcRectangle: DoRectangle;
      rpcTabRectangle: DoRectangle;
      rpcSetBrushColor: DoBrushColor;
      rpcSetFontColor: begin
        Font.Color := TColor(ReadLongint);
        Renderer.FontChanged;
      end;
      rpcSetFontName: begin
        Font.Name := ReadString;
        Renderer.FontChanged;
      end;
      rpcSetFontHeight: begin
        FontHeight := ReadSingle;
        If FileVer >= 2000 then begin
          ReadSingle; { Real width of FontString }
        end;
        Font.Size := Round(FontHeight * 72);
        Renderer.FontChanged;
      end;
      rpcMoveTo: DoMoveTo;
      rpcLineTo: DoLineTo;
      rpcSetFontBold: begin
        if boolean(ReadByte) then begin
          Font.Style := Font.Style + [fsBold];
        end else begin
          Font.Style := Font.Style - [fsBold];
        end;
        Renderer.FontChanged;
      end;
      rpcSetFontUnderline: begin
        if boolean(ReadByte) then begin
          Font.Style := Font.Style + [fsUnderline];
        end else begin
          Font.Style := Font.Style - [fsUnderline];
        end;
        Renderer.FontChanged;
      end;
      rpcSetFontItalic: begin
        if boolean(ReadByte) then begin
          Font.Style := Font.Style + [fsItalic];
        end else begin
          Font.Style := Font.Style - [fsItalic];
        end;
        Renderer.FontChanged;
      end;
      rpcSetFontStrikeout: begin
        if boolean(ReadByte) then begin
          Font.Style := Font.Style + [fsStrikeOut];
        end else begin
          Font.Style := Font.Style - [fsStrikeOut];
        end;
        Renderer.FontChanged;
      end;
      rpcSetFontSuperscript: begin
        FontSuperscript := boolean(ReadByte);
        Renderer.FontChanged;
      end;
      rpcSetFontSubscript: begin
        FontSubscript := boolean(ReadByte);
        Renderer.FontChanged;
      end;
      rpcSetPenColor: DoSetPenColor;
      rpcArc: DoArc;
      rpcBrushCopy: DoBrushCopy;
      rpcChord: DoChord;
      rpcCopyRect: DoCopyRect;
      rpcDraw: DoDraw;
      rpcDrawFocusRect: DoDrawFocusRect;
      rpcEllipse: DoEllipse;
      rpcFillRect: DoFillRect;
      rpcFloodFill: DoFloodFill;
      rpcFrameRect: DoFrameRect;
      rpcPie: DoPie;
      rpcPolygon: DoPolygon;
      rpcPolyline: DoPolyline;
      rpcPrintBitmap:  DoPrintBitmap;
      rpcPrintBitmapRect: DoPrintBitmapRect;
      rpcRoundRect: DoRoundRect;
      rpcStretchDraw: DoStretchDraw;
      rpcTextRect: DoTextRect;
      rpcSetTextBKMode: DoSetTextBKMode;
      rpcSetBKColor: DoSetBKColor;
      rpcSetScaleX: DoSetScaleX;
      rpcSetScaleY: DoSetScaleY;
      rpcPrintData: DoPrintData;
      rpcPrintDataStream: DoPrintDataStream;
      rpcTransBitmap: DoTransBitmap;
      rpcSetFrameMode: DoSetFrameMode;
      rpcPrintImageRect: DoPrintImageRect;
      rpcVariableData: DoVariableData;
      rpcSetBrush: DoSetBrush;
      rpcSetBrushStyle: DoSetBrushStyle;
      rpcSetBrushBitmap: DoSetBrushBitmap;
      rpcSetFont: DoSetFont;
      rpcSetFontPitch: begin
        //FontPitch := TFontPitch(
        //TODO:FONT
        ReadByte;
        Renderer.FontChanged;
      end;
      rpcSetFontRotation: begin
        FontRotation := ReadSmallInt;
        Renderer.FontChanged;
      end;
      rpcSetFontAlign: begin
        //FontAlign := TFontAlign(
        ReadByte;
        Renderer.FontChanged;
      end;
      rpcSetFontCharset: begin
        //  FontCharset :=
        ReadByte;
        Renderer.FontChanged;
      end;
      rpcSetPen: DoSetPen;
      rpcSetPenMode: DoSetPenMode;
      rpcSetPenStyle: DoSetPenStyle;
      rpcSetPenWidth: DoSetPenWidth;
      rpcResetLineHeight: DoResetLineHeight;
      rpcAllowPreviewOnly: DoAllowPreviewOnly;
      rpcAllowPrinterOnly: DoAllowPrinterOnly;
      rpcAllowAll: DoAllowAll;
      rpcSetOrientation: DoSetOrientation;
      rpcSetBin: DoSetBin;

      // User Defined fields
      rpcJustText  : DoJustText;
      rpcTextRect2 : DoTextRect2;
      rpcPrintBitmapRect2 : DoPrintBitmapRect;
      else begin
        RaiseError('Unexpected code found in report file.');
      end;
    end;
  until false;
  Renderer.PageEnd;
end;

function TRPConverter.ReadByte: Byte;
begin
  FStream.ReadBuffer(Result, SizeOf(Result));
end;

function TRPConverter.ReadLongint: LongInt;
begin
  FStream.ReadBuffer(Result, SizeOf(Result));
end;

procedure TRPConverter.ReadPageHeader;
begin
  flCurrPagePos := FStream.Position;
  MatchCode(rpcNewPage);

{ Read page header }
  flPrevPagePos := ReadLongint;
  flNextPagePos := ReadLongint;
  fnPageNo := ReadSmallInt;

{ Page Width,Height }
  If FileVer >= 2000 then begin
    Renderer.PaperWidth := ReadSingle;
    Renderer.PaperHeight := ReadSingle;
  end else begin
    ReadByte; { Old orientation byte }
  end;
end;

procedure TRPConverter.ReadPen;
var
  Pen: TPen;
  PenWidth: double;
begin { ReadPen }
  Pen := TPen.Create;
  try
    With Pen do begin
      Color := TColor(ReadLongint);
      Mode := TPenMode(ReadByte);
      Style := TPenStyle(ReadByte);
      PenWidth := ReadSingle;
      Width := Round(PenWidth {* FXDPI * FScaleX * FZoom} / 10000.0);
    end;
    Pen.Assign(Pen);
  finally
    Pen.Free;
  end;
end;

procedure TRPConverter.ReadReportHeader;
begin
  Case ReadByte of
    rpcJobHeader11: fwFileVer := 1101;
    rpcJobHeader20i: fwFileVer := 2009;
    rpcJobHeader: fwFileVer := ReadSmallInt;
    else Raise EReportPrinter.Create('Unexpected header code found in report file.');
  end;

  If FileVer >= 2010 then
    fsTitle := ReadString;

  fnPageNo := 1;
  FPageCount := ReadSmallInt;
  FFirstPage := ReadSmallInt;
  FLastPage := ReadSmallInt;

  // PaperWidth
  ReadSingle;
  // PaperHeight
  ReadSingle;

  // Waste dimensions
  ReadSingle; { FLeftWaste }
  ReadSingle; { FRightWaste }
  ReadSingle; { FTopWaste }
  ReadSingle; { FBottomLeftWaste }

  // Printer settings
  ReadByte; { Orientation }
  If FileVer >= 2000 then begin
    ReadSmallInt; { Bin }
    ReadByte; { Collate }
    ReadByte; { Duplex }
  end; { if }
  ReadSmallInt; { Copies }
  ReadSmallInt; { PaperSize }
  ReadSmallInt; { PaperWidth }
  ReadSmallInt; { PaperLength }
  // OutputName - Output port for Printer
  ReadString;

  flCurrPagePos := FStream.Position;
end;

function TRPConverter.ReadSingle: Single;
begin
  FStream.ReadBuffer(Result, SizeOf(Result));
end;

function TRPConverter.ReadSmallInt: SmallInt;
begin
  FStream.ReadBuffer(Result, SizeOf(Result));
end;

function TRPConverter.ReadString: string;
var
  wLen: word;
begin
  wLen := ReadByte;
  If (FileVer >= 2016) and (wLen >= 192) then begin
    wLen := (wLen * $0100 + ReadByte) - $C000;
  end; { if }
  SetLength(Result, wLen);
  If wLen > 0 then begin
    FStream.ReadBuffer(Result[1], wLen);
    ProcessString(Result);
  end; { if }
end;

procedure TRPConverter.DoFillRect;

var
  Rect1: TRect;

begin
  Rect1 := ReadRect;
  Renderer.FillRect(Rect1);
end;

procedure TRPConverter.DoFloodFill;
begin
  ReadSingle;
  ReadSingle;
  ReadLongint;
  ReadLongint;
//  X1 := ReadSingle;
//  Y1 := ReadSingle;
//  L1 := ReadLongint;
//  L2 := ReadLongint;
//  FloodFill(X1,Y1,TColor(L1),TFillStyle(L2));
end;

procedure TRPConverter.DoFrameRect;
begin
  ReadRect;
  //Rect1 := ReadRect;
  //FrameRect(Rect1);
end;

procedure TRPConverter.DoPie;

var
  X1, Y1, X2, Y2,
  X3, Y3, X4, Y4: double;

begin
  X1 := ReadSingle;
  Y1 := ReadSingle;
  X2 := ReadSingle;
  Y2 := ReadSingle;
  X3 := ReadSingle;
  Y3 := ReadSingle;
  X4 := ReadSingle;
  Y4 := ReadSingle;
  Renderer.Pie(X1,Y1,X2,Y2,X3,Y3,X4,Y4);
end;

procedure TRPConverter.DoPolygon;

var
  I1, I2: integer;

begin
  I1 := ReadSmallInt;
  for I2 := 0 to I1 do begin
    ReadSingle;
    ReadSingle;
  end; { for }
//      I1 := ReadSmallInt;
//        GetMem(PointArr,(I1 + 1) * SizeOf(TPoint));
//      try
//        For I2 := 0 to I1 do begin
//            PointArr^[I2].X := XU2D(ReadSingle);
//            PointArr^[I2].Y := YU2D(ReadSingle);
//        end; { for }

        { Call Polygon(PointArr^) but with only I1+1 items in open array }
//          asm
//            mov edx,PointArr { Load pointer to PointArr }
//            mov ecx,I1 { Load High(PointArr^) }
//            mov eax,self { Load self pointer }
//            mov ebx,[eax]
//            call TFilePrinter.Polygon { call self.Polygon }
//          end; { asm }
//      finally
//          FreeMem(PointArr,(I1 + 1) * SizeOf(TPoint));
//      end; { try }
end;

procedure TRPConverter.DoPolyline;

var
  I1, I2: integer;

begin
  I1 := ReadSmallInt;
  for I2 := 0 to I1 do begin
    ReadSingle;
    ReadSingle;
  end; { for }
//  I1 := ReadSmallInt;
//  GetMem(PointArr,(I1 + 1) * SizeOf(TPoint));
//  try
//    For I2 := 0 to I1 do begin
//      PointArr^[I2].X := XU2D(ReadSingle);
//      PointArr^[I2].Y := YU2D(ReadSingle);
//    end; { for }
//
//  { Call Polyline(PointArr^) but with only I1+1 items in open array }
//    asm
//      mov edx,PointArr { Load pointer to PointArr }
//      mov ecx,I1 { Load High(PointArr^) }
//      mov eax,self { Load self pointer }
//      mov ebx,[eax]
//      call TFilePrinter.Polyline { call self.PolyLine }
//    end; { asm }
//  finally
//    FreeMem(PointArr,(I1 + 1) * SizeOf(TPoint));
//  end; { tryf }
end;

procedure TRPConverter.DoPrintBitmap;

var
  LGraphic: TGraphic;
  X1,Y1: double;
  ScaleX,ScaleY: double;

begin
  CreateGraphic(LGraphic);
  try
    X1 := ReadSingle;
    Y1 := ReadSingle;
    ScaleX := ReadSingle;
    ScaleY := ReadSingle;
    Renderer.PrintBitmap(X1,Y1,ScaleX,ScaleY,LGraphic as
      {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}.TBitmap);
  finally
    LGraphic.Free;
  end;
end;

procedure TRPConverter.DoPrintBitmapRect;
var
  LGraphic: TGraphic;
  X1, X2: double;
  Y1, Y2: double;
begin
  CreateGraphic(LGraphic);
  try
    X1 := ReadSingle;
    Y1 := ReadSingle;
    X2 := ReadSingle;
    Y2 := ReadSingle;
    Renderer.PrintBitmapRect(X1, Y1, X2, Y2, LGraphic as
      {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}.TBitmap);
  finally
    LGraphic.Free;
    LGraphic := nil;
  end;
end;

procedure TRPConverter.DoRoundRect;

var
  X1, X2, X3, Y1, Y2, Y3: Single;

begin
  X1 := ReadSingle;
  Y1 := ReadSingle;
  X2 := ReadSingle;
  Y2 := ReadSingle;
  X3 := ReadSingle;
  Y3 := ReadSingle;
  Renderer.RoundRect(X1, Y1, X2, Y2, X3, Y3);
end;

procedure TRPConverter.DoStretchDraw;

var
  LGraphic: TGraphic;
  Rect1: TRect;

begin
  CreateGraphic(LGraphic);
  try
    Rect1 := ReadRect;
    Renderer.StretchDraw(Rect1,LGraphic);
  finally
    LGraphic.Free;
  end;
end;

procedure TRPConverter.DoTextRect;

var
  X1, Y1: double;
  S1: string;
  Rect1: TRect;

begin
  Rect1 := ReadRect;
  X1 := ReadSingle;
  Y1 := ReadSingle;
  S1 := ReadString;
  Renderer.TextRect(Rect1,X1,Y1,S1);
end;

procedure TRPConverter.DoSetTextBkMode;
begin
  //TextBKMode := TBKMode();
  ReadByte;
end;

procedure TRPConverter.DoSetBkColor;
begin
  //BKColor := TColor();
  ReadLongint;
end;

procedure TRPConverter.DoSetScaleX;
begin
  { Don't change ScaleX }
  ReadSingle;
end;

procedure TRPConverter.DoSetScaleY;
begin
  { Don't change ScaleY }
  ReadSingle;
end;

procedure TRPConverter.DoPrintData;
begin
  ReadString;
//  S1 := ReadString;
//  PrintData(S1);
end;

procedure TRPConverter.DoPrintDataStream;
begin
  ReadLongint;
//  L1 := ReadLongint;
//  PrintDataStream(InputStream,L1);
end;

procedure TRPConverter.DoTransBitmap;
begin
  //TransparentBitmaps := boolean(
  ReadByte;
end;

procedure TRPConverter.DoSetFrameMode;
begin
  Renderer.FrameMode := TFrameMode(ReadByte);
end;

procedure TRPConverter.DoPrintImageRect;

var
  TempStream: TMemoryStream;
  S1: string;
  X1: double;
  Y1: double;
  X2: double;
  Y2: double;

begin
  TempStream := TMemoryStream.Create; { Create temp stream }
  try
    TempStream.SetSize(ReadLongint); { Allocate space }
    FStream.ReadBuffer(TempStream.Memory^,TempStream.Size);
    TempStream.Position := 0;
    S1 := ReadString; { Read ImageType }
    X1 := ReadSingle;
    Y1 := ReadSingle;
    X2 := ReadSingle;
    Y2 := ReadSingle;
    Renderer.PrintImageRect(X1,Y1,X2,Y2,TempStream,S1);
  finally
    TempStream.Free; { Clean up stream }
  end; { tryf }

end;

procedure TRPConverter.DoVariableData;
begin
  ReadString; { Read variable name }
//  S1 := ReadString; { Read variable name }
  raise Exception.Create('Not supported yet');
//  SetPIVar(S1,ReadPIVar);
end;

procedure TRPConverter.DoSetBrush;
begin
  raise Exception.Create('Not supported yet');
//        ReadBrush;
end;

procedure TRPConverter.DoSetBrushStyle;
begin
  //Canvas.Brush.Style := TBrushStyle(
  Brush.Style := TBrushStyle(ReadByte);
end;

procedure TRPConverter.DoSetBrushBitmap;
begin
  if boolean(ReadByte) then begin
    raise Exception.Create('Not supported yet');
  end;
//  ReadGraphic(Canvas.Brush.Bitmap);
end;

procedure TRPConverter.DoSetFont;
begin
  with Font do begin
    Name := ReadString;
    Color := TColor(ReadLongint);
    Pitch := TFontPitch(ReadByte);
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    If FileVer > 2017 then begin
      Charset := ReadByte;
    end else begin
      Charset := DEFAULT_CHARSET;
    end;
    {$ENDIF}
    FontHeight := ReadSingle;
    Font.Size := Round(FontHeight * 72);
    if boolean(ReadByte) then begin
      Style := Style + [fsBold];
    end; { if }
    if boolean(ReadByte) then begin
      Style := Style + [fsItalic];
    end; { if }
    if boolean(ReadByte) then begin
      Style := Style + [fsStrikeout];
    end;
    ReadByte;
    If FileVer >= 2000 then begin
      FontRotation := ReadSmallInt;
    end else begin
      FontRotation := 0;
    end; { else }
  end;
  Renderer.FontChanged;
end;

procedure TRPConverter.DoSetPen;
begin
  ReadPen;
end;

procedure TRPConverter.DoSetPenMode;
begin
//  Canvas.Pen.Mode := TPenMode(
  ReadByte;
end;

procedure TRPConverter.DoSetPenStyle;
begin
//  Canvas.Pen.Style := TPenStyle(
  Pen.Style := TPenStyle(ReadByte);
end;

procedure TRPConverter.DoSetPenWidth;
begin
  Renderer.PenWidth := ReadSingle;
//  F1 := ReadSingle;
//  Canvas.Pen.Width := Round(F1 * FXDPI * FScaleX * FZoom / 10000.0);
end;

procedure TRPConverter.DoResetLineHeight;
begin
//  FAscentHeight :=
  ReadSingle;
//  FDescentHeight :=
  ReadSingle;
//  FLineHeight :=
  ReadSingle;
end;

procedure TRPConverter.DoAllowPreviewOnly;
begin
  //AllowPreviewOnly;
end;

procedure TRPConverter.DoAllowPrinterOnly;
begin
  //AllowPrinterOnly;
end;

procedure TRPConverter.DoAllowAll;
begin
  //AllowAll;
end;

procedure TRPConverter.DoSetOrientation;
begin
  ReadByte;
//  B1 := ReadByte;
//  NextOrientation := TOrientation(B1);
end;

procedure TRPConverter.DoSetBin;
begin
  ReadString;
//  S1 := ReadString;
//  SelectBin(S1);
end;

procedure TRPConverter.DoJustText;
Begin { DoJustText }
  { read details out of stream }
  {Rect1 := }ReadRect;
  {B1 := }ReadByte;
  {S1 := }ReadString;

  { Draw text }
  //ExtTextRect(Rect1,B1,S1);
End; { DoJustText }

procedure TRPConverter.DoTextRect2;
Begin { DoTextRect2 }
  {Rect1 := }ReadRect;
  {X1 := }ReadSingle;
  {Y1 := }ReadSingle;
  {B1 := }ReadByte;
  {S1 := }ReadString;
  //TextRect2(Rect1,X1,Y1,B1,S1);
End; { DoTextRect2 }

constructor TRPConverter.Create(AStream: TStream; ARenderer: TRPRender);
begin
  inherited Create;
  FStream := AStream;
  FRenderer := ARenderer;
  //
  Brush := TBrush.Create;
  Font := TFont.Create;
  Pen := TPen.Create;
end;

function TRPConverter.ReadRect: TRect;
begin
  Result.TopLeft := ReadPoint;
  Result.BottomRight := ReadPoint;
end;

procedure TRPConverter.CreateGraphic(var Value: TGraphic);
var
  Kind: byte;
begin { CreateGraphic }
  inherited;
  Kind := ReadByte;
  fReuseGraphic := Kind > 128;
  Case (Kind mod 128) of
    1: begin { Bitmap }
      Value := {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}.TBitmap.Create;
    end;
    2: begin { Metafile }
      {$IFDEF Linux}
      //!!PORT!!
      {$ELSE}
      Value := TMetafile.Create;
      {$ENDIF}
    end;
    3: begin { Icon }
      Value := TIcon.Create;
    end;
  end; { case }
  LoadGraphic(Value);
end;

procedure TRPConverter.LoadGraphic(Value: TGraphic);
var
  TempStream: TMemoryStream;
  NewPos: longint;
  SavePos: longint;
begin { LoadGraphic }
  TempStream := TMemoryStream.Create; { Create temp stream }
  try
    If fReuseGraphic then begin
      NewPos := ReadLongint;
      SavePos := FStream.Position;
      FStream.Position := NewPos;
    end else begin
      SavePos := 0;
    end; { else }
    TempStream.SetSize(ReadLongint); { Allocate space }
    FStream.ReadBuffer(TempStream.Memory^,TempStream.Size);
    Value.LoadFromStream(TempStream); { Copy stream to icon object }
    If fReuseGraphic then begin
      FStream.Position := SavePos;
      fReuseGraphic := false;
    end; { if }
  finally
    TempStream.Free; { Clean up stream }
  end; { try }
end;

function TRPConverter.ReadPoint: TPoint;
begin
  Result.X := Round(ReadSingle * 72);
  Result.Y := Round(ReadSingle * 72);
end;

destructor TRPConverter.Destroy;
begin
  Brush.Free;
  Font.Free;
  Pen.Free;
  inherited;
end;

(*****************************************************************************}
( class TRPRender
(*****************************************************************************)

constructor TRPRender.Create(AOwner: TComponent);
begin
  inherited;
  DisplayName := 'RPRender';
  Active := true;
end;

destructor TRPRender.Destroy;
begin
  RaveUnRegisterRender(DisplayName, self);
  inherited;
end;

procedure TRPRender.PrintRender(NDRStream: TStream;
                                OutputFileName: TFileName);
begin
end;

procedure TRPRender.SetDisplayName(const Value: string);
begin
  RaveUnRegisterRender(DisplayName, Self);
  FDisplayName := Value;
  RaveRegisterRender(DisplayName, Self);
end;

procedure TRPRender.Arc(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4, pfY4: Double);
begin
end;

procedure TRPRender.BrushChanged;
begin
end;

procedure TRPRender.CenterText(const psText: String; const pfX, pfY: Double);
begin
end;

procedure TRPRender.Chord(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4, pfY4: Double);
begin
end;

procedure TRPRender.DocBegin;
begin
end;

procedure TRPRender.DocEnd;
begin
end;

procedure TRPRender.Ellipse(const pfX1, pfY1, pfX2, pfY2: Double);
begin
end;

procedure TRPRender.FillRect(const pRect: TRect);
begin
end;

procedure TRPRender.TextRect(Rect: TRect; X1,Y1: double;S1: string);
begin
end;

procedure TRPRender.FontChanged;
begin
end;

procedure TRPRender.LeftText(const psText: String; const pfX, pfY: Double);
begin
end;

procedure TRPRender.LineTo(const pfX1, pfY1: Double);
begin
end;

procedure TRPRender.MoveTo(const pfX1, pfY1: Double);
begin
end;

procedure TRPRender.PageBegin;
begin
end;

procedure TRPRender.PageEnd;
begin
end;

procedure TRPRender.PenChanged;
begin

end;

procedure TRPRender.Pie(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4,
  pfY4: Double);
begin
end;

procedure TRPRender.PrintBitmap(const X1, Y1, ScaleX, ScaleY: Double;
  AGraphic: {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}.TBitmap);
begin
end;

procedure TRPRender.PrintBitmapRect(const X1, Y1, X2, Y2: Double; AGraphic:
  {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}.TBitmap);
begin
end;

procedure TRPRender.PrintImageRect(X1,Y1,X2,Y2: double;
                                       ImageStream: TStream;
                                       ImageType: string);
begin
end;

procedure TRPRender.PrintSpaces(const psText: string; const pfX, pfY, pfWidth: Double);
begin
end;

procedure TRPRender.StretchDraw(const pRect: TRect;
  AGraphic: TGraphic);
begin
end;

procedure TRPRender.Draw(const pfX1, pfY1: Double; AGraphic: TGraphic);
begin
end;

procedure TRPRender.Rectangle(const pfX1, pfY1, pfX2, pfY2: Double);
begin
end;

procedure TRPRender.RightText(const psText: String; const pfX, pfY: Double);
begin
end;

procedure TRPRender.RoundRect(const pfX1, pfY1, pfX2, pfY2, pfX3,
  pfY3: Double);
begin
end;

(*****************************************************************************}
( class TRPRenderStream
(*****************************************************************************)

destructor TRPRenderStream.Destroy;
begin
  FreeAndNil(FOwnedStream);
  inherited;
end;

procedure TRPRenderStream.InitFileStream(const AFileName: string);
begin
  FOwnedStream := TFileStream.Create(AFilename,fmCreate);
  OutputStream := FOwnedStream;
end;

procedure TRPRenderStream.SetOutputStream(AStream: TStream);
begin
  FOutputStream := AStream;
  FActiveStream := AStream;
end;

procedure TRPRenderStream.Print(const AData: string);
begin
  if Length(AData) > 0 then begin
    ActiveStream.WriteBuffer(AData[1], Length(AData));
  end; { if }
end;

procedure TRPRenderStream.PrintF(const AData: string;
                                 const AArgs: array of const);
begin
  Print(Format(AData, AArgs));
end;

procedure TRPRenderStream.PrintLn(const AData: string);
begin
  Print(AData + #13#10);
end;

procedure TRPRenderStream.PrintLnF(const AData: string;
                                   const AArgs: array of const);
begin
  PrintLn(Format(AData, AArgs));
end;

procedure TRPConverter.ProcessString(var Text: string);
  var
    I1: integer;
    I2: integer;
    I3: integer;
    MacroStr: string;
    MacroID: TMacroID;
    VarName: string;

  begin { ProcessString }
  { Look for any macro strings in Text and replace }
    Repeat
      I1 := Pos({Trans-}#253'$RPCM',Text);
      If I1 > 0 then begin
        MacroStr := Copy(Text,I1,8);
        MacroID := TMacroID(StrToInt(Copy(MacroStr,7,2)));
        Delete(Text,I1,8);
        Insert(ConvertMacro(MacroID),Text,I1);
      end; { if }
      I2 := Pos({Trans-}#253'$RPCV',Text);
      If I2 > 0 then begin
        I3 := I2 + 6;
        VarName := '';
        If (I3 < Length(Text)) and (Text[I3] = #252) then begin
          Inc(I3);
          While I3 <= Length(Text) do begin
            If Text[I3] = #251 then begin
              Break;
            end else begin
              VarName := VarName + Text[I3];
            end; { else }
            Inc(I3);
          end; { while }
        end; { if }
        If I3 <= Length(Text) then begin
          Delete(Text,I2,I3 - I2 + 1);
        end else begin
          Delete(Text,I2,Length(Text) - I2 + 1);
        end; { else }
        Insert(GetPIVar(VarName),Text,I2);
      end; { if }
    until (I1 = 0) and (I2 = 0);
  end;  { ProcessString }

function TRPConverter.ConvertMacro(MacroID: TMacroID): string;
(*
var
  I1: integer;
*)

begin { ConvertMacro }
  Case MacroID of
    midCurrDateShort: begin
      Result := FormatDateTime({Trans-}'ddddd',ReportDateTime);
    end;
    midCurrDateLong: begin
      Result := FormatDateTime({Trans-}'dddddd',ReportDateTime);
    end;
    midCurrDateUS: begin
      Result := FormatDateTime({Trans-}'mm/dd/yy',ReportDateTime);
    end;
    midCurrDateInter: begin
      Result := FormatDateTime({Trans-}'dd/mm/yy',ReportDateTime);
    end;
    midCurrTimeShort: begin
      Result := FormatDateTime({Trans-}'t',ReportDateTime);
    end;
    midCurrTimeLong: begin
      Result := FormatDateTime({Trans-}'tt',ReportDateTime);
    end;
    midCurrTimeAMPM: begin
      Result := FormatDateTime({Trans-}'hh:nn ampm',ReportDateTime);
    end;
    midCurrTime24: begin
      Result := FormatDateTime({Trans-}'hh:nn',ReportDateTime);
    end;
    midFirstPage: begin
      Result := IntToStr(FFirstPage);
    end;
    midLastPage: begin
      Result := IntToStr(FLastPage);
    end;
    midTotalPages: begin
      Result := IntToStr(FPageCount);
    end;
    midCurrentPage: begin
      Result := IntToStr(fnPageNo);
    end;
    midRelativePage: begin
      Result := IntToStr(RelativePage);
    end;
    midPrinterName: begin
      Result := DeviceName;
    end;
    midDriverName: begin
      Result := DriverName;
    end;
    midPortName: begin
      Result := Port;
    end;
    midUser01..midUser20: begin
(*
      I1 := Ord(MacroID) - Ord(midUser01);
      If I1 < MacroData.Count then begin
        Result := MacroData[I1];
      end else begin
        Result := '';
      end; { else }
    end;
    else begin
*)
      Result := '';
    end;
  end; { case }
end;  { ConvertMacro }

function TRPConverter.GetPIVar(VarName: string): string;
begin { GetPIVar }
  Result := VarName;
end;  { GetPIVar }

function TRPConverter.GetRelativePage: integer;
begin
//  Result := fnPageNo + PageNumOffset;
  Result := fnPageNo;
end;

function TRPConverter.GetDeviceName: string;
begin
  Result := 'Render';
end;

function TRPConverter.GetDriverName: string;
begin
  Result := 'Render';
end;

function TRPConverter.GetPort: string;
begin
  Result := 'Render';
end;

end.
