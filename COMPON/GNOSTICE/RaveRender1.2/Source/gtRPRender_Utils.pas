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

unit gtRPRender_Utils;

interface

uses
	SysUtils, Windows, Graphics, StdCtrls, Controls, FileCtrl
	{$IFDEF AMResample}
		, ReSample
	{$ENDIF};

type

	TgtRotatedTextValues = record
		ATextWidth,
		ATextHeight,
		ATextWidthGap,
		ATextHeightGap,
		ATotalWidth,
		ATotalHeight,
		AposX,
		AposY: Integer;
	end;

	THackWinControl = class(TWinControl);

function AppendTrailingBackslash(const S: string): string;
function ClipText(AText: string; AClipWidth, ATextWidth: Integer): string;
function ColorBGRToRGB(AColor: TColor): string;
function DegreesToRadians(Degrees: Extended): Extended;
function ForceDirs(Dir: string): Boolean;
function GetAbsoluteDir(const ADir, AReferenceDir: string): string;
function GetTextSize(AFont: TFont; const Text: string): TSize;
function JustifyText(AText: string; AWidth: Integer; AFont: TFont): string;
function MakeFileName(AFileName, AFileExtension: string;
	ANumber: Integer): string;
function MakeImageFileName(AFileName, AFileExtension: string;
	ANumber: Integer): string;
function Max(A,B: Extended): Extended;
function Min(A,B: Extended): Extended;
function RadiansToDegrees(Radians: Extended): Extended;
function ReplaceString(const S, OldPattern, NewPattern: string): string;

procedure CalculateTextPositions(ACanvas: TCanvas; AAngleDegree: Integer;
	Atext: string; var AgtRotatedTextValues: TgtRotatedTextValues);
procedure CheckAndDeleteFile(AFileName: string);
procedure gtAngleText(AText: string; AAngleDegree: Integer; ABitmap: TBitmap;
	var PosX, PosY: Integer);
procedure gtStretchDraw(ImageIn: TGraphic; ImageOut: TBitmap);
procedure	SetControlsEnabled(AControl: TWinControl; AState: Boolean);
procedure SetTextAngle(ACanvas: TCanvas; AAngleDegree: Integer);

implementation

{------------------------------------------------------------------------------}

function AppendTrailingBackslash(const S: string): string;
begin
	Result := S;
	if not IsPathDelimiter(Result, Length(Result)) then Result := Result + '\';
end;

{------------------------------------------------------------------------------}

function ClipText(AText: string; AClipWidth, ATextWidth: Integer): string;
var
	ClipLength: Integer;
begin
	Result := AText;
	if ATextWidth <= AClipWidth then Exit;
	ClipLength := Round(AClipWidth * Length(AText) / ATextWidth);
	Result := Copy(AText, 0, ClipLength);
end;

{------------------------------------------------------------------------------}

function ColorBGRToRGB(AColor: TColor): string;
begin
{--- Re-arrange BGR, returned by ColorToRGB, to RGB ---}
	Result := IntToHex(ColorToRGB(AColor), 6);
	Result := Copy(Result, 5, 2) + Copy(Result, 3, 2) + Copy(Result, 1, 2);
end;

{------------------------------------------------------------------------------}

function DegreesToRadians(Degrees: Extended): Extended;
begin
	Result := Degrees * (PI / 180);
end;

{------------------------------------------------------------------------------}

function ForceDirs(Dir: string): Boolean;
begin
	{$IFDEF gtDelphi5Up}
		Result := ForceDirectories(Dir);
	{$ELSE}
		ForceDirectories(Dir);
		Result := DirectoryExists(Dir);
	{$ENDIF}
end;

{------------------------------------------------------------------------------}

function GetAbsoluteDir(const ADir, AReferenceDir: string): string;
var
	TempDir: string;
begin
	Result := AReferenceDir;
	if ADir <> '' then
	begin
		TempDir := GetCurrentDir;
		SetCurrentDir(AReferenceDir);
		Result := ExtractFilePath(ExpandFileName(ADir));
		if Result <> '' then Result := AppendTrailingBackslash(Result);
		if not DirectoryExists(Result) then
			ForceDirs(Result);
		SetCurrentDir(TempDir);
	end;
end;

{------------------------------------------------------------------------------}

function GetTextSize(AFont: TFont; const Text: string): TSize;
var
	DC: HDC;
	SaveFont: HFont;
