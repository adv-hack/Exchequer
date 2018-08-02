unit EBusVar;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  BtrvU2, Sentimail_TLB;

// Turn word alignment off
{$A-}
const
  EBsF =  18;                       // Same as FaxF for now
  CompCodeLen = 6;

  EBUS_DIR = 'EBus';

  EBUS_XML_DIR = 'XML';
  EBUS_XSL_DIR = 'XSL';
  EBUS_EML_Ext = '.EML';
  EBUS_Txt_DIR = 'TEXT';
  EBus_XSL_DefXSL = 'excheqr.xsl';
  EBUS_XML_SEARCH_DIR = 'Search';
  EBUS_XML_FAIL_DIR = 'Failed';
  EBUS_XML_ARCHIVED_DIR = 'Archived';

  EBUS_LOGS_DIR = 'Logs';
  EBUS_LOGS_IMPORTED_DIR = 'Imported';
  EBUS_LOGS_EXPORT_DIR = 'Export';
  EBUS_XML_POSTED_DIR = 'Posted';
  EBUS_CSVMAP_DIR= 'CSVMAP';

  EBUS_FILENAME   = 'EBus.DAT';
  EBUS_DOCNAME    = 'EBUSDOC.DAT';
  EBUS_DETAILNAME = 'EBUSDETL.DAT';
  EBUS_NOTESNAME  = 'EBUSNOTE.DAT';
  EBUS_TRADNAME   = 'EBUSCUSU.DAT';

  EBUS_MAX_REC_SIZE = 900;

  // RecPFix values
  EBUS_RECPFIX_ENTERPRISE = 'E';
  EBUS_RECPFIX_DRAGNET    = 'D';

  // SubType values
  EBUS_SUBTYPE_GENERAL     = 'G';
  EBUS_SUBTYPE_COMPANY     = 'C';
  EBUS_SUBTYPE_IMPORT      = 'I';
  EBUS_SUBTYPE_EXPORT      = 'X';
  EBUS_SUBTYPE_FTP         = 'F';
  EBUS_SUBTYPE_EMAIL       = 'E';
  EBUS_SUBTYPE_CSV         = 'V';
  EBUS_SUBTYPE_FILE        = 'D';
  EBUS_SUBTYPE_XML         = 'L';
  EBUS_SUBTYPE_CATALOGUE   = 'A';
  EBUS_SUBTYPE_COUNTRY     = 'Y';
  EBUS_SUBTYPE_COM_PRICING = 'M';
  EBUS_SUBTYPE_COUNTERS    = 'N';
  EBUS_SUBTYPE_PRESERVEINV = 'P';
  EBUS_SUBTYPE_PRESERVEID  = 'Q';

  DefaultFreightDesc = 'Freight charges';
  DefaultMiscDesc    = 'Misc charges';
  DefaultDiscDesc    = 'Discount';


