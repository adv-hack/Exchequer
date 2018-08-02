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

unit gtRPRender_PDF;

interface

uses
	SysUtils, Windows, Messages, Classes, Forms, Dialogs, StdCtrls, Controls,
	RPRender, gtRPRender_Main, gtRPRender_Document, gtRPRender_Consts,
	gtRPRender_Utils,
	{$IFDEF ZLib}
		ZLib,
	{$ENDIF} Graphics;

type

	// Line Type: Underline or Strikeout 
	TgtLineType = (ltUnderline, ltStrikeOut);

	// Encoding Types
	TPDFFontEncoding = (feWinAnsiEncoding, feMacRomanEncoding,
		feMacExpertEncoding, feStandardEncoding, fePDFDocEncoding);

	// Compression Methods
	TPDFCompressionMethod = (cmFastest, cmNormal, cmMaxCompress);

	// Ellipse Control Points
	TgtRPEllipseCtrlPoints = record
		X1, X2, X3, X4, X5,
		Y1, Y2, Y3, Y4, Y5: Double;
	end;

{ TgtRPFontInfo class }

	// Holds font metrics while exporting to PDF
	TgtRPFontInfo = class(TObject)
	private
		fiFontObjRef: Integer;
		fiWidths: array[32..255] of Integer;
		fiFontDescriptorObjRef: Integer;
		fiFlags: Integer;
		fiFontBBox: TRect;
		fiAscent: Integer;
		fiDescent: Integer;
		fiCapHeight: Integer;
		fiAvgWidth: Integer;
		fiMaxWidth: Integer;
		fiStemV: Integer;
		fiItalicAngle: Integer;
		fiLeading: Integer;
		fiStrikeoutSize: Integer;
		fiStrikeoutPosition: Integer;
		fiUnderscoreSize: Integer;
		fiUnderscorePosition: Integer;
	end;

{ TgtRPRenderPDF class }

	TgtRPRenderPDF = class(TgtRPRenderDocument)
	private
		FCompressionMethod: TPDFCompressionMethod;
		FEncoding: TPDFFontEncoding;
		FUseCompression: Boolean;
		{ Used in directing output to user supplied stream }
		FOutputToUserStream: Boolean;
		FUserStream: TMemoryStream;

		FFontTable: TStrings;
		FImageStream: TStream;
		FPDFStream: TStream;
		FImageCtlList: TStrings;
		FImageXRefList: TStrings;
		FObjRunNo: Integer;
		FPageObjNo: Integer;
		FContentsObjNo: Integer;
		FLengthObjNo: Integer;
		FBackgroundImageObjNo: Integer;
		FBackgroundImageWidth: Extended;
		FBackgroundImageHeight: Extended;
		FBackgroundImageLeft: Extended;
		FBackgroundImageTop: Extended;
		FPageObjs: string;
		FXRefTable: TStrings;

		procedure SetExportImageFormat(Value: TgtRPImageFormat);

		function ColorToPDFColor(AColor: TColor): string;
		function CompletePath(APen: TPen; ABrush: TBrush): string;
		function CompressStream(InputStream, OutputStream: TStream): Integer;
		function DoFill(ABrush: TBrush): Boolean;
		function DoStroke(APen: TPen): Boolean;
		function EncodeArc(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Double;
			ClosePath: Boolean): string;
		function EncodeRect(PosX, PosY, Width, Height: Double): string;
    {$IFDEF Rave407Up}
  		function EncodePolyLine(const PolyLineArr: array of
      {$IFDEF Rave50Up} TFloatPoint {$ELSE} TPoint {$ENDIF}): string;
    {$ENDIF}
		function GetEllipseCtrlPts(
			PosX1, PosY1, PosX2, PosY2: Double): TgtRPEllipseCtrlPoints;
		function GetFillStyles(ABrush: TBrush;
			ALeft, ATop, ARight, ABottom: Extended): string;
		function GetFontInfoObj(AFont: TgtRPFontAttrib): TgtRPFontInfo;
		function GetLineStyle(AStyle: TPenStyle): string;
		function GetNativeXPos(X: Extended): Extended;
		function GetNativeYPos(Y: Extended): Extended;
		function GetNewObjNo: Integer;
		function MakeObjHead(ObjNo: Integer): string;
		function MakeObjRef(ObjNo: Integer): string;
		function PDFCurveto(X1, Y1, X2, Y2, X3, Y3: Double): string;
		function PDFShortArc(X, Y, R: Double; Alpha, Beta: Double): string;
		function SaveImageContents(ABitmap: TBitmap): Integer;

		procedure AppendXRef(APos, ObjNo: Integer);
		procedure EncodeImage(AGraphic: TGraphic;
			PosX, PosY, Width, Height: Double);
		procedure EncodeText(ATextDetails: TgtRPTextDetails);
		procedure InitPDFFontInfoObj(AFont: TFont; AFontInfoObj: TgtRPFontInfo);
		procedure FillFontMetrics(AFont: TgtRPFontAttrib;
			AFontInfoObj: TgtRPFontInfo);
		procedure WriteBackground;
		procedure WriteObj(const S: string; ObjNo: Integer;
			IsObjectComplete: Boolean);
		procedure WriteToImageStream(const AText: string);
		procedure	WriteToPDFStream(const AText: string);

	protected
		function GetNativeText(const Text: string): string; override;
		function NumToStr(N: Extended): string; override;
		function ShowSetupModal: Word; override;

		procedure Arc(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3,
			pfX4, pfY4: Double); override;
		procedure Chord(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3,
			pfX4, pfY4: Double); override;
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
  		procedure PolyLine(const PolyLineArr: array of
        {$IFDEF Rave50Up} TFloatPoint {$ELSE} TPoint {$ENDIF}); override;
	  	procedure Polygon(const PolyLineArr: array of
        {$IFDEF Rave50Up} TFloatPoint {$ELSE} TPoint {$ENDIF}); override;
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

  {$IFDEF Rave50Up}
    procedure RenderPage(PageNum: integer); override;
  {$ELSE}
		procedure PrintRender(NDRStream: TStream;
			OutputFileName: TFileName); override;
  {$ENDIF}

		property OutputToUserStream: Boolean read FOutputToUserStream write
			FOutputToUserStream;
		property UserStream: TMemoryStream read FUserStream write FUserStream;

	published
		property Author;
		property BackgroundColor;
		property BackgroundImage;
		property BackgroundImageDisplayType;
		property CompressionMethod: TPDFCompressionMethod read FCompressionMethod
			write FCompressionMethod default cmMaxCompress;
		property Creator;
		property Encoding: TPDFFontEncoding read FEncoding write FEncoding
			default feWinAnsiEncoding;
		property ExportImageFormat write SetExportImageFormat default ifBMP;
		property ImageDPI;
		property ImagePixelFormat;
		property IncludeLines;
		property IncludeNonRectShapes;
		property IncludeImages;
		property JPEGQuality;
		property Keywords;
		property Subject;
		property Title;
		property UseCompression: Boolean read FUseCompression
			write FUseCompression default True;
			
	end;

const

	PDFFontEncodeStrings: array[TPDFFontEncoding] of string = (
		'WinAnsiEncoding', 'MacRomanEncoding', 'MacExpertEncoding',
		'StandardEncoding', 'PDFDocEncoding');

	ImageFilter: array[TgtRPImageFormat] of string =
		('/LZWDecode', '/DCTDecode', '/FlateDecode');

implementation

uses gtRPRender_MainDlg, gtRPRender_DocumentDlg, gtRPRender_PDFDlg;

{------------------------------------------------------------------------------}
{ TgtRPRenderPDF }
{------------------------------------------------------------------------------}

constructor TgtRPRenderPDF.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);

	DisplayName := sPDFDesc;
	FileExtension := '*.' + sPDFExt;
	ExportImageFormat := ifBMP;
	FCompressionMethod := cmMaxCompress;
	FEncoding := feWinAnsiEncoding;
	FUseCompression := True;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.SetExportImageFormat(Value: TgtRPImageFormat);
begin
	if Value in [ifJPG, ifBMP] then
		inherited ExportImageFormat := Value
	else
		DoErrorMessage(sUnsupportedPDFImageFormat);
end;

{------------------------------------------------------------------------------}

function TgtRPRenderPDF.ColorToPDFColor(AColor: TColor): string;
	function PDFColor(HexCode: string): string;
	begin
		Result := Format('%1.4f',
			[StrToIntDef('$' + HexCode, 0) / 255]);
		if DecimalSeparator <> '.' then
			Result := ReplaceString(Result, DecimalSeparator, '.');
	end;
begin
	// Converts specified color into PDF color format
	Result := IntToHex(ColorToRGB(AColor), 6);
	if AColor < 0 then
		Result := IntToHex(ColorToRGB(clBlack), 6);
	Result := PDFColor(Copy(Result, 5, 2)) + ' ' +
		PDFColor(Copy(Result, 3, 2)) + ' ' + PDFColor(Copy(Result, 1, 2));
end;

{------------------------------------------------------------------------------}

function TgtRPRenderPDF.CompletePath(APen: TPen; ABrush: TBrush): string;
var
	Fill, Stroke: Boolean;
