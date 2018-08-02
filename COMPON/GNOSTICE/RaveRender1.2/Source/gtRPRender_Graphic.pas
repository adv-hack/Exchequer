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

unit gtRPRender_Graphic;

interface

uses
	SysUtils, Windows, Messages, Classes, Graphics, Forms, Dialogs, StdCtrls,
	Controls, gtRPRender_Main, gtRPRender_Consts, gtRPRender_Utils, RPRender;

type

{ TgtRPRenderGraphic class }

	// Main Graphic Render class. All Graphic Render classes derive from
	// TgtRPRenderGraphic
	TgtRPRenderGraphic = class(TgtRPRender)
	private
		FScaleX,
		FScaleY: Double;
		FPolyArray: array of TPoint;

		function GetBackgroundImage: TBitmap;
		function SetFontDetails: TgtRPFontAttrib;

		procedure DoTile(ABitmap: TBitmap);
		procedure RenderBitmap(X1, Y1, AHeight, AWidth: Integer;
			AGraphic: TGraphic; AStretched: Boolean);

	protected
		FBitmap: TBitmap;

		function GetNativePos(APos: Extended): Integer;
		function StorePage(ABitmap: TBitmap): TBitmap;

		procedure AssignPolyArray(APolyArray: array of {$IFDEF Rave50Up}
			TFloatPoint {$ELSE} TPoint {$ENDIF});
		procedure PageBegin; override;
		procedure PageEnd; override;

	public
		constructor Create(AOwner: TComponent); override;

		procedure Arc(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4,
			pfY4: Double); override;
		procedure Chord(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4,
			pfY4: Double); override;
		procedure CenterText(const psText: string; const pfX,
			pfY: Double); override;
		procedure Draw(const pfX1, pfY1: Double; AGraphic: TGraphic); override;
		procedure Ellipse(const pfX1, pfY1, pfX2, pfY2: Double); override;
		procedure FillRect(const pRect: TRect); override;
		procedure LeftText(const psText: string; const pfX, pfY: Double); override;
		procedure LineTo(const pfX1, pfY1: Double); override;
		procedure MoveTo(const pfX1, pfY1: Double); override;
		procedure Pie(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4,
			pfY4: Double); override;
    {$IFDEF Rave407Up}
		  procedure Polygon(const PolyLineArr: array of {$IFDEF Rave50Up}
      	TFloatPoint {$ELSE} TPoint {$ENDIF}); override;
  		procedure PolyLine(const PolyLineArr: array of {$IFDEF Rave50Up}
      	TFloatPoint {$ELSE} TPoint {$ENDIF}); override;
    {$ENDIF}

		procedure PrintBitmapRect(const X1,Y1,X2,Y2: Double;
			AGraphic: Graphics.TBitmap); override;
		procedure PrintBitmap(const X1,Y1,ScaleX,ScaleY: Double;
			AGraphic: Graphics.TBitmap); override;
		procedure PrintSpaces(const psText: string; const pfX, pfY,
			pfWidth: Double); override;
		procedure Rectangle(const pfX1, pfY1, pfX2, pfY2: Double); override;
		procedure RightText(const psText: string; const pfX, pfY: Double); override;
		procedure StretchDraw(const pRect: TRect; AGraphic: TGraphic); override;
		procedure RoundRect(const pfX1, pfY1, pfX2, pfY2, pfX3,
			pfY3: Double); override;
		procedure TextRect(Rect: TRect; X1,Y1: double; S1: string); override;

	published
		property BackgroundColor;
		property BackgroundImage;
		property BackgroundImageDisplayType;

		property ScaleX: Double read FScaleX  write FScaleX;
		property ScaleY: Double read FScaleY  write FScaleY;

	end;

implementation

{------------------------------------------------------------------------------}
{ TgtRPRenderGraphic }
{------------------------------------------------------------------------------}

constructor TgtRPRenderGraphic.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
	FScaleX := 1;
	FScaleY := 1;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderGraphic.GetBackgroundImage: TBitmap;
