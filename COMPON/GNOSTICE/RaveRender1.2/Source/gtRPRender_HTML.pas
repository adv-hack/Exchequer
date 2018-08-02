{***************************************************************************}
{                                                                           }
{  Gnostice RaveRender                                                      }
{                                                                           }
{  Copyright © 2000-2003 Gnostice Information Technologies Private Limited  }
{  http://www.gnostice.com                                                  }
{                                                                           }
{***************************************************************************}

{$I gtDefines.Inc}
{$I gtRPDefines.Inc}

unit gtRPRender_HTML;

interface

uses
	SysUtils, Windows, Messages, Classes, Graphics, Forms, Dialogs, StdCtrls,
	Controls, RPRender, gtRPRender_Main, gtRPRender_Document,
	gtRPRender_Consts, gtRPRender_Utils;

type

	// Navigator Type.
	TgtRPNavigatorType = (ntFixedToScreen, ntFixedToPage);

{ TgtRPRenderHTML class }

	TgtRPRenderHTML = class(TgtRPRenderDocument)
	private
		FCSSFileName: string;
		FDefaultFont: TFont;
		FImageFolder: string;
		FLinkTextFirst: string;
		FLinkTextNext: string;
		FLinkTextPrev: string;
		FLinkTextLast: string;
		FLinkBackColor: TColor;
		FLinkHoverForeColor: TColor;
		FLinkHoverBackColor: TColor;
		FLinkImgSRCFirst: string;
		FLinkImgSRCNext: string;
		FLinkImgSRCPrev: string;
		FLinkImgSRCLast: string;
		FLinkFont: TFont;
		FNavigatorType: TgtRPNavigatorType;
		// If OptimizeForIE = True,
		// it optimizes by defining and reusing attribute classes
		FOptimizeForIE: Boolean;
		// If OutputStylesToCSSFile = True,
		// CSS Style tags are stored in separate file
		FOutputStylesToCSSFile: Boolean;
		// If PageEndLines = True, a line is drawn after each page
		FPageEndLines: Boolean;
		// If SeparateFilePerPage = True, New file is created for each page
		FSeparateFilePerPage: Boolean;
		// If ShowNavigator = True, shows Navigator in each page
		FShowNavigator: Boolean;
		// If UseTextLinks = True, text links are used instead of image links
		FUseTextLinks: Boolean;

		FOnMakeImageFileName: TMakeImageFileNameEvent;

		FCSSClasses: TStringList;
		FCSSFileEncodeName: string;
		FCSSFileCreateName: string;
		FDefaultFontAttrib: TgtRPFontAttrib;
		FHTMLStream: TMemoryStream;
		FImageFileNames: TStringList;
		FImageEncodeDir: string;
		FImageCreateDir: string;
		FNavigatorHeight: Extended;
		FNavigatorWidth: Extended;
		FPositionAbsolute: string;

		function IsLinkTextFirstStored: Boolean;
		function IsLinkTextLastStored: Boolean;
		function IsLinkTextPrevStored: Boolean;
		function IsLinkTextNextStored: Boolean;
		function GetImageFileCount: Integer;
		procedure SetLinkFont(const Value: TFont);
		procedure SetDefaultFont(const Value: TFont);

		function ConstructStyleStrings: string;
		function GetBackground: string;
		function GetColorCSS(FontAttrib: TgtRPFontAttrib): string;
		function GetFontCSS(FontAttrib: TgtRPFontAttrib): string;
		function GetFontDecorCSS(FontAttrib: TgtRPFontAttrib): string;
		function GetFontInfo(FontAttrib: TgtRPFontAttrib): string;
		function GetFontSizeCSS(FontAttrib: TgtRPFontAttrib): string;
		function GetFontStyleCSS(FontAttrib: TgtRPFontAttrib): string;
		function GetJavaScripts: string;
		function GetNavigatorStyle: string;
		function GetOffsetFromTop: Integer;
		function GetRectDetails: string;
		function MakeHTMLImageFileName(AGraphic: TGraphic; AWidth, AHeight: Double;
			var AAltText: string): string;

		procedure CalculateNavigatorDimensions;
		procedure EncodeImage(const AFileName, AAltText: string;
			ATop, ALeft, AWidth, AHeight: double);
    {$IFDEF Rave407Up}
		  procedure EncodePolyLine(const PolyLineArr: array of {$IFDEF Rave50Up}
      	TFloatPoint {$ELSE} TPoint {$ENDIF}; IsPolygon: Boolean);
    {$ENDIF}
		procedure EncodeText(ATextDetails: TgtRPTextDetails; IsClipping: Boolean);
		procedure EncodeRect(ATop, ALeft, AWidth, AHeight: Double);
		procedure WriteHeader;
		procedure WriteFooter;
		procedure	WriteToHTMLStream(const AText: string);

	protected
		function GetNativeText(const Text: string): string; override;
		function ShowSetupModal: Word; override;

		procedure Arc(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3,
			pfX4, pfY4: Double); override;
		procedure Chord(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3,
			pfX4, pfY4: Double); override;
		procedure CreateEMailInfoObj; override;
		procedure DocBegin; override;
		procedure DocEnd; override;
		procedure Draw(const pfX1, pfY1: Double; AGraphic: TGraphic); override;
		procedure Ellipse(const pfX1, pfY1, pfX2, pfY2: Double); override;
		procedure EndText; override;
		procedure FillRect(const pRect: TRect); override;
		procedure LineTo(const pfX1, pfY1: Double); override;
		procedure PageBegin; override;
		procedure PageEnd; override;
		procedure Pie(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3,
			pfX4, pfY4: Double); override;
    {$IFDEF Rave407Up}
      procedure PolyLine(const PolyLineArr: array of {$IFDEF Rave50Up}
      	TFloatPoint {$ELSE} TPoint {$ENDIF}); override;
  		procedure Polygon(const PolyLineArr: array of {$IFDEF Rave50Up}
      	TFloatPoint {$ELSE} TPoint {$ENDIF}); override;
    {$ENDIF}
		procedure PrintBitmap(const X1, Y1, ScaleX, ScaleY: Double;
			AGraphic: Graphics.TBitmap); override;
		procedure PrintBitmapRect(const X1, Y1, X2, Y2: Double;
			AGraphic: Graphics.TBitmap); override;
		procedure Rectangle(const pfX1, pfY1, pfX2, pfY2: Double); override;
		procedure RoundRect(const pfX1, pfY1, pfX2, pfY2,
			pfX3, pfY3: Double); override;
		procedure StretchDraw(const pRect: TRect; AGraphic: TGraphic); override;
		procedure TextRect(Rect: TRect; X1, Y1: double; S1: string); override;

	public
		constructor Create(AOwner: TComponent); override;
		destructor Destroy; override;

		procedure CancelExport; override;
  {$IFDEF Rave50Up}
    procedure RenderPage(PageNum: integer); override;
  {$ELSE}
		procedure PrintRender(NDRStream: TStream;
			OutputFileName: TFileName); override;
  {$ENDIF}

		property ImageFileCount: Integer read GetImageFileCount;
		property ImageFileNames: TStringList read FImageFileNames;

	published
		property Author;
		property BackgroundColor;
		property BackgroundImage;
		property BackgroundImageDisplayType;
		property Creator;
		property CSSFileName: string read FCSSFileName write FCSSFileName;
		property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
		property ExportImageFormat;
		property ImageDPI;
		property ImagePixelFormat;
		property ImageFolder: string read FImageFolder write FImageFolder;
		property IncludeImages;
		property IncludeLines;
		property IncludeNonRectShapes;
		property JPEGQuality;
		property Keywords;
		property LinkTextFirst: string read FLinkTextFirst write FLinkTextFirst
			stored IsLinkTextFirstStored;
		property LinkTextNext: string read FLinkTextNext write FLinkTextNext
			stored IsLinkTextNextStored;
		property LinkTextPrev: string read FLinkTextPrev write FLinkTextPrev
			stored IsLinkTextPrevStored;
		property LinkTextLast: string read FLinkTextLast write FLinkTextLast
			stored IsLinkTextLastStored;
		property LinkBackColor: TColor read FLinkBackColor write FLinkBackColor
			default cLinkBackColor;
		property LinkHoverForeColor: TColor read FLinkHoverForeColor
			write FLinkHoverForeColor default cLinkHoverForeColor;
		property LinkHoverBackColor: TColor read FLinkHoverBackColor
			write FLinkHoverBackColor default cLinkHoverBackColor;
		property LinkImgSRCFirst: string read FLinkImgSRCFirst
			write FLinkImgSRCFirst;
		property LinkImgSRCNext: string read FLinkImgSRCNext write FLinkImgSRCNext;
		property LinkImgSRCPrev: string read FLinkImgSRCPrev write FLinkImgSRCPrev;
		property LinkImgSRCLast: string read FLinkImgSRCLast write FLinkImgSRCLast;
		property LinkFont: TFont read FLinkFont write SetLinkFont;
		property NavigatorType: TgtRPNavigatorType read FNavigatorType
			write FNavigatorType default ntFixedToScreen;
		property OptimizeForIE: Boolean read FOptimizeForIE write FOptimizeForIE
			default True;
		property OutputStylesToCSSFile: Boolean read FOutputStylesToCSSFile
			write FOutputStylesToCSSFile default True;
		property PageEndLines: Boolean read FPageEndLines write FPageEndLines
			default True;
		property SeparateFilePerPage: Boolean read FSeparateFilePerPage
			write FSeparateFilePerPage default True;
		property ShowNavigator: Boolean read FShowNavigator write FShowNavigator
			default True;
		property Subject;
		property Title;
		property UseTextLinks: Boolean read FUseTextLinks write FUseTextLinks
			default True;

		// Event published only for HTML Render
		property OnMakeImageFileName: TMakeImageFileNameEvent
			read FOnMakeImageFileName write FOnMakeImageFileName;

	end;

const

	TgtBackgroundRepeat: array[Boolean] of string = ('repeat', 'no-repeat');
	TgtBackgroundPosition: array[TgtRPBackgroundDisplayType] of string =
		('center', 'top left', 'top center', 'top right', 'center left', 'center',
		'center right', 'bottom left', 'bottom center', 'bottom right');

	ANSICodePageIDs: array[0..13] of record
		ISOCode: string;
		WinCode: Integer;
	end = (
	{ 874 Thai }
		(ISOCode: 'ISO-8859-11'; WinCode: 874),
	{ 932 Japan }
		(ISOCode: 'Windows-932'; WinCode: 932),
	{ 936 Chinese (PRC, Singapore) }
		(ISOCode: 'gb2312-80'; WinCode: 936),
	{ 949 Korean }
		(ISOCode: 'Windows-949'; WinCode: 949),
	{ 950 Chinese (Taiwan, Hong Kong) }
		(ISOCode: 'csbig5'; WinCode: 950),
	{ 1200 Unicode (BMP of ISO 10646) }
		(ISOCode: 'ISO-10646'; WinCode: 1200),
	{ 1250 Windows 3.1 Eastern European }
		(ISOCode: 'ISO-8859-2'; WinCode: 1250),
	{ 1251 Windows 3.1 Latin/Cyrillic }
		(ISOCode: 'ISO-8859-5'; WinCode: 1251),
	{ 1252 Windows 3.1 Latin 1 (US, Western Europe) }
		(ISOCode: 'ISO-8859-1'; WinCode: 1252),
	{ 1253 Windows 3.1 Greek }
		(ISOCode: 'ISO-8859-7'; WinCode: 1253),
	{ 1254 Windows 3.1 Turkish }
		(ISOCode: 'ISO-8859-9'; WinCode: 1254),
	{ 1255 Hebrew }
		(ISOCode: 'ISO-8859-8'; WinCode: 1255),
	{ 1256 Latin/Arabic }
		(ISOCode: 'ISO-8859-6'; WinCode: 1256),
	{ 1257 Baltic }
		(ISOCode: 'ISO-8859-13'; WinCode: 1257)
		);

	{--- HTML: Text prepended with cHTMLNoTranslate does not get translated.     }
	{    For example: space characters do not get replaced with '&nbps;'.        }
	{		 Use when specifying URLs that need to be active in the generated HMTL.  }
	cHTMLNoTranslateText = #1#1#1;

implementation

uses gtRPRender_MainDlg, gtRPRender_DocumentDlg, gtRPRender_HTMLDlg;

{------------------------------------------------------------------------------}
{ TgtRPRenderHTML }
{------------------------------------------------------------------------------}

constructor TgtRPRenderHTML.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);

	DisplayName := sHTMLDesc;
	FileExtension := '*.html;*.htm';
	FCSSFileName := '';
	FDefaultFont := TFont.Create;
	FDefaultFont.Name := 'Arial';
	FDefaultFont.Size := 10;
	FImageFolder := '';
	FLinkTextFirst := sLinkTextFirst;
	FLinkTextPrev := sLinkTextPrev;
	FLinkTextNext := sLinkTextNext;
	FLinkTextLast := sLinkTextLast;
	FLinkFont := TFont.Create;
	FLinkFont.Name := 'Wingdings';
	FLinkFont.Size := 18;
	FLinkFont.Color := cLinkForeColor;
	FLinkBackColor := cLinkBackColor;
	FLinkHoverForeColor := cLinkHoverForeColor;
	FLinkHoverBackColor := cLinkHoverBackColor;
	FLinkImgSRCFirst := '';
	FLinkImgSRCNext := '';
	FLinkImgSRCPrev := '';
	FLinkImgSRCLast := '';
	FNavigatorType := ntFixedToScreen;
	FOptimizeForIE := True;
	OutputStylesToCSSFile := True;
	FPageEndLines := True;
	FSeparateFilePerPage := True;
	FShowNavigator := True;
	FUseTextLinks := True;

	FImageFileNames := TStringList.Create;
