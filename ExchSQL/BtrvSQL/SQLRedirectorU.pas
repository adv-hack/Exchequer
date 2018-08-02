unit SQLRedirectorU;

interface

uses SysUtils, Classes, BtrvU2, GlobVar, CompilableVarRec, SQLStructuresU;

const
  MIN_REC_ADDRESS = 0;
  MAX_REC_ADDRESS = 1;

type
  TRangeArray = array[0..1] of LongInt;
  TRecordRange = record
    FileName: string;
    Prefix: Char;
    SubType: Char;
    Range: TRangeArray;
  end;

  TSQLRedirector = class(TObject)
  protected
    IsOpen: Boolean;
    PrefixSize: Integer;
    FPrefix: Char;
    FSubType: Char;
    KeyBuffer: Str255;
    PosBlock: FileVar;
    TableName: String;
    Path: string;
    FIndexNo: Integer;
    BaseOperation: Word;
    RecordRange: TRangeArray;

    // CJS 2014-09-24 - ABSEXCH-15624 - Core Running Errors on redirected files
    FClientID: Pointer;

    // Copies the fields from the original variant record into the record
    // for the new table.
    procedure ImportFields(var DataBlock); virtual; abstract;

    // Copies the key from the original buffer to the buffer for the new table.
    procedure ImportKeyBuffer(var KeyBuffer; KeyLength: Integer); virtual;

    // Copies the fields from the record for the new table back to the original
    // variant record.
    procedure ExportFields(var DataBlock; DataLength: Integer); virtual; abstract;

    // Copies the key from the new buffer to the original buffer.
    procedure ExportKeyBuffer(var KeyBuffer; KeyLength: Integer); virtual;

    // Returns the index number for the index which matches the supplied
    // index number from the original variant file.
    function TranslateIndex(OriginalIndex: Integer): Integer; virtual; abstract;

    // Performs the actual call to the redirected table. This must be provided
    // by the ancestor classes, as it needs to make use of the data buffers
    // specific to each table.
    function RedirectedCall(Operation: Word; IndexNumber: Integer; KeyLength: Integer; var DataLength: WORD; ClientID: pointer = nil): LongInt; virtual; abstract;

    // Returns True if the current key value is empty. This has default
    // handling for classes which use KeyBuffer, but must be overridden by
    // classes which store the key value in other ways (at the moment [07/2010]
    // this is only TTransactionNotesRedirector). See TSQLRedirector.BTRCall.
    function KeyIsEmpty: Boolean; virtual;

  public
    constructor Create(ForPath: string); virtual;
    function Close: LongInt;
    function Open(ClientID: pointer): LongInt;
    function BTRCall(operation: WORD; var posblk; var databuf; var datalen: WORD;
      var keybuf; keylen: Byte; keynum: Integer; ClientID: pointer = nil): SmallInt;
    property IndexNo: Integer read FIndexNo;
    property Prefix: Char read FPrefix;
    property SubType: Char read FSubType;
  end;

  TTransactionNotesKeyRec = record
    Folio: LongInt;
    NType: Char;
    LineNo: LongInt;
  end;

  TExchqChk_TransactionNotesKeyRec = record
    Prefix: Char;
    SubType: Char;
    Folio: LongInt;
    Padding: array[0..1] of Char;
    NType: Char;
    LineNo: array[1..4] of Char;
  end;

  TTransactionNotesRedirector = class(TSQLRedirector)
  private
  protected
    function KeyIsEmpty: Boolean; override;
  public
    DataRec: TTransactionNotesRec;
    KeyRec: TTransactionNotesKeyRec;
    procedure ImportFields(var DataBuffer); override;
    procedure ImportKeyBuffer(var KeyBuffer; KeyLength: Integer); override;
    procedure ExportFields(var DataBuffer; DataLength: Integer); override;
    procedure ExportKeyBuffer(var KeyBuffer; KeyLength: Integer); override;
    function RedirectedCall(Operation: Word; IndexNumber: Integer;
                            KeyLength: Integer; var DataLength: WORD; ClientID: pointer = nil): LongInt; override;
    function TranslateIndex(OriginalIndex: Integer): Integer; override;
    constructor Create(ForPath: string); override;
  end;

  TFinancialMatchingRedirector = class(TSQLRedirector)
  public
    DataRec: TFinancialMatchingRec;
    procedure ImportFields(var DataBuffer); override;
    procedure ExportFields(var DataBuffer; DataLength: Integer); override;
    function RedirectedCall(Operation: Word; IndexNumber: Integer;
                            KeyLength: Integer; var DataLength: WORD; ClientID: pointer = nil): LongInt; override;
    function TranslateIndex(OriginalIndex: Integer): Integer; override;
    constructor Create(ForPath: string); override;
  end;

  TCustomerDiscountRedirector = class(TSQLRedirector)
  public
    DataRec: TCustomerDiscountRec;
    procedure ImportFields(var DataBuffer); override;
    procedure ExportFields(var DataBuffer; DataLength: Integer); override;
    procedure ExportKeyBuffer(var KeyBuffer; KeyLength: Integer); override;
    function RedirectedCall(Operation: Word; IndexNumber: Integer;
                            KeyLength: Integer; var DataLength: WORD; ClientID: pointer = nil): LongInt; override;
    function TranslateIndex(OriginalIndex: Integer): Integer; override;
    constructor Create(ForPath: string); override;
  end;

  TCustomerStockAnalysisRedirector = class(TSQLRedirector)
  public
    DataRec: TCustomerStockAnalysisRec;
    procedure ImportFields(var DataBuffer); override;
    procedure ExportFields(var DataBuffer; DataLength: Integer); override;
    function RedirectedCall(Operation: Word; IndexNumber: Integer;
                            KeyLength: Integer; var DataLength: WORD; ClientID: pointer = nil): LongInt; override;
    function TranslateIndex(OriginalIndex: Integer): Integer; override;
    constructor Create(ForPath: string); override;
  end;

  TFiFoKey01Rec = record
    DocRef: array[1..10] of char;
    StockFolio: Integer;
    AbsLineNo: Integer;
  end;

  TExStkChk_FiFoKey01Rec = record
    Prefix: Char;
    SubType: Char;
    DocRef: array[1..9] of char;
    StockFolio: Integer;
    AbsLineNo: Integer;
  end;

  TFiFoRedirector = class(TSQLRedirector)
  public
    DataRec: TFiFoRec;
    Key01Rec: TFiFoKey01Rec;
    procedure ImportFields(var DataBuffer); override;
    procedure ImportKeyBuffer(var KeyBuffer; KeyLength: Integer); override;
    procedure ExportFields(var DataBuffer; DataLength: Integer); override;
    procedure ExportKeyBuffer(var KeyBuffer; KeyLength: Integer); override;
    function RedirectedCall(Operation: Word; IndexNumber: Integer;
                            KeyLength: Integer; var DataLength: WORD; ClientID: pointer = nil): LongInt; override;
    function TranslateIndex(OriginalIndex: Integer): Integer; override;
    constructor Create(ForPath: string); override;
  end;

  TSerialBatchRedirector = class(TSQLRedirector)
  public
    DataRec: TSerialBatchRec;
    procedure ImportFields(var DataBuffer); override;
    procedure ExportFields(var DataBuffer; DataLength: Integer); override;
    function RedirectedCall(Operation: Word; IndexNumber: Integer;
                            KeyLength: Integer; var DataLength: WORD; ClientID: pointer = nil): LongInt; override;
    function TranslateIndex(OriginalIndex: Integer): Integer; override;
    constructor Create(ForPath: string); override;
  end;

  TWindowSettingRedirector = class(TSQLRedirector)
  public
    DataRec: TWindowSettingRec;
    procedure ImportFields(var DataBuffer); override;
    procedure ExportFields(var DataBuffer; DataLength: Integer); override;
    function RedirectedCall(Operation: Word; IndexNumber: Integer;
                            KeyLength: Integer; var DataLength: WORD; ClientID: pointer = nil): LongInt; override;
    function TranslateIndex(OriginalIndex: Integer): Integer; override;
    constructor Create(ForPath: string); override;
  end;

  TLocationRedirector = class(TSQLRedirector)
  public
    DataRec: TLocationRec;
    procedure ImportFields(var DataBuffer); override;
    procedure ExportFields(var DataBuffer; DataLength: Integer); override;
    function RedirectedCall(Operation: Word; IndexNumber: Integer;
                            KeyLength: Integer; var DataLength: WORD; ClientID: pointer = nil): LongInt; override;
    function TranslateIndex(OriginalIndex: Integer): Integer; override;
    constructor Create(ForPath: string); override;
  end;

  TStockLocationRedirector = class(TSQLRedirector)
  public
    DataRec: TStockLocationRec;
    procedure ImportFields(var DataBuffer); override;
    procedure ExportFields(var DataBuffer; DataLength: Integer); override;
    function RedirectedCall(Operation: Word; IndexNumber: Integer;
                            KeyLength: Integer; var DataLength: WORD; ClientID: pointer = nil): LongInt; override;
    function TranslateIndex(OriginalIndex: Integer): Integer; override;
    constructor Create(ForPath: string); override;
  end;

  TAllocWizardSessionRedirector = class(TSQLRedirector)
  public
    DataRec: TAllocWizardSessionRec;
    procedure ImportFields(var DataBuffer); override;
    procedure ExportFields(var DataBuffer; DataLength: Integer); override;
    function RedirectedCall(Operation: Word; IndexNumber: Integer;
                            KeyLength: Integer; var DataLength: WORD; ClientID: pointer = nil): LongInt; override;
    function TranslateIndex(OriginalIndex: Integer): Integer; override;
    constructor Create(ForPath: string); override;
  end;

  TAnalysisCodeBudgetRedirector = class(TSQLRedirector)
  public
    DataRec: TJobBudgetRec;
    procedure ImportFields(var DataBuffer); override;
    procedure ImportKeyBuffer(var KeyBuffer; KeyLength: Integer); override;
    procedure ExportFields(var DataBuffer; DataLength: Integer); override;
    procedure ExportKeyBuffer(var KeyBuffer; KeyLength: Integer); override;
    function RedirectedCall(Operation: Word; IndexNumber: Integer;
                            KeyLength: Integer; var DataLength: WORD; ClientID: pointer = nil): LongInt; override;
    function TranslateIndex(OriginalIndex: Integer): Integer; override;
    constructor Create(ForPath: string); override;
  end;

  TJobTotalsBudgetRedirector = class(TAnalysisCodeBudgetRedirector)
  public
    DataRec: TJobBudgetRec;
    procedure ImportKeyBuffer(var KeyBuffer; KeyLength: Integer); override;
    procedure ExportKeyBuffer(var KeyBuffer; KeyLength: Integer); override;
    constructor Create(ForPath: string); override;
  end;

  // CJS 2014-07-24 7.x ORD - Order Payments Matching normalisation
  TOrderPaymentsMatchingRedirector = class(TSQLRedirector)
  public
    DataRec: TFinancialMatchingRec;
    procedure ImportFields(var DataBuffer); override;
    procedure ExportFields(var DataBuffer; DataLength: Integer); override;
    function RedirectedCall(Operation: Word; IndexNumber: Integer;
                            KeyLength: Integer; var DataLength: WORD; ClientID: pointer = nil): LongInt; override;
    function TranslateIndex(OriginalIndex: Integer): Integer; override;
    constructor Create(ForPath: string); override;
  end;

  TSQLRedirectorFactory = class(TObject)
  private
    FEnabled: Boolean;
  public
    // Determines the appropriate table, based on the details in the data buffer
    // and the key, and returns the redirector class which handles it. Returns
    // nil if there is no redirector class for this table or variant.
    function GetRedirector(Op: Word; var posblk; var databuf; var keyblk): TSQLRedirector;
    property Enabled: Boolean read FEnabled write FEnabled;
  end;

  TSQLRedirectorCache = class(TObject)
  private
    FList: TList;
    function IndexOf(Prefix, SubType: Char): Integer;
    function GetRedirector(Prefix, SubType: Char): TSQLRedirector;
    procedure SetRedirector(Prefix, SubType: Char;
      const Value: TSQLRedirector);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;

    // Returns the Redirector whose offset record range includes the supplied
    // record address. The offset record range is a way of identifying which
    // variant is required for GetDirect calls -- this is because GetDirect is
    // not called with anything which allows the correct variant to be
    // identified. The offset record ranges are different for each variant, so
    // that the record address can be used for this purpose. The offset address
    // is converted back to the correct address by the ExportFields methods.
    function RedirectorForRecordAddress(RecAddress: LongInt): TSQLRedirector;
    function PrefixForRecordAddress(RecAddress: LongInt; FileName: string;
      var Prefix: Char; var SubType: Char): Boolean;

    // Returns the cached Redirector which matches the specified Prefix and
    // Subtype. Returns nil if no matching Redirector can be found.
    property Redirector[Prefix, SubType: Char]: TSQLRedirector
      read GetRedirector write SetRedirector; default;
  end;

  // Returns the singleton instance of the Redirector Factory.
  function RedirectorFactory: TSQLRedirectorFactory;

  Procedure Finalize_SQLRedirectorU;

