unit VRWConverterU;
{
  Implementation of the IVRWConverter interface. Converts a report from the
  original Report Writer format into latest Visual Report Writer format.
}
interface

uses SysUtils, Classes, Types, VRWConverterIF, VRWReportIF, RWRIntF;

type
  TVRWConverter = class(TInterfacedObject, IVRWConverter)
  private
    { --- Property fields --------------------------------------------------- }
    FImportLog: TStringList;
    FReport: IVRWReport;
    FSourceReport: IReportDetails;
    FGridSizeXmm: Integer;
    FGridSizeYmm: Integer;
    FGridSizeXPixels: Integer;
    FGridSizeYPixels: Integer;
    FMinControlHeight: Integer;
    FMinControlWidth: Integer;

    { --- Implementation of property access methods ------------------------- }
    function GetReport: IVRWReport;
    procedure SetReport(Value: IVRWReport);

    function GetSourceReport: IReportDetails;
    procedure SetSourceReport(Value: IReportDetails);

    { --- Support methods --------------------------------------------------- }
    function Validate: Boolean;

    function CalcSize(ForText: ShortString): TPoint;

    function ConvertPrintIfCriteria(
      const OldCriteria: ShortString;
      const FieldName: ShortString;
      const FieldNumber: SmallInt) : ShortString;

    function ConvertSelectionCriteria(
      RangeFilter: IVRWRangeFilter;
      const OldCriteria : ShortString;
      const FieldName : ShortString;
      const FieldNumber : SmallInt): ShortString;

    function ConvertStringSplice(Definition: ShortString): ShortString;

    function CreateDBControl(InRegion: IVRWRegion;
      FromDetails: ReportDetailType; ControlNo: Integer): IVRWFieldControl;

    function CreateFmlControl(InRegion: IVRWRegion;
      FromDetails: ReportDetailType;
      Definition: ShortString;
      IncludeSortOrder: Boolean = True): IVRWFormulaControl;

    function ParseFormula(Definition: ShortString): ShortString;

    procedure Log(LogMsg: string);

  public

    constructor Create;

    destructor Destroy; override;

    { --- Implementation of general methods --------------------------------- }

    { Main entry point. Report and SourceReport must be set before calling this
      method }
    function Execute: LongInt;

  end;

implementation

uses Windows, ShellApi, RptEngDLL, ExtCtrls, Graphics, Inifiles, GlobVar, Forms,
  RPDefine, DDFuncs, RWOpenF, VarConst, VarFPosU;

Const
  // Scaling ratio for designer
  PixelsPerMM = 3;
  PixelsPerInch = PixelsPerMM * 25.4;  // 25.4mm = 1 Inch

{ TVRWConverter }

// Copied and amended from ctrlDrag.pas - CalcInitialSize
function TVRWConverter.CalcSize(ForText: ShortString): TPoint;
Var
  TheRect    : TRect;
  TheText    : ANSIString;
  PaintFlags : Word;
  Image: TImage;

  // Copied from DesignerUtil.pas
  Procedure SetVisFontHeight (VisFont : TFont; PointSize : Integer);
  Const
    PointsPerMM = 0.352778;   { 25.4mm / 72 points per inch }
  begin
    { Calculate pixel height }
    VisFont.Height := -Round (PointsPerMM * PointSize * PixelsPerMM);
  end;

  // Copied from DesignerUtil.pas
  Procedure CanvasDrawText (Const TheCanvas : TCanvas;
                            Const DrawStr   : ShortString;
                            Var   DrawRect  : TRect;
                            Const DrawFlags : Word);
  Var
    TheStr   : PChar;
    TmpStyle : TBrushStyle;
  Begin
    TheStr := StrAlloc (Length (DrawStr) + 1);
    StrPCopy (TheStr, DrawStr);

    TmpStyle := TheCanvas.Brush.Style;
    TheCanvas.Brush.Style := bsClear;

    DrawText(TheCanvas.Handle, TheStr, Length (TheStr), DrawRect, DrawFlags);

    TheCanvas.Brush.Style := TmpStyle;

    StrDispose(TheStr);
  End;

  Function Snap (Const Pixels, GridSize : LongInt) : LongInt;
  Begin // Snap
    Result := (Pixels Div GridSize) * GridSize;
    If ((Pixels Mod GridSize) <> 0) Then
      Result := Result + GridSize;
  End; // Snap

Begin // CalcSize
  Image := TImage.Create(nil);
  try
    // Copy the font details in from the default report font and then scale
    // the font
    Image.Canvas.Font.Name  := FReport.vrFont.Name;
    Image.Canvas.Font.Size  := FReport.vrFont.Size;
    Image.Canvas.Font.Color := FReport.vrFont.Color;
    Image.Canvas.Font.Style := FReport.vrFont.Style;

    SetVisFontHeight (Image.Canvas.Font, Image.Canvas.Font.Size);

    // Get size of font
    TheRect := Rect (1, 1, 2, 2);
    TheText := ForText;
    PaintFlags := DT_CALCRECT Or DT_SINGLELINE;
    CanvasDrawText (Image.Canvas, TheText, TheRect, PaintFlags);

    // Set control size - round sizes up to the nearest grid node
    Result.Y := Snap(TheRect.Bottom - TheRect.Top, FGridSizeYPixels);
    Result.X := Snap(TheRect.Right - TheRect.Left, FGridSizeXPixels);
    if (Result.Y < FMinControlHeight) then
      Result.Y := FMinControlHeight;
    if (Result.X < FMinControlWidth) then
      Result.X := FMinControlWidth;

    // Return the result in mm.
    Result.X := Result.X div PixelsPerMM;
    Result.Y := Result.Y div PixelsPerMM;

  finally
    Image.Free;
  end;
end;

