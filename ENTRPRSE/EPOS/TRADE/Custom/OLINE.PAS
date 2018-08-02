// Implementation of the "thLine" COM Object
unit oLine;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  EPOSProc, ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, SysUtils, TXRecs
  , CustomP, oStock, DLLInc, oSerials, oLoctn, ComCtrls, BTKeys1U;

type
  TTransLinePropertyIndex = (pIdx_NEVER_AUTHORISE, pIdxtlQty, pIdxtlStockCode
  , pIdxtlBOMKitLink, pIdxtlDescr, pIdxtlAnalysisCode, pIdxtlChargeCurrency
  , pIdxtlCompanyRate, pIdxtlCost, pIdxtlCostCentre, pIdxtlCurrency, pIdxtlDailyRate
  , pIdxtlDepartment, pIdxtlDiscFlag, pIdxtlDiscount, pIdxtlGLCode, pIdxtlInclusiveVATCode
  , pIdxtlItemNo, pIdxtlJobCode, pIdxtlLineDate, pIdxtlLineNo, pIdxtlLineType
  , pIdxtlRecStatus, pIdxtlNetValue, pIdxtlPayment, pIdxtlPriceMultiplier, pIdxtlQtyDel
  , pIdxtlQtyMul, pIdxtlQtyPicked, pIdxtlQtyPickedWO, pIdxtlQtyWOFF, pIdxtlSOPABSLineNo
  , pIdxtlSOPFolioNum, pIdxtlUserField1, pIdxtlUserField2, pIdxtlUserField3, pIdxtlUserField4
  , pIdxtlSSDUpliftPerc, pIdxtlSSDCommodCode, pIdxtlSSDCountry, pIdxtlSSDSalesUnit
  , pIdxtlSSDUseLineValues, pIdxtlUnitWeight, pIdxtlVATCode, pIdxtlVATAmount);

  TTransLineFunctionIndex = (fIdxSave, fIdxCancel);

  TTradeEventTransLine = class(TAutoIntfObject, ITradeEventTransLine, ITradeEventTransLine2)
  private
    // Records changes to properties of this object
    FDataChanged : Boolean;

    FStockO : TTradeEventStock;
    FStockI : ITradeEventStock;

    FSerialsO : TTradeEventSerialNumbers;
    FSerialsI : ITradeEventSerialNumbers;

    FLocationO : TTradeEventLocation;
    FLocationI : ITradeEventLocation;

    oEventData : TObject;
    oLines : TObject;

    procedure RecalcLineAndHeader;

  protected
    function Get_tlLineNo: Integer; safecall;
    procedure Set_tlLineNo(Value: Integer); safecall;
    function Get_tlGLCode: Integer; safecall;
    procedure Set_tlGLCode(Value: Integer); safecall;
    function Get_tlCurrency: Integer; safecall;
    procedure Set_tlCurrency(Value: Integer); safecall;
    function Get_tlCompanyRate: Double; safecall;
    procedure Set_tlCompanyRate(Value: Double); safecall;
    function Get_tlDailyRate: Double; safecall;
    procedure Set_tlDailyRate(Value: Double); safecall;
    function Get_tlCostCentre: WideString; safecall;
    procedure Set_tlCostCentre(const Value: WideString); safecall;
    function Get_tlDepartment: WideString; safecall;
    procedure Set_tlDepartment(const Value: WideString); safecall;
    function Get_tlStockCode: WideString; safecall;
    procedure Set_tlStockCode(const Value: WideString); safecall;
    function Get_tlQty: Double; safecall;
    procedure Set_tlQty(Value: Double); safecall;
    function Get_tlQtyMul: Double; safecall;
    procedure Set_tlQtyMul(Value: Double); safecall;
    function Get_tlNetValue: Double; safecall;
    procedure Set_tlNetValue(Value: Double); safecall;
    function Get_tlDiscount: Double; safecall;
    procedure Set_tlDiscount(Value: Double); safecall;
    function Get_tlDiscFlag: WideString; safecall;
    procedure Set_tlDiscFlag(const Value: WideString); safecall;
    function Get_tlVATCode: WideString; safecall;
    procedure Set_tlVATCode(const Value: WideString); safecall;
    function Get_tlVATAmount: Double; safecall;
    procedure Set_tlVATAmount(Value: Double); safecall;
    function Get_tlPayment: WordBool; safecall;
    procedure Set_tlPayment(Value: WordBool); safecall;
    function Get_tlQtyWOFF: Double; safecall;
    procedure Set_tlQtyWOFF(Value: Double); safecall;
    function Get_tlQtyDel: Double; safecall;
    procedure Set_tlQtyDel(Value: Double); safecall;
    function Get_tlCost: Double; safecall;
    procedure Set_tlCost(Value: Double); safecall;
    function Get_tlLineDate: WideString; safecall;
    procedure Set_tlLineDate(const Value: WideString); safecall;
    function Get_tlItemNo: WideString; safecall;
    procedure Set_tlItemNo(const Value: WideString); safecall;
    function Get_tlDescr: WideString; safecall;
    procedure Set_tlDescr(const Value: WideString); safecall;
    function Get_tlJobCode: WideString; safecall;
    procedure Set_tlJobCode(const Value: WideString); safecall;
    function Get_tlAnalysisCode: WideString; safecall;
    procedure Set_tlAnalysisCode(const Value: WideString); safecall;
    function Get_tlUnitWeight: Double; safecall;
    procedure Set_tlUnitWeight(Value: Double); safecall;
    function Get_tlLocation: ITradeEventLocation; safecall;
    function Get_tlChargeCurrency: Integer; safecall;
    procedure Set_tlChargeCurrency(Value: Integer); safecall;
    function Get_tlAcCode: WideString; safecall;
    function Get_tlLineType: TTradeTransLineType; safecall;
    procedure Set_tlLineType(Value: TTradeTransLineType); safecall;
    function Get_tlFolioNum: Integer; safecall;
    function Get_tlLineClass: WideString; safecall;
    function Get_tlRecStatus: Smallint; safecall;
    procedure Set_tlRecStatus(Value: Smallint); safecall;
    function Get_tlSOPFolioNum: Integer; safecall;
    procedure Set_tlSOPFolioNum(Value: Integer); safecall;
    function Get_tlSOPABSLineNo: Integer; safecall;
    procedure Set_tlSOPABSLineNo(Value: Integer); safecall;
    function Get_tlABSLineNo: Integer; safecall;
    function Get_tlUserField1: WideString; safecall;
    procedure Set_tlUserField1(const Value: WideString); safecall;
    function Get_tlUserField2: WideString; safecall;
    procedure Set_tlUserField2(const Value: WideString); safecall;
    function Get_tlUserField3: WideString; safecall;
    procedure Set_tlUserField3(const Value: WideString); safecall;
    function Get_tlUserField4: WideString; safecall;
    procedure Set_tlUserField4(const Value: WideString); safecall;
    function Get_tlSSDUpliftPerc: Double; safecall;
    procedure Set_tlSSDUpliftPerc(Value: Double); safecall;
    function Get_tlSSDCommodCode: WideString; safecall;
    procedure Set_tlSSDCommodCode(const Value: WideString); safecall;
    function Get_tlSSDSalesUnit: Double; safecall;
    procedure Set_tlSSDSalesUnit(Value: Double); safecall;
    function Get_tlSSDUseLineValues: WordBool; safecall;
    procedure Set_tlSSDUseLineValues(Value: WordBool); safecall;
    function Get_tlPriceMultiplier: Double; safecall;
    procedure Set_tlPriceMultiplier(Value: Double); safecall;
    function Get_tlQtyPicked: Double; safecall;
    procedure Set_tlQtyPicked(Value: Double); safecall;
    function Get_tlQtyPickedWO: Double; safecall;
    procedure Set_tlQtyPickedWO(Value: Double); safecall;
    function Get_tlSSDCountry: WideString; safecall;
    procedure Set_tlSSDCountry(const Value: WideString); safecall;
    function Get_tlInclusiveVATCode: WideString; safecall;
    procedure Set_tlInclusiveVATCode(const Value: WideString); safecall;
    function Get_tlBOMKitLink: Integer; safecall;
    procedure Set_tlBOMKitLink(Value: Integer); safecall;
    function Get_tlOurRef: WideString; safecall;
    function Get_tlStock: ITradeEventStock; safecall;
    function Get_tlSerialNumbers: ITradeEventSerialNumbers; safecall;

    function Get_tlMultiBuyDiscount: Double; safecall;
    procedure Set_tlMultiBuyDiscount(Value: Double); safecall;
    function Get_tlMultiBuyDiscountFlag: WideString; safecall;
    procedure Set_tlMultiBuyDiscountFlag(const Value: WideString); safecall;
    function Get_tlTransValueDiscount: Double; safecall;
    procedure Set_tlTransValueDiscount(Value: Double); safecall;
    function Get_tlTransValueDiscountFlag: WideString; safecall;
    procedure Set_tlTransValueDiscountFlag(const Value: WideString); safecall;
    function Get_tlTransValueDiscountType: Smallint; safecall;
    procedure Set_tlTransValueDiscountType(Value: Smallint); safecall;

    procedure Save; safecall;
    procedure Cancel; safecall;

    // Local Methods
    Procedure AuthoriseProperty (Const PropertyIdx : TTransLinePropertyIndex; const PropName : ShortString);
    Procedure AuthoriseFunction (Const FunctionIdx : TTransLineFunctionIndex; const FuncName : ShortString);

    Function GetDataChanged : Boolean;
  public
    // properties of this object OR any sub-objects

    iLineNo : integer;
    LTXLineRec : pTXLineRec;
