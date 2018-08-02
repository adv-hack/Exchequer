unit Ostock2;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     GlobVar, VarConst, VarCnst3, MiscFunc, ExceptIntf;

type
  pBatchSKRec = ^TBatchSKRec;

  {-----------------------------------------}

  TStockReorder = class(TAutoIntfObjectEx, IStockReorder)
  protected
    FStock  : pBatchSKRec;

    // IStockReorder
    function  Get_stReorderQty: Double; safecall;
    procedure Set_stReorderQty(Value: Double); safecall;
    function  Get_stReorderCur: Smallint; safecall;
    procedure Set_stReorderCur(Value: Smallint); safecall;
    function  Get_stReorderPrice: Double; safecall;
    procedure Set_stReorderPrice(Value: Double); safecall;
    function  Get_stReorderDate: WideString; safecall;
    procedure Set_stReorderDate(const Value: WideString); safecall;
    function  Get_stReorderCostCentre: WideString; safecall;
    procedure Set_stReorderCostCentre(const Value: WideString); safecall;
    function  Get_stReorderDepartment: WideString; safecall;
    procedure Set_stReorderDepartment(const Value: WideString); safecall;
  public
    Constructor Create (Const pStock : pBatchSKRec);
    Destructor Destroy; override;
  End; { TStockReorder }

  {-----------------------------------------}

  TGetPriceFunc = Function (Const BandNo : Byte) : Double Of Object;
  TSetPriceFunc = Procedure (Const BandNo : Byte; Const Value : Double) Of Object;
  TGetCcyFunc = Function (Const BandNo : Byte) : Integer Of Object;
  TSetCcyFunc = Procedure (Const BandNo : Byte; Const Value : Integer) Of Object;

  TStockSalesBand = class(TAutoIntfObjectEx, IStockSalesBand)
  protected
    FBandNo   : Byte;
    FGetPrice : TGetPriceFunc;
    FSetPrice : TSetPriceFunc;
    FGetCcy   : TGetCcyFunc;
    FSetCcy   : TSetCcyFunc;

    // IStockSalesBand
    function  Get_stPrice: Double; safecall;
    procedure Set_stPrice(Value: Double); safecall;
    function  Get_stCurrency: Integer; safecall;
    procedure Set_stCurrency(Value: Integer); safecall;
  public
    Constructor Create (Const BandNo   : Byte;
                              GetPrice : TGetPriceFunc;
                              SetPrice : TSetPriceFunc;
                              GetCcy   : TGetCcyFunc;
                              SetCcy   : TSetCcyFunc);
    Destructor Destroy; override;
  End; { TStockSalesBand }

  {-----------------------------------------}

  TStockIntrastat = class(TAutoIntfObjectEx, IStockIntrastat, IStockIntrastat2)
  protected
    FStock  : pBatchSKRec;

    // IStockIntrastat
    function  Get_stSSDCommodityCode: WideString; safecall;
    procedure Set_stSSDCommodityCode(const Value: WideString); safecall;
    function  Get_stSSDSalesUnitWeight: Double; safecall;
    procedure Set_stSSDSalesUnitWeight(Value: Double); safecall;
    function  Get_stSSDPurchaseUnitWeight: Double; safecall;
    procedure Set_stSSDPurchaseUnitWeight(Value: Double); safecall;
    function  Get_stSSDUnitDesc: WideString; safecall;
    procedure Set_stSSDUnitDesc(const Value: WideString); safecall;
    function  Get_stSSDStockUnits: Double; safecall;
    procedure Set_stSSDStockUnits(Value: Double); safecall;
    function  Get_stSSDDespatchUplift: Double; safecall;
    procedure Set_stSSDDespatchUplift(Value: Double); safecall;
    function  Get_stSSDCountry: WideString; safecall;
    procedure Set_stSSDCountry(const Value: WideString); safecall;

    function Get_stSSDArrivalUplift: Double; safecall;
    procedure Set_stSSDArrivalUplift(Value: Double); safecall;

  public
    Constructor Create (Const pStock : pBatchSKRec);
    Destructor Destroy; override;
  End; { TStockIntrastat }

  {-----------------------------------------}

  TStockCover = class(TAutoIntfObjectEx, IStockCover)
  protected
    FStock  : pBatchSKRec;

    // IStockCover
    function  Get_stUseCover: WordBool; safecall;
    procedure Set_stUseCover(Value: WordBool); safecall;
    function  Get_stCoverPeriods: Smallint; safecall;
    procedure Set_stCoverPeriods(Value: Smallint); safecall;
    function  Get_stCoverPeriodUnits: WideString; safecall;
    procedure Set_stCoverPeriodUnits(const Value: WideString); safecall;
    function  Get_stCoverMinPeriods: Smallint; safecall;
    procedure Set_stCoverMinPeriods(Value: Smallint); safecall;
    function  Get_stCoverMinPeriodUnits: WideString; safecall;
    procedure Set_stCoverMinPeriodUnits(const Value: WideString); safecall;
    function  Get_stCoverQtySold: Double; safecall;
    procedure Set_stCoverQtySold(Value: Double); safecall;
    function  Get_stCoverMaxPeriods: Smallint; safecall;
    procedure Set_stCoverMaxPeriods(Value: Smallint); safecall;
    function  Get_stCoverMaxPeriodUnits: WideString; safecall;
    procedure Set_stCoverMaxPeriodUnits(const Value: WideString); safecall;
  public
    Constructor Create (Const pStock : pBatchSKRec);
    Destructor Destroy; override;
  End; { TStockIntrastat }

  {-----------------------------------------}

