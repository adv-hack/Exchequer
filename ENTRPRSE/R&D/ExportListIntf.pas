Unit ExportListIntf;

Interface

Uses Messages, Windows;

// MH 26/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists

Const
  // Common export command descriptions -----------------------------
  ecIDCurrentRow = 1;
  ecdCurrentRow = 'Export Current Row to Excel';

  ecIDCurrentPage = 2;
  ecdCurrentPage = 'Export Current Page to Excel';

  ecIDEntireList = 3;
  ecdEntireList = 'Export Entire List to Excel';

  WM_ListExportProgress = WM_USER + $212;


  // Export Metadata tags -------------------------------------------
  // Note: sandwich the tags in chevrons to prevent one tag appearing within another
  // tag, e.g. CurrencyAmount and NonCurrencyAmount    
  emtPeriod = '<PERIOD>';
  emtCurrencyAmount = '<CURRENCYAMOUNT>';
  emtNonCurrencyAmount = '<NONCURRENCYAMOUNT>';
  // ForceText - used where the column may have data in multiple formats, e.g. Period Column on Auto Daybooks
  emtForceText = '<FORCETEXT>';
  // AlignRight - force right alignment where Exchequer behaviour is non-standard
  emtAlignRight = '<ALIGNRIGHT>';
  // Date - Excel is trying to convert all the dates to US Format (MM/DD/YYYY) which is screwing it all up!
  emtDate = '<DATE>';
  // Quantity - can have non-standard decimal places
  emtQuantity = '<QUANTITY>';
  // Cost Price - can have non-standard decimal places
  emtCostPrice = '<COSTPRICE>';
  // Sales Price - can have non-standard decimal places
  emtSalesPrice = '<SALESPRICE>';
  // MH 16/05/18 ABSEXCH-20519: Coded row emphasis as had to change the row export code to call the functions anyway
  emtBold = '<BOLD>';
  emtUnderline = '<UNDERLINE>';
  emtItalic = '<ITALIC>';

Type
  // Generic base interface for exporting lists
  IExportListData = Interface
    ['{BE57BB4C-EA3F-4384-B092-5D709FAF337B}']
    // --- Internal Methods to implement Public Properties ---
    Function GetExportTitle : ANSIString;
    Procedure SetExportTitle (Value : ANSIString);

    // ------------------ Public Properties ------------------
    Property ExportTitle : ANSIString Read GetExportTitle Write SetExportTitle;

    // ------------------- Public Methods --------------------
    Function StartExport : Boolean;
    Procedure FinishExport;

    Procedure AddColumnTitle (Const ColumnTitle, MetaData : ANSIString);
    Procedure AddColumnData (Const ColumnData, MetaData : ANSIString);
    Procedure NewRow;
  End; // IExportListData


Implementation

End.
