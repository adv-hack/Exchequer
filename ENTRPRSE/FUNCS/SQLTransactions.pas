unit SQLTransactions;

interface

//
// NOTE: Copies from SQLTransactionLines.pas
//

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
  ADOConnect;

type
  { Array-type for accessing binary fields (see ReadRecord) }
  TByteArray = Array [0..255] of Byte;

  {
    Class for retrieving transactions via direct SQL or a stored
    procedure. This is an abstract class, and should not be used -- instead,
    one of the descendant classes.
  }
  TSQLTransactions = class(TObject)
  private
    fldPosition : TIntegerField;

    fldRunNo : TIntegerField;
    fldAcCode : TStringField;
    fldNomAuto : TBooleanField;
    fldOurRef : TStringField;
    fldFolioNum : TIntegerField;
    fldCurrency : TIntegerField;
    fldYear : TIntegerField;
    fldPeriod : TIntegerField;
    fldDueDate : TStringField;
    fldVATPostDate : TStringField;
    fldTransDate : TStringField;
    fldCustSupp : TStringField;
    fldCompanyRate : TFloatField;
    fldDailyRate : TFloatField;
    fldOldYourRef : TStringField;
    fldBatchLink : TBinaryField;
    fldOutstanding : TStringField;
    fldNextLineNumber : TIntegerField;
    fldNextNotesLineNumber : TIntegerField;
    fldDocType : TIntegerField;
    fldVATAnalysisStandard : TFloatField;
    fldVATAnalysisExempt : TFloatField;
    fldVATAnalysisZero : TFloatField;
    fldVATAnalysisRate1 : TFloatField;
    fldVATAnalysisRate2 : TFloatField;
    fldVATAnalysisRate3 : TFloatField;
    fldVATAnalysisRate4 : TFloatField;
    fldVATAnalysisRate5 : TFloatField;
    fldVATAnalysisRate6 : TFloatField;
    fldVATAnalysisRate7 : TFloatField;
    fldVATAnalysisRate8 : TFloatField;
    fldVATAnalysisRate9 : TFloatField;
    fldVATAnalysisRateT : TFloatField;
    fldVATAnalysisRateX : TFloatField;
    fldVATAnalysisRateB : TFloatField;
    fldVATAnalysisRateC : TFloatField;
    fldVATAnalysisRateF : TFloatField;
    fldVATAnalysisRateG : TFloatField;
    fldVATAnalysisRateR : TFloatField;
    fldVATAnalysisRateW : TFloatField;
    fldVATAnalysisRateY : TFloatField;
    fldVATAnalysisRateIAdj : TFloatField;
    fldVATAnalysisRateOAdj : TFloatField;
    fldVATAnalysisRateSpare : TFloatField;
    fldNetValue : TFloatField;
    fldTotalVAT : TFloatField;
    fldSettleDiscPerc : TFloatField;
    fldSettleDiscAmount : TFloatField;
    fldTotalLineDiscount : TFloatField;
    fldSettleDiscDays : TIntegerField;
    fldSettleDiscTaken : TBooleanField;
    fldAmountSettled : TFloatField;
    fldAutoIncrement : TIntegerField;
    fldUntilYear : TIntegerField;
    fldUntilPeriod : TIntegerField;
    fldTransportNature : TIntegerField;
    fldTransportMode : TIntegerField;
    fldRemitNo : TStringField;
    fldAutoIncrementType : TStringField;
    fldHoldFlag : TIntegerField;
    fldAuditFlag : TBooleanField;
    fldTotalWeight : TFloatField;
    fldDeliveryAddr1 : TStringField;
    fldDeliveryAddr2 : TStringField;
    fldDeliveryAddr3 : TStringField;
    fldDeliveryAddr4 : TStringField;
    fldDeliveryAddr5 : TStringField;
    fldVariance : TFloatField;
    fldTotalOrdered : TFloatField;
    fldTotalReserved : TFloatField;
    fldTotalCost : TFloatField;
    fldTotalInvoiced : TFloatField;
    fldLongYourRef : TBinaryField;
    fldUntilDate : TStringField;
    fldNOMVATIO : TStringField;
    fldExternal : TBooleanField;
    fldPrinted : TBooleanField;
    fldRevalueAdj : TFloatField;
    fldCurrSettled : TFloatField;
    fldSettledVAT : TFloatField;
    fldVATClaimed : TFloatField;
    fldBatchGL : TIntegerField;
    fldAutoPost : TBooleanField;
    fldManualVAT : TBooleanField;
    fldDeliveryTerms : TStringField;
    fldIncludeInPickingRun : TBooleanField;
    fldOperator : TStringField;
    fldNoLabels : TIntegerField;
    fldTagged : TIntegerField;
    fldPickingRunNo : TIntegerField;
    fldOrdMatch : TBooleanField;
    fldDeliveryNoteRef : TStringField;
    fldVATCompanyRate : TFloatField;
    fldVATDailyRate : TFloatField;
    fldOriginalCompanyRate : TFloatField;
    fldOriginalDailyRate : TFloatField;
    fldPostDiscAm : TFloatField;
    fldSpareNomCode : TIntegerField;
    fldPostDiscTaken : TBooleanField;
    fldControlGL : TIntegerField;
    fldJobCode : TStringField;
    fldAnalysisCode : TStringField;
    fldTotalOrderOS : TFloatField;
    fldAppDepartment : TStringField;
    fldAppCostCentre : TStringField;
    fldUserField1 : TStringField;
    fldUserField2 : TStringField;
    fldLineTypeAnalysis1 : TFloatField;
    fldLineTypeAnalysis2 : TFloatField;
    fldLineTypeAnalysis3 : TFloatField;
    fldLineTypeAnalysis4 : TFloatField;
    fldLineTypeAnalysis5 : TFloatField;
    fldLineTypeAnalysis6 : TFloatField;
    fldLastDebtChaseLetter : TIntegerField;
    fldBatchNow : TFloatField;
    fldBatchThen : TFloatField;
    fldUnTagged : TBooleanField;
    fldOriginalBaseValue : TFloatField;
    fldUseOriginalRates : TIntegerField;
    fldOldCompanyRate : TFloatField;
    fldOldDailyRate : TFloatField;
    fldFixedRate : TBooleanField;
    fldUserField3 : TStringField;
    fldUserField4 : TStringField;
    fldProcess : TStringField;
    fldSource : TIntegerField;
    fldCurrencyTriRate : TFloatField;
    fldCurrencyTriEuro : TIntegerField;
    fldCurrencyTriInvert : TBooleanField;
    fldCurrencyTriFloat : TBooleanField;
    fldCurrencyTriSpare : TBinaryField;
    fldVATTriRate : TFloatField;
    fldVATTriEuro : TIntegerField;
    fldVATTriInvert : TBooleanField;
    fldVATTriFloat : TBooleanField;
    fldVATTriSpare : TBinaryField;
    fldOriginalTriRate : TFloatField;
    fldOriginalTriEuro : TIntegerField;
    fldOriginalTriInvert : TBooleanField;
    fldOriginalTriFloat : TBooleanField;
    fldOriginalTriSpare : TBinaryField;
    fldOldOriginalTriRate : TFloatField;
    fldOldOriginalTriEuro : TIntegerField;
    fldOldOriginalTriInvert : TBooleanField;
    fldOldOriginalTriFloat : TBooleanField;
    fldOldOriginalTriSpare : TBinaryField;
    fldPostedDate : TStringField;
    fldPORPickSOR : TBooleanField;
    fldBatchDiscAmount : TFloatField;
    fldPrePost : TIntegerField;
    fldAuthorisedAmnt : TFloatField;
    fldTimeChanged : TStringField;
    fldTimeCreated : TStringField;
    fldCISTaxDue : TFloatField;
    fldCISTaxDeclared : TFloatField;
    fldCISManualTax : TBooleanField;
    fldCISDate : TStringField;
    fldTotalCostApportioned : TFloatField;
    fldCISEmployee : TStringField;
    fldCISTotalGross : TFloatField;
    fldCISSource : TIntegerField;
    fldTimesheetExported : TBooleanField;
    fldCISExcludedFromGross : TFloatField;
    fldWeekMonth : TIntegerField;
    fldWorkflowState : TIntegerField;
    fldOverrideLocation : TStringField;
    fldSpare5 : TBinaryField;
    fldYourRef : TStringField;
    fldUserField5 : TStringField;
    fldUserField6 : TStringField;
    fldUserField7 : TStringField;
    fldUserField8 : TStringField;
    fldUserField9 : TStringField;
    fldUserField10 : TStringField;
    fldDeliveryPostCode : TStringField;
    fldOriginator : TStringField;
    fldCreationTime : TStringField;
    fldCreationDate : TStringField;
    fldOrderPaymentOrderRef : TStringField;
    fldOrderPaymentElement : TIntegerField;
    fldOrderPaymentFlags : TIntegerField;
    fldCreditCardType : TStringField;
    fldCreditCardNumber : TStringField;
    fldCreditCardExpiry : TStringField;
    fldCreditCardAuthorisationNo : TStringField;
    fldCreditCardReferenceNo : TStringField;
    fldCustomData1 : TStringField;
    fldDeliveryCountry : TStringField;
    fldPPDPercentage : TFloatField;
    fldPPDDays : TIntegerField;
    fldPPDGoodsValue : TFloatField;
    fldPPDVATValue : TFloatField;
    fldPPDTaken : TIntegerField;
    fldPPDCreditNote : TBooleanField;
    fldBatchPayPPDStatus : TIntegerField;
    // CJS 2015-12-15 - 2016 R1 - Intrastat - A1.3 - new Transaction Header (Document) field
    fldIntrastatOutOfPeriod: TBooleanField;

    // MH 21/03/2016 2016-R2 ABSEXCH-17378: New Udef Fields for eRCT
    fldUserField11 : TStringField;
    fldUserField12 : TStringField;

    // MH 21/03/2016 2016-R2 ABSEXCH-17379: New Tax Region field for Multi-Region Tax
    fldTaxRegion : TIntegerField;

    //RB 17/11/2017 2018-R1 ABSEXCH-19347: GDPR - Document.Dat Database Changes	
    fldAnonymised : TBooleanField;
    fldAnonymisedDate : TStringField;
    fldAnonymisedTime : TStringField;

    Columns: string;

    QryCount: Integer;

    FieldsPrepared: Boolean;

    { Flag to record whether we are using our own copy of TSQLCaller (and
      hence must free it) rather than an instance supplied by the calling
      routine. }
    UsingInternalSQLCaller: Boolean;

    { Getter for the Line property, returning the specified line. Raises an
      exception if the recordset is not open. }
    function GetHeader(Idx: Integer): InvRec;

    { Checks that any required properties have been assigned values. Returns
      False if the validation fails and puts a description of the problem into
      ValidationError. This should be overridden by descendant classes (this
      base function simply returns True). }
    function Validate: Boolean;

  protected
    ValidationError: string;

  public
    SQLCaller: TSQLCaller;
    Inv: InvRec;
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
    function ReadRecord: InvRec;

    procedure ReadRecordInto(var InvR: InvRec);

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

    property Header[Idx: Integer]: InvRec read GetHeader; default;
  end;

  // ===========================================================================

  {
    Class for retrieving transactions via direct SQL.

    The CompanyCode and FromClause must be initialised, and optionally the
    JoinClause, WhereClause, and OrderByClause.

    Call OpenFile to read the records, then either navigate through them using
    First and Next, or read the transactions directly using the Header[] index property
    (use Count to determine how many transaction headers there are).

    Retrieve the current record using ReadRecord, which returns an InvRec
    structure.

    Example:

      var
        Headers: TSQLSelectTransactions;
        InvR : InvRec;
      begin
        Headers := TSQLSelectTransactions.Create;
        Headers.CompanyCode := 'ZZZZ01';
        Headers.FromClause  := 'FROM [COMPANY].DOCUMENT';
        Headers.WhereClause := 'WHERE thFolioNum = 1234';

        // Access using SQL navigation
        Headers.OpenFile;
        Headers.First;
        while not Headers.Eof do
        begin
          InvR := Headers.ReadRecord;
          Headers.Next;
        end;

        // Access using header index
        Headers.OpenFile;
        for i := 0 to Headers.Count - 1 do
        begin
          InvR := Headers[i]; // Equivalent of Headers.Header[i];
        end;
      end;
  }
  TSQLSelectTransactions = class(TSQLTransactions)
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
    Class for retrieving transactions via a stored procedure.

    The CompanyCode and StoredProcedure variables must be initialised.

    Call OpenFile to read the records, then either navigate through them using
    First and Next, or read the headers directly using the Header[] index property
    (use Count to determine how many transaction headers there are).

    Retrieve the current record using ReadRecord, which returns an InvRec
    structure.

    Example:

      var
        Headers: TSQLStoredProcedureTransactions;
        InvR : InvRec;
      begin
        Headers := TSQLStoredProcedureTransactions.Create;
        Headers.CompanyCode := 'ZZZZ01';
        Headers.StoredProcedure := 'EXEC [COMPANY].esp_Wibble';

        // Access using SQL navigation
        Headers.OpenFile;
        Headers.First;
        while not Headers.Eof do
        begin
          InvR := Headers.ReadRecord;
          Headers.Next;
        end;

        // Access using Header index
        Headers.OpenFile;
        for i := 0 to Headers.Count - 1 do
        begin
          InvR := Header[i]; // Equivalent of Headers.Header[i];
        end;
      end;
  }
  TSQLStoredProcedureTransactions = class(TSQLTransactions)
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
// TSQLTransactions
// =============================================================================

