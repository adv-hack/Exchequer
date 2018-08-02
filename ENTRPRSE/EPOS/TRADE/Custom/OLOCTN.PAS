// Implementation of the "tlLocation" COM Object
unit oLoctn;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComCtrls, ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, SysUtils, TXRecs
  , VarConst, CustomP, DLLInc, oAddr, GlobVar, oStock2;

type

  TLocFunctionIndex = (fIdxUnknownfunction);
  TLocPropertyIndex = (pIdxNeverAuthorise, pIdxloArea, pIdxloBalSheetGL, pIdxloBelowMinLevel
  , pIdxloBinLocation, pIdxloCode, pIdxloContact, pIdxloCostCentre, pIdxloCostOfSalesGL
  , pIdxloCostPrice, pIdxloCostPriceCur, pIdxloCurrency, pIdxloDepartment, pIdxloEmailAddr
  , pIdxloFax, pIdxloModem, pIdxloName, pIdxloOverrideBinLocation, pIdxloOverrideCCDept
  , pIdxloOverrideGLCodes, pIdxloOverrideSalesPrice, pIdxloOverrideSupplier, pIdxloPandLGL
  , pIdxloPhone, pIdxloQtyMax, pIdxloQtyMin, pIdxloQtyStockTake, pIdxloReorderCostCentre
  , pIdxloReorderCur, pIdxloReorderDate, pIdxloReorderDepartment, pIdxloReorderPrice
  , pIdxloReorderQty, pIdxloRep, pIdxloSalesGL, pIdxloSupplier, pIdxloSuppTemp, pIdxloTagged
  , pIdxloWIPGL);

  TTradeEventLocation = class(TAutoIntfObject, ITradeEventLocation)
  private
    // Records changes to properties of this object
    FDataChanged : Boolean;

    FLocAddressO : TTradeAddress;
    FLocAddressI : ITradeAddress;

    // Sales Bands sub-objects
    FSalesBandO : Array[1..8] Of TTradeStockSalesBand;
    FSalesBandI : Array[1..8] Of ITradeStockSalesBand;

    oEventData, oLineData : TObject;