implementation

uses ComServ, BtKeys1U, oStock;

{-------------------------------------------------------------------------------------------------}

constructor TStockReorder.Create(const pStock : pBatchSKRec);
begin
  Inherited Create (ComServer.TypeLib, IStockReorder);

  // Initialise variables
  FStock := pStock;
end;

{-----------------------------------------}

destructor TStockReorder.Destroy;
begin
  FStock := NIL;

  inherited;
end;

{-----------------------------------------}

function TStockReorder.Get_stReorderCostCentre: WideString;
begin
  Result := FStock.stRoCostCentre;
end;

procedure TStockReorder.Set_stReorderCostCentre(const Value: WideString);
begin
  FStock.stRoCostCentre := FullCCDepKey(UpperCase(Value));
end;

{-----------------------------------------}

function TStockReorder.Get_stReorderCur: Smallint;
begin
  Result := FStock.RoCurrency;
end;

procedure TStockReorder.Set_stReorderCur(Value: Smallint);
begin
  FStock.RoCurrency := ValidateCurrencyNo (Value);
end;

{-----------------------------------------}

function TStockReorder.Get_stReorderDate: WideString;
begin
  Result := FStock.RODate;
end;

procedure TStockReorder.Set_stReorderDate(const Value: WideString);
begin
  FStock.RODate := Value;
end;

{-----------------------------------------}

function TStockReorder.Get_stReorderDepartment: WideString;
begin
  Result := FStock.stRoDepartment;
end;

procedure TStockReorder.Set_stReorderDepartment(const Value: WideString);
begin
  FStock.stRoDepartment := FullCCDepKey(UpperCase(Value));
end;

{-----------------------------------------}

function TStockReorder.Get_stReorderPrice: Double;
begin
  Result := FStock.ROCPrice;
end;

procedure TStockReorder.Set_stReorderPrice(Value: Double);
begin
  FStock.ROCPrice := Value;
end;

{-----------------------------------------}

function TStockReorder.Get_stReorderQty: Double;
begin
  Result := FStock.ROQty;
end;

procedure TStockReorder.Set_stReorderQty(Value: Double);
begin
  FStock.ROQty := Value;
end;

{-------------------------------------------------------------------------------------------------}

constructor TStockSalesBand.Create (Const BandNo   : Byte;
                                          GetPrice : TGetPriceFunc;
                                          SetPrice : TSetPriceFunc;
                                          GetCcy   : TGetCcyFunc;
                                          SetCcy   : TSetCcyFunc);

begin
  Inherited Create (ComServer.TypeLib, IStockSalesBand);

  // Initialise variables
  FBandNo := BandNo;
  FGetPrice := GetPrice;
  FSetPrice := SetPrice;
  FGetCcy   := GetCcy;
  FSetCcy   := SetCcy;
end;

{-----------------------------------------}

destructor TStockSalesBand.Destroy;
begin
  FGetPrice := NIL;
  FSetPrice := NIL;
  FGetCcy   := NIL;
  FSetCcy   := NIL;

  inherited;
end;

{-----------------------------------------}

function TStockSalesBand.Get_stCurrency: Integer;
begin
  Result := FGetCcy(FBandNo);
end;

procedure TStockSalesBand.Set_stCurrency(Value: Integer);
begin
  FSetCcy (FBandNo, Value);
end;

{-----------------------------------------}

function TStockSalesBand.Get_stPrice: Double;
begin
  Result := FGetPrice(FBandNo);
end;

procedure TStockSalesBand.Set_stPrice(Value: Double);
begin
  FSetPrice(FBandNo, Value);
end;

{-------------------------------------------------------------------------------------------------}

constructor TStockIntrastat.Create(const pStock: pBatchSKRec);
begin
  Inherited Create (ComServer.TypeLib, IStockIntrastat2);

  // Initialise variables
  FStock := pStock;
end;

{-----------------------------------------}

destructor TStockIntrastat.Destroy;
begin
  FStock := NIL;

  inherited;
end;

{-----------------------------------------}

function TStockIntrastat.Get_stSSDCommodityCode: WideString;
begin
  Result := FStock.CommodCode;
end;

procedure TStockIntrastat.Set_stSSDCommodityCode(const Value: WideString);
begin
  FStock.CommodCode := Value;
end;

{-----------------------------------------}

function TStockIntrastat.Get_stSSDCountry: WideString;
begin
  // MH 18/01/2016 2016-R1 ABSEXCH-17099: SSD Country field no longer used for UK
  If (CurrentCountry <> UKCCode) Then
    Result := FStock.SSDCountry
  Else
    Result := '';
