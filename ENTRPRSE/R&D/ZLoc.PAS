unit zLoc;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU;

Type
  TCOMLocation = class(TAutoIntfObject, ICOMLocation)
  private
    FEntSysObj : TEnterpriseSystem;
    FLocation  : TAbsLocation;
  protected
    { Property methods }
    function Get_AccessRights: TRecordAccessStatus; safecall;

    function Get_loCode: WideString; safecall;
    procedure Set_loCode(const Value: WideString); safecall;
    function Get_loName: WideString; safecall;
    procedure Set_loName(const Value: WideString); safecall;
    function Get_loAddress(Index: Integer): WideString; safecall;
    procedure Set_loAddress(Index: Integer; const Value: WideString); safecall;
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
    function Get_loCurrency: TCurrencyType; safecall;
    procedure Set_loCurrency(Value: TCurrencyType); safecall;
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
    function Get_loSalesReturnGL: Integer; safecall;
    procedure Set_loSalesReturnGL(Value: Integer); safecall;
    function Get_loPurchaseReturnGL: Integer; safecall;
    procedure Set_loPurchaseReturnGL(Value: Integer); safecall;
  public
    Constructor Create;
    Destructor Destroy; Override;

    procedure InitLocation(EntSysObj: TEnterpriseSystem);
  End; // TCOMLocation

implementation

uses ComServ, CustIntU, ZUtils;

//=========================================================================

Constructor TCOMLocation.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMLocation);

  FEntSysObj := Nil;
End; { Create }

//------------------------------

destructor TCOMLocation.Destroy;
begin
  FEntSysObj := NIL;

  inherited;
end;

//-------------------------------------------------------------------------

procedure TCOMLocation.InitLocation(EntSysObj: TEnterpriseSystem);
begin
  FEntSysObj := EntSysObj;
  FLocation  := FEntSysObj.Location;
end;

//-------------------------------------------------------------------------

function TCOMLocation.Get_AccessRights: TRecordAccessStatus;
begin
  Result := Ord(FLocation.AccessRights);
end;

//-------------------------------------------------------------------------

function TCOMLocation.Get_loCode: WideString;
begin
  Result := FLocation.loCode;
end;

procedure TCOMLocation.Set_loCode(const Value: WideString);
begin
  FLocation.loCode := Value;
end;

//------------------------------

function TCOMLocation.Get_loName: WideString;
begin
  Result := FLocation.loName;
end;
procedure TCOMLocation.Set_loName(const Value: WideString);
begin
  FLocation.loName := Value;
end;

//------------------------------

function TCOMLocation.Get_loAddress(Index: Integer): WideString;
begin
  Result := FLocation.loAddress[Index];
end;
procedure TCOMLocation.Set_loAddress(Index: Integer; const Value: WideString);
begin
  FLocation.loAddress[Index] := Value;
end;

//------------------------------

function TCOMLocation.Get_loPhone: WideString;
begin
  Result := FLocation.loPhone;
end;
procedure TCOMLocation.Set_loPhone(const Value: WideString);
begin
  FLocation.loPhone := Value;
end;

//------------------------------

function TCOMLocation.Get_loFax: WideString;
begin
  Result := FLocation.loFax;
end;
procedure TCOMLocation.Set_loFax(const Value: WideString);
begin
  FLocation.loFax := Value;
end;

//------------------------------

function TCOMLocation.Get_loEmailAddr: WideString;
begin
  Result := FLocation.loEmailAddr;
end;
procedure TCOMLocation.Set_loEmailAddr(const Value: WideString);
begin
  FLocation.loEmailAddr := Value;
end;

//------------------------------

function TCOMLocation.Get_loModem: WideString;
begin
  Result := FLocation.loModem;
end;
procedure TCOMLocation.Set_loModem(const Value: WideString);
begin
  FLocation.loModem := Value;
end;

//------------------------------

function TCOMLocation.Get_loContact: WideString;
begin
  Result := FLocation.loContact;
end;
procedure TCOMLocation.Set_loContact(const Value: WideString);
begin
  FLocation.loContact := Value;
end;

//------------------------------

function TCOMLocation.Get_loCurrency: TCurrencyType;
begin
  Result := FLocation.loCurrency;
end;
procedure TCOMLocation.Set_loCurrency(Value: TCurrencyType);
begin
  FLocation.loCurrency := Value;
end;

//------------------------------

function TCOMLocation.Get_loArea: WideString;
begin
  Result := FLocation.loArea;
end;
procedure TCOMLocation.Set_loArea(const Value: WideString);
begin
  FLocation.loArea := Value;
end;

