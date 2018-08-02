unit oStock2;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     EnterpriseTrade_TLB, GlobVar, VarConst, DLLInc;

type
  pBatchSKRec = ^TBatchSKRec;

  {-----------------------------------------}

  TReorderPropertyIndex = (pIdxroNeverAuthorise, pIdxstReorderCostCentre, pIdxstReorderCur
  , pIdxstReorderDate, pIdxstReorderDepartment, pIdxstReorderPrice, pIdxstReorderQty);

  TTradeStockReorder = class(TAutoIntfObject, ITradeStockReorder)
  Private
    FDataChanged : Boolean;
    oEventData, oLineData : TObject;
  protected
    // ITradeStockReorder
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

    Procedure AuthoriseProperty(Const PropertyIdx : TReorderPropertyIndex; const PropName : ShortString);
  public
    Property DataChanged : Boolean Read FDataChanged;
    Constructor Create(EventData, LineData : TObject);
    Destructor Destroy; override;
  End; { TTradeStockReorder }

  {-----------------------------------------}

  TGetPriceFunc = Function (Const BandNo : Byte) : Double Of Object;
  TSetPriceFunc = Procedure (Const BandNo : Byte; Const Value : Double; var Changed : boolean) Of Object;
  TGetCcyFunc = Function (Const BandNo : Byte) : Integer Of Object;
  TSetCcyFunc = Procedure (Const BandNo : Byte; Const Value : Integer; var Changed : boolean) Of Object;

  TSalesBandPropertyIndex = (pIdxsbNeverAuthorise, pIdxstCurrency, pIdxstPrice);

  TTradeStockSalesBand = class(TAutoIntfObject, ITradeStockSalesBand)
  Private
    FDataChanged : Boolean;
    oEventData, oLineData : TObject;
  protected
    FBandNo   : Byte;
    FGetPrice : TGetPriceFunc;
    FSetPrice : TSetPriceFunc;
    FGetCcy   : TGetCcyFunc;
    FSetCcy   : TSetCcyFunc;

    // ITradeStockSalesBand
    function  Get_stPrice: Double; safecall;
    procedure Set_stPrice(Value: Double); safecall;
    function  Get_stCurrency: Integer; safecall;
    procedure Set_stCurrency(Value: Integer); safecall;

    Procedure AuthoriseProperty(Const PropertyIdx : TSalesBandPropertyIndex; const PropName : ShortString);
  public
    Property DataChanged : Boolean Read FDataChanged;

    Constructor Create (Const EventData, LineData : TObject;
                              BandNo   : Byte;
                              GetPrice : TGetPriceFunc;
                              SetPrice : TSetPriceFunc;
                              GetCcy   : TGetCcyFunc;
                              SetCcy   : TSetCcyFunc);
    Destructor Destroy; override;
  End; { TTradeStockSalesBand }

  {-----------------------------------------}

  TIntrastatPropertyIndex = (pIdxisNeverAuthorise, pIdxstSSDCommodityCode, pIdxstSSDCountry
  , pIdxstSSDPurchaseUnitWeight, pIdxstSSDSalesUnitWeight, pIdxstSSDDespatchUplift
  , pIdxstSSDStockUnits, pIdxstSSDUnitDesc);

  TTradeStockIntrastat = class(TAutoIntfObject, ITradeStockIntrastat)
  private
    FDataChanged : Boolean;
    oEventData, oLineData : TObject;
  protected
    // ITradeStockIntrastat
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

    Procedure AuthoriseProperty(Const PropertyIdx : TIntrastatPropertyIndex; const PropName : ShortString);
  public
    Property DataChanged : Boolean Read FDataChanged;
    Constructor Create(EventData, LineData : TObject);
    Destructor Destroy; override;
  End; { TTradeStockIntrastat }

  {-----------------------------------------}

  TCoverPropertyIndex = (pIdxcvNeverAuthorise, pIdxstCoverMaxPeriods, pIdxstCoverMaxPeriodUnits
  , pIdxstCoverMinPeriods, pIdxstCoverMinPeriodUnits, pIdxstCoverPeriods, pIdxstCoverPeriodUnits
  , pIdxstCoverQtySold, pIdxstUseCover);

  TTradeStockCover = class(TAutoIntfObject, ITradeStockCover)
  private
    FDataChanged : Boolean;
    oEventData, oLineData : TObject;
  protected
    // ITradeStockCover
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

    Procedure AuthoriseProperty(Const PropertyIdx : TCoverPropertyIndex; const PropName : ShortString);
  public
    Property DataChanged : Boolean Read FDataChanged;
    Constructor Create(EventData, LineData : TObject);
    Destructor Destroy; override;
  End; { TTradeStockIntrastat }

  {-----------------------------------------}