procedure TSQLTransactions.CloseFile;
begin
  if SQLCaller.Records.Active then
    SQLCaller.Records.Close;
end;

// -----------------------------------------------------------------------------

function TSQLTransactions.Count: Integer;
begin
  if SQLCaller.Records.Active then
    Result := SQLCaller.Records.RecordCount
  else
    Result := 0;
end;

// -----------------------------------------------------------------------------

constructor TSQLTransactions.Create;
begin
  inherited;
  UsingInternalSQLCaller := False;
  FieldsPrepared := False;
  QryCount := 0;
  Columns := 'thRunNo, thAcCode, thNomAuto, thOurRef, thFolioNum, thCurrency, thYear, ' +
             'thPeriod, thDueDate, thVATPostDate, thTransDate, thCustSupp, thCompanyRate, ' +
             'thDailyRate, thOldYourRef, thBatchLink, thOutstanding, thNextLineNumber, ' +
             'thNextNotesLineNumber, thDocType, thVATAnalysisStandard, thVATAnalysisExempt, ' +
             'thVATAnalysisZero, thVATAnalysisRate1, thVATAnalysisRate2, thVATAnalysisRate3, ' +
             'thVATAnalysisRate4, thVATAnalysisRate5, thVATAnalysisRate6, thVATAnalysisRate7, ' +
             'thVATAnalysisRate8, thVATAnalysisRate9, thVATAnalysisRateT, thVATAnalysisRateX, ' +
             'thVATAnalysisRateB, thVATAnalysisRateC, thVATAnalysisRateF, thVATAnalysisRateG, ' +
             'thVATAnalysisRateR, thVATAnalysisRateW, thVATAnalysisRateY, thVATAnalysisRateIAdj, ' +
             'thVATAnalysisRateOAdj, thVATAnalysisRateSpare, thNetValue, thTotalVAT, ' +
             'thSettleDiscPerc, thSettleDiscAmount, thTotalLineDiscount, thSettleDiscDays, ' +
             'thSettleDiscTaken, thAmountSettled, thAutoIncrement, thUntilYear, ' +
             'thUntilPeriod, thTransportNature, thTransportMode, thRemitNo, thAutoIncrementType, ' +
             'thHoldFlag, thAuditFlag, thTotalWeight, thDeliveryAddr1, thDeliveryAddr2, ' +
             'thDeliveryAddr3, thDeliveryAddr4, thDeliveryAddr5, thVariance, thTotalOrdered, ' +
             'thTotalReserved, thTotalCost, thTotalInvoiced, thLongYourRef, thUntilDate, ' +
             'thNOMVATIO, thExternal, thPrinted, thRevalueAdj, thCurrSettled, thSettledVAT, ' +
             'thVATClaimed, thBatchGL, thAutoPost, thManualVAT, thDeliveryTerms, ' +
             'thIncludeInPickingRun, thOperator, thNoLabels, thTagged, thPickingRunNo, ' +
             'thOrdMatch, thDeliveryNoteRef, thVATCompanyRate, thVATDailyRate, ' +
             'thOriginalCompanyRate, thOriginalDailyRate, PostDiscAm, thSpareNomCode, ' +
             'thPostDiscTaken, thControlGL, thJobCode, thAnalysisCode, thTotalOrderOS, ' +
             'thAppDepartment, thAppCostCentre, thUserField1, thUserField2, thLineTypeAnalysis1, ' +
             'thLineTypeAnalysis2, thLineTypeAnalysis3, thLineTypeAnalysis4, thLineTypeAnalysis5, ' +
             'thLineTypeAnalysis6, thLastDebtChaseLetter, thBatchNow, thBatchThen, ' +
             'thUnTagged, thOriginalBaseValue, thUseOriginalRates, thOldCompanyRate, ' +
             'thOldDailyRate, thFixedRate, thUserField3, thUserField4, thProcess, ' +
             'thSource, thCurrencyTriRate, thCurrencyTriEuro, thCurrencyTriInvert, ' +
             'thCurrencyTriFloat, thCurrencyTriSpare, thVATTriRate, thVATTriEuro, ' +
             'thVATTriInvert, thVATTriFloat, thVATTriSpare, thOriginalTriRate, ' +
             'thOriginalTriEuro, thOriginalTriInvert, thOriginalTriFloat, thOriginalTriSpare, ' +
             'thOldOriginalTriRate, thOldOriginalTriEuro, thOldOriginalTriInvert, ' +
             'thOldOriginalTriFloat, thOldOriginalTriSpare, thPostedDate, thPORPickSOR, ' +
             'thBatchDiscAmount, thPrePost, thAuthorisedAmnt, thTimeChanged, thTimeCreated, ' +
             'thCISTaxDue, thCISTaxDeclared, thCISManualTax, thCISDate, thTotalCostApportioned, ' +
             'thCISEmployee, thCISTotalGross, thCISSource, thTimesheetExported, ' +
             'thCISExcludedFromGross, thWeekMonth, thWorkflowState, thOverrideLocation, ' +
             'thSpare5, thYourRef, thUserField5, thUserField6, thUserField7, thUserField8, ' +
             'thUserField9, thUserField10, thDeliveryPostCode, thOriginator, thCreationTime, ' +
             'thCreationDate, thOrderPaymentOrderRef, thOrderPaymentElement, thOrderPaymentFlags, ' +
             'thCreditCardType, thCreditCardNumber, thCreditCardExpiry, thCreditCardAuthorisationNo, ' +
             'thCreditCardReferenceNo, thCustomData1, thDeliveryCountry, thPPDPercentage, ' +
             'thPPDDays, thPPDGoodsValue, thPPDVATValue, thPPDTaken, thPPDCreditNote, ' +
             'thBatchPayPPDStatus, thIntrastatOutOfPeriod, ' +
             // MH 21/03/2016 2016-R2 ABSEXCH-17378: New Udef Fields for eRCT
             'thUserField11, thUserField12, ' +

             // MH 21/03/2016 2016-R2 ABSEXCH-17379: New Tax Region field for Multi-Region Tax
             'thTaxRegion, ' +

             //RB 17/11/2017 2018-R1 ABSEXCH-19347: GDPR - Document.Dat Database Changes
             'thAnonymised, thAnonymisedDate, thAnonymisedTime';
