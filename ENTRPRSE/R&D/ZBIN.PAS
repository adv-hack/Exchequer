unit zBin;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU, zCcyTri;

Type
  TCOMMutliBin = class(TAutoIntfObject, ICOMMultiBin, ICOMMultiBin2)
  private
    FEntSysObj : TEnterpriseSystem;
    FMultiBin  : TAbsMultiBin2;

    FCcyTriO  : TCOMCurrencyTriangulation;
    FCcyTriI  : ICOMCurrencyTriangulation;
  protected
    { Property methods }
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_brBinCode: WideString; safecall;
    procedure Set_brBinCode(const Value: WideString); safecall;
    function Get_brStockFolio: Integer; safecall;
    procedure Set_brStockFolio(Value: Integer); safecall;
    function Get_brPickingPriority: WideString; safecall;
    procedure Set_brPickingPriority(const Value: WideString); safecall;
    function Get_brUseByDate: WideString; safecall;
    procedure Set_brUseByDate(const Value: WideString); safecall;
    function Get_brUnitOfMeasurement: WideString; safecall;
    procedure Set_brUnitOfMeasurement(const Value: WideString); safecall;
    function Get_brAutoPickMode: Integer; safecall;
    procedure Set_brAutoPickMode(Value: Integer); safecall;
    function Get_brTagNo: Integer; safecall;
    procedure Set_brTagNo(Value: Integer); safecall;
    function Get_brQty: Double; safecall;
    procedure Set_brQty(Value: Double); safecall;
    function Get_brQtyUsed: Double; safecall;
    procedure Set_brQtyUsed(Value: Double); safecall;
    function Get_brCapacity: Double; safecall;
    procedure Set_brCapacity(Value: Double); safecall;
    function Get_brCostPrice: Double; safecall;
    procedure Set_brCostPrice(Value: Double); safecall;
    function Get_brCostPriceCurrency: Integer; safecall;
    procedure Set_brCostPriceCurrency(Value: Integer); safecall;
    function Get_brSalesPrice: Double; safecall;
    procedure Set_brSalesPrice(Value: Double); safecall;
    function Get_brSalesPriceCurrency: Integer; safecall;
    procedure Set_brSalesPriceCurrency(Value: Integer); safecall;
    function Get_brInDate: WideString; safecall;
    procedure Set_brInDate(const Value: WideString); safecall;
    function Get_brInOrderRef: WideString; safecall;
    procedure Set_brInOrderRef(const Value: WideString); safecall;
    function Get_brInOrderLine: Integer; safecall;
    procedure Set_brInOrderLine(Value: Integer); safecall;
    function Get_brInDocRef: WideString; safecall;
    procedure Set_brInDocRef(const Value: WideString); safecall;
    function Get_brInDocLine: Integer; safecall;
    procedure Set_brInDocLine(Value: Integer); safecall;
    function Get_brInLocation: WideString; safecall;
    procedure Set_brInLocation(const Value: WideString); safecall;
    function Get_brUsedRec: WordBool; safecall;
    procedure Set_brUsedRec(Value: WordBool); safecall;
    function Get_brSold: WordBool; safecall;
    procedure Set_brSold(Value: WordBool); safecall;
    function Get_brOutDate: WideString; safecall;
    procedure Set_brOutDate(const Value: WideString); safecall;
    function Get_brOutOrderRef: WideString; safecall;
    procedure Set_brOutOrderRef(const Value: WideString); safecall;
    function Get_brOutOrderLine: Integer; safecall;
    procedure Set_brOutOrderLine(Value: Integer); safecall;
    function Get_brOutDocRef: WideString; safecall;
    procedure Set_brOutDocRef(const Value: WideString); safecall;
    function Get_brOutDocLine: Integer; safecall;
    procedure Set_brOutDocLine(Value: Integer); safecall;
    function Get_brOutLocation: WideString; safecall;
    procedure Set_brOutLocation(const Value: WideString); safecall;
    function Get_brCompanyRate: Double; safecall;
    procedure Set_brCompanyRate(Value: Double); safecall;
    function Get_brDailyRate: Double; safecall;
    procedure Set_brDailyRate(Value: Double); safecall;
    function Get_brUseORate: Smallint; safecall;
    procedure Set_brUseORate(Value: Smallint); safecall;
    function Get_brTriangulation: ICOMCurrencyTriangulation; safecall;

    // HM 27/07/05 - ICOMMultiBin2
    function Get_brReturned: WordBool; safecall;
    procedure Set_brReturned(Value: WordBool); safecall;
  public
    Constructor Create;
    Destructor Destroy; Override;

    procedure InitMultiBin(EntSysObj: TEnterpriseSystem);
  End; { TCOMMutliBin }