begin
	Result := '';
	Fill := False;
	if ABrush <> nil then
		Fill := DoFill(ABrush);
	Stroke := DoStroke(APen);
	if Fill and Stroke then
		Result := 'b*'
	else if Fill then
		Result := 'f'
	else if Stroke then
		Result := 'h S'
	else
		Result := 's';
end;

{------------------------------------------------------------------------------}

function TgtRPRenderPDF.CompressStream(
	InputStream, OutputStream: TStream): Integer;
{$IFDEF ZLib}
var
		CmprStream: TCompressionStream;
{$ENDIF}
begin
	Result := InputStream.Size;
	// Compress page if requested & ZLib enabled.
	{$IFDEF ZLib}
		if UseCompression then
		begin
			CmprStream := TCompressionStream.Create(
				TCompressionLevel(CompressionMethod), OutputStream);
			try
				Result := OutputStream.Size;
				InputStream.Position := 0;
				CmprStream.Write(TMemoryStream(InputStream).Memory^, InputStream.Size);
			finally
				CmprStream.Free;
				Result := OutputStream.Size - Result;
			end;
		end
		else
			OutputStream.CopyFrom(InputStream, 0);
	{$ELSE}
		OutputStream.CopyFrom(InputStream, 0);
	{$ENDIF}
end;

{------------------------------------------------------------------------------}

function TgtRPRenderPDF.DoFill(ABrush: TBrush): Boolean;
begin
	Result := ABrush.Style <> bsClear;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderPDF.DoStroke(APen: TPen): Boolean;
begin
	Result := APen.Style <> psClear;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderPDF.EncodeArc(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Double;
	ClosePath: Boolean): string;

	function CalculateAngle(XCenter, YCenter, X, Y: Double): Double;
	begin
		If X > XCenter then
		begin
			Result := 360.0 + RadiansToDegrees(ArcTan((Y - YCenter) / (X - XCenter)));
			If Result >= 360.0 then
				Result := Result - 360.0;
		end
		else if X < XCenter then
			Result := 180.0 + RadiansToDegrees(ArcTan((Y - YCenter) / (X - XCenter)))
		else
		begin
			If Y > YCenter then
				Result := 90.0
			else
				Result := 270.0;
		end;
	end;

var
	XCenter, YCenter, Radius, StartX, StartY: Double;
	Alpha, Beta, TempAngle: Double;

begin
	// Calculate center & radius
	XCenter := (X1 + X2) / 2.0;
	YCenter := (Y1 + Y2) / 2.0;
	Radius := Abs(X1 - X2) / 2.0;

	Alpha := CalculateAngle(XCenter, YCenter, X3, Y3) + 180;
	Beta := CalculateAngle(XCenter, YCenter, X4, Y4) + 180;

	while (Beta < Alpha) do
		Beta := Beta + 360;

	// Get starting point
	StartX := XCenter - Radius * cos(DegreesToRadians(Alpha));
	StartY := YCenter - Radius * sin(DegreesToRadians(Alpha));

	// Line style
	Result := GetLineStyle(Converter.Pen.Style);
	// Width, spacing and color
	Result := Result + NumToStr(
		GetNativeXPos(Converter.Pen.Width / cPixelsPerInch))
		+ ' w' + CR + ColorToPDFColor(Converter.Pen.Color) + ' RG';
	// Move to starting point
	Result := Result + CR + NumToStr(StartX) + ' ' + NumToStr(StartY) + ' m';

	while (Beta - Alpha > 90) do
	begin
		TempAngle := Alpha + 90;
		Result := Result + CR + PDFShortArc(XCenter, YCenter, Radius, Alpha,
			TempAngle);
		Alpha := TempAngle;
	end;
	if (Alpha <> Beta) then
		Result := Result + CR +
			PDFShortArc(XCenter, YCenter, Radius, Alpha, Beta);

	if ClosePath then
		Result := Result + CR + '0 w' + CR +
			ColorToPDFColor(Converter.Brush.Color) + ' rg' + CR +
			CompletePath(Converter.Pen, nil);
end;

{------------------------------------------------------------------------------}

function TgtRPRenderPDF.EncodeRect(PosX, PosY, Width, Height: Double): string;
var
	LS, TS, WS, HS: string;
	ALeft, ATop, AWidth, AHeight: Extended;
begin
	if IncludeLines then
	begin
		ALeft := GetNativeXPos(PosX);
		ATop := GetNativeYPos(PosY);
		AWidth := GetNativeXPos(Width);
		AHeight := Height * cInchToPoint;

		Result := '';

		// Line Style
		Result := GetLineStyle(Converter.Pen.Style);
		// Border width, spacing and color
		Result := Result +
			NumToStr(GetNativeXPos(Converter.Pen.Width / cPixelsPerInch)) +
			' w' + CR + ColorToPDFColor(Converter.Pen.Color) + ' RG';

		// Left, top, width, height encoded as strings
		LS := NumToStr(ALeft) + ' ';
		TS := NumToStr(ATop) + ' ';
		WS := NumToStr(AWidth) + ' ';
		HS := NumToStr(AHeight) + ' ';
		Result := Result + CR + LS + TS + WS + HS + 're';

		if Converter.Brush.Style <> bsClear then
			Result := Result + CR + '0 w' + CR +
				ColorToPDFColor(Converter.Brush.Color) + ' rg';
	end;
end;

{------------------------------------------------------------------------------}

{$IFDEF Rave407Up}

function TgtRPRenderPDF.EncodePolyLine(
	const PolyLineArr: array of
    {$IFDEF Rave50Up} TFloatPoint {$ELSE} TPoint {$ENDIF}): string;
var
	I: Integer;
	ALeft, ATop, ARight, ABottom: string;
begin
	// Left, top, right, bottom encoded as strings
	ALeft := NumToStr(GetNativeXPos(FCurrentX)) + ' ';
	ATop := NumToStr(GetNativeYPos(FCurrentY)) + ' ';

	// Line Style
	Result := GetLineStyle(Converter.Pen.Style);
	// Line width, spacing and color
	Result := Result + NumToStr(GetNativeXPos(
		Converter.Pen.Width / cPixelsPerInch)) +
		' w' + CR + ColorToPDFColor(Converter.Pen.Color) + ' RG';

	Result := Result + CR + ALeft + ATop + 'm' + CR;
	for I := Low(PolyLineArr) to  High(PolyLineArr) do
	begin
		ARight := NumToStr(GetNativeXPos(PolyLineArr[I].X / FontDPI)) + ' ';
		ABottom := NumToStr(GetNativeYPos(PolyLineArr[I].Y / FontDPI)) + ' ';
		Result := Result + ARight + ABottom + 'l' + CR;
	end;
end;

{$ENDIF}

{------------------------------------------------------------------------------}

function TgtRPRenderPDF.GetEllipseCtrlPts(
	PosX1, PosY1, PosX2, PosY2: Double): TgtRPEllipseCtrlPoints;
var
	cpFactor: Double;
begin
	// cpFactor := 4/3 * (1-cos 45∞)/sin 45∞ := 4/3 * sqrt(2) - 1
	cpFactor := (4.0 / 3.0) * (Sqrt(2) - 1.0);

	with Result do
	begin
		If PosX1 < PosX2 then
			X1 := PosX1
		else
			X1 := PosX2;
		If PosX1 > PosX2 then
			X5 := PosX1
		else
			X5 := PosX2;
		X3 := (PosX1 + PosX2) / 2.0;
		X2 := X3 - cpFactor * (X3 - X1);
		X4 := X3 + cpFactor * (X3 - X1);

		If PosY1 < PosY2 then
			Y5 := PosY1
		else
			Y5 := PosY2;
		If PosY1 > PosY2 then
			Y1 := PosY1
		else
			Y1 := PosY2;
		Y3 := (PosY1 + PosY2) / 2.0;
		Y2 := Y3 - cpFactor * (Y3 - Y1);
		Y4 := Y3 + cpFactor * (Y3 - Y1);
	end;
end;

{------------------------------------------------------------------------------}

{ Encode Fill Styles. Draw lines and then clip lines to get
	required fill pattern. }
function TgtRPRenderPDF.GetFillStyles(
	ABrush: TBrush; ALeft, ATop, ARight, ABottom: Extended): string;