const
  { These are assigned to the RecordRange property of each Redirector class. }

  // CJS 31/03/2011 - ABSEXCH-10648 - DEBEN GROUP: Error 43. Increased offset
  // ranges.

  //                              Max:  2147483647
  { ExchqChk }
  TRANSACTION_NOTES_RANGE_START       =  100000000;
  TRANSACTION_NOTES_RANGE_END         =  199999999;
  FINANCIAL_MATCHING_RANGE_START      =  200000000;
  FINANCIAL_MATCHING_RANGE_END        =  299999999;
  // CJS 24/07/2014 - 7.x ORD - T010 - Added Order Payments Matching range
  ORDER_PAYMENTS_MATCHING_RANGE_START =  300000000;
  ORDER_PAYMENTS_MATCHING_RANGE_END   =  399999999;

  { ExStkChk}
  CUSTOMER_DISCOUNTS_RANGE_START      =  100000000;
  CUSTOMER_DISCOUNTS_RANGE_END        =  199999999;
  FIFO_RANGE_START                    =  200000000;
  FIFO_RANGE_END                      =  299999999;
  SERIAL_BATCH_RANGE_START            =  300000000;
  SERIAL_BATCH_RANGE_END              =  399999999;
  WINDOW_SETTING_RANGE_START          =  400000000;
  WINDOW_SETTING_RANGE_END            =  499999999;

  { MLocStk }
  CUSTOMER_STOCK_ANALYSIS_RANGE_START =  100000000;
  CUSTOMER_STOCK_ANALYSIS_RANGE_END   =  199999999;
  LOCATION_RANGE_START                =  200000000;
  LOCATION_RANGE_END                  =  299999999;
  STOCK_LOCATION_RANGE_START          =  300000000;
  STOCK_LOCATION_RANGE_END            =  399999999;
  ALLOC_WIZARD_SESSION_RANGE_START    =  400000000;
  ALLOC_WIZARD_SESSION_RANGE_END      =  499999999;

  { JobCtrl }
  ANALYSIS_CODE_BUDGET_RANGE_START    =  100000000;
  ANALYSIS_CODE_BUDGET_RANGE_END      =  199999999;
  JOB_TOTALS_BUDGET_RANGE_START       =  200000000;
  JOB_TOTALS_BUDGET_RANGE_END         =  299999999;

  {
    CJS 09/02/2011 - ABSEXCH-10870 - Corrected the Prefix and Subtypes for
    Customer Stock Analysis, Locations, and Stock Locations.
  }
  // CJS 24/07/2014 - 7.x ORD - T010 - Added Order Payments Matching range
  RecordRanges: array[1..13] of TRecordRange =
    (
      (Filename: 'EXCHQCHK.DAT'; Prefix: 'N'; SubType: 'D'; Range: (TRANSACTION_NOTES_RANGE_START, TRANSACTION_NOTES_RANGE_END)),
      (Filename: 'EXCHQCHK.DAT'; Prefix: 'T'; SubType: 'P'; Range: (FINANCIAL_MATCHING_RANGE_START, FINANCIAL_MATCHING_RANGE_END)),
      (Filename: 'EXCHQCHK.DAT'; Prefix: 'T'; SubType: 'R'; Range: (ORDER_PAYMENTS_MATCHING_RANGE_START, ORDER_PAYMENTS_MATCHING_RANGE_END)),
      (Filename: 'EXSTKCHK.DAT'; Prefix: 'C'; SubType: 'C'; Range: (CUSTOMER_DISCOUNTS_RANGE_START, CUSTOMER_DISCOUNTS_RANGE_END)),
      (Filename: 'EXSTKCHK.DAT'; Prefix: 'F'; SubType: 'S'; Range: (FIFO_RANGE_START, FIFO_RANGE_END)),
      (Filename: 'EXSTKCHK.DAT'; Prefix: 'F'; SubType: 'R'; Range: (SERIAL_BATCH_RANGE_START, SERIAL_BATCH_RANGE_END)),
      (Filename: 'EXSTKCHK.DAT'; Prefix: 'U'; SubType: 'C'; Range: (WINDOW_SETTING_RANGE_START, WINDOW_SETTING_RANGE_END)),
      (Filename: 'MLOCSTK.DAT';  Prefix: 'T'; SubType: 'P'; Range: (CUSTOMER_STOCK_ANALYSIS_RANGE_START, CUSTOMER_STOCK_ANALYSIS_RANGE_END)),
      (Filename: 'MLOCSTK.DAT';  Prefix: 'C'; SubType: 'C'; Range: (LOCATION_RANGE_START, LOCATION_RANGE_END)),
      (Filename: 'MLOCSTK.DAT';  Prefix: 'C'; SubType: 'D'; Range: (STOCK_LOCATION_RANGE_START, STOCK_LOCATION_RANGE_END)),
      (Filename: 'MLOCSTK.DAT';  Prefix: 'X'; SubType: 'C'; Range: (ALLOC_WIZARD_SESSION_RANGE_START, ALLOC_WIZARD_SESSION_RANGE_END)),
      (Filename: 'JOBCTRL.DAT';  Prefix: 'J'; SubType: 'B'; Range: (ANALYSIS_CODE_BUDGET_RANGE_START, ANALYSIS_CODE_BUDGET_RANGE_END)),
      (Filename: 'JOBCTRL.DAT';  Prefix: 'J'; SubType: 'M'; Range: (JOB_TOTALS_BUDGET_RANGE_START, JOB_TOTALS_BUDGET_RANGE_END))
    );

implementation

uses Dialogs,
  SQLVariantsU, VarRec2U, BtrvSQLU, BtKeys1U, ETMiscU, ETStrU, StrUtils,
  DebugLogU;

const
  // Btrieve operations which require a valid populated data buffer.
  InputDataOps  = [B_Insert, B_Update, B_GetDirect, B_Unlock, B_GetPrevEx, B_UpdateEx];

  // Btrieve operations which require a valid populated key.
  InputKeyOps   = [B_GetEq, B_GetNext, B_GetPrev, B_GetGretr, B_GetGEq, B_GetLess, B_GetLessEq, B_GetNextEx, B_GetPrevEx];

  // Btrieve operations which return a populated data buffer.
  OutputDataOps = [B_GetEq, B_GetNext, B_GetPrev, B_GetGretr, B_GetGEq, B_GetLess, B_GetLessEq, B_GetFirst, B_GetLast, B_GetPos, B_GetDirect, B_GetNextEx, B_GetPrevEx];

  // Btrieve operations which return a populated key.
  OutputKeyOps  = [B_Insert, B_Update, B_GetNext, B_GetPrev, B_GetGretr, B_GetGEq, B_GetLess, B_GetLessEq, B_GetFirst, B_GetLast, B_GetDirect, B_GetDirect, B_GetNextEx, B_GetPrevEx];

var
  FRedirectorFactory: TSQLRedirectorFactory;

// =============================================================================

function RedirectorFactory: TSQLRedirectorFactory;
begin
  if not Assigned(FRedirectorFactory) then
  begin
    FRedirectorFactory := TSQLRedirectorFactory.Create;
    FRedirectorFactory.Enabled := True;
  end;
  Result := FRedirectorFactory;
end;

