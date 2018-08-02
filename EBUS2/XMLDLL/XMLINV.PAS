unit XMLInv;

{ prutherford440 09:53 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses                                       
  XMLBase, XMLTrans;

type
  TWriteXMLInvoice = class(TWriteXMLTransaction)
    protected
      procedure WriteSchema; override;
      procedure WriteStylesheet; override;
      procedure ProcessIntraStatHeader; override;
      procedure ProcessTransType; override;
      procedure ProcessCurrency; override;
      procedure ProcessReference; override;
      procedure ProcessDateInfo; override;
      procedure ProcessSupplierBuyer; override;
      procedure WriteInvoiceTo(InvoiceSupp : PBatchCURec); override;
      procedure ProcessDelivery; override;
      procedure ProcessTransactionLines; override;
      procedure WriteTransactionLines;
  end;

implementation

uses
  XMLOutpt, SysUtils, XmlUtil,
{$IFNDEF StandAlone}
  UseDLLU,
  VarConst,
{$ENDIF}
  XMLConst,  MathUtil, EtDateU, TransactionHelperU,
  CountryCodeUtils; //PR: 26/02/2015 ABSEXCH-15298 Settlement Discount withdrawn from 01/04/2015;

const
  BASDA_INV_SCHEMA_VERS = '3.01';
  BASDA_INV_SCHEMA_VERS_309 = '3.09';
//  BASDA_INV_SCHEMA_URL  = 'urn:www.basda.org/schema/eBIS-XML_invoice_v3.00.xml';
  BASDA_INV_SCHEMA_URL  = 'urn:schemas-basda-org:2000:salesInvoice:xdr:3.01';

  BASDA_ORD_STYLESHEET_NAME  = 'eBIS-XML_simple.xsl';
  BASDA_ORD_STYLESHEET_VERS  = '3.0';

//-----------------------------------------------------------------------------------

procedure TWriteXMLInvoice.WriteSchema;
var
  Schema : TXmlDElement;
  TransferMode, Replication : TXmlDElement;
begin
  Body := Document.CreateElement(XML_BODY);
  Root.AppendChild(Body);

  Trans := Document.CreateElement(XML_INVOICE,
    [STD_XMLNS_NAME, AddNameSpace(NAMESPACE_EXCHEQUER, STD_XMLNS_NAME)],
    [BASDA_INV_SCHEMA_URL, STD_EXCHEQUER_URN]);
  Body.AppendChild(Trans);

  TransHead := Document.CreateElement(XML_INVOICE_HEAD);
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
    Schema.AppendChild(Document.CreateElement(XML_VERSION, BASDA_INV_SCHEMA_VERS_309))
  else
    Schema.AppendChild(Document.CreateElement(XML_VERSION, BASDA_INV_SCHEMA_VERS));
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLInvoice.WriteStyleSheet;
var
  Stylesheet : TXmlDElement;
begin
  Stylesheet := Document.CreateElement(XML_STYLESHEET);
  TransHead.AppendChild(Stylesheet);
  Stylesheet.AppendChild(Document.CreateElement(XML_STYLESHEET_OWNER, STD_BASDA_NAME));
  Stylesheet.AppendChild(Document.CreateElement(XML_STYLESHEET_NAME, BASDA_ORD_STYLESHEET_NAME));
  Stylesheet.AppendChild(Document.CreateElement(XML_VERSION,   BASDA_ORD_STYLESHEET_VERS));
  Stylesheet.AppendChild(Document.CreateElement(XML_STYLESHEET_TYPE, STD_XSL_NAME));
end; // TWriteXMLInvoice.WriteStyleSheet

//-----------------------------------------------------------------------------------

procedure TWriteXMLInvoice.ProcessIntraStatHeader;
begin
  WriteIntraStat(TransHead, '', '', '');
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLInvoice.ProcessTransType;
begin
  WriteTransType(XML_INVOICE_TYPE);
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLInvoice.ProcessCurrency;
begin
  WriteCurrency(TransHead, XML_INVOICE_CURRENCY, fHeader^.Currency);
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLInvoice.ProcessReference;
begin
  WriteReference(XML_INVOICE_REFERENCE, XML_SUPPLIER_INVOICE_NO, XML_BUYER_ORDER_NO);
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLInvoice.ProcessDateInfo;
begin
  WriteDateInfo(Trans, XML_INVOICE_DATE, fHeader^.TransDate);
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLInvoice.ProcessSupplierBuyer;
begin
{$IFDEF StandAlone}
  if DocType in [SIN, SCR] then
{$ELSE}
  if DocType = SIN then
{$ENDIF}
  begin
    // Supplier
    WriteBuyerSupplierAsUs(XML_SUPPLIER, XML_SUPPLIER_REFS, XML_BUYER_CODE_SUPPLIER,
      fCustSupp^.RefNo, SysInfo^.UserName, GetAddressDetails(TAddressLines(SysInfo^.UserAddr), DefaultCountryCode(SysInfo^.CurrentCountry)));
    // Buyer
    WriteBuyerSupplierAsThem(XML_BUYER, XML_BUYER_REFS, XML_SUPPLIER_CODE_BUYER,
      fHeader^.CustCode, fCustSupp);
  end
  else
  begin // PIN - For Replication only
    // Supplier
    WriteBuyerSupplierAsThem(XML_SUPPLIER, XML_SUPPLIER_REFS, XML_BUYER_CODE_SUPPLIER,
       fHeader^.CustCode, fCustSupp);

    // Buyer
(*    WriteBuyerSupplierAsUs(XML_BUYER, BASDA_SUPPLIER_CODE_BUYER, 'Supplier''s Code for Buyer',
      fCustSupp^.RefNo, SysInfo^.UserName, BASDA_CUST_VAT_NUM,
      TAddressDetails(SysInfo^.UserAddr)); *)
  end;
end; // TWriteXMLInvoice.ProcessSupplierBuyer

//-----------------------------------------------------------------------------------

procedure TWriteXMLInvoice.WriteInvoiceTo(InvoiceSupp : PBatchCURec);
begin
  WriteBuyerSupplierAsThem(XML_INVOICE_TO, XML_INVOICE_TO_REFS,
    XML_SUPPLIER_CODE_INVOICE_TO, fCustSupp^.SOPInvCode, InvoiceSupp);
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLInvoice.ProcessDelivery;
begin
  WriteDelivery(fCustSupp^.Company, GetAddressDetails(TAddressLines(fHeader^.DAddr), fHeader^.thDeliveryCountry),
    GetAddressDetails(TAddressLines(fCustSupp^.Addr), fCustSupp^.acDeliveryCountry), fHeader^.thDeliveryPostcode);
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLInvoice.ProcessTransactionLines;
begin
  WriteTransactionLines;
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLInvoice.WriteTransactionLines;
type
  TTaxRateInfo = record
    LineCount : integer;
    Amount : double;
  end;
var
  InvoiceLine,
  Product      : TXmlDElement;
  RateIndex,
  LineCount : integer;
  LineType  : string;
  DescriptionOnly : boolean;
  TransLine : ^TBatchTLRec;
  Status : integer;
  LineTotal,
  SumLineTotal : double;
  TaxRateInfo : array[0..MAX_VAT_INDEX] of TTaxRateInfo;
  LineTotalCalcOK : boolean;

  procedure WriteIntraStatInfo;
  var
    CommodCode,
    SuppUnits,
    CountryOfDest : string;
  begin
    if fLines^[LineCount].SSDUseLine then
    begin
      CommodCode := fLines^[LineCount].SSDCommod;
      SuppUnits := FloatToStr(fLines^[LineCount].SSDSPUnit);
      CountryOfDest := fLines^[LineCount].SSDCountry;
    end
    else
    begin
      CommodCode := fStockInfo^.CommodCode;
      SuppUnits := FloatToStr(fStockInfo^.SuppSUnit);
      CountryOfDest := fStockInfo^.SSDCountry;
    end;
    WriteIntraStat(InvoiceLine, CommodCode, SuppUnits, CountryOfDest);
  end;

  procedure WriteSerialNumInfo;
  var
    SerialRec : ^TBatchSRLinesRec;
    SearchTransNo : array[0..255] of char;
    SerialInfo,
    Quantity : TXmlDElement;
    i : integer;
{$IFNDEF StandAlone}
    function SerialBatchForThisLine(Number : string; IsSerialNum : boolean) : boolean;
    var
      OneSerialRec : ^TBatchSerialRec;
    begin


      Result := false;
      if Trim(Number) <> '' then
      begin
        new(OneSerialRec);
        if IsSerialNum then
          OneSerialRec^.SerialNo := Number
        else
          OneSerialRec^.BatchNo := Number;
        Result := Ex_GetSerialBatch(OneSerialRec, SizeOf(OneSerialRec^), B_GetEq) = 0;
        if Result then
          Result := fLines^[LineCount].ABSLineNo = OneSerialRec^.SoldABSLine;
        dispose(OneSerialRec);
      end;

    end;
{$ENDIF}
  begin // WriteSerialNumInfo
{$IFNDEF StandAlone}
    new(SerialRec);
    StrPCopy(SearchTransNo, fHeader^.OurRef);
    if Ex_GetLineSerialNos(SerialRec, SizeOf(SerialRec^), SearchTransNo,
     fLines^[LineCount].ABSLineNo, 0) = 0 then
    begin
      for i := 1 to 500 do
        with SerialRec^[i] do
        begin
          if SerialBatchForThisLine(SerialNo, true) then
          begin
            SerialInfo := Document.CreateElement(XML_LOT_SERIAL);
            InvoiceLine.AppendChild(SerialInfo);
            SerialInfo.AppendChild(Document.CreateElement(XML_LOT_SERIAL_TYPE,
              [XML_CODE], [BASDA_SERIAL_NUMBER]));
            SerialInfo.AppendChild(Document.CreateElement(XML_LOT_SERIAL_NUMBER,
              Trim(SerialNo)));
          end;
          if SerialBatchForThisLine(BatchNo, false) then
          begin
            SerialInfo := Document.CreateElement(XML_LOT_SERIAL);
            InvoiceLine.AppendChild(SerialInfo);
            SerialInfo.AppendChild(Document.CreateElement(XML_LOT_SERIAL_TYPE,
              [XML_CODE], [BASDA_BATCH_NUMBER]));
            SerialInfo.AppendChild(Document.CreateElement(XML_LOT_SERIAL_NUMBER,
              Trim(BatchNo)));

            Quantity := Document.CreateElement(XML_QUANTITY, [XML_QUANT_UOM_DESC],
              [fStockInfo^.UnitS]);

            SerialInfo.AppendChild(Quantity);
            Quantity.AppendChild(Document.CreateElement(XML_AMOUNT, QuantToStr(QtyUsed)));
          end;
        end;
    end;
    dispose(SerialRec);

{$ELSE} //Standalone
    for i := 0 to fSerialCount - 1 do
    begin
      if fSerial[i].FLineNo = fLines^[LineCount].LineNo then
      begin
        if fSerial[i].FType = 0 then //SerialNo
        begin
          SerialInfo := Document.CreateElement(XML_LOT_SERIAL);
          InvoiceLine.AppendChild(SerialInfo);
          SerialInfo.AppendChild(Document.CreateElement(XML_LOT_SERIAL_TYPE,
            [XML_CODE], [BASDA_SERIAL_NUMBER]));
          SerialInfo.AppendChild(Document.CreateElement(XML_LOT_SERIAL_NUMBER,
            Trim(fSerial[i].FSerialNo)));
        end
        else
        if fSerial[i].FType = 1 then //BatchNo
        begin
          SerialInfo := Document.CreateElement(XML_LOT_SERIAL);
          InvoiceLine.AppendChild(SerialInfo);
          SerialInfo.AppendChild(Document.CreateElement(XML_LOT_SERIAL_TYPE,
            [XML_CODE], [BASDA_BATCH_NUMBER]));
          SerialInfo.AppendChild(Document.CreateElement(XML_LOT_SERIAL_NUMBER,
            Trim(fSerial[i].FBatchNo)));

          Quantity := Document.CreateElement(XML_QUANTITY, [XML_QUANT_UOM_DESC],
            [fStockInfo^.UnitS]);

          SerialInfo.AppendChild(Quantity);
          Quantity.AppendChild(Document.CreateElement(XML_AMOUNT,
           QuantToStr(fSerial[i].FQtyUsed)));
        end;
      end;
    end;
{$ENDIF}
  end; // WriteSerialNumInfo

  procedure WriteSettlementInfo;
  var
    SettleInfo,
    SettleTerms,
    SettleDiscInfo,
    Discount : TXmlDElement;

    function PayByDate : string;
    begin
      Result := DateToBASDADate(CalcDueDate(fHeader^.TransDate, fHeader^.DiscDays));
    end;

    procedure AddQualifyingTerms;
    var
      QualTerms : TXmlDElement;
    begin
      QualTerms := Document.CreateElement(XML_QUALIFYING_TERMS);
      Discount.AppendChild(QualTerms);
      QualTerms.AppendChild(Document.CreateElement(XML_PAYBY_DATE, PayByDate));
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
    //PR: 24/02/2015 ABSEXCH-15298 Settlement Discount withdrawn from 01/04/2015
    if (fHeader^.DiscDays > 0) and SettlementDiscountSupportedForDate(fHeader^.TransDate) then
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
  end; // WriteSettlementInfo

  procedure WriteTaxSubTotals;
  var
    TaxTotal : TXmlDElement;
    Rates : integer;
    SettleDiscThisRate,
    TaxableTotalThisRate : double;
  begin
    for Rates := Low(VAT_CODES) to High(VAT_CODES) do
      if TaxRateInfo[Rates].LineCount > 0 then
      begin
        TaxTotal := Document.CreateElement(XML_TAX_SUBTOTAL);
        Trans.AppendChild(TaxTotal);

        TaxTotal.AppendChild(Document.CreateElement(XML_TAX_RATE,
          FloatValToStr(GetVATRate(VAT_CODES[Rates]), 2), [XML_CODE], [VAT_CODES[Rates]]));
        TaxTotal.AppendChild(Document.CreateElement(XML_TAX_RATE_LINES,
          IntToStr(TaxRateInfo[Rates].LineCount)));
        TaxTotal.AppendChild(Document.CreateElement(XML_TAX_RATE_TOTAL,
          FloatValToStr(TaxRateInfo[Rates].Amount, 2)));
        SettleDiscThisRate := TaxRateInfo[Rates].Amount * fHeader^.DiscSetl;
        TaxTotal.AppendChild(Document.CreateElement(XML_TAX_RATE_SETTLE,
          FloatValToStr(SettleDiscThisRate, 2)));
        TaxableTotalThisRate := TaxRateInfo[Rates].Amount - SettleDiscThisRate;
        TaxTotal.AppendChild(Document.CreateElement( XML_TAX_RATE_DISC_VALUE,
          FloatValToStr(TaxableTotalThisRate, 2))); 
        TaxTotal.AppendChild(Document.CreateElement(XML_TAX_RATE_TAX_VALUE,
          FloatValToStr(fHeader^.InvVatAnal[Rates], 2)));
        TaxTotal.AppendChild(Document.CreateElement(XML_TAX_RATE_NET_PAY,
          FloatValToStr(TaxableTotalThisRate + fHeader^.InvVatAnal[Rates], 2)));
        TaxTotal.AppendChild(Document.CreateElement(XML_TAX_RATE_GROSS_PAY,
          FloatValToStr(TaxRateInfo[Rates].Amount + fHeader^.InvVatAnal[Rates], 2)));
        WriteCurrency(TaxTotal, XML_TAX_CURRENCY, fHeader^.Currency);
      end;
  end; // WriteTaxSubTotals

  procedure WriteInvoiceTotals;
  var
    InvoiceTotal : TXmlDElement;
    Rates : integer;
    TaxRateCount : integer;
  begin
    InvoiceTotal := Document.CreateElement(XML_INVOICE_TOTAL);
    Trans.AppendChild(InvoiceTotal);
    InvoiceTotal.AppendChild(Document.CreateElement(XML_NUMBER_LINES,
      IntToStr(fHeader^.LineCount)));

    TaxRateCount := 0;
    for Rates := Low(VAT_CODES) to High(VAT_CODES) do
      if TaxRateInfo[Rates].LineCount > 0 then inc(TaxRateCount);
    InvoiceTotal.AppendChild(Document.CreateElement(XML_NUMBER_TAX_RATES,
      IntToStr(TaxRateCount)));
    InvoiceTotal.AppendChild(Document.CreateElement(XML_LINE_VALUE_TOTAL,
      CostToStr(SumLineTotal)));
    InvoiceTotal.AppendChild(Document.CreateElement(XML_SETTLE_DISC_TOTAL,
      CostToStr(fHeader^.DiscSetAm)));
    InvoiceTotal.AppendChild(Document.CreateElement(XML_DISCOUNTED_TAX_TOTAL,
      CostToStr(SumLineTotal - fHeader^.DiscSetAm)));
    InvoiceTotal.AppendChild(Document.CreateElement(XML_TAX_TOTAL,
      CostToStr(fHeader^.InvVat)));
    InvoiceTotal.AppendChild(Document.CreateElement(XML_NET_PAYMENT_TOTAL,
      CostToStr(SumLineTotal - fHeader^.DiscSetAm + fHeader^.InvVat)));
    InvoiceTotal.AppendChild(Document.CreateElement(XML_GROSS_PAYMENT_TOTAL,
      CostToStr(SumLineTotal + fHeader^.InvVat)));
  end; // WriteInvoiceTotals

begin // TWriteXMLInvoice.WriteTransactionLines
  FillChar(TaxRateInfo, SizeOf(TaxRateInfo), 0);
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
      LineType := BASDA_INVOICE_LINE;
      DescriptionOnly := false;
    end;

    InvoiceLine := Document.CreateElement(XML_INVOICELINE,
      [XML_ACTION, XML_TYPE_CODE, XML_TYPE_DESC],
      [BASDA_LINE_ADD, LineType,  BASDALineTypeToDesc(LineType)]);
    Trans.AppendChild(InvoiceLine);
    InvoiceLine.AppendChild(Document.CreateElement(XML_LINE_NUMBER, IntToStr(LineCount),
      [XML_PRESERVE], ['true']));

    //PR: 02/02/2012 ABSEXCH-2748 Added call to write ExtendedLineType tag
    if not DescriptionOnly then
      WriteReferenceInfo(InvoiceLine, LineCount, XML_INVOICE_LINE_REFS)
    else
      WriteLinkToStock(InvoiceLine, LineCount, XML_INVOICE_LINE_REFS);



    Product := Document.CreateElement(XML_PRODUCT);
    InvoiceLine.AppendChild(Product);

    if not DescriptionOnly then
    begin // Product line
      if DocType = SIN then
        WriteStockCodeInfo(Product, LineCount, XML_SUPPLIERS_PRODUCT_CODE,
          XML_BUYERS_PRODUCT_CODE)
      else
        WriteStockCodeInfo(Product, LineCount, XML_BUYERS_PRODUCT_CODE,
          XML_SUPPLIERS_PRODUCT_CODE);
    end;

    Product.AppendChild(Document.CreateElement(XML_PRODUCT_DESCRIPTION, Trim(fLines^[LineCount].Desc)));

    if not DescriptionOnly then
    begin // Product line
      WritePropertiesInfo(Product, LineCount);
      WriteQuantityInfo(InvoiceLine, LineCount);
      WritePriceInfo(InvoiceLine, LineCount);
      WriteDiscountInfo(InvoiceLine, LineCount);

    {$IFNDEF StandAlone}
      new(TransLine);
      TransLine^ := fLines^[LineCount];
      Status := Ex_GetLineTotal(TransLine, SizeOf(TransLine^), true, 0.0, LineTotal);
      dispose(TransLine);
    {$ELSE}
      LineTotal := CalcLineTotal;
      Status := 0;
    {$ENDIF}

      LineTotalCalcOK := Status = 0;

      RateIndex := VATCodeToIndex(fLines^[LineCount].VATCode);
      if (RateIndex >= Low(TaxRateInfo)) and (RateIndex <= High(TaxRateInfo)) then
      begin
        Inc(TaxRateInfo[RateIndex].LineCount);
        if LineTotalCalcOK then
        begin
          TaxRateInfo[RateIndex].Amount := TaxRateInfo[RateIndex].Amount +
            LineTotal;
          SumLineTotal := SumLineTotal + LineTotal;
        end;
{$IFDEF StandAlone}
        fHeader^.InvVatAnal[RateIndex] := fHeader^.InvVatAnal[RateIndex] +
                                            fLines^[LineCount].Vat;
{$ENDIF}
      end;

      WriteLineTaxInfo(InvoiceLine, LineCount);
      if LineTotalCalcOK then
        InvoiceLine.AppendChild(Document.CreateElement(XML_LINE_TOTAL, CostToStr(LineTotal)));
      WriteSerialNumInfo;
      WriteIntraStatInfo;
    end; // Product line
  end; // for
  WriteNarrative;
  WriteSettlementInfo;
  WriteTaxSubTotals;
  WriteInvoiceTotals;
end; // TWriteXMLInvoice.WriteTransactionLines

//-----------------------------------------------------------------------------------

end.
