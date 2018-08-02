unit SEPACreditClass;

interface

uses
  BaseSEPAXMLClass, XmlConst;

type
  TSEPACreditClass = Class(TBaseSEPAXMLClass)
  protected
    procedure WriteDebtorDetails(const AName : string; const IBAN : string); override;
    procedure WriteAmount; override;
  public
    constructor Create;
    procedure WriteXMLDocumentHeader; override;
    procedure WriteXMLPaymentInfo(DDSeq : TDirectDebitSequence; NoOfTrans : Integer; SumOfTrans : Double); override;
    procedure WriteXMLPayment(APaymentData : TPaymentData); override;
    procedure SetPaymentInfoID; override;
  end;

implementation


{ TSEPACreditClass }

constructor TSEPACreditClass.Create;
begin
  inherited;
  FPaymentMethod := 'TRF';
end;

procedure TSEPACreditClass.SetPaymentInfoID;
begin
  FPaymentID := 'BACS ' + GetRunNo;
end;

procedure TSEPACreditClass.WriteAmount;
begin
  //Base method just writes Instructed Amount - for Credit Transfers this needs
  //to be wrapped in an Amount tag.
  OpenTag(XML_AMOUNT);
  inherited;
  CloseTag;
end;

procedure TSEPACreditClass.WriteDebtorDetails(const AName : string; const IBAN : string);
begin
  OpenTag(XML_DEBTOR);
  AddNode(XML_NAME, FCompanyName);
  CloseTag;

  OpenTag(XML_DEBTOR_ACCOUNT);

  OpenTag(XML_ID);
  AddNode(XML_IBAN, FCompanyIBAN);
  CloseTag; //ID

  AddNode(XML_CURRENCY, FCurrency);
  CloseTag; //Debtor Account
end;

procedure TSEPACreditClass.WriteXMLDocumentHeader;
begin
  OpenTag(XML_PAYMENT_DOC_HEADER);
  OpenTag(XML_CREDIT_REF);
end;

procedure TSEPACreditClass.WriteXMLPayment(APaymentData: TPaymentData);
begin
  //Set PaymentData
  FPaymentData := APaymentData;

  //Open payment
  OpenTag(XML_CREDIT_TRANSFER_INFO);

  //EndToEndID
  WritePaymentID;

  //Amount
  WriteAmount;

  //Creditor BIC
  WriteCreditorAgent(PaymentData.BIC);

  //Creditor Name & IBAN
  WriteCreditorDetails(PaymentData.Name, PaymentData.IBAN);

  //Close payment
  CloseTag; //XML_CREDIT_TRANSFER_INFO
end;

procedure TSEPACreditClass.WriteXMLPaymentInfo(DDSeq: TDirectDebitSequence;
  NoOfTrans: Integer; SumOfTrans: Double);
begin
  inherited;

  //PR: 28/10/2013
  WritePaymentType;

  AddNode(XML_EXECUTION_DATE, FExecutionDate);

  //Debtor Name, IBAN and currency
  WriteDebtorDetails(FCompanyName, FCompanyIBAN);

  //Debtor Bank (BIC)
  WriteDebtorAgent(FCompanyBIC);

  WriteChargeBearer;
end;

end.
