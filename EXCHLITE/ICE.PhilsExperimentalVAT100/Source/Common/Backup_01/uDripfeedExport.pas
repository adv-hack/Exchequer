unit uDripfeedExport;
{ ORIGINAL VERSION: Includes references to TICETrack for recording edits 
  to transactions, but these are no longer allowed. }

interface

uses
  Classes, SysUtils, ComObj, Controls, Variants, Forms, Contnrs,
  // Exchequer units
  Enterprise01_Tlb,
  EnterpriseBeta_Tlb,
  GlobVar,
  VarConst,
  BtrvU2,

  // ICE units
  MSXML2_TLB,
  uXmlBaseClass,
  uConsts,
  uCommon,
  uExportBaseClass,
  uXMLFileManager,
  uXMLWriter,
  uTransactionTracker,
  uICETrack
  ;

{$I ice.inc}

type
  TAlreadyExportedType = (aeCostCentre, aeDepartment, aeStockGroup);

  TAlreadyExported = class(TObject)
  private
    Lists: TObjectList;
    function GetItem(ListType: TAlreadyExportedType;
      Code: ShortString): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(ListType: TAlreadyExportedType; Code: ShortString);
    procedure Clear;
    property Includes[ListType: TAlreadyExportedType; Code: ShortString]: Boolean
      read GetItem; default;
  end;

  TDripfeedExport = class(_ExportBase)
  private
    fFromDate: TDateTime;
    fToDate: TDateTime;
    oToolkit: IToolkit;
    fOutputDirectory: string;
    FileManager: TXMLFileManager;
    Tracker: TTransactionTracker;
    EditTrack: TICETrack;
    XMLWriter: TXMLWriter;
    AlreadyExported: TAlreadyExported;
    StockGroups: TStringList;
    fRecordsPerFile: Integer;
    function AddAccount(Code: ShortString): Boolean;
    function AddCostCentre(Code: ShortString): Boolean;
    function AddDepartment(Code: ShortString): Boolean;
    function AddTransactionHeader: Boolean;
    function AddMatchingRecords: Boolean;
    function AddStockGroup(Code: ShortString): Boolean;
    function AddStockItem(Code: ShortString): Boolean;
    function AddTransactionLines: Boolean;
    function BuildRecord: Boolean;
    function BuildLineRecord(Line: ITransactionLine3): Boolean;
    function CloseCostCentreFile: Boolean;
    function OpenCostCentreFile: Boolean;
    function OpenCustFile: Boolean;
    function CloseCustFile: Boolean;
    function OpenStockFile: Boolean;
    function CloseStockFile: Boolean;
    procedure SetOutputDirectory(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    function LoadFromDB: Boolean; override;
    property FromDate: TDateTime read fFromDate write fFromDate;
    property RecordsPerFile: Integer read fRecordsPerFile write fRecordsPerFile;
    property ToDate: TDateTime read fToDate write fToDate;
    property OutputDirectory: string
      read fOutputDirectory write SetOutputDirectory;
  end;

implementation

uses
  CTKUtil,
  DateUtils,
  BtKeys1U
  ;

const
  VATCodes:       array[1..23] of Char = ('S','E','Z','M','I','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');
  VATCodesLessMI: array[1..21] of Char = ('S','E','Z','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');

// ===========================================================================
// TDripfeedExport
// ===========================================================================

function TDripfeedExport.AddAccount(Code: ShortString): Boolean;
var
  SpareStr: string[109];
  FuncRes: LongInt;
  Key: ShortString;
begin
  Result := True;
  if (Trim(Code) <> '') then
  begin
    Key := FullCustCode(Code);
    FuncRes := Find_Rec(B_GetEq, F[CustF], CustF, RecPtr[CustF]^, CustCodeK, Key);
    if (FuncRes = 0) then
    with Cust do
    try
      XMLWriter.AddOpeningTag('custrec');

      XMLWriter.AddLeafTag('accode',               CustCode);
      XMLWriter.AddLeafTag('accompany',            Company);
      XMLWriter.AddLeafTag('acarea',               AreaCode);
      XMLWriter.AddLeafTag('acacctype',            CustSupp);
      XMLWriter.AddLeafTag('acstatementto',        RemitCode);
      XMLWriter.AddLeafTag('acvatregno',           VATRegNo);

      XMLWriter.AddOpeningTag('acaddress');
      XMLWriter.AddLeafTag('acstreet1',            Addr[1]);
      XMLWriter.AddLeafTag('acstreet2',            Addr[2]);
      XMLWriter.AddLeafTag('actown',               Addr[3]);
      XMLWriter.AddLeafTag('accounty',             Addr[4]);
      XMLWriter.AddLeafTag('acpostcode',           Addr[5]);
      XMLWriter.AddClosingTag('acaddress');

      XMLWriter.AddOpeningTag('acdeladdress');
      XMLWriter.AddLeafTag('acstreet1',            DAddr[1]);
      XMLWriter.AddLeafTag('acstreet2',            DAddr[2]);
      XMLWriter.AddLeafTag('actown',               DAddr[3]);
      XMLWriter.AddLeafTag('accounty',             DAddr[4]);
      XMLWriter.AddLeafTag('acpostcode',           DAddr[5]);
      XMLWriter.AddClosingTag('acdeladdress');

      XMLWriter.AddLeafTag('accontact',            Contact);
      XMLWriter.AddLeafTag('acphone',              Phone);
      XMLWriter.AddLeafTag('acfax',                Fax);
      XMLWriter.AddLeafTag('actheiracc',           RefNo);
      XMLWriter.AddLeafTag('acowntradterm',        TradTerm);

      XMLWriter.AddOpeningTag('actradeterms');
      XMLWriter.AddLeafTag('acterm1',              STerms[1]);
      XMLWriter.AddLeafTag('acterm2',              STerms[2]);
      XMLWriter.AddClosingTag('actradeterms');

      XMLWriter.AddLeafTag('accurrency',           Currency);
      XMLWriter.AddLeafTag('acvatcode',            VATCode);
      XMLWriter.AddLeafTag('acpayterms',           PayTerms);
      XMLWriter.AddLeafTag('accreditlimit',        CreditLimit);
      XMLWriter.AddLeafTag('acdiscount',           Discount);
      XMLWriter.AddLeafTag('accreditstatus',       CreditStatus);
      XMLWriter.AddLeafTag('accostcentre',         CustCC);
      XMLWriter.AddLeafTag('acdiscountband',       CDiscCh);
      XMLWriter.AddLeafTag('acdepartment',         CustDep);
      XMLWriter.AddLeafTag('acecmember',           EECMember);
      XMLWriter.AddLeafTag('acstatement',          IncStat);
      XMLWriter.AddLeafTag('acsalesgl',            DefNomCode);
      XMLWriter.AddLeafTag('aclocation',           DefMLocStk);
      XMLWriter.AddLeafTag('acaccstatus',          AccStatus);
      XMLWriter.AddLeafTag('acpaytype',            PayType);
      XMLWriter.AddLeafTag('acbanksort',           BankSort);
      XMLWriter.AddLeafTag('acbankacc',            BankAcc);
      XMLWriter.AddLeafTag('acbankref',            BankRef);
      XMLWriter.AddLeafTag('aclastused',           LastUsed);
      XMLWriter.AddLeafTag('acphone2',             Phone2);
      XMLWriter.AddLeafTag('acuserdef1',           UserDef1);
      XMLWriter.AddLeafTag('acuserdef2',           UserDef2);
      XMLWriter.AddLeafTag('acinvoiceto',          SOPInvCode);
      XMLWriter.AddLeafTag('acsopautowoff',        SOPAutoWOff);
      XMLWriter.AddLeafTag('acbookordval',         BOrdVal);
      XMLWriter.AddLeafTag('accosgl',              DefCOSNom);
      XMLWriter.AddLeafTag('acdrcrgl',             DefCtrlNom);
      XMLWriter.AddLeafTag('acdirdebmode',         DirDeb);
      XMLWriter.AddLeafTag('acccstart',            CCDSDate);
      XMLWriter.AddLeafTag('acccend',              CCDEDate);
      XMLWriter.AddLeafTag('acccname',             CCDName);
      XMLWriter.AddLeafTag('acccnumber',           CCDCardNo);
      XMLWriter.AddLeafTag('acccswitch',           CCDSARef);
      XMLWriter.AddLeafTag('acdefsettledays',      DefSetDDays);
      XMLWriter.AddLeafTag('acdefsettledisc',      DefSetDisc);
      XMLWriter.AddLeafTag('acformset',            FDefPageNo);
      XMLWriter.AddLeafTag('acstatedeliverymode',  StatDMode);
      XMLWriter.AddLeafTag('acemailaddr',          EmailAddr);
      XMLWriter.AddLeafTag('acsendreader',         EmlSndRdr);
      XMLWriter.AddLeafTag('acebuspword',          EmlSndRdr);
      XMLWriter.AddLeafTag('acaltcode',            CustCode2);
      XMLWriter.AddLeafTag('acpostcode',           PostCode);
      XMLWriter.AddLeafTag('acuseforebus',         AllowWeb);
      XMLWriter.AddLeafTag('aczipattachments',     EmlZipAtc);
      XMLWriter.AddLeafTag('acuserdef3',           UserDef3);
      XMLWriter.AddLeafTag('acuserdef4',           UserDef4);
      XMLWriter.AddLeafTag('actimestamp',          TimeChange);
      XMLWriter.AddLeafTag('acssddeliveryterms',   SSDDelTerms);
      XMLWriter.AddLeafTag('acinclusivevatcode',   CVATIncFlg);
      XMLWriter.AddLeafTag('acssdmodeoftransport', SSDModeTr);
      XMLWriter.AddLeafTag('aclastoperator',       LastOpo);
      XMLWriter.AddLeafTag('acdocdeliverymode',    InvDMode);
      XMLWriter.AddLeafTag('acsendhtml',           EmlSndHtml);
      XMLWriter.AddLeafTag('acweblivecatalog',     WebLiveCat);
      XMLWriter.AddLeafTag('acwebprevcatalog',     WebPrevCat);
      XMLWriter.AddLeafTag('acsopconsho',          SOPConsHO);
      XMLWriter.AddLeafTag('acdeftagno',           DefTagNo);
      XMLWriter.AddLeafTag('acordconsmode',        OrdConsMode);

      SpareStr := Spare;
      XMLWriter.AddLeafTag('spare', SpareStr);

      XMLWriter.AddLeafTag('spare2', Spare2);

      XMLWriter.AddLeafTag('spare51', Spare5[1]);
      XMLWriter.AddLeafTag('spare52', Spare5[2]);

      XMLWriter.AddClosingTag('custrec');
    except

    end;
  end;
end;

// ---------------------------------------------------------------------------

function TDripfeedExport.AddCostCentre(Code: ShortString): Boolean;
var
  FuncRes: Integer;
  RecPFix, SubType: Char;
  Key: ShortString;
begin
  Result := True;
  if (Trim(Code) <> '') and not AlreadyExported[aeCostCentre, Code] then
  begin
    { Find the Cost Centre record. }
    RecPfix := CostCCode;
    Subtype := CSubCode[True];
    Key := FullCCKey(RecPFix, SubType, Code);
    FuncRes := Find_Rec(B_GetEq, F[PwrdF], PwrdF, RecPtr[PwrdF]^, 0, Key);
    if (FuncRes = 0) then
    begin
      XMLWriter.AddOpeningTag('ccrec');
      XMLWriter.AddLeafTag('cdcode', Password.CostCtrRec.PCostC);
      XMLWriter.AddLeafTag('cdname', Password.CostCtrRec.CCDesc);
      XMLWriter.AddClosingTag('ccrec');
    end;
    AlreadyExported.Add(aeCostCentre, Code);
  end;
end;

// ---------------------------------------------------------------------------

function TDripfeedExport.AddDepartment(Code: ShortString): Boolean;
var
  FuncRes: Integer;
  RecPFix, SubType: Char;
  Key: ShortString;
begin
  Result := True;
  if (Trim(Code) <> '') and not AlreadyExported[aeDepartment, Code] then
  begin
    { Find the Department record. }
    RecPfix := CostCCode;
    Subtype := CSubCode[False];
    Key := FullCCKey(RecPFix, SubType, Code);
    FuncRes := Find_Rec(B_GetEq, F[PwrdF], PwrdF, RecPtr[PwrdF]^, 0, Key);
    if (FuncRes = 0) then
    begin
      XMLWriter.AddOpeningTag('deptrec');
      XMLWriter.AddLeafTag('cdcode', Password.CostCtrRec.PCostC);
      XMLWriter.AddLeafTag('cdname', Password.CostCtrRec.CCDesc);
      XMLWriter.AddClosingTag('deptrec');
    end;
    AlreadyExported.Add(aeDepartment, Code);
  end;
end;

// ---------------------------------------------------------------------------

function TDripfeedExport.AddMatchingRecords: Boolean;
var
  oMatching: IMatching2;
  FuncRes: Integer;
begin
  Result := False;
  oMatching := oToolkit.Transaction.thMatching as IMatching2;
  try
    FuncRes := oMatching.GetFirst;
    try
      while (FuncRes = 0) do
      begin
        { Add the record node. }
        XMLWriter.AddOpeningTag('matchrec');

        XMLWriter.AddLeafTag('madocyourref',  oMatching.maDocYourRef);
        XMLWriter.AddLeafTag('madocref',      oMatching.maDocRef);
        XMLWriter.AddLeafTag('mapayref',      oMatching.maPayRef);
        XMLWriter.AddLeafTag('matype',        oMatching.maType);
        XMLWriter.AddLeafTag('madoccurrency', oMatching.maDocCurrency);
        XMLWriter.AddLeafTag('madocvalue',    oMatching.maDocValue);
        XMLWriter.AddLeafTag('mapaycurrency', oMatching.maPayCurrency);
        XMLWriter.AddLeafTag('mapayvalue',    oMatching.maPayValue);
        XMLWriter.AddLeafTag('mabasevalue',   oMatching.maBaseValue);

        XMLWriter.AddClosingTag('matchrec');

        FuncRes := oMatching.GetNext;
      end;
      Result := True;
    except
      On e:Exception Do
        DoLogMessage('TMatchingExport.BuildRecord', cBUILDINGXMLERROR, 'Error: ' +
          e.message);
    end;
  finally
    oMatching := nil;
  end;
end;

// ---------------------------------------------------------------------------

function TDripfeedExport.AddStockGroup(Code: ShortString): Boolean;
var
  i: Integer;
  Key: ShortString;
  FuncRes: LongInt;
begin
  Result := True;
  XMLWriter.AddOpeningTag('stockgroup');
  Key := FullStockCode(Code);
  FuncRes := Find_Rec(B_GetEq, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, Key);
  with Stock do
  begin
    XMLWriter.AddLeafTag('stcode',                StockCode    );

    XMLWriter.AddOpeningTag('stdesc');
    for i := Low(Desc) to High(Desc) do
      XMLWriter.AddLeafTag('stdline', Desc[i]);
    XMLWriter.AddClosingTag('stdesc');

    XMLWriter.AddLeafTag('sttype',                StockType    );
    XMLWriter.AddLeafTag('stparentcode',          StockCat     );
    XMLWriter.AddLeafTag('stunitofstock',         'each'       );
    XMLWriter.AddLeafTag('stunitofsale',          'each'       );
    XMLWriter.AddLeafTag('stunitofpurch',         'each'       );
    XMLWriter.AddLeafTag('stsalesunits',          1.0          );
    XMLWriter.AddLeafTag('stpurchunits',          1.0          );
  end;
  XMLWriter.AddClosingTag('stockgroup');
end;

// ---------------------------------------------------------------------------

function TDripfeedExport.AddStockItem(Code: ShortString): Boolean;
var
  FuncRes: LongInt;
  GroupCode: ShortString;
  GroupKey, Key: ShortString;
  i: Integer;
  SpareStr: string[29];
begin
  Result := True;
  { Locate the record. }
  Key := FullStockCode(Code);
  FuncRes := Find_Rec(B_GetEq, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, Key);
  { Build a list of all the parent items. }
  while (FuncRes = 0) and (Trim(Stock.StockCat) <> '') do
  begin
    GroupCode := Trim(Stock.StockCat);
    { Add the parent code to the list. }
    if not AlreadyExported[aeStockGroup, GroupCode] then
    begin
      StockGroups.Insert(0, GroupCode);
      AlreadyExported.Add(aeStockGroup, GroupCode);
    end;
    { Find the parent record. }
    GroupKey := FullStockCode(GroupCode);
    FuncRes := Find_Rec(B_GetEq, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, GroupKey);
  end;
  { Add the Stock Item. }
  Key := FullStockCode(Code);
  FuncRes := Find_Rec(B_GetEq, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, Key);
  XMLWriter.AddOpeningTag('stockrec');
  with Stock do
  begin
    XMLWriter.AddLeafTag('stcode',                StockCode    );

    XMLWriter.AddOpeningTag('stdesc');
    for i := Low(Desc) to High(Desc) do
      XMLWriter.AddLeafTag('stdline', Desc[i]);
    XMLWriter.AddClosingTag('stdesc');

    XMLWriter.AddLeafTag('staltcode',             AltCode      );
    XMLWriter.AddLeafTag('sttype',                StockType    );
    XMLWriter.AddLeafTag('stsalesgl',             NomCodes[1]  );
    XMLWriter.AddLeafTag('stcosgl',               NomCodes[2]  );
    XMLWriter.AddLeafTag('stpandlgl',             NomCodes[3]  );
    XMLWriter.AddLeafTag('stbalsheetgl',          NomCodes[4]  );
    XMLWriter.AddLeafTag('stwipgl',               NomCodes[5]  );
    XMLWriter.AddLeafTag('stbelowminlevel',       MinFlg       );
    XMLWriter.AddLeafTag('stfolionum',            StockFolio   );
    XMLWriter.AddLeafTag('stparentcode',          StockCat     );
    XMLWriter.AddLeafTag('stsupptemp',            SuppTemp     );
    XMLWriter.AddLeafTag('stunitofstock',         UnitK        );
    XMLWriter.AddLeafTag('stunitofsale',          UnitS        );
    XMLWriter.AddLeafTag('stunitofpurch',         UnitP        );
    XMLWriter.AddLeafTag('stcostpricecur',        PCurrency    );
    XMLWriter.AddLeafTag('stcostprice',           CostPrice    );
    XMLWriter.AddLeafTag('stsalesunits',          SellUnit     );
    XMLWriter.AddLeafTag('stpurchunits',          BuyUnit      );
    XMLWriter.AddLeafTag('stvatcode',             VATCode      );
    XMLWriter.AddLeafTag('stcostcentre',          CCDep[BOn]   );
    XMLWriter.AddLeafTag('stdepartment',          CCDep[BOff]  );
    XMLWriter.AddLeafTag('stqtyinstock',          QtyInStock   );
    XMLWriter.AddLeafTag('stqtyposted',           QtyPosted    );
    XMLWriter.AddLeafTag('stqtyallocated',        QtyAllocated );
    XMLWriter.AddLeafTag('stqtyonorder',          QtyOnOrder   );
    XMLWriter.AddLeafTag('stqtymin',              QtyMin       );
    XMLWriter.AddLeafTag('stqtymax',              QtyMax       );
    XMLWriter.AddLeafTag('stbinlocation',         BinLoc       );
    XMLWriter.AddLeafTag('stanalysiscode',        JAnalCode    );

    XMLWriter.AddOpeningTag('stsalesbands');
    for i := Low(SaleBands) to High(SaleBands) do
    begin
      XMLWriter.AddOpeningTag('stsband');
      XMLWriter.AddLeafTag('stscurrency', SaleBands[i].Currency);
      XMLWriter.AddLeafTag('stsprice', SaleBands[i].SalesPrice);
      XMLWriter.AddClosingTag('stsband');
    end;
    XMLWriter.AddClosingTag('stsalesbands');

    XMLWriter.AddLeafTag('sttimechange',          TimeChange   );
    XMLWriter.AddLeafTag('stinclusivevatcode',    SVATIncFlg   );
    XMLWriter.AddLeafTag('stoperator',            LastOpo      );
    XMLWriter.AddLeafTag('stsupplier',            Supplier     );
    XMLWriter.AddLeafTag('stdefaultlinetype',     StkLinkLT    );
    XMLWriter.AddLeafTag('stvaluationmethod',     StkValType   );
    XMLWriter.AddLeafTag('stqtypicked',           QtyPicked    );
    XMLWriter.AddLeafTag('stlastused',            LastUsed     );
    XMLWriter.AddLeafTag('stbarcode',             BarCode      );
    XMLWriter.AddLeafTag('stlocation',            DefMLoc      );
    XMLWriter.AddLeafTag('stshowqtyaspacks',      DPackQty     );
    XMLWriter.AddLeafTag('stuserfield1',          StkUser1     );
    XMLWriter.AddLeafTag('stuserfield2',          StkUser2     );
    XMLWriter.AddLeafTag('stuserfield3',          StkUser3     );
    XMLWriter.AddLeafTag('stuserfield4',          StkUser4     );
    XMLWriter.AddLeafTag('stshowkitonpurchase',   KitOnPurch   );
    XMLWriter.AddLeafTag('stimagefile',           ImageFile    );
    XMLWriter.AddLeafTag('stweblivecatalog',      WebLiveCat   );
    XMLWriter.AddLeafTag('stwebprevcatalog',      WebPrevCat   );
    XMLWriter.AddLeafTag('stuseforebus',          WebInclude   );
    XMLWriter.AddLeafTag('stusecover',            UseCover     );
    XMLWriter.AddLeafTag('stcoverperiods',        CovPr        );
    XMLWriter.AddLeafTag('stcoverperiodunits',    CovPrUnit    );
    XMLWriter.AddLeafTag('stcoverminperiods',     CovMinPr     );
    XMLWriter.AddLeafTag('stcoverminperiodunits', CovMinUnit   );
    XMLWriter.AddLeafTag('stcoverqtysold',        CovSold      );
    XMLWriter.AddLeafTag('stcovermaxperiods',     CovMaxPr     );
    XMLWriter.AddLeafTag('stcovermaxperiodunits', CovMaxUnit   );
    XMLWriter.AddLeafTag('stblinecount',          BLineCount   );
    XMLWriter.AddLeafTag('sthasserno',            HasSerNo     );
    XMLWriter.AddLeafTag('ststkflg',              StkFlg       );
    XMLWriter.AddLeafTag('stqtyfreeze',           QtyFreeze    );
    XMLWriter.AddLeafTag('stcalcpack',            CalcPack     );
    XMLWriter.AddLeafTag('stcommodcode',          CommodCode   );
    XMLWriter.AddLeafTag('strocc',                ROCCDep[BOn] );
    XMLWriter.AddLeafTag('strodep',               ROCCDep[BOff]);
    XMLWriter.AddLeafTag('stpricepack',           PricePack    );
    XMLWriter.AddLeafTag('stkitprice',            KitPrice     );
    XMLWriter.AddLeafTag('stqtyreturn',           QtyReturn    );
    XMLWriter.AddLeafTag('stqtyallocwor',         QtyAllocWOR  );
    XMLWriter.AddLeafTag('stqtyissuewor',         QtyIssueWOR  );
    XMLWriter.AddLeafTag('stsernowavg',           SerNoWAvg    );
    XMLWriter.AddLeafTag('ststksizecol',          StkSizeCol   );
    XMLWriter.AddLeafTag('stssdduplift',          SSDDUplift   );
    XMLWriter.AddLeafTag('stssdcountry',          SSDCountry   );
    XMLWriter.AddLeafTag('stssdauplift',          SSDAUpLift   );
    XMLWriter.AddLeafTag('stprivaterec',          PrivateRec   );
    XMLWriter.AddLeafTag('sttempbloc',            TempBLoc     );
    XMLWriter.AddLeafTag('stqtypickwor',          QtyPickWOR   );
    XMLWriter.AddLeafTag('stwopwipgl',            WOPWIPGL     );
    XMLWriter.AddLeafTag('stprodtime',            ProdTime     );
    XMLWriter.AddLeafTag('stleadtime',            Leadtime     );
    XMLWriter.AddLeafTag('stcalcprodtime',        CalcProdTime );
    XMLWriter.AddLeafTag('stbomprodtime',         BOMProdTime  );
    XMLWriter.AddLeafTag('stmineccqty',           MinEccQty    );
    XMLWriter.AddLeafTag('stmultibinmode',        MultiBinMode );
    XMLWriter.AddLeafTag('stswarranty',           SWarranty    );
    XMLWriter.AddLeafTag('stswarrantytype',       SWarrantyType);
    XMLWriter.AddLeafTag('stmwarranty',           MWarranty    );
    XMLWriter.AddLeafTag('stmwarrantytype',       MWarrantyType);
    XMLWriter.AddLeafTag('stqtypreturn',          QtyPReturn   );
    XMLWriter.AddLeafTag('streturngl',            ReturnGL     );
    XMLWriter.AddLeafTag('strestockpcnt',         ReStockPcnt  );
    XMLWriter.AddLeafTag('strestockgl',           ReStockGL    );
    XMLWriter.AddLeafTag('stbomdedcomp',          BOMDedComp   );
    XMLWriter.AddLeafTag('stpreturngl',           PReturnGL    );
    XMLWriter.AddLeafTag('strestockpchr',         ReStockPChr  );
    XMLWriter.AddLeafTag('stroflg',               ROFlg        );
    XMLWriter.AddLeafTag('stnlinecount',          NLineCount   );
    XMLWriter.AddLeafTag('stroqty',               ROQty        );
    XMLWriter.AddLeafTag('stsubassyflg',          SubAssyFlg   );
    XMLWriter.AddLeafTag('stshowaskit',           ShowasKit    );
    XMLWriter.AddLeafTag('strocurrency',          ROCurrency   );
    XMLWriter.AddLeafTag('strocprice',            ROCPrice     );
    XMLWriter.AddLeafTag('strodate',              RODate       );
    XMLWriter.AddLeafTag('stqtytake',             QtyTake      );
    XMLWriter.AddLeafTag('stsweight',             SWeight      );
    XMLWriter.AddLeafTag('stpweight',             PWeight      );
    XMLWriter.AddLeafTag('stunitsupp',            UnitSupp     );
    XMLWriter.AddLeafTag('stsuppsunit',           SuppSUnit    );
    XMLWriter.AddLeafTag('stspare',               Spare        );

    Move(Spare2[1], SpareStr[1], Length(SpareStr));
    XMLWriter.AddLeafTag('stspare2',              SpareStr);
  end;
  XMLWriter.AddClosingTag('stockrec');

end;

// ---------------------------------------------------------------------------

function TDripfeedExport.AddTransactionHeader: Boolean;

  function IsPaymentOrReceipt(Ref: string): Boolean;
  begin
    Result := (Uppercase(Copy(Ref, 1, 3)) = 'PPY') or
              (Uppercase(Copy(Ref, 1, 3)) = 'SRC');
  end;

  function IsInvoice(Ref: string): Boolean;
  begin
    Result := (Uppercase(Copy(Ref, 1, 3)) = 'SIN') or
              (Uppercase(Copy(Ref, 1, 3)) = 'PIN') or
              (Uppercase(Copy(Ref, 1, 3)) = 'ADJ') or
              (Uppercase(Copy(Ref, 1, 3)) = 'SCR');
  end;

var
  oTrans: ITransaction3;
  i: Integer;
  LineType: TTransactionLineType;
  RunNo: LongInt;
  RunStr: ShortString;
begin
  Result := True;
  oTrans := oToolkit.Transaction as ITransaction3;
  try
    XMLWriter.AddLeafTag('thaccode',        oTrans.thAcCode);
    XMLWriter.AddLeafTag('thourref',        oTrans.thOurRef);
    XMLWriter.AddLeafTag('thamountsettled', oTrans.thAmountSettled);
    if (Trim(oTrans.thJobCode) = '') then
      XMLWriter.AddLeafTag('thanalysiscode',  oTrans.thAnalysisCode)
    else
      XMLWriter.AddLeafTag('thanalysiscode',  '');

    if (oTrans.thAsApplication <> nil) then
    with oTrans.thAsApplication do
    begin
      XMLWriter.AddOpeningTag('thasapplication');
      XMLWriter.AddLeafTag('tpapplicationbasis', tpApplicationBasis);
      XMLWriter.AddLeafTag('tpapplied',          tpApplied);
      XMLWriter.AddLeafTag('tpappsinterimflag',  tpAppsInterimFlag);
      XMLWriter.AddLeafTag('tpatr',              tpATR);
      XMLWriter.AddLeafTag('tpcertified',        tpCertified);
      XMLWriter.AddLeafTag('tpcertifiedvalue',   tpCertifiedValue);
      XMLWriter.AddLeafTag('tpcisdate',          tpCISDate);
      XMLWriter.AddLeafTag('tpcismanualtax',     tpCISManualTax);
      XMLWriter.AddLeafTag('tpcissource',        tpCISSource);
      XMLWriter.AddLeafTag('tpcistaxdeclared',   tpCISTaxDeclared);
      XMLWriter.AddLeafTag('tpcistaxdue',        tpCISTaxDue);
      XMLWriter.AddLeafTag('tpcistotalgross',    tpCISTotalGross);
      XMLWriter.AddLeafTag('tpdefervat',         tpDeferVAT);
      XMLWriter.AddLeafTag('tpemployeecode',     tpEmployeeCode);
      XMLWriter.AddLeafTag('tpparentterms',      tpParentTerms);
      XMLWriter.AddLeafTag('tptermsinterimflag', tpTermsInterimFlag);
      XMLWriter.AddLeafTag('tptermsstage',       tpTermsStage);
      XMLWriter.AddLeafTag('tptotalappliedytd',  tpTotalAppliedYTD);
      XMLWriter.AddLeafTag('tptotalbudget',      tpTotalBudget);
      XMLWriter.AddLeafTag('tptotalcertytd',     tpTotalCertYTD);
      XMLWriter.AddLeafTag('tptotalcontra',      tpTotalContra);
      XMLWriter.AddLeafTag('tptotaldeduct',      tpTotalDeduct);
      XMLWriter.AddLeafTag('tptotaldeductytd',   tpTotalDeductYTD);
      XMLWriter.AddLeafTag('tptotalretain',      tpTotalRetain);
      XMLWriter.AddLeafTag('tptotalretainytd',   tpTotalRetainYTD);
      XMLWriter.AddClosingTag('thasapplication');
    end;

    if (oTrans.thAsBatch <> nil) then
    with oTrans.thAsBatch do
    begin
      XMLWriter.AddOpeningTag('thasbatch');
      XMLWriter.AddLeafTag('btbankgl',        btBankGL);
      XMLWriter.AddLeafTag('btchequenostart', btChequeNoStart);
      XMLWriter.AddLeafTag('bttotal',         btTotal);
      XMLWriter.AddClosingTag('thasbatch');
    end;

    if (oTrans.thAsNOM <> nil) then
    with oTrans.thAsNOM as ITransactionAsNOM2 do
    begin
      XMLWriter.AddOpeningTag('thasnom');
      XMLWriter.AddLeafTag('tnautoreversing', tnAutoReversing);
      XMLWriter.AddLeafTag('tnvatio',         tnVatIO);
      XMLWriter.AddClosingTag('thasnom');
    end;

    if (oTrans.thAutoSettings <> nil) then
    with oTrans.thAutoSettings do
    begin
      XMLWriter.AddOpeningTag('thautosettings');
      XMLWriter.AddLeafTag('atautocreateonpost', atAutoCreateOnPost);
      XMLWriter.AddLeafTag('atenddate',          atEndDate);
      XMLWriter.AddLeafTag('atendperiod',        atEndPeriod);
      XMLWriter.AddLeafTag('atendyear',          atEndYear);
      XMLWriter.AddLeafTag('atincrement',        atIncrement);
      XMLWriter.AddLeafTag('atincrementtype',    atIncrementType);
      XMLWriter.AddLeafTag('atstartdate',        atStartDate);
      XMLWriter.AddLeafTag('atstartperiod',      atStartPeriod);
      XMLWriter.AddLeafTag('atstartyear',        atStartYear);
      XMLWriter.AddClosingTag('thautosettings');
    end;

    XMLWriter.AddLeafTag('thautotransaction', oTrans.thAutoTransaction);
    XMLWriter.AddLeafTag('thbatchdiscamount', oTrans.thBatchDiscAmount);
    XMLWriter.AddLeafTag('thcisdate',         oTrans.thCISDate);
    XMLWriter.AddLeafTag('thcisemployee',     oTrans.thCISEmployee);
    XMLWriter.AddLeafTag('thcismanualtax',    oTrans.thCISManualTax);
    XMLWriter.AddLeafTag('thcissource',       oTrans.thCISSource);
    XMLWriter.AddLeafTag('thcistaxdeclared',  oTrans.thCISTaxDeclared);
    XMLWriter.AddLeafTag('thcistaxdue',       oTrans.thCISTaxDue);
    XMLWriter.AddLeafTag('thcistotalgross',   oTrans.thCISTotalGross);
    XMLWriter.AddLeafTag('thcompanyrate',     oTrans.thCompanyRate);
    XMLWriter.AddLeafTag('thcontrolgl',       oTrans.thControlGL);
    XMLWriter.AddLeafTag('thcurrency',        oTrans.thCurrency);
    XMLWriter.AddLeafTag('thdailyrate',       oTrans.thDailyRate);

    if (oTrans.thDelAddress <> nil) then
    with oTrans.thDelAddress do
    begin
      XMLWriter.AddOpeningTag('thdeladdress');
      XMLWriter.AddLeafTag('street1',  Street1);
      XMLWriter.AddLeafTag('street2',  Street2);
      XMLWriter.AddLeafTag('town',     Town);
      XMLWriter.AddLeafTag('county',   County);
      XMLWriter.AddLeafTag('postcode', PostCode);
      XMLWriter.AddClosingTag('thdeladdress');
    end;

    XMLWriter.AddLeafTag('thdeliverynoteref', oTrans.thDeliveryNoteRef);

    RunStr := oTrans.thDeliveryRunNo;
    if IsPaymentOrReceipt(oTrans.thOurRef) and
       (Length(RunStr) >= 7) then
    begin
      Move (RunStr, RunNo, SizeOf(RunNo));
      XMLWriter.AddLeafTag('thdeliveryrunno', RunNo);
    end
    else if IsInvoice(oTrans.thOurRef) and
            (Length(RunStr) >= 7) then
    begin
      Move (RunStr, RunNo, SizeOf(RunNo));
      XMLWriter.AddLeafTag('thdeliveryrunno', RunNo);
    end
    else
      XMLWriter.AddLeafTag('thdeliveryrunno',   oTrans.thDeliveryRunNo);

    XMLWriter.AddLeafTag('thdeliveryterms',   oTrans.thDeliveryTerms);
    XMLWriter.AddLeafTag('thdoctype',         oTrans.thDocType);
    XMLWriter.AddLeafTag('thduedate',         oTrans.thDueDate);
    XMLWriter.AddLeafTag('themployeecode',    oTrans.thEmployeeCode);
    XMLWriter.AddLeafTag('thexternal',        oTrans.thExternal);
    XMLWriter.AddLeafTag('thfixedrate',       oTrans.thFixedRate);
    XMLWriter.AddLeafTag('thfolionum',        oTrans.thFolioNum);

    XMLWriter.AddOpeningTag('thgoodsanalysis');
    for i := Low(VATCodesLessMI) to High(VATCodesLessMI) do
    begin
      XMLWriter.AddOpeningTag('tgaline');
      XMLWriter.AddLeafTag('tgacode', VATCodesLessMI[i]);
      XMLWriter.AddLeafTag('tgavalue', oTrans.thGoodsAnalysis[VATCodes[i]]);
      XMLWriter.AddClosingTag('tgaline');
    end;
    XMLWriter.AddClosingTag('thgoodsanalysis');

    XMLWriter.AddLeafTag('thholdflag',            oTrans.thHoldFlag);
//      XMLWriter.AddLeafTag('thjobcode',             oTrans.thJobCode);
    XMLWriter.AddLeafTag('thjobcode',             '');
    XMLWriter.AddLeafTag('thlastdebtchaseletter', oTrans.thLastDebtChaseLetter);

    XMLWriter.AddOpeningTag('thlineanalysis');
    for LineType := tlTypeNormal to tlTypeMaterials2 do //tlTypeMisc2
    begin
      XMLWriter.AddOpeningTag('tlaline');
      XMLWriter.AddLeafTag('tlacode', LineType);
      XMLWriter.AddLeafTag('tlavalue', oTrans.thLineTypeAnalysis[LineType]);
      XMLWriter.AddClosingTag('tlaline');
    end;
    XMLWriter.AddClosingTag('thlineanalysis');

    XMLWriter.AddLeafTag('thlongyourref',       oTrans.thLongYourRef);
    XMLWriter.AddLeafTag('thmanualvat',         oTrans.thManualVAT);
    XMLWriter.AddLeafTag('thnetvalue',          oTrans.thNetValue);
    XMLWriter.AddLeafTag('thnolabels',          oTrans.thNoLabels);
    XMLWriter.AddLeafTag('thoperator',          oTrans.thOperator);
    XMLWriter.AddLeafTag('thoutstanding',       oTrans.thOutstanding);
    XMLWriter.AddLeafTag('thperiod',            oTrans.thPeriod);
    XMLWriter.AddLeafTag('thpickingrunno',      oTrans.thPickingRunNo);
    XMLWriter.AddLeafTag('thporpicksor',        oTrans.thPORPickSOR);
    XMLWriter.AddLeafTag('thpostcompanyrate',   oTrans.thPostCompanyRate);
    XMLWriter.AddLeafTag('thpostdailyrate',     oTrans.thPostDailyRate);
    XMLWriter.AddLeafTag('thpostdiscamount',    oTrans.thPostDiscAmount);
    XMLWriter.AddLeafTag('thpostdisctaken',     oTrans.thPostDiscTaken);
    XMLWriter.AddLeafTag('thposteddate',        oTrans.thPostedDate);
    XMLWriter.AddLeafTag('thprepost',           oTrans.thPrePost);
    XMLWriter.AddLeafTag('thprinted',           oTrans.thPrinted);

    try
      XMLWriter.AddLeafTag('thprocess',           oTrans.thProcess);
    except
      on E:Exception do
        XMLWriter.AddLeafTag('thprocess', ' ')
    end;

    XMLWriter.AddLeafTag('thrunno',             oTrans.thRunNo);
    XMLWriter.AddLeafTag('thsettlediscamount',  oTrans.thSettleDiscAmount);
    XMLWriter.AddLeafTag('thsettlediscdays',    oTrans.thSettleDiscDays);
    XMLWriter.AddLeafTag('thsettlediscperc',    oTrans.thSettleDiscPerc);
    XMLWriter.AddLeafTag('thsettledisctaken',   oTrans.thSettleDiscTaken);
    XMLWriter.AddLeafTag('thsettledvat',        oTrans.thSettledVat);
    XMLWriter.AddLeafTag('thsource',            oTrans.thSource);
    XMLWriter.AddLeafTag('thtagged',            oTrans.thTagged);
    XMLWriter.AddLeafTag('thtagno',             oTrans.thTagNo);
    XMLWriter.AddLeafTag('thtotalcost',         oTrans.thTotalCost);
    XMLWriter.AddLeafTag('thtotalcostapport',   oTrans.thTotalCostApport);
    XMLWriter.AddLeafTag('thtotallinediscount', oTrans.thTotalLineDiscount);
    XMLWriter.AddLeafTag('thtotalorderos',      oTrans.thTotalOrderOS);
    XMLWriter.AddLeafTag('thtotalvat',          oTrans.thTotalVAT);
    XMLWriter.AddLeafTag('thtotalweight',       oTrans.thTotalWeight);
    XMLWriter.AddLeafTag('thtransdate',         oTrans.thTransDate);
    XMLWriter.AddLeafTag('thtransportmode',     oTrans.thTransportMode);
    XMLWriter.AddLeafTag('thtransportnature',   oTrans.thTransportNature);
    XMLWriter.AddLeafTag('thuserfield1',        oTrans.thUserField1);
    XMLWriter.AddLeafTag('thuserfield2',        oTrans.thUserField2);
    XMLWriter.AddLeafTag('thuserfield3',        oTrans.thUserField3);
    XMLWriter.AddLeafTag('thuserfield4',        oTrans.thUserField4);

    XMLWriter.AddOpeningTag('thvatanalysis');
    for i := Low(VATCodesLessMI) to High(VATCodesLessMI) do
    begin
      XMLWriter.AddOpeningTag('tvaline');
      XMLWriter.AddLeafTag('tvacode', VATCodesLessMI[i]);
      XMLWriter.AddLeafTag('tvavalue', oTrans.thVATAnalysis[VATCodesLessMI[i]]);
      XMLWriter.AddClosingTag('tvaline');
    end;
    XMLWriter.AddClosingTag('thvatanalysis');

    XMLWriter.AddLeafTag('thvatclaimed',     oTrans.thVATClaimed);
    XMLWriter.AddLeafTag('thvatcompanyrate', oTrans.thVATCompanyRate);
    XMLWriter.AddLeafTag('thvatdailyrate',   oTrans.thVATDailyRate);
    XMLWriter.AddLeafTag('thyear',           oTrans.thYear);
    XMLWriter.AddLeafTag('thyourref',        oTrans.thYourRef);

    with oTrans as IBetaTransaction do
    begin
      XMLWriter.AddLeafTag('thordmatch', thOrdMatch);
      XMLWriter.AddLeafTag('thautopost', thAutoPost);
    end;
  finally
    oTrans := nil;
  end;
end;

// ---------------------------------------------------------------------------

function TDripfeedExport.AddTransactionLines: Boolean;
var
  ErrorCode: Integer;
  LineNo: Integer;
  oTrans: ITransaction;
begin
  Result := False;
  ErrorCode := 0;
  oTrans := oToolkit.Transaction;
  try
    for LineNo := 1 to oTrans.thLines.thLineCount do
      { Build the required XML record from the Transaction Line details. }
      BuildLineRecord(oTrans.thLines[LineNo] as ITransactionLine3);
  finally
    oTrans := nil;
  end;
  { Log any errors. }
  if (ErrorCode <> 0) then
    DoLogMessage('TDripfeedExport.LoadLinesFromDB', ErrorCode);
end;

// ---------------------------------------------------------------------------

function TDripfeedExport.BuildLineRecord(Line: ITransactionLine3): Boolean;
begin
  Result := False;

  with Line do
  begin
    try
      { Add the record node. }
      XMLWriter.AddOpeningTag('tlrec');

      { Add the field nodes. }

      XMLWriter.AddLeafTag('tlabslineno',    tlABSLineNo);
      XMLWriter.AddLeafTag('tlaccode',       tlAcCode);
      if (Trim(tlJobCode) = '') then
        XMLWriter.AddLeafTag('tlanalysiscode', tlAnalysisCode)
      else
        XMLWriter.AddLeafTag('tlanalysiscode', '');

      if (tlAsApplication <> nil) then
      with tlAsApplication do
      begin
        XMLWriter.AddOpeningTag('tlasapplication');
        XMLWriter.AddLeafTag('tplcalculatebeforeretention', tplCalculateBeforeRetention);
        XMLWriter.AddLeafTag('tpldeductiontype',            tplDeductionType);
        XMLWriter.AddLeafTag('tploverridevalue',            tplOverrideValue);
        XMLWriter.AddLeafTag('tplretentionexpiry',          tplRetentionExpiry);
        XMLWriter.AddLeafTag('tplretentiontype',            tplRetentionType);
        XMLWriter.AddClosingTag('tlasapplication');
      end;

      if (tlAsNOM <> nil) then
      with tlAsNOM as ITransactionLineAsNOM2 do
      begin
        XMLWriter.AddOpeningTag('tlasnom');
        XMLWriter.AddLeafTag('tlnnomvattype', tlnNomVatType);
        XMLWriter.AddClosingTag('tlasnom');
      end;

      XMLWriter.AddLeafTag('tlb2blineno',           tlB2BLineNo );
      XMLWriter.AddLeafTag('tlb2blinkfolio',        tlB2BLinkFolio );
      XMLWriter.AddLeafTag('tlbinqty',              tlBinQty );
      XMLWriter.AddLeafTag('tlbomkitlink',          tlBOMKitLink);
      XMLWriter.AddLeafTag('tlchargecurrency',      tlChargeCurrency);
      XMLWriter.AddLeafTag('tlcisrate',             tlCISRate );
      XMLWriter.AddLeafTag('tlcisratecode',         tlCISRateCode );
      XMLWriter.AddLeafTag('tlcompanyrate',         tlCompanyRate);
      XMLWriter.AddLeafTag('tlcosdailyrate',        tlCOSDailyRate );
      XMLWriter.AddLeafTag('tlcost',                tlCost);
      XMLWriter.AddLeafTag('tlcostapport',          tlCostApport );
      XMLWriter.AddLeafTag('tlcostcentre',          tlCostCentre);
      XMLWriter.AddLeafTag('tlcurrency',            tlCurrency);
      XMLWriter.AddLeafTag('tldailyrate',           tlDailyRate);
      XMLWriter.AddLeafTag('tldepartment',          tlDepartment);
      XMLWriter.AddLeafTag('tldescr',               tlDescr);
      XMLWriter.AddLeafTag('tldiscflag',            tlDiscFlag);
      XMLWriter.AddLeafTag('tldiscount',            tlDiscount);
      XMLWriter.AddLeafTag('tldoctype',             tlDocType );
      XMLWriter.AddLeafTag('tlfolionum',            tlFolioNum);
      XMLWriter.AddLeafTag('tlglcode',              tlGLCode);
      XMLWriter.AddLeafTag('tlinclusivevatcode',    tlInclusiveVATCode);
      XMLWriter.AddLeafTag('tlitemno',              tlItemNo);
//      XMLWriter.AddLeafTag('tljobcode',             tlJobCode);
      XMLWriter.AddLeafTag('tljobcode',             '');
      XMLWriter.AddLeafTag('tllineclass',           tlLineClass);
      XMLWriter.AddLeafTag('tllinedate',            tlLineDate);
      XMLWriter.AddLeafTag('tllineno',              tlLineNo);
      XMLWriter.AddLeafTag('tllinesource',          tlLineSource );
      XMLWriter.AddLeafTag('tllinetype',            tlLineType);
      XMLWriter.AddLeafTag('tllocation',            tlLocation);
      XMLWriter.AddLeafTag('tlnetvalue',            tlNetValue);
      XMLWriter.AddLeafTag('tlnominalmode',         tlNominalMode);
      XMLWriter.AddLeafTag('tlourref',              tlOurRef);
      XMLWriter.AddLeafTag('tlpayment',             tlPayment);
      XMLWriter.AddLeafTag('tlperiod',              tlPeriod );
      XMLWriter.AddLeafTag('tlpricemultiplier',     tlPriceMultiplier);
      XMLWriter.AddLeafTag('tlqty',                 tlQty);
      XMLWriter.AddLeafTag('tlqtydel',              tlQtyDel);
      XMLWriter.AddLeafTag('tlqtymul',              tlQtyMul);
      XMLWriter.AddLeafTag('tlqtypack',             tlQtyPack );
      XMLWriter.AddLeafTag('tlqtypicked',           tlQtyPicked);
      XMLWriter.AddLeafTag('tlqtypickedwo',         tlQtyPickedWO);
      XMLWriter.AddLeafTag('tlqtywoff',             tlQtyWOFF);
      XMLWriter.AddLeafTag('tlreconciliationdate',  tlReconciliationDate );
      XMLWriter.AddLeafTag('tlrecstatus',           tlRecStatus);
      XMLWriter.AddLeafTag('tlrunno',               tlRunNo );
      XMLWriter.AddLeafTag('tlsopabslineno',        tlSOPABSLineNo);
      XMLWriter.AddLeafTag('tlsopfolionum',         tlSOPFolioNum);
      XMLWriter.AddLeafTag('tlssdcommodcode',       tlSSDCommodCode);
      XMLWriter.AddLeafTag('tlssdcountry',          tlSSDCountry);
      XMLWriter.AddLeafTag('tlssdsalesunit',        tlSSDSalesUnit);
      XMLWriter.AddLeafTag('tlssdupliftperc',       tlSSDUpliftPerc);
      XMLWriter.AddLeafTag('tlssduselinevalues',    tlSSDUseLineValues);
      XMLWriter.AddLeafTag('tlstockcode',           tlStockCode);
      XMLWriter.AddLeafTag('tlstockdeductqty',      tlStockDeductQty );
      XMLWriter.AddLeafTag('tlunitweight',          tlUnitWeight);
      XMLWriter.AddLeafTag('tluserfield1',          tlUserField1);
      XMLWriter.AddLeafTag('tluserfield2',          tlUserField2);
      XMLWriter.AddLeafTag('tluserfield3',          tlUserField3);
      XMLWriter.AddLeafTag('tluserfield4',          tlUserField4);
      XMLWriter.AddLeafTag('tluseqtymul',           tlUseQtyMul );
      XMLWriter.AddLeafTag('tlvatamount',           tlVATAmount);
      XMLWriter.AddLeafTag('tlvatcode',             tlVATCode);
      XMLWriter.AddLeafTag('tlvatincvalue',         tlVATIncValue );
      XMLWriter.AddLeafTag('tlyear',                tlYear );

      XMLWriter.AddClosingTag('tlrec');

      Result := True;
    except
      on e: Exception Do
        DoLogMessage('TDripfeedExport.BuildLineRecord', cBUILDINGXMLERROR, 'Error: ' +
          e.message);
    end;
  end; { with Line do... }
end;

// ---------------------------------------------------------------------------

function TDripfeedExport.BuildRecord: Boolean;

  function HasStock(oTrans: ITransaction; oLine: ITransactionLine): Boolean;
  begin
    Result := (Trim(oLine.tlStockCode) <> '');
    if (Result) then
    begin
      if (oTrans.thDocType in [dtPPY, dtSRC]) then
        Result := False
      else if (oTrans.thDocType in [dtPPI, dtPRF, dtSRI, dtSRF]) and
              (oLine.tlPayment) then
        Result := False;
    end;
  end;

var
  oTrans: ITransaction3;
  i, LineNo: Integer;
begin

  { Add the record node. }
  XMLWriter.AddOpeningTag('threc');

  oTrans := oToolkit.Transaction as ITransaction3;
  try
    try

      { Add the Customer/Supplier record }
      OpenCustFile;
      try
        AddAccount(oTrans.thAcCode);
      finally
        CloseCustFile;
      end;

      OpenCostCentreFile;
      try
        { Add the Cost Centre records }
        XMLWriter.AddOpeningTag('ccrecs');
        for LineNo := 1 to oTrans.thLines.thLineCount do
        begin
          AddCostCentre(oTrans.thLines[LineNo].tlCostCentre);
        end;
        XMLWriter.AddClosingTag('ccrecs');
        { Add the Department records }
        XMLWriter.AddOpeningTag('deptrecs');
        for LineNo := 1 to oTrans.thLines.thLineCount do
        begin
          AddDepartment(oTrans.thLines[LineNo].tlDepartment);
        end;
        XMLWriter.AddClosingTag('deptrecs');
      finally
        CloseCostCentreFile;
      end;

      { Add the Stock Item records }
      OpenStockFile;
      try
        XMLWriter.AddOpeningTag('stockrecs');
        for LineNo := 1 to oTrans.thLines.thLineCount do
        begin
          if HasStock(oTrans, oTrans.thLines[LineNo]) then
            AddStockItem(oTrans.thLines[LineNo].tlStockCode);
        end;
        XMLWriter.AddClosingTag('stockrecs');
        XMLWriter.AddOpeningTag('stockgroups');
        { Add each parent item to the XML file. }
        for i := 0 to StockGroups.Count - 1 do
          AddStockGroup(StockGroups[i]);
        XMLWriter.AddClosingTag('stockgroups');
      finally
        CloseStockFile;
      end;

      { Add the Transaction Header details. }
      AddTransactionHeader;

      { Add the lines for this Transaction. }
      XMLWriter.AddOpeningTag('tlrecs');
      AddTransactionLines;
      XMLWriter.AddClosingTag('tlrecs');

      { Add the Matching records }
      XMLWriter.AddOpeningTag('matchrecs');
      AddMatchingRecords;
      XMLWriter.AddClosingTag('matchrecs');

    except
      On e:Exception Do
        DoLogMessage('TDripfeedExport.BuildRecord', cBUILDINGXMLERROR, 'Error: ' +
          e.message);
    end;
  finally
    oTrans := nil;

    XMLWriter.AddClosingTag('threc');

    Result := True;
  end;
end;

// ---------------------------------------------------------------------------

function TDripfeedExport.CloseCostCentreFile: Boolean;
var
  FuncRes: LongInt;
begin
  FuncRes := Close_File(F[PWrdF]);
  Result := (FuncRes = 0);
end;

// ---------------------------------------------------------------------------

function TDripfeedExport.CloseCustFile: Boolean;
var
  FuncRes: LongInt;
begin
  FuncRes := Close_File(F[CustF]);
  Result := (FuncRes = 0);
end;

function TDripfeedExport.CloseStockFile: Boolean;
var
  FuncRes: LongInt;
begin
  FuncRes := Close_File(F[StockF]);
  Result := (FuncRes = 0);
end;

// ---------------------------------------------------------------------------

constructor TDripfeedExport.Create;
begin
  inherited Create;
  UseFiles := True;
  FileManager := TXMLFileManager.Create;
  RecordsPerFile := 1;
  FileManager.BaseFileName := 'dri';
  XMLWriter := TXMLWriter.Create;
  XMLWriter.NameSpace := 'dripfeed';
  AlreadyExported := TAlreadyExported.Create;
  StockGroups := TStringList.Create;
  Tracker := TTransactionTracker.Create;
  EditTrack := TICETrack.CreateAtIndex(16);
end;

// ---------------------------------------------------------------------------

destructor TDripfeedExport.Destroy;
begin
  EditTrack.Free;
  Tracker.Free;
  StockGroups.Free;
  AlreadyExported.Free;
  FileManager.Free;
  inherited;
end;

// ---------------------------------------------------------------------------

function TDripfeedExport.LoadFromDB: Boolean;

  function IsInDateRange(oTrans: ITransaction): Boolean;
  var
    FromDate, ToDate: TDateTime;
    FromKey, ToKey: string;
  begin
    if (not VarIsNull(Param1)) and (not VarIsNull(Param2)) then
    begin
      try
        FromDate := VarToDateTime(Param1);
        ToDate   := VarToDateTime(Param2);
        FromKey  := oTrans.BuildTransDateIndex(FormatDateTime('yyyymmdd', FromDate));
        ToKey    := oTrans.BuildTransDateIndex(FormatDateTime('yyyymmdd', ToDate));
        Result   := (oTrans.thTransDate >= FromKey) and
                    (oTrans.thTransDate <= ToKey);
      except
        Result := False;
      end;
    end
    else
      Result := True;
  end;

  function IsInDocCodeRange(Ref: string): Boolean;
  var
    DocCode: string;
  const
    DocCodes: string =
      'NOM SIN SJI SJC SRF SRC SCR SRI PIN PJI PJC PPI PRF PCR PPY SBT PBT';
  begin
    DocCode := Copy(Ref, 1, 3);
    Result := (Pos(DocCode, DocCodes) <> 0);
  end;

  function IsAuto(oTrans: ITransaction): Boolean;
  begin
    Result := (oTrans.thRunNo = -1) or
              (oTrans.thRunNo = -2);
  end;

  function IncludeRecord(oTrans: ITransaction): Boolean;
  begin
    Result := IsInDocCodeRange(oTrans.thOurRef) and
              not IsAuto(oTrans) and
              (Tracker.IsNew(oTrans.thOurRef) or
               Tracker.HasChanged(oTrans.thOurRef));
  end;

var
  FuncRes: LongInt;
  Key: ShortString;
  ErrorCode: Integer;
  oTrans: ITransaction;
  FileName: string;
  RecordCount: Integer;
  FirstRecord: Boolean;
  RecordIncluded: Boolean;
  RecordIsOpen: Boolean;
begin
  ErrorCode := 0;
  RecordCount := 0;
  SetDrive := DataPath;
  FirstRecord := True;
  RecordIsOpen := False;
  FileManager.Directory := DataPath + cICEFOLDER;
  Tracker.DataPath := DataPath;
  EditTrack.DataPath := DataPath + cICEFOLDER;
  oToolkit := OpenToolkit(DataPath, True);
  if not Assigned(oToolkit) then
  begin
    DoLogMessage('TDripfeedExport.LoadFromDB: Cannot create COM Toolkit instance', cCONNECTINGDBERROR);
    Result := False;
    Exit;
  end;
  oTrans := oToolkit.Transaction;
  try
    oTrans.Index := thIdxTransDate;
    FuncRes := oTrans.GetFirst;
    Result  := (FuncRes = 0);
    while (FuncRes = 0) do
    begin
      RecordIncluded := IncludeRecord(oTrans);
      if RecordIncluded then
      begin
        RecordCount := RecordCount + 1;

        { If required, start a new XML file. }
        if (RecordCount = RecordsPerFile) or FirstRecord then
        begin
          XMLWriter.Start(0, 'dripfeed');
          RecordIsOpen := True;
          FirstRecord := False;
        end;

        { Build the required XML record from the transaction details. }
        AlreadyExported.Clear;
        BuildRecord;

        { Remove the transaction from the list of transactions to be
          exported. }
        EditTrack.Entry.OurRef := oTrans.thOurRef;
        if EditTrack.Find(oTrans.thOurRef) = 0 then
          EditTrack.Delete;

      end; { if (IncludeRecord(oTrans)... }

      { Find the next transaction record }
      FuncRes := oTrans.GetNext;

      { If required, finish the XML file and save the filename. }
      if ((RecordCount = RecordsPerFile) or (FuncRes <> 0)) and (RecordIsOpen) then
      begin
        XMLWriter.Finish;
        RecordCount := 0;
        RecordIsOpen := False;
        FileName := FileManager.SaveXML(XMLWriter.XML.Text);
        Files.Add(FileName);
      end
      else if RecordIncluded then
        RecordCount := RecordCount + 1;

      Application.ProcessMessages;

    end;
  finally
    oTrans := nil;
    oToolkit.CloseToolkit;
    oToolkit := nil;
    Tracker.UpdateDocumentNumbers;
  end;
  { Log any errors. }
  if (ErrorCode <> 0) then
    DoLogMessage('TDripfeedExport.LoadFromDB', ErrorCode, 'Error: ' + IntToStr(FuncRes));
end;

// ---------------------------------------------------------------------------

function TDripfeedExport.OpenCostCentreFile: Boolean;
var
  FuncRes: LongInt;
begin
  FuncRes := Open_File(F[PwrdF], SetDrive + FileNames[PwrdF], 0);
  Result := (FuncRes = 0);
end;

// ---------------------------------------------------------------------------

function TDripfeedExport.OpenCustFile: Boolean;
var
  FuncRes: LongInt;
begin
  FuncRes := Open_File(F[CustF], SetDrive + FileNames[CustF], 0);
  Result := (FuncRes = 0);
end;

// ---------------------------------------------------------------------------

function TDripfeedExport.OpenStockFile: Boolean;
var
  FuncRes: LongInt;
begin
  FuncRes := Open_File(F[StockF], SetDrive + FileNames[StockF], 0);
  Result := (FuncRes = 0);
end;

// ---------------------------------------------------------------------------

procedure TDripfeedExport.SetOutputDirectory(const Value: string);
begin
  fOutputDirectory := Value;
  ForceDirectories(fOutputDirectory);
  if not DirectoryExists(fOutputDirectory) then
    DoLogMessage('TDripfeedExport.SetOutputDirectory: ' +
                 'Directory does not exist and could not be created',
                 cNOOUTPUTDIRECTORY);
end;

// ===========================================================================
// TAlreadyExported
// ===========================================================================

procedure TAlreadyExported.Add(ListType: TAlreadyExportedType;
  Code: ShortString);
var
  List: TStringList;
begin
  if not Includes[ListType, Code] then
  begin
    List := TStringList(Lists[Ord(ListType)]);
    List.Add(Code);
  end;
end;

// ---------------------------------------------------------------------------

procedure TAlreadyExported.Clear;
var
  i: TAlreadyExportedType;
begin
  for i := Low(TAlreadyExportedType) to High(TAlreadyExportedType) do
    TStringList(Lists[Ord(i)]).Clear;
end;

// ---------------------------------------------------------------------------

constructor TAlreadyExported.Create;
var
  i: TAlreadyExportedType;
begin
  inherited Create;
  Lists := TObjectList.Create;
  Lists.OwnsObjects := true;
  for i := Low(TAlreadyExportedType) to High(TAlreadyExportedType) do
    Lists.Add(TStringList.Create);
end;

// ---------------------------------------------------------------------------

destructor TAlreadyExported.Destroy;
begin
  Lists.Free;
  inherited;
end;

// ---------------------------------------------------------------------------

function TAlreadyExported.GetItem(ListType: TAlreadyExportedType;
  Code: ShortString): Boolean;
var
  List: TStringList;
begin
  List := TStringList(Lists[Ord(ListType)]);
  Result := (List.IndexOf(Code) <> -1);
end;

// ---------------------------------------------------------------------------

end.
