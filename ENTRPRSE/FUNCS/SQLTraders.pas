unit SQLTraders;

interface

uses SysUtils, Variants, DB, GlobVar, VarConst, SQLUtils, SQLCallerU, SQLRep_Config,
     EncryptionUtils, EntLoggerClass, Classes, ADOConnect;

const
  ErrCompanyCode = 'No company code assigned.';

type
  { Array-type for accessing binary fields (see ReadRecord) }
  TByteArray = Array [0..255] of Byte;

  { Class for retrieving Traders via direct SQL or a stored
    procedure. This is an abstract class, and should not be used -- instead,
    one of the descendant classes.
  }
//==============================================================================
  TSQLTraders = class(TObject)
  private
    //DB Filed
    fldPositionId: TIntegerField;
    fldAcCode: TStringField;
    fldAcCustSupp: TStringField;
    fldAcCompany: TStringField;
    fldAcArea: TStringField;
    fldAcAccType: TStringField;
    fldAcStatementTo: TStringField;
    fldAcVATRegNo: TStringField;
    fldAcAddressLine1: TStringField;
    fldAcAddressLine2: TStringField;
    fldAcAddressLine3: TStringField;
    fldAcAddressLine4: TStringField;
    fldAcAddressLine5: TStringField;
    fldAcDespAddr: TBooleanField;
    fldAcDespAddressLine1: TStringField;
    fldAcDespAddressLine2: TStringField;
    fldAcDespAddressLine3: TStringField;
    fldAcDespAddressLine4: TStringField;
    fldAcDespAddressLine5: TStringField;
    fldAcContact: TStringField;
    fldAcPhone: TStringField;
    fldAcFax: TStringField;
    fldAcTheirAcc: TStringField;
    fldAcOwnTradTerm: TBooleanField;
    fldAcTradeTerms1: TStringField;
    fldAcTradeTerms2: TStringField;
    fldAcCurrency: TIntegerField;
    fldAcVATCode: TStringField;
    fldAcPayTerms: TIntegerField;
    fldAcCreditLimit: TFloatField;
    fldAcDiscount: TFloatField;
    fldAcCreditStatus: TIntegerField;
    fldAcCostCentre: TStringField;
    fldAcDiscountBand: TStringField;
    fldAcOrderConsolidationMode: TIntegerField;
    fldAcDefSettleDays: TIntegerField;
    fldAcSpare5: TBinaryField;
    fldAcBalance: TFloatField;
    fldAcDepartment: TStringField;
    fldAcECMember: TBooleanField;
    fldAcNLineCount: TIntegerField;
    fldAcStatement: TBooleanField;
    fldAcSalesGL: TIntegerField;
    fldAcLocation: TStringField;
    fldAcAccStatus: TIntegerField;
    fldAcPayType: TStringField;
    fldAcOldBankSort: TStringField;
    fldAcOldBankAcc: TStringField;
    fldAcBankRef: TStringField;
    fldAcAvePay: TIntegerField;
    fldAcPhone2:  TStringField;
    fldAcCOSGL: TIntegerField;
    fldAcDrCrGL: TIntegerField;
    fldAcLastUsed: TStringField;
    fldAcUserDef1: TStringField;
    fldAcUserDef2: TStringField;
    fldAcInvoiceTo: TStringField;
    fldAcSOPAutoWOff: TBooleanField;
    fldAcFormSet: TIntegerField;
    fldAcBookOrdVal: TFloatField;
    fldAcDirDebMode: TIntegerField;
    fldAcCCStart: TStringField;
    fldAcCCEnd: TStringField;
    fldAcCCName: TStringField;
    fldAcCCNumber: TStringField;
    fldAcCCSwitch: TStringField;
    fldAcDefSettleDisc: TFloatField;
    fldAcStateDeliveryMode: TIntegerField;
    fldAcSpare2: TStringField;
    fldAcSendReader: TBooleanField;
    fldAcEBusPword: TStringField;
    fldAcPostCode: TStringField;
    fldAcAltCode: TStringField;
    fldAcUseForEbus: TIntegerField;
    fldAcZIPAttachments: TIntegerField;
    fldAcUserDef3: TStringField;
    fldAcUserDef4: TStringField;
    fldAcWebLiveCatalog: TStringField;
    fldAcWebPrevCatalog: TStringField;
    fldAcTimeStamp: TStringField;
    fldAcVATCountryCode: TStringField;
    fldAcSSDDeliveryTerms: TStringField;
    fldAcInclusiveVATCode: TStringField;
    fldAcSSDModeOfTransport: TIntegerField;
    fldAcPrivateRec: TBooleanField;
    fldAcLastOperator: TStringField;
    fldAcDocDeliveryMode: TIntegerField;
    fldAcSendHTML: TBooleanField;
    fldAcEmailAddr: TStringField;
    fldAcOfficeType: TIntegerField;
    fldAcDefTagNo: TIntegerField;
    fldAcUserDef5: TStringField;
    fldAcUserDef6: TStringField;
    fldAcUserDef7: TStringField;
    fldAcUserDef8: TStringField;
    fldAcUserDef9: TStringField;
    fldAcUserDef10: TStringField;
    fldAcBankSortCode: TBinaryField;
    fldAcBankAccountCode: TBinaryField;
    fldAcMandateID: TBinaryField;
    fldAcMandateDate: TStringField;
    fldAcDeliveryPostCode: TStringField;
    fldAcSubType: TStringField;
    fldAcLongAcCode: TStringField;
    fldAcAllowOrderPayments: TBooleanField;
    fldAcOrderPaymentsGLCode: TIntegerField;
    fldAcCountry: TStringField;
    fldAcDeliveryCountry: TStringField;
    fldAcPPDMode: TIntegerField;
    fldAcDefaultToQR: TBooleanField;
    fldAcTaxRegion: TIntegerField;
    fldAcAnonymisationStatus: TIntegerField;
    fldAcAnonymisedDate: TStringField;
    fldAcAnonymisedTime: TStringField;

    FColumns: String;
    FQryCount: Integer;
    FFieldsPrepared: Boolean;
    { Flag to record whether we are using our own copy of TSQLCaller (and
      hence must free it) rather than an instance supplied by the calling
      routine. }
    FUsingInternalSQLCaller: Boolean;
    function GetColumnList: String;
    { Getter for the Line property, returning the specified line. Raises an
      exception if the recordset is not open. }
    function GetHeader(Idx: Integer): CustRec;
    { Checks that any required properties have been assigned values. Returns
      False if the validation fails and puts a description of the problem into
      ValidationError. This should be overridden by descendant classes (this
      base function simply returns True). }
    function Validate: Boolean;
  protected
    ValidationError: String;
  public
    SQLCaller: TSQLCaller;
    TraderRec: CustRec;
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
    function ReadRecord: CustRec;
    procedure ReadRecordInto(var ATraderRec: CustRec);
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
    procedure OnError(AMsg: string);
    property Header[Idx: Integer]: CustRec read GetHeader; default;
  end; //TSQLTraders

