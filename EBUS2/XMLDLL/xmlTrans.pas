unit XmlTrans;

{ prutherford440 09:53 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  XMLOutpt, XMLBase, XMLUtil, SysUtils, Classes, EbusVar, XMLConst, //Moved XmlConst from Implementation Section
{$IFNDEF StandAlone}
   VarConst
{$ELSE}
  { VarRec2U,}
   GlobVar //PR: 18/04/2011 
{$ENDIF};

 {$I Exdllbt.inc}
 {$I Exchdll.inc}

{$IFDEF StandAlone}
  {$I T2xml.inc}
{$ENDIF}


type

  EWriteXMLTransactionError = Exception;

  TBatchLinesRec = Array[1..10000] of TBatchTLRec;

  TWriteXMLTransaction = class(TWriteXMLBase)
    private
      fOurRef : string;             // e.g. SOR001234 etc.
      fTransDesc : string;          // e.g. Purchase Order etc.
      fXSLLocation : string;
      fDataPath : string;           // path to the Enterprise multicompany data
    protected
      fDocType : DocTypes;
      fHeader       : ^TBatchTHRec;
      fLines        : ^TBatchLinesRec;
      fCustSupp     : PBatchCURec;
      fStockInfo    : ^TBatchSKRec;
      fAltStockInfo : ^TBatchSkAltRec;
    {$IFDEF StandAlone}
      fAuxLines     : T2xAuxLines;
      fCurrName     : String;
      fCurrCode     : String;
      fCalcLineTotals : Boolean;
      fNarrative    :TXmlNarrativeArray;
      fNarrativeCount : integer;
      fSerial       : TXmlSerialArray;
      fSerialCount : integer;
    {$ENDIF}
      fEntPath : string;
      fOriginalOrder : string;
      fPresLineFields : Array of TPreserveLineFields;
      fPresDocFields : TPreserveDocFields;
      Root,
      Body,
      Trans,                        // Order or Invoice
      TransHead     : TXmlDElement; // OrderHead or InvoiceHead
      fLinesSize : longint;
      fEbusAvailable : Boolean;
      procedure SetString(Index : integer; Value : string);
      procedure SetDocType(Value : DocTypes);
      procedure SetStandardFields;
      procedure ReadCustSupp;
      procedure ReadTransaction;
      procedure SetStockInfo(const StockCode : string);

      procedure ProcessBizTalkWrapper;
      procedure ProcessTransactionHeader;
      procedure WriteSchema; virtual; abstract;
      procedure WriteStylesheet; virtual; abstract;
      procedure ProcessIntraStatHeader; virtual;
      procedure WriteIntraStat(ParentTag : TXmlDElement; const CommodCode, SuppUnits,
        CountryOfDest : string);
      procedure ProcessReference; virtual; abstract;
      procedure ProcessTransType; virtual; abstract;
      procedure WriteTransType(const TagName : string);
      procedure ProcessCurrency; virtual; abstract;
      procedure WriteCurrency(ParentTag : TXmlDElement;
        const TagName : string; CurrencyNum : integer);
      procedure WriteEnterpriseHeaderInfo(ParentTag : TXmlDElement);
      procedure WriteReference(const TagName, OurRefTag : string;
        const LongYourRefTag : string = '');
      procedure ProcessDateInfo; virtual; abstract;
      function TransDiscountType : Integer;
      procedure WriteTransDiscountType(ParentTag : TXmlDElement; LineCount : integer);
      procedure WriteDateInfo(ParentTag : TXmlDElement; const TagName, Date : string);
      procedure ProcessSupplierBuyer; virtual; abstract;
      procedure ProcessInvoiceTo;
      procedure WriteInvoiceTo(InvoiceSupp : PBatchCURec); virtual; abstract;
      procedure WriteBuyerSupplierAsThem(const BuyerSupplier, BuyerSupplierReference,
        CodeOwner, TheirCode : string; LocalCustSupp : PBatchCURec);
      procedure WriteBuyerSupplierAsUs(const BuyerSupplier, BuyerSupplierReference,
        CodeOwner, OurCode, OurName : string; const OurAddress : TAddressDetails);
      procedure ProcessDelivery; virtual; abstract;
      //PR: 16/10/2013 ASEXCH-14703 Add postcode parameter
      procedure WriteDelivery(const CompName : string;
        const DelAddress, DefaultAddress : TAddressDetails; const DeliveryPostcode : string = ''; const DefaultPostcode : string = '');
      procedure WriteAddress(ParentTag : TXmlDElement; AddressDetails : TAddressDetails; const Postcode : string = '');
      procedure WriteContactInfo(ParentTag : TXmlDElement; LocalCustSupp : PBatchCURec);

      procedure ProcessTransactionLines; virtual; abstract;
      procedure WriteNarrative;
      procedure WriteQuantityInfo(ParentTag : TXmlDElement; LineCount : integer);
      procedure WriteDiscountInfo(ParentTag : TXmlDElement; LineCount : integer);
      procedure WritePriceInfo(ParentTag : TXmlDElement; LineCount : integer);
      procedure WritePropertiesInfo(ParentTag : TXmlDElement; LineCount : integer);
      procedure WriteReferenceInfo(ParentTag : TXmlDElement; LineCount : integer;
        const TagName : string);
      procedure WriteStockCodeInfo(ParentTag : TXmlDElement;
        LineCount : integer; const OurStockTag, TheirStockTag : string);
      procedure WriteLineTaxInfo(ParentTag : TXmlDElement; LineCount : integer);

      function  SetAltStockCode(StockCode, SuppCode : string) : boolean;
      function  GetStockPrice(const StockCode, CustCode : string;
                              Currency : smallint;
                              Quantity : double) : double;
      procedure GetTransactionNotes(var NoteLines : TStringArray);
      function  CalculateCheckSum : int64;
      procedure SetHeader(Value : TBatchTHRec);
      function GetHeader : TBatchTHRec;
      procedure SetLines(const Value : TBatchLinesRec);
      function GetLines : TBatchLinesRec;
    {$IFDEF StandAlone}
      function  GetVATRate(VATCode : char) : double; override;
      function CalcLineTotal : Double;
      function CalcLineDiscountValue(LineNo : Integer) : Double;
    {$ENDIF}

      //PR: 01/02/2012 Functions for maintaining KitLink ABSEXCH-2748
      procedure WriteLinkToStock(ParentTag : TXmlDElement; LineNo : Integer; const TagName : string);
      function NeedLinkToStockLine(iLink : longint) : Boolean;
    public
      constructor Create;
      destructor Destroy; override;
      function FindOriginalOrderRef(const InvRef : string) : string;
      function LoadPreserveFields(const InvRef : string) : Boolean;
      procedure CreateXML(Ref : string); virtual;
      property OurRef : string index 1 read fOurRef write SetString;
      property TransDesc : string index 2 read fTransDesc write SetString;
      property XSLLocation : string index 3 read fXSLLocation write SetString;
      property DocType : DocTypes read fDocType write SetDocType;
      property DataPath : string index 4 read fDataPath write SetString;
      property TransHeader : TBatchTHRec read GetHeader write SetHeader;
      property TransLines  : TBatchLinesRec read GetLines write SetLines;
      property CustSupp : PBatchCURec read fCustSupp write fCustSupp;
    {$IFDEF StandAlone}
      property AuxLines : t2xAuxLines read fAuxLines write fAuxLines;
      property CurrencyName : string read fCurrName write fCurrName;
      property CurrencyCode : string read fCurrCode write fCurrCode;
      property CalcLineTotals : Boolean read fCalcLineTotals write fCalcLineTotals;
      property Narrative    : TxmlNarrativeArray read fNarrative write fNarrative;
      property NarrativeCount : integer read fNarrativeCount write fNarrativeCount;
      procedure SetNarrative(len : integer);

      property SerialArray : TXmlSerialArray read fSerial write fSerial;
      property SerialCount : integer read fSerialCount write fSerialCount;

      procedure SetSerial(len : integer);
    {$ENDIF}
  end;

  //-----------------------------------------------------------------------------------

var
  bUseBasda309 : Boolean;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

uses
{$IFNDEF StandAlone}
  UseDLLU,
{$ENDIF}
 Dialogs, MathUtil, ETMiscU, FileUtil, BtrvU2, EtStrU, BtKeys1U, EbusUtil, SQLUtils,
 ExchequerRelease;

//===================================================================================

constructor TWriteXMLTransaction.Create;
begin
//  ShowMessage(IntToStr(GetHeapStatus.TotalFree div 1024));
  inherited Create;
  new(fHeader);
{$IFDEF StandAlone}
  new(fLines);
{$ELSE}
  fEntPath := IncludeTrailingBackslash(GetEnterpriseDirectory);
  fEbusAvailable := TableExists(fEntPath + 'ebus.dat');
{$ENDIF}
  new(fCustSupp);
  new(fStockInfo);
  new(fAltStockInfo);
//  ShowMessage(IntToStr(GetHeapStatus.TotalFree div 1024));
end;

//-----------------------------------------------------------------------------------

destructor TWriteXMLTransaction.Destroy;
begin
//  ShowMessage(IntToStr(GetHeapStatus.TotalFree div 1024));
  dispose(fHeader);
{$IFDEF StandAlone}
  dispose(fLines);
  finalize(fNarrative);
  finalize(fSerial);
{$ENDIF}
  dispose(fCustSupp);
  dispose(fStockInfo);
  dispose(fAltStockInfo);
  inherited Destroy;
//  ShowMessage(IntToStr(GetHeapStatus.TotalFree div 1024));
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.SetString(Index : integer; Value : string);
begin
  case Index  of
    1: fOurRef := Value;
    2: fTransDesc := Value;
    3: fXSLLocation := Value;
    4: fDataPath := Value;
  end;
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.SetDocType(Value : DocTypes);
begin
  fDocType := Value;
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.ReadTransaction;
var
  SearchRef : array[0..255] of char;
  Status : integer;
begin
{$IFNDEF StandAlone}
  StrPCopy(SearchRef, OurRef);
  Status := Ex_GetTransHed(fHeader, SizeOf(fHeader^), SearchRef, 0, B_GetEq, false);

  if Status = 0 then
  begin
    fLinesSize := fHeader^.LineCount * SizeOf(TBatchTLRec);

    if fLinesSize > 0 then
    begin
      GetMem(fLines, fLinesSize);


      Status := Ex_GetTrans(fHeader, fLines, SizeOf(fHeader^), fLinesSize, SearchRef, 0, B_GetEq, false);
    end;
  end;

  if Status = 0 then
  begin
    DocType := EntTransStrToEnum(copy(OurRef,1,3));
    if (DocType = SIN) and fEbusAvailable then
      fEbusAvailable := LoadPreserveFields(OurRef)
    else
      fEbusAvailable := False;
  end
  else
    raise EWriteXMLTransactionError.CreateFmt
      ('Could not read transaction: %s' + #13#10 + 'Status: %d', [OurRef, Status])
{$ELSE}
  //Change param passed so that standalone can use not exchequer OurRef
  DocType := EntTransStrToEnum(fHeader^.TransDocHed);
{$ENDIF not StandAlone}
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.ReadCustSupp;
var
  SearchRef : array[0..255] of char;
  Status : integer;
begin
{$IFNDEF StandAlone}
  StrPCopy(SearchRef, fHeader^.CustCode);
  Status := Ex_GetAccount(fCustSupp, SizeOf(fCustSupp^), SearchRef, 0, B_GetEq, 0, false);
  if Status <> 0 then
    raise EWriteXMLTransactionError.Create('Could not read cust/supp: ' + SearchRef);
{$ENDIF not StandAlone}
end; // TWriteXMLTransaction.ReadCustSupp

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.SetStandardFields;
begin
  TransDesc := GetTransDesc(fHeader^.TransDocHed);
end;

//-----------------------------------------------------------------------------------

function TWriteXMLTransaction.CalculateCheckSum : int64;
// Action : Calculates checksum based on following calculation ...
//          LinesTotal = Total(LineNumber * LineQuantity)
//          Factor1 = Year + (13 * Day) - (7 * LinesTotal)
//          Factor2 = Month + (17 * LineCount) + (5 * TotalValue)
//          Result = Last 5 digits of trunc(Factor1 * Factor2)
//          See BASDA EBis spec - Code Lists Appendix 2
// Post   : Returns the checksum or -1 if it could not be calculated
var
  Factor1,
  Factor2,
  LinesTotal : double;
  i,
  Year,
  Month,
  Day    : integer;
begin
  Result := -1;
  try
    with fHeader^ do
    begin
      Year := StrToInt(copy(TransDate, 1, 4));
      Month := StrToInt(copy(TransDate, 5, 2));
      Day := StrToInt(copy(TransDate, 7, 2));

      LinesTotal := 0;
      for i := 1 to LineCount do
      begin
        // The calculation needs Order/OrderLine/Quantity/Amount
        if fLines^[i].QtyMul = 1 then
          LinesTotal := LinesTotal + (i * fLines^[i].Qty)
        else
          LinesTotal := LinesTotal + (i * fLines^[i].QtyMul);

    {$IFDEF StandAlone}
        //DiscAmount := DiscAmount + CalcLineDiscountValue(i);
    {$ENDIF}
      end;

      Factor1 := Year + (13 * Day) - (7 * LinesTotal);

      Factor2 := Month + (17 * LineCount) + (5 * (InvNetVal- DiscAmount));
      Result := trunc(frac(abs(Factor1 * Factor2 / 100000)) * 100000);
    end;
  except
    // Trap any exceptions e.g. trunc can return an EInvalidOp
  end;
end;

//-----------------------------------------------------------------------------------

function TWriteXMLTransaction.GetStockPrice(const StockCode, CustCode : string;
                                              Currency : smallint;
                                              Quantity : double) : double;
var
  Status : integer;
  StockPriceRec : ^TBatchStkPriceRec;
begin
{$IFNDEF StandAlone}
  Result := 0;
  new(StockPriceRec);
  try
    StockPriceRec^.StockCode := StockCode;
    StockPriceRec^.CustCode := CustCode;
    StockPriceRec^.Currency := Currency;
    StockPriceRec^.Qty := Quantity;
    Status := Ex_CalcStockPrice(StockPriceRec, SizeOf(StockPriceRec));
    if Status = 0 then
      Result := StockPriceRec^.Price
    else
      raise EWriteXMLTransactionError.Create('Could not read stock price');
  finally
    dispose(StockPriceRec);
  end;
{$ENDIF}
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.GetTransactionNotes(var NoteLines : TStringArray);
var
  NotesRec : ^TBatchNotesRec;
  SearchKey : array[0..255] of char;
  NoteTypeRef : char;
  Status : integer;
  LineCount : integer;
begin
{$IFNDEF StandAlone}
  new(NotesRec);
  StrPCopy(SearchKey, OurRef);
  LineCount := 1;

  // '1' = General notes, '2' = dated notes
  for NoteTypeRef := '1' to '2' do
  begin
    with NotesRec^ do
    begin
      NoteSort := 'DOC';
      NoteType := NoteTypeRef;
      NoteCode := OurRef;

      Status := Ex_GetNotes(NotesRec, SizeOf(NotesRec^), SearchKey, 0, B_GetGEq, false);
      while (Status = 0) and (NotesRec^.NoteCode = OurRef) do
      begin
        SetLength(NoteLines, LineCount);
        NoteLines[LineCount-1] := NotesRec^.NoteLine;
        inc(LineCount);
        Status := Ex_GetNotes(NotesRec, SizeOf(NotesRec^), SearchKey, 0, B_GetNext,false);
      end;
    end; // with
  end; // for
  dispose(NotesRec);
{$ENDIF}
end; // TWriteXMLTransaction.GetTransactionNotes

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.SetStockInfo(const StockCode : string);
var
  Status : integer;
  SearchCode : array[0..255] of char;
begin
{$IFNDEF StandAlone}
  if Trim(StockCode) <> '' then
  begin
    StrPCopy(SearchCode, StockCode);
    Status := Ex_GetStock(fStockInfo, Sizeof(fStockInfo^), SearchCode, 0, B_GetEq, false);
    if Status <> 0 then
      raise EWriteXMLTransactionError.Create('Could not read stock code: ' + StockCode);
  end
  else
    FillChar(fStockInfo^, SizeOf(fStockInfo^), 0);
{$ELSE Standalone}
  fStockInfo^.StockCode := StockCode;
{$ENDIF StandAlone}
end;

//-----------------------------------------------------------------------------------

function TWriteXMLTransaction.SetAltStockCode(StockCode, SuppCode : string) : boolean;
// Post : Returns true if an alternative stock code was found
var
  SearchCode : array[0..255] of char;
  Status : integer;
begin
{$IFNDEF StandAlone}
  StrPCopy(SearchCode, StockCode);
  FillChar(fAltStockInfo^, SizeOf(fAltStockInfo^), 0);

  if SuppCode = '' then
    SuppCode := StringOfChar(' ', 6);
  fAltStockInfo^.AltCode := '';
  Result := false;
  Status := Ex_GetStkAlt(fAltStockInfo, SizeOf(fAltStockInfo^),
    SearchCode, 1, B_GetGEq, false);
  while (Status = 0) and (fAltStockInfo^.StockCode = StockCode) and not Result do
  begin
    Result := fAltStockInfo^.SuppCode = SuppCode;
    if not Result then
      Status := Ex_GetStkAlt(fAltStockInfo, SizeOf(fAltStockInfo^),
        SearchCode, 1, B_GetNext, false);
  end;
{$ENDIF}
end; // TWriteXMLTransaction.SetAltStockCode

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.ProcessBizTalkWrapper;
var
  Header,
  Delivery,
  BizTalkMessage,
  BizTalkTo,
  BizTalkFrom,
  BizTalkState : TXmlDElement;

  function BizTalkDateTime(DateTime : TDateTime) : string;
  begin
    Result := FormatDateTime('yyyy-mm-dd"T"hh":"mm":"ss', DateTime);
  end;

begin
  Root := Document.CreateElement(BIZTALK, [STD_XMLNS_NAME], [BIZTALK_URN]);
  Document.AppendChild(Root);

  Header := Document.CreateElement(BIZTALK_HEADER);
  Root.AppendChild(Header);

  Delivery := Document.CreateElement(BIZTALK_DELIVERY);
  Header.AppendChild(Delivery);

  BizTalkMessage := Document.CreateElement(BIZTALK_MESSAGE);
  Delivery.AppendChild(BizTalkMessage);
  BizTalkMessage.AppendChild(Document.CreateElement(BIZTALK_MESSAGE_ID));
  BizTalkMessage.AppendChild(Document.CreateElement(BIZTALK_SENT, BizTalkDateTime(Now)));
  BizTalkMessage.AppendChild(Document.CreateElement(BIZTALK_SUBJECT, fTransDesc));
  BizTalkMessage.AppendChild(Document.CreateElement(
    AddNameSpace(BIZTALK_BASDA_SENDER, NAMESPACE_BASDA), SysInfo^.UserName,
    [AddNameSpace(NAMESPACE_BASDA, STD_XMLNS_NAME)], [BIZTALK_BASDA_URN]));
  BizTalkMessage.AppendChild(Document.CreateElement(
    AddNameSpace(BIZTALK_BASDA_RECIPIENT, NAMESPACE_BASDA), Trim(fCustSupp^.Company),
    [AddNameSpace(NAMESPACE_BASDA, STD_XMLNS_NAME)], [BIZTALK_BASDA_URN]));

  BizTalkTo := Document.CreateElement(BIZTALK_TO);
  Delivery.AppendChild(BizTalkTo);
  BizTalkTo.AppendChild(Document.CreateElement(BIZTALK_ADDRESS));
  BizTalkState := Document.CreateElement(BIZTALK_STATE);
  BizTalkTo.AppendChild(BizTalkState);
  BizTalkState.AppendChild(Document.CreateElement(BIZTALK_REFERENCE_ID));
  BizTalkState.AppendChild(Document.CreateElement(BIZTALK_HANDLE));
  BizTalkState.AppendChild(Document.CreateElement(BIZTALK_PROCESS));

  BizTalkFrom := Document.CreateElement(BIZTALK_FROM);
  Delivery.AppendChild(BizTalkFrom);
  BizTalkFrom.AppendChild(Document.CreateElement(BIZTALK_ADDRESS));
  BizTalkState := Document.CreateElement(BIZTALK_STATE);
  BizTalkFrom.AppendChild(BizTalkState);
  BizTalkState.AppendChild(Document.CreateElement(BIZTALK_REFERENCE_ID));
  BizTalkState.AppendChild(Document.CreateElement(BIZTALK_HANDLE));
  BizTalkState.AppendChild(Document.CreateElement(BIZTALK_PROCESS));

  Header.AppendChild(Document.CreateElement(BIZTALK_MANIFEST));
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.ProcessTransactionHeader;
var
  Parameters,
  Software    : TXmlDElement;
begin
  WriteSchema;
  WriteStylesheet;

  Parameters := Document.CreateElement(XML_PARAMETERS);
  TransHead.AppendChild(Parameters);
  Parameters.AppendChild(Document.CreateElement(XML_LANGUAGE, STD_LANGUAGE_CODE));
  Parameters.AppendChild(Document.CreateElement(XML_DECIMAL_SEP, STD_DECIMAL_SYMBOL));
  Parameters.AppendChild(Document.CreateElement(XML_PRECISION, STD_PRECISION));

  Software := Document.CreateElement(XML_SOFTWARE);
  TransHead.AppendChild(Software);
  Software.AppendChild(Document.CreateElement(XML_SOFTWARE_MANUFAC, 'Advanced Enterprise Software Ltd'));
  Software.AppendChild(Document.CreateElement(XML_SOFTWARE_PRODUCT, 'Exchequer'));
  Software.AppendChild(Document.CreateElement(XML_SOFTWARE_VERSION, ExchequerModuleVersion(emEbusinessXMLDLL, '')));
  ProcessTransType;
  ProcessCurrency;
  ProcessIntraStatHeader;
  TransHead.AppendChild(Document.CreateElement(XML_CHECKSUM, IntToStr(CalculateCheckSum)));
end; // TWriteXMLTransaction.WriteTransmissionHeader

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.WriteEnterpriseHeaderInfo(ParentTag : TXmlDElement);
var
  Proprietary : TXmlDElement;
begin
  Proprietary := Document.CreateElement(XML_PROPRIETARY);
  ParentTag.AppendChild(Proprietary);
  Proprietary.AppendChild(Document.CreateElement(XML_ENTERPRISE,
    [XML_TRANSACTION_TYPE, XML_TRANSFER_MODE], [fHeader^.TransDocHed, ENT_EXCHANGE]));
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.WriteIntraStat(ParentTag : TXmlDElement; const CommodCode,
  SuppUnits, CountryOfDest : string);
var
  IntraStat : TXmlDElement;
begin
  IntraStat := Document.CreateElement(XML_INTRASTAT);
  ParentTag.AppendChild(IntraStat);
  IntraStat.AppendChild(Document.CreateElement(XML_INTRASTAT_COMMOD_CODE, CommodCode));
  IntraStat.AppendChild(Document.CreateElement(XML_INTRASTAT_COMMOD_DESC));
  IntraStat.AppendChild(Document.CreateElement(
    XML_INTRASTAT_NATURE_OF_TRANSACT, IntToStr(fHeader^.TransNat)));
  IntraStat.AppendChild(Document.CreateElement(XML_INTRASTAT_SUPP_UNITS, SuppUnits));
  IntraStat.AppendChild(Document.CreateElement(XML_INTRASTAT_COUNTRY_DEST, CountryOfDest));
  IntraStat.AppendChild(Document.CreateElement(XML_INTRASTAT_MODE_OF_TRANSPORT,
    IntToStr(fHeader^.TransMode)));
end; // TWriteXMLInvoice.WriteIntraStat

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.WriteTransType(const TagName : string);
var
  TransType : TXmlDElement;
begin
  TransType := Document.CreateElement(TagName, DocNames[fDocType],
    [XML_CODE], [EntTransToEBisTrans(fDocType)]);
  TransHead.AppendChild(TransType);
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.WriteCurrency(ParentTag : TXmlDElement;
  const TagName : string; CurrencyNum : integer);
var
  Currency : TXmlDElement;
  CurrencyInfo : TCurrItems;
  CurrencyName,
  EBisCurrCode : string;
begin
{$IFNDEF StandAlone}

  // This relies on the cross-reference having been set-up ...
  EntCurrToEBisCurr(DataPath, CurrencyNum, EBisCurrCode);
{$ENDIF}
  Currency := Document.CreateElement(TagName);
  ParentTag.AppendChild(Currency);

  if GetCurrencyInfo(CurrencyNum, CurrencyInfo) then
    CurrencyName := CurrencyInfo.CurrName
  else
    CurrencyName := '';
{$IFNDEF Standalone}
  Currency.AppendChild(Document.CreateElement(XML_CURRENCY, CurrencyName,
    XML_CODE, EBisCurrCode));
{$ELSE}
  Currency.AppendChild(Document.CreateElement(XML_CURRENCY, FCurrName,
    XML_CODE, FCurrCode));
{$ENDIF}
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.ProcessIntraStatHeader;
begin
  // Not always overridden -> hence not abstract
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.WriteReference(const TagName, OurRefTag : string;
  const LongYourRefTag : string = '');
var
  Reference, Target, ExtensionsTag : TXmlDElement;
  JCode, ACode, BuyerCode : string;

  //PR: 31/01/2013 ABSEXCH-12837 Added procedure to minimise repetition of code
  procedure AddExchequerString(const Value : string; Tag : string);
  begin
    if Trim(Value) <> '' then
      Target.AppendChild(Document.CreateElement(
         AddNameSpace(Tag, NAMESPACE_EXCHEQUER), Value));

  end;
begin
  Reference := Document.CreateElement(TagName);
  Trans.AppendChild(Reference);

(*  if Trim(fHeader^.YourRef) <> '' then
  begin
    Reference := Document.CreateElement(XML_REFERENCE, [XML_REFTYPE], YourRefType);
    Trans.AppendChild(Reference);
    Reference.AppendChild(Document.CreateElement(XML_REFDESC, YourRefDesc));
    Reference.AppendChild(Document.CreateElement(XML_REFCODE, fHeader^.YourRef));
  end; *)

//  if (LongYourRefTag <> '') {and (Trim(fHeader^.LongYrRef) <> '')} then
  if (LongYourRefTag <> '') {and (Trim(fHeader^.LongYrRef) <> '')} then
  begin
    if fEbusAvailable then
      BuyerCode := Trim(fPresDocFields.InvBuyersOrder)
    else
      BuyerCode := Trim(fHeader^.LongYrRef);

    if BuyerCode <> '' then
      Reference.AppendChild(Document.CreateElement(LongYourRefTag, BuyerCode,
        [XML_PRESERVE], [XML_TRUE]));
  end;

  if fEbusAvailable then
  begin
    JCode := Trim(fPresDocFields.InvProjectCode);
    ACode := Trim(fPresDocFields.InvAnalysisCode);
  end
  else
  begin
    JCode := Trim(fHeader^.DJobCode);
    ACode := Trim(fHeader^.DJobAnal);
  end;

  if JCode <> '' then
    Reference.AppendChild(Document.CreateElement(XML_PROJECT_CODE, JCode,
      [XML_PRESERVE], [XML_TRUE]));

  if ACode <> '' then
    Reference.AppendChild(Document.CreateElement(XML_PROJECT_ANALYSIS_CODE, ACode,
      [XML_PRESERVE], [XML_TRUE]));

  Reference.AppendChild(Document.CreateElement(OurRefTag, fHeader^.OurRef,
    [XML_PRESERVE], [XML_TRUE]));


  if bUseBasda309 then
  begin
    ExtensionsTag := Document.CreateElement(BASDA_EXTENSIONS);
    Target := Document.CreateElement(AddNameSpace(ENT_TRANS_EXTENSIONS, NAMESPACE_EXCHEQUER));
    Trans.AppendChild(ExtensionsTag);
    ExtensionsTag.AppendChild(Target);

    if fDocType = POR then
      Target.AppendChild(Document.CreateElement(AddNameSpace(XML_BUYER_CODE_INVOICE_TO, NAMESPACE_EXCHEQUER),
          Trim(fCustSupp^.SOPInvCode)))
    else
      Target.AppendChild(Document.CreateElement(AddNameSpace(XML_SUPPLIER_CODE_INVOICE_TO, NAMESPACE_EXCHEQUER),
          Trim(fCustSupp^.SOPInvCode)));
  end
  else
    Target := Reference;

  //PR: 31/01/2013 ABSEXCH-12837 Add UDFs 5-10, plus change to use new AddExchequerString procedure.

  //PR: 24/7/02 - Allow output only of yourref for Exchequer Ireland
  AddExchequerString(fHeader^.YourRef,   ENT_YOURREF);

  //Add user def fields for cougar  - can't use field 1 because we already use it
  //PR: 24/7/02 - Allow output only of udf1 for Exchequer Ireland
  AddExchequerString(fHeader^.DocUser1,  ENT_HEADUSER1);
  AddExchequerString(fHeader^.DocUser2,  ENT_HEADUSER2);
  AddExchequerString(fHeader^.DocUser3,  ENT_HEADUSER3);
  AddExchequerString(fHeader^.DocUser4,  ENT_HEADUSER4);

  //PR: 31/01/2013 ABSEXCH-12837 Add UDFs 5-10
  AddExchequerString(fHeader^.DocUser5,  ENT_HEADUSER5);
  AddExchequerString(fHeader^.DocUser6,  ENT_HEADUSER6);
  AddExchequerString(fHeader^.DocUser7,  ENT_HEADUSER7);
  AddExchequerString(fHeader^.DocUser8,  ENT_HEADUSER8);
  AddExchequerString(fHeader^.DocUser9,  ENT_HEADUSER9);
  AddExchequerString(fHeader^.DocUser10, ENT_HEADUSER10);

  AddExchequerString(IntToStr(fHeader^.Tagged), ENT_TAGNO);
end; // TWriteXMLTransaction.WriteReference

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.WriteDateInfo(ParentTag : TXmlDElement;
  const TagName, Date : string);
var
  DateInfo : TXmlDElement;
begin
  DateInfo := Document.CreateElement(TagName, DateToBASDADate(Date));
  ParentTag.AppendChild(DateInfo);
end; // TWriteXMLTransaction.WriteOrderHeader

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.WriteBuyerSupplierAsThem(
  const BuyerSupplier, BuyerSupplierReference, CodeOwner, TheirCode : string;
  LocalCustSupp : PBatchCURec);
var
  BuySup,
  BuySupRef : TXmlDElement;
begin
  BuySup := Document.CreateElement(BuyerSupplier);
  Trans.AppendChild(BuySup);

  BuySupRef := Document.CreateElement(BuyerSupplierReference);
  BuySup.AppendChild(BuySupRef);

  if (CodeOwner = XML_BUYER_CODE_INVOICE_TO) or (CodeOwner = XML_SUPPLIER_CODE_INVOICE_TO) then
  begin
    if not bUseBasda309 then
      BuySupRef.AppendChild(Document.CreateElement(AddNameSpace(CodeOwner, NAMESPACE_EXCHEQUER),
        Trim(TheirCode)));
    if (CodeOwner = XML_SUPPLIER_CODE_INVOICE_TO) then
      BuySupRef.AppendChild(Document.CreateElement(CodeOwner, Trim(TheirCode)));
  end
  else
    BuySupRef.AppendChild(Document.CreateElement(CodeOwner, Trim(TheirCode)));
  BuySup.AppendChild(Document.CreateElement(XML_PARTY, Trim(LocalCustSupp^.Company)));
  WriteAddress(BuySup, GetAddressDetails(TAddressLines(LocalCustSupp^.Addr), LocalCustSupp^.acCountry));
  WriteContactInfo(BuySup, LocalCustSupp);
//  WriteTransDiscountType(BuySup);
end; // WriteBuyerSupplierAsThem

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.WriteBuyerSupplierAsUs(
  const BuyerSupplier, BuyerSupplierReference, CodeOwner, OurCode, OurName : string;
  const OurAddress : TAddressDetails);
var
  BuySup,
  BuySupRef : TXmlDElement;
begin
  BuySup := Document.CreateElement(BuyerSupplier);
  Trans.AppendChild(BuySup);

  BuySupRef := Document.CreateElement(BuyerSupplierReference);
  BuySup.AppendChild(BuySupRef);
  BuySupRef.AppendChild(Document.CreateElement(CodeOwner, Trim(OurCode)));
  if Trim(SysInfo^.UserVATReg) <> '' then
    BuySupRef.AppendChild(Document.CreateElement(XML_TAX_NUMBER, SysInfo^.UserVATReg));

  BuySup.AppendChild(Document.CreateElement(XML_PARTY, Trim(OurName)));
  WriteAddress(BuySup, OurAddress);
end; // TWriteXMLTransaction.WriteBuyerSupplierAsUs

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.ProcessInvoiceTo;
var
  InvoiceSupp : PBatchCURec;
  SearchRef : array[0..255] of char;
begin
{$IFNDEF StandAlone}

  if Trim(fCustSupp^.SOPInvCode) <> '' then
  begin
    new(InvoiceSupp);
    StrPCopy(SearchRef, fCustSupp^.SOPInvCode);
    if Ex_GetAccount(InvoiceSupp, SizeOf(InvoiceSupp^), SearchRef, 0,
      B_GetEq, 0, false) = 0 then
        WriteInvoiceTo(InvoiceSupp)
    else
    begin
      fCustSupp.SOPInvCode := fCustSupp.CustCode;
      WriteInvoiceTo(fCustSupp);
    end;
    dispose(InvoiceSupp);
  end
  else
  begin
    fCustSupp.SOPInvCode := fCustSupp.CustCode;
    WriteInvoiceTo(fCustSupp);
  end;
{$ENDIF}
end; // TWriteXMLOrder.ProcessInvoiceTo

//-----------------------------------------------------------------------------------
//PR: 16/10/2013 ASEXCH-14703 Add postcode parameter
procedure TWriteXMLTransaction.WriteAddress(ParentTag : TXmlDElement; AddressDetails : TAddressDetails; const Postcode : string = '');
var
  Address : TXmlDElement;
  AddrLine : integer;
begin
  Address := Document.CreateElement(XML_ADDRESS);
  ParentTag.AppendChild(Address);

  for AddrLine := 1 to 5 do
    if AddressDetails.Lines[AddrLine] <> '' then
      Address.AppendChild(Document.CreateElement(XML_ADDRESSLINE, AddressDetails.Lines[AddrLine]));

  //PR: 16/10/2013 ASEXCH-14703 Write postcode if populated
  if Postcode <> '' then
    Address.AppendChild(Document.CreateElement(XML_POSTCODE, Postcode));

  if Trim(AddressDetails.CountryCode) <> '' then
    Address.AppendChild(Document.CreateElement(XML_COUNTRY, AddressDetails.CountryName, [XML_CODE], [AddressDetails.CountryCode]));
end; // TWriteXMLTransaction.WriteAddress

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.WriteContactInfo(ParentTag : TXmlDElement;
  LocalCustSupp : PBatchCURec);
var
  ContactTag : TXmlDElement;
begin
  with LocalCustSupp^ do
    if Trim(Contact) <> '' then
    begin
      ContactTag := Document.CreateElement(XML_CONTACT);
      ParentTag.AppendChild(ContactTag);

      ContactTag.AppendChild(Document.CreateElement(XML_CONTACT_NAME, Trim(Contact)));
      if Trim(Phone) <> '' then
        ContactTag.AppendChild(Document.CreateElement(XML_CONTACT_DDI, Trim(Phone)));
      if Trim(Phone2) <> '' then //PR 12/09/03 - changed ddi to mobile to conform to ebis spec
        ContactTag.AppendChild(Document.CreateElement(XML_CONTACT_MOBILE, Trim(Phone2)));
      if Trim(Fax) <> '' then
        ContactTag.AppendChild(Document.CreateElement(XML_CONTACT_FAX, Trim(Fax)));
    end;
end; // TWriteXMLTransaction.WriteContactInfo

//-----------------------------------------------------------------------------------
//PR: 16/10/2013 ASEXCH-14703 Add postcode parameter
procedure TWriteXMLTransaction.WriteDelivery(const CompName : string;
  const DelAddress, DefaultAddress : TAddressDetails; const DeliveryPostcode : string = ''; const DefaultPostcode : string = '');
var
  AddrLine : integer;
  DelAddressFilled : boolean;
  Delivery,
  DeliverTo : TXmlDElement;
begin
  DelAddressFilled := false;
  for AddrLine := 1 to 5 do
    DelAddressFilled := DelAddressFilled or (DelAddress.Lines[AddrLine] <> '');

  Delivery := Document.CreateElement(XML_DELIVERY);
  Trans.AppendChild(Delivery);
  DeliverTo := Document.CreateElement(XML_DELIVER_TO);
  Delivery.AppendChild(DeliverTo);
  DeliverTo.AppendChild(Document.CreateElement(XML_PARTY, Trim(CompName)));

  //PR: 16/10/2013 ASEXCH-14703 Include postcode for delivery address
  if DelAddressFilled then
    WriteAddress(DeliverTo, DelAddress, DeliveryPostcode)
  else
    WriteAddress(DeliverTo, DefaultAddress, DefaultPostcode);

  WriteDateInfo(Delivery, XML_LATEST_DATE, fHeader^.DueDate);
end; // WriteDelAddress

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.WriteNarrative;
var
  i : integer;
  NoteLines : TStringArray;
  Narrative : TXmlDElement;
begin
{$IFNDEF StandAlone}
  GetTransactionNotes(NoteLines);
  for i := Low(NoteLines) to High(NoteLines) do
  begin
    Narrative := Document.CreateElement(XML_NARRATIVE, NoteLines[i]);
    Trans.AppendChild(Narrative);
  end;
{$ELSE}
  for i := 0 to fNarrativeCount - 1 do
  begin
    Narrative := Document.CreateElement(XML_NARRATIVE, fNarrative[i].Text);
    Trans.AppendChild(Narrative);
  end;
{$ENDIF}
end; // TWriteXMLTransaction.WriteNarrative

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.WriteQuantityInfo(ParentTag : TXmlDElement;
  LineCount : integer);
// Notes : Quantity information within a transaction line
var
  Quantity : TXmlDElement;
begin
  // Ignored UOMCode as would have to convert free text UnitP field into
  // a specific attribute value.  Spec says attribute is not required

{$IFNDEF StandAlone}
  Quantity := Document.CreateElement(XML_QUANTITY, [XML_QUANT_UOM_DESC], [fStockInfo^.UnitP]);
{$ELSE}
  Quantity := Document.CreateElement(XML_QUANTITY, [XML_QUANT_UOM_DESC],
                  [fAuxLines[fCurrentLine]^.axUOMQuantDesc]);
{$ENDIF}
  ParentTag.AppendChild(Quantity);
  Quantity.AppendChild(Document.CreateElement(XML_QUANT_PACKSIZE,
    QuantToStr(fLines^[LineCount].QtyMul)));
  Quantity.AppendChild(Document.CreateElement(XML_AMOUNT, QuantToStr(fLines^[LineCount].Qty)));
end; // TWriteXMLTransaction.WriteQuantityInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.WriteDiscountInfo(ParentTag : TXmlDElement; LineCount : integer);
// Notes : Discount information within a transaction line
var
  DiscountTag : TXmlDElement;
  sDiscType : string;

  procedure WriteDiscount(const DiscType : string; DiscVal : Double; DiscChar : Char; Qty : Double);
  var
    sDiscType : string;
  begin
    if not ZeroFloat(DiscVal) then
    if DiscChar = '%' then
    begin
      DiscountTag := Document.CreateElement(XML_DISCOUNT_PERCENT);
      ParentTag.AppendChild(DiscountTag);
      DiscountTag.AppendChild(Document.CreateElement(XML_TYPE,
        BASDADiscountTypeToDesc(DiscType), [XML_CODE], [DiscType]));
      DiscountTag.AppendChild(Document.CreateElement(XML_PERCENTAGE,
         CostToStr(DiscVal * 100)))
    end
    else
    begin
      DiscountTag := Document.CreateElement(XML_DISCOUNT_AMOUNT);
      ParentTag.AppendChild(DiscountTag);
      DiscountTag.AppendChild(Document.CreateElement(XML_TYPE,
        BASDADiscountTypeToDesc(DiscType), [XML_CODE], [DiscType]));
      DiscountTag.AppendChild(Document.CreateElement(XML_AMOUNT,
        FloatToStrF(DiscVal * Qty, ffFixed, 5, 2)));
    end;
  end;
begin
  //PR: 27/05/2009 Added handling for Advance Discounts
  with fLines^[LineCount] do
  begin
    WriteDiscount(BASDA_RECIPE_DISCOUNT, Discount, DiscountChr, Qty * QtyMul);
    WriteDiscount(BASDA_VOLUME_DISCOUNT, tlMultiBuyDiscount, tlMultiBuyDiscountChr, Qty * QtyMul);
    WriteDiscount(BASDA_SPECIAL_DISCOUNT, tlTransValueDiscount, tlTransValueDiscountChr, Qty * QtyMul);

  end;


end; // WriteDiscountInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.WritePriceInfo(ParentTag : TXmlDElement; LineCount : integer);
// Notes : Price information within a transaction line
var
  Price : TXmlDElement;
begin
{$IFNDEF StandAlone}
  Price := Document.CreateElement(XML_PRICE, [XML_PRICE_UOM_DESC], [fStockInfo^.UnitS]);
{$ELSE}
  Price := Document.CreateElement(XML_PRICE, [XML_PRICE_UOM_DESC],
                 [fAuxLines[fCurrentLine]^.axUOMPriceDesc]);
{$ENDIF}
  ParentTag.AppendChild(Price);
  Price.AppendChild(Document.CreateElement(XML_UNIT_PRICE,
    CostToStr(fLines^[LineCount].NetValue)));
end; // TWriteXMLTransaction.WritePriceInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.WritePropertiesInfo(ParentTag : TXmlDElement;
  LineCount : integer);
var
  Properties : TXmlDElement;
  Weight : double;
begin
{$IFNDEF StandAlone}
  if DocType in [PIN, POR] then
    Weight := fStockInfo^.PWeight
  else
    Weight := fStockInfo^.SWeight;
{$ELSE}
  Weight := fLines^[FCurrentLine].LWeight;
{$ENDIF}

  if not ZeroFloat(Weight) then
  begin
    Properties := Document.CreateElement(XML_PRODUCT_PROPERTIES);
    ParentTag.AppendChild(Properties);
    Properties.AppendChild(Document.CreateElement(XML_PROPERTIES_WEIGHT,
      FloatToStrF(Weight, ffFixed, 15, 2),
      [XML_PROPERTIES_UOM_DESC, XML_PROPERTIES_UOM_CODE],
      [BASDAPropertiesUOMToDesc(BASDA_WEIGHT_KG), BASDA_WEIGHT_KG]));
  end;
end; // TWriteXMLTransaction.WritePropertiesInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.WriteReferenceInfo(ParentTag : TXmlDElement;
  LineCount : integer; const TagName : string);
