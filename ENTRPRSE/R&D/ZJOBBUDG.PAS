unit zJobBudg;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU, zCcyTri;

type
  TCOMJobBudget = class(TAutoIntfObject, ICOMJobBudget, ICOMJobBudget2, ICOMJobBudget3)
  private
    FEntSysObj : TEnterpriseSystem;
    FJobBudget : TAbsJobBudget;
  protected
    { Property methods }
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_jbType: Integer; safecall;
    procedure Set_jbType(Value: Integer); safecall;
    function Get_jbUnitPrice: Double; safecall;
    procedure Set_jbUnitPrice(Value: Double); safecall;
    function Get_jbOriginalQty: Double; safecall;
    procedure Set_jbOriginalQty(Value: Double); safecall;
    function Get_jbRevisedQty: Double; safecall;
    procedure Set_jbRevisedQty(Value: Double); safecall;
    function Get_jbOriginalValue: Double; safecall;
    procedure Set_jbOriginalValue(Value: Double); safecall;
    function Get_jbRevisedValue: Double; safecall;
    procedure Set_jbRevisedValue(Value: Double); safecall;
    function Get_jbOriginalValuation: Double; safecall;
    procedure Set_jbOriginalValuation(Value: Double); safecall;
    function Get_jbRevisedValuation: Double; safecall;
    procedure Set_jbRevisedValuation(Value: Double); safecall;
    function Get_jbUplift: Double; safecall;
    procedure Set_jbUplift(Value: Double); safecall;
    function Get_jbBudgetType: Integer; safecall;
    procedure Set_jbBudgetType(Value: Integer); safecall;
    function Get_jbJobCode: WideString; safecall;
    procedure Set_jbJobCode(const Value: WideString); safecall;
    function Get_jbStockCode: WideString; safecall;
    procedure Set_jbStockCode(const Value: WideString); safecall;
    function Get_jbAnalysisCode: WideString; safecall;
    procedure Set_jbAnalysisCode(const Value: WideString); safecall;
    function Get_jbRecharge: WordBool; safecall;
    procedure Set_jbRecharge(Value: WordBool); safecall;
    function Get_jbCostOverhead: Double; safecall;
    procedure Set_jbCostOverhead(Value: Double); safecall;

    // ICOMJobBudget2
    function Get_jbOrigValuation: Double; safecall;
    procedure Set_jbOrigValuation(Value: Double); safecall;
    function Get_jbRevValuation: Double; safecall;
    procedure Set_jbRevValuation(Value: Double); safecall;
    function Get_jbValuationPercentage: Double; safecall;
    procedure Set_jbValuationPercentage(Value: Double); safecall;
    function Get_jbValuationBasis: Integer; safecall;
    procedure Set_jbValuationBasis(Value: Integer); safecall;

    // ICOMJobBudget3
    function Get_jbBudgetCurrency: Smallint; safecall;
    procedure Set_jbBudgetCurrency(Value: Smallint); safecall;

  public
    Constructor Create;

    procedure InitJobBudget(EntSysObj: TEnterpriseSystem);
  End; { TCOMJobBudget }

implementation

uses ComServ, CustIntU, ZUtils;

//=========================================================================

Constructor TCOMJobBudget.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMJobBudget3);

  FEntSysObj := Nil;
End; { Create }

//-------------------------------------------------------------------------

procedure TCOMJobBudget.InitJobBudget(EntSysObj: TEnterpriseSystem);
begin
  FEntSysObj := EntSysObj;
  FJobBudget := FEntSysObj.JobCosting.Job2.jrBudget;
end;

//-------------------------------------------------------------------------

function TCOMJobBudget.Get_AccessRights: TRecordAccessStatus;
begin
  Result := Ord(FJobBudget.AccessRights);
end;

//------------------------------

function TCOMJobBudget.Get_jbType: Integer;
begin
  Result := FJobBudget.jbType;
end;

procedure TCOMJobBudget.Set_jbType(Value: Integer);
begin
  FJobBudget.jbType := Value;
end;

//------------------------------

function TCOMJobBudget.Get_jbUnitPrice: Double;
begin
  Result := FJobBudget.jbUnitPrice;
end;

procedure TCOMJobBudget.Set_jbUnitPrice(Value: Double);
begin
  FJobBudget.jbUnitPrice := Value;
end;

//------------------------------

function TCOMJobBudget.Get_jbOriginalQty: Double;
begin
  Result := FJobBudget.jbOriginalQty;
end;

procedure TCOMJobBudget.Set_jbOriginalQty(Value: Double);
begin
  FJobBudget.jbOriginalQty := Value;
end;

//------------------------------

function TCOMJobBudget.Get_jbRevisedQty: Double;
begin
  Result := FJobBudget.jbRevisedQty;
end;

procedure TCOMJobBudget.Set_jbRevisedQty(Value: Double);
begin
  FJobBudget.jbRevisedQty := Value;
end;

//------------------------------

function TCOMJobBudget.Get_jbOriginalValue: Double;
begin
  Result := FJobBudget.jbOriginalValue;