//    LTXRec : pTXRec;

    // DataChanged flag indicates whether Plug-Ins made any changes to
    Property DataChanged : Boolean Read GetDataChanged;

    Constructor Create;
    Destructor Destroy; override;

//    Procedure Assign (EventData : TObject; TheTXLineRec : pTXLineRec);
    Procedure Assign(EventData, Lines : TObject; TheTXLineRec : pTXLineRec; LineNo : integer);
  End; { TTradeEventTransaction }

implementation

uses
  Math, CalcPric, EPOSCnst, EntLkup, StrUtil, oEvent, ComServ, oVersion, ETMiscU, oLines;

//---------------------------------------------------------------------------

Constructor TTradeEventTransLine.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeEventTransline2);

  FStockO := TTradeEventStock.Create;
  FStockI := FStockO;

  FSerialsO := TTradeEventSerialNumbers.Create;
  FSerialsI := FSerialsO;

  FLocationO := TTradeEventLocation.Create;
  FLocationI := FLocationO;

  FDataChanged := False;
End; { Create }

//---------------------------------------------------------------------------

Destructor TTradeEventTransLine.Destroy;
Begin { Destroy }

  FSerialsO := nil;
  FSerialsI := nil;

  FStockO := nil;
  FStockI := nil;

  FLocationO := nil;
  FLocationI := nil;

  Inherited;
End; { Destroy }

//---------------------------------------------------------------------------

Procedure TTradeEventTransLine.Assign(EventData, Lines : TObject; TheTXLineRec : pTXLineRec; LineNo : integer);

begin { Assign }
  // Reset Datachanged flag for new event
  FDataChanged := False;
  oEventData := EventData;
  oLines := Lines;
  LTXLineRec := TheTXLineRec;
  iLineNo := LineNo;
//  LTXRec := TheTXRec;

  // Assign Sub Objects
  FStockO.Assign(oEventData, Self);
  FSerialsO.Assign(oEventData, Self);
  FLocationO.Assign(oEventData, Self);
end; { Assign }

//---------------------------------------------------------------------------

// Returns True if the specified property can be written to by the Plug-In during the current event
Procedure TTradeEventTransLine.AuthoriseProperty (Const PropertyIdx : TTransLinePropertyIndex; const PropName : ShortString);
Var
  bAuthorised : Boolean;