var
  Reference, ExchequerTag, ExtensionsTag : TXmlDElement;
  oLineNo, JCode, ACode, LRef : string;

  procedure CreateRefTag;
  begin
    if not Assigned(Reference) then
    begin
      Reference := Document.CreateElement(TagName);
      ParentTag.AppendChild(Reference);
    end;
  end;

  function WantExchequerTag : Boolean;
  begin
    Result := bUseBasda309 and (
              (DocType in [POR, SOR]) or
              (Trim(fLines^[LineCount].Dep) <> '') or
              ((SysInfo^.MultiLocn > 1) and (Trim(fLines^[LineCount].MLocStk) <> '')) or
              (Trim(fLines^[LineCount].LineUser1) <> '') or
              (Trim(fLines^[LineCount].LineUser2) <> '') or
              (Trim(fLines^[LineCount].LineUser3) <> '') or
              (Trim(fLines^[LineCount].LineUser4) <> '') or
              (fLines^[LineCount].tlTransValueDiscountType > 0) or NeedLinkToStockLine(fLines^[LineCount].KitLink)
              );

  end;

begin
  Reference := nil;
  CreateRefTag;

  if WantExchequerTag then
  begin
    ExchequerTag := Document.CreateElement(AddNameSpace(ENT_TRANS_LINE_EXTENSIONS, NAMESPACE_EXCHEQUER));
    ExtensionsTag := Document.CreateElement(BASDA_EXTENSIONS);
    ParentTag.AppendChild(ExtensionsTag);
    ExtensionsTag.AppendChild(ExchequerTag);
  end;

  WriteTransDiscountType(ExchequerTag, LineCount);

  if SysInfo^.CCDepts then
  begin
    if Trim(fLines^[LineCount].CC) <> '' then
    begin
      CreateRefTag;
      Reference.AppendChild(Document.CreateElement(XML_COST_CENTRE, fLines^[LineCount].CC));
    end;

    if Trim(fLines^[LineCount].Dep) <> '' then
    begin
      if not bUseBasda309 then
      begin
        CreateRefTag;
        Reference.AppendChild(Document.CreateElement(
          AddNameSpace(XML_DEPARTMENT, NAMESPACE_EXCHEQUER), fLines^[LineCount].Dep));
      end
      else
        ExchequerTag.AppendChild(Document.CreateElement(
          AddNameSpace(XML_DEPARTMENT, NAMESPACE_EXCHEQUER), fLines^[LineCount].Dep));
    end;
  end;

  if fLines^[LineCount].NomCode <> 0 then
  begin
    CreateRefTag;
    Reference.AppendChild(Document.CreateElement(XML_GL_CODE,
      IntToStr(fLines^[LineCount].NomCode)));
  end;

  //PR: 02/02/2012 ABSEXCH-2748 If this is a Bom component line then we need to add the ExtendedLineType tag.
  if NeedLinkToStockLine(fLines^[LineCount].KitLink) then
  begin
    if not bUseBasda309 then
    begin
      Reference.AppendChild(Document.CreateElement(
        AddNameSpace(ENT_EXTENDED_LINE_TYPE, NAMESPACE_EXCHEQUER), ENT_EXTENDED_LINE_TYPE_STOCK_DESCRIPTION));
    end
    else
    begin
      ExchequerTag.AppendChild(Document.CreateElement(
        AddNameSpace(ENT_EXTENDED_LINE_TYPE, NAMESPACE_EXCHEQUER), ENT_EXTENDED_LINE_TYPE_STOCK_DESCRIPTION));
    end;
  end;


  if (SysInfo^.MultiLocn > 1) and (Trim(fLines^[LineCount].MLocStk) <> '') then
  begin
    if not bUseBasda309 then
    begin
      CreateRefTag;
      Reference.AppendChild(Document.CreateElement(
        AddNameSpace(XML_LOCATION, NAMESPACE_EXCHEQUER), fLines^[LineCount].MLocStk));
    end
    else
      ExchequerTag.AppendChild(Document.CreateElement(
        AddNameSpace(XML_LOCATION, NAMESPACE_EXCHEQUER), fLines^[LineCount].MLocStk));
  end;

  //Add in user def fields for cougar
  if Trim(fLines^[LineCount].LineUser1) <> '' then
  begin
    if not bUseBasda309 then
    begin
      CreateRefTag;
      Reference.AppendChild(Document.CreateElement(
        AddNameSpace(ENT_LINEUSER1, NAMESPACE_EXCHEQUER), fLines^[LineCount].LineUser1));
    end
    else
      ExchequerTag.AppendChild(Document.CreateElement(
        AddNameSpace(ENT_LINEUSER1, NAMESPACE_EXCHEQUER), fLines^[LineCount].LineUser1));
  end;

  if Trim(fLines^[LineCount].LineUser2) <> '' then
  begin
    if not bUseBasda309 then
    begin
      CreateRefTag;
      Reference.AppendChild(Document.CreateElement(
        AddNameSpace(ENT_LINEUSER2, NAMESPACE_EXCHEQUER), fLines^[LineCount].LineUser2));
    end
    else
      ExchequerTag.AppendChild(Document.CreateElement(
        AddNameSpace(ENT_LINEUSER2, NAMESPACE_EXCHEQUER), fLines^[LineCount].LineUser2));
  end;

  if Trim(fLines^[LineCount].LineUser3) <> '' then
  begin
    if not bUseBasda309 then
    begin
      CreateRefTag;
      Reference.AppendChild(Document.CreateElement(
        AddNameSpace(ENT_LINEUSER3, NAMESPACE_EXCHEQUER), fLines^[LineCount].LineUser3));
    end
    else
      ExchequerTag.AppendChild(Document.CreateElement(
        AddNameSpace(ENT_LINEUSER3, NAMESPACE_EXCHEQUER), fLines^[LineCount].LineUser3));
  end;

  if Trim(fLines^[LineCount].LineUser4) <> '' then
  begin
    if not bUseBasda309 then
    begin
      CreateRefTag;
      Reference.AppendChild(Document.CreateElement(
        AddNameSpace(ENT_LINEUSER4, NAMESPACE_EXCHEQUER), fLines^[LineCount].LineUser4));
    end
    else
      ExchequerTag.AppendChild(Document.CreateElement(
        AddNameSpace(ENT_LINEUSER4, NAMESPACE_EXCHEQUER), fLines^[LineCount].LineUser4));
  end;

  if fEBusAvailable then
  begin