// =============================================================================
// Copied from CuStkA4U.pas, used by TCustomerStockAnalysisRedirector
// =============================================================================
function Full_CuStkLKey(cc: Str10; LineNo: LongInt): Str30;
begin
  Result := FullCustCode(cc) + ConstStr(#0, 4) + Dec2Hex(LineNo);
end;
// -----------------------------------------------------------------------------
function Full_CuStkKey(cc: Str10; sc: Str20): Str30;
begin
  Full_CuStkKey := FullCustCode(cc) + ConstStr(#0, 4) + FullStockCode(sc);
end;
// -----------------------------------------------------------------------------
function Full_CuStkKey2(cc: Str10; sc: Str20): Str30;
begin
  Full_CuStkKey2 := FullStockCode(sc) + ConstStr(#0, 4) + FullCustCode(cc);
end;
// =============================================================================

// =============================================================================
// Copied from BtKeys1U.pas, used by TFiFoRedirector
// =============================================================================
// In BtKeys1U.pas these functions are inside STK and PF_On directives. If these
// directives are included in BtrvSQLU, it will crash on start-up, so the
// functions have been duplicated here instead.
// -----------------------------------------------------------------------------
function MakeFIKey(SFOL: LongInt; SDate: LongDate): Str30;
begin
  Result := FullNomKey(SFOL) + SDate;
end;
// -----------------------------------------------------------------------------
function MakeFIDocKey(DNo: Str10; SFOL, DLNo: LongInt): Str30;
begin
  Result := FullOurRefKey(DNo) + FullNomKey(SFOL) + FullNomKey(DLNo) + HelpKStop;
end;
// =============================================================================

// =============================================================================
// Copied from BtKeys1U.pas, used by TSerialBatchRedirector
// =============================================================================
function MakeSNKey(SFOL: LongInt; Sold: Boolean; SNo: Str20): Str30;
begin
  Result := FullNomKey(SFOL) + Chr(Ord(Sold)) + SNo;
end;

// =============================================================================
// Copied from BtKeys1U.pas, used by TStockLocationRedirector
// =============================================================================
function Full_MLocKey(lc: Str10): Str10;
begin
  Result := LJVar(LC, MLocKeyLen);
end;
// -----------------------------------------------------------------------------
function Full_MLocLKey(lc: Str10; sc: Str20): Str30;
begin
  Result := Full_MLocKey(lc) + FullStockCode(sc);
end;
// -----------------------------------------------------------------------------
function Full_MLocSKey(lc: Str10; sc: Str20): Str30;
begin
  Result := FullStockCode(sc) + Full_MLocKey(lc);
end;
// =============================================================================

// =============================================================================
// Copied from JobSup1U.pas, used by TAnalysisCodeBudgetRedirector
// =============================================================================
function FullJBDDKey(JC: Str10; MH: LongInt): Str20;
begin
  Result := FullJobCode(JC) + FullNomKey(MH) + HelpKStop;
end;

// =============================================================================
// TSQLRedirectorFactory
// =============================================================================

function TSQLRedirectorFactory.GetRedirector(Op: Word; var posblk;
  var databuf; var keyblk): TSQLRedirector;
type
  TBuffer = array[0..255] of Byte;
var
  FileName: string;
  Path: string;
  KeyBuffer: Str255;
  DataBuffer: Str255;
  Prefix: Char;
  SubType: Char;
  RecAddress: LongInt;
  VariantFile: TSQLVariantFile;
  Redirector: TSQLRedirector;

  // ...........................................................................
  function GetCharDef(Buffer: string; IndexPos: Integer; Default: Char): Char;
  { Returns the character at the specified position in the buffer string, or
    returns the default character if IndexPos is not a valid position. }
  begin
    if (Length(Buffer) > IndexPos - 1) then
      Result := Buffer[IndexPos]
    else
      Result := Default;
  end;
  // ...........................................................................

begin
  Result := nil;
  if (Enabled) then
  begin
    { Get the details for the current file. If this is not a variant file,
      this will return nil, and can be ignored, as non-variant files are not
      being redirected. }
    VariantFile := SQLVariants.GetEntry(posblk);
    if (VariantFile <> nil) then
    begin
      { Remove any lock offset. }
      Op := (Op mod 100);
      if (Op > 50) then
        Op := Op - 50;
      { Get the Prefix and SubType from either the search key or the data
        record. }
      FillChar(KeyBuffer, 255, 0);
      FillChar(DataBuffer, 255, 0);
      Move(TBuffer(keyblk), KeyBuffer[1], 255);
      KeyBuffer[0] := Char(255);
      Move(TBuffer(databuf), DataBuffer[1], 4);
      DataBuffer[0] := Char(4);
      Prefix  := #0;
      SubType := #0;
      if (Op in InputKeyOps) then
      begin
        Prefix  := GetCharDef(KeyBuffer, 1, #0);
        SubType := GetCharDef(KeyBuffer, 2, #0);
      end
      else if (Op <> B_GetDirect) then
      begin
        Prefix  := GetCharDef(DataBuffer, 1, #0);
        SubType := GetCharDef(DataBuffer, 2, #0);
      end;
      if (Op = B_GetPos) then
      begin
        { Get Position will not have a valid search key or data record. Get the
          last Redirector which was referenced for the current variant file, and
          use this (the last record-positioning command against this file must
          have been for the variant record which is now being referenced, and
          hence the last redirector should be the correct one. }
        Redirector := VariantFile.LastRedirector;
      end
      else if (Op = B_GetDirect) or (Op = B_Unlock) then
      begin
        { Get the Redirector which matches the offset record address. }
        Move(DataBuffer[1], RecAddress, 4);
        Redirector := VariantFile.RedirectorForRecordAddress(RecAddress);
        { If no Redirector can be found, we haven't yet done a navigation
          operation for this file. Instead, set the Prefix and Subtype that
          matches this file and variant, so that the correct Redirector will
          be created. }
        if (Redirector = nil) then
        begin
          VariantFile.PrefixForRecordAddress(RecAddress, Prefix, SubType);
        end;
      end
      else
      begin
        { Get the redirector for the variant identified by the Prefix and
          SubType. This will return nil if this is the first time that this
          variant set of records has been referenced. }
        Redirector := VariantFile.Redirector[Prefix, SubType];
      end;
      // CJS 2014-05-06 - ABSEXCH-15215 - error 43 on closing Batch Payments
      // CJS 2015-11-11 - ABSEXCH-16531 - SQL Redirection not handling GetDirect correctly
      if (Redirector = nil) and not (Op = B_GetPos) then
      begin
        { A Redirector does not yet exist for the current variant record set,
          so create one now. This assumes that the operation is not Get Position
          (which would be invalid under these circumstances, as it would mean
          that Get Position was being called before a record-positioning
          operation had been carried out on this record set). }
        Path := ExtractFilePath(VariantFile.FileSpec);
        FileName := VariantFile.TableName;
        if (FileName = 'EXCHQCHK.DAT') then
        begin
          case Prefix of
            'N':  if (SubType = 'D') then
                  begin
                    { Create a Redirector, and add it to the list of Redirectors
                      for this variant file. }
                    Redirector := TTransactionNotesRedirector.Create(Path);
                    VariantFile.Redirector[Prefix, SubType] := Redirector;
                  end;
            'T': if (SubType = 'P') then
                  begin
                    Redirector := TFinancialMatchingRedirector.Create(Path);
                    VariantFile.Redirector[Prefix, SubType] := Redirector;
                  end
                  else if (SubType = 'R') then
                  begin
                    Redirector := TOrderPaymentsMatchingRedirector.Create(Path);
                    VariantFile.Redirector[Prefix, SubType] := Redirector;
                  end;
          end;
        end
        else if (FileName = 'EXSTKCHK.DAT') then
        begin
          case Prefix of
            'C': if (SubType = 'C') then
                 begin
                   Redirector := TCustomerDiscountRedirector.Create(Path);
                   VariantFile.Redirector[Prefix, SubType] := Redirector;
                 end;
            'F': if (SubType = 'S') then
                 begin
                   Redirector := TFiFoRedirector.Create(Path);
                   VariantFile.Redirector[Prefix, SubType] := Redirector;
                 end
                 else if (SubType = 'R') then
                 begin
                   Redirector := TSerialBatchRedirector.Create(Path);
                   VariantFile.Redirector[Prefix, SubType] := Redirector;
                 end;
{
            'U': if (SubType = 'C') then
                 begin
                   Redirector := TWindowSettingRedirector.Create(Path);
                   VariantFile.Redirector[Prefix, SubType] := Redirector;
                 end;
}                 
          end;
        end
        else if (FileName = 'MLOCSTK.DAT') then
        begin
          case Prefix of
            'T': if (SubType = 'P') then
                 begin
                   Redirector := TCustomerStockAnalysisRedirector.Create(Path);
                   VariantFile.Redirector[Prefix, SubType] := Redirector;
                 end;
            'C': if (SubType = 'C') then
                 begin
                   Redirector := TLocationRedirector.Create(Path);
                   VariantFile.Redirector[Prefix, SubType] := Redirector;
                 end
                 else if (SubType = 'D') then
                 begin
                   Redirector := TStockLocationRedirector.Create(Path);
                   VariantFile.Redirector[Prefix, SubType] := Redirector;
                 end;
            'X': if (SubType = 'C') then
                 begin
                   Redirector := TAllocWizardSessionRedirector.Create(Path);
                   VariantFile.Redirector[Prefix, SubType] := Redirector;
                 end;
          end;
        end
        else if (FileName = 'JOBCTRL.DAT') then
        begin
          case Prefix of
            'J': if (SubType = 'B') then
                 begin
                   Redirector := TAnalysisCodeBudgetRedirector.Create(Path);
                   VariantFile.Redirector[Prefix, SubType] := Redirector;
                 end
                 else if (SubType = 'M') then
                 begin
                   Redirector := TJobTotalsBudgetRedirector.Create(Path);
                   VariantFile.Redirector[Prefix, SubType] := Redirector;
                 end;
          end;
        end;
      end;
      { Store this Redirector (if any) as the Redirector which was last used
        for this variant file. It is valid for this to be nil (which would mean
        that a Redirector type does not exist for the current Prefix and
        SubType, and hence the calls cannot be redirected). }
      VariantFile.LastRedirector := Redirector;
      Result := Redirector;
    end;
  end;
end;

// =============================================================================
// TSQLRedirector
// =============================================================================

function TSQLRedirector.BTRCall(operation: WORD; var posblk; var databuf;
  var datalen: WORD; var keybuf; keylen: Byte; keynum: Integer; ClientID: pointer): SmallInt;
var
  IsKeyOnly: Boolean;
  LockOffset: Integer;
begin
  { Remove any lock offset. }
  BaseOperation := operation mod 100;
  if (BaseOperation > 50) then
  begin
    IsKeyOnly := True;
    BaseOperation := BaseOperation - 50;
    LockOffset := operation div 100;
  end
  else
  begin
    IsKeyOnly := False;
    LockOffset := 0;
  end;

  FIndexNo := TranslateIndex(keynum);

  if (BaseOperation in InputDataOps) then
    ImportFields(databuf);

  if (BaseOperation in InputKeyOps) then
    ImportKeyBuffer(keybuf, keylen);

  { A search against an empty string can return inconsistent results, so
    translate the operation into a simple GetFirst or GetLast as appropriate. }
  if KeyIsEmpty then
  begin
    if (BaseOperation in [B_GetGretr, B_GetGEq]) then
      operation := B_GetFirst + LockOffset
    else if (BaseOperation in [B_GetLess, B_GetLessEq]) then
      operation := B_GetLast + LockOffset;
  end;

  BtrvSQLU.Redirected := True;
  try
    Result := RedirectedCall(operation, keynum, keylen, datalen, ClientID);
  finally
    BtrvSQLU.Redirected := False;
  end;

  if (BaseOperation in OutputKeyOps) then
    ExportKeyBuffer(keybuf, keylen);

  if (BaseOperation in OutputDataOps) and not IsKeyOnly then
    ExportFields(databuf, datalen);
end;

// -----------------------------------------------------------------------------

function TSQLRedirector.Close: LongInt;
begin
  // CJS 2014-09-24 - ABSEXCH-15624 - Core Running Errors on redirected files
  if (FClientID <> nil) then
    Result := Close_FileCId(PosBlock, FClientID)
  else
    Result := Close_File(PosBlock);
  IsOpen := False;
end;

// -----------------------------------------------------------------------------

constructor TSQLRedirector.Create(ForPath: string);
begin
  inherited Create;
  IsOpen := False;
  PrefixSize := 2;
  Path := ForPath;
  RecordRange[MIN_REC_ADDRESS] := 0;
  RecordRange[MAX_REC_ADDRESS] := 999999999;
end;

// -----------------------------------------------------------------------------

procedure TSQLRedirector.ExportKeyBuffer(var KeyBuffer;
  KeyLength: Integer);
begin
  if PrefixSize = 1 then
    self.KeyBuffer := Prefix + self.KeyBuffer
  else
    self.KeyBuffer := Prefix + SubType + self.KeyBuffer;
  Move(self.KeyBuffer[1], KeyBuffer, Length(self.KeyBuffer));
end;

// -----------------------------------------------------------------------------

procedure TSQLRedirector.ImportKeyBuffer(var KeyBuffer;
  KeyLength: Integer);
var
  Start: Integer;
  Buffer: array[1..257] of Char absolute KeyBuffer;
begin
  FillChar(self.KeyBuffer, SizeOf(self.KeyBuffer), 0);
  Start := PrefixSize + 1;
  KeyLength := KeyLength - PrefixSize;
  if (KeyLength > SizeOf(Buffer)) then
    KeyLength := SizeOf(Buffer);
//  Move(Buffer[Start - 1], self.KeyBuffer, KeyLength);
  Move(Buffer[Start], self.KeyBuffer[1], KeyLength);
  self.KeyBuffer[0] := Char(KeyLength);
end;

// -----------------------------------------------------------------------------

function TSQLRedirector.KeyIsEmpty: Boolean;
begin
  Result := (KeyBuffer = '');
end;

// -----------------------------------------------------------------------------

function TSQLRedirector.Open(ClientID: pointer): LongInt;
begin
  if not IsOpen then
  begin
    // CJS 2014-09-24 - ABSEXCH-15624 - Core Running Errors on redirected files
    FClientID := ClientID;

    if (ClientID <> nil) then
      Result := Open_FileCId(PosBlock, Path + TableName, 0, ClientID)
    else
      Result := Open_File(PosBlock, Path + TableName, 0);
    if (Result = 0) then
      IsOpen := True;
  end
  else
    Result := 0;
end;

// =============================================================================
// TTransactionNotesRedirector
// =============================================================================

constructor TTransactionNotesRedirector.Create(ForPath: string);
begin
  inherited Create(ForPath);
  FPrefix  := 'N';
  FSubType := 'D';
  TableName := 'TransactionNote.dat';
  RecordRange[0] := TRANSACTION_NOTES_RANGE_START;
  RecordRange[1] := TRANSACTION_NOTES_RANGE_END;
end;

// -----------------------------------------------------------------------------

procedure TTransactionNotesRedirector.ExportFields(var DataBuffer;
  DataLength: Integer);
var
  PPassRec: ^PassWordRec;
  RecAddress: LongInt;
begin
  PPassRec := @DataBuffer;
  if (BaseOperation = B_GetPos) then
  begin
    // Offset the record address, so that a subsequent GetDirect can identify
    // the variant type to which it relates.
    Move(DataRec, RecAddress, 4);
    RecAddress := RecAddress + RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataBuffer, 4);
  end
  else
  begin
    // Copy the data buffer back to the variant record structure.
    PPassRec^.RecPfix := Prefix;
    PPassRec^.SubType := SubType;
    PPassRec^.NotesRec.NoteNo     := FullNCode(FullNomKey(DataRec.NoteFolio)) + DataRec.NType + Dec2Hex(DataRec.LineNo);
    PPassRec^.NotesRec.NoteDate   := DataRec.NoteDate;
    PPassRec^.NotesRec.NoteAlarm  := DataRec.NoteAlarm;
    PPassRec^.NotesRec.NoteFolio  := FullNomKey(DataRec.NoteFolio);
    PPassRec^.NotesRec.NType      := DataRec.NType;
    PPassRec^.NotesRec.LineNo     := DataRec.LineNo;
    PPassRec^.NotesRec.NoteLine   := DataRec.NoteLine;
    PPassRec^.NotesRec.NoteUser   := DataRec.NoteUser;
    PPassRec^.NotesRec.TmpImpCode := DataRec.TmpImpCode;
    PPassRec^.NotesRec.ShowDate   := DataRec.ShowDate;
    PPassRec^.NotesRec.RepeatNo   := DataRec.RepeatNo;
    PPassRec^.NotesRec.NoteFor    := DataRec.NoteFor;
  end;
end;

// -----------------------------------------------------------------------------

procedure TTransactionNotesRedirector.ExportKeyBuffer(var KeyBuffer;
  KeyLength: Integer);
var
  HexValue: string[4];
begin
  with TExchqChk_TransactionNotesKeyRec(KeyBuffer) do
  begin
    Prefix  := self.Prefix;
    SubType := self.SubType;
    Folio   := KeyRec.Folio;
    Padding := '  ';
    NType   := KeyRec.NType;
    HexValue := IntToHex(KeyRec.LineNo, 4);
    Move(HexValue[1], LineNo, SizeOf(LineNo));
  end;
end;

// -----------------------------------------------------------------------------

procedure TTransactionNotesRedirector.ImportFields(var DataBuffer);
var
  PPassRec: ^PassWordRec;
  RecAddress: LongInt;
begin
  PPassRec := @DataBuffer;
  if (BaseOperation = B_GetDirect) or (BaseOperation = B_Unlock) then
  begin
    // Convert the offset record address into the actual record address.
    Move(DataBuffer, RecAddress, 4);
    RecAddress := RecAddress - RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataRec, 4);
  end
  else
  begin
    // Copy the variant record contents to the data buffer.
    DataRec.NoteDate   := PPassRec^.NotesRec.NoteDate;
    DataRec.NoteAlarm  := PPassRec^.NotesRec.NoteAlarm;
    DataRec.NoteFolio  := UnFullNomKey(PPassRec^.NotesRec.NoteFolio);
    DataRec.NType      := PPassRec^.NotesRec.NType;
    DataRec.LineNo     := PPassRec^.NotesRec.LineNo;
    DataRec.NoteLine   := PPassRec^.NotesRec.NoteLine;
    DataRec.NoteUser   := PPassRec^.NotesRec.NoteUser;
    DataRec.TmpImpCode := PPassRec^.NotesRec.TmpImpCode;
    DataRec.ShowDate   := PPassRec^.NotesRec.ShowDate;
    DataRec.RepeatNo   := PPassRec^.NotesRec.RepeatNo;
    DataRec.NoteFor    := PPassRec^.NotesRec.NoteFor;
  end;
end;

// -----------------------------------------------------------------------------

procedure TTransactionNotesRedirector.ImportKeyBuffer(var KeyBuffer;
  KeyLength: Integer);
begin
  {
    Original key:
      Prefix + SubType + FullNomKey(Folio) + NType + Dec2Hex(LineNo)
  }
  KeyRec.Folio  := TExchqChk_TransactionNotesKeyRec(KeyBuffer).Folio;
  KeyRec.NType  := TExchqChk_TransactionNotesKeyRec(KeyBuffer).NType;
  if (Trim(TExchqChk_TransactionNotesKeyRec(KeyBuffer).LineNo) <> '') then
    KeyRec.LineNo := StrToInt('$' + TExchqChk_TransactionNotesKeyRec(KeyBuffer).LineNo)
  else
    KeyRec.LineNo := 0;
end;

// -----------------------------------------------------------------------------

function TTransactionNotesRedirector.KeyIsEmpty: Boolean;
begin
  Result := (KeyRec.Folio = 0);
end;

// -----------------------------------------------------------------------------

function TTransactionNotesRedirector.RedirectedCall(Operation: Word;
  IndexNumber: Integer; KeyLength: Integer; var DataLength: WORD; ClientID: pointer): LongInt;
begin
  Result := Open(ClientID);
  if IsOpen then
  begin
    DataLength := SizeOf(DataRec);
    if (ClientID = nil) then
      Result := BtrvSQLU.BTRCall(Operation, PosBlock, DataRec, DataLength,
                                 KeyRec, KeyLength, 0)
    else
      Result := BtrvSQLU.BTRCallID(Operation, PosBlock, DataRec, DataLength,
                                   KeyRec, KeyLength, 0, ClientID^);
  end;
end;

// -----------------------------------------------------------------------------

function TTransactionNotesRedirector.TranslateIndex(
  OriginalIndex: Integer): Integer;
begin
  Result := OriginalIndex;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TFinancialMatchingRedirector
// =============================================================================

constructor TFinancialMatchingRedirector.Create(ForPath: string);
begin
  inherited Create(ForPath);
  FPrefix  := 'T';
  FSubType := 'P';
  TableName := 'FinancialMatching.dat';
  RecordRange[0] := FINANCIAL_MATCHING_RANGE_START;
  RecordRange[1] := FINANCIAL_MATCHING_RANGE_END;
end;

// -----------------------------------------------------------------------------

procedure TFinancialMatchingRedirector.ExportFields(var DataBuffer;
  DataLength: Integer);
var
  PPassRec: ^PassWordRec;
  RecAddress: LongInt;
begin
  PPassRec := @DataBuffer;
  if (BaseOperation = B_GetPos) then
  begin
    // Offset the record address, so that a subsequent GetDirect can identify
    // the variant type to which it relates.
    Move(DataRec, RecAddress, 4);
    RecAddress := RecAddress + RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataBuffer, 4);
  end
  else
  begin
    // Copy the data buffer back to the variant record structure.
    PPassRec^.RecPfix := Prefix;
    PPassRec^.SubType := SubType;
    PPassRec^.MatchPayRec.DocCode    := DataRec.DocCode;
    PPassRec^.MatchPayRec.PayRef     := DataRec.PayRef;
    PPassRec^.MatchPayRec.SettledVal := DataRec.SettledVal;
    PPassRec^.MatchPayRec.OwnCVal    := DataRec.OwnCVal;
    PPassRec^.MatchPayRec.MCurrency  := DataRec.MCurrency;
    PPassRec^.MatchPayRec.MatchType  := DataRec.MatchType;
    PPassRec^.MatchPayRec.OldAltRef  := DataRec.OldAltRef;
    PPassRec^.MatchPayRec.RCurrency  := DataRec.RCurrency;
    PPassRec^.MatchPayRec.RecOwnCVal := DataRec.RecOwnCVal;
    PPassRec^.MatchPayRec.AltRef     := DataRec.AltRef;
  end;
end;

// -----------------------------------------------------------------------------

procedure TFinancialMatchingRedirector.ImportFields(var DataBuffer);
var
  PPassRec: ^PassWordRec;
  RecAddress: LongInt;
begin
  PPassRec := @DataBuffer;
  if (BaseOperation = B_GetDirect) or (BaseOperation = B_Unlock) then
  begin
    // Convert the offset record address into the actual record address.
    Move(DataBuffer, RecAddress, 4);
    RecAddress := RecAddress - RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataRec, 4);
  end
  else
  begin
    // Copy the variant record contents to the data buffer.
    DataRec.DocCode    := PPassRec^.MatchPayRec.DocCode;
    DataRec.PayRef     := PPassRec^.MatchPayRec.PayRef;
    DataRec.SettledVal := PPassRec^.MatchPayRec.SettledVal;
    DataRec.OwnCVal    := PPassRec^.MatchPayRec.OwnCVal;
    DataRec.MCurrency  := PPassRec^.MatchPayRec.MCurrency;
    DataRec.MatchType  := PPassRec^.MatchPayRec.MatchType;
    DataRec.OldAltRef  := PPassRec^.MatchPayRec.OldAltRef;
    DataRec.RCurrency  := PPassRec^.MatchPayRec.RCurrency;
    DataRec.RecOwnCVal := PPassRec^.MatchPayRec.RecOwnCVal;
    DataRec.AltRef     := PPassRec^.MatchPayRec.AltRef;
  end;
end;

// -----------------------------------------------------------------------------

function TFinancialMatchingRedirector.RedirectedCall(Operation: Word;
  IndexNumber, KeyLength: Integer; var DataLength: WORD; ClientID: pointer): LongInt;
begin
  Result := Open(ClientID);
  if IsOpen then
  begin
    DataLength := SizeOf(DataRec);
    if (ClientID = nil) then
      Result := BtrvSQLU.BTRCall(Operation, PosBlock, DataRec, DataLength,
                                 KeyBuffer[1], KeyLength, IndexNo)
    else
      Result := BtrvSQLU.BTRCallID(Operation, PosBlock, DataRec, DataLength,
                                   KeyBuffer[1], KeyLength, IndexNo,
                                   ClientID^);
  end;
end;

// -----------------------------------------------------------------------------

function TFinancialMatchingRedirector.TranslateIndex(
  OriginalIndex: Integer): Integer;
begin
  Result := OriginalIndex;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TCustomerDiscountRedirector
// =============================================================================

constructor TCustomerDiscountRedirector.Create(ForPath: string);
begin
  inherited Create(ForPath);
  FPrefix  := 'C';
  FSubType := 'C';
  TableName := 'CustomerDiscount.dat';
  RecordRange[0] := CUSTOMER_DISCOUNTS_RANGE_START;
  RecordRange[1] := CUSTOMER_DISCOUNTS_RANGE_END;
end;

// -----------------------------------------------------------------------------

procedure TCustomerDiscountRedirector.ExportFields(var DataBuffer;
  DataLength: Integer);

  // ...........................................................................
  // Copied from BtKeys1U.pas
  function MakeCDKey (CCode: Str10; SCode: Str20; QCurr: Byte): Str30;
  begin
    Result := FullCustCode(CCode) + FullStockCode(SCode) + Chr(QCurr);
  end;
  // ...........................................................................

var
  PMiscRec: MiscRecPtr;
  RecAddress: LongInt;
begin
  PMiscRec := @DataBuffer;
  if (BaseOperation = B_GetPos) then
  begin
    // Offset the record address, so that a subsequent GetDirect can identify
    // the variant type to which it relates.
    Move(DataRec, RecAddress, 4);
    RecAddress := RecAddress + RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataBuffer, 4);
  end
  else
  begin
    // Copy the data buffer back to the variant record structure.
    PMiscRec^.RecMfix := Prefix;
    PMiscRec^.SubType := SubType;
    PMiscRec^.CustDiscRec.DiscCode  := MakeCDKey(DataRec.CustCode, DataRec.StockCode, DataRec.Currency) + '!';
    PMiscRec^.CustDiscRec.QStkCode  := FullStockCode(DataRec.StockCode);
    PMiscRec^.CustDiscRec.DCCode    := FullCustCode(DataRec.CustCode);
    PMiscRec^.CustDiscRec.QBType    := DataRec.DiscountType;
    PMiscRec^.CustDiscRec.QBCurr    := DataRec.Currency;
    PMiscRec^.CustDiscRec.QSPrice   := DataRec.Price;
    PMiscRec^.CustDiscRec.QBand     := DataRec.Band;
    PMiscRec^.CustDiscRec.QDiscP    := DataRec.DiscountP;
    PMiscRec^.CustDiscRec.QDiscA    := DataRec.DiscountA;
    PMiscRec^.CustDiscRec.QMUMG     := DataRec.MarkUp;
    PMiscRec^.CustDiscRec.CUseDates := DataRec.UseDates;
    PMiscRec^.CustDiscRec.CStartD   := DataRec.StartDate;
    PMiscRec^.CustDiscRec.CEndD     := DataRec.EndDate;
    // CJS 2012-02-24 - v6.10 - ABSEXCH-9795
    PMiscRec^.CustDiscRec.QtyBreakFolio := DataRec.QtyBreakFolio;
  end;
end;

// -----------------------------------------------------------------------------

procedure TCustomerDiscountRedirector.ExportKeyBuffer(var KeyBuffer;
  KeyLength: Integer);
begin
  self.KeyBuffer := Prefix + SubType + Copy(self.KeyBuffer, 1, Pos(#0, self.KeyBuffer)) + '!';
  Move(self.KeyBuffer[1], KeyBuffer, Length(self.KeyBuffer));
end;

// -----------------------------------------------------------------------------

procedure TCustomerDiscountRedirector.ImportFields(var DataBuffer);
var
  PMiscRec: MiscRecPtr;
  RecAddress: LongInt;
begin
  PMiscRec := @DataBuffer;
  if (BaseOperation = B_GetDirect) or (BaseOperation = B_Unlock) then
  begin
    // Convert the offset record address into the actual record address.
    Move(DataBuffer, RecAddress, 4);
    RecAddress := RecAddress - RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataRec, 4);
  end
  else
  begin
    // Copy the variant record contents to the data buffer.
    DataRec.CustCode     := PMiscRec^.CustDiscRec.DCCode;
    DataRec.StockCode    := PMiscRec^.CustDiscRec.QStkCode;
    DataRec.Currency     := PMiscRec^.CustDiscRec.QBCurr;
    DataRec.DiscountType := PMiscRec^.CustDiscRec.QBType;
    DataRec.Price        := PMiscRec^.CustDiscRec.QSPrice;
    DataRec.Band         := PMiscRec^.CustDiscRec.QBand;
    DataRec.DiscountP    := PMiscRec^.CustDiscRec.QDiscP;
    DataRec.DiscountA    := PMiscRec^.CustDiscRec.QDiscA;
    DataRec.MarkUp       := PMiscRec^.CustDiscRec.QMUMG;
    DataRec.UseDates     := PMiscRec^.CustDiscRec.CUseDates;
    DataRec.StartDate    := PMiscRec^.CustDiscRec.CStartD;
    DataRec.EndDate      := PMiscRec^.CustDiscRec.CEndD;
    // CJS 2012-02-24 - v6.10 - ABSEXCH-9795
    DataRec.QtyBreakFolio:= PMiscRec^.CustDiscRec.QtyBreakFolio;
  end;
end;

// -----------------------------------------------------------------------------

function TCustomerDiscountRedirector.RedirectedCall(Operation: Word;
  IndexNumber, KeyLength: Integer; var DataLength: WORD; ClientID: pointer): LongInt;
begin
  Result := Open(ClientID);
  if IsOpen then
  begin
    DataLength := SizeOf(DataRec);
    if (ClientID = nil) then
      Result := BtrvSQLU.BTRCall(Operation, PosBlock, DataRec, DataLength,
                                 KeyBuffer[1], KeyLength, IndexNo)
    else
      Result := BtrvSQLU.BTRCallID(Operation, PosBlock, DataRec, DataLength,
                                   KeyBuffer[1], KeyLength, IndexNo,
                                   ClientID^);
  end;
end;

// -----------------------------------------------------------------------------

function TCustomerDiscountRedirector.TranslateIndex(
  OriginalIndex: Integer): Integer;
begin
  Result := OriginalIndex;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TCustomerStockAnalysisRedirector
// =============================================================================

constructor TCustomerStockAnalysisRedirector.Create(ForPath: string);
begin
  inherited;
  FPrefix := 'T';
  FSubType := 'P';
  TableName := 'CustomerStockAnalysis.dat';
  RecordRange[0] := CUSTOMER_STOCK_ANALYSIS_RANGE_START;
  RecordRange[1] := CUSTOMER_STOCK_ANALYSIS_RANGE_END;
end;

// -----------------------------------------------------------------------------

procedure TCustomerStockAnalysisRedirector.ExportFields(var DataBuffer;
  DataLength: Integer);
var
  PMLocRec: MLocPtr;
  RecAddress: LongInt;
  Buffer: array[1..1302] of Char absolute DataBuffer;
begin
  PMLocRec := @DataBuffer;
  if (BaseOperation = B_GetPos) then
  begin
    // Offset the record address, so that a subsequent GetDirect can identify
    // the variant type to which it relates.
    Move(DataRec, RecAddress, 4);
    RecAddress := RecAddress + RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataBuffer, 4);
  end
  else
  begin
    // Copy the data buffer back to the variant record structure.
    PMLocRec^.RecPfix := Prefix;
    PMLocRec^.SubType := SubType;
    PMLocRec^.CuStkRec.csCode1 := Full_CuStkLKey(DataRec.csCustCode, DataRec.csLineNo);
    PMLocRec^.CuStkRec.csCode2 := Full_CuStkKey(DataRec.csCustCode, DataRec.csStockCode);
    PMLocRec^.CuStkRec.csCode3 := Full_CuStkKey2(DataRec.csCustCode, DataRec.csStockCode);

    Move(DataRec.csCustCode, Buffer[BtKeyPos(@PMLocRec^.CuStkRec.csCustCode, @PMLocRec.CuStkRec ) + 2], SizeOf(DataRec) - (BtKeyPos(@DataRec.csCustCode, @DataRec) - 1));

  end;
end;

// -----------------------------------------------------------------------------

procedure TCustomerStockAnalysisRedirector.ImportFields(var DataBuffer);
var
  PMLocRec: MLocPtr;
  RecAddress: LongInt;
  Buffer: array[1..1302] of Char absolute DataBuffer;
begin
  PMLocRec := @DataBuffer;
  if (BaseOperation = B_GetDirect) or (BaseOperation = B_Unlock) then
  begin
    // Convert the offset record address into the actual record address.
    Move(DataBuffer, RecAddress, 4);
    RecAddress := RecAddress - RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataRec, 4);
  end
  else
  begin
    DataRec.csIndex := PMLocRec^.CuStkRec.csCode2;
    Move(Buffer[BtKeyPos(@PMLocRec^.CuStkRec.csCustCode, @PMLocRec.CuStkRec ) + 2], DataRec.csCustCode, SizeOf(DataRec) - (BtKeyPos(@DataRec.csCustCode, @DataRec) - 1));
  end;
end;

// -----------------------------------------------------------------------------

function TCustomerStockAnalysisRedirector.RedirectedCall(Operation: Word;
  IndexNumber, KeyLength: Integer; var DataLength: WORD;
  ClientID: pointer): LongInt;
begin
  Result := Open(ClientID);
  if IsOpen then
  begin
    DataLength := SizeOf(DataRec);
    if (ClientID = nil) then
      Result := BtrvSQLU.BTRCall(Operation, PosBlock, DataRec, DataLength,
                                 KeyBuffer[1], KeyLength, IndexNo)
    else
      Result := BtrvSQLU.BTRCallID(Operation, PosBlock, DataRec, DataLength,
                                   KeyBuffer[1], KeyLength, IndexNo,
                                   ClientID^);
  end;
end;

// -----------------------------------------------------------------------------

function TCustomerStockAnalysisRedirector.TranslateIndex(
  OriginalIndex: Integer): Integer;
begin
  Result := OriginalIndex;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TFiFoRedirector
// =============================================================================

constructor TFiFoRedirector.Create(ForPath: string);
begin
  inherited;
  FPrefix := 'F';
  FSubType := 'S';
  TableName := 'FiFo.dat';
  RecordRange[0] := FIFO_RANGE_START;
  RecordRange[1] := FIFO_RANGE_END;
end;

// -----------------------------------------------------------------------------

procedure TFiFoRedirector.ExportFields(var DataBuffer;
  DataLength: Integer);
var
  PMiscRec: MiscRecPtr;
  RecAddress: LongInt;
  Buffer: array[1..SizeOf(TFiFoRec)] of Char absolute DataBuffer;
begin
  PMiscRec := @DataBuffer;
  if (BaseOperation = B_GetPos) then
  begin
    // Offset the record address, so that a subsequent GetDirect can identify
    // the variant type to which it relates.
    Move(DataRec, RecAddress, 4);
    RecAddress := RecAddress + RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataBuffer, 4);
  end
  else
  begin
    // Copy the data buffer back to the variant record structure.
    PMiscRec^.RecMfix := Prefix;
    PMiscRec^.SubType := SubType;
    PMiscRec^.FIFORec.FIFOCode := MakeFIKey(DataRec.FIFOStkFolio, DataRec.FIFODate);
    PMiscRec^.FIFORec.DocFolioK := MakeFIDocKey(DataRec.FIFODocRef, DataRec.FIFOStkFolio, DataRec.FIFODocAbsNo);

    Move(DataRec, Buffer[BtKeyPos(@PMiscRec^.FIFORec.StkFolio, @PMiscRec^.FIFORec) + 2], SizeOf(DataRec));

  end;
end;

// -----------------------------------------------------------------------------

procedure TFiFoRedirector.ExportKeyBuffer(var KeyBuffer;
  KeyLength: Integer);
begin
  if IndexNo = 0 then
    inherited
  else
  begin
    Move(self.KeyBuffer[1], Key01Rec, SizeOf(Key01Rec));
    with TExStkChk_FiFoKey01Rec(KeyBuffer) do
    begin
      Prefix := FPrefix;
      SubType := FSubType;
      Move(Key01Rec.DocRef[1], DocRef[1], 9);
      StockFolio := Key01Rec.StockFolio;
      AbsLineNo := Key01Rec.AbsLineNo;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TFiFoRedirector.ImportFields(var DataBuffer);
var
  PMiscRec: MiscRecPtr;
  RecAddress: LongInt;
  Buffer: array[1..SizeOf(TFiFoRec)] of Char absolute DataBuffer;
begin
  PMiscRec := @DataBuffer;
  if (BaseOperation = B_GetDirect) or (BaseOperation = B_Unlock) then
  begin
    // Convert the offset record address into the actual record address.
    Move(DataBuffer, RecAddress, 4);
    RecAddress := RecAddress - RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataRec, 4);
  end
  else
  begin
    // Copy the variant record contents to the data buffer.
    Move(Buffer[BtKeyPos(@PMiscRec^.FIFORec.StkFolio, @PMiscRec^.FIFORec) + 2], DataRec, SizeOf(DataRec));
  end;
