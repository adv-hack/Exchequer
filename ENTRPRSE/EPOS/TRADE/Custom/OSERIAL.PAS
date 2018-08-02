unit oSerial;
// Implementation of the "snUsed / snAvailable" COM Object

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, SysUtils, EPOSProc
  , CustomP, oStock, DLLInc, SerialPrc, StrUtil;

type
  TSerialNoPropertyIndex = (pIdxNeverAuthorise, pIdxtlQty, pIdxtlStockCode, pIdxsnBatchNo
  , pIdxsnBatchQuantity, pIdxsnBatchQuantitySold, pIdxsnCompanyRate, pIdxsnCostPrice
  , pIdxsnCostPriceCurrency, pIdxsnDailyRate, pIdxsnInDate, pIdxsnInDocLine, pIdxsnInDocRef
  , pIdxsnInLocation, pIdxsnInOrderRef, pIdxsnInOrderLine, pIdxsnOutDate, pIdxsnOutDocLine
  , pIdxsnOutDocRef, pIdxsnOutOrderLine, pIdxsnOutOrderRef, pIdxsnSalesPrice
  , pIdxsnSalesPriceCurrency, pIdxsnSerialNo, pIdxsnSold, pIdxsnUseByDate);

  TSerialNoFunctionIndex = (fIdxUnknownfunction);

  TTradeEventSerialNo = class(TAutoIntfObject, ITradeEventSerialNo, ITradeEventSerialNo2)
  private
    // Records changes to properties of this object
    FDataChanged : Boolean;

    // Event WindowId/HandlerId
    FWindowId  : TTradeWindowIds;
    FHandlerId : Integer;

    lSerialInfo : TSerialInfo;
//    iUsedInThisLine : Integer;
//    iUsedInThisTX : Integer;
    rUsedInThisLine : real;
    rUsedInThisTX : real;
    bUsedList : boolean;

    function SNRound(rNo : double): double;

  protected
    function Get_snSerialNo: WideString; safecall;
    procedure Set_snSerialNo(const Value: WideString); safecall;
    function Get_snBatchNo: WideString; safecall;
    procedure Set_snBatchNo(const Value: WideString); safecall;
    function Get_snType: TTradeSerialBatchType; safecall;
    procedure Set_snSold(Value: WordBool); safecall;
    function Get_snSold: WordBool; safecall;
    function Get_snUseByDate: WideString; safecall;
    procedure Set_snUseByDate(const Value: WideString); safecall;
    procedure Set_snInDate(const Value: WideString); safecall;
    function Get_snInDate: WideString; safecall;
    function Get_snInOrderRef: WideString; safecall;
    procedure Set_snInOrderRef(const Value: WideString); safecall;
    function Get_snInOrderLine: Integer; safecall;
    procedure Set_snInOrderLine(Value: Integer); safecall;
    function Get_snInDocRef: WideString; safecall;
    procedure Set_snInDocRef(const Value: WideString); safecall;
    function Get_snInDocLine: Integer; safecall;
    procedure Set_snInDocLine(Value: Integer); safecall;
    function Get_snInLocation: WideString; safecall;
    procedure Set_snInLocation(const Value: WideString); safecall;
    procedure Set_snOutDate(const Value: WideString); safecall;
    function Get_snOutDate: WideString; safecall;
    function Get_snOutOrderRef: WideString; safecall;
    procedure Set_snOutOrderRef(const Value: WideString); safecall;
    function Get_snOutOrderLine: Integer; safecall;
    procedure Set_snOutOrderLine(Value: Integer); safecall;
    function Get_snOutDocRef: WideString; safecall;
    procedure Set_snOutDocRef(const Value: WideString); safecall;
    function Get_snOutDocLine: Integer; safecall;
    procedure Set_snOutDocLine(Value: Integer); safecall;
    function Get_snOutLocation: WideString; safecall;
    procedure Set_snOutLocation(const Value: WideString); safecall;
    function Get_snCostPrice: Double; safecall;
    procedure Set_snCostPrice(Value: Double); safecall;
    function Get_snCostPriceCurrency: Smallint; safecall;
    procedure Set_snCostPriceCurrency(Value: Smallint); safecall;
    function Get_snSalesPrice: Double; safecall;
    procedure Set_snSalesPrice(Value: Double); safecall;
    function Get_snSalesPriceCurrency: Smallint; safecall;
    procedure Set_snSalesPriceCurrency(Value: Smallint); safecall;
    function Get_snBatchQuantity: Double; safecall;
    procedure Set_snBatchQuantity(Value: Double); safecall;
    function Get_snBatchQuantitySold: Double; safecall;
    procedure Set_snBatchQuantitySold(Value: Double); safecall;
    function Get_snDailyRate: Double; safecall;
    procedure Set_snDailyRate(Value: Double); safecall;
    function Get_snCompanyRate: Double; safecall;
    procedure Set_snCompanyRate(Value: Double); safecall;
    function Get_snBatchQtySelected: Integer; safecall;
    function Get_snBatchQtyAvailable: Integer; safecall;
    function Get_snBatchQtySelectedFloat: Double; safecall;
    function Get_snBatchQtyAvailableFloat: Double; safecall;

    // Local Methods
    Procedure AuthoriseProperty (Const PropertyIdx : TSerialNoPropertyIndex; const PropName : ShortString);
    Procedure AuthoriseFunction (Const FunctionIdx : TSerialNoFunctionIndex; const FuncName : ShortString);
  public
    // DataChanged flag indicates whether Plug-Ins made any changes to
    // properties of this object OR any sub-objects
    Property DataChanged : Boolean Read FDataChanged;

    Constructor Create;
    Destructor Destroy; override;

    Procedure Assign(EventData : TObject;
                      Const SerialInfo : TSerialInfo;
                      Const UsedInThisLine : real;
                      Const UsedInThisTX : real;
                      Const UsedList : boolean);
  End; { TTradeEventTransaction }

