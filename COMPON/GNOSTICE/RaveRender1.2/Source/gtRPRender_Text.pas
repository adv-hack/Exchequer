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

unit gtRPRender_Text;

interface

uses
	SysUtils, Windows, Messages, Classes, Graphics, Forms, Dialogs, StdCtrls,
	Controls, RPRender, gtRPRender_Main, gtRPRender_Document, gtRPRender_Consts,
	gtRPRender_Utils;

type

	TTextLineSpacing = (lsActual, lsNoBlank, lsOneBlank, lsTwoBlank,
		lsThreeBlank,	lsFourBlank, lsFiveBlank);

{ TgtRPRenderText class }

	TgtRPRenderText = class(TgtRPRenderDocument)
	private
		FLineSpacing: TTextLineSpacing;
		FPageBreaks,
		FPageEndLines,
		FSeparateFilePerPage: Boolean;
		FXFactor,
		FYFactor: Extended;
		FPageContentList: TList;
		FPageLines: TStringList;

		procedure AppendLines(N: Integer);
		procedure ClearPageContentList;

	public
		constructor Create(AOwner: TComponent); override;

		function GetNativeXPos(X: Extended): Integer;
		function GetNativeYPos(Y: Extended): Integer;
		function ShowSetupModal: Word; override;

		procedure DocBegin; override;
		procedure DocEnd; override;
		procedure EndText; override;
		procedure PageBegin; override;
		procedure PageEnd; override;
  {$IFDEF Rave50Up}
    procedure RenderPage(PageNum: integer); override;
  {$ELSE}
		procedure PrintRender(NDRStream: TStream;
			OutputFileName: TFileName); override;
  {$ENDIF}
		procedure InsertStringAtRowCol(ARow, ACol: Integer; AStr: string);

	protected
		procedure Arc(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4,
			pfY4: Double); override;
		procedure Chord(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4,
			pfY4: Double); override;
		procedure Draw(const pfX1, pfY1: Double;
			AGraphic: TGraphic); override;
		procedure Ellipse(const pfX1, pfY1, pfX2, pfY2: Double); override;
		procedure FillRect(const pRect: TRect); override;
		procedure LineTo(const pfX1, pfY1: Double); override;
		procedure Pie(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4,
			pfY4: Double); override;
		procedure PrintBitmap(const X1, Y1, ScaleX, ScaleY: Double;
			AGraphic: Graphics.TBitmap); override;
		procedure PrintBitmapRect(const X1, Y1, X2, Y2: Double;
			AGraphic: Graphics.TBitmap); override;
		procedure Rectangle(const pfX1, pfY1, pfX2,
			pfY2: Double); override;
		procedure RoundRect(const pfX1, pfY1, pfX2, pfY2, pfX3,
			pfY3: Double); override;
		procedure StretchDraw(const pRect: TRect;
			AGraphic: TGraphic); override;
		procedure TextRect(Rect: TRect; X1, Y1: Double; S1: string); override;

	published
		property LineSpacing: TTextLineSpacing read FLineSpacing
			write FLineSpacing default lsOneBlank;
		property PageBreaks: Boolean read FPageBreaks
			write FPageBreaks default True;
		property PageEndLines: Boolean read FPageEndLines
			write FPageEndLines default True;
		property SeparateFilePerPage: Boolean read FSeparateFilePerPage
			write FSeparateFilePerPage default False;
	end;

const

	TextAdvancedLines: array[TTextLineSpacing] of integer =
		(-1, 0, 1, 2, 3, 4, 5);

implementation

uses gtRPRender_MainDlg, gtRPRender_DocumentDlg, gtRPRender_TextDlg,
  RpDefine;

{------------------------------------------------------------------------------}
{ TgtRPRenderText }
{------------------------------------------------------------------------------}

constructor TgtRPRenderText.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
	DisplayName := sTextDesc;
	FileExtension := '*.' + sTextExt;
	FLineSpacing := lsOneBlank;
	FSeparateFilePerPage := False;
end;

{------------------------------------------------------------------------------}

// Adds blank lines to end of string list
procedure TgtRPRenderText.AppendLines(N: Integer);
var
	I: Integer;
begin
	for I := 1 to N do
		FPageLines.Add(StringOfChar(' ', GetNativeXPos(
			PaperWidth * cPixelsPerInch)));
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderText.ClearPageContentList;
var
	I: Integer;
	P: TgtRPTextDetails;
