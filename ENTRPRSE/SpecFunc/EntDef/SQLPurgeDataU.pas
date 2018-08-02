unit SQLPurgeDataU;

interface

uses SysUtils, ADODB, DB, VarConst, SQLCallerU, SQLUtils, SFHeaderU,ExchConnect;

const
  // The progress bar is divided into equal-sized segments, one for each Purge
  // area. This is an attempt to make the progress at least minimally sensible.
  ProgressSegment: Integer = 1000;

type
  { Exception handler }
  ESQLPurge = class(Exception)
  public
    { Constructor, taking a description of the context in which the error
      occurred, and the relevant Btrieve error-code. For non-database errors
      use the default constructor.

      This formats the error message, adding the SQL error information if
      available. The details are written to the log. }
    constructor CreateAs(const Context: string; ErrorCode: Integer);
  end;

  { Record to hold input parameters (equivalent of Purge_OrdRec in the
    original Pervasive version, but holding additional information). }
  TSQLPurgeInfo = record
    Year: Integer;
    Period: Integer;
    PurgeCustomers: Boolean;
    PurgeSuppliers: Boolean;
    PurgeStock: Boolean;
    PurgeLocations: Boolean;
    PurgeSerial: Boolean;
    RecordsScanned: LongInt;
    RecordsProcessed: LongInt;
    OptionCount: Integer;
    Progress: TSFProgressBar;
  end;
  PSQLPurgeInfo = ^TSQLPurgeInfo;

  { Base class for purging the data from one area of the system. }
  TSQLPurgeData = class(TObject)
  protected
    // Main SQL query, set by PrepareSQL()
    FSQL: string;
    // SQL Caller for scanning the main records
    FSQLCaller: TSQLCaller;
    // SQL Caller for performing deletions of related records
    FSQLDelete: TSQLCaller;
    // Basic error message to use in the event of errors. Operation-specific
    // messages will be added to the end of this.
    FErrorMsg: string;
    // Count of the number of records deleted from related tables
    FRelatedDeletionsCount: Integer;
    FInfo: PSQLPurgeInfo;
    FCompanyCode: string;
    FConnection: TExchConnection;
    FTitle: string;
    // Fix up the Progress Bar position (basically rounding it up to the next
    // value)
    procedure FinishProgress;
    // Sets up the SQL query in FSQL. Must be overridden.
    procedure PrepareSQL; virtual; abstract;
    // Error-handler, raising an ESQLPurge exception with the supplied details
    procedure RaiseError(const Context: string; ErrorCode: Integer = 0);
    // Returns the character at the specified position in the string, or the
    // default character if the position is out of range.
    function SafeCharFromString(Str: string; Position: Integer; DefaultChr: Char = ' '): Char;
    // Sets the Title to display in the information label on the main form, and
    // updates the label
    procedure SetTitle(Value: string);
    // Runs a specified query, updating the record count values in FInfo
    procedure RunQuery(Caller: TSQLCaller; Qry: string; ErrorMsg: string);
  public
    property Title: string read FTitle write SetTitle;
    constructor Create(Info: PSQLPurgeInfo; Connection: TExchConnection); virtual;
    destructor Destroy; override;
    function Process: Boolean; virtual;
  end;

  { Class for purging Transactions and related records in other tables. }
  TSQLPurgeTransactions = class(TSQLPurgeData)
  private
    // Pointers to field objects returned from query.
    fldCustSupp: TStringField;
    fldAcCode: TStringField;
    fldNomAuto: TBooleanField;
    fldFolioNum: TIntegerField;
    fldRunNo: TIntegerField;
    fldDocType: TIntegerField;
    fldControlGL: TIntegerField;
    fldYear: TIntegerField;
    fldPeriod: TIntegerField;
    fldCurrency: TIntegerField;
    fldRemitNo: TStringField;
    fldSettledVAT: TFloatField;
    fldVATPostDate: TStringField;
    fldUntilDate: TStringField;
    fldDueDate: TStringField;

    { CJS 2012-08-15 - ABSEXCH-13240 - Transactions not being deleted }
    fldAmountSettled: TFloatField;

    fldCurrSettled: TFloatField;
    fldOurRef: TStringField;
    fldCompanyRate: TFloatField;
    fldDailyRate: TFloatField;
    fldOutstanding: TStringField;
    fldTotalOrderOS: TFloatField;
    fldTotalCost: TFloatField;
    fldTotalOrdered: TFloatField;
    fldDeliveryNoteRef: TStringField;
    fldNetValue: TFloatField;
    fldTotalVAT: TFloatField;
    fldTotalLineDiscount: TFloatField;
    fldVariance: TFloatField;
    fldRevalueAdj: TFloatField;
    fldSettleDiscAmount: TFloatField;
    fldSettleDiscTaken: TBooleanField;
    fldPostDiscAm: TFloatField;
    fldPositionId: TIntegerField;
    // Reads the pointers to the fields returned from the SQL recordset
    procedure PrepareFields;
    // Creates the SQL query
    procedure PrepareSQL; override;
    // Deletes related records in other tables
    procedure PurgeLines;
    procedure PurgeMatching;
    procedure PurgeNotes;
    procedure PurgeLinks;
    // Reads the values from the record returned from SQL into the Inv global
    // record.
    procedure ReadRecord(var InvR: InvRec);
  public
    function Process: Boolean; override;
  end;

  { Class for purging Pay-in Lines. }
  TSQLPurgePayinLines = class(TSQLPurgeData)
  private
    procedure PrepareSQL; override;
  public
    function Process: Boolean; override;
  end;

  { Class for purging Run Control Lines. }
  TSQLPurgeRunLines = class(TSQLPurgeData)
  private
    procedure PrepareSQL; override;
  public
    function Process: Boolean; override;
  end;

  { Class for making a backup of the History table, for any future unpost }
  TSQLPurgeHistory = class(TSQLPurgeData)
  private
    procedure PrepareSQL; override;
  public
    function Process: Boolean; override;
  end;

  { Class for purging Customer/Supplier records, and related records in other
    tables. }
  TSQLPurgeTraders = class(TSQLPurgeData)
  private
    // Pointers to field objects returned from stored procedure.
    fldCustSupp: TStringField;
    fldAcCode: TStringField;
    procedure PrepareFields;
    procedure PrepareSQL; override;
    procedure PurgeNotes;
    procedure PurgeDiscounts;
    procedure PurgeLinks;
    procedure PurgeTelesalesAnalysis;
    procedure PurgeHistory;
  public
    function Process: Boolean; override;
  end;

  { Class for purging Stock records, and related records in other tables. }
  TSQLPurgeStock = class(TSQLPurgeData)
  private
    // Pointers to field objects returned by SQL record set.
    fldStCode: TStringField;
    fldStAltCode: TStringField;
    fldStFolioNum: TIntegerField;
    fldStParentCode: TStringField;
    fldStType: TStringField;
    fldStQtyInStock: TFloatField;
    function CanBeDeleted: Boolean;
    procedure PrepareFields;
    procedure PrepareSQL; override;
    procedure PurgeNotes;
    procedure PurgeBOM;
    procedure PurgeDiscounts;
    procedure PurgeStockLocations;
    procedure PurgeFIFO;
    procedure PurgeAltStock;
    procedure PurgeSerialNumbers;
    procedure PurgeBinRecords;
    procedure PurgeLinks;
    procedure PurgeAnalysisRecords;
    procedure PurgePostedHistory;
    procedure PurgeLocationHistory;
    procedure PurgeSalesHistory;
    procedure PurgeLocationSalesHistory;
  public
    function Process: Boolean; override;
  end;

  { Class for purging unused Location records }
  TSQLPurgeLocations = class(TSQLPurgeData)
  private
    // Pointers to field objects returned by SQL record set.
    fldLoCode: TStringField;
    procedure PrepareFields;
    procedure PrepareSQL; override;
    procedure PurgeNotes;
  public
    function Process: Boolean; override;
  end;

  { Class for purging unused Serial Number records }
  TSQLPurgeSerialNumbers = class(TSQLPurgeData)
  private
    // Pointers to field objects returned by SQL record set.
    fldSerialNo: TStringField;
    fldNoteFolio: TIntegerField;
    procedure PrepareFields;
    procedure PrepareSQL; override;
    procedure PurgeNotes;
  public
    function Process: Boolean; override;
  end;

{ Main entry point, called from Purge_Control() in Purge1U.pas. Requires a
  pointer to the Info structure containing the parameters for the Purge. }