end;

{------------------------------------------------------------------------------}

destructor TgtRPRenderHTML.Destroy;
begin
	FImageFileNames.Free;
	FDefaultFont.Free;
	FLinkFont.Free;
	inherited Destroy;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderHTML.IsLinkTextLastStored: Boolean;
begin
	Result := FLinkTextLast <> sLinkTextLast;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderHTML.IsLinkTextFirstStored: Boolean;
begin
	Result := FLinkTextFirst <> sLinkTextFirst;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderHTML.IsLinkTextPrevStored: Boolean;
begin
	Result := FLinkTextPrev <> sLinkTextPrev;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderHTML.IsLinkTextNextStored: Boolean;
begin
	Result := FLinkTextNext <> sLinkTextNext;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderHTML.GetImageFileCount: Integer;
begin
	Result := FImageFileNames.Count;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.SetLinkFont(const Value: TFont);
begin
	FLinkFont.Assign(Value);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.SetDefaultFont(const Value: TFont);
begin
	FDefaultFont.Assign(Value);
	with FDefaultFontAttrib do
	begin
		Charset := Value.Charset;
		Name := Value.Name;
		Pitch := Value.Pitch;
		Size := Value.Size;
		Color := Value.Color;
		Style := Value.Style;
	end;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderHTML.ConstructStyleStrings: string;
var
	I: Integer;
begin
	Result := '';
	for I := 0 to FCSSClasses.Count - 1 do
		Result := Result + CRLF +
			'.S' + NumToStr(I) + ' {' + FCSSClasses[I] + '}';
end;

{------------------------------------------------------------------------------}

function TgtRPRenderHTML.GetBackground: string;
var
	ImageFileName: string;
	Bmp: TBitmap;
