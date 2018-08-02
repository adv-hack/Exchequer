unit DNBBACSCreditClass;

interface

uses
  SepaCreditClass, BaseSEPAXMLClass, XmlConst;

type
  TDNBBACSCreditClass = Class(TSepaCreditClass)
  protected
    procedure WritePaymentID; override;
    procedure WriteChargeBearer; override;
    procedure WriteCreditorDetails(const AName : string; const IBAN : string); override;
    procedure WriteCreditorAgent(const BIC : string); override;
    procedure WriteAmount; override;
    procedure WriteDebtorDetails(const AName : string; const IBAN : string); override;
  public
    procedure WriteInitiatingParty; override;
    constructor Create;
  end;

implementation

{ TDNBBACSCreditClass }

constructor TDNBBACSCreditClass.Create;
begin
  inherited;
  FCurrency := 'GBP';
end;

procedure TDNBBACSCreditClass.WriteAmount;
begin
  OpenTag(XML_AMOUNT);
  AddNode(XML_INSTRUCTED_AMOUNT, WriteInEuros(PaymentData.Amount), XML_CURRENCY, 'GBP');
  CloseTag; //Amount
  AddNode(XML_CHARGE_BEARER, 'SHAR');
end;

procedure TDNBBACSCreditClass.WriteChargeBearer;
begin
  //Do nothing
end;

procedure TDNBBACSCreditClass.WriteCreditorAgent(const BIC: string);
begin
  OpenTag(XML_CREDITOR_AGENT);
  OpenTag(XML_FINANCIAL_INSTITUTION_ID);
  OpenTag(XML_CLEARING_SYSTEM_MEMBER_ID);
  OpenTag(XML_CLEARING_SYSTEM_ID);
  AddNode(XML_CODE, 'GBDSC');
  CloseTag; //Clearing System Id
  AddNode(XML_CODE, BIC);
  CloseTag; //Clearing System Member Id
  CloseTag; //Financial Inst
  CloseTag; //Creditor Agent
end;

procedure TDNBBACSCreditClass.WriteCreditorDetails(const AName,
  IBAN: string);
begin
  OpenTag(XML_CREDITOR);

  AddNode(XML_NAME, AName);

  OpenTag(XML_POSTAL_ADDRESS);
  AddNode(XML_STREET, FPaymentData.Street);
  AddNode(XML_POSTCODE, FPaymentData.PostCode);
  AddNode(XML_TOWN, FPaymentData.Town);
  AddNode(XML_COUNTRY, FPaymentData.Country);
  CloseTag; //Postal Address
  CloseTag; //Creditor

  OpenTag(XML_CREDITOR_ACCOUNT);
  OpenTag(XML_ID);
  OpenTag(XML_OTHER);
  AddNode(XML_ID, IBAN);
  OpenTag(XML_SCHEME_NAME);
  AddNode(XML_CODE, 'BBAN');
  CloseTag; //Scheme Name
  CloseTag; //Other
  CloseTag; //ID
  CloseTag; //Creditor Account

  OpenTag(XML_REMIT_INFO);
  AddNode(XML_UNSTRUCTURED, FPaymentData.Ref);
  CloseTag; //Remit info

end;

procedure TDNBBACSCreditClass.WriteDebtorDetails(const AName,
  IBAN: string);
begin
  //Debtor Name
  OpenTag(XML_DEBTOR);
  AddNode(XML_NAME, AName);
  CloseTag;

  //Debtor Account
  OpenTag(XML_DEBTOR_ACCOUNT);
  OpenTag(XML_ID);
  AddNode(XML_IBAN, IBAN);
  CloseTag; // XML_ID
  CloseTag; //XML_DEBTOR_ACCOUNT
end;

procedure TDNBBACSCreditClass.WriteInitiatingParty;
begin
  OpenTag(XML_INITIATING_PARTY);

  AddNode(XML_NAME, FCompanyName);
  OpenTag(XML_ID);
  OpenTag(XML_ORGANISATION_ID);
  OpenTag(XML_OTHER);
  AddNode(XML_ID, FOriginatorID);
  OpenTag(XML_SCHEME_NAME);
  AddNode(XML_CODE, 'CUST');
  CloseTag; //Scheme name
  CloseTag; //Other
  CloseTag; //Org_id
  CloseTag; //Id
  CloseTag; //Initiating party
end;

procedure TDNBBACSCreditClass.WritePaymentID;
begin
  OpenTag(XML_PAYMENT_ID);
  AddNode(XML_INSTRUCTION_ID, PaymentData.Ref);
  AddNode(XML_END_TO_END_ID, PaymentData.Ref);
  CloseTag;
end;

end.
 