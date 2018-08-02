// Implementation of the "tlStock" COM Object
unit oStock;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComCtrls, ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, SysUtils, TXRecs
  , VarConst, CustomP, oAddr, DLLInc, oStock2;

type

  TStockPropertyIndex = (pIdxNeverAuthorise, pIdxstAltCode, pIdxstAnalysisCode
  , pIdxstBalSheetGL, pIdxstBarCode, pIdxstBelowMinLevel, pIdxstBinLocation, pIdxstCode
  , pIdxstCOSGL, pIdxstCostCentre, pIdxstCostPrice, pIdxstCostPriceCur, pIdxstDepartment
  , pIdxstDesc, pIdxstImageFile, pIdxstInclusiveVATCode, pIdxstLocation, pIdxstOperator
  , pIdxstPandLGL, pIdxstParentCode, pIdxstPricingMethod, pIdxstPurchUnits, pIdxstQtyMax
  , pIdxstQtyMin, pIdxstSalesGL, pIdxstSalesUnits, pIdxstShowKitOnPurchase
  , pIdxstShowQtyAsPacks, pIdxstSupplier, pIdxstSuppTemp, pIdxstType, pIdxstUnitOfPurch
  , pIdxstUnitOfSale, pIdxstUnitOfStock, pIdxstUseForEbus, pIdxstUseKitPrice
  , pIdxstUserField1, pIdxstUserField2, pIdxstUserField3, pIdxstUserField4
  , pIdxstValuationMethod, pIdxstVATCode, pIdxstWebLiveCatalog, pIdxstWebPrevCatalog
  , pIdxstWIPGL);

  TStockFunctionIndex = (fIdxUnknownfunction);

  TTradeEventStock = class(TAutoIntfObject, ITradeEventStock)
  private
    // Records changes to properties of this object
    FDataChanged : Boolean;

    // Cover sub-object
    FCoverO   : TTradeStockCover;
    FCoverI   : ITradeStockCover;

    // Intrastat sub-object
    FIntraO   : TTradeStockIntrastat;
    FIntraI   : ITradeStockIntrastat;

    // Re-order sub-object
    FReorderO : TTradeStockReorder;
    FReorderI : ITradeStockReorder;

    // Sales Bands sub-objects
    FSalesBandO : Array[1..8] Of TTradeStockSalesBand;
    FSalesBandI : Array[1..8] Of ITradeStockSalesBand;

    oEventData, oLineData : TObject;