begin
	Result := TBitmap.Create;
	with Result do
	begin
		Width := BackgroundImage.Width;
		Height := BackgroundImage.Height;
		Transparent := True;
		Canvas.Draw(0, 0, BackgroundImage.Graphic);
	end
end;

{------------------------------------------------------------------------------}

function TgtRPRenderGraphic.SetFontDetails: TgtRPFontAttrib;
begin
	with Result, Converter do
	begin
		Charset := Font.Charset;
		Name := Font.Name;
		Pitch := Font.Pitch;
		Size := Font.Size;
		Color := Font.Color;
		Style := Font.Style;
	end;
end;

{------------------------------------------------------------------------------}

// Tiles BackgroundImage on to Canvas
procedure TgtRPRenderGraphic.DoTile(ABitmap: TBitmap);
var
	X,
	Y: Integer;
	Height,
	Width: Integer;
begin
	X := 0;
	Y := 0;
	Height := GetNativePos(PaperHeight);
	Width :=  GetNativePos(PaperWidth);
	while (Y < Height) do
	begin
		while (X < Width) do
		begin
			FBitmap.Canvas.Draw(X, Y, ABitmap);
			X := X + ABitmap.Width;
		end;
		X := 0;
		Y := Y + ABitmap.Height;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderGraphic.RenderBitmap(X1, Y1, AHeight, AWidth: Integer;
	AGraphic: TGraphic;	AStretched: Boolean);
var
	BMP: TBitmap;
	R: TRect;
begin
	BMP := TBitmap.Create;
	try
		BMP.Width := AWidth;
		BMP.Height := AHeight;
		BMP.Transparent := True;
		R := Rect(0, 0, AWidth, AHeight);

		if AStretched then
		begin
		{$IFDEF AMResample}
			gtStretchDraw(AGraphic, BMP)
		{$ELSE}
			BMP.Canvas.StretchDraw(R, AGraphic);
		{$ENDIF}
		end
		else
			BMP.Canvas.Draw(0, 0, AGraphic);
		with FBitmap.Canvas do
			Draw(X1, Y1, BMP);
	finally
		BMP.Free;
	end;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderGraphic.GetNativePos(APos: Extended): Integer;
begin
	Result := Round(APos * cPixelsPerInch);
end;

{------------------------------------------------------------------------------}

// Descendant classes call StorePage to get the page as bitmap
function TgtRPRenderGraphic.StorePage(ABitmap: TBitmap): TBitmap;
begin
	Result := TBitmap.Create;
	with Result do
	begin
		Width := GetNativePos(PaperWidth * ScaleX);
		Height := GetNativePos(PaperHeight * ScaleY);
	end;
	gtStretchDraw(ABitmap, Result);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderGraphic.AssignPolyArray(APolyArray: array of
	{$IFDEF Rave50Up}	TFloatPoint {$ELSE} TPoint {$ENDIF});
var
	I: Integer;
begin
	SetLength(FPolyArray, High(APolyArray) - Low(APolyArray) + 1);
	for I := Low(APolyArray) to High(APolyArray) do
	begin
		FPolyArray[I].x := GetNativePos(APolyArray[I].x / FontDPI);
		FPolyArray[I].y := GetNativePos(APolyArray[I].y / FontDPI);
	end;
end;

{------------------------------------------------------------------------------}