end;

// -----------------------------------------------------------------------------

procedure TFiFoRedirector.ImportKeyBuffer(var KeyBuffer;
  KeyLength: Integer);
begin
  if IndexNo = 0 then
    inherited
  else
  begin
    with TExStkChk_FiFoKey01Rec(KeyBuffer) do
    begin
      Move(DocRef[1], Key01Rec.DocRef[1], SizeOf(Key01Rec.DocRef) - 1);
      Key01Rec.DocRef[10] := #0;
      Key01Rec.StockFolio := StockFolio;
      Key01Rec.AbsLineNo := AbsLineNo;
    end;
    Move(Key01Rec, self.KeyBuffer[1], SizeOf(Key01Rec));
    self.KeyBuffer[0] := Chr(SizeOf(Key01Rec));
  end;
end;

// -----------------------------------------------------------------------------

function TFiFoRedirector.RedirectedCall(Operation: Word; IndexNumber,
  KeyLength: Integer; var DataLength: WORD; ClientID: pointer): LongInt;
begin
  Result := Open(ClientID);
  if IsOpen then
  begin
    DataLength := SizeOf(DataRec);
    if (ClientID = nil) then
      Result := BtrvSQLU.BTRCall(Operation, PosBlock, DataRec, DataLength,
                                 KeyBuffer[1], KeyLength, IndexNo)
    else
      Result := BtrvSQLU.BTRCallID(Operation, PosBlock, DataRec, DataLength,
                                   KeyBuffer[1], KeyLength, IndexNo,
                                   ClientID^);
  end;