//    lTKStockRec : TBatchSKRec;
    lTXLineRec : pTXLineRec;

    Function GetDataChanged : Boolean;

  protected
    function Get_stCode: WideString; safecall;
    procedure Set_stCode(const Value: WideString); safecall;
    function Get_stDesc(Index: Integer): WideString; safecall;
    procedure Set_stDesc(Index: Integer; const Value: WideString); safecall;
    function Get_stAltCode: WideString; safecall;
    procedure Set_stAltCode(const Value: WideString); safecall;
    function Get_stType: TTradeStockType; safecall;
    procedure Set_stType(Value: TTradeStockType); safecall;
    function Get_stSalesGL: Integer; safecall;
    procedure Set_stSalesGL(Value: Integer); safecall;
    function Get_stCOSGL: Integer; safecall;
    procedure Set_stCOSGL(Value: Integer); safecall;
    function Get_stPandLGL: Integer; safecall;
    procedure Set_stPandLGL(Value: Integer); safecall;
    function Get_stBalSheetGL: Integer; safecall;
    procedure Set_stBalSheetGL(Value: Integer); safecall;
    function Get_stWIPGL: Integer; safecall;
    procedure Set_stWIPGL(Value: Integer); safecall;
    function Get_stBelowMinLevel: WordBool; safecall;
    procedure Set_stBelowMinLevel(Value: WordBool); safecall;
    function Get_stFolioNum: Integer; safecall;
    function Get_stParentCode: WideString; safecall;
    procedure Set_stParentCode(const Value: WideString); safecall;
    function Get_stSuppTemp: WideString; safecall;
    procedure Set_stSuppTemp(const Value: WideString); safecall;
    function Get_stUnitOfStock: WideString; safecall;
    procedure Set_stUnitOfStock(const Value: WideString); safecall;
    function Get_stUnitOfSale: WideString; safecall;
    procedure Set_stUnitOfSale(const Value: WideString); safecall;
    function Get_stUnitOfPurch: WideString; safecall;
    procedure Set_stUnitOfPurch(const Value: WideString); safecall;
    function Get_stCostPriceCur: Integer; safecall;
    procedure Set_stCostPriceCur(Value: Integer); safecall;
    function Get_stCostPrice: Double; safecall;
    procedure Set_stCostPrice(Value: Double); safecall;
    function Get_stSalesUnits: Double; safecall;
    procedure Set_stSalesUnits(Value: Double); safecall;
    function Get_stPurchUnits: Double; safecall;
    procedure Set_stPurchUnits(Value: Double); safecall;
    function Get_stVATCode: WideString; safecall;
    procedure Set_stVATCode(const Value: WideString); safecall;
    function Get_stCostCentre: WideString; safecall;
    procedure Set_stCostCentre(const Value: WideString); safecall;
    function Get_stDepartment: WideString; safecall;
    procedure Set_stDepartment(const Value: WideString); safecall;
    function Get_stQtyInStock: Double; safecall;
    function Get_stQtyPosted: Double; safecall;
    function Get_stQtyAllocated: Double; safecall;
    function Get_stQtyOnOrder: Double; safecall;
    function Get_stQtyMin: Double; safecall;
    procedure Set_stQtyMin(Value: Double); safecall;
    function Get_stQtyMax: Double; safecall;
    procedure Set_stQtyMax(Value: Double); safecall;
    function Get_stBinLocation: WideString; safecall;
    procedure Set_stBinLocation(const Value: WideString); safecall;
    function Get_stCover: ITradeStockCover; safecall;
    function Get_stIntrastat: ITradeStockIntrastat; safecall;
    function Get_stReorder: ITradeStockReorder; safecall;
    function Get_stAnalysisCode: WideString; safecall;
    procedure Set_stAnalysisCode(const Value: WideString); safecall;

    Function  GetSalesBandPrice (Const BandNo : Byte) : Double;
    Procedure SetSalesBandPrice (Const BandNo : Byte; Const Value : Double;  var bChanged : boolean);
    Function  GetSalesBandCcy (Const BandNo : Byte) : Integer;
    Procedure SetSalesBandCcy (Const BandNo : Byte; Const Value : Integer; var bChanged : boolean);

    function Get_stSalesBands(const Band: WideString): ITradeStockSalesBand; safecall;

    function Get_stTimeChange: WideString; safecall;
    function Get_stInclusiveVATCode: WideString; safecall;
    procedure Set_stInclusiveVATCode(const Value: WideString); safecall;
    function Get_stOperator: WideString; safecall;
    procedure Set_stOperator(const Value: WideString); safecall;
    function Get_stSupplier: WideString; safecall;
    procedure Set_stSupplier(const Value: WideString); safecall;
    function Get_stDefaultLineType: TTradeTransLineType; safecall;
    procedure Set_stDefaultLineType(Value: TTradeTransLineType); safecall;
    function Get_stValuationMethod: TTradeStockValuationType; safecall;
    procedure Set_stValuationMethod(Value: TTradeStockValuationType); safecall;
    function Get_stQtyPicked: Double; safecall;
    function Get_stLastUsed: WideString; safecall;
    function Get_stBarCode: WideString; safecall;
    procedure Set_stBarCode(const Value: WideString); safecall;
    function Get_stLocation: WideString; safecall;
    procedure Set_stLocation(const Value: WideString); safecall;
    function Get_stPricingMethod: TTradeStockPricingMethod; safecall;
    procedure Set_stPricingMethod(Value: TTradeStockPricingMethod); safecall;
    function Get_stShowQtyAsPacks: WordBool; safecall;
    procedure Set_stShowQtyAsPacks(Value: WordBool); safecall;
    function Get_stUseKitPrice: WordBool; safecall;
    procedure Set_stUseKitPrice(Value: WordBool); safecall;
    function Get_stUserField1: WideString; safecall;
    procedure Set_stUserField1(const Value: WideString); safecall;
    function Get_stUserField2: WideString; safecall;
    procedure Set_stUserField2(const Value: WideString); safecall;
    function Get_stUserField3: WideString; safecall;
    procedure Set_stUserField3(const Value: WideString); safecall;
    function Get_stUserField4: WideString; safecall;
    procedure Set_stUserField4(const Value: WideString); safecall;
    function Get_stShowKitOnPurchase: WordBool; safecall;
    procedure Set_stShowKitOnPurchase(Value: WordBool); safecall;
    function Get_stImageFile: WideString; safecall;
    procedure Set_stImageFile(const Value: WideString); safecall;
    function Get_stWebLiveCatalog: WideString; safecall;
    procedure Set_stWebLiveCatalog(const Value: WideString); safecall;
    function Get_stWebPrevCatalog: WideString; safecall;
    procedure Set_stWebPrevCatalog(const Value: WideString); safecall;
    function Get_stUseForEbus: WordBool; safecall;
    procedure Set_stUseForEbus(Value: WordBool); safecall;
    function Get_stQtyFree: Double; safecall;
    property stCode: WideString read Get_stCode write Set_stCode;
    property stDesc[Index: Integer]: WideString read Get_stDesc write Set_stDesc;
    property stAltCode: WideString read Get_stAltCode write Set_stAltCode;
    property stType: TTradeStockType read Get_stType write Set_stType;
    property stSalesGL: Integer read Get_stSalesGL write Set_stSalesGL;
    property stCOSGL: Integer read Get_stCOSGL write Set_stCOSGL;
    property stPandLGL: Integer read Get_stPandLGL write Set_stPandLGL;
    property stBalSheetGL: Integer read Get_stBalSheetGL write Set_stBalSheetGL;
    property stWIPGL: Integer read Get_stWIPGL write Set_stWIPGL;
    property stBelowMinLevel: WordBool read Get_stBelowMinLevel write Set_stBelowMinLevel;
    property stFolioNum: Integer read Get_stFolioNum;
    property stParentCode: WideString read Get_stParentCode write Set_stParentCode;
    property stSuppTemp: WideString read Get_stSuppTemp write Set_stSuppTemp;
    property stUnitOfStock: WideString read Get_stUnitOfStock write Set_stUnitOfStock;
    property stUnitOfSale: WideString read Get_stUnitOfSale write Set_stUnitOfSale;
    property stUnitOfPurch: WideString read Get_stUnitOfPurch write Set_stUnitOfPurch;
    property stCostPriceCur: Integer read Get_stCostPriceCur write Set_stCostPriceCur;
    property stCostPrice: Double read Get_stCostPrice write Set_stCostPrice;
    property stSalesUnits: Double read Get_stSalesUnits write Set_stSalesUnits;
    property stPurchUnits: Double read Get_stPurchUnits write Set_stPurchUnits;
    property stVATCode: WideString read Get_stVATCode write Set_stVATCode;
    property stCostCentre: WideString read Get_stCostCentre write Set_stCostCentre;
    property stDepartment: WideString read Get_stDepartment write Set_stDepartment;
    property stQtyInStock: Double read Get_stQtyInStock;
    property stQtyPosted: Double read Get_stQtyPosted;
    property stQtyAllocated: Double read Get_stQtyAllocated;
    property stQtyOnOrder: Double read Get_stQtyOnOrder;
    property stQtyMin: Double read Get_stQtyMin write Set_stQtyMin;
    property stQtyMax: Double read Get_stQtyMax write Set_stQtyMax;
    property stBinLocation: WideString read Get_stBinLocation write Set_stBinLocation;
    property stCover: ITradeStockCover read Get_stCover;
    property stIntrastat: ITradeStockIntrastat read Get_stIntrastat;
    property stReorder: ITradeStockReorder read Get_stReorder;
    property stAnalysisCode: WideString read Get_stAnalysisCode write Set_stAnalysisCode;
    property stSalesBands[const Band: WideString]: ITradeStockSalesBand read Get_stSalesBands;
    property stTimeChange: WideString read Get_stTimeChange;
    property stInclusiveVATCode: WideString read Get_stInclusiveVATCode write Set_stInclusiveVATCode;
    property stOperator: WideString read Get_stOperator write Set_stOperator;
    property stSupplier: WideString read Get_stSupplier write Set_stSupplier;
    property stDefaultLineType: TTradeTransLineType read Get_stDefaultLineType write Set_stDefaultLineType;
    property stValuationMethod: TTradeStockValuationType read Get_stValuationMethod write Set_stValuationMethod;
    property stQtyPicked: Double read Get_stQtyPicked;
    property stLastUsed: WideString read Get_stLastUsed;
    property stBarCode: WideString read Get_stBarCode write Set_stBarCode;
    property stLocation: WideString read Get_stLocation write Set_stLocation;
    property stPricingMethod: TTradeStockPricingMethod read Get_stPricingMethod write Set_stPricingMethod;
    property stShowQtyAsPacks: WordBool read Get_stShowQtyAsPacks write Set_stShowQtyAsPacks;
    property stUseKitPrice: WordBool read Get_stUseKitPrice write Set_stUseKitPrice;
    property stUserField1: WideString read Get_stUserField1 write Set_stUserField1;
    property stUserField2: WideString read Get_stUserField2 write Set_stUserField2;
    property stUserField3: WideString read Get_stUserField3 write Set_stUserField3;
    property stUserField4: WideString read Get_stUserField4 write Set_stUserField4;
    property stShowKitOnPurchase: WordBool read Get_stShowKitOnPurchase write Set_stShowKitOnPurchase;
    property stImageFile: WideString read Get_stImageFile write Set_stImageFile;
    property stWebLiveCatalog: WideString read Get_stWebLiveCatalog write Set_stWebLiveCatalog;
    property stWebPrevCatalog: WideString read Get_stWebPrevCatalog write Set_stWebPrevCatalog;
    property stUseForEbus: WordBool read Get_stUseForEbus write Set_stUseForEbus;
    property stQtyFree: Double read Get_stQtyFree;

    // Local Methods
    Procedure AuthoriseProperty (Const PropertyIdx : TStockPropertyIndex; const PropName : ShortString);
    Procedure AuthoriseFunction (Const FunctionIdx : TStockFunctionIndex; const FuncName : ShortString);

    procedure InitObjects;
  public
    // DataChanged flag indicates whether Plug-Ins made any changes to
    // properties of this object OR any sub-objects
    Property DataChanged : Boolean Read GetDataChanged;

    Constructor Create;
    Destructor Destroy; override;

    Procedure Assign(EventData, LineData : TObject);

  End; { TTradeEventStock }

