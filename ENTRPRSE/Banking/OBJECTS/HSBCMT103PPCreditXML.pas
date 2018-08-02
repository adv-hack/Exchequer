unit HSBCMT103PPCreditXML;

//------------------------------------------------------------------------------
//HV 09/05/2018 2018-R1.1 ABSEXCH-20015: Thomas Pink - HSBC-MT103 Priority Payments (XML Foramt)
//------------------------------------------------------------------------------

interface

uses
  SEPACreditClass, XMLConst, BaseSEPAExportClass;

type
  //Descendant of SEPACreditClass to allow HSBC MY 103 PP XML Bank-specific output
  THSBCMT103PPCredit = class(TSEPACreditClass)
  protected
    procedure WriteInitiatingParty; override;
    procedure WritePaymentType; override;
    procedure WriteDebtorDetails(const AName: String; const IBAN: String); override;
    procedure WriteDebtorAgent(const BIC: String); override;
    procedure WritePaymentID; override;
    procedure WriteCreditorAgent(const BIC : string); override;
    procedure WriteCreditorDetails(const AName : string; const IBAN : string); override;
    procedure WriteAmount; override;
  public
    procedure WriteXMLGroupHeader(NoOfTrans: Integer; SumOfTrans: Double); override;
    procedure WriteXMLPaymentInfo(DDSeq: TDirectDebitSequence; NoOfTrans: Integer; SumOfTrans: Double); override;
  end;

//------------------------------------------------------------------------------

implementation

uses
  StrUtils, SysUtils, BaseSEPAXMLClass;

//------------------------------------------------------------------------------
{ THSBCMT103PPCredit }
//------------------------------------------------------------------------------

procedure THSBCMT103PPCredit.WriteAmount;
begin
  if FPaymentData.PayCcy = '£' then
    FPaymentData.PayCcy := 'GBP'
  else if FPaymentData.PayCcy = '€' then
      FPaymentData.PayCcy := 'EUR';
  OpenTag(XML_AMOUNT);
  AddNode(XML_INSTRUCTED_AMOUNT, WriteInEuros(PaymentData.Amount), XML_CURRENCY, FPaymentData.PayCcy);
  CloseTag;
end;

//------------------------------------------------------------------------------

procedure THSBCMT103PPCredit.WriteCreditorAgent(const BIC: string);
begin
  OpenTag(XML_CREDITOR_AGENT);
  OpenTag(XML_FINANCIAL_INSTITUTION_ID);
  OpenTag(XML_CLEARING_SYSTEM_MEMBER_ID);
  AddNode(XML_MEMBER_ID, BIC);                                         //Supp Bank BIC Code
  CloseTag;
  OpenTag(XML_POSTAL_ADDRESS);
  AddNode(XML_COUNTRY, FPaymentData.Country);                    //Supp. Country Code
  CloseTag; //XML_POSTAL_ADDRESS
  CloseTag; //XML_FINANCIAL_INSTITUTION_ID
  CloseTag; //XML_CREDITOR_AGENT
end;

//------------------------------------------------------------------------------

procedure THSBCMT103PPCredit.WriteCreditorDetails(const AName, IBAN: String);
begin
  OpenTag(XML_CREDITOR);
  AddNode(XML_NAME, AName);
  //Address:
  OpenTag(XML_POSTAL_ADDRESS);
  AddNode(XML_STREET, FPaymentData.Street);                 //Supplier Address line 1
  //AddNode(XML_BLDGNO, LeftStr(Trim(FPaymentData.BuildingNo), 10));  //Supplier Building Number Address line 2
  if FPaymentData.PostCode <> EmptyStr then
    AddNode(XML_POSTCODE, FPaymentData.PostCode);           //Supplier Post Code
  AddNode(XML_TOWN, FPaymentData.Town);                     //Supplier Town - Address line 4
  AddNode(XML_COUNTRY_SUBDVSN, FPaymentData.CtrySubDvsn);   //Supplier Country
  AddNode(XML_COUNTRY, FPaymentData.Country);               //Supplier Country Code 
  CloseTag; //XML_POSTAL_ADDRESS
  CloseTag; //Creditor

  OpenTag(XML_CREDITOR_ACCOUNT);
  OpenTag(XML_ID);
  OpenTag(XML_OTHER);
  AddNode(XML_ID, IBAN);
  CloseTag; //Other
  CloseTag; //ID
  CloseTag; //Creditor Account

  OpenTag(XML_REMIT_INFO);
  AddNode(XML_UNSTRUCTURED, FPaymentData.PaymentRef);    //<Ustrd> Remittance Info PPY Reference
  CloseTag; //Remit info
end;

//------------------------------------------------------------------------------

procedure THSBCMT103PPCredit.WriteDebtorAgent(const BIC: String);
begin
  OpenTag(XML_DEBTOR_AGENT);
  OpenTag(XML_FINANCIAL_INSTITUTION_ID);
  OpenTag(XML_CLEARING_SYSTEM_MEMBER_ID);
  AddNode(XML_MEMBER_ID, BIC);                                //Company or E-Banking Setup Debtor BIC Code
  CloseTag; //XML_CLEARING_SYSTEM_MEMBER_ID
  OpenTag(XML_POSTAL_ADDRESS);
  AddNode(XML_COUNTRY, FCompanyCountry);                //Company Country Code
  CloseTag; //XML_POSTAL_ADDRESS
  CloseTag; //XML_FINANCIAL_INSTITUTION_ID
  CloseTag; //XML_DEBTOR_AGENT
  WriteChargeBearer;