procedure SQLPurgeData(Info: PSQLPurgeInfo);

implementation

uses DateUtils, Forms, Dialogs, GlobVar, VarFPosU, ComCtrls, ETMiscU, ReBuld1U, ReBuld2U, ProgU;

{ Simplistic Timer class for basic performance testing }
type
  TTimer = class(TObject)
  private
    FOperation: string;
    FStartTime: TDateTime;
    FStopTime: TDateTime;
    function GetDuration: LongInt;
    function GetReport: string;
  public
    procedure Start(Operation: string);
    procedure Stop;
    property Duration: LongInt read GetDuration;
    property Operation: string read FOperation;
    property Report: string read GetReport;
  end;

var
  gTimer: TTimer;

// =============================================================================
// TTimer
// =============================================================================

function Timer: TTimer;
begin
  if not Assigned(gTimer) then
    gTimer := TTimer.Create;
  Result := gTimer;
end;

function TTimer.GetReport: string;
begin
  Result := Format(FOperation + ': %d', [Duration]);
end;

function TTimer.GetDuration: LongInt;
begin
  if FStopTime > 0 then
    Result := MillisecondsBetween(FStartTime, FStopTime)
  else
    Result := MillisecondsBetween(FStartTime, Now);
end;

procedure TTimer.Start(Operation: string);
begin
  FOperation := Operation;
  FStartTime := Now;
  FStopTime  := 0;
end;

procedure TTimer.Stop;
begin
  FStopTime := Now;
end;

// =============================================================================

procedure SQLPurgeData(Info: PSQLPurgeInfo);
var
  Purge: TSQLPurgeData;
  Connection: TExchConnection;  //SS:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  ConnectionString,
  lPassword: WideString;
  CompanyCode: string;
begin
  // Prepare the main connection (the same connection is used for all the
  // different Purge objects).
  Connection := TExchConnection.Create(nil);
  CompanyCode := SQLUtils.GetCompanyCode(SetDrive);
  //SQLUtils.GetConnectionString(CompanyCode, False, ConnectionString);
  
  //SS:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  SQLUtils.GetConnectionStringWOPass(CompanyCode, False, ConnectionString, lPassword);
  Connection.ConnectionString := ConnectionString;
  Connection.Password := lPassword;
  // Count the number of Purge options that are included. This will be used for
  // setting the progress bar.
  Info.OptionCount := 4 +
                      Ord(Info.PurgeCustomers) +
                      Ord(Info.PurgeSuppliers) +
                      Ord(Info.PurgeStock) +
                      Ord(Info.PurgeLocations) +
                      Ord(Info.PurgeSerial);
  Connection.Open;
  Info.Progress.InfoLbl.Caption := '';

  try
    // Transactions
    Purge := TSQLPurgeTransactions.Create(Info, Connection);
    Purge.Title := 'Purging Transactions';
    Purge.Process;
    FreeAndNil(Purge);

    // Pay-in Lines
    if not Info.Progress.Aborted then
    begin
      Purge := TSQLPurgePayinLines.Create(Info, Connection);
      Purge.Title := 'Purging Pay-in Lines';
      Purge.Process;
      FreeAndNil(Purge);
    end;

    // Run Control Lines
    if not Info.Progress.Aborted then
    begin
      Purge := TSQLPurgeRunLines.Create(Info, Connection);
      Purge.Title := 'Purging Run Control Lines';
      Purge.Process;
      FreeAndNil(Purge);
    end;

    // History
    if not Info.Progress.Aborted then
    begin
      Purge := TSQLPurgeHistory.Create(Info, Connection);
      Purge.Title := 'Copying History';
      Purge.Process;
      FreeAndNil(Purge);
    end;

    // Customers/Suppliers
    if not Info.Progress.Aborted then
    begin
      if (Info.PurgeCustomers) or (Info.PurgeSuppliers) then
      begin
        Purge := TSQLPurgeTraders.Create(Info, Connection);
        Purge.Process;
        FreeAndNil(Purge);
      end;
    end;

    // Stock
    if not Info.Progress.Aborted then
    begin
      if (Info.PurgeStock) then
      begin
        Purge := TSQLPurgeStock.Create(Info, Connection);
        Purge.Title := 'Purging Stock';
        Purge.Process;
        FreeAndNil(Purge);
        if (Info.PurgeLocations) then
        begin
          Purge := TSQLPurgeLocations.Create(Info, Connection);
          Purge.Title := 'Purging Locations';
          Purge.Process;
          FreeAndNil(Purge);
        end;
        if (Info.PurgeSerial) then
        begin
          Purge := TSQLPurgeSerialNumbers.Create(Info, Connection);
          Purge.Title := 'Purging Serial Numbers';
          Purge.Process;
          FreeAndNil(Purge);
        end;
      end;
    end;
    if not Info.Progress.Aborted then
    begin
      // Set the Purge Year
      Syss.AuditYr := Info.Year;
      PutMultiSys(SysR,BOn);
    end;
  except
    on E:Exception do
    begin
      ShowMessage(E.Message);
      Info.Progress.Aborted := True;
    end;
  end;

end;

// =============================================================================
// ESQLPurge
// =============================================================================

constructor ESQLPurge.CreateAs(const Context: string; ErrorCode: Integer);
var
  Msg: string;
begin
  if (ErrorCode = 0) then
    Msg := Context
  else if (ErrorCode = -1) then
  begin
    // ErrorCode -1 is a general SQL error returned from SQLUtils.ExecSQL()
    Msg := Context + ', error: ' + SQLUtils.LastSQLError;
  end
  else
    Msg := Format(Context + ', error %d', [ErrorCode]);
  Write_FixMsgFmt(Msg, 4);
  inherited Create(Msg);
end;

// =============================================================================
// TSQLPurgeData
// =============================================================================

constructor TSQLPurgeData.Create(Info: PSQLPurgeInfo; Connection: TExchConnection);
begin
  inherited Create;
  FConnection  := Connection;
  FSQLCaller   := TSQLCaller.Create(FConnection);
  FSQLDelete   := TSQLCaller.Create(FConnection);
  FInfo        := Info;
  FCompanyCode := SQLUtils.GetCompanyCode(SetDrive);
end;

// -----------------------------------------------------------------------------

destructor TSQLPurgeData.Destroy;
begin
  FSQLDelete.Free;
  FSQLCaller.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeData.FinishProgress;
var
  Pos: Integer;
begin
  Pos := FInfo.Progress.ProgressBar1.Position div ProgressSegment;
  Pos := (Pos + 1) * ProgressSegment;
  FInfo.Progress.ProgressBar1.Position := Pos;
end;

// -----------------------------------------------------------------------------

function TSQLPurgeData.Process: Boolean;
begin
  PrepareSQL;
  RunQuery(FSQLCaller, FSQL, FErrorMsg);
  FinishProgress;
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeData.RaiseError(const Context: string;
  ErrorCode: Integer);
begin
  raise ESQLPurge.CreateAs(Context, ErrorCode);
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeData.RunQuery(Caller: TSQLCaller; Qry: string; ErrorMsg: string);
var
  RecordCount: Integer;
begin
  RecordCount := Caller.ExecSQL(Qry, FCompanyCode);
  if (RecordCount = -1) then
  begin
    RaiseError(ErrorMsg + ': ' + Caller.ErrorMsg);
  end;
  FInfo.RecordsScanned := FInfo.RecordsScanned + Caller.LastRecordCount;
  FInfo.RecordsProcessed := FInfo.RecordsProcessed + Caller.LastRecordCount;
  FRelatedDeletionsCount := FRelatedDeletionsCount + Caller.LastRecordCount;
end;

// -----------------------------------------------------------------------------

function TSQLPurgeData.SafeCharFromString(Str: string;
  Position: Integer; DefaultChr: Char): Char;
