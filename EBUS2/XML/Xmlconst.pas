unit XMLConst;

{ prutherford440 09:52 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

const
  ERR_CUST_NOT_FOUND = 1;
  ERR_CUST_AMBIGUOUS = 2;
  ERR_SUPP_NOT_FOUND = 3;
  ERR_SUPP_AMBIGUOUS = 4;
  ERR_CURRENCY_NOT_FOUND = 5;
  ERR_CC_NOT_FOUND = 6;
  ERR_DEP_NOT_FOUND = 7;
  ERR_LOC_NOT_FOUND = 8;
  ERR_NOM_NOT_FOUND = 9;
  ERR_STOCK_NOT_FOUND = 10;
  ERR_QUANTITY = 11;
  ERR_PRICE = 12;
  ERR_PRICE_CHECK = 13;
  ERR_TAXCODE_NOT_FOUND = 14;

type
  // xmlEBusiness => Code called from the E-Business module
  // xmlDemo => Code called from the stand-alone demonstration program
  TXmlSaveMode = (xmlEBusiness, xmlDemo);

  // logWarn => Logged Information - minor alteration
  // logError => Major error - will be prevent transaction posting via Toolkit
  TLogErrorStatus = (logWarn, logError);

  // tfrReplication => copying transaction between Enterprise systems
  // tfrExchange => normal transaction processing
  TTransferMode = (tfrReplication, tfrExchange);

  {$IFDEF EXTERNALIMPORT}
    TDocGroup = (grpOrders, grpInvoices, grpSRI);
  {$ELSE}
    TDocGroup = (grpOrders, grpInvoices);
  {$ENDIF}

  // impFatal => XML file not well formed / not EBis compliant / could not be read in
  // impOK    => XML file imported without error
  // impWarn  => Imported OK but with default values substituted - should post via Toolkit
  // impError => Imported but with major errors - won't post via Toolkit
  TImportXML = (impFatal, impOK, impWarn, impError);
(*
  // perFromTransDate => Set from the transaction date
  // perFromEntDate   => To the current period in Enterprise
  // perToFixedDate   => To a fixed financial period / year in the eBusiness set-up
  TPeriodMethod = (perFromTransDate, perFromEntPeriod, perToFixedPeriod); *)

const
  MAX_VAT_INDEX = 20;
  VAT_CODES : array[0..MAX_VAT_INDEX] of char = ('S','E','Z','1','2','A','D','5',
                                                 '6','7','8','9','T','X','B','C',
                                                 'F','G','R','W','Y');
  CRLF = #13#10;

  // BizTalk
  BIZTALK = 'biztalk_1';
  BIZTALK_URN = 'urn:schemas-biztalk-org:biztalk/biztalk_1.xml';
  BIZTALK_HEADER = 'header';
  BIZTALK_DELIVERY = 'delivery';
  BIZTALK_MESSAGE = 'message';
  BIZTALK_MESSAGE_ID = 'messageID';
  BIZTALK_SENT = 'sent';
  BIZTALK_SUBJECT = 'subject';
  BIZTALK_BASDA_SENDER = 'SENDER';
  BIZTALK_BASDA_RECIPIENT = 'RECIPIENT';
  BIZTALK_BASDA_URN = 'urn:basda.org:header';

  NAMESPACE_BASDA = 'basda';
  NAMESPACE_EXCHEQUER = 'exchequer';

  BIZTALK_TO = 'to';
  BIZTALK_FROM = 'from';
  BIZTALK_ADDRESS = 'address';
  BIZTALK_STATE = 'state';
  BIZTALK_REFERENCE_ID = 'referenceID';
  BIZTALK_HANDLE = 'handle';
  BIZTALK_PROCESS = 'process';
  BIZTALK_MANIFEST = 'manifest';

  // Tags
  XML_BODY = 'body';
  XML_SCHEMA = 'Schema';
  XML_VERSION = 'Version';
  XML_STYLESHEET = 'Stylesheet';
  XML_STYLESHEET_OWNER = 'StylesheetOwner';
  XML_STYLESHEET_NAME = 'StylesheetName';
  XML_STYLESHEET_TYPE = 'StylesheetType';

  XML_PARAMETERS = 'Parameters';
  XML_LANGUAGE = 'Language';
  XML_DECIMAL_SEP = 'DecimalSeparator';

  XML_SOFTWARE = 'OriginatingSoftware';
  XML_SOFTWARE_MANUFAC = 'SoftwareManufacturer';
  XML_SOFTWARE_PRODUCT = 'SoftwareProduct';
  XML_SOFTWARE_VERSION = 'SoftwareVersion';

  XML_PRECISION = 'Precision';
  XML_CHECKSUM = 'Checksum';

  XML_INTRASTAT = 'Intrastat';
  XML_INTRASTAT_COMMOD_CODE = 'CommodityCode';
  XML_INTRASTAT_COMMOD_DESC = 'CommodityDescription';
  XML_INTRASTAT_NATURE_OF_TRANSACT = 'NatureOfTransaction';
  XML_INTRASTAT_SUPP_UNITS = 'SupplementaryUnits';
  XML_INTRASTAT_COUNTRY_DEST = 'CountryOfDestination';
  XML_INTRASTAT_MODE_OF_TRANSPORT = 'ModeOfTransport';

  XML_TYPE = 'Type';
  XML_CODE = 'Code';
  XML_PRESERVE = 'Preserve';
  XML_TRUE = 'true';
  XML_FUNCTION = 'Function';

  XML_ORDER = 'Order';
  XML_ORDER_TYPE = 'OrderType';
  XML_ORDER_HEAD = 'OrderHead';
  XML_ORDER_TOTAL = 'OrderTotal';
  XML_GOODS_VALUE = 'GoodsValue';
  XML_TAX_TOTAL = 'TaxTotal';
  XML_GROSS_VALUE = 'GrossValue';

  XML_INVOICE = 'Invoice';
  XML_INVOICE_TYPE = 'InvoiceType';
  XML_INVOICE_HEAD = 'InvoiceHead';

  XML_ORDER_REFERENCE = 'OrderReferences';
  XML_SUPPLIER_ORDER_REFERENCE = 'SuppliersOrderReference';
  XML_BUYER_ORDER_NO = 'BuyersOrderNumber';
  XML_ORDER_DATE = 'OrderDate';

  XML_INVOICE_REFERENCE = 'InvoiceReferences';
  XML_SUPPLIER_INVOICE_NO = 'SuppliersInvoiceNumber';
  XML_INVOICE_DATE = 'InvoiceDate';

  XML_BUYER = 'Buyer';
  XML_SUPPLIER = 'Supplier';
  XML_INVOICE_TO = 'InvoiceTo';
  XML_PARTY = 'Party';
  XML_BUYER_CODE_SUPPLIER = 'BuyersCodeForSupplier';
  XML_SUPPLIER_CODE_BUYER = 'SuppliersCodeForBuyer';
  XML_BUYER_CODE_INVOICE_TO = 'BuyersCodeForInvoiceTo';
  XML_SUPPLIER_CODE_INVOICE_TO = 'SuppliersCodeForInvoiceTo';
  XML_SUPPLIER_REFS = 'SupplierReferences';
  XML_BUYER_REFS = 'BuyerReferences';
  XML_INVOICE_TO_REFS = 'InvoiceToReferences';
  XML_TAX_NUMBER = 'TaxNumber';
  XML_BUYER_CODE_DELIVERY = 'BuyersCodeForDelivery';


  XML_ADDRESS = 'Address';
  XML_ADDRESSLINE = 'AddressLine';
  XML_STREET = 'Street';
  XML_CITY = 'City';
  XML_STATE = 'State';
  XML_COUNTRY = 'Country';
  XML_POSTCODE = 'PostCode';

  XML_ORDERLINE = 'OrderLine';
  XML_ORDER_LINE_REFS = 'OrderLineReferences';

  XML_INVOICELINE = 'InvoiceLine';
  XML_INVOICE_LINE_REFS = 'InvoiceLineReferences';
  XML_ORDER_LINE_NUMBER = 'OrderLineNumber';

  XML_NARRATIVE = 'Narrative';

  XML_ACTION = 'Action';
  XML_TYPE_CODE = 'TypeCode';
  XML_TYPE_DESC = 'TypeDescription';
  XML_LINE_NUMBER = 'LineNumber';

  XML_COST_CENTRE = 'CostCentre';
  XML_DEPARTMENT = 'Department'; // Not part of version 3 spec - Enterprise specific
  XML_LOCATION = 'Location';     // Not part of version 3 spec - Enterprise specific
  {$IFDEF EXTERNALIMPORT}
    XML_PAYMENT_LINE = 'PaymentLine';
  {$ENDIF}

  XML_GL_CODE = 'GeneralLedgerCode';
  XML_PROJECT_CODE = 'ProjectCode';
  XML_PROJECT_ANALYSIS_CODE = 'ProjectAnalysisCode';

  XML_PRODUCT = 'Product';
  XML_PRODUCT_DESCRIPTION = 'Description';
  XML_SUPPLIERS_PRODUCT_CODE = 'SuppliersProductCode';
  XML_BUYERS_PRODUCT_CODE = 'BuyersProductCode';
  XML_CONSUMER_UNIT_CODE = 'ConsumerUnitCode'; // Bar code

  XML_PRODUCT_PROPERTIES = 'Properties';
  XML_PROPERTIES_WEIGHT = 'Weight';
  XML_PROPERTIES_UOM_CODE = 'UOMCode';
  XML_PROPERTIES_UOM_DESC = 'UOMDescription';

  XML_QUANTITY = 'Quantity';
  XML_QUANT_UOM_CODE = 'UOMCode';
  XML_QUANT_UOM_DESC = 'UOMDescription';
  XML_QUANT_PACKSIZE = 'Packsize';

  XML_PRICE = 'Price';
  XML_UNITS = 'Units';
  XML_UNIT_PRICE = 'UnitPrice';
  XML_PRICE_UOM_DESC = 'UOMDescription';

  XML_DISCOUNT_AMOUNT = 'AmountDiscount';
  XML_AMOUNT = 'Amount';
  XML_DISCOUNT_PERCENT = 'PercentDiscount';
  XML_PERCENTAGE = 'Percentage';
  XML_QUALIFYING_TERMS = 'QualifyingTerms';

  XML_DELIVERY = 'Delivery';
  XML_DELIVER_TO = 'DeliverTo';

  XML_CONTACT = 'Contact';
  XML_CONTACT_NAME = 'Name';
  XML_CONTACT_DDI = 'DDI';
  XML_CONTACT_MOBILE = 'Mobile';
  XML_CONTACT_FAX = 'Fax';
  XML_CONTACT_EMAIL = 'Email';

  XML_EARLIEST_DATE = 'EarliestAcceptableDate';
  XML_LATEST_DATE = 'LatestAcceptableDate';
  XML_PREFERRED_DATE = 'PreferredDate';

  XML_CURRENCY = 'Currency';
  XML_ORDER_CURRENCY = 'OrderCurrency';
  XML_INVOICE_CURRENCY = 'InvoiceCurrency';

  XML_LINE_TOTAL = 'LineTotal';

  XML_LINE_TAX = 'LineTax';
  XML_TAX_RATE = 'TaxRate';
  XML_TAX_VALUE = 'TaxValue';

  XML_LOT_SERIAL = 'LotSerial';
  XML_LOT_SERIAL_TYPE = 'LotSerialType';
  XML_LOT_SERIAL_NUMBER = 'LotSerialNumber';

  XML_TAX_SUBTOTAL = 'TaxSubTotal';
  XML_TAX_RATE_LINES = 'NumberOfLinesAtRate';
  XML_TAX_RATE_TOTAL = 'TotalValueAtRate';
  XML_TAX_RATE_SETTLE = 'SettlementDiscountAtRate';
  XML_TAX_RATE_DISC_VALUE = 'TaxableValueAtRate';
  XML_TAX_RATE_TAX_VALUE = 'TaxAtRate';
  XML_TAX_RATE_NET_PAY = 'NetPaymentAtRate';
  XML_TAX_RATE_GROSS_PAY = 'GrossPaymentAtRate';
  XML_TAX_CURRENCY = 'TaxCurrency';

  XML_INVOICE_TOTAL = 'InvoiceTotal';
  XML_NUMBER_LINES = 'NumberOfLines';
  XML_NUMBER_TAX_RATES = 'NumberOfTaxRates';
  XML_LINE_VALUE_TOTAL = 'LineValueTotal';
  XML_SETTLE_DISC_TOTAL = 'SettlementDiscountTotal';
  XML_DISCOUNTED_TAX_TOTAL = 'TaxableTotal';
  XML_NET_PAYMENT_TOTAL = 'NetPaymentTotal';
  XML_GROSS_PAYMENT_TOTAL = 'GrossPaymentTotal';

  XML_SETTLEMENT = 'Settlement';
  XML_SETTLEMENT_TERMS = 'SettlementTerms';
  XML_SETTLEMENT_DISCOUNT = 'SettlementDiscount';
  XML_PAYBY_DATE = 'PayByDate';
  XML_DAYS_FROM_INV = 'DaysFromInvoice';
  XML_DAYS_FROM_MONTH_END = 'DaysFromMonthEnd';
  XML_DAYS_FROM_DELIVERY = 'DaysFromDelivery';

  XML_BANK_DETAILS = 'BankDetails';
  XML_BANK_CODE = 'BankCode'; // Sort code
  XML_BANK_REFERENCE = 'BankReference';

  XML_CARD_DETAILS = 'CardDetails';
  XML_CARD_ISSUE_DATE = 'IssueDate';
  XML_CARD_EXPIRY_DATE = 'ExpiryDate';
  XML_CARD_NUMBER = 'CardNumber';
  XML_CARD_ISSUE_NUM = 'IssueNumber';

  XML_FREIGHT_CHARGES = 'FreightCharges';
  XML_MISC_CHARGES = 'MiscCharges';

  // Extra codes for using EBis message for Enterprise to Enterprise transfers
  XML_PROPRIETARY = 'Proprietary';
  XML_ENTERPRISE = 'Enterprise';
  XML_TRANSFER_MODE = 'TRANSFERMODE';
  XML_TRANSACTION_TYPE = 'TRANSACTTYPE';

  // Extra codes introduced for customer / stock
  XML_CARD_NAME = 'CardName';
  XML_BANK_ACCOUNT = 'BankAccount';
  XML_DEFAULTS = 'Defaults';
  XML_ALT_SUPPLIER_CODE_BUYER = 'AltSuppliersCodeForBuyer';
  XML_ALT_BUYER_CODE_SUPPLIER = 'AltBuyersCodeForSupplier';
  XML_TAX_INFO = 'TaxInfo';
  XML_VAT_CODE = 'VATCode';
  XML_VAT_INCLUSIVE_CODE = 'VATInclusiveCode';
  XML_DESCRIPTION_LINE = 'DescriptionLine';
  XML_GL_SALES = 'Sales';
  XML_GL_COSTOFSALES = 'CostOfSales';
  XML_GL_DEFAULT = 'Default';
  XML_GL_PROFITANDLOSS = 'ProfitAndLoss';
  XML_GL_BALSHEET = 'BalanceSheet';
  XML_GL_WIP = 'WorkInProgress';



  XML_DATABASE_INFO = 'DatabaseInfo';
  XML_RECORD_UPDATED = 'RecordUpdated';
  XML_RECORD_DATE = 'Date';
  XML_RECORD_TIME = 'Time';
  XML_RECORD_LAST_USER = 'LastUser';

  XML_BUYERS_ORDER_LINE_REF = 'BuyersOrderLineReference';

  // Standard constants not in Appendices
  STD_EXCHEQUER_URN = 'urn:www.exchequer.com';
  STD_BASDA_NAME = 'BASDA';
  STD_XSL_NAME = 'xsl';
  STD_XMLNS_NAME = 'xmlns';
  STD_DECIMAL_SYMBOL = '.';
  STD_LANGUAGE_CODE = 'en_GB';
  STD_PRECISION = '20.3';

  // Appendix 1.1 BASDA ORDER Types
  BASDA_PURCH_ORDER = 'PUO';
  BASDA_BLANKET_ORDER = 'BLO';
  BASDA_SPOT_ORDER = 'SPO';
  BASDA_LEASE_ORDER = 'LEO';
  BASDA_RUSH_ORDER = 'RUO';
  BASDA_REPAIR_ORDER = 'REO';
  BASDA_CALL_OFF_ORDER = 'CAO';
  BASDA_CONSIGNMENT_ORDER = 'COO';
  BASDA_SAMPLE_ORDER = 'SAO';
  BASDA_SWAP_ORDER = 'SWO';
  BASDA_HIRE_ORDER = 'HIO';
  BASDA_SALES_ORDER = 'SLR';
  //PSR: 05/6/02 added extras listed in v3.03 of code list
  BASDA_CHANGE_ORDER = 'PCR';
  BASDA_RESPONSE_ORDER = 'POR';
  BASDA_SPARE_PARTS_ORDER = 'SPO';
  BASDA_WEB_ORDER = 'WEO';
  BASDA_QUOTE_REQUEST_ORDER = 'RFQ';
  BASDA_QUOTE_RESPONSE_ORDER = 'RRQ';

  // Appendix 1.2 BASDA Message function codes
  BASDA_FIRM_ORDER = 'FIO';
  BASDA_PROPOSED_ORDER = 'PRO';
  BASDA_PROVISIOAL_ORDER = 'PVO';
  BASDA_TEST_ORDER = 'TEO';
  //PSR: 05/6/02 added extras listed in v3.03 of code list
  BASDA_AMENDMENT_ORDER = 'AMO';
  BASDA_CANCELLATION_ORDER = 'CAO';
  BASDA_COPY_ORDER = 'COO';
  BASDA_REPLACEMENT_ORDER = 'RPO';
  BASDA_VARIATION_ORDER = 'VRO';

  // Appendix 1.4 BASDA Discount types
  BASDA_SPECIAL_DISCOUNT = 'SPD';
  BASDA_LINE_DISCOUNT = 'LID';
  BASDA_VOLUME_DISCOUNT = 'VOD';
  BASDA_EARLY_SETTLE_DISCOUNT = 'ESD';
  BASDA_RECIPE_DISCOUNT = 'RED'; // Derived discount = recipe discount
  BASDA_TRADE_DISCOUNT = 'TRD';
  //PSR: 05/6/02 added extras listed in v3.03 of code list
  BASDA_LATE_INTEREST = 'LPI';

  // Appendix 1.5 BASDA Dimension codes
  BASDA_WEIGHT_KG = 'KGM';

  // Appendix 1.7
  BASDA_GOODS = 'GDS';
  BASDA_DESCRIPTION = 'DES';
  BASDA_BLANKLINE = 'BLK';
  BASDA_ORDER_LINE = 'ORL';
  BASDA_INVOICE_LINE = 'INL';
  BASDA_FREIGHT_CHARGES = 'FRT';
  BASDA_MISC_CHARGES = 'MIS';
  //PSR: 05/6/02 added extras listed in v3.03 of code list
  BASDA_CHANGE = 'CHG';
  BASDA_ALLOWANCE = 'ALW';
  BASDA_SUB_ASSEMBLY = 'SUA';

  // Appendix 1.8 BASDA Invoice types
  BASDA_COMMERCIAL_INVOICE = 'INV';
  BASDA_COMMISSION_NOTE = 'CMN';
  BASDA_DEBIT_NOTE = 'DEN';
  BASDA_CONSOLIDATED_INVOICE = 'CSI';
  BASDA_PREPAYMENT_INVOICE = 'PPI';
  BASDA_HIRE_INVOICE = 'HII';
  BASDA_TAX_INVOICE = 'TXI';
  BASDA_SELF_BILLED_INVOICE = 'SBI';
  BASDA_FACTORED_INVOICE = 'FCI';
  BASDA_LEASE_INVOICE = 'LEI';
  BASDA_CONSIGNMENT_INVOICE = 'CGI';
  BASDA_PURCH_INVOICE = 'PIN'; // Not officially in appendix
  //PSR: 05/6/02 added extras listed in v3.03 of code list
  BASDA_CREDIT_INVOICE = 'CRN';
  BASDA_CORRECTED_INVOICE = 'CRI';
  BASDA_PRO_FORMA_INVOICE = 'PFI';
  BASDA_DELCREDERE_INVOICE = 'DCI';


  // Appendix 1.9 BASDA Message function codes
  BASDA_FIRM_INVOICE = 'FII';
  BASDA_PROPOSED_INVOICE = 'PRI';
  BASDA_PROVISIONAL_INVOICE = 'PVI';
  BASDA_TEST_INVOICE = 'TEI';
  //PSR: 05/6/02 added extras listed in v3.03 of code list
  BASDA_AMENDMENT_INVOICE = 'AMI';
  BASDA_CANCELLATION_INVOICE = 'CAI';
  BASDA_COPY_INVOICE = 'COI';

  // Appendix 1.10 BASDA Settlement terms codes
  BASDA_DATE = 'Date';
  //PSR: 05/6/02 added extras listed in v3.03 of code list
  BASDA_TEN_DAYS_FROM_INVOICE = '10I';
  BASDA_TWENTY_DAYS_FROM_INVOICE = '20I';
  BASDA_TEN_DAYS_FROM_DELIVERY = '10D';
  BASDA_TWENTY_DAYS_FROM_DELIVERY = '20D';
  BASDA_PAID = 'PAD';


  // Appendix 1.13 BASDA VAT / Tax codes
  BASDA_STANDARD_VAT = 'S';
  BASDA_ZERO_VAT = 'Z';
  BASDA_EXEMPT_VAT = 'E';
  BASDA_LOWER_RATE_VAT = 'L';
  BASDA_HIGHER_RATE_VAT = 'H';
  BASDA_NO_VAT = 'N';
  BASDA_NON_UK_VAT = 'X';

  // Appendix 1.15 BASDA Lot / serial type
  BASDA_LOT_NUMBER = 'LOT';
  BASDA_SERIAL_NUMBER = 'SER';
  BASDA_BATCH_NUMBER = 'BCH';

  // Other attribute values
  BASDA_LINE_ADD = 'Add';
  BASDA_LINE_DELETE = 'Delete';
  BASDA_LINE_CHANGE = 'Change';

  BASDA_USER_DEFINED = 'USR';

  //PR: 07/02/2012 Add Extensions tag ABSEXCH-2748
  BASDA_EXTENSIONS = 'Extensions';

  // Added for Enterprise specific purposes
  ENT_REPLICATION = 'REPLICATION';  // i.e. copying a transaction between 2 systems
  ENT_EXCHANGE = 'EXCHANGE';        // i.e. the normal mode - a transaction to be processed

  ENT_HEADUSER1 = 'HeaderUserDef1';
  ENT_HEADUSER2 = 'HeaderUserDef2';
  ENT_HEADUSER3 = 'HeaderUserDef3';
  ENT_HEADUSER4 = 'HeaderUserDef4';

  //PR: 31/01/2013 ABSEXCH-13134 Added UDFs 5-10
  ENT_HEADUSER5  = 'HeaderUserDef5';
  ENT_HEADUSER6  = 'HeaderUserDef6';
  ENT_HEADUSER7  = 'HeaderUserDef7';
  ENT_HEADUSER8  = 'HeaderUserDef8';
  ENT_HEADUSER9  = 'HeaderUserDef9';
  ENT_HEADUSER10 = 'HeaderUserDef10';

  ENT_LINEUSER1  = 'LineUserDef1';
  ENT_LINEUSER2  = 'LineUserDef2';
  ENT_LINEUSER3  = 'LineUserDef3';
  ENT_LINEUSER4  = 'LineUserDef4';

  ENT_QUANTITY_PICKED   = 'QuantityPicked'; //Added 6/12/07 at request of KH for Polestar
  ENT_QUANTITY_PICKEDWO = 'QuantityPickedWO'; //Added 6/12/07 at request of KH for Polestar

  ENT_YOURREF = 'YourRef';
  ENT_TAGNO = 'TagNo';

  ENT_HOLDSTATUS = 'HoldStatus'; //added 7/11/05 at request of NF/KH for Volac plug-in.

  ENT_TRANS_DISC_TYPE = 'SpecialDiscountType';
  ENT_TRANS_DISC_TTD = 'TTD';
  ENT_TRANS_DISC_VBD = 'VBD';
  ENT_TRANS_MBD_DESC_LINE = 'DDL';

  ENT_TRANS_EXTENSIONS = 'AdditionalReferences';
  ENT_TRANS_LINE_EXTENSIONS = 'AdditionalLineReferences';

  //PR: 07/02/2012 Added new tag for linking stock description lines ABSEXCH-
  ENT_EXTENDED_LINE_TYPE = 'ExtendedLineType';
  ENT_EXTENDED_LINE_TYPE_STOCK_DESCRIPTION = '1';


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

end.
