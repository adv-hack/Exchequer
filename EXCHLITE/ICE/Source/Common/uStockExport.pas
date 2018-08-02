unit uStockExport;

interface

uses
  Classes, SysUtils, ComObj, Controls, Variants,

  // Exchequer units
  GlobVar,
  VarConst,
  BtrvU2,

  // ICE units
  MSXML2_TLB,
  uXmlBaseClass,
  uConsts,
  uCommon,
  uXMLFileManager,
  uExportBaseClass
  ;

{$I ice.inc}

type
  TStockExport = Class(_ExportBase)
  private
    FileManager: TXMLFileManager;
    procedure AddChildRecords(ParentCode: ShortString);
  protected
    function BuildXmlRecord(pStock: Pointer): Boolean; override;
  public
    constructor Create;
    destructor Destroy; override;
    function LoadFromDB: Boolean; override;
  end;

implementation

uses
  uEXCHBaseClass,
  SavePos,
  BtKeys1U,
  Forms
  ;

{ TStockExport }

procedure TStockExport.AddChildRecords(ParentCode: ShortString);
{ Recursive routine for retrieving the Stock tree in the correct order (each
  parent record followed by its child records). }

  function IsValidRecord: Boolean;
  { Returns False if the current record no longer matches the parent code (in
    other words, we have gone past the last child record for this parent). }
  begin
    Result := (FullStockCode(Stock.StockCat) = FullStockCode(ParentCode));
  end;

var
  FuncRes: Integer;
  StockRecPtr: ^StockRec;
  Key: ShortString;
  FileName: string;
  RecNode: IXMLDOMNode;
begin
  { Find the first child record, if any, for this parent code. }
//  Key := FullStockCode(ParentCode);
  Key := ParentCode;
  if (Trim(ParentCode) = '') then
    FuncRes := Find_Rec(B_GetFirst, F[StockF], StockF, RecPtr[StockF]^, StkCatK, Key)
  else
    FuncRes := Find_Rec(B_GetGEq, F[StockF], StockF, RecPtr[StockF]^, StkCatK, Key);
  StockRecPtr := @Stock;
  { Cycle through all the child records. }
  while (FuncRes = 0) and IsValidRecord do
  begin
    Application.ProcessMessages;

    { Free any existing XML document handler (in fActiveXMLDoc), and create a
      new one. }
    CreateXMLDoc;

    { Locate and delete the empty Stock record section, because we are going to
      create multiple entries (rather than simply updating the fields in one
      entry). }
    RecNode := ActiveXMLDoc.Doc;
    try
      RecNode := _GetNodeByName(RecNode, 'message');
      RecNode.removeChild(_GetNodeByName(RecNode, 'stockrec'));
    finally
      RecNode := nil;
    end;

    { Add the record to the XML. }
    BuildXMLRecord(StockRecPtr);

    RemoveComments;

    FileName := FileManager.SaveXML(ActiveXMLDoc.Doc.xml);
    Files.Add(FileName);

    { If the ledger code type is 'Header', it will have child records. }
    if (Stock.StockType = 'G') then
    begin
      { Preserve the current database position (because we are going to call
        this routine recursively, which will move the database cursor to a
        new position). }
      with TBtrieveSavePosition.Create do
      try
        SaveFilePosition(StockF, StkCatK);
        { Process the child records. }
        AddChildRecords(Stock.StockCode);
      finally
        RestoreSavedPosition;
        Free;
      end;
    end;
    FuncRes := Find_Rec(B_GetNext, F[StockF], StockF, RecPtr[StockF]^, StkCatK, Key);
  end;
end;

function TStockExport.LoadFromDB: Boolean;
var
  FuncRes: LongInt;
  ErrorCode: Integer;