//    OLineNo := IntToStr(FPresLineFields[LineCount].IdLineNo);
    //PR: 14/05/2009 This was putting out LineNo instead of OrderLineNo
    OLineNo := IntToStr(FPresLineFields[LineCount].IdOrderLineNo);
    JCode   := Trim(FPresLineFields[LineCount].IdProjectCode);
    ACode   := Trim(FPresLineFields[LineCount].IdAnalysisCode);
    LRef    := Trim(FPresLineFields[LineCount].IdBuyersLineRef);
  end
  else
  begin
    //PR: 14/05/2009
//    OLineNo := IntToStr(fLines^[LineCount].SOPLineNo);
    OLineNo := IntToStr(fLines^[LineCount].AbsLineNo);
    JCode   := Trim(fLines^[LineCount].JobCode);
    ACode   := Trim(fLines^[LineCount].AnalCode);
//    LRef    := fHeader^.OurRef + '-' + IntToStr(LineCount);
   //PR: 14/05/2009 Was outputting LineCount (ie position in array) rather than AbsLineNo. Consequently, if lineNos are 1, 3
   //second line would not be identified on return.
    LRef    := fHeader^.OurRef + '-' + IntToStr(fLines^[LineCount].AbsLineNo);
  end;



  if JCode <> '' then
  begin
    CreateRefTag;
    Reference.AppendChild(Document.CreateElement(XML_PROJECT_CODE,
      JCode, [XML_PRESERVE], [XML_TRUE]));
  end;

  if ACode <> '' then
  begin
    CreateRefTag;
    Reference.AppendChild(Document.CreateElement(XML_PROJECT_ANALYSIS_CODE,
      Acode, [XML_PRESERVE], [XML_TRUE]));
  end;

  if (fDocType in [SIN, PIN]) and fEbusAvailable and (Trim(fPresLineFields[LineCount].IdBuyersOrder)<>'') then
  begin
    CreateRefTag;
    Reference.AppendChild(Document.CreateElement(XML_BUYER_ORDER_NO,
      Trim(fPresLineFields[LineCount].IdBuyersOrder), [XML_PRESERVE], [XML_TRUE]));
  end;

  if (fDocType in [SIN, PIN]) or not bUseBasda309 then
  begin
    CreateRefTag;
    Reference.AppendChild(Document.CreateElement(XML_ORDER_LINE_NUMBER,
      OLineNo, [XML_PRESERVE], [XML_TRUE]));
  end
  else
    ExchequerTag.AppendChild(Document.CreateElement(AddNameSpace(XML_ORDER_LINE_NUMBER, NAMESPACE_EXCHEQUER),
      OLineNo, [XML_PRESERVE], [XML_TRUE]));


  if LRef <> '' then
  begin
    CreateRefTag;
    Reference.AppendChild(Document.CreateElement(XML_BUYERS_ORDER_LINE_REF,
      LRef, [XML_PRESERVE], [XML_TRUE]));
  end;

