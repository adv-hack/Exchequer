unit RWRIntF;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

interface

Uses GlobVar;

Type
  IReportTreeElement = Interface;

  //------------------------------

  // Copied in from VarRec2U to minimise dependancies
  CCDepType = Array[False..True] of String[3];  {  CC/Dep Type }

  TReportType = (rtGroup, rtReport);

  //------------------------------

  FieldFontType = Record
    fColor : LongInt;          { TColor - Font Color }
    fStyle : Byte;             { TFontStyles - Bold, Italic, etc }
  End; // FieldFontType

  //------------------------------

  ReportFontType = Record
    fName  :  String[32];       { Font Name }
    fSize  :  SmallInt;         { Font Size }
    fColor :  LongInt;          { TColor - Font Color }
    fStyle :  Byte;             { TFontStyles - Bold, Italic, etc }
    fPitch :  Byte;             { TFontPitch - }
  End; // ReportFontType

  //------------------------------

  // Report Header record
  ReportHedType = Record
    ReportKey  : String[20];     {  Report Group+Report Code}
    RepGroup   : String[10];     {  Directory Group }
    Spare2     : Array[1..15] of Char;
    RepName    : String[10];     {  Rep Code }
    RepDesc    : String[130];    {  Rep Title }
    DriveFile  : SmallInt;       {  Driving Fnum }
    DrivePath  : SmallInt;       {  Driving Path }
    MaxWidth   : SmallInt;       {  Current Report Width}
    MaxCount   : LongInt;        {  Include Max Items }
    RepDest    : SmallInt;       {  Report default destination }
    RepSelect  : String[100];    {  Overall selection criteria }
    RLineCount : LongInt;        {  Count of variables / next No. }
    HLineCount : LongInt;        {  No Headings Count }
    LastRun    : LongDate;       {  LAst Report Run Date }
    LastOpo    : String[10];     {  Last Operator }
    RepType    : Char;           {  Report / Group Item }
    RepPgLen   : SmallInt;       {  Report Page Length }
    ILineCount : LongInt;        {  No Input Vars Count }
    TotLevels  : Byte;           {  No Nested Totals }
    NLineCount : LongInt;        {  Note Line Count }
    LastPath   : String[50];     {  Store last file name used }
    SampleNo   : LongInt;        {  No of selected records to include in Report Test Mode }
    TestMode   : Boolean;        {  Test Mode Flag }
    MLineCount : LongInt;        {  Nominal Line Count }
    CurrBreak  : Byte;           {  Record of last Break No. }
    FirstPos   : LongInt;        {  Record pos of first selected record }
    RefreshPos : Boolean;        {  Start looking from FirstPos ? }
    LastPos    : LongInt;        {  Record pos of last selected record }
    RefreshEnd : Boolean;        {  Abort when last pos encountered }
    FirstTot   : LongInt;        {  Count at first pos }
    HPrintEff  : LongInt;        {  Header Printing Effect }
    FNDXInpNo  : LongInt;        {  FastNDX Input LinkUp }
    DefFont    : ReportFontType; { Default Font for Windows Report }
    PaprOrient : Char;           { Paper Orientations - (P)ortrait or (L)andscape }
    ColSpace   : Byte;           { Space between columns in millimeters }
    PWord      : String[8];      { Security Password }
    PrnInpData : Boolean;        { Print Input Data Page }
    CSVTotals  : Boolean;
    Spare      : Array[1..31] of Byte;
  End; // ReportHedType

  //------------------------------

  ReportDetailType = Record
    ReportKey   : String[20];    {  RepName +Var Type + LineRef}
    RepName     : String[10];    {  Parent Code }
    RepVarNo    : LongInt;       {  Field No. }
    VarType     : Char;          {  R/I/H }
    VarLen      : Byte;          {  Variable length }
    PrintVar    : Boolean;       {  Print this variable }
    SubTot      : Boolean;       {  Sub Total }
    SortOrd     : String[2];     {  Sort Order ie 1A }
    PrintEff    : LongInt;       {  Weighted byte of print effect }
    VarRef      : String[10];    {  Variable Lookup }
    Break       : Byte;          {  Break Type Line, PAge }
    RepLDesc    : String[30];    {  Report Heading }
    Format      : String[30];    {  Format Mask }
    RecSelect   : String[100];   {  Record Selection }
    PrintSelect : String[100];   {  Print Selection }
    Summary     : Boolean;       {  Summary Report }
    CalcField   : Boolean;       {  Is a calculated field }
    VarNumPFix  : Char;          {  R Types can be I or R }
    RepLIType   : Byte;          {  Report Input Type 1..10 }
    RepPadNo    : String[10];    {  Padded Line Refernce }
    RepLPr      : CCDepType;     {  Special Period/Year Input }
    PrSel       : Boolean;       {  Period selection required }
    NoDecs      : Byte;          {  No Dec places for a real }
    RepLCr      : Byte;          {  Period Select Currency }
    ReCalcBTot  : Boolean;       {  Calculate Value at the end }
    ApplyPSumm  : Boolean;       {  Apply Print Select condition to Summary }
    CDrCr       : Boolean;       {  Show as Dr/Cr calc field only }
    SpareBool   : Boolean;       {  Use Default Report Font }
    WinFont     : FieldFontType; { Default Font for Windows Report }
    MMWidth     : SmallInt;      { Column Width in miliimeters }
    InputType   : Byte;          {  Type of input field needed }
    InputLink   : Byte;          {  Link to input field }
    Spare       : Array[1..47] of Byte;
    Case Byte of
      1  :  (VarSubSplit  :  String[100]);  {  Calculation / Sub Split }
      2  :  (ASCStr       :  Array[1..2] of String[30]); {Input Values}
      3  :  (DRange       :  Array[1..2] of LongDate);
      4  :  (VRange       :  Array[1..2] of Real);
      5  :  (PrRange      :  Array[1..2,1..2] of Byte);
      6  :  (PrIRange     :  Array[1..4] of Byte);
      7  :  (CrRange      :  Array[1..2] of Byte);
  End; // ReportDetailType

  //------------------------------

  // NOTE: To simplify the object, and significantly shorten development time, we
  // are re-using the RW record structures to store the report header and line info
  IReportDetails = Interface
    ['{2048764D-6CD4-4226-9AD4-94EF86B5D5DC}']
    // --- Internal Methods to implement Public Properties ---
    Function GetReportHeader : ReportHedType;
    Function GetHeadingLineCount : SmallInt;
    Function GetHeadingLines (Index: SmallInt) : ReportDetailType;
    Function GetInputLineCount : SmallInt;
    Function GetInputLines (Index: SmallInt) : ReportDetailType;
    Function GetReportLineCount : SmallInt;
    Function GetReportLines (Index: SmallInt) : ReportDetailType;

    // ------------------ Public Properties ------------------
    Property rdReportHeader : ReportHedType Read GetReportHeader;
    Property rdHeadingLineCount : SmallInt Read GetHeadingLineCount;
    Property rdHeadingLines [Index: SmallInt] : ReportDetailType Read GetHeadingLines;
    Property rdInputLineCount : SmallInt Read GetInputLineCount;
    Property rdInputLines [Index: SmallInt] : ReportDetailType Read GetInputLines;
    Property rdReportLineCount : SmallInt Read GetReportLineCount;
    Property rdReportLines [Index: SmallInt] : ReportDetailType Read GetReportLines;

    // ------------------- Public Methods --------------------
  End; // IReportDetails

  //------------------------------

  IReportTree = Interface
    ['{F9807303-DAE7-47BC-BB18-46E67D072CD2}']
    // --- Internal Methods to implement Public Properties ---
    Function GetReportCount : SmallInt;
    Function GetReportItems (Index: SmallInt) : IReportTreeElement;

    // ------------------ Public Properties ------------------
    // The number of reports/sub-groups in the Reports List
    Property rpReportCount : SmallInt Read GetReportCount;
    Property rpReports [Index: SmallInt] : IReportTreeElement Read GetReportItems;

    // ------------------- Public Methods --------------------
  End; // IReportTree

  //------------------------------

  IReportTreeElement = Interface(IReportTree)
    ['{D661E60E-9064-4E95-AC67-43FFA91BA0BA}']
    // --- Internal Methods to implement Public Properties ---
    Function GetCode : ShortString;
    Function GetName : ShortString;
    Function GetType : TReportType;
    Function GetPWord : ShortString;

    // ------------------ Public Properties ------------------
    Property rpCode : ShortString Read GetCode;
    Property rpName : ShortString Read GetName;
    Property rpType : TReportType Read GetType;
    // Encrypted Password for access into group
    Property rpPWord : ShortString Read GetPWord;

    // ------------------- Public Methods --------------------

  End; // IReportTreeElement



implementation

end.