begin
  Result := False;

  ErrorCode := 0;

  SetDrive := DataPath;

  FileManager.Directory := DataPath + cICEFOLDER;

  { Remove any existing drip-feed files from the export path. }
  DeleteFiles(FileManager.Directory, FileManager.BaseFileName + '*.xml');

  Clear;

  { Open the Stock table. }
  FuncRes := Open_File(F[StockF], SetDrive + FileNames[StockF], 0);
  if (FuncRes = 0) then
  begin

    { Records with no parent have a blank parent code. Start the processing with
      these records. }
    AddChildRecords('');
//    AddChildRecords(StringOfChar(#0, 16) + #1);

    FuncRes := Close_File(F[StockF]);
    Result := True;
  end
  else
    ErrorCode := cCONNECTINGDBERROR;

  { Log any errors. }
  if (ErrorCode <> 0) then
    DoLogMessage('TStockExport.LoadFromDB', ErrorCode, 'Error: ' + IntToStr(FuncRes));
End;

function TStockExport.BuildXmlRecord(pStock: Pointer): Boolean;
var
  RootNode, Node, SubNode, BandNode: IXMLDomNode;
  SpareStr: string[29];
  i: Integer;
const
  AS_CDATA = True;
Begin
  Result := False;

  With StockRec(pStock^) Do
  Begin
    RootNode := ActiveXMLDoc.Doc;

    { Locate the top node, 'message' -- all the other records will be added as
      child nodes below this node. }
    RootNode := _GetNodeByName(RootNode, 'message');

    if (RootNode <> nil) then
    try

      { Add the record node. }
      Node := RootNode.appendChild(ActiveXMLDoc.Doc.createElement('stockrec'));

      { Add the field nodes. }

      _AddLeafNode(Node, 'stcode',                StockCode    );

      SubNode := Node.appendChild(ActiveXMLDoc.Doc.createElement('stdesc'));
      try
        for i := Low(Desc) to High(Desc) do
          _AddLeafNode(SubNode, 'stdline', Desc[i]);
      finally
        SubNode := nil;
      end;

      _AddLeafNode(Node, 'staltcode',             AltCode      );
      _AddLeafNode(Node, 'sttype',                StockType    );
      _AddLeafNode(Node, 'stsalesgl',             NomCodes[1]  );
      _AddLeafNode(Node, 'stcosgl',               NomCodes[2]  );
      _AddLeafNode(Node, 'stpandlgl',             NomCodes[3]  );
      _AddLeafNode(Node, 'stbalsheetgl',          NomCodes[4]  );
      _AddLeafNode(Node, 'stwipgl',               NomCodes[5]  );
      _AddLeafNode(Node, 'stbelowminlevel',       MinFlg       );
      _AddLeafNode(Node, 'stfolionum',            StockFolio   );
      _AddLeafNode(Node, 'stparentcode',          StockCat     );
      _AddLeafNode(Node, 'stsupptemp',            SuppTemp     );
      _AddLeafNode(Node, 'stunitofstock',         UnitK        );
      _AddLeafNode(Node, 'stunitofsale',          UnitS        );
      _AddLeafNode(Node, 'stunitofpurch',         UnitP        );
      _AddLeafNode(Node, 'stcostpricecur',        PCurrency    );
      _AddLeafNode(Node, 'stcostprice',           CostPrice    );
      _AddLeafNode(Node, 'stsalesunits',          SellUnit     );
      _AddLeafNode(Node, 'stpurchunits',          BuyUnit      );
      _AddLeafNode(Node, 'stvatcode',             VATCode      );
      _AddLeafNode(Node, 'stcostcentre',          CCDep[BOn]   );
      _AddLeafNode(Node, 'stdepartment',          CCDep[BOff]  );
      _AddLeafNode(Node, 'stqtyinstock',          QtyInStock   );
      _AddLeafNode(Node, 'stqtyposted',           QtyPosted    );
      _AddLeafNode(Node, 'stqtyallocated',        QtyAllocated );
      _AddLeafNode(Node, 'stqtyonorder',          QtyOnOrder   );
      _AddLeafNode(Node, 'stqtymin',              QtyMin       );
      _AddLeafNode(Node, 'stqtymax',              QtyMax       );
      _AddLeafNode(Node, 'stbinlocation',         BinLoc       );
      _AddLeafNode(Node, 'stanalysiscode',        JAnalCode    );

      SubNode := Node.appendChild(ActiveXMLDoc.Doc.createElement('stsalesbands'));
      try
        for i := Low(SaleBands) to High(SaleBands) do
        begin
          BandNode := SubNode.appendChild(ActiveXMLDoc.Doc.createElement('stsband'));
          _AddLeafNode(BandNode, 'stscurrency', SaleBands[i].Currency);
          _AddLeafNode(BandNode, 'stsprice', SaleBands[i].SalesPrice);
        end;
      finally
        SubNode := nil;
      end;

      _AddLeafNode(Node, 'sttimechange',          TimeChange   );
      _AddLeafNode(Node, 'stinclusivevatcode',    SVATIncFlg   );
      _AddLeafNode(Node, 'stoperator',            LastOpo      );
      _AddLeafNode(Node, 'stsupplier',            Supplier     );
      _AddLeafNode(Node, 'stdefaultlinetype',     StkLinkLT    );
      _AddLeafNode(Node, 'stvaluationmethod',     StkValType   );
      _AddLeafNode(Node, 'stqtypicked',           QtyPicked    );
      _AddLeafNode(Node, 'stlastused',            LastUsed     );
      _AddLeafNode(Node, 'stbarcode',             BarCode      );
      _AddLeafNode(Node, 'stlocation',            DefMLoc      );
      _AddLeafNode(Node, 'stshowqtyaspacks',      DPackQty     );
      _AddLeafNode(Node, 'stuserfield1',          StkUser1     );
      _AddLeafNode(Node, 'stuserfield2',          StkUser2     );
      _AddLeafNode(Node, 'stuserfield3',          StkUser3     );
      _AddLeafNode(Node, 'stuserfield4',          StkUser4     );
      _AddLeafNode(Node, 'stshowkitonpurchase',   KitOnPurch   );
      _AddLeafNode(Node, 'stimagefile',           ImageFile    );
      _AddLeafNode(Node, 'stweblivecatalog',      WebLiveCat   );
      _AddLeafNode(Node, 'stwebprevcatalog',      WebPrevCat   );
      _AddLeafNode(Node, 'stuseforebus',          WebInclude   );
      _AddLeafNode(Node, 'stusecover',            UseCover     );
      _AddLeafNode(Node, 'stcoverperiods',        CovPr        );
      _AddLeafNode(Node, 'stcoverperiodunits',    CovPrUnit    );
      _AddLeafNode(Node, 'stcoverminperiods',     CovMinPr     );
      _AddLeafNode(Node, 'stcoverminperiodunits', CovMinUnit   );
      _AddLeafNode(Node, 'stcoverqtysold',        CovSold      );
      _AddLeafNode(Node, 'stcovermaxperiods',     CovMaxPr     );
      _AddLeafNode(Node, 'stcovermaxperiodunits', CovMaxUnit   );
      _AddLeafNode(Node, 'stblinecount',          BLineCount   );
      _AddLeafNode(Node, 'sthasserno',            HasSerNo     );
      _AddLeafNode(Node, 'ststkflg',              StkFlg       );
      _AddLeafNode(Node, 'stqtyfreeze',           QtyFreeze    );
      _AddLeafNode(Node, 'stcalcpack',            CalcPack     );
      _AddLeafNode(Node, 'stcommodcode',          CommodCode   );
      _AddLeafNode(Node, 'strocc',                ROCCDep[BOn] );
      _AddLeafNode(Node, 'strodep',               ROCCDep[BOff]);
      _AddLeafNode(Node, 'stpricepack',           PricePack    );
      _AddLeafNode(Node, 'stkitprice',            KitPrice     );
      _AddLeafNode(Node, 'stqtyreturn',           QtyReturn    );
      _AddLeafNode(Node, 'stqtyallocwor',         QtyAllocWOR  );
      _AddLeafNode(Node, 'stqtyissuewor',         QtyIssueWOR  );
      _AddLeafNode(Node, 'stsernowavg',           SerNoWAvg    );
      _AddLeafNode(Node, 'ststksizecol',          StkSizeCol   );
      _AddLeafNode(Node, 'stssdduplift',          SSDDUplift   );
      _AddLeafNode(Node, 'stssdcountry',          SSDCountry   );
      _AddLeafNode(Node, 'stssdauplift',          SSDAUpLift   );
      _AddLeafNode(Node, 'stprivaterec',          PrivateRec   );
      _AddLeafNode(Node, 'sttempbloc',            TempBLoc     );
      _AddLeafNode(Node, 'stqtypickwor',          QtyPickWOR   );
      _AddLeafNode(Node, 'stwopwipgl',            WOPWIPGL     );
      _AddLeafNode(Node, 'stprodtime',            ProdTime     );
      _AddLeafNode(Node, 'stleadtime',            Leadtime     );
      _AddLeafNode(Node, 'stcalcprodtime',        CalcProdTime );
      _AddLeafNode(Node, 'stbomprodtime',         BOMProdTime  );
      _AddLeafNode(Node, 'stmineccqty',           MinEccQty    );
      _AddLeafNode(Node, 'stmultibinmode',        MultiBinMode );
      _AddLeafNode(Node, 'stswarranty',           SWarranty    );
      _AddLeafNode(Node, 'stswarrantytype',       SWarrantyType);
      _AddLeafNode(Node, 'stmwarranty',           MWarranty    );
      _AddLeafNode(Node, 'stmwarrantytype',       MWarrantyType);
      _AddLeafNode(Node, 'stqtypreturn',          QtyPReturn   );
      _AddLeafNode(Node, 'streturngl',            ReturnGL     );
      _AddLeafNode(Node, 'strestockpcnt',         ReStockPcnt  );
      _AddLeafNode(Node, 'strestockgl',           ReStockGL    );
      _AddLeafNode(Node, 'stbomdedcomp',          BOMDedComp   );
      _AddLeafNode(Node, 'stpreturngl',           PReturnGL    );
      _AddLeafNode(Node, 'strestockpchr',         ReStockPChr  );
      _AddLeafNode(Node, 'stroflg',               ROFlg        );
      _AddLeafNode(Node, 'stnlinecount',          NLineCount   );
      _AddLeafNode(Node, 'stroqty',               ROQty        );
      _AddLeafNode(Node, 'stsubassyflg',          SubAssyFlg   );
      _AddLeafNode(Node, 'stshowaskit',           ShowasKit    );
      _AddLeafNode(Node, 'strocurrency',          ROCurrency   );
      _AddLeafNode(Node, 'strocprice',            ROCPrice     );
      _AddLeafNode(Node, 'strodate',              RODate       );
      _AddLeafNode(Node, 'stqtytake',             QtyTake      );
      _AddLeafNode(Node, 'stsweight',             SWeight      );
      _AddLeafNode(Node, 'stpweight',             PWeight      );
      _AddLeafNode(Node, 'stunitsupp',            UnitSupp     );
      _AddLeafNode(Node, 'stsuppsunit',           SuppSUnit    );
      _AddLeafNode(Node, 'stspare',               Spare        );

      Move(Spare2[1], SpareStr[1], Length(SpareStr));
      _AddLeafNode(Node, 'stspare2',              SpareStr, AS_CDATA);

      Node := nil;
      RootNode := nil;
      Result := True;
    Except
      On e: Exception Do
        DoLogMessage('TStockExport.BuildXml', cBUILDINGXMLERROR, 'Error: ' +
          e.message);
    End
    Else
      DoLogMessage('TStockExport.BuildXml', cINVALIDXMLNODE);
  End;
End;

constructor TStockExport.Create;
begin
  inherited Create;
  UseFiles := True;
  FileManager := TXMLFileManager.Create;
  FileManager.BaseFileName := 'stk'
end;

destructor TStockExport.Destroy;
begin
  FileManager.Free;
  inherited;
end;

end.