type
  TEBusParams = record
    EntDefaultCompany : string[6];   // Code for default multi-company on start-up
    // One CSV mapping file sub-directory off of the main company's EBus sub-directory
    EntCSVMapFileDir  : string[50];  // Currently MainCompany\EBus\CSVMap
    // One text file sub-directory off of the main company's EBus sub-directory
    // Text files for standard transaction progress notification messages
    EntTextFileDir    : string[50];  // Currently MainCompany\EBus\Text
    EntPollFreq       : cardinal;    // Global polling frequency for import module
    EntSetupPassword  : string[12];
  end;

  TEBusDragNet = record
    DNetPublisherCode     : string[8];
    DNetPublisherPassword : string[20];
  end;

  // Company Data
  TEBusCompany = record
    CompPostingLogDir    : string[50]; // Relative to specific company root
    CompDefCostCentre    : string[3];  // Default Cost centre
    CompDefDept          : string[3];  // Default Department
    CompDefLocation      : string[3];  // Default Location
    CompDefCustomer      : string[10]; // Default Customer
    CompDefSupplier      : string[10]; // Default Supplier
    CompDefPurchNom      : longint;    // Default nominal code for purchases
    CompDefSalesNom      : longint;    // Default nominal code for sales
    CompDefVATCode       : char;
    // 0 = from the transaction date, 1 = from current Enterprise date, 2 = manually
    CompSetPeriodMethod  : byte;
    CompPeriod           : byte;       // Financial period if setting period manually
    CompYear             : byte;       // Financial year if setting period manually
    CompKeepTransNo      : byte;       // Try to keep transaction number if replicating? 0 = false
    // 0 = no; 1 = hold only, 2 = warnings only, 3 = hold and warnings
    CompPostHoldFlag     : byte;
    CompTransTextDir     : string[50]; // Relative to specific company root
    CompOrdOKTextFile    : string[12]; // File with notification text when an order is OK
    CompOrdFailTextFile  : string[12]; // File with notification text when an order is not OK
    CompInvOKTextFile    : string[12]; // File with notification text when an invoice is OK
    CompInvFailTextFile  : string[12]; // File with notification text when an invoice is not OK

    CompXMLAfterProcess  : byte;       // 0 = archive, 1 = delete

    CompCSVDelimiter     : char;       //
    CompCSVSeparator     : char;       //
    CompCSVIncHeaderRow  : byte;       // 0=false, 1=true
    CompFreightLine      : byte;       // User defined transaction line that maps to freight
    CompMiscLine         : byte;       // User defined transaction line that maps to misc
    CompDiscount         : byte;       // User defined transaction line that maps to discounts
    CompCustLockFile     : string[12]; // Customer lock file name default
    CompStockLockFile    : string[12]; // Stock / Stock & location lock file name default
    CompStockGrpLockFile : string[12]; // Stock group lock file name default
    CompTransLockFile    : string[12]; // Transaction lock file name default
    CompCustLockExt      : string[3];  // Customer lock file extension
    CompStockLockExt     : string[3];  // Stock / Stock & location lock file extension
    CompStockGrpLockExt  : string[3];  // Stock group lock file extension
    CompTransLockExt     : string[3];  // Transaction lock file extension
    // Lock methods, 0 = file present as lock, 1 = file present as ready to use flag
    CompCustLockMethod   : byte;       // Customer lock file method
    CompStockLockMethod  : byte;       // Stock / Stock & location lock file method
    CompStockGrpMethod   : byte;       // Stock group lock file method
    CompTransLockMethod  : byte;       // Transaction lock file method