end;

procedure TCOMJobBudget.Set_jbOriginalValue(Value: Double);
begin
  FJobBudget.jbOriginalValue := Value;
end;

//------------------------------

function TCOMJobBudget.Get_jbRevisedValue: Double;
begin
  Result := FJobBudget.jbRevisedValue;
end;

procedure TCOMJobBudget.Set_jbRevisedValue(Value: Double);
begin
  FJobBudget.jbRevisedValue := Value;
end;

//------------------------------

function TCOMJobBudget.Get_jbOriginalValuation: Double;
begin
  Result := FJobBudget.jbOriginalValuation;
end;

procedure TCOMJobBudget.Set_jbOriginalValuation(Value: Double);
begin
  FJobBudget.jbOriginalValuation := Value;
end;

//------------------------------

function TCOMJobBudget.Get_jbRevisedValuation: Double;
begin
  Result := FJobBudget.jbRevisedValuation;
end;

procedure TCOMJobBudget.Set_jbRevisedValuation(Value: Double);
begin
  FJobBudget.jbRevisedValuation := Value;
end;

//------------------------------

function TCOMJobBudget.Get_jbUplift: Double;
begin
  Result := FJobBudget.jbUplift;
end;

procedure TCOMJobBudget.Set_jbUplift(Value: Double);
begin
  FJobBudget.jbUplift := Value;
end;

//------------------------------

function TCOMJobBudget.Get_jbBudgetType: Integer;
begin
  Result := FJobBudget.jbBudgetType;
end;

procedure TCOMJobBudget.Set_jbBudgetType(Value: Integer);
begin
  FJobBudget.jbBudgetType := Value;
end;

//------------------------------

function TCOMJobBudget.Get_jbJobCode: WideString;
begin
  Result := FJobBudget.jbJobCode;
end;

procedure TCOMJobBudget.Set_jbJobCode(const Value: WideString);
begin
  FJobBudget.jbJobCode := Value;
end;

//------------------------------

function TCOMJobBudget.Get_jbStockCode: WideString;
begin
  Result := FJobBudget.jbStockCode;
end;

procedure TCOMJobBudget.Set_jbStockCode(const Value: WideString);
begin
  FJobBudget.jbStockCode := Value;
end;

//------------------------------

function TCOMJobBudget.Get_jbAnalysisCode: WideString;
begin
  Result := FJobBudget.jbAnalysisCode;
end;

procedure TCOMJobBudget.Set_jbAnalysisCode(const Value: WideString);
begin
  FJobBudget.jbAnalysisCode := Value;
end;

//------------------------------

function TCOMJobBudget.Get_jbRecharge: WordBool;
begin
  Result := FJobBudget.jbRecharge;
end;

procedure TCOMJobBudget.Set_jbRecharge(Value: WordBool);
begin
  FJobBudget.jbRecharge := Value;
end;

//------------------------------

function TCOMJobBudget.Get_jbCostOverhead: Double;
begin
  Result := FJobBudget.jbCostOverhead;
end;

procedure TCOMJobBudget.Set_jbCostOverhead(Value: Double);
begin
  FJobBudget.jbCostOverhead := Value;
end;

//------------------------------

function TCOMJobBudget.Get_jbOrigValuation: Double;
begin
  Result := (FJobBudget As TAbsJobBudget2).jbOrigValuation;
end;

procedure TCOMJobBudget.Set_jbOrigValuation(Value: Double);
begin
  (FJobBudget As TAbsJobBudget2).jbOrigValuation := Value;
end;

//------------------------------

function TCOMJobBudget.Get_jbRevValuation: Double;
begin
  Result := (FJobBudget As TAbsJobBudget2).jbRevValuation;
end;

procedure TCOMJobBudget.Set_jbRevValuation(Value: Double);
begin
  (FJobBudget As TAbsJobBudget2).jbRevValuation := Value;
end;

//------------------------------

function TCOMJobBudget.Get_jbValuationPercentage: Double;
begin
  Result := (FJobBudget As TAbsJobBudget2).jbValuationPercentage;
end;

procedure TCOMJobBudget.Set_jbValuationPercentage(Value: Double);
begin
  (FJobBudget As TAbsJobBudget2).jbValuationPercentage := Value;
end;

//------------------------------

function TCOMJobBudget.Get_jbValuationBasis: Integer;
begin
  Result := (FJobBudget As TAbsJobBudget2).jbValuationBasis;
end;

procedure TCOMJobBudget.Set_jbValuationBasis(Value: Integer);
begin
  (FJobBudget As TAbsJobBudget2).jbValuationBasis := Value;
end;

//=========================================================================

function TCOMJobBudget.Get_jbBudgetCurrency: Smallint;
begin
  Result := (FJobBudget As TAbsJobBudget3).jbBudgetCurrency;
end;

procedure TCOMJobBudget.Set_jbBudgetCurrency(Value: Smallint);
begin
  (FJobBudget As TAbsJobBudget3).jbBudgetCurrency := Value;
end;

end.