begin
	DC := GetDC(0);
	SaveFont := SelectObject(DC, AFont.Handle);
	Result.cX := 0;
	Result.cY := 0;
	GetTextExtentPoint32(DC, PChar(Text), Length(Text), Result);
	SelectObject(DC, SaveFont);
	ReleaseDC(0, DC);
end;

{------------------------------------------------------------------------------}

function JustifyText(AText: string; AWidth: Integer; AFont: TFont): string;
var
	BlankString: string;
	CurWidth, BlankWidth,	BlankSpaceCount: Integer;
begin
	Result := AText;
	BlankString := ' ';
	CurWidth := GetTextSize(AFont, Result).cx;
	if (CurWidth >= AWidth) or (Pos(BlankString, Result) = 0) then Exit;
	while CurWidth < AWidth do
	begin
		Result := StringReplace(Result, BlankString,
			BlankString + ' ', [rfReplaceAll]);
		CurWidth := GetTextSize(AFont, Result).cx;
		BlankString := BlankString + ' ';
	end;
	BlankWidth := GetTextSize(AFont, ' ').cx;
	BlankSpaceCount := Round((CurWidth - AWidth) / BlankWidth);
	Delete(BlankString, 1, 1);
	while BlankSpaceCount > 0 do
	begin
		Result := StringReplace(Result, BlankString + ' ', BlankString, []);
		Dec(BlankSpaceCount);
	end;
end;

{------------------------------------------------------------------------------}

function MakeFileName(AFileName, AFileExtension:
	string; ANumber: Integer): string;
var
	FileName, FileExt: string;
begin
	FileName := ChangeFileExt(ExtractFileName(AFileName), '');
	FileExt := AFileExtension;
	if Pos('.', AFileExtension) = 0 then
		FileExt := '.' + FileExt;
	if ANumber >= 0 then
	// Format to <User given name>0001.<FileExt> - e.g. MyRep0001.htm
		Result := Format('%s%.4d%s',[FileName, ANumber, FileExt])
	else
		Result := Format('%s%s',[FileName, FileExt])
end;

{------------------------------------------------------------------------------}

function MakeImageFileName(AFileName, AFileExtension: string;
	ANumber: Integer): string;
var
	FileName: string;
begin
	FileName := ChangeFileExt(ExtractFileName(AFileName), '');
	Result := Format('%s_I%.4d.%s', [FileName, ANumber, AFileExtension]);
end;

{------------------------------------------------------------------------------}

function Max(A,B: Extended): Extended;
begin
	if A > B then
		Result := A
	else
		Result := B;
end;

{------------------------------------------------------------------------------}

function Min(A,B: Extended): Extended;
begin
	if A < B then
		Result := A
	else
		Result := B;
end;

{------------------------------------------------------------------------------}

function RadiansToDegrees(Radians: Extended): Extended;
begin
	Result := Radians * (180 / PI);
end;

{------------------------------------------------------------------------------}

function ReplaceString(const S, OldPattern, NewPattern: string): string;
var
	I: Integer;
	SearchStr, Str, OldPat: string;
begin
	SearchStr := AnsiUpperCase(S);
	OldPat := AnsiUpperCase(OldPattern);
	Str := S;
	Result := '';
	while SearchStr <> '' do
	begin
		I := AnsiPos(OldPat, SearchStr);
		if I = 0 then
		begin
			Result := Result + Str;
			Break;
		end;
		Result := Result + Copy(Str, 1, I - 1) + NewPattern;
		Str := Copy(Str, I + Length(OldPattern), MaxInt);
		SearchStr := Copy(SearchStr, I + Length(OldPat), MaxInt);
	end;
end;

{------------------------------------------------------------------------------}

procedure CalculateTextPositions(ACanvas: TCanvas; AAngleDegree: Integer;
	Atext: string; var AgtRotatedTextValues: TgtRotatedTextValues);
var
	AFontWidth, AFontHeight: Integer;
	AAngleRadians: Real;
