unit zTimeRat;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU;

type
  TCOMTimeRate = class(TAutoIntfObject, ICOMTimeRate)
  private
    FEntSysObj : TEnterpriseSystem;
    FTimeRate  : TAbsTimeRate;
  protected
    { Property methods }
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_trRateCode: WideString; safecall;
    procedure Set_trRateCode(const Value: WideString); safecall;
    function Get_trEmployeeCode: WideString; safecall;
    procedure Set_trEmployeeCode(const Value: WideString); safecall;
    function Get_trCostCurrency: Integer; safecall;
    procedure Set_trCostCurrency(Value: Integer); safecall;
    function Get_trTimeCost: Double; safecall;
    procedure Set_trTimeCost(Value: Double); safecall;
    function Get_trChargeCurrency: Integer; safecall;
    procedure Set_trChargeCurrency(Value: Integer); safecall;
    function Get_trTimeCharge: Double; safecall;
    procedure Set_trTimeCharge(Value: Double); safecall;
    function Get_trAnalysisCode: WideString; safecall;
    procedure Set_trAnalysisCode(const Value: WideString); safecall;
    function Get_trDescription: WideString; safecall;
    procedure Set_trDescription(const Value: WideString); safecall;
    function Get_trPayFactor: Integer; safecall;
    procedure Set_trPayFactor(Value: Integer); safecall;
    function Get_trPayRate: Integer; safecall;
    procedure Set_trPayRate(Value: Integer); safecall;
  public
    Constructor Create;
    procedure InitTimeRate(EntSysObj: TEnterpriseSystem);
  End; { TCOMTimeRate }

implementation

uses ComServ, CustIntU, ZUtils;

//=========================================================================

Constructor TCOMTimeRate.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMTimeRate);

  FEntSysObj := Nil;
End; { Create }

//-------------------------------------------------------------------------

procedure TCOMTimeRate.InitTimeRate(EntSysObj: TEnterpriseSystem);
begin
  FEntSysObj := EntSysObj;
  FTimeRate := FEntSysObj.JobCosting.TimeRate;
end;

//-------------------------------------------------------------------------

function TCOMTimeRate.Get_AccessRights: TRecordAccessStatus;
begin
  Result := Ord(FTimeRate.AccessRights);
end;

//------------------------------

function TCOMTimeRate.Get_trRateCode: WideString;
begin
  Result := FTimeRate.trRateCode;
end;

procedure TCOMTimeRate.Set_trRateCode(const Value: WideString);
begin
  FTimeRate.trRateCode := Value;
end;

//------------------------------

function TCOMTimeRate.Get_trEmployeeCode: WideString;
begin
  Result := FTimeRate.trEmployeeCode;
end;

procedure TCOMTimeRate.Set_trEmployeeCode(const Value: WideString);
begin
  FTimeRate.trEmployeeCode := Value;
end;

//------------------------------

function TCOMTimeRate.Get_trCostCurrency: Integer;
begin
  Result := FTimeRate.trCostCurrency;
end;

procedure TCOMTimeRate.Set_trCostCurrency(Value: Integer);
begin
  FTimeRate.trCostCurrency := Value;
end;

//------------------------------

function TCOMTimeRate.Get_trTimeCost: Double;
begin
  Result := FTimeRate.trTimeCost;
end;

procedure TCOMTimeRate.Set_trTimeCost(Value: Double);
begin
  FTimeRate.trTimeCost := Value;
end;

//------------------------------

function TCOMTimeRate.Get_trChargeCurrency: Integer;
begin
  Result := FTimeRate.trChargeCurrency;
end;

procedure TCOMTimeRate.Set_trChargeCurrency(Value: Integer);
begin
  FTimeRate.trChargeCurrency := Value;
end;

//------------------------------

function TCOMTimeRate.Get_trTimeCharge: Double;
begin
  Result := FTimeRate.trTimeCharge;
end;

procedure TCOMTimeRate.Set_trTimeCharge(Value: Double);
begin
  FTimeRate.trTimeCharge := Value;
end;

//------------------------------

function TCOMTimeRate.Get_trAnalysisCode: WideString;
begin
  Result := FTimeRate.trAnalysisCode;
end;

procedure TCOMTimeRate.Set_trAnalysisCode(const Value: WideString);
begin
  FTimeRate.trAnalysisCode := Value;
end;

//------------------------------

function TCOMTimeRate.Get_trDescription: WideString;
begin
  Result := FTimeRate.trDescription;
end;

procedure TCOMTimeRate.Set_trDescription(const Value: WideString);
begin
  FTimeRate.trDescription := Value;
end;

//------------------------------

function TCOMTimeRate.Get_trPayFactor: Integer;
begin
  Result := FTimeRate.trPayFactor;
end;

procedure TCOMTimeRate.Set_trPayFactor(Value: Integer);
begin
  FTimeRate.trPayFactor := Value;
end;

//------------------------------

function TCOMTimeRate.Get_trPayRate: Integer;
begin
  Result := FTimeRate.trPayRate;
end;

procedure TCOMTimeRate.Set_trPayRate(Value: Integer);
begin
  FTimeRate.trPayRate := Value;
end;

//=========================================================================

end.
