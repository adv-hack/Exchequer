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

unit gtRPRender_Excel;

interface

uses
	SysUtils, Windows, Messages, Math, Classes, Graphics, Forms, Dialogs, StdCtrls,
	Controls, RPRender, gtRPRender_Main, gtRPRender_Document, gtRPRender_Consts,
	gtRPRender_Utils;

type

	// Excel Cell Type.
	TgtExcelCellType = (ctString, ctInteger, ctDouble, ctCurrency, ctTime);

	// Line Spacing.
	TTextLineSpacing = (lsActual, lsNoBlank, lsOneBlank, lsTwoBlank,
		lsThreeBlank, lsFourBlank, lsFiveBlank);

	PgtRPFontAttrib = ^TgtRPFontAttrib;

	PgtExcelTextDetails = ^TgtExcelTextDetails;
	// Excel Text Details.
	TgtExcelTextDetails = record
		FLeft: Extended;
		FTop: Extended;
    FRow: Integer;
    FCol: Integer;
		FText: string;
		FWidth: Extended;
		FTextAlign: TgtRPTextProperty;
		FFontAttrib: TgtRPFontAttrib;
		FExcelCellType: TgtExcelCellType;
	end;

	TgtOnEncodeText = procedure(Render: TgtRPRender; var Text: string;
		var ExcelCellType: TgtExcelCellType) of object;

{ TgtRPRenderExcel class }

	TgtRPRenderExcel = class(TgtRPRenderDocument)
	private
		FOnEncodeText: TgtOnEncodeText;
		FLineSpacing: TTextLineSpacing;
		FSetCellAttributes: Boolean;
    FOutputToUserStream: Boolean;
    FUserStream: TMemoryStream;

		FExcelCellList: TStringList;
		FExcelStream: TStream;
		FExcelTextList: TList;
    FRowTextList: Tlist;

		FFontTable: TStringList;
		FRowsPerPage, FPrevRowNO, FLastLine: Integer;
		FXFactor: Extended;
		FYFactor: Extended;
    FPrevRowError: Extended;
    FScaleX: Double;
    PrevPageCellno: Integer;

		function BuildFontString(AFontName: string;
			AFontSize: Integer; AFontStyle: TFontStyles): string;
		function GetNativeXPos(X: Extended): Extended;
		function GetNativeYPos(Y: Extended): Extended;

		procedure AddFontInfoToFontTable(AFontName: string; AFontSize: Integer;
			AFontStyle: TFontStyles);
		procedure SortAndInsertIntoList(ACurItem : PgtExcelTextDetails;
      ATextList: TList);
		procedure WriteRecord(RecType, RecSize: Integer;
			Buf: array of word; DataSize: Integer; AStream: TStream);

	protected
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
		procedure PageEnd; override;
		procedure Pie(const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3,
			pfX4, pfY4: Double); override;
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
		// LineSpacing Default is set to one
		property LineSpacing: TTextLineSpacing read FLineSpacing
			write FLineSpacing default lsActual;
		property SetCellAttributes: Boolean read FSetCellAttributes
			write FSetCellAttributes default True;
    property ScaleX: Double read FScaleX write FScaleX;

		property OnEncodeText: TgtOnEncodeText read FOnEncodeText
			write FOnEncodeText;
	end;

const

	{---- Text: blank lines to leave before next line}
	TextAdvanceLines: array[TTextLineSpacing] of integer = (-1, 0, 1, 2, 3, 4, 5);

implementation

uses gtRPRender_MainDlg, gtRPRender_DocumentDlg, gtRPRender_ExcelDlg;

{------------------------------------------------------------------------------}
{ TgtRPRenderExcel }
{------------------------------------------------------------------------------}

constructor TgtRPRenderExcel.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
	DisplayName := sExcelDesc;
	FileExtension := '*.' + sExcelExt;
	FLineSpacing := lsActual;
	FSetCellAttributes := True;
  FScaleX := 1;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderExcel.BuildFontString(AFontName: string;
	AFontSize: Integer; AFontStyle: TFontStyles): string;