implementation

uses ComServ, CustIntU, ZUtils;

//=========================================================================

Constructor TCOMMutliBin.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMMultiBin2);

  FEntSysObj := Nil;

  FCcyTriO := NIL;
  FCcyTriI := NIL;
End; { Create }

//------------------------------

destructor TCOMMutliBin.Destroy;
begin
  FCcyTriO := NIL;
  FCcyTriI := NIL;

  FEntSysObj := NIL;

  inherited;
end;

//-------------------------------------------------------------------------

procedure TCOMMutliBin.InitMultiBin(EntSysObj: TEnterpriseSystem);
begin
  FEntSysObj := EntSysObj;
  FMultiBin  := FEntSysObj.Bin As TAbsMultiBin2;

  If Assigned(FCcyTriO) Then FCcyTriO.InitCcyTri(FMultiBin.brTriangulation);
end;

//-------------------------------------------------------------------------

function TCOMMutliBin.Get_AccessRights: TRecordAccessStatus;
begin
  Result := Ord(FMultiBin.AccessRights);
end;

//-------------------------------------------------------------------------

function TCOMMutliBin.Get_brBinCode: WideString;
begin
  Result := FMultiBin.brBinCode;
end;

procedure TCOMMutliBin.Set_brBinCode(const Value: WideString);
begin
  FMultiBin.brBinCode := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brStockFolio: Integer;
begin
  Result := FMultiBin.brStockFolio;
end;

procedure TCOMMutliBin.Set_brStockFolio(Value: Integer);
begin
  FMultiBin.brStockFolio := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brPickingPriority: WideString;
begin
  Result := FMultiBin.brPickingPriority;
end;

procedure TCOMMutliBin.Set_brPickingPriority(const Value: WideString);
begin
  FMultiBin.brPickingPriority := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brUseByDate: WideString;
begin
  Result := FMultiBin.brUseByDate;
end;

procedure TCOMMutliBin.Set_brUseByDate(const Value: WideString);
begin
  FMultiBin.brUseByDate := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brUnitOfMeasurement: WideString;
begin
  Result := FMultiBin.brUnitOfMeasurement;
end;

procedure TCOMMutliBin.Set_brUnitOfMeasurement(const Value: WideString);
begin
  FMultiBin.brUnitOfMeasurement := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brAutoPickMode: Integer;
begin
  Result := FMultiBin.brAutoPickMode;
end;

procedure TCOMMutliBin.Set_brAutoPickMode(Value: Integer);
begin
  FMultiBin.brAutoPickMode := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brTagNo: Integer;
begin
  Result := FMultiBin.brTagNo;
end;

procedure TCOMMutliBin.Set_brTagNo(Value: Integer);
begin
  FMultiBin.brTagNo := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brQty: Double;
begin
  Result := FMultiBin.brQty;
end;

procedure TCOMMutliBin.Set_brQty(Value: Double);
begin
  FMultiBin.brQty := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brQtyUsed: Double;
begin
  Result := FMultiBin.brQtyUsed;
end;

procedure TCOMMutliBin.Set_brQtyUsed(Value: Double);
begin
  FMultiBin.brQtyUsed := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brCapacity: Double;
begin
  Result := FMultiBin.brCapacity;
end;

procedure TCOMMutliBin.Set_brCapacity(Value: Double);
begin
  FMultiBin.brCapacity := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brCostPrice: Double;
begin
  Result := FMultiBin.brCostPrice;
end;

procedure TCOMMutliBin.Set_brCostPrice(Value: Double);
begin
  FMultiBin.brCostPrice := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brCostPriceCurrency: Integer;
begin
  Result := FMultiBin.brCostPriceCurrency;
end;

procedure TCOMMutliBin.Set_brCostPriceCurrency(Value: Integer);
begin
  FMultiBin.brCostPriceCurrency := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brSalesPrice: Double;
begin
  Result := FMultiBin.brSalesPrice;
end;

procedure TCOMMutliBin.Set_brSalesPrice(Value: Double);
begin
  FMultiBin.brSalesPrice := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brSalesPriceCurrency: Integer;
begin
  Result := FMultiBin.brSalesPriceCurrency;
end;

procedure TCOMMutliBin.Set_brSalesPriceCurrency(Value: Integer);
begin
  FMultiBin.brSalesPriceCurrency := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brInDate: WideString;
begin
  Result := FMultiBin.brInDate;
