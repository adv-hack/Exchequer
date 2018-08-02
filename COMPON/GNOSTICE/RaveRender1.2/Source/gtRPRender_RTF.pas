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

unit gtRPRender_RTF;

interface

uses
	SysUtils, Windows, Messages, Classes, Graphics, Forms, Dialogs, StdCtrls,
	Controls, jpeg, RPRender, gtRPRender_Main, gtRPRender_Document,
	gtRPRender_Consts, gtRPRender_Utils;

type

{ TgtRPRenderRTF class }

	TgtRPRenderRTF = class(TgtRPRenderDocument)
	private
		FTempStream: TMemoryStream;									// Temporary memory stream
		FFontTable: TStrings;												// Font table list
		FColorTable: TStrings;											// Color table list
		FGraphicDataInBinary: Boolean;
		FTempFileName: string;
		FTempFileStream: TFileStream;
		FTempFileUsed: Boolean;
    FFirstPageWidth: Extended;
    FFirstPageHeight: Extended;
		{ Used in directing output to user supplied stream }
		FOutputToUserStream: Boolean;
		FUserStream: TMemoryStream;

		function ExtractBlueValue(AColor: TColor): string;
		function ExtractGreenValue(AColor: TColor): string;
		function ExtractRedValue(AColor: TColor): string;
		function GetColorNumInColorTbl(AColor: TColor): Integer;
		function GetBinHex(S: string): string;
		function GetNativePos(X: Extended): Integer;	// Returns position in RTF units: Twips.
		function InchesToTwips(X: Extended): Integer;
		function GetLineAttrib: string;
		function GetLineStyle: string;
		function GetShadeAttrib: string;
		function HexToInt(HexCode: string): string; 	// Converts Hex to Int and returns in a string.
		function RevHexBytes(S: string): string;			// Reverses the string of Hex bytes.
		function WriteBackgroundImage: string;

		procedure EncodeText(ATextDetails: TgtRPTextDetails);
    {$IFDEF Rave407Up}
		  procedure EncodePolyLine(const PolyLineArr: array of
        {$IFDEF Rave50Up} TFloatPoint {$ELSE} TPoint {$ENDIF};
        IsPolygon: Boolean);
    {$ENDIF}

		procedure EncodeGraphic(AGraphic: TGraphic; PosX, PosY, AWidth,
			AHeight: Integer; IsBackgroundImage: Boolean);
		procedure EncodeRect(const pfX1, pfY1, pfX2, pfY2: Double;
			ARectType: string);
		procedure SetBackgroundDisplay(Value: TgtRPBackgroundDisplayType);
		procedure SetExportImageFormat(Value: TgtRPImageFormat);
		procedure WriteToTempStream(AText: string);

	protected
		function GetNativeText(const Text: string): string; override;

		procedure Arc(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4,
			pfY4: Double); override;
		procedure Chord(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4,
			pfY4: Double); override;
		procedure DocBegin; override;
		procedure DocEnd; override;
		procedure Draw(const pfX1, pfY1: Double; AGraphic: TGraphic); override;
		Procedure EndText; override;
		procedure Ellipse(const pfX1, pfY1, pfX2, pfY2: Double); override;
		procedure FillRect(const pRect: TRect); override;
		procedure LineTo(const pfX1, pfY1: Double); override;
    {$IFDEF Rave407Up}
      procedure PolyLine(const PolyLineArr: array of
      {$IFDEF Rave50Up} TFloatPoint {$ELSE} TPoint {$ENDIF}); override;
      procedure Polygon(const PolyLineArr: array of
      {$IFDEF Rave50Up} TFloatPoint {$ELSE} TPoint {$ENDIF}); override;
    {$ENDIF}

		procedure Pie(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4,
			pfY4: Double); override;
		procedure PageBegin; override;
		procedure PageEnd; override;
		procedure PrintBitmapRect(const X1, Y1, X2, Y2: Double;
			AGraphic: Graphics.TBitmap); override;
		procedure PrintBitmap(const X1, Y1, ScaleX, ScaleY: Double;
			AGraphic: Graphics.TBitmap); override;
		procedure Rectangle(const pfX1, pfY1, pfX2, pfY2: Double); override;
		procedure RoundRect(const pfX1, pfY1, pfX2, pfY2, pfX3,
			pfY3: Double); override;
		procedure StretchDraw(const pRect: TRect; AGraphic: TGraphic); override;
		procedure TextRect(Rect: TRect; X1, Y1: Double; S1: string); override;

	public
		constructor Create(AOwner: TComponent); override;

		function ShowSetupModal: Word; override;

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
		property BackgroundImage;
		property BackgroundImageDisplayType write SetBackgroundDisplay;
		property Creator;
		property ExportImageFormat write SetExportImageFormat;
		property GraphicDataInBinary: Boolean read FGraphicDataInBinary
			write FGraphicDataInBinary default True;
		property ImageDPI;
		property ImagePixelFormat;
		property IncludeLines;
		property IncludeNonRectShapes;
		property IncludeImages;
		property JPEGQuality;
		property Keywords;
		property Subject;
		property Title;
	end;