Begin { AuthoriseProperty }

  // Check for specific enablement of fields
  bAuthorised := FALSE;

  with TTradeEventData(oEventData) do begin

    // Authorise if appropriate
    case PropertyIdx of
      pIdx_NEVER_AUTHORISE  : bAuthorised := FALSE;

      pIdxtlStockCode : bAuthorised := HookIsTXLineInitialise and (iLineNo = CURRENT_LINE);

//      pIdxtlQty : begin
      pIdxtlQty, pIdxtlQtyPicked : begin
        bAuthorised := ((HookIsBeforeTenderScreen or HookIsTXHeadCustom1 or HookIsTXHeadCustom2)
        and (iLineNo = NEW_LINE))
        or ((HookIsTXLineInitialise or HookIsTXLineEnterQuantity
        or HookIsNonStockEnterQuantity) and (iLineNo = CURRENT_LINE))
      end;

      pIdxtlUnitWeight : begin
        bAuthorised := (HookIsTXLineBeforeStore or HookIsNonStockBeforeStore) and (iLineNo = CURRENT_LINE);
      end;

      pIdxtlNetValue, pIdxtlVATAmount, pIdxtlGLCode, pIdxtlCostCentre, pIdxtlDepartment, pIdxtlDescr : begin
        bAuthorised := (HookIsBeforeTenderScreen or HookIsTXHeadCustom1 or HookIsTXHeadCustom2)
        and (iLineNo = NEW_LINE);
      end;

      pIdxtlVATCode, pIdxtlInclusiveVATCode : begin
        bAuthorised := ((HookIsBeforeTenderScreen or HookIsTXHeadCustom1 or HookIsTXHeadCustom2)
        and (iLineNo = NEW_LINE)) or (HookIsTXLineBeforeCalcStockPrice and (iLineNo = CURRENT_LINE));
      end;

      pIdxtlUserField1, pIdxtlUserField2, pIdxtlUserField3, pIdxtlUserField4 : begin
        bAuthorised := ((iLineNo = CURRENT_LINE) and (HookIsTXLineCustom1
        or HookIsTXLineCustom2 or HookIsNonStockCustom1 or HookIsNonStockCustom2
        or HookIsTXLineInitialise or HookIsTXLineEnterQuantity or HookIsNonStockEnterQuantity
        or HookIsTXLineBeforeStore or HookIsNonStockBeforeStore))
        or ((HookIsBeforeTenderScreen or HookIsTXHeadCustom1 or HookIsTXHeadCustom2)
        {and (iLineNo = NEW_LINE)});
//        or ((HookIsTXHeadCustom1 or HookIsTXHeadCustom2) and (iLineNo <> CURRENT_LINE) and (iLineNo <> NEW_LINE));
      end;

      pIdxtlDiscount, pIdxtlDiscFlag : begin
        bAuthorised := HookIsBeforeTenderScreen;
      end;
    end; { Case }

    If (Not bAuthorised) Then begin
      // Raise exception to notify the user that the Plug-In has been naughty
      Raise ERightsError.Create (Format('Customisation Error in ITradeEventTransLine for Event %d.%d - The property %s is Read-Only'
      , [FWindowId, FHandlerId, QuotedStr(PropName)]));
    end;{if}
  end;{with}
End; { AuthoriseProperty }

//---------------------------------------------------------------------------

// Returns True if the specified function/procedure can be called by the Plug-In during the current event
Procedure TTradeEventTransLine.AuthoriseFunction (Const FunctionIdx : TTransLineFunctionIndex; const FuncName : ShortString);
var
  bAuthorised : Boolean;
begin

  // Check for specific enablement of fields
  bAuthorised := FALSE;

  with TTradeEventData(oEventData) do begin

    // Authorise if appropriate
    case FunctionIdx of
      fIdxSave, fIdxCancel : begin
        bAuthorised := iLineNo = NEW_LINE;
      end;
    end; { Case }

    If (Not bAuthorised) Then begin
      // Raise exception to notify the user that the Plug-In has been naughty
      Raise ERightsError.Create (Format('Customisation Error in ITradeEventTransLine for Event %d.%d - The property %s is Read-Only'
      , [FWindowId, FHandlerId, QuotedStr(FuncName)]));
    end;{if}
  end;{with}
end;

// Returns TRUE if any properties within the eventdata have been changed
Function TTradeEventTransLine.GetDataChanged : Boolean;
Begin { GetDataChanged }
  Result := FDataChanged or FStockO.DataChanged or FSerialsO.DataChanged
  or FLocationO.DataChanged;
End; { GetDataChanged }

//---------------------------------------------------------------------------

function TTradeEventTransLine.Get_tlABSLineNo: Integer;
begin
  Result := lTXLineRec.TKTLRec.ABSLineNo;
end;


function TTradeEventTransLine.Get_tlAcCode: WideString;
begin
//  Result := lTXLineRec.TKTLRec.CustCode;
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.CustCode;
end;


function TTradeEventTransLine.Get_tlAnalysisCode: WideString;
begin
  Result := lTXLineRec.TKTLRec.CustCode;
end;

procedure TTradeEventTransLine.Set_tlAnalysisCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlAnalysisCode, 'tlAnalysisCode');

  // Set Value
  lTXLineRec.TKTLRec.AnalCode := FullJACode(UpperCase(Value));
end;


function TTradeEventTransLine.Get_tlBOMKitLink: Integer;
begin
  Result := lTXLineRec.TKTLRec.KitLink;
end;

procedure TTradeEventTransLine.Set_tlBOMKitLink(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlBOMKitLink, 'tlBOMKitLink');

  // Set Value
  lTXLineRec.TKTLRec.KitLink := CustomSetInteger(lTXLineRec.TKTLRec.KitLink, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlChargeCurrency: Integer;
begin
  Result := lTXLineRec.TKTLRec.TSHCCurr;
end;

procedure TTradeEventTransLine.Set_tlChargeCurrency(Value: Integer);
var
  FVersionO : TTradeVersion;
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlChargeCurrency, 'tlChargeCurrency');

  // Set Value
  FVersionO := TTradeVersion.Create;
  lTXLineRec.TKTLRec.TSHCCurr := CustomSetInteger(lTXLineRec.TKTLRec.TSHCCurr
  , FVersionO.ValidateCurrencyNo(Value), FDataChanged);
  FVersionO := nil;