begin
  if (Position > Length(Str)) then
    Result := DefaultChr
  else
    Result := Str[Position];
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeData.SetTitle(Value: string);
begin
  FTitle := Value;
  FInfo.Progress.InfoLbl.Caption := Trim(FInfo.Progress.InfoLbl.Caption + #13#10 + FTitle);
  Application.ProcessMessages;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TSQLPurgeTransactions
// =============================================================================

procedure TSQLPurgeTransactions.PrepareFields;
begin
  fldCustSupp          := FSQLCaller.Records.FieldByName('thCustSupp') as TStringField;
  fldAcCode            := FSQLCaller.Records.FieldByName('thAcCode') as TStringField;
  fldNomAuto           := FSQLCaller.Records.FieldByName('thNomAuto') as TBooleanField;
  fldFolioNum          := FSQLCaller.Records.FieldByName('thFolioNum') as TIntegerField;
  fldRunNo             := FSQLCaller.Records.FieldByName('thRunNo') as TIntegerField;
  fldDocType           := FSQLCaller.Records.FieldByName('thDocType') as TIntegerField;
  fldControlGL         := FSQLCaller.Records.FieldByName('thControlGL') as TIntegerField;
  fldYear              := FSQLCaller.Records.FieldByName('thYear') as TIntegerField;
  fldPeriod            := FSQLCaller.Records.FieldByName('thPeriod') as TIntegerField;
  fldCurrency          := FSQLCaller.Records.FieldByName('thCurrency') as TIntegerField;
  fldRemitNo           := FSQLCaller.Records.FieldByName('thRemitNo') as TStringField;
  fldSettledVAT        := FSQLCaller.Records.FieldByName('thSettledVAT') as TFloatField;
  fldVATPostDate       := FSQLCaller.Records.FieldByName('thVATPostDate') as TStringField;
  fldUntilDate         := FSQLCaller.Records.FieldByName('thUntilDate') as TStringField;
  fldDueDate           := FSQLCaller.Records.FieldByName('thDueDate') as TStringField;

  { CJS 2012-08-15 - ABSEXCH-13240 - Transactions not being deleted }
  fldAmountSettled     := FSQLCaller.Records.FieldByName('thAmountSettled') as TFloatField;

  fldCurrSettled       := FSQLCaller.Records.FieldByName('thCurrSettled') as TFloatField;
  fldOurRef            := FSQLCaller.Records.FieldByName('thOurRef') as TStringField;
  fldCompanyRate       := FSQLCaller.Records.FieldByName('thCompanyRate') as TFloatField;
  fldDailyRate         := FSQLCaller.Records.FieldByName('thDailyRate') as TFloatField;
  fldOutstanding       := FSQLCaller.Records.FieldByName('thOutstanding') as TStringField;
  fldTotalOrderOS      := FSQLCaller.Records.FieldByName('thTotalOrderOS') as TFloatField;
  fldTotalCost         := FSQLCaller.Records.FieldByName('thTotalCost') as TFloatField;
  fldTotalOrdered      := FSQLCaller.Records.FieldByName('thTotalOrdered') as TFloatField;
  fldDeliveryNoteRef   := FSQLCaller.Records.FieldByName('thDeliveryNoteRef') as TStringField;
  fldNetValue          := FSQLCaller.Records.FieldByName('thNetValue') as TFloatField;
  fldTotalVAT          := FSQLCaller.Records.FieldByName('thTotalVAT') as TFloatField;
  fldTotalLineDiscount := FSQLCaller.Records.FieldByName('thTotalLineDiscount') as TFloatField;
  fldVariance          := FSQLCaller.Records.FieldByName('thVariance') as TFloatField;
  fldRevalueAdj        := FSQLCaller.Records.FieldByName('thRevalueAdj') as TFloatField;
  fldSettleDiscAmount  := FSQLCaller.Records.FieldByName('thSettleDiscAmount') as TFloatField;
  fldSettleDiscTaken   := FSQLCaller.Records.FieldByName('thSettleDiscTaken') as TBooleanField;
  fldPostDiscAm        := FSQLCaller.Records.FieldByName('PostDiscAm') as TFloatField;
  fldPositionId        := FSQLCaller.Records.FieldByName('PositionId') as TIntegerField;
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeTransactions.PrepareSQL;
const
  IncludeRunNumbers: array[0..5] of Integer = (StkAdjRunNo, TSTPostRunNo, OrdUSRunNo, OrdUPRunNo, BatchPostRunNo, BatchRunNo);
var
  ValidRunNumbers: string;
  i: Integer;
  ConnectionString: string;
begin
  // Build a list of the additional (negative) Run numbers that should be
  // included in the Purge (Run Numbers greater than or equal to zero will
  // automatically be included).
  ValidRunNumbers := IntToStr(IncludeRunNumbers[0]);
  for i := 1 to High(IncludeRunNumbers) do
    ValidRunNumbers := ValidRunNumbers + ', ' + IntToStr(IncludeRunNumbers[i]);

  { CJS 2012-08-15 - ABSEXCH-13240 - Transactions not being deleted. Added
                                     thAmountSettled field. }
  FSQL := Format(
           'SELECT ' +
           '  thCustSupp,         ' +
           '  thAcCode,           ' +
           '  thNomAuto,          ' +
           '  thFolioNum,         ' +
           '  thRunNo,            ' +
           '  thDocType,          ' +
           '  thControlGL,        ' +
           '  thYear,             ' +
           '  thPeriod,           ' +
           '  thCurrency,         ' +
           '  thRemitNo,          ' +
           '  thSettledVAT,       ' +
           '  thVATPostDate,      ' +
           '  thUntilDate,        ' +
           '  thDueDate,          ' +
           '  thAmountSettled,    ' +
           '  thCurrSettled,      ' +
           '  thOurRef,           ' +
           '  thCompanyRate,      ' +
           '  thDailyRate,        ' +
           '  thOutstanding,      ' +
           '  thTotalOrderOS,     ' +
           '  thTotalCost,        ' +
           '  thTotalOrdered,     ' +
           '  thDeliveryNoteRef,  ' +
           '  thNetValue,         ' +
           '  thTotalVAT,         ' +
           '  thTotalLineDiscount,' +
           '  thVariance,         ' +
           '  thRevalueAdj,       ' +
           '  thSettleDiscAmount, ' +
           '  thSettleDiscTaken,  ' +
           '  PostDiscAm,         ' +
           '  PositionId          ' +
           'FROM [COMPANY].DOCUMENT ' +
           'WHERE (' +
           '  ((thRunNo >= 0) OR      ' +
           '   (thRunNo in (%s))) AND ' +
           '  ((thYear < %d) OR ((thYear = %d) AND (thPeriod <= %d))) ' +
           ')',
           [ValidRunNumbers, FInfo.Year, FInfo.Year, FInfo.Period]
         );
end;

// -----------------------------------------------------------------------------

function TSQLPurgeTransactions.Process: Boolean;
var
  RecordCount: Integer;
  SQLDeleteQry: string;
  ProgressPerRecord: Double;
  Progress: Double;
  DeletedCount: Integer;
begin
  // Set up the SQL call
  PrepareSQL;
  FSQLCaller.Select(FSQL, FCompanyCode);
  if FSQLCaller.ErrorMsg <> '' then
  begin
    RaiseError('Error retrieving transactions: ' + FSQLCaller.ErrorMsg);
  end
  else if FSQLCaller.Records.RecordCount > 0 then
  begin
    DeletedCount := 0;
    FRelatedDeletionsCount := 0;
    // Attempt to set the Progress Bar to something plausible
    FInfo.Progress.ProgressBar1.Max := FInfo.OptionCount * ProgressSegment;
    ProgressPerRecord := ProgressSegment / FSQLCaller.Records.RecordCount;
    Progress := 0;
    PrepareFields;

    // Locate all the transactions that should be purged
    while (not FSQLCaller.Records.Eof) and (not FInfo.Progress.Aborted) do
    begin
      // FInfo.Progress.InfoLbl.Caption := 'Checking ' + fldOurRef.Value;
      Progress := Progress + ProgressPerRecord;
      FInfo.Progress.ProgressBar1.Position := Trunc(Progress);
      Application.ProcessMessages;

      FInfo.RecordsScanned := FInfo.RecordsScanned + 1;

      // For each relevant Transaction:
      ReadRecord(Inv);
      if (not (Inv.InvDocHed in SalesSplit + PurchSplit)) or
         ((Round_up(BaseTotalOs(Inv), 2) = 0.0) or
         (Inv.RunNo = 0)) then
      begin
        // Purge the related records from other tables
        PurgeLines;
        PurgeNotes;
        PurgeLinks;

        // Delete the Transaction record itself
        SQLDeleteQry := 'DELETE FROM [COMPANY].DOCUMENT WHERE thFolioNum = ' +
                        IntToStr(fldFolioNum.Value);
        RecordCount := FSQLDelete.ExecSQL(SQLDeleteQry, FCompanyCode);
        if (RecordCount = -1) then
        begin
          RaiseError('Error purging transactions: ' + FSQLDelete.ErrorMsg);
        end;
        DeletedCount := DeletedCount + 1;
        FInfo.RecordsProcessed := FInfo.RecordsProcessed + 1;
      end;
      FSQLCaller.Records.Next;
    end;
    if (FRelatedDeletionsCount > 0) then
      Write_FixMsgFmt('Deleted ' + IntToStr(DeletedCount) + ' Transactions ' +
                      '+ ' + IntToStr(FRelatedDeletionsCount) + ' related records', 3)
    else
      Write_FixMsgFmt('Deleted ' + IntToStr(DeletedCount) + ' Transactions', 3);
  end;
  FSQLCaller.Close;
  // Delete all the Matching records for which the Transactions no longer exist
  if (not FInfo.Progress.Aborted) then
  begin
    PurgeMatching;
    // Fix up the progress bar position
    FinishProgress;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeTransactions.PurgeLines;
var
  Qry: string;
begin
  // Delete all the Transaction Lines which are linked to the current
  // Transaction
  Qry := 'DELETE FROM [COMPANY].DETAILS ' +
         'WHERE tlFolioNum = ' + IntToStr(fldFolioNum.Value);
  RunQuery(FSQLDelete, Qry, 'Error purging Transaction Lines');
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeTransactions.PurgeLinks;
var
  Qry: string;
begin
  // Delete all the Link records for the current Transaction
  Qry := 'DELETE FROM [COMPANY].EXSTKCHK ' +
         'WHERE (RecMfix = ''W'') AND (SubType = ''T'') AND ' +
         'CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(CONVERT(VARBINARY(4), exstchkvar1),2,4))) AS INTEGER) = ' + IntToStr(fldFolioNum.Value);
  RunQuery(FSQLDelete, Qry, 'Error purging Transaction links');
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeTransactions.PurgeMatching;
var
  Qry: string;
begin
  // Delete all the Financial Matching records which point to Transactions
  // which have now been deleted
  Qry :=
    'DELETE FROM [COMPANY].FinancialMatching                   ' +
    'WHERE DocRef NOT IN                                       ' +
    '(                                                         ' +
    '  SELECT DocRef FROM [COMPANY].FinancialMatching          ' +
    '  INNER JOIN [COMPANY].DOCUMENT doc ON                    ' +
    '   ((doc.thRemitNo <> '''') OR (doc.thOrdMatch <> 0)) AND ' +
    '   (doc.thOurRef = DocRef)                                ' +
    '  INNER JOIN [COMPANY].DOCUMENT pay ON                    ' +
    '   ((pay.thRemitNo = '''') AND (pay.thOrdMatch = 0)) AND  ' +
    '   (pay.thOurRef = PayRef)                                ' +
    ')';
  RunQuery(FSQLDelete, Qry, 'Error purging Financial Matching');
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeTransactions.PurgeNotes;
var
  Qry: string;
begin
  // Delete all the Notes for the current Transaction
  Qry := 'DELETE FROM [COMPANY].TransactionNote WHERE NoteFolio = ' + IntToStr(fldFolioNum.Value);
  RunQuery(FSQLDelete, Qry, 'Error purging Transaction Notes');
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeTransactions.ReadRecord(var InvR: InvRec);
begin
  FillChar(InvR, SizeOf(InvR), 0);
  InvR.CustSupp      := SafeCharFromString(fldCustSupp.Value, 1);
  InvR.CustCode      := fldAcCode.Value;
  InvR.NomAuto       := fldNomAuto.Value;
  InvR.FolioNum      := fldFolioNum.Value;
  InvR.RunNo         := fldRunNo.Value;
  InvR.InvDocHed     := DocTypes(fldDocType.Value);
  InvR.CtrlNom       := fldControlGL.Value;
  InvR.AcYr          := fldYear.Value;
  InvR.AcPr          := fldPeriod.Value;
  InvR.Currency      := fldCurrency.Value;
  InvR.RemitNo       := fldRemitNo.Value;
  InvR.SettledVAT    := fldSettledVAT.Value;
  InvR.VATPostDate   := fldVATPostDate.Value;
  InvR.UntilDate     := fldUntilDate.Value;

  { CJS 2012-08-15 - ABSEXCH-13240 - Transactions not being deleted }
  InvR.Settled       := fldAmountSettled.Value;

  InvR.CurrSettled   := fldCurrSettled.Value;
  InvR.OurRef        := fldOurRef.Value;
  InvR.CXrate[False] := fldCompanyRate.Value;
  InvR.CXrate[True]  := fldDailyRate.Value;
  InvR.AllocStat     := SafeCharFromString(fldOutstanding.Value, 1);
  InvR.UntilDate     := fldUntilDate.Value;
  InvR.DueDate       := fldDueDate.Value;
  InvR.TotOrdOS      := fldTotalOrderOS.Value;
  InvR.TotalCost     := fldTotalCost.Value;
  InvR.TotalOrdered  := fldTotalOrdered.Value;
  InvR.DeliverRef    := fldDeliveryNoteRef.Value;
  InvR.InvNetVal     := fldNetValue.Value;
  InvR.InvVat        := fldTotalVAT.Value;
  InvR.DiscAmount    := fldTotalLineDiscount.Value;
  InvR.Variance      := fldVariance.Value;
  InvR.ReValueAdj    := fldRevalueAdj.Value;
  InvR.DiscSetAm     := fldSettleDiscAmount.Value;
  InvR.DiscTaken     := fldSettleDiscTaken.Value;
  InvR.PostDiscAm    := fldPostDiscAm.Value;
end;

// =============================================================================
// TSQLPurgePayinLines
// =============================================================================

procedure TSQLPurgePayinLines.PrepareSQL;
begin
  FErrorMsg := 'Error purging Pay-In Lines';
  FSQL :=
    'DELETE FROM [COMPANY].DETAILS                                             ' +
    'WHERE PositionId IN                                                       ' +
    '(                                                                         ' +
    '  /* Select all the Nominal records */                                    ' +
    '  SELECT sourceLine.PositionId                                            ' +
    '  FROM [COMPANY].NOMINAL                                                  ' +
    '  /* Join all the Transaction Lines which match the negative of the       ' +
    '     Nominal Code */                                                      ' +
    '  INNER JOIN [COMPANY].DETAILS sourceLine                                 ' +
    '  ON (tlGLCode = glCode * -1.0) AND (tlNominalMode = 1)                   ' +
    '  /* Join all the Transaction Lines which match with the PayIn reference  ' +
    '     extracted from the Stock Code on the Transaction Line, using an Outer' +
    '     Join so that we include source Transaction Lines which have no       ' +
    '     Payin Lines associated with them */                                  ' +
    '  LEFT OUTER JOIN [COMPANY].DETAILS payinLine                             ' +
    '  ON (payinLine.tlOurRef =                                                ' +
    '      CAST(SUBSTRING(sourceLine.tlStockCode, 8, 10) AS VARCHAR))          ' +
    '  WHERE                                                                   ' +
    '    /* Exclude Nominal Headers and Carry-Forward records */               ' +
    '    (glType <> ''H'') AND                                                 ' +
    '    (glType <> ''F'')                                                     ' +
    '    /* Only include records with *NO* matching Pay-In Transaction Lines   ' +
    '       (because of the Outer Join the columns for these will come through ' +
    '       as NULL). */                                                       ' +
    '    AND payinLine.tlOurRef IS NULL                                        ' +
    ')';
end;

// -----------------------------------------------------------------------------

function TSQLPurgePayinLines.Process: Boolean;
begin
  Result := inherited Process;
  Write_FixMsgFmt('Deleted ' + IntToStr(FSQLCaller.LastRecordCount) + ' Pay-In Lines', 3);
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TSQLPurgeRunLines
// =============================================================================

procedure TSQLPurgeRunLines.PrepareSQL;
begin
  FErrorMsg := 'Error purging Run Control Lines';
  FSQL := Format(
           'DELETE FROM [COMPANY].DETAILS ' +
           'WHERE (tlDocType = %d) AND ' +
           '      ((tlYear < %d) OR ((tlYear = %d) AND (tlPeriod <= %d)))',
           [Ord(RUN), FInfo.Year, FInfo.Year, FInfo.Period]
         );
end;

// -----------------------------------------------------------------------------

function TSQLPurgeRunLines.Process: Boolean;
begin
  Result := inherited Process;
  Write_FixMsgFmt('Deleted ' + IntToStr(FSQLCaller.LastRecordCount) + ' Run Control Lines', 3);
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TSQLPurgeHistory
// =============================================================================

procedure TSQLPurgeHistory.PrepareSQL;
begin
  FErrorMsg := 'Error copying History records';
  FSQL := 'IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[COMPANY].[HISTPRGE]'') AND type in (N''U'')) ' +
          'DROP TABLE [COMPANY].[HISTPRGE] ' +
          ';' +
          'SELECT * INTO [COMPANY].HISTPRGE FROM [COMPANY].HISTORY ' +
          'WHERE [COMPANY].HISTORY.hiYear <= ' + IntToStr(FInfo.Year);
end;

// -----------------------------------------------------------------------------

function TSQLPurgeHistory.Process: Boolean;
begin
  Result := inherited Process;
  Write_FixMsgFmt('Copied ' + IntToStr(FSQLCaller.LastRecordCount) + ' History records', 3);
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TSQLPurgeTraders
// =============================================================================

procedure TSQLPurgeTraders.PrepareFields;
begin
  fldCustSupp := FSQLCaller.Records.FieldByName('acCustSupp') as TStringField;
  fldAcCode   := FSQLCaller.Records.FieldByName('acCode') as TStringField;
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeTraders.PrepareSQL;
begin
  // SQL query to find all Customers/Suppliers who have no Transactions
  // against them.
  FSQL := 'SELECT acCustSupp, acCode FROM [COMPANY].CUSTSUPP    ' +
          'WHERE acCode IN                                      ' +
          '(                                                    ' +
          '  SELECT c.acCode FROM [COMPANY].CUSTSUPP c          ' +
          '  LEFT JOIN [COMPANY].DOCUMENT ON thAcCode = acCode  ' +
          '  WHERE thOurRef IS NULL AND                         ' +
          '        c.acCustSupp = ''%s'' AND                    ' +
          '        c.acCode <> ''%s''                           ' +
          ')                                                    ';
end;

// -----------------------------------------------------------------------------

function TSQLPurgeTraders.Process: Boolean;
var
  RecordCount: Integer;
  SQLDeleteQry: string;
  ProgressPerRecord: Double;
  Progress: Double;
  DeletedCount: Integer;
begin
  if FInfo.PurgeCustomers then
  begin
    { CJS 2012-11-09 - ABSEXCH-13692 - Purge Suppliers doesn't }
    PrepareSQL;
    Title := 'Purging Customers';
    FSQL := Format(FSQL, ['C', Syss.DirectCust]);
    FSQLCaller.Select(FSQL, FCompanyCode);
    if (FSQLCaller.ErrorMsg <> '') then
    begin
      RaiseError('Error retrieving Customer records: ' + FSQLCaller.ErrorMsg);
    end
    else if FSQLCaller.Records.RecordCount > 0 then
    begin
      DeletedCount := 0;
      FRelatedDeletionsCount := 0;
      ProgressPerRecord := ProgressSegment / FSQLCaller.Records.RecordCount;
      Progress := FInfo.Progress.ProgressBar1.Position;
      PrepareFields;
      while (not FSQLCaller.Records.Eof) and (not FInfo.Progress.Aborted) do
      begin
        // FInfo.Progress.InfoLbl.Caption := 'Checking ' + fldAcCode.Value;
        Progress := Progress + ProgressPerRecord;
        FInfo.Progress.ProgressBar1.Position := Trunc(Progress);
        Application.ProcessMessages;

        PurgeNotes;
        PurgeDiscounts;
        PurgeLinks;
        PurgeTeleSalesAnalysis;
        PurgeHistory;

        // Delete the record itself
        SQLDeleteQry := 'DELETE FROM [COMPANY].CUSTSUPP WHERE acCode = ''' +
                         fldAcCode.Value + '''';
        RecordCount := FSQLDelete.ExecSQL(SQLDeleteQry, FCompanyCode);
        if (RecordCount = -1) then
        begin
          RaiseError('Error deleting Customer record ' + fldAcCode.Value + ': ' + FSQLDelete.ErrorMsg);
        end;

        FInfo.RecordsScanned := FInfo.RecordsScanned + 1;
        FInfo.RecordsProcessed := FInfo.RecordsProcessed + 1;
        DeletedCount := DeletedCount + 1;

        FSQLCaller.Records.Next;
      end;
      if (FRelatedDeletionsCount > 0) then
        Write_FixMsgFmt('Deleted ' + IntToStr(DeletedCount) + ' Customers ' +
                        '+ ' + IntToStr(FRelatedDeletionsCount) + ' related records', 3)
      else
        Write_FixMsgFmt('Deleted ' + IntToStr(DeletedCount) + ' Customers', 3);
    end;
    FinishProgress;
    FSQLCaller.Close;
  end;
  if FInfo.PurgeSuppliers then
  begin
    { CJS 2012-11-09 - ABSEXCH-13692 - Purge Suppliers doesn't }
    PrepareSQL;
    Title := 'Purging Suppliers';
    FSQL := Format(FSQL, ['S', Syss.DirectSupp]);
    FSQLCaller.Select(FSQL, FCompanyCode);
    if (FSQLCaller.ErrorMsg <> '') then
    begin
      RaiseError('Error retrieving Supplier records: ' + FSQLCaller.ErrorMsg);
    end
    else if FSQLCaller.Records.RecordCount > 0 then
    begin
      DeletedCount := 0;
      FRelatedDeletionsCount := 0;
      ProgressPerRecord := ProgressSegment / FSQLCaller.Records.RecordCount;
      Progress := FInfo.Progress.ProgressBar1.Position;
      PrepareFields;
      while (not FSQLCaller.Records.Eof) and (not FInfo.Progress.Aborted) do
      begin
        // FInfo.Progress.InfoLbl.Caption := 'Checking ' + fldAcCode.Value;
        Progress := Progress + ProgressPerRecord;
        FInfo.Progress.ProgressBar1.Position := Trunc(Progress);
        Application.ProcessMessages;

        PurgeNotes;
        PurgeDiscounts;
        PurgeLinks;
        PurgeTeleSalesAnalysis;
        PurgeHistory;

        // Delete the record itself
        SQLDeleteQry := 'DELETE FROM [COMPANY].CUSTSUPP WHERE acCode = ''' +
                        fldAcCode.Value + '''';
        RecordCount := FSQLDelete.ExecSQL(SQLDeleteQry, FCompanyCode);
        if (RecordCount = -1) then
        begin
          RaiseError('Error deleting Supplier record ' + fldAcCode.Value + ': ' + FSQLDelete.ErrorMsg);
        end;

        FInfo.RecordsScanned := FInfo.RecordsScanned + 1;
        FInfo.RecordsProcessed := FInfo.RecordsProcessed + 1;
        DeletedCount := DeletedCount + 1;

        FSQLCaller.Records.Next;
      end;
      if (FRelatedDeletionsCount > 0) then
        Write_FixMsgFmt('Deleted ' + IntToStr(DeletedCount) + ' Suppliers ' +
                        '+ ' + IntToStr(FRelatedDeletionsCount) + ' related records', 3)
      else
        Write_FixMsgFmt('Deleted ' + IntToStr(DeletedCount) + ' Suppliers', 3);
    end;
    FinishProgress;
    FSQLCaller.Close;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeTraders.PurgeDiscounts;
var
  Qry: string;
begin
  // Old discount types
  Qry := 'DELETE FROM [COMPANY].EXSTKCHK ' +
         'WHERE RecMfix = ''D'' AND SubType = ''' + fldCustSupp.Value + '''' +
         '      AND Exstchkvar1Trans1 LIKE ''' + fldAcCode.Value + ''' ';
  RunQuery(FSQLDelete, Qry, 'Error purging Trader Discounts for ' + fldAcCode.Value);

  Qry := 'DELETE FROM [COMPANY].EXSTKCHK ' +
         'WHERE RecMfix = ''C'' AND SubType = ''' + fldCustSupp.Value + '''' +
         '      AND Exstchkvar1Trans1 LIKE ''' + fldAcCode.Value + ''' ';
  RunQuery(FSQLDelete, Qry, 'Error purging old Quantity Break Discounts for ' + fldAcCode.Value);

  // Multi-buy Discounts
  Qry := 'DELETE FROM [COMPANY].MULTIBUY WHERE ' +
         '(mbdOwnerType = ''%s'') AND (mbdAcCode = ''%s'')';
  Qry := Format(Qry, [fldCustSupp.Value, fldAcCode.Value]);
  RunQuery(FSQLDelete, Qry, 'Error purging Multi-Buy Discounts for ' + fldAcCode.Value);

  // Quantity-Break Discounts
  Qry := 'DELETE FROM [COMPANY].QTYBREAK WHERE ' +
         '(qbAcCode = ''%s'')';
  Qry := Format(Qry, [fldAcCode.Value]);
  RunQuery(FSQLDelete, Qry, 'Error purging Quantity Break Discounts for ' + fldAcCode.Value);
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeTraders.PurgeHistory;
var
  Code: string;
  Size: Integer;
  Qry: string;
begin
  Code := fldAcCode.Value;
  Size := Length(Code) + 1;
  Qry  := 'DELETE FROM [COMPANY].HISTORY WHERE ' +
          Format('(hiExClass = %d) AND (LEFT(hiCode, %d) = ''%s'')',
                 [Ord(CuStkHistCode), Size, Code]);
  RunQuery(FSQLDelete, Qry, 'Error purging Trader History records for ' + fldAcCode.Value);

  Code := #1 + fldAcCode.Value;
  Size := Length(Code) + 1;
  Qry  := 'DELETE FROM [COMPANY].HISTORY WHERE ' +
          Format('(hiExClass = %d) AND (LEFT(hiCode, %d) = ''%s'')',
          [Ord(CuStkHistCode), Size, Code]);
  RunQuery(FSQLDelete, Qry, 'Error purging Trader History (1) records for ' + fldAcCode.Value);

  Code := #2 + fldAcCode.Value;
  Size := Length(Code) + 1;
  Qry  := 'DELETE FROM [COMPANY].HISTORY WHERE ' +
          Format('(hiExClass = %d) AND (LEFT(hiCode, %d) = ''%s'')',
          [Ord(CuStkHistCode), Size, Code]);
  RunQuery(FSQLDelete, Qry, 'Error purging Trader History (2) records for ' + fldAcCode.Value);
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeTraders.PurgeLinks;
var
  Qry: string;
begin
  Qry := 'DELETE FROM [COMPANY].EXSTKCHK ' +
         'WHERE RecMfix = ''W'' AND SubType = ''' + fldCustSupp.Value + '''' +
         '      AND Exstchkvar1Trans1 LIKE ''' + fldAcCode.Value + ''' ';
  RunQuery(FSQLDelete, Qry, 'Error purging Trader Links for ' + fldAcCode.Value);
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeTraders.PurgeNotes;
var
  Qry: string;
begin
  // Customer/Supplier notes are against Prefix/Subtype 'NA'
  Qry := 'DELETE FROM [COMPANY].EXCHQCHK ' +
         'WHERE RecPfix = ''N'' AND SubType = ASCII(''A'') ' +
         '      AND LEFT(EXCHQCHKcode1, 7) = ' +
                SQLUtils.StringToHex(#11 + fldAcCode.Value, 6);
  RunQuery(FSQLDelete, Qry, 'Error purging Trader Notes for ' + fldAcCode.Value);
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeTraders.PurgeTelesalesAnalysis;
var
  Qry: AnsiString;
begin
  // Build the SQL query.
  Qry := 'DELETE FROM [COMPANY].CustomerStockAnalysis WHERE ' +
         'CsCustCode = ''' + fldAcCode.Value + ''' ';
  RunQuery(FSQLDelete, Qry, 'Error purging Trader Stock Analysis records for ' + fldAcCode.Value);
end;

// =============================================================================
// TSQLPurgeStock
// =============================================================================

function TSQLPurgeStock.CanBeDeleted: Boolean;
var
  Purch: Real;
  Sales: Real;
  Cleared: Real;
  Profit: Real;
  Qry: string;
  CountResult: Variant;
  FuncRes: Integer;
begin
  Profit := Profit_To_Date(Calc_AltStkHCode(SafeCharFromString(fldStType.Value, 1)),
                                            FullNOmKey(fldStFolioNum.Value),
                                            0, 150, YTD,
                                            Purch, Sales, Cleared, True);

  Qry := 'SELECT COUNT(tlFolioNum) AS reccount FROM [COMPANY].DETAILS ' +
         'WHERE (LEFT(tlStockCode, 17) = ' + StringToHex(fldStCode.Value, 16, True) + ')';
  FuncRes := SQLFetch(Qry, 'reccount', SetDrive, CountResult);
  if (FuncRes <> 0) then
  begin
    RaiseError('Error checking Stock record for existing transactions: ' + fldStCode.Value, FuncRes);
  end;

  if (CountResult = 0) and
     (fldStQtyInStock.Value = 0.0) and
     (fldStType.Value <> StkGrpCode) and
     (Cleared = 0.0) then
    Result := True
  else
    Result := False;
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeStock.PrepareFields;
begin
  fldStCode       := FSQLCaller.Records.FieldByName('stCode') as TStringField;
  fldStAltCode    := FSQLCaller.Records.FieldByName('stAltCode') as TStringField;
  fldStFolioNum   := FSQLCaller.Records.FieldByName('stFolioNum') as TIntegerField;
  fldStParentCode := FSQLCaller.Records.FieldByName('stParentCode') as TStringField;
  fldStType       := FSQLCaller.Records.FieldByName('stType') as TStringField;
  fldStQtyInStock := FSQLCaller.Records.FieldByName('stQtyInStock') as TFloatField;
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeStock.PrepareSQL;
begin
  FSQL := 'SELECT          ' +
          '  stCode,       ' +
          '  stAltCode,    ' +
          '  stFolioNum,   ' +
          '  stParentCode, ' +
          '  stType,       ' +
          '  stQtyInStock  ' +
          'FROM [COMPANY].STOCK ';
end;

// -----------------------------------------------------------------------------

function TSQLPurgeStock.Process: Boolean;
var
  SQLDeleteQry: string;
  RecordCount: Integer;
  ProgressPerRecord: Double;
  Progress: Double;
  DeletedCount: Integer;
begin
  PrepareSQL;
  FSQLCaller.Select(FSQL, FCompanyCode);
  if FSQLCaller.ErrorMsg <> '' then
  begin
    RaiseError('Error retrieving Stock records: ' + FSQLCaller.ErrorMsg);
  end
  else if FSQLCaller.Records.RecordCount > 0 then
  begin
    ProgressPerRecord := ProgressSegment / FSQLCaller.Records.RecordCount;
    Progress := FInfo.Progress.ProgressBar1.Position;
    PrepareFields;

    DeletedCount := 0;
    FRelatedDeletionsCount := 0;
    // Locate all the Stock records that should be purged
    while (not FSQLCaller.Records.Eof) and (not FInfo.Progress.Aborted) do
    begin
      // FInfo.Progress.InfoLbl.Caption := 'Checking ' + fldStCode.Value;
      Progress := Progress + ProgressPerRecord;
      FInfo.Progress.ProgressBar1.Position := Trunc(Progress);
      Application.ProcessMessages;
      // Write_FixMsgFmt('Checking ' + fldStCode.Value, 3);

      FInfo.RecordsScanned := FInfo.RecordsScanned + 1;
      // For each Stock record:
      if CanBeDeleted then
      begin
        // Purge the related records from other tables
        PurgeNotes;
        PurgeBOM;
        PurgeDiscounts;
        PurgeStockLocations;
        PurgeFIFO;
        PurgeAltStock;
        PurgeSerialNumbers;
        PurgeBinRecords;
        PurgeLinks;
        PurgeAnalysisRecords;
        PurgePostedHistory;
        PurgeLocationHistory;
        PurgeSalesHistory;
        PurgeLocationSalesHistory;

        // Delete the Stock record itself
        SQLDeleteQry := 'DELETE FROM [COMPANY].STOCK WHERE stFolioNum = ' +
                        IntToStr(fldStFolioNum.Value);
        RecordCount := FSQLDelete.ExecSQL(SQLDeleteQry, FCompanyCode);
        if (RecordCount = -1) then
        begin
          RaiseError('Error purging Stock record ' + fldStCode.Value + ': ' + FSQLDelete.ErrorMsg);
        end;
        FInfo.RecordsProcessed := FInfo.RecordsProcessed + 1;
        DeletedCount := DeletedCount + 1;
      end;
      FSQLCaller.Records.Next;
    end;
    if (FRelatedDeletionsCount > 0) then
      Write_FixMsgFmt('Deleted ' + IntToStr(DeletedCount) + ' Stock Items ' +
                      '+ ' + IntToStr(FRelatedDeletionsCount) + ' related records', 3)
    else
      Write_FixMsgFmt('Deleted ' + IntToStr(DeletedCount) + ' Stock Items', 3);
  end;
  FSQLCaller.Close;
  FinishProgress;
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeStock.PurgeAltStock;
var
  Qry: string;
begin
  Qry := 'DELETE FROM [COMPANY].MLOCSTK WHERE ' +
         '(RecPfix = ''N'') AND ' +
         '(SubType = ''A'') AND ' +
         '(sdStkFolio = ' + IntToStr(fldStFolioNum.Value) + ') ';
  RunQuery(FSQLDelete, Qry, 'Error purging Alternate Stock Codes for ' + fldStCode.Value);
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeStock.PurgeAnalysisRecords;
var
  Qry: string;
begin
  Qry := 'DELETE FROM [COMPANY].MLOCSTK WHERE ' +
         '(RecPfix = ''T'') AND ' +
         '(SubType = ''P'') AND ' +
         '(sdStkFolio = ' + IntToStr(fldStFolioNum.Value) + ') ';
  RunQuery(FSQLDelete, Qry, 'Error purging Stock Analysis records for ' + fldStCode.Value);
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeStock.PurgeBinRecords;
var
  Qry: string;
begin
  Qry := 'DELETE FROM [COMPANY].MLOCSTK WHERE ' +
         '(RecPfix = ''I'') AND ' +
         '(SubType = ''R'') AND ' +
         '(sdStkFolio = ' + IntToStr(fldStFolioNum.Value) + ') ';
  RunQuery(FSQLDelete, Qry, 'Error purging Bin records for ' + fldStCode.Value);
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeStock.PurgeBOM;
var
  Qry: string;
begin
  Qry := 'DELETE FROM [COMPANY].EXCHQCHK WHERE ' +
         'RecPfix = ''B'' AND SubType = ASCII(''M'') AND ' +
         '( ' +
         '  CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(CONVERT(VARBINARY(4), EXCHQCHKcode1),2,4))) AS INTEGER) = %d OR ' +
         '  CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(CONVERT(VARBINARY(4), EXCHQCHKcode3),2,4))) AS INTEGER) = %d ' +
         ') ';
  Qry := Format(Qry, [fldStFolioNum.Value, fldStFolioNum.Value]);
  RunQuery(FSQLDelete, Qry, 'Error purging Bill of Material records for ' + fldStCode.Value);
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeStock.PurgeDiscounts;
var
  Qry: string;
begin
  // Discounts
  Qry := 'DELETE FROM [COMPANY].EXSTKCHK WHERE ' +
         'RecMfix = ''D'' AND SubType = ''Q'' AND ' +
         'CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(CONVERT(VARBINARY(4), exstchkvar1),2,4))) AS INTEGER) = %d';
  Qry := Format(Qry, [fldStFolioNum.Value]);
  RunQuery(FSQLDelete, Qry, 'Error purging Stock Discounts for ' + fldStCode.Value);

  // Multi-Buy Discounts
  Qry := 'DELETE FROM [COMPANY].MULTIBUY WHERE ' +
         '(mbdOwnerType = ''T'') AND (mbdStockCode = ''%s'')';
  Qry := Format(Qry, [fldStCode.Value]);
  RunQuery(FSQLDelete, Qry, 'Error purging Stock Multi-Buy Discounts for ' + fldStCode.Value);

  // Quantity-Break Discounts
  Qry := 'DELETE FROM [COMPANY].QTYBREAK WHERE ' +
         '(qbFolio = 0) AND (qbStockFolio = %d)';
  Qry := Format(Qry, [fldStFolioNum.Value]);
  RunQuery(FSQLDelete, Qry, 'Error purging Stock Quantity Break Discounts for ' + fldStCode.Value);
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeStock.PurgeFIFO;
var
  Qry: AnsiString;
begin
  // Build the SQL query.
  Qry := 'DELETE FROM [COMPANY].FIFO WHERE ' +
         'FIFOStkFolio = ' + IntToStr(fldStFolioNum.Value);
  RunQuery(FSQLDelete, Qry, 'Error purging FIFO records for ' + fldStCode.Value);
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeStock.PurgeLinks;
var
  Qry: string;
begin
  Qry := 'DELETE FROM [COMPANY].EXSTKCHK WHERE ' +
         'RecMfix = ''W'' AND SubType = ''K'' AND ' +
         'CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(CONVERT(VARBINARY(4), AccCode),2,4))) AS INTEGER) = %d';
  Qry := Format(Qry, [fldStFolioNum.Value]);
  RunQuery(FSQLDelete, Qry, 'Error purging Stock Links for ' + fldStCode.Value);
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeStock.PurgeLocationHistory;
var
  HistoryCode: string;
  HistoryClass: Char;
  Size: Integer;
  Qry: string;
begin
  HistoryClass := Calc_AltStkHCode(SafeCharFromString(fldStType.Value, 1));
  HistoryCode := SQLUtils.StringToHex('L' + FullNomKey(fldStFolioNum.Value));
  Size := Length(HistoryCode) + 1;
  Qry := 'DELETE FROM [COMPANY].HISTORY WHERE ' +
         Format('(hiExClass = %d) AND (LEFT(hiCode, %d) = %s)',
         [Ord(HistoryClass), Size, HistoryCode]);
  RunQuery(FSQLDelete, Qry, 'Error purging Stock Location History records for ' + fldStCode.Value);
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeStock.PurgeLocationSalesHistory;
var
  HistoryCode: string;
  HistoryClass: Char;
  Size: Integer;
  Qry: string;
begin
  HistoryClass := SafeCharFromString(fldStType.Value, 1);
  HistoryCode := SQLUtils.StringToHex('L' + FullNomKey(fldStFolioNum.Value));
  Size := Length(HistoryCode) + 1;
  Qry := 'DELETE FROM [COMPANY].HISTORY WHERE ' +
         Format('(hiExClass = %d) AND (LEFT(hiCode, %d) = %s)',
         [Ord(HistoryClass), Size, HistoryCode]);
  RunQuery(FSQLDelete, Qry, 'Error purging Stock Location Sales History records for ' + fldStCode.Value);
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeStock.PurgeNotes;
var
  Qry: string;
begin
  // Stock notes are against Prefix/Subtype 'NS'
  Qry := 'DELETE FROM [COMPANY].EXCHQCHK WHERE ' +
         'RecPfix = ''N'' AND SubType = ASCII(''S'') ' +
         'AND CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(CONVERT(VARBINARY(4), EXCHQCHKcode1),2, 4))) AS INTEGER) = ' +
         IntToStr(fldStFolioNum.Value);
  RunQuery(FSQLDelete, Qry, 'Error purging Stock Notes for ' + fldStCode.Value);
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeStock.PurgePostedHistory;
var
  HistoryCode: string;
  HistoryClass: Char;
  Size: Integer;
  Qry: string;
begin
  HistoryClass := Calc_AltStkHCode(SafeCharFromString(fldStType.Value, 1));
  HistoryCode := SQLUtils.StringToHex(FullNomKey(fldStFolioNum.Value));
  Size := Length(HistoryCode) + 1;
  Qry := 'DELETE FROM [COMPANY].HISTORY WHERE ' +
         Format('(hiExClass = %d) AND (LEFT(hiCode, %d) = %s)',
         [Ord(HistoryClass), Size, HistoryCode]);
  RunQuery(FSQLDelete, Qry, 'Error purging Posted Stock History records for ' + fldStCode.Value);
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeStock.PurgeSalesHistory;
var
  HistoryCode: string;
  HistoryClass: Char;
  Size: Integer;
  Qry: string;
begin
  HistoryClass := SafeCharFromString(fldStType.Value, 1);
  HistoryCode := SQLUtils.StringToHex(FullNomKey(fldStFolioNum.Value));
  Size := Length(HistoryCode) + 1;
  Qry := 'DELETE FROM [COMPANY].HISTORY WHERE ' +
         Format('(hiExClass = %d) AND (LEFT(hiCode, %d) = %s)',
         [Ord(HistoryClass), Size, HistoryCode]);
  RunQuery(FSQLDelete, Qry, 'Error purging Stock Sales History records for ' + fldStCode.Value);
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeStock.PurgeSerialNumbers;
var
  Qry: string;
begin
  Qry := 'DELETE FROM [COMPANY].SerialBatch WHERE ' +
         'StockFolio = %d';
  Qry := Format(Qry, [fldStFolioNum.Value]);
  RunQuery(FSQLDelete, Qry, 'Error purging Serial Numbers for ' + fldStCode.Value);
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeStock.PurgeStockLocations;
var
  Qry: AnsiString;
begin
  // Build the SQL query.
  Qry := 'DELETE FROM [COMPANY].StockLocation WHERE ' +
         'LsStkFolio = %d';
  Qry := Format(Qry, [fldStFolioNum.Value]);
  RunQuery(FSQLDelete, Qry, 'Error purging Stock Location records for ' + fldStCode.Value);
end;

// =============================================================================
// TSQLPurgeLocations
// =============================================================================

procedure TSQLPurgeLocations.PrepareFields;
begin
  fldLoCode := FSQLCaller.Records.FieldByName('loCode') as TStringField;
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeLocations.PrepareSQL;
begin
  FSQL := 'SELECT loCode FROM [COMPANY].Location                           ' +
          'WHERE loCode IN                                                 ' +
          '(                                                               ' +
          '  SELECT loCode FROM [COMPANY].Location                         ' +
          '  LEFT OUTER JOIN [COMPANY].StockLocation ON loCode = LsLocCode ' +
          '  WHERE LsLocCode IS NULL                                       ' +
          ')                                                               ';
end;

// -----------------------------------------------------------------------------

function TSQLPurgeLocations.Process: Boolean;
var
  SQLDeleteQry: string;
  RecordCount: Integer;
  ProgressPerRecord: Double;
  Progress: Double;
  DeletedCount: Integer;
begin
  PrepareSQL;
  FSQLCaller.Select(FSQL, FCompanyCode);
  if FSQLCaller.ErrorMsg <> '' then
  begin
    RaiseError('Error retrieving Location records: ' + FSQLCaller.ErrorMsg);
  end
  else if FSQLCaller.Records.RecordCount > 0 then
  begin
    ProgressPerRecord := ProgressSegment / FSQLCaller.Records.RecordCount;
    Progress := FInfo.Progress.ProgressBar1.Position;
    PrepareFields;

    DeletedCount := 0;
    FRelatedDeletionsCount := 0;
    // Locate all the records that should be purged
    while (not FSQLCaller.Records.Eof) and (not FInfo.Progress.Aborted) do
    begin
      Progress := Progress + ProgressPerRecord;
      FInfo.Progress.ProgressBar1.Position := Trunc(Progress);
      Application.ProcessMessages;

      FInfo.RecordsScanned := FInfo.RecordsScanned + 1;

      // For each record, purge the related records from other tables
      PurgeNotes;

      // Delete the record itself
      SQLDeleteQry := Format('DELETE FROM [COMPANY].Location WHERE loCode = ''%s''',
                             [fldLoCode.Value]);
      RecordCount := FSQLDelete.ExecSQL(SQLDeleteQry, FCompanyCode);
      if (RecordCount = -1) then
      begin
        RaiseError('Error purging Location record ' + fldLoCode.Value + ': ' + FSQLDelete.ErrorMsg);
      end;
      FInfo.RecordsProcessed := FInfo.RecordsProcessed + 1;
      DeletedCount := DeletedCount + 1;

      FSQLCaller.Records.Next;
    end;
    if (FRelatedDeletionsCount > 0) then
      Write_FixMsgFmt('Deleted ' + IntToStr(DeletedCount) + ' Locations ' +
                      '+ ' + IntToStr(FRelatedDeletionsCount) + ' related records', 3)
    else
      Write_FixMsgFmt('Deleted ' + IntToStr(DeletedCount) + ' Locations', 3);
  end;
  FSQLCaller.Close;
  FinishProgress;
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeLocations.PurgeNotes;
var
  Qry: string;
begin
  Qry := Format('DELETE FROM [COMPANY].[EXCHQCHK] ' +
                'WHERE RecPfix = ''N'' AND SubType = ASCII(''L'') ' +
                'AND LEFT(EXCHQCHKcode1, 4) = CHAR(11) + ''%s''',
                [fldLoCode.Value]);
  RunQuery(FSQLDelete, Qry, 'Error purging Location Notes for ' + fldLoCode.Value);
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TSQLPurgeSerialNumbers
// =============================================================================

procedure TSQLPurgeSerialNumbers.PrepareFields;
begin
  fldSerialNo  := FSQLCaller.Records.FieldByName('SerialNo') as TStringField;
  fldNoteFolio := FSQLCaller.Records.FieldByName('NoteFolio') as TIntegerField;
end;

procedure TSQLPurgeSerialNumbers.PrepareSQL;
begin
  FSQL := 'SELECT SerialNo, NoteFolio FROM [COMPANY].SerialBatch  ' +
          'WHERE SerialNo IN                            ' +
          '(                                            ' +
          '  SELECT SerialNo                            ' +
          '  FROM [COMPANY].SerialBatch                 ' +
          '  LEFT OUTER JOIN [COMPANY].DOCUMENT         ' +
          '  ON thOurRef = InDoc OR thOurRef = OutDoc   ' +
          '  WHERE thOurRef IS NULL                     ' +
          ')                                            ';
end;

// -----------------------------------------------------------------------------

function TSQLPurgeSerialNumbers.Process: Boolean;
var
  SQLDeleteQry: string;
  RecordCount: Integer;
  ProgressPerRecord: Double;
  Progress: Double;
  DeletedCount: Integer;
begin
  PrepareSQL;
  FSQLCaller.Select(FSQL, FCompanyCode);
  if FSQLCaller.ErrorMsg <> '' then
  begin
    RaiseError('Error retrieving Serial Numbers: ' + FSQLCaller.ErrorMsg);
  end
  else if FSQLCaller.Records.RecordCount > 0 then
  begin
    ProgressPerRecord := ProgressSegment / FSQLCaller.Records.RecordCount;
    Progress := FInfo.Progress.ProgressBar1.Position;
    PrepareFields;

    DeletedCount := 0;
    FRelatedDeletionsCount := 0;
    // Locate all the records that should be purged
    while (not FSQLCaller.Records.Eof) and (not FInfo.Progress.Aborted) do
    begin
      Progress := Progress + ProgressPerRecord;
      FInfo.Progress.ProgressBar1.Position := Trunc(Progress);
      Application.ProcessMessages;

      FInfo.RecordsScanned := FInfo.RecordsScanned + 1;

      // For each record, purge the related records from other tables
      PurgeNotes;

      // Delete the record itself
      SQLDeleteQry := Format('DELETE FROM [COMPANY].SerialBatch WHERE SerialNo = ''%s''',
                             [fldSerialNo.Value]);
      RecordCount := FSQLDelete.ExecSQL(SQLDeleteQry, FCompanyCode);
      if (RecordCount = -1) then
      begin
        RaiseError('Error purging Serial Number record ' + fldSerialNo.Value + ': ' + FSQLDelete.ErrorMsg);
      end;
      FInfo.RecordsProcessed := FInfo.RecordsProcessed + 1;
      DeletedCount := DeletedCount + 1;

      FSQLCaller.Records.Next;
    end;
    if (FRelatedDeletionsCount > 0) then
      Write_FixMsgFmt('Deleted ' + IntToStr(DeletedCount) + ' Serial Numbers ' +
                      '+ ' + IntToStr(FRelatedDeletionsCount) + ' related records', 3)
    else
      Write_FixMsgFmt('Deleted ' + IntToStr(DeletedCount) + ' Serial Numbers', 3);
  end;
  FSQLCaller.Close;
  FinishProgress;
end;

// -----------------------------------------------------------------------------

procedure TSQLPurgeSerialNumbers.PurgeNotes;
var
  Qry: string;
begin
  Qry := 'DELETE FROM [COMPANY].EXCHQCHK WHERE ' +
         'RecPfix = ''N'' AND SubType = ASCII(''R'') ' +
         'AND CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(CONVERT(VARBINARY(4), EXCHQCHKcode1),2, 4))) AS INTEGER) = ' +
         IntToStr(fldNoteFolio.Value);
  RunQuery(FSQLDelete, Qry, 'Error purging Serial Notes for ' + fldSerialNo.Value);
end;

// -----------------------------------------------------------------------------

end.