const

	PictureType: array[TgtRPImageFormat] of string =
		('\wmetafile8', '\jpegblip', '\wmetafile8');

implementation

uses gtRPRender_MainDlg, gtRPRender_DocumentDlg, gtRPRender_RTFDlg,
  RpDefine;

{------------------------------------------------------------------------------}
{ TgtRPRenderRTF }
{------------------------------------------------------------------------------}

constructor TgtRPRenderRTF.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
	FGraphicDataInBinary := True;
	FileExtension := '*.' + sRTFExt;
	DisplayName := sRTFDesc;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderRTF.ExtractBlueValue(AColor: TColor): string;
begin
	Result := IntToStr(GetBValue(ColorToRGB(AColor)));
end;

{------------------------------------------------------------------------------}

function TgtRPRenderRTF.ExtractGreenValue(AColor: TColor): string;
begin
	Result := IntToStr(GetGValue(ColorToRGB(AColor)));
end;

{------------------------------------------------------------------------------}

function TgtRPRenderRTF.ExtractRedValue(AColor: TColor): string;
begin
	Result := IntToStr(GetRValue(ColorToRGB(AColor)));
end;

{------------------------------------------------------------------------------}

function TgtRPRenderRTF.GetColorNumInColorTbl(AColor: TColor): Integer;
begin
	// Add color to color list.
	Result := FColorTable.IndexOf(ColorBGRToRGB(AColor));
	if Result = -1 then
		Result := FColorTable.Add(ColorBGRToRGB(AColor));
	Inc(Result);
end;

{------------------------------------------------------------------------------}

function TgtRPRenderRTF.GetBinHex(S: string): string;
var
	I: Integer;
begin
	Result := '';
	for I := 1 to Length(S) do
		Result := Result + IntToHex(Ord(S[I]), 2);
end;

{------------------------------------------------------------------------------}

function TgtRPRenderRTF.GetNativePos(X: Extended): Integer;
begin
	// Convert pixels to twips.
	Result := Round((X / cPixelsPerInch) * cInchToPoint * cPointToTwip);
end;

{------------------------------------------------------------------------------}

function TgtRPRenderRTF.InchesToTwips(X: Extended): Integer;
begin
	// Convert inches to twips.
	Result := Round(X * cInchToPoint * cPointToTwip);
end;

{------------------------------------------------------------------------------}

function TgtRPRenderRTF.GetLineAttrib: string;
begin
	// Encodes line attributes.
	Result := '';
	if IncludeLines then
		Result :=
			'\dplinew' + NumToStr(Converter.Pen.Width) +
			'\dplinecor' +  ExtractRedValue(Converter.Pen.Color) +
			'\dplinecog' +  ExtractGreenValue(Converter.Pen.Color) +
			'\dplinecob' +	ExtractBlueValue(Converter.Pen.Color);
end;

{------------------------------------------------------------------------------}

function TgtRPRenderRTF.GetLineStyle: string;
begin
	// Encodes line style properties.
	case Converter.Pen.Style of
		psDash:
			Result := '\dplinedash';
		psDot:
			Result := '\dplinedot';
		psDashDot:
			Result := '\dplinedado';
		psDashDotDot:
			Result := '\dplinedadodo';
		psClear:
			Result := '\dplinehollow';
	else
		Result := '\dplinesolid';
	end;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderRTF.GetShadeAttrib: string;
const
	BrushStyle: array [TBrushStyle] of string = ('1', '0', '20', '21',
		 '22', '23', '24', '25');
var
	ABrushStyle: string;
begin
	// Encodes shade properties
	ABrushStyle := BrushStyle[Converter.Brush.Style];
	if (Converter.Brush.Style = bsSolid) then
		Result :=
			'\dpfillfgcr' + ExtractRedValue(Converter.Brush.Color) +
			'\dpfillfgcg' + ExtractGreenValue(Converter.Brush.Color) +
			'\dpfillfgcb' + ExtractBlueValue(Converter.Brush.Color)
	else
		Result :=
			'\dpfillfgcr255\dpfillfgcg255\dpfillfgcb255';

	Result := Result +
		'\dpfillbgcr'	+ ExtractRedValue(Converter.Brush.Color) +
		'\dpfillbgcg' +	ExtractGreenValue(Converter.Brush.Color) +
		'\dpfillbgcb' +	ExtractBlueValue(Converter.Brush.Color) +
		'\dpfillpat' + ABrushStyle;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderRTF.HexToInt(HexCode: string): string;
begin
	Result := IntToStr(StrToIntDef('$' + HexCode, 0));
end;

{------------------------------------------------------------------------------}

function TgtRPRenderRTF.RevHexBytes(S: string): string;
var
	I: Integer;
begin
	Result := '';
	I := Length(S) - 1;
	while I > 0 do
	begin
		Result := Result + Copy(S, I, 2);
		Dec(I, 2);
	end;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderRTF.WriteBackgroundImage: string;