implementation

uses ComServ;

//---------------------------------------------------------------------------

Constructor TTradeEventSerialNo.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeEventTransaction);

  lSerialInfo := TSerialInfo.Create;

  FDataChanged := False;
End; { Create }

//---------------------------------------------------------------------------

Destructor TTradeEventSerialNo.Destroy;
Begin { Destroy }
  lSerialInfo.Free;

  Inherited;
End; { Destroy }

//---------------------------------------------------------------------------

Procedure TTradeEventSerialNo.Assign (EventData : TObject;
                                         Const SerialInfo : TSerialInfo;
                                         Const UsedInThisLine : real;
                                         Const UsedInThisTX : real;
                                         Const UsedList : boolean);

begin { Assign }
  // Reset Datachanged flag for new event
  FDataChanged := False;

  // make local copy of data required for this object
  lSerialInfo.CopyFrom(SerialInfo);
  rUsedInThisLine := UsedInThisLine;
  rUsedInThisTX := UsedInThisTX;
  bUsedList := UsedList;

end; { Assign }

//---------------------------------------------------------------------------

// Returns True if the specified property can be written to by the Plug-In during the current event
Procedure TTradeEventSerialNo.AuthoriseProperty (Const PropertyIdx : TSerialNoPropertyIndex; const PropName : ShortString);
Var
  Authorised : Boolean;
Begin { AuthoriseProperty }
  // Check for specific enablement of fields
  Authorised := FALSE;