//New fields added (28/1/2001) to control how Freight, Misc & Discount trailer tags are
//imported - if CompUseStockForCharges then they are associated with stock codes
//otherwise brought in as freight, disc & normal lines using default nominal codes, etc.
    CompUseStockForCharges : byte;      //0 = false, 1 = True
    CompFreightStockCode   : string[16];
    CompMiscStockCode      : string[16];
    CompDiscStockCode      : string[16];
    CompFreightDesc        : string[40];
    CompMiscDesc           : string[40];
    CompDiscDesc           : string[40];
    CompReapplyPricing     : byte;      //0 = false, 1 = True
    CompYourRefToAltRef    : Boolean;
    CompUseMatching        : Boolean;
    CompSentimailEvent     : Boolean;
    CompLocationOrigin     : Byte; //0 - Customer, Stock, Default; 1- Stock, Customer, Default
    CompImportUDF1         : Boolean;
    CompGeneralNotes       : Boolean;
    CompCCDepFromXML       : Boolean;
    CompUseBasda309         : Boolean; //PR: 11/06/2009 Added switch for Basda eBIS-XML 3.09 schema
    CompDescLinesFromXML     : Boolean; //PR: 28/09/2012 ABSEXCH-13432|20/05/2013 ABSEXCH-11905
  end;
  PEBusCompany = ^TEBusCompany;

  TEBusFileCounters = record // Per company
    StockCounter         : longint;
    StockGrpCounter      : longint;
    TransactionCounter   : longint;
    CustomerCounter      : longint;
    EmailCounter         : longint;
    ExportLogCounter     : longint;
  end;

  TEBusImport = record // Per company
    ImportSearchDir     : string[50]; // Relative to specific company root
    ImportArchiveDir    : string[50]; // Relative to specific company root
    ImportFailDir       : string[50]; // Relative to specific company root
    ImportLogDir        : string[50]; // Relative to specific company root
  end;

  TEBusExport = record // Export job i.e. multiple jobs per company
    // Maps onto the wizard
    ExptDescription    : string[50];
    // 0 = ignore, 1 = include updated records only, 2 = include all records
    ExptStock          : byte;
    ExptStockGroups    : byte;
    ExptCustomers      : byte;
    // 0 = ignore, 1 = include
    ExptIncCurSalesTrans  : byte;      // Outstanding sales transactions (other than orders)
    ExptIncCurSalesOrders : byte;      // Outstanding sales orders
    ExptIncCurPurchTrans  : byte;      // Outstanding purchase transactions (other than orders)
    ExptIncCurPurchOrders : byte;      // Outstanding purchase orders
    ExptIncCOMPricing     : byte;      // 0 = false, 1 = complete upload, 2 = updated
    ExptIgnoreCustWebInc     : byte;   // 0 = false, 1 = true
    ExptIgnoreStockWebInc    : byte;   // 0 = false, 1 = true
    ExptIgnoreStockGrpWebInc : byte;   // 0 = false, 1 = true

    ExptCustFileName       : string[12]; // Customer Filename
    ExptStockFileName      : string[12]; // Stock Header or Standard Filename
    ExptStockLocFileName   : string[12]; // Location Lines Filename
    ExptStockGroupFileName : string[12]; // Stock Group Filename
    ExptTransFileName      : string[12]; // Transaction Header or Standard Filename
    ExptTransLinesFileName : string[12]; // Transaction Lines Filename

    ExptZipFiles          : byte;      // Zip individual files 0 = false, 1 = true
    ExptTransportType     : char;      // 'F'=FTP, 'D'=File, 'E'=Email
    ExptDataType          : char;      // 'X'=XML, 'C'=CSV, 'D'=DragNet
    ExptActive            : byte;      // 0 = inactive, 1 = active
    // 0 = never, 1 = At time 1 only, 2 = every x minutes defined by ExptFrequency,
    // 3 = as 2 but between only between time 1 and time 2
    ExptTimeType          : byte;
    ExptFrequency         : smallint;   // in minutes (smallest time interval 10 minutes?)
    ExptTime1             : TDateTime;  // Time in day OR start of frequency period
    ExptTime2             : TDateTime;  // End of frequency period if required
    ExptDaysOfWeek        : byte;       // Bit 0 = Monday ... bit 6 = Sunday
    ExptCatalogues        : string[20]; // Up to 20 catalogues to match Enterprise
    ExptCSVCustMAPFile    : string[12]; //
    ExptCSVStockMAPFile   : string[12]; //
    ExptCSVStockGrpMAPFile: string[12]; //
    ExptCSVTransMAPFile   : string[12]; //
    ExptLastExportAt      : TDateTime;  // Last time customer data exported
    ExptCustLockFile      : string[12]; // Customer lock file name 
    ExptStockLockFile     : string[12]; // Stock / Stock & location lock file name
    ExptStockGrpLockFile  : string[12]; // Stock group lock file name
    ExptTransLockFile     : string[12]; // Transaction lock file name
    ExptCustLockExt       : string[3];  // Customer lock file extension
    ExptStockLockExt      : string[3];  // Stock / Stock & location lock file extension
    ExptStockGrpLockExt   : string[3];  // Stock group lock file extension
    ExptTransLockExt      : string[3];  // Transaction lock file extension
    // Lock methods, 0 = file present as lock, 1 = file present as ready to use flag
    ExptCustLockMethod    : byte;       // Customer lock file method
    ExptStockLockMethod   : byte;       // Stock / Stock & location lock file method
    ExptStockGrpMethod    : byte;       // Stock group lock file method
    ExptTransLockMethod   : byte;       // Transaction lock file method
    ExptStockFilter       : string[16]; // allows you to start at a certain group / product in the tree
    ExptIgnoreCOMCustInc  : byte;       // 0 = false, 1 = true
    ExptIgnoreCOMStockInc : byte;       // 0 = false, 1 = true
    ExptCommandLine : string[100];      // Command line to run after export

    ExptCustAccTypeFilter : string[4];  // Allows you to filter the Customers by Account Type
    ExptCustAccTypeFilterFlag : byte;   // 0 = No Filter, 1 = Include, 2 = Exclude, 3 = Contains, 4 = doesn't Contain
    ExptStockWebFilter : string[20];    // Allows you to filter the Stock by Web Catalogue
    ExptStockWebFilterFlag : byte;      // 0 = No Filter, 1 = Include, 2 = Exclude, 3 = Contains, 4 = doesn't Contain

    {NF: Added 05/08/2004}