// Draws BackgroundImage and fills the Canvas with BackgroundColor
procedure TgtRPRenderGraphic.PageBegin;
var
	PaperHorCenter, PaperVertCenter,
	Top, Left: Integer;
	BMP: TBitmap;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	inherited PageBegin;

	FBitmap := TBitmap.Create;
	with FBitmap do
	begin
		Height := GetNativePos(PaperHeight);
		Width := GetNativePos(PaperWidth);
		Canvas.Brush.Color := BackgroundColor;
		Canvas.Brush.Style := bsSolid;
		Canvas.FillRect(Rect(0, 0, Width, Height));
		TransparentColor := BackgroundColor;
	end;

	if BackgroundImage.Graphic <> nil then
	begin
		Top := 0;
		Left := 0;
		PaperHorCenter := FBitmap.Width div 2;
		PaperVertCenter := FBitmap.Height div 2;

		if BackgroundImageDisplayType in [dtCenterLeft, dtCenter,
				dtCenterRight] then
			Top := PaperVertCenter - BackgroundImage.Height div 2
		else if BackgroundImageDisplayType in [dtBottomLeft, dtBottomCenter,
				dtBottomRight] then
			Top := FBitmap.Height - BackgroundImage.Height;

		if BackgroundImageDisplayType in [dtTopCenter, dtCenter,
				dtBottomCenter] then
			Left := PaperHorCenter - BackgroundImage.Width div 2
		else if BackgroundImageDisplayType in [dtTopRight, dtCenterRight,
				dtBottomRight] then
			Left := FBitmap.Width - BackgroundImage.Width;

		BMP := GetBackgroundImage;
		try
			if BackgroundImageDisplayType = dtTile then
				DoTile(BMP)
			else
				FBitmap.Canvas.Draw(Left, Top, BMP);
		finally
			BMP.Free;
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderGraphic.PageEnd;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	inherited PageEnd;
	FBitmap.Free;
	// Free the OwnedStream created in descendant graphic classes
	FOwnedStream.Free;
	FOwnedStream := nil;
end;

{------------------------------------------------------------------------------}