end;


function TTradeEventTransLine.Get_tlCompanyRate: Double;
begin
  Result := lTXLineRec.TKTLRec.CoRate;
end;

procedure TTradeEventTransLine.Set_tlCompanyRate(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlCompanyRate, 'tlCompanyRate');

  // Set Value
  lTXLineRec.TKTLRec.CoRate := CustomSetReal(lTXLineRec.TKTLRec.CoRate, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlCost: Double;
begin
  Result := Round_Up(lTXLineRec.TKTLRec.CostPrice, TKSysRec.CostDP);
end;

procedure TTradeEventTransLine.Set_tlCost(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlCost, 'tlCost');

  // Set Value
  lTXLineRec.TKTLRec.CostPrice := CustomSetReal(lTXLineRec.TKTLRec.CostPrice, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlCostCentre: WideString;
begin
  Result := lTXLineRec.TKTLRec.CC;
end;

procedure TTradeEventTransLine.Set_tlCostCentre(const Value: WideString);
var
  sCostCentre : string20;
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlCostCentre, 'tlCostCentre');

  // Check if Cost Centre code is valid.
  sCostCentre := Value;
  if DoGetCCDep(nil, sCurrCompPath, sCostCentre, sCostCentre, TRUE, vmCheckValue, TRUE) then
    begin
      // Set Value
      lTXLineRec.TKTLRec.CC := CustomSetString(lTXLineRec.TKTLRec.CC
      , FullCCDepKey(UpperCase(Value)), FDataChanged);
    end
  else begin
    Raise Exception.Create ('TTradeEventTransLine.Set_tlCostCentre - Invalid Cost Centre Code : ' + Trim(sCostCentre));
  end;{if}

end;


function TTradeEventTransLine.Get_tlCurrency: Integer;
begin
//  Result := lTXLineRec.TKTLRec.Currency;
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.Currency;
end;

procedure TTradeEventTransLine.Set_tlCurrency(Value: Integer);
var
  FVersionO : TTradeVersion;
begin
  // Check this property can be written to for this event
//  AuthoriseProperty(pIdxtlCurrency, 'tlCurrency');
  AuthoriseProperty(pIdx_NEVER_AUTHORISE, 'tlCurrency');

  // Set Value
  FVersionO := TTradeVersion.Create;
  lTXLineRec.TKTLRec.Currency := CustomSetInteger(lTXLineRec.TKTLRec.Currency
  , FVersionO.ValidateCurrencyNo(Value), FDataChanged);
  FVersionO := nil;
end;


function TTradeEventTransLine.Get_tlDailyRate: Double;
begin
  Result := lTXLineRec.TKTLRec.VATRate;
end;

procedure TTradeEventTransLine.Set_tlDailyRate(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlDailyRate, 'tlDailyRate');

  // Set Value
  lTXLineRec.TKTLRec.VATRate := CustomSetReal(lTXLineRec.TKTLRec.VATRate, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlDepartment: WideString;
begin
  Result := lTXLineRec.TKTLRec.Dep;
end;

procedure TTradeEventTransLine.Set_tlDepartment(const Value: WideString);
var
  sDepartment : string20;
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlDepartment, 'tlDepartment');

  sDepartment := Value;
  if DoGetCCDep(nil, sCurrCompPath, sDepartment, sDepartment
  , FALSE, vmCheckValue, TRUE) then
    begin
      // Set Value
      lTXLineRec.TKTLRec.Dep := CustomSetString(lTXLineRec.TKTLRec.Dep
      , FullCCDepKey(UpperCase(Value)), FDataChanged);
    end
  else begin
    Raise Exception.Create ('TTradeEventTransLine.Set_tlDepartment - Invalid Department Code : ' + Trim(sDepartment));
  end;{if}

end;


function TTradeEventTransLine.Get_tlDescr: WideString;
begin
  Result := lTXLineRec.sDesc;
end;

procedure TTradeEventTransLine.Set_tlDescr(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxtlDescr, 'tlDescr');

  // Set Value
  lTXLineRec.sDesc := CustomSetString(lTXLineRec.sDesc, Value, FDataChanged);
  lTXLineRec.TKStockRec.Desc[1] := CustomSetString(lTXLineRec.TKStockRec.Desc[1], Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlDiscFlag: WideString;
begin
//  Result := lTXLineRec.TKTLRec.DiscountChr;
  Result := lTXLineRec.cDiscount;
end;

procedure TTradeEventTransLine.Set_tlDiscFlag(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlDiscFlag, 'tlDiscFlag');

  // Set Value
  lTXLineRec.TKTLRec.DiscountChr := ExtractChar(CustomSetString(lTXLineRec.TKTLRec.DiscountChr
  , Value, FDataChanged), ' ');

  lTXLineRec.cDiscount := ExtractChar(CustomSetString(lTXLineRec.cDiscount, Value, FDataChanged), ' ');
  SetDiscountStr(lTXLineRec^);
  RecalcLineAndHeader;

  // recalc line and tx
//  CalcStockPrice(TTradeEventData(oEventData).LTXRec, lTXLineRec^, TRUE);
//  RecalcTXTotals(TTradeEventData(oEventData).LTXRec, TTradeEventData(oEventData).LListView);
end;


function TTradeEventTransLine.Get_tlDiscount: Double;
begin
//  Result := Round_Up(lTXLineRec.TKTLRec.Discount, TKSysRec.PriceDP);
  Result := Round_Up(lTXLineRec.rDiscount, TKSysRec.PriceDP);
end;

procedure TTradeEventTransLine.Set_tlDiscount(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlDiscount, 'tlDiscount');

  // Set Value
  case lTXLineRec.cDiscount of
    '%' : lTXLineRec.TKTLRec.Discount := CustomSetReal(lTXLineRec.TKTLRec.Discount, Value / 100, FDataChanged);
    #0, ' ' : lTXLineRec.TKTLRec.Discount := CustomSetReal(lTXLineRec.TKTLRec.Discount, Value, FDataChanged);
    '£' : begin
//      lTXLineRec.TKTLRec.NetValue := CustomSetReal(lTXLineRec.TKTLRec.NetValue, Value, FDataChanged);
{      lTXLineRec.rNetPrice := lTXLineRec.rPreEPOSDiscount;
      lTXLineRec.rVATAmountForOne := SimpleRoundTo(lTXLineRec.rTotalLineVATAmount / lTXLineRec.TKTLRec.Qty
      , -TKSysRec.PriceDP);
      lTXLineRec.rPrice := SimpleRoundTo(lTXLineRec.rNetPrice + lTXLineRec.rVATAmountForOne
      , -TKSysRec.PriceDP);}
//      lTXLineRec.TKTLRec.Discount := CustomSetReal(lTXLineRec.TKTLRec.Discount, Value, FDataChanged);
      lTXLineRec.TKTLRec.NetValue := CustomSetReal(lTXLineRec.TKTLRec.NetValue
      , Value, FDataChanged);
{      lTXLineRec.rLineNetTotal := CustomSetReal(lTXLineRec.rLineNetTotal
      , lTXLineRec.TKTLRec.NetValue * lTXLineRec.TKTLRec.Qty, FDataChanged);}
    end;
  end;{case}
  lTXLineRec.rDiscount := CustomSetReal(lTXLineRec.rDiscount, Value, FDataChanged);
  SetDiscountStr(lTXLineRec^);
  RecalcLineAndHeader;

  // recalc line and tx
//  CalcStockPrice(TTradeEventData(oEventData).LTXRec, lTXLineRec^, TRUE);
//  RecalcTXTotals(TTradeEventData(oEventData).LTXRec, TTradeEventData(oEventData).LListView);
end;


function TTradeEventTransLine.Get_tlFolioNum: Integer;
begin
  Result := lTXLineRec.TKTLRec.FolioNum;
end;


function TTradeEventTransLine.Get_tlGLCode: Integer;
begin
  Result := lTXLineRec.TKTLRec.NomCode;
end;

procedure TTradeEventTransLine.Set_tlGLCode(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlGLCode, 'tlGLCode');

  // Set Value
  lTXLineRec.TKTLRec.NomCode := CustomSetInteger(lTXLineRec.TKTLRec.NomCode, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlInclusiveVATCode: WideString;
begin
  Result := lTXLineRec.TKTLRec.VATIncFlg;
end;

procedure TTradeEventTransLine.Set_tlInclusiveVATCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlInclusiveVATCode, 'tlInclusiveVATCode');

  // Set Value on TX Line Record
  lTXLineRec.TKTLRec.VATIncFlg := ExtractChar(CustomSetString(lTXLineRec.TKTLRec.VATIncFlg
  , Value, FDataChanged), ' ');

  // Set Value on Stock Record
  lTXLineRec.TKStockRec.SVATIncFlg:= ExtractChar(CustomSetString(lTXLineRec.TKStockRec.SVATIncFlg
  , Value, FDataChanged),#255);
end;


function TTradeEventTransLine.Get_tlItemNo: WideString;
begin
  Result := lTXLineRec.TKTLRec.Item;
end;

procedure TTradeEventTransLine.Set_tlItemNo(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlItemNo, 'tlItemNo');

  // Set Value
  lTXLineRec.TKTLRec.Item := CustomSetString(lTXLineRec.TKTLRec.Item, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlJobCode: WideString;
begin
  Result := lTXLineRec.TKTLRec.JobCode;
end;

procedure TTradeEventTransLine.Set_tlJobCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlJobCode, 'tlJobCode');

  // Set Value
  lTXLineRec.TKTLRec.JobCode := CustomSetString(lTXLineRec.TKTLRec.JobCode, FullJobCode(UpperCase(Value)), FDataChanged);
end;


function TTradeEventTransLine.Get_tlLineClass: WideString;
begin
  Result := lTXLineRec.TKTLRec.LineType;
end;


function TTradeEventTransLine.Get_tlLineDate: WideString;
begin
  Result := lTXLineRec.TKTLRec.LineDate;
end;

procedure TTradeEventTransLine.Set_tlLineDate(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlLineDate, 'tlLineDate');

  // Set Value
  lTXLineRec.TKTLRec.LineDate := CustomSetString(lTXLineRec.TKTLRec.LineDate, Value, FDataChanged);
  lTXLineRec.bDateChangedByCustomisation := TRUE;
end;


function TTradeEventTransLine.Get_tlLineNo: Integer;
begin
  Result := lTXLineRec.TKTLRec.LineNo;
end;

procedure TTradeEventTransLine.Set_tlLineNo(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlLineNo, 'tlLineNo');

  // Set Value
  lTXLineRec.TKTLRec.LineNo := CustomSetInteger(lTXLineRec.TKTLRec.LineNo, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlLineType: TTradeTransLineType;
begin
  Result := lTXLineRec.TKTLRec.DocLTLink;
end;

procedure TTradeEventTransLine.Set_tlLineType(Value: TTradeTransLineType);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlLineType, 'tlLineType');

  // Set Value
  lTXLineRec.TKTLRec.DocLTLink := CustomSetInteger(lTXLineRec.TKTLRec.DocLTLink, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlRecStatus: Smallint;
begin
  Result := lTXLineRec.TKTLRec.Reconcile;
end;

procedure TTradeEventTransLine.Set_tlRecStatus(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlRecStatus, 'tlRecStatus');

  // Set Value
  lTXLineRec.TKTLRec.Reconcile := CustomSetInteger(lTXLineRec.TKTLRec.Reconcile, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlLocation: ITradeEventLocation;
begin
  Result := FLocationI;
end;


function TTradeEventTransLine.Get_tlNetValue: Double;
begin
//  Result := Round_Up(lTXLineRec.rNetPrice, TKSysRec.PriceDP);
  Result := Round_Up(lTXLineRec.rPreEPOSDiscount, TKSysRec.PriceDP);
end;

procedure TTradeEventTransLine.Set_tlNetValue(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlNetValue, 'tlNetValue');

  // Set Value
//  lTXLineRec.TKTLRec.NetValue := CustomSetReal(lTXLineRec.TKTLRec.NetValue, Value, FDataChanged);
  lTXLineRec.rPreEPOSDiscount := CustomSetReal(lTXLineRec.rPreEPOSDiscount, Value, FDataChanged);

end;


function TTradeEventTransLine.Get_tlOurRef: WideString;
begin
//  Result := lTXLineRec.TKTLRec.TransRefNo;
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.OurRef;
end;


function TTradeEventTransLine.Get_tlPayment: WordBool;
begin
  Result := lTXLineRec.TKTLRec.Payment;
end;

procedure TTradeEventTransLine.Set_tlPayment(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlPayment, 'tlPayment');

  // Set Value
  lTXLineRec.TKTLRec.Payment := CustomSetBoolean(lTXLineRec.TKTLRec.Payment, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlPriceMultiplier: Double;
begin
  Result := lTXLineRec.TKTLRec.PriceMulx;
end;

procedure TTradeEventTransLine.Set_tlPriceMultiplier(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlPriceMultiplier, 'tlPriceMultiplier');

  // Set Value
  lTXLineRec.TKTLRec.PriceMulx := CustomSetReal(lTXLineRec.TKTLRec.PriceMulx, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlQty: Double;
begin
  Result := lTXLineRec.TKTLRec.Qty;
end;

procedure TTradeEventTransLine.Set_tlQty(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlQty, 'tlQty');

  // Set Value
  lTXLineRec.TKTLRec.Qty := CustomSetReal(lTXLineRec.TKTLRec.Qty, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlQtyDel: Double;
begin
  Result := lTXLineRec.TKTLRec.QtyDel;
end;

procedure TTradeEventTransLine.Set_tlQtyDel(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlQtyDel, 'tlQtyDel');

  // Set Value
  lTXLineRec.TKTLRec.QtyDel := CustomSetReal(lTXLineRec.TKTLRec.QtyDel, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlQtyMul: Double;
begin
  Result := lTXLineRec.TKTLRec.QtyMul;
end;

procedure TTradeEventTransLine.Set_tlQtyMul(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlQtyMul, 'tlQtyMul');

  // Set Value
  lTXLineRec.TKTLRec.QtyMul := CustomSetReal(lTXLineRec.TKTLRec.QtyMul, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlQtyPicked: Double;
begin
  Result := lTXLineRec.TKTLRec.QtyPick;
end;

procedure TTradeEventTransLine.Set_tlQtyPicked(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlQtyPicked, 'tlQtyPicked');

  // Set Value
  lTXLineRec.TKTLRec.QtyPick := CustomSetReal(lTXLineRec.TKTLRec.QtyPick, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlQtyPickedWO: Double;
begin
  Result := lTXLineRec.TKTLRec.QtyPWOff;
end;

procedure TTradeEventTransLine.Set_tlQtyPickedWO(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlQtyPickedWO, 'tlQtyPickedWO');

  // Set Value
  lTXLineRec.TKTLRec.QtyPWOff := CustomSetReal(lTXLineRec.TKTLRec.QtyPWOff, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlQtyWOFF: Double;
begin
  Result := lTXLineRec.TKTLRec.QtyWOff;
end;

procedure TTradeEventTransLine.Set_tlQtyWOFF(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlQtyWOFF, 'tlQtyWOFF');

  // Set Value
  lTXLineRec.TKTLRec.QtyWOff := CustomSetReal(lTXLineRec.TKTLRec.QtyWOff, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlSOPABSLineNo: Integer;
begin
  Result := lTXLineRec.TKTLRec.SOPLineNo;
end;

procedure TTradeEventTransLine.Set_tlSOPABSLineNo(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlSOPABSLineNo, 'tlSOPABSLineNo');

  // Set Value
  lTXLineRec.TKTLRec.SOPLineNo := CustomSetInteger(lTXLineRec.TKTLRec.SOPLineNo, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlSOPFolioNum: Integer;
begin
  Result := lTXLineRec.TKTLRec.SOPLink;
end;

procedure TTradeEventTransLine.Set_tlSOPFolioNum(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlSOPFolioNum, 'tlSOPFolioNum');

  // Set Value
  lTXLineRec.TKTLRec.SOPLink := CustomSetInteger(lTXLineRec.TKTLRec.SOPLink, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlSSDCommodCode: WideString;
begin
  Result := lTXLineRec.TKTLRec.SSDCommod;
end;

procedure TTradeEventTransLine.Set_tlSSDCommodCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlSSDCommodCode, 'tlSSDCommodCode');

  // Set Value
  lTXLineRec.TKTLRec.SSDCommod := CustomSetString(lTXLineRec.TKTLRec.SSDCommod, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlSSDCountry: WideString;
begin
  Result := lTXLineRec.TKTLRec.SSDCountry;
end;

procedure TTradeEventTransLine.Set_tlSSDCountry(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlSSDCountry, 'tlSSDCountry');

  // Set Value
  lTXLineRec.TKTLRec.SSDCountry := CustomSetString(lTXLineRec.TKTLRec.SSDCountry, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlSSDSalesUnit: Double;
begin
  Result := lTXLineRec.TKTLRec.SSDSPUnit;
end;

procedure TTradeEventTransLine.Set_tlSSDSalesUnit(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlSSDSalesUnit, 'tlSSDSalesUnit');

  // Set Value
  lTXLineRec.TKTLRec.SSDSPUnit := CustomSetReal(lTXLineRec.TKTLRec.SSDSPUnit, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlSSDUpliftPerc: Double;
begin
  Result := lTXLineRec.TKTLRec.SSDUplift;
end;

procedure TTradeEventTransLine.Set_tlSSDUpliftPerc(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlSSDUpliftPerc, 'tlSSDUpliftPerc');

  // Set Value
  lTXLineRec.TKTLRec.SSDUplift := CustomSetReal(lTXLineRec.TKTLRec.SSDUplift, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlSSDUseLineValues: WordBool;
begin
  Result := lTXLineRec.TKTLRec.SSDUseLine;
end;

procedure TTradeEventTransLine.Set_tlSSDUseLineValues(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlSSDUseLineValues, 'tlSSDUseLineValues');

  // Set Value
  lTXLineRec.TKTLRec.SSDUseLine := CustomSetBoolean(lTXLineRec.TKTLRec.SSDUseLine, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlStockCode: WideString;
begin
  Result := lTXLineRec.TKTLRec.StockCode;
end;

procedure TTradeEventTransLine.Set_tlStockCode(const Value: WideString);
var
  sStockCode : string20;
//  iLineNo, iPos : integer;
  ATXLineRec : TTXLineRec;
  ATXRec : TTXRec;
  rQty : real;
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlStockCode, 'tlStockCode');

  // Update Stock Object
  if (UpperCase(Trim(lTXLineRec.TKTLRec.StockCode)) <> UpperCase(Trim(Value))) then begin
    sStockCode := PadString(psRight,UpperCase(Value),' ',16);
    if DoGetStock(nil, sCurrCompPath, sStockCode, sStockCode, [stkProduct, stkBOM], vmCheckValue, TRUE) then
      begin
        // Set Value
        lTXLineRec.TKTLRec.StockCode := CustomSetString(lTXLineRec.TKTLRec.StockCode
        , Value, FDataChanged);

{        iLineNo := lTXLineRec.TKTLRec.LineNo;
        lTXLineRec.TKStockRec.StockCode := UpperCase(Trim(Value));}

//        ATXLineRec := lTXLineRec^;
//        InitialiseTXLine(ATXLineRec);

//        sStockCode := lTXLineRec.TKStockRec.StockCode;
//        ATXRec := TTradeEventData(oEventData).LTXRec;
//        rQty := lTXLineRec.TKTLRec.Qty;

//        FillTXLineRec(ATXRec, ATXLineRec, sStockCode, rQty, TRUE);

        // Reset list folio number, so we know to explode the bom if neccessary
{        if TTXLineInfo(Selected.Data).TXLineRec.TKTLRec.StockCode <> EditedTXLineRec.TKTLRec.StockCode
        then EditedTXLineRec.iListFolioNo := 0;

        {Delete previous item's lines}
{        DeleteLines(TTradeEventData(oEventData).LListView, iLineNo, TTXLineInfo(Selected.Data).TXLineRec.TKTLRec.StockCode
        <> EditedTXLineRec.TKTLRec.StockCode);

        // Add new lines
        iStockFolio := EditedTXLineRec.TKStockRec.StockFolio;
        PopulateOtherThingsAboutThisLine(TXRec, EditedTXLineRec, (iLineNo + 1) * 2);
        AddTXLine(EditedTXLineRec, iLineNo, rPrevQty);
        EnableDisable;

        {realigns scroll position}
{        if bScroll then Scroll(0, 16);

        {set focus back to appropriate control}
{        bRefocusEdit := bRefocusEdit and TRUE;
        if bRefocusEdit then btnEdit.SetFocus
        else lvLines.SetFocus;

{        FillTXLineRec(TTradeEventData(oEventData).LTXRec, lTXLineRec^, sStockCode
        , lTXLineRec.TKTLRec.Qty, TRUE);

        lTXLineRec.sDesc := lTXLineRec.TKTLRec.Desc[1];}

//        lTXLineRec.TKStockRec := ;
//        lTXLineRec.TKStockLocRec := ;
//        lTXLineRec.TKStockPrice := ;

        {clear serial numbers list}
{        if Assigned(lTXLineRec.SerialNumbers) then begin
          with lTXLineRec^, SerialNumbers do begin
            For iPos := 0 to Count - 1 do Objects[iPos].Free;
            Clear;
          end;{with}
{        end;{if}

        // Recalc line and totals
//        PopulateOtherThingsAboutThisLine(TTradeEventData(oEventData).LTXRec, lTXLineRec^, iLineNo);
//        CalcStockPrice(TTradeEventData(oEventData).LTXRec, lTXLineRec^, TRUE);
//        RecalcTXTotals(TTradeEventData(oEventData).LTXRec, TTradeEventData(oEventData).LListView);
      end
    else begin
      Raise EValidation.Create ('Invalid Stock Code. This stock code does not exist (' + UpperCase(Value) + ')');
    end;{if}
  end;{if}
end;


function TTradeEventTransLine.Get_tlUnitWeight: Double;
begin
  Result := lTXLineRec.TKTLRec.LWeight;
end;

procedure TTradeEventTransLine.Set_tlUnitWeight(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlUnitWeight, 'tlUnitWeight');

  // Set Value
  lTXLineRec.TKTLRec.LWeight := CustomSetReal(lTXLineRec.TKTLRec.LWeight, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlUserField1: WideString;
begin
  Result := lTXLineRec.TKTLRec.LineUser1;
end;

procedure TTradeEventTransLine.Set_tlUserField1(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlUserField1, 'tlUserField1');

  // Set Value
  lTXLineRec.TKTLRec.LineUser1 := CustomSetString(lTXLineRec.TKTLRec.LineUser1, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlUserField2: WideString;
begin
  Result := lTXLineRec.TKTLRec.LineUser2;
end;

procedure TTradeEventTransLine.Set_tlUserField2(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlUserField2, 'tlUserField2');

  // Set Value
  lTXLineRec.TKTLRec.LineUser2 := CustomSetString(lTXLineRec.TKTLRec.LineUser2, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlUserField3: WideString;
begin
  Result := lTXLineRec.TKTLRec.LineUser3;
end;

procedure TTradeEventTransLine.Set_tlUserField3(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlUserField3, 'tlUserField3');

  // Set Value
  lTXLineRec.TKTLRec.LineUser3 := CustomSetString(lTXLineRec.TKTLRec.LineUser3, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlUserField4: WideString;
begin
  Result := lTXLineRec.TKTLRec.LineUser4;
end;

procedure TTradeEventTransLine.Set_tlUserField4(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlUserField4, 'tlUserField4');

  // Set Value
  lTXLineRec.TKTLRec.LineUser4 := CustomSetString(lTXLineRec.TKTLRec.LineUser4, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlVATCode: WideString;
begin
  Result := lTXLineRec.TKTLRec.VATCode;
end;

procedure TTradeEventTransLine.Set_tlVATCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlVATCode, 'tlVATCode');

  // Set Value on TX Line Record
  lTXLineRec.TKTLRec.VATCode := ExtractChar(CustomSetString(lTXLineRec.TKTLRec.VATCode
  , Value, FDataChanged),#255);

  // Set Value on Stock Record
  lTXLineRec.TKStockRec.VATCode:= ExtractChar(CustomSetString(lTXLineRec.TKStockRec.VATCode
  , Value, FDataChanged),#255);

  lTXLineRec.bVATInclusive := lTXLineRec.TKTLRec.VATCode = 'I';
end;


function TTradeEventTransLine.Get_tlStock: ITradeEventStock;
begin
  Result := FStockI;
end;


function TTradeEventTransLine.Get_tlVATAmount: Double;
begin
  Result := Round_Up(lTXLineRec.TKTLRec.VAT, TKSysRec.PriceDP);
end;

procedure TTradeEventTransLine.Set_tlVATAmount(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlVATAmount, 'tlVATAmount');

  // Set Value
  lTXLineRec.TKTLRec.VAT := CustomSetReal(lTXLineRec.TKTLRec.VAT, Value, FDataChanged);
end;


function TTradeEventTransLine.Get_tlSerialNumbers: ITradeEventSerialNumbers;
begin
  Result := FSerialsI;
end;

procedure TTradeEventTransLine.Cancel;
begin
  // Check that it is valid to call this function at this time
  AuthoriseFunction(fIdxCancel, 'Cancel');

  // Reset Current Line
  InitialiseTXLine(lTXLineRec^);
  TTradeEventTransLines(oLines).bGetCurrentLine := TRUE;
end;

procedure TTradeEventTransLine.Save;
var
  oLine : pTransLineType;
  NewItem : TListItem;
begin
  // Check that it is valid to call this function at this time
  AuthoriseFunction(fIdxSave, 'Save');

  // Add New Line To List
  New (oLine);
  With oLine^ Do Begin
    // Allocate unique Id number
    IdNo := TTradeEventTransLines(oLines).IdControl.OpenBit;
    TTradeEventTransLines(oLines).IdControl.Bits[IdNo] := True;
    // Create lines object
    TLO  := TTradeEventTransLine.Create;
    TLI  := oLine.TLO;
    TLO.Assign(oEventData, oLines, LTXLineRec, TTradeEventData(oEventData).LListView.Items.Count);
  End; { With oLine }

  // Add into Lines List
  TTradeEventTransLines(oLines).Lines.Add(oLine);

  // Add into Local Copy of the listview
  with TTradeEventData(oEventData).LListView do begin
    NewItem := Items.Add;
    NewItem.Data := TTXLineInfo.create(LTXLineRec^);
  end;{with}

  // Recalculate header
  RecalcTXTotals(TTradeEventData(oEventData).LTXRec, TTradeEventData(oEventData).LListView);

  // Reset Current Line
  InitialiseTXLine(LTXLineRec^);
  TTradeEventTransLines(oLines).bGetCurrentLine := TRUE;
end;

procedure TTradeEventTransLine.RecalcLineAndHeader;
begin
  TTXLineInfo(TTradeEventData(oEventData).LListView.Items[iLineNo].Data).RecalcLine(TTradeEventData(oEventData).LTXRec
  , lTXLineRec.TKTLRec.DiscountChr = '£');
  PopulateOtherThingsAboutThisLine(TTradeEventData(oEventData).LTXRec, LTXLineRec^, iLineNo);
  RecalcTXTotals(TTradeEventData(oEventData).LTXRec, TTradeEventData(oEventData).LListView);
end;


function TTradeEventTransLine.Get_tlMultiBuyDiscount: Double;
begin
  Result := lTXLineRec.TKTLRec.tlMultiBuyDiscount;
end;

procedure TTradeEventTransLine.Set_tlMultiBuyDiscount(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdx_NEVER_AUTHORISE, 'tlMultiBuyDiscount');

  // Set Value
  lTXLineRec.TKTLRec.tlMultiBuyDiscount := Value;
end;


function TTradeEventTransLine.Get_tlMultiBuyDiscountFlag: WideString;
begin
  Result := lTXLineRec.TKTLRec.tlMultiBuyDiscountChr;
end;

procedure TTradeEventTransLine.Set_tlMultiBuyDiscountFlag(
  const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdx_NEVER_AUTHORISE, 'tlMultiBuyDiscountFlag');

  // Set Value
  lTXLineRec.TKTLRec.tlMultiBuyDiscountChr := ExtractChar(CustomSetString(lTXLineRec.TKTLRec.tlMultiBuyDiscountChr
  , Value, FDataChanged), ' ');
end;


function TTradeEventTransLine.Get_tlTransValueDiscount: Double;
begin
  Result := lTXLineRec.TKTLRec.tlTransValueDiscount;
end;

procedure TTradeEventTransLine.Set_tlTransValueDiscount(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdx_NEVER_AUTHORISE, 'tlTransValueDiscount');

  // Set Value
  lTXLineRec.TKTLRec.tlTransValueDiscount := Value;
end;


function TTradeEventTransLine.Get_tlTransValueDiscountFlag: WideString;
begin
  Result := lTXLineRec.TKTLRec.tlTransValueDiscountChr;
end;

procedure TTradeEventTransLine.Set_tlTransValueDiscountFlag(
  const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdx_NEVER_AUTHORISE, 'tlTransValueDiscountFlag');

  // Set Value
  lTXLineRec.TKTLRec.tlTransValueDiscountChr := ExtractChar(CustomSetString(lTXLineRec.TKTLRec.tlTransValueDiscountChr
  , Value, FDataChanged), ' ');
end;


function TTradeEventTransLine.Get_tlTransValueDiscountType: Smallint;
begin
  Result := lTXLineRec.TKTLRec.tlTransValueDiscountType;
end;

procedure TTradeEventTransLine.Set_tlTransValueDiscountType(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdx_NEVER_AUTHORISE, 'tlTransValueDiscountType');

  // Set Value
  lTXLineRec.TKTLRec.tlTransValueDiscountType := Value;
end;

end.
