unit XMLStock;

{ prutherford440 09:52 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  XMLOutpt, XMLBase, XMLExp, Classes, StrUtil;

{$I Exchdll.inc}
{$I Exdllbt.inc}

type
  PBatchSKRec = ^TBatchSKRec;
  PBatchSLRec = ^TBatchSLRec;

  TWriteXMLStockGroup = class(TWriteXMLExport) {was from TWriteXMLBase}
    private
      Root     : TXmlDElement;
      procedure ProcessStockGroups(SearchCode : TCharArray255);
      procedure OutputStockGroup(StockInfo : PBatchSKRec);
    public
      procedure CreateXML; override;
  end;

  TWriteXMLStock = class(TWriteXMLExport)
    private
      StockRoot,
      LocationRoot : TXmlDElement;
      StockInfo : PBatchSKRec;
      StockLocnInfo : PBatchSLRec;
      MultiLocationEnabled : boolean;
      LocationsList : TStringList;

      procedure ReadLocations;
      procedure ProcessStockTree(SearchCode : TCharArray255);
      procedure OutputStockXML;
      procedure ProcessStockLocation;
      procedure OutputStockLocationXML;
      procedure WriteProductCodeInfo;
      procedure WriteDefaultsInfo;
      procedure WriteDescription;
      procedure WriteTaxInfo;
      procedure WriteQuantityInfo;
      procedure WriteIntraStatInfo;
      procedure WriteCoverInfo;
      procedure WriteReOrderInfo;
      procedure WriteStockLevels;
      procedure WriteCostInfo;
      procedure WriteSalesInfo;
      procedure WriteEnterpriseInfo;
      procedure WriteDatabaseInfo;
      procedure WriteLocnDefaultsInfo;
      procedure WriteLocnQuantityInfo;
      procedure WriteLocnReOrderInfo;
      procedure WriteLocnStockLevels;
      procedure WriteLocnCostInfo;
      procedure WriteLocnSalesInfo;
      procedure WriteLocnDatabaseInfo;
      function  OKToWriteStockRecord : boolean;
      function  OKToWriteStockLocationRecord : boolean;
    public
      WebCatFilter, ProdGroupFilter : string;
      WebCatFilterFlag : Byte;
      procedure CreateXML; override;
      constructor Create;
      destructor  Destroy; override;
  end;

implementation

uses
  ExpUtil, UseDLLU, SysUtils, XMLUtil, XMLConst, eBusCnst;

procedure TWriteXMLStockGroup.OutputStockGroup(StockInfo : PBatchSKRec);
var
  ProprietaryInfo, EnterpriseInfo, Group, Description : TXmlDElement;
  i : integer;
begin
  Group := Document.CreateElement('Group');
  Root.AppendChild(Group);
  with StockInfo^ do
  begin
    Group.AppendChild(Document.CreateElement('Name', Trim(StockCode)));
    Group.AppendChild(Document.CreateElement('Parent', Trim(StockCat)));
    Description := Document.CreateElement('Description');
    Group.AppendChild(Description);

    for i := 1 to 6 do
      Description.AppendChild(Document.CreateElement('DescriptionLine', Trim(Desc[i])));

    ProprietaryInfo := Document.CreateElement(XML_PROPRIETARY);
    Group.AppendChild(ProprietaryInfo);
    EnterpriseInfo := Document.CreateElement(XML_ENTERPRISE);
    ProprietaryInfo.AppendChild(EnterpriseInfo);
    EnterpriseInfo.AppendChild(Document.CreateElement('ImageFile', ImageFile));
  end;
end;

//-----------------------------------------------------------------------

procedure TWriteXMLStockGroup.ProcessStockGroups(SearchCode : TCharArray255);
// SearchPath : 0 Stock Code
//              1 Stock Folio Number
//              2 Stock Group
var
  StockRec : PBatchSKRec;
  Status : integer;
  Position : longint;
  TempSearchCode : TCharArray255;
  CheckGroup, CurGroup : string;
begin
  new(StockRec);
  // Find record in stock file
  CheckGroup := SearchCode;
  Status := Ex_GetStock(StockRec, SizeOf(StockRec^), SearchCode, 2, B_GetGEq, false);
  CurGroup := StockRec^.StockCat;

  // Check we're processing same stock group code
  while (Trim(CheckGroup) = Trim(StockRec^.StockCat))
  and (Status = 0) and (Trim(StockRec^.StockCat) = Trim(CurGroup)) do begin
    with StockRec^ do begin
      if (StockType = 'G') and (IgnoreWebIncludeFlag  or (WebInclude > 0)) then begin
        OutputStockGroup(StockRec);

        // Store Btrieve position
        Ex_GetRecordAddress(StockF, Position);

        // Recurse down a level
        FillChar(TempSearchCode, SizeOf(TempSearchCode), #0);
        Move(StockCode[1], TempSearchCode, length(StockCode));
        ProcessStockGroups(TempSearchCode);

        // Restore Btrieve position - moved back up a level
        Ex_GetRecWithAddress(StockF, 2, Position);
      end;{if}
    end;{with}
    Status := Ex_GetStock(StockRec, SizeOf(StockRec^), SearchCode, 2, B_GetNext, false);
  end; // while

  dispose(StockRec);
end; // TWriteXMLStockGroup.ProcessStockGroups

//-----------------------------------------------------------------------

procedure TWriteXMLStockGroup.CreateXML;
begin
  Root := Document.CreateElement('StockGroups');
  Document.AppendChild(Root);
  ProcessStockGroups('');
end;

//=======================================================================

constructor TWriteXMLStock.Create;
begin
  inherited Create;
  new(StockInfo);
  new(StockLocnInfo);
  LocationsList := TStringList.Create;
end;

//-----------------------------------------------------------------------------------

destructor TWriteXMLStock.Destroy;
begin
  dispose(StockInfo);
  dispose(StockLocnInfo);
  LocationsList.Free;
  inherited Destroy;
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.CreateXML;
var
  Seed : TCharArray255;
begin
  ReadSystemInfo;
  MultiLocationEnabled := SysInfo^.MultiLocn > 1;
  if MultiLocationEnabled then
    ReadLocations;
  Document := TxmlDDocument.Create;
  Root := Document.CreateElement('Products');
  Document.AppendChild(Root);
{  ProcessStockTree('');}
  StrPCopy(Seed, ProdGroupFilter);
  ProcessStockTree(Seed);
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.ReadLocations;
var
  LocationCode : array[0..255] of char;
  LocationRec : TBatchMLocRec;
  Status : integer;
begin
  FillChar(LocationCode, SizeOf(LocationCode), 0);
  Status := Ex_GetLocation(@LocationRec, Sizeof(LocationRec), LocationCode, 0, B_GetFirst, false);
  while Status = 0 do
  begin
    LocationsList.Add(LocationRec.LoCode);
    Status := Ex_GetLocation(@LocationRec, Sizeof(LocationRec), LocationCode, 0, B_GetNext, false);
  end;
end;

//-----------------------------------------------------------------------------------

function TWriteXMLStock.OKToWriteStockRecord : boolean;

  function StockLocationChanged : boolean;
  var
    SearchStockCode,
    SearchLocationCode : array[0..255] of char;
    i,
    Status : integer;
//    LStockLocnInfo : PBatchSLRec;
    bChanged : boolean;
  begin
    i := 0;
    bChanged := FALSE;
    while (i < LocationsList.Count) and (not bChanged)  do
    begin
{    for i := 0 to LocationsList.Count -1 do
    begin}
      FillChar(SearchLocationCode, Sizeof(SearchLocationCode), 0);
      StrPCopy(SearchLocationCode, LocationsList[i]);
      StrPCopy(SearchStockCode, StockInfo^.StockCode);
      Status := Ex_GetStockLoc(StockLocnInfo, SizeOf(StockLocnInfo^), SearchStockCode
      , SearchLocationCode, false);
      if Status = 0 then bChanged := OKToWriteStockLocationRecord;
      inc(i);
    end;{while}
    Result := bChanged;
  end;

begin
  with StockInfo^ do
  begin
    Result := StockType in ['M','P'];
//    Result := Result and OKToWriteRecord(LastUsed, TimeChange);
    Result := Result and (OKToWriteRecord(LastUsed, TimeChange) or
    (MultiLocationEnabled {and ExportUpdatedLocations} and StockLocationChanged));

    {NF added to check if Stock Loation record has been updated
    if MultiLocationEnabled and ExportUpdatedLocations then
    begin
      Result := Result and OKToWriteRecord(StockLocnInfo.lsLastUsed, StockLocnInfo.lsLastTime);
    end;}

    if not IgnoreWebIncludeFlag then
      Result := Result and (WebInclude > 0);

    Result := Result and CheckFilter(WebCatFilter, WebLiveCat, WebCatFilterFlag);
  end;
end;

//-----------------------------------------------------------------------

function TWriteXMLStock.OKToWriteStockLocationRecord: boolean;
begin
  with StockLocnInfo^ do
    Result := OKToWriteRecord(lsLastUsed, lsLastTime);
end;

//-----------------------------------------------------------------------

procedure TWriteXMLStock.ProcessStockTree(SearchCode : TCharArray255);
var
  iKey, iSearchMode, Position, Status : integer;
  TempSearchCode : TCharArray255;
  CurGroup : string;
  sCode : string16;
  bGroup : boolean;
begin
  // Find record in stock file

  sCode := copy(SearchCode,0,StrLen(SearchCode));

  {is this item a group ?}
  if SearchCode = '' then bGroup := TRUE
  else begin
    Status := Ex_GetStock(StockInfo, SizeOf(StockInfo^), SearchCode, 0, B_GetGEq, false);
    bGroup := (Status = 0) and (StockInfo^.StockCode = sCode) and (StockInfo^.StockType = 'G');
  end;{if}

  if bGroup then
    begin
      iKey := 2;
      iSearchMode := B_GetGEq;
      CurGroup := sCode; {NF: 431.106 bug fix}
    end
  else begin
    iKey := 0;
    iSearchMode := B_GetEq;
  end;{if}

  Status := Ex_GetStock(StockInfo, SizeOf(StockInfo^), SearchCode, iKey, iSearchMode, false);

  if not bGroup then CurGroup := StockInfo^.StockCat; {NF: 431.106 bug fix}

  // Check we're processing same stock group code
  while (Status = 0) and (Trim(StockInfo^.StockCat) = Trim(CurGroup)) do begin
    with StockInfo^ do begin
      if (StockType = 'G') then
        begin
          if (IgnoreWebIncludeFlag  or (WebInclude > 0)) then begin
            // Store Btrieve position
            Ex_GetRecordAddress(StockF, Position);

            // Recurse down a level
            FillChar(TempSearchCode, SizeOf(TempSearchCode), #0);
            Move(StockCode[1], TempSearchCode, length(StockCode));
            ProcessStockTree(TempSearchCode);

            // Restore Btrieve position - moved back up a level
            Ex_GetRecWithAddress(StockF, 2, Position);
          end;
        end
      else begin
        {Write record to file}
//        if OKToWriteStockRecord or ( and OKToWriteStockLocationRecord) then begin
        if OKToWriteStockRecord then begin
          OutputStockXML;
          if MultiLocationEnabled and OKToWriteStockLocationRecord then ProcessStockLocation;
        end;
      end;{if}
    end;{with}
    Status := Ex_GetStock(StockInfo, SizeOf(StockInfo^), SearchCode, iKey, B_GetNext, false);
  end; // while
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.OutputStockXML;
begin
  StockRoot := Document.CreateElement('Product');
  Root.AppendChild(StockRoot);
  WriteProductCodeInfo;
  WriteDefaultsInfo;
  WriteDescription;
  WriteTaxInfo;
  WriteQuantityInfo;
  WriteIntraStatInfo;
  WriteCoverInfo;
  WriteReOrderInfo;
  WriteStockLevels;
  WriteCostInfo;
  WriteSalesInfo;
  WriteEnterpriseInfo;
  WriteDatabaseInfo;
end; // TWriteXMLStock.OutputStockXML

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.OutputStockLocationXML;
begin
  LocationRoot := Document.CreateElement('MultiLocation');
  StockRoot.AppendChild(LocationRoot);
  LocationRoot.AppendChild(Document.CreateElement(XML_LOCATION, StockLocnInfo^.lsLocCode));
  
  WriteLocnDefaultsInfo;
  WriteLocnQuantityInfo;
  WriteLocnReOrderInfo;
  WriteLocnStockLevels;
  WriteLocnCostInfo;
  WriteLocnSalesInfo;
  WriteLocnDatabaseInfo;
end; // TWriteXMLStock.OutputStockLocationXML

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.ProcessStockLocation;
var
  SearchStockCode,
  SearchLocationCode : array[0..255] of char;
  i,
  Status : integer;
begin
  for i := 0 to LocationsList.Count -1 do
  begin
    FillChar(SearchLocationCode, Sizeof(SearchLocationCode), 0);
    StrPCopy(SearchLocationCode, LocationsList[i]);
    StrPCopy(SearchStockCode, StockInfo^.StockCode);
    Status := Ex_GetStockLoc(StockLocnInfo, SizeOf(StockLocnInfo^), SearchStockCode,
      SearchLocationCode, false);
    if Status = 0 then
      OutputStockLocationXML;
  end;
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.WriteProductCodeInfo;
var
  ProductCodeInfo : TXmlDElement;
begin
  ProductCodeInfo := Document.CreateElement('ProductReferences');
  StockRoot.AppendChild(ProductCodeInfo);
  with StockInfo^ do
  begin
    ProductCodeInfo.AppendChild(Document.CreateElement('StockCode', Trim(StockCode)));
    ProductCodeInfo.AppendChild(Document.CreateElement('AltCode', Trim(AltCode)));
    ProductCodeInfo.AppendChild(Document.CreateElement('BarCode', StBarCode));
  end; 
end; // TWriteXMLStock.WriteProductCodeInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.WriteDefaultsInfo;
var
  Defaults,
  SupplierInfo,
  SupplierRefs,
  GLCodes : TXmlDElement;
begin
  Defaults := Document.CreateElement(XML_DEFAULTS);
  StockRoot.AppendChild(Defaults);
  with StockInfo^ do
  begin
    SupplierInfo := Document.CreateElement(XML_SUPPLIER);
    Defaults.AppendChild(SupplierInfo);
    SupplierRefs := Document.CreateElement(XML_SUPPLIER_REFS);
    SupplierInfo.AppendChild(SupplierRefs);
    SupplierRefs.AppendChild(Document.CreateElement(XML_BUYER_CODE_SUPPLIER, Trim(Supplier)));
    SupplierRefs.AppendChild(Document.CreateElement(XML_ALT_BUYER_CODE_SUPPLIER, Trim(SuppTemp)));
    Defaults.AppendChild(Document.CreateElement(XML_PROJECT_ANALYSIS_CODE, Trim(JAnalCode)));
    Defaults.AppendChild(Document.CreateElement(XML_COST_CENTRE, Trim(CC)));
    Defaults.AppendChild(Document.CreateElement(XML_DEPARTMENT, Trim(Dep)));
    Defaults.AppendChild(Document.CreateElement(XML_LOCATION, Trim(StLocation)));
    Defaults.AppendChild(Document.CreateElement('StockGroup', Trim(StockCat)));
    Defaults.AppendChild(Document.CreateElement('BinLocation', Trim(BinLoc)));

    GLCodes := Document.CreateElement(XML_GL_CODE);
    Defaults.AppendChild(GLCodes);
    GLCodes.AppendChild(Document.CreateElement(XML_GL_SALES, IntToStr(NomCodes[1])));
    GLCodes.AppendChild(Document.CreateElement(XML_GL_COSTOFSALES, IntToStr(NomCodes[2])));
    GLCodes.AppendChild(Document.CreateElement(XML_GL_PROFITANDLOSS, IntToStr(NomCodes[3])));
    GLCodes.AppendChild(Document.CreateElement(XML_GL_BALSHEET, IntToStr(NomCodes[4])));
    GLCodes.AppendChild(Document.CreateElement(XML_GL_WIP, IntToStr(NomCodes[5])));
  end;
end; // TWriteXMLStock.WriteDefaultsInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.WriteDescription;
var
  Description : TXmlDElement;
  i : integer;
begin
  Description := Document.CreateElement(XML_PRODUCT_DESCRIPTION);
  StockRoot.AppendChild(Description);
  for i := 1 to 6 do
    Description.AppendChild(Document.CreateElement(XML_DESCRIPTION_LINE, Trim(StockInfo^.Desc[i])));
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.WriteTaxInfo;
var
  TaxInfo : TXmlDElement;
begin
  TaxInfo := Document.CreateElement(XML_TAX_INFO);
  StockRoot.AppendChild(TaxInfo);
  with StockInfo^ do
  begin
    TaxInfo.AppendChild(Document.CreateElement(XML_VAT_CODE, JustAlphaNum(VATCode)));
    TaxInfo.AppendChild(Document.CreateElement(XML_VAT_INCLUSIVE_CODE, JustAlphaNum(SVATIncFlg)));
  end;
end; // TWriteXMLStock.WriteTaxInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.WriteQuantityInfo;
var
  QuantityInfo : TXmlDElement;
begin
  QuantityInfo := Document.CreateElement(XML_QUANTITY);
  StockRoot.AppendChild(QuantityInfo);
  with StockInfo^ do
  begin
    QuantityInfo.AppendChild(Document.CreateElement('StockingDescription', UnitK));
    QuantityInfo.AppendChild(Document.CreateElement('SellingDescription', UnitS));
    QuantityInfo.AppendChild(Document.CreateElement('BuyingDescription', UnitP));
    QuantityInfo.AppendChild(Document.CreateElement('SellingUnit', FloatToStr(SellUnit)));
    QuantityInfo.AppendChild(Document.CreateElement('BuyingUnit', FloattoStr(BuyUnit)));
    QuantityInfo.AppendChild(Document.CreateElement('Picked', FloattoStr(QtyPicked)));
    QuantityInfo.AppendChild(Document.CreateElement('QuantityAsCase', BooleanToString(StDPackQty)));
  end;
end; // TWriteXMLStock.WriteTaxInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.WriteIntraStatInfo;
var
  IntraStat : TXmlDElement;
begin
  IntraStat := Document.CreateElement(XML_INTRASTAT);
  StockRoot.AppendChild(IntraStat);
  with StockInfo^ do
  begin
    IntraStat.AppendChild(Document.CreateElement(XML_INTRASTAT_COMMOD_CODE, CommodCode));
    IntraStat.AppendChild(Document.CreateElement('SellingWeight', FloatToStr(SWeight)));
    IntraStat.AppendChild(Document.CreateElement('BuyingWeight', FloatToStr(PWeight)));
    IntraStat.AppendChild(Document.CreateElement('SalesUnit', UnitSupp));
    IntraStat.AppendChild(Document.CreateElement('StockPerUnit', FloatToStr(SuppSUnit)));
    IntraStat.AppendChild(Document.CreateElement('UpliftDespatch', FloatToStr(SSDDUpLift)));
  end;
end; // TWriteXMLStock.WriteIntraStatInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.WriteCoverInfo;
var
  Cover : TXmlDElement;

  function CoverDesc(CoverPeriod : char) : string;
  begin
    case CoverPeriod of
      'D' : Result := 'days';
      'W' : Result := 'weeks';
      'M' : Result := 'months';
    else
      Result := '';
    end;
  end;
  
begin
  Cover := Document.CreateElement('Cover');
  StockRoot.AppendChild(Cover);
  with StockInfo^ do
  begin
    Cover.AppendChild(Document.CreateElement('UseCover', BooleanToString(UseCover)));
    Cover.AppendChild(Document.CreateElement('NumPeriods', IntToStr(CovPr)));
    Cover.AppendChild(Document.CreateElement('PeriodType', CoverDesc(CovPrUnit)));
    Cover.AppendChild(Document.CreateElement('MinNumPeriods', IntToStr(CovMinPr)));
    Cover.AppendChild(Document.CreateElement('MinPeriodType', CoverDesc(CovMinUnit)));
    Cover.AppendChild(Document.CreateElement('MaxNumPeriods', IntToStr(CovMaxPr)));
    Cover.AppendChild(Document.CreateElement('MaxPeriodType', CoverDesc(CovMaxUnit)));
    Cover.AppendChild(Document.CreateElement('ItemsSold', FloatToStr(CovSold)));
  end;
end; // TWriteXMLStock.WriteCoverInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.WriteReOrderInfo;
var
  ReOrder : TXmlDElement;
begin
  ReOrder := Document.CreateElement('ReOrder');
  StockRoot.AppendChild(ReOrder);
  with StockInfo^ do
  begin
    ReOrder.AppendChild(Document.CreateElement(XML_CURRENCY, IntToStr(ROCurrency)));
    ReOrder.AppendChild(Document.CreateElement(XML_PRICE, FloatToStr(ROCPrice)));
    ReOrder.AppendChild(Document.CreateElement('DeliveryDate', RODate));
    ReOrder.AppendChild(Document.CreateElement(XML_COST_CENTRE, StROCostCentre));
    ReOrder.AppendChild(Document.CreateElement(XML_DEPARTMENT, StRODepartment));
  end;
end; // TWriteXMLStock.WriteCoverInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.WriteStockLevels;
var
  StockLevels : TXmlDElement;
begin
  StockLevels := Document.CreateElement('StockLevels');
  StockRoot.AppendChild(StockLevels);
  with StockInfo^ do
  begin
    StockLevels.AppendChild(Document.CreateElement('InStock', FloatToStr(QtyInStock)));
    StockLevels.AppendChild(Document.CreateElement('Posted', FloatToStr(QtyPosted)));
    StockLevels.AppendChild(Document.CreateElement('Allocated', FloatToStr(QtyAllocated)));
    StockLevels.AppendChild(Document.CreateElement('OnOrder', FloatToStr(QtyOnOrder)));
    StockLevels.AppendChild(Document.CreateElement('Minumum', FloatToStr(QtyMin)));
    StockLevels.AppendChild(Document.CreateElement('Maximum', FloatToStr(QtyMax)));
    StockLevels.AppendChild(Document.CreateElement('LastOrder', FloatToStr(ROQty)));
  end;
end; // TWriteXMLStock.WriteReOrderInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.WriteCostInfo;
var
  CostInfo : TXmlDElement;
begin
  CostInfo := Document.CreateElement('CostInfo');
  StockRoot.AppendChild(CostInfo);
  with StockInfo^ do
  begin
    CostInfo.AppendChild(Document.CreateElement(XML_CURRENCY, IntToStr(PCurrency)));
    CostInfo.AppendChild(Document.CreateElement('Buying', CostToStr(CostPrice)));
  end;
end; // TWriteXMLStock.WriteCostInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.WriteSalesInfo;
var
  SalesInfo,
  SalesBand : TXmlDElement;
  Band : integer;
begin
  SalesInfo := Document.CreateElement('SalesInfo');
  StockRoot.AppendChild(SalesInfo);
  for Band := 1 to 8 do
    with StockInfo^ do
    begin
      SalesBand := Document.CreateElement('Band', ['Reference'], [chr((Band)+ ord('A') -1)]);
      SalesInfo.AppendChild(SalesBand);
      SalesBand.AppendChild(Document.CreateElement(XML_CURRENCY,
        IntToStr(SaleBands[Band].Currency)));
      SalesBand.AppendChild(Document.CreateElement('Selling',
        PriceToStr(SaleBands[Band].SalesPrice)));
    end;
end; // TWriteXMLStock.WriteSalesInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.WriteEnterpriseInfo;
var
  ProprietaryInfo,
  EnterpriseInfo,
  UserDefinedInfo : TXmlDElement;

  procedure WriteUserDefinedField(FieldNo : integer; const Field : string);
  begin
    UserDefinedInfo.AppendChild(Document.CreateElement('Field', Field, 'Number', IntToStr(FieldNo)));
  end;

  function ValuationDesc(ValuationType : char) : string;
  begin
    case ValuationType of
      'C' : Result := 'last cost';
      'L' : Result := 'LIFO';
      'F' : Result := 'FIFO';
      'S' : Result := 'standard';
      'A' : Result := 'average';
      'R' : Result := 'serial/batch';
    else
      Result := ValuationType;
    end;
  end;

begin // TWriteXMLStock.WriteEnterpriseInfo
  ProprietaryInfo := Document.CreateElement(XML_PROPRIETARY);
  StockRoot.AppendChild(ProprietaryInfo);
  EnterpriseInfo := Document.CreateElement(XML_ENTERPRISE);
  ProprietaryInfo.AppendChild(EnterpriseInfo);
  with StockInfo^ do
  begin
    EnterpriseInfo.AppendChild(Document.CreateElement('StockValuation',
      ValuationDesc(StkValType)));
    EnterpriseInfo.AppendChild(Document.CreateElement('PriceAsPack',
      BooleanToString(StPricePack)));
    EnterpriseInfo.AppendChild(Document.CreateElement('UseBOMPrice',
      BooleanToString(StKitPrice)));
    EnterpriseInfo.AppendChild(Document.CreateElement('ExplodeKit',
      BooleanToString(StKitOnPurch)));
    EnterpriseInfo.AppendChild(Document.CreateElement('MinReOrderEnabled',
      BooleanToString(MinFlg)));
    EnterpriseInfo.AppendChild(Document.CreateElement('AllowOnWeb', IntToStr(WebInclude)));
    EnterpriseInfo.AppendChild(Document.CreateElement('WebLiveCatalogues', WebLiveCat));
    EnterpriseInfo.AppendChild(Document.CreateElement('ImageFile', ImageFile));
    EnterpriseInfo.AppendChild(Document.CreateElement('AverageSerials', IntToStr(SerNoWAvg)));
    UserDefinedInfo := Document.CreateElement('UserDefined');
    EnterpriseInfo.AppendChild(UserDefinedInfo);
    WriteUserDefinedField(1, StStkUser1);
    WriteUserDefinedField(2, StStkUser2);
    WriteUserDefinedField(3, StkUser3);
    WriteUserDefinedField(4, StkUser4);

    //PR: 26/08/2014 ABSEXCH-15585 Added UDFs 5-10
    WriteUserDefinedField(5, StkUser5);
    WriteUserDefinedField(6, StkUser6);
    WriteUserDefinedField(7, StkUser7);
    WriteUserDefinedField(8, StkUser8);
    WriteUserDefinedField(9, StkUser9);
    WriteUserDefinedField(10, StkUser10);
  end;
end; // TWriteXMLStock.WriteEnterpriseInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.WriteDatabaseInfo;
var
  DatabaseInfo,
  RecordUpdated : TXmlDElement;
begin
  DatabaseInfo := Document.CreateElement(XML_DATABASE_INFO);
  StockRoot.AppendChild(DatabaseInfo);
  RecordUpdated := Document.CreateElement(XML_RECORD_UPDATED);
  DatabaseInfo.AppendChild(RecordUpdated);
  with StockInfo^ do
  begin
    RecordUpdated.AppendChild(Document.CreateElement(XML_RECORD_DATE, DateToBASDADate(LastUsed)));
    RecordUpdated.AppendChild(Document.CreateElement(XML_RECORD_TIME, TimeToBASDATime(TimeChange)));
    DatabaseInfo.AppendChild(Document.CreateElement(XML_RECORD_LAST_USER, LastOpo));
  end;
end; // TWriteXMLStock.WriteDatabaseInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.WriteLocnCostInfo;
var
  CostInfo : TXmlDElement;
begin
  CostInfo := Document.CreateElement('CostInfo');
  LocationRoot.AppendChild(CostInfo);
  with StockLocnInfo^ do
  begin
    CostInfo.AppendChild(Document.CreateElement(XML_CURRENCY, IntToStr(lsPCurrency)));
    CostInfo.AppendChild(Document.CreateElement('Buying', CostToStr(lsCostPrice)));
  end;
end; // TWriteXMLStock.WriteLocnCostInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.WriteLocnDatabaseInfo;
var
  DatabaseInfo,
  RecordUpdated : TXmlDElement;
begin
  DatabaseInfo := Document.CreateElement(XML_DATABASE_INFO);
  LocationRoot.AppendChild(DatabaseInfo);
  RecordUpdated := Document.CreateElement(XML_RECORD_UPDATED);
  DatabaseInfo.AppendChild(RecordUpdated);
  with StockLocnInfo^ do
  begin
    RecordUpdated.AppendChild(Document.CreateElement(XML_RECORD_DATE, DateToBASDADate(lsLastUsed)));
    RecordUpdated.AppendChild(Document.CreateElement(XML_RECORD_TIME, TimeToBASDATime(lsLastTime)));
  end;
end; // TWriteXMLStock.WriteLocnDatabaseInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.WriteLocnDefaultsInfo;
var
  Defaults,
  SupplierInfo,
  SupplierRefs,
  GLCodes : TXmlDElement;
begin
  Defaults := Document.CreateElement(XML_DEFAULTS);
  LocationRoot.AppendChild(Defaults);
  with StockLocnInfo^ do
  begin
    SupplierInfo := Document.CreateElement(XML_SUPPLIER);
    Defaults.AppendChild(SupplierInfo);
    SupplierRefs := Document.CreateElement(XML_SUPPLIER_REFS);
    SupplierInfo.AppendChild(SupplierRefs);
    SupplierRefs.AppendChild(Document.CreateElement(XML_BUYER_CODE_SUPPLIER, Trim(lsSupplier)));
    SupplierRefs.AppendChild(Document.CreateElement(XML_ALT_BUYER_CODE_SUPPLIER, Trim(lsTempSupp)));

    Defaults.AppendChild(Document.CreateElement(XML_COST_CENTRE, Trim(lsCC)));
    Defaults.AppendChild(Document.CreateElement(XML_DEPARTMENT, Trim(lsDep)));
    Defaults.AppendChild(Document.CreateElement('BinLocation', Trim(lsBinLoc)));

    GLCodes := Document.CreateElement(XML_GL_CODE);
    Defaults.AppendChild(GLCodes);
    GLCodes.AppendChild(Document.CreateElement(XML_GL_SALES, IntToStr(lsDefNom[1])));
    GLCodes.AppendChild(Document.CreateElement(XML_GL_COSTOFSALES, IntToStr(lsDefNom[2])));
    GLCodes.AppendChild(Document.CreateElement(XML_GL_PROFITANDLOSS, IntToStr(lsDefNom[3])));
    GLCodes.AppendChild(Document.CreateElement(XML_GL_BALSHEET, IntToStr(lsDefNom[4])));
    GLCodes.AppendChild(Document.CreateElement(XML_GL_WIP, IntToStr(lsDefNom[5])));
  end;
end; // TWriteXMLStock.WriteLocnDefaultsInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.WriteLocnQuantityInfo;
var
  QuantityInfo : TXmlDElement;
begin
  QuantityInfo := Document.CreateElement(XML_QUANTITY);
  LocationRoot.AppendChild(QuantityInfo);
  with StockLocnInfo^ do
    QuantityInfo.AppendChild(Document.CreateElement('Picked', FloattoStr(lsQtyPicked)));
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.WriteLocnReOrderInfo;
var
  ReOrder : TXmlDElement;
begin
  ReOrder := Document.CreateElement('ReOrder');
  LocationRoot.AppendChild(ReOrder);
  with StockLocnInfo^ do
  begin
    ReOrder.AppendChild(Document.CreateElement(XML_CURRENCY, IntToStr(lsROCurrency)));
    ReOrder.AppendChild(Document.CreateElement(XML_PRICE, FloatToStr(lsROPrice)));
    ReOrder.AppendChild(Document.CreateElement('DeliveryDate', lsRODate));
    ReOrder.AppendChild(Document.CreateElement(XML_COST_CENTRE, lsROCC));
    ReOrder.AppendChild(Document.CreateElement(XML_DEPARTMENT, lsRODep));
  end;
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.WriteLocnSalesInfo;
var
  SalesInfo,
  SalesBand : TXmlDElement;
  Band : integer;
begin
  SalesInfo := Document.CreateElement('SalesInfo');
  LocationRoot.AppendChild(SalesInfo);
  for Band := 1 to 8 do
    with StockLocnInfo^ do
    begin
      SalesBand := Document.CreateElement('Band', ['Reference'], [chr((Band)+ ord('A') -1)]);
      SalesInfo.AppendChild(SalesBand);
      SalesBand.AppendChild(Document.CreateElement(XML_CURRENCY,
        IntToStr(lsSaleBands[Band].Currency)));
      SalesBand.AppendChild(Document.CreateElement('Selling',
        PriceToStr(lsSaleBands[Band].SalesPrice)));
    end;
end; // TWriteXMLStock.WriteLocnSalesInfo

//-----------------------------------------------------------------------------------

procedure TWriteXMLStock.WriteLocnStockLevels;
var
  StockLevels : TXmlDElement;
begin
  StockLevels := Document.CreateElement('StockLevels');
  LocationRoot.AppendChild(StockLevels);
  with StockLocnInfo^ do
  begin
    StockLevels.AppendChild(Document.CreateElement('InStock', FloatToStr(lsQtyInStock)));
    StockLevels.AppendChild(Document.CreateElement('Posted', FloatToStr(lsQtyPosted)));
    StockLevels.AppendChild(Document.CreateElement('Allocated', FloatToStr(lsQtyAlloc)));
    StockLevels.AppendChild(Document.CreateElement('OnOrder', FloatToStr(lsQtyOnOrder)));
    StockLevels.AppendChild(Document.CreateElement('Minumum', FloatToStr(lsQtyMin)));
    StockLevels.AppendChild(Document.CreateElement('Maximum', FloatToStr(lsQtyMax)));
    StockLevels.AppendChild(Document.CreateElement('BelowMin', BooleanToString(lsMinFlg)));
    StockLevels.AppendChild(Document.CreateElement('LastOrder', FloatToStr(lsRoQty)));
    StockLevels.AppendChild(Document.CreateElement('StockTake', FloatToStr(lsQtyTake)));
    StockLevels.AppendChild(Document.CreateElement('FreezeQuantity', FloatToStr(lsQtyFreeze)));
  end;
end;

//-----------------------------------------------------------------------------------

end.