begin
// Encode Background Color, Background Image
	Result := '';
	if BackgroundImage.Graphic <> nil then
	begin
		Bmp := TBitmap.Create;
		try
			Bmp.Width := BackgroundImage.Width;
			Bmp.Height := BackgroundImage.Height;
			Bmp.Transparent := True;
			Bmp.Canvas.Draw(0, 0, BackgroundImage.Graphic);
			ImageFileName := 	SaveBitmapAs(Bmp, ExportImageFormat, JPEGQuality,
				FImageCreateDir + ChangeFileExt(ExtractFileName(FOutputFileName), '') +
				'BgImage');
		finally
			Bmp.Free;
		end;
	end;
	if ImageFileName <> '' then
		Result := 'url(' + FImageEncodeDir + ExtractFileName(ImageFileName) + ') ';
	Result := '  BODY {background: ' + Result + '#' +
		ColorBGRToRGB(BackgroundColor) + ' ' +
		TgtBackgroundRepeat[BackgroundImageDisplayType <> dtTile] + ' ' +
		TgtBackgroundPosition[BackgroundImageDisplayType] + ' fixed}';
end;

{------------------------------------------------------------------------------}

function TgtRPRenderHTML.GetColorCSS(FontAttrib: TgtRPFontAttrib): string;
begin
// Encode Font color
	Result := 'color: #' + ColorBGRToRGB(FontAttrib.Color);
end;

{------------------------------------------------------------------------------}

function TgtRPRenderHTML.GetFontCSS(FontAttrib: TgtRPFontAttrib): string;
begin
// Encode Font Details
	Result := GetFontStyleCSS(FontAttrib);
	if Result <> '' then Result := Result + ' ';
	Result := Result +
		GetFontSizeCSS(FontAttrib) + ' ' +
		FontAttrib.Name +
		GetFontDecorCSS(FontAttrib);
	Result := Trim(Result) + '; ' + GetColorCSS(FontAttrib);
end;

{------------------------------------------------------------------------------}

function TgtRPRenderHTML.GetFontDecorCSS(FontAttrib: TgtRPFontAttrib): string;
begin
// Encode Underline & Strikeout
	Result := '';
	with FontAttrib do
		if Style - [fsBold, fsItalic] <> [] then
		begin
			Result := '; text-decoration:';
			if fsUnderline in Style then
				Result := Result + ' underline';
			if fsStrikeOut in Style then
				Result := Result + ' line-through';
		end;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderHTML.GetFontInfo(FontAttrib: TgtRPFontAttrib): string;

	function IsFontMatching: Boolean;
	begin
		with FontAttrib do
			Result := (Size = FDefaultFontAttrib.Size) and
				(Name = FDefaultFontAttrib.Name) and
				(Style = FDefaultFontAttrib.Style) and
				(Color = FDefaultFontAttrib.Color);
	end;

var
	I: Integer;
begin
	Result := '';
	if OptimizeForIE then
	begin
		if not IsFontMatching then
		begin
			Result := 'font: ' + GetFontCSS(FontAttrib);
			I := FCSSClasses.IndexOf(Result);
			if I = -1 then
				I := FCSSClasses.Add(Result);
			Result := '" CLASS="S' + NumToStr(I);
		end;
	end
	else
		Result := '; font: ' + GetFontCSS(FontAttrib);
end;

{------------------------------------------------------------------------------}

function TgtRPRenderHTML.GetFontSizeCSS(FontAttrib: TgtRPFontAttrib): string;
begin
// Encode FontSize
	Result := NumToStr(Abs(FontAttrib.Size)) + 'pt';
end;

{------------------------------------------------------------------------------}

function TgtRPRenderHTML.GetFontStyleCSS(FontAttrib: TgtRPFontAttrib): string;
const
	Bold: array[Boolean] of string = ('', ' bold');
	Italic: array[Boolean] of string = ('', ' italic');
begin
// Encode Bold, Italic. Should be encoded before FontSize & FontName
	Result := '';
	with FontAttrib do
		Result := Italic[fsItalic in Style] + Bold[fsBold in Style];
end;

{------------------------------------------------------------------------------}

{ Return JavaScript for page Navigator. JavaScript will be either embedded in
	HEAD of the HTML Document or in a separate JavaScript File. }
function TgtRPRenderHTML.GetJavaScripts: string;
const
	HTAB = #09;
var
	AWindowPixelLeft, AWindowPixelTop: string;
begin
	AWindowPixelLeft := 'document.body.scrollLeft + ' +
		'document.body.clientWidth - ' + NumToStr(FNavigatorWidth);
	AWindowPixelTop := 'document.body.scrollTop + ' +
		'document.body.clientHeight - ' + NumToStr(FNavigatorHeight);

	Result := 'function floatNavigator(){' + CRLF + HTAB +
		'if (document.all){' +
		'document.all.gtNavigator.style.pixelTop = ' + AWindowPixelTop +
		';document.all.gtNavigator.style.pixelLeft = ' + AWindowPixelLeft +
		';}' + CRLF + HTAB +
		'else if(document.getElementById){document.getElementById(' +
		'''gtNavigator'').style.top = window.pageYOffset + ' +
		'''px'';document.getElementById(''gtNavigator'').style.left = ' +
		'window.pageXOffset + ''px'';}' + CRLF +
		'}' + CRLF +  

		'if (document.all){window.onresize = SetResizeLeft;' +
		'window.onscroll = floatNavigator;}' + CRLF +
		'else setInterval (''floatNavigator()'', 100);' + CRLF + 

		'function initNavigator(){' + CRLF +
		'if (document.all){' +
		'document.all.gtNavigator.style.pixelTop = ' + AWindowPixelTop +
		';document.all.gtNavigator.style.pixelLeft = ' + AWindowPixelLeft +
		';document.all.gtNavigator.style.visibility = ' +
		'''visible'';}' + CRLF + HTAB +
		'else if (document.getElementById){' +
		'document.getElementById(''gtNavigator'').style.top = ' +
		'window.pageYOffset + ''px''' +
		';document.getElementById(''gtNavigator'').style.left = ' +
		'window.pageYOffset + ''px'';' +
		'document.getElementById(''gtNavigator'').style.visibility = ' +
		'''visible'';}' + CRLF +
		'}' + CRLF + 

		'function SetResizeLeft(){' + CRLF + HTAB +
		'if (document.all){' +
		'document.all.gtNavigator.style.pixelTop = ' + AWindowPixelTop +
		';document.all.gtNavigator.style.pixelLeft = ' + AWindowPixelLeft +
		';}' + CRLF + HTAB +
		'else if (document.getElementById){document.getElementById(' +
		'''gtNavigator'').style.top = window.pageYOffset + ' +
		'''px'';document.getElementById(''gtNavigator''' +
		').style.left = window.pageYOffset + ''px'';}' + CRLF +
		'}';
end;

{------------------------------------------------------------------------------}

function TgtRPRenderHTML.GetNavigatorStyle: string;
begin
// Encode Navigator Styles
	Result :=
		'A:link {font: ' + NumToStr(FLinkFont.Size) + 'pt ' + FLinkFont.Name +
			'; text-decoration: none; color: #' + ColorBGRToRGB(FLinkFont.Color) +
			'; background-color: #' + ColorBGRToRGB(FLinkBackColor) +
			'}' + CRLF +
		'A:visited {font: ' + NumToStr(FLinkFont.Size) + 'pt ' + FLinkFont.Name +
			'; text-decoration: none; color: #' + ColorBGRToRGB(FLinkFont.Color) +
			'; background-color: #' + ColorBGRToRGB(FLinkBackColor) +
			'}' + CRLF +
		'A:hover {font: ' + NumToStr(FLinkFont.Size) + 'pt ' + FLinkFont.Name +
			'; text-decoration: none; color: #' + ColorBGRToRGB(FLinkHoverForeColor) +
			'; background-color: #' + ColorBGRToRGB(FLinkHoverBackColor) +
			'}';
end;

{------------------------------------------------------------------------------}