//    LTKStockLocRec : TBatchSLRec;
    lTXLineRec : pTXLineRec;

    procedure InitObjects;
    Function GetDataChanged : Boolean;

  protected
    function Get_loCode: WideString; safecall;
    procedure Set_loCode(const Value: WideString); safecall;
    function Get_loName: WideString; safecall;
    procedure Set_loName(const Value: WideString); safecall;
    function Get_loAddress: ITradeAddress; safecall;
    function Get_loPhone: WideString; safecall;
    procedure Set_loPhone(const Value: WideString); safecall;
    function Get_loFax: WideString; safecall;
    procedure Set_loFax(const Value: WideString); safecall;
    function Get_loEmailAddr: WideString; safecall;
    procedure Set_loEmailAddr(const Value: WideString); safecall;
    function Get_loModem: WideString; safecall;
    procedure Set_loModem(const Value: WideString); safecall;
    function Get_loContact: WideString; safecall;
    procedure Set_loContact(const Value: WideString); safecall;
    function Get_loCurrency: Smallint; safecall;
    procedure Set_loCurrency(Value: Smallint); safecall;
    function Get_loArea: WideString; safecall;
    procedure Set_loArea(const Value: WideString); safecall;
    function Get_loRep: WideString; safecall;
    procedure Set_loRep(const Value: WideString); safecall;
    function Get_loTagged: WordBool; safecall;
    procedure Set_loTagged(Value: WordBool); safecall;
    function Get_loCostCentre: WideString; safecall;
    procedure Set_loCostCentre(const Value: WideString); safecall;
    function Get_loDepartment: WideString; safecall;
    procedure Set_loDepartment(const Value: WideString); safecall;
    function Get_loOverrideSalesPrice: WordBool; safecall;
    procedure Set_loOverrideSalesPrice(Value: WordBool); safecall;
    function Get_loOverrideGLCodes: WordBool; safecall;
    procedure Set_loOverrideGLCodes(Value: WordBool); safecall;
    function Get_loOverrideCCDept: WordBool; safecall;
    procedure Set_loOverrideCCDept(Value: WordBool); safecall;
    function Get_loOverrideSupplier: WordBool; safecall;
    procedure Set_loOverrideSupplier(Value: WordBool); safecall;
    function Get_loOverrideBinLocation: WordBool; safecall;
    procedure Set_loOverrideBinLocation(Value: WordBool); safecall;
    function Get_loSalesGL: Integer; safecall;
    procedure Set_loSalesGL(Value: Integer); safecall;
    function Get_loCostOfSalesGL: Integer; safecall;
    procedure Set_loCostOfSalesGL(Value: Integer); safecall;
    function Get_loPandLGL: Integer; safecall;
    procedure Set_loPandLGL(Value: Integer); safecall;
    function Get_loBalSheetGL: Integer; safecall;
    procedure Set_loBalSheetGL(Value: Integer); safecall;
    function Get_loWIPGL: Integer; safecall;
    procedure Set_loWIPGL(Value: Integer); safecall;
    function Get_loQtyInStock: Double; safecall;
    function Get_loQtyOnOrder: Double; safecall;
    function Get_loQtyAllocated: Double; safecall;
    function Get_loQtyPicked: Double; safecall;
    function Get_loQtyMin: Double; safecall;
    procedure Set_loQtyMin(Value: Double); safecall;
    function Get_loQtyMax: Double; safecall;
    procedure Set_loQtyMax(Value: Double); safecall;
    function Get_loQtyFreeze: Double; safecall;
    function Get_loReorderQty: Double; safecall;
    procedure Set_loReorderQty(Value: Double); safecall;
    function Get_loReorderCur: Smallint; safecall;
    procedure Set_loReorderCur(Value: Smallint); safecall;
    function Get_loReorderPrice: Double; safecall;
    procedure Set_loReorderPrice(Value: Double); safecall;
    function Get_loReorderDate: WideString; safecall;
    procedure Set_loReorderDate(const Value: WideString); safecall;
    function Get_loReorderCostCentre: WideString; safecall;
    procedure Set_loReorderCostCentre(const Value: WideString); safecall;
    function Get_loReorderDepartment: WideString; safecall;
    procedure Set_loReorderDepartment(const Value: WideString); safecall;
    function Get_loBinLocation: WideString; safecall;
    procedure Set_loBinLocation(const Value: WideString); safecall;
    function Get_loCostPriceCur: Integer; safecall;
    procedure Set_loCostPriceCur(Value: Integer); safecall;
    function Get_loCostPrice: Double; safecall;
    procedure Set_loCostPrice(Value: Double); safecall;
    function Get_loBelowMinLevel: WordBool; safecall;
    procedure Set_loBelowMinLevel(Value: WordBool); safecall;
    function Get_loSuppTemp: WideString; safecall;
    procedure Set_loSuppTemp(const Value: WideString); safecall;
    function Get_loSupplier: WideString; safecall;
    procedure Set_loSupplier(const Value: WideString); safecall;
    function Get_loLastUsed: WideString; safecall;
    function Get_loQtyPosted: Double; safecall;
    function Get_loQtyStockTake: Double; safecall;
    procedure Set_loQtyStockTake(Value: Double); safecall;
    function Get_loTimeChange: WideString; safecall;

    Function  GetSalesBandPrice (Const BandNo : Byte) : Double;
    Procedure SetSalesBandPrice (Const BandNo : Byte; Const Value : Double; var Changed : boolean);
    Function  GetSalesBandCcy (Const BandNo : Byte) : Integer;
    Procedure SetSalesBandCcy (Const BandNo : Byte; Const Value : Integer; var Changed : boolean);

    function Get_loSalesBands(const Band: WideString): ITradeStockSalesBand; safecall;
    function Get_loQtyFree: Double; safecall;

    // Local Methods
    Procedure AuthoriseProperty (Const PropertyIdx : TLocPropertyIndex; const PropName : ShortString);
    Procedure AuthoriseFunction (Const FunctionIdx : TLocFunctionIndex; const FuncName : ShortString);
  public
    // DataChanged flag indicates whether Plug-Ins made any changes to
    // properties of this object OR any sub-objects
    Property DataChanged : Boolean Read GetDataChanged;

    Constructor Create;
    Destructor Destroy; override;

    Procedure Assign(const EventData, LineData : TObject);

  End; { TTradeEventLocation }

