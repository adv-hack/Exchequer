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

unit gtRPRender_Document;

interface

uses
	SysUtils, Windows, Messages, Classes, Graphics, Forms, Dialogs, StdCtrls,
	Controls, gtRPRender_Main, gtRPRender_Consts, gtRPRender_Utils, jpeg
	{$IFDEF GIFByRx}
		, RxGIF
	{$ELSE}
		{$IFDEF GIFByAM}
			, GIFImage
		{$ENDIF}
	{$ENDIF};

type

{ TgtRPTextDetails class }

	// Class for storing Text Details
	TgtRPTextDetails = class(TObject)
	public
		FText: string;
		FFont: TgtRPFontAttrib;
		FTextAlign: TgtRPTextProperty;
		FTextWidth: Double;
		FTextHeight: Double;
		FX: Double;
		FY: Double;
		FFontRotation: Integer;
		constructor Create;
	end;

{ TgtRPRenderDocument class }

	// Main Document render class, derived from TgtRPRender
	// Base class for all Document renders
	TgtRPRenderDocument = class(TgtRPRender)
	private
		FAuthor: string;
		FCreator: string;
		FExportImageFormat: TgtRPImageFormat;
		FImageDPI: Integer;
		FImagePixelFormat: TPixelFormat;
		FIncludeImages: Boolean;
		FIncludeLines: Boolean;
		FIncludeNonRectShapes: Boolean;
		FJPEGQuality: TJPEGQualityRange;
		FKeywords: string;
		FSubject: string;
		FTitle: string;

		function IsCreatorStored: Boolean;

		procedure SetExportImageFormat(Value: TgtRPImageFormat);
		procedure AddTextDetails(ATextDetails: TgtRPTextDetails;
			PosX, PosY: Double);

	protected
		FTextList: TList;
//		FGreatestTextWidth: Double;

		function GetArcBitmap(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Extended): TBitmap;
		function GetBitmapAsJpgGifStream(Bmp: TBitmap; ImgFormat: TgtRPImageFormat;
			JPEGQuality: TJPEGQualityRange): TStream;
		function GetChordBitmap(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Extended): TBitmap;
		function GetEllipseBitmap(X1, Y1, X2, Y2: Extended): TBitmap;
		function GetLineBitmap(X1, Y1, X2, Y2: Extended): TBitmap;
		function GetNativeText(const Text: string): string; virtual;
		function GetPieBitmap(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Extended): TBitmap;
		function GetRoundRectBitmap(X1, Y1, X2, Y2, X3, Y3: Extended): TBitmap;
		function NumToStr(N: Extended): string; virtual;
		function SaveBitmapAs(Bmp: TBitmap; ImgFormat: TgtRPImageFormat;
			JPEGQuality: TJPEGQualityRange; const BaseName: string): string;

{$IFDEF Rave50Up}
    procedure BrushChanged(Sender: TObject); override;
{$ELSE}
		procedure BrushChanged; override;
{$ENDIF}
		procedure CenterText(const psText: string;
			const pfX, pfY: Double); override;
		procedure ClearTextList;
		procedure DocBegin; override;
		procedure DocEnd; override;
		procedure EndText; virtual;
{$IFDEF Rave50Up}
    procedure FontChanged(Sender: TObject); override;
{$ELSE}
		procedure FontChanged; override;
{$ENDIF}
		procedure InsertObjectIntoList(FTextDetails: TgtRPTextDetails;
			ATextList: TList);
		procedure LeftText(const psText: string; const pfX, pfY: Double); override;
{$IFDEF Rave50Up}
    procedure PenChanged(Sender: TObject); override;
{$ELSE}
		procedure PenChanged; override;
{$ENDIF}
		procedure PrintSpaces(const psText: string;
			const pfX, pfY, pfWidth: Double); override;
		procedure RightText(const psText: string; const pfX, pfY: Double); override;
		procedure SetFontDetails(ATextDetails: TgtRPTextDetails);

		property Author: string read FAuthor write FAuthor;
		property Creator: string read FCreator write FCreator
			stored IsCreatorStored;
		property ExportImageFormat: TgtRPImageFormat read FExportImageFormat
			write SetExportImageFormat default ifJPG;
		property ImageDPI: Integer read FImageDPI write FImageDPI default -1;
		property ImagePixelFormat: TPixelFormat read FImagePixelFormat
			write FImagePixelFormat default pf24bit;
		property IncludeImages: Boolean read FIncludeImages write FIncludeImages
			default True;
		property IncludeLines: Boolean read FIncludeLines write FIncludeLines
			default True;
		property IncludeNonRectShapes: Boolean read FIncludeNonRectShapes
			write FIncludeNonRectShapes default True;
		property JPEGQuality: TJPEGQualityRange read FJPEGQuality
			write FJPEGQuality default High(TJPEGQualityRange);
		property Keywords: string read FKeywords write FKeywords;
		property Subject: string read FSubject write FSubject;
		property Title: string read FTitle write FTitle;

	public
		constructor Create(AOwner: TComponent); override;

	end;