{  case PropertyIdx of
  end; { Case }

  If (Not Authorised) Then begin
    // Raise exception to notify the user that the Plug-In has been naughty
    Raise ERightsError.Create (Format('Customisation Error in ITradeEventSerialNo for Event %d.%d - The property %s is Read-Only'
    , [FWindowId, FHandlerId, QuotedStr(PropName)]));
  end;{if}
End; { AuthoriseProperty }

//---------------------------------------------------------------------------

// Returns True if the specified function/procedure can be called by the Plug-In during the current event
Procedure TTradeEventSerialNo.AuthoriseFunction (Const FunctionIdx : TSerialNoFunctionIndex; const FuncName : ShortString);
begin

  //
  // This section needs to be coded once some functions are added in
  //
  Raise Exception.Create ('TTradeEventSerialNo.AuthoriseFunction Not Implemented - Please notify your technical support');

  { TODO -cDO : TTradeEventSerialNo.AuthoriseFunction Not Implemented }

end;


//---------------------------------------------------------------------------


function TTradeEventSerialNo.Get_snBatchNo: WideString;
begin
  Result := lSerialInfo.TKSerialRec.BatchNo;
end;

procedure TTradeEventSerialNo.Set_snBatchNo(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnBatchNo, 'snBatchNo');
  lSerialInfo.TKSerialRec.BatchNo := CustomSetString(lSerialInfo.TKSerialRec.BatchNo, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snBatchQuantity: Double;
begin
  Result := SNRound(lSerialInfo.TKSerialRec.BuyQty);
end;

procedure TTradeEventSerialNo.Set_snBatchQuantity(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnBatchQuantity, 'snBatchQuantity');
  lSerialInfo.TKSerialRec.BuyQty := CustomSetReal(lSerialInfo.TKSerialRec.BuyQty, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snBatchQuantitySold: Double;
begin
  Result := SNRound(lSerialInfo.TKSerialRec.QtyUsed);
end;

procedure TTradeEventSerialNo.Set_snBatchQuantitySold(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnBatchQuantitySold, 'snBatchQuantitySold');
  lSerialInfo.TKSerialRec.QtyUsed := CustomSetReal(lSerialInfo.TKSerialRec.QtyUsed, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snCompanyRate: Double;
begin
  Result := lSerialInfo.TKSerialRec.CoRate;
end;

procedure TTradeEventSerialNo.Set_snCompanyRate(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnCompanyRate, 'snCompanyRate');
  lSerialInfo.TKSerialRec.QtyUsed := CustomSetReal(lSerialInfo.TKSerialRec.QtyUsed, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snCostPrice: Double;
begin
  Result := lSerialInfo.TKSerialRec.SerCost;
end;

procedure TTradeEventSerialNo.Set_snCostPrice(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnCostPrice, 'snCostPrice');
  lSerialInfo.TKSerialRec.SerCost := CustomSetReal(lSerialInfo.TKSerialRec.SerCost, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snCostPriceCurrency: Smallint;
begin
  Result := lSerialInfo.TKSerialRec.CurCost;
end;

procedure TTradeEventSerialNo.Set_snCostPriceCurrency(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnCostPriceCurrency, 'snCostPriceCurrency');
  lSerialInfo.TKSerialRec.CurCost := CustomSetInteger(lSerialInfo.TKSerialRec.CurCost, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snDailyRate: Double;
begin
  Result := lSerialInfo.TKSerialRec.DailyRate;
end;

procedure TTradeEventSerialNo.Set_snDailyRate(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnDailyRate, 'snDailyRate');
  lSerialInfo.TKSerialRec.DailyRate := CustomSetReal(lSerialInfo.TKSerialRec.DailyRate, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snInDate: WideString;
begin
  Result := lSerialInfo.TKSerialRec.DateIn;
end;

procedure TTradeEventSerialNo.Set_snInDate(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnInDate, 'snInDate');
  lSerialInfo.TKSerialRec.DateIn := CustomSetString(lSerialInfo.TKSerialRec.DateIn, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snInDocLine: Integer;
begin
  Result := lSerialInfo.TKSerialRec.BuyABSLine;
end;

procedure TTradeEventSerialNo.Set_snInDocLine(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnInDocLine, 'snInDocLine');
  lSerialInfo.TKSerialRec.BuyABSLine := CustomSetInteger(lSerialInfo.TKSerialRec.BuyABSLine, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snInDocRef: WideString;
begin
  Result := lSerialInfo.TKSerialRec.InDoc;
end;

procedure TTradeEventSerialNo.Set_snInDocRef(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnInDocRef, 'snInDocRef');
  lSerialInfo.TKSerialRec.InDoc := CustomSetString(lSerialInfo.TKSerialRec.InDoc, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snInLocation: WideString;
begin
  Result := lSerialInfo.TKSerialRec.InMLoc;
end;

procedure TTradeEventSerialNo.Set_snInLocation(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnInLocation, 'snInLocation');
  lSerialInfo.TKSerialRec.InMLoc := CustomSetString(lSerialInfo.TKSerialRec.InMLoc, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snInOrderLine: Integer;
begin
  Result := lSerialInfo.TKSerialRec.InOrdLine;
end;

procedure TTradeEventSerialNo.Set_snInOrderLine(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnInOrderLine, 'snInOrderLine');
  lSerialInfo.TKSerialRec.InOrdLine := CustomSetInteger(lSerialInfo.TKSerialRec.InOrdLine, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snInOrderRef: WideString;
begin
  Result := lSerialInfo.TKSerialRec.InOrdDoc;
end;

procedure TTradeEventSerialNo.Set_snInOrderRef(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnInOrderRef, 'snInOrderRef');
  lSerialInfo.TKSerialRec.InOrdDoc := CustomSetString(lSerialInfo.TKSerialRec.InOrdDoc, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snOutDate: WideString;
begin
  Result := lSerialInfo.TKSerialRec.DateOut;
end;

procedure TTradeEventSerialNo.Set_snOutDate(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnOutDate, 'snOutDate');
  lSerialInfo.TKSerialRec.DateOut := CustomSetString(lSerialInfo.TKSerialRec.DateOut, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snOutDocLine: Integer;
begin
  Result := lSerialInfo.TKSerialRec.SoldABSLine;
end;

procedure TTradeEventSerialNo.Set_snOutDocLine(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnOutDocLine, 'snOutDocLine');
  lSerialInfo.TKSerialRec.SoldABSLine := CustomSetInteger(lSerialInfo.TKSerialRec.SoldABSLine, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snOutDocRef: WideString;
begin
  Result := lSerialInfo.TKSerialRec.OutDoc;
end;

procedure TTradeEventSerialNo.Set_snOutDocRef(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnOutDocRef, 'snOutDocRef');
  lSerialInfo.TKSerialRec.OutDoc := CustomSetString(lSerialInfo.TKSerialRec.OutDoc, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snOutLocation: WideString;
begin
  Result := lSerialInfo.TKSerialRec.OutMLoc;
end;

procedure TTradeEventSerialNo.Set_snOutLocation(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxNeverAuthorise, 'snOutLocation');
end;


function TTradeEventSerialNo.Get_snOutOrderLine: Integer;
begin
  Result := lSerialInfo.TKSerialRec.OutOrdLine;
end;

procedure TTradeEventSerialNo.Set_snOutOrderLine(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnOutOrderLine, 'snOutOrderLine');
  lSerialInfo.TKSerialRec.OutOrdLine := CustomSetInteger(lSerialInfo.TKSerialRec.OutOrdLine, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snOutOrderRef: WideString;
begin
  Result := lSerialInfo.TKSerialRec.OutOrdDoc;
end;

procedure TTradeEventSerialNo.Set_snOutOrderRef(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnOutOrderRef, 'snOutOrderRef');
  lSerialInfo.TKSerialRec.OutOrdDoc := CustomSetString(lSerialInfo.TKSerialRec.OutOrdDoc, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snSalesPrice: Double;
begin
  Result := lSerialInfo.TKSerialRec.SerSell;
end;

procedure TTradeEventSerialNo.Set_snSalesPrice(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnSalesPrice, 'snSalesPrice');
  lSerialInfo.TKSerialRec.SerSell := CustomSetReal(lSerialInfo.TKSerialRec.SerSell, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snSalesPriceCurrency: Smallint;
begin
  Result := lSerialInfo.TKSerialRec.CurSell;
end;

procedure TTradeEventSerialNo.Set_snSalesPriceCurrency(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnSalesPriceCurrency, 'snSalesPriceCurrency');
  lSerialInfo.TKSerialRec.CurSell := CustomSetInteger(lSerialInfo.TKSerialRec.CurSell, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snSerialNo: WideString;
begin
  Result := lSerialInfo.TKSerialRec.SerialNo;
end;

procedure TTradeEventSerialNo.Set_snSerialNo(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnSerialNo, 'snSerialNo');
  lSerialInfo.TKSerialRec.SerialNo := CustomSetString(lSerialInfo.TKSerialRec.SerialNo, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snSold: WordBool;
begin
  Result := lSerialInfo.TKSerialRec.Sold;
end;

procedure TTradeEventSerialNo.Set_snSold(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnSold, 'snSold');
  lSerialInfo.TKSerialRec.Sold := CustomSetBoolean(lSerialInfo.TKSerialRec.Sold, Value, FDataChanged);
end;


function TTradeEventSerialNo.Get_snType: TTradeSerialBatchType;
begin
  If lSerialInfo.TKSerialRec.BatchRec Then Begin
    // Batch or Batch Child
    If lSerialInfo.TKSerialRec.BatchChild Then
      Result := snTypeBatchSale
    Else
      Result := snTypeBatch;
  End
  Else
    Result := snTypeSerial;
end;


function TTradeEventSerialNo.Get_snUseByDate: WideString;
begin
  Result := lSerialInfo.TKSerialRec.DateUseX;
end;

procedure TTradeEventSerialNo.Set_snUseByDate(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxsnUseByDate, 'snUseByDate');
  lSerialInfo.TKSerialRec.DateUseX := CustomSetString(lSerialInfo.TKSerialRec.DateUseX, Value, FDataChanged);
end;

function TTradeEventSerialNo.Get_snBatchQtyAvailable: Integer;
begin
  if bUsedList then Raise ERightsError.Create(Format('Customisation Error in ITradeEventSerialNo for Event %d.%d'
  + ' - The property snBatchQtyAvailable is not available for serial numbers in the Used List', [FWindowId, FHandlerId]))
  else Result := Round(lSerialInfo.TKSerialRec.BuyQty - lSerialInfo.TKSerialRec.QtyUsed
  - rUsedInThisTX);
end;

function TTradeEventSerialNo.Get_snBatchQtySelected: Integer;
begin
  Result := Round(rUsedInThisLine);
end;

function TTradeEventSerialNo.Get_snBatchQtyAvailableFloat: double;
begin
  if bUsedList then Raise ERightsError.Create(Format('Customisation Error in ITradeEventSerialNo for Event %d.%d'
  + ' - The property snBatchQtyAvailableFloat is not available for serial numbers in the Used List', [FWindowId, FHandlerId]))
  else Result := SNRound(lSerialInfo.TKSerialRec.BuyQty - lSerialInfo.TKSerialRec.QtyUsed
  - rUsedInThisTX);
end;

function TTradeEventSerialNo.Get_snBatchQtySelectedFloat: double;
begin
  Result := SNRound(rUsedInThisLine);
end;

function TTradeEventSerialNo.SNRound(rNo : double): double;
begin
  Result := StrToFloatDef(MoneyToStr(rNo, TKSysRec.QuantityDP),0);
end;



end.

