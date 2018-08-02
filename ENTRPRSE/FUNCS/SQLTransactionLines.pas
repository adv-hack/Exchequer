unit SQLTransactionLines;

interface

uses
  SysUtils,
  Variants,
  DB,
  GlobVar,
  VarConst,
  SQLUtils,
  SQLCallerU,
  SQLRep_Config,
  EntLoggerClass,
  AdoConnect;

type
  { Array-type for accessing binary fields (see ReadRecord) }
  TByteArray = Array [0..255] of Byte;

  {
    Class for retrieving transaction lines via direct SQL or a stored
    procedure. This is an abstract class, and should not be used -- instead,
    one of the descendant classes.
  }
  TSQLTransactionLines = class(TObject)
  private
    fldPosition : TIntegerField;
    LI, iRes : LongInt;
    fldFolioNum : TIntegerField;
    fldLineNo : TIntegerField;
    fldRunNo : TIntegerField;
    fldGLCode : TIntegerField;
    fldNominalMode : TIntegerField;
    fldCurrency : TIntegerField;
    fldYear : TIntegerField;
    fldPeriod : TIntegerField;
    fldDepartment : TStringField;
    fldCostCentre : TStringField;
    fldStockCode : TBinaryField;
    fldABSLineNo : TIntegerField;
    fldLineType : TStringField;
    fldDocType : TIntegerField;
    fldDLLUpdate : TIntegerField;
    fldOldSerialQty : TIntegerField;
    fldQty : TFloatField;
    fldQtyMul : TFloatField;
    fldNetValue : TFloatField;
    fldDiscount : TFloatField;
    fldVATCode : TStringField;
    fldVATAmount : TFloatField;
    fldPaymentCode : TStringField;
    fldOldPBal : TFloatField;
    fldRecStatus : TIntegerField;
    fldDiscFlag : TStringField;
    fldQtyWOFF : TFloatField;
    fldQtyDel : TFloatField;
    fldCost : TFloatField;
    fldAcCode : TStringField;
    fldLineDate : TStringField;
    fldItemNo : TStringField;
    fldDescription : TStringField;
    fldJobCode : TStringField;
    fldAnalysisCode : TStringField;
    fldCompanyRate : TFloatField;
    fldDailyRate : TFloatField;
    fldUnitWeight : TFloatField;
    fldStockDeductQty : TFloatField;
    fldBOMKitLink : TIntegerField;
    fldSOPFolioNum : TIntegerField;
    fldSOPABSLineNo : TIntegerField;
    fldLocation : TStringField;
    fldQtyPicked : TFloatField;
    fldQtyPickedWO : TFloatField;
    fldUsePack : TBooleanField;
    fldSerialQty : TFloatField;
    fldCOSNomCode : TIntegerField;
    fldOurRef : TStringField;
    fldDocLTLink : TIntegerField;
    fldPrxPack : TBooleanField;
    fldQtyPack : TFloatField;
    fldReconciliationDate : TStringField;
    fldShowCase : TBooleanField;
    fldSdbFolio : TIntegerField;
    fldOriginalBaseValue : TFloatField;
    fldUseOriginalRates : TIntegerField;
    fldUserField1 : TStringField;
    fldUserField2 : TStringField;
    fldUserField3 : TStringField;
    fldUserField4 : TStringField;
    fldSSDUpliftPerc : TFloatField;
    fldSSDCountry : TStringField;
    fldInclusiveVATCode : TStringField;
    fldSSDCommodCode : TStringField;
    fldSSDSalesUnit : TFloatField;
    fldPriceMultiplier : TFloatField;
    fldB2BLinkFolio : TIntegerField;
    fldB2BLineNo : TIntegerField;
    fldTriRates : TFloatField;
    fldTriEuro : TIntegerField;
    fldTriInvert : TBooleanField;
    fldTriFloat : TBooleanField;
    fldSpare1 : TBinaryField;
    fldSSDUseLineValues : TBooleanField;
    fldPreviousBalance : TFloatField;
    fldLiveUplift : TBooleanField;
    fldCOSDailyRate : TFloatField;
    fldVATIncValue : TFloatField;
    fldLineSource : TIntegerField;
    fldCISRateCode : TStringField;
    fldCISRate : TFloatField;
    fldCostApport : TFloatField;
    fldNOMIOFlag : TIntegerField;
    fldBinQty : TFloatField;
    fldCISAdjustment : TFloatField;
    fldDeductionType : TIntegerField;
    fldSerialReturnQty : TFloatField;
    fldBinReturnQty : TFloatField;
    fldDiscount2 : TFloatField;
    fldDiscount2Chr : TStringField;
    fldDiscount3 : TFloatField;
    fldDiscount3Chr : TStringField;
    fldDiscount3Type : TIntegerField;
    fldECService : TBooleanField;
    fldServiceStartDate : TStringField;
    fldServiceEndDate : TStringField;
    fldECSalesTaxReported : TFloatField;
    fldPurchaseServiceTax : TFloatField;
    fldReference : TStringField;
    fldReceiptNo : TStringField;
    fldFromPostCode : TStringField;
    fldToPostCode : TStringField;
    fldUserField5 : TStringField;
    fldUserField6 : TStringField;
    fldUserField7 : TStringField;
    fldUserField8 : TStringField;
    fldUserField9 : TStringField;
    fldUserField10 : TStringField;
    fldThresholdCode : TStringField;
    fldMaterialsOnlyRetention : TBooleanField;
    // CJS 2015-12-15 - 2016 R1 - Intrastat - A1.4 - new Transaction Line (Details) field
    fldIntrastatNoTC: TStringField;
    // MH 21/03/2016 2016-R2 ABSEXCH-17379: New Tax Region field for Multi-Region Tax
    fldTaxRegion : TIntegerField;

    Columns: string;

    QryCount: Integer;

    FieldsPrepared: Boolean;

    { Flag to record whether we are using our own copy of TSQLCaller (and
      hence must free it) rather than an instance supplied by the calling
      routine. }
    UsingInternalSQLCaller: Boolean;

    { Getter for the Line property, returning the specified line. Raises an
      exception if the recordset is not open. }
    function GetLine(Idx: Integer): IDetail;

    { Checks that any required properties have been assigned values. Returns
      False if the validation fails and puts a description of the problem into
      ValidationError. This should be overridden by descendant classes (this
      base function simply returns True). }
    function Validate: Boolean;

  protected
    ValidationError: string;

  public
    SQLCaller: TSQLCaller;
    Id: IDetail;
    Logger: TEntBaseLogger;
    CompanyCode: AnsiString;

    constructor Create;
    destructor Destroy; override;

    { Sets up the references to the fields in the recordset. The recordset
      must be open before calling this procedure. }
    procedure PrepareFields;

    { Retrieves the recordset. This must be overridden in descendant classes. }
    procedure OpenFile; virtual; abstract;

    { Closes the recordset. }
    procedure CloseFile;

    { Reads the current record from the dataset into the internal structure,
      and returns a copy }
    function ReadRecord: IDetail;

    procedure ReadRecordInto(var IdR: IDetail);

    { Navigates to the first record in the recordset. Raises an exception if
      the recordset is not open. }
    procedure First;

    { Navigates to the next record in the recordset. Raises an exception if
      the recordset is not open. }
    procedure Next;

    { Returns the number of records in the recordset. Returns 0 if the
      recordset is not open }
    function Count: Integer;

    { Returns True if we have navigated past the end of the recordset. Always
      returns True if the recordset is not open }
    function EOF: Boolean;

    { Reports the supplied error (if Logger is assigned) and then raises an
      an exception using the error message. }
    procedure OnError(Msg: string);

    property Line[Idx: Integer]: IDetail read GetLine; default;
  end;

  // ===========================================================================

  {
    Class for retrieving transaction lines via direct SQL.

    The CompanyCode and FromClause must be initialised, and optionally the
    JoinClause, WhereClause, and OrderByClause.

    Call OpenFile to read the records, then either navigate through them using
    First and Next, or read the lines directly using the Line[] index property
    (use Count to determine how many lines there are).

    Retrieve the current record using ReadRecord, which returns an IDetail
    structure.

    Example:

      var
        Lines: TSQLSelectTransactionLines;
        Id: IDetail;
      begin
        Lines := TSQLSelectTransactionLines.Create;
        Lines.CompanyCode := 'ZZZZ01';
        Lines.FromClause  := 'FROM [COMPANY].DETAILS';
        Lines.WhereClause := 'WHERE tlFolioNum = 1234';

        // Access using SQL navigation
        Lines.OpenFile;
        Lines.First;
        while not Lines.Eof do
        begin
          Id := Lines.ReadRecord;
          Lines.Next;
        end;

        // Access using line index
        Lines.OpenFile;
        for i := 0 to Lines.Count - 1 do
        begin
          Id := Lines[i]; // Equivalent of Lines.Line[i];
        end;
      end;
  }
  TSQLSelectTransactionLines = class(TSQLTransactionLines)
  public
    FromClause: AnsiString;
    JoinClause: AnsiString;
    WhereClause: AnsiString;
    OrderByClause: AnsiString;

    { Executes the SQL query to retrieve the recordset. }
    procedure OpenFile; override;

    { Checks that any required properties have been assigned values. Returns
      False if the validation fails and puts a description of the problem into
      ValidationError. }
    function Validate: Boolean;

  end;

  // ===========================================================================

  {
    Class for retrieving transaction lines via a stored procedure.

    The CompanyCode and StoredProcedure variables must be initialised.

    Call OpenFile to read the records, then either navigate through them using
    First and Next, or read the lines directly using the Line[] index property
    (use Count to determine how many lines there are).

    Retrieve the current record using ReadRecord, which returns an IDetail
    structure.

    Example:

      var
        Lines: TSQLStoredProcedureTransactionLines;
        Id: IDetail;
      begin
        Lines := TSQLStoredProcedureTransactionLines.Create;
        Lines.CompanyCode := 'ZZZZ01';
        Lines.StoredProcedure := 'EXEC [COMPANY].esp_GLJobActual';

        // Access using SQL navigation
        Lines.OpenFile;
        Lines.First;
        while not Lines.Eof do
        begin
          Id := Lines.ReadRecord;
          Lines.Next;
        end;

        // Access using line index
        Lines.OpenFile;
        for i := 0 to Lines.Count - 1 do
        begin
          Id := Lines[i]; // Equivalent of Lines.Line[i];
        end;
      end;
  }
  TSQLStoredProcedureTransactionLines = class(TSQLTransactionLines)
  public
    StoredProcedure: AnsiString;

    { Executes the stored procedure to retrieve the recordset. }
    procedure OpenFile; override;

    { Checks that any required properties have been assigned values. Returns
      False if the validation fails and puts a description of the problem into
      ValidationError. }
    function Validate: Boolean;

  end;

