unit uStockImport;

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
  uImportBaseClass
  ;

{$I ice.inc}

type
  TStockImport = class(_ImportBase)
  private
    function WriteDetails(Node: IXMLDOMNode): Boolean;
  protected
    isFileOpen: Boolean;
    procedure AddRecord(pNode: IXMLDOMNode); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function SaveListToDB: Boolean; override;
  end;

implementation

uses
  EtStrU,
  BtKeys1U;

// ===========================================================================
// TStockImport
// ===========================================================================

procedure TStockImport.AddRecord(pNode: IXMLDOMNode);
{ Called by the Extract method in the _ImportBase class. }
var
  FuncRes, ErrorCode: LongInt;
begin
  ErrorCode := 0;
  FuncRes   := 0;

  if not isFileOpen then
  begin
    ErrorCode := 0;
    SetDrive := DataPath;

    { Open the table. }
    FuncRes := Open_File(F[StockF], SetDrive + FileNames[StockF], 0);
    if (FuncRes = 0) then
      isFileOpen := True
    else
      ErrorCode := cCONNECTINGDBERROR;
  end;

  if (ErrorCode = 0) then
    { Write the record details from the XML file to the database. }
    WriteDetails(pNode);

  { Log any errors. }
  if (ErrorCode <> 0) then
  begin
    if (FuncRes <> 0) then
      DoLogMessage('TStockImport.AddRecord', ErrorCode,
                   'Error: ' + IntToStr(FuncRes))
    else
      DoLogMessage('TStockImport.AddRecord', ErrorCode);
  end;
end;

// ---------------------------------------------------------------------------

constructor TStockImport.Create;
begin
  inherited;
  isFileOpen := False;
end;

// ---------------------------------------------------------------------------

destructor TStockImport.Destroy;
var
  FuncRes: LongInt;
begin
  if isFileOpen then
  begin
    FuncRes := Close_File(F[StockF]);
    isFileOpen := False;
    if ((FuncRes <> 0) and (FuncRes <> 3)) then
      DoLogMessage('TStockImport.Destroy: ' +
                   'error closing file',
                   cCONNECTINGDBERROR,
                   'Error: ' + IntToStr(FuncRes));
  end;
  inherited;
end;

function TStockImport.SaveListToDB: Boolean;
begin
  { Not used (the data is written directly to database via AddRecord) but
    must be implemented as TEntImport will attempt to call it, and the base
    method is abstract. }
  Result := True;
end;

// ---------------------------------------------------------------------------

function TStockImport.WriteDetails(Node: IXMLDOMNode): Boolean;

  function ToChar(const Value: string): Char;
  begin
    if (Trim(Value) <> '') then
      Result := Value[1]
    else
      Result := #0;
  end;

var
  FuncRes: LongInt;
  Key: ShortString;
  Aux: string;
  SubNode, LineNode: IXMLDOMNode;
  i: Integer;
  TempStr: string[29];