implementation

uses RpDefine, RpRender;

{------------------------------------------------------------------------------}
{ TgtRPTextDetails }
{------------------------------------------------------------------------------}

constructor TgtRPTextDetails.Create;
begin
	inherited Create;
end;

{------------------------------------------------------------------------------}
{ TgtRPRenderDocument }
{------------------------------------------------------------------------------}

constructor TgtRPRenderDocument.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
	FCreator := sCreatorName;
	FIncludeLines := True;
	FIncludeNonRectShapes := True;
	FIncludeImages := True;
	FExportImageFormat := ifJPG;
	FImageDPI := -1;
	FImagePixelFormat := pf24bit;
	FJPEGQuality := 100;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderDocument.IsCreatorStored: Boolean;
begin
	Result := FCreator <> sCreatorName;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderDocument.SetExportImageFormat(Value: TgtRPImageFormat);
begin
	FExportImageFormat := Value;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderDocument.AddTextDetails(ATextDetails: TgtRPTextDetails;
	PosX, PosY: Double);
begin
	if FTextList.Count > 0 then
		with TgtRPTextDetails(FTextList.Items[FTextList.Count - 1]) do
			if FProcessingText and ((FTextAlign <> ATextDetails.FTextAlign) or
					(ATextDetails.FY > (FY + (FTextHeight * 1.5))) or
					(FCurrentX <> PosX)) then
				EndText;
//	if FGreatestTextWidth < ATextDetails.FTextWidth then
//		FGreatestTextWidth := ATextDetails.FTextWidth;
	FCurrentX := PosX;
	FCurrentY := PosY;
	FProcessingText := True;
	FTextList.Add(ATextDetails);
end;

{------------------------------------------------------------------------------}

function TgtRPRenderDocument.GetArcBitmap(
	X1, Y1, X2, Y2, X3, Y3, X4, Y4: Extended): TBitmap;
begin
	Result := TBitmap.Create;
	with Result do
	begin
		Canvas.Pen.Assign(Converter.Pen);
		Width := Round(Abs(X2 - X1) * cPixelsPerInch);
		Height := Round(Abs(Y2 - Y1) * cPixelsPerInch);
		Transparent := True;
		Canvas.Arc(0, 0, Width, Height,
			Round((X3 - X1) * cPixelsPerInch), Round((Y3 - Y1) * cPixelsPerInch),
			Round((X4 - X1) * cPixelsPerInch), Round((Y4 - Y1) * cPixelsPerInch));
	end;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderDocument.GetBitmapAsJpgGifStream(Bmp: TBitmap;
	ImgFormat: TgtRPImageFormat; JPEGQuality: TJPEGQualityRange): TStream;
var
	Img: TGraphic;