begin
	if FPageContentList = nil then Exit;
	for I := 0 to FPageContentList.Count - 1 do
	begin
		Application.ProcessMessages;
		P := FPageContentList.Items[I];
		if P <> nil then
			P.Free;
	end;
	FPageContentList.Clear;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderText.GetNativeXPos(X: Extended): Integer;
begin
	Result := Round(X / FXFactor);
end;

{------------------------------------------------------------------------------}

function TgtRPRenderText.GetNativeYPos(Y: Extended): Integer;
begin
	Result := Round(Y / FYFactor);
end;

{------------------------------------------------------------------------------}

function TgtRPRenderText.ShowSetupModal: Word;
begin
	with TgtRPRenderTextDlg.Create(nil) do
	try
		RenderObject := Self;
		Application.ProcessMessages;
		Result := ShowModal;
	finally
		Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderText.DocBegin;
begin
	if FExportCanceled then Exit;
	inherited DocBegin;

	FPageContentList := TList.Create;
	FPageLines := TStringList.Create;
	if not SeparateFilePerPage then
	begin
		try
			FOwnedStream := TFileStream.Create(ReportFileNames.Strings[0], fmCreate);
		except
			CancelExport;
			DoErrorMessage(sCreateFileError);
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderText.DocEnd;
begin
	if FExportCanceled then
	begin
		inherited DocEnd;
		Exit;
	end;

	FPageContentList.Free;
	FPageLines.Free;
	if not SeparateFilePerPage then
	begin
		FOwnedStream.Free;
		FOwnedStream := nil;
	end;
	inherited DocEnd;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderText.EndText;
var
	X, I: Integer;
	AFont: TFont;
	TS: TSize;
begin
	inherited EndText;

	if FXFactor = 0 then
	begin
		AFont := TFont.Create;
		with TgtRPTextDetails(FTextList.Items[0]) do
			try
			// Used for positioning objects
			// If you have a fixed width font, output is closer to original
				AFont.Name := 'Courier New';
				AFont.Charset := FFont.Charset;
				AFont.Color := FFont.Color;
				AFont.Size := 10;
				AFont.Pitch := FFont.Pitch;
				TS := GetTextSize(AFont, 'W');
				FXFactor := TS.cx;
				FYFactor := TS.cy;
			finally
				AFont.Free;
			end;
	end;
	for I := 0 to FTextList.Count - 1 do
	begin
		with TgtRPTextDetails(FTextList.Items[I]) do
		begin
			X := GetNativeXPos(FX);
			if FTextAlign = tpAlignRight then					// Adjust x based on alignment
			begin
				X := GetNativeXPos(FX + FTextWidth);
				X := X - Length(FText);
			end
			else if FTextAlign = tpAlignCenter then
			begin
				X := GetNativeXPos(FX + FTextWidth / 2);
				X := X - Length(FText) div 2 + 1;
			end;
			FX := X;
		end;
		InsertObjectIntoList(FTextList.Items[I], FPageContentList);
	end;
	ClearTextList;
	FProcessingText := False;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderText.PageBegin;
var
	AFileName: string;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	inherited PageBegin;

	FPageLines.Clear;
	// If each page of report is to be exported to separate files just get
	// filename, no need for file stream, use StringList.SaveToFile on EndPage
	if SeparateFilePerPage and (FCurrentPageNo > 1) then
	begin
		AFileName := ExtractFilePath(FOutputFileName) +
			MakeFileName(FOutputFileName, GetFileExtension, FCurrentPageNo);
		if Assigned(OnMakeReportFileName) then
			OnMakeReportFileName(Self, AFileName, Converter.PageNo);
		ReportFileNames.Add(AFileName);
	end;
end;

{------------------------------------------------------------------------------}