begin
  Result := True;

  { Search for a matching record. }
  Key := FullStockCode(_GetNodeValue(Node, 'stcode'));
  FuncRes := Find_Rec(B_GetEq, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, Key);

  { Fill in the record structure }
  with Stock do
  begin
    try

      StockCode := FullStockCode(_GetNodeValue(Node, 'stcode'));

      SubNode := _GetNodeByName(Node, 'stdesc');
      if (SubNode <> nil) then
      begin
        for i := 0 to SubNode.childNodes.length - 1 do
        begin
          LineNode := SubNode.childNodes[i];
          if (i < (Length(Desc) - 1)) then
            Desc[i + 1] := LineNode.text;
        end;
      end;

      AltCode       := LJVar(_GetNodeValue(Node, 'staltcode'), StkKeyLen);
      SuppTemp      := FullCustCode(_GetNodeValue(Node, 'stsupptemp'));
      NomCodes[1]   := _GetNodeValue(Node, 'stsalesgl');
      NomCodes[2]   := _GetNodeValue(Node, 'stcosgl');
      NomCodes[3]   := _GetNodeValue(Node, 'stpandlgl');
      NomCodes[4]   := _GetNodeValue(Node, 'stbalsheetgl');
      NomCodes[5]   := _GetNodeValue(Node, 'stwipgl');
      ROFlg         := _GetNodeValue(Node, 'stroflg');
      MinFlg        := _GetNodeValue(Node, 'stbelowminlevel');
      StockFolio    := _GetNodeValue(Node, 'stfolionum');
      StockCat      := FullStockCode(_GetNodeValue(Node, 'stparentcode'));
      StockType     := ToChar(_GetNodeValue(Node, 'sttype'));
      UnitK         := _GetNodeValue(Node, 'stunitofstock');
      UnitS         := _GetNodeValue(Node, 'stunitofsale');
      UnitP         := _GetNodeValue(Node, 'stunitofpurch');
      PCurrency     := _GetNodeValue(Node, 'stcostpricecur');
      CostPrice     := _GetNodeValue(Node, 'stcostprice');

      SubNode := _GetNodeByName(Node, 'stsalesbands');
      if (SubNode <> nil) then
      begin
        for i := 1 to SubNode.childNodes.length do
        begin
          LineNode := SubNode.childNodes.item[i];
          if (i < Length(SaleBands)) then
          begin
            SaleBands[i].Currency   := _GetNodeValue(LineNode, 'stscurrency');
            SaleBands[i].SalesPrice := _GetNodeValue(LineNode, 'stsprice');
          end;
        end;
      end;

      SellUnit      := _GetNodeValue(Node, 'stsalesunits');
      BuyUnit       := _GetNodeValue(Node, 'stpurchunits');
      VATCode       := ToChar(_GetNodeValue(Node, 'stvatcode'));
      CCDep[BOn]    := FullCCDepKey(_GetNodeValue(Node, 'stcostcentre'));
      CCDep[BOff]   := FullCCDepKey(_GetNodeValue(Node, 'stdepartment'));
      QtyInStock    := 0; //  _GetNodeValue(Node, 'stqtyinstock');
      QtyPosted     := 0; //  _GetNodeValue(Node, 'stqtyposted');
      QtyAllocated  := 0; //  _GetNodeValue(Node, 'stqtyallocated');
      QtyOnOrder    := 0; //  _GetNodeValue(Node, 'stqtyonorder');
      QtyMin        := _GetNodeValue(Node, 'stqtymin');
      QtyMax        := _GetNodeValue(Node, 'stqtymax');
      ROQty         := _GetNodeValue(Node, 'stroqty');
      NLineCount    := _GetNodeValue(Node, 'stnlinecount');
      SubAssyFlg    := _GetNodeValue(Node, 'stsubassyflg');
      ShowasKit     := _GetNodeValue(Node, 'stshowaskit');
      BLineCount    := _GetNodeValue(Node, 'stblinecount');
      CommodCode    := _GetNodeValue(Node, 'stcommodcode');
      SWeight       := _GetNodeValue(Node, 'stsweight');
      PWeight       := _GetNodeValue(Node, 'stpweight');
      UnitSupp      := _GetNodeValue(Node, 'stunitsupp');
      SuppSUnit     := _GetNodeValue(Node, 'stsuppsunit');
      BinLoc        := FullBinCode(_GetNodeValue(Node, 'stbinlocation'));
      StkFlg        := _GetNodeValue(Node, 'ststkflg');
      CovPr         := _GetNodeValue(Node, 'stcoverperiods');
      CovPrUnit     := ToChar(_GetNodeValue(Node, 'stcoverperiodunits'));
      CovMinPr      := _GetNodeValue(Node, 'stcoverminperiods');
      CovMinUnit    := ToChar(_GetNodeValue(Node, 'stcoverminperiodunits'));
      Supplier      := FullCustCode(_GetNodeValue(Node, 'stsupplier'));
      QtyFreeze     := _GetNodeValue(Node, 'stqtyfreeze');
      CovSold       := _GetNodeValue(Node, 'stcoverqtysold');
      UseCover      := _GetNodeValue(Node, 'stusecover');
      CovMaxPr      := _GetNodeValue(Node, 'stcovermaxperiods');
      CovMaxUnit    := ToChar(_GetNodeValue(Node, 'stcovermaxperiodunits'));
      ROCurrency    := _GetNodeValue(Node, 'strocurrency');
      ROCPrice      := _GetNodeValue(Node, 'strocprice');
      RODate        := _GetNodeValue(Node, 'strodate');
      QtyTake       := _GetNodeValue(Node, 'stqtytake');
      StkValType    := ToChar(_GetNodeValue(Node, 'stvaluationmethod'));
      HasSerNo      := _GetNodeValue(Node, 'sthasserno');
      QtyPicked     := _GetNodeValue(Node, 'stqtypicked');
      LastUsed      := _GetNodeValue(Node, 'stlastused');
      CalcPack      := _GetNodeValue(Node, 'stcalcpack');
      JAnalCode     := Uppercase(LJVar(_GetNodeValue(Node, 'stanalysiscode'), AnalKeyLen));
      StkUser1      := _GetNodeValue(Node, 'stuserfield1');
      StkUser2      := _GetNodeValue(Node, 'stuserfield2');
      BarCode       := FullBarCode(_GetNodeValue(Node, 'stbarcode'));
      ROCCDep[BOn]  := FullCCDepKey(_GetNodeValue(Node, 'strocc'));
      ROCCDep[BOff] := FullCCDepKey(_GetNodeValue(Node, 'strodep'));
      DefMLoc       := _GetNodeValue(Node, 'stlocation');
      PricePack     := _GetNodeValue(Node, 'stpricepack');
      DPackQty      := _GetNodeValue(Node, 'stshowqtyaspacks');
      KitPrice      := _GetNodeValue(Node, 'stkitprice');
      KitOnPurch    := _GetNodeValue(Node, 'stshowkitonpurchase');
      StkLinkLT     := _GetNodeValue(Node, 'stdefaultlinetype');
      QtyReturn     := _GetNodeValue(Node, 'stqtyreturn');
      QtyAllocWOR   := _GetNodeValue(Node, 'stqtyallocwor');
      QtyIssueWOR   := _GetNodeValue(Node, 'stqtyissuewor');
      WebInclude    := _GetNodeValue(Node, 'stuseforebus');
      WebLiveCat    := _GetNodeValue(Node, 'stweblivecatalog');
      WebPrevCat    := _GetNodeValue(Node, 'stwebprevcatalog');
      StkUser3      := _GetNodeValue(Node, 'stuserfield3');
      StkUser4      := _GetNodeValue(Node, 'stuserfield4');
      SerNoWAvg     := _GetNodeValue(Node, 'stsernowavg');
      StkSizeCol    := _GetNodeValue(Node, 'ststksizecol');
      SSDDUplift    := _GetNodeValue(Node, 'stssdduplift');
      SSDCountry    := _GetNodeValue(Node, 'stssdcountry');
      TimeChange    := _GetNodeValue(Node, 'sttimechange');
      SVATIncFlg    := ToChar(_GetNodeValue(Node, 'stinclusivevatcode'));
      SSDAUpLift    := _GetNodeValue(Node, 'stssdauplift');
      PrivateRec    := _GetNodeValue(Node, 'stprivaterec');
      LastOpo       := _GetNodeValue(Node, 'stoperator');
      ImageFile     := _GetNodeValue(Node, 'stimagefile');
      TempBLoc      := FullBinCode(_GetNodeValue(Node, 'sttempbloc'));      // **
      QtyPickWOR    := _GetNodeValue(Node, 'stqtypickwor');
      WOPWIPGL      := _GetNodeValue(Node, 'stwopwipgl');
      ProdTime      := _GetNodeValue(Node, 'stprodtime');
      Leadtime      := _GetNodeValue(Node, 'stleadtime');
      CalcProdTime  := _GetNodeValue(Node, 'stcalcprodtime');
      BOMProdTime   := _GetNodeValue(Node, 'stbomprodtime');
      MinEccQty     := _GetNodeValue(Node, 'stmineccqty');
      MultiBinMode  := _GetNodeValue(Node, 'stmultibinmode');
      SWarranty     := _GetNodeValue(Node, 'stswarranty');
      SWarrantyType := _GetNodeValue(Node, 'stswarrantytype');
      MWarranty     := _GetNodeValue(Node, 'stmwarranty');
      MWarrantyType := _GetNodeValue(Node, 'stmwarrantytype');
      QtyPReturn    := _GetNodeValue(Node, 'stqtypreturn');
      ReturnGL      := _GetNodeValue(Node, 'streturngl');
      ReStockPcnt   := _GetNodeValue(Node, 'strestockpcnt');
      ReStockGL     := _GetNodeValue(Node, 'strestockgl');
      BOMDedComp    := _GetNodeValue(Node, 'stbomdedcomp');
      PReturnGL     := _GetNodeValue(Node, 'stpreturngl');
      ReStockPChr   := ToChar(_GetNodeValue(Node, 'strestockpchr'));
      Spare         := _GetNodeValue(Node, 'stspare');
      TempStr       := _GetNodeValue(Node, 'stspare2');
      Move(TempStr[1], Spare2[1], Length(Spare2));

    except
      on E:Exception Do
      begin
        Result := False;
        DoLogMessage('TStockImport.GetRecordValue',
                     cLOADINGXMLVALUEERROR,
                     'Error: ' + E.message);
      end;
    end; { try... }
  end; { with Stock do... }

  if Result then
  begin
    { If a matching record was found, update the details... }
    if (FuncRes = 0) then
      FuncRes := Put_Rec(F[StockF], StockF, RecPtr[StockF]^, 0)
    else
      { ...otherwise add a new record. }
      FuncRes := Add_Rec(F[StockF], StockF, RecPtr[StockF]^, 0);

    if (FuncRes <> 0) then
    begin
      DoLogMessage('TStockImport.WriteDetails', cUPDATINGDBERROR);
      Result := False;
    end;
  end;

end;

// ---------------------------------------------------------------------------

end.