implementation

// =============================================================================
// TSQLTransactionLines
// =============================================================================

procedure TSQLTransactionLines.CloseFile;
begin
  if SQLCaller.Records.Active then
    SQLCaller.Records.Close;
end;

// -----------------------------------------------------------------------------

function TSQLTransactionLines.Count: Integer;
begin
  if SQLCaller.Records.Active then
    Result := SQLCaller.Records.RecordCount
  else
    Result := 0;
end;

// -----------------------------------------------------------------------------

constructor TSQLTransactionLines.Create;
begin
  inherited;
  UsingInternalSQLCaller := False;
  FieldsPrepared := False;
  QryCount := 0;
  Columns := 'tlFolioNum, tlLineNo, tlRunNo, tlGLCode, tlNominalMode, ' +
             'tlCurrency, tlYear, tlPeriod, tlDepartment, tlCostCentre, ' +
             'tlStockCode, tlABSLineNo, tlLineType, tlDocType, tlDLLUpdate, ' +
             'tlOldSerialQty, tlQty, tlQtyMul, tlNetValue, tlDiscount, ' +
             'tlVATCode, tlVATAmount, tlPaymentCode, tlOldPBal, tlRecStatus, ' +
             'tlDiscFlag, tlQtyWOFF, tlQtyDel, tlCost, tlAcCode, tlLineDate, ' +
             'tlItemNo, tlDescription, tlJobCode, tlAnalysisCode, tlCompanyRate, ' +
             'tlDailyRate, tlUnitWeight, tlStockDeductQty, tlBOMKitLink, ' +
             'tlSOPFolioNum, tlSOPABSLineNo, tlLocation, tlQtyPicked, ' +
             'tlQtyPickedWO, tlUsePack, tlSerialQty, tlCOSNomCode, tlOurRef, ' +
             'tlDocLTLink, tlPrxPack, tlQtyPack, tlReconciliationDate, ' +
             'tlShowCase, tlSdbFolio, tlOriginalBaseValue, tlUseOriginalRates, ' +
             'tlUserField1, tlUserField2, tlUserField3, tlUserField4, ' +
             'tlSSDUpliftPerc, tlSSDCountry, tlInclusiveVATCode, tlSSDCommodCode, ' +
             'tlSSDSalesUnit, tlPriceMultiplier, tlB2BLinkFolio, tlB2BLineNo, ' +
             'tlTriRates, tlTriEuro, tlTriInvert, tlTriFloat, tlSpare1, ' +
             'tlSSDUseLineValues, tlPreviousBalance, tlLiveUplift, ' +
             'tlCOSDailyRate, tlVATIncValue, tlLineSource, tlCISRateCode, ' +
             'tlCISRate, tlCostApport, tlNOMIOFlag, tlBinQty, tlCISAdjustment, ' +
             'tlDeductionType, tlSerialReturnQty, tlBinReturnQty, tlDiscount2, ' +
             'tlDiscount2Chr, tlDiscount3, tlDiscount3Chr, tlDiscount3Type, ' +
             'tlECService, tlServiceStartDate, tlServiceEndDate, ' +
             'tlECSalesTaxReported, tlPurchaseServiceTax, tlReference, ' +
             'tlReceiptNo, tlFromPostCode, tlToPostCode, tlUserField5, ' +
             'tlUserField6, tlUserField7, tlUserField8, tlUserField9, ' +
             'tlUserField10, tlThresholdCode, tlMaterialsOnlyRetention, ' +
             'tlIntrastatNoTC, ' +
             // MH 21/03/2016 2016-R2 ABSEXCH-17379: New Tax Region field for Multi-Region Tax
             'tlTaxRegion';