const
	CFillLineGap = 8; // Gap between two adjacent fill lines.

	function GetFillLine(APosX1, APosY1, APosX2, APosY2: Extended): string;
	begin
		Result := NumToStr(APosX1) + ' ' + NumToStr(APosY1) + ' m ' +
			NumToStr(APosX2) + ' ' + NumToStr(APosY2) + ' l';
	end;

	function GetHorizontalBrushStyle: string;
	var
		Y: Extended;
	begin
		// Draw from Top to Bottom.
		Y := ATop;
		while Y > ABottom do
		begin
			Result := Result + CR + GetFillLine(ALeft, Y, ARight, Y);
			Y := Y - CFillLineGap;
		end;
	end;

	function GetVerticalBrushStyle: string;
	var
		X: Extended;
	begin
		// Draw from Left to Right.
		X := ALeft;
		while X < ARight do
		begin
			Result := Result + CR + GetFillLine(X, ATop, X, ABottom);
			X := X + CFillLineGap;
		end;
	end;

	function GetFDiagonalBrushStyle: string;
	var
		X, Y: Extended;
	begin
		// Draw from TopRight to BottomLeft.
		X := ARight;
		Y := ATop;
		while (X > (ALeft - Abs(ARight - ALeft))) or
			(Y > (ABottom - Abs(ATop - ABottom))) do
		begin
			Result := Result + CR + GetFillLine(X, ATop, ARight, Y);
			X := X - CFillLineGap;
			Y := Y - CFillLineGap;
		end;
	end;

	function GetBDiagonalBrushStyle: string;
	var
		X, Y: Extended;
	begin
		// Draw from TopLeft to BottomRight.
		X := ALeft;
		Y := ATop;
		while (X < (ARight + Abs(ARight - ALeft))) or
			(Y > (ABottom - Abs(ATop - ABottom))) do
		begin
			Result := Result + CR + GetFillLine(X, ATop, ALeft, Y);
			X := X + CFillLineGap;
			Y := Y - CFillLineGap;
		end;
	end;

begin
	Result := '';
	Result := 'W' + CR + 's []0 d' + CR + '1 w ' +
		ColorToPDFColor(ABrush.Color) + ' RG ';

	case ABrush.Style of
		bsHorizontal:
			Result := Result + GetHorizontalBrushStyle;

		bsVertical:
			Result := Result + GetVerticalBrushStyle;

		bsFDiagonal:
			Result := Result + GetFDiagonalBrushStyle;

		bsBDiagonal:
			Result := Result + GetBDiagonalBrushStyle;

		bsCross:
		begin
			Result := Result + GetVerticalBrushStyle;
			Result := Result + GetHorizontalBrushStyle;
		end;

		bsDiagCross:
		begin
			Result := Result + GetFDiagonalBrushStyle;
			Result := Result + GetBDiagonalBrushStyle;
		end;
	end;

	Result := Result + CR + 'S';
end;

{------------------------------------------------------------------------------}

function TgtRPRenderPDF.GetFontInfoObj(AFont: TgtRPFontAttrib): TgtRPFontInfo;
begin
	Result := TgtRPFontInfo.Create;
	Result.fiFontObjRef := GetNewObjNo;
	Result.fiFontDescriptorObjRef := GetNewObjNo;
	FillFontMetrics(AFont, Result);
end;

{------------------------------------------------------------------------------}

function TgtRPRenderPDF.GetLineStyle(AStyle: TPenStyle): string;
const
	LineType: array[TPenStyle] of string = ('[]0', '[16 8]0', '[3 4]0',
		'[8 4 2 4]0', '[8 4 2 4 2 8]0', '', '');
begin
	Result := LineType[AStyle];
	if Result <> '' then
		Result := Result + ' d' + CR;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderPDF.GetNativeXPos(X: Extended): Extended;
begin
	Result := X * cInchToPoint; // Convert from inches to points
end;

{------------------------------------------------------------------------------}

function TgtRPRenderPDF.GetNativeYPos(Y: Extended): Extended;
var
	PageHeight: Extended;
begin
	Result := Y * cInchToPoint; // Convert from inches to points
	// Y0 is at bottom of screen in PDF
	PageHeight := PaperHeight * cInchToPoint;
	if PageHeight <> 0 then
		Result := PageHeight - Result;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderPDF.GetNewObjNo: Integer;
begin
	Inc(FObjRunNo);
	Result := FObjRunNo;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderPDF.MakeObjHead(ObjNo: Integer): string;
begin
	// Returns object head for specified object number
	Result := IntToStr(ObjNo) + ' 0 obj';
end;

{------------------------------------------------------------------------------}

function TgtRPRenderPDF.MakeObjRef(ObjNo: Integer): string;
begin
	// Returns object reference for specified object number
	Result := IntToStr(ObjNo) + ' 0 R';
end;

{------------------------------------------------------------------------------}

function TgtRPRenderPDF.PDFCurveto(X1, Y1, X2, Y2, X3, Y3: Double): string;
begin
	// Second control point coincides with final point
	if (X2 = X3) and (Y2 = Y3) then
		Result := Format('%s %s %s %s y', [NumToStr(X1), NumToStr(Y1),
			NumToStr(X3), NumToStr(Y3)])
	else
		Result := Format('%s %s %s %s %s %s c', [NumToStr(X1), NumToStr(Y1),
			NumToStr(X2), NumToStr(Y2), NumToStr(X3), NumToStr(Y3)]);
end;

{------------------------------------------------------------------------------}

function TgtRPRenderPDF.PDFShortArc(X, Y, R: Double;
	Alpha, Beta: Double): string;
var
	cpFactor: Double;
	AlphaRad, BetaRad, cosAlpha, cosBeta, sinAlpha, sinBeta: Double;
begin
	// Convert from degrees to radians
	AlphaRad := DegreesToRadians(Alpha);
	BetaRad  := DegreesToRadians(Beta);
	// This factor is used to calculate control points
	cpFactor := (4.0/3 * (1 - cos((BetaRad - AlphaRad)/2)) /
		sin((BetaRad - AlphaRad) / 2));

	sinAlpha := sin(AlphaRad);
	sinBeta := sin(BetaRad);
	cosAlpha := cos(AlphaRad);
	cosBeta := cos(BetaRad);

	Result := PDFCurveto(
		X - R * (cosAlpha - cpFactor * sinAlpha),			// X1
		Y - R * (sinAlpha + cpFactor * cosAlpha),			// Y1
		X - R * (cosBeta + cpFactor * sinBeta),				// X2
		Y - R * (sinBeta - cpFactor * cosBeta),				// Y2
		X - R * cosBeta,															// X3
		Y - R * sinBeta);															// Y3
end;

{------------------------------------------------------------------------------}

function TgtRPRenderPDF.SaveImageContents(ABitmap: TBitmap): Integer;

	function GetImageFilter: string;
	begin
		Result := '';
		if (ExportImageFormat = ifJPG)
				{$IFDEF ZLib} or UseCompression {$ENDIF} then
			Result := '/Filter' + ImageFilter[ExportImageFormat];
	end;

var
	S: string;
	ABmpStream, AStream: TStream;
	Bmp: TBitmap;
	ImageObjNo, X, Y: integer;
	P: PByteArray;
	AByte: Byte;
begin
	S := '';
	if ExportImageFormat <> ifBMP then
		AStream := GetBitmapAsJpgGifStream(ABitmap,
			ExportImageFormat, JPEGQuality)
	else
	begin
		AStream := TMemoryStream.Create;
		ABmpStream := TMemoryStream.Create;
		Bmp := TBitmap.Create;
		try
			Bmp.Assign(ABitmap);
			Bmp.PixelFormat := pf24Bit;
			TMemoryStream(ABmpStream).SetSize(Bmp.Width * Bmp.Height * 3);
			// Convert the Bitmap image into PDF supported Bitmap image format.
			for Y := 0 to Bmp.Height - 1 do
			begin
				P := Bmp.ScanLine[y];
				X := 0;
				while X < Bmp.Width * 3 - 1 do
				begin
					AByte := P[X];
					P[X] := P[X + 2];
					P[X + 2] := AByte;
					Inc(X, 3);
				end;
				ABmpStream.Write(P^, Bmp.Width * 3);
			end;
			// Compress Bitmap if requested & ZLib enabled.
			CompressStream(ABmpStream, AStream);
		finally
			Bmp.Free;
			ABmpStream.Free;
		end;
	end;

	try
		ImageObjNo := GetNewObjNo;
		Result := FImageCtlList.Add(IntToStr(ImageObjNo));
		FImageXRefList.AddObject(IntToStr(FImageStream.Size), TObject(ImageObjNo));
		S := MakeObjHead(ImageObjNo) + CRLF + '<< ' +
			'/Type/XObject/Subtype/Image' +
			'/Name/Img' + IntToStr(Result) +
			'/Width ' + IntToStr(ABitmap.Width) +
			'/Height ' + IntToStr(ABitmap.Height) +
			'/BitsPerComponent 8' +
			'/ColorSpace/DeviceRGB' +
			GetImageFilter +
			'/Length ' + IntToStr(AStream.Size) + ' >>' + CRLF +
			'stream' + CRLF;
		WriteToImageStream(S);
		FImageStream.CopyFrom(AStream, 0);
		S := CRLF + 'endstream' + CRLF + 'endobj' + CRLF;
		WriteToImageStream(S);
	finally
		AStream.Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.AppendXRef(APos, ObjNo: Integer);
begin
	FXRefTable.AddObject(IntToStr(APos), TObject(ObjNo));
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.EncodeImage(AGraphic: TGraphic;
	PosX, PosY, Width, Height: Double);