end;

// -----------------------------------------------------------------------------

destructor TSQLTransactions.Destroy;
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

function TSQLTransactions.EOF: Boolean;
begin
  if SQLCaller.Records.Active then
    Result := SQLCaller.Records.Eof
  else
    Result := True;
end;

// -----------------------------------------------------------------------------

procedure TSQLTransactions.First;
begin
  if SQLCaller.Records.Active then
    SQLCaller.Records.First
  else
    OnError('TSQLTransactions.First: the SQL record-set is not open');
end;

// -----------------------------------------------------------------------------

function TSQLTransactions.GetHeader(Idx: Integer): InvRec;
begin
  if SQLCaller.Records.Active then
  begin
    { Jump to the requested record position, and read the record into the
      internal InvRec record }
    try
      SQLCaller.Records.RecNo := Idx;
      { Return a copy of the internal InvRec record }
      Result := ReadRecord;
    except
      on E:Exception do
        OnError('TSQLTransactions.GetHeader: ' + E.Message);
    end;
  end
  else
    OnError('TSQLTransactions.GetHeader: the SQL record-set is not open');
end;

// -----------------------------------------------------------------------------

procedure TSQLTransactions.Next;
begin
  if SQLCaller.Records.Active then
    SQLCaller.Records.Next
  else
    OnError('TSQLTransactions.Next: the SQL record-set is not open');
end;

// -----------------------------------------------------------------------------

procedure TSQLTransactions.OnError(Msg: string);
begin
  if Assigned(Logger) then
    Logger.LogError(Msg);
  raise Exception.Create(Msg);
end;

// -----------------------------------------------------------------------------