var
	APaperWidth, APaperHeight, APaperWidthCenter, APaperHeightCenter,
	ATop, ALeft: Integer;
	ABmp: TBitmap;
begin
	// Sets background image position and calls Encodegr aphic to
	// encode background image.
	Result:= '';
	if BackgroundImage.Graphic <> nil then
	begin
		ALeft := 0;
		ATop := 0;
		APaperWidth := InchesToTwips(PaperWidth);
		APaperHeight := InchesToTwips(PaperHeight);
		APaperWidthCenter := APaperWidth div 2;
		APaperHeightCenter := APaperHeight div 2;

		if BackgroundImageDisplayType in
				[dtCenterLeft, dtCenter, dtCenterRight] then
			ATop := APaperHeightCenter - GetNativePos(BackgroundImage.Height) div 2
		else if BackgroundImageDisplayType in
				[dtBottomLeft, dtBottomCenter, dtBottomRight] then
			ATop := APaperHeight - GetNativePos(BackgroundImage.Height);

		if BackgroundImageDisplayType in
				[dtTopCenter, dtCenter, dtBottomCenter] then
			ALeft := APaperWidthCenter - GetNativePos(BackgroundImage.Width) div 2
		else if BackgroundImageDisplayType in
				[dtTopRight, dtCenterRight, dtBottomRight] then
			ALeft := APaperWidth - GetNativePos(BackgroundImage.Width);

		ABmp := TBitmap.Create;
		try
			ABmp.Height := BackgroundImage.Height;
			ABmp.Width := BackgroundImage.Width;
			ABmp.Canvas.Draw(0, 0, BackgroundImage.Graphic);
			ALeft := ALeft - InchesToTwips(sMarginLeft);
			ATop :=  ATop - InchesToTwips(sTopMargin);
			EncodeGraphic(ABmp, ALeft, ATop, ABmp.Width, ABmp.Height, True);
		finally
			ABmp.Free;
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.EncodeText(ATextDetails: TgtRPTextDetails);
const
	Bold: array[Boolean] of string = ('', ' \b');
	Italic: array[Boolean] of string = ('', ' \i');
	StrikeOut: array[Boolean] of string = ('', ' \strike');
	UnderLine: array[Boolean] of string = ('', ' \ul');
	Bold0: array[Boolean] of string = ('', ' \b0');
	Italic0: array[Boolean] of string = ('', ' \i0');
	StrikeOut0: array[Boolean] of string = ('', ' \strike0');
	UnderLine0: array[Boolean] of string = ('', ' \ul0');

var
	Fn, ATop, ALeft: Integer;
	EncodedText, AWidthEncodedText, TextAlignment, ATextAttribSetStr,
	ATextAttribResetStr: string;
	ABmp: TBitmap;
begin
	// Encodes text. If text is rotated it is encoded as a Image.
	TextAlignment := '';
	AWidthEncodedText := '';
	with ATextDetails do
	begin
		if FFontRotation <> 0 then
		begin
			ALeft := Round(FX);
			ATop := Round(FY);
			ABmp := GetRotatedTextBmp(FText, FFontRotation, ALeft, ATop, FTextWidth,
				FTextHeight, FTextAlign, FFont);
			try
				ATop := GetNativePos(ATop);
				ALeft := GetNativePos(ALeft);
				EncodeGraphic(ABmp, ALeft, ATop, ABmp.Width, ABmp.Height, False);
			finally
				ABmp.Free;
			end;
		end
		else
		begin
			case FTextAlign of
				tpAlignLeft:
					TextAlignment := '\ql';
				tpAlignRight:
					TextAlignment := '\qr';
				tpAlignCenter:
					TextAlignment := '\qc';
				tpAlignJustify:
					TextAlignment := '\qj';
			end;

			EncodedText := GetNativeText(FText);
			EncodedText := EncodedText;

			// Add font to font list if new.
			//Fn := FFontTable.IndexOf(FFont.Name);
			Fn := FFontTable.IndexOf(IntToStr(FFont.Charset) + ' ' + FFont.Name);
			if Fn = -1 then
				Fn := FFontTable.Add(IntToStr(FFont.Charset) + ' ' + FFont.Name);
				//Fn := FFontTable.Add(FFont.Name);

			ATextAttribSetStr :=
				'\f' + IntToStr(Fn) +
				'\cf' + IntToStr(GetColorNumInColorTbl(FFont.Color)) +
				'\fs' + IntToStr(FFont.Size * 2) +
				Bold[fsBold in FFont.Style] +
				Italic[fsItalic in FFont.Style] +
				StrikeOut[fsStrikeOut in FFont.Style] +
				UnderLine[fsUnderLine in FFont.Style] +
				TextAlignment;

			ATextAttribResetStr :=
				Bold0[fsBold in FFont.Style] +
				Italic0[fsItalic in FFont.Style] +
				StrikeOut0[fsStrikeOut in FFont.Style] +
				UnderLine0[fsUnderLine in FFont.Style];

			if FText <> '' then
			begin
				EncodedText := '\par\pard\pvpg\phpg' +
					'\posy' + NumToStr(GetNativePos(FY - FTextHeight)) +
					'\posx' + NumToStr(GetNativePos(FX)) +
					ATextAttribSetStr + ' ' + EncodedText + ' '	+ ATextAttribResetStr;
				WriteToTempStream(EncodedText);
			end;
		end;
	end;
