unit XmlParse;

{ prutherford440 09:52 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  UseDLLU, SysUtils, XMLUtil, VarConst, XMLBase, Classes, XMLConst, EbusVar,
  {$IFDEF VCXML}
    vcxml_tlb
  {$ELSE}
    msxml_tlb
  {$ENDIF} ;

{$I Exdllbt.inc}
{$I Exchdll.inc}



type

  TBatchLinesRec  =  Array[1..190] of TBatchTLRec;

  TErrorLogInfo = record
    ErrorStatus : TLogErrorStatus;
    ErrorMessage : ShortString;
    ErrorCode : integer;
  end;
  PErrorLogInfo = ^TErrorLogInfo;

  PBatchTHRec = ^TBatchTHRec;
  PBatchLinesRec = ^TBatchLinesRec;

  PTrLineArray = ^TTrLineArray;
  TTrLineArray = Array of TBatchTLRec;

  PPresLineArray = ^TPresLineArray;
  TPresLineArray = Array of TPreserveLineFields;

  // Any fatal error which prevents parsing
  EXMLFatalError = Exception;

  TXmlParseErrorLog = class(TList)
    private
      fLogStatus : TLogErrorStatus;
    protected
      procedure   SetLogStatus(Value : TLogErrorStatus);
    public
      procedure   Add(Status : TLogErrorStatus; const Msg : string; Code : integer);
      function    GetErrorLogLine(Line : integer) : string;
      procedure   ShowErrors;
      constructor Create;
      destructor  Destroy; override;
      property    LogStatus : TLogErrorStatus read fLogStatus write SetLogStatus;
  end;

  TXmlParse = class(TReadWriteXMLBase)
    private
      XmlDoc   : IXMLDOMDocument;
      //23.3.2001 Changed fLines to dynamic array to allow transactions with > 190 lines
      fLines   : {PBatchLinesRec;}PTrLineArray;
      fCustSupp : ^TBatchCURec;
      fHeader  : PBatchTHRec;
      fTotalLines : integer;
      fXmlSaveMode : TXmlSaveMode;
      fCreatedTransName : string;
      fDocGroup : TDocGroup;
      fDocType : DocTypes;
      fNotes : AnsiString;
      fErrorLog : TXmlParseErrorLog;
      fTransferMode : TTransferMode; // Whether to replicate or process transaction

      // Default values
      fDefaultCC,
      fDefaultDept,
      fDefaultLocation,
      fDefaultCustCode,
      fDefaultSuppCode,
      fCompanyCode,

      {$IFDEF EXTERNALIMPORT}
        fCompanyPath,
      {$ENDIF}

      fDiscStockCode,
      fMiscStockCode,
      fFreightStockCode,
      fFreightDesc,
      fMiscDesc,
      fDiscDesc : string;
      fFreightMap,
      fMiscMap,
      fDiscMap  : integer;
      fDefaultPurchNomCode,
      fDefaultSalesNomCode : longint;
      fDefaultVATCode : char;
(*      fDefaultPeriodMethod : TPeriodMethod;
      fDefaultFinPeriod,
      fDefaultFinYear    : byte; *)
      fEnterpriseXML : boolean;
      fUseStockForCharges : Boolean;
      fReapplyPricing : Boolean;
      fLocOrigin : Byte;
      LineVatTotal : Double;
      fPresLineFields : TPresLineArray;
      fPresDocFields : TPreserveDocFields;
      fUDF1 : Boolean;
      fGeneralNotes : Boolean;
      fCCDepFromXML : Boolean;
      SchemaVersionRead : string;
      function UseBasda309 : Boolean;
    protected
      procedure SetInteger(Index, Value : integer);
      procedure SetChar(Value : char);
      procedure SetString(Index : integer; const Value : string);

    (*  procedure SetByte(const Index: Integer; const Value: byte);
      procedure SetDefaultPeriodMethod(const Value: TPeriodMethod); // XML document being read originates from Enterprise *)
      function  SafeSelectSingleNodeText(ParentNode : IXmlDOMNode; ChildNodeName : string) : string;
      function  SafeSelectAttributeText(Node : IXmlDOMNode; AttributeName : string) : string;
      procedure SetDocumentType;
      procedure AssignCustSuppRec;
      procedure ReadHead;
      function  ReadBuySupCode(const TransTag, BuySup, BuySupRef, CodeOwner : string) : string;
      procedure ReadReferences(const XMLTransTag, XMLTransRef, RefTypeTag : string);
      procedure ReadLineReferences(const XMLTransTag, XMLTransRef, RefTypeTag : string; LineNo : Integer);
      //PR: 16/10/2013 ASEXCH-14703 Add postcode parameter
      procedure ReadAddress(AddressNodeList : IXMLDOMNodeList; var AddressDetails : TAddressDetails;
                            var sPostCode : TPostcodeString);
//      procedure SetPeriod;
      procedure ReadDate(Query : array of string; var DateField : shortstring);
      procedure ReadCurrency(Query : string; var CurrencyField : smallint);
      procedure ReadCustomer;
      procedure ReadSupplier;
      procedure ReadDiscount(ParentNode : IXmlDOMNode;
        var DiscountPercent, DiscountAmount : double);  overload;
      //PR: 28/05/2009 Overload ReadDiscount to deal with Advanced Discounts
      procedure ReadDiscount(ParentNode : IXmlDOMNode;
        var DiscountPercent, DiscountAmount,
            DiscountPercent2, DiscountAmount2,
            DiscountPercent3, DiscountAmount3 : double); overload;
      procedure ReadOrderSettlementDisc;
      procedure ReadOrderFullSettlementDisc;
      procedure ReadInvoiceSettlementDate;
      procedure ReadInvoiceSettlementDisc;
      procedure ReadDelAddress(const TransTag : string);
      procedure ReadTaxTotal;
      procedure ReadNarrative(const XMLTransTag : string);
      procedure ReadTransactionLines(const XMLTransTag, XMLTransLineTag : string);
      function  AddTrans : integer;
      function  NextDocNo(DocType : string) : string;
      function LineTypeMap(const AType : string) : integer;
      procedure ReadHeaderUDFields;
      procedure ReadLineUDFields;
      procedure ReadDiscountDays(ParentNode   : IXmlDOMNode;
                           const DiscType     : String;
                             var DiscountDays : SmallInt);
    public
      LSplit : Array[1..6] of Double;
      destructor Destroy; override;
      procedure Initialise(XMLSaveMode : TXmlSaveMode; DocName : string);
      //PR 19/12/2007 PreserveLines array wasn't being finalized so added this function that can be called from the importer
      procedure FinalizePreserveLines;
      function Parse : TImportXML; overload;
      function Parse(var Status : integer) : TImportXML; overload;
      property TotalLines : longint index 1 read fTotalLines write SetInteger;
      property CreatedTransName : string read fCreatedTransName;
      property DefaultCC : string index 1 read fDefaultCC write SetString;
      property DefaultDept : string index 2 read fDefaultDept write SetString;
      property DefaultLocation : string index 3 read fDefaultLocation write SetString;
      property DefaultCustCode : string index 4 read fDefaultCustCode write SetString;
      property DefaultSuppCode : string index 5 read fDefaultSuppCode write SetString;
      property DefaultPurchNomCode : longint index 2 read fDefaultPurchNomCode write SetInteger;
      property DefaultSalesNomCode : longint index 3 read fDefaultSalesNomCode write SetInteger;
      property DefaultVATCode : char read fDefaultVATCode write SetChar;
      (*  Not needed here - actually set correctly on adding to daybook
      property DefaultPeriodMethod : TPeriodMethod read fDefaultPeriodMethod write SetDefaultPeriodMethod;
      property DefaultFinPeriod : byte index 1 read fDefaultFinPeriod write SetByte;
      property DefaultFinYear : byte index 2 read fDefaultFinYear write SetByte; *)
      property CompanyCode : string index 6 read fCompanyCode write SetString;
      property Header : PBatchTHRec read fHeader;
      property Lines : {PBatchLinesRec}PTrLineArray read fLines;
      property ErrorLog : TXmlParseErrorLog read fErrorLog;
      property TransferMode : TTransferMode read fTransferMode;
      property FreightStockCode : string index 7 read fFreightStockCode write SetString;
      property MiscStockCode : string index 8 read fMiscStockCode write SetString;
      property DiscStockCode : string index 9 read fDiscStockCode write SetString;
      property UseStockForCharges : Boolean read fUseStockForCharges
                                          write fUseStockForCharges;
      property FreightDesc : string index 10 read fFreightDesc write SetString;
      property MiscDesc : string index 11 read fMiscDesc write SetString;
      property DiscDesc : string index 12 read fDiscDesc write SetString;

      {$IFDEF EXTERNALIMPORT}
        property CompanyPath : string index 13 read fCompanyPath write SetString;
      {$ENDIF}

      property ReapplyPricing : Boolean read fReapplyPricing
                                        write fReapplyPricing;
      property FreightMap : integer index 4 read fFreightMap write SetInteger;
      property MiscMap : integer index 5 read fMiscMap write SetInteger;
      property DiscMap : integer index 6 read fDiscMap write SetInteger;
      property Notes : AnsiString read fNotes;
      property PresLineFields : TPresLineArray read fPresLineFields;
      property PresDocFields : TPreserveDocFields read fPresDocFields;
      property LocationOrigin : Byte read FLocOrigin write FLocOrigin;
      property ImportUDF1 : Boolean read fUDF1 write fUDF1;
      property GeneralNotes : Boolean read fGeneralNotes write fGeneralNotes;
      property CCDepFromXML : Boolean read fCCDepFromXML write fCCDepFromXML;

 end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

uses
  ComObj, Dialogs, eBusLkup, Controls, ETMiscU, EBusUtil, AdmnUtil, StrUtil,
  Debugger, EtDateU, MathUtil, TransactionHelperU, //PR: 24/02/2015 ABSEXCH-15298 Settlement Discount withdrawn from 01/04/2015;
  CountryCodeUtils;

type
  EParseXMLError = Exception;



// In transfer mode ...
// Read in a POR and treat as an SOR
// Read in a SIN and treat as a PIN

//-----------------------------------------------------------------------------------

constructor TXmlParseErrorLog.Create;
begin
  inherited Create;
  LogStatus := logWarn;
end;

//-----------------------------------------------------------------------------------

destructor TXmlParseErrorLog.Destroy;
var
  i : integer;
begin
  for i := 0 to Count -1 do
    if assigned(Items[i]) then
    begin
      dispose(PErrorLogInfo(Items[i]));
      Items[i] := nil;
    end;
  inherited Destroy;
end; // TXmlParseErrorLog.Destroy

//-----------------------------------------------------------------------------------

procedure TXmlParseErrorLog.SetLogStatus(Value : TLogErrorStatus);
begin
  fLogStatus := Value;
end;

//-----------------------------------------------------------------------------------

procedure TXmlParseErrorLog.Add(Status : TLogErrorStatus; const Msg : string; Code : integer);
var
  ErrorRec : PErrorLogInfo;
begin
  new(ErrorRec);
  with ErrorRec^ do
  begin
    ErrorStatus := Status;
    ErrorMessage := Msg;
    ErrorCode := Code;
  end;
  if Status = logError then
    logStatus := logError;
  inherited Add(ErrorRec);
end; // TXmlParseErrorLog.Add

//-----------------------------------------------------------------------------------

function TXmlParseErrorLog.GetErrorLogLine(Line : integer) : string;
begin
  Result := PErrorLogInfo(Items[Line])^.ErrorMessage;
end;

//-----------------------------------------------------------------------------------

procedure TXmlParseErrorLog.ShowErrors;
var
  i : integer;
begin
  for i := 0 to Count - 1 do
    if MessageDlg(GetErrorLogLine(i), mtInformation, [mbOK, mbCancel], 0) = mrCancel then
      break
end;

//===================================================================================

procedure TXmlParse.Initialise(XMLSaveMode : TXmlSaveMode; DocName : string);
begin
  fXMLSaveMode := XMLSaveMode;
  fErrorLog := TXMLParseErrorLog.Create;

  if not LoadXMLDocument(DocName, XMLDoc) then
    raise EXMLFatalError.CreateFmt('Could not load xml document %s', [DocName]);
  new(fHeader);
  new(fLines);
  new(fCustSupp);
  FillChar(fHeader^, SizeOf(fHeader^), 0);
  FillChar(fLines^, SizeOf(fLines^), 0);
  FillChar(fCustSupp^, SizeOf(fCustSupp^), 0);
  FillChar(fPresDocFields, SizeOf(fPresDocFields), 0);


  // Store the xml document's name in DocUser1 field
  fHeader^.DocUser1 := ExtractFileName(DocName);

(*  if fXMLSaveMode = xmlDemo then
    InitialiseToolkit; *)

  ReadSystemInfo;
  ReadVATInfo;
  ReadCurrencyInfo;
end; // TXmlParse.Create

//-----------------------------------------------------------------------------------

destructor TXmlParse.Destroy;
begin
  if Assigned(fHeader) then
    dispose(fHeader);
  if Assigned(fLines) then
    dispose(fLines);
  if Assigned(fCustSupp) then
    dispose(fCustSupp);
  if Assigned(fErrorLog) then
    fErrorLog.Free;
(*  if fXMLSaveMode = xmlDemo then
    Ex_CloseDLL; *)
  inherited Destroy;
end; // TXmlParse.Destroy

//-----------------------------------------------------------------------------------

function TxmlParse.SafeSelectSingleNodeText(ParentNode : IXmlDOMNode; ChildNodeName : string) : string;
// Post  : Returns the text value of the node, or a blank string if it does not exist
// Notes : selectSingleNode will return a nil pointer if the specified ChildNodeName does not exist.
//         Accessing its text property then returns an access violation.
var
  ChildNode : IxmlDOMNode;
begin
  Result := '';
  if Assigned(ParentNode) then
  begin
    ChildNode := ParentNode.selectSingleNode(ChildNodeName);
    if Assigned(ChildNode) then
      Result := ChildNode.Text
  end;
end; // TxmlParse.SafeSelectSingleNodeText

//-----------------------------------------------------------------------------------

function TXmlParse.SafeSelectAttributeText(Node : IXmlDOMNode; AttributeName : string) : string;
// Post : Returns the named attribute value from the specified node.
//        If the node is invalid or the attribute not found returns an empty string
var
  Attribute : IXMLDOMNode;
begin
  Result := '';
  if Assigned(Node) then
  begin
    Attribute := Node.attributes.getNamedItem(AttributeName);
    if Assigned(Attribute) then
      Result := Attribute.text
  end;
end; // TXmlParse.SafeSelectAttributeText

//-----------------------------------------------------------------------------------

procedure TXmlParse.SetDocumentType;
// Post : fDocGroup set to grpInvoices or grpOrders
//        fDocType set to SIN, PIN, SOR, POR
//        fTransferMode set to tfrExchange or tfrReplication
var
  {$IFDEF EXTERNALIMPORT}
    nEnterprise  : IXmlDOMNodeList;
    Attribute : IXMLDOMNode;
  {$ENDIF}
  Transaction,
  ReplicationInfo : IXmlDOMNodeList;
  XMLType,
  TransTypeRead,
  TransferModeRead : string;
begin
  Transaction := XmlDoc.getElementsByTagName(XML_ORDER_HEAD);
  if Transaction.Length = 0 then
  begin
    fDocGroup := grpInvoices;
    {$IFDEF EXTERNALIMPORT}
      // Support for SRIs
      nEnterprise := XmlDoc.getElementsByTagName(XML_ENTERPRISE);
      if nEnterprise.length > 0 then
      begin
        Attribute := nEnterprise.item[0].attributes.getNamedItem(XML_TRANSACTION_TYPE);
        if UpperCase(Trim(Attribute.text)) = 'SRI' then fDocGroup := grpSRI;
      end;{if}
    {$ENDIF}
  end else
  begin
    fDocGroup := grpOrders;
  end;

  fTransferMode := tfrExchange;
  if fDocGroup = grpInvoices then
  begin
    XMLType := XML_INVOICE_HEAD;
    fDocType := SIN;
  end
  else
  begin
    XMLType := XML_ORDER_HEAD;
    fDocType := POR;
    {$IFDEF EXTERNALIMPORT}
      if fDocGroup = grpSRI then
      begin
        XMLType := XML_INVOICE_HEAD;
        fDocType := SRI;
      end;{if}
    {$ENDIF}
  end;

  fEnterpriseXML := false;
  ReplicationInfo := XmlDoc.getElementsByTagName(
    XSLQuery([XMLType, XML_PROPRIETARY, XML_ENTERPRISE]));
  if ReplicationInfo.Length > 0 then
  begin
    fEnterpriseXML := true;
    TransTypeRead := SafeSelectAttributeText(ReplicationInfo.item[0], XML_TRANSACTION_TYPE);
    TransferModeRead := SafeSelectAttributeText(ReplicationInfo.item[0], XML_TRANSFER_MODE);
    if Trim(TransferModeRead) = ENT_REPLICATION then
      fTransferMode := tfrReplication;
    fDocType := EntTransStrToEnum(Trim(TransTypeRead));
  end;
end; // TXmlParse.SetDocumentType

//-----------------------------------------------------------------------------------

procedure TXmlParse.AssignCustSuppRec;
var
  SearchRef : array[0..255] of char;

  function LJVar(const s : String; Len : Integer) : String;
  begin
    Result := Copy(s + StringOfChar(' ', Len), 1, Len);
  end;

begin
  if length(fHeader^.CustCode) <> 0 then
  begin
    StrPCopy(SearchRef, LJVar(fHeader^.CustCode, 6));
    Ex_GetAccount(fCustSupp, SizeOf(fCustSupp^), SearchRef, 0, B_GetEq, 0, false);
  end;
end;

//-----------------------------------------------------------------------------------

function TXmlParse.Parse(var Status : integer) : TImportXML;
begin
  Debug.Show('TXmlParse.Parse called');
  with XmlDoc do
  begin
    SetDocumentType;
    FillChar(fPresDocFields, SizeOf(fPresDocFields), 0);
    if fDocGroup = grpOrders then
    begin // Orders
      ReadHead;
      //UDF
      ReadHeaderUDFields;
      ReadCurrency(XSLQuery([XML_ORDER, XML_ORDER_HEAD, XML_ORDER_CURRENCY]), fHeader^.Currency);
      ReadReferences(XML_ORDER, XML_ORDER_REFERENCE, XML_BUYER_ORDER_NO);
      ReadReferences(XML_ORDER, XML_ORDER_REFERENCE, XML_SUPPLIER_ORDER_REFERENCE);
      ReadReferences(XML_ORDER, XML_ORDER_REFERENCE, XML_PROJECT_CODE);
      ReadReferences(XML_ORDER, XML_ORDER_REFERENCE, XML_PROJECT_ANALYSIS_CODE);

      ReadDate([XML_ORDER, XML_ORDER_DATE], fHeader^.TransDate);
      ReadDate([XML_ORDER, XML_DELIVERY, XML_LATEST_DATE], fHeader^.DueDate);
      ReadNarrative(XML_ORDER);
//      SetPeriod;
      if fTransferMode = tfrExchange then
        ReadCustomer // POR Exchange
      else
        if fDocType = POR then
          ReadSupplier  // POR Replication
        else
          ReadCustomer; // SOR Replication
      AssignCustSuppRec;
      ReadDelAddress(XML_ORDER);
      //PR 20/12/02 Added to read settlement discount days
{      ReadOrderFullSettlementDisc;
      if FHeader^.DiscSetl = 0 then
        ReadOrderSettlementDisc;}
      //PR 15/09/03 don't have settlement discount on order in basda spec so take from customer defaults

      //PR: 24/02/2015 ABSEXCH-15298 Settlement Discount withdrawn from 01/04/2015
      if (Trim(fHeader^.CustCode) <> '') and SettlementDiscountSupportedForDate(fHeader^.TransDate) then
      begin
        fHeader^.DiscSetl := fCustSupp.DefSetDisc / 100;
        fHeader^.DiscDays := fCustSupp.DefSetDDays;
      end;
      ReadTransactionLines(XML_ORDER, XML_ORDERLINE);
      Status := AddTrans;
    end
    else
    begin // Invoices
      ReapplyPricing := False;//Can't reapply on invoices?
      ReadHead;
      //UDF
      ReadHeaderUDFields;
      ReadCurrency(XSLQuery([XML_INVOICE, XML_INVOICE_HEAD, XML_INVOICE_CURRENCY]), fHeader^.Currency);
      ReadReferences(XML_INVOICE, XML_INVOICE_REFERENCE, XML_BUYER_ORDER_NO);
      ReadReferences(XML_INVOICE, XML_INVOICE_REFERENCE, XML_SUPPLIER_INVOICE_NO);
      ReadReferences(XML_INVOICE, XML_INVOICE_REFERENCE, XML_PROJECT_CODE);
      ReadReferences(XML_INVOICE, XML_INVOICE_REFERENCE, XML_PROJECT_ANALYSIS_CODE);
      ReadReferences(XML_INVOICE, XML_INVOICE_REFERENCE, XML_BUYER_CODE_DELIVERY);
      ReadDate([XML_INVOICE, XML_INVOICE_DATE], fHeader^.TransDate);
      ReadNarrative(XML_INVOICE);
//      SetPeriod;

      {$IFDEF EXTERNALIMPORT}
        if fTransferMode = tfrExchange then
        begin
          ReadSupplier // SIN Exchange
        end else
        begin
          if (fDocType = SIN) or (fDocType = SRI) or (fDocType = SCR) then ReadCustomer // SIN/SRI/SCR Replication
          else ReadSupplier; // PIN Replication
        end;
      {$ELSE}
        if fTransferMode = tfrExchange then
          ReadSupplier // SIN Exchange
        else //PR 29/08/07 Added SCR to SIN Replication check
          if (fDocType in [SIN, SCR]) then
            ReadCustomer // SIN Replication
          else
            ReadSupplier; // PIN Replication
      {$ENDIF}

      AssignCustSuppRec;
      ReadDelAddress(XML_INVOICE);
      ReadInvoiceSettlementDate;
      ReadInvoiceSettlementDisc;
      ReadTransactionLines(XML_INVOICE, XML_INVOICELINE);
      ReadTaxTotal;
      Status := AddTrans;
    end;
  end;

  // fErrorLog.ShowErrors;
  Result := impOK;
  if (fErrorLog.Count > 0) then
    if fErrorLog.logStatus = logWarn then
      Result := impWarn
    else
      Result := impError;
end; // TXmlParse.Parse

//-----------------------------------------------------------------------------------

function TXmlParse.Parse : TImportXML;
var
  intDum : integer;
begin
  Result := Parse(intDum);
end;

//-----------------------------------------------------------------------------------

procedure TXmlParse.ReadHead;
const
  SCHEMA_VERSION_EXPECTED = 3;

  MAX_ALLOWED_ORDER_TYPES = 17;
  ALLOWED_ORDER_TYPES : array[1..MAX_ALLOWED_ORDER_TYPES] of string =
   (BASDA_PURCH_ORDER, BASDA_BLANKET_ORDER, BASDA_SPOT_ORDER, BASDA_LEASE_ORDER,
    BASDA_RUSH_ORDER, BASDA_REPAIR_ORDER, BASDA_CALL_OFF_ORDER, BASDA_CONSIGNMENT_ORDER,
    BASDA_SAMPLE_ORDER, BASDA_SWAP_ORDER, BASDA_HIRE_ORDER,
    BASDA_CHANGE_ORDER, BASDA_RESPONSE_ORDER, BASDA_SPARE_PARTS_ORDER,
    BASDA_WEB_ORDER, BASDA_QUOTE_REQUEST_ORDER, BASDA_QUOTE_RESPONSE_ORDER);

  MAX_ALLOWED_INVOICE_TYPES = 15;
  ALLOWED_INVOICE_TYPES : array[1..MAX_ALLOWED_INVOICE_TYPES] of string =
    (BASDA_COMMERCIAL_INVOICE, BASDA_COMMISSION_NOTE, BASDA_DEBIT_NOTE,
     BASDA_CONSOLIDATED_INVOICE, BASDA_PREPAYMENT_INVOICE, BASDA_HIRE_INVOICE,
     BASDA_TAX_INVOICE, BASDA_SELF_BILLED_INVOICE, BASDA_FACTORED_INVOICE,
     BASDA_LEASE_INVOICE, BASDA_CONSIGNMENT_INVOICE, BASDA_CREDIT_INVOICE,
     BASDA_CORRECTED_INVOICE, BASDA_PRO_FORMA_INVOICE, BASDA_DELCREDERE_INVOICE);

  MAX_ALLOWED_ORDER_FUNCTIONS = 9;
  ALLOWED_ORDER_FUNCTIONS : array[1..MAX_ALLOWED_ORDER_FUNCTIONS] of string =
    (BASDA_FIRM_ORDER, BASDA_PROPOSED_ORDER, BASDA_PROVISIOAL_ORDER, BASDA_TEST_ORDER,
    BASDA_AMENDMENT_ORDER, BASDA_CANCELLATION_ORDER, BASDA_COPY_ORDER, BASDA_REPLACEMENT_ORDER,
    BASDA_VARIATION_ORDER);

  MAX_ALLOWED_INVOICE_FUNCTIONS = 7;
  ALLOWED_INVOICE_FUNCTIONS : array[1..MAX_ALLOWED_INVOICE_FUNCTIONS] of string =
    (BASDA_FIRM_INVOICE, BASDA_PROPOSED_INVOICE, BASDA_PROVISIONAL_INVOICE,
     BASDA_TEST_INVOICE, BASDA_AMENDMENT_INVOICE, BASDA_CANCELLATION_INVOICE,
     BASDA_COPY_INVOICE);
var
  HeadTag,
  SchemaTag,
  TransTypeTag,
  FunctionTag : IXmlDOMNodeList;
  XMLTransTag,
  XMLTransHeadTag,
  XMLTransTypeTag,
  TransTypeRead,
  LSchemaVersionRead,
  FuncCodeRead,
  Query    : string;

  FuncCodeOK,
  TransTypeOK : boolean;
  CopyText : string;

  procedure CheckTagStructureValid(Tag : IXmlDOMNodeList);
  begin
    // Must be only one tag
    if Tag.Length = 0 then
      raise EXMLFatalError.CreateFmt('Tag %s missing', [Query]);
    if Tag.Length > 1 then
      raise EXMLFatalError.CreateFmt('Multiple %s tags', [Query]);
  end;

  function InStringSet(const SearchValue : string; Values : array of string) : boolean;
  var
    i : integer;
  begin
    i := Low(Values);
    Result := false;
    while (i <= High(Values)) and not Result do
    begin
      Result := SearchValue = Values[i];
      inc(i);
    end;
  end;

begin // TXmlParse.ReadHead
  if fDocGroup = grpOrders then
  begin
    XMLTransTag := XML_ORDER;
    XMLTransHeadTag := XML_ORDER_HEAD;
    XMLTransTypeTag := XML_ORDER_TYPE;
  end
  else
  begin
    XMLTransTag := XML_INVOICE;
    XMLTransHeadTag := XML_INVOICE_HEAD;
    XMLTransTypeTag := XML_INVOICE_TYPE;
  end;

  // Check only one header tag
  Query := XSLQuery([XMLTransTag, XMLTransHeadTag]);
  HeadTag := XmlDoc.getElementsByTagName(Query);
  CheckTagStructureValid(HeadTag);

  // Check only one schema tag
  Query := XSLQuery([XMLTransHeadTag, XML_SCHEMA, XML_VERSION]);
  SchemaTag := XmlDoc.getElementsByTagName(Query);
  CheckTagStructureValid(SchemaTag);
  SchemaVersionRead := SchemaTag[0].Text;
  LSchemaVersionRead := ExtractLeadingInteger(SchemaTag[0].Text);
  if StrToInt(LSchemaVersionRead) < SCHEMA_VERSION_EXPECTED then
    raise EXMLFatalError.CreateFmt('Schema version read: "%s".' + CRLF +
      'Expected: "%s"', [LSchemaVersionRead, SCHEMA_VERSION_EXPECTED]);

  // Check only one transaction type tag
  Query := XSLQuery([XMLTransTag, XMLTransHeadTag, XMLTransTypeTag]);
  TransTypeTag := XmlDoc.getElementsByTagName(Query);
  CheckTagStructureValid(TransTypeTag);

  // Must be of correct transaction type - or may be blank in which case
  // PUO or INV is assumed
  TransTypeRead := SafeSelectAttributeText(TransTypeTag.item[0], XML_CODE);
  if fDocGroup = grpOrders then
    TransTypeOK := (TransTypeRead = '') or (InStringSet(TransTypeRead, ALLOWED_ORDER_TYPES))
  else
    TransTypeOK := (TransTypeRead = '') or InStringSet(TransTypeRead, ALLOWED_INVOICE_TYPES);


  if fTransferMode = tfrReplication then
  begin
    if (fDocGroup = grpOrders) and (TransTypeRead = BASDA_SALES_ORDER) then
    begin
      TransTypeOK := True;
      fDocType := SOR;
    end;
  end;

  //PR 29/08/07 Added SCR/PCR functionality
  if TransTypeOK and (TransTypeRead = BASDA_CREDIT_INVOICE) then
    fDocType := SCR;

  {$IFDEF EXTERNALIMPORT}
    if (not TransTypeOK) and ((TransTypeRead = 'SRI') or (TransTypeRead = 'SIN') or (TransTypeRead = 'SCR'))
    then TransTypeOK := TRUE;
  {$ENDIF}

  if not TransTypeOK then
    raise EXMLFatalError.CreateFmt('Invalid transaction type code %s read: "%s".',
      [Query, TransTypeRead]); 

  // Read function type
  Query := XSLQuery([XMLTransTag, XMLTransHeadTag, XML_FUNCTION]);
  FunctionTag := XmlDoc.getElementsByTagName(Query);
  // Function tag is not mandatory
  if FunctionTag.Length > 0 then
  begin
    FuncCodeRead := SafeSelectAttributeText(FunctionTag.item[0], XML_CODE);

    if fDocGroup = grpOrders then
      FuncCodeOK := InStringSet(FuncCodeRead, ALLOWED_ORDER_FUNCTIONS)
    else
      FuncCodeOK := InStringSet(FuncCodeRead, ALLOWED_INVOICE_FUNCTIONS);

    if not ((FuncCodeRead = '') or FuncCodeOK) then
      raise EXMLFatalError.CreateFmt('Invalid transaction function code read: "%s".',
        [FuncCodeRead])
    else
    if (FuncCodeRead = BASDA_COPY_INVOICE) or (FuncCodeRead = BASDA_COPY_ORDER) then
    begin
      if fDocGroup = grpOrders then
        CopyText := 'ORDER'
      else
        CopyText := 'INVOICE';
      fErrorLog.Add(logWarn, '*** THIS IS A COPY ' + CopyText + ' ***', 0);
    end;

  end;
end; // TXmlParse.ReadHead

//-----------------------------------------------------------------------------------

procedure TXmlParse.ReadReferences(const XMLTransTag, XMLTransRef, RefTypeTag : string);
var
  DocumentRefs : IXmlDOMNodeList;
  Ref, p : string;
  i : integer;

  function WantPreserve : Boolean;
  var
    Preserve : string;
    Node : IXmlDOMNode;
  begin
    Node := DocumentRefs.item[i].selectSingleNode(RefTypeTag);
    if Assigned(Node) then
    begin
      Preserve := UpperCase(SafeSelectAttributeText(Node, XML_PRESERVE));
      Result := Preserve = 'TRUE';
    end
    else
      Result := False;
  end;

  procedure SetPreserveField;
  begin
    if WantPreserve then
    begin
      if RefTypeTag = XML_BUYER_ORDER_NO then
        fPresDocFields.InvBuyersOrder := Ref
      else
      if RefTypeTag = XML_SUPPLIER_INVOICE_NO then
        fPresDocFields.InvSuppInvoice := Ref
      else
      if RefTypeTag = XML_PROJECT_CODE then
        fPresDocFields.InvProjectCode := Ref
      else
      if RefTypeTag = XML_PROJECT_ANALYSIS_CODE then
        fPresDocFields.InvAnalysisCode := Ref
      else
      if RefTypeTag = XML_BUYER_CODE_DELIVERY then
        fPresDocFields.InvBuyersDelivery := Ref;
    end;
  end;

begin
  DocumentRefs := XmlDoc.getElementsByTagName(XSLQuery([XMLTransTag, XMLTransRef]));
  for i := 0 to DocumentRefs.length -1 do
  begin
    Ref := SafeSelectSingleNodeText(DocumentRefs.item[i], RefTypeTag);
    if Ref <> '' then
    begin
      SetPreserveField;
      if (RefTypeTag = XML_BUYER_ORDER_NO) or (RefTypeTag = XML_SUPPLIER_INVOICE_NO) then
        fHeader^.YourRef := Ref
      else
      if RefTypeTag = XML_SUPPLIER_ORDER_REFERENCE then
        fHeader^.DocUser2 := Ref;

      if fDocGroup = grpInvoices then
      begin
        if RefTypeTag = XML_PROJECT_CODE then
          fHeader^.DJobCode := Ref
        else
        if RefTypeTag = XML_PROJECT_ANALYSIS_CODE then
          fHeader^.DJobAnal := Ref;
      end;
    end;
(*  if SafeSelectAttributeText(DocumentRefs.item[i], XML_REFTYPE) = AltRefTypeVal then
      fHeader^.LongYrRef := SafeSelectSingleNodeText(DocumentRefs.item[i], XML_REFCODE); *)
  end;
end;

//-----------------------------------------------------------------------------------
(*
procedure TXmlParse.SetPeriod;
var
  PDate : array[0..8] of char;
  Period, Year : smallint;
begin
  case DefaultPeriodMethod of
    perFromTransDate:
      begin
        StrpCopy(PDate, fHeader^.TransDate);
        if Ex_DateToEntPeriod(PDate, Period, Year) = 0 then
        begin
          fHeader^.AcPr := Period;
          fHeader^.AcYr := Year;
        end;
      end;
    perFromEntPeriod:
      begin
        fHeader^.AcPr := SysInfo^.ExPr;
        fHeader^.AcYr := SysInfo^.ExYr;
       end;
    perToFixedPeriod:
      begin
        fHeader^.AcPr := DefaultFinPeriod;
        fHeader^.AcYr := DefaultFinYear;
      end;
  end;
end; // TXmlParse.SetPeriod
*)

//-----------------------------------------------------------------------------------

procedure TXmlParse.ReadDate(Query : array of string; var DateField : shortstring);
var
  DateElement : IXmlDOMNodeList;
  i : integer;
begin
  DateElement := XmlDoc.getElementsByTagName(XSLQuery(Query));
  for i := 0 to DateElement.length -1 do
    if Trim(DateElement.item[i].text) <> '' then
      DateField := BASDADateToDate(Trim(DateElement.item[i].text));
end; // TXmlParse.ReadDate

//-----------------------------------------------------------------------------------

procedure TXmlParse.ReadCurrency(Query : string; var CurrencyField : smallint);
// Pre  : Query = XSL query to find currency tag e.g. Order/OrderHead/OrderCurrency
// Post : CurrencyField = Enterprise integer value for currency
var
  CurrencyElement : IXmlDOMNodeList;
  CurrencyCode : string;
  i : integer;

  procedure AssignExchangeRate;
  var
    CurrInfo : TCurrItems;
  begin
    if GetCurrencyInfo(CurrencyField, CurrInfo) then
    begin
      fHeader^.CoRate := CurrInfo.CurrCompRate;
      fHeader^.VATRate := CurrInfo.CurrDailyRate;
    end;
  end;

begin
  Query := XSLQuery([Query, XML_CURRENCY]);
  CurrencyElement := XmlDoc.getElementsByTagName(Query);
  CurrencyCode := '';
  for i := 0 to CurrencyElement.length -1 do
    CurrencyCode := SafeSelectAttributeText(CurrencyElement.item[i], XML_CODE);

  CurrencyField := 1;

{$IFDEF EXTERNALIMPORT}
  if EBisCurrToEntCurr(CompanyCode, CompanyPath, CurrencyCode, CurrencyField) <> 0 then
{$ELSE}
  if EBisCurrToEntCurr(CompanyCode, CurrencyCode, CurrencyField) <> 0 then
{$ENDIF}
    fErrorLog.Add(logWarn, Format('Currency lookup for %s failed.  Rate 1 will be used.',
      [CurrencyCode]), ERR_CURRENCY_NOT_FOUND);
  AssignExchangeRate;
end; // TXmlParse.ReadCurrency

//-----------------------------------------------------------------------------------

function TXmlParse.ReadBuySupCode(const TransTag, BuySup, BuySupRef, CodeOwner : string) : string;
var
  CodeRefs : IXmlDOMNodeList;
  i : integer;
begin
  Result := '';
  CodeRefs := XmlDoc.getElementsByTagName(XSLQuery([TransTag, BuySup, BuySupRef, CodeOwner]));
  for i := 0 to CodeRefs.length -1 do
    if Trim(CodeRefs.item[i].text) <> '' then
      Result := CodeRefs.item[i].text
end; // TXmlParse.ReadBuySupCode

//-----------------------------------------------------------------------------------

procedure TXmlParse.ReadCustomer;
var
  CustCode,
  TheirCodeForUs,
  TransType : string;
  PossibleCustomers : integer;
begin
  // Try to find the correct customer code in Enterprise
  if fDocGroup = grpInvoices then
    TransType := XML_INVOICE
  else
    TransType := XML_ORDER;

  {$IFDEF EXTERNALIMPORT}
    if fDocGroup = grpSRI then TransType := XML_INVOICE;
  {$ENDIF}

  PossibleCustomers := 0;
  CustCode := ReadBuySupCode(TransType, XML_BUYER, XML_BUYER_REFS, XML_SUPPLIER_CODE_BUYER);
  if CustSuppCodeExists(CustCode, true) then
    PossibleCustomers := 1;

  if PossibleCustomers = 0 then
  begin // Try to find via 'Their Code for Us'
    TheirCodeForUs := ReadBuySupCode(TransType, XML_SUPPLIER, XML_SUPPLIER_REFS, XML_BUYER_CODE_SUPPLIER);
    PossibleCustomers := TheirCodeForUsToCustSuppCode(TheirCodeForUs, true, CustCode);
    if PossibleCustomers > 1 then
      fErrorLog.Add(logWarn, Format('Multiple customers have a "Their A/C For Us" of %s; %s used',
        [TheirCodeForUs, CustCode]), ERR_CUST_AMBIGUOUS);
  end;

  if PossibleCustomers = 0 then
    if CustSuppCodeExists(DefaultCustCode, true) then
    begin
      fErrorLog.Add(logWarn, Format('Customer code : %s not found, default : %s used',
        [CustCode, DefaultCustCode]), ERR_CUST_NOT_FOUND);
      CustCode := DefaultCustCode;
    end
    else
      if Trim(CustCode) = '' then
        fErrorLog.Add(logError, 'No customer code could be found', ERR_CUST_NOT_FOUND)
      else
      begin
        fErrorLog.Add(logError, Format('Invalid customer code : %s', [CustCode]),
          ERR_CUST_NOT_FOUND);
        CustCode := '';
      end;

  fHeader^.CustCode := CustCode;
end; // TXmlParse.ReadCustomer

//-----------------------------------------------------------------------------------

procedure TXmlParse.ReadSupplier;
var
  SuppCode,
  TheirCodeForUs,
  TransType : string;
  PossibleSuppliers : integer;
begin
  // Try to find the correct supplier code in Enterprise
  if fDocGroup = grpInvoices then
    TransType := XML_INVOICE
  else
    TransType := XML_ORDER;
  PossibleSuppliers := 0;

  SuppCode := ReadBuySupCode(TransType, XML_SUPPLIER, XML_SUPPLIER_REFS, XML_BUYER_CODE_SUPPLIER);
  if CustSuppCodeExists(SuppCode, false) then
    PossibleSuppliers := 1;

  if PossibleSuppliers = 0 then
  begin // Try to find via 'Their Code for Us'
    TheirCodeForUs := ReadBuySupCode(TransType, XML_BUYER, XML_BUYER_REFS, XML_SUPPLIER_CODE_BUYER);
    PossibleSuppliers := TheirCodeForUsToCustSuppCode(TheirCodeForUs, false, SuppCode);
    if PossibleSuppliers > 1 then
      fErrorLog.Add(logWarn, Format('Multiple suppliers have a "Their A/C For Us" of %s; %s used',
        [TheirCodeForUs, SuppCode]), ERR_SUPP_AMBIGUOUS);
  end;

  if PossibleSuppliers = 0 then
    if CustSuppCodeExists(DefaultSuppCode, false) then
    begin
      fErrorLog.Add(logWarn, Format('Supplier code : %s not found, default : %s used',
        [SuppCode, DefaultSuppCode]), ERR_SUPP_NOT_FOUND);
      SuppCode := DefaultSuppCode;
    end
    else
      if Trim(SuppCode) = '' then
        fErrorLog.Add(logError, 'No supplier code could be found', ERR_SUPP_NOT_FOUND)
      else
      begin
        fErrorLog.Add(logError, Format('Invalid supplier code : %s', [SuppCode]),
          ERR_SUPP_NOT_FOUND);
        SuppCode := '';
      end;

  fHeader^.CustCode := SuppCode;
end; // TXmlParse.ReadSupplier

//-----------------------------------------------------------------------------------

procedure TXmlParse.ReadDelAddress(const TransTag : string);
var
  i : Integer;
  GotAddr : Boolean;
  AddressDetails : TAddressDetails;
begin
  FillChar(AddressDetails, SizeOf(AddressDetails), 0);
  //PR: 16/10/2013 ABSEXCH-14703 Add delivery postcode
  ReadAddress(XmlDoc.getElementsByTagName(
    XSLQuery([TransTag, XML_DELIVERY, XML_DELIVER_TO, XML_ADDRESS])),
    AddressDetails, fHeader^.thDeliveryPostcode);

  //PR: 30/08/2016 ABSEXCH-17138 Include country code
  Move(AddressDetails.Lines, fHeader^.DAddr, SizeOf(AddressDetails.Lines));
  fHeader^.thDeliveryCountry := AddressDetails.CountryCode;
  //Check Delivery address - if it is all blank then get from CustSupp address
  GotAddr := False;
  for i := 1 to 5 do
    if Trim(fHeader^.DAddr[i]) <> '' then
    begin
      GotAddr := True;
      Break;
    end;

  //PR: 16/10/2013 ABSEXCH-14703 Add delivery postcode
  if not GotAddr then
  begin
    for i := 1 to 5 do
    begin
      fHeader^.DAddr[i] := fCustSupp.DAddr[i];
      if Trim(fHeader^.DAddr[i]) <> '' then
      begin
        GotAddr := True;
      end;
    end;

    fHeader^.thDeliveryPostcode := fCustSupp.acDeliveryPostcode;

    //PR: 30/08/2016 ABSEXCH-17138 Include country code
    if GotAddr then
      fHeader^.thDeliveryCountry := GetFirstPopulatedString([fCustSupp.acDeliveryCountry, fCustSupp.acCountry]);
  end;

end;

//-----------------------------------------------------------------------------------

procedure TXmlParse.ReadTaxTotal;
var
  TaxInfo : IXmlDOMNodeList;
  i,
  Index : integer;
  TaxCodeRead,
  TaxAmt : string;
  EntTaxCode : char;
begin
  TaxInfo := XmlDoc.getElementsByTagName(XSLQuery([XML_INVOICE, XML_TAX_SUBTOTAL]));
  for i := 0 to TaxInfo.length -1 do
  begin
    TaxCodeRead := SafeSelectAttributeText(TaxInfo.item[i].SelectSingleNode(XML_TAX_RATE),
      XML_CODE);
    TaxAmt := SafeSelectSingleNodeText(TaxInfo.item[i], XML_TAX_RATE_TAX_VALUE);
    if length(TaxCodeRead) > 0 then
    begin
      // First try a tax code lookup
      {$IFDEF EXTERNALIMPORT}
        EntTaxCode := ExternalTaxToEntTaxCode(TaxCodeRead, CompanyCode, CompanyPath, Header^.CustCode);
      {$ELSE}
        EntTaxCode := ExternalTaxToEntTaxCode(TaxCodeRead, CompanyCode, Header^.CustCode);
      {$ENDIF}

      if EntTaxCode = #0 then //Try Global lookup
        {$IFDEF EXTERNALIMPORT}
          EntTaxCode := ExternalTaxToEntTaxCode(TaxCodeRead, CompanyCode, CompanyPath, '');
        {$ELSE}
          EntTaxCode := ExternalTaxToEntTaxCode(TaxCodeRead, CompanyCode, '');
        {$ENDIF}

      // If lookup failed use standard BASDA to Enterprise mapping
      if EntTaxCode = #0 then
      begin
        EntTaxCode := BASDATaxToEntTaxCode(TaxCodeRead[1]);
        // Should add warning to log that this mapping assumed ?
        if EntTaxCode <> #0 then
          fErrorLog.Add(logWarn, Format('Tax Code lookup for %s failed.  Default mapping used.',
            [TaxCodeRead]), ERR_TAXCODE_NOT_FOUND)
        else
        begin
          EntTaxCode := fDefaultVatCode;
          fErrorLog.Add(logWarn, Format('Tax Code lookup for %s failed.  Default Tax Code used.',
            [TaxCodeRead]), ERR_TAXCODE_NOT_FOUND)
        end;


      end;

      Index := VATCodeToIndex(EntTaxCode);
      if Index <> -1 then
        try
          fHeader^.InvVatAnal[Index] := fHeader^.InvVatAnal[Index] + StrToFloat(TaxAmt);
        except ;
        end;
    end;
  end;
end;

//-----------------------------------------------------------------------------------
//PR: 16/10/2013 ASEXCH-14703 Add postcode parameter
procedure TXmlParse.ReadAddress(AddressNodeList : IXMLDOMNodeList;
  var AddressDetails : TAddressDetails; var sPostCode : TPostcodeString);
// Notes : Routine should handle addresses using <STREET>, <CITY>, <STATE>, <POSTCODE>,
//         <COUNTRY> and <ADDRESSLINE> in combination.  Order of the tags is relevant.
var
  AddressLines : IXmlDOMNodeList;
  LineNum : integer;
  i : integer;
  State,
  Country,
  PostCode  : string;
begin
  if AddressNodeList.length > 0 then
  begin // Address element not empty
    LineNum := 1;
    State := '';
    Country := '';
    PostCode := '';
    AddressLines := AddressNodeList.item[0].childNodes;

    for i := 0 to AddressLines.length -1 do
      with AddressLines[i] do
        begin
          // Enterprise has 5 address lines so try and pick out the most important
          // details.  If there's room add in State, Country and PostCode
          if nodeName = XML_STATE then
            State := Text
          else
            if nodeName = XML_COUNTRY then
              Country := SafeSelectAttributeText(AddressLines[i], 'Code')
            else
              if nodeName = XML_POSTCODE then
                PostCode := Text
               else
                if (LineNum <= 5) and (Trim(Text) <> '') then
                begin
                  AddressDetails.Lines[LineNum] := Text;
                  inc(LineNum);
                end;
        end;

    //PR: 16/10/2013 ABEXCH-14703 Set delivery postcode
    if PostCode <> '' then
      sPostCode := PostCode;

    //PR: 30/08/2016 ABSEXCH-17138 Include country code
    if Country <> '' then
      AddressDetails.CountryCode := CountryCode3ToCountryCode2(Country);

    //PR: 16/10/2013 ABEXCH-14703 Removed postcode from section below
    case LineNum of
      1..4: // 4 or more spare address lines
        begin
          if State <> '' then
          begin
            AddressDetails.Lines[LineNum] := State;
            inc(LineNum);
          end;
        end;
      5: // 1 spare address line
        begin
          if State <> '' then
            AddressDetails.Lines[LineNum] := State;
        end;
    end; // case
  end; // Address element not empty
end; // TXmlParse.ReadAddress

//-----------------------------------------------------------------------------------

procedure TXmlParse.ReadOrderSettlementDisc;
var
  Discount,
  DiscountType : IXmlDOMNodeList;
  i,
  j : integer;
  strDiscount : string;
begin
  Discount := XMlDoc.getElementsByTagName(XSLQuery([XML_ORDER, XML_DISCOUNT_PERCENT]));
  for i := 0 to Discount.Length -1 do
  begin
    DiscountType := Discount.item[i].selectNodes(XML_TYPE);
    for j := 0 to DiscountType.Length -1 do
      if SafeSelectAttributeText(DiscountType.item[j], XML_CODE) =
        BASDA_EARLY_SETTLE_DISCOUNT then
      begin
        strDiscount := SafeSelectSingleNodeText(Discount.item[i], XML_PERCENTAGE);
        if strDiscount <> '' then
          try
            fHeader^.DiscSetl := StrToFloat(strDiscount) / 100;
          except ;
          end
      end;
  end;
end; // TXmlParse.ReadOrderSettlementDisc

//-----------------------------------------------------------------------------------

procedure TXmlParse.ReadDiscount(ParentNode : IXmlDOMNode;
  var DiscountPercent, DiscountAmount : double);
var
  PercentDiscTag,
  AmountDiscTag  : IXmlDOMNodeList;
  i : integer;
  strDiscount : string;
begin
  PercentDiscTag := ParentNode.selectNodes(XSLQuery([XML_DISCOUNT_PERCENT]));
  for i := 0 to PercentDiscTag.Length -1 do
  begin
    strDiscount := SafeSelectSingleNodeText(PercentDiscTag.item[i], XML_PERCENTAGE);
    if strDiscount <> '' then
      try
        DiscountPercent := StrToFloat(strDiscount) / 100;
      except ;
      end
  end;

  AmountDiscTag := ParentNode.selectNodes(XSLQuery([XML_DISCOUNT_AMOUNT]));
  for i := 0 to AmountDiscTag.Length - 1 do
  begin
    strDiscount := SafeSelectSingleNodeText(AmountDiscTag.item[i], XML_AMOUNT);
    if strDiscount <> '' then
    try
      DiscountAmount := StrToFloat(strDiscount);
    except ;
    end;
  end;
end; // TXmlParse.ReadDiscount

//-----------------------------------------------------------------------------------

procedure TXmlParse.ReadDiscount(ParentNode : IXmlDOMNode;
  var DiscountPercent, DiscountAmount,
      DiscountPercent2, DiscountAmount2,
      DiscountPercent3, DiscountAmount3 : double);
var
  PercentDiscTag,
  AmountDiscTag  : IXmlDOMNodeList;
  DiscTypeTag, aDiscTypeTag : IXmlDOMNode;
  i : integer;
  strDiscount, sAttr : string;
begin
  PercentDiscTag := ParentNode.selectNodes(XSLQuery([XML_DISCOUNT_PERCENT]));
  for i := 0 to PercentDiscTag.Length -1 do
  begin
    strDiscount := SafeSelectSingleNodeText(PercentDiscTag.item[i], XML_PERCENTAGE);
    if strDiscount <> '' then
      try
        DiscTypeTag := PercentDiscTag.item[i].selectSingleNode(XML_TYPE);
        sAttr := SafeSelectAttributeText(DiscTypeTag, XML_CODE);
        if sAttr = 'RED' then
          DiscountPercent := StrToFloat(strDiscount) / 100
        else
        if sAttr = 'VOD' then
          DiscountPercent2 := StrToFloat(strDiscount) / 100
        else
        if sAttr = 'SPD' then
          DiscountPercent3 := StrToFloat(strDiscount) / 100
      except ;
      end
  end;

  AmountDiscTag := ParentNode.selectNodes(XSLQuery([XML_DISCOUNT_AMOUNT]));
  for i := 0 to AmountDiscTag.Length - 1 do
  begin
    strDiscount := SafeSelectSingleNodeText(AmountDiscTag.item[i], XML_AMOUNT);
    if strDiscount <> '' then
    try
        aDiscTypeTag := AmountDiscTag.item[i].selectSingleNode(XML_TYPE);
        sAttr := SafeSelectAttributeText(aDiscTypeTag, XML_CODE);
      if sAttr = 'RED' then
         DiscountAmount := StrToFloat(strDiscount)
      else
      if sAttr = 'VOD' then
         DiscountAmount2 := StrToFloat(strDiscount)
      else
      if sAttr = 'SPD' then
         DiscountAmount3 := StrToFloat(strDiscount);
    except ;
    end;
  end;
end; // TXmlParse.ReadDiscount

//-----------------------------------------------------------------------------------

procedure TXmlParse.ReadTransactionLines(const XMLTransTag, XMLTransLineTag : string);
var
  TransLines : IXmlDOMNodeList;
  CurTransLine, TempNode : IXMLDOMNode;
  i : integer;
  LineAction,
  strLineNum : string;
  iLineNum : integer;
  DescOnlyLine : boolean;
  StockRec : ^TBatchSKRec;
  FreightCharge,
  MiscCharge,
  DiscCharge,
  FreightVat,
  MiscVat,
  DiscVat : Double;
  LType, LRefs : String;
  PreserveS, sLineRef : string;
  LastStockFolio : longint;


  {$IFDEF EXTERNALIMPORT}
    nPaymentLine : IXmlDOMNode;
    nlInvLineRefs : IXmlDOMNodeList;
  {$ENDIF}

  function GetMiscCharge : Double;
  var
    Charge : IXmlDOMNodeList;
    strCharge : string;
  begin
    Charge := XMlDoc.getElementsByTagName(XSLQuery([XML_ORDER, XML_ORDER_TOTAL,
                                                   XML_MISC_CHARGES]));
    if Charge.Length > 0 then
    begin
      strCharge := Charge.Item[0].Text;
      MiscCharge := StrToFloat(strCharge);
    end
    else
      MiscCharge := 0;

    Result := MiscCharge;
  end;


  function GetFreightCharge : Double;
  var
    Charge : IXmlDOMNodeList;
    strCharge : string;
  begin
    Charge := XMlDoc.getElementsByTagName(XSLQuery([XML_ORDER, XML_ORDER_TOTAL,
                                                   XML_FREIGHT_CHARGES]));
    if Charge.Length > 0 then
    begin
      strCharge := Charge.Item[0].Text;
      FreightCharge := StrToFloat(strCharge);
    end
    else
      FreightCharge := 0;

    Result := FreightCharge;
  end;

  function GetDiscCharge : Double;
  var
    Charge : IXmlDOMNodeList;
    strCharge : string;
  begin
    Charge := XMlDoc.getElementsByTagName(XSLQuery([XML_ORDER, XML_ORDER_TOTAL,
                                                   XML_SETTLE_DISC_TOTAL]));
    if Charge.Length > 0 then
    begin
      strCharge := Charge.Item[0].Text;
      DiscCharge := StrToFloat(strCharge);
    end
    else
      DiscCharge := 0;

    if DiscCharge > 0 then
      DiscCharge := - DiscCharge;

    Result := DiscCharge;

  end;

  function ReadLineUDField(const FNo : String) : string;
  var
    UD : IXmlDOMNodeList;
    i : integer;
    UDTag : string;
  begin
    UDTag := AddNameSpace(Fno, NAMESPACE_EXCHEQUER);
    if UseBasda309 then //PR: 07/02/2012 Add Extensions tag ABSEXCH-2748
      UD := CurTransLine.selectNodes(XSLQuery([BASDA_EXTENSIONS, AddNameSpace(ENT_TRANS_LINE_EXTENSIONS, NAMESPACE_EXCHEQUER)]))
    else
    begin
      if fDocGroup = grpOrders then
        UD := CurTransLine.selectNodes(XSLQuery([XML_ORDER_LINE_REFS]))
      else
        UD := CurTransLine.selectNodes(XSLQuery([XML_INVOICE_LINE_REFS]));
    end;
    for i := 0 to UD.length -1 do
      Result := SafeSelectSingleNodeText(UD[i], UDTag);
  end;

  //PR: 01/02/2012  Function to test whether line needs to be linked to stock code ABSEXCH-2748
  function LinkToStockLine : Boolean;
  begin
    Result := ReadLineUDField(ENT_EXTENDED_LINE_TYPE) = ENT_EXTENDED_LINE_TYPE_STOCK_DESCRIPTION;
  end;

  function ReadTransDiscountType : Byte;
  var
    DT : IXmlDOMNodeList;
    i : integer;
    DTTag : string;
    sResult, TransType : string;
  begin
    DTTag := AddNameSpace(ENT_TRANS_DISC_TYPE, NAMESPACE_EXCHEQUER);

    //PR: 07/02/2012 Add Extensions tag ABSEXCH-2748
    DT := CurTransLine.selectNodes(XSLQuery([BASDA_EXTENSIONS, AddNameSpace(ENT_TRANS_LINE_EXTENSIONS, NAMESPACE_EXCHEQUER), DTTag]));

    for i := 0 to DT.length -1 do
      if Trim(DT.item[i].text) <> '' then
        sResult := Trim(DT.item[i].text);

    if sResult = ENT_TRANS_DISC_TTD then
      Result := 1
    else
    if sResult = ENT_TRANS_DISC_VBD then
      Result := 2
    else
    if sResult = ENT_TRANS_MBD_DESC_LINE then
      Result := 255
    else
      Result := 0;
  end;


  function Line : string;
  begin
    Result := Format('Line : %d', [iLineNum]);
  end;

  function ReadDescription : string;
  var
    ProductElements : IXmlDOMNodeList;
    ElementCount : integer;
  begin
    ProductElements := CurTransLine.selectNodes(XSLQuery([XML_PRODUCT]));
    ElementCount := 0;
    Result := '';
    while (ElementCount < ProductElements.length) and (Result = '') do
    begin
      Result := SafeSelectSingleNodeText(ProductElements.item[ElementCount], XML_PRODUCT_DESCRIPTION);
      inc(ElementCount);
    end;
  end; // ReadDescription

  function AssignNominal : integer;
  var
    LineRefs : IXmlDOMNodeList;
    strNom : string;
    i,
    StockNom,
    DefaultNom : integer;
    OK : boolean;
  begin
    Result := 0;
    OK := false;
    if fTransferMode = tfrReplication then
    begin // In replication mode read Nominal code from XML message
      strNom := '';

//      LineRefs := CurTransLine.selectNodes(XSLQuery([XML_ORDER_LINE_REFS]));
      // I know they're the same, but I won't remember to duplicate this code into v6, unless I use the compiler directive.
      {$IFDEF EXTERNALIMPORT}
        if fDocGroup = grpOrders then
        begin
          LineRefs := CurTransLine.selectNodes(XSLQuery([XML_ORDER_LINE_REFS]))
        end else
        begin
          LineRefs := CurTransLine.selectNodes(XSLQuery([XML_INVOICE_LINE_REFS]));
        end;{if}
      {$ELSE}
        if fDocGroup = grpOrders then
        begin
          LineRefs := CurTransLine.selectNodes(XSLQuery([XML_ORDER_LINE_REFS]))
        end else
        begin
          LineRefs := CurTransLine.selectNodes(XSLQuery([XML_INVOICE_LINE_REFS]));
        end;{if}
      {$ENDIF}

      for i := 0 to LineRefs.Length -1 do
        if SafeSelectSingleNodeText(LineRefs[i], XML_GL_CODE) <> '' then
          strNom := SafeSelectSingleNodeText(LineRefs[i], XML_GL_CODE);
      try
        Result := StrToInt(strNom);
      except
        Result := 0;
      end;
      OK := NominalCodeExists(Result);
    end;

    if not OK and NominalCodeExists(fCustSupp^.DefNomCode) then
    begin
      Result := fCustSupp^.DefNomCode;
      OK := true;
      if fTransferMode = tfrReplication then
        fErrorLog.Add(logWarn, Format('%s Nominal code read : %s not found, ' +
        'trader default : %d used', [Line, strNom, Result]), ERR_NOM_NOT_FOUND);
    end;
    //At this point the doctype hasn't been exchanged so we need to
    //make sure we get the right nominal code

  // I know they're the same, but I won't remember to duplicate this code into v6, unless I use the compiler directive.
  {$IFDEF EXTERNALIMPORT}
    if (not OK) and Assigned(StockRec) then
    begin
  {$ELSE}
    if (not OK) and Assigned(StockRec) then
    begin
  {$ENDIF}
      if fTransferMode = tfrReplication then
      begin
        if (fDocType = POR) or (fDocType = PIN) then
        begin
          if StockRec^.StockType = 'M' then //BOM
            StockNom := StockRec^.NomCodes[5]
          else
            StockNom := StockRec^.NomCodes[4];
        end
        else
          StockNom := StockRec^.NomCodes[1];
      end
      else
      begin
        if (fDocType = POR) or (fDocType = PIN) then
          StockNom := StockRec^.NomCodes[1]
        else
        begin
          if StockRec^.StockType = 'M' then  //BOM
            StockNom := StockRec^.NomCodes[5]
          else
          //PR: 24/09/02 Nom code from stock rec - if live valuation then Stock Value else Cost of Sales
            if Syss.AutoValStk then
              StockNom := StockRec^.NomCodes[4]
            else
              StockNom := StockRec^.NomCodes[2];
        end
      end;
  {$IFDEF EXTERNALIMPORT}
    end;{if}
  {$ELSE}
    end;{if}
  {$ENDIF}

    if not OK and NominalCodeExists(StockNom) then
    begin
      Result := StockNom;
      OK := true;
      if fTransferMode = tfrReplication then
        fErrorLog.Add(logWarn, Format('%s Nominal code read : %s not found, ' +
          ' stock default : %d used', [Line, strNom, Result]), ERR_NOM_NOT_FOUND);
    end;

    if (fDocType = POR) or (fDocType = PIN) then
      DefaultNom := fDefaultPurchNomCode
    else
      DefaultNom := fDefaultSalesNomCode;

    if not OK and NominalCodeExists(DefaultNom) then
    begin
      Result := DefaultNom;
      OK := true;
      if fTransferMode = tfrReplication then
        fErrorLog.Add(logWarn, Format('%s Nominal code read : %s not found, ' +
          ' EBusiness default : %d used', [Line, strNom, Result]), ERR_NOM_NOT_FOUND);
    end;

    if not OK then
      fErrorLog.Add(logError, Format('%s Nominal code invalid', [Line]), ERR_NOM_NOT_FOUND);
  end; // AssignNominal

  function AssignCostCentre : string;
  var
    LineRefs : IXmlDOMNodeList;
    i : integer;
    OK : boolean;
  begin
    Result := '';
    OK := false;
    if (fTransferMode = tfrReplication) or fCCDepFromXML then
    begin // In replication mode read CC from XML message
      if fDocGroup = grpOrders then
        LineRefs := CurTransLine.selectNodes(XSLQuery([XML_ORDER_LINE_REFS]))
      else
        LineRefs := CurTransLine.selectNodes(XSLQuery([XML_INVOICE_LINE_REFS]));
      for i := 0 to LineRefs.Length -1 do
        Result := SafeSelectSingleNodeText(LineRefs[i], XML_COST_CENTRE);
      OK := CCDepExists(Result, true);
    end;

    // In transfer mode use defaults
    if not OK and (CCDepExists(StockRec^.CC, true)) then
    begin
      if fTransferMode = tfrReplication then
        fErrorLog.Add(logWarn,
         Format('%s Cost centre read : %s not found, ' +
        'stock default : %s used', [Line, Result, StockRec^.CC]), ERR_CC_NOT_FOUND);
      Result := StockRec^.CC;
      OK := true;
    end;

    if not OK and (CCDepExists(fCustSupp^.CustCC, true)) then
    begin
      if fTransferMode = tfrReplication then
        fErrorLog.Add(logWarn,
         Format('%s Cost centre read : %s not found, ' +
        'customer default : %s used', [Line, Result, fCustSupp^.CustCC]), ERR_CC_NOT_FOUND);
      Result := fCustSupp^.CustCC;
      OK := true;
    end;

    if not OK and (CCDepExists(fDefaultCC, true)) then
    begin
      if fTransferMode = tfrReplication then
        fErrorLog.Add(logWarn, Format('%s Cost centre read : %s not found, ' +
        'EBusiness default : %s used', [Line, Result, fDefaultCC]), ERR_CC_NOT_FOUND);
      Result := fDefaultCC;
      OK := true;
    end;

    if not OK then
      fErrorLog.Add(logError, Format('%s Cost centre invalid', [Line]), ERR_CC_NOT_FOUND);
  end; // AssignCostCentre

  function AssignDepartment : string;
  var
    LineRefs : IXmlDOMNodeList;
    i : integer;
    OK : boolean;
  begin
    Result := '';
    OK := false;

    if (fTransferMode = tfrReplication) or fCCDepFromXML then
    begin // In replication mode read Dept from XML message
      if UseBasda309 then
        LineRefs :=  CurTransLine.selectNodes(XSLQuery([AddNameSpace(ENT_TRANS_LINE_EXTENSIONS, NAMESPACE_EXCHEQUER)]))
      else
      if fDocGroup = grpOrders then
        LineRefs := CurTransLine.selectNodes(XSLQuery([XML_ORDER_LINE_REFS]))
      else
        LineRefs := CurTransLine.selectNodes(XSLQuery([XML_INVOICE_LINE_REFS]));
      for i := 0 to LineRefs.Length -1 do
        Result := SafeSelectSingleNodeText(LineRefs[i], AddNameSpace(XML_DEPARTMENT, NAMESPACE_EXCHEQUER));
      OK := CCDepExists(Result, false);
    end;

    // In transfer mode use defaults
    if not OK and (CCDepExists(StockRec^.Dep, false)) then
    begin
      if fTransferMode = tfrReplication then
        fErrorLog.Add(logWarn, Format('%s Department read : %s not found, ' +
        'stock default : %s used', [Line, Result, StockRec^.Dep]), ERR_DEP_NOT_FOUND);
      Result := StockRec^.Dep;
      OK := true;
    end;

    if not OK and (CCDepExists(fCustSupp^.CustDep, False)) then
    begin
      if fTransferMode = tfrReplication then
        fErrorLog.Add(logWarn,
         Format('%s Department read : %s not found, ' +
        'customer default : %s used', [Line, Result, fCustSupp^.CustDep]), ERR_CC_NOT_FOUND);
      Result := fCustSupp^.CustDep;
      OK := true;
    end;

    if not OK and (CCDepExists(fDefaultDept, false)) then
    begin
      if fTransferMode = tfrReplication then
        fErrorLog.Add(logWarn, Format('%s Department read : %s not found, ' +
        'EBusiness default : %s used', [Line, Result, fDefaultDept]), ERR_DEP_NOT_FOUND);
      Result := fDefaultDept;
      OK := true;
    end;

    if not OK then
      fErrorLog.Add(logError, Format('%s Department invalid', [Line]), ERR_DEP_NOT_FOUND);
  end; // AssignDepartment

  function AssignLocation : string;
  var
    LineRefs : IXmlDOMNodeList;
    i : integer;
    OK : boolean;

    procedure GetLoc(const TmpLoc : string;
                     const TmpLocStr : string);
    begin
      if not OK and (LocationExists(TmpLoc)) then
      begin

        if fTransferMode = tfrReplication then
          fErrorLog.Add(logWarn, Format('%s Location read : %s not found, ' +
          TmpLocStr + ' default : %s used', [Line, Result, TmpLoc]), ERR_LOC_NOT_FOUND);
        Result := TmpLoc;
        OK := true;
      end;
    end;


  begin
    Result := '';
    OK := false;

    if fTransferMode = tfrReplication then
    begin // In replication mode read Location from XML message

//      LineRefs := CurTransLine.selectNodes(XSLQuery([XML_ORDER_LINE_REFS]));
      // I know they're the same, but I won't remember to duplicate this code into v6, unless I use the compiler directive.
      {$IFDEF EXTERNALIMPORT}
        if fDocGroup = grpOrders then
        begin
          LineRefs := CurTransLine.selectNodes(XSLQuery([XML_ORDER_LINE_REFS]))
        end else
        begin
          LineRefs := CurTransLine.selectNodes(XSLQuery([XML_INVOICE_LINE_REFS]));
        end;{if}
      {$ELSE}
        if UseBasda309 then
           LineRefs := CurTransLine.selectNodes(XSLQuery([AddNameSpace(ENT_TRANS_LINE_EXTENSIONS, NAMESPACE_EXCHEQUER)]))
        else
        if fDocGroup = grpOrders then
        begin
          LineRefs := CurTransLine.selectNodes(XSLQuery([XML_ORDER_LINE_REFS]))
        end else
        begin
          LineRefs := CurTransLine.selectNodes(XSLQuery([XML_INVOICE_LINE_REFS]));
        end;{if}
      {$ENDIF}

      for i := 0 to LineRefs.Length -1 do
      {$IFNDEF EXTERNALIMPORT}
//        Result := SafeSelectSingleNodeText(LineRefs[i], XML_LOCATION);
      {$ENDIF}
        Result := SafeSelectSingleNodeText(LineRefs[i], AddNameSpace(XML_LOCATION, NAMESPACE_EXCHEQUER));

      OK := LocationExists(Result);
    end;

    // In transfer mode use defaults
    Case LocationOrigin of
      0  : begin
             GetLoc(StockRec^.StLocation, 'Stock');
             GetLoc(fDefaultLocation, 'EBusiness');
           end;
      1  : begin
             GetLoc(StockRec^.StLocation, 'Stock');
             GetLoc(fDefaultLocation, 'EBusiness');
             GetLoc(fCustSupp^.DefMLocStk, 'Account');
           end;
      2  : begin
             GetLoc(StockRec^.StLocation, 'Stock');
             GetLoc(fCustSupp^.DefMLocStk, 'Account');
             GetLoc(fDefaultLocation, 'EBusiness');
           end;
      3  : begin
             GetLoc(fCustSupp^.DefMLocStk, 'Account');
             GetLoc(fDefaultLocation, 'EBusiness');
             GetLoc(StockRec^.StLocation, 'Stock');
           end;
      4  : begin
             GetLoc(fCustSupp^.DefMLocStk, 'Account');
             GetLoc(StockRec^.StLocation, 'Stock');
             GetLoc(fDefaultLocation, 'EBusiness');
           end;
      5  : begin
             GetLoc(fDefaultLocation, 'EBusiness');
           end;
    end; //case


    if not OK then
      fErrorLog.Add(logError, Format('%s Location invalid', [Line]), ERR_LOC_NOT_FOUND);
  end; // AssignLocation

  function AssignVATCode : char;
  var
    TaxInfo : IXmlDOMNodeList;
    RateNode : IXMlDOMNode;
    i : integer;
    TaxAmt,
    strTaxCode : string;
    TaxCode : char;
    TaxCodeOK : boolean;
  begin
    TaxCode := #0;
    TaxCodeOK := false;
    // Read tax code from XML document
    TaxInfo := CurTransLine.selectNodes(XSLQuery([XML_LINE_TAX]));
    for i := 0 to TaxInfo.length -1 do
    begin
      RateNode := TaxInfo[i].SelectSingleNode(XML_TAX_RATE);
      strTaxCode := Trim(SafeSelectAttributeText(RateNode, XML_CODE));
      TaxAmt := SafeSelectSingleNodeText(TaxInfo.item[i], XML_TAX_VALUE);
      if length(Trim(strTaxCode)) > 0 then
      begin
        // Try a tax code lookup

        {$IFDEF EXTERNALIMPORT}
          TaxCode := ExternalTaxToEntTaxCode(strTaxCode, CompanyCode, CompanyPath, Header^.CustCode);
        {$ELSE}
          TaxCode := ExternalTaxToEntTaxCode(strTaxCode, CompanyCode, Header^.CustCode);
        {$ENDIF}

        if TaxCode = #0 then
          {$IFDEF EXTERNALIMPORT}
            TaxCode := ExternalTaxToEntTaxCode(strTaxCode, CompanyCode, CompanyPath, '');
          {$ELSE}
            TaxCode := ExternalTaxToEntTaxCode(strTaxCode, CompanyCode, '');
          {$ENDIF}

        TaxCodeOK := VATCodeToIndex(TaxCode) <> -1;
        if not TaxCodeOK then
        begin
          // Assume it's a standard BASDA code
          TaxCode := BASDATaxToEntTaxCode(Trim(strTaxCode)[1]);
          TaxCodeOK := VATCodeToIndex(TaxCode) <> -1;
        end;
      end; // A tax code read in
    end; // for
    if not TaxCodeOK and (VATCodeToIndex(StockRec^.VATCode) <> -1) then
    begin
      TaxCode := StockRec^.VATCode;
      TaxCodeOK := true;
    end;
    if not TaxCodeOK and (VATCodeToIndex(DefaultVATCode) <> -1) then
    begin
      TaxCode := DefaultVATCode;
      TaxCodeOK := true;
    end;
    Result := TaxCode;
    // On reading an order the tax amounts will be recalculated using the VAT code
    // and the net value.
    // On reading an invoice the tax amounts have to be accepted - they may have
    // have been manually adjusted / rounded etc.
    try
      fLines^[iLineNum].VAT := StrToFloat(TaxAmt);
    except ;
    end;
  end;

  procedure ProcessProduct(const XMLOurProdCodeType, XMLAltProdCodeType : string);
  var
    StockCodes : IXmlDOMNodeList;
    StockRecFound : boolean;
    i : integer;
    SearchCode : array[0..255] of char;
    ErrMsg,
    OurStockCode,
    AltStockCode,
    BarCode : string;
  begin // ProcessProduct
    StockCodes := CurTransLine.selectNodes(XSLQuery([XML_PRODUCT]));
    // Select the buyer's code from the various product codes
    for i := 0 to StockCodes.Length -1 do
    begin
      OurStockCode := SafeSelectSingleNodeText(StockCodes.item[i], XMLOurProdCodeType);
      if OurStockCode <> '' then
        fLines^[iLineNum].StockCode := OurStockCode;
      AltStockCode := SafeSelectSingleNodeText(StockCodes.item[i], XMLAltProdCodeType);
      BarCode := SafeSelectSingleNodeText(StockCodes.item[i], XML_CONSUMER_UNIT_CODE);
    end;

      // Pad stock code to 16 characters
      fLines^[iLineNum].StockCode := fLines^[iLineNum].StockCode +
        StringOfChar(' ', 16 - length(fLines^[iLineNum].StockCode));
      //PR: 09/03/2009 Added checks for blank AltStockCode & BarCode
      // Stock code not found, try via alternative stock code (trader code, then global)
      if not StockCodeExists(fLines^[iLineNum].StockCode) and (Trim(AltStockCode) <> '') then
        fLines^[iLineNum].StockCode := AltStockToEntStockCode(AltStockCode, fHeader^.CustCode);
      // Stock code not found, try via bar code
      if not StockCodeExists(fLines^[iLineNum].StockCode) and (Trim(BarCode) <> '')  then
        fLines^[iLineNum].StockCode := BarCodeToEntStockCode(BarCode);
    // Stock code not found, see if 'their' code is actually 'our' code
    if not StockCodeExists(fLines^[iLineNum].StockCode) then
      fLines^[iLineNum].StockCode := AltStockCode +
        StringOfChar(' ', 16 - length(fLines^[iLineNum].StockCode));
    // Change order to be ...
    // OurCode
    // Specific alt code
    // Bar code
    // Global alt code
    // Alt code is REALLY our code + warning


    new(StockRec);
    FillChar(StockRec^, SizeOf(StockRec^), 0);
    StrPCopy(SearchCode, fLines^[iLineNum].StockCode);
    StockRecFound := StockCodeExists(fLines^[iLineNum].StockCode);
    if StockRecFound then
      Ex_GetStock(StockRec, SizeOf(StockRec^), SearchCode, 0, B_GetEq, false)
    else
      fLines^[iLineNum].StockCode := StringOfChar(' ', 16);

    if not (StockRecFound or DescOnlyLine) then
    begin
      {$IFDEF EXTERNALIMPORT}
        if Trim(OurStockCode) = '' then
        begin
          ErrMsg := Format('%s No product code could be read', [Line])
        end else
        begin
          ErrMsg := Format('%s Stock record for product %s not found', [Line, OurStockCode]);
          // If a product code is set but can't be found then need to blank it to
          // avoid a Toolkit error 30106
          fLines^[iLineNum].StockCode := '';
        end;{if}
      {$ELSE}
        if Trim(SearchCode) = '' then
          ErrMsg := Format('%s No product code could be read', [Line])
        else
        begin
          ErrMsg := Format('%s Stock record for product %s not found', [Line, SearchCode]);
          // If a product code is set but can't be found then need to blank it to
          // avoid a Toolkit error 30106
          fLines^[iLineNum].StockCode := '';
        end;
      {$ENDIF}

      fErrorLog.Add(logWarn, ErrMsg, ERR_STOCK_NOT_FOUND);
    end;

    //PR: 01/02/2012 ABSEXCH-2478 Set kit link if necessary
    if LinkToStockLine then
      fLines^[iLineNum].KitLink := LastStockFolio
    else
    if not DescOnlyLine then //for stock line (not component), set variable used for setting kit links on following lines.
      LastStockFolio := StockRec.StockFolio;


    if not DescOnlyLine then
    begin
      fLines^[iLineNum].NomCode := AssignNominal;
      fLines^[iLineNum].VATCode := AssignVATCode;
      //PR: 24/9/02 PINs shouldn't take cost from stock rec
      if (fDocGroup = grpOrders) then
        fLines^[iLineNum].CostPrice := StockRec^.CostPrice;

      if (StockRec^.StPricePack and StockRec^.StDPackQty ) {and not
                           (StockRec^.StkValType In [{'S', 'C', 'R'])} then
        fLines^[iLineNum].CostPrice := fLines^[iLineNum].CostPrice / StockRec^.BuyUnit;

    end;

    if SysInfo^.CCDepts and not DescOnlyLine then
    begin
      fLines^[iLineNum].CC := AssignCostCentre;
      fLines^[iLineNum].Dep := AssignDepartment;
    end;

    if (SysInfo^.MultiLocn = 2) and not DescOnlyLine then
      fLines^[iLineNum].MLocStk := AssignLocation;

    //PR: 25/02/2009 Was not checking for DescOnlyLine so was trying to dispose of StockRec when it hadn't been assigned
    if not DescOnlyLine then
      dispose(StockRec);
  end; // ProcessProduct

  {$IFDEF EXTERNALIMPORT}
    procedure ProcessPayment(const XMLOurProdCodeType : string);
    var
      StockCodes : IXmlDOMNodeList;
      i : integer;
      PayInRef: string;
    begin // ProcessPayment
      StockCodes := CurTransLine.selectNodes(XSLQuery([XML_PRODUCT]));
      // Select the buyer's code from the various product codes
      for i := 0 to StockCodes.Length -1 do
      begin
        PayInRef := SafeSelectSingleNodeText(StockCodes.item[i], XMLOurProdCodeType);
        if PayInRef <> '' then
          fLines^[iLineNum].StockCode := PayInRef;
//        AltStockCode := SafeSelectSingleNodeText(StockCodes.item[i], XMLAltProdCodeType);
//        BarCode := SafeSelectSingleNodeText(StockCodes.item[i], XML_CONSUMER_UNIT_CODE);
      end;

      // Pad PayInRef to 10 characters
      fLines^[iLineNum].StockCode := fLines^[iLineNum].StockCode +
        StringOfChar(' ', 10 - length(fLines^[iLineNum].StockCode));
      // Stock code not found, try via alternative stock code (trader code, then global)
{      if not StockCodeExists(fLines^[iLineNum].StockCode) then
        fLines^[iLineNum].StockCode := AltStockToEntStockCode(AltStockCode, fHeader^.CustCode);}
      // Stock code not found, try via bar code
//      if not StockCodeExists(fLines^[iLineNum].StockCode) then
//        fLines^[iLineNum].StockCode := BarCodeToEntStockCode(BarCode);
      // Stock code not found, see if 'their' code is actually 'our' code
{      if not StockCodeExists(fLines^[iLineNum].StockCode) then
        fLines^[iLineNum].StockCode := AltStockCode +
          StringOfChar(' ', 16 - length(fLines^[iLineNum].StockCode));
      // Change order to be ...
      // OurCode
      // Specific alt code
      // Bar code
      // Global alt code
      // Alt code is REALLY our code + warning

      new(StockRec);
      FillChar(StockRec^, SizeOf(StockRec^), 0);
      StrPCopy(SearchCode, fLines^[iLineNum].StockCode);
      StockRecFound := StockCodeExists(fLines^[iLineNum].StockCode);
      if StockRecFound then
        Ex_GetStock(StockRec, SizeOf(StockRec^), SearchCode, 0, B_GetEq, false)
      else
        fLines^[iLineNum].StockCode := StringOfChar(' ', 16);

      if not (StockRecFound or DescOnlyLine) then
      begin
        if Trim(SearchCode) = '' then
          ErrMsg := Format('%s No product code could be read', [Line])
        else
        begin
          ErrMsg := Format('%s Stock record for product %s not found', [Line, SearchCode]);
          // If a product code is set but can't be found then need to blank it to
          // avoid a Toolkit error 30106
          fLines^[iLineNum].StockCode := '';
        end;
        fErrorLog.Add(logWarn, ErrMsg, ERR_STOCK_NOT_FOUND);
      end;

      // Not possible to determine if a desc only line should or should not be
      // attached to the previous transaction line ...
      // fLines^[iLineNum].KitLink := StockRec^.StockFolio;

      if not DescOnlyLine then
      begin}
        fLines^[iLineNum].NomCode := AssignNominal;
//        fLines^[iLineNum].VATCode := AssignVATCode;
        //PR: 24/9/02 PINs shouldn't take cost from stock rec
//        if (fDocGroup = grpOrders) then
//          fLines^[iLineNum].CostPrice := StockRec^.CostPrice;

//        if (StockRec^.StPricePack and StockRec^.StDPackQty ) {and not
//                             (StockRec^.StkValType In [{'S', 'C', 'R'])} then
//          fLines^[iLineNum].CostPrice := fLines^[iLineNum].CostPrice / StockRec^.BuyUnit;

//      end;

      if SysInfo^.CCDepts {and not DescOnlyLine} then
      begin
        fLines^[iLineNum].CC := AssignCostCentre;
        fLines^[iLineNum].Dep := AssignDepartment;
      end;

//      if (SysInfo^.MultiLocn = 2) and not DescOnlyLine then
//        fLines^[iLineNum].MLocStk := AssignLocation;

//      dispose(StockRec);
    end; // ProcessPayment
  {$ENDIF}

  procedure ProcessFreightMiscStock;
  var
    StockNom : longint;
    SearchCode : array[0..255] of char;
    ErrMsg : string;
    StockRecFound : boolean;
   begin
    new(StockRec);
    FillChar(StockRec^, SizeOf(StockRec^), 0);
    StrPCopy(SearchCode, fLines^[TotalLines].StockCode);
    StockRecFound := StockCodeExists(fLines^[TotalLines].StockCode);
    if StockRecFound then
      Ex_GetStock(StockRec, SizeOf(StockRec^), SearchCode, 0, B_GetEq, false)
    else
      fLines^[iLineNum].StockCode := StringOfChar(' ', 16);

    if not (StockRecFound or DescOnlyLine) then
    begin
      if Trim(SearchCode) = '' then
        ErrMsg := Format('%s No product code could be read', [Line])
      else
      begin
        ErrMsg := Format('%s Stock record for product %s not found', [Line, SearchCode]);
        // If a product code is set but can't be found then need to blank it to
        // avoid a Toolkit error 30106
        fLines^[TotalLines].StockCode := '';
      end;
      fErrorLog.Add(logWarn, ErrMsg, ERR_STOCK_NOT_FOUND);
    end
    else
    begin
      fLines^[TotalLines].CC := StockRec^.CC;
      fLines^[TotalLines].Dep := StockRec^.Dep;
      fLines^[TotalLines].Desc := StockRec^.Desc[1];

      if LocationExists(StockRec^.StLocation) then
        fLines^[TotalLines].MLocStk := StockRec^.StLocation
      else
      if LocationExists(fDefaultLocation) then
        fLines^[TotalLines].MLocStk := fDefaultLocation
      else
        fErrorLog.Add(logError, Format('%s Location invalid', [Line]), ERR_LOC_NOT_FOUND);

      if ((fDocType = POR) or (fDocType = PIN) and (fTransferMode <> tfrReplication)) then
        StockNom := StockRec^.NomCodes[1]
      else
        StockNom := StockRec^.NomCodes[4];

      fLines^[TotalLines].NomCode := StockNom;

    end;
  end;

  procedure ProcessDeliveryDate;
  // Action : Reads delivery date from transaction line.
  //          Priority of date usage = LatestDate, PreferredDate, EarliestDate
  var
    DeliveryInfo : IXmlDOMNodeList;
    FirstDate,
    LatestDate,
    PreferredDate,
    EarliestDate : string;
    i : integer;

  begin // ProcessDeliveryDate
    FirstDate := '';
    DeliveryInfo := CurTransLine.selectNodes(XSLQuery([XML_DELIVERY]));
    for i := 0 to DeliveryInfo.Length -1 do
    begin
      LatestDate := SafeSelectSingleNodeText(DeliveryInfo.item[i], XML_LATEST_DATE);
      PreferredDate := SafeSelectSingleNodeText(DeliveryInfo.item[i], XML_PREFERRED_DATE);
      EarliestDate := SafeSelectSingleNodeText(DeliveryInfo.item[i], XML_EARLIEST_DATE);
    end;

    if Trim(LatestDate) <> '' then
      fLines^[iLineNum].LineDate := BASDADateToDate(LatestDate)
    else
      if Trim(PreferredDate) <> '' then
        fLines^[iLineNum].LineDate := BASDADateToDate(PreferredDate)
      else
        if Trim(EarliestDate) <> '' then
          fLines^[iLineNum].LineDate := BASDADateToDate(EarliestDate)
         else
         begin
           if fDocGroup = grpOrders then
             fLines^[iLineNum].LineDate := fHeader^.DueDate
           else
             fLines^[iLineNum].LineDate := fHeader^.TransDate;
         end;

     if (fLines^[iLineNum].LineDate > fHeader^.TransDate) and
       (fLines^[iLineNum].LineDate < fHeader^.DueDate) then
       fHeader^.DueDate := fLines^[iLineNum].LineDate;
  end; // ProcessDeliveryDate

  procedure ProcessQuantity;
  var
    QuantityElements : IXmlDOMNodeList;
    i : integer;
    dblQuant : double;
    strQuant : string;
    strPick  : string;
  begin
    QuantityElements := CurTransLine.selectNodes(XSLQuery([XML_QUANTITY]));
    for i := 0 to QuantityElements.Length -1 do
    begin
      strQuant := SafeSelectSingleNodeText(QuantityElements.item[i], XML_AMOUNT);
      if strQuant <> '' then
      begin
        try
          dblQuant := StrToFloat(strQuant)
        except
          on EConvertError do
          begin
            fErrorLog.Add(logWarn, Format('%s Quantity "%s" could not be interpreted. ' +
            'Quantity of 1 used.', [Line, strQuant]), ERR_QUANTITY);
            dblQuant := 1;
          end;
        end;
        fLines^[iLineNum].Qty := TrueReal(dblQuant, SysInfo^.QuantityDP);
        fPresLineFields[iLineNum].IDQty := fLines^[iLineNum].Qty;
      end;
    end;

    for i := 0 to QuantityElements.Length -1 do
    begin
      strQuant := SafeSelectSingleNodeText(QuantityElements.item[i], XML_QUANT_PACKSIZE);
      if strQuant <> '' then
      begin
        try
          dblQuant := StrToFloat(strQuant)
        except
          on EConvertError do
          begin
            fErrorLog.Add(logWarn, Format('%s Pack Quantity "%s" could not be interpreted. ' +
            'Quantity of 1 used.', [Line, strQuant]), ERR_QUANTITY);
            dblQuant := 1;
          end;
        end;
        fLines^[iLineNum].QtyMul := TrueReal(dblQuant, SysInfo^.QuantityDP);
      end;
    end;

    if fTransferMode = tfrReplication then
    begin  //If in replication mode allow through QtyPicked and QtyPickedWoff
      //QtyPicked
      for i := 0 to QuantityElements.Length -1 do
      begin
        strPick := AddNameSpace(ENT_QUANTITY_PICKED, NAMESPACE_EXCHEQUER);
        strQuant := SafeSelectSingleNodeText(QuantityElements.item[i], strPick);
        if strQuant <> '' then
        begin
          try
            dblQuant := StrToFloat(strQuant)
          except
            on EConvertError do
            begin
              fErrorLog.Add(logWarn, Format('%s Quantity Picked "%s" could not be interpreted. ' +
              'Quantity of 0 used.', [Line, strQuant]), ERR_QUANTITY);
              dblQuant := 0;
            end;
          end;
          fLines^[iLineNum].QtyPick := TrueReal(dblQuant, SysInfo^.QuantityDP);
        end;
      end;

      //QtyPickedWoff
      for i := 0 to QuantityElements.Length -1 do
      begin
        strPick := AddNameSpace(ENT_QUANTITY_PICKEDWO, NAMESPACE_EXCHEQUER);
        strQuant := SafeSelectSingleNodeText(QuantityElements.item[i], strPick);
        if strQuant <> '' then
        begin
          try
            dblQuant := StrToFloat(strQuant)
          except
            on EConvertError do
            begin
              fErrorLog.Add(logWarn, Format('%s Quantity Picked Woff "%s" could not be interpreted. ' +
              'Quantity of 0 used.', [Line, strQuant]), ERR_QUANTITY);
              dblQuant := 0;
            end;
          end;
          fLines^[iLineNum].QtyPWoff := TrueReal(dblQuant, SysInfo^.QuantityDP);
        end;
      end;
    end;

  end;// ProcessQuantity


  procedure CheckPrice(iLine : integer);
  var
    PriceInfo : ^TBatchStkPriceRec;
    Status : integer;
  begin
    {$IFDEF EXTERNALIMPORT}
      if fLines^[iLine].payment then exit;
    {$ENDIF}

    new(PriceInfo);
    FillChar(PriceInfo^, Sizeof(PriceInfo^), 0);
    with PriceInfo^ do
    begin
      StockCode := fLines^[iLine].StockCode;
      CustCode := fHeader^.CustCode;
      Currency := fHeader^.Currency;
      Qty := fLines^[iLine].Qty;
      LocCode := fLines^[iLine].MLocStk;

      Status := Ex_CalcStockPrice(PriceInfo, Sizeof(PriceInfo^));
      if TrueReal(Price,2) <> fLines^[iLine].NetValue then
      begin
        //PR 27/02/02 Change so that reapply pricing doesn't apply to invoices.  Requested by EAL
        if ReapplyPricing and (fDocGroup <> grpInvoices) then //replace price with enterprise price
        begin
        //what do we need to do here?
        {1. replace NetValue with unit price from stock rec
         2. if PriceInfo^.Discount <> 0 then set discount}
          if Status = 0 then
          begin
            fErrorLog.Add(logWarn, Format('%s Price read : %f Exchequer calculated price : %f' +
                                          ' - Exchequer price applied',
            [Line, fLines^[iLine].NetValue, Price]), 0);

            fLines^[iLine].NetValue := Price;
            fLines^[iLine].DiscountChr := DiscChar;
            if DiscChar = '%' then
              fLines^[iLine].Discount := DiscVal / 100
            else
              fLines^[iLine].Discount := DiscVal;

          end;

        end
        else
          fErrorLog.Add(logWarn, Format('%s Price read : %f Exchequer calculated price : %f' ,
          [Line, fLines^[iLine].NetValue, Price]), ERR_PRICE_CHECK);
      end;



    end; // with
    dispose(PriceInfo);
  end; // CheckPrice

  procedure ProcessPrice;
  var
    PriceElements : IXmlDOMNodeList;
    i : integer;
    dblPrice : double;
    strPrice : string;
  begin
    PriceElements := CurTransLine.selectNodes(XSLQuery([XML_PRICE]));
    for i := 0 to PriceElements.Length -1 do
    begin
      strPrice := SafeSelectSingleNodeText(PriceElements.item[i], XML_UNIT_PRICE);
      if strPrice <> '' then
      begin
        try
          dblPrice := StrToFloat(strPrice)
        except
          on EConvertError do
            fErrorLog.Add(logError, Format('%s Price %s could not be interpreted. ',
            [iLineNum, strPrice]), ERR_PRICE);
        end;
        fLines^[iLineNum].NetValue := TrueReal(dblPrice, SysInfo^.PriceDP);
        fPresLineFields[iLineNum].IdValue  := fLines^[iLineNum].NetValue;
        // Can only check price information if a stock code is available
        if Trim(fLines^[iLineNum].StockCode) <> '' then
          CheckPrice(iLineNum);
      end;
    end;
  end; // ProcessPrice

  procedure ProcessDiscount;
  // Notes : Takes percent discount by preference over an amount
  //         Need to know business rules as to how to apply these
  var
    DiscountPercent,
    DiscountAmount : double;
    DiscountPercent2,
    DiscountAmount2 : double;
    DiscountPercent3,
    DiscountAmount3 : double;
  begin
    DiscountPercent := 0;
    DiscountAmount := 0;
    DiscountPercent2 := 0;
    DiscountAmount2 := 0;
    DiscountPercent3 := 0;
    DiscountAmount3 := 0;
    ReadDiscount(CurTransLine, DiscountPercent, DiscountAmount,  DiscountPercent2, DiscountAmount2,  DiscountPercent3, DiscountAmount3);
    if DiscountPercent <> 0 then
    begin
      fLines^[iLineNum].Discount := DiscountPercent;
      fLines^[iLineNum].DiscountChr := '%';
    end
    else
    begin
      // Assumes discount amount is for the whole line
      fLines^[iLineNum].Discount := DiscountAmount;
    end;

    if DiscountPercent2 <> 0 then
    begin
      fLines^[iLineNum].tlMultiBuyDiscount := DiscountPercent2;
      fLines^[iLineNum].tlMultiBuyDiscountChr := '%';
    end
    else
    begin
      // Assumes discount amount is for the whole line
      fLines^[iLineNum].tlMultiBuyDiscount := DiscountAmount2;
    end;

    if DiscountPercent3 <> 0 then
    begin
      fLines^[iLineNum].tlTransValueDiscount := DiscountPercent3;
      fLines^[iLineNum].tlTransValueDiscountChr := '%';
    end
    else
    begin
      // Assumes discount amount is for the whole line
      fLines^[iLineNum].tlTransValueDiscount := DiscountAmount3;
    end;

    fPresLineFields[iLineNum].IdDiscAmount := fLines^[iLineNum].Discount;
    fPresLineFields[iLineNum].IdDiscChar := fLines^[iLineNum].DiscountChr;
  end;


  function ReadVatTotal : Double;
  var
    VatTotal : IXmlDOMNodeList;
    strVatTotal : string;

  begin
    VatTotal := XMlDoc.getElementsByTagName(XSLQuery([XML_ORDER, XML_ORDER_TOTAL,
                                                   XML_TAX_TOTAL]));
    if VatTotal.Length > 0 then
    begin
      strVatTotal := VatTotal.Item[0].Text;
      Result := StrToFloat(strVatTotal);
    end
    else
      Result := 0;

  end;



  procedure SplitVat(const Freight, Misc, Disc : Double;
                       var varFreight, varMisc, varDisc : Double);
  var
    Total, VatAmount : Double;
    VatStr : string;
  begin
    VatAmount := ReadVatTotal - LineVatTotal;
    Total := Freight + Misc + Abs(Disc);
    if Total > 0 then
    begin
      varFreight := VatAmount * (Freight / Total);
      varMisc := VatAmount * (Misc / Total);
      varDisc := - (VatAmount * (Abs(Disc) / Total));
    end
    else
    begin
      varFreight := 0;
      varMisc := 0;
      varDisc := 0;
    end;
  end;

  function ProcessPath(var xPath : string) : Boolean;
  var
    Node : IXmlDOMNode;
  begin
    Node := CurTransLine.selectSingleNode(xPath);

    if Assigned(Node) then
    begin
      xPath := Node.text;
      Result := True;
    end
    else
      Result := False;
  end;

  function WantPreserve(var xPath : string) : Boolean;
  var
    Preserve : string;
    Node : IXmlDOMNode;
  begin
    Node := CurTransLine.selectSingleNode(xPath);

    if Assigned(Node) then
    begin
      Preserve := UpperCase(SafeSelectAttributeText(Node, XML_PRESERVE));
      Result := Preserve = 'TRUE';
      xPath := Node.text;
    end
    else
      Result := False;
  end;

  function ReadLineRef(const xPath : string) : string;
  var
    Node : IXmlDOMNode;
  begin
    Node := CurTransLine.selectSingleNode(xPath);

    if Assigned(Node) then
    begin
      Result := Node.text;
    end
    else
      Result := '';
  end;

begin // TXmlParse.ReadTransactionLines
  TransLines := XmlDoc.GetElementsByTagName(XSLQuery([XMLTransTag, XMLTransLineTag]));
  TotalLines := TransLines.Length;

  LineVatTotal := 0;

  for i := 1 to 6 do
    LSplit[i] := 0;

  if fDocGroup = grpOrders then
    LRefs := XML_ORDER_LINE_REFS
  else
    LRefs := XML_INVOICE_LINE_REFS;

  Try
    SetLength(fLines^, TotalLines + 1);
    SetLength(fPresLineFields, TotalLines + 1);
{    FillChar(fLines^, SizeOf(TBatchTLRec) * (TotalLines + 1), 0);}
  Except
    On E: EOutOfMemory do
      ShowMessage('Not enough memory to process transaction ' + fHeader^.DocUser1);
  End;
  for i := 0 to TotalLines - 1 do
  begin
    FillChar(fLines^[i + 1], SizeOf(TBatchTLRec), 0);
    FillChar(fPresLineFields[i + 1], SizeOf(TPreserveLineFields), 0);
    CurTransLine := TransLines.item[i];
    strLineNum := SafeSelectSingleNodeText(CurTransLine, XML_LINE_NUMBER);
    try
      iLineNum := StrToInt(strLineNum);
{      if iLineNum > 190 then
        raise EXMLFatalError.CreateFmt('Too many %s lines = %s (max = 190)',
          [XSLQuery([XMLTransTag, XMLTransLineTag]), strLineNum]);}
    except
      on EConvertError do
        raise EXMLFatalError.CreateFmt('"%s" is an invalid %s', [strLineNum, XML_LINE_NUMBER]);
    end;

    PreserveS := XML_LINE_NUMBER;
    if WantPreserve(PreserveS) then
    begin
      fPresLineFields[i + 1].IdLineNo := iLineNum;
      fPresLineFields[i + 1].IdAbsLineNo := i + 1;
    end;

    PreserveS := XSLQuery([LRefs, XML_PROJECT_CODE]);
    if WantPreserve(PreserveS) then
      fPresLineFields[i + 1].IdProjectCode := PreserveS;

    PreserveS := XSLQuery([LRefs, XML_PROJECT_ANALYSIS_CODE]);
    if WantPreserve(PreserveS) then
      fPresLineFields[i + 1].IdAnalysisCode := PreserveS;

    {$IFDEF EXTERNALIMPORT}
      if fDocGroup in [grpInvoices, grpSRI] then
    {$ELSE}
      if fDocGroup = grpInvoices then
    {$ENDIF}
    begin
      sLineRef := XSLQuery([LRefs, XML_PROJECT_CODE]);
      FLines^[i + 1].JobCode := ReadLineRef(sLineRef);
      if Trim(FLines^[i + 1].JobCode) = '' then
        FLines^[i + 1].JobCode := FHeader.DJobCode;
      sLineRef := XSLQuery([LRefs, XML_PROJECT_ANALYSIS_CODE]);
      FLines^[i + 1].AnalCode := ReadLineRef(sLineRef);
      if Trim(FLines^[i + 1].AnalCode) = '' then
        FLines^[i + 1].AnalCode := FHeader.DJobAnal;
    end;

(*     //PR: 24/07/2009 This would never work - Buyers Order No always comes from the header - not the line.
    {$IFDEF EXTERNALIMPORT}
      if fDocGroup in [grpInvoices, grpSRI] then
    {$ELSE}
      if fDocGroup = grpInvoices then
    {$ENDIF}
    begin
      PreserveS := XSLQuery([LRefs, XML_BUYER_ORDER_NO]);
      if WantPreserve(PreserveS) then
        fPresLineFields[i + 1].IdBuyersOrder := PreserveS;
    end
    else *)
      fPresLineFields[i + 1].IdBuyersOrder := fPresDocFields.InvBuyersOrder;

    PreserveS := XSLQuery([LRefs, XML_BUYERS_ORDER_LINE_REF]);
    if WantPreserve(PreserveS) then
      fPresLineFields[i + 1].IdBuyersLineRef := PreserveS;

    Try
      //PR: 12/06/2009
      //PR: 01/03/2012 ABSEXCH-11381 On orders in 309 format, need to read from Extensions tag
      if UseBasda309 and (fDocGroup = grpOrders) then
        PreserveS := XSLQuery([BASDA_EXTENSIONS, AddNameSpace(ENT_TRANS_LINE_EXTENSIONS, NAMESPACE_EXCHEQUER),
                              AddNameSpace(XML_ORDER_LINE_NUMBER, NAMESPACE_EXCHEQUER)])
      else
        PreserveS := XSLQuery([LRefs, XML_ORDER_LINE_NUMBER]);
      if ProcessPath(PreserveS) then
        fPresLineFields[i + 1].IdOrderLineNo := StrToInt(PreserveS);
    Except
    End;

    with fLines^[i{LineNum} + 1] do
    begin
      Desc := ReadDescription;
      LType := SafeSelectAttributeText(CurTransLine, XML_TYPE_CODE);
      DescOnlyLine := LType = BASDA_DESCRIPTION;
      DocLTLink := LineTypeMap(LType);
      LineNo := iLineNum;
      {Line numbers may not follow on but all the routines called here use iLineNum
       to identify which line we're using so change it to point at the right position
       in the array}
      iLineNum := i + 1;
      LineAction := SafeSelectAttributeText(CurTransLine, XML_ACTION);
      if (LineAction <> BASDA_LINE_DELETE) and (LineAction <> BASDA_LINE_CHANGE) then
        if fDocGroup = grpOrders then
        begin
          if fTransferMode = tfrExchange then // POR Exchange
            ProcessProduct(XML_SUPPLIERS_PRODUCT_CODE, XML_BUYERS_PRODUCT_CODE)
          else
            if fDocType = POR then // POR Replication
              ProcessProduct(XML_BUYERS_PRODUCT_CODE, XML_SUPPLIERS_PRODUCT_CODE)
            else // SOR Replication
              ProcessProduct(XML_SUPPLIERS_PRODUCT_CODE, XML_BUYERS_PRODUCT_CODE);
          if fHeader^.DueDate = '' then
            fHeader^.DueDate := fHeader^.TransDate;
          ProcessDeliveryDate;

          ProcessQuantity;
          ProcessDiscount;
          ProcessPrice;
        end
        else
        begin
          if fTransferMode = tfrExchange then
            ProcessProduct(XML_BUYERS_PRODUCT_CODE, XML_SUPPLIERS_PRODUCT_CODE) // SIN Exchange
          else
          {$IFDEF EXTERNALIMPORT}
            begin
              case fDocType of

                SIN : ProcessProduct(XML_SUPPLIERS_PRODUCT_CODE, XML_BUYERS_PRODUCT_CODE); // SIN Replication

                SRI : begin
                  // find payment line node
                  nPaymentLine := nil;
                  nlInvLineRefs := CurTransLine.selectNodes(XSLQuery([XML_INVOICE_LINE_REFS]));
                  if nlInvLineRefs.length > 0 then
                  begin
                    nPaymentLine := nlInvLineRefs.item[0].selectSingleNode(AddNameSpace(XML_PAYMENT_LINE, NAMESPACE_EXCHEQUER))
                  end;{if}

                  if Assigned(nPaymentLine) and (UpperCase(Trim(nPaymentLine.text)) = 'TRUE') then
                  begin
                    // Payment Line
                    fLines^[iLineNum].Payment := TRUE;
                    ProcessPayment(XML_SUPPLIERS_PRODUCT_CODE)
                  end else
                  begin
                    // Sales Line
                    ProcessProduct(XML_SUPPLIERS_PRODUCT_CODE, XML_BUYERS_PRODUCT_CODE) // SIN Replication
                  end;
                end;

                else begin
                  ProcessProduct(XML_BUYERS_PRODUCT_CODE, XML_SUPPLIERS_PRODUCT_CODE);
                end;
              end;{case}
            end;{if}
          {$ELSE}
            if fDocType = SIN then
              ProcessProduct(XML_SUPPLIERS_PRODUCT_CODE, XML_BUYERS_PRODUCT_CODE) // SIN Replication
            else
              ProcessProduct(XML_BUYERS_PRODUCT_CODE, XML_SUPPLIERS_PRODUCT_CODE);
          {$ENDIF}

          fLines^[iLineNum].LineDate := fHeader^.TransDate;
          ProcessQuantity;
          ProcessDiscount;
          ProcessPrice;
        end;

      fLines^[iLineNum].LineUser1 := ReadLineUDField(ENT_LINEUSER1);
      fLines^[iLineNum].LineUser2 := ReadLineUDField(ENT_LINEUSER2);
      fLines^[iLineNum].LineUser3 := ReadLineUDField(ENT_LINEUSER3);
      fLines^[iLineNum].LineUser4 := ReadLineUDField(ENT_LINEUSER4);

      fLines^[iLineNum].tlTransValueDiscountType := ReadTransDiscountType;

      if Vat > 0 then
      begin
        if not ReapplyPricing then
          fHeader^.ManVat := True;
          //if we're reapplying our pricing then we'll need to recalc the vat
      end;
      LineVatTotal := LineVatTotal + VAT;
    end; // with
  end; // Loop through all order lines


  //Freight and misc charges
  GetFreightCharge;
  GetMiscCharge;
//Freight & misc charges shouldn't have vat
//  SplitVat(FreightCharge, MiscCharge, DiscCharge, FreightVat, MiscVat, DiscVat);

  //Freight
  if FreightCharge > 0 then
  begin
    TotalLines := TotalLines + 1;
    SetLength(fLines^, TotalLines + 1);
    FillChar(fLines^[TotalLines], SizeOf(TBatchTLRec), 0);

    //PR: 13/07/2017 ABSEXCH-18560 v2017 R2 Need to keep PreserveLines array
    //                             in step to avoid overflow problems
    SetLength(fPresLineFields, TotalLines + 1);
    FillChar(fPresLineFields[TotalLines], SizeOf(TPreserveLineFields), 0);

    with fLines^[TotalLines] do
    begin
      Currency := fHeader^.Currency;
      DescOnlyLine := False;
      LineNo := TotalLines;
      NetValue := FreightCharge;
      LSplit[1] := FreightCharge;
      Discount := 0;
      Qty := TrueReal(1, SysInfo^.QuantityDP);
      QtyMul := 1;
      VatCode := 'Z'{was DefaultVatCode};
      Vat := {FreightVat}0;
      DocLTLink := LineTypeMap(BASDA_FREIGHT_CHARGES);

      if UseStockForCharges then
      begin
        StockCode := FreightStockCode;
        ProcessFreightMiscStock; //sets nomcode, cc, dep & desc
        CheckPrice(TotalLines);
      end
      else
      begin
        StockCode := '';
        Desc := FreightDesc;
        CC := DefaultCC;
        Dep := DefaultDept;
        if fDocGroup = grpOrders then
          NomCode := fDefaultSalesNomCode
        else
          NomCode := fDefaultPurchNomCode;
        MLocStk := fDefaultLocation;
      end;
    end; // with
  end;

  //Misc
  if MiscCharge > 0 then
  begin
    TotalLines := TotalLines + 1;
    SetLength(fLines^, TotalLines + 1);
    FillChar(fLines^[TotalLines], SizeOf(TBatchTLRec), 0);

    //PR: 13/07/2017 ABSEXCH-18560 v2017 R2 Need to keep PreserveLines array
    //                             in step to avoid overflow problems
    SetLength(fPresLineFields, TotalLines + 1);
    FillChar(fPresLineFields[TotalLines], SizeOf(TPreserveLineFields), 0);

    with fLines^[TotalLines] do
    begin

      Currency := fHeader^.Currency;
      DescOnlyLine := False;
      LineNo := TotalLines;
      NetValue := MiscCharge;
      LSplit[3] := MiscCharge;
      Discount := 0;
      Qty := TrueReal(1, SysInfo^.QuantityDP);;
      QtyMul := 1;
      VatCode := {DefaultVatCode}'Z';
      Vat := {MiscVat}0;
      DocLTLink := LineTypeMap(BASDA_MISC_CHARGES);


      if UseStockForCharges then
      begin
        StockCode := MiscStockCode;
        ProcessFreightMiscStock; //sets nomcode, cc, dep, loc & desc
        CheckPrice(TotalLines);
      end
      else
      begin
        Desc := MiscDesc;
        StockCode := '';
        CC := DefaultCC;
        Dep := DefaultDept;
        if fDocGroup = grpOrders then
          NomCode := fDefaultSalesNomCode
        else
          NomCode := fDefaultPurchNomCode;
        MLocStk := fDefaultLocation;
      end;
    end; // with
  end;

end; // TXmlParse.ReadTransactionLines

//-----------------------------------------------------------------------------------

function TXmlParse.AddTrans : integer;
// Post : If in Demo program mode returns the Toolkit error from an Ex_StoreTrans
//        Else defaults to 0 (meaning Toolkit data structures initialised)
var
  VATIndex,
  i : integer;

  function GetLineDiscAmt : double;
  begin
    with fLines^[i] do
      if DiscountChr = '%' then
        Result :=  fLines^[i].Discount * NetValue
      else
        Result := fLines^[i].Discount;

  end;

  function GetLineTot : double;
  var
    CurLine : ^TBatchTLRec;
  begin
    new(CurLine);
    Move(fLines^[i], CurLine^, SizeOf(CurLine^));
    if Ex_GetLineTotal(CurLine, SizeOf(CurLine^), false, {fHeader^.DiscSetl}0, Result) <> 0 then
      Result := Ex_RoundUp(fLines^[i].NetValue * fLines^[i].Qty, 2);
    dispose(CurLine);
  end;

begin
  with fHeader^ do
  begin
    if fDocGroup = grpInvoices then
    begin
      if fXMLSaveMode = xmlDemo then
        OurRef := NextDocNo('PIN');

      // Exchange SIN -> PIN, Replication SIN -> SIN, PIN -> PIN
      if (fTransferMode = tfrExchange) then
      begin
       if (fDocType = SIN) then
          TransDocHed := 'PIN'
       else
       if (fDocType = SCR) then
          TransDocHed := 'PCR';
      end
      else
        TransDocHed := DocCodes[fDocType];
      // When reading an invoice have to accept the VAT values as provided
      // hence need to set the "manual VAT" flag to true
      ManVAT := true;
    end
    else
    begin
      if fXMLSaveMode = xmlDemo then
        OurRef := NextDocNo('SOR');

      // Exchange POR -> SOR, Replication SOR -> SOR, POR -> POR
      if (fTransferMode = tfrExchange) and (fDocType = POR) then
        TransDocHed := 'SOR'
      else
        TransDocHed := DocCodes[fDocType];
     { ManVAT := false;}
    end;
 {   CoRate := 1;
    VATRate := 1;}
    LineCount := TotalLines;
  end;

  for i := 1 to TotalLines do
    with fLines^[i] do
    begin
      if DiscountChr = '%' then
        fHeader^.DiscAmount := fHeader^.DiscAmount + Round_Up((GetLineDiscAmt * Qty), 2)
      else
        fHeader^.DiscAmount := fHeader^.DiscAmount + Round_Up(GetLineDiscAmt, 2);

      {$IFDEF EXTERNALIMPORT}
        if (not fLines^[i].Payment)
        then fHeader^.InvNetVal := fHeader^.InvNetVal + Ex_RoundUp(GetLineTot, 2);
      {$ELSE}
        fHeader^.InvNetVal := fHeader^.InvNetVal + Ex_RoundUp(GetLineTot, 2);
      {$ENDIF}

      fHeader^.TotOrdOs := fHeader^.TotOrdOs + (NetValue * Qty) - Round_Up((GetLineDiscAmt * Qty),2);
      fHeader^.TotalCost := fHeader^.TotalCost + (CostPrice * Qty);
      TransRefNo := fHeader^.OurRef;
      Currency := fHeader^.Currency;
      VATRate := fHeader^.VATRate;
      CoRate := fHeader^.CoRate;
      if QtyMul = 0 then
        QtyMul := 1.0;
      if (fDocGroup = grpOrders) then
      begin // Re-calculate the VAT for an order
        if not fHeader^.ManVat then
          VAT := ((NetValue - GetLineDiscAmt) * Qty * (GetVATRate(VATCode) /100)) * (1 - fHeader^.DiscSetl);
        fHeader^.InvVAT := fHeader^.InvVAT + VAT;
        VATIndex := VATCodeToIndex(VATCode);
        if VATIndex <> - 1 then
          fHeader^.InvVATAnal[VATIndex] := fHeader^.InvVATAnal[VATIndex] + VAT;
      end;
      CustCode := fHeader^.CustCode;
    end;
  fHeader^.InvNetVal := Ex_RoundUp(fHeader^.InvNetVal, 2);
  fHeader^.DiscSetAm := Ex_RoundUp((fHeader^.InvNetVal - fHeader^.DiscAmount) * fHeader^.DiscSetl, 2);

  if fDocGroup = grpInvoices then
    for i := Low(fHeader^.InvVATAnal) to High(fHeader^.InvVATAnal) do
      fHeader^.InvVAT := fHeader^.InvVAT + fHeader^.InvVATAnal[i];

  if fXMLSaveMode = xmlDemo then
  begin
    Result := Ex_StoreTrans(fHeader, fLines, Sizeof(fHeader^), SizeOf(fLines^), 0, B_Insert);
    if Result = 0 then
      fCreatedTransName := fHeader^.OurRef;
  end
  else
    Result := 0;
end; // TXmlParse.AddTrans

//-----------------------------------------------------------------------------------

procedure TXmlParse.ReadInvoiceSettlementDate;
// Action : Read the settlement date i.e. the due date
var
  SettleDateInfo : IXmlDOMNodeList;
  CodeType : string;
  Days,
  i : integer;
begin
  SettleDateInfo := XmlDoc.getElementsByTagName(XSLQuery([XML_INVOICE, XML_SETTLEMENT,
    XML_SETTLEMENT_TERMS]));
  for i := 0 to SettleDateInfo.Length -1 do
  begin
    CodeType := SafeSelectAttributeText(SettleDateInfo.item[i], XML_CODE);
    if (Trim(CodeType) = BASDA_DATE) or (Trim(CodeType) = '') then  //PR 2/10/2007 Add check for no code
      fHeader^.DueDate := BASDADateToDate(Trim(SettleDateInfo.item[i].Text))
    else
      if copy(Trim(CodeType), length(CodeType), 1) = 'I' then
      begin
        Days := StrToInt(copy(Trim(CodeType), 1, length(Trim(CodeType)) -1));
        fHeader^.DueDate := DateTimeAsLongDate(ToDateTime(fHeader^.TransDate) + Days);
      end;
  end;
  // If no invoice settlement date was found, default first to the Supplier terms, then to the transaction date
  if fHeader^.DueDate = '' then
  begin
    if fCustSupp.PayTerms > 0 then
      fHeader^.DueDate := CalcDueDate(fHeader^.TransDate, fCustSupp.PayTerms)
    else
      fHeader^.DueDate := fHeader^.TransDate;
  end;
end; // procedure TXmlParse.ReadInvoiceSettlementDate

//-----------------------------------------------------------------------------------

procedure TXmlParse.ReadInvoiceSettlementDisc;
var
  SettleDiscInfo : IXmlDOMNodeList;
  SettleDiscTerms : string;
begin
  SettleDiscInfo := XmlDoc.getElementsByTagName(
    XSLQuery([XML_INVOICE, XML_SETTLEMENT, XML_SETTLEMENT_DISCOUNT]));

  if SettleDiscInfo.length > 0 then
    with fHeader^ do
    begin
      ReadDiscount(SettleDiscInfo[0], DiscSetl, DiscSetAm);

      // Days from invoice
{      SettleDiscTerms := SafeSelectSingleNodeText(SettleDiscInfo.item[0], XML_DAYS_FROM_INV);
      try
        DiscDays := StrToInt(Trim(SettleDiscTerms));
      except
      end;}
      ReadDiscountDays(SettleDiscInfo[0], XML_DAYS_FROM_INV, DiscDays);
      // Days from month end
      if DiscDays = 0 then
      begin
{        SettleDiscTerms := SafeSelectSingleNodeText(SettleDiscInfo.item[0], XML_DAYS_FROM_MONTH_END);
        try
          DiscDays := DaysToMonthEnd(ToDateTime(BASDADateToDate(TransDate))) +
            StrToInt(Trim(SettleDiscTerms));
        except
        end;}
        ReadDiscountDays(SettleDiscInfo[0], XML_DAYS_FROM_MONTH_END, DiscDays);
        DiscDays := DiscDays + DaysToMonthEnd(ToDateTime(BASDADateToDate(TransDate)));
      end;
      // Days from delivery
      if DiscDays = 0 then
      begin
{        SettleDiscTerms := SafeSelectSingleNodeText(SettleDiscInfo.item[0], XML_DAYS_FROM_DELIVERY);
        try
          DiscDays := DaysBetween(ToDateTime(DueDate), ToDateTime(TransDate)) +
            StrToInt(Trim(SettleDiscTerms));
        except
        end;}
        ReadDiscountDays(SettleDiscInfo[0], XML_DAYS_FROM_DELIVERY, DiscDays);
        DiscDays := DiscDays + DaysBetween(ToDateTime(DueDate), ToDateTime(TransDate));
      end;

      // Days from delivery
      if DiscDays = 0 then
      begin
        SettleDiscTerms := SafeSelectSingleNodeText(SettleDiscInfo.item[0], XML_PAYBY_DATE);
        try
          DiscDays := DaysBetween(ToDateTime(SettleDiscTerms), ToDateTime(TransDate));
        except
        end;
      end;

    //PR: 24/02/2015 ABSEXCH-15298 If PIN is dated on or after 01/04/2015 and it has settlement discount then
    //                             add a warning to the user. This will show up in Admin Module, and user won't
    //                             be able to post invoice into Exchequer until SettleDisc fields are cleared
    if not SettlementDiscountSupportedForDate(TransDate) then
    begin
      if not ZeroFloat(DiscSetl + DiscSetAm, 4) then
        fErrorLog.Add(logWarn, '*****'#10'WARNING: This invoice is dated ' + POutDate(TransDate) + ' but has Settlement Discount. ' +
                      'Because of changes to HMRC legislation effective 01/04/2015, this must be adjusted before' +
                      ' the invoice can be posted to Exchequer.'#10'*****'#10, 0)
      else
        //No settlement discount - clear DiscDays just in case
        DiscDays := 0;
    end;
  end;
end; // TXmlParse.ReadInvoiceSettlementDisc

//-----------------------------------------------------------------------------------

procedure TXmlParse.ReadOrderFullSettlementDisc;
var
  SettleDiscInfo : IXmlDOMNodeList;
  SettleDiscTerms : string;
begin
  SettleDiscInfo := XmlDoc.getElementsByTagName(
    XSLQuery([XML_ORDER, XML_SETTLEMENT, XML_SETTLEMENT_DISCOUNT]));

  if SettleDiscInfo.length > 0 then
    with fHeader^ do
    begin
      ReadDiscount(SettleDiscInfo[0], DiscSetl, DiscSetAm);

      // Days from invoice
{      SettleDiscTerms := SafeSelectSingleNodeText(SettleDiscInfo.item[0], XML_DAYS_FROM_INV);
      try
        DiscDays := StrToInt(Trim(SettleDiscTerms));
      except
      end;}
      ReadDiscountDays(SettleDiscInfo[0], XML_DAYS_FROM_INV, DiscDays);
      // Days from month end
      if DiscDays = 0 then
      begin
{        SettleDiscTerms := SafeSelectSingleNodeText(SettleDiscInfo.item[0], XML_DAYS_FROM_MONTH_END);
        try
          DiscDays := DaysToMonthEnd(ToDateTime(BASDADateToDate(TransDate))) +
            StrToInt(Trim(SettleDiscTerms));
        except
        end;}
        ReadDiscountDays(SettleDiscInfo[0], XML_DAYS_FROM_MONTH_END, DiscDays);
        DiscDays := DiscDays + DaysToMonthEnd(ToDateTime(BASDADateToDate(TransDate)));
      end;
      // Days from delivery
      if DiscDays = 0 then
      begin
{        SettleDiscTerms := SafeSelectSingleNodeText(SettleDiscInfo.item[0], XML_DAYS_FROM_DELIVERY);
        try
          DiscDays := DaysBetween(ToDateTime(DueDate), ToDateTime(TransDate)) +
            StrToInt(Trim(SettleDiscTerms));
        except
        end;}
        ReadDiscountDays(SettleDiscInfo[0], XML_DAYS_FROM_DELIVERY, DiscDays);
        DiscDays := DiscDays + DaysBetween(ToDateTime(DueDate), ToDateTime(TransDate));
      end;

      // Days from delivery
      if DiscDays = 0 then
      begin
        SettleDiscTerms := SafeSelectSingleNodeText(SettleDiscInfo.item[0], XML_PAYBY_DATE);
        try
          DiscDays := DaysBetween(ToDateTime(SettleDiscTerms), ToDateTime(TransDate));
        except
        end;
      end;
  end;
end; // TXmlParse.ReadOrderFullSettlementDisc

//-----------------------------------------------------------------------------------

procedure TXmlParse.ReadNarrative(const XMLTransTag : string);
// Notes : The transactions are stored in the EBusiness header and transaction lines files.
//         Nowhere to put these narrative lines currently without adding another file.
var
  NarrativeInfo : IXmlDOMNodeList;
  NarrText : ansistring;
  i : integer;
begin
  NarrativeInfo := XmlDoc.getElementsByTagName(XSLQuery([XmlTransTag, XML_NARRATIVE]));
  NarrText := '';
  for i := 0 to NarrativeInfo.Length - 1 do
  begin
    if i = 0 then
      NarrText := WrapText(Trim(NarrativeInfo.item[i].text), 65)
    else
      NarrText := NarrText + #13#10 + WrapText(Trim(NarrativeInfo.item[i].text), 65);

  end;
//  fNotes := WrapText(NarrText, 65);
  fNotes := NarrText;

  // Parse through the string, chopping it into pieces at the CRLF's and
  // ultimately add using Ex_StoreTrans
end; // TXmlParse.ReadNarrative

//-----------------------------------------------------------------------------------

procedure TXmlParse.SetInteger(Index, Value : integer);
begin
  case Index of
    1 : fTotalLines := Value;
    2 : fDefaultPurchNomCode := Value;
    3 : fDefaultSalesNomCode := Value;
    4 : fFreightMap := Value;
    5 : fMiscMap := Value;
    6 : fDiscMap := Value;
  end;
end;

//-----------------------------------------------------------------------------------

procedure TXmlParse.SetChar(Value : char);
begin
  fDefaultVATCode := Value;
end;

//-----------------------------------------------------------------------------------

procedure TXmlParse.SetString(Index : integer; const Value : string);
begin
  case Index of
    1: fDefaultCC := Value;
    2: fDefaultDept := Value;
    3: fDefaultLocation := Value;
    4: fDefaultCustCode := Value;
    5: fDefaultSuppCode := Value;
    6: fCompanyCode := Trim(Value);
    7: fFreightStockCode := Value;
    8: fMiscStockCode := Value;
    9: fDiscStockCode := Value;
    10: fFreightDesc := Value;
    11: fMiscDesc := Value;
    12 : fDiscDesc := Value;
    {$IFDEF EXTERNALIMPORT}
      13 : fCompanyPath := Value;
    {$ENDIF}
  end; // case
end; // TXmlParse.SetString

//-----------------------------------------------------------------------------------
(*
procedure TXmlParse.SetByte(const Index: Integer; const Value: byte);
begin
  case Index of
    1 : fDefaultFinPeriod := Value;
    2 : fDefaultFinYear := Value;
  end;
end; *)

//-----------------------------------------------------------------------------------
(*
procedure TXmlParse.SetDefaultPeriodMethod(const Value: TPeriodMethod);
begin
  fDefaultPeriodMethod := Value;
end; *)

//-----------------------------------------------------------------------------------

function TXmlParse.NextDocNo(DocType : string) : string;
var
  Doc,
  NextNo : array[0..255] of char;
  Status : integer;
begin
  StrPCopy(Doc, DocType);
  Status := Ex_GetNextTransNo(Doc, NextNo, true);
  if Status = 0 then
    Result := string(NextNo)
  else
    Result := '';
end;

function TXmlParse.LineTypeMap(const AType : string) : integer;
begin
  if AType = BASDA_FREIGHT_CHARGES then
    Result := fFreightMap
  else
  if AType = BASDA_MISC_CHARGES then
    Result := fMiscMap
  else
  if AType = BASDA_LINE_DISCOUNT then
    Result := fDiscMap
  else
    Result := 0;
end;

procedure TXmlParse.ReadHeaderUDFields;
var
  TransType : string;
  TransRef : string;
  TmpInt : SmallInt;
  c : Integer;

  function ReadField(const FNo : String) : string;
  var
    UD : IXmlDOMNodeList;
    i : integer;
    UDTag : string;
  begin
    UDTag := AddNameSpace(Fno, NAMESPACE_EXCHEQUER);
    if UseBasda309 then //PR: 07/02/2012 Add Extensions tag ABSEXCH-2748
      UD := XmlDoc.getElementsByTagName(XSLQuery([TransType, BASDA_EXTENSIONS,
                                          AddNameSpace(ENT_TRANS_EXTENSIONS, NAMESPACE_EXCHEQUER), UDTag]))
    else
      UD := XmlDoc.getElementsByTagName(XSLQuery([TransType, TransRef, UDTag]));
    for i := 0 to UD.length -1 do
      if Trim(UD.item[i].text) <> '' then
      Result := Trim(UD.item[i].text);
  end;

begin

  if fDocGroup = grpOrders then
  begin
    TransType := XML_ORDER;
    TransRef  := XML_ORDER_REFERENCE;
  end
  else
  begin
    TransType := XML_INVOICE;
    TransRef  := XML_INVOICE_REFERENCE;
  end;

  with fHeader^ do
  begin

  {    DocUser1 := ReadField(ENT_HEADUSER1);}
//Long your Ref is not actually used for anything although it is stored in Inv.transDesc
//so we'll use it to store header userfield 2
    LongYrRef := ReadField(ENT_HEADUSER2);
    DocUser3 := ReadField(ENT_HEADUSER3);
    //Added 1/09/04 at KH's request - if fUDF1 switch set then store udf1 from messsage in udf4,
    //then put it into udf1 when posting into enterprise.
    if fUDF1 then
      DocUser4 := ReadField(ENT_HEADUSER1)
    else
      DocUser4 := ReadField(ENT_HEADUSER4);


    //PR: 31/01/2013 ABSEXCH-13134 Add user fields 5-10.
    DocUser5  := ReadField(ENT_HEADUSER5);
    DocUser6  := ReadField(ENT_HEADUSER6);
    DocUser7  := ReadField(ENT_HEADUSER7);
    DocUser8  := ReadField(ENT_HEADUSER8);
    DocUser9  := ReadField(ENT_HEADUSER9);
    DocUser10 := ReadField(ENT_HEADUSER10);

    OpName := ReadField(ENT_YOURREF);



      Val(ReadField(ENT_HOLDSTATUS), TmpInt, c);
      if c = 0 then
        HoldFlg := TmpInt
      else
        HoldFlg := 0;


      Val(ReadField(ENT_TAGNO), TmpInt, c);
      if c = 0 then
        Tagged := TmpInt
      else
        Tagged := 0;
  end;

end;

procedure TXmlParse.ReadLineUDFields;
begin
end;

procedure TXmlParse.ReadDiscountDays(ParentNode   : IXmlDOMNode;
                               const DiscType     : String;
                                 var DiscountDays : SmallInt);
var
  PercentDiscTag,
  AmountDiscTag  : IXmlDOMNodeList;
  i : integer;
  strDiscount : string;
begin
  PercentDiscTag := ParentNode.selectNodes(XSLQuery([XML_DISCOUNT_PERCENT, XML_QUALIFYING_TERMS]));
  for i := 0 to PercentDiscTag.Length -1 do
  begin
    strDiscount := SafeSelectSingleNodeText(PercentDiscTag.item[i], DiscType);
    if strDiscount <> '' then
      try
        DiscountDays := StrToInt(strDiscount);
      except ;
      end
  end;

  if DiscountDays = 0 then
  begin
    AmountDiscTag := ParentNode.selectNodes(XSLQuery([XML_DISCOUNT_AMOUNT, XML_QUALIFYING_TERMS]));
    for i := 0 to AmountDiscTag.Length - 1 do
    begin
      strDiscount := SafeSelectSingleNodeText(AmountDiscTag.item[i], DiscType);
      if strDiscount <> '' then
      try
        DiscountDays := StrToInt(strDiscount);
      except ;
      end;
    end;
  end;
end; // TXmlParse.ReadDiscount


procedure TXmlParse.ReadLineReferences(const XMLTransTag, XMLTransRef,
  RefTypeTag: string; LineNo: Integer);
var
  LineRefs : IXmlDOMNodeList;
  Ref, p : string;
  i : integer;
begin
  LineRefs := XmlDoc.getElementsByTagName(XSLQuery([XMLTransTag, XMLTransRef]));
  for i := 0 to LineRefs.length -1 do
  begin
    Ref := SafeSelectSingleNodeText(LineRefs.item[i], RefTypeTag);
    if Ref <> '' then
    begin
      if RefTypeTag = XML_PROJECT_CODE then
        fLines^[LineNo].JobCode := Ref
      else
      if RefTypeTag = XML_PROJECT_ANALYSIS_CODE then
        fLines^[LineNo].AnalCode := Ref;
    end;
  end;
end;

procedure TXmlParse.FinalizePreserveLines;
begin
 //PR 19/12/2007 PreserveLines array wasn't being finalized so added this function that can be called from the importer
  Finalize(fPresLineFields)
end;


function TXmlParse.UseBasda309: Boolean;
begin
  Result := SchemaVersionRead >= '3.09';
end;

end.



