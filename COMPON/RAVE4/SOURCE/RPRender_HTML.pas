{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPRender_HTML;

interface

uses
  {$IFDEF Linux}
  QGraphics, Types,
  {$ELSE}
  Graphics,
  Windows,
  {$ENDIF}
  Classes,
  SysUtils,
  RPRender;

type
  TRPRenderHTML = class(TRPRenderStream)
  protected
    FCacheDir: string;
    FGenerator: integer;
    ffMaxY: Double;
    FOffsetX: integer;
    FOffsetY: integer;
    FPageURL: string;
    FTemplateHead: string;
    FTemplatePost: string;
    FTemplatePre: string;
    FServerMode: boolean;
    //
    function ColorToRGBString(AColor: TColor): String;
    procedure DoGifDiv(const AX, AY, AWidth, AHeight: Single; AColor: TColor);
    function GetFontStyle(AFont: TFont): string;
    function GetTemplate: string;
  	Function HTMLColor(const colr: TColor): String;
    function HTMLText(const psText: string): string;
    function InchesToPixels(const AInches: Double): integer;
    function NewCacheFile(APrefix: string): string;
    function ProcessParams(const AHTML: string): string;
    procedure SetDefaultTemplate;
    procedure SetTemplate(const AValue: string);
    procedure	ToJPEGFile(AGraphic: TGraphic; const AFileName: String);
    // WriteDiv must be the only item that writes out DIVs as it handles offsets, etc
    procedure WriteDiv(const AText: String; const AX1, AY1: Double; const AWidth: double = 0;
     const AHeight: Double = 0);
    function ProcessURL(AValue: string): string;
  public
    constructor Create(AOwner: TComponent); override;
    procedure PrintRender(NDRStream: TStream;
                          OutputFileName: TFileName); override;
    procedure CenterText(const psText: String; const pfX, pfY: Double); override;
    class procedure CreateColorGif(AStream: TStream; AColor: TColor);
    procedure LeftText(const psText: String; const pfX, pfY: Double); override;
    procedure LineTo(const pfX1, pfY1: Double); override;
    procedure PrintBitmapRect(const AX1, AY1, AX2, AY2: Double; AGraphic:
      {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}.TBitmap);
     override;
    procedure StretchDraw(const Rect: TRect; AGraphic: TGraphic); override;
    procedure PrintSpaces(const psText: string; const pfX, pfY, pfWidth: Double); override;
    procedure Rectangle(const pfX1, pfY1, pfX2, pfY2: Double); override;
    procedure FillRect(const pRect: TRect); override;
    procedure RightText(const psText: String; const pfX, pfY: Double); override;
    //
    procedure PageBegin; override;
    procedure PageEnd; override;
    //
    property PageURL: string read FPageURL write FPageURL;
    property Template: string read GetTemplate write SetTemplate;
  published
    property CacheDir: string read FCacheDir write FCacheDir;
    property ServerMode: boolean read FServerMode write FServerMode;
  end;

implementation

uses
  Math,
  {$IFDEF Linux}
  Libc,
  NDGraphic,
  {$ELSE}
  JPeg,
  {$ENDIF}
  RPDefine;

const
  PPI = 96;
  Pixel = 1 / 96;

{ TRPRenderHTML }

procedure TRPRenderHTML.PageBegin;

begin
  ffMaxY := 0;
  PrintLn(ProcessParams(FTemplateHead));
  PrintLn('<SCRIPT Language=Javascript>');
//  PrintLn('var GPageURL = "' + PageURL + '";');
  PrintLn('var GPageURL = "' + ProcessURL(PageURL) + '";');
  PrintLn('var GPageNo = ' + IntToStr(Converter.PageNo) + ';');
  PrintLn('var GPageCount = ' + IntToStr(Converter.PageCount) + ';');
  PrintLn('');
  PrintLn('function GotoPage(APageNo) {');
  PrintLn('  location.href = GPageURL.replace(/{%PAGENO%}/,APageNo);');
  PrintLn('}');
  PrintLn('');
  PrintLn('function NextPage() {');
  PrintLn('  if (GPageNo < GPageCount)');
  PrintLn('    {GotoPage(GPageNo + 1);}');
  PrintLn('  else');
  PrintLn('    {window.alert("This is the last page.")}');
  PrintLn('}');
  PrintLn('');
  PrintLn('function PrevPage() {');
  PrintLn('  if (GPageNo > 1)');
  PrintLn('    {GotoPage(GPageNo - 1);}');
  PrintLn('  else');
  PrintLn('    {window.alert("This is the first page.")}');
  PrintLn('}');
  PrintLn('');
  PrintLn('</SCRIPT>');
  Print(ProcessParams(FTemplatePre));
end;

procedure TRPRenderHTML.PageEnd;
begin
  Print(ProcessParams(FTemplatePost));
end;

function TRPRenderHTML.InchesToPixels(const AInches: Double): integer;
begin
  Result := Round(AInches * PPI);
end;

procedure TRPRenderHTML.LeftText;
begin
  WriteDiv(HTMLText(psText), pfX, pfY - Converter.FontHeight);
end;

procedure TRPRenderHTML.PrintSpaces(const psText: string; const pfX, pfY, pfWidth: Double);
begin
  LeftText(psText, pfX, pfY);
end;

procedure TRPRenderHTML.Rectangle(const pfX1, pfY1, pfX2, pfY2: Double);
var
  LLeft, LTop, LWidth, LHeight: Single;
begin
  LLeft := Min(pfX1, pfX2);
  LTop := Min(pfY1, pfY2);
  LWidth := Max(pfX1, pfX2) - LLeft;
  LHeight := Max(pfY1, pfY2) - LTop;
  DoGifDiv(LLeft, LTop, LWidth, LHeight, Converter.Brush.Color);
  DoGifDiv(LLeft, LTop, Pixel, LHeight, Converter.Pen.Color);
  DoGifDiv(LLeft, LTop + LHeight, LWidth, Pixel, Converter.Pen.Color);
  DoGifDiv(LLeft + LWidth, LTop, Pixel, LHeight, Converter.Pen.Color);
  DoGifDiv(LLeft, LTop, LWidth, Pixel, Converter.Pen.Color);
end;

procedure TRPRenderHTML.WriteDiv(const AText: String; const AX1, AY1: Double;
 const AWidth: double = 0; const AHeight: Double = 0);
var
  s: string;
begin
  ffMaxY := Max(AY1 + AHeight, ffMaxY);
  s := '';
  if AWidth > 0 then begin
    s := s + 'width:' + IntToStr(InchesToPixels(AWidth)) + ';';
  end;
  if AHeight > 0 then begin
    s := s + 'height:' + IntToStr(InchesToPixels(AHeight)) + ';';
  end;
  PrintLn('<DIV STYLE="left:' + IntToStr(InchesToPixels(AX1) + FOffsetX) + ';top:'
   + IntToStr(InchesToPixels(AY1) + FOffsetY) + ';' + s + GetFontStyle(Converter.Font) + '">'
   + AText + '</DIV>');
end;

Function TRPRenderHTML.HTMLColor;
begin
	Result := IntToHex(ColorToRGB(colr), 6);
	Result := Result[5] + Result[6] + Result[3] + Result[4] + Result[1] + Result[2];
end;

function TRPRenderHTML.HTMLText(const psText: string): string;
begin
  {TODO: Convert special chars in psText}
  result := psText;
end;

function TRPRenderHTML.GetFontStyle(AFont: TFont): string;
begin
  Result := 'font:';
  if fsItalic in AFont.Style then begin
    Result := Result + 'italic ';
  end else begin
    Result := Result + 'normal ';
  end;
  if fsBold in AFont.Style then begin
    Result := Result + 'bold ';
  end else begin
    Result := Result + 'normal ';
  end;
  Result := Result + IntToStr(AFont.Size) + 'pt ''' + AFont.Name + '''';
  if fsUnderline in AFont.Style then begin
    Result := Result + ';text-decoration:underline';
  end;
  if AFont.Color <> clNone then begin
    Result := Result + ';color:#' + ColorToRGBString(AFont.Color);
  end;
end;

function TRPRenderHTML.ColorToRGBString(AColor: TColor): string;
begin
  Result := IntToHex(ColorToRGB(AColor), 6);
  Result := Result[5] + Result[6] + Result[3] + Result[4] + Result[1] + Result[2];
end;

procedure TRPRenderHTML.LineTo(const pfX1, pfY1: Double);
begin
  if (pfX1 = Converter.CurrX) or (pfY1 = Converter.CurrY) then begin
    DoGifDiv(Converter.CurrX, Converter.CurrY, pfX1 - Converter.CurrX, pfY1 - Converter.CurrY
     , Converter.Pen.Color);
  end;
end;

procedure TRPRenderHTML.PrintBitmapRect(const AX1, AY1, AX2, AY2: Double;
 AGraphic:
  {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}.TBitmap);
var
  LFilename: string;
  LPathURL: string;
begin
  LFilename := NewCacheFile('jpg');
  ToJPegFile(AGraphic, LFilename);
  if ServerMode then begin
    LPathURL := '/Cache/' + ExtractFilename(LFilename);
  end else begin
    LPathURL := CacheDir;
    if Length(LPathURL) = 0 then begin
      LPathURL := GetCurrentDir;
    end;
    if not (LPathURL[Length(LPathURL)] in ['/', '\']) then begin
      LPathURL := LPathURL + '/';
    end;
    LPathURL := ProcessURL(LPathURL + ExtractFilename(LFilename));
  end;
  //TODO: Scale image during call to ToJPegFile instead of using browsers scaling
  WriteDiv('<IMG Src="' + LPathURL + '" width='
   + IntToStr(InchesToPixels(AX2 - AX1)) + ' height=' + IntToStr(InchesToPixels(AY2 - AY1)) + '>'
   , AX1, AY1, AX2 - AX1, AY2 - AY1);
end;

procedure TRPRenderHTML.StretchDraw(const Rect: TRect; AGraphic: TGraphic);
var
  LFilename: string;
  LPathURL: string;
  Bitmap:
    {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}.TBitmap;
  Rect1: TRect;
  MetafileDPI: integer;
begin
  Bitmap :=
    {$IFDEF Linux}QGraphics{$ELSE}Graphics{$ENDIF}.TBitmap.Create;
  try
    Rect1.Left := 0;
    Rect1.Top := 0;
    Rect1.Right := Rect.Right - Rect.Left;
    MetafileDPI := 300;
    Rect1.Right := Round(Rect1.Right / 72 * MetafileDPI);
    Rect1.Bottom := Rect.Bottom - Rect.Top;
    Rect1.Bottom := Round(Rect1.Bottom / 72 * MetafileDPI);
    Bitmap.Width := Rect1.Right;
    Bitmap.Height := Rect1.Bottom;
    Bitmap.Canvas.StretchDraw(Rect1, AGraphic);
    LFilename := NewCacheFile('jpg');
    If not ServerMode then begin
      SetLength(LFilename,Pos('.',LFilename));
      LFilename := LFilename + 'jpg';
    end; { if }
    ToJPegFile(Bitmap, LFilename);
  finally
    Bitmap.Free;
  end; { tryf }
  if ServerMode then begin
    LPathURL := '/Cache/' + ExtractFilename(LFilename);
  end else begin
    LPathURL := CacheDir;
    if Length(LPathURL) = 0 then begin
      LPathURL := GetCurrentDir;
    end;
    if not (LPathURL[Length(LPathURL)] in ['/', '\']) then begin
      LPathURL := LPathURL + '/';
    end;
    LPathURL := ProcessURL(LPathURL + ExtractFilename(LFilename));
  end;
  //TODO: Scale image during call to ToJPegFile instead of using browsers scaling
  WriteDiv('<IMG Src="' + LPathURL + '" width='
   + IntToStr(InchesToPixels((Rect.Right / 72) - (Rect.Left / 72)))
   + ' height=' + IntToStr(InchesToPixels((Rect.Bottom / 72) - (Rect.Top / 72))) + '>'
   , Rect.Left / 72, Rect.Top / 72, (Rect.Right / 72) - (Rect.Left / 72)
   , (Rect.Bottom / 72) - (Rect.Top / 72));
end;

function TRPRenderHTML.NewCacheFile(APrefix: string): string;
var
  ActiveCacheDir: string;
begin
  //TODO change to use SystemCrispi.MakeTempFilename
  SetLength(Result, MAX_PATH + 1);
  ActiveCacheDir := CacheDir;
  if Length(ActiveCacheDir) = 0 then begin
    ActiveCacheDir := GetCurrentDir();
  end;
  {$IFDEF Linux}
  Result := tempnam(PChar(ActiveCacheDir), PChar(APrefix));
  if Result = '' then begin
    raise Exception.Create('NewCacheFile error.');
  end;
  {$ELSE}
  if GetTempFileName(PChar(ActiveCacheDir), PChar(APrefix), 0, PChar(Result)) = 0 then begin
    raise Exception.Create('NewCacheFile error.');
  end;
  {$ENDIF}
  Result := PChar(Result);
end;

procedure	TRPRenderHTML.ToJPEGFile(AGraphic: TGraphic; const AFileName: String);
begin
  {$IFDEF Linux}
  with TNDGraphic.Create do try
    Assign(AGraphic);
    Format := gfJPEG;
    SaveToFile(AFilename);
  finally Free end;
  {$ELSE}
	if AGraphic is TJPEGImage then begin
		TJPEGImage(AGraphic).SaveToFile(AFileName);
	end else begin
		with TJPEGimage.Create do try
			Assign(AGraphic);
			JPEGneeded;
			Compress;
			SaveToFile(AFileName);
    finally Free end;
	end;
  {$ENDIF}
end;

class procedure TRPRenderHTML.CreateColorGif(AStream: TStream; AColor: TColor);
const
  Prefix: array[1..13] of byte = ($47,$49,$46,$38,$39,$61,$02,$00,$02,$00,$B3,$00,$00);
  Suffix: array[1..62] of byte = ($00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
   $00,$00,$00,$00,$00,$00,$00,$2C,$00,$00,$00,$00,$02,$00,$02,$00,$00,$04,$03,$10,$48,$10,$00,$3B);
var
  LByte: Byte;
  LColor: LongInt;
begin
  with AStream do begin
    WriteBuffer(Prefix, Length(Prefix));
    LColor := ColorToRGB(AColor);
    LByte := (LColor and $000000FF);
    WriteBuffer(LByte, SizeOf(LByte));
    LByte := (LColor and $0000FF00) shr 8;
    WriteBuffer(LByte, SizeOf(LByte));
    LByte := (LColor and $00FF0000) shr 16;
    WriteBuffer(LByte, SizeOf(LByte));
    WriteBuffer(Suffix, Length(Suffix));
  end;
end;

procedure TRPRenderHTML.DoGifDiv(const AX, AY, AWidth, AHeight: Single; AColor: TColor);

var
  PathURL: string;
  ImageStream: TMemoryStream;

begin
  if ServerMode then begin
    PathURL := '/Color/' + HTMLColor(AColor) + '.gif';
  end else begin
    PathURL := CacheDir;
    if PathURL = '' then begin
      PathURL := GetCurrentDir;
    end; { if }
    if (PathURL[Length(PathURL)] <> '/') and
       (PathURL[Length(PathURL)] <> '\') then begin
      PathURL := PathURL + '/';
    end; { if }
    PathURL := PathURL + HTMLColor(AColor) + '.gif';
    PathURL := ProcessURL(PathURL);
    ImageStream := TMemoryStream.Create;
    try
      CreateColorGif(ImageStream, AColor);
      ImageStream.SaveToFile(ExpandFileName(PathURL));
    finally
      ImageStream.Free;
    end; { tryf }
  end;
  WriteDiv('<IMG SRC="' + PathURL + '" WIDTH='
   + IntToStr(Max(InchesToPixels(AWidth), 1)) + ' HEIGHT='
   + IntToStr(Max(InchesToPixels(AHeight), 1)) + '>', AX, AY, AWidth, AHeight);
end;

procedure TRPRenderHTML.CenterText(const psText: String; const pfX, pfY: Double);
begin
  WriteDiv('<P ALIGN=CENTER>' + HTMLText(psText), 0, pfY - Converter.FontHeight - Pixel, pfX * 2);
end;

procedure TRPRenderHTML.RightText(const psText: String; const pfX, pfY: Double);
begin
//  WriteDiv('<TABLE BORDER=0 CELLPADDING=0 CELLSPACING=0><TR><TD WIDTH='
//   + IntToStr(InchesToPixels(pfX)) + '><P ALIGN=RIGHT>' + HTMLText(psText)
//   + '</TD></TR></TABLE>', 0, pfY - Converter.FontHeight - Pixel);
  // This works better, but does not work properly in NS - The above table doesnt work in IE
  // it loses the font info.
  WriteDiv('<P ALIGN=RIGHT>' + HTMLText(psText), 0, pfY - Converter.FontHeight, pfX);
end;

constructor TRPRenderHTML.Create(AOwner: TComponent);
begin
  inherited;
  SetDefaultTemplate;
  DisplayName := 'Web Page (HTML)';
  FileExtension := '*.html;*.htm';
end;

function TRPRenderHTML.GetTemplate: string;
begin
  Result := FTemplateHead + FTemplatePre + '{%Report%}' + FTemplatePost;
end;

procedure TRPRenderHTML.SetTemplate(const AValue: string);
var
  i: integer;
  s: string;
begin
  if Length(AValue) = 0 then begin
    SetDefaultTemplate;
  end else begin
    //TODO: Pos on uppercase is not efficient.
    i := Pos('{%REPORT%}', Uppercase(AValue));
    if i = 0 then begin
      raise Exception.Create('{%Report%} tag not found.');
    end;
    FTemplatePre := Copy(AValue, 1, i - 1);
    FTemplatePost := Copy(AValue, i + 10, MaxInt);
    //
    //TODO: Pos on uppercase is not efficient.
    i := Pos('</HEAD', Uppercase(FTemplatePre));
    if i = 0 then begin
      raise Exception.Create('</HEAD> tag not found.');
    end;
    FTemplateHead := Copy(FTemplatePre, 1, i - 1);
    FTemplatePre := Copy(FTemplatePre, i, MaxInt);
    // Extract offsets
    i := Pos('<RAVE ', AValue);
    if i > 0 then begin
      s := Copy(AValue, i + 6, MaxInt);
      i := Pos('>', s);
      if i > 0 then begin
        SetLength(s, i - 1);
        with TStringList.Create do try
          CommaText := StringReplace(s, ' ', ',', [rfReplaceAll]);
          FOffsetX := StrToInt(Values['OffsetX']);
          FOffsetY := StrToInt(Values['OffsetY']);
        finally Free; end;
      end;
    end;
  end;
end;

function TRPRenderHTML.ProcessParams(const AHTML: string): string;
begin
  Result := AHTML;
  Result := StringReplace(Result, '{%PageNo%}', IntToStr(Converter.PageNo), [rfReplaceAll
   , rfIgnoreCase]);
  Result := StringReplace(Result, '{%TotalPages%}', IntToStr(Converter.PageCount), [rfReplaceAll
   , rfIgnoreCase]);
  Result := StringReplace(Result, '{%MaxY%}', IntToStr(InchesToPixels(ffMaxY + 1) + FOffsetY)
   , [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '{%PrevPageURL%}', 'javascript:PrevPage();', [rfReplaceAll]);
  Result := StringReplace(Result, '{%NextPageURL%}', 'javascript:NextPage();', [rfReplaceAll]);
  Result := StringReplace(Result, '{%FirstPageURL%}', 'javascript:GotoPage(1);', [rfReplaceAll
   , rfIgnoreCase]);
  Result := StringReplace(Result, '{%LastPageURL%}', 'javascript:NextPage('
   + IntToStr(Converter.PageCount) + ');', [rfReplaceAll, rfIgnoreCase]);
end;

procedure TRPRenderHTML.FillRect(const pRect: TRect);
begin
  Rectangle(pRect.Left / 72, pRect.Top / 72, pRect.Right / 72, pRect.Bottom / 72);
end;

function TRPRenderHTML.ProcessURL(AValue: string): string;
begin
  Result := StringReplace(AValue, '\', '/', [rfReplaceAll]);
end;

procedure TRPRenderHTML.SetDefaultTemplate;
begin
  FTemplateHead := '';
  with TStringList.Create do try
    {TODO: Make the prev/next page buttons "pretty"}
    Add('<HTML><HEAD>');
    Add('<STYLE TYPE="text/css">');
    Add('<!--');
    Add('DIV {position:absolute}');
    Add('-->');
    Add('</STYLE>');
    Add('</HEAD>');
    Add('<BODY>');
    FTemplatePre := Text;
    Clear;
    Add('<DIV style="COLOR: #000000; FONT: 10pt ''Arial''; LEFT: 0px; TOP: {%MaxY%}px">');
    Add('<HR><P ALIGN=CENTER>');
    Add('<A HREF="{%PrevPageURL%}">Previous Page</A>');
    Add(' --------- ');
    Add('<A HREF="{%NextPageURL%}">Next Page</A>');
    Add('</P></DIV></BODY></HTML>');
    FTemplatePost := Text;
  finally Free; end;
end;

procedure TRPRenderHTML.PrintRender(NDRStream: TStream;
                                    OutputFileName: TFileName);
var
  I1: integer;
  LTotalPages: integer;
  LExt: string;
  LBasePathName: string;
  LRender: TRPRenderHTML;
begin
  LExt := ExtractFileExt(OutputFileName);
  LBasePathName := ExtractFilePath(OutputFileName) + ExtractFileName(OutputFileName);
  SetLength(LBasePathname,Length(LBasePathname) - Length(LExt));
  If (LExt = '') or (LExt = '.') then begin
    LExt := Copy(FileExtension, Pos('.',FileExtension),Length(FileExtension));
    If Pos(';',LExt) > 0 then begin
      LExt := Copy(LExt, 0, Pos(';',LExt) - 1);
    end; { if }
  end; { if }
  LTotalPages := 1;
  I1 := 1;
  While I1 <= LTotalPages do begin
    NDRStream.Position := 0;
    LRender := TRPRenderHTML.Create(self);
    LRender.CacheDir := CacheDir;
    LRender.ServerMode := ServerMode;

    LRender.InitFileStream(LBasePathname + IntToStr(I1) + LExt);
    try
      LRender.PageURL := ExtractFilename(LBasePathname + '{%PAGENO%}' + LExt);
      with TRPConverter.Create(NDRStream, LRender) do try
        Generate(I1);
        LTotalPages := PageCount;
      finally
        Free;
      end; { with }
    finally
      LRender.Free;
    end; { tryf }
    Inc(I1);
  end; { while }
end;

end.