end;

procedure TStockIntrastat.Set_stSSDCountry(const Value: WideString);
begin
  // MH 18/01/2016 2016-R1 ABSEXCH-17099: SSD Country field no longer used for UK
  If (CurrentCountry <> UKCCode) Then
    FStock.SSDCountry := Value
  Else
    FStock.SSDCountry := '';
end;

{-----------------------------------------}

function TStockIntrastat.Get_stSSDArrivalUplift: Double;
begin
  Result := FSTock.SSDAUplift;
end;

procedure TStockIntrastat.Set_stSSDArrivalUplift(Value: Double);
begin
  FSTock.SSDAUplift := Value;
end;

{-----------------------------------------}

function TStockIntrastat.Get_stSSDDespatchUplift: Double;
begin
  Result := FStock.SSDDUplift;
end;

procedure TStockIntrastat.Set_stSSDDespatchUplift(Value: Double);
begin
  FStock.SSDDUplift := Value;
end;

{-----------------------------------------}

function TStockIntrastat.Get_stSSDPurchaseUnitWeight: Double;
begin
  Result := FStock.PWeight;
end;

procedure TStockIntrastat.Set_stSSDPurchaseUnitWeight(Value: Double);
begin
  FStock.PWeight := Value;
end;

{-----------------------------------------}

function TStockIntrastat.Get_stSSDSalesUnitWeight: Double;
begin
  Result := FStock.SWeight;
end;

procedure TStockIntrastat.Set_stSSDSalesUnitWeight(Value: Double);
begin
  FStock.SWeight := Value;
end;

{-----------------------------------------}

function TStockIntrastat.Get_stSSDStockUnits: Double;
begin
  Result := FStock.SuppSUnit;
end;

procedure TStockIntrastat.Set_stSSDStockUnits(Value: Double);
begin
  FStock.SuppSUnit := Value;
end;

{-----------------------------------------}

function TStockIntrastat.Get_stSSDUnitDesc: WideString;
begin
  Result := FStock.UnitSupp;
end;

procedure TStockIntrastat.Set_stSSDUnitDesc(const Value: WideString);
begin
  FStock.UnitSupp := Value;
end;

{-------------------------------------------------------------------------------------------------}

constructor TStockCover.Create(const pStock: pBatchSKRec);
begin
  Inherited Create (ComServer.TypeLib, IStockCover);

  // Initialise variables
  FStock := pStock;
end;

{-----------------------------------------}

destructor TStockCover.Destroy;
begin
  FStock := NIL;

  inherited;
end;

{-----------------------------------------}

function TStockCover.Get_stCoverMaxPeriods: Smallint;
begin
  Result := FStock.CovMaxPr;
end;

procedure TStockCover.Set_stCoverMaxPeriods(Value: Smallint);
begin
  FStock.CovMaxPr := Value;
end;

{-----------------------------------------}

function TStockCover.Get_stCoverMaxPeriodUnits: WideString;
begin
  Result := FStock.CovMaxUnit;
end;

procedure TStockCover.Set_stCoverMaxPeriodUnits(const Value: WideString);
begin
  FStock.CovMaxUnit := ExtractChar(Value, ' ');
end;

{-----------------------------------------}

function TStockCover.Get_stCoverMinPeriods: Smallint;
begin
  Result := FStock.CovMinPr;
end;

procedure TStockCover.Set_stCoverMinPeriods(Value: Smallint);
begin
  FStock.CovMinPr := Value;
end;

{-----------------------------------------}

function TStockCover.Get_stCoverMinPeriodUnits: WideString;
begin
  Result := FStock.CovMinUnit;
end;

procedure TStockCover.Set_stCoverMinPeriodUnits(const Value: WideString);
begin
  FStock.CovMinUnit := ExtractChar(Value, ' ');
end;

{-----------------------------------------}

function TStockCover.Get_stCoverPeriods: Smallint;
begin
  Result := FStock.CovPr;
end;

procedure TStockCover.Set_stCoverPeriods(Value: Smallint);
begin
  FStock.CovPr := Value;
end;

{-----------------------------------------}

function TStockCover.Get_stCoverPeriodUnits: WideString;
begin
  Result := FStock.CovPrUnit;
end;

procedure TStockCover.Set_stCoverPeriodUnits(const Value: WideString);
begin
  FStock.CovPrUnit := ExtractChar(Value, ' ');
end;

{-----------------------------------------}

function TStockCover.Get_stCoverQtySold: Double;
begin
  Result := FStock.CovSold;
end;

procedure TStockCover.Set_stCoverQtySold(Value: Double);
begin
  FStock.CovSold := Value;
end;

{-----------------------------------------}

function TStockCover.Get_stUseCover: WordBool;
begin
  Result := FStock.UseCover;
end;

procedure TStockCover.Set_stUseCover(Value: WordBool);
begin
  FStock.UseCover := Value;
end;

{-------------------------------------------------------------------------------------------------}



end.