end;

{------------------------------------------------------------------------------}

{$IFDEF Rave407Up}

procedure TgtRPRenderRTF.EncodePolyLine(const PolyLineArr: array of
{$IFDEF Rave50Up} TFloatPoint {$ELSE} TPoint {$ENDIF}; IsPolygon: Boolean);
var
	S: String;
	I, N: Integer;
	APosX1, APosY1: Extended;
begin
	S := '';
	N := Length(PolyLineArr);
	APosX1 := 0;
	APosY1 := 0;
	for I := Low(PolyLineArr) to High(PolyLineArr) do
	begin
		if APosX1 < PolyLineArr[I].X then
			APosX1 := PolyLineArr[I].X;
		if APosY1 < PolyLineArr[I].Y then
			APosY1 := PolyLineArr[I].Y;
	end;
	for I := 0 to N do
		S := S + '\dpptx' + NumToStr(InchesToTwips(PolyLineArr[I].x / FontDPI)) +
			'\dppty' + NumToStr(InchesToTwips(PolyLineArr[I].y / FontDPI));

	S := '{\*\do\dobxpage\dobypage\dppolygon' +
		'\dppolycount'+ NumToStr(N) + S + '\dpx0\dpy0' +
		'\dpxsize' + NumToStr(InchesToTwips(APosX1 / FontDPI)) +
		'\dpysize' + NumToStr(InchesToTwips(APosY1 / FontDPI)) +
		GetLineStyle + GetLineAttrib;
	if IsPolygon then
		S := S + GetShadeAttrib;
	S := '{\lang1024 ' + S + '}}';
	WriteToTempStream(S);
end;

{$ENDIF}

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.EncodeGraphic(AGraphic: TGraphic; PosX, PosY, AWidth,
	AHeight: Integer;	IsBackgroundImage: Boolean);
var
	AStream: TStream;
	Imagebuf, RTFHead, ImageHead: string;
	I, AScaleX, AScaleY: Integer;
	Bmp: TBitmap;
begin
	// Image encoded as BMP/JPEG, based on ExportImageFormat.
	Imagebuf := '';
	RTFHead := '';
	Bmp := TBitmap.Create;
	Bmp.PixelFormat := ImagePixelFormat;
	if (ImageDPI <> -1) and not IsBackgroundImage then
	begin
		try
			Bmp.Width := Round(AWidth / CPixelsPerInch * ImageDPI);
			Bmp.Height := Round(AHeight / CPixelsPerInch * ImageDPI);
      gtStretchDraw(AGraphic, Bmp);
		except
			on E: Exception do
			begin
				DoErrorMessage(E.Message);
				CancelExport;
				Exit;
			end;
		end;
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
	AScaleX := Round(AWidth / Bmp.Width * 100);
	AScaleY := Round(AHeight / Bmp.Height * 100);
	if ExportImageFormat <> ifBMP then   			// If JPEG.
	begin
		AStream := GetBitmapAsJpgGifStream(Bmp, ifJPG, JPEGQuality);
		AStream.Position := 0;
	end
	else																			// If BMP.
	begin
		// Prepend metafile header to bitmap and save to stream.
		AStream := TMemoryStream.Create;
		Bmp.SaveToStream(AStream);
		AStream.Position := 2;
		AStream.Read(I, 4);
		I := I div 2 + 7;
		ImageHead := '010009000003'	+ RevHexBytes(IntToHex(I + $24, 8)) + '0000' +
			RevHexBytes(IntToHex(I, 8)) + '0000050000000b0200000000050000000c02' +
			RevHexBytes(IntToHex(Bmp.Height, 4)) +
			RevHexBytes(IntToHex(Bmp.Width, 4)) +
			'05000000090200000000050000000102ffffff000400000007010300' +
			RevHexBytes(IntToHex(I, 8)) + '430f2000cc000000' +
			RevHexBytes(IntToHex(Bmp.Height, 4)) +
			RevHexBytes(IntToHex(Bmp.Width, 4)) + '00000000' +
			RevHexBytes(IntToHex(Bmp.Height , 4)) +
			RevHexBytes(IntToHex(Bmp.Width, 4)) + '00000000' + CRLF;
		AStream.Position := AStream.Position + 8;
	end;
	try
		with AStream as TMemoryStream do
		begin
			SetLength(Imagebuf, Size - Position);
			Read(Imagebuf[1], Size - Position);
		end;

		RTFHead := '{\pict' + PictureType[TgtRPImageFormat(ExportImageFormat)];
		if IsBackgroundImage then
			RTFHead := RTFHead + '\picwgoal' + NumToStr(GetNativePos(Bmp.Width)) +
				'\pichgoal' + NumToStr(GetNativePos(Bmp.Height))
		else
    begin
    	RTFHead := RTFHead + '\picw' + NumToStr(AWidth * 26.46875) +
        '\pich' + NumToStr(AHeight * 26.46875) +
        '\picwgoal' + NumToStr(GetNativePos(Bmp.Width)) +
        '\pichgoal' + NumToStr(GetNativePos(Bmp.Height)) +
        '\picscalex' + NumToStr(AScaleX) +
        '\picscaley' + NumToStr(AScaleY);
    end;
		RTFHead := RTFHead + '\picbmp\picbpp4 ' + CRLF;
		if FGraphicDataInBinary and (ExportImageFormat <> ifBMP) then
			RTFHead := RTFHead + '\bin' + IntToStr(Length(Imagebuf)) + ' '
					+ Imagebuf + '}'
		else
			RTFHead := RTFHead + ImageHead + GetBinHex(Imagebuf)
				+ '030000000000' + '}';

		RTFHead := '{\*\do\dobxpage\dobypage'	+
			'\dptxbx{\dptxbxtext' +
			'\dpx'+ NumToStr(PosX) +
			'\dpy'+ NumToStr(PosY) +
			'\dpxsize' + NumToStr(GetNativePos(AWidth)) +
			'\dpysize' + NumToStr(GetNativePos(AHeight)) +
			'\dplinehollow{\lang1024 ' + RTFHead + '}}}';

		if IsBackgroundImage then
			RTFHead := '{\header' + RTFHead + '}';
	finally
		WriteToTempStream(RTFHead);
		AStream.Free;
		Bmp.Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.EncodeRect(const pfX1, pfY1, pfX2, pfY2: Double;
	ARectType: string);