implementation

uses
  oLine, oEvent, ComServ, BtKeys1U, oStock, oVersion, CustomP;

{-------------------------------------------------------------------------------------------------}

constructor TTradeStockReorder.Create(EventData, LineData : TObject);
begin
  Inherited Create (ComServer.TypeLib, ITradeStockReorder);

  // Initialise variables
  FDataChanged := FALSE;
  oEventData := EventData;
  oLineData := LineData;
end;

destructor TTradeStockReorder.Destroy;
begin
//  FStock := NIL;

  inherited;
end;

procedure TTradeStockReorder.AuthoriseProperty(const PropertyIdx: TReorderPropertyIndex; const PropName: ShortString);
Var
  Authorised : Boolean;
Begin { AuthoriseProperty }

  Authorised := FALSE;

  with TTradeEventData(oEventData) do begin

  {  Case PropertyIdx Of
      pIdxEdit1      : Authorised := ((FWindowId = twiTransaction) And (FHandlerId = 1)) Or    // Exit Edit1
                                     ((FWindowId = twiTransaction) And (FHandlerId = 101)) Or  // Custom Button 1
                                     ((FWindowId = twiTransaction) And (FHandlerId = 102));    // Custom Button 2
      // etc...
    End; { Case }

    If (Not Authorised) Then
      // Raise exception to notify the user that the Plug-In has been naughty
      Raise ERightsError.Create (Format('Customisation Error in ITradeStockReorder for Event %d.%d - The property %s is Read-Only',
                                        [FWindowId, FHandlerId, QuotedStr(PropName)]));
  end;{with}
End; { AuthoriseProperty }

{-----------------------------------------}

function TTradeStockReorder.Get_stReorderCostCentre: WideString;
begin
  Result := TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.stRoCostCentre;
end;

procedure TTradeStockReorder.Set_stReorderCostCentre(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstReorderCostCentre, 'stReorderCostCentre');
  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.stRoCostCentre := CustomSetString(TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.stRoCostCentre, Value, FDataChanged);
end;

{-----------------------------------------}

function TTradeStockReorder.Get_stReorderCur: Smallint;
begin
  Result := TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.RoCurrency;
end;

procedure TTradeStockReorder.Set_stReorderCur(Value: Smallint);
var
  FVersionO : TTradeVersion;
begin
  FVersionO := TTradeVersion.Create;

  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstReorderCur, 'stReorderCur');
  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.RoCurrency := CustomSetInteger(TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.RoCurrency, FVersionO.ValidateCurrencyNo(Value), FDataChanged);

  FVersionO := nil;
end;

{-----------------------------------------}

function TTradeStockReorder.Get_stReorderDate: WideString;
begin
  Result := TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.RODate;
end;

procedure TTradeStockReorder.Set_stReorderDate(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstReorderDate, 'stReorderDate');
  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.RODate := CustomSetString(TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.RODate, Value, FDataChanged);
end;

{-----------------------------------------}

function TTradeStockReorder.Get_stReorderDepartment: WideString;
begin
  Result := TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.stRoDepartment;
end;

procedure TTradeStockReorder.Set_stReorderDepartment(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstReorderDepartment, 'stReorderDepartment');
  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.stRoDepartment := CustomSetString(TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.stRoDepartment, FullCCDepKey(UpperCase(Value))
  , FDataChanged);
end;

{-----------------------------------------}

function TTradeStockReorder.Get_stReorderPrice: Double;
begin
  Result := TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.ROCPrice;
end;