end;

procedure TCOMMutliBin.Set_brInDate(const Value: WideString);
begin
  FMultiBin.brInDate := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brInOrderRef: WideString;
begin
  Result := FMultiBin.brInOrderRef;
end;

procedure TCOMMutliBin.Set_brInOrderRef(const Value: WideString);
begin
  FMultiBin.brInOrderRef := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brInOrderLine: Integer;
begin
  Result := FMultiBin.brInOrderLine;
end;

procedure TCOMMutliBin.Set_brInOrderLine(Value: Integer);
begin
  FMultiBin.brInOrderLine := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brInDocRef: WideString;
begin
  Result := FMultiBin.brInDocRef;
end;

procedure TCOMMutliBin.Set_brInDocRef(const Value: WideString);
begin
  FMultiBin.brInDocRef := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brInDocLine: Integer;
begin
  Result := FMultiBin.brInDocLine;
end;

procedure TCOMMutliBin.Set_brInDocLine(Value: Integer);
begin
  FMultiBin.brInDocLine := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brInLocation: WideString;
begin
  Result := FMultiBin.brInLocation;
end;

procedure TCOMMutliBin.Set_brInLocation(const Value: WideString);
begin
  FMultiBin.brInLocation := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brUsedRec: WordBool;
begin
  Result := FMultiBin.brUsedRec;
end;

procedure TCOMMutliBin.Set_brUsedRec(Value: WordBool);
begin
  FMultiBin.brUsedRec := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brSold: WordBool;
begin
  Result := FMultiBin.brSold;
end;

procedure TCOMMutliBin.Set_brSold(Value: WordBool);
begin
  FMultiBin.brSold := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brOutDate: WideString;
begin
  Result := FMultiBin.brOutDate;
end;

procedure TCOMMutliBin.Set_brOutDate(const Value: WideString);
begin
  FMultiBin.brOutDate := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brOutOrderRef: WideString;
begin
  Result := FMultiBin.brOutOrderRef;
end;

procedure TCOMMutliBin.Set_brOutOrderRef(const Value: WideString);
begin
  FMultiBin.brOutOrderRef := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brOutOrderLine: Integer;
begin
  Result := FMultiBin.brOutOrderLine;
end;

procedure TCOMMutliBin.Set_brOutOrderLine(Value: Integer);
begin
  FMultiBin.brOutOrderLine := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brOutDocRef: WideString;
begin
  Result := FMultiBin.brOutDocRef;
end;

procedure TCOMMutliBin.Set_brOutDocRef(const Value: WideString);
begin
  FMultiBin.brOutDocRef := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brOutDocLine: Integer;
begin
  Result := FMultiBin.brOutDocLine;
end;

procedure TCOMMutliBin.Set_brOutDocLine(Value: Integer);
begin
  FMultiBin.brOutDocLine := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brOutLocation: WideString;
begin
  Result := FMultiBin.brOutLocation;
end;

procedure TCOMMutliBin.Set_brOutLocation(const Value: WideString);
begin
  FMultiBin.brOutLocation := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brCompanyRate: Double;
begin
  Result := FMultiBin.brCompanyRate;
end;

procedure TCOMMutliBin.Set_brCompanyRate(Value: Double);
begin
  FMultiBin.brCompanyRate := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brDailyRate: Double;
begin
  Result := FMultiBin.brDailyRate;
end;

procedure TCOMMutliBin.Set_brDailyRate(Value: Double);
begin
  FMultiBin.brDailyRate := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brUseORate: Smallint;
begin
  Result := FMultiBin.brUseORate;
end;

procedure TCOMMutliBin.Set_brUseORate(Value: Smallint);
begin
  FMultiBin.brUseORate := Value;
end;

//------------------------------

function TCOMMutliBin.Get_brTriangulation: ICOMCurrencyTriangulation;
begin
  If (Not Assigned(FCcyTriO)) Then Begin
    { Create and initialise the Job Actuals sub-object }
    FCcyTriO := TCOMCurrencyTriangulation.Create;
    FCcyTriO.InitCcyTri(FMultiBin.brTriangulation);

    FCcyTriI := FCcyTriO;
  End; { If (Not Assigned(FCcyTriO)) }

  Result := FCcyTriI;
end;

//------------------------------

function TCOMMutliBin.Get_brReturned: WordBool;
begin
  Result := FMultiBin.brReturned;
end;

procedure TCOMMutliBin.Set_brReturned(Value: WordBool);
begin
  FMultiBin.brReturned := Value;
end;

//------------------------------

end.