function TVRWConverter.ConvertPrintIfCriteria(
  const OldCriteria: ShortString;
  const FieldName: ShortString;
  const FieldNumber: SmallInt): ShortString;
var
  ssNewSelection : ShortString;
  ssFieldName : ShortString;
  siFieldNamePos, siFieldNameLgth : SmallInt;
  siStartSlice, siEndSlice : SmallInt;
  ssStrSlice : ShortString;
begin
  ssNewSelection := OldCriteria;

  // find all occurances of string slicing in the selection string. eg. [1,3] = 'blah'
  siStartSlice := Pos('[',ssNewSelection); siEndSlice := Pos('=',ssNewSelection);
  if ((siStartSlice > 0) and (siEndSlice > 0)) and (siEndSlice > siStartSlice) then
  begin
    ssStrSlice := Copy(ssNewSelection, siStartSlice, ((siEndSlice - siStartSlice) + 1));
    if (ssStrSlice[2] = '1') then
    begin // BeginsWith
      Delete(ssNewSelection, siStartSlice, ((siEndSlice - siStartSlice) + 1));
      Insert(' BeginsWith', ssNewSelection, siStartSlice);
    end
    else
    begin // Contains
      Delete(ssNewSelection, siStartSlice, ((siEndSlice - siStartSlice) + 1));
      Insert(' Contains', ssNewSelection, siStartSlice);
    end;
  end;

  // find all occurance of Rxx in the selection string. eg. R14 = "PIN"
  ssFieldName := 'R' + IntToStr(FieldNumber);
  siFieldNameLgth := Length(ssFieldName);

  siFieldNamePos := Pos(ssFieldName, ssNewSelection);
  while (siFieldNamePos > 0) do
  begin
    Delete(ssNewSelection, siFieldNamePos, siFieldNameLgth);
    Insert('DBF['+trim(FieldName)+']', ssNewSelection, siFieldNamePos);
    siFieldNamePos := Pos(ssFieldName, ssNewSelection);
  end;

  Result := ssNewSelection;
end;

function TVRWConverter.ConvertSelectionCriteria(
  RangeFilter: IVRWRangeFilter;
  const OldCriteria : ShortString;
  const FieldName : ShortString;
  const FieldNumber : SmallInt): ShortString;
var
  ssInputLineNumber,
  ssInputLineToken : ShortString;

  TokenPos,
  siInputLineIdx : SmallInt;
begin
  // need to establish if this selection has an input line in it or not.
  siInputLineIdx := 0;
  TokenPos := 0;
  if (FSourceReport.rdInputLineCount > 0) then
  repeat
    Inc(siInputLineIdx);
    ssInputLineNumber := IntToStr(siInputLineIdx);
    ssInputLineToken := 'I' + trim(ssInputLineNumber);
    TokenPos := Pos(ssInputLineToken, OldCriteria);
  until (TokenPos > 0) or (siInputLineIdx = FSourceReport.rdInputLineCount);

  if (TokenPos = 0) then
  begin // normal selection criteria
    Result := ConvertPrintIfCriteria(OldCriteria, FieldName, FieldNumber);
  end
  else
  begin // input line
    with RangeFilter, FSourceReport.rdInputLines[siInputLineIdx-1] do
    begin
      rfName := trim(ssInputLineToken); //  TInputLineRecord;  // 412 bytes
      rfDescription := trim(FSourceReport.rdInputLines[siInputLineIdx-1].RepLDesc);
      rfType := FSourceReport.rdInputLines[siInputLineIdx-1].RepLIType;
      rfAlwaysAsk := TRUE;
      case rfType of
        1 : begin // date
              // change yyyymmdd format to ddmmyyyy, hence all the calls to copy()!!
              rfFromValue := Copy(DRange[1],7,2) + Copy(DRange[1],5,2) + Copy(DRange[1],1,4);
              rfToValue := Copy(DRange[2],7,2) + Copy(DRange[2],5,2) + Copy(DRange[2],1,4);
            end;
        2 : begin // period
              rfFromValue := IntToStr(PrRange[1,1]) + '/' + IntToStr(PrRange[1,2]);
              rfToValue := IntToStr(PrRange[2,1]) + '/' + IntToStr(PrRange[2,2]);
            end;
        3 : begin // currency value
              rfFromValue := FloatToStr(VRange[1]);
              rfToValue := FloatToStr(VRange[2]);
            end;
        5 : begin // currency
              rfFromValue := IntToStr(CrRange[1]);
              rfToValue := IntToStr(CrRange[2]);
            end;
        4,  // ASCII
        6,  // Document No.
        7,  // Customer Code
        8,  // Supplier Code
        9,  // Nominal Code
        10, // Stock Code
        11, // Cost Centre Code
        12, // Department Code
        13, // Location Code
        17, // Job Code
        18 : begin // Bin Code
               rfFromValue := trim(ASCStr[1]);
               rfToValue := trim(ASCStr[2]);
             end;
      end; // case rfType of...
    end; // with Control.vcRangeFilter do...

    Result := 'DBF[' + trim(FieldName) + '] >= INP[' + trim(ssInputLineToken) + ',START] AND ' +
              'DBF[' + trim(FieldName) + '] <= INP[' + trim(ssInputLineToken) + ',END]';
  end;

end;

function TVRWConverter.ConvertStringSplice(
  Definition: ShortString): ShortString;
var
  StartPos, EndPos: Integer;
  HasSplice: Boolean;
begin
  HasSplice := False;
  StartPos := Pos('[', Definition);
  if StartPos <> 0 then
  begin
    StartPos := StartPos + 1;
    EndPos := StartPos;
    while EndPos < Length(Definition) do
    begin
      if (Definition[EndPos] = ',') then
        HasSplice := True;
{
      if (Definition[EndPos] = ']') then
      begin
        EndPos := EndPos - 1;
        Break;
      end;
}
      EndPos := EndPos + 1;
    end; // while EndPos...
    if HasSplice then
    begin
      Result := ''
    end
    else
      Result := Definition;
  end;