begin
	SetTextAngle(ACanvas, AAngleDegree); // Rotate Font

	// Convert from Degrees to Radians
	case AAngleDegree of
		0..89   : AAngleRadians := DegreesToRadians(90 - AAngleDegree);
		90..179 : AAngleRadians := DegreesToRadians(AAngleDegree - 90);
		180..269: AAngleRadians := DegreesToRadians(270 - AAngleDegree);
	else {270..359}
		AAngleRadians := DegreesToRadians(AAngleDegree - 270);
	end;

	AFontWidth := ACanvas.TextWidth(AText);
	AFontHeight := ACanvas.TextHeight(AText);

	with AgtRotatedTextValues do
	begin
		ATextWidth     := Round(sin(AAngleRadians) * AFontWidth);
		ATextWidthGap  := Round(cos(AAngleRadians) * AFontHeight);
		ATextHeight    := Round(cos(AAngleRadians) * AFontWidth);
		ATextHeightGap := Round(sin(AAngleRadians) * AFontHeight);

		ATotalWidth  := (ATextWidth + ATextWidthGap);
		ATotalHeight := (ATextHeight + ATextHeightGap);

		// Calculate new position of text
		case AAngleDegree of
			0..89:
			begin
				AposX := 0;
				APosY := ATextHeight;
			end;
			90..179:
			begin
				APosX := ATextWidth;
				APosY := ATotalHeight
			end;
			180..269:
			begin
				APosX := ATotalWidth;
				APosY := ATextHeightGap;
			end;
		else {270..359}
			begin
				APosX := ATextWidthGap;
				APosY := 0
			end;
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure CheckAndDeleteFile(AFileName: string);
begin
	try
		if FileExists(AFileName) then
			SysUtils.DeleteFile(AFileName);
	except
	end;
end;

{------------------------------------------------------------------------------}

procedure gtAngleText(AText: string; AAngleDegree: Integer; ABitmap: TBitmap;
	var PosX, PosY: Integer);
var
	AgtRotatedTextValues: TgtRotatedTextValues;
begin
	CalculateTextPositions(ABitmap.Canvas, AAngleDegree, AText,
		AgtRotatedTextValues);

	with ABitmap do
	begin
		Width := AgtRotatedTextValues.ATextWidth +
			AgtRotatedTextValues.ATextWidthGap;
		Height := AgtRotatedTextValues.ATextHeight +
			AgtRotatedTextValues.ATextHeightGap;
		Transparent := True;
		Canvas.Brush.Style := bsClear;
		Canvas.TextOut(AgtRotatedTextValues.APosX,
			AgtRotatedTextValues.APosY, AText);
	end;
	PosX := PosX - AgtRotatedTextValues.APosX;
	PosY := PosY - AgtRotatedTextValues.APosY;
end;

{------------------------------------------------------------------------------}

procedure gtStretchDraw(ImageIn: TGraphic; ImageOut: TBitmap);
var
	OutputRect: TRect;
{$IFDEF AMResample}
	Bmp: TBitmap;
{$ENDIF}
begin
	OutputRect := ImageOut.Canvas.ClipRect;
{$IFDEF AMResample}
	Bmp := TBitmap.Create;
	try
		Bmp.Width := ImageIn.Width;
		Bmp.Height := ImageIn.Height;
		Bmp.Canvas.Draw(0, 0, ImageIn);
		Strecth(Bmp, ImageOut, ResampleFilters[2].Filter,
			ResampleFilters[2].Width);
	finally
		Bmp.Free;
	end;
{$ELSE}
		ImageOut.Canvas.StretchDraw(OutputRect, ImageIn);
{$ENDIF}
end;

{------------------------------------------------------------------------------}

procedure	SetControlsEnabled(AControl: TWinControl; AState: Boolean);
const
	StateColor: array[Boolean] of TColor = (clInactiveBorder, clWindow);
var
	I: Integer;
begin
	with AControl do
	for I := 0 to ControlCount - 1 do
		begin
			if ((Controls[I] is TWinControl) and
					(TWinControl(Controls[I]).ControlCount > 0)) then
				SetControlsEnabled(TWinControl(Controls[I]), AState);
			if (Controls[I] is TCustomEdit) then
				THackWinControl(Controls[I]).Color := StateColor[AState]
			else if (Controls[I] is TCustomComboBox) then
				THackWinControl(Controls[I]).Color := StateColor[AState];
			Controls[I].Enabled := AState;
		end;
end;

{------------------------------------------------------------------------------}

procedure SetTextAngle(ACanvas: TCanvas; AAngleDegree: Integer);
var
	AFontLogRec: TLogFont;
begin
	// Get current Font information for Font rotation
	GetObject(ACanvas.Font.Handle, SizeOf(AFontLogRec), Addr(AFontLogRec));

	// Rotate Font
	AFontLogRec.lfEscapement := (AAngleDegree * 10);
	// Request TrueType precision
	AFontLogRec.lfOutPrecision := OUT_TT_ONLY_PRECIS;

	ACanvas.Font.Handle := CreateFontIndirect(AFontLogRec);
end;

{------------------------------------------------------------------------------}

end.
