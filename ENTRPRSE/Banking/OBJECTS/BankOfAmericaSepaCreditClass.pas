unit BankOfAmericaSepaCreditClass;

interface

uses
  SepaCreditClass, XmlConst;

type
  TBankOfAmericaSepaCreditClass = Class(TSepaCreditClass)
  protected
    procedure WriteDebtorDetails(const AName : string; const IBAN : string); override;
    procedure WriteDebtorAgent(const BIC : string); override;

    procedure WriteCreditorDetails(const AName : string; const IBAN : string); override;
    procedure WriteCreditorAgent(const BIC : string); override;

    procedure WritePaymentType; override;
    procedure WritePaymentID; override;

  end;

implementation

uses
  SysUtils;

{ TBankOfAmericaSepaCreditClass }

procedure TBankOfAmericaSepaCreditClass.WriteCreditorAgent(const BIC: string);
begin
  OpenTag(XML_CREDITOR_AGENT);
  OpenTag(XML_FINANCIAL_INSTITUTION_ID);
  AddNode(XML_BIC, BIC);

  OpenTag(XML_POSTAL_ADDRESS);
  AddNode(XML_COUNTRY, Copy(FPaymentData.IBAN, 1, 2));
  CloseTag; //XML_POSTAL_ADDRESS

  CloseTag; //Creditor Agent
  CloseTag; //Financial Inst
end;

procedure TBankOfAmericaSepaCreditClass.WriteCreditorDetails(const AName,
  IBAN: string);
begin
  OpenTag(XML_CREDITOR);
  AddNode(XML_NAME, UpperCase(AName));

  OpenTag(XML_POSTAL_ADDRESS);
  AddNode(XML_COUNTRY, Copy(FPaymentData.IBAN, 1, 2));
  CloseTag; //XML_POSTAL_ADDRESS

  CloseTag; //Creditor

  OpenTag(XML_CREDITOR_ACCOUNT);
  OpenTag(XML_ID);
  AddNode(XML_IBAN, IBAN);
  CloseTag; //ID

  AddNode(XML_CURRENCY, FCurrency);
  CloseTag; //Creditor Account
end;

procedure TBankOfAmericaSepaCreditClass.WriteDebtorAgent(const BIC: string);
begin
  //Debtor BIC
  OpenTag(XML_DEBTOR_AGENT);
  OpenTag(XML_FINANCIAL_INSTITUTION_ID);
  AddNode(XML_BIC, BIC);

  OpenTag(XML_POSTAL_ADDRESS);
  AddNode(XML_COUNTRY, Copy(FCompanyIBAN, 1, 2));
  CloseTag; //XML_POSTAL_ADDRESS

  CloseTag; //XML_FINANCIAL_INSTITUTION_ID
  CloseTag; //XML_DEBTOR_AGENT
end;

procedure TBankOfAmericaSepaCreditClass.WriteDebtorDetails(const AName,
  IBAN: string);
begin
  //Debtor Name
  OpenTag(XML_DEBTOR);
  AddNode(XML_NAME, UpperCase(AName));

  OpenTag(XML_POSTAL_ADDRESS);
  AddNode(XML_COUNTRY, Copy(IBAN, 1, 2));
  CloseTag;

  CloseTag;

  //Debtor account
  OpenTag(XML_DEBTOR_ACCOUNT);

  OpenTag(XML_ID);
  AddNode(XML_IBAN, IBAN);
  CloseTag; //ID

  AddNode(XML_CURRENCY, FCurrency);
  CloseTag; //Debtor Account
end;

procedure TBankOfAmericaSepaCreditClass.WritePaymentID;
begin
  OpenTag(XML_PAYMENT_ID);
  AddNode(XML_END_TO_END_ID, UpperCase(PaymentData.Ref));
  CloseTag;
end;

procedure TBankOfAmericaSepaCreditClass.WritePaymentType;
begin
  OpenTag(XML_PAYMENT_TYPE_INFO);

  OpenTag(XML_SERVICE_LEVEL);
  AddNode(XML_CODE, 'SEPA');
  CloseTag; //service level

  CloseTag; //Payment type
end;

end.