function TgtRPRenderHTML.GetOffsetFromTop: Integer;
begin
	// For SingleFile exports Offset =
	// 	(Paperheight + PageEnd Linewidth) * (PagesDone - 1)
	// For MultiFile exports
	// 	offset = 0
	Result := Round((PaperHeight * cPixelsPerInch) + cPageEndLineWidth) *
		(FCurrentPageNo - 1) * Ord(not SeparateFilePerPage);
end;

{------------------------------------------------------------------------------}

function TgtRPRenderHTML.GetRectDetails: string;
var
	S: string;
	I: Integer;
begin
	Result := '';
	S := 'border: ' + NumToStr(Converter.Pen.Width) + 'px solid ' +
			'#' + ColorBGRToRGB(Converter.Pen.Color);

	if not OptimizeForIE then
		Result := '; ' + S
	else
	begin
		I := FCSSClasses.Indexof(S);
		if I = -1 then
			Result := 'S' + NumToStr(FCSSClasses.Add(S))
		else
			Result := 'S' + NumToStr(I);

		Result := '" CLASS="' + Result;
	end;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderHTML.MakeHTMLImageFileName(AGraphic: TGraphic;
	AWidth, AHeight: Double; var AAltText: string): string;
var
	Bmp: TBitmap;
begin
	Bmp := TBitmap.Create;
	try
		Bmp.PixelFormat := ImagePixelFormat;
		if ImageDPI <> -1 then
		begin
			Bmp.Width := Round(AWidth / cPixelsPerInch * ImageDPI);
			Bmp.Height := Round(AHeight / cPixelsPerInch * ImageDPI);
			gtStretchDraw(AGraphic, Bmp);
		end
		else
		begin
			if (AGraphic.Width <= AWidth) and (AGraphic.Height <= AHeight) then
			begin
				Bmp.Width := AGraphic.Width;
				Bmp.Height := AGraphic.Height;
				Bmp.Canvas.Draw(0, 0, AGraphic);
			end
			else
			begin
				Bmp.Width := Round(AWidth);
				Bmp.Height := Round(AHeight);
				gtStretchDraw(AGraphic, Bmp);
			end;
		end;
		Result := FImageCreateDir + MakeImageFileName(
			ExtractFileName(FOutputFileName), sBMPExt, ImageFileCount + 1);

		if Assigned(OnMakeImageFileName) then
			OnMakeImageFileName(Self, Result, AAltText, Converter.PageNo);
		Result := SaveBitmapAs(Bmp, ExportImageFormat, JPEGQuality,
			ChangeFileExt(Result, ''));
		FImageFileNames.Add(Result);
	finally
		Bmp.Free;
	end;
end;

{------------------------------------------------------------------------------}

{ Calculate Navigator Height and Width. }
procedure TgtRPRenderHTML.CalculateNavigatorDimensions;
var
	APicture: TPicture;
	ASize: TSize;
begin
	if UseTextLinks then
	begin
		ASize := GetTextSize(LinkFont, LinkTextFirst + ' ');
		FNavigatorWidth := ASize.cx * 4;
		FNavigatorHeight := ASize.cy;
	end
	else
	begin
		APicture := TPicture.Create;
		try
			APicture.LoadFromFile(LinkImgSRCFirst);
			FNavigatorWidth := APicture.Graphic.Width * 6;
			FNavigatorHeight := APicture.Graphic.Height * 1.5;
		finally
			APicture.Free;
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.EncodeImage(const AFileName, AAltText: string;
	ATop, ALeft, AWidth, AHeight: Double);
var
	S: string;
begin
	S := '<DIV STYLE="' + FPositionAbsolute +
		'top: ' + NumToStr(ATop + GetOffsetFromTop) + 'px; ' +
		'left: ' + NumToStr(ALeft) + 'px; ' +
		'width: ' + NumToStr(AWidth) + 'px; ' +
		'height: ' + NumToStr(AHeight) + 'px' + ';">' +
		'<IMG SRC="' + AFileName + '" ALT="' + AAltText +
		'" Width=' + NumToStr(AWidth) + ' Height=' + NumToStr(AHeight) +
		'>' + '</DIV>' + CRLF;
	WriteToHTMLStream(S);
end;

{------------------------------------------------------------------------------}

{$IFDEF Rave407Up}

procedure TgtRPRenderHTML.EncodePolyLine(const PolyLineArr: array of
	{$IFDEF Rave50Up} TFloatPoint {$ELSE} TPoint {$ENDIF}; IsPolygon: Boolean);
var
	I: Integer;
	Bmp: TBitmap;
	APosX1, APosY1, APosX2, APosY2: Extended;
	A: array of TPoint;
	AFileName, AAltText: string;
begin
	SetLength(A, High(PolyLineArr) - Low(PolyLineArr) + 1);
	APosX1 := FCurrentX * FontDPI;
	APosY1 := FCurrentY * FontDPI;
	APosX2 := FCurrentX * FontDPI;
	APosY2 := FCurrentY * FontDPI;
	for I := Low(PolyLineArr) to  High(PolyLineArr) do
	begin
		if PolyLineArr[I].X < APosX1 then
			APosX1 := PolyLineArr[I].X
		else if PolyLineArr[I].X > APosX2 then
			APosX2 := PolyLineArr[I].X;
		if PolyLineArr[I].Y < APosY1 then
			APosY1 := PolyLineArr[I].Y
		else if PolyLineArr[I].Y > APosY2 then
			APosY2 := PolyLineArr[I].Y;
	end;
	for I := Low(PolyLineArr) to  High(PolyLineArr) do
	begin
		A[I].x := Round((PolyLineArr[I].x - APosX1) / FontDPI * cPixelsPerInch);
		A[I].y := Round((PolyLineArr[I].y - APosY1) / FontDPI * cPixelsPerInch);
	end;

	Bmp := TBitmap.Create;
	try
		Bmp.Width := Round((APosX2 - APosX1) / FontDPI * cPixelsPerInch);
		Bmp.Height := Round((APosY2 - APosY1) / FontDPI * cPixelsPerInch);
		Bmp.Canvas.Pen := Converter.Pen;
		Bmp.Canvas.Brush := Converter.Brush;
		if IsPolygon then
			Bmp.Canvas.Polygon(A)
		else
			Bmp.Canvas.Polyline(A);
		AFileName := MakeHTMLImageFileName(Bmp, Bmp.Width, Bmp.Height, AAltText);
		AFileName := FImageEncodeDir + ExtractFileName(AFileName);
		EncodeImage(AFileName, AAltText,  APosY1 / FontDPI * cPixelsPerInch,
			APosX1 / FontDPI * cPixelsPerInch, Bmp.Width, Bmp.Height);
	finally
		Bmp.Free;
	end;
end;

{$ENDIF}

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.EncodeText(ATextDetails: TgtRPTextDetails;
	IsClipping: Boolean);
var
	S, Align, AText, AAltText, AFileName: string;
	ATop, ALeft: Integer;
	AFont: TFont;
	Bmp: TBitmap;