begin
	case ImgFormat of
		ifGIF:
{$IFDEF GIFSupport}
			Img := TGIFImage.Create;
{$ELSE}
			Img := TJPEGImage.Create;
{$ENDIF}
		ifJPG:
			Img := TJPEGImage.Create;
	else
		Img := TJPEGImage.Create;
	end;

	Result := TMemoryStream.Create;
	try
		if Img is TJPEGImage then
			TJPEGImage(Img).CompressionQuality := JPEGQuality;
		Img.Assign(Bmp);
		Img.SaveToStream(Result);
	finally
		Img.Free;
	end;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderDocument.GetChordBitmap(
	X1, Y1, X2, Y2, X3, Y3, X4, Y4: Extended): TBitmap;
begin
	Result := TBitmap.Create;
	with Result do
	begin
		Canvas.Pen.Assign(Converter.Pen);
		Width := Round(Abs(X2 - X1) * cPixelsPerInch);
		Height := Round(Abs(Y2 - Y1) * cPixelsPerInch);
		Transparent := True;
		Canvas.Brush.Assign(Converter.Brush);
		Canvas.Chord(0, 0, Width, Height,
			Round((X3 - X1) * cPixelsPerInch), Round((Y3 - Y1) * cPixelsPerInch),
			Round((X4 - X1) * cPixelsPerInch), Round((Y4 - Y1)  * cPixelsPerInch));
	end;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderDocument.GetEllipseBitmap(
	X1, Y1, X2, Y2: Extended): TBitmap;
begin
	Result := TBitmap.Create;
	with Result do
	begin
		Canvas.Pen.Assign(Converter.Pen);
		Width := Round(Abs(X2 - X1) * cPixelsPerInch);
		Height := Round(Abs(Y2 - Y1) * cPixelsPerInch);
		Transparent := True;
		Canvas.Brush.Assign(Converter.Brush);
		Canvas.Ellipse(0, 0, Width, Height);
	end;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderDocument.GetLineBitmap(X1, Y1, X2, Y2: Extended): TBitmap;
var
	X, Y: Integer;
begin
	Result := TBitmap.Create;
	with Result do
	begin
		Canvas.Pen.Assign(Converter.Pen);
		Width := Round(Abs(X2 - X1) * cPixelsPerInch);
		Height := Round(Abs(Y2 - Y1) * cPixelsPerInch);
		Transparent := True;
		if X1 > X2 then
			X := Width
		else
			X := 0;
		if Y1 > Y2 then
			Y := Height
		else
			Y := 0;
		Canvas.MoveTo(X, Y);
		Canvas.LineTo(Width - X, Height - Y);
	end;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderDocument.GetNativeText(const Text: string): string;
begin
	// No conversion here.
	// Descendants need not override the method if no conversion is required.
	Result := Text;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderDocument.GetPieBitmap(
	X1, Y1, X2, Y2, X3, Y3, X4, Y4: Extended): TBitmap;
begin
	Result := TBitmap.Create;
	with Result do
	begin
		Canvas.Pen.Assign(Converter.Pen);
		Width := Round(Abs(X2 - X1) * cPixelsPerInch);
		Height := Round(Abs(Y2 - Y1) * cPixelsPerInch);
		Transparent := True;
		Canvas.Brush.Assign(Converter.Brush);
		Canvas.Pie(0, 0, Width, Height,
			Round((X3 - X1) * cPixelsPerInch), Round((Y3 - Y1) * cPixelsPerInch),
			Round((X4 - X1) * cPixelsPerInch), Round((Y4 - Y1) * cPixelsPerInch));
	end;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderDocument.GetRoundRectBitmap(
	X1, Y1, X2, Y2, X3, Y3: Extended): TBitmap;
begin
	Result := TBitmap.Create;
	with Result do
	begin
		Canvas.Pen.Assign(Converter.Pen);
		Width := Round(Abs(X2 - X1) * cPixelsPerInch);
		Height := Round(Abs(Y2 - Y1) * cPixelsPerInch);
		Transparent := True;
		Canvas.Brush.Assign(Converter.Brush);
		Canvas.RoundRect(0, 0, Width, Height,
			Round(X3 * cPixelsPerInch), Round(Y3 * cPixelsPerInch));
	end;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderDocument.NumToStr(N: Extended): string;