// Draws Arc on to the Canvas
procedure TgtRPRenderGraphic.Arc(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4,
	pfY4: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	with FBitmap.Canvas do
	begin
		Pen.Assign(Converter.Pen);
		Arc(GetNativePos(pfX1), GetNativePos(pfY1),
			GetNativePos(pfX2), GetNativePos(pfY2),
			GetNativePos(pfX3), GetNativePos(pfY3),
			GetNativePos(pfX4), GetNativePos(pfY4));
	end;
end;

{------------------------------------------------------------------------------}

// Draws Chord on to the Canvas
procedure TgtRPRenderGraphic.Chord(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3,
	pfX4, pfY4: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	with FBitmap.Canvas do
	begin
		Pen.Assign(Converter.Pen);
		Brush.Assign(Converter.Brush);
		Chord(GetNativePos(pfX1), GetNativePos(pfY1),
			GetNativePos(pfX2), GetNativePos(pfY2),
			GetNativePos(pfX3), GetNativePos(pfY3),
			GetNativePos(pfX4), GetNativePos(pfY4));
	end;
end;

{------------------------------------------------------------------------------}

// Renders text, centrally aligned, on to the Canvas
procedure TgtRPRenderGraphic.CenterText(const psText: string; const pfX,
	pfY: Double);
var
	BMP: TBitmap;
	ATextSize: TSize;
	ATextHeight,
	AFontRotation,
	AX,
	AY: Integer;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	with FBitmap.Canvas do
	begin
		Pen.Assign(Converter.Pen);
		Brush.Style := bsClear;
		Font := Converter.Font;

		AY := GetNativePos(pfY);
		ATextSize := GetTextSize(Converter.Font, psText);
{$IFDEF Rave50Up}
		ATextHeight := GetNativePos(Converter.FontData.Height);
{$ELSE}
		ATextHeight := GetNativePos(Converter.FontHeight);
{$ENDIF}
		AX :=  GetNativePos(pfX) - ATextSize.cx div 2;
{$IFDEF Rave50Up}
		AFontRotation := Converter.FontData.Rotation;
{$ELSE}
		AFontRotation := Converter.FontRotation;
{$ENDIF}

{$IFDEF Rave50Up}
		if Converter.FontData.Rotation <> 0 then
{$ELSE}
		if Converter.FontRotation <> 0 then
{$ENDIF}
		begin
  {$IFDEF Rave50Up}
			if Converter.FontData.Rotation < 0 then
  {$ELSE}
			if Converter.FontRotation < 0 then
  {$ENDIF}
    {$IFDEF Rave50Up}
				AFontRotation := 360 + Converter.FontData.Rotation;
    {$ELSE}
				AFontRotation := 360 + Converter.FontRotation;
    {$ENDIF}
			BMP := GetRotatedTextBmp(psText, AFontRotation, AX, AY,
				ATextSize.cx, ATextHeight, tpAlignCenter, SetFontDetails);
			Draw(AX, (AY), BMP);
			BMP.Free;
		end
		else
			TextOut(AX, (AY - ATextHeight), psText);
	end;
end;

{------------------------------------------------------------------------------}

// Draws Graphic on to the Canvas
procedure TgtRPRenderGraphic.Draw(const pfX1, pfY1: Double; AGraphic: TGraphic);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	RenderBitmap(GetNativePos(pfX1), GetNativePos(pfY1), AGraphic.Height,
		AGraphic.Width, AGraphic,	False);
end;

{------------------------------------------------------------------------------}

// Draws Ellipse on to the Canvas
procedure TgtRPRenderGraphic.Ellipse(const pfX1, pfY1, pfX2, pfY2: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	with FBitmap.Canvas do
	begin
		Pen.Assign(Converter.Pen);
		Brush.Assign(Converter.Brush);

		Ellipse(GetNativePos(pfX1), GetNativePos(pfY1),
			GetNativePos(pfX2), GetNativePos(pfY2));
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderGraphic.FillRect(const pRect: TRect);
var
	R: TRect;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	with FBitmap.Canvas do
	begin
		Pen.Assign(Converter.Pen);
		Brush.Assign(Converter.Brush);
		if Converter.Brush.Color = clNone
			then Brush.Style := bsClear;
		R.Left := Round(pRect.Left / 72 * cPixelsPerInch);
		R.Right := Round(pRect.Right / 72 * cPixelsPerInch);
		R.Top := Round(pRect.Top / 72 * cPixelsPerInch);
		R.Bottom := Round(pRect.Bottom / 72 * cPixelsPerInch);
		FillRect(R);
	end;
end;

{------------------------------------------------------------------------------}

// Renders text, left aligned, on to the Canvas
procedure TgtRPRenderGraphic.LeftText(const psText: string; const pfX,
	pfY: Double);
var
	BMP: TBitmap;
	ATextSize: TSize;
	ATextHeight,
	AFontRotation,
	AX,
	AY: Integer;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	with FBitmap.Canvas do
	begin
		Pen.Assign(Converter.Pen);
		Brush.Style := bsClear;
		Font := Converter.Font;

		AX := GetNativePos(pfX);
		AY := GetNativePos(pfY);
		ATextSize := GetTextSize(Converter.Font, psText);
{$IFDEF Rave50Up}
		ATextHeight := GetNativePos(Converter.FontData.Height);
{$ELSE}
		AFontRotation := Converter.FontRotation;
{$ENDIF}

  {$IFDEF Rave50Up}
		if Converter.FontData.Rotation <> 0 then
  {$ELSE}
		if Converter.FontRotation <> 0 then
  {$ENDIF}
		begin
    {$IFDEF Rave50Up}
			if Converter.FontData.Rotation < 0 then
    {$ELSE}
			if Converter.FontRotation < 0 then
    {$ENDIF}
      {$IFDEF Rave50Up}
				AFontRotation := (360 + Converter.FontData.Rotation);
      {$ELSE}
				AFontRotation := (360 + Converter.FontRotation);
      {$ENDIF}
			BMP := GetRotatedTextBmp(psText, AFontRotation, AX, AY,
				ATextSize.cx, ATextHeight, tpAlignLeft, SetFontDetails);
			Draw(AX, (AY), BMP);
		end
		else
			TextOut(AX, (AY - ATextHeight), psText);
	end;
end;

{------------------------------------------------------------------------------}

// Draws line on to Canvas
procedure TgtRPRenderGraphic.LineTo(const pfX1, pfY1: Double);
var
	I: Integer;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	with FBitmap.Canvas do
	begin
		Brush.Style := bsCross;
		Pen := Converter.Pen;
		Pen.Style := Pen.Style;
		Pen.Width := 1;
//		Pen.Assign(Converter.Pen);
//		Pen.Width := Converter.Pen.Width;
		for I := 0 to Converter.Pen.Width do
			LineTo(GetNativePos(pfX1) + I, GetNativePos(pfY1) + I);
	end;
end;

{------------------------------------------------------------------------------}

// Moves to a specified point on the Canvas
procedure TgtRPRenderGraphic.MoveTo(const pfX1, pfY1: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	FBitmap.Canvas.MoveTo(GetNativePos(pfX1), GetNativePos(pfY1));
end;

{------------------------------------------------------------------------------}

// Draws Pie on to the Canvas
procedure TgtRPRenderGraphic.Pie(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3,
	pfX4, pfY4: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	with FBitmap.Canvas do
	begin
		Pen.Assign(Converter.Pen);
		Brush.Assign(Converter.Brush);

		Pie(GetNativePos(pfX1), GetNativePos(pfY1),
			GetNativePos(pfX2), GetNativePos(pfY2),
			GetNativePos(pfX3),	GetNativePos(pfY3),
			GetNativePos(pfX4), GetNativePos(pfY4));
	end;
end;

{------------------------------------------------------------------------------}

// Draws Polygon on to Canvas.

{$IFDEF Rave407Up}

procedure TgtRPRenderGraphic.Polygon(const PolyLineArr: array of
	{$IFDEF Rave50Up} TFloatPoint {$ELSE} TPoint {$ENDIF});
begin
	with FBitmap.Canvas do
	begin
		Pen.Assign(Converter.Pen);
		Pen.Style := Converter.Pen.Style;
		Pen.Width := Converter.Pen.Width;
		Brush.Assign(Converter.Brush);

		AssignPolyArray(PolyLineArr);
		Polygon(FPolyArray);
	end;
end;

{------------------------------------------------------------------------------}

// Draws Polyline on to Canvas.
procedure TgtRPRenderGraphic.PolyLine(const PolyLineArr: array of
	{$IFDEF Rave50Up} TFloatPoint {$ELSE} TPoint {$ENDIF});
begin
	with FBitmap.Canvas do
	begin
		Pen.Assign(Converter.Pen);
		Pen.Style := Converter.Pen.Style;
		Pen.Width := Converter.Pen.Width;
		Brush.Assign(Converter.Brush);

		AssignPolyArray(PolyLineArr);
		Polyline(FPolyArray);
	end;
end;

{$ENDIF}

{------------------------------------------------------------------------------}

procedure TgtRPRenderGraphic.PrintBitmapRect(const X1, Y1, X2, Y2: Double;
	AGraphic: Graphics.TBitmap);
var
	AX1,
	AY1,
	AX2,
	AY2: Integer;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	AX1 := GetNativePos(X1);
	AY1 := GetNativePos(Y1);
	AX2 := GetNativePos(X2);
	AY2 := GetNativePos(Y2);
	RenderBitmap(AX1, AY1, Abs(AY2 - AY1), Abs(AX2 - AX1), AGraphic, True);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderGraphic.PrintBitmap(const X1, Y1, ScaleX, ScaleY: Double;
	AGraphic: Graphics.TBitmap);
var
	AX1,
	AY1: Integer;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	AX1 := Round(AGraphic.Width * ScaleX);
	AY1 := Round(AGraphic.Height * ScaleY);
	RenderBitmap(GetNativePos(X1), GetNativePos(Y1), AY1, AX1, AGraphic, True);
end;

{------------------------------------------------------------------------------}

// Renders text, justified, on to the Canvas
procedure TgtRPRenderGraphic.PrintSpaces(const psText: string; const pfX, pfY,
	pfWidth: Double);
var
	AFontRotation,
	ATextHeight,
	AX,
	AY: Integer;
	ATextSize: TSize;
	BMP: TBitmap;
	AText: string;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	with FBitmap.Canvas do
	begin
		Pen.Assign(Converter.Pen);
		Brush.Style := bsClear;
		Font := Converter.Font;

		AX := GetNativePos(pfX);
		AY := GetNativePos(pfY);
		ATextSize := GetTextSize(Converter.Font, psText);
  {$IFDEF Rave50Up}
		ATextHeight := GetNativePos(Converter.FontData.Height);
	{$ELSE}
		ATextHeight := GetNativePos(Converter.FontHeight);
  {$ENDIF}
  {$IFDEF Rave50Up}
  	AFontRotation := Converter.FontData.Rotation;
	{$ELSE}
  	AFontRotation := Converter.FontRotation;
  {$ENDIF}

  {$IFDEF Rave50Up}
		if Converter.FontData.Rotation <> 0 then
	{$ELSE}
		if Converter.FontRotation <> 0 then
  {$ENDIF}
		begin
    {$IFDEF Rave50Up}
			if Converter.FontData.Rotation < 0 then
  	{$ELSE}
			if Converter.FontRotation < 0 then
    {$ENDIF}
      {$IFDEF Rave50Up}
				AFontRotation := (360 + Converter.FontData.Rotation);
    	{$ELSE}
				AFontRotation := (360 + Converter.FontRotation);
      {$ENDIF}
			BMP := GetRotatedTextBmp(psText, AFontRotation, AX, AY,
				ATextSize.cx, ATextHeight, tpAlignJustify, SetFontDetails);
			Draw(AX, (AY - ATextHeight), BMP);
		end
		else
		begin
			AText := JustifyText(psText, GetNativePos(pfWidth), Converter.Font);
			TextOut(AX, (AY - ATextHeight), AText);
		end;
	end;
end;

{------------------------------------------------------------------------------}

// Draws Rectangle on to the Canvas
procedure TgtRPRenderGraphic.Rectangle(const pfX1, pfY1, pfX2, pfY2: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	with FBitmap.Canvas do
	begin
		Pen.Assign(Converter.Pen);
		Brush.Assign(Converter.Brush);

		Rectangle(GetNativePos(pfX1), GetNativePos(pfY1),
			GetNativePos(pfX2), GetNativePos(pfY2));
	end;
end;

{------------------------------------------------------------------------------}

// Renders text, right aligned, on to the Canvas
procedure TgtRPRenderGraphic.RightText(const psText: string; const pfX,
	pfY: Double);
var
	AFontRotation,
	ATextHeight,
	AX,
	AY: Integer;
	ATextSize: TSize;
	BMP: TBitmap;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	with FBitmap.Canvas do
	begin
		Pen.Assign(Converter.Pen);
		Brush.Style := bsClear;
		Font := Converter.Font;

		ATextSize := GetTextSize(Converter.Font, psText);
  {$IFDEF Rave50Up}
		ATextHeight := GetNativePos(Converter.FontData.Height);
  {$ELSE}
		ATextHeight := GetNativePos(Converter.FontHeight);
  {$ENDIF}
		AX := GetNativePos(pfX) - ATextSize.cx + 1;
		AY := GetNativePos(pfy);
  {$IFDEF Rave50Up}
		AFontRotation := Converter.FontData.Rotation;
  {$ELSE}
		AFontRotation := Converter.FontRotation;
  {$ENDIF}

  {$IFDEF Rave50Up}
		if Converter.FontData.Rotation <> 0 then
  {$ELSE}
		if Converter.FontRotation <> 0 then
  {$ENDIF}
		begin
    {$IFDEF Rave50Up}
			if Converter.FontData.Rotation < 0 then
    {$ELSE}
			if Converter.FontRotation < 0 then
    {$ENDIF}
      {$IFDEF Rave50Up}
				AFontRotation := (360 + Converter.FontData.Rotation);
      {$ELSE}
				AFontRotation := (360 + Converter.FontRotation);
      {$ENDIF}
			BMP := GetRotatedTextBmp(psText, AFontRotation, AX, AY,
				ATextSize.cx, ATextHeight, tpAlignRight, SetFontDetails);
			Draw(AX, (AY) , BMP);
		end
		else
			TextOut(AX, (AY - ATextHeight), psText);
	end;
end;

{------------------------------------------------------------------------------}

// Draws Graphic on to Canvas
procedure TgtRPRenderGraphic.StretchDraw(const pRect: TRect;
	AGraphic: TGraphic);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	RenderBitmap(Round(pRect.Left / 72 * cPixelsPerInch),
		Round(pRect.Top / 72 * cPixelsPerInch),
		Round(Abs(pRect.Bottom - pRect.Top) / 72 * cPixelsPerInch),
		Round(Abs(pRect.Right - pRect.Left) / 72 * cPixelsPerInch),
		AGraphic, True);
end;

{------------------------------------------------------------------------------}

// Draws RoundedRectangle on to Canvas
procedure TgtRPRenderGraphic.RoundRect(const pfX1, pfY1, pfX2, pfY2, pfX3,
	pfY3: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	with FBitmap.Canvas do
	begin
		Pen.Assign(Converter.Pen);
		Brush.Assign(Converter.Brush);

		RoundRect(GetNativePos(pfX1), GetNativePos(pfY1),
			GetNativePos(pfX2), GetNativePos(pfY2),
			GetNativePos(pfX3), GetNativePos(pfY3));
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderGraphic.TextRect(Rect: TRect; X1, Y1: double;	S1: string);
var
	AFontRotation,
	ATextHeight,
	AX,
	AY: Integer;
	ATextSize: TSize;
	BMP: TBitmap;
	R: TRect;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	with FBitmap.Canvas do
	begin
		Pen.Assign(Converter.Pen);
		Brush.Assign(Converter.Brush);

		ATextSize := GetTextSize(Converter.Font, S1);
		AX := GetNativePos(X1) - ATextSize.cx + 1;
		AY := GetNativePos(Y1);
  {$IFDEF Rave50Up}
		AFontRotation := Converter.FontData.Rotation;
  {$ELSE}
		AFontRotation := Converter.FontRotation;
  {$ENDIF}
  {$IFDEF Rave50Up}
		ATextHeight := GetNativePos(Converter.FontData.Height);
  {$ELSE}
		ATextHeight := GetNativePos(Converter.FontHeight);
  {$ENDIF}

  {$IFDEF Rave50Up}
		if Converter.FontData.Rotation <> 0 then
  {$ELSE}
		if Converter.FontRotation <> 0 then
  {$ENDIF}
		begin
    {$IFDEF Rave50Up}
			if Converter.FontData.Rotation < 0 then
				AFontRotation := (360 + Converter.FontData.Rotation);
    {$ELSE}
			if Converter.FontRotation < 0 then
				AFontRotation := (360 + Converter.FontRotation);
    {$ENDIF}
			BMP := GetRotatedTextBmp(S1, AFontRotation, AX, AY,
				ATextSize.cx, ATextHeight, tpAlignLeft, SetFontDetails);
			Draw(AX, (AY) , BMP);
		end
		else
		begin
			R.Left := Round(Rect.Left / 72 * cPixelsPerInch);
			R.Right := Round(Rect.Right / 72 * cPixelsPerInch);
			R.Top := Round(Rect.Top / 72 * cPixelsPerInch);
			R.Bottom := Round(Rect.Bottom / 72 * cPixelsPerInch);
			TextRect(R, AX, (AY - ATextHeight), S1);
		end;
	end;
end;

{------------------------------------------------------------------------------}

end.