procedure TTradeStockReorder.Set_stReorderPrice(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstReorderPrice, 'stReorderPrice');
  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.ROCPrice := CustomSetReal(TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.ROCPrice, Value, FDataChanged);
end;

{-----------------------------------------}

function TTradeStockReorder.Get_stReorderQty: Double;
begin
  Result := TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.ROQty;
end;

procedure TTradeStockReorder.Set_stReorderQty(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstReorderQty, 'stReorderQty');
  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.ROQty := CustomSetReal(TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.ROQty, Value, FDataChanged);
end;

{-------------------------------------------------------------------------------------------------}

constructor TTradeStockSalesBand.Create (Const EventData, LineData : TObject;
                                          BandNo   : Byte;
                                          GetPrice : TGetPriceFunc;
                                          SetPrice : TSetPriceFunc;
                                          GetCcy   : TGetCcyFunc;
                                          SetCcy   : TSetCcyFunc);
begin
  Inherited Create (ComServer.TypeLib, ITradeStockSalesBand);

  // Initialise variables
  FBandNo := BandNo;
  FGetPrice := GetPrice;
  FSetPrice := SetPrice;
  FGetCcy   := GetCcy;
  FSetCcy   := SetCcy;
  FDataChanged := FALSE;
  oEventData := EventData;
  oLineData := LineData;
end;

destructor TTradeStockSalesBand.Destroy;
begin
  FGetPrice := NIL;
  FSetPrice := NIL;
  FGetCcy   := NIL;
  FSetCcy   := NIL;

  inherited;
end;

procedure TTradeStockSalesBand.AuthoriseProperty(const PropertyIdx: TSalesBandPropertyIndex; const PropName: ShortString);
var
  Authorised : Boolean;