var
	ALeft, ATop, AWidth, AHeight: Double;
	K: Integer;
	AImageInfo: string;
	Bmp: TBitmap;

	function EncodeImageObjectRef(ImageNo: Integer): string;
	begin
		// Pass back reference of saved image object, to put in main content stream
		Result := 'q' + CR +
			NumToStr(AWidth) + ' 0 0 ' +
			NumToStr(AHeight) + ' ' +
			NumToStr(ALeft) + ' ' +
			NumToStr(ATop - AHeight) + ' cm' + CR +
			'/Img' + IntToStr(ImageNo) + ' Do' + CR + 'Q' + CRLF;
	end;

begin
	ALeft := GetNativeXPos(PosX);
	ATop := GetNativeYPos(PosY);
	AWidth := GetNativeXPos(Width);
	AHeight := Height * cInchToPoint;
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

		AImageInfo := '';
		K := SaveImageContents(Bmp);
		AImageInfo := EncodeImageObjectRef(K);
		WriteToPDFStream(AImageInfo);
	finally
		Bmp.Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.EncodeText(ATextDetails: TgtRPTextDetails);
const
	AttribSeparator: array[Boolean] of string = ('', ',');
	Bold: array[Boolean] of string = ('', 'Bold');
	Italic: array[Boolean] of string = ('', 'Italic');

var
	ALeft, ATop, AWidth, AHeight, AR: Extended;
	CosA, SinA, CharSpacing: Extended;
	Fn: Integer;
	EncodedText, FontName, FontAttrib: string;

	function EncodeTextDecor(LineType: TgtLineType): string;
	var
		W, Y: Extended;
		FontInfo: TgtRPFontInfo;
	begin
		FontInfo := TgtRPFontInfo(FFontTable.Objects[Fn]);
		if LineType = ltUnderline then
		begin
			W := FontInfo.fiUnderscoreSize;
			Y := FontInfo.fiUnderscorePosition;
		end
		else
		begin
			W := FontInfo.fiStrikeoutSize;
			Y := FontInfo.fiStrikeoutPosition;
		end;
		Y := ATop + Y;
		Result :=  NumToStr(W) + ' w' + CR +
			NumToStr(ALeft) + ' ' + NumToStr(Y) + ' m' + CR +
			NumToStr(ALeft + AWidth) + ' ' + NumToStr(Y + AHeight) + ' l' + CR + 'S';
	end;

	function GetPDFCharSpacing(AText: string): Extended;
	var
		I: Integer;
		AFontInfo: TgtRPFontInfo;
	begin
		Result := 0;
		if AText = '' then Exit;
		AFontInfo := TgtRPFontInfo(FFontTable.Objects[Fn]);
		for I := 1 to Length(AText) do
			Result := Result + AFontInfo.fiwidths[Ord(AText[I])];
		Result := Result * ATextDetails.FFont.Size / 1000;
		Result := (ATextDetails.FTextWidth /
			cPixelsPerInch * cInchToPoint) - Result;
		if Result = 0 then Exit;
		Result := Result / Length(AText);
	end;

begin
	with ATextDetails do
	begin
		ALeft := GetNativeXPos(FX / cPixelsPerInch);
		ATop := GetNativeYPos(FY / cPixelsPerInch);
		AWidth := GetNativeXPos(FTextWidth / cPixelsPerInch);
		AHeight := 0;

		// Construct font str with attributes
		FontName := ReplaceString(FFont.Name, ' ', '');
		FontAttrib := FontName +
			AttribSeparator[[fsBold, fsItalic] * FFont.Style <> []] +
			Bold[fsBold in FFont.Style] +
			Italic[fsItalic in FFont.Style];

		// Add font to font list if encountered for the first time
		Fn := FFontTable.IndexOf(FontAttrib);
		if Fn = -1 then
			Fn := FFontTable.AddObject(FontAttrib, GetFontInfoObj(FFont));

		EncodedText := FText;
		CharSpacing := GetPDFCharSpacing(EncodedText);
		EncodedText := GetNativeText(EncodedText);

		if FFontRotation <> 0 then
		begin
			CosA := Cos(DegreesToRadians(FFontRotation));
			SinA := Sin(DegreesToRadians(FFontRotation));
			if FTextAlign = tpAlignRight then
				AR := FTextWidth
			else if FTextAlign = tpAlignCenter then
				AR := FTextWidth / 2.0
			else
				AR := 0;
			ATop := GetNativeYPos((FY + (AR * SinA)) / cPixelsPerInch);
			ALeft := GetNativeXPos((FX + (AR * (1 - CosA))) / cPixelsPerInch);
			AWidth := GetNativeXPos(FTextWidth * CosA / cPixelsPerInch);
			AHeight := GetNativeXPos(FTextWidth * SinA / cPixelsPerInch);

			EncodedText := Format('%s %s %s %s %s %s Tm (%s) Tj',
				[NumToStr(CosA), NumToStr(SinA),
				NumToStr(-SinA), NumToStr(CosA), NumToStr(ALeft),
				NumToStr(ATop), EncodedText]) + CR + 'ET';
		end
		else
			EncodedText := Format('%s %s Td (%s) Tj', [NumToStr(ALeft),
				NumToStr(ATop), EncodedText]) + CR + 'ET';

		if CharSpacing <> 0 then
			EncodedText := Format('%s Tc', [NumToStr(CharSpacing)]) +
				CR + EncodedText;
		EncodedText := 'BT' + CR +
			ColorToPDFColor(FFont.Color) + ' rg' + CR +
			Format('/F%d %d Tf', [Fn, FFont.Size]) + CR + EncodedText;

		// Draw your own underlines and strikeouts, no help from PDF here!
		if fsUnderline in FFont.Style then
			EncodedText := EncodedText + CR + ColorToPDFColor(FFont.Color) +
				' RG' + CR + EncodeTextDecor(ltUnderline);
		if fsStrikeOut in FFont.Style then
			EncodedText := EncodedText + CR + ColorToPDFColor(FFont.Color) +
				' RG' + CR + EncodeTextDecor(ltStrikeOut);

		EncodedText := EncodedText + CRLF;
		WriteToPDFStream(EncodedText);
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.InitPDFFontInfoObj(AFont: TFont;
	AFontInfoObj: TgtRPFontInfo);
var
	I: Integer;
begin
	with AFontInfoObj do
	begin
		fiFlags := 0;
		fiFontBBox := Rect(-250, -200, 1000, 900);
		fiAscent := 800;
		fiDescent := -200;
		fiCapHeight := 700;
		fiAvgWidth := 600;
		fiMaxWidth := 600;
		fiStemV := 0;
		fiItalicAngle := 0;
		fiLeading := 0;
		fiStrikeoutSize := AFont.Size div 20;
		fiStrikeoutPosition := Abs(AFont.Height) div 5;
		fiUnderscoreSize := AFont.Size div 10;
		fiUnderscorePosition := -1;
		for I := Low(fiWidths) to High(fiWidths) do
			fiWidths[I] := 600;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.FillFontMetrics(AFont: TgtRPFontAttrib;
	AFontInfoObj: TgtRPFontInfo);
var
	Font: TFont;
	DC: HDC;
	SaveFont: HFont;
	TM: TTextMetric;
	OTM: TOutlineTextmetric;
	SaveMM: Integer;

	function GetPDFFontFlags: Integer;
	begin
		with TM do
		begin
			Result :=
				// If bit TMPF_FIXED_PITCH is set the font is NOT fixed-pitch,
				// the values are reversed. Check Win API help on TextMetric.
				cPDFFontFixedPitch[(tmPitchAndFamily and TMPF_FIXED_PITCH) = 0] +
				cPDFFontSerif[(tmPitchAndFamily and FF_ROMAN) <> 0] +
				cPDFFontSymbolic[tmCharSet = SYMBOL_CHARSET] +
				cPDFFontScript[(tmPitchAndFamily and FF_SCRIPT) <> 0] +
				cPDFFontNonSymbolic[tmCharSet <> SYMBOL_CHARSET] +
				cPDFFontItalic[tmItalic <> 0];
		end;
	end;

	procedure FillCharWidths;
	var
		I: Integer;
		ASize: TSize;
		C: string;
	begin
		ASize.cx := 0;
		ASize.cy := 0;
		with AFontInfoObj do
			for I := Low(fiWidths) to High(fiWidths) do
			begin
				C := Chr(I);
				GetTextExtentPoint32(DC, PChar(C), 1, ASize);
				fiWidths[I] := Round(ASize.cx / cPixelsPerInch * cInchToPoint);
			end;
	end;