end;

// -----------------------------------------------------------------------------

destructor TSQLTransactionLines.Destroy;
begin
  try
    if SQLCaller.Records.Active then
      SQLCaller.Records.Close;

    if UsingInternalSQLCaller then
      FreeAndNil(SQLCaller);
  except
    on Exception do ;
  end;

  inherited;
end;

// -----------------------------------------------------------------------------

function TSQLTransactionLines.EOF: Boolean;
begin
  if SQLCaller.Records.Active then
    Result := SQLCaller.Records.Eof
  else
    Result := True;
end;

// -----------------------------------------------------------------------------

procedure TSQLTransactionLines.First;
begin
  if SQLCaller.Records.Active then
    SQLCaller.Records.First
  else
    OnError('TSQLTransactionLines.First: the SQL record-set is not open');
end;

// -----------------------------------------------------------------------------

function TSQLTransactionLines.GetLine(Idx: Integer): IDetail;
begin
  if SQLCaller.Records.Active then
  begin
    { Jump to the requested record position, and read the record into the
      internal IDetail record }
    try
      SQLCaller.Records.RecNo := Idx;
      { Return a copy of the internal IDetail record }
      Result := ReadRecord;
    except
      on E:Exception do
        OnError('TSQLTransactionLines.GetLine: ' + E.Message);
    end;
  end
  else
    OnError('TSQLTransactionLines.GetLine: the SQL record-set is not open');