{  else
  if (fDocType in [POR]) then
  begin
    CreateRefTag;
    Reference.AppendChild(Document.CreateElement(XML_BUYER_ORDER_NO,
      Trim(fHeader^.OurRef), [XML_PRESERVE], [XML_TRUE]));
  end;}



end; // TWriteXMLTransaction.WriteReferenceInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.WriteStockCodeInfo(ParentTag : TXmlDElement;
  LineCount : integer; const OurStockTag, TheirStockTag : string);
begin
  if Trim(fStockInfo^.StockCode) <> '' then
  begin  // Various equivalent stock codes
    ParentTag.AppendChild(Document.CreateElement(OurStockTag,
      Trim(fLines^[LineCount].StockCode)));

    // Alternative stock code
    if SetAltStockCode(fLines^[LineCount].StockCode, fCustSupp^.CustCode) then
      ParentTag.AppendChild(Document.CreateElement(TheirStockTag,
        Trim(fAltStockInfo^.AltCode)));

    (* No BASDA code defined - ???
    // Generic alternative stock code i.e. without a supplier code
    if SetAltStockCode(fLines^[LineCount].StockCode, '') then
      ParentTag.AppendChild(Document.CreateElement(TheirStockTag,
        Trim(fAltStockInfo^.AltCode))); *)

   // Bar code
    if Trim(fStockInfo^.stBarCode) <> '' then
      ParentTag.AppendChild(Document.CreateElement(XML_CONSUMER_UNIT_CODE,
        Trim(fStockInfo.stBarCode)));
  end;