end;

// -----------------------------------------------------------------------------

function TFiFoRedirector.TranslateIndex(OriginalIndex: Integer): Integer;
begin
  Result := OriginalIndex;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TSerialBatchRedirector
// =============================================================================

constructor TSerialBatchRedirector.Create(ForPath: string);
begin
  inherited;
  FPrefix := 'F';
  FSubType := 'R';
  TableName := 'SerialBatch.dat';
  RecordRange[0] := SERIAL_BATCH_RANGE_START;
  RecordRange[1] := SERIAL_BATCH_RANGE_END;
end;

// -----------------------------------------------------------------------------

procedure TSerialBatchRedirector.ExportFields(var DataBuffer;
  DataLength: Integer);
var
  PMiscRec: MiscRecPtr;
  RecAddress: LongInt;
  Buffer: array[1..SizeOf(TSerialBatchRec)] of Char absolute DataBuffer;
begin
  PMiscRec := @DataBuffer;
  if (BaseOperation = B_GetPos) then
  begin
    // Offset the record address, so that a subsequent GetDirect can identify
    // the variant type to which it relates.
    Move(DataRec, RecAddress, 4);
    RecAddress := RecAddress + RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataBuffer, 4);
  end
  else
  begin
    // Copy the data buffer back to the variant record structure.
    PMiscRec^.RecMfix := Prefix;
    PMiscRec^.SubType := SubType;
    PMiscRec^.SerialRec.SerialCode := MakeSNKey(DataRec.StockFolio,
                                                DataRec.Sold, DataRec.SerialNo);
    Move(DataRec.SerialNo, Buffer[BtKeyPos(@PMiscRec^.SerialRec.SerialNo, @PMiscRec^.SerialRec) + 2], SizeOf(DataRec) - (BtKeyPos(@DataRec.SerialNo, @DataRec) - 1));
  end;
end;

// -----------------------------------------------------------------------------

procedure TSerialBatchRedirector.ImportFields(var DataBuffer);
var
  PMiscRec: MiscRecPtr;
  RecAddress: LongInt;
  Buffer: array[1..SizeOf(TSerialBatchRec)] of Char absolute DataBuffer;
begin
  PMiscRec := @DataBuffer;
  if (BaseOperation = B_GetDirect) or (BaseOperation = B_Unlock) then
  begin
    // Convert the offset record address into the actual record address.
    Move(DataBuffer, RecAddress, 4);
    RecAddress := RecAddress - RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataRec, 4);
  end
  else
  begin
    // Copy the variant record contents to the data buffer.
    Move(Buffer[BtKeyPos(@PMiscRec^.SerialRec.SerialNo, @PMiscRec^.SerialRec) + 2], DataRec.SerialNo, SizeOf(DataRec) - (BtKeyPos(@DataRec.SerialNo, @DataRec) - 1));
  end;
end;

// -----------------------------------------------------------------------------

function TSerialBatchRedirector.RedirectedCall(Operation: Word;
  IndexNumber, KeyLength: Integer; var DataLength: WORD;
  ClientID: pointer): LongInt;
begin
  Result := Open(ClientID);
  if IsOpen then
  begin
    DataLength := SizeOf(DataRec);
    if (ClientID = nil) then
      Result := BtrvSQLU.BTRCall(Operation, PosBlock, DataRec, DataLength,
                                 KeyBuffer[1], KeyLength, IndexNo)
    else
      Result := BtrvSQLU.BTRCallID(Operation, PosBlock, DataRec, DataLength,
                                   KeyBuffer[1], KeyLength, IndexNo,
                                   ClientID^);
  end;
end;

// -----------------------------------------------------------------------------

function TSerialBatchRedirector.TranslateIndex(
  OriginalIndex: Integer): Integer;
begin
  Result := OriginalIndex;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TWindowSettingRedirector
// =============================================================================

constructor TWindowSettingRedirector.Create(ForPath: string);
begin
  inherited;
  FPrefix := 'U';
  FSubType := 'C';
  TableName := 'WindowSetting.dat';
  RecordRange[0] := WINDOW_SETTING_RANGE_START;
  RecordRange[1] := WINDOW_SETTING_RANGE_END;
end;

// -----------------------------------------------------------------------------

procedure TWindowSettingRedirector.ExportFields(var DataBuffer;
  DataLength: Integer);
var
  PMiscRec: MiscRecPtr;
  RecAddress: LongInt;
begin
  PMiscRec := @DataBuffer;
  if (BaseOperation = B_GetPos) then
  begin
    // Offset the record address, so that a subsequent GetDirect can identify
    // the variant type to which it relates.
    Move(DataRec, RecAddress, 4);
    RecAddress := RecAddress + RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataBuffer, 4);
  end
  else
  begin
    // Copy the data buffer back to the variant record structure.
    PMiscRec^.RecMfix := Prefix;
    PMiscRec^.SubType := SubType;
    PMiscRec^.btCustomRec.CustomKey    := FullCompoKey(Copy(DataRec.FormID + DataRec.ComponentName, 1, 10), DataRec.UserName);
    PMiscRec^.btCustomRec.UserKey      := FullCompoKey(DataRec.Username, Copy(DataRec.FormID + DataRec.ComponentName, 1, 10));
    PMiscRec^.btCustomRec.BkgColor     := DataRec.BkgColor;
    PMiscRec^.btCustomRec.FontName     := DataRec.FontName;
    PMiscRec^.btCustomRec.FontSize     := DataRec.FontSize;
    PMiscRec^.btCustomRec.FontColor    := DataRec.FontColor;
    PMiscRec^.btCustomRec.FontStyle    := DataRec.FontStyle;
    PMiscRec^.btCustomRec.FontPitch    := DataRec.FontPitch;
    PMiscRec^.btCustomRec.FontHeight   := DataRec.FontHeight;
    PMiscRec^.btCustomRec.LastColOrder := DataRec.LastColOrder;
    PMiscRec^.btCustomRec.Position     := DataRec.Position;
    PMiscRec^.btCustomRec.CompName     := DataRec.FormID + DataRec.ComponentName;
    PMiscRec^.btCustomRec.UserName     := DataRec.UserName;
    PMiscRec^.btCustomRec.HighLight    := DataRec.HighLight;
    PMiscRec^.btCustomRec.HighText     := DataRec.HighText;
  end;
end;