begin
{ Font string includes FontName, FontSize and FontStyle. }

	Result := AFontName + ' ' + IntToStr(AFontSize);
	if fsBold in AFontStyle then
		Result := Result + ' Bold';
	if fsItalic in AFontStyle then
		Result := Result + ' Italic';
	if fsUnderLine in AFontStyle then
		Result := Result + ' UnderLine';
	if fsStrikeOut in AFontStyle then
		Result := Result + ' StrikeOut';
end;

{------------------------------------------------------------------------------}

function TgtRPRenderExcel.GetNativeXPos(X: Extended): Extended;
begin
	// Convert to Cell column number. 1 cell = 1 inch approx.
	Result := X ;/// FXFactor;
end;

{------------------------------------------------------------------------------}

function TgtRPRenderExcel.GetNativeYPos(Y: Extended): Extended;
begin
	// Convert to Cell Row number. 1 cell = 1 report char height
	Result := Y ;// + (FCurrentPageNo - 1) * FRowsPerPage;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcel.AddFontInfoToFontTable(
	AFontName: string; AFontSize: Integer; AFontStyle: TFontStyles);
var
	S: string;
	AExcelFontAttrib: ^TgtRPFontAttrib;
begin
	S := BuildFontString(AFontName, AFontSize, AFontStyle);
	if FFontTable.IndexOf(S) = -1 then
	begin
		New(AExcelFontAttrib);
		AExcelFontAttrib.Name := AFontName;
		AExcelFontAttrib.Size := AFontSize;
		AExcelFontAttrib.Style := AFontStyle;
		FFontTable.AddObject(S, TObject(AExcelFontAttrib));
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcel.SortAndInsertIntoList(ACurItem : PgtExcelTextDetails;
              ATextList: TList);
var
	I: Integer;
	OldItem: PgtExcelTextDetails;
begin
	with ATextList do
	begin
		I := Count - 1;
		// Insert new rec at point such that TextRecs sort by
		// increasing order of Y and X.
		while I >= 0 do
		begin
			OldItem := ATextList.Items[I];

			if (ACurItem.FTop >(OldItem.FTop)) then
        Break
      else
      if (ACurItem.FTop = OldItem.FTop )   then
      begin
        if  (ACurItem.FLeft >= OldItem.FLeft)  then
          Break;
      end;
			Dec(I);
		end;

		if I = Count - 1 then
			Add(ACurItem)
		else
			Insert(I + 1, ACurItem);

	end;
end;


{------------------------------------------------------------------------------}

procedure TgtRPRenderExcel.WriteRecord(RecType, RecSize: Integer;
	Buf: array of word; DataSize: Integer; AStream: TStream);
var
	Header: array[0..1] of word;
begin
	Header[0] := RecType;
	Header[1] := RecSize;
	AStream.Write(Header, SizeOf(Header));
	if DataSize <> 0 then
		AStream.Write(Buf, SizeOf(Buf));
end;

{------------------------------------------------------------------------------}