begin
	Font := TFont.Create;
	with AFontInfoObj do
		try
			with Font do
			begin
				Charset := AFont.Charset;
				Name :=  AFont.Name;
				Size := AFont.Size;
				Pitch := AFont.Pitch;
				Style := AFont.Style;
			end;
			InitPDFFontInfoObj(Font, AFontInfoObj);
			Font.Size := 1000;
			DC := GetDC(0);
			SaveFont := SelectObject(DC, Font.Handle);
			SaveMM := GetMapMode(DC);
			SetMapMode(DC, MM_TEXT);
			FillCharWidths;
			GetTextMetrics(DC, TM);
			with TM do
			begin
				fiFlags := GetPDFFontFlags;
				fiAscent := tmAscent div cPixelsPerInch * cInchToPoint;
				fiDescent := -Abs(tmDescent) div cPixelsPerInch * cInchToPoint;
				fiCapHeight := tmAscent div cPixelsPerInch * cInchToPoint;
				fiAvgWidth := tmAveCharWidth div cPixelsPerInch * cInchToPoint;
				fiMaxWidth := tmMaxCharWidth div cPixelsPerInch * cInchToPoint;
				fiLeading := tmExternalLeading div cPixelsPerInch * cInchToPoint;
				fiFontBBox := Rect(
					fiFontBBox.Left,
					fiAscent,
					fiMaxWidth,
					fiDescent);
				if (tmPitchAndFamily and TMPF_TRUETYPE) <> 0 then
				begin
					GetOutlineTextMetrics(DC, SizeOf(OTM),  @OTM);
					with OTM do
					begin
						// Required in degrees but function returns in tenths of a degree
						fiItalicAngle := otmItalicAngle div 10;
						//	fiStemV := 0;
						fiStrikeoutSize := Round(((otmsStrikeoutSize / cPixelsPerInch)
							 * cInchToPoint) * AFont.Size / 1000);
						fiStrikeoutPosition := Round(((
							otmsStrikeoutPosition / cPixelsPerInch)
							 * cInchToPoint) * AFont.Size / 1000);
						fiUnderscoreSize := Round(((otmsUnderscoreSize / cPixelsPerInch)
							 * cInchToPoint) * AFont.Size / 1000);
						fiUnderscorePosition := Round(((
							otmsUnderscorePosition / cPixelsPerInch)
							 * cInchToPoint) * AFont.Size / 1000) - 1;
					end;
				end;
				SetMapMode(DC, SaveMM);
				SelectObject(DC, SaveFont);
				ReleaseDC(0, DC);
			end;
		finally
			Font.Free;
		end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.WriteBackground;
var
	S: string;
	APaperWidth, APaperHeight, APaperWidthCenter, APaperHeightCenter: Extended;
	ATop, ALeft, AWidth, AHeight: Double;
	Bmp: TBitmap;
begin
	APaperWidth := GetNativeXPos(PaperWidth);
	APaperHeight := PaperHeight * cInchToPoint;
	APaperWidthCenter := APaperWidth / 2.0;
	APaperHeightCenter := APaperHeight / 2.0;
	ATop := 0;	// For dtTile, dtTopLeft, dtTopCenter, dtTopRight
	ALeft := 0;	// For dtTile, dtTopLeft, dtCenterLeft, dtBottomLeft
	AWidth := APaperWidth;
	AHeight := APaperHeight;

	S := 'q' + CR + '0 w' + CR +
		ColorToPDFColor(BackgroundColor) + ' rg' + CR +
		NumToStr(ALeft) + ' ' +
		NumToStr(GetNativeYPos(ATop) - AHeight) + ' ' +
		NumToStr(AWidth) + ' ' +
		NumToStr(AHeight) + ' re' + CR + 'f' + CR;
	S := S + 'Q' + CRLF;

	if BackgroundImage.Graphic <> nil then
		with BackgroundImage do
		begin
			if BackgroundImageDisplayType <> dtTile then
			begin
				AWidth := GetNativeXPos(Width / cPixelsPerInch);
				AHeight := GetNativeXPos(Height / cPixelsPerInch);
			end;
			if BackgroundImageDisplayType in
					[dtCenterLeft, dtCenter, dtCenterRight] then
				ATop := APaperHeightCenter -
					GetNativeXPos((Height / cPixelsPerInch) / 2.0)
			else if BackgroundImageDisplayType in
					[dtBottomLeft, dtBottomCenter, dtBottomRight] then
				ATop := APaperHeight - GetNativeXPos(Height / cPixelsPerInch);

			if BackgroundImageDisplayType in
					[dtTopCenter, dtCenter, dtBottomCenter] then
				ALeft := APaperWidthCenter -
					GetNativeXPos((Width / cPixelsPerInch) / 2.0)
			else if BackgroundImageDisplayType in
					[dtTopRight, dtCenterRight, dtBottomRight] then
				ALeft := APaperWidth - GetNativeXPos(Width / cPixelsPerInch);

			ATop := GetNativeYPos(ATop / cInchToPoint);
			if FCurrentPageNo = 1 then
			begin
				Bmp := TBitmap.Create;
				try
					Bmp.Width := Width;
					Bmp.Height := Height;
					Bmp.Canvas.Draw(0, 0, Graphic);
					FBackgroundImageObjNo := SaveImageContents(Bmp);
				finally
					Bmp.Free;
				end;
			end;
			FBackgroundImageWidth := GetNativeXPos(Width / cPixelsPerInch);
			FBackgroundImageHeight := GetNativeXPos(Height / cPixelsPerInch);
			FBackgroundImageLeft := ALeft;
			FBackgroundImageTop := ATop;

			S := S + '/Pattern cs ' + CR + '/P1 scn' + CR +
				NumToStr(ALeft) + ' ' + NumToStr(ATop - AHeight) + ' ' +
				NumToStr(AWidth) + ' ' + NumToStr(AHeight) +
				' re' + CR + 'f' + CRLF;
		end;
	WriteToPDFStream(S);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.WriteObj(const S: string; ObjNo: Integer;
	IsObjectComplete: Boolean);
var
	ObjText: string;
begin
	ObjText := S;
	if Pos(CRLF, ObjText) <> 0 then
		ObjText := '<<' + CRLF + ObjText + CRLF + '>>';
	ObjText := MakeObjHead(ObjNo) + CRLF + ObjText + CRLF;
	if IsObjectComplete then
		ObjText := ObjText + 'endobj' + CRLF;
	AppendXRef(FOwnedStream.Size, ObjNo);
	WriteToOwnedStream(ObjText);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.WriteToImageStream(const AText: string);
begin
	// Write data to Image stream
	FImageStream.Write(Pointer(AText)^, Length(AText));
end;

{------------------------------------------------------------------------------}

procedure	TgtRPRenderPDF.WriteToPDFStream(const AText: string);
begin
	// Write data to PDF stream
	FPDFStream.Write(Pointer(AText)^, Length(AText));
end;

{------------------------------------------------------------------------------}