implementation

uses
  oEvent, ComServ, oVersion, oLine;

//---------------------------------------------------------------------------

Constructor TTradeEventStock.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeEventTransaction);

  InitObjects;

  { Create and initialise Cover sub-object }
  FCoverO := TTradeStockCover.Create(oEventData, oLineData);
  FCoverI := FCoverO;

  FIntraO := TTradeStockIntrastat.Create(oEventData, oLineData);
  FIntraI := FIntraO;

  FReorderO := TTradeStockReorder.Create(oEventData, oLineData);
  FReorderI := FReorderO;

  FDataChanged := False;
End; { Create }

//---------------------------------------------------------------------------

Destructor TTradeEventStock.Destroy;
Begin { Destroy }
  InitObjects;
  Inherited;
End; { Destroy }

//---------------------------------------------------------------------------

Procedure TTradeEventStock.Assign(EventData, LineData : TObject);

begin { Assign }
  // Reset Datachanged flag for new event
  FDataChanged := False;
  oEventData := EventData;
  oLineData := LineData;

//  lTKStockRec :=

  lTXLineRec := TTradeEventTransLine(oLineData).LTXLineRec;

end; { Assign }

//---------------------------------------------------------------------------

Procedure TTradeEventStock.AuthoriseProperty (Const PropertyIdx : TStockPropertyIndex; const PropName : ShortString);
Var
  Authorised : Boolean;