end;

constructor TVRWConverter.Create;
var
  ShowGrid: Boolean;
begin
  with TIniFile.Create(SetDrive + 'REPORTS\' + ChangeFileExt(ExtractFileName(Application.ExeName), '.DAT')) Do
  Begin
    ShowGrid := ReadBool (EntryRec^.Login, 'ShowGrid', True);
    FGridSizeXmm := ReadInteger (EntryRec^.Login, 'GridXMM', 2);
    FGridSizeYmm := ReadInteger (EntryRec^.Login, 'GridYMM', 2);
    if ShowGrid then
    begin
      FGridSizeXPixels  := FGridSizeXmm * PixelsPerMM;
      FGridSizeYPixels  := FGridSizeYmm * PixelsPerMM;
      FMinControlHeight := FGridSizeYmm * PixelsPerMM;
      FMinControlWidth  := FGridSizeXmm * PixelsPerMM;
    end
    else
    begin
      FGridSizeXPixels  := PixelsPerMM;
      FGridSizeYPixels  := PixelsPerMM;
      FMinControlHeight := 3 * PixelsPerMM;
      FMinControlWidth  := 3 * PixelsPerMM;
    end;
  end;
  FImportLog := TStringList.Create;
end;

function TVRWConverter.CreateDBControl(InRegion: IVRWRegion;
  FromDetails: RWRIntF.ReportDetailType; ControlNo: Integer): IVRWFieldControl;
var
  RecSelect, PrintSelect: ShortString;
begin
  { Create a new field control for the region }
  Result := InRegion.rgControls.Add(FReport, ctField, '') as IVRWFieldControl;
  { Copy the properties over from the old version }
  Result.vcFieldName := FromDetails.VarRef;
  Result.vcSortOrder := FromDetails.SortOrd;
  
  { Copy and translate any selection criteria }
  RecSelect := FromDetails.RecSelect;
  Result.vcSelectCriteria :=
    ConvertSelectionCriteria(Result.vcRangeFilter,
                             RecSelect,
                             Result.vcFieldName,
                             FromDetails.RepVarNo);
  Result.vcSelectCriteria := ParseFormula(Result.vcSelectCriteria);

  { Copy and translate any 'Print If' criteria }
  PrintSelect := FromDetails.PrintSelect;
  Result.vcPrintIf :=
      ConvertPrintIfCriteria(PrintSelect,
                             Result.vcFieldName,
                             FromDetails.RepVarNo);
  Result.vcPrintIf := ParseFormula(Result.vcPrintIf);

  Result.vcSubTotal := FromDetails.SubTot;
  Result.vcPageBreak := (FromDetails.Break = 4);
  Result.vcRecalcBreak := False;
  Result.vcSelectSummary := FromDetails.Summary;
  Result.vcVarNo := FromDetails.RepVarNo;
  Result.vcVarLen := FromDetails.VarLen;
  Result.vcVarDesc := FromDetails.RepLDesc;
  Result.vcVarNoDecs := FromDetails.NoDecs;
  Result.vcPeriodField := FromDetails.PrSel;
  if Result.vcPeriodField then
  begin
    Result.vcPeriod := FromDetails.RepLPr[FALSE];
    if (Length(Result.vcPeriod) > 0) then
      with FromDetails do
        Log('CHECK : Imported period for field ('+trim(VarRef)+')');

    Result.vcYear := FromDetails.RepLPr[TRUE];
    if (Length(Result.vcYear) > 0) then
      with FromDetails do
        Log('CHECK : Imported year for field ('+trim(VarRef)+')');

    Result.vcCurrency := FromDetails.RepLCr;
  end;
end;

function TVRWConverter.CreateFmlControl(InRegion: IVRWRegion;
  FromDetails: RWRIntF.ReportDetailType;
  Definition: ShortString;
  IncludeSortOrder: Boolean): IVRWFormulaControl;
var
  HasStringSlice: Boolean;
  FormulaName: ShortString;
  BaseFormulaName: ShortString;
  Extension: Integer;
begin
  HasStringSlice := False;
  Result := InRegion.rgControls.Add(FReport, ctFormula, '') as IVRWFormulaControl;
  BaseFormulaName := 'R' + IntToStr(FromDetails.RepVarNo);
  FormulaName := BaseFormulaName;
  Extension := 0;
  while FReport.FindFormulaControl(FormulaName) <> nil do
  begin
    FormulaName := BaseFormulaName + IntToStr(Extension);
    Extension := Extension + 1;
  end;
  Result.vcFormulaName := FormulaName;
  if IncludeSortOrder then
    Result.vcSortOrder := FromDetails.SortOrd
  else
    Result.vcSortOrder := '';
  Result.vcPrintIf := ParseFormula(FromDetails.PrintSelect);
  if (Result.vcPrintIf <> '') then
    HasStringSlice := (ConvertStringSplice(Result.vcPrintIf) = '');
  Result.vcPeriod := FromDetails.RepLPr[False];
  Result.vcYear :=  FromDetails.RepLPr[True];
  Result.vcCurrency := FromDetails.RepLCr;
  Result.vcDecimalPlaces := FromDetails.NoDecs;
  { Parse the formula definition -- replace any Rxx report-line references with
    the matching DBF[fieldname] reference }
  Result.vcFormulaDefinition := ParseFormula(Definition);
  if ConvertStringSplice(Result.vcFormulaDefinition) = '' then
    HasStringSlice := True;
  if HasStringSlice then
    Log(Result.vcName + ' contains a string splice and will need to be manually corrected');
  { Make sure that the formula does not contain a circular reference }
  if Pos('[' + Result.vcFormulaName + ']', Result.vcFormulaDefinition) <> 0 then
  begin
    Result.vcFormulaDefinition := '"' + Result.vcFormulaDefinition;
    Log('Formula ' + Result.vcFormulaName + ' contains a reference to itself and has been disabled');
  end;
end;

destructor TVRWConverter.Destroy;
begin
  FImportLog.Free;

  { Release references to interfaces }
  FReport       := nil;
  FSourceReport := nil;

  inherited;
end;

function TVRWConverter.Execute: LongInt;

  function CleanString(Str: ShortString): ShortString;
  { Removes any non-alpha characters from the supplied string. }
  var
    CharPos: Integer;
  const
    GoodChars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  begin
    Result := '';
    for CharPos := 1 to Length(Str) do
    begin
      if Pos(LowerCase(Str[CharPos]), GoodChars) <> 0 then
        Result := Result + Str[CharPos];
    end;
  end;

  procedure ApplyDefaults(Control: IVRWControl; Caption: ShortString;
    X, Y, W, H: Integer; IncludeLabel: Boolean = True);
  { Applies the sizing to the control, and creates a matching label in the
    page header }
  var
    LblControl: IVRWTextControl;
    PageRegion: IVRWRegion;
    CanPrint: Boolean;
  begin
    Control.vcTop := Y;
    Control.vcLeft := X;
    Control.vcWidth := W;
    Control.vcHeight := H;

    if Supports(Control, IVRWFieldControl) then
      CanPrint := (Control as IVRWFieldControl).vcPrintField
    else if Supports(Control, IVRWFormulaControl) then
      CanPrint := (Control as IVRWFormulaControl).vcPrintField
    else
      CanPrint := True;

    if IncludeLabel and CanPrint then
    begin
      { Create a label control for the page header }
      PageRegion := FReport.vrRegions[PAGE_HEADER_NAME];
      LblControl := PageRegion.rgControls.Add(FReport, ctText, '') as IVRWTextControl;
      try
        LblControl.vcCaption := Caption;
        LblControl.vcFont.Style := [fsBold];

        LblControl.vcTop := Y + ((H + 2) * 3);
        LblControl.vcLeft := X;
        LblControl.vcWidth := W;
        LblControl.vcHeight := H;
        LblControl.vcFieldFormat := Control.vcFieldFormat;
      finally
        LblControl := nil;
      end;
    end;
  end;

  function FindHighestSection: Integer;
  { Returns the highest section number found in the old report }
  var
    ControlNo: Integer;
    SortIndex: Integer;
  begin
    Result := 0;
    for ControlNo := 0 to FSourceReport.rdReportLineCount - 1 do
    begin
      if Trim(FSourceReport.rdReportLines[ControlNo].SortOrd) <> '' then
      begin
        SortIndex := StrToIntDef(FSourceReport.rdReportLines[ControlNo].SortOrd[1], 0);
        if (SortIndex > Result) then
          Result := SortIndex;
      end;
    end;
  end;

  procedure AddRegions(MaxSection: Integer; LeftMargin: SmallInt);
  { Adds the regions required by the report }
  var
    SortIndex: Integer;
  begin
    { Add the header regions }
    FReport.vrRegions.Add(FReport, rtRepHdr);
    FReport.vrRegions[REPORT_HEADER_NAME].rgLeft := LeftMargin;
    FReport.vrRegions.Add(FReport, rtPageHdr);
    FReport.vrRegions[PAGE_HEADER_NAME].rgLeft := LeftMargin;

    { Add header regions for each of the required sections }
    for SortIndex := 1 to MaxSection do
    begin
      FReport.vrRegions.Add(FReport, rtSectionHdr, SortIndex);
      FReport.vrRegions[SECTION_HEADER_NAME + IntToStr(SortIndex)].rgLeft := LeftMargin;
    end;

    { Add the report line region }
    FReport.vrRegions.Add(FReport, rtRepLines);
    FReport.vrRegions[REPORT_LINE_NAME].rgLeft := LeftMargin;

    { Add footer regions for each of the required sections }
    for SortIndex := MaxSection downto 1 do
    begin
      FReport.vrRegions.Add(FReport, rtSectionFtr, SortIndex);
      FReport.vrRegions[SECTION_FOOTER_NAME + IntToStr(SortIndex)].rgLeft := LeftMargin;
    end;

    { Add the page footer and report footer regions }
    FReport.vrRegions.Add(FReport, rtPageFtr);
    FReport.vrRegions[PAGE_FOOTER_NAME].rgLeft := LeftMargin;
    FReport.vrRegions.Add(FReport, rtRepFtr);
    FReport.vrRegions[REPORT_FOOTER_NAME].rgLeft := LeftMargin;
  end;

  procedure AddHeaderLabels(Height, PaperLeft, PaperRight: Integer);
  var
    Region: IVRWRegion;
    Lbl: IVRWTextControl;
    Fml: IVRWFormulaControl;
    Dbf: IVRWFieldControl;
  begin
    Region := FReport.vrRegions[PAGE_HEADER_NAME];
    Region.rgHeight := (Height + 2) * 4;
    { Company name }
    Fml := Region.rgControls.Add(FReport, ctFormula, '') as IVRWFormulaControl;
    try
      Fml.vcFormulaDefinition := '"DBF[SYSUSER]';
      Fml.vcFormulaName := 'PrintCompanyName';
      Fml.vcFieldFormat := 'L';
      Fml.vcTop := 2;
      Fml.vcWidth := PaperRight div 2;
      Fml.vcLeft := PaperLeft;
      Fml.vcHeight := Height;
      Fml.vcFont.Style := [fsBold];
    finally
      Fml := nil;
    end;
    { SYSUSER }
    Dbf := Region.rgControls.Add(FReport, ctField, '') as IVRWFieldControl;
    try
      Dbf.vcFieldName := 'SYSUSER';
      Dbf.vcPrintField := False;
      Dbf.vcFieldFormat := 'L';
      Dbf.vcTop := 2;
      Dbf.vcLeft := (PaperRight div 2) + 4;
      Dbf.vcHeight := Height;
      Dbf.vcWidth := 10;
    finally
      Dbf := nil;
    end;
    { Report name }
    Lbl := Region.rgControls.Add(FReport, ctText, '') as IVRWTextControl;
    try
      Lbl.vcCaption := FSourceReport.rdReportHeader.RepDesc;
      Lbl.vcTop := 2 + Height;
      Lbl.vcWidth := PaperRight div 2;
      Lbl.vcLeft := PaperLeft;
      Lbl.vcHeight := Height;
      Lbl.vcFont.Style := [fsBold];
    finally
      Lbl := nil;
    end;
    { SYSLUSER }
    Dbf := Region.rgControls.Add(FReport, ctField, '') as IVRWFieldControl;
    try
      Dbf.vcFieldName := 'SYSLUSER';
      Dbf.vcPrintField := False;
      Dbf.vcFieldFormat := 'L';
      Dbf.vcTop := 2 + Height;
      Dbf.vcLeft := (PaperRight div 2) + 4;
      Dbf.vcHeight := Height;
      Dbf.vcWidth := 10;
    finally
      Dbf := nil;
    end;
    { Print date/time }
    Fml := Region.rgControls.Add(FReport, ctFormula, '') as IVRWFormulaControl;
    try
      Fml.vcFormulaDefinition := '""Printed : " + INFO[DATE] + " - " + INFO[TIME]';
      Fml.vcFormulaName := 'PrintDate';
      Fml.vcFieldFormat := 'R';
      Fml.vcTop := 2;
      Fml.vcWidth := CalcSize('Printed : 00/00/0000 - 00:00:00').X;
      Fml.vcLeft := PaperRight - Fml.vcWidth;
      Fml.vcHeight := Height;
    finally
      Fml := nil;
    end;
    { User name }
    Fml := Region.rgControls.Add(FReport, ctFormula, '') as IVRWFormulaControl;
    try
      Fml.vcFormulaDefinition := '"DBF[SYSLUSER]';
      Fml.vcFormulaDefinition :=
        '""User : " + DBF[SYSLUSER] + ". Page : " + INFO[CURRENTPAGE]';
      Fml.vcFormulaName := 'PrintUserName';
      Fml.vcFieldFormat := 'R';
      Fml.vcTop := Height + 2;
      Fml.vcWidth := CalcSize('User : XXXXXXXX. Page : 0000').X;
      Fml.vcLeft := PaperRight - Fml.vcWidth;
      Fml.vcHeight := Height;
    finally
      Fml := nil;
    end;
  end;

  function HasHeadingLine(FieldName: ShortString): Boolean;
  { Returns True if the old report had a heading line matching the supplied
    field name }
  var
    HeadingNo: Integer;
  begin
    Result := False;
    for HeadingNo := 0 to FSourceReport.rdHeadingLineCount - 1 do
    begin
      if Trim(FSourceReport.rdHeadingLines[HeadingNo].VarRef) = Trim(FieldName) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;

  function HeadingControl(Region: IVRWRegion; FieldName: ShortString): IVRWFieldControl;
  var
    ControlNo: Integer;
    HeaderFieldName: ShortString;
  begin
    Result := nil;
    for ControlNo := 0 to Region.rgControls.clCount - 1 do
    begin
      if Supports(Region.rgControls.clItems[ControlNo], IVRWFieldControl) then
      begin
        HeaderFieldName := (Region.rgControls.clItems[ControlNo] as IVRWFieldControl).vcFieldName;
        if (Trim(FieldName) = Trim(HeaderFieldName)) then
        begin
          Result := Region.rgControls.clItems[ControlNo] as IVRWFieldControl;
          Break;
        end;
      end;
    end;
  end;

var
  MaxSection: Integer;
  SortIndex: Integer;
  ControlNo: Integer;
  Region, PageRegion, FooterRegion: IVRWRegion;
  Source: RWRIntf.ReportDetailType;
  DBControl: IVRWFieldControl;
  FmlControl: IVRWFormulaControl;
  X, Y, W, H: Integer;
  ColSpacing: Integer;
  LogFileName: string;
  LineControl: IVRWBoxControl;
  PaperLeft, PaperRight: Integer;
  DataRec: RWOpenF.DataDictRec;
  FieldName, SourceName: ShortString;
  HasHiddenFields: Boolean;
  IsFormula: Boolean;
begin
  Result := -1;

  FImportLog.Clear;

  HasHiddenFields := False;

  { Make sure all the Converter parameters are set }
  if not Validate then
    Exit;

  { Create a new report }
  FReport := nil;
  FReport := GetVRWReport;

  FReport.vrName := CleanString(FSourceReport.rdReportHeader.RepName);
  FReport.vrDescription := FSourceReport.rdReportHeader.RepDesc;
  FReport.vrMainFileNum := FSourceReport.rdReportHeader.DriveFile;
  FReport.vrMainFile := DataFilesL^[FReport.vrMainFileNum];

  FReport.vrIndexID := FSourceReport.rdReportHeader.DrivePath;
  FReport.vrFilename := SetDrive + 'REPORTS\' + FReport.vrName;
  FReport.vrFont.Name := FSourceReport.rdReportHeader.DefFont.fName;
  FReport.vrFont.Size := FSourceReport.rdReportHeader.DefFont.fSize;
  FReport.vrFont.Style := [];
  FReport.vrFont.Color := FSourceReport.rdReportHeader.DefFont.fColor;

  FReport.vrTestModeParams.tmRefreshStart := True;
  FReport.vrTestModeParams.tmRefreshEnd   := True;

  { Find the highest numbered section, using the Sort Order from the imported
    report. }
  MaxSection := FindHighestSection;

  { Add the report regions }
//  AddRegions(MaxSection, FSourceReport.rdReportHeader.ColSpace);
  AddRegions(MaxSection, 5);

  Y := 0;
  H := CalcSize('Ag').Y;
  ColSpacing := FSourceReport.rdReportHeader.ColSpace;
  PaperLeft := 5;
  if (FSourceReport.rdReportHeader.PaprOrient = 'L') then
    FReport.vrPaperOrientation := Ord(poLandscape)
  else
    FReport.vrPaperOrientation := Ord(poPortrait);

  { Add controls to the header sections }
  for ControlNo := 0 to FSourceReport.rdHeadingLineCount - 1 do
  begin
    Source := FSourceReport.rdHeadingLines[ControlNo];
    if Trim(Source.SortOrd) <> '' then
    begin
      { Determine and retrieve the correct region }
      SortIndex := StrToIntDef(Source.SortOrd[1], 0);
      Region := FReport.vrRegions[SECTION_HEADER_NAME + IntToStr(SortIndex)];
      if (Region <> nil) then
      try
        X := Region.rgLeft;
        if Source.CalcField then
        begin
          { Formula Field }
          FmlControl := CreateFmlControl(Region, Source, Source.VarSubSplit);

          W := Source.MMWidth;
          FmlControl.vcFieldFormat := 'R';
          FmlControl.vcPrintField := Source.PrintVar;
          ApplyDefaults(FmlControl, Source.RepLDesc, X, Y, W, H, False);
          if not Source.PrintVar then
          begin
            HasHiddenFields := True;
            FmlControl.vcTop := Y + H;
          end;

          Region.rgHeight := H;

          FmlControl := nil;

        end
        else
        begin
          DBControl := CreateDBControl(Region, Source, ControlNo);

          W := FSourceReport.rdReportLines[ControlNo].MMWidth;

          DBControl.vcTop := Y;
          DBControl.vcLeft := X;
          DBControl.vcWidth := W;
          DBControl.vcHeight := H;

          DBControl.vcSortOrder := '';

          DBControl.vcPrintField := Source.PrintVar;
          if not Source.PrintVar then
          begin
            HasHiddenFields := True;
            DBControl.vcTop := Y + H;
          end;

          FieldName := DBControl.vcFieldName;
          GetDDField(FieldName, DataRec);
          DBControl.vcVarNo := DataRec.DataVarRec.VarNo;
          DBControl.vcVarLen := DataRec.DataVarRec.VarLen;
          DBControl.vcVarDesc := DataRec.DataVarRec.VarDesc;
          DBControl.vcVarType := DataRec.DataVarRec.VarType;

          if (DataRec.DataVarRec.VarType in [2,3,6,7,9]) then // 2,3,6,7,9 - real, double, integer, longint, currency
            DBControl.vcFieldFormat := 'R'
          else
            DBControl.vcFieldFormat := 'L';
        end;

        Region.rgHeight := H;

        if Source.PrintVar then
          Region.rgLeft := Region.rgLeft + W + ColSpacing;

      finally
        if HasHiddenFields then
          Log(Region.rgName + ' has hidden fields below the bottom of the section');
        DBControl := nil;
        Region := nil;
      end;
    end;
  end;

  { Add sort controls to the header sections }
  HasHiddenFields := False;
  for ControlNo := 0 to FSourceReport.rdReportLineCount - 1 do
  begin
    Source := FSourceReport.rdReportLines[ControlNo];
    { If the control has a sort order, a section needs to exist for it. }
    if Trim(Source.SortOrd) <> '' then
    begin
      { Determine and retrieve the correct region }
      SortIndex := StrToIntDef(Source.SortOrd[1], 0);
      Region := FReport.vrRegions[SECTION_HEADER_NAME + IntToStr(SortIndex)];
      if (Region <> nil) then
      try
        X := Region.rgLeft;
        W := 0;
        if Source.CalcField then
        begin
          { Formula Field }
          FmlControl := CreateFmlControl(Region, Source, Source.VarSubSplit);

          W := Source.MMWidth;
          FmlControl.vcFieldFormat := 'R';
          FmlControl.vcPrintField := Source.PrintVar;
          ApplyDefaults(FmlControl, Source.RepLDesc, X, Y, W, H, False);
          if not Source.PrintVar then
          begin
            HasHiddenFields := True;
            FmlControl.vcTop := Y + H;
          end;

          Region.rgHeight := H;

          FmlControl := nil;

        end
        else
        begin
          DBControl := HeadingControl(Region, Source.VarRef);
          if DBControl = nil then
          begin
            DBControl := CreateDBControl(Region, Source, ControlNo);
            DBControl.vcPrintField := Source.PrintVar;

            W := FSourceReport.rdReportLines[ControlNo].MMWidth;

            DBControl.vcTop := Y;
            DBControl.vcLeft := X;
            DBControl.vcWidth := W;
            DBControl.vcHeight := H;

            if not Source.PrintVar then
            begin
              HasHiddenFields := True;
              DBControl.vcTop := Y + H;
            end;

            DBControl.vcPrintField := False;

            FieldName := DBControl.vcFieldName;
            GetDDField(FieldName, DataRec);
            DBControl.vcVarNo := DataRec.DataVarRec.VarNo;
            DBControl.vcVarLen := DataRec.DataVarRec.VarLen;
            DBControl.vcVarDesc := DataRec.DataVarRec.VarDesc;
            DBControl.vcVarType := DataRec.DataVarRec.VarType;

            if (DataRec.DataVarRec.VarType in [2,3,6,7,9]) then // 2,3,6,7,9 - real, double, integer, longint, currency
              DBControl.vcFieldFormat := 'R'
            else
              DBControl.vcFieldFormat := 'L';
          end
          else
            DBControl.vcSortOrder := Source.SortOrd;
        end;

        Region.rgHeight := H;

        if Source.PrintVar then
          Region.rgLeft := Region.rgLeft + W + ColSpacing;

      finally
        DBControl := nil;
        Region := nil;
      end;
    end;
  end;

  { Add controls to the report lines }
  Region := FReport.vrRegions[REPORT_LINE_NAME];
  PageRegion := FReport.vrRegions[PAGE_HEADER_NAME];
  PageRegion.rgHeight := (H + 2) * 4;
  IsFormula := False;
  if (Region <> nil) then
  try
    for ControlNo := 0 to FSourceReport.rdReportLineCount - 1 do
    begin
      X := Region.rgLeft;
      Source := FSourceReport.rdReportLines[ControlNo];

      if Source.CalcField then
      begin
        { Formula Field }
        IsFormula := True;
        FmlControl := CreateFmlControl(Region, Source, Source.VarSubSplit);
        SourceName := FmlControl.vcFormulaName;

        W := Source.MMWidth;
        FmlControl.vcFieldFormat := 'R';
        FmlControl.vcPrintField := Source.PrintVar;
        ApplyDefaults(FmlControl, Source.RepLDesc, X, Y, W, H);
        if not Source.PrintVar then
        begin
          HasHiddenFields := True;
          FmlControl.vcTop := Y + H;
        end;

        Region.rgHeight := H;

        FmlControl := nil;

      end
      else
      begin
        { DB Field }
        IsFormula := False;
        Source := FSourceReport.rdReportLines[ControlNo];
        DBControl := CreateDBControl(Region, Source, ControlNo);
        SourceName := DBControl.vcFieldName;
        GetDDField(SourceName, DataRec);
        DBControl.vcVarNo := DataRec.DataVarRec.VarNo;
        DBControl.vcVarLen := DataRec.DataVarRec.VarLen;
        DBControl.vcVarDesc := DataRec.DataVarRec.VarDesc;
        DBControl.vcVarType := DataRec.DataVarRec.VarType;

        if (DataRec.DataVarRec.VarType in [2,3,6,7,9]) then // 2,3,6,7,9 - real, double, integer, longint, currency
          DBControl.vcFieldFormat := 'R'
        else
          DBControl.vcFieldFormat := 'L';

        W := Source.MMWidth;
        DBControl.vcPrintField := Source.PrintVar;
        ApplyDefaults(DBControl, Source.RepLDesc, X, Y, W, H);
        if not Source.PrintVar then
        begin
          HasHiddenFields := True;
          DBControl.vcTop := Y + H;
        end;

        Region.rgHeight := H;

      end;

      if Source.SubTot then
      begin

        { Sub-totals required. Create a sub-total formula field in the section
          footers. }
        for SortIndex := 1 to MaxSection do
        begin
          FooterRegion := FReport.vrRegions[SECTION_FOOTER_NAME + IntToStr(SortIndex)];

          if IsFormula then
            FmlControl := CreateFmlControl(
                            FooterRegion, Source,
                            'TotalField('+trim(SourceName)+')',
                            False)
          else
            FmlControl := CreateFmlControl(
                            FooterRegion, Source,
                            'TotalField(DBF['+trim(SourceName)+'])',
                            False);
          FmlControl.vcFieldFormat := 'R';
          W := Source.MMWidth;
          ApplyDefaults(FmlControl, Source.RepLDesc, X, Y + 2, W, H, False);
          { Add a line over it }
          LineControl := FooterRegion.rgControls.Add(FReport, ctBox, '') as IVRWBoxControl;
          try
            LineControl.vcWidth := W;
            LineControl.vcTop := Y;
            LineControl.vcLeft := X;
            LineControl.vcHeight := 1;
            LineControl.vcBoxLines[biLeft].vcLineStyle := psClear;
            LineControl.vcBoxLines[biRight].vcLineStyle := psClear;
            LineControl.vcBoxLines[biBottom].vcLineStyle := psClear;
          finally
            LineControl := nil;
          end;

          FmlControl := nil;
        end;

        { Create a grand total in the report footer }
        FooterRegion := FReport.vrRegions[REPORT_FOOTER_NAME];

        if IsFormula then
          FmlControl := CreateFmlControl(
                          FooterRegion, Source,
                          'TotalField('+trim(SourceName)+')',
                          False)
        else
          FmlControl := CreateFmlControl(
                          FooterRegion, Source,
                          'TotalField(DBF['+trim(SourceName)+'])',
                          False);
        FmlControl.vcFieldFormat := 'R';
        W := Source.MMWidth;
        ApplyDefaults(FmlControl, Source.RepLDesc, X, Y + 2, W, H, False);
        { Add a line over it }
        LineControl := FooterRegion.rgControls.Add(FReport, ctBox, '') as IVRWBoxControl;
        try
          LineControl.vcWidth := W;
          LineControl.vcTop := Y;
          LineControl.vcLeft := X;
          LineControl.vcHeight := 1;
          LineControl.vcBoxLines[biLeft].vcLineStyle := psClear;
          LineControl.vcBoxLines[biRight].vcLineStyle := psClear;
          LineControl.vcBoxLines[biBottom].vcLineStyle := psClear;
        finally
          LineControl := nil;
        end;

        FmlControl := nil;

      end; // if Source.SubTot...

      DBControl  := nil;
      if Source.PrintVar then
        Region.rgLeft := Region.rgLeft + W + ColSpacing;

    end;
    PaperRight := Region.rgLeft;
    { Add the report header labels }
    AddHeaderLabels(H, PaperLeft, PaperRight);

    { Add a line under the header }
    LineControl := PageRegion.rgControls.Add(FReport, ctBox, '') as IVRWBoxControl;
    try
      LineControl.vcWidth := PaperRight;
      LineControl.vcTop := PageRegion.rgHeight - 1;
      LineControl.vcLeft := ColSpacing;
      LineControl.vcHeight := 1;
      LineControl.vcBoxLines[biLeft].vcLineStyle := psClear;
      LineControl.vcBoxLines[biRight].vcLineStyle := psClear;
      LineControl.vcBoxLines[biBottom].vcLineStyle := psClear;
    finally
      LineControl := nil;
    end;
  finally
    if HasHiddenFields then
      Log(Region.rgName + ' has hidden fields below the bottom of the section');
    DBControl := nil;
    Region := nil;
  end;

  if (FImportLog.Count > 0) then
  begin
    LogFileName := SetDrive + 'REPORTS\' + Trim(FReport.vrName) + '.TXT';
    FImportLog.Insert(0, '============================================');
    FImportLog.Insert(0, 'Exception log - Report Writer report import.');
    FImportLog.SaveToFile(LogFileName);
    ShellExecute(Application.MainForm.Handle, nil, PChar(LogFileName), nil, nil, SW_SHOW)
  end;

end;

function TVRWConverter.GetReport: IVRWReport;
begin
  Result := FReport;
end;

function TVRWConverter.GetSourceReport: IReportDetails;
begin
  Result := FSourceReport;
end;

procedure TVRWConverter.Log(LogMsg: string);
begin
  FImportLog.Add(LogMsg);
end;

function TVRWConverter.ParseFormula(Definition: ShortString): ShortString;
var
  PrevChar, ThisChar: Char;
  CharPos, RefNo, LineNo: Integer;
  Reference, FieldName: ShortString;
  InReference: Boolean;
  LeftStr, RightStr: ShortString;
  IsCalculated: Boolean;
begin
  { Locate any Rxx or Ixx references }
  PrevChar := ' ';
  CharPos := 1;
  Reference := '';
  InReference := False;
  IsCalculated := False;
  Definition := Uppercase(Definition);
  while (CharPos <= Length(Definition)) do
  begin
    ThisChar := Definition[CharPos];
    if InReference then
    begin
      if (CharPos = Length(Definition)) and
         (Pos(ThisChar, '1234567890') > 0) then
      begin
        Reference := Reference + ThisChar;
        CharPos := CharPos + 1;
      end;
      { Have we reached the end of the reference? }
      if (Pos(ThisChar, '1234567890') = 0) or
         (CharPos >= Length(Definition)) then
      begin
        if (Length(Reference) > 1) then
        begin
          if (Reference[1] = 'I') then
          begin
            { 'I' references (input fields) cannot be imported }
            FieldName := Reference;
            IsCalculated := True;
            Log('Input line ' + Reference + ' will need to be amended')
          end
          else
          begin
            { Search for the matching report-line, and extract the field name }
            RefNo := StrToIntDef(Copy(Reference, 2, Length(Reference)), 0);
            FieldName := '';
            for LineNo := 0 to FSourceReport.rdReportLineCount - 1 do
            begin
              if FSourceReport.rdReportLines[LineNo].RepVarNo = RefNo then
              begin
                FieldName := FSourceReport.rdReportLines[LineNo].VarRef;
                if (Trim(FieldName) = '+') then
                begin
                  { It's a calculated field - use the report line reference as
                    the name }
                  FieldName := Reference;
                  IsCalculated := True;
                end;
                Break;
              end;
            end;
          end;
          { Replace the reference with the field reference }
          if FieldName <> '' then
          begin
            if Reference[1] = 'I' then
              FieldName := Reference + ' : <Replace with input value>'
            else if IsCalculated then
              FieldName := 'FML[' + Trim(FieldName) + ']'
            else
              FieldName := 'DBF[' + Trim(FieldName) + ']';

            { Now the tricky bit. We have to insert the field reference into
              the formula definition, whilst correctly adjusting the CharPos
              position so that it points to the character immediately following
              the field reference }

            { We already have the left side (the part before the location of
              the field reference) stored in LeftStr. Store the part of the
              definition that follows the existing reference. }
            RightStr := Copy(Definition, CharPos, Length(Definition));

            { Now attach the new field reference to the first part of the
              definition. }
            Definition := LeftStr + FieldName;

            { The new CharPos is at the end of this. }
            CharPos := Length(Definition);

            { Add the right side of the definition }
            Definition := Definition + RightStr;
          end;
        end;
        InReference := False;
        IsCalculated := False;
      end
      else
      { Add the digit to the reference }
      begin
        Reference := Reference + ThisChar;
      end;
    end
    else
    begin
      { We are not currently reading a reference. If the current character is
        an 'R', and the previous character was not alphabetic, assume that this
        is the start of a reference }
      if (ThisChar = 'R') and
         (Pos(Lowercase(PrevChar), 'abcdefghijklmnopqrstuvwxyx') = 0) then
      begin
        InReference := True;
        Reference := 'R';
        { Copy the definition up to the point that we have reached }
        LeftStr := Copy(Definition, 1, CharPos - 1);
      end
      else if (ThisChar = 'I') and
         (Pos(Lowercase(PrevChar), 'abcdefghijklmnopqrstuvwxyx') = 0) then
      begin
        InReference := True;
        Reference := 'I';
        { Copy the definition up to the point that we have reached }
        LeftStr := Copy(Definition, 1, CharPos - 1);
      end;
    end;
    CharPos := CharPos + 1;
  end;
  Result := Definition;
end;

procedure TVRWConverter.SetReport(Value: IVRWReport);
begin
  FReport := Value;
end;

procedure TVRWConverter.SetSourceReport(Value: IReportDetails);
begin
  FSourceReport := Value;
end;

function TVRWConverter.Validate: Boolean;
begin
  Result := (FSourceReport <> nil);
end;

end.