implementation

uses
  oEvent, oVersion, ComServ, oLine;

//---------------------------------------------------------------------------

Constructor TTradeEventLocation.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeEventTransaction);

  InitObjects;

  FLocAddressO := TTradeAddress.Create;
  FLocAddressI := FLocAddressO;

  FDataChanged := False;
End; { Create }

//---------------------------------------------------------------------------

Destructor TTradeEventLocation.Destroy;
Begin { Destroy }
  InitObjects;
  Inherited;
End; { Destroy }

procedure TTradeEventLocation.InitObjects;
Var
  I : Byte;
Begin { Destroy }

  For I := Low(FSalesBandO) To High(FSalesBandO) Do Begin
    FSalesBandO[I] := NIL;
    FSalesBandI[I] := NIL;
  End; { For I }

  FLocAddressO := nil;
  FLocAddressI := nil;

End; { Destroy }

//---------------------------------------------------------------------------

Procedure TTradeEventLocation.Assign (const EventData, LineData : TObject);
begin { Assign }
  // Reset Datachanged flag for new event
  FDataChanged := False;
  oEventData := EventData;
  oLineData := LineData;

  lTXLineRec := TTradeEventTransLine(oLineData).LTXLineRec;

  // Assign sub-objects
  FLocAddressO.Assign (oEventData, waEventLocation);

end; { Assign }

//---------------------------------------------------------------------------

Procedure TTradeEventLocation.AuthoriseProperty (Const PropertyIdx : TLocPropertyIndex; const PropName : ShortString);
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
      raise ERightsError.Create (Format('Customisation Error in ITradeEventLocation for Event %d.%d - The property %s is Read-Only'
      , [FWindowId, FHandlerId, QuotedStr(PropName)]));
    end;{if}
  end;{with}

End;{AuthoriseProperty}

//---------------------------------------------------------------------------

// Returns True if the specified function/procedure can be called by the Plug-In during the current event
Procedure TTradeEventLocation.AuthoriseFunction (Const FunctionIdx : TLocFunctionIndex; const FuncName : ShortString);
begin
  //
  // This section needs to be coded once some functions are added in
  //
  Raise Exception.Create ('TTradeEventLocation.AuthoriseFunction Not Implemented - Please notify your technical support');
  { TODO -cDO : TTradeEventLocation.AuthoriseFunction Not Implemented }
end;

// Returns TRUE if any properties within the eventdata have been changed
Function TTradeEventLocation.GetDataChanged : Boolean;

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

Begin { GetDataChanged }
  Result := FDataChanged or FLocAddressO.DataChanged or AnySalesBandDataChanged;
End; { GetDataChanged }


function TTradeEventLocation.Get_loAddress: ITradeAddress;
begin
  Result := FLocAddressI;
end;

function TTradeEventLocation.Get_loArea: WideString;
begin
  Result := TTradeEventData(oEventData).LTKLocationRec.loArea;
end;