Begin

  // Check for specific enablement of fields
  Authorised := FALSE;

  with TTradeEventData(oEventData) do begin
{    case PropertyIdx Of
    end; { Case }

    if (not Authorised) then begin
      // Raise exception to notify the user that the Plug-In has been naughty
      raise ERightsError.Create (Format('Customisation Error in ITradeEventStock for Event %d.%d - The property %s is Read-Only'
      , [FWindowId, FHandlerId, QuotedStr(PropName)]));
    end;{if}
  end;{with}

End;{AuthoriseProperty}

//---------------------------------------------------------------------------

// Returns True if the specified function/procedure can be called by the Plug-In during the current event
Procedure TTradeEventStock.AuthoriseFunction (Const FunctionIdx : TStockFunctionIndex; const FuncName : ShortString);
begin

  //
  // This section needs to be coded once some functions are added in
  //
  Raise Exception.Create ('TTradeEventStock.AuthoriseFunction Not Implemented - Please notify your technical support');

  { TODO -cDO : TTradeEventStock.AuthoriseFunction Not Implemented }

end;

// Returns TRUE if any properties within the eventdata have been changed
function TTradeEventStock.GetDataChanged : Boolean;

  function AnySalesBandDataChanged : boolean;
  var
    iPos : integer;
  begin{AnySalesBandDataChanged}
    Result := FALSE;
    For iPos := 1 to 8 Do Begin
      if Assigned(FSalesBandO[iPos]) and FSalesBandO[iPos].DataChanged then begin
        Result := TRUE;
        Break;
      end;{if}
    end;{while}
  end;{AnySalesBandDataChanged}

begin { GetDataChanged }
  Result := FDataChanged or FCoverO.DataChanged or FIntraO.DataChanged or FReorderO.DataChanged
  or AnySalesBandDataChanged;
end; { GetDataChanged }


function TTradeEventStock.Get_stAltCode: WideString;
begin
  Result := lTXLineRec.TKStockRec.AltCode;
end;

procedure TTradeEventStock.Set_stAltCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstAltCode, 'stAltCode');
  lTXLineRec.TKStockRec.AltCode := CustomSetString(lTXLineRec.TKStockRec.AltCode, Value, FDataChanged);
end;


function TTradeEventStock.Get_stAnalysisCode: WideString;
begin
  Result := lTXLineRec.TKStockRec.JAnalCode;
end;

procedure TTradeEventStock.Set_stAnalysisCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstAnalysisCode, 'stAnalysisCode');
  lTXLineRec.TKStockRec.JAnalCode := CustomSetString(lTXLineRec.TKStockRec.JAnalCode, Value, FDataChanged);
end;


function TTradeEventStock.Get_stBalSheetGL: Integer;
begin
  Result := lTXLineRec.TKStockRec.NomCodes[4];
end;

procedure TTradeEventStock.Set_stBalSheetGL(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstBalSheetGL, 'stBalSheetGL');
  lTXLineRec.TKStockRec.NomCodes[4] := CustomSetInteger(lTXLineRec.TKStockRec.NomCodes[4], Value, FDataChanged);
end;


function TTradeEventStock.Get_stBarCode: WideString;
begin
  Result := lTXLineRec.TKStockRec.StBarCode;
end;

procedure TTradeEventStock.Set_stBarCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstBarCode, 'stBarCode');
  lTXLineRec.TKStockRec.StBarCode := CustomSetString(lTXLineRec.TKStockRec.StBarCode, Value, FDataChanged);
end;


function TTradeEventStock.Get_stBelowMinLevel: WordBool;
begin
  Result := lTXLineRec.TKStockRec.MinFlg;
end;

procedure TTradeEventStock.Set_stBelowMinLevel(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstBelowMinLevel, 'stBelowMinLevel');
  lTXLineRec.TKStockRec.MinFlg := CustomSetBoolean(lTXLineRec.TKStockRec.MinFlg, Value, FDataChanged);
end;


function TTradeEventStock.Get_stBinLocation: WideString;
begin
  Result := lTXLineRec.TKStockRec.BinLoc;
end;

procedure TTradeEventStock.Set_stBinLocation(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstBinLocation, 'stBinLocation');
  lTXLineRec.TKStockRec.BinLoc := CustomSetString(lTXLineRec.TKStockRec.BinLoc, Value, FDataChanged);
end;


function TTradeEventStock.Get_stCode: WideString;
begin
  Result := lTXLineRec.TKStockRec.StockCode;
end;

procedure TTradeEventStock.Set_stCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstCode, 'stCode');
  lTXLineRec.TKStockRec.StockCode := CustomSetString(lTXLineRec.TKStockRec.StockCode, Value, FDataChanged);
end;


function TTradeEventStock.Get_stCOSGL: Integer;
begin
  Result := lTXLineRec.TKStockRec.NomCodeS[2];
end;

procedure TTradeEventStock.Set_stCOSGL(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstCOSGL, 'stCOSGL');
  lTXLineRec.TKStockRec.NomCodeS[2] := CustomSetInteger(lTXLineRec.TKStockRec.NomCodeS[2], Value, FDataChanged);
end;


function TTradeEventStock.Get_stCostCentre: WideString;
begin
  Result := lTXLineRec.TKStockRec.CC;
end;

procedure TTradeEventStock.Set_stCostCentre(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstCostCentre, 'stCostCentre');
  lTXLineRec.TKStockRec.CC := CustomSetString(lTXLineRec.TKStockRec.CC, Value, FDataChanged);
end;

function TTradeEventStock.Get_stCostPrice: Double;
begin
  Result := lTXLineRec.TKStockRec.CostPrice;
end;

procedure TTradeEventStock.Set_stCostPrice(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstCostPrice, 'stCostPrice');
  lTXLineRec.TKStockRec.CostPrice := CustomSetReal(lTXLineRec.TKStockRec.CostPrice, Value, FDataChanged);
end;


function TTradeEventStock.Get_stCostPriceCur: Integer;
begin
  Result := lTXLineRec.TKStockRec.PCurrency;
end;