function TgtRPRenderExcel.ShowSetupModal: Word;
begin
	with TgtRPRenderExcelDlg.Create(nil) do
	try
		RenderObject := Self;
		Application.ProcessMessages;
		Result := ShowModal;
	finally
		Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcel.Arc(
	const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4, pfY4: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcel.Chord(
	const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4, pfY4: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcel.DocBegin;
begin
	if FExportCanceled then Exit;
	inherited DocBegin;

  FExcelTextList := TList.Create;
  FRowTextList := TList.Create;
	FExcelStream := TMemoryStream.Create;
	FFontTable := TStringList.Create;
	FExcelCellList := TStringList.Create;

	// Write Excel header
	WriteRecord(cExcel_BIFF5_BOF, cExcel_Rec_Size_BOF,
		[0, cExcel_DocType, 0], 6, FOwnedStream);
	// Write worksheet dimensions
	WriteRecord(cExcel_DIM, cExcel_Rec_Size_DIM,
		[0, 0, 0, 0, 0], 10, FOwnedStream);

  PrevPageCellno := 0;    
	FLastLine := 0;
	FXFactor := 0;
	FYFactor := 0;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcel.DocEnd;

  procedure WriteFormatRecord;
  const
    FormatStrings: array[0..3] of string =
      ('General','0','0.00','h:mm:ss AM/PM');
  var
    S: string;
    FormatAttrib: array [4..6] of Byte;
    I: Integer;
  begin
    for I := Low(FormatStrings) to High(FormatStrings) + 1 do
    begin
      if I = High(FormatStrings) + 1 then
        S := CurrencyString +  '#,##0.00_);' + CurrencyString + '(#,##0.00)'
      else
        S := FormatStrings[I];

      FormatAttrib[4] := (I and $FF);
      FormatAttrib[5] := (I shr 8) and $FF;
      FormatAttrib[6] := Length(S);
      WriteRecord($41E, Length(S) + 3, [0], 0, FOwnedStream);
      FOwnedStream.Write(FormatAttrib, SizeOf(FormatAttrib));
      FOwnedStream.Write(pointer(s)^,Length(s));
    end;
  end;

	procedure WriteFontToStream(AFontAttrib: PgtRPFontAttrib);
	var
		S: string;
		FontAttribute: array[2..4] of Byte;
		FontHeight: Word;
	begin
		with AFontAttrib^ do
		begin
			FontAttribute[2] := 0;
			if fsBold in Style then
				FontAttribute[2] := FontAttribute[2] + 1;
			if fsItalic in Style then
				FontAttribute[2] := FontAttribute[2] + 2;
			if fsUnderline in Style then
				FontAttribute[2] := FontAttribute[2] + 4;
			if fsStrikeOut in Style then
				FontAttribute[2] := FontAttribute[2] + 8;

			FontAttribute[3] := 0;
			S := AFontAttrib^.Name;
			FontAttribute[4] := Length(S);
			WriteRecord(49, Length(S) + 5, [0], 0, FOwnedStream);
			FontHeight := 20 * Size;
			FOwnedStream.Write(FontHeight, Sizeof(FontHeight));
			FOwnedStream.Write(FontAttribute, Sizeof(FontAttribute));
			FOwnedStream.Write(Pointer(S)^, Length(S));
		end;
	end;

var
	I, AFontCount: Integer;
	AFontAttrib: PgtRPFontAttrib;
begin
	if FExportCanceled then
	begin
		inherited DocEnd;
		Exit;
	end;

  WriteFormatRecord;
	AFontCount := FFontTable.Count;
	if AFontCount > 4 then
		AFontCount := 4;
	for I := 0 to AFontCount - 1 do
	begin
		AFontAttrib := PgtRPFontAttrib(FFontTable.Objects[I]);
		WriteFontToStream(AFontAttrib);
		Dispose(AFontAttrib);
	end;
	FOwnedStream.CopyFrom(FExcelStream, 0);
	WriteRecord(cExcel_EOF, cExcel_Rec_Size_EOF, [0], 0, FOwnedStream);

  if OutputToUserStream  then
		FUserStream.LoadFromStream(FOwnedStream);

  FOwnedStream.Position := 0;
  if (OutputStream <> nil) and (FOwnedStream <> OutputStream) then
    OutputStream.CopyFrom(FOwnedStream, 0);

	FExcelCellList.Free;
	FExcelTextList.Free;
  FRowTextList.Free;
	FExcelStream.Free;
	FExcelStream := nil;
	FFontTable.Free;
	FOwnedStream.Free;
	FOwnedStream := nil;
	inherited DocEnd;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcel.Draw(const pfX1, pfY1: Double; AGraphic: TGraphic);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcel.Ellipse(const pfX1, pfY1, pfX2, pfY2: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcel.EndText;

  function GetCellType(AText: string): TgtExcelCellType;
  var
    Temp: string;
    LastChar: string;
  begin

    try
      StrToFloat(AText);

      {
        CJS 27/01/2011 - ABSEXCH-3020 : trailing 'E' is being stripped from
        EC VAT Reg numbers (this is because StrToFloat interprets the trailing
        'E' as an exponent indicator).
      }
      Temp := Uppercase(Trim(AText));
      LastChar := Copy(Temp, Length(Temp), 1);
      if (LastChar = 'E') then
        raise EConvertError.Create('');

      if Pos(SysUtils.DecimalSeparator, AText) = 0 then
        Result := ctInteger
      else
        Result := ctDouble;
      exit;
    except
      on Exception do
    end;

    try
      if AText[1] = CurrencyString then
      begin
        StrToCurr(Copy(AText, 2, Length(AText) - 1));
        Result := ctCurrency;
        exit;
      end;
    except
      on EConvertError do
    end;

    try
      StrToTime(AText);
      Result := ctTime;
      exit
    except
      on EConvertError do
    end;

    Result := ctString;
  end;

	procedure InsertTextDetailsToList(ATextDetails: TgtRPTextDetails);
	var
		AExcelTextDetails: PgtExcelTextDetails;
		S: string;
		Temp: Extended;
	begin
		{ Store Text details in a record. Add the record to a list.
			Sort the List based on X and Y positions. }

		New(AExcelTextDetails);
		with AExcelTextDetails^ do
		begin
			FText := ATextDetails.FText;
			FWidth := GetNativeXPos(ATextDetails.FTextWidth);
			FFontAttrib.Name := ATextDetails.FFont.Name;
			FFontAttrib.Charset := ATextDetails.FFont.Charset;
			FFontAttrib.Color := ATextDetails.FFont.Color;
			FFontAttrib.Pitch := ATextDetails.FFont.Pitch;
			FFontAttrib.Size := ATextDetails.FFont.Size;
			FFontAttrib.Style := ATextDetails.FFont.Style;
			AddFontInfoToFontTable(ATextDetails.FFont.Name,
        ATextDetails.FFont.Size, ATextDetails.FFont.Style);
			FTextAlign := ATextDetails.FTextAlign;
			FLeft := GetNativeXPos(ATextDetails.FX);
			FTop := GetNativeYPos(ATextDetails.FY);


			// Excel Cell Type.
			FExcelCellType := ctString;
			S := FText;

			if SysUtils.ThousandSeparator <> SysUtils.DecimalSeparator then
				S := ReplaceString(FText, SysUtils.ThousandSeparator, '');

			FExcelCellType := GetCellType(FText);
			if Assigned(OnEncodeText) then
				OnEncodeText(Self, FText, FExcelCellType);

		end;
		SortAndInsertIntoList(AExcelTextDetails, FExcelTextList);
	end;

var
	I: Integer;
	AFont: TFont;
	TS: TSize;
begin

	if ((FXFactor = 0) or (FYFactor = 0)) then
	begin
		AFont := TFont.Create;
		try
			// Used for positioning objects
			// If you have a fixed width font, output will be closer to original
			AFont.Name := 'Arial';
			AFont.Size := 10;
			TS := GetTextSize(AFont, 'a');
			FRowsPerPage := Round(PaperHeight * cPixelsPerInch / TS.cy);
			FXFactor := (TS.cx * cExcel_StdCharsPerCell) * ScaleX;
			FYFactor := TS.cy;
			AddFontInfoToFontTable(AFont.Name, AFont.Size, AFont.Style);
		finally
			AFont.Free;
		end;
	end;

	for I := 0 to FTextList.Count - 1 do
    InsertTextDetailsToList(FTextList.Items[I]);

	ClearTextList;
	FProcessingText := False;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcel.FillRect(const pRect: TRect);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcel.LineTo(const pfX1, pfY1: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcel.PageEnd;

	function GetFontIndex(AFontName: string; AFontSize: Integer;
		AFontStyle: TFontStyles): Byte;
	var
		S: string;
		I: Integer;
	begin
		S := BuildFontString(AFontName, AFontSize, AFontStyle);
		I := FFontTable.IndexOf(S);
		Result := I;
		if I >= 4 then
      Result := 0
	end;

  function GetNumberString(AText: string): string;
  var
    I: Integer;
  begin
    Result := '';
    AText := Trim(AText);
    for I := 1 to Length(AText) do
    begin
      if ((I = 1) and (AText[I] in ['+', '-'])) or
          (AText[I] in ['0'..'9', DecimalSeparator, ThousandSeparator]) then
        Result := Result + AText[I];
    end;
  end;

	procedure WriteCellData(ARow, ACol: Integer; AAttrib: array of Byte;
		 AData: string; AExcelCellType: TgtExcelCellType);
	var
		S: string;
		Buf: array[0..1] of word;
		XLSString: shortstring;
		ACellData: Double;
	begin
		XLSString := '';
		Buf[0] := ARow +  PrevPageCellno;
		Buf[1] := ACol;
		S := ReplaceString(AData, SysUtils.ThousandSeparator, '');
		case AExcelCellType of
      ctCurrency:
        AAttrib[1] := AAttrib[1] + 4;
			ctInteger:
        AAttrib[1] := AAttrib[1] + 1;
			ctDouble:
        AAttrib[1] := AAttrib[1] + 2;
      ctTime:
        AAttrib[1] := AAttrib[1] + 3;
		end;

		if AExcelCellType in [ctInteger, ctDouble, ctCurrency] then
    begin
      ACellData := StrToFloat(GetNumberString(Trim(S)));
      WriteRecord(CExcel_Cell_Double, CExcel_Rec_Size_Cell_Double,
					[0], 0, FExcelStream);
  		FExcelStream.Write(Buf, SizeOf(Buf));
	  	FExcelStream.Write(AAttrib, SizeOf(AAttrib));
			FExcelStream.Write(ACellData, SizeOf(Double))
    end
		else
    begin
      XLSString := Trim(AData);
      WriteRecord(CExcel_Cell_Label,
        Length(XLSString) + CExcel_Rec_Size_Cell_Label+1 , [0], 0, FExcelStream);
	  	FExcelStream.Write(Buf, SizeOf(Buf));
  		FExcelStream.Write(AAttrib, SizeOf(AAttrib));
			FExcelStream.Write(XLSString, Length(XLSString)+1);
    end;
	end;

  procedure WriteRow(list: Tlist);
  var
    J: Integer;
    Ptr1: PgtExcelTextDetails;
    ColNO: Integer;
    PrevCellno,RowNO :Integer;
  begin
    RowNo := 0;
    PrevCellno := -1;
    if List.Count > 0 then
    begin
      if LineSpacing = lsActual then
      begin
        RowNO := Round(PgtExcelTextDetails(List.items[0]).FTop / FYFactor);
        if RowNO <= FPrevRowNo then
          RowNO := FPrevRowNo + 1;
        FPrevRowNO := RowNO;
      end
      else
      begin
        RowNO := FLastLine;
        FLastLine := FLastLine + TextAdvanceLines[LineSpacing] + 1;
      end;
    end;

    for J := 0 to list.Count-1 do
    begin
      Ptr1 := list.Items[J];
      ColNO := Round(Ptr1.FLeft / FXFactor);
      if ColNo <= PrevCellNo then
        ColNo := PrevCellNo + 1;
      Ptr1.FCol := ColNo;
      Ptr1.FRow := RowNO;
      PrevCellno := ColNO;
    end;
  end;

var
	ATextDetails: PgtExcelTextDetails;
  Ptr1, Ptr2: PgtExcelTextDetails;
	CellAttribute: array[0..2] of Byte; { 24 bit field }
	I, K: Integer;
	Fn: Byte;
  E: Extended;
begin
	if FExportCanceled then Exit;
	if FProcessingText then EndText;
	CellAttribute[0] := 0;
  Ptr1 := nil;
  FPrevRowNO := 0;
  FLastLine := 0;
  FPrevRowError := 0.0;
  E := 0.0;

  if  FExcelTextList.Count > 0 then
  begin
    Ptr1 :=  FExcelTextList.Items[0];
    FRowTextList.Add(Ptr1);
    E := GetNativeYPos(Abs(Ptr1.FFontAttrib.Size));
  end;

  for I := 1 to FExcelTextList.Count - 1 do
	begin
    Ptr2 := FExcelTextList.Items[I];
    if (Ptr2.FTop > (Ptr1.FTop + E / 2) ) then
    begin
      WriteRow(FRowTextList);
      FRowTextList.Clear;
      FRowTextList.Add(Ptr2);
      Ptr1 := Ptr2;
      E := GetNativeYPos(Abs(Ptr1.FFontAttrib.Size));
    end
    else
    begin
      K := FRowTextList.Count -1;
      while K >= 0 do
      begin
        if Ptr2.FLeft >= PgtExcelTextDetails(FRowTextList.Items[k]).FLeft  then
          Break;
        dec(K);
      end;
      if K = (FRowTextList.Count - 1) then
        FRowTextList.Add(Ptr2)
      else
        FRowTextList.Insert(K+1,Ptr2);
    end;
  end;
    WriteRow(FRowTextList);
    FRowTextList.Clear;

	for I := 0 to FExcelTextList.Count - 1 do
	begin
		ATextDetails := FExcelTextList.Items[I];
		with ATextDetails^ do
		begin
			Fn := GetFontIndex(
				FFontAttrib.Name, FFontAttrib.Size, FFontAttrib.Style) * 64;

			CellAttribute[1] :=	Fn;
			CellAttribute[2] := 1;										// Cell alignment byte.

      if  SetCellAttributes then
        if FTextAlign = tpAlignRight then
          CellAttribute[2] := 3												// Set bit 0 & 1.
        else if FTextAlign = tpAlignCenter then
          CellAttribute[2] := 2;											// Set bit 1.

			if Trim(FText) <> '' then
				WriteCellData(FRow, FCol, CellAttribute, Trim(FText),
          FExcelCellType);
			Dispose(ATextDetails);
		end;
	end;

  PrevPageCellNO := PrevPageCellNO + FPrevRowNO + 1;

	FExcelTextList.Clear;
	inherited PageEnd;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcel.Pie(
	const pfX1, pfY1, pfX2, pfY2, pfX3, pfY3, pfX4, pfY4: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcel.PrintBitmap(const X1, Y1, ScaleX, ScaleY: Double;
	AGraphic: Graphics.TBitmap);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcel.PrintBitmapRect(const X1, Y1, X2, Y2: Double;
	AGraphic: Graphics.TBitmap);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcel.Rectangle(const pfX1, pfY1, pfX2, pfY2: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcel.RoundRect(const pfX1, pfY1, pfX2, pfY2,
	pfX3, pfY3: Double);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcel.StretchDraw(const pRect: TRect; AGraphic: TGraphic);
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcel.TextRect(Rect: TRect; X1, Y1: double; S1: string);
var
	ATextDetails: TgtRPTextDetails;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;
	if FProcessingText then EndText;

	ATextDetails := TgtRPTextDetails.Create;
	with ATextDetails do
		try
			SetFontDetails(ATextDetails);
			FTextAlign := tpAlignLeft;
			FTextWidth := Rect.Right - Rect.Left;
  {$IFDEF Rave50Up}
			FTextHeight := Converter.FontData.Height * cPixelsPerInch;
  {$ELSE}
			FTextHeight := Converter.Font.Height * cPixelsPerInch;
  {$ENDIF}
			FText := ClipText(S1, Round(FTextWidth),
				GetTextSize(Converter.Font, S1).cx);
			FX := X1 * cPixelsPerInch;
			FY := Y1 * cPixelsPerInch;
			InsertObjectIntoList(ATextDetails, FExcelTextList);
		finally
			Free;
		end;
end;

{------------------------------------------------------------------------------}

{$IFDEF Rave50Up}

procedure TgtRPRenderExcel.RenderPage(PageNum: integer);
begin
	inherited Renderpage(PageNum);

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

procedure TgtRPRenderExcel.PrintRender(NDRStream: TStream;
	OutputFileName: TFileName);
begin
	inherited PrintRender(NDRStream, OutputFileName);

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

{------------------------------------------------------------------------------}

{$ENDIF}

end.