// -----------------------------------------------------------------------------

procedure TWindowSettingRedirector.ImportFields(var DataBuffer);
var
  PMiscRec: MiscRecPtr;
  RecAddress: LongInt;
begin
  PMiscRec := @DataBuffer;
  if (BaseOperation = B_GetDirect) or (BaseOperation = B_Unlock) then
  begin
    // Convert the offset record address into the actual record address.
    Move(DataBuffer, RecAddress, 4);
    RecAddress := RecAddress - RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataRec, 4);
  end
  else
  begin
    // Copy the variant record contents to the data buffer.
    DataRec.BkgColor             := PMiscRec^.btCustomRec.BkgColor;
    DataRec.FontName             := PMiscRec^.btCustomRec.FontName;
    DataRec.FontSize             := PMiscRec^.btCustomRec.FontSize;
    DataRec.FontColor            := PMiscRec^.btCustomRec.FontColor;
    DataRec.FontStyle            := PMiscRec^.btCustomRec.FontStyle;
    DataRec.FontPitch            := PMiscRec^.btCustomRec.FontPitch;
    DataRec.FontHeight           := PMiscRec^.btCustomRec.FontHeight;
    DataRec.LastColOrder         := PMiscRec^.btCustomRec.LastColOrder;
    DataRec.Position             := PMiscRec^.btCustomRec.Position;
    DataRec.FormID               := PMiscRec^.btCustomRec.CompName[1];
    DataRec.ComponentName        := Copy(PMiscRec^.btCustomRec.CompName, 2, 63);
    DataRec.IndexedComponentName := LJVar(DataRec.ComponentName, 9);
    DataRec.UserName             := LJVar(PMiscRec^.btCustomRec.UserName, 10);
    DataRec.HighLight            := PMiscRec^.btCustomRec.HighLight;
    DataRec.HighText             := PMiscRec^.btCustomRec.HighText;
  end;
end;

// -----------------------------------------------------------------------------

function TWindowSettingRedirector.RedirectedCall(Operation: Word;
  IndexNumber, KeyLength: Integer; var DataLength: WORD;
  ClientID: pointer): LongInt;
begin
  Result := Open(ClientID);
  if IsOpen then
  begin
    DataLength := SizeOf(DataRec);
    if (ClientID = nil) then
      Result := BtrvSQLU.BTRCall(Operation, PosBlock, DataRec, DataLength,
                                 KeyBuffer[1], KeyLength, IndexNo)
    else
      Result := BtrvSQLU.BTRCallID(Operation, PosBlock, DataRec, DataLength,
                                   KeyBuffer[1], KeyLength, IndexNo,
                                   ClientID^);
  end;
end;

// -----------------------------------------------------------------------------

function TWindowSettingRedirector.TranslateIndex(
  OriginalIndex: Integer): Integer;
begin
  Result := OriginalIndex;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TLocationRedirector
// =============================================================================

constructor TLocationRedirector.Create(ForPath: string);
begin
  inherited;
  FPrefix := 'C';
  FSubType := 'C';
  TableName := 'Location.dat';
  RecordRange[0] := LOCATION_RANGE_START;
  RecordRange[1] := LOCATION_RANGE_END;
end;

// -----------------------------------------------------------------------------

procedure TLocationRedirector.ExportFields(var DataBuffer;
  DataLength: Integer);
var
  PMLocRec: MLocPtr;
  RecAddress: LongInt;
  Buffer: array[1..SizeOf(TLocationRec)] of Char absolute DataBuffer;
begin
  PMLocRec := @DataBuffer;
  if (BaseOperation = B_GetPos) then
  begin
    // Offset the record address, so that a subsequent GetDirect can identify
    // the variant type to which it relates.
    Move(DataRec, RecAddress, 4);
    RecAddress := RecAddress + RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataBuffer, 4);
  end
  else
  begin
    // Copy the data buffer back to the variant record structure.
    PMLocRec^.RecPfix := Prefix;
    PMLocRec^.SubType := SubType;
    PMLocRec^.MLocLoc.loCode := DataRec.loCode;
    PMLocRec^.MLocLoc.loName := DataRec.loName;
    Move(DataRec.loAddr, Buffer[BtKeyPos(@PMLocRec^.MLocLoc.loAddr, @PMLocRec^.MLocLoc) + 2], SizeOf(DataRec) - (BtKeyPos(@DataRec.loAddr, @DataRec) - 1));
  end;
end;

// -----------------------------------------------------------------------------

procedure TLocationRedirector.ImportFields(var DataBuffer);
var
  PMLocRec: MLocPtr;
  RecAddress: LongInt;
  Buffer: array[1..SizeOf(TLocationRec)] of Char absolute DataBuffer;
begin
  PMLocRec := @DataBuffer;
  FillChar(DataRec, SizeOf(DataRec), 0);
  if (BaseOperation = B_GetDirect) or (BaseOperation = B_Unlock) then
  begin
    // Convert the offset record address into the actual record address.
    Move(DataBuffer, RecAddress, 4);
    RecAddress := RecAddress - RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataRec, 4);
  end
  else
  begin
    DataRec.loCode := PMLocRec^.MLocLoc.loCode;
    DataRec.loName := PMLocRec^.MLocLoc.loName;
    // Copy the variant record contents to the data buffer.
    Move(Buffer[BtKeyPos(@PMLocRec^.MLocLoc.loAddr, @PMLocRec^.MLocLoc) + 2], DataRec.loAddr, SizeOf(DataRec) - (BtKeyPos(@DataRec.loAddr, @DataRec) - 1));
  end;
end;

// -----------------------------------------------------------------------------

function TLocationRedirector.RedirectedCall(Operation: Word; IndexNumber,
  KeyLength: Integer; var DataLength: WORD; ClientID: pointer): LongInt;
begin
  Result := Open(ClientID);
  if IsOpen then
  begin
    DataLength := SizeOf(DataRec);
    if (ClientID = nil) then
      Result := BtrvSQLU.BTRCall(Operation, PosBlock, DataRec, DataLength,
                                 KeyBuffer[1], KeyLength, IndexNo)
    else
      Result := BtrvSQLU.BTRCallID(Operation, PosBlock, DataRec, DataLength,
                                   KeyBuffer[1], KeyLength, IndexNo,
                                   ClientID^);
  end;
end;

// -----------------------------------------------------------------------------

function TLocationRedirector.TranslateIndex(
  OriginalIndex: Integer): Integer;
begin
  Result := OriginalIndex;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TStockLocationRedirector
// =============================================================================

constructor TStockLocationRedirector.Create(ForPath: string);
begin
  inherited;
  FPrefix := 'C';
  FSubType := 'D';
  TableName := 'StockLocation.dat';
  RecordRange[0] := STOCK_LOCATION_RANGE_START;
  RecordRange[1] := STOCK_LOCATION_RANGE_END;
end;

// -----------------------------------------------------------------------------

procedure TStockLocationRedirector.ExportFields(var DataBuffer;
  DataLength: Integer);
var
  PMLocRec: MLocPtr;
  RecAddress: LongInt;
  Buffer: array[1..SizeOf(TStockLocationRec)] of Char absolute DataBuffer;
begin
  PMLocRec := @DataBuffer;
  if (BaseOperation = B_GetPos) then
  begin
    // Offset the record address, so that a subsequent GetDirect can identify
    // the variant type to which it relates.
    Move(DataRec, RecAddress, 4);
    RecAddress := RecAddress + RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataBuffer, 4);
  end
  else
  begin
    // Copy the data buffer back to the variant record structure.
    PMLocRec^.RecPfix := Prefix;
    PMLocRec^.SubType := SubType;
    PMLocRec^.MStkLoc.lsCode1 := Full_MLocSKey(DataRec.lsLocCode, DataRec.lsStkCode);
    PMLocRec^.MStkLoc.lsCode2 := Full_MLocLKey(DataRec.lsLocCode, DataRec.lsStkCode);
    Move(DataRec, Buffer[BtKeyPos(@PMLocRec^.MStkLoc.lsStkCode, @PMLocRec^.MStkLoc) + 2], SizeOf(DataRec));
  end;
end;

// -----------------------------------------------------------------------------

procedure TStockLocationRedirector.ImportFields(var DataBuffer);
var
  PMLocRec: MLocPtr;
  RecAddress: LongInt;
  Buffer: array[1..SizeOf(TStockLocationRec)] of Char absolute DataBuffer;
begin
  PMLocRec := @DataBuffer;
  FillChar(DataRec, SizeOf(DataRec), 0);
  if (BaseOperation = B_GetDirect) or (BaseOperation = B_Unlock) then
  begin
    // Convert the offset record address into the actual record address.
    Move(DataBuffer, RecAddress, 4);
    RecAddress := RecAddress - RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataRec, 4);
  end
  else
  begin
    // Copy the variant record contents to the data buffer.
    Move(Buffer[BtKeyPos(@PMLocRec^.MStkLoc.lsStkCode, @PMLocRec^.MStkLoc) + 2], DataRec, SizeOf(DataRec));
  end;
end;

// -----------------------------------------------------------------------------

function TStockLocationRedirector.RedirectedCall(Operation: Word;
  IndexNumber, KeyLength: Integer; var DataLength: WORD;
  ClientID: pointer): LongInt;
begin
  Result := Open(ClientID);
  if IsOpen then
  begin
    DataLength := SizeOf(DataRec);
    if (ClientID = nil) then
      Result := BtrvSQLU.BTRCall(Operation, PosBlock, DataRec, DataLength,
                                 KeyBuffer[1], KeyLength, IndexNo)
    else
      Result := BtrvSQLU.BTRCallID(Operation, PosBlock, DataRec, DataLength,
                                   KeyBuffer[1], KeyLength, IndexNo,
                                   ClientID^);
  end;
end;

// -----------------------------------------------------------------------------

function TStockLocationRedirector.TranslateIndex(
  OriginalIndex: Integer): Integer;
begin
  Result := OriginalIndex;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TAllocWizardSessionRedirector
// =============================================================================

constructor TAllocWizardSessionRedirector.Create(ForPath: string);
begin
  inherited;
  FPrefix := 'X';
  FSubType := 'C';
  TableName := 'AllocWizardSession.dat';
  RecordRange[0] := ALLOC_WIZARD_SESSION_RANGE_START;
  RecordRange[1] := ALLOC_WIZARD_SESSION_RANGE_END;
end;

// -----------------------------------------------------------------------------

procedure TAllocWizardSessionRedirector.ExportFields(var DataBuffer;
  DataLength: Integer);
var
  PMLocRec: MLocPtr;
  RecAddress: LongInt;