// Go through captured list of text entries and put out to file
procedure TgtRPRenderText.PageEnd;
var
	CurLine, I,	OldY,	Y: Integer;
	ATextDetails: TgtRPTextDetails;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	CurLine := 0;
	OldY := -1;
	for I := 0 to FPageContentList.Count - 1 do
	begin
		ATextDetails := FPageContentList.Items[I];
		with ATextDetails do
		begin
			Y := GetNativeYPos(FY);
			if LineSpacing = lsActual then
				CurLine := Y
			else if OldY <> Y then
			begin
				Inc(CurLine, TextAdvancedLines[LineSpacing] + 1);
				OldY := Y;
			end;
			InsertStringAtRowCol(CurLine, Round(FX), FText);
		end;
	end;
	if LineSpacing = lsActual then
		AppendLines(GetNativeYPos(PaperHeight * cPixelsPerInch) - FPageLines.Count)
	else
		AppendLines(TextAdvancedLines[LineSpacing]);
	if PageEndLines then
		FPageLines.Add(StringOfChar('-', GetNativeXPos(
			PaperWidth * cPixelsPerInch)));
	if PageBreaks then
		FPageLines.Add(cPAGEBREAK);
	if not SeparateFilePerPage then
		FOwnedStream.Write(FPageLines.Text[1], Length(FPageLines.Text))
	else
		FPageLines.SaveToFile(ReportFileNames[FCurrentPageNo - 1]);

	ClearPageContentList;
	inherited PageEnd;
end;

{------------------------------------------------------------------------------}

{$IFDEF Rave50Up}

procedure TgtRPRenderText.RenderPage(PageNum: integer);
begin
	inherited Renderpage(PageNum);

	with TRPConverter.Create(NDRStream, Self) do
		try
			Generate;
		finally
			Free;
		end;
end;

{$ELSE}

procedure TgtRPRenderText.PrintRender(NDRStream: TStream;
	OutputFileName: TFileName);
begin
	inherited PrintRender(NDRStream, OutputFileName);

	with TRPConverter.Create(NDRStream, Self) do
		try
			Generate;
		finally
			Free;
		end;
end;

{$ENDIF}

{------------------------------------------------------------------------------}

procedure TgtRPRenderText.InsertStringAtRowCol(ARow, ACol: Integer;
	AStr: string);

	procedure OverwriteString(var S: string; const AText: string; APos: Integer);
	begin
		Delete(S, APos, Length(AText));
		Insert(AText, S, APos);
	end;

var
	S: string;
begin
	if FPageLines.Count < ARow then
		AppendLines(ARow - FPageLines.Count);
	S := FPageLines[ARow - 1];
	OverwriteString(S, AStr, ACol);
	FPageLines[ARow - 1] := S;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderText.Arc(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3,
	pfX4, pfY4: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then
		EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderText.Chord(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3,
	pfX4, pfY4: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then
		EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderText.Draw(const pfX1, pfY1: Double;
	AGraphic: TGraphic);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then
		EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderText.Ellipse(const pfX1, pfY1, pfX2, pfY2: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then
		EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderText.FillRect(const pRect: TRect);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then
		EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderText.LineTo(const pfX1, pfY1: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then
		EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderText.Pie(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3,
	pfX4, pfY4: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then
		EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderText.PrintBitmap(const X1, Y1, ScaleX, ScaleY: Double;
	AGraphic: TBitmap);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then
		EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderText.PrintBitmapRect(const X1, Y1, X2, Y2: Double;
	AGraphic: TBitmap);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then
		EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderText.Rectangle(const pfX1, pfY1, pfX2, pfY2: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then
		EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderText.RoundRect(const pfX1, pfY1, pfX2, pfY2, pfX3,
	pfY3: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then
		EndText;
end;

{------------------------------------------------------------------------------}
  
procedure TgtRPRenderText.StretchDraw(const pRect: TRect;	AGraphic: TGraphic);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then
		EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderText.TextRect(Rect: TRect; X1, Y1: double;	S1: string);
var
	ATextDetails: TgtRPTextDetails;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	ATextDetails := TgtRPTextDetails.Create;
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
			FTextWidth := Rect.Right - Rect.Left;
  {$IFDEF Rave50Up}
      FTextHeight := Converter.FontData.Height * cPixelsPerInch;
  {$ELSE}
      FTextHeight := Converter.FontHeight * cPixelsPerInch;
  {$ENDIF}
			FText := ClipText(S1, Round(FTextWidth), GetTextSize(
				Converter.Font, S1).cx);
			FX := X1 * cPixelsPerInch;
			FY := Y1 * cPixelsPerInch;
  {$IFDEF Rave50Up}
			FFontRotation := Converter.FontData.Rotation;
  {$ELSE}
			FFontRotation := Converter.FontRotation;
  {$ENDIF}
			InsertObjectIntoList(ATextDetails, FPageContentList);
		finally
			Free;
		end;
end;

{------------------------------------------------------------------------------}

end.
