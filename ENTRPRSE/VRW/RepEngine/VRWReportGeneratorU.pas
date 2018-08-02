unit VRWReportGeneratorU;

interface

uses SysUtils, Forms, Classes, Windows,
  VRWReportIF, oRepEngineManager, GUIEng, PrntDlg2,
  RPDefine, RPBase, RPFiler, RPDevice, RPCanvas, RPFPrint,
  GlobVar, GlobalTypes, GlobType, GuiVar,
  EnterpriseDBF_TLB, DBFUtil, ActiveX, ComObj, ExtCtrls
  //PR 12/08/2016 2016-R1 ABSEXCH-10720: Added the Export To Excel sub-object for printing to .xlsx
  ,RepExcelExport

{$IFDEF DEBUGON}
  , DbgWin2
{$ENDIF}
  ;

type
  { The TTotals collection class maintains a list of totals of all numeric
    fields on the report. There is one TTotal for each Section, plus an entry
    for grand totals, for each numeric field control found in the Report Lines.
    Note that totals are maintained regardless of whether or not the totals are
    to be printed. }
  TTotal = class(TCollectionItem)
  private
    FFieldName: ShortString;
    FSectionNumber: SmallInt;
    FValue: Double;                                         
    FCount: Integer;
    FIsUpdated: Boolean;
    procedure SetValue(const Value: Double);
  public
    { The field name is the field which is being totalled. }
    property FieldName: ShortString read FFieldName write FFieldName;

    { Each total is associated with a specific section. When the section
      breaks, the total is reset to zero. A section number of 0 will never
      break, and is used for grand totals. }
    property SectionNumber: SmallInt read FSectionNumber write FSectionNumber;

    { The current value of the total. }
    property Value: Double read FValue write SetValue;

    { The current count -- i.e. the number of times that the total has been
      updated. Normally this will be the same as a row-count, but if the field
      which is being totalled has a Print If filter, only those rows where the
      Print If filter matches will be counted. Also, this value will be reset
      on a section break. }
    property Count: Integer read FCount write FCount;

    { The IsUpdated flag indicates whether or not the total has been updated
      against the current record, and is reset each time we move to another
      record. This prevents the total being updated more than once, in the
      event that the field appears more than once in the section. }
    property IsUpdated: Boolean read FIsUpdated write FIsUpdated;

  end;

  TTotals = class(TCollection)
  private
    FEnabled: Boolean;
    FInFooter: Boolean;
    function GetItem(Index: Integer): TTotal;
    procedure SetItem(Index: Integer; const Value: TTotal);
{$IFDEF DEBUGON}
    procedure Debug_ShowAll;
{$ENDIF DEBUGON}
  public
    constructor Create;
    function Add(FieldName: ShortString; SectionNumber: SmallInt): TTotal;
    procedure AddToTotal(FieldName: ShortString; AddValue: Double);
    function Exists(FieldName: ShortString; SectionNumber: SmallInt): Boolean;
    procedure Reset(SectionNumber: SmallInt);
    procedure ResetUpdatedFlag(SectionNumber: SmallInt = -1);
    function Value(FieldName: ShortString; SectionNumber: SmallInt): Double;
    function FieldCount(FieldName: ShortString; SectionNumber: SmallInt; EndOfReport: Boolean = False): Integer;
    property Enabled: Boolean read FEnabled write FEnabled;
    property InFooter: Boolean read FInFooter write FInFooter;
    property Items[Index: Integer]: TTotal read GetItem write SetItem; default;
  end;

  TVRWControlLayout = record
    X: Double;
    Y: Double;
    W: Double;
    H: Double;
    Text: ShortString;
    Print: Boolean;
    Justify: TPrintJustify;
    DrillDownInfo: TRWDrillDownInfo;
  end;

  TVRWReportGenerator = class
  private
    FPrintingRegion: Boolean;
  private
    FCSVOutput: TStringList;
    FDBFOutput: IDBFWriter;

    FBitmapIndex: Integer;
    PrinterInfo : TSBSPrintSetupInfo;
    FPrinterInfoSet: Boolean;

    // CJS 2014-07-09 - ABSEXCH-15307 - CSV headers on export from VRW
    // List to hold sorted collection of controls to be printed
    FCSVReportControls: TStringList;

    FDBEngine: TReportWriterEngine;
    FFiler: TReportFiler;
    FEndOfReport: Boolean;
    FError: string;
    FExternalCall: Boolean;
    FFileName: string;
    FNewPageRequired: Boolean;
    FReport: IVRWReport;
    FSectionFootersRequired: Boolean;
    FSectionHeadersRequired: Boolean;
    FSectionNumber: SmallInt;
    FTotals: TTotals;
    FCancelled: Boolean;
    FRecordCount: Integer;
    FRecordTotal: Integer;
    FOnCheckRecord: TOnCheckRecordProc;
    FOnSecondPass: TOnCheckRecordProc;
    FOnFirstPass: TOnCheckRecordProc;
    FCurrentControlName: string;
    FReportFileName: ShortString;
    FBreakingSection: SmallInt;
    FUserID: string;

    //PR 12/08/2016 2016-R1 ABSEXCH-10720: Added the Export To Excel sub-object for printing to .xlsx
    ExportToExcel : TExportReportToExcel;
    FXLSXRegionControls: TStringList; //List to hold controls in display order for XLSX output

    //For xlsx keep track of current page
    FCurrentPage : Integer;
    StartXPos : Integer; //Position of first control in display order for XLSX printing

    FRowsInLine : Integer; //Number of rows in each report line
    FRowsInPage : Integer; //Number of rows in page header and footer combined
    FRowsInSections : Integer; //Number of rows in all section headers and footers combined

    procedure AddToTotals(TotalName: string);
    function CheckForPageBreak(Region: IVRWRegion): Boolean;
    function CheckForSectionBreak(Region: IVRWRegion; ForceBreak: Boolean): Boolean;
    procedure CheckForSectionBreaks;
    procedure ClearSortedControlList(List: TStringList);
    function ControlHoldsDate(Control: IVRWFieldControl): Boolean;
    function ControlHoldsFloat(Control: IVRWFieldControl): Boolean;
    function ControlHoldsInteger(Control: IVRWFieldControl): Boolean;
    procedure ExtTextRect2(ftText : ShortString;
                           const ftJustify : TPrintJustify;
                           const ftLeft,
                                 ftTop,
                                 ftWidth,
                                 ftHeight  : Double;
                           const VCenter   : Boolean = False);
    procedure FinishDBFOutput;
    function GetDBEngine: TReportWriterEngine;
    function GetEndOfReport: Boolean;
    function GetEngineControl(ControlName: ShortString): TRWFieldObject;
    function GetError: string;
    function GetExternalCall: Boolean;
    function GetField(FieldName: ShortString): TRWFieldObject;
    function GetFileName: string;
    function GetFiler: TReportFiler;
    function GetFirst: LongInt;
    function GetFormulaFieldNo(ControlName: ShortString): Integer;
    function GetNewPageRequired: Boolean;
    function GetNext: LongInt;
    function GetPrevious: LongInt;
    function GetReport: IVRWReport;
    function GetSectionFootersRequired: Boolean;
    function GetSectionHeadersRequired: Boolean;
    function GetSectionNumber: SmallInt;
    function InitialisePrinter: Boolean;
    function InitialiseRangeFilters: Boolean;
    procedure InitialiseReportEngine;
    procedure InitialiseReportFields;
    procedure InitialiseReportFiler;
    function IsNumeric(Value: string): Boolean;
    procedure OnNotifyField(const ControlName: string);
    procedure OnNotifyFieldValue(const ControlName  : string;
      const FieldValue : string);
    procedure ParseFormula(Control: IVRWFormulaControl);
    function ParserCallBack(const ValueIdentifier, ValueName: string;
      var ErrorCode: SmallInt; var ErrorString : ShortString;
      var ErrorWord : ShortString): ResultValueType;

    // CJS 2014-07-09 - ABSEXCH-15307 - CSV headers on export from VRW
    procedure PrepareCSVReportControls;

    function PrepareLayout(Region: IVRWRegion; Control: IVRWControl;
      Top: Double): TVRWControlLayout;
    procedure PrintControl(Control: IVRWControl; Layout: TVRWControlLayout);
    function PrintingToExcel: Boolean;
    procedure PrintNewPage;
    procedure PrintPageFooter;
    procedure PrintPageHeader;
    procedure PrintRegion(Region: IVRWRegion);
    procedure PrintReportFooter;
    procedure PrintReportHeader;
    procedure PrintSectionFooters;
    procedure PrintSectionHeaders;
    procedure Process(Sender: TObject);
    procedure ProcessForCSV(Sender: TObject);
    procedure ProcessForDBF(Sender: TObject);
    function RegionIsPrintable(Region: IVRWRegion): Boolean;
    procedure ResetBitmapCache;
    procedure SetEndOfReport(const Value: Boolean);
    procedure SetFileName(const Value: string);
    procedure SetNewPageRequired(const Value: Boolean);
    procedure SetSectionFootersRequired(const Value: Boolean);
    procedure SetSectionHeadersRequired(const Value: Boolean);
    procedure SetSectionNumber(const Value: SmallInt);
    procedure SortReportControls(List: TStringList);
    procedure StartDBFOutput;
    function TemporaryReportFileName: string;
    procedure UpdateTotals(const ControlName  : string; const FieldValue : string);
    procedure WriteCSVHeader;
    procedure WriteCSVLine;
    procedure WriteDBFHeader(Region: IVRWRegion);
    procedure WriteDBFLine(Region: IVRWRegion);

    //PR: 12/08/2016 ABSEXCH-12521 Functions for printing to XLSX Excel files
    //Returns true if the control should be printed to Excel
    function ValidXLSXControl(const Control : IVRWControl) : Boolean;

    //Housekeeping procedure to set up Excel component
    procedure PrepareXLSX;

    //Function to set rows on xlsx object
    procedure PrepareToPrintXLSX;

    //Functions to return the region (and row within that region) with most columns
    procedure FindControlsForXSLXColumns;

    //Function to find any fields which are to the right of the columns for the report lines
    function FindExtraColumns(LastX : Integer) : TStringList;

    //Set the column widths for Excel
    Procedure SetXLSXColumns;

    //Before saving xslx files set all column widths to the initial width of their controls
    procedure ResetXLSXColumnWidths;

    //Function to return print justification from control format
    function Justify(const Control : IVRWControl): TPrintJustify;

    //Sorts the columns for a region into a list in display order
    procedure SortReportControlsForXLSX(const List: TStringList; Region: IVRWRegion; IncludeHiddenControls : Boolean = False);

    //Exports the values for the given region to the Excel component
    procedure PrintRegionToXLSX(const Region: IVRWRegion);

    //function to set a field value without using a Rave macro
    function ReplaceMacro(const ValueName : string) : ResultValueType;

    //Replaces page number indicator with actual number
    procedure ProcessXLSXMacros(var Value : ShortString);

    procedure ProcessControl(const Control : IVRWControl; const Region: IVRWRegion; YStart : Double; var Layout : TVRWControlLayout);

    //Utility functions for XLSX output
    function SameRow(Val1, Val2 : Integer) : Boolean;
    function SameColumn(Val1, Val2 : Integer) : Boolean;

    property DBEngine: TReportWriterEngine
      read GetDBEngine;

    property EndOfReport: Boolean
      read GetEndOfReport
      write SetEndOfReport;

    property ExternalCall: Boolean
      read GetExternalCall;

    property FileName: string
      read GetFileName
      write SetFileName;

    property Filer: TReportFiler
      read GetFiler;

    property NewPageRequired: Boolean
      read GetNewPageRequired
      write SetNewPageRequired;

    property Report: IVRWReport
      read GetReport;

    property SectionFootersRequired: Boolean
      read GetSectionFootersRequired
      write SetSectionFootersRequired;

    property SectionHeadersRequired: Boolean
      read GetSectionHeadersRequired
      write SetSectionHeadersRequired;

    { Identifies the section number to use when looking up a total }
    property SectionNumber: SmallInt
      read GetSectionNumber
      write SetSectionNumber;

    property Totals: TTotals
      read FTotals;

    property RecordCount: Integer
      read FRecordCount
      write FRecordCount;

    property RecordTotal: Integer
      read FRecordTotal
      write FRecordTotal;

    { Holds the next available bitmap index, for bitmap caching. }
    property BitmapIndex: Integer
      read FBitmapIndex
      write FBitmapIndex;

    { CSVOutput holds the lines for a CSV file as they are built up by the
      report generator. }
    property CSVOutput: TStringList
      read FCSVOutput;

    { DBFOutput holds an IDBFWriter instance, for creating and outputting to DBF
      files }
    property DBFOutput: IDBFWriter
      read FDBFOutput;

    property CurrentControlName: string
      read FCurrentControlName;

    property PrintingRegion: Boolean
      read FPrintingRegion
      write FPrintingRegion;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Cancel;
    function Print(Report: IVRWReport; ExternalCall: Boolean = False): Boolean;

    property Error: string read GetError;

    property OnCheckRecord: TOnCheckRecordProc
      read FOnCheckRecord
      write FOnCheckRecord;

    property OnFirstPass: TOnCheckRecordProc
      read FOnFirstPass
      write FOnFirstPass;

    property OnSecondPass: TOnCheckRecordProc
      read FOnSecondPass
      write FOnSecondPass;

    property ReportFileName: ShortString
      read FReportFileName;

    property Cancelled: Boolean
      read FCancelled;

    property UserID: string
      read FUserID write FUserID;

  end;

  EReportGenerator = class(Exception)
  end;

  { Wrapper object for objects with a VRW Control interface. This is purely
    used so that we can store IVRWControl instances as objects in a stringlist.
    See the CSV functions. }
  TVRWControlWrapper = class
  private
    FVRWControl: IVRWControl;
  public
    constructor Create(ForControl: IVRWControl);
    destructor Destroy; override;
    property Control: IVRWControl read FVRWControl;
  end;

implementation

uses Graphics, Controls, Types, TEditVal, ETMiscU, RPMemo, Enterprise01_TLB,
  RWPrintR, frmVRWRangeFiltersU, Dialogs, MCParser, VRWReportU, ShellApi,
  StrUtils, VarConst, VarRec2U, BtKeys1U, BtrvU2, BTSupU1, prntprev, SQLUtils, IniFiles;

const
  //When printing to XLSX, this constant indicates how large the difference between the tops of two controls can be
  //before we put them into separate rows.
  XLSX_SAME_ROW_LIMIT = 5;

  //Same for columns rather than rows
  XLSX_SAME_COLUMN_LIMIT = 5;

function StrippedStrToFloat(Str: string): Double;
begin
  { Remove thousands separators }
  Str := StringReplace(Str, ',', '', [rfReplaceAll]);
  { If there is a negative sign at the right-hand end, move it to the
    left-hand end. }
  if (Str <> '') and (Str[Length(Str)] = '-') then
    Str := '-' + Copy(Str, 1, Length(Str) - 1);
  { Convert }
  Result := StrToFloatDef(Str, 0);
end;

function RightNegative(Str: string): string;
{ Forces any negative sign to the right-hand end of the string. }
var
  CharPos: Integer;
begin
  Result := Str;

  CharPos := Pos('-', Result);
  if (CharPos > 0) then
  begin
    Delete(Result, CharPos, 1);
    Result := Trim(Result) + '-';
  end;

end;

function Get_PWDefaults(PLogin: Str10): TPassDefType;
const
  Fnum     =  MLocF;
  Keypath  =  MLK;
var
  KeyS,
  KeyChk :  Str255;
begin
  FillChar(Result, Sizeof(Result), 0);
  KeyChk := FullPWordKey(PassUCode, 'D', PLogin);
  KeyS   := KeyChk;
  begin
    Status := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
    if (StatusOk) then
      Result := MLocCtrl^.PassDefRec;
    Result.Loaded := StatusOk;
  end; {With..}
end;

{ TVRWReportGenerator }

procedure TVRWReportGenerator.AddToTotals(TotalName: string);
{ Adds the field or formula name to the list of fields for which
  totals are maintained. }
var
  RegionNumber: Integer;
  Region: IVRWRegion;
begin
  { Add one entry for grand totals (SectionNumber = 0) }
  if not Totals.Exists(TotalName, 0) then
    Totals.Add(TotalName, 0);
  { For each section, add an entry against the section number }
  for RegionNumber := 0 to Report.vrRegions.rlCount - 1 do
  begin
    Region := Report.vrRegions.rlItems[RegionNumber];
    if (Region.rgSectionNumber > 0) then
    begin
      if not Totals.Exists(TotalName, Region.rgSectionNumber) then
        Totals.Add(TotalName, Region.rgSectionNumber);
    end;
  end;
end;

procedure TVRWReportGenerator.Cancel;
begin
  FCancelled := True;
end;

function TVRWReportGenerator.CheckForPageBreak(Region: IVRWRegion): Boolean;
{ Checks whether or not the specified region can fit in the room remaining on
  the page, and starts a new page if necessary. }
var
  BottomMargin: Integer;
  NextPrintPosition, AvailablePageHeight: Double;
begin
  Result := False;
  { Calculate how much room is needed at the bottom of the page to allow for
    the page footer }
  if (Report.vrRegions['Page Footer'] <> nil) and
     (Report.vrRegions['Page Footer'].rgControls.clCount > 0) then
    BottomMargin := Report.vrRegions['Page Footer'].rgHeight
  else
    BottomMargin := 0;

  { Determine whether or not the next print position will be beyond the
    bottom of the available page area }
  NextPrintPosition := Filer.YPos + Region.rgHeight;
  AvailablePageHeight := (Filer.PageHeight - Filer.BottomWaste) - BottomMargin;
  if (NextPrintPosition > AvailablePageHeight) then
  begin
    PrintNewPage;
    Result := True;
  end;
end;

