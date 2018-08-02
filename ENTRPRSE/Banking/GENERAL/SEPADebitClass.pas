unit SEPADebitClass;

interface

uses
  BaseSEPAXMLClass, XmlConst;

type
  TSEPADebitClass = Class(TBaseSEPAXMLClass)
  protected
    function DDSequenceString(DDSeq : TDirectDebitSequence) : string;

    procedure WriteMandateInfo; virtual;
    procedure WriteCreditorSchemeInfo; virtual;
    procedure WriteSepaInfo; Virtual;
    procedure WriteTransaction; virtual;
  public
    procedure WriteXMLDocumentHeader; override;
    procedure WriteXMLPaymentInfo(DDSeq : TDirectDebitSequence; NoOfTrans : Integer; SumOfTrans : Double); override;
    procedure WriteXMLPayment(APaymentData : TPaymentData); override;
    procedure SetPaymentInfoID; override;

    constructor Create;
  end;

implementation


{ TSEPACreditClass }

constructor TSEPADebitClass.Create;
begin
  inherited;
  FPaymentMethod := 'DD';
end;

function TSEPADebitClass.DDSequenceString(
  DDSeq: TDirectDebitSequence): string;
begin
  Case DDSeq of
    ddFirst     : Result := 'FRST';
    ddRecurring : Result := 'RCUR';
    ddFinal     : Result := 'FNAL';
    ddOneOff    : Result := 'OOFF';
    else
      Result := '';
  end;
end;

procedure TSEPADebitClass.SetPaymentInfoID;
begin
  FPaymentID := GetRunNo + ' Direct Debits';
end;

procedure TSEPADebitClass.WriteCreditorSchemeInfo;
begin
 //User ID
  OpenTag(XML_CREDITOR_SCHEME_ID);
  OpenTag(XML_ID);
  OpenTag(XML_PRIVATE_ID);
  OpenTag(XML_OTHER);
  AddNode(XML_ID, FOriginatorID);

  OpenTag(XML_SCHEME_NAME);
  AddNode(XML_PROPRIETARY, 'SEPA');
  CloseTag; //Scheme name

  CloseTag; //Other
  CloseTag; //Private ID
  CloseTag; //ID
  CloseTag; //Creditor Scheme
end;


procedure TSEPADebitClass.WriteMandateInfo;
begin
  OpenTag(XML_MANDATE_RELATED_INFO);
  AddNode(XML_MANDATE_ID, PaymentData.MandateID);
  AddNode(XML_MANDATE_DATE, PaymentData.MandateDate);
  CloseTag; //XML_MANDATE_RELATED_INFO
end;

procedure TSEPADebitClass.WriteSepaInfo;
begin
  OpenTag(XML_SERVICE_LEVEL);
  AddNode(XML_CODE, 'SEPA');
  CloseTag; //service level

  OpenTag(XML_LOCAL_INSTRUMENT);
  AddNode(XML_CODE, 'CORE');
  CloseTag; //local instrument

end;

procedure TSEPADebitClass.WriteTransaction;
begin
  //MandateID & date
  WriteMandateInfo;

  //Creditor Scheme
  WriteCreditorSchemeInfo;
end;

procedure TSEPADebitClass.WriteXMLDocumentHeader;
begin
  OpenTag(XML_DEBIT_DOC_HEADER);
  OpenTag(XML_DEBIT_REF);
end;

procedure TSEPADebitClass.WriteXMLPayment(APaymentData: TPaymentData);
begin
  //Set PaymentData
  FPaymentData := APaymentData;

  //Open payment
  OpenTag(XML_DEBIT_TRANSFER_INFO);

  //EndToEndID
  WritePaymentID;

  //Amount
  WriteAmount;

  OpenTag(XML_DEBIT_TRANSACTION);

  WriteTransaction; //Mandate info + Creditor Scheme

  CloseTag; //XML_DEBIT_TRANSACTION

  //Debtor Bank (BIC)
  WriteDebtorAgent(PaymentData.BIC);

  //Debtor name and IBAN
  WriteDebtorDetails(PaymentData.Name, PaymentData.IBAN);

  //Close payment
  CloseTag; //XML_DEBIT_TRANSFER_INFO
end;

procedure TSEPADebitClass.WriteXMLPaymentInfo(DDSeq : TDirectDebitSequence; NoOfTrans : Integer; SumOfTrans : Double);
begin
  inherited;

  OpenTag(XML_PAYMENT_TYPE_INFO);
  //Service Level, etc.
  WriteSepaInfo;

  AddNode(XML_SEQUENCE_TYPE, DDSequenceString(DDSeq));
  CloseTag; //Payment Type Info

  AddNode(XML_COLLECTION_DATE, FExecutionDate);

  //Creditor name & IBAN;
  WriteCreditorDetails(FCompanyName, FCompanyIBAN);

  //Creditor name & IBAN
  WriteCreditorAgent(FCompanyBIC);

  WriteChargeBearer;

end;

end.