//------------------------------

function TCOMLocation.Get_loRep: WideString;
begin
  Result := FLocation.loRep;
end;
procedure TCOMLocation.Set_loRep(const Value: WideString);
begin
  FLocation.loRep := Value;
end;

//------------------------------

function TCOMLocation.Get_loTagged: WordBool;
begin
  Result := FLocation.loTagged;
end;
procedure TCOMLocation.Set_loTagged(Value: WordBool);
begin
  FLocation.loTagged := Value;
end;

//------------------------------

function TCOMLocation.Get_loCostCentre: WideString;
begin
  Result := FLocation.loCostCentre;
end;
procedure TCOMLocation.Set_loCostCentre(const Value: WideString);
begin
  FLocation.loCostCentre := Value;
end;

//------------------------------

function TCOMLocation.Get_loDepartment: WideString;
begin
  Result := FLocation.loDepartment;
end;
procedure TCOMLocation.Set_loDepartment(const Value: WideString);
begin
  FLocation.loDepartment := Value;
end;

//------------------------------

function TCOMLocation.Get_loOverrideSalesPrice: WordBool;
begin
  Result := FLocation.loOverrideSalesPrice;
end;
procedure TCOMLocation.Set_loOverrideSalesPrice(Value: WordBool);
begin
  FLocation.loOverrideSalesPrice := Value;
end;

//------------------------------

function TCOMLocation.Get_loOverrideGLCodes: WordBool;
begin
  Result := FLocation.loOverrideGLCodes;
end;
procedure TCOMLocation.Set_loOverrideGLCodes(Value: WordBool);
begin
  FLocation.loOverrideGLCodes := Value;
end;

//------------------------------

function TCOMLocation.Get_loOverrideCCDept: WordBool;
begin
  Result := FLocation.loOverrideCCDept;
end;
procedure TCOMLocation.Set_loOverrideCCDept(Value: WordBool);
begin
  FLocation.loOverrideCCDept := Value;
end;

//------------------------------

function TCOMLocation.Get_loOverrideSupplier: WordBool;
begin
  Result := FLocation.loOverrideSupplier;
end;
procedure TCOMLocation.Set_loOverrideSupplier(Value: WordBool);
begin
  FLocation.loOverrideSupplier := Value;
end;

//------------------------------

function TCOMLocation.Get_loOverrideBinLocation: WordBool;
begin
  Result := FLocation.loOverrideBinLocation;
end;
procedure TCOMLocation.Set_loOverrideBinLocation(Value: WordBool);
begin
  FLocation.loOverrideBinLocation := Value;
end;

//------------------------------

function TCOMLocation.Get_loSalesGL: Integer;
begin
  Result := FLocation.loSalesGL;
end;
procedure TCOMLocation.Set_loSalesGL(Value: Integer);
begin
  FLocation.loSalesGL := Value;
end;

//------------------------------

function TCOMLocation.Get_loCostOfSalesGL: Integer;
begin
  Result := FLocation.loCostOfSalesGL;
end;
procedure TCOMLocation.Set_loCostOfSalesGL(Value: Integer);
begin
  FLocation.loCostOfSalesGL := Value;
end;

//------------------------------

function TCOMLocation.Get_loPandLGL: Integer;
begin
  Result := FLocation.loPandLGL;
end;
procedure TCOMLocation.Set_loPandLGL(Value: Integer);
begin
  FLocation.loPandLGL := Value;
end;

//------------------------------

function TCOMLocation.Get_loBalSheetGL: Integer;
begin
  Result := FLocation.loBalSheetGL;
end;
procedure TCOMLocation.Set_loBalSheetGL(Value: Integer);
begin
  FLocation.loBalSheetGL := Value;
end;

//------------------------------

function TCOMLocation.Get_loWIPGL: Integer;
begin
  Result := FLocation.loWIPGL;
end;
procedure TCOMLocation.Set_loWIPGL(Value: Integer);
begin
  FLocation.loWIPGL := Value;
end;

//------------------------------

function TCOMLocation.Get_loSalesReturnGL: Integer;
begin
  Result := FLocation.loSalesReturnGL;
end;
procedure TCOMLocation.Set_loSalesReturnGL(Value: Integer);
begin
  FLocation.loSalesReturnGL := Value;
end;

//------------------------------

function TCOMLocation.Get_loPurchaseReturnGL: Integer;
begin
  Result := FLocation.loPurchaseReturnGL;
end;
procedure TCOMLocation.Set_loPurchaseReturnGL(Value: Integer);
begin
  FLocation.loPurchaseReturnGL := Value;
end;

//------------------------------

end.