var
	S: string;
	ALeft, ATop, AWidth, AHeight: Integer;
begin
	// Encode rectangle, based on ARectType (Rectangle, FillRect or RoundRect).
	ALeft := InchesToTwips(pfx1);
	ATop := InchesToTwips(pfY1);
	AWidth := (InchesToTwips(pfX2) - ALeft);
	AHeight := (InchesToTwips(pfY2) - ATop);
	if AWidth < 0 then
	begin
		AWidth := Abs(AWidth);
		ALeft := ALeft - AWidth;
	end;
	if AHeight < 0 then
	begin
		AHeight := Abs(AHeight);
		ATop := ATop - AHeight;
	end;
	S := '{\*\do\dobxpage\dobypage' + ARectType +
		'\dpx'+ NumToStr(ALeft) +
		'\dpy'+ NumToStr(ATop) +
		'\dpxsize' + NumToStr(AWidth + 1) +
		'\dpysize' + NumToStr(AHeight + 1) +
		GetLineStyle + GetShadeAttrib + GetLineAttrib + CRLF;

	S := '{\lang1024 ' + S + '}}';
	WriteToTempStream(S);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.SetBackgroundDisplay(
	Value: TgtRPBackgroundDisplayType);
begin
	// All supported except tiling
	if Value <> dtTile then
		inherited BackgroundImageDisplayType := Value
	else
		DoErrorMessage(sUnsupportedBackgroundDisplayType);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.SetExportImageFormat(Value: TgtRPImageFormat);
begin
	// All supported except GIF.
	if Value in [ifJPG, ifBMP] then
		inherited ExportImageFormat := Value
	else
		DoErrorMessage(sUnsupportedRTFImageFormat);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.WriteToTempStream(AText: string);
	procedure HandleOutOfMem;
	var
		AFileName, ATempPath : array[0..MAX_PATH] of char;
	begin
		// Create temporary file on disk and write data in memory to it.
		// Clear memory stream, write S to mem stream and let it go ahead.
		if not FTempFileUsed then
		begin
			GetTempPath(MAX_PATH, ATempPath);
			GetTempFilename(ATempPath, 'gtRR', 0, AFileName);
			FTempFileName := string(AFileName);
			FTempFileStream := TFileStream.Create(FTempFileName,
				fmCreate or fmOpenReadWrite);
		end;
		FTempFileStream.CopyFrom(FTempStream, 0);
		TMemoryStream(FTempStream).Clear;
		FTempStream.Write(Pointer(AText)^, Length(AText));
		FTempFileUsed := True;
	end;

begin
	try
		FTempStream.Write(Pointer(AText)^, Length(AText));
	except
		on EStreamError do HandleOutOfMem;
	end;

end;

{------------------------------------------------------------------------------}