begin
  PMLocRec := @DataBuffer;
  if (BaseOperation = B_GetPos) then
  begin
    // Offset the record address, so that a subsequent GetDirect can identify
    // the variant type to which it relates.
    Move(DataRec, RecAddress, 4);
    RecAddress := RecAddress + RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataBuffer, 4);
  end
  else
  begin
    // Copy the data buffer back to the variant record structure.
    PMLocRec^.RecPfix := Prefix;
    PMLocRec^.SubType := SubType;
    PMLocRec^.AllocCRec.arcCode1   := DataRec.arcCustSupp + DataRec.arcCustCode;
    PMLocRec^.AllocCRec.arcCode2   := '';
    PMLocRec^.AllocCRec.arcCode3   := '';
    PMLocRec^.AllocCRec.arcBankNom := DataRec.arcBankNom;
    PMLocRec^.AllocCRec.arcCtrlNom := DataRec.arcCtrlNom;
    PMLocRec^.AllocCRec.arcPayCurr := DataRec.arcPayCurr;
    PMLocRec^.AllocCRec.arcInvCurr := DataRec.arcInvCurr;
    { - Skip Spare field - }
    PMLocRec^.AllocCRec.arcCCDep      := DataRec.arcCCDep;
    PMLocRec^.AllocCRec.arcSortBy     := DataRec.arcSortBy;
    PMLocRec^.AllocCRec.arcAutoTotal  := DataRec.arcAutoTotal;
    PMLocRec^.AllocCRec.arcSDDaysOver := DataRec.arcSDDaysOver;
    PMLocRec^.AllocCRec.arcFromTrans  := DataRec.arcFromTrans;
    PMLocRec^.AllocCRec.arcOldYourRef := DataRec.arcOldYourRef;
    PMLocRec^.AllocCRec.arcChequeNo2  := DataRec.arcChequeNo2;
    { - Skip Spare field - }
    PMLocRec^.AllocCRec.arcForceNew   := DataRec.arcForceNew;
    PMLocRec^.AllocCRec.arcSort2By    := DataRec.arcSort2By;
    PMLocRec^.AllocCRec.arcTotalOwn   := DataRec.arcTotalOwn;
    PMLocRec^.AllocCRec.arcTransValue := DataRec.arcTransValue;
    PMLocRec^.AllocCRec.arcTagCount   := DataRec.arcTagCount;
    PMLocRec^.AllocCRec.arcTagRunDate := DataRec.arcTagRunDate;
    PMLocRec^.AllocCRec.arcTagRunYr   := DataRec.arcTagRunYr;
    PMLocRec^.AllocCRec.arcTagRunPr   := DataRec.arcTagRunPr;
    PMLocRec^.AllocCRec.arcSRCPIRef   := DataRec.arcSRCPIRef;
    PMLocRec^.AllocCRec.arcIncSDisc   := DataRec.arcIncSDisc;
    PMLocRec^.AllocCRec.arcTotal      := DataRec.arcTotal;
    PMLocRec^.AllocCRec.arcVariance   := DataRec.arcVariance;
    PMLocRec^.AllocCRec.arcSettleD    := DataRec.arcSettleD;
    PMLocRec^.AllocCRec.arcTransDate  := DataRec.arcTransDate;
    PMLocRec^.AllocCRec.arcUD1        := DataRec.arcUD1;
    PMLocRec^.AllocCRec.arcUD2        := DataRec.arcUD2;
    PMLocRec^.AllocCRec.arcUD3        := DataRec.arcUD3;
    PMLocRec^.AllocCRec.arcUD4        := DataRec.arcUD4;
    PMLocRec^.AllocCRec.arcJobCode    := DataRec.arcJobCode;
    PMLocRec^.AllocCRec.arcAnalCode   := DataRec.arcAnalCode;
    PMLocRec^.AllocCRec.arcDelAddr    := DataRec.arcPayDetails;
    PMLocRec^.AllocCRec.arcIncVar     := DataRec.arcIncVar;
    PMLocRec^.AllocCRec.arcOurRef     := DataRec.arcOurRef;
    PMLocRec^.AllocCRec.arcCxRate     := DataRec.arcCxRate;
    PMLocRec^.AllocCRec.arcOpoName    := DataRec.arcOpoName;
    PMLocRec^.AllocCRec.arcStartDate  := DataRec.arcStartDate;
    PMLocRec^.AllocCRec.arcStartTime  := DataRec.arcStartTime;
    PMLocRec^.AllocCRec.arcWinLogIn   := DataRec.arcWinLogIn;
    PMLocRec^.AllocCRec.arcLocked     := DataRec.arcLocked;
    PMLocRec^.AllocCRec.arcSalesMode  := DataRec.arcSalesMode;
    PMLocRec^.AllocCRec.arcCustCode   := DataRec.arcCustCode;
    PMLocRec^.AllocCRec.arcUseOSNdx   := DataRec.arcUseOSNdx;
    PMLocRec^.AllocCRec.arcOwnTransValue := DataRec.arcOwnTransValue;
    PMLocRec^.AllocCRec.arcOwnSettleD := DataRec.arcOwnSettleD;
    PMLocRec^.AllocCRec.arcFinVar     := DataRec.arcFinVar;
    PMLocRec^.AllocCRec.arcFinSetD    := DataRec.arcFinSetD;
    PMLocRec^.AllocCRec.arcSortD      := DataRec.arcSortD;
    { - Skip spare field - }
    PMLocRec^.AllocCRec.arcAllocFull  := DataRec.arcAllocFull;
    PMLocRec^.AllocCRec.arcCheckFail  := DataRec.arcCheckFail;
    PMLocRec^.AllocCRec.arcCharge1GL  := DataRec.arcCharge1GL;
    PMLocRec^.AllocCRec.arcCharge2GL  := DataRec.arcCharge2GL;
    PMLocRec^.AllocCRec.arcCharge1Amt := DataRec.arcCharge1Amt;
    PMLocRec^.AllocCRec.arcCharge2Amt := DataRec.arcCharge2Amt;
    { - Skip spare field - }
    PMLocRec^.AllocCRec.arcYourRef    := DataRec.arcYourRef;
    PMLocRec^.AllocCRec.arcUD5        := DataRec.arcUD5;
    PMLocRec^.AllocCRec.arcUD6        := DataRec.arcUD6;
    PMLocRec^.AllocCRec.arcUD7        := DataRec.arcUD7;
    PMLocRec^.AllocCRec.arcUD8        := DataRec.arcUD8;
    PMLocRec^.AllocCRec.arcUD9        := DataRec.arcUD9;
    PMLocRec^.AllocCRec.arcUD10       := DataRec.arcUD10;
    PMLocRec^.AllocCRec.arcUsePPD     := DataRec.arcUsePPD;
  end;
end;

// -----------------------------------------------------------------------------

procedure TAllocWizardSessionRedirector.ImportFields(var DataBuffer);
var
  PMLocRec: MLocPtr;
  RecAddress: LongInt;
begin
  PMLocRec := @DataBuffer;
  FillChar(DataRec, SizeOf(DataRec), 0);
  if (BaseOperation = B_GetDirect) or (BaseOperation = B_Unlock) then
  begin
    // Convert the offset record address into the actual record address.
    Move(DataBuffer, RecAddress, 4);
    RecAddress := RecAddress - RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataRec, 4);
  end
  else
  begin
    // Copy the variant record contents to the data buffer.
    DataRec.arcCustSupp     := PMLocRec^.AllocCRec.arcCode1[1];
    DataRec.arcCustCode     := Copy(PMLocRec^.AllocCRec.arcCode1, 2, 6);
    DataRec.arcBankNom      := PMLocRec^.AllocCRec.arcBankNom;
    DataRec.arcCtrlNom      := PMLocRec^.AllocCRec.arcCtrlNom;
    DataRec.arcPayCurr      := PMLocRec^.AllocCRec.arcPayCurr;
    DataRec.arcInvCurr      := PMLocRec^.AllocCRec.arcInvCurr;
    { - Skip Spare field - }
    DataRec.arcCCDep        := PMLocRec^.AllocCRec.arcCCDep;
    DataRec.arcSortBy       := PMLocRec^.AllocCRec.arcSortBy;
    DataRec.arcAutoTotal    := PMLocRec^.AllocCRec.arcAutoTotal;
    DataRec.arcSDDaysOver   := PMLocRec^.AllocCRec.arcSDDaysOver;
    DataRec.arcFromTrans    := PMLocRec^.AllocCRec.arcFromTrans;
    DataRec.arcOldYourRef   := PMLocRec^.AllocCRec.arcOldYourRef;
    DataRec.arcChequeNo2    := PMLocRec^.AllocCRec.arcChequeNo2;
    { - Skip Spare field - }
    DataRec.arcForceNew     := PMLocRec^.AllocCRec.arcForceNew;
    DataRec.arcSort2By      := PMLocRec^.AllocCRec.arcSort2By;
    DataRec.arcTotalOwn     := PMLocRec^.AllocCRec.arcTotalOwn;
    DataRec.arcTransValue   := PMLocRec^.AllocCRec.arcTransValue;
    DataRec.arcTagCount     := PMLocRec^.AllocCRec.arcTagCount;
    DataRec.arcTagRunDate   := PMLocRec^.AllocCRec.arcTagRunDate;
    DataRec.arcTagRunYr     := PMLocRec^.AllocCRec.arcTagRunYr;
    DataRec.arcTagRunPr     := PMLocRec^.AllocCRec.arcTagRunPr;
    DataRec.arcSRCPIRef     := PMLocRec^.AllocCRec.arcSRCPIRef;
    DataRec.arcIncSDisc     := PMLocRec^.AllocCRec.arcIncSDisc;
    DataRec.arcTotal        := PMLocRec^.AllocCRec.arcTotal;
    DataRec.arcVariance     := PMLocRec^.AllocCRec.arcVariance;
    DataRec.arcSettleD      := PMLocRec^.AllocCRec.arcSettleD;
    DataRec.arcTransDate    := PMLocRec^.AllocCRec.arcTransDate;
    DataRec.arcUD1          := PMLocRec^.AllocCRec.arcUD1;
    DataRec.arcUD2          := PMLocRec^.AllocCRec.arcUD2;
    DataRec.arcUD3          := PMLocRec^.AllocCRec.arcUD3;
    DataRec.arcUD4          := PMLocRec^.AllocCRec.arcUD4;
    DataRec.arcJobCode      := PMLocRec^.AllocCRec.arcJobCode;
    DataRec.arcAnalCode     := PMLocRec^.AllocCRec.arcAnalCode;
    DataRec.arcPayDetails   := PMLocRec^.AllocCRec.arcDelAddr;
    DataRec.arcIncVar       := PMLocRec^.AllocCRec.arcIncVar;
    DataRec.arcOurRef       := PMLocRec^.AllocCRec.arcOurRef;
    DataRec.arcCxRate       := PMLocRec^.AllocCRec.arcCxRate;
    DataRec.arcOpoName      := PMLocRec^.AllocCRec.arcOpoName;
    DataRec.arcStartDate    := PMLocRec^.AllocCRec.arcStartDate;
    DataRec.arcStartTime    := PMLocRec^.AllocCRec.arcStartTime;
    DataRec.arcWinLogIn     := PMLocRec^.AllocCRec.arcWinLogIn;
    DataRec.arcLocked       := PMLocRec^.AllocCRec.arcLocked;
    DataRec.arcSalesMode    := PMLocRec^.AllocCRec.arcSalesMode;
    DataRec.arcUseOSNdx     := PMLocRec^.AllocCRec.arcUseOSNdx;
    DataRec.arcOwnTransValue:= PMLocRec^.AllocCRec.arcOwnTransValue;
    DataRec.arcOwnSettleD   := PMLocRec^.AllocCRec.arcOwnSettleD;
    DataRec.arcFinVar       := PMLocRec^.AllocCRec.arcFinVar;
    DataRec.arcFinSetD      := PMLocRec^.AllocCRec.arcFinSetD;
    DataRec.arcSortD        := PMLocRec^.AllocCRec.arcSortD;
    { - Skip spare field - }
    DataRec.arcAllocFull    := PMLocRec^.AllocCRec.arcAllocFull;
    DataRec.arcCheckFail    := PMLocRec^.AllocCRec.arcCheckFail;
    DataRec.arcCharge1GL    := PMLocRec^.AllocCRec.arcCharge1GL;
    DataRec.arcCharge2GL    := PMLocRec^.AllocCRec.arcCharge2GL;
    DataRec.arcCharge1Amt   := PMLocRec^.AllocCRec.arcCharge1Amt;
    DataRec.arcCharge2Amt   := PMLocRec^.AllocCRec.arcCharge2Amt;
    { - Skip spare field - }
    DataRec.arcYourRef      := PMLocRec^.AllocCRec.arcYourRef;
    DataRec.arcUD5          := PMLocRec^.AllocCRec.arcUD5;
    DataRec.arcUD6          := PMLocRec^.AllocCRec.arcUD6;
    DataRec.arcUD7          := PMLocRec^.AllocCRec.arcUD7;
    DataRec.arcUD8          := PMLocRec^.AllocCRec.arcUD8;
    DataRec.arcUD9          := PMLocRec^.AllocCRec.arcUD9;
    DataRec.arcUD10         := PMLocRec^.AllocCRec.arcUD10;
    DataRec.arcUsePPD       := PMLocRec^.AllocCRec.arcUsePPD;
  end;
end;

// -----------------------------------------------------------------------------

function TAllocWizardSessionRedirector.RedirectedCall(Operation: Word;
  IndexNumber, KeyLength: Integer; var DataLength: WORD;
  ClientID: pointer): LongInt;
begin
  Result := Open(ClientID);
  if IsOpen then
  begin
    DataLength := SizeOf(DataRec);
    if (ClientID = nil) then
      Result := BtrvSQLU.BTRCall(Operation, PosBlock, DataRec, DataLength,
                                 KeyBuffer[1], KeyLength, IndexNo)
    else
      Result := BtrvSQLU.BTRCallID(Operation, PosBlock, DataRec, DataLength,
                                   KeyBuffer[1], KeyLength, IndexNo,
                                   ClientID^);
  end;
end;

// -----------------------------------------------------------------------------

function TAllocWizardSessionRedirector.TranslateIndex(
  OriginalIndex: Integer): Integer;
begin
  Result := OriginalIndex;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TAnalysisCodeBudgetRedirector
// =============================================================================

constructor TAnalysisCodeBudgetRedirector.Create(ForPath: string);
begin
  inherited;
  FPrefix := 'J';
  FSubType := 'B';
  TableName := 'AnalysisCodeBudget.dat';
  RecordRange[0] := ANALYSIS_CODE_BUDGET_RANGE_START;
  RecordRange[1] := ANALYSIS_CODE_BUDGET_RANGE_END;
end;

// -----------------------------------------------------------------------------

procedure TAnalysisCodeBudgetRedirector.ExportFields(var DataBuffer;
  DataLength: Integer);
var
  PJobCtrlRec: JobCtrlPtr;
  RecAddress: LongInt;
  Buffer: array[1..SizeOf(TStockLocationRec)] of Char absolute DataBuffer;
begin
  PJobCtrlRec := @DataBuffer;
  if (BaseOperation = B_GetPos) then
  begin
    // Offset the record address, so that a subsequent GetDirect can identify
    // the variant type to which it relates.
    Move(DataRec, RecAddress, 4);
    RecAddress := RecAddress + RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataBuffer, 4);
  end
  else
  begin
    // Copy the data buffer back to the variant record structure.
    PJobCtrlRec^.RecPfix := Prefix;
    PJobCtrlRec^.SubType := SubType;
    PJobCtrlRec^.JobBudg.BudgetCode := FullJBCode(DataRec.JobCode, DataRec.CurrBudg, DataRec.AnalysisCode);
    PJobCtrlRec^.JobBudg.Code2NDX := FullJBDDKey(DataRec.JobCode, DataRec.AnalHed);
    Move(DataRec, Buffer[BtKeyPos(@PJobCtrlRec^.JobBudg.AnalCode, @PJobCtrlRec^.JobBudg) + 2], SizeOf(DataRec));
  end;