begin
	Result := IntToStr(Round(N)); // get numbers in native string format
end;

{------------------------------------------------------------------------------}

function TgtRPRenderDocument.SaveBitmapAs(Bmp: TBitmap;
	ImgFormat: TgtRPImageFormat; JPEGQuality: TJPEGQualityRange;
	const BaseName: string): string;
var
	DestStream: TStream;
	Img: TGraphic;

	procedure SaveJpgGif(const AFileName: string);
	begin
		DestStream := TFileStream.Create(AFileName, fmCreate);
		try
			Img.Assign(Bmp);
			Img.SaveToStream(DestStream);
		finally
			DestStream.Free;
			Img.Free;
		end;
	end;

begin
	Result := BaseName;
	case ImgFormat of
		ifBMP:
		begin
			Result := Result + '.bmp';
			Bmp.SaveToFile(Result);
		end;
		ifGIF:
		begin
{$IFDEF GIFSupport}
			Result := Result + '.gif';
			Img := TGIFImage.Create;
{$ELSE}
			Result := Result + '.jpg';
			Img := TJPEGImage.Create;
{$ENDIF}
			SaveJpgGif(Result);
		end;
		ifJPG:
		begin
			Result := Result + '.jpg';
			Img := TJPEGImage.Create;
			TJPEGImage(Img).CompressionQuality := JPEGQuality;
			SaveJpgGif(Result);
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderDocument.BrushChanged;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderDocument.CenterText(const psText: string;
	const pfX, pfY: Double);
var
	FTextDetails: TgtRPTextDetails;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	FTextDetails := TgtRPTextDetails.Create;
	with FTextDetails do
	begin
		FText := psText;
		FTextWidth := GetTextSize(Converter.Font, psText).cx;

{$IFDEF Rave50Up}
		FTextHeight := Converter.FontData.Height * cPixelsPerInch;
{$ELSE}
		FTextHeight := Converter.FontHeight * cPixelsPerInch;
{$ENDIF}
		FX := (pfX * cPixelsPerInch) - (FTextWidth / 2);
		FY := pfY * cPixelsPerInch;
		FTextAlign := tpAlignCenter;
		SetFontDetails(FTextDetails);
	end;
	AddTextDetails(FTextDetails, pfX, pfY);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderDocument.ClearTextList;
var
	I: Integer;
	P: TgtRPTextDetails;
begin
	if FTextList = nil then Exit;
	for I := 0 to FTextList.Count - 1 do
	begin
		Application.ProcessMessages;
		P := FTextList.Items[I];
		if P <> nil then
			P.Free;
	end;
	FTextList.Clear;
//	FGreatestTextWidth := 0;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderDocument.DocBegin;
begin
	if FExportCanceled then Exit;
	inherited DocBegin;

	FTextList := TList.Create;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderDocument.DocEnd;
begin
	ClearTextList;
	FTextList.Free;
	inherited DocEnd;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderDocument.EndText;
begin
//
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderDocument.FontChanged;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderDocument.InsertObjectIntoList(
	FTextDetails: TgtRPTextDetails; ATextList: TList);
var
	I: Integer;
	AOldObject: TgtRPTextDetails;
	ACurObject: TgtRPTextDetails;