procedure TSQLTransactions.PrepareFields;
begin
//  if not FieldsPrepared then
  begin
    fldRunNo := SqlCaller.Records.FieldByName('thRunNo') As TIntegerField;
    fldAcCode := SqlCaller.Records.FieldByName('thAcCode') As TStringField;
    fldNomAuto := SqlCaller.Records.FieldByName('thNomAuto') As TBooleanField;
    fldOurRef := SqlCaller.Records.FieldByName('thOurRef') As TStringField;
    fldFolioNum := SqlCaller.Records.FieldByName('thFolioNum') As TIntegerField;
    fldCurrency := SqlCaller.Records.FieldByName('thCurrency') As TIntegerField;
    fldYear := SqlCaller.Records.FieldByName('thYear') As TIntegerField;
    fldPeriod := SqlCaller.Records.FieldByName('thPeriod') As TIntegerField;
    fldDueDate := SqlCaller.Records.FieldByName('thDueDate') As TStringField;
    fldVATPostDate := SqlCaller.Records.FieldByName('thVATPostDate') As TStringField;
    fldTransDate := SqlCaller.Records.FieldByName('thTransDate') As TStringField;
    fldCustSupp := SqlCaller.Records.FieldByName('thCustSupp') As TStringField;
    fldCompanyRate := SqlCaller.Records.FieldByName('thCompanyRate') As TFloatField;
    fldDailyRate := SqlCaller.Records.FieldByName('thDailyRate') As TFloatField;
    fldOldYourRef := SqlCaller.Records.FieldByName('thOldYourRef') As TStringField;
    fldBatchLink := SqlCaller.Records.FieldByName('thBatchLink') As TBinaryField;
    fldOutstanding := SqlCaller.Records.FieldByName('thOutstanding') As TStringField;
    fldNextLineNumber := SqlCaller.Records.FieldByName('thNextLineNumber') As TIntegerField;
    fldNextNotesLineNumber := SqlCaller.Records.FieldByName('thNextNotesLineNumber') As TIntegerField;
    fldDocType := SqlCaller.Records.FieldByName('thDocType') As TIntegerField;
    fldVATAnalysisStandard := SqlCaller.Records.FieldByName('thVATAnalysisStandard') As TFloatField;
    fldVATAnalysisExempt := SqlCaller.Records.FieldByName('thVATAnalysisExempt') As TFloatField;
    fldVATAnalysisZero := SqlCaller.Records.FieldByName('thVATAnalysisZero') As TFloatField;
    fldVATAnalysisRate1 := SqlCaller.Records.FieldByName('thVATAnalysisRate1') As TFloatField;
    fldVATAnalysisRate2 := SqlCaller.Records.FieldByName('thVATAnalysisRate2') As TFloatField;
    fldVATAnalysisRate3 := SqlCaller.Records.FieldByName('thVATAnalysisRate3') As TFloatField;
    fldVATAnalysisRate4 := SqlCaller.Records.FieldByName('thVATAnalysisRate4') As TFloatField;
    fldVATAnalysisRate5 := SqlCaller.Records.FieldByName('thVATAnalysisRate5') As TFloatField;
    fldVATAnalysisRate6 := SqlCaller.Records.FieldByName('thVATAnalysisRate6') As TFloatField;
    fldVATAnalysisRate7 := SqlCaller.Records.FieldByName('thVATAnalysisRate7') As TFloatField;
    fldVATAnalysisRate8 := SqlCaller.Records.FieldByName('thVATAnalysisRate8') As TFloatField;
    fldVATAnalysisRate9 := SqlCaller.Records.FieldByName('thVATAnalysisRate9') As TFloatField;
    fldVATAnalysisRateT := SqlCaller.Records.FieldByName('thVATAnalysisRateT') As TFloatField;
    fldVATAnalysisRateX := SqlCaller.Records.FieldByName('thVATAnalysisRateX') As TFloatField;
    fldVATAnalysisRateB := SqlCaller.Records.FieldByName('thVATAnalysisRateB') As TFloatField;
    fldVATAnalysisRateC := SqlCaller.Records.FieldByName('thVATAnalysisRateC') As TFloatField;
    fldVATAnalysisRateF := SqlCaller.Records.FieldByName('thVATAnalysisRateF') As TFloatField;
    fldVATAnalysisRateG := SqlCaller.Records.FieldByName('thVATAnalysisRateG') As TFloatField;
    fldVATAnalysisRateR := SqlCaller.Records.FieldByName('thVATAnalysisRateR') As TFloatField;
    fldVATAnalysisRateW := SqlCaller.Records.FieldByName('thVATAnalysisRateW') As TFloatField;
    fldVATAnalysisRateY := SqlCaller.Records.FieldByName('thVATAnalysisRateY') As TFloatField;
    fldVATAnalysisRateIAdj := SqlCaller.Records.FieldByName('thVATAnalysisRateIAdj') As TFloatField;
    fldVATAnalysisRateOAdj := SqlCaller.Records.FieldByName('thVATAnalysisRateOAdj') As TFloatField;
    fldVATAnalysisRateSpare := SqlCaller.Records.FieldByName('thVATAnalysisRateSpare') As TFloatField;
    fldNetValue := SqlCaller.Records.FieldByName('thNetValue') As TFloatField;
    fldTotalVAT := SqlCaller.Records.FieldByName('thTotalVAT') As TFloatField;
    fldSettleDiscPerc := SqlCaller.Records.FieldByName('thSettleDiscPerc') As TFloatField;
    fldSettleDiscAmount := SqlCaller.Records.FieldByName('thSettleDiscAmount') As TFloatField;
    fldTotalLineDiscount := SqlCaller.Records.FieldByName('thTotalLineDiscount') As TFloatField;
    fldSettleDiscDays := SqlCaller.Records.FieldByName('thSettleDiscDays') As TIntegerField;
    fldSettleDiscTaken := SqlCaller.Records.FieldByName('thSettleDiscTaken') As TBooleanField;
    fldAmountSettled := SqlCaller.Records.FieldByName('thAmountSettled') As TFloatField;
    fldAutoIncrement := SqlCaller.Records.FieldByName('thAutoIncrement') As TIntegerField;
    fldUntilYear := SqlCaller.Records.FieldByName('thUntilYear') As TIntegerField;
    fldUntilPeriod := SqlCaller.Records.FieldByName('thUntilPeriod') As TIntegerField;
    fldTransportNature := SqlCaller.Records.FieldByName('thTransportNature') As TIntegerField;
    fldTransportMode := SqlCaller.Records.FieldByName('thTransportMode') As TIntegerField;
    fldRemitNo := SqlCaller.Records.FieldByName('thRemitNo') As TStringField;
    fldAutoIncrementType := SqlCaller.Records.FieldByName('thAutoIncrementType') As TStringField;
    fldHoldFlag := SqlCaller.Records.FieldByName('thHoldFlag') As TIntegerField;
    fldAuditFlag := SqlCaller.Records.FieldByName('thAuditFlag') As TBooleanField;
    fldTotalWeight := SqlCaller.Records.FieldByName('thTotalWeight') As TFloatField;
    fldDeliveryAddr1 := SqlCaller.Records.FieldByName('thDeliveryAddr1') As TStringField;
    fldDeliveryAddr2 := SqlCaller.Records.FieldByName('thDeliveryAddr2') As TStringField;
    fldDeliveryAddr3 := SqlCaller.Records.FieldByName('thDeliveryAddr3') As TStringField;
    fldDeliveryAddr4 := SqlCaller.Records.FieldByName('thDeliveryAddr4') As TStringField;
    fldDeliveryAddr5 := SqlCaller.Records.FieldByName('thDeliveryAddr5') As TStringField;
    fldVariance := SqlCaller.Records.FieldByName('thVariance') As TFloatField;
    fldTotalOrdered := SqlCaller.Records.FieldByName('thTotalOrdered') As TFloatField;
    fldTotalReserved := SqlCaller.Records.FieldByName('thTotalReserved') As TFloatField;
    fldTotalCost := SqlCaller.Records.FieldByName('thTotalCost') As TFloatField;
    fldTotalInvoiced := SqlCaller.Records.FieldByName('thTotalInvoiced') As TFloatField;
    fldLongYourRef := SqlCaller.Records.FieldByName('thLongYourRef') As TBinaryField;
    fldUntilDate := SqlCaller.Records.FieldByName('thUntilDate') As TStringField;
    fldNOMVATIO := SqlCaller.Records.FieldByName('thNOMVATIO') As TStringField;
    fldExternal := SqlCaller.Records.FieldByName('thExternal') As TBooleanField;
    fldPrinted := SqlCaller.Records.FieldByName('thPrinted') As TBooleanField;
    fldRevalueAdj := SqlCaller.Records.FieldByName('thRevalueAdj') As TFloatField;
    fldCurrSettled := SqlCaller.Records.FieldByName('thCurrSettled') As TFloatField;
    fldSettledVAT := SqlCaller.Records.FieldByName('thSettledVAT') As TFloatField;
    fldVATClaimed := SqlCaller.Records.FieldByName('thVATClaimed') As TFloatField;
    fldBatchGL := SqlCaller.Records.FieldByName('thBatchGL') As TIntegerField;
    fldAutoPost := SqlCaller.Records.FieldByName('thAutoPost') As TBooleanField;
    fldManualVAT := SqlCaller.Records.FieldByName('thManualVAT') As TBooleanField;
    fldDeliveryTerms := SqlCaller.Records.FieldByName('thDeliveryTerms') As TStringField;
    fldIncludeInPickingRun := SqlCaller.Records.FieldByName('thIncludeInPickingRun') As TBooleanField;
    fldOperator := SqlCaller.Records.FieldByName('thOperator') As TStringField;
    fldNoLabels := SqlCaller.Records.FieldByName('thNoLabels') As TIntegerField;
    fldTagged := SqlCaller.Records.FieldByName('thTagged') As TIntegerField;
    fldPickingRunNo := SqlCaller.Records.FieldByName('thPickingRunNo') As TIntegerField;
    fldOrdMatch := SqlCaller.Records.FieldByName('thOrdMatch') As TBooleanField;
    fldDeliveryNoteRef := SqlCaller.Records.FieldByName('thDeliveryNoteRef') As TStringField;
    fldVATCompanyRate := SqlCaller.Records.FieldByName('thVATCompanyRate') As TFloatField;
    fldVATDailyRate := SqlCaller.Records.FieldByName('thVATDailyRate') As TFloatField;
    fldOriginalCompanyRate := SqlCaller.Records.FieldByName('thOriginalCompanyRate') As TFloatField;
    fldOriginalDailyRate := SqlCaller.Records.FieldByName('thOriginalDailyRate') As TFloatField;
    fldPostDiscAm := SqlCaller.Records.FieldByName('PostDiscAm') As TFloatField;
    fldSpareNomCode := SqlCaller.Records.FieldByName('thSpareNomCode') As TIntegerField;
    fldPostDiscTaken := SqlCaller.Records.FieldByName('thPostDiscTaken') As TBooleanField;
    fldControlGL := SqlCaller.Records.FieldByName('thControlGL') As TIntegerField;
    fldJobCode := SqlCaller.Records.FieldByName('thJobCode') As TStringField;
    fldAnalysisCode := SqlCaller.Records.FieldByName('thAnalysisCode') As TStringField;
    fldTotalOrderOS := SqlCaller.Records.FieldByName('thTotalOrderOS') As TFloatField;
    fldAppDepartment := SqlCaller.Records.FieldByName('thAppDepartment') As TStringField;
    fldAppCostCentre := SqlCaller.Records.FieldByName('thAppCostCentre') As TStringField;
    fldUserField1 := SqlCaller.Records.FieldByName('thUserField1') As TStringField;
    fldUserField2 := SqlCaller.Records.FieldByName('thUserField2') As TStringField;
    fldLineTypeAnalysis1 := SqlCaller.Records.FieldByName('thLineTypeAnalysis1') As TFloatField;
    fldLineTypeAnalysis2 := SqlCaller.Records.FieldByName('thLineTypeAnalysis2') As TFloatField;
    fldLineTypeAnalysis3 := SqlCaller.Records.FieldByName('thLineTypeAnalysis3') As TFloatField;
    fldLineTypeAnalysis4 := SqlCaller.Records.FieldByName('thLineTypeAnalysis4') As TFloatField;
    fldLineTypeAnalysis5 := SqlCaller.Records.FieldByName('thLineTypeAnalysis5') As TFloatField;
    fldLineTypeAnalysis6 := SqlCaller.Records.FieldByName('thLineTypeAnalysis6') As TFloatField;
    fldLastDebtChaseLetter := SqlCaller.Records.FieldByName('thLastDebtChaseLetter') As TIntegerField;
    fldBatchNow := SqlCaller.Records.FieldByName('thBatchNow') As TFloatField;
    fldBatchThen := SqlCaller.Records.FieldByName('thBatchThen') As TFloatField;
    fldUnTagged := SqlCaller.Records.FieldByName('thUnTagged') As TBooleanField;
    fldOriginalBaseValue := SqlCaller.Records.FieldByName('thOriginalBaseValue') As TFloatField;
    fldUseOriginalRates := SqlCaller.Records.FieldByName('thUseOriginalRates') As TIntegerField;
    fldOldCompanyRate := SqlCaller.Records.FieldByName('thOldCompanyRate') As TFloatField;
    fldOldDailyRate := SqlCaller.Records.FieldByName('thOldDailyRate') As TFloatField;
    fldFixedRate := SqlCaller.Records.FieldByName('thFixedRate') As TBooleanField;
    fldUserField3 := SqlCaller.Records.FieldByName('thUserField3') As TStringField;
    fldUserField4 := SqlCaller.Records.FieldByName('thUserField4') As TStringField;
    fldProcess := SqlCaller.Records.FieldByName('thProcess') As TStringField;
    fldSource := SqlCaller.Records.FieldByName('thSource') As TIntegerField;
    fldCurrencyTriRate := SqlCaller.Records.FieldByName('thCurrencyTriRate') As TFloatField;
    fldCurrencyTriEuro := SqlCaller.Records.FieldByName('thCurrencyTriEuro') As TIntegerField;
    fldCurrencyTriInvert := SqlCaller.Records.FieldByName('thCurrencyTriInvert') As TBooleanField;
    fldCurrencyTriFloat := SqlCaller.Records.FieldByName('thCurrencyTriFloat') As TBooleanField;
    fldCurrencyTriSpare := SqlCaller.Records.FieldByName('thCurrencyTriSpare') As TBinaryField;
    fldVATTriRate := SqlCaller.Records.FieldByName('thVATTriRate') As TFloatField;
    fldVATTriEuro := SqlCaller.Records.FieldByName('thVATTriEuro') As TIntegerField;
    fldVATTriInvert := SqlCaller.Records.FieldByName('thVATTriInvert') As TBooleanField;
    fldVATTriFloat := SqlCaller.Records.FieldByName('thVATTriFloat') As TBooleanField;
    fldVATTriSpare := SqlCaller.Records.FieldByName('thVATTriSpare') As TBinaryField;
    fldOriginalTriRate := SqlCaller.Records.FieldByName('thOriginalTriRate') As TFloatField;
    fldOriginalTriEuro := SqlCaller.Records.FieldByName('thOriginalTriEuro') As TIntegerField;
    fldOriginalTriInvert := SqlCaller.Records.FieldByName('thOriginalTriInvert') As TBooleanField;
    fldOriginalTriFloat := SqlCaller.Records.FieldByName('thOriginalTriFloat') As TBooleanField;
    fldOriginalTriSpare := SqlCaller.Records.FieldByName('thOriginalTriSpare') As TBinaryField;
    fldOldOriginalTriRate := SqlCaller.Records.FieldByName('thOldOriginalTriRate') As TFloatField;
    fldOldOriginalTriEuro := SqlCaller.Records.FieldByName('thOldOriginalTriEuro') As TIntegerField;
    fldOldOriginalTriInvert := SqlCaller.Records.FieldByName('thOldOriginalTriInvert') As TBooleanField;
    fldOldOriginalTriFloat := SqlCaller.Records.FieldByName('thOldOriginalTriFloat') As TBooleanField;
    fldOldOriginalTriSpare := SqlCaller.Records.FieldByName('thOldOriginalTriSpare') As TBinaryField;
    fldPostedDate := SqlCaller.Records.FieldByName('thPostedDate') As TStringField;
    fldPORPickSOR := SqlCaller.Records.FieldByName('thPORPickSOR') As TBooleanField;
    fldBatchDiscAmount := SqlCaller.Records.FieldByName('thBatchDiscAmount') As TFloatField;
    fldPrePost := SqlCaller.Records.FieldByName('thPrePost') As TIntegerField;
    fldAuthorisedAmnt := SqlCaller.Records.FieldByName('thAuthorisedAmnt') As TFloatField;
    fldTimeChanged := SqlCaller.Records.FieldByName('thTimeChanged') As TStringField;
    fldTimeCreated := SqlCaller.Records.FieldByName('thTimeCreated') As TStringField;
    fldCISTaxDue := SqlCaller.Records.FieldByName('thCISTaxDue') As TFloatField;
    fldCISTaxDeclared := SqlCaller.Records.FieldByName('thCISTaxDeclared') As TFloatField;
    fldCISManualTax := SqlCaller.Records.FieldByName('thCISManualTax') As TBooleanField;
    fldCISDate := SqlCaller.Records.FieldByName('thCISDate') As TStringField;
    fldTotalCostApportioned := SqlCaller.Records.FieldByName('thTotalCostApportioned') As TFloatField;
    fldCISEmployee := SqlCaller.Records.FieldByName('thCISEmployee') As TStringField;
    fldCISTotalGross := SqlCaller.Records.FieldByName('thCISTotalGross') As TFloatField;
    fldCISSource := SqlCaller.Records.FieldByName('thCISSource') As TIntegerField;
    fldTimesheetExported := SqlCaller.Records.FieldByName('thTimesheetExported') As TBooleanField;
    fldCISExcludedFromGross := SqlCaller.Records.FieldByName('thCISExcludedFromGross') As TFloatField;
    fldWeekMonth := SqlCaller.Records.FieldByName('thWeekMonth') As TIntegerField;
    fldWorkflowState := SqlCaller.Records.FieldByName('thWorkflowState') As TIntegerField;
    fldOverrideLocation := SqlCaller.Records.FieldByName('thOverrideLocation') As TStringField;
    fldSpare5 := SqlCaller.Records.FieldByName('thSpare5') As TBinaryField;
    fldYourRef := SqlCaller.Records.FieldByName('thYourRef') As TStringField;
    fldUserField5 := SqlCaller.Records.FieldByName('thUserField5') As TStringField;
    fldUserField6 := SqlCaller.Records.FieldByName('thUserField6') As TStringField;
    fldUserField7 := SqlCaller.Records.FieldByName('thUserField7') As TStringField;
    fldUserField8 := SqlCaller.Records.FieldByName('thUserField8') As TStringField;
    fldUserField9 := SqlCaller.Records.FieldByName('thUserField9') As TStringField;
    fldUserField10 := SqlCaller.Records.FieldByName('thUserField10') As TStringField;
    fldDeliveryPostCode := SqlCaller.Records.FieldByName('thDeliveryPostCode') As TStringField;
    fldOriginator := SqlCaller.Records.FieldByName('thOriginator') As TStringField;
    fldCreationTime := SqlCaller.Records.FieldByName('thCreationTime') As TStringField;
    fldCreationDate := SqlCaller.Records.FieldByName('thCreationDate') As TStringField;
    fldOrderPaymentOrderRef := SqlCaller.Records.FieldByName('thOrderPaymentOrderRef') As TStringField;
    fldOrderPaymentElement := SqlCaller.Records.FieldByName('thOrderPaymentElement') As TIntegerField;
    fldOrderPaymentFlags := SqlCaller.Records.FieldByName('thOrderPaymentFlags') As TIntegerField;
    fldCreditCardType := SqlCaller.Records.FieldByName('thCreditCardType') As TStringField;
    fldCreditCardNumber := SqlCaller.Records.FieldByName('thCreditCardNumber') As TStringField;
    fldCreditCardExpiry := SqlCaller.Records.FieldByName('thCreditCardExpiry') As TStringField;
    fldCreditCardAuthorisationNo := SqlCaller.Records.FieldByName('thCreditCardAuthorisationNo') As TStringField;
    fldCreditCardReferenceNo := SqlCaller.Records.FieldByName('thCreditCardReferenceNo') As TStringField;
    fldCustomData1 := SqlCaller.Records.FieldByName('thCustomData1') As TStringField;
    fldDeliveryCountry := SqlCaller.Records.FieldByName('thDeliveryCountry') As TStringField;
    fldPPDPercentage := SqlCaller.Records.FieldByName('thPPDPercentage') As TFloatField;
    fldPPDDays := SqlCaller.Records.FieldByName('thPPDDays') As TIntegerField;
    fldPPDGoodsValue := SqlCaller.Records.FieldByName('thPPDGoodsValue') As TFloatField;
    fldPPDVATValue := SqlCaller.Records.FieldByName('thPPDVATValue') As TFloatField;
    fldPPDTaken := SqlCaller.Records.FieldByName('thPPDTaken') As TIntegerField;
    fldPPDCreditNote := SqlCaller.Records.FieldByName('thPPDCreditNote') As TBooleanField;
    fldBatchPayPPDStatus := SqlCaller.Records.FieldByName('thBatchPayPPDStatus') As TIntegerField;
    // CJS 2015-12-15 - 2016 R1 - Intrastat - A1.3 - new Transaction Header (Document) field
    fldIntrastatOutOfPeriod := SqlCaller.Records.FieldByName('thIntrastatOutOfPeriod') AS TBooleanField;
    // MH 21/03/2016 2016-R2 ABSEXCH-17378: New Udef Fields for eRCT
    fldUserField11 := SqlCaller.Records.FieldByName('thUserField11') As TStringField;
    fldUserField12 := SqlCaller.Records.FieldByName('thUserField12') As TStringField;
    // MH 21/03/2016 2016-R2 ABSEXCH-17379: New Tax Region field for Multi-Region Tax
    fldTaxRegion := SqlCaller.Records.FieldByName('thTaxRegion') As TIntegerField;
    //RB 17/11/2017 2018-R1 ABSEXCH-19347: GDPR - Document.Dat Database Changes
    fldAnonymised := SqlCaller.Records.FieldByName('thAnonymised') As TBooleanField;
    fldAnonymisedDate := SqlCaller.Records.FieldByName('thAnonymisedDate') As TStringField;
    fldAnonymisedTime := SqlCaller.Records.FieldByName('thAnonymisedTime') As TStringField;

    FieldsPrepared := True;
  end;
