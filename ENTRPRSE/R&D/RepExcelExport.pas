Unit RepExcelExport;

Interface

Uses Classes, Graphics, SysUtils, Windows, RpDefine, ZEXMLSS, ZSSPXML, ZEXLSX, ProcMonDebugOutput;

const
  //Constants for value to increment row array by in EndLine to avoid out of memory error
  XLSX_INC_ROWS_BY_DEFAULT = 500000;
  XLSX_INC_ROWS_FILENAME = 'xlrows.ini';

  //PR: 01/12/2017 ABSEXCH-19450 Non-printable chars to remove from
  //text before sending it to Excel
  //Source: https://www.thoughtco.com/remove-non-printable-characters-3123798
  NonPrintableChars = [#0..#31, #127, #129, #143, #144, #157];


Type
  TXLSXDataType = (dtString, dtFloat, dtInteger);



  TExportReportToExcel = Class(TObject)
  Private
    // Instance of XLSX writer object
    XMLSS: TZEXMLSS;

    // Reference to worksheet object within XMLSS that we are exporting the report into
    oWorksheet : TZSheet;

    // Coords of active cell within the worksheet
    CurrentRow : Integer;
    CurrentCol : Integer;

    // Left hand margin in MM from Report
    FMarginLeft : Double;

    // Array of column alignments, this is used when printing each cell as the alignment is
    // set at the cell level when exporting
    FColumnAlignments : Array of TPrintJustify;

    //value to increment row array by in EndLine to avoid out of memory error (ABSEXCH-12521)
    FIncRowsBy : Integer;

    // Optional debug output to SysInterals ProcessMonitor controlled by command line parameter /XLSXDebug
    oProcessMonitorLogger : TProcessMonitorLogger;
    Procedure Log (Const LogMessage : String);

    // Returns the index of the specified style in the list of styles, if not present the
    // new style is added into the list
    Function GetStyleIndex (Const FontName : String;
                            Const FontSize : Double;
                            Const FontBold, FontItalic, FontUnderLine : Boolean;
                            Const CellJustification : TPrintJustify;
                            Const StyleFormatting : String) : Integer;
  Public
    //PR: 12/08/2016 ABSEXCH-12521 Made PosToColumnNumber & PrintCell public, so they can be used in VRW.

    // Works out which column will contain a MM based position
    Function PosToColumnNumber (Const PosInMM : Double) : Integer;

    // Populates the specified Cell in the active row with the specified text using the specified
    // font and justification details.  The supplied text is analysed to determine whether it is
    // a date or number and the cell formatting adjusted accordingly
    Procedure PrintCell (Const ColNumber : Integer;
                         Const ThisText : String;
                         Const FontName : String;
                         Const FontSize : Double;
                         Const FontBold, FontItalic, FontUnderLine : Boolean;
                         Const CellJustification : TPrintJustify
                        {$IFDEF REP_ENGINE}
                        ; DataType : TXLSXDataType = dtString
                        {$ENDIF REP_ENGINE});

    // Left margin from printed report - needed to accurately position fields using a MM position
    Property MarginLeft : Double Read FMarginLeft Write FMarginLeft;

    Constructor Create;
    Destructor Destroy; Override;

    // Called to move the current cell to the start of the current row
    Procedure StartLine;
    // Called at the end of each line to move to the next row
    Procedure EndLine;

    // Replacement for call to RAVE TBaseReport.Print redirects it to the XLSX conversion thingie
    // Appends text to the current cell
    Procedure Print(Const ThisText: string;
                    Const FontName : String;
                    Const FontSize : Double;
                    Const FontBold, FontItalic, FontUnderLine : Boolean);

    // Prints a centred piece of text in the column containing the specified MM position
    Procedure PrintCenter(Const ThisText : String;
                          Const Pos : Double;
                          Const FontName : String;
                          Const FontSize : Double;
                          Const FontBold, FontItalic, FontUnderLine : Boolean);

    // Prints a left aligned piece of text in the first column
    Procedure PrintLeft(Const ThisText : String;
                        Const FontName : String;
                        Const FontSize : Double;
                        Const FontBold, FontItalic, FontUnderLine : Boolean);

    // Prints a right aligned piece of text in the last column
    Procedure PrintRight(Const ThisText : String;
                         Const FontName : String;
                         Const FontSize : Double;
                         Const FontBold, FontItalic, FontUnderLine : Boolean);

    // Populates the Active Cell with the specified text using the specified font details
    Procedure PrintColumn (Const ThisText : String;
                           Const FontName : String;
                           Const FontSize : Double;
                                 FontBold, FontItalic, FontUnderLine : Boolean);

    // Creates the .xlsx file in the specified path
    Procedure SaveToFile (Const DestinationFilename : ANSIString);

    // Called to format the columns based on the report's tab settings
    Procedure SetColumnWidth(Const ColumnNo : Integer; Const ColumnWidth : Integer; Const Justification : TPrintJustify; Const UpdateExistingTabs : Boolean);

    //value to increment row array by in EndLine to avoid out of memory error
    property IncrementRowsBy : Integer read FIncRowsBy write FIncRowsBy;
  End; // TExportReportToExcel

Implementation

Uses AbZipKit, AbUtils, AbArcTyp, ETDateU, APIUtil;

//=========================================================================

Constructor TExportReportToExcel.Create;
Begin // Create
  Inherited Create;

  FMarginLeft := 0.0;

  // Optional debug output to SysInterals ProcessMonitor controlled by command line parameter /XLSXDebug
  If FindCmdLineSwitch('XLSXDebug', ['-', '/', '\'], True) Then
    oProcessMonitorLogger := TProcessMonitorLogger.Create
  Else
    oProcessMonitorLogger := NIL;

  // Create an instance of the Export to XLSX component
  XMLSS := TZEXMLSS.Create(nil);

  // Create the worksheet to contain the report
  XMLSS.Sheets.Count := 1;
  oWorksheet := XMLSS.Sheets[0];
  oWorksheet.Title := 'Exchequer Report';

  // Setup local dynamic array to contain the column alignment details
  SetLength(FColumnAlignments, 0);

  //Set initial rows to a low figure for first EndLine (below) to allow caller to set increment rows after creation
  FIncRowsBy := 2;

  // Set the starting position and create the first rows
  CurrentCol := 0;
  CurrentRow := 0;
  EndLine;

  //Set increment rows to default value; caller can override if necessary
  FIncRowsBy := XLSX_INC_ROWS_BY_DEFAULT;
End; // Create

//------------------------------

Destructor TExportReportToExcel.Destroy;
Begin // Destroy
  FreeAndNil(XMLSS);

  SetLength(FColumnAlignments, 0);
  FColumnAlignments := nil;

  FreeAndNIL(oProcessMonitorLogger);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// A .xlsx file contains a list of 'Styles' which define the font and alignment settings, each
// cell is linked to a specified style to control its font/alignment.
//
// This function returns the index of the specified style in the list of styles, if not present
// the new style is added into the list
Function TExportReportToExcel.GetStyleIndex (Const FontName : String;
                                             Const FontSize : Double;
                                             Const FontBold, FontItalic, FontUnderLine : Boolean;
                                             Const CellJustification : TPrintJustify;
                                             Const StyleFormatting : String) : Integer;
Var
  oStyle : TZStyle;
  FSize, I : Integer;
  IsBold, IsItalic, IsUnderline : Boolean;
  Justify : TZHorizontalAlignment; // (ZHAutomatic, ZHLeft, ZHCenter, ZHRight, ZHFill, ZHJustify, ZHCenterAcrossSelection, ZHDistributed, ZHJustifyDistributed);
Begin // GetStyleIndex
  Result := -1;

  // Translate the Justification to Zexmlss'ese
  //
  //   TPrintJustify = (pjCenter,pjLeft,pjRight,pjBlock);
  //   TZHorizontalAlignment = (ZHAutomatic, ZHLeft, ZHCenter, ZHRight, ZHFill, ZHJustify, ZHCenterAcrossSelection, ZHDistributed, ZHJustifyDistributed);
  //
  Case CellJustification Of
    pjCenter : Justify := ZHCenter;
    pjLeft   : Justify := ZHLeft;
    pjRight  : Justify := ZHRight;
  Else
    Justify := ZHLeft;
  End; // Case CellJustification

  // Run through the list of existing styles to try and find a matching style
  FSize := Round(FontSize);
  For I := 0 To (XMLSS.Styles.Count - 1) Do
  Begin
    oStyle := XMLSS.Styles[I];
    IsBold := (fsBold In oStyle.Font.Style);
    IsItalic := (fsItalic In oStyle.Font.Style);
    IsUnderline := (fsUnderline In oStyle.Font.Style);

    If (oStyle.Font.Name = FontName) And
       (oStyle.Font.Size = FSize) And
       (oStyle.Alignment.Horizontal = Justify) And
       (oStyle.NumberFormat = StyleFormatting) And
       (FontBold = IsBold) And (FontItalic = IsItalic) And (FontUnderline = IsUnderline) Then
    Begin
      Result := I;
      Break;
    End; // If (oStyle.Font.Name = FontName) And (oStyle.Font.Size = FSize)
  End; // For I

  // Style not found - add it in
  If (Result = -1) Then
  Begin
    // Add a new entry into the Styles array and return that for the cell to use
    XMLSS.Styles.Count := XMLSS.Styles.Count + 1;
    Result := XMLSS.Styles.Count - 1;

    // Get the new style object and set the details
    oStyle := XMLSS.Styles[Result];
    oStyle.Font.Name := FontName;
    oStyle.Font.Size := FSize;
    oStyle.Font.Style := [];
    If FontBold Then oStyle.Font.Style := oStyle.Font.Style + [fsBold];
    If FontItalic Then oStyle.Font.Style := oStyle.Font.Style + [fsItalic];
    If FontUnderLine Then oStyle.Font.Style := oStyle.Font.Style + [fsUnderline];
    oStyle.Alignment.Horizontal := Justify;
    oStyle.NumberFormat := StyleFormatting;
  End; // If (Result = -1)
End; // GetStyleIndex

//-------------------------------------------------------------------------

// Optional debug output to SysInterals ProcessMonitor controlled by command line parameter /XLSXDebug.
//
// This is used when it crashes creating the report to determine what it was doing at the time of
// the crash - as the export is running within a thread the Delphi Debugger tends to die extremely
// badly and is of niminal/no use.
//
Procedure TExportReportToExcel.Log (Const LogMessage : String);
Begin // Log
  If Assigned(oProcessMonitorLogger) Then
    oProcessMonitorLogger.Output(LogMessage);

End; // Log

//-------------------------------------------------------------------------

// Called to format the columns based on the report's tab settings
Procedure TExportReportToExcel.SetColumnWidth(Const ColumnNo : Integer;
                                              Const ColumnWidth : Integer;
                                              Const Justification : TPrintJustify;
                                              Const UpdateExistingTabs : Boolean);
Begin // SetColumnWidth
  // Debug Logging
  Log('SetColumnWidth (ColumnNo=' + IntToStr(ColumnNo) + ', ColumnWidth=' + IntToStr(ColumnWidth) + ', Justification=' + IntToStr(Ord(Justification)) + ')');

  // Check whether we need to add a new column
  If (ColumnNo >= oWorksheet.ColCount) Then
    oWorksheet.ColCount := oWorksheet.ColCount + 1;

  // If UpdateExistingTabs = True then only make column wider, do not narrow the column
  // as it has already been used for something else
  If (Not UpdateExistingTabs) Or (oWorksheet.Columns[ColumnNo].WidthMM < (ColumnWidth + 2)) Then
    // Set the columns width - HACK: Add 2mm so dates display properly
    oWorksheet.Columns[ColumnNo].WidthMM := ColumnWidth + 2;

  // Increase size of dynamic array storing the alignment as required
  If (Length(FColumnAlignments) <= ColumnNo) Then
  Begin
    SetLength(FColumnAlignments, ColumnNo + 1);
    FColumnAlignments[ColumnNo] := Justification;  // TPrintJustify = (pjCenter,pjLeft,pjRight,pjBlock);
  End; // If (Length(FColumnAlignments) <= ColumnNo)
  
  If (Not UpdateExistingTabs) Then
    FColumnAlignments[ColumnNo] := Justification;  // TPrintJustify = (pjCenter,pjLeft,pjRight,pjBlock);
End; // SetColumnWidth

//------------------------------

// Works out which column will contain a MM based position
Function TExportReportToExcel.PosToColumnNumber (Const PosInMM : Double) : Integer;
Var
  iCol : Integer;
  iPos : Double;
Begin // PosToColumnNumber
  Result := 0;

  iPos := FMarginLeft;
  For iCol := 0 To (oWorksheet.ColCount - 1) Do
  Begin
    // Work out where this column ends and see if the specified position is within it
    iPos := iPos + oWorksheet.Columns[iCol].WidthMM;
    If (iPos >= PosInMM) Then
    Begin
      Result := iCol;
      Break;
    End; // If (iPos >= PosInMM)
  End; // For iCol
  Log(Format('Pos=%8.2f Col=%d', [PosInMM, Result]));
End; // PosToColumnNumber

//-------------------------------------------------------------------------

// Populates the specified Cell in the active row with the specified text using the specified
// font and justification details.  The supplied text is analysed to determine whether it is
// a date or number and the cell formatting adjusted accordingly
Procedure TExportReportToExcel.PrintCell (Const ColNumber : Integer;
                                          Const ThisText : String;
                                          Const FontName : String;
                                          Const FontSize : Double;
                                          Const FontBold, FontItalic, FontUnderLine : Boolean;
                                          Const CellJustification : TPrintJustify
                                          {$IFDEF REP_ENGINE}
                                          ; DataType : TXLSXDataType = dtString
                                          {$ENDIF REP_ENGINE});
Var
  oCell : TZCell;
  CellText : String;
  StyleFormatting : String;

  //------------------------------

  Function IsDate (Var ThisText : String) : Boolean;
  Var
    sDate : String;
  Begin // IsDate
    Result := Length(ThisText) = 10;

    If Result Then
    Begin
      // Perform some basic checks on the string to ensure it is a date
      If (ShortDateFormat = UKDateFormat) Then
      Begin
        // UK Date format - 'DD/MM/YYYY'
        Result := (ThisText[1] In ['0'..'3']) And   // D
                  (ThisText[2] In ['0'..'9']) And   // D
                  (ThisText[3] = '/') And
                  (ThisText[4] In ['0'..'1']) And   // M
                  (ThisText[5] In ['0'..'9']) And   // M
                  (ThisText[6] = '/') And
                  (ThisText[7] In ['1'..'2']) And   // Y
                  (ThisText[8] In ['0'..'9']) And   // Y
                  (ThisText[9] In ['0'..'9']) And   // Y
                  (ThisText[10] In ['0'..'9']);     // Y

        If Result Then
          // Create a copy in YYYYMMDD format for validation
          sDate := Copy (ThisText, 7, 4) + Copy (ThisText, 4, 2) + Copy (ThisText, 1, 2);
      End // If (ShortDateFormat = UKDateFormat)
      Else If (ShortDateFormat = USDateFormat) Then
      Begin
        // US Date format - 'MM/DD/YYYY'
        Result := (ThisText[1] In ['0'..'1']) And   // M
                  (ThisText[2] In ['0'..'9']) And   // M
                  (ThisText[3] = '/') And
                  (ThisText[4] In ['0'..'3']) And   // D
                  (ThisText[5] In ['0'..'9']) And   // D
                  (ThisText[6] = '/') And
                  (ThisText[7] In ['1'..'2']) And   // Y
                  (ThisText[8] In ['0'..'9']) And   // Y
                  (ThisText[9] In ['0'..'9']) And   // Y
                  (ThisText[10] In ['0'..'9']);     // Y

        If Result Then
          // Create a copy in YYYYMMDD format for validation
          sDate := Copy (ThisText, 7, 4) + Copy (ThisText, 1, 2) + Copy (ThisText, 4, 2);
      End // If (ShortDateFormat = USDateFormat)
      Else If (ShortDateFormat = JADateFormat) Then
      Begin
        // Japanese Date Format - 'YYYY/MM/DD'
        Result := (ThisText[1] In ['1'..'2']) And   // Y
                  (ThisText[2] In ['0'..'9']) And   // Y
                  (ThisText[3] In ['0'..'9']) And   // Y
                  (ThisText[4] In ['0'..'9']) And   // Y
                  (ThisText[5] = '/') And
                  (ThisText[6] In ['0'..'1']) And   // M
                  (ThisText[7] In ['0'..'9']) And   // M
                  (ThisText[8] = '/') And
                  (ThisText[9] In ['0'..'3']) And   // D
                  (ThisText[10] In ['0'..'9']);     // D

        If Result Then
          // Create a copy in YYYYMMDD format for validation
          sDate := Copy (ThisText, 1, 4) + Copy (ThisText, 6, 2) + Copy (ThisText, 9, 2);
      End // If (ShortDateFormat = JADateFormat)
      Else
        Result := False;
    End; // If Result

    If Result Then
    Begin
      Result := ValidDate(sDate);
      If Result Then
      Begin
        // Modify the cell contents to YYYYMMDD format as this is apparently what Excel expects
        ThisText := sDate;
      End; // If Result
    End; // If Result
  End; // IsDate

  //------------------------------

  // Returns TRUE if the supplied ThisText contains a number and returns a reformatted
  // version along with a Format String to be applied to the Cell's Style
  Function IsFloat (Var ThisText, StyleFormatting : String) : Boolean;
  Var
    sNumber : String;
    FloatVal : Double;
    I, iDecs, iPos : Integer;
    lDecimalFound : Boolean; //AP : 03/02/2017 2017-R1 ABSEXCH-18146 : Intrastat report - Access violation at non floating point value
  Begin // IsFloat
    sNumber := Trim(ThisText);
    iDecs := 0; //PR: 22/03/2016 v2016 R2 ABSEXCH-17390 Moved from below to avoid warnings

    // Run through the string checking that it contains valid characters
    If (sNumber <> '') Then
    Begin
      Result := True;
      //AP : 03/02/2017 2017-R1 ABSEXCH-18146 : Intrastat report - Access violation at non floating point value
      lDecimalFound := False;

      For I := 1 To Length(sNumber) Do
      begin
        //AP : 03/02/2017 2017-R1 ABSEXCH-18146 : Intrastat report - Access violation at non floating point value
        If (Not (sNumber[I] In ['0'..'9', '-', ThousandSeparator, DecimalSeparator])) or
           (lDecimalFound and ((sNumber[I] = DecimalSeparator) or (sNumber[I] = ThousandSeparator))) Then
        Begin
          Result := False;
          Break;
        End; // If (Not (sNumber[I] In ['0'..'9', DecimalSeparator]))

        //AP : 03/02/2017 2017-R1 ABSEXCH-18146 : Intrastat report - Access violation at non floating point value
        if sNumber[I] = DecimalSeparator then
          lDecimalFound := True;

        //AP : 01/02/2017 2017-R1 ABSEXCH-18146 : Intrastat report - Check for the '-' in middle of the string
        if ((I>1) and (I<Length(sNumber))) and (sNumber[I] = '-') then
        Begin
          Result := False;
          Break;
        End;

      end;
    End // If (sNumber <> '')
    Else
      // Blank string = not number
      Result := False;

    If Result And (Length(sNumber) > 4) Then
    Begin
      // Try to eliminate false positives on numeric Account codes, stock codes, yourref's etc...
      //
      // A formatted floating point number of 5+ digits will have either '.' or ',' in it
      //
      // e.g. 0.00
      //      1.23-
      //      12.23
      //      1,234
      //
      If (Pos(DecimalSeparator, sNumber) = 0) And (Pos(ThousandSeparator, sNumber) = 0) Then
        // No commas or decimals - probably not a number
        Result := False;  
    End; // If Result And (Length(sNumber) > 4)

    {$IFDEF REP_ENGINE}
     Result := DataType in [dtFloat, dtInteger];
    {$ENDIF REP_ENGINE}

    If Result Then
    Begin
      // Excel requires the '-' sign to be at the start, not the end
      If (sNumber[Length(sNumber)] = '-') Then
        sNumber := '-' + Copy(sNumber, 1, Length(sNumber) - 1);

      // Excel also has a problem if we supply the commas
      sNumber := StringReplace(sNumber, ThousandSeparator, '', [rfReplaceAll]);

      // Count Decimal Places so we can customise the formatting
      iPos := Pos(DecimalSeparator, sNumber);
      If (iPos > 0) Then
      Begin
        For I := (iPos + 1) To Length(sNumber) Do
        Begin
          If (sNumber[I] In ['0'..'9']) Then
            iDecs := iDecs + 1
          Else
            Break;
        End; // For I
      End; // If (iPos > 0)
    End; // If Result

    If Result Then
    Begin
      // Need to generate the correct number of decimal places on the format string - use the number
      // of decimals off the original string as a guide
      //
      // Excel expects a format like this:- '[RED][<0]0.000;[GREEN][>100]0.000;[BLUE]0.000' or '#,##0.00;-#,##0.00'
      //
      If (iDecs > 0) Then
        StyleFormatting := '#,##0.' + StringOfChar('0', iDecs) + ';-#,##0.' + StringOfChar('0', iDecs)
      Else
        StyleFormatting := '#,##0;-#,##0';

      Try
        // Need to convert the string to float as a last step validation, an exception will be
        // raised if the modified string isn't a valid number, e.g. 74.125.224.72 will pass the
        // tests above, but isn't a valid floating point or integer number
        FloatVal := StrToFloat(sNumber);
        ThisText := sNumber;
      Except
        On Exception Do
          Result := False;
      End; // Try..Except
    End; // If Result
  End; // IsFloat

  //------------------------------

  //PR: 01/12/2017 ABSEXCH-19450 Non-printable chars to remove from
  //text before sending it to Excel
  function CleanText(const s : string) : string;
  var
    i : integer;
  begin
    Result := s;
    i := 1;
    while (i <= Length(Result)) do
    begin
      if Result[i] in NonPrintableChars then
        Delete(Result, i, 1);
      inc(i);
    end;
  end;

Begin // PrintCell
//If (CurrentRow <= 3) Then
//Begin
  // Debug Logging
  Log('PrintCell (ColNumber=' + IntToStr(ColNumber) + ', ThisText=' + ThisText + ', CellJustification=' + IntToStr(Ord(CellJustification)) + ')');

  If (Trim(ThisText) <> '') Then
  Begin
    // Get a local reference to the cell we are going to write to
    oCell := oWorksheet.Cell[ColNumber, CurrentRow];

    // Copy the text into a local variable as we need to play with it for certain fields
    CellText := CleanText(ThisText);

    // Custom format strings are stored against the Style not the Cell
    StyleFormatting := '';

    //AP : 01/02/2017 2017-R1 ABSEXCH-18146 : Intrastat report output to Excel fails with an Application error - Irish editions only
    if Assigned(oCell) then
    begin
      // Check to see if it is a date
      If IsDate(CellText) Then
      Begin
        // Date - write to the cell and format as a date - IsDate will have adjusted the CellText
        // contents as required by Excel
        Log('  IsDate (CellText=' + CellText + ')');
        oCell.CellType := ZEDateTime;
        oCell.Data := CellText;
      End // If IsDate(ThisText)
      // Otherwise check to see if it is a number - IsFloat is currently handling Integer numbers as well
      Else If IsFloat(CellText, StyleFormatting) Then
      Begin
        // Number - Float or Integer - write to the cell and format as a number - IsFloat will have
        // adjusted the CellText contents as required by Excel and dynamically generated an
        // appropriate StyleFormatting string for the cell
        Log('  IsFloat (CellText=' + CellText + ', StyleFormatting=' + StyleFormatting + ')');
        oCell.CellType := ZENumber;
        oCell.Data := CellText;
      End // If IsFloat(ThisText)
      Else
      Begin
        // No idea - treat as text
        oCell.CellType := ZEString;
        oCell.Data := Trim(CellText);
      End; // Else

      // Lookup the correct style in the styles list for the supplied font details
      oCell.CellStyle := GetStyleIndex (FontName, FontSize, FontBold, FontItalic, FontUnderLine, CellJustification, StyleFormatting);
    end;    
  End; // If (Trim(ThisText) <> '')
//End;
End; // PrintCell

//------------------------------

// Replacement for call to RAVE TBaseReport.Print redirects it to the XLSX conversion thingie
// Appends text to the current cell
Procedure TExportReportToExcel.Print(Const ThisText: string;
                                     Const FontName : String;
                                     Const FontSize : Double;
                                     Const FontBold, FontItalic, FontUnderLine : Boolean);
Var
  NewCellText : String;
Begin // Print
  Log('Print(ThisText=' + ThisText + ')  (CurrentCol=' + IntToStr(CurrentCol) + ', CurrentRow=' + IntToStr(CurrentRow) + ')');

  // Append the new text to the existing contents of the cell
  NewCellText := oWorksheet.Cell[CurrentCol, CurrentRow].Data + ThisText;

  PrintCell (CurrentCol, NewCellText, FontName, FontSize, FontBold, FontItalic, FontUnderLine, pjLeft);
End; // Print

//------------------------------

// Prints a centred piece of text in the column containing the specified MM position
Procedure TExportReportToExcel.PrintCenter(Const ThisText : String;
                                           Const Pos : Double;
                                           Const FontName : String;
                                           Const FontSize : Double;
                                           Const FontBold, FontItalic, FontUnderLine : Boolean);
Begin // PrintCenter
  Log('PrintCenter(ThisText=' + ThisText + ', Pos=' + FloatToStr(Pos) + ')  (CurrentCol=' + IntToStr(CurrentCol) + ', CurrentRow=' + IntToStr(CurrentRow) + ')');

  PrintCell (PosToColumnNumber(Pos), ThisText, FontName, FontSize, FontBold, FontItalic, FontUnderLine, pjCenter);
End; // PrintCenter

//------------------------------

// Prints a left aligned piece of text in the first column
Procedure TExportReportToExcel.PrintLeft(Const ThisText : String;
                                         Const FontName : String;
                                         Const FontSize : Double;
                                         Const FontBold, FontItalic, FontUnderLine : Boolean);
Begin // PrintLeft
  Log('PrintLeft(ThisText=' + ThisText + ')  (CurrentCol=' + IntToStr(CurrentCol) + ', CurrentRow=' + IntToStr(CurrentRow) + ')');

  PrintCell (0, ThisText, FontName, FontSize, FontBold, FontItalic, FontUnderLine, pjLeft);
End; // PrintLeft

//------------------------------

// Prints a right aligned piece of text in the last column
Procedure TExportReportToExcel.PrintRight(Const ThisText : String;
                                          Const FontName : String;
                                          Const FontSize : Double;
                                          Const FontBold, FontItalic, FontUnderLine : Boolean);
Begin // PrintRight
  Log('PrintRight(ThisText=' + ThisText + ')  (CurrentCol=' + IntToStr(CurrentCol) + ', CurrentRow=' + IntToStr(CurrentRow) + ')');

  PrintCell (oWorksheet.ColCount - 1, ThisText, FontName, FontSize, FontBold, FontItalic, FontUnderLine, pjRight);
End; // PrintRight

//------------------------------

// Populates the Active Cell with the specified text using the specified font details
Procedure TExportReportToExcel.PrintColumn (Const ThisText : String;
                                            Const FontName : String;
                                            Const FontSize : Double;
                                                  FontBold, FontItalic, FontUnderLine : Boolean);
Var
  ColJustification : TPrintJustify;
Begin // PrintColumn
  Log('PrintColumn(ThisText=' + ThisText + ')  (CurrentCol=' + IntToStr(CurrentCol) + ', CurrentRow=' + IntToStr(CurrentRow) + ')');

  // Check whether we need to add a new column
  If (CurrentCol >= oWorksheet.ColCount) Then
    oWorksheet.ColCount := oWorksheet.ColCount + 1;

  // Need to specifically check otherwise a faulty report can crash with a range check error - this
  // is then a major PITA to track down
  If (CurrentCol <= High(FColumnAlignments)) Then
    ColJustification := FColumnAlignments[CurrentCol]
  Else
  Begin
    // Column not defined properly - assume Left Justifcation and sett to Bold/Italic/Unerline to highlight
    ColJustification := pjLeft;
    FontBold := True;
    FontItalic := True;
    FontUnderLine := True;
  End; // Else

  PrintCell (CurrentCol, ThisText, FontName, FontSize, FontBold, FontItalic, FontUnderLine, ColJustification);

  CurrentCol := CurrentCol + 1;
End; // PrintColumn

//-------------------------------------------------------------------------

// Called to move the current cell to the start of the current row
Procedure TExportReportToExcel.StartLine;
Begin // StartLine
  Log('StartLine  (CurrentCol=' + IntToStr(CurrentCol) + ', CurrentRow=' + IntToStr(CurrentRow) + ')');

  CurrentCol := 0;
End; // StartLine

//-------------------------------------------------------------------------

// Called at the end of each line to move to the next row
Procedure TExportReportToExcel.EndLine;
Begin // EndLine
  Log('EndLine  (CurrentCol=' + IntToStr(CurrentCol) + ', CurrentRow=' + IntToStr(CurrentRow) + ')');

  // Move to the first column in the new row
  CurrentRow := CurrentRow + 1;
  CurrentCol := 0;

  If (CurrentRow >= oWorksheet.RowCount) Then
    // Add a new batch of row - add multiple rows to improve performance
    oWorksheet.RowCount := oWorksheet.RowCount + FIncRowsBy;  
End; // EndLine

//-------------------------------------------------------------------------

// Creates the .xlsx file in the specified path
Procedure TExportReportToExcel.SaveToFile (Const DestinationFilename : ANSIString);
Var
  TextConverter: TAnsiToCPConverter;
  AbZipKit1 : TAbZipKit;
  sTempDir, sXLSXFile : ANSIString;

  //------------------------------

  Function CreateTempDirPath : String;
  Var
    sPath : String;
    Uid : TGuid;
    Res : HResult;
    OK : Boolean;
  Begin // CreateTempDirPath
    Repeat
      // Put all the temporary directories into an ExchXLSX directory in the temporary files
      // directory to make manually clearing them up easier if necessary
      sPath := WinGetWindowsTempDir + 'ExchXLSX\';

      // Use a GUID to create a unique directory name, if the GUID creation fails then fallback
      // to using a date-time stamp instead
      Res := CreateGuid(Uid);
      If (Res = S_OK) Then
        sPath := sPath + GuidToString(Uid)
      Else
        sPath := sPath + FormatDateTime('yyyymmddhhnnsszz', Now);

      If (Not DirectoryExists(sPath)) Then
        // Create directory and parent ExchXLSX directory if necessary
        OK := ForceDirectories(sPath)
      Else
        OK := False;
    Until OK;

    Result := IncludeTrailingPathDelimiter(sPath);
  End; // CreateTempDirPath

  //------------------------------

  function FileSize(const FileName: string): Int64;
  var
    AttributeData: TWin32FileAttributeData;
  begin
    if GetFileAttributesEx(PChar(FileName), GetFileExInfoStandard, @AttributeData) then
    begin
      Int64Rec(Result).Lo := AttributeData.nFileSizeLow;
      Int64Rec(Result).Hi := AttributeData.nFileSizeHigh;
    end
    else
      Result := -1;
  end;

  //------------------------------

Begin // SaveToFile
  Log('SaveToFile(DestinationFilename=' + DestinationFilename + ')');

  // Trim off any unused rows at the end
  If (CurrentRow < oWorksheet.RowCount) Then
    oWorksheet.RowCount := CurrentRow + 1;

  // Create a new directory off the Temporary Files directory for the numerous files across XL and
  // three subdirectories which need to be zipped into a '.XLSX' file
  sTempDir := CreateTempDirPath;
  sXLSXFile := sTempDir + 'Report.xlsx';
  Try
    // Save all the excel files to the temp directory - this creates numerous files across the directory
    // and subdirectories which need to be zipped into a '.XLSX' file
    TextConverter := @AnsiToUtf8;
    Log('  Creating Excel Files');
    SaveXmlssToXLSXPath(XMLSS, sTempDir, [0, 1], [], TextConverter, 'UTF-8');

    // Zip the excel files we've just created as a .xlsx in the temporary files directory
    AbZipKit1 := TAbZipKit.Create(NIL);
    Try
      Log('  Zipping Excel Files');
      With AbZipKit1 Do
      Begin
        // Getting an exception without this as Abbrevia doesn't know what compression method to use
        ForceType := True;
        ArchiveType := atZip;
        FileName := sXLSXFile;

        // Need to store relative paths within the .ZIP file
        BaseDirectory := sTempDir;
        StoreOptions := [soRecurse, soRemoveDots{, soStripDrive, soStripPath}];

        // Don't convert to short filenames
        DOSMode := False;

        AddFiles ('*.*', 0);

        Save;
      end;{with}
    finally
      AbZipKit1.Free;
    end;{try}

    Log('  Checking For .xlsx');
    If FileExists(sXLSXFile) Then
    Begin
      Log('    ' + sXLSXFile + ' = ' + IntToStr(FileSize(sXLSXFile)) + ' bytes');

      // Copy .xlsx to destination directory and filename specified by user
      Log('    Copying .xlsx');
      // Only copied a 1kb file for the VAT Return, but says it succeeded - seems to be OK for other reprots
      If Windows.CopyFile(PChar(sXLSXFile), PChar(DestinationFilename), False) Then
      Begin
        Log('    Copy Succeeded');
        Log('    ' + DestinationFilename + ' = ' + IntToStr(FileSize(DestinationFilename)) + ' bytes');
      End // If Windows.CopyFile(PChar(sXLSXFile), PChar(DestinationFilename), False)
      Else
        Log('    Copy Failed');
    End // If FileExists(sXLSXFile)
    Else
      Log('    File Not Found');

    // Note: Moved the Auto-open code to a later point in the process that is within the main
    // thread after experiencing numerous problems calling ShellExecute from here
  Finally
    // Inhume directory and contents with extreme prejudice
    Log('  DeleteDirectory(' + sTempDir + ')');
    DeleteDirectory (sTempDir);
  End; // Try..Finally
  Log('SaveToFile Finished');
End; // SaveToFile

//=========================================================================

End.