begin { AuthoriseProperty }

  Authorised := FALSE;

  with TTradeEventData(oEventData) do begin

  {  Case PropertyIdx Of
      pIdxEdit1      : Authorised := ((FWindowId = twiTransaction) And (FHandlerId = 1)) Or    // Exit Edit1
                                     ((FWindowId = twiTransaction) And (FHandlerId = 101)) Or  // Custom Button 1
                                     ((FWindowId = twiTransaction) And (FHandlerId = 102));    // Custom Button 2
      // etc...
    End; { Case }

    if (not Authorised) then
      // Raise exception to notify the user that the Plug-In has been naughty
      raise ERightsError.Create (Format('Customisation Error in ITradeStockSalesBand for Event %d.%d - The property %s is Read-Only',
                                        [FWindowId, FHandlerId, QuotedStr(PropName)]));
  end;{with}
end; { AuthoriseProperty }

{-----------------------------------------}

function TTradeStockSalesBand.Get_stCurrency: Integer;
begin
  Result := FGetCcy(FBandNo);
end;

procedure TTradeStockSalesBand.Set_stCurrency(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstCurrency, 'stCurrency');
  FSetCcy (FBandNo, Value, FDataChanged);
end;

{-----------------------------------------}

function TTradeStockSalesBand.Get_stPrice: Double;
begin
  Result := FGetPrice(FBandNo);
end;

procedure TTradeStockSalesBand.Set_stPrice(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstPrice, 'stPrice');
  FSetPrice(FBandNo, Value, FDataChanged);
end;

{-------------------------------------------------------------------------------------------------}

constructor TTradeStockIntrastat.Create(EventData, LineData : TObject);
begin
  Inherited Create (ComServer.TypeLib, ITradeStockIntrastat);

  // Initialise variables
  FDataChanged := FALSE;
//  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec := pStock;

  oEventData := EventData;
  oLineData := LineData;
end;

destructor TTradeStockIntrastat.Destroy;
begin
//  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec := NIL;

  inherited;
end;

procedure TTradeStockIntrastat.AuthoriseProperty(const PropertyIdx: TIntrastatPropertyIndex; const PropName: ShortString);
var
  Authorised : Boolean;
begin { AuthoriseProperty }

  Authorised := FALSE;

  with TTradeEventData(oEventData) do begin

  {  Case PropertyIdx Of
      pIdxEdit1      : Authorised := ((FWindowId = twiTransaction) And (FHandlerId = 1)) Or    // Exit Edit1
                                     ((FWindowId = twiTransaction) And (FHandlerId = 101)) Or  // Custom Button 1
                                     ((FWindowId = twiTransaction) And (FHandlerId = 102));    // Custom Button 2
      // etc...
    End; { Case }

    if (not Authorised) then
      // Raise exception to notify the user that the Plug-In has been naughty
      raise ERightsError.Create (Format('Customisation Error in ITradeStockIntrastat for Event %d.%d - The property %s is Read-Only',
                                        [FWindowId, FHandlerId, QuotedStr(PropName)]));
  end;{with}
end; { AuthoriseProperty }

{-----------------------------------------}

function TTradeStockIntrastat.Get_stSSDCommodityCode: WideString;
begin
  Result := TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CommodCode;
end;

procedure TTradeStockIntrastat.Set_stSSDCommodityCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstSSDCommodityCode, 'stSSDCommodityCode');
  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CommodCode := CustomSetString(TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CommodCode, Value, FDataChanged);
end;

{-----------------------------------------}

function TTradeStockIntrastat.Get_stSSDCountry: WideString;
begin
  Result := TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.SSDCountry;
end;

procedure TTradeStockIntrastat.Set_stSSDCountry(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstSSDCountry, 'stSSDCountry');
  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.SSDCountry := CustomSetString(TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.SSDCountry, Value, FDataChanged);
end;

{-----------------------------------------}

function TTradeStockIntrastat.Get_stSSDDespatchUplift: Double;
begin
  Result := TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.SSDDUplift;
end;

procedure TTradeStockIntrastat.Set_stSSDDespatchUplift(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstSSDDespatchUplift, 'stSSDDespatchUplift');
  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.SSDDUplift := CustomSetReal(TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.SSDDUplift, Value, FDataChanged);
end;

{-----------------------------------------}

function TTradeStockIntrastat.Get_stSSDPurchaseUnitWeight: Double;
begin
  Result := TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.PWeight;
end;

procedure TTradeStockIntrastat.Set_stSSDPurchaseUnitWeight(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstSSDPurchaseUnitWeight, 'stSSDPurchaseUnitWeight');
  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.PWeight := CustomSetReal(TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.PWeight, Value, FDataChanged);
end;

{-----------------------------------------}

function TTradeStockIntrastat.Get_stSSDSalesUnitWeight: Double;
begin
  Result := TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.SWeight;
end;

procedure TTradeStockIntrastat.Set_stSSDSalesUnitWeight(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstSSDSalesUnitWeight, 'stSSDSalesUnitWeight');
  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.SWeight := CustomSetReal(TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.SWeight, Value, FDataChanged);
end;

{-----------------------------------------}

function TTradeStockIntrastat.Get_stSSDStockUnits: Double;
begin
  Result := TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.SuppSUnit;
end;

procedure TTradeStockIntrastat.Set_stSSDStockUnits(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstSSDStockUnits, 'stSSDStockUnits');
  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.SuppSUnit := CustomSetReal(TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.SuppSUnit, Value, FDataChanged);
end;

{-----------------------------------------}

function TTradeStockIntrastat.Get_stSSDUnitDesc: WideString;
begin
  Result := TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.UnitSupp;
end;

procedure TTradeStockIntrastat.Set_stSSDUnitDesc(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstSSDUnitDesc, 'stSSDUnitDesc');
  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.UnitSupp := CustomSetString(TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.UnitSupp, Value, FDataChanged);
end;

{-------------------------------------------------------------------------------------------------}

constructor TTradeStockCover.Create(EventData, LineData : TObject);
begin
  Inherited Create (ComServer.TypeLib, ITradeStockCover);

  // Initialise variables
  FDataChanged := FALSE;
//  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec := pStock;

  oEventData := EventData;
  oLineData := LineData;
end;

destructor TTradeStockCover.Destroy;
begin
//  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec := NIL;

  inherited;
end;

procedure TTradeStockCover.AuthoriseProperty(const PropertyIdx: TCoverPropertyIndex; const PropName: ShortString);
var
  Authorised : Boolean;
begin { AuthoriseProperty }

  Authorised := FALSE;

  with TTradeEventData(oEventData) do begin

  {  Case PropertyIdx Of
      pIdxEdit1      : Authorised := ((FWindowId = twiTransaction) And (FHandlerId = 1)) Or    // Exit Edit1
                                     ((FWindowId = twiTransaction) And (FHandlerId = 101)) Or  // Custom Button 1
                                     ((FWindowId = twiTransaction) And (FHandlerId = 102));    // Custom Button 2
      // etc...
    End; { Case }

    if (not Authorised) then
      // Raise exception to notify the user that the Plug-In has been naughty
      raise ERightsError.Create (Format('Customisation Error in ITradeStockCover for Event %d.%d - The property %s is Read-Only',
                                        [FWindowId, FHandlerId, QuotedStr(PropName)]));
  end;{with}
end; { AuthoriseProperty }


{-----------------------------------------}

function TTradeStockCover.Get_stCoverMaxPeriods: Smallint;
begin
  Result := TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CovMaxPr;
end;

procedure TTradeStockCover.Set_stCoverMaxPeriods(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstCoverMaxPeriods, 'stCoverMaxPeriods');
  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CovMaxPr := CustomSetInteger(TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CovMaxPr, Value, FDataChanged);
end;

{-----------------------------------------}

function TTradeStockCover.Get_stCoverMaxPeriodUnits: WideString;
begin
  Result := TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CovMaxUnit;
end;

procedure TTradeStockCover.Set_stCoverMaxPeriodUnits(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstCoverMaxPeriodUnits, 'stCoverMaxPeriodUnits');
  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CovMaxUnit := ExtractChar(CustomSetString(TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CovMaxUnit
  , ExtractChar(Value, ' '), FDataChanged), #255);
end;

{-----------------------------------------}

function TTradeStockCover.Get_stCoverMinPeriods: Smallint;
begin
  Result := TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CovMinPr;
end;

procedure TTradeStockCover.Set_stCoverMinPeriods(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstCoverMinPeriods, 'stCoverMinPeriods');
  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CovMinPr := CustomSetInteger(TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CovMinPr, Value, FDataChanged);
end;

{-----------------------------------------}

function TTradeStockCover.Get_stCoverMinPeriodUnits: WideString;
begin
  Result := TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CovMinUnit;
end;

procedure TTradeStockCover.Set_stCoverMinPeriodUnits(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstCoverMinPeriodUnits, 'stCoverMinPeriodUnits');
  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CovMinUnit := ExtractChar(CustomSetString(TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CovMinUnit
  , ExtractChar(Value, ' '), FDataChanged),#255);
end;

{-----------------------------------------}

function TTradeStockCover.Get_stCoverPeriods: Smallint;
begin
  Result := TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CovPr;
end;

procedure TTradeStockCover.Set_stCoverPeriods(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstCoverPeriods, 'stCoverPeriods');
  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CovPr := CustomSetInteger(TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CovPr, Value, FDataChanged);
end;

{-----------------------------------------}

function TTradeStockCover.Get_stCoverPeriodUnits: WideString;
begin
  Result := TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CovPrUnit;
end;

procedure TTradeStockCover.Set_stCoverPeriodUnits(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstCoverPeriodUnits, 'stCoverPeriodUnits');
  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CovPrUnit := ExtractChar(CustomSetString(TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CovPrUnit
  , ExtractChar(Value, ' '), FDataChanged), #255);
end;

{-----------------------------------------}

function TTradeStockCover.Get_stCoverQtySold: Double;
begin
  Result := TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CovSold;
end;

procedure TTradeStockCover.Set_stCoverQtySold(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstCoverQtySold, 'stCoverQtySold');
  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CovSold := CustomSetReal(TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.CovSold, Value, FDataChanged);
end;

{-----------------------------------------}

function TTradeStockCover.Get_stUseCover: WordBool;
begin
  Result := TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.UseCover;
end;

procedure TTradeStockCover.Set_stUseCover(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstUseCover, 'stUseCover');
  TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.UseCover := CustomSetBoolean(TTradeEventTransLine(oLineData).LTXLineRec.TKStockRec.UseCover, Value, FDataChanged);
end;

{-------------------------------------------------------------------------------------------------}

end.