end; // TWriteXMLTransaction.WriteStockCodeInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.WriteLineTaxInfo(ParentTag : TXmlDElement;
  LineCount : integer);
var
  LineTax : TXmlDElement;
begin
  LineTax := Document.CreateElement(XML_LINE_TAX);
  ParentTag.AppendChild(LineTax);
  LineTax.AppendChild(Document.CreateElement(XML_TAX_RATE,
    FloatValToStr(GetVATRate(fLines^[LineCount].VATCode), 2),
    [XML_CODE], [fLines^[LineCount].VATCode]));
  LineTax.AppendChild(Document.CreateElement(XML_TAX_VALUE,
    PriceToStr(fLines^[LineCount].VAT)));
end; // TWriteXMLTransaction.WriteLineTaxInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLTransaction.CreateXML(Ref : string);
// Pre : Ref = Our ref of the transaction
begin
  OurRef := Ref;
  ReadTransaction;
  ReadSystemInfo;
  ReadCurrencyInfo;
  ReadVATInfo;
  ReadCustSupp;
  SetStandardFields;

  if XSLLocation <> '' then
    Document.AppendChild(Document.CreateProcessingInst(XSLLocation));

  ProcessBizTalkWrapper;
  ProcessTransactionHeader;
  ProcessReference;
  ProcessDateInfo;
  ProcessSupplierBuyer;
  ProcessDelivery;
  ProcessInvoiceTo;
  ProcessTransactionLines;