end;

//------------------------------------------------------------------------------

procedure THSBCMT103PPCredit.WriteDebtorDetails(const AName, IBAN: String);
begin
  OpenTag(XML_DEBTOR);
  AddNode(XML_NAME, FCompanyName);                  // DEBTOR NAME System setup, Company tab, Company Name/Address line 0
  //Comapny Address From Company Setup Tab:
  OpenTag(XML_POSTAL_ADDRESS);                      //Detials come from INI
  AddNode(XML_STREET, CommpanyAddr[1]);             //Street Name System setup, Company tab, Company Name/Address line 1
  AddNode(XML_BLDGNO, LeftStr(Trim(CommpanyAddr[2]), 10));             //Building Number System setup, Company tab, Company Name/Address line 2
  if CommpanyAddr[3] <> EmptyStr then
    AddNode(XML_POSTCODE, CommpanyAddr[3]);         //Post Code System setup, Company tab, Company Name/Address line 5
  AddNode(XML_TOWN, CommpanyAddr[4]);               //Town Name System setup, Company tab, Company Name/Address line 3
  AddNode(XML_COUNTRY_SUBDVSN, CommpanyAddr[5]);    //Country/State/Region System setup, Company tab, Company Name/Address line 4
  AddNode(XML_COUNTRY, FCompanyCountry);            //Company Country Code
  CloseTag; //XML_POSTAL_ADDRESS
  CloseTag; //XML_DEBTOR

  OpenTag(XML_DEBTOR_ACCOUNT);
  OpenTag(XML_ID);
  OpenTag(XML_OTHER);
  AddNode(XML_ID, FCompanyIBAN);                  //Company or E-Banking Setup IBAN
  CloseTag; //XML_OTHER
  CloseTag; //XML_ID
  CloseTag; //XML_DEBTOR_ACCOUNT
end;

//------------------------------------------------------------------------------

procedure THSBCMT103PPCredit.WriteInitiatingParty;
begin
  OpenTag(XML_INITIATING_PARTY);
  AddNode(XML_NAME, FCompanyName);    //Comapny Name From SetUp -> Company Tab Address Line1
  CloseTag; //XML_INITIATING_PARTY
end;

//------------------------------------------------------------------------------

procedure THSBCMT103PPCredit.WritePaymentID;
begin
  OpenTag(XML_PAYMENT_ID);
  AddNode(XML_INSTRUCTION_ID, FPaymentData.PaymentRef);     //Payment ID (eg.. PPYXXXXX)
  AddNode(XML_END_TO_END_ID, FPaymentData.Ref);             //Supp Bank Ref Up to 35 Char
  CloseTag;
end;

//------------------------------------------------------------------------------

procedure THSBCMT103PPCredit.WritePaymentType;
begin
  OpenTag(XML_PAYMENT_TYPE_INFO);
  OpenTag(XML_SERVICE_LEVEL);
  AddNode(XML_CODE, 'URGP');
  CloseTag; //XML_PAYMENT_TYPE_INFO
  CloseTag; //XML_SERVICE_LEVEL
end;

//------------------------------------------------------------------------------

procedure THSBCMT103PPCredit.WriteXMLGroupHeader(NoOfTrans: Integer; SumOfTrans: Double);
begin
  OpenTag(XML_GROUP_HEADER);

  //The group header contains MessageID, Creation Date/Time, Number of Transactions, Sum of Transactions (Header Control Sum)
  AddNode(XML_MESSAGE_ID, GetMessageID);
  AddNode(XML_CREATION_DATETIME, FormatDateTime('yyyy"-"mm"-"dd"T"hh":"nn":"ss', Now));
  AddNode(XML_NO_OF_TRANSACTIONS, NoOfTrans);
  WriteInitiatingParty;  ////Company name from Company Setup tab

  CloseTag; //XML_GROUP_HEADER
end;

//------------------------------------------------------------------------------

procedure THSBCMT103PPCredit.WriteXMLPaymentInfo(DDSeq: TDirectDebitSequence; NoOfTrans: Integer; SumOfTrans: Double);
var
  lComanyBank: String;
begin
  OpenTag(XML_PAYMENT_INFO);

  AddNode(XML_PAYMENT_INFO_ID,  OriginatorTag);     //Company Bank Ref From company Setup/ E-Banking Setup
  AddNode(XML_PAYMENT_METHOD, FPaymentMethod);      //Payment Method
  WritePaymentType;                                 //Payment Type Info
  AddNode(XML_EXECUTION_DATE, FExecutionDate);      //ReqdExctnDt
  WriteDebtorDetails(FCompanyName, FCompanyIBAN);   //Debtor Name, Address, IBAN and currency : From Company Setup Tab
  WriteDebtorAgent(FCompanyBIC);                    //Debtor Bank (BIC) and Country Code(IBAN First 2 Char) From Company Tab/EBanking Setup
end;

//------------------------------------------------------------------------------

end.