end;

// -----------------------------------------------------------------------------

function TSQLTransactions.ReadRecord: InvRec;
begin
  ReadRecordInto(Inv);
  Result := Inv;
end;

// -----------------------------------------------------------------------------

procedure TSQLTransactions.ReadRecordInto(var InvR: InvRec);
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
  FillChar (InvR, SizeOf (InvR), #0);
  With InvR Do
  Begin
    RunNo := fldRunNo.Value;
    CustCode := fldAcCode.Value;
    NomAuto := fldNomAuto.Value;
    OurRef := fldOurRef.Value;
    FolioNum := fldFolioNum.Value;
    Currency := fldCurrency.Value;
    AcYr := fldYear.Value;
    AcPr := fldPeriod.Value;
    DueDate := fldDueDate.Value;
    VATPostDate := fldVATPostDate.Value;
    TransDate := fldTransDate.Value;
    CustSupp := SafeReadChar(fldCustSupp.Value);
    CXRate[BOff] := fldCompanyRate.Value;
    CXRate[BOn] := fldDailyRate.Value;
    OldYourRef := fldOldYourRef.Value;

    // Process the Binary BatchLink field
    V := fldBatchLink.AsVariant;
    If VarIsArray(V) Then
    Begin
      // Map byte array onto StockCode field
      VarArray := @BatchLink;
      For I := VarArrayLowBound(V,1) To VarArrayHighBound(V,1) Do
        If (I <= SizeOf(BatchLink)) Then
          VarArray[i] := V[I]
        Else
          Break;
    End; // If VarIsArray(V)

    AllocStat := SafeReadChar(fldOutstanding.Value);
    ILineCount := fldNextLineNumber.Value;
    NLineCount := fldNextNotesLineNumber.Value;
    InvDocHed := DocTypes(fldDocType.Value);
    InvVatAnal [Standard] := fldVATAnalysisStandard.Value;
    InvVatAnal [Exempt] := fldVATAnalysisExempt.Value;
    InvVatAnal [Zero] := fldVATAnalysisZero.Value;
    InvVatAnal [Rate1] := fldVATAnalysisRate1.Value;
    InvVatAnal [Rate2] := fldVATAnalysisRate2.Value;
    InvVatAnal [Rate3] := fldVATAnalysisRate3.Value;
    InvVatAnal [Rate4] := fldVATAnalysisRate4.Value;
    InvVatAnal [Rate5] := fldVATAnalysisRate5.Value;
    InvVatAnal [Rate6] := fldVATAnalysisRate6.Value;
    InvVatAnal [Rate7] := fldVATAnalysisRate7.Value;
    InvVatAnal [Rate8] := fldVATAnalysisRate8.Value;
    InvVatAnal [Rate9] := fldVATAnalysisRate9.Value;
    InvVatAnal [Rate10] := fldVATAnalysisRateT.Value;
    InvVatAnal [Rate11] := fldVATAnalysisRateX.Value;
    InvVatAnal [Rate12] := fldVATAnalysisRateB.Value;
    InvVatAnal [Rate13] := fldVATAnalysisRateC.Value;
    InvVatAnal [Rate14] := fldVATAnalysisRateF.Value;
    InvVatAnal [Rate15] := fldVATAnalysisRateG.Value;
    InvVatAnal [Rate16] := fldVATAnalysisRateR.Value;
    InvVatAnal [Rate17] := fldVATAnalysisRateW.Value;
    InvVatAnal [Rate18] := fldVATAnalysisRateY.Value;
    InvVatAnal [IAdj] := fldVATAnalysisRateIAdj.Value;
    InvVatAnal [OAdj] := fldVATAnalysisRateOAdj.Value;
    InvVatAnal [Spare8] := fldVATAnalysisRateSpare.Value;
    InvNetVal := fldNetValue.Value;
    InvVat := fldTotalVAT.Value;
    DiscSetl := fldSettleDiscPerc.Value;
    DiscSetAm := fldSettleDiscAmount.Value;
    DiscAmount := fldTotalLineDiscount.Value;
    DiscDays := fldSettleDiscDays.Value;
    DiscTaken := fldSettleDiscTaken.Value;
    Settled := fldAmountSettled.Value;
    AutoInc := fldAutoIncrement.Value;
    UnYr := fldUntilYear.Value;
    UnPr := fldUntilPeriod.Value;
    TransNat := fldTransportNature.Value;
    TransMode := fldTransportMode.Value;
    RemitNo := fldRemitNo.Value;
    AutoIncBy := SafeReadChar(fldAutoIncrementType.Value);
    HoldFlg := fldHoldFlag.Value;
    AuditFlg := fldAuditFlag.Value;
    TotalWeight := fldTotalWeight.Value;
    DAddr[1] := fldDeliveryAddr1.Value;
    DAddr[2] := fldDeliveryAddr2.Value;
    DAddr[3] := fldDeliveryAddr3.Value;
    DAddr[4] := fldDeliveryAddr4.Value;
    DAddr[5] := fldDeliveryAddr5.Value;
    Variance := fldVariance.Value;
    TotalOrdered := fldTotalOrdered.Value;
    TotalReserved := fldTotalReserved.Value;
    TotalCost := fldTotalCost.Value;
    TotalInvoiced := fldTotalInvoiced.Value;

    // Process the Binary BatchLink field
    V := fldLongYourRef.AsVariant;
    If VarIsArray(V) Then
    Begin
      // Map byte array onto StockCode field
      VarArray := @TransDesc;
      For I := VarArrayLowBound(V,1) To VarArrayHighBound(V,1) Do
        If (I <= SizeOf(TransDesc)) Then
          VarArray[i] := V[I]
        Else
          Break;
    End; // If VarIsArray(V)

    UntilDate := fldUntilDate.Value;
    NOMVATIO := SafeReadChar(fldNOMVATIO.Value);
    ExternalDoc := fldExternal.Value;
    PrintedDoc := fldPrinted.Value;
    ReValueAdj := fldRevalueAdj.Value;
    CurrSettled := fldCurrSettled.Value;
    SettledVAT := fldSettledVAT.Value;
    VATClaimed := fldVATClaimed.Value;
    BatchNom := fldBatchGL.Value;
    AutoPost := fldAutoPost.Value;
    ManVAT := fldManualVAT.Value;
    DelTerms := fldDeliveryTerms.Value;
    OnPickRun := fldIncludeInPickingRun.Value;
    OpName := fldOperator.Value;
    NoLabels := fldNoLabels.Value;
    Tagged := fldTagged.Value;
    PickRunNo := fldPickingRunNo.Value;
    OrdMatch := fldOrdMatch.Value;
    DeliverRef := fldDeliveryNoteRef.Value;
    VATCRate[BOff] := fldVATCompanyRate.Value;
    VATCRate[BOn] := fldVATDailyRate.Value;
    OrigRates[BOff] := fldOriginalCompanyRate.Value;
    OrigRates[BOn] := fldOriginalDailyRate.Value;
    PostDiscAm := fldPostDiscAm.Value;
    FRNomCode := fldSpareNomCode.Value;
    PDiscTaken := fldPostDiscTaken.Value;
    CtrlNom := fldControlGL.Value;
    DJobCode := fldJobCode.Value;
    DJobAnal := fldAnalysisCode.Value;
    TotOrdOS := fldTotalOrderOS.Value;
    FRCCDep[BOff] := fldAppDepartment.Value;
    FRCCDep[BOn] := fldAppCostCentre.Value;
    DocUser1 := fldUserField1.Value;
    DocUser2 := fldUserField2.Value;
    DocLSplit[1] := fldLineTypeAnalysis1.Value;
    DocLSplit[2] := fldLineTypeAnalysis2.Value;
    DocLSplit[3] := fldLineTypeAnalysis3.Value;
    DocLSplit[4] := fldLineTypeAnalysis4.Value;
    DocLSplit[5] := fldLineTypeAnalysis5.Value;
    DocLSplit[6] := fldLineTypeAnalysis6.Value;
    LastLetter := fldLastDebtChaseLetter.Value;
    BatchNow := fldBatchNow.Value;
    BatchThen := fldBatchThen.Value;
    UnTagged := fldUnTagged.Value;
    OBaseEquiv := fldOriginalBaseValue.Value;
    UseORate := fldUseOriginalRates.Value;
    OldORates[BOff] := fldOldCompanyRate.Value;
    OldORates[BOn] := fldOldDailyRate.Value;
    SOPKeepRate := fldFixedRate.Value;
    DocUser3 := fldUserField3.Value;
    DocUser4 := fldUserField4.Value;
    SSDProcess := SafeReadChar(fldProcess.Value);
    ExtSource := fldSource.Value;
    CurrTriR.TriRates := fldCurrencyTriRate.Value;
    CurrTriR.TriEuro := fldCurrencyTriEuro.Value;
    CurrTriR.TriInvert := fldCurrencyTriInvert.Value;
    CurrTriR.TriFloat := fldCurrencyTriFloat.Value;

    // Process the Binary CurrTriR.Spare field
    V := fldCurrencyTriSpare.AsVariant;
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

    VATTriR.TriRates := fldVATTriRate.Value;
    VATTriR.TriEuro := fldVATTriEuro.Value;
    VATTriR.TriInvert := fldVATTriInvert.Value;
    VATTriR.TriFloat := fldVATTriFloat.Value;

    // Process the Binary VATTriR.Spare field
    V := fldVATTriSpare.AsVariant;
    If VarIsArray(V) Then
    Begin
      // Map byte array onto CurrTriR.Spare field
      VarArray := @VATTriR.Spare;
      For I := VarArrayLowBound(V,1) To VarArrayHighBound(V,1) Do
        If (I <= SizeOf(VATTriR.Spare)) Then
          VarArray[i] := V[I]
        Else
          Break;
    End; // If VarIsArray(V)

    OrigTriR.TriRates := fldOriginalTriRate.Value;
    OrigTriR.TriEuro := fldOriginalTriEuro.Value;
    OrigTriR.TriInvert := fldOriginalTriInvert.Value;
    OrigTriR.TriFloat := fldOriginalTriFloat.Value;

    // Process the Binary OrigTriR.Spare field
    V := fldOriginalTriSpare.AsVariant;
    If VarIsArray(V) Then
    Begin
      // Map byte array onto CurrTriR.Spare field
      VarArray := @OrigTriR.Spare;
      For I := VarArrayLowBound(V,1) To VarArrayHighBound(V,1) Do
        If (I <= SizeOf(OrigTriR.Spare)) Then
          VarArray[i] := V[I]
        Else
          Break;
    End; // If VarIsArray(V)

    OldORTriR.TriRates := fldOldOriginalTriRate.Value;
    OldORTriR.TriEuro := fldOldOriginalTriEuro.Value;
    OldORTriR.TriInvert := fldOldOriginalTriInvert.Value;
    OldORTriR.TriFloat := fldOldOriginalTriFloat.Value;

    // Process the Binary OrigTriR.Spare field
    V := fldOldOriginalTriSpare.AsVariant;
    If VarIsArray(V) Then
    Begin
      // Map byte array onto CurrTriR.Spare field
      VarArray := @OldORTriR.Spare;
      For I := VarArrayLowBound(V,1) To VarArrayHighBound(V,1) Do
        If (I <= SizeOf(OldORTriR.Spare)) Then
          VarArray[i] := V[I]
        Else
          Break;
    End; // If VarIsArray(V)

    PostDate := fldPostedDate.Value;
    PORPickSOR := fldPORPickSOR.Value;
    BDiscount := fldBatchDiscAmount.Value;
    PrePostFlg := fldPrePost.Value;
    AuthAmnt := fldAuthorisedAmnt.Value;
    TimeChange := fldTimeChanged.Value;
    TimeCreate := fldTimeCreated.Value;
    CISTax := fldCISTaxDue.Value;
    CISDeclared := fldCISTaxDeclared.Value;
    CISManualTax := fldCISManualTax.Value;
    CISDate := fldCISDate.Value;
    TotalCost2 := fldTotalCostApportioned.Value;
    CISEmpl := fldCISEmployee.Value;
    CISGross := fldCISTotalGross.Value;
    CISHolder := fldCISSource.Value;
    THExportedFlag := fldTimesheetExported.Value;
    CISGExclude := fldCISExcludedFromGross.Value;
    thWeekMonth := fldWeekMonth.Value;
    thWorkflowState := fldWorkflowState.Value;
    thOverrideLocation := fldOverrideLocation.Value;

    // Process the Binary BatchLink field
    V := fldSpare5.AsVariant;
    If VarIsArray(V) Then
    Begin
      // Map byte array onto StockCode field
      VarArray := @Spare5;
      For I := VarArrayLowBound(V,1) To VarArrayHighBound(V,1) Do
        If (I <= SizeOf(Spare5)) Then
          VarArray[i] := V[I]
        Else
          Break;
    End; // If VarIsArray(V)

    YourRef := fldYourRef.Value;
    DocUser5 := fldUserField5.Value;
    DocUser6 := fldUserField6.Value;
    DocUser7 := fldUserField7.Value;
    DocUser8 := fldUserField8.Value;
    DocUser9 := fldUserField9.Value;
    DocUser10 := fldUserField10.Value;
    thDeliveryPostCode := fldDeliveryPostCode.Value;
    thOriginator := fldOriginator.Value;
    thCreationTime := fldCreationTime.Value;
    thCreationDate := fldCreationDate.Value;
    thOrderPaymentOrderRef := fldOrderPaymentOrderRef.Value;
    thOrderPaymentElement := enumOrderPaymentElement(fldOrderPaymentElement.Value);
    thOrderPaymentFlags := fldOrderPaymentFlags.Value;
    thCreditCardType := fldCreditCardType.Value;
    thCreditCardNumber := fldCreditCardNumber.Value;
    thCreditCardExpiry := fldCreditCardExpiry.Value;
    thCreditCardAuthorisationNo := fldCreditCardAuthorisationNo.Value;
    thCreditCardReferenceNo := fldCreditCardReferenceNo.Value;
    thCustomData1 := fldCustomData1.Value;
    thDeliveryCountry := fldDeliveryCountry.Value;
    thPPDPercentage := fldPPDPercentage.Value;
    thPPDDays := fldPPDDays.Value;
    thPPDGoodsValue := fldPPDGoodsValue.Value;
    thPPDVATValue := fldPPDVATValue.Value;
    thPPDTaken := TTransactionPPDTakenStatus(fldPPDTaken.Value);
    thPPDCreditNote := fldPPDCreditNote.Value;
    thBatchPayPPDStatus := fldBatchPayPPDStatus.Value;

    // CJS 2015-12-15 - 2016 R1 - Intrastat - A1.3 - new Transaction Header (Document) field
    thIntrastatOutOfPeriod := fldIntrastatOutOfPeriod.Value;

    // MH 21/03/2016 2016-R2 ABSEXCH-17378: New Udef Fields for eRCT
    thUserField11 := fldUserField11.Value;
    thUserField12 := fldUserField12.Value;
    // MH 21/03/2016 2016-R2 ABSEXCH-17379: New Tax Region field for Multi-Region Tax
    thTaxRegion := fldTaxRegion.Value;

    //RB 17/11/2017 2018-R1 ABSEXCH-19347: GDPR - Document.Dat Database Changes
    thAnonymised := fldAnonymised.Value;
    thAnonymisedDate := fldAnonymisedDate.Value;
    thAnonymisedTime := fldAnonymisedTime.Value;
  End; // With InvR
end;

// -----------------------------------------------------------------------------

function TSQLTransactions.Validate: Boolean;
begin
  Result := True;
  ValidationError := '';
end;

// =============================================================================
// TSQLSelectTransactions
// =============================================================================

procedure TSQLSelectTransactions.OpenFile;
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
      OnError('TSQLTransactions.OpenFile: ' + SQLCaller.ErrorMsg);
  end
  else
    { Validation failed }
    OnError('TSQLTransactions.OpenFile: ' + ValidationError);
end;

// -----------------------------------------------------------------------------

function TSQLSelectTransactions.Validate: Boolean;
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
// TSQLStoredProcedureTransactions
// =============================================================================

procedure TSQLStoredProcedureTransactions.OpenFile;
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
      OnError('TSQLStoredProcedureTransactions.OpenFile: ' + SQLCaller.ErrorMsg);
  end
  else
    { Validation failed }
    OnError('TSQLStoredProcedureTransactions.OpenFile: ' + ValidationError);
end;

// -----------------------------------------------------------------------------

function TSQLStoredProcedureTransactions.Validate: Boolean;
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

(*

      {001}     RunNo     :  Longint;
      {006}     CustCode  :  String[10];  { Lookup Cust Code }
      {016}     NomAuto   :  Boolean;     { Auto Day book flag }
      {018}     OurRef    :  String[10];  { Doc Number }
      {028}     FolioNum  :  Longint;     { Audit No.}
      {032}     Currency  :  Byte;        { Currency of Document }
      {033/034} AcYr : Byte;
                AcPr :  Byte;
      {036}     DueDate   :  LongDate;    { Date DocDue }
      {045}     VATPostDate  :  LongDate;    { Vat Period Posting Date }

      {054}     TransDate :  LongDate;    { Doc Date }
      {062}     CustSupp  :  Char;        { Cust/Supplier char, to differentiate between Payments / Reciepts Due }
                                          {Normaly, 'C' ,or 'S' for fin trans. 'O', 'P' for ?OR. 'J' for J?A, K for J?T}
      CXRate[BOff] : Real;
      CXRate[BOn] : Real;
      {076}     OldYourRef   :  String[10];  { Customers Ref before v6.00}

      {087}     BatchLink :  String[12];  { Batch No. Link Up Key }
                                          { Used also on SPOP to reprint Delivery notes/Invoices by runno }
                                          { and On time sheets to record employee code }
                                          { and on J?? to record employee}

      {099}     AllocStat :  Char;        { Allocation status for shorter Search , P=Purch unalloc}
      {100}     ILineCount:  LongInt;     { SOP Mode Invoice line count }
      {104}     NLineCount:  LongInt;     { Notes Line count }

      {108}     InvDocHed :  DocTypes;    { Document Type }

//      {109}     InvVatAnal:  Array[VATType] of Real;        { Analysis of VAT Anal }
                InvVatAnal [Standard] : Real;
                InvVatAnal [Exempt] : Real;
                InvVatAnal [Zero] : Real;
                InvVatAnal [Rate1] : Real;
                InvVatAnal [Rate2] : Real;
                InvVatAnal [Rate3] : Real;
                InvVatAnal [Rate4] : Real;
                InvVatAnal [Rate5] : Real;
                InvVatAnal [Rate6] : Real;
                InvVatAnal [Rate7] : Real;
                InvVatAnal [Rate8] : Real;
                InvVatAnal [Rate9] : Real;
                InvVatAnal [Rate10] : Real;
                InvVatAnal [Rate11] : Real;
                InvVatAnal [Rate12] : Real;
                InvVatAnal [Rate13] : Real;
                InvVatAnal [Rate14] : Real;
                InvVatAnal [Rate15] : Real;
                InvVatAnal [Rate16] : Real;
                InvVatAnal [Rate17] : Real;
                InvVatAnal [Rate18] : Real;
                InvVatAnal [IAdj] : Real;
                InvVatAnal [OAdj] : Real;
                InvVatAnal [Spare8] : Real;

      {211}     InvNetVal :  Real;        { Total Posting Value of Doc }

      {247}     InvVat    :  Real;        { Total VAT Content }

      {253}     DiscSetl  :  Real;        { Discount Avail/Take }
      {259}     DiscSetAm :  Real;        { Actual Value of Setle Discount }
      {265}     DiscAmount:  Real;        { Discount Amount     }
      {271}     DiscDays  :  SmallInt;     { No Days Disc Avail }
      {273}     DiscTaken :  Boolean;     { Discount Taken }

      {274}     Settled   :  Real;        { Amount Paid Off }
      {280}     AutoInc   :  SmallInt;     { Automatic Document Increment }

      {281}     UnYr :  Byte;        { Auto Until Period }
                UnPr :  Byte;        { Auto Until Period }
      {282}     TransNat  :  Byte;        { VAT Nature of Transaction }
      {283}     TransMode :  Byte;        { VAT Mode of Transport     }
      {285}     RemitNo   :  String[10];  { Doc No of Coressponding Payment / Recipt / Order }

      {295}     AutoIncBy :  Char;        { Type of Automatic Increment Date or Period }

      {296}     HoldFlg   :  Byte;        { Hold Status }
      {297}     AuditFlg  :  Boolean;     { Is Doc Purgable }
      {298}     TotalWeight                           :  Real;        { Order Weight Details }
                DAddr[1] : String[30];
                DAddr[2] : String[30];
                DAddr[3] : String[30];
                DAddr[4] : String[30];
                DAddr[5] : String[30];
      {459}     Variance  :  Real;        { Currency Exchabge Loss/ Gain }
      {465}     TotalOrdered:  Real;
      {471}     TotalReserved:  Real;
      {477}     TotalCost:  Real;
      {483}     TotalInvoiced :  Real;
      {490}     TransDesc :  String[20];  { Free format text }

      {511}     UntilDate :  LongDate;    { Auto Until Date  }

      {519}     NOMVATIO  :  Char;        { * Determins if a NOM is an input ot output journal. N/A=0, I=1, O=2 VAT}

      {520}     ExternalDoc                           :  Boolean;     {* This is an externaly created Document, no edit allowed *}

      {521}     PrintedDoc                           :  Boolean;     {* This Document has been printed *}

      {522}     ReValueAdj:  Real;
      {528}     CurrSettled                           :  Real;        {* Docs Own Setttled rate *}

      {534}     SettledVAT                           :  Real;        {* Amount recorded as settled during last VAT Return (Cash Accounting) *}

      {540}     VATClaimed                           :  Real;        {* Total VAT presented as at last VAT Return (Cash Accounting) *}

      {546}     BatchNom  :  LongInt;     {* Batch Payment Nominal *}

      {550}     AutoPost  :  Boolean;     {* Pickup Auto item on Daybook post  *}
                                          {* Also used to indicate Nom Generated automaticly by system *}

      {551}     ManVAT    :  Boolean;     {* If Set, prevents re-calclation of VAT *}

      {553}     DelTerms  :  String[3];   {* VAT Delivery Terms *}

      {558}     OnPickRun :  Boolean;

      {560}     OpName    :  String[10];  {* Operators User Name *}

      {570}     NoLabels  :  SmallInt;     {* No. of labels to print *}

                  Tagged    :  Byte;         {* Doc Marked for something *}
      {572}     PickRunNo :  LongInt;     {* Flag to indicate inclusion on picking list *}

      {576}     OrdMatch  :  Boolean;     {* Flag to indicate we have a match on order set up *}

      {578}     DeliverRef:  String[10];  {* Store Delivery notes Number link *}

      {588}     VATCRate[BOff]  :  Real;
      {588}     VATCRate[BOn]  :  Real;

      {600}     OrigRates[BOff] :  Real;
      {600}     OrigRates[BOn] :  Real;

      {612}     PostDiscAm:  Double;      {* Posted Discount taken/given *}
      {620}     FRNomCode :  LongInt;     {* Spare *}
      {624}     PDiscTaken:  Boolean;     {* Posted Settlement Discount Taken *}

      {625}     CtrlNom   :  Longint;     {* Debtor/Creditor Control Nominal *}

      {627}     DJobCode  :  String[10];  {* Default Document Job Code *}
      {638}     DJobAnal  :  String[10];  {* Default Document Anal Code *}

      {648}     TotOrdOS  :  Real;        {* Value of Order Outstanding/ Temp Aged Debt Value *}

      {654}     FRCCDep[BOff]   :  String[3];
      {654}     FRCCDep[BOn]   :  String[3];

      {636}     DocUser1  : String[30];   {* User def fields *}
      {647}     DocUser2  : String[30];   {* User def fields *}

      {687}     DocLSplit[1] : Double;
      {687}     DocLSplit[2] : Double;
      {687}     DocLSplit[3] : Double;
      {687}     DocLSplit[4] : Double;
      {687}     DocLSplit[5] : Double;
      {687}     DocLSplit[6] : Double;

      {735}     LastLetter: Byte;
      {736}     BatchNow: Double;       {* Part allocation value in Batch payments *}
                BatchThen: Double;       {* Part allocation value in Batch payments *}
      {752}     UnTagged  : Boolean;
      {753}     OBaseEquiv: Double;       {* Pre EMU conversion base value }
      {761}     UseORate  : Byte;         {* Forces the conversion routines to apply non tri rules *}
      {762}     OldORates[BOff] : Real48;
      {762}     OldORates[BOn] : Real48;    {* After euro conversion, very original rates are shown *}
      {774}     SOPKeepRate : Boolean;      {* When converting through SOP process, use original order rate *}

      {776}     DocUser3  : String[30];   {* User def fields *}
      {797}     DocUser4  : String[30];   {* User def fields *}
      {818}     SSDProcess: Char;         {* SSD process flag *}
      {819}     ExtSource : Byte;         {* If transaction created externaly where from *}


                CurrTriR.TriRates   :   Double;
                CurrTriR.TriEuro    :   Byte;
                CurrTriR.TriInvert  :   Boolean;
                CurrTriR.TriFloat   :   Boolean;
                CurrTriR.Spare      :   Array[1..10] of Byte;

                VATTriR.TriRates   :   Double;
                VATTriR.TriEuro    :   Byte;
                VATTriR.TriInvert  :   Boolean;
                VATTriR.TriFloat   :   Boolean;
                VATTriR.Spare      :   Array[1..10] of Byte;

                OrigTriR.TriRates   :   Double;
                OrigTriR.TriEuro    :   Byte;
                OrigTriR.TriInvert  :   Boolean;
                OrigTriR.TriFloat   :   Boolean;
                OrigTriR.Spare      :   Array[1..10] of Byte;

                OldORTriR.TriRates   :   Double;
                OldORTriR.TriEuro    :   Byte;
                OldORTriR.TriInvert  :   Boolean;
                OldORTriR.TriFloat   :   Boolean;
                OldORTriR.Spare      :   Array[1..10] of Byte;

      {905}     PostDate  : LongDate;     {* Date posted, used for EC + SSD *}

      {913}     PORPickSOR: Boolean;      {* Back to Back SOR/POR auto picks SOR *}

      {914}     BDiscount : Double;       {* Amount of discount applied via batch *}

      {922}     PrePostFlg: Byte;
      {923}     AuthAmnt  : Double;       {* Amount authorised when last stored *}

      {932}     TimeChange: String[6];    {* Last time transaction changed}
      {939}     TimeCreate: String[6];    {* Time transaction created}


        {945}    CISTax   : Double;       {*Total amount of CIS tax to be deducted *}
        {953}    CISDeclared                           : Double;
                                             
        {961}    CISManualTax                           : Boolean;      {* Tax was overridden by manual adjustment, do not auto calculate *}
        {963}    CISDate  : LongDate;     {* Date of next voucher run *}
        {971}    TotalCost2                            : Double;       {* Cost appotrionment from outside costs, included in GP *}
        {980}    CISEmpl  : String[10];   {* Employe code used for this CIS Entry *}

        {990}    CISGross : Double;       {* Basis of CIS Tax *}

        {998}    CISHolder: Byte;
         {999}   THExportedFlag  : Boolean;      {* Flag to indicate timesheet exported *}

         {1000}   CISGExclude                         : Double;
                  thWeekMonth : SmallInt;
                  thWorkflowState : LongInt;
                  thOverrideLocation : String[3];
                  Spare5   : Array[1..54] of Byte;
                  YourRef   :  String[20];  { Customers Ref from v6.00}
                  DocUser5  : String[30];   {* User def fields *}
                  DocUser6  : String[30];   {* User def fields *}
                  DocUser7  : String[30];   {* User def fields *}
                  DocUser8  : String[30];   {* User def fields *}
                  DocUser9  : String[30];   {* User def fields *}
                  DocUser10 : String[30];   {* User def fields *}
                  thDeliveryPostCode: string[20];
                  thOriginator   : String[36]; // Exchequer User Id
                  thCreationTime : String[6];  // HHMMSS
                  thCreationDate : String[8];  // YYYYMMDD
                  thOrderPaymentOrderRef : String[10];              // OurRef of parent Order for SDN/SIN/SRC in Order Payments subsystem
                  thOrderPaymentElement : enumOrderPaymentElement;  // The type of transaction in Order Payments subsystem, e.g. Order Payment
                  thOrderPaymentFlags : Byte;                       // bit field - see thopfXXX constants above for values
                  thCreditCardType : String[4];                     // Credit Card Payment Details (on Payment SRC only)
                  thCreditCardNumber : String[4];                   // Credit Card Payment Details (on Payment SRC only) - Last 4 digits only
                  thCreditCardExpiry : String[4];                   // Credit Card Payment Details (on Payment SRC only) - MMYY format
                  thCreditCardAuthorisationNo : String[20];         // Credit Card Payment Details (on Payment SRC only)
                  thCreditCardReferenceNo : String[70];             // Credit Card Payment Details (on Payment SRC only)
                  thCustomData1 : String[30];                       // for bespoke
                  thDeliveryCountry : String[2];                    // Delivery address Country Code (ISO 3166-1 alpha-2)
                  thPPDPercentage : Double;   // Discount Percentage - Note: 0.1 = 10%
                  thPPDDays       : SmallInt; // Number of days discount offer is valid for
                  thPPDGoodsValue : Double;   // Goods Value of Discount (if taken) in Transaction Currency
                  thPPDVATValue   : Double;   // VAT Value of Discount (if taken) in Transaction Currency
                  thPPDTaken      : TTransactionPPDTakenStatus;  // Indicates if Prompt Payment Discount was given
                  thPPDCreditNote : Boolean;                     // TRUE if this is a Credit Note created for PPD
                  thBatchPayPPDStatus : Byte;                    // PPD Status Flag for Batch Payments
                  thIntrastatOutOfPeriod : Boolean;   // Intrastat Out of Period Transaction
                  Spare600  : Array[1..356] of Byte;        {* !! *}
*)

end.