begin
	with ATextList do
	begin
		I := Count - 1;
		ACurObject := TgtRPTextDetails.Create;
		with ACurObject do
		begin
			FText := FTextDetails.FText;
			FFont.Charset := FTextDetails.FFont.Charset;
			FFont.Name := FTextDetails.FFont.Name;
			FFont.Pitch := FTextDetails.FFont.Pitch;
			FFont.Size := FTextDetails.FFont.Size;
			FFont.Color := FTextDetails.FFont.Color;
			FFont.Style := FTextDetails.FFont.Style;
			FTextAlign := FTextDetails.FTextAlign;
			FTextWidth := FTextDetails.FTextWidth;
			FTextHeight := FTextDetails.FTextHeight;
			FX := FTextDetails.FX;
			FY := FTextDetails.FY;
			FFontRotation := FTextDetails.FFontRotation;
		end;
		// Insert new rec at point such that TextObjs sort by
		// increasing order of Y and X
		while I >= 0 do
		begin
			AOldObject := Items[I];
			if (ACurObject.FY > AOldObject.FY) or
					((ACurObject.FY = AOldObject.FY) and
					(ACurObject.FX >= AOldObject.FX)) then
				Break;
			Dec(I);
		end;
		if I = Count - 1 then
			Add(ACurObject)
		else
			Insert(I + 1, ACurObject);
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderDocument.LeftText(const psText: string;
	const pfX, pfY: Double);
var
	FTextDetails: TgtRPTextDetails;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	FTextDetails := TgtRPTextDetails.Create;
	with FTextDetails do
	begin
		FText := psText;
		FTextWidth := GetTextSize(Converter.Font, psText).cx;
{$IFDEF Rave50Up}
		FTextHeight := Converter.FontData.Height * cPixelsPerInch;
{$ELSE}
		FTextHeight := Converter.FontHeight * cPixelsPerInch;
{$ENDIF}
		FX := pfX * cPixelsPerInch;
		FY := pfY * cPixelsPerInch;
		FTextAlign := tpAlignLeft;
		SetFontDetails(FTextDetails);
	end;
	AddTextDetails(FTextDetails, pfX, pfY);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderDocument.PenChanged;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderDocument.PrintSpaces(const psText: string;
	const pfX, pfY, pfWidth: Double);
var
	FTextDetails: TgtRPTextDetails;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	FTextDetails := TgtRPTextDetails.Create;
	with FTextDetails do
	begin
		FText := psText;
		FTextWidth := pfWidth * cPixelsPerInch;
{$IFDEF Rave50Up}
		FTextHeight := Converter.FontData.Height * cPixelsPerInch;
{$ELSE}
		FTextHeight := Converter.FontHeight * cPixelsPerInch;
{$ENDIF}
		FX := pfX * cPixelsPerInch;
		FY := pfY * cPixelsPerInch;
		FTextAlign := tpAlignJustify;
		SetFontDetails(FTextDetails);
	end;
	AddTextDetails(FTextDetails, pfX, pfY);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderDocument.RightText(const psText: string;
	const pfX, pfY: Double);
var
	FTextDetails: TgtRPTextDetails;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	FTextDetails := TgtRPTextDetails.Create;
	with FTextDetails do
	begin
		FText := psText;
		FTextWidth := GetTextSize(Converter.Font, psText).cx;
{$IFDEF Rave50Up}
		FTextHeight := Converter.FontData.Height * cPixelsPerInch;
{$ELSE}
		FTextHeight := Converter.FontHeight * cPixelsPerInch;
{$ENDIF}
		FX := (pfX * cPixelsPerInch) - FTextWidth;
		FY := pfY * cPixelsPerInch;
		FTextAlign := tpAlignRight;
		SetFontDetails(FTextDetails);
	end;
	AddTextDetails(FTextDetails, pfX, pfY);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderDocument.SetFontDetails(ATextDetails: TgtRPTextDetails);
begin
	with ATextDetails, Converter do
	begin
		FFont.Charset := Font.Charset;
		FFont.Name := Font.Name;
		FFont.Pitch := Font.Pitch;
		FFont.Size := Abs(Font.Size);
		FFont.Color := Font.Color;
		FFont.Style := Font.Style;
{$IFDEF Rave50Up}
    FFontRotation := FontData.Rotation;
{$ELSE}
		FFontRotation := FontRotation;
{$ENDIF}
		// FFontRotation should be in [0..359].
		while FFontRotation < 0 do
			FFontRotation := FFontRotation + 360;
		while FFontRotation >= 360 do
			FFontRotation := FFontRotation - 360;
	end;
end;

{------------------------------------------------------------------------------}

end.