procedure TTradeEventLocation.Set_loArea(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloArea, 'loArea');
  TTradeEventData(oEventData).LTKLocationRec.loArea := CustomSetString(TTradeEventData(oEventData).LTKLocationRec.loArea, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loBalSheetGL: Integer;
begin
  Result := lTXLineRec.TKStockLocRec.lsDefNom[4];
end;

procedure TTradeEventLocation.Set_loBalSheetGL(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloBalSheetGL, 'loBalSheetGL');
  lTXLineRec.TKStockLocRec.lsDefNom[4] := CustomSetInteger(lTXLineRec.TKStockLocRec.lsDefNom[4], Value, FDataChanged);
end;


function TTradeEventLocation.Get_loBelowMinLevel: WordBool;
begin
  Result := lTXLineRec.TKStockLocRec.lsMinFlg;
end;

procedure TTradeEventLocation.Set_loBelowMinLevel(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloBelowMinLevel, 'loBelowMinLevel');
  lTXLineRec.TKStockLocRec.lsMinFlg := CustomSetBoolean(lTXLineRec.TKStockLocRec.lsMinFlg, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loBinLocation: WideString;
begin
  Result := lTXLineRec.TKStockLocRec.lsBinLoc;
end;

procedure TTradeEventLocation.Set_loBinLocation(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloBinLocation, 'loBinLocation');
  lTXLineRec.TKStockLocRec.lsBinLoc := CustomSetString(lTXLineRec.TKStockLocRec.lsBinLoc, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loCode: WideString;
begin
  Result := lTXLineRec.TKStockLocRec.lsLocCode;
end;

procedure TTradeEventLocation.Set_loCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloCode, 'loCode');
  lTXLineRec.TKStockLocRec.lsLocCode := CustomSetString(lTXLineRec.TKStockLocRec.lsLocCode, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loContact: WideString;
begin
  Result := TTradeEventData(oEventData).LTKLocationRec.loContact;
end;

procedure TTradeEventLocation.Set_loContact(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloContact, 'loContact');
  TTradeEventData(oEventData).LTKLocationRec.loContact := CustomSetString(TTradeEventData(oEventData).LTKLocationRec.loContact, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loCostCentre: WideString;
begin
  Result := lTXLineRec.TKStockLocRec.lsCC;
end;

procedure TTradeEventLocation.Set_loCostCentre(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloCostCentre, 'loCostCentre');
  lTXLineRec.TKStockLocRec.lsCC := CustomSetString(lTXLineRec.TKStockLocRec.lsCC, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loCostOfSalesGL: Integer;
begin
  Result := lTXLineRec.TKStockLocRec.lsDefNom[2];
end;

procedure TTradeEventLocation.Set_loCostOfSalesGL(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxloCostOfSalesGL, 'loCostOfSalesGL');
  lTXLineRec.TKStockLocRec.lsDefNom[2] := CustomSetInteger(lTXLineRec.TKStockLocRec.lsDefNom[2], Value, FDataChanged);
end;


function TTradeEventLocation.Get_loCostPrice: Double;
begin
  Result := lTXLineRec.TKStockLocRec.lsCostPrice;
end;

procedure TTradeEventLocation.Set_loCostPrice(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloCostPrice, 'loCostPrice');
  lTXLineRec.TKStockLocRec.lsCostPrice := CustomSetReal(lTXLineRec.TKStockLocRec.lsCostPrice, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loCostPriceCur: Integer;
begin
  Result := lTXLineRec.TKStockLocRec.lsPCurrency;
end;

procedure TTradeEventLocation.Set_loCostPriceCur(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloCostPriceCur, 'loCostPriceCur');
  lTXLineRec.TKStockLocRec.lsPCurrency := CustomSetInteger(lTXLineRec.TKStockLocRec.lsPCurrency, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loCurrency: Smallint;
begin
  Result := TTradeEventData(oEventData).LTKLocationRec.loCurrency;
end;

procedure TTradeEventLocation.Set_loCurrency(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloCurrency, 'loCurrency');
  TTradeEventData(oEventData).LTKLocationRec.loCurrency := CustomSetInteger(TTradeEventData(oEventData).LTKLocationRec.loCurrency, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loDepartment: WideString;
begin
  Result := lTXLineRec.TKStockLocRec.lsDep;
end;

procedure TTradeEventLocation.Set_loDepartment(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloDepartment, 'loDepartment');
  lTXLineRec.TKStockLocRec.lsDep := CustomSetString(lTXLineRec.TKStockLocRec.lsDep, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loEmailAddr: WideString;
begin
  Result := TTradeEventData(oEventData).LTKLocationRec.loemail;
end;

procedure TTradeEventLocation.Set_loEmailAddr(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloEmailAddr, 'loEmailAddr');
  TTradeEventData(oEventData).LTKLocationRec.loemail := CustomSetString(TTradeEventData(oEventData).LTKLocationRec.loemail, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loFax: WideString;
begin
  Result := TTradeEventData(oEventData).LTKLocationRec.loFax;
end;

procedure TTradeEventLocation.Set_loFax(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloFax, 'loFax');
  TTradeEventData(oEventData).LTKLocationRec.loFax := CustomSetString(TTradeEventData(oEventData).LTKLocationRec.loFax, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loLastUsed: WideString;
begin
  Result := lTXLineRec.TKStockLocRec.lsLastUsed;
end;


function TTradeEventLocation.Get_loModem: WideString;
begin
  Result := TTradeEventData(oEventData).LTKLocationRec.loModem;
end;

procedure TTradeEventLocation.Set_loModem(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloModem, 'loModem');
  TTradeEventData(oEventData).LTKLocationRec.loModem := CustomSetString(TTradeEventData(oEventData).LTKLocationRec.loModem, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loName: WideString;
begin
  Result := TTradeEventData(oEventData).LTKLocationRec.loName;
end;

procedure TTradeEventLocation.Set_loName(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloName, 'loName');
  TTradeEventData(oEventData).LTKLocationRec.loName := CustomSetString(TTradeEventData(oEventData).LTKLocationRec.loName, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loOverrideBinLocation: WordBool;
begin
  Result := TTradeEventData(oEventData).LTKLocationRec.loUseBinLoc;
end;

procedure TTradeEventLocation.Set_loOverrideBinLocation(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloOverrideBinLocation, 'loOverrideBinLocation');
  TTradeEventData(oEventData).LTKLocationRec.loUseBinLoc := CustomSetBoolean(TTradeEventData(oEventData).LTKLocationRec.loUseBinLoc, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loOverrideCCDept: WordBool;
begin
  Result := TTradeEventData(oEventData).LTKLocationRec.loUseCCDep;
end;

procedure TTradeEventLocation.Set_loOverrideCCDept(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloOverrideCCDept, 'loOverrideCCDept');
  TTradeEventData(oEventData).LTKLocationRec.loUseCCDep := CustomSetBoolean(TTradeEventData(oEventData).LTKLocationRec.loUseCCDep, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loOverrideGLCodes: WordBool;
begin
  Result := TTradeEventData(oEventData).LTKLocationRec.loUseNom;
end;

procedure TTradeEventLocation.Set_loOverrideGLCodes(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloOverrideGLCodes, 'loOverrideGLCodes');
  TTradeEventData(oEventData).LTKLocationRec.loUseNom := CustomSetBoolean(TTradeEventData(oEventData).LTKLocationRec.loUseNom, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loOverrideSalesPrice: WordBool;
begin
  Result := TTradeEventData(oEventData).LTKLocationRec.loUsePrice;
end;

procedure TTradeEventLocation.Set_loOverrideSalesPrice(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloOverrideSalesPrice, 'loOverrideSalesPrice');
  TTradeEventData(oEventData).LTKLocationRec.loUsePrice := CustomSetBoolean(TTradeEventData(oEventData).LTKLocationRec.loUsePrice, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loOverrideSupplier: WordBool;
begin
  Result := TTradeEventData(oEventData).LTKLocationRec.loUseSupp;
end;

procedure TTradeEventLocation.Set_loOverrideSupplier(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloOverrideSupplier, 'loOverrideSupplier');
  TTradeEventData(oEventData).LTKLocationRec.loUseSupp := CustomSetBoolean(TTradeEventData(oEventData).LTKLocationRec.loUseSupp, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loPandLGL: Integer;
begin
  Result := lTXLineRec.TKStockLocRec.lsDefNom[3];
end;

procedure TTradeEventLocation.Set_loPandLGL(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloPandLGL, 'loPandLGL');
  lTXLineRec.TKStockLocRec.lsDefNom[3] := CustomSetInteger(lTXLineRec.TKStockLocRec.lsDefNom[3], Value, FDataChanged);
end;


function TTradeEventLocation.Get_loPhone: WideString;
begin
  Result := TTradeEventData(oEventData).LTKLocationRec.loTel;
end;

procedure TTradeEventLocation.Set_loPhone(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloPhone, 'loPhone');
  TTradeEventData(oEventData).LTKLocationRec.loTel := CustomSetString(TTradeEventData(oEventData).LTKLocationRec.loTel, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loQtyAllocated: Double;
begin
  Result := lTXLineRec.TKStockLocRec.lsQtyAlloc;
end;

function TTradeEventLocation.Get_loQtyFree: Double;
begin
  If Syss.FreeExAll Then
    Result := lTXLineRec.TKStockLocRec.lsQtyInStock
  Else Begin
    If Syss.UsePick4All Then
      Result := lTXLineRec.TKStockLocRec.lsQtyInStock - lTXLineRec.TKStockLocRec.lsQtyPicked
    Else
      Result := lTXLineRec.TKStockLocRec.lsQtyInStock - lTXLineRec.TKStockLocRec.lsQtyAlloc;
  End; { Else }
end;

function TTradeEventLocation.Get_loQtyFreeze: Double;
begin
  Result := lTXLineRec.TKStockLocRec.lsQtyFreeze
end;

function TTradeEventLocation.Get_loQtyInStock: Double;
begin
  Result := lTXLineRec.TKStockLocRec.lsQtyInStock;
end;

function TTradeEventLocation.Get_loQtyMax: Double;
begin
  Result := lTXLineRec.TKStockLocRec.lsQtyMax;
end;

procedure TTradeEventLocation.Set_loQtyMax(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloQtyMax, 'loQtyMax');
  lTXLineRec.TKStockLocRec.lsQtyMax := CustomSetReal(lTXLineRec.TKStockLocRec.lsQtyMax, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loQtyMin: Double;
begin
  Result := lTXLineRec.TKStockLocRec.lsQtyMin;
end;

procedure TTradeEventLocation.Set_loQtyMin(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloQtyMin, 'loQtyMin');
  lTXLineRec.TKStockLocRec.lsQtyMin := CustomSetReal(lTXLineRec.TKStockLocRec.lsQtyMin, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loQtyOnOrder: Double;
begin
  Result := lTXLineRec.TKStockLocRec.lsQtyOnOrder;
end;

function TTradeEventLocation.Get_loQtyPicked: Double;
begin
  Result := lTXLineRec.TKStockLocRec.lsQtyPicked;
end;

function TTradeEventLocation.Get_loQtyPosted: Double;
begin
  Result := lTXLineRec.TKStockLocRec.lsQtyPosted;
end;

function TTradeEventLocation.Get_loQtyStockTake: Double;
begin
  Result := lTXLineRec.TKStockLocRec.lsQtyTake;
end;

procedure TTradeEventLocation.Set_loQtyStockTake(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloQtyStockTake, 'loQtyStockTake');
  lTXLineRec.TKStockLocRec.lsQtyTake := CustomSetReal(lTXLineRec.TKStockLocRec.lsQtyTake, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loReorderCostCentre: WideString;
begin
  Result := lTXLineRec.TKStockLocRec.lsRoCC;
end;

procedure TTradeEventLocation.Set_loReorderCostCentre(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloReorderCostCentre, 'loReorderCostCentre');
  lTXLineRec.TKStockLocRec.lsRoCC := CustomSetString(lTXLineRec.TKStockLocRec.lsRoCC, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loReorderCur: Smallint;
begin
  Result := lTXLineRec.TKStockLocRec.lsRoCurrency;
end;

procedure TTradeEventLocation.Set_loReorderCur(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloReorderCur, 'loReorderCur');
  lTXLineRec.TKStockLocRec.lsRoCurrency := CustomSetInteger(lTXLineRec.TKStockLocRec.lsRoCurrency, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loReorderDate: WideString;
begin
  Result := lTXLineRec.TKStockLocRec.lsRoDate;
end;

procedure TTradeEventLocation.Set_loReorderDate(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloReorderDate, 'loReorderDate');
  lTXLineRec.TKStockLocRec.lsRoDate := CustomSetString(lTXLineRec.TKStockLocRec.lsRoDate, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loReorderDepartment: WideString;
begin
  Result := lTXLineRec.TKStockLocRec.lsRoDep;
end;

procedure TTradeEventLocation.Set_loReorderDepartment(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloReorderDepartment, 'loReorderDepartment');
  lTXLineRec.TKStockLocRec.lsRoDep := CustomSetString(lTXLineRec.TKStockLocRec.lsRoDep, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loReorderPrice: Double;
begin
  Result := lTXLineRec.TKStockLocRec.lsRoPrice;
end;

procedure TTradeEventLocation.Set_loReorderPrice(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloReorderPrice, 'loReorderPrice');
  lTXLineRec.TKStockLocRec.lsRoPrice := CustomSetReal(lTXLineRec.TKStockLocRec.lsRoPrice, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loReorderQty: Double;
begin
  Result := lTXLineRec.TKStockLocRec.lsRoQty;
end;

procedure TTradeEventLocation.Set_loReorderQty(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloReorderQty, 'loReorderQty');
  lTXLineRec.TKStockLocRec.lsRoQty := CustomSetReal(lTXLineRec.TKStockLocRec.lsRoQty, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loRep: WideString;
begin
  Result := TTradeEventData(oEventData).LTKLocationRec.loRep;
end;

procedure TTradeEventLocation.Set_loRep(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloRep, 'loRep');
  TTradeEventData(oEventData).LTKLocationRec.loRep := CustomSetString(TTradeEventData(oEventData).LTKLocationRec.loRep, Value, FDataChanged);
end;


Function TTradeEventLocation.GetSalesBandPrice (Const BandNo : Byte) : Double;
begin
  Result := lTXLineRec.TKStockLocRec.lsSaleBands[BandNo].SalesPrice;
end;

Procedure TTradeEventLocation.SetSalesBandPrice (Const BandNo : Byte; Const Value : Double; var Changed : boolean);
begin
  lTXLineRec.TKStockLocRec.lsSaleBands[BandNo].SalesPrice := CustomSetReal(lTXLineRec.TKStockLocRec.lsSaleBands[BandNo].SalesPrice
  , Value, FDataChanged);
end;

Function TTradeEventLocation.GetSalesBandCcy (Const BandNo : Byte) : Integer;
begin
  Result := lTXLineRec.TKStockLocRec.lsSaleBands[BandNo].Currency;
end;

Procedure TTradeEventLocation.SetSalesBandCcy (Const BandNo : Byte; Const Value : Integer; var Changed : boolean);
var
  FVersionO : TTradeVersion;
begin
  FVersionO := TTradeVersion.Create;

  lTXLineRec.TKStockLocRec.lsSaleBands[BandNo].Currency := CustomSetInteger(lTXLineRec.TKStockLocRec.lsSaleBands[BandNo].Currency
  , FVersionO.ValidateCurrencyNo(Value), FDataChanged);

  FVersionO := nil;
end;

function TTradeEventLocation.Get_loSalesBands(const Band: WideString): ITradeStockSalesBand;
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

function TTradeEventLocation.Get_loSalesGL: Integer;
begin
  Result := lTXLineRec.TKStockLocRec.lsDefNom[1];
end;

procedure TTradeEventLocation.Set_loSalesGL(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloSalesGL, 'loSalesGL');
  lTXLineRec.TKStockLocRec.lsDefNom[1] := CustomSetInteger(lTXLineRec.TKStockLocRec.lsDefNom[1], Value, FDataChanged);
end;


function TTradeEventLocation.Get_loSupplier: WideString;
begin
  Result := lTXLineRec.TKStockLocRec.lsSupplier;
end;

procedure TTradeEventLocation.Set_loSupplier(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloSupplier, 'loSupplier');
  lTXLineRec.TKStockLocRec.lsSupplier := CustomSetString(lTXLineRec.TKStockLocRec.lsSupplier, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loSuppTemp: WideString;
begin
  Result := lTXLineRec.TKStockLocRec.lsTempSupp;
end;

procedure TTradeEventLocation.Set_loSuppTemp(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloSuppTemp, 'loSuppTemp');
  lTXLineRec.TKStockLocRec.lsTempSupp := CustomSetString(lTXLineRec.TKStockLocRec.lsTempSupp, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loTagged: WordBool;
begin
  Result := TTradeEventData(oEventData).LTKLocationRec.loTag;
end;

procedure TTradeEventLocation.Set_loTagged(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloTagged, 'loTagged');
  TTradeEventData(oEventData).LTKLocationRec.loTag
  := CustomSetBoolean(TTradeEventData(oEventData).LTKLocationRec.loTag, Value, FDataChanged);
end;


function TTradeEventLocation.Get_loTimeChange: WideString;
begin
  Result := lTXLineRec.TKStockLocRec.lsLastTime;
end;

function TTradeEventLocation.Get_loWIPGL: Integer;
begin
  Result := lTXLineRec.TKStockLocRec.lsDefNom[5];
end;

procedure TTradeEventLocation.Set_loWIPGL(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxloWIPGL, 'loWIPGL');
  lTXLineRec.TKStockLocRec.lsDefNom[5] := CustomSetInteger(lTXLineRec.TKStockLocRec.lsDefNom[5]
  , Value, FDataChanged);
end;

end.
