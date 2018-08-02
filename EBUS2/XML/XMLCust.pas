unit XMLCust;

{ prutherford440 09:52 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  XMLOutpt, XMLExp, XMLUtil, EBusUtil;

{$I Exchdll.inc}
{$I Exdllbt.inc}

type
  TWriteXMLCustomer = class(TWriteXMLExport)
    private
      CustInfo : ^TBatchCURec;
      CustRoot : TXmlDElement;
      procedure WriteAddress(MainAddress : boolean; AddressDetails : TAddressLines);
      procedure WriteAccountInfo;
      procedure WriteCurrencyInfo;
      procedure WriteContactInfo;
      procedure WriteDefaultsInfo;
      procedure WriteDiscountInfo;
      procedure WriteCreditCardInfo;
      procedure WriteBankInfo;
      procedure WriteTaxInfo;
      procedure WriteCreditInfo;
      procedure WriteSettlementInfo;
      procedure WriteEnterpriseInfo;
      procedure WriteDatabaseInfo;
      procedure ProcessCustomers;
      procedure OutputCustXML;
      function  OKToWriteCustRecord : boolean;
    public
      AccTypeFilter : string;
      AccTypeFilterFlag : Byte;
      constructor Create;
      destructor  Destroy; override;
      procedure CreateXML; override;
  end;

implementation

uses
  UseDLLU, SysUtils, XMLConst, EXpUtil, CountryCodeUtils;

//-----------------------------------------------------------------------------------

procedure TWriteXMLCustomer.CreateXML;
begin
  Root := Document.CreateElement('Customers');
  Document.AppendChild(Root);
  ProcessCustomers;
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLCustomer.WriteAddress(MainAddress : boolean;
  AddressDetails : TAddressLines);
// Pre : MainAddress = true  => Address lines, PostCode and company name
//                   = false => Delivery address
var
  Address  : TXmlDElement;
  AddrLine : integer;
  TagName : string;
begin
  if MainAddress then
    TagName := XML_ADDRESS
  else
    TagName := XML_DELIVERY;
  Address := Document.CreateElement(TagName);
  CustRoot.AppendChild(Address);
  for AddrLine := 1 to 5 do
    Address.AppendChild(Document.CreateElement(XML_ADDRESSLINE, AddressDetails[AddrLine]));

  //PR: 30/08/2016 ABSEXCH-17138 Add Country code
  if MainAddress then
  begin
    Address.AppendChild(Document.CreateElement(XML_POSTCODE, CustInfo^.PostCode));
    Address.AppendChild(Document.CreateElement(XML_COUNTRY, CountryCode2ToCountryCode3(CustInfo^.acCountry)));
  end
  else //PR: 17/10/2013 ABSEXCH-14703 Add delivery postcode
  begin
    Address.AppendChild(Document.CreateElement(XML_POSTCODE, CustInfo^.acDeliveryPostCode));
    Address.AppendChild(Document.CreateElement(XML_COUNTRY, CountryCode2ToCountryCode3(CustInfo^.acDeliveryCountry)));
  end;
end; // TWriteXMLCustomer.WriteAddress

//-----------------------------------------------------------------------------------

procedure TWriteXMLCustomer.WriteAccountInfo;
var
  SupplierRefs,                 // Us
  BuyerRefs     : TXmlDElement; // Customer
begin
  with CustInfo^ do
  begin
    CustRoot.AppendChild(Document.CreateElement(XML_PARTY, Trim(CustInfo^.Company)));

    SupplierRefs := Document.CreateElement(XML_SUPPLIER_REFS);
    CustRoot.AppendChild(SupplierRefs);
    SupplierRefs.AppendChild(Document.CreateElement(XML_BUYER_CODE_SUPPLIER, RefNo));

    BuyerRefs := Document.CreateElement(XML_BUYER_REFS);
    CustRoot.AppendChild(BuyerRefs);
    BuyerRefs.AppendChild(Document.CreateElement(XML_TAX_NUMBER, Trim(VATRegNo)));
    BuyerRefs.AppendChild(Document.CreateElement(XML_SUPPLIER_CODE_BUYER, CustCode));
    BuyerRefs.AppendChild(Document.CreateElement(XML_ALT_SUPPLIER_CODE_BUYER, Trim(CustCode2)));
    BuyerRefs.AppendChild(Document.CreateElement('StatementAccountCode', Trim(RemitCode)));
  end;
end; // TWriteXMLCustomer.WriteAccountInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLCustomer.WriteContactInfo;
var
  ContactItem : TXmlDElement;
begin
  ContactItem := Document.CreateElement(XML_CONTACT);
  CustRoot.AppendChild(ContactItem);
  with CustInfo^ do
  begin
    ContactItem.AppendChild(Document.CreateElement(XML_CONTACT_NAME, Contact));
    ContactItem.AppendChild(Document.CreateElement(XML_CONTACT_DDI, Phone));
    ContactItem.AppendChild(Document.CreateElement(XML_CONTACT_DDI, Phone2));
    ContactItem.AppendChild(Document.CreateElement(XML_CONTACT_FAX, Fax));
    ContactItem.AppendChild(Document.CreateElement(XML_CONTACT_EMAIL, EmailAddr));
  end;
end; // TWriteXMLCustomer.WriteContactInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLCustomer.WriteCurrencyInfo;
// Notes : The currency value needs to be translated to an ISO code ???
var
  CurrencyInfo : TXmlDElement;
begin
  CurrencyInfo := Document.CreateElement(XML_CURRENCY, IntToStr(CustInfo^.Currency));
  CustRoot.AppendChild(CurrencyInfo);
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLCustomer.WriteDefaultsInfo;
var
  Defaults,
  GLCodes : TXmlDElement;
begin
  Defaults := Document.CreateElement(XML_DEFAULTS);
  CustRoot.AppendChild(Defaults);
  with CustInfo^ do
  begin
    Defaults.AppendChild(Document.CreateElement(XML_LOCATION, Trim(DefMLocStk)));
    Defaults.AppendChild(Document.CreateElement(XML_COST_CENTRE, Trim(CustCC)));
    Defaults.AppendChild(Document.CreateElement(XML_DEPARTMENT, Trim(DefMLocStk)));

    GLCodes := Document.CreateElement(XML_GL_CODE);
    Defaults.AppendChild(GLCodes);
    GLCodes.AppendChild(Document.CreateElement(XML_GL_SALES, IntToStr(DefCtrlNom)));
    GLCodes.AppendChild(Document.CreateElement(XML_GL_COSTOFSALES, IntToStr(DefCOSNom)));
    GLCodes.AppendChild(Document.CreateElement(XML_GL_DEFAULT, IntToStr(DefNomCode)));
  end;
end; // TWriteXMLCustomer.WriteDefaultsInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLCustomer.WriteCreditCardInfo;
var
  CreditCardInfo : TXmlDElement;
begin
  CreditCardInfo := Document.CreateElement(XML_CARD_DETAILS);
  CustRoot.AppendChild(CreditCardInfo);
  with CustInfo^ do
  begin
    CreditCardInfo.AppendChild(Document.CreateElement(XML_CARD_ISSUE_DATE, CCDSDate));
    CreditCardInfo.AppendChild(Document.CreateElement(XML_CARD_EXPIRY_DATE, CCDEDate));
    CreditCardInfo.AppendChild(Document.CreateElement(XML_CARD_NAME, CCDName));
    CreditCardInfo.AppendChild(Document.CreateElement(XML_CARD_NUMBER, CCDCardNo));
    CreditCardInfo.AppendChild(Document.CreateElement(XML_CARD_ISSUE_NUM, CCDSARef));
  end;
end; // TWriteXMLCustomer.WriteCreditCardInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLCustomer.WriteBankInfo;
var
  BankInfo : TXmlDElement;
begin
  BankInfo := Document.CreateElement(XML_BANK_DETAILS);
  CustRoot.AppendChild(BankInfo);
  with CustInfo^ do
  begin
    BankInfo.AppendChild(Document.CreateElement(XML_BANK_CODE, BankSort));
    BankInfo.AppendChild(Document.CreateElement(XML_BANK_ACCOUNT, BankAcc));
    BankInfo.AppendChild(Document.CreateElement(XML_BANK_REFERENCE, BankRef));
  end;
end; // TWriteXMLCustomer.WriteBankInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLCustomer.WriteTaxInfo;
var
  TaxInfo : TXmlDElement;
begin
  TaxInfo := Document.CreateElement(XML_TAX_INFO);
  CustRoot.AppendChild(TaxInfo);
  with CustInfo^ do
  begin
    TaxInfo.AppendChild(Document.CreateElement(XML_VAT_CODE, JustAlphaNum(VATCode)));
    TaxInfo.AppendChild(Document.CreateElement(XML_VAT_INCLUSIVE_CODE, JustAlphaNum(CVATIncFlg)));
    TaxInfo.AppendChild(Document.CreateElement('EECMember', BooleanToString(EECMember)));
  end;
end; // TWriteXMLCustomer.WriteTaxInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLCustomer.WriteCreditInfo;
var
  CreditInfo : TXmlDElement;
begin
  CreditInfo := Document.CreateElement('CreditInfo');
  CustRoot.AppendChild(CreditInfo);
  with CustInfo^ do
  begin
    CreditInfo.AppendChild(Document.CreateElement('PaymentTerms', IntToStr(PayTerms)));
    CreditInfo.AppendChild(Document.CreateElement('CreditLimit', Format('%3.4f', [CreditLimit])));
    CreditInfo.AppendChild(Document.CreateElement('WeeksOverdue', IntToStr(CreditStatus)));
    CreditInfo.AppendChild(Document.CreateElement('AccountStatus', IntToStr(AccStatus)));
  end;
end; // TWriteXMLCustomer.WriteCreditInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLCustomer.WriteSettlementInfo;
var
  Settlement,
  DiscountInfo : TXmlDElement;
begin
  Settlement := Document.CreateElement(XML_SETTLEMENT);
  CustRoot.AppendChild(Settlement);
  with CustInfo^ do
  begin
    Settlement.AppendChild(Document.CreateElement('DiscountDays', IntToStr(DefSetDDays)));
    DiscountInfo := Document.CreateElement(XML_DISCOUNT_PERCENT);
    Settlement.AppendChild(DiscountInfo);
    DiscountInfo.AppendChild(Document.CreateElement(XML_DISCOUNT_PERCENT, FloatToStr(DefSetDisc)));
  end;
end; // TWriteXMLCustomer.WriteSettlementInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLCustomer.WriteDiscountInfo;
var
  DiscountInfo : TXmlDElement;
  DiscountTag,
  DiscountType : string;
begin
  with CustInfo^ do
  begin
    if CDiscCh <> '%' then
    begin
      DiscountTag := XML_DISCOUNT_AMOUNT;
      DiscountType := XML_AMOUNT;
    end
    else
    begin
      DiscountTag := XML_DISCOUNT_PERCENT;
      DiscountType := XML_PERCENTAGE;
    end;
    DiscountInfo := Document.CreateElement(DiscountTag);
    CustRoot.AppendChild(DiscountInfo);
    DiscountInfo.AppendChild(Document.CreateElement(DiscountType, Format('%3.4f',[Discount])));
  end;
end; // TWriteXMLCustomer.WriteDiscountInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLCustomer.WriteEnterpriseInfo;
var
  ProprietaryInfo,
  EnterpriseInfo,
  UserDefinedInfo : TXmlDElement;

  procedure WriteUserDefinedField(FieldNo : integer; const Field : string);
  begin
    UserDefinedInfo.AppendChild(Document.CreateElement('Field', Field, 'Number', IntToStr(FieldNo)));
  end;

begin // TWriteXMLCustomer.WriteEnterpriseInfo
  ProprietaryInfo := Document.CreateElement(XML_PROPRIETARY);
  CustRoot.AppendChild(ProprietaryInfo);
  EnterpriseInfo := Document.CreateElement(XML_ENTERPRISE);
  ProprietaryInfo.AppendChild(EnterpriseInfo);
  with CustInfo^ do
  begin
    EnterpriseInfo.AppendChild(Document.CreateElement('AreaCode', AreaCode));
    EnterpriseInfo.AppendChild(Document.CreateElement('RepCode', RepCode));
    EnterpriseInfo.AppendChild(Document.CreateElement('DespatchAddress',
      BooleanToString(DespAddr)));
    EnterpriseInfo.AppendChild(Document.CreateElement('IncludeInStatement',
      BooleanToString(IncStat)));
    EnterpriseInfo.AppendChild(Document.CreateElement('DefaultFormNo',
      IntToStr(DefFormNo)));
    EnterpriseInfo.AppendChild(Document.CreateElement('SpecialTradeTerms',
      BooleanToString(TradTerm)));
    EnterpriseInfo.AppendChild(Document.CreateElement('Terms1', STerms[1]));
    EnterpriseInfo.AppendChild(Document.CreateElement('Terms2', STerms[2]));
    EnterpriseInfo.AppendChild(Document.CreateElement('InvoiceDeliveryMode', IntToStr(InvDMode)));
    EnterpriseInfo.AppendChild(Document.CreateElement('StatementDeliveryMode',
      IntToStr(StatDMode)));
    EnterpriseInfo.AppendChild(Document.CreateElement('AllowOnWeb', IntToStr(AllowWeb)));
    EnterpriseInfo.AppendChild(Document.CreateElement('WebLiveCatalogues', WebLiveCat));
    EnterpriseInfo.AppendChild(Document.CreateElement('WebPassword', ebusPwrd));
    EnterpriseInfo.AppendChild(Document.CreateElement('SendHTMLWithXML',
      BooleanToString(EmlSndHTML)));
    EnterpriseInfo.AppendChild(Document.CreateElement('SendEmailReader',
      BooleanToString(EmlSndRdr)));
    EnterpriseInfo.AppendChild(Document.CreateElement('PaymentType', PayType));
    EnterpriseInfo.AppendChild(Document.CreateElement('SOPInvoiceCode', Trim(SOPInvCode)));
    EnterpriseInfo.AppendChild(Document.CreateElement('SOPAutoWriteOff',
      BooleanToString(SOPAutoWOff)));
    EnterpriseInfo.AppendChild(Document.CreateElement('BookOrderVal',
      FloatToStr(BOrdVal)));
    EnterpriseInfo.AppendChild(Document.CreateElement('DirectDebitMode', IntToStr(
      DirDeb)));
    EnterpriseInfo.AppendChild(Document.CreateElement('DeliveryTerms', SSDDelTerms));
    EnterpriseInfo.AppendChild(Document.CreateElement('ModeOfTransport',
      IntToStr(SSDModeTr)));
    UserDefinedInfo := Document.CreateElement('UserDefined');
    EnterpriseInfo.AppendChild(UserDefinedInfo);
    WriteUserDefinedField(1, UserDef1);
    WriteUserDefinedField(2, UserDef2);
    WriteUserDefinedField(3, UserDef3);
    WriteUserDefinedField(4, UserDef4);
    if CDiscCh in ['A'..'H'] then
       EnterpriseInfo.AppendChild(Document.CreateElement('DiscountBand', CDiscCh));
    EnterpriseInfo.AppendChild(Document.CreateElement('PPDMode',
      IntToStr(acPPDMode)));
  end;
end; // TWriteXMLCustomer.WriteEnterpriseInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLCustomer.WriteDatabaseInfo;
var
  DatabaseInfo,
  RecordUpdated : TXmlDElement;
begin
  DatabaseInfo := Document.CreateElement(XML_DATABASE_INFO);
  CustRoot.AppendChild(DatabaseInfo);
  RecordUpdated := Document.CreateElement(XML_RECORD_UPDATED);
  DatabaseInfo.AppendChild(RecordUpdated);
  with CustInfo^ do
  begin
    RecordUpdated.AppendChild(Document.CreateElement(XML_RECORD_DATE, DateToBASDADate(LastUsed)));
    RecordUpdated.AppendChild(Document.CreateElement(XML_RECORD_TIME, TimeToBASDATime(TimeChange)));
    DatabaseInfo.AppendChild(Document.CreateElement(XML_RECORD_LAST_USER, LastOpo));
  end;
end; // TWriteXMLCustomer.WriteDatabaseInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLCustomer.OutputCustXML;
begin
  CustRoot := Document.CreateElement('Customer');
  Root.AppendChild(CustRoot);
  WriteAccountInfo;
  WriteCurrencyInfo;
  WriteAddress(true, TAddressLines(CustInfo^.Addr));
  WriteContactInfo;
  WriteAddress(false, TAddressLines(CustInfo^.DAddr));
  WriteDefaultsInfo;
  WriteDiscountInfo;
  WriteCreditCardInfo;
  WriteBankInfo;
  WriteTaxInfo;
  WriteCreditInfo;
  WriteSettlementInfo;
  WriteEnterpriseInfo;
  WriteDatabaseInfo;
end; // TWriteXMLCustomer.OutputCustXML

//-----------------------------------------------------------------------------------

function TWriteXMLCustomer.OKToWriteCustRecord;
begin
  with CustInfo^ do
  begin
    Result := OKToWriteRecord(LastUsed, TimeChange);
    if not IgnoreWebIncludeFlag then
      Result := Result and (AllowWeb > 0);

    Result := Result and CheckFilter(AccTypeFilter, RepCode, AccTypeFilterFlag);
  end;
end; // TWriteXMLCustomer.OKToWriteCustRecord

//-----------------------------------------------------------------------------------

procedure TWriteXMLCustomer.ProcessCustomers;
var
  Status : integer;
  SearchRec : array[0..255] of char;
begin
  FillChar(SearchRec, SizeOf(SearchRec), 0);
  Status := Ex_GetAccount(CustInfo, SizeOf(CustInfo^), SearchRec, 0, B_GetFirst, 1, false);
  while Status = 0 do
  begin
    if OKToWriteCustRecord then
      OutputCustXML;
    Status := Ex_GetAccount(CustInfo, SizeOf(CustInfo^), SearchRec, 0, B_GetNext, 1, false);
  end;
end; // TWriteXMLCustomer.ProcessCustomers

//-----------------------------------------------------------------------------------

constructor TWriteXMLCustomer.Create;
begin
  inherited Create;
  new(CustInfo);
end;

//-----------------------------------------------------------------------------------

destructor TWriteXMLCustomer.Destroy;
begin
  dispose(CustInfo);
  inherited Destroy;
end;

//-----------------------------------------------------------------------------------

end.