end;

//===================================================================================

procedure TWriteXMLTransaction.SetHeader(Value : TBatchTHRec);
begin
  fHeader^ := Value;
end;

function TWriteXMLTransaction.GetHeader : TBatchTHRec;
begin
  if Assigned(FHeader) then
    Result := fHeader^;
end;

procedure TWriteXMLTransaction.SetLines(const Value : TBatchLinesRec);
begin
  fLines^ := Value;
end;

function TWriteXMLTransaction.GetLines : TBatchLinesRec;
begin
  if Assigned(fLines) then
    Result := fLines^;
end;

function TWriteXMLTransaction.FindOriginalOrderRef(const InvRef : string) : string;
var
  MatchRec : TBatchMatchRec;
  Res : SmallInt;
  KeyS : PChar;
begin
{$IFNDEF Standalone}
  GetMem(KeyS, 256);
  StrPCopy(KeyS, InvRef);

  FillChar(MatchRec, SizeOf(MatchRec), 0);

  Res := Ex_GetMatch(@MatchRec, SizeOf(MatchRec), KeyS, 0, B_GetGEq, False);

  while (MatchRec.DebitRef = InvRef) and (Res = 0) and (MatchRec.MatchType <> 'O') do
    Res := Ex_GetMatch(@MatchRec, SizeOf(MatchRec), KeyS, 0, B_GetNext, False);

  if (MatchRec.DebitRef = InvRef) and (Res = 0) and (MatchRec.MatchType = 'O') then
    Result := MatchRec.CreditRef
  else
    Result := '';

  FreeMem(KeyS, 256);
{$ELSE}
  Result := '';
{$ENDIF}
end;

