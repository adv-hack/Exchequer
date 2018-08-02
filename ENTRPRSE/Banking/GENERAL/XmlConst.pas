unit XmlConst;

interface

const
  {These constants reference the xml tags used in the SEPA format and should make the code more understandable.}
  XML_ENCODING                  = 'UTF-8';

  XML_PAYMENT_DOC_HEADER        = 'Document xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' +
                                  ' xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03"';
  XML_DEBIT_DOC_HEADER          = 'Document xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' +
                                  ' xmlns="urn:iso:std:iso:20022:tech:xsd:pain.008.001.02"';

  XML_CREDIT_REF                = 'CstmrCdtTrfInitn';
  XML_DEBIT_REF                 = 'CstmrDrctDbtInitn';

  XML_GROUP_HEADER              = 'GrpHdr';
  XML_MESSAGE_ID                = 'MsgId';
  XML_CREATION_DATETIME         = 'CreDtTm';
  XML_NO_OF_TRANSACTIONS        = 'NbOfTxs';
  XML_SUM_OF_TRANSACTIONS       = 'CtrlSum';

  XML_INITIATING_PARTY          = 'InitgPty';
  XML_ID                        = 'Id';
  XML_PRIVATE_ID                = 'PrvtId';
  XML_ORGANISATION_ID           = 'OrgId';
  XML_OTHER                     = 'Othr';

  XML_PAYMENT_INFO              = 'PmtInf';
  XML_PAYMENT_INFO_ID           = 'PmtInfId';
  XML_PAYMENT_METHOD            = 'PmtMtd';

  XML_PAYMENT_TYPE_INFO         = 'PmtTpInf';
  XML_SERVICE_LEVEL             = 'SvcLvl';
  XML_CODE                      = 'Cd';
  XML_LOCAL_INSTRUMENT          = 'LclInstrm';
  XML_SEQUENCE_TYPE             = 'SeqTp';

  XML_EXECUTION_DATE            = 'ReqdExctnDt';
  XML_DEBTOR                    = 'Dbtr';
  XML_NAME                      = 'Nm';
  XML_DEBTOR_ACCOUNT            = 'DbtrAcct';
  XML_IBAN                      = 'IBAN';
  XML_CURRENCY                  = 'Ccy';
  XML_DEBTOR_AGENT              = 'DbtrAgt';
  XML_FINANCIAL_INSTITUTION_ID  = 'FinInstnId';
  XML_BIC                       = 'BIC';

  XML_CREDITOR                  = 'Cdtr';
  XML_CREDITOR_AGENT            = 'CdtrAgt';
  XML_CREDITOR_ACCOUNT          = 'CdtrAcct';

  XML_CREDIT_TRANSFER_INFO      = 'CdtTrfTxInf';
  XML_PAYMENT_ID                = 'PmtId';
  XML_END_TO_END_ID             = 'EndToEndId';
  XML_INSTRUCTION_ID            = 'InstrId';
  XML_AMOUNT                    = 'Amt';
  XML_INSTRUCTED_AMOUNT         = 'InstdAmt';
  XML_CHARGE_BEARER             = 'ChrgBr';

  XML_COLLECTION_DATE           = 'ReqdColltnDt';
  XML_DEBIT_TRANSFER_INFO       = 'DrctDbtTxInf';
  XML_DEBIT_TRANSACTION         = 'DrctDbtTx';
  XML_MANDATE_RELATED_INFO      = 'MndtRltdInf';
  XML_MANDATE_ID                = 'MndtId';
  XML_MANDATE_DATE              = 'DtOfSgntr';

  XML_CREDITOR_SCHEME_ID        = 'CdtrSchmeId';
  XML_SCHEME_NAME               = 'SchmeNm';
  XML_PROPRIETARY               = 'Prtry';

  XML_POSTAL_ADDRESS            = 'PstlAdr';
  XML_STREET                    = 'StrtNm';
  XML_BLDGNO                    = 'BldgNb';
  XML_TOWN                      = 'TwnNm';
  XML_POSTCODE                  = 'PstCd';
  XML_ADDRESS_LINE              = 'AdrLine';
  XML_COUNTRY                   = 'Ctry';
  XML_COUNTRY_SUBDVSN           = 'CtrySubDvsn';

  XML_REMIT_INFO                = 'RmtInf';
  XML_UNSTRUCTURED              = 'Ustrd';

  XML_CLEARING_SYSTEM_ID        = 'ClrSysId';
  XML_CLEARING_SYSTEM_MEMBER_ID = 'ClrSysMmbId';
  XML_MEMBER_ID                 = 'MmbId';




type
  TDirectDebitSequence = (ddNA, ddFirst, ddRecurring, ddFinal, ddOneOff);

  PPaymentData = ^TPaymentData;
  TPaymentData = Record
    Name        : string[45];
    Amount      : Double;
    Ref         : String[35];
    BIC         : String[11];
    IBAN        : String[35];
    MandateID   : String[35];
    MandateDate : String[10];
    Street      : String[70];                                                            
    PostCode    : String[16];
    Town        : String[35];
    Country     : String[2];
    BuildingNo  : String[70];
    CtrySubDvsn : String[70];
    PaymentRef  : String[50];
    PayCcy      : String[3];
  end;



implementation

end.