procedure TTradeEventStock.Set_stCostPriceCur(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstCostPriceCur, 'stCostPriceCur');
  lTXLineRec.TKStockRec.PCurrency := CustomSetInteger(lTXLineRec.TKStockRec.PCurrency, Value, FDataChanged);
end;


function TTradeEventStock.Get_stCover: ITradeStockCover;
begin
  Result := FCoverI;
end;


function TTradeEventStock.Get_stDefaultLineType: TTradeTransLineType;
begin
  Result := lTXLineRec.TKStockRec.StkLinkLT;
end;

procedure TTradeEventStock.Set_stDefaultLineType(
  Value: TTradeTransLineType);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxNeverAuthorise, 'stDefaultLineType');
  lTXLineRec.TKStockRec.StkLinkLT := CustomSetInteger(lTXLineRec.TKStockRec.StkLinkLT, Value, FDataChanged);
end;


function TTradeEventStock.Get_stDepartment: WideString;
begin
  Result := lTXLineRec.TKStockRec.Dep;
end;

procedure TTradeEventStock.Set_stDepartment(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstDepartment, 'stDepartment');
  lTXLineRec.TKStockRec.Dep := CustomSetString(lTXLineRec.TKStockRec.Dep, Value, FDataChanged);
end;


function TTradeEventStock.Get_stDesc(Index: Integer): WideString;
begin
  Result := lTXLineRec.TKStockRec.Desc[Index];
end;

procedure TTradeEventStock.Set_stDesc(Index: Integer;
  const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstDesc, 'stDesc');
  lTXLineRec.TKStockRec.Desc[Index] := CustomSetString(lTXLineRec.TKStockRec.Desc[Index], Value, FDataChanged);
end;


function TTradeEventStock.Get_stFolioNum: Integer;
begin
  Result := lTXLineRec.TKStockRec.StockFolio;
end;


function TTradeEventStock.Get_stImageFile: WideString;
begin
  Result := lTXLineRec.TKStockRec.ImageFile;
end;

procedure TTradeEventStock.Set_stImageFile(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstImageFile, 'stImageFile');
  lTXLineRec.TKStockRec.ImageFile := CustomSetString(lTXLineRec.TKStockRec.ImageFile, Value, FDataChanged);
end;


function TTradeEventStock.Get_stInclusiveVATCode: WideString;
begin
  Result := lTXLineRec.TKStockRec.SVATIncFlg;
end;

procedure TTradeEventStock.Set_stInclusiveVATCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstInclusiveVATCode, 'stInclusiveVATCode');
  lTXLineRec.TKStockRec.SVATIncFlg := ExtractChar(CustomSetString(lTXLineRec.TKStockRec.SVATIncFlg, Value, FDataChanged), #255);
end;


function TTradeEventStock.Get_stIntrastat: ITradeStockIntrastat;
begin
  Result := FIntraI;
end;


function TTradeEventStock.Get_stLastUsed: WideString;
begin
  Result := lTXLineRec.TKStockRec.LastUsed;
end;


function TTradeEventStock.Get_stLocation: WideString;
begin
  Result := lTXLineRec.TKStockRec.StLocation;
end;

procedure TTradeEventStock.Set_stLocation(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstLocation, 'stLocation');
  lTXLineRec.TKStockRec.StLocation := CustomSetString(lTXLineRec.TKStockRec.StLocation, Value, FDataChanged);
end;


function TTradeEventStock.Get_stOperator: WideString;
begin
  Result := lTXLineRec.TKStockRec.LastOpo;
end;

procedure TTradeEventStock.Set_stOperator(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstOperator, 'stOperator');
  lTXLineRec.TKStockRec.LastOpo := CustomSetString(lTXLineRec.TKStockRec.LastOpo, Value, FDataChanged);
end;


function TTradeEventStock.Get_stPandLGL: Integer;
begin
  Result := lTXLineRec.TKStockRec.NomCodes[3];
end;

procedure TTradeEventStock.Set_stPandLGL(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstPandLGL, 'stPandLGL');
  lTXLineRec.TKStockRec.NomCodes[3] := CustomSetInteger(lTXLineRec.TKStockRec.NomCodes[3], Value, FDataChanged);
end;


function TTradeEventStock.Get_stParentCode: WideString;
begin
  Result := lTXLineRec.TKStockRec.StockCat;
end;

procedure TTradeEventStock.Set_stParentCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstParentCode, 'stParentCode');
  lTXLineRec.TKStockRec.StockCat := CustomSetString(lTXLineRec.TKStockRec.StockCat, Value, FDataChanged);
end;


function TTradeEventStock.Get_stPricingMethod: TTradeStockPricingMethod;
begin
//  Result := lTXLineRec.TKStockRec.

  With lTXLineRec.TKStockRec Do
    If PriceByStkUnit then
      Result := spmByStockUnit
    else
      If StPricePack then
        Result := spmBySplitPack
      else
        Result := spmBySalesUnit;

end;

procedure TTradeEventStock.Set_stPricingMethod(
  Value: TTradeStockPricingMethod);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstPricingMethod, 'stPricingMethod');

  lTXLineRec.TKStockRec.PriceByStkUnit := CustomSetBoolean(lTXLineRec.TKStockRec.PriceByStkUnit
  , (Value = spmByStockUnit), FDataChanged);

  lTXLineRec.TKStockRec.StPricePack    := CustomSetBoolean(lTXLineRec.TKStockRec.PriceByStkUnit
  , (Value = spmBySplitPack), FDataChanged);
end;


function TTradeEventStock.Get_stPurchUnits: Double;
begin
  Result := lTXLineRec.TKStockRec.BuyUnit;