function TWriteXMLTransaction.LoadPreserveFields(const InvRef : string) : Boolean;
var
  Res : SmallInt;
  KeyS : String[255];
  OrderRef : string;
  F : FileVar;
  FEbusRec : TEbusRec;
  i : longint;
begin
  Result := False;
  OrderRef := FindOriginalOrderRef(InvRef);
  if OrderRef = '' then
    OrderRef := fHeader^.YourRef;

  Res := Open_File(F, fEntPath + 'ebus.dat', 0);
  if Res = 0 then
  begin
    KeyS := 'EP' + MakePreserveKey1(CompanyCodeFromDir(fDataPath), OrderRef) +MakePreserveKey2('');
    Res := Find_Rec(B_GetEq, F, EbsF, FEbusRec, 0, KeyS);

    if Res = 0 then
    begin
      fPresDocFields := FEbusRec.PreserveDoc;
      Result := True;
      SetLength(fPresLineFields, fHeader.LineCount + 1);
      for i := 1 to fHeader.LineCount do
      begin
//        KeyS := 'EQ' + FullNomKey(fLines^[i].SOPLink) + FullNomKey(fLines^[i].SOPLineNo) + '!';
        KeyS := 'EQ' + MakePreserveKey1(CompanyCodeFromDir(fDataPath),FullNomKey(fLines^[i].SOPLink)) +
                                                                      MakePreserveKey2(FullNomKey(fLines^[i].SOPLineNo) + '!');
        Res := Find_Rec(B_GetEq, F, Ebsf, FEbusRec, 0, KeyS);
        if Res = 0 then
          fPresLineFields[i] := FEbusRec.PreserveLine;
      end;
    end;
  end;
