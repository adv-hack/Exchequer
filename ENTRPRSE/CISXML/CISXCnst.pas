unit CISXCnst;

interface

const
  EXCHEQUER_PRODUCT_NAME = 'Exchequer';
  EXCHEQUER_VENDOR_ID = '6033';

  // VDM: 08/03/2007 support sender type
  cIRSenderIndividual = 'Individual';
  cIRSenderCompany = 'Company';
  cIRSenderAgent = 'Agent';
  cIRSenderBureau = 'Bureau';
  cIRSenderPartnership = 'Partnership';
  cIRSenderTrust = 'Trust';
  cIRSenderGovernment = 'Government';
  cIRSenderOther = 'Other';  
  
  XMLNS = 'xmlns';
  YN_YES = 'yes';
  YN_NO = 'no';

  GOV_TALK_MESSAGE = 'GovTalkMessage';
  GOV_TALK_URL = 'http://www.govtalk.gov.uk/CM/envelope';
  GOV_TALK_HEADER = 'Header';
  GOV_TALK_ENVELOPE_VERSION = 'EnvelopeVersion';
  GOV_TALK_ENVELOPE_VERSION_VALUE = '2.0';

  MESSAGE_DETAILS = 'MessageDetails';
  MESSAGE_CLASS = 'Class';
  MESSAGE_CLASS_RETURN = 'IR-CIS-CIS300MR';
  MESSAGE_CLASS_VERIFY = 'IR-CIS-VERIFY'; //TBC
  MESSAGE_QUALIFIER = 'Qualifier';
  MESSAGE_FUNCTION = 'Function';
  MESSAGE_CORRELATION_ID = 'CorrelationID';
  MESSAGE_TRANSFORMATION = 'Transformation';
  MESSAGE_GATEWAY_TEST = 'GatewayTest';

  SENDER_DETAILS = 'SenderDetails';
  SENDER_ID_AUTHENTICATION_HEAD = 'IDAuthentication';
  SENDER_ID = 'SenderID';
  SENDER_ID_AUTHENTICATION = 'Authentication';
  SENDER_ID_METHOD = 'Method';
  SENDER_ID_ROLE = 'Role';
  SENDER_ID_VALUE = 'Value';

  GOV_TALK_DETAILS = 'GovTalkDetails';
  GOV_TALK_KEYS = 'Keys';
  GOV_TALK_KEY = 'Key';
  GOV_TALK_TYPE = 'Type';
  TAX_OFFICE_NO = 'TaxOfficeNumber';
  TAX_OFFICE_REF = 'TaxOfficeReference';

  GOV_TALK_TARGET = 'TargetDetails';
  GOV_TALK_TARGET_ORG = 'Organisation';
  GOV_TALK_TARGET_ORG_VALUE = 'IR';

  GOV_TALK_CHANNEL_ROUTING = 'ChannelRouting';
  GOV_TALK_CHANNEL = 'Channel';
  GOV_TALK_CHANNEL_URI = 'URI';
  GOV_TALK_CHANNEL_PRODUCT = 'Product';
  GOV_TALK_CHANNEL_VERSION = 'Version';

  IR_BODY = 'Body';
  IR_ENVELOPE = 'IRenvelope';
  IR_CIS_URL = 'http://www.govtalk.gov.uk/taxation/CISreturn';

  // VDM: 25/01/2007
  IR_CIS_URL_REQUEST = 'http://www.govtalk.gov.uk/taxation/CISrequest';
  //

  IR_HEADER = 'IRheader';
  IR_HEADER_PERIOD_END = 'PeriodEnd';
  IR_HEADER_CURRENCY = 'DefaultCurrency';
  IR_HEADER_MARK = 'IRmark';
  IR_HEADER_SENDER = 'Sender';

  CIS_RETURN = 'CISreturn';

  // VDM: 25/01/2007
  CIS_REQUEST = 'CISrequest';
  //

  CIS_CONTRACTOR = 'Contractor';
  CIS_CONTRACTOR_AOREF = 'AOref';
  CIS_CONTRACTOR_UTR = 'UTR';

  CIS_NIL_RETURN = 'NilReturn';

  CIS_SUBCONTRACTOR = 'Subcontractor';
  CIS_SUBCONTRACTOR_TRADINGNAME = 'TradingName';
  CIS_SUBCONTRACTOR_NAME = 'Name';

  // VDM: 02/03/2007 
  //CIS_SUBCONTRACTOR_FORENAME = 'Forename';
  CIS_SUBCONTRACTOR_FORENAME = 'Fore';

  // VDM: 02/03/2007
  //CIS_SUBCONTRACTOR_SURNAME = 'Surname';
  CIS_SUBCONTRACTOR_SURNAME = 'Sur';

  
  CIS_SUBCONTRACTOR_UNMATCHED_RATE = 'UnmatchedRate';
  CIS_SUBCONTRACTOR_UTR = 'UTR';
  CIS_SUBCONTRACTOR_CRN = 'CRN';
  CIS_SUBCONTRACTOR_NINO = 'NINO';

  // VDM: 25/01/2007
  CIS_SUBCONTRACTOR_WORKSREF = 'WorksRef';
  //

  CIS_SUBCONTRACTOR_VERIFICATION_NO = 'VerificationNumber';
  CIS_SUBCONTRACTOR_TOTAL_PAYMENTS = 'TotalPayments';
  CIS_SUBCONTRACTOR_COST_OF_MATERIALS = 'CostOfMaterials';
  CIS_SUBCONTRACTOR_TOTAL_DEDUCTED = 'TotalDeducted';
  CIS_SUBCONTRACTOR_ACTION = 'Action';
  CIS_SUBCONTRACTOR_TYPE = 'Type';
  CIS_SUBCONTRACTOR_PARTNERSHIP = 'Partnership';
  CIS_DECLARATIONS = 'Declarations';

  // VDM: 31/01/2007
  CIS_SUBCONTRACTOR_TAXTREATMENT = 'TaxTreatment';

  // VDM: 25/01/2007
  CIS_DECLARATION = 'Declaration';

  //

  CIS_DECLARATIONS_EMPLOYMENT_STATUS = 'EmploymentStatus';
  CIS_DECLARATIONS_VERIFICATION = 'Verification';
  CIS_DECLARATIONS_INFORMATION_CORRECT = 'InformationCorrect';
  CIS_DECLARATIONS_INACTIVITY = 'Inactivity';




implementation

end.