end;

// -----------------------------------------------------------------------------

procedure TSQLTransactionLines.Next;
begin
  if SQLCaller.Records.Active then
    SQLCaller.Records.Next
  else
    OnError('TSQLTransactionLines.Next: the SQL record-set is not open');
end;

// -----------------------------------------------------------------------------

procedure TSQLTransactionLines.OnError(Msg: string);
begin
  if Assigned(Logger) then
    Logger.LogError(Msg);
  raise Exception.Create(Msg);
end;

// -----------------------------------------------------------------------------

procedure TSQLTransactionLines.PrepareFields;
begin
//  if not FieldsPrepared then
  begin
    fldFolioNum := SqlCaller.Records.FieldByName('tlFolioNum') As TIntegerField;
    fldLineNo := SqlCaller.Records.FieldByName('tlLineNo') As TIntegerField;
    fldRunNo := SqlCaller.Records.FieldByName('tlRunNo') As TIntegerField;
    fldGLCode := SqlCaller.Records.FieldByName('tlGLCode') As TIntegerField;
    fldNominalMode := SqlCaller.Records.FieldByName('tlNominalMode') As TIntegerField;
    fldCurrency := SqlCaller.Records.FieldByName('tlCurrency') As TIntegerField;
    fldYear := SqlCaller.Records.FieldByName('tlYear') As TIntegerField;
    fldPeriod := SqlCaller.Records.FieldByName('tlPeriod') As TIntegerField;
    fldDepartment := SqlCaller.Records.FieldByName('tlDepartment') As TStringField;
    fldCostCentre := SqlCaller.Records.FieldByName('tlCostCentre') As TStringField;
    fldStockCode := SqlCaller.Records.FieldByName('tlStockCode') As TBinaryField;
    fldABSLineNo := SqlCaller.Records.FieldByName('tlABSLineNo') As TIntegerField;
    fldLineType := SqlCaller.Records.FieldByName('tlLineType') As TStringField;
    fldDocType := SqlCaller.Records.FieldByName('tlDocType') As TIntegerField;
    fldDLLUpdate := SqlCaller.Records.FieldByName('tlDLLUpdate') As TIntegerField;
    fldOldSerialQty := SqlCaller.Records.FieldByName('tlOldSerialQty') As TIntegerField;
    fldQty := SqlCaller.Records.FieldByName('tlQty') As TFloatField;
    fldQtyMul := SqlCaller.Records.FieldByName('tlQtyMul') As TFloatField;
    fldNetValue := SqlCaller.Records.FieldByName('tlNetValue') As TFloatField;
    fldDiscount := SqlCaller.Records.FieldByName('tlDiscount') As TFloatField;
    fldVATCode := SqlCaller.Records.FieldByName('tlVATCode') As TStringField;
    fldVATAmount := SqlCaller.Records.FieldByName('tlVATAmount') As TFloatField;
    fldPaymentCode := SqlCaller.Records.FieldByName('tlPaymentCode') As TStringField;
    fldOldPBal := SqlCaller.Records.FieldByName('tlOldPBal') As TFloatField;
    fldRecStatus := SqlCaller.Records.FieldByName('tlRecStatus') As TIntegerField;
    fldDiscFlag := SqlCaller.Records.FieldByName('tlDiscFlag') As TStringField;
    fldQtyWOFF := SqlCaller.Records.FieldByName('tlQtyWOFF') As TFloatField;
    fldQtyDel := SqlCaller.Records.FieldByName('tlQtyDel') As TFloatField;
    fldCost := SqlCaller.Records.FieldByName('tlCost') As TFloatField;
    fldAcCode := SqlCaller.Records.FieldByName('tlAcCode') As TStringField;
    fldLineDate := SqlCaller.Records.FieldByName('tlLineDate') As TStringField;
    fldItemNo := SqlCaller.Records.FieldByName('tlItemNo') As TStringField;
    fldDescription := SqlCaller.Records.FieldByName('tlDescription') As TStringField;
    fldJobCode := SqlCaller.Records.FieldByName('tlJobCode') As TStringField;
    fldAnalysisCode := SqlCaller.Records.FieldByName('tlAnalysisCode') As TStringField;
    fldCompanyRate := SqlCaller.Records.FieldByName('tlCompanyRate') As TFloatField;
    fldDailyRate := SqlCaller.Records.FieldByName('tlDailyRate') As TFloatField;
    fldUnitWeight := SqlCaller.Records.FieldByName('tlUnitWeight') As TFloatField;
    fldStockDeductQty := SqlCaller.Records.FieldByName('tlStockDeductQty') As TFloatField;
    fldBOMKitLink := SqlCaller.Records.FieldByName('tlBOMKitLink') As TIntegerField;
    fldSOPFolioNum := SqlCaller.Records.FieldByName('tlSOPFolioNum') As TIntegerField;
    fldSOPABSLineNo := SqlCaller.Records.FieldByName('tlSOPABSLineNo') As TIntegerField;
    fldLocation := SqlCaller.Records.FieldByName('tlLocation') As TStringField;
    fldQtyPicked := SqlCaller.Records.FieldByName('tlQtyPicked') As TFloatField;
    fldQtyPickedWO := SqlCaller.Records.FieldByName('tlQtyPickedWO') As TFloatField;
    fldUsePack := SqlCaller.Records.FieldByName('tlUsePack') As TBooleanField;
    fldSerialQty := SqlCaller.Records.FieldByName('tlSerialQty') As TFloatField;
    fldCOSNomCode := SqlCaller.Records.FieldByName('tlCOSNomCode') As TIntegerField;
    fldOurRef := SqlCaller.Records.FieldByName('tlOurRef') As TStringField;
    fldDocLTLink := SqlCaller.Records.FieldByName('tlDocLTLink') As TIntegerField;
    fldPrxPack := SqlCaller.Records.FieldByName('tlPrxPack') As TBooleanField;
    fldQtyPack := SqlCaller.Records.FieldByName('tlQtyPack') As TFloatField;
    fldReconciliationDate := SqlCaller.Records.FieldByName('tlReconciliationDate') As TStringField;
    fldShowCase := SqlCaller.Records.FieldByName('tlShowCase') As TBooleanField;
    fldSdbFolio := SqlCaller.Records.FieldByName('tlSdbFolio') As TIntegerField;
    fldOriginalBaseValue := SqlCaller.Records.FieldByName('tlOriginalBaseValue') As TFloatField;
    fldUseOriginalRates := SqlCaller.Records.FieldByName('tlUseOriginalRates') As TIntegerField;
    fldUserField1 := SqlCaller.Records.FieldByName('tlUserField1') As TStringField;
    fldUserField2 := SqlCaller.Records.FieldByName('tlUserField2') As TStringField;
    fldUserField3 := SqlCaller.Records.FieldByName('tlUserField3') As TStringField;
    fldUserField4 := SqlCaller.Records.FieldByName('tlUserField4') As TStringField;
    fldSSDUpliftPerc := SqlCaller.Records.FieldByName('tlSSDUpliftPerc') As TFloatField;
    fldSSDCountry := SqlCaller.Records.FieldByName('tlSSDCountry') As TStringField;
    fldInclusiveVATCode := SqlCaller.Records.FieldByName('tlInclusiveVATCode') As TStringField;
    fldSSDCommodCode := SqlCaller.Records.FieldByName('tlSSDCommodCode') As TStringField;
    fldSSDSalesUnit := SqlCaller.Records.FieldByName('tlSSDSalesUnit') As TFloatField;
    fldPriceMultiplier := SqlCaller.Records.FieldByName('tlPriceMultiplier') As TFloatField;
    fldB2BLinkFolio := SqlCaller.Records.FieldByName('tlB2BLinkFolio') As TIntegerField;
    fldB2BLineNo := SqlCaller.Records.FieldByName('tlB2BLineNo') As TIntegerField;
    fldTriRates := SqlCaller.Records.FieldByName('tlTriRates') As TFloatField;
    fldTriEuro := SqlCaller.Records.FieldByName('tlTriEuro') As TIntegerField;
    fldTriInvert := SqlCaller.Records.FieldByName('tlTriInvert') As TBooleanField;
    fldTriFloat := SqlCaller.Records.FieldByName('tlTriFloat') As TBooleanField;
    fldSpare1 := SqlCaller.Records.FieldByName('tlSpare1') As TBinaryField;
    fldSSDUseLineValues := SqlCaller.Records.FieldByName('tlSSDUseLineValues') As TBooleanField;
    fldPreviousBalance := SqlCaller.Records.FieldByName('tlPreviousBalance') As TFloatField;
    fldLiveUplift := SqlCaller.Records.FieldByName('tlLiveUplift') As TBooleanField;
    fldCOSDailyRate := SqlCaller.Records.FieldByName('tlCOSDailyRate') As TFloatField;
    fldVATIncValue := SqlCaller.Records.FieldByName('tlVATIncValue') As TFloatField;
    fldLineSource := SqlCaller.Records.FieldByName('tlLineSource') As TIntegerField;
    fldCISRateCode := SqlCaller.Records.FieldByName('tlCISRateCode') As TStringField;
    fldCISRate := SqlCaller.Records.FieldByName('tlCISRate') As TFloatField;
    fldCostApport := SqlCaller.Records.FieldByName('tlCostApport') As TFloatField;
    fldNOMIOFlag := SqlCaller.Records.FieldByName('tlNOMIOFlag') As TIntegerField;
    fldBinQty := SqlCaller.Records.FieldByName('tlBinQty') As TFloatField;
    fldCISAdjustment := SqlCaller.Records.FieldByName('tlCISAdjustment') As TFloatField;
    fldDeductionType := SqlCaller.Records.FieldByName('tlDeductionType') As TIntegerField;
    fldSerialReturnQty := SqlCaller.Records.FieldByName('tlSerialReturnQty') As TFloatField;
    fldBinReturnQty := SqlCaller.Records.FieldByName('tlBinReturnQty') As TFloatField;
    fldDiscount2 := SqlCaller.Records.FieldByName('tlDiscount2') As TFloatField;
    fldDiscount2Chr := SqlCaller.Records.FieldByName('tlDiscount2Chr') As TStringField;
    fldDiscount3 := SqlCaller.Records.FieldByName('tlDiscount3') As TFloatField;
    fldDiscount3Chr := SqlCaller.Records.FieldByName('tlDiscount3Chr') As TStringField;
    fldDiscount3Type := SqlCaller.Records.FieldByName('tlDiscount3Type') As TIntegerField;
    fldECService := SqlCaller.Records.FieldByName('tlECService') As TBooleanField;
    fldServiceStartDate := SqlCaller.Records.FieldByName('tlServiceStartDate') As TStringField;
    fldServiceEndDate := SqlCaller.Records.FieldByName('tlServiceEndDate') As TStringField;
    fldECSalesTaxReported := SqlCaller.Records.FieldByName('tlECSalesTaxReported') As TFloatField;
    fldPurchaseServiceTax := SqlCaller.Records.FieldByName('tlPurchaseServiceTax') As TFloatField;
    fldReference := SqlCaller.Records.FieldByName('tlReference') As TStringField;
    fldReceiptNo := SqlCaller.Records.FieldByName('tlReceiptNo') As TStringField;
    fldFromPostCode := SqlCaller.Records.FieldByName('tlFromPostCode') As TStringField;
    fldToPostCode := SqlCaller.Records.FieldByName('tlToPostCode') As TStringField;
    fldUserField5 := SqlCaller.Records.FieldByName('tlUserField5') As TStringField;
    fldUserField6 := SqlCaller.Records.FieldByName('tlUserField6') As TStringField;
    fldUserField7 := SqlCaller.Records.FieldByName('tlUserField7') As TStringField;
    fldUserField8 := SqlCaller.Records.FieldByName('tlUserField8') As TStringField;
    fldUserField9 := SqlCaller.Records.FieldByName('tlUserField9') As TStringField;
    fldUserField10 := SqlCaller.Records.FieldByName('tlUserField10') As TStringField;
    fldThresholdCode := SqlCaller.Records.FieldByName('tlThresholdCode') As TStringField;
    fldMaterialsOnlyRetention := SqlCaller.Records.FieldByName('tlMaterialsOnlyRetention') As TBooleanField;
    // CJS 2015-12-15 - 2016 R1 - Intrastat - A1.4 - new Transaction Line (Details) field
    fldIntrastatNoTC := SqlCaller.Records.FieldByName('tlIntrastatNoTC') AS TStringField;
    // MH 21/03/2016 2016-R2 ABSEXCH-17379: New Tax Region field for Multi-Region Tax
    fldTaxRegion := SqlCaller.Records.FieldByName('tlTaxRegion') As TIntegerField;

    FieldsPrepared := True;
  end;