//    ExptUpdatedStockLocation    : byte;   // 0 = false, 1 = true
  end;

  TEBusCatalogue = record // per company
    CatTitle              : string[40];
    CatCreditLimitApplies : boolean;
    CatOnHoldApplies      : boolean;
  end;

  // TRANSPORT TYPES
  TEBusFTP = record // Per company - covers basic and upload parameters
    FTPSitePort       : longint;    // e.g. 921
    FTPSiteAddress    : string[40]; // e.g. 124.32.128.146 or intershop.freecom.net
    FTPUserName       : string[20]; //
    FTPPassword       : string[20]; //
    FTPRequestTimeOut : shortint;   // in seconds
    FTPProxyPort      : longint;
    FTPProxyAddress   : string[40];
    FTPPassiveMode    : shortint;   // 0 = false, 1 = true
    FTPRootDir        : string[50]; // Root directory for uploads if required
    FTPCustomerDir    : string[50]; // Customer directory for uploads
    FTPStockDir       : string[50]; // Stock directory for uploads
    FTPCOMPriceDir    : string[50]; // Directory for COM pricing file uploads
    FTPTransactionDir : string[50]; // Directory for transaction uploads
  end;

  TEBusEmail = record // Per company
    EmailEnabled           : boolean;
    EmailAdminAddress      : string[100]; // Administrator's email address
    // 0 = never, 1 = only exchange XML transactions, 2 = all XML transactions
    EmailNotifyAdmin       : byte;
    EmailType              : byte;        // 0 = Disabled, 1 = MAPI, 2 = SMTP
    EmailServerName        : string[40];  // e.g. ntbox or mail.mydomain.com, or 123.456.789.123
    EmailAccountName       : string[40];  // Email account receiving orders etc
    EmailAccountPassword   : string[40];  // Password for email account receiving orders etc.
    EmailNotifySender      : byte;        // 0 = no, 1 = send confirmation of receipt to sender
    EmailConfirmProcessing : byte;        // 0 = no, 1 = send copy of order document printed form
    EmailCustomerAddr      : string[100]; // Customer directory for uploads
    EmailStockAddr         : string[100]; // Stock directory for uploads
    EmailCOMPriceAddr      : string[100]; // Directory for COM pricing file uploads
    EmailTransactionAddr   : string[100]; // Directory for transaction uploads
  end;

  TEBusFile = record // Per export (excludes filenames)
    FileCustomerDir    : string[80]; // Customer path
    FileStockDir       : string[80]; // Stock path
    FileStockGroupDir  : string[80]; // Stock Group path
    FileTransDir       : string[80]; // Transaction path
    FileCOMPriceDir    : string[80]; // path for COM pricing
  end;

  // 3rd PARTY SPECIFIC
  TEBusDragNetCompany = record
    DNetCompanyCode      : char;
    DNetOrderNoStart     : longint;
    DNetOrderPrefix      : string[3];
    DNetCustExportedAt   : TDateTime;  // Standard text files
    DNetStockExportedAt  : TDateTime;  // Standard text files
    DNetLastOrderFile    : string[12]; // Name of the last order file imported
    DNetUseExternalRef   : boolean;    // True => use external trans ref as OurRef
    // DNetUseCatalogues = False => any 'include on web' stock items -> output to catalogue A
    DNetUseCatalogues    : boolean;
  end;
  PEBusDragNetCompany = ^TEBusDragNetCompany;

  TEBusDragNetCountry = record
    DNetCtryCode        : string[3];
    DNetCtryName        : string[20];
    DNetCtryTaxCode     : string[3];
    DNetCtryECMember    : boolean;
    DNetCtryHomeCountry : boolean;
  end;


  {Records for storing fields to be preserved from order to invoice. Index
    on Ent order no as Key 1 + LineNo (fullnomkeyed) as Key2.}
  TPreserveDocFields = record
    InvOrderNo         : string[10];
    InvBuyersOrder     : string[20];
    InvProjectCode     : string[20];
    InvAnalysisCode    : string[20];
    InvSuppInvoice     : string[20];
    InvBuyersDelivery  : string[20];
    InvFolio           : longint;
    InvPosted          : Boolean;
    InvPostedDate      : string[8];
  end;

  TPreserveLineFields = record
    IdAbsLineNo        : longint;
    IdLineNo           : longint;
    IdFolio            : longint;
    IdProjectCode      : string[20];
    IdAnalysisCode     : string[20];
    IdBuyersOrder      : string[20];
    IdBuyersLineRef    : string[20];
    IdOrderNo          : string[10];
    IdPDNNo            : string[10];
    IdPDNLineNo        : longint;
    IdValue            : Double;
    IDQty              : Double;
    IdOrderLineNo      : longint;
    IdStockCode        : string[16];
    IdDescription      : string[60];
    IdDiscAmount       : Double;
    IdDiscChar         : Char;
    //PR: 23/07/2009 Extra fields added for 6.01 Advanced Discounts
    IdDisc2Amount       : Double;
    IdDisc2Char         : Char;
    IdDisc3Amount       : Double;
    IdDisc3Char         : Char;
    IdDisc3Type         : Byte;
  end;

  TPreserveLineObject = Class
    Fields : TPreserveLineFields;
  end;

  TEBusRec = record
    RecPfix   : char;        // Record prefix
    SubType   : char;        // Subtype record type
    EBusCode1 : string[20];  // e.g. Enterprise Company code
    EBusCode2 : string[20];  // e.g. Catalogue code within company code
    case byte of
      1: (EBusParams     : TEBusParams);
      2: (EBusCompany    : TEBusCompany);
      3: (EBusCatalogue  : TEBusCatalogue);
      4: (EBusImport     : TEBusImport);
      5: (EBusExport     : TEBusExport);
      6: (EBusFTP        : TEBusFTP);
      7: (EBusEmail      : TEBusEmail);
      8: (EBusFile       : TEBusFile);
      9: (EBusDragNet        : TEBusDragNet);
     10: (EBusDragNetCountry : TEBusDragNetCountry);
     11: (EBusDragNetCounter : longint);
     12: (EBusRecSize        : array[1..EBUS_MAX_REC_SIZE] of char);
     13: (PreserveDoc    : TPreserveDocFields);
     14: (PreserveLine   : TPreserveLineFields);
  end;

  EBus_FileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..6] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

