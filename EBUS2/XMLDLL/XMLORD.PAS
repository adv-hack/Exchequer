unit XMLOrd;

{ prutherford440 09:53 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  XMLBase, XMLTrans;

type
  TWriteXMLOrder = class(TWriteXMLTransaction)
    protected
      procedure WriteSchema; override;
      procedure WriteStylesheet; override;
      procedure ProcessTransType; override;
      procedure ProcessCurrency; override;
      procedure ProcessReference; override;
      procedure ProcessDateInfo; override;
      procedure ProcessSupplierBuyer; override;
      procedure WriteInvoiceTo(InvoiceSupp : PBatchCURec); override;
      procedure ProcessDelivery; override;
      procedure ProcessTransactionLines; override;
      procedure WriteSettlementInfo;
      procedure WriteTransactionLines;
  end;

implementation

uses
  XMLOutpt, SysUtils, XmlUtil,
{$IFNDEF StandAlone}
  UseDLLU,
   VarConst,
{$ENDIF}
  XmlConst, MathUtil,
  Dialogs, // Debugging
  TransactionHelperU, //PR: 26/02/2015 ABSEXCH-15298 Settlement Discount withdrawn from 01/04/2015;
  CountryCodeUtils;

const
  BASDA_ORD_SCHEMA_VERS = '3.01';
  BASDA_ORD_SCHEMA_VERS_309 = '3.09';
//  BASDA_ORD_SCHEMA_URL  = 'urn:www.basda.org/schema/eBIS-XML_order_v3.00.xml';
  BASDA_ORD_SCHEMA_URL  = 'urn:schemas-basda-org:2000:purchaseOrder:xdr:3.01';

  BASDA_ORD_STYLESHEET_NAME  = 'eBIS-XML_simple.xsl';
  BASDA_ORD_STYLESHEET_VERS  = '3.0';

//-----------------------------------------------------------------------------------

procedure TWriteXMLOrder.WriteSchema;
var
  Schema : TXmlDElement;
  TransferMode, Replication : TXmlDElement;
begin
  Body := Document.CreateElement(XML_BODY);
  Root.AppendChild(Body);

  Trans := Document.CreateElement(XML_ORDER,
    [STD_XMLNS_NAME, AddNameSpace(NAMESPACE_EXCHEQUER, STD_XMLNS_NAME)],
    [BASDA_ORD_SCHEMA_URL, STD_EXCHEQUER_URN]);
  Body.AppendChild(Trans);

  TransHead := Document.CreateElement(XML_ORDER_HEAD);
  Trans.AppendChild(TransHead);

  {$IFDEF StandAlone}
    if SysInfo.UseCrLimitChk then
    begin
      TransferMode := Document.CreateElement(XML_PROPRIETARY);
      Replication := Document.CreateElement(XML_ENTERPRISE, [XML_TRANSFER_MODE, XML_TRANSACTION_TYPE],
                                             [ENT_REPLICATION, DocCodes[fDocType]]);
      TransferMode.AppendChild(Replication);
      TransHead.AppendChild(TransferMode);
    end;
  {$ENDIF}

  Schema := Document.CreateElement(XML_SCHEMA);
  TransHead.AppendChild(Schema);
  if bUseBasda309 then
    Schema.AppendChild(Document.CreateElement(XML_VERSION, BASDA_ORD_SCHEMA_VERS_309))
  else
    Schema.AppendChild(Document.CreateElement(XML_VERSION, BASDA_ORD_SCHEMA_VERS));
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLOrder.WriteStyleSheet;
var
  Stylesheet : TXmlDElement;
begin
  Stylesheet := Document.CreateElement(XML_STYLESHEET);
  TransHead.AppendChild(Stylesheet);
  Stylesheet.AppendChild(Document.CreateElement(XML_STYLESHEET_OWNER, STD_BASDA_NAME));
  Stylesheet.AppendChild(Document.CreateElement(XML_STYLESHEET_NAME, BASDA_ORD_STYLESHEET_NAME));
  Stylesheet.AppendChild(Document.CreateElement(XML_VERSION,   BASDA_ORD_STYLESHEET_VERS));
  Stylesheet.AppendChild(Document.CreateElement(XML_STYLESHEET_TYPE, STD_XSL_NAME));
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLOrder.ProcessTransType;
begin
  WriteTransType(XML_ORDER_TYPE);
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLOrder.ProcessCurrency;
begin
  WriteCurrency(TransHead, XML_ORDER_CURRENCY, fHeader^.Currency);
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLOrder.ProcessReference;
begin
  WriteReference(XML_ORDER_REFERENCE, XML_BUYER_ORDER_NO);
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLOrder.ProcessDateInfo;
begin
  WriteDateInfo(Trans, XML_ORDER_DATE, fHeader^.TransDate);
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLOrder.ProcessSupplierBuyer;
begin
  if DocType = POR then
  begin
    // Supplier
    WriteBuyerSupplierAsThem(XML_SUPPLIER, XML_SUPPLIER_REFS, XML_BUYER_CODE_SUPPLIER,
      fHeader^.CustCode, fCustSupp);

    // Buyer
    WriteBuyerSupplierAsUs(XML_BUYER, XML_BUYER_REFS, XML_SUPPLIER_CODE_BUYER,
      fCustSupp^.RefNo, SysInfo^.UserName, GetAddressDetails(TAddressLines(SysInfo^.UserAddr), DefaultCountryCode(SysInfo^.CurrentCountry)));
  end
  else
  begin // SOR - For replication only
{.$IFDEF Standalone}
    // Supplier
{    WriteBuyerSupplierAsUs(XML_SUPPLIER, XML_BUYER_REFS, XML_BUYER_CODE_SUPPLIER,
       fCustSupp^.RefNo, SysInfo^.UserName,
      TAddressDetails(SysInfo^.UserAddr));}

    // Buyer
    WriteBuyerSupplierAsThem(XML_BUYER, XML_BUYER_REFS, XML_SUPPLIER_CODE_BUYER,
      fHeader^.CustCode, fCustSupp);
{.$ENDIF Standalone}
  end;
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLOrder.WriteInvoiceTo(InvoiceSupp : PBatchCURec);
begin
  WriteBuyerSupplierAsThem(XML_INVOICE_TO, XML_INVOICE_TO_REFS,
    XML_BUYER_CODE_INVOICE_TO, fCustSupp^.SOPInvCode, InvoiceSupp);
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLOrder.ProcessDelivery;
begin
  if fDocType = POR then
    WriteDelivery(SysInfo^.UserName, GetAddressDetails(TAddressLines(fHeader^.DAddr), fHeader^.thDeliveryCountry),
      GetAddressDetails(TAddressLines(SysInfo^.UserAddr), DefaultCountryCode(SysInfo^.CurrentCountry)), fHeader^.thDeliveryPostcode)
  else
  begin
  {PR 3/01/2007 Changed to output customer details for SORs. If customer delivery address populated then pass that through as default,
                otherwise pass through customer address}
    //PR: 16/10/2013 ABSEXCH-14703 Pass through header delivery postcode
    if Trim(fCustSupp^.dAddr[1]) <> '' then
      WriteDelivery(fCustSupp^.Company, GetAddressDetails(TAddressLines(fHeader^.DAddr), fHeader^.thDeliveryCountry),
        GetAddressDetails(TAddressLines(fCustSupp^.DAddr), fCustSupp^.acDeliveryCountry), fHeader^.thDeliveryPostcode)
    else
      WriteDelivery(fCustSupp^.Company, GetAddressDetails(TAddressLines(fHeader^.DAddr), fHeader^.thDeliveryCountry),
        GetAddressDetails(TAddressLines(fCustSupp^.Addr), fCustSupp^.acCountry), fHeader^.thDeliveryPostcode, fCustSupp^.acDeliveryPostcode);
  end;

end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLOrder.ProcessTransactionLines;
begin
  WriteTransactionLines;
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLOrder.WriteSettlementInfo;
// Notes : Settlement Discount information
var
  Discount : TXmlDElement;
begin
  //PR: 24/02/2015 ABSEXCH-15298 Settlement Discount withdrawn from 01/04/2015
  if not ZeroFloat(fHeader^.DiscSetl) and SettlementDiscountSupportedForDate(fHeader^.TransDate) then
  begin
    Discount := Document.CreateElement(XML_DISCOUNT_PERCENT);
    Trans.AppendChild(Discount);

    Discount.AppendChild(Document.CreateElement(XML_TYPE,
      BASDADiscountTypeToDesc(BASDA_EARLY_SETTLE_DISCOUNT),
      [XML_CODE], [BASDA_EARLY_SETTLE_DISCOUNT]));
    Discount.AppendChild(Document.CreateElement(XML_PERCENTAGE,
      FloatValToStr(fHeader^.DiscSetl * 100, 2)));
   end;
end; // WriteSettlementInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLOrder.WriteTransactionLines;
var
  // XML Tags
  OrderLine,
  Product,
  LineDelivery : TXmlDElement;

  LineCount : integer;
  LineType  : string;
  DescriptionOnly : boolean;
  TransLine : ^TBatchTLRec;
  Status : integer;
  LineTotal,
  SumLineTotal : double;

{  procedure WriteSettlementInfo;
  var
    SettleInfo,
    SettleTerms,
    SettleDiscInfo,
    Discount : TXmlDElement;

    procedure AddQualifyingTerms;
    var
      QualTerms : TXmlDElement;
    begin
      QualTerms := Document.CreateElement(XML_QUALIFYING_TERMS);
      Discount.AppendChild(QualTerms);
      QualTerms.AppendChild(Document.CreateElement(XML_DAYS_FROM_INV,
        IntToStr(fHeader^.DiscDays)));
    end;

  begin  // WriteSettlementInfo
    SettleInfo := Document.CreateElement(XML_SETTLEMENT);
    Trans.AppendChild(SettleInfo);

    // Settlement due date
    SettleTerms := Document.CreateElement(XML_SETTLEMENT_TERMS);
    SettleInfo.AppendChild(SettleTerms);
    SettleTerms.AppendChild(Document.CreateElement(XML_PAYBY_DATE,
      DateToBASDADate(fHeader^.DueDate)));

    // Settlement discount
    if fHeader^.DiscDays > 0 then
    begin
      SettleDiscInfo := Document.CreateElement(XML_SETTLEMENT_DISCOUNT);
      SettleInfo.AppendChild(SettleDiscInfo);

      Discount := Document.CreateElement(XML_DISCOUNT_PERCENT);
      SettleDiscInfo.AppendChild(Discount);
      AddQualifyingTerms;
      Discount.AppendChild(Document.CreateElement(XML_PERCENTAGE,
        FloatValToStr(fHeader^.DiscSetl * 100, 2)));

      Discount := Document.CreateElement(XML_DISCOUNT_AMOUNT);
      SettleDiscInfo.AppendChild(Discount);
      AddQualifyingTerms;
      Discount.AppendChild(Document.CreateElement(XML_AMOUNT,
        FloatValToStr(fHeader.DiscSetAm, 2)));
    end;
  end; // WriteSettlementInfo}


  procedure WriteOrderTotals;
  var
    OrderTotal : TXmlDElement;
  begin
    OrderTotal := Document.CreateElement(XML_ORDER_TOTAL);
    Trans.AppendChild(OrderTotal);

    OrderTotal.AppendChild(Document.CreateElement(XML_GOODS_VALUE,
      CostToStr(SumLineTotal)));
    OrderTotal.AppendChild(Document.CreateElement(XML_TAX_TOTAL,
      CostToStr(fHeader^.InvVat)));
    OrderTotal.AppendChild(Document.CreateElement(XML_GROSS_VALUE,
      CostToStr(SumLineTotal + fHeader^.InvVat)));
  end; // WriteOrderTotals

begin // TWriteXMLOrder.WriteTransactionLines
  SumLineTotal := 0;
  for LineCount := 1 to fHeader^.LineCount do
  begin
    fCurrentLine := LineCount;
    SetStockInfo(fLines^[LineCount].StockCode);

    if (ZeroFloat(fLines^[LineCount].Qty)) and (ZeroFloat(fLines^[LineCount].NetValue)) then
    begin // Description only line
      LineType := BASDA_DESCRIPTION;
      DescriptionOnly := true;
    end
    else
    begin
      LineType := BASDA_ORDER_LINE;
      DescriptionOnly := false;
    end;

    OrderLine := Document.CreateElement(XML_ORDERLINE,
      [XML_ACTION, XML_TYPE_CODE, XML_TYPE_DESC],
      [BASDA_LINE_ADD, LineType,  BASDALineTypeToDesc(LineType)]);
    Trans.AppendChild(OrderLine);
    OrderLine.AppendChild(Document.CreateElement(XML_LINE_NUMBER, IntToStr(LineCount),
      [XML_PRESERVE], [XML_TRUE]));

    //PR: 02/02/2012 ABSEXCH-2748 Added call to write ExtendedLineType tag
    if not DescriptionOnly then
      WriteReferenceInfo(OrderLine, LineCount, XML_ORDER_LINE_REFS)
    else
      WriteLinkToStock(OrderLine, LineCount, XML_ORDER_LINE_REFS);

    Product := Document.CreateElement(XML_PRODUCT);
    OrderLine.AppendChild(Product);

    if not DescriptionOnly then
    begin // Product line
      if DocType = POR then
        WriteStockCodeInfo(Product, LineCount, XML_BUYERS_PRODUCT_CODE,
          XML_SUPPLIERS_PRODUCT_CODE)
      else
        WriteStockCodeInfo(Product, LineCount, XML_SUPPLIERS_PRODUCT_CODE,
          XML_BUYERS_PRODUCT_CODE);
    end;

    Product.AppendChild(Document.CreateElement(XML_PRODUCT_DESCRIPTION, Trim(fLines^[LineCount].Desc)));

    if not DescriptionOnly then
    begin
      WritePropertiesInfo(Product, LineCount);
      WriteQuantityInfo(OrderLine, LineCount);
      WritePriceInfo(OrderLine, LineCount);
      WriteDiscountInfo(OrderLine, LineCount);
      WriteLineTaxInfo(OrderLine, LineCount);

    {$IFNDEF StandAlone}
      new(TransLine);
      TransLine^ := fLines^[LineCount];
      Status := Ex_GetLineTotal(TransLine, SizeOf(TransLine^), true, 0.0, LineTotal);
      dispose(TransLine);
    {$ELSE}
      LineTotal := CalcLineTotal;
      Status := 0;
    {$ENDIF}
      if Status = 0 then
      begin
        OrderLine.AppendChild(Document.CreateElement(XML_LINE_TOTAL,
          CostToStr(LineTotal)));
        SumLineTotal := SumLineTotal + LineTotal;
      end;

      LineDelivery := Document.CreateElement(XML_DELIVERY);
      OrderLine.AppendChild(LineDelivery);
      WriteDateInfo(LineDelivery, XML_LATEST_DATE, fLines^[LineCount].LineDate);
    end; // Product line
  end; // Iterate through lines

  WriteSettlementInfo;
  WriteNarrative;
  WriteOrderTotals;
end; // TWriteXMLOrder.WriteTransactionLines

//-----------------------------------------------------------------------------------


end.