function TgtRPRenderPDF.GetNativeText(const Text: string): string;
begin
// Convert text to PDF native string format
	Result := ReplaceString(Text, '\' , '\\');
	Result := ReplaceString(Result, '(' , '\(');
	Result := ReplaceString(Result, ')' , '\)');
end;

{------------------------------------------------------------------------------}

function TgtRPRenderPDF.NumToStr(N: Extended): string;
begin
	Result := FloatToStrF(N, ffFixed, 18, 4); // Convert to native string
	// Regional settings! convert without changing DecimalSeparator
	if DecimalSeparator <> '.' then
		Result := ReplaceString(Result, DecimalSeparator, '.');
end;

{------------------------------------------------------------------------------}

function TgtRPRenderPDF.ShowSetupModal: Word;
begin
	with TgtRPRenderPDFDlg.Create(nil) do
	try
		RenderObject := Self;
		Application.ProcessMessages;
		Result := ShowModal;
	finally
		Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.Arc(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3,
	pfX4, pfY4: Double);
var
	S: string;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeNonRectShapes then
	begin
		S := 'q' + EncodeArc(GetNativeXPos(pfX1), GetNativeYPos(pfY1),
			GetNativeXPos(pfX2), GetNativeYPos(pfY2),
			GetNativeXPos(pfX3), GetNativeYPos(pfY3),
			GetNativeXPos(pfX4), GetNativeYPos(pfY4),
			False) + CR + 'S' + CR + 'Q' + CRLF;
		WriteToPDFStream(S);
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.Chord(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3,
	pfX4, pfY4: Double);
var
	S: string;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeNonRectShapes then
	begin
		S := 'q' + EncodeArc(GetNativeXPos(pfX1), GetNativeYPos(pfY1),
			GetNativeXPos(pfX2), GetNativeYPos(pfY2),
			GetNativeXPos(pfX3), GetNativeYPos(pfY3),
			GetNativeXPos(pfX4), GetNativeYPos(pfY4), True) + CR + 'Q' + CRLF;
		WriteToPDFStream(S);
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.DocBegin;
var
	S: string;
begin
	if FExportCanceled then Exit;
	inherited DocBegin;

	FImageStream := TMemoryStream.Create;
	FPDFStream := TMemoryStream.Create;
	FFontTable := TStringList.Create;
	FImageCtlList := TStringList.Create;
	FImageXRefList := TStringList.Create;
	FXRefTable := TStringList.Create;

	FPageObjs := '';
	FObjRunNo := cLastReservedObjNo;
	// Write header
	S := '%PDF-1.3' + CRLF + '%‚„œ”' + CRLF;
	WriteToOwnedStream(S);
	// Write Root object
	S := '/Type /Catalog' + CRLF + '/Pages ' + MakeObjRef(cPagesTreeObjNo);
	WriteObj(S, cRootObjNo, True);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.DocEnd;

	function MakeXRef(Offset: Integer; GenNum: Integer; fn: Char): string;
	begin
		Result := Format('%.10d %.5d %s', [Offset, GenNum, fn]);
	end;

	function ToPDF(I: Integer): string;
	begin
		Result := IntToStr(Round(I * cInchToPoint));
	end;

var
	S, W, Pattern, ZoneBias: string;
	TmZone: TTimeZoneInformation;
	I, F, StartXRef, Pg: Integer;
	APatternResourceObjNo, APatternObjNo: Integer;
	FontInfoObj: TgtRPFontInfo;
	FontAttrib: TgtRPFontAttrib;

begin
	if FExportCanceled then
	begin
		inherited DocEnd;
		Exit;
	end;

	GetTimeZoneInformation(TmZone);
	ZoneBias := Format('%.2d', [TmZone.Bias div -60]);
	if ZoneBias[1] <> '-' then
	begin
		ZoneBias := '+' + ZoneBias;
		TmZone.Bias := TmZone.Bias * -1;
	end;
	ZoneBias := ZoneBias + '''' + Format('%.2d', [TmZone.Bias mod 60]) + '''';

	FPageObjs := Trim(FPageObjs);
	// Pages tree object
{$IFNDEF Registered}
		Pg := cMaxPages;
		if Pg > FCurrentPageNo then
			Pg := FCurrentPageNo;
{$ELSE}
		Pg := FTotalPages;
{$ENDIF}
	S := '/Type /Pages' + CRLF +
		'/Count ' + IntToStr(Pg) + CRLF +
		'/Kids [' + FPageObjs + ']';
	WriteObj(S, cPagesTreeObjNo, True);

	S := '';
	APatternObjNo := 0;
	if BackgroundImage.Graphic <> nil then
	begin
		APatternObjNo := GetNewObjNo;
		S := '/Pattern << /P1 ' + MakeObjRef(APatternObjNo) + ' >>' + CRLF;
	end;

	// Resources object - font
	if FFontTable.Count = 0 then
	begin
		with FontAttrib do
		begin
			Name := 'Arial';
			Charset := TFontcharset(1);
			Size := 10;
			Color := clBlack;
		end;
		FFontTable.AddObject('Arial', GetFontInfoObj(FontAttrib));
	end;
	if FFontTable.Count > 0 then
	begin
		S := S + '/Font <<' +  CRLF;
		with FFontTable do
			for I := 0 to Count - 1 do
				S := S + '/F' + IntToStr(I) + ' ' +
					MakeObjRef(TgtRPFontInfo(Objects[I]).fiFontObjRef) + CRLF;
		S := S + '>>' + CRLF;
	end;

	// Procset & Images references
	S := S + '/ProcSet ' + MakeObjRef(cProcSetObjNo);
	if FImageCtlList.Count > 0 then
	begin
		S := S + CRLF + '/XObject <<';
		with FImageCtlList do
			for I := 0 to Count - 1 do
				S := S + CRLF + '/Img' + IntToStr(I) + ' ' +
					MakeObjRef(StrToIntDef(Strings[I], 0));
		S := S + ' >>';
	end;
	WriteObj(S, cResourcesObjNo, True);

	// Pattern object
	if BackgroundImage.Graphic <> nil then
	begin
		Pattern := 'q' + CRLF +
			NumToStr(FBackgroundImageWidth) + ' 0 0 ' +
			NumToStr(FBackgroundImageHeight) + ' 0 0 ' + ' cm' + CRLF +
			'/Img0' + ' Do' + CRLF + 'Q' + CRLF;

		APatternResourceObjNo := GetNewObjNo;
		S := '/Type /Pattern' + CRLF +
			'/PatternType 1' + CRLF + 							// A tiling pattern
			'/PaintType 1' + CRLF +  								// A colored pattern
			'/Resources ' + MakeObjRef(APatternResourceObjNo) + CRLF +
			'/TilingType 1' + CRLF +
			'/BBox [0 0 ' + NumToStr(FBackgroundImageWidth) + ' ' +
				NumToStr(FBackgroundImageHeight) + ']' + CRLF +
			'/Matrix [1 0 0 1 ' + NumToStr(FBackgroundImageLeft) + ' ' +
				NumToStr(FBackgroundImageTop) + ']' + CRLF +
			'/XStep ' + NumToStr(FBackgroundImageWidth) + CRLF +
			'/YStep ' + NumToStr(FBackgroundImageHeight) + CRLF +
			'/Length ' + IntToStr(Length(Pattern));
		WriteObj(S, APatternObjNo, False);
		S := 'stream' + CRLF + Pattern + 'endstream' + CRLF + 'endobj' + CRLF;
		WriteToOwnedStream(S);

		// Pattern Resources object
		S := '/ProcSet [/PDF /ImageC]' + CRLF +
			'/XObject' + CRLF + '<< /Img0 ' +
			MakeObjRef(StrToIntDef(FImageCtlList.Strings[FBackgroundImageObjNo], 0)) +
			CRLF + '>>';
		WriteObj(S, APatternResourceObjNo, True);
	end;

	// ProcSet object
	S := '[/PDF /Text';
	if IncludeImages then
		S := S + ' /ImageC';
	S := S + ']';
	WriteObj(S, cProcSetObjNo, True);

	// Individual font objects
	with FFontTable, FontInfoObj do
		for I := 0 to Count - 1 do
		begin
			FontInfoObj := TgtRPFontInfo(Objects[I]);
			W := '';
			for F := Low(fiWidths) to High(fiWidths) do
				W := W + IntToStr(fiWidths[F]) + ' ';
			W := Trim(W);
			S := '/Type /Font' + CRLF +
				'/Subtype /TrueType' + CRLF +
				'/Name /F' + IntToStr(I) + CRLF +
				'/BaseFont /' + Strings[I] + CRLF +
				'/Encoding /' + PDFFontEncodeStrings[Encoding] + CRLF +
				'/FirstChar ' + IntToStr(Low(fiWidths)) + CRLF +
				'/LastChar ' + IntToStr(High(fiWidths)) + CRLF +
				'/Widths [' + W + ']' + CRLF +
				'/FontDescriptor ' + MakeObjRef(fiFontDescriptorObjRef);
			WriteObj(S, fiFontObjRef, True);

			S := '/Type /FontDescriptor' + CRLF +
				'/FontName /' + Strings[I] + CRLF +
				'/Flags ' + IntToStr(fiFlags) + CRLF +
				Format('/FontBBox [%d %d %d %d]', [
					fiFontBBox.Left,
					fiFontBBox.Bottom,
					fiFontBBox.Right,
					fiFontBBox.Top ]) + CRLF +
				'/Ascent ' + IntToStr(fiAscent) + CRLF +
				'/Descent ' + IntToStr(fiDescent) + CRLF +
				'/CapHeight ' + IntToStr(fiCapHeight) + CRLF +
				'/AvgWidth ' + IntToStr(fiAvgWidth) + CRLF +
				'/MaxWidth ' + IntToStr(fiMaxWidth) + CRLF +
				'/StemV ' + IntToStr(fiStemV) + CRLF +
				'/ItalicAngle ' + IntToStr(fiItalicAngle) + CRLF;
			WriteObj(S, fiFontDescriptorObjRef, True);
			TgtRPFontInfo(Objects[I]).Free;
		end;

	// Document Info object
	S := '/Author (' + GetNativeText(Author) + ')' + CRLF +
		'/CreationDate (D:' +
			FormatDateTime('yyyymmddhhnnss', Now) + ZoneBias + ')' + CRLF +
		'/Keywords (' + GetNativeText(Keywords) + ')' + CRLF +
		'/Creator (' + GetNativeText(Creator) + ')' + CRLF + '/Title (';
	if Title = '' then
		S := S + GetNativeText(Converter.Title)
	else
		S := S + GetNativeText(Title);
	S := S + ')' + CRLF + '/Subject (' + GetNativeText(Subject) + ')' + CRLF +
		'/Producer (Gnostice RaveRender V' + CVersion +
		' for Rave Reports \(www.gnostice.com\))';

	WriteObj(S, CInfoObjNo, True);

	StartXRef := FOwnedStream.Size;
	// Xref table
	S := 'xref' + CRLF + '0 ' + IntToStr(FObjRunNo + 1) + CRLF +
		MakeXRef(0, 65535, 'f') + CRLF;
	with FXRefTable do
		for I := 0 to Count - 1 do
			S := S + MakeXRef(StrToIntDef(Strings[
				IndexOfObject(TObject(I + 1))], 0), 0, 'n') + CRLF;
	WriteToOwnedStream(S);

	// Trailer & footer objects
	S := 'trailer' + CRLF +
		'<<' + CRLF +
		'/Root ' + MakeObjRef(cRootObjNo) + CRLF +
		'/Info ' + MakeObjRef(cInfoObjNo) + CRLF +
		'/Size ' + IntToStr(FObjRunNo + 1) + CRLF +
		'>>' + CRLF +
		'startxref' + CRLF + IntToStr(StartXRef) + CRLF +
		'%%EOF';
	WriteToOwnedStream(S);

	FFontTable.Free;
	FImageCtlList.Free;
	FImageXRefList.Free;
	FXRefTable.Free;
	FImageStream.Free;
	FPDFStream.Free;

	// Copy stream contents only if output was directed to user specified stream
	if OutputToUserStream then
		FUserStream.LoadFromStream(FOwnedStream);

	FOwnedStream.Free;
	FOwnedStream := nil;
	inherited DocEnd;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.Draw(const pfX1, pfY1: Double; AGraphic: TGraphic);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeImages then
		EncodeImage(AGraphic, pfX1, pfY1, AGraphic.Width / cPixelsPerInch,
			AGraphic.Height / cPixelsPerInch);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.Ellipse(const pfX1, pfY1, pfX2, pfY2: Double);
var
	EllipseCtrlPts: TgtRPEllipseCtrlPoints;
	S: string;
	APosX1, APosY1, APosX2, APosY2: Extended;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeNonRectShapes then
	begin
		APosX1 := GetNativeXPos(pfX1);
		APosY1 := GetNativeYPos(pfY1);
		APosX2 := GetNativeXPos(pfX2);
		APosY2 := GetNativeYPos(pfY2);
		
		EllipseCtrlPts := GetEllipseCtrlPts(APosX1, APosY1, APosX2, APosY2);

		with EllipseCtrlPts do
		begin
			// Line Style
			S := GetLineStyle(Converter.Pen.Style);
			// Width, spacing and color
			S := S + NumToStr(GetNativeXPos(Converter.Pen.Width / cPixelsPerInch)) +
				' w' + CR + ColorToPDFColor(Converter.Pen.Color) + ' RG';
			if Converter.Brush.Style <> bsClear then
				S := S + CR + '0 w' + CR +
					ColorToPDFColor(Converter.Brush.Color) + ' rg';
			// Move to starting point
			S := S + CR + NumToStr(X3) + ' ' + NumToStr(Y1) + ' m';
			// Draw four Bezier curves to approximate an Ellipse
			S := S + CR + PDFCurveto(X4, Y1, X5, Y2, X5, Y3);
			S := S + CR + PDFCurveto(X5, Y4, X4, Y5, X3, Y5);
			S := S + CR + PDFCurveto(X2, Y5, X1, Y4, X1, Y3);
			S := S + CR + PDFCurveto(X1, Y2, X2, Y1, X3, Y1);

		if (Converter.Brush.Style in [bsClear, bsSolid]) then
			S := S + CR + CompletePath(Converter.Pen, Converter.Brush)
		else
			S := S + CR + GetFillStyles(Converter.Brush,
				APosX1, APosY1, APosX2, APosY2) + CR + S + ' S';
		S := 'q' + CR + S + CR + 'Q' + CRLF;
			WriteToPDFStream(S);
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.EndText;
var
	FTextDetails: TgtRPTextDetails;
	I: Integer;
begin
	for I := 0 to FTextList.Count - 1 do
	begin
		FTextDetails := FTextList.Items[I];
		EncodeText(FTextDetails);
	end;
	ClearTextList;
	FProcessingText := False;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.FillRect(const pRect: TRect);
var
	S: string;
	ALeft, ATop, AWidth, AHeight: Extended;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeLines then
		with pRect do
		begin
			ALeft := Left / 72;
			ATop := Top / 72;
			AWidth := (Right - Left) / 72;
			AHeight := (Bottom - Top) / 72;

			S := EncodeRect(ALeft, ATop, AWidth, AHeight);
			if (Converter.Brush.Style in [bsClear, bsSolid]) then
				S := S + CR + CompletePath(Converter.Pen, Converter.Brush)
			else
				S := S + CR + GetFillStyles(Converter.Brush, GetNativeXPos(ALeft),
					GetNativeYPos(ATop), GetNativeXPos(AWidth),
					GetNativeXPos(AHeight)) + CR + S + ' S';
			S := 'q' + CR + S + CR + 'Q' + CRLF;

			WriteToPDFStream(S);
		end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.LineTo(const pfX1, pfY1: Double);
var
	S: string;
	ATop, ALeft, ARight, ABottom: string;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeLines then
	begin
		// Left, top, right, bottom encoded as strings
		ALeft := NumToStr(GetNativeXPos(FCurrentX)) + ' ';
		ATop := NumToStr(GetNativeYPos(FCurrentY)) + ' ';
		ARight := NumToStr(GetNativeXPos(pfX1)) + ' ';
		ABottom := NumToStr(GetNativeYPos(pfY1)) + ' ';

		// Line Style
		S := GetLineStyle(Converter.Pen.Style);
		// Line width, spacing and color
		S := S + NumToStr(GetNativeXPos(Converter.Pen.Width / cPixelsPerInch)) +
			' w' + CR + ColorToPDFColor(Converter.Pen.Color) + ' RG';

		S := S + CR + ALeft + ATop + 'm' + CR + ARight + ABottom + 'l';
		S := 'q' + CR + S + CR +
			CompletePath(Converter.Pen, nil) + CR + 'Q' + CRLF;
		WriteToPDFStream(S);
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.PageBegin;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	inherited PageBegin;
	FImageXRefList.Clear;
	TMemoryStream(FImageStream).Clear;
	TMemoryStream(FPDFStream).Clear;

	FPageObjNo := GetNewObjNo;
	FContentsObjNo := GetNewObjNo;
	FPageObjs := FPageObjs + ' ' + MakeObjRef(FPageObjNo);
	FLengthObjNo := GetNewObjNo;

	WriteBackground;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.PageEnd;
var
	S: string;
	I, ImageOffset, StreamSize: Integer;
	PgHeight, PgWidth: Extended;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

  PgHeight := PaperHeight * cInchToPoint;
	PgWidth := PaperWidth * cInchToPoint;

	// Page object
	S := '/Type /Page' + CRLF +
		'/MediaBox [0 0 ' + NumToStr(PgWidth) + ' ' + NumToStr(PgHeight) + ']'
      + CRLF +
		'/Resources ' + MakeObjRef(cResourcesObjNo) + CRLF +
		'/Parent ' + MakeObjRef(cPagesTreeObjNo) + CRLF +
		'/Contents ' + MakeObjRef(FContentsObjNo);
	WriteObj(S, FPageObjNo, True);

	// Page Length object and compression filter if setup
	S := '/Length ' + MakeObjRef(FLengthObjNo);
	{$IFDEF ZLib}
		if UseCompression then
			S := S + CRLF + '/Filter /FlateDecode'
		else
			S := '<< ' + S + ' >>';
	{$ELSE}
		S := '<< ' + S + ' >>';
	{$ENDIF}
	WriteObj(S, FContentsObjNo, False);

	// Write actual page contents
	S := 'stream' + CRLF;
	WriteToOwnedStream(S);
	StreamSize := CompressStream(FPDFStream, FOwnedStream);
	S := CRLF + 'endstream' + CRLF + 'endobj' + CRLF;
	WriteToOwnedStream(S);
	// Write page stream length object
	S := IntToStr(StreamSize);
	if S = '' then
		S := '0';
	WriteObj(S, FLengthObjNo, True);

	// Offset all image xrefs by (page + page lenght obj sizes)
	// and add to xref list
	for I := 0 to FImageXRefList.Count - 1 do
	begin
		ImageOffset := StrToIntDef(FImageXRefList[I], 0);
		Inc(ImageOffset, FOwnedStream.Size);
		AppendXRef(ImageOffset, Integer(FImageXRefList.Objects[I]));
	end;
	// Write all saved images to file
	if FImageStream.Size > 0 then
		FOwnedStream.CopyFrom(FImageStream, 0);

	inherited PageEnd;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.Pie(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3,
	pfX4, pfY4: Double);
var
	S: string;
	APosX1, APosY1, APosX2, APosY2, APosX3, APosY3, APosX4, APosY4: Extended;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeNonRectShapes then
	begin
		APosX1 := GetNativeXPos(pfX1);
		APosY1 := GetNativeYPos(pfY1);
		APosX2 := GetNativeXPos(pfX2);
		APosY2 := GetNativeYPos(pfY2);
		APosX3 := GetNativeXPos(pfX3);
		APosY3 := GetNativeYPos(pfY3);
		APosX4 := GetNativeXPos(pfX4);
		APosY4 := GetNativeYPos(pfY4);

		S := EncodeArc(APosX1, APosY1,
			APosX2, APosY2, APosX3, APosY3, APosX4, APosY4, False);

		S := S + CR + NumToStr(GetNativeXPos(
			Converter.Pen.Width / cPixelsPerInch)) +
			' w' + CR + ColorToPDFColor(Converter.Pen.Color) + ' RG';
		if Converter.Brush.Style <> bsClear then
			S := S + CR + '0 w' + CR + ColorToPDFColor(Converter.Brush.Color) + ' rg';

		S := S + CR + NumToStr(GetNativeXPos((pfX1 + pfX2) / 2.0)) + ' ' +
			NumTOStr(GetNativeYPos((pfY1 + pfY2) / 2.0)) + ' l';

		if (Converter.Brush.Style in [bsClear, bsSolid]) then
			S := S + CR + CompletePath(Converter.Pen, Converter.Brush)
		else
			S := S + CR + GetFillStyles(Converter.Brush,
				APosX1, APosY1, APosX2, APosY2) + CR + S + ' S';
		S := 'q' + CR + S + CR + 'Q' + CRLF;
		WriteToPDFStream(S);
	end;
end;

{------------------------------------------------------------------------------}

{$IFDEF Rave407Up}

procedure TgtRPRenderPDF.PolyLine(const PolyLineArr: array of
  {$IFDEF Rave50Up} TFloatPoint {$ELSE} TPoint {$ENDIF});
var
	S: string;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeLines then
	begin
		S := EncodePolyLine(PolyLineArr);
		S := 'q' + CR + S + CR +
			CompletePath(Converter.Pen, nil) + CR + 'Q' + CRLF;
		WriteToPDFStream(S);
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.Polygon(const PolyLineArr: array of
  {$IFDEF Rave50Up} TFloatPoint {$ELSE} TPoint {$ENDIF});
var
	I: Integer;
	S: string;
	APosX1, APosY1, APosX2, APosY2: Extended;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeLines then
	begin
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
		S := EncodePolyLine(PolyLineArr);
		if Converter.Brush.Style <> bsClear then
			S := S + CR + '0 w ' + ColorToPDFColor(Converter.Brush.Color) + ' rg';
		if (Converter.Brush.Style in [bsClear, bsSolid]) then
			S := S + CR + CompletePath(Converter.Pen, Converter.Brush)
		else
			S := S + CR + GetFillStyles(Converter.Brush,
				GetNativeXPos(APosX1 / FontDPI), GetNativeYPos(APosY1 / FontDPI),
				GetNativeXPos(APosX2 / FontDPI), GetNativeYPos(APosY2 / FontDPI)) +
				CR + S + ' S';
		S := 'q' + CR + S + CR + 'Q' + CRLF;
		WriteToPDFStream(S);
	end;
end;
{$ENDIF}

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.PrintBitmap(const X1, Y1, ScaleX, ScaleY: Double;
	AGraphic: Graphics.TBitmap);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeImages then
		EncodeImage(AGraphic, X1, Y1, AGraphic.Width * ScaleX / cPixelsPerInch,
			AGraphic.Height * ScaleX / cPixelsPerInch);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.PrintBitmapRect(const X1, Y1, X2, Y2: Double;
	AGraphic: Graphics.TBitmap);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeImages then
		EncodeImage(AGraphic, X1, Y1, Abs(X2 - X1), Abs(Y2 - Y1));
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.Rectangle(const pfX1, pfY1, pfX2, pfY2: Double);
var
	S: string;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeLines then
	begin
		S := EncodeRect(pfX1, pfY1, (pfX2 - pfX1), (pfY1 - pfY2));
		if (Converter.Brush.Style in [bsClear, bsSolid]) then
			S := S + CR + CompletePath(Converter.Pen, COnverter.Brush)
		else
			S := S + CR + GetFillStyles(Converter.Brush, GetNativeXPos(pfX1),
				GetNativeYPos(pfY1), (GetNativeXPos(pfX2)), GetNativeYPos(pfY2)) +
				CR + S + ' S';
		S := 'q' + CR + S + CR + 'Q' + CRLF;
		WriteToPDFStream(S);
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.RoundRect(const pfX1, pfY1, pfX2, pfY2,
	pfX3, pfY3: Double);
var
	EllipseCtrlPts: TgtRPEllipseCtrlPoints;
	S: string;
	RoundRectLineWidth, RoundRectLineHeight: Extended;
	APosX1, APosY1, APosX2, APosY2, APosX3, APosY3: Extended;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeLines then
	begin
		APosX1 := GetNativeXPos(pfX1);
		APosY1 := GetNativeYPos(pfY1);
		APosX2 := GetNativeXPos(pfX2);
		APosY2 := GetNativeYPos(pfY2);;
		APosX3 := GetNativeXPos(pfX1 + pfX3);
		APosY3 := GetNativeYPos(pfY1 + pfY3);

		EllipseCtrlPts := GetEllipseCtrlPts(APosX1, APosY1, APosX3, APosY3);
		RoundRectLineWidth := GetNativeXPos(pfX2 - pfX1 - pfX3);
		RoundRectLineHeight := GetNativeXPos(pfY2 - pfY1 - pfY3);

		with EllipseCtrlPts do
		begin
			// Line Style
			S := GetLineStyle(Converter.Pen.Style);
			// width, spacing and color
			S := S + NumToStr(GetNativeXPos(Converter.Pen.Width / cPixelsPerInch)) +
				' w' + CR + ColorToPDFColor(Converter.Pen.Color) + ' RG';
			// Move to starting point
			S := S + CR + NumToStr(X3) + ' ' + NumToStr(Y1) + ' m';

			// Draw RoundRect
			S := S + CR + NumToStr(X3 + RoundRectLineWidth) + ' ' +
				NumToStr(Y1) + ' l';
			S := S + CR + PDFCurveto(X4 + RoundRectLineWidth, Y1,
				X5 + RoundRectLineWidth, Y2, X5 + RoundRectLineWidth, Y3);

			S := S + CR + NumToStr(X5 + RoundRectLineWidth) + ' ' +
				NumToStr(Y3 - RoundRectLineHeight) + ' l';
			S := S + CR + PDFCurveto(
				X5 + RoundRectLineWidth, Y4 - RoundRectLineHeight,
				X4 + RoundRectLineWidth, Y5 - RoundRectLineHeight,
				X3 + RoundRectLineWidth, Y5 - RoundRectLineHeight);

			S := S + CR + NumToStr(X3) + ' ' +
				NumToStr(Y5 - RoundRectLineHeight) + ' l';
			S := S + CR + PDFCurveto(X2, Y5 - RoundRectLineHeight,
				X1, Y4 - RoundRectLineHeight, X1, Y3 - RoundRectLineHeight);

			S := S + CR + NumToStr(X1) + ' ' + NumToStr(Y3) + ' l';
			S := S + CR + PDFCurveto(X1, Y2, X2, Y1, X3, Y1);

			if Converter.Brush.Style <> bsClear then
				S := S + CR + '0 w ' + ColorToPDFColor(Converter.Brush.Color) + ' rg';
			if (Converter.Brush.Style in [bsClear, bsSolid]) then
				S := S + CR + CompletePath(Converter.Pen, Converter.Brush)
			else
				S := S + CR + GetFillStyles(Converter.Brush,
					APosX1, APosY1, APosX2, APosY2) + CR + S + ' S';
			S := 'q' + CR + S + CR + 'Q' + CRLF;

			WriteToPDFStream(S);
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.StretchDraw(const pRect: TRect; AGraphic: TGraphic);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	if IncludeImages then
		EncodeImage(AGraphic, pRect.Left / 72, pRect.Top / 72,
			Abs(pRect.Right - pRect.Left) / 72, Abs(pRect.Bottom - pRect.Top) / 72);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDF.TextRect(Rect: TRect; X1, Y1: double; S1: string);
var
	S: string;
	ATextDetails: TgtRPTextDetails;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

{	with Rect do
		S := 'q' + CR + EncodeRect(Left / 72, Top / 72,
			(Right - Left) / 72, (Bottom - Top) / 72) +
			CR + 'W n' + CR + CompletePath + CR;
	WriteToPDFStream(S);}
	ATextDetails := TgtRPTextDetails.Create;
	with ATextDetails do
		try
			SetFontDetails(ATextDetails);
			FTextAlign := tpAlignLeft;
			FTextWidth := (Rect.Right - Rect.Left);
  {$IFDEF Rave50Up}
      FTextHeight := Converter.FontData.Height * cPixelsPerInch;
  {$ELSE}
      FTextHeight := Converter.FontHeight * cPixelsPerInch;
  {$ENDIF}
			FText := ClipText(S1, Round(FTextWidth),
				GetTextSize(Converter.Font, S1).cx);
			FX := X1 * cPixelsPerInch;
			FY := Y1 * cPixelsPerInch;

			EncodeText(ATextDetails);
//			S := 'Q' + CRLF;
			WriteToPDFStream(S);
		finally
			Free;
		end;
end;

{------------------------------------------------------------------------------}

{$IFDEF Rave50Up}

procedure TgtRPRenderPDF.RenderPage(PageNum: integer);
begin
	inherited Renderpage(PageNum);

	if not FExportCanceled then
	begin
		try
			if FUserStream = nil then
				FOutputToUserStream := False;
			{ Create file stream if running in regular mode, where output is expected
				 in a disk file else create a memory stream and in the end copy stream
				 contents to user specified stream }
			if not OutputToUserStream then
				InitFileStream(ReportFileNames.Strings[0])
			else
				FOwnedStream := TMemoryStream.Create;
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

procedure TgtRPRenderPDF.PrintRender(NDRStream: TStream;
	OutputFileName: TFileName);
begin
	inherited PrintRender(NDRStream, OutputFileName);

	if not FExportCanceled then
	begin
		try
			if FUserStream = nil then
				FOutputToUserStream := False;
			{ Create file stream if running in regular mode, where output is expected
				 in a disk file else create a memory stream and in the end copy stream
				 contents to user specified stream }
			if not OutputToUserStream then
				InitFileStream(ReportFileNames.Strings[0])
			else
				FOwnedStream := TMemoryStream.Create;
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