end;

// -----------------------------------------------------------------------------

function TSQLTransactionLines.ReadRecord: IDetail;
begin
  ReadRecordInto(Id);
  Result := Id;
end;

// -----------------------------------------------------------------------------

procedure TSQLTransactionLines.ReadRecordInto(var IdR: IDetail);
var
  V : Variant;
  VarArray : ^TByteArray;
  I: Integer;

  { Function to return the first character from a string, returning #0 if
    the string is empty }
  function SafeReadChar(Value: string): char;
  begin
    if (Value <> '') then
      Result := Value[1]
    else
      Result := #0;
  end;

begin
  // Copy the returned columns into the Transaction Line
  FillChar (IdR, SizeOf (IDetail), #0);
  With IdR Do
  Begin
    FolioRef := fldFolioNum.Value;
    LineNo := fldLineNo.Value;
    PostedRun := fldRunNo.Value;
    NomCode := fldGLCode.Value;
    NomMode := fldNominalMode.Value;
    Currency := fldCurrency.Value;
    PYr  := fldYear.Value;
    PPr  := fldPeriod.Value;
    CCDep[BOff] := fldDepartment.Value;
    CCDep[BOn] := fldCostCentre.Value;

    // Process the Binary StockCode field
    V := fldStockCode.AsVariant;
    If VarIsArray(V) Then
    Begin
      // Map byte array onto StockCode field
      VarArray := @StockCode;
      For I := VarArrayLowBound(V,1) To VarArrayHighBound(V,1) Do
        If (I <= SizeOf(StockCode)) Then
          VarArray[i] := V[I]
        Else
          Break;
    End; // If VarIsArray(V)

    ABSLineNo := fldABSLineNo.Value;
    LineType := SafeReadChar(fldLineType.Value);
    IdDocHed := DocTypes(fldDocType.Value);
    DLLUpdate := fldDLLUpdate.Value;
    OldSerQty := fldOldSerialQty.Value;
    Qty := fldQty.Value;
    QtyMul := fldQtyMul.Value;
    NetValue := fldNetValue.Value;
    Discount := fldDiscount.Value;
    VATCode := SafeReadChar(fldVATCode.Value);
    VAT := fldVATAmount.Value;
    Payment := SafeReadChar(fldPaymentCode.Value);
    OldPBal := fldOldPBal.Value;
    Reconcile := fldRecStatus.Value;
    DiscountChr:= SafeReadChar(fldDiscFlag.Value);
    QtyWOFF := fldQtyWOFF.Value;
    QtyDel := fldQtyDel.Value;
    CostPrice := fldCost.Value;
    CustCode := fldAcCode.Value;
    PDate := fldLineDate.Value;
    Item := fldItemNo.Value;
    Desc := fldDescription.Value;
    JobCode := fldJobCode.Value;
    AnalCode := fldAnalysisCode.Value;
    CXrate[BOff] := fldCompanyRate.Value;
    CXrate[BOn] := fldDailyRate.Value;
    LWeight := fldUnitWeight.Value;
    DeductQty := fldStockDeductQty.Value;
    KitLink := fldBOMKitLink.Value;
    SOPLink := fldSOPFolioNum.Value;
    SOPLineNo := fldSOPABSLineNo.Value;
    MLocStk := fldLocation.Value;
    QtyPick := fldQtyPicked.Value;
    QtyPWOff := fldQtyPickedWO.Value;
    UsePack := fldUsePack.Value;
    SerialQty := fldSerialQty.Value;
    COSNomCode := fldCOSNomCode.Value;
    DocPRef := fldOurRef.Value;
    DocLTLink := fldDocLTLink.Value;
    PrxPack := fldPrxPack.Value;
    QtyPack := fldQtyPack.Value;
    ReconDate := fldReconciliationDate.Value;
    ShowCase := fldShowCase.Value;
    sdbFolio := fldSdbFolio.Value;
    OBaseEquiv := fldOriginalBaseValue.Value;
    UseORate := fldUseOriginalRates.Value;
    LineUser1 := fldUserField1.Value;
    LineUser2 := fldUserField2.Value;
    LineUser3 := fldUserField3.Value;
    LineUser4 := fldUserField4.Value;
    SSDUplift := fldSSDUpliftPerc.Value;
    SSDCountry := fldSSDCountry.Value;
    VATIncFlg := SafeReadChar(fldInclusiveVATCode.Value);
    SSDCommod := fldSSDCommodCode.Value;
    SSDSPUnit := fldSSDSalesUnit.Value;
    PriceMulx := fldPriceMultiplier.Value;
    B2BLink := fldB2BLinkFolio.Value;
    B2BLineNo := fldB2BLineNo.Value;
    CurrTriR.TriRates := fldTriRates.Value;
    CurrTriR.TriEuro := fldTriEuro.Value;
    CurrTriR.TriInvert := fldTriInvert.Value;
    CurrTriR.TriFloat := fldTriFloat.Value;
    // Process the Binary CurrTriR.Spare field
    V := fldSpare1.AsVariant;
    If VarIsArray(V) Then
    Begin
      // Map byte array onto CurrTriR.Spare field
      VarArray := @CurrTriR.Spare;
      For I := VarArrayLowBound(V,1) To VarArrayHighBound(V,1) Do
        If (I <= SizeOf(CurrTriR.Spare)) Then
          VarArray[i] := V[I]
        Else
          Break;
    End; // If VarIsArray(V)
    SSDUseLine := fldSSDUseLineValues.Value;
    PreviousBal:= fldPreviousBalance.Value;
    LiveUplift := fldLiveUplift.Value;
    COSConvRate := fldCOSDailyRate.Value;
    IncNetValue := fldVATIncValue.Value;
    AutoLineType := fldLineSource.Value;
    CISRateCode:= SafeReadChar(fldCISRateCode.Value);
    CISRate := fldCISRate.Value;
    CostApport := fldCostApport.Value;
    NOMIOFlg := fldNOMIOFlag.Value;
    BinQty := fldBinQty.Value;
    CISAdjust := fldCISAdjustment.Value;
    JAPDedType := fldDeductionType.Value;
    SerialRetQty := fldSerialReturnQty.Value;
    BinRetQty:= fldBinReturnQty.Value;
    Discount2 := fldDiscount2.Value;
    Discount2Chr := SafeReadChar(fldDiscount2Chr.Value);
    Discount3 := fldDiscount3.Value;
    Discount3Chr := SafeReadChar(fldDiscount3Chr.Value);
    Discount3Type := fldDiscount3Type.Value;
    ECService := fldECService.Value;
    ServiceStartDate := fldServiceStartDate.Value;
    ServiceEndDate := fldServiceEndDate.Value;
    ECSalesTaxReported := fldECSalesTaxReported.Value;
    PurchaseServiceTax := fldPurchaseServiceTax.Value;
    tlReference := fldReference.Value;
    tlReceiptNo := fldReceiptNo.Value;
    tlFromPostCode := fldFromPostCode.Value;
    tlToPostCode := fldToPostCode.Value;
    LineUser5 := fldUserField5.Value;
    LineUser6 := fldUserField6.Value;
    LineUser7 := fldUserField7.Value;
    LineUser8 := fldUserField8.Value;
    LineUser9 := fldUserField9.Value;
    LineUser10 := fldUserField10.Value;
    tlThresholdCode := fldThresholdCode.Value;
    tlMaterialsOnlyRetention := fldMaterialsOnlyRetention.Value;
    // CJS 2015-12-15 - 2016 R1 - Intrastat - A1.4 - new Transaction Line (Details) field
    tlIntrastatNoTC := fldIntrastatNoTC.Value;
    // MH 21/03/2016 2016-R2 ABSEXCH-17379: New Tax Region field for Multi-Region Tax
    tlTaxRegion := fldTaxRegion.Value;
  End; // With CompObj.CompanyBtr.LId
end;

// -----------------------------------------------------------------------------

function TSQLTransactionLines.Validate: Boolean;
begin
  Result := True;
  ValidationError := '';
end;

// =============================================================================
// TSQLSelectTransactionLines
// =============================================================================

procedure TSQLSelectTransactionLines.OpenFile;
var
  ConnStr: AnsiString;
  Qry: string;
begin
  if not Assigned(SQLCaller) then
  begin
    //RB 06/07/2017 2017-R2 ABSEXCH-18944: Use Global SQL Connection for SQLCaller
    SQLCaller := TSQLCaller.Create(GlobalADOConnection);
    UsingInternalSQLCaller := True;
  end;

  if SQLCaller.Records.Active then
    SQLCaller.Records.Close;
  if Validate then
  begin
    { Build the full query from the assigned parts, and retrieve the recordset }
    Qry := Format('SELECT %s %s %s %s %s', [Columns, FromClause, JoinClause, WhereClause, OrderByClause]);
    SQLCaller.Select(Qry, CompanyCode);

    if (SQLCaller.ErrorMsg = '') then
    begin
      PrepareFields;
      { Disable the link to the UI to improve performance when iterating through
        the dataset }
      SQLCaller.Records.DisableControls;
    end
    else
      OnError('TSQLTransactionLines.OpenFile: ' + SQLCaller.ErrorMsg);
  end
  else
    { Validation failed }
    OnError('TSQLTransactionLines.OpenFile: ' + ValidationError);
end;

// -----------------------------------------------------------------------------

function TSQLSelectTransactionLines.Validate: Boolean;
begin
  Result := True;
  ValidationError := '';
  if (Trim(CompanyCode) = '') then
  begin
    ValidationError := 'No company code assigned';
    Result := False;
  end
  else if (Trim(FromClause) = '') then
  begin
    ValidationError := 'No "From" clause assigned';
    Result := False;
  end
  else if (Pos('FROM ', Uppercase(FromClause)) = 0) then
  begin
    ValidationError := 'Invalid "From" clause (must contain "FROM")';
    Result := False;
  end
  else if (Trim(JoinClause) <> '') and (Pos('JOIN ', Uppercase(JoinClause)) = 0) then
  begin
    ValidationError := 'Invalid "JOIN" clause (must contain "JOIN")';
    Result := False;
  end
  else if (Trim(WhereClause) <> '') and (Pos('WHERE ', Uppercase(WhereClause)) = 0) then
  begin
    ValidationError := 'Invalid "WHERE" clause (must contain "WHERE")';
    Result := False;
  end
  else if (Trim(OrderByClause) <> '') and (Pos('ORDER BY ', Uppercase(OrderByClause)) = 0) then
  begin
    ValidationError := 'Invalid "ORDER BY" clause (must contain "ORDER BY")';
    Result := False;
  end
  else if (Trim(WhereClause) = '') then
  begin
    ValidationError := 'A WHERE clause is required';
    Result := False;
  end;
end;

// =============================================================================
// TSQLStoredProcedureTransactionLines
// =============================================================================

procedure TSQLStoredProcedureTransactionLines.OpenFile;
var
  ConnStr: AnsiString;
  Qry: string;
begin
  if not Assigned(SQLCaller) then
  begin
    //RB 06/07/2017 2017-R2 ABSEXCH-18944: Use Global SQL Connection for SQLCaller
    SQLCaller := TSQLCaller.Create(GlobalADOConnection);
    UsingInternalSQLCaller := True;
  end;

  if SQLCaller.Records.Active then
    SQLCaller.Records.Close;
  if Validate then
  begin
    { Build the full query from the assigned parts, and retrieve the recordset }
    Qry := StoredProcedure;
    SQLCaller.Select(Qry, CompanyCode);

    if (SQLCaller.ErrorMsg = '') then
    begin
      if (Count > 0) then
      begin
        PrepareFields;
        { Disable the link to the UI to improve performance when iterating through
          the dataset }
        SQLCaller.Records.DisableControls;
      end;
    end
    else
      OnError('TSQLStoredProcedureTransactionLines.OpenFile: ' + SQLCaller.ErrorMsg);
  end
  else
    { Validation failed }
    OnError('TSQLStoredProcedureTransactionLines.OpenFile: ' + ValidationError);
end;

// -----------------------------------------------------------------------------

function TSQLStoredProcedureTransactionLines.Validate: Boolean;
begin
  Result := True;
  ValidationError := '';
  if (Trim(CompanyCode) = '') then
  begin
    ValidationError := 'No company code assigned';
    Result := False;
  end
  else if Trim(StoredProcedure) = '' then
  begin
    ValidationError := 'No stored procedure assigned';
    Result := False;
  end;
end;

end.