end;

procedure TTradeEventStock.Set_stPurchUnits(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstPurchUnits, 'stPurchUnits');
  lTXLineRec.TKStockRec.BuyUnit := CustomSetReal(lTXLineRec.TKStockRec.BuyUnit, Value, FDataChanged);
end;


function TTradeEventStock.Get_stQtyAllocated: Double;
begin
  Result := lTXLineRec.TKStockRec.QtyAllocated;
end;


function TTradeEventStock.Get_stQtyFree: Double;
begin
  If Syss.FreeExAll Then
    Result := lTXLineRec.TKStockRec.QtyInStock
  Else Begin
    If Syss.UsePick4All Then
      Result := lTXLineRec.TKStockRec.QtyInStock - lTXLineRec.TKStockRec.QtyPicked
    Else
      Result := lTXLineRec.TKStockRec.QtyInStock - lTXLineRec.TKStockRec.QtyAllocated;
  End; { Else }
end;


function TTradeEventStock.Get_stQtyInStock: Double;
begin
  Result := lTXLineRec.TKStockRec.QtyInStock;
end;


function TTradeEventStock.Get_stQtyMax: Double;
begin
  Result := lTXLineRec.TKStockRec.QtyMax;
end;

procedure TTradeEventStock.Set_stQtyMax(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstQtyMax, 'stQtyMax');
  lTXLineRec.TKStockRec.QtyMax := CustomSetReal(lTXLineRec.TKStockRec.QtyMax, Value, FDataChanged);
end;


function TTradeEventStock.Get_stQtyMin: Double;
begin
  Result := lTXLineRec.TKStockRec.QtyMin;
end;

procedure TTradeEventStock.Set_stQtyMin(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstQtyMin, 'stQtyMin');
  lTXLineRec.TKStockRec.QtyMin := CustomSetReal(lTXLineRec.TKStockRec.QtyMin, Value, FDataChanged);
end;


function TTradeEventStock.Get_stQtyOnOrder: Double;
begin
  Result := lTXLineRec.TKStockRec.QtyOnOrder;
end;


function TTradeEventStock.Get_stQtyPicked: Double;
begin
  Result := lTXLineRec.TKStockRec.QtyPicked;
end;


function TTradeEventStock.Get_stQtyPosted: Double;
begin
  Result := lTXLineRec.TKStockRec.QtyPosted;
end;


function TTradeEventStock.Get_stReorder: ITradeStockReorder;
begin
  Result := FReorderI;
end;


Function TTradeEventStock.GetSalesBandPrice (Const BandNo : Byte) : Double;
begin
  Result := lTXLineRec.TKStockRec.SaleBands[BandNo].SalesPrice;
end;

Procedure TTradeEventStock.SetSalesBandPrice (Const BandNo : Byte; Const Value : Double;  var bChanged : boolean);
begin
  lTXLineRec.TKStockRec.SaleBands[BandNo].SalesPrice := CustomSetReal(lTXLineRec.TKStockRec.SaleBands[BandNo].SalesPrice
  , Value, bChanged);
end;

Function TTradeEventStock.GetSalesBandCcy (Const BandNo : Byte) : Integer;
begin
  Result := lTXLineRec.TKStockRec.SaleBands[BandNo].Currency;
end;

Procedure TTradeEventStock.SetSalesBandCcy (Const BandNo : Byte; Const Value : Integer; var bChanged : boolean);
var
  FVersionO : TTradeVersion;
begin
  FVersionO := TTradeVersion.Create;

  lTXLineRec.TKStockRec.SaleBands[BandNo].Currency := CustomSetInteger(lTXLineRec.TKStockRec.SaleBands[BandNo].Currency
  , FVersionO.ValidateCurrencyNo(Value), bChanged);

  FVersionO := nil;
end;


function TTradeEventStock.Get_stSalesBands(const Band: WideString): ITradeStockSalesBand;
Var
  BandChar : Char;
  BandNo   : Byte;
