unit VATXMLConst;

interface

const
  VAT_VENDOR_ID                  = '2441';

  VAT_IR_ENVELOPE                = 'vat:IRenvelope';
  VAT_IR_HEADER                  = 'vat:IRheader';
  VAT_KEYS                       = 'vat:Keys';
  VAT_KEY                        = 'vat:Key';
  VAT_PERIOD_ID                  = 'vat:PeriodID';

  // Optional fields, but mandatory for testing with the LTS.
  // (actually, LTS works without them using their sample valid file)
  VAT_PERIOD_START               = 'vat:PeriodStart';
  VAT_PERIOD_END                 = 'vat:PeriodEnd';
  
  VAT_IR_MARK                    = 'vat:IRmark';
  VAT_SENDER                     = 'vat:Sender';
  VAT_DECLARATION_REQUEST        = 'vat:VATDeclarationRequest';
  VAT_VAT_DUE_ON_OUTPUTS         = 'vat:VATDueOnOutputs';
  VAT_VAT_DUE_ON_EC_ACQUISITIONS = 'vat:VATDueOnECAcquisitions';
  VAT_TOTALVAT                   = 'vat:TotalVAT';
  VAT_VAT_RECLAIMED_ON_INPUTS    = 'vat:VATReclaimedOnInputs';
  VAT_NET_VAT                    = 'vat:NetVAT';
  VAT_NET_SALES_AND_OUTPUTS      = 'vat:NetSalesAndOutputs';
  VAT_NET_PURCHASES_AND_INPUTS   = 'vat:NetPurchasesAndInputs';
  VAT_NET_EC_SUPPLIES            = 'vat:NetECSupplies';
  VAT_NET_EC_ACQUISITIONS        = 'vat:NetECAcquisitions';
  VAT_REG_NUMBER                 = 'VATRegNo';
  VAT_IR_URL                     = 'http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2';
  VAT_XMLNS                      = 'xmlns:vat';

  MESSAGE_CLASS_VAT_RETURN       = 'HMRC-VAT-DEC';
  // PKR 21/10/2014. ABSEXCH-15735.  Submissions defaulting to the wrong site.
  // TIL (Test-In-Live) class added to allow test submissions to the live site.
  MESSAGE_CLASS_VAT_RETURN_TIL   = 'HMRC-VAT-DEC-TIL';
  VAT_SUBVERIFICATIONSUBJECT     = 'VAT 100 Submission Verification';
  VAT_SENT                       = 22;

  cVAT100XMLSUBFILE              = 'VAT100.xml';
  cVAT100XMLNODESUB              = 'VAT100xml';

implementation

end.