end;

// -----------------------------------------------------------------------------

procedure TAnalysisCodeBudgetRedirector.ExportKeyBuffer(var KeyBuffer;
  KeyLength: Integer);
var
  IndexCode: string[30];
  JobCode: string[10];
  AnalysisCode: string[10];
begin
  if (IndexNo = 1) then
    inherited
  else
  begin
    Move(self.KeyBuffer[1], JobCode[1], SizeOf(JobCode) - 1);
    JobCode[0] := Char(SizeOf(JobCode) - 1);
    Move(self.KeyBuffer[11], AnalysisCode[1], SizeOf(AnalysisCode) - 1);
    AnalysisCode[0] := Char(SizeOf(AnalysisCode) - 1);
    // Note: Key string is only 27 characters, but FullJBCode returns 30.
    IndexCode := FPrefix + FSubType + FullJBCode(JobCode, DataRec.CurrBudg, AnalysisCode);
    Move(IndexCode[1], KeyBuffer, SizeOf(IndexCode) - 1);
  end;
end;

// -----------------------------------------------------------------------------

procedure TAnalysisCodeBudgetRedirector.ImportFields(var DataBuffer);
var
  PJobCtrlRec: JobCtrlPtr;
  RecAddress: LongInt;
  Buffer: array[1..SizeOf(TJobBudgetRec)] of Char absolute DataBuffer;
begin
  PJobCtrlRec := @DataBuffer;
  FillChar(DataRec, SizeOf(DataRec), 0);
  if (BaseOperation = B_GetDirect) or (BaseOperation = B_Unlock) then
  begin
    // Convert the offset record address into the actual record address.
    Move(DataBuffer, RecAddress, 4);
    RecAddress := RecAddress - RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataRec, 4);
  end
  else
  begin
    // Copy the variant record contents to the data buffer.
    Move(Buffer[BtKeyPos(@PJobCtrlRec^.JobBudg.AnalCode, @PJobCtrlRec^.JobBudg) + 2], DataRec, SizeOf(DataRec));
  end;
end;

// -----------------------------------------------------------------------------

procedure TAnalysisCodeBudgetRedirector.ImportKeyBuffer(var KeyBuffer;
  KeyLength: Integer);
var
  Buffer: array[1..29] of Char absolute KeyBuffer;
  JobCode: string[10];
  AnalysisCode: string[10];
begin
  if (IndexNo = 1) then
    inherited
  else
  begin
    Move(Buffer[3], JobCode[1], SizeOf(JobCode) - 1);
    JobCode[0] := Char(SizeOf(JobCode) - 1);
    Move(Buffer[13], AnalysisCode[1], SizeOf(AnalysisCode) - 1);
    AnalysisCode[0] := Char(SizeOf(AnalysisCode) - 1);
    self.KeyBuffer := JobCode + AnalysisCode + #0;
  end;
end;

// -----------------------------------------------------------------------------

function TAnalysisCodeBudgetRedirector.RedirectedCall(Operation: Word;
  IndexNumber, KeyLength: Integer; var DataLength: WORD;
  ClientID: pointer): LongInt;
begin
  Result := Open(ClientID);
  if IsOpen then
  begin
    DataLength := SizeOf(DataRec);
    if (ClientID = nil) then
      Result := BtrvSQLU.BTRCall(Operation, PosBlock, DataRec, DataLength,
                                 KeyBuffer[1], KeyLength, IndexNo)
    else
      Result := BtrvSQLU.BTRCallID(Operation, PosBlock, DataRec, DataLength,
                                   KeyBuffer[1], KeyLength, IndexNo,
                                   ClientID^);
  end;
end;

// -----------------------------------------------------------------------------

function TAnalysisCodeBudgetRedirector.TranslateIndex(
  OriginalIndex: Integer): Integer;
begin
  Result := OriginalIndex;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TJobTotalsBudgetRedirector
// =============================================================================

constructor TJobTotalsBudgetRedirector.Create(ForPath: string);
begin
  inherited;
  FPrefix := 'J';
  FSubType := 'M';
  TableName := 'JobTotalsBudget.dat';
  RecordRange[0] := JOB_TOTALS_BUDGET_RANGE_START;
  RecordRange[1] := JOB_TOTALS_BUDGET_RANGE_END;
end;

// -----------------------------------------------------------------------------

procedure TJobTotalsBudgetRedirector.ExportKeyBuffer(var KeyBuffer;
  KeyLength: Integer);
var
  IndexCode: string[30];
  JobCode: string[10];
  HistFolio: string[4];
begin
  if (IndexNo = 1) then
    inherited
  else
  begin
    Move(self.KeyBuffer[1], JobCode[1], SizeOf(JobCode) - 1);
    JobCode[0] := Char(SizeOf(JobCode) - 1);
    Move(self.KeyBuffer[11], HistFolio[1], SizeOf(HistFolio) - 1);
    HistFolio[0] := Char(SizeOf(HistFolio) - 1);
    // Note: Key string is only 27 characters, but FullJBCode returns 30.
    IndexCode := FPrefix + FSubType + FullJBCode(JobCode, DataRec.CurrBudg, HistFolio);
    Move(IndexCode[1], KeyBuffer, SizeOf(IndexCode) - 1);
  end;
end;

// -----------------------------------------------------------------------------

procedure TJobTotalsBudgetRedirector.ImportKeyBuffer(var KeyBuffer;
  KeyLength: Integer);
var
  Buffer: array[1..28] of Char absolute KeyBuffer;
  JobCode: string[10];
  HistFolio: string[4];
begin
  if (IndexNo = 1) then
    inherited
  else
  begin
    Move(Buffer[3], JobCode[1], SizeOf(JobCode) - 1);
    JobCode[0] := Char(SizeOf(JobCode) - 1);
    Move(Buffer[13], HistFolio[1], SizeOf(HistFolio) - 1);
    HistFolio[0] := Char(SizeOf(HistFolio) - 1);
    self.KeyBuffer := JobCode + HistFolio + #0;
  end;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TOrderPaymentsMatchingRedirector
// =============================================================================

constructor TOrderPaymentsMatchingRedirector.Create(ForPath: string);
begin
  inherited Create(ForPath);
  FPrefix  := 'T';
  FSubType := 'R';
  TableName := 'OrderPaymentsMatching.dat';
  RecordRange[0] := ORDER_PAYMENTS_MATCHING_RANGE_START;
  RecordRange[1] := ORDER_PAYMENTS_MATCHING_RANGE_END;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsMatchingRedirector.ExportFields(var DataBuffer;
  DataLength: Integer);
var
  PPassRec: ^PassWordRec;
  RecAddress: LongInt;
begin
  PPassRec := @DataBuffer;
  if (BaseOperation = B_GetPos) then
  begin
    // Offset the record address, so that a subsequent GetDirect can identify
    // the variant type to which it relates.
    Move(DataRec, RecAddress, 4);
    RecAddress := RecAddress + RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataBuffer, 4);
  end
  else
  begin
    // Copy the data buffer back to the variant record structure.
    PPassRec^.RecPfix := Prefix;
    PPassRec^.SubType := SubType;
    PPassRec^.MatchPayRec.DocCode    := DataRec.DocCode;
    PPassRec^.MatchPayRec.PayRef     := DataRec.PayRef;
    PPassRec^.MatchPayRec.SettledVal := DataRec.SettledVal;
    PPassRec^.MatchPayRec.OwnCVal    := DataRec.OwnCVal;
    PPassRec^.MatchPayRec.MCurrency  := DataRec.MCurrency;
    PPassRec^.MatchPayRec.MatchType  := DataRec.MatchType;
    PPassRec^.MatchPayRec.OldAltRef  := DataRec.OldAltRef;
    PPassRec^.MatchPayRec.RCurrency  := DataRec.RCurrency;
    PPassRec^.MatchPayRec.RecOwnCVal := DataRec.RecOwnCVal;
    PPassRec^.MatchPayRec.AltRef     := DataRec.AltRef;
  end;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsMatchingRedirector.ImportFields(var DataBuffer);
var
  PPassRec: ^PassWordRec;
  RecAddress: LongInt;
begin
  PPassRec := @DataBuffer;
  if (BaseOperation = B_GetDirect) or (BaseOperation = B_Unlock) then
  begin
    // Convert the offset record address into the actual record address.
    Move(DataBuffer, RecAddress, 4);
    RecAddress := RecAddress - RecordRange[MIN_REC_ADDRESS];
    Move(RecAddress, DataRec, 4);
  end
  else
  begin
    // Copy the variant record contents to the data buffer.
    DataRec.DocCode    := PPassRec^.MatchPayRec.DocCode;
    DataRec.PayRef     := PPassRec^.MatchPayRec.PayRef;
    DataRec.SettledVal := PPassRec^.MatchPayRec.SettledVal;
    DataRec.OwnCVal    := PPassRec^.MatchPayRec.OwnCVal;
    DataRec.MCurrency  := PPassRec^.MatchPayRec.MCurrency;
    DataRec.MatchType  := PPassRec^.MatchPayRec.MatchType;
    DataRec.OldAltRef  := PPassRec^.MatchPayRec.OldAltRef;
    DataRec.RCurrency  := PPassRec^.MatchPayRec.RCurrency;
    DataRec.RecOwnCVal := PPassRec^.MatchPayRec.RecOwnCVal;
    DataRec.AltRef     := PPassRec^.MatchPayRec.AltRef;
  end;
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsMatchingRedirector.RedirectedCall(Operation: Word;
  IndexNumber, KeyLength: Integer; var DataLength: WORD;
  ClientID: pointer): LongInt;
begin
  Result := Open(ClientID);
  if IsOpen then
  begin
    DataLength := SizeOf(DataRec);
    if (ClientID = nil) then
      Result := BtrvSQLU.BTRCall(Operation, PosBlock, DataRec, DataLength,
                                 KeyBuffer[1], KeyLength, IndexNo)
    else
      Result := BtrvSQLU.BTRCallID(Operation, PosBlock, DataRec, DataLength,
                                   KeyBuffer[1], KeyLength, IndexNo,
                                   ClientID^);
  end;
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsMatchingRedirector.TranslateIndex(
  OriginalIndex: Integer): Integer;
begin
  Result := OriginalIndex;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TSQLRedirectorCache
// =============================================================================

procedure TSQLRedirectorCache.Clear;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
  begin
    TSQLRedirector(FList[i]).Close;
    TSQLRedirector(FList[i]).Free;
    FList[i] := nil;
  end;
end;

// -----------------------------------------------------------------------------

constructor TSQLRedirectorCache.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

// -----------------------------------------------------------------------------

destructor TSQLRedirectorCache.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited;
end;

// -----------------------------------------------------------------------------

function TSQLRedirectorCache.GetRedirector(Prefix,
  SubType: Char): TSQLRedirector;
var
  i: Integer;
begin
  Result := nil;
  i := IndexOf(Prefix, SubType);
  if (i <> -1) then
    Result := TSQLRedirector(FList[i]);
end;

// -----------------------------------------------------------------------------

function TSQLRedirectorCache.IndexOf(Prefix, SubType: Char): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to FList.Count - 1 do
  begin
    if (TSQLRedirector(FList[i]).Prefix = Prefix) and
       (TSQLRedirector(FList[i]).SubType = SubType) then
    begin
      Result := i;
      break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TSQLRedirectorCache.PrefixForRecordAddress(RecAddress: Integer;
  FileName: string; var Prefix, SubType: Char): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := Low(RecordRanges) to High(RecordRanges) do
  begin
    if (RecordRanges[i].FileName = FileName) and
       (RecordRanges[i].Range[MIN_REC_ADDRESS] <= RecAddress) and
       (RecordRanges[i].Range[MAX_REC_ADDRESS] >= RecAddress) then
    begin
      Prefix := RecordRanges[i].Prefix;
      SubType := RecordRanges[i].SubType;
      Result := True;
      break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TSQLRedirectorCache.RedirectorForRecordAddress(
  RecAddress: Integer): TSQLRedirector;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FList.Count - 1 do
  begin
    if (TSQLRedirector(FList[i]).RecordRange[MIN_REC_ADDRESS] <= RecAddress) and
       (TSQLRedirector(FList[i]).RecordRange[MAX_REC_ADDRESS] >= RecAddress) then
    begin
      Result := TSQLRedirector(FList[i]);
      break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLRedirectorCache.SetRedirector(Prefix, SubType: Char;
  const Value: TSQLRedirector);
begin
  if (IndexOf(Prefix, SubType) = -1) then
    FList.Add(Value);
end;

// -----------------------------------------------------------------------------

Procedure Finalize_SQLRedirectorU;
Begin // Finalize_SQLRedirectorU
  if Assigned(FRedirectorFactory) then
    FreeAndNil(FRedirectorFactory);
End; // Finalize_SQLRedirectorU

initialization

finalization
// MH 15/03/2010 v6.3: Moved into Finalize_SQLRedirectorU as getting problems with order of finalizations
//  if Assigned(FRedirectorFactory) then
//    FreeAndNil(FRedirectorFactory);

end.