function TVRWReportGenerator.CheckForSectionBreak(Region: IVRWRegion;
  ForceBreak: Boolean): Boolean;
var
  BreakRequired: Boolean;
  PageBreakRequired: Boolean;
  ControlNo: Integer;
  Field: TRWFieldObject;
  Section: IVRWRegion;
  SectionName: string;
  CompareText: string;
  Control : IVRWControl;
begin
  PageBreakRequired := False;
  BreakRequired := ForceBreak;
  SectionName := 'SECTION HEADER ' + IntToStr(Region.rgSectionNumber);
  Section := Report.vrRegions[SectionName];
  if not ForceBreak then
  begin
    { For each control in the region: }
    for ControlNo := 0 to Section.rgControlCount - 1 do
    begin
      Control := Section.rgControls.clItems[ControlNo];

      if Supports(Control, IVRWFieldControl) then
      with Control as IVRWFieldControl do
      begin
        if not vcDeleted then
        begin
          { Is it a section-break field? }
          if (Trim(vcSortOrder) <> '') then
          begin
            { If so, find the matching field in the Report Data Engine }
            Field := GetEngineControl(vcName);
            if (Field <> nil) then
            begin
              { Compare the contents. If they are different, a section break is
                required. }
              if (Field.Value <> Trim(vcText)) then
              begin
                BreakRequired := True;
              end;
            end;
            if vcPageBreak and BreakRequired then
              NewPageRequired := True;
          end;
        end;
      end;
      if Supports(Control, IVRWFormulaControl) then
      with Control as IVRWFormulaControl do
      begin
        if not vcDeleted then
        begin
          { Is it a section-break field? }
          if (Trim(vcSortOrder) <> '') then
          begin
            { If so, find the matching field in the Report Data Engine }
            Field := GetEngineControl(vcName);
            if (Field <> nil) then
            begin
              { Compare the contents. If they are different, a section break is
                required. }
              CompareText := Trim(vcText);
              if (Field.Value <> CompareText) then
              begin
                BreakRequired := True;
              end;
            end;
            // if vcPageBreak then
            if vcPageBreak and BreakRequired then
              NewPageRequired := True;
          end;
        end;
      end;
    end;
  end;
  Result := BreakRequired;
  if EndOfReport then
  begin
    FBreakingSection := 1;
    SectionFootersRequired := True;
  end
  else if BreakRequired then
  { If a section break is required, print the section footer (for the
    previous section), and the section header (for the current section) }
  begin
    if FBreakingSection = 0 then
    begin
      FBreakingSection := Region.rgSectionNumber;
      SectionHeadersRequired := True;
      SectionFootersRequired := True;
    end;
  end;
end;

procedure TVRWReportGenerator.CheckForSectionBreaks;
var
  Region: IVRWRegion;
  RegionNo: Integer;
  Force: Boolean;
begin
  Force := False;
  FBreakingSection := 0;
  for RegionNo := 0 to Report.vrRegions.rlCount - 1 do
  begin
    Region := Report.vrRegions.rlItems[RegionNo];
    if (Region.rgType = rtSectionHdr) then
    begin
      if CheckForSectionBreak(Region, Force) then
        { All subsequent sections must also break }
        Force := True;
    end;
    Region := nil;
  end;
end;

procedure TVRWReportGenerator.ClearSortedControlList(List: TStringList);
var
  i: Integer;
begin
  for i := 0 to List.Count - 1 do
  begin
    List.Objects[i].Free;
    List.Objects[i] := nil;
  end;
  List.Clear;
end;

function TVRWReportGenerator.ControlHoldsDate(Control: IVRWFieldControl): Boolean;
begin
  Result := (Control.vcVarType in [4, 12]);
end;

function TVRWReportGenerator.ControlHoldsFloat(Control: IVRWFieldControl): Boolean;
begin
  Result := (Control.vcVarType in [2, 3]);
end;

function TVRWReportGenerator.ControlHoldsInteger(Control: IVRWFieldControl): Boolean;
begin
  Result := (Control.vcVarType in [6, 7, 8, 9]);
end;

constructor TVRWReportGenerator.Create;
begin
  inherited Create;
  FTotals := TTotals.Create;
  FCSVOutput := TStringList.Create;
  FPrinterInfoSet := False;
end;

destructor TVRWReportGenerator.Destroy;
begin
  // CJS 2014-07-09 - ABSEXCH-15307 - CSV headers on export from VRW
  if Assigned(FCSVReportControls) then
  begin
    ClearSortedControlList(FCSVReportControls);
    FCSVReportControls.Free;
  end;

  if Assigned(FDBEngine) then
    FDBEngine.Free;
  if Assigned(FFiler) then
    FFiler.Free;
  FCSVOutput.Free;
  FTotals.Free;
  FReport := nil;
  inherited;
end;

procedure TVRWReportGenerator.ExtTextRect2(ftText: ShortString;
  const ftJustify: TPrintJustify; const ftLeft, ftTop, ftWidth,
  ftHeight: Double; const VCenter: Boolean);
const
  GenRealMask ='###,###,##0.00 ;###,###,##0.00-';
var
  TempYPos : Double;
  OK : Boolean;
  iIdx : SmallInt;
  CanTruncate: Boolean;

  // String to Float conversion function which supports '-' signs on right
  // hand edge of number
  procedure StrToDouble(StrNum : ShortString;
                        var StrOK  : Boolean;
                        var RNum   : Double;
                        var NoDecs : Byte);
  var
    Neg  : Boolean;
    Chk  : Integer;
  begin { StrToDouble }
    StrOK  := FALSE;
    Rnum   := 0.00;
    NoDecs := 0;
    Neg    := False;

    // strip off any spaces
    StrNum := Trim(StrNum);

    // Remove any 000's commas as they cause problems too
    if (Length(StrNum) > 0) then
      while (Pos(',', StrNum) > 0) do
        Delete (StrNum, Pos(',', StrNum), 1);

    // Check for -ve sign
    if (Length(StrNum) > 0) then
      if (StrNum[Length(StrNum)] = '-') then
      begin
        Neg := True;
        Delete (StrNum, Length(StrNum), 1);
      end; { if (StrNum[Length(StrNum)] = '-') }

    if (StrNum <> '') then
    begin
      if (Pos ('.', StrNum) > 0) then
      begin
        // Calculate number of decimal places in string
        NoDecs := Length(StrNum) - Pos ('.', StrNum);
      end; { if }

      // Convert string to float with error checking
      Val (StrNum, Rnum, Chk);
      StrOK := (Chk = 0);

      // Restore -ve sign to number
      if StrOK and Neg then RNum := -RNum;
    end { if (StrNum <> '')  }
    else
      StrOK:=True;
  end; { StrToDouble }

  // Squashes the text down so that it fits within the column without loss
  procedure SquashText;
  var
    FieldMask, BaseMask : ShortString;
    RNum                : Double;
    NoDecs, I           : Byte;
  begin { SquashText }
    with Filer do
    begin
      // Trim text based on justification before checking whether it will fit
      //PR 2/6/03- blank string in header was crashing preview.
      if Trim(ftText) <> '' then
      begin
        case ftJustify of
          pjLeft   : ftText := TrimRight(ftText);
          pjCenter : ftText := Trim(ftText);
          pjRight  : ftText := TrimLeft(ftText);
        end; { Case }
      end;

      // Check whether text will fit or not
      if (TextWidth(ftText) > ftWidth) then
      begin
        // Won't fit - determine whether text is text or number
        StrToDouble (ftText, OK, RNum, NoDecs);
        if OK then
        begin
          // Number - check whether Integer or Floating Point
          if (System.Pos ('.', ftText) > 0) then
          begin
            // Floating Point - 1) Retry without commas, but with full number
            //                  2) Incrementally reduce decimals
            //                  3) Display #'s like MS Excel

            // 1) Reformat without any thousands separators to see if that will fit
            while (System.Pos (',', ftText) > 0) do
              System.Delete (ftText, System.Pos (',', ftText), 1);

            if (TextWidth(ftText) > ftWidth) then
            begin
              // 2) reduce the decs - retry at full decs just in case the formatting is different
              { Generate a new formatting mask without commas }
              BaseMask := GenRealMask;
              while (System.Pos (',', BaseMask) > 0) do System.Delete (BaseMask, System.Pos (',', BaseMask), 1);

              for I := NoDecs downto 0 do
              begin
                { Generate a new mask with the correct decimals }
                FieldMask := FormatDecStrSD(I, BaseMask, FALSE);

                { reformat field into what it should look like }
                ftText := FormatFloat (FieldMask, Round_Up(RNum, I));

                if (TextWidth(ftText) < ftWidth) then Break;
              end; { For I }
            end; { if (TextWidth(ftText) > ftWidth) }
          end; { if (Pos ('.', ftText) > 0) }

          if (TextWidth(ftText) > ftWidth) then
            // No way to shorten string without misleading users so
            // display ### like MS Excel to indicate the field can't fit
            // NOTE: Integers just display ###'s if they don't fit
            ftText := StringOfChar ('#', Trunc(ftWidth / TextWidth('#')));
        end { if OK }
        else
          // Normal string - trim off characters until fits
          while (ftText <> '') And (TextWidth(ftText) > ftWidth) do
            System.Delete (ftText, Length(ftText), 1);
      end; { if (TextWidth(ftText) > ftWidth) }
    end; { with RepFiler1 }
  end; { SquashText }

begin { ExtTextRect2 }
  CanTruncate := True;
  with Filer do
  begin
    // filter out unprintable characters here. It just adds some stablility til I find the real problem.
    // 128 check stops Euro symbol being removed from ftText
    // 163 check stops £ being removed from ftText
    // 253 check stops Rave Macro identifier being removed from ftText
    for iIdx := 1 to Length(ftText) do
    begin
      if (
          (ord(ftText[iIdx]) < 32) or
          (ord(ftText[iIdx]) > 127)
         ) and
         (
          (ord(ftText[iIdx]) <> 128) and
          (ord(ftText[iIdx]) <> 163) and
          (ord(ftText[iIdx]) <> 253)
         ) then
        Delete(ftText,iIdx,1);
      if (ord(ftText[iIdx]) = 253) then
        CanTruncate := False;
    end;

    // 'Adjust' text to ensure that it will fit correctly within the column
    if CanTruncate then
      SquashText;

    // Sending Email with either RAVE PDF or RAVE HTML format attachments - use
    // standard RAVE commands to allow Renderer components to convert output
    TempYPos := YD2U(CursorYPos);

    with TMemoBuf.Create do
    try
      BaseReport := Filer;
      Text := ftText;
      if PrintingToExcel then
        Justify := pjLeft
      else
        Justify := ftJustify;
      FontTop := ftTop;
      PrintStart := ftLeft;
      PrintEnd := ftLeft + ftWidth;
      // Print the text
      PrintHeight (ftHeight, False);
    finally
      Free;
    end;
    GotoXY (CursorXPos, TempYPos);
  end; { with TheReport }
end; { ExtTextRect2 }

procedure TVRWReportGenerator.FinishDBFOutput;
begin
  FreeDBFLists(DBFOutput);
  FDBFOutput := nil;
  CoUninitialize;
end;

function TVRWReportGenerator.GetDBEngine: TReportWriterEngine;
begin
  Result := FDBEngine;
end;

function TVRWReportGenerator.GetEndOfReport: Boolean;
begin
  Result := FEndOfReport;
end;

function TVRWReportGenerator.GetEngineControl(
  ControlName: ShortString): TRWFieldObject;
{ Returns the field in the Report Data Engine. Returns nil if no field can be
  found against the specified name. }
var
  FieldNo: Integer;
begin
  Result := nil;
  for FieldNo := 0 to DBEngine.FieldCount - 1 do
  begin
    if (Trim(DBEngine.Fields[FieldNo].Name) = Trim(ControlName)) then
    begin
      Result := DBEngine.Fields[FieldNo];
      Break;
    end;
  end;
end;

function TVRWReportGenerator.GetError: string;
begin
  Result := FError;
end;

function TVRWReportGenerator.GetExternalCall: Boolean;
begin
  Result := FExternalCall;
end;

function TVRWReportGenerator.GetField(FieldName: ShortString): TRWFieldObject;
{ Returns the field in the Report Data Engine. Returns nil if no field can be
  found against the specified name. }
var
  FieldNo: Integer;
begin
  Result := nil;
  for FieldNo := 0 to DBEngine.FieldCount - 1 do
  begin
    if (Trim(DBEngine.Fields[FieldNo].VarName) = Trim(FieldName)) then
    begin
      Result := DBEngine.Fields[FieldNo];
      Break;
    end;
  end;
end;

function TVRWReportGenerator.GetFileName: string;
begin
  Result := FFileName;
end;

function TVRWReportGenerator.GetFiler: TReportFiler;
begin
  Result := FFiler;
end;

function TVRWReportGenerator.GetFirst: LongInt;
var
  Abort: Boolean;