begin
  // Decode Band Number
  BandChar := ExtractChar(UpperCase(Band), #255);
  If (BandChar In ['A'..'H']) Then Begin
    BandNo := Ord(BandChar) - Ord('A') + 1;

    { Check Sales Band sub-object has been initialised }
    If (Not Assigned(FSalesBandO[BandNo])) Then Begin
      { Create and initialise Sales Band sub-object }
      FSalesBandO[BandNo] := TTradeStockSalesBand.Create(oEventData, oLineData, BandNo, GetSalesBandPrice
      , SetSalesBandPrice, GetSalesBandCcy, SetSalesBandCcy);

      FSalesBandI[BandNo] := FSalesBandO[BandNo];
    End; { If (Not Assigned(FSalesBandO[BandNo]))  }

    Result := FSalesBandI[BandNo];
  End { If (BandChar In ['A'..'H']) }
  Else
    Raise EUnknownValue.Create ('Invalid Sales Band Index (' + BandChar + ')');
end;


function TTradeEventStock.Get_stSalesGL: Integer;
begin
  Result := lTXLineRec.TKStockRec.NomCodes[1];
end;

procedure TTradeEventStock.Set_stSalesGL(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstSalesGL, 'stSalesGL');
  lTXLineRec.TKStockRec.NomCodes[1] := CustomSetInteger(lTXLineRec.TKStockRec.NomCodes[1], Value, FDataChanged);
end;


function TTradeEventStock.Get_stSalesUnits: Double;
begin
  Result := lTXLineRec.TKStockRec.SellUnit;
end;

procedure TTradeEventStock.Set_stSalesUnits(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstSalesUnits, 'stSalesUnits');
  lTXLineRec.TKStockRec.SellUnit := CustomSetReal(lTXLineRec.TKStockRec.SellUnit, Value, FDataChanged);
end;


function TTradeEventStock.Get_stShowKitOnPurchase: WordBool;
begin
  Result := lTXLineRec.TKStockRec.StKitOnPurch;
end;

procedure TTradeEventStock.Set_stShowKitOnPurchase(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstShowKitOnPurchase, 'stShowKitOnPurchase');
  lTXLineRec.TKStockRec.StKitOnPurch := CustomSetBoolean(lTXLineRec.TKStockRec.StKitOnPurch, Value, FDataChanged);
end;


function TTradeEventStock.Get_stShowQtyAsPacks: WordBool;
begin
  Result := lTXLineRec.TKStockRec.stDPackQty;
end;

procedure TTradeEventStock.Set_stShowQtyAsPacks(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstShowQtyAsPacks, 'stShowQtyAsPacks');
  lTXLineRec.TKStockRec.stDPackQty := CustomSetBoolean(lTXLineRec.TKStockRec.stDPackQty, Value, FDataChanged);
end;


function TTradeEventStock.Get_stSupplier: WideString;
begin
  Result := lTXLineRec.TKStockRec.Supplier;
end;

procedure TTradeEventStock.Set_stSupplier(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstSupplier, 'stSupplier');
  lTXLineRec.TKStockRec.Supplier := CustomSetString(lTXLineRec.TKStockRec.Supplier, Value, FDataChanged);
end;


function TTradeEventStock.Get_stSuppTemp: WideString;
begin
  Result := lTXLineRec.TKStockRec.SuppTemp;
end;

procedure TTradeEventStock.Set_stSuppTemp(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstSuppTemp, 'stSuppTemp');
  lTXLineRec.TKStockRec.SuppTemp := CustomSetString(lTXLineRec.TKStockRec.SuppTemp, Value, FDataChanged);
end;


function TTradeEventStock.Get_stTimeChange: WideString;
begin
  Result := lTXLineRec.TKStockRec.TimeChange;
end;


function TTradeEventStock.Get_stType: TTradeStockType;
begin
  Case lTXLineRec.TKStockRec.StockType Of
    'G' : Result := stTypeGroup;
    'P' : Result := stTypeProduct;
    'D' : Result := stTypeDescription;
    'M' : Result := stTypeBillOfMaterials;
    'X' : Result := stTypeDiscontinued;
  Else
    Raise EUnknownValue.Create ('Invalid Stock Type (' + lTXLineRec.TKStockRec.StockType + ')');
  End; { Case }
end;

procedure TTradeEventStock.Set_stType(Value: TTradeStockType);
var
  cType : WideChar;
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstType, 'stType');

  Case Value Of
    stTypeGroup : cType := 'G';
    stTypeProduct : cType := 'P';
    stTypeDescription : cType := 'D';
    stTypeBillOfMaterials : cType := 'M';
    stTypeDiscontinued : cType := 'X';
  End; { Case }
  lTXLineRec.TKStockRec.StockType := ExtractChar(CustomSetString(lTXLineRec.TKStockRec.StockType, cType, FDataChanged),#255);
end;


function TTradeEventStock.Get_stUnitOfPurch: WideString;
begin
  Result := lTXLineRec.TKStockRec.UnitP;
end;

procedure TTradeEventStock.Set_stUnitOfPurch(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstUnitOfPurch, 'stUnitOfPurch');
  lTXLineRec.TKStockRec.UnitP := CustomSetString(lTXLineRec.TKStockRec.UnitP, Value, FDataChanged);
end;


function TTradeEventStock.Get_stUnitOfSale: WideString;
begin
  Result := lTXLineRec.TKStockRec.UnitS;
end;

procedure TTradeEventStock.Set_stUnitOfSale(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstUnitOfSale, 'stUnitOfSale');
  lTXLineRec.TKStockRec.UnitS := CustomSetString(lTXLineRec.TKStockRec.UnitS, Value, FDataChanged);
end;


function TTradeEventStock.Get_stUnitOfStock: WideString;
begin
  Result := lTXLineRec.TKStockRec.UnitK;
end;

procedure TTradeEventStock.Set_stUnitOfStock(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstUnitOfStock, 'stUnitOfStock');
  lTXLineRec.TKStockRec.UnitK := CustomSetString(lTXLineRec.TKStockRec.UnitK, Value, FDataChanged);
end;


function TTradeEventStock.Get_stUseForEbus: WordBool;
begin
  Result := (lTXLineRec.TKStockRec.WebInclude <> 0);
end;

procedure TTradeEventStock.Set_stUseForEbus(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxstUseForEbus, 'stUseForEbus');
  if Value then lTXLineRec.TKStockRec.WebInclude := CustomSetInteger(lTXLineRec.TKStockRec.WebInclude, 0, FDataChanged)
  else lTXLineRec.TKStockRec.WebInclude := CustomSetInteger(lTXLineRec.TKStockRec.WebInclude, 1, FDataChanged);
end;


function TTradeEventStock.Get_stUseKitPrice: WordBool;
begin
  Result := lTXLineRec.TKStockRec.StKitPrice;
end;

procedure TTradeEventStock.Set_stUseKitPrice(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstUseKitPrice, 'stUseKitPrice');
  lTXLineRec.TKStockRec.StKitPrice := CustomSetBoolean(lTXLineRec.TKStockRec.StKitPrice, Value, FDataChanged);
end;


function TTradeEventStock.Get_stUserField1: WideString;
begin
  Result := lTXLineRec.TKStockRec.StStkUser1;
end;

procedure TTradeEventStock.Set_stUserField1(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstUserField1, 'stUserField1');
  lTXLineRec.TKStockRec.StStkUser1 := CustomSetString(lTXLineRec.TKStockRec.StStkUser1, Value, FDataChanged);
end;


function TTradeEventStock.Get_stUserField2: WideString;
begin
  Result := lTXLineRec.TKStockRec.StStkUser2;
end;

procedure TTradeEventStock.Set_stUserField2(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstUserField2, 'stUserField2');
  lTXLineRec.TKStockRec.StStkUser2 := CustomSetString(lTXLineRec.TKStockRec.StStkUser2, Value, FDataChanged);
end;


function TTradeEventStock.Get_stUserField3: WideString;
begin
  Result := lTXLineRec.TKStockRec.StkUser3;
end;

procedure TTradeEventStock.Set_stUserField3(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstUserField3, 'stUserField3');
  lTXLineRec.TKStockRec.StkUser3 := CustomSetString(lTXLineRec.TKStockRec.StkUser3, Value, FDataChanged);
end;


function TTradeEventStock.Get_stUserField4: WideString;
begin
  Result := lTXLineRec.TKStockRec.StkUser4;
end;

procedure TTradeEventStock.Set_stUserField4(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstUserField4, 'stUserField4');
  lTXLineRec.TKStockRec.StkUser4 := CustomSetString(lTXLineRec.TKStockRec.StkUser4, Value, FDataChanged);
end;


function TTradeEventStock.Get_stValuationMethod: TTradeStockValuationType;
begin
  Case lTXLineRec.TKStockRec.StkValType Of
    'A' : If (lTXLineRec.TKStockRec.SerNoWAvg = 1) Then
            Result := stValSerialAvgCost
          Else
            Result := stValAverage;
    'C' : Result := stValLastCost;
    'F' : Result := stValFIFO;
    'L' : Result := stValLIFO;
    'R' : Result := stValSerial;
    'S' : Result := stValStandard;
  Else
    Raise EUnknownValue.Create ('Invalid Stock Valuation Method (' + lTXLineRec.TKStockRec.StkValType + ')');
  End; { Case }
end;

procedure TTradeEventStock.Set_stValuationMethod(Value: TTradeStockValuationType);
var
  sValType : WideString;
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstValuationMethod, 'stValuationMethod');

  case Value of
    stValSerialAvgCost : begin
      sValType := 'A';
      lTXLineRec.TKStockRec.SerNoWAvg := CustomSetInteger(lTXLineRec.TKStockRec.SerNoWAvg, 1, FDataChanged);
    end;

    stValAverage : begin
      sValType := 'A';
      lTXLineRec.TKStockRec.SerNoWAvg := CustomSetInteger(lTXLineRec.TKStockRec.SerNoWAvg, 0, FDataChanged);
    end;

    stValLastCost : sValType := 'C';
    stValFIFO : sValType := 'F';
    stValLIFO : sValType := 'L';
    stValSerial : sValType := 'R';
    stValStandard : sValType := 'S';
  end; { Case }

  lTXLineRec.TKStockRec.StkValType := ExtractChar(CustomSetString(lTXLineRec.TKStockRec.StkValType, sValType, FDataChanged), #255);

end;


function TTradeEventStock.Get_stVATCode: WideString;
begin
  Result := lTXLineRec.TKStockRec.VATCode;
end;

procedure TTradeEventStock.Set_stVATCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstVATCode, 'stVATCode');
  lTXLineRec.TKStockRec.VATCode := ExtractChar(CustomSetString(lTXLineRec.TKStockRec.VATCode, Value, FDataChanged),#255);
end;


function TTradeEventStock.Get_stWebLiveCatalog: WideString;
begin
  Result := lTXLineRec.TKStockRec.WebLiveCat;
end;

procedure TTradeEventStock.Set_stWebLiveCatalog(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstWebLiveCatalog, 'stWebLiveCatalog');
  lTXLineRec.TKStockRec.WebLiveCat := CustomSetString(lTXLineRec.TKStockRec.WebLiveCat, Value, FDataChanged);
end;


function TTradeEventStock.Get_stWebPrevCatalog: WideString;
begin
  Result := lTXLineRec.TKStockRec.WebPrevCat;
end;

procedure TTradeEventStock.Set_stWebPrevCatalog(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstWebPrevCatalog, 'stWebPrevCatalog');
  lTXLineRec.TKStockRec.WebPrevCat := CustomSetString(lTXLineRec.TKStockRec.WebPrevCat, Value, FDataChanged);
end;


function TTradeEventStock.Get_stWIPGL: Integer;
begin
  Result := lTXLineRec.TKStockRec.NomCodes[5];
end;

procedure TTradeEventStock.Set_stWIPGL(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxstWIPGL, 'stWIPGL');
  lTXLineRec.TKStockRec.NomCodes[5] := CustomSetInteger(lTXLineRec.TKStockRec.NomCodes[5], Value, FDataChanged);
end;

Procedure TTradeEventStock.InitObjects;
Var
  I : Byte;
Begin { Destroy }
  // Cover sub-object
  FCoverO := NIL;
  FCoverI := NIL;

  // Intrastat sub-object
  FIntraO := NIL;
  FIntraI := NIL;

  // Re-order sub-object
  FReorderO := NIL;
  FReorderI := NIL;

  // Sales Bands sub-objects
  For I := Low(FSalesBandO) To High(FSalesBandO) Do Begin
    FSalesBandO[I] := NIL;
    FSalesBandI[I] := NIL;
  End; { For I }

End; { Destroy }



end.