function TgtRPRenderRTF.GetNativeText(const Text: string): string;
begin
	Result := ReplaceString(Text, '\' , '\\');
	Result := ReplaceString(Result, '{' , '\{');
	Result := ReplaceString(Result, '}' , '\}');
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.Arc(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3,
	pfX4, pfY4: Double);
var
	ABmp: TBitmap;
	PosX1, PosY1: Integer;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
	if IncludeNonRectShapes then
	begin
		PosX1 := InchesToTwips(pfX1);
		PosY1 := InchesToTwips(pfY1);
		ABmp := GetArcBitmap(pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4, pfY4);
		try
			EncodeGraphic(ABmp, PosX1, PosY1, ABmp.Width, ABmp.Height, False);
		finally
			ABmp.Free;
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.Chord(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3,
	pfX4, pfY4: Double);
var
	ABmp: TBitmap;
	PosX1, PosY1: Integer;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
	if IncludeNonRectShapes then
	begin
		PosX1 := InchesToTwips(pfX1);
		PosY1 := InchesToTwips(pfY1);
		ABmp := GetChordBitmap(pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4, pfY4);
		try
			EncodeGraphic(ABmp, PosX1, PosY1, ABmp.Width, ABmp.Height, False);
		finally
			ABmp.Free;
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.DocBegin;
begin
	// Initialize on document begin.
	if FExportCanceled then Exit;
	inherited DocBegin;
	FTempStream := TMemoryStream.Create;			// Creating Temporaty Memory Stream.
	FFontTable := TStringList.Create;					// Creating Font Table.
	FColorTable := TStringList.Create;				// Creating Color Table.
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.DocEnd;

	function MakeFontTable: string;
	var
		I: Integer;
	begin
		Result := '';
		for I := 0 to FFontTable.Count - 1 do
			Result := Result + '{\f' + IntToStr(I) + '\fcharset' +
				FFontTable[I] + ';}';
	end;

	function MakeColorTable: string;
	var
		I: Integer;
	begin
		Result := '';
		for I := 0 to FColorTable.Count - 1 do
			Result := Result +
				'\red' + HexToInt(Copy(FColorTable[I], 1, 2)) +
				'\green' + HexToInt(Copy(FColorTable[I], 3, 2)) +
				'\blue' + HexToInt(Copy(FColorTable[I], 5, 2)) + ';';
	end;

var
	S: string;
	LeftMargin, RightMargin, TopMargin, BottomMargin: Integer;
begin
	if FExportCanceled then
	begin
		inherited DocEnd;
		Exit;
	end;

	// On end of document write header and temporary Stream
	// to file or UserStream.
	LeftMargin := InchesToTwips(sMarginLeft);
	TopMargin := InchesToTwips(sTopMargin);
	RightMargin := InchesToTwips(sMarginRight);
	BottomMargin := InchesToTwips(sBottomMargin);
	S := '{\rtf1\ansi\ansicpg' + IntToStr(GetACP) +
		'\deff0\deftab720' +
		'{\fonttbl' + MakeFontTable + '}' +
		'{\colortbl;' + MakeColorTable + '}' +
		'{\info{\title ';
	if Title <> '' then
		S := S + Title + '}'
	else
		S := S + Converter.Title + '}';
	if Subject <> '' then
		S := S + '{\subject ' + Subject + '}' ;
	S := S + '{\author ' + Author + '}' +
		'{\keywords ' + Keywords + '}' +
		'{\doccomm Produced by: Gnostice RaveRender V' + CVersion +
		' for Rave Reports (www.gnostice.com)}' +
		'{\creatim' +
			FormatDateTime('"\yr"yyyy"\mo"m"\dy"d"\hr"h"\min"n', Now) + '}}' +
		'\viewkind1' +
		'\paperw' + NumToStr(FFirstPageWidth) +
    '\paperh' + NumToStr(FFirstPageHeight) +
		'\margl' + NumToStr(LeftMargin) +	'\margr' + NumToStr(RightMargin) +
		'\margt' + NumToStr(TopMargin) + 	'\margb' + NumToStr(BottomMargin);

	//if poLandscape then    			// Need to know Report Orientation
	//S := S + '\landscape';			// to enable this

	S := S + '\headery0\footery0';
	S := S + WriteBackgroundImage + CRLF;
	// Create file, write header & content.
	with FOwnedStream do
	begin
		// Header.
		Write(Pointer(S)^, Length(S));
		// If Temp file was used, first copy its contents.
		if FTempFileUsed then
		begin
			CopyFrom(FTempFileStream, 0);
			FTempFileStream.Free;
			CheckAndDeleteFile(FTempFileName);
		end;
		// Copy document from memory stream.
		CopyFrom(FTempStream, 0);
		// Closing char.
		S := '}}';
		Write(Pointer(S)^, Length(S));
	end;
	FFontTable.Free;
	FColorTable.Free;
	FTempStream.Free;
	FFontTable := nil;
	FColorTable := nil;
	FTempStream := nil;
	// Copy contents to UserStream if requested.
	if OutputToUserStream then
		FUserStream.LoadFromStream(FOwnedStream);
	FOwnedStream.Free;
	FOwnedStream := nil;
	inherited DocEnd;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.Draw(const pfX1, pfY1: Double; AGraphic: TGraphic);
var
	ABmp: TBitmap;
	PosX1, PosY1: Integer;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
	if IncludeImages then
	begin
		ABmp := TBitmap.Create;
		try
			ABmp.Height := AGraphic.Height;
			ABmp.Width := AGraphic.Width;
			ABmp.Canvas.Draw(0, 0, AGraphic);
			PosX1 := InchesToTwips(pfX1);
			PosY1 := InchesToTwips(pfY1);
			EncodeGraphic(ABmp, PosX1, PosY1, ABmp.Width, ABmp.Height, False);
		finally
			ABmp.Free;
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.EndText;
var
	ATextDetails: TgtRPTextDetails;
	I: Integer;
begin
	if FTextList.Count = 0 then Exit;
	for I := 0 to FTextList.Count - 1 do
	begin
		ATextDetails := TgtRPTextDetails(FTextList.Items[I]);
		EncodeText(ATextDetails);
	end;
	ClearTextList;
	FProcessingText := False;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.Ellipse(const pfX1, pfY1, pfX2, pfY2: Double);
var
	S: string;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
	if IncludeNonRectShapes then
	begin
		S := CRLF + '{\*\do\dobxpage\dobypage\dpellipse'
			+ '\dpx'+ NumToStr(InchesToTwips(pfx1))
			+ '\dpy'+ NumToStr(InchesToTwips(pfY1))
			+ '\dpxsize' + NumToStr(InchesToTwips(pfX2 - pfX1) + 1)
			+ '\dpysize' + NumToStr(InchesToTwips(pfY2 - pfY1) + 1)
			+ GetLineStyle + GetLineAttrib + GetShadeAttrib + CRLF;

		S := '{\lang1024 ' + S + '}}';
		WriteToTempStream(S);
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.FillRect(const pRect: TRect);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
	if IncludeLines then
		EncodeRect(pRect.Left / 72, pRect.Top / 72, pRect.Right / 72,
			pRect.Bottom / 72, '\dprect');
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.LineTo(const pfX1, pfY1: Double);
var
	S: string;
	ALeft, ATop, ARight, ABottom, AWidth, AHeight: Integer;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
	if IncludeLines then
	begin
		ALeft := InchesToTwips(FCurrentX);
		ARight := InchesToTwips(pfX1);
		ATop := InchesToTwips(Min(pfY1, FCurrentY));
		ABottom := InchesToTwips(Max(pfY1, FCurrentY));
		AWidth := ARight - ALeft;
		AHeight := ABottom - ATop;
		if pfy1 < FCurrentY then
			S := '\dpptx' + NumToStr(AWidth) +
				'\dppty0\dpptx0' + '\dppty' + NumToStr(AHeight)
		else
			S := '\dpptx0\dppty0' +
				'\dpptx' + NumToStr(AWidth) +
				'\dppty' + NumToStr(AHeight);

		S := '{\*\do\dobxpage\dobypage\dpline' + S + '\dpx';

		if AWidth < 0 then
			S := S + NumToStr(ALeft + AWidth)
		else
			S := S + NumToStr(ALeft);

		S := S + '\dpy' + NumToStr(ATop)
			+ '\dpxsize' + NumToStr(Abs(AWidth) + 1)
			+ '\dpysize' + NumToStr(Abs(AHeight) + 1)
			+ GetLineStyle + GetLineAttrib + '}' + CRLF;

		WriteToTempStream(S);
	end;
end;

{------------------------------------------------------------------------------}

{$IFDEF Rave407Up}

procedure TgtRPRenderRTF.PolyLine(const PolyLineArr: array of
  {$IFDEF Rave50Up} TFloatPoint {$ELSE} TPoint {$ENDIF});
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
	if IncludeNonRectShapes then
		EncodePolyLine(PolyLineArr, False);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.Polygon(const PolyLineArr: array of
  {$IFDEF Rave50Up} TFloatPoint {$ELSE} TPoint {$ENDIF});
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
	if IncludeNonRectShapes then
		EncodePolyLine(PolyLineArr, True);
end;

{$ENDIF}

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.Pie(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3,
	pfX4, pfY4: Double);
var
	ABmp: TBitmap;
	PosX1, PosY1: Integer;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
	if IncludeNonRectShapes then
	begin
		PosX1 := InchesToTwips(pfX1);
		PosY1 := InchesToTwips(pfY1);
		ABmp := GetPieBitmap(pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4, pfY4);
		try
			EncodeGraphic(ABmp, PosX1, PosY1, ABmp.Width, ABmp.Height, False);
		finally
			ABmp.Free;
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.PageBegin;
var
	S: string;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	inherited PageBegin;
  if Converter.PageNo = 1 then
  begin
  	FFirstPageWidth := InchesToTwips(PaperWidth);
  	FFirstPageHeight := InchesToTwips(PaperHeight);
	end;
  if (Converter.PageCount > 1) and (Converter.PageNo > 1) then
  begin
    S := '\sect\sectd';
    {$IFDEF Rave50Up}
    if Converter.ReportHeader.Orientation = poLandscape then
      S := S + '\lndscpsxn';
		{$ENDIF}
    S := S + '\pgwsxn' + NumToStr(InchesToTwips(PaperWidth)) +
      '\pghsxn' + NumToStr(InchesToTwips(PaperHeight)) +
      '\margrsxn' + NumToStr(InchesToTwips(sMarginRight)) +
      '\sectdefaultcl ';
    WriteToTempStream(S);
  end;
	S := '{';
	WriteToTempStream(S);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.PageEnd;
var
	S: string;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
  S := '\par}' + CRLF;
	WriteToTempStream(S);
	inherited PageEnd;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.PrintBitmapRect(const X1, Y1, X2, Y2: Double;
	AGraphic: Graphics.TBitmap);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if IncludeImages then
	begin
    EncodeGraphic(AGraphic, InchesToTwips(Abs(X1)), InchesToTwips(Abs(Y1)),
      Round(Abs(X2 - X1) * cPixelsPerInch),
      Round(Abs(Y2 - Y1) * cPixelsPerInch), False);
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.PrintBitmap(const X1, Y1, ScaleX, ScaleY: Double;
	AGraphic: Graphics.TBitmap);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if IncludeImages then
	begin
    EncodeGraphic(AGraphic, Round(X1), Round(Y1),
      Round(AGraphic.Width * ScaleX * cPixelsPerInch),
      Round(AGraphic.Height * ScaleY * cPixelsPerInch), False);
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.Rectangle(const pfX1, pfY1, pfX2, pfY2: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
	if IncludeLines then
		EncodeRect(pfX1, pfY1, pfX2, pfY2, '\dprect');
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.RoundRect(const pfX1, pfY1, pfX2, pfY2,
	pfX3, pfY3: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
	if IncludeLines then
		EncodeRect(pfX1, pfY1, pfX2, pfY2, '\dprect\dproundr');
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.StretchDraw(const pRect: TRect; AGraphic: TGraphic);
var
	PosX1, PosY1: Integer;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
	if IncludeImages then
	begin
		PosX1 := GetNativePos(pRect.Left / 72 * cPixelsPerInch);
		PosY1 := GetNativePos(pRect.Top / 72 * cPixelsPerInch);
		EncodeGraphic(AGraphic, PosX1, PosY1,
			Round(Abs(pRect.Right - pRect.Left) / 72 * cPixelsPerInch),
			Round(Abs(pRect.Bottom - pRect.Top) / 72 * cPixelsPerInch), False);
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTF.TextRect(Rect: TRect; X1, Y1: Double; S1: string);
var
	ATextDetails: TgtRPTextDetails;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
	ATextDetails := TgtRPTextDetails.Create;			 // Encoding Text
	with ATextDetails do
	try
		FText := S1;
		FFont.Charset := Converter.Font.Charset;
		FFont.Name := Converter.Font.Name;
		FFont.Pitch := Converter.Font.Pitch;
		FFont.Size := Converter.Font.Size;
		FFont.Color := Converter.Font.Color;
		FFont.Style := Converter.Font.Style;
		FTextAlign := tpAlignLeft;
		FTextWidth := (Rect.Right - Rect.Left) * 72;
  {$IFDEF Rave50Up}
      FTextHeight := Converter.FontData.Height * cPixelsPerInch;
  {$ELSE}
      FTextHeight := Converter.FontHeight * cPixelsPerInch;
  {$ENDIF}
		FX := X1 * cPixelsPerInch;
		FY := Y1 * cPixelsPerInch;
  {$IFDEF Rave50Up}
		FFontRotation := Converter.FontData.Rotation;
  {$ELSE}
		FFontRotation := Converter.FontRotation;
  {$ENDIF}
		EncodeText(ATextDetails);
	finally
		Free;
	end;
end;

{------------------------------------------------------------------------------}

// Creates and shows setup dialog.
function TgtRPRenderRTF.ShowSetupModal: Word;
begin
	with TgtRPRenderRTFDlg.Create(nil) do
	try
		RenderObject := Self;
		Application.ProcessMessages;
		Result := ShowModal;
	finally
		Free;
	end;
end;

{------------------------------------------------------------------------------}

// Create FileStream and begin render.

{$IFDEF Rave50Up}
procedure TgtRPRenderRTF.RenderPage(PageNum: integer);
begin
	inherited Renderpage(PageNum);
	if not FExportCanceled then
	begin
		try
			if FUserStream = nil then
				FOutputToUserStream := False;
			if not OutputToUserStream then
				InitFileStream(ReportFileNames.Strings[0])
			else
				FOwnedStream := TMemoryStream.Create;
		except
			CancelExport;
			DoErrorMessage(sCreateFileError);
			Exit;
		end;
		with TRPConverter.Create(NDRStream, self) do
		try
			Generate;
		finally
			Free;
		end;
	end;
end;

{$ELSE}

procedure TgtRPRenderRTF.PrintRender(NDRStream: TStream;
	OutputFileName: TFileName);
begin
	inherited PrintRender(NDRStream, OutputFileName);
	if not FExportCanceled then
	begin
		try
			if FUserStream = nil then
				FOutputToUserStream := False;
			if not OutputToUserStream then
				InitFileStream(ReportFileNames.Strings[0])
			else
				FOwnedStream := TMemoryStream.Create;
		except
			CancelExport;
			DoErrorMessage(sCreateFileError);
			Exit;
		end;
		with TRPConverter.Create(NDRStream, self) do
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