end;


{$IFDEF StandAlone}
function TWriteXMLTransaction.GetVATRate(VATCode : char) : double;
begin
  if Assigned(fAuxLines[fCurrentLine]) then
     Result := fAuxLines[fCurrentLine]^.axVatRate
  else
    Result := 0.0;
end;

function TWriteXMLTransaction.CalcLineTotal : Double;
var
  DiscValue : Double;
  Total : Double;
begin
  if fCalcLineTotals then
  begin
    with fLines^[FCurrentLine] do
    begin
      Total := Qty * QtyMul * NetValue;

      if DiscountChr = '%' then
        DiscValue:=Round_Up(Discount * Total,2)
      else
        DiscValue := Discount;

      Result := Total - DiscValue;

    end;
  end
  else
    Result := FAuxLines[FCurrentLine]^.axLineTotal;
end;

function TWriteXMLTransaction.CalcLineDiscountValue(LineNo : integer) : Double;
var
  Total : Double;
begin
   with fLines^[LineNo] do
   begin
      Total := Qty * QtyMul * NetValue;

      if DiscountChr = '%' then
        Result :=Round_Up(Discount * Total,2)
      else
        Result := Discount;
   end;
end;

procedure TWriteXMLTransaction.SetNarrative(len : integer);
begin
  SetLength(fNarrative, len);
end;

procedure TWriteXMLTransaction.SetSerial(len : integer);
begin
  SetLength(fSerial, len);
end;



{$ENDIF}


function TWriteXMLTransaction.TransDiscountType: Integer;
var
  i : Integer;
begin
  Result := 0;
  i := 1;
  while (i < fHeader.LineCount) and (Result = 0) do
  begin
    Result := fLines[i].tlTransValueDiscountType;

    if Result = 0 then
      inc(i);
  end;
end;

procedure TWriteXMLTransaction.WriteTransDiscountType(ParentTag : TXmlDElement; LineCount : integer);
var
  DiscountTag : TXmlDElement;
  sDiscType : string;
begin
  with fLines^[LineCount] do
  begin
    Case tlTransValueDiscountType of
      1  : sDiscType := ENT_TRANS_DISC_TTD;
      2  : sDiscType := ENT_TRANS_DISC_VBD;
    255  : sDiscType := ENT_TRANS_MBD_DESC_LINE;
    end; //Case

    if tlTransValueDiscountType > 0 then
    begin
      DiscountTag := Document.CreateElement(AddNameSpace(ENT_TRANS_DISC_TYPE, NAMESPACE_EXCHEQUER), sDiscType);
      ParentTag.AppendChild(DiscountTag);
    end;
  end;
end;

//PR: 02/02/2012 ABSEXCH-2748 Function to write ExtendedLineType tag for additional stock desc line if required
procedure TWriteXMLTransaction.WriteLinkToStock(ParentTag : TXmlDElement; LineNo: Integer;
                 const TagName : string);
var
  Reference, ExchequerTag, ExtensionsTag : TXmlDElement;
begin
  if NeedLinkToStockLine(fLines^[LineNo].KitLink) then
  begin
    if not bUseBasda309 then
    begin
      Reference := Document.CreateElement(TagName);
      ParentTag.AppendChild(Reference);

      Reference.AppendChild(Document.CreateElement(
        AddNameSpace(ENT_EXTENDED_LINE_TYPE, NAMESPACE_EXCHEQUER), ENT_EXTENDED_LINE_TYPE_STOCK_DESCRIPTION));
    end
    else
    begin
      ExchequerTag := Document.CreateElement(AddNameSpace(ENT_TRANS_LINE_EXTENSIONS, NAMESPACE_EXCHEQUER));
      ExtensionsTag := Document.CreateElement(BASDA_EXTENSIONS);
      ParentTag.AppendChild(ExtensionsTag);
      ExtensionsTag.AppendChild(ExchequerTag);

      ExchequerTag.AppendChild(Document.CreateElement(
        AddNameSpace(ENT_EXTENDED_LINE_TYPE, NAMESPACE_EXCHEQUER), ENT_EXTENDED_LINE_TYPE_STOCK_DESCRIPTION));
    end;
  end;
end;

//PR: 02/02/2012 ABSEXCH-2748
function TWriteXMLTransaction.NeedLinkToStockLine(iLink: Integer): Boolean;
begin
  Result := (iLink <> 0) and (iLink <> fHeader.FolioNum);
end;

Initialization
  bUseBasda309 := False;

end.