begin
{$IFDEF DEBUGON}
  Dbug.msg(1, 'GetFirst');
{$ENDIF}
  Result := 0;
  Abort := False;
  { Calling DBEngine.Execute (below) will run once through the data, so call
    the OnFirstPass event (if assigned) to let the program know that we are
    about to do this. }
  if Assigned(FOnFirstPass) then
    OnFirstPass(0, 0, Abort);
  if not Abort then
  begin
    DBEngine.OnCheckRecord := FOnCheckRecord;
    Totals.Enabled := False;
    DBEngine.Execute;
    Totals.Enabled := True;
    DBEngine.GetFirst;
    FRecordCount := 0;
    FRecordTotal := DBEngine.RecordCount;
    { Going through the records as we print the report will be the second pass
      through the data, so call the OnSecondPass event (if assigned) to let the
      program know that we are about to do this. }
    if Assigned(FOnSecondPass) then
      OnSecondPass(0, RecordTotal, Abort);
    { Also call the OnCheckRecord event (if assigned) so that the program can
      set/reset the progress bar/progress messages/etc. RecordCount will be
      zero, because we haven't actually started yet. }
    if Assigned(FOnCheckRecord) then
      OnCheckRecord(RecordCount, RecordTotal, Abort);
  end;
  if Abort then
    Cancel;
end;

function TVRWReportGenerator.GetFormulaFieldNo(
  ControlName: ShortString): Integer;
var
  FieldNo: Integer;
begin
  Result := -1;
  for FieldNo := 0 to DBEngine.FieldCount - 1 do
  begin
    if (Trim(DBEngine.Fields[FieldNo].Name) = Trim(ControlName)) then
    begin
      Result := FieldNo;
      Break;
    end;
  end;
end;

function TVRWReportGenerator.GetNewPageRequired: Boolean;
begin
  Result := FNewPageRequired;
end;

function TVRWReportGenerator.GetNext: LongInt;
var
  Abort: Boolean;
begin
{$IFDEF DEBUGON}
  Dbug.msg(1, 'GetNext');
{$ENDIF}
  Result := 0;
  Totals.ResetUpdatedFlag;
  if not DBEngine.GetNext then
  begin
    EndOfReport := True;
    Result := 9;
  end
  else
  begin
    FRecordCount := FRecordCount + 1;
  end;
  if Assigned(FOnCheckRecord) then
  begin
    Abort := False;
    OnCheckRecord(RecordCount, RecordTotal, Abort);
    if Abort then
      Cancel;
  end;
end;

function TVRWReportGenerator.GetPrevious: LongInt;
var
  Abort: Boolean;
begin
{$IFDEF DEBUGON}
  Dbug.msg(1, 'GetPrevious');
{$ENDIF}
  Result := 0;
  if not DBEngine.GetPrevious then
  begin
    Result := 9;
  end
  else
  begin
    FRecordCount := FRecordCount - 1;
  end;
  if Assigned(FOnCheckRecord) then
  begin
    Abort := False;
    OnCheckRecord(RecordCount, RecordTotal, Abort);
    if Abort then
      Cancel;
  end;
end;

function TVRWReportGenerator.GetReport: IVRWReport;
begin
  Result := FReport;
end;

function TVRWReportGenerator.GetSectionFootersRequired: Boolean;
begin
  Result := FSectionFootersRequired;
end;

function TVRWReportGenerator.GetSectionHeadersRequired: Boolean;
begin
  Result := FSectionHeadersRequired;
end;

function TVRWReportGenerator.GetSectionNumber: SmallInt;
begin
  Result := FSectionNumber;
end;

function TVRWReportGenerator.InitialisePrinter: Boolean;
var
  ReportPrinter: ShortString;
  iOptIdx: Integer;
begin
  if (not FPrinterInfoSet) then
  begin
    PrinterInfo := RpDev.SBSSetupInfo;
    PrinterInfo.feMiscOptions[Integer(XLS_SHOW_REPORT_HEADER)]  := True;
    PrinterInfo.feMiscOptions[Integer(XLS_SHOW_PAGE_HEADER)]    := True;
    PrinterInfo.feMiscOptions[Integer(XLS_SHOW_SECTION_HEADER)] := True;
    PrinterInfo.feMiscOptions[Integer(XLS_SHOW_REPORT_LINES)]   := True;
    PrinterInfo.feMiscOptions[Integer(XLS_SHOW_SECTION_FOOTER)] := True;
    PrinterInfo.feMiscOptions[Integer(XLS_SHOW_PAGE_FOOTER)]    := True;
    PrinterInfo.feMiscOptions[Integer(XLS_SHOW_REPORT_FOOTER)]  := True;
    FPrinterInfoSet := True;
  end;
  Result := True;
  if ExternalCall then
  begin
    Report.WritePrintMethodParams(PrinterInfo);
    {$IFDEF SENTREPENG}
    //Turn off messages
    //PR: 28/06/2011 Don't want printer settings remembered for Sentimail - particularly 'open file after creating' (ABSEXCH-11546)
    //PR: 22/08/2011 ABSEXCH-11766 Simply avoiding WritePrintMethodParams call above was losing PrintMethod. Change to specifically
    //take out the properties we don't want.
    PrinterInfo.feMiscOptions[Integer(GEN_NO_MESSAGES)]  := True;
    PrinterInfo.feMiscOptions[Integer(HTML_AUTO_OPEN)]   := False;
    PrinterInfo.feMiscOptions[Integer(DBF_AUTO_OPEN)]    := False;
    PrinterInfo.feMiscOptions[Integer(CSV_AUTO_OPEN)]    := False;
    {$ENDIF}
  end
  else
  begin
    // popup a printer selection dialog
    with TPrintDlg.Create(Application.MainForm) do
    begin
      try
        { Copy the print method parameters into the PrinterInfo record (the
          Print Dialog will update PrinterInfo) }
//        Report.WritePrintMethodParams(PrinterInfo);
        // HM 07/03/05: Changed to pass default printer into Execute as parameter
        UserProfile^ := Get_PWDefaults(FUserID);
        ReportPrinter := UserProfile.ReportPrn;
        if Execute('', PrinterInfo, ReportPrinter) then
        begin
//          SetPaperParams(ReportConstructInfo.PaperParameters, PrinterInfo);
          { Copy the PrintInfo information back into the report }
          Report.ReadPrintMethodParams(PrinterInfo);
        end
        else
          Result := False;
      finally
        Free;
      end; // try...finally
    end; // with TPrintDlg.Create(Application.MainForm) do...
  end; // if bExternalCaller then...else...
end;

function TVRWReportGenerator.InitialiseRangeFilters: Boolean;
var
  Control: IVRWControl;
  InputField: IVRWInputField;
  Entry: Integer;
  RFDlg: TfrmVRWRangeFilters;
begin
  Result := True;
  if not ExternalCall then
  begin
    RFDlg := TfrmVRWRangeFilters.Create(nil);
    RFDlg.DialogMode := rflmPrintTime;
    try
      if RangeFilterSet(Report.vrRangeFilter) And Report.vrRangeFilter.rfAlwaysAsk Then
        RFDlg.AddRangeFilter('Index Filter', 255, Report.vrRangeFilter);

      for Entry := 0 to Report.vrControls.clCount - 1 do
      begin
        Control := Report.vrControls.clItems[Entry];
        { Only field controls can have a range filter }
        if Supports(Control, IVRWFieldControl) then
        with Control as IVRWFieldControl do
        begin
          { Does this control have a Range Filter? }
          if RangeFilterSet(vcRangeFilter) and (vcRangeFilter.rfAlwaysAsk) then
          begin
            { If so, add it to the Range Filter form's list }
            RFDlg.AddRangeFilter(vcFieldName, vcVarType, vcRangeFilter);
          end;
        end;  // if Supports(...
        Control := nil;
      end;  // for Entry...

      for Entry := 0 to (Report as IVRWReport3).vrInputFields.rfCount - 1 do
      begin
        InputField := (Report as IVRWReport3).vrInputFields.rfItems[Entry];
        if (InputField.rfAlwaysAsk) then
          RFDlg.AddInputField(InputField);
        InputField := nil;
      end;  // for Entry...

      RFDlg.Caption := 'Report Parameters';

      if (RFDlg.Count > 0) then
      begin
        RFDlg.mulRangeFilters.DesignColumns[0].Caption := 'Name/Location';
        RFDlg.ShowModal;
        Result := (RFDlg.ModalResult = mrOk);
      end;
    finally
      RFDlg.Free;
    end;
  end;  // if not ExternalCall...
end;

procedure TVRWReportGenerator.InitialiseReportEngine;
const
  Identifiers: array[0..4] of string =
  (
    'TOTALFIELD',
    'COUNTFIELD',
    'INFO',
    'FML',
    'RF'
  );
begin
  { Attempt to get an instance of the Report Data Engine }
  if (FDBEngine = nil) then
  begin
    FDBEngine := TReportWriterEngine.Create;
    FDBEngine.GetCustomValue := ParserCallBack;
    FDBEngine.SetCustomIds(Identifiers);
    FDBEngine.NotifyField := OnNotifyField;
//    FDBEngine.NotifyFieldValue := OnNotifyFieldValue;
  end;
  if (FDBEngine <> nil) then
  begin
    DBEngine.FileNo       := Report.vrMainFileNum;
    DBEngine.IndexNo      := Report.vrIndexID;
    DBEngine.TestMode     := Report.vrTestModeParams.tmTestMode;
    DBEngine.SampleCount  := Report.vrTestModeParams.tmSampleCount;
    DBEngine.RefreshFirst := Report.vrTestModeParams.tmRefreshStart;
    DBEngine.RefreshLast  := Report.vrTestModeParams.tmRefreshEnd;
    DBEngine.ClearFields;
  end
  else
    raise EReportGenerator.Create('Failed to create Report Data Engine');
end;

procedure TVRWReportGenerator.InitialiseReportFields;
{ Installs the fields into the Report Data Engine }

  //PR: 16/10/2014 Added function to set printing order for fields before adding to engine.
  {Fields are added to the engine in the order in which the user creates them and the engine processes them in that order;
  however, this causes a problem with fields such as OPLNKTRA which specifies that references to TH fields
  occuring after it appears refer to the SIN/SDN rather than the SOR or the SRC. Consequently we need to specify the order
  in which the fields should be processed by the engine. This is done by setting a position property on the field object;
  the engine will then sort the list of fields in order of position before running the report.

  The formula to give a unique integer for a field's position is

                 10 million times the number of the region in which the field appears
                 plus 2000 times the field's top position (IVRWControl.vcTop)
                 plus the field's left postion (IVRWControl.vcLeft.)}

  function CalcFieldPosition(RegionName : string;
                             ControlTop : Integer;
                             ControlLeft : Integer;
                             ReportWidth : Integer;
                             RegionCount : Integer) : Integer;

  const
    RegionNames : Array[0..6] of string =
      ('Report Header', 'Page Header', 'Section Header',
       'Report Line', 'Section Footer', 'Page Footer', 'Report Footer');
  var
    i : integer;
    RegionNo : Integer;
    HeaderFooterCount : Integer;
  begin
    //Get number of section headers/footers - 1 = 1 header & 1 footer
    HeaderFooterCount := (RegionCount - 5) div 2;

    //Find out which region we're in
    for i := 0 to 6 do
      if UpperCase(Copy(RegionNames[i], 1, 11)) = UpperCase(Copy(RegionName, 1, 11)) then
      begin
        RegionNo := i;
        Break;
      end;

    //Calculate the region's number
    Case RegionNo of
      0, 1 : ; //Report header and Page header - always first and second so no need to do anything
         2 : begin
               //Section Header
               Delete(RegionName, 1, 15);
               RegionNo := StrToInt(RegionName) + 1;
             end;
         3 : begin
               //Report Line - first line after last section header
               RegionNo := 2 + HeaderFooterCount;
             end;
         4 : begin
               //Section Footer - 1 comes directly after Report Line
               Delete(RegionName, 1, 15);
               RegionNo := StrToInt(RegionName) + HeaderFooterCount + 2;
             end;
      5, 6 : RegionNo := RegionCount - (7 - RegionNo);

    end; //case

    Result := (RegionNo * 10000000) + ((ControlTop * ReportWidth) + ControlLeft);

  end;


  procedure AddInputField (InputField: TRWInputObject;
    RangeFilter: IVRWBaseInputField);
  begin // AddInputField

    InputField.Name := RangeFilter.rfName;
    InputField.InputType := Byte(RangeFilter.rfType);
    case RangeFilter.rfType of
      1 : // date
        begin
          // MH 21/03/05: Reformat from Andy's DDMMYYYY to standard YYYYMMDD
          // on the fly to avoid breaking existing reports
          If (Length(RangeFilter.rfFromValue) = 8) Then
            InputField.DateFrom := Copy(RangeFilter.rfFromValue, 5, 4) + Copy(RangeFilter.rfFromValue, 3, 2) + Copy(RangeFilter.rfFromValue, 1, 2);
          If (Length(RangeFilter.rfToValue) = 8) Then
            InputField.DateTo := Copy(RangeFilter.rfToValue, 5, 4) + Copy(RangeFilter.rfToValue, 3, 2) + Copy(RangeFilter.rfToValue, 1, 2);
        end;
      2 : // period
        begin
          // tried DateFrom/To, ValueFrom/To and StringFrom/To
          // also tried Copy(s,1,2) to extract the period value from the string
          // string example, 01/2002, period being the first two characters.
          //InputField.DateFrom := RangeFilter.rfFromValue;
          //InputField.DateTo := RangeFilter.rfToValue;

          Try
            If (Trim(RangeFilter.rfFromValue) <> '') And (Length(RangeFilter.rfFromValue) = 6) Then
            Begin
              InputField.PeriodFrom := StrToInt(Copy (RangeFilter.rfFromValue, 1, 2));
              InputField.YearFrom := StrToInt(Copy (RangeFilter.rfFromValue, 3, 4));
            End; // If (Trim(RangeFilter.rfFromValue) <> '') And (Length(RangeFilter.rfFromValue) = 6)
          Except
            On Exception Do
              MessageDlg ('Invalid From Period/Year value (' + RangeFilter.rfFromValue + ') for Input Field ' + RangeFilter.rfName, mtError, [mbOk], 0);
          End; // Try..Except

          Try
            If (Trim(RangeFilter.rfToValue) <> '') And (Length(RangeFilter.rfToValue) = 6) Then
            Begin
              InputField.PeriodTo := StrToInt(Copy (RangeFilter.rfToValue, 1, 2));
              InputField.YearTo := StrToInt(Copy (RangeFilter.rfToValue, 3, 4));
            End; // If (Trim(RangeFilter.rfToValue) <> '') And (Length(RangeFilter.rfToValue) = 6)
          Except
            On Exception Do
              MessageDlg ('Invalid To Period/Year value (' + RangeFilter.rfFromValue + ') for Input Field ' + RangeFilter.rfName, mtError, [mbOk], 0);
          End; // Try..Except
        end;
      3 : // value
        begin
          { Remove thousands separator, and make sure any negative sign is on
            the left end of the string. }
          InputField.ValueFrom := StrippedStrToFloat(RangeFilter.rfFromValue);

          { Remove thousands separator, and make sure any negative sign is on
            the left end of the string. }
          InputField.ValueTo := StrippedStrToFloat(RangeFilter.rfToValue);
        end;
      5 : // currency
        begin
          If (Length(RangeFilter.rfFromValue) > 0) Then
            InputField.CurrencyFrom := Ord(RangeFilter.rfFromValue[1]);

          If (Length(RangeFilter.rfToValue) > 0) Then
            InputField.CurrrencyTo := Ord(RangeFilter.rfToValue[1]);
        end;
      4,   // ASCII
      6,   // document no
      7,   // customer code
      8,   // supplier code
      9,   // nominal code
      10,  // stock code
      11,  // cost centre code
      12,  // department code
      13,  // location code
      17,  // Job Code
      18 : // Bin Code
        begin
          InputField.StringFrom := RangeFilter.rfFromValue;
          InputField.StringTo := RangeFilter.rfToValue;
        end;
    end; // case InputDets.siType of..

  End; // AddInputField

var
  ControlNo, i: Integer;
  Field: TRWFieldObject;
  Control: IVRWControl;
  TotalType: TTotalType;
begin
  Totals.Clear;

  { Input Fields }
  for i := 0 to (Report as IVRWReport3).vrInputFields.rfCount - 1 do
  begin
    AddInputField(DBEngine.AddInput, (Report as IVRWReport3).vrInputFields.rfItems[i]);
  end;

  for ControlNo := 0 to Report.vrControls.clCount - 1 do
  begin
    Control := Report.vrControls.clItems[ControlNo];
    if not Control.vcDeleted then
    begin
      { DB fields }
      if Supports(Control, IVRWFieldControl) then
      with Control as IVRWFieldControl do
      begin
        Field := DBEngine.AddField;
        Field.VarName     := vcFieldName;
        Field.Name        := vcName;

        //PR: 16/10/2014 Added position for Order Payments
        Field.Position := CalcFieldPosition(vcRegionName, vcTop, vcLeft, 2000, FReport.vrRegions.rlCount);
        Field.PeriodField := vcPeriodField;
        Field.Filter      := vcSelectCriteria;
        Field.PrintFilter := vcPrintIf;
        Field.PeriodField := (trim(vcPeriod) <> '') or
                             (trim(vcYear) <> '');
        if Field.PeriodField then
        begin
          Field.Period := trim(vcPeriod);
          Field.Year := trim(vcYear);
          Field.Currency := vcCurrency;
        end;
        if (Trim(vcSortOrder) <> '') then
          Field.SortOrder := vcSortOrder;
        Field.DecPlaces := vcVarNoDecs;
        Field.CalcField := FALSE;
        if (vcType = ctField) then
          if(Field.DataType in [2, 3, 6, 7, 8, 9]) then
            AddToTotals((Control as IVRWFieldControl).vcFieldName);
        if RangeFilterSet(vcRangeFilter) then
        begin
          if (vcRangeFilter.rfName = '') then
            vcRangeFilter.rfName := 'RF_' + Control.vcName;
          vcParsedInputLine :=
            'DBF[' + trim(vcFieldName) + '] >= INP[' + vcRangeFilter.rfName + ',START] AND ' +
            'DBF[' + trim(vcFieldName) + '] <= INP[' + vcRangeFilter.rfName + ',END]';
          Field.RangeFilter := vcParsedInputLine;
          AddInputField(DBEngine.AddInput, vcRangeFilter);
        end
        else
          Field.RangeFilter := '';
        if (vcInputLine.rfName <> '') then
        begin
          Field.InputLink := DBEngine.InputNumber(vcInputLine.rfName);
        end;
      end;
      { Formula fields }
      if Supports(Control, IVRWFormulaControl) then
      with Control as IVRWFormulaControl do
      begin
        TotalType := vcTotalType;
  { TODO: Remove TotalType 'ttUnknown' bodge when designer is fixed }
        if TotalType in [ttUnknown, ttNone, ttCalc, ttRangeFilter] then
  //      if TotalType in [ttNone, ttCalc, ttRangeFilter] then
        begin
          Field := DBEngine.AddField;
          Field.Name        := vcName;

          //PR: 16/10/2014 Added position for Order Payments
          Field.Position := CalcFieldPosition(vcRegionName, vcTop, vcLeft, 2000, FReport.vrRegions.rlCount);
          Field.PrintFilter := vcPrintIf;
          Field.Calculation := vcFormulaDefinition;
          Field.PeriodField := (trim(vcPeriod) <> '') or
                               (trim(vcYear) <> '');
          if Field.PeriodField then
          begin
            Field.Period := trim(vcPeriod);
            Field.Year := trim(vcYear);
            Field.Currency := vcCurrency;
          end;
          if (Trim(vcSortOrder) <> '') then
            Field.SortOrder := vcSortOrder;
          Field.DecPlaces := vcDecimalPlaces;
          Field.CalcField := True;
          if Copy(Trim(vcFormulaDefinition), 1, 1) <> '"' then
            AddToTotals((Control as IVRWFormulaControl).vcFormulaName);
        end; // if TotalType in...
      end; // if Supports(Control, IVRWFormulaControl)...
    end; // if not Control.vcDeleted...
    Control := nil;
  end;

  { Range filter for index }
  if RangeFilterSet(Report.vrRangeFilter) Then
  begin
    Report.vrRangeFilter.rfName := 'RepIdxInputFilter';
    AddInputField(DBEngine.AddInput, Report.vrRangeFilter);
    DBEngine.InputLink := Report.vrRangeFilter.rfName;
  end; // If RangeFilterSet(RangeFilter)
end;

procedure TVRWReportGenerator.InitialiseReportFiler;
begin
  if (FFiler = nil) then
    FFiler := TReportFiler.Create(nil);
  if (FFiler <> nil) then
  begin
    { Temporary file for report }
    Filer.FileName         := TemporaryReportFileName;
    Filer.StreamMode       := smFile;
    Filer.Units            := unMM;
    Filer.AccuracyMethod   := amAppearance;
    Filer.LineHeightMethod := lhmFont;
    FReportFileName := Filer.FileName;
    { Direct the OnPrint callback to the correct method:
        Normal print/print preview:   Process
        CSV output                :   ProcessForCSV
        DBF output                :   ProcessForDBF }
    with Report.vrPrintMethodParams do
      if (pmPrintMethod = 4) then // output to DBF file
        Filer.OnPrint := ProcessForDBF
      else if (pmPrintMethod = 6) then // output to CSV file
        Filer.OnPrint := ProcessForCSV
      else
        Filer.OnPrint := Process;
    Filer.PrinterIndex := PrinterInfo.DevIdx;
    Filer.Orientation := TOrientation(Report.vrPaperOrientation);
  end
  else
    raise EReportGenerator.Create('Failed to create Report Printer Engine');
end;

function TVRWReportGenerator.IsNumeric(Value: string): Boolean;
var
  CharPos: Integer;
const
  NumSet: set of Char = ['0','1','2','3','4','5','6','7','8','9','.', ',','-'];
begin
  Result := (Trim(Value) <> '');
  for CharPos := 1 to Length(Value) do
  begin
    if not (Value[CharPos] in NumSet) then
      Result := False;
  end;
end;

procedure TVRWReportGenerator.OnNotifyField(const ControlName: string);
{ Called by DBEngine just before processing a field -- for Formulas,
  FieldName will be the formula name. Used by the ParserCallBack. }
begin
  FCurrentControlName := ControlName
end;

procedure TVRWReportGenerator.OnNotifyFieldValue(const ControlName,
  FieldValue: string);
{ Called by DBEngine just after processing a field. Used for updating total
  field values }

  function IsFooter(RegionName: string): Boolean;
  begin
    Result := (Copy(RegionName, 1, 14) = 'Section Footer') OR
              (RegionName = 'Report Footer');
  end;

  function IsBreakingSection(RegionName: string): Boolean;
  begin
    Result := FReport.vrRegions[RegionName].rgSectionNumber = FBreakingSection;
  end;

var
  Control: IVRWControl;
  DBName: ShortString;
  ControlInFooter: Boolean;
  ControlInSection: Boolean;
  Field: TRWFieldObject;
  Value: Double;
begin
  if Totals.Enabled and PrintingRegion then
  begin
    DBName := '';
    Control := FReport.vrControls[ControlName];
    Value := StrippedStrToFloat(FieldValue);
//    if (Value <> 0) then
    begin
{$IFDEF DEBUGON}
      if Supports(Control, IVRWFieldControl) then
        Dbug.msg(2, '    Checking totals for ' + (Control as IVRWFieldControl).vcFieldName)
      else if Supports(Control, IVRWFormulaControl) then
        Dbug.msg(2, '    Checking totals for ' + (Control as IVRWFormulaControl).vcFormulaName);
{$ENDIF}
      if Supports(Control, IVRWFieldControl) then
      begin

        ControlInFooter := IsFooter((Control as IVRWFieldControl).vcRegionName);
        ControlInSection := IsBreakingSection((Control as IVRWFieldControl).vcRegionName);
        if ControlInFooter and Totals.InFooter then // and ControlInSection then
          DBName := (Control as IVRWFieldControl).vcFieldName
        else if (not ControlInFooter) and (not Totals.InFooter) then
          DBName := (Control as IVRWFieldControl).vcFieldName;

      end
      else if Supports(Control, IVRWFormulaControl) then
      begin

        ControlInFooter := IsFooter((Control as IVRWFormulaControl).vcRegionName);
        ControlInSection := IsBreakingSection((Control as IVRWFormulaControl).vcRegionName);
        if ControlInFooter and Totals.InFooter then // and ControlInSection then
          DBName := (Control as IVRWFormulaControl).vcFormulaName
        else if (not ControlInFooter) and (not Totals.InFooter) then
          DBName := (Control as IVRWFormulaControl).vcFormulaName;

      end;
      if (DBName <> '') then
        Totals.AddToTotal(DBName, StrippedStrToFloat(FieldValue));
{$IFDEF DEBUGON}
      if (DBName = '') then
        if Totals.InFooter then
          Dbug.msg(2, '     -- ignored, control is not in the current section footer')
        else
          Dbug.msg(2, '     -- ignored, control is not on a record line');
{$ENDIF}
    end;
  end;
end;

procedure TVRWReportGenerator.ParseFormula(Control: IVRWFormulaControl);
var
  ErrorCode: SmallInt;
  FieldNo: Integer;
  ParserResult: ResultValueType;
const
  Identifiers: array[0..4] of string =
  (
    'TOTALFIELD',
    'COUNTFIELD',
    'INFO',
    'FML',
    'RF'
  );
begin
  { Call DBEngine's parser to evaluate the formula. }
  FieldNo := GetFormulaFieldNo(Control.vcName);
  if FieldNo <> -1 then
  begin
    ParserResult :=
      DBEngine.CustomParse(
        Control.vcFormulaDefinition,
        Identifiers,
        ParserCallBack,
        FieldNo,
        ErrorCode
      );
    if (Control.vcFormulaDefinition[1] = '"') then
      Control.vcText := ParserResult.StrResult
    else
      //PR: 22/07/2014 ABSEXCH-12602 Change call to Round_Up to use Control.vcDecimalPlaces rather than 2, so
      //                             that we get the full value
      Control.vcText :=
        FloatToStrF(
          Round_Up(ParserResult.DblResult, Control.vcDecimalPlaces),
          ffNumber,
          15,
          Control.vcDecimalPlaces
        );
  end;
end;

function TVRWReportGenerator.ParserCallBack(const ValueIdentifier,
  ValueName: string; var ErrorCode: SmallInt; var ErrorString : ShortString;
      var ErrorWord : ShortString): ResultValueType;

  function ExtractTotalName(FromString: string): string;
  var
    CharStart, CharEnd: Integer;
  begin
    Result := '';
    FromString := Trim(Uppercase(ValueName));
    { Check for DBF indentifier }
    CharStart := Pos('DBF', FromString);
    { If no DBF identifier is found, look for an FML (formula) identifier
      instead }
    if (CharStart = 0) then
      CharStart := Pos('FML', FromString);
    { If an identifier was found... }
    if (CharStart > 0) then
    begin
      { ...extract the name from inside the square brackets }
      Result := Copy(FromString, CharStart + 4, Length(FromString));
      CharEnd := Pos(']', Result);
      if (CharEnd = 0) then
        CharEnd := Length(FromString) + 1;
      Result := Copy(Result, 1, CharEnd - 1);
    end;
  end;

var
  TotalName: string;
  Field: TRWFieldObject;
  BaseControl: IVRWControl;
  Control: IVRWFieldControl;
  FormulaControl: IVRWFormulaControl;
  RegionName: ShortString;
  Entry: Integer;
  Formula, Desc: string;
  R : TParserStateRec;
  FromStr, ToStr: ShortString;
begin
  Result.StrResult := '';
  Result.DblResult := 0.00;
  if (Uppercase(ValueIdentifier) = 'TOTALFIELD') then
  begin
    { Retrieve the total from the Totals handler }
    TotalName := ExtractTotalName(ValueName);
    if (TotalName <> '') then
    begin
      FormulaControl := Report.vrControls[CurrentControlName] as IVRWFormulaControl;
      if (FormulaControl <> nil) then
      begin
        Result.DblResult :=
          Totals.Value(
            TotalName,
            FReport.vrRegions[FormulaControl.vcRegionName].rgSectionNumber
          );
        Result.StrResult := FormatFloat('#,0.' + StringOfChar('0', FormulaControl.vcDecimalPlaces), Result.DblResult);
        Result.StrResult := RightNegative(Result.StrResult);
{$IFDEF DEBUGON}
        Dbug.Msg(2, 'TotalField ' + TotalName + ' = ' + Result.StrResult);
{$ENDIF}
      end;
    end;
  end
  else if (Uppercase(ValueIdentifier) = 'COUNTFIELD') then
  begin
    TotalName := ExtractTotalName(ValueName);
    if (TotalName <> '') then
    begin
      BaseControl := Report.vrControls[CurrentControlName] as IVRWControl;
      if (BaseControl <> nil) then
      begin
        Result.DblResult :=
          Totals.FieldCount(
            TotalName,
            FReport.vrRegions[BaseControl.vcRegionName].rgSectionNumber,
            EndOfReport
          );
        Result.StrResult := FormatFloat('#,0', Result.DblResult);
        Result.StrResult := RightNegative(Result.StrResult);
      end;
    end;
  end
  else if (Uppercase(ValueIdentifier) = 'DBF') then
  begin
    Control := Report.vrControls[CurrentControlName] as IVRWFieldControl;
    { Retrieve the field's value from the current record }
    Field := GetField(ValueName);
    if (Field <> nil) and (Field.Print) then
    begin
      Result.DblResult := StrippedStrToFloat(Field.Value);
      Result.StrResult := FormatFloat('#,0.' + StringOfChar('0', Control.vcVarNoDecs), Result.DblResult);
      Result.StrResult := RightNegative(Result.StrResult);
    end;
  end
  else if (Uppercase(ValueIdentifier) = 'FML') then
  begin
    { Locate the related formula control }
    FormulaControl := Report.FindFormulaControl(ValueName);
    if FormulaControl <> nil then
    begin
      { Get the formula }
      Formula := FormulaControl.vcFormulaDefinition;

      { Parse the formula. }
      SaveParser(R);
      ParseFormula(FormulaControl);
      RestoreParser(R);

      { Return the result }
      Result.DblResult := StrippedStrToFloat(FormulaControl.vcText);
      if (Copy(Formula, 1, 1) = '"') then
        Result.StrResult := FormulaControl.vcText
      else
      begin
        Result.StrResult := FormatFloat('#,0.' + StringOfChar('0', FormulaControl.vcDecimalPlaces), Result.DblResult);
        Result.StrResult := RightNegative(Result.StrResult);
      end;
      FormulaControl := nil;
    end;
  end
  else if (Uppercase(ValueIdentifier) = 'RF') then
  { An RF field prints a description of the specified Range Filter }
  begin
    { Prepare the description }
    Desc := 'Range Filter - ' + ValueName + ' ';
    { Locate the matching Range Filter }
    for Entry := 0 to Report.vrControls.clCount - 1 do
    begin
      if Supports(Report.vrControls.clItems[Entry], IVRWFieldControl) then
      begin
        Control := Report.vrControls.clItems[Entry] as IVRWFieldControl;
        if UpperCase(Control.vcRangeFilter.rfDescription) = UpperCase(ValueName) then
          { Found a matching control }
          Break;
        Control := nil;
      end;
    end;
    if Control <> nil then
    begin
      { Extract the To and From values, and build a description from them. }
      FromStr := Control.vcRangeFilter.rfFromValue;
      ToStr   := Control.vcRangeFilter.rfToValue;
      Desc := Desc + ' from ' + Control.vcRangeFilter.GetRangeString(FromStr) +
                     ' to '   + Control.vcRangeFilter.GetRangeString(ToStr);
      Control := nil;
    end
    else if (ValueName = 'INDEX') then
    begin
      FromStr := Report.vrRangeFilter.rfFromValue;
      ToStr   := Report.vrRangeFilter.rfToValue;
      Desc := Desc + ' from ' + Report.vrRangeFilter.GetRangeString(FromStr) +
                     ' to '   + Report.vrRangeFilter.GetRangeString(ToStr);
    end
    else
      Desc := Desc + 'not found.';
    { Return the description }
    Result.DblResult := 0.00;
    Result.StrResult := Desc;
  end
  else if (Uppercase(ValueIdentifier) = 'INFO') then
  { An INFO field returns one of the Rave Report macro values }
  begin
    if PrintingToExcel then
    begin
      Result := ReplaceMacro(ValueName);
    end
    else
    if (Uppercase(ValueName) = 'DATE') then
    begin
      Result.StrResult := Filer.Macro(midCurrDateShort);
      Result.DblResult := 0.00;
    end
    else if (Uppercase(ValueName) = 'TIME') then
    begin
      Result.StrResult := Filer.Macro(midCurrTimeAMPM);
      Result.DblResult := 0.00;
    end
    else if (Uppercase(ValueName) = 'FIRSTPAGE') then
    begin
      Result.StrResult := Filer.Macro(midFirstPage);
      Result.DblResult := 0.00;
    end
    else if (Uppercase(ValueName) = 'LASTPAGE') then
    begin
      Result.StrResult := Filer.Macro(midLastPage);
      Result.DblResult := 0.00;
    end
    else if (Uppercase(ValueName) = 'CURRENTPAGE') then
    begin
      Result.StrResult := Filer.Macro(midCurrentPage);
      Result.DblResult := 0.00;
    end
    else if (Uppercase(ValueName) = 'TOTALPAGES') then
    begin
      Result.StrResult := Filer.Macro(midTotalPages);
      Result.DblResult := 0.00;
    end
    else if (Uppercase(ValueName) = 'REPORTNAME') then
    begin
      Result.StrResult := FReport.vrName;
      Result.DblResult := 0.00;
    end
    else if (Uppercase(ValueName) = 'REPORTDESC') then
    begin
      Result.StrResult := FReport.vrDescription;
      Result.DblResult := 0.00;
    end;
  end;
end;

procedure TVRWReportGenerator.PrepareCSVReportControls;
begin
  { Create the list if it does not exist }
  if not Assigned(FCSVReportControls) then
    FCSVReportControls := TStringList.Create;

  { Clear any existing entries }
  FCSVReportControls.Clear;

  { Build the sorted list of controls }
  SortReportControls(FCSVReportControls);
end;

function TVRWReportGenerator.PrepareLayout(Region: IVRWRegion;
  Control: IVRWControl; Top: Double): TVRWControlLayout;
{ Returns a TVRWControlLayout record which holds the details of the layout
  for the specified control -- it's actual position, size, etc. }
var
  RegionBottom: Double;
  RightPos: Double;
  MinWidth: Double;
begin
  Result.X := Control.vcLeft;
  Result.Y := Top + Control.vcTop;
  Result.W := Control.vcWidth;

  RegionBottom := Top + Region.rgHeight;
  if ((Result.Y + Control.vcHeight) < RegionBottom) then
    Result.H := Control.vcHeight
  else
    Result.H := (RegionBottom - Result.Y);
  Result.Text := Control.vcText;
  { Apply field formatting }
  if (Pos('%', Control.vcFieldFormat) <> 0) then
    Result.Text := Result.Text + '%';
  if (Pos('R', Control.vcFieldFormat) <> 0) then
    Result.Justify := pjRight
  else if (Pos('C', Control.vcFieldFormat) <> 0) then
    Result.Justify := pjCenter
  else
    Result.Justify := pjLeft;

  Filer.FontName  := Control.vcFont.Name;
  Filer.FontSize  := Control.vcFont.Size;
  Filer.FontColor := Control.vcFont.Color;
  Filer.Bold := (fsBold in Control.vcFont.Style);
  Filer.Italic := (fsItalic in Control.vcFont.Style);
  Filer.Underline := (fsUnderline in Control.vcFont.Style);
  Filer.Strikeout := (fsStrikeout in Control.vcFont.Style);

  // For formula controls, force the width to be large enough to include the
  // whole formula, otherwise Rave is liable to truncate the formula.
  if Supports(Control, IVRWFormulaControl) then
  begin
    RightPos := Result.X + Result.W;
    MinWidth := Filer.TextWidth(Result.Text);
    if (Result.W < MinWidth) then
      Result.W := MinWidth;
    if (Result.Justify = pjRight) then
      Result.X := RightPos - Result.W;
  end;

  Result.Print := (Result.H > 0);
end;

procedure TVRWReportGenerator.PrepareXLSX;
begin
  //Load FXLSXRegionControls list with columns we'll use to set
  //excel column widths
  FindControlsForXSLXColumns;

  //Set column widths
  SetXLSXColumns;
end;

function TVRWReportGenerator.Print(Report: IVRWReport;
  ExternalCall: Boolean): Boolean;
{ Main entry point for Report Generator }
var
  ReportFileName: ShortString;
begin
  FError := '';
  FCancelled := False;
  FExternalCall := ExternalCall;
  Result := True;
  try
    FReport := Report;
    try

      FileName := FReport.vrFilename;
      InitialiseReportEngine;
      if InitialisePrinter and
         InitialiseRangeFilters then
      begin
        InitialiseReportFiler;
        InitialiseReportFields;

        //PR 12/08/2016 2016-R1 ABSEXCH-10720: Create the Export To Excel sub-object for printing to .xlsx
        If (Report.vrPrintMethodParams.pmPrintMethod = 5) Then
        Begin
          ExportToExcel := TExportReportToExcel.Create;
          FXLSXRegionControls :=  TStringList.Create;
          PrepareXLSX;
        End; // If (RDevRec.fePrintMethod = 5)

        Filer.Execute;
        if not Cancelled then
        begin
          with Report.vrPrintMethodParams do
          begin
            if (pmPrintMethod = 4) then
            { Output to DBF file: already handled by ProcessForDBF }
            begin
              if PrinterInfo.feMiscOptions[Integer(DBF_AUTO_OPEN)] then
              begin
                ShellExecute(
                  0,                                    // Parent Window
                  'open',                               // Operation
                  PChar(pmXMLFileDir),                  // FileName
                  '',                                   // Params
                  PChar(ExtractFilePath(pmXMLFileDir)), // Default Dir
                  SW_SHOWNORMAL);                       // Show
              end;
            end
            else if (pmPrintMethod = 6) then
            begin
              { Output to CSV file }
              CSVOutput.SaveToFile(pmXMLFileDir);
              if PrinterInfo.feMiscOptions[Integer(CSV_AUTO_OPEN)] then
              begin
                ShellExecute(
                  0,                                    // Parent Window
                  'open',                               // Operation
                  PChar(pmXMLFileDir),                  // FileName
                  '',                                   // Params
                  PChar(ExtractFilePath(pmXMLFileDir)), // Default Dir
                  SW_SHOWNORMAL);                       // Show
              end;
            end
            else if (pmPrintMethod in [2, 3, 5, 7]) then
            begin
              ReportFileName := Filer.FileName;

              //PR 12/08/2016 2016-R1 ABSEXCH-10720: Save the report to .xlsx and tidy up
              If (pmPrintMethod = 5) and PrintingToExcel Then
              Begin
                ResetXLSXColumnWidths;
                ExportToExcel.SaveToFile (pmXMLFileDir);     // Destination Filename for .xlsx file

                // Destroy the Export To Excel sub-object
                FreeAndNIL(ExportToExcel);

                //PR: 31/08/2016 ABSEXCH-12521 Auto-open the file if required
                if PrinterInfo.feMiscOptions[Integer(XLS_AUTO_OPEN)] then
                begin
                  ShellExecute(
                    0,                                    // Parent Window
                    'open',                               // Operation
                    PChar(pmXMLFileDir),                  // FileName
                    '',                                   // Params
                    PChar(ExtractFilePath(pmXMLFileDir)), // Default Dir
                    SW_SHOWNORMAL);                       // Show
                end;

              End // If PrintingToExcel
              else
                PrintFileTo(PrinterInfo, ReportFileName, 'Preview', ExternalCall, nil);

              FReportFileName := ReportFileName;

            end
            else
            begin
              { Output to printer or print preview }
              ReportFileName := Filer.FileName;
              PrintFileTo(PrinterInfo, ReportFileName, 'Preview', ExternalCall, nil);
            end;
          end;
        end;
      end;
    finally
      FReport := nil;
      if (not PrinterInfo.Preview) and (Application.MainForm <> nil) then
        SendMessage(Application.MainForm.Handle, WM_PreviewClosed, 0, 0);
    end;
  except
    on E:Exception do
    begin
      FError := 'VRW Report Generator: Failed to print report:' + #13#10#13#10 +
                E.Message;
      Result := False;
    end;
  end;
end;

procedure TVRWReportGenerator.PrintControl(Control: IVRWControl;
  Layout: TVRWControlLayout);
var
  X1, X2, Y1, Y2: Double;
  Bmp: TBitmap;
  BmpRect: TRect;
  XLSXPos : Integer;
  IsFloatingPoint : Boolean;
  Col : Integer;
  DataType : TXLSXDataType;
begin
  { Line }
   if Supports(Control, IVRWLineControl) then
  begin
  If not PrintingToExcel Then
    with Control as IVRWLineControl do
    begin
      Filer.SetPen(vcPenColor, TPenStyle(vcPenStyle), -(vcPenWidth), pmCopy);
      Filer.MoveTo(Layout.X, Layout.Y);
      if vcLineOrientation = loVertical then
        Filer.LineTo(Layout.X, Layout.Y + Layout.H - 1)
      else
        Filer.LineTo(Layout.X + Layout.W - 1, Layout.Y);
    end;
  end
  { Box }
  else if Supports(Control, IVRWBoxControl) then
  begin
  If not PrintingToExcel Then
    with Control as IVRWBoxControl do
    begin
      X1 := Layout.X;
      X2 := Layout.X + Layout.W - 1;
      Y1 := Layout.Y;
      Y2 := Layout.Y + Layout.H - 1;
      if vcFilled then
      begin
        Filer.SetBrush(vcFillColor, bsSolid, nil);
        Filer.FillRect(Filer.CreateRect(X1, Y1, X2, Y2));
      end;
      with vcBoxLines[biTop] do
      begin
        Filer.SetPen(vcLineColor, vcLineStyle, -vcLineWidth, pmCopy);
        Filer.MoveTo(X1, Y1);
        if (vcLineStyle <> psClear) then
          Filer.LineTo(X2, Y1);
      end;
      with vcBoxLines[biLeft] do
      begin
        Filer.SetPen(vcLineColor, vcLineStyle, -vcLineWidth, pmCopy);
        Filer.MoveTo(X1, Y1);
        if (vcLineStyle <> psClear) then
          Filer.LineTo(X1, Y2);
      end;
      with vcBoxLines[biBottom] do
      begin
        Filer.SetPen(vcLineColor, vcLineStyle, -vcLineWidth, pmCopy);
        Filer.MoveTo(X1, Y2);
        if (vcLineStyle <> psClear) then
          Filer.LineTo(X2, Y2);
      end;
      with vcBoxLines[biRight] do
      begin
        Filer.SetPen(vcLineColor, vcLineStyle, -vcLineWidth, pmCopy);
        Filer.MoveTo(X2, Y1);
        if (vcLineStyle <> psClear) then
          Filer.LineTo(X2, Y2);
      end;
    end;
  end
  { Image }
  else if Supports(Control, IVRWImageControl) then
  begin
  If not PrintingToExcel Then
    with Control as IVRWImageControl do
    begin
      Bmp := TBitmap.Create;
      try
        Bmp.Width  := Trunc(vcImage.Width *  (Layout.W / Control.vcWidth));
        Bmp.Height := Trunc(vcImage.Height * (Layout.H / Control.vcHeight));
        BmpRect    := Filer.CreateRect(0, 0, Bmp.Width, Bmp.Height);
        Bmp.Canvas.CopyRect(BmpRect, vcImage.Canvas, BmpRect);
        if (vcBMPIndex = 0) then
        begin
          if BitmapIndex < 10 then
          begin
            BitmapIndex := BitmapIndex + 1;
            vcBMPIndex := BitmapIndex;
          end;
        end;
        if (vcBMPIndex > 0) then
          Filer.ReuseGraphic(vcBMPIndex);

        Filer.PrintBitmapRect(
          Layout.X,
          Layout.Y,
          Layout.X + Layout.W,
          Layout.Y + Layout.H,
          Bmp
        );

        if (vcBMPIndex > 0) then
          Filer.RegisterGraphic(vcBMPIndex);
      finally
        Bmp.Free;
      end;
    end;
  end
  else
  { All other control types }
  begin
    Filer.FontName  := Control.vcFont.Name;
    Filer.FontSize  := Control.vcFont.Size;
    Filer.FontColor := Control.vcFont.Color;
    Filer.Bold := (fsBold in Control.vcFont.Style);
    Filer.Italic := (fsItalic in Control.vcFont.Style);
    Filer.Underline := (fsUnderline in Control.vcFont.Style);
    Filer.Strikeout := (fsStrikeout in Control.vcFont.Style);

    If PrintingToExcel Then
    begin
       //Replace currentpage indicator
       ProcessXLSXMacros(Layout.Text);

       //Find print position according to justification
       if Layout.Justify = pjRight then
         XLSXPos := Control.vcLeft + Control.vcWidth - 2
       else
       if Layout.Justify = pjCenter then
         XLSXPos := Round(Control.vcLeft + (Control.vcWidth / 2) - 1)
       else
         XLSXPos := Control.vcLeft;

       //Try to work out if it's a floating point number
       DataType := dtString;
       if Supports(Control, IVRWFieldControl) then
       with Control as IVRWFieldControl do
       begin
         if vcVarType in [2, 3] then
           DataType := dtFloat
         else
         if vcVarType in [6..8] then
           DataType := dtInteger;
       end
       else
       if Supports(Control, IVRWFormulaControl) then
       with Control as IVRWFormulaControl do
       begin
         if (Length(vcFormulaDefinition) <> 0) and (vcFormulaDefinition[1] <> '"') then
           DataType := dtFloat;
       end;

       //Leave percentage fields as strings as
       if DataType in [dtFloat, dtInteger] then
         if Pos('%', Layout.Text) > 0 then
           DataType := dtString;

       //Find column number from position
       Col := ExportToExcel.PosToColumnNumber(XLSXPos);

       // Send the text out to Excel
       ExportToExcel.PrintCell (Col, Layout.Text, Filer.FontName, Filer.FontSize, Filer.Bold, Filer.Italic, Filer.UnderLine, Layout.Justify, DataType);
    end //Printing to Excel
    else
    begin
      ExtTextRect2(Layout.Text, Layout.Justify, Layout.X, Layout.Y,
        Layout.W, Layout.H, False);

      if Assigned(Layout.DrillDownInfo) then
        Filer.DrillDownArea(
          Layout.X,
          Layout.Y,
          Layout.X + Layout.W - 1,
          Layout.Y + Layout.H - 1,
          Layout.DrillDownInfo.LevelNo,
          Layout.DrillDownInfo.KeyString,
          Layout.DrillDownInfo.FileNo,
          Layout.DrillDownInfo.IndexNo,
          Layout.DrillDownInfo.Mode
        );
    end;
  end;
end;

function TVRWReportGenerator.PrintingToExcel: Boolean;
begin
  Result := (Report.vrPrintMethodParams.pmPrintMethod = 5) and Assigned(ExportToExcel);
end;

procedure TVRWReportGenerator.PrintNewPage;
begin
  PrintPageFooter;
  Filer.NewPage;
  PrintPageHeader;
  NewPageRequired := False;
end;

procedure TVRWReportGenerator.PrintPageFooter;
var
  Region: IVRWRegion;
begin
  Region := Report.vrRegions['Page Footer'];
  if (Region <> nil) and (Region.rgControls.clCount > 0) and
     (Region.rgVisible) then
  begin
    Filer.YPos := ((Filer.PageHeight - Filer.BottomWaste) - Region.rgHeight) + 1;
    PrintRegion(Region);
  end;
end;

procedure TVRWReportGenerator.PrintPageHeader;
begin
  PrintRegion(Report.vrRegions['Page Header']);
  Inc(FCurrentPage);
end;

procedure TVRWReportGenerator.PrintRegion(Region: IVRWRegion);
var
  Control: IVRWControl;
  ControlNo: Integer;
  ControlCount: Integer;
  Field: TRWFieldObject;
  YStart: Double;
  Layout: TVRWControlLayout;
  FormatStr: string;
begin
  if Region = nil then
    Exit;

  If PrintingToExcel Then
  begin
    //For Excel we need to print in display order, so divert the call to the xlsx printing procedure
    PrintRegionToXLSX(Region);
    Exit;
  end;

{$IFDEF DEBUGON}
  Dbug.Msg(1, 'Start of Print Region: ' + Region.rgName);
{$ENDIF}
  YStart := Filer.YPos;
  ControlCount := 0;

  SectionNumber := Region.rgSectionNumber;
  if (Region.rgType = rtRepHdr) or
     (Region.rgType = rtRepFtr) or
     (Region.rgType = rtPageHdr) or
     (Region.rgType = rtPageFtr) then
    SectionNumber := 0;

  PrintingRegion := True;

  { For each control in the specified region: }
  for ControlNo := 0 to Region.rgControlCount - 1 do
  begin
    Layout.Print := False;
    Layout.DrillDownInfo := nil;
    Control := Region.rgControls.clItems[ControlNo];
    Control.vcText := Control.vcCaption;
    if (not Control.vcDeleted) and Control.vcVisible then
    begin
      ProcessControl(Control, Region, YStart, Layout);
    end; // if not Control.vcDeleted...
    if Layout.Print and RegionIsPrintable(Region) then
    begin
      PrintControl(Control, Layout);
      ControlCount := ControlCount + 1;
    end;
  end;
  if ControlCount > 0 then
  begin
    Filer.GotoXY(0, YStart + Region.rgHeight);
  end;
  PrintingRegion := False;
{$IFDEF DEBUGON}
  Dbug.Msg(1, 'End of Print Region: ' + Region.rgName);
{$ENDIF}
end;

procedure TVRWReportGenerator.PrintRegionToXLSX(const Region: IVRWRegion);
var
  Control: IVRWControl;
  ControlNo: Integer;
  ControlCount: Integer;
  Field: TRWFieldObject;
  YStart: Double;
  Layout: TVRWControlLayout;
  FormatStr: string;
  LastY : Integer;
  i : integer;
begin
  if Region = nil then
    Exit;

{$IFDEF DEBUGON}
  Dbug.Msg(1, 'Start of Print Region: ' + Region.rgName);
{$ENDIF}
  YStart := Filer.YPos;
  ControlCount := 0;
  LastY := 0;
  SectionNumber := Region.rgSectionNumber;
  if (Region.rgType = rtRepHdr) or
     (Region.rgType = rtRepFtr) or
     (Region.rgType = rtPageHdr) or
     (Region.rgType = rtPageFtr) then
    SectionNumber := 0;

  PrintingRegion := True;
  SortReportControlsForXLSX(FXLSXRegionControls, Region, True);
  { For each control in the specified region: }
  for ControlNo := 0 to FXLSXRegionControls.Count - 1 do
  begin
    Layout.Print := False;
    Layout.DrillDownInfo := nil;
    Control := TVRWControlWrapper(FXLSXRegionControls.Objects[ControlNo]).Control;
    Control.vcText := Control.vcCaption;
    if (not Control.vcDeleted) and Control.vcVisible then
    begin
      ProcessControl(Control, Region, YStart, Layout);
    end; // if not Control.vcDeleted...
    if Layout.Print and RegionIsPrintable(Region) then
    begin
      if not SameRow(Round(Control.vcTop), LastY) then
      begin
        ExportToExcel.EndLine;
        LastY := Round(Control.vcTop);
      end;
      PrintControl(Control, Layout);
      ControlCount := ControlCount + 1;
    end;
  end;
  if ControlCount > 0 then
  begin
    Filer.GotoXY(0, YStart + Region.rgHeight);
    If PrintingToExcel Then
      // Tell the XLSX conversion thingie to move to the next row
      ExportToExcel.EndLine;
  end;
  PrintingRegion := False;
{$IFDEF DEBUGON}
  Dbug.Msg(1, 'End of Print Region: ' + Region.rgName);
{$ENDIF}
end;

procedure TVRWReportGenerator.PrintReportFooter;
begin
  PrintRegion(Report.vrRegions['Report Footer']);
end;

procedure TVRWReportGenerator.PrintReportHeader;
begin
  PrintRegion(Report.vrRegions['Report Header']);
  PrintPageHeader;
  SectionHeadersRequired := True;
end;

procedure TVRWReportGenerator.PrintSectionFooters;
var
  Region: IVRWRegion;
  RegionNo, HighestSection: Integer;
  RegionName: ShortString;
  AtEnd: Boolean;
  ForceNewPage: Boolean;
begin
  ForceNewPage := NewPageRequired;
  NewPageRequired := False;

  HighestSection := 0;
  for RegionNo := 0 to Report.vrRegions.rlCount - 1 do
  begin
    Region := Report.vrRegions.rlItems[RegionNo];
    if (Region.rgType = rtSectionHdr) and
       (Region.rgSectionNumber > HighestSection) then
      HighestSection := Region.rgSectionNumber;
  end;

  AtEnd := EndOfReport;
{$IFDEF DEBUGON}
  if AtEnd then Dbug.msg(1, 'End of report');
{$ENDIF}
{$IFDEF DEBUGON}
  Dbug.msg(1, 'Start of PrintSectionFooters');
{$ENDIF}
  { We can only detect that we have reached the end of a section when we
    have found the first record past the end of the section, so in order
    to print the correct details for the footer we need to move back to the
    last record of the section. We set the InFooter flag to tell the Totals
    calculator that it should accumulate the totals for section and report
    footers now. }
  Totals.InFooter := not AtEnd;
  GetPrevious;
  { If we are at the end of the report, we were actually already on the
    correct record (the last available record for printing), so we must check
    for this, and move back to the correct record.

    It might seem better to check for 'AtEnd' before doing the GetPrevious
    and avoid moving to another record at all, but in fact that does not work
    (the total fields for the last record do not get updated), so we have to
    do these seemingly unnecessary record moves. }
  if AtEnd then
  begin
    Totals.InFooter := False;
    GetNext;
  end;
  Totals.InFooter := True;

  for RegionNo := HighestSection downto FBreakingSection do
  begin
    RegionName := SECTION_FOOTER_NAME + IntToStr(RegionNo);
    Region := Report.vrRegions[RegionName];
    if (Region <> nil) then
    try

      { Print the section footer }
      CheckForPageBreak(Region);
      PrintRegion(Region);
      if NewPageRequired then
      begin
        PrintNewPage;
        ForceNewPage := False;
      end;

      { We've now printed the totals, so we can reset them ready for the next
        section. }
//      if not AtEnd then
        Totals.Reset(Region.rgSectionNumber);

    finally
      Region := nil;
    end;
  end;

  Totals.InFooter := False;

  if ForceNewPage then
    PrintNewPage;

  if (not AtEnd) then
  begin
    { Now we need to move back to the correct record. Note that as the totals
      have been reset we need to leave Totals enabled so that the values are
      updated. }
    GetNext;
  end;

  SectionFootersRequired := False;
{$IFDEF DEBUGON}
  Dbug.msg(1, 'End of PrintSectionFooters');
{$ENDIF}
end;

procedure TVRWReportGenerator.PrintSectionHeaders;
var
  Region: IVRWRegion;
  RegionNo, HighestSection: Integer;
  PageBreakRequired: Boolean;
  RegionName: ShortString;
begin
  HighestSection := 0;
  for RegionNo := 0 to Report.vrRegions.rlCount - 1 do
  begin
    Region := Report.vrRegions.rlItems[RegionNo];
    if (Region.rgType = rtSectionHdr) and
       (Region.rgSectionNumber > HighestSection) then
      HighestSection := Region.rgSectionNumber;
  end;

  for RegionNo := FBreakingSection to HighestSection do
  begin
    RegionName := SECTION_HEADER_NAME + IntToStr(RegionNo);
    Region := Report.vrRegions[RegionName];
    if Region <> nil then
    try
      { Print the header for the new section }
      CheckForPageBreak(Region);
      PrintRegion(Region);
    finally
      Region := nil;
    end;
  end;
  SectionHeadersRequired := False;
end;

procedure TVRWReportGenerator.Process(Sender: TObject);
var
  Region: IVRWRegion;
  OldCursor: TCursor;
  Abort: Boolean;
begin
  OldCursor := Screen.Cursor;
  ResetBitmapCache;
  Screen.Cursor := crHourGlass;
  try
    GetFirst;
    If PrintingToExcel Then
    begin
      // Tell the XLSX conversion thingie to move to the start of the row
       ExportToExcel.StartLine;
       FCurrentPage := 1;
       PrepareToPrintXLSX;
    end;

    PrintReportHeader;
    PrintSectionHeaders;
    Totals.ResetUpdatedFlag;
{$IFDEF DEBUGON}
  Dbug.msg(1, 'Start of main loop');
{$ENDIF}
    while (not EndOfReport) and (not Cancelled) do
    begin
      Region := Report.vrRegions[REPORT_LINE_NAME];
      CheckForPageBreak(Region);
      if SectionHeadersRequired then
        PrintSectionHeaders;
      PrintRegion(Region);
      GetNext;
{$IFDEF DEBUGON}
  Dbug.msg(2, 'Checking for section break');
{$ENDIF}
      CheckForSectionBreaks;
      if SectionFootersRequired then
      begin
        PrintSectionFooters;
      end;
      Totals.ResetUpdatedFlag;
      Region := nil;
    end;
{$IFDEF DEBUGON}
  Dbug.msg(1, 'End of main loop');
{$ENDIF}

    { Force the controls to be updated with the latest totals. }
    GetPrevious;
    GetNext;

    { Print the final sections. }
    CheckForPageBreak(Report.vrRegions['Report Footer']);
    PrintReportFooter;
    PrintPageFooter;
  finally
    if Assigned(FOnCheckRecord) then
    begin
      Abort := False;
      OnCheckRecord(0, RecordTotal, Abort);
    end;
    ResetBitmapCache;
    Screen.Cursor := OldCursor;
  end;
end;

procedure TVRWReportGenerator.ProcessForCSV(Sender: TObject);
var
  OldCursor: TCursor;
  Abort: Boolean;
begin
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    GetFirst;
    // CJS 2014-07-09 - ABSEXCH-15307 - CSV headers on export from VRW
    PrepareCSVReportControls;
    WriteCSVHeader;
    while (not EndOfReport) and (not Cancelled) do
    begin
      WriteCSVLine;
      GetNext;
    end;
  finally
    if Assigned(FOnCheckRecord) then
    begin
      Abort := False;
      OnCheckRecord(0, RecordTotal, Abort);
    end;
    Screen.Cursor := OldCursor;
  end;
end;

procedure TVRWReportGenerator.ProcessForDBF(Sender: TObject);
var
  Region: IVRWRegion;
  OldCursor: TCursor;
  Abort: Boolean;
begin
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  StartDBFOutput;
  try
    GetFirst;
    Region := Report.vrRegions[REPORT_LINE_NAME];
    WriteDBFHeader(Region);
    while (not EndOfReport) and (not Cancelled) do
    begin
      Region := Report.vrRegions[REPORT_LINE_NAME];
      WriteDBFLine(Region);
      GetNext;
      Region := nil;
    end;
  finally
    FinishDBFOutput;
    if Assigned(FOnCheckRecord) then
    begin
      Abort := False;
      OnCheckRecord(0, RecordTotal, Abort);
    end;
    Screen.Cursor := OldCursor;
  end;
end;

procedure TVRWReportGenerator.ProcessXLSXMacros(var Value: Shortstring);
begin
  //if output string contains #255 + 'P' then replace it with the current page number
  if Pos(#255'P', UpperCase(Value)) > 0 then
    Value := AnsiReplaceStr(Value, #255'P', IntToStr(FCurrentPage));
end;

function TVRWReportGenerator.RegionIsPrintable(Region: IVRWRegion): Boolean;
{ Returns True if the Region is visible and is to be included in the report
  (for export to Excel the Region might be visible, but not be included in
  the export). }
var
  Options: TOptionArray;
begin
  Result := Region.rgVisible;
  if Result and (Report.vrPrintMethodParams.pmPrintMethod = 5) then
  begin
    Options := Report.vrPrintMethodParams.pmMiscOptions;
    case Region.rgType of
      rtRepHdr:     Result := Options[Integer(XLS_SHOW_REPORT_HEADER)];
      rtPageHdr:    Result := Options[Integer(XLS_SHOW_PAGE_HEADER)];
      rtSectionHdr: Result := Options[Integer(XLS_SHOW_SECTION_HEADER)];
      rtRepLines:   Result := Options[Integer(XLS_SHOW_REPORT_LINES)];
      rtPageFtr:    Result := Options[Integer(XLS_SHOW_PAGE_FOOTER)];
      rtRepFtr:     Result := Options[Integer(XLS_SHOW_REPORT_FOOTER)];
    end;
  end;
end;

//Replace Rave macros with actual values
function TVRWReportGenerator.ReplaceMacro(
  const ValueName: string): ResultValueType;
begin
  if (Uppercase(ValueName) = 'DATE') then
  begin
    Result.StrResult := FormatDateTime('ddddd', Now); //Short date format
    Result.DblResult := 0.00;
  end
  else if (Uppercase(ValueName) = 'TIME') then
  begin
    Result.StrResult := FormatDateTime('t', Now); //Short time format
    Result.DblResult := 0.00;
  end
  else if (Uppercase(ValueName) = 'FIRSTPAGE') then
  begin
    Result.StrResult := '1';
    Result.DblResult := 0.00;
  end
  else if (Uppercase(ValueName) = 'LASTPAGE') then
  begin
    Result.StrResult := '';
    Result.DblResult := 0.00;
  end
  else if (Uppercase(ValueName) = 'CURRENTPAGE') then
  begin
    //Don't know the page number at this point, so replace Rave macro with simpler indicator for current page;
    //this can then be replaced on second pass
    Result.StrResult := #255'P';
    Result.DblResult := 0.00;
  end
  else if (Uppercase(ValueName) = 'TOTALPAGES') then
  begin
    Result.StrResult := '';
    Result.DblResult := 0.00;
  end
  else if (Uppercase(ValueName) = 'REPORTNAME') then
  begin
    Result.StrResult := FReport.vrName;
    Result.DblResult := 0.00;
  end
  else if (Uppercase(ValueName) = 'REPORTDESC') then
  begin
    Result.StrResult := FReport.vrDescription;
    Result.DblResult := 0.00;
  end;
end;

procedure TVRWReportGenerator.ResetBitmapCache;
var
  i: Integer;
begin
  for i := 1 to BitmapIndex do
    Filer.UnregisterGraphic(i);
  BitmapIndex := 0;
end;

//Set column widths for Excel. Controls are already in the FXLSXRegionControls
//list sorted into display order. The procedure sets the columns and widths for those controls
procedure TVRWReportGenerator.SetXLSXColumns;
Var
  I : Integer;
  Control: IVRWControl;
  NextControl : IVRWControl;

  LastX : Integer;
  s : string;
  w, x : Integer;
  ExtraColumnList : TStringList;
  Col : Integer;

Begin // SetXLSXColumns
  If PrintingToExcel Then
  Begin
            {$IFDEF DEBUGON}
             Dbug.msg(5, 'Count=' + IntToStr(FXLSXRegionControls.Count));
            {$ENDIF}
    Col := 0;
    //Iterate through list
    for I := 0 to FXLSXRegionControls.Count - 1 do
    begin
      Control := TVRWControlWrapper(FXLSXRegionControls.Objects[I]).Control;
            {$IFDEF DEBUGON}
             Dbug.msg(5, Format('Left=%d; Width=%d; Top=%d', [Control.vcLeft, Control.vcWidth, Control.vcTop]));
            {$ENDIF}

      if I = 0 then
        ExportToExcel.MarginLeft := Control.vcLeft - 2;

      if I < FXLSXRegionControls.Count - 1 then
      begin
        //Except for last control, set column width to difference between start of this control and start of next control

        //Get next control in list
        NextControl := TVRWControlWrapper(FXLSXRegionControls.Objects[I+1]).Control;


        //Need to subtract 2px from column width as the RepExcelExport adds 2px on

        //Check for overlapping columns
//        if NextControl.vcLeft > Control.vcLeft + Control.vcWidth then
          ExportToExcel.SetColumnWidth(Col, Round(NextControl.vcLeft - Control.vcLeft - 2), Justify(Control), False)
{        else
          ExportToExcel.SetColumnWidth(Col, Round(Control.vcWidth - 2), Justify, True);}
      end
      else
        ExportToExcel.SetColumnWidth(Col, Round(Control.vcWidth), Justify(Control), False);

      inc(Col);
    End; // For I

    //Set rightmost point and then check for any further controls
    if Assigned(Control) then
    begin
      LastX := Control.vcLeft + Control.vcWidth;
      ExtraColumnList := FindExtraColumns(LastX);

      //Are there any controls past the rightmost point?
      if Assigned(ExtraColumnList) then
      Try
        for i := 0 to ExtraColumnList.Count - 1 do
        begin
          s := ExtraColumnList[i];
          w := StrToInt(Copy(s, 9, 8)); //Get width of control

          if (i = 0) and (Col > 0) then
          begin
            //Get horizontal startpoint of first control
            x := StrToInt(Copy(s, 1, 8));

            //If there is a space between end of current rightmost control and left of this control then widen rightmost control
            if x > LastX + 1 then
              ExportToExcel.SetColumnWidth(Col-1, x - Control.vcLeft - 1, Justify(Control), True);
          end;

          //Set width for this control
          ExportToExcel.SetColumnWidth(Col, w, pjLeft, False);
          inc(Col);
        end;
      Finally
        //Free list
        ExtraColumnList.Free;
      End;
    end; //if assigned(Control)
  End; // If PrintingToExcel


end;

procedure TVRWReportGenerator.SetEndOfReport(const Value: Boolean);
begin
  FEndOfReport := Value;
end;

procedure TVRWReportGenerator.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

procedure TVRWReportGenerator.SetNewPageRequired(const Value: Boolean);
begin
  FNewPageRequired := Value;
end;

procedure TVRWReportGenerator.SetSectionFootersRequired(
  const Value: Boolean);
begin
  FSectionFootersRequired := Value;
end;

procedure TVRWReportGenerator.SetSectionHeadersRequired(
  const Value: Boolean);
begin
  FSectionHeadersRequired := Value;
end;

procedure TVRWReportGenerator.SetSectionNumber(const Value: SmallInt);
begin
  FSectionNumber := Value;
end;

// CJS 2014-07-09 - ABSEXCH-15307 - CSV headers on export from VRW
procedure TVRWReportGenerator.SortReportControls(List: TStringList);
{ Sorts the Report Line and Section Header controls into on-screen order, so
  that they can be exported to CSV in the correct order. }
var
  ControlNo: Integer;
  Control: IVRWControl;
  Region: IVRWRegion;
  SortString: string;
  SortPrefix: string;

  function RegionIsIncluded(RegionName: string): Boolean;
  begin
    Result := False;
    { Include Section Headers... }
    if (Copy(RegionName, 1, Length(SECTION_HEADER_NAME)) = SECTION_HEADER_NAME) then
      { ...but only if the user has requested them }
      Result := Report.vrPrintMethodParams.pmMiscOptions[Integer(CSV_SHOW_SECTION_HEADER)]
    else if (RegionName = REPORT_LINE_NAME) then
      { Always include the actual report lines }
      Result := True;
  end;

begin
  List.Clear;
  Region := nil;
  { For each control in the report: }
  for ControlNo := 0 to Report.vrControls.clCount - 1 do
  begin
    { Get the control }
    Control := Report.vrControls.clItems[ControlNo];

    { Check that it is in a region which should be printed }
    if RegionIsIncluded(Control.vcRegionName) then
    begin
      { Get the Region (if we don't already have it) }
      if (Region = nil) or (Region.rgName <> Control.vcRegionName) then
        Region := Report.vrRegions[Control.vcRegionName];

      { Assign a prefix so that section headers are sorted into the correct
        order }
      if (Copy(Control.vcRegionName, 1, Length(SECTION_HEADER_NAME)) = SECTION_HEADER_NAME) then
        SortPrefix := Char(Region.rgSectionNumber + Ord('A') - 1)
      else
        SortPrefix := 'X';

      { Add the control to the list, with a sort key based on the on-screen
        position }
      SortString := Format('%s%.8d%.8d', [SortPrefix, Control.vcTop, Control.vcLeft]);
      List.AddObject(SortString, TVRWControlWrapper.Create(Control));

    end; // if RegionIsIncluded...
    Control := nil;
  end;
  List.Sort;
end;

//Sorts the columns for a region into a list in display order. When sorting for setting xl column widths only include visible controls
procedure TVRWReportGenerator.SortReportControlsForXLSX(const List: TStringList; Region: IVRWRegion; IncludeHiddenControls : Boolean = False);
var
  ControlNo: Integer;
  Control: IVRWControl;
//  Region: IVRWRegion;
  SortString: string;
  SortPrefix: string;
  i : integer;

begin
  for i := 0 to List.Count - 1 do
  begin
    if Assigned(List.Objects[i]) then
      List.Objects[i].Free;
  end;
  List.Clear;
  { For each control in the report: }
  for ControlNo := 0 to Region.rgControlCount - 1 do
  begin
    { Get the control }
    Control := Region.rgControls.clItems[ControlNo];

    if IncludeHiddenControls or ValidXLSXControl(Control) then
    begin
      { Add the control to the list, with a sort key based on the on-screen
        position }
      SortString := Format('%.8d%.8d', [Control.vcTop, Control.vcLeft]);
      List.AddObject(SortString, TVRWControlWrapper.Create(Control));

    end; // if RegionIsIncluded...
    Control := nil;
  end;
  List.Sort;
end;

procedure TVRWReportGenerator.StartDBFOutput;
begin
  Coinitialize(nil); // required for CreateOLEObject to work in a thread (Sentimail).
  FDBFOutput := CreateOLEObject('EnterpriseDBF.DBFWriter') as IDBFWriter;
end;

function TVRWReportGenerator.TemporaryReportFileName: string;
//var
//  szPathName, szPrefix, szTempFileName : PChar;
begin
  // MH 12/03/2012 v6.10 ABSEXCH-11937: Stash reports locally in Windows\Temp folder rather
  // than uploading them to the network Exchequer\Swap folder

  (***
  Result := '';
  szPathName := StrAlloc(255);
  szPrefix := StrAlloc(255);
  szTempFileName := StrAlloc(MAX_PATH);
  try
    szPathName := StrPCopy(szPathName, SetDrive + 'SWAP\');
    ForceDirectories(szPathName);
    if not DirectoryExists(szPathName) then
    begin
      MessageDlg('Failed to create SWAP directory for temporary report files',
                 mtError,
                 [mbOk],
                 0);
      Abort;
    end;
    szPreFix := StrPCopy(szPreFix, 'ERW');
    if (GetTempFileName(szPathName, szPrefix, 0, szTempFileName) > 0) then
      Result := ChangeFileExt(StrPas(szTempFileName), '.EDF')
    else
      Result := SetDrive + 'SWAP\' + 'ERWRAVE.EDF';
  finally
    StrDispose(szPathName);
    StrDispose(szPrefix);
    StrDispose(szTempFileName);
  end; // try...finally
  ***)

  Result := GetWinTempPrintingFilename ('.EDF');
end;

procedure TVRWReportGenerator.UpdateTotals(const ControlName, FieldValue: string);

  function IsFooter(RegionName: string): Boolean;
  begin
    Result := (Copy(RegionName, 1, 14) = 'Section Footer') OR
              (RegionName = 'Report Footer');
  end;

var
  Control: IVRWControl;
  DBName: ShortString;
  ControlInFooter: Boolean;
  Field: TRWFieldObject;
  Value: Double;
begin
  if Totals.Enabled and PrintingRegion then
  begin
    DBName := '';
    Control := FReport.vrControls[ControlName];
    Value := StrippedStrToFloat(FieldValue);
    if (Value <> 0) then
    begin
      if Supports(Control, IVRWFieldControl) then
      begin

        ControlInFooter := IsFooter((Control as IVRWFieldControl).vcRegionName);
        if ControlInFooter and Totals.InFooter then
          DBName := (Control as IVRWFieldControl).vcFieldName
        else if (not ControlInFooter) and (not Totals.InFooter) then
          DBName := (Control as IVRWFieldControl).vcFieldName;

      end
      else if Supports(Control, IVRWFormulaControl) then
      begin

        ControlInFooter := IsFooter((Control as IVRWFormulaControl).vcRegionName);
        if ControlInFooter and Totals.InFooter then
          DBName := (Control as IVRWFormulaControl).vcFormulaName
        else if (not ControlInFooter) and (not Totals.InFooter) then
          DBName := (Control as IVRWFormulaControl).vcFormulaName;

      end;
      if (DBName <> '') then
        Totals.AddToTotal(DBName, StrippedStrToFloat(FieldValue));
    end;
  end;
end;

function TVRWReportGenerator.ValidXLSXControl(
  const Control: IVRWControl): Boolean;
begin
  Result := not Control.vcDeleted and
                Control.vcVisible and
                ((Supports(Control, IVRWFieldControl) and (Control as IVRWFieldControl).vcPrintField)
                  or
                  (Supports(Control, IVRWFormulaControl) and (Control as IVRWFormulaControl).vcPrintField )
                  or Supports(Control, IVRWTextControl));
end;

procedure TVRWReportGenerator.WriteCSVHeader;
var
  ControlNo: Integer;
  Control: IVRWControl;
  Field: TRWFieldObject;
  Line: string;
begin
  CSVOutput.Clear;
  Line := '';
  { For each control in the specified region: }
  for ControlNo := 0 to FCSVReportControls.Count - 1 do
  begin
    // CJS 2014-07-09 - ABSEXCH-15307 - CSV headers on export from VRW
    // Replaced local string-list with FCSVReportControls
    Control := TVRWControlWrapper(FCSVReportControls.Objects[ControlNo]).Control;
    { For database controls... }
    if Supports(Control, IVRWFieldControl) then
    begin
      if (Control as IVRWFieldControl).vcPrintField and
         not (Control as IVRWFieldControl).vcDeleted then
      begin
        { ...locate the matching field entry in the Report Data Engine }
        {
          CJS 24/01/2011 - ABSEXCH-3020 - Amended the retrieval of the
          database field value
        }
//          Field := GetField((Control as IVRWFieldControl).vcFieldName);
        Field := GetEngineControl(Control.vcName);
        if (Field <> nil) and (Field.Print) then
        begin
          { Add the field name to the header line }
          if (Line <> '') then
            Line := Line + ',';
          Line := Line + '"' + (Control as IVRWFieldControl).vcFieldName + '"';
        end;
      end;
    end
    { For formula controls... }
    else if Supports(Control, IVRWFormulaControl) then
    begin

      if (Control as IVRWFormulaControl).vcPrintField and
         not (Control as IVRWFormulaControl).vcDeleted then
      begin
        { ...add the formula name to the header line }
        if (Line <> '') then
          Line := Line + ',';
        Line := Line + '"' + (Control as IVRWFormulaControl).vcFormulaName + '"';
      end;

    end;
    Control := nil;
  end;
  if (Line <> '') then
    CSVOutput.Add(Line);
end;

procedure TVRWReportGenerator.WriteCSVLine;
var
  ControlNo: Integer;
  Control: IVRWControl;
  StrFormat: string;
  Field: TRWFieldObject;
  Line: string;
begin
  Line := '';
  { For each control in the specified region: }
  for ControlNo := 0 to FCSVReportControls.Count - 1 do
  begin
    // CJS 2014-07-09 - ABSEXCH-15307 - CSV headers on export from VRW
    // Replaced local string-list with FCSVReportControls
    Control := TVRWControlWrapper(FCSVReportControls.Objects[ControlNo]).Control;
    { For database controls... }
    if Supports(Control, IVRWFieldControl) then
    begin
      if (Control as IVRWFieldControl).vcPrintField and
         not (Control as IVRWFieldControl).vcDeleted then
      begin
        { ...locate the matching field entry in the Report Data Engine }
        {
          CJS 24/01/2011 - ABSEXCH-3020 - Amended the retrieval of the
          database field value
        }
//          Field := GetField((Control as IVRWFieldControl).vcFieldName);
        Field := GetEngineControl(Control.vcName);
        if (Field <> nil) and (Field.Print) then
        begin
          { Build a format string for floating-point numbers. }
          StrFormat := '0.' + StringOfChar('0', Field.DecPlaces);
          { Append the field value to the CSV line }
          if (Line <> '') then
            Line := Line + ',';
          if ControlHoldsFloat(Control as IVRWFieldControl) then
            Line := Line + FormatFloat(StrFormat, StrippedStrToFloat(Field.Value))
          else if ControlHoldsInteger(Control as IVRWFieldControl) then
            Line := Line + FormatFloat('0', StrippedStrToFloat(Field.Value))
          else
            Line := Line + '"' + StringReplace(Field.Value, '"', '''''', [rfReplaceAll]) + '"';
        end;
      end;
    end
    { For formula controls... }
    else if Supports(Control, IVRWFormulaControl) then
    begin

      if (Control as IVRWFormulaControl).vcPrintField then
      begin
        { ...locate the matching field entry in the Report Data Engine }
        Field := GetEngineControl(Control.vcName);
        if (Field <> nil) and (Field.Print) then
        begin
          Control.vcText := Field.Value;
          if ((Control as IVRWFormulaControl).vcFormulaDefinition[1] <> '"') then
          begin
            with Control as IVRWFormulaControl do
            begin
              StrFormat := '#0.' + StringOfChar('0', vcDecimalPlaces);

              vcText := FormatFloat(StrFormat, StrippedStrToFloat(Field.Value));
              { Check for 'blank on zero' }
              if (Pos('B', vcFieldFormat) <> 0) and
                 (StrippedStrToFloat(Field.Value) = 0) then
                vcText := ''
              else
                vcText := RightNegative(vcText);
            end;
          end;

          { Append the field value to the CSV line }
          if (Line <> '') then
            Line := Line + ',';
          if IsNumeric(Control.vcText) then
            Line := Line + FormatFloat(StrFormat, StrippedStrToFloat(Control.vcText))
          else
            Line := Line + '"' + Control.vcText + '"';
        end;

      end;

    end;
    Control := nil;
  end;
  if (Line <> '') then
    CSVOutput.Add(Line);
end;

procedure TVRWReportGenerator.WriteDBFHeader(Region: IVRWRegion);

  function DBFFieldIsUnique(FieldName: string): Boolean;
  var
    Entry: Integer;
    FieldEntry: string;
  begin
    FieldEntry := FieldName + ';';
    Result := True;
    for Entry := 0 to DBFFieldList.Count - 1 do
    begin
      if Copy(DBFFieldList[Entry], 1, Length(FieldEntry)) = FieldEntry then
      begin
        Result := False;
        Break;
      end;
    end;
  end;

  function CreateUniqueFieldname(FromFieldName: string): string;
  var
    CharPos: Integer;
  const
    IncrementChars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  begin
    Result := FromFieldName;
    CharPos := 0;
    while not DBFFieldIsUnique(Result) do
    begin
      Inc(CharPos);
      if (CharPos < Length(IncrementChars)) then
        Result := FromFieldName + '_' + IncrementChars[CharPos]
      else
        raise Exception.Create('Too many instances of field ' + FromFieldName +
                               ' in report');
    end;
  end;

  function FindFieldInHeader(FieldName: string; var SectionNumber: Integer): IVRWFieldControl;
  var
    Region: IVRWRegion;
    RegionNo, ControlNo: Integer;
  begin
    Result := nil;
    for RegionNo := 0 to Report.vrRegions.rlCount - 1 do
    begin
      Region := Report.vrRegions.rlItems[RegionNo];
      if (Region.rgName <> REPORT_LINE_NAME) then
      begin
        for ControlNo := 0 to Region.rgControlCount - 1 do
        begin
          if Supports(Region.rgControls.clItems[ControlNo], IVRWFieldControl) then
          begin
            Result := Region.rgControls.clItems[ControlNo] as IVRWFieldControl;
            if Result.vcFieldName = FieldName then
            begin
              SectionNumber := Region.rgSectionNumber;
              Break;
            end;
            Result := nil;
          end;
        end;
      end;
      if (Result <> nil) then
        Break;
    end;
  end;

  function FindFormulaInHeader(FormulaName: string; var SectionNumber: Integer): IVRWFormulaControl;
  var
    Region: IVRWRegion;
    RegionNo, ControlNo: Integer;
  begin
    Result := nil;
    for RegionNo := 0 to Report.vrRegions.rlCount - 1 do
    begin
      Region := Report.vrRegions.rlItems[RegionNo];
      if (Region.rgName <> REPORT_LINE_NAME) then
      begin
        for ControlNo := 0 to Region.rgControlCount - 1 do
        begin
          if Supports(Region.rgControls.clItems[ControlNo], IVRWFormulaControl) then
          begin
            Result := Region.rgControls.clItems[ControlNo] as IVRWFormulaControl;
            if Result.vcFormulaName = FormulaName then
            begin
              SectionNumber := Region.rgSectionNumber;
              Break;
            end;
            Result := nil;
          end;
        end;
      end;
      if (Result <> nil) then
        Break;
    end;
  end;

var
  ControlNo: Integer;
  Control: IVRWControl;
  DBControl: IVRWFieldControl;
  FmlControl: IVRWFormulaControl;
  DBFieldDef, FieldName, UniqueFieldName: string;
  Field: TRWFieldObject;
  wsDefStr: WideString;
  SortIndex: Integer;
  Res: SmallInt;
  HeaderDBControl: IVRWFieldControl;
  HeaderFmlControl: IVRWFormulaControl;
  SectionNumber: Integer;
begin
  CreateDBFLists;

  DbfList.Clear;
  NameList.Clear;
  DbfFieldList.Clear;

  for ControlNo := 0 to Report.vrControls.clCount - 1 do
  begin
    Control := Report.vrControls.clItems[ControlNo];
    if (Control.vcRegionName <> 'Report Header') and
       (Control.vcRegionName <> 'Page Header') and
       (Copy(Control.vcRegionName, 1, 14) <> 'Section Footer') and
       (Control.vcRegionName <> 'Page Footer') and
       (Control.vcRegionName <> 'Report Footer') then
    begin
      { Field controls }
      if Supports(Control, IVRWFieldControl) then
      begin
        DBControl := Control as IVRWFieldControl;
        if DBControl.vcPrintField and
           not DBControl.vcDeleted then
        begin
          FieldName := Uppercase(Trim(DBControl.vcFieldName));
          UniqueFieldName := CreateUniqueFieldName(FieldName);
          {
            CJS 24/01/2011 - ABSEXCH-3020 - Amended the retrieval of the
            database field value
          }
//          Field := GetField(FieldName);
          Field := GetEngineControl(DBControl.vcName);
          if (Field <> nil) and (Field.Print) then
          begin
            DBFieldDef := UniqueFieldName + ';';
            case DBControl.vcVarType of
              1,5,10  : DBFieldDef := DBFieldDef + 'C;'; // string
              2,3     : DBFieldDef := DBFieldDef + 'F;'; // float
              4,12    : DBFieldDef := DBFieldDef + 'D;'; // date
              6,7,8,9 : DBFieldDef := DBFieldDef + 'N;'; // number
              11      : DBFieldDef := DBFieldDef + 'L;'; // logical
            else
              DBFieldDef := DBFieldDef + 'C;'; // string - default, better than nothing.
            end;

            if (DBControl.vcVarType in [2, 3]) then
              DBFieldDef := DBFieldDef +
                            IntToStr(DBControl.vcVarLen) + ';' +
                            IntToStr(DBControl.vcVarNoDecs)
            else
              DBFieldDef := DBFieldDef +
                            IntToStr(DBControl.vcVarLen) + ';' +
                            '0';

            SortIndex := 0;
            if (Region.rgName = REPORT_LINE_NAME) then
            begin
              { Search the section headers for a control matching the fieldname }
              HeaderDBControl := FindFieldInHeader(DBControl.vcFieldName, SectionNumber);

              { If found, use the sort order from the control }
              if (HeaderDBControl <> nil) then
              begin
                if (Pos('A', HeaderDBControl.vcSortOrder) > 0) then
                  SortIndex := 1
                else if (Pos('D', HeaderDBControl.vcSortOrder) > 0) then
                  SortIndex := 2
                else
                  SortIndex := 0;
              end;

            end;

            if (SortIndex = 0) then
            begin
              if (Pos('A', DBControl.vcSortOrder) > 0) then
                SortIndex := 1
              else if (Pos('D', DBControl.vcSortOrder) > 0) then
                SortIndex := 2
              else
                SortIndex := 0;
            end;

            NameList.Add(DBFieldDef);
            DbfFieldList.AddObject(DBFieldDef, TObject(SortIndex));
          end; // if (Field <> nil...
        end; // if DBControl.vcPrintField...
        DBControl := nil;
      end // if Supports(Control...
      { Formula controls }
      else if Supports(Control, IVRWFormulaControl) then
      begin
        FmlControl := Control as IVRWFormulaControl;

        if FmlControl.vcPrintField and
           not FmlControl.vcDeleted then
        begin
          FieldName := Uppercase(Trim(FmlControl.vcFormulaName));
          UniqueFieldName := CreateUniqueFieldName(FieldName);
          if Copy(FmlControl.vcFormulaDefinition, 1, 1) = '"' then
            { String formula }
            DBFieldDef := UniqueFieldName + ';C;255;0'
          else
            { Numeric formula }
            DBFieldDef := UniqueFieldName + ';F;' +
                          IntToStr(10 + FmlControl.vcDecimalPlaces) + ';' +
                          IntToStr(FmlControl.vcDecimalPlaces);

          SortIndex := 0;
          if (Region.rgName = REPORT_LINE_NAME) then
          begin
            { Search the section headers for a control matching the formula }
            HeaderFmlControl := FindFormulaInHeader(FmlControl.vcFormulaName, SectionNumber);

            { If found, use the sort order from the control }
            if (HeaderFmlControl <> nil) then
            begin
              if (Pos('A', HeaderFmlControl.vcSortOrder) > 0) then
                SortIndex := 1
              else if (Pos('D', HeaderFmlControl.vcSortOrder) > 0) then
                SortIndex := 2
              else
                SortIndex := 0;
            end;

          end;

          if (SortIndex = 0) then
          begin
            if (Pos('A', FmlControl.vcSortOrder) > 0) then
              SortIndex := 1
            else if (Pos('D', FmlControl.vcSortOrder) > 0) then
              SortIndex := 2
            else
              SortIndex := 0;
          end;

          NameList.Add(DBFieldDef);
          DbfFieldList.AddObject(DBFieldDef, TObject(SortIndex));
        end; // if FmlControl.vcPrintField...

        FmlControl := nil;
      end;  // else if Supports(Control...
    end; // if (Control.vcRegionName...
    Control := nil;
  end; // for ControlNo...

  if (Trim(Report.vrPrintMethodParams.pmXMLFileDir) <> '') then
    DBFOutput.Filename := Report.vrPrintMethodParams.pmXMLFileDir
  else
    DBFOutput.Filename := ExtractFilePath(ReportConstructInfo.ssReportTempRaveName) + 'REPORT.DBF';

  wsDefStr := DbfFieldList.CommaText;
  try
    Res := DBFOutput.CreateFile(wsDefStr);
  except
    on E:Exception do
      raise Exception.Create('Failed to create DBF file, error ' + E.Message);
  end;
  if (Res <> 0) then
    raise Exception.Create('Failed to create DBF file, error ' + IntToStr(Res));
end;

procedure TVRWReportGenerator.WriteDBFLine(Region: IVRWRegion);
var
  FieldNo: Integer;
  Field: TRWFieldObject;
  ControlNo: Integer;
  Control: IVRWControl;
  DBControl: IVRWFieldControl;
  FmlControl: IVRWFormulaControl;
  StrFormat: string;
  DateStr: string;
begin
  DBFOutput.AddRec;
  { Clear the global field-values list (see DBFUtil.pas) }
  DBFList.Clear;
  for ControlNo := 0 to Report.vrControls.clCount - 1 do
  begin
    Control := Report.vrControls.clItems[ControlNo];
    if (Control.vcRegionName <> 'Report Header') and
       (Control.vcRegionName <> 'Page Header') and
       (Copy(Control.vcRegionName, 1, 14) <> 'Section Footer') and
       (Control.vcRegionName <> 'Page Footer') and
       (Control.vcRegionName <> 'Report Footer') then
    begin
      { Field controls }
      if Supports(Control, IVRWFieldControl) then
      begin
        DBControl := Control as IVRWFieldControl;
        if DBControl.vcPrintField and
           not DBControl.vcDeleted then
        begin
          {
            CJS 24/01/2011 - ABSEXCH-3020 - Amended the retrieval of the
            database field value
          }
//          Field := GetField(DBControl.vcFieldName);
          Field := GetEngineControl(DBControl.vcName);
          if (Field <> nil) and (Field.Print) then
          begin
            { Build a format string for floating-point numbers. }
            StrFormat := '0.' + StringOfChar('0', Field.DecPlaces);
            if ControlHoldsFloat(Control as IVRWFieldControl) then
              DBFList.Add(FormatFloat(StrFormat, StrippedStrToFloat(Field.Value)))
            else if ControlHoldsInteger(Control as IVRWFieldControl) then
              DBFList.Add(FormatFloat('0', StrippedStrToFloat(Field.Value)))
            else if ControlHoldsDate(Control as IVRWFieldControl) then
            begin
              if (StrToDateDef(Field.Value, 0) = 0) then
                DateStr := ''
              else
                DateStr := FormatDateTime('yyyyddmm', StrToDateDef(Field.Value, 0));
              DBFList.Add(DateStr);
            end
            else
              DBFList.Add(Field.Value);
          end;
        end;
        DBControl := nil;
      end
      { Formula controls }
      else if Supports(Control, IVRWFormulaControl) then
      begin
        FmlControl := Control as IVRWFormulaControl;

        if FmlControl.vcPrintField and
           not FmlControl.vcDeleted then
        begin
          { ...locate the matching field entry in the Report Data Engine }
          Field := GetEngineControl(Control.vcName);
          if (Field <> nil) and (Field.Print) then
          begin
            Control.vcText := Field.Value;
            if ((Control as IVRWFormulaControl).vcFormulaDefinition[1] <> '"') then
            begin
              with Control as IVRWFormulaControl do
              begin
                StrFormat := '#,0.' + StringOfChar('0', vcDecimalPlaces);

                vcText := FormatFloat(StrFormat, StrippedStrToFloat(Field.Value));
                { Check for 'blank on zero' }
                if (Pos('B', vcFieldFormat) <> 0) and
                   (StrippedStrToFloat(Field.Value) = 0) then
                  vcText := ''
                else
                  vcText := RightNegative(vcText);
              end;
              if (StrippedStrToFloat(Field.Value) >= 0) then
                Control.vcText := Control.vcText + ' ';
              { Add the field value to the list of field values }
              if Copy(FmlControl.vcFormulaDefinition, 1, 1) = '"' then
                DBFList.Add(Control.vcText)
              else
                DBFList.Add(FormatFloat(StrFormat, StrippedStrToFloat(FmlControl.vcText)));
            end;
          end;
        end;
        FmlControl := nil;
      end;
    end; // if (Control.vcRegionName...
    Control := nil;
  end;
  { Write the values to the DBF record. This assumes that the fields in the
    DBF file are in the same order as the controls in the report -- this
    should always be the case (see WriteDBFHeader) }
  DBFOutput.AddRec;
  for FieldNo := 0 to DBFList.Count - 1 do
    DBFOutput.SetFieldValue(FieldNo + 1, DBFList[FieldNo]);
  DBFOutput.SaveRec;
end;


//Assume controls whose tops are less than XLSX_SAME_ROW_LIMIT pixels apart are meant to be in the same row
function TVRWReportGenerator.SameRow(Val1, Val2: Integer): Boolean;
begin
  Result := Abs(Val1 - Val2) < XLSX_SAME_ROW_LIMIT;
end;

procedure TVRWReportGenerator.FindControlsForXSLXColumns;
var
  RegionNo : Integer;
  Region: IVRWRegion;
  ControlNo : Integer;
  Control : IVRWControl;
  Pos : Integer;
  LastLeft, ThisLeft : Integer;
  LastWidth, ThisWidth : Integer;
  SortString : string;
  RowList : TStringList;
  RowCount : Integer;

  function RowsInRegion : Integer;
  var
    I : integer;
  begin

    I := 1;
    while I < RowList.Count do
    begin
      //Remove any lines that are in the same row as the previous line
      if SameRow(StrToInt(RowList[I]), StrToInt(RowList[I-1])) then
        RowList.Delete(I)
      else
        Inc(I);
    end;

    Result := RowList.Count;
  end;
begin
  RowList := TStringList.Create;
  RowList.Sorted := True;
  RowList.Duplicates := dupIgnore;

  FRowsInPage := 0;
  FRowsInSections := 0;

  //Iterate through regions and load all controls from visible regions into a list sorted on left and width
  for RegionNo := 0 to Report.vrRegions.rlCount - 1 do
  begin
    Region := Report.vrRegions.rlItems[RegionNo];
    RowList.Clear;
    //Limit regions to section headers and footers, and report lines - avoids using wide titles in report or page header
    for ControlNo := 0 to Region.rgControls.clCount - 1 do
    begin
      Control := Region.rgControls.clItems[ControlNo];
      if ValidXLSXControl(Control) then
      begin
        if RegionIsPrintable(Region) then
        begin
          RowList.Add(Format('%.8d', [Control.vcTop]));

          if (Region.rgType in [rtSectionHdr, rtRepLines, rtSectionFtr]) then
          begin
            {$IFDEF DEBUGON}
             Dbug.msg(5, Format('%s Left=%d; Width=%d; Top=%d', [Region.rgName, Control.vcLeft, Control.vcWidth, Control.vcTop]));
            {$ENDIF}
            SortString := Format('%.8d%.8d', [Control.vcLeft, Control.vcWidth]);
            FXLSXRegionControls.AddObject(SortString, TVRWControlWrapper.Create(Control));
          end; //if (Region.rgType in [rtSectionHdr, rtRepLines, rtSectionFtr])
        end; //if RegionIsPrintable(Region)
      end;
    end;

    if RegionIsPrintable(Region) then
    begin
      Case Region.rgType of
        rtPageHdr,
        rtPageFtr : FRowsInPage := FRowsInPage + RowsInRegion;
        rtRepLines : FRowsInLine := RowsInRegion;
        rtSectionHdr,
        rtSectionFtr : FRowsInSections := FRowsInSections + RowsInRegion;
      end; //case
    end;
  end; //for regionno
  FXLSXRegionControls.Sort;

  RowList.Free;

  //Keep first control then iterate through rest of list
  LastLeft := StrToInt(Copy(FXLSXRegionControls[0], 1, 8));
  LastWidth := StrToInt(Copy(FXLSXRegionControls[0], 9, 8));
  Pos := 1;

  //Iterate through list and leave just one line of any given left position
  while (Pos < FXLSXRegionControls.Count) do
  begin
    ThisLeft := StrToInt(Copy(FXLSXRegionControls[Pos], 1, 8));
    ThisWidth := StrToInt(Copy(FXLSXRegionControls[Pos], 9, 8));

    if SameColumn(ThisLeft, LastLeft) then
    begin
      //We already have a column with this left so delete it. If this is the last control in the list then
      //delete the previous control so we keep the largest width to make the last column wide enough. (The widths of all other
      //columns are set using the distance to the start of the next control.)
      if (Pos = FXLSXRegionControls.Count - 1) then
      begin
        FXLSXRegionControls.Delete(Pos-1);
      end
      else
        FXLSXRegionControls.Delete(Pos);
    end
{    else
    if (ThisLeft + ThisWidth) <= (LastLeft + LastWidth) then
    begin
      //Control is completely contained in the previous column so remove it
      FXLSXRegionControls.Delete(Pos);
    end}
    else
    begin
      //Keep this control and move to next
      LastLeft := ThisLeft;
      LastWidth := ThisWidth;
      inc(Pos);
    end;
  end;
end;

//Assume controls whose lefts are less than XLSX_SAME_ROW_LIMIT pixels apart are meant to be in the same column
function TVRWReportGenerator.SameColumn(Val1, Val2: Integer): Boolean;
begin
  Result := Abs(Val1 - Val2) < XLSX_SAME_COLUMN_LIMIT;
end;

procedure TVRWReportGenerator.ProcessControl(
  const Control: IVRWControl; const Region: IVRWRegion; YStart : Double; var Layout : TVRWControlLayout);
var
  Field: TRWFieldObject;
  FormatStr: string;
begin
  { For database controls... }
  if Supports(Control, IVRWFieldControl) then
  begin
    { ...locate the matching field entry in the Report Data Engine }
    Field := GetEngineControl(Control.vcName);
    { If Field.Print is False, the field is neither printed nor
      included in totals. }
    if (Field <> nil) and (Field.Print) then
    begin
      Control.vcText := Field.Value;
      if(Field.DataType in [2, 3, 6, 7, 8]) then
      begin
        // Update the running total of this field.
        UpdateTotals(Control.vcName, Field.Value);

        with Control as IVRWFieldControl do
        begin
          if (Field.DataType in [2, 3]) then
          begin
            if PrintingToExcel then
              FormatStr := '#0.' + StringOfChar('0', vcVarNoDecs)
            else
              FormatStr := '#,0.' + StringOfChar('0', vcVarNoDecs);
          end
          else
            FormatStr := '#0';
          vcText := FormatFloat(FormatStr, StrippedStrToFloat(Field.Value));
          if not PrintingToExcel then
          begin
            { Check for 'blank on zero' }
            if (Pos('B', vcFieldFormat) <> 0) and
               (StrippedStrToFloat(Field.Value) = 0) then
              vcText := ''
            else
              vcText := RightNegative(vcText);
          end;
        end;
        if (StrippedStrToFloat(Field.Value) >= 0) then
          Control.vcText := Control.vcText + ' ';
      end;
      { If Control.vcPrintField is False, the field is
        not printed, but *is* included in totals. }
      if (Control as IVRWFieldControl).vcPrintField then
      begin
        { Layout holds the display details for the control - size, position,
          text, etc. }
        Layout := PrepareLayout(Region, Control, YStart);
        { DB Fields include drill-down information, which act as hyperlinks
          if the report is previewed -- clicking on them will take the
          user to the relevant record in Exchequer (assuming the report is
          being run from within Exchequer). }
        if Report.vrPrintMethodParams.pmPrintMethod = 0 then // Print preview
          Layout.DrillDownInfo := Field.DrillDownInfo;
      end;
    end;
  end
  { For formula controls... }
  else if Supports(Control, IVRWFormulaControl) then
  begin
    { ...locate the matching field entry in the Report Data Engine }
    Field := GetEngineControl(Control.vcName);
    { If Field.Print is False, the field is neither printed nor
      included in totals. }
    if (Field <> nil) and (Field.Print) then
    begin
      Control.vcText := Field.Value;
      if ((Control as IVRWFormulaControl).vcFormulaDefinition[1] <> '"') then
      begin
        // The ParseFormula routine makes callbacks which need to know
        // which control we are currently dealing with.
        OnNotifyField(Control.vcName);

        // Call ParseFormula to make sure we pick up any totals calculated
        // for the current record (the Report Engine will still hold the
        // values as they were before being updated).

        //PR: 24/06/2014 ABSEXCH-11693 For SQL we also need to recalulate any formulas in the
        //                             footer which reference formulas which include TOTALFIELD
        if (Pos('TOTALFIELD', Uppercase((Control as IVRWFormulaControl).vcFormulaDefinition)) <> 0) or
           (SQLUtils.UsingSQL and (Region.rgType in [rtRepFtr, rtSectionFtr])) then
          ParseFormula(Control as IVRWFormulaControl);

        // Update the running total of this formula.
        UpdateTotals(Control.vcName, Control.vcText);

        with Control as IVRWFormulaControl do
        begin
          if PrintingToExcel then
            FormatStr := '#0.' + StringOfChar('0', vcDecimalPlaces)
          else
            FormatStr := '#,0.' + StringOfChar('0', vcDecimalPlaces);

          vcText := FormatFloat(FormatStr, StrippedStrToFloat(Control.vcText));
          if not PrintingToExcel then
          begin
            { Check for 'blank on zero' }
            if (Pos('B', vcFieldFormat) <> 0) and
               (StrippedStrToFloat(Control.vcText) = 0) then
              vcText := ''
            else
              vcText := RightNegative(vcText);
          end;
        end;
        if (StrippedStrToFloat(Control.vcText) >= 0) and not PrintingToExcel then
          Control.vcText := Control.vcText + ' ';
      end;
      { If Control.vcPrintField is False, the field is
        not printed, but *is* included in totals. }
      if (Control as IVRWFormulaControl).vcPrintField then
      begin
        { Layout holds the display details for the control - size, position,
          text, etc. }
        Layout := PrepareLayout(Region, Control, YStart);
      end;
    end;
  end
  else
  { For all other control types... }
  begin
    { ...create the layout }
    Layout := PrepareLayout(Region, Control, YStart);
  end;
end;

function TVRWReportGenerator.FindExtraColumns(LastX: Integer): TStringList;
var
  RegionNo : Integer;
  ControlNo : Integer;
  Region: IVRWRegion;
  Control : IVRWControl;
  ThisLastX : Integer;
  XLSXPos : Integer;

  X, W, X1, W1 : Integer;
  s : string;
begin
  Result := TStringList.Create;
  ThisLastX := LastX;

  //Iterate through regions - are there any controls where Left is after the last column (LastX)
  for RegionNo := 0 to Report.vrRegions.rlCount - 1 do
  begin
    Region := Report.vrRegions.rlItems[RegionNo];

    if Region.rgType <> rtRepLines then
    begin
      for ControlNo := 0 to Region.rgControls.clCount - 1 do
      begin
        Control := Region.rgControls.clItems[ControlNo];
        if ValidXLSXControl(Control) then
        begin
          if (Pos('R', Control.vcFieldFormat) <> 0) then //right justified
            XLSXPos := Control.vcLeft + Control.vcWidth + 1
          else
            XLSXPos := Control.vcLeft + 1;

          if XLSXPos > LastX then
          begin
            Result.Add(Format('%.8d%.8d', [Control.vcLeft + 1, Control.vcWidth]));
            {$IFDEF DEBUGON}
             Dbug.msg(5, Format('Extra controls %s Left=%d; Width=%d; Top=%d', [Region.rgName, Control.vcLeft, Control.vcWidth, Control.vcTop]));
            {$ENDIF}
          end;
        end;
      end;

    end;
  end;

    //Delete any columns that clash
    if Result.Count > 0 then
    begin
      Result.Sort;
      s := Result[0];
      x := StrToInt(Copy(s, 1, 8));
      w := StrToInt(Copy(s, 9, 8));
      ControlNo := 1;
      while ControlNo < Result.Count do
      begin
        s := Result[ControlNo];
        x1 := StrToInt(Copy(s, 1, 8));
        w1 := StrToInt(Copy(s, 9, 8));

        if (x1 >= x) then
        begin
          if (x1 < x + w) then
          begin
            if x1 + w1 <= x + w then //completely contained - delete
              Result.Delete(0)
            else
            begin
              w := w1; //Increase width
              Result.Delete(0);
            end;
          end
          else
          begin
            inc(ControlNo);
            x := x1;
            w := w1;
          end;
        end
        else //Shouldn't happen
          Result.Delete(0);

      end; //while ControlNo < Result.Count
    end // if Result.Count > 0
    else
      FreeAndNil(Result);

end;

procedure TVRWReportGenerator.PrepareToPrintXLSX;
const
  //Arbitrary numbers
  LINES_ON_PAGE = 35;
  SECTIONS = 2000;
var
  TotalRows : Integer;
  PageHeaderRows : Integer;
  DefaultRows : Integer;
begin
  //Estimate total number of xl rows we'll need
  TotalRows := DBEngine.RecordCount * FRowsInLine;
  PageHeaderRows := (TotalRows div LINES_ON_PAGE) * FRowsInPage;
  TotalRows := TotalRows + PageHeaderRows + (SECTIONS * FRowsInSections);

  //Check if we have an ini file to override default
  with TIniFile.Create(SetDrive + XLSX_INC_ROWS_FILENAME) do
  Try
    DefaultRows := ReadInteger('Settings','Rows', XLSX_INC_ROWS_BY_DEFAULT);

    //Only replace default/ini with our estimate if it's larger
    if TotalRows > DefaultRows then
      ExportToExcel.IncrementRowsBy := TotalRows
    else
      ExportToExcel.IncrementRowsBy := DefaultRows;
  Finally
    Free;
  end;
end;

//Before saving xslx files set each column width to the initial width of its control, if that's wider than their current width
procedure TVRWReportGenerator.ResetXLSXColumnWidths;
var
  I : Integer;
  Control : IVRWControl;

begin
  for I := 0 to FXLSXRegionControls.Count - 1 do
  begin
    Control := TVRWControlWrapper(FXLSXRegionControls.Objects[I]).Control;

    ExportToExcel.SetColumnWidth(I, Round(Control.vcWidth), Justify(Control), True {don't reduce width});
  End; // For I
end;

//Function to return print justification from control format
function TVRWReportGenerator.Justify(
  const Control: IVRWControl): TPrintJustify;
begin
  //Set justification from control's field format
  if (Pos('R', Control.vcFieldFormat) <> 0) then
    Result := pjRight
  else if (Pos('C', Control.vcFieldFormat) <> 0) then
    Result := pjCenter
  else
    Result := pjLeft;
end;

{ TTotals }

function TTotals.Add(FieldName: ShortString;
  SectionNumber: SmallInt): TTotal;
begin
  Result := TTotal(inherited Add);
  Result.FieldName := Trim(FieldName);
  Result.SectionNumber := SectionNumber;
  Result.Value := 0.00;
end;

procedure TTotals.AddToTotal(FieldName: ShortString; AddValue: Double);
var
  Entry: Integer;
begin
{$IFDEF DEBUGON}
  Dbug.msg(2, '    Adding ' + FloatToStr(AddValue) + ' to ' + FieldName);
{$ENDIF}
  FieldName := Trim(FieldName);
  for Entry := 0 to Count - 1 do
  begin
    if SameText(FieldName, Items[Entry].FieldName) and
       (not Items[Entry].IsUpdated) then
    begin
      Items[Entry].Value := Items[Entry].Value + AddValue;
      Items[Entry].Count := Items[Entry].Count + 1;
      Items[Entry].IsUpdated := True;
    end;
  end;
end;

constructor TTotals.Create;
begin
  inherited Create(TTotal);
  FEnabled := True;
end;

{$IFDEF DEBUGON}
procedure TTotals.Debug_ShowAll;
var
  Entry: Integer;
  Item: TTotal;
begin
  Dbug.Msg(2, '=Totals====');
  for Entry := 0 to Count - 1 do
  begin
    Item := Items[Entry];
//    if (Trim(Item.FieldName) = 'Formula1') then
    begin
      DBug.Msg(
        2,
        Item.FieldName +
        '(' + IntToStr(Item.SectionNumber) + ') ' +
        FloatToStr(Item.Value)
      );
      DBug.Msg(2, 'IsUpdated:' + IfThen(Item.IsUpdated, 'Yes', 'No'));
    end;
  end;
  Dbug.Msg(2, '===========');
end;
{$ENDIF DEBUGON}

function TTotals.Exists(FieldName: ShortString;
  SectionNumber: SmallInt): Boolean;
var
  Entry: Integer;
begin
  Result := False;
  for Entry := 0 to Count - 1 do
  begin
    if (Items[Entry].FieldName = Trim(FieldName)) and
       (Items[Entry].SectionNumber = SectionNumber) then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function TTotals.FieldCount(FieldName: ShortString;
  SectionNumber: SmallInt; EndOfReport: Boolean): Integer;
var
  Entry: Integer;
begin
  Result := 0;
  for Entry := 0 to Count - 1 do
  begin
    if SameText(FieldName, Items[Entry].FieldName) and
       (SectionNumber = Items[Entry].SectionNumber) then
    begin
      if (SectionNumber = 0) and (not EndOfReport) then
        Result := Items[Entry].Count + 1
      else
        Result := Items[Entry].Count;
      Break;
    end;
  end;
end;

function TTotals.GetItem(Index: Integer): TTotal;
begin
  Result := TTotal(inherited GetItem(Index));
end;

procedure TTotals.Reset(SectionNumber: SmallInt);
{ Resets (to zero) all the entries against the specified section number }
var
  Entry: Integer;
begin
{$IFDEF DEBUGON}
  Dbug.msg(1, 'Clearing totals for section ' + IntToStr(SectionNumber));
{$ENDIF}
  for Entry := 0 to Count - 1 do
  begin
    if Items[Entry].SectionNumber = SectionNumber then
    begin
      Items[Entry].Value          := 0.00;
      Items[Entry].Count          := 0;
      Items[Entry].IsUpdated      := False;
    end;
  end;
end;

procedure TTotals.ResetUpdatedFlag(SectionNumber: SmallInt);
{ Resets the IsUpdated flag against each total -- this is done whenever we move
  to a new record, so that the Totals handler is ready to update the totals for
  the record. }
var
  Entry: Integer;
begin
{$IFDEF DEBUGON}
  Dbug.msg(2, 'Resetting Updated flag');
{$ENDIF}
  for Entry := 0 to Count - 1 do
  begin
    if (Items[Entry].SectionNumber = SectionNumber) or
       (SectionNumber = -1) then
      Items[Entry].IsUpdated := False;
  end;
end;

procedure TTotals.SetItem(Index: Integer; const Value: TTotal);
begin
  inherited SetItem(Index, Value);
end;

function TTotals.Value(FieldName: ShortString;
  SectionNumber: SmallInt): Double;
var
  Entry: Integer;
begin
  Result := 0.00;
  for Entry := 0 to Count - 1 do
  begin
    if SameText(FieldName, Items[Entry].FieldName) and
       (SectionNumber = Items[Entry].SectionNumber) then
    begin
      Result := Items[Entry].Value;
      Break;
    end;
  end;
end;

{ TTotal }

procedure TTotal.SetValue(const Value: Double);
begin
  FValue := Value;
end;

{ TVRWControlWrapper }

constructor TVRWControlWrapper.Create(ForControl: IVRWControl);
begin
  inherited Create;
  FVRWControl := ForControl;
end;

destructor TVRWControlWrapper.Destroy;
begin
  FVRWControl := nil;
  inherited;
end;

end.