//==============================================================================

  {
    Class for retrieving Traders via direct SQL.

    The CompanyCode and FromClause must be initialised, and optionally the
    JoinClause, WhereClause, and OrderByClause.

    Call OpenFile to read the records, then either navigate through them using
    First and Next, or read the transactions directly using the Header[] index property
    (use Count to determine how many transaction headers there are).

    Retrieve the current record using ReadRecord, which returns an InvRec
    structure.

    Example:

      var
        Headers: TSQLSelectTraders;
        TraderRec : CustRec;
      begin
        Headers := TSQLSelectTraders.Create;
        Headers.CompanyCode := 'ZZZZ01';
        Headers.FromClause  := 'FROM [COMPANY].CustSupp';
        Headers.WhereClause := 'WHERE acCustSupp = 'C' ';

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
  TSQLSelectTraders = class(TSQLTraders)
  private
    FFromClause: AnsiString;
    FJoinClause: AnsiString;
    FWhereClause: AnsiString;
    FOrderByClause: AnsiString;
  public
    { Executes the SQL query to retrieve the recordset. }
    procedure OpenFile; override;
    { Checks that any required properties have been assigned values. Returns
      False if the validation fails and puts a description of the problem into
      ValidationError. }
    function Validate: Boolean;

    property FromClause: AnsiString read FFromClause write FFromClause;
    property JoinClause: AnsiString read FJoinClause write FJoinClause;
    property WhereClause: AnsiString read FWhereClause write FWhereClause;
    property OrderByClause: AnsiString read FOrderByClause write FOrderByClause;
  end;//TSQLSelectTraders

//==============================================================================

  {
    Class for retrieving Traders via a stored procedure.

    The CompanyCode and StoredProcedure variables must be initialised.

    Call OpenFile to read the records, then either navigate through them using
    First and Next, or read the headers directly using the Header[] index property
    (use Count to determine how many transaction headers there are).

    Retrieve the current record using ReadRecord, which returns an InvRec
    structure.

    Example:

      var
        Headers: TSQLStoredProcedureTraders;
        TraderRec: CustRec;
      begin
        Headers := TSQLStoredProcedureTraders.Create;
        Headers.CompanyCode := 'ZZZZ01';
        Headers.StoredProcedure := 'EXEC [COMPANY].esp_CustSupp';

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
  TSQLStoredProcedureTraders = class(TSQLTraders)
  private
    FStoredProcedure: AnsiString;
  public
    { Executes the stored procedure to retrieve the recordset. }
    procedure OpenFile; override;
    { Checks that any required properties have been assigned values. Returns
      False if the validation fails and puts a description of the problem into
      ValidationError. }
    function Validate: Boolean;
    property StoredProcedure: AnsiString read FStoredProcedure write FStoredProcedure;
  end; //TSQLStoredProcedureTraders

//==============================================================================

implementation

//==============================================================================
{ TSQLTraders }
//==============================================================================

procedure TSQLTraders.CloseFile;
begin
  if SQLCaller.Records.Active then
    SQLCaller.Records.Close;
end;

function TSQLTraders.Count: Integer;
begin
  if SQLCaller.Records.Active then
    Result := SQLCaller.Records.RecordCount
  else
    Result := 0;
end;

constructor TSQLTraders.Create;
begin
  inherited;
  FUsingInternalSQLCaller := False;
  FFieldsPrepared := False;
  FQryCount := 0;
  FColumns := GetColumnList;
end;

destructor TSQLTraders.Destroy;
begin
  try
    if SQLCaller.Records.Active then
      SQLCaller.Records.Close;

    if FUsingInternalSQLCaller then
      FreeAndNil(SQLCaller);
  except
    on Exception do ;
  end;
  inherited;
end;

function TSQLTraders.EOF: Boolean;
begin
  if SQLCaller.Records.Active then
    Result := SQLCaller.Records.Eof
  else
    Result := True;
end;

procedure TSQLTraders.First;
begin
  if SQLCaller.Records.Active then
    SQLCaller.Records.First
  else
    OnError('TSQLTraders.First: the SQL record-set is not open');
end;

function TSQLTraders.GetColumnList: String;
begin
  Result := 'PositionId, acCode, acCustSupp, acCompany, acArea, acAccType, acStatementTo, ' +
            'acVATRegNo, acAddressLine1, acAddressLine2, acAddressLine3, acAddressLine4, ' +
            'acAddressLine5, acDespAddr, acDespAddressLine1, acDespAddressLine2, ' +
            'acDespAddressLine3, acDespAddressLine4, acDespAddressLine5, acContact, ' +
            'acPhone, acFax, acTheirAcc, acOwnTradTerm, acTradeTerms1, acTradeTerms2, ' +
            'acCurrency, acVATCode, acPayTerms, acCreditLimit, acDiscount, acCreditStatus, ' +
            'acCostCentre, acDiscountBand, acOrderConsolidationMode, acDefSettleDays, ' +
            'acSpare5, acBalance, acDepartment, acECMember, acNLineCount, acStatement, ' +
            'acSalesGL, acLocation, acAccStatus, acPayType, acOldBankSort, acOldBankAcc, ' +
            'acBankRef, acAvePay, acPhone2, acCOSGL, acDrCrGL, acLastUsed, acUserDef1, ' +
            'acUserDef2, acInvoiceTo, acSOPAutoWOff, acFormSet, acBookOrdVal, acDirDebMode, ' +
            'acCCStart, acCCEnd, acCCName, acCCNumber, acCCSwitch, acDefSettleDisc, ' +
            'acStateDeliveryMode, acSpare2, acSendReader, acEBusPword, acPostCode, ' +
            'acAltCode, acUseForEbus, acZIPAttachments, acUserDef3, acUserDef4, ' +
            'acWebLiveCatalog, acWebPrevCatalog, acTimeStamp, acVATCountryCode, ' +
            'acSSDDeliveryTerms, acInclusiveVATCode, acSSDModeOfTransport, acPrivateRec, ' +
            'acLastOperator, acDocDeliveryMode, acSendHTML, acEmailAddr, acOfficeType, ' +
            'acDefTagNo, acUserDef5, acUserDef6, acUserDef7, acUserDef8, acUserDef9, ' +
            'acUserDef10, acBankSortCode, acBankAccountCode, acMandateID, acMandateDate, ' +
            'acDeliveryPostCode, acSubType, acLongAcCode, acAllowOrderPayments, ' +
            'acOrderPaymentsGLCode, acCountry, acDeliveryCountry, acPPDMode, acDefaultToQR, ' +
            'acTaxRegion, acAnonymisationStatus, acAnonymisedDate, acAnonymisedTime';
end;

function TSQLTraders.GetHeader(Idx: Integer): CustRec;
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
        OnError('TSQLTraders.GetHeader: ' + E.Message);
    end;
  end
  else
    OnError('TSQLTraders.GetHeader: the SQL record-set is not open');
end;

procedure TSQLTraders.Next;
begin
  if SQLCaller.Records.Active then
    SQLCaller.Records.Next
  else
    OnError('TSQLTraders.Next: the SQL record-set is not open');
end;

procedure TSQLTraders.OnError(AMsg: string);
begin
  if Assigned(Logger) then
    Logger.LogError(AMsg);
  raise Exception.Create(AMsg);
end;

procedure TSQLTraders.PrepareFields;
begin
  if not FFieldsPrepared then
  begin
    with SqlCaller.Records do
    begin
      fldPositionId := FieldByName('PositionId') as TIntegerField;
      fldAcCode := FieldByName('acCode') as TStringField;
      fldAcCustSupp := FieldByName('acCustSupp') as TStringField;
      fldAcCompany := FieldByName('acCompany') as TStringField;
      fldAcArea := FieldByName('acArea') as TStringField;
      fldAcAccType := FieldByName('acAccType') as TStringField;
      fldAcStatementTo := FieldByName('acStatementTo') as TStringField;
      fldAcVATRegNo := FieldByName('acVATRegNo') as TStringField;
      fldAcAddressLine1 := FieldByName('acAddressLine1') as TStringField;
      fldAcAddressLine2 := FieldByName('acAddressLine2') as TStringField;
      fldAcAddressLine3 := FieldByName('acAddressLine3') as TStringField;
      fldAcAddressLine4 := FieldByName('acAddressLine4') as TStringField;
      fldAcAddressLine5 := FieldByName('acAddressLine5') as TStringField;
      fldAcDespAddr := FieldByName('acDespAddr') as TBooleanField;
      fldAcDespAddressLine1 := FieldByName('acDespAddressLine1') as TStringField;
      fldAcDespAddressLine2 := FieldByName('acDespAddressLine2') as TStringField;
      fldAcDespAddressLine3 := FieldByName('acDespAddressLine3') as TStringField;
      fldAcDespAddressLine4 := FieldByName('acDespAddressLine4') as TStringField;
      fldAcDespAddressLine5 := FieldByName('acDespAddressLine5') as TStringField;
      fldAcContact := FieldByName('acContact') as TStringField;
      fldAcPhone := FieldByName('acPhone') as TStringField;
      fldAcFax := FieldByName('acFax') as TStringField;
      fldAcTheirAcc := FieldByName('acTheirAcc') as TStringField;
      fldAcOwnTradTerm := FieldByName('acOwnTradTerm') as TBooleanField;
      fldAcTradeTerms1 := FieldByName('acTradeTerms1') as TStringField;
      fldAcTradeTerms2 := FieldByName('acTradeTerms2') as TStringField;
      fldAcCurrency := FieldByName('acCurrency') as TIntegerField;
      fldAcVATCode := FieldByName('acVATCode') as TStringField;
      fldAcPayTerms := FieldByName('acPayTerms') as TIntegerField;
      fldAcCreditLimit := FieldByName('acCreditLimit') as TFloatField;
      fldAcDiscount := FieldByName('acDiscount') as TFloatField;
      fldAcCreditStatus := FieldByName('acCreditStatus') as TIntegerField;
      fldAcCostCentre := FieldByName('acCostCentre') as TStringField;
      fldAcDiscountBand := FieldByName('acDiscountBand') as TStringField;
      fldAcOrderConsolidationMode := FieldByName('acOrderConsolidationMode') as TIntegerField;
      fldAcDefSettleDays := FieldByName('acDefSettleDays') as TIntegerField;
      fldAcSpare5 := FieldByName('acSpare5') as TBinaryField;
      fldAcBalance := FieldByName('acBalance') as TFloatField;
      fldAcDepartment := FieldByName('acDepartment') as TStringField;
      fldAcECMember := FieldByName('acECMember') as TBooleanField;
      fldAcNLineCount := FieldByName('acNLineCount') as TIntegerField;
      fldAcStatement := FieldByName('acStatement') as TBooleanField;
      fldAcSalesGL := FieldByName('acSalesGL') as TIntegerField;
      fldAcLocation := FieldByName('acLocation') as TStringField;
      fldAcAccStatus := FieldByName('acAccStatus') as TIntegerField;
      fldAcPayType := FieldByName('acPayType') as TStringField;
      fldAcOldBankSort := FieldByName('acOldBankSort') as TStringField;
      fldAcOldBankAcc := FieldByName('acOldBankAcc') as TStringField;
      fldAcBankRef := FieldByName('acBankRef') as TStringField;
      fldAcAvePay := FieldByName('acAvePay') as TIntegerField;
      fldAcPhone2 := FieldByName('acPhone2') as TStringField;
      fldAcCOSGL := FieldByName('acCOSGL') as TIntegerField;
      fldAcDrCrGL := FieldByName('acDrCrGL') as TIntegerField;
      fldAcLastUsed := FieldByName('acLastUsed') as TStringField;
      fldAcUserDef1 := FieldByName('acUserDef1') as TStringField;
      fldAcUserDef2 := FieldByName('acUserDef2') as TStringField;
      fldAcInvoiceTo := FieldByName('acInvoiceTo') as TStringField;
      fldAcSOPAutoWOff := FieldByName('acSOPAutoWOff') as TBooleanField;
      fldAcFormSet := FieldByName('acFormSet') as TIntegerField;
      fldAcBookOrdVal := FieldByName('acBookOrdVal') as TFloatField;
      fldAcDirDebMode := FieldByName('acDirDebMode') as TIntegerField;
      fldAcCCStart := FieldByName('acCCStart') as TStringField;
      fldAcCCEnd := FieldByName('acCCEnd') as TStringField;
      fldAcCCName := FieldByName('acCCName') as TStringField;
      fldAcCCNumber := FieldByName('acCCNumber') as TStringField;
      fldAcCCSwitch := FieldByName('acCCSwitch') as TStringField;
      fldAcDefSettleDisc := FieldByName('acDefSettleDisc') as TFloatField;
      fldAcStateDeliveryMode := FieldByName('acStateDeliveryMode') as TIntegerField;
      fldAcSpare2 := FieldByName('acSpare2') as TStringField;
      fldAcSendReader := FieldByName('acSendReader') as TBooleanField;
      fldAcEBusPword := FieldByName('acEBusPword') as TStringField;
      fldAcPostCode := FieldByName('acPostCode') as TStringField;
      fldAcAltCode := FieldByName('acAltCode') as TStringField;
      fldAcUseForEbus := FieldByName('acUseForEbus') as TIntegerField;
      fldAcZIPAttachments := FieldByName('acZIPAttachments') as TIntegerField;
      fldAcUserDef3 := FieldByName('acUserDef3') as TStringField;
      fldAcUserDef4 := FieldByName('acUserDef4') as TStringField;
      fldAcWebLiveCatalog := FieldByName('acWebLiveCatalog') as TStringField;
      fldAcWebPrevCatalog := FieldByName('acWebPrevCatalog') as TStringField;
      fldAcTimeStamp := FieldByName('acTimeStamp') as TStringField;
      fldAcVATCountryCode := FieldByName('acVATCountryCode') as TStringField;
      fldAcSSDDeliveryTerms := FieldByName('acSSDDeliveryTerms') as TStringField;
      fldAcInclusiveVATCode := FieldByName('acInclusiveVATCode') as TStringField;
      fldAcSSDModeOfTransport := FieldByName('acSSDModeOfTransport') as TIntegerField;
      fldAcPrivateRec := FieldByName('acPrivateRec') as TBooleanField;
      fldAcLastOperator := FieldByName('acLastOperator') as TStringField;
      fldAcDocDeliveryMode := FieldByName('acDocDeliveryMode') as TIntegerField;
      fldAcSendHTML := FieldByName('acSendHTML') as TBooleanField;
      fldAcEmailAddr := FieldByName('acEmailAddr') as TStringField;
      fldAcOfficeType := FieldByName('acOfficeType') as TIntegerField;
      fldAcDefTagNo := FieldByName('acDefTagNo') as TIntegerField;
      fldAcUserDef5 := FieldByName('acUserDef5') as TStringField;
      fldAcUserDef6 := FieldByName('acUserDef6') as TStringField;
      fldAcUserDef7 := FieldByName('acUserDef7') as TStringField;
      fldAcUserDef8 := FieldByName('acUserDef8') as TStringField;
      fldAcUserDef9 := FieldByName('acUserDef9') as TStringField;
      fldAcUserDef10 := FieldByName('acUserDef10') as TStringField;
      fldAcBankSortCode := FieldByName('acBankSortCode') as TBinaryField;
      fldAcBankAccountCode := FieldByName('acBankAccountCode') as TBinaryField;
      fldAcMandateID := FieldByName('acMandateID') as TBinaryField;
      fldAcMandateDate := FieldByName('acMandateDate') as TStringField;
      fldAcDeliveryPostCode := FieldByName('acDeliveryPostCode') as TStringField;
      fldAcSubType := FieldByName('acSubType') as TStringField;
      fldAcLongAcCode := FieldByName('acLongAcCode') as TStringField;
      fldAcAllowOrderPayments := FieldByName('acAllowOrderPayments') as TBooleanField;
      fldAcOrderPaymentsGLCode := FieldByName('acOrderPaymentsGLCode') as TIntegerField;
      fldAcCountry := FieldByName('acCountry') as TStringField;
      fldAcDeliveryCountry := FieldByName('acDeliveryCountry') as TStringField;
      fldAcPPDMode := FieldByName('acPPDMode') as TIntegerField;
      fldAcDefaultToQR := FieldByName('acDefaultToQR') as TBooleanField;
      fldAcTaxRegion := FieldByName('acTaxRegion') as TIntegerField;
      fldAcAnonymisationStatus := FieldByName('acAnonymisationStatus') as TIntegerField;
      fldAcAnonymisedDate := FieldByName('acAnonymisedDate') as TStringField;
      fldAcAnonymisedTime := FieldByName('acAnonymisedTime') as TStringField;
      FFieldsPrepared := True;
    end;
  end;
end;

function TSQLTraders.ReadRecord: CustRec;
begin
  ReadRecordInto(TraderRec);
  Result := TraderRec;
end;

procedure TSQLTraders.ReadRecordInto(var ATraderRec: CustRec);
var
  lVariant: Variant;
  lVarArray : ^TByteArray;
  i: Integer;

  //-----------------------------------
  {Function to return the first character from a string, returning #0 if
   the string is empty}
  function SafeReadChar(Value: string): char;
  begin
    if (Value <> '') then
      Result := Value[1]
    else
      Result := #0;
  end;

  //-----------------------------------

  function GetPPDMode(AMode: Integer): TTraderPPDMode;
  begin
    Result := pmPPDDisabled;
    case AMode of
      0 : Result := pmPPDDisabled;
      1 : Result := pmPPDEnabledWithAutoJournalCreditNote;
      2 : Result := pmPPDEnabledWithAutoCreditNote;
      3 : Result := pmPPDEnabledWithManualCreditNote;
    end;
  end;

  //-----------------------------------

begin
  // Copy the returned columns into the CustSupp
  FillChar (ATraderRec, SizeOf (ATraderRec), #0);
  with ATraderRec do
  begin
    // Populate the data - which populates the Query values
    CustCode := fldAcCode.Value;
    CustSupp := SafeReadChar(fldAcCustSupp.Value);
    Company  := fldAcCompany.Value;
    AreaCode := fldAcArea.Value;
    RepCode := fldAcAccType.Value;
    RemitCode := fldAcStatementTo.Value;
    VATRegNo := fldAcVATRegNo.Value;
    Addr[1] := fldAcAddressLine1.Value;
    Addr[2] := fldAcAddressLine2.Value;
    Addr[3] := fldAcAddressLine3.Value;
    Addr[4] := fldAcAddressLine4.Value;
    Addr[5] := fldAcAddressLine5.Value;
    DespAddr := fldAcDespAddr.Value;
    DAddr[1] := fldAcDespAddressLine1.Value;
    DAddr[2] := fldAcDespAddressLine2.Value;
    DAddr[3] := fldAcDespAddressLine3.Value;
    DAddr[4] := fldAcDespAddressLine4.Value;
    DAddr[5] := fldAcDespAddressLine5.Value;
    Contact := fldAcContact.Value;
    Phone := fldAcPhone.Value;
    Fax := fldAcFax.Value;
    RefNo := fldAcTheirAcc.Value;
    TradTerm := fldAcOwnTradTerm.Value;
    STerms[1] := fldAcTradeTerms1.Value;
    STerms[2] := fldAcTradeTerms2.Value;
    Currency := fldAcCurrency.Value;
    VATCode := SafeReadChar(fldAcVATCode.Value);
    PayTerms := fldAcPayTerms.Value;
    CreditLimit := fldAcCreditLimit.Value;
    Discount := fldAcDiscount.Value;
    CreditStatus := fldAcCreditStatus.Value;
    CustCC := fldAcCostCentre.Value;
    CDiscCh := SafeReadChar(fldAcDiscountBand.Value);
    OrdConsMode := fldAcOrderConsolidationMode.Value;
    DefSetDDays := fldAcDefSettleDays.Value;

    // Process the Spare5 field
    lVariant := fldAcSpare5.AsVariant;
    if VarIsArray(lVariant) then
    begin
      // Map byte array onto StockCode field
      lVarArray := @Spare5;
      for i := VarArrayLowBound(lVariant, 1) to VarArrayHighBound(lVariant, 1) do
      begin
        if (i <= SizeOf(Spare5)) then
          lVarArray[i] := lVariant[i]
        else
          Break;
      end;
    end;

    Balance := fldAcBalance.Value;
    CustDep := fldAcDepartment.Value;
    EECMember := fldAcECMember.Value;
    NLineCount := fldAcNLineCount.Value;
    IncStat := fldAcStatement.Value;
    DefNomCode := fldAcSalesGL.Value;
    DefMLocStk := fldAcLocation.Value;
    AccStatus := fldAcAccStatus.Value;
    PayType := SafeReadChar(fldAcPayType.Value);
    OldBankSort := fldAcOldBankSort.Value;
    OldBankAcc := fldAcOldBankAcc.Value;
    BankRef := fldAcBankRef.Value;
    AvePay := fldAcAvePay.Value;
    Phone2 := fldAcPhone2.Value;
    DefCOSNom := fldAcCOSGL.Value;
    DefCtrlNom := fldAcDrCrGL.Value;
    LastUsed := fldAcLastUsed.Value;
    UserDef1 := fldAcUserDef1.Value;
    UserDef2 := fldAcUserDef2.Value;
    SOPInvCode := fldAcInvoiceTo.Value;
    SOPAutoWOff := fldAcSOPAutoWOff.Value;
    FDefPageNo := fldAcFormSet.Value;
    BOrdVal := fldAcBookOrdVal.Value;
    DirDeb := fldAcDirDebMode.Value;
    CCDSDate := fldAcCCStart.Value;
    CCDEDate := fldAcCCEnd.Value;
    CCDName := fldAcCCName.Value;
    CCDCardNo := fldAcCCNumber.Value;
    CCDSARef := fldAcCCSwitch.Value;
    DefSetDisc := fldAcDefSettleDisc.Value;
    StatDMode := fldAcStateDeliveryMode.Value;
    Spare2 := fldAcSpare2.Value;
    EmlSndRdr := fldAcSendReader.Value;
    ebusPwrd := fldAcEBusPword.Value;
    PostCode := fldAcPostCode.Value;
    CustCode2 := fldAcAltCode.Value;
    AllowWeb := fldAcUseForEbus.Value;
    EmlZipAtc := fldAcZIPAttachments.Value;
    UserDef3 := fldAcUserDef3.Value;
    UserDef4 := fldAcUserDef4.Value;
    WebLiveCat := fldAcWebLiveCatalog.Value;
    WebPrevCat := fldAcWebPrevCatalog.Value;
    TimeChange := fldAcTimeStamp.Value;
    VATRetRegC := fldAcVATCountryCode.Value;
    SSDDelTerms := fldAcSSDDeliveryTerms.Value;
    CVATIncFlg := SafeReadChar(fldAcInclusiveVATCode.Value);
    SSDModeTr := fldAcSSDModeOfTransport.Value;
    PrivateRec := fldAcPrivateRec.Value;
    LastOpo := fldAcLastOperator.Value;
    InvDMode := fldAcDocDeliveryMode.Value;
    EmlSndHTML := fldAcSendHTML.Value;
    EmailAddr := fldAcEmailAddr.Value;
    SOPConsHO := fldAcOfficeType.Value;
    DefTagNo := fldAcDefTagNo.Value;
    UserDef5 := fldAcUserDef5.Value;
    UserDef6 := fldAcUserDef6.Value;
    UserDef7 := fldAcUserDef7.Value;
    UserDef8 := fldAcUserDef8.Value;
    UserDef9 := fldAcUserDef9.Value;
    UserDef10 := fldAcUserDef10.Value;

    // Process the Binary BankSortCode field
    lVariant := fldAcBankSortCode.AsVariant;
    if VarIsArray(lVariant) then
    begin
      // Map byte array onto BankSortCode field
      lVarArray := @acBankSortCode;
      for i := VarArrayLowBound(lVariant, 1) to VarArrayHighBound(lVariant, 1) do
      begin
        if (i <= SizeOf(acBankSortCode)) then
          lVarArray[i] := lVariant[i]
        else
          Break;
      end;
    end;
    // Process the Binary acBankAccountCode field
    lVariant := fldAcBankAccountCode.AsVariant;
    if VarIsArray(lVariant) then
    begin
      // Map byte array onto acBankAccountCode field
      lVarArray := @acBankAccountCode;
      for i := VarArrayLowBound(lVariant, 1) to VarArrayHighBound(lVariant, 1) do
      begin
        if (i <= SizeOf(acBankAccountCode)) then
          lVarArray[i] := lVariant[i]
        else
          Break;
      end;
    end;
    // Process the Binary acMandateID field
    lVariant := fldAcMandateID.AsVariant;
    if VarIsArray(lVariant) then
    begin
      // Map byte array onto acMandateID field
      lVarArray := @acMandateID;
      for i := VarArrayLowBound(lVariant, 1) to VarArrayHighBound(lVariant, 1) do
      begin
        if (i <= SizeOf(acMandateID)) then
          lVarArray[i] := lVariant[i]
        else
          Break;
      end;
    end;
    
    acMandateDate := fldAcMandateDate.Value;
    acDeliveryPostCode := fldAcDeliveryPostCode.Value;
    acSubType := SafeReadChar(fldAcSubType.Value);
    acLongACCode := fldAcLongAcCode.Value;
    acAllowOrderPayments := fldAcAllowOrderPayments.Value;
    acOrderPaymentsGLCode := fldAcOrderPaymentsGLCode.Value;
    acCountry := fldAcCountry.Value;
    acDeliveryCountry := fldAcDeliveryCountry.Value;
    acPPDMode := GetPPDMode(fldAcPPDMode.Value);
    acDefaultToQR := fldAcDefaultToQR.Value;
    acTaxRegion := fldAcTaxRegion.Value;
    acAnonymisationStatus := TEntityAnonymisationStatus(fldAcAnonymisationStatus.Value);
    acAnonymisedDate := fldAcAnonymisedDate.Value;
    acAnonymisedTime := fldAcAnonymisedTime.Value;
  end;
end;

function TSQLTraders.Validate: Boolean;
begin
  Result := True;
  ValidationError := '';
end;

{ TSQLSelectTraders }

procedure TSQLSelectTraders.OpenFile;
var
  lConnStr: AnsiString;
  lSQLQry: String;
begin
  if not Assigned(SQLCaller) then
  begin
    //RB 06/07/2017 2017-R2 ABSEXCH-18944: Use Global SQL Connection for SQLCaller
    SQLCaller := TSQLCaller.Create(GlobalADOConnection);
    FUsingInternalSQLCaller := True;
  end;

  if SQLCaller.Records.Active then
    SQLCaller.Records.Close;

  if Validate then
  begin
    { Build the full query from the assigned parts, and retrieve the recordset }
    lSQLQry := Format('SELECT %s %s %s %s %s', [FColumns, FFromClause, FJoinClause, FWhereClause, FOrderByClause]);
    SQLCaller.Select(lSQLQry, CompanyCode);

    if (SQLCaller.ErrorMsg = '') then
    begin
      PrepareFields;
      { Disable the link to the UI to improve performance when iterating through
        the dataset }
      SQLCaller.Records.DisableControls;
    end
    else
      OnError('TSQLTraders.OpenFile: ' + SQLCaller.ErrorMsg);
  end
  else
    { Validation failed }
    OnError('TSQLTraders.OpenFile: ' + ValidationError);
end;

function TSQLSelectTraders.Validate: Boolean;
begin
  Result := True;
  ValidationError := EmptyStr;
  if Trim(CompanyCode) = EmptyStr then
  begin
    ValidationError := ErrCompanyCode;
    Result := False;
  end
  else if Trim(FFromClause) = EmptyStr then
  begin
    ValidationError := 'No "From" clause assigned';
    Result := False;
  end
  else if (Pos('FROM ', Uppercase(FFromClause)) = 0) then
  begin
    ValidationError := 'Invalid "From" clause (must contain "FROM")';
    Result := False;
  end
  else if (Trim(JoinClause) <> EmptyStr) and (Pos('JOIN ', Uppercase(JoinClause)) = 0) then
  begin
    ValidationError := 'Invalid "JOIN" clause (must contain "JOIN")';
    Result := False;
  end
  else if (Trim(WhereClause) <> EmptyStr) and (Pos('WHERE ', Uppercase(WhereClause)) = 0) then
  begin
    ValidationError := 'Invalid "WHERE" clause (must contain "WHERE")';
    Result := False;
  end
  else if (Trim(OrderByClause) <> EmptyStr) and (Pos('ORDER BY ', Uppercase(OrderByClause)) = 0) then
  begin
    ValidationError := 'Invalid "ORDER BY" clause (must contain "ORDER BY")';
    Result := False;
  end;
  {else if Trim(WhereClause) = EmptyStr then
  begin
    ValidationError := 'A WHERE clause is required';
    Result := False;
  end;}
end;

{ TSQLStoredProcedureTraders }

procedure TSQLStoredProcedureTraders.OpenFile;
var
  lConnStr: AnsiString;
  lSQLQry: String;
begin
  if not Assigned(SQLCaller) then
  begin
    //RB 06/07/2017 2017-R2 ABSEXCH-18944: Use Global SQL Connection for SQLCaller
    SQLCaller := TSQLCaller.Create(GlobalADOConnection);
    FUsingInternalSQLCaller := True;
  end;

  if SQLCaller.Records.Active then
    SQLCaller.Records.Close;
  if Validate then
  begin
    { Build the full query from the assigned parts, and retrieve the recordset }
    lSQLQry := FStoredProcedure;
    SQLCaller.Select(lSQLQry, CompanyCode);

    if SQLCaller.ErrorMsg = EmptyStr then
    begin
      if Count > 0 then
      begin
        PrepareFields;
        { Disable the link to the UI to improve performance when iterating through
          the dataset }
        SQLCaller.Records.DisableControls;
      end;
    end
    else
      { Validation failed }
      OnError('TSQLStoredProcedureTraders.OpenFile: ' + SQLCaller.ErrorMsg);
  end
  else
    { Validation failed }
    OnError('TSQLStoredProcedureTraders.OpenFile: ' + ValidationError);
end;

function TSQLStoredProcedureTraders.Validate: Boolean;
begin
  Result := True;
  ValidationError := EmptyStr;
  if Trim(CompanyCode) = EmptyStr then
  begin
    ValidationError := ErrCompanyCode;
    Result := False;
  end
  else if Trim(StoredProcedure) = EmptyStr then
  begin
    ValidationError := 'No stored procedure assigned';
    Result := False;
  end;
end;

end.