begin
	with ATextDetails do
	begin
		case FTextAlign of
			tpAlignleft, tpAlignJustify:
				if OptimizeForIE then
					Align := ''
				else
					Align := '; text-align: left';
			tpAlignCenter:
				Align := '; text-align: center';
			tpAlignRight:
				Align := '; text-align: right';
		end;

		AText := FText;
		if FTextAlign = tpAlignJustify then
		begin
			AFont := TFont.Create;
			with AFont do
				try
					Name := FFont.Name;
					Charset := FFont.Charset;
					Pitch := FFont.Pitch;
					Size := FFont.Size;
					Color := FFont.Color;
					Style := FFont.Style;
					AText := JustifyText(AText, Round(FTextWidth), AFont);
				finally
					Free;
				end;
		end;

		if FFontRotation <> 0 then
		begin
			AAltText := '';
			ALeft := Round(FX);
			ATop := Round(FY);
			Bmp := GetRotatedTextBmp(AText, FFontRotation, ALeft, ATop, FTextWidth,
				FTextHeight, FTextAlign, FFont);
			AFileName := MakeHTMLImageFileName(Bmp, Bmp.Width, Bmp.Height, AAltText);
			AFileName := FImageEncodeDir + ExtractFileName(AFileName);
			EncodeImage(AFileName, AAltText, ATop, ALeft, Bmp.Width, Bmp.Height);
			Bmp.Free;
		end
		else
		begin
			AText := GetNativeText(AText);
			S := '<DIV STYLE="' + FPositionAbsolute +
				'top: ' + NumToStr(FY + GetOffsetFromTop - FTextHeight) + 'px; ' +
				'left: ' + NumToStr(FX) + 'px; ' +
				// Remove braces to ensure proper printing
			{	'width:' + NumToStr(FTextWidth * 2.5) + 'px' +
				// ^^^ setting text width prevents text, containing hyphens (-),
				// from breaking to the next line.
				// "* 2.5" compensation for (browser) printing error. It does not
				// alter on-screen rendering
		//}	'width: ' + NumToStr(FTextWidth + 2) + 'px' +
				Align;
			if IsClipping then
				S := S + '; clip: rect(0 ' + NumToStr(FTextWidth + 2) + ' ' +
					NumToStr(FTextHeight + 1) + ' 0)';
			S := S + GetFontInfo(FFont) + '">' + AText + '</DIV>' + CRLF;
			WriteToHTMLStream(S);
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.EncodeRect(ATop, ALeft, AWidth, AHeight: Double);
var
	APosX, APosY, RectWidth, RectHeight: Double;
	S: string;
begin
	APosX := ALeft;
	APosY := ATop;
	RectWidth := AWidth;
	RectHeight := AHeight;
	if RectWidth < 0 then
	begin
		RectWidth := Abs(RectWidth);
		APosX := APosX - RectWidth;
	end;
	if RectHeight < 0 then
	begin
		RectHeight := Abs(RectHeight);
		APosY := APosY - RectHeight;
	end;
	S := '<DIV STYLE="' + FPositionAbsolute +
		'font: 0pt; top: ' + NumToStr(APosY + GetOffsetFromTop - 1) + 'px; ' +
		'left: ' + NumToStr(APosX) + 'px; ' +
		'width: ' + NumToStr(RectWidth + 1) + 'px; ' +
		'height: ' + NumToStr(RectHeight) + 'px; ';
	if Converter.Brush.Style <> bsClear then
		S := S + 'background-color: #' +
			ColorBGRToRGB(Converter.Brush.Color);
	if Converter.Pen.Style <> psClear then
		S := S + GetRectDetails;
	S := S + '"></DIV>' + CRLF;
	WriteToHTMLStream(S);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.WriteHeader;

	function GetISOCharSet(WinCP: Integer): string;
	var
		K: Integer;
	begin
		Result := '';
		for K := Low(ANSICodePageIDs) to High(ANSICodePageIDs) do
			if ANSICodePageIDs[K].WinCode = WinCP then
			begin
				Result := ANSICodePageIDs[K].ISOCode;
				Break;
			end;
	end;

var
	S: string;
begin
	S := 
		'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 transitional//EN">' + CRLF +
		'<HTML> <HEAD>' + CRLF + '<TITLE>';
	if Title = '' then
		S := S + Converter.Title
	else
		S := S + GetNativeText(Title);
	S := S + '</TITLE>' + CRLF +
		'<META HTTP-EQUIV="Content-Style-Type" CONTENT="text/css" CHARSET="' +
		{ Get active chatacter code page and encode so that non English characters
			such as Eastern European & Asian characters show up properly }
		GetISOCharSet(GetACP) + '">' + CRLF +
		'<META NAME="Subject" CONTENT="' + Subject + '">' + CRLF +
		'<META NAME="Keywords" CONTENT="' + Keywords + '">' + CRLF +
		'<META NAME="Author" CONTENT="' + Author + '">' + CRLF +
		'<META NAME="Creator" CONTENT="' + Creator + '">' + CRLF +
		'<META NAME="Producer" CONTENT="Gnostice RaveRender V' + cVersion +
		' for Rave Reports (www.gnostice.com)">';

	// Encode style sheet location.
	if OptimizeForIE and OutputStylesToCSSFile then
		S := S + CRLF + '<LINK rel="stylesheet" href="' + FCSSFileEncodeName +
			'" type="text/css">'
	else
	begin
		S := S + CRLF + '<STYLE>' + CRLF + '<!--';
		// Encode navigator anchor style if not single file and show navigator on.
		if SeparateFilePerPage and ShowNavigator then
			S := S + CRLF + GetNavigatorStyle;
		S := S + CRLF + GetBackground;
		// Encode default style - positioning & report font properties.
		if OptimizeForIE then
		begin
			S := S + CRLF + 'DIV {position:absolute; font:' +
				GetFontCSS(FDefaultFontAttrib) + '}';
			S := S + ConstructStyleStrings;
		end;
		S := S + 'SPAN {position: absolute; visibility: hidden}';
		S := S + CRLF +	'-->' + CRLF + '</STYLE>';
	end;

	// Encode Java Script for Floating Navigator.
	if (NavigatorType = ntFixedToScreen) and SeparateFilePerPage and
		ShowNavigator and (FTotalPages <> 1) then
	begin
		S := S + CRLF + '<SCRIPT LANGUAGE="JavaScript">' + CRLF + '<!--' + CRLF +
			GetJavaScripts + CRLF + '-->';
		S := S + CRLF + '</SCRIPT>';
	end;

	S := S + CRLF + '</HEAD>' + CRLF + '<BODY BGCOLOR = "#FFFFFF"';
	if (NavigatorType = ntFixedToScreen) and SeparateFilePerPage and
			ShowNavigator and (FTotalPages <> 1) then
		S := S + ' onLoad="initNavigator()"';

	S := S + '>' + CRLF;
	WriteToOwnedStream(S);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.WriteFooter;
var
	S: string;
	ANavLeft, ANavTop: Extended;

	function GetNavHTML: string;
	const
		ATextFormat = '<A %sTITLE="%s">%s</A>';
		AImageFormat = '<A %sTITLE="%s"><IMG SRC="%s" ALT="%s"></A>';
	var
		FirstPage, LastPage: Boolean;
		FirstLnk, PrevLnk, NextLnk, LastLnk: string;
	begin
		// Navigator Links
		FirstLnk := '';
		PrevLnk := '';
		NextLnk := '';
		LastLnk := '';
		Result := '';
		FirstPage := (FCurrentPageNo = 1);
		LastPage := (FCurrentPageNo = FTotalPages);
		if not FirstPage then
		begin
			FirstLnk := 'HREF="' +
				ExtractFileName(ReportFileNames[0]) + '" ';
			PrevLnk := 'HREF="' +
				ExtractFileName(ReportFileNames[FCurrentPageNo - 2]) + '" ';
		end;
		if not LastPage then
		begin
			LastLnk := 'HREF="' +
				ExtractFileName(ReportFileNames[FTotalpages - 1]) + '" ';
			NextLnk := 'HREF="' +
				ExtractFileName(ReportFileNames[FCurrentPageNo]) + '" ';
		end;

		if FUseTextLinks then
			Result :=
				Format(ATextFormat,
					[FirstLnk, sTitleTextFirst, FLinkTextFirst]) + '&nbsp;' +
				Format(ATextFormat,
					[PrevLnk, sTitleTextPrev, FLinkTextPrev]) + '&nbsp;' +
				Format(ATextFormat,
					[NextLnk, sTitleTextNext, FLinkTextNext]) + '&nbsp;' +
				Format(ATextFormat,
					[LastLnk, sTitleTextLast, FLinkTextLast])
		else
			Result :=
				Format(AImageFormat,
					[FirstLnk, sTitleTextFirst, FLinkImgSRCFirst, sTitleTextFirst]) +
					'&nbsp;' +
				Format(AImageFormat,
					[PrevLnk, sTitleTextPrev, FLinkImgSRCPrev, sTitleTextPrev]) +
					'&nbsp;' +
				Format(AImageFormat,
					[NextLnk, sTitleTextNext, FLinkImgSRCNext, sTitleTextNext]) +
					'&nbsp;' +
				Format(AImageFormat,
					[LastLnk, sTitleTextLast, FLinkImgSRCLast, sTitleTextLast]);
	end;
begin
	S := '';
	// If single-file export, draw page-end line.
	if (not SeparateFilePerPage) and (PageEndLines) then
	begin
		S := '<DIV STYLE="' + FPositionAbsolute +
			'top: ' + NumToStr(FCurrentPageNo * PaperHeight * cPixelsPerInch) +
			'px">' +
			'<HR SIZE= ' + NumToStr(cPageEndLineWidth) + ' ' +
			'WIDTH= ' + NumToStr((PaperWidth * cPixelsPerInch) - 10) + ' ' +
			'NOSHADE></DIV>' + CRLF;
		WriteToOwnedStream(S);
	end
	else if SeparateFilePerPage and ShowNavigator and (FTotalPages > 1) then
	begin
		if (NavigatorType = ntFixedToScreen) then
		begin
			S := '<SPAN ID="gtNavigator">' + CRLF +
				'<DIV STYLE="' + FPositionAbsolute +
				'font: ' + NumToStr(LinkFont.Size) + 'pt ' + LinkFont.Name +
				'; color: #' + ColorBGRToRGB(LinkFont.Color) + '">' +
				GetNavHTML + '</DIV>' + CRLF + '</SPAN>';
		end
		else
		begin
			ANavLeft := PaperWidth * cPixelsPerInch - FNavigatorWidth;
			ANavTop := PaperHeight * cPixelsPerInch - FNavigatorHeight;

			// Display navigator buttons.
			S := '<DIV STYLE="' + FPositionAbsolute +
				'top: ' + NumToStr(ANavTop) + 'px; ' +
				'left: ' + NumToStr(ANavLeft) + 'px; ' +
				'font: ' + NumToStr(LinkFont.Size) + 'pt ' + LinkFont.Name +
				'; color: #' + ColorBGRToRGB(LinkFont.Color) + '">' +
				GetNavHTML + '</DIV>' + CRLF;
		end;
		WriteToOwnedStream(S);
	end;

	// Append closing HTMLText.
	if (SeparateFilePerPage or (FCurrentPageNo = {$IFNDEF Registered} cMaxPages
		{$ELSE} FTotalPages {$ENDIF})) then
	begin
		S := '</BODY>' + CRLF + '</HTML>' + CRLF;
		WriteToOwnedStream(S);
	end;

(*	// If single-file export, draw page-end line
	if (not SeparateFilePerPage) and (PageEndLines) then
	begin
		S := '<DIV STYLE="' + FPositionAbsolute +
			'top: ' + NumToStr(FCurrentPageNo * PaperHeight * cPixelsPerInch) +
			'px">' +
			'<HR SIZE= ' + NumToStr(cPageEndLineWidth) + ' ' +
			'WIDTH= ' + NumToStr((PaperWidth * cPixelsPerInch) - 10) + ' ' +
			'NOSHADE></DIV>' + CRLF;
		WriteToOwnedStream(S);
	end
	else if SeparateFilePerPage and ShowNavigator and (FTotalPages > 1) then
	begin
		// Display navigator buttons
		S := '<DIV STYLE="' + FPositionAbsolute +
			'top: ' + NumToStr(PaperHeight * cPixelsPerInch) + 'px; ' +
			'left: 0px; ' +
			'font: ' + NumToStr(FLinkFont.Size) + 'pt ' + FLinkFont.Name +
			'; color: #' + ColorBGRToRGB(FLinkFont.Color) + '">' +
			GetNavHTML + '</DIV>' + CRLF;
		WriteToOwnedStream(S);
	end;

	// Append closing HTMLText
	if (SeparateFilePerPage or (FCurrentPageNo = {$IFNDEF Registered} cMaxPages
		{$ELSE} FTotalPages {$ENDIF})) then
	begin
		S := '</BODY>' + CRLF + '</HTML>' + CRLF;
		WriteToOwnedStream(S);
	end;*)
end;

{------------------------------------------------------------------------------}

procedure	TgtRPRenderHTML.WriteToHTMLStream(const AText: string);
begin
	// Write data to HTML stream
	FHTMLStream.Write(Pointer(AText)^, Length(AText));
end;

{------------------------------------------------------------------------------}

function TgtRPRenderHTML.GetNativeText(const Text: string): string;
begin
// Spaces to '&nbsp;'
	if Copy(Text, 1, Length(cHTMLNoTranslateText)) = cHTMLNoTranslateText then
		Result := Copy(Text, Length(cHTMLNoTranslateText) + 1, MaxInt)
	else
		Result := ReplaceString(Text, ' ', '&nbsp;');
end;

{------------------------------------------------------------------------------}

function TgtRPRenderHTML.ShowSetupModal: Word;
begin
	with TgtRPRenderHTMLDlg.Create(nil) do
	try
		RenderObject := Self;
		Application.ProcessMessages;
		Result := ShowModal;
	finally
		Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.Arc(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3,
	pfX4, pfY4: Double);
var
	Bmp: TBitmap;
	AFileName, AAltText: string;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeNonRectShapes then
	begin
		Bmp := GetArcBitmap(pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4, pfY4);
		try
			AFileName := MakeHTMLImageFileName(Bmp, Bmp.Width, Bmp.Height, AAltText);
			AFileName := FImageEncodeDir + ExtractFileName(AFileName);
			EncodeImage(AFileName, AAltText, Min(pfY1, pfY2) * cPixelsPerInch,
				Min(pfX1, pfX2) * cPixelsPerInch, Bmp.Width, Bmp.Height);
		finally
			Bmp.Free;
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.Chord(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3,
	pfX4, pfY4: Double);
var
	Bmp: TBitmap;
	AFileName, AAltText: string;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeNonRectShapes then
	begin
		Bmp := GetChordBitmap(pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4, pfY4);
		try
			AFileName := MakeHTMLImageFileName(Bmp, Bmp.Width, Bmp.Height, AAltText);
			AFileName := FImageEncodeDir + ExtractFileName(AFileName);
			EncodeImage(AFileName, AAltText, Min(pfY1, pfY2) * cPixelsPerInch,
				Min(pfX1, pfX2) * cPixelsPerInch, Bmp.Width, Bmp.Height);
		finally
			Bmp.Free;
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.CreateEMailInfoObj;
var
	I: Integer;
begin
//	Create EmailInfo object.
//	Add all report files, image files and CSS file as Attachments.

	inherited CreateEMailInfoObj; 
	with FEMailInfo do
	begin
		for I := 0 to FImageFileNames.Count - 1 do
			Attachments.Add(FImageFileNames.Strings[I]);
		if OptimizeForIE and OutputStylesToCSSFile then
			Attachments.Add(FCSSFileCreateName);
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.DocBegin;
var
	I: Integer;
	AFileName: string;
begin
	if FExportCanceled then Exit;
	inherited DocBegin;

	FPositionAbsolute := '';
	if OptimizeForIE then
		FCSSClasses := TStringList.Create
	else
		FPositionAbsolute := 'position:absolute; ';

	FCurrentPageNo := 0;
	if SeparateFilePerPage and (FTotalPages <> 1) then
		for I := 2 to  (Converter.PageCount) do
			if IsPageInRange(I) then
			begin
				Inc(FCurrentPageNo);
				AFileName := ExtractFilePath(FOutputFileName) +
					MakeFileName(FOutputFileName, GetFileExtension, FCurrentPageNo + 1);
				if Assigned(OnMakeReportFileName) then
					OnMakeReportFileName(Self, AFileName, I);
				ReportFileNames.Add(AFileName);
			end;
	FCurrentPageNo := 0;

	// Resolve absolute Image and CSS path names
	if OptimizeForIE and OutputStylesToCSSFile then
	begin
		FCSSFileEncodeName := Trim(FCSSFileName);
		if FCSSFileEncodeName = '' then
			FCSSFileEncodeName := ExtractFileName(FOutputFileName);
		FCSSFileEncodeName := ChangeFileExt(FCSSFileEncodeName, '.css');
		FCSSFileCreateName := GetAbsoluteDir(FCSSFileEncodeName,
			ExtractFilePath(FOutputFileName));
		FCSSFileCreateName := FCSSFileCreateName +
			ExtractFileName(FCSSFileEncodeName);
	end;
	// Image Encode Directory and Image Create Directory
	FImageEncodeDir := Trim(FImageFolder);
	if FImageEncodeDir <> '' then
		FImageEncodeDir := AppendTrailingBackslash(FImageEncodeDir);
	FImageCreateDir := GetAbsoluteDir(FImageEncodeDir,
		ExtractFilePath(FOutputFilename));
	FImageEncodeDir := ReplaceString(FImageEncodeDir, '\', '/');

	CalculateNavigatorDimensions;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.DocEnd;
var
	CSSStyles: string;
begin
	if FExportCanceled then
	begin
		inherited DocEnd;
		Exit;
	end;

	if OptimizeForIE then
	begin
		if OutputStylesToCSSFile then
		begin
			CSSStyles := '';
			if SeparateFilePerPage and ShowNavigator then
				CSSStyles := GetNavigatorStyle;
			// Encode Background
			CSSStyles := CSSStyles + CRLF + GetBackground;
			// Encode DIV Styles
			CSSStyles := CSSStyles + CRLF +
				'  DIV {position:absolute; font: ' + GetFontCSS(FDefaultFontAttrib) +
				'; text-align: left' + '}';
			// Encode CSS classes
			CSSStyles := CSSStyles + ConstructStyleStrings;
			CSSStyles := CSSStyles + CRLF +
				'SPAN {position: absolute; visibility: hidden}';
			try
				with TFileStream.Create(FCSSFileCreateName, fmCreate) do
					try
						Write(CSSStyles[1], Length(CSSStyles));
					finally
						Free;
					end;
			except
				DoErrorMessage(sCreateCSSFileError);
			end;
		end;
		FCSSClasses.Free;
	end;
	inherited DocEnd;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.Draw(const pfX1, pfY1: Double; AGraphic: TGraphic);
var
	AFileName, AAltText: string;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeImages then
	begin
		AFileName := MakeHTMLImageFileName(AGraphic, AGraphic.Width,
			AGraphic.Height, AAltText);
		AFileName := FImageEncodeDir + ExtractFileName(AFileName);
		EncodeImage(AFileName, AAltText, pfY1 * cPixelsPerInch,
			pfX1 * cPixelsPerInch, AGraphic.Width, AGraphic.Height);
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.Ellipse(const pfX1, pfY1, pfX2, pfY2: Double);
var
	Bmp: TBitmap;
	AFileName, AAltText: string;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeNonRectShapes then
	begin
		Bmp := GetEllipseBitmap(pfX1, pfY1, pfX2, pfY2);
		try
			AFileName := MakeHTMLImageFileName(Bmp, Bmp.Width, Bmp.Height, AAltText);
			AFileName := FImageEncodeDir + ExtractFileName(AFileName);
			EncodeImage(AFileName, AAltText, Min(pfY1, pfY2) * cPixelsPerInch,
				Min(pfX1, pfX2) * cPixelsPerInch, Bmp.Width, Bmp.Height);
		finally
			Bmp.Free;
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.EndText;
var
	ATextDetails: TgtRPTextDetails;
	I: Integer;
begin
	for I := 0 to FTextList.Count - 1 do
	begin
		ATextDetails := TgtRPTextDetails(FTextList.Items[I]);
		EncodeText(ATextDetails, False);
	end;
	ClearTextList;
	FProcessingText := False;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.FillRect(const pRect: TRect);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeLines then
		EncodeRect(pRect.Top / 72 * cPixelsPerInch,
			pRect.Left / 72 * cPixelsPerInch,
			(pRect.Right - pRect.Left) / 72 * cPixelsPerInch,
			(pRect.Bottom - pRect.Top) / 72 * cPixelsPerInch);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.LineTo(const pfX1, pfY1: Double);
var
	S: string;
	Attrib, AAltText, AFileName: string;
	ATop, ALeft, AWidth, AHeight: Double;
	Bmp: TBitmap;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeLines then
		// Vertical line or Horizontal line
		if (FCurrentX = pfX1) or (FCurrentY = pfY1) then
		begin
			ALeft := Min(FCurrentX, pfX1) * cPixelsPerInch;
			ATop := Min(FCurrentY, pfY1) * cPixelsPerInch;
			AWidth := Abs(pfX1 - FCurrentX) * cPixelsPerInch;
			AHeight := Abs(pfY1 - FCurrentY) * cPixelsPerInch;
			if AWidth = 0 then
			begin
				Attrib := NumToStr(Abs(AHeight));
				AWidth := Converter.Pen.Width;
				S := '; border-top: '; // Horizontal line
			end
			else
			begin
				Attrib := NumToStr(Abs(AWidth));
				AHeight := Converter.Pen.Width;
				S := '; border-left: '; // Vertical line
			end;
			ATop := ATop + GetOffsetFromTop - 1;
			Attrib := Attrib + 'px solid ' + 
				'#' + ColorBGRToRGB(Converter.Pen.Color);

			S := '<DIV STYLE="font: 0pt; ' + FPositionAbsolute +
				'top: ' + NumToStr(ATop) + 'px; ' +
				'left: ' + NumToStr(ALeft) + 'px; ' +
				'width: ' + NumToStr(AWidth) + 'px; ' +
				'height: ' + NumToStr(AHeight) + 'px' + S + Attrib;

			S := S + '"></DIV>' + CRLF;
			WriteToHTMLStream(S);
		end
		else // Inclined Lines are encoded as images
		begin
			Bmp := GetLineBitmap(FCurrentX, FCurrentY, pfX1, pfY1);
			try
				AFileName := MakeHTMLImageFileName(Bmp, Bmp.Width,
					Bmp.Height, AAltText);
				AFileName := FImageEncodeDir + ExtractFileName(AFileName);
				EncodeImage(AFileName, AAltText,
					Min(FCurrentY, pfY1) * cPixelsPerInch,
					Min(pfX1, FCurrentX) * cPixelsPerInch, Bmp.Width, Bmp.Height);
			finally
				Bmp.Free;
			end;
		end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.PageBegin;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	inherited PageBegin;
	if 	FCurrentPageNo = 1 then
		FHTMLStream := TMemoryStream.Create
	else if SeparateFilePerPage then
		FHTMLStream := TMemoryStream.Create;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.PageEnd;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if (FCurrentPageNo = 1) then
		WriteHeader
	else if SeparateFilePerPage then
	begin
		try
			FOwnedStream := TFileStream.Create(ReportFileNames[FCurrentPageNo - 1],
				fmCreate);
		except
			CancelExport;
			DoErrorMessage(sCreateFileError);
			Exit;
		end;
		WriteHeader;
	end;

	FOwnedStream.CopyFrom(FHTMLStream, 0);
	WriteFooter;
	TMemoryStream(FHTMLStream).Clear;
	if (FCurrentPageNo =
		{$IFNDEF Registered} cMaxPages {$ELSE} FTotalPages {$ENDIF})
		or SeparateFilePerPage then
	begin
		FHTMLStream.Free;
		FOwnedStream.Free;
		FOwnedStream := nil;
	end;
	inherited PageEnd;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.Pie(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3,
	pfX4, pfY4: Double);
var
	Bmp: TBitmap;
	AFileName, AAltText: string;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeNonRectShapes then
	begin
		Bmp := GetPieBitmap(pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4, pfY4);
		try
			AFileName := MakeHTMLImageFileName(Bmp, Bmp.Width, Bmp.Height, AAltText);
			AFileName := FImageEncodeDir + ExtractFileName(AFileName);
			EncodeImage(AFileName, AAltText, Min(pfY1, pfY2) * cPixelsPerInch,
				Min(pfX1, pfX2) * cPixelsPerInch, Bmp.Width, Bmp.Height);
		finally
			Bmp.Free;
		end;
	end;
end;

{------------------------------------------------------------------------------}

{$IFDEF Rave407Up}

procedure TgtRPRenderHTML.PolyLine(const PolyLineArr: array of {$IFDEF Rave50Up}
	TFloatPoint {$ELSE} TPoint {$ENDIF});
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeLines then
		EncodePolyLine(PolyLineArr, False);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.Polygon(const PolyLineArr: array of {$IFDEF Rave50Up}
	TFloatPoint {$ELSE} TPoint {$ENDIF});
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeLines then
		EncodePolyLine(PolyLineArr, True);
end;

{$ENDIF}

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.PrintBitmap(const X1, Y1, ScaleX, ScaleY: Double;
	AGraphic: Graphics.TBitmap);
var
	AFileName, AAltText: string;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeImages then
	begin
		AFileName := MakeHTMLImageFileName(AGraphic, AGraphic.Width * ScaleX,
			AGraphic.Height * ScaleY, AAltText);
		AFileName := FImageEncodeDir + ExtractFileName(AFileName);
		EncodeImage(AFileName, AAltText, Y1 * cPixelsPerInch, X1 * cPixelsPerInch,
			AGraphic.Width * ScaleX, AGraphic.Height * ScaleY);
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.PrintBitmapRect(const X1, Y1, X2, Y2: Double;
	AGraphic: Graphics.TBitmap);
var
	AFileName, AAltText: string;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeImages then
	begin
		AFileName := MakeHTMLImageFileName(AGraphic, Abs(X2 - X1) * cPixelsPerInch,
			Abs(Y2 - Y1) * cPixelsPerInch, AAltText);
		AFileName := FImageEncodeDir + ExtractFileName(AFileName);
		EncodeImage(AFileName, AAltText, Y1 * cPixelsPerInch,
			X1 * cPixelsPerInch, Abs(X2 - X1) * cPixelsPerInch,
			Abs(Y2 - Y1) * cPixelsPerInch);
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.Rectangle(const pfX1, pfY1, pfX2, pfY2: Double);
	function GetRectangleBitmap(X1, Y1, X2, Y2: Extended): TBitmap;
	begin
		Result := TBitmap.Create;
		with Result do
		begin
			Canvas.Pen.Assign(Converter.Pen);
			Width := Round(Abs(X2 - X1) * cPixelsPerInch);
			Height := Round(Abs(Y2 - Y1) * cPixelsPerInch);
			Canvas.Brush.Assign(Converter.Brush);
			Canvas.Rectangle(0, 0, Width, Height);
		end;
	end;

var
	Bmp: TBitmap;
	AFileName, AAltText: string;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeLines then
	begin
		if Converter.Brush.Style in [bsClear, bsSolid] then
			EncodeRect(pfY1 * cPixelsPerInch, pfX1 * cPixelsPerInch,
				(pfX2 - pfX1) * cPixelsPerInch, (pfY2 - pfY1) * cPixelsPerInch)
		else
		begin
			Bmp := GetRectangleBitmap(pfX1, pfY1, pfX2, pfY2);
			try
				AFileName := MakeHTMLImageFileName(Bmp, Bmp.Width,
					Bmp.Height, AAltText);
				AFileName := FImageEncodeDir + ExtractFileName(AFileName);
				EncodeImage(AFileName, AAltText, pfY1 * cPixelsPerInch,
					pfX1 * cPixelsPerInch, Bmp.Width, Bmp.Height);
			finally
				Bmp.Free;
			end;
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.RoundRect(const pfX1, pfY1, pfX2, pfY2,
	pfX3, pfY3: Double);
var
	Bmp: TBitmap;
	AFileName, AAltText: string;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeLines then
	begin
		Bmp := GetRoundRectBitmap(pfX1, pfY1, pfX2, pfY2, pfX3, pfY3);
		try
			AFileName := MakeHTMLImageFileName(Bmp, Bmp.Width, Bmp.Height, AAltText);
			AFileName := FImageEncodeDir + ExtractFileName(AFileName);
			EncodeImage(AFileName, AAltText, pfY1 * cPixelsPerInch,
				pfX1 * cPixelsPerInch, Bmp.Width, Bmp.Height);
		finally
			Bmp.Free;
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.StretchDraw(const pRect: TRect; AGraphic: TGraphic);
var
	AFileName, AAltText: string;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeImages then
	begin
		AFileName := MakeHTMLImageFileName(AGraphic,
			Abs(pRect.Left - pRect.Right) / 72 * cPixelsPerInch,
			Abs(pRect.Top - pRect.Bottom) / 72 * cPixelsPerInch, AAltText);
		AFileName := FImageEncodeDir + ExtractFileName(AFileName);
		EncodeImage(AFileName, AAltText, pRect.Top / 72 * cPixelsPerInch,
			pRect.Left / 72 * cPixelsPerInch,
			Abs(pRect.Left - pRect.Right) / 72 * cPixelsPerInch,
			Abs(pRect.Top - pRect.Bottom) / 72 * cPixelsPerInch);
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.TextRect(Rect: TRect; X1,Y1: double; S1: string);
var
	ATextDetails: TgtRPTextDetails;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	with Rect do
		if Converter.Pen.Style <> psClear then
			EncodeRect(Top / 72 * cPixelsPerInch, Left / 72 * cPixelsPerInch,
				(Right - Left) / 72 * cPixelsPerInch,
				(Bottom - Top) / 72 * cPixelsPerInch);

	ATextDetails := TgtRPTextDetails.Create;
	with ATextDetails do
		try
			FText := S1;
			SetFontDetails(ATextDetails);
			FTextAlign := tpAlignLeft;
			FTextWidth := (Rect.Right - Rect.Left) / 72 * cPixelsPerInch;
  {$IFDEF Rave50Up}
      FTextHeight := Converter.FontData.Height * cPixelsPerInch;
  {$ELSE}
      FTextHeight := Converter.FontHeight * cPixelsPerInch;
  {$ENDIF}
			FX := X1 * cPixelsPerInch;
			FY := Y1 * cPixelsPerInch;
			EncodeText(ATextDetails, True);
		finally
			Free;
		end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTML.CancelExport;
var
	I: Integer;
begin
	inherited CancelExport;
	for I := 0 to ImageFileCount - 1 do
		CheckAndDeleteFile(ImageFileNames.Strings[I]);
	if OutputStylesToCSSFile then
		CheckAndDeleteFile(FCSSFileCreateName);
end;

{------------------------------------------------------------------------------}

{$IFDEF Rave50Up}

procedure TgtRPRenderHTML.RenderPage(PageNum: integer);
begin
	inherited Renderpage(PageNum);
	FImageFileNames.Clear;
	if not FExportCanceled then
	begin
		try
			InitFileStream(ReportFileNames.Strings[0]);
		except
			CancelExport;
			DoErrorMessage(sCreateFileError);
			Exit;
		end;
		with TRPConverter.Create(NDRStream, Self) do
		try
			Generate;
		finally
			Free;
		end;
	end;
end;

{$ELSE}

procedure TgtRPRenderHTML.PrintRender(NDRStream: TStream;
	OutputFileName: TFileName);
begin
	inherited PrintRender(NDRStream, OutputFileName);

	FImageFileNames.Clear;
	if not FExportCanceled then
	begin
		try
			InitFileStream(ReportFileNames.Strings[0]);
		except
			CancelExport;
			DoErrorMessage(sCreateFileError);
			Exit;
		end;
		with TRPConverter.Create(NDRStream, Self) do
		try
			Generate;
		finally
			Free;
		end;
	end;
end;

{$ENDIF}

{------------------------------------------------------------------------------}

end.



