unit RepUtil;

{ nfrewer440 16:35 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
//  RPBase, RPDefine;

  {NF: 22/01/2009}
  RPBase, RPDefine, Windows, ETStrU, RPMemo, RPDevice, ETMiscU, TEditVal, RPFiler, StrUtil, Types;

const
  dlThin = -1;
  dlThick = -2;
  dlVeryThick = -3;

  NO_HEADER_LINE = '-=*> NO HEADER LINE <*=-';  //NF 25/01/2008

type
  TFontName = (fnTitle, fnSubTitle, fnSubSubTitle, fnColHeader, fnMainText, fnCourier, fnSubTotal
  , fnSectionHeader, fnSmallText);

  TWastes = Record
    Left : real;
    Right : real;
    Top : real;
    Bottom : real;
  end;

  procedure SetDefaultMargins(TheReport : TBaseReport; SetOrientTo : TOrientation);
//  procedure SetStandardHeader(TheReport : TBaseReport; sUserName, sReportTitle, sColHeads : string; bPagedFormat : boolean = TRUE);
  procedure SetStandardHeader(TheReport : TBaseReport; sUserName, sReportTitle, sColHeads : string; bPagedFormat : boolean = TRUE; sSubTitle : string = ''; sDateRange : string = '');
  procedure SetRepFont(TheReport : TBaseReport; NewFontName : TFontName; rBaseFontSize : double);
  procedure DrawHorzLine(TheReport : TBaseReport; iWidth : integer; XLeft, XRight : real);
  procedure DrawLineUnder(TheReport : TBaseReport);
//  function EndOfPageLine(TheReport : TBaseReport) : boolean;
  function EndOfPageLine(TheReport : TBaseReport; bPagedFormat : boolean = TRUE; bDrawLine : boolean = TRUE) : boolean;
  function NextLine(TheReport : TBaseReport; bPagedFormat : boolean = TRUE) : boolean;
  procedure UpOneLine(TheReport : TBaseReport);
  procedure PrintEOPLn(asLine : AnsiString; TheReport : TBaseReport; bPagedFormat : boolean = TRUE; bDrawLine : boolean = TRUE);
  {NF: 22/01/2009}
  Procedure PrintLineWithBounds(ThisLine  :  String; RepFiler1 : TReportFiler; RDevRec : TSBSPrintSetupInfo);

implementation
uses
  SysUtils, Graphics, MathUtil;

procedure SetDefaultMargins(TheReport : TBaseReport; SetOrientTo : TOrientation);
var
  PortraitWastes, LandscapeWastes : TWastes;

  procedure GetWastes(var Wastes : TWastes);
  begin
    with Wastes do begin
      Left := TheReport.LeftWaste;
      Right := TheReport.RightWaste;
      Top := TheReport.TopWaste;
      Bottom := TheReport.BottomWaste;
    end;{with}
  end;

begin
  with TheReport do begin
    Orientation := poPortrait;
    GetWastes(PortraitWastes);
    Orientation := poLandscape;
    GetWastes(LandscapeWastes);

    if SetOrientTo = poLandscape then
      begin
        MarginLeft := GreaterRealOf(PortraitWastes.Top, LandscapeWastes.Top) + 1;
        MarginRight := GreaterRealOf(PortraitWastes.Bottom, LandscapeWastes.Bottom) + 1;
        MarginTop := GreaterRealOf(PortraitWastes.Right, LandscapeWastes.Right) + 1;
        MarginBottom := GreaterRealOf(PortraitWastes.Left, LandscapeWastes.Left) + 1;
      end
    else begin
      MarginLeft := GreaterRealOf(PortraitWastes.Left, LandscapeWastes.Left) + 1;
      MarginRight := GreaterRealOf(PortraitWastes.Right, LandscapeWastes.Right) + 1;
      MarginTop := GreaterRealOf(PortraitWastes.Top, LandscapeWastes.Top) + 1;
      MarginBottom := GreaterRealOf(PortraitWastes.Bottom, LandscapeWastes.Bottom) + 1;
    end;{if}
    Orientation := SetOrientTo;
  end;{with}
end;

procedure SetStandardHeader(TheReport : TBaseReport; sUserName, sReportTitle, sColHeads : string
; bPagedFormat : boolean = TRUE; sSubTitle : string = ''; sDateRange : string = '');
begin
  with TheReport do begin
    Home;

    // Print Main Title
    SetRepFont(TheReport, fnTitle, 8);
    PrintLeft(sUserName,MarginLeft);

    // Print Date / Time "Printed On"
    SetRepFont(TheReport, fnSubSubTitle, 8);
    if bPagedFormat then PrintRight('Printed on : ' + DateToStr(Now) + ' - ' + TimeToStr(Now),PageWidth - MarginRight)
    else PrintLeft('Printed on : ' + DateToStr(Now) + ' - ' + TimeToStr(Now), MarginLeft);

    CRLF;

    // Print Report Title
    SetRepFont(TheReport, fnSubTitle, 8);
    PrintLeft(sReportTitle,MarginLeft);

    if (sDateRange = '') then
      begin
        // Print Page No
        SetRepFont(TheReport, fnSubSubTitle, 8);
        if bPagedFormat then PrintRight('Page : ' + Macro(MidCurrentPage) + ' of ' + Macro(MidTotalPages), PageWidth - MarginRight);
      end
    else begin
      // Print Date Range
      SetRepFont(TheReport, fnSubSubTitle, 8);
      PrintRight('Range : ' + sDateRange, PageWidth - MarginRight);
    end;{if}

    CRLF;

    // print sub-title
    if (sSubTitle <> '') then begin
      SetRepFont(TheReport, fnColHeader, 8);
      PrintLeft(sSubTitle, MarginLeft);
    end;{if}

    // Print Page No
    if (sDateRange <> '') then begin
      SetRepFont(TheReport, fnSubSubTitle, 8);
      if bPagedFormat then PrintRight('Page : ' + Macro(MidCurrentPage) + ' of ' + Macro(MidTotalPages), PageWidth - MarginRight);
    end;{if}

    if (sSubTitle <> '') or (sDateRange <> '') then CRLF;

    // print column headers
//    if sColHeads <> '' then begin
    if (sColHeads <> '') and (sColHeads <> NO_HEADER_LINE) then //NF 25/01/2008
    begin
      SetRepFont(TheReport, fnColHeader, 8);
      CRLF;
      Print(sColHeads);
    end;{if}

//    DrawLineUnder(TheReport);
    if sColHeads <> NO_HEADER_LINE then DrawLineUnder(TheReport); //NF 25/01/2008
  end;{with}
end;

procedure SetRepFont(TheReport : TBaseReport; NewFontName : TFontName; rBaseFontSize : double);
begin
  with TheReport do begin
    if NewFontName = fnCourier then FontName := 'Courier New'
    else FontName := 'Arial';
    FontColor := clBlack;
    Bold := NewFontName in [fnTitle, fnSubTitle, fnColHeader, fnSubTotal, fnSectionHeader];
    Underline := NewFontName = fnSectionHeader;

    SetPen(clBlack,psSolid,-1,pmCopy);
    SetBrush(clWhite,bsClear,Nil);

    case NewFontName of
      fnTitle : FontSize := rBaseFontSize + 2;
      fnSubTitle : FontSize := rBaseFontSize + 1;
      fnSectionHeader, fnColHeader, fnSubTotal, fnSubSubTitle, fnMainText : FontSize := rBaseFontSize;
      fnCourier : FontSize := rBaseFontSize + 2;
      fnSmallText : FontSize := rBaseFontSize - 2;
    end;{case}
  end;{with}
end;

procedure DrawHorzLine(TheReport : TBaseReport; iWidth : integer; XLeft, XRight : real);
var
  rHeight : real;
begin
  with TheReport do begin
    SetPen(clBlack,psSolid,iWidth,pmCopy);
    rHeight := YD2U(CursorYPos) + (LineHeight / 3.5);
    MoveTo(XLeft, rHeight);
    LineTo(XRight, rHeight);
    CRLF;
  end;{with}
end;

procedure DrawLineUnder(TheReport : TBaseReport);
begin
  with TheReport do begin
    DrawHorzLine(TheReport, -2, MarginLeft, PageWidth - MarginRight);
  end;{with}
end;

(*
function EndOfPageLine(TheReport : TBaseReport) : boolean;
begin
  with TheReport do begin
    Result := LinesLeft < 3;
    if LinesLeft < 3 then
      begin
        DrawLineUnder(TheReport);
        NewPage;
      end
    else CRLF;
  end;{with}
end;
*)

function EndOfPageLine(TheReport : TBaseReport; bPagedFormat : boolean = TRUE; bDrawLine : boolean = TRUE) : boolean;
begin
  with TheReport do begin
    Result := LinesLeft < 3;
    if LinesLeft < 3 then
      begin
        if bDrawLine then DrawLineUnder(TheReport)
        else CRLF;
        if bPagedFormat or (TheReport.CurrentPage = TheReport.LastPage)
        then NewPage;
      end
    else CRLF;
  end;{with}
end;

function NextLine(TheReport : TBaseReport; bPagedFormat : boolean = TRUE) : boolean;
begin
  with TheReport do begin
    Result := LinesLeft < 3;
    if LinesLeft < 3 then
      begin
        if bPagedFormat or (TheReport.CurrentPage = TheReport.LastPage)
        then NewPage;
      end
    else CRLF;
  end;{with}
end;

procedure UpOneLine(TheReport : TBaseReport);
begin
  with TheReport do YPos := YPos - LineHeight;
end;

procedure PrintEOPLn(asLine : AnsiString; TheReport : TBaseReport; bPagedFormat : boolean = TRUE; bDrawLine : boolean = TRUE);
begin
  TheReport.Print(asLine);
  EndOfPageLine(TheReport, bPagedFormat, bDrawLine);
end;

{NF: 22/01/2009}
Procedure PrintLineWithBounds(ThisLine  :  String; RepFiler1 : TReportFiler; RDevRec : TSBSPrintSetupInfo);
const
  GenRealMask   =  '###,###,###,##0.00 ;###,###,###,##0.00-';
Var
  ThisPos, ThisPos2, ThisCol, ThisX, ThisY      :  Integer;
  ThisTab    :  PTab;
  ThisRect   :  TRect;
  ThisText, ProcessLn  :  String;
  TAbort     :  Boolean;

  Procedure RPJustXY(Var TX, TY : Integer; Const ThisRect : TRect; Const RPJust : TPrintJustify);
  Var
    FontHeight  : Integer;
  Begin
    With ThisRect do
    Begin
      TY:=Bottom;

      Case RPJust of
        pjCenter  :  TX:=Round((Right-Left)/2)+Left;
        pjRight  :  TX:=Right;
        else        TX:=Left;
      end; {Case..}
    end; {With..}
  end; {Proc..}

  function RPJust2DT(RPJust : TPrintJustify) : Byte;
  Begin
    Case RPJust of
      pjCenter  :  Result:=DT_Center;
      pjRight   :  Result:=DT_Right;
      else         Result:=DT_Left;
    end; {Case..}
  end;

  // HM 17/01/02: Replacement function for TextRect2 that uses standard RAVE
  // commands to allow usage of RAVE PDF/HTML formats.
  Procedure ExtTextRect2(ftText : ShortString; Const ftJustify : TPrintJustify; Const ftLeft, ftTop, ftWidth, ftHeight : Double; Const VCenter : Boolean = FALSE);
  Var
    TempYPos            : Double;
    ThisRect            :  TRect;

    // String to Float conversion function which supports '-' signs on right
    // hand edge of number
    Procedure StrToDouble(StrNum : String30; Var StrOK : Boolean; Var RNum : Double; Var NoDecs : Byte);
    Var
      Neg  : Boolean;
      Chk  : Integer;
    Begin { StrToDouble }
      StrOK  := FALSE;
      Rnum   := 0.00;
      NoDecs := 0;
      Neg    := False;

      // strip off any spaces
      StrNum := Trim(StrNum);

      // Remove any 000's commas as they cause problems too
      If (Length(StrNum) > 0) Then
        While (Pos(',', StrNum) > 0) Do
          Delete (StrNum, Pos(',', StrNum), 1);

      // Check for -ve sign
      If (Length(StrNum) > 0) Then
        If (StrNum[Length(StrNum)] = '-') Then Begin
          Neg := True;
          Delete (StrNum, Length(StrNum), 1);
        End; { If (StrNum[Length(StrNum)] = '-') }

      If (StrNum <> '') Then Begin
        If (Pos ('.', StrNum) > 0) Then Begin
          // Calculate number of decimal places in string
          NoDecs := Length(StrNum) - Pos ('.', StrNum);
        End; { If }

        // Convert string to float with error checking
        Val (StrNum, Rnum, Chk);
        StrOK := (Chk = 0);

        // Restore -ve sign to number
        If StrOK And Neg Then RNum := -RNum;
      End { If (StrNum <> '')  }
      Else
        StrOK:=True;
    End; { StrToDouble }

    // Squashes the text down so that it fits within the column without loss
    Procedure SquashText;
    Var
      sStr                : ANSIString;
      FieldMask, BaseMask : String255;
      Rect                : TRect;
      PaintFlags          : Word;
      RNum                : Double;
      NoDecs, I           : Byte;
      bOK : boolean;
    Begin { SquashText }
      With RepFiler1 Do Begin
        // Trim text based on justification before checking whether it will fit
        Case ftJustify Of
          pjLeft   : ftText := TrimRight(ftText);
          pjCenter : ftText := Trim(ftText);
          pjRight  : ftText := TrimLeft(ftText);
        End; { Case }

        // Check whether text will fit or not
        If (TextWidth(ftText) > ftWidth) Then Begin
          // Won't fit - determine whether text is text or number
          StrToDouble (ftText, bOK, RNum, NoDecs);
          If bOK Then Begin
            // Number - check whether Integer or Floating Point
            If (System.Pos ('.', ftText) > 0) Then Begin
              // Floating Point - 1) Retry without commas, but with full number
              //                  2) Incrementally reduce decimals
              //                  3) Display #'s like MS Excel

              // 1) Reformat without any thousands separators to see if that will fit
              While (System.Pos (',', ftText) > 0) Do
                System.Delete (ftText, System.Pos (',', ftText), 1);

              If (TextWidth(ftText) > ftWidth) Then Begin
                // 2) reduce the decs - retry at full decs just in case the formatting is different
                { Generate a new formatting mask without commas }
                BaseMask := GenRealMask;
                While (System.Pos (',', BaseMask) > 0) Do System.Delete (BaseMask, System.Pos (',', BaseMask), 1);

                For I := NoDecs DownTo 0 Do Begin
                  { Generate a new mask with the correct decimals }
                  FieldMask := FormatDecStrSD(I, BaseMask, FALSE);

                  { reformat field into what it should look like }
                  ftText := FormatFloat (FieldMask, Round_Up(RNum, I));

                  If (TextWidth(ftText) < ftWidth) Then Break;
                End; { For I }
              End; { If (TextWidth(ftText) > ftWidth) }
            End; { If (Pos ('.', ftText) > 0) }

            If (TextWidth(ftText) > ftWidth) Then
              // No way to shorten string without misleading users so
              // display ### like MS Excel to indicate the field can't fit
              // NOTE: Integers just display ###'s if they don't fit
              ftText := StringOfChar ('#', Trunc(ftWidth / TextWidth('#')));
          End { If bOK }
          Else
            // Normal string - trim off characters until fits
            While (ftText <> '') And (TextWidth(ftText) > ftWidth) Do
              System.Delete (ftText, Length(ftText), 1);
        End; { If (TextWidth(ftText) > ftWidth) }
      End; { With RepFiler1 }
    End; { SquashText }

  Begin { ExtTextRect2 }
    With RepFiler1 Do Begin
      // 'Adjust' text to ensure that it will fit correctly within the column
      SquashText;

      // Check RDevRec to determine how to print the text - stick with old method for Preview,
      // Printer and Adobe, and use the new method for RAVE PDF/HTML only.
// HM 01/08/03 (EN552XL): Extended to use standard commands for export to Excel (Preview & File)
// HM 22/03/04: Extended for Print to HTML support
      If ((RDevRec.fePrintMethod = 2) And (RDevRec.feEmailAtType In [2, 3])) Or
          (RDevRec.fePrintMethod = 5) Or (RDevRec.fePrintMethod = 7) Then Begin
        // Sending Email with either RAVE PDF or RAVE HTML format attachments - use
        // standard RAVE commands to allow Renderer components to convert output
        TempYPos := YD2U(CursorYPos);

        With TMemoBuf.Create Do
          Try
            BaseReport := RepFiler1;

            If (RDevRec.fePrintMethod = 5) and (ftJustify=pjRight) then
            Begin
              Justify := pjLeft;

              { Excel does not like right justification, or the minus at the end of the figure. Alter both factors
                 when outputting to excel }

              If (ftText[Length(ftText)]='-') then
                Text:='-'+Copy(ftText,1,Pred(Length(ftText)))
              else
                Text:=ftText;

              Text:=Strip('A',[ThousandSeparator],Text);
            end
            else
            Begin
              Text := ftText;
              Justify := ftJustify;
            end;

            FontTop := ftTop;
            PrintStart := ftLeft;
            PrintEnd := ftLeft + ftWidth;

            PrintHeight(ftHeight, False);
          Finally
            Free;
          End;

        GotoXY (CursorXPos, TempYPos);
      End { If (RDevRec.fePrintMethod = 2) And (RDevRec.feEmailAtType In [2, 3]) }
      Else Begin
        // Standard routine for Preview/Printer/Adobe Acrobat support
        ThisRect := CreateRect(ftLeft, ftTop, ftLeft + ftWidth, ftTop + ftHeight);

        RPJustXY(ThisX,ThisY,ThisRect,ftJustify);

        TextRect2 (ThisRect,                        // Clipping Rectangle
                   XD2U(ThisX),                     // X Start Position
                   YD2U(ThisY),                     // Y Start Postion
                   RPJust2DT(ftJustify),            // Justification
                   ftText);                         // Text
      End; { Else }
    End; { With TheReport }
  End; { ExtTextRect2 }


Begin
  ThisText:='';

  With RepFiler1 do
  Begin
    ThisCol:=0;
    ThisX:=0;
    ThisY:=0;
    TAbort:=FALSE;
    ProcessLn:=ThisLine;
    ThisPos2:=Pos(#9,ProcessLn);

    While (ThisPos2<>0) and (Not TAbort) do
    Begin
      Inc(ThisCol);
      ThisPos:=ThisPos2;
      Delete(ProcessLn,ThisPos,1);
      ThisPos2:=Pos(#9,ProcessLn);

      If (ThisPos2=0) then
      Begin
        ThisPos2:=Succ(Length(ProcessLn));
        TAbort:=TRUE;
      end;

      If (ThisPos2>ThisPos) then {* Only print if there is data there *}
      Begin
        ThisText:=Copy(ProcessLn,ThisPos,ThisPos2-ThisPos);
        ThisTab:=GetTab(ThisCol);

        If (Assigned(ThisTab)) then
        begin
          With ThisTab^ do
          Begin
            Tab(NA,NA,NA,NA,NA);

            ExtTextRect2 (ThisText,
                          Justify,
                          TabStart(ThisCol),                    // Left
                          YD2U(CursorYPos)-(LineHeight)+1,      // Top
                          TabEnd(ThisCol)-TabStart(ThisCol),    // Width
                          LineHeight);                          // Height

          end;{with}
        end;{if}
      end;{if}
    end; {While..}
  end;
end; {Proc..}

end.