var
  EBusRec  : TEBusRec;
  EBusFile : EBus_FileDef;
  EventObject : ISentimailEvent;

procedure DefineEBusiness;
function MakePreserveKey1(const CompanyCode, OrderNo : string) : string;
function MakePreserveKey2(const KeyValue : string) : string;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

uses
  Dialogs, EtStrU;

function MakePreserveKey1(const CompanyCode, OrderNo : string) : string;
begin
  Result := LJVar(CompanyCode, 6) + LJVar(OrderNo, 10);
  Result := LJVar(Result, 20);
end;

function MakePreserveKey2(const KeyValue : string) : string;
begin
  Result := LJVar(KeyValue, 20);
end;

procedure CheckRecordStructureSizes;
var
  StructureName : string;

  function TooBig(RecSize : integer) : boolean;
  begin
    Result := RecSize > EBUS_MAX_REC_SIZE;
  end;

begin
  StructureName := '';
  if TooBig(Sizeof(TEBusParams)) then
    StructureName := 'TEBusParams';
  if TooBig(Sizeof(TEBusCompany)) then
    StructureName := 'TEBusCompany';
  if TooBig(Sizeof(TEBusCatalogue)) then
    StructureName := 'TEBusCatalogue';
  if TooBig(Sizeof(TEBusImport)) then
    StructureName := 'TEBusImport';
  if TooBig(Sizeof(TEBusExport)) then
    StructureName := 'TEBusExport';
  if TooBig(Sizeof(TEBusFTP)) then
    StructureName := 'TEBusFTP';
  if TooBig(Sizeof(TEBusEmail)) then
    StructureName := 'TEBusEmail';
  if TooBig(Sizeof(TEBusFile)) then
    StructureName := 'TEBusFile';
  if TooBig(Sizeof(TEBusFile)) then
    StructureName := 'TEBusFile';
  if TooBig(Sizeof(TEBusDragNet)) then
    StructureName := 'TEBusDragNet';
  if TooBig(Sizeof(TEBusDragNetCountry)) then
    StructureName := 'TEBusDragNetCountry';
  if TooBig(Sizeof(TEBusFileCounters)) then
    StructureName := 'TEBusFileCounters';

  if StructureName <> '' then
  begin
    ShowMessageFmt('%s over %d bytes !', [StructureName, EBUS_MAX_REC_SIZE]);
    Halt;
  end;
end;

procedure DefineEBusiness;
const
  Idx = EBsF;
begin
  FileSpecLen[Idx] := SizeOf(EBusFile);
  FillChar(EBusFile, FileSpecLen[Idx],0);

  with EBusFile do
  begin
    RecLen := Sizeof(EBusRec);
    PageSize := 1024; //DefPageSize;
    NumIndex := 1;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);
    // 2 chars = Code in table
    KeyBuff[1].KeyPos := 1;
    KeyBuff[1].KeyLen := 2;
    KeyBuff[1].KeyFlags := ModSeg;

    // Key 1 = string[20]
    KeyBuff[2].KeyPos := 4;
    KeyBuff[2].KeyLen := 20;
    KeyBuff[2].KeyFlags := ModSeg;

    // Key 2 = string[20]
    KeyBuff[3].KeyPos := 25;
    KeyBuff[3].KeyLen := 20;
    KeyBuff[3].KeyFlags := Modfy;

    AltColt:=UpperALT;
  end;

  FileRecLen[Idx] := Sizeof(EBusRec);
  FillChar(EBusRec,FileRecLen[Idx],0);
  RecPtr[Idx] := @EBusRec;
  FileSpecOfS[Idx] := @EBusFile;
  FileNames[Idx] := EBUS_FILENAME;
end;

initialization
  CheckRecordStructureSizes;
  DefineEBusiness;

end.